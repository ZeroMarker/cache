/**
 * ģ��:     ������ѡ�м�¼��־
 * ��д����: 2020-12-16
 * ��д��:   yangsj
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
         title:'����˵��',
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
     //������Ա
     PHA.ComboBox('comUser', { url: PHA_STORE.SSUser().url });
 }
 
 function InitEvent() {
     
     /// csp/�˵�
     $('#TextCspOrMenuName').searchbox({
         searcher:function(value,name){
         	QueryGridMenu();
         },
         width:360,
         prompt: $g('������csp/�˵����ƽ��м���') + '...'
     }); 
     
     /// �������������
     $('#TextSelectName').searchbox({
         searcher:function(value,name){
         	QueryGridCombox();
         },
         width:360,
         prompt: $g('���������������/���ƽ��м���') + '...'
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
 
 ///---------------��ѯ��������--------Start-------------///
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
 
 ///---------------��ѯ��������--------Start-------------///
 
 /// --------------Grid��ʼ��--------Start---------------///
 
 function InitGridMenu() {
     var columns = [
         [
             { field: 'MenuName', title: '�˵�����', width: 150 },
             { field: 'CspName', title: 'Csp����', width: 225 },
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
             { field: 'ComboxCode', title: '���������', width: 150 },
             { field: 'ComboxDesc', title: '����������', width: 120 },
             {
                 field: 'Days',
                 title: '�ۼ�����',
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
                 title: 'ʹ��״̬',
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
             { field: 'Date', title: '����ʱ��', width: 200 },
             { field: 'SelectVal', title: 'ѡ��ֵ', width: 80 },
             { field: 'SelectDesc', title: 'ѡ������', width: 150 },
             { field: 'UserName', title: '������', width: 150 },
             { field: 'LocDesc', title: '����', width: 150 },
             { field: 'GroupDesc', title: '��ȫ��', width: 150 },
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
 
 /// --------------Grid��ʼ��--------End---------------///
 
 /// --------------���淽������--------Start---------------///
 function SaveSelect() {
     $('#gridCombox').datagrid('endEditing');
     var gridChanges = $('#gridCombox').datagrid('getChanges');
     var gridChangeLen = gridChanges.length;
     if (gridChangeLen == 0) {
         DHCPHA_HUI_COM.Msg.popover({
             msg: 'û����Ҫ���������',
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
           PHA.Popover({ showType: 'show', msg: '�ۼ���������С�ڵ���0��', type: 'alert' });
         return;  
         }
         var params =
             (iData.SRLRowId || '') + '^' + (iData.Days || '') + '^' + (iData.ActiveFlag || '');
         if (params.replace(/\^/g, '') == '') continue;
         paramsStr = paramsStr == '' ? params : paramsStr + '!!' + params;
     }
     if (paramsStr == '') {
         PHA.Popover({ showType: 'show', msg: 'û����Ҫ�������ϸ��', type: 'alert' });
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
                     msg: '����ɹ�',
                     type: 'success',
                 });
                 QueryGridCombox();
             } else
                 PHA.Popover({
                     showType: 'show',
                     msg: $g('����ʧ��') + retData,
                     type: 'alert',
                 });
         }
     );
 }
 
 /// --------------���淽������--------End---------------///
 