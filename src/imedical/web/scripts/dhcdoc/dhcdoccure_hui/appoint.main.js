/**
	治疗预约 Version 2.0
	appoint.main.js
	2022-06-02
*/
var PageAppointMainObj={
	cspName:"doccure.applyapplist.hui.csp",
	m_SelectArcimID:"",
	m_CureAppPatientDataGrid:"",
	m_CureSingleAppoint:"",
	m_CureApplyAppDataGrid:"",
	m_DCAListDataGrid:"",
	PatCondition:[{id:"PatNo",desc:$g("登记号")},{id:"PatMedNo",desc:$g("住院号")},{id:"PatName",desc:$g("患者姓名")}],
	dw:$(window).width(),
	dh:$(window).height()
}

$(window).load(function(){
	
})

$(document).ready(function(){
	if (!CheckDocCureUseBase()){
		return;
	}
	Init();
	InitEvent();
	PageHandle();
});

function Init(){
	//界面左侧患者列表初始化
	InitMain();
	
	if(ServerObj.DocCureUseBase=="0"){
		//预约资源界面Init
		appList_appResListObj.InitScheduleTab("");
		//预约列表Init
		PageAppointMainObj.m_CureApplyAppDataGrid=appListObj.InitCureApplyAppDataGrid();
	}
	
	//项目明细界面初始化
	InitDCAListEle();
}

function InitEvent(){
	//界面左侧患者列表事件初始化
	InitMainEvent()
	
	//预约部分事件初始化
	if(ServerObj.DocCureUseBase=="0"){
		appList_appResListObj.InitApplyResListEvent();
		appListObj.InitApplyAppListEvent();	
	}
	//项目明细界面的事件初始化
	InitDCAListEvent();	
}

function PageHandle(){
	if(ServerObj.DocCureUseBase=="0"){
	}	
}

function InitMain(){
	InitPatCondition();
	InitSingleAppointMode();	
	PageAppointMainObj.m_CureAppPatientDataGrid=InitCurePatientDataGrid();
	$("#StartDate").datebox('setValue',ServerObj.CurrentDate);	
	$("#EndDate").datebox('setValue',ServerObj.CurrentDate);
	$HUI.combobox("#ServiceGroup",{
	    valueField:'Rowid',   
    	textField:'Desc',
    	url:$URL+"?ClassName=DHCDoc.DHCDocCure.RBCServiceGroupSet&QueryName=QueryServiceGroup&HospID="+_PageCureObj.LogHospID+"&ResultSetType=array",
    	onSelect:function(){
	    	CurePatientDataGridLoad();
	    }
	});	
}
function InitMainEvent(){
	$('#btnFind').bind('click', function(){
		CurePatientDataGridLoad();
	});
	
	$('#btnClear').bind('click', function(){
		ClearHandle();
	});
	
	$('#PatConditionVal').bind('keydown', function(event){
		if(event.keyCode==13)
		{
			var PatCondition=$("#PatCondition").combobox("getValue");
			if(PatCondition=="PatNo"){
				PatNoHandle(EventPatientDataGridLoad,this.id);	
				if ($(this).val()==""){
					$("#PatientID").val("");
				}
			}else{
				EventPatientDataGridLoad();
			}
		}
	});
	$('#PatConditionVal').bind('change', function(){
		var PatCondition=$("#PatCondition").combobox("getValue");
		if(PatCondition=="PatNo"){
			if ($(this).val()==""){
				$("#PatientID").val("");
			}
		}
    });
	$HUI.radio("[name='SortType']",{
        onChecked:function(e,value){
            setTimeout("CurePatientDataGridLoad();",10)
        }
    });
	
	//common.readcard.js
	InitCardNoEvent(EventPatientDataGridLoad); 	
}

function InitDCAListEle(){
	InitOrderLoc();
	InitOrderDoc();
	InitArcimDesc();
	InitOthChkCondition();
	PageAppointMainObj.m_DCAListDataGrid=InitDCAListTabDataGrid();
}

