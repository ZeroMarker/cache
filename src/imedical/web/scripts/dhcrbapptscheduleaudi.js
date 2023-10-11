var ApptScheduleAudiDataGrid;
var ApptScheduleAudiDetailDataGrid;
var PageLogicObj={
	dw:$(window).width()-100,
	dh:$(window).height()-180
};
$(document).ready(function(){
	var hospComp = GenUserHospComp();
	hospComp.jdata.options.onSelect = function(e,t){
		InitLoc();
		$HUI.combobox("#ComboDoc").setValue("");
		$HUI.combobox("#ComboDoc").loadData("")
		//$("#ComboDoc").combobox('loadData',[]);
		$HUI.combobox("#ComboSessType").setValue("");
		InitReason();
		ApptScheduleAudiDataGridLoad();
		ClearClick();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		//��ʼ��
		Init();
	}
	InitEvent();
});
function Init(){
	InitLoc();
	InitDoc();
	InitSessType();
	InitAudiStat();
	InitReason();
  	InitApptScheduleAudiDataGrid();	
}
function InitLoc(){
	$HUI.combobox("#ComboLoc", {})
    $.cm({
		ClassName:"web.DHCRBApptScheduleAudi",
		QueryName:"QueryLoc",
		'depname':"",
		'UserID':session['LOGON.USERID'],
		LogHospId:$HUI.combogrid('#_HospUserList').getValue(),
		dataType:"json",
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#ComboLoc", {
				valueField: 'id',
				textField: 'name', 
				editable:true,
				data: Data["rows"],
				filter: function(q, row){
					return (row["name"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["contactname"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},onSelect:function(record){
					InitDoc(record.id);
				},onChange:function(newValue, oldValue){
					if (newValue==""){
						$HUI.combobox("#ComboDoc").setValue("");
						$HUI.combobox("#ComboDoc").loadData("");
					}
				}
		 });
	});
}
function InitDoc(val){
	$HUI.combobox("#ComboDoc", {})
	if((typeof(val)=='undefined')||(val==""))return;
    $.cm({
		ClassName:"web.DHCOPRegReports",
		QueryName:"OPDoclookup",
		'locid':val,
		'DocDesc':"",
		HospID:$HUI.combogrid('#_HospUserList').getValue(),
		dataType:"json",
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#ComboDoc", {
				valueField: 'rowid',
				textField: 'OPLocdesc', 
				editable:true,
				data: Data["rows"],
				filter: function(q, row){
					return (row["OPLocdesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},
				
		 });
	});
}

function InitSessType(){
	$HUI.combobox("#ComboSessType", {})
    $.cm({
		ClassName:"web.DHCOPAdmRegQuery",
		QueryName:"SearchSessionType",
		'Desc':"",
		HospID:$HUI.combogrid('#_HospUserList').getValue(),
		dataType:"json",
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#ComboSessType", {
				valueField: 'HIDDEN',
				textField: 'Desc', 
				editable:true,
				data: Data["rows"],
				filter: function(q, row){
					return (row["Desc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				}
		 });
	});
}

function InitAudiStat(){
	$HUI.combobox("#ComboAudiStatus", {})
    $.cm({
		ClassName:"web.DHCRBApptScheduleAudi",
		QueryName:"QueryAudiStat",
		dataType:"json",
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#ComboAudiStatus", {
				valueField: 'id',
				textField: 'name', 
				editable:false,
				data: Data["rows"],
				filter: function(q, row){
					return (row["name"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},onLoadSuccess:function(){
					$HUI.combobox("#ComboAudiStatus").select("N");	
				}
		 });
	});	
}

function InitReason(){
    $.cm({
		ClassName:"web.DHCRBApptScheduleAudi",
		QueryName:"FindAudiReason",
		'Type':"F",
		HospID:$HUI.combogrid('#_HospUserList').getValue(),
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#ComboReason,#win_ComboReason", {
				valueField: 'TAudiID',
				textField: 'TAudiDesc', 
				editable:true,
				data: Data["rows"],
				filter: function(q, row){
					return (row["TAudiDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				}
		 });
	});
}

function InitEvent(){
	$('#btnFind').click(ApptScheduleAudiDataGridLoad);
    $('#btnClear').click(ClearClick);
    $('#btnCancelAll').click(CancelAllClick);
    $('#btnAll').click(AllClick);
    $('#win_RefuseSure').click(RefuseSureHandle);
    $HUI.checkbox("#Check_QryByLoc",{
		onChecked:function(e,val){
			setTimeout("ApptScheduleAudiDataGridLoad();",10)	
		},
		onUnchecked:function(e,val){
			setTimeout("ApptScheduleAudiDataGridLoad();",10)
		}	
	})
}

function AllClick(){
	
}

function BCheckAll_click(){
	$('#tabApptScheduleAudi').datagrid("selectAll");
	$('#tabApptScheduleAudi').datagrid("checkAll");
}

function BunCheckAll_click(){
	$('#tabApptScheduleAudi').datagrid("unselectAll");
	$('#tabApptScheduleAudi').datagrid("uncheckAll");	
}

function CancelAllClick(){
	$('#tabApptScheduleAudi').datagrid("clearSelections");
	$('#tabApptScheduleAudi').datagrid("clearChecked");
}

function ClearClick(){
	$HUI.combobox("#ComboLoc").setValue("");
	$HUI.combobox("#ComboSessType").setValue("");
	$HUI.combobox("#ComboAudiStatus").select("N");	
	$HUI.datebox("#StartDate").setValue("");
	$HUI.datebox("#EndDate").setValue("");
	$HUI.checkbox("#Check_New").setValue(false);
	$HUI.checkbox("#Check_Stop").setValue(false);
	$HUI.checkbox("#Check_CancelStop").setValue(false);
	$HUI.checkbox("#Check_Replace").setValue(false);
	$HUI.combobox("#ComboReason").setValue("");
	$HUI.datebox("#ScheduleDate").setValue("");
	$HUI.combobox("#ComboDoc").setValue("");
	$HUI.combobox("#ComboDoc").loadData("");
}

function InitApptScheduleAudiDataGrid()
{
	ApptScheduleAudiDataGrid=$('#tabApptScheduleAudi').datagrid({  
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
		singleSelect:false,    
		url : '',
		loadMsg : '������..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"TIndex",
		//pageNumber:0,
		pageSize : 20,
		pageList : [20,50,100],
		columns :[[ 
				{field:'RowCheck',checkbox:true
				},
				{field:'TRequestType',title:'��������',width:85,align:'center'}, 
				{field:'TRequestDate',title:'����ʱ��',width:100,align:'center'}, 
				{field:'TRequestWaitTime',title:'�ȴ�ʱ��',width:80,align:'center'}, 
				{field:'TLocDesc',title:'����',width:150,align:'center'},								
				{field:'TDocDesc',title:'ҽ��',width:100,align:'center',
						formatter:function(value,row,index){
							if(row.TDocDesc=="˫���鿴��ϸ"){
								return '<a href="###" ondblclick=ShowScheduleDetail('+row.TIndex+','+row.TLocid+');>'+row.TDocDesc+"</a>"
							}else{
								return row.TDocDesc;	
							}
						},
						styler:function(value,row){
							if(row.TDocDesc=="˫���鿴��ϸ"){	
								return "color:blue;text-decoration: underline;"
							}
						}
				}, 
				{field:'TDate',title:'��������',width:100,align:'center'}, 
				{field:'TTimeRange',title:'ʱ��',width:50,align:'center'}, 
				{field:'TSessionType',title:'�ű�',width:100,align:'center'}, 
				{field:'TRegNum',title:'�޶�',width:150,align:'center'},
				{field:'TReason',title:'ͣ����ԭ��',width:100,align:'center'},
				{field:'TRInfo',title:'����ҽ����Ϣ',width:150,align:'center'}, 
				//{field:'TRLocDesc',title:'�������',width:120,align:'center'}, 
				//{field:'TRDocDesc',title:'����ҽ��',width:100,align:'center'}, 
				//{field:'TRSessionType',title:'����ű�',width:100,align:'center'}, 
				{field:'TResult',title:'״̬',width:60,align:'center'}, 
				{field:'TRequestAuditDate',title:'����ʱ��',width:80,align:'center'}, 
				{field:'TRequestUser',title:'������',width:80,align:'center'}, 
				{field:'TRequestAuditUser',title:'������',width:80,align:'center'}, 
				{field:'TRequestReason',title:'�ܾ�ԭ��',width:100,align:'center'}, 
				{field:'TID',title:'TID',width:30,align:'center',hidden:true},
				{field:'TSelect',title:'TSelect',width:30,align:'center',hidden:true},
				{field:'TIndex',title:'TIndex',width:30,align:'center',hidden:false},
				{field:'TLocid',title:'TLocid',width:30,align:'center',hidden:true}
			 ]],
			 onLoadSuccess:function(data){
				$(this).parent().find("div .datagrid-header-check")
                .children("input[type=\"checkbox\"]").eq(0)
                .attr("style", "display:none;");
				SetSelectDisabled();			
			 },onDblClickRow:function(index,row){
				return false;	 
			 }
	});
	ApptScheduleAudiDataGridLoad();
}
function ApptScheduleAudiDataGridLoad()
{
	var StartDate=$("#StartDate").datebox("getValue");
	var EndDate=$("#EndDate").datebox("getValue");
	var LocID=$HUI.combobox("#ComboLoc").getValue();
	LocID=CheckComboxSelData("ComboLoc",LocID);
	var DocID=$HUI.combobox("#ComboDoc").getValue();
	DocID=CheckComboxSelData("ComboDoc",DocID)
	var SessionTypeID=$HUI.combobox("#ComboSessType").getValue();
	SessionTypeID=CheckComboxSelData("ComboSessType",SessionTypeID)
	var ChkAuditStat=$HUI.combobox("#ComboAudiStatus").getValue();
	ChkAuditStat=CheckComboxSelData("ComboAudiStatus",ChkAuditStat);
	if(ChkAuditStat=="")ChkAuditStat="N";
	var ChkNewFlag="",ChkStopFlag="";ChkCancelStopFlag="";ChkReplaceFlag="";ChkQryByLocFlag="";
	var ChkNew=$("#Check_New").prop("checked");
	if(ChkNew)ChkNewFlag="Y"
	var ChkStop=$("#Check_Stop").prop("checked");
	if(ChkStop)ChkStopFlag="Y"
	var ChkCancelStop=$("#Check_CancelStop").prop("checked");
	if(ChkCancelStop)ChkCancelStopFlag="Y"
	var ChkReplace=$("#Check_Replace").prop("checked");
	if(ChkReplace)ChkReplaceFlag="Y"
	var ChkQryByLoc=$("#Check_QryByLoc").prop("checked");
	if(ChkQryByLoc)ChkQryByLocFlag="Y";
	var ScheduleDate=$("#ScheduleDate").datebox("getValue");
	var ReasonDr=$HUI.combobox("#ComboReason").getValue();
	$.cm({
		ClassName:"web.DHCRBApptScheduleAudi",
		QueryName:"RBASRequestQuery",
		'StartDate':StartDate,
		'EndDate':EndDate,
		'LocID':LocID,
		'DocID':DocID,
		'SessionTypeID':SessionTypeID,
		'ChkAuditStat':ChkAuditStat,
		'ChkNew':ChkNewFlag,
		'ChkStop':ChkStopFlag,
		'ChkCancelStop':ChkCancelStopFlag,
		'ChkReplace':ChkReplaceFlag,
		'ChkQryByLoc':ChkQryByLocFlag,
		'FindIndex':"",
		'ScheduleDate':ScheduleDate,
		'ReasonDr':ReasonDr,
		HospID:$HUI.combogrid('#_HospUserList').getValue(),
		Pagerows:ApptScheduleAudiDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		ApptScheduleAudiDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		ApptScheduleAudiDataGrid.datagrid('clearSelections'); 
		ApptScheduleAudiDataGrid.datagrid('clearChecked'); 
	})
}

function CheckComboxSelData(id,selId){
	var Find=0;
	 var Data=$("#"+id).combobox('getData');
	 for(var i=0;i<Data.length;i++){
		 if (id=="ComboSessType"){
			var CombValue=Data[i].HIDDEN;
		 	var CombDesc=Data[i].Desc;
	     }else if (id=="ComboDoc"){
			var CombValue=Data[i].rowid;
		 	var CombDesc=Data[i].OPLocdesc;
	     }else if ((id=="ComboReason")||(id=="win_ComboReason")){
			var CombValue=Data[i].TAudiID;
		 	var CombDesc=Data[i].TAudiDesc;
	     }else{
		    var CombValue=Data[i].id  
		 	var CombDesc=Data[i].name
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

function SetSelectDisabled(){
	var data=$('#tabApptScheduleAudi').datagrid("getData"); // ��ȡ��������data.rows
	if (data.rows.length > 0) {
		var rowData = data.rows;
        $.each(rowData,function(idx,val){
			if(val.TSelect==1){
				//setTimeout('selectOneRow('+idx+');',10);
			}else{
				$("#tabApptScheduleAudi").parent().find("div .datagrid-cell-check")
				.children("input[type=\"checkbox\"]").eq(idx)
				.attr("style", "display:none;");  
			}
        });  
	}
}

function selectOneRow(idx,sel){
	if(sel=="Y"){
		$("#tabApptScheduleAudi").datagrid("checkRow", idx);
	}else{
		$("#tabApptScheduleAudi").datagrid("uncheckRow", idx);	
	}	
}

function GetSelectIDs(val)
{
	
	var rows=$("#tabApptScheduleAudi").datagrid('getSelections');
	var len=rows.length;
	var IDs=""
	for (i=0;i<len;i++)
	{
		var TSelect=rows[i].TSelect
		if(TSelect=="0")continue;
		//var TCheck=$("#tabApptScheduleAudi").parent().find("div .datagrid-cell-check").children("input[type=\"checkbox\"]").eq(i).is(':checked');
		//alert(TCheck)
		//if(!TCheck)continue;
		var ID=rows[i].TID;
		if(val=="Y"){
			ID=rows[i].TIndex;	
		}
		if (IDs==""){
			IDs=ID;
		}else{
			IDs=IDs+"^"+ID
		}
	}
	return IDs;
}
function CheckQryByLoc(){
	var ChkQryByLocFlag="";
	var ChkQryByLoc=$("#Check_QryByLoc").prop("checked");
	if(ChkQryByLoc)ChkQryByLocFlag="Y";
	return ChkQryByLocFlag;
}
function BAudit_click()
{
	var flag=CheckQryByLoc()
	var IDs=GetSelectIDs(flag);
	if (IDs==""){
		$.messager.alert("��ʾ","�������ϵĹ�ѡ��,ѡ������Ҫ����������");
		return "";
	}
	//var ret=tkMakeServerCall("web.DHCRBApptSchedule","AuditRBASRequest",IDs)
	$.messager.confirm('ȷ��',"�Ƿ�ȷ�����?",function(r){
		if (r){
			$.m({
				ClassName:"web.DHCRBApptScheduleAudi",
				MethodName:"AuditRBASRequest",
				'IDs':IDs,
				'UserID':session['LOGON.USERID'],
				'GenFlag':flag,
			},function testget(value){
				if (value<0){
					$.messager.alert("��ʾ","�������ݴ���");
					ApptScheduleAudiDataGridLoad();
				}else if(value>0){
					$.messager.alert("��ʾ","����"+ret+"�����ܲ���������");
					ApptScheduleAudiDataGridLoad();
				}else{
					//$.messager.show("��ʾ","�����ɹ�");
					$.messager.show({
						title: '��ʾ',
						msg: '�����ɹ�',
						timeout: 3000,
						showType: 'slide'
					});
					ApptScheduleAudiDataGridLoad();
				}			
				
			});
		}
	})
}
function BRefuse_click()
{
	var flag=CheckQryByLoc()
	var IDs=GetSelectIDs(flag);
	if (IDs==""){
		$.messager.alert("��ʾ","�������ϵĹ�ѡ��,ѡ������Ҫ����������");
		return "";
	}
	ShowReasonWin();
}

function ShowReasonWin(){
	$("#reason-dialog").dialog("open");
	$("#win_ComboReason").combobox('select',"");
	$("#win_ComboReason").next('span').find('input').focus();
}
function RefuseSureHandle(){
	var flag=CheckQryByLoc()
	var IDs=GetSelectIDs(flag);
	if (IDs==""){
		$.messager.alert("��ʾ","�������ϵĹ�ѡ��,ѡ������Ҫ����������");
		return "";
	}
	var ReasonDr=$HUI.combobox("#win_ComboReason").getValue();
	ReasonDr=CheckComboxSelData("win_ComboReason",ReasonDr);
	if (ReasonDr==""){
		$.messager.alert("��ʾ","��ѡ��ܾ�ԭ��.");
		return false;
	}
	
	$.messager.confirm('ȷ��',"�Ƿ�ȷ�Ͼܾ�?",function(r){
		if (r){
			$.m({
				ClassName:"web.DHCRBApptScheduleAudi",
				MethodName:"RefuseRBASRequest",
				'IDs':IDs,
				'UserID':session['LOGON.USERID'],
				'ReasonDr':ReasonDr,
				'GenFlag':flag,
			},function testget(value){
				if (value<0){
					$.messager.alert("��ʾ","�������ݴ���");
					ApptScheduleAudiDataGridLoad();
				}else if(value>0){
					$.messager.alert("��ʾ","����"+ret+"�����ܲ���������");
					ApptScheduleAudiDataGridLoad();
				}else{
					$.messager.popover({msg: '�����ɹ���',type:'success',timeout: 1000});
					$("#reason-dialog").dialog("close");
					ApptScheduleAudiDataGridLoad();
				}			
				
			});
		}
	})
}

function BDelete_click()
{
	var flag=CheckQryByLoc()
	var IDs=GetSelectIDs(flag);
	if (IDs==""){
		$.messager.alert("��ʾ","�������ϵĹ�ѡ��,ѡ������Ҫ����������");
		return "";
	}
	//var ret=tkMakeServerCall("web.DHCRBApptSchedule","DeleteRBASRequest",IDs)
	$.messager.confirm('ȷ��',"�Ƿ�ȷ�ϳ�������?",function(r){
		if (r){
			$.m({
				ClassName:"web.DHCRBApptScheduleAudi",
				MethodName:"DeleteRBASRequest",
				'IDs':IDs,
				'UserID':session['LOGON.USERID'],
				'GenFlag':flag,
			},function testget(value){
				testGetReturn(value);	
			});
		}
	})
}

function testGetReturn(value){
	if (value<0){
		$.messager.alert("��ʾ","�������ݴ���");
		ApptScheduleAudiDataGridLoad();
	}else if(value>0){
		$.messager.alert("��ʾ","����"+value+"�����ܲ���������");
		ApptScheduleAudiDataGridLoad();
	}else{
		$.messager.show("��ʾ","�����ɹ�");
		ApptScheduleAudiDataGridLoad();
	}	
}

function ShowScheduleDetail(inde,loc){
	$('#add-dialog').window('open').window('resize',{width:PageLogicObj.dw,height:PageLogicObj.dh,top: 100,left:50});
	ApptScheduleAudiDetailDataGrid=$('#tabApptScheduleAudiDetail').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : false,
		checkOnSelect:false,
		fitColumns : false,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		singleSelect:false,    
		url : '',
		loadMsg : '������..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"TID",
		//pageNumber:0,
		pageSize : 20,
		pageList : [20,50,100],
		columns :[[ 
				//{field:'RowCheck',checkbox:true},
				{field:'TRequestType',title:'��������',width:85,align:'center'}, 
				{field:'TRequestDate',title:'����ʱ��',width:100,align:'center'}, 
				{field:'TRequestWaitTime',title:'�ȴ�ʱ��',width:80,align:'center'}, 
				{field:'TLocDesc',title:'����',width:150,align:'center'},								
				{field:'TDocDesc',title:'ҽ��',width:90,align:'center',}, 
				{field:'TDate',title:'��������',width:100,align:'center'}, 
				{field:'TTimeRange',title:'ʱ��',width:50,align:'center'}, 
				{field:'TSessionType',title:'�ű�',width:100,align:'center'}, 
				{field:'TNoLimitLoadFlag',title:'�����ƺ�Դ',width:100,align:'center'},
				{field:'TRegNum',title:'�޶�',width:150,align:'center'},
				{field:'TReason',title:'ͣ����ԭ��',width:100,align:'center'},
				//{field:'TRLocDesc',title:'�������',width:120,align:'center'}, 
				//{field:'TRDocDesc',title:'����ҽ��',width:100,align:'center'}, 
				//{field:'TRSessionType',title:'����ű�',width:100,align:'center'}, 
				{field:'TResult',title:'״̬',width:60,align:'center'}, 
				{field:'TRequestAuditDate',title:'����ʱ��',width:80,align:'center'}, 
				{field:'TRequestUser',title:'������',width:80,align:'center'}, 
				{field:'TRequestAuditUser',title:'������',width:80,align:'center'},
				{field:'TRequestReason',title:'�ܾ�ԭ��',width:100,align:'center'},
				{field:'TRInfo',title:'����ҽ����Ϣ',width:150,align:'center'},   
				{field:'TID',title:'TID',width:30,align:'center',hidden:true},
				//{field:'TSelect',title:'TSelect',width:30,align:'center',hidden:true},
				//{field:'TIndex',title:'TIndex',width:30,align:'center',hidden:true}
			 ]]
			 /*,
			 onLoadSuccess:function(data){
				 $(this).parent().find("div .datagrid-header-check")
                .children("input[type=\"checkbox\"]").eq(0)
                .attr("style", "display:none;");
				SetSelectDisabled();			
			 }
			 */
	});
	ApptScheduleAudiDetailDataGridLoad(inde,loc);
}

function ApptScheduleAudiDetailDataGridLoad(DetailIndex,FindLoc)
{
	if(typeof(DetailIndex)=='undefined'){
		DetailIndex="";	
	}
	if(typeof(FindLoc)=='undefined'){
		FindLoc="";	
	}
	if(DetailIndex=="")return;
	var StartDate=$("#StartDate").datebox("getValue");
	var EndDate=$("#EndDate").datebox("getValue");
	var LocID=$HUI.combobox("#ComboLoc").getValue();
	LocID=CheckComboxSelData("ComboLoc",LocID);
	var DocID=$HUI.combobox("#ComboDoc").getValue();
	DocID=CheckComboxSelData("ComboDoc",DocID)
	var SessionTypeID=$HUI.combobox("#ComboSessType").getValue();
	SessionTypeID=CheckComboxSelData("ComboSessType",SessionTypeID)
	var ChkAuditStat=$HUI.combobox("#ComboAudiStatus").getValue();
	ChkAuditStat=CheckComboxSelData("ComboAudiStatus",ChkAuditStat);
	if(ChkAuditStat=="")ChkAuditStat="N";
	var ChkNewFlag="",ChkStopFlag="";ChkCancelStopFlag="";ChkReplaceFlag="";ChkQryByLocFlag="";
	var ChkNew=$("#Check_New").prop("checked");
	if(ChkNew)ChkNewFlag="Y"
	var ChkStop=$("#Check_Stop").prop("checked");
	if(ChkStop)ChkStopFlag="Y"
	var ChkCancelStop=$("#Check_CancelStop").prop("checked");
	if(ChkCancelStop)ChkCancelStopFlag="Y"
	var ChkReplace=$("#Check_Replace").prop("checked");
	if(ChkReplace)ChkReplaceFlag="Y"
	var ChkQryByLoc=$("#Check_QryByLoc").prop("checked");
	if(ChkQryByLoc)ChkQryByLocFlag="Y"
	if(DetailIndex!=""){
		LocID=FindLoc;
	}
	$.cm({
		ClassName:"web.DHCRBApptScheduleAudi",
		QueryName:"RBASRequestQuery",
		'StartDate':StartDate,
		'EndDate':EndDate,
		'LocID':LocID,
		'DocID':DocID,
		'SessionTypeID':SessionTypeID,
		'ChkAuditStat':ChkAuditStat,
		'ChkNew':ChkNewFlag,
		'ChkStop':ChkStopFlag,
		'ChkCancelStop':ChkCancelStopFlag,
		'ChkReplace':ChkReplaceFlag,
		'ChkQryByLoc':ChkQryByLocFlag,
		'FindIndex':DetailIndex,
		Pagerows:ApptScheduleAudiDetailDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		ApptScheduleAudiDetailDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		ApptScheduleAudiDetailDataGrid.datagrid('clearSelections'); 
		ApptScheduleAudiDetailDataGrid.datagrid('clearChecked'); 
	})
}

function CheckRowCheck(index){
	var checkval=$("#tabApptScheduleAudi").parent().find("div .datagrid-cell-check")
	.children("input[type=\"checkbox\"]").eq(index)
	.is(':checked');
	return checkval;	
}