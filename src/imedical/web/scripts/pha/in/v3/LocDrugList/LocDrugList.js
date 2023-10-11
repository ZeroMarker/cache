//scripts/pha/in/v3/LocDrugList/LocDrugList.js
/**
 * @ģ��:     ������ҩĿ¼
 * @��д����: 2020-07-01
 * @��д��:   yangsj
 */

var HosId = session['LOGON.HOSPID'];
var ComBoxWidth = 300 - 15;
var lookUpWidth = 453 - 15;
var searchBoxWidth = 392 - 15;
var ComBoxWidthLoc = 343 - 15;
var DurgToLocLeft=492 - 15
$(function () {
    InitDictBegin(); 	// ��ʼ�����ᷢ���仯��Ԫ��
    InitDict(); 		// ��ʼ����������Ԫ��
    InitGird(); 		// �б��ʼ��
    InitEvent(); 		// ���¼�
    ImportHandler();
    InitTrans();        //panel title����
});

function InitTrans(){
	$('#panel2').panel('setTitle',$g('����-ҽ����<font color=green>(��ά��)</font>'));
	$('#panel3').panel('setTitle',$g('����-ҽ����<font color=red>(δά��)</font>'));
	$('#panel4').panel('setTitle',$g('����-����ͨ����<font color=green>(��ά��)</font>'));
	$('#panel5').panel('setTitle',$g('����-����ͨ����<font color=red>(δά��)</font>'));
	$('#panel6').panel('setTitle',$g('ҽ�������б�<font color=green>(��ά��)</font>'));
	$('#panel7').panel('setTitle',$g('ҽ�������б�<font color=red>(δά��)</font>'));
}

//����ҽԺ������Ӱ��Ŀؼ��ڴ˳�ʼ��
function InitDictBegin() {
    PHA.ComboBox('cmbHos', {
        url: PHA_STORE.CTHosNew("PHAIN_LocDrugList").url, //CTHospital
        width: ComBoxWidth,
    });
    setTimeout('SetDefaultHos()', 100);
}

/// �ӳٰ�ҽԺ
function SetDefaultHos() {
    $('#cmbHos').combobox('setValue', HosId);

    ///�����ؼ�������ӳٰ��¼��Ļ����ᱻ�����¼����ǣ�ֻ���ӳ�ִ�У�����Ҫ��ԭ���¼������ƹ�������Ȼ���¼�ֻ��ȡһ��
    /// ����-ҽ����-��ά�� �б�
    $('#LULocInciArcim').lookup({
        onSelect: function (rowIndex, rowData) {
            var idField = $('#LULocInciArcim').lookup('options').idField;
            $('#LULocInciArcim').lookup('setValue', rowData[idField]);
            QueryLocInciArcimGrid();
        },
    });
    $('#LULocInciArcim').on('blur', function () {
        var ArcItm = $('#LULocInciArcim').lookup('getValue') || '';
        if (ArcItm != '') return; //ʧȥ�����¼�ֻ��ɾ��ҽ�����������ˢ���¼����Ϸ�onSelectʱ����
        QueryLocInciArcimGrid();
    });
    /// ����-ҽ����-δά�� �б�
    $('#LULocInciArcimNo').lookup({
        onSelect: function (rowIndex, rowData) {
            var idField = $('#LULocInciArcimNo').lookup('options').idField;
            $('#LULocInciArcimNo').lookup('setValue', rowData[idField]);
            QueryLocWithOutDrugARCGrid();
        },
    });
    $('#LULocInciArcimNo').on('blur', function () {
        var ArcItm = $('#LULocInciArcimNo').lookup('getValue') || '';
        if (ArcItm != '') return; //ʧȥ�����¼�ֻ��ɾ��ҽ�����������ˢ���¼����Ϸ�onSelectʱ����
        QueryLocWithOutDrugARCGrid();
    });
    /// ҽ�������б�
    $('#LUArcimAndLoc').lookup({
        onSelect: function (rowIndex, rowData) {
            var idField = $('#LUArcimAndLoc').lookup('options').idField;
            $('#LUArcimAndLoc').lookup('setValue', rowData[idField]);
            QueryDrugArcGird();
        },
    });
    $('#LUArcimAndLoc').on('blur', function () {
        var ArcItm = $('#LUArcimAndLoc').lookup('getValue') || '';
        if (ArcItm != '') return; //ʧȥ�����¼�ֻ��ɾ��ҽ�����������ˢ���¼����Ϸ�onSelectʱ����
        QueryDrugArcGird();
    });
    /// ����ͨ�������б�
    $('#LUPHCGMain').lookup({
        onSelect: function (rowIndex, rowData) {
            var idField = $('#LUPHCGMain').lookup('options').idField;
            $('#LUPHCGMain').lookup('setValue', rowData[idField]);
            QueryDrugPHCGGird();
        },
    });
    $('#LUPHCGMain').on('blur', function () {
        var PHCG = $('#LUPHCGMain').lookup('getValue') || '';
        if (PHCG != '') return; //ʧȥ�����¼�ֻ��ɾ��ҽ�����������ˢ���¼����Ϸ�onSelectʱ����
        QueryDrugPHCGGird();
    });
    /// ����-����ͨ����-��ά���б�
    $('#LULocPhcg').lookup({
        onSelect: function (rowIndex, rowData) {
            var idField = $('#LULocPhcg').lookup('options').idField;
            $('#LULocPhcg').lookup('setValue', rowData[idField]);
            QueryLocWithPHCGGrid();
        },
    });
    $('#LULocPhcg').on('blur', function () {
        var PHCG = $('#LULocPhcg').lookup('getValue') || '';
        if (PHCG != '') return; //ʧȥ�����¼�ֻ��ɾ��ҽ�����������ˢ���¼����Ϸ�onSelectʱ����
        QueryLocWithPHCGGrid();
    });
    /// ����-����ͨ����-δά���б�
    $('#LULocPhcgNo').lookup({
        onSelect: function (rowIndex, rowData) {
            var idField = $('#LULocPhcgNo').lookup('options').idField;
            $('#LULocPhcgNo').lookup('setValue', rowData[idField]);
            QueryLocWithOutPHCGGrid();
        },
    });
    $('#LULocPhcgNo').on('blur', function () {
        var PHCG = $('#LULocPhcgNo').lookup('getValue') || '';
        if (PHCG != '') return; //ʧȥ�����¼�ֻ��ɾ��ҽ�����������ˢ���¼����Ϸ�onSelectʱ����
        QueryLocWithOutPHCGGrid();
    });
    /// ����-���ҽ��-��ά���б�
    $('#TextLocDoc').searchbox({
	    searcher:function(value,name){
	    QueryLocWithDocGrid();
	    },
	    width:searchBoxWidth,
	    prompt:'ҽ��ģ������...'
	});
    /// ����-���ҽ��-δά���б�
    $('#TextLocDocNo').searchbox({
	    searcher:function(value,name){
	    QueryLocWithOutDocGrid();
	    },
	    width:searchBoxWidth,
	    prompt:'ҽ��ģ������...'
	});
    
    /// ���ҽ�����б�
    $('#TextLocDocMain').searchbox({
	    searcher:function(value,name){
	    QueryDocGird();
	    },
	    width:DurgToLocLeft,
	    prompt:'ҽ��ģ������...'
	});
}

