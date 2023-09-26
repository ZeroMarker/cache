//名称	DHCPECRMInfo.hisui.js
//功能  随访信息
//创建	2020.03.26
//创建人  xy

$(function(){
	 	
	InitCRMList();
	
	//保存
	$("#BSave").click(function() {	
		BSave_click();		
        });
        
    //随访完成 
    $("#BCrmFinish").click(function() {	
		 BCrmFinish_click();		
        }); 
        
	
})


function InitCRMList(){
	
	
	$HUI.datagrid("#CRMList",{
		url: $URL,
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列  
		pageSize: 20,
		pageList : [20,100,200],
		queryParams:{
			ClassName:"web.DHCPE.HighRiskNew",
			QueryName:"FindCRMInfo", 
			SourceID:SourceID,	
		},

		columns:[[
			{field:'TID',title:'ID',hidden: true},
			{field:'TSort',title:'Sort',hidden: true},
			{field:'TUser',width:'120',title:'随访人'},
			{field:'TDate',width:'120',title:'随访日期'},
			{field:'TTime',width:'120',title:'随访时间'},
			{field:'TCRMInfo',width:'400',title:'随访内容'},
			{field:'delete',title:'操作',width:'40',
			formatter:function(value,rowData,rowIndex){
				if(rowData.TSourceID!=""){
					                                                                                
					return '<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png"  title="" border="0" onclick="Delete('+rowIndex+')"></a>';
			
				}
				}},	
		]]
		
		
	
	})

	
}

function  BCrmFinish_click()
{
	var UserID=session['LOGON.USERID'];
	var ret=tkMakeServerCall("web.DHCPE.HighRiskNew","CrmFinish",SourceID,UserID)
	if(ret=="0"){
		$.messager.alert("提示","随访完成","success");
		//$("#CRMInfoWin").window("close");
		window.parent.$("#HighRiskListGrid").datagrid("reload");
		
	} 

}
function BSave_click(){
	var UserID=session['LOGON.USERID'];
	var CRMInfo=$("#CRMInfo").val();
	var ret=tkMakeServerCall("web.DHCPE.HighRiskNew","SaveCRMInfo",SourceID,CRMInfo,UserID)
	if(ret=="0"){
		$.messager.alert("提示","保存成功","success");
		$("#CRMList").datagrid("reload");
		
	}	
	
}

function Delete(selectrow){
	var objtbl = $("#CRMList").datagrid('getRows');
	var ID=objtbl[selectrow].TID;
	var Sort=objtbl[selectrow].TSort;
	var ret=tkMakeServerCall("web.DHCPE.HighRiskNew","DeleteCRMInfo",ID+"^"+Sort)
	if(ret=="0"){
		$.messager.alert("提示","删除成功","success");
		$("#CRMList").datagrid("reload");
		
	}	
}