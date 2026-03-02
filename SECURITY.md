# Security Policy

> **PROJECT ARCHIVED - NO SECURITY UPDATES**
> 
> This project was archived on March 2, 2026. Security vulnerabilities will no longer be patched or addressed. Use this software at your own risk. I recommend forking the project if you require ongoing security maintenance.
>
> **GitHub Repository:** https://github.com/iad1tya/pufood

## Supported Versions

Note: As of March 2, 2026, no versions are actively supported. The information below is historical.

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

**Note:** As this project is archived, security reports are no longer being actively monitored or addressed.

### Historical Reporting Process

The following was the historical process before archival:

**Please do NOT report security vulnerabilities through public GitHub issues.**

### What to Include

Please include the following information in your report:

- Type of vulnerability
- Full paths of source file(s) related to the vulnerability
- Location of the affected source code (tag/branch/commit or direct URL)
- Step-by-step instructions to reproduce the issue
- Proof-of-concept or exploit code (if possible)
- Impact of the issue, including how an attacker might exploit it

### Response Timeline

- **Initial Response:** Within 48 hours
- **Status Update:** Within 7 days
- **Fix Timeline:** Depends on severity
  - Critical: 1-3 days
  - High: 3-7 days
  - Medium: 7-14 days
  - Low: 14-30 days

### Disclosure Policy

- Security issues will be addressed privately
- A fix will be developed and tested
- An advisory will be published after the fix is released
- Credit will be given to the reporter (unless anonymity is requested)

## Security Best Practices for Users

### For Web Users

1. **Always use HTTPS**
   - Access only via `https://pufood.xyz`
   - Verify SSL certificate validity

2. **Keep Browsers Updated**
   - Use latest version of Chrome, Firefox, Safari, or Edge
   - Enable automatic updates

3. **Be Cautious with Personal Data**
   - Don't share sensitive information in search queries
   - Clear browser cache periodically

4. **Verify Downloads**
   - Only download APK from official sources
   - Check file signatures if provided

### For Mobile App Users

1. **Download from Official Sources**
   - Google Play Store (recommended)
   - Official website only
   - Verify developer name

2. **Keep App Updated**
   - Enable automatic updates
   - Check for updates regularly

3. **App Permissions**
   - Review requested permissions
   - Only grant necessary permissions

4. **Device Security**
   - Use device lock screen
   - Keep OS updated
   - Use antivirus (optional but recommended)

### For Developers

1. **Code Security**
   - Follow OWASP guidelines
   - Sanitize all user inputs
   - Use secure dependencies
   - Regular dependency audits

2. **API Security**
   - Never commit API keys to repository
   - Use environment variables
   - Implement rate limiting
   - Validate all requests

3. **Data Protection**
   - Encrypt sensitive data
   - Use HTTPS for all communications
   - Implement proper session management
   - Follow data minimization principles

4. **Testing**
   - Regular security testing
   - Penetration testing
   - Code reviews
   - Automated security scans

## Known Security Considerations

### API Key Exposure

Note: The `config.js` file contains an API key for OpenRouter. This is intentional for the chatbot feature but has limited permissions and rate limits. However:

- Do not use this key for other purposes
- Replace with your own key in production
- Monitor usage regularly

### Third-Party Dependencies

We use third-party libraries and services:

- Firebase (Analytics)
- Google Analytics
- Syncfusion PDF Viewer
- Various Flutter/npm packages

These are regularly updated to address known vulnerabilities.

### Data Collection

PUFood collects minimal user data:

- **Web App:** Anonymous analytics via Google Analytics
- **Mobile App:** Firebase Analytics (crash reports, usage stats)
- **No personal information** is stored or transmitted

See [Privacy Policy](https://pufood.xyz/privacy.html) for details.

## Security Updates

Security updates are announced through:

1. GitHub Security Advisories
2. Release notes
3. Community group announcements

Subscribe to repository notifications to stay informed.

## Security Checklist for Contributors

Before submitting code:

- [ ] No hardcoded credentials
- [ ] Input validation implemented
- [ ] No SQL/NoSQL injection vulnerabilities
- [ ] XSS prevention measures in place
- [ ] CSRF protection where applicable
- [ ] Secure session management
- [ ] Proper error handling (no sensitive data in errors)
- [ ] Dependencies are up-to-date
- [ ] Code follows security best practices

## Vulnerability Disclosure Examples

### Example 1: XSS Vulnerability

```
Title: Cross-Site Scripting in Search Feature

Description: The search functionality does not properly sanitize user input,
allowing execution of arbitrary JavaScript.

Steps to Reproduce:
1. Navigate to homepage
2. Enter: <script>alert('XSS')</script> in search box
3. Observe script execution

Impact: Attackers could steal session tokens or perform actions on behalf 
of users.

Suggested Fix: Implement input sanitization using DOMPurify or similar library.
```

### Example 2: Information Disclosure

```
Title: API Key Exposed in Client-Side Code

Description: Sensitive API key is hardcoded in config.js and publicly accessible.

Location: /config.js line 2

Impact: Attackers could abuse the API key for unauthorized access or 
rate limit exhaustion.

Suggested Fix: Move API key to server-side environment variables.
```

## Security Tools We Use

- **Dependency Scanning:** GitHub Dependabot
- **Code Analysis:** ESLint, dart analyze
- **HTTPS:** Let's Encrypt SSL certificates
- **CDN:** Cloudflare (DDoS protection)

## Bug Bounty Program

Currently, we do not have a formal bug bounty program. However:

- Security researchers are acknowledged in release notes
- Contributors page recognition
- Our gratitude and appreciation

We may implement a formal program in the future.

## Compliance

PUFood aims to comply with:

- GDPR (minimal data collection)
- COPPA (no data from children under 13)
- Indian IT Act

---

End of Security Policy

## Attribution

We follow responsible disclosure and will credit security researchers who:
- Follow our reporting guidelines
- Give us reasonable time to fix issues
- Do not publicly disclose before patches are released

Thank you for helping keep PUFood and its users safe!
