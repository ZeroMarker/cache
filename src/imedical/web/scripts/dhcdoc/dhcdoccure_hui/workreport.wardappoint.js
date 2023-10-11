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
		loadMsg : '加载中...',  
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
				{field:'PatientNo',title:'患者登记号',width:100,align:'left'},   
				{field:'PatientName',title:'患者姓名',width:80,align:'left'},  
				{field:'PatOther',title:'患者其他信息',width:180,align:'left'},
				{field:'PAAdmWard',title:'所在病区',width:120,align:'left'},
				{field:'CureApplyNo',title:'治疗申请单号',width:120,align:'left'},
				{field:'ArcimDesc',title:'治疗项目',width:150,align:'left'},
				{field:'OrderReLoc',title:'接收科室',width:120,align:'left'},
				{field:'ApplyStatus',title:'申请单状态',width:80,align:'left'},
				{field:'ApplyDate',title:'申请日期',width:150,align:'left'},
				{field:'ApplyUser',title:'申请人',width:100,align:'left'},
				{field:'DDCRSDate', title:'预约治疗日期', width: 120, align: 'left', sortable: true, resizable: true},
				{field:'DDCRSLoc', title:'治疗科室', width: 120, align: 'left', sortable: true, resizable: true},
				{field:'CTCareProv', title: '治疗医师', width: 100, align: 'left', resizable: true},
				{field:'TimeRangeDesc', title: '预约时段', width: 80, align: 'left', resizable: true},
				{field:'DCASeqNo',title:'治疗排队序号',width:100,align:'left'},
				{field:'DCAAQty',title:'治疗数量',width:80,align:'left'},
				{field:'DCAAStatus', title: '预约治疗状态', width: 100, align: 'left',resizable: true},
				{field:'ServiceGroupDesc', title: '服务组', width: 80, align: 'left',resizable: true},
				{field:'DDCRSStatus', title: '预约排班状态', width: 100, align: 'left',resizable: true},
				{field:'ReqUser', title: '预约操作人', width: 80, align: 'left',resizable: true},
				{field:'ReqDate', title: '预约操作时间', width: 100, align: 'left',resizable: true},
				{field:'StartTime', title: '开始时间', width: 80, align: 'left',resizable: true},
				{field:'EndTime', title: '结束时间', width: 80, align: 'left',resizable: true},
				{field:'LastUpdateUser', title: '最后更新人', width: 80, align: 'left',resizable: true},
				{field:'LastUpdateDate', title: '最后更新时间', width: 100, align: 'left',resizable: true}   
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
				{field:'PatNo',title:'登记号',width:100,align:'left'},   
    			{field:'PatName',title:'姓名',width:80,align:'left'},  
				{field:'QueNo',title:'排队序号',width:80,align:'left'},
				{field:'DCAAStatus', title: '预约状态', width: 115, align: 'left',resizable: true
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
				{field:'ASDate', title:'预约治疗日期', width: 100, align: 'left', resizable: true},
				{field:'QueDept', title:'治疗科室', width: 150, align: 'left', resizable: true},
    			{field:'ResDesc', title: '治疗资源', width: 100, align: 'left', resizable: true},
				{field:'TimeRange', title: '时段', width: 140, align: 'left', resizable: true},
				{field:'SchedStTime', title: '开始时间', width: 80, align: 'left',resizable: true},
				{field:'SchedEdTime', title: '结束时间', width: 80, align: 'left',resizable: true},
				{field:'DDCRSStatus', title: '排班状态', width: 80, align: 'left',resizable: true},
				{field:'QueOperUser', title: '预约操作人', width: 80, align: 'left',resizable: true},
				{field:'QueStatusDate', title: '最后操作时间', width: 180, align: 'left',resizable: true},
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
			Desc: $g('预约')
		},{
			Rowid: 'C',
			Desc: $g('取消预约')
		},{
			Rowid: 'A',
			Desc: $g('已治疗')
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


//打印选中数据
function print_click()
{
	var printDate = tkMakeServerCall("web.DHCRisWardQuery","GetCurrentDate");
	var printDoc = session['LOGON.USERNAME'];
	
	var printArr=new Array();
	var listTitle="姓名^登记号^性别^年龄^病区^床号^医嘱项目^预约日期^预约资源^状态^执行科室"
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