function InitDCAListEvent(){
	$('#btnDCAFind').bind('click', function(){
		CureApplyDataGridLoad();
	});
	
	$('#btnDCAClear').bind('click', function(){
		DCAListClearHandle();
	});	
	$HUI.radio("[name='DCASortType']",{
        onChecked:function(e,value){
            setTimeout("CureApplyDataGridLoad();",10)
        }
    });
    $('#DCAListTabWin').window({
		onClose:function(){
			DCAListClearHandle();	
		}	
	})	
}

function DCAListClearHandle(){
	$('.dcalist-table input[class*="validatebox"]').val("");
	$('.dcalist-table input[type="checkbox"]').checkbox('uncheck');
	$('.dcalist-table input[class*="combobox"]').combobox('select','');
	$("#DCAStartDate,#DCAEndDate").datebox("setValue","");	
	PageAppointMainObj.m_SelectArcimID=""; 
	$("#DCAComboArcim").lookup('setText','');
	$("#DCAComboOtherChk").combobox('setValues','');
	var radioObj=$("input[name='DCASortType']");
	$.each(radioObj,function(i,o){
		if(o.value=="A"){
			$HUI.radio(this).setValue(true);
		}
	})
}

function InitCurePatientDataGrid(){
	var CureListDataGrid=$('#tabCureAppPatientList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		loadMsg : '加载中..',  
		pagination : true, 
		rownumbers : true, 
		singleSelect : true,
		url:$URL+"?ClassName=DHCDoc.DHCDocCure.AppointmentV2&QueryName=FindAppList&rows=9999",
		loadMsg : '加载中..',  
		idField:"PatientId",
		pageSize : 20,
		pageList : [20,30,50],
		columns : [[     
			{field: 'DCARowIdStr', title: 'DCARowIdStr', hidden:true}, 
			{field: 'PatientId', title: 'PatientID', hidden:true},
			{field: 'PatientNo',title:'患者登记号',width:120,align:'left'},   
			{field: 'PatientName',title:'患者姓名',width:100,align:'left'},
			{field: 'PatientSex',title:'患者性别',width:80,align:'left'},  
			{field: 'OrdRecLocDesc',title:'治疗科室',width:200, hidden:true},
			{field: 'OrdRecLocDr',title:'', hidden:true},
			{field: 'HasLong',title:'', hidden:true},
			{field: 'DCAInfo',title:'治疗项目明细',width:100,align:'left', resizable: true,formatter:function(val,row,index){
				return '<a class="editcls" onclick="ShowDCAList(\''+row.PatientId+'\',\''+row.ServiceGroupDr+'\')">'+$g("项目明细")+'</a>';
			}},
			{field: 'ServiceGroup', title: '服务组', width: 160, align: 'left',resizable: true},
			{field: 'ServiceGroupDr',title:'', hidden:true}
		]],
		onBeforeLoad:function(param){
			$(this).datagrid("unselectAll");
			var StartDate=$("#StartDate").datebox("getValue");
			var EndDate=$("#EndDate").datebox("getValue");
			var queryPatID=$("#PatientID").val();
			var PatName="",PatMedNo=""; 
			var PatCondition=$("#PatCondition").combobox("getValue");
			var PatConditionVal=$("#PatConditionVal").val();
			if(PatCondition=="PatName"){
				PatName=PatConditionVal;
			}else if(PatCondition=="PatMedNo"){
				PatMedNo=PatConditionVal;
			}
			var ServiceGroup=$("#ServiceGroup").combobox("getValue");
			var QueryExpStr=PatName+"^"+PatMedNo+"^"+ServiceGroup;
			var SessionStr=PageAppointMainObj.cspName+"^"+com_Util.GetSessionStr();
			$.extend(param,{StartDate:StartDate,EndDate:EndDate,PatientID:queryPatID,
			LogLocID:_PageCureObj.LogCTLocID,LogUserID:_PageCureObj.LogUserID,queryOrderLoc:"",
			queryExpStr:QueryExpStr,SessionStr:SessionStr});
		},
		onSelect:function(){
			appList_appResListObj.SelectScheduleTab();
			appListObj.CureApplyAppDataGridLoad();
		}
	});
	return CureListDataGrid;	
}

