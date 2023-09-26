/*
模块:住院药房
子模块:住院药房-首页-侧菜单-退药原因维护
createdate:2016-06-21
creator:dinghongying
*/
var url = "dhcpha.inpha.retreason.action.csp";
var HospId = session['LOGON.HOSPID'];
$(function(){
	InitHospCombo();
	InitRetReasonList();	
	
	$('#Badd').bind('click', Add);//点击增加
	$('#Bupdate').bind('click', Update);//点击更新
	$('#Bdelete').bind('click', Delete);//点击删除
});


//初始化退药原因列表
function InitRetReasonList(){
	//定义columns
	var columns=[[
		{field:'TReasonCode',title:'代码',width:300},
	    {field:'TReasonDesc',title:'描述',width:300},
	    {field:'TRowid',title:'RowId',width:200,hidden:true}
	]];  
   //定义datagrid	
   $('#retreasondg').datagrid({    
        url:url+'?action=GetRetReasonList&HospId='+HospId,
        fit:true,
	    border:false,
	    striped:true,
	    singleSelect:true,
	    rownumbers:true,
        columns:columns,
        pageSize:30,  // 每页显示的记录条数
	    pageList:[30,50,100],   // 可以设置每页记录条数的列表
	    singleSelect:true,
	    loadMsg: '正在加载信息...',
	    pagination:true,
	    onClickRow:function(rowIndex,rowData){
			if (rowData){
				var RowId=rowData['TRowid'];
				var retreasondesc=rowData['TReasonDesc'];
				var retreasoncode=rowData['TReasonCode'];
				$("#Desc").val(retreasondesc);
				$("#Code").val(retreasoncode);
			}
		}   
   });
}


///退药原因代码增加
function Add()
{
	var ReasonDesc=$("#Desc").val();
	var ReasonCode=$("#Code").val();
	if(ReasonCode=="" & ReasonDesc==""){
		$.messager.alert('信息提示',"请输入退药原因代码和描述!","info");
		return;
	}
	if(ReasonCode==""){
		$.messager.alert('信息提示',"请输入退药原因代码!","info");
		return;
	}
	if(ReasonDesc==""){
		$.messager.alert('信息提示',"请输入退药原因描述!","info");
		return;
	}
	else{
		var RowId=""
		var returnValue= tkMakeServerCall("web.DHCINPHA.RetReason","InsertRetReason",ReasonDesc,RowId,ReasonCode,HospId);
		if(returnValue==0){
			$.messager.alert('信息提示',"增加成功!");
			$('#retreasondg').datagrid('reload');
		}else if (returnValue=="-12"){
			$.messager.alert('信息提示',"代码重复,不允许增加!","info");
		}else if (returnValue=="-11"){
			$.messager.alert('信息提示',"描述重复,不允许增加!","info");
		}else{
			$.messager.alert('信息提示',"添加失败,错误代码:"+returnValue,"warning");
		}
	}
}


///退药原因代码修改
function Update()
{
	var selected = $("#retreasondg").datagrid("getSelected");
	if (selected==null){
		$.messager.alert('信息提示',"请先选中需要修改的数据!","info");
		return;
	}
	var RowId=selected.TRowid
	var ReasonCode=$("#Code").val();
	var ReasonDesc=$("#Desc").val();
    var retValue=tkMakeServerCall("web.DHCINPHA.RetReason","UpdateRetReason",ReasonDesc,RowId,ReasonCode,HospId);
    if(retValue==0){
	    //$.messager.alert('信息提示',"修改成功!");
    	$('#retreasondg').datagrid('reload');
    }else if (retValue=="-12"){
		$.messager.alert('信息提示',"代码重复,不允许修改!","info");
	}else if (retValue=="-11"){
		$.messager.alert('信息提示',"描述重复,不允许修改!","info");
	}else {
		$.messager.alert('信息提示',"修改失败,错误代码:"+retValue,"warning");
	}
   
}

///退药原因代码删除
function Delete(){
	var selected = $("#retreasondg").datagrid("getSelected");
	if (selected==null){
		$.messager.alert('信息提示',"请先选中需要删除的数据!","info");
		return;
	}
	var RowId=selected.TRowid
	$.messager.confirm('信息提示',"确认删除吗？",function(r){
		if(r){
			var retValue=tkMakeServerCall("web.DHCINPHA.RetReason","DeleteRetReason",RowId,HospId);
			if(retValue==0){
				$("#Desc").val("");
				$("#Code").val("");	
				$('#retreasondg').datagrid('reload');
			}
			else{
				$.messager.alert('信息提示',"删除失败,错误代码:"+retValue,"error");
			}
		}
	});
}
function InitHospCombo(){
	var genHospObj=DHCSTEASYUI.GenHospComp({tableName:'BLC_ReasonForRefund'});
	if (typeof genHospObj ==='object'){
		$(genHospObj).combogrid('options').onSelect =  function(index, record) {
			NewHospId=record.HOSPRowId;
			if(NewHospId!=HospId){
				HospId=NewHospId;	
				$("#Code").val('');
				$("#Desc").val('');
				$('#retreasondg').datagrid('options').queryParams.HospId=HospId;			
				$('#retreasondg').datagrid('reload');		
			}
        };
	}
}

