# THOON – Backend API Architecture

## Tech Stack Overview

| Layer | Technology |
|---|---|
| API Framework | ASP.NET Core 8 Web API |
| Database | SQL Server 2022 |
| Authentication | Firebase Auth (Phone OTP + Google) |
| Push Notifications | Firebase FCM via Node.js service |
| Payment Gateway | Razorpay (with server-side webhook verification) |
| File Storage | Azure Blob Storage (complaint photos, voice notes) |
| Real-time | Node.js + Socket.IO (notification delivery) |

---

## SQL Server Database Schema

### Table: Users
```sql
CREATE TABLE Users (
    Id              UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    FirebaseUid     NVARCHAR(128) UNIQUE NOT NULL,
    Name            NVARCHAR(200) NOT NULL,
    Phone           NVARCHAR(15)  NOT NULL UNIQUE,
    Email           NVARCHAR(200),
    AvatarUrl       NVARCHAR(500),
    MembershipTier  NVARCHAR(20)  NOT NULL DEFAULT 'Standard',  -- Standard, Silver, Gold, Platinum
    LoyaltyPoints   INT           NOT NULL DEFAULT 0,
    FcmToken        NVARCHAR(500),
    CreatedAt       DATETIME2     NOT NULL DEFAULT GETUTCDATE(),
    UpdatedAt       DATETIME2     NOT NULL DEFAULT GETUTCDATE()
);
```

### Table: Employees
```sql
CREATE TABLE Employees (
    Id          UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    Name        NVARCHAR(200) NOT NULL,
    Phone       NVARCHAR(15) NOT NULL UNIQUE,
    Role        NVARCHAR(100) NOT NULL,    -- e.g. "Senior Mason"
    Skills      NVARCHAR(500),             -- comma-separated
    AvatarUrl   NVARCHAR(500),
    Rating      DECIMAL(3,2) DEFAULT 0,
    TotalJobs   INT NOT NULL DEFAULT 0,
    IsActive    BIT NOT NULL DEFAULT 1,
    Status      NVARCHAR(20) DEFAULT 'Available',  -- Available, Busy, OffDuty
    CreatedAt   DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);
```

### Table: Services
```sql
CREATE TABLE Services (
    Id              UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    Title           NVARCHAR(300) NOT NULL,
    Category        NVARCHAR(100) NOT NULL,
    Description     NVARCHAR(MAX),
    ImageUrl        NVARCHAR(500),
    Price           NVARCHAR(100) NOT NULL,   -- e.g. "₹65 / sq.ft"
    OfferPrice      NVARCHAR(100),
    DiscountPercent INT,
    Rating          DECIMAL(3,2) DEFAULT 0,
    ReviewCount     INT DEFAULT 0,
    IsAvailable     BIT NOT NULL DEFAULT 1,
    ExpertId        UNIQUEIDENTIFIER REFERENCES Employees(Id),
    CreatedAt       DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);
```

### Table: Complaints
```sql
CREATE TABLE Complaints (
    Id                  UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    ReferenceId         NVARCHAR(20) NOT NULL UNIQUE,   -- e.g. THN-998822
    UserId              UNIQUEIDENTIFIER NOT NULL REFERENCES Users(Id),
    Category            NVARCHAR(100) NOT NULL,
    Description         NVARCHAR(MAX),
    Priority            NVARCHAR(20) NOT NULL DEFAULT 'Medium',  -- Low, Medium, High, Urgent
    Status              NVARCHAR(30) NOT NULL DEFAULT 'Pending', -- Pending, Assigned, InProgress, Completed, Cancelled
    HasVoiceNote        BIT DEFAULT 0,
    VoiceNoteUrl        NVARCHAR(500),
    AssignedEmployeeId  UNIQUEIDENTIFIER REFERENCES Employees(Id),
    AssignedAt          DATETIME2,
    CompletedAt         DATETIME2,
    CreatedAt           DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    UpdatedAt           DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);

CREATE TABLE ComplaintPhotos (
    Id          UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    ComplaintId UNIQUEIDENTIFIER NOT NULL REFERENCES Complaints(Id),
    PhotoUrl    NVARCHAR(500) NOT NULL,
    CreatedAt   DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);
```

