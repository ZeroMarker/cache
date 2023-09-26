var PageAppListAllObj={
	m_SelectArcimID:"",
	_SELECT_DCAROWID:"",
	_SELECT_DCARecLOCROWID:"",
	DATE_FORMAT:""
}
var CureApplyDataGrid="";
$(document).ready(function(){	
	Init();
	InitEvent();
	PageHandle();		
	CureApplyDataGridLoad();
	if (ServerObj.DateFormat=="4"){
		//DD/MM/YYYY
        PageAppListAllObj.DATE_FORMAT= new RegExp("(((0[1-9]|[12][0-9]|3[01])/((0[13578]|1[02]))|((0[1-9]|[12][0-9]|30)/(0[469]|11))|(0[1-9]|[1][0-9]|2[0-8])/(02))/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3}))|(29/02/(([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00)))");
	}else if(ServerObj.DateFormat=="3"){
		//YYYY-MM-DD
    	PageAppListAllObj.DATE_FORMAT= new RegExp("(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)");
	}
});

function Init(){
	//申请单列表Init
	//卡类型列表
    //InitCardType();
	InitOrderLoc();
	InitArcimDesc();
	InitCureApplyDataGrid();
	if(ServerObj.myTriage!="Y"){
		InitExecDate();
		InitExecEvent();
		InitCureExecDataGrid();
	}
	if(ServerObj.DocCureUseBase=="0"){
		if(ServerObj.myTriage=="Y"){
			//分诊资源界面Init
			InitTriageLoc();
			InitCureRBCResListDataGrid();
		
			//分诊列表界面
			InitCureTriageListDataGrid();			
		}else{
			//预约资源界面Init
			InitDate();
			InitCureRBCResSchduleDataGrid();
			//预约列表Init
			InitCureApplyAppDataGrid();
		}
	}
}

function InitEvent(){
	InitCureAppListEvent();	
	if(ServerObj.DocCureUseBase=="0"){
		if(ServerObj.myTriage=="Y"){
			InitCureTriageListEvent();
			
			InitTriageResListEvent();
		}else{
			InitApplyResListEvent();
			InitApplyAppListEvent();	
		}
	}
}

function InitCureAppListEvent(){
	$('#btnFind').bind('click', function(){
		CureApplyDataGridLoad();
	});
	
	$('#btnClear').bind('click', function(){
		ClearHandle();
	});
	$('#patName').bind('keydown', function(event){
		if(event.keyCode==13)
		{
			CureApplyDataGridLoad();
		}
	});
	$('#ApplyNo').bind('keydown', function(event){
		if(event.keyCode==13)
		{
			CureApplyDataGridLoad();
		}
	});
	$HUI.checkbox("#OPCheck",{
		onCheckChange:function(e,value){
			setTimeout("CureApplyDataGridLoad();",10)
		}
	})
	$HUI.checkbox("#IPCheck",{
		onCheckChange:function(e,value){
			setTimeout("CureApplyDataGridLoad();",10)
		}
	})
	
	//common.readcard.js
	InitPatNoEvent(CureApplyDataGridLoad);
	InitCardNoEvent(CureApplyDataGridLoad); 
}

function PageHandle(){
	if(ServerObj.myTriage=="Y"){
		$HUI.checkbox("#Distributed",{
			onCheckChange:function(e,value){
				var cbox=$HUI.checkbox("#Distributed");
				if (cbox.getValue()){
					$HUI.checkbox("#ALLDis").uncheck();
				}
				setTimeout("CureApplyDataGridLoad();",10)
			}
		})
		$HUI.checkbox("#ALLDis",{
			onCheckChange:function(e,value){
				var cbox=$HUI.checkbox("#ALLDis");
				if (cbox.getValue()){
					$HUI.checkbox("#Distributed").uncheck();
				}
				setTimeout("CureApplyDataGridLoad();",10)
			}
		})		
	}else{
		$HUI.checkbox("#CancelDis",{
			onCheckChange:function(e,value){
				var cbox=$HUI.checkbox("#CancelDis");
				if (cbox.getValue()){
					$HUI.checkbox("#FinishDis").uncheck();
				}
				setTimeout("CureApplyDataGridLoad();",10)
			}
		})
		$HUI.checkbox("#FinishDis",{
			onCheckChange:function(e,value){
				var cbox=$HUI.checkbox("#FinishDis");
				if (cbox.getValue()){
					$HUI.checkbox("#CancelDis").uncheck();
				}
				setTimeout("CureApplyDataGridLoad();",10)
			}
		})	
		$HUI.checkbox("#LongOrdPriority",{
			onCheckChange:function(e,value){
				setTimeout("CureApplyDataGridLoad();",10)
			}
		})	
		ControlButton(true);
		if(ServerObj.DocCureUseBase=="1"){
			$("#applist_panel").panel({title: '治疗执行-申请单列表'})
		}
	}	
}

