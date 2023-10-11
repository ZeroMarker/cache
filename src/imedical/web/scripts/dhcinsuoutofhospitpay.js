/**
 * Ժ�ⱨ���渶¼��
 * FileName: dhcinsuoutofhospitpay.js
 * tangzf 2019-12-06
 * �汾��V1.0
 * hisui�汾:0.1.0
 */
 var HospDr=session['LOGON.HOSPID'];
$(function(){
	init_SearchPanel();
	init_OutHospitalPayDG();
	
});
/*
 * ��ʼ����ѯ���
 */
function init_SearchPanel(){
	//Ĭ������
	setValueById('StartDate',getDefStDate(-31));
	//setValueById('EndDate',getDefStDate(31));
	setValueById('EndDate',getDefStDate(0));  //��������ʹ�õ������� modify by kj 20200304
	
	// ҽ������
	init_INSUType();
	
	// ��������
	init_AdmType();
	
	//ҽ�����
	init_MedType();
	
	// �Ա�
	init_Sex();
	
	// ����סԺ��ˮ��
	buildADMSeri();
	
	// ����״̬
	init_INPAYFlag();
	
	// ��ʼ�����
	$('.hisui-numberbox').numberbox({
		value:0,
		min:0,
		precision:2	
	})
	$("#INPAYjjzfe0").keyup(function(e){ 
		if(e.keyCode===13){
			calAmt(this.value);		
		}
	})
	$('#INPAYjjzfe0').bind('change',function(){
  		calAmt(this.value);
	})
	
	$("#INPAYbcbxf0").keyup(function(e){ 
		if(e.keyCode===13){
			calAmt(getValueById("INPAYjjzfe0"));		
		}
	})
	$('#INPAYbcbxf0').bind('change',function(){
  		calAmt(getValueById("INPAYjjzfe0"));
	})
	
	// ���֤
	$('#INPAYid0000').bind('change',function(){
		if(this.value.length !='15' && this.value.length !='18'){
  			$.messager.alert('��ʾ', "���֤�Ų��Ϸ�", 'error');
			setValueById('INPAYid0000', '');
		}
	})
	
	// ����Dg
	//loadDatagridData();
}
/*
 * ����סԺ��ˮ��
 */
function buildADMSeri(){
	var NowDate=new Date();
	var NowDate=nowTimeObjToFormatTime(NowDate);
	var objAdmType=getValueById('INPAYZstr12');
	if (objAdmType !=""){
		zylsh0=objAdmType+NowDate+PUBLIC_CONSTANT.SESSION.USERID;
		setValueById('INPAYzylsh0',zylsh0);
	}else{
		setValueById('INPAYzylsh0','');
	}
}
/*
 * ��������Ը�
 */
function calAmt(insuAmt){
	//var totalAmt = getValueById('INPAYbcbxf0');
	var totalAmt = $("#INPAYbcbxf0").val();
	if (totalAmt <=0){
		$.messager.alert('��ʾ', "�����ܽ���ȷ", 'error');
		setValueById('INPAYgrzfe0', '0.00');
		return;	
	}
		
	var selfAmt = totalAmt - insuAmt;
	if(selfAmt < 0){
		$.messager.alert('��ʾ', "�������ȷ", 'error');
		setValueById('INPAYgrzfe0', '0.00');
		return;	
	}
	setValueById('INPAYgrzfe0', formatAmt(selfAmt));
}
/*
 * ����У��
 */
function checkAmtData(){
	//var totalAmt = getValueById('INPAYbcbxf0');
	var totalAmt = $("#INPAYbcbxf0").val();
	if (totalAmt <=0){
		$.messager.alert('��ʾ', "�����ܽ���ȷ", 'error');
		setValueById('#INPAYbcbxf0', '0.00');
		return;	
	}
	var insuAmt = $("#INPAYjjzfe0").val();
	var selfAmt = totalAmt - insuAmt;
	if(selfAmt < 0){
		$.messager.alert('��ʾ', "�������ȷ", 'error');
		setValueById('INPAYgrzfe0', '0.00');
		return false;	
	}
	setValueById('INPAYgrzfe0', formatAmt(selfAmt));
	return true;
}
/*
 * Ժ��渶grid
 */