function EventPatientDataGridLoad(){
	$("#StartDate,#EndDate").datebox('setValue',"");
	CurePatientDataGridLoad();	
}

function CurePatientDataGridLoad(){
	PageAppointMainObj.m_CureAppPatientDataGrid.datagrid("reload");	
}

function InitPatCondition(){
	$HUI.combobox("#PatCondition", {
		valueField: 'id',
		textField: 'desc', 
		editable:false,
		data: PageAppointMainObj.PatCondition,
		onSelect:function(){
	    	$("#PatConditionVal").val("");
	    	$("#PatientID").val("");
	    }
	});
}
function InitOthChkCondition(){
	var OthChkConditionAry=[{id:"FinishDis",desc:$g("申请状态-已完成")},{id:"CancelDis",desc:$g("申请状态-已撤销")}]
	var myAry=[{id:"OPCheck",desc:$g("患者类型-门急诊")},{id:"IPCheck",desc:$g("患者类型-住院")}]
	OthChkConditionAry.push.apply(OthChkConditionAry,myAry);
	$HUI.combobox("#DCAComboOtherChk", {
		valueField: 'id',
		textField: 'desc', 
		editable:false,
		multiple:true,
		rowStyle:'checkbox',
		selectOnNavigation:false,
		panelHeight:"auto",
		data: OthChkConditionAry
	});
}
function InitArcimDesc()
{
	$("#DCAComboArcim").lookup({
        url:$URL,
        mode:'remote',
        disabled:false,
        method:"Get",
        idField:'ArcimRowID',
        textField:'ArcimDesc',
        columns:[[  
            {field:'ArcimDesc',title:'名称',width:320,sortable:true},
			{field:'ArcimRowID',title:'ID',width:100,sortable:true},
			{field:'selected',title:'ID',width:120,sortable:true,hidden:true}
        ]],
        pagination:true,
        panelWidth:420,
        panelHeight:260,
        isCombo:true,
        minQueryLen:1,
        rownumbers:true,
		fit: true,
		pageSize: 5,
		pageList: [5],
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: "DHCDoc.DHCDocCure.Apply",QueryName: 'FindAllItem'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        //if (desc=="") return false;
	        var CureItemFlag="on"
			param = $.extend(param,{'Alias':desc,'CureItemFlag':CureItemFlag,'SubCategory':""});
	    },onSelect:function(ind,item){
            var Desc=item['desc'];
			var ID=item['ArcimRowID'];
			PageAppointMainObj.m_SelectArcimID=ID;
			$HUI.lookup("#DCAComboArcim").hidePanel();
		},onHidePanel:function(){
            var gtext=$HUI.lookup("#DCAComboArcim").getText();
            if((gtext=="")){
	        	PageAppointMainObj.m_SelectArcimID="";    
	        }
		}
    });  
};
function InitOrderLoc(){
	var obj=com_withLocDocFun.InitComboDoc("DCAComboOrderDoc");
	com_withLocDocFun.InitComboLoc("DCAComboOrderLoc",obj);
}
function InitOrderDoc(LocID){
}

/**
	@单申请单预约模式
	@	页签展示业务操作列表操作模式下有效
	@	启用后治疗预约界面预约时本次预约成功后若仍存在可预约的数量，则可弹出日期选择框继续按照本次预约的资源、时段、服务组进行预约，但申请单只能单选一条记录.
*/
function InitSingleAppointMode(){
	if(ServerObj.LayoutConfig=="1"){
		var SingleAppointMode="0";
		if(ServerObj.UIConfigObj!=""){
			var data = eval('(' + ServerObj.UIConfigObj + ')');
			if ((!data['DocCure_SingleAppointMode'])||(data['DocCure_SingleAppointMode']=="")){
				SingleAppointMode="0";
			}else{
				SingleAppointMode=data['DocCure_SingleAppointMode'];
			}
		}
		PageAppointMainObj.m_CureSingleAppoint=SingleAppointMode;
	}
}