function ClearHandle(){
	InitCardType();
	$("#CardNo,#patNo,#patName,#PatientID,#ApplyNo,#CardTypeNew").val("");
	$("#StartDate,#EndDate").datebox("setValue","");	
	$("#CancelDis,#FinishDis,#Distributed,#ALLDis,#LongOrdPriority,#OPCheck,#IPCheck").checkbox('uncheck');
	PageAppListAllObj.m_SelectArcimID=""; 
	$("#ComboArcim").lookup('setText','');
	$("#ComboOrderLoc").combobox('select','');
}
function ControlButton(val){
	return true;
	if(val==true){
		$('#btnExecOrd').linkbutton({    
		    disabled: true  
		}); 
		$('#btnExecOrd').unbind()
	}else{
		$('#btnExecOrd').linkbutton({    
		    disabled: false  
		}); 
		$('#btnExecOrd').unbind();
		$('#btnExecOrd').bind('click', function(){
			UpdateExecOrd();	
    	});	
	}
}
function InitCureApplyDataGrid()
{
	// Toolbar
	if(ServerObj.myTriage=="Y"){
		var fitcolumnval=true;
		var cureApplyToolBar = [{
		id:'BtnDetailView',
			text:'申请单浏览', 
			iconCls:'icon-funnel-eye',  
			handler:function(){
				OpenApplyDetailDiag();
			}
		}
		];	
	}else{
		var fitcolumnval=false;
		var cureApplyToolBar = [/*{
			id:'BtnCall',
			text:'叫号',
			iconCls:'icon-add',
			handler:function(){
				FormMatterPatName();		 
			}
		},'-',*/{
			id:'BtnDetailView',
			text:'申请单浏览', 
			iconCls:'icon-funnel-eye',  
			handler:function(){
				OpenApplyDetailDiag();
			}
		}/*
		//执行改为下方页签，不在按钮弹出
		,"-",{
			id:'btnExecOrd',
			text:'执行', 
			iconCls:'icon-exe-order',  
			handler:function(){
				//ExecOrdClick();
			}
		}*/,"-",{
			id:'BtnFinish',
			text:'完成申请单', 
			iconCls:'icon-ok',  
			handler:function(){
				FinishApplyClick("F");
			}
		},{
			id:'BtnFinish',
			text:'撤销完成申请单', 
			iconCls:'icon-cancel',  
			handler:function(){
				FinishApplyClick("CF");
			}
		},"-",{
			id:'BtnAssessment',
			text:'治疗评估', 
			iconCls:'icon-paper-table',  
			handler:function(){
				UpdateAssessment();
			}
		}
		];
	}
	var cureApplyColumn=[[ 
		{field:'RowCheck',checkbox:true},     
		{field:'ApplyNo',title:'申请单号',width:110,align:'left', resizable: true},  
		{field:'ServiceGroup',title:'服务组',width:80,align:'left', resizable: true}, 
		{ field: 'ApplyExec', title: '是否可预约', width: 80, align: 'left',resizable: true,hidden:(ServerObj.myTriage=="Y")?true:false
			,styler: function(value,row,index){
				if (value.indexOf("直接执行")>=0){
					return 'color:#FF6347;';
				}
			}
		},
		{field:'PatNo',title:'登记号',width:100,align:'left', resizable: true},   
		{field:'PatName',title:'姓名',width:60,align:'left', resizable: true
		},   
		{field:'PatOther',title:'患者其他信息',width:200,align:'left', resizable: true},
		{field:'ArcimDesc',title:'治疗项目',width:200,align:'left', resizable: true},
		{field:'OrdOtherInfo',title:'医嘱其他信息',width:150,align:'left', resizable: true}, 
		{field:'OrdBilled',title:'是否缴费',width:70,align:'left', resizable: true,
			styler: function(value,row,index){
				if (value == "否"){
					return 'background-color:#ffee00;color:red;';
				}
			}
		},
		{field:'OrdQty',title:'数量',width:50,align:'left', resizable: true}, 
		{field:'OrdBillUOM',title:'单位',width:50,align:'left', resizable: true}, 
		{field:'OrdUnitPrice',title:'单价',width:50,align:'left', resizable: true}, 
		{field:'OrdPrice',title:'总金额',width:60,align:'left', resizable: true}, 
		{field:'ApplyAppedTimes',title:'已预约次数',width:80,align:'left', resizable: true,hidden:((ServerObj.myTriage=="Y")||(ServerObj.DocCureUseBase=="1"))?true:false},
		{field:'ApplyNoAppTimes',title:'未预约次数',width:80,align:'left', resizable: true,hidden:((ServerObj.myTriage=="Y")||(ServerObj.DocCureUseBase=="1"))?true:false},
		{field:'ApplyFinishTimes',title:'已治疗次数',width:80,align:'left', resizable: true,hidden:((ServerObj.myTriage=="Y")||(ServerObj.DocCureUseBase=="1"))?true:false},
		{field:'ApplyNoFinishTimes',title:'未治疗次数',width:80,align:'left', resizable: true,hidden:((ServerObj.myTriage=="Y")||(ServerObj.DocCureUseBase=="1"))?true:false},
		{field:'OrdReLoc',title:'接收科室',width:80,align:'left', resizable: true},   
		{field:'HistoryTriRes',title:'上次分配',width:80,align:'left', resizable: true,hidden:(ServerObj.myTriage=="Y")?false:true},
		{field:'ApplyStatus',title:'申请状态',width:80,align:'left', resizable: true},
		{field:'ApplyStatusCode',title:'ApplyStatusCode',width:80,align:'left', resizable: true,hidden:true},
		{field:'ApplyUser',title:'申请医生',width:80,align:'left', resizable: true},
		{field:'ApplyDateTime',title:'申请时间',width:80,align:'left', resizable: true},
		//{field:'ServiceGroup',title:'服务组',width:30,align:'left',hidden:(HiddenLoc.indexOf(session['LOGON.CTLOCID'])<0)?true:false}, //HiddenLoc.indexOf(session['LOGON.CTLOCID'])
		//{ field: 'CallStatus', title: '呼叫状态', width: 30, align: 'left',resizable: true},
		{field:'ServiceGroupID',title:'服务组id',width:80,align:'left',hidden:true},
		{field:'ControlFlag',title:'',width:10,align:'left',hidden:true},
		{field:'OrdFreqCode',title:'医嘱频次',width:50,align:'left',hidden:true},
		{field:'OrdStatusCode',title:'医嘱状态',width:50,align:'left',hidden:true},
		{field:'OrderId',title:'OrderId',width:50,align:'left',hidden:true},
		{field:'DCARowId',title:'DCARowId',width:30,hidden:true}  	
			   
	 ]]
	var mypageSize=5;
	if(ServerObj.DocCureUseBase==1){
    	mypageSize=10;
    	var fitcolumnval=true;
    }
	// 治疗记录申请单Grid
	CureApplyDataGrid=$('#tabCureApplyList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : false,
		checkOnSelect:true,
		fitColumns : fitcolumnval,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		url : '',
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"DCARowId",
		//pageNumber:0,
		pageSize : mypageSize,
		pageList : [5,10,50,100],
		//frozenColumns : FrozenCateColumns,
		columns : cureApplyColumn,
    	toolbar : cureApplyToolBar,
		onClickRow:function(rowIndex, rowData){
			var msg=true;
			var ret=CheckSelectedRow(rowIndex, rowData,msg);
			if(ret){
				loadTabData();
			}
		},
		onRowContextMenu:function(e, rowIndex, rowData){
			ShowGridRightMenu(e,rowIndex, rowData,"Ord");
		},
		onCheck:function(rowIndex, rowData){
			var msg=false;
			var ret=CheckSelectedRow(rowIndex, rowData);
			if(ret){
				loadTabData();
			}
		},
		onUncheck:function(rowIndex, rowData){
			loadTabData();
		},
		rowStyler:function(index,row){   
	        if (row.CallStatus=="正在呼叫"){   
	            return 'background-color:green;';   
	        }   
	    },
	    onLoadSuccess: function () {   //隐藏表头的checkbox
	    	$("#btnExecOrd").linkbutton("disable")
            $(this).parent().find("div .datagrid-header-check")
                .children("input[type=\"checkbox\"]").eq(0)
                .attr("style", "display:none;");
        },onSelect:function(index, row){
			var frm=dhcsys_getmenuform();
			if (frm){
				var DCARowId=row["DCARowId"];
				var Info=$.cm({
					ClassName:"DHCDoc.DHCDocCure.Common",
					MethodName:"GetPatAdmIDByDCA",
					DCARowId:DCARowId,
					dataType:"text"
				},false); 
				if(Info!=""){
					var PatientID=Info.split("^")[1];
					var EpisodeID=Info.split("^")[0]
					frm.PatientID.value=PatientID;
					frm.EpisodeID.value=EpisodeID;
				}
			}
		},
		onBeforeSelect:function(index, row){
			var oldSelRow=$(this).datagrid('getSelected');
			var oldSelIndex=$(this).datagrid('getRowIndex',oldSelRow);
			if (oldSelIndex==index){
				$(this).datagrid('unselectRow',index);
				var frm=dhcsys_getmenuform();
				if (frm){
					frm.PPRowId.value="";
					frm.EpisodeID.value="";
				}
				return false;
			}
            } 
	});
	$('#tabs').tabs({
       onSelect: function(title,index){
	     loadTabData()
       }
    });

}
 
