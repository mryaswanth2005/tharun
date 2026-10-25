import rawProducts from '@/data/products.json';
import {
  Product,
  Order,
  DealerApplication,
  ServiceBooking,
  DashboardMetrics,
  OrderStatus,
  DealerStatus,
  ServiceStatus,
} from './types';

// Pre-seeded Realistic Orders
const defaultOrders: Order[] = [
  {
    id: 'ord_101',
    orderNumber: 'CAL-ORD-9412',
    userId: 'demo_customer_01',
    userName: 'Rahul Sharma',
    userEmail: 'customer@califnco.com',
    userPhone: '+91 98765 12345',
    isWholesale: false,
    items: [
      {
        productId: 'cal-ro-001',
        sku: 'CAL-RO-AQUAPRO',
        name: 'Califnco AquaPro RO+UV+UF+TDS Water Purifier 10L',
        category: 'RO water purifiers',
        imageUrl: 'https://images.unsplash.com/photo-1542013936693-884638332954?auto=format&fit=crop&w=800&q=80',
        unitPrice: 14999,
        retailPrice: 14999,
        quantity: 1,
        isWholesale: false,
        totalPrice: 14999,
      },
      {
        productId: 'cal-part-001',
        sku: 'CAL-PART-PREHOUSING',
        name: 'Califnco Heavy Duty Pre-Filter Housing Bowl',
        category: 'Replacement cartridges and spare parts',
        imageUrl: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=800&q=80',
        unitPrice: 699,
        retailPrice: 699,
        quantity: 1,
        isWholesale: false,
        totalPrice: 699,
      },
    ],
    subtotal: 15698,
    shippingFee: 0,
    taxAmount: 2825.64,
    totalAmount: 15698,
    shippingAddress: {
      recipientName: 'Rahul Sharma',
      phone: '+91 98765 12345',
      street: 'Flat 402, Green Glen Layout, Bellandur Outer Ring Road',
      landmark: 'Opposite Cloudnine Hospital',
      city: 'Bengaluru',
      state: 'Karnataka',
      pincode: '560103',
    },
    paymentMethod: 'Razorpay Test (UPI / NetBanking)',
    paymentStatus: 'paid',
    paymentId: 'pay_Nzk02948190',
    orderStatus: 'processing',
    createdAt: new Date(Date.now() - 3600000 * 4).toISOString(),
    updatedAt: new Date().toISOString(),
  },
  {
    id: 'ord_102',
    orderNumber: 'CAL-WHL-8821',
    userId: 'demo_dealer_approved',
    userName: 'Apex Water Solutions Ltd',
    userEmail: 'dealer.approved@califnco.com',
    userPhone: '+91 98220 54321',
    isWholesale: true,
    items: [
      {
        productId: 'cal-mem-001',
        sku: 'CAL-MEM-75GPD-VON',
        name: 'Califnco Filmtech High TDS RO Membrane 75 GPD',
        category: 'RO membranes',
        imageUrl: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=800&q=80',
        unitPrice: 950,
        retailPrice: 1499,
        quantity: 20,
        isWholesale: true,
        totalPrice: 19000,
      },
      {
        productId: 'cal-pump-001',
        sku: 'CAL-PUMP-75GPD',
        name: 'Califnco SilentDrive 75 GPD RO Booster Pump 24V DC',
        category: 'Water pumps',
        imageUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?auto=format&fit=crop&w=800&q=80',
        unitPrice: 1050,
        retailPrice: 1599,
        quantity: 10,
        isWholesale: true,
        totalPrice: 10500,
      },
    ],
    subtotal: 29500,
    shippingFee: 0,
    taxAmount: 5310,
    totalAmount: 29500,
    shippingAddress: {
      recipientName: 'Apex Water Solutions (Warehouse)',
      phone: '+91 98220 54321',
      street: 'Plot 42, Phase 2, Peenya Industrial Area',
      city: 'Bengaluru',
      state: 'Karnataka',
      pincode: '560058',
    },
    paymentMethod: 'Bank Wire / Verified Wholesale Credit',
    paymentStatus: 'paid',
    paymentId: 'whl_pay_884129',
    orderStatus: 'confirmed',
    createdAt: new Date(Date.now() - 3600000 * 18).toISOString(),
    updatedAt: new Date().toISOString(),
  },
  {
    id: 'ord_103',
    orderNumber: 'CAL-ORD-7719',
    userId: 'user_priya',
    userName: 'Priya Sundaram',
    userEmail: 'priya.s@gmail.com',
    userPhone: '+91 97410 88990',
    isWholesale: false,
    items: [
      {
        productId: 'cal-uv-001',
        sku: 'CAL-UV-PURESTREAM',
        name: 'Califnco PureStream Stainless Steel UV Purifier 8L',
        category: 'UV water purifiers',
        imageUrl: 'https://images.unsplash.com/photo-1527661591475-527312dd65f5?auto=format&fit=crop&w=800&q=80',
        unitPrice: 8499,
        retailPrice: 8499,
        quantity: 1,
        isWholesale: false,
        totalPrice: 8499,
      },
    ],
    subtotal: 8499,
    shippingFee: 0,
    taxAmount: 1529.82,
    totalAmount: 8499,
    shippingAddress: {
      recipientName: 'Priya Sundaram',
      phone: '+91 97410 88990',
      street: 'Tower 4, Apt 1102, Prestige Shantiniketan, Whitefield',
      city: 'Bengaluru',
      state: 'Karnataka',
      pincode: '560048',
    },
    paymentMethod: 'Razorpay Test (Card)',
    paymentStatus: 'paid',
    paymentId: 'pay_rzp_441209',
    orderStatus: 'dispatched',
    createdAt: new Date(Date.now() - 3600000 * 48).toISOString(),
    updatedAt: new Date().toISOString(),
  },
  {
    id: 'ord_104',
    orderNumber: 'CAL-ORD-6532',
    userId: 'user_anand',
    userName: 'Anand Kumar',
    userEmail: 'anand.k@rediffmail.com',
    userPhone: '+91 98450 33445',
    isWholesale: false,
    items: [
      {
        productId: 'cal-comm-001',
        sku: 'CAL-COMM-RO50',
        name: 'Califnco Commercial 50 LPH RO Plant with SS Skid',
        category: 'Commercial water purification systems',
        imageUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?auto=format&fit=crop&w=800&q=80',
        unitPrice: 38999,
        retailPrice: 38999,
        quantity: 1,
        isWholesale: false,
        totalPrice: 38999,
      },
    ],
    subtotal: 38999,
    shippingFee: 0,
    taxAmount: 7019.82,
    totalAmount: 38999,
    shippingAddress: {
      recipientName: 'Anand Kumar (AeroTech Canteen)',
      phone: '+91 98450 33445',
      street: '14/B, Electronic City Phase 1',
      city: 'Bengaluru',
      state: 'Karnataka',
      pincode: '560100',
    },
    paymentMethod: 'Pay on Installation',
    paymentStatus: 'pending',
    orderStatus: 'placed',
    createdAt: new Date(Date.now() - 3600000 * 2).toISOString(),
    updatedAt: new Date().toISOString(),
  },
];

