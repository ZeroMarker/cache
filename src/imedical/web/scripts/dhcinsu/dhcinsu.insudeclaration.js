/*
 * FileName:	dhcinsu.insudeclaration.js
 * User:		tangzf
 * Date:		2020-02-27
 * Description: ҽ���걨
 */
 var GV = {
	UPDATEDATAID : '',
	HospDr:session['LOGON.HOSPID'] 
}
 $(function () { 
	setValueById('StartDate',getDefStDate(0));
	setValueById('EndDate',getDefStDate(1));	
	// �������
	init_ReportType();
	// ҽ������
	init_INSUType();	
	// �س��¼�
	$('#search .textbox').keydown(function (e) {
		if (e.keyCode == 13) {
			initLoadGrid();
		}
	});
	init_dg(); 
});
/*
 * ҽ������
 */
function init_INSUType(){
	var Options = {
		defaultFlag:'N'	,
		hospDr:GV.HospDr
	}
	INSULoadDicData('INSUType','DLLType',Options); 	
	$('#INSUType').combobox({
		onSelect:function(){
			init_ReportType();
		}	
	})
}
/*
 * �������
 */
function init_ReportType(){
	var Options = {
		defaultFlag:'N',
		editable:'Y',
		hospDr:GV.HospDr	
	}
	INSULoadDicData('Rptlb','AKA130' + getValueById('INSUType'),Options); 	
}
/*
 * datagrid
 */
function init_dg() {
	var dgColumns = [[
			{field:'TabPatNo',title:'���˱��',width:150 },
			{field:'TabPatName',title:'��������',width:150 },
			{field:'TabRptDate',title:'�걨����',width:150},
			{field:'TabSDate',title:'��Ч��ʼ����',width:150},
			{field:'TabEDate',title:'��Ч��������',width:150},
			{field:'TabFlag',title:'������־',width:150,styler:function(val, index, rowData){
				switch (val){
					case "����δͨ��":
						return "background:red"
						break;
					case "����ͨ��":
						return "background:green"
						break
					case "δ����":
						return "background:yellow"
						break
						
				}
			
			}},	
			{field:'TabRptTypeDesc',title:'�걨����	',width:150},
			{field:'TabAdmSeriNo',title:'סԺ��ˮ��',width:220},
			{field:'TabAdmType',title:'��������',width:120,},
			{field:'TabDiagCode',title:'��������',width:150 },
			{field:'TabDiagDesc',title:'��������',width:150},
			{field:'TabRPTNo',title:'�������',width:150},
			{field:'Tabxmbm',title:'��Ŀ����',width:150},
			{field:'Tabxmmc',title:'��Ŀ����',width:150 },
			{field:'TabHisCode',title:'ҽԺ��Ŀ����',width:150},
			{field:'TabHisDesc',title:'ҽԺ��Ŀ����',width:150 },
			{field:'Tabxmlb',title:'��Ŀ���',width:150 },
			{field:'TabOutHosName',title:'ת��ҽԺ',width:150 },
			{field:'Tabmoney',title:'���',width:150,align:'right' },
			{field:'Tabsl',title:'����',width:150 },
			{field:'TabUserName',title:'������',width:150 },
			{field:'TabDoctor',title:'����ҽ��',width:150 },
			{field:'TabNumberID',title:'�������κ�',width:150 },
			{field:'TabStates',title:'�α���',width:150 },
			{field:'TabHosYJ',title:'ҽԺ���',width:150 },
			{field:'TabJSYJ',title:'�������',width:150 },
			{field:'TabMD',title:'	Ŀ��',width:150 },
			{field:'TabZZ',title:'֢״',width:150 },	
			{field:'TabBZ',title:'��ע',width:150 },
			{field:'TabRptType',hidden:true },	
			{field:'rowid',hidden:true}
		]];

	// ��ʼ��DataGrid
	$('#dg').datagrid({
		data:[],
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
		onDblClickRow:function(index,rowData){
			//FindReportInfo();	
		}
	});
}
/*
 * ��������
 */
function initLoadGrid(){
	if(getValueById('INSUType')==''){
		$.messager.alert('��ʾ','ҽ�����Ͳ���Ϊ��','info');
		return;	
	}
    var queryParams = {
	    ClassName : 'web.INSUReport',
	    QueryName : 'QueryAll',
	    Rptlb : getValueById('Rptlb'),
	    StartDate : getValueById('StartDate'),
	    EndDate : getValueById('EndDate'),
	    HospId: GV.HospDr,
	    ParamINSUType: getValueById('INSUType')
	    
	}	
    loadDataGridStore('dg',queryParams);
	
}
/*
 * ��ѯҽ�������Ϣ
 */