function CheckSelectedRow(rowIndex, rowData,msg){
	var tabsObj=GetSelTabsObj();
	if(tabsObj.index==0){
		return true;	
	}
	var selected=CureApplyDataGrid.datagrid('getRows'); 
	var SelServiceGroup=selected[rowIndex].ServiceGroup;
	var SelOrdReLocId=selected[rowIndex].OrdReLocId;
	var rows = CureApplyDataGrid.datagrid("getSelections");
	var ApplyExec=selected[rowIndex].ApplyExec;
	var length=rows.length;
	var finflag=0;
	for(var i=0;i<length;i++){
		var MyServiceGroup="";
		var MyServiceGroup=rows[i].ServiceGroup;
		var MyOrdReLocId=rows[i].OrdReLocId;
		if ((SelServiceGroup!=MyServiceGroup)||(SelOrdReLocId!=MyOrdReLocId)){
			if(!msg){
				$.messager.alert("提示","一次选择只能选中相同服务组和接收科室的申请单！",'err')
			}
			CureApplyDataGrid.datagrid("uncheckRow",rowIndex);
			CureApplyDataGrid.datagrid("unselectRow",rowIndex);
			finflag=1;
			break;		
		}
	}
	if(finflag==1)return false;
	return true;
}

function loadTabData()
{
	var rows = CureApplyDataGrid.datagrid("getSelections");
	var DCARowId="";
	var DCARowIdStr="";
	var OrdReLocId="";
	var ControlVal=0;
	for(var i=0;i<rows.length;i++){
		var DCARowIds=rows[i].DCARowId;
		var ApplyExec=rows[i].ApplyExec;
		var Billed=rows[i].OrdBilled;
		//var ControlVal=rows[i].ControlFlag;
		if(rows[i].ControlFlag==1){
			ControlVal=1;	
		}
		if(DCARowIdStr==""){
			DCARowIdStr=DCARowIds;
		}else{
			DCARowIdStr=DCARowIdStr+"!"+DCARowIds;
		}
		OrdReLocId=rows[i].OrdReLocId;
	}
	if(ControlVal==1){
		ControlButton(false);
	}else{
		ControlButton(true);	
	}
	PageAppListAllObj._SELECT_DCAROWID=DCARowIdStr;
	PageAppListAllObj._SELECT_DCARecLOCROWID=OrdReLocId;
	// 更新选择的面板的新标题和内容
	var title = $('.tabs-selected').text();
	var seltab = $('#tabs').tabs('getSelected');
	setTimeout(function(){DataGridLoad(title);},100)
}