// Pre-seeded Realistic Dealer Applications
const defaultDealerApplications: DealerApplication[] = [
  {
    id: 'app_001',
    userId: 'demo_dealer_pending',
    contactName: 'Krishna Murthy',
    email: 'dealer.pending@califnco.com',
    phone: '+91 99440 67890',
    companyName: 'Krishna Enterprises & Hardware',
    gstNumber: '36AAAAA0000A1Z5',
    address: 'Shop 12, Main Market Complex, Begumpet, Hyderabad - 500001',
    status: 'pending',
    createdAt: new Date(Date.now() - 3600000 * 6).toISOString(),
  },
  {
    id: 'app_002',
    userId: 'dealer_sri_infra',
    contactName: 'Venkatesh Rao',
    email: 'venkat@sriinfra.in',
    phone: '+91 98860 12000',
    companyName: 'Sri Venkateshwara Water & Plumbing Solutions',
    gstNumber: '29BBBBB1111B1Z2',
    address: 'No. 88, 1st Cross, Gandhi Nagar, Hubli - 580020',
    status: 'pending',
    createdAt: new Date(Date.now() - 3600000 * 22).toISOString(),
  },
  {
    id: 'app_003',
    userId: 'demo_dealer_approved',
    contactName: 'Sanjay Deshmukh',
    email: 'dealer.approved@califnco.com',
    phone: '+91 98220 54321',
    companyName: 'Apex Water Solutions Pvt Ltd',
    gstNumber: '29ABCDE1234F1Z5',
    address: 'Plot 42, Industrial Area, Bangalore - 560058',
    status: 'approved',
    adminDecisionNotes: 'Verified against GST portal. Annual turnover exceeds ₹1.2 Cr. Tier 1 Wholesale pricing authorized.',
    reviewedBy: 'Admin Ops',
    reviewedAt: new Date(Date.now() - 3600000 * 72).toISOString(),
    createdAt: new Date(Date.now() - 3600000 * 96).toISOString(),
  },
];

