/**
 * ģ��:    ����ҩ��
 * ��ģ��:  ҩ���䷢���ڹ���
 * ��д����:2017-11-23
 * ��д��:  yunhaibao
 */
var commonOutPhaUrl = "DHCST.OUTPHA.ACTION.csp";
$(function(){
	InitDict();	
	InitGrid();
	$("#btnClear").on('click',ClearHandler);
	$("#btnAdd").on('click',AddHandler);
	$("#btnDelete").on('click',DeleteHandler);
	$("#btnSearch").on('click',SearchHandler);
});

function InitDict(){
	var options={
		width:'auto',
		editable:false ,
		panelWidth:'auto',
		url:commonOutPhaUrl+'?action=GetUserAllLocDs&gUserId='+session['LOGON.USERID'],
		onSelect:function(selData){  
			var selLocId=selData.RowId;
			/// ����-��ҩ����
			var secOptions={
				editable:false ,
				width:'auto',
				panelWidth:'auto',
				url:commonOutPhaUrl+'?action=GetPYWinList&gLocId='+selLocId,	
			};
			$("#cmbPyWin").dhcphaEasyUICombo(secOptions);	
			/// ����-��ҩ����
			var secOptions={
				editable:false ,
				ClassName:"web.DHCOutPhCode",
				QueryName:"GetFyWinDict",
				StrParams:selLocId		
			}
			$("#cmbFyWin").dhcstcomboeu(secOptions);	
		}  
	}
	$('#cmbPhLoc').dhcphaEasyUICombo(options);		 
}

function InitGrid(){
	var gridColumns=[[
		{field:'TLocDesc',title:'ҩ������',width:250},
		{field:'TPyWinDesc',title:'��ҩ����',width:250},
		{field:'TFyWinDesc',title:'��ҩ����',width:250},
		{field:'TPhlid',title:'����ҩ��ID',width:200,hidden:true},
		{field:'TPyWinID',title:'��ҩ����ID',width:200,hidden:true},
		{field:'TPhwid',title:'��ҩ����ID',width:200,hidden:true},
		{field:'TLocId',title:'����ID',width:200,hidden:true}
	]];
	
	var options={
		ClassName:'web.DHCOutPhCode',
		QueryName:'FindPhPYWinSub',
		fitColumns:true,
        columns:gridColumns,
        singleSelect:true,
        striped:true,
        toolbar:"#btnbar"  
	}
	$('#grid-pfwin').dhcstgrideu(options);	
}

function SearchHandler(){
	var locId=$("#cmbPhLoc").combobox('getValue');
	$('#grid-pfwin').datagrid({
     	queryParams:{
			StrParams:locId
		}
	});
}
function AddHandler(){
	var locId=$("#cmbPhLoc").combobox('getValue');
	if(locId==""){
		$.messager.alert('��ʾ',"ҩ�����Ʋ���Ϊ��!","warning");
		return;
	}
	var fyWinId=$("#cmbFyWin").combobox('getValue');
	if(fyWinId==""){
		$.messager.alert('��ʾ',"��ҩ���ڲ���Ϊ��!","warning");
		return;
	}
	var pyWinId=$("#cmbPyWin").combobox('getValue');
	if(pyWinId==""){
		$.messager.alert('��ʾ',"��ҩ���ڲ���Ϊ��!","warning");
		return;
	}
	var saveRet=tkMakeServerCall("web.DHCOutPhCode","insertPhPyFyWin",locId,fyWinId,pyWinId);
	if(saveRet==0){
		$.messager.alert('�ɹ���ʾ',"���ӳɹ�!","info");
		$("#grid-pfwin").datagrid('reload');
	}else if(saveRet==-1){
		$.messager.alert('��ʾ',"��ѡ��ķ�ҩ�����Ѿ�����!","warning");
	}else{
		$.messager.alert('������ʾ',"����ʧ��,�������:"+saveRet,"error");
	}
}

function ClearHandler(){
	$("#cmbPhLoc").combobox('setValue',"");
	$("#cmbPyWin").combobox('setValue',"");
	$("#cmbFyWin").combobox('setValue',"");
	$("#cmbPyWin").combobox('loadData', {});
	$("#cmbFyWin").combobox('loadData', {});
	$('#grid-pfwin').datagrid({
     	queryParams:{
			StrParams:""
		}
	});
}

function DeleteHandler(){
	var seletcted = $("#grid-pfwin").datagrid("getSelected");
	if (seletcted==null){
		$.messager.alert('��ʾ',"����ѡ����ɾ���ļ�¼!","warning");
		return;
	}
	$.messager.confirm('��ʾ','��ȷ��ɾ����',function(r){
		if(r){
			var pfWinId=seletcted.TPyWinID;
			var delRet=tkMakeServerCall("web.DHCOutPhCode","DeletePyFyWin",pfWinId);
			if(delRet==0){
				$.messager.alert('�ɹ���ʾ',"ɾ���ɹ�!","info");
				$("#grid-pfwin").datagrid('reload');
			}else{
				$.messager.alert('������ʾ',"ɾ��ʧ��,�������:"+delRet,"error");
			}
		}
	});
}