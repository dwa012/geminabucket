# Geminabucket

Why run a gem server to host your gems when you have Amazon S3?

Geminbucket is Rubygems plugin that lets you host gems in S3 buckets.

Create your gem repository, push it to S3, add your bucket as a Rubygem source and that's it.

## Installation

Make sure you have Rubygems installed on your system then run:

    $ gem install geminabucket

## Usage

### Create the gem repository

```bash
# index your gems
mkdir -p /path/to/myrepo/gems
mv *.gem /path/to/myrepo/gems

gem generate_index --directory /path/to/myrepo  # no /gems suffix !

# push the repo to S3
s3cp -r /path/to/myrepo s3://my_gem_bucket
```

### Add the S3 bucket as a source

```bash
gem sources --add s3://my_gem_bucket/  # trailing '/' matters!
```

And now you can install gems from S3 with `gem install` !


## Security / Credentials

Geminabucket uses the aws-sdk gem to access S3 objects. Credentials are managed by the default credential provider.

From the [documentation](http://docs.aws.amazon.com/AWSRubySDK/latest/AWS/Core/CredentialProviders/DefaultProvider.html):
>The default credential provider makes a best effort to locate your AWS credentials. It checks a variety of locations in the following order:
>
> * Static credentials from AWS.config (e.g. AWS.config.access_key_id, AWS.config.secret_access_key)
> * The environment (e.g. ENV['AWS_ACCESS_KEY_ID'] or ENV['AMAZON_ACCESS_KEY_ID'])
> * EC2 metadata service (checks for credentials provided by roles for instances).

In addition, an AWS key can be set in a `gemrc` config file (`/etc/gemrc` or `~.gemrc`):
```yaml
---
geminabucket: {
    access_key_id: "...",
    secret_access_key: "..."
}
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Geminabucket is is licensed under the terms of the Apache Software License v2.0.
<http://www.apache.org/licenses/LICENSE-2.0.html>

