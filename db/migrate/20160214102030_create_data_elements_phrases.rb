class CreateDataElementsPhrases < ActiveRecord::Migration
  def change
    create_table :data_elements_phrases, :id => false do |t|
      t.references :data_element
      t.references :phrase
    end

    add_index :data_elements_phrases, [:data_element_id, :phrase_id],
      name: 'data_elements_phrases_index',
      unique: true
  end
end
