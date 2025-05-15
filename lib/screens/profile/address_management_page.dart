
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shop/models/ShippingAddress.dart';
import 'package:shop/services/AddressService.dart';

enum AddressType { home, work, other }

class AddressManagerPage extends StatefulWidget {
  final String customerId;
  final String storeId;
  final String token;

  const AddressManagerPage({
    Key? key,
    required this.customerId,
    required this.storeId,
    required this.token,
  }) : super(key: key);

  @override
  _AddressManagerPageState createState() => _AddressManagerPageState();
}

class _AddressManagerPageState extends State<AddressManagerPage> {
  List<ShippingAddress> _addresses = [];
  bool _isLoading = true;
  String _errorMessage = '';
  ShippingAddress? _addressToEdit;
  LatLng? _selectedLocation;
  AddressType _addressType = AddressType.home;
  LatLng? _currentLocation;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addressNameController = TextEditingController();
  final TextEditingController _streetAddressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAddresses();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل في الحصول على الموقع الحالي: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }



  Future<void> _loadAddresses() async {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        final addresses = await AddressService.fetchAddresses(
          customerId: widget.customerId,
          storeId: widget.storeId,
          token: widget.token,
        );

        setState(() {
          _addresses = addresses;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'فشل في تحميل العناوين: ${e.toString()}';
        });
      }
    }

    void _clearForm() {
      _addressNameController.clear();
      _streetAddressController.clear();
      _cityController.clear();
      _districtController.clear();
      _countryController.clear();
      _descriptionController.clear();
      _addressToEdit = null;
      _selectedLocation = null;
      _addressType = AddressType.home;
    }

    void _fillFormForEdit(ShippingAddress address) {
      _addressNameController.text = address.addressName;
      _streetAddressController.text = address.streetAddress;
      _cityController.text = address.city;
      _districtController.text = address.district;
      _countryController.text = address.country;
      _descriptionController.text = address.description ?? '';
      _addressToEdit = address;

      if (address.location != null) {
        _selectedLocation = LatLng(
          address.location!['latitude'],
          address.location!['longitude'],
        );
      }

      // Set address type
      if (address.addressType != null) {
        _addressType = AddressType.values.firstWhere(
              (e) => e.toString().split('.').last == address.addressType,
          orElse: () => AddressType.home,
        );
      }
    }

    Future<void> _saveAddress() async {
      if (!_formKey.currentState!.validate()) return;

      if (_selectedLocation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('الرجاء تحديد الموقع على الخريطة'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final addressData = {
        "addressName": _addressNameController.text,
        "streetAddress": _streetAddressController.text,
        "city": _cityController.text,
        "district": _districtController.text,
        "country": _countryController.text,
        "description": _descriptionController.text,
        "customerId": widget.customerId,
        "location": {
          "latitude": _selectedLocation!.latitude,
          "longitude": _selectedLocation!.longitude,
        },
      };

      try {
        bool success;
        if (_addressToEdit != null) {
          success = await AddressService.updateAddress(
            addressId: _addressToEdit!.id!,
            token: widget.token,
            address: addressData,
          );
        } else {
          success = await AddressService.addAddress(
            customerId: widget.customerId,
            storeId: widget.storeId,
            token: widget.token,
            address: addressData,
          );
        }

        if (success) {
          Navigator.of(context).pop();
          _loadAddresses();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_addressToEdit != null
                  ? 'تم تحديث العنوان بنجاح'
                  : 'تمت إضافة العنوان بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
          _clearForm();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('فشل في حفظ العنوان'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    Future<LatLng?> _selectLocation() async {
      try {
        final selectedLocation = await Navigator.of(context).push<LatLng>(
          MaterialPageRoute(
            builder: (context) => LocationPickerMap(
              initialLocation: _selectedLocation,
              currentLocation: _currentLocation,
            ),
          ),
        );
        return selectedLocation;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في تحديد الموقع: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        return null;
      }
    }


    String _getAddressTypeName(AddressType type) {
      switch (type) {
        case AddressType.home:
          return 'منزل';
        case AddressType.work:
          return 'عمل';
        case AddressType.other:
          return 'أخرى';
      }
    }

    void _showAddressDialog({ShippingAddress? address}) {
      if (address != null) {
        _fillFormForEdit(address);
      }

      showDialog(
        context: context,
        builder: (context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: Text(
                address != null ? 'تعديل العنوان' : 'إضافة عنوان جديد',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<AddressType>(
                        value: _addressType,
                        items: AddressType.values.map((type) {
                          return DropdownMenuItem<AddressType>(
                            value: type,
                            child: Text(_getAddressTypeName(type)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _addressType = value;
                            });
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: 'نوع العنوان',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          final location = await _selectLocation();
                          if (location != null) {
                            setState(() {
                              _selectedLocation = location;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: Text(
                          _selectedLocation == null
                              ? 'تحديد الموقع على الخريطة'
                              : 'تم تحديد الموقع',
                        ),
                      ),
                      if (_selectedLocation != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'الإحداثيات: ${_selectedLocation!.latitude.toStringAsFixed(4)}, ${_selectedLocation!.longitude.toStringAsFixed(4)}',
                            style: const TextStyle(color: Colors.green),
                          ),
                        ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _addressNameController,
                        label: 'اسم العنوان',
                        validator: (value) => value!.isEmpty ? 'مطلوب' : null,
                      ),
                      _buildTextField(
                        controller: _streetAddressController,
                        label: 'العنوان التفصيلي',
                        validator: (value) => value!.isEmpty ? 'مطلوب' : null,
                      ),
                      _buildTextField(
                        controller: _cityController,
                        label: 'المدينة',
                        validator: (value) => value!.isEmpty ? 'مطلوب' : null,
                      ),
                      _buildTextField(
                        controller: _districtController,
                        label: 'الحي/المنطقة',
                        validator: (value) => value!.isEmpty ? 'مطلوب' : null,
                      ),
                      _buildTextField(
                        controller: _countryController,
                        label: 'البلد',
                        validator: (value) => value!.isEmpty ? 'مطلوب' : null,
                      ),
                      _buildTextField(
                        controller: _descriptionController,
                        label: 'وصف إضافي (اختياري)',
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _clearForm();
                  },
                  child: const Text('إلغاء'),
                ),
                ElevatedButton(
                  onPressed: _saveAddress,
                  child: Text(address != null ? 'حفظ التعديل' : 'حفظ'),
                ),
              ],
            ),
          );
        },
      );
    }

    Widget _buildTextField({
      required TextEditingController controller,
      required String label,
      String? Function(String?)? validator,
      int maxLines = 1,
    }) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          validator: validator,
          maxLines: maxLines,
        ),
      );
    }

    Future<void> _deleteAddress(String addressId) async {
      try {
        final success = await AddressService.deleteAddress(
          addressId: addressId,
          token: widget.token,
        );

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم حذف العنوان بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
          _loadAddresses();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    void _showDeleteDialog(String addressId) {
      showDialog(
        context: context,
        builder: (context) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('حذف العنوان'),
            content: const Text('هل أنت متأكد من رغبتك في حذف هذا العنوان؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _deleteAddress(addressId);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('حذف'),
              ),
            ],
          ),
        ),
      );
    }

    @override
    Widget build(BuildContext context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('إدارة العناوين',
                style: TextStyle(fontWeight: FontWeight.bold)),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  _loadAddresses();
                  _getCurrentLocation();
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddressDialog(),
            child: const Icon(Icons.add),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          body: _buildMainContent(),
        ),
      );
    }

    Widget _buildMainContent() {
      if (_isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (_errorMessage.isNotEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }

      if (_addresses.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_off, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'لا توجد عناوين مسجلة',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _showAddressDialog(),
                child: const Text('إضافة عنوان جديد'),
              ),
            ],
          ),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _addresses.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final address = _addresses[index];
          return _buildAddressCard(address);
        },
      );
    }

    Widget _buildAddressCard(ShippingAddress address) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showAddressDialog(address: address),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _getAddressTypeIcon(address.addressType),
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        address.addressName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _showDeleteDialog(address.id!),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildAddressDetail(Icons.location_on, address.streetAddress),
                _buildAddressDetail(Icons.apartment, '${address.city} - ${address.district}'),
                _buildAddressDetail(Icons.flag, address.country),
                if (address.description?.isNotEmpty ?? false)
                  _buildAddressDetail(Icons.note, address.description!),
              ],
            ),
          ),
        ),
      );
    }

    Widget _buildAddressDetail(IconData icon, String text) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(child: Text(text)),
          ],
        ),
      );
    }

    IconData _getAddressTypeIcon(String? type) {
      switch (type) {
        case 'home':
          return Icons.home;
        case 'work':
          return Icons.work;
        default:
          return Icons.location_pin;
      }
    }
  }