$('#btnFindReport').bind('click', function () {
	FindReportInfo();
})
/*
 * ����
 */
$('#btnAdd').bind('click', function () {
	var INSUType = getValueById('INSUType');
	if(INSUType == ''){
		$.messager.alert('��ʾ','����ѡ��ҽ������','info');
		return;	
	}
	openEditWindow();
});

/*
 * readcard
 */
$('#btnReadCard').bind('click', function () {
	var CardType="1",InsuNo="";
	var ExpString = getValueById('INSUType') + '^' + GV.HospDr;
	var UserId = session['LOGON.USERID'];
	var str = InsuReadCard('0',UserId,InsuNo,1,ExpString);
	var TmpData = str.split("|");
	if (TmpData[0]!="0"){
		$.messager.alert('��ʾ', "����ʧ��" + str, 'error');	
		return;
	}else{
	 	var TmpData1 = TmpData[1].split("^")
	 	var TmpData2 = TmpData[2].split("^")
	 	setValueById('PatNo',TmpData1[0]); //���˱��
	 	setValueById('INSUCardNo',TmpData1[1]);  //����
	 	setValueById('name',TmpData1[3]); //����
	 	setValueById('Sex',TmpData1[4]); //�Ա�
	 	setValueById('States',TmpData2[8]); //�α���������
	 	setValueById('rylb',TmpData1[11]);  //��Ա���	 	
	 }
    
});
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
/*
 * ����
 */
$('#btnReport').bind('click', function () {
	try{
		
		checkData();
		var PatNo = getValueById('PatNo');
		var RptType = getValueById('RptType');
		var AdmSeriNo = '';
		var OutHosName = '';
		var HosLevel = '';
		var DiagCode = getValueById('DiagCode');
		var DiagDesc = $('#DiagCode').combobox('getText');
		var HosYJ = getValueById('HosYJ');
		var xmbm = getValueById('xmbm');
		var xmmc = $('#xmbm').combobox('getText');	
		var sl = getValueById('sl');
		var RptDate = getValueById('RptDate');	
		var SDate = getValueById('SDate');	
		var EDate = getValueById('EDate');	
		var Guser = session['LOGON.USERID'];
		var OutHosName = '';
		var GuserName = session['LOGON.USERNAME'];
		var OutType = '';
		var Demo = '';
		var money = getValueById('money');
		var xmlb = '';
		var RPTNo = '';
		var ZYZZ = getValueById('ZYZZ');
		var MD = getValueById('MD');
		var Doctor = getValueById('Doctor');
		var KZR = getValueById('KZR');
		var JSYJ = getValueById('JSYJ');
		var KZRYJ = getValueById('KZRYJ');
		var LRuser = '';
		var LRDate = '';
		var RPTUser = '';
		var HisCode = '';
		var HisDesc = '';
		var AdmType = '';
		var NumberID = '';
		var States =  $('#States').combobox('getText'); 
		var HospId = GV.HospDr;
                    //0                       											5															11									14
		var str = PatNo + "|"+RptType+"|"+AdmSeriNo+"|"+OutHosName+"|"+HosLevel+"|"+DiagCode+"|"+DiagDesc+"|"+HosYJ+"|"+xmbm+"|"+xmmc+"|"+sl+"|"+RptDate+"|"+SDate+"|"+EDate+"|"+GuserName+"|";
		//				15												20																			28			
		str = str + OutType+"|"+Demo+"|"+money+"|"+xmlb+"|"+RPTNo+"|"+ZYZZ+"|"+MD+"|"+Doctor+"|"+KZR+"|"+JSYJ+"|"+KZRYJ+"|"+LRuser+"|"+LRDate+"|"+RPTUser+"|";
								// 30								      33
		str = str + HisCode+"|"+HisDesc+"|"+AdmType+"|"+NumberID + "|" + States;
		ExpString = getValueById('INSUType') + '^^' +getValueById('name'); // insutype^ExpStrForNet^Name
		var rtn=InsuReport(0,str,Guser,ExpString);
		if (rtn == 0){
			$.messager.alert('��ʾ', "�����ϱ��ɹ�!��" + rtn, 'info',function(){
				$HUI.dialog("#LocalListInfoProWin",'close');
				initLoadGrid();	
			});	
		} else{
			$.messager.alert('����', "�����ϱ�ʧ��!��" + rtn, 'error');
		}
	}catch(e){
	}
});
/*
 * ɾ��
 */
