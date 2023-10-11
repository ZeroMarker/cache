var PageLogicObj={
	m_TalStartDate:"",
	m_SchduleDataGridLoadTimer:"",
	m_SearchClickTimer:"",
	m_ScheduleTabIndex:"",
	m_CureScheduleListDataGrid:"",
	m_TabAppQtyListDataGrid:"",
	m_LogLocID:session['LOGON.CTLOCID']
}
$(document).ready(function(){
	if(ServerObj.ToLocFlag=="Y"){
		LoadSuccessInit();
	}else{
		InitHospList();
	}
	
	InitEvent();	
});	

function InitHospList(){
	var hospStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	var hospComp = GenHospComp("Doc_Cure_Schedule",hospStr);
	hospComp.jdata.options.onSelect = function(e,t){
		if (!CheckDocCureUseBase()){
			return;
		}
		$("#LocName,#Resource,#Loc_Search,#Doc_Search").combobox('setValue',"");
		ReLoadComboDoc("Resource");
		ReLoadComboDoc("Doc_Search");
		Init();
		TimeInterSearch();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		LoadSuccessInit();
	}
}
function LoadSuccessInit(){
	if (!CheckDocCureUseBase()){
		return;
	}
	Init();
}
function CheckDocCureUseBase(){
	var UserHospID=Util_GetSelHospID();
	var DocCureUseBase=$.m({
		ClassName:"DHCDoc.DHCDocCure.VersionControl",
		MethodName:"UseBaseControl",
		HospitalId:UserHospID,
		dataType:"text"
	},false);
	if (DocCureUseBase=="1"){
		$(".window-mask.alldom").show();
		return false;
	}else{
		$(".window-mask.alldom").hide();
		return true;
	}
}

function Init(){
	//资源列表
	var CureResourceObj=$HUI.combobox('#Resource',{      
		valueField:'TRowid',   
		textField:'TResDesc'   
	});
	
	//科室列表
	InitLoc("LocName",CureResourceObj);
	//$("#BookDate,#BookEndDate").datebox('setValue',ServerObj.CurrDate);		
	//InitCureRBCResSchdule();
	var HospDr=Util_GetSelHospID();
	$HUI.combobox('#ResGroup',{
		valueField:'Rowid',   
		textField:'Desc',
		url:$URL+"?ClassName=DHCDoc.DHCDocCure.RBCServiceGroupSet&QueryName=QueryServiceGroup&HospID="+HospDr+"&ResultSetType=array",
	});	
	
	InitWinComb();
	
	//if(ServerObj.ToLocFlag!="Y"){
		var DocSearchObj=$HUI.combobox('#Doc_Search',{      
			valueField:'TRowid',   
			textField:'TResDesc'   
		});
		InitLoc("Loc_Search",DocSearchObj);
		InitWeekSearch();
	//}
	PageLogicObj.m_TabAppQtyListDataGrid=InitTabAppQtyList();
}

