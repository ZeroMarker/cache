/**
 * ģ��:    ����ҩ��
 * ��ģ��:  ҩ���䷢���ڹ���
 * ��д����:2017-11-23
 * ��д��:  yunhaibao
 */
var HospId=session['LOGON.HOSPID'];
var commonOutPhaUrl = "DHCST.OUTPHA.ACTION.csp";
$(function(){
	InitHospCombo();
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
		url:commonOutPhaUrl+'?action=GetUserAllLocDs&gUserId='+session['LOGON.USERID']+"&HospId="+HospId,
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
		{field:'TLocDesc',title:$g("ҩ������"),width:250},
		{field:'TPyWinDesc',title:$g("��ҩ����"),width:250},
		{field:'TFyWinDesc',title:$g("��ҩ����"),width:250},
		{field:'TPhlid',title:$g("����ҩ��ID"),width:200,hidden:true},
		{field:'TPyWinID',title:$g("��ҩ����ID"),width:200,hidden:true},
		{field:'TPhwid',title:$g("��ҩ����ID"),width:200,hidden:true},
		{field:'TLocId',title:$g("����ID"),width:200,hidden:true}
	]];
	
	var options={
		ClassName:'web.DHCOutPhCode',
		QueryName:'FindPhPYWinSub',
     	queryParams:{
			StrParams:""+"|@|"+HospId
		},
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
			StrParams:locId+"|@|"+HospId
		}
	});
}
function AddHandler(){
	var locId=$("#cmbPhLoc").combobox('getValue');
	if(locId==""){
		$.messager.alert($g("��ʾ"),$g("ҩ�����Ʋ���Ϊ��!"),"warning");
		return;
	}
	var fyWinId=$("#cmbFyWin").combobox('getValue');
	if(fyWinId==""){
		$.messager.alert($g("��ʾ"),$g("��ҩ���ڲ���Ϊ��!"),"warning");
		return;
	}
	var pyWinId=$("#cmbPyWin").combobox('getValue');
	if(pyWinId==""){
		$.messager.alert($g("��ʾ"),$g("��ҩ���ڲ���Ϊ��!"),"warning");
		return;
	}
	var saveRet=tkMakeServerCall("web.DHCOutPhCode","insertPhPyFyWin",locId,fyWinId,pyWinId);
	if(saveRet==0){
		$.messager.alert($g("�ɹ���ʾ"),$g("���ӳɹ�!"),"info");
		$("#grid-pfwin").datagrid('reload');
	}else if(saveRet==-1){
		$.messager.alert($g("��ʾ"),$g("��ѡ��ķ�ҩ�����Ѿ�����!"),"warning");
	}else{
		$.messager.alert($g("������ʾ"),$g("����ʧ��,�������:")+saveRet,"error");
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
			StrParams:""+"|@|"+HospId
		}
	});
}

function DeleteHandler(){
	var seletcted = $("#grid-pfwin").datagrid("getSelected");
	if (seletcted==null){
		$.messager.alert($g("��ʾ"),$g("����ѡ����ɾ���ļ�¼!"),"warning");
		return;
	}
	$.messager.confirm($g("��ʾ"),$g("��ȷ��ɾ����"),function(r){
		if(r){
			var pfWinId=seletcted.TPyWinID;
			var delRet=tkMakeServerCall("web.DHCOutPhCode","DeletePyFyWin",pfWinId);
			if(delRet==0){
				$.messager.alert($g("�ɹ���ʾ"),$g("ɾ���ɹ�!"),"info");
				$("#grid-pfwin").datagrid('reload');
			}else{
				$.messager.alert($g("������ʾ"),$g("ɾ��ʧ��,�������:")+delRet,"error");
			}
		}
	});
}

function InitHospCombo(){
	var genHospObj = DHCSTEASYUI.GenHospComp({tableName:'PHA-OP-PreDispWin'}); //����ҽԺ
	if (typeof genHospObj === 'object') {
		//����ѡ���¼�
		$('#_HospList').combogrid("options").onSelect=function(index,record){
			NewHospId=record.HOSPRowId;
			if(NewHospId!=HospId){
				HospId=NewHospId;
				$('#cmbPhLoc').combobox('loadData',[]);
				$('#cmbPhLoc').combobox('options').url=commonOutPhaUrl+'?action=GetUserAllLocDs&gUserId='+session['LOGON.USERID']+'&HospId='+HospId;
				$('#cmbPhLoc').combobox('reload');
				$('#cmbPyWin').combobox('loadData',[]);	
				$('#cmbFyWin').combobox('loadData',[]);	
				ClearHandler();				
			}
		};
	}
}