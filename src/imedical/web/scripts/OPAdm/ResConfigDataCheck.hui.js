var PageLogicObj={
	m_ResConfDataCheckTabDataGrid:"",
	m_selLocId:"",
	m_selMarkId:""
};
$(function(){
	var hospComp = GenUserHospComp();
	hospComp.jdata.options.onSelect = function(e,t){
		PageLogicObj.m_selLocId="",PageLogicObj.m_selMarkId="";
		$("#Dept,#Mark").lookup('setText','');
		$("#StartDate,#EndDate").datebox('setValue',"");
		ResConfDataCheckTabDataGridLoad();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		//初始化
		Init();
		//表格数据初始化
		ResConfDataCheckTabDataGridLoad();
	}
	//事件初始化
	InitEvent();
});
function Init(){
	InitDeptLookup();
	InitMarkLookup();
	PageLogicObj.m_ResConfDataCheckTabDataGrid=InitResConfDataCheckTabDataGrid();
}
function InitEvent(){
	$('#BFind').click(ResConfDataCheckTabDataGridLoad);
}
function InitResConfDataCheckTabDataGrid(){
	var toobar=[{
        text: '导出',
        iconCls: 'icon-export',
        handler: function() {ExportExcel();}
    }];
	var Columns=[[ 
		{field:'LocDesc',title:'科室',width:150},
		{field:'MarkDdesc',title:'号别',width:150},
		{field:'chkMsg',title:'监测结果',width:400}
    ]]
	var ResConfDataCheckTabDataGrid=$("#ResConfDataCheckTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 15,
		pageList : [15,100,200],
		idField:'ResRowId',
		columns :Columns,
		toolbar:toobar
	}).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter});
	return ResConfDataCheckTabDataGrid;
}
function ResConfDataCheckTabDataGridLoad(){
	var StartDate=$HUI.datebox("#StartDate").getValue();
	var EndDate=$HUI.datebox("#EndDate").getValue();
	$.q({
	    ClassName : "web.DHCDocRegConfigDataCheck",
	    QueryName : "ResConfigDataCheck",
	    StartDate:StartDate,
	    EndDate:EndDate,
	    LocId:GetSelLocId(),
	    MarkId:GetSelMarkId(),
	    HospID:$HUI.combogrid('#_HospUserList').getValue(),
	    Pagerows:PageLogicObj.m_ResConfDataCheckTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_ResConfDataCheckTabDataGrid.datagrid('loadData',GridData);
	});
}
function InitDeptLookup(){
	//科室
	$("#Dept").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'id',
        textField:'name',
        columns:[[  
            {field:'id',title:'ID'},
			{field:'name',title:'科室',width:330}
        ]], 
        pagination:true,
        panelWidth:400,
        panelHeight:410,
        isCombo:true,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'DHCDoc.DHCDocConfig.CommonFunction',QueryName: 'QueryLoc'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        param = $.extend(param,{depname:desc,LogHospId:$HUI.combogrid('#_HospUserList').getValue()});
	    },
	    onSelect:function(index, rec){
		    setTimeout(function(){
				if (rec!=undefined){
					PageLogicObj.m_selLocId=rec["id"];
					PageLogicObj.m_selMarkId="";
					$("#Mark").lookup('setText',"");
					ResConfDataCheckTabDataGridLoad();
				}
			});
		}
    });
}
function InitMarkLookup(){
	//号别
	$("#Mark").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'RowID',
        textField:'Desc',
        columns:[[  
            {field:'RowID',title:'ID'},
			{field:'Desc',title:'号别',width:330}
        ]], 
        pagination:true,
        panelWidth:400,
        panelHeight:410,
        isCombo:true,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCExaBorough',QueryName: 'FindDoc'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        param = $.extend(param,{depid:GetSelLocId(),docname:desc});
	    },
	    onSelect:function(index, rec){
		    setTimeout(function(){
				if (rec!=undefined){
					PageLogicObj.m_selMarkId=rec["RowID"];
					ResConfDataCheckTabDataGridLoad();
				}
			});
		}
    });
}
function GetSelLocId(){
	var LocDesc=$("#Dept").lookup("getText");
    if (LocDesc=="") {
	    PageLogicObj.m_selLocId="";
    }
    return PageLogicObj.m_selLocId;
}
function GetSelMarkId(){
	var MarkDesc=$("#Mark").lookup("getText");
    if (MarkDesc=="") {
	    PageLogicObj.m_selMarkId="";
    }
    return PageLogicObj.m_selMarkId;
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
function ExportExcel(){
	var StartDate=$HUI.datebox("#StartDate").getValue();
	var EndDate=$HUI.datebox("#EndDate").getValue();
	var rtn = $cm({
		dataType:'text',
		ResultSetType:'Excel',
		ExcelName:'资源监测明细',
		ClassName:'web.DHCDocRegConfigDataCheck',
		QueryName:'ResConfigDataCheck',
		StartDate:StartDate,
	    EndDate:EndDate,
	    LocId:GetSelLocId(),
	    MarkId:GetSelMarkId(),
	    HospID:$HUI.combogrid('#_HospUserList').getValue()
	}, false);
	location.href = rtn;
}