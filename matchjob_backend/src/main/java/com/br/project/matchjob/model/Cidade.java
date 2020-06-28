package com.br.project.matchjob.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "Cidade")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Cidade implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", unique = true, nullable = false)
    private Long id;

    @Column(name = "nome", length = 60)
    private String nome;

    @ManyToOne
    @JoinColumn(name = "fk_estado", nullable = false)
    private Estado estado;

}