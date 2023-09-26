/**
 * ģ��:     С�ֵ�ά��
 * ��д����: 2018-03-06
 * ��д��:   QianHuanjuan
 */
 
$(function(){
	InitGridDictionary(); //��ʼ���б�
	InitDict();
	$('#btnAdd').on("click",function(){
		MainTain("A");
	}); 
	$('#btnUpdate').on("click",function(){
		MainTain("U");
	});  
	$('#btnDelete').on("click",DeleteHandler);
	$('#cmbStkComDict').next().find(".combo-text").attr("placeholder","��ѡ���ֵ�����...");
});
function InitDict(){
	PIVAS.ComboBox.Init({Id:"cmbStkComDict",Type:"StkComDict"},{editable:false,width:157,
		onSelect:function(selData){
			QueryStkComDict();
		}
	});		
}
/// ��ѯ�ֵ�ά���б�
function QueryStkComDict(){
	var SCDITypeId=$("#cmbStkComDict").combobox('getValue');
	var params=SCDITypeId;
	$('#gridStkComDictionary').datagrid({
		queryParams:{
			StrParams:params
	    }
	});		
}
function InitGridDictionary(){
	var columns=[[
		{field:"SCDIId",title:'�ֵ�Id',align:'center',hidden:true},
		{field:'SCDICode',title:'�ֵ����',width:225,halign:'center',align:'center',sortable:'true'},
		{field:'SCDIDesc',title:'�ֵ�����',width:225,halign:'center',align:'center'},
		{field:'SCDIType',title:'�ֵ�����',width:225,halign:'center',align:'center'},
	]];
	var dataGridOption={
		ClassName:'web.DHCSTPIVAS.StkComDictionary',
		QueryName:'StkComDictionary',	
		columns:columns,
		rownumbers:false,
		toolbar:"#gridStkComDictionaryBar",
		onClickRow:function(rowIndex,rowData){
			if (rowData){
				$('#txtSCDICode').val(rowData.SCDICode);
				$('#txtSCDIDesc').val(rowData.SCDIDesc);
				$('#cmbStkComDict').val(rowData.SCDIType);
			}
		} 
	};
	$('#gridStkComDictionary').dhcstgrideu(dataGridOption);
}

function MainTain(type){
	var gridSelect = $('#gridStkComDictionary').datagrid('getSelected');
	if(type=="U"){
		if(gridSelect==null){
			$.messager.alert("��ʾ","����ѡ����Ҫ�޸ĵļ�¼!","warning");
			return;
		}
		$("#txtSCDICode").val(gridSelect.SCDICode);		
		$("#txtSCDIDesc").val(gridSelect.SCDIDesc);	
					
	}else if(type="A"){
		if($("#cmbStkComDict").combobox("getValue")==""){
			$.messager.alert("��ʾ","����ѡ���ֵ�����!","warning");
			return;
		}
		$("#txtSCDICode").val("");		
		$("#txtSCDIDesc").val("");
	}
	$('#gridStkComDictionaryWin').window({'title':"�ֵ�ά��"+((type=="A")?"����":"�޸�")})
	$('#gridStkComDictionaryWin').window('open');
	$('#gridStkComDictionaryWin').window('move',{
		left:event.clientX,
		top:event.clientY,
	});			
}

function SaveStkComDictionary(){
	var winTitle=$("#gridStkComDictionaryWin").panel('options').title;
	var gridSelect = $('#gridStkComDictionary').datagrid('getSelected');
	var SCDICode=$('#txtSCDICode').val().trim();
	var SCDIDesc=$('#txtSCDIDesc').val().trim();
	var SCDITypeId=$("#cmbStkComDict").combobox("getValue");
	var SCDIId="";
	if (winTitle.indexOf("�޸�")>=0){
		SCDIId=gridSelect.SCDIId;
	}else{
		SCDIId="";
	}
	var params=SCDIId+"^"+SCDICode+"^"+SCDIDesc+"^"+SCDITypeId;
	var saveRet=tkMakeServerCall("web.DHCSTPIVAS.StkComDictionary","SaveStkComDict",params);
	var saveArr=saveRet.split("^");
	var saveVal=saveArr[0];
	var saveInfo=saveArr[1];
	if (saveVal<0){
		$.messager.alert("��ʾ",saveInfo,"warning");
		return;
	}	
	$('#gridStkComDictionaryWin').window('close');
	$('#gridStkComDictionary').datagrid("reload");
}
function DeleteHandler(){
	var gridSelect=$('#gridStkComDictionary').datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert("��ʾ","��ѡ����Ҫɾ���ļ�¼!","warning");
		return;
	}
	$.messager.confirm('ȷ�϶Ի���', 'ȷ��ɾ����', function(r){
		if (r){
			var SCDIId=gridSelect.SCDIId;
			var delRet=tkMakeServerCall("web.DHCSTPIVAS.StkComDictionary","DeleteStkComDict",SCDIId);
			$('#gridStkComDictionary').datagrid("reload");
		}
	})
}