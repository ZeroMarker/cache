var PageLogicObj={
	m_RefundTabDataGrid:"",
	m_UserId:""
}
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
})
function Init(){
	PageLogicObj.m_RefundTabDataGrid=InitRefundTabDataGrid();
}
function InitEvent(){
	$('#Clear').click(BClearClick);
	$('#ReadCard').click(ReadCardClick);
	$('#Find').click(RefundTabDataGridLoad);
	$('#CardNo').keydown(CardNoKeydownHandler);
	$('#PatNo').keydown(PatNoKeydownHandler);
	$('#ReceipNO').keydown(ReceipNOKeydownHandler);
}
function PageHandle(){
	InitChargeUser();
	RefundTabDataGridLoad();
}
function InitRefundTabDataGrid(){
	var toobar=[{
        text: '处理订单',
        iconCls: 'icon-edit',
        handler: function() {Dealclick(); }
    }];
	var Columns=[[ 
		{field:'INABRowID',checkbox:true},
		{field:'TabRecptStatusDesc',title:'订单状态',width:100},
		{field:'TabInsuAccount',title:'金额',width:100},
		{field:'TabUserName',title:'收费员',width:100},
		{field:'TabBornDate',title:'产生日期',width:100},
		{field:'TabBornTime',title:'产生时间',width:100},
		{field:'TabAdmDepDesc',title:'挂号科室',width:100},
		{field:'TabAdmDocDesc',title:'挂号医生',width:150},
		{field:'TabPatientNo',title:'登记号',width:100},
		{field:'TabPatientName',title:'患者姓名',width:100},
		{field:'TAdmDocCode',title:'是否来自挂号',width:100}		
    ]]
	var RefundTabDataGrid=$("#RefundTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 15,
		pageList : [15,100,200],
		idField:'INABRowID',
		columns :Columns,
		toolbar:toobar,
		onClickRow:function(index, row){
			SetSelRowData(row);
		}
	});
	return RefundTabDataGrid;
}
function InitChargeUser(){
	$("#ChargeUser").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'UsrID',
        textField:'UsrName',
        columns:[[  
           {field:'UsrName',title:'收费员',width:130,sortable:true}
        ]],
        pagination:true,
        panelWidth:300,
        panelHeight:300,
        isCombo:true,
        minQueryLen:0,
        delay:'200',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCOPAdmReg',QueryName: 'FindInvUsr'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
			param = $.extend(param,{ChargeUser:desc});
	    },onSelect:function(ind,item){
		    PageLogicObj.m_UserId=item.UsrID;
		}
    });
}
function CardNoKeydownHandler(e){
	var key=websys_getKey(e);
	if (key==13) {
		CheckCardNo();
		return false;
	}
}
function CheckCardNo(){
	var CardNo=$("#CardNo").val();
	if (CardNo=="") return;
	var myrtn=DHCACC_GetAccInfo("",CardNo,"","","CardNoCallBack");
}
function ReadCardClick(){
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
			SetPatientInfo(PatientNo,CardNo);
			RefundTabDataGridLoad()
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
			RefundTabDataGridLoad()
			event.keyCode=13;
		default:
	}
}
function SetPatientInfo(PatientNo,CardNo){
	if (PatientNo!='') {
		$.cm({
		    ClassName : "web.DHCOPCashierIF",
		    MethodName : "GetPAPMIByNo",
		    PAPMINo:PatientNo,
		    dataType:"text"
		},function(PatDr){
			if (PatDr=="") {
				$.messager.alert("提示",PatientNo+" 此登记号不存在对应病人，请确认！","info",function(){
					$("#PatNo").val("").focus();
				});
				return false;
			}
			$("#PatNo").val(PatientNo);
			$("#CardNo").val(CardNo);
		})
	} else {
		$('#CardNo').focus();
		return false;
	}
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
		RefundTabDataGridLoad()
	}
}
function ReceipNOKeydownHandler(){
	if (!e)
		var key = websys_getKey(e);
	if (key == 13) {
		RefundTabDataGridLoad();
	}
}
function BClearClick(){
	$("#ChargeUser").lookup('setText',"");
	PageLogicObj.m_UserId="";
	$("#ReceipNO,#PatNo,#PatName,#CardTypeNew,#CardNo").val("");
	$("#StartDate,#EndDate").datebox('setValue',"");
	RefundTabDataGridLoad();
}
function RefundTabDataGridLoad(){
	var PatNo=$("#PatNo").val();
	var StartDate=$HUI.datebox("#StartDate").getValue();
	var EndDate=$HUI.datebox("#EndDate").getValue();
	if ($("#ChargeUser").lookup('getText')=="") PageLogicObj.m_UserId="";
	$.q({
	    ClassName : "web.DHCOPAdmReg",
	    QueryName : "DHCOPINAB",
	    PatientNO:PatNo,
	    UserId:PageLogicObj.m_UserId,
	    StartDate:StartDate,
	    EndDate:EndDate,
	    Pagerows:PageLogicObj.m_RefundTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_RefundTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	});
}
function Dealclick(){
	var UserID=session['LOGON.USERID'];
    var IsSelectFlag=false;
	var UserId=session['LOGON.USERID'];
	var rows=PageLogicObj.m_RefundTabDataGrid.datagrid('getSelections');
	if  (rows.length==0) {
		$.messager.alert("提示","请先选择一条记录后再处理!");
		return false;
	}
	for (var i=0;i<rows.length;i++){
		var InsuAdmInfoDr=rows[i].InsuAdmRowid;
		var AdmReason=rows[i].TabAdmReason;
		//挂号的异常订单产生于HIS挂号失败，撤销医保挂号失败时，处理步骤是进行医保退号
		//退号的异常订单产生于医保退号失败，回退HIS退号失败时，处理步骤是进行医保退号，而不是回退HIS退号
		var InsuRetValue=InsuOPRegStrike(0,UserID,InsuAdmInfoDr,"",AdmReason,"");
		 if (InsuRetValue=='-1'){	                		   
			$.messager.alert("提示","异常订单处理失败!");
            return false;					
         }
	}
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