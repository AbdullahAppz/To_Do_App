import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/task_model.dart';
import '../providers/task_provider.dart';
import '../utility/empty_widget.dart';
import '../utility/error_widget.dart';
import '../utility/filter_chips.dart';
import '../utility/search_bar.dart';
import '../utility/sort_dropdown.dart';
import '../utility/task_card.dart';
import 'add_edit_task_screen.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController searchController =
  TextEditingController();

  List<TaskModel> filteredTasks = [];

  String selectedFilter = "All";
  String selectedSort = "Newest First";

  @override
  void initState() {
    super.initState();

    searchController.addListener(filterTasks);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<TaskProvider>().loadTasks();

      if (mounted) {
        filterTasks();
      }
    });
  }

  Future<void> loadTasks() async {
    await context.read<TaskProvider>().loadTasks();

    if (mounted) {
      filterTasks();
    }
  }

  void filterTasks() {
    final searchText =
    searchController.text.trim().toLowerCase();

    List<TaskModel> result =
    List<TaskModel>.from(
      context.read<TaskProvider>().tasks,
    );

    // ---------------- SEARCH ----------------

    if (searchText.isNotEmpty) {
      result = result.where((task) {
        return task.title
            .toLowerCase()
            .contains(searchText) ||
            task.description
                .toLowerCase()
                .contains(searchText);
      }).toList();
    }

    // ---------------- FILTER ----------------

    if (selectedFilter == "Pending") {
      result = result
          .where((task) => !task.isCompleted)
          .toList();
    } else if (selectedFilter == "Completed") {
      result = result
          .where((task) => task.isCompleted)
          .toList();
    }

    // ---------------- SORT ----------------

    switch (selectedSort) {
      case "Newest First":
        result.sort(
              (a, b) =>
              b.createdAt.compareTo(a.createdAt),
        );
        break;

      case "Oldest First":
        result.sort(
              (a, b) =>
              a.createdAt.compareTo(b.createdAt),
        );
        break;

      case "A → Z":
        result.sort(
              (a, b) => a.title
              .toLowerCase()
              .compareTo(
            b.title.toLowerCase(),
          ),
        );
        break;

      case "Z → A":
        result.sort(
              (a, b) => b.title
              .toLowerCase()
              .compareTo(
            a.title.toLowerCase(),
          ),
        );
        break;
    }

    if (!mounted) return;

    setState(() {
      filteredTasks = result;
    });
  }

  void changeFilter(String filter) {
    setState(() {
      selectedFilter = filter;
    });

    filterTasks();
  }

  void changeSort(String sort) {
    setState(() {
      selectedSort = sort;
    });

    filterTasks();
  }

  void clearSearch() {
    searchController.clear();
    filterTasks();
  }

  Future<void> openAddTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddEditTaskScreen(),
      ),
    );

    if (result == true && mounted) {
      await loadTasks();
    }
  }

  Future<void> openTask(TaskModel task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TaskDetailScreen(
          task: task,
        ),
      ),
    );

    if (result == true && mounted) {
      await loadTasks();
    }
  }

  int get completedCount {
    return context
        .read<TaskProvider>()
        .tasks
        .where((task) => task.isCompleted)
        .length;
  }

  int get pendingCount {
    return context
        .read<TaskProvider>()
        .tasks
        .where((task) => !task.isCompleted)
        .length;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();

    final tasks = provider.tasks;
    final isLoading = provider.isLoading;
    final error = provider.error;

    return Scaffold(
      backgroundColor: const Color(0xfff7f7f7),

      appBar: AppBar(
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        title: const Text("My Tasks"),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: openAddTask,
        backgroundColor: const Color(0xff795548),
        foregroundColor: Colors.white,
        elevation: 5,
        icon: const Icon(Icons.add),
        label: const Text(
          "Add Task",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isLandscape =
                constraints.maxWidth > constraints.maxHeight;

            return RefreshIndicator(
              onRefresh: loadTasks,

              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),

                padding: const EdgeInsets.only(
                  bottom: 100,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    // =================================================
                    // SEARCH
                    // =================================================

                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        16,
                        isLandscape ? 8 : 16,
                        16,
                        8,
                      ),

                      child: SearchBarWidget(
                        controller: searchController,

                        onChanged: (_) {
                          filterTasks();
                        },

                        onClear: clearSearch,
                      ),
                    ),

                    // =================================================
                    // SUMMARY CARDS
                    // =================================================

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: isLandscape ? 4 : 8,
                      ),

                      child: Row(
                        children: [

                          Expanded(
                            child: _summaryCard(
                              icon: Icons.assignment,
                              title: "Total",
                              value: tasks.length.toString(),
                              isLandscape: isLandscape,
                            ),
                          ),

                          const SizedBox(width: 8),

                          Expanded(
                            child: _summaryCard(
                              icon: Icons.pending_actions,
                              title: "Pending",
                              value: pendingCount.toString(),
                              isLandscape: isLandscape,
                            ),
                          ),

                          const SizedBox(width: 8),

                          Expanded(
                            child: _summaryCard(
                              icon: Icons.check_circle,
                              title: "Done",
                              value: completedCount.toString(),
                              isLandscape: isLandscape,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // =================================================
                    // FILTER
                    // =================================================

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),

                      child: SizedBox(
                        height: isLandscape ? 45 : 52,

                        child: FilterChips(
                          selectedFilter: selectedFilter,
                          onSelected: changeFilter,
                        ),
                      ),
                    ),

                    // =================================================
                    // SORT
                    // =================================================

                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        16,
                        isLandscape ? 4 : 8,
                        16,
                        isLandscape ? 8 : 12,
                      ),

                      child: Row(
                        children: [

                          const Icon(
                            Icons.sort,
                            size: 20,
                          ),

                          const SizedBox(width: 8),

                          const Text(
                            "Sort",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: SortDropdown(
                              selectedSort: selectedSort,
                              onChanged: changeSort,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // =================================================
                    // TASKS
                    // =================================================

                    if (isLoading)

                      const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 100,
                        ),

                        child: Column(
                          children: [
                            CircularProgressIndicator(),

                            SizedBox(height: 15),

                            Text(
                              "Loading your tasks...",
                            ),
                          ],
                        ),
                      )

                    else if (error != null)

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 80,
                        ),

                        child: AppErrorWidget(
                          message: error,
                          onRetry: loadTasks,
                        ),
                      )

                    else if (filteredTasks.isEmpty)

                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 60,
                          ),

                          child: EmptyWidget(
                            title:
                            searchController.text
                                .trim()
                                .isNotEmpty
                                ? "No Results Found"
                                : selectedFilter == "All"
                                ? "No Tasks Yet"
                                : "No $selectedFilter Tasks",

                            message:
                            searchController.text
                                .trim()
                                .isNotEmpty
                                ? "Try a different search term."
                                : selectedFilter == "All"
                                ? "Start by creating your first task."
                                : "There are no tasks in this category.",

                            icon:
                            searchController.text
                                .trim()
                                .isNotEmpty
                                ? Icons.search_off
                                : Icons.assignment_outlined,

                            onAction:
                            selectedFilter == "All" &&
                                searchController.text
                                    .trim()
                                    .isEmpty
                                ? openAddTask
                                : null,

                            actionText: "Add Task",
                          ),
                        )

                      else

                      // =================================================
                      // TASK LIST
                      // =================================================

                        ListView.builder(
                          shrinkWrap: true,

                          physics:
                          const NeverScrollableScrollPhysics(),

                          padding: const EdgeInsets.fromLTRB(
                            16,
                            0,
                            16,
                            20,
                          ),

                          itemCount: filteredTasks.length,

                          itemBuilder: (context, index) {
                            final task =
                            filteredTasks[index];

                            return TweenAnimationBuilder<double>(
                              tween: Tween(
                                begin: 0,
                                end: 1,
                              ),

                              duration: Duration(
                                milliseconds:
                                250 + (index * 50),
                              ),

                              builder:
                                  (context, value, child) {
                                return Opacity(
                                  opacity: value,

                                  child: Transform.translate(
                                    offset: Offset(
                                      0,
                                      20 * (1 - value),
                                    ),

                                    child: child,
                                  ),
                                );
                              },

                              child: TaskCard(
                                task: task,

                                onTap: () =>
                                    openTask(task),
                              ),
                            );
                          },
                        ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  // ==============================================================
  // TASK CONTENT
  // ==============================================================

  Widget _buildTaskContent({
    required bool isLoading,
    required String? error,
  }) {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 15),
            Text(
              "Loading your tasks...",
            ),
          ],
        ),
      );
    }

    if (error != null) {
      return AppErrorWidget(
        message: error,
        onRetry: loadTasks,
      );
    }

    if (filteredTasks.isEmpty) {
      final bool hasSearch =
          searchController.text
              .trim()
              .isNotEmpty;

      return EmptyWidget(
        title: hasSearch
            ? "No Results Found"
            : selectedFilter == "All"
            ? "No Tasks Yet"
            : "No $selectedFilter Tasks",

        message: hasSearch
            ? "Try a different search term."
            : selectedFilter == "All"
            ? "Start by creating your first task."
            : "There are no tasks in this category.",

        icon: hasSearch
            ? Icons.search_off
            : Icons.assignment_outlined,

        onAction:
        selectedFilter == "All" &&
            !hasSearch
            ? openAddTask
            : null,

        actionText: "Add Task",
      );
    }

    return RefreshIndicator(
      onRefresh: loadTasks,

      child: ListView.builder(
        physics:
        const AlwaysScrollableScrollPhysics(),

        padding: const EdgeInsets.fromLTRB(
          16,
          8,
          16,
          100,
        ),

        itemCount: filteredTasks.length,

        itemBuilder: (context, index) {
          final task =
          filteredTasks[index];

          return TweenAnimationBuilder<double>(
            tween: Tween(
              begin: 0,
              end: 1,
            ),

            duration: Duration(
              milliseconds:
              250 + (index * 50),
            ),

            builder:
                (context, value, child) {
              return Opacity(
                opacity: value,

                child:
                Transform.translate(
                  offset: Offset(
                    0,
                    20 * (1 - value),
                  ),

                  child: child,
                ),
              );
            },

            child: TaskCard(
              task: task,
              onTap: () =>
                  openTask(task),
            ),
          );
        },
      ),
    );
  }

  // ==============================================================
  // SUMMARY CARD
  // ==============================================================

  Widget _summaryCard({
    required IconData icon,
    required String title,
    required String value,
    required bool isLandscape,
  }) {
    return Container(
      padding: EdgeInsets.all(
        isLandscape ? 7 : 12,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(14),

        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Icon(
            icon,
            size: isLandscape ? 18 : 22,
          ),

          SizedBox(
            height: isLandscape ? 2 : 5,
          ),

          Text(
            value,
            style: TextStyle(
              fontSize:
              isLandscape ? 16 : 20,
              fontWeight:
              FontWeight.bold,
            ),
          ),

          Text(
            title,
            style: TextStyle(
              fontSize:
              isLandscape ? 10 : 11,
              color:
              Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}