function init_OutHospitalPayDG(){
	var dgColumns = [[
			{field:'TFlag',title:'����״̬',width:150},
			{field:'Txming0',title:'����',width:150},
			{field:'Tbcbxf0',title:'�ܷ���',width:100,align:'right' },
			{field:'Tjjzfe0',title:'�渶����',width:100,align:'right'},
			{field:'Tgrzfe0',title:'�����Ը�',width:100,align:'right'},
			{field:'Tdjlsh0',title:'���ݺ�',width:150},
			{field:'TiDate',title:'¼��ʱ��',width:150},
			{field:'Tid0000',title:'���֤��',width:120},
			{field:'TsUserDr',title:'¼����',width:150},
			{field:'Tsftsbz',title:'ҽ�����',width:150 },
			{field:'Tbie00',title:'�Ա�',width:150 },
			{field:'Tzylsh0',title:'��ˮ��',width:150 },
			{field:'TZstr04',title:'ҽ������',width:150},
			{field:'TZstr10',title:'�������',width:220},
			{field:'TZstr12',title:'��������',width:150},
			{field:'TZstr13',title:'����',width:120},
			{field:'TZstr16',title:'ת��ҽԺ',width:150},
			{field:'TZstr24',title:'��ע',width:100},
			{field:'TRowID',title:'TRowID',hidden:true},
			{field:'Flag',title:'Flag',hidden:true}, // ״̬
			{field:'Sex',title:'Sex',hidden:true}, // �Ա�
			{field:'AdmType',title:'AdmType',hidden:true}, // �������
			{field:'States',title:'States',hidden:true}, // ͳ����
			{field:'PatType',title:'PatType',hidden:true},// ��Ա���
			{field:'MedType',title:'MedType',hidden:true}, // ҽ�����
			{field:'InsuType',title:'InsuType',hidden:true},// ҽ������
		]];
	$('#dg').datagrid({
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		data:[],
		pageSize:'20',
		columns: dgColumns,
		toolbar:'#toolBar',
		onLoadSuccess: function (data) {
		},
		onSelect:function(index,row){
			selectRowHandle(index,row);
		}
	});
}
/*
 * ��ѯ
 */
function Query(){
	loadDatagridData();
}
/*
 * ����
 */
function Add(){
	try{
		var flag=checkAmtData();
		if(!flag){return;}
		var tmpObj = new Object();
		var saveTable=$('#addInfo').find('input');
		$.each(saveTable, function (index, rowData) {
			if(rowData.id !='StartDate' && rowData.id !='EndDate'){
				checkData(index, rowData);
				rowData.id != '' ? tmpObj[rowData.id] = getValueById(rowData.id) : '';
			}
		});	
		tmpObj['INPAYFlag'] = 'I'; 
		tmpObj['INPAYsUserDr'] = PUBLIC_CONSTANT.SESSION.USERID;
		tmpObj['INPAYHospDr'] = PUBLIC_CONSTANT.SESSION.HOSPID;	
		var xmlStr=json2xml(tmpObj,"")
		var rtn=tkMakeServerCall("web.INSUOutOfHospitalCtl", "SaveDivInfo", xmlStr);
		if(rtn != "0"){
			$.messager.alert('��ʾ', "����ʧ��" + rtn, 'error');
		}else{
			$.messager.alert('��ʾ', "����ɹ�", 'info',function(){
				Query();
			});	
		}
	}catch(e){}
}
/*
 * ����
 */
