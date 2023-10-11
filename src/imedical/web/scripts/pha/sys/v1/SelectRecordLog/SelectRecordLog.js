/**
 * 模块:     下拉框选中记录日志
 * 编写日期: 2020-12-16
 * 编写人:   yangsj
 */
 var SessionLoc = session['LOGON.CTLOCID'];
 var SessionUser = session['LOGON.USERID'];
 var SessionHosp = session['LOGON.HOSPID'];
 $(function () {
     InitGrid();
     InitBtnEvent();
     InitDict();
     InitEvent();
     
     $("#btnHelp").popover({
         title:'调用说明',
         trigger:'click',
         padding:'10px',
         width:'390px',
         content:$('#js-help-info').html()
                 
     });
 });
 
 function InitGrid() {
     InitGridMenu();
     InitGridCombox();
     InitGridSelectRecord();
 }
 function InitBtnEvent() {
     $('#btnQuery').on('click', QueryGridMenu);
     $('#btnFindRecord').on('click', QueryGridSelectRecord);
     $('#btnSaveSelect').on('click', SaveSelect);
 }
 
 function InitDict() {
     $('#dateStart').datebox('setValue', 't-10');
     $('#dateEnd').datebox('setValue', 't');
     //操作人员
     PHA.ComboBox('comUser', { url: PHA_STORE.SSUser().url });
 }
 
 function InitEvent() {
     
     /// csp/菜单
     $('#TextCspOrMenuName').searchbox({
         searcher:function(value,name){
         	QueryGridMenu();
         },
         width:360,
         prompt: $g('请输入csp/菜单名称进行检索') + '...'
     }); 
     
     /// 下拉框代码名称
     $('#TextSelectName').searchbox({
         searcher:function(value,name){
         	QueryGridCombox();
         },
         width:360,
         prompt: $g('请输入下拉框代码/名称进行检索') + '...'
     }); 
 }
 
 function clear() {
     $('#gridMenu').datagrid('clear');
     $('#gridMenu').datagrid('clearSelections');
     $('#gridCombox').datagrid('clear');
     $('#gridCombox').datagrid('clearSelections');
     $('#gridSelectRecord').datagrid('clear');
     $('#gridSelectRecord').datagrid('clearSelections');
 }
 
 ///---------------查询方法集中--------Start-------------///
 function QueryGridMenu() {
     clear();
     $('#gridMenu').datagrid('query', {
         HospId: SessionHosp,
         inputStr: $('#TextCspOrMenuName').searchbox("getValue")
     });
 }
 
 function QueryGridCombox() {
     var gridSelect = $('#gridMenu').datagrid('getSelected') || '';
     var CspName = '';
     if (gridSelect) CspName = gridSelect.CspName;
     if (CspName == '') return;
     $('#gridCombox').datagrid('query', {
         CspName: CspName,
         HospId: SessionHosp,
         inputStr:  $('#TextSelectName').searchbox("getValue") 
     });
 }
 
 function QueryGridSelectRecord() {
     var gridSelect = $('#gridCombox').datagrid('getSelected') || '';
     var SRLRowId = '';
     if (gridSelect) SRLRowId = gridSelect.SRLRowId;
     if (SRLRowId == '') return;
     $('#gridSelectRecord').datagrid('query', {
         StDate: $('#dateStart').datebox('getValue'),
         EdDate: $('#dateEnd').datebox('getValue'),
         SRLRowId: SRLRowId,
         User: $('#comUser').combobox('getValue'),
     });
 }
 
 ///---------------查询方法集中--------Start-------------///
 
 /// --------------Grid初始化--------Start---------------///
 
 function InitGridMenu() {
     var columns = [
         [
             { field: 'MenuName', title: '菜单名称', width: 150 },
             { field: 'CspName', title: 'Csp链接', width: 225 },
         ],
     ];
     var dataGridOption = {
         url: $URL,
         queryParams: {
             ClassName: 'PHA.SYS.SelectRecordLog.Query',
             QueryName: 'QueryCspList',
             HospId: SessionHosp,
         },
         pagination: true,
         fitColumns: true,
         fit: true,
         idField: 'MenuName',
         rownumbers: true,
         columns: columns,
         toolbar: '#gridMenuBar',
         onClickRow: function (rowIndex, rowData) {
             QueryGridCombox();
         },
         singleSelect: true,
         selectOnCheck: true,
         checkOnSelect: true,
         onLoadSuccess: function () {},
     };
     DHCPHA_HUI_COM.Grid.Init('gridMenu', dataGridOption);
 }
 
 function InitGridCombox() {
     var columns = [
         [
             // SRLRowId,ComboxCode,ComboxDesc,Days,ActiveFlag
             { field: 'SRLRowId', title: 'SRLRowId', width: 150, hidden: true },
             { field: 'ComboxCode', title: '下拉框代码', width: 150 },
             { field: 'ComboxDesc', title: '下拉框名称', width: 120 },
             {
                 field: 'Days',
                 title: '累计天数',
                 width: 100,
                 editor: {
                     type: 'numberbox',
                     options: {
                         required: true,
                     },
                 },
             },
             {
                 field: 'ActiveFlag',
                 title: '使用状态',
                 align: 'center',
                 width: 100,
                 editor: {
                     type: 'icheckbox',
                     options: {
                         on: 'Y',
                         off: 'N',
                     },
                 },
                 formatter: function (value, row, index) {
                     if (value == 'Y') {
                         return PHA_COM.Fmt.Grid.Yes.Chinese;
                     } else {
                         return PHA_COM.Fmt.Grid.No.Chinese;
                     }
                 },
             },
         ],
     ];
     var dataGridOption = {
         url: $URL,
         queryParams: {
             ClassName: 'PHA.SYS.SelectRecordLog.Query',
             QueryName: 'QueryComboxList',
             HospId: SessionHosp,
         },
         pagination: true,
         fitColumns: true,
         fit: true,
         idField: 'SRLRowId',
         rownumbers: true,
         columns: columns,
         toolbar: '#gridComboxBar',
         onClickRow: function (rowIndex, rowData) {
             QueryGridSelectRecord();
         },
         onDblClickRow: function (rowIndex, rowData) {
             var Days = rowData.Days;
             if (Days)
                 $(this).datagrid('beginEditRow', {
                     rowIndex: rowIndex,
                     editField: 'Days',
                 });
         },
         singleSelect: true,
         selectOnCheck: true,
         checkOnSelect: true,
         onLoadSuccess: function () {},
     };
     DHCPHA_HUI_COM.Grid.Init('gridCombox', dataGridOption);
 }
 
 function InitGridSelectRecord() {
     var columns = [
         [
             { field: 'SRLIRowId', title: 'SRLIRowId', width: 150, hidden: true },
             { field: 'Date', title: '日期时间', width: 200 },
             { field: 'SelectVal', title: '选择值', width: 80 },
             { field: 'SelectDesc', title: '选择描述', width: 150 },
             { field: 'UserName', title: '操作人', width: 150 },
             { field: 'LocDesc', title: '科室', width: 150 },
             { field: 'GroupDesc', title: '安全组', width: 150 },
         ],
     ];
     var dataGridOption = {
         url: $URL,
         queryParams: {
             ClassName: 'PHA.SYS.SelectRecordLog.Query',
             QueryName: 'QueryRecordList',
         },
         pagination: true,
         fitColumns: true,
         fit: true,
         idField: 'SRLIRowId',
         rownumbers: true,
         columns: columns,
         toolbar: '#gridSelectRecordBar',
         onClickRow: function (rowIndex, rowData) {
             //QueryConstGroup();
         },
         singleSelect: true,
         selectOnCheck: true,
         checkOnSelect: true,
         onLoadSuccess: function () {},
     };
     DHCPHA_HUI_COM.Grid.Init('gridSelectRecord', dataGridOption);
 }
 
 /// --------------Grid初始化--------End---------------///
 
 /// --------------保存方法集中--------Start---------------///
 function SaveSelect() {
     $('#gridCombox').datagrid('endEditing');
     var gridChanges = $('#gridCombox').datagrid('getChanges');
     var gridChangeLen = gridChanges.length;
     if (gridChangeLen == 0) {
         DHCPHA_HUI_COM.Msg.popover({
             msg: '没有需要保存的数据',
             type: 'alert',
         });
         return;
     }
     // SRLRowId,ComboxCode,ComboxDesc,Days,ActiveFlag
     var paramsStr = '';
     for (var i = 0; i < gridChangeLen; i++) {
         var iData = gridChanges[i];
         var days=iData.Days || '';
         if(days<=0){
           PHA.Popover({ showType: 'show', msg: '累计天数不能小于等于0！', type: 'alert' });
         return;  
         }
         var params =
             (iData.SRLRowId || '') + '^' + (iData.Days || '') + '^' + (iData.ActiveFlag || '');
         if (params.replace(/\^/g, '') == '') continue;
         paramsStr = paramsStr == '' ? params : paramsStr + '!!' + params;
     }
     if (paramsStr == '') {
         PHA.Popover({ showType: 'show', msg: '没有需要保存的明细！', type: 'alert' });
         return;
     }
 
     $.cm(
         {
             ClassName: 'PHA.SYS.SelectRecordLog.Save',
             MethodName: 'UpdateDayAndActive',
             paramsStr: paramsStr,
         },
         function (retData) {
             if (!retData) {
                 PHA.Popover({
                     showType: 'show',
                     msg: '保存成功',
                     type: 'success',
                 });
                 QueryGridCombox();
             } else
                 PHA.Popover({
                     showType: 'show',
                     msg: $g('保存失败') + retData,
                     type: 'alert',
                 });
         }
     );
 }
 
 /// --------------保存方法集中--------End---------------///
 