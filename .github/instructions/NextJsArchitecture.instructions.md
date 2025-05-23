# Next.js Architecture Guide

Follow clean architecture patterns with separation of concerns and single responsibility principles for all Next.js development.

## Core Architecture Rules

### Rule 1: Logic Separation
- **Custom hooks for ALL logic** - Never mix business logic with UI
- Extract `useEffect`, state management, and data fetching into `use*` hooks
- Place in `hooks/` folder within features
- Components should only handle UI rendering and user interactions

### Rule 2: Service Layer
- **Service classes for ALL external calls** - No API calls in components/hooks
- Static methods for HTTP requests, data transformation, error handling
- Place in `services/` folder within features
- Handle all external communication through service layer

### Rule 3: Component Architecture
- **Single responsibility** - Max 100 lines per component
- Use composition over large monolithic components
- Break down complex UIs into focused sub-components
- Each component should have one clear purpose

### Rule 4: Form Architecture
- **React Hook Form ONLY** - No manual form state management
- Use Zod for validation schemas
- Extract complex form logic to custom hooks
- Server actions for form submissions

### Rule 5: Folder Structure
**Feature-based organization:**
```
src/
├── features/
│   ├── auth/
│   │   ├── components/
│   │   ├── hooks/
│   │   ├── services/
│   │   ├── actions/
│   │   └── types.ts
│   ├── users/
│   │   ├── components/
│   │   ├── hooks/
│   │   ├── services/
│   │   ├── actions/
│   │   └── types.ts
│   └── dashboard/
├── shared/
│   ├── components/
│   ├── hooks/
│   ├── utils/
│   └── types/
└── app/
    ├── (routes)/
    └── api/
```

### Rule 6: State Management Architecture
- **Local state** for component-specific data
- **Zustand** for complex global state
- Create stores by feature/domain
- Never mix global and local state concerns
- Keep stores focused and minimal

## Architecture Patterns

### Custom Hook Pattern
```tsx
// hooks/useUserProfile.ts
export function useUserProfile(userId: string) {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    UserService.getUser(userId)
      .then(setUser)
      .catch(err => setError(err.message))
      .finally(() => setLoading(false));
  }, [userId]);

  const updateProfile = useCallback(async (data: UserUpdate) => {
    setLoading(true);
    try {
      const updated = await UserService.updateUser(userId, data);
      setUser(updated);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }, [userId]);

  return { user, loading, error, updateProfile };
}
```

### Service Layer Pattern
```tsx
// services/userService.ts
export class UserService {
  static async getUser(id: string): Promise<User> {
    const response = await fetch(`/api/users/${id}`);
    if (!response.ok) throw new Error('Failed to fetch user');
    return response.json();
  }

  static async updateUser(id: string, data: UserUpdate): Promise<User> {
    const response = await fetch(`/api/users/${id}`, {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    });
    if (!response.ok) throw new Error('Failed to update user');
    return response.json();
  }
}
```

### Server Action Pattern
```tsx
// actions/userActions.ts
'use server';

export async function updateUserProfile(formData: FormData) {
  // 1. Extract and validate data
  const data = userSchema.parse(Object.fromEntries(formData.entries()));
  
  // 2. Business logic
  try {
    await UserService.updateUser(data.id, data);
    revalidatePath('/profile');
    return { success: true };
  } catch (error) {
    return { error: 'Failed to update profile' };
  }
}
```

### Component Composition Pattern
```tsx
// Break large components into focused pieces
function UserDashboard({ userId }: { userId: string }) {
  return (
    <div className="space-y-6">
      <UserHeader userId={userId} />
      <UserStats userId={userId} />
      <UserActivity userId={userId} />
      <UserSettings userId={userId} />
    </div>
  );
}

function UserHeader({ userId }: { userId: string }) {
  const { user, loading } = useUserProfile(userId);
  
  if (loading) return <HeaderSkeleton />;
  return <header>...</header>;
}
```

## Architecture Checklist

### Every Feature Must Have:
- [ ] Feature folder with proper subfolders
- [ ] Service class for external communication
- [ ] Custom hooks for business logic
- [ ] Focused components (< 100 lines each)
- [ ] TypeScript interfaces in types.ts

### Never Allow:
- [ ] Business logic in components
- [ ] API calls in components or hooks
- [ ] Mixed concerns in single file
- [ ] Large monolithic components
- [ ] File organization by type instead of feature

## Implementation Workflow

**New Feature Development:**
1. Create feature folder with proper structure
2. Define TypeScript interfaces in `types.ts`
3. Create service class for API interactions
4. Build custom hooks for business logic
5. Create focused UI components
6. Add server actions if needed

**Standards to Maintain:**
- Every external call → service class
- Every business logic → custom hook
- Every component → single responsibility
- Every feature → own folder structure