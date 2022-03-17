# frozen_string_literal: true

class Memo
  def initialize
    @conn = PG.connect(dbname: 'memotest')
  end

  def all_memo
    @conn.exec('SELECT * FROM memo ORDER BY id')
  end

  def create_new_memo(title, comment)
    @conn.exec('INSERT INTO memo (title, comment) VALUES ($1, $2) RETURNING id', [title, comment]).first
  end

  def get_memo_detail(id)
    @conn.exec('SELECT * FROM memo WHERE id = $1', [id]).first
  end

  def update_memo(title, comment, id)
    @conn.exec('UPDATE memo SET title = $1, comment = $2 WHERE id = $3', [title, comment, id])
  end

  def delete_memo(id)
    @conn.exec('DELETE FROM memo WHERE id = $1', [id])
  end
end