function GetSelTabsObj(){
	var tabsObj={};
	var title = $('.tabs-selected').text();
	var seltab = $('#tabs').tabs('getSelected');
	var index = $('#tabs').tabs('getTabIndex',seltab);
	tabsObj={
		title:title,
		index:index	
	}
	return tabsObj
}

function CureApplyDataGridLoad()
{
	var tabsobj=GetSelTabsObj()
	var ExecFlag="N";
	if(tabsobj.index==0){
		ExecFlag="Y";
	}
	if(ServerObj.DHCDocCureAppQryNotWithTab==1){
		ExecFlag="";
	}
	var PatientID=$("#PatientID").val();
	var patName=$("#patName").val()
	var StartDate=$("#StartDate").datebox("getValue");
	var EndDate=$("#EndDate").datebox("getValue");
	var TriageFlag=ServerObj.myTriage;
	var ApplyNo=$("#ApplyNo").val()
	
	var DisCancelFlag="";
	var FinishDisFlag="";
	var LongOrdPriorityFlag="";
	if(TriageFlag=="Y"){
		var Distributed=$HUI.checkbox("#Distributed").getValue()
		if (Distributed){DisCancelFlag="Y"}
		var ALLDis=$HUI.checkbox("#ALLDis").getValue()
		if (ALLDis){FinishDisFlag="Y"}
	}else{
		var CancelDis=$HUI.checkbox("#CancelDis").getValue()
		if (CancelDis){DisCancelFlag="Y"}
		var FinishDis=$HUI.checkbox("#FinishDis").getValue()
		if (FinishDis){FinishDisFlag="Y"}
		var LongOrdPriority=$HUI.checkbox("#LongOrdPriority").getValue()
		if (LongOrdPriority){LongOrdPriorityFlag="Y"}
	}
	var CheckAdmType="";
	var OPCheckObj=$HUI.checkbox("#OPCheck").getValue()
	if (OPCheckObj){CheckAdmType="O"};
	var IPCheckObj=$HUI.checkbox("#IPCheck").getValue()
	if (IPCheckObj){CheckAdmType="I"};
	if ((OPCheckObj)&&(IPCheckObj)){CheckAdmType=""};
	var gtext=$HUI.lookup("#ComboArcim").getText();
	if (gtext=="")PageAppListAllObj.m_SelectArcimID="";
	var queryArcim=PageAppListAllObj.m_SelectArcimID;
	var queryOrderLoc=$("#ComboOrderLoc").combobox("getValue");
	queryOrderLoc=CheckComboxSelData("ComboOrderLoc",queryOrderLoc);
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Apply",
		QueryName:"FindAllCureApplyListHUI",
		'PatientID':PatientID,
		'StartDate':StartDate,
		'EndDate':EndDate,
		'outCancel':DisCancelFlag,
		'FinishDis':FinishDisFlag,
		'PatName':patName,
		'TriageFlag':TriageFlag,
		'LogLocID':session['LOGON.CTLOCID'],
		'LogUserID':session['LOGON.USERID'],
		'ApplyNo':ApplyNo,
		'LongOrdPriority':LongOrdPriorityFlag,
		'CheckAdmType':CheckAdmType,
		'queryArcim':queryArcim,
		'queryOrderLoc':queryOrderLoc,
		'ExecFlag':ExecFlag,
		Pagerows:CureApplyDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		CureApplyDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
		CureApplyDataGrid.datagrid("clearSelections");
		CureApplyDataGrid.datagrid("clearChecked");	
	})
	
	PageAppListAllObj._SELECT_DCAROWID="";
	PageAppListAllObj._SELECT_DCARecLOCROWID="";
	ControlButton(true);
}

