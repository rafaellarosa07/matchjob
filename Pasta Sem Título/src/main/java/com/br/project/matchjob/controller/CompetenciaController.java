package com.br.project.matchjob.controller;

import com.br.project.matchjob.dto.CompetenciaDTO;
import com.br.project.matchjob.dto.Mensagem;
import com.br.project.matchjob.exception.ResourceNotFoundException;
import com.br.project.matchjob.model.Competencia;
import com.br.project.matchjob.service.CompetenciaService;
import io.swagger.annotations.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping()
@Api(description = "Competencia")
public class CompetenciaController {

    @Autowired
    private CompetenciaService competenciaService;

    @PostMapping(consumes = MediaType.APPLICATION_JSON_VALUE, value = "/competencia")
    @ApiOperation(value = "Inserir Competencia", consumes = MediaType.APPLICATION_JSON_VALUE)
    @ApiResponses(value = { @ApiResponse(code = 200, message = "Registro inserido com sucesso."),
            @ApiResponse(code = 400, message = "Dados incorretos"),
            @ApiResponse(code = 500, message = "Erro interno servidor") })
    public ResponseEntity<Mensagem> inserirCompetencia(@Valid @RequestBody CompetenciaDTO competenciaDTO) throws IOException {
        return competenciaService.inserir(competenciaDTO);
    }

    @PutMapping(value = "/competencia", consumes = MediaType.APPLICATION_JSON_VALUE)
    @ApiOperation(value = "Alterar Competencia", consumes = MediaType.APPLICATION_JSON_VALUE)
    @ApiResponses(value = { @ApiResponse(code = 200, message = "Execu��o realizada com sucesso"),
            @ApiResponse(code = 500, message = "Erro interno servidor") })
    public ResponseEntity<Mensagem>  alterarCompetencia(@RequestBody CompetenciaDTO competenciaDTO) throws IOException {
        return competenciaService.alterar(competenciaDTO);

    }

    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE, value = "/competencia")
    @ApiOperation(value = "Listar Competencias", produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
    @ApiResponses(value = { @ApiResponse(code = 200, message = "Execu��o realizada com sucesso"),
            @ApiResponse(code = 500, message = "Erro interno servidor") })
    public ResponseEntity<List<Competencia>> listarCompetencia() {
        return competenciaService.listarTodos();
    }

    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE, value = "/competencia/{id:\\d+}")
    @ApiOperation(value = "Retorna Competencia por Id", produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "id", value = "Identificador �nico da Competencia que ser� consultado.", required = true, dataType = "Integer", paramType = "path") })
    @ApiResponses(value = { @ApiResponse(code = 200, message = "Execu��o realizada com sucesso"),
            @ApiResponse(code = 500, message = "Erro interno servidor") })
    public ResponseEntity<Competencia> buscaCompetenciaById(@PathVariable Long id) throws ResourceNotFoundException {
        return competenciaService.listarPorId(id);
    }

    @DeleteMapping(value = "/competencia/{id:\\d+}")
    @ApiOperation(value = "Excluir Produto", consumes = MediaType.APPLICATION_JSON_VALUE)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "id", value = "Identificador �nico de Competencia que ser� exclu�do.", required = true, dataType = "Integer", paramType = "path") })
    @ApiResponses(value = { @ApiResponse(code = 204, message = "Execu��o realizada com sucesso"),
            @ApiResponse(code = 500, message = "Erro interno servidor") })
    public ResponseEntity<Mensagem>  excluirCompetencia(@PathVariable Long id) throws IOException {
        return competenciaService.excluir(id);

    }
}
