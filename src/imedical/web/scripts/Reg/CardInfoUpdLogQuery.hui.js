var PageLogicObj={
	m_CardInfoUpdLogTabDataGrid:""
};
$(function(){
	//初始化
	Init();
	//页面元素初始化
	PageHandle();
	//事件初始化
	InitEvent();
	//表格数据初始化
	CardInfoUpdLogTabDataGridLoad();
});
function Init(){
	PageLogicObj.m_CardInfoUpdLogTabDataGrid=InitCardInfoUpdLogTabDataGrid();
}
function PageHandle(){
	$("#StartDate,#EndDate").datebox('setValue',ServerObj.CurDate);
}
function InitCardInfoUpdLogTabDataGrid(){
	var Columns=[[ 
		{field:'TUPCardNo',title:'卡号',width:100},
		{field:'TUPRegNo',title:'登记号',width:100},
		{field:'TUPPAPERName',title:'原患者姓名	',width:130},
		{field:'TUPsPAPERName',title:'改后的患者姓名',width:130},
		{field:'TUPDate',title:'修改日期',width:100},
		{field:'TUPTime',title:'修改时间',width:80},
		{field:'TUPUserDr',title:'修改人',width:90},
		{field:'TUPCardInfo',title:'改动的其他卡信息'},
		{field:'TPoliticalLevel',title:'患者级别',width:80},
		{field:'TSecretLevel',title:'患者密级',width:80}
    ]]
	var CardInfoUpdLogTabDataGrid=$("#CardInfoUpdLogTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,
		rownumbers:true,  
		pageSize: 15,
		pageList : [15,100,200],
		idField:'TUPRegNo',
		columns :Columns
	});
	return CardInfoUpdLogTabDataGrid;
}
function InitEvent(){
	$('#BReadCard').click(ReadCardClickHandler);
	$('#BFind').click(CardInfoUpdLogTabDataGridLoad);
	$('#BClear').click(BClearClickHandler);
	document.onkeydown = DocumentOnKeyDown;
}
function CardInfoUpdLogTabDataGridLoad(){
	$.q({
	    ClassName : "web.DHCBL.Patient.DHCPatientBuilder",
	    QueryName : "QueryUptLog",
	    UPCardNo:$("#UPCardNo").val(),
	    UPRegNo:$("#UPRegNo").val(),
	    UPPAPERName:$("#UPPAPERName").val(),
	    UPsPAPERName:$("#UPsPAPERName").val(),
	    StartDate:$("#StartDate").datebox('getValue'),
	    EndDate:$("#EndDate").datebox('getValue'),
	    Pagerows:PageLogicObj.m_CardInfoUpdLogTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_CardInfoUpdLogTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function DocumentOnKeyDown(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	if (keyCode==13) {
		if(SrcObj && SrcObj.id.indexOf("UPCardNo")>=0){
			CheckCardNo(e);
			return false;
		}else if(SrcObj && SrcObj.id.indexOf("UPRegNo")>=0){
			var PatientNo=$("#UPRegNo").val();
			if (PatientNo!='') {
				if (PatientNo.length<10) {
					for (var i=(10-PatientNo.length-1); i>=0; i--) {
						PatientNo="0"+PatientNo;
					}
				}
			}
			$("#UPRegNo").val(PatientNo);
			CardInfoUpdLogTabDataGridLoad();
			return false;
		}
		return true;
	}
}
function ReadCardClickHandler(){
	DHCACC_GetAccInfo7(CardNoCallBack);
}
function CardNoCallBack(myrtn){
	var myary=myrtn.split("^");
	var rtn=myary[0];
	switch (rtn){
		case "0": //卡有效有帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			$("#UPCardNo").val(CardNo);
			CardInfoUpdLogTabDataGridLoad()
			event.keyCode=13;
			break;
		case "-200": //卡无效
			$.messager.alert("提示","卡无效","info",function(){
				$('#UPCardNo').focus();
			});
			break;
		case "-201": //卡有效无帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			$("#UPCardNo").val(CardNo);
			CardInfoUpdLogTabDataGridLoad()
			event.keyCode=13;
		default:
	}
}
function CheckCardNo(){
	var CardNo=$("#UPCardNo").val();
	if (CardNo=="") return;
	var myrtn=DHCACC_GetAccInfo("",CardNo,"","",CardNoCallBack);
}
function BClearClickHandler(){
	$("#UPCardNo,#UPRegNo,#CardTypeNew,#UPPAPERName,#UPsPAPERName").val('');
	$("#StartDate,#EndDate").datebox('setValue',ServerObj.CurDate);
	CardInfoUpdLogTabDataGridLoad();
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