require 'z3/backend/memory/storage'
class FilledMemoryBackend < Z3::Backend::Memory
  private
  def after_init
    user=create_user(:z3_display_name => 'Pan Tau')
    add_credentials(user, "AKanaccesskey", "asupersecretkeys")
    bucket=create_bucket(user,
                         {:z3_name => "z3test",
                          :z3_updated_at => Time.now,
                          :z3_acl => "private",
                          :z3_location => 'EU'},
                         [[user.z3_grantee, Z3::Acl::PERMISSION_FULL_CONTROL]]
    )
    create_object(bucket,
                  {:z3_name => 'note.txt',
                   :z3_updated_at => Time.now,
                   :z3_owner_id => user.z3_id,
                   :z3_size => 10,
                   :z3_etag => '7c12772809c1c0c3deda6103b10fdfa0',
                   :z3_meta => {:gid => '1000',
                                :uid => '1000',
                                :mode => "33204",
                                :mtime => '1334702205'},
                   :content => '1234567890',
                   :content_type => 'text/plain'},
                  [[user.z3_grantee, Z3::Acl::PERMISSION_FULL_CONTROL]]
    )
    create_object(bucket,
                  {:z3_name => 'note2.txt',
                   :z3_updated_at => Time.now,
                   :z3_owner_id => user.z3_id,
                   :z3_size => 14,
                   :z3_etag => '7c12772809c1c0c3deda6103b10fdfa0',
                   :z3_meta => {:gid => '1000',
                                :uid => '1000',
                                :mode => "33204",
                                :mtime => '1334702205'},
                   :content => 'abcdefghijklmn',
                   :content_type => 'text/plain'},
                  [[Z3::Acl::GROUP_ALL, Z3::Acl::PERMISSION_READ]]
    )
  end
end