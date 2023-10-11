var PageLogicObj={
	m_tabDHCApptScheduleUpdateLogGrid:""
};
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//表格数据初始化
	PageHandle()
});
function Init(){
	PageLogicObj.m_tabDHCApptScheduleUpdateLogGrid=LoadtabDHCApptScheduleUpdateLog();
}
function InitEvent(){
	$("#BFind").click(function(){LoadStatisticsAppRegNumber("");})
}
function PageHandle(){
	LoadStatisticsAppRegNumber(ServerObj.vRBASID)
	LoadLoc();
}
function LoadtabDHCApptScheduleUpdateLog(){
	var DHCApptScheduleUpdateLoNumber=[[
		{field:'UpdateRBAS',title:'排班ID',width:90},
		{field:'DepName',title:'科室',width:110},
		{field:'DoctorName',title:'医生',width:100},
    	{field:'UpdateType',title:'更新类型',width:80,
    		formatter: function(value,row,index){
				if (value=="A"){
					var btn = '<img src="../scripts_lib/hisui-0.1.0/dist/css/icons/add.png"/><span style="vertical-align:top;padding-left:5px;">新增</span>';
				}else if (value=="U"){
					var btn = '<img src="../scripts_lib/hisui-0.1.0/dist/css/icons/pencil.png"/><span style="vertical-align:top;padding-left:5px;">修改</span>';
				}else if (value=="D"){
					var btn = '<img src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png"/><span style="vertical-align:top;padding-left:5px;">删除</span>';
				}
				return btn;
			}
    	},
    	{field:'UpdateNotes',title:'更新日志',fitColumns:true},
    	{field:'UpdateDateN',title:'更新日期',width:100},
    	{field:'UpdateTime',title:'更新时间',width:100},
    	{field:'UpdateUser',title:'更新人',width:100}
    ]];
	var DHCApptScheduleUpdateLogGrid=$('#tabDHCApptScheduleUpdateLog').datagrid({    
	    idField:'id',    
	    //treeField:'LocDesc',    
        fit:true,               //网格自动撑满
        //fitColumns:true, 
        //toolbar :ToolBar, 
        remoteSort:false,  
        pagination:true,
        pageSize: 15,
		pageList : [15,50,200],
	    columns:DHCApptScheduleUpdateLoNumber,
	    singleSelect:true,
	    onClickRow:function (row){
		    return false;
		}
	});
	return DHCApptScheduleUpdateLogGrid;  
}
function LoadStatisticsAppRegNumber(ASRowid){
	var startdate=$HUI.datebox("#StartDate").getValue();
	var enddate=$HUI.datebox("#EndDate").getValue();
	var ComboLoc=$('#Combo_Loc').combobox('getValue');
	if (ComboLoc==undefined) ComboLoc="";
	var ComboDoc=$('#Combo_Doc').combobox('getValue');
	if (ComboDoc==undefined) ComboDoc="";
	var SelRBASFlag=""
	var SelRBAS=$("#SelRBASFlag").prop("checked");
	if(SelRBAS) SelRBASFlag="on"
	$.q({
	    ClassName : "web.DHCRBApptScheduleUpdateLog",
	    QueryName : "QueryRBASULog",
	    CTlocID:ComboLoc, CTPCPID:ComboDoc, 
	    StartDate:startdate,  EndDate:enddate,SelRBASFlag:SelRBASFlag,vRBASID:ASRowid,HospID:ServerObj.HospID,
	    Pagerows:PageLogicObj.m_tabDHCApptScheduleUpdateLogGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_tabDHCApptScheduleUpdateLogGrid.datagrid('unselectAll');
		PageLogicObj.m_tabDHCApptScheduleUpdateLogGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
	}
function LoadLoc(){
	var HospitalDr="";
	if (websys_showModal('options').GetHospId) {
		HospitalDr=websys_showModal('options').GetHospId();
	}
	$.q({
		ClassName:"web.DHCRBResSession",
		QueryName:"FindLoc",
		Loc:"",
		UserID:session['LOGON.USERID'],
		HospitalDr:HospitalDr,
		rows: 9999
	},function(Data){
		var cbox = $HUI.combobox("#Combo_Loc", {
				valueField: 'Hidden',
				textField: 'Desc', 
				editable:true,
				data: Data['rows'],
				filter: function(q, row){
					if (q=="") return true; 
					q=q.toUpperCase();
					if ((row["Code"].toUpperCase().indexOf(q)>=0)||(row["Alias"].toUpperCase().indexOf(q)>=0)||(row["Desc"].toUpperCase().indexOf(q)>=0)) return true;
				},
				onSelect:function(rec){
					if (rec){
						LoadDoc(rec['Hidden']);
					}
				},
				onChange:function(newValue,oldValue){
					if (newValue==""){
						$("#Doc").combobox('select','');
						$("#Doc").combobox('loadData',[{}])
					}
				}
		 });
	});
}
function LoadDoc(DepRowId){
	var HospitalDr="";
	if (websys_showModal('options').GetHospId) {
		HospitalDr=websys_showModal('options').GetHospId();
	}
	$.q({
		ClassName:"web.DHCRBResSession",
		QueryName:"FindResDoc",
		DepID:DepRowId,
		HospID:HospitalDr
	},function(Data){
		var cbox = $HUI.combobox("#Combo_Doc", {
				valueField: 'Hidden1',
				textField: 'Desc', 
				editable:true,
				data: Data['rows'],
				filter: function(q, row){
					if (q=="") return true; 
					q=q.toUpperCase();
					if ((row["Code"].toUpperCase().indexOf(q)>=0)||(row["Hidden2"].toUpperCase().indexOf(q)>=0)||(row["Desc"].toUpperCase().indexOf(q)>=0)) return true;
				},
				onSelect:function(){
				}
		 });
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