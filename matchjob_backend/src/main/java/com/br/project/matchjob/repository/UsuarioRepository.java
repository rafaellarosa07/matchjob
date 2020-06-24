package com.br.project.matchjob.repository;


import com.br.project.matchjob.model.Usuario;
import com.br.project.matchjob.model.Vaga;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import javax.websocket.server.PathParam;
import java.util.List;

public interface UsuarioRepository extends JpaRepository<Usuario, Long> {

    Usuario findByEmailAndSenha(String email, String senha);

    @Query(value = "SELECT u.* FROM usuario u inner join usuario_vaga uv on uv.fk_usuario = u.id where uv.fk_vaga = :id", nativeQuery = true)
    List<Usuario> findCandidaturasByIdVaga(@PathParam("id") Long id);
}
