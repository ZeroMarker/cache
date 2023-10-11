var PageLogicObj={
	m_ScheduleAdjustListTabDataGrid:""
};
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
});
function InitEvent(){
	$("#BAdjust").click(AdjustClick);
	$("#BDel").click(DelClick);
}
function PageHandle(){
	ScheduleAdjustListTabDataGridLoad();
}
function Init(){
	//初始化医院
	var hospComp = GenUserHospComp();
	hospComp.jdata.options.onSelect = function(e,t){
		var HospID=t.HOSPRowId;
		ScheduleAdjustListTabDataGridLoad();
	}
	PageLogicObj.m_ScheduleAdjustListTabDataGrid=InitScheduleAdjustListTabDataGrid();
}
function InitScheduleAdjustListTabDataGrid(){
	var Columns=[[ 
		{field:'TOriginalDate',title:'原出诊日期',width:100},
		{field:'TAdjustDate',title:'迁移至日期',width:100},
		{field:'LogInfo',title:'迁移结果',width:300},
		
		{field:'UpdateDate',title:'更新日期',width:100},
		{field:'UpdateTime',title:'更新时间',width:100},
		{field:'UserName',title:'操作人',width:100},
		{field:'HospitalDesc',title:'医院',width:260},
    ]]
	var ScheduleAdjustListTabDataGrid=$("#ScheduleAdjustListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		rownumbers:true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 15,
		pageList : [15,100,200],
		idField:'LocId',
		columns :Columns,
		onSelect:function(index, row){
		},
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_ScheduleAdjustListTabDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_ScheduleAdjustListTabDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_ScheduleAdjustListTabDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		}
	});
	return ScheduleAdjustListTabDataGrid;
}
function AdjustClick(){
	if ($("#BAdjust").hasClass('l-btn-disabled')){
		return false;
	}
	DisableBtn("BAdjust",true);
	var HospID=$HUI.combogrid('#_HospUserList').getValue();
	var userid=session['LOGON.USERID'];	
	var groupid=session['LOGON.GROUPID'];	
	var ctlocid=session['LOGON.CTLOCID'];
	var OriginalDate=$("#OriginalDate").datebox('getValue');
	if (OriginalDate=="") {
		$.messager.alert("提示","请选择<i>原出诊日期</i>!");
		DisableBtn("BAdjust",false);
		return false;
	}
	var AdjustDate=$("#AdjustDate").datebox('getValue');
	if (AdjustDate=="") {
		$.messager.alert("提示","请选择迁移日期!");
		DisableBtn("BAdjust",false);
		return false;
	}
	$.messager.prompt("提示", "本操作会<b>原出诊日期</b>排班数据复制至<b>迁移日期</b>,并将<b>原出诊日期</b>排班删除,请输入<b>确认迁移</b>以继续该操作!", function (r) {
		if (r=="确认迁移") {
			
			$.cm({
				ClassName:"web.DHCOPRegHolidayAdjust",
				MethodName:"AdjustHoliday",
				OriginalDate:OriginalDate, AdjustDate:AdjustDate,HospitalDr:HospID,
				SessionStr:GetSessionStr?GetSessionStr():(session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']),
				dataType:'text'
			},function(rtn){
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="0"){
					$.messager.alert("提示",rtnArr[1],"info",function(){
						ScheduleAdjustListTabDataGridLoad();
					});
				}else{
					$.messager.alert("提示","调整失败!:"+rtn.split("^")[1]);
				}
				DisableBtn("BAdjust",false);
			})
		} else {
			$.messager.popover({ msg: "操作取消" });
			DisableBtn("BAdjust",false);
		}
	});
}
function DelClick(){
	var row=PageLogicObj.m_ScheduleAdjustListTabDataGrid.datagrid("getSelected");
	if (!row){
		$.messager.alert("提示","请选择需要删除的行!");
		return false;
	}
	var HospID=$HUI.combogrid('#_HospUserList').getValue();
	var OriginalDate=row['TOriginalDate'];
	$.cm({
		ClassName:"web.DHCOPRegHolidayAdjust",
		MethodName:"DelAdjustHoliday",
		OriginalDate:OriginalDate,
		HospitalDr:HospID,
		dataType:'text'
	},function(rtn){
		if(rtn=="0"){
			$.messager.alert("提示","删除成功!","info",function(){
				ScheduleAdjustListTabDataGridLoad();
			});
		}else{
			$.messager.alert("提示","删除失败!");
		}
	})
}
function ScheduleAdjustListTabDataGridLoad(){
	var HospID=$HUI.combogrid('#_HospUserList').getValue();
	$.q({
	    ClassName : "web.DHCOPRegHolidayAdjust",
	    QueryName : "FindAdjustDate",
	    HospitalDr : HospID,
	    Pagerows:PageLogicObj.m_ScheduleAdjustListTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_ScheduleAdjustListTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
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
function DisableBtn(id,disabled){
	if (disabled){
		$HUI.linkbutton("#"+id).disable();
	}else{
		$HUI.linkbutton("#"+id).enable();
	}
}
