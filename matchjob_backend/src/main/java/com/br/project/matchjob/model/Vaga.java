package com.br.project.matchjob.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "Vaga")
@Data
@NoArgsConstructor
@Builder
@AllArgsConstructor
public class Vaga implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false, length = 20)
    private Long id;

    @Column(name = "nome", nullable = false, length = 80)
    private String nome;

    @Column(name = "descricao", nullable = false, length = 80)
    private String descricao;

    @Column(name = "valor", nullable = false, length = 80)
    private String valor;

    @Column(name = "data_cadastro", nullable = false, length = 80)
    private Date dataCadastro;

    @Column(name = "email", nullable = false, length = 80)
    private String email;

    @Column(name = "nome_empresa", nullable = false, length = 60)
    private String nomeEmpresa;

    @Column(name = "identificador_usuario", nullable = false, length = 80)
    private Long idUsuario;

    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "fk_endereco", nullable = false)
    private Endereco endereco;

    @ManyToMany
    @JoinTable(
            name = "vaga_competencia",
            joinColumns = @JoinColumn(name = "fk_vaga"),
            inverseJoinColumns = @JoinColumn(name = "fk_competencia"))
    private List<Competencia> competencias;
}
