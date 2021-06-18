# frozen_string_literal: true

class Memo
  def initialize
    @connection = PG.connect(dbname: 'memos')
  end

  def read_all_memos
    query = 'SELECT * FROM t_memos'
    @connection.exec(query)
  end

  def create(title, content)
    query = 'INSERT INTO t_memos (title, content) VALUES ($1, $2) RETURNING id'
    key = [title, content]
    @connection.exec(query, key).first
  end

  def read_a_memo(id)
    query = 'SELECT * FROM t_memos WHERE id = $1'
    key = [id]
    @connection.exec(query, key).first
  end

  def edit(title, content, id)
    query = 'UPDATE t_memos SET title = $1, content = $2 WHERE id = $3'
    key = [title, content, id]
    @connection.exec(query, key)
  end

  def delete(id)
    query = 'DELETE FROM t_memos WHERE id = $1'
    key = [id]
    @connection.exec(query, key)
  end
end
