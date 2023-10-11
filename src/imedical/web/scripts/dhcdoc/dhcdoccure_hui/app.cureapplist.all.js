var CureApplyDataGrid="";
var PageAppListAllObj={
	m_SelectArcimID:"",
	_SELECT_DCAROWID:"",
	_SELECT_DCARecLOCROWID:"",
	m_CureAppScheduleListDataGrid:"",
	m_CurePatientDataGrid:"",
	m_PrePageNumber:"",
	m_NotReloadAppDataGrid:"",
	m_selTabTitle:"",
	m_LoadTabTimer:"",
	m_CureSingleAppoint:"",
	m_SameServiceGroup:["预约","分配"],
	PatCondition:[{id:"PatNo",desc:$g("登记号")},{id:"PatMedNo",desc:$g("住院号")},{id:"PatName",desc:$g("患者姓名")}],
	dw:$(window).width(),
	dh:$(window).height(),
	MainSreenFlag:websys_getAppScreenIndex()
}

$(window).load(function(){
	InitOrderLoc();
	InitOrderDoc();
	InitArcimDesc();
	InitPatCondition();
	InitOthChkCondition();
	CureApplyDataGridLoad();
})

$(document).ready(function(){	
	Init();
	InitEvent();
	PageHandle();		
});

function Init(){
	InitSingleAppointMode();
	InitCureApplyDataGrid();
	PageAppListAllObj.m_CurePatientDataGrid=com_Util.InitCurePatientDataGrid(CureApplyDataGridLoad);
	$("#StartDate").datebox('setValue',ServerObj.CurrentDate);	
	$("#EndDate").datebox('setValue',ServerObj.CurrentDate);	
	if(ServerObj.myTriage=="Y"){
		if(ServerObj.DocCureUseBase=="0"){	
			//分诊资源界面Init
			appList_triageResListObj.InitTriageLoc();
			appList_triageResListObj.InitCureRBCResListDataGrid();
			//分诊列表界面
			appList_triageListObj.InitCureTriageListDataGrid();		
		}
	}else{
		if(ServerObj.LayoutConfig!=""){
			appList_execObj.InitExecDate();
			appList_execObj.InitExecEvent();
			appList_execObj.InitCureExecDataGrid();
	
			if(ServerObj.DocCureUseBase=="0"){
				//预约资源界面Init
				appList_appResListObj.InitScheduleTab("");
				//预约列表Init
				appList_appListObj.InitCureApplyAppDataGrid();
			}
			
			if($("#Apply_Asslist").length>0){
				//评估列表Init
				workList_AssListObj.InitCureAssessmentDataGrid();	
			}
		}
		InitAppScheduleListComb();
	}
}

function InitEvent(){
	InitCureAppListEvent();	
	if(ServerObj.DocCureUseBase=="0"){
		if(ServerObj.myTriage=="Y"){
			appList_triageResListObj.InitTriageResListEvent();
			appList_triageListObj.InitCureTriageListEvent();
		}else{
			appList_appResListObj.InitApplyResListEvent();
			appList_appListObj.InitApplyAppListEvent();	
		}
	}
	
	if($('#apptabs-dialog').length>0){
		$('#apptabs-dialog').window({
			onClose:function(){
				RefreshDataGrid();	
			}	
		})	
	}
	$('#appschedulelist-dialog').window({
		onClose:function(){
			RefreshDataGrid();	
		}	
	})	
}

function InitCureAppListEvent(){
	$('#btnFind').bind('click', function(){
		CureApplyDataGridLoad();
	});
	
	$('#btnClear').bind('click', function(){
		ClearHandle();
	});
	$('#btnSearchAppSchedule').click(function(){
		CureAppScheduleListDataGridLoad();
	});
	$('#ApplyNo').bind('keydown', function(event){
		if(event.keyCode==13)
		{
			CureApplyDataGridLoad();
		}
	});
	$HUI.checkbox("#LongOrdPriority",{
		onCheckChange:function(e,value){
			setTimeout("CureApplyDataGridLoad();",10)
		}
	})
	
	$('#PatConditionVal').bind('keydown', function(event){
		if(event.keyCode==13)
		{
			var PatCondition=$("#PatCondition").combobox("getValue");
			if(PatCondition=="PatNo"){
				PatNoHandle(EventApplyDataGridLoad,this.id);	
				if ($(this).val()==""){
					$("#PatientID").val("");
				}
			}else{
				EventApplyDataGridLoad();
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
            setTimeout("CureApplyDataGridLoad();",10)
        }
    });
	
	//common.readcard.js
	//InitPatNoEvent(CureApplyDataGridLoad);
	InitCardNoEvent(EventApplyDataGridLoad); 
}

function PageHandle(){
	if(ServerObj.myTriage!="Y"){	
		if(ServerObj.DocCureUseBase=="1"){
			$("#applist_panel").panel({title: $g('治疗执行-申请单列表')})
		}else{
			if(ServerObj.CureAppVersion!="V1"){
				$("#applist_panel").panel({title: $g('治疗执行-申请单列表')})
			}
			resizePanel();
		}
	}
	if(ServerObj.DocCureUseBase=="0"){
		resizePanel();
	}	
}

function InitPatCondition(){
	$HUI.combobox("#PatCondition", {
		valueField: 'id',
		textField: 'desc', 
		editable:false,
		data: PageAppListAllObj.PatCondition,
		onSelect:function(){
	    	$("#PatConditionVal").val("");
	    	$("#PatientID").val("");
	    }
	});
}
function InitOthChkCondition(){
	if(ServerObj.myTriage=="Y"){
		var OthChkConditionAry=[{id:"FinishDis",desc:$g("申请状态-全部有效")},{id:"CancelDis",desc:$g("申请状态-已分配")}]
	}else{
		//预约未完成：可预约数>0的申请单
		var OthChkConditionAry=[{id:"FinishDis",desc:$g("申请状态-已完成")},{id:"CancelDis",desc:$g("申请状态-已撤销")},{id:"ANF",desc:$g("预约未完成"),title:"可预约数大于0的申请单"}]
	}
	var myAry=[{id:"OPCheck",desc:$g("患者类型-门急诊")},{id:"IPCheck",desc:$g("患者类型-住院")},{id:"ChkCurrLoc",desc:$g("本科就诊患者")}]
	OthChkConditionAry.push.apply(OthChkConditionAry,myAry);
	$HUI.combobox("#ComboOtherChk", {
		valueField: 'id',
		textField: 'desc', 
		editable:false,
		multiple:true,
		//rowStyle:'checkbox',
		selectOnNavigation:false,
		panelHeight:"auto",
		data: OthChkConditionAry,
		formatter: function(row){
            var opts = $(this).combobox('options');
            var value=row[opts.valueField];
            var text=row[opts.textField];
            var title=row.title;
            if(row.selected==true){
				var rhtml = text+"<span id='i"+value+"' class='icon icon-ok'></span>";
			}else{
				var rhtml = text+"<span id='i"+value+"' class='icon'></span>";
			}
            if(value=='ANF'){
                return '<div title='+title+'>'+rhtml+'<\/div>';    
            }else{
	            return rhtml;
	        }
		},
		onChange:function(newval,oldval){
			$(this).combobox("panel").find('.icon').removeClass('icon-ok');
			for (var i=0;i<newval.length;i++){
				$(this).combobox("panel").find('#i'+newval[i]).addClass('icon-ok');
			}
		}
	});
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
		PageAppListAllObj.m_CureSingleAppoint=SingleAppointMode;
	}
}

