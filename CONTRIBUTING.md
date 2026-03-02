# Contributing to PUFood

> **PROJECT ARCHIVED - CONTRIBUTIONS CLOSED**
> 
> This project has been archived on March 2, 2026. I am no longer accepting contributions, pull requests, or issue reports. This documentation is maintained for historical reference only.
> 
> You are welcome to fork this project for your own use, but the original repository will not receive any updates.
>
> **GitHub Repository:** https://github.com/iad1tya/pufood

---

## Historical Documentation

The following documentation reflects how contributions were handled before the project was archived.

## Table of Contents

1. [Code of Conduct](#code-of-conduct)
2. [How Can I Contribute?](#how-can-i-contribute)
3. [Getting Started](#getting-started)
4. [Development Workflow](#development-workflow)
5. [Submitting Changes](#submitting-changes)
6. [Style Guidelines](#style-guidelines)

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code. Please report unacceptable behavior to the project maintainer.

### Our Standards

- Be respectful and inclusive
- Accept constructive criticism gracefully
- Focus on what is best for the community
- Show empathy towards other community members

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates. When you create a bug report, include as many details as possible:

- **Use a clear and descriptive title**
- **Describe the exact steps to reproduce the problem**
- **Provide specific examples**
- **Describe the behavior you observed and what you expected**
- **Include screenshots if possible**
- **Specify your environment** (OS, browser, app version)

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, include:

- **Use a clear and descriptive title**
- **Provide a detailed description of the suggested enhancement**
- **Explain why this enhancement would be useful**
- **List examples of how it would work**

### Adding Food Data

You can help keep PUFood up-to-date by:

1. **Adding New Outlets**
   - Visit [Submit Menu](https://pufood.xyz/submit.html)
   - Fill out the form with outlet details
   - Upload menu PDF
   - Submit for review

2. **Updating Existing Data**
   - Report price changes
   - Update menu items
   - Correct nutritional information
   - Add missing outlets

3. **Verifying Information**
   - Cross-check prices
   - Verify outlet locations
   - Confirm menu accuracy

### Code Contributions

## Getting Started

### Prerequisites

For Web Development:
- Modern web browser
- Code editor (VS Code recommended)
- Basic knowledge of HTML, CSS, JavaScript

For Flutter App Development:
- Flutter SDK (3.7.2 or higher)
- Dart SDK
- Android Studio / Xcode
- VS Code or Android Studio

### Setup Development Environment

1. **Fork the repository**
   ```bash
   # Click the 'Fork' button on GitHub
   ```

2. **Clone your fork**
   ```bash
   git clone https://github.com/YOUR-USERNAME/pufood.git
   cd pufood
   ```

3. **Add upstream remote**
   ```bash
   git remote add upstream https://github.com/ORIGINAL-OWNER/pufood.git
   ```

4. **For Flutter development**
   ```bash
   cd app
   flutter pub get
   ```

## Development Workflow

### Making Changes

1. **Create a branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Write clean, readable code
   - Follow the existing code style
   - Test your changes thoroughly

3. **Commit your changes**
   ```bash
   git add .
   git commit -m "Add: Brief description of your changes"
   ```

4. **Stay up to date**
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

5. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

### Testing

Before submitting:

**Web Application:**
- Test on multiple browsers (Chrome, Firefox, Safari)
- Test on mobile devices
- Verify PWA functionality
- Check offline mode

**Flutter App:**
- Run `flutter analyze`
- Test on both Android and iOS (if possible)
- Check for UI issues on different screen sizes
- Verify all features work correctly

## Submitting Changes

### Pull Request Process

1. **Update documentation**
   - Update README.md if needed
   - Add comments to complex code
   - Update CHANGELOG.md

2. **Create Pull Request**
   - Use a clear and descriptive title
   - Reference related issues
   - Describe your changes in detail
   - Include screenshots for UI changes

3. **Pull Request Template**
   ```markdown
   ## Description
   Brief description of changes

   ## Type of Change
   - [ ] Bug fix
   - [ ] New feature
   - [ ] Documentation update
   - [ ] Performance improvement

   ## Testing
   Describe how you tested your changes

   ## Screenshots (if applicable)

   ## Checklist
   - [ ] My code follows the style guidelines
   - [ ] I have tested my changes
   - [ ] I have updated the documentation
   - [ ] My changes generate no new warnings
   ```

4. **Code Review**
   - Be responsive to feedback
   - Make requested changes promptly
   - Discuss disagreements constructively

## Style Guidelines

### JavaScript Style Guide

- Use ES6+ features
- Use `const` and `let`, avoid `var`
- Use meaningful variable names
- Add comments for complex logic
- Keep functions small and focused

```javascript
const calculateTotalPrice = (items) => {
  return items.reduce((total, item) => total + item.price, 0);
};
```

### Dart/Flutter Style Guide

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Use meaningful names
- Keep widgets small and reusable
- Use const constructors where possible

```dart
class FoodCard extends StatelessWidget {
  final FoodItem foodItem;
  
  const FoodCard({Key? key, required this.foodItem}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(foodItem.name),
        subtitle: Text('₹${foodItem.price}'),
      ),
    );
  }
}
```

### CSS/Styling

- Use meaningful class names
- Follow mobile-first approach
- Use CSS variables for theming
- Keep styles modular

```css
.food-card {
  padding: var(--spacing-md);
  border-radius: var(--border-radius);
  background: var(--card-bg);
}
```

### Commit Messages

Use conventional commits format:

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes (formatting)
- `refactor:` Code refactoring
- `test:` Adding tests
- `chore:` Maintenance tasks

Examples:
```
feat: Add filter by high protein foods
fix: Resolve search bar not clearing on mobile
docs: Update installation instructions
```

### Documentation

- Use clear and concise language
- Include code examples
- Add screenshots for UI features
- Keep documentation up-to-date

## Additional Notes

### Priority Labels

Issues and PRs may be labeled with:
- `good first issue` - Good for newcomers
- `help wanted` - Extra attention needed
- `bug` - Something isn't working
- `enhancement` - New feature or request
- `documentation` - Documentation improvements


## Recognition

Contributors will be:
- Listed in the [Contributors page](https://pufood.xyz/contributors.html)
- Acknowledged in release notes
- Appreciated by the entire PU community

Thank you for contributing to PUFood.
