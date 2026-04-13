import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schedule_resolver/screens/task_input_screen.dart';
import '../providers/schedule_provider.dart';
import '../services/ai_schedule_service.dart';
import '../models/task_model.dart';
import 'recommendation_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Color _categoryColor(String category) {
    switch (category) {
      case 'Class':    return const Color(0xFFF472B6);
      case 'Study':    return const Color(0xFFE879B0);
      case 'Org Work': return const Color(0xFFBF5AF2);
      case 'Rest':     return const Color(0xFF64D8C8);
      default:         return const Color(0xFF888896);
    }
  }

  // ── Feature 4: Task Detail Bottom Sheet ──────────────────────────────────
  void _showTaskDetail(BuildContext context, TaskModel task, ScheduleProvider provider) {
    final color = _categoryColor(task.category);
    final isCompleted = provider.isCompleted(task.id);

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1C21),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36, height: 3,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A3A44),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(children: [
                Container(width: 4, height: 44,
                    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(task.title,
                      style: GoogleFonts.dmSans(fontSize: 17, fontWeight: FontWeight.w600,
                          color: const Color(0xFFF1F0F5))),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                  child: Text(task.category,
                      style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
                ),
              ]),
              const SizedBox(height: 20),
              Container(height: 1, color: const Color(0xFF2E2E36)),
              const SizedBox(height: 16),
              _detailRow('Time',
                  '${task.startTime.hour}:${task.startTime.minute.toString().padLeft(2, '0')} — ${task.endTime.hour}:${task.endTime.minute.toString().padLeft(2, '0')}'),
              _detailRow('Urgency',    '${task.urgency} / 5'),
              _detailRow('Importance', '${task.importance} / 5'),
              _detailRow('Energy',     task.energyLevel),
              _detailRow('Effort',     '${task.estimatedEffortHours}h estimated'),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      provider.toggleComplete(task.id);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? const Color(0xFF2E2E36)
                            : const Color(0xFFF472B6).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isCompleted ? const Color(0xFF3A3A44) : const Color(0xFFF472B6),
                          width: 1,
                        ),
                      ),
                      child: Text(isCompleted ? 'Mark Undone' : 'Mark Done',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600,
                              color: isCompleted ? const Color(0xFF666672) : const Color(0xFFF472B6))),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    provider.removeTask(task.id);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A1A1A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF3D2020)),
                    ),
                    child: Text('Delete',
                        style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600,
                            color: const Color(0xFFE05252))),
                  ),
                ),
              ]),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.dmSans(fontSize: 13, color: const Color(0xFF666672))),
          Text(value,  style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w500,
              color: const Color(0xFFF1F0F5))),
        ],
      ),
    );
  }

  // ── Feature 5: Clear All Confirmation ────────────────────────────────────
  void _confirmClearAll(BuildContext context, ScheduleProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C21),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text('Clear all tasks?',
            style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w600,
                color: const Color(0xFFF1F0F5))),
        content: Text('This will permanently remove all tasks from your timeline.',
            style: GoogleFonts.dmSans(fontSize: 13, color: const Color(0xFF888896), height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: GoogleFonts.dmSans(fontSize: 13, color: const Color(0xFF666672))),
          ),
          GestureDetector(
            onTap: () {
              provider.clearAll();
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                color: const Color(0xFF2A1A1A),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF3D2020)),
              ),
              child: Text('Clear All',
                  style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600,
                      color: const Color(0xFFE05252))),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final aiService = Provider.of<AiScheduleServices>(context);

    final sortedTasks = List<TaskModel>.from(scheduleProvider.task);
    sortedTasks.sort((a, b) => a.startTime.hour.compareTo(b.startTime.hour));

    // ── Feature 2: Daily Progress values ─────────────────────────────────
    const totalDayMinutes = 16 * 60;
    final scheduledMinutes = scheduleProvider.scheduledMinutes.clamp(0, totalDayMinutes);
    final progressValue = sortedTasks.isEmpty ? 0.0 : scheduledMinutes / totalDayMinutes;
    final scheduledHours = (scheduledMinutes / 60).toStringAsFixed(1);
    final completedCount = scheduleProvider.completedCount;

    // ── Feature 3: Conflict count ─────────────────────────────────────────
    final conflictCount = scheduleProvider.conflictCount;

    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(children: [
            TextSpan(text: 'Schedule ',
                style: GoogleFonts.dmSans(fontSize: 17, fontWeight: FontWeight.w400,
                    color: const Color(0xFF888896))),
            TextSpan(text: 'Resolver',
                style: GoogleFonts.dmSans(fontSize: 17, fontWeight: FontWeight.w600,
                    color: const Color(0xFFF1F0F5))),
          ]),
        ),
        // ── Feature 5: Clear All in AppBar ───────────────────────────────
        actions: [
          if (sortedTasks.isNotEmpty)
            GestureDetector(
              onTap: () => _confirmClearAll(context, scheduleProvider),
              child: Container(
                margin: const EdgeInsets.only(right: 14),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A1A1A),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF3D2020)),
                ),
                child: Text('Clear',
                    style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w500,
                        color: const Color(0xFFE05252))),
              ),
            ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // ── Feature 2: Daily Progress Bar ────────────────────────────
            if (sortedTasks.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C21),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF2E2E36)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('DAY COVERAGE',
                            style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w500,
                                color: const Color(0xFF666672), letterSpacing: 0.8)),
                        Row(children: [
                          Text('$scheduledHours h scheduled',
                              style: GoogleFonts.dmSans(fontSize: 11, color: const Color(0xFF666672))),
                          const SizedBox(width: 10),
                          Text('$completedCount done',
                              style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w600,
                                  color: const Color(0xFF64D8C8))),
                        ]),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progressValue,
                        minHeight: 6,
                        backgroundColor: const Color(0xFF2E2E36),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF472B6)),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text('${(progressValue * 100).toStringAsFixed(0)}% of waking day',
                        style: GoogleFonts.dmSans(fontSize: 10, color: const Color(0xFF444450))),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],

            // AI Recommendation Banner
            if (aiService.currentAnalysis != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C21),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF472B6).withOpacity(0.35), width: 1),
                ),
                child: Row(children: [
                  Container(width: 6, height: 6,
                      decoration: const BoxDecoration(color: Color(0xFFF472B6), shape: BoxShape.circle)),
                  const SizedBox(width: 10),
                  Expanded(child: Text('Recommendation ready',
                      style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w500,
                          color: const Color(0xFFF9A8D4)))),
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const RecommendationScreen())),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                          color: const Color(0xFFF472B6), borderRadius: BorderRadius.circular(20)),
                      child: Text('View',
                          style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A0010))),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 10),
            ],

            // Section Header
            Padding(
              padding: const EdgeInsets.only(left: 2, bottom: 10, top: 4),
              child: Text(
                sortedTasks.isEmpty
                    ? ''
                    : 'TODAY  —  ${sortedTasks.length} task${sortedTasks.length == 1 ? '' : 's'}',
                style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w500,
                    color: const Color(0xFF555560), letterSpacing: 1.2),
              ),
            ),

            // Task List
            Expanded(
              child: sortedTasks.isEmpty
                  ? Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(width: 56, height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C21),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF2E2E36)),
                      ),
                      child: const Icon(Icons.calendar_today_outlined,
                          color: Color(0xFF444450), size: 22)),
                  const SizedBox(height: 14),
                  Text('No tasks yet',
                      style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w500,
                          color: const Color(0xFF555560))),
                  const SizedBox(height: 4),
                  Text('Tap + to add your first task',
                      style: GoogleFonts.dmSans(fontSize: 12, color: const Color(0xFF3A3A44))),
                ]),
              )
                  : ListView.separated(
                itemCount: sortedTasks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final task = sortedTasks[index];
                  final color = _categoryColor(task.category);
                  final isDone = scheduleProvider.isCompleted(task.id);

                  // ── Feature 4: Tap opens detail sheet ────────────
                  return GestureDetector(
                    onTap: () => _showTaskDetail(context, task, scheduleProvider),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 250),
                      opacity: isDone ? 0.45 : 1.0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C1C21),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF2E2E36), width: 1),
                        ),
                        child: Row(children: [
                          // ── Feature 1: Completion circle toggle ──
                          GestureDetector(
                            onTap: () => scheduleProvider.toggleComplete(task.id),
                            child: Container(
                              width: 20, height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDone
                                    ? const Color(0xFF64D8C8).withOpacity(0.15)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: isDone
                                      ? const Color(0xFF64D8C8)
                                      : const Color(0xFF3A3A44),
                                  width: 1.5,
                                ),
                              ),
                              child: isDone
                                  ? const Icon(Icons.check, size: 12, color: Color(0xFF64D8C8))
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(width: 3, height: 40,
                              decoration: BoxDecoration(
                                  color: color, borderRadius: BorderRadius.circular(2))),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ── Feature 1: Strikethrough when done
                                  Text(task.title,
                                      style: GoogleFonts.dmSans(
                                        fontSize: 14, fontWeight: FontWeight.w500,
                                        color: const Color(0xFFF1F0F5),
                                        decoration: isDone
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                        decorationColor: const Color(0xFF64D8C8),
                                      )),
                                  const SizedBox(height: 3),
                                  Row(children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                          color: color.withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(6)),
                                      child: Text(task.category,
                                          style: GoogleFonts.dmSans(fontSize: 10,
                                              fontWeight: FontWeight.w500, color: color)),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                        '${task.startTime.hour}:${task.startTime.minute.toString().padLeft(2, '0')} — ${task.endTime.hour}:${task.endTime.minute.toString().padLeft(2, '0')}',
                                        style: GoogleFonts.dmSans(fontSize: 11,
                                            color: const Color(0xFF666672))),
                                  ]),
                                ]),
                          ),
                        ]),
                      ),
                    ),
                  );
                },
              ),
            ),

            // ── Feature 3: Resolve Button with conflict badge ─────────────
            if (sortedTasks.isNotEmpty) ...[
              const SizedBox(height: 12),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: aiService.isLoading
                          ? null
                          : () => aiService.analyzeSchedule(scheduleProvider.task),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: aiService.isLoading
                            ? const Color(0xFF2E2E36)
                            : const Color(0xFFF472B6),
                        foregroundColor: const Color(0xFF1A0010),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: aiService.isLoading
                          ? const SizedBox(height: 18, width: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Color(0xFFF472B6)))
                          : Text('Resolve Conflicts with AI',
                          style: GoogleFonts.dmSans(fontWeight: FontWeight.w600,
                              fontSize: 14, color: const Color(0xFF1A0010))),
                    ),
                  ),
                  // ── Feature 3: Red conflict badge ─────────────────────
                  if (conflictCount > 0)
                    Positioned(
                      top: -8,
                      right: -6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE05252),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF0E0E11), width: 2),
                        ),
                        child: Text(
                            '$conflictCount conflict${conflictCount == 1 ? '' : 's'}',
                            style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => TaskInputScreen())),
        child: const Icon(Icons.add, size: 22),
      ),
    );
  }
}