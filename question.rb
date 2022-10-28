require_relative 'DBConnection'
require_relative 'reply'
require_relative 'question_follow'

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

    def self.find_by_author_id(author_id)
        questions = DBConnection.instance.execute(<<~SQL, author_id)
            SELECT
                questions.*
            FROM
                questions
            WHERE
                author_id = ?
        SQL

        questions.map { |question| Question.new(question)}
    end

    def author
        User.find_by_id(self.author_id)
    end

    def replies
        Reply.find_by_question_id(self.id)
    end

    def followers
        Question_follow.followers_for_question_id(self.id)
    end
end