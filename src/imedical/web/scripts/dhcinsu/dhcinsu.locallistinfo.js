/*
 * FileName:	dhcinsu.locallistinfo.js
 * User:		tangzf
 * Date:		2019-09-11
 * Function:	
 * Description: ������Ա����ά��
 */
 var GV = {
	UPDATEDATAID : '',	
}
 $(function () { 
	 
	init_dg(); 
	
	// �ѱ�
	init_AdmReason(); 
	
	// �������� ��������
	init_FYQB();
	
	// �س��¼�
	$('#search .textbox').keydown(function (e) {
		if (e.keyCode == 13) {
			initLoadGrid();
		}
	});
});
/*
 * datagrid
 */
function init_dg() {
	var dgColumns = [[
			{field:'TXXLX',title:'��Ϣ����',width:150 },
			{field:'TXM',title:'��������',width:150 },
			{field:'TYLZBH',title:'������',width:150},
			{field:'TYLZZT',title:'ҽ��֤״̬',width:220},
			{field:'TSBCARD',title:'�籣����',width:150},
			{field:'TTXM',title:'������',width:150},
			{field:'TSFZH',title:'���֤��',width:120,},
			{field:'TXB',title:'�Ա�',width:150 },
			{field:'TCSNY',title:'��������',width:150},
			{field:'TBZNY',title:'��֤����',width:150},
			{field:'TYYDH',title:'ѡ��ҽԺ����',width:150},
			{field:'TDWDM',title:'��λ����',width:150},
			{field:'TDWMC',title:'��λ����',width:150},
			{field:'TDWDZ',title:'��λ��ַ',width:150 },
			{field:'TDWDH',title:'��λ�绰',width:150},
			{field:'TDWYB',title:'��λ�ʱ�',width:150 },
			{field:'TJTZZ',title:'��ͥ��ַ',width:150 },
			{field:'TZZDH',title:'��ͥ�绰',width:150 },
			{field:'TZZYB',title:'��ͥ�ʱ�',width:150 },
			{field:'TiDate',title:'��������',width:150 },
			{field:'TStaDate',title:'��Ч����',width:150 },
			{field:'SubCate',title:'��������',width:150 },
			{field:'TYearStrDate',title:'��ȿ�ʼʱ��',width:150 },
			{field:'TMZQFD',title:'�����𸶶�',width:150 },
			{field:'TMZLJ',title:'�����Ը����ۼ�',width:150 },
			{field:'TZYQFX',title:'סԺ����',width:150 },
			{field:'TNDLJ',title:'����ۼ�',width:150 },
			{field:'TZYCS',title:'סԺ����',width:150 },	
			{field:'TTZLX',title:'ת��֪ͨ����',width:150 },
			{field:'TZCYYDM',title:'ת��ҽԺ����',width:150 },
			{field:'TZCKSMC',title:'ת�������������',width:150 },
			{field:'TZCBQMC',title:'ת����������',width:150 },	
			{field:'TZCCWBH',title:'ת����λ����',width:150 },
			{field:'TZRYYDH',title:'ת��ҽԺ����',width:150 },
			{field:'TZRKSMC',title:'����ת��ָ������',width:150 },
			{field:'TZRBQMC',title:'ת��ָ����������',width:150 },	
			{field:'TXXLXDesc',title:'��Ϣ����',width:150 },
			{field:'TAdmReaDesc',title:'�ѱ�',width:150 },	
			{field:'TFYIDDesc',title:'��������',width:150 },
			{field:'TFFXZIDDesc',title:'��������',width:150 },
			{field:'TRZIDDesc',title:'ְ�����',width:150 },	
			{field:'TJBIDDesc',title:'ְ������',width:150 },
			{field:'TDWXZDMDesc',title:'��λ����',width:150},
			{field:'TRowid',title:'TRowid',width:150,hidden:true},
			{field:'TAdmReasonDr',title:'TRowid',width:150,hidden:true}
		]];

	// ��ʼ��DataGrid
	$('#dg').datagrid({
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: false,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		columns: dgColumns,
		toolbar: '#tToolBar',
	});
}
/*
 * �ѱ�
 */
function init_AdmReason(){
	$('#AdmReason').combobox({
		valueField: 'RowID',
		textField: 'READesc',
		url: $URL,
		onBeforeLoad:function(param){
			param.ClassName = 'DHCBILLConfig.DHCBILLSysType';
			param.QueryName = 'FindAdmReason';
			param.ResultSetType = 'array';
			param.Code = '';
			param.Desc = '';
			param.HospId = PUBLIC_CONSTANT.SESSION.HOSPID; //+ DingSH 20200601
		},
		onSelect:function(data){
		}
	})
}
/*
 * �������� ,��������
 */
