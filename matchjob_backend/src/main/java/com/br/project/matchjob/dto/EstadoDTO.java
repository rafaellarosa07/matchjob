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
public class EstadoDTO implements Serializable {

    private Long id;
    private String nome;
    private String uf;

}