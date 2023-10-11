PageLogicObj={
	CureReportListDataGrid:""	
}
$(function(){
	Init();
	InitEvent();
	PageHandle();
});

function Init()
{
	var HospIdTdWidth=$("#HospIdTd").width()
	var opt={width:HospIdTdWidth}
	var hospComp = GenUserHospComp(opt);
	hospComp.jdata.options.onSelect = function(e,t){
		var HospID=t.HOSPRowId;
		PageHandle();
		LoadCureReportListDataGrid();
	}
	PageLogicObj.CureReportListDataGrid=InitCureReportListDataGrid()
	InitCureStatus();
	InitDate(ServerObj.CurrentDate);	
}

function InitEvent()
{
	$('#btnFind').bind('click',LoadCureReportListDataGrid);
	$('#btnClear').bind('click',clear_click);
	//common.readcard.js 
	InitPatNoEvent(LoadCureReportListDataGrid);
}

function PageHandle(){
	InitWard();
	InitLoc();
	InitResGroup();
	InitArcimDesc();
	clear_click();
}

function InitCureReportListDataGrid(){
	var DataGridObj={ 
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		singleSelect:true,    
		url : '',
		loadMsg : '������...',  
		pagination : true, 
		rownumbers : true,
		pageSize : 20,
		pageList : [20,50,100]
	}
	if(ServerObj.CureAppVersion=="V1"){
		$.extend(DataGridObj,{  
			idField:"DCAARowId",
			url : $URL+"?ClassName=DHCDoc.DHCDocCure.WordReport&QueryName=QueryWardCureAppointV1&rows=9999",
			columns:[[
				{field:'DCAARowId',title:'DCAARowId',width:100,align:'left', hidden: true},   
				{field:'PatientNo',title:'���ߵǼǺ�',width:100,align:'left'},   
				{field:'PatientName',title:'��������',width:80,align:'left'},  
				{field:'PatOther',title:'����������Ϣ',width:180,align:'left'},
				{field:'PAAdmWard',title:'���ڲ���',width:120,align:'left'},
				{field:'CureApplyNo',title:'�������뵥��',width:120,align:'left'},
				{field:'ArcimDesc',title:'������Ŀ',width:150,align:'left'},
				{field:'OrderReLoc',title:'���տ���',width:120,align:'left'},
				{field:'ApplyStatus',title:'���뵥״̬',width:80,align:'left'},
				{field:'ApplyDate',title:'��������',width:150,align:'left'},
				{field:'ApplyUser',title:'������',width:100,align:'left'},
				{field:'DDCRSDate', title:'ԤԼ��������', width: 120, align: 'left', sortable: true, resizable: true},
				{field:'DDCRSLoc', title:'���ƿ���', width: 120, align: 'left', sortable: true, resizable: true},
				{field:'CTCareProv', title: '����ҽʦ', width: 100, align: 'left', resizable: true},
				{field:'TimeRangeDesc', title: 'ԤԼʱ��', width: 80, align: 'left', resizable: true},
				{field:'DCASeqNo',title:'�����Ŷ����',width:100,align:'left'},
				{field:'DCAAQty',title:'��������',width:80,align:'left'},
				{field:'DCAAStatus', title: 'ԤԼ����״̬', width: 100, align: 'left',resizable: true},
				{field:'ServiceGroupDesc', title: '������', width: 80, align: 'left',resizable: true},
				{field:'DDCRSStatus', title: 'ԤԼ�Ű�״̬', width: 100, align: 'left',resizable: true},
				{field:'ReqUser', title: 'ԤԼ������', width: 80, align: 'left',resizable: true},
				{field:'ReqDate', title: 'ԤԼ����ʱ��', width: 100, align: 'left',resizable: true},
				{field:'StartTime', title: '��ʼʱ��', width: 80, align: 'left',resizable: true},
				{field:'EndTime', title: '����ʱ��', width: 80, align: 'left',resizable: true},
				{field:'LastUpdateUser', title: '��������', width: 80, align: 'left',resizable: true},
				{field:'LastUpdateDate', title: '������ʱ��', width: 100, align: 'left',resizable: true}   
			]],
			onBeforeLoad:function(param){
				$(this).datagrid("unselectAll");
				var StartDate=$("#StartDate").datebox("getValue");
				var EndDate=$("#EndDate").datebox("getValue");
				var queryLoc=$("#ComboLoc").combogrid("getValue");
				var queryStatus=$("#CureStatus").combogrid("getValue");
				queryStatus=CheckComboxSelData("CureStatus",queryStatus);
				var queryGroup=$('#ResGroup').combobox('getValue');
				queryGroup=CheckComboxSelData("ResGroup",queryGroup)
				var PatientNo=$('#patNo').val();
				var qWardID=$('#wardCmb').combobox('getValue');
				var gUserID=session['LOGON.USERID'];
				var gtext=$HUI.lookup("#ComboArcim").getText();
				if(gtext=="")PageSizeItemObj.m_SelectArcimID="";
				var queryArcim=PageSizeItemObj.m_SelectArcimID;
				var bookDateChk=$HUI.radio("#bookDateChk").getValue();
				if(bookDateChk){
					bookDateChk="A";	
				}else{
					bookDateChk="";	
				}
				var UserHospID=Util_GetSelUserHospID();
				var qExpStr=UserHospID+ "^" + session['LOGON.LANGID'];
				$.extend(param,{StartDate:StartDate,EndDate:EndDate,
				qWardID:qWardID,PatientNo:PatientNo,qArcimID:queryArcim,qRecLocID:queryLoc,
				qResGroupID:queryGroup,qCureStatus:queryStatus,qDateType:bookDateChk,qExpStr:qExpStr});
			}
		});
	}else{
		$.extend(DataGridObj,{  
			idField:"QueId",
			url : $URL+"?ClassName=DHCDoc.DHCDocCure.WordReport&QueryName=QueryWardCureAppoint&rows=9999",
			columns:[[
				{field:'QueId', title: 'QueId', width: 1, align: 'left',hidden:true}, 
				{field:'PatNo',title:'�ǼǺ�',width:100,align:'left'},   
    			{field:'PatName',title:'����',width:80,align:'left'},  
				{field:'QueNo',title:'�Ŷ����',width:80,align:'left'},
				{field:'DCAAStatus', title: 'ԤԼ״̬', width: 115, align: 'left',resizable: true
					,formatter:function(value,row,index){
						if (value==$g("��ԤԼ")){
							return "<span class='fillspan-fullnum'>"+value+"</span>";
						}else if(value==$g("ȡ��ԤԼ")){
							return "<span class='fillspan-xapp'>"+value+"</span>";
						}else{
							return "<span class='fillspan-nonenum'>"+value+"</span>";
						}
					}
				},
				{field:'ASDate', title:'ԤԼ��������', width: 100, align: 'left', resizable: true},
				{field:'QueDept', title:'���ƿ���', width: 150, align: 'left', resizable: true},
    			{field:'ResDesc', title: '������Դ', width: 100, align: 'left', resizable: true},
				{field:'TimeRange', title: 'ʱ��', width: 140, align: 'left', resizable: true},
				{field:'SchedStTime', title: '��ʼʱ��', width: 80, align: 'left',resizable: true},
				{field:'SchedEdTime', title: '����ʱ��', width: 80, align: 'left',resizable: true},
				{field:'DDCRSStatus', title: '�Ű�״̬', width: 80, align: 'left',resizable: true},
				{field:'QueOperUser', title: 'ԤԼ������', width: 80, align: 'left',resizable: true},
				{field:'QueStatusDate', title: '������ʱ��', width: 180, align: 'left',resizable: true},
				{field:'Job',title:'',width:1,hidden:true}
			]],
			onBeforeLoad:function(param){
				$(this).datagrid("unselectAll");
				var StartDate=$("#StartDate").datebox("getValue");
				var EndDate=$("#EndDate").datebox("getValue");
				var queryLoc=$("#ComboLoc").combogrid("getValue");
				var queryStatus=$("#CureStatus").combogrid("getValue");
				queryStatus=CheckComboxSelData("CureStatus",queryStatus);
				var queryGroup=$('#ResGroup').combobox('getValue');
				queryGroup=CheckComboxSelData("ResGroup",queryGroup)
				var PatientNo=$('#patNo').val();
				var qWardID=$('#wardCmb').combobox('getValue');
				var SessionStr="doccure.workreport.wardappoint.hui.csp"+"^"+com_Util.GetSessionStr();
				
				$.extend(param,{StartDate:StartDate,EndDate:EndDate,qWardID:qWardID,PatientNo:PatientNo,
				qRecLocID:queryLoc,qResGroupID:queryGroup,qCureStatus:queryStatus,SessionStr:SessionStr});
			}
		});
	}
	var CureReportDataGrid=$('#tabCureReportList').datagrid(DataGridObj);
	return CureReportDataGrid;		
}

