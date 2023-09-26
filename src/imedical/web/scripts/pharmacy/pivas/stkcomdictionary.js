/**
 * 模块:     小字典维护
 * 编写日期: 2018-03-06
 * 编写人:   QianHuanjuan
 */
 
$(function(){
	InitGridDictionary(); //初始化列表
	InitDict();
	$('#btnAdd').on("click",function(){
		MainTain("A");
	}); 
	$('#btnUpdate').on("click",function(){
		MainTain("U");
	});  
	$('#btnDelete').on("click",DeleteHandler);
	$('#cmbStkComDict').next().find(".combo-text").attr("placeholder","请选择字典类型...");
});
function InitDict(){
	PIVAS.ComboBox.Init({Id:"cmbStkComDict",Type:"StkComDict"},{editable:false,width:157,
		onSelect:function(selData){
			QueryStkComDict();
		}
	});		
}
/// 查询字典维护列表
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
		{field:"SCDIId",title:'字典Id',align:'center',hidden:true},
		{field:'SCDICode',title:'字典代码',width:225,halign:'center',align:'center',sortable:'true'},
		{field:'SCDIDesc',title:'字典名称',width:225,halign:'center',align:'center'},
		{field:'SCDIType',title:'字典类型',width:225,halign:'center',align:'center'},
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
			$.messager.alert("提示","请先选中需要修改的记录!","warning");
			return;
		}
		$("#txtSCDICode").val(gridSelect.SCDICode);		
		$("#txtSCDIDesc").val(gridSelect.SCDIDesc);	
					
	}else if(type="A"){
		if($("#cmbStkComDict").combobox("getValue")==""){
			$.messager.alert("提示","请先选择字典类型!","warning");
			return;
		}
		$("#txtSCDICode").val("");		
		$("#txtSCDIDesc").val("");
	}
	$('#gridStkComDictionaryWin').window({'title':"字典维护"+((type=="A")?"增加":"修改")})
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
	if (winTitle.indexOf("修改")>=0){
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
		$.messager.alert("提示",saveInfo,"warning");
		return;
	}	
	$('#gridStkComDictionaryWin').window('close');
	$('#gridStkComDictionary').datagrid("reload");
}
function DeleteHandler(){
	var gridSelect=$('#gridStkComDictionary').datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert("提示","请选择需要删除的记录!","warning");
		return;
	}
	$.messager.confirm('确认对话框', '确定删除吗？', function(r){
		if (r){
			var SCDIId=gridSelect.SCDIId;
			var delRet=tkMakeServerCall("web.DHCSTPIVAS.StkComDictionary","DeleteStkComDict",SCDIId);
			$('#gridStkComDictionary').datagrid("reload");
		}
	})
}