function InitLoc(parame,obj){
	var HospDr=Util_GetSelHospID();
	var ForLocID="";
	if(ServerObj.ToLocFlag=="Y"){
	    ForLocID=PageLogicObj.m_LogLocID;
	}	
    $HUI.combobox("#"+parame+"", {
		valueField: 'LocId',
		textField: 'LocDesc', 
		editable:true,
		url:$URL+"?ClassName=DHCDoc.DHCDocCure.Config&QueryName=QueryCureLoc&HospID="+HospDr+"&LogLocID="+ForLocID+"&ResultSetType=array",
		filter: function(q, row){
			return (row["LocDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["LocContactName"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
		},onSelect:function(record){
			var locId=record.LocId;
			var url = $URL+"?ClassName=DHCDoc.DHCDocCure.Config&QueryName=QueryResource&LocID="+locId+"&ResultSetType=array";
			obj.clear();
			obj.reload(url);
			if(parame=="LocName"){
				TimeInterSearch();
			}
		} ,onLoadSuccess:function(data){
			if(ServerObj.ToLocFlag=="Y"){
				for(var i=0;i<data.length;i++){
			    	if(data[i].LocId==PageLogicObj.m_LogLocID){
				    	$(this).combobox("select",PageLogicObj.m_LogLocID).combobox("disable");
				    }
			    }
			}	
		}  
	});
}


function InitEvent(){
	$('#btnSave').bind('click', function(){
		if(!SaveFormData())return false;
	});
	$('#btnFind').bind('click', function(){
		SearchClick();
		//LoadCureRBCResSchduleDataGrid();
	}); 
	$("#BookDate").datebox({
		onChange:function(newValue, oldValue){
			TimeInterSearch();
		}
	}).datebox('setValue',ServerObj.CurrDate); 
	$('#btnBatch').bind('click', function(){
		ShowScheduleListWin();
	}); 
	$('#btnWinFindSchedule').bind('click', function(){
		PageLogicObj.m_CureScheduleListDataGrid.datagrid('reload');
	});
	$("#TimeRangeFlag").checkbox({
		onCheckChange:function(e,val){
			ChangeTREleStyle(val);
		}
	})
	$("#TRLength").numberbox({
		onChange:function(newValue,oldValue){
			TRInfoCalculateHandle("N");
		}
	});
}

function InitWinComb(){
	var HospDr=Util_GetSelHospID();
	//资源列表
	var CureResourceListObj=$HUI.combobox('#ResourceList',{     
		valueField:'TRowid',   
		textField:'TResDesc'   
	});
	//科室列表
	InitLoc("LocList",CureResourceListObj);
	
	//服务组列表
	var CureServiceGroupListObj=$HUI.combobox('#ServiceGroup',{
		valueField:'Rowid',   
		textField:'Desc',
		url:$URL+"?ClassName=DHCDoc.DHCDocCure.RBCServiceGroupSet&QueryName=QueryServiceGroup&HospID="+HospDr+"&ResultSetType=array",
		onSelect:function(record){
			$("#TimeDesc").combobox("select","");	
			var HospID=Util_GetSelHospID();
			var rs=$cm({
				ClassName:"DHCDoc.DHCDocCure.RBCResPlan",
				QueryName:"QueryBookTime",
				HospID:HospID,
				SGRowID:record.Rowid,
				ResultSetType:"array", 
				rows:99999
			},false);
			$("#TimeDesc").combobox("loadData",rs);			
		}  
	});	
	
  	//时段列表
	var CureTimeDescListObj=$HUI.combobox('#TimeDesc',{ 
		valueField:'Rowid',   
		textField:'Desc',
		//url:$URL+"?ClassName=DHCDoc.DHCDocCure.RBCResPlan&QueryName=QueryBookTime&SGRowID="+""+"&HospID="+HospDr+"&ResultSetType=array",
		onSelect:function(record){
			if ((record!=undefined)&&(record!="")){
				var Rowid=record.Rowid;
				var StartTime=record.StartTime;
				var EndTime=record.EndTime;
				var EndChargTime=record.EndChargTime;
				var EndAppointTime=record.EndAppointTime;
				$("#StartTime").timespinner("setValue",StartTime);
				$("#EndTime").timespinner("setValue",EndTime);
				$("#EndAppointTime").timespinner("setValue",EndAppointTime);
				TRInfoCalculateHandle("N");
			}else{
				$("#StartTime,#EndTime,#EndAppointTime").timespinner("setValue",StartTime);
			}
		} 
	});
	//星期列表
	var CureWeekListObj=$HUI.combobox('#Week',{
		valueField:'WeekId',   
		textField:'WeekName',
		url:$URL+"?ClassName=DHCDoc.DHCDocCure.RBCResPlan&QueryName=QueryWeek&ResultSetType=array",
	});
}
function CheckData(){
	var Date=$('#Date').datebox('getValue');
	if(Date=="")
	{
		$.messager.alert('提示','请选择日期',"warning");   
        return false;
	}
	var LocId=$('#LocList').combobox('getValue');
	var LocId=CheckComboxSelData("LocList",LocId);
	if(LocId=="")
	{
		 $.messager.alert("提示", "请选择科室", 'warning')
        return false;
	}
	var ResourceId=$('#ResourceList').combobox('getValue');
	var ResourceId=CheckComboxSelData("ResourceList",ResourceId);
	if(ResourceId=="")
	{
		 $.messager.alert("提示", "请选择资源", 'warning')
        return false;
	}
	var TimeDesc=$('#TimeDesc').combobox('getValue');
	var TimeDesc=CheckComboxSelData("TimeDesc",TimeDesc);
	if(TimeDesc=="")
	{
		$.messager.alert('提示','请选择时段', 'warning');   
        return false;
	}
	var ServiceGroup=$('#ServiceGroup').combobox('getValue');
	var ServiceGroup=CheckComboxSelData("ServiceGroup",ServiceGroup);
	if(ServiceGroup=="")
	{
		$.messager.alert('提示','请选择服务组', 'warning');   
        return false;
	}
	var StartTime=$("#StartTime").val();
	if(StartTime=="")
	{
		$.messager.alert('提示','请填写开始时间', 'warning');   
        return false;
	}
	var EndTime=$("#EndTime").val();
	if(EndTime=="")
	{
		$.messager.alert('提示','请填写结束时间', 'warning');   
        return false;
	}
	var Max=$("#Max").val();
	if(Max=="")
	{
		$.messager.alert('提示','请填写最大预约数', 'warning');   
        return false;
	}
	var Max=parseFloat(Max);
	if(Max<=0){
		$.messager.alert("提示","预约数请填写大于0整数", 'warning');
		return false;		
	}
	var ReservedNum=$("#ReservedNum").numberbox("getValue");
	if ((ReservedNum!="")&&(parseInt(ReservedNum)>parseInt(Max))){
		$.messager.alert('提示','分时段保留号数不能大于最大预约数',"warning");   
        return false;
	}
	return true;
}
///修改表格函数
function SaveFormData(){
	if(!CheckData()) return false;
	var Rowid=$("#Rowid").val();
	var Date=$('#Date').datebox('getValue');
	var LocId=$('#LocList').combobox('getValue');
	var ResourceId=$('#ResourceList').combobox('getValue');   
	var TimeDesc=$('#TimeDesc').combobox('getValue');
	var ServiceGroup=$('#ServiceGroup').combobox('getValue');
	var StartTime=$("#StartTime").val();
	var EndTime=$("#EndTime").val();
	var Max=$("#Max").val();
	var AutoNumber="";//$("#AutoNumber").val();
	var ChargTime="";
	var EndAppointTime=$("#EndAppointTime").val();
	var TimeRangeInfo=GetTRInfo();
	if(TimeRangeInfo==false){	
		return false;
	}
	if (Rowid=="")
	{
		var InputPara=Date+"^"+LocId+"^"+ResourceId+"^"+TimeDesc+"^"+StartTime+"^"+EndTime+"^"+ServiceGroup+"^"+Max+"^"+AutoNumber+"^"+ChargTime+"^"+EndAppointTime;
		//alert(InputPara);
		$.m({
			ClassName:"DHCDoc.DHCDocCure.RBCResSchdule",
			MethodName:"InsertOneRBCSchedule",
			'Para':InputPara,
			'UserID':session['LOGON.USERID'],
			TimeRangeInfo:TimeRangeInfo
		},function testget(value){
			if(value=="0"){
				$.messager.popover({msg: '保存成功',type:'success',timeout: 3000})
				$("#add-dialog").dialog( "close" );
				LoadCureRBCResSchduleDataGrid();
				return true;							
			}else{
				var err=value
				if ((value==101)) err="该资源同一时段已经排过班次";
				$.messager.alert('提示',"保存失败:"+err,"error");
				return false;
			}
		});
	}else{
		var InputPara=Rowid+"^"+TimeDesc+"^"+StartTime+"^"+EndTime+"^"+ServiceGroup+"^"+Max+"^"+AutoNumber+"^"+ChargTime+"^"+EndAppointTime;
		$.m({
			ClassName:"DHCDoc.DHCDocCure.RBCResSchdule",
			MethodName:"UpdateOneRBCSchedule",
			Para:InputPara,			
			UserID:session['LOGON.USERID'],	
			TimeRangeInfo:TimeRangeInfo		
		},function testget(value){
			if(value=="0"){
				//$.messager.show({title:"提示",msg:"保存成功"});	
				$.messager.popover({msg: '保存成功',type:'success',timeout: 3000})
				$("#add-dialog").dialog( "close" );
				LoadCureRBCResSchduleDataGrid()
				return true;								
			}else{
				var err=value
				if ((value==101)) err="该资源同一时段已经排过班次";
				$.messager.alert('提示',"保存失败:"+err,"error");
				return false;
			}
		});
	}
}
///修改表格函数
function UpdateGridData(){
	var GridId=GetCurrentGrid();
	var rows = $("#"+GridId).datagrid("getSelections");
	if (rows.length ==1) {
		$('#add-dialog').window('open');
		//清空表单数据
		$('#add-form').form("clear")
		$('#LocList').combobox('setValue',rows[0].LocDr)
		var CureResourceListObj=$HUI.combobox("#ResourceList");
		var url = $URL+"?ClassName=DHCDoc.DHCDocCure.Config&QueryName=QueryResource&LocID="+rows[0].LocDr+"&ResultSetType=array";
		CureResourceListObj.clear();
		CureResourceListObj.reload(url);
		CureResourceListObj.setValue(rows[0].ResourceDr);
		var TimeRangeFlag=rows[0].TimeRangeFlag;
		$("#TimeRangeFlag").checkbox("uncheck");
		if(TimeRangeFlag=="Y"){
			$("#TimeRangeFlag").checkbox("check");
		}
		
		$("#TRLength").numberbox("setValue",(rows[0].TRLength));
		$("#ReservedNum").numberbox("setValue",(rows[0].TRReservedNum));
		$('#ServiceGroup').combobox('select',rows[0].ServiceGroupDr);
		$('#TimeDesc').combobox('setValue',rows[0].TimePeriodCode)
		$('#add-form').form("load",{
			Rowid:rows[0].Rowid,
			Date:rows[0].DDCRSDate,
			StartTime:rows[0].StartTime,
			EndTime:rows[0].EndTime,
			Max:rows[0].MaxNumber,
			//AutoNumber:rows[0].AutoNumber,
			EndAppointTime:rows[0].EndAppointTime	 	 
		})
		$('#LocList,#ResourceList').combobox("disable");
		$('#ServiceGroup,#TimeDesc').combobox("disable"); 
		$('#Date').datebox("disable"); 
		LoadTabAppQtyListDataGrid(rows[0].Rowid,"","Sche");
	}else if (rows.length>1){
		$.messager.alert("提示","您选择了多行！",'warning')
	}else{
		$.messager.alert("提示","请选择一行！",'warning')
	}
}

function UpdateScheduleStatus(flag){
	var GridId=GetCurrentGrid();
	var rows = $("#"+GridId).datagrid("getSelections");
    if (rows.length > 0) {
	    if(flag=="C"){var msg="是否确定要撤销停诊?"}
		if(flag=="S"){
			var msg="是否确定要停诊?";
			var ObjScope=$.cm({
				ClassName:"DHCDoc.DHCDocCure.Appointment",
				MethodName:"GetRBCResSchduleAppedNum",
				'RBASId':rows[0].Rowid,
				'JSONType':"JSON",
			},false);
			var value=ObjScope.result;
			if(value>0){
				var msg="该资源存在预约记录,是否确定要停诊?";	
			}
		};
        $.messager.confirm("提示", msg,
        function(r) {
            if (r) {
				var ids = [];
                for (var i = 0; i < rows.length; i++) {
                    ids.push(rows[i].Rowid);
                }
                var ID=ids.join(',')
				$.m({
					ClassName:"DHCDoc.DHCDocCure.RBCResSchdule",
					MethodName:"StopOneRBCSchedule",
					'ASRowID':ID,
					'UserID':session['LOGON.USERID'],
					'StopFlag':flag
				},function testget(value){
			        if(value=="0"){
				    	LoadCureRBCResSchduleDataGrid();
				       	$.messager.popover({msg: '操作成功',type:'success',timeout: 3000})
			        }else if(value=="-1"){
				        $.messager.alert('提示',"排班已经是停诊状态,无需停诊",'error');
				    }else if(value=="-2"){
				        $.messager.alert('提示',"排班非停诊状态,无需撤销停诊",'error');
				    }else if(value=="101"){
				        $.messager.alert('提示',"执行失败:"+"存在有效的相同记录,无法撤销停诊",'error');
				    }else{
				       	$.messager.alert('提示',"执行失败:"+value,'error');
			        }
			   });
            }
        });
    } else {
	    if(flag=="C"){
			$.messager.alert("提示", "请选择需要撤销停诊的记录.", "warning");    
		}else{
        	$.messager.alert("提示", "请选择需要停诊的记录.", "warning");
		}
    }		
}

function CheckComboxSelData(id,selId){
	var Find=0;
	var Data=$("#"+id).combobox('getData');
	for(var i=0;i<Data.length;i++){
		if ((id=="LocName")||(id=="LocList")){
			var CombValue=Data[i].LocId;
			var CombDesc=Data[i].LocDesc;
		}else if ((id=="Resource")||(id=="ResourceList")){
			var CombValue=Data[i].TRowid;
			var CombDesc=Data[i].TResDesc;
		}else{
			var CombValue=Data[i].Rowid  
			var CombDesc=Data[i].Desc
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

function TimeInterSearch(){
	clearTimeout(PageLogicObj.m_SearchClickTimer);
	PageLogicObj.m_SearchClickTimer=setTimeout("SearchClick()",100)
}

function SearchClick(){
	var StartDate=$("#BookDate").datebox("getValue"); 
	var tabs = $("#ScheduleTab").tabs("tabs");
    $('#ScheduleTab').tabs({
		onSelect:function (){
		}
	})
	var length = tabs.length;
	for(var i = 0; i < length; i++) {
	    var onetab = tabs[0];
	    var title = onetab.panel('options').tab.text();
	    $("#ScheduleTab").tabs("close", title);
	}
	InitScheduleTab(StartDate) ;	
}

function InitScheduleTab(StartDate){
	if(StartDate=="")return;
	var AdmDateStr=tkMakeServerCall("DHCDoc.DHCDocCure.RBCResSchdule","GetScheduleDateStr",StartDate)
	var AdmDateStrArr=AdmDateStr.split("^")
	for(var i=0;i<AdmDateStrArr.length;i++){
		var admDate=AdmDateStrArr[i].split(String.fromCharCode(1))[0]
		$("#ScheduleTab").tabs("add",{
			title:admDate,
			content:'Tab Body'
		})
	}
	$('#ScheduleTab').tabs({
		heigth:'auto',
		onSelect: function(title,index){
			SelectScheduleTab(title,index);
		}
	})
}
function SelectScheduleTab(title,index){
	if("undefined"==typeof index)index=PageLogicObj.m_ScheduleTabIndex;
	if("undefined"==typeof title){
		var StartDate=PageLogicObj.m_TalStartDate;
	}else{
		var StartDate=title.split("(")[0];
	}
	var CurrentTabPanel=$('#ScheduleTab').tabs("getSelected");
	var TemplateTable=$('<table id="ScheduleGrid'+index+'"></table>');
	CurrentTabPanel.html(TemplateTable);
	PageLogicObj.m_TalStartDate=StartDate ;
	InitCureRBCResSchduleDataGrid("ScheduleGrid"+index,CurrentTabPanel.height());
	clearTimeout(PageLogicObj.m_SchduleDataGridLoadTimer);
	PageLogicObj.m_SchduleDataGridLoadTimer=setTimeout("LoadCureRBCResSchduleDataGrid('ScheduleGrid"+index+"','"+StartDate+"')",100)
	PageLogicObj.m_ScheduleTabIndex=index;
	//$("#ScheduleTab").tabs("select",PageLogicObj.m_ScheduleTabIndex)	
}

function InitCureRBCResSchduleDataGrid(GridId,height)
{  
	var CureRBCResSchduleToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() {
                $('#add-dialog').window('open');
	 			//清空表单数据
	 		  	$('#add-form').form("clear");
	 		  	$('#LocList,#ResourceList,#ServiceGroup,#TimeDesc').combobox("select","")
	 		  	.combobox("enable")
	 		  	.combobox("validate");
	 			$('#Date').datebox("setValue",PageLogicObj.m_TalStartDate).datebox("enable");
	 		  	if(ServerObj.ToLocFlag=="Y"){
					var data=$("#LocList").combobox("getData");
					for(var i=0;i<data.length;i++){
				    	if(data[i].LocId==PageLogicObj.m_LogLocID){
					    	$("#LocList").combobox("select",PageLogicObj.m_LogLocID).combobox("disable");
					    }
				    }
				}	
				$("#TimeRangeFlag").checkbox("uncheck");
				$("#TRLength").numberbox("setValue","");
				$("#ReservedNum").numberbox("setValue","");
				ChangeTREleStyle(false);
            }
        },{
            text: '停诊',
            id:GridId+"-stopsch",
            iconCls: 'icon-unuse',
            handler: function() {
	            UpdateScheduleStatus("S");               
            }
        },{
            text: '撤销停诊',
            id:GridId+"-cancelstopsch",
            iconCls: 'icon-ok',
            handler: function() {
	            UpdateScheduleStatus("C");               
            }
        },{
			text: '修改',
			iconCls: 'icon-write-order',
			handler: function() {
			  	UpdateGridData();
			}
		}];
	var CureRBCResSchduleColumns=[[    
			{ field: 'Rowid', title: 'ID', width: 1,hidden:true
			}, 
			//{ field: 'DDCRSDate', title:'日期', width: 100, sortable: true, resizable: true  
			//},
			{ field: 'LocDesc', title:'科室', width: 180, resizable: true  
			},
			{ field: 'ResourceDesc', title: '资源', width: 120, resizable: true
			},
			{ field: 'TimeDesc', title: '时段', width: 80, resizable: true
			},
			{ field: 'StartTime', title: '开始时间', width: 80,resizable: true
			},
			{ field: 'EndTime', title: '结束时间', width: 80,resizable: true
			},
			{ field: 'EndAppointTime', title: '截止预约时间', width: 80,resizable: true
			},
			{ field: 'ServiceGroupDesc', title: '服务组', width: 100,resizable: true
			},
			{ field: 'DDCRSStatus', title: '状态', width: 80,resizable: true
			},
			{ field: 'MaxNumber', title: '最大预约数', width: 80,resizable: true
			},
			{ field: 'TimeRangeFlag', title: '分时段', width: 80,resizable: true
			},
			//{ field: 'AutoNumber', title: '自动预约数', width: 80, sortable: true,resizable: true
			//},
			//{ field: 'ChargeTime', title: '截止缴费时间', width: 100, sortable: true,resizable: true
			//}
			/*,
			{ field: 'AvailPatType', title: '可用类型', width: 20, sortable: true,resizable: true
			},
			{ field: 'AutoAvtiveFlag', title: '自动预约启用开关', width: 20, sortable: true
			},*/
			{ field: 'LocDr', title: 'LocDr', width: 1,hidden:true
			}, 
			{ field: 'ResourceDr', title: 'ResourceDr', width: 1,hidden:true
			}, 
			{ field: 'TimePeriodCode', title: 'TimePeriodCode', width: 1,hidden:true
			}, 
			{ field: 'ServiceGroupDr', title: 'ServiceGroupDr', width: 1,hidden:true
			}
		]];
	
	$('#'+GridId).datagrid({ 
		fit:true,
		width:'auto',
		border:false,
		remoteSort:false,
		striped:true,
		singleSelect:true,
		autoRowHeight:true,
		fitColumns : true,
		height:height,
		loadMsg:'正在加载',
		rownumbers:true,
		idField:"Rowid",
		//pageSize:10,
		//pageList : [10,20,50],
		columns :CureRBCResSchduleColumns,
		toolbar:CureRBCResSchduleToolBar,
		onClickRow:function(rowIndex, rowData){
			if (rowData.DDCRSStatus=="正常"){
				$("#"+GridId+"-cancelstopsch").linkbutton("disable")
				$("#"+GridId+"-stopsch").linkbutton("enable")
			}else{
				$("#"+GridId+"-stopsch").linkbutton("disable")
				$("#"+GridId+"-cancelstopsch").linkbutton("enable")
			}
		},
		onDblClickRow:function(rowIndex, rowData){ 
		 	UpdateGridData();	
       	},
		rowStyler:function(rowIndex, rowData){
 			if (rowData.DDCRSStatus!="正常"){
	 			return 'color:#788080;';
	 		}
		},
		onLoadSuccess:function(data){
			UpdateScheTabStyle(GridId);
		}
	});
}
function UpdateScheTabStyle(tabId){
	$(".tabItem_badge").remove();
	var opts=$("#"+tabId).datagrid("options");
	var queryParams=opts.queryParams;
	var ArgCnt=queryParams.ArgCnt;
	var obj={};
	for (var i=0;i<ArgCnt;i++) {
		var ArgN="Arg"+(i+1);
		obj[ArgN]=queryParams[ArgN];
	}
	var FirstTab = $('#ScheduleTab').tabs('getTab',0);
	var FirstTabTitle=FirstTab.panel("options").title;
	var FirstTabDate=FirstTabTitle.split("(")[0];
	var AdmDateStr=tkMakeServerCall("DHCDoc.DHCDocCure.RBCResSchdule","GetScheduleDateStr",FirstTabDate,JSON.stringify(obj))
	var AdmDateStrArr=AdmDateStr.split("^");
	for(var i=0;i<AdmDateStrArr.length;i++){
		var admDate=AdmDateStrArr[i].split(String.fromCharCode(1))[0];
		var ExistScheduleFlag=AdmDateStrArr[i].split(String.fromCharCode(1))[1];
		if (ExistScheduleFlag==1){
			$($("#ScheduleTab .tabs li a")[i]).append('<sup class="tabItem_badge"></sup>');
		}
	}
}

function LoadCureRBCResSchduleDataGrid(GridId,StartDate)
{
	if("undefined"==typeof GridId)GridId="ScheduleGrid"+PageLogicObj.m_ScheduleTabIndex;
	if("undefined"==typeof StartDate)StartDate=PageLogicObj.m_TalStartDate;
	var CureLocName=$('#LocName').combobox('getValue');
	var CureLocName=CheckComboxSelData("LocName",CureLocName);
	var CureResource=$('#Resource').combobox('getValue');
	var CureResource=CheckComboxSelData("Resource",CureResource);
	var CureBookDate=StartDate;
	var CureBookEndDate=StartDate;
	var ResGroupID=$('#ResGroup').combobox('getValue');
	var ResGroupID=CheckComboxSelData("ResGroup",ResGroupID);
	var UserHospID=Util_GetSelHospID();
	$("#"+GridId).datagrid("unselectAll");
	var queryParams = new Object();
		queryParams.ClassName ='DHCDoc.DHCDocCure.RBCResSchdule';
		queryParams.QueryName ='QueryResApptSchdule';
		queryParams.Arg1 =CureLocName;
		queryParams.Arg2 =CureResource;
		queryParams.Arg3 =CureBookDate;
		queryParams.Arg4 =ResGroupID;
		queryParams.Arg5 =CureBookEndDate;
		queryParams.Arg6 =UserHospID;
		queryParams.ArgCnt = 6;
		
		var opts = $("#"+GridId).datagrid("options");
		opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
		$("#"+GridId).datagrid('load', queryParams); 
}
function GetCurrentGrid(){
	var tab = $('#ScheduleTab').tabs('getSelected');
	var index = $('#ScheduleTab').tabs('getTabIndex',tab);
	var GridId="ScheduleGrid"+index;
	return GridId;
}

function ReLoadComboDoc(ele)
{
	$('#'+ele).combobox('reload',$URL+"?ClassName=DHCDoc.DHCDocCure.Config&QueryName=QueryResource&LocID="+"&ResultSetType=array"); 
}

function ShowScheduleListWin(){
	var dhwid=$(document.body).width()-60;
	var dhhei=$(document.body).height()-100;
	if(ServerObj.ToLocFlag!="Y"){
		$("#Loc_Search").combobox('setValue',"");
		ReLoadComboDoc("Doc_Search");
	}
	$("#Week_Search,#Doc_Search").combobox('setValue',"");
	$('#schedulelist-dialog').window('open').window('resize',{width:dhwid,height:dhhei,top: 50,left:30});
	$HUI.datebox('#SttDate_Search').setValue(ServerObj.CurrDate);
	$HUI.datebox('#EndDate_Search').setValue(ServerObj.CurrDate);
	var DataGrid=$('#tabCureScheduleList').datagrid({  
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
		url : $URL+'?ClassName=DHCDoc.DHCDocCure.RBCResSchdule&QueryName=QueryResApptSchdule&rows=9999',
		loadMsg : '加载中..',  
		pagination : true,
		rownumbers : true,
		idField:"Rowid",
		pageSize : 20,
		pageList : [20,50],
		columns :[[   
			{ field: 'RowCheck',checkbox:true},     
			{ field: 'Rowid', title: 'ID', width: 1, align: 'left',hidden:true
			}, 
			{ field: 'DDCRSDate', title:'日期', width: 120, align: 'left', resizable: true  
			},
			{ field: 'LocDesc', title:'科室', width: 180, align: 'left', resizable: true  
			},
			{ field: 'ResourceDesc', title: '资源', width: 120, align: 'left', resizable: true
			},
			{ field: 'TimeDesc', title: '时段', width: 100, align: 'left', resizable: true
			},
			{ field: 'StartTime', title: '开始时间', width: 80, align: 'left',resizable: true
			},
			{ field: 'EndTime', title: '结束时间', width: 80, align: 'left',resizable: true
			},
			{ field: 'ServiceGroupDesc', title: '服务组', width: 120, align: 'left',resizable: true
			},
			{ field: 'DDCRSStatus', title: '状态', width: 80, align: 'left',resizable: true
			},
			{ field: 'AppedNumber', title: '已预约数', width: 100, align: 'left',resizable: true,
				formatter:function(value,row,index){
					value=parseFloat(value);
					if(value>0){
						return "<span class='fillspan-nonenum'>"+value+"</span>";	
					}else{
						return "<span class='fillspan-fullnum'>"+value+"</span>";	
					}
				}
			},
			{ field: 'MaxNumber', title: '最大预约数', width: 100, align: 'left',resizable: true
			},
			{ field: 'AppedLeftNumber', title: '剩余可预约数', width: 100, align: 'left',resizable: true
			}
		 ]],
		 toolbar : [{
			id:'BtnGenStop',
			text:'停诊',
			iconCls:'icon-unuse',
			handler:function(){
				var rows = PageLogicObj.m_CureScheduleListDataGrid.datagrid("getSelections");
				var length=rows.length;
				if(length==0){
					$.messager.alert("提示", "请选择需要停诊的资源排程.", "warning");	
					return false;
				}
				$.messager.confirm('确认',"是否确认停诊?",function(r){
					if (r){
						var ids = [];
						for (var i = 0; i < length; i++) {
							ids.push(rows[i].Rowid);
						}
						var IDStr=ids.join("^");
						var ret=$.cm({
							ClassName:"DHCDoc.DHCDocCure.RBCResSchdule",
							MethodName:"StopRBCSchedule",
							ASRowIDStr:IDStr,
							UserID:session['LOGON.USERID'],
							StopFlag:"S",
							dataType:"text"
						},false);
						if(ret!=""){
							$.messager.alert("提示", ret, "warning");
						}else{
							$.messager.popover({msg: '操作成功！',type:'success',timeout: 3000});
							PageLogicObj.m_CureScheduleListDataGrid.datagrid("reload");
						}
					}
				})
			}
		},{
			id:'BtnGenDelete',
			text:'删除',
			iconCls:'icon-remove',
			handler:function(){
				var rows = PageLogicObj.m_CureScheduleListDataGrid.datagrid("getSelections");
				var length=rows.length;
				if(length==0){
					$.messager.alert("提示", "请选择需要删除的资源排程.", "warning");	
					return false;
				}
				$.messager.confirm('确认',"是否确认删除?",function(r){
					if (r){
						var ids = [];
						for (var i = 0; i < length; i++) {
							ids.push(rows[i].Rowid);
						}
						var IDStr=ids.join("^");
						var ret=$.cm({
							ClassName:"DHCDoc.DHCDocCure.RBCResSchdule",
							MethodName:"DeleteRBCSchedule",
							ASRowIDStr:IDStr,
							dataType:"text"
						},false);
						if(ret!=""){
							$.messager.alert("提示", ret, "warning");
						}else{
							$.messager.popover({msg: '操作成功！',type:'success',timeout: 3000});
							PageLogicObj.m_CureScheduleListDataGrid.datagrid("reload");
						}
					}
				})
			}
		}],
		onBeforeLoad:function(param){
			var UserHospID=Util_GetSelHospID();
			var SearchLocID=$HUI.combobox('#Loc_Search').getValue();
			var SearchDocID=$HUI.combobox('#Doc_Search').getValue();
			var SearchWeekID=$HUI.combobox('#Week_Search').getValue();
			var StartDate=$HUI.datebox('#SttDate_Search').getValue();
			var EndDate=$HUI.datebox('#EndDate_Search').getValue();
			$.extend(param,{LocId:SearchLocID,ResourceId:SearchDocID,BookStartDate:StartDate,BookEndDate:EndDate,HospID:UserHospID,WeekID:SearchWeekID});
		},onClickRow: function(rowIndex, rowData){
			var RowObj=$(this).parent().find("div .datagrid-cell-check")
            .children("input[type=\"checkbox\"]");
		    RowObj.each(function(index, el){
		        if (el.style.display == "none") {
		            PageLogicObj.m_CureScheduleListDataGrid.datagrid('unselectRow', index);
		        }
		    })
		},onBeforeSelect:function(rowIndex, rowData){
			
		},onBeforeCheck:function(rowIndex, rowData){
			
		},onLoadSuccess:function(data){
			$(this).datagrid("clearSelections").datagrid("clearChecked");
			var headchkobj=$(this).parent().find("div .datagrid-header-check")
            .children("input[type=\"checkbox\"]").eq(0);
        	headchkobj.attr("style", "display:none;");
        	
			var RowObj=$(this).parent().find("div .datagrid-cell-check")
            .children("input[type=\"checkbox\"]");
		    for (var i = 0; i < data.rows.length; i++) {
		        if (data.rows[i].AppedNumber>0) {
		            RowObj.eq(i).attr("style", "display:none");
		        }
		    }
		}
	});
	PageLogicObj.m_CureScheduleListDataGrid=DataGrid;
	//CureAppScheduleListDataGridLoad();
}
function InitWeekSearch(){
	$HUI.combobox('#Week_Search',{ 
		valueField:'WeekId',   
		textField:'WeekName',
		url:$URL+"?ClassName=DHCDoc.DHCDocCure.RBCResPlan&QueryName=QueryWeek&ResultSetType=array",
		onSelect:function(record){
		} 
	});
}