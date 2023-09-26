var PageLogic={
	m_PatientCureTabDataGrid:"",
	m_CureDetailDataGrid:""
}
$(document).ready(function(){
	Init();
	InitEvent();
	var hospComp = GenUserHospComp();
	hospComp.jdata.options.onSelect = function(e,t){
		var HospID=t.HOSPRowId;
		PatientCureTabDataGridLoad();	
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		PatientCureTabDataGridLoad();	
	}	
});

function Init(){
	//InitCardType();
	InitDate();
  	PageLogic.m_PatientCureTabDataGrid=InitPatientCureTabDataGrid();	
}

function InitEvent(){
	$('#btnFind').click(PatientCureTabDataGridLoad);
    $('#btnExport').click(ExportCureReport);
    $('#btnClear').click(ClearHandle);
	$('#ApplyNo').bind('keydown', function(event){
		if(event.keyCode==13){
			PatientCureTabDataGridLoad();
		}
	});
    InitPatNoEvent(PatientCureTabDataGridLoad);
	InitCardNoEvent(PatientCureTabDataGridLoad);
}

function InitPatientCureTabDataGrid()
{
	var PatientCureToolBar = [{
		id:'BtnDetailView',
			text:'申请单浏览', 
			iconCls:'icon-funnel-eye',  
			handler:function(){
				OpenApplyDetailDiag();
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
	var PatientCureColumn=[[ 
		{field:'ApplyNo',title:'申请单号',width:120,align:'left', resizable: true},  
		{field:'PatNo',title:'登记号',width:100,align:'left', resizable: true},   
		{field:'PatName',title:'姓名',width:60,align:'left', resizable: true
		},   
		{field:'PatOther',title:'患者其他信息',width:200,align:'left', resizable: true},
		{field:'ArcimDesc',title:'治疗项目',width:200,align:'left', resizable: true},
		{field:'OrdOtherInfo',title:'医嘱其他信息',width:150,align:'left', resizable: true}, 
		{field:'OrdAddLoc',title:'开单科室',width:100,align:'left', resizable: true},  
		{field:'OrdUnitPrice',title:'单价',width:50,align:'left', resizable: true}, 
		{field:'OrdQty',title:'数量',width:50,align:'left', resizable: true}, 
		{field:'OrdBillUOM',title:'单位',width:50,align:'left', resizable: true}, 
		{field:'OrdPrice',title:'总金额',width:60,align:'left', resizable: true}, 
		{field:'ApplyAppedTimes',title:'已预约次数',width:80,align:'left', resizable: true,hidden:((ServerObj.myTriage=="Y")||(ServerObj.DocCureUseBase=="1"))?true:false},
		{field:'ApplyNoAppTimes',title:'未预约次数',width:80,align:'left', resizable: true,hidden:((ServerObj.myTriage=="Y")||(ServerObj.DocCureUseBase=="1"))?true:false},
		{field:'ApplyFinishTimes',title:'已治疗次数',width:80,align:'left', resizable: true,hidden:((ServerObj.myTriage=="Y")||(ServerObj.DocCureUseBase=="1"))?true:false,
			formatter:function(value,row,index){
					return '<a href="###" id= "'+row["TIndex"]+'"'+' onmouseover=ShowCureEexcDetail(this);'+' ondblclick=ShowCureDetail('+row.TIndex+','+row.DCARowId+');>'+row.ApplyFinishTimes+"</a>"
				},
				styler:function(value,row){
					return "color:blue;text-decoration: underline;"
				}
		},
		{field:'ApplyNoFinishTimes',title:'未治疗次数',width:80,align:'left', resizable: true,hidden:((ServerObj.myTriage=="Y")||(ServerObj.DocCureUseBase=="1"))?true:false},
		{field:'OrdBilled',title:'是否缴费',width:70,align:'left', resizable: true,
			styler: function(value,row,index){
				if (value == "否"){
					return 'background-color:#ffee00;color:red;';
				}
			}
		},
		{field:'OrdReLoc',title:'接收科室',width:100,align:'left', resizable: true},   
		{field:'ServiceGroup',title:'服务组',width:80,align:'left', resizable: true}, 
		{ field: 'ApplyExec', title: '是否可预约', width: 80, align: 'left',resizable: true,hidden:(ServerObj.myTriage=="Y")?true:false
			,styler: function(value,row,index){
				if (value.indexOf("直接执行")>=0){
					return 'color:#FF6347;';
				}
			}
		},
		{field:'ApplyStatus',title:'申请状态',width:80,align:'left', resizable: true},
		{field:'ApplyUser',title:'申请医生',width:80,align:'left', resizable: true},
		{field:'ApplyDateTime',title:'申请时间',width:80,align:'left', resizable: true},
		{field:'ApplyStatusCode',title:'ApplyStatusCode',width:80,align:'left', resizable: true,hidden:true},
		{field:'DCARowId',title:'DCARowId',width:30,hidden:true}  	
			   
	 ]]
	var fitColumnVal=false;
	if(ServerObj.DocCureUseBase==1){
		fitColumnVal=true;
	}
	var PatientCureTabDataGrid=$('#PatientCureTab').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : fitColumnVal,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		url : '',
		loadMsg : '加载中..',  
		pagination : true,
		rownumbers : true,
		idField:"DCARowId",
		pageSize : 20,
		pageList : [20,50,100],
		columns : PatientCureColumn,
		toolbar : PatientCureToolBar,
		onSelect:function(index, row){
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
	return PatientCureTabDataGrid
}
function PatientCureTabDataGridLoad()
{
	var StartDate=$("#StartDate").datebox("getValue");
	var EndDate=$("#EndDate").datebox("getValue");
	var PatientID=$("#PatientID").val();
	var patName=$("#patName").val();
	var ApplyNo=$("#ApplyNo").val()
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Apply",
		QueryName:"FindAllCureApplyListHUI",
		'PatientID':PatientID,
		'StartDate':StartDate,
		'EndDate':EndDate,
		'outCancel':"",
		'FinishDis':"",
		'PatName':patName,
		'TriageFlag':"ALL",
		'LogLocID':session['LOGON.CTLOCID'],
		'LogUserID':session['LOGON.USERID'],
		'ApplyNo':ApplyNo,
		HospID:Util_GetSelUserHospID(),
		Pagerows:PageLogic.m_PatientCureTabDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		PageLogic.m_PatientCureTabDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
		PageLogic.m_PatientCureTabDataGrid.datagrid("clearSelections");
		PageLogic.m_PatientCureTabDataGrid.datagrid("clearChecked");	
	})
}

function ExportCureReport(){
	try{
		var UserID=session['LOGON.USERID'];
		var RowIDs=CureReportDataGrid.datagrid('getRows');
		//if(RowIDs.length)
		var RowNum=RowIDs.length;
		if(RowNum==0){
			$.messager.alert("提示","未有需要导出的数据");
			return false;
		}
		CureReportDataGrid.datagrid('selectRow',0);
		var ProcessNo=""
		var row = CureReportDataGrid.datagrid('getSelected');
		if (row){
			ProcessNo=row.Job
		}

		if(ProcessNo==""){
			$.messager.alert("提示","获取进程号错误");
			return false;
		}
		var datacount=tkMakeServerCall(PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,"GetQryWorkReportForNum",ProcessNo,UserID);
		if(datacount==0){
			$.messager.alert("提示","获取导出数据错误");
			return false;
		}
	
		var xlApp,xlsheet,xlBook;
		var TemplatePath=ServerObj.PrintBath+"DHCDocCureWorkReportUser.xlsx";
		xlApp = new ActiveXObject("Excel.Application");
		xlBook = xlApp.Workbooks.Add(TemplatePath);
	    
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.PageSetup.LeftMargin=0;  //lgl+
	    xlsheet.PageSetup.RightMargin=0;
    	
    	var StartDate=$("#StartDate").datebox("getValue");
		var EndDate=$("#EndDate").datebox("getValue");
    	var DateStr=StartDate+"至"+EndDate
    	xlsheet.cells(2,2)=DateStr;
		var myret=tkMakeServerCall(PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,"GetLocDesc",session['LOGON.CTLOCID']);
		var Title=myret+"个人治疗工作量统计"
    	var xlsrow=3;
		xlsheet.cells(1,1)=Title;
	    for(var i=1;i<=datacount;i++){
			var ret=tkMakeServerCall(PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,"GetQryWorkReportForInfo",ProcessNo,i,UserID);
			if(ret=="") return ;
			var arr=ret.split("^");
			xlsrow=xlsrow+1;
			var FinishUser=arr[6]
			var ArcimDesc=arr[1]
			var UnitPrice=arr[2]
			var OrderQty=arr[3]
			var OrdBillUOM=arr[4]
			var OrdPrice=arr[5]
			if(OrdBillUOM!="")OrdBillUOM="/"+OrdBillUOM;
			xlsheet.cells(xlsrow,1)=FinishUser;
			xlsheet.cells(xlsrow,2)=ArcimDesc;
			xlsheet.cells(xlsrow,3)=UnitPrice+"元";;
		    xlsheet.cells(xlsrow,4)=OrderQty+OrdBillUOM;
		    xlsheet.cells(xlsrow,5)=OrdPrice+"元";;		    
	    }
	    xlsheet.printout;
	    gridlist(xlsheet,4,xlsrow,1,5)
		xlBook.Close (savechanges=true);
		xlApp.Quit();
		xlApp=null;
		xlsheet=null;
	}catch(e){
		alert(e.message);	
	}
}

function ClearHandle(){
	InitCardType();
	$("#CardTypeNew,#CardNo,#patNo,#patName,#PatientID,#ApplyNo").val("");
	InitDate();	
}

function ShowCureDetail(inde,id){
	var dhwid=window.screen.availWidth-200;
	var dhhei=window.screen.availHeight-300;
	var wid=200/2;
	$('#add-dialog').window('open').window('resize',{width:dhwid,height:dhhei,top: 50,left:wid});
	var CureDetailDataGrid=$('#tabCureDetail').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		checkOnSelect:false,
		fitColumns : false,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		singleSelect:false,    
		url : '',
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"OEORERowID",
		//pageNumber:0,
		pageSize : 20,
		pageList : [20,50,100],
		columns :[[ 
        			{field:'DCARowId',title:'',width:1,hidden:true}, 
        			{field:'PapmiNo',title:'登记号',width:100},   
        			{field:'PatientName',title:'姓名',width:100},
        			{field:'ArcimDesc',title:'治疗项目',width:220,align:'left'},  
        			//{field:'OEOREExStDate',title:'要求执行时间',width:130,align:'left'},
        			{field:'DCRContent',title:'治疗记录',width:220,align:'left'} ,
        			{field:'OEOREQty',title:'执行数量',width:80,align:'left'} ,
        			{field:'OEOREStatus',title:'执行状态',width:80,align:'left'},
        			{field:'OEOREUpUser',title:'执行人',width:60,align:'left'},
        			{field:'DCRCureDate',title:'治疗时间',width:160,align:'left'} ,
        			{field:'DCRResponse',title:'治疗反应',width:220,align:'left'} ,
        			{field:'DCREffect',title:'治疗效果',width:220,align:'left'} ,
        			{field:'OEOREExDate',title:'操作时间',width:160,align:'left'} ,
        			{field:'OEOREType',title:'医嘱类型',width:100,align:'left'} ,
        			{field:'OEORERowID',ExecID:'ID',width:50,align:'left',hidden:true}  
			 ]]
	});
	PageLogic.m_CureDetailDataGrid=CureDetailDataGrid;
	CureDetailDataGridLoad(id);
	return CureDetailDataGrid	
}

