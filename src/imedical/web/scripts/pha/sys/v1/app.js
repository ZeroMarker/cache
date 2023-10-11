/**
 * 名称:	 药房公共-系统管理-应用程序维护
 * 编写人:	 yunhaibao
 * 编写日期: 2019-03-12~
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
 
 // 字典
 function InitDict() {
     PHA.ComboBox('appModuType', {
         width: 180,
         data: [
             {
                 RowId: 'B',
                 Description: '业务'
             },
             {
                 RowId: 'Q',
                 Description: '查询'
             },
             {
                 RowId: 'S',
                 Description: '统计'
             },
             {
                 RowId: 'M',
                 Description: '维护'
             }
         ],
         panelHeight: 'auto',
         editable: false
     });
 
     PHA.ComboBox('proId', {
         width: 180,
         placeholder: '产品线...',
         url: $URL + '?ResultSetType=array&ClassName=PHA.SYS.Store&QueryName=DHCStkSysPro',
         editable: false
     });
 }
 // 表格-产品线
 function InitGridPro() {
     var columns = [
         [
             {
                 field: 'RowId',
                 title: '产品线Id',
                 hidden: true,
                 width: 100
             },
             {
                 field: 'Description',
                 title: '名称',
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
 
 // 表格-产品模块
 function InitGridApp() {
     var columns = [
         [
             {
                 field: 'appId',
                 title: '模块Id',
                 hidden: true,
                 width: 100
             },
             {
                 field: 'appCode',
                 title: '模块代码',
                 width: 300
             },
             {
                 field: 'appDesc',
                 title: '模块名称',
                 width: 300
             },
             {
                 field: 'appModuTypeDesc',
                 title: '类型',
                 width: 100,
                 align: 'center'
             },
             {
                 field: 'appForAppNo',
                 title: '用于单号规则',
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
                 title: '用于参数设置',
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
             ShowDiagApp({ id: 'btnEdit', text: '修改' });
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
                     msg: '保存成功！',
                     type: 'success'
                 });
             }
         },
         onLoadSuccess: function () {
             $('#gridApp').datagrid('enableDnd'); // 不能再添加单元格编辑,有冲突
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
                 msg: '请先选中需要编辑的模块',
                 type: 'alert'
             });
             return;
         }
         appId = gridSelect.appId;
     }
     var gridProSelect = $('#gridPro').datagrid('getSelected') || '';
     if (gridProSelect == '') {
         PHA.Popover({
             msg: '请先选中产品线',
             type: 'alert'
         });
         return;
     }
 
     $('#diagApp')
         .dialog({
             title: '模块' + btnOpt.text,
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
  * @param {String} type 1(继续新增)
  */
 function Save(type) {
     var title = $('#diagApp').panel('options').title;
     var ifAdd = title.indexOf('新增') >= 0 ? true : false;
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
         PHA.Alert('提示', saveInfo, saveVal);
         return;
     } else {
         PHA.Popover({
             msg: '保存成功',
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
 // 删除页面
 function Delete() {
     var gridSelect = $('#gridApp').datagrid('getSelected') || '';
     if (gridSelect == '') {
         PHA.Popover({
             msg: '请先选中需要删除的模块',
             type: 'alert',
             timeout: 1000
         });
         return;
     }
     var appId = gridSelect.appId || '';
     PHA.Confirm('删除提示', '您确认删除吗?', function () {
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
             PHA.Alert('提示', saveInfo, 'warning');
             return;
         } else {
             PHA.Popover({
                 msg: '删除成功',
                 type: 'success'
             });
             $('#gridApp').datagrid('reload');
         }
     });
 }
 
 function AddTips() {
     $Tips = $('#panel-app').prev().find('.panel-tool').find('.icon-tip');
     $Tips.attr('title', '拖动可以改变“产品模块”的显示顺序！');
     $Tips.tooltip({ position: 'left' }).show();
 }
 