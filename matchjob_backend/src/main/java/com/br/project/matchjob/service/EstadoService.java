package com.br.project.matchjob.service;

import com.br.project.matchjob.dto.Mensagem;
import com.br.project.matchjob.exception.ResourceNotFoundException;
import com.br.project.matchjob.model.Cidade;
import com.br.project.matchjob.model.Estado;
import com.br.project.matchjob.repository.EstadoRepository;
import com.br.project.matchjob.util.ConvertModelToDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;

import java.util.List;

@Service
public class EstadoService extends ConvertModelToDTO {

    @Autowired
    private EstadoRepository estadoRepository;

    private Mensagem mensagem;

    public ResponseEntity<List<Estado>>listarTodos() throws ResourceNotFoundException {
        List<Estado> estados = estadoRepository.findAll();
        if (ObjectUtils.isEmpty(estados)) {
            return new ResponseEntity<List<Estado>>(estados, HttpStatus.NO_CONTENT);
        }
        return new ResponseEntity<List<Estado>>(estados, HttpStatus.OK);
    }


    public ResponseEntity<Estado> listarPorId(Long id) throws ResourceNotFoundException {
        Estado retorna = estadoRepository.findById(id).orElseThrow(() ->
                new ResourceNotFoundException("Estado não encontrada para o  id :: " + id));
        ;
        ;
        if (ObjectUtils.isEmpty(retorna)) {
        }
        return new ResponseEntity<Estado>(retorna, HttpStatus.OK);
    }
}
