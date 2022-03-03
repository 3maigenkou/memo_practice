class Memo
  def initialize
    @conn = PG.connect(dbname: 'memotest')
  end

  def all_memo
    @conn.exec('SELECT * FROM memo ORDER BY id')
  end

  def create_new_memo(title, comment)
    @conn.exec("INSERT INTO memo (title, comment) VALUES ('#{title}', '#{comment}') RETURNING id").first
  end

  def get_memo_detail(id)
    @conn.exec("SELECT * FROM memo WHERE id = '#{id}'").first
  end

  def update_memo(title, comment, id)
    @conn.exec("UPDATE memo SET title = '#{title}', comment = '#{comment}' WHERE id ='#{id}'")
  end

  def delete_memo(id)
    @conn.exec("DELETE FROM memo WHERE id ='#{id}'")
  end
end