function OpenApplyDetailDiag()
{
	var DCARowId=GetSelectRow();
	if(DCARowId==""){
		return;	
	}
	var href="doccure.apply.update.hui.csp?DCARowId="+DCARowId;
	/*var ReturnValue=window.showModalDialog(href,"","dialogwidth:1200px;dialogheight:35em;status:no;center:1;resizable:yes");
	if (ReturnValue !== "" && ReturnValue !== undefined) 
    {
		if(ReturnValue){
			CureApplyDataGridLoad();	
		}
    }*/
    websys_showModal({
		url:href,
		title:'申请单浏览',
		width:"900px",
		height:window.screen.availHeight-180,
		//onBeforeClose:function(){CureApplyDataGridLoad();},
		CureApplyDataGridLoad:CureApplyDataGridLoad
	});
}
function refreshTab(cfg){  
    var refresh_tab = cfg.tabTitle?$('#tabs').tabs('getTab',cfg.tabTitle):$('#tabs').tabs('getSelected');  
    if(refresh_tab && refresh_tab.find('iframe').length > 0){  
	    var _refresh_ifram = refresh_tab.find('iframe')[0];  
	    var refresh_url = cfg.url?cfg.url:_refresh_ifram.src;   
	    _refresh_ifram.contentWindow.location.href=refresh_url;  
    }  
}

function UpdateExecOrd(){
	var rows = CureApplyDataGrid.datagrid("getSelections");
	if (rows.length==0) 
	{
		$.messager.alert("提示","请选择一个申请单","warning");
		return false;
	}
	var DCARowId="";
	var DCARowIdStr=""
	
	for(var i=0;i<rows.length;i++){
		var DCARowIds=rows[i].DCARowId;
		var OrdBilled=rows[i].OrdBilled;
		var ApplyExec=rows[i].ApplyExec;
		var rowIndex = CureApplyDataGrid.datagrid("getRowIndex", rows[i]);
		if((ApplyExec.indexOf("直接执行")<0)||(OrdBilled=="否")){
			//CureApplyDataGrid.datagrid("uncheckRow",rowIndex);
			//continue;
		}else{
			if(DCARowIdStr==""){
				DCARowIdStr=DCARowIds;
			}else{
				DCARowIdStr=DCARowIdStr+"!"+DCARowIds;
			}
		}
	}	
	if(DCARowIdStr==""){
		$.messager.alert('提示','未有可执行的申请',"warning");
		return false;	
	}
	var ExecType="";
	var DefaultNum=1;
	if(ExecType=="E"){
		//DefaultNum=selected[rowIndex].OrdQty;
	}
	var href="doccure.exec.hui.csp?ExecType="+ExecType+"&DefaultNum="+DefaultNum+"&DCARowIdStr="+DCARowIdStr;
	//var ReturnValue=window.showModalDialog(href,"","dialogWidth:1200px;dialogHeight:650px;status:no;center:1;resizable:yes");
 	websys_showModal({
		url:href,
		title:'治疗执行',
		width:"1200px",height:"650px",
		onBeforeClose:function(){CureApplyDataGridLoad();},
	});
 	return true;
 } 
 
 function FormMatterPatName(val,row){
	//以下程序仅支持东华叫号接口
	var rows = CureApplyDataGrid.datagrid("getSelections");
	var DCAARowId="",DCARowId="",DCAOEOREDR=""
	if (rows.length>=1)
	{
		var succsss=true;
		for(var i=0;i<rows.length;i++){
			var rowIndex = CureApplyDataGrid.datagrid("getRowIndex", rows[i]);
			var selected=CureApplyDataGrid.datagrid('getRows'); 
			var DCARowId=selected[rowIndex].DCARowId;
			//DCAOEOREDR=selected[rowIndex].OEOREDR;
			var PatName=selected[rowIndex].PatName;
			var treatID=selected[rowIndex].ServiceGroupID;
			//alert(DCAARowId)
			//return;
			/*
			深圳市中医院  治疗室 叫号接口
			web.DHCVISVoiceCall.InsertVoiceQueue(callinfo,user,computerIP,"A","LR","N",callinfo,callinfo,"",treatID)
			callinfo          请 张三 进入治疗室
			user              userID
			computerIP        计算机IP
			treatID           治疗类型ID   
			*/
			var callinfo="请"+PatName+"进入治疗室";
			var computerIP=GetComputerIp()
			var loguser=session['LOGON.USERID'];
			var logloc=session['LOGON.CTLOCID'];
			var ret="0"; 
			//alert(callinfo+";"+loguser+";"+computerIP+";"+callinfo+";"+logloc+";"+treatID);
			var ret=tkMakeServerCall("web.DHCVISVoiceCall","InsertVoiceQueue",callinfo,loguser,computerIP,"A","LR","N",callinfo,logloc,"",treatID)
			//alert("InsertVoiceQueue+"+ret)
			if(ret=="0"){
				var callret=tkMakeServerCall("DHCDoc.DHCDocCure.Appointment","UpdateTreatCallStatus",DCARowId,"Y")
				if(callret!=0){
					var errmsg=PatName+"更新呼叫状态失败";
					$.messager.alert("错误", errmsg, 'error')
					succsss=false;
					return false;
				}else{
					//alert("呼叫成功")
					//$.messager.alert("提示", "呼叫成功")
				}
			}else{
				var errmsg=PatName+"呼叫失败:"+ret
				$.messager.alert("错误", errmsg, 'error')
				succsss=false;
				return false;
			}
		}
		if(succsss==true){
			$.messager.alert("提示", "呼叫成功")		
		}
	}else{
		$.messager.alert("错误", "请选择一位病人再呼叫.", 'error')
		 return false;
	}
}

