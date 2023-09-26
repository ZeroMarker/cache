/*
模块:住院药房
子模块:住院药房-首页-侧菜单-拒绝发药原因维护
createdate:2016-06-29
creator:dinghongying
*/
var url = "dhcpha.inpha.drugrefusereason.action.csp";
var HospId = session['LOGON.HOSPID'];
$(function(){
	InitHospCombo(); //加载医院
	InitDrugRefuseReasonList();		
	$('#Add').bind('click', Add);//点击增加
	$('#Modify').bind('click', Modify);//点击修改
	$('#Delete').bind('click', Delete);//点击删除
});


//初始化拒绝发药原因列表
function InitDrugRefuseReasonList(){
	//定义columns
	var columns=[[
	    {field:'Rowid',title:'Rowid',width:200,hidden:true},
	    {field:'Code',title:'代码',width:300},
	    {field:'Desc',title:'名称',width:300}
	]];  
   //定义datagrid	
   $('#drugrefusereasondg').datagrid({    
        url:url+'?action=GetDrugRefuseReasonList&HospId='+HospId,
        fit:true,
	    border:false,
	    striped:true,
	    singleSelect:true,
	    rownumbers:true,
        columns:columns,
        pageSize:50,  // 每页显示的记录条数
	    pageList:[50,100,300],   // 可以设置每页记录条数的列表
	    singleSelect:true,
	    loadMsg: '正在加载信息...',
	    pagination:true,
	    onClickRow:function(rowIndex,rowData){
			if (rowData){
				var RowId=rowData['Rowid'];
				var desc=rowData['Desc'];
				var code=rowData['Code'];
				$("#Desc").val(desc);
				$("#Code").val(code);
			}
		}   
   });
}


///拒绝发药原因代码增加
function Add()
{
	var ReasonCode=$("#Code").val();
	var ReasonDesc=$("#Desc").val();
	if(ReasonCode=="" & ReasonDesc==""){
		$.messager.alert('信息提示',"请输入拒绝发药原因代码和名称!");
		return;
	}
	if(ReasonCode==""){
		$.messager.alert('信息提示',"请输入拒绝发药原因代码!");
		return;
	}
	if(ReasonDesc==""){
		$.messager.alert('信息提示',"请输入拒绝发药原因名称!");
		return;
	}
	else{
		var RowId=""
		var retValue= tkMakeServerCall("web.DHCINPHA.DrugRefuseReason","InsertRefReason",RowId,ReasonCode,ReasonDesc,HospId);
		if(retValue==-1){
			$.messager.alert('信息提示',"代码重复,不允许增加!","info");
		}
		else if(retValue==-2){
			$.messager.alert('信息提示',"名称重复,不允许增加!","info");
		}
		else if(retValue==-100){
			$.messager.alert('信息提示',"添加失败,错误代码:"+retValue,"warning");
		}
		else{
			$.messager.alert('信息提示',"添加成功!");
			$('#drugrefusereasondg').datagrid('reload');
		}
	}
}


///拒绝发药原因代码修改
function Modify()
{
	var selected = $("#drugrefusereasondg").datagrid("getSelected");
	if (selected==null){
		$.messager.alert('信息提示',"请先选中需要修改的数据!","info");
		return;
	}
	else{
		var RowId=selected.Rowid
		var ReasonCode=$("#Code").val();
		var ReasonDesc=$("#Desc").val();
		var retValue=tkMakeServerCall("web.DHCINPHA.DrugRefuseReason","UpdateRefReason",RowId,ReasonCode,ReasonDesc,HospId);
		if(retValue==-1){
			$.messager.alert('信息提示',"代码重复,不允许修改!","info");
		}
		else if(retValue==-2){
			$.messager.alert('信息提示',"名称重复,不允许修改!","info");
		}
		else if(retValue==-100){
			$.messager.alert('信息提示',"修改失败,错误代码:"+retValue,"warning");
		}
		else{
			$.messager.alert('信息提示',"修改成功!");
			$('#drugrefusereasondg').datagrid('reload');
		}
	}
}

///拒绝发药原因代码删除
function Delete(){
	var selected = $("#drugrefusereasondg").datagrid("getSelected");
	if (selected==null){
		$.messager.alert('信息提示',"请先选中需要删除的数据!","info");
		return;
	}
	else{
		var RowId=selected.Rowid
		$.messager.confirm('信息提示',"确认删除吗？",function(r){
			if(r){
				var retValue=tkMakeServerCall("web.DHCINPHA.DrugRefuseReason","DeleteRefReason",RowId,HospId);
				if(retValue==0){
					$.messager.alert('信息提示',"删除成功!");
					$("#Desc").val("");
					$("#Code").val("");
					$('#drugrefusereasondg').datagrid('reload');
				}
				else{
					$.messager.alert('信息提示',"删除失败,错误代码:"+retValue,"error");
				}
			}
		});
	}
}

function InitHospCombo(){
	var genHospObj=DHCSTEASYUI.GenHospComp({tableName:'DHC_STRefuseReason'});
	if (typeof genHospObj ==='object'){
		$(genHospObj).combogrid('options').onSelect =  function(index, record) {
			NewHospId=record.HOSPRowId;
			if(NewHospId!=HospId){
				HospId=NewHospId;	
				$("#Code").val('');
				$("#Desc").val('');
				$('#drugrefusereasondg').datagrid('options').queryParams.HospId=HospId;			
				$('#drugrefusereasondg').datagrid('reload');		
			}
        };
	}
}