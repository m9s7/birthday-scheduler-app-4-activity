import 'package:birthday_scheduler/models/birthday_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class BirthdayCard extends ConsumerWidget {
  final Birthday bday;

  const BirthdayCard({super.key, required this.bday});

  void navigateToScheduledBirthday(BuildContext context, String id) {
    Routemaster.of(context).push('/scheduled_bday/$id');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // print("${bday.childsName} ${bday.finalized}");
    return GestureDetector(
      onTap: () => navigateToScheduledBirthday(context, bday.id),
      child: Card(
        color: Colors.grey[800],
        shadowColor: Colors.blue[900],
        surfaceTintColor: Colors.blue[900],
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(10), // Round the corners of the card
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${bday.childsName}, ${bday.turningAge}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 8),
                  Text('${bday.date} u ${bday.time}'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on),
                  const SizedBox(width: 8),
                  Expanded(child: Text(bday.location)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.email),
                  const SizedBox(width: 8),
                  Text(bday.email),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.phone),
                  const SizedBox(width: 8),
                  Text(bday.contact),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    'Paket: ',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    bday.package,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  const Text(
                    'Cena: ',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    bday.price,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (bday.entertainers.isNotEmpty) ...[
                const Text('Treneri:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: bday.entertainers.map((e) => Text('• $e')).toList(),
                ),
                const SizedBox(height: 16),
              ],
              if (bday.note.isNotEmpty) ...[
                Text('Napomena: ${bday.note}'),
                const SizedBox(height: 16),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Zakazao/la ${bday.createdBy} ${(bday.createdDate).substring(0, (bday.createdDate).lastIndexOf(':'))}',
                    style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey),
                  ),
                  Container(
                    height: 16,
                    width: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: bday.finalized ? Colors.green : Colors.red,
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
