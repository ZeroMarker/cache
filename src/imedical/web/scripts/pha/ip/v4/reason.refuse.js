/**
 * 名称:   住院药房 - 拒绝发药原因维护
 * 编写人:  yunhaibao
 * 编写日期: 2020-10-30
 */
 $.fn.tooltip.methods.show = function(){};

 PHA_COM.App.Csp = 'pha.ip.v4.reason.refuse.csp';
 PHA_COM.App.Name = '';
 $(function () {
     InitHosp();
     InitGridReason();
     $('#btnAdd').on('click', function () {
         $('#gridReason').datagrid('addNewRow', {});
     });
     $('#btnSave').on('click', Save);
     $('#btnDelete').on('click', Delete);
     PHA_UX.Translate({ buttonID: 'btnTranslate', gridID: 'gridReason', idField: 'rowID', sqlTableName: 'DHC_STRefuseReason' });
 });
 
 function InitGridReason() {
     var columns = [
         [
             {
                 field: 'rowID',
                 title: 'rowID',
                 hidden: true,
                 width: 100
             },
             {
                 field: 'reasonCode',
                 title: '代码',
                 width: 200,
                 editor: {
                     type: 'validatebox',
                     options: {
                         required: true
                     }
                 }
             },
             {
                 field: 'reasonDesc',
                 title: '名称',
                 width: $('#lyCenter').width() - 250,
                 editor: {
                     type: 'validatebox',
                     options: {
                         required: true
                     }
                 }
             }
         ]
     ];
     var dataGridOption = {
         url: $URL,
         queryParams: {
             ClassName: 'PHA.IP.Reason.Refuse',
             QueryName: 'RefuseReason',
             pJsonStr: JSON.stringify({ hosp: PHA_COM.Session.HOSPID })
         },
         columns: columns,
         rownumbers: true,
         toolbar: '#gridReasonBar',
         enableDnd: false,
         onClickRow: function (rowIndex, rowData) {
             $(this).datagrid('endEditing');
         },
         onDblClickRow: function (rowIndex, rowData) {
             if (rowData) {
                 $(this).datagrid('beginEditRow', {
                     rowIndex: rowIndex,
                     editField: 'reasonCode'
                 });
             }
         }
     };
     PHA.Grid('gridReason', dataGridOption);
 }
 function Query() {
     $('#gridReason').datagrid('query', {
         ClassName: 'PHA.IP.Reason.Refuse',
         QueryName: 'RefuseReason',
         pJsonStr: JSON.stringify({ hosp: PHA_COM.Session.HOSPID }),
         rows: 999
     });
 }
 // 保存
 function Save() {
     var $grid = $('#gridReason');
     if ($grid.datagrid('endEditing') === false) {
         PHA.Popover({
             msg: '请先完成必填项',
             type: 'alert'
         });
         return;
     }
     var gridChanges = $grid.datagrid('getChanges');
     var gridChangeLen = gridChanges.length;
     if (gridChangeLen == 0) {
         PHA.Popover({
             msg: '没有需要保存的数据',
             type: 'alert'
         });
         return;
     }
 
     var repeatObj = $grid.datagrid('checkRepeat', [['reasonCode'], ['reasonDesc']]);
     if (typeof repeatObj.pos === 'number') {
         PHA.Popover({
             msg: '第' + (repeatObj.pos + 1) + '、' + (repeatObj.repeatPos + 1) + '行:' + repeatObj.titleArr.join('、') + '重复',
             type: 'alert'
         });
         return;
     }
 
     var dataArr = [];
     for (var i = 0; i < gridChangeLen; i++) {
         var iData = gridChanges[i];
         if ($grid.datagrid('getRowIndex', iData) < 0) {
             continue;
         }
         var iJson = {
             rowID: iData.rowID || '',
             reasonCode: iData.reasonCode,
             reasonDesc: iData.reasonDesc,
             hosp: PHA_COM.Session.HOSPID
         };
         dataArr.push(iJson);
     }
     var retJson = $.cm(
         {
             ClassName: 'PHA.IP.Data.Api',
             MethodName: 'HandleInAll',
             pClassName: 'PHA.IP.Reason.Refuse',
             pMethodName: 'SaveHandler',
             pJsonStr: JSON.stringify(dataArr)
         },
         false
     );
     if (retJson.success === 'N') {
         var msg = PHAIP_COM.DataApi.Msg(retJson);
         PHA.Alert('提示', msg, 'warning');
     } else {
         $grid.datagrid('reload');
     }
 }
 // 删除
 function Delete() {
     var gridSelect = $('#gridReason').datagrid('getSelected') || '';
     if (gridSelect === '') {
         PHA.Popover({
             msg: '请先选中需要删除的记录',
             type: 'alert'
         });
         return;
     }
     PHA.Confirm('删除提示', '您正在操作 <span style="color:red;font-weight:bold">删除</span>', function () {
         var rowID = gridSelect.rowID || '';
         var rowIndex = $('#gridReason').datagrid('getRowIndex', gridSelect);
         if (rowID !== '') {
             var dataArr = [];
             dataArr.push({
                 rowID: rowID,
                 hosp: PHA_COM.Session.HOSPID
             });
             var retJson = $.cm(
                 {
                     ClassName: 'PHA.IP.Data.Api',
                     MethodName: 'HandleInAll',
                     pClassName: 'PHA.IP.Reason.Refuse',
                     pMethodName: 'DeleteHandler',
                     pJsonStr: JSON.stringify(dataArr)
                 },
                 false
             );
             if (retJson.success === 'N') {
                 var msg = PHAIP_COM.DataApi.Msg(retJson);
                 PHA.Alert('提示', msg, 'warning');
                 return;
             }
         }
         $('#gridReason').datagrid('deleteRow', rowIndex);
     });
 }
 
 function InitHosp() {
     var hospComp = GenHospComp('DHC_STRefuseReason');
     hospComp.options().onSelect = function (rowIndex, rowData) {
         PHA_COM.Session.HOSPID = rowData.HOSPRowId;
         Query();
     };
     var defHosp = $.cm(
         {
             dataType: 'text',
             ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
             MethodName: 'GetDefHospIdByTableName',
             tableName: 'DHC_STRefuseReason',
             HospID: PHA_COM.Session.HOSPID
         },
         false
     );
     PHA_COM.Session.HOSPID = defHosp;
     PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
 
 }
 