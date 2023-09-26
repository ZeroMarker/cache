var PageLogicObj={
	m_CardInvReptsTabDataGrid:""
};
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
	//表格数据初始化
	CardInvReptsTabDataGridLoad();
});
function Init(){
	PageLogicObj.m_CardInvReptsTabDataGrid=InitCardInvReptsTabDataGrid();
}
function InitCardInvReptsTabDataGrid(){
	var Columns=[[ 
		{field:'TUserCode',title:'收费员代码',width:100,
			formatter: function(value,row,index){
				var btn = '<a class="editcls" onclick="BCardInvDetails(\'' + row["TUserID"] + '\')">'+value+'</a>';
				return btn;
			}
		},
		{field:'TUserName',title:'收费员',width:100},
		{field:'TIssueCardNum',title:'发卡张数',width:100},
		{field:'TIssueCardAmt',title:'发卡金额',width:100,align:'right'},
		{field:'TReclaimCardNum',title:'退卡张数',width:90},
		{field:'TReclaimCardAmt',title:'退卡金额',width:90,align:'right'},
		{field:'TCardNum',title:'实际发卡张数',width:150},
		{field:'TCardAmt',title:'实际收款金额',width:180,align:'right'},
		{field:'TExChangeNum',title:'换卡数量',width:100,
			formatter: function(value,row,index){
				var btn = '<a class="editcls" onclick="BCardExChangeDetails(\'' + row["TUserID"] + '\')">'+value+'</a>';
				return btn;
			}
		}, 
		{field:'TReNewNum',title:'补卡数量',width:100},
		{field:'TReNewAmt',title:'补卡金额',width:100,align:'right'}
    ]]
	var CardInvReptsTabDataGrid=$("#CardInvReptsTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 30,
		pageList : [30,100,200],
		idField:'TUserID',
		columns :Columns
	});
	return CardInvReptsTabDataGrid;
}
function InitEvent(){
	$('#BFind').click(CardInvReptsTabDataGridLoad);
	$('#BFindDetails').click(function(){BCardInvDetails(session['LOGON.USERID'],ServerObj.OwnFlag)}); 
	$('#BImportData').click(BImportDataClickHandle);
}
function PageHandle(){
	if (ServerObj.OwnFlag==0){
		$("#pagetitle").panel('setTitle','卡费用日报汇总')
	}
	//$("#StDate,#EndDate").datebox('setValue',ServerObj.CurDay);
}
function CardInvReptsTabDataGridLoad(){
	$.q({
	    ClassName : "web.UDHCJFOPCardInvRepts",
	    QueryName : "CardInvRept",
	    StartDate:$("#StDate").datebox('getValue'), EndDate:$("#EndDate").datebox('getValue'),
	    OwnFlag:ServerObj.OwnFlag, UserID:session['LOGON.USERID'], HandinFlag:ServerObj.HandinFlag,
	    Pagerows:PageLogicObj.m_CardInvReptsTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_CardInvReptsTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
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
function BCardInvDetails(TUserID,ownflag){
	if (ownflag==undefined) ownflag=1 //ServerObj.OwnFlag;
	var $code='<div style="border:1px solid #ccc;margin:10px;border-radius:4px;"><table id="CardInvDetailsGrid"></table></div>'
	createModalDialog("Grid","挂号员卡费用日报明细", 900, 520,"icon-w-list","",$code,"LoadCardInvDetailsGrid('"+TUserID+"','"+ownflag+"')");
}
function BCardExChangeDetails(TUserID){
	var $code='<div style="border:1px solid #ccc;margin:10px;border-radius:4px;"><table id="CardExChangeDetailsGrid"></table></div>'
	createModalDialog("Grid","换卡明细", 700, 520,"icon-w-list","",$code,"LoadCardExChangeDetailsGrid('"+TUserID+"')");
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
function LoadCardInvDetailsGrid(TUserID,ownflag){
	var Columns=[[    
		{field:'TUserCode',title:'收费员代码',width:100,}, 
		{field:'TUserName',title:'收费员',width:100},
		{field:'TInvFlag',title:'收款类型',width:80},
		{field:'TCardAmt',title:'金额',width:70,align:'right'},
		{field:'TCardNo',title:'卡号',width:150},
		{field:'TPatName',title:'姓名',width:100},  
		{field:'TDate',title:'日期',width:100},   
		{field:'TTime',title:'时间',width:100}
    ]];
	$.q({
	    ClassName:"web.UDHCJFOPCardInvRepts",
	    QueryName:"CardInvDetails",
	    StartDate:$("#StDate").datebox('getValue'), EndDate:$("#EndDate").datebox('getValue'), 
	    OwnFlag:ownflag, UserID:TUserID, HandinFlag:ServerObj.HandinFlag,
	    rows:99999
	},function(GridData){
		$HUI.datagrid('#CardInvDetailsGrid',{
		    data:GridData,
		    idField:'TID',
		    fit : false,
		    width:870,
		    height:460,
		    border: false,
		    columns:Columns
		});
	});
}
function LoadCardExChangeDetailsGrid(TUserID){
	var Columns=[[    
		{field:'TCardNo',title:'原卡号',width:150,}, 
		{field:'TPatName',title:'患者姓名',width:80},
		{field:'TUserId',title:'操作员',width:80},
		{field:'TCscDate',title:'更改日期',width:100},
		{field:'TCscTime',title:'更改时间',width:80}
    ]];
	$.q({
	    ClassName:"web.UDHCJFOPCardInvRepts",
	    QueryName:"FindCardStatus",
	    StartDate:$("#StDate").datebox('getValue'), EndDate:$("#EndDate").datebox('getValue'), 
	    Status:"ETD", UserID:TUserID,
	    rows:99999
	},function(GridData){
		$HUI.datagrid('#CardExChangeDetailsGrid',{
		    data:GridData,
		    idField:'TCardNo',
		    fit : false,
		    width:670,
		    height:460,
		    border: false,
		    columns:Columns
		});
	});
}
function BImportDataClickHandle(){
	var Templatefilepath=$.cm({
		ClassName:"web.UDHCJFCOMMON",
		MethodName:"getpath",
		dataType:"text"
	},false);
	Templatefilepath=Templatefilepath+'UDHCJFOPCardInvRepts.xls';			
	xlApp = new ActiveXObject("Excel.Application"); 
	xlBook = xlApp.Workbooks.Add(Templatefilepath); 
	xlsheet = xlBook.WorkSheets("Sheet1");
	var columnNumber=1;
	xlsheet.cells(2, columnNumber).value = "收费员代码";
	xlsheet.cells(2, columnNumber+1).value = "收费员";
	xlsheet.cells(2, columnNumber+2).value = "发卡张数";
	xlsheet.cells(2, columnNumber+3).value = "发卡金额";
	xlsheet.cells(2, columnNumber+4).value = "退卡张数";
	xlsheet.cells(2, columnNumber+5).value = "退卡金额";
	xlsheet.cells(2, columnNumber+6).value = "实际发卡张数";
	xlsheet.cells(2, columnNumber+7).value = "实际收款金额";
	xlsheet.cells(2, columnNumber+8).value = "换卡数量";
	xlsheet.cells(2, columnNumber+9).value = "补卡数量";
	xlsheet.cells(2, columnNumber+10).value = "补卡金额";
		
	var rows=PageLogicObj.m_CardInvReptsTabDataGrid.datagrid('getRows');
	for (var i=0;i<rows.length;i++){
		xlsheet.cells(i+3, columnNumber).value = rows[i]['TUserCode'];
		xlsheet.cells(i+3, columnNumber+1).value = rows[i]['TUserName'];
		xlsheet.cells(i+3, columnNumber+2).value = rows[i]['TIssueCardNum'];
		xlsheet.cells(i+3, columnNumber+3).value = rows[i]['TIssueCardAmt'];
		xlsheet.cells(i+3, columnNumber+4).value = rows[i]['TReclaimCardNum'];
		xlsheet.cells(i+3, columnNumber+5).value = rows[i]['TReclaimCardAmt'];
		xlsheet.cells(i+3, columnNumber+6).value = rows[i]['TCardNum'];
		xlsheet.cells(i+3, columnNumber+7).value = rows[i]['TCardAmt'];
		xlsheet.cells(i+3, columnNumber+8).value = rows[i]['TExChangeNum'];
		xlsheet.cells(i+3, columnNumber+9).value = rows[i]['TReNewNum'];
		xlsheet.cells(i+3, columnNumber+10).value = rows[i]['TReNewAmt'];
	}
	xlsheet.printout;
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null;
	//idTmr   =   window.setInterval("Cleanup();",1); 
}