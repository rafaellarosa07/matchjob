package com.br.project.matchjob.config;

import com.google.common.base.Predicate;
import com.google.common.base.Predicates;
import com.google.common.collect.Lists;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.RequestMethod;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.ResponseMessageBuilder;
import springfox.documentation.schema.ModelRef;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.service.ResponseMessage;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

import java.time.*;

@Configuration
@EnableSwagger2
public class SwaggerConfig {

    @Autowired
    private ApplicationProperties applicationProperties;

    public SwaggerConfig() {
    }

    @Bean
    public Docket swaggerSpringMvcPlugin() {
        Docket docket = (new Docket(DocumentationType.SWAGGER_12)).groupName("api-negocio").select().paths(this.paths()).build().apiInfo(this.apiInfo());
        this.makeDirectModelSubstitute(docket);
        this.makeGlobalResponseMessage(docket);
        return docket;
    }

    private void makeGlobalResponseMessage(Docket docket) {
        docket.globalResponseMessage(RequestMethod.POST, Lists.newArrayList(new ResponseMessage[]{(new ResponseMessageBuilder()).code(HttpStatus.UNPROCESSABLE_ENTITY.value()).message("Erro de Validação.").responseModel(new ModelRef("ValidationError")).build(), (new ResponseMessageBuilder()).code(HttpStatus.BAD_REQUEST.value()).message("Erro de negócio.").responseModel(new ModelRef("ExceptionInfo")).build()}));
    }

    private void makeDirectModelSubstitute(Docket docket) {
        docket.directModelSubstitute(LocalDate.class, String.class).directModelSubstitute(OffsetDateTime.class, String.class).directModelSubstitute(ZonedDateTime.class, String.class).directModelSubstitute(LocalDate.class, String.class).directModelSubstitute(Instant.class, String.class).directModelSubstitute(LocalDateTime.class, String.class).directModelSubstitute(Duration.class, String.class).directModelSubstitute(LocalTime.class, String.class).directModelSubstitute(MonthDay.class, String.class).directModelSubstitute(OffsetDateTime.class, String.class).directModelSubstitute(OffsetTime.class, String.class).directModelSubstitute(Period.class, String.class).directModelSubstitute(Year.class, String.class).directModelSubstitute(YearMonth.class, String.class);
    }

    private Predicate<String> paths() {
        return Predicates.or(new Predicate[]{PathSelectors.regex("/.*")});
    }

    private ApiInfo apiInfo() {
        return new ApiInfo(this.applicationProperties.getSwagger().getTitle(), this.applicationProperties.getSwagger().getDescription(), this.applicationProperties.getSwagger().getVersion(), this.applicationProperties.getSwagger().getTermsOfServiceUrl(), this.applicationProperties.getSwagger().getContact(), this.applicationProperties.getSwagger().getLicense(), this.applicationProperties.getSwagger().getLicenseUrl());
    }
}
