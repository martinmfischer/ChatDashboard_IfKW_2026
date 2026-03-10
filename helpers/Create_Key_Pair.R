# ============================================================
#  ChatDashboard – Key Setup Script
#  PURPOSE:
#  - Generate asymmetric RSA keys for secure data encryption
#  - Clearly separate responsibilities between:
#      * Researchers (local machines)
#      * Server (deployment machine)
#
#  IMPORTANT:
#  - Private keys MUST NEVER be committed or shared
# ============================================================


library(cyphr)
library(fs)

cat("\n🔐 ChatDashboard – Cryptographic Key Setup\n")
cat("=========================================\n\n")

# ------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------
researcher_dir <- "Researcher_Keypair"                        # Local / Researcher keys
server_dir     <- "ServerFolder"          # Deployment / Server keys

# ------------------------------------------------------------------
# Step 1: Generate key pairs (idempotent)
# ------------------------------------------------------------------
cat("➡  Generating key pairs (if missing)...\n")


cyphr::ssh_keygen(researcher_dir, password = FALSE)
cat("   ✔ Researcher keypair created in:", path_abs(researcher_dir), "\n")



dir_create(server_dir, recurse = TRUE)
cyphr::ssh_keygen(server_dir, password = FALSE)
cat("   ✔ Server keypair created in:", path_abs(server_dir), "\n")


# ------------------------------------------------------------------
# Step 2: Collect public keys
# ------------------------------------------------------------------
researcher_pub <- path(researcher_dir, "id_rsa.pub")
server_pub     <- path(server_dir, "id_rsa.pub")

# ------------------------------------------------------------------
# Step 3: Final instructions (MOST IMPORTANT PART)
# ------------------------------------------------------------------
cat("\nKEY DISTRIBUTION INSTRUCTIONS\n")
cat("================================\n\n")

cat("PRIVATE KEYS (DO NOT SHARE):\n")
cat(" - Researcher private key: ", path_abs(path(researcher_dir, "id_rsa")), "\n", sep = "")
cat(" - Server private key:     ", path_abs(path(server_dir, "id_rsa")), "\n\n", sep = "")

cat("PUBLIC KEYS (SAFE TO SHARE):\n")
cat(" - Researcher public key: ", path_abs(researcher_pub), "\n", sep = "")
cat(" - Server public key:     ", path_abs(server_pub), "\n\n", sep = "")

cat("------------------------------------------------------------\n")
cat("REQUIRED MANUAL STEPS\n")
cat("------------------------------------------------------------\n\n")

cat("1️⃣ ON THE SERVER (ChatDashboard deployment):\n")
cat("    • KEEP:  Server private key here -> ", path_abs(path(server_dir, "id_rsa")), "\n", sep = "")
cat("    • COPY:  Researcher public key here -> ", path_abs(researcher_pub), "\n", sep = "")
cat("    • PURPOSE: ChatDashboard encrypts data for researcher\n\n")

cat("2️⃣ ON THE RESEARCHER / LOCAL MACHINE:\n")
cat("    • KEEP:  Researcher private key -> ", path_abs(path(researcher_dir, "id_rsa")), "\n", sep = "")
cat("    • COPY:  Server public key -> place in ChatDashboard app folder (e.g., inst/keys/server_id_rsa.pub)\n\n")

cat("------------------------------------------------------------\n")
cat("SECURITY RULES\n")
cat("------------------------------------------------------------\n")
cat(" • NEVER commit private keys to Git\n")
cat(" • NEVER upload private keys to the server\n")
cat(" • ONLY public keys may be shared or versioned\n\n")

cat("✅ Key setup completed.\n")
cat("You may now configure encryption in the ChatDashboard app.\n\n")