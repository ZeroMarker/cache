var PageLogicObj={
	m_PatListTabDataGrid:"",
	m_FindFlag:0,
	m_PAAdmRowId:"",
	m_ConflictCehckStr:"cOutStatus^cInStatus^cDisInStatus",
	m_EpisodeID:"",
	m_PatientID:""
}
$(window).load(function() {
	var OFlag = $("#cOutStatus").checkbox('getValue');
	var cInStatus=$("#cInStatus").checkbox('getValue');
	var cDisInStatus=$("#cDisInStatus").checkbox('getValue');
	if ((OFlag)&&(!cInStatus)&&(!cDisInStatus)) {
		$("#WardDesc").combobox('disable');
	}else {
		$("#WardDesc").combobox('enable');
	}
})
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
	$("#CardNo").focus();
})
function PageHandle(){
	$("#Startdate,#Enddate").datebox('setValue',ServerObj.NowDate);
	//科室
	LoadDept(); 
	//医生
	LoadDoc();
	//病区
	LoadWard();
	//姓名
	IntNameLookUp();
	//诊断
	IntDiagnosisLookUp();
	//初始化条件
	InitFindType();
	//OPDocLogTabDataGridLoad();
	if ((session['LOGON.GROUPDESC']=='手术护士')){
		$("#PatMed").focus();
	}
	var frm=dhcsys_getmenuform();
	if (frm){
		PageLogicObj.m_EpisodeID=frm.EpisodeID.value;
		PageLogicObj.m_PatientID=frm.PatientID.value;
	}
}
function Init(){
	var hospComp = GenUserHospComp();
	hospComp.jdata.options.onSelect = function(e,t){
		var HospID=t.HOSPRowId;
		PageHandle();
	}
	PageLogicObj.m_PatListTabDataGrid=InitPatListTabDataGrid();
}
function InitEvent(){
	$("#BFind").click(PatListTabDataGridLoad);
	$("#BReadCard").click(ReadCardClickHandle);
	$("#BClear").click(BClearClickHandle);
	$("#CardNo").change(CardNoChange);
	$("#BPrint").click(function(){
		ExportPrintCommon("Print");
	}); //PrintClickHandle
	$("#BExport").click(function(){
		ExportPrintCommon("Export");
	});   //ExprotClickHandle 
	$HUI.checkbox(".hisui-checkbox",{
        onChecked:function(e,value){
            var id=e.currentTarget.id;
            chekboxChange(id);
        }
    });
	document.onkeydown = DocumentOnKeyDown;
}
function InitPatListTabDataGrid(){
	var Columns=[[ 
		{field:'SerialNumber',title:'序号',width:40,align:'center'},
		{field:'PatientID',hidden:true,title:''},
		{field:'AdmDate',title:'就诊日期',width:100},
		{field:'AdmTime',title:'就诊时间',width:80},
		{field:'AdmDept',title:'就诊科室',width:120},
		{field:'AdmDoc',title:'医生',width:100},
		{field:'AdmReason',title:'费别',width:70},
		{field:'AdmType',title:'就诊类型',width:70},
		{field:'PAAdmWard',title:'病区',width:120},
		{field:'PAAdmBed',title:'床位',width:50},
		{field:'PatName1',title:'姓名',width:100}, 
		{field:'PatSex1',title:'性别',width:50}, 
		{field:'PatientMedicare',title:'病案号',width:80}, 
		{field:'RegNo',title:'登记号',width:100},
        {field:'AdmDischgDate',title:'出院日期',width:100},
        {field:'PAADMDischgTime',title:'出院时间',width:80},
		{field:'MRDiagnoseDesc',title:'诊断',width:120},
		{field:'baseinfo',title:'基本信息',width:70,align:'center',
			formatter: function(value,row,index){
				var btn = '<a class="editcls" onclick="BPatBaseInfo(\'' + row["EpisodeID"] + '\')"><img src="../images/webemr/regalert.gif"></a>';
				return btn;
			}
		},
		{field:'EpisodeID',title:'就诊号',width:80},
		{field:'VisitStatus',title:'病人状态',width:80},
		{field:'AddPilotProPat',title:'加入科研项目',width:100,align:'center',
			formatter: function(value,row,index){
				var btn = '<a class="editcls" onclick="BAddPilotProPat(\'' + row["EpisodeID"] + '\' , \''+row["EpisodeID"] + '\')"><img src="../images/websys/new.gif"></a>';
				return btn;
			}
		}, 
		{field:'TelPhone',title:'联系电话',width:120},
		{field:'PatPoliticalLevel',title:'患者级别',width:100},
		{field:'PatSecretLevel',title:'患者密级',width:100}
    ]]
	var PatListTabDataGrid=$("#PatListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'EpisodeID',
		columns :Columns,
		onCheck:function(index, row){
			if ((!(typeof window.parent.SetChildPatNo == "function"))&&(!(typeof window.parent.ChangePerson === "function"))) {
				var frm=dhcsys_getmenuform();
				if (frm){
					frm.EpisodeID.value=row["EpisodeID"];
					frm.PatientID.value=row["PatientID"];
					if (frm.AnaesthesiaID) frm.AnaesthesiaID.value = "";
					if (frm.canGiveBirth) frm.canGiveBirth.value = "";
					if (frm.PPRowId) frm.PPRowId.value = "";
				}
				if(session['LOGON.GROUPID']=='105'){
					WriteTimeToTXT("EpisodeID="+row["EpisodeID"]+",PatientID="+row["PatientID"]+",病人ID="+row["RegNo"]);
				}
			}
		},
		onDblClickRow:function(index, row){
			var EpisodeID=row["EpisodeID"];
			var AdmID=EpisodeID;
			var PatientID=row["PatientID"];
			var frm=dhcsys_getmenuform();
			//旧版开住院证->患者切换(模态框弹出)
			if (window.name=="BookCreat"){
				if (frm){
					frm.EpisodeID.value=PageLogicObj.m_EpisodeID;
					frm.PatientID.value=PageLogicObj.m_PatientID;
					if (frm.AnaesthesiaID) frm.AnaesthesiaID.value = "";
					if (frm.canGiveBirth) frm.canGiveBirth.value = "";
					if (frm.PPRowId) frm.PPRowId.value = "";
				}
				var Parobj=window.opener
				self.close();
				Parobj.ChangePerson(AdmID,PatientID)
			}
			//新版开住院证->患者切换(hisui弹框)
			if ("function" === typeof window.parent.ChangePerson){
				if (frm){
					frm.EpisodeID.value=PageLogicObj.m_EpisodeID;
					frm.PatientID.value=PageLogicObj.m_PatientID;
					if (frm.AnaesthesiaID) frm.AnaesthesiaID.value = "";
					if (frm.canGiveBirth) frm.canGiveBirth.value = "";
					if (frm.PPRowId) frm.PPRowId.value = "";
				}
				window.parent.ChangePerson(AdmID,PatientID);
				window.parent.destroyDialog("BookCreat");
			}
			//预约/加号->患者查询
			if (typeof window.parent.SetChildPatNo == "function") {
				window.parent.SetChildPatNo(row["RegNo"]);
				window.close()
			}
		},
		onBeforeSelect:function(index, row){
			if ((!(typeof window.parent.SetChildPatNo == "function"))&&(!(typeof window.parent.ChangePerson === "function"))) {
				var oldSelRow=PageLogicObj.m_PatListTabDataGrid.datagrid('getSelected');
				var oldSelIndex=PageLogicObj.m_PatListTabDataGrid.datagrid('getRowIndex',oldSelRow);
				if (oldSelIndex==index){
					PageLogicObj.m_PatListTabDataGrid.datagrid('unselectRow',index);
					var frm=dhcsys_getmenuform();
					if (frm){
						frm.EpisodeID.value="";
						frm.PatientID.value="";
						frm.mradm.value="";
						if (frm.AnaesthesiaID) frm.AnaesthesiaID.value = "";
						if (frm.canGiveBirth) frm.canGiveBirth.value = "";
						if (frm.PPRowId) frm.PPRowId.value = "";
					}
					return false;
				}
			}
		}
	});
	PatListTabDataGrid.datagrid('loadData',{ 'total':'0',rows:[] });
	return PatListTabDataGrid;
}
function LoadDept(){
	var HospID=$HUI.combogrid('#_HospUserList').getValue();
	$.cm({
		ClassName:"web.DHCExamPatList",
		QueryName:"ctloclookup",
	   	desc:"",hospid:HospID,
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#CTLoc", {
				valueField: 'ctlocid',
				textField: 'ctloc', 
				editable:true,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["ctloc"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(row["Alias"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},
				onSelect: function(rec){  
					LoadDoc(); 
					LoadWard(); 
				},
				onChange:function(newValue,oldValue){
					if (newValue==""){
						LoadDoc();
						LoadWard();
					}
				}
		 });
	});
}
function LoadDoc(){
	$.cm({
		ClassName:"web.DHCExamPatList",
		QueryName:"FindDoc",
	   	LocId:$("#CTLoc").combobox('getValue'), DocDesc:"",
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#AdmDoc", {
				valueField: 'DocId',
				textField: 'DocDesc', 
				editable:true,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["DocDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["Alias"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				}
		 });
	});
}
function LoadWard(){
	var LocId=$("#CTLoc").combobox('getValue');
	$.cm({
		ClassName:"web.DHCExamPatList",
		QueryName:"GetWardMessage",
		desc:"", luloc:LocId,
		HospID:$HUI.combogrid('#_HospUserList').getValue(),
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#WardDesc", {
				valueField: 'HIDDEN', 
				textField: 'Ward', 
				editable:true,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["Ward"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(row["Alias"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},
				onLoadSuccess:function(){
					var data=$(this).combobox('getData');
					if ((data.length>0)&&(LocId!="")&&(!OFlag)){
						$(this).combobox('select',data[0]['HIDDEN']);
					}else{
						SetDefaultWard();
					}
					
				}
		 });
	});
}
function SetDefaultWard(){
	var LocId=$("#CTLoc").combobox('getValue');
	if (LocId!=""){
		$("#WardDesc").combobox('select','');
		return;
	}
	var rtn=$.cm({
		ClassName:"web.DHCExamPatList",
		MethodName:"GetDefaultWard",
		PatNo:"", WardID:"", Name:"",
		dataType:"text"
	},false);
	if (rtn!=""){
		$("#WardDesc").combobox('setValue',rtn.split("^")[1]);
	}
}
function IntNameLookUp(){
	$("#Name").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'PAAdmRowId',
        textField:'PatName',
        columns:[[  
			{field:'PatNo',title:'登记号',width:100},
			{field:'PatName',title:'患者姓名',width:100,sortable:true},
			{field:'Birth',title:'出生日期',width:95,sortable:true},
			{field:'PatSex',title:'性别',width:40,sortable:true},
			{field:'InPatFlag',title:'正在住院',width:80,sortable:true},
			{field:'InPatLoc',title:'住院科室',width:120,sortable:true}
        ]], 
        pagination:true,
        panelWidth:500,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCExamPatList',QueryName: 'patnamelookup'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        if (desc=="") return false;
	        var OutStatus=$("#cOutStatus").checkbox('getValue')?'1':'';
		    var InStatus=$("#cInStatus").checkbox('getValue')?'1':'';
		    var DisInStatus=$("#cDisInStatus").checkbox('getValue')?'1':'';
			param = $.extend(param,{PatName:desc,HospDr:$HUI.combogrid('#_HospUserList').getValue()});
	    },
	    onSelect:function(index, row){
		    var PatNo=row['PatNo'];
		    $("#PatNo").val(PatNo);
		    //PageLogicObj.m_PAAdmRowId=row['PAAdmRowId'];
		    FindPatDetail();
		}
    });
}
function IntDiagnosisLookUp() {
	$("#Diagnosis").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'HIDDEN',
        textField:'desc',
        columns:[[  
            {field:'desc',title:'诊断名称',width:300,sortable:true},
			{field:'code',title:'code',width:120,sortable:true},
			{field:'HIDDEN',title:'HIDDEN',width:120,sortable:true,hidden:true}
        ]],
        pagination:true,
        panelWidth:500,
        panelHeight:410,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCMRDiagnos',QueryName: 'LookUpWithAlias'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        var DiaType=""	//$HUI.combobox("#catType").getValue();
			param = $.extend(param,{desc:desc,ICDType:DiaType});
	    },onSelect:function(ind,item){
			
		}
    });	
}
function InitFindType () {
	var responseText=$.cm({
		ClassName:"DHCDoc.DHCDocConfig.CommonFunctionE2",
		MethodName:"GetLocType",
		TLocID:session['LOGON.CTLOCID'],
		dataType:"text"
	},false);
	if ((responseText == "E")||(responseText == "O")) {
		$("#cOutStatus").checkbox("check");
	}
	if (responseText == "I") {
		$("#cInStatus").checkbox("check");
	}
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
			var CardNo=$('#CardNo').val();
			if (CardNo=="") return;
			var myrtn=DHCACC_GetAccInfo("",CardNo,"","","CardNoKeyDownCallBack");
			return false;
		}
		if(SrcObj && SrcObj.id.indexOf("PatNo")>=0){
			var PatNo=$('#PatNo').val();
			if (PatNo=="") return;
			if (PatNo.length<10) {
				for (var i=(10-PatNo.length-1); i>=0; i--) {
					PatNo="0"+PatNo;
				}
			}
			$("#CardTypeNew,#CardNo").val("");
			$('#PatNo').val(PatNo);
			FindPatDetail();
			return false;
		}
		if(SrcObj && SrcObj.id.indexOf("PatMed")>=0){
			$("#CardTypeNew,#CardNo").val("");
			FindPatByMedicare();
			return false;
		}
		return true;
	}
}
function FindPatDetail(){
	var PatNo=$('#PatNo').val();
	if (PatNo!=""){
		//如果是按患者查询则清空开始与截止日期
		$("#Startdate,#Enddate").datebox('setValue','');
		var value=$.cm({
		    ClassName : "web.DHCExamPatList",
		    MethodName : "PatListBroker",
		    itmjs:"1", itmjsex:"", val:PatNo,
		    dataType:"text"
		},false);
		SetPatient_Sel(value);
	}
}
function SetPatient_Sel(value){
	if (value=="0"){
		return;
	}
	var Split_Value=value.split("^");
	/*if (unescape(Split_Value[3])!="") {
		$("#Startdate").datebox('disable').datebox('setValue','');
		$("#Enddate").datebox('disable').datebox('setValue','');
	} else {
		$("#Startdate").datebox('enable').datebox('setValue',ServerObj.NowDate);
		$("#Enddate").datebox('enable').datebox('setValue',ServerObj.NowDate);
	}*/
	$("#Name").val(unescape(Split_Value[0]));
	$("#Birth").val(unescape(Split_Value[1]));
	$("#Sex").val(unescape(Split_Value[2]));
	//$("#PatMed").val(unescape(Split_Value[5]));
	$("#PatNo").val(unescape(Split_Value[3]));
	$("#PapmiDr").val(unescape(Split_Value[23]));
	var PatMed=$("#PatMed").val();
	if ((PatNo=="")&&(PatMed!="")){
		FindPatByMedicare();
	} 
	//PageLogicObj.m_PAAdmRowId="";
	PatListTabDataGridLoad();
	PageLogicObj.m_FindFlag=1;
}
function FindPatByMedicare(){
	var PatMed=$("#PatMed").val();
	var PatNoStr=$.cm({
	    ClassName : "web.DHCExamPatList",
	    MethodName : "GetPatInfoByInMedNo",
	    InMedNO:PatMed,
	    dataType:"text"
	},false);
	if (PatNoStr!=""){
		var Str=PatNoStr.split("^");
		if (Str.length>1){
			var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCDocExamGetPatList&PatNoStr="+PatNoStr; 
	        var PatNo=window.showModalDialog(url,"","dialogwidth:50em;dialogheight:30em;center:1");
		    $("#PatNo").val(PatNo);
		    FindPatDetail();
		}else{
			$("#PatNo").val(Str[0]);
			FindPatDetail();
		}
	}
}
function ReadCardClickHandle(){
	DHCACC_GetAccInfo7(CardNoKeyDownCallBack);
}
function CardNoKeyDownCallBack(myrtn){
	var myary=myrtn.split("^");
	var rtn=myary[0];
	switch (rtn){
		case "0": 
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
    		$("#CardNo").val(CardNo);
    		$("#PatNo").val(PatientNo);
    		FindPatDetail();
			break;
		case "-200": 
			$.messager.alert("提示","卡无效!","info",function(){
				$("#CardTypeNew,#PatNo").val("");
				$("#CardNo").focus();
			});
			break;
		case "-201": 
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
    		$("#CardNo").val(CardNo);
    		$("#PatNo").val(PatientNo);
    		FindPatDetail();
			break;
		default:
			break;
	}
}
function CardNoChange(){
	var CardNo=$('#CardNo').val();
	if (CardNo==""){
		$("#PatientID,#CardTypeNew").val("");
	}
}
function BClearClickHandle(){
	$(".textbox").val('');
	$("#SAge,#EAge").numberbox('setValue','');
	$(".hisui-combobox").combobox('select','');
	$("#Startdate,#Enddate").datebox('setValue',ServerObj.NowDate);
	$("#cOutStatus,#cInStatus,#cDisInStatus").checkbox('setValue',false);
	$("#Name").lookup('setText','');
	$("#PatMed").removeAttr("disabled");
	$("#WardDesc").combobox('enable');
	PageLogicObj.m_PAAdmRowId="";
	PageLogicObj.m_PatListTabDataGrid.datagrid('loadData', {"total":0,"rows":[]});
	//setTimeout(function(){PatListTabDataGridLoad();});
}
function GetPrintDetailData(){
	var PrintFlag="Y";
	return PatListTabDataGridLoad(PrintFlag);
}
function PrintClickHandle(){
	try {   
	    if (PageLogicObj.m_FindFlag==0){
		    $.messager.alert("提示","请先点击查找后再打印!");
		    return false;
		}
		var TemplatePath=$.cm({
			ClassName:"web.UDHCJFCOMMON",
			MethodName:"getpath",
			dataType:"text"
		},false);
		var Template=TemplatePath+"DHCExamPatList1.xls";
        var xlApp,xlsheet,xlBook
		//左右边距
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.PageSetup.LeftMargin=15;  
	    xlsheet.PageSetup.RightMargin=0;
		//获取页面数据
		var ReturnValue=$.cm({
			ClassName:"web.DHCExamPatList",
			MethodName:"GetDHCExamPatListMessage",
			UserID:session['LOGON.USERID'], Flag:1, Row:"",
			dataType:"text"
		},false);
	    if (+ReturnValue==0){
		    $.messager.alert("提示","没有需要打印的数据!");
		    return false;
		}
		var myRows=ReturnValue;
		$.messager.confirm('确认对话框', '确定要打印信息?', function(r){
			if (r){
				var xlsrow=2; //用来指定模板的开始行数位置
				var xlsCurcol=0;  //用来指定开始的列数位置
				var NO=myRows/48
			    NO=parseInt(NO)+1;
				var Flag=1
				for (var Row=1;Row<=myRows;Row++){   
				    if (xlsrow==(50*Flag)){
					     Flag=Flag+1;
				         if(ServerObj.HospName!=""){
					        xlsheet.cells(1,1)=ServerObj.HospName+"患者查找单";
					     }else{
						    xlsheet.cells(1,1)="患者查找单";
						 }
						 xlsheet.PrintOut;
						 var xlsrow=2;
					     var xlsCurcol=0;
					     xlApp = new ActiveXObject("Excel.Application");
					     xlBook = xlApp.Workbooks.Add(Template);
					     xlsheet = xlBook.ActiveSheet; 
					     xlsheet.PageSetup.LeftMargin=15;  
				    	 xlsheet.PageSetup.RightMargin=0;
				    	
					}
					xlsrow=xlsrow+1; //从第三行开始
					//获取页面数据
					var StrData=$.cm({
						ClassName:"web.DHCExamPatList",
						MethodName:"GetDHCExamPatListMessage",
						UserID:session['LOGON.USERID'], Flag:2, Row:Row,
						dataType:"text"
					},false);
		            var DataValue=StrData.split("^")
		            xlsheet.cells(xlsrow,xlsCurcol+1)=Row;
		            xlsheet.cells(xlsrow,xlsCurcol+8)=DataValue[0]; //AdmDate 就诊日期
		            xlsheet.cells(xlsrow,xlsCurcol+9)=DataValue[1];//AdmTime 就诊时间
		            xlsheet.cells(xlsrow,xlsCurcol+11)=DataValue[2];//AdmDoC 医生
		            xlsheet.cells(xlsrow,xlsCurcol+7)=DataValue[3];//AdmReasoc 费别
		            xlsheet.cells(xlsrow,xlsCurcol+6)=DataValue[4];//AdmType  就诊类型
		            xlsheet.cells(xlsrow,xlsCurcol+12)=DataValue[5];//PAAdmWard 病区
		            xlsheet.cells(xlsrow,xlsCurcol+13)=DataValue[6];//PAAdmBed 病床
		            xlsheet.cells(xlsrow,xlsCurcol+10)=DataValue[7];//AdmDept 就诊科室
		            xlsheet.cells(xlsrow,xlsCurcol+3)=DataValue[12]; //病人ID
		            xlsheet.cells(xlsrow,xlsCurcol+2)=DataValue[13];//病案号
		            xlsheet.cells(xlsrow,xlsCurcol+14)=DataValue[10];//AdmDischgDate 出院日期
		            xlsheet.cells(xlsrow,xlsCurcol+4)=DataValue[14];// 病人姓名
		            xlsheet.cells(xlsrow,xlsCurcol+5)=DataValue[15]// 病人性别
		        }
		        if(ServerObj.HospName!=""){
			        xlsheet.cells(1,1)=ServerObj.HospName+"患者查找单";
			    }else{
				    xlsheet.cells(1,1)="患者查找单";
				}
				var d=new Date();
				var h=d.getHours();
				var m=d.getMinutes();
				var s=d.getSeconds()
			    xlsheet.PrintOut;
			    xlBook.Close (savechanges=false);
			    xlApp=null;
			    xlApp.Quit();
			    xlsheet=null;
			}
		});		
	} catch(e) {
		//alert(e.message);
	};
}
function PatListTabDataGridLoad(PrintFlag){
	//最后一个参数合并
	var PatNo=$('#PatNo').val();
	var PatMed = $("#PatMed").val();
	var SAge = $("#SAge").val();
	var EAge = $("#EAge").val();
	var Diagnosis = $("#Diagnosis").lookup("getText");
	var HospID=$HUI.combogrid('#_HospUserList').getValue();
	var RequestPatMed = PatMed + "^" + Diagnosis + "^" + SAge + "^" + EAge+"^"+HospID;
	var SDate = $("#Startdate").datebox('getValue');
	var EDate = $("#Enddate").datebox('getValue');
	var OFlag = $("#cOutStatus").checkbox('getValue');
	var IFlag = $("#cInStatus").checkbox('getValue');
	var DisFlag = $("#cDisInStatus").checkbox('getValue');
	if ((!OFlag)&&(!IFlag)&&(!DisFlag)) {
		$.messager.alert("提示","请先选择门/急/住院患者类型进行查询!","info");
		return false;
	}
	var DateFlag = tkMakeServerCall("web.DHCExamPatList","IfSelectDate",SDate,EDate);
	if ((PatNo=="")&&(OFlag)&&(DateFlag!=1)) {
		 $.messager.alert("提示","请选择合适的日期范围,门诊所选择日期在7天之内!","info");
		 return false;
	}
	PageLogicObj.m_FindFlag=1;
	var GridData=$.cm({
	    ClassName : "web.DHCExamPatList",
	    QueryName : "RegFind",
	    UserID:session['LOGON.USERID'],
	    PatNo:$("#PatNo").val(),
	    OutStatus:$("#cOutStatus").checkbox('getValue')?'on':'',
	    InStatus:$("#cInStatus").checkbox('getValue')?'on':'',
	    DisInStatus:$("#cDisInStatus").checkbox('getValue')?'on':'',
	    Startdate:$("#Startdate").datebox('getValue'),
	    Enddate:$("#Enddate").datebox('getValue'),
	    WardID:$("#WardDesc").combobox('getValue'),
	    FindbyDoc:"",
	    CTLoc:$("#CTLoc").combobox('getText'),
	    WardDesc:$("#WardDesc").combobox('getText'),
	    PAAdmRowId:PageLogicObj.m_PAAdmRowId,
	    luloc:$("#CTLoc").combobox('getValue'),
	    AdmDocId:$("#AdmDoc").combobox('getValue'),
	    RequestName:$("#Name").lookup('getText'),
	    RequestPatMed:RequestPatMed,	//$("#PatMed").val(), 
	    Pagerows:PageLogicObj.m_PatListTabDataGrid.datagrid("options").pageSize,
	    rows:99999
	},false);
	if (PrintFlag=="Y") {
		return GridData.rows;
	}else{
		PageLogicObj.m_PatListTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}
}
function chekboxChange(id){
	var rtn=$.cm({
		ClassName:"web.DHCDocConfig",
		MethodName:"GetConfigNode",
		Node:"PatFindMutiSelect",
		dataType:"text"
	},false);
	if (rtn == 0) {
		var ConflictCehckArr=PageLogicObj.m_ConflictCehckStr.split("^");
		for (var i=0;i<ConflictCehckArr.length;i++){
			var tmpId=ConflictCehckArr[i];
			if (tmpId!=id){
				$("#"+tmpId).checkbox('setValue',false);
			}
		}
		if (id == "cOutStatus") {
			$("#PatMed").attr("disabled","disabled").val("");
			$("#WardDesc").combobox('setValue','').combobox('disable');
			
		}
		if ((id == "cInStatus")||(id == "cDisInStatus")) {
			$("#PatMed").removeAttr("disabled");
			$("#WardDesc").combobox('enable');
		}
	}
}
function BPatBaseInfo(EpisodeID){
	//var src="dhc.nurse.vue.mainentry.csp?ViewName=PatInfo&EpisodeID="+EpisodeID;
	var src="dhc.nurse.vue.nis.csp?pageName=patientDetail&EpisodeID="+EpisodeID;
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("Find","患者基本信息", 900, 500,"icon-w-card","",$code,"");
}
function BAddPilotProPat(EpisodeID,PatientID){
	var src="docpilotpro.patadd.hui.csp?EpisodeID="+EpisodeID+"&PatientID="+PatientID;
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("Find","加入科研项目", 1340, 600,"icon-w-add","",$code,"");
}
function WriteTimeToTXT(i){
	var writeStr;
	var userId=session['LOGON.USERID'];
	var myDate = new Date();
	var mytime=myDate.toLocaleTimeString()+":"+myDate.getMilliseconds();
	writeStr="时间:"+mytime;
	/*    
	object.OpenTextFile(filename[, iomode[, create[, format]]])    
	参数object必选项。object 应为 FileSystemObject 的名称。    
	filename必选项。指明要打开文件的字符串表达式。    
	iomode可选项。可以是三个常数之一：ForReading 、 ForWriting 或 ForAppending 。    
	create可选项。Boolean 值，指明当指定的 filename 不存在时是否创建新文件。如果创建新文件则值为 True ，如果不创建则为 False 。如果忽略，则不创建新文件。    
	format可选项。使用三态值中的一个来指明打开文件的格式。如果忽略，那么文件将以 ASCII 格式打开。    
	设置iomode 参数可以是下列设置中的任一种：    
	常数      值  描述    
	ForReading 1 以只读方式打开文件。不能写这个文件。    
	ForWriting 2 以写方式打开文件    
	ForAppending 8 打开文件并从文件末尾开始写。    
	format 参数可以是下列设置中的任一种：    
	值              描述    
	TristateTrue 以 Unicode 格式打开文件。    
	TristateFalse 以 ASCII 格式打开文件。    
	TristateUseDefault 使用系统默认值打开文件。 
	-2系统默认、-1以Unicode 格式、0以ASCII 格式   
	*/     
	var filePath="c://"+userId+"searchLog.txt";
	var objFSO = new ActiveXObject("Scripting.FileSystemObject");
	var objStream;
	if (!objFSO.FileExists(filePath)){    // 检查文件是否存在
   		objStream=objFSO.CreateTextFile(filePath,8,true);
	}else{
		objStream=objFSO.OpenTextFile(filePath,8,false,-1);
	}
	objStream.Write(writeStr+"----"+i+"\r\n");
   	objStream.Close();  // 关闭文件
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
        //href: _url,
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
	    }
    });
}
function destroyDialog(id){
   //移除存在的Dialog
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
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
function ExprotClickHandle() {
	 var PatNo=$('#PatNo').val();
	 var PatMed = $("#PatMed").val();
	 var SAge = $("#SAge").val();
	 var EAge = $("#EAge").val();
	 var Diagnosis = $("#Diagnosis").lookup("getText");
	 var RequestPatMed = PatMed + "^" + Diagnosis + "^" + SAge + "^" + EAge;
	 var SDate = $("#Startdate").datebox('getValue');
	 var EDate = $("#Enddate").datebox('getValue');
	 var OFlag = $("#cOutStatus").checkbox('getValue');
	 var IFlag = $("#cInStatus").checkbox('getValue');
	 var DisFlag = $("#cDisInStatus").checkbox('getValue');
	 if ((!OFlag)&&(!IFlag)&&(!DisFlag)) {
	   $.messager.alert("提示","请先选择门/急/住院患者类型进行查询!","info");
	   return false;
	 }
	 var DateFlag = tkMakeServerCall("web.DHCExamPatList","IfSelectDate",SDate,EDate);
	 if ((PatNo=="")&&(OFlag)&&(DateFlag!=1)) {
	    $.messager.alert("提示","请选择合适的日期范围,门诊所选择日期在7天之内!","info");
	    return false;
	 }
	 var FileName="PatListQuery";
	 var oXL = new ActiveXObject("Excel.Application"); //创建AX对象excel   
	 var oWB = oXL.Workbooks.Add(); //获取workbook对象   
	 var oSheet = oWB.ActiveSheet; //激活当前sheet
	 oSheet.Columns.NumberFormatLocal = "@";
	 //设置工作薄名称  
	 oSheet.name = FileName; 
	 PageLogicObj.m_FindFlag=1;
	 $.cm({
	     ClassName : "web.DHCExamPatList",
	     QueryName : "RegFind",
	     UserID:session['LOGON.USERID'],
	     PatNo:$("#PatNo").val(),
	     OutStatus:$("#cOutStatus").checkbox('getValue')?'on':'',
	     InStatus:$("#cInStatus").checkbox('getValue')?'on':'',
	     DisInStatus:$("#cDisInStatus").checkbox('getValue')?'on':'',
	     Startdate:$("#Startdate").datebox('getValue'),
	     Enddate:$("#Enddate").datebox('getValue'),
	     WardID:$("#WardDesc").combobox('getValue'),
	     FindbyDoc:"",
	     CTLoc:$("#CTLoc").combobox('getText'),
	     WardDesc:$("#WardDesc").combobox('getText'),
	     PAAdmRowId:PageLogicObj.m_PAAdmRowId,
	     luloc:$("#CTLoc").combobox('getValue'),
	     AdmDocId:$("#AdmDoc").combobox('getValue'),
	     RequestName:$("#Name").lookup('getText'),
	     RequestPatMed:RequestPatMed, //$("#PatMed").val(), 
	    rows:99999
	 },function(data){
	  try{
	   var rowArr=data.rows; 
	   if(rowArr.length==0) return;
	   var columns=$("#PatListTab").datagrid('options').columns[0];   
	   for(var i=0; i<rowArr.length; i++) {
		   var col=0;
	       for(var j=0; j<columns.length; j++) {
		        if(columns[j].hidden) continue;
		        var field=columns[j].field;
		        if ((field=="baseinfo")||(field=="AddPilotProPat")) continue;
		        if(i==0) oSheet.cells(i+1,col+1)=columns[j].title;
		        var val=rowArr[i][columns[j].field];
		        if(columns[j].formatter) val="";
		        oSheet.cells(i+2,1)=i+1;
		        oSheet.cells(i+2,col+1)=val;
		        col++;
	       }
	   }
	   oXL.Visible = false; //设置excel可见属性
	   var fname = oXL.Application.GetSaveAsFilename(FileName+".xls", "Excel Spreadsheets (*.xls), *.xls");
	   oWB.SaveAs(fname);
	   oWB.Close(savechanges=false);
	   oXL.Quit();
	   oXL=null;
	  }catch(e){
	    $.messager.alert("提示",e.message);
	  };
   });
}
function ExportPrintCommon(ResultSetTypeDo){
	var PatNo=$('#PatNo').val();
	 var PatMed = $("#PatMed").val();
	 var SAge = $("#SAge").val();
	 var EAge = $("#EAge").val();
	 var Diagnosis = $("#Diagnosis").lookup("getText");
	 var RequestPatMed = PatMed + "^" + Diagnosis + "^" + SAge + "^" + EAge;
	 var SDate = $("#Startdate").datebox('getValue');
	 var EDate = $("#Enddate").datebox('getValue');
	 var OFlag = $("#cOutStatus").checkbox('getValue');
	 var IFlag = $("#cInStatus").checkbox('getValue');
	 var DisFlag = $("#cDisInStatus").checkbox('getValue');
	 if ((!OFlag)&&(!IFlag)&&(!DisFlag)) {
	   $.messager.alert("提示","请先选择门/急/住院患者类型进行查询!","info");
	   return false;
	 }
	 var DateFlag = tkMakeServerCall("web.DHCExamPatList","IfSelectDate",SDate,EDate);
	 if ((PatNo=="")&&(OFlag)&&(DateFlag!=1)) {
	    $.messager.alert("提示","请选择合适的日期范围,门诊所选择日期在7天之内!","info");
	    return false;
	 }
	 $.cm({
		 localDir:ResultSetTypeDo=="Export"?"Self":"",
		 ResultSetTypeDo:ResultSetTypeDo,
	     ExcelName:ServerObj.HospName+"患者查找单",
	     ResultSetType:"ExcelPlugin",
	     ClassName : "web.DHCExamPatList",
	     QueryName : "RegFindExport",
	     UserID:session['LOGON.USERID'],
	     PatNo:$("#PatNo").val(),
	     OutStatus:$("#cOutStatus").checkbox('getValue')?'on':'',
	     InStatus:$("#cInStatus").checkbox('getValue')?'on':'',
	     DisInStatus:$("#cDisInStatus").checkbox('getValue')?'on':'',
	     Startdate:$("#Startdate").datebox('getValue'),
	     Enddate:$("#Enddate").datebox('getValue'),
	     WardID:$("#WardDesc").combobox('getValue'),
	     FindbyDoc:"",
	     CTLoc:$("#CTLoc").combobox('getText'),
	     WardDesc:$("#WardDesc").combobox('getText'),
	     PAAdmRowId:PageLogicObj.m_PAAdmRowId,
	     luloc:$("#CTLoc").combobox('getValue'),
	     AdmDocId:$("#AdmDoc").combobox('getValue'),
	     RequestName:$("#Name").lookup('getText'),
	     RequestPatMed:RequestPatMed, //$("#PatMed").val(), 
	     rows:99999
	 },false);
}

//查询方法
function SearchFunLib(){
	var PatNo=$("#PatNo").val();
	//var name=$('#TextDesc').val();
	$('#mygrid').datagrid('load',  { 
		ClassName:"web.DHCExamPatList",
		QueryName:"GetBioBankFlagLog" ,  
		'PatNo':PatNo,   
		//'Name':name
	});
	$('#mygrid').datagrid('unselectAll');
}

//重置方法
function ClearFunLib()
{
	$("#PatNo").val("");
	$('#mygrid').datagrid('load',  { 
		ClassName:"web.DHCExamPatList.cls",
		QueryName:"GetBioBankLog"
	});
	$('#mygrid').datagrid('unselectAll');
}