function CureDetailDataGridLoad(id)
{
	var CheckOnlyNoExcute="";
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.ExecApply",
		QueryName:"FindCureExecList",
		'DCARowId':id,
		'OnlyNoExcute':CheckOnlyNoExcute,
		'OnlyExcute':"Y",
		Pagerows:PageLogic.m_CureDetailDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		PageLogic.m_CureDetailDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})
	PageLogic.m_CureDetailDataGrid.datagrid("clearChecked");
	PageLogic.m_CureDetailDataGrid.datagrid("clearSelections");
}
function ShowCureEexcDetail(that){
	var title=""
	var content="双击浏览明细信息"
	$(that).webuiPopover({
		title:title,
		content:content,
		trigger:'hover',
		placement:'top',
		style:'inverse'
	});
	$(that).webuiPopover('show');
}
function OpenApplyDetailDiag()
{
	var rows = PageLogic.m_PatientCureTabDataGrid.datagrid("getSelections");
	if (rows.length==0) {
		$.messager.alert("提示","请选择一个申请单");
		return;
	}else if (rows.length>1){
		$.messager.alert("错误","您选择了多个申请单！",'err')
		return;
    }
	var DCARowId="";
	for(var i=0;i<rows.length;i++){
		var DCARowId=rows[i].DCARowId;
		if(DCARowId!=""){
			break;	
		}
	}
	if(DCARowId==""){
		$.messager.alert('Warning','请选择一条申请单');
		return false;
	}
	var href="doccure.apply.update.hui.csp?DCARowId="+DCARowId;
	/*var ReturnValue=window.showModalDialog(href,"","dialogwidth:1200px;dialogheight:35em;status:no;center:1;resizable:yes");
	if (ReturnValue !== "" && ReturnValue !== undefined) 
    {
		if(ReturnValue){
			PatientCureTabDataGridLoad();	
		}
    }*/
	websys_showModal({
		url:href,
		title:'申请单浏览',
		width:'90%',
		height:window.screen.availHeight-100,
		PatientCureTabDataGridLoad:PatientCureTabDataGridLoad
	});
}
function UpdateAssessment(){
	var rows = PageLogic.m_PatientCureTabDataGrid.datagrid("getSelections");
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
		var rowIndex = PageLogic.m_PatientCureTabDataGrid.datagrid("getRowIndex", rows[i]);
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