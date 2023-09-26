var PageLogicObj={
	m_RegQueryTabDataGrid:"",
}
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
})
function PageHandle(){
	$("#StDate,#EdDate").datebox('setValue',ServerObj.CurDate);
	RegQueryTabDataGridLoad();
	//挂号员
	LoadGhuse();
	//科室
	LoadDept();
	//优惠
	LoadRegConDisList();
	//医生 号别
	LoadMarkDoc();
	LoadDoc();
	//支付方式
	LoadPayMode();
	//挂号职称
	LoadSessionType();
}
function Init(){
	var hospComp = GenUserHospComp();
	hospComp.jdata.options.onSelect = function(e,t){
		var HospID=t.HOSPRowId;
		PageHandle();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		PageLogicObj.m_RegQueryTabDataGrid=InitRegQueryTabDataGrid();
		//页面元素初始化
		PageHandle();
	}
}
function InitEvent(){
	$("#BFind").click(RegQueryTabDataGridLoad);
	$("#Bclear").click(BClearHandle);
	$("#BReadCard").click(ReadCardClickHandle);
	$("#CardNo").keydown(CardNoKeydownHandler);
	$('#CardNo').change(CardNoChange);
	$("#RegNo").keydown(RegNoKeydownHandler);
	document.onkeydown = DocumentOnKeyDown;
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
	//浏览器中Backspace不可用  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        e.preventDefault();   
    }  
}
function InitRegQueryTabDataGrid(){
	/* 
	原号重打移至退号界面
	{
		id:"rePrint",
		text: '重打',
		iconCls: 'icon-print',
		handler: function(){ReprintClickHandler();}
	}, */	
	PageLogicObj.toolbar=[{
		id:"Export",
		text: '导出',
		iconCls: 'icon-arrow-right-top',
		handler: function(){ExportClick();}
	}]
	var Columns=[[ 
		{field:'TRegisFee',hidden:true,title:''},
		{field:'TPatNo',title:'登记号',width:100},
		{field:'TPatMNo',title:'病历号',width:80},
		{field:'TPatName',title:'姓名',width:80},
		{field:'TRegLoc',title:'科室',width:120},
		{field:'TRegDoc',title:'号别',width:140},
		{field:'TArriveDoc',title:'看诊医生',width:100},
		{field:'TRegDate',title:'就诊日期',width:100},
		{field:'TRegFee',title:'挂号费',width:50},
		{field:'TFormFee',title:'工本费',width:50},
		{field:'TExamFee',title:'诊疗费',width:50},
		{field:'TUsrCode',title:'挂号员',width:80},
		{field:'TUsrName',title:'挂号员姓名',width:80},
		{field:'TRegTime',title:'挂号时间',width:150},
		{field:'TRefUsr',title:'退号员',width:80},
		{field:'TRefUsrname',title:'退号员姓名',width:90},
		{field:'TRefTime',title:'退号时间',width:100},
		{field:'TRegNo',title:'顺序号',width:50},
		{field:'TRegType',title:'挂号类型',width:90},
		{field:'TAddflag',title:'加号',width:90},
		{field:'THandDate',title:'结账日期',width:90},
		{field:'TPatCardNo',title:'卡号',width:120},
		{field:'TInvNo',title:'发票号',width:110},
		{field:'TPayMode',title:'支付方式',width:280},	
		{field:'TimeRangeInfo',title:'建议就诊时段',width:150},
		{field:'TabReturnReason',title:'退号原因',width:90},
		{field:'TTelHome',title:'联系电话',width:90},
		{field:'TSessionType',title:'挂号职称',width:100},
		{field:'TRoom',title:'诊室',width:90},
		{field:'TPoliticalLevel',title:'患者级别',width:90},
		{field:'TSecretLevel',title:'患者密级',width:90}
    ]]
	var RegQueryTabDataGrid=$("#RegQueryTab").datagrid({
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
		idField:'TRegisFee',
		columns :Columns,
		toolbar:PageLogicObj.toolbar,
		onSelect:function(index, row){
			//ChangeButtonStatus(row);
		},
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_RegQueryTabDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_RegQueryTabDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_RegQueryTabDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		}
	});
	return RegQueryTabDataGrid;
}
function RegQueryTabDataGridLoad(){
	var selfHosp = true;//$("#SelfHosp").checkbox('getValue');
	var payMode = $("#PayMode").combobox('getValue')+"^";
	var RMarkdesc=$("#RMarkdesc").combobox('getValue');
	var HospID=$HUI.combogrid('#_HospUserList').getValue();
	if (!RMarkdesc) RMarkdesc="";
	if (selfHosp) payMode = $("#PayMode").combobox('getValue')+"^"+HospID+"^"+$("#TelHome").val()+"^"+RMarkdesc;
	else payMode = $("#PayMode").combobox('getValue')+"^^"+$("#TelHome").val()+"^"+RMarkdesc;
	payMode=payMode+"^"+$("#SessionType").combobox('getText')
	$.cm({
	    ClassName : "web.DHCOPRegReports",
	    QueryName : "RegQuery",
	    StDate:$("#StDate").datebox('getValue'),
	    EdDate:$("#EdDate").datebox('getValue'),
	    StTime:$("#StTime").timespinner('getValue'),
	    EdTime:$("#EdTime").timespinner('getValue'),
	    SuseID:$("#Ghuse").combobox('getValue'),
	    RLoc:$("#RLocdesc").combobox('getValue'),
	    RDoc:$("#RDocdesc").combobox('getValue'),
	    RType:"",
	    Rflag:$HUI.checkbox('#Rflag').getValue() ? "on" : "",
	    FeeNullCheck:$HUI.checkbox('#FeeNullCheck').getValue() ? "on" : "",
	    CardNo:$("#CardNo").val(),
	    RegNo:$("#RegNo").val(),
	    PatName:$("#PatName").val(),
	    MRRFlag:$HUI.checkbox('#MRRFlag').getValue() ? "on" : "",
	    DRCDRowid:$("#DRCDDesc").combobox('getValue'),
	    PayMode:payMode,
	    Pagerows:PageLogicObj.m_RegQueryTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_RegQueryTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	});
}
function LoadGhuse(){
	var HospID=$HUI.combogrid('#_HospUserList').getValue();
	$.cm({
		ClassName:"web.DHCUserGroup",
		QueryName:"Finduse1",
		Desc:"",
		HOSPID:HospID,
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#Ghuse", {
				valueField: 'SSUSR_RowId',
				textField: 'SSUSR_Name', 
				editable:true,
				enterNullValueClear:false,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["SSUSR_Name"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["SSUSR_Initials"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				}
		 });
	});
}
function LoadDept(){
	var HospID=$HUI.combogrid('#_HospUserList').getValue();
	$.cm({
		ClassName:"web.DHCOPReg",
		QueryName:"OPLoclookup",
		desc:"", hospid:HospID,
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#RLocdesc", {
				valueField: 'rowid',
				textField: 'OPLocdesc', 
				editable:true,
				data: GridData["rows"],
				enterNullValueClear:false,
				filter: function(q, row){
					return (row["OPLocdesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(row["Alias"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},
				onSelect:function(rec){
					$("#RDocdesc").combobox("select","");
					$("#RMarkdesc").combobox("select","");
					LoadMarkDoc();
					 LoadDoc();
				},
				onChange:function(newValue,oldValue){
					if (newValue==""){
						$("#RLocdesc,#RDocdesc,#RMarkdesc").combobox("select","");
						LoadMarkDoc("");
						LoadDoc("");
					}
				}
		 });
	});
}
function LoadMarkDoc(){
	$.cm({
		ClassName:"web.DHCOPRegReports",
		QueryName:"OPDoclookup",
		locid:$("#RLocdesc").combobox('getValue'),
		DocDesc:"",
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#RMarkdesc", {
				valueField: 'rowid',
				textField: 'OPLocdesc', 
				editable:true,
				enterNullValueClear:false,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["OPLocdesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(row["Code"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				}
		 });
	});
}
function LoadDoc(){
	$.cm({
		ClassName:"web.DHCOPRegReports",
		QueryName:"OPDoclookup",
		locid:$("#RLocdesc").combobox('getValue'),
		DocDesc:"",
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#RDocdesc", {
				valueField: 'rowid',
				textField: 'OPLocdesc', 
				editable:true,
				enterNullValueClear:false,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["OPLocdesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(row["Code"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				}
		 });
	});
}
function LoadRegConDisList() {
	var HospID=$HUI.combogrid('#_HospUserList').getValue();
	$.m({
		ClassName:"web.DHCRegConDisCount", 
		MethodName:"ReadDHCRegConDisCountBroker",
		JSFunName:"GetRegConToHUIJson",
		ListName:"",
		PatientID:"",
		BillTypeID:"",
		ExpStr:"",
		HospId:HospID
	},function(Data){
		var cbox = $HUI.combobox("#DRCDDesc", {
				valueField: 'id',
				textField: 'text', 
				panelHeight:'160',
				editable:true,
				data: JSON.parse(Data),
				enterNullValueClear:false
		})
	})
}