### Table: Bookings
```sql
CREATE TABLE Bookings (
    Id                  UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    ReferenceId         NVARCHAR(30) NOT NULL UNIQUE,
    UserId              UNIQUEIDENTIFIER NOT NULL REFERENCES Users(Id),
    ServiceId           UNIQUEIDENTIFIER NOT NULL REFERENCES Services(Id),
    Type                NVARCHAR(30) NOT NULL DEFAULT 'SiteVisit',  -- SiteVisit, ServiceBooking
    Status              NVARCHAR(30) NOT NULL DEFAULT 'Pending',    -- Pending, Confirmed, Visited, Converted, Cancelled
    ScheduledDate       DATE NOT NULL,
    TimeSlot            NVARCHAR(50) NOT NULL,
    Address             NVARCHAR(500) NOT NULL,
    SiteVisitFee        DECIMAL(10,2) NOT NULL DEFAULT 100,
    SiteVisitFeePaid    BIT DEFAULT 0,
    RazorpayPaymentId   NVARCHAR(100),
    FinalProjectCost    DECIMAL(12,2),
    IsSiteFeeCredited   BIT DEFAULT 0,   -- Business rule: credited in final quote
    AssignedEmployeeId  UNIQUEIDENTIFIER REFERENCES Employees(Id),
    CreatedAt           DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    UpdatedAt           DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);
```

### Table: BuildingEnquiries
```sql
CREATE TABLE BuildingEnquiries (
    Id          UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    EnquiryId   NVARCHAR(20) NOT NULL UNIQUE,     -- e.g. ENQ-98822
    UserId      UNIQUEIDENTIFIER REFERENCES Users(Id),
    Name        NVARCHAR(200) NOT NULL,
    Phone       NVARCHAR(15) NOT NULL,
    ProjectType NVARCHAR(100) NOT NULL,
    PlotSize    NVARCHAR(100),
    Budget      NVARCHAR(100),
    Location    NVARCHAR(300),
    SitePhotoUrl NVARCHAR(500),
    Notes       NVARCHAR(MAX),
    Status      NVARCHAR(30) DEFAULT 'New',   -- New, Contacted, QuoteSent, Converted
    CreatedAt   DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);
```

### Table: Offers
```sql
CREATE TABLE Offers (
    Id          UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    Title       NVARCHAR(200) NOT NULL,
    Discount    NVARCHAR(50)  NOT NULL,   -- e.g. "15% OFF" or "₹500 Back"
    Category    NVARCHAR(100),
    ValidFrom   DATETIME2 NOT NULL,
    ValidTo     DATETIME2 NOT NULL,
    IsActive    BIT NOT NULL DEFAULT 1,
    CouponCode  NVARCHAR(30),
    CreatedAt   DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);
```

### Table: Payments
```sql
CREATE TABLE Payments (
    Id                  UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    UserId              UNIQUEIDENTIFIER NOT NULL REFERENCES Users(Id),
    BookingId           UNIQUEIDENTIFIER REFERENCES Bookings(Id),
    Amount              DECIMAL(10,2) NOT NULL,
    GstAmount           DECIMAL(10,2),
    CouponDiscount      DECIMAL(10,2) DEFAULT 0,
    RazorpayOrderId     NVARCHAR(100),
    RazorpayPaymentId   NVARCHAR(100),
    RazorpaySignature   NVARCHAR(300),
    Status              NVARCHAR(20) NOT NULL DEFAULT 'Pending',  -- Pending, Success, Failed, Refunded
    PaymentMethod       NVARCHAR(30),   -- UPI, Card, NetBanking
    CreatedAt           DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);
```

### Table: Notifications
```sql
CREATE TABLE Notifications (
    Id          UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    UserId      UNIQUEIDENTIFIER REFERENCES Users(Id),   -- NULL = all users
    Title       NVARCHAR(200) NOT NULL,
    Body        NVARCHAR(MAX) NOT NULL,
    Type        NVARCHAR(50) NOT NULL,  -- complaint_registered, payment_success, offer_alert, etc.
    IsRead      BIT DEFAULT 0,
    SentAt      DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    Metadata    NVARCHAR(MAX)   -- JSON: { "complaintId": "...", "bookingId": "..." }
);
```

---

## API Endpoint Map

### Auth
| Method | Endpoint | Description |
|---|---|---|
| POST | `/api/v1/auth/send-otp` | Send Firebase OTP |
| POST | `/api/v1/auth/verify-otp` | Verify OTP + return JWT |
| POST | `/api/v1/auth/refresh` | Refresh JWT token |
| POST | `/api/v1/auth/logout` | Revoke session |

### Users
| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/v1/users/me` | Get own profile |
| PUT | `/api/v1/users/me` | Update profile |
| PUT | `/api/v1/users/me/fcm-token` | Update FCM token |

### Services
| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/v1/services` | List all (with category filter) |
| GET | `/api/v1/services/{id}` | Get service detail |
| POST | `/api/v1/admin/services` | Create service (Admin) |
| PUT | `/api/v1/admin/services/{id}` | Update service (Admin) |
| DELETE | `/api/v1/admin/services/{id}` | Delete service (Admin) |

