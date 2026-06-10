import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:wenshiji/common/logger.dart';
import 'package:wenshiji/models/event.dart';
import 'package:wenshiji/providers/event.dart';

const _bg = Color(0xFFFFF9EE);
const _surface = Color(0xFFFFFFFF);
const _surfaceWarm = Color(0xFFFFF6E0);
const _fg = Color(0xFF3D2E1E);
const _fgSecondary = Color(0xFF8B7355);
const _fgTertiary = Color(0xFFB8A48A);
const _border = Color(0xFFF0E4CF);
const _borderLight = Color(0xFFF7EDDA);
const _accent = Color(0xFFE8A840);
const _accentLight = Color(0xFFFFF1D6);
const _accentDeep = Color(0xFFD4922E);
const _tagBirthday = Color(0xFFFF9A76);
const _tagTask = Color(0xFF7EB5E0);
const _tagCountup = Color(0xFF8BC48A);
const _tagStar = Color(0xFFF0C75E);
const _tagHoliday = Color(0xFFC48AD0);
const _checkinBg = Color(0xFFE8F5E3);
const _checkinFg = Color(0xFF5A9E4F);
const _danger = Color(0xFFE06060);
const _dangerLight = Color(0xFFFFF0F0);

class ArchiveScreen extends ConsumerStatefulWidget {
  const ArchiveScreen({super.key});