function ClearHandle(){
	//InitCardType();
	$('.search-table input[class*="validatebox"]').val("");
	$('.search-table input[type="checkbox"]').checkbox('uncheck');
	$("#StartDate,#EndDate").datebox("setValue","");	
	$("#ServiceGroup,#PatCondition").combobox('select','');
	$("#StartDate").datebox('setValue',ServerObj.CurrentDate);	
	$("#EndDate").datebox('setValue',ServerObj.CurrentDate);	
}

function InitDCAListTabDataGrid() {
	var cureApplyToolBar = [{
		id:'BtnDetailView',
		text:'申请单浏览', 
		iconCls:'icon-eye',  
		handler:function(){
			OpenApplyDetailDiag();
		}
	}];
	var cureApplyColumn=[[ 
		{field:'ServiceGroup',title:'服务组',width:88,align:'left', resizable: true}, 
		{field:'OrdOtherInfo',title:'医嘱其他信息',width:150,align:'left',
			formatter: function (value, rowData, rowIndex) {
				if(value==""){
					value = $g("医嘱明细信息");
				}
				return "<a href='javascript:void(0)' title='"+$g("医嘱明细信息")+"'  onclick='com_openwin.ordDetailInfoShow(\""+rowData.OrderId+"\")'>"+value+"</a>";
			}
		}, 
		{field:'OrdBilled',title:'是否缴费',width:80,align:'left', resizable: true,
			formatter:function(value,row,index){
				if (value == $g("否")){
					return "<span class='fillspan-nobilled'>"+value+"</span>";
				}else{
					return "<span class='fillspan'>"+value+"</span>";
				}
			}
		},
		{field:'OrdQty',title:'数量',width:60,align:'left', resizable: true}, 
		{field:'OrdBillUOM',title:'单位',width:60,align:'left', resizable: true}, 
		{field:'OrdUnitPrice',title:'单价',width:60,align:'left', resizable: true}, 
		{field:'OrdPrice',title:'总金额',width:60,align:'left', resizable: true}, 
		//{field:'ApplyNoAppTimes',title:'未预约数量',width:80,align:'left', resizable: true,hidden:((ServerObj.myTriage=="Y")||(ServerObj.DocCureUseBase=="1"))?true:false},
		//{field:'ApplyAppedTimes',title:'已预约数量',width:80,align:'left', resizable: true,hidden:((ServerObj.myTriage=="Y")||(ServerObj.DocCureUseBase=="1"))?true:false},
		{field:'ApplyFinishTimes',title:'已治疗数量',width:80,align:'left', resizable: true},
		{field:'ApplyNoFinishTimes',title:'未治疗数量',width:80,align:'left', resizable: true},
		{field:'OrdReLoc',title:'接收科室',width:120,align:'left', resizable: true},   
		{field:'HistoryTriRes',title:'上次分配',width:100,align:'left', resizable: true,hidden:(ServerObj.myTriage=="Y")?false:true},
		{field:'ApplyStatus',title:'申请状态',width:80,align:'left', resizable: true},
		{field:'ApplyStatusCode',title:'ApplyStatusCode',width:80,align:'left', resizable: true,hidden:true},
		{field:'ApplyUser',title:'申请医生',width:100,align:'left', resizable: true},
		{field:'ApplyDateTime',title:'申请时间',width:120,align:'left', resizable: true},
		{field:'ServiceGroupID',title:'服务组id',width:80,align:'left',hidden:true},
		{field:'ControlFlag',title:'',width:10,align:'left',hidden:true},
		{field:'OrdFreqCode',title:'医嘱频次',width:50,align:'left',hidden:true},
		{field:'OrdStatusCode',title:'医嘱状态',width:50,align:'left',hidden:true},
		{field:'ApplyExecFlag',title:'ApplyExecFlag',width:50,align:'left',hidden:true},
		{field:'OrderId',title:'OrderId',width:50,align:'left',hidden:true},
		{field:'DCAAdmID',title:'DCAAdmID',width:50,align:'left',hidden:true},
		{field:'PatientID',title:'PatientID',width:50,align:'left',hidden:true}
	 ]]
	 var CureApplyDataGrid=$('#tabCureApplyList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		checkOnSelect:true,
		fitColumns : false,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		loadMsg : '加载中..',  
		pagination : true,
		rownumbers : true,
		idField:"DCARowId",
		pageSize : 20,
		pageList : [20,50,100],
		frozenColumns : [[
			{field:'DCARowId',title:'DCARowId',width:30,hidden:true},   
			{field:'ApplyNo',title:'申请单号',width:110,align:'left', resizable: true},  
			{field:'PatNo',title:'登记号',width:100,align:'left', hidden: true},   
			{field:'PatName',title:'姓名',width:60,align:'left', hidden: true},   
			{field:'PatOther',title:'患者其他信息',width:200,align:'left', hidden: true},
			{field:'ArcimDesc',title:'治疗项目',width:200,align:'left', resizable: true,
				formatter: function (value, rowData, rowIndex) {
					var retStr=value;
					if(value!=""){
						retStr = "<a href='javascript:void(0)' title='"+$g("医嘱及绑定信息")+"'  onclick='com_openwin.applyAppenditemShow(\""+rowData.OrderId+"\")'>"+value+"</a>"
					}
					return retStr;
				}
			},
			{field: 'ApplyExec', title: '是否可预约', width: 80, align: 'left',resizable: true,hidden:(ServerObj.myTriage=="Y")
				,formatter:function(value,row,index){
					if (row.ApplyExecFlag=="Y"){
						return "<span class='fillspan-exec'>"+value+"</span>";
					}else {
						return "<span class='fillspan-app'>"+value+"</span>";
					}
				}
			}
			]
		],
		columns : cureApplyColumn,
    	toolbar : cureApplyToolBar
	});
	return CureApplyDataGrid;
}
/// 治疗明细
function ShowDCAList(PatientID, ServiceGroup) {
	if(typeof PatientID != "undefined"){
		$("#DCAPatientID").val(PatientID);
	}else{
		$.messager.alert("提示","获取患者信息错误","warning");
	}
	if(typeof ServiceGroup != "undefined"){
		$("#DCAServiceGroup").val(ServiceGroup);
	}
	
	var dhwid=$(document.body).width()-50;
	var dhhei=$(document.body).height()-100;
	$('#DCAListTabWin').dialog('open').dialog('resize',{width:dhwid,height:dhhei,top: 50,left:25});
	CureApplyDataGridLoad();
}

