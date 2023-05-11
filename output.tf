output "sympl_password" {
  value     = random_password.sympl.result
  sensitive = true
}
