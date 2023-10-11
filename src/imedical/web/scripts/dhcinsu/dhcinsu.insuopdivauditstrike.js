/* 
 * FileName:	dhcinsu.insuopdivauditstrike.js
 * User:		HanZH
 * Date:		2022-10-17
 * Function:	
 * Description: 医保门诊退费审核
*/

var Guser=session['LOGON.USERID'];
$(function(){
	setPageLayout(); //页面布局初始化
	//setElementEvent(); //页面事件初始化
});

//页面布局初始化
function setPageLayout(){
	
	// 默认日期
	$('#StartDate').datebox('setValue', getDefStDate(-1)); 	// getDefStDate() -> 需要引用 <DHCBILL/>
	$('#EndDate').datebox('setValue', getDefStDate(0));
	
	$('#RegNo').on('keydown', function (e) {
		findPatKeyDownRegNo(e);
	});				
	
	//查询
	$HUI.linkbutton("#btnQuery", {
		onClick: function () {
			loadDivDataGrid();
		}
	});
	
	//医保结算
	$HUI.linkbutton("#btn-InsuDivCancel", {
		onClick: function () {
			InsuOPDivideStrikeForAudit();
		}
	});
	
	
	//打印医保结算单
	$HUI.linkbutton("#btn-InsuDivPrint", {
		onClick: function () {
			InsuDivPrint();
		}
	});
	
	
	//预结算单
	$HUI.linkbutton("#btn-InsuPreDivPrint", {
		onClick: function () {
			InsuPreDivPrint();
		}
	});

	
	//发票明细列表
	$HUI.datagrid('#DivGrid',{
		//title:'医保结算明细',
		border:false,
		iconCls:'icon-apply-check',
		headerCls:'panel-header-gray',
		fitColumns:true,
		fit:true,
		rownumbers:true,
		//checkOnSelect:false,
		singleSelect:true,
		pagination:true,
		toolbar: '#InvToolBar', // 工具栏 对应csp中的id
		pageSize:30,
		pageList:[10,20,30],
		url:$URL,
		columns:[[     
				//{field:'checkbox',checkbox:true},
				{field:'TRowid',title:'结算ID',width:100},
				{field:'TFlag',title:'结算标志',width:80},
				{field:'TRegNo',title:'登记号',width:100},
				{field:'TPatName',title:'病人姓名',width:100},
				{field:'TPatID',title:'病人身份证号',width:140},
				{field:'Tdjlsh',title:'单据号',width:80},
				{field:'TAmt',title:'结算金额',width:80,align:'right'},
				{field:'TDate',title:'结算日期',width:100},
				{field:'TTime',title:'结算时间',width:100},
				{field:'Tjjzfe',title:'基金支付',width:80,align:'right'},
				{field:'Tzhzfe',title:'账户支付',width:80,align:'right'},
				{field:'Tgrzfe',title:'现金支付',width:80,align:'right'},
				{field:'TUserID',title:'结算人ID',width:80,hidden:true},
				{field:'TUserName',title:'结算人',width:80}
		]],
		onLoadSuccess:function(){
		},
		onSelect:function(rowIndex,rowData){
			//loadOEDataGrid(rowIndex,rowData);
		}
	});
	
	var a =document.getElementsByClassName("layout-button-up");
	//a[0].style.display="none";
}


///登记号回车
function findPatKeyDownRegNo(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		GetRegNo();
		loadDivDataGrid();
	}
}

//登记号补零  
function GetRegNo(){
	var RegNo=$('#RegNo').val();
	var PRegNoLength=10-RegNo.length;      	
	for (var i=0;i<PRegNoLength;i++){
		RegNo="0"+RegNo;			
	}
	$('#RegNo').val(RegNo);	
}

///加载发票列表信息
function loadDivDataGrid(){
	
	var StartDate = $('#StartDate').datebox('getValue');
	var EndDate = $('#EndDate').datebox('getValue');
	var RegNo=$('#RegNo').val();
	var queryParams = {
		ClassName:'web.INSUOPDivideAudit',
		QueryName:'OPDivInfo',
		StartDate:StartDate, 
		EndDate:EndDate, 
		RegNo:RegNo,
		Guser:Guser
	}
	$('#DivGrid').datagrid('options').url = $URL;
	$('#DivGrid').datagrid('load',queryParams);
	
}


