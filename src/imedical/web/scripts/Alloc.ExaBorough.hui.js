var PageLogicObj={
	m_ExaBoroughTabDataGrid:""
};
$(function(){
	//初始化
	Init();
	//加载分诊区表格数据
	ExaBoroughTabDataGridLoad();
});
$(window).load(function() {
	InitPopover();
})
function Init(){
	var hospComp = GenHospComp("DHCExaBorough");
	hospComp.jdata.options.onSelect = function(e,t){
		var HospID=t.HOSPRowId;
		ExaBoroughTabDataGridLoad();
		ClearData();
	}
	PageLogicObj.m_ExaBoroughTabDataGrid=InitExaBoroughTabDataGrid();
}
function InitExaBoroughTabDataGrid(){
	var toobar=[{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() {AddClickHandle(); }
    }, {
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() {DelClickHandle();}
    }, {
        text: '保存',
        iconCls: 'icon-save',
        handler: function() { UpdateClickHandle();}
    }];
	var Columns=[[ 
		{field:'Tid',hidden:true,title:''},
		{field:'Tcode',title:'代码',width:200},
		{field:'Tname',title:'名称',width:200},
		{field:'Tmemo',title:'备注',width:200},
		{field:'TCheckin',title:'是否报到',width:90},
		{field:'TAutoCheckin',title:'是否查询后自动报到',width:150},
		{field:'TFristReson',title:'是否需要填写优先原因',width:150},
		{field:'TNoCheckinDocCanRecAdm',title:'未报到可就诊',width:100},
		{field:'TCreatQueueNo',title:'报到产生队列号',width:100},
		{field:'TDelayQueueNo',title:'报到迟到惩罚',width:100},
		{field:'TCallDelayQueueNo',title:'过号惩罚',width:100},
		{field:'TCallFilePath',title:'呼叫目录',width:200},
		{field:'TWaitFilePath',title:'等候目录',width:200},
		{field:'THospital',title:'医院',width:300}
    ]]
	var ExaBoroughTabDataGrid=$("#ExaBoroughTab").datagrid({
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
		idField:'Tid',
		columns :Columns,
		toolbar:toobar,
		onCheck:function(index, row){
			SetSelRowData(row);
		},
		onUnselect:function(index, row){
			ClearData();
		},
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_ExaBoroughTabDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_ExaBoroughTabDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_ExaBoroughTabDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		}
	}); 
	return ExaBoroughTabDataGrid;
}
function SetSelRowData(row){
	$("#code").val(row["Tcode"]);
	$("#name").val(row["Tname"]);
	$("#memo").val(row["Tmemo"]);
	$("#CallFilePath").val(row["TCallFilePath"]);
	$("#WaitFilePath").val(row["TWaitFilePath"]);
	$("#FristReson").checkbox('setValue',row["TFristReson"]=="Y"?true:false);
	$("#Checkin").checkbox('setValue',row["TCheckin"]=="Y"?true:false);
	$("#AutoReportCheckin").checkbox('setValue',row["TAutoCheckin"]=="Y"?true:false);
	$("#NoCheckinDocCanRecAdm").checkbox('setValue',row["TNoCheckinDocCanRecAdm"]=="Y"?true:false);
	$("#CreatQueueNo").checkbox('setValue',row["TCreatQueueNo"]=="Y"?true:false);
	$("#DelayQueueNo").checkbox('setValue',row["TDelayQueueNo"]=="Y"?true:false);
	$("#CallDelayQueueNo").checkbox('setValue',row["TCallDelayQueueNo"]=="Y"?true:false);
}
function AddClickHandle(){
	if (!CheckDataValid()) return false;
	var code=$("#code").val();
	var name=$("#name").val();
	var memo=$("#memo").val();
	var CallFilePath=$("#CallFilePath").val();
	var WaitFilePath=$("#WaitFilePath").val();
	var Checkin=$("#Checkin").checkbox('getValue')?"Y":"N";
	var ExabAutoReport=$("#AutoReportCheckin").checkbox('getValue')?"Y":"N";
	var FristReson=$("#FristReson").checkbox('getValue')?"Y":"N";
	var NoCheckinDocCanRecAdm=$("#NoCheckinDocCanRecAdm").checkbox('getValue')?"Y":"N";
	var CreatQueueNo=$("#CreatQueueNo").checkbox('getValue')?"Y":"N";
	var DelayQueueNo=$("#DelayQueueNo").checkbox('getValue')?"Y":"N";
	var CallDelayQueueNo=$("#CallDelayQueueNo").checkbox('getValue')?"Y":"N";
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var OtherStr=CreatQueueNo+"^"+DelayQueueNo+"^"+CallDelayQueueNo+"^"+HospID
	$.cm({
		ClassName:"web.DHCExaBorough",
		MethodName:"insertExaB",
		itmjs:"",
		itmjsex:"",
		code:code,
		name:name,
		memo:memo,
		Checkin:Checkin,
		ExabSubCallFilePath:CallFilePath,
		ExabSubWaitFilePath:WaitFilePath,
		ExabAutoReport:ExabAutoReport,
		FristReson:FristReson,
		NoCheckinDocCanRecAdm:NoCheckinDocCanRecAdm,
		OtherStr:OtherStr
	},function(rtn){
		if (rtn=="0"){
			$.messager.alert("提示","增加成功!");
			PageLogicObj.m_ExaBoroughTabDataGrid.datagrid('uncheckAll');
			ExaBoroughTabDataGridLoad();
			ClearData();
		}else{
			$.messager.alert("提示","增加失败!代码重复!");
			return false;
		}
	});
}
function UpdateClickHandle(){
	var row=PageLogicObj.m_ExaBoroughTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要更新的行!");
		return false;
	}
	if (!CheckDataValid()) return false;
	var code=$("#code").val();
	var name=$("#name").val();
	var memo=$("#memo").val();
	var CallFilePath=$("#CallFilePath").val();
	var WaitFilePath=$("#WaitFilePath").val();
	var Checkin=$("#Checkin").checkbox('getValue')?"Y":"N";
	var ExabAutoReport=$("#AutoReportCheckin").checkbox('getValue')?"Y":"N";
	var FristReson=$("#FristReson").checkbox('getValue')?"Y":"N";
	var NoCheckinDocCanRecAdm=$("#NoCheckinDocCanRecAdm").checkbox('getValue')?"Y":"N";
	var CreatQueueNo=$("#CreatQueueNo").checkbox('getValue')?"Y":"N";
	var DelayQueueNo=$("#DelayQueueNo").checkbox('getValue')?"Y":"N";
	var CallDelayQueueNo=$("#CallDelayQueueNo").checkbox('getValue')?"Y":"N";
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var OtherStr=CreatQueueNo+"^"+DelayQueueNo+"^"+CallDelayQueueNo+"^"+HospID
	$.cm({
		ClassName:"web.DHCExaBorough",
		MethodName:"updateExaB",
		itmjs:"",
		itmjsex:"",
		code:code,
		name:name,
		memo:memo,
		rowid:row["Tid"],
		Checkin:Checkin,
		ExabSubCallFilePath:CallFilePath,
		ExabSubWaitFilePath:WaitFilePath,
		ExabAutoReport:ExabAutoReport,
		ExabFristReson:FristReson,
		NoCheckinDocCanRecAdm:NoCheckinDocCanRecAdm,
		OtherStr:OtherStr,
		dataType:"text"
	},function(rtn){
		if (rtn=="0"){
			$.messager.popover({msg: '更新成功!',type:'success'});
			PageLogicObj.m_ExaBoroughTabDataGrid.datagrid('updateRow',{
				index: PageLogicObj.m_ExaBoroughTabDataGrid.datagrid("getRowIndex",row),
				row: {
					Tcode: code,
					Tname: name,
					Tmemo:memo,
					TCheckin: Checkin,
					TCallFilePath: CallFilePath,
					TWaitFilePath:WaitFilePath,
					TAutoCheckin:ExabAutoReport,
					TNoCheckinDocCanRecAdm:NoCheckinDocCanRecAdm,
					TFristReson:FristReson,
					TCreatQueueNo:CreatQueueNo,
					TDelayQueueNo:DelayQueueNo,
					TCallDelayQueueNo:CallDelayQueueNo
				}
			});
		}else{
			$.messager.alert("提示","更新失败!代码重复!");
			return false;
		}
	});
}
function DelClickHandle(){
	var row=PageLogicObj.m_ExaBoroughTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要删除的行!");
		return false;
	}
	$.cm({
		ClassName:"web.DHCExaBorough",
		MethodName:"delExaB",
		itmjs:"",
		itmjsex:"",
		rid:row["Tid"]
	},function(rtn){
		if (rtn=="0"){
			$.messager.alert("提示","删除成功!");
			ClearData();
			PageLogicObj.m_ExaBoroughTabDataGrid.datagrid('uncheckAll');
			ExaBoroughTabDataGridLoad();
		}else{
			$.messager.alert("提示","删除失败!"+rtn);
			return false;
		}
	});
}
function ClearData(){
	$("#code,#name,#memo,#CallFilePath,#WaitFilePath").val("");
	$("#Checkin,#AutoReportCheckin,#FristReson,#TNoCheckinDocCanRecAdm").checkbox('uncheck');
}
function CheckDataValid(){
	var code=$("#code").val();
	if (code==""){
		$.messager.alert("提示","请填写代码!","info",function(){$("#code").focus();});
		return false;
	}
	var name=$("#name").val();
	if (name==""){
		$.messager.alert("提示","请填写名称!","info",function(){$("#name").focus();});
		return false;
	}
	var HospID=$HUI.combogrid('#_HospList').getValue();
	if (HospID==""){
		$.messager.alert("提示","请选择医院!","info");
		return false;
	}
	return true;
}
function ExaBoroughTabDataGridLoad(){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$.q({
	    ClassName : "web.DHCExaBorough",
	    QueryName : "UFindExaBorough",
	    depid : "",
	    HospId :HospID,
	    Pagerows:PageLogicObj.m_ExaBoroughTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_ExaBoroughTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function InitPopover(){
	$("#DelayQueueNo").next().popover({
		title:'规则',
		style:'inverse',
		content:"在分时段的情况下,过了就诊时段报到患者为迟到患者，排在当前时段的最后一个。",
		placement:'bottom',
		trigger:'hover'
	});
	$("#CallDelayQueueNo").next().popover({
		title:'规则',
		width:'400px',
		height:'320px;',
		style:'inverse',
		content:"在分时段的情况下,第一次过号重新报到,排到当前时段的最后一个;第二次过号重新报到,排到当前时段的下一个时段的最后一个;第三次及以上过号重新报到,排到最后时段的最后一个。",
		placement:'auto-bottom',
		trigger:'hover'
	});
}