function CureApplyDataGridLoad()
{
	var PatientID=$("#DCAPatientID").val();
	var StartDate=$("#DCAStartDate").datebox("getValue");
	var EndDate=$("#DCAEndDate").datebox("getValue");
	var ApplyNo=$("#DCAApplyNo").val()
	var gtext=$HUI.lookup("#DCAComboArcim").getText();
	if (gtext=="")PageAppointMainObj.m_SelectArcimID="";
	var queryArcim=PageAppointMainObj.m_SelectArcimID;
	var queryOrderLoc=$("#DCAComboOrderLoc").combobox("getValue");
	queryOrderLoc=com_Util.CheckComboxSelData("DCAComboOrderLoc",queryOrderLoc);
	var queryOrderDoc=$("#DCAComboOrderDoc").combobox("getValue");
	queryOrderDoc=com_Util.CheckComboxSelData("DCAComboOrderDoc",queryOrderDoc);
	var SortType="A"; //默认时间正序
	var chkRadioJObj = $("input[name='DCASortType']:checked");
	if(chkRadioJObj.length>0){SortType=chkRadioJObj.val();}
	var DisCancelFlag="",FinishDisFlag="",CheckAdmType="";
	if($("#DCAComboOtherChk").length>0){
		var OtherChkAry=$("#DCAComboOtherChk").combobox("getValues");
		if($.hisui.indexOfArray(OtherChkAry,"FinishDis")>-1){FinishDisFlag="Y"}
		if($.hisui.indexOfArray(OtherChkAry,"CancelDis")>-1){DisCancelFlag="Y"}
		if($.hisui.indexOfArray(OtherChkAry,"OPCheck")>-1){CheckAdmType="O"}
		if($.hisui.indexOfArray(OtherChkAry,"IPCheck")>-1){CheckAdmType="I"}
		if($.hisui.indexOfArray(OtherChkAry,"OPCheck")>-1 && $.hisui.indexOfArray(OtherChkAry,"IPCheck")>-1){CheckAdmType=""}
	}
	var PatMedNo="",ChkCurrLocFlag="";
	var ServiceGroup=$("#DCAServiceGroup").val();
	var QueryExpStr=session['LOGON.HOSPID']+"^"+ChkCurrLocFlag+"^"+queryOrderDoc+"^"+PatMedNo+"^"+SortType;
		QueryExpStr=QueryExpStr+"^"+PageAppointMainObj.cspName+"^^"+ServiceGroup;
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Apply",
		QueryName:"FindAllCureApplyListHUI",
		'PatientID':PatientID,
		'StartDate':StartDate,
		'EndDate':EndDate,
		'outCancel':DisCancelFlag,
		'FinishDis':FinishDisFlag,
		'PatName':"",
		'TriageFlag':"APP",
		'LogLocID':session['LOGON.CTLOCID'],
		'LogUserID':session['LOGON.USERID'],
		'ApplyNo':ApplyNo,
		'LongOrdPriority':"",
		'CheckAdmType':CheckAdmType,
		'queryArcim':queryArcim,
		'queryOrderLoc':queryOrderLoc,
		'ExecFlag':"",
		'queryExpStr':QueryExpStr,
		Pagerows:PageAppointMainObj.m_DCAListDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		PageAppointMainObj.m_DCAListDataGrid.datagrid("clearSelections").datagrid("clearChecked");
		PageAppointMainObj.m_DCAListDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})
}