// Pre-seeded Realistic Service Bookings
const defaultServiceBookings: ServiceBooking[] = [
  {
    id: 'srv_201',
    ticketNumber: 'CAL-SRV-1042',
    userId: 'demo_customer_01',
    customerName: 'Rahul Sharma',
    customerPhone: '+91 98765 12345',
    address: {
      recipientName: 'Rahul Sharma',
      phone: '+91 98765 12345',
      street: 'Flat 402, Green Glen Layout, Bellandur',
      city: 'Bengaluru',
      state: 'Karnataka',
      pincode: '560103',
    },
    serviceType: 'Filter & Membrane Replacement',
    purifierModel: 'Califnco AquaPro RO 10L',
    preferredDate: '26 Oct 2026',
    preferredTimeSlot: '11:00 AM - 01:00 PM',
    status: 'assigned',
    assignedTechnician: 'Suresh Kumar (+91 94480 11223)',
    notes: 'Annual filter change request and TDS calibration.',
    createdAt: new Date(Date.now() - 3600000 * 12).toISOString(),
    updatedAt: new Date().toISOString(),
  },
  {
    id: 'srv_202',
    ticketNumber: 'CAL-SRV-1043',
    userId: 'user_anand',
    customerName: 'Anand Kumar',
    customerPhone: '+91 98450 33445',
    address: {
      recipientName: 'Anand Kumar',
      phone: '+91 98450 33445',
      street: '14/B, Electronic City Phase 1',
      city: 'Bengaluru',
      state: 'Karnataka',
      pincode: '560100',
    },
    serviceType: 'New Purifier Installation',
    purifierModel: 'Califnco Commercial 50 LPH RO Skid',
    preferredDate: '27 Oct 2026',
    preferredTimeSlot: '10:00 AM - 01:00 PM',
    status: 'pending',
    notes: 'Inlet raw water line 1-inch plumbing already prepared. Requires heavy power socket.',
    createdAt: new Date(Date.now() - 3600000 * 2).toISOString(),
    updatedAt: new Date().toISOString(),
  },
  {
    id: 'srv_203',
    ticketNumber: 'CAL-SRV-1044',
    userId: 'user_kavita',
    customerName: 'Kavita Hegde',
    customerPhone: '+91 99000 77889',
    address: {
      recipientName: 'Kavita Hegde',
      phone: '+91 99000 77889',
      street: 'No 45, 12th Main, Indiranagar',
      city: 'Bengaluru',
      state: 'Karnataka',
      pincode: '560038',
    },
    serviceType: 'Breakdown Repair & Troubleshooting',
    purifierModel: 'Califnco Slimline Wall-Mounted RO 8L',
    preferredDate: '26 Oct 2026',
    preferredTimeSlot: '03:00 PM - 06:00 PM',
    status: 'inProgress',
    assignedTechnician: 'Ramesh Babu (+91 98440 44556)',
    notes: 'Pump buzzing sound, water dispense tap dripping constantly.',
    createdAt: new Date(Date.now() - 3600000 * 8).toISOString(),
    updatedAt: new Date().toISOString(),
  },
];

class DataStore {
  private products: Product[] = [];
  private orders: Order[] = [];
  private dealerApplications: DealerApplication[] = [];
  private serviceBookings: ServiceBooking[] = [];
  private isBrowser: boolean = typeof window !== 'undefined';