$('#btnDel').bind('click', function () {
	var selected = $('#dg').datagrid('getSelected');
	if (selected) {
		if (selected.rowid != "") {
			$.messager.confirm('ȷ��', 'ȷ�ϳ����ϱ���¼��', function (r) {
				if (r) {
					var str=selected.TabRptType + "|"  + selected.TabPatNo + "|" + selected.TabAdmSeriNo + "|" + selected.TabDiagCode + "|" + selected.TabDiagDesc + "|" + selected.TabSDate
					ExpString = selected.rowid + "|";
					var rtn=tkMakeServerCall("web.INSUReport", "DeleteReport", selected.rowid); //DHCINSUBLL.InsuReportDestroy(1,str,Guser,ExpString);	
				    if (rtn!="0"){
					    $.messager.alert('����', "�����ϱ�����ʧ��!" + rtn, 'info');
					}else {
						$.messager.alert('����', "�����ϱ������ɹ�!" + rtn, 'info',function(){
							initLoadGrid();	
						});
				    }
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
$('#btnFind').bind('click', function () {
	initLoadGrid();
});
/* ����/�޸ĵ���
 */
function openEditWindow(){
	$('#LocalListInfoProWin').show(); 
	$HUI.dialog("#LocalListInfoProWin",{
			title:"�걨��Ϣ",
			height:527,
			width:570,
			collapsible:false,
			modal:true,
		    iconCls: 'icon-w-edit'
	})
	$("#addInfo").form("clear");
	
	init_AddInfoPanel();	
	
}
/* 
 * ��ѯҽ�������Ϣ
 */
function FindReportInfo(){
	var selected = $('#dg').datagrid('getSelected');
	if (selected) {
		if(selected.TabFlag =='�ѳ���'){
			$.messager.alert('��ʾ', "����Ѿ�����", 'info');
			return;
		}
		$.messager.alert('��ʾ', "��Ҫ����ҽ������", 'info');	
	} else {
		$.messager.alert('��ʾ', "��ѡ��Ҫ��ѯ�ļ�¼", 'info');
	}
}
/* 
 * ��������
 */
function init_AddInfoPanel(){
	setValueById('SDate',getDefStDate(0));
	setValueById('EDate',getDefStDate(1));
	setValueById('RptDate',getDefStDate(0));
	Options = {
		hospDr: GV.HospDr	
	}
	// �������
	INSULoadDicData('RptType','AKA130' + getValueById('INSUType'),Options); 	
	// ��Ա���
	INSULoadDicData('rylb','AKC021' + getValueById('INSUType'),Options); 
	// states
	INSULoadDicData('States','YAB003' + getValueById('INSUType'),Options); 
	// ���������
	setValueById('money','0');
	setValueById('sl','1');
	
	// HIS��Ŀ����
	$HUI.combobox(('#xmbm'),{
		defaultFilter:'4',
		valueField: 'HisCode',
		textField: 'HisDesc',
		url:$URL,
		mode:'remote',
		onBeforeLoad:function(param){
			if(param.q==''){
				return true;	
			}
			param.ClassName = 'web.INSUTarContrastCom';
			param.QueryName= 'DhcTarQuery';
			param.sKeyWord = param.q;
			param.Class = '1';
			param.Type = getValueById('INSUType');
			param.ConType = 'A';
			param.ExpStr = 'N||' + GV.HospDr;
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){

		}		
	})
	Options = {
		defaultFlag:'N',
		hospDr: GV.HospDr	
	}
	// ���Բ����
	INSULoadDicData('DiagCodeMXB','Skc516' + getValueById('INSUType'),Options); 
	
	// HIS���
	$HUI.combobox(('#DiagCode'),{
		defaultFilter:'3',
		valueField: 'code',
		textField: 'desc',
		url:$URL,
		mode:'remote',
		onBeforeLoad:function(param){
			if(param.q==''){
				return true;	
			}
			param.ClassName = 'web.DHCMRDiagnos';
			param.QueryName= 'LookUpWithAlias';
			param.desc = param.q;
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){

		}		
	})
	
	// ���
	$('.advise').combobox({
		valueField: 'id',
		textField: 'text',
		editable: false,
		data:[{
    			"id" : '01',
    			"text":"ͬ��",
    			selected:true
    		},{
    			"id" : '02',
    			"text":"��ͬ��"	
    		}],		
	})
	// sex
	$('#Sex').combobox({
		valueField: 'id',
		textField: 'text',
		editable: false,
		data:[{
    			"id" : '��',
    			"text":"��",
    			selected:true
    		},{
    			"id" : 'Ů',
    			"text":"Ů"	
    		},{
    			"id" : 'δ֪',
    			"text":"δ֪"	
    		}],		
	})
}

