package com.br.project.matchjob.controller;

import com.br.project.matchjob.dto.Mensagem;
import com.br.project.matchjob.dto.VagaDTO;
import com.br.project.matchjob.exception.ResourceNotFoundException;
import com.br.project.matchjob.model.Usuario;
import com.br.project.matchjob.model.Vaga;
import com.br.project.matchjob.service.VagaService;
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
@Api(description = "Vaga")
public class VagaController {

    @Autowired
    private VagaService vagaService;

    @PostMapping(consumes = MediaType.APPLICATION_JSON_VALUE, value = "/vaga")
    @ApiOperation(value = "Inserir Vaga", consumes = MediaType.APPLICATION_JSON_VALUE)
    @ApiResponses(value = {@ApiResponse(code = 200, message = "Registro inserido com sucesso."),
            @ApiResponse(code = 400, message = "Dados incorretos"),
            @ApiResponse(code = 500, message = "Erro interno servidor")})
    public ResponseEntity<Mensagem> inserirVaga(@Valid @RequestBody VagaDTO vagaDTO) throws IOException {
        return vagaService.inserir(vagaDTO);
    }

    @PutMapping(value = "/vaga", consumes = MediaType.APPLICATION_JSON_VALUE)
    @ApiOperation(value = "Alterar Vaga", consumes = MediaType.APPLICATION_JSON_VALUE)
    @ApiResponses(value = {@ApiResponse(code = 200, message = "Execu��o realizada com sucesso"),
            @ApiResponse(code = 500, message = "Erro interno servidor")})
    public ResponseEntity<Mensagem> alterarVaga(@RequestBody VagaDTO vaga) throws IOException {
        return vagaService.alterar(vaga);

    }

    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE, value = "/vaga/listar/{idUsuario}")
    @ApiOperation(value = "Listar Vaga", produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
    @ApiResponses(value = {@ApiResponse(code = 200, message = "Execu��o realizada com sucesso"),
            @ApiResponse(code = 500, message = "Erro interno servidor")})
    public ResponseEntity<List<Vaga>> listarVaga(@PathVariable Long idUsuario) throws ResourceNotFoundException {
        return vagaService.listarTodasVagas(idUsuario);
    }

    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE, value = "/vaga/minhas-vagas-cadastradas/{idUsuario}")
    @ApiOperation(value = "Listar Minhas Vaga", produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
    @ApiResponses(value = {@ApiResponse(code = 200, message = "Execu��o realizada com sucesso"),
            @ApiResponse(code = 500, message = "Erro interno servidor")})
    public ResponseEntity<List<Vaga>> listarMinhasVagaCadastradas(@PathVariable Long idUsuario) throws ResourceNotFoundException {
        return vagaService.listarMinhasVagasCadastradas(idUsuario);
    }

    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE, value = "/vaga/minhas-vagas/{idUsuario}")
    @ApiOperation(value = "Listar Minhas Vaga", produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
    @ApiResponses(value = {@ApiResponse(code = 200, message = "Execu��o realizada com sucesso"),
            @ApiResponse(code = 500, message = "Erro interno servidor")})
    public ResponseEntity<List<Vaga>> listarMinhasVaga(@PathVariable Long idUsuario) throws ResourceNotFoundException {
        return vagaService.listarMinhasVagas(idUsuario);
    }

    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE, value = "/vaga/candidatos/{id:\\d+}")
    @ApiOperation(value = "Retorna candidatos da Vaga por Id", produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "id", value = "Identificador �nico da Vaga que ser� consultado.", required = true, dataType = "Integer", paramType = "path")})
    @ApiResponses(value = {@ApiResponse(code = 200, message = "Execu��o realizada com sucesso"),
            @ApiResponse(code = 500, message = "Erro interno servidor")})
    public ResponseEntity<List<Usuario>> consultarCandidatos(@PathVariable Long id) throws ResourceNotFoundException {
        return vagaService.consultarCandidatos(id);
    }

    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE, value = "/vaga{id:\\d+}")
    @ApiOperation(value = "Retorna Vaga por Id", produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "id", value = "Identificador �nico da Vaga que ser� consultado.", required = true, dataType = "Integer", paramType = "path")})
    @ApiResponses(value = {@ApiResponse(code = 200, message = "Execu��o realizada com sucesso"),
            @ApiResponse(code = 500, message = "Erro interno servidor")})
    public ResponseEntity<Vaga> buscaVagaById(@PathVariable Long id) throws ResourceNotFoundException {
        return vagaService.listarPorId(id);
    }

    @DeleteMapping(value = "/vaga/{id:\\d+}")
    @ApiOperation(value = "Excluir Produto", consumes = MediaType.APPLICATION_JSON_VALUE)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "id", value = "Identificador �nico de Vaga que ser� exclu�do.", required = true, dataType = "Integer", paramType = "path")})
    @ApiResponses(value = {@ApiResponse(code = 204, message = "Execu��o realizada com sucesso"),
            @ApiResponse(code = 500, message = "Erro interno servidor")})
    public ResponseEntity<Mensagem> excluirVaga(@PathVariable Long id) throws IOException {
        return vagaService.excluir(id);

    }
}