function OpenApplyDetailDiag()
{
	var rows = PageAppointMainObj.m_DCAListDataGrid.datagrid("getSelections");
	if (rows.length==0) 
	{
		$.messager.alert("提示","请选择一个申请单!","warning");
		return "";
	}else if (rows.length>1){
     	$.messager.alert("错误","您选择了多个申请单!","warning")
     	return "";
    }
	var DCARowId=rows[0].DCARowId;
	if(DCARowId==""){
		$.messager.alert('提示','请选择一条申请单',"warning");
		return "";
	}
	com_openwin.ShowApplyDetail(DCARowId,ServerObj.DHCDocCureLinkPage,CureApplyDataGridLoad);
}

function RefreshDataGrid(){
	if(PageAppointMainObj.m_CureApplyAppDataGrid){
		appListObj.CureApplyAppDataGridLoad();
	}
	if(appList_appResListObj){
		appList_appResListObj.CureRBCResSchduleDataGridLoad();
	}
	if(PageAppointMainObj.m_CureAppPatientDataGrid){
		//CurePatientDataGridLoad();
	}
}

function getConfigUrl(userId,groupId,ctlocId){
	return com_Util.getConfigUrl(userId,groupId,ctlocId);
}

function CheckDocCureUseBase(){
	if (ServerObj.DocCureUseBase=="1"){
		$(".window-mask.alldom").show();
		return false;
	}else if (ServerObj.CureAppVersion=="V1"){
		$(".window-mask.alldom").show();
		return false;
	}else{
		$(".window-mask.alldom").hide();
		return true;
	}
}