function GetComputerIp() 
{
   var ipAddr="";
   var locator = new ActiveXObject ("WbemScripting.SWbemLocator");  
   var service = locator.ConnectServer("."); //连接本机服务器
   var properties = service.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration");  //查询使用SQL标准 
   var e = new Enumerator (properties);
   var p = e.item ();

   for (;!e.atEnd();e.moveNext ())  
   {
  	var p = e.item ();  
 	//document.write("IP:" + p.IPAddress(0) + " ");//IP地址为数组类型,子网俺码及默认网关亦同
	ipAddr=p.IPAddress(0); 
	if(ipAddr) break;
	}

	return ipAddr;
}

function RefreshDataGrid(){
	if(CureApplyDataGrid){
		CureApplyDataGridLoad();

		CureApplyDataGrid.datagrid("clearSelections");
		CureApplyDataGrid.datagrid("clearChecked");	
	}
}


function FinishApplyClick(Type)
{
	var DCARowId=GetSelectRow();
	if(DCARowId==""){
		return;	
	}
	if(Type=="F"){var msg="请确认该申请治疗已完成,是否确认完成该申请?";}
	else{var msg="是否确认撤消完成该申请?"}
	$.messager.confirm('确认',msg,function(r){
		if (r){
			$.m({
				ClassName:"DHCDoc.DHCDocCure.Apply",
				MethodName:"FinishCureApply",
				'DCARowId':DCARowId,
				'UserID':session['LOGON.USERID'],
				'Type':Type,
			},function testget(value){
				if(value == "0"){
					$.messager.show({title:"提示",msg:"确认成功"});
					RefreshDataGrid();
				}else{
					if(value.indexOf("^")>0){
						var msg=value.split("^")[1];
					}else{
						var msg=value;	
					}
					$.messager.alert("提示","确认失败,"+msg);
				}				
				
			});
		}
	})
	
}
function InitArcimDesc()
{
	$("#ComboArcim").lookup({
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
			PageAppListAllObj.m_SelectArcimID=ID;
			$HUI.lookup("#ComboArcim").hidePanel();
		},onHidePanel:function(){
            var gtext=$HUI.lookup("#ComboArcim").getText();
            if((gtext=="")){
	        	PageAppListAllObj.m_SelectArcimID="";    
	        }
		}
    });  
};
function InitOrderLoc(){
	$HUI.combobox("#ComboOrderLoc", {})
    $.cm({
		ClassName:"DHCDoc.DHCDocCure.Config",
		QueryName:"FindLoc",
		'Loc':"",
		'CureFlag':"",
		'Hospital':session['LOGON.HOSPID'],
		dataType:"json",
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#ComboOrderLoc", {
				valueField: 'LocRowID',
				textField: 'LocDesc', 
				editable:true,
				data: Data["rows"],
				filter: function(q, row){
					return (row["LocDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["LocContactName"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				}
		 });
	});
}
function CheckComboxSelData(id,selId){
	var Find=0;
	var Data=$("#"+id).combobox('getData');
	for(var i=0;i<Data.length;i++){
		if (id=="ComboOrderLoc"){
			var CombValue=Data[i].LocRowID;
			var CombDesc=Data[i].LocDesc;
		}else if(id=="RESSessionType"){
			var CombValue=Data[i].ID  
			var CombDesc=Data[i].Desc
		}else{
			var CombValue=Data[i].value  
			var CombDesc=Data[i].desc
		}
		if(selId==CombValue){
			selId=CombValue;
			Find=1;
			break;
		}
	}
	if (Find=="1") return selId
	return "";
}

function UpdateAssessment(){
	var rows = CureApplyDataGrid.datagrid("getSelections");
	if (rows.length==0) 
	{
		$.messager.alert("提示","请选择一个申请单","warning");
		return false;
	}
	var DCARowIdStr=""
	for(var i=0;i<rows.length;i++){
		var DCARowIds=rows[i].DCARowId;
		var OrdBilled=rows[i].OrdBilled;
		var ApplyExec=rows[i].ApplyExec;
		var ApplyStatusCode=rows[i].ApplyStatusCode;
		var rowIndex = CureApplyDataGrid.datagrid("getRowIndex", rows[i]);
		if((OrdBilled!="否")&&(ApplyStatusCode!="C")){
			if(DCARowIdStr==""){
				DCARowIdStr=DCARowIds;
			}else{
				DCARowIdStr=DCARowIdStr+"!"+DCARowIds;
			}
		}
	}	
	if(DCARowIdStr==""){
		$.messager.alert('提示','未有可进行评估的治疗申请,请确认申请是否已缴费或是否已撤消!',"warning");
		return false;	
	}
	var OperateType="";
	var href="doccure.cureassessmentlist.csp?OperateType="+OperateType+"&DCARowIdStr="+DCARowIdStr;
    websys_showModal({
		url:href,
		title:'治疗评估',
		width:screen.availWidth-200,height:screen.availHeight-200
	});
}

function GetSelectRow(){
	var rows = CureApplyDataGrid.datagrid("getSelections");
	if (rows.length==0) 
	{
		$.messager.alert("提示","请选择一个申请单!","warning");
		return "";
	}else if (rows.length>1){
     	$.messager.alert("错误","您选择了多个申请单!","warning")
     	return "";
     }
	var DCARowId=rows[0].DCARowId;
	if(DCARowId=="")
	{
		$.messager.alert('提示','请选择一条申请单',"warning");
		return "";
	}	
	return DCARowId;
}

function destroyDialog(id){
   $("body").remove("#"+id); //移除存在的Dialog
   $("#"+id).dialog('destroy');
}

function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
   if(_btntext==""){
	   var buttons=[{
		   text:'关闭',
			iconCls:'icon-w-close',
			handler:function(){
   				destroyDialog(id);
			}
	   }]
   }else{
	   var buttons=[{
			text:_btntext,
			iconCls:_icon,
			handler:function(){
				if(_event!="") eval(_event);
			}
		},{
			text:'关闭',
			iconCls:'icon-w-close',
			handler:function(){
   				destroyDialog(id);
			}
		}]
   }
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
        closable: false,
        content:_content,
        buttons:buttons
    });

}