class LocationPickerMap extends StatefulWidget {
  final LatLng? initialLocation;
  final LatLng? currentLocation;

  const LocationPickerMap({
    Key? key,
    this.initialLocation,
    this.currentLocation,
  }) : super(key: key);

  @override
  _LocationPickerMapState createState() => _LocationPickerMapState();
}

class _LocationPickerMapState extends State<LocationPickerMap> {
  final MapController _mapController = MapController();
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
    WidgetsBinding.instance.addPostFrameCallback((_) => _centerMap());
  }

  void _centerMap() {
    final targetLocation = _selectedLocation ?? widget.currentLocation;
    if (targetLocation != null) {
      _mapController.move(targetLocation, 15);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختر الموقع'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (_selectedLocation != null) {
                Navigator.pop(context, _selectedLocation);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('الرجاء تحديد موقع على الخريطة'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: widget.currentLocation ??  LatLng(24.7136, 46.6753),
          zoom: 15.0,
          onTap: (_, latlng) => setState(() => _selectedLocation = latlng),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.app',
          ),
          if (widget.currentLocation != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: widget.currentLocation!,
                  width: 40,
                  height: 40,
                  builder: (ctx) => const Icon(
                    Icons.my_location,
                    color: Colors.blue,
                    size: 40,
                  ),
                ),
              ],
            ),
          if (_selectedLocation != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: _selectedLocation!,
                  width: 50,
                  height: 50,
                  builder: (ctx) => const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 50,
                  ),
                ),
              ],
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _centerMap,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}