//预约列表
var appListObj=(function(){
	function InitApplyAppListEvent(){
		$HUI.checkbox("#OnlyApp",{
			onCheckChange:function(e,value){
				setTimeout("appListObj.CureApplyAppDataGridLoad();",10)
			}
		})
		$("#Appoint_FindDate").datebox({
			onChange:function(newValue, oldValue){
				appListObj.CureApplyAppDataGridLoad();
			}
		});
	}
	function InitCureApplyAppDataGrid()
	{
		var CureApplyAppDataGrid=$('#tabCureApplyApp').datagrid({  
			fit : true,
			width : 'auto',
			border : false,
			remoteSort:false,
			striped : true,
			singleSelect : false,
			fitColumns : false,
			autoRowHeight : true,
			url:$URL+"?ClassName=DHCDoc.DHCDocCure.AppointmentV2&QueryName=FindAppointmentList&rows=9999",
			loadMsg : '加载中..',  
			pagination : false,
			rownumbers : true,
			idField:"QueId",
			pageSize:10,
			pageList : [10,25,50],
			columns :[[  
				{field:'RowCheck',checkbox:true},
				{field:'QueId', title: 'QueId', width: 1, align: 'left',hidden:true}, 
				{field:'PatNo',title:'登记号',width:100,align:'left',hidden:true},   
    			{field:'PatName',title:'姓名',width:80,align:'left'},  
				{field:'ASDate', title:'预约治疗日期', width: 100, align: 'left', sortable: true, resizable: true  },
				{field:'QueNo',title:'排队序号',width:80,align:'left'},
				{ field: 'DCAAStatus', title: '预约状态', width: 110, align: 'left',resizable: true
					,formatter:function(value,row,index){
						if (value==$g("已预约")){
							return "<span class='fillspan-fullnum'>"+value+"</span>";
						}else if(value==$g("取消预约")){
							return "<span class='fillspan-xapp'>"+value+"</span>";
						}else{
							return "<span class='fillspan-nonenum'>"+value+"</span>";
						}
					}
				},
				{field:'QueDept', title:'科室', width: 150, align: 'left', resizable: true  
				},
    			{ field: 'ResDesc', title: '资源', width: 100, align: 'left', resizable: true
				},
				{ field: 'TimeRange', title: '时段', width: 140, align: 'left', resizable: true
				},
				{ field: 'SchedStTime', title: '开始时间', width: 80, align: 'left',resizable: true
				},
				{ field: 'SchedEdTime', title: '结束时间', width: 80, align: 'left',resizable: true
				},
				{ field: 'DDCRSStatus', title: '排班状态', width: 80, align: 'left',resizable: true
				},
				{ field: 'QueOperUser', title: '预约操作人', width: 80, align: 'left',resizable: true
				},
				{ field: 'QueStatusDate', title: '最后操作时间', width: 180, align: 'left',resizable: true
				}
			 ]],
			onBeforeLoad:function(param){
				$(this).datagrid("unselectAll");
				var SelRow=PageAppointMainObj.m_CureAppPatientDataGrid.datagrid("getSelected")
				if (!SelRow) return ;
				var PatientId=SelRow.PatientId;
				var OnlyAppFlag="";
				var OnlyApp=$("#OnlyApp").prop("checked");
				if (OnlyApp){OnlyAppFlag="Y"};
				var AppDate=$('#Appoint_FindDate').datebox('getValue');
				var SessionStr=PageAppointMainObj.cspName+"^"+com_Util.GetSessionStr();
				$.extend(param,{PatientId:PatientId,OnlyApp:OnlyAppFlag,AppDate:AppDate,SessionStr:SessionStr});
			}
		});
		return CureApplyAppDataGrid;
	}
	function CureApplyAppDataGridLoad()
	{
		PageAppointMainObj.m_CureApplyAppDataGrid.datagrid("clearChecked").datagrid("clearSelections");	
		PageAppointMainObj.m_CureApplyAppDataGrid.datagrid("reload");
	}

	function GenCancelCureAppoint(){ 
		var rows = PageAppointMainObj.m_CureApplyAppDataGrid.datagrid("getSelections");
		var length=rows.length;
		var finflag=0;
		var IDAry=new Array();
		for(var i=0;i<length;i++){
			var Rowid=rows[i].QueId;
			IDAry.push(Rowid);
		}
		if(IDAry.length>0){
			var RowIdStr=IDAry.join("^");
			var SessionStr=PageAppointMainObj.cspName+"^"+com_Util.GetSessionStr();
			$.messager.confirm('确认','是否确认取消预约所选预约记录?',function(r){    
			    if (r){ 
					$.m({
						ClassName:"DHCDoc.DHCDocCure.AppointmentV2",
						MethodName:"AppCancelBatch",
						RowIdStr:RowIdStr,
						UserDR:session['LOGON.USERID'],
						SessionStr:SessionStr
					},function testget(value){
						if(value==""){
							AfterCancelAppoint();
							$.messager.popover({msg: '取消预约成功！',type:'success',timeout: 3000})
						}else{
							var msgwid=580;
							var msgleft=(document.body.clientWidth-msgwid)/2+document.body.scrollLeft;   
							$.messager.alert('提示',$g("取消预约失败")+":"+value,"warning")
							.window({
								width:msgwid,
								left:msgleft
							}).css("overflow","auto");;
						}
					})
			    }
			})
		}else{
			$.messager.alert("提示","请选择一条预约记录","warning");		
		}	
	}
	
	function AfterCancelAppoint(){
		RefreshDataGrid();
	}

	function BtnPrintApplyClick(){
		DHCP_GetXMLConfig("XMLObject","DHCDocCureAppointPrtV2"); 
		var SelRow=PageAppointMainObj.m_CureAppPatientDataGrid.datagrid("getSelected")
		if (!SelRow) {
			$.messager.alert("提示", "请选择一位患者记录!");
			return false;
		}
		var PatientID=SelRow.PatientId;
		var IDStr="";
		var rows = PageAppointMainObj.m_CureApplyAppDataGrid.datagrid("getSelections");
		if (rows.length > 0) {
			var SelectIDArr=[];
	        for (var i = 0; i < rows.length; i++) {
	            var Rowid=rows[i].QueId;
	            if(Rowid=="")continue;
	            SelectIDArr.push(Rowid);
	        }
	        IDStr=SelectIDArr.join("^");
		}
		PrintCureAppXML(PatientID,IDStr);	
	}

	function PrintCureAppXML(PatientID,IDStr)
	{
		var JsonObj=$.cm({
			ClassName:"DHCDoc.DHCDocCure.AppointmentV2",
			MethodName:"GetPrintData",
			PatId:PatientID,
			LogLocID:session['LOGON.CTLOCID'],
			IDStr:IDStr,
			dataType:"text"
		},function(ret){
			if (ret!="") {
				var Arr=ret.split(String.fromCharCode(1));
				DHC_PrintByLodop(getLodop(),Arr[0],Arr[1],"","");
				
				//打印成功后给患者发送短信
				//var ret=tkMakeServerCall("DHCDoc.DHCDocCure.Appointment","SendMessage",DCARowId,session['LOGON.USERCODE'])
				//if(ret!="0"){
				//	$.messager.alert("提示","短信纪录发送失败,请确认.")
				//	return false
				//}
			}else {
				$.messager.alert("提示", "未获取需要打印的数据!","error")
			}	
		})
	}
	
	function GetMainID(){
		var MainID="";
		if(typeof(PageAppointMainObj) != "undefined"){
			var SelRow = PageAppointMainObj.m_CureAppPatientDataGrid.datagrid("getSelected");
			if (SelRow){
				MainID = SelRow.DCARowIdStr;
			}
		}
		
		return MainID;
	}
	
	return {
		"InitApplyAppListEvent":InitApplyAppListEvent,
		"InitCureApplyAppDataGrid":InitCureApplyAppDataGrid,
		"CureApplyAppDataGridLoad":CureApplyAppDataGridLoad,
		"BtnPrintApplyClick":BtnPrintApplyClick,
		"GenCancelCureAppoint":GenCancelCureAppoint,
		"AfterCancelAppoint":AfterCancelAppoint
	}
})()