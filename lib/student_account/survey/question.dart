import 'package:flutter/material.dart';
import 'package:wellbeing_app_2/style/app_style.dart';

class Question extends StatefulWidget {
  const Question({
    super.key,
    required this.index,
    required this.questions,
    required this.onChanged,
  });
  final int index;
  final List questions;
  final Function({
    required double? sliderValue,
    required String? answer,
    required String? indepthAnswer,
  }) onChanged;

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  double _sliderValue = 5.0;
  String? _answer;
  String? _indepthAnswer;

  @override
  Widget build(BuildContext context) {
    Color sliderRGBValue = _getColorFromSliderValue();

    return Column(
      children: [
        QuestionTile(sliderRGBValue),
        const SizedBox(height: 10),
      ],
    );
  }

  // ignore: non_constant_identifier_names
  QuestionTile(Color sliderRGBValue) {
    return Container(
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
              const CircleAvatar(
                backgroundColor: Colors.black,
                radius: 10,
                child: Icon(
                  Icons.question_mark_rounded,
                  color: Colors.white,
                  size: 15,
                ),
              ),
              const SizedBox(width: 5),
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
            widget.questions[widget.index]['Question'],
            style: AppStyle.defaultText,
          ),
          if (widget.questions[widget.index]['Scale or Descriptor'] == 'Scale')
            Column(
              children: [
                Slider(
                  value: _sliderValue,
                  activeColor: sliderRGBValue,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  label: _sliderValue.toInt().toString(),
                  onChanged: (value) {
                    setState(() {
                      _sliderValue = value;
                    });
                    widget.onChanged(
                      sliderValue: _sliderValue,
                      answer: _answer,
                      indepthAnswer: _indepthAnswer,
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              ],
            ),
          if (widget.questions[widget.index]['Scale or Descriptor'] ==
              'Descriptor')
            Column(
              children: [
                const SizedBox(height: 5),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Answer Here',
                    hintStyle: AppStyle.defaultText,
                  ),
                  onChanged: (value) {
                    _answer = value;
                    widget.onChanged(
                      sliderValue: _sliderValue,
                      answer: _answer,
                      indepthAnswer: _indepthAnswer,
                    );
                  },
                ),
              ],
            ),
          if (widget.questions[widget.index]['Indepth Question'] != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Text(
                  widget.questions[widget.index]['Indepth Question'],
                  style: AppStyle.defaultText,
                ),
                const SizedBox(height: 5),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Answer Here',
                    hintStyle: AppStyle.defaultText,
                  ),
                  onChanged: (value) {
                    _indepthAnswer = value;
                    widget.onChanged(
                      sliderValue: _sliderValue,
                      answer: _answer,
                      indepthAnswer: _indepthAnswer,
                    );
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }

  Color _getColorFromSliderValue() {
    final hue = (_sliderValue / 10 * 120); // 0-120: red to green
    return HSVColor.fromAHSV(1.0, hue, 1.0, 0.7).toColor();
  }
}
