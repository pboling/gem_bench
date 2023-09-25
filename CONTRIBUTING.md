## Contributing

Bug reports and pull requests are welcome on GitLab at [https://gitlab.com/rubocop-lts/standard-rubocop-lts][🚎src-main]
. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to
the [code of conduct][conduct].

To submit a patch, please fork the project and create a patch with tests. Once you're happy with it send a pull request
and post a message to the [gitter chat][🏘chat].

## Release

To release a new version:

1. Run `bin/setup && bin/rake` as a tests, coverage, & linting sanity check
2. update the version number in `version.rb`
3. Run `bin/setup && bin/rake` again as a secondary check, and to update `Gemfile.lock`
4. Double check the `CHANGELOG.md`, make sure changes are documented
5. run `git commit -am "🔖 Prepare release v<VERSION>"` to commit the changes
6. Run `git push` to trigger the final CI pipeline before release, & merge PRs
7. Run `git checkout main` (Or whichever branch is considered `trunk`, e.g. `master`)
8. Run `git pull origin main` to ensure you will release the latest trunk code.
9. Run `bundle exec rake build`
10. Run `bin/checksum` to create and commit the SHA256 & SHA512 checksums
11. Run `bundle exec rake release`

NOTE: You will need to have a public key in `certs/`, and list your cert in the
`gemspec`, in order to sign the new release.
See: [RubyGems Security Guide][rubygems-security-guide]

## Contributors

See: [https://gitlab.com/rubocop-lts/standard-rubocop-lts/-/graphs/main][🖐contributors]

[conduct]: https://gitlab.com/rubocop-lts/standard-rubocop-lts/-/blob/main/CODE_OF_CONDUCT.md
[🖐contributors]: https://gitlab.com/rubocop-lts/standard-rubocop-lts/-/graphs/main
[🚎src-main]: https://gitlab.com/rubocop-lts/standard-rubocop-lts/-/tree/main
[🏘chat]: https://gitter.im/rubocop-lts/community
[rubygems-security-guide]: https://guides.rubygems.org/security/#building-gems
[rubygems]: https://rubygems.org

