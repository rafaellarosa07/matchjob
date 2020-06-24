package com.br.project.matchjob.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;
import org.springframework.web.cors.CorsConfiguration;

@Component
@ConfigurationProperties(
        prefix = "application-properties",
        ignoreUnknownFields = false
)
public class ApplicationProperties {

    private final CorsConfiguration cors = new CorsConfiguration();
    private final Swagger swagger = new Swagger();

    public ApplicationProperties() {
    }

    public CorsConfiguration getCors() {
        return this.cors;
    }

    public Swagger getSwagger() {
        return this.swagger;
    }

    public static class Swagger {
        private String title;
        private String description;
        private String version;
        private String termsOfServiceUrl;
        private String contact;
        private String license;
        private String licenseUrl;

        public Swagger() {
        }

        public String getTitle() {
            return this.title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public String getDescription() {
            return this.description;
        }

        public void setDescription(String description) {
            this.description = description;
        }

        public String getVersion() {
            return this.version;
        }

        public void setVersion(String version) {
            this.version = version;
        }

        public String getTermsOfServiceUrl() {
            return this.termsOfServiceUrl;
        }

        public void setTermsOfServiceUrl(String termsOfServiceUrl) {
            this.termsOfServiceUrl = termsOfServiceUrl;
        }

        public String getContact() {
            return this.contact;
        }

        public void setContact(String contact) {
            this.contact = contact;
        }

        public String getLicense() {
            return this.license;
        }

        public void setLicense(String license) {
            this.license = license;
        }

        public String getLicenseUrl() {
            return this.licenseUrl;
        }

        public void setLicenseUrl(String licenseUrl) {
            this.licenseUrl = licenseUrl;
        }
    }

}
