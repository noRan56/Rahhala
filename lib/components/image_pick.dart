import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImagePickMe extends StatelessWidget {
  final void Function()? pickImage;
  final String? imageUrl;

  const ImagePickMe({Key? key, this.pickImage, this.imageUrl})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pickImage,
      child: Center(
        child: Container(
          width: 200.w,
          height: 200.h,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
            image:
                imageUrl != null
                    ? DecorationImage(
                      image: NetworkImage(imageUrl!),
                      fit: BoxFit.cover,
                    )
                    : null,
          ),
          child:
              imageUrl == null
                  ? const Icon(Icons.camera_alt_outlined, size: 50)
                  : null,
        ),
      ),
    );
  }
}