function Abort(){
	var selected = $('#dg').datagrid('getSelected');
	if(!selected){
		$.messager.alert('��ʾ','��ѡ��Ҫ���ϵļ�¼','info');	
		return;
	}
	if(selected.TFlag != '��������'){
		$.messager.alert('��ʾ','�����������ѳ����ķ��ã�������ѡ��','info');	
		return;
	}
	var User = PUBLIC_CONSTANT.SESSION.USERID ;
	var djlsh = selected.Tdjlsh0;
	var rowid = selected.TRowID;
	var divideFlag = selected.Flag;
	var Instring = User + '^' + djlsh + '^' + rowid + '^' + 'S'; //�û�ID^���ݺ�^Divide���Rowid(���ϱش�)^����״̬(����:I,������:B,����:S)
	
	$.messager.confirm("ȷ��", "�Ƿ����ϸ�����?", function (r) {
		if (r) {
			$.m({
				ClassName: "web.INSUOutOfHospitalCtl",
				MethodName: "StrikeDivideInfo",
				InStr: Instring,
			}, function(rtn){
				if(rtn > 0){
					$.messager.alert('��ʾ', "���ϳɹ���", 'info');	
				}else if(rtn = -5){
					$.messager.alert('����ʧ��', "ϵͳ�б����ҽ��ϵͳ�������ҳ����ʾ�Ľ���Ų�ͬ��", 'error');	
				}else{
					$.messager.alert('����ʧ��:', rtn, 'error');
				}
				//Clear();
				Query();
			});
		}
	});
}
/*
 * ����
 */
function Clear(){
	$(".search-table").form("clear");
	setValueById('StartDate',getDefStDate(-31));
	setValueById('EndDate',getDefStDate(0));  //��������ʹ�õ������� modify by kj 20200304
	// ��������
	setValueById('INPAYZstr12','OP');
	// ҽ������
	var data = $('#INPAYZstr04').combobox('getData');
	/*if(data.length > 0){
		$('#INPAYZstr04').combobox('select',data[0].cCode);	
	}*/
	// ����״̬
	setValueById('INPAYFlag','I');;
	// amt
	$('.hisui-numberbox').val('0.00');
	// sex
	setValueById('INPAYxbie00','1');
	buildADMSeri();
	loadDatagridData();
}
/*
 * ����dg����
 */
function loadDatagridData(){
	var queryParams={
		ClassName:'web.INSUOutOfHospitalCtl',
		QueryName:'QryOutOfHospital',
		StartDate:getValueById('StartDate'),
		EndDate:getValueById('EndDate'),
		Zstr12:getValueById('INPAYZstr12'),  // ���� סԺ
		djlsh0:getValueById('INPAYdjlsh0'), //�Ǽ���ˮ��
		id0000:getValueById('INPAYid0000'), // ���֤
		Zstr04:getValueById('INPAYZstr04'), // ҽ������
		HospDr : HospDr
	}
	loadDataGridStore('dg',queryParams);	
}
/*
 * ѡ����
 */
function selectRowHandle(index,rowData){
	setValueById('INPAYZstr04',rowData.InsuType); //ҽ������
	setTimeout(function(){
		setValueById('INPAYzylsh0',rowData.Tzylsh0);
		setValueById('INPAYxming0',rowData.Txming0);
		setValueById('INPAYbcbxf0',rowData.Tbcbxf0);
		setValueById('INPAYZstr24',rowData.TZstr24);
		//setValueById('INPAYsftsbz',rowData.Tsftsbz); // ҽ�����
		setValueById('INPAYsftsbz',rowData.MedType);   // ҽ�����
		setValueById('INPAYZstr12',rowData.AdmType);   //��������
		setValueById('INPAYZstr16',rowData.TZstr16);
		setValueById('INPAYjjzfe0',rowData.Tjjzfe0);
		setValueById('INPAYZstr13',rowData.States);   //����
		setValueById('INPAYxbie00',rowData.Sex);      //�Ա�
		setValueById('INPAYdjlsh0',rowData.Tdjlsh0);
		setValueById('INPAYid0000',rowData.Tid0000);
		setValueById('INPAYgrzfe0',rowData.Tgrzfe0);
		setValueById('INPAYZstr10',rowData.PatType); //�������
		setValueById('INPAYFlag',rowData.Flag); //״̬	
	},300)	
}
/*
 * ҽ�����
 */
