var CureWorkListDataGrid;
var PageWorkListAllObj={
	m_SelectArcimID:"",
	m_LogHospID:session['LOGON.HOSPID'],
	_WORK_SELECT_DCAROWID:""	
}
$(document).ready(function(){
	Init();
	InitEvent();
	PageHandle();		
	CureWorkListDataGridLoad();
	
});
function Init(){
	InitCardType();
	InitOrderLoc();
	InitArcimDesc();
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
	InitCureApplyAppDataGrid();
	//�����б�Init
	InitCureRecordDataGrid();
	//���������б�Init
	InitCureAssessmentDataGrid();
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
	$('#PatMedNo').bind('keydown', function(event){
		if(event.keyCode==13)
		{
			CureWorkListDataGridLoad();
		}
	});
	$HUI.checkbox("#OPCheck",{
		onChecked:function(e,val){
			setTimeout("CureWorkListDataGridLoad();",10)
		},
		onUnchecked:function(e,val){
			setTimeout("CureWorkListDataGridLoad();",10)
		}
	})
	$HUI.checkbox("#IPCheck",{
		onChecked:function(e,val){
			setTimeout("CureWorkListDataGridLoad();",10)
		},
		onUnchecked:function(e,val){
			setTimeout("CureWorkListDataGridLoad();",10)
		}
	})
	$HUI.combobox("#queryStatus",{
    	onSelect:function(rec){
	    	CureWorkListDataGridLoad();
	    }
	});
	//common.readcard.js
	var param="work";
	//InitPatNoEvent(param);
	//InitCardNoEvent(param);
	InitPatNoEvent(CureWorkListDataGridLoad);
	InitCardNoEvent(CureWorkListDataGridLoad);
};

function PageHandle(){
	
}

function ClearHandle(){
	InitCardType();
	$("#CardNo,#PatMedNo,#patNo,#PatientID,#ApplyNo,#CardTypeNew").val("");
	$("#sttDate,#endDate").datebox("setValue","");	
	$("#queryStatus,#serviceGroup").combobox("setValue","");
	$("#OPCheck,#IPCheck,#LongOrdPriority").checkbox('uncheck');
	PageWorkListAllObj.m_SelectArcimID="";    
	$("#ComboArcim").lookup('setText','');
	$("#ComboOrderLoc").combobox('select','');	
}