function InitEvent() {
    // ��ҽԺ����ѡ������������Ҫ���³�ʼ�������³�ʼ���ķ�ʽ���޸�PHA_COM.Session.HOSPID��ֵΪѡ��ҽԺ�������ֵ
    $('#cmbHos').combobox({
        onChange: function () {
            var hos = $('#cmbHos').combobox('getValue'); //ȡѡ��ֵ
            PHA_COM.Session.HOSPID = hos;
            InitDict();
            queryList();
            QueryDrugArcGird();
        },
    });
    $('#cmbDocLoc').combobox({
        onChange: function () {
            queryList();
        },
    });

    $('#cmbDrugDocLoc').combobox({
        onChange: function () {
            QueryDrugWithLocGird();
        },
    });

    $('#cmbDrugDocLocNo').combobox({
        onChange: function () {
            QueryDrugWithOutLocGird();
        },
    });
    
    
    $('#tabPrt').tabs('options').onSelect = function (title, index) {
	    
    }
    
    
    //������ά��ҩƷ/��ҩƷά������ ֮����л�
    $('#tabPrt').tabs('options').onSelect = function (title, index) {
        ClearGridI();
        ClearConditionI();
        var tabTitle = $('#tabPrt').tabs('getSelected').panel('options').title;
	    if (tabTitle == $g('������ά��ҩƷ')) {
		    QueryLocGird();
	    }
	    if (tabTitle == $g('��ҩƷά������')) {
		    QueryDrugWithOutLocGird();
	    	QueryDrugWithLocGird();
	    }
   		}
    
    //������ά��ҩƷ ���Ҳ� ҽ����/����ͨ����/ҩƷ���� ֮����л�
    $('#tabARCOrPHCG').tabs('options').onSelect = function (title, index) {
        ClearGridI();
        ClearConditionI();
        var tabTitle = $('#tabARCOrPHCG').tabs('getSelected').panel('options').title;
        var tabId = $('#tabARCOrPHCG').tabs('getSelected').panel('options').id;
	    if (tabId == 'tabARCLable') {
	        QueryLocWithOutDrugARCGrid();
	        QueryLocInciArcimGrid();
	    } else if (tabId =='tabPHCGeLable') {
	        QueryLocWithOutPHCGGrid();
	        QueryLocWithPHCGGrid();
	    } else if (tabId == 'tabDOCLable') {
		    QueryLocWithOutDocGrid();
		    QueryLocWithDocGrid();
	    }
     }
    $('#tabDrugArcOrPhcg').tabs('options').onSelect = function (title, index) { 
        ClearGridI();
        ClearConditionI();
        
        QueryLocWithOutDrugARCGrid();
	    QueryLocWithOutPHCGGrid();
	    QueryDrugWithOutLocGird();
	    QueryDrugWithLocGird();
	    QueryLocWithOutDocGrid();
    }
    
    
    $("#btnDownLoad").on("click", DownLoadModel);
}
//���ص���ģ��
function DownLoadModel(){
	
	var title={
		locDesc:"��������",
		ArcCode:"ҽ�������",
		ArcDesc:"ҽ��������",
		phcgeCode:"����ͨ��������",
		phcgeDesc:"����ͨ��������",
	}
	var data=[{locDesc:'������', ArcCode:"XWY000153",ArcDesc:"˫��̩����Ƭ[CO*10]"}, {locDesc:'������', phcgeCode:"TY1918",phcgeDesc:"�����"}]
	var fileName="����ҩƷĿ¼����ģ��.xlsx"
	PHA_COM.ExportFile(title, data, fileName);
	
	//window.open("../scripts/pha/in/v3/LocDrugList/����ҩƷĿ¼����ģ��.xlsx", "_blank");	
}

////  ----------------------------����¼�����-----Start--------///
/// �����������б�
function ClearGridI()
{
	$('#LocInciArcimGrid').datagrid('clear');
    $('#LocInciArcimGrid').datagrid('clearSelections');
    $('#LocWithOutDrugARCGrid').datagrid('clear');
    $('#LocWithOutDrugARCGrid').datagrid('clearSelections');
    $('#LocWithPHCGGrid').datagrid('clear');
    $('#LocWithPHCGGrid').datagrid('clearSelections');
    $('#LocWithOutPHCGGrid').datagrid('clear');
    $('#LocWithOutPHCGGrid').datagrid('clearSelections');
    $('#LocWithDocGrid').datagrid('clear');
    $('#LocWithDocGrid').datagrid('clearSelections');
    $('#LocWithOutDocGrid').datagrid('clear');
    $('#LocWithOutDocGrid').datagrid('clearSelections');
    $('#DrugWithLocGird').datagrid('clear');
    $('#DrugWithLocGird').datagrid('clearSelections');
    $('#DrugWithOutLocGird').datagrid('clear');
    $('#DrugWithOutLocGird').datagrid('clearSelections');
}
/// ����������б������
function ClearConditionI()
{
	$('#conFileBox').filebox('clear');
	$('#LULocInciArcim').lookup('setValue',"");
	$('#LULocInciArcim').lookup('setText',"");
	$('#LULocInciArcimNo').lookup('setValue',"");
	$('#LULocInciArcimNo').lookup('setText',"");
	$('#LULocPhcg').lookup('setValue',"");
	$('#LULocPhcg').lookup('setText',"");
	$('#LULocPhcgNo').lookup('setValue',"");
	$('#LULocPhcgNo').lookup('setText',"");
	
	$('#cmbDrugDocLoc').combobox('setValue',"");
	$('#cmbDrugDocLocNo').combobox('setValue',"");
	
	$('#TextLocDoc').val("");
	$('#TextLocDocNo').val("");
}
/// ������������������ҽԺ
function ClearMian()
{
	$('#cmbHos').combobox('setValue', HosId);
	$('#LUArcimAndLoc').lookup('setValue',"");
	$('#LUArcimAndLoc').lookup('setText',"");
	$('#LUPHCGMain').lookup('setValue',"");
	$('#LUPHCGMain').lookup('setText',"");
	$('#cmbDocLoc').combobox('setValue',"");
	$('#TextLocDocMain').val("");
}

/// ������ť
function clean()
{
	ClearGridI();
    ClearConditionI();
    ClearMian();
}
////  ----------------------------����¼�����-----End--------///

function ImportHandler() {
	$("#conFileBox").filebox({
		prompt: $g('��ѡ���ļ�...'),
		buttonText: $g('ѡ��'),
		width: 250,
		accept: 'application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
	})
	$("#btnFileBox").on("click", function(){
		var filelist = $('#conFileBox').filebox("files");
		if (filelist.length == 0) {
			//alert("����ѡ���ļ�")
			PHA.Alert($g('��ʾ'), $g("����ѡ���ļ���"), 'warning');
			return
		}
		var file = filelist[0];
		var importData="";
		PHA_COM.ReadExcel(file,function(xlsData){
			var dataLen = xlsData.length ;
			//alert(JSON.stringify(xlsData))
			//var JSONData = JSON.stringify(xlsData) ;
			for (var num=0;num<dataLen;num++){
				var sData = xlsData[num] ;  //��������	ҽ�������	ҽ��������	����ͨ��������	����ͨ��������

				var Locdesc = sData['��������'] ;  
				var arcCode = sData['ҽ�������'] ;  
				var phcGeneCode = sData['����ͨ��������'] ;  
				var data= [Locdesc,arcCode,phcGeneCode].join("^")
					importData=(importData=="")?data:importData+"##"+data ;
			}
			if ((importData=="")||(importData==null)||(importData==undefined)){
				PHA.Alert($g('��ʾ'), $g("û�л�ȡ����Ҫ����ҩƷ��ϸ��Ϣ����ע��Excelģ���ʽ�Ƿ���ȷ��"), 'warning');
				return ;
			}
			var importRet = tkMakeServerCall("PHA.IN.LocDrugList.Save","importData",importData)
			var RetArr = importRet.split("^");
			var RetSucc = RetArr[0];
			var RetVal = RetArr[1];
			if (RetSucc < 0) {
				PHA.Alert($g('��ʾ'), $g("����ʧ�ܣ�������Ϣ��")+RetVal, 'warning');
			} else {				
				var msgInfo = $g("����ɹ�!");
				PHA.Alert($g('��ʾ'), msgInfo, 'success');
				queryList()
				
			}
		})
		
	});
}

