package com.br.project.matchjob.controller;

import com.br.project.matchjob.exception.ResourceNotFoundException;
import com.br.project.matchjob.model.Cidade;
import com.br.project.matchjob.model.Estado;
import com.br.project.matchjob.service.EstadoService;
import io.swagger.annotations.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping()
@Api(description = "Estado")
public class EstadoController {

    @Autowired
    private EstadoService estadoService;

    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE, value = "/estado")
    @ApiOperation(value = "Listar Estados", produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
    @ApiResponses(value = {@ApiResponse(code = 200, message = "Execu��o realizada com sucesso"),
            @ApiResponse(code = 500, message = "Erro interno servidor")})
    public ResponseEntity<List<Estado>> listarEstado() throws ResourceNotFoundException {
        return estadoService.listarTodos();
    }

    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE, value = "/estado/{id}")
    @ApiOperation(value = "Retorna Estado por Id", produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "id", value = "Identificador �nico da Estado que ser� consultado.", required = true, dataType = "Integer", paramType = "path")})
    @ApiResponses(value = {@ApiResponse(code = 200, message = "Execu��o realizada com sucesso"),
            @ApiResponse(code = 500, message = "Erro interno servidor")})
    public ResponseEntity<Estado> buscaEstadoById(@PathVariable Long id) throws ResourceNotFoundException {
        return estadoService.listarPorId(id);
    }
}
