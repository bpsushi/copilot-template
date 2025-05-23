# Functional Programming Rules

Apply functional programming principles to all JavaScript/TypeScript development for more predictable, testable, and maintainable code.

## Core Principles (Non-Negotiable)

### Rule 1: Immutability
- **Never mutate existing data** - always create new versions
- Use spread operator, array methods, and object destructuring
- Avoid `.push()`, `.pop()`, `.splice()`, direct property assignment

```tsx
// Good
const addUser = (users: User[], newUser: User) => [...users, newUser];
const updateUser = (user: User, updates: Partial<User>) => ({ ...user, ...updates });

// Bad
const addUser = (users: User[], newUser: User) => { users.push(newUser); return users; };
```

### Rule 2: Pure Functions
- **Same input = same output** - no randomness, external dependencies
- **No side effects** - no mutations, console.logs, API calls, DOM manipulation
- Move side effects to separate functions or hooks

```tsx
// Pure function - Good
const calculateTotal = (items: Item[]) => items.reduce((sum, item) => sum + item.price, 0);

// Impure function - Bad
const calculateTotal = (items: Item[]) => {
  console.log('Calculating...'); // Side effect
  return items.reduce((sum, item) => sum + item.price, 0);
};
```

### Rule 3: Declarative Style
- Focus on **what** you want, not **how** to get it
- Use array methods over loops
- Compose operations with clear intent

```tsx
// Declarative - Good
const activeUserEmails = users
  .filter(user => user.active)
  .map(user => user.email)
  .sort();

// Imperative - Bad
const activeUserEmails = [];
for (let i = 0; i < users.length; i++) {
  if (users[i].active) {
    activeUserEmails.push(users[i].email);
  }
}
activeUserEmails.sort();
```

## Essential Patterns

### Array Methods (Always Use These)
```tsx
// Transform data
const doubled = numbers.map(n => n * 2);

// Filter data
const adults = users.filter(user => user.age >= 18);

// Aggregate data
const total = prices.reduce((sum, price) => sum + price, 0);

// Find single item
const user = users.find(u => u.id === targetId);

// Check conditions
const hasAdults = users.some(user => user.age >= 18);
const allActive = users.every(user => user.active);
```

### Function Composition
```tsx
// Pipe functions left to right for readability
const pipe = <T>(...fns: Array<(arg: T) => T>) => (value: T) => 
  fns.reduce((acc, fn) => fn(acc), value);

// Build complex operations from simple functions
const processUserData = pipe(
  (users: User[]) => users.filter(u => u.active),
  (users: User[]) => users.map(u => ({ ...u, email: u.email.toLowerCase() })),
  (users: User[]) => users.sort((a, b) => a.name.localeCompare(b.name))
);
```

### Currying for Reusable Functions
```tsx
// Create specialized functions from general ones
const filterBy = <T>(predicate: (item: T) => boolean) => (items: T[]) => 
  items.filter(predicate);

const filterActive = filterBy((user: User) => user.active);
const filterAdults = filterBy((user: User) => user.age >= 18);

// Use in different contexts
const activeUsers = filterActive(allUsers);
const adultUsers = filterAdults(allUsers);
```

## React-Specific FP Rules

### Functional Components Only
```tsx
// Pure functional component
function UserCard({ user, onEdit }: { user: User; onEdit: (id: string) => void }) {
  const handleClick = () => onEdit(user.id);
  
  return (
    <div className="card">
      <h3>{user.name}</h3>
      <button onClick={handleClick}>Edit</button>
    </div>
  );
}
```

### Immutable State Updates
```tsx
// State updates with immutability
const [users, setUsers] = useState<User[]>([]);

// Add user
const addUser = (newUser: User) => {
  setUsers(prevUsers => [...prevUsers, newUser]);
};

// Update user
const updateUser = (id: string, updates: Partial<User>) => {
  setUsers(prevUsers => 
    prevUsers.map(user => 
      user.id === id ? { ...user, ...updates } : user
    )
  );
};

// Remove user
const removeUser = (id: string) => {
  setUsers(prevUsers => prevUsers.filter(user => user.id !== id));
};
```