// �ӳٵ���getText��������Ϊ��������ѡ���¼�����ʱ��������δ��Desc��ֵ����ʱ������getTextȡֵ��
function EventUnite() {
    setTimeout('showTmpCombPanel()', 100);
}

/// ---------------------------�����б��ѯ����������-------Start-------------------/////
///��ѯ�ĸ����б�
function queryList() {
    QueryLocGird();
    QueryDrugArcGird();
    QueryDrugPHCGGird();
    QueryDocGird();
    QueryLocWithOutDrugARCGrid();
    QueryLocWithOutPHCGGrid();
    QueryDrugWithOutLocGird();
    QueryLocWithOutDocGrid();
    
}

function QueryLocInciArcimGrid() {
    var gridSelect = $('#LocGird').datagrid('getSelected') || '';
    var LDLRowId = '';
    if (gridSelect) LDLRowId = gridSelect.LDLRowId;
    if (LDLRowId == '') return;
    var WithArc = $('#LULocInciArcim').lookup('getValue') || '';
    $('#LocInciArcimGrid').datagrid('query', {
        inputStr: LDLRowId + '^' + WithArc + '^^ARC', //+"^"+WithArc
    });
}

function QueryLocWithOutDrugARCGrid() {
    var gridSelect = $('#LocGird').datagrid('getSelected') || '';
    var LDLRowId = '';
    if (gridSelect) LDLRowId = gridSelect.LDLRowId;
    //if (LDLRowId == '') return;
    var WithOutArc = $('#LULocInciArcimNo').lookup('getValue') || '';
    $('#LocWithOutDrugARCGrid').datagrid('query', {
        inputStr: LDLRowId + '^' + WithOutArc + '^' + $('#cmbHos').combobox('getValue'),
    });
}

function QueryLocWithPHCGGrid() {
    var gridSelect = $('#LocGird').datagrid('getSelected') || '';
    var LDLRowId = '';
    if (gridSelect) LDLRowId = gridSelect.LDLRowId;
    if (LDLRowId == '') return;
    var WithPhcg = $('#LULocPhcg').lookup('getValue') || '';
    $('#LocWithPHCGGrid').datagrid('query', {
        inputStr: LDLRowId + '^^' + WithPhcg + '^PHCG',
    });
}

function QueryLocWithOutPHCGGrid() {
    var gridSelect = $('#LocGird').datagrid('getSelected') || '';
    var LDLRowId = '';
    if (gridSelect) LDLRowId = gridSelect.LDLRowId;
    //if (LDLRowId == '') return;
    var WithOutPhcg = $('#LULocPhcgNo').lookup('getValue') || '';
    $('#LocWithOutPHCGGrid').datagrid('query', {
        inputStr: LDLRowId + '^' + WithOutPhcg + '^' + $('#cmbHos').combobox('getValue'),
    });
}

function QueryDrugPHCGGird() {
    var HosID = $('#cmbHos').combobox('getValue') || '';
    var Phcg = $('#LUPHCGMain').lookup('getValue') || '';
    var inputStr = '' + '^' + Phcg + '^' + HosID;
    $('#DrugPHCGGird').datagrid('query', {
        inputStr: inputStr,
    });
}

function QueryDrugArcGird() {
    var HosID = $('#cmbHos').combobox('getValue') || '';
    var Arc = $('#LUArcimAndLoc').lookup('getValue') || '';
    var inputStr = '' + '^' + Arc + '^' + HosID;
    $('#DrugArcGird').datagrid('query', {
        inputStr: inputStr,
    });
}

function QueryDrugWithLocGird() {
    //var tabTitle = $('#tabDrugArcOrPhcg').tabs('getSelected').panel('options').title;
    var tabId = $('#tabDrugArcOrPhcg').tabs('getSelected').panel('options').id;  
    var arcimId = '',
        phcgId = '',
        pcpId = '';
    if (tabId == 'tabARCLable') {
        var gridSelect = $('#DrugArcGird').datagrid('getSelected') || '';
        if (gridSelect) arcimId = gridSelect.arcimId;
    } else if (tabId == 'tabPHCGeLable') {
        var gridSelect = $('#DrugPHCGGird').datagrid('getSelected') || '';
        if (gridSelect) phcgId = gridSelect.phcg;
    } else if (tabId == 'tabDOCeLable') {
        var gridSelect = $('#DocGird').datagrid('getSelected') || '';
        if (gridSelect) pcpId = gridSelect.pcpId;
    }
    if (arcimId == '' && phcgId == '' && pcpId == '') return;

    var DrugDocLoc = $('#cmbDrugDocLoc').combobox('getValue') || '';
    var HosID = $('#cmbHos').combobox('getValue') || '';
    var inputStr =
        HosID + '^' + arcimId + '^' + phcgId + '^' + DrugDocLoc + '^' + 'Y' + '^' + pcpId;
    $('#DrugWithLocGird').datagrid('query', {
        inputStr: inputStr,
    });
}

function QueryDrugWithOutLocGird() {
    //var tabTitle = $('#tabDrugArcOrPhcg').tabs('getSelected').panel('options').title;
    var tabId = $('#tabDrugArcOrPhcg').tabs('getSelected').panel('options').id;  
    var arcimId = '',
        phcgId = '',
        pcpId = '';
    if (tabId == 'tabARCLable') {
        var gridSelect = $('#DrugArcGird').datagrid('getSelected') || '';
        if (gridSelect) arcimId = gridSelect.arcimId;
    } else if (tabId == 'tabPHCGeLable') {
        var gridSelect = $('#DrugPHCGGird').datagrid('getSelected') || '';
        if (gridSelect) phcgId = gridSelect.phcg;
    } else if (tabId == 'tabDOCeLable') {
        var gridSelect = $('#DocGird').datagrid('getSelected') || '';
        if (gridSelect) pcpId = gridSelect.pcpId;
    }
    if (arcimId == '' && phcgId == '' && pcpId == '') return;

    var DrugDocLoc = $('#cmbDrugDocLocNo').combobox('getValue') || '';
    var HosID = $('#cmbHos').combobox('getValue') || '';
    var inputStr =
        HosID + '^' + arcimId + '^' + phcgId + '^' + DrugDocLoc + '^' + 'N' + '^' + pcpId;

    $('#DrugWithOutLocGird').datagrid('query', {
        inputStr: inputStr,
    });
}
function QueryLocGird() {
    $('#LocGird').datagrid('clear');
    $('#LocGird').datagrid('clearSelections');
    $('#LocGird').datagrid('query', {
        inputStr: $('#cmbHos').combobox('getValue') + '^' + $('#cmbDocLoc').combobox('getValue'),
    });
}

