class UserRoleValidator < ActiveModel::EachValidator
  Roles = ['admin','sales','user']
  def validate_each(record,attribute,value)
    record.errors.add(attribute,"#{value} is not a valid user role!") unless Roles.include?(value)
  end
end
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  acts_as_orderer
  enum role: %i(user admin sales)

  def is_admin?
    admin? || sales?
  end

  rails_admin do
    list do
      fields(:email,:first_name,:last_name)
      field :role, :enum do
        enum do
          User.roles
        end
      end
    end
    edit do
      fields(:first_name,:last_name,:email,:password,:password_confirmation)
      field :role, :enum do
        enum do
          User.roles.keys
        end
        default_value 'user'
       end
    end
    show do
      fields(
          :first_name,
          :last_name,
          :email)
      field :role, :enum do
        enum do
          User.roles
        end
      end
      fields(
          :reset_password_sent_at,
          :sign_in_count,
          :current_sign_in_at,
          :last_sign_in_at,
          :current_sign_in_ip,
          :last_sign_in_ip,
          :created_at,
          :updated_at)
    end
  end
end
