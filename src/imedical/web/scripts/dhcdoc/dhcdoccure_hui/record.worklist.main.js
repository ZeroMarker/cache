/**
 * @file ���ƴ���V2.0 record.worklist.main.js
 * @author nk
 * @version 2.0
 */
 var PageWorkListAllObj={
	m_CureQueListDataGrid:"",
	m_CurePatAppListDataGrid:"",
	m_DefKey:"",
	m_selTabTitle:"",
	_WORK_SELECT_QUEID:"",
	_WORK_SELECT_DCAROWID:"",
	m_SelectArcimID:"",
	m_LoadStopOrd:"",
	m_LoadTimer:null,
	m_LoadTabTimer:null,
	dw:$(window).width(),
	dh:$(window).height(),
	PatCondition:[{id:"PatNo",desc:$g("�ǼǺ�")},{id:"PatMedNo",desc:$g("סԺ��")},{id:"PatName",desc:$g("��������")}],
	cspName:"doccure.worklist.v2.hui.csp"
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

$(document).ready(function(){
	if (!CheckDocCureUseBase()){
		return;
	}
	Init();
	InitEvent();
	PageHandle();
});

function Init(){
	InitPageDom();
	PageWorkListAllObj.m_CureQueListDataGrid=InitCureQueListDataGrid();
	PageWorkListAllObj.m_CurePatAppListDataGrid=InitCurePatAppListDataGrid();
	//����ִ�м�¼�б�Init
	appList_execObj.InitExecDate();
	appList_execObj.InitCureExecDataGrid();
	if($("#Apply_Assessment").length>0){
		//���������б�Init
		workList_AssListObj.InitCureAssessmentDataGrid();
	}	
	
}
function InitEvent(){
	//���߶����б�����¼���ʼ��
	$("#BFindPatQue").click(CureQueListDataGridLoad);
	$("#BClearPatQue").click(ClearPatQueHandle);
	$('#PatConditionVal').bind('keydown', function(event){
		if(event.keyCode==13)
		{
			var PatCondition=$("#PatCondition").combobox("getValue");
			if(PatCondition=="PatNo"){
				PatNoHandle(CureQueListDataGridLoad,this.id);	
				if ($(this).val()==""){
					$("#PatientID").val("");
				}
			}else{
				CureQueListDataGridLoad();
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
    //common.readcard.js
	InitCardNoEvent(CureQueListDataGridLoad); 
	
	//���뵥�б��¼���ʼ��
	InitPatCureAppListEvent();
	//���ƴ���ҳǩ�¼���ʼ��
	appList_execObj.InitExecEvent();
}
//���뵥�б��¼���ʼ��
function InitPatCureAppListEvent(){
	$("#BFindPatCure").click(CurePatAppListDataGridLoad);
	$("#BClearPatCure").click(ClearPatCureHandle);
	$HUI.radio("[name='DateSortType']",{
        onChecked:function(e,value){
            setTimeout("CurePatAppListDataGridLoad();",10)
        }
    });
}
function PageHandle(){
	resizePanel();
}

function ClearPatQueHandle(){
	$('.patque-table input[class*="validatebox"]').val("");
	$('.patque-table input[type="checkbox"]').checkbox('uncheck');
	$('.patque-table input[class*="combobox"]').combobox('select','');
	$("#QueDate").datebox('setValue',ServerObj.CurrentDate);
	$("#QueKey").keywords("select",PageWorkListAllObj.m_DefKey)	
}
function ClearPatCureHandle(){
	PageWorkListAllObj.m_SelectArcimID=""; 
	$("#ComboArcim").lookup('setText','');	
	$('.search-applist-panel input[class*="validatebox"]').val("");
	$('.search-applist-panel input[type="checkbox"]').checkbox('uncheck');
	var comboObj=$('.search-applist-panel input[class*="combobox"]');
	comboObj.combobox('select','');	
	comboObj.combobox('clear');
	comboObj.combobox("panel").find('.icon').removeClass('icon-ok');
	$('.search-applist-panel input[class*="hisui-datebox"]').datebox('setValue','');
	var radioObj=$("input[name='DateSortType']");
	$.each(radioObj,function(i,o){
		if(o.value=="A"){
			$HUI.radio(this).setValue(true);
		}
	})
}

function InitPageDom(){
	//��������
	$("#QueDate").datebox('setValue',ServerObj.CurrentDate);
	
	//������Դ
	var LocID=session['LOGON.CTLOCID'];
	if($("#Resource").length>0){
		$HUI.combobox("#Resource",{
			valueField:'TRowid',   
	    	textField:'TResDesc',
	    	url:$URL+"?ClassName=DHCDoc.DHCDocCure.Config&QueryName=QueryResource&LocID="+LocID+"&ResultSetType=array",
	    	filter: function(q, row){
				return (row["TResDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},
			onSelect:function(){
				CureQueListDataGridLoad();
			}
		})
	}
	//��������
	$HUI.combobox("#PatCondition", {
		valueField: 'id',
		textField: 'desc', 
		editable:false,
		data: PageWorkListAllObj.PatCondition,
		onSelect:function(){
	    	$("#PatConditionVal").val("");
	    	$("#PatientID").val("");
	    }
	});	
	//���йؼ����б�
	var KeyWordsArr=[
		{text:$g('ȫ��'),id:""}
	]
	$.q({
		ClassName:"DHCDoc.DHCDocCure.CureCall",
		QueryName:"CurePerStatusDataNew",
		dataType:"json"
	},function(Data) {
		var NeedKeyAry=["Wait","Complete"];
		if(ServerObj.CureLocNeedReport=="1"){
			NeedKeyAry.push("Report");	
		}
		var DataLen=Data["rows"].length;
		for (var i=0;i<DataLen;i++){
			var RowId=Data["rows"][i].RowId;
			var Desc=Data["rows"][i].ShowName;
			var Code=Data["rows"][i].Code;
			if (!Desc) Desc=Data["rows"][i].Desc;
			if(NeedKeyAry.indexOf(Code)<0){
				continue	
			}
			var selected=false;
			if(Code=="Wait"){
				selected=true;
				PageWorkListAllObj.m_DefKey=RowId;
			}
			KeyWordsArr.push({
				text:Desc,
				id:RowId,
				selected:selected
			})
		}
		$("#QueKey").keywords({
		    singleSelect:true,
		    labelCls:'red',
		    items:KeyWordsArr,
		    onClick:function(o){
			   	var id=o.id;
			   	CureQueListDataGridLoad();
			}
		});	
		CureQueListDataGridLoad();
	})
	
	//���뵥�б�-ҽ����
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
	        var CureItemFlag="on"
			param = $.extend(param,{'Alias':desc,'CureItemFlag':CureItemFlag,'SubCategory':""});
	    },onSelect:function(ind,item){
            var Desc=item['desc'];
			var ID=item['ArcimRowID'];
			PageWorkListAllObj.m_SelectArcimID=ID;
			$HUI.lookup("#ComboArcim").hidePanel();
		},onHidePanel:function(){
            var gtext=$HUI.lookup("#ComboArcim").getText();
            if((gtext=="")){
	        	PageWorkListAllObj.m_SelectArcimID="";    
	        }
		}
    }); 
    
	var OthChkConditionAry=[{id:"FinishDis",desc:$g("����״̬-�����")},{id:"CancelDis",desc:$g("����״̬-�ѳ���")},{id:"OPCheck",desc:$g("��������-�ż���")},{id:"IPCheck",desc:$g("��������-סԺ")}]
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
            return rhtml;
		},
		onChange:function(newval,oldval){
			$(this).combobox("panel").find('.icon').removeClass('icon-ok');
			for (var i=0;i<newval.length;i++){
				$(this).combobox("panel").find('#i'+newval[i]).addClass('icon-ok');
			}
		}
	}); 
}

function InitCureQueListDataGrid(){
	var ToolBar = [
	{
		id:'BtnCall',
		text:'����', 
		iconCls:'icon-ring-blue',  
		handler:function(){
			DHCDocCure_CureCall.CureCallHandle(PageWorkListAllObj.m_CureQueListDataGrid,CureQueListDataGridLoad);
		}
	},
	{
		id:'BtnPass',
		text:'����',
		iconCls:'icon-skip-no',
		handler:function(){
			DHCDocCure_CureCall.SkipCallHandle(PageWorkListAllObj.m_CureQueListDataGrid,CureQueListDataGridLoad);		 
		}
	}];
	var CurePatListDataGrid=$('#CureQueListTab').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : true,
		loadMsg : '������..',  
		//url:$URL+"?ClassName=DHCDoc.DHCDocCure.Alloc&QueryName=FindCureAllocList&rows=9999",
		pagination : true, 
		rownumbers : true, 
		pageSize:20,
		pageList : [20,50,100],
		columns :[[     
			{ field: 'Rowid', title: 'ID', hidden:true}, 
			{ field: 'PatId', title: 'PatId', hidden:true}, 
			{ field: 'PatNo',title:'�ǼǺ�',width:100,align:'left'},   
			{ field: 'PatName',title:'����',width:70,align:'left',
				formatter:function(value,row,index){
					var CallStatusCode=row.CallStatusCode;
					if (CallStatusCode == "N"){
						return "<span class='fillspan-bg-skyblue'>"+value+"</span>";
					}else if (CallStatusCode == "Y"){
						return "<span class='fillspan-bg-lightgreen'>"+value+"</span>";
					}else{
						return value;	
					}
				}
			}, 
			{ field: 'PatOther',title:'����������Ϣ',width:180,align:'left'},
			{ field: 'QueNo',title:'���',width:50,align:'left'}, 
			{ field: 'TimeRangeDesc',title:'ʱ��',width:120,align:'left'}, 
			{ field: 'QueStatus',title:'�Ŷ�״̬',width:80,align:'left'}, 
			{ field: 'QueStatusCode',title:'�Ŷ�״̬', hidden: true}, 
			{ field: 'QueDate', title:'ԤԼ��������', width: 100, align: 'left'},
			{ field: 'QueRBASServiceGroupDR', title:'������ID', hidden: true},
			{ field: 'QueRBASServiceGroupDesc', title:'������', width: 100, align: 'left'},
			{ field: 'QueLocDesc', title:'���ƿ���', width: 150, align: 'left', resizable: true},
			{ field: 'ResourceDesc', title:'������Դ', width: 100, align: 'left', resizable: true},
			{ field: 'CallStatusCode', title:'CallStatusCode', hidden: true}
		 ]] ,
    	toolbar : ToolBar,
    	onBeforeSelect:function(index, row) {
	    	var ControlStatusAry=["Cancel","Report"]
	    	if(ControlStatusAry.indexOf(row.QueStatusCode)>-1){
		    	var alertInfo=row.QueStatus+"�ļ�¼,�޷�����"
		    	$.messager.popover({type:"alert",msg:alertInfo,timeout:3000});
		    	ClearPatAppListDataGrid();	
		    	return false;
		    }
    	},
    	onSelect: function(index, row) {
	    	PageWorkListAllObj._WORK_SELECT_QUEID=row.Rowid;
		    CurePatAppListDataGridLoad();
    	},
	    onLoadSuccess: function () {
		    if(ServerObj.DHCDocCureUseCall==0){
				$("#BtnCall,#BtnPass").linkbutton("disable");
			}
			/*PageWorkListAllObj.m_LoadTimer=setTimeout(function(){
				CureQueListDataGridLoad()
			},60000);*/
			CurePatAppListDataGridLoad();
        }
	});	
	
	return CurePatListDataGrid;
}
function CureQueListDataGridLoad(NotClearFlag){
	//clearTimeout(PageWorkListAllObj.m_LoadTimer);
	var queryPatID=$("#PatientID").val();
	var PatName="",PatMedNo=""; 
	var PatCondition=$("#PatCondition").combobox("getValue");
	var PatConditionVal=$("#PatConditionVal").val();
	if(PatCondition=="PatName"){
		PatName=PatConditionVal;
	}else if(PatCondition=="PatMedNo"){
		PatMedNo=PatConditionVal;
	}
	var Resource="";
	if($("#Resource").length>0){
		Resource=$("#Resource").combobox("getValue");
	}
	var QueDate=$("#QueDate").datebox("getValue");
	var KeyObj=$("#QueKey").keywords("getSelected");
	var SelPerStatus=KeyObj[0].id;
	var ReportFlag="";
	var QueryExpStr=ReportFlag+"^"+PatName+"^"+PatMedNo;
	var SessionStr=PageWorkListAllObj.cspName+"^"+com_Util.GetSessionStr();
			
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Alloc",
		QueryName:"FindCureAllocList",
		qPatientID:queryPatID, 
		qStatus:SelPerStatus, 
		qQueDate:QueDate, 
		qTimeRange:"", 
		qResource:Resource, 
		SessionStr:SessionStr, 
		qExpStr:QueryExpStr,
		Pagerows:PageWorkListAllObj.m_CureQueListDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(Data) {
		PageWorkListAllObj.m_CureQueListDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',Data); 
		if(NotClearFlag!="Y"){
			PageWorkListAllObj.m_CureQueListDataGrid.datagrid('unselectAll');
		}
	});
}