function QueryLocWithDocGrid() {
    var gridSelect = $('#LocGird').datagrid('getSelected') || '';
    var LDLRowId = '';
    if (gridSelect) LDLRowId = gridSelect.LDLRowId;
    if (LDLRowId == '') return;
    var HospId = $('#cmbHos').combobox('getValue');
    var LocDocQText =$('#TextLocDoc').searchbox("getValue")
    var WithFlag = 'Y';
    var inputStr = HospId + '^' + LDLRowId + '^' + LocDocQText + '^' + WithFlag;
    $('#LocWithDocGrid').datagrid('query', {
        inputStr: inputStr,
    });
}

function QueryLocWithOutDocGrid() {
    var gridSelect = $('#LocGird').datagrid('getSelected') || '';
    var LDLRowId = '';
    if (gridSelect) LDLRowId = gridSelect.LDLRowId;
    //if (LDLRowId == '') return;
    var HospId = $('#cmbHos').combobox('getValue');
    var LocDocNoQText =$('#TextLocDocNo').searchbox("getValue") 
    var WithFlag = 'N';
    var inputStr = HospId + '^' + LDLRowId + '^' + LocDocNoQText + '^' + WithFlag;
    $('#LocWithOutDocGrid').datagrid('query', {
        inputStr: inputStr,
    });
}
function QueryDocGird() {
    var LDLRowId = '';
    var HospId = $('#cmbHos').combobox('getValue');
    var LocDocMainQText =  $('#TextLocDocMain').searchbox("getValue") 
    var WithFlag = '';
    var inputStr = HospId + '^' + LDLRowId + '^' + LocDocMainQText + '^' + WithFlag;
    $('#DocGird').datagrid('query', {
        inputStr: inputStr,
    });
}

/// ---------------------------�����б��ѯ����������-------End-------------------/////

///��ʼ�������б�
function InitGird() {
    InitLocGird();
    InitLocInciArcimGrid();
    InitLocWithOutDrugARCGrid();
    InitDrugArcGird();
    InitDrugWithLocGird();
    InitDrugWithOutLocGird();
    InitLocWithPHCGGrid();
    InitLocWithOutPHCGGrid();
    InitDrugPHCGGird();
    //InitLocWithDocGrid();
    //InitLocWithOutDocGrid();
    //InitDocGird();
}

////---------------------------------��ʼ�������б�----Start------------------////
//��ʼ�������б�
function InitLocGird() {
    var columns = [
        [
            // combRowid,combItmRowid,activeFlag,CtrlLevel,CombItmType,CombItmTypeVal,limitQty,combItmSign
            { field: 'LDLRowId', 	title: 'LDLRowId',	 	align: 'center', 	width: 80, 		hidden: true },
            { field: 'locCode',	 	title: $g('���Ҵ���'), 		align: 'left', 	width: 100, 	hidden: true },
            { field: 'locDesc', 	title: $g('��������'), 		align: 'left', 		width: 150 },
            
            
        ],
    ];
    var frozenColumns = [
        [
            {
                field: 'deleteBut',
                title: $g('ɾ��'),
                align: 'center',
                width: 59,
                formatter: deleteLocFormatter,
                frozencols:true	
            },{
                field: 'activeFlag',
                title: $g('����״̬'),
                align: 'center',
                width: 90,
                formatter: statusFormatter,
            }
        ]
    ];
    var dataGridOption = {
        fitColumns: true,
        fit: true,
        toolbar: '#LocBar',
        rownumbers: true,
        pagination: true,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        width: 1500,
        nowrap: false,
        idField: 'LDLRowId',
        columns: columns,
        frozenColumns: frozenColumns,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocDrugList.Query',
            QueryName: 'QueryLDLLocList',
            inputStr: HosId,
        },
        onLoadSuccess: function (data) {
            var pageSize = $('#LocGird').datagrid('getPager').data('pagination').options.pageSize;
            var total = data.total;
            if (data.curPage > 0 && total > 0 && total <= pageSize) {
                $('#LocGird').datagrid('selectRow', 0);
            }
            $('.hisui-switchbox').switchbox();
        },
        onSelect: function (rowIndex, rowData) {
            QueryLocInciArcimGrid();
            QueryLocWithOutDrugARCGrid();
            QueryLocWithPHCGGrid();
            QueryLocWithOutPHCGGrid();
            //QueryLocWithDocGrid();
            //QueryLocWithOutDocGrid();
        },
    };
    PHA.Grid('LocGird', dataGridOption);
}

//�Զ���״̬�и�ʽ-����
function statusFormatter(value, rowData, rowIndex) {
    var LDLRowId = rowData.LDLRowId;
    var value = rowData.activeFlag;
    var IndexString = JSON.stringify(rowIndex);
    if (value == 'Y') {
        return (
            "<div class=\"hisui-switchbox\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'��',offText:'��',checked:" +
            'true' +
            ',disabled:false,onSwitchChange:function(e, obj){UpdateLocStatus(obj.value,' +
            LDLRowId +
            ',' +
            IndexString +
            ",'" +
            value +
            '\')}"></div>'
        );
    } else {
        return (
            "<div class=\"hisui-switchbox\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'��',offText:'��',checked:" +
            'false' +
            ',disabled:false,onSwitchChange:function(e, obj){UpdateLocStatus(obj.value,' +
            LDLRowId +
            ',' +
            IndexString +
            ",'" +
            value +
            '\')}"></div>'
        );
    }
}

function UpdateLocStatus(objVal,LDLRowId, Index, value) {
    if (objVal) value = 'Y';
    else value = 'N';
    $.cm(
        {
            ClassName: 'PHA.IN.LocDrugList.Save',
            MethodName: 'UpdateLocActive',
            LDLRowId: LDLRowId,
            ActiveFlag: value,
        },
        function (retData) {
            if (!retData) {
                PHA.Popover({ showType: 'show', msg: $g('�޸Ŀ���״̬�ɹ�'), type: 'success' });
            } else
                PHA.Popover({
                    showType: 'show',
                    msg: $g('�޸Ŀ���״̬ʧ�ܣ� ��������') + retData.desc,
                    type: 'alert',
                });
        }
    );
    
}

//�Զ���״̬�и�ʽ-ҽ����
function statusFormatteri(value, rowData, rowIndex) {
    var LDLRowId = rowData.LDLRowId;
    var IndexString = JSON.stringify(rowIndex);
    if (value == 'Y') {
        return (
            "<div class=\"hisui-switchboxi\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'��',offText:'��',checked:" +
            'true' +
            ',disabled:false,onSwitchChange:function(v, e){Update(' +
            LDLRowId +
            ',' +
            IndexString +
            ",'" +
            value +
            '\')}"></div>'
        );
    } else {
        return (
            "<div class=\"hisui-switchboxi\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'��',offText:'��',checked:" +
            'false' +
            ',disabled:false,onSwitchChange:function(v, e){Update(' +
            LDLRowId +
            ',' +
            IndexString +
            ",'" +
            value +
            '\')}"></div>'
        );
    }
}

function deleteLocFormatter(value, rowData, rowIndex) {
    var LDLRowId = rowData.LDLRowId;
    return (
        '<span class="icon icon-cancel"  onclick="DeleteLDLRow(\'' +
        LDLRowId +
        '\')">&ensp;</span>'
    );
}

function AddFormatter(value, rowData, rowIndex) {
    var DUlRowID = rowData.DULRowId;
    return (
        '<span class="icon icon-add" style="cursor:pointer;width: 24px;height: 16px;display: inline-block;" onclick="DeleteDULRow(\'' +
        DUlRowID +
        '\')">&ensp;</span>'
    );
}

