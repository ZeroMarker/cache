var PageLogicObj={
	m_QueStateQryTabDataGrid:""
};
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
	//表格数据初始化
	QueStateQryTabDataGridLoad();
});
function Init(){
	PageLogicObj.m_QueStateQryTabDataGrid=InitExaBoroughRoomTabDataGrid();
}
function InitExaBoroughRoomTabDataGrid(){
	var Columns=[[ 
		{field:'Tind',title:'序号',width:40},
		{field:'TPatID',title:'病人ID',width:100},
		{field:'TPatName',title:'患者姓名',width:100},
		{field:'TAdmDate',title:'就诊日期',width:150},
		{field:'TQSStatus',title:'改变后状态',width:100},
		{field:'TAdmDep',title:'',hidden:true},
		{field:'TAdmDepDesc',title:'就诊科室',width:100},
		{field:'TAdmDocCode',title:'就诊医生',width:100},
		{field:'TQSDate',title:'更新日期',width:100},
		{field:'TQSTime',title:'更新时间',width:100},
		{field:'TQSUpUser',title:'更新人',width:100},
		{field:'OPTransAdmFlag',title:'转诊标志',width:80}
    ]]
	var QueStateQryTabDataGrid=$("#QueStateQryTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 15,
		pageList : [15,100,200],
		idField:'Tind',
		columns :Columns,
		onClickRow:function(index, row){
			SetSelRowData(row);
		}
	});
	return QueStateQryTabDataGrid;
}
function InitEvent(){
	$('#ReadCard').click(ReadCardClickHandler);
	$('#Bfind').click(QueStateQryTabDataGridLoad);
	$('#CardNo').keydown(CardNoKeydownHandler);
	$('#PatNo').keydown(PatNoKeydownHandler);
}
function ReadCardClickHandler(){
	DHCACC_GetAccInfo7(CardNoCallBack);
}
function PageHandle(){
	$.cm({
	    ClassName : "web.DHCDocQueStateQry",
	    MethodName : "GetDHCPerStateJson",
	    rows:9999
	},function(data){
		//初始化状态
		 var cbox = $HUI.combobox("#State", {
				valueField: 'id',
				textField: 'text',
				editable:true, 
				data:data,
				onSelect: function (rec) {
					QueStateQryTabDataGridLoad();
				},
				onChange:function(newValue,OldValue){
					if (newValue==""){
						QueStateQryTabDataGridLoad();
					}
				}
		   });
	}); 
	
}
function PatNoKeydownHandler(e){
	var key=websys_getKey(e);
	if (key==13) {
		var PatNo=$("#PatNo").val();
		if (PatNo!="") {
			if (PatNo.length<10){
				for (var i=(10-PatNo.length-1); i>=0; i--) {
					PatNo="0"+PatNo
				}
			}
		}
		SetPatientInfo(PatNo,"");
		QueStateQryTabDataGridLoad()
	}
}
function CardNoKeydownHandler(e){
	var key=websys_getKey(e);
	if (key==13) {
		CheckCardNo();
		return false;
		//QueStateQryTabDataGridLoad()
	}
}
function CardNoCallBack(myrtn){
	var myary=myrtn.split("^");
	var rtn=myary[0];
	switch (rtn){
		case "0": //卡有效有帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			SetPatientInfo(PatientNo,CardNo);
			QueStateQryTabDataGridLoad()
			event.keyCode=13;
			break;
		case "-200": //卡无效
			$.messager.alert("提示","卡无效","info",function(){
				$('#CardNo').focus();
			});
			break;
		case "-201": //卡有效无帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			SetPatientInfo(PatientNo,CardNo);
			QueStateQryTabDataGridLoad()
			event.keyCode=13;
		default:
	}
}
function CheckCardNo(){
	var CardNo=$("#CardNo").val();
	if (CardNo=="") return;
	var myrtn=DHCACC_GetAccInfo("",CardNo,"","","CardNoCallBack");
}
function GetCardTypeRowId(){
	var CardTypeRowId="";
	var CardTypeValue=$("#CardType").combobox("getValue");
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^")
		CardTypeRowId=CardTypeArr[0];
	}
	return CardTypeRowId
}
function GetCardNoLength(){
	var CardNoLength="";
	var CardTypeValue=$("#CardType").combobox("getValue");
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^");
		CardNoLength=CardTypeArr[17];
	}
	return CardNoLength;
}
function FormatCardNo(){
	var CardNo=$("#CardNo").val();
	if (CardNo!='') {
		var CardNoLength=GetCardNoLength();
		if ((CardNo.length<CardNoLength)&&(CardNoLength!=0)) {
			for (var i=(CardNoLength-CardNo.length-1); i>=0; i--) {
				CardNo="0"+CardNo;
			}
		}
	}
	return CardNo
}
function SetPatientInfo(PatientNo,CardNo){
	if (PatientNo!='') {
		$("#PatNo").val(PatientNo);
		$("#CardNo").val(CardNo);
	} else {
		$('#CardNo').focus();
		return false;
	}
}
function QueStateQryTabDataGridLoad(){
	var PatNo=$("#PatNo").val();
	var StartDate=$HUI.datebox("#StartDate").getValue();
	var EndDate=$HUI.datebox("#EndDate").getValue();
	var State=$("#State").combobox("getValue");
	$.q({
	    ClassName : "web.DHCDocQueStateQry",
	    QueryName : "QueryUpState",
	    PatNo:PatNo,
	    StartDate:StartDate,
	    EndDate:EndDate,
	    State:State,
	    Pagerows:PageLogicObj.m_QueStateQryTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_QueStateQryTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
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