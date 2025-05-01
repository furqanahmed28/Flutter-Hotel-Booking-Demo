import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
void main() {
  timeDilation = 1.5; // Slows down Hero animations
  runApp(const MyApp());
}
class Hotel {
  final String name, city, image;
  final int price;
  Hotel({required this.name, required this.city, required this.image, required this.price});
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hotel App',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal)),
      home: const HomePage(),
    );
  }
}
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  final hotels = [
    Hotel(name: "Pearl Continental", city: "Karachi", image: "images/PC.jpg", price: 18000),
    Hotel(name: "Movenpick Hotel", city: "Karachi", image: "images/mnp.jpg", price: 20000),
    Hotel(name: "Marriott", city: "Karachi", image: "images/mariott.jpg", price: 17000),
  ];
  final booked = <Hotel>[];
  void _goToBookings() => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => BookingsPage(bookings: booked, onRemove: (h) {
        setState(() => booked.remove(h));
      }),
    ),
  );
  void _goToDetails(Hotel h) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailPage(hotel: h, onBook: () {
          setState(() => booked.add(h));
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Hotel booked!")),
          );
        }),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hotels"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Stack(
            children: [
              IconButton(icon: const Icon(Icons.shopping_cart), onPressed: _goToBookings),
              if (booked.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text("${booked.length}", style: const TextStyle(fontSize: 12, color: Colors.white)),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: hotels.length,
        itemBuilder: (_, i) {
          final h = hotels[i];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: Hero(tag: h.image, child: Image.asset(h.image, width: 60, height: 60, fit: BoxFit.cover)),
              title: Text(h.name),
              subtitle: Text("${h.city} • Rs ${h.price}"),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () => _goToDetails(h),
            ),
          );
        },
      ),
    );
  }
}
class DetailPage extends StatelessWidget {
  final Hotel hotel;
  final VoidCallback? onBook;
  const DetailPage({super.key, required this.hotel, required this.onBook});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(hotel.name), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Hero(tag: hotel.image, child: Image.asset(hotel.image, height: 250, fit: BoxFit.cover)),
          const SizedBox(height: 20),
          Center(child: Text(hotel.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
          Center(child: Text(hotel.city, style: const TextStyle(fontSize: 18, color: Colors.grey))),
          const SizedBox(height: 20),
          Center(child: Text("Rs ${hotel.price} / night", style: const TextStyle(fontSize: 20))),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: ElevatedButton.icon(
              onPressed: onBook,
              icon: const Icon(Icons.check, color: Colors.black),
              label: const Text("Book Now"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                foregroundColor: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class BookingsPage extends StatefulWidget {
  final List<Hotel> bookings;
  final Function(Hotel) onRemove;
  const BookingsPage({super.key, required this.bookings, required this.onRemove});
  @override
  State<BookingsPage> createState() => _BookingsPageState();
}
class _BookingsPageState extends State<BookingsPage> {
  @override
  Widget build(BuildContext context) {
    final total = widget.bookings.fold<int>(0, (sum, h) => sum + h.price);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Bookings"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: widget.bookings.isEmpty
          ? const Center(child: Text("No bookings yet."))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.bookings.length,
                    itemBuilder: (context, i) {
                      final h = widget.bookings[i];
                      return ListTile(
                        leading: Hero(
                          tag: h.image,
                          child: Image.asset(h.image, width: 50, height: 50, fit: BoxFit.cover),
                        ),
                        title: Text(h.name),
                        subtitle: Text("Rs ${h.price}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              widget.onRemove(h);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    "Total: Rs $total",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
    );
  }
}
