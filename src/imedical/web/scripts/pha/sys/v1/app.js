/**
 * ����:	 ҩ������-ϵͳ����-Ӧ�ó���ά��
 * ��д��:	 yunhaibao
 * ��д����: 2019-03-12~
 */
 PHA_COM.App.Csp = 'pha.sys.v1.app.csp';
 PHA_COM.App.Name = 'SYS.APP';
 PHA_COM.App.Load = '';
 $(function () {
     InitDict();
     InitGridPro();
     InitGridApp();
     InitEvents();
 
     $('#gridPro').parent().parent().css('border-radius', '0px');
     AddTips();
 });
 
 // �ֵ�
 function InitDict() {
     PHA.ComboBox('appModuType', {
         width: 180,
         data: [
             {
                 RowId: 'B',
                 Description: 'ҵ��'
             },
             {
                 RowId: 'Q',
                 Description: '��ѯ'
             },
             {
                 RowId: 'S',
                 Description: 'ͳ��'
             },
             {
                 RowId: 'M',
                 Description: 'ά��'
             }
         ],
         panelHeight: 'auto',
         editable: false
     });
 
     PHA.ComboBox('proId', {
         width: 180,
         placeholder: '��Ʒ��...',
         url: $URL + '?ResultSetType=array&ClassName=PHA.SYS.Store&QueryName=DHCStkSysPro',
         editable: false
     });
 }
 // ���-��Ʒ��
 function InitGridPro() {
     var columns = [
         [
             {
                 field: 'RowId',
                 title: '��Ʒ��Id',
                 hidden: true,
                 width: 100
             },
             {
                 field: 'Description',
                 title: '����',
                 width: 100
             }
         ]
     ];
     var dataGridOption = {
         url: $URL,
         queryParams: {
             ClassName: 'PHA.SYS.Store',
             QueryName: 'DHCStkSysPro',
             ActiveFlag: 'Y'
         },
         pagination: false,
         columns: columns,
         fitColumns: true,
         toolbar: null,
         enableDnd: false,
         onSelect: function (rowIndex, rowData) {
             $('#gridApp').datagrid('query', {
                 InputStr: rowData.RowId
             });
             $('#gridPro').datagrid('options').selectedRowIndex = rowIndex;
         },
         onLoadSuccess: function (data) {
             var total = data.total;
             if (total > 0) {
                 var selRowIdx = $('#gridPro').datagrid('options').selectedRowIndex;
                 if (selRowIdx >= 0 && selRowIdx < data.rows.length) {
                     $('#gridPro').datagrid('selectRow', selRowIdx);
                 } else {
                     $('#gridPro').datagrid('selectRow', 0);
                 }
             }
         }
     };
 
     PHA.Grid('gridPro', dataGridOption);
 }
 
 // ���-��Ʒģ��
 function InitGridApp() {
     var columns = [
         [
             {
                 field: 'appId',
                 title: 'ģ��Id',
                 hidden: true,
                 width: 100
             },
             {
                 field: 'appCode',
                 title: 'ģ�����',
                 width: 300
             },
             {
                 field: 'appDesc',
                 title: 'ģ������',
                 width: 300
             },
             {
                 field: 'appModuTypeDesc',
                 title: '����',
                 width: 100,
                 align: 'center'
             },
             {
                 field: 'appForAppNo',
                 title: '���ڵ��Ź���',
                 width: 100,
                 align: 'center',
                 formatter: function (value, row, index) {
                     if (value == 'Y') {
                         return PHA_COM.Fmt.Grid.Yes.Chinese;
                     } else {
                         return '';
                     }
                 }
             },
             {
                 field: 'appForParams',
                 title: '���ڲ�������',
                 width: 100,
                 align: 'center',
                 formatter: function (value, row, index) {
                     if (value == 'Y') {
                         return PHA_COM.Fmt.Grid.Yes.Chinese;
                     } else {
                         return '';
                     }
                 }
             }
         ]
     ];
     var dataGridOption = {
         url: $URL,
         queryParams: {
             ClassName: 'PHA.SYS.App.Query',
             QueryName: 'DHCStkSysApp'
         },
         pagination: true,
         columns: columns,
         toolbar: '#gridAppBar',
         onDblClickRow: function (rowIndex, rowData) {
             ShowDiagApp({ id: 'btnEdit', text: '�޸�' });
         },
         onDrop: function () {
             var appIdStr = '';
             var rows = $('#gridApp').datagrid('getRows');
             var rowsLen = rows.length;
             for (var i = 0; i < rowsLen; i++) {
                 var appId = rows[i].appId;
                 appIdStr = appIdStr == '' ? appId : appIdStr + '^' + appId;
             }
             var saveRet = $.cm(
                 {
                     ClassName: 'PHA.SYS.App.Save',
                     MethodName: 'ReBuildSortNum',
                     appIdStr: appIdStr,
                     dataType: 'text'
                 },
                 false
             );
             var saveArr = saveRet.split('^');
             var saveVal = saveArr[0];
             var saveInfo = saveArr[1];
             if (saveVal < 0) {
                 PHA.Popover({
                     msg: saveInfo,
                     type: 'alert'
                 });
             } else {
                 PHA.Popover({
                     msg: '����ɹ���',
                     type: 'success'
                 });
             }
         },
         onLoadSuccess: function () {
             $('#gridApp').datagrid('enableDnd'); // ��������ӵ�Ԫ��༭,�г�ͻ
         }
     };
     PHA.Grid('gridApp', dataGridOption);
 }
 
 function InitEvents() {
     $('#btnAdd,#btnEdit').on('click', function () {
         ShowDiagApp(this);
     });
     $('#btnDel').on('click', Delete);
 }
 
 function QueryPro() {
     $('#gridPro').datagrid('query', {
         InputStr: ''
     });
 }
 
 function ShowDiagApp(btnOpt) {
     var ifAdd = btnOpt.id.indexOf('Add') >= 0 ? true : false;
     var appId = '';
     if (ifAdd == false) {
         var gridSelect = $('#gridApp').datagrid('getSelected') || '';
         if (gridSelect == '') {
             PHA.Popover({
                 msg: '����ѡ����Ҫ�༭��ģ��',
                 type: 'alert'
             });
             return;
         }
         appId = gridSelect.appId;
     }
     var gridProSelect = $('#gridPro').datagrid('getSelected') || '';
     if (gridProSelect == '') {
         PHA.Popover({
             msg: '����ѡ�в�Ʒ��',
             type: 'alert'
         });
         return;
     }
 
     $('#diagApp')
         .dialog({
             title: 'ģ��' + btnOpt.text,
             iconCls: ifAdd ? 'icon-w-add' : 'icon-w-edit',
             modal: true
         })
         .dialog('open');
     if (ifAdd == false) {
         $('#diagApp_btnAdd').hide();
         $.cm(
             {
                 ClassName: 'PHA.SYS.App.Query',
                 QueryName: 'SelectDHCStkSysApp',
                 AppId: appId,
                 ResultSetType: 'Array'
             },
             function (arrData) {
                 PHA.SetVals(arrData);
             }
         );
         $('#proId').combobox('enable');
     } else {
         var clearValueArr = ['appCode', 'appDesc', 'appModuType', 'appForAppNo', 'appForParams'];
         PHA.ClearVals(clearValueArr);
         $('#proId').combobox('setValue', gridProSelect.RowId);
         $('#proId').combobox('disable');
     }
     $('#appCode').focus();
 }
 
 /**
  * @param {String} type 1(��������)
  */
 function Save(type) {
     var title = $('#diagApp').panel('options').title;
     var ifAdd = title.indexOf('����') >= 0 ? true : false;
     var appId = '';
     if (ifAdd == false) {
         var gridSelect = $('#gridApp').datagrid('getSelected');
         appId = gridSelect.appId || '';
     }
     var getValueArr = ['proId', 'appCode', 'appDesc', 'appModuType', 'appForAppNo', 'appForParams'];
     var valsArr = PHA.GetVals(getValueArr);
     var valsStr = valsArr.join('^');
     debugger
     if (valsStr == '') {
         return;
     }
     var saveRet = $.cm(
         {
             ClassName: 'PHA.SYS.App.Save',
             MethodName: 'Save',
             AppId: appId,
             DataStr: valsStr,
             dataType: 'text'
         },
         false
     );
     var saveArr = saveRet.split('^');
     var saveVal = saveArr[0];
     var saveInfo = saveArr[1];
     if (saveVal < 0) {
         PHA.Alert('��ʾ', saveInfo, saveVal);
         return;
     } else {
         PHA.Popover({
             msg: '����ɹ�',
             type: 'success',
             timeout: 500
         });
     }
     if (type == 1) {
         PHA.ClearVals(['appCode', 'appDesc', 'appModuType', 'appForAppNo', 'appForParams']);
         $('#appCode').focus();
     } else {
         $('#diagApp').dialog('close');
     }
     $('#gridPro').datagrid('reload');
 }
 // ɾ��ҳ��
 function Delete() {
     var gridSelect = $('#gridApp').datagrid('getSelected') || '';
     if (gridSelect == '') {
         PHA.Popover({
             msg: '����ѡ����Ҫɾ����ģ��',
             type: 'alert',
             timeout: 1000
         });
         return;
     }
     var appId = gridSelect.appId || '';
     PHA.Confirm('ɾ����ʾ', '��ȷ��ɾ����?', function () {
         var saveRet = $.cm(
             {
                 ClassName: 'PHA.SYS.App.Save',
                 MethodName: 'Delete',
                 AppId: appId,
                 dataType: 'text'
             },
             false
         );
         var saveArr = saveRet.split('^');
         var saveVal = saveArr[0];
         var saveInfo = saveArr[1];
         if (saveVal < 0) {
             PHA.Alert('��ʾ', saveInfo, 'warning');
             return;
         } else {
             PHA.Popover({
                 msg: 'ɾ���ɹ�',
                 type: 'success'
             });
             $('#gridApp').datagrid('reload');
         }
     });
 }
 
 function AddTips() {
     $Tips = $('#panel-app').prev().find('.panel-tool').find('.icon-tip');
     $Tips.attr('title', '�϶����Ըı䡰��Ʒģ�顱����ʾ˳��');
     $Tips.tooltip({ position: 'left' }).show();
 }
 