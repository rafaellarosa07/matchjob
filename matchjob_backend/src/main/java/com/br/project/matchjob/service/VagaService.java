package com.br.project.matchjob.service;

import com.br.project.matchjob.dto.Mensagem;
import com.br.project.matchjob.dto.VagaDTO;
import com.br.project.matchjob.exception.ResourceNotFoundException;
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
public class VagaService extends ConvertModelToDTO {

    @Autowired
    private VagaRepository vagaRepository;

    @Autowired
    private PastaService pastaVagaService;

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private CidadeRepository cidadeRepository;

    private Mensagem mensagem;

    public ResponseEntity<Mensagem> inserir(VagaDTO vagaDTO) {
        try {
            Vaga vaga = new Vaga();
            vaga = preencherProduto(vagaDTO, vaga);
            vagaRepository.save(vaga);
            pastaVagaService.createDirectoryVaga(vaga.getId());
            mensagem = new Mensagem("Vaga Cadastrado com Sucesso!!", vaga.getId(), "success", true);
            return new ResponseEntity<Mensagem>(mensagem, HttpStatus.OK);
        } catch (Exception e) {
            mensagem = new Mensagem("Erro ao Cadastrar!", vagaDTO.getId(), "error", false);
            return new ResponseEntity<Mensagem>(mensagem, HttpStatus.OK);
        }
    }

    public ResponseEntity<Mensagem> alterar(VagaDTO vagaDTO) {
        try {
            Vaga vaga = new Vaga();
            vaga = vagaRepository.findById(vagaDTO.getId()).orElseThrow(() ->
                    new ResourceNotFoundException("Usuario não encontrado para o  id :: " + vagaDTO.getId()));
            ;
            vagaRepository.save(preencherProduto(vagaDTO, vaga));
            mensagem = new Mensagem("Vaga Alterado com Sucesso!!", vaga.getId(), "success", true);
            return new ResponseEntity<Mensagem>(mensagem, HttpStatus.OK);
        } catch (Exception e) {
            mensagem = new Mensagem("Erro ao Tentar Alterar", vagaDTO.getId(), "error", false);
            return new ResponseEntity<Mensagem>(mensagem, HttpStatus.OK);
        }
    }

    private Vaga preencherProduto(VagaDTO vagaDTO, Vaga vaga) {
        vaga.setDescricao(vagaDTO.getDescricao());
        vaga.setNome(vagaDTO.getNome());
        vaga.setDescricao(vagaDTO.getDescricao());
        vaga.setValor(vagaDTO.getValor());
        preencherEndereco(vagaDTO, vaga);
        vaga.setEmail(vagaDTO.getEmail());
        vaga.setNomeEmpresa(vagaDTO.getNomeEmpresa());
        vaga.setDataCadastro(new Date());
        vaga.setIdUsuario(vagaDTO.getIdUsuario());
        return vaga;
    }

    private void preencherEndereco(VagaDTO vagaDTO, Vaga vaga){
        Endereco endereco = new Endereco();
        endereco.setCidade(cidadeRepository.findById(vagaDTO.getEndereco().getIdCidade()).get());
        vaga.setEndereco(endereco);

    }


    public ResponseEntity<Mensagem> excluir(Long id) {

        try {
            Vaga vaga = vagaRepository.findById(id).orElseThrow(() ->
                    new ResourceNotFoundException("Vaga não encontrada para o  id :: " + id));

            removerVagaUsuario(vaga);
            vagaRepository.delete(vaga);
            mensagem = new Mensagem("Vaga Excluído com Sucesso!", id, "success", true);
            return new ResponseEntity<Mensagem>(mensagem, HttpStatus.OK);

        } catch (Exception e) {
            mensagem = new Mensagem("Erro ao tentar excluir", id, "error", false);
            return new ResponseEntity<Mensagem>(mensagem, HttpStatus.OK);
        }
    }


    private void removerVagaUsuario(Vaga vaga){
        List<Usuario> usuarios = usuarioRepository.findCandidaturasByIdVaga(vaga.getId());
        for (Usuario usuario :usuarios) {
            usuario.getVagas().remove(vaga);
            usuarioRepository.save(usuario);
        }
    }

    public ResponseEntity<List<Vaga>> listarTodasVagas(Long idUsuario) throws ResourceNotFoundException {
        Usuario usuario = usuarioRepository.findById(idUsuario).orElseThrow(() ->
                new ResourceNotFoundException("Usuario não encontrado para o  id :: " + idUsuario));
        List<Vaga> vagas = vagaRepository.findAll();
        vagas.removeAll(usuario.getVagas());
        if (ObjectUtils.isEmpty(vagas)) {
            return new ResponseEntity<List<Vaga>>(vagas, HttpStatus.NO_CONTENT);
        }
        return new ResponseEntity<List<Vaga>>(vagas, HttpStatus.OK);

    }

    public ResponseEntity<List<Vaga>> listarMinhasVagasCadastradas(Long idUsuario) throws ResourceNotFoundException {
        List<Vaga> vagas = vagaRepository.findByIdUsuario(idUsuario);
        if (ObjectUtils.isEmpty(vagas)) {
            return new ResponseEntity<List<Vaga>>(vagas, HttpStatus.NO_CONTENT);
        }
        return new ResponseEntity<List<Vaga>>(vagas, HttpStatus.OK);

    }

    public ResponseEntity<List<Vaga>> listarMinhasVagas(Long idUsuario) {
        List<Vaga> vagas = usuarioRepository.findById(idUsuario).get().getVagas();
        if (ObjectUtils.isEmpty(vagas)) {
            return new ResponseEntity<List<Vaga>>(vagas, HttpStatus.NO_CONTENT);
        }
        return new ResponseEntity<List<Vaga>>(vagas, HttpStatus.OK);

    }

    public ResponseEntity<List<Usuario>> consultarCandidatos(Long id) {
        return new ResponseEntity<List<Usuario>>(usuarioRepository.findCandidaturasByIdVaga(id), HttpStatus.OK);
    }

    public ResponseEntity<Vaga> listarPorId(Long id) throws ResourceNotFoundException {
        Vaga retorna = vagaRepository.findById(id).orElseThrow(() ->
                new ResourceNotFoundException("Vaga não encontrada para o  id :: " + id));
        ;
        ;
        if (ObjectUtils.isEmpty(retorna)) {
        }
        return new ResponseEntity<Vaga>(retorna, HttpStatus.OK);
    }
}
