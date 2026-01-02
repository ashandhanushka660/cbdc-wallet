export async function adminGuard(to, from, next) {
  const { supabase } = await import('boot/supabase')
  
  try {
    // Check if user is authenticated
    const { data: { user }, error: authError } = await supabase.auth.getUser()
    
    if (authError || !user) {
      next('/')
      return
    }

    // Check if user is admin
    const { data: profile, error: profileError } = await supabase
      .from('profiles')
      .select('is_admin')
      .eq('id', user.id)
      .single()

    if (profileError || !profile || !profile.is_admin) {
      next('/')
      return
    }

    // User is admin, allow access
    next()
  } catch (err) {
    console.error('Admin guard error:', err)
    next('/')
  }
}
