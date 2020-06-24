package com.br.project.matchjob.service;

import com.br.project.matchjob.dto.CompetenciaDTO;
import com.br.project.matchjob.dto.Mensagem;
import com.br.project.matchjob.exception.ResourceNotFoundException;
import com.br.project.matchjob.model.Competencia;
import com.br.project.matchjob.repository.CompetenciaRepository;
import com.br.project.matchjob.util.ConvertModelToDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;

import java.util.List;

@Service
public class CompetenciaService extends ConvertModelToDTO {

    @Autowired
    private CompetenciaRepository competenciaRepository;

    private Mensagem mensagem;


    public ResponseEntity<Mensagem> inserir(CompetenciaDTO produtoDTO) {
        try {
            Competencia competencia = super.toModel(produtoDTO, Competencia.class);
            competenciaRepository.save(competencia);
            mensagem = new Mensagem("Competencia Cadastrada com Sucesso!!", competencia.getId(), "success", true);
            return new ResponseEntity<Mensagem>(mensagem, HttpStatus.OK);
        } catch (Exception e) {
            mensagem = new Mensagem("Erro ao Cadastrar!", produtoDTO.getId(), "error", false);
            return new ResponseEntity<Mensagem>(mensagem, HttpStatus.OK);
        }
    }

    public ResponseEntity<Mensagem> alterar(CompetenciaDTO competenciaDTO) {
        try {
            Competencia competencia = competenciaRepository.findById(competenciaDTO.getId()).orElseThrow(() ->
                    new ResourceNotFoundException("Competencia não encontrada para o  id :: " + competenciaDTO.getId()));
            competenciaRepository.save(preencherProduto(competenciaDTO, competencia));
            mensagem = new Mensagem("Competencia Alterada com Sucesso!!", competencia.getId(), "success", true);
            return new ResponseEntity<Mensagem>(mensagem, HttpStatus.OK);
        } catch (Exception e) {
            mensagem = new Mensagem("Erro ao Tentar Alterar", competenciaDTO.getId(), "error", false);
            return new ResponseEntity<Mensagem>(mensagem, HttpStatus.OK);
        }
    }

    private Competencia preencherProduto(CompetenciaDTO competenciaDTO, Competencia competencia) {
        competencia.setDescricao(competenciaDTO.getDescricao());
        return competencia;
    }

    public ResponseEntity<Mensagem> excluir(Long id) {

        try {
            Competencia competencia = competenciaRepository.findById(id).orElseThrow(() ->
                    new ResourceNotFoundException("Competencia não encontrada para o  id :: " + id));
            competenciaRepository.delete(competencia);
            mensagem = new Mensagem("Competencia Excluída com Sucesso!", id, "success", true);
            return new ResponseEntity<Mensagem>(mensagem, HttpStatus.OK);

        } catch (Exception e) {
            mensagem = new Mensagem("Erro ao tentar excluir", id, "error", false);
            return new ResponseEntity<Mensagem>(mensagem, HttpStatus.OK);
        }
    }

    public ResponseEntity<List<Competencia>> listarTodos() {

        List<Competencia> produtos = competenciaRepository.findAll();
        if (ObjectUtils.isEmpty(produtos)) {
            return new ResponseEntity<List<Competencia>>(produtos, HttpStatus.NO_CONTENT);
        }
        return new ResponseEntity<List<Competencia>>(produtos, HttpStatus.OK);

    }

    public ResponseEntity<Competencia> listarPorId(Long id) throws ResourceNotFoundException {
        Competencia retorna = competenciaRepository.findById(id).orElseThrow(() ->
                new ResourceNotFoundException("Competencia não encontrada para o  id :: " + id));
        if (ObjectUtils.isEmpty(retorna)) {
        }
        return new ResponseEntity<Competencia>(retorna, HttpStatus.OK);
    }
}