function DeleteLDLRow(LDLRowId) {
    $.cm(
        {
            ClassName: 'PHA.IN.LocDrugList.Save',
            MethodName: 'DeleteLoc',
            LDLRowId: LDLRowId,
        },
        function (retData) {
            if (!retData) {
                PHA.Popover({ showType: 'show', msg: $g('ɾ�����ҳɹ�'), type: 'success' });
                queryList();
            } else
                PHA.Popover({
                    showType: 'show',
                    msg: $g('ɾ������ʧ�ܣ� ��������') + retData.desc,
                    type: 'alert',
                });
        }
    );
}
////---------------------------------��ʼ�������б�----End------------------////

///-------------------------��ʼ������-ҽ����-��ά��---------Start------------------////
//��ʼ������-ҽ����-��ά��
function InitLocInciArcimGrid() {
    var columns = [
        [
            // LDLIRowid,arcCode,arcDesc
            { field: 'LDLIRowid', title: 'LDLIRowid', align: 'center', width: 80, hidden: true },
            {
                field: 'deleteBut',
                title: $g('ɾ��'),
                align: 'center',
                width: 60,
                formatter: deleteLocDrugFormatter,
            },
            { field: 'arcCode', title: $g('ҽ�������'), align: 'left', width: 100 },
            { field: 'arcDesc', title: $g('ҽ��������'), align: 'left', width: 315 },
        ],
    ];
    var dataGridOption = {
        fitColumns: true,
        fit: true,
        toolbar: '#LocAndArcBar',
        //rownumbers: true,
        pagination: true,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        width: 1500,
        nowrap: false,
        idField: 'LDLIRowid',
        columns: columns,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocDrugList.Query',
            QueryName: 'QueryLDLItm',
            inputStr: '',
        },
        onLoadSuccess: function (data) {},
    };
    PHA.Grid('LocInciArcimGrid', dataGridOption);
}

function deleteLocDrugFormatter(value, rowData, rowIndex) {
    var LDLIRowid = rowData.LDLIRowid;
    return (
        '<span class="icon icon-cancel"  onclick="DeleteLDLIRow(\'' +
        LDLIRowid +
        '\')">&ensp;</span>'
    );
}
function DeleteLDLIRow(LDLIRowId) {
    //var tabTitle = $('#tabARCOrPHCG').tabs('getSelected').panel('options').title;
    var tabId = $('#tabARCOrPHCG').tabs('getSelected').panel('options').id;
    $.cm(
        {
            ClassName: 'PHA.IN.LocDrugList.Save',
            MethodName: 'DeleteLocDrug',
            LDLIRowId: LDLIRowId,
        },
        function (retData) {
            if (!retData) {
                if (tabId == 'tabPHCGeLable') {
                    PHA.Popover({ showType: 'show', msg: $g('ɾ������ͨ�����ɹ�'), type: 'success' });
                    QueryLocWithPHCGGrid();
                    QueryLocWithOutPHCGGrid();
                } else if (tabId == 'tabARCLable') {
                    PHA.Popover({ showType: 'show', msg: $g('ɾ��ҽ����ɹ�'), type: 'success' });
                    QueryLocInciArcimGrid();
                    QueryLocWithOutDrugARCGrid();
                }
            } else
                PHA.Popover({
                    showType: 'show',
                    msg: $g('ɾ��ҽ����ʧ�ܣ� ��������') + retData.desc,
                    type: 'alert',
                });
        }
    );
}

///-----------------------------��ʼ������-ҽ����-��ά��---------End------------------////
///-----------------------------��ʼ������-ҩƷ-δά��----Start---------------------////

//��ʼ������-ҩƷ-δά��
function InitLocWithOutDrugARCGrid() {
    var columns = [
        [
            // arcimId,arcimCode,arcimDesc
            { field: 'arcimId', title: 'arcimId', align: 'center', width: 80, hidden: true },
            {
                field: 'AddBut',
                title: $g('���'),
                align: 'center',
                width: 60,
                formatter: AddArcFormatter,
            },
            { field: 'arcimCode', title: $g('ҽ�������'), align: 'left', width: 100 },
            { field: 'arcimDesc', title: $g('ҽ��������'), align: 'left', width: 335 },
            
        ],
    ];
    var dataGridOption = {
        //fitColumns: true,
        fit: true,
        toolbar: '#LocWithOutArcBar',
        //rownumbers: true,
        pagination: true,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        width: 1500,
        nowrap: false,
        idField: 'arcimId',
        columns: columns,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocDrugList.Query',
            QueryName: 'QueryLDLItmWithOut',
            inputStr: '',
        },
        onLoadSuccess: function (data) {
            //$('.hisui-switchboxi').switchbox();
        },
    };
    PHA.Grid('LocWithOutDrugARCGrid', dataGridOption);
}

function AddArcFormatter(value, rowData, rowIndex) {
    var arcimId = rowData.arcimId;
    var phcgId = rowData.phcg;
    if (!arcimId) arcimId = '';
    if (!phcgId) phcgId = '';
    //alert("<a href='#' onclick='AddLDLI(\""+arcimId+"\",\""+phcgId+"\")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' border=0/></a>")
    return (
        '<span class="icon icon-add" style="cursor:pointer;width: 24px;height: 16px;display: inline-block;" onclick="AddLDLI(\'' +
        arcimId +
        '\',\'' +
        phcgId +
        '\')">&ensp;</span>'
    );
}

function AddLDLI(arcimId, phcgId) {
    //alert(arcimId+"^"+phcgId)
    var gridSelect = $('#LocGird').datagrid('getSelected');
    var LDLRowId = '';
    if (gridSelect) LDLRowId = gridSelect.LDLRowId;

    var DocLoc = $('#cmbDocLoc').combobox('getValue');
    if (LDLRowId == '' && DocLoc == '') {
        PHA.Popover({ showType: 'show', msg: $g('��ѡ��һ������'), type: 'alert' });
        return;
    }
    var detailTitle=$g("ҽ����")
    if (phcgId!="") detailTitle=$g("����ͨ����")
    $.cm(
        {
            ClassName: 'PHA.IN.LocDrugList.Save',
            MethodName: 'AddLocDrug',
            Hosp:$('#cmbHos').combobox('getValue'),
            LDLRowId: LDLRowId,
            Arc: arcimId,
            Phcg: phcgId,
            DocLoc: DocLoc,
        },
        
        function (retData) {
            if (!retData) {
                PHA.Popover({ showType: 'show', msg:$g( '���')+detailTitle+$g('�ɹ�'), type: 'success' });
                if (arcimId) {
                    QueryLocInciArcimGrid();
                    QueryLocWithOutDrugARCGrid();
                }
                if (phcgId) {
                    QueryLocWithPHCGGrid();
                    QueryLocWithOutPHCGGrid();
                }
                if (LDLRowId == '') {
                    $('#LocGird').datagrid('clear');
                    $('#LocGird').datagrid('clearSelections');
                    $('#LocGird').datagrid('query', {
                        inputStr:
                            $('#cmbHos').combobox('getValue') +
                            '^' +
                            $('#cmbDocLoc').combobox('getValue'),
                    });
                }
            } else
                PHA.Popover({
                    showType: 'show',
                    msg: $g('���')+detailTitle+$g('ʧ�ܣ� ��������:') + retData.desc,
                    type: 'alert',
                });
        }
    );
}

///-----------------------------��ʼ������-ҩƷ-δά��----End---------------------////
///------------------------------��ʼ��ҽ���б�----Start----------------------------------///

