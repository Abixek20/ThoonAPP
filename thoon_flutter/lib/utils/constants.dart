// ─────────────────────────────────────────────────────────────────────────────
// THOON – App Constants
// ─────────────────────────────────────────────────────────────────────────────

class AppConstants {
  AppConstants._();

  // --- API ---
  static const String apiBaseUrl = 'https://api.thoon.in/api/v1';
  static const int apiTimeoutSeconds = 30;

  // --- App Info ---
  static const String appName = 'THOON';
  static const String appVersion = '1.0.0';
  static const String appTaglineTamil = 'உங்கள் கட்டுமான வேலைகளுக்கு ஒரே நம்பிக்கை';

  // --- Support ---
  static const String supportPhone = '+919876543210';
  static const String supportWhatsApp = '+919876543210';
  static const String supportEmail = 'support@thoon.in';

  // --- Firebase ---
  // NOTE: Replace with your actual Firebase project credentials
  static const String firebaseProjectId = 'thoon-app';

  // --- Razorpay ---
  // NOTE: Replace with your actual Razorpay key
  static const String razorpayKeyId = 'rzp_test_XXXXXXXXXXXXXXXX';

  // --- Complaint Priorities ---
  static const List<String> complaintPriorities = ['Low', 'Medium', 'High', 'Urgent'];

  // --- Service Categories ---
  static const List<String> serviceCategories = [
    'All',
    'Mason Work (Kothanar)',
    'Electrical',
    'Plumbing',
    'Painting',
    'Wall Painting',
    'Tiles',
    'Carpenter',
    'Furniture Works',
    'Interior',
    'Home Decoration',
    'Decorative Statues',
    'Modular Kitchen',
    'False Ceiling',
    'Custom Interior Works',
    'Construction',
    'Building Promoters',
    'Elevation Works',
    'Renovation Works',
    'Swimming Pool Construction',
    'Garden / Landscape Services',
    'House Cleaning Services',
    'Photo Frame Customization',
  ];

  // --- Complaint Categories ---
  static const List<String> complaintCategories = [
    'Mason Work (Kothanar)',
    'Electrical',
    'Plumbing',
    'Painting',
    'Wall Painting',
    'Tiles',
    'Carpenter',
    'Furniture Works',
    'Interior',
    'Construction',
    'Building Promoters',
    'Renovation Works',
    'Swimming Pool Construction',
    'Garden / Landscape Services',
    'House Cleaning Services',
    'General',
  ];

  // --- Project Types (Building Enquiry) ---
  static const List<String> projectTypes = [
    'Residential Building',
    'Commercial Building',
    'Villa / Bungalow',
    'Renovation / Remodel',
    'Interior Fit-out',
    'Industrial / Warehouse',
  ];

  // --- Budget Ranges ---
  static const List<String> budgetRanges = [
    'Under ₹5 Lakhs',
    '₹5 – 15 Lakhs',
    '₹15 – 30 Lakhs',
    '₹30 – 50 Lakhs',
    '₹50 Lakhs – 1 Crore',
    'Above ₹1 Crore',
  ];
}
