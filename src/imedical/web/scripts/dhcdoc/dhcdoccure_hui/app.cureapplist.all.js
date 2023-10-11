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
	m_SameServiceGroup:["ԤԼ","����"],
	PatCondition:[{id:"PatNo",desc:$g("�ǼǺ�")},{id:"PatMedNo",desc:$g("סԺ��")},{id:"PatName",desc:$g("��������")}],
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
			//������Դ����Init
			appList_triageResListObj.InitTriageLoc();
			appList_triageResListObj.InitCureRBCResListDataGrid();
			//�����б����
			appList_triageListObj.InitCureTriageListDataGrid();		
		}
	}else{
		if(ServerObj.LayoutConfig!=""){
			appList_execObj.InitExecDate();
			appList_execObj.InitExecEvent();
			appList_execObj.InitCureExecDataGrid();
	
			if(ServerObj.DocCureUseBase=="0"){
				//ԤԼ��Դ����Init
				appList_appResListObj.InitScheduleTab("");
				//ԤԼ�б�Init
				appList_appListObj.InitCureApplyAppDataGrid();
			}
			
			if($("#Apply_Asslist").length>0){
				//�����б�Init
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
			$("#applist_panel").panel({title: $g('����ִ��-���뵥�б�')})
		}else{
			if(ServerObj.CureAppVersion!="V1"){
				$("#applist_panel").panel({title: $g('����ִ��-���뵥�б�')})
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
		var OthChkConditionAry=[{id:"FinishDis",desc:$g("����״̬-ȫ����Ч")},{id:"CancelDis",desc:$g("����״̬-�ѷ���")}]
	}else{
		//ԤԼδ��ɣ���ԤԼ��>0�����뵥
		var OthChkConditionAry=[{id:"FinishDis",desc:$g("����״̬-�����")},{id:"CancelDis",desc:$g("����״̬-�ѳ���")},{id:"ANF",desc:$g("ԤԼδ���"),title:"��ԤԼ������0�����뵥"}]
	}
	var myAry=[{id:"OPCheck",desc:$g("��������-�ż���")},{id:"IPCheck",desc:$g("��������-סԺ")},{id:"ChkCurrLoc",desc:$g("���ƾ��ﻼ��")}]
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
	@�����뵥ԤԼģʽ
	@	ҳǩչʾҵ������б����ģʽ����Ч
	@	���ú�����ԤԼ����ԤԼʱ����ԤԼ�ɹ������Դ��ڿ�ԤԼ����������ɵ�������ѡ���������ձ���ԤԼ����Դ��ʱ�Ρ����������ԤԼ�������뵥ֻ�ܵ�ѡһ����¼.
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
			text:'���뵥���', 
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
				text:'����', 
				iconCls:'icon-book',  
				handler:function(){
					Apply_Click("Apply_TriageReslist");
				}
			})
			cureApplyToolBar.push({
				id:'Apply_Triagelist',
				text:'�����б�', 
				iconCls:'icon-sample-stat',  
				handler:function(){
					Apply_Click("Apply_Triagelist");
				}
			})
		}
	}else{
		var cureApplyToolBar = [{
			id:'BtnCall',
			text:'�к�',
			iconCls:'icon-ring-blue',
			handler:function(){
				DHCDocCure_CureCall.CureCallHandle(CureApplyDataGrid,CureApplyDataGridLoad);
			}
		},{
			id:'BtnPass',
			text:'����',
			iconCls:'icon-skip-no',
			handler:function(){
				DHCDocCure_CureCall.SkipCallHandle(CureApplyDataGrid,CureApplyDataGridLoad);		 
			}
		},'-',{
			id:'BtnDetailView',
			text:'���뵥���', 
			iconCls:'icon-funnel-eye',  
			handler:function(){
				OpenApplyDetailDiag();
			}
		}/*,"-",{
			id:'BtnFinish',
			text:'������뵥', 
			iconCls:'icon-ok',  
			handler:function(){
				FinishApplyClick("F");
			}
		},{
			id:'BtnFinish',
			text:'����������뵥', 
			iconCls:'icon-cancel',  
			handler:function(){
				FinishApplyClick("CF");
			}
		},'-'*/,{
			id:'AddOrderBtn',
			text:'���ò�¼', 
			iconCls:'icon-write-order',  
			handler:function(){
				AddOrderClick();
			}
		}];
		
		if(ServerObj.LayoutConfig=="2"){
			cureApplyToolBar.push("-");
			cureApplyToolBar.push({
				id:'Apply_Execlist',
				text:'ֱ��ִ��', 
				iconCls:'icon-mutpaper-tri',  
				handler:function(){
					Apply_Click("Apply_Execlist");
				}
			})
			if(ServerObj.DocCureUseBase=="0" && ServerObj.CureAppVersion=="V1"){
				cureApplyToolBar.push({
					id:'Apply_Reslist',
					text:'ԤԼ', 
					iconCls:'icon-book',  
					handler:function(){
						Apply_Click("Apply_Reslist");
					}
				})
			}
			cureApplyToolBar.push({
				id:'Apply_Asslist',
				text:'��������', 
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
		{field:'ServiceGroup',title:'������',width:88,align:'left', resizable: true}, 
		{field:'PatOther',title:'����������Ϣ',width:200,align:'left'},
		{field:'OrdOtherInfo',title:'ҽ��������Ϣ',width:150,align:'left',
			formatter: function (value, rowData, rowIndex) {
				if(value==""){
					value = $g("ҽ����ϸ��Ϣ");
				}
				return "<a href='javascript:void(0)' title='"+$g("ҽ����ϸ��Ϣ")+"'  onclick='com_openwin.ordDetailInfoShow(\""+rowData.OrderId+"\")'>"+value+"</a>";
			}
		}, 
		{field:'OrdBilled',title:'�Ƿ�ɷ�',width:80,align:'left', resizable: true,
			formatter:function(value,row,index){
				if (value == $g("��")){
					return "<span class='fillspan-nobilled'>"+value+"</span>";
				}else{
					return "<span class='fillspan'>"+value+"</span>";
				}
			}
		},
		{field:'OrdQty',title:'����',width:60,align:'left', resizable: true}, 
		{field:'OrdBillUOM',title:'��λ',width:60,align:'left', resizable: true}, 
		{field:'OrdUnitPrice',title:'����',width:60,align:'left', resizable: true}, 
		{field:'OrdPrice',title:'�ܽ��',width:60,align:'left', resizable: true}, 
		{field:'ApplyNoAppTimes',title:'δԤԼ����',width:80,align:'left', resizable: true,hidden:hiddenColumn
			,formatter:function(value,row,index){
				var NumVal=Number(value);
				if ((NumVal == 0 ||typeof NumVal != 'number' || isNaN(NumVal))) {
					return "<span>"+value+"</span>";
				}else {
					return '<a href="javascript:void(0)" id= "'+row["DCARowId"]+'"'+' onclick=ShowAppSchedule('+row.DCARowId+','+row.ServiceGroupID+');>'+"<span class='fillspan-nosave'>"+value+"</span>"+"</a>"
				}
			}
		},
		{field:'ApplyAppedTimes',title:'��ԤԼ����',width:80,align:'left', resizable: true,hidden:hiddenColumn},
		{field:'ApplyFinishTimes',title:'����������',width:80,align:'left', resizable: true,hidden:((ServerObj.myTriage=="Y")||(ServerObj.DocCureUseBase=="1"))?true:false},
		{field:'ApplyNoFinishTimes',title:'δ��������',width:80,align:'left', resizable: true,hidden:((ServerObj.myTriage=="Y")||(ServerObj.DocCureUseBase=="1"))?true:false},
		{field:'CallStatus', title: '����״̬', width: 80, align: 'left',resizable: true,hidden:((ServerObj.myTriage=="Y")||(ServerObj.DocCureUseBase=="1"))?true:false}, 
		{field:'OrdReLoc',title:'���տ���',width:120,align:'left', resizable: true},   
		{field:'HistoryTriRes',title:'�ϴη���',width:100,align:'left', resizable: true,hidden:(ServerObj.myTriage=="Y")?false:true},
		{field:'ApplyStatus',title:'����״̬',width:80,align:'left', resizable: true},
		{field:'ApplyStatusCode',title:'ApplyStatusCode',width:80,align:'left', resizable: true,hidden:true},
		{field:'ApplyUser',title:'����ҽ��',width:100,align:'left', resizable: true},
		{field:'ApplyDateTime',title:'����ʱ��',width:120,align:'left', resizable: true},
		//{field:'ServiceGroup',title:'������',width:30,align:'left',hidden:(HiddenLoc.indexOf(session['LOGON.CTLOCID'])<0)?true:false}, //HiddenLoc.indexOf(session['LOGON.CTLOCID'])
		{field:'ServiceGroupID',title:'������id',width:80,align:'left',hidden:true},
		{field:'ApplyExecFlag',title:'',width:10,align:'left',hidden:true},
		{field:'OrdFreqCode',title:'ҽ��Ƶ��',width:50,align:'left',hidden:true},
		{field:'OrdStatusCode',title:'ҽ��״̬',width:50,align:'left',hidden:true},
		{field:'OrderId',title:'OrderId',width:50,align:'left',hidden:true},
		{field:'DCAAdmID',title:'DCAAdmID',width:50,align:'left',hidden:true},
		{field:'PatientID',title:'PatientID',width:50,align:'left',hidden:true},
		{field:'DCARowId',title:'DCARowId',width:30,hidden:true}  	
			   
	 ]]
	var mypageSize=10;
	if(ServerObj.LayoutConfig=="2"){
    	mypageSize=20;
    }
	// ���Ƽ�¼���뵥Grid
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
		loadMsg : '������..',  
		pagination : true,
		rownumbers : true,
		idField:"DCARowId",
		pageSize : mypageSize,
		pageList : [5,10,20,50],
		frozenColumns : [
			[
				{field:'RowCheck',checkbox:true},     
				{field:'ApplyNo',title:'���뵥��',width:110,align:'left', resizable: true},  
				{ field: 'ApplyExec', title: '�Ƿ��ԤԼ', width: 80, align: 'left',resizable: true,hidden:(ServerObj.myTriage=="Y")?true:false
					,formatter:function(value,row,index){
						if (row.ApplyExecFlag=="Y"){
							return "<span class='fillspan-exec'>"+value+"</span>";
						}else {
							return "<span class='fillspan-app'>"+value+"</span>";
						}
					}
				},
				{field:'PatNo',title:'�ǼǺ�',width:100,align:'left', resizable: true},   
				{field:'PatName',title:'����',width:60,align:'left', resizable: true},   
				{field:'ArcimDesc',title:'������Ŀ',width:200,align:'left', resizable: true,
					formatter: function (value, rowData, rowIndex) {
						var retStr=value;
						if(value!=""){
							retStr = "<a href='#' title='"+$g("ҽ��������Ϣ")+"'  onclick='com_openwin.applyAppenditemShow(\""+rowData.OrderId+"\")'>"+value+"</a>"
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
                //չʾ��������
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
		        if (row.CallStatus=="���ں���"){   
		            return 'background-color: #21ba45 !important;color:#fff !important;'; //#00DC00
		        }else if (row.CallStatus=="����"){   
		            return 'background-color: #d2eafe  !important;color:#000 !important;';
		        }   
			}else{
				return "";	
			}
	    },
	    onLoadSuccess: function () {   //���ر�ͷ��checkbox
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
	@���������ѡ��
	@ԤԼ������ʱ����ÿ��ѡ����ͬ�����顢���տ��ҵ����뵥
	@�����뵥ԤԼģʽ�£�ѡ��ԤԼҳǩ,������ԤԼģʽ�½�datagrid��ѡ���Ϊ��ѡģʽ
	@�����뵥ԤԼģʽ�£�������ҳǩ��ѡ�����뵥��¼���е�ԤԼҳǩʱ���Զ�ȡ����ѡ����һ����¼��������¼CheckSelectRow������ʵ��
	@Input:
		rowIndex ��ǰѡ��������
		rowData  ��ǰѡ���еļ�¼
		noMsgTip �Ƿ񵯴���ʾ true������ʾ
		tabTitle ѡ���ҳǩ,δ����ȡtabs getSelected��ҳǩ
*/
function CheckSelectedRow(rowIndex, rowData,noMsgTip,tabTitle){
	if(typeof(tabTitle)=="undefined"){tabTitle=""}
	if(tabTitle==""){
		var tabsObj=GetSelTabsObj();
		tabTitle=tabsObj.title;
	}
	
	var opts=CureApplyDataGrid.datagrid("options");
	if(tabTitle=="ԤԼ"){
		//ѡ��ԤԼҳǩ,������ԤԼģʽ�½�datagrid��ѡ���Ϊ��ѡģʽ
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
				$.messager.alert("��ʾ","��"+tabTitle+"ʱ������ͬ����������,һ��ѡ��ֻ��ѡ����ͬ������ͽ��տ��ҵ����뵥��������ѡ��",'warning')
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
					DataGridLoad("ԤԼ�б�");
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
	if(tabsobj.title=="ֱ��ִ��"){
		ExecFlag="Y";
		if(ServerObj.DHCDocCureAppointAllowExec==1){
			ExecFlag="";
		}
	}
	if((tabsobj.title=="��������")||(ServerObj.DHCDocCureAppQryNotWithTab==1)){
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
	var SortType="A"; //Ĭ��ʱ������
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
            {field:'ArcimDesc',title:'����',width:320,sortable:true},
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
		$.messager.alert("��ʾ","��ѡ��һ�����뵥","warning");
		return false;
	}
	var DCARowIdStr=""
	for(var i=0;i<rows.length;i++){
		var DCARowIds=rows[i].DCARowId;
		var OrdBilled=rows[i].OrdBilled;
		var ApplyStatusCode=rows[i].ApplyStatusCode;
		var rowIndex = CureApplyDataGrid.datagrid("getRowIndex", rows[i]);
		if((OrdBilled!=$g("��"))&&(ApplyStatusCode!="C")){
			if(DCARowIdStr==""){
				DCARowIdStr=DCARowIds;
			}else{
				DCARowIdStr=DCARowIdStr+"!"+DCARowIds;
			}
		}
	}	
	if(DCARowIdStr==""){
		$.messager.alert('��ʾ','δ�пɽ�����������������,��ȷ�������Ƿ��ѽɷѻ��Ƿ��ѳ���!',"warning");
		return false;	
	}
}

function GetSelectRow(){
	var rows = CureApplyDataGrid.datagrid("getSelections");
	if (rows.length==0) 
	{
		$.messager.alert("��ʾ","��ѡ��һ�����뵥!","warning");
		return "";
	}else if (rows.length>1){
     	$.messager.alert("����","��ѡ���˶�����뵥!","warning")
     	return "";
     }
	var DCARowId=rows[0].DCARowId;
	if(DCARowId=="")
	{
		$.messager.alert('��ʾ','��ѡ��һ�����뵥',"warning");
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
	e.preventDefault(); //��ֹ����������Ҽ��¼�
	$("#RightKeyMenu").empty(); //	������еĲ˵�
	CureApplyDataGrid.datagrid("clearSelections"); 
	CureApplyDataGrid.datagrid("checkRow", rowIndex);
	//if (rowData.OrdFreqCode!="PRN") return false;
	var RightMenu="{'id':'DOCCureOrder', 'text':'�������뵥','handler':'', 'displayHandler':'', 'iconCls':'',menu:{items:["
	RightMenu=RightMenu+"{'id':'R_DetailView', 'text':'���뵥���','handler':'OpenApplyDetailDiag', 'displayHandler':'', 'iconCls':''}"
	RightMenu=RightMenu+",{'id':'PRNOrderAddExecOrder', 'text':'����ִ�м�¼','handler':'addExecOrderHandler', 'displayHandler':'addExecOrderShowHandler', 'iconCls':''}"
	if(ServerObj.myTriage!="Y"){
		RightMenu=RightMenu+",{'id':'R_Finish', 'text':'������뵥','handler':'FinishHandler', 'displayHandler':'', 'iconCls':''}"
		RightMenu=RightMenu+",{'id':'R_CancelFinish', 'text':'����������뵥','handler':'CancelFinishHandler', 'displayHandler':'', 'iconCls':''}"
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
	    left: e.pageX,         //�����������ʾ�˵�
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
				$.messager.popover({msg: '�����뵥ԤԼģʽ�����Զ�ȡ����ѡ����һ����¼��������¼',type:'info',timeout: 3000})
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
	@Type��Ҫ��csp�ж����ҳǩdiv idһ��,������Ĺ��߰�ťid��Ҫ��ҳǩdiv idһ��
*/
function Apply_Click(Type){
	if(PageAppListAllObj._SELECT_DCAROWID==""){
		$.messager.alert("��ʾ","��ѡ�����뵥��¼.","info");
		return false;
	}
	var obj=$("#"+Type);
	if(obj.length=0){
		$.messager.alert("��ʾ","δ���ֶ���Ķ�Ӧ�Ľ���","info");
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
			if(tabTitle=="ԤԼ"){
				appList_appResListObj.InitDate();
			}
		}else{
			$("#tabs").tabs("select",tabTitle);
			if(PageAppListAllObj.m_selTabTitle==""){
				DataGridLoad(tabTitle);
			}
			if(tabTitle=="ԤԼ"){
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
			loadMsg : '������..',  
			pagination : true,
			rownumbers : true,
			idField:"Rowid",
			pageSize : 20,
			pageList : [20,50],
			columns :[[   
				{ field: 'RowCheck',checkbox:true},     
				{ field: 'Rowid', title: 'ID', width: 1, align: 'left', sortable: true,hidden:true
				}, 
				{ field: 'DDCRSDate', title:'����', width: 30, align: 'left', sortable: true, resizable: true  
				},
				{ field: 'LocDesc', title:'����', width: 50, align: 'left', sortable: true, resizable: true  
				},
				{ field: 'ResourceDesc', title: '��Դ', width: 30, align: 'left', sortable: true, resizable: true
				},
				{ field: 'TimeDesc', title: 'ʱ��', width: 30, align: 'left', sortable: true, resizable: true
				},
				{ field: 'StartTime', title: '��ʼʱ��', width: 30, align: 'left', sortable: true,resizable: true
				},
				{ field: 'EndTime', title: '����ʱ��', width: 30, align: 'left', sortable: true,resizable: true
				},
				{ field: 'ServiceGroupDesc', title: '������', width: 30, align: 'left', sortable: true,resizable: true
				},
				{ field: 'DDCRSStatus', title: '״̬', width: 20, align: 'left', sortable: true,resizable: true
				},
				{ field: 'AppedLeftNumber', title: 'ʣ���ԤԼ��', width: 30, align: 'left', sortable: true,resizable: true,
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
				{ field: 'AppedNumber', title: '��ԤԼ��', width: 20, align: 'left', sortable: true,resizable: true
				},
				{ field: 'MaxNumber', title: '���ԤԼ��', width: 30, align: 'left', sortable: true,resizable: true
				},
				{ field: 'EndAppointTime', title: '��ֹԤԼʱ��', width: 30, align: 'left', sortable: true,resizable: true
				}
			 ]],
			 toolbar : [{
				id:'BtnGenAppoint',
				text:'ԤԼ',
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
		$.messager.alert("��ʾ","�����������ԤԼ��������.","warning");
		return false;	
	}
}

function GenAppoint(DCARowID){
	if(DCARowID==""){
		$.messager.alert("��ʾ", "��ȡ���뵥��Ϣ����.", "warning");	
		return false;
	}
	var rows = PageAppListAllObj.m_CureAppScheduleListDataGrid.datagrid("getSelections");
	var length=rows.length;
	if(length==0){
		$.messager.alert("��ʾ", "��ѡ����ҪԤԼ����Դ.", "warning");	
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
		$.messager.alert("��ʾ", ret, "warning");
	}else{
		$.messager.popover({msg: 'ԤԼ�ɹ���',type:'success',timeout: 3000});
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
	if ($(ele).hasClass('expanded')){  //�Ѿ�չ�� ����
		$(ele).removeClass('expanded');
		$("#moreBtn")[0].innerText=$g("����");
    	$("tr.display-more-tr").slideUp("fast", setHeight(-40));
	}else{
		$(ele).addClass('expanded');
		$("#moreBtn")[0].innerText=$g("����");
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
