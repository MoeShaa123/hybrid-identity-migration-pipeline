variable "target_identities" {
  type = map(object({
    FirstName         = string
    LastName          = string
    Department        = string
    JobTitle          = string
    UserPrincipalName = string
  }))
  description = "Structured collection of enterprise employee profiles parsed from legacy systems."
  default     = {}
}
