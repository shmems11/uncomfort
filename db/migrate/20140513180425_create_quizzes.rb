class CreateQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|
      

      t.timestamps
    end
  end
end