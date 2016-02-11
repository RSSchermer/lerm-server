# Seed admin.
unless User.find_by_email('admin@lerm.com')
  User.create(email: 'admin@lerm.com',
              password: 'pleasechangethispassword',
              super_admin: true
  )
end
