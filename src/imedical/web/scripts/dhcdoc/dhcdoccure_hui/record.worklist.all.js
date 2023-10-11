var CureWorkListDataGrid;
var PageWorkListAllObj={
	m_SelectArcimID:"",
	m_LogHospID:session['LOGON.HOSPID'],
	_WORK_SELECT_DCAROWID:"",
	m_LoadStopOrd:"",
	m_LoadTabTimer:"",
	dw:$(window).width(),
	dh:$(window).height(),
	PatCondition:[{id:"PatNo",desc:$g("�ǼǺ�")},{id:"PatMedNo",desc:$g("סԺ��")},{id:"PatName",desc:$g("��������")}],
	cspName:"doccure.worklist.hui.csp"
}

function CheckDocCureUseBase(){
	if (ServerObj.DocCureUseBase=="1"){
		$(".window-mask.alldom").show();
		return false;
	}else if (ServerObj.CureAppVersion!="V1"){
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
	CureWorkListDataGridLoad();
	
});
function Init(){
	InitPatCondition();
	InitOrderLoc();
	InitOrderDoc();
	InitArcimDesc();
	$("#sttDate").datebox('setValue',ServerObj.CurrentDate);	
	$("#endDate").datebox('setValue',ServerObj.CurrentDate);	
	//�������б�
	$HUI.combobox("#serviceGroup",{
	    valueField:'Rowid',   
    	textField:'Desc',
    	url:$URL+"?ClassName=DHCDoc.DHCDocCure.RBCServiceGroupSet&QueryName=QueryServiceGroup&HospID="+PageWorkListAllObj.m_LogHospID+"&ResultSetType=array",
    	onSelect:function(){
	    	CureWorkListDataGridLoad();
	    }
	});
	
	InitCureWorkListDataGrid();
	
	//ԤԼ�б�Init
	workList_AppListObj.InitCureApplyAppDataGrid();
	if($("#Apply_Resultlist").length>0){
		//�����б�Init
		workList_RecordListObj.InitCureRecordDataGrid();
	}
	if($("#Apply_Assessment").length>0){
		//���������б�Init
		workList_AssListObj.InitCureAssessmentDataGrid();
	}
}
function InitEvent(){
	$('#btnFind').bind('click', function(){
		   CureWorkListDataGridLoad();
    });
    
    $('#btnClear').bind('click', function(){
		ClearHandle();
	});
	
	$('#ApplyNo').bind('keydown', function(event){
		if(event.keyCode==13)
		{
			CureWorkListDataGridLoad();
		}
	});
	$('#PatConditionVal').bind('keydown', function(event){
		if(event.keyCode==13)
		{
			var PatCondition=$("#PatCondition").combobox("getValue");
			if(PatCondition=="PatNo"){
				PatNoHandle(CureWorkListDataGridLoad,this.id);	
				if ($(this).val()==""){
					$("#PatientID").val("");
				}
			}else{
				CureWorkListDataGridLoad();
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
	$HUI.checkbox("#OPCheck,#IPCheck",{
		onCheckChange:function(e,value){
			setTimeout("CureWorkListDataGridLoad();",10)
		}
	})
	$HUI.checkbox("#IStatCheck,#AStatCheck",{
		onCheckChange:function(e,value){
			setTimeout("CureWorkListDataGridLoad();",10)
		}
	})
	
	if($('#apptabs-dialog').length>0){
		$('#apptabs-dialog').window({
			onClose:function(){
				RefreshDataGrid();	
			}	
		})	
	}
	//common.readcard.js
	//InitPatNoEvent(CureWorkListDataGridLoad);
	InitCardNoEvent(CureWorkListDataGridLoad);
};

function PageHandle(){
	resizePanel();
}

function InitPatCondition(){
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
}

function ClearHandle(){
	//InitCardType();
	$("#cardNo,#CardNo,#PatientID,#ApplyNo,#CardTypeNew,#PatConditionVal").val("");
	$("#sttDate,#endDate").datebox("setValue","");	
	$("#queryStatus,#serviceGroup,#PatCondition").combobox("setValue","");
	$("#OPCheck,#IPCheck,#IStatCheck,#AStatCheck").checkbox('uncheck');
	PageWorkListAllObj.m_SelectArcimID="";    
	$("#ComboArcim").lookup('setText','');
	$("#ComboOrderLoc").combobox('select','');	
}

function InitCureWorkListDataGrid(){
	var cureWorkListToolBar = [{
			id:'BtnCall',
			text:'�к�',
			iconCls:'icon-big-ring',
			handler:function(){
				DHCDocCure_CureCall.CureCallHandle(CureWorkListDataGrid,CureWorkListDataGridLoad);		 
			}
		},{
			id:'BtnPass',
			text:'����',
			iconCls:'icon-skip-no',
			handler:function(){
				DHCDocCure_CureCall.SkipCallHandle(CureWorkListDataGrid,CureWorkListDataGridLoad);		 
			}
		},"-",{
		id:'BtnDetailView',
			text:'���뵥���', 
			iconCls:'icon-funnel-eye',  
			handler:function(){
				OpenApplyDetailDiag();
			}
		},"-"];
	if(ServerObj.LayoutConfig=="2"){
		cureWorkListToolBar.push({
			id:'Apply_Applist',
			text:'���ƴ���', 
			iconCls:'icon-mutpaper-tri',  
			handler:function(){
				Apply_Click("Apply_Applist");
			}
		})
		
		cureWorkListToolBar.push({
			id:'Apply_Assessment',
			text:'��������', 
			iconCls:'icon-paper-table',  
			handler:function(){
				Apply_Click("Apply_Assessment");
			}
		})
	}
	var mypageSize=10;
	if(ServerObj.LayoutConfig=="2"){
    	mypageSize=20;
    }
	// ���ƹ���̨��ѯGrid
	CureWorkListDataGrid=$('#tabCureWorkList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		//singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		loadMsg : '������..',  
		pagination : true,
		rownumbers : true,
		idField:"Rowid",
		pageSize : mypageSize,
		pageList : [5,10,20,50],
		frozenColumns : [
			[
				{field:'RowCheck',checkbox:true},     
    			{field:'Rowid', title: 'ID', width: 1, align: 'left',hidden:true}, 
				{field:'CureApplyNo',title:'���뵥��',width:120,align:'left'},   
				{field:'PatNo',title:'�ǼǺ�',width:100,align:'left'},   
    			{field:'PatName',title:'����',width:80,align:'left'},   
				{field:'PatOther',title:'����������Ϣ',width:200,align:'left', resizable: true},
				{field:'ArcimDesc',title:'������Ŀ',width:200,align:'left', resizable: true,
					formatter: function (value, rowData, rowIndex) {
						var retStr="<span>"+rowData.ArcimDesc+"</span>";
						if(rowData.ArcimDesc!=""){
							retStr = "<a href='#' title='ҽ���б�'  onclick='InitBillInfoList(\""+rowData.AdmRowID+"\")'>"+retStr+"</a>"
						}
						return retStr;
					}
				},
    			{field:'DCAAQty',title:'��������',width:70,align:'left', resizable: true},
				{field: 'DDCRSDate', title:'ԤԼ��������', width: 100, align: 'left', resizable: true},
				{field:'DCASeqNo',title:'�Ŷ����',width:80,align:'left'},
			]
		],
		columns :[[   
				{field: 'LocDesc', title:'����', width: 150, align: 'left', resizable: true
				},
				{field: 'ResourceDesc', title: '��Դ', width: 80, align: 'left', resizable: true
				},
				{field: 'TimeDesc', title: 'ʱ��', width: 60, align: 'left', resizable: true
				},
				{field: 'StartTime', title: '��ʼʱ��', width: 80, align: 'left',resizable: true
				},
				{ field: 'EndTime', title: '����ʱ��', width: 80, align: 'left',resizable: true
				},
				{ field: 'ServiceGroupDesc', title: '������', width: 80, align: 'left',resizable: true
				},
				{ field: 'DDCRSStatus', title: '�Ű�״̬', width: 80, align: 'left',resizable: true
				},
				{ field: 'DCAAStatus', title: 'ԤԼ״̬', width: 80, align: 'left',resizable: true
				},
				{ field: 'CallStatus', title: '����״̬', width: 80, align: 'left',resizable: true
				},
				{ field: 'ReqUser', title: 'ԤԼ������', width: 80, align: 'left',resizable: true
				},
				{ field: 'ReqDate', title: 'ԤԼ����ʱ��', width: 120, align: 'left',resizable: true
				},
				{ field: 'LastUpdateUser', title: '������', width: 80, align: 'left',resizable: true,hidden: true
				},
				{ field: 'LastUpdateDate', title: '����ʱ��', width: 80, align: 'left',resizable: true,hidden: true
				},
				{ field: 'OEOREDR', title: 'ִ�м�¼ID', width: 60, align: 'left',hidden: true
				},
				{ field: 'AdmRowID', title: 'AdmRowID', width: 60, align: 'left',hidden: true
				},
				{ field: 'PatientID', title: 'PatientID', width: 60, align: 'left',hidden: true
				},
				{ field: 'ServiceGroupID', title: '������', width: 60, align: 'left',hidden: true
				}
			 ]
		],
    	toolbar : cureWorkListToolBar,
		onClickRow:function(rowIndex, rowData){
			loadTabData()
		},
		onCheck:function(rowIndex, rowData){
			loadTabData();
		},
		onUncheck:function(rowIndex, rowData){
			//var ret=CheckSelectedRow(rowIndex, rowData);
			loadTabData();
		},
		rowStyler:function(index,row){   
	        if (row.CallStatusCode=="Call"){   
	            return 'background-color: #21ba45 !important;color:#fff !important;';
	        }else if (row.CallStatusCode=="Pass"){   
	            return 'background-color: #d2eafe  !important;color:#000 !important;';
	        }   
	    },
	    onLoadSuccess: function () {   //���ر�ͷ��checkbox
                //$(this).parent().find("div .datagrid-header-check")
                //.children("input[type=\"checkbox\"]").eq(0)
                //.attr("style", "display:none;");
                $(this).parent().find("div .datagrid-header-check")
                .children("input[type=\"checkbox\"]").eq(0)
                .bind('click', function(){
					loadTabData();
			    });
		    if(ServerObj.DHCDocCureUseCall==0){
				$("#BtnCall,#BtnPass").linkbutton("disable");
			}
        },onSelect:function(index, row){
			var frm=dhcsys_getmenuform();
			if (frm){
				var DCARowId=row["Rowid"];
				var AdmRowID=row["AdmRowID"];
				var PatientID=row["PatientID"];
				frm.PatientID.value=PatientID;
				frm.EpisodeID.value=AdmRowID;
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
	//CureWorkListDataGridLoad();	
}

function CureWorkListDataGridLoad(NotClearFlag)
{
	var ServiceGroup=$("#serviceGroup").combobox('getValue');
	var PatientID=$("#PatientID").val();
	var sttDate=$('#sttDate').datebox('getValue');
	var endDate=$('#endDate').datebox('getValue');
	var ApplyNo=$("#ApplyNo").val();
	
	var CheckAdmType="";
	var OPCheckObj=$HUI.checkbox("#OPCheck").getValue()
	if (OPCheckObj){CheckAdmType="O"};
	var IPCheckObj=$HUI.checkbox("#IPCheck").getValue()
	if (IPCheckObj){CheckAdmType="I"};
	if ((OPCheckObj)&&(IPCheckObj)){CheckAdmType=""};
	var queryStatus="";
	var IStatObj=$HUI.checkbox("#IStatCheck").getValue()
	if (IStatObj){queryStatus="I"};
	var AStatObj=$HUI.checkbox("#AStatCheck").getValue()
	if (AStatObj){queryStatus="A"};
	if ((IStatObj)&&(AStatObj)){queryStatus=""};
	
	var gtext=$HUI.lookup("#ComboArcim").getText();
	if (gtext=="")PageWorkListAllObj.m_SelectArcimID="";
	var queryArcim=PageWorkListAllObj.m_SelectArcimID;
	var queryOrderLoc=$("#ComboOrderLoc").combobox("getValue");
	queryOrderLoc=com_Util.CheckComboxSelData("ComboOrderLoc",queryOrderLoc);
	var queryOrderDoc=$("#ComboOrderDoc").combobox("getValue");
	queryOrderDoc=com_Util.CheckComboxSelData("ComboOrderDoc",queryOrderDoc);
	var PatName="",PatMedNo=""; //$("#PatMedNo").val();
	var PatCondition=$("#PatCondition").combobox("getValue");
	var PatConditionVal=$("#PatConditionVal").val();
	if(PatCondition=="PatName"){
		PatName=PatConditionVal;
	}else if(PatCondition=="PatMedNo"){
		PatMedNo=PatConditionVal;
	}
	var ExpStr=PatName+"^"+session['LOGON.USERID']+"^"+session['LOGON.HOSPID']+"^"+session['LOGON.LANGID']+"^"+PageWorkListAllObj.cspName;
		ExpStr=ExpStr+"^"+queryOrderDoc
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Appointment",
		QueryName:"FindCurrentAppointmentListHUI",
		'LocId':session['LOGON.CTLOCID'],
		'UserId':session['LOGON.USERID'],
		'StartDate':sttDate,
		'EndDate':endDate,
		'QPatientID':PatientID,
		'ServiceGroupId':ServiceGroup,
		'QueryStatus':queryStatus,
		'QApplyNo':ApplyNo,
		'QPatMedNo':PatMedNo,
		'CheckAdmType':CheckAdmType,
		'queryArcim':queryArcim,
		'queryOrderLoc':queryOrderLoc,
		ExpStr:ExpStr,
		Pagerows:CureWorkListDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		CureWorkListDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
		if(NotClearFlag!="Y"){
			CureWorkListDataGrid.datagrid("clearSelections");
			CureWorkListDataGrid.datagrid("clearChecked");	
			PageWorkListAllObj._WORK_SELECT_DCAROWID="";
		}
	});
	
}

function loadTabData() {
	var rows = CureWorkListDataGrid.datagrid("getSelections");
	var idAry=[],DCARowIdStr="";
	for(var i=0;i<rows.length;i++){
		var DCAARowId=rows[i].Rowid;
		if (DCAARowId=="") {
			continue;	
		}
		idAry.push(DCAARowId);
	}
	DCARowIdStr=idAry.join("!");
	PageWorkListAllObj._WORK_SELECT_DCAROWID=DCARowIdStr;
	var seltab = $('#tabs').tabs('getSelected');
	var title = seltab.panel('options').title;
	
	clearTimeout(PageWorkListAllObj.m_LoadTabTimer);
	PageWorkListAllObj.m_LoadTabTimer=setTimeout(function(){
		DataGridLoad(title);
	},200)
}

function RefreshDataGrid(){
	if(CureWorkListDataGrid){
		CureWorkListDataGridLoad();

		CureWorkListDataGrid.datagrid("clearSelections");
		CureWorkListDataGrid.datagrid("clearChecked");	
	}
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
        rownumbers:true,//���   
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
			PageWorkListAllObj.m_SelectArcimID=ID;
			$HUI.lookup("#ComboArcim").hidePanel();
		},onHidePanel:function(){
            var gtext=$HUI.lookup("#ComboArcim").getText();
            if((gtext=="")){
	        	PageWorkListAllObj.m_SelectArcimID="";    
	        }
		}
    });  
};
function InitOrderLoc(){
	var obj=com_withLocDocFun.InitComboDoc("ComboOrderDoc");
	com_withLocDocFun.InitComboLoc("ComboOrderLoc",obj);
}
function InitOrderDoc(LocID){
}

function InitBillInfoList(EpisodeID){
	PageWorkListAllObj.m_LoadStopOrd="";
	var dhwid=$(document.body).width()-100;
	var dhhei=$(document.body).height()-200;
	$('#admorderlist-dialog').window('open').window('resize',{width:dhwid,height:dhhei,top: 50,left:45});
    var BillInfoColumns=[[
        {field: 'ReportLinkInfo',hidden:true}
        ,{field: 'OrderSum', title: unescape('�ܼ�'), width: 80, align: 'left'}
        ,{field: 'Price', title: '����', width: 80, align: 'left'}
        ,{field: 'Desc', title: 'ҽ������', width: 250, align: 'left',
            formatter:function(value,row,index){
                if (row.ReportLinkInfo ==""){
                    return value;
                }
                var btn = '<a style="color: #ff7f24;text-decoration: underline;" onclick="OpenReportLink(\''+row.ReportLinkInfo +'\')">'+value+'\</a>';
                return btn;
        }}
        ,{field: 'PackQty', title: '����', width: 80, align: 'left'}
        ,{field: 'ReLoc', title: '���տ���', width: 150, align: 'left'}
        ,{field: 'Doctor', title: 'ҽʦ', width: 100, align: 'left'}
        ,{field: 'OrdStatus', title: 'ҽ��״̬', width: 100, align: 'left'}
        ,{field: 'OrdStartDate', title: '��ʼʱ��', width: 150, align: 'left'}
        ,{field: 'OrdBilled', title: '�Ʒ�״̬', width: 100, align: 'left'}
        ,{field: 'OrdXDate', title: 'ֹͣ����', width: 100, align: 'left',sortable: true}
        ,{field: 'OrdXTime', title: 'ֹͣʱ��', width: 100, align: 'left',sortable: true}
        ,{field: 'StopDoc', title: 'ͣҽ����', width: 100, align: 'left',sortable: true}
        ,{field: 'OEItemID', title: 'ҽ������', width: 100, align: 'left',sortable: true}
        //,{field: 'BtnPrtOrder', title: '��ӡҽ����ǩ', width: 60, align: 'left',sortable: true}
        //,{field: 'BtnLinkLabPage', title: '���뵥', width: 60, align: 'left',sortable: true}
    ]];
    
    
    var BillInfoToolBar = [{
            text: 'ˢ��',
            iconCls: 'icon-reload',
            handler: function() {
                PageWorkListAllObj.m_LoadStopOrd="";
                $('#tabBillInfoList').datagrid('reload');
            }
        },{
            text: '��ֹͣҽ��',
            iconCls: 'icon-cancel',
            handler: function() {
                PageWorkListAllObj.m_LoadStopOrd="Stop";
                $('#tabBillInfoList').datagrid('reload');
            }
        }]
    
    var BillInfoDataGrid=$('#tabBillInfoList').datagrid({
        fit : true,
        width : 'auto',
        border : false,
        striped : true,
        singleSelect : true,
        fitColumns : false,
        autoRowHeight : true,
        url : $URL,
        loadMsg : '������..',  
        pagination : true,
        pageSize:25,
		pageList : [25,50], 
        rownumbers : true,
        idField:"OEItemID",
        columns :BillInfoColumns,
        toolbar :BillInfoToolBar,
        onClickRow:function(rowIndex, rowData){
            BillInfoDataSelectedRow=rowIndex;
        },
        rowStyler: function(index,row){
            if (row.OrdStatus=="ֹͣ"){
                return 'background-color:#BDBEC2;color:#000000;';
            }else if (row.OEItemID!=""){
                return '';
            }else{
                return 'background-color:#C8FEC0;color:#000000;';
            }
        },
        queryParams:{
	    	ClassName:"web.DHCDocOPOrdInfo",
	    	QueryName:"GetOrdByAdm" 
	    },
        onBeforeLoad:function(param){
            $.extend(param,{EpisodeID:EpisodeID,OrdComStatus:PageWorkListAllObj.m_LoadStopOrd})
        }
        ,onLoadSuccess:function(data){ 
            if (PageWorkListAllObj.m_LoadStopOrd==""){
                BillInfoDataGrid.datagrid('hideColumn', 'OrdXDate');
                BillInfoDataGrid.datagrid('hideColumn', 'OrdXTime');
            }else{
                BillInfoDataGrid.datagrid('showColumn', 'OrdXDate');
                BillInfoDataGrid.datagrid('showColumn', 'OrdXTime');
            }
        }
    });
    //LoadBillInfoList();
}

function getConfigUrl(userId,groupId,ctlocId){
	return com_Util.getConfigUrl(userId,groupId,ctlocId);
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
			
		$('#main_layout').layout('panel', 'north').panel('resize',{
			height:PageWorkListAllObj.dh*ListScale
		})
		$('#main_layout').layout("resize");
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
		$("#tabs").tabs("select",tabTitle)	
	}
}

function OpenApplyDetailDiag()
{
	var DCARowId=GetSelectRow();
	if(DCARowId==""){
		return;	
	}
	
	com_openwin.ShowApplyDetail(DCARowId,ServerObj.DHCDocCureLinkPage,"");
}
function GetSelectRow(){
	var rows = CureWorkListDataGrid.datagrid("getSelections");
	if (rows.length==0) 
	{
		$.messager.alert("��ʾ","��ѡ��һ��ԤԼ��¼������뵥��Ϣ!","warning");
		return "";
	}else if (rows.length>1){
     	$.messager.alert("����","��ѡ���˶���ԤԼ��¼!","warning")
     	return "";
     }
	var DCAARowId=rows[0].Rowid;
	if(DCAARowId=="")
	{
		$.messager.alert('��ʾ','��ѡ��һ��ԤԼ��¼������뵥��Ϣ!',"warning");
		return "";
	}	
	var DCARowId=DCAARowId.split("||")[0];
	return DCARowId;
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