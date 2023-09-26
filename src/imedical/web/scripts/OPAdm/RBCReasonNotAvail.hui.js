var PageLogicObj={
	m_RBCReasonNotAvailTabDataGrid:""
};
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//表格数据初始化
	RBCReasonNotAvailTabDataGridLoad();
});
function Init(){
	PageLogicObj.m_RBCReasonNotAvailTabDataGrid=InitRBCReasonNotAvailTabDataGrid();
}
function InitEvent(){
	$("#Bfind").click(RBCReasonNotAvailTabDataGridLoad)
}
function InitRBCReasonNotAvailTabDataGrid(){
	var toobar=[{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() {AddClickHandle(); }
    },{
        text: '保存',
        iconCls: 'icon-save',
        handler: function() { UpdateClickHandle();}
    }];
	var Columns=[[ 
		{field:'TID',hidden:true,title:''},
		{field:'TRNAVCode',title:'代码',width:300},
		{field:'TRNAVDesc',title:'原因',width:300},
		{field:'TRNAVDateFrom',title:'生效日期',width:250},
		{field:'TRNAVDateTo',title:'截止日期',width:250},
		{field:'TRNAVType',hidden:true,title:''}
    ]]
	var RBCReasonNotAvailTabDataGrid=$("#RBCReasonNotAvailTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'TID',
		columns :Columns,
		toolbar:toobar,
		onCheck:function(index, row){
			SetSelRowData(row);
		},
		onUnselect:function(index, row){
			ClearData();
		},
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_RBCReasonNotAvailTabDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_RBCReasonNotAvailTabDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_RBCReasonNotAvailTabDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		}
	}); 
	return RBCReasonNotAvailTabDataGrid;
}
function SetSelRowData(row){
	$("#code").val(row["TRNAVCode"])
	$("#name").val(row["TRNAVDesc"])
	$("#StartDate").datebox('setValue',row["TRNAVDateFrom"])
	$("#EndDate").datebox('setValue',row["TRNAVDateTo"])
}
function RBCReasonNotAvailTabDataGridLoad(){
	var Code=$("#code").val()
	var Name=$("#name").val()
	$.q({
		ClassName:"web.DHCBL.CARD.DHCRBCReasonNotAvail",
		QueryName:"RBCReasonNotAvailQuery",
		Code:Code,
		Name:Name,
		Pagerows:PageLogicObj.m_RBCReasonNotAvailTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_RBCReasonNotAvailTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	})
}
function AddClickHandle(){
	if(!CheckData()) return false;
	var Code=$("#code").val()
	var Name=$("#name").val()
	var DateFrom=$("#StartDate").datebox("getValue")
	var DateTo=$("#EndDate").datebox("getValue")
	if(Code==""){
		$.messager.alert("提示","代码不能为空!")
		return false;
	}
	//构造服务端解析对象
	var ParseInfo="TransContent^RNAVCode^RNAVDateFrom^RNAVDateTo^RNAVDesc";
	//var RBCReasonNotAvail=DHCDOM_GetEntityClassInfoToXML(ParseInfo);
	var RBCReasonNotAvail="<TransContent>"+DHCStringToXml("RNAVCode",Code)+DHCStringToXml("RNAVDesc",Name)+DHCStringToXml("RNAVDateFrom",DateFrom)+DHCStringToXml("RNAVDateTo",DateTo)+"</TransContent>"
	$.cm({
		ClassName:"web.DHCBL.CARD.DHCRBCReasonNotAvailBuilder",
		MethodName:"DHCRBCReasonNotAvailInsert",
		DHCRBCReasonNotAvailInfo:RBCReasonNotAvail
	},function(rtn){
		if(rtn=="-100"){
			$.messager.alert("提示","新增失败!")
			return false;	
		}else if(rtn=="10"){
			$.messager.alert("提示","代码已经存在!")
			return false;
		}else{
			$.messager.alert("提示","新增成功!")
			ClearData()
			RBCReasonNotAvailTabDataGridLoad()
		}
	})
}
function UpdateClickHandle(){
	var row=PageLogicObj.m_RBCReasonNotAvailTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择一行！")
		return false
	}
	if(!CheckData()) return false;
	var RowId=row["TID"]
	var Code=$("#code").val()
	var Name=$("#name").val()
	var DateFrom=$("#StartDate").datebox("getValue")
	var DateTo=$("#EndDate").datebox("getValue")
	if(Code==""){
		$.messager.alert("提示","代码不能为空!")
		return false;
	}
	var rtn=$.cm({
		ClassName:"web.DHCBL.CARD.DHCRBCReasonNotAvailBuilder",
		MethodName:"GetTIDByCode",
		InPutCode:Code,
		ID:RowId
	},false)
	if(rtn!="0"){
		$.messager.alert("提示","代码重复!")
		return false;
	}
	//构造服务端解析对象
	//var ParseInfo="TransContent^ID^RNAVCode^RNAVDateFrom^RNAVDateTo^RNAVDesc^RNAVType";
	var RBCReasonNotAvail="<TransContent>"+DHCStringToXml("ID",RowId)+DHCStringToXml("RNAVCode",Code)+DHCStringToXml("RNAVDesc",Name)+DHCStringToXml("RNAVDateFrom",DateFrom)+DHCStringToXml("RNAVDateTo",DateTo)+"</TransContent>"
	$.cm({
		ClassName:"web.DHCBL.CARD.DHCRBCReasonNotAvailBuilder",
		MethodName:"DHCRBCReasonNotAvailUpdate",
		DHCRBCReasonNotAvailInfo:RBCReasonNotAvail
	},function(rtn){
		if(rtn!="-100"){			
			$.messager.alert("提示","更新成功!")
			ClearData()
			RBCReasonNotAvailTabDataGridLoad()	
		}else{
			$.messager.alert("提示","更新失败!")
			return false;
		}
	})
}
function ClearData(){
	$("#code").val("")
	$("#name").val("")
	$("#StartDate").datebox('setValue',"")
	$("#EndDate").datebox('setValue',"")
}
function CheckData(){
	var Code=$("#code").val()
	var Name=$("#name").val()
	var StDate=$HUI.datebox("#StartDate").getValue()
	if(Code==""){$.messager.alert("提示","请输入代码!");return false;}
	if(Name==""){$.messager.alert("提示","请输入原因!");return false;}
	if(StDate==""){$.messager.alert("提示","请输入生效日期!");return false;}
	return true;
}
function DHCStringToXml(Key,Value){
	return "<"+Key+">"+Value+"</"+Key+">"
}
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (ServerObj.sysDateFormat=="3") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (ServerObj.sysDateFormat=="4") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function myparser(s){
    if (!s) return new Date();
    if(ServerObj.sysDateFormat=="4"){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}else{
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}