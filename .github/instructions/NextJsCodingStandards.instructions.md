# Next.js Coding Standards

You are a Senior Front-End Developer expert in ReactJS, NextJS, TypeScript, TailwindCSS, Shadcn UI, and Radix UI. Follow these coding standards for all implementation.

## TypeScript Standards
- **Use interfaces over types** for object definitions
- **Avoid enums** - use maps instead
- **Always type all functions and components**
- Descriptive names with auxiliary verbs (`isLoading`, `hasError`)
- Export types from feature `types.ts` files

## Syntax & Formatting Rules
- **Use `function` for React components** (better debugging/stack traces)
- **Use `const` for utility functions and event handlers** (lexical scoping)
- **Use early returns** whenever possible for readability
- **Avoid unnecessary curly braces** in conditionals - use concise syntax
- **Use declarative JSX** - clear and readable markup
- **Event functions named with "handle" prefix** (`handleClick`, `handleKeyDown`)

## Naming Conventions
- **Lowercase with dashes for directories** (e.g., `components/auth-wizard`)
- **Favor named exports** for components
- **Descriptive variable names** with clear intent
- **PascalCase for components** (`UserProfile`, `DataTable`)
- **camelCase for functions and variables** (`handleSubmit`, `isLoading`)

## Performance & Client Components
- **Limit `use client`** - Favor server components and Next.js SSR
- **Use `use client` ONLY** for Web API access in small components
- **Avoid `use client`** for data fetching or state management
- **Wrap client components in Suspense** with fallback
- **Use dynamic loading** for non-critical components
- **Optimize images** (WebP format, lazy loading, size data)

## UI & Styling Standards
- **Use Shadcn UI, Radix, and Tailwind** for all components and styling
- **Mobile-first responsive design** with Tailwind CSS
- **Always use Tailwind classes** - avoid CSS files or inline styles
- **Implement accessibility** (tabIndex, aria-labels, semantic HTML)
- **Use proper semantic HTML** structure

## Code Implementation Guidelines

### General Rules
- **Use early returns** whenever possible to make code more readable
- **Always use Tailwind classes** for styling HTML elements
- **Avoid CSS files or style tags** completely
- **Use descriptive variable and function names**
- **Implement proper accessibility features** on all interactive elements

### Component Structure
- **Structure files**: exported component → subcomponents → helpers → types
- **Keep components focused** - single responsibility
- **Use functional components** with TypeScript interfaces
- **Prefer iteration and modularization** over code duplication

### Error Handling
- **Always handle errors** in async operations
- **Provide user-friendly error messages**
- **Use try-catch blocks** appropriately
- **Validate data** before processing

## Code Examples

### Proper Component Structure
```tsx
// Component with all standards applied
function UserProfile({ userId }: { userId: string }) {
  const { user, loading, error } = useUserProfile(userId);
  
  // Early returns for better readability
  if (loading) return <LoadingSpinner />;
  if (error) return <ErrorMessage message={error} />;
  if (!user) return <NotFoundMessage />;
  
  // Event handlers with proper naming
  const handleEditClick = () => {
    // Handler logic here
  };
  
  const handleDeleteClick = async () => {
    // Async handler with error handling
    try {
      await UserService.deleteUser(userId);
    } catch (error) {
      // Handle error appropriately
    }
  };
  
  return (
    <div className="max-w-2xl mx-auto p-6 bg-white rounded-lg shadow-md">
      <header className="mb-6">
        <h1 className="text-2xl font-bold text-gray-900">{user.name}</h1>
        <p className="text-gray-600">{user.email}</p>
      </header>
      
      <div className="flex gap-4">
        <button 
          onClick={handleEditClick}
          className="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-500"
          tabIndex={0}
          aria-label="Edit user profile"
        >
          Edit Profile
        </button>
        
        <button 
          onClick={handleDeleteClick}
          className="px-4 py-2 bg-red-500 text-white rounded hover:bg-red-600 focus:outline-none focus:ring-2 focus:ring-red-500"
          tabIndex={0}
          aria-label="Delete user profile"
        >
          Delete
        </button>
      </div>
    </div>
  );
}

export { UserProfile };
```

### Utility Function Example
```tsx
// Utility functions using const
const formatCurrency = (amount: number): string => {
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD'
  }).format(amount);
};

const debounce = <T extends (...args: any[]) => any>(
  func: T,
  delay: number
): ((...args: Parameters<T>) => void) => {
  let timeoutId: NodeJS.Timeout;
  return (...args: Parameters<T>) => {
    clearTimeout(timeoutId);
    timeoutId = setTimeout(() => func(...args), delay);
  };
};
```

## Quality Checklist

### Every File Must Have:
- [ ] Proper TypeScript typing
- [ ] Consistent naming conventions
- [ ] Early returns where applicable
- [ ] Proper error handling
- [ ] Accessibility features implemented

### Code Quality Standards:
- [ ] No CSS files or inline styles
- [ ] Mobile-first Tailwind classes
- [ ] Semantic HTML structure
- [ ] Proper event handler naming
- [ ] Clear variable and function names
- [ ] Consistent code formatting

### Performance Standards:
- [ ] Minimal use of `use client`
- [ ] Proper image optimization
- [ ] Dynamic loading where appropriate
- [ ] Efficient component structure
- [ ] No unnecessary re-renders