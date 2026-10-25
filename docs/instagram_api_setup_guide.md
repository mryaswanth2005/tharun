# Meta Instagram Graph API Setup Guide

This guide details the prerequisites and configuration steps required to authorize official Instagram Graph API publishing.

---

## 1. Prerequisites Checklist
- [x] Instagram Professional (Business or Creator) account.
- [x] Facebook Page linked to the Instagram Professional account.
- [x] Meta for Developers account ([developers.facebook.com](https://developers.facebook.com)).
- [x] Registered Meta App (Type: **Business**).

---

## 2. Required Permissions
Ensure your Meta System User or User Access Token includes:
- `instagram_basic`
- `instagram_content_publish`
- `pages_show_list`
- `pages_read_engagement`

---

## 3. Finding Your Instagram Account ID

Execute a GET request in the Meta Graph API Explorer:
```http
GET https://graph.facebook.com/v19.0/me/accounts?fields=instagram_business_account{id,username}
```
The response returns your `INSTAGRAM_ACCOUNT_ID`:
```json
{
  "instagram_business_account": {
    "id": "17841400000000000",
    "username": "califnco_purewater"
  }
}
```

---

## 4. Two-Step Media Publishing Pipeline

Meta requires a two-step publishing cycle:

### Step 1: Create Media Container
```http
POST https://graph.facebook.com/v19.0/{ig-user-id}/media
Content-Type: application/json

{
  "image_url": "https://res.cloudinary.com/califnco/image/upload/v1/product.jpg",
  "caption": "💧 Discover pure healthy water with Califnco AquaPro RO! #Califnco",
  "access_token": "{your-meta-access-token}"
}
```
Returns:
```json
{
  "id": "17891234567890123"
}
```

### Step 2: Publish Container
```http
POST https://graph.facebook.com/v19.0/{ig-user-id}/media_publish
Content-Type: application/json

{
  "creation_id": "17891234567890123",
  "access_token": "{your-meta-access-token}"
}
```
Returns:
```json
{
  "id": "17983421098456721"
}
```
The post is now live on the official Instagram profile!

---

## 5. Image Format Constraints Enforced by Instagram
1. **Aspect Ratio**: 1:1 (Square), 4:5 (Vertical), or 1.91:1 (Horizontal).
2. **File Format**: JPEG or PNG.
3. **Maximum File Size**: 8 MB.
4. **URL Accessibility**: Must be publicly reachable on HTTPS without basic auth or redirect barriers (Cloudinary and Unsplash URLs meet these requirements).
