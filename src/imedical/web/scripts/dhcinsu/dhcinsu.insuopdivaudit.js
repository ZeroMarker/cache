/* 
 * FileName:	dhcinsu.insuopdivaudit.js
 * User:		HanZH
 * Date:		2022-10-17
 * Function:	
 * Description: 门诊收费审核
*/

var InvAmt=0;
var OEInvId=""
var ItmOEID=""
$(function(){
	setPageLayout(); //页面布局初始化
	//setElementEvent(); //页面事件初始化
	var a =document.getElementsByClassName("layout-button-up");
	  a[0].style.display="none";
});

//页面布局初始化
function setPageLayout(){
	
	// 默认日期
	$('#StartDate').datebox('setValue', getDefStDate(-61)); 	// getDefStDate() -> 需要引用 <DHCBILL/>
	$('#EndDate').datebox('setValue', getDefStDate(0));
	//$("#InvAmt").val(InvAmt);
	setValueById('InvAmt',InvAmt);
	$("#InvAmt").attr("readOnly", true);	
	
	
	$('#RegNo').on('keydown', function (e) {
		findPatKeyDownRegNo(e);
	});		
	//查询
	$HUI.linkbutton("#btnQuery", {
		onClick: function () {
			loadInvDataGrid();
		}
	});
	
	
	//调自费
	$HUI.linkbutton("#btn-zf", {
		onClick: function () {
			ChangeOECoverMain("N");
		}
	});
	
	//调医保
	$HUI.linkbutton("#btn-yb", {
		onClick: function () {
			ChangeOECoverMain("Y");
		}
	});
	
	//医保结算
	$HUI.linkbutton("#btn-InsuDiv", {
		onClick: function () {
			InsuOPDivideForAudit();
		}
	});
	
	//医保结算
	$HUI.linkbutton("#btn-InsuDivPrint", {
		onClick: function () {
			InsuDivPrint();
		}
	});
	
	//慢病查询
	$HUI.linkbutton("#btnCheckMB", {
		onClick: function () {
			btnCheckMBPrint();
		}
	});
	
	
	//医保读卡
	$HUI.linkbutton("#btnReadCard", {
		onClick: function () {
			InsuReadPatInfo();
		}
	});
	
	
	//是否集中打印发票
	$HUI.combobox("#CPPFlag",{
		valueField:'code', 
		textField:'desc',
		panelHeight:"auto",
		data:[
			{code:'N',desc:'否',selected:'true'},
			{code:'Y',desc:'是'}
		]
	});
	
	//发票明细列表
	$HUI.datagrid('#InvGrid',{
		//title:'发票明细',
		iconCls:'icon-apply-check',
		headerCls:'panel-header-gray',
		closable:false,
		collapsible:false,
		fitColumns:true,
		fit:true,
		rownumbers:true,
		checkOnSelect:false,
		//singleSelect:true,
		pagination:true,
		toolbar: '#InvToolBar', // 工具栏 对应csp中的id
		pageSize:50,
		pageList:[10,20,30,50],
		url:$URL,
		columns:[[     
				{field:'checkbox',checkbox:true},
				{field:'Tind',title:'序号',hidden:true,algin:'left'},
				{field:'TInvNo',title:'发票号',width:140},
				//{field:'TInvId',title:'发票rowid',width:20,hidden:true},
				{field:'TInvId',title:'发票rowid',width:120},
				{field:'TRegNo',title:'登记号',width:120},
				{field:'TPatName',title:'病人姓名',width:120},
				{field:'TPatID',title:'病人身份证号',width:180},
				{field:'TTotalAmout',title:'发票金额',width:120,align:'right'},
				{field:'TInvDate',title:'收费日期',width:120},
				{field:'TInvTime',title:'收费时间',width:120},
				{field:'TInsuMark',title:'医保标记',width:80,hidden:true}
		]],
		onLoadSuccess:function(){

		},
		onSelect:function(rowIndex,rowData){
			loadOEDataGrid(rowIndex,rowData);
		},
		onUnselect:function(rowIndex,rowData){
			cleanloadOEDataGrid(rowIndex,rowData);
		},
		onCheck:function(rowIndex,rowData){
			EditInvAmtAdd(rowIndex,rowData);
		},
		onUncheck:function(rowIndex,rowData){
			EditInvAmtSub(rowIndex,rowData);
		},
		onCheckAll:function(rows){
			EditInvAmtAddALL(rows);
		},
		onUncheckAll:function(rows){
			InvAmt=0;
   			setValueById('InvAmt',0);
   			setValueById('sfz',"");
		}
	});
	
	//医嘱明细列表
	$HUI.datagrid('#orGrid',{
		//title:'医嘱明细',
		//iconCls:'icon-apply-check',
		//headerCls:'panel-header-gray',
		//fitColumns:true,
		border:false,
		fit:true,
		rownumbers:true,
		//singleSelect:true,
		checkOnSelect:false,
		pagination:true,
		toolbar: '#orToolBar', // 工具栏 对应csp中的id
		pageSize:10,
		pageList:[10,20,30],
		url:$URL,
		columns:[[     
			{field:'checkbox',checkbox:true},
			{field:'BillDr',title:'BillDr',hidden:true},
			{field:'TCoverMainIns',title:'医保标识',width:80},
			{field:'TOEID',title:'医嘱ID',width:60},    
			{field:'TOEDesc',title:'医嘱名称',width:160},
			{field:'TInsuxmmc',title:'医保项目名称',width:160,size:10},
			{field:'TInsuxmdj',title:'项目等级',width:80},
			{field:'Insubz',title:'限制范围',width:200,size:10},
			{field:'TOEDept',title:'执行科室',width:100}, 
			{field:'TOEDate',title:'开医嘱日期',width:80},   
			{field:'TOEDoctor',title:'开医嘱医生',width:80},
			{field:'TOEPrice',title:'单价',width:60,align:'right'},    
			{field:'TOEQty',title:'数量',width:60},
			{field:'TOEAmt',title:'金额',width:60,align:'right'}
		]],
		onLoadSuccess:function(){
		},
		onSelect:function(rowIndex,rowData){
			loadItmDataGrid(rowIndex,rowData)
		},
		onUnselect:function(rowIndex,rowData){
			cleanloadItmDataGrid(rowIndex,rowData);
		}
		
	});
	
	//收费项明细列表
	$HUI.datagrid('#ItmGrid',{
		title:'收费项明细',
		iconCls:'icon-apply-check',
		headerCls:'panel-header-gray',
		//fitColumns:true,
		fit:true,
		rownumbers:true,
		singleSelect:true,
		pagination:true,
		pageSize:10,
		pageList:[10,20,30],
		url:$URL,
		columns:[[  
			{field:'TItmind',title:'序号',hidden:true}, 
			{field:'TarID',title:'收费项ID',width:100,hidden:true},    
			{field:'TarCode',title:'医院项目编码',width:120},
			{field:'TarDesc',title:'医院项目名称',width:120}, 
			{field:'InsuItmID',title:'医保收费项ID',width:100,hidden:true},
			{field:'InsuCode',title:'医保项目编码',width:120},
			{field:'InsuDesc',title:'医保项目名称',width:120},       
			{field:'Insuxmdj',title:'项目等级',width:80},
			{field:'ItmPrice',title:'单价',width:80,align:'right'},    
			{field:'ItmQty',title:'数量',width:60},
			{field:'ItmAmt',title:'金额',width:80,align:'right'}
		]],
		onLoadSuccess:function(){
		}
	});
	var a =document.getElementsByClassName("layout-button-up");
	  a[0].style.display="none";
}


