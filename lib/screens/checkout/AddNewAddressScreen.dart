import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:shop/services/AddressService.dart';
import 'package:shop/services/auth_service.dart';

class AddNewAddressScreen extends StatefulWidget {
  const AddNewAddressScreen({super.key});

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressNameController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _countryController = TextEditingController();
  final _descriptionController = TextEditingController();

  LatLng? _selectedLocation;
  AddressType _addressType = AddressType.home;
  bool _isLoading = false;
  bool _isFetchingLocation = false;

  @override
  void initState() {
    _addressNameController;
    _streetController;
    _cityController;
    _districtController;
    _countryController;
    _descriptionController;
    super.initState();
  }

  Future<void> _fetchAddressDetails(LatLng position) async {
    setState(() => _isFetchingLocation = true);

    try {
      final response = await http.get(Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?'
              'format=json&'
              'lat=${position.latitude}&'
              'lon=${position.longitude}&'
              'addressdetails=1&'
              'accept-language=ar'
      ));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _autoFillAddress(data['address']);
      }
    } catch (e) {
      _showError('تعذر الحصول على تفاصيل العنوان');
    } finally {
      setState(() => _isFetchingLocation = false);
    }
  }

  void _autoFillAddress(Map<String, dynamic> address) {
    setState(() {
      _streetController.text = address['road'] ?? address['village'] ?? '';
      _cityController.text = address['city'] ?? address['state'] ?? '';
      _districtController.text = address['county'] ?? address['region'] ?? '';
      _countryController.text = address['country'] ?? 'اليمن';
      _addressNameController.text = _addressType.displayName;
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best
      );

      setState(() => _selectedLocation = LatLng(
          position.latitude,
          position.longitude
      ));

      await _fetchAddressDetails(_selectedLocation!);

    } on LocationServiceDisabledException {
      _showError('يجب تفعيل خدمة الموقع');
    } catch (e) {
      _showError('خطأ في تحديد الموقع');
    }
  }

  Future<void> _submitAddress() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedLocation == null) {
      _showError('الرجاء تحديد الموقع على الخريطة');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final token = await AuthService.getToken();
      final customerId = await AuthService.getCustomerId();
      final storeId = await AuthService.getStoreId();

      if (customerId == null) throw Exception('Customer ID not found');

      final newAddress = {
        "addressName": _addressNameController.text.trim(),
        "streetAddress": _streetController.text.trim(),
        "city": _cityController.text.trim(),
        "district": _districtController.text.trim(),
        "country": _countryController.text.trim(),
        "description": _descriptionController.text.trim(),
        "location": {
          "latitude": _selectedLocation!.latitude,
          "longitude": _selectedLocation!.longitude,
        },
        "customerId": customerId,
        "addressType": _addressType.name,
      };

      await AddressService.addAddress(
        customerId: customerId,
        storeId: storeId!,
        token: token!,
        address: newAddress,
      );

      if (mounted) Navigator.pop(context, true);

    } catch (e) {
      _showError('حدث خطأ أثناء الحفظ: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة عنوان جديد'),
        actions: [
          IconButton(
            icon: const Icon(Icons.gps_fixed),
            onPressed: _getCurrentLocation,
            tooltip: 'الموقع الحالي',
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildAddressTypeSelector(),
              _buildAddressForm(),
              _buildMapSection(),
              const SizedBox(height: 20),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressTypeSelector() {
    return SegmentedButton<AddressType>(
      segments: AddressType.values.map<ButtonSegment<AddressType>>(
            (type) => ButtonSegment<AddressType>(
          value: type,
          label: Text(type.displayName),
        ),
      ).toList(),
      selected: <AddressType>{_addressType},
      onSelectionChanged: (Set<AddressType> newSelection) {
        setState(() => _addressType = newSelection.first);
        _addressNameController.text = _addressType.displayName;
      },
    );
  }

  Widget _buildAddressForm() {
    return Column(
      children: [
        _buildTextFormField(_addressNameController, 'اسم العنوان'),
        _buildTextFormField(_streetController, 'الشارع'),
        _buildTextFormField(_cityController, 'المدينة'),
        _buildTextFormField(_districtController, 'المنطقة'),
        _buildTextFormField(_countryController, 'الدولة'),
        _buildTextFormField(_descriptionController, 'وصف إضافي (اختياري)', optional: true),
      ],
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String label, {bool optional = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        validator: optional ? null : (value) => value!.isEmpty ? 'حقل مطلوب' : null,
      ),
    );
  }

  Widget _buildMapSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'تحديد الموقع:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Container(
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
            )],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    center: _selectedLocation ??  LatLng(15.3694, 44.1910),
                    zoom: _selectedLocation != null ? 18.0 : 14.0,
                    interactiveFlags: InteractiveFlag.all,
                    onTap: (_, LatLng pos) {
                      setState(() => _selectedLocation = pos);
                      _fetchAddressDetails(pos);
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
                      subdomains: const ['a', 'b', 'c'],
                      userAgentPackageName: 'com.example.shop',
                    ),
                    if (_selectedLocation != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _selectedLocation!,
                            builder: (ctx) => const Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 45,
                            ),
                          )
                        ],
                      ),
                  ],
                ),
                if (_isFetchingLocation)
                  const Center(child: CircularProgressIndicator()),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: FloatingActionButton.small(
                    onPressed: _getCurrentLocation,
                    child: const Icon(Icons.gps_fixed),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton.icon(
      icon: _isLoading
          ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(color: Colors.white))
          : const Icon(Icons.save),
      label: const Text('حفظ العنوان'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: _isLoading ? null : _submitAddress,
    );
  }
}

enum AddressType {
  home('المنزل'),
  work('العمل'),
  other('أخرى');

  final String displayName;
  const AddressType(this.displayName);
}