package com.br.project.matchjob.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.io.Serializable;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CidadeDTO implements Serializable {

    private Long id;
    private String nome;
    private EstadoDTO estado;

}