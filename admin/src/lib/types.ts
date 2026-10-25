export type UserRole = 'customer' | 'dealer' | 'admin';
export type DealerStatus = 'pending' | 'approved' | 'rejected';

export interface Product {
  id: string;
  sku: string;
  name: string;
  category: string;
  brand: string;
  description: string;
  price: number;
  dealerPrice: number;
  stock: number;
  rating: number;
  reviewCount: number;
  specifications: Record<string, string>;
  imageUrl: string;
  isActive: boolean;
}

export type OrderStatus =
  | 'placed'
  | 'confirmed'
  | 'processing'
  | 'dispatched'
  | 'delivered'
  | 'cancelled';

export interface OrderItem {
  productId: string;
  sku: string;
  name: string;
  category: string;
  imageUrl: string;
  unitPrice: number;
  retailPrice: number;
  quantity: number;
  isWholesale: boolean;
  totalPrice: number;
}

export interface ShippingAddress {
  recipientName: string;
  phone: string;
  street: string;
  landmark?: string;
  city: string;
  state: string;
  pincode: string;
  latitude?: number;
  longitude?: number;
}

export interface Order {
  id: string;
  orderNumber: string;
  userId: string;
  userName: string;
  userEmail: string;
  userPhone: string;
  isWholesale: boolean;
  items: OrderItem[];
  subtotal: number;
  shippingFee: number;
  taxAmount: number;
  totalAmount: number;
  shippingAddress: ShippingAddress;
  paymentMethod: string;
  paymentStatus: string;
  paymentId?: string;
  orderStatus: OrderStatus;
  createdAt: string;
  updatedAt: string;
}

export interface DealerApplication {
  id: string;
  userId: string;
  contactName: string;
  email: string;
  phone: string;
  companyName: string;
  gstNumber: string;
  address: string;
  status: DealerStatus;
  adminDecisionNotes?: string;
  reviewedBy?: string;
  reviewedAt?: string;
  createdAt: string;
}

export type ServiceStatus = 'pending' | 'assigned' | 'inProgress' | 'completed' | 'cancelled';

export interface ServiceBooking {
  id: string;
  ticketNumber: string;
  userId: string;
  customerName: string;
  customerPhone: string;
  address: ShippingAddress;
  serviceType: string;
  purifierModel: string;
  preferredDate: string;
  preferredTimeSlot: string;
  status: ServiceStatus;
  assignedTechnician?: string;
  notes?: string;
  createdAt: string;
  updatedAt: string;
}

export interface DashboardMetrics {
  totalRevenue: number;
  totalOrdersCount: number;
  pendingOrdersCount: number;
  approvedDealersCount: number;
  pendingDealersCount: number;
  openServiceRequestsCount: number;
  lowStockProductsCount: number;
}
