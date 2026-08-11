import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../models/task_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            title: const Text('SayDone', style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1A1D1E))),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.settings_outlined)),
              const SizedBox(width: 8),
            ],
          ),
          SliverToBoxAdapter(
            child: _UsageCard(count: provider.dailyTasksCount),
          ),
          if (provider.tasks.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.mic_none_rounded, size: 64, color: Colors.black12),
                    SizedBox(height: 16),
                    Text('No tasks yet', style: TextStyle(color: Colors.black38, fontSize: 16)),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _TaskItem(task: provider.tasks[index]),
                  childCount: provider.tasks.length,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () => _showVoiceModal(context),
        backgroundColor: const Color(0xFF5865F2),
        child: const Icon(Icons.mic_rounded, color: Colors.white, size: 36),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showVoiceModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _VoiceModal(),
    );
  }
}

class _UsageCard extends StatelessWidget {
  final int count;
  const _UsageCard({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF5865F2),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: const Color(0xFF5865F2).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Daily Progress', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text('$count / 5 Tasks Used', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  value: count / 5,
                  strokeWidth: 6,
                  backgroundColor: Colors.white24,
                  color: Colors.white,
                ),
              ),
              Text('${(count / 5 * 100).toInt()}%', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

class _TaskItem extends StatelessWidget {
  final Task task;
  const _TaskItem({required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEDF0F7)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: GestureDetector(
          onTap: () => context.read<AppProvider>().toggleTask(task),
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: task.isCompleted ? const Color(0xFF5865F2) : Colors.transparent,
              border: Border.all(color: task.isCompleted ? const Color(0xFF5865F2) : const Color(0xFFCBD5E1), width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: task.isCompleted ? const Icon(Icons.check, size: 18, color: Colors.white) : null,
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            color: task.isCompleted ? Colors.black38 : const Color(0xFF1A1D1E),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.transcription != null)
              Text(task.transcription!, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, color: Colors.black54)),
            const SizedBox(height: 4),
            Text(DateFormat('MMM dd, hh:mm a').format(task.createdAt), style: const TextStyle(fontSize: 11, color: Colors.black26)),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline_rounded, color: Colors.black26, size: 20),
          onPressed: () => context.read<AppProvider>().deleteTask(task.id!),
        ),
      ),
    );
  }
}

class _VoiceModal extends StatefulWidget {
  const _VoiceModal();
  @override
  State<_VoiceModal> createState() => _VoiceModalState();
}

class _VoiceModalState extends State<_VoiceModal> {
  bool _isRecording = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 32),
          Text(_isRecording ? 'Listening...' : 'Ready to listen', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 16),
          const Text('Say something in Arabic or English', style: TextStyle(color: Colors.black38)),
          const Spacer(),
          GestureDetector(
            onTap: () => setState(() => _isRecording = !_isRecording),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: _isRecording ? Colors.red.withOpacity(0.1) : const Color(0xFF5865F2).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(color: _isRecording ? Colors.red : const Color(0xFF5865F2), shape: BoxShape.circle),
                  child: Icon(_isRecording ? Icons.stop_rounded : Icons.mic_rounded, color: Colors.white, size: 32),
                ),
              ),
            ),
          ),
          const Spacer(),
          if (!_isRecording)
            TextButton(
              onPressed: () {
                context.read<AppProvider>().createTask('Call the client', transcription: 'اتصل بالعميل الساعة 5 مساءً');
                Navigator.pop(context);
              },
              child: const Text('Simulate Local AI Processing'),
            ),
        ],
      ),
    );
  }
}