function MulOrdDealWithCom(type){
   var date="",time="";
   var ExpStr=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID'];
   var pinNum="";
   if(type=="Addexec"){
	   var date = $('#winRunOrderDate').datebox('getValue');
	   if (date==""){
		   $.messager.alert("提示","要求执行日期不能为空!");
		   $('#winRunOrderDate').next('span').find('input').focus();
		   return false;
	   }
	   if(!PageAppListAllObj.DATE_FORMAT.test(date)){
		   $.messager.alert("提示","要求执行日期格式不正确!");
		   return false;
	   }
	   var time=$('#winRunOrderTime').combobox('getValue');
	   if (time==""){
		   $.messager.alert("提示","要求执行时间不能为空!");
		   $('#winRunOrderTime').next('span').find('input').focus();
		   return false;
	   }
	   if (!IsValidTime(time)){
		   $.messager.alert("提示","要求执行时间格式不正确! 时:分:秒,如11:05:01");
		   return false;
	   }
   }
   var ReasonId="",Reasoncomment="";
   ExpStr=ExpStr+"^"+ReasonId+"^"+Reasoncomment;
   if ($("#winPinNum").length>0){
	   pinNum=$("#winPinNum").val();
	   if (pinNum==""){
		   $.messager.alert("提示","密码不能为空!");
		   $("#winPinNum").focus();
		   return false;
	   }
   }
   var SelOrdRowStr=GetSelOrdRowStr();
   $.m({
	    ClassName:"web.DHCDocInPatPortalCommon",
	    MethodName:"MulOrdDealWithCom",
	    OrderItemStr:SelOrdRowStr,
	    date:date,
	    time:time,
	    type:type,
	    pinNum:pinNum,
	    ExpStr:ExpStr
	},function(val){
		if (val=="0"){
			if (type=="Addexec"){
				CureExecDataGridLoad();
			}
			destroyDialog("CureOrdDiag");
		}else{
			$.messager.alert("提示",val);
			return false;
		}
	});
}

function IsValidTime(time){
	if (time.split(":").length==3){
	   var TIME_FORMAT=/^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/;
	}else if(time.split(":").length==2){
	   var TIME_FORMAT=/^(0\d{1}|1\d{1}|2[0-3]):([0-5]\d{1})$/;  
	}else{
	   return false;
	}
	if(!TIME_FORMAT.test(time)) return false;
	return true;
}

function GetSelOrdRowStr(){
	var SelOrdRowStr="";
	var SelOrdRowArr=CureApplyDataGrid.datagrid('getChecked');
	for (var i=0;i<SelOrdRowArr.length;i++){
	   if (SelOrdRowArr[i].OrderId==""){
		    continue;  
	   }
	   if (SelOrdRowStr=="") SelOrdRowStr=SelOrdRowArr[i].OrderId+String.fromCharCode(1)+"";
	   else SelOrdRowStr=SelOrdRowStr+"^"+SelOrdRowArr[i].OrderId+String.fromCharCode(1)+""
	}
	return SelOrdRowStr;
}

