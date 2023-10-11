var PageLogicObj={
	m_CardListTabDataGrid:"",
	dw:$(window).width()-400,
	dh:$(window).height()-100,
	CardLoss:true,
	CardCancelLoss:true,
	CardExchange:true,
	CardReplace:true,
	CardCancel:true
}
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
	if (ServerObj.InsuranceNo!=""){
		$("#InsuranceNo").val(ServerObj.InsuranceNo);
		RegReturnListTabDataGridLoad();
	}
	$("#Name").focus();
})
function PageHandle(){
	//卡类型
	//LoadCardType();
}
function InitEvent(){
	$("#BFind").click(RegReturnListTabDataGridLoad);
	$('#CardNo').change(CardNoChange);
	$("#BReadCard").click(ReadCardClickHandle);
	$("#BirthDay").change(BirthDayChange);
	$("#ReadRegInfo").click(ReadRegInfoOnClick);
	document.onkeydown = DocumentOnKeyDown;
}
function Init(){
	PageLogicObj.m_CardListTabDataGrid=InitCardListTabDataGrid();
}
function InitCardListTabDataGrid(){
	var Columns=[[ 
		{field:'CardID',hidden:true,title:''},
		{field:'CardTypeDesc',title:'卡类型',width:80},
		{field:'CardNO',title:'卡号',width:100},
		{field:'ActivedFlag',title:'卡状态',width:80},
		{field:'TPapmiNo',title:'登记号',width:100},
		{field:'Name',title:'姓名',width:100},
		{field:'TSex',title:'性别',width:50},
		{field:'TBirthday',title:'出生日期',width:100},
		{field:'TPatType',title:'患者类型',width:80},
		{field:'Ttelphone',title:'电话',width:105},
		{field:'TAddress',title:'住址',width:120},
		{field:'TCompany',title:'工作单位',width:150},
		{field:'CredTypeDesc',title:'证件类型',width:100},
		{field:'CredNo',title:'证件号',width:160},
		{field:'TInMedicareNo',title:'住院病历号',width:100},
		{field:'TCreateDate',title:'建档时间',width:90},
		{field:'TPoliticalLevel',title:'患者级别',width:90},
		{field:'TSecretLevel',title:'患者密级',width:90},
		{field:'TPatientID',title:'',hidden:true},
		{field:'myOtherStr',title:'',hidden:true}
    ]]
	var CardListTabDataGrid=$("#CardListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'CardID',
		columns :Columns,
		onSelect:function(index, row){
		},
		onDblClickRow:function(index, row){
			var myPatientID=row['TPatientID'];
			var cardno=row['CardNO'];
			var Regno=row['TPapmiNo'];
			if ((window.parent)&&(window.parent.CardSearchCallBack)){
				window.parent.CardSearchCallBack(cardno,Regno,myPatientID);
				window.parent.destroyDialog("FindPatReg");
			}else{
				 //建卡界面弹出
				 if(window&&window.name=="FindPatBase"){
					 var objCardNo=window.opener.opener.document.getElementById("CardNo")
				    if (objCardNo) objCardNo.value=cardno;
				    self.close();
				    window.opener.opener.websys_setfocus('CardNo');
				    window.opener.opener.focus();
				 }
				 //挂号界面弹出
				 if (window.name=="FindPatReg"){
						var Parobj=window.opener
				    var objCardNo=Parobj.document.getElementById("CardNo")
				    if (objCardNo) objCardNo.value=cardno;
			      	self.close();
				    Parobj.websys_setfocus('CardNo'); 
				}
				if (window.name=="UDHCJFIPReg"){
					var Parobj=window.opener
				    var objRegno=Parobj.document.getElementById("Regno")
				    if (objRegno) objRegno.value=Regno;
				    self.close();
				    Parobj.getpatinfo1()
				    Parobj.websys_setfocus('name'); 
				}
				//注册建卡界面弹出
				if (window.name=="UDHCCardPatInfoRegExpFind"){
					var Parobj=window.opener;
					Parobj.DHCWebD_SetObjValueA("PAPMINo", Regno);
				    self.close();
				    Parobj.ValidateRegInfoByCQU(myPatientID);
				}
			}
		}
	});
	CardListTabDataGrid.datagrid('loadData', { total: 0, rows: [] });  
	return CardListTabDataGrid;
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
		if(SrcObj && SrcObj.id.indexOf("CardNo")>=0){
			CardNoKeydownHandler(e);
			return false;
		}else if(SrcObj && SrcObj.id.indexOf("PatientNo")>=0){
			RegNoKeydownHandler(e);
			return false;
		}else if(SrcObj && (SrcObj.id.indexOf("Name")>=0||SrcObj.id.indexOf("CredNo")>=0||SrcObj.id.indexOf("OutMedicareNo")>=0||SrcObj.id.indexOf("InMedicareNo")>=0||SrcObj.id.indexOf("EmMedicare")>=0||SrcObj.id.indexOf("InsuranceNo")>=0||SrcObj.id.indexOf("Telphone"))>=0){
			FindDocumentOnKeyDownHandler(e);
			return false;
		}
		return true;
	}
}
function RegReturnListTabDataGridLoad(){
	PageLogicObj.m_CardListTabDataGrid.datagrid("uncheckAll");
	var EmployeeNo=$("#EmployeeNo").val();
	var Hospital=$("#Hospital").checkbox('getValue')?'on':'';
	var PatientNo=$("#PatientNo").val();
	$.cm({
	    ClassName : "web.DHCCardSearch",
	    QueryName : "PatientCardQuery",
	    Name:$("#Name").val(),
	    IDCardNo:"", //身份证号
	    CardNo:$("#CardNo").val(),
	    CardStatus:$("#CardStatus").checkbox('getValue')?'on':'',
	    CardTypeID:$("#CardTypeRowID").val(), //GetCardTypeRowId(),
	    SupportFlag:"",
	    CredNo:$("#CredNo").val(),
	    UseStatus:"",
	    BirthDay:$("#BirthDay").val(),
	    Telphone:$("#Telphone").val(),
	    OutMedicareNo:$("#OutMedicareNo").val(),
	    InMedicareNo:$("#InMedicareNo").val(),
	    //NewInMedicareNo:"",
	    InsuranceNo:$("#InsuranceNo").val(),
	    EmMedicare:$("#EmMedicare").val(),
	    ExpStr:EmployeeNo+"^"+Hospital+"^"+PatientNo+"^^"+session['LOGON.HOSPID'],
	    Pagerows:PageLogicObj.m_CardListTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_CardListTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function RegNoKeydownHandler(e){
	var key=websys_getKey(e);
	if(key==13){
		var RegNo=$('#PatientNo').val();
		if (RegNo!='') {
			var RegNoLength=10;
			if ((RegNo.length<RegNoLength)&&(RegNoLength!=0)) {
				for (var i=(RegNoLength-RegNo.length-1); i>=0; i--) {
					RegNo="0"+RegNo;
				}
			}
		}
		$('#PatientNo').val(RegNo);
		RegReturnListTabDataGridLoad();
	}
}
function CardNoChange(){
	var CardNo=$("#CardNo").val();
	if (CardNo==""){
		$("#CardTypeNew,#CardTypeRowID").val("");
	}
}
function CardNoKeydownHandler(e){
	var key=websys_getKey(e);
	if (key==13) {
		var CardNo=$("#CardNo").val();
		if (CardNo=="") return;
		CheckCardNo();
		return false;
	}
}
function CheckCardNo(){
	var CardNo=$("#CardNo").val();
	if (CardNo=="") return false;
	var myrtn=DHCACC_GetAccInfo("",CardNo,"","",CardNoKeyDownCallBack);
}
function CardNoKeyDownCallBack(myrtn){
	var CardNo=$("#CardNo").val();
	var CardTypeNew=$("#CardTypeNew").val();
	$(".textbox").val('');
	$("#CardTypeNew").val(CardTypeNew);
   var myary=myrtn.split("^");
   var rtn=myary[0];
   if ((rtn=="0")||(rtn=="-201")){
		var PatientID=myary[4];
		var PatientNo=myary[5];
		var CardNo=myary[1]
		$("#CardTypeRowID").val(myary[8]);
		$("#CardNo").focus().val(CardNo);
		if ($("#CardTypeNew").val()==""){
			$("#CardTypeNew").val(CardTypeNew);	
		}
		RegReturnListTabDataGridLoad();
	}else if(rtn=="-200"){
		$.messager.alert("提示","卡无效!","info",function(){
			$("#CardNo").val(CardNo).focus();
		});
		return false;
	}
}
function FindDocumentOnKeyDownHandler(e){
	var key=websys_getKey(e);
	if (key==13) {
		RegReturnListTabDataGridLoad();
		return false;
	}
}
function ReadCardClickHandle(){
	DHCACC_GetAccInfo7(CardNoKeyDownCallBack);
}
function BirthDayChange(){
	var BirthDay=$('#BirthDay').val();
	var BirLen=BirthDay.length
    if (BirLen==0) return true;
	if ((BirLen!=8)&&(BirLen!=10)){
		$("#BirthDay").addClass("newclsInvalid");
		$("#BirthDay").focus();
		return false;
	}
	if (BirLen==8){
		if (ServerObj.sysDateFormat=="4"){
			BirthDay=BirthDay.substring(6,8)+"/"+BirthDay.substring(4,6)+"/"+BirthDay.substring(0,4)
		}else{
			BirthDay=BirthDay.substring(0,4)+"-"+BirthDay.substring(4,6)+"-"+BirthDay.substring(6,8)
		}
	}
	$('#BirthDay').val(BirthDay);
	var myrtn=false
	if (ServerObj.sysDateFormat=="4"){
		var myrtn=DHCWeb_IsDate(BirthDay,"/")
	}else{
		var myrtn=DHCWeb_IsDate(BirthDay,"-")
	}
	if (!myrtn){
		$("#BirthDay").addClass("newclsInvalid");
		$("#BirthDay").focus();
		return false;
	}
	$("#BirthDay").removeClass("newclsInvalid");
}
function ReadRegInfoOnClick(){
	//默认设备类型为"身份证"
	var myHCTypeDR="1";
	if ($("#IEType").length>0) myHCTypeDR=$("#IEType").combobox("getValue");
	var myInfo=DHCWCOM_PersonInfoRead(myHCTypeDR);
	var myary=myInfo.split("^");
	if (myary[0]=="0"){
		var NameStr=myary[1].split("<Name>")[1];
		var Name=NameStr.split("</Name>")[0];
		var CredNoStr=myary[1].split("<CredNo>")[1];
		var CredNo=CredNoStr.split("</CredNo>")[0];
		var BirthStr=myary[1].split("<Birth>")[1];
		var Birth=BirthStr.split("</Birth>")[0];
		$("#BirthDay").val(Birth);
		$("#CredNo").val(CredNo);
		$("#Name").val(Name);
		BirthDayChange();
		RegReturnListTabDataGridLoad();
		}
	}