/**
 * 名称:   药房公共-系统管理-应用程序维护
 * 编写人:  yunhaibao
 * 编写日期: 2019-03-12~
 * scripts/pha/sys/v1/appprop.js
 */
 PHA_COM.App.Csp = 'pha.sys.v1.appprop.csp';
 PHA_COM.App.Name = 'SYS.APPPROP';
 PHA_COM.App.Load = '';
 PHA_COM.Temp = {};
 PHA_COM.Temp.TreeState = 'open';
 PHA_COM.Temp.IsUpdate = false;
 PHA_COM.Temp.PwdPropCode = (function () {
     var pwdCodeStr = tkMakeServerCall('PHA.SYS.AppProp.Query', 'GetPwdCodeStr');
     return pwdCodeStr.split('|');
 })();
 
 $(function () {
     PHA_COM.ResizePanel({
         layoutId: 'layout-right',
         region: 'south',
         height: 0.4
     });
 
     InitDict();
     InitTreeApp();
     InitGridProp();
     InitGridPref();
     InitEvents();
 });
 
 // 事件
 function InitEvents() {
     $('#btnAddProp,#btnEditProp').on('click', function () {
         ShowDiagProp(this);
     });
     $('#btnDelProp').on('click', DeleteProp);
     $('#btnAddPref,#btnEditPref').on('click', function () {
         ShowDiagPref(this);
     });
     $('#btnDelPref').on('click', DeletePref);
 
     $('#btnImport').on('click', Import);
     $('#btnExport').on('click', Export);
 }
 
 // 字典
 function InitDict() {
     // 检索别名
     PHA.SearchBox('conAppAlias', {
         searcher: QueryTreeApp,
         placeholder: '可输入模块或参数的简拼、代码、名称...'
     });
 
     // 参数维护中的类型串，允许多选
     PHA.ComboBox('propTypeList', {
         multiple: true,
         data: [{
                 RowId: 'G',
                 Description: $g('安全组')
             }, {
                 RowId: 'L',
                 Description: $g('科室')
             }, {
                 RowId: 'U',
                 Description: $g('用户')
             }, {
                 RowId: 'D',
                 Description: $g('全院')
             }
         ],
         onHidePanel: function (data) {
             //LoadTypePointer();
         },
         onChange: function (newValue, oldValue) {
             if (newValue == '') {
                 //$('#prefTypePointer').combobox('loadData', []);
             }
         },
         width: 429
     });
 
     // 医院
     PHA.ComboBox('prefHosp', {
         url: PHA_STORE.CTHospital().url,
         onHidePanel: function (data) {
             LoadTypePointer();
         },
         width: 300
     });
     
     // 类型
     PHA.ComboBox('prefType', {
         data: [{
                 RowId: 'G',
                 Description: $g('安全组')
             }, {
                 RowId: 'L',
                 Description: $g('科室')
             }, {
                 RowId: 'U',
                 Description: $g('用户')
             }, {
                 RowId: 'D',
                 Description: $g('全院')
             }
         ],
         onHidePanel: function (data) {
             LoadTypePointer();
         },
         onChange: function (newValue, oldValue) {
             if (newValue == '') {
                 $('#prefTypePointer').combobox('loadData', []);
             }
         },
         width: 300
     });
     
     // 类型值 (二级联动)
     PHA.ComboBox('prefTypePointer', {
         width: 300
     });
     
     // 查询参数列表是否使用查询条件
     $('#chk-QText').checkbox({
         onCheckChange: function (e, value) {
             QueryGridProp();
         }
     });
 }
 
 function LoadTypePointer() {
     var typePointerOpts = $('#prefTypePointer').combobox('options');
     if (typePointerOpts.disabled == true) {
         return;
     }
     var type = $('#prefType').combobox('getValue') || '';
     var HospId = $('#prefHosp').combobox('getValue') || '';
     if (HospId == '') {
         $('#prefTypePointer').combobox('clear');
         return;
     }
     var newUrl = '';
     if (type == 'L') {
         newUrl = $URL + '?ResultSetType=Array&ClassName=PHA.STORE.Org&QueryName=CTLoc' + '&HospId=' + HospId;
     } else if (type == 'G') {
         newUrl = $URL + '?ResultSetType=Array&ClassName=PHA.STORE.Org&QueryName=SSGroup' + '&HospId=' + HospId;
     } else if (type == 'U') {
         newUrl = $URL + '?ResultSetType=Array&ClassName=PHA.STORE.Org&QueryName=SSUser' + '&HospId=' + HospId;
     } else if (type == 'D') {
         $('#prefTypePointer').combobox('loadData', [{
                     RowId: 'DHC',
                     Description: 'DHC'
                 }
             ]
         );
     } else {
         $('#prefTypePointer').combobox('loadData', []);
     }
     if (newUrl != '') {
         $('#prefTypePointer').combobox('options').url = newUrl;
         $('#prefTypePointer').combobox('reload');
     }
     $('#prefTypePointer').combobox('setValue', '');
 }
 
 // 树-产品模块
 function InitTreeApp() {
     PHA.Tree('treeApp', {
         onSelect: function (node) {
             if ((node.children || '') != '') {
                 $('#curAppCode').html('');
             } else {
                 var curAppDesc = node.text || '';
                 var curAppCode = node.appCode || '';
                 var showStr = curAppDesc + ' [' + curAppCode + ']';
                 $('#curAppCode').html(showStr);
             }
             QueryGridProp();
         },
         onLoadSuccess: function (node, data) {
             if (data.length == 0) {
                 return;
             }
             var childrenData = data[0].children || [];
             if (childrenData.length == 0) {
                 return;
             }
             var domId = childrenData[0].domId;
             $('#treeApp').tree('select', $('#' + domId));
         }
     });
     QueryTreeApp(null);
 }
 function QueryTreeApp(p) {
     // 查询
     var conAppAlias = $('#conAppAlias').searchbox('getValue');
     var TreeState = PHA_COM.Temp.TreeState;
     if (TreeState == 'closed') {
         PHA_COM.Temp.TreeState = 'open';
     } else {
         PHA_COM.Temp.TreeState = 'closed';
     }
     var InputStr = [TreeState, conAppAlias, 'Y', 'B', 'Y'].join('^');
     $.cm({
         ClassName: 'PHA.SYS.Store',
         MethodName: 'GetDHCStkSysAppTree',
         InputStr: InputStr
     }, function (data) {
         $('#treeApp').tree({
             data: data
         });
     });
     if (p != null) {
         $('#gridProp').datagrid('clear');
     }
     // 修改上箭头
     var $toolBar = $('#panel-app').siblings().eq(0).children('.panel-tool').children().eq(0);
     var curIcon = $toolBar.attr('class');
     var newIcon = curIcon == 'icon-up-gray' ? 'icon-down-gray' : 'icon-up-gray';
     $toolBar.attr('class', newIcon);
     $('#curAppCode').html('');
 }
 
 // 表格-模块参数
 function InitGridProp() {
     var columns = [
         [{
                 field: 'propId',
                 title: '参数Id',
                 hidden: true,
                 width: 100
             }, {
                 field: 'propCode',
                 title: '代码',
                 width: 180
             }, {
                 field: 'propDesc',
                 title: '名称',
                 width: 200,
                 showTip: true,
                 tipWidth: 150
             }, {
                 field: 'propTypeDesc',
                 title: '类型串',
                 width: 200,
                 showTip: true,
                 tipWidth: 150
             }, {
                 field: 'propVal',
                 title: '默认值',
                 width: 120,
                 align: 'center',
                 formatter: function (value, rowData, index) {
                     if (PHA_COM.Temp.PwdPropCode.indexOf(rowData.propCode) >= 0) {
                         return GetPassword(value);
                     }
                     return value;
                 }
             }, {
                 field: 'propMemo',
                 title: '说明',
                 width: 450,
                 showTip: true,
                 tipWidth: 300
             }, {
                 field: 'HospLevelFlag',
                 title: '院级标志',
                 align: 'center',
                 width: 100,
                 hidden: true,
                 formatter: HospLevelFormatter
             }, {
                 field: 'DateConfigFlag',
                 title: '日期配置',
                 align: 'center',
                 width: 100,
                 hidden: true,
                 formatter: DateConfigFlagFormatter
             },{
                field: 'startDate',
                title: '开始日期',
                hidden: true,
                width: 120
            },{
                field: 'endDate',
                title: '结束日期',
                hidden: true,
                width: 120
            }
         ]
     ];
     var dataGridOption = {
         url: $URL,
         queryParams: {
             ClassName: 'PHA.SYS.AppProp.Query',
             QueryName: 'DHCStkSysAProp'
         },
         pagination: false,
         columns: columns,
         fitColumns: true,
         nowrap: true,
         toolbar: '#gridPropBar',
         enableDnd: false,
         onSelect: function (rowIndex, rowData) {
             QueryGridPref();
             $(this).datagrid('options').selectedRowIndex = rowIndex;
             var DateConfigFlag = rowData.DateConfigFlag;
             if (DateConfigFlag != 'Y')
                 $('#gridPref').datagrid('hideColumn', 'prefStDate'); // 隐藏
             else
                 $('#gridPref').datagrid('showColumn', 'prefStDate'); // 显示
         },
         onDblClickRow: function (rowIndex, rowData) {
             ShowDiagProp({
                 id: 'btnEditProp',
                 text: '修改'
             });
         },
         onDrop: function () {
	         // 拖动排序. Huxt 2023-04-18
             var idStr = '';
             var rows = $(this).datagrid('getRows');
             var rowsLen = rows.length;
             for (var i = 0; i < rowsLen; i++) {
                 idStr = idStr == '' ? rows[i].propId : idStr + '^' + rows[i].propId;
             }
             var saveRet = $.cm(
                 {
                     ClassName: 'PHA.COM.DataSort',
                     MethodName: 'SaveMulti',
                     dataClass: 'User.DHCStkSysAProp',
                     dataIDStr: idStr,
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
         onLoadSuccess: function (data) {
	         $('#gridProp').datagrid('enableDnd'); // 不能再添加单元格编辑,有冲突
	         
             $('#gridPref').datagrid('clear');
             if (data.total > 0) {
                 var selRowIdx = $(this).datagrid('options').selectedRowIndex;
                 if (selRowIdx >= 0 && selRowIdx < data.rows.length) {
                     $(this).datagrid('selectRow', selRowIdx);
                 } else {
                     $(this).datagrid('selectRow', 0);
                 }
             }
             $('.hisui-switchboxHospLevel').switchbox();
             $('.hisui-switchboxDateConfig').switchbox();
         }
     };
     PHA.Grid('gridProp', dataGridOption);
 }
 
 function QueryGridPref() {
     var selRow = $('#gridProp').datagrid('getSelected') || {};
     $('#gridPref').datagrid('query', {
         InputStr: selRow.propId || '',
         rows:999999
     });
 }
 
 function HospLevelFormatter(value, rowData, rowIndex) {
     var propId = rowData.propId;
     var IndexString = JSON.stringify(rowIndex);
     var Useflag = false;
     if (value == 'Y')
         Useflag = true;
     return (
         "<div class=\"hisui-switchboxHospLevel\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'" + $g('是') + "',offText:'" + $g('否') + "',checked:" +
         Useflag +
         ",disabled:false,onSwitchChange:function(e, obj){UpdateHospLevel(obj.value,'" +
         propId +
         "'," +
         IndexString +
         ",'" +
         value +
         '\')}"></div>');
 }
 
 function UpdateHospLevel(objVal, propId, IndexString, value) {
     objVal = objVal ? 'Y' : 'N';
     $.cm({
         ClassName: 'PHA.SYS.AppProp.Save',
         MethodName: 'UpdateHospLevel',
         propId: propId,
         val: objVal
     }, function (retData) {
         if (!retData) {
             PHA.Popover({
                 showType: 'show',
                 msg: '修改院级标志成功！',
                 type: 'success'
             });
             var gridSelect = $('#gridProp').datagrid('getSelected') || '';
             if (!gridSelect)
                 return;
             gridSelect.HospLevelFlag = objVal;
         } else {
             PHA.Popover({
                 showType: 'show',
                 msg: '修改院级标志失败！ 错误描述' + retData,
                 type: 'alert'
             });
         }
     });
 }
 
 function DateConfigFlagFormatter(value, rowData, rowIndex) {
     var propId = rowData.propId;
     var IndexString = JSON.stringify(rowIndex);
     var Useflag = value == 'Y' ? true : false;
     return (
         "<div class=\"hisui-switchboxDateConfig\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'" + $g('是') + "',offText:'" + $g('否') + "',checked:" +
         Useflag +
         ",disabled:false,onSwitchChange:function(e, obj){UpdateDateConfigFlag(obj.value,'" +
         propId +
         "'," +
         IndexString +
         ",'" +
         value +
         '\')}"></div>'
     );
 }
 
 function UpdateDateConfigFlag(objVal, propId, IndexString, value) {
     objVal = objVal ? 'Y' : 'N';
     $.cm({
         ClassName: 'PHA.SYS.AppProp.Save',
         MethodName: 'UpdateDateConfigFlag',
         propId: propId,
         val: objVal
     }, function (retData) {
         if (!retData) {
             PHA.Popover({
                 showType: 'show',
                 msg: '修改日期配置成功！',
                 type: 'success'
             });
             var gridSelect = $('#gridProp').datagrid('getSelected') || '';
             if (!gridSelect) {
                 return;
             }
             gridSelect.DateConfigFlag = objVal;
         } else {
             PHA.Popover({
                 showType: 'show',
                 msg: '修改日期配置失败！ 错误描述' + retData,
                 type: 'alert'
             });
         }
     });
 }
 
 // 表格-模块参数值
 function InitGridPref() {
     var columns = [
         [{
                 field: 'prefId',
                 title: '参数值Id',
                 hidden: true,
                 width: 100
             }, {
                 field: 'prefHospDesc',
                 title: '医院',
                 width: 150
             }, {
                 field: 'prefTypeDesc',
                 title: '类型',
                 width: 80
             }, {
                 field: 'prefTypePointerDesc',
                 title: '类型值',
                 width: 100
             }, {
                 field: 'prefVal',
                 title: '参数值',
                 width: 100,
                 formatter: function (value, rowData, index) {
                     var propCode = ($('#gridProp').datagrid('getSelected') || {}).propCode;
                     if (PHA_COM.Temp.PwdPropCode.indexOf(propCode) >= 0) {
                         return GetPassword(value);
                     }
                     return value;
                 }
             }, {
                 field: 'prefStDate',
                 title: '生效日期',
                 width: 80
             }
         ]
     ];
     var dataGridOption = {
         url: $URL,
         queryParams: {
             ClassName: 'PHA.SYS.AppProp.Query',
             QueryName: 'DHCStkSysAPropPref'
         },
         pagination: false,
         columns: columns,
         fitColumns: true,
         toolbar: '#gridPrefBar',
         enableDnd: false,
         onClickRow: function (rowIndex, rowData) {},
         onDblClickRow: function (rowIndex, rowData) {
             ShowDiagPref({
                 id: 'btnEditPref',
                 text: '修改'
             });
         }
     };
     PHA.Grid('gridPref', dataGridOption);
 }
 
 function QueryGridProp() {
     var treeSelect = $('#treeApp').tree('getSelected') || '';
     if (treeSelect == '') {
         return;
     }
     var appId = treeSelect.id;
     if (treeSelect.children) {
         appId = '';
     }
     var conAppAlias = $('#conAppAlias').searchbox('getValue');
     var chkQText = $('#chk-QText').checkbox('getValue');
     if (chkQText == false) {
         conAppAlias = '';
     }
     $('#gridProp').datagrid('query', {
         InputStr: appId + '^' + conAppAlias,
         rows:999999
     });
 }
 
 function ShowDiagProp(btnOpt) {
     var ifAdd = btnOpt.id.indexOf('Add') >= 0 ? true : false;
     var propId = '';
     if (ifAdd == false) {
         var gridSelect = $('#gridProp').datagrid('getSelected') || '';
         if (gridSelect == '') {
             PHA.Popover({
                 msg: '请先选中需要修改的参数',
                 type: 'alert'
             });
             return;
         }
         propId = gridSelect.propId;
     }
     var treeSelect = $('#treeApp').tree('getSelected') || '';
     if (treeSelect == '') {
         PHA.Popover({
             msg: '请先选中产品模块',
             type: 'alert'
         });
         return;
     }
     if (treeSelect.children) {
         PHA.Popover({
             msg: '请先选中该产品线下的产品模块',
             type: 'alert'
         });
         return;
     }
     $('#diagProp').dialog({
         title: '参数' + btnOpt.text,
         iconCls: ifAdd ? 'icon-w-add' : 'icon-w-edit',
         modal: true
     }).dialog('open');
     if (ifAdd == false) {
         $('#diagProp_btnAdd').hide();
         $.cm({
             ClassName: 'PHA.SYS.AppProp.Query',
             QueryName: 'SelectDHCStkSysAProp',
             PropId: propId,
             ResultSetType: 'Array'
         }, function (arrData) {
             var propTypeList = arrData[0].propTypeList;
             if (arrData[0].propTypeList !== ''){
                 arrData[0].propTypeList = JSON.parse(arrData[0].propTypeList)
             }
             PropPassword(arrData);
             PHA.SetVals(arrData);
         });
     } else {
         var clearValueArr = ['propCode', 'propDesc', 'propVal', 'propMemo', 'propTypeList'];
         PHA.ClearVals(clearValueArr);
     }
     $('#propCode').focus();
 }
 
 /**
  * @param {String} type 1(继续新增)
  */
 function SaveProp(type) {
     var iconCls = $('#diagProp').panel('options').iconCls || '';
     var ifAdd = iconCls.indexOf('add') >= 0 ? true : false;
     var propId = '';
     if (ifAdd == false) {
         var gridSelect = $('#gridProp').datagrid('getSelected');
         propId = gridSelect.propId || '';
     }
     var getValueArr = ['propCode', 'propDesc', 'propVal', 'propMemo', 'propTypeList'];
     var valsArr = PHA.GetVals(getValueArr);
     if (PHA_COM.Temp.PwdPropCode.indexOf(valsArr[0]) >= 0) {
         valsArr[2] = (new jsBase64).encode(valsArr[2]);  // 测试要求. Huxt 2021-08-08
     }
     var valsStr = valsArr.join('^');
     if (valsStr == '') {
         return;
     }
     var treeSelect = $('#treeApp').tree('getSelected');
     var appId = treeSelect.id;
     var saveRet = $.cm({
         ClassName: 'PHA.SYS.AppProp.Save',
         MethodName: 'SaveProp',
         PropId: propId,
         DataStr: appId + '^' + valsStr,
         dataType: 'text'
     }, false);
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
         PHA.ClearVals(['propCode', 'propDesc', 'propVal', 'propMemo', 'propTypeList']);
         $('#propCode').focus();
     } else {
         $('#diagProp').dialog('close');
     }
     QueryGridProp();
 }
 // 删除页面
 function DeleteProp() {
     var gridSelect = $('#gridProp').datagrid('getSelected') || '';
     if (gridSelect == '') {
         PHA.Popover({
             msg: '请先选中需要删除的参数',
             type: 'alert',
             timeout: 1000
         });
         return;
     }
     var propId = gridSelect.propId || '';
     PHA.Confirm('删除提示', '您确认删除吗?', function () {
         var saveRet = $.cm({
             ClassName: 'PHA.SYS.AppProp.Save',
             MethodName: 'DeleteProp',
             PropId: propId,
             dataType: 'text'
         }, false);
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
             QueryGridProp();
         }
     });
 }
 
 function ShowDiagPref(btnOpt) {
     var ifAdd = btnOpt.id.indexOf('Add') >= 0 ? true : false;
     var prefId = '';
     var HospLevelFlag = '';
     var DateConfigFlag = '';
     if (ifAdd == false) {
         var gridSelect = $('#gridPref').datagrid('getSelected') || '';
         if (gridSelect == '') {
             PHA.Popover({
                 msg: '请先选中需要编辑的参数值',
                 type: 'alert'
             });
             return;
         }
         prefId = gridSelect.prefId;
     }
     var gridPropSelect = $('#gridProp').datagrid('getSelected') || '';
     if (gridPropSelect == '') {
         PHA.Popover({
             msg: '请先选中参数',
             type: 'alert'
         });
         return;
     }
     HospLevelFlag = gridPropSelect.HospLevelFlag;
     DateConfigFlag = gridPropSelect.DateConfigFlag;
     propCode = gridPropSelect.propCode;

     $('#diagPref').dialog({
         title: '参数值' + btnOpt.text,
         iconCls: ifAdd ? 'icon-w-add' : 'icon-w-edit',
         modal: true
     }).dialog('open');
     if (DateConfigFlag != 'Y') {
         $('#divPrefStDate').hide();
         // $("#diagPref").dialog({height:"250"});
     } else {
         $('#divPrefStDate').show();
     }
     if (ifAdd == false) {
         $('#diagPref_btnAdd').hide();
         $.cm({
             ClassName: 'PHA.SYS.AppProp.Query',
             MethodName: 'SelectDHCStkSysAPropPref',
             PrefId: prefId,
             ResultSetType: 'Array'
         }, function (arrData) {
             
             PHA_COM.Temp.IsUpdate = true;
             PropPrefPassword(arrData);
             PHA.SetVals(arrData);
             LoadTypePointer();
             PHA.SetComboVal('prefTypePointer', [arrData[0].prefTypePointer]);
         });
     } else {
         $('#prefTypePointer').combobox('loadData', []);
         PHA_COM.Temp.IsUpdate = false;
         var clearValueArr = ['prefType', 'prefTypePointer', 'prefVal', 'prefHosp', 'prefStDate'];
         PHA.ClearVals(clearValueArr);
         if (HospLevelFlag == 'Y') {
             $('#prefType').combobox('setValue', 'D');
             $('#prefTypePointer').combobox('loadData', [{
                         RowId: 'DHC',
                         Description: 'DHC'
                     }
                 ]
             );
             $('#prefTypePointer').combobox('setValue', 'DHC');
         }
         if (propCode == 'Permission4Recreate') {
            $('#prefType').combobox('setValue', 'U');
        }
     }
     // 对院级配置做不可用控制
     if (HospLevelFlag == 'Y') {
         $('#prefType').combobox('disable');
         $('#prefTypePointer').combobox('disable');
     }
     else if(propCode == 'Permission4Recreate'){
        $('#prefType').combobox('disable');
     }
     else {
         $('#prefType').combobox('enable');
         $('#prefTypePointer').combobox('enable');
     }
     $('#prefType').focus();
 }
 
 /**
  * @param {String} type 1(继续新增)
  */
 function SavePref(type) {
     var iconCls = $('#diagPref').panel('options').iconCls || '';
     var ifAdd = iconCls.indexOf('add') >= 0 ? true : false;
     var prefId = '';
     if (ifAdd == false) {
         var gridSelect = $('#gridPref').datagrid('getSelected');
         prefId = gridSelect.prefId || '';
     }
     var getValueArr = ['prefType', 'prefTypePointer', 'prefVal', 'prefHosp', 'prefStDate'];
     var valsArr = PHA.GetVals(getValueArr);
     
     var gridPropSelect = $('#gridProp').datagrid('getSelected');
     var propId = gridPropSelect.propId;
     var propCode = gridPropSelect.propCode;
     if (PHA_COM.Temp.PwdPropCode.indexOf(propCode) >= 0) {
         valsArr[2] = (new jsBase64).encode(valsArr[2]); // 测试要求. Huxt 2021-08-08
     }
     
     var valsStr = valsArr.join('^');
     if (valsStr == '') {
         return;
     }
     var saveRet = $.cm({
         ClassName: 'PHA.SYS.AppProp.Save',
         MethodName: 'SavePref',
         PrefId: prefId,
         DataStr: propId + '^' + valsStr,
         dataType: 'text'
     }, false);
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
         PHA.ClearVals(['prefType', 'prefTypePointer', 'prefVal', 'prefHosp', 'prefStDate']);
         $('#prefType').focus();
     } else {
         $('#diagPref').dialog('close');
     }
     QueryGridPref();
 }
 // 删除页面
 function DeletePref() {
     var gridSelect = $('#gridPref').datagrid('getSelected') || '';
     if (gridSelect == '') {
         PHA.Popover({
             msg: '请先选中需要删除的参数值',
             type: 'alert',
             timeout: 1000
         });
         return;
     }
     var prefId = gridSelect.prefId || '';
     PHA.Confirm('删除提示', '您确认删除吗?', function () {
         var saveRet = $.cm({
             ClassName: 'PHA.SYS.AppProp.Save',
             MethodName: 'DeletePref',
             PrefId: prefId,
             dataType: 'text'
         }, false);
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
             QueryGridPref();
         }
     });
 }
 
 // 导入导出
 function Export() {
     $.cm({
         ClassName: 'PHA.SYS.Init.Query',
         QueryName: 'QueryPref',
         ResultSetType: 'Array'
     }, function (arrData) {
         var newCols = [];
         for (var k in arrData[0]) {
             newCols.push({
                 title: k,
                 hidden: false,
                 field: k // descField: '', formatter: function(){}
             });
         }
         var fileName = PHA_COM.GetFileName('参数设置') + '.xls';
         PHA_COM.ExportData(arrData, newCols, fileName);
     });
 }
 function Import() {
     PHA_COM.ReadFile({
         suffixReg: /^(.xls)|(.xlsx)$/,
         charset: 'gbk2312'
     }, function (data) {
         var dataStr = '';
         var dataLen = data.length;
         for (var i = 0; i < dataLen; i++) {
             var oneData = data[i];
             var proCode = oneData.proCode || '';
             var appCode = oneData.appCode || '';
             if ('' == dataStr) {
                 dataStr = proCode + '^' + appCode;
             } else {
                 dataStr = dataStr + '||' + proCode + '^' + appCode;
             }
         }
 
         var retStr = tkMakeServerCall('PHA.SYS.Init.Save', 'UpdateAppPro', dataStr);
         var retArr = retStr.split('^');
         if (retArr[0] < 0) {
             alert('失败:' + retArr[1]);
         } else {
             alert('成功!');
         }
     });
 }
 
 function GetPassword(val) {
     val = val || '';
     var vl = val.toString().length;
     var pwdStr = '';
     for (var i = 0; i < vl; i++) {
         if (pwdStr == '') {
             pwdStr = '·';
         } else {
             pwdStr = pwdStr + '·';
         }
     }
     return '<b>' + pwdStr + '</b>';
 }
 
 function PropPassword(arrData) {
     if (arrData.length == 0) {
         return;
     }
     var firstRowData = arrData[0];
     var propCode = firstRowData.propCode || '';
     if (propCode == '') {
         return;
     }
     if (PHA_COM.Temp.PwdPropCode.indexOf(propCode) >= 0) {
         $('#propVal').attr('type', 'password');
     } else {
         if ($('#propVal').attr('type') == 'password') {
             $('#propVal').removeAttr('type');
         }
     }
 }
 
 function PropPrefPassword(arrData) {
     if (arrData.length == 0) {
         return;
     }
     var selRowData = $('#gridProp').datagrid('getSelected') || {};
     var propCode = selRowData.propCode || '';
     if (propCode == '') {
         return;
     }
     if (PHA_COM.Temp.PwdPropCode.indexOf(propCode) >= 0) {
         $('#prefVal').attr('type', 'password');
     } else {
         if ($('#prefVal').attr('type') == 'password') {
             $('#prefVal').removeAttr('type');
         }
     }
 }
 
 /**
  * 测试要求前端后端都加密 ...
  * 加密算法 - 网上随便写=找了一个加密方法
  */
 function jsBase64() {
     // private property
     var _keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
     // public method for encoding
     this.encode = function (input) {
         var output = "";
         var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
         var i = 0;
         input = _utf8_encode(input);
         while (i < input.length) {
             chr1 = input.charCodeAt(i++);
             chr2 = input.charCodeAt(i++);
             chr3 = input.charCodeAt(i++);
             enc1 = chr1 >> 2;
             enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
             enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
             enc4 = chr3 & 63;
             if (isNaN(chr2)) {
                 enc3 = enc4 = 64;
             } else if (isNaN(chr3)) {
                 enc4 = 64;
             }
             output = output +
                 _keyStr.charAt(enc1) + _keyStr.charAt(enc2) +
                 _keyStr.charAt(enc3) + _keyStr.charAt(enc4);
         }
         return output;
     }
     // public method for decoding
     this.decode = function (input) {
         var output = "";
         var chr1, chr2, chr3;
         var enc1, enc2, enc3, enc4;
         var i = 0;
         input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");
         while (i < input.length) {
             enc1 = _keyStr.indexOf(input.charAt(i++));
             enc2 = _keyStr.indexOf(input.charAt(i++));
             enc3 = _keyStr.indexOf(input.charAt(i++));
             enc4 = _keyStr.indexOf(input.charAt(i++));
             chr1 = (enc1 << 2) | (enc2 >> 4);
             chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
             chr3 = ((enc3 & 3) << 6) | enc4;
             output = output + String.fromCharCode(chr1);
             if (enc3 != 64) {
                 output = output + String.fromCharCode(chr2);
             }
             if (enc4 != 64) {
                 output = output + String.fromCharCode(chr3);
             }
         }
         output = _utf8_decode(output);
         return output;
     }
     // private method for UTF-8 encoding
     _utf8_encode = function (string) {
         string = string.replace(/\r\n/g, "\n");
         var utftext = "";
         for (var n = 0; n < string.length; n++) {
             var c = string.charCodeAt(n);
             if (c < 128) {
                 utftext += String.fromCharCode(c);
             } else if ((c > 127) && (c < 2048)) {
                 utftext += String.fromCharCode((c >> 6) | 192);
                 utftext += String.fromCharCode((c & 63) | 128);
             } else {
                 utftext += String.fromCharCode((c >> 12) | 224);
                 utftext += String.fromCharCode(((c >> 6) & 63) | 128);
                 utftext += String.fromCharCode((c & 63) | 128);
             }
         }
         return utftext;
     }
     // private method for UTF-8 decoding
     _utf8_decode = function (utftext) {
         var string = "";
         var i = 0;
         var c = c1 = c2 = 0;
         while (i < utftext.length) {
             c = utftext.charCodeAt(i);
             if (c < 128) {
                 string += String.fromCharCode(c);
                 i++;
             } else if ((c > 191) && (c < 224)) {
                 c2 = utftext.charCodeAt(i + 1);
                 string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
                 i += 2;
             } else {
                 c2 = utftext.charCodeAt(i + 1);
                 c3 = utftext.charCodeAt(i + 2);
                 string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
                 i += 3;
             }
         }
         return string;
     }
 }
 