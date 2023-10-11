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
	//��ʼ��
	Init();
	//�¼���ʼ��
	InitEvent();
	//ҳ��Ԫ�س�ʼ��
	PageHandle();
	$("#CardNo").focus();
})
function PageHandle(){
	//����
	LoadDept(); 
	//ҽ��
	LoadDoc();
	//����
	LoadWard();
	//����
	IntNameLookUp();
	//���
	IntDiagnosisLookUp();
	//��ʼ������
	InitFindType();
	//���֤
	IntCredNoLookUp();
	//���߷ѱ�
	LoadAdmReason()
	//OPDocLogTabDataGridLoad();
	if ((session['LOGON.GROUPDESC']=='������ʿ')){
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
	// onCheck ����ѡ�л��ߵĽ��棬��֧���в�����ť
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
		//��Ų����� �������ʹ��rownumbers
		//{field:'SerialNumber',title:'���',width:40,align:'center'},
		{field:"patOperBtn", title:'����', width:225, align:'center',
			formatter: function(value, row, index) {
				var operDiv = '<div id="patOperBtn_'  + index + '" style="width:100%;height:100%"></div>'
				return operDiv
			}
		},
		{field:'RegNo',title:'�ǼǺ�',width:100,sortable:true},
		{field:'PatName1',title:'����',width:100,sortable:false}, 
		{field:'PatientID',hidden:true,title:''},
		{field:'AdmDate',title:'��������',width:90,sortable:true},
		{field:'AdmTime',title:'����ʱ��',width:70,sortable:true},
		{field:'AdmDept',title:'�������',width:120,sortable:true},
		{field:'AdmDoc',title:'ҽ��',width:100,sortable:true},
		{field:'AdmReason',title:'�ѱ�',width:70,sortable:true},
		{field:'AdmType',title:'��������',width:70,sortable:true},
		{field:'PAAdmWard',title:'����',width:120,sortable:true},
		{field:'PAAdmBed',title:'��λ',width:50,sortable:true},
		
		{field:'PatSex1',title:'�Ա�',width:50,sortable:true}, 
		{field:'PatAge',title:'����',width:50,sortable:false}, 
		{field:'PatCredNo',title:'֤����',width:230,sortable:false}, 
		{field:'PatientMedicare',title:'������',width:80,sortable:true}, 
		
        {field:'AdmDischgDate',title:'��Ժ����',width:100,sortable:true},
        {field:'PAADMDischgTime',title:'��Ժʱ��',width:80,sortable:true},
		{field:'MRDiagnoseDesc',title:'���',width:120,sortable:true},
		{field:'baseinfo',title:'������Ϣ',width:70,align:'center',
			formatter: function(value,row,index){
				var btn = '<a class="editcls" onclick="BPatBaseInfo(\'' + row["EpisodeID"] + '\' , \''+row["WardId"] + '\')"><img src="../images/webemr/Regalert.gif"></a>';
				return btn;
			}
		},
		{field:'WardId',hidden:true,title:''},
		{field:'EpisodeID',title:'�����',width:80,sortable:false},
		{field:'VisitStatus',title:'����״̬',width:80,sortable:true},
		{field:'AddPilotProPat',title:'���������Ŀ',width:100,align:'center',
			formatter: function(value,row,index){
				var btn = '<a class="editcls" onclick="BAddPilotProPat(\'' + row["EpisodeID"] + '\' , \''+row["EpisodeID"] + '\')"><img src="../images/websys/new.gif"></a>';
				return btn;
			}
		}, 
		{field:'TelPhone',title:'��ϵ�绰',width:120,sortable:true},
		{field:'PatPoliticalLevel',title:'���߼���',width:100,sortable:true},
		{field:'PatSecretLevel',title:'�����ܼ�',width:100,sortable:true}
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
					WriteTimeToTXT("EpisodeID="+row["EpisodeID"]+",PatientID="+row["PatientID"]+",����ID="+row["RegNo"]);
				}
			}
		},
		onDblClickRow:function(index, row){
			var EpisodeID=row["EpisodeID"];
			var AdmID=EpisodeID;
			var PatientID=row["PatientID"];
			var frm=dhcsys_getmenuform();
			var menuWin=websys_getMenuWin();
			//�ɰ濪סԺ֤->�����л�(ģ̬�򵯳�)
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
			//�°濪סԺ֤->�����л�(hisui����)
			if ("function" === typeof window.parent.ChangePerson){
				/*if ((menuWin) &&(menuWin.MainClearEpisodeDetails)) menuWin.MainClearEpisodeDetails();
				if (frm){
					frm.EpisodeID.value=PageLogicObj.m_EpisodeID;
					frm.PatientID.value=PageLogicObj.m_PatientID;
				}*/
				window.parent.ChangePerson(AdmID,PatientID);
				window.parent.destroyDialog("BookCreat");
			}
			//ԤԼ/�Ӻ�->���߲�ѯ
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
				// �п�ı䣬��ť����֮�仯
				if (field == "patOperBtn") {
					$(this).datagrid('getPanel').find('td[field="patOperBtn"]').find('.shortcutbar-list-x').panel('resize')
				}
			}
		},
		onLoadSuccess: function(data) {
			if (PageLogicObj.m_ShowPatOperBtn == 1) {
				// �����и�̫С
				$(this).datagrid('getPanel').find('div.datagrid-body tr').find('td[field="patOperBtn"]').children("div").css({   
					"height": "40px" 
				})
				// ������Ÿ߶�
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
			{field:'PatNo',title:'�ǼǺ�',width:100},
			{field:'PatName',title:'��������',width:100,sortable:true},
			{field:'Birth',title:'��������',width:95,sortable:true},
			{field:'PatSex',title:'�Ա�',width:40,sortable:true},
			{field:'InPatFlag',title:'����סԺ',width:80,sortable:true},
			{field:'InPatLoc',title:'סԺ����',width:120,sortable:true},
			{field:'CredNo',title:'֤������',width:120,sortable:true}
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
			{field:'PatNo',title:'�ǼǺ�',width:100},
			{field:'PatName',title:'��������',width:100,sortable:true},
			{field:'Birth',title:'��������',width:95,sortable:true},
			{field:'PatSex',title:'�Ա�',width:40,sortable:true},
			{field:'InPatFlag',title:'����סԺ',width:80,sortable:true},
			{field:'InPatLoc',title:'סԺ����',width:120,sortable:true}
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
            {field:'desc',title:'�������',width:300,sortable:true},
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
		//����ǰ����߲�ѯ����տ�ʼ���ֹ����
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
		$.messager.alert("��ʾ",unescape(Split_Value[3])+" �õǼǺ��ѱ��ϲ��������ǼǺ�Ϊ<font style='color:red'>"+UnitRegNo+"</font>!","info")
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
			$.messager.alert("��ʾ","����Ч!","info",function(){
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
		    $.messager.alert("��ʾ","���ȵ�����Һ��ٴ�ӡ!");
		    return false;
		}
		var TemplatePath=$.cm({
			ClassName:"web.UDHCJFCOMMON",
			MethodName:"getpath",
			dataType:"text"
		},false);
		var Template=TemplatePath+"DHCExamPatList1.xls";
        var xlApp,xlsheet,xlBook
		//���ұ߾�
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.PageSetup.LeftMargin=15;  
	    xlsheet.PageSetup.RightMargin=0;
		//��ȡҳ������
		var ReturnValue=$.cm({
			ClassName:"web.DHCExamPatList",
			MethodName:"GetDHCExamPatListMessage",
			UserID:session['LOGON.USERID'], Flag:1, Row:"",
			dataType:"text"
		},false);
	    if (+ReturnValue==0){
		    $.messager.alert("��ʾ","û����Ҫ��ӡ������!");
		    return false;
		}
		var myRows=ReturnValue;
		$.messager.confirm('ȷ�϶Ի���', 'ȷ��Ҫ��ӡ��Ϣ?', function(r){
			if (r){
				var xlsrow=2; //����ָ��ģ��Ŀ�ʼ����λ��
				var xlsCurcol=0;  //����ָ����ʼ������λ��
				var NO=myRows/48
			    NO=parseInt(NO)+1;
				var Flag=1
				for (var Row=1;Row<=myRows;Row++){   
				    if (xlsrow==(50*Flag)){
					     Flag=Flag+1;
				         if(ServerObj.HospName!=""){
					        xlsheet.cells(1,1)=ServerObj.HospName+"���߲��ҵ�";
					     }else{
						    xlsheet.cells(1,1)="���߲��ҵ�";
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
					xlsrow=xlsrow+1; //�ӵ����п�ʼ
					//��ȡҳ������
					var StrData=$.cm({
						ClassName:"web.DHCExamPatList",
						MethodName:"GetDHCExamPatListMessage",
						UserID:session['LOGON.USERID'], Flag:2, Row:Row,
						dataType:"text"
					},false);
		            var DataValue=StrData.split("^")
		            xlsheet.cells(xlsrow,xlsCurcol+1)=Row;
		            xlsheet.cells(xlsrow,xlsCurcol+8)=DataValue[0]; //AdmDate ��������
		            xlsheet.cells(xlsrow,xlsCurcol+9)=DataValue[1];//AdmTime ����ʱ��
		            xlsheet.cells(xlsrow,xlsCurcol+11)=DataValue[2];//AdmDoC ҽ��
		            xlsheet.cells(xlsrow,xlsCurcol+7)=DataValue[3];//AdmReasoc �ѱ�
		            xlsheet.cells(xlsrow,xlsCurcol+6)=DataValue[4];//AdmType  ��������
		            xlsheet.cells(xlsrow,xlsCurcol+12)=DataValue[5];//PAAdmWard ����
		            xlsheet.cells(xlsrow,xlsCurcol+13)=DataValue[6];//PAAdmBed ����
		            xlsheet.cells(xlsrow,xlsCurcol+10)=DataValue[7];//AdmDept �������
		            xlsheet.cells(xlsrow,xlsCurcol+3)=DataValue[12]; //����ID
		            xlsheet.cells(xlsrow,xlsCurcol+2)=DataValue[13];//������
		            xlsheet.cells(xlsrow,xlsCurcol+14)=DataValue[10];//AdmDischgDate ��Ժ����
		            xlsheet.cells(xlsrow,xlsCurcol+4)=DataValue[14];// ��������
		            xlsheet.cells(xlsrow,xlsCurcol+5)=DataValue[15]// �����Ա�
		        }
		        if(ServerObj.HospName!=""){
			        xlsheet.cells(1,1)=ServerObj.HospName+"���߲��ҵ�";
			    }else{
				    xlsheet.cells(1,1)="���߲��ҵ�";
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
	//���һ�������ϲ�
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
		$.messager.alert("��ʾ","����ѡ���ż���/סԺ/��Ժ/ԤסԺ�������ͽ��в�ѯ!","info");
		return false;
	}
	if ((PatNo=="")&&(PatMed=="")&&(SDate=="")&&(EDate=="")){
		$.messager.alert("��ʾ","������ѡ��һ����ѯ����(���ڡ����š��ǼǺš�������)���в�ѯ!","info");
		return false;
		}
	var PreFlag=$("#cPreStatus").checkbox('getValue')?'on':''
	var RequestPatMed=RequestPatMed +"^"+PreFlag
	var PatType = $("#PatType").datebox('getValue');
	var RequestPatMed=RequestPatMed +"^"+PatType
	 var DateFlag = tkMakeServerCall("web.DHCExamPatList","IfSelectDate",SDate,EDate,session['LOGON.HOSPID']);
	 if ((PatNo=="")&&(DateFlag!="")) {
	    $.messager.alert("��ʾ",DateFlag,"info");
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
	//2022.06.29 V8.5.2 ���ɻ�ʿվ�·�װ��HISUIҳ��(ҳ����ʾ����������Դ����λ������-������ϸ��Ϣ����)
	/*var src="dhc.nurse.vue.nis.csp?pageName=patientDetail&EpisodeID="+EpisodeID;
	websys_showModal({
		url:src,
		title:'���߻�����Ϣ',
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
	    title: "���߻�����Ϣ",
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
	createModalDialog("Find","���������Ŀ", 1340, 600,"icon-w-add","",$code,"");
}
function WriteTimeToTXT(i){
	var writeStr;
	var userId=session['LOGON.USERID'];
	var myDate = new Date();
	var mytime=myDate.toLocaleTimeString()+":"+myDate.getMilliseconds();
	writeStr="ʱ��:"+mytime;
	/*    
	object.OpenTextFile(filename[, iomode[, create[, format]]])    
	����object��ѡ�object ӦΪ FileSystemObject �����ơ�    
	filename��ѡ�ָ��Ҫ���ļ����ַ������ʽ��    
	iomode��ѡ���������������֮һ��ForReading �� ForWriting �� ForAppending ��    
	create��ѡ�Boolean ֵ��ָ����ָ���� filename ������ʱ�Ƿ񴴽����ļ�������������ļ���ֵΪ True �������������Ϊ False ��������ԣ��򲻴������ļ���    
	format��ѡ�ʹ����ֵ̬�е�һ����ָ�����ļ��ĸ�ʽ��������ԣ���ô�ļ����� ASCII ��ʽ�򿪡�    
	����iomode �������������������е���һ�֣�    
	����      ֵ  ����    
	ForReading 1 ��ֻ����ʽ���ļ�������д����ļ���    
	ForWriting 2 ��д��ʽ���ļ�    
	ForAppending 8 ���ļ������ļ�ĩβ��ʼд��    
	format �������������������е���һ�֣�    
	ֵ              ����    
	TristateTrue �� Unicode ��ʽ���ļ���    
	TristateFalse �� ASCII ��ʽ���ļ���    
	TristateUseDefault ʹ��ϵͳĬ��ֵ���ļ��� 
	-2ϵͳĬ�ϡ�-1��Unicode ��ʽ��0��ASCII ��ʽ   
	*/     
	var filePath="c://"+userId+"searchLog.txt";
	var objFSO = new ActiveXObject("Scripting.FileSystemObject");
	var objStream;
	if (!objFSO.FileExists(filePath)){    // ����ļ��Ƿ����
   		objStream=objFSO.CreateTextFile(filePath,8,true);
	}else{
		objStream=objFSO.OpenTextFile(filePath,8,false,-1);
	}
	objStream.Write(writeStr+"----"+i+"\r\n");
   	objStream.Close();  // �ر��ļ�
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
   //�Ƴ����ڵ�Dialog
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
		$.messager.alert("��ʾ","����ѡ���ż���/סԺ/��Ժ/ԤסԺ�������ͽ��в�ѯ!","info");
		return false;
	}
	  var DateFlag = tkMakeServerCall("web.DHCExamPatList","IfSelectDate",SDate,EDate,session['LOGON.HOSPID']);
	 if ((PatNo=="")&&(DateFlag!="")) {
	    $.messager.alert("��ʾ",DateFlag,"info");
	    return false;
	 }
	 var PreFlag=$("#cPreStatus").checkbox('getValue')?'on':''
	var RequestPatMed=RequestPatMed +"^"+PreFlag
	var PatType = $("#PatType").datebox('getValue');
	var RequestPatMed=RequestPatMed +"^"+PatType
	 var FileName="PatListQuery";
	 var oXL = new ActiveXObject("Excel.Application"); //����AX����excel   
	 var oWB = oXL.Workbooks.Add(); //��ȡworkbook����   
	 var oSheet = oWB.ActiveSheet; //���ǰsheet
	 oSheet.Columns.NumberFormatLocal = "@";
	 //���ù���������  
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
	   oXL.Visible = false; //����excel�ɼ�����
	   var fname = oXL.Application.GetSaveAsFilename(FileName+".xls", "Excel Spreadsheets (*.xls), *.xls");
	   oWB.SaveAs(fname);
	   oWB.Close(savechanges=false);
	   oXL.Quit();
	   oXL=null;
	  }catch(e){
	    $.messager.alert("��ʾ",e.message);
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
		$.messager.alert("��ʾ","����ѡ���ż���/סԺ/��Ժ/ԤסԺ�������ͽ��в�ѯ!","info");
		return false;
	}
	 var DateFlag = tkMakeServerCall("web.DHCExamPatList","IfSelectDate",SDate,EDate,session['LOGON.HOSPID']);
	 if ((PatNo=="")&&(DateFlag!="")) {
	    $.messager.alert("��ʾ",DateFlag,"info");
	    return false;
	 }
	 var Rows =PageLogicObj.m_PatListTabDataGrid.datagrid('getRows')
	 if (Rows.length==0){
		 if (ResultSetTypeDo=="Print"){
			 $.messager.alert("��ʾ","�벻Ҫ��ӡ������","info");
		 }else{
		 	$.messager.alert("��ʾ","�벻Ҫ����������","info");
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
	     ExcelName:$HUI.combogrid('#_HospUserList').getText()+"���߲��ҵ�",
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
 * �����б�ť��ת�˵�
 * @param {*} cfg 
 */
function jumpMenu(cfg) {
	var menuCodeStr = cfg.url
	if (menuCodeStr == "") {
		var msg = "��ǰ�� <font style='font-weight:bold;color:red;'>ҽ��վ����-��ʾ��Ϣ����-���﹦������ť���� ���߲�ѯ�а�ť</font> ������ ���� ��Ӧ�˵����룡"
		$.messager.alert("��ʾ", msg, "info")
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
			// ҽ��վ����-��ʾ��Ϣ����-���﹦������ť���� ���߲�ѯ�а�ť �����¼������ô��´��ڵĲ���������Ҫ�Ŀɲ����ã���ԭ�в˵��򿪷�ʽ����
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
			$.messager.alert("��ʾ", "��û��Ȩ�޴򿪵�ǰ��ť��Ӧ�˵���", "info")
			return false
		}
	} else {
		$.messager.alert("��ʾ", "δ�ܻ�ȡͷ�˵� ��top��, ����ϵ����ƽ̨֧�֣�", "info")
		return false
	}
}

/**
 * �ݹ��ȡ��ť��Ӧ�˵���ĿǰӦ����Ҫ��ͷ�˵���
 * @param {*} menuArr 
 * @param {*} menuCodeStr 
 * @param {*} matchMenu 
 * @returns 
 */
function getMatchMenu(menuArr, menuCodeStr, matchMenu) {
	for (var i = 0; i < menuArr.length; i++) {
		if (menuArr[i].link != "#") {
			// replaceAll() ������ҽΪ�����
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