//��ʼ��ҽ���б�
function InitDrugArcGird() {
    var columns = [
        [
            // arcimId,arcimCode,arcimDesc
            { field: 'arcimId', title: 'arcimId', align: 'center', width: 80, hidden: true },
            { field: 'arcimCode', title: $g('ҽ�������'), align: 'left', width: 100 },
            { field: 'arcimDesc', title: $g('ҽ��������'), align: 'left', width: 369 },
        ],
    ];
    var dataGridOption = {
        fitColumns: true,
        fit: true,
        toolbar: '#ArcBar',
        //rownumbers: true,
        pagination: true,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        width: 1500,
        nowrap: false,
        idField: 'arcimId',
        columns: columns,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocDrugList.Query',
            QueryName: 'QueryLDLItmWithOut',
            inputStr: '^^' + HosId,
        },
        onLoadSuccess: function (data) {
            $('.hisui-switchboxi').switchbox();
            var pageSize = $('#DrugArcGird').datagrid('getPager').data('pagination').options.pageSize;
            var total = data.total;
            if (data.curPage > 0 && total > 0 ) {   //&& total <= pageSize
                $('#DrugArcGird').datagrid('selectRow', 0);
            }
           
            
        },
        onSelect: function (rowIndex, rowData) {
            QueryDrugWithLocGird();
            QueryDrugWithOutLocGird();
        },
    };
    PHA.Grid('DrugArcGird', dataGridOption);
}

///------------------------------��ʼ��ҽ���б�----End----------------------------------///
///------------------------------��ʼ����ͨ�����б�----Start----------------------------------///

//��ʼ����ͨ�����б�
function InitDrugPHCGGird() {
    var columns = [
        [
            // phcg,phcgCode,phcgDesc
            { field: 'phcg', title: 'phcg', align: 'center', width: 80, hidden: true },
            { field: 'phcgCode', title: $g('����ͨ��������'), align: 'left', width: 150 },
            { field: 'phcgDesc', title: $g('����ͨ��������'), align: 'left', width: 319 },
        ],
    ];
    var dataGridOption = {
        fitColumns: true,
        fit: true,
        toolbar: '#PHCGMainBar',
        //rownumbers: true,
        pagination: true,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        width: 1500,
        nowrap: false,
        idField: 'phcg',
        columns: columns,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocDrugList.Query',
            QueryName: 'QueryLDLItmWithOutPHCG',
            inputStr: '',
        },
        onLoadSuccess: function (data) {
            $('.hisui-switchboxi').switchbox();
             var pageSize = $('#DrugPHCGGird').datagrid('getPager').data('pagination').options.pageSize;
            var total = data.total;
            if (data.curPage > 0 && total > 0 ) {   //&& total <= pageSize
                $('#DrugPHCGGird').datagrid('selectRow', 0);
            }
        },
        onSelect: function (rowIndex, rowData) {
            QueryDrugWithLocGird();
            QueryDrugWithOutLocGird();
        },
    };
    PHA.Grid('DrugPHCGGird', dataGridOption);
}
///------------------------------��ʼ����ͨ�����б�----End----------------------------------///

//// --------------------------------��ʼ��ҩƷ-����-��ά��-----Start-----------------------------////
//��ʼ��ҩƷ-����-��ά��
function InitDrugWithLocGird() {
    var columns = [
        [
            // LDLIRowId,loc,loccode,locdesc
            { field: 'LDLIRowId', title: 'LDLIRowId', align: 'center', width: 80, hidden: true },
            {
                field: 'deleteBut',
                title: $g('ɾ��'),
                align: 'center',
                width: 50,
                formatter: deleteDrugLocFormatter,
            },
            { field: 'loc', title: '����id', align: 'center', width: 100, hidden: true },
            { field: 'loccode', title: $g('���Ҵ���'), align: 'left', width: 100 },
            { field: 'locdesc', title: $g('��������'), align: 'left', width: 140 },
            {
                field: 'Status',
                title: $g('Ŀ¼״̬'),
                align: 'center',
                width: 80,
                formatter: DrugLocStatusFormatter,
            },
            
        ],
    ];
    var dataGridOption = {
        fitColumns: true,
        fit: true,
        toolbar: '#ArcAndLocBar',
        //rownumbers: true,
        pagination: true,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        width: 1500,
        nowrap: false,
        idField: 'LDLIRowId',
        columns: columns,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocDrugList.Query',
            QueryName: 'QueryLocByDrug',
            inputStr: '',
        },
        onLoadSuccess: function (data) {
            //$('.hisui-switchboxi').switchbox();
        },
    };
    PHA.Grid('DrugWithLocGird', dataGridOption);
}

function DrugLocStatusFormatter(value, rowData, rowIndex) {
    var Status = rowData.Status;
    if (Status == 'Y')
        return "<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/accept.png' border=0/>";
    else return "<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/no.png' border=0/>";
}

function deleteDrugLocFormatter(value, rowData, rowIndex) {
    var LDLIRowId = rowData.LDLIRowId;
    return (
        '<span class="icon icon-cancel"  onclick="DeleteArcLDLIRow(\'' +
        LDLIRowId +
        '\')">&ensp;</span>'
    );
}
function DeleteArcLDLIRow(LDLIRowId) {
    var tabTitle = $('#tabDrugArcOrPhcg').tabs('getSelected').panel('options').title;
    if (tabTitle.indexOf($g('���ҽ��ά��'))<0) {
        $.cm(
            {
                ClassName: 'PHA.IN.LocDrugList.Save',
                MethodName: 'DeleteLocDrug',
                LDLIRowId: LDLIRowId,
            },
            function (retData) {
                if (!retData) {
                    PHA.Popover({ showType: 'show', msg: $g('ɾ��ҽ�����ҳɹ�'), type: 'success' });
                    QueryDrugWithLocGird();
                    QueryDrugWithOutLocGird();
                } else
                    PHA.Popover({
                        showType: 'show',
                        msg: $g('ɾ��ҽ������ʧ�ܣ� ��������') + retData.desc,
                        type: 'alert',
                    });
            }
        );
    } else {
        $.cm(
            {
                ClassName: 'PHA.IN.LocDrugList.Save',
                MethodName: 'DeleteLocDoc',
                LDDIRowId: LDLIRowId,
            },
            function (retData) {
                if (!retData) {
                    PHA.Popover({ showType: 'show', msg: $g('ɾ��ҽ�����ҳɹ�'), type: 'success' });
                    QueryDrugWithLocGird();
                    QueryDrugWithOutLocGird();
                } else
                    PHA.Popover({
                        showType: 'show',
                        msg: $g('ɾ��ҽ������ʧ�ܣ� ��������') + retData.desc,
                        type: 'alert',
                    });
            }
        );
    }
}

//// --------------------------------��ʼ��ҩƷ-����-��ά��-----END-----------------------------////

//// --------------------------------��ʼ��ҩƷ-����-δά��-----Start-----------------------------////

//��ʼ��ҩƷ-����-δά��
function InitDrugWithOutLocGird() {
    var columns = [
        [
            // ,loc,locdesc
            //{field:'combItmRowid',	title:'DULCRowIdi',	align:'center', width: 80,hidden:true},
            { field: 'loc', title: 'loc', align: 'center', width: 100, hidden: true },
            {
                field: 'deleteBut',
                title: $g('���'),
                align: 'center',
                width: 50,
                formatter: AddLocBYDrugFormatter,
            },
            { field: 'loccode', title: $g('���Ҵ���'), align: 'left', width: 100 },
            { field: 'locdesc', title: $g('��������'), align: 'left', width: 220 },
            
        ],
    ];
    var dataGridOption = {
        //fitColumns: true,
        fit: true,
        toolbar: '#ArcWithOutLocBar',
        //rownumbers: true,
        pagination: true,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        width: 1500,
        nowrap: false,
        idField: 'loc',
        columns: columns,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocDrugList.Query',
            QueryName: 'QueryLocByDrug',
            inputStr: '',
        },
        onLoadSuccess: function (data) {
            //$('.hisui-switchboxi').switchbox();
        },
    };
    PHA.Grid('DrugWithOutLocGird', dataGridOption);
}