function InitCurePatAppListDataGrid(){
	var cureApplyToolBar = [{
		id:'BtnDetailView',
		text:'���뵥���', 
		iconCls:'icon-eye',  
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
			id:'Apply_Applist',
			text:'���ƴ���', 
			iconCls:'icon-mutpaper-tri',  
			handler:function(){
				Apply_Click("Apply_Applist");
			}
		})
		cureApplyToolBar.push({
			id:'Apply_Asslist',
			text:'��������', 
			iconCls:'icon-paper-table',  
			handler:function(){
				Apply_Click("Apply_Asslist");
			}
		})
	}
	var cureApplyColumn=[[ 
		{field:'ServiceGroup',title:'������',width:88,align:'left', resizable: true}, 
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
		{field:'OrdReLoc',title:'���տ���',width:120,align:'left', resizable: true},   
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
	var CurePatAppListDataGrid=$('#tabCurePatAppList').datagrid({  
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
		//url : $URL,
		loadMsg : '������..',  
		pagination : true,
		rownumbers : true,
		/*queryParams:{
		    ClassName:"DHCDoc.DHCDocCure.Apply",
			QueryName:"FindAllCureApplyListHUI"
	    },*/
		idField:"DCARowId",
		pageSize : mypageSize,
		pageList : [5,10,20,50],
		frozenColumns : [
			[
				{field:'RowCheck',checkbox:true},     
				{field:'ApplyNo',title:'���뵥��',width:110,align:'left', resizable: true},  
				{field:'ArcimDesc',title:'������Ŀ',width:180,align:'left', resizable: true,
					formatter: function (value, rowData, rowIndex) {
						var retStr=value;
						if(value!=""){
							retStr = "<a href='javascript:void(0)' title='"+$g("ҽ��������Ϣ")+"'  onclick='com_openwin.applyAppenditemShow(\""+rowData.OrderId+"\")'>"+value+"</a>"
						}
						return retStr;
					}
				},
				{field:'OrdOtherInfo',title:'ҽ��������Ϣ',width:150,align:'left',
					formatter: function (value, rowData, rowIndex) {
						if(value==""){
							value = $g("ҽ����ϸ��Ϣ");
						}
						return "<a href='javascript:void(0)' title='"+$g("ҽ����ϸ��Ϣ")+"'  onclick='com_openwin.ordDetailInfoShow(\""+rowData.OrderId+"\")'>"+value+"</a>";
					}
				}, 
				{field:'ApplyFinishTimes',title:'����������',width:80,align:'left', resizable: true},
				{field:'ApplyNoFinishTimes',title:'δ��������',width:80,align:'left', resizable: true}
			]
		],
		columns : cureApplyColumn,
    	toolbar : cureApplyToolBar,
		onClickRow:function(rowIndex, rowData){
			//alert("onClickRow")
			var RowObj=$(this).parent().find("div .datagrid-cell-check")
            .children("input[type=\"checkbox\"]");
		    RowObj.each(function(index, el){
		        if (el.style.display == "none") {
		            $('#tabCurePatAppList').datagrid('unselectRow', index);
		        }else{
			    	loadTabData();    
			    }
		    })
		},
		onRowContextMenu:function(e, rowIndex, rowData){
			ShowGridRightMenu(e,rowIndex, rowData,"Ord");
		},
		onCheck:function(rowIndex, rowData){
			//alert("onCheck")
			loadTabData();
		},onCheckAll:function(rows){
			var load=true;
			if(load){
				loadTabData();
			}else{
				$(this).datagrid("uncheckAll").datagrid("unselectAll");
			}
		},onUncheckAll:function(rows){
			loadTabData();
		},onUncheck:function(rowIndex, rowData){
			loadTabData();
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
        },onBeforeLoad:function(param){
			/*PageWorkListAllObj._WORK_SELECT_DCAROWID="";
			var querow=PageWorkListAllObj.m_CureQueListDataGrid.datagrid('getSelected');
			if(!querow){
				//$(this).datagrid("clearSelections").datagrid("clearChecked").datagrid('loadData',{total: 0, rows: []}); 
				return;
			}
			var PatientID=querow.PatId;
			if (PatientID=="") return;
			var StartDate=$('#sttDate').datebox('getValue');
			var EndDate=$('#endDate').datebox('getValue');
			var ApplyNo=$("#ApplyNo").val();
			var DisCancelFlag="",FinishDisFlag="",CheckAdmType="";
			if($("#ComboOtherChk").length>0){
				var OtherChkAry=$("#ComboOtherChk").combobox("getValues");
				if($.hisui.indexOfArray(OtherChkAry,"FinishDis")>-1){FinishDisFlag="Y"}
				if($.hisui.indexOfArray(OtherChkAry,"CancelDis")>-1){DisCancelFlag="Y"}
				if($.hisui.indexOfArray(OtherChkAry,"OPCheck")>-1){CheckAdmType="O"}
				if($.hisui.indexOfArray(OtherChkAry,"IPCheck")>-1){CheckAdmType="I"}
				if($.hisui.indexOfArray(OtherChkAry,"OPCheck")>-1 && $.hisui.indexOfArray(OtherChkAry,"IPCheck")>-1){CheckAdmType=""}
			}
			
			var queryArcim=PageWorkListAllObj.m_SelectArcimID;
			var SessionStr=PageWorkListAllObj.cspName+"^"+com_Util.GetSessionStr();
					
			var QueryExpStr=session['LOGON.HOSPID'];
			$.extend(param,{
				'PatientID':PatientID,
				'StartDate':StartDate,
				'EndDate':EndDate,
				'outCancel':DisCancelFlag,
				'FinishDis':FinishDisFlag,
				'PatName':"",
				'TriageFlag':"",
				'LogLocID':session['LOGON.CTLOCID'],
				'LogUserID':session['LOGON.USERID'],
				'ApplyNo':ApplyNo,
				'LongOrdPriority':"",
				'CheckAdmType':CheckAdmType,
				'queryArcim':queryArcim,
				'queryOrderLoc':"",
				'ExecFlag':"N",
				'queryExpStr':QueryExpStr
			});*/
		},onLoadSuccess: function(data){
			var RowObj=$(this).parent().find("div .datagrid-cell-check")
            .children("input[type=\"checkbox\"]");
		    for (var i = 0; i < data.rows.length; i++) {
			    var dataObj=data.rows[i];
		        if ((dataObj.OrdStatusCode=="D")) { //(dataObj.OrdBilled==$g("��")) || 
		            RowObj.eq(i).attr("style", "display:none");
		        }
		    }
		    //PageWorkListAllObj.m_CurePatAppListDataGrid.datagrid("clearSelections").datagrid("clearChecked");
		}
	});
	return CurePatAppListDataGrid;
}
function ClearPatAppListDataGrid(){
	PageWorkListAllObj._WORK_SELECT_DCAROWID="";
	PageWorkListAllObj.m_CurePatAppListDataGrid.datagrid("clearSelections").datagrid("clearChecked");
	PageWorkListAllObj.m_CurePatAppListDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',{total: 0, rows: []}); 	
}
function CurePatAppListDataGridLoad(NotClearFlag){
	//PageWorkListAllObj.m_CurePatAppListDataGrid.datagrid("reload");
	//return
	var querow=PageWorkListAllObj.m_CureQueListDataGrid.datagrid('getSelected');
	if(!querow){
		ClearPatAppListDataGrid();
		return;
	}
	var PatientID=querow.PatId;
	var ServiceGroup=querow.QueRBASServiceGroupDR;
	var StartDate=$('#sttDate').datebox('getValue');
	var EndDate=$('#endDate').datebox('getValue');
	var ApplyNo=$("#ApplyNo").val();
	var DisCancelFlag="",FinishDisFlag="",CheckAdmType="";
	if($("#ComboOtherChk").length>0){
		var OtherChkAry=$("#ComboOtherChk").combobox("getValues");
		if($.hisui.indexOfArray(OtherChkAry,"FinishDis")>-1){FinishDisFlag="Y"}
		if($.hisui.indexOfArray(OtherChkAry,"CancelDis")>-1){DisCancelFlag="Y"}
		if($.hisui.indexOfArray(OtherChkAry,"OPCheck")>-1){CheckAdmType="O"}
		if($.hisui.indexOfArray(OtherChkAry,"IPCheck")>-1){CheckAdmType="I"}
		if($.hisui.indexOfArray(OtherChkAry,"OPCheck")>-1 && $.hisui.indexOfArray(OtherChkAry,"IPCheck")>-1){CheckAdmType=""}
	}
	var gtext=$HUI.lookup("#ComboArcim").getText();
	if (gtext=="")PageWorkListAllObj.m_SelectArcimID="";
	var queryArcim=PageWorkListAllObj.m_SelectArcimID;
	var SortType="A"; //Ĭ��ʱ������
	var chkRadioJObj = $("input[name='DateSortType']:checked");
	if(chkRadioJObj.length>0){SortType=chkRadioJObj.val();}
	var SessionStr=PageWorkListAllObj.cspName+"^"+com_Util.GetSessionStr();
	var QueryExpAry = new Array();	
		QueryExpAry[0]=session['LOGON.HOSPID'];
		QueryExpAry[4]=SortType;
		QueryExpAry[7]=ServiceGroup;
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Apply",
		QueryName:"FindAllCureApplyListHUI",
		'PatientID':PatientID,
		'StartDate':StartDate,
		'EndDate':EndDate,
		'outCancel':DisCancelFlag,
		'FinishDis':FinishDisFlag,
		'PatName':"",
		'TriageFlag':"",
		'LogLocID':session['LOGON.CTLOCID'],
		'LogUserID':session['LOGON.USERID'],
		'ApplyNo':ApplyNo,
		'LongOrdPriority':"",
		'CheckAdmType':CheckAdmType,
		'queryArcim':queryArcim,
		'queryOrderLoc':"",
		'ExecFlag':"N",
		'queryExpStr':QueryExpAry.join("^"),
		Pagerows:PageWorkListAllObj.m_CurePatAppListDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		PageWorkListAllObj._WORK_SELECT_DCAROWID="";
		PageWorkListAllObj.m_CurePatAppListDataGrid.datagrid("clearSelections").datagrid("clearChecked");
		PageWorkListAllObj.m_CurePatAppListDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})
}

