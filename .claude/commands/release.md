Prepare a new release of DCC:

1. Ask for the version number (e.g., 1.2.0) and a short description
2. Update CHANGELOG.md with the new version and changes
3. Run /build to generate dist/
4. Run /test to verify everything works
5. Git commit with message "v{VERSION} — {description}"
6. Git tag v{VERSION}
7. Push to origin with tags: git push && git push --tags
8. Report the release summary
