
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/Product_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedBrand;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);


    Set<String> brandSet = {};

    for (var product in productProvider.Products) {
      final brand = product['brand'];
      if (brand != null && brand is String && brand.isNotEmpty) {
        brandSet.add(brand);
      }
    }

    List<String> brands = ['All', ...brandSet.toList()];

    if (selectedBrand == null || !brands.contains(selectedBrand)) {
      selectedBrand = 'All';
    }


    List filteredProducts = selectedBrand == 'All'
        ? productProvider.Products
        : productProvider.Products
        .where((product) => product['brand'] == selectedBrand)
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Products',style: TextStyle(fontWeight: FontWeight.w600),),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/search');
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: productProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedBrand,
              items: brands.map((brand) {
                return DropdownMenuItem<String>(
                  value: brand,
                  child: Text(brand),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedBrand = value;
                });
              },
            ),
          ),
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(child: Text("No products found."))
                : ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];

                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: Card(
                    child: ListTile(
                      leading: (product['thumbnail'] != null &&
                          (product['thumbnail'] as String)
                              .isNotEmpty)
                          ? Image.network(
                        product['thumbnail'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) {
                          return const Icon(
                              Icons.broken_image);
                        },
                      )
                          : const Icon(Icons.image_not_supported),
                      title: Text(
                        product['title'] ?? 'No Title',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        "₹ ${product['price']?.toString() ?? 'N/A'}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
