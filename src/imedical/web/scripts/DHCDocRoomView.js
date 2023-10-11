var PageLogicObj={
	m_ScheduleListDataGrid:"",
	m_selZoonRowId:"",
	m_selLocRowId:"",
	m_selDocRowId:""
};
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
});
function Init(){
	PageLogicObj.m_ScheduleListDataGrid=InitScheduleList();
}
function InitEvent(){
	$("#BFind").click(LoadScheduleListGrid);
}
function PageHandle(){
	//诊区
	InitZone();
	//科室
	InitDept();
	//医生
	InitDoc();
	//时段
	InitTimeRange();
	$("#StartDate").datebox("setValue",ServerObj.CurrDate.split("^")[1])
	$("#EndDate").datebox("setValue",ServerObj.CurrDate.split("^")[1])
}
function InitScheduleList(){
	var ScheduleListColumns=[[    
            { field : 'ASRowId',title : '',width : 1,hidden:true  },
            { field: 'ASDate', title: '出诊日期', width: 200,sortable: true, resizable: true},
			{ field: 'ASRoom', title: '诊室名称', width: 200,sortable: true, resizable: true},
			{ field : 'LocDesc',title : '科室',width : 200 ,sortable: true, resizable: true},
            { field : 'DocDesc',title : '医生',width : 200},
			{ field: 'TimeRange', title: '时段', width: 200,sortable: true, resizable: true}					
    	]];
	ScheduleListDataGrid=$("#tabScheduleList").datagrid({  
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 15,
		pageList : [15,100,200],
		idField:'ASRowId',
		remoteSort:false,
		columns :ScheduleListColumns,
		onDblClickRow:function(index, row){
			onDblClickRow(row);
		}
	});
	ScheduleListDataGrid.datagrid('loadData', {"total":0,"rows":[]});
	return ScheduleListDataGrid;
}
function LoadScheduleListGrid(){
	var zoonDesc=$("#Combo_Zone").combobox('getText');
    if (zoonDesc==""){PageLogicObj.m_selZoonRowId=""};
    var locDesc=$("#Combo_Loc").lookup('getText');
    if (locDesc==""){PageLogicObj.m_selLocRowId=""};
    var docDesc=$("#Combo_Doc").lookup('getText');
    if (docDesc==""){PageLogicObj.m_selDocRowId=""};
    var StartDate=$("#StartDate").datebox("getValue")
	var EndDate=$("#EndDate").datebox("getValue")
	$.q({
	    ClassName : "web.DHCApptScheduleNew",
	    QueryName : "GetApptSchedule",
	    Loc:PageLogicObj.m_selLocRowId, Doc:PageLogicObj.m_selDocRowId, StDate:StartDate, 
	    EnDate:EndDate, userid:"", groupid:"", ResID:"", ExaID:PageLogicObj.m_selZoonRowId,
	    paraTimeRange:$("#Combo_TimeRange").combobox('getValue'), Type:1,
	    Pagerows:PageLogicObj.m_ScheduleListDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_ScheduleListDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function InitZone(){
	$.cm({
		ClassName:"web.DHCAlloc",
		QueryName:"QueryExaborough",
		UserId:session['LOGON.USERCODE'],
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#Combo_Zone", {
				valueField: 'HIDDEN',
				textField: 'exabname', 
				editable:true,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["exabname"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},onSelect:function(record){
					PageLogicObj.m_selZoonRowId=record['HIDDEN'];
					$("#Combo_Loc,#Combo_Doc").lookup('setText','');
					PageLogicObj.m_selLocRowId="";
					PageLogicObj.m_selDocRowId="";
				},onLoadSuccess:function(){
					if (GridData["rows"].length>0){
						var DefaultZoneID="";
						for (var i=0;i<GridData["rows"].length;i++){
							if (GridData["rows"][i]["isDefault"]=="true"){
								DefaultZoneID=GridData["rows"][i]["HIDDEN"];
								break;
							}
						}
						if (DefaultZoneID!=""){
							$("#Combo_Zone").combobox('select',DefaultZoneID);
						}else{
							$("#Combo_Zone").combobox('select',GridData["rows"][0]["HIDDEN"]);
						}
					}
				
			},
		 });
	})
}
function InitDept(){
	$("#Combo_Loc").lookup({
	    url:$URL,
	    mode:'remote',
	    method:"Get",
	    idField:'LocId',
	    textField:'LocDesc',
	    columns:[[  
	        {field:'LocId',title:'',hidden:true},
			{field:'LocDesc',title:'科室',width:350}
	    ]], 
	    pagination:true,
	    panelWidth:400,
	    panelHeight:400,
	    isCombo:true,
	    //minQueryLen:2,
	    delay:'500',
	    queryOnSameQueryString:true,
	    queryParams:{ClassName: 'web.DHCAlloc',QueryName: 'FindLocListByBor'},
	    onBeforeLoad:function(param){
	        var desc=param['q']; 
	        var zoonDesc=$("#Combo_Zone").combobox('getText');
	        if (zoonDesc==""){PageLogicObj.m_selZoonRowId=""};
			param = $.extend(param,{UserId:session['LOGON.USERID'],Zone:PageLogicObj.m_selZoonRowId,desc:desc});
	    },
	    onSelect:function(index, rec){
		    PageLogicObj.m_selLocRowId=rec['LocId'];
		    $("#Combo_Doc").lookup('setText','');
		    PageLogicObj.m_selDocRowId="";
		}
	});
}
function InitDoc(){
	$("#Combo_Doc").lookup({
	    url:$URL,
	    mode:'remote',
	    method:"Get",
	    idField:'DocId',
	    textField:'DocDesc',
	    columns:[[  
	        {field:'DocId',title:'',hidden:true},
			{field:'DocDesc',title:'名称',width:350}
	    ]], 
	    pagination:true,
	    panelWidth:400,
	    panelHeight:400,
	    isCombo:true,
	    //minQueryLen:2,
	    delay:'500',
	    queryOnSameQueryString:true,
	    queryParams:{ClassName: 'web.DHCAlloc',QueryName: 'FindDocListByBor'},
	    onBeforeLoad:function(param){
	        var desc=param['q']; 
	        var zoonDesc=$("#Combo_Zone").combobox('getText');
	        if (zoonDesc==""){PageLogicObj.m_selZoonRowId=""};
	        var locDesc=$("#Combo_Loc").lookup('getText');
	        if (locDesc==""){PageLogicObj.m_selLocRowId=""};
			param = $.extend(param,{UserId:session['LOGON.USERID'],Zone:PageLogicObj.m_selZoonRowId,LocId:PageLogicObj.m_selLocRowId,desc:desc});
	    },
	    onSelect:function(index, rec){
		    PageLogicObj.m_selDocRowId=rec['DocId'];
		}
	});
}
function InitTimeRange(){
	$.cm({
		ClassName:"web.DHCApptScheduleNew",
		QueryName:"LookUpTimeRange",
		date:ServerObj.CurrDate.split("^")[0],
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#Combo_TimeRange", {
				valueField: 'RowId',
				textField: 'Desc', 
				editable:true,
				data: GridData["rows"],
				onLoadSuccess:function(){
					LoadScheduleListGrid()
					}
				
		 });
	});
}