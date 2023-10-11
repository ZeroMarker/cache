var PageLogicObj={
	m_PatListTabDataGrid:"",
	m_FindFlag:0,
	m_PAAdmRowId:"",
	m_ConflictCehckStr:"cOutStatus^cInStatus^cDisInStatus^cPreStatus",
	m_EpisodeID:"",
	m_PatientID:"",
	m_ShowPatOperBtn: 1
}
$(window).load(function() {
	SetWardStatus();
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
	//身份证
	IntCredNoLookUp();
	//患者费别
	LoadAdmReason()
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
	var HospIdTdWidth=$("#HospIdTd").width()
	var opt={width:HospIdTdWidth}
	var hospComp = GenUserHospComp(opt);
	hospComp.jdata.options.onSelect = function(e,t){
		var HospID=t.HOSPRowId;
		PageHandle();
	}
	PageLogicObj.m_PatListTabDataGrid=InitPatListTabDataGrid();
	// onCheck 不能选中患者的界面，不支持行操作按钮
	if ((typeof window.parent.SetChildPatNo == "function")||(typeof window.parent.ChangePerson == "function")) {
		PageLogicObj.m_ShowPatOperBtn = 0
		PageLogicObj.m_PatListTabDataGrid.datagrid('hideColumn', 'patOperBtn')
	}
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
        onCheckChange:function(e,value){
            var id=e.currentTarget.id;
            chekboxChange(id);
        }
    });
	document.onkeydown = DocumentOnKeyDown;
}
function InitPatListTabDataGrid(){
	var Columns=[[ 
		//序号不连贯 屏蔽序号使用rownumbers
		//{field:'SerialNumber',title:'序号',width:40,align:'center'},
		{field:"patOperBtn", title:'操作', width:225, align:'center',
			formatter: function(value, row, index) {
				var operDiv = '<div id="patOperBtn_'  + index + '" style="width:100%;height:100%"></div>'
				return operDiv
			}
		},
		{field:'RegNo',title:'登记号',width:100,sortable:true},
		{field:'PatName1',title:'姓名',width:100,sortable:false}, 
		{field:'PatientID',hidden:true,title:''},
		{field:'AdmDate',title:'就诊日期',width:90,sortable:true},
		{field:'AdmTime',title:'就诊时间',width:70,sortable:true},
		{field:'AdmDept',title:'就诊科室',width:120,sortable:true},
		{field:'AdmDoc',title:'医生',width:100,sortable:true},
		{field:'AdmReason',title:'费别',width:70,sortable:true},
		{field:'AdmType',title:'就诊类型',width:70,sortable:true},
		{field:'PAAdmWard',title:'病区',width:120,sortable:true},
		{field:'PAAdmBed',title:'床位',width:50,sortable:true},
		
		{field:'PatSex1',title:'性别',width:50,sortable:true}, 
		{field:'PatAge',title:'年龄',width:50,sortable:false}, 
		{field:'PatCredNo',title:'证件号',width:230,sortable:false}, 
		{field:'PatientMedicare',title:'病案号',width:80,sortable:true}, 
		
        {field:'AdmDischgDate',title:'出院日期',width:100,sortable:true},
        {field:'PAADMDischgTime',title:'出院时间',width:80,sortable:true},
		{field:'MRDiagnoseDesc',title:'诊断',width:120,sortable:true},
		{field:'baseinfo',title:'基本信息',width:70,align:'center',
			formatter: function(value,row,index){
				var btn = '<a class="editcls" onclick="BPatBaseInfo(\'' + row["EpisodeID"] + '\' , \''+row["WardId"] + '\')"><img src="../images/webemr/Regalert.gif"></a>';
				return btn;
			}
		},
		{field:'WardId',hidden:true,title:''},
		{field:'EpisodeID',title:'就诊号',width:80,sortable:false},
		{field:'VisitStatus',title:'病人状态',width:80,sortable:true},
		{field:'AddPilotProPat',title:'加入科研项目',width:100,align:'center',
			formatter: function(value,row,index){
				var btn = '<a class="editcls" onclick="BAddPilotProPat(\'' + row["EpisodeID"] + '\' , \''+row["EpisodeID"] + '\')"><img src="../images/websys/new.gif"></a>';
				return btn;
			}
		}, 
		{field:'TelPhone',title:'联系电话',width:120,sortable:true},
		{field:'PatPoliticalLevel',title:'患者级别',width:100,sortable:true},
		{field:'PatSecretLevel',title:'患者密级',width:100,sortable:true}
    ]]
	var PatListTabDataGrid=$("#PatListTab").datagrid({
		fit : true,
		border : false,
		striped : false,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true, 
		rownumbers : true,		
		pageSize: 20,
		pageList : [20,100,200],
		idField:'EpisodeID',
		columns :Columns,
		remoteSort:false,
		onCheck:function(index, row){
			if ((!(typeof window.parent.SetChildPatNo == "function"))&&(!(typeof window.parent.ChangePerson === "function"))) {
				var frm=dhcsys_getmenuform();
				var menuWin=websys_getMenuWin();
				if ((menuWin) &&(menuWin.MainClearEpisodeDetails)) menuWin.MainClearEpisodeDetails();
				if (frm){
					frm.EpisodeID.value=row["EpisodeID"];
					frm.PatientID.value=row["PatientID"];
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
			var menuWin=websys_getMenuWin();
			//旧版开住院证->患者切换(模态框弹出)
			if (window.name=="BookCreat"){
				/*if ((menuWin) &&(menuWin.MainClearEpisodeDetails)) menuWin.MainClearEpisodeDetails();zz
				if (frm){
					frm.EpisodeID.value=PageLogicObj.m_EpisodeID;
					frm.PatientID.value=PageLogicObj.m_PatientID;
				}*/
				var Parobj=window.opener
				self.close();
				Parobj.ChangePerson(AdmID,PatientID)
			}
			//新版开住院证->患者切换(hisui弹框)
			if ("function" === typeof window.parent.ChangePerson){
				/*if ((menuWin) &&(menuWin.MainClearEpisodeDetails)) menuWin.MainClearEpisodeDetails();
				if (frm){
					frm.EpisodeID.value=PageLogicObj.m_EpisodeID;
					frm.PatientID.value=PageLogicObj.m_PatientID;
				}*/
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
		},
		onResizeColumn: function(field, width) {
			if (PageLogicObj.m_ShowPatOperBtn == 1) {
				// 列宽改变，按钮区随之变化
				if (field == "patOperBtn") {
					$(this).datagrid('getPanel').find('td[field="patOperBtn"]').find('.shortcutbar-list-x').panel('resize')
				}
			}
		},
		onLoadSuccess: function(data) {
			if (PageLogicObj.m_ShowPatOperBtn == 1) {
				// 处理行高太小
				$(this).datagrid('getPanel').find('div.datagrid-body tr').find('td[field="patOperBtn"]').children("div").css({   
					"height": "40px" 
				})
				// 处理序号高度
				$(this).datagrid('getPanel').find('.datagrid-td-rownumber').css({   
					"height": "40px"
				})
				$(this).datagrid('getPanel').find('div.datagrid-body tr').find()
				if (data.total > 0) {
					data.rows.forEach(function(value, index, array) {
						$('#patOperBtn_' + index).marybtnbar({
							barCls: 'background:none;padding:5px 0px;',
							queryParams: {ClassName:'DHCDoc.OPDoc.MainFrame',QueryName:'QueryBtnCfg',url:'doc.patlistquery.hui.csp'},
							onBeforeLoad: function(param){
								param.EpisodeID=value.EpisodeID;
							},
							onClick: function(jq,cfg){
								jq.tooltip('hide');
								$("#PatListTab").datagrid("unselectAll")
								$("#PatListTab").datagrid("selectRow", index)
								jumpMenu(cfg)
							}
						})
					});
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
	var HospID=$HUI.combogrid('#_HospUserList').getValue();
	$.cm({
		ClassName:"web.DHCExamPatList",
		QueryName:"FindDoc",
	   	LocId:$("#CTLoc").combobox('getValue'), DocDesc:"",HospID:HospID,
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
					var OFlag = $("#cOutStatus").checkbox('getValue');
					var cInStatus=$("#cInStatus").checkbox('getValue');
					var cDisInStatus=$("#cDisInStatus").checkbox('getValue');
					var data=$(this).combobox('getData');
					if ((OFlag)&&(!cInStatus)&&(!cDisInStatus)) {
						$("#WardDesc").combobox('disable');
					}else{
						$("#WardDesc").combobox('enable');
						if ((data.length>0)&&(LocId!="")&&(!OFlag)){
							$(this).combobox('select',data[0]['HIDDEN']);
						}else{
							SetDefaultWard();
						}
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
		if ($.hisui.indexOfArray($("#WardDesc").combobox('getData'),"HIDDEN",rtn.split("^")[1]) >=0) {
			$("#WardDesc").combobox("setValue",rtn.split("^")[1]);
		}else{
			$("#WardDesc").combobox("setValue","");
		}
	}
}

function IntCredNoLookUp() {
	$("#PatCredNo").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'PAAdmRowId',
        textField:'CredNo',
        columns:[[  
			{field:'PatNo',title:'登记号',width:100},
			{field:'PatName',title:'患者姓名',width:100,sortable:true},
			{field:'Birth',title:'出生日期',width:95,sortable:true},
			{field:'PatSex',title:'性别',width:40,sortable:true},
			{field:'InPatFlag',title:'正在住院',width:80,sortable:true},
			{field:'InPatLoc',title:'住院科室',width:120,sortable:true},
			{field:'CredNo',title:'证件号码',width:120,sortable:true}
        ]], 
        pagination:true,
        panelWidth:500,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCExamPatList',QueryName: 'patcrednolookup'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        if (desc=="") return false;
	        var OutStatus=$("#cOutStatus").checkbox('getValue')?'1':'';
		    var InStatus=$("#cInStatus").checkbox('getValue')?'1':'';
		    var DisInStatus=$("#cDisInStatus").checkbox('getValue')?'1':'';
			param = $.extend(param,{PatCredNo:desc,HospDr:$HUI.combogrid('#_HospUserList').getValue()});
	    },
	    onSelect:function(index, row){
		    var PatNo=row['PatNo'];
		    $("#PatNo").val(PatNo);
		    //PageLogicObj.m_PAAdmRowId=row['PAAdmRowId'];
		    FindPatDetail();
		}
    });
}

function IntNameLookUp(){
	$("#Name").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'PAAdmRowId',
        textField:'PatName',
		remoteSort:false,
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
		fitColumns:true,
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
	var PatientID=unescape(Split_Value[23]);
	var UnitRegNo=$.cm({
	    ClassName : "web.DHCOPAdmReg",
	    MethodName : "GetUnitedRegNo",
	    dataType:"text",
	    PatientID:PatientID,
    },false);
	if (UnitRegNo!=""){
		$.messager.alert("提示",unescape(Split_Value[3])+" 该登记号已被合并，保留登记号为<font style='color:red'>"+UnitRegNo+"</font>!","info")
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
	//$("#Startdate,#Enddate").datebox('setValue',ServerObj.NowDate);
	$("#Startdate,#Enddate").datebox('setValue',"");
	//$("#cOutStatus,#cInStatus,#cDisInStatus").checkbox('setValue',false);
	$("#Name").lookup('setText','');
	$("#PatMed").removeAttr("disabled");
	SetWardStatus(); //$("#WardDesc").combobox('enable');
	if ($("#cOutStatus").checkbox('getValue')==false) {SetDefaultWard();}
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
	var RequestPatMed = PatMed + "^" + Diagnosis + "^" + SAge + "^" + EAge+"^"+HospID
	var SDate = $("#Startdate").datebox('getValue');
	var EDate = $("#Enddate").datebox('getValue');
	var OFlag = $("#cOutStatus").checkbox('getValue');
	var IFlag = $("#cInStatus").checkbox('getValue');
	var DisFlag = $("#cDisInStatus").checkbox('getValue');
	var PreFlag = $("#cPreStatus").checkbox('getValue');
	if ((!OFlag)&&(!IFlag)&&(!DisFlag)&&(!PreFlag)) {
		$.messager.alert("提示","请先选择门急诊/住院/出院/预住院患者类型进行查询!","info");
		return false;
	}
	if ((PatNo=="")&&(PatMed=="")&&(SDate=="")&&(EDate=="")){
		$.messager.alert("提示","请至少选择一个查询条件(日期、卡号、登记号、病案号)进行查询!","info");
		return false;
		}
	var PreFlag=$("#cPreStatus").checkbox('getValue')?'on':''
	var RequestPatMed=RequestPatMed +"^"+PreFlag
	var PatType = $("#PatType").datebox('getValue');
	var RequestPatMed=RequestPatMed +"^"+PatType
	 var DateFlag = tkMakeServerCall("web.DHCExamPatList","IfSelectDate",SDate,EDate,session['LOGON.HOSPID']);
	 if ((PatNo=="")&&(DateFlag!="")) {
	    $.messager.alert("提示",DateFlag,"info");
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
	var cOutStatusFlag=$("#cOutStatus").checkbox('getValue')
	var cInStatusFlag=$("#cInStatus").checkbox('getValue')
	var cDisInStatusFlag=$("#cDisInStatus").checkbox('getValue')
	var cPreFlag = $("#cPreStatus").checkbox('getValue');
	/*if ((cOutStatusFlag==true)&&(cInStatusFlag==false)&&(cDisInStatusFlag==false)){
		$("#WardDesc").combobox('setValue','')
	}else if ((cOutStatusFlag==true)&&(cInStatusFlag==true)&&(cDisInStatusFlag==false)){
		//$("#WardDesc").combobox('setValue','')
	}else if ((cOutStatusFlag==true)&&(cInStatusFlag==false)&&(cDisInStatusFlag==true)){
		//$("#WardDesc").combobox('setValue','')
	}else{
		if ($("#WardDesc").combobox('getValue')=="") {
			SetDefaultWard()
		}
	}*/
	if (cOutStatusFlag ==true) {
		$("#WardDesc").combobox('setValue','');
	}
	if ((cInStatusFlag==true)||(cDisInStatusFlag==true)||(cPreFlag==true)) {
		$("#WardDesc").combobox('enable');
	}else{
		$("#WardDesc").combobox('setValue','').combobox('disable');
	}
}
function BPatBaseInfo(EpisodeID,wardId){
	//2022.06.29 V8.5.2 换成护士站新封装的HISUI页面(页面显示内容配置来源：床位卡配置-患者详细信息配置)
	/*var src="dhc.nurse.vue.nis.csp?pageName=patientDetail&EpisodeID="+EpisodeID;
	websys_showModal({
		url:src,
		title:'患者基本信息',
		width:900,height:500
	})*/
	var getPatDetailMaxRow=$.cm({
		ClassName:"Nur.NIS.Service.Base.BedConfig",
		MethodName:"getPatDetailMaxRow",
		HospId:session['LOGON.HOSPID'],
		wardId:""
	},false);
	getPatDetailMaxRow = parseInt(getPatDetailMaxRow);
	var panelHeadHeight = 37,patBarHeight = 41;
    var panelBodyHeight = getPatDetailMaxRow * 30 + (getPatDetailMaxRow + 1) * 10;
  	var panelHeight = panelHeadHeight + patBarHeight + panelBodyHeight;
  	var lnk="nur.hisui.patdetailinfo.csp?EpisodeID="+EpisodeID+"&saveOperation=N&wardID="+wardId
	websys_showModal({
	    url: lnk,
	    title: "患者基本信息",
	    iconCls:'icon-w-eye',
	    width: 738,
	    height: panelHeight,
	    CallBackFunc: function(result) {
	      websys_showModal("close");
	    }
  });
}
function BAddPilotProPat(EpisodeID,PatientID){
	var src="docpilotpro.patadd.hui.csp?EpisodeID="+EpisodeID+"&PatientID="+PatientID;
	if(typeof websys_writeMWToken=='function') src=websys_writeMWToken(src);
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
	 var PreFlag = $("#cPreStatus").checkbox('getValue');
	 if ((!OFlag)&&(!IFlag)&&(!DisFlag)&&(!PreFlag)) {
		$.messager.alert("提示","请先选择门急诊/住院/出院/预住院患者类型进行查询!","info");
		return false;
	}
	  var DateFlag = tkMakeServerCall("web.DHCExamPatList","IfSelectDate",SDate,EDate,session['LOGON.HOSPID']);
	 if ((PatNo=="")&&(DateFlag!="")) {
	    $.messager.alert("提示",DateFlag,"info");
	    return false;
	 }
	 var PreFlag=$("#cPreStatus").checkbox('getValue')?'on':''
	var RequestPatMed=RequestPatMed +"^"+PreFlag
	var PatType = $("#PatType").datebox('getValue');
	var RequestPatMed=RequestPatMed +"^"+PatType
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
	 var HospID=$HUI.combogrid('#_HospUserList').getValue();
	 var RequestPatMed = PatMed + "^" + Diagnosis + "^" + SAge + "^" + EAge+"^"+HospID
	 var SDate = $("#Startdate").datebox('getValue');
	 var EDate = $("#Enddate").datebox('getValue');
	 var OFlag = $("#cOutStatus").checkbox('getValue');
	 var IFlag = $("#cInStatus").checkbox('getValue');
	 var DisFlag = $("#cDisInStatus").checkbox('getValue');
	 var PreFlag=$("#cPreStatus").checkbox('getValue')
	 if ((!OFlag)&&(!IFlag)&&(!DisFlag)&&(!PreFlag)) {
		$.messager.alert("提示","请先选择门急诊/住院/出院/预住院患者类型进行查询!","info");
		return false;
	}
	 var DateFlag = tkMakeServerCall("web.DHCExamPatList","IfSelectDate",SDate,EDate,session['LOGON.HOSPID']);
	 if ((PatNo=="")&&(DateFlag!="")) {
	    $.messager.alert("提示",DateFlag,"info");
	    return false;
	 }
	 var Rows =PageLogicObj.m_PatListTabDataGrid.datagrid('getRows')
	 if (Rows.length==0){
		 if (ResultSetTypeDo=="Print"){
			 $.messager.alert("提示","请不要打印空数据","info");
		 }else{
		 	$.messager.alert("提示","请不要导出空数据","info");
		 }
		return false;
		 }
	 var PreFlag=$("#cPreStatus").checkbox('getValue')?'on':''
	 var RequestPatMed=RequestPatMed +"^"+PreFlag
	 var PatType = $("#PatType").datebox('getValue');
	 var RequestPatMed=RequestPatMed +"^"+PatType
	 $.cm({
		 localDir:ResultSetTypeDo=="Export"?"Self":"",
		 ResultSetTypeDo:ResultSetTypeDo,
	     ExcelName:$HUI.combogrid('#_HospUserList').getText()+"患者查找单",
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
function SetWardStatus(){
	var OFlag = $("#cOutStatus").checkbox('getValue');
	var cInStatus=$("#cInStatus").checkbox('getValue');
	var cDisInStatus=$("#cDisInStatus").checkbox('getValue');
	var cPreFlag = $("#cPreStatus").checkbox('getValue');
	if ((OFlag)&&(!cInStatus)&&(!cDisInStatus)&&(!cPreFlag)) {
		$("#WardDesc").combobox('disable');
	}else {
		$("#WardDesc").combobox('enable');
	}
}
function LoadAdmReason(){
	var HospID=$HUI.combogrid('#_HospUserList').getValue();
	var sessinStr="^"+session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^"+HospID+"^"+session['LOGON.SITECODE']+"^"
	var DefaultPatTypePara=tkMakeServerCall('web.UDHCOPOtherLB','ReadAdmReason',"GetAdmReasonToHUIJson","",sessinStr)
	$("#PatType").combobox({
		//width:115,
		valueField: 'id',
		textField: 'text', 
		//editable:false,
		blurValidValue:true,
		data: JSON.parse(DefaultPatTypePara),
		filter: function(q, row){
			if (q=="") return true;
			if (row["text"].indexOf(q.toUpperCase())>=0) return true;
			var find=0;
			if ((row["AliasStr"])&&(row["AliasStr"]!="")){
				for (var i=0;i<row["AliasStr"].split("^").length;i++){
					if (row["AliasStr"].split("^")[i].indexOf(q.toUpperCase()) >= 0){
						find=1;
						break;
					}
				}
			}
			if (find==1) return true;
			return false;
		},
		onSelect:function(rec){
			//PatTypeOnChange();
		}
	})
}

/**
 * 患者列表按钮跳转菜单
 * @param {*} cfg 
 */
function jumpMenu(cfg) {
	var menuCodeStr = cfg.url
	if (menuCodeStr == "") {
		var msg = "请前往 <font style='font-weight:bold;color:red;'>医生站配置-显示信息配置-门诊功能区按钮配置 患者查询行按钮</font> 的链接 配置 对应菜单代码！"
		$.messager.alert("提示", msg, "info")
		return false
	}
	var top = websys_getMenuWin()
	if(top) {
		var matchMenu = getMatchMenu(top.menuJson.records, menuCodeStr, null)
		// console.log(matchMenu)
		if (matchMenu != null) {
			var link = ""
			var newwin = ""
			if (matchMenu.target == "_blank") {
				newwin = matchMenu.blankOpt
			}
			// 医生站配置-显示信息配置-门诊功能区按钮配置 患者查询行按钮 单击事件，配置打开新窗口的参数，不需要的可不配置，按原有菜单打开方式处理
			// Ex: "top=6%,left=2%,width=96%,height=105%"
			if (cfg.handler != "") {
				newwin = cfg.handler
			}
			if (matchMenu.link.indexOf("javascript:") > -1) {
				link = matchMenu.link.split("'")[1]
			} else {
				link = matchMenu.link
			}
			top.PassDetails(link, newwin)
		} else {
			$.messager.alert("提示", "您没有权限打开当前按钮对应菜单！", "info")
			return false
		}
	} else {
		$.messager.alert("提示", "未能获取头菜单 “top”, 请联系基础平台支持！", "info")
		return false
	}
}

/**
 * 递归获取按钮对应菜单（目前应该主要是头菜单）
 * @param {*} menuArr 
 * @param {*} menuCodeStr 
 * @param {*} matchMenu 
 * @returns 
 */
function getMatchMenu(menuArr, menuCodeStr, matchMenu) {
	for (var i = 0; i < menuArr.length; i++) {
		if (menuArr[i].link != "#") {
			// replaceAll() 不兼容医为浏览器
			// var menuCode = menuArr[i].code.replaceAll("_", ".")
			var menuCode = menuArr[i].code.replace(/_/g, ".")
			if ((";" + menuCodeStr + ";").indexOf(";" + menuCode + ";") > -1) {
				matchMenu = menuArr[i]
				return matchMenu
			}
		} else {
			var matchMenu = getMatchMenu(menuArr[i].children, menuCodeStr, matchMenu)
			if (matchMenu) {
				return matchMenu
			}
		}
	}
	return matchMenu
}
