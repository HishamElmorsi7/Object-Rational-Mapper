require_relative 'DBConnection'

class Reply
    attr_accessor :id, :author_id, :question, :body, :parent_reply_id

    def initialize(options)
        @id = options['id']
        @author_id = options['author_id']
        @question_id = options['question_id']
        @parent_reply_id = options['parent_reply_id']
        @body = options['body']
    end

    def self.find_by_id(id)
        reply = DBConnection.instance.execute(<<~SQL, id)
            SELECT
                *
            FROM
                replies
            WHERE
                id = ?
        SQL

        Reply.new(reply.first) unless reply.empty?
    end

    def self.find_by_body(body)
        reply = DBConnection.instance.execute(<<~SQL, body)
            SELECT
                *
            FROM
                replies
            WHERE
                body = ?
        SQL

        Reply.new(reply.first) unless reply.empty?
    end
end