### Data Processing in JSX
```tsx
// Process data declaratively in render
function UserList({ users }: { users: User[] }) {
  return (
    <div>
      {users
        .filter(user => user.active)
        .sort((a, b) => a.name.localeCompare(b.name))
        .map(user => (
          <UserCard key={user.id} user={user} />
        ))
      }
    </div>
  );
}
```

## Advanced Patterns (Use When Needed)

### Option/Maybe for Null Safety
```tsx
class Option<T> {
  static some<T>(value: T): Option<T> { return new Some(value); }
  static none<T>(): Option<T> { return new None(); }
  static fromNullable<T>(value: T | null | undefined): Option<T> {
    return value == null ? Option.none() : Option.some(value);
  }
}

// Safe data access
const getUserEmail = (user: User | null) => 
  Option.fromNullable(user)
    .flatMap(u => Option.fromNullable(u.profile))
    .flatMap(p => Option.fromNullable(p.email))
    .map(email => email.toLowerCase())
    .getOrElse('no-email@example.com');
```

### Memoization for Expensive Pure Functions
```tsx
const memoize = <T extends (...args: any[]) => any>(fn: T): T => {
  const cache = new Map();
  return ((...args: Parameters<T>) => {
    const key = JSON.stringify(args);
    if (cache.has(key)) return cache.get(key);
    const result = fn(...args);
    cache.set(key, result);
    return result;
  }) as T;
};

// Use for expensive calculations
const expensiveCalculation = memoize((data: number[]) => {
  return data.reduce((acc, n) => acc + Math.pow(n, 2), 0);
});
```

## Implementation Guidelines

### When to Apply FP Patterns

**Always Use:**
- Pure functions for calculations and transformations
- Immutable data updates
- Array methods over loops
- Function composition for complex operations

**Use When Appropriate:**
- Option/Maybe for null-heavy APIs
- Memoization for expensive pure functions
- Currying for creating specialized functions
- Higher-order functions for reusable logic

**Avoid When:**
- Team isn't familiar with FP concepts
- Performance is critical (profile first)
- Simple operations don't need abstraction

### Integration with Hooks
```tsx
// Custom hooks with FP principles
function useUserData(userId: string) {
  const [users, setUsers] = useState<User[]>([]);
  
  // Pure functions for data processing
  const findUser = (id: string) => users.find(u => u.id === id);
  const getActiveUsers = () => users.filter(u => u.active);
  const getUsersByRole = (role: string) => users.filter(u => u.role === role);
  
  // Immutable update functions
  const updateUser = useCallback((id: string, updates: Partial<User>) => {
    setUsers(prevUsers => 
      prevUsers.map(user => 
        user.id === id ? { ...user, ...updates } : user
      )
    );
  }, []);
  
  return {
    users,
    findUser,
    getActiveUsers,
    getUsersByRole,
    updateUser
  };
}
```

## FP Checklist

### Every Function Should:
- [ ] Be pure (no side effects, predictable output)
- [ ] Use immutable data patterns
- [ ] Have single responsibility
- [ ] Be easily testable
- [ ] Use descriptive names

### Data Processing Should:
- [ ] Use array methods over loops
- [ ] Compose operations clearly
- [ ] Handle null/undefined safely
- [ ] Create new data instead of mutating
- [ ] Be readable and declarative

### Avoid These Patterns:
- [ ] Mutating arrays/objects in place
- [ ] Functions with side effects
- [ ] Imperative loops when array methods work
- [ ] Shared mutable state
- [ ] Complex nested conditionals

## Performance Considerations

### When FP Might Impact Performance:
- Creating many intermediate arrays/objects
- Deep object copying
- Complex function compositions
- Excessive memoization overhead

### Optimization Strategies:
- Profile before optimizing
- Use transducers for performance-critical chains
- Consider native methods vs library overhead
- Memoize only expensive pure functions
- Use structural sharing libraries (Immer) when needed

**Remember**: Readable, maintainable code is usually more valuable than micro-optimizations. Apply FP principles consistently, then optimize specific bottlenecks when needed.