///加载发票列表信息
function loadInvDataGrid(){
	
	var StartDate = $('#StartDate').datebox('getValue');
	var EndDate = $('#EndDate').datebox('getValue');
	var CPPFlag= $('#CPPFlag').combobox('getValue')
	var RegNo=$('#RegNo').val();
	var InvNo=$('#InvNo').val();
	//alert(InvNo)
	if((RegNo=="")&&(InvNo=="")) {
		$.messager.alert('提示','登记号和发票号不能同时为空,请检查','info');
		return;
	}
	
	var queryParams = {
		ClassName:'web.INSUOPDivideAudit',
		QueryName:'OPDivAuditApp',
		StartDate:StartDate, 
		EndDate:EndDate, 
		RegNo:RegNo, 
		InvNo:InvNo,
		CPPFlag:CPPFlag
	}
	$('#InvGrid').datagrid('options').url = $URL;
	$('#InvGrid').datagrid('load',queryParams);
	
}

///加载医嘱列表信息
function loadOEDataGrid(rowIndex,rowData){
	
	var PrtRowidStr=rowData.TInvId;
	//alert(PrtRowidStr)
	var queryParams = {
		ClassName:'web.INSUOPDivideAudit',
		QueryName:'OPOEListAuditApp',
		PrtRowidStr:PrtRowidStr
	}
	$('#orGrid').datagrid('options').url = $URL;
	$('#orGrid').datagrid('load',queryParams);
	OEInvId=PrtRowidStr;
	
}
///清除医嘱列表信息 +20221202
function cleanloadOEDataGrid(rowIndex,rowData){
	if (rowData.TInvId==OEInvId){
		$('#orGrid').datagrid('load',{});
		$('#ItmGrid').datagrid('load',{});
	}
	
}


