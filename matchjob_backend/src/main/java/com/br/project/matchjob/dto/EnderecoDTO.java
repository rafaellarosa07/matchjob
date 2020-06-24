package com.br.project.matchjob.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class EnderecoDTO implements Serializable {

    private Long id;
    private String cep;
    private String latitude;
    private String longitude;
}