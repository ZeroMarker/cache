/**
 * 模块:     配液拒绝
 * 编写日期: 2020-08-24
 * 编写人:   yunhaibao
 */
 var SessionLoc = session['LOGON.CTLOCID'];
 var SessionUser = session['LOGON.USERID'];
 var hisPatNoLen = PIVAS.PatNoLength();
 var PersonSameFields = '[field=patNo],[field=patName],[field=bedNo],[field=wardDesc]';
 var SameRowsHanlder = PIVAS.Grid.SameRows('gridOrdExe', PersonSameFields);
 $(function () {
     InitDict();
     InitGridOrdExe();
     $('#btnFind').bind('click', Query);
     $('#btnRefuse').bind('click', Refuse);
     $('#btnCancel').bind('click', CancelRefuse);
     $('#txtPatNo').on('keypress', function (event) {
         if (window.event.keyCode == '13') {
             var patNo = $.trim($('#txtPatNo').val());
             if (patNo != '') {
                 patNo = PIVAS.FmtPatNo(patNo);
                 $('#txtPatNo').val(patNo);
                 Query();
             }
         }
     });
     // 流程单号
     $('#txtPrtNo').searchbox({
         width: 254,
         searcher: function (value, name) {
             if (event.keyCode == 13) {
                 Query();
                 return;
             }
             var pivaLocId = SessionLoc;
             var psNumber = ''; //$('#cmbPivaStat').combobox("getValue");
             PIVAS.PogsNoWindow({
                 TargetId: 'txtPrtNo',
                 PivaLocId: pivaLocId,
                 PsNumber: psNumber
             });
         }
     });
     $('.dhcpha-win-mask').remove();
 });
 
 function InitDict() {
     //日期
 //    PIVAS.Date.Init({ Id: 'datePrtStart', LocId: '', Type: 'Start', QueryType: 'Query' });
 //    PIVAS.Date.Init({ Id: 'datePrtEnd', LocId: '', Type: 'End', QueryType: 'Query' });
     PIVAS.Date.Init({ Id: 'dateOrdStart', LocId: '', Type: 'Start', QueryType: 'Query' });
     PIVAS.Date.Init({ Id: 'dateOrdEnd', LocId: '', Type: 'End', QueryType: 'Query' });
     // 病区
     PIVAS.ComboBox.Init({ Id: 'cmbWard', Type: 'Ward' }, {});
     // 药品名称
     PIVAS.ComboGrid.Init({ Id: 'cmgIncItm', Type: 'IncItm' }, { width: 254 });
     // 医嘱优先级
     PIVAS.ComboBox.Init({ Id: 'cmbPriority', Type: 'Priority' }, {});
     // 病区
     PIVAS.ComboBox.Init({ Id: 'cmbWard', Type: 'Ward' }, {});
     // 科室组
     PIVAS.ComboBox.Init({ Id: 'cmbLocGrp', Type: 'LocGrp' }, {});
     // 配伍审核
     PIVAS.ComboBox.Init({ Id: 'cmbPassResult', Type: 'PassResult' }, {});
     $('#cmbPassResult').combobox('setValue', '');
     // 批次
     PIVAS.BatchNoCheckList({ Id: 'DivBatNo', LocId: SessionLoc, Check: true, Pack: false });
     // 集中配制
     PIVAS.ComboBox.Init({ Id: 'cmbWorkType', Type: 'PIVAWorkType' }, {});
     // 配液拒绝
     PIVAS.ComboBox.Init(
         {
             Id: 'cmbPivaRefuse',
             Type: 'YesOrNo',
             data: {
                 data: [
                     { RowId: 'Y', Description: $g('已配液拒绝') },
                     { RowId: 'N', Description: $g('未配液拒绝') }
                 ]
             }
         },
         {}
     );
     PIVAS.ComboBox.Init(
         {
             Id: 'cmbPack',
             Type: 'PackType'
         },
         {}
     );
     PIVAS.ComboBox.Init(
         {
             Id: 'cmbPivaCat',
             Type: 'PivaCat'
         },
         {}
     );
 }
 
 // 医嘱明细列表
 function InitGridOrdExe() {
     var columns = [
         [
             {
                 field: 'gridSelect',
                 checkbox: true
             },
             {
                 field: 'refInfo',
                 title: '配液拒绝信息',
                 width: 155,
                 formatter: function (value, row, index) {
                     if (row.refReasonDesc !== '') {
                         var retHtmlArr = [];
 
                         retHtmlArr.push('<div class="pivas-grid-tip">');
                         retHtmlArr.push('	<div>');
                         retHtmlArr.push('   	<div>' + row.refDate + ' ' + row.refTime + '</div>');
                         retHtmlArr.push('	</div>');
                         retHtmlArr.push('	<div style="padding-top:8px;">');
                         retHtmlArr.push('   	<div>' + row.refUserName + ' / ' + row.refReasonDesc + '</div>');
                         retHtmlArr.push('   	<div style="clear:both"></div>');
                         retHtmlArr.push('	</div>');
                         retHtmlArr.push('</div>');
                         return retHtmlArr.join('');
                     } else {
                         return '';
                     }
                 },
                 styler: function (value, row, index) {
                     if (row.refUserName !== '') {
                         return 'background-color:#F4868E;color:white';
                     }
                 }
             },
             {
                 field: 'wardDesc',
                 title: '病区',
                 width: 125
             },
             {
                 field: 'bedNo',
                 title: '床号',
                 width: 75
             },
             {
                 field: 'patNo',
                 title: '登记号',
                 width: 100
             },
             {
                 field: 'patName',
                 title: '姓名',
                 width: 70
             },
             {
                 field: 'doseDateTime',
                 title: '用药时间',
                 width: 95
             },
             {
                 field: 'batNo',
                 title: '批次',
                 width: 50,
                 styler: function (value, row, index) {
                     var colorStyle = '';
                     if (row.packFlag != '') {
                         colorStyle += PIVAS.Grid.CSS.BatchPack;
                     }
                     return colorStyle;
                 }
             },
             {
                 field: 'drugsArr',
                 title: '药品信息',
                 width: 300,
                 formatter: PIVAS.Grid.Formatter.InciGroup
             },
             {
                 field: 'dosage',
                 title: '剂量',
                 width: 75,
                 align: 'right',
                 formatter: PIVAS.Grid.Formatter.DosageGroup
             },
             {
                 field: 'qtyUom',
                 title: '数量',
                 width: 50,
                 align: 'right',
                 formatter: PIVAS.Grid.Formatter.QtyUomGroup
             },
             {
                 field: 'freqDesc',
                 title: '频次',
                 width: 75
             },
             {
                 field: 'instrucDesc',
                 title: '用法',
                 width: 100
             },
             {
                 field: 'priDesc',
                 title: '医嘱优先级',
                 width: 90
             },
             {
                 field: 'psName',
                 title: '配液状态',
                 width: 80,
                 styler: PIVAS.Grid.Styler.PivaState
             },
             {
                 field: 'barCode',
                 title: '条码',
                 width: 125,
                 formatter: function (value, row, index) {
                     var field = 'barCode';
                     return '<a class="pha-grid-a" onclick="PIVASTIMELINE.Init({Params:\'' + value + "',Field:'" + field + "',ClickField:'" + field + '\'} )">' + value + '</a>';
                 }
             },
             {
                 field: 'passResultInfo',
                 title: '配伍审核信息',
                 width: 155,
                 formatter: function (value, row, index) {
                     var retArr = [];
                     retArr.push('<div>' + row.phaOrdDateTime + '</div>');
                     retArr.push('<div class="pivas-grid-div">');
                     retArr.push('   <div style="float:left">' + row.phaOrdUser + '</div>');
                     retArr.push('   <div style="float:right;font-weight:bold">' + row.passResultDesc + '</div>');
                     retArr.push('</div>');
                     return retArr.join('');
                 }
             },
 
             {
                 field: 'xDateTime',
                 title: '停止时间',
                 width: 155
             },
             {
                 field: 'oeoriStatDesc',
                 title: '医嘱状态',
                 width: 80
             },
             {
                 field: 'oeoreStatDesc',
                 title: '执行记录状态',
                 width: 100
             },
             {
                 field: 'refReasonDesc',
                 title: '拒绝原因',
                 width: 100,
                 hidden: true
             },
             {
                 field: 'pog',
                 title: 'pog',
                 width: 70,
                 hidden: true
             },
             {
                 field: 'durationDesc',
                 title: '疗程',
                 width: 50,
                 hidden: true
             },
             {
                 field: 'packFlag',
                 title: '打包',
                 width: 50,
                 hidden: true
             },
             {
                 field: 'mDsp',
                 title: 'mDsp',
                 width: 50,
                 hidden: true
             },
             {
                 field: 'sameFlag',
                 title: 'sameFlag',
                 width: 70,
                 hidden: true,
                 styler: function (value, row, index) {
                     if (value === 'Y') {
                         return {
                             class: 'pivas-person-toggle'
                         };
                     }
                 }
             }
         ]
     ];
     var dataGridOption = {
         url: '',
         fitColumns: false,
         columns: columns,
         singleSelect: false,
         selectOnCheck: false,
         checkOnSelect: false,
         pageSize: 100,
         pageList: [100, 300, 500, 100],
         toolbar: '#gridOrdExeBar',
         rowStyler: PIVAS.Grid.RowStyler.PersonAlt,
         onLoadSuccess: function () {
             $(this).datagrid('loaded');
             SameRowsHanlder.Hide();
             $('.pivas-grid-tip').each(function () {
                 var text = $(this).text();
                 if (text !== '') {
                     $(this).tooltip({
                         content: text,
                         position: 'right'
                     });
                 }
             });
             $(this).datagrid('uncheckAll');
         },
         onClickRow: function (rowIndex, rowData) {
             SameRowsHanlder.ShowRow(rowIndex);
         },
         onBeforeSelect: function (rowIndex, rowData) {
             $(this).datagrid('unselectAll');
         },
         onUnselect: function (rowIndex, rowData) {
             PIVAS.Grid.ClearSelections(this.id);
         },
         loadFilter: PIVAS.Grid.LoadFilter
     };
     PIVAS.Grid.Init('gridOrdExe', dataGridOption);
 }
 
 /// 查询
 function Query() {
     var $grid = $('#gridOrdExe');
     var pJson = QueryParams();
     PIVAS.Grid.PageHandler($grid);
     $grid.datagrid('loading');
     var rowsData = $.cm(
         {
             ClassName: 'web.DHCSTPIVAS.Refuse',
             QueryName: 'OrdExeData',
             pJsonStr: JSON.stringify(pJson),
             rows: 99999,
             page: 1
         },
         false
     );
     setTimeout(function () {
         $grid.datagrid('loadData', rowsData);
     }, 100);
 }
 /// 拒绝
 function Refuse() {
     $.messager.confirm('提示', '您确认拒绝配液吗?', function (r) {
         if (r) {
             var pogArr = GetPogChecked('R');
             if (pogArr.length == 0) {
                 DHCPHA_HUI_COM.Msg.popover({
                     msg: '请勾选需要配液拒绝的数据',
                     type: 'alert'
                 });
                 return;
             }
             PIVAS.RefuseReasonWindow({ pogArr: pogArr, user: SessionUser }, Query);
         }
     });
 }
 /// 取消拒绝
 function CancelRefuse() {
     $.messager.confirm('提示', '您确认取消拒绝吗?', function (r) {
         if (r) {
             var pogArr = GetPogChecked('C');
             if (pogArr.length == 0) {
                 DHCPHA_HUI_COM.Msg.popover({
                     msg: '请勾选需要取消配液拒绝的数据',
                     type: 'alert'
                 });
                 return;
             }
             $.cm(
                 {
                     ClassName: 'web.DHCSTPIVAS.Refuse',
                     MethodName: 'SaveData',
                     pogJsonStr: JSON.stringify(pogArr),
                     user: SessionUser,
                     reason: '',
                     exeType: 'C',
                     dataType: 'text'
                 },
                 function (retData) {
                     var retArr = retData.split('^');
                     if (retArr[0] == -1) {
                         $.messager.alert('提示', $got(retArr[1]), 'warning');
                     } else if (retArr[0] < -1) {
                         $.messager.alert('提示', $got(retArr[1]), 'error');
                     }
                     Query();
                 }
             );
         }
     });
 }
 
 function GetPogChecked(actionType) {
     var pogArr = [];
     var gridOrdExeChecked = $('#gridOrdExe').datagrid('getChecked');
     for (var i = 0; i < gridOrdExeChecked.length; i++) {
         var checkedData = gridOrdExeChecked[i];
         var pog = checkedData.pog;
         if (actionType === 'R' && checkedData.refReasonDesc === '') {
             pogArr.push(pog);
         }
         if (actionType === 'C' && checkedData.refReasonDesc !== '') {
             pogArr.push(pog);
         }
     }
     return pogArr;
 }
 
 function QueryParams() {
     var pJson = {};
     pJson.loc = SessionLoc;
     pJson.ordStartDate = $('#dateOrdStart').datebox('getValue'); // 起始日期
     pJson.ordEndDate = $('#dateOrdEnd').datebox('getValue'); // 截止日期
     pJson.prtStartDate = $('#datePrtStart').datebox('getValue'); // 起始日期
     pJson.prtEndDate = $('#datePrtEnd').datebox('getValue'); // 截止日期
     pJson.locGrp = $('#cmbLocGrp').combobox('getValue') || ''; // 科室组
     pJson.wardStr = $('#cmbWard').combobox('getValue') || ''; // 病区
     pJson.priority = $('#cmbPriority').combobox('getValue') || ''; // 医嘱优先级
     pJson.patNo = $.trim($('#txtPatNo').val()); // 登记号
     pJson.pogsNo = $('#txtPrtNo').searchbox('getValue'); // 单号
     pJson.refuseStat = $('#cmbPivaRefuse').combobox('getValue'); // 拒绝状态
     pJson.pivaCat = $('#cmbPivaCat').combobox('getValue'); // 配液大类
     pJson.workType = $('#cmbWorkType').combobox('getValue') || ''; // 工作组
     pJson.packFlag = $('#cmbPack').combobox('getValue') || ''; // 打包类型
     pJson.inci = $('#cmgIncItm').combobox('getValue') || '';
     var batNoArr = [];
     $('input[type=checkbox][name=batbox]').each(function () {
         if ($('#' + this.id).is(':checked')) {
             batNoArr.push($('#' + this.id).attr('text'));
         }
     });
     pJson.batNoStr = batNoArr.join(',');
     return pJson;
 }
 
