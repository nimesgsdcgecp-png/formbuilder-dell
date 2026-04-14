package com.sttl.formbuilder2.ai.controller;

import com.sttl.formbuilder2.ai.service.AiArchitectService;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

/**
 * AiArchitectController — Dedicated API Controller for AI features.
 * 
 * Separated from core business controllers by the '.ai' package prefix.
 */
@RestController
@RequestMapping("/api/ai")
@RequiredArgsConstructor
@Slf4j
public class AiArchitectController {

    private final AiArchitectService aiArchitectService;

    @PostMapping("/chat")
    public ResponseEntity<String> chat(@RequestBody ChatRequest request) {
        log.info("AI Chat request received in specialized AI package.");
        
        try {
            String response = aiArchitectService.chat(request.getPrompt(), request.getHistory());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("AI Controller Failure", e);
            return ResponseEntity.internalServerError().body("Error processing AI request.");
        }
    }

    @Data
    public static class ChatRequest {
        private String prompt;
        private String history;
    }
}