function ClearHandle(){
	//InitCardType();
	$('.search-table input[class*="validatebox"]').val("");
	$('.search-table input[type="checkbox"]').checkbox('uncheck');
	$("#StartDate,#EndDate").datebox("setValue","");	
	PageAppListAllObj.m_SelectArcimID=""; 
	$("#ComboArcim").lookup('setText','');
	$("#ComboOrderLoc,#ComboOrderDoc,#PatCondition").combobox('select','');
	$("#ComboOtherChk").combobox('setValues','');
	$("#StartDate").datebox('setValue',ServerObj.CurrentDate);	
	$("#EndDate").datebox('setValue',ServerObj.CurrentDate);	
}

function LoadCurePatientDataGridData(GridData){
	var originalRows=GridData.originalRows;	
	var len=originalRows.length;
	var PatLen=0;
	var PatArray=[];
	var Ids=[];
	for(var i=0;i<len;i++){
		var originalRow=originalRows[i];
		var PatientID=originalRow.PatientID;
		var PatientName=originalRow.PatName;
		var PatientNo=originalRow.PatNo;
		var PatOther=originalRow.PatOther;
		var PatOtherArr=PatOther.split("|")
		PatOtherArr.pop();
		var PatOther=PatOtherArr.join(" ");
		var mobj={
			PatientID:PatientID,
			PatientName:PatientName,
			PatientNo:PatientNo,
			PatOther:PatOther	
		}
		if(Ids.indexOf(PatientID)<0){
			PatArray.push(mobj);
			Ids.push(PatientID);
			PatLen++;
		}
	}
	
	var dataobj={
		rows:[],
		total:0,
		curPage:1	
	}
	dataobj.total=PatLen;
	dataobj.rows=PatArray;
	PageAppListAllObj.m_CurePatientDataGrid.datagrid('clearSelections').datagrid({loadFilter:pagerFilter}).datagrid('loadData',dataobj); 
}

