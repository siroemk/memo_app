# frozen_string_literal: true

require 'pg'

class Memo
  def initialize
    @connection = PG.connect(dbname: 'memos')
  end

  def get_all_data
    @connection.exec('SELECT * FROM t_memos')
  end
end
