/**
 * ģ��:   ��Һɨ��ִ��
 * ��д����: 2020-07-06
 * ��д��:   yunhaibao
 */

 var SessionLoc = session['LOGON.CTLOCID'];
 var SessionUser = session['LOGON.USERID'];
 var SessionWard = session['LOGON.WARDID'] || '';
 var PIVAStateNumber = '';
 var PrtWardBatPS = '';
 var PHA_PIVAS_SCAN = {
     LabelGridOpts: function () {
         //����columns
         var columns = [
             [
                 {
                     field: 'warn',
                     title: 'warn',
                     width: 75,
                     hidden: true,
                     sortable: true
                 },
                 {
                     field: 'status',
                     title: '״̬',
                     width: 75,
                     sortable: true,
                     formatter: function (value, options, rowData) {
                         value = value || '';
                         return '<div style="white-space: normal;">' + value + '</div>';
                     }
                 },
                 {
                     field: 'barCode',
                     title: '�����',
                     width: 100,
                     sortable: true
                 },
                 {
                     field: 'batNo',
                     title: '����',
                     width: 50,
                     styler: function (value, row, index) {
                         var colorStyle = '';
                         if (row.packFlag != '') {
                             colorStyle = PIVAS.Grid.CSS.BatchPack;
                         }
                         return colorStyle;
                     }
                 },
                 {
                     field: 'pivaCatDesc',
                     title: '��Һ����',
                     width: 72
                 },
 
                 {
                     field: 'patInfo',
                     title: '������Ϣ',
                     width: 230,
                     formatter: function (value, rowData, index) {
                         var retHtmlArr = [];
                         retHtmlArr.push('<div class="pha-scan-ward">' + rowData.wardLocDesc + '</div>');
                         retHtmlArr.push('<div style="padding-top:8px">');
                         retHtmlArr.push('   <div style="float:left;width:125px">' + rowData.patBedNo + ' / ' + rowData.patName + '</div>');
                         retHtmlArr.push('   <div style="float:right">' + rowData.patNo + '</div>');
                         retHtmlArr.push('</div>');
                         return retHtmlArr.join('');
                     }
                 },
                 {
                     field: 'useInfo',
                     title: '�÷���Ϣ',
                     width: 130,
                     formatter: function (value, rowData, index) {
                         var retHtmlArr = [];
 
                         retHtmlArr.push('<div>');
                         retHtmlArr.push('   <div style="float:left;width:75px">' + rowData.doseDTHtml + '</div>');
                         retHtmlArr.push('   <div style="float:right">' + rowData.freqDesc + '</div>');
                         retHtmlArr.push('   <div style="clear:both"></div>');
                         retHtmlArr.push('</div>');
                         retHtmlArr.push('<div style="padding-top:8px">' + rowData.instrucDesc + '</div>');
                         return retHtmlArr.join('');
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
                 }
             ]
         ];
         var dataGridOption = {
             pagination: true,
             pageList: [1000, 2000],
             pageSize: 1000,
             fitColumns: false,
             fit: true,
             rownumbers: false,
             remoteSort: false,
             columns: columns,
             onClickRow: function (rowIndex, rowData) {},
             singleSelect: true,
             selectOnCheck: true,
             checkOnSelect: true,
             queryOnSelect: false,
             rowStyler: function (index, rowData) {
                 if (rowData.warn !== '') {
                     return { class: 'pha-scan-' + rowData.warn };
                 }
             }
         };
         return dataGridOption;
     }
 };
 $(function () {
     InitDict();
     InitGridWard();
     InitGridLabel();
     InitGridLabelUnScaned();
     InitGridLabelScaned();
     InitPivasSettings();
     $('#txtBarCode').on('keypress', function (event) {
         if (event.keyCode == '13') {
             ScanHandler();
         }
     });
     $('#btnFind').on('click', Query);
     $('#btnFindUnScaned').on('click', QueryDetail);
     $('#btnFindScaned').on('click', QueryDetail);
     $('#btnRefresh').on('click', RefreshHandler);
     $('#btnClean').on('click', CleanHandler);
     $('#btnPrint').on('click', ShowPrint);
     $('#btnPrtSelectDivOk').on('click', PrintHandler);
 
     $('.dhcpha-win-mask').remove();
     $('.datagrid-pager table').css('display', 'none');
     // $('#gridLabel').datagrid('autoSizeColumn','drugsInfo');
     // $('#gridLabel').datagrid('autoSizeColumn','patInfo');
     // $('#gridLabel').datagrid('autoSizeColumn','batNo');
     // $('#gridLabel').datagrid('autoSizeColumn','barCode');
 });
 function InitDict() {
     PIVAS.ComboBox.Init({ Id: 'conBatNo', Type: 'Batch' }, { width: 330, multiple: true, panelHeight: 'auto' });
     PIVAS.ComboBox.Init({ Id: 'conPivaCat', Type: 'PivaCat' }, { width: 330, multiple: true, panelHeight: 'auto' });
     PIVAS.ComboBox.Init(
         {
             Id: 'conPivaStat',
             Type: 'PIVAState'
         },
         {
             width: 330,
             editable: false,
             readonly: PIVAStateNumber != '' ? true : false,
             onLoadSuccess: function () {},
             onSelect: function (data) {
                 ToggleBtnPrt();
                 Query();
             },
             onBeforeLoad: function (param) {
                 var noPs = '3,10';
                 if (SessionWard == '') {
                     noPs += ',90';
                 }
                 param.inputStr = SessionLoc + '^' + noPs + '^' + 'execute';
                 param.filterText = param.q;
             }
         }
     );
 
     $('#kwScanStat').keywords({
         singleSelect: true,
         items: [
             { text: 'ȫ��', id: '0', selected: true },
             { text: '��ɨ', id: '1' },
             { text: 'δɨ', id: '2' }
         ],
         onClick: function (data) {
             FilterScanStat(data.id);
         }
     });
 }
 function FilterScanStat(stat) {
     var rowsData = $('#gridLabel').datagrid('getRows');
     $('[id^=datagrid-row-r2-]').show();
     var total = rowsData.length;
     if (stat != 0) {
         for (var i = 0; i < rowsData.length; i++) {
             var rowData = rowsData[i];
             var warn = rowData.warn || '';
 
             if (stat == '1') {
                 if (warn == '') {
                     $('#datagrid-row-r2-2-' + i).hide();
                     total--;
                 }
             } else {
                 if (warn !== '') {
                     $('#datagrid-row-r2-2-' + i).hide();
                     total--;
                 }
             }
         }
     }
     // ���пɼ����ݸ��ºϼ���
     $('#gridLabel').datagrid('getPager').pagination('options').total = total;
     $('#gridLabel').datagrid('getPager').pagination('refresh');
 }
 //��ʼ�������б�
 function InitGridWard() {
     //����columns
     var columns = [
         [
             {
                 field: 'select',
                 checkbox: true
             },
             {
                 field: 'wardLoc',
                 title: 'wardLoc',
                 hidden: true
             },
             {
                 field: 'wardLocDesc',
                 title: '����',
                 width: 200,
                 sortable: true
             },
             {
                 field: 'unScaned',
                 title: '�ϼ�',
                 width: 40,
                 align: 'right',
                 sortable: true
             }
             // {
             //     field: 'scaned',
             //     title: '��ɨ',
             //     width: 40,
             //     sortable:true
             // }
         ]
     ];
     var dataGridOption = {
         url: $URL,
         queryParams: {
             ClassName: 'web.DHCSTPIVAS.Scan',
             QueryName: 'WardData'
         },
         pagination: false,
         fitColumns: true,
         fit: true,
         toolbar: '#gridWardToolbar',
         rownumbers: false,
         columns: columns,
         onClickRow: function (rowIndex, rowData) {},
         singleSelect: false,
         selectOnCheck: true,
         checkOnSelect: true,
         queryOnSelect: false,
         onSelect: SelectQuery,
         onUnselect: SelectQuery,
         onClickCell: function (rowIndex, field, value) {
             if (field !== 'select') {
                 $(this).datagrid('options').queryOnSelect = true;
             }
         },
         onLoadSuccess: function () {
             // $("#gridOrdItem").datagrid("clear");
             $(this).datagrid('uncheckAll');
             CleanScan();
             CleanPanel();
         }
     };
     DHCPHA_HUI_COM.Grid.Init('gridWard', dataGridOption);
     function SelectQuery(rowIndex, rowData) {
         var $grid = $('#gridWard');
         if ($grid.datagrid('options').queryOnSelect == true) {
             $grid.datagrid('options').queryOnSelect = false;
             RefreshHandler();
         }
     }
 }
 
 //��ʼ�������б�
 function InitGridLabel() {
     var labelGridOption = PHA_PIVAS_SCAN.LabelGridOpts();
     var options = {
         onLoadSuccess: function (data) {
             $(this).datagrid('uncheckAll');
             if (data.total > 0) {
                 $('#txtScanTotal').text(data.total);
                 $('#txtScaned').text(0);
                 var geneNo = tkMakeServerCall('web.DHCSTPIVAS.Scan', 'GeneNo', SessionLoc, $('#conPivaStat').combobox('getValue'));
                 $('#txtGeneNo').text(geneNo);
             } else {
                 CleanPanel();
             }
         },
         toolbar: '#gridLabelBar'
     };
 
     PIVAS.Grid.Init('gridLabel', $.extend({}, labelGridOption, options));
 }
 // ����λ
 
 //��ʼ�������б�
 function InitGridLabelUnScaned() {
     var labelGridOption = PHA_PIVAS_SCAN.LabelGridOpts();
     var options = {
         toolbar: '#gridLabelUnScanedBar'
     };
     PIVAS.Grid.Init('gridLabelUnScaned', $.extend({}, labelGridOption, options));
     $('#gridLabelUnScaned').datagrid('hideColumn', 'status');
 }
 
 //��ʼ�������б�
 function InitGridLabelScaned() {
     var labelGridOption = PHA_PIVAS_SCAN.LabelGridOpts();
     var options = {
         toolbar: '#gridLabelScanedBar'
     };
     PIVAS.Grid.Init('gridLabelScaned', $.extend({}, labelGridOption, options));
     $('#gridLabelScaned').datagrid('hideColumn', 'status');
 }
 
 function ScanHandler() {
     var barCode = $('#txtBarCode').val().trim();
     if (barCode === '') {
         return;
     }
     var gridRows = $('#gridLabel').datagrid('getRows');
     if (gridRows.length === 0) {
         DHCPHA_HUI_COM.Msg.popover({
             msg: $g('���Ȳ�ѯ����ϸ�ٽ���ɨ��'),
             type: 'alert'
         });
         $('#txtBarCode').val('').focus();
         return;
     }
     var barCodeIndex = GetLabelIndex(barCode);
     if (barCodeIndex === '') {
         $.messager.confirm($g('��ʾ'), $g('ɨ����ϸ�в����ڸü�¼���Ƿ�ִ�У�'), function (r) {
             if (r) {
                 AddNewLabelRow(barCode);
                 SaveScan();
             } else {
                 $('#txtBarCode').val('').focus();
             }
         });
     } else {
         SaveScan();
     }
 }
 function SaveScan() {
     var barCode = $('#txtBarCode').val().trim();
     var barCodeIndex = GetLabelIndex(barCode);
 
     var pJson = GetQueryParams();
 
     var wardLocArr = [];
     var gridChked = $('#gridWard').datagrid('getChecked');
     for (var i = 0; i < gridChked.length; i++) {
         wardLocArr.push(gridChked[i].wardLoc);
     }
 
     var wardLocStr = wardLocArr.join(',');
     pJson.wardLocStr = wardLocStr;
     pJson.pogsNo = $('#txtGeneNo').text().trim();
     pJson.barCode = barCode;
 
     var retData = tkMakeServerCall('web.DHCSTPIVAS.Scan', 'Execute', JSON.stringify(pJson));
 
     var retDataArr = retData.split('|$|');
     PIVAS.Media.Play('success');
     $('#txtBarCode').val('').focus();
     FillLabel(barCodeIndex, retDataArr[1], retDataArr[0], retDataArr[2]);
 }
 function FillLabel(rowIndex, status, warn, labelData) {
     $('#labelResult').text(status);
     $('#labelResult').removeClass('pha-scan-success pha-scan-error pha-scan-warning');
     $('#labelResult').addClass('pha-scan-' + warn);
     PIVASLABEL.Init({ labelData: labelData });
 
     if (rowIndex !== '') {
         $('#gridLabel').datagrid('updateRow', {
             index: rowIndex,
             row: {
                 status: status,
                 warn: warn
             }
         });
         $('#gridLabel').datagrid('scrollTo', rowIndex);
     }
     if (warn === 'success') {
         $('#txtScaned').text($('#txtScaned').text() * 1 + 1);
     }
     $('#txtBarCode').val('').focus();
 }
 function GetLabelIndex(barCode) {
     var rows = $('#gridLabel').datagrid('getRows');
     var rowIndex = '';
     for (var i = 0; i < rows.length; i++) {
         var rowBarCode = rows[i].barCode;
         if (rowBarCode === barCode) {
             rowIndex = i;
             break;
         }
     }
     return rowIndex;
 }
 
 function RefreshHandler() {
     var chkRet = CheckRefreshHandler();
     if (chkRet != '') {
         DHCPHA_HUI_COM.Msg.popover({
             msg: chkRet,
             type: 'alert'
         });
         return;
     }
 
     $('#txtBarCode').removeAttr('disabled');
     $('#txtBarCode').focus();
     QueryDetail('gridLabel');
 }
 
 function CheckRefreshHandler() {
     if ($('#conPivaStat').combobox('getValue') === '') {
         return $g('����ѡ����Һ״̬');
     }
 
     return '';
 }
 function Query() {
     var pJson = GetQueryParams();
     if (pJson.psNumber === '') {
         DHCPHA_HUI_COM.Msg.popover({
             msg: $g('����ѡ����Һ״̬'),
             type: 'alert'
         });
         return;
     }
     $('#gridWard').datagrid('query', {
         pJsonStr: JSON.stringify(pJson)
     });
 }
 function GetQueryParams() {
     return {
         loc: SessionLoc,
         user: SessionUser,
         startDate: $('#conStartDate').datebox('getValue'),
         endDate: $('#conEndDate').datebox('getValue'),
         psNumber: $('#conPivaStat').combobox('getValue'),
         batNoStr: $('#conBatNo').combobox('getText'),
         catStr: $('#conPivaCat').combobox('getValues').join(','),
         pScanStatus: ''
     };
 }
 function GetCurrentTabID() {
     var tabOptions = $('.hisui-tabs').tabs('getSelected').panel('options');
     var tabTitle = tabOptions.title;
     var tabId = tabOptions.id;
     return tabId;
 }
 
 function QueryDetail() {
     var tabID = GetCurrentTabID();
 
     var pJson = GetQueryParams();
     pJson.pScanStatus = tabID;
     var wardLocArr = [];
     var gridChked = $('#gridWard').datagrid('getChecked');
     for (var i = 0; i < gridChked.length; i++) {
         wardLocArr.push(gridChked[i].wardLoc);
     }
     var wardLocStr = wardLocArr.join(',');
     pJson.wardLocStr = wardLocStr;
 
     var gridID = '';
     if (tabID === 'allScan') {
         gridID = 'gridLabel';
     } else if (tabID === 'unScaned') {
         gridID = 'gridLabelUnScaned';
     } else if (tabID === 'scaned') {
         gridID = 'gridLabelScaned';
     }
     if (wardLocStr === '') {
         $('#' + gridID).datagrid('clear');
         return;
     }
     $.cm(
         {
             ClassName: 'web.DHCSTPIVAS.Scan',
             QueryName: 'LabelData',
             pJsonStr: JSON.stringify(pJson)
         },
         function (rowsData) {
             $('#' + gridID).datagrid('loadData', rowsData);
             var kwSel = $('#kwScanStat').keywords('getSelected');
             FilterScanStat(kwSel[0].id);
         }
     );
 }
 
 function ResizeDrugs() {}
 
 function CleanHandler() {
     $('#gridWard').datagrid('clear');
     $('#conBatNo,#conPivaCat,#conPivaStat').combobox('clear');
     InitPivasSettings();
 }
 
 function CleanScan() {
     $('#gridLabel,#gridLabelUnScaned,#gridLabelScaned').datagrid('clear');
 }
 function CleanPanel() {
     $('#txtGeneNo').text($g('[ ���� ]'));
     $('#txtScaned').text($g('[ ��ɨ ]'));
     $('#txtScanTotal').text($g('[ �ϼ� ]'));
     $('#labelResult').text($g('[ ɨ���� ]'));
     $('#labelResult').removeClass('pha-scan-success pha-scan-error pha-scan-warning').addClass('pha-scan-success');
     $('#labelContent').html(GetEmptyHtml('û������Ŷ��ɨ���ǩ�����ɣ�'));
 }
 
 function AddNewLabelRow(barCode) {
     var pJson = {
         barCode: barCode
     };
     var rowsData = $.cm(
         {
             ClassName: 'web.DHCSTPIVAS.Scan',
             QueryName: 'LabelData',
             pJsonStr: JSON.stringify(pJson)
         },
         false
     );
     if (rowsData.total === 1) {
         $('#gridLabel').datagrid('appendRow', rowsData.rows[0]);
     }
 }
 function ShowPrint() {
     var geneNo = $('#txtGeneNo').text().trim();
     if (geneNo.indexOf($g('����')) >= 0) {
         DHCPHA_HUI_COM.Msg.popover({
             msg: $g('��δ��ʼɨ��,��ɨ����ɺ�ʼ��ӡ'),
             type: 'alert'
         });
         return;
     }
     $('#prtSelectDiv').window('open');
 }
 function PrintHandler() {
     var geneWay = 1; //$("input[name='genePOGSNo']:checked").val() || '';
     var prtWay = $("input[name='prtPOGSWay']:checked").val() || '';
     if (geneWay === '' || prtWay === '') {
         DHCPHA_HUI_COM.Msg.popover({
             msg: $g('����ѡ���Ӧ��ʽ'),
             type: 'alert'
         });
         return;
     }
     var geneNo = $('#txtGeneNo').text().trim();
     var pJson = [geneNo];
     /**
      * �����Ҫ��ӡ��Һ�������д��ڴ���ӡ������, ��ʹ�� ##class(web.DHCSTPIVAS.Execute).SaveByCondition
      */
     var ret = $.cm(
         {
             ClassName: 'web.DHCSTPIVAS.Execute',
             MethodName: 'SaveDataByPOGSNo',
             pogsNo: geneNo,
             userId: SessionUser,
             psNumber: PrtWardBatPS,
             grpWay: geneWay,
             dataType: 'text'
         },
         false
     );
     var retArr = ret.split('^');
     if (retArr[0] < 0) {
         $.messager.alert($g('��ʾ'), retArr[1], 'warning');
         return;
     }
 
     var pogsNoStr = retArr[1];
     var printType = '';
     if (prtWay == 1) {
         printType = 'Inci';
     } else if (prtWay == 0) {
         printType = 'Total';
     }
     PIVASPRINT.WardBat.Handler({
         pogsNoArr: pogsNoStr.split('!!'),
         loc: session['LOGON.CTLOCID'],
         rePrint: '',
         printType: printType
     });
 
     $('#prtSelectDiv').window('close');
     RefreshHandler();
 }
 
 // ��ʼ��Ĭ������
 function InitPivasSettings() {
     $.cm(
         {
             ClassName: 'web.DHCSTPIVAS.Settings',
             MethodName: 'GetAppProp',
             userId: session['LOGON.USERID'],
             locId: session['LOGON.CTLOCID'],
             appCode: 'Scan'
         },
         function (jsonData) {
             $('#conStartDate').datebox('setValue', jsonData.OrdStDate);
             $('#conEndDate').datebox('setValue', jsonData.OrdEdDate);
             PIVAS.VAR.MaxDrugCnt = jsonData.MaxDrugCnt;
         }
     );
     $.cm(
         {
             ClassName: 'web.DHCSTPIVAS.Settings',
             MethodName: 'GetAppProp',
             userId: session['LOGON.USERID'],
             locId: session['LOGON.CTLOCID'],
             appCode: 'Execute'
         },
         function (jsonData) {
             PrtWardBatPS = 85;
             //$('[name=genePOGSNo][value=' + jsonData.GeneWay + ']').radio('setValue', true);
             $('[name=prtPOGSWay][value=' + jsonData.PrtWay + ']').radio('setValue', true);
         }
     );
 }
 
 function ToggleBtnPrt() {
     var curPs = $('#conPivaStat').combobox('getValue');
     var rows = $('#conPivaStat').combobox('getData');
     var len = rows.length;
     for (var i = len - 1; i >= 0; i--) {
         var rowData = rows[i];
         var ps = rowData.RowId;
         if (ps == PrtWardBatPS) {
             if (curPs === rows[i - 1].RowId) {
                 $('#btnPrintSeparator').show();
                 $('#btnPrint').show();
                 return;
             }
         }
     }
     $('#btnPrintSeparator').hide();
     $('#btnPrint').hide();
 }
 
 /**
  * ����UI�������
  * ԭ��ʽ: <img src="../scripts/pharmacy/common/image/bg-label-nodata.png" width="360px">
  */
 function GetEmptyHtml(tipsMsg) {
	 try {
		 tipsMsg = $g(tipsMsg);
	 } catch(e){}
	 var eHtml = '';
	 eHtml += '<div style="width:100%; text-align:center; overflow:hidden;">';
	 eHtml += '	<div style="margin-top:20px;">';
	 eHtml += '		<img src="../scripts/pharmacy/common/image/nodata-small.png" width="60px" height="60px;">';
	 eHtml += '	</div>';
	 eHtml += '	<div style="margin-top:10px; color:#999999; font-size:16px;">';
	 eHtml += '		' + tipsMsg + '';
	 eHtml += '	</div>';
	 eHtml += '</div>';
	 return eHtml;
 }

 
