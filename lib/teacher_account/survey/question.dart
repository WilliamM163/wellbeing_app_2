import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/style/app_style.dart';

class Question extends StatefulWidget {
  const Question({
    super.key,
    required this.index,
    required this.question,
    this.furtherQuestion,
  });
  final int index;
  final String question;
  final String? furtherQuestion;

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  double _sliderValue = 5.0;

  @override
  Widget build(BuildContext context) {
    Color sliderRGBValue = _getColorFromSliderValue();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.question_mark_rounded),
                  Text(
                    'Question ${widget.index + 1}',
                    style: AppStyle.defaultText.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Text(
                widget.question,
                style: AppStyle.defaultText,
              ),
              Slider(
                value: _sliderValue,
                activeColor: sliderRGBValue,
                min: 0,
                max: 10,
                divisions: 10,
                label: _sliderValue.toInt().toString(),
                onChanged: (value) => setState(() => _sliderValue = value),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.thumb_down_rounded, size: 15),
                      const SizedBox(width: 5),
                      Text(
                        'Poor',
                        style: AppStyle.defaultText.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                  Text(
                    '<- Drag ->',
                    style: AppStyle.defaultText.copyWith(fontSize: 12),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.thumb_up_rounded, size: 15),
                      const SizedBox(width: 5),
                      Text(
                        'Great',
                        style: AppStyle.defaultText.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (widget.furtherQuestion != null)
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    label: Text(widget.furtherQuestion!),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Color _getColorFromSliderValue() {
    final hue = (_sliderValue / 10 * 120); // 0-120: red to green
    return HSVColor.fromAHSV(1.0, hue, 1.0, 0.7).toColor();
  }
}