function init_FYQB(){
	var Options = new Object();
	Options.editable = true ;
	Options.defaultFlag = 'N';
	Options.hospDr = PUBLIC_CONSTANT.SESSION.HOSPID; //+ DingSH 20200601 
	INSULoadDicData('FYQB','FYQB',Options); //�������� 
	INSULoadDicData('FYLB','FYLB',Options); //��������
}
/*
 * ��������
 */
function initLoadGrid(){
    var queryParams = {
	    ClassName : 'web.DHCINSULOCInfo',
	    QueryName : 'QueryLocInfo',
	    AdmReason : getValueById('AdmReason') || '',
	    YLZBH : getValueById('INSUNo'),
	    Name : getValueById('Name'),
	    SFZH : getValueById('IDCard'),
	    FYID : getValueById('FYQB') || '',
	    FFXZID : getValueById('FYLB') || '',
	    DWDM : getValueById('PADepCode'),
	    HospDr:PUBLIC_CONSTANT.SESSION.HOSPID //+ DingSH 20200601
	}	
    loadDataGridStore('dg',queryParams);
	
}
/*
 * ����
 */
$('#BtnClear').bind('click', function () {
	setValueById('Name','');
	setValueById('AdmReason','');
	setValueById('INSUNo','');
	setValueById('IDCard','');
	setValueById('FYQB','');
	setValueById('FYLB','');
	setValueById('PADepCode','');
	initLoadGrid();
})
/*
 * ����
 */
$('#BtnAdd').bind('click', function () {
	openEditWindow('insert');
});
/*
 * �޸�
 */
$('#BtnUpdate').bind('click', function () {
	var selectRow = $('#dg').datagrid('getSelected');
	if(!selectRow){
		$.messager.alert('��ʾ','��ѡ��Ҫ�޸ĵļ�¼','info');
		return;	
	}
	openEditWindow('update');
});
/*
 * ����
 */
$('#BtnImport').bind('click', function () {
	var filePath = FileOpenWindow(importFun)
    
});
function importFun(filePath){
	if(filePath=="")
    {
	    $.messager.alert('��ʾ', '��ѡ���ļ�����', 'error');
	    return ;
    }
    
    var ErrMsg="";     //��������
    var errRowNums=0;  //��������
    var sucRowNums=0;  //����ɹ�������
    
	xlApp = new ActiveXObject("Excel.Application"); 
	xlBook = xlApp.Workbooks.open(filePath); 
	xlBook.worksheets(1).select(); 
    var xlsheet = xlBook.ActiveSheet;
    
    var rows=xlsheet.usedrange.rows.count;
    var columns=xlsheet.usedRange.columns.count;
    var i,j,k;
	try{

		for(i=2;i<=rows;i++){
			var pym="";
			
			var TmpList=new Array();
	        TmpList[0]="";
	        var InString="";
			for (j=1;j<=columns;j++){
				TmpList[j]=xlsheet.Cells(i,j).text;
			}
			var Type=TmpList[33]
			var VerStr=tkMakeServerCall("web.DHCINSULOCInfo","GetLocInfoBySSID",TmpList[2],Type);
			var VerArr=VerStr.split("^")
			if (parseInt(VerArr[0])<=0){
				TmpList[0]=""
				for(;j<32;j++){TmpList[j]=""}
				TmpList[j]=Type;
			}
			else{  
				if(TmpList[1]="1"){TmpList[0]=""}
				TmpList[0]=VerArr[0];
				}
			for(k=1;k<TmpList.length;k++){
				InString=InString+"^"+TmpList[k];
				}
				
			for(;k<VerArr.length;k++){
				InString=InString+"^"+VerArr[k];
				}
			
				InString=TmpList[0]+InString;
		
 	        var savecode=tkMakeServerCall("web.DHCINSULOCInfo","Save",InString);
			if(savecode==null || savecode==undefined) savecode=-1;
			if(eval(savecode)>=0){
				sucRowNums=sucRowNums+1;
		
			}else{
				errRowNums=errRowNums+1; 
				if(ErrMsg==""){
					ErrMsg=i;
				}else{
					ErrMsg=ErrMsg+"\t"+i;
				}
			}
		}
		
		if(ErrMsg==""){
			$.messager.alert('��ʾ', '������ȷ�������', 'info');
		}else{
			var tmpErrMsg="�ɹ����롾"+sucRowNums+"/"+(rows-1)+"��������";
			tmpErrMsg=tmpErrMsg+"ʧ�������к����£�\n\n"+ErrMsg;
			$.messager.alert('��ʾ', tmpErrMsg, 'error');   
		}
	}
	catch(e){
		$.messager.alert('��ʾ', "����ʱ�����쳣��ErrInfo��" + e.message, 'error');
	}
	finally{
		xlBook.Close (savechanges=false);
		xlApp.Quit();
		xlApp=null;
		xlsheet=null;
	}	
}
/*
 * ����
 */
