/**
 * FileName: dhcinsu/mi.portfunargslist.js
 * Anchor: tangzf
 * Date: 2021-02-02
 * 2022-11-10/��˧/UI�޸�
 * Description: ���Ұ�-ҽ�������ϴ� �ӿ��嵥����ά��
 */
 $(function(){
	 init_portlist();	
	 
	 LoadportfunlistDG(); 
	 
	 init_HOSPID();
	 
	 init_HITYPE();
	 
	 $('#HisQueryTab.textbox').keyup(function(){
		if(event.keyCode==13){
			LoadportfunlistDG();
		}
	});
	$("#Exp").click(InLocEpot);
})
function init_HOSPID(){
		
}
function init_HITYPE(){
		
}
function init_portlist(){
	var colums = [[

		{field:'INFNO',title:'���ױ��',width:100},
		{field:'INFNAME',title:'��������',width:60},
		{field:'PARNODETYPE',title:'�����ڵ�����',width:50},
		{field:'NODECODE',title:'���ڵ����',width:100},
		{field:'SEQ',title:'���',width:100},
		{field:'ARGCODE',title:'��������',width:70},
		{field:'ARGNAME',title:'��������',width:100},
		{field:'ARGTYPE',title:'��������',width:100,formatter:function(value, data,index){
			var rtn = GLOBAL.ARGTYPE[value] || value ;
			return rtn ;	
		}},
		{field:'MAXLENG',title:'��󳤶�',width:100},
		{field:'CODEFLAG',title:'�����ʶ',width:100,formatter:function(value, data,index){
			var rtn = GLOBAL.CODEFLAG[value] || value ;
			return rtn ;	
		}},
		{field:'MUSTFLAG',title:'�����־',width:94,formatter:function(value, data,index){
			var rtn = GLOBAL.MUSTFLAG[value] || value;
			return rtn ;	
		}},
		{field:'DATADESC',title:'����',width:94},
		{field:'EFFTFLAG',title:'��Ч��ʶ',width:94,formatter:function(value, data,index){
			var rtn = GLOBAL.EFFTFLAG[value] || value;
			return rtn ;	
		}},
		{field:'VER',title:'�汾��',width:100},
		{field:'ROWID',title:'ROWID',width:48,hidden:true}
	]];
	$HUI.datagrid('#portfunlistDG',{
		border:false,
		fitColumns: true,
		singleSelect: true,
		data: [],
		fit:true,
		columns:colums,
		pageSize:30,
		pageList:[10,20,30,40],
		pagination:true,
		toolbar:'#TB',
		
		onLoadSuccess:function(data){

		},
		onDblClickRow:function(){
			
		},
		onSelect:function(rowIndex, rowData){
			FillTableInfo(rowData);
		},
		onUnselect:function(rowIndex, rowData){
			
		}
	});	
	
}
function FillTableInfo(rowData){
	setValueById('INFNO',rowData.INFNO);
	setValueById('INFNAME',rowData.INFNAME);
	setValueById('PARNODETYPE',rowData.PARNODETYPE);
	setValueById('NODECODE',rowData.NODECODE);
	setValueById('ARGCODE',rowData.ARGCODE);
	setValueById('ARGNAME',rowData.ARGNAME);
	setValueById('ARGTYPE',rowData.ARGTYPE);
	setValueById('CONTENTTYPE',rowData.CONTENTTYPE);	
	setValueById('MAXLENG',rowData.MAXLENG);
	setValueById('CODEFLAG',rowData.CODEFLAG);
	setValueById('MUSTFLAG',rowData.MUSTFLAG);
	setValueById('DATADESC',rowData.DATADESC);
	setValueById('EFFTFLAG',rowData.EFFTFLAG);
	setValueById('VER',rowData.VER);
	setValueById('SEQ',rowData.SEQ);	
}
function LoadportfunlistDG(){
	var ParamStr = getValueById('INFNO') + '|' + getValueById('INFNAME') + '|' + getValueById('ARGCODE') + '|' + getValueById('ARGNAME');
	var queryParams = {
	    ClassName : 'INSU.MI.PortFunArgsListCom',
	    QueryName : 'QueryPortFunArgsList',
	    ParamStr: ParamStr   
	}	
    loadDataGridStore('portfunlistDG',queryParams);				
}
$('#Find').bind('click', function () {
	LoadportfunlistDG();
});
$('#Save').bind('click', function () {
	var dgSelect = $('#portfunlistDG').datagrid('getSelected');
	var selectROWID = '';
	if(dgSelect){
		selectROWID = dgSelect.ROWID;	
	}
	if(selectROWID != ''){ // uodate
		$.messager.confirm('ȷ��','�Ƿ�����޸�����?',function(r){		
			if(r){
				SavePortList();	
			}			
		})
	}else{ // add	
		SavePortList();
	}
});
$('#Del').bind('click', function () {
	DeletePortList();
});
$('#Clean').bind('click', function () {
	setValueById('INFNO','');
	setValueById('INFNAME','');
	setValueById('PARNODETYPE','');
	setValueById('NODECODE','');
	setValueById('ARGCODE','');
	setValueById('ARGNAME','');
	setValueById('ARGTYPE','');
	setValueById('CONTENTTYPE','');	
	setValueById('MAXLENG','');
	setValueById('CODEFLAG','');
	setValueById('MUSTFLAG','');
	setValueById('DATADESC','');
	setValueById('EFFTFLAG','');
	setValueById('VER','');	
	setValueById('SEQ','');	
	$('#portfunlistDG').datagrid('unselectAll');
	$('#portfunlistDG').datagrid('uncheckAll');
});

 // ����
