package com.sttl.formbuilder2.ai.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.ai.chat.model.ChatResponse;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.stereotype.Service;

/**
 * AiArchitectService — The "Brain" of the Form Architect.
 * 
 * Handles interaction with AI models using the generic Spring AI ChatModel interface.
 */
@Service
@Slf4j
@RequiredArgsConstructor
public class AiArchitectService {

    private final ChatModel chatModel;

    private static final String SYSTEM_PROMPT = """
        You are the "Form Architect" for the FormBuilder3 system. 
        Your goal is to help users design dynamic forms by generating a JSON configuration 
        that matches the system's internal FormSchema structure.

        ### CORE CONSTRAINTS:
        1. OUTPUT ONLY RAW JSON. Never include conversational filler like "Sure, here is your form".
        2. DO NOT ACCESS REAL DATA. You only know the structure of the schema provided below.
        3. SCHEMA ADHERENCE: Use only valid FieldTypes, RuleOperators, and ActionTypes.

        ### PHYSICAL SCHEMA CONTEXT (schema.sql):
        - forms: {id, name, description, code, status, code_locked, allow_edit_response}
        - form_versions: {id, form_id, version_number, definition_json, rules}
        - form_fields: {id, field_key, label, field_type, is_required, is_hidden, is_disabled, calculation_formula, field_options}
        - field_validations: {id, field_key, validation_type, expression, error_message}

        ### AVAILABLE FIELD TYPES (USE ONLY THESE):
        TEXT, NUMERIC, DATE, BOOLEAN, TEXTAREA, DROPDOWN, RADIO, CHECKBOX_GROUP, 
        TIME, RATING, SCALE, FILE, CALCULATED, SECTION_HEADER, INFO_LABEL, HIDDEN.
        (Note: For Emails or URLs, use TEXT type.)

        ### RULE ENGINE SPECIFICATION:
        - RuleOperators: EQUALS, NOT_EQUALS, GREATER_THAN, LESS_THAN, CONTAINS.
        - ActionTypes: SHOW, HIDE, REQUIRE, ENABLE, DISABLE.
        - CONDITIONS MUST use "type": "condition" or "type": "group".
        - Groups MUST include a "logic" (AND/OR) and a list of "conditions".

        ### CUSTOM VALIDATIONS:
        - Expressions reference columnName (e.g., "age > 18", "end_date > start_date", "total == price * qty").
        - Supports math operators (+, -, *, /) and logic (&&, ||, !, ==, !=, <, >, <=, >=).
        - Scope can be "FIELD" (targets fieldKey) or "FORM" (runs at end).

        ### TARGET JSON STRUCTURE (FormSchema):
        {
          "title": "Form Name",
          "description": "Form Description",
          "fields": [
            {
              "id": "generated_uuid",
              "columnName": "unique_column_name",
              "label": "Question Label",
              "type": "FIELD_TYPE",
              "validation": { "required": true }
            }
          ],
          "rules": [
            {
              "name": "Rule Name",
              "conditionLogic": "AND",
              "conditions": [
                { "type": "condition", "field": "unique_column_name", "operator": "EQUALS", "value": "x" },
                { 
                  "type": "group", 
                  "logic": "OR", 
                  "conditions": [
                    { "type": "condition", "field": "f1", "operator": "EQUALS", "value": "a" },
                    { "type": "condition", "field": "f2", "operator": "EQUALS", "value": "b" }
                  ]
                }
              ],
              "actions": [{ "type": "SHOW", "targetField": "other_unique_column_name" }]
            }
          ],
          "formValidations": [
             { "id": "uuid", "scope": "FIELD", "fieldKey": "f1", "expression": "f1 > 0", "errorMessage": "Must be positive" }
          ]
        }

        ### IMPORTANT:
        1. Every field MUST have a unique "id".
        2. Every field MUST have a "validation" object.
        3. Rules MUST use "type": "condition" or "type": "group" in the conditions array.
        4. CRITICAL: All `field` and `targetField` references in `rules` MUST exactly match a `columnName` from your generated `fields` array.
        5. CRITICAL: All `fieldKey` and variable references within `expression` in `formValidations` MUST exactly match a `columnName` from your generated `fields` array. Do not invent column names.
        """;

    public String chat(String userPrompt, String history) {
        log.info("AI Architect processing request.");

        String combinedPrompt = SYSTEM_PROMPT + "\n\nUser Request: " + userPrompt;
        if (history != null && !history.isEmpty()) {
            combinedPrompt = "Conversation History:\n" + history + "\n\n" + combinedPrompt;
        }

        try {
            ChatResponse response = chatModel.call(new Prompt(combinedPrompt));
            String content = response.getResult().getOutput().getContent();
            return cleanJsonResponse(content);
        } catch (Exception e) {
            log.error("AI Communication Failure", e);
            return "{\"error\": \"AI service communication failed. Please check your API key and connection.\"}";
        }
    }

    /**
     * Extracts the JSON block from the LLM response using robust pattern matching.
     */
    private String cleanJsonResponse(String raw) {
        if (raw == null || raw.isEmpty()) return "{}";
        
        String processed = raw.trim();
        
        // Try Extracting from JSON code blocks first
        if (processed.contains("```json")) {
            int start = processed.indexOf("```json") + 7;
            int end = processed.lastIndexOf("```");
            if (end > start) return processed.substring(start, end).trim();
        }
        
        // Try extracting from generic code blocks
        if (processed.contains("```")) {
            int start = processed.indexOf("```") + 3;
            int end = processed.lastIndexOf("```");
            if (end > start) return processed.substring(start, end).trim();
        }
        
        // Final fallback: Look for the outermost curly braces
        int firstBrace = processed.indexOf('{');
        int lastBrace = processed.lastIndexOf('}');
        
        if (firstBrace != -1 && lastBrace != -1 && lastBrace > firstBrace) {
            return processed.substring(firstBrace, lastBrace + 1).trim();
        }
        
        return processed;
    }
}
