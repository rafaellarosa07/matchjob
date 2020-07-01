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
@Table(name = "Usuario")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Usuario implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", unique = true, nullable = false)
    private Long id;

    @Column(name = "nome", nullable = false, length = 60)
    private String nome;

    @Column(name = "cpf", length = 11)
    private String cpf;

    @Column(name = "cnpj", length = 18)
    private String cnpj;

    @Column(name = "tipo_pessoa")
    private char tipoPessoa;

    @Column(name = "email", length = 90)
    private String email;

    @Column(name = "senha", length = 40)
    private String senha;

    @ManyToMany()
    @JoinTable(
            name = "usuario_vaga",
            joinColumns = @JoinColumn(name = "fk_usuario"),
            inverseJoinColumns = @JoinColumn(name = "fk_vaga"))
    private List<Vaga> vagas;

}