function InitCureApplyDataGrid()
{
	// Toolbar
	if(ServerObj.myTriage=="Y"){
		var cureApplyToolBar = [{
			id:'BtnDetailView',
			text:'申请单浏览', 
			iconCls:'icon-eye',  
			handler:function(){
				OpenApplyDetailDiag();
				}
			}
		];
		if((ServerObj.LayoutConfig=="2")&&(ServerObj.DocCureUseBase=="0")){
			cureApplyToolBar.push("-");
			cureApplyToolBar.push({
				id:'Apply_TriageReslist',
				text:'分配', 
				iconCls:'icon-book',  
				handler:function(){
					Apply_Click("Apply_TriageReslist");
				}
			})
			cureApplyToolBar.push({
				id:'Apply_Triagelist',
				text:'分配列表', 
				iconCls:'icon-sample-stat',  
				handler:function(){
					Apply_Click("Apply_Triagelist");
				}
			})
		}
	}else{
		var cureApplyToolBar = [{
			id:'BtnCall',
			text:'叫号',
			iconCls:'icon-ring-blue',
			handler:function(){
				DHCDocCure_CureCall.CureCallHandle(CureApplyDataGrid,CureApplyDataGridLoad);
			}
		},{
			id:'BtnPass',
			text:'过号',
			iconCls:'icon-skip-no',
			handler:function(){
				DHCDocCure_CureCall.SkipCallHandle(CureApplyDataGrid,CureApplyDataGridLoad);		 
			}
		},'-',{
			id:'BtnDetailView',
			text:'申请单浏览', 
			iconCls:'icon-funnel-eye',  
			handler:function(){
				OpenApplyDetailDiag();
			}
		}/*,"-",{
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
		},'-'*/,{
			id:'AddOrderBtn',
			text:'费用补录', 
			iconCls:'icon-write-order',  
			handler:function(){
				AddOrderClick();
			}
		}];
		
		if(ServerObj.LayoutConfig=="2"){
			cureApplyToolBar.push("-");
			cureApplyToolBar.push({
				id:'Apply_Execlist',
				text:'直接执行', 
				iconCls:'icon-mutpaper-tri',  
				handler:function(){
					Apply_Click("Apply_Execlist");
				}
			})
			if(ServerObj.DocCureUseBase=="0" && ServerObj.CureAppVersion=="V1"){
				cureApplyToolBar.push({
					id:'Apply_Reslist',
					text:'预约', 
					iconCls:'icon-book',  
					handler:function(){
						Apply_Click("Apply_Reslist");
					}
				})
			}
			cureApplyToolBar.push({
				id:'Apply_Asslist',
				text:'治疗评估', 
				iconCls:'icon-paper-table',  
				handler:function(){
					Apply_Click("Apply_Asslist");
				}
			})
		}
	}
	var hiddenColumn=false;
	if((ServerObj.myTriage=="Y")||(ServerObj.DocCureUseBase=="1")||(ServerObj.CureAppVersion!="V1")){
		hiddenColumn=true;	
	}
	var cureApplyColumn=[[ 
		{field:'ServiceGroup',title:'服务组',width:88,align:'left', resizable: true}, 
		{field:'PatOther',title:'患者其他信息',width:200,align:'left'},
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
		{field:'ApplyNoAppTimes',title:'未预约数量',width:80,align:'left', resizable: true,hidden:hiddenColumn
			,formatter:function(value,row,index){
				var NumVal=Number(value);
				if ((NumVal == 0 ||typeof NumVal != 'number' || isNaN(NumVal))) {
					return "<span>"+value+"</span>";
				}else {
					return '<a href="javascript:void(0)" id= "'+row["DCARowId"]+'"'+' onclick=ShowAppSchedule('+row.DCARowId+','+row.ServiceGroupID+');>'+"<span class='fillspan-nosave'>"+value+"</span>"+"</a>"
				}
			}
		},
		{field:'ApplyAppedTimes',title:'已预约数量',width:80,align:'left', resizable: true,hidden:hiddenColumn},
		{field:'ApplyFinishTimes',title:'已治疗数量',width:80,align:'left', resizable: true,hidden:((ServerObj.myTriage=="Y")||(ServerObj.DocCureUseBase=="1"))?true:false},
		{field:'ApplyNoFinishTimes',title:'未治疗数量',width:80,align:'left', resizable: true,hidden:((ServerObj.myTriage=="Y")||(ServerObj.DocCureUseBase=="1"))?true:false},
		{field:'CallStatus', title: '呼叫状态', width: 80, align: 'left',resizable: true,hidden:((ServerObj.myTriage=="Y")||(ServerObj.DocCureUseBase=="1"))?true:false}, 
		{field:'OrdReLoc',title:'接收科室',width:120,align:'left', resizable: true},   
		{field:'HistoryTriRes',title:'上次分配',width:100,align:'left', resizable: true,hidden:(ServerObj.myTriage=="Y")?false:true},
		{field:'ApplyStatus',title:'申请状态',width:80,align:'left', resizable: true},
		{field:'ApplyStatusCode',title:'ApplyStatusCode',width:80,align:'left', resizable: true,hidden:true},
		{field:'ApplyUser',title:'申请医生',width:100,align:'left', resizable: true},
		{field:'ApplyDateTime',title:'申请时间',width:120,align:'left', resizable: true},
		//{field:'ServiceGroup',title:'服务组',width:30,align:'left',hidden:(HiddenLoc.indexOf(session['LOGON.CTLOCID'])<0)?true:false}, //HiddenLoc.indexOf(session['LOGON.CTLOCID'])
		{field:'ServiceGroupID',title:'服务组id',width:80,align:'left',hidden:true},
		{field:'ApplyExecFlag',title:'',width:10,align:'left',hidden:true},
		{field:'OrdFreqCode',title:'医嘱频次',width:50,align:'left',hidden:true},
		{field:'OrdStatusCode',title:'医嘱状态',width:50,align:'left',hidden:true},
		{field:'OrderId',title:'OrderId',width:50,align:'left',hidden:true},
		{field:'DCAAdmID',title:'DCAAdmID',width:50,align:'left',hidden:true},
		{field:'PatientID',title:'PatientID',width:50,align:'left',hidden:true},
		{field:'DCARowId',title:'DCARowId',width:30,hidden:true}  	
			   
	 ]]
	var mypageSize=10;
	if(ServerObj.LayoutConfig=="2"){
    	mypageSize=20;
    }
	// 治疗记录申请单Grid
	CureApplyDataGrid=$('#tabCureApplyList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : false,
		checkOnSelect:true,
		fitColumns : false,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		url : '',
		loadMsg : '加载中..',  
		pagination : true,
		rownumbers : true,
		idField:"DCARowId",
		pageSize : mypageSize,
		pageList : [5,10,20,50],
		frozenColumns : [
			[
				{field:'RowCheck',checkbox:true},     
				{field:'ApplyNo',title:'申请单号',width:110,align:'left', resizable: true},  
				{ field: 'ApplyExec', title: '是否可预约', width: 80, align: 'left',resizable: true,hidden:(ServerObj.myTriage=="Y")?true:false
					,formatter:function(value,row,index){
						if (row.ApplyExecFlag=="Y"){
							return "<span class='fillspan-exec'>"+value+"</span>";
						}else {
							return "<span class='fillspan-app'>"+value+"</span>";
						}
					}
				},
				{field:'PatNo',title:'登记号',width:100,align:'left', resizable: true},   
				{field:'PatName',title:'姓名',width:60,align:'left', resizable: true},   
				{field:'ArcimDesc',title:'治疗项目',width:200,align:'left', resizable: true,
					formatter: function (value, rowData, rowIndex) {
						var retStr=value;
						if(value!=""){
							retStr = "<a href='#' title='"+$g("医嘱及绑定信息")+"'  onclick='com_openwin.applyAppenditemShow(\""+rowData.OrderId+"\")'>"+value+"</a>"
						}
						return retStr;
					}
				}
			]
		],
		columns : cureApplyColumn,
    	toolbar : cureApplyToolBar,
		onClickRow:function(rowIndex, rowData){
			var msg=true;
			var ret=true;
			if(ServerObj.LayoutConfig=="1"){
				ret=CheckSelectedRow(rowIndex, rowData,msg);
			}
			if(ret){
				loadTabData();
                //展示副屏数据
				if (PageAppListAllObj.MainSreenFlag==0){
					var DCARowId=rowData["DCARowId"];
			        if (DCARowId==""){
			        	var Obj={PatientID:rowData.PatientID,EpisodeID:rowData.DCAAdmID,mradm:"",PageShowFromWay:"ApplyEntry"};
						websys_emit("onOpenCureInterface",Obj);
						return;
			        }
				    var Obj={DCARowId:DCARowId,EpisodeID:rowData["DCAAdmID"]};
					websys_emit("onOpenCureAppInfo",Obj);
				}
			}
		},
        onDblClickRow: function(index,row) {
			var DCARowId=row["DCARowId"];
			if (DCARowId=="") return;
	        if (PageAppListAllObj.MainSreenFlag==0){
			    var Obj={DCARowId:DCARowId,EpisodeID:row["DCAAdmID"]};
				websys_emit("onOpenCureAppInfo",Obj);
			}
		},
		onRowContextMenu:function(e, rowIndex, rowData){
			ShowGridRightMenu(e,rowIndex, rowData,"Ord");
		},
		onCheck:function(rowIndex, rowData){
			var ret=true;
			if(ServerObj.LayoutConfig=="1"){
				ret=CheckSelectedRow(rowIndex, rowData);
			}
			if(ret){
				loadTabData();
			}
		},onCheckAll:function(rows){
			var load=true;
			if(ServerObj.LayoutConfig=="1"){
				for(var index=0;index<rows.length;index++){
					var ret=CheckSelectedRow(index, rows[index]);
					if(!ret){
						load=false;
						break;	
					}
				}
			}
			if(load){
				loadTabData();
			}else{
				$(this).datagrid("uncheckAll").datagrid("unselectAll");
			}
		},onUncheckAll:function(rows){
			loadTabData();
		},
		onUncheck:function(rowIndex, rowData){
			loadTabData();
		},
		rowStyler:function(index,row){ 
			if(ServerObj.myTriage!="Y"){  
		        if (row.CallStatus=="正在呼叫"){   
		            return 'background-color: #21ba45 !important;color:#fff !important;'; //#00DC00
		        }else if (row.CallStatus=="过号"){   
		            return 'background-color: #d2eafe  !important;color:#000 !important;';
		        }   
			}else{
				return "";	
			}
	    },
	    onLoadSuccess: function () {   //隐藏表头的checkbox
            //var headchkobj=$(this).parent().find("div .datagrid-header-check")
            //    .children("input[type=\"checkbox\"]").eq(0);
            //headchkobj.attr("style", "display:none;");
            if(ServerObj.DHCDocCureUseCall==0){
				$("#BtnCall,#BtnPass").linkbutton("disable");
			}
        },onSelect:function(index, row){
			var frm=dhcsys_getmenuform();
			if (frm){
				var DCARowId=row.DCARowId;
				var EpisodeID=row.DCAAdmID;
				var PatientID=row.PatientID;
				if(EpisodeID==""){
					var Info=$.cm({
						ClassName:"DHCDoc.DHCDocCure.Common",
						MethodName:"GetPatAdmIDByDCA",
						DCARowId:DCARowId,
						dataType:"text"
					},false); 
					if(Info!=""){
						PatientID=Info.split("^")[1];
						EpisodeID=Info.split("^")[0]
					}
				}
				frm.PatientID.value=PatientID;
				frm.EpisodeID.value=EpisodeID;
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

}

/**
	@检测行数据选择：
	@预约、分配时限制每次选择相同服务组、接收科室的申请单
	@单申请单预约模式下，选择预约页签,单申请预约模式下将datagrid行选择改为单选模式
	@单申请单预约模式下，从其他页签多选了申请单记录后，切到预约页签时，自动取消勾选除第一条记录的其他记录CheckSelectRow方法中实现
	@Input:
		rowIndex 当前选择行索引
		rowData  当前选择行的记录
		noMsgTip 是否弹窗提示 true弹窗提示
		tabTitle 选择的页签,未传则取tabs getSelected的页签
*/
function CheckSelectedRow(rowIndex, rowData,noMsgTip,tabTitle){
	if(typeof(tabTitle)=="undefined"){tabTitle=""}
	if(tabTitle==""){
		var tabsObj=GetSelTabsObj();
		tabTitle=tabsObj.title;
	}
	
	var opts=CureApplyDataGrid.datagrid("options");
	if(tabTitle=="预约"){
		//选择预约页签,单申请预约模式下将datagrid行选择改为单选模式
		if(PageAppListAllObj.m_CureSingleAppoint=="1"){
			if(!opts.singleSelect){
				opts.singleSelect=true;
			}
		}else{
			if(opts.singleSelect){
				opts.singleSelect=false;
			}
		}
	}else{
		if(opts.singleSelect){
			opts.singleSelect=false;
		}
	}
	
	if(PageAppListAllObj.m_SameServiceGroup.indexOf(tabTitle)==-1){
		return true;	
	}
	
	var SelServiceGroup=rowData.ServiceGroup;
	var SelOrdReLocId=rowData.OrdReLocId;
	var ApplyExec=rowData.ApplyExec;
	var rows = CureApplyDataGrid.datagrid("getSelections");
	var length=rows.length;
	var findFlag=0;
	for(var i=0;i<length;i++){
		var MyServiceGroup="";
		var MyServiceGroup=rows[i].ServiceGroup;
		var MyOrdReLocId=rows[i].OrdReLocId;
		if ((SelServiceGroup!=MyServiceGroup)||(SelOrdReLocId!=MyOrdReLocId)){
			if(!noMsgTip){
				$.messager.alert("提示","受"+tabTitle+"时仅限相同服务组限制,一次选择只能选中相同服务组和接收科室的申请单，请重新选择！",'warning')
			}
			CureApplyDataGrid.datagrid("uncheckRow",rowIndex);
			CureApplyDataGrid.datagrid("unselectRow",rowIndex);
			findFlag=1;
			break;		
		}
	}
	if(findFlag==1)return false;
	return true;
}

function loadTabData() {
	var rows = CureApplyDataGrid.datagrid("getSelections");
	var idAry=[];
	var DCARowIdStr="";
	var OrdReLocId="";
	for(var i=0;i<rows.length;i++){
		idAry.push(rows[i].DCARowId);
		OrdReLocId=rows[i].OrdReLocId;
	}
	DCARowIdStr=idAry.join("!");
	PageAppListAllObj._SELECT_DCAROWID=DCARowIdStr;
	PageAppListAllObj._SELECT_DCARecLOCROWID=OrdReLocId;
	if(ServerObj.LayoutConfig=="1"){
		clearTimeout(PageAppListAllObj.m_LoadTabTimer);
		if(PageAppListAllObj.m_NotReloadAppDataGrid!="Y"){
			var tabsObj=GetSelTabsObj();
			PageAppListAllObj.m_LoadTabTimer=setTimeout(function(){
				DataGridLoad(tabsObj.title);
			},100)
		}else{
			if($("#Apply_Reslist").length>0){
				PageAppListAllObj.m_LoadTabTimer=setTimeout(function(){
					DataGridLoad("预约列表");
				},100)
			}
		}
	}
}

function GetSelTabsObj(){
	var tabsObj={};
	var seltab = $('#tabs').tabs('getSelected');
	var title = seltab.panel('options').title;
	var index = $('#tabs').tabs('getTabIndex',seltab);
	tabsObj={
		title:title,
		index:index	
	}
	return tabsObj
}

function EventApplyDataGridLoad(){
	$("#StartDate,#EndDate").datebox('setValue',"");	
	CureApplyDataGridLoad();
}

function CureApplyDataGridLoad(NotClearFlag,PreDCAIDArr,CallBackFun,argObj)
{
	var mArgObj=$.extend({
			NotReloadPatData:""
	},argObj);
	var tabsobj=GetSelTabsObj()
	var ExecFlag="N";
	if(tabsobj.title=="直接执行"){
		ExecFlag="Y";
		if(ServerObj.DHCDocCureAppointAllowExec==1){
			ExecFlag="";
		}
	}
	if((tabsobj.title=="治疗评估")||(ServerObj.DHCDocCureAppQryNotWithTab==1)){
		ExecFlag="";
	}
	
	PageAppListAllObj.m_PrePageNumber="";
	PageAppListAllObj.m_NotReloadAppDataGrid="";
	if(NotClearFlag=="Y"){
		var pageopt=CureApplyDataGrid.datagrid('getPager').data("pagination").options;
		PageAppListAllObj.m_PrePageNumber=pageopt.pageNumber;
		PageAppListAllObj.m_NotReloadAppDataGrid="Y";
	}else{
		PageAppListAllObj._SELECT_DCAROWID="";
		PageAppListAllObj._SELECT_DCARecLOCROWID="";	
	}
	CureApplyDataGrid.datagrid("clearSelections").datagrid("clearChecked");
	var PatientID=$("#PatientID").val();
	//var patName=$("#patName").val()
	var StartDate=$("#StartDate").datebox("getValue");
	var EndDate=$("#EndDate").datebox("getValue");
	var TriageFlag=ServerObj.myTriage;
	var ApplyNo=$("#ApplyNo").val()
	var gtext=$HUI.lookup("#ComboArcim").getText();
	if (gtext=="")PageAppListAllObj.m_SelectArcimID="";
	var queryArcim=PageAppListAllObj.m_SelectArcimID;
	var queryOrderLoc=$("#ComboOrderLoc").combobox("getValue");
	queryOrderLoc=com_Util.CheckComboxSelData("ComboOrderLoc",queryOrderLoc);
	var queryOrderDoc=$("#ComboOrderDoc").combobox("getValue");
	queryOrderDoc=com_Util.CheckComboxSelData("ComboOrderDoc",queryOrderDoc);
	
	var PatName="",PatMedNo=""; 
	var PatCondition=$("#PatCondition").combobox("getValue");
	var PatConditionVal=$("#PatConditionVal").val();
	if(PatCondition=="PatName"){
		PatName=PatConditionVal;
	}else if(PatCondition=="PatMedNo"){
		PatMedNo=PatConditionVal;
	}
	var SortType="A"; //默认时间正序
	var chkRadioJObj = $("input[name='SortType']:checked");
	if(chkRadioJObj.length>0){SortType=chkRadioJObj.val();}
	var DisCancelFlag="",FinishDisFlag="",LongOrdPriorityFlag="",CheckAdmType="",ChkCurrLocFlag="";
	var ANFFlag="";
	if($("#ComboOtherChk").length>0){
		var OtherChkAry=$("#ComboOtherChk").combobox("getValues");
		if($.hisui.indexOfArray(OtherChkAry,"FinishDis")>-1){FinishDisFlag="Y"}
		if($.hisui.indexOfArray(OtherChkAry,"CancelDis")>-1){DisCancelFlag="Y"}
		if($.hisui.indexOfArray(OtherChkAry,"OPCheck")>-1){CheckAdmType="O"}
		if($.hisui.indexOfArray(OtherChkAry,"IPCheck")>-1){CheckAdmType="I"}
		if($.hisui.indexOfArray(OtherChkAry,"ChkCurrLoc")>-1){ChkCurrLocFlag="Y"}
		if($.hisui.indexOfArray(OtherChkAry,"ANF")>-1){ANFFlag="Y"}
		if($.hisui.indexOfArray(OtherChkAry,"OPCheck")>-1 && $.hisui.indexOfArray(OtherChkAry,"IPCheck")>-1){CheckAdmType=""}
	}
	if($("#LongOrdPriority").length>0){
		var LongOrdPriority=$HUI.checkbox("#LongOrdPriority").getValue()
		if (LongOrdPriority){LongOrdPriorityFlag="Y"}
	}
	
	var QueryExpStr=session['LOGON.HOSPID']+"^"+ChkCurrLocFlag+"^"+queryOrderDoc+"^"+PatMedNo+"^"+SortType;
	var QueryExpStr=QueryExpStr+"^^"+ANFFlag;
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Apply",
		QueryName:"FindAllCureApplyListHUI",
		'PatientID':PatientID,
		'StartDate':StartDate,
		'EndDate':EndDate,
		'outCancel':DisCancelFlag,
		'FinishDis':FinishDisFlag,
		'PatName':PatName,
		'TriageFlag':TriageFlag,
		'LogLocID':session['LOGON.CTLOCID'],
		'LogUserID':session['LOGON.USERID'],
		'ApplyNo':ApplyNo,
		'LongOrdPriority':LongOrdPriorityFlag,
		'CheckAdmType':CheckAdmType,
		'queryArcim':queryArcim,
		'queryOrderLoc':queryOrderLoc,
		'ExecFlag':ExecFlag,
		'queryExpStr':QueryExpStr,
		Pagerows:CureApplyDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		CureApplyDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
		if(mArgObj.NotReloadPatData!="Y"){
			LoadCurePatientDataGridData(GridData);
		}
		if(NotClearFlag=="Y"){
			if(typeof PreDCAIDArr!='undefined'){
				SelectCheckPreDCA(PreDCAIDArr);
			}
			if(typeof CallBackFun=='function'){
				CallBackFun();
			}
		}
	})
}

function SelectCheckPreDCA(PreDCAIDArr){
	if(PreDCAIDArr.length>0){
		var ListData = CureApplyDataGrid.datagrid('getData');
		var opts = CureApplyDataGrid.datagrid('options');
		var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
		var end = start + parseInt(opts.pageSize);
		for(var k=0;k<PreDCAIDArr.length;k++){
			var DCAID=PreDCAIDArr[k];
			for (i=0;i<ListData.originalRows.length;i++){
				var DCARowId=ListData.originalRows[i].DCARowId;
				if(DCAID==DCARowId){
					var NextRowIndex=i;
					
					var NeedPageNum=Math.ceil((NextRowIndex+1)/parseInt(opts.pageSize));
					if (opts.pageNumber!=NeedPageNum){
						CureApplyDataGrid.datagrid('getPager').pagination('select',NeedPageNum);
					}
					NextRowIndex=(NextRowIndex)%parseInt(opts.pageSize);
					CureApplyDataGrid.datagrid('checkRow',NextRowIndex);
						
					break;
				}
			}
		}
	}
}

function OpenApplyDetailDiag()
{
	var DCARowId=GetSelectRow();
	if(DCARowId==""){
		return;	
	}
	
	com_openwin.ShowApplyDetail(DCARowId,ServerObj.DHCDocCureLinkPage,CureApplyDataGridLoad);
}
function refreshTab(cfg){  
    var refresh_tab = cfg.tabTitle?$('#tabs').tabs('getTab',cfg.tabTitle):$('#tabs').tabs('getSelected');  
    if(refresh_tab && refresh_tab.find('iframe').length > 0){  
	    var _refresh_ifram = refresh_tab.find('iframe')[0];  
	    var refresh_url = cfg.url?cfg.url:_refresh_ifram.src;
		if(typeof websys_writeMWToken=='function') refresh_url=websys_writeMWToken(refresh_url);   
	    _refresh_ifram.contentWindow.location.href=refresh_url;  
    }  
}

function RefreshDataGrid(NotClearFlag,PreDCAIDArr,CallBackFun){
	if(CureApplyDataGrid){
		CureApplyDataGridLoad(NotClearFlag,PreDCAIDArr,CallBackFun);
	}
}

function RefreshDataColGrid(){
	var DCARowId=GetSelectRow();
	if(DCARowId==""){
		return;	
	}
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Apply",
		MethodName:"GetCureApply",
		dataType:"text",
		DCARowId:DCARowId
	},function(CureInfo){
		if(CureInfo!=""){
			var CureInfoAry=CureInfo.split(String.fromCharCode(1));
			var CureApplyAry=CureInfoAry[1].split("^");
			var ApplyStatus=CureApplyAry[6];
			var ApplyStatusCode=CureApplyAry[35];
			var ApplyFinishTimes=CureApplyAry[11];
			var ApplyNoFinishTimes=CureApplyAry[12];
			var selRow = CureApplyDataGrid.datagrid('getSelected');
			var selIndex = CureApplyDataGrid.datagrid('getRowIndex', selRow);

			CureApplyDataGrid.datagrid('updateRow',{
				index: selIndex,
				row: {
					ApplyStatus: ApplyStatus,
					ApplyStatusCode: ApplyStatusCode,
					ApplyFinishTimes: ApplyFinishTimes,
					ApplyNoFinishTimes: ApplyNoFinishTimes
				}
			});
		}
	});
}