function RefreshDataGrid(NotClearFlag){
	if(PageWorkListAllObj.m_CurePatAppListDataGrid){
		CurePatAppListDataGridLoad(NotClearFlag);
		/*var selItems=PageWorkListAllObj.m_CurePatAppListDataGrid.datagrid('getSelections');
		$.each(selItems, function(index, selItem){
			var RowIndex = PageWorkListAllObj.m_CurePatAppListDataGrid.datagrid('getRowIndex', selItem);
			PageWorkListAllObj.m_CurePatAppListDataGrid.datagrid('refreshRow', RowIndex);
		})*/
	}
}

function loadTabData(){
	var rows = PageWorkListAllObj.m_CurePatAppListDataGrid.datagrid("getSelections");
	var idAry=[];
	var DCARowIdStr="";
	for(var i=0;i<rows.length;i++){
		idAry.push(rows[i].DCARowId);
	}
	DCARowIdStr=idAry.join("!");
	PageWorkListAllObj._WORK_SELECT_DCAROWID=DCARowIdStr;
	if(ServerObj.LayoutConfig=="1"){
		clearTimeout(PageWorkListAllObj.m_LoadTabTimer);
		var tabsObj=GetSelTabsObj();
		PageWorkListAllObj.m_LoadTabTimer=setTimeout(function(){
			DataGridLoad(tabsObj.title);
		},200);
		//setTimeout(function(){DataGridLoad(tabsObj.title);},100)
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

function FinishApplyClick(Type){
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

function GetSelectRow(){
	var rows = PageWorkListAllObj.m_CurePatAppListDataGrid.datagrid("getSelections");
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


function getConfigUrl(userId,groupId,ctlocId){
	return com_Util.getConfigUrl(userId,groupId,ctlocId);
}

function ShowGridRightMenu(e,rowIndex, rowData){
	if($("#RightKeyMenu").length==0){return}
	e.preventDefault(); //��ֹ����������Ҽ��¼�
	$("#RightKeyMenu").empty(); //	������еĲ˵�
	PageWorkListAllObj.m_CurePatAppListDataGrid.datagrid("clearSelections"); 
	PageWorkListAllObj.m_CurePatAppListDataGrid.datagrid("checkRow", rowIndex);
	var RightMenu="{'id':'DOCCureOrder', 'text':'�������뵥','handler':'', 'displayHandler':'', 'iconCls':'',menu:{items:["
	RightMenu=RightMenu+"{'id':'R_DetailView', 'text':'���뵥���','handler':'OpenApplyDetailDiag', 'displayHandler':'', 'iconCls':''}"
	RightMenu=RightMenu+",{'id':'R_PRNOrderAddExecOrder', 'text':'����ִ�м�¼','handler':'addExecOrderHandler', 'displayHandler':'addExecOrderShowHandler', 'iconCls':''}"
	RightMenu=RightMenu+",{'id':'R_Finish', 'text':'������뵥','handler':'FinishHandler', 'displayHandler':'', 'iconCls':''}"
	RightMenu=RightMenu+",{'id':'R_CancelFinish', 'text':'����������뵥','handler':'CancelFinishHandler', 'displayHandler':'', 'iconCls':''}"
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
	com_withApplyFun.AddOrderClick(PageWorkListAllObj.m_CurePatAppListDataGrid);
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
			var selRow = PageWorkListAllObj.m_CurePatAppListDataGrid.datagrid('getSelected');
			var selIndex = PageWorkListAllObj.m_CurePatAppListDataGrid.datagrid('getRowIndex', selRow);

			PageWorkListAllObj.m_CurePatAppListDataGrid.datagrid('updateRow',{
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

function GetSelOrdRowStr(){
		var SelOrdRowStr="";
		if(typeof(PageWorkListAllObj.m_CurePatAppListDataGrid)!="undefined"){
			var SelOrdRowArr=PageWorkListAllObj.m_CurePatAppListDataGrid.datagrid('getChecked');
		}else{
			var SelOrdRowArr=CureApplyDataGrid.datagrid('getChecked');
		}
		for (var i=0;i<SelOrdRowArr.length;i++){
		   if (SelOrdRowArr[i].OrderId==""){
			    continue;  
		   }
		   if (SelOrdRowStr=="") SelOrdRowStr=SelOrdRowArr[i].OrderId+String.fromCharCode(1)+"";
		   else SelOrdRowStr=SelOrdRowStr+"^"+SelOrdRowArr[i].OrderId+String.fromCharCode(1)+""
		}
		return SelOrdRowStr;
	}


function resizePanel(){
	if(ServerObj.LayoutConfig=="1"){
		var ListScale=60;
		if(ServerObj.UIConfigObj!=""){
			var data = eval('(' + ServerObj.UIConfigObj + ')');
			if ((!data['DocCure_AppListScale'])||(data['DocCure_AppListScale']=="")){
				ListScale=60;
			}else{
				ListScale=data['DocCure_AppListScale'];
			}
		}
		ListScale=parseFloat(ListScale/100);
			
		$('#center_main_layout').layout('panel', 'north').panel('resize',{
			height:PageWorkListAllObj.dh*ListScale
		})
		$('#center_main_layout').layout("resize");
	}
}
function Apply_Click(Type){
	var obj=$("#"+Type);
	if(obj.length=0){
		$.messager.alert("��ʾ","δ���ֶ���Ķ�Ӧ�Ľ���","info");
		return false;
	}else{
		var tabTitle=obj[0].innerText;
		tabTitle=$.trim(tabTitle);
		
		var dhwid=$(document.body).width()-100;
		var dhhei=$(document.body).height()-200;
		$('#apptabs-dialog').window('open').window('resize',{
			width:dhwid,
			height:dhhei,
			top:100,
			left:50
		});
		if(PageWorkListAllObj.m_selTabTitle==tabTitle){
			DataGridLoad(tabTitle);
		}else{
			$("#tabs").tabs("select",tabTitle);
			if(PageWorkListAllObj.m_selTabTitle==""){
				DataGridLoad(tabTitle);
			}
		}
		PageWorkListAllObj.m_selTabTitle=tabTitle;
	}
}

function Main_SetPatArrive() {
	var querow=PageWorkListAllObj.m_CureQueListDataGrid.datagrid('getSelected');
	if(!querow){return}
	var QueId=querow.Rowid;
	var QueStatusCode=querow.QueStatusCode;
	if (QueId!="" && QueStatusCode=="Wait") {
		$.messager.confirm('ȷ��',"�Ƿ񽫻�����Ϊ���״̬?",function(r){ 
			if(r){   
				$.cm({
					ClassName:"DHCDoc.DHCDocCure.Alloc",
					MethodName:"UpdateCureQue",
					QueId:QueId,
					StatusCode:"Complete",
					UserId:session['LOGON.USERID'],
					dataType:"text"
				},function(ret){
					if(ret==0){
						CureQueListDataGridLoad();	
					}else{
						$.messager.alert("��ʾ","״̬����ʧ��","warning");	
					}	
				})
			}
		})
	}
}

function OpenApplyDetailDiag(){
	var DCARowId=GetSelectRow();
	if(DCARowId==""){
		return;	
	}
	com_openwin.ShowApplyDetail(DCARowId,ServerObj.DHCDocCureLinkPage,CurePatAppListDataGridLoad);
}