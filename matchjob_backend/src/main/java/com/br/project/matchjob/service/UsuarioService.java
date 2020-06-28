package com.br.project.matchjob.service;

import com.br.project.matchjob.dto.AutenticarDTO;
import com.br.project.matchjob.dto.EnderecoDTO;
import com.br.project.matchjob.dto.Mensagem;
import com.br.project.matchjob.dto.UsuarioDTO;
import com.br.project.matchjob.exception.ResourceNotFoundException;
import com.br.project.matchjob.model.Endereco;
import com.br.project.matchjob.model.Usuario;
import com.br.project.matchjob.model.Vaga;
import com.br.project.matchjob.repository.UsuarioRepository;
import com.br.project.matchjob.repository.VagaRepository;
import com.br.project.matchjob.util.ConvertModelToDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@Service
public class UsuarioService extends ConvertModelToDTO {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private VagaRepository vagaRepository;

    @Autowired
    private PastaService pastaService;

    private Mensagem mensagem;


    public ResponseEntity<Usuario> inserir(UsuarioDTO usuarioDTO) {
        try {
            Usuario usuario = super.toModel(usuarioDTO, Usuario.class);
            tratamentoCnpjCpf(usuario, usuarioDTO);
            usuarioRepository.save(usuario);
            pastaService.createDirectoryUser(usuario.getId());
            mensagem = new Mensagem("Usuario Cadastrado com Sucesso!!", usuario.getId(), "success", true);
            return new ResponseEntity<Usuario>(usuario, HttpStatus.OK);
        } catch (Exception e) {
            mensagem = new Mensagem("Erro ao Cadastrar!", usuarioDTO.getId(), "error", false);
            return new ResponseEntity<Usuario>(new Usuario(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    public ResponseEntity<Mensagem> alterar(UsuarioDTO usuarioDTO) {
        try {
            Usuario usuario = usuarioRepository.findById(usuarioDTO.getId()).orElseThrow(() ->
                    new ResourceNotFoundException("Usuario não encontrado para o  id :: " + usuarioDTO.getId()));
            usuarioRepository.save(preencherUsuario(usuarioDTO, usuario));
            mensagem = new Mensagem("Usuario Alterado com Sucesso!!", usuario.getId(), "success", true);
            return new ResponseEntity<Mensagem>(mensagem, HttpStatus.OK);
        } catch (Exception e) {
            mensagem = new Mensagem("Erro ao Tentar Alterar", usuarioDTO.getId(), "error", false);
            return new ResponseEntity<Mensagem>(mensagem, HttpStatus.OK);
        }
    }

    private void tratamentoCnpjCpf(Usuario usuario, UsuarioDTO usuarioDTO) {
        if (usuarioDTO.getCpfCnpj().length() == 18) {
            usuario.setCnpj(usuarioDTO.getCpfCnpj());
        } else if (usuarioDTO.getCpfCnpj().length() == 11) {
            usuario.setCpf(usuarioDTO.getCpfCnpj());
        }
    }

    private Usuario preencherUsuario(UsuarioDTO usuarioDTO, Usuario usuario) {
        tratamentoCnpjCpf(usuario, usuarioDTO);
        usuario.setEmail(usuarioDTO.getEmail());
        usuario.setNome(usuarioDTO.getNome());
        usuario.setTipoPessoa(usuarioDTO.getTipoPessoa());
        usuario.setSenha(usuarioDTO.getSenha());
        return usuario;
    }

    public ResponseEntity<Mensagem> excluir(Long id) {

        try {
            Usuario usuario = usuarioRepository.findById(id).orElseThrow(() ->
                    new ResourceNotFoundException("Usuario não encontrado para o  id :: " + id));
            usuarioRepository.delete(usuario);
            mensagem = new Mensagem("Usuario Excluído com Sucesso!", id, "success", true);
            return new ResponseEntity<Mensagem>(mensagem, HttpStatus.OK);

        } catch (Exception e) {
            mensagem = new Mensagem("Erro ao tentar excluir", id, "error", false);
            return new ResponseEntity<Mensagem>(mensagem, HttpStatus.OK);
        }
    }

    public ResponseEntity<UsuarioDTO> autenticar(AutenticarDTO autenticarDTO) {

        Usuario usuario = usuarioRepository.findByEmailAndSenha(autenticarDTO.getEmail(), autenticarDTO.getSenha());
        if (Objects.nonNull(usuario)) {
            UsuarioDTO usuarioDTO = super.toDTO(usuario, UsuarioDTO.class);
            return new ResponseEntity<UsuarioDTO>(usuarioDTO, HttpStatus.OK);
        }
        return null;
    }

    public void salvarCurriculo(Long id, MultipartFile file) {
        pastaService.writeFiles(id, file);
    }

    public byte[] buscarCurriculo(Long id) {
        return pastaService.buscarFile(id);
    }

    public ResponseEntity<List<Usuario>> listarTodos() {

        List<Usuario> usuarios = usuarioRepository.findAll();
        if (ObjectUtils.isEmpty(usuarios)) {
            return new ResponseEntity<List<Usuario>>(usuarios, HttpStatus.NO_CONTENT);
        }
        return new ResponseEntity<List<Usuario>>(usuarios, HttpStatus.OK);

    }

    public ResponseEntity<Usuario> listarPorId(Long id) throws ResourceNotFoundException {
        Usuario retorna = usuarioRepository.findById(id).orElseThrow(() ->
                new ResourceNotFoundException("Usuario não encontrado para o  id :: " + id));
        ;
        ;
        if (ObjectUtils.isEmpty(retorna)) {
        }
        return new ResponseEntity<Usuario>(retorna, HttpStatus.OK);
    }


    public ResponseEntity<Mensagem> candidatar(Long idVaga, Long idPessoa) throws ResourceNotFoundException {
        Usuario usuario = usuarioRepository.findById(idPessoa).orElseThrow(() ->
                new ResourceNotFoundException("Usuario não encontrado para o  id :: " + idPessoa));
        if (usuario.getVagas() == null) {
            usuario.setVagas(new ArrayList<Vaga>());
        }
        usuario.getVagas().add(vagaRepository.findById(idVaga).orElseThrow(() ->
                new ResourceNotFoundException("Vaga não encontrado para o  id :: " + idVaga)));
        usuarioRepository.save(usuario);
        mensagem = new Mensagem("Candidatura realizada com Sucesso!", idPessoa, "success", true);
        return new ResponseEntity<Mensagem>(mensagem, HttpStatus.OK);
    }

    public ResponseEntity<Mensagem> cancelarCandidatura(Long idVaga, Long idPessoa) throws ResourceNotFoundException {
        Usuario usuario = usuarioRepository.findById(idPessoa).orElseThrow(() ->
                new ResourceNotFoundException("Usuario não encontrado para o  id :: " + idPessoa));
        usuario.getVagas().remove(vagaRepository.findById(idVaga).orElseThrow(() ->
                new ResourceNotFoundException("Vaga não encontrado para o  id :: " + idVaga)));
        usuarioRepository.save(usuario);
        mensagem = new Mensagem("Candidatura realizada com Sucesso!", idPessoa, "success", true);
        return new ResponseEntity<Mensagem>(mensagem, HttpStatus.OK);
    }
}