///加载收费项目列表信息
function loadItmDataGrid(rowIndex,rowData){
	var OeOrdDr=rowData.TOEID;
	var BillDr=rowData.BillDr;
	//alert(OeOrdDr+"^"+rowData.BillDr)
	var queryParams = {
		ClassName:'web.INSUOPDivideAudit',
		QueryName:'OPItmListAuditApp',
		BillDr:BillDr,
		OeOrdDr:OeOrdDr
	}
	$('#ItmGrid').datagrid('options').url = $URL;
	$('#ItmGrid').datagrid('load',queryParams);
	ItmOEID=OeOrdDr
	
}

///清除收费项目列表信息 +20221202
function cleanloadItmDataGrid(rowIndex,rowData){
	if (rowData.TOEID==ItmOEID){
		$('#ItmGrid').datagrid('load',{});
	}
	
}

///调自费-调医保
function ChangeOECoverMain(State){
	var OEORIRowIdStr=""
	var rows = $('#orGrid').datagrid('getChecked'); //行记录
	if(rows.length>0){
		for (i=0;i<rows.length;i++)
		{
			if(OEORIRowIdStr==""){OEORIRowIdStr=rows[i].TOEID;}
			else{OEORIRowIdStr=OEORIRowIdStr+"^"+rows[i].TOEID}
		}
		//alert(OEORIRowIdStr)
		
	}else{
		$.messager.alert('提示','请选择需要调整的记录','info');
	}
		
	$.m({
		ClassName: "web.INSUOPDivideAudit",
		MethodName: "UpdateOECoverMain",
		OEORIRowIdStr: OEORIRowIdStr,
		State:State
	}, function (rtn) {
		//alert(rtn)
		if(rtn==0){
			//$.messager.alert('提示','调整成功','info');
		}else{
			$.messager.alert('提示','调整失败','info');
		}
	})
	$('#orGrid').datagrid('reload');
	$('#ItmGrid').datagrid('reload');
}



///医保结算
function InsuOPDivideForAudit(){
	var StrInvDrStr=""
	var rows = $('#InvGrid').datagrid('getChecked'); //行记录
	if(rows.length>0){
		for (i=0;i<rows.length;i++)
		{
			if(StrInvDrStr==""){StrInvDrStr=rows[i].TInvId;}
			else{StrInvDrStr=StrInvDrStr+"^"+rows[i].TInvId}
			var StrInvDr=rows[rows.length-1].TInvId
		}
		
	}else{
		$.messager.alert('提示','请选择需要结算的记录','info');
		return;
	}
	
	var UseQty=$('#UseQty').val();
	if(UseQty==""){UseQty="0";}			//add by xubaobao 2020 06 17
	var StrikeFlag="N"
	var GroupDR=session['LOGON.GROUPID'];
	var Guser=session['LOGON.USERID']
	var InsuNo=""
	var CardType=""
	var YLLB=""
	var DicCode=""
	var JSLY="01"
	var DYLB=""
	var MoneyType=""	//卡类型
	var LeftAmt="0"
	var LeftAmtStr="!"+LeftAmt+"^"+MoneyType	
	var ExpString=StrikeFlag+"^"+GroupDR+"^"+InsuNo+"^"+CardType+"^"+YLLB+"^"+DicCode+"^^^"+JSLY+"^^"+DYLB+"^^"+session['LOGON.HOSPID']+"^"+LeftAmtStr		
	var ExpString=ExpString+"!"+"INSU"+"^"+UseQty
	var CPPFlag=""
	var AdmReasonId=tkMakeServerCall("web.INSUDicDataCom","GetDicDataDescByCode","HISPROPerty00A","OpChrgChkSetlAdmReasonId",session['LOGON.HOSPID']);
	if(AdmReasonId==""){
		$.messager.alert('提示','请核实是否维护了HISPROPerty00A下的OpChrgChkSetlAdmReasonId字典配置！','info');
		return;
	}
	
	//医保结算
	var DivideStr=InsuOPDivideAudit(0 , Guser, StrInvDrStr, "1", AdmReasonId,ExpString,CPPFlag)	//DHCInsuPort.js
	
	DivRowid=tkMakeServerCall("web.DHCINSUPort","GetDivideIDByInvPrtDr",StrInvDr);
	//var flag=InsuOPJSDPrint00A(0,session['LOGON.USERID'],DivRowid,"","","")
	var flag=InsuOPJSDPrint(0,session['LOGON.USERID'],DivRowid,"",AdmReasonId,"",CPPFlag)
	if(DivideStr.split("^")[0]!="0"){
		//$.messager.alert('提示','医保结算失败','info');
		//return;
	}
	
	$('#InvGrid').datagrid('reload');
	$('#orGrid').datagrid('reload');
	$('#ItmGrid').datagrid('reload');
	InvAmt=0;
}