function ShowGridRightMenu(e,rowIndex, rowData){
	if($("#RightKeyMenu").length==0){return}
	e.preventDefault(); //阻止浏览器捕获右键事件
   	$("#RightKeyMenu").empty(); //	清空已有的菜单
	CureApplyDataGrid.datagrid("clearSelections"); 
	CureApplyDataGrid.datagrid("checkRow", rowIndex);
	//if (rowData.OrdFreqCode!="PRN") return false;
	var RightMenu="{'id':'DOCCureOrder', 'text':'治疗申请单','handler':'', 'displayHandler':'', 'iconCls':'',menu:{items:[{'id':'PRNOrderAddExecOrder', 'text':'增加执行记录','handler':'addExecOrderHandler', 'displayHandler':'addExecOrderShowHandler', 'iconCls':''}]}}"
    var RightMenu=eval("("+RightMenu+")");
    if ($.isEmptyObject(RightMenu)) return false;
    var RightMenuArr=RightMenu.menu.items;
    for (var i=0;i<RightMenuArr.length;i++){
        var title="";
        var displayHandler=RightMenuArr[i].displayHandler;
        if (displayHandler!=""){
            title=eval(displayHandler)(rowIndex,rowData);
        }
        if (RightMenuArr[i].handler=="") continue;
        $('#RightKeyMenu').menu('appendItem', {
            id:RightMenuArr[i].id,
			text:RightMenuArr[i].text,
			iconCls: RightMenuArr[i].iconCls, //'icon-ok' 
			onclick: eval(RightMenuArr[i].handler)
		});
		if (title!=""){
			var item = $('#RightKeyMenu').menu('findItem', RightMenuArr[i].text);
			$('#RightKeyMenu').menu('disableItem', item.target);
			$("#"+RightMenuArr[i].id+"").addClass("hisui-tooltip");
			$("#"+RightMenuArr[i].id+"").attr("title",title);
	    }
    }
    $('#RightKeyMenu').menu('show', {  
        left: e.pageX,         //在鼠标点击处显示菜单
        top: e.pageY
    });
   
}
function addExecOrderHandler(){
	destroyDialog("CureOrdDiag");
   	var html="<div id='DiagWin' style=''>"
		html +="	<table class='search-table' cellpadding='5' style='margin:0 auto;border:none;'>"
		html +="	 <tr>"
		html +="	 <td class='r-label'>"
		html +="	 "+"要求执行日期"
		html +="	 </td>"
		html +="	 <td>"
		html +="	 <input id='winRunOrderDate' type='text' class='hisui-datebox' required='required'></input>"
		html +="	 </td>"
		html +="	 </tr>"
		html +="	 <tr>"
		html +="	 <td class='r-label'>"
		html +="	 "+"要求执行时间"
		html +="	 </td>"
		html +="	 <td>"
		html +="	 <input id='winRunOrderTime' class='hisui-combobox'/> "
		html +="	 </td>"
		html +="	 </tr>"
		html +="	 </tr>"
	   	html +="	</table>"
   		html += "</div>"	
	var iconCls="icon-w-ok";
    createModalDialog("CureOrdDiag","增加执行医嘱", 380, 260,iconCls,"确定",html,"MulOrdDealWithCom('Addexec')");
    var o=$HUI.datebox('#winRunOrderDate');
    o.setValue(ServerObj.CurrentDate);
    var cbox = $HUI.combobox("#winRunOrderTime", {
	    width:'151',
		editable: true,
		multiple:false,
		mode:"remote",
		method: "GET",
		selectOnNavigation:true,
	  	valueField:'id',
	  	textField:'text',
	  	data:eval("("+ServerObj.IntervalTimeListJson+")"),
	  	onLoadSuccess:function(){
			var sbox = $HUI.combobox("#winRunOrderTime");
			sbox.setValue("");
		}
	});
    $('#winRunOrderTime').next('span').find('input').focus();
}
function addExecOrderShowHandler(rowIndex,record){
	var title="";
	var orderStatus = record.OrdStatusCode;
	var PHFreqCode = record.OrdFreqCode;
	var ApplyStatus= record.ApplyStatus ;
	var ApplyExec= record.ApplyExec;
	var ApplyOrdQty= record.OrdQty;
	var ApplyAppedTimes= record.ApplyAppedTimes;
	var ApplyFinishTimes= record.ApplyFinishTimes;
	var ApplyNoFinishTimes= record.ApplyNoFinishTimes;
	var ApplyStatusCode=record.ApplyStatusCode;
	if((orderStatus != "V")&&(orderStatus != "E")) {
		title = "医嘱非核实状态,不能增加!";
		return title;
	}else if(ApplyStatusCode== "C"){
		title = "治疗申请已撤销,不能增加!";
		return title ;
	}else if(ApplyStatusCode== "F"){
		title = "治疗申请已完成,不能增加!";
		return title ;
	}else if(PHFreqCode.toLocaleUpperCase() != "PRN"){
		title = "prn医嘱才能增加!";
		return title ;
	}else if(ApplyExec.indexOf("直接执行")<0){
		title = "非直接执行医嘱，不能增加!";
		return title ;
	}else if(parseInt(ApplyOrdQty)<=parseInt(ApplyAppedTimes+ApplyFinishTimes+ApplyNoFinishTimes)){
		title = "已达申请数量上限,不能继续增加!";
		return title ;
	}
	return title;	
}