function FinishApplyClick(Type)
{
	if(typeof Type=="undefined"){Type="F"};
	var DCARowId=GetSelectRow();
	if(DCARowId==""){
		return;	
	}
	com_withApplyFun.FinishApplyClick(Type,DCARowId);
}
function CancelFinishHandler(){
	FinishApplyClick("CF");
}
function FinishHandler(){
	FinishApplyClick("F");
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
	var obj=com_withLocDocFun.InitComboDoc("ComboOrderDoc");
	com_withLocDocFun.InitComboLoc("ComboOrderLoc",obj);
}
function InitOrderDoc(LocID){
	/*
	$HUI.combobox("#ComboOrderDoc",{
		valueField:'TDocRowid',   
    	textField:'TResDesc',
    	filter: function(q, row){
			return (row["TResDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
		}	
	})
	*/
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
		var ApplyStatusCode=rows[i].ApplyStatusCode;
		var rowIndex = CureApplyDataGrid.datagrid("getRowIndex", rows[i]);
		if((OrdBilled!=$g("否"))&&(ApplyStatusCode!="C")){
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
	var RightMenu="{'id':'DOCCureOrder', 'text':'治疗申请单','handler':'', 'displayHandler':'', 'iconCls':'',menu:{items:["
	RightMenu=RightMenu+"{'id':'R_DetailView', 'text':'申请单浏览','handler':'OpenApplyDetailDiag', 'displayHandler':'', 'iconCls':''}"
	RightMenu=RightMenu+",{'id':'PRNOrderAddExecOrder', 'text':'增加执行记录','handler':'addExecOrderHandler', 'displayHandler':'addExecOrderShowHandler', 'iconCls':''}"
	if(ServerObj.myTriage!="Y"){
		RightMenu=RightMenu+",{'id':'R_Finish', 'text':'完成申请单','handler':'FinishHandler', 'displayHandler':'', 'iconCls':''}"
		RightMenu=RightMenu+",{'id':'R_CancelFinish', 'text':'撤销完成申请单','handler':'CancelFinishHandler', 'displayHandler':'', 'iconCls':''}"
	}
	RightMenu=RightMenu+"]}}"
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
	com_withApplyFun.addExecOrderHandler()
}
function addExecOrderShowHandler(rowIndex,record){
	return com_withApplyFun.addExecOrderShowHandler(rowIndex,record);
}
function AddOrderClick(){
	com_withApplyFun.AddOrderClick(CureApplyDataGrid);
}

function CheckSelectRow(tabTitle){
	if(typeof(tabTitle)=="undefined"){tabTitle=""}
	if(PageAppListAllObj._SELECT_DCAROWID!=""){
		var PreDCAIDArr=PageAppListAllObj._SELECT_DCAROWID.split("!");
		var ListData = CureApplyDataGrid.datagrid('getData');
		var opts = CureApplyDataGrid.datagrid('options');
		var load=true;
		for(var k=0;k<PreDCAIDArr.length;k++){
			var DCAID=PreDCAIDArr[k];
			for (i=0;i<ListData.originalRows.length;i++){
				var DCARowId=ListData.originalRows[i].DCARowId;
				if(DCAID==DCARowId){
					var checkRowIndex=(i)%parseInt(opts.pageSize);
					var ret=CheckSelectedRow(checkRowIndex, ListData.originalRows[i],"",tabTitle);
					if(!ret){
						load=false;
						break;	
					}
				}
			}
			if(!load){
				break;		
			}
		}
		if(load){
			if((PageAppListAllObj.m_CureSingleAppoint=="1")&&(PreDCAIDArr.length>1)){
				CureApplyDataGrid.datagrid("clearSelections").datagrid("clearChecked");
				$.messager.popover({msg: '单申请单预约模式下已自动取消勾选除第一条记录的其他记录',type:'info',timeout: 3000})
				SelectCheckPreDCA([PreDCAIDArr[0]]);
			}
			loadTabData();
		}else{
			CureApplyDataGrid.datagrid("clearSelections").datagrid("clearChecked");
			PageAppListAllObj._SELECT_DCAROWID="";
			if($('#apptabs-dialog').length>0){
				$('#apptabs-dialog').window('close');
			}
			return false;
		}
	}
	return true;
}

function getConfigUrl(userId,groupId,ctlocId){
	return com_Util.getConfigUrl(userId,groupId,ctlocId);
}
function resizePanel(){
	if(ServerObj.LayoutConfig=="1"){
		var AppListScale=60;
		if(ServerObj.UIConfigObj!=""){
			var data = eval('(' + ServerObj.UIConfigObj + ')');
			if ((!data['DocCure_AppListScale'])||(data['DocCure_AppListScale']=="")){
				AppListScale=60;
			}else{
				AppListScale=data['DocCure_AppListScale'];
			}
		}
		AppListScale=parseFloat(AppListScale/100);
			
		$('#main_layout').layout('panel', 'north').panel('resize',{
			height:PageAppListAllObj.dh*AppListScale
		})
		$('#main_layout').layout("resize");
	}
}

/**
	@Type需要与csp中定义的页签div id一致,即定义的工具按钮id需要与页签div id一致
*/
function Apply_Click(Type){
	if(PageAppListAllObj._SELECT_DCAROWID==""){
		$.messager.alert("提示","请选择申请单记录.","info");
		return false;
	}
	var obj=$("#"+Type);
	if(obj.length=0){
		$.messager.alert("提示","未发现定义的对应的界面","info");
		return false;
	}else{
		var tabTitle=obj[0].innerText;
		tabTitle=$.trim(tabTitle);
		
		var ret=CheckSelectRow(tabTitle);
		if(!ret){
			return;
		}
	
		var dhwid=$(document.body).width()-50;
		var dhhei=$(document.body).height()-100;
		$('#apptabs-dialog').window('open').window('resize',{
			width:dhwid,
			height:dhhei,
			top:50,
			left:25
		});
		if(PageAppListAllObj.m_selTabTitle==tabTitle){
			DataGridLoad(tabTitle);
			if(tabTitle=="预约"){
				appList_appResListObj.InitDate();
			}
		}else{
			$("#tabs").tabs("select",tabTitle);
			if(PageAppListAllObj.m_selTabTitle==""){
				DataGridLoad(tabTitle);
			}
			if(tabTitle=="预约"){
				appList_appResListObj.InitDate();
			}
		}
		PageAppListAllObj.m_selTabTitle=tabTitle;
	}
}
function ShowAppSchedule(DCARowID,ServiceGroupID){
	var dhwid=$(document.body).width()-100;
	var dhhei=$(document.body).height()-150;
	var ApplyNoAppTimes=$.cm({
		ClassName:"DHCDoc.DHCDocCure.Appointment",
		MethodName:"GetAppointLeftCount",
		'DCARowId':DCARowID,
		dataType:"text"
	},false)
	if(ApplyNoAppTimes>0){
		$('#appschedulelist-dialog').window('open').window('resize',{width:dhwid,height:dhhei,top: 50,left:45});
		SetLogLocID();
		InitTimeRangeSearch(ServiceGroupID);
		$HUI.datebox('#SttDate_Search').setValue(ServerObj.CurrentDate);
		$HUI.datebox('#EndDate_Search').setValue(ServerObj.AppEndDate);
		var SessionStr=session['LOGON.HOSPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.USERID'];
		var DataGrid=$('#tabCureAppScheduleList').datagrid({  
			fit : true,
			width : 'auto',
			border : false,
			striped : true,
			singleSelect : false,
			checkOnSelect:true,
			fitColumns : true,
			autoRowHeight : false,
			nowrap: false,
			collapsible:false,
			url : $URL+'?ClassName=DHCDoc.DHCDocCure.RBCResSchdule&QueryName=QueryAvailResApptSchdule&SessionStr='+SessionStr,
			loadMsg : '加载中..',  
			pagination : true,
			rownumbers : true,
			idField:"Rowid",
			pageSize : 20,
			pageList : [20,50],
			columns :[[   
				{ field: 'RowCheck',checkbox:true},     
				{ field: 'Rowid', title: 'ID', width: 1, align: 'left', sortable: true,hidden:true
				}, 
				{ field: 'DDCRSDate', title:'日期', width: 30, align: 'left', sortable: true, resizable: true  
				},
				{ field: 'LocDesc', title:'科室', width: 50, align: 'left', sortable: true, resizable: true  
				},
				{ field: 'ResourceDesc', title: '资源', width: 30, align: 'left', sortable: true, resizable: true
				},
				{ field: 'TimeDesc', title: '时段', width: 30, align: 'left', sortable: true, resizable: true
				},
				{ field: 'StartTime', title: '开始时间', width: 30, align: 'left', sortable: true,resizable: true
				},
				{ field: 'EndTime', title: '结束时间', width: 30, align: 'left', sortable: true,resizable: true
				},
				{ field: 'ServiceGroupDesc', title: '服务组', width: 30, align: 'left', sortable: true,resizable: true
				},
				{ field: 'DDCRSStatus', title: '状态', width: 20, align: 'left', sortable: true,resizable: true
				},
				{ field: 'AppedLeftNumber', title: '剩余可预约数', width: 30, align: 'left', sortable: true,resizable: true,
					formatter:function(value,row,index){
						value=parseFloat(value)
						var MaxNumber=parseFloat(row.MaxNumber)*0.5;
						if (value ==0){
							return "<span class='fillspan-nonenum'>"+value+"</span>";
						}else if((value >0)&&(value<MaxNumber)){
							return "<span class='fillspan-nofullnum'>"+value+"</span>";
						}else{
							return "<span class='fillspan-fullnum'>"+value+"</span>";
						}
					}
				},
				{ field: 'AppedNumber', title: '已预约数', width: 20, align: 'left', sortable: true,resizable: true
				},
				{ field: 'MaxNumber', title: '最大预约数', width: 30, align: 'left', sortable: true,resizable: true
				},
				{ field: 'EndAppointTime', title: '截止预约时间', width: 30, align: 'left', sortable: true,resizable: true
				}
			 ]],
			 toolbar : [{
				id:'BtnGenAppoint',
				text:'预约',
				iconCls:'icon-book',
				handler:function(){
					GenAppoint(DCARowID);
				}
			}],
			onBeforeLoad:function(param){
				var SearchExpStr="";
				var SearchLocID=$HUI.combobox('#Loc_Search').getValue();
				var SearchDocID=$HUI.combobox('#Doc_Search').getValue();
				var SearchTimeRangeID=$HUI.combobox('#TimeRange_Search').getValue();
				SearchExpStr=SearchLocID+"^"+SearchDocID+"^"+SearchTimeRangeID;
				var StartDate=$HUI.datebox('#SttDate_Search').getValue();
				var EndDate=$HUI.datebox('#EndDate_Search').getValue();
				$.extend(param,{DCARowId:DCARowID,StartDate:StartDate,EndDate:EndDate,SearchExpStr:SearchExpStr});
			},onClickRow: function(rowIndex, rowData){
				var RowObj=$(this).parent().find("div .datagrid-cell-check")
                .children("input[type=\"checkbox\"]");
			    RowObj.each(function(index, el){
			        if (el.style.display == "none") {
			            PageAppListAllObj.m_CureAppScheduleListDataGrid.datagrid('unselectRow', index);
			        }
			    })
			},onBeforeSelect:function(rowIndex, rowData){
				var rows = PageAppListAllObj.m_CureAppScheduleListDataGrid.datagrid("getSelections");
				var length=rows.length;
				if(length>=ApplyNoAppTimes){
					PageAppListAllObj.m_CureAppScheduleListDataGrid.datagrid('unselectRow', rowIndex);
					return false
				}
			},onBeforeCheck:function(rowIndex, rowData){
				var rows = PageAppListAllObj.m_CureAppScheduleListDataGrid.datagrid("getSelections");
				var length=rows.length;
				if(length>=ApplyNoAppTimes){
					PageAppListAllObj.m_CureAppScheduleListDataGrid.datagrid('unselectRow', rowIndex);
					return false
				}
			},onLoadSuccess:function(data){
				PageAppListAllObj.m_CureAppScheduleListDataGrid.datagrid("clearSelections").datagrid("clearChecked");
				var headchkobj=$(this).parent().find("div .datagrid-header-check")
                .children("input[type=\"checkbox\"]").eq(0);
            	headchkobj.attr("style", "display:none;");
            	
				var RowObj=$(this).parent().find("div .datagrid-cell-check")
                .children("input[type=\"checkbox\"]");
			    for (var i = 0; i < data.rows.length; i++) {
			        if (data.rows[i].AppedLeftNumber==0) {
			            RowObj.eq(i).attr("style", "display:none");
			        }
			    }
			}
		});
		PageAppListAllObj.m_CureAppScheduleListDataGrid=DataGrid;
		//CureAppScheduleListDataGridLoad();
	}else{
		$.messager.alert("提示","该治疗申请可预约数量不足.","warning");
		return false;	
	}
}

function GenAppoint(DCARowID){
	if(DCARowID==""){
		$.messager.alert("提示", "获取申请单信息错误.", "warning");	
		return false;
	}
	var rows = PageAppListAllObj.m_CureAppScheduleListDataGrid.datagrid("getSelections");
	var length=rows.length;
	if(length==0){
		$.messager.alert("提示", "请选择需要预约的资源.", "warning");	
		return false;
	}
	var ids = [];
	for (var i = 0; i < length; i++) {
		ids.push(rows[i].Rowid);
	}
	var ID=ids.join(String.fromCharCode(1));
	var Para=DCARowID+"^"+ID+"^"+"M"+"^"+session['LOGON.USERID']+"^"+session['LOGON.HOSPID'];
	var InsExpStr=session['LOGON.HOSPID']+"^"+session['LOGON.LANGID'];
	var ret=$.cm({
		ClassName:"DHCDoc.DHCDocCure.Appointment",
		MethodName:"AppInsertBroker",
		Para:Para,
		InsExpStr:InsExpStr,
		dataType:"text"
	},false);
	if(ret!=""){
		$.messager.alert("提示", ret, "warning");
	}else{
		$.messager.popover({msg: '预约成功！',type:'success',timeout: 3000});
		PageAppListAllObj.m_CureAppScheduleListDataGrid.datagrid("reload");
	}
}

function InitLocSearch(){
	InitDocSearch();
    $HUI.combobox("#Loc_Search", {
		valueField: 'LocId',
		textField: 'LocDesc', 
		editable:true,
		url :$URL+"?ClassName=DHCDoc.DHCDocCure.Config&QueryName=QueryCureLoc&HospID="+session['LOGON.HOSPID']+"&ResultSetType=array",
		filter: function(q, row){
			return (row["LocDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["LocContactName"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
		},onSelect:function(record){
			var locId=record.LocId;
			var url = $URL+"?ClassName=DHCDoc.DHCDocCure.Config&QueryName=QueryResource&LocID="+locId+"&ResultSetType=array";
			var obj=$HUI.combobox('#Doc_Search');
			obj.clear();
			obj.reload(url);
		},onLoadSuccess:function(data){
			SetLogLocID();
		}  
	 });
}

function SetLogLocID(){
	var m_LogLocID=session['LOGON.CTLOCID'];
	var data=$("#Loc_Search").combobox("getData");
	for(var i=0;i<data.length;i++){
    	if(data[i].LocId==m_LogLocID){
	    	$("#Loc_Search").combobox("select",m_LogLocID);
	    }
    }
    $("#Doc_Search").combobox("select","");
}

function InitDocSearch(){
	$HUI.combobox('#Doc_Search',{      
		valueField:'TRowid',   
		textField:'TResDesc',
		//url:$URL+"?ClassName=DHCDoc.DHCDocCure.Config&QueryName=QueryResource&LocID="+session['LOGON.CTLOCID']+"&ResultSetType=array",
		onSelect:function(record){
			//PageAppListAllObj.m_CureAppScheduleListDataGrid.datagrid("reload");
		},onChange:function(newValue, oldValue){
			//if((newValue=="")||(newValue=='undefined')){
			//	$(this).select("");
			//	PageAppListAllObj.m_CureAppScheduleListDataGrid.datagrid("reload");
			//}
		},onLoadSuccess:function(data){
			$(this).combobox("select","");
		}  
	});
}
function InitTimeRangeSearch(SGRowID){
	$HUI.combobox('#TimeRange_Search',{ 
		valueField:'Rowid',   
		textField:'Desc',
		url:$URL+"?ClassName=DHCDoc.DHCDocCure.RBCResPlan&QueryName=QueryBookTime&SGRowID="+SGRowID+"&HospID="+session['LOGON.HOSPID']+"&ExpStr="+session['LOGON.LANGID']+"&ResultSetType=array",
		onSelect:function(record){
		} 
	});
}
function InitAppScheduleListComb(){
	InitLocSearch();
	//InitTimeRangeSearch();
}

function CureAppScheduleListDataGridLoad(){
	PageAppListAllObj.m_CureAppScheduleListDataGrid.datagrid("reload");
}

function togglePanelExpand(){
	var wp = $("#CenterPanel").layout("panel", "west");
	var cp = $("#CenterPanel").layout("panel", "center");
	$(wp).panel({
		onExpand:function(){
			IFrameReSizeWidth("FormMain",-200)
		},
		onCollapse:function(){
			IFrameReSizeWidth("FormMain",200)
		}	
	})	
}
function toggleMoreInfo(ele){
	if ($(ele).hasClass('expanded')){  //已经展开 隐藏
		$(ele).removeClass('expanded');
		$("#moreBtn")[0].innerText=$g("更多");
    	$("tr.display-more-tr").slideUp("fast", setHeight(-40));
	}else{
		$(ele).addClass('expanded');
		$("#moreBtn")[0].innerText=$g("隐藏");
    	$("tr.display-more-tr").slideDown("'normal", setHeight(40));
	}
	

	function setHeight(num) {
		var l = $("#search-applist-layout");
		var n = l.layout("panel", "north");
		var nh = parseInt(n.outerHeight()) + parseInt(num);
		n.panel("resize", {
			height: nh
		});
		if (num > 0) {
			$("tr.display-more-tr").show();
		} else {
			$("tr.display-more-tr").hide();
		}
		var c = l.layout("panel", "center");
		var ch = parseInt(c.panel("panel").outerHeight()) - parseInt(num);
		c.panel("resize", {
			height: ch,
			top: nh
		});
	}
}