### Complaints
| Method | Endpoint | Description |
|---|---|---|
| POST | `/api/v1/complaints` | Submit complaint |
| POST | `/api/v1/complaints/{id}/photos` | Upload complaint photos (multipart) |
| GET | `/api/v1/complaints/mine` | Get user's complaint history |
| GET | `/api/v1/admin/complaints` | Get all complaints (Admin) |
| PUT | `/api/v1/admin/complaints/{id}/assign` | Assign employee (Admin) |
| PUT | `/api/v1/admin/complaints/{id}/status` | Update status (Admin) |

### Bookings
| Method | Endpoint | Description |
|---|---|---|
| POST | `/api/v1/bookings/site-visit` | Create site visit booking |
| GET | `/api/v1/bookings/mine` | Get user's bookings |
| GET | `/api/v1/admin/bookings` | Get all bookings (Admin) |
| PUT | `/api/v1/admin/bookings/{id}/status` | Update status (Admin) |

### Building Enquiries
| Method | Endpoint | Description |
|---|---|---|
| POST | `/api/v1/enquiries/building` | Submit enquiry |
| GET | `/api/v1/admin/enquiries` | Get all enquiries (Admin) |
| PUT | `/api/v1/admin/enquiries/{id}/status` | Update status (Admin) |

### Payments
| Method | Endpoint | Description |
|---|---|---|
| POST | `/api/v1/payments/create-order` | Create Razorpay order |
| POST | `/api/v1/payments/verify` | Verify Razorpay payment signature |
| POST | `/api/v1/payments/webhook` | Razorpay webhook handler |
| GET | `/api/v1/payments/mine` | Get user's payment history |

### Notifications
| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/v1/notifications` | Get user's notifications |
| PUT | `/api/v1/notifications/mark-read` | Mark all as read |
| POST | `/api/v1/admin/notifications/send` | Send push to all/segment (Admin) |

### Employees (Admin)
| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/v1/admin/employees` | List all employees |
| POST | `/api/v1/admin/employees` | Onboard employee |
| PUT | `/api/v1/admin/employees/{id}` | Update employee |
| PUT | `/api/v1/admin/employees/{id}/status` | Set availability |

### Offers (Admin)
| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/v1/offers` | Get active offers (Public) |
| POST | `/api/v1/admin/offers` | Create offer |
| PUT | `/api/v1/admin/offers/{id}` | Update offer |
| DELETE | `/api/v1/admin/offers/{id}` | Delete offer |

---

## Razorpay Payment Flow

```
1. Client → POST /api/v1/payments/create-order
           { amount, bookingId, userId }
2. ASP.NET → Razorpay API: create order → returns orderId
3. Client  → Razorpay SDK: opens payment UI (UPI/Card/etc.)
4. Client  → On success: receives { paymentId, orderId, signature }
5. Client  → POST /api/v1/payments/verify
           { paymentId, orderId, signature, bookingId }
6. ASP.NET → Verifies HMAC signature server-side
7. ASP.NET → Marks booking as paid, fires FCM notification
8. Razorpay → Webhook: POST /api/v1/payments/webhook (backup verification)
```

**Business Rule – Site Visit Fee Credit:**
When a booking is marked as `Converted` (project confirmed),
the API automatically creates a `FinalQuotation` record
and deducts the site visit fee paid from the total:
```
finalAmountDue = finalProjectCost - siteVisitFee
```

---

## Firebase FCM Notification Types

| Type | Trigger | Target |
|---|---|---|
| `complaint_registered` | User submits complaint | User |
| `employee_assigned` | Admin assigns employee | User |
| `site_visit_confirmed` | Booking confirmed | User |
| `payment_success` | Payment verified | User |
| `service_completed` | Job marked complete | User |
| `offer_alert` | Admin creates offer | All / Gold members |
| `booking_reminder` | 24h before visit | User |

---

## Node.js Realtime Notification Service

Acts as an intermediary between ASP.NET Core and FCM:
- Receives notification triggers from ASP.NET via HTTP
- Uses `firebase-admin` SDK to send FCM
- Optionally: Maintains Socket.IO connections for real-time in-app alerts

```
ASP.NET Core → HTTP POST → Node.js Service → FCM → Flutter App
```

---

## Security Notes

1. **All admin endpoints** require `role=admin` claim in Firebase JWT
2. **Razorpay signature** must be verified server-side (never trust client-side)
3. **File uploads** must scan for malware before storing in Azure Blob
4. **Rate limiting** on OTP endpoint: max 5 OTP requests per phone per hour
5. **Complaint photos** are stored with randomized blob names (no enumerable URLs)
