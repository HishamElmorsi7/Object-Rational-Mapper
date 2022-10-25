require_relative './user.rb'


class Question
    attr_accessor :id, :title, :body, :author_id

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @author_id = options['author_id']
    end

    def self.find_by_id(id)
        question = DBConnection.instance.execute(<<~SQL, id)
            SELECT
                *
            FROM
                questions
            WHERE
                id = ?
        SQL

        Question.new(question.first) unless question.empty?
    end

    def self.find_by_title(title)
        question = DBConnection.instance.execute(<<~SQL, title)
            SELECT
                *
            FROM
                questions
            WHERE
                title = ?
        SQL

        Question.new(question.first) unless question.empty?
    end


end