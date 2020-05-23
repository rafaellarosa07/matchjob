package com.br.project.matchjob.dto;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UsuarioDTO implements Serializable {

    private Long id;
    private String nome;
    private String cpf;
    private String cnpj;
    private String cpfCnpj;
    private char tipoPessoa;
    private String email;
    private String senha;
    private EnderecoDTO endereco;

}