function InsuDivPrint(){
	var StrInvDrStr=""
	var DivRowid=""
	var rows = $('#InvGrid').datagrid('getChecked'); //行记录
	if(rows.length>0){
		for (i=0;i<rows.length;i++)
		{
			if(StrInvDrStr==""){StrInvDrStr=rows[i].TInvId;}
			else{StrInvDrStr=StrInvDrStr+"^"+rows[i].TInvId}
		}
		
	}else{
		$.messager.alert('提示','请选择需要结算的记录','info');
		return;
	}
	
	var GroupDR=session['LOGON.GROUPID'];
	var Guser=session['LOGON.USERID']
	DivRowid=tkMakeServerCall("web.DHCINSUDivideCtl","GetDivRowidByInvprt",rows[i].TInvId);
	var flag=InsuOPJSDPrint00A(0,session['LOGON.USERID'],DivRowid,"","","")
	
}

function EditInvAmtAdd(rowIndex,rowData){
	/*var rows = $('#InvGrid').datagrid('getChecked'); //行记录
	if(rows.length>0){
		for (i=0;i<rows.length;i++)
		{
			if(InvAmt==""){InvAmt=parseFloat(rows[i].TTotalAmout);}
			else{InvAmt=InvAmt+parseFloat(rows[i].TTotalAmout)}
		}
	}*/
	InvAmt=InvAmt+parseFloat(rowData.TTotalAmout);
	//InvAmt=InvAmt+Number(rowData.TTotalAmout);
	//$("#InvAmt").text(InvAmt);
	setValueById('InvAmt',InvAmt);
	setValueById('sfz',rowData.TPatID);
}

function btnCheckMBPrint(){
	var INSUType="00A"
	var InsuNo=""
	var ID=$('#sfz').val();
	var ExpString=INSUType+"^^^^^"
//	var flag=InsuReadCard00A(0,session['LOGON.USERID'],PatId,"02",ExpString)//DHCInsuPort.js
	var TmpStr=INSUDiseaseApproveQueryNew(0,session['LOGON.USERID'],ID,ExpString)
	$.messager.alert('提示',TmpStr,'info');
	}

function EditInvAmtSub(rowIndex,rowData){
	/*var rows = $('#InvGrid').datagrid('getChecked'); //行记录
	if(rows.length>0){
		for (i=0;i<rows.length;i++)
		{
			if(InvAmt==""){InvAmt=parseFloat(rows[i].TTotalAmout);}
			else{InvAmt=InvAmt+parseFloat(rows[i].TTotalAmout)}
		}
	}*/
	InvAmt=InvAmt-parseFloat(rowData.TTotalAmout);
	//$("#InvAmt").text(InvAmt);
	setValueById('InvAmt',InvAmt);
	if(InvAmt=="0"){
		setValueById('sfz',"");
	}
	
}

function EditInvAmtAddALL(rows){
	InvAmt=0
	for (i=0;i<rows.length;i++){
		EditInvAmtAdd(i,rows[i])
	}
}

/*
///医保读卡
function InsuReadPatInfo(){
	var Guser=session['LOGON.USERID'];
	var CardType="";
	var InsuNo="";
	var ExpString=""
	var ID=$('#sfz').val();
	var SFZID=""
	var rows = $('#InvGrid').datagrid('getSelected'); //行记录
	if(rows.length>1){
		$.messager.alert('提示','请选择一条需要读卡的记录','info');
		return;
	}
	if(rows.TPatID==""&&ID==""){
		$.messager.alert('提示','身份证号不能为空','info');
		return;
	}else if(rows.TPatID==""){
		SFZID=ID
	}else{
		SFZID=rows.TPatID
	}
	var ExpString=rows.TPatName+"^"+SFZID;
	var ReadInfo=InsuASReadPatInfo(0,Guser,CardType,InsuNo,ExpString)
	//alert(ReadInfo)
	if (ReadInfo.split("|")[0]=="0")
	{
		$('#PatTypeD').text(ReadInfo.split("|")[1]);	
		$('#DiagDesc').text(ReadInfo.split("|")[2]+"|"+ReadInfo.split("|")[3]);	
	}
}
*/

///登记号回车
function findPatKeyDownRegNo(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		GetRegNo();
		loadInvDataGrid();
	}
}

//登记号补零  
function GetRegNo(){
	var RegNo=$('#RegNo').val();
	var PRegNoLength=10-RegNo.length;      	
	for (var i=0;i<PRegNoLength;i++){
		RegNo="0"+RegNo;			
	}
	//$('#RegNo').val(RegNo);
	setValueById('RegNo',RegNo);
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