  @override
  ConsumerState<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends ConsumerState<ArchiveScreen> {
  EventCategory _currentCategory = EventCategory.all;
  String _searchQuery = '';
  //bool _batchMode = false;
  final Set<String> _selectedIds = {};

  bool _showToast = false;
  String _toastMessage = '';

  bool _isModalVisible = false;
  String _modalTitle = '';
  String _modalDesc = '';
  String _modalConfirmText = '';
  VoidCallback? _modalCallback;

  // bool _showContextMenu = false;
  // int? _contextTargetId;
  // Offset _contextMenuOffset = Offset.zero;
  final categoryTabs = [
    (EventType.birthday, '生日'),
    (EventType.task, '事项'),
    (EventType.dailySignIn, '连签计时'),
    (EventType.holiday, '节日'),
  ];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_handleSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final archivedEvents = ref.watch(
      filteredEventsProvider(filterType: FilterType.archived),
    );
    AppLogger().info('archivedEvents: $archivedEvents');
    final filteredData = _getFilteredData(archivedEvents);
    AppLogger().info('filteredData: $filteredData');
    final hasData = filteredData.isNotEmpty;
    final now = DateTime.now();
    final monthCount = filteredData.where((item) {
      final d = item.nextEffectiveTime;
      return d.month == now.month && d.year == now.year;
    }).length;

    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildTopNav(),
                Expanded(
                  child: _buildScrollContent(hasData, monthCount, filteredData),
                ),
              ],
            ),
          ),
          //_buildBatchBar(),
          if (_isModalVisible) _buildModalOverlay(),
          //if (_showContextMenu) _buildContextMenu(),
          _buildToast(),
        ],
      ),
    );
  }

  Widget _buildTopNav() {
    return Container(
      color: _bg,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      // child: Row(
      //   children: [
      //     _buildBackButton(),
      //     const SizedBox(width: 16),
      //     const Expanded(
      //       child: Center(
      //         child: Text(
      //           '归档记录',
      //         style: TextStyle(
      //           fontSize: 17,
      //           fontWeight: FontWeight.w600,
      //           color: _fg,
      //           letterSpacing: 0.3,
      //         ),
      //       ),
      //     )),
      child: Stack(
        children: [
          Align(alignment: Alignment.centerLeft, child: _buildBackButton()),
          // 居中
          SizedBox(
            height: 36,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                '归档记录',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: _fg,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ],
      ),

      // InkWell(
      //   onTap: _toggleBatch,
      //   borderRadius: BorderRadius.circular(8),
      //   child: Container(
      //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      //     child: Text(
      //       _batchMode ? '取消' : '批量管理',
      //       style: TextStyle(
      //         fontSize: 13,
      //         color: _batchMode ? _danger : _accentDeep,
      //         fontWeight: FontWeight.w500,
      //       ),
      //     ),
      //   ),
      // ),
      // ],
      // ),
    );
  }

  Widget _buildBackButton() {
    return InkWell(
      onTap: () => context.pop(),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
        child: const Center(
          child: Icon(Icons.arrow_back_ios, size: 22, color: _fg),
        ),
      ),
    );
  }

  Widget _buildScrollContent(
    bool hasData,
    int monthCount,
    List<Event> filteredData,
  ) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 24 + 60),
      children: [
        if (_searchQuery.isEmpty) _buildStatsCard(monthCount, filteredData),
        _buildFilterSection(),
        if (hasData) ...[
          _buildArchiveList(filteredData),
          _buildBottomClear(),
        ] else
          _buildEmptyState(),
      ],
    );
  }

  Widget _buildStatsCard(int monthCount, List<Event> filteredData) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: _surfaceWarm,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(61, 46, 30, 0.06),
            offset: Offset(0, 2),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(filteredData.length.toString(), '累计归档'),
          ),
          Expanded(child: _buildStatItem(monthCount.toString(), '本月归档')),
        ],
      ),
    );
  }

  Widget _buildStatItem(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: _accentDeep,
            height: 1.2,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12, color: _fgTertiary)),
      ],
    );
  }

  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBox(),
          const SizedBox(height: 10),
          _buildCategoryTabs(),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: _surface,
        border: Border.all(color: _border, width: 1.5),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          const Icon(Icons.search, size: 18, color: _fgTertiary),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: '搜索事件名称或备注',
                hintStyle: TextStyle(color: _fgTertiary),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(fontSize: 14, color: _fg),
            ),
          ),
          if (_searchQuery.isNotEmpty)
            GestureDetector(
              onTap: _clearSearch,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: _border,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    '✕',
                    style: TextStyle(fontSize: 11, color: _fgSecondary),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    final tabs = [
      (EventCategory.all, '全部'),
      (EventCategory.birthday, '生日'),
      (EventCategory.task, '事项'),
      (EventCategory.dailySignIn, '连签计时'),
      (EventCategory.star, '星标'),
      (EventCategory.holiday, '节日'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: tabs.map((tab) {
          final isActive = _currentCategory == tab.$1;
          return Padding(
            padding: const EdgeInsets.only(right: 4),
            child: InkWell(
              onTap: () => setState(() => _currentCategory = tab.$1),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: isActive ? _accentLight : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tab.$2,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive ? _accentDeep : _fgSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildArchiveList(List<Event> filteredData) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: filteredData.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return _buildEvent(item, index);
        }).toList(),
      ),
    );
  }

  Widget _buildEvent(Event item, int index) {
    final isSelected = _selectedIds.contains(item.id);
    final tagColor = _getCategoryColor(item);
    final tagBgColor = _getCategoryBgColor(item);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeInOutCubic,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(61, 46, 30, 0.06),
            offset: Offset(0, 2),
            blurRadius: 12,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _openDetail(item.id),
          //onLongPress: () => _startLongPress(item),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // if (_batchMode)
                //   Padding(
                //     padding: const EdgeInsets.only(top: 8, right: 10),
                //     child: _buildCheckbox(
                //       isSelected,
                //       () => _toggleSelect(item.id),
                //     ),
                //   ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: _fg,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),

                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: tagBgColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              categoryTabs
                                  .firstWhere((tab) => tab.$1 == item.type)
                                  .$2,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: tagColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Text(
                      //   item.status == EventStatus.auto ? '已到期自动归档' : '手动归档',
                      //   style: const TextStyle(
                      //     fontSize: 11,
                      //     color: _fgTertiary,
                      //   ),
                      // ),
                      if (item.type == EventType.dailySignIn) ...[
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _checkinBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                size: 12,
                                color: _checkinFg,
                              ),
                              const SizedBox(width: 3),

                              Text(
                                '累计打卡${item.checkinStreakCount}天',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: _checkinFg,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 3),
                      Text(
                        DateFormat('yyyy-MM-dd').format(item.date).toString(),
                        style: const TextStyle(
                          fontSize: 11,
                          color: _fgTertiary,
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // _buildSmallButton(
                    //   '恢复',
                    //   _accentLight,
                    //   _accentDeep,
                    //   () => _restoreItem(item.id),
                    // ),
                    const SizedBox(height: 6),
                    _buildSmallButton(
                      '删除',
                      _dangerLight,
                      _danger,
                      () => _deleteItem(item.id),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox(bool isChecked, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: isChecked ? _accent : _surface,
          border: Border.all(color: isChecked ? _accent : _border, width: 2),
          borderRadius: BorderRadius.circular(11),
        ),
        child: isChecked
            ? const Center(
                child: Text(
                  '✓',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildSmallButton(
    String text,
    Color bgColor,
    Color textColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomClear() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 16),
      child: Center(
        child: InkWell(
          onTap: _showClearAllModal,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Text(
              '清空全部归档记录',
              style: TextStyle(
                fontSize: 13,
                color: _danger.withValues(alpha: 0.7),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.only(top: 80, left: 40, right: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: CustomPaint(painter: _EmptyIconPainter()),
          ),
          const SizedBox(height: 20),
          Text(
            '暂无归档记录',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: _fgSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '完结的事件会自动收纳在这里',
            style: TextStyle(fontSize: 13, color: _fgTertiary, height: 1.6),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Widget _buildBatchBar() {
  //   final filteredData = _getFilteredData();
  //   final allSelected =
  //       _selectedIds.length == filteredData.length && filteredData.isNotEmpty;

  //   return AnimatedPositioned(
  //     duration: const Duration(milliseconds: 300),
  //     curve: Curves.easeInOutCubic,
  //     bottom: _batchMode ? 0 : -100,
  //     left: 0,
  //     right: 0,
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: _surface,
  //         border: Border(top: BorderSide(color: _border)),
  //       ),
  //       padding: EdgeInsets.only(
  //         left: 16,
  //         right: 16,
  //         top: 10,
  //         bottom: 10 + MediaQuery.of(context).viewInsets.bottom + 24,
  //       ),
  //       child: SafeArea(
  //         top: false,
  //         child: Row(
  //           children: [
  //             Row(
  //               children: [
  //                 GestureDetector(
  //                   onTap: _toggleSelectAll,
  //                   child: Row(
  //                     children: [
  //                       _buildCheckbox(allSelected, _toggleSelectAll),
  //                       const SizedBox(width: 6),
  //                       Text(
  //                         '全选',
  //                         style: const TextStyle(fontSize: 14, color: _fg),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 const SizedBox(width: 16),
  //                 Text(
  //                   '已选 ${_selectedIds.length} 项',
  //                   style: const TextStyle(fontSize: 13, color: _fgTertiary),
  //                 ),
  //               ],
  //             ),
  //             const Spacer(),
  //             Row(
  //               children: [
  //                 _buildBatchButton(
  //                   '恢复',
  //                   _accentLight,
  //                   _accentDeep,
  //                   _batchRestore,
  //                 ),
  //                 const SizedBox(width: 8),
  //                 _buildBatchButton('删除', _dangerLight, _danger, _batchDelete),
  //                 const SizedBox(width: 8),
  //                 _buildBatchButton(
  //                   '取消',
  //                   _borderLight,
  //                   _fgSecondary,
  //                   _toggleBatch,
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildBatchButton(
  //   String text,
  //   Color bgColor,
  //   Color textColor,
  //   VoidCallback onTap,
  // ) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //       decoration: BoxDecoration(
  //         color: bgColor,
  //         borderRadius: BorderRadius.circular(8),
  //       ),
  //       child: Text(
  //         text,
  //         style: TextStyle(
  //           fontSize: 13,
  //           fontWeight: FontWeight.w500,
  //           color: textColor,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildModalOverlay() {
    return GestureDetector(
      onTap: _hideModal,
      child: Container(
        color: _fg.withValues(alpha: 0.35),
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: AnimatedScale(
              scale: _isModalVisible ? 1 : 0.92,
              duration: const Duration(milliseconds: 350),
              curve: Curves.elasticOut,
              child: Container(
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(61, 46, 30, 0.18),
                      offset: Offset(0, 8),
                      blurRadius: 40,
                    ),
                  ],
                ),
                margin: const EdgeInsets.symmetric(horizontal: 36),
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _modalTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _fg,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _modalDesc,
                      style: const TextStyle(
                        fontSize: 13,
                        color: _fgSecondary,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: _buildModalButton(
                            '取消',
                            _borderLight,
                            _fgSecondary,
                            _hideModal,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildModalButton(
                            _modalConfirmText,
                            _danger,
                            Colors.white,
                            _confirmModal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModalButton(
    String text,
    Color bgColor,
    Color textColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // Widget _buildContextMenu() {
  //   return GestureDetector(
  //     onTap: _hideContextMenu,
  //     child: Container(
  //       color: Colors.transparent,
  //       child: Stack(
  //         children: [
  //           Positioned(
  //             left: _contextMenuOffset.dx,
  //             top: _contextMenuOffset.dy,
  //             child: AnimatedScale(
  //               scale: _showContextMenu ? 1 : 0.9,
  //               duration: const Duration(milliseconds: 200),
  //               curve: Curves.elasticOut,
  //               alignment: Alignment.topLeft,
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   color: _surface,
  //                   borderRadius: BorderRadius.circular(14),
  //                   boxShadow: const [
  //                     BoxShadow(
  //                       color: Color.fromRGBO(61, 46, 30, 0.18),
  //                       offset: Offset(0, 8),
  //                       blurRadius: 40,
  //                     ),
  //                   ],
  //                 ),
  //                 padding: const EdgeInsets.symmetric(vertical: 6),
  //                 constraints: const BoxConstraints(minWidth: 140),
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     // _buildContextMenuItem(
  //                     //   '恢复',
  //                     //   Icons.restore,
  //                     //   false,
  //                     //   () => _contextAction('restore'),
  //                     // ),
  //                     _buildContextMenuItem(
  //                       '彻底删除',
  //                       Icons.delete_outline,
  //                       true,
  //                       () => _contextAction('delete'),
  //                     ),
  //                     _buildContextMenuItem(
  //                       '查看详情',
  //                       Icons.visibility_outlined,
  //                       false,
  //                       () => _contextAction('detail'),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildContextMenuItem(
    String label,
    IconData icon,
    bool isDanger,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isDanger ? _danger : _fg),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(fontSize: 14, color: isDanger ? _danger : _fg),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToast() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      top: 44 + 56,
      left: 0,
      right: 0,
      child: Center(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _showToast ? 1 : 0,
          child: AnimatedSlide(
            offset: Offset(0, _showToast ? 0 : -0.5),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              decoration: BoxDecoration(
                color: _fg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _toastMessage,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(Event event) {
    if (event.isStarred) {
      return _tagStar;
    }
    if (event.type == EventType.birthday) {
      return _tagBirthday;
    }
    if (event.type == EventType.task) {
      return _tagTask;
    }
    if (event.type == EventType.dailySignIn) {
      return _tagCountup;
    }
    if (event.type == EventType.holiday) {
      return _tagHoliday;
    }

    return _fgTertiary;
  }

  Color _getCategoryBgColor(Event event) {
    if (event.isStarred) {
      return const Color(0xFFFFF8E0);
      ;
    }
    if (event.type == EventType.birthday) {
      return const Color(0xFFFFF0E8);
      ;
    }
    if (event.type == EventType.task) {
      return const Color(0xFFE8F2FB);
    }
    if (event.type == EventType.dailySignIn) {
      return _checkinBg;
    }
    if (event.type == EventType.holiday) {
      return const Color(0xFFF5EAF8);
    }

    return _borderLight;
  }

  bool checkType(Event item, EventCategory category) {
    switch (category) {
      case EventCategory.birthday:
        return item.type == EventType.birthday;
      case EventCategory.task:
        return item.type == EventType.task;
      case EventCategory.dailySignIn:
        return item.type == EventType.dailySignIn;
      case EventCategory.star:
        return item.isStarred;
      case EventCategory.holiday:
        return item.type == EventType.holiday;
      case EventCategory.all:
        return true;
    }
  }

  List<Event> _getFilteredData(List<Event> data) {
    return data.where((item) {
      final catMatch = checkType(item, _currentCategory);
      final searchMatch =
          _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery.toLowerCase());
      return catMatch && searchMatch;
    }).toList();
  }

  void _handleSearch() {
    setState(() {
      _searchQuery = _searchController.text.trim();
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
    });
  }

  void _toggleSelect(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  // void _toggleSelectAll() {
  //   final filtered = _getFilteredData();
  //   if (_selectedIds.length == filtered.length) {
  //     setState(() => _selectedIds.clear());
  //   } else {
  //     setState(() => _selectedIds.addAll(filtered.map((item) => item.id)));
  //   }
  // }

  // void _toggleBatch() {
  //   setState(() {
  //     _batchMode = !_batchMode;
  //     _selectedIds.clear();
  //   });
  // }

  void _openDetail(String id) {
    context.push('/event-detail/$id');
  }

  // void _restoreItem(String id) {
  //   final item = _archiveData.firstWhere((i) => i.id == id);
  //   setState(() => _archiveData.removeWhere((i) => i.id == id));
  //   _showToastMsg('已恢复「${item.name}」');
  // }

  void _deleteItem(String id) {
    //final item = _archiveData.firstWhere((i) => i.id == id);
    final item = ref
        .read(filteredEventsProvider(filterType: FilterType.archived))
        .firstWhere((i) => i.id == id);
    _showModalDialog(
      '确认删除',
      '是否永久删除「${item.name}」的归档记录？删除后数据不可恢复。',
      '确认删除',
      () async {
        await ref.read(eventProvider.notifier).deleteEvent(id);

        // setState(() => _archiveData.removeWhere((i) => i.id == id));
        _showToastMsg('已永久删除');
      },
    );
  }

  // void _batchRestore() {
  //   if (_selectedIds.isEmpty) {
  //     _showToastMsg('请先选择条目');
  //     return;
  //   }
  //   final count = _selectedIds.length;
  //   setState(() {
  //     _archiveData.removeWhere((item) => _selectedIds.contains(item.id));
  //     _selectedIds.clear();
  //     _batchMode = false;
  //   });
  //   _showToastMsg('已恢复 $count 条记录');
  // }

  // void _batchDelete() {
  //   if (_selectedIds.isEmpty) {
  //     _showToastMsg('请先选择条目');
  //     return;
  //   }
  //   final count = _selectedIds.length;
  //   _showModalDialog('批量删除确认', '是否永久删除已选的 $count 条归档记录？删除后数据不可恢复。', '确认删除', () {
  //     setState(() {
  //       _archiveData.removeWhere((item) => _selectedIds.contains(item.id));
  //       _selectedIds.clear();
  //       _batchMode = false;
  //     });
  //     _showToastMsg('已永久删除 $count 条记录');
  //   });
  // }

  //todo 清空全部归档记录后，需要更新本地存储
  void _showClearAllModal() {
    _showModalDialog(
      '清空全部归档记录',
      '清空后所有归档历史、打卡记录、事件数据将永久删除，无法恢复，是否继续？',
      '全部清空',
      () async {
        await ref.read(eventProvider.notifier).deleteAllArchivedEvent();
        _showToastMsg('已清空全部归档记录');
      },
    );
  }

  void _showModalDialog(
    String title,
    String desc,
    String confirmText,
    VoidCallback callback,
  ) {
    setState(() {
      _modalTitle = title;
      _modalDesc = desc;
      _modalConfirmText = confirmText;
      _modalCallback = callback;
      _isModalVisible = true;
    });
  }

  void _hideModal() {
    setState(() => _isModalVisible = false);
  }

  void _confirmModal() {
    if (_modalCallback != null) {
      _modalCallback!();
    }
    _hideModal();
  }

  // void _startLongPress(Event item) {
  //   if (_batchMode) return;
  //   final RenderBox box = context.findRenderObject() as RenderBox;
  //   final position = box.localToGlobal(Offset.zero);
  //   final screenHeight = MediaQuery.of(context).size.height;

  //   double top = position.dy + 150;
  //   double left = position.dx + 30;

  //   if (top + 150 > screenHeight) top = top - 160;
  //   if (left + 160 > MediaQuery.of(context).size.width) {
  //     left = MediaQuery.of(context).size.width - 170;
  //   }

  //   setState(() {
  //     _contextTargetId = item.id;
  //     _contextMenuOffset = Offset(left, top);
  //     _showContextMenu = true;
  //   });
  // }

  // void _hideContextMenu() {
  //   setState(() {
  //     _showContextMenu = false;
  //     _contextTargetId = null;
  //   });
  // }

  // void _contextAction(String action) {
  //   _hideContextMenu();
  //   if (_contextTargetId == null) return;
  //   if (action == 'delete') {
  //     _deleteItem(_contextTargetId!);
  //   } else if (action == 'detail') {
  //     _openDetail(_contextTargetId!);
  //   }
  // }

  void _showToastMsg(String msg) {
    setState(() {
      _toastMessage = msg;
      _showToast = true;
    });
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() => _showToast = false);
      }
    });
  }
}

class _EmptyIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFFD4C4A8)
      ..strokeWidth = 2.5;

    // Draw box
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(14, 10, 52, 60),
        const Radius.circular(8),
      ),
      paint,
    );

    paint.style = PaintingStyle.fill;
    paint.color = const Color(0xFFFFF6E0);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(14, 10, 52, 60),
        const Radius.circular(8),
      ),
      paint,
    );

    // Draw lines
    paint.style = PaintingStyle.stroke;
    paint.color = const Color(0xFFD4C4A8);
    paint.strokeWidth = 2;
    paint.strokeCap = StrokeCap.round;

    canvas.drawLine(const Offset(28, 30), const Offset(52, 30), paint);
    canvas.drawLine(const Offset(28, 40), const Offset(46, 40), paint);
    canvas.drawLine(const Offset(28, 50), const Offset(40, 50), paint);

    // Draw checkmark
    paint.color = const Color(0xFFB8A48A);
    paint.strokeWidth = 2.5;
    final path = Path()
      ..moveTo(50, 52)
      ..lineTo(54, 56)
      ..lineTo(62, 46);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
