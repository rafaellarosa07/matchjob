package com.br.project.matchjob.controller;

import com.br.project.matchjob.dto.AutenticarDTO;
import com.br.project.matchjob.dto.Mensagem;
import com.br.project.matchjob.dto.UsuarioDTO;
import com.br.project.matchjob.exception.ResourceNotFoundException;
import com.br.project.matchjob.model.Cidade;
import com.br.project.matchjob.model.Usuario;
import com.br.project.matchjob.service.CidadeService;
import com.br.project.matchjob.service.UsuarioService;
import io.swagger.annotations.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.Valid;
import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping()
@Api(description = "Cidade")
public class CidadeController {

    @Autowired
    private CidadeService cidadeService;


    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE, value = "/cidade")
    @ApiOperation(value = "Listar Cidades", produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
    @ApiResponses(value = {@ApiResponse(code = 200, message = "Execu��o realizada com sucesso"),
            @ApiResponse(code = 500, message = "Erro interno servidor")})
    public ResponseEntity<List<Cidade>> listarCidade() throws ResourceNotFoundException {
        return cidadeService.listarTodos();
    }

    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE, value = "/cidade/{id}")
    @ApiOperation(value = "Retorna Cidade por Id", produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "id", value = "Identificador �nico da Cidade que ser� consultado.", required = true, dataType = "Integer", paramType = "path")})
    @ApiResponses(value = {@ApiResponse(code = 200, message = "Execu��o realizada com sucesso"),
            @ApiResponse(code = 500, message = "Erro interno servidor")})
    public ResponseEntity<Cidade> buscaCidadeById(@PathVariable Long id) throws ResourceNotFoundException {
        return cidadeService.listarPorId(id);
    }

    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE, value = "/cidade/estado/{id}")
    @ApiOperation(value = "Retorna Cidade por Id do Estado", produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "id", value = "Identificador �nico da Cidade que ser� consultado.", required = true, dataType = "Integer", paramType = "path")})
    @ApiResponses(value = {@ApiResponse(code = 200, message = "Execu��o realizada com sucesso"),
            @ApiResponse(code = 500, message = "Erro interno servidor")})
    public ResponseEntity<List<Cidade>> buscaCidadeByEstadoId(@PathVariable Long id) throws ResourceNotFoundException {
        return cidadeService.listarPorEstadoId(id);
    }
}
