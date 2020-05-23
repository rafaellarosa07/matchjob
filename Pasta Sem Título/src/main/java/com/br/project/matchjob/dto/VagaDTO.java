package com.br.project.matchjob.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class VagaDTO implements Serializable {

    private Long id;
    private String nome;
    private String descricao;
    private String nomeEmpresa;
    private EnderecoDTO endereco;
    private String valor;
    private String email;
    private Long idUsuario;
    private List<CompetenciaDTO> competencias;

}