  constructor() {
    this.init();
  }

  private init() {
    this.products = (rawProducts as any[]).map((p) => ({
      ...p,
      price: Number(p.price),
      dealerPrice: Number(p.dealerPrice),
      stock: Number(p.stock),
      rating: Number(p.rating),
      reviewCount: Number(p.reviewCount),
    }));

    if (this.isBrowser) {
      const savedOrders = localStorage.getItem('califnco_admin_orders');
      this.orders = savedOrders ? JSON.parse(savedOrders) : defaultOrders;

      const savedDealers = localStorage.getItem('califnco_admin_dealers');
      this.dealerApplications = savedDealers ? JSON.parse(savedDealers) : defaultDealerApplications;

      const savedServices = localStorage.getItem('califnco_admin_services');
      this.serviceBookings = savedServices ? JSON.parse(savedServices) : defaultServiceBookings;
    } else {
      this.orders = defaultOrders;
      this.dealerApplications = defaultDealerApplications;
      this.serviceBookings = defaultServiceBookings;
    }
  }

  private persist() {
    if (this.isBrowser) {
      localStorage.setItem('califnco_admin_orders', JSON.stringify(this.orders));
      localStorage.setItem('califnco_admin_dealers', JSON.stringify(this.dealerApplications));
      localStorage.setItem('califnco_admin_services', JSON.stringify(this.serviceBookings));
    }
  }

  public getProducts(): Product[] {
    return this.products;
  }

  public getOrders(): Order[] {
    return this.orders;
  }

  public updateOrderStatus(orderId: string, status: OrderStatus): void {
    const idx = this.orders.findIndex((o) => o.id === orderId);
    if (idx >= 0) {
      this.orders[idx] = {
        ...this.orders[idx],
        orderStatus: status,
        updatedAt: new Date().toISOString(),
      };
      this.persist();
    }
  }

  public getDealerApplications(): DealerApplication[] {
    return this.dealerApplications;
  }

  public decideDealerApplication(
    applicationId: string,
    status: DealerStatus,
    notes: string,
    reviewer: string = 'Califnco Admin'
  ): void {
    const idx = this.dealerApplications.findIndex((a) => a.id === applicationId);
    if (idx >= 0) {
      this.dealerApplications[idx] = {
        ...this.dealerApplications[idx],
        status,
        adminDecisionNotes: notes,
        reviewedBy: reviewer,
        reviewedAt: new Date().toISOString(),
      };
      this.persist();
    }
  }

  public getServiceBookings(): ServiceBooking[] {
    return this.serviceBookings;
  }

  public updateServiceStatus(
    bookingId: string,
    status: ServiceStatus,
    technician?: string
  ): void {
    const idx = this.serviceBookings.findIndex((b) => b.id === bookingId);
    if (idx >= 0) {
      this.serviceBookings[idx] = {
        ...this.serviceBookings[idx],
        status,
        assignedTechnician: technician || this.serviceBookings[idx].assignedTechnician,
        updatedAt: new Date().toISOString(),
      };
      this.persist();
    }
  }

  public getMetrics(): DashboardMetrics {
    const totalRevenue = this.orders
      .filter((o) => o.paymentStatus === 'paid')
      .reduce((sum, o) => sum + o.totalAmount, 0);

    const pendingOrdersCount = this.orders.filter(
      (o) => o.orderStatus === 'placed' || o.orderStatus === 'confirmed' || o.orderStatus === 'processing'
    ).length;

    const approvedDealersCount = this.dealerApplications.filter((a) => a.status === 'approved').length;
    const pendingDealersCount = this.dealerApplications.filter((a) => a.status === 'pending').length;
    const openServiceRequestsCount = this.serviceBookings.filter(
      (b) => b.status === 'pending' || b.status === 'assigned' || b.status === 'inProgress'
    ).length;

    const lowStockProductsCount = this.products.filter((p) => p.stock < 15).length;

    return {
      totalRevenue,
      totalOrdersCount: this.orders.length,
      pendingOrdersCount,
      approvedDealersCount,
      pendingDealersCount,
      openServiceRequestsCount,
      lowStockProductsCount,
    };
  }
}

export const dataStore = new DataStore();
