package com.br.project.matchjob.controller;

import com.br.project.matchjob.dto.AutenticarDTO;
import com.br.project.matchjob.dto.Mensagem;
import com.br.project.matchjob.dto.UsuarioDTO;
import com.br.project.matchjob.exception.ResourceNotFoundException;
import com.br.project.matchjob.model.Usuario;
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
@Api(description = "Usuario")
public class UsuarioController {

    @Autowired
    private UsuarioService usuarioService;

    @PostMapping(consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE, value = "/usuario")
    @ApiOperation(value = "Inserir Usuario", consumes = MediaType.APPLICATION_JSON_VALUE)
    @ApiResponses(value = {@ApiResponse(code = 200, message = "Registro inserido com sucesso."),
            @ApiResponse(code = 400, message = "Dados incorretos"),
            @ApiResponse(code = 500, message = "Erro interno servidor")})
    public ResponseEntity<Usuario> inserirUsuario(@Valid @RequestBody UsuarioDTO usuarioDTO) throws IOException {
        return usuarioService.inserir(usuarioDTO);
    }

    @PutMapping(value = "/usuario", consumes = MediaType.APPLICATION_JSON_VALUE)
    @ApiOperation(value = "Alterar Usuario", consumes = MediaType.APPLICATION_JSON_VALUE)
    @ApiResponses(value = {@ApiResponse(code = 200, message = "Execu��o realizada com sucesso"),
            @ApiResponse(code = 500, message = "Erro interno servidor")})
    public ResponseEntity<Mensagem> alterarUsuario(@RequestBody UsuarioDTO produto) throws IOException {
        return usuarioService.alterar(produto);

    }

    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE, value = "/usuario")
    @ApiOperation(value = "Listar Usuarios", produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
    @ApiResponses(value = {@ApiResponse(code = 200, message = "Execu��o realizada com sucesso"),
            @ApiResponse(code = 500, message = "Erro interno servidor")})
    public ResponseEntity<List<Usuario>> listarUsuario() {
        return usuarioService.listarTodos();
    }

    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE, value = "/usuario/{id:\\d+}")
    @ApiOperation(value = "Retorna Usuario por Id", produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "id", value = "Identificador �nico da Usuario que ser� consultado.", required = true, dataType = "Integer", paramType = "path")})
    @ApiResponses(value = {@ApiResponse(code = 200, message = "Execu��o realizada com sucesso"),
            @ApiResponse(code = 500, message = "Erro interno servidor")})
    public ResponseEntity<Usuario> buscaUsuarioById(@PathVariable Long id) throws ResourceNotFoundException {
        return usuarioService.listarPorId(id);
    }

    @DeleteMapping(value = "/usuario/{id:\\d+}")
    @ApiOperation(value = "Excluir Produto", consumes = MediaType.APPLICATION_JSON_VALUE)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "id", value = "Identificador �nico de Usuario que ser� exclu�do.", required = true, dataType = "Integer", paramType = "path")})
    @ApiResponses(value = {@ApiResponse(code = 204, message = "Execu��o realizada com sucesso"),
            @ApiResponse(code = 500, message = "Erro interno servidor")})
    public ResponseEntity<Mensagem> excluirUsuario(@PathVariable Long id) throws IOException {
        return usuarioService.excluir(id);

    }


    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE, value = "/usuario/curriculo/{id}")
    @ApiOperation(value = "Curriculo", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @ApiResponses(value = {@ApiResponse(code = 200, message = "retornado"),
            @ApiResponse(code = 400, message = "Dados incorretos"),
            @ApiResponse(code = 500, message = "Erro interno servidor")})
    public void cadastrarCurriculo(@PathVariable Long id, @RequestParam("file") MultipartFile image) throws IOException {
        usuarioService.salvarCurriculo(id, image);
    }

    @GetMapping(produces = MediaType.APPLICATION_OCTET_STREAM_VALUE, value = "/usuario/curriculo/{id}")
    @ApiOperation(value = "Curriculo", produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
    @ApiResponses(value = {@ApiResponse(code = 200, message = "retornado"),
            @ApiResponse(code = 400, message = "Dados incorretos"),
            @ApiResponse(code = 500, message = "Erro interno servidor")})
    public byte[] buscarCurriculo(@PathVariable Long id) throws IOException {
        return usuarioService.buscarCurriculo(id);
    }

    @PostMapping(consumes = MediaType.APPLICATION_JSON_VALUE, value = "/usuario/autenticar")
    @ApiOperation(value = "Autenticar", consumes = MediaType.APPLICATION_JSON_VALUE)
    @ApiResponses(value = {@ApiResponse(code = 200, message = "retornado"),
            @ApiResponse(code = 400, message = "Dados incorretos"),
            @ApiResponse(code = 500, message = "Erro interno servidor")})
    public ResponseEntity<UsuarioDTO> autenticar(@Valid @RequestBody AutenticarDTO autenticarDTO) throws IOException {
        return usuarioService.autenticar(autenticarDTO);
    }


    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE, value = "/usuario/candidatar/{idVaga}/{idPessoa}")
    @ApiOperation(value = "Candidatar Usuario para vaga", produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "id", value = "Identificador �nico da Usuario que ser� consultado.", required = true, dataType = "Integer", paramType = "path")})
    @ApiResponses(value = {@ApiResponse(code = 200, message = "Execu��o realizada com sucesso"),
            @ApiResponse(code = 500, message = "Erro interno servidor")})
    public ResponseEntity<Mensagem> candidatar(@PathVariable Long idVaga, @PathVariable Long idPessoa) throws ResourceNotFoundException {
        return usuarioService.candidatar(idVaga, idPessoa);
    }

    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE, value = "/usuario/cancelar-candidatura/{idVaga}/{idPessoa}")
    @ApiOperation(value = "Cancelar candidatura Usuario para vaga", produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
    @ApiImplicitParams({
            @ApiImplicitParam(name = "id", value = "Identificador �nico da Usuario que ser� consultado.", required = true, dataType = "Integer", paramType = "path")})
    @ApiResponses(value = {@ApiResponse(code = 200, message = "Execu��o realizada com sucesso"),
            @ApiResponse(code = 500, message = "Erro interno servidor")})
    public ResponseEntity<Mensagem> cancelarCandidatura(@PathVariable Long idVaga, @PathVariable Long idPessoa) throws ResourceNotFoundException {
        return usuarioService.cancelarCandidatura(idVaga, idPessoa);
    }
}