function LoadCureReportListDataGrid()
{
	PageLogicObj.CureReportListDataGrid.datagrid("reload");
}

function InitCureStatus(){
	var CureStatusObj=$HUI.combobox('#CureStatus',{     
    	valueField:'Rowid',   
    	textField:'Desc',
    	data: [{
			Rowid: 'I',
			Desc: $g('ԤԼ')
		},{
			Rowid: 'C',
			Desc: $g('ȡ��ԤԼ')
		},{
			Rowid: 'A',
			Desc: $g('������')
		}]

	});
}

function InitWard(){
	var LocId="";
	var UserHospID=Util_GetSelUserHospID();
	$.cm({
		ClassName:"web.DHCExamPatList",
		QueryName:"GetWardMessage",
		desc:"", luloc:LocId,
		HospID:UserHospID,
		rows:99999
	},function(GridData){
		$HUI.combobox("#wardCmb", {
			valueField: 'HIDDEN', 
			textField: 'Ward', 
			editable:true,
			data: GridData["rows"],
			filter: function(q, row){
				return (row["Ward"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(row["Alias"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},
			onLoadSuccess:function(data){
				if ((data.length>0)&&(LocId!="")){
					$(this).combobox('select',data[0]['HIDDEN']);
				}else{
					var DefaultWard=ServerObj.DefaultWard;
					if(DefaultWard!=""){
						DefaultWard=DefaultWard.split("^")[1];
						for(var i=0;i<data.length;i++){
					    	if(data[i].HIDDEN==DefaultWard){
						    	SetDefaultWard();
						    	break;
						    }
					    }
					}
				}
			}
		});
	});
}

function SetDefaultWard(){
	var DefaultWard=ServerObj.DefaultWard;
	if (DefaultWard!=""){
		$("#wardCmb").combobox('setValue',DefaultWard.split("^")[1]);
	}
}

function clear_click()
{
	$('#patNo').val("");
	InitDate(ServerObj.CurrentDate);
	$('#CureStatus,#ComboLoc,#ResGroup').combobox('setValue',"");
	$HUI.lookup("#ComboArcim").setText("");
    PageSizeItemObj.m_SelectArcimID="";    
    SetDefaultWard();  
    $HUI.checkbox('#bookDateChk').setValue(false);
}


//��ӡѡ������
function print_click()
{
	var printDate = tkMakeServerCall("web.DHCRisWardQuery","GetCurrentDate");
	var printDoc = session['LOGON.USERNAME'];
	
	var printArr=new Array();
	var listTitle="����^�ǼǺ�^�Ա�^����^����^����^ҽ����Ŀ^ԤԼ����^ԤԼ��Դ^״̬^ִ�п���"
	printArr.push(listTitle);
	
	//var str=arr.join("");

	var selectRows=$('#orderlist').datagrid('getSelections');
	for ( var i=0;i<selectRows.length;i++)
	{
		
		var OeItemID=selectRows[i].OEOrdItemID;
		var depname=selectRows[i].Tdepname;
		var BedNo=selectRows[i].Tbedno;
		var RegNo=selectRows[i].Tregno;
		var Name=selectRows[i].Tname;
		var Sex=selectRows[i].Tsex;
		var Age=selectRows[i].TAge;
		var ItemName=selectRows[i].Titemname;
		var Date=selectRows[i].TstrDate;
		var Time=selectRows[i].TstrTime;
		var AppointDate=selectRows[i].TAppointDate;
		var AppointstTime=selectRows[i].TAppointstTime;
		var ResDesc=selectRows[i].TResDesc;
		var PrintFalg=selectRows[i].PrintFalg;
		var wardname=selectRows[i].Twarddesc;
		var RegDate=selectRows[i].TstrRegDate;
		var RegTime=selectRows[i].TstrRegTime;
		var StudyNo=selectRows[i].TStudyNo;
		var ReportDoc=selectRows[i].TReportDoc;
		var ReportVerifyDoc=selectRows[i].TReportVerifyDoc;
		var RisStatusDesc=selectRows[i].TRisStatusDesc;
		var BodyRowid=selectRows[i].bodyRowid;
		var MeothodDesc=selectRows[i].MeothodDesc;
		var PrintDate="";
		var PrintTime="";

		if(OeItemID!="" && PrintFalg!="Y")
		{
		  	//web.DHCRisWardQuery.SetPrintFlag
			
			var data=$.m({
				ClassName:"web.DHCRisWardQuery",
				MethodName:"SetPrintFlag",
				oeorditemdr:OeItemID,
				bodyRowid:BodyRowid
			
			},false);
			//web.DHCRisWardQuery.SetPrintDateTime
			var printInfo=$.m({
				ClassName:"web.DHCRisWardQuery",
				MethodName:"SetPrintDateTime",
				oeorditemdr:OeItemID,
				bodyRowid:BodyRowid
			},false);
			
			if (printInfo!="")
			{
				var Item=printInfo.split("^"); 
				PrintDate=Item[0];
				PrintTime=Item[1];
			}
		}
	
		var printInfo = Name+"^"+RegNo+"^"+Sex+"^"+Age+"^"+wardname+"^"+BedNo+"^"+ItemName+"^"+AppointDate+" "+AppointstTime+"^"+ResDesc+"^"+RisStatusDesc+"^"+depname;
		
		printArr.push(printInfo);
	
		

	}
	
	var printListStr=printArr.join(String.fromCharCode(2));
	
	DHCP_GetXMLConfig("InvPrintEncrypt","BookDataList");
	var myobj=document.getElementById("ClsBillPrint");
	
	var MyPara = "PrintDate"+String.fromCharCode(2)+printDate
					+"^PrintDoc"+String.fromCharCode(2)+printDoc; 
	//DHCP_PrintFunNew(myobj,MyPara,printListStr);
	//DHCP_PrintFun(myobj,MyPara,"");
	//DHCP_XMLPrint(myobj,MyPara,"");
	DHCP_PrintFunHDLP("",MyPara,printListStr);
}