function SavePortList(){
	var INFNO = getValueById('INFNO');
	var INFNAME = getValueById('INFNAME');
	var PARNODETYPE =getValueById('PARNODETYPE');
	var NODECODE= getValueById('NODECODE');
	var ARGCODE = getValueById('ARGCODE');
	var ARGNAME = getValueById('ARGNAME');
	var ARGTYPE = getValueById('ARGTYPE');
	
	var MAXLENG = getValueById('MAXLENG');
	var CODEFLAG = getValueById('CODEFLAG');
	var MUSTFLAG = getValueById('MUSTFLAG');
	var DATADESC = getValueById('DATADESC');
	var EFFTFLAG = getValueById('EFFTFLAG');
	var VER = getValueById('VER');
	var SEQ = getValueById('SEQ');
	var dgSelect = $('#portfunlistDG').datagrid('getSelected');
	var selectROWID = '';
	if(dgSelect){
		selectROWID = dgSelect.ROWID;	
	}
	var InStr = selectROWID + '^' + INFNO  + '^' + INFNAME + '^' + PARNODETYPE  + '^' + NODECODE + '^' + ARGCODE  + '^' + ARGNAME + '^' + ARGTYPE + '^' + MAXLENG;
	InStr = InStr + '^' + CODEFLAG  + '^' + MUSTFLAG + '^' + DATADESC  + '^' + EFFTFLAG + '^' + VER + '^' + SEQ;
	InStr.replace(undefined,'')
	var rtn = $.m({ClassName: "INSU.MI.PortFunArgsListCom", MethodName: "Save", InStr:InStr,SessionStr: session['LOGON.USERID']}, false);
	if (rtn == '0'){
		INSUMIAlert('����ɹ�' , 'success');
	}else{
		INSUMIAlert('����ʧ�ܣ�'  + rtn , 'error');
	}
	LoadportfunlistDG();
}
// ɾ��
function DeletePortList(){
	var dgSelect = $('#portfunlistDG').datagrid('getSelected');
	var RowId = '';
	if(dgSelect){
		RowId = dgSelect.ROWID;	
	}
	if (RowId == ''){
		INSUMIAlert('��ѡ��Ҫɾ������' , 'error');
		return;	
	}	
	
	$.messager.confirm('��ʾ','�Ƿ����ɾ��������?�ò�����ɾ����Ӧ�Ĳ���',function(r){
				if(r){
	var rtn = $.m({ClassName: "INSU.MI.PortFunArgsListCom", MethodName: "Delete", RowId:RowId,}, false);
	if (rtn == '0'){
		INSUMIAlert('ɾ���ɹ�' , 'success');
		LoadportfunlistDG();
	}else{
		INSUMIAlert('ɾ��ʧ��'  + rtn , 'error');
		LoadportfunlistDG();
	}
	
				}
				});
				
}
// ����
$('#Imp').bind('click', function () {
	INSUMIFileOpenWindow(import_PortFunArgsList);
});
//����  2022/10/31  ��˧1010
function InLocEpot()
{
	
	    
    var ParamStr = getValueById('INFNO') + '|' + getValueById('INFNAME') + '|' + getValueById('ARGCODE') + '|' + getValueById('ARGNAME'); 
	try
	{

	var rtn = $cm({
	dataType:'text',
	ResultSetType:"Excel",
	ExcelName:"�ӿ��嵥����ά��", //Ĭ��DHCCExcel
	ClassName:"INSU.MI.PortFunArgsListCom",
	QueryName:"QueryPortFunArgsList",
    ParamStr: ParamStr   
     },false);
     location.href = rtn;
	$.messager.progress({
				title: "��ʾ",
				msg: '�ӿ��嵥����ά��',
				text: '������....'
			});
	setTimeout('$.messager.progress("close");', 3 * 1000);	
		
		return;
	} catch(e) {
		$.messager.alert("����",e.message);
		$.messager.progress('close');
	};
	
	
	}