/*
旧方法未做院区区分，与挂号界面统一调用方法
*/
function LoadRegConDis(){
	$.cm({
		ClassName:"web.DHCOPRegReports",
		QueryName:"FindDHCRegConDis",
		rows:99999  
	},function(GridData){
		var cbox = $HUI.combobox("#DRCDDesc", {
				valueField: 'DRCDRowid',
				textField: 'DRCDDesc', 
				editable:true,
				enterNullValueClear:false,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["DRCDDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				}
		 });
	});
}
function LoadPayMode(){
	$.cm({
		ClassName:"web.UDHCOPOtherLB",
		MethodName:"ReadPayModeBroker",
		JSFunName:"GetPayModeToHUIJson", ListName:""
	},function(Data){
		//Data.splice(0,1); 
		var cbox = $HUI.combobox("#PayMode", {
				valueField: 'id',
				textField: 'text', 
				editable:false,
				data: Data,
				filter: function(q, row){
					return (row["text"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				}
		 });
	});
}
function BClearHandle(){
	$(".hisui-combobox").combobox('select','');
	$("#SessionType").combobox('setValues','');
	$(".hisui-timespinner").timespinner('setValue','')
	$("#CardTypeNew,#CardNo,#RegNo,#PatName,#TelHome").val('');
	$("#StDate,#EdDate").datebox('setValue',ServerObj.CurDate);
	$("#FeeNullCheck,#MRRFlag,#Rflag").checkbox('setValue',false);  //#SelfHosp
	setTimeout(function(){RegQueryTabDataGridLoad();});
}
function CardNoChange(){
	var CardNo=$("#CardNo").val();
	if (CardNo==""){
		$("#CardTypeNew").val("");
	}
}
function ReadCardClickHandle(){
	DHCACC_GetAccInfo7(CardNoKeyDownCallBack);
}
function CardNoKeydownHandler(e){
	var key=websys_getKey(e);
	if (key==13) {
		var CardNo=$("#CardNo").val();
		if (CardNo=="") return;
		var myrtn=DHCACC_GetAccInfo("",CardNo,"","",CardNoKeyDownCallBack);
		return false;
	}
}
function CardNoKeyDownCallBack(myrtn){
   var myary=myrtn.split("^");
   var rtn=myary[0];
	switch (rtn){
		case "0": //卡有效有帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			$("#CardNo").focus().val(CardNo);
			RegQueryTabDataGridLoad();
			event.keyCode=13;			
			break;
		case "-200": //卡无效
			$.messager.alert("提示","卡无效","info",function(){$("#CardNo").focus();});
			break;
		case "-201": //卡有效无帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			$("#CardNo").focus().val(CardNo);
			RegQueryTabDataGridLoad();
			event.keyCode=13;
			break;
		default:
	}
}
function RegNoKeydownHandler(e){
	var key=websys_getKey(e);
	if (key==13) {
		var RegNo=$("#RegNo").val();
		if (RegNo=="") return;
		var RegNoLength=10;
		if ((RegNo.length<RegNoLength)&&(RegNoLength!=0)) {
			for (var i=(RegNoLength-RegNo.length-1); i>=0; i--) {
				RegNo="0"+RegNo;
			}
		}
		$("#RegNo").val(RegNo);
		RegQueryTabDataGridLoad();
		return false;
	}
}
function ReprintClickHandler(){
	var row=PageLogicObj.m_RegQueryTabDataGrid.datagrid('getSelected');
	if (!row){
		$.messager.alert("提示","请选择需要重打的挂号记录!");
		return false;
	}
	if (row["TRefUsr"]!=""){
		$.messager.alert("提示","已退号不能重打!");
		return false;
	}
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCOPAdmRegPrint");
	var RegRowId=row["TRegisFee"];
	var userid=session['LOGON.USERID'];	
	var groupid=session['LOGON.GROUPID'];	
	var ctlocid=session['LOGON.CTLOCID'];
	var ret=$.cm({
		ClassName:"web.DHCOPAdmReg",
		MethodName:"GetPrintData",
		dataType:"text",
		RegfeeRowId:RegRowId, AppFlag:"", RePrintFlag:"Y"
	},false);
	PrintOut(ret);
	$.messager.alert("提示","重打成功!");
} 
function PrintOut(PrintData) {
	try {
		if (PrintData=="") return;
		var PrintArr=PrintData.split("^");
		var AdmNo=PrintArr[0];
		var PatName=PrintArr[1];
		var RegDep=PrintArr[2];
		var DocDesc=PrintArr[3];
		var SessionType=PrintArr[4];
		var MarkDesc=DocDesc
		var AdmDateStr=PrintArr[5];
		var TimeRange=PrintArr[6];
		var AdmDateStr=AdmDateStr+" "+TimeRange;
		var SeqNo=PrintArr[7];
		var RoomNo=PrintArr[8];
		var RoomFloor=PrintArr[9];
		var UserCode=PrintArr[10];
		var RegDateYear=PrintArr[12];
		var RegDateMonth=PrintArr[13];
		var RegDateDay=PrintArr[14];
		var TransactionNo=PrintArr[15];
		var Total=PrintArr[16];
		var RegFee=PrintArr[17];
		var AppFee=PrintArr[18];
		var OtherFee=PrintArr[19];
		var ClinicGroup=PrintArr[20];
		var RegTime=PrintArr[21];
		var ExabMemo=PrintArr[23];
		var InsuPayCash=PrintArr[24];
		var InsuPayCount=PrintArr[25];
		var InsuPayFund=PrintArr[26];
		var InsuPayOverallPlanning=PrintArr[27];
		var InsuPayOther=PrintArr[28];
		var TotalRMBDX=PrintArr[29];
		var INVPRTNo=PrintArr[30];
		var CardNo=PrintArr[31];
		var Room=PrintArr[32];
		var AdmReason=PrintArr[33];
		var Regitems=PrintArr[34];
		var AccBalance=PrintArr[35];
		var PatNo=PrintArr[36];
		var TimeRangeInfo=PrintArr[37];
		var HospitalDesc=PrintArr[38];
		var PersonPay=PrintArr[39];
		var YBPay=PrintArr[40];
		var DYIPMRN=PrintArr[41];
		var RowID=PrintArr[42];
		var PayModeStr1=PrintArr[46];
		var PayModeStr2=PrintArr[47];
		var MyList="";
		for (var i=0;i<Regitems.split("!").length-1;i++){
			var tempBillStr=Regitems.split("!")[i];
			if (tempBillStr=="") continue;
			var tempBillDesc=tempBillStr.split("[")[0];
			var tempBillAmount=tempBillStr.split("[")[1];
			if (MyList=="") MyList=tempBillDesc+"   "+tempBillAmount;
			else  MyList = MyList + String.fromCharCode(2)+tempBillDesc+"   "+tempBillAmount;
		}

		//病人自负比例的备注
		var ProportionNote="";
		var ProportionNote1="";
		var ProportionNote2="";
		InsuPayCash="";
		InsuPayCount="";
		InsuPayOverallPlanning="";
		InsuPayOther="";
		ProportionNote="本收据中,"+RegFee+"元"+"不属于医保报销范围";
		ProportionNote1="";
		ProportionNote2="";
		var NeedCardFee=false;
		var CardFee=0;
 		if (NeedCardFee==true){
 			var CardFee="工本费 "+parseFloat(CardFee)+"元";
 		}else{
 			var CardFee="";
 		}
		RegTime=RegDateYear+"-"+RegDateMonth+"-"+RegDateDay+" "+RegTime
		if (AccBalance=="") AccBalance=0;
		//重打不显示消费金额。
		//消费后金额
		AccTotal="" //SaveNumbleFaxed(AccBalance);
		//消费前金额
    	AccAmount="" //SaveNumbleFaxed(parseFloat(AccBalance)+parseFloat(Total));
		var cardnoprint=$('#CardNo').val();
		if (cardnoprint=="") {
			var row=PageLogicObj.m_RegQueryTabDataGrid.datagrid('getSelected');
			cardnoprint=row['TPatCardNo'];
		}
		var TimeD=TimeRange;
		if (AppFee!=0){AppFee="预约费:"+AppFee}else{AppFee=""}
		if (OtherFee!=0) {OtherFee="治疗费:"+OtherFee}else{OtherFee=""}
		var PDlime=String.fromCharCode(2);
		var MyPara="AdmNo"+PDlime+AdmNo+"^"+"PatName"+PDlime+PatName+"^"+"TransactionNo"+PDlime+TransactionNo+"^"+"AccTotal"+PDlime+AccTotal+"^"+"AccAmount"+PDlime+AccAmount;
		var MyPara=MyPara+"^"+"MarkDesc"+PDlime+MarkDesc+"^"+"AdmDate"+PDlime+AdmDateStr+"^"+"SeqNo"+PDlime+SeqNo+"^RegDep"+PDlime+RegDep;
		var MyPara=MyPara+"^"+"RoomFloor"+PDlime+RoomFloor+"^"+"UserCode"+PDlime+UserCode;
		var MyPara=MyPara+"^"+"RegDateYear"+PDlime+RegDateYear+"^RegDateMonth"+PDlime+RegDateMonth+"^RegDateDay"+PDlime+RegDateDay;
		var MyPara=MyPara+"^"+"Total"+PDlime+Total+"^RegFee"+PDlime+RegFee+"^AppFee"+PDlime+AppFee+"^OtherFee"+PDlime+OtherFee;
		var MyPara=MyPara+"^"+"RoomNo"+PDlime+RoomNo+"^"+"ClinicGroup"+PDlime+ClinicGroup+"^"+"SessionType"+PDlime+SessionType+"^"+"TimeD"+PDlime+TimeD+"^"+"RegTime"+PDlime+RegTime+"^"+"cardnoprint"+PDlime+cardnoprint;
		var MyPara=MyPara+"^"+"INVPRTNo"+PDlime+INVPRTNo;
		var MyPara=MyPara+"^"+"TimeRangeInfo"+PDlime+TimeRangeInfo;
		var MyPara=MyPara+"^"+"YBPay"+PDlime+YBPay;
		var MyPara=MyPara+"^"+"PersonPay"+PDlime+PersonPay;
		var MyPara=MyPara+"^"+"RowID"+PDlime+RowID;
		var MyPara=MyPara+"^"+"DYIPMRN"+PDlime+Trim(DYIPMRN);
		var MyPara=MyPara+"^"+"ExabMemo"+PDlime+ExabMemo;
		var MyPara=MyPara+"^"+"PatNo"+PDlime+PatNo;       //打印登记号
		var MyPara=MyPara+"^"+"HospName"+PDlime+HospitalDesc+"^"+"paymoderstr1"+PDlime+PayModeStr1+"^"+"paymoderstr2"+PDlime+PayModeStr2;
		var myobj=document.getElementById("ClsBillPrint");
		PrintFun(myobj,MyPara,"");	
	} catch(e) {$.messager.alert("提示",e.message)};
}

function PrintFun(PObj,inpara,inlist){
	////DHCPrtComm.js
	try{
		var mystr="";
		for (var i= 0; i<PrtAryData.length;i++){
			mystr=mystr + PrtAryData[i];
		}
		inpara=DHCP_TextEncoder(inpara)
		inlist=DHCP_TextEncoder(inlist)
		var docobj=new ActiveXObject("MSXML2.DOMDocument.4.0");
		docobj.async = false;    //close
		var rtn=docobj.loadXML(mystr);
		if ((rtn)){
			var rtn=PObj.ToPrintDocNew(inpara,inlist,docobj);
		}
	}catch(e){
		$.messager.alert("提示",e.message);
		return;
	}
}
function Trim(str){
	return str.replace(/[\t\n\r ]/g, "");
}
function SaveNumbleFaxed(str){
	var len,StrTemp;	
	if((str=="")||(!str)) return 0;
	if(parseInt(str)==str){
		str=str+".00";
		}else{
		StrTemp=str.toString().split(".")[1];
		len=StrTemp.length;
		if(len==1){
			str=str+"0";
		}else{
			var myAry=str.toString().split(".");
			str=myAry[0]+"."+myAry[1].substring(0,2);
		}
	}
	
	return str;
}
function ExportClick(){
	var selfHosp = true; 
	var HospID=$HUI.combogrid('#_HospUserList').getValue();
	//$("#SelfHosp").checkbox('getValue');
	/*var payMode = $("#PayMode").combobox('getValue')+"^";
	if (selfHosp) payMode = $("#PayMode").combobox('getValue')+"^"+session['LOGON.HOSPID']+"^"+$("#RMarkdesc").combobox('getValue');*/
	if (selfHosp) payMode = $("#PayMode").combobox('getValue')+"^"+HospID+"^"+$("#TelHome").val()+"^"+$("#RMarkdesc").combobox('getValue');
	else payMode = $("#PayMode").combobox('getValue')+"^^"+$("#TelHome").val()+"^"+$("#RMarkdesc").combobox('getValue');
	payMode=payMode+"^"+$("#SessionType").combobox('getText')
	
	$cm({
	    ExcelName:"挂号查询明细",
		localDir:"Self", 
	    ResultSetType:"ExcelPlugin",
		ClassName:'web.DHCOPRegReports',
		QueryName:'RegQuery',
		StDate:$("#StDate").datebox('getValue'),
	    EdDate:$("#EdDate").datebox('getValue'),
	    StTime:$("#StTime").timespinner('getValue'),
	    EdTime:$("#EdTime").timespinner('getValue'),
	    SuseID:$("#Ghuse").combobox('getValue'),
	    RLoc:$("#RLocdesc").combobox('getValue'),
	    RDoc:$("#RDocdesc").combobox('getValue'),
	    RType:"",
	    Rflag:$HUI.checkbox('#Rflag').getValue() ? "on" : "",
	    FeeNullCheck:$HUI.checkbox('#FeeNullCheck').getValue() ? "on" : "",
	    CardNo:$("#CardNo").val(),
	    RegNo:$("#RegNo").val(),
	    PatName:$("#PatName").val(),
	    MRRFlag:$HUI.checkbox('#MRRFlag').getValue() ? "on" : "",
	    DRCDRowid:$("#DRCDDesc").combobox('getValue'),
	    PayMode:payMode,
	}, false);
}
function ExportClickOld(){
	var path=$.cm({
		ClassName:"web.UDHCJFCOMMON",
		MethodName:"getpath",
		dataType:"text"
	},false);
	var Template=path+"DHCOPRegRegQuery.xls";
	try{
		var oXL = new ActiveXObject("Excel.Application"); 
		var oWB = oXL.Workbooks.Add(Template); 
		var oSheet = oWB.ActiveSheet; 
		var UserID=session['LOGON.USERID'];
		var mainrows=$.cm({
			ClassName:"web.DHCOPRegReports",
			MethodName:"getRegQueryNum",
			dataType:"text",
			user:UserID, inum:""
		},false);
		for (i=0;i<mainrows;i++){
			var PrintSet=$.cm({
				ClassName:"web.DHCOPRegReports",
				MethodName:"getRegQueryNum",
				dataType:"text",
				user:UserID, inum:i+1
			},false);
			var sstr=PrintSet.split("^")
			for (j=0;j<sstr.length;j++) {
				oSheet.Cells(i+2,j+1).value =sstr[j];
			}
		}
        $.messager.alert("提示","文件将保存在您的E盘根目录下","info",function(){
	        var savePath="E:\\挂号查询明细.xls";
			oSheet.saveas(savePath);
			oWB.Close (savechanges=false);
			oXL.Quit();
			oXL=null;
			oSheet=null;
	    });		
	}
	catch(e) {
		$.messager.alert("提示","要打印该表您必须安装Excel电子表格软件,同时浏览器须使用'ActiveX 控件',您的浏览器须允许执行控件 请点击帮助了解浏览器设置方法");
		return "";
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
function LoadSessionType(){
	$.cm({
		ClassName:"web.DHCDocSessContrast",
		QueryName:"QuerySessList",
		date:ServerObj.CurDateStr,
		HospID:$HUI.combogrid('#_HospUserList').getValue(),
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#SessionType", {
				valueField: 'SessRowid',
				textField: 'SessDesc', 
				editable:true,
				enterNullValueClear:false,
				data: GridData["rows"],
				multiple:true,
				rowStyle:'checkbox', //显示成勾选行形式
				filter: function(q, row){
					return (row["Desc"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(row["Code"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				}
		 });
	});
	}