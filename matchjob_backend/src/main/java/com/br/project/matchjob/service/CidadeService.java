package com.br.project.matchjob.service;

import com.br.project.matchjob.dto.Mensagem;
import com.br.project.matchjob.dto.VagaDTO;
import com.br.project.matchjob.exception.ResourceNotFoundException;
import com.br.project.matchjob.model.Cidade;
import com.br.project.matchjob.model.Endereco;
import com.br.project.matchjob.model.Usuario;
import com.br.project.matchjob.model.Vaga;
import com.br.project.matchjob.repository.CidadeRepository;
import com.br.project.matchjob.repository.UsuarioRepository;
import com.br.project.matchjob.repository.VagaRepository;
import com.br.project.matchjob.util.ConvertModelToDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;

import java.util.Date;
import java.util.List;

@Service
public class CidadeService extends ConvertModelToDTO {

    @Autowired
    private CidadeRepository cidadeRepository;

    private Mensagem mensagem;

    public ResponseEntity<List<Cidade>> listarTodos() throws ResourceNotFoundException {
        List<Cidade> cidades = cidadeRepository.findAll();
        if (ObjectUtils.isEmpty(cidades)) {
            return new ResponseEntity<List<Cidade>>(cidades, HttpStatus.NO_CONTENT);
        }
        return new ResponseEntity<List<Cidade>>(cidades, HttpStatus.OK);
    }


    public ResponseEntity<Cidade> listarPorId(Long id) throws ResourceNotFoundException {
        Cidade retorna = cidadeRepository.findById(id).orElseThrow(() ->
                new ResourceNotFoundException("Cidade não encontrada para o  id :: " + id));
        ;
        ;
        if (ObjectUtils.isEmpty(retorna)) {
        }
        return new ResponseEntity<Cidade>(retorna, HttpStatus.OK);
    }


    public ResponseEntity<List<Cidade>> listarPorEstadoId(Long id) throws ResourceNotFoundException {
        List<Cidade> cidades = cidadeRepository.findByEstadoId(id);
        if (ObjectUtils.isEmpty(cidades)) {
            return new ResponseEntity<List<Cidade>>(cidades, HttpStatus.NO_CONTENT);
        }
        return new ResponseEntity<List<Cidade>>(cidades, HttpStatus.OK);
    }
}
