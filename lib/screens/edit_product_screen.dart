import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../providers/provider.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}
class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _isInit = true;
  bool isLoading = false;
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: ''
  );
  var _initValues = {
    'title':'',
    'description':'',
    'price':'',
    'imageUrl':'',
  };
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    // TODO: implement initState
    super.initState();
  }
  @override
  void didChangeDependencies() {
     if(_isInit){
       final productId =  ModalRoute.of(context).settings.arguments as String;
      if(productId != null){
        _editedProduct = Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description':_editedProduct.description,
          'price':_editedProduct.price.toString(),
         // 'imageUrl':_editedProduct.imageUrl,
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
     }
     _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }
  void _updateImageUrl(){
    if(!_imageUrlFocusNode.hasFocus){
      if(!_imageUrlController.text.startsWith('http') && !_imageUrlController.text.startsWith('https') ||
      (!_imageUrlController.text.endsWith('.png') && !_imageUrlController.text.endsWith('.jpg') && !_imageUrlController.text.endsWith('.jpeg'))
      ){return;}
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    setState(() {
      isLoading = true;
    });
    if(!isValid){return;}
    _form.currentState.save();
    if(_editedProduct.id != null){
      await Provider.of<Products>(context,listen: false)
          .updateProduct(_editedProduct.id,_editedProduct);
    }else{
     try{
       await Provider.of<Products>(context,listen: false)
           .addProduct(_editedProduct);
     }catch (e) {
       await showDialog<Null>(context: context, builder: (ctx) =>
           AlertDialog(
             title: Text('An error occurred!'),
             content: Text('Something went wrong'),
             actions: [
               TextButton(
                 child: Text('Okay'),
                 onPressed: () {
                   Navigator.of(context).pop();
                 },
               ),
             ],
           ));
     }
     // } finally{
     //   setState(() {
     //     isLoading = false;
     //   });
     //   Navigator.of(context).pop();
     // }

      }
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(onPressed: (){
            _saveForm();
           }, icon: Icon(Icons.save)),
        ],
        ),
      body: isLoading ? Center(child: CircularProgressIndicator(),) : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onSaved: (value){
                  _editedProduct = Product(
                      title: value,
                      description: _editedProduct.description,
                     price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                      id: _editedProduct.id,
                      isFavourite: _editedProduct.isFavourite,

                  );
                },
                validator: (value){
                  if(value.isEmpty){
                    return 'Please provide a value';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                onSaved: (value){
                  _editedProduct = Product(
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      price: double.parse(value),
                      imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isFavourite: _editedProduct.isFavourite,
                  );
                },
                validator: (value){
                  if(value.isEmpty){return 'Please enter a price';}
                  if(double.tryParse(value) == null){return 'Please enter a valid number';}
                  if(double.parse(value) <= 0){return 'Please enter a number greater than zero';}
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(labelText: 'Description',
                ),
                maxLines: 3,
                //textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.next,
                validator: (value){
                  if(value.isEmpty){return 'Please enter a description';}
                  if(value.length < 10){return 'Should be at least 10 characters long';}
                  return null;
                  },
                onSaved: (value){
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    description: value,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isFavourite: _editedProduct.isFavourite,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      right: 5,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty 
                        ? Text('Enter a URL')
                        : FittedBox(
                          child: Image.network(_imageUrlController.text,fit: BoxFit.cover,),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      // initialValue: _initValues['imageUrl'],
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      validator: (value){
                        if(value.isEmpty){return 'Please enter a URL';}
                        if(!value.startsWith('http') && !value.startsWith('https')) {return 'Enter a valid URL.';}
                        if(!value.endsWith('.png') && !value.endsWith('.jpg') && !value.endsWith('.jpeg')){return 'Enter a valid image URL';}
                        return null;
                        },
                      onSaved: (value){
                        _editedProduct = Product(
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: value,
                          id: _editedProduct.id,
                          isFavourite: _editedProduct.isFavourite,
                        );
                      },
                      onFieldSubmitted: (_){
                        _saveForm();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

    );
  }
}