$('#BtnSavePro').bind('click', function () {
	try{
		var tmpObj = new Object();
		var saveTable=$('#addInfo').find('input');
		checkData(); //�Ƿ���Ч����
		$.each(saveTable, function (index, rowData) {
			INSUcheckText(rowData.value, $('#Label' + rowData.id).text(), "^ < > '"); //�����ַ�
			rowData.id != '' ? tmpObj[rowData.id] = getValueById(rowData.id) : '';
		});		
		var xmlStr=json2xml(tmpObj,"")
		var rtn=tkMakeServerCall("web.DHCINSULOCInfo", "SaveLocalInfo", xmlStr, GV.UPDATEDATAID);
		if(rtn != "0"){
			$.messager.alert('��ʾ', "����ʧ��" + rtn, 'error');
		}else{
			$.messager.alert('��ʾ', "����ɹ�", 'info',function(){
				$HUI.dialog("#LocalListInfoProWin",'close');
				initLoadGrid();
			});	
		}
	}catch(e){
	}
});
/*
 * ɾ��
 */
$('#BtnDelete').bind('click', function () {
	var selected = $('#dg').datagrid('getSelected');
	if (selected) {
		if (selected.TRowid != "") {
			$.messager.confirm('ȷ��', '��ȷ����Ҫɾ����¼��', function (r) {
				if (r) {
					$.m({
						ClassName: "web.DHCINSULOCInfo",
						MethodName: "Delete",
						LocRowid: selected.TRowid ,
					}, function (rtn) {
						if (rtn == "0") {
							$.messager.alert('��ʾ', "ɾ���ɹ�", 'success',function(){
								initLoadGrid();
							});
						} else {
							$.messager.alert('����', "ɾ��ʧ�ܣ�������룺" + rtn, 'error');
						}
					});
				}
			});
		}
	} else {
		$.messager.alert('��ʾ', "��ѡ��Ҫɾ���ļ�¼", 'info');
	}
});
/*
 * ��ѯ
 */
$('#BtnFind').bind('click', function () {
	FindClick();
});
/*
 * ��ѯ
 */
function FindClick() {
	initLoadGrid();
}
/* ����/�޸ĵ���
 * input : type = 'insert' ���� ; type = 'update' �޸�
 */
function openEditWindow(type){
	$('#LocalListInfoProWin').show(); 
	var title = type=='insert' ? '����':'�޸�'
	$HUI.dialog("#LocalListInfoProWin",{
			title:title,
			height:647,
			width:871,
			collapsible:false,
			modal:true,
		    iconCls: 'icon-w-edit'
	})
	$("#addInfo").form("clear");
	init_LocalListProWin();	
	if(type == 'update'){
		var selectRow = $('#dg').datagrid('getSelected');
		GV.UPDATEDATAID = selectRow.TRowid;
		setTimeout(function () {
			setDefaultVal();
		}, 200);
		
		
	}else{
		GV.UPDATEDATAID	= '';
	}
	
}
/* 
 * �޸�  ���� setVal
 */
function setDefaultVal(){
	var selectRow = $('#dg').datagrid('getSelected');
	$.each(selectRow, function (field, Data) {
		field = field.substr(1,field.length);
		field = 'INLOC' + field;
		if($('#' + field).attr('class') && $('#' + field).attr('class').indexOf('datebox-f')>0 && Data =='ERROR!'){
			Data = '';	
		}
		setValueById(field,Data);

	});	
}
$('#BtnClose').bind('click', function () {
	$HUI.dialog("#LocalListInfoProWin",'close');
});
/* 
 * ��ʼ�� �����е������� 
 */