function init_MedType(){
	$('#INPAYsftsbz').combobox({
		valueField: 'cCode',
		textField: 'cDesc',
		editable: false,
		onBeforeLoad:function(param){
				param.ResultSetType = 'array';
			},	
		onLoadSuccess:function(data){
			if(data.length > 0){
				$('#INPAYsftsbz').combobox('select',data[0].cCode);	
			}	
		}
	})
}
/*
 * ����ҽ����� (����Ҫ���ݾ���������)
 */
function loadMedType(){
	var INSUType = getValueById('INPAYZstr04');
	setValueById('INPAYsftsbz','');
	var url = $URL + "?ClassName=web.INSUDicDataCom&QueryName=QueryDic1&Type=" + 'med_type' + INSUType + '&Code=' + '' + '&OPIPFlag=' + getValueById('INPAYZstr12')+'&HospDr='+HospDr;
	$('#INPAYsftsbz').combobox('reload', url); 
}
/*
 * ҽ������
 */
function init_INSUType(){
	var options={
		  defaultFlag:'N',
		  hospDr:HospDr
		}
	INSULoadDicData('INPAYZstr04','DLLType',options);
	$('#INPAYZstr04').combobox({
		onChange:function(){
			init_TreatmentType();
			init_States();
			loadMedType();
		}	
	})	
}
/*
 * ����
 */
function init_States(){
	var options={
		  defaultFlag:'N',
		  hospDr:HospDr
		}
	var INSUType = getValueById('INPAYZstr04');
	INSULoadDicData('INPAYZstr13','admdvs' + INSUType,options);
}
/*
 * ��������
 */
function init_AdmType(){
	$HUI.combobox("#INPAYZstr12", {
		valueField:'id',
		textField:'text',
		editable:false,
		data:[{
			"id" : 'OP',
			"text":"����",
			selected:true
		},{
			"id" : 'IP',
			"text":"סԺ"	
		}],
		onSelect:function(data){
			buildADMSeri();
			loadMedType();
		}
	})
}
/*
 * �������
 */
function init_TreatmentType(){
	var options={
		  defaultFlag:'N',
		  hospDr:HospDr
		}
	var INSUType = getValueById('INPAYZstr04');
	INSULoadDicData('INPAYZstr10','psn_type' + INSUType,options);
}
/*
 * �Ա�
 */
function init_Sex(){
	$HUI.combobox("#INPAYxbie00", {
		valueField:'id',
		textField:'text',
		data:[{
			"id" : '1',
			"text":"��",
			selected:true
		},{
			"id" : '2',
			"text":"Ů"	
		}],
	})
}
/*
 * ����״̬
 */
function init_INPAYFlag(){
	$HUI.combobox("#INPAYFlag", {
		valueField:'id',
		textField:'text',
		data:[{
			"id" : 'I',
			"text":"��������",
			selected:true
		},{
			"id" : 'D',
			"text":"Ԥ����"	
		},{
			"id" : 'S',
			"text":"����",
		},{
			"id" : 'B',
			"text":"������"	
		}],
	})
}
/**
* ����У��
*/
function checkData(index, rowData) {
	if(rowData.id==''){
		return;
	}
	// ��ǩ����
	var labelDesc =  $('#Label' + rowData.id).text();
	var val = getValueById(rowData.id);
	//����
	var required = $('#' + rowData.id).attr('required');
	if(required && val == ''){
		$.messager.alert('��ʾ', '[' + labelDesc +']' + '����Ϊ��' , 'error');
		throw msg;		
	}
	var Flag = val!=''?INSUcheckText(rowData.value, labelDesc):'';
}
