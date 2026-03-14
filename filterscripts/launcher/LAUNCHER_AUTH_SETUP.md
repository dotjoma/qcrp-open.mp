# QcRP Launcher Authentication Setup

## Overview

This system provides **AAA-level security** for your SA-MP server by validating all connections through your backend API.

## Architecture

```
Launcher → Backend API → JWT Token → SAMP Server → Backend API Validation
```

**Key Security Features:**
- ✅ Challenge-response authentication
- ✅ HMAC signature verification
- ✅ JWT tokens with 1-hour expiry
- ✅ Single-use challenges (60s expiry)
- ✅ HWID binding
- ✅ Rate limiting (5 attempts/min)
- ✅ Real-time ban checking
- ✅ API-based validation (no direct DB access)

---

## Requirements

### 1. HTTP Plugin for SAMP

Download **samp-requests** plugin:
- GitHub: https://github.com/Southclaws/samp-requests
- Download latest release
- Extract `requests.dll` (Windows) or `requests.so` (Linux)
- Copy to `plugins/` folder

### 2. Update server.cfg

```ini
plugins crashdetect pawncmd requests streamer mysql
```

**Important:** `requests` must be loaded!

### 3. Include in Filterscript

The filterscript already includes:
```pawn
#include <requests>
```

---

## How It Works

### Step 1: Launcher Authenticates

```
1. User opens QcRP Launcher
2. Launcher → POST /api/auth/challenge
   - Sends: hwid, timestamp, nonce
   - Gets: challenge (random 64-char hex)

3. Launcher computes HMAC:
   response = HMAC(challenge + hwid + timestamp + nonce)

4. Launcher → POST /api/auth/authenticate
   - Sends: hwid, response, timestamp, nonce
   - Gets: JWT token (expires in 1 hour)
```

### Step 2: Launcher Writes Token File

Before starting SAMP, launcher writes `qcrp_token.txt`:
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...|ABC123DEF456...
```

Format: `TOKEN|HWID`

### Step 3: Launcher Starts SAMP

```bash
samp.exe -c -h 127.0.0.1 -p 7777
```

### Step 4: SAMP Server Validates

```
1. Player connects
2. Filterscript reads qcrp_token.txt
3. Filterscript → POST /api/auth/validate
   - Sends: { "token": "...", "hwid": "..." }
   - Backend checks:
     ✓ Token signature valid?
     ✓ Token not expired?
     ✓ HWID matches token?
     ✓ Player not banned?
   - Returns: { "valid": true/false }

4. If valid: Player spawns
   If invalid: Player kicked
```

---

## API Endpoints Used

### POST /api/auth/validate

**Request:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "hwid": "ABC123DEF456..."
}
```

**Response (Success):**
```json
{
  "valid": true,
  "hwid": "ABC123DEF456...",
  "expiresAt": 1773212586
}
```

**Response (Banned):**
```json
{
  "valid": false,
  "error": "BANNED",
  "reason": "Cheating"
}
```

**Response (Expired):**
```json
{
  "valid": false,
  "error": "TOKEN_EXPIRED"
}
```

---

## Testing

### 1. Test Backend API

```bash
cd nodejs_backend
node test-auth-flow.js
```

Should output:
```
✅ Full auth flow successful! 🎉
```

### 2. Test SAMP Integration

1. Compile filterscript: `launcher_auth.pwn`
2. Add to server.cfg: `filterscripts launcher_auth`
3. Create test token file:
   ```bash
   echo "test_token|test_hwid" > qcrp_token.txt
   ```
4. Start server
5. Connect - should see validation attempt in server log

---

## Security Benefits

### vs Direct Database Access

❌ **Old way (Direct DB):**
- Attacker can manipulate database
- No centralized validation
- Hard to update security logic
- Can't enforce real-time checks

✅ **New way (API-based):**
- Single source of truth (backend API)
- Centralized security logic
- Real-time ban checking
- Easy to update/patch
- Rate limiting enforced
- Audit logging automatic

### vs No Launcher

❌ **Without launcher:**
- Anyone can connect
- No HWID tracking
- No ban enforcement
- Easy to bypass

✅ **With launcher:**
- Only authenticated users connect
- HWID-based bans
- Token expiry enforced
- Challenge-response prevents replay attacks

---

## Troubleshooting

### "Token file not found"

**Cause:** Launcher didn't write token file before starting SAMP.

**Fix:** Ensure launcher writes `qcrp_token.txt` before calling `CreateProcess()` to start SAMP.

### "Authentication server error"

**Cause:** Backend API is down or unreachable.

**Fix:** 
1. Check backend is deployed: `curl https://qcrp-backend.vercel.app/api/health`
2. Check server has internet access
3. Check firewall allows outbound HTTPS

### "Invalid token format"

**Cause:** Token file format is wrong.

**Fix:** Ensure format is `TOKEN|HWID` with no extra spaces/newlines.

### Player kicked immediately

**Cause:** Token validation failed.

**Fix:** Check server logs for exact error. Common causes:
- Token expired (> 1 hour old)
- HWID mismatch
- Player is banned
- Invalid token signature

---

## Admin Commands

### /checkauth [playerid]

Check if a player is authenticated.

```
/checkauth 0
> Player_Name is authenticated (HWID: ABC123...)
```

---

## Production Checklist

- [ ] Backend deployed to Vercel
- [ ] Environment variables set (SUPABASE_URL, JWT_SECRET, HMAC_SECRET, etc.)
- [ ] Database tables created (launcher_sessions, launcher_bans, launcher_logs)
- [ ] HTTP plugin installed (requests.dll/so)
- [ ] Filterscript compiled and loaded
- [ ] Launcher writes token file before starting SAMP
- [ ] Test full flow: Launcher → Auth → SAMP → Validation

---

## Support

- Backend API: https://qcrp-backend.vercel.app
- Health check: https://qcrp-backend.vercel.app/api/health
- Documentation: See DEPLOYMENT.md in nodejs_backend/

**Your authentication system is now AAA-level secure!** 🔒🚀