function InitCureWorkListDataGrid(){
	var cureWorkListToolBar = [/*{
			id:'BtnCall',
			text:'�к�',
			iconCls:'icon-add',
			handler:function(){
				FormMatterPatName();		 
			}
		},'-',*/];
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
		pageSize : 5,
		pageList : [5,15,50],
		columns :[[   
					{field:'RowCheck',checkbox:true},     
        			{ field: 'Rowid', title: 'ID', width: 1, align: 'left', sortable: true,hidden:true
					}, 
					{field:'CureApplyNo',title:'���뵥��',width:110,align:'left'},   
					{field:'PatNo',title:'�ǼǺ�',width:100,align:'left'},   
        			{field:'PatName',title:'����',width:80,align:'left',
						/*formatter:function(value,row){							
							return '<a href="###" onclick=FormMatterPatName();>'+row.PatName+"</a>"
						},
						styler:function(value,row){
							return "color:blue;"
						}*/
					},   
					{field:'PatOther',title:'����������Ϣ',width:200,align:'left', resizable: true},
					{field:'ArcimDesc',title:'������Ŀ',width:200,align:'left', resizable: true},
        			//{field:'PatSex',title:'�Ա�',width:40,align:'left'},
        			//{field:'PatAge',title:'����',width:40,align:'left'},
        			{field:'DCAAQty',title:'��������',width:70,align:'left', resizable: true},
					{ field: 'DDCRSDate', title:'ԤԼ��������', width: 100, align: 'left', sortable: true, resizable: true},
					{field:'DCASeqNo',title:'�Ŷ����',width:80,align:'left'},
        			{ field: 'ResourceDesc', title: '��Դ', width: 80, align: 'left', resizable: true
					},
					{ field: 'TimeDesc', title: 'ʱ��', width: 60, align: 'left', resizable: true
					},
					{ field: 'StartTime', title: '��ʼʱ��', width: 80, align: 'left',resizable: true
					},
					{ field: 'EndTime', title: '����ʱ��', width: 80, align: 'left',resizable: true
					},
					{ field: 'ServiceGroupDesc', title: '������', width: 60, align: 'left',resizable: true
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
					{ field: 'ServiceGroupID', title: '������', width: 60, align: 'left',hidden: true
					}
    			 ]] ,
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
	        if (row.CallStatus=="���ں���"){   
	            return 'background-color:green;';   
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
        },onSelect:function(index, row){
			var frm=dhcsys_getmenuform();
			if (frm){
				var DCARowId=row["Rowid"];
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
	//CureWorkListDataGridLoad();	
}

function CureWorkListDataGridLoad()
{
	var ServiceGroup=$("#serviceGroup").combobox('getValue');
	var PatientID=$("#PatientID").val();
	var sttDate=$('#sttDate').datebox('getValue');
	var endDate=$('#endDate').datebox('getValue');
	var queryStatus=$("#queryStatus").combobox('getValue');
	var ApplyNo=$("#ApplyNo").val();
	var PatMedNo=$("#PatMedNo").val();
	var CheckAdmType="";
	var OPCheckObj=$HUI.checkbox("#OPCheck").getValue()
	if (OPCheckObj){CheckAdmType="O"};
	var IPCheckObj=$HUI.checkbox("#IPCheck").getValue()
	if (IPCheckObj){CheckAdmType="I"};
	if ((OPCheckObj)&&(IPCheckObj)){CheckAdmType=""};
	var gtext=$HUI.lookup("#ComboArcim").getText();
	if (gtext=="")PageWorkListAllObj.m_SelectArcimID="";
	var queryArcim=PageWorkListAllObj.m_SelectArcimID;
	var queryOrderLoc=$("#ComboOrderLoc").combobox("getValue");
	queryOrderLoc=CheckComboxSelData("ComboOrderLoc",queryOrderLoc);
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
		Pagerows:CureWorkListDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		CureWorkListDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
		CureWorkListDataGrid.datagrid("clearSelections");
		CureWorkListDataGrid.datagrid("clearChecked");	
		PageWorkListAllObj._WORK_SELECT_DCAROWID="";
	});
	
}

function FormMatterPatName(val,row){
	//���³����֧�ֶ����кŽӿ�
	var rows = CureWorkListDataGrid.datagrid("getSelections");
	var DCAARowId="",DCARowId="",DCAOEOREDR=""
	if (rows.length>=1)
	{
		var succsss=true;
		for(var i=0;i<rows.length;i++){
			
			var rowIndex = CureWorkListDataGrid.datagrid("getRowIndex", rows[i]);
			var selected=CureWorkListDataGrid.datagrid('getRows'); 
			var DCAARowId=selected[rowIndex].Rowid;
			DCAOEOREDR=selected[rowIndex].OEOREDR;
			var PatName=selected[rowIndex].PatName;
			var treatID=selected[rowIndex].ServiceGroupID;
			
		    var ServiceGroupDesc=selected[rowIndex].ServiceGroupDesc;
		    var StartTime=selected[rowIndex].StartTime;
			//alert(DCAARowId)
			//return;
			/*
			��������ҽԺ  ������ �кŽӿ�
		   	web.DHCVISVoiceCall.InsertVoiceQueue(callinfo,user,computerIP,"A","LR","N",callinfo,callinfo,"",treatID)
		   	callinfo          �� ���� ����������
		   	user              userID
		   	computerIP        �����IP
		   	treatID           ��������ID   
			*/
			var callinfo="��"+PatName+"����������";
			var computerIP=GetComputerIp()
			var loguser=session['LOGON.USERID'];
			var logloc=session['LOGON.CTLOCID'];
			var ret="0"; 
			//alert(callinfo+";"+loguser+";"+computerIP+";"+callinfo+";"+logloc+";"+treatID);
			var zhContent=DCAARowId+";"+PatName+";"+ServiceGroupDesc+";"+StartTime;
			var ret=tkMakeServerCall("web.DHCVISVoiceCall","InsertVoiceQueue",callinfo,loguser,computerIP,"A","LR","N",zhContent,logloc,"",treatID)
			//alert("InsertVoiceQueue+"+ret)
			if(ret=="0"){
				var callret=tkMakeServerCall("DHCDoc.DHCDocCure.Appointment","UpdateTreatCallStatus",DCAARowId,"Y")
				if(callret!=0){
					succsss=false;
					$.messager.alert("����", "���º���״̬ʧ��", 'error')
			        return false;
				}else{
					//alert("���гɹ�")
					$.messager.alert("��ʾ", "���гɹ�")
				}
			}else{
				var errmsg="����ʧ��:"+ret
				$.messager.alert("����", errmsg, 'error');
				succsss=false;
			    return false;
			}
		}
		if(succsss==true){
			$.messager.alert("��ʾ", "���гɹ�")		
		}
	}else{
		$.messager.alert("����", "��ѡ��һλ�����ٺ���.", 'error')
		 return false;
	}
}

function GetComputerIp() 
{
   var ipAddr="";
   var locator = new ActiveXObject ("WbemScripting.SWbemLocator");  
   var service = locator.ConnectServer("."); //���ӱ���������
   var properties = service.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration");  //��ѯʹ��SQL��׼ 
   var e = new Enumerator (properties);
   var p = e.item ();

   for (;!e.atEnd();e.moveNext ())  
   {
  	var p = e.item ();  
 	//document.write("IP:" + p.IPAddress(0) + " ");//IP��ַΪ��������,�������뼰Ĭ��������ͬ
	ipAddr=p.IPAddress(0); 
	if(ipAddr) break;
	}

	return ipAddr;
}
function loadTabData()
{
	var rows = CureWorkListDataGrid.datagrid("getSelections");
	var DCARowId="",DCARowIdStr="",DCAOEOREDR="";
	
	for(var i=0;i<rows.length;i++){
		var DCAARowId=rows[i].Rowid;
		if (DCAARowId!="")
		{
			//DCARowId=DCAARowId.split("||")[0];
			DCARowId=DCAARowId
		}else{
			continue;	
		}
		if(DCARowIdStr==""){
			DCARowIdStr=DCARowId;
		}else{
			DCARowIdStr=DCARowIdStr+"!"+DCARowId;
		}
	}
	PageWorkListAllObj._WORK_SELECT_DCAROWID=DCARowIdStr;
	// ����ѡ��������±��������
	var title = $('.tabs-selected').text();
	var seltab = $('#tabs').tabs('getSelected');  // ��ȡѡ������
	setTimeout(function(){DataGridLoad(title);},100)
}
function refreshTab(cfg){  
    var refresh_tab = cfg.tabTitle?$('#tabs').tabs('getTab',cfg.tabTitle):$('#tabs').tabs('getSelected');  
    if(refresh_tab && refresh_tab.find('iframe').length > 0){  
	    var _refresh_ifram = refresh_tab.find('iframe')[0];  
	    var refresh_url = cfg.url?cfg.url:_refresh_ifram.src;   
	    _refresh_ifram.contentWindow.location.href=refresh_url;  
    }  
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