function AddLocBYDrugFormatter(value, rowData, rowIndex) {
    var loc = rowData.loc;
    return (
        '<span class="icon icon-add" style="cursor:pointer;width: 24px;height: 16px;display: inline-block;" onclick="AddLocBYDrug(\'' +
        loc +
        '\')">&ensp;</span>'
    );

}

function AddLocBYDrug(loc) {
    //var tabTitle = $('#tabDrugArcOrPhcg').tabs('getSelected').panel('options').title;
    var tabId = $('#tabDrugArcOrPhcg').tabs('getSelected').panel('options').id;
    var arcimId = '',
        phcgId = '',
        pcpId = '';
    if (tabId == 'tabARCLable') {
        var gridSelect = $('#DrugArcGird').datagrid('getSelected') || '';
        if (gridSelect) arcimId = gridSelect.arcimId;
    } else if (tabId == 'tabPHCGeLable') {
        var gridSelect = $('#DrugPHCGGird').datagrid('getSelected') || '';
        if (gridSelect) phcgId = gridSelect.phcg;
    } else if (tabId == 'tabDOCLable') {
        var gridSelect = $('#DocGird').datagrid('getSelected') || '';
        if (gridSelect) pcpId = gridSelect.pcpId;
    }

    if (arcimId == '' && phcgId == '' && pcpId == '') {
        PHA.Popover({
            showType: 'show',
            msg: $g('��ѡ��һ��ҽ����/����ͨ����/���ҽ����'),
            type: 'alert',
        });
        return;
    }
    if (tabId != 'tabDOCLable') {
        $.cm(
            {
                ClassName: 'PHA.IN.LocDrugList.Save',
                MethodName: 'AddLocDrug',
                Hosp:$('#cmbHos').combobox('getValue'),
                LDLRowId: '',
                Arc: arcimId,
                Phcg: phcgId,
                DocLoc: loc,
            },
            function (retData) {
                if (!retData) {
                    PHA.Popover({
                        showType: 'show',
                        msg: $g('���ҽ�����ҳɹ�'),
                        type: 'success',
                    });
                    QueryDrugWithLocGird();
                    QueryDrugWithOutLocGird();
                } else
                    PHA.Popover({
                        showType: 'show',
                        msg: $g('���ҽ������ʧ�ܣ� ��������:') + retData.desc,
                        type: 'alert',
                    });
            }
        );
    } else {
        $.cm(
            {
                ClassName: 'PHA.IN.LocDrugList.Save',
                MethodName: 'AddLocDoc',
                LDLRowId: '',
                CTCP: pcpId,
                DocLoc: loc,
            },
            function (retData) {
                if (!retData) {
                    PHA.Popover({ showType: 'show', msg: $g('���ҽ�����ҳɹ�'), type: 'success' });
                    QueryDrugWithLocGird();
                    QueryDrugWithOutLocGird();
                } else
                    PHA.Popover({
                        showType: 'show',
                        msg: $g('���ҽ������ʧ�ܣ� ��������:') + retData.desc,
                        type: 'alert',
                    });
            }
        );
    }
}

//// --------------------------------��ʼ��ҩƷ-����-δά��-----END-----------------------------////

function deleteFormatteri(value, rowData, rowIndex) {
    var combRowid = rowData.combRowid;
    var CombName = rowData.CombName;
    if (CombName){  
        return (
			'<span class="icon icon-cancel"  onclick="DeleteCombi(\'' +
			combRowid +
            '\',\'' +
            CombName +
			'\')">&ensp;</span>'
		);
    }
    else return value;
}

//��ʼ������-����ͨ����-��ά��
function InitLocWithPHCGGrid() {
    var columns = [
        [
            // LDLIRowid,arcCode,arcDesc
            { field: 'LDLIRowid', title: 'LDLIRowid', align: 'center', width: 80, hidden: true },
            {
                field: 'deleteBut',
                title: $g('ɾ��'),
                align: 'center',
                width: 60,
                formatter: deleteLocDrugFormatter,
            },
            { field: 'phcgCode', title: $g('����ͨ��������'), align: 'left', width: 150 },
            { field: 'phcgDesc', title: $g('����ͨ��������'), align: 'left', width: 265 },
            
        ],
    ];
    var dataGridOption = {
        fitColumns: true,
        fit: true,
        toolbar: '#LocInciPhcgBar',
        //rownumbers: true,
        pagination: true,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        width: 1500,
        nowrap: false,
        idField: 'LDLIRowid',
        columns: columns,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocDrugList.Query',
            QueryName: 'QueryLDLItm',
            inputStr: '',
        },
        onLoadSuccess: function (data) {},
    };
    PHA.Grid('LocWithPHCGGrid', dataGridOption);
}

//��ʼ������-����ͨ����-δά��
function InitLocWithOutPHCGGrid() {
    var columns = [
        [
            // LDLIRowid,arcCode,arcDesc
            { field: 'phcg', title: 'phcg', align: 'center', width: 80, hidden: true },
            {
                field: 'deleteBut',
                title: '���',
                align: 'center',
                width: 60,
                formatter: addLocPhcgFormatter,
            },
            { field: 'phcgCode', title: $g('����ͨ��������'), align: 'left', width: 150 },
            { field: 'phcgDesc', title: $g('����ͨ��������'), align: 'left', width: 285 },
            
        ],
    ];
    var dataGridOption = {
        //fitColumns: true,
        fit: true,
        toolbar: '#LocInciPhcgNoBar',
        //rownumbers: true,
        pagination: true,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        width: 1500,
        nowrap: false,
        idField: 'phcg',
        columns: columns,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocDrugList.Query',
            QueryName: 'QueryLDLItmWithOutPHCG',
            inputStr: '',
        },
        onLoadSuccess: function (data) {},
    };
    PHA.Grid('LocWithOutPHCGGrid', dataGridOption);
}

function addLocPhcgFormatter(value, rowData, rowIndex) {
    var arcimId = rowData.arcimId;
    var phcgId = rowData.phcg;
    if (!arcimId) arcimId = '';
    if (!phcgId) phcgId = '';
    return (
        '<span class="icon icon-add" style="cursor:pointer;width: 24px;height: 16px;display: inline-block;" onclick="AddLDLI(\'' +
        arcimId +
        '\',\'' +
        phcgId +
        '\')">&ensp;</span>'
    );
}

///-------------------------����-���ҽ��(��ά��)-------Start------------------------------------///
function InitLocWithDocGrid() {
    var columns = [
        [
            // LDDIRowId,pcpId,userCode,userName
            { field: 'LDDIRowId', title: 'LDDIRowId', align: 'center', width: 80, hidden: true },
            {
                field: 'DeleteBut',
                title: $g('ɾ��'),
                align: 'center',
                width: 80,
                formatter: DeleteLocDocFormatter,
            },
            { field: 'userCode', title: $g('ҽ������'), align: 'left', width: 140 },
            { field: 'userName', title: $g('ҽ������'), align: 'left', width: 150 },
            
        ],
    ];
    var dataGridOption = {
        fitColumns: true,
        fit: true,
        toolbar: '#TextLocDocBar',
        //rownumbers: true,
        pagination: true,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        width: 1500,
        nowrap: false,
        idField: 'LDDIRowId',
        columns: columns,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocDrugList.Query',
            QueryName: 'QueryDocInLoc',
            inputStr: '',
        },
        onLoadSuccess: function (data) {
	     
	        },
    };
    PHA.Grid('LocWithDocGrid', dataGridOption);
}

function DeleteLocDocFormatter(value, rowData, rowIndex) {
    var LDDIRowId = rowData.LDDIRowId;
    if (LDDIRowId){
        return (
			'<span class="icon icon-cancel"  onclick="DeleteLocDoc(\'' +
			LDDIRowId +
			'\')">&ensp;</span>'
		);
    }
    else return value;
}
function DeleteLocDoc(LDDIRowId) {
    $.cm(
        {
            ClassName: 'PHA.IN.LocDrugList.Save',
            MethodName: 'DeleteLocDoc',
            LDDIRowId: LDDIRowId,
        },
        function (retData) {
            if (!retData) {
                PHA.Popover({ showType: 'show', msg: $g('ɾ�����ҽ���ɹ�'), type: 'success' });
                QueryLocWithDocGrid();
                QueryLocWithOutDocGrid();
            } else
                PHA.Popover({
                    showType: 'show',
                    msg: $g('ɾ�����ҽ��ʧ�ܣ� ��������') + retData.desc,
                    type: 'alert',
                });
        }
    );
}

///-------------------------����-���ҽ��(��ά��)-------End------------------------------------///

///-------------------------����-���ҽ��(δά��)-------Start------------------------------------///
function InitLocWithOutDocGrid() {
    var columns = [
        [
            // LDDLRowId,pcpId,userCode,userName
            { field: 'pcpId', title: 'lddiId', align: 'center', width: 80, hidden: true },
            {
                field: 'AddBut',
                title: $g('���'),
                align: 'center',
                width: 80,
                formatter: addLocDocFormatter,
            },
            { field: 'userCode', title: $g('ҽ������'), align: 'left', width: 150 },
            { field: 'userName', title: $g('ҽ������'), align: 'left', width: 150 },
            
        ],
    ];
    var dataGridOption = {
        //fitColumns: true,
        fit: true,
        toolbar: '#TextLocDocNoBar',
        pagination: true,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        width: 1500,
        nowrap: false,
        idField: 'pcpId',
        columns: columns,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocDrugList.Query',
            QueryName: 'QueryDocInLoc',
            inputStr: '',
        },
        onLoadSuccess: function (data) {},
    };
    PHA.Grid('LocWithOutDocGrid', dataGridOption);
}

function addLocDocFormatter(value, rowData, rowIndex) {
    var pcpId = rowData.pcpId;
    return (
        '<span class="icon icon-add" style="cursor:pointer;width: 24px;height: 16px;display: inline-block;" onclick="AddLocDoc(\'' +
        pcpId +
        '\')">&ensp;</span>'
    );
}

function AddLocDoc(pcpId) {
    var gridSelect = $('#LocGird').datagrid('getSelected');
    var LDLRowId = '';
    if (gridSelect) LDLRowId = gridSelect.LDLRowId;

    var DocLoc = $('#cmbDocLoc').combobox('getValue');
    if (LDLRowId == '' && DocLoc == '') {
        PHA.Popover({ showType: 'show', msg: $g('��ѡ��һ������'), type: 'alert' });
        return;
    }

    $.cm(
        {
            ClassName: 'PHA.IN.LocDrugList.Save',
            MethodName: 'AddLocDoc',
            LDLRowId: LDLRowId,
            CTCP: pcpId,
            DocLoc: DocLoc,
        },
        function (retData) {
            if (!retData) {
                PHA.Popover({ showType: 'show', msg: $g('������ҽ���ɹ�'), type: 'success' });
                if (LDLRowId == '') {
                    $('#LocGird').datagrid('clear');
                    $('#LocGird').datagrid('clearSelections');
                    $('#LocGird').datagrid('query', {
                        inputStr:
                            $('#cmbHos').combobox('getValue') +
                            '^' +
                            $('#cmbDocLoc').combobox('getValue'),
                    });
                }
                QueryLocWithDocGrid();
                QueryLocWithOutDocGrid();
            } else
                PHA.Popover({
                    showType: 'show',
                    msg: $g('������ҽ��ʧ�ܣ� ��������:') + retData.desc,
                    type: 'alert',
                });
        }
    );
}

///-------------------------����-���ҽ��(δά��)-------End------------------------------------///

///-------------------------���ҽ�����б�-------Start------------------------------------///
function InitDocGird() {
    var columns = [
        [
            // LDDLRowId,pcpId,userCode,userName
            { field: 'pcpId', title: 'lddiId', align: 'center', width: 80, hidden: true },
            { field: 'userCode', title: $g('ҽ������'), align: 'left', width: 150 },
            { field: 'userName', title: $g('ҽ������'), align: 'left', width: 285 },
        ],
    ];
    var dataGridOption = {
        fitColumns: true,
        fit: true,
        toolbar: '#TextLocDocMainBar',
        pagination: true,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        width: 1500,
        nowrap: false,
        idField: 'pcpId',
        columns: columns,
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocDrugList.Query',
            QueryName: 'QueryDocInLoc',
            inputStr: '',
        },
        onLoadSuccess: function (data) {
	        var pageSize = $('#DocGird').datagrid('getPager').data('pagination').options.pageSize;
            var total = data.total;
            if (data.curPage > 0 && total > 0 ) {  //&& total <= pageSize
                $('#DocGird').datagrid('selectRow', 0);
            }
	        
	        },
        onSelect: function (rowIndex, rowData) {
            QueryDrugWithLocGird();
            QueryDrugWithOutLocGird();
        },
    };
    PHA.Grid('DocGird', dataGridOption);
}

///-------------------------���ҽ�����б�-------End------------------------------------///

/**
 * ��ʼ�����
 * @method InitDict
 */
function InitDict() {
    //ҽ����lookup
    var opts = $.extend({}, PHA_STORE.ArcItmMast('Y'), {
        width: lookUpWidth,
    });

    PHA.LookUp('LULocInciArcim', opts);
    PHA.LookUp('LULocInciArcimNo', opts);
    PHA.LookUp('LUArcimAndLoc', $.extend({}, PHA_STORE.ArcItmMast('Y'), {
        width: DurgToLocLeft,
    }));  

    var opts = $.extend({}, PHA_STORE.PHCGeneric('Y'), {
        width: lookUpWidth,
    });
    PHA.LookUp('LULocPhcg', opts);
    PHA.LookUp('LULocPhcgNo', opts);
    PHA.LookUp('LUPHCGMain', $.extend({}, PHA_STORE.PHCGeneric('Y'), {
        width: DurgToLocLeft,
    }));

    //ҽ������
    PHA.ComboBox('cmbDocLoc', {
        url: PHA_STORE.DocLoc().url,
        width: ComBoxWidthLoc,
    });
    //ҽ������
    PHA.ComboBox('cmbDrugDocLoc', {
        url: PHA_STORE.DocLoc().url,
        width: searchBoxWidth,
    });
    //ҽ������
    PHA.ComboBox('cmbDrugDocLocNo', {
        url: PHA_STORE.DocLoc().url,
        width: searchBoxWidth,
    });
}