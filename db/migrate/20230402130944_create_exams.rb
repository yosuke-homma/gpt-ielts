class CreateExams < ActiveRecord::Migration[7.0]
  def change
    create_table :exams do |t|
      t.text :question
      t.text :answer
      t.string :score
      t.text :review
      t.timestamps
    end
  end
end
