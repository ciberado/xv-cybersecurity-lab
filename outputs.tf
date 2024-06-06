

# Outputs for Firewall created
output "firewall_name" {
  value = {
    name = aws_networkfirewall_firewall.lab_firewall.name
  }
  description = "AWS Network firewall"
}
