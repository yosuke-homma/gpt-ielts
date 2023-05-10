class RemoveScoreFromExams < ActiveRecord::Migration[7.0]
  def change
    remove_column :exams, :score, :string
  end
end