///撤销医保结算
function InsuOPDivideStrikeForAudit(){
	
	var rows = $('#DivGrid').datagrid('getSelected'); //行记录
	if(!rows){
		$.messager.alert('提示','请选择需要结算的记录','info');
		return;
	}
	var DivRowid=rows.TRowid;
	var ExpString="S^^^^"
	var CPPFlag=""
	var AdmReasonId=tkMakeServerCall("web.INSUDicDataCom","GetDicDataDescByCode","HISPROPerty00A","OpChrgChkSetlAdmReasonId",session['LOGON.HOSPID']);
	if(AdmReasonId==""){
		$.messager.alert('提示','请核实是否维护了HISPROPerty00A下的OpChrgChkSetlAdmReasonId字典配置！','info');
		return;
	}
	var DivideStr=InsuOPDivideStrikeAudit(0,Guser,DivRowid,"1",AdmReasonId,ExpString,CPPFlag)
	$('#DivGrid').datagrid('reload');
}


function getDefStDate(space) {
	if (isNaN(space)) {
		space = -30;
	}
	var dateObj = new Date();
	dateObj.setDate(dateObj.getDate() + space);
	var myYear = dateObj.getFullYear();
	var myMonth = (dateObj.getMonth() + 1) < 10 ? "0" + (dateObj.getMonth() + 1) : (dateObj.getMonth() + 1);
	var myDay = (dateObj.getDate()) < 10 ? "0" + (dateObj.getDate()) : (dateObj.getDate());
	var dateStr = "";
	var sysDateFormat = $.m({
			ClassName: "websys.Conversions",
			MethodName: "DateFormat"
		}, false); //同步调用取系统配置日期格式
	if (sysDateFormat == 1) {
		dateStr = myMonth + '/' + myDay + '/' + myYear;
	} else if (sysDateFormat == 3) {
		dateStr = myYear + '-' + myMonth + '-' + myDay;
	} else {
		dateStr = myDay + '/' + myMonth + '/' + myYear;
	}

	return dateStr;
}

///登记号回车
function findPatKeyDownRegNo(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		GetRegNo();
		loadDivDataGrid();
	}
}

//登记号补零  
function GetRegNo(){
	var RegNo=$('#RegNo').val();
	var PRegNoLength=10-RegNo.length;      	
	for (var i=0;i<PRegNoLength;i++){
		RegNo="0"+RegNo;			
	}
	$('#RegNo').val(RegNo);	
}

function InsuDivPrint(){
	var StrInvDrStr=""
	var DivRowid=""
	var rows = $('#DivGrid').datagrid('getChecked'); //行记录
	if(rows.length>0){
		for (i=0;i<rows.length;i++)
		{
			if(DivRowid==""){DivRowid=rows[i].TRowid;}
			else{DivRowid=DivRowid+"^"+rows[i].TRowid}
		}
		
	}else{
		$.messager.alert('提示','请选择需要结算的记录','info');
		return;
	}
	
	var GroupDR=session['LOGON.GROUPID'];
	var Guser=session['LOGON.USERID'];
	//DivRowid=tkMakeServerCall("web.DHCINSUDivideCtl","GetDivRowidByInvprt",rows[i].TInvId);
	var AdmReasonId=tkMakeServerCall("web.INSUDicDataCom","GetDicDataDescByCode","HISPROPerty00A","OpChrgChkSetlAdmReasonId",session['LOGON.HOSPID']);
	if(AdmReasonId==""){
		$.messager.alert('提示','请核实是否维护了HISPROPerty00A下的OpChrgChkSetlAdmReasonId字典配置！','info');
		return;
	}
	var flag=InsuOPJSDPrint00A(0,session['LOGON.USERID'],DivRowid,"1",AdmReasonId,"00A^^^^^")
	
}


///预结算单
function InsuPreDivPrint(){
	var StrInvDrStr=""
	var DivRowid=""
	var rows = $('#DivGrid').datagrid('getChecked'); //行记录
	if(rows.length>0){
		for (i=0;i<rows.length;i++)
		{
			if(DivRowid==""){DivRowid=rows[i].TRowid;}
			else{DivRowid=DivRowid+"^"+rows[i].TRowid}
		}
		
	}else{
		$.messager.alert('提示','请选择需要结算的记录','info');
		return;
	}
	DHCINVRowid=tkMakeServerCall("web.DHCINSUDivideCtl","GetInvprtByDivRowid",DivRowid);
	//var flag=InsuOPJSDPrint00A(0,session['LOGON.USERID'],DivRowid,"","","")
	filename="dhcinsu.mzmbyjsd.rpx&INVPrt="+DHCINVRowid
	DHCCPM_RQPrint(filename)
}


