package com.br.project.matchjob.util;

import org.springframework.data.domain.Example;
import org.springframework.data.domain.Sort;
import org.springframework.data.repository.NoRepositoryBean;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.QueryByExampleExecutor;

import java.io.Serializable;
import java.util.List;

@NoRepositoryBean
public interface MatchJobRepository<T, ID extends Serializable> extends PagingAndSortingRepository<T, ID>, QueryByExampleExecutor<T> {

    public List<T> findAll();

    public List<T> findAll(Sort sort);

    public List<T> findAll(Iterable<ID> itrbl);

    public <S extends T> List<S> save(Iterable<S> itrbl);

    public void flush();

    public <S extends T> S saveAndFlush(S s);

    public void deleteInBatch(Iterable<T> itrbl);

    public void deleteAllInBatch();

    public T getOne(ID id);

    public <S extends T> List<S> findAll(Example<S> exmpl);

    public <S extends T> List<S> findAll(Example<S> exmpl, Sort sort);
}
