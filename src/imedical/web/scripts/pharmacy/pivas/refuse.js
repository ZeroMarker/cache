/**
 * ģ��:     ��Һ�ܾ�
 * ��д����: 2020-08-24
 * ��д��:   yunhaibao
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
     // ���̵���
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
     //����
 //    PIVAS.Date.Init({ Id: 'datePrtStart', LocId: '', Type: 'Start', QueryType: 'Query' });
 //    PIVAS.Date.Init({ Id: 'datePrtEnd', LocId: '', Type: 'End', QueryType: 'Query' });
     PIVAS.Date.Init({ Id: 'dateOrdStart', LocId: '', Type: 'Start', QueryType: 'Query' });
     PIVAS.Date.Init({ Id: 'dateOrdEnd', LocId: '', Type: 'End', QueryType: 'Query' });
     // ����
     PIVAS.ComboBox.Init({ Id: 'cmbWard', Type: 'Ward' }, {});
     // ҩƷ����
     PIVAS.ComboGrid.Init({ Id: 'cmgIncItm', Type: 'IncItm' }, { width: 254 });
     // ҽ�����ȼ�
     PIVAS.ComboBox.Init({ Id: 'cmbPriority', Type: 'Priority' }, {});
     // ����
     PIVAS.ComboBox.Init({ Id: 'cmbWard', Type: 'Ward' }, {});
     // ������
     PIVAS.ComboBox.Init({ Id: 'cmbLocGrp', Type: 'LocGrp' }, {});
     // �������
     PIVAS.ComboBox.Init({ Id: 'cmbPassResult', Type: 'PassResult' }, {});
     $('#cmbPassResult').combobox('setValue', '');
     // ����
     PIVAS.BatchNoCheckList({ Id: 'DivBatNo', LocId: SessionLoc, Check: true, Pack: false });
     // ��������
     PIVAS.ComboBox.Init({ Id: 'cmbWorkType', Type: 'PIVAWorkType' }, {});
     // ��Һ�ܾ�
     PIVAS.ComboBox.Init(
         {
             Id: 'cmbPivaRefuse',
             Type: 'YesOrNo',
             data: {
                 data: [
                     { RowId: 'Y', Description: $g('����Һ�ܾ�') },
                     { RowId: 'N', Description: $g('δ��Һ�ܾ�') }
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
 
 // ҽ����ϸ�б�
 function InitGridOrdExe() {
     var columns = [
         [
             {
                 field: 'gridSelect',
                 checkbox: true
             },
             {
                 field: 'refInfo',
                 title: '��Һ�ܾ���Ϣ',
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
                 title: '����',
                 width: 125
             },
             {
                 field: 'bedNo',
                 title: '����',
                 width: 75
             },
             {
                 field: 'patNo',
                 title: '�ǼǺ�',
                 width: 100
             },
             {
                 field: 'patName',
                 title: '����',
                 width: 70
             },
             {
                 field: 'doseDateTime',
                 title: '��ҩʱ��',
                 width: 95
             },
             {
                 field: 'batNo',
                 title: '����',
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
                 title: 'ҩƷ��Ϣ',
                 width: 300,
                 formatter: PIVAS.Grid.Formatter.InciGroup
             },
             {
                 field: 'dosage',
                 title: '����',
                 width: 75,
                 align: 'right',
                 formatter: PIVAS.Grid.Formatter.DosageGroup
             },
             {
                 field: 'qtyUom',
                 title: '����',
                 width: 50,
                 align: 'right',
                 formatter: PIVAS.Grid.Formatter.QtyUomGroup
             },
             {
                 field: 'freqDesc',
                 title: 'Ƶ��',
                 width: 75
             },
             {
                 field: 'instrucDesc',
                 title: '�÷�',
                 width: 100
             },
             {
                 field: 'priDesc',
                 title: 'ҽ�����ȼ�',
                 width: 90
             },
             {
                 field: 'psName',
                 title: '��Һ״̬',
                 width: 80,
                 styler: PIVAS.Grid.Styler.PivaState
             },
             {
                 field: 'barCode',
                 title: '����',
                 width: 125,
                 formatter: function (value, row, index) {
                     var field = 'barCode';
                     return '<a class="pha-grid-a" onclick="PIVASTIMELINE.Init({Params:\'' + value + "',Field:'" + field + "',ClickField:'" + field + '\'} )">' + value + '</a>';
                 }
             },
             {
                 field: 'passResultInfo',
                 title: '���������Ϣ',
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
                 title: 'ֹͣʱ��',
                 width: 155
             },
             {
                 field: 'oeoriStatDesc',
                 title: 'ҽ��״̬',
                 width: 80
             },
             {
                 field: 'oeoreStatDesc',
                 title: 'ִ�м�¼״̬',
                 width: 100
             },
             {
                 field: 'refReasonDesc',
                 title: '�ܾ�ԭ��',
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
                 title: '�Ƴ�',
                 width: 50,
                 hidden: true
             },
             {
                 field: 'packFlag',
                 title: '���',
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
 
 /// ��ѯ
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
 /// �ܾ�
 function Refuse() {
     $.messager.confirm('��ʾ', '��ȷ�Ͼܾ���Һ��?', function (r) {
         if (r) {
             var pogArr = GetPogChecked('R');
             if (pogArr.length == 0) {
                 DHCPHA_HUI_COM.Msg.popover({
                     msg: '�빴ѡ��Ҫ��Һ�ܾ�������',
                     type: 'alert'
                 });
                 return;
             }
             PIVAS.RefuseReasonWindow({ pogArr: pogArr, user: SessionUser }, Query);
         }
     });
 }
 /// ȡ���ܾ�
 function CancelRefuse() {
     $.messager.confirm('��ʾ', '��ȷ��ȡ���ܾ���?', function (r) {
         if (r) {
             var pogArr = GetPogChecked('C');
             if (pogArr.length == 0) {
                 DHCPHA_HUI_COM.Msg.popover({
                     msg: '�빴ѡ��Ҫȡ����Һ�ܾ�������',
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
                         $.messager.alert('��ʾ', $got(retArr[1]), 'warning');
                     } else if (retArr[0] < -1) {
                         $.messager.alert('��ʾ', $got(retArr[1]), 'error');
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
     pJson.ordStartDate = $('#dateOrdStart').datebox('getValue'); // ��ʼ����
     pJson.ordEndDate = $('#dateOrdEnd').datebox('getValue'); // ��ֹ����
     pJson.prtStartDate = $('#datePrtStart').datebox('getValue'); // ��ʼ����
     pJson.prtEndDate = $('#datePrtEnd').datebox('getValue'); // ��ֹ����
     pJson.locGrp = $('#cmbLocGrp').combobox('getValue') || ''; // ������
     pJson.wardStr = $('#cmbWard').combobox('getValue') || ''; // ����
     pJson.priority = $('#cmbPriority').combobox('getValue') || ''; // ҽ�����ȼ�
     pJson.patNo = $.trim($('#txtPatNo').val()); // �ǼǺ�
     pJson.pogsNo = $('#txtPrtNo').searchbox('getValue'); // ����
     pJson.refuseStat = $('#cmbPivaRefuse').combobox('getValue'); // �ܾ�״̬
     pJson.pivaCat = $('#cmbPivaCat').combobox('getValue'); // ��Һ����
     pJson.workType = $('#cmbWorkType').combobox('getValue') || ''; // ������
     pJson.packFlag = $('#cmbPack').combobox('getValue') || ''; // �������
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
 