function init_LocalListProWin(){
	// �÷������ݿɸ��� ����ҽ���ֵ�����  ƴ�� ҽ������ 
	// ��:�������ʣ�INSULoadDicData('INLOCFYID', 'FYQBZZB', '', '');
	
	// �Ա�
	$('#INLOCXB').combobox({
		valueField: 'id',
		textField: 'desc',
		editable:false,
		data:[
			{
				"id":"��",
				"desc":"��",
				selected:true
			},
			{
				"id":"Ů",
				"desc":"Ů"	
			},
			{
				"id":"δ֪",
				"desc":"δ֪"	
			}
		
		]
	})
	var paraOptions= new Object();
	paraOptions.valueField='cCode'
	paraOptions.hospDr = PUBLIC_CONSTANT.SESSION.HOSPID; //+ DingSH 20200601 
	// ��������
	INSULoadDicData('INLOCFYID', 'FYQB', paraOptions);
	// ��������
	INSULoadDicData('INLOCFFXZID', 'FYLB',paraOptions);
	// ְ�����	
	INSULoadDicData('INLOCRZID', 'RZID',paraOptions);
	// ְ������
	INSULoadDicData('INLOCJBID', 'JBID',paraOptions);
	// ��λ����
	INSULoadDicData('INLOCDWXZDM', 'DWXZDM',paraOptions);	
	// ת��֪ͨ����
	$('#INLOCTZLX').combobox({
		valueField: 'id',
		textField: 'desc',
		editable:false,
		data:[
			{
				'id':'TZLX1',
				'desc':'����֪ͨ',
			},
			{
				'id':'TZLX0',
				'desc':'����֪ͨ',
				selected:true
			}		
		]
	})
	// ά�����  �ѱ�
	$('#INLOCAdmReasonDr').combobox({
		valueField: 'RowID',
		textField: 'READesc',
		url: $URL,
		editable:false,
		onBeforeLoad:function(param){
			param.ClassName = 'DHCBILLConfig.DHCBILLSysType';
			param.QueryName = 'FindAdmReason';
			param.ResultSetType = 'array';
			param.Code = '';
			param.Desc = '';
			param.HospId = PUBLIC_CONSTANT.SESSION.HOSPID; //+ DingSH 20200601
		},
		onLoadSuccess:function(data){
			if(data.length > 0){
				$('#INLOCAdmReasonDr').combobox('select',data[0].RowID)	;
			}	
		}
	})
}
/**
* ����У��
*/
function checkData() {
	var inValiddatebox = $('.validatebox-invalid');
	if(inValiddatebox.length > 0){ //validdatebox
		$.each(inValiddatebox, function (index, rowData) {
			var labelDesc = $('#Label' + rowData.id).text() || 'ֵ: ' + rowData.value;
			$.messager.alert('��ʾ', '[' + labelDesc +']' + '��֤��ͨ��' , 'error');
			throw rowData.id;
		});		
	}
}
$.extend($.fn.validatebox.defaults.rules, {
    idcard : {// ��֤���֤
        validator : function(value) {
            return /^\d{15}(\d{2}[A-Za-z0-9])?$/i.test(value);
        },
        message : '��������ȷ�����֤'
    },
    integer : {// ��֤����
        validator : function(value) {
            return /^[+]?[1-9]+\d*$/i.test(value);
        },
        message : '����������'
    },
    zip : {// ��֤��������
        validator : function(value) {
            return /^[0-9]\d{5}$/i.test(value);
        },
        message : '���������ʽ����ȷ'
    },
    Date :{
	    validator: function (value) {
		    var r = value.match(/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2}) (\d{1,2}):(\d{1,2}):(\d{1,2})$/);
		    if (r == null) return false;
		    var d = new Date(r[1], r[3] - 1, r[4], r[5], r[6], r[7]);
		    return (d.getFullYear() == r[1] && (d.getMonth() + 1) == r[3] && d.getDate() == r[4] && d.getHours() == r[5] && d.getMinutes() == r[6] && d.getSeconds() == r[7]);

		    },
		    message: 'ʱ���ʽ����ȷ�����������롣'
    }
});
function selectHospCombHandle(){
	setValueById('Name','');
	setValueById('AdmReason','');
	setValueById('INSUNo','');
	setValueById('IDCard','');
	setValueById('FYQB','');
	setValueById('FYLB','');
	setValueById('PADepCode','');
	$('#AdmReason').combobox('clear');
	$('#AdmReason').combobox('reload');
	//$('#AdmReason').combobox('clear');
	//$('#AdmReason').combobox('reload');
	initLoadGrid();
}
    
