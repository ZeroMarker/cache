var PageLogicObj={
	m_RegHandleInHisTabDataGrid:""
};
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
	//表格数据初始化
	RegHandleInHisTabDataGridLoad();
});
function Init(){
	PageLogicObj.m_RegHandleInHisTabDataGrid=InitRegHandleInHisTabDataGrid();
}
function InitRegHandleInHisTabDataGrid(){
	var Columns=[[ 
		{field:'TID',title:'系统号',width:100,
			formatter: function(value,row,index){
				var btn = '<a class="editcls" onclick="BRegHaninDetails(\'' + row["TID"] + '\')">'+value+'</a>';
				return btn;
			}
		},
		{field:'THandInDate',title:'结算日期',width:100},
		{field:'THandInTime',title:'结算时间',width:100},
		{field:'TAmount',title:'挂号总金额',width:100,align:'right'},
		{field:'TRegTotal',title:'挂号总数',width:90}
    ]]
	var RegHandleInHisTabDataGrid=$("#RegHandleInHisTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		rownumbers:true,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 30,
		pageList : [30,100,200],
		idField:'TUserID',
		columns :Columns
	});
	return RegHandleInHisTabDataGrid;
}
function InitEvent(){
	$('#BFind').click(RegHandleInHisTabDataGridLoad);
}
function PageHandle(){
	$("#StDate,#EndDate").datebox('setValue',ServerObj.CurDay);
}
function RegHandleInHisTabDataGridLoad(){
	$.q({
	    ClassName : "web.UDHCJFOPHandinReg11",
	    QueryName : "QueryHandinRegHis",
	    StDate:$("#StDate").datebox('getValue'), EndDate:$("#EndDate").datebox('getValue'),
	    UserID:session['LOGON.USERID'],
	    Pagerows:PageLogicObj.m_RegHandleInHisTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_RegHandleInHisTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
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
function BRegHaninDetails(TID){
	var src="opadm.reghandin.hui.csp?RepID="+TID;
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("Project","挂号员日结账明细", '650', '630',"icon-w-list","",$code,"");
}
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content,
        onClose:function(){
	        destroyDialog(id);
	    },
	    onBeforeOpen:function(){
		    if (_event!="") eval(_event);
		    return true;
		}
    });
}
function destroyDialog(id){
   //移除存在的Dialog
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}