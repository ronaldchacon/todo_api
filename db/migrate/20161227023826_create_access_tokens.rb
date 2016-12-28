class CreateAccessTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :access_tokens do |t|
      t.string :token_digest
      t.references :user, foreign_key: true
      t.timestamp :accessed_at

      t.timestamps
    end
  end
end
