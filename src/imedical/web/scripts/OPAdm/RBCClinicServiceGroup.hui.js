var PageLogicObj={
	m_RBCClinicServiceGroupTabDataGrid:""
};
$(function(){
	var hospComp = GenUserHospComp();
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//表格数据初始化
	hospComp.jdata.options.onSelect = function(e,t){
		$("#code,#name").val("");
		$("#StartDate,#EndDate").datebox('setValue','');
		RBCClinicServiceGroupTabDataGridLoad();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		RBCClinicServiceGroupTabDataGridLoad();
	}
});
function Init(){
	PageLogicObj.m_RBCClinicServiceGroupTabDataGrid=InitRBCClinicServiceGroupTabDataGrid();
}
function InitRBCClinicServiceGroupTabDataGrid(){
	var toobar=[{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() {AddClickHandle(); }
    }, {
        text: '保存',
        iconCls: 'icon-save',
        handler: function() { UpdateClickHandle();}
    }, {
        text: '授权医院',
        iconCls: 'icon-house',
        handler: function() {
	        var row=PageLogicObj.m_RBCClinicServiceGroupTabDataGrid.datagrid('getSelected');
			if (!row){
				$.messager.alert("提示","请选择一行！")
				return false
			}
			GenHospWin("RBC_ClinicServiceGroup",row.ID);
	    }
    }];
    var Columns=[[ 
    	{field:'ID',hidden:true,title:''},
		{field:'CLSGRPCode',title:'代码',width:300},
		{field:'CLSGRPDesc',title:'名称',width:300},
		{field:'CLSGRPDateFrom',title:'开始日期',width:300},
		{field:'CLSGRPDateTo',title:'结束日期',width:300}
    ]];
    var RBCClinicServiceGroupTabDataGrid=$("#RBCClinicServiceGroupTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true, 
		idField:'ID', 
		pageSize: 20,
		pageList : [20,100,200],
		columns :Columns,
		toolbar:toobar,
		onCheck:function(index, row){
			SetSelRowData(row);
		},
		onUnselect:function(index, row){
			clear();
		},
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_RBCClinicServiceGroupTabDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_RBCClinicServiceGroupTabDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_RBCClinicServiceGroupTabDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		}
	}).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}); 
	return RBCClinicServiceGroupTabDataGrid;
}
function SetSelRowData(row){
	$("#code").val(row["CLSGRPCode"]);
	$("#name").val(row["CLSGRPDesc"]); 
	$HUI.datebox("#StartDate").setValue(row["CLSGRPDateFrom"]);
	$HUI.datebox("#EndDate").setValue(row["CLSGRPDateTo"]);
}
function InitEvent(){
	$('#Bfind').click(RBCClinicServiceGroupTabDataGridLoad);
}
function RBCClinicServiceGroupTabDataGridLoad(){
	var CLSGRPCode=$("#code").val();
	var CLSGRPDesc=$("#name").val();
	var HospID=$HUI.combogrid('#_HospUserList').getValue();
	$.q({
	    ClassName : "web.DHCRBCClinicServiceGroup",
	    QueryName : "GetAllClinicServiceGroupNew",
	    CLSGRPCode:CLSGRPCode,
	    CLSGRPDesc:CLSGRPDesc,
	    HospID:HospID,
	    Pagerows:PageLogicObj.m_RBCClinicServiceGroupTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_RBCClinicServiceGroupTabDataGrid.datagrid('unselectAll').datagrid('loadData',GridData);
	});
}
function AddClickHandle(){
	if(!CheckData()) return false;
	var Code=$("#code").val()
	var Name=$("#name").val()
	var StDate=$HUI.datebox("#StartDate").getValue()
	var EndDate=$HUI.datebox("#EndDate").getValue()
	var HospID=$HUI.combogrid('#_HospUserList').getValue();
	$.cm({
		ClassName:"web.DHCRBCClinicServiceGroup",
		MethodName:"InsertClinicServiceGroup",
		code:Code,
		name:Name,
		begindate:StDate,
		enddate:EndDate,
		HospID:HospID
	},function(rtn){
		if(rtn=="1"){
			$.messager.alert("提示","增加成功!")
			clear()
			RBCClinicServiceGroupTabDataGridLoad()
		}else if(rtn=="2"){
			$.messager.alert("提示","服务组代码重复!")
			return false
		}else{
			$.messager.alert("提示","增加失败!")
			return false
		}
	});
}
function UpdateClickHandle(){
	var row=PageLogicObj.m_RBCClinicServiceGroupTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择一行！")
		return false
	}
	if(!CheckData()) return false;
	var ID=row["ID"]
	var Code=$("#code").val()
	var Name=$("#name").val()
	var StDate=$HUI.datebox("#StartDate").getValue()
	var EndDate=$HUI.datebox("#EndDate").getValue()
	$.cm({
		ClassName:"web.DHCRBCClinicServiceGroup",
		MethodName:"UpdateClinicServiceGroup",
		id:ID,
		code:Code,
		name:Name,
		begindate:StDate,
		enddate:EndDate
	},function(rtn){
		if(rtn=="1"){
			$.messager.alert("提示","更新成功!")
			PageLogicObj.m_RBCClinicServiceGroupTabDataGrid.datagrid('updateRow',{
				index: PageLogicObj.m_RBCClinicServiceGroupTabDataGrid.datagrid("getRowIndex",row),
				row: {
					CLSGRPCode:Code,
					CLSGRPDesc:Name,
					CLSGRPDateFrom:StDate,
					CLSGRPDateTo:EndDate
				}
			});
		}else if(rtn=="2"){
			$.messager.alert("提示","服务组代码重复!")
			return false
		}else{
			$.messager.alert("提示","更新失败!")
			return false
		}
	});
	
}
function CheckData(){
	var Code=$("#code").val()
	var Name=$("#name").val()
	var StDate=$HUI.datebox("#StartDate").getValue()
	if(Code==""){$.messager.alert("提示","请输入代码!");return false;}
	if(Name==""){$.messager.alert("提示","请输入名称!");return false;}
	if(StDate==""){$.messager.alert("提示","请输入开始日期!");return false;}
	return true;
}
function clear(){
	$("#code").val("")
	$("#name").val("")
	$HUI.datebox("#StartDate").setValue("")
	$HUI.datebox("#EndDate").setValue("")
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