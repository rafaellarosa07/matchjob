package com.br.project.matchjob.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "Competencia")
@Data
@NoArgsConstructor
@Builder
@AllArgsConstructor
public class Competencia implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false, length = 20)
    private Long id;

    @Column(name = "descricao", nullable = false, length = 80)
    private String descricao;

}
