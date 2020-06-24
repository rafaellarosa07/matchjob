package com.br.project.matchjob.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CompetenciaDTO implements Serializable {

    private Long id;
    private String descricao;

}
