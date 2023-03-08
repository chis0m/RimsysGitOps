# gitOps

### Features
- Setup single deployment for frontend and backend application
- Ingress group

### Optimization
Dockefile
- Layering
- optimized image sizes, frontend(bullseye-slim) 338mb, backend(alpine) 350-370mb
- using .dockerignore
- importing env with kustomize fil,e rather than using configmap object
- frontend communicates to backend through service and not through the internet
- uses initcontainer to run laravel migration
- use terraform to create infrastructure and install argocd
- setup readonly permission for the cluster
