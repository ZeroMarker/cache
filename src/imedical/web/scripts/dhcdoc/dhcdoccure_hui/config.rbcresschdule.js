var CureRBCResSchduleDataGrid;
var CureResourceObj;
var CureResourceListObj;
var CureTimeDescListObj;
var CureServiceGroupListObj;
$(document).ready(function(){
	//Init();
	InitHospList();
	InitEvent();	
});	

function InitHospList(){
	var hospStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	var hospComp = GenHospComp("Doc_Cure_Schedule",hospStr);
	hospComp.jdata.options.onSelect = function(e,t){
		if (!CheckDocCureUseBase()){
			return;
		}
		Init();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		if (!CheckDocCureUseBase()){
			return;
		}
		Init();
	}
}
function CheckDocCureUseBase(){
	var UserHospID=Util_GetSelHospID();
	var DocCureUseBase=$.m({
		ClassName:"web.DHCDocConfig",
		MethodName:"GetConfigNode",
		Node: "DocCureUseBase",
		HospId:UserHospID,
		dataType:"text",
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
	$HUI.combobox("#LocName", {});
	InitLoc("LocName",CureResourceObj);
	InitDate();
	InitCureRBCResSchdule();
	InitWinComb();
}
function InitDate(){
    var CurDay=$.cm({
		ClassName:"DHCDoc.DHCDocCure.Common",
		MethodName:"DateLogicalToHtml",
		'h':"",
		dataType:"text"   
	},false);
    $("#BookDate,#BookEndDate").datebox('setValue',CurDay);		
}

function InitLoc(parame,obj){
	var HospDr=Util_GetSelHospID();
    $.cm({
		ClassName:"DHCDoc.DHCDocCure.Config",
		QueryName:"QueryCureLoc",		
		HospID:	HospDr,
		dataType:"json",
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#"+parame+"", {
				valueField: 'LocId',
				textField: 'LocDesc', 
				editable:true,
				data: Data["rows"],
				filter: function(q, row){
					return (row["LocDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["LocContactName"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},onSelect:function(record){
					var locId=record.LocId;
					var url = $URL+"?ClassName=DHCDoc.DHCDocCure.Config&QueryName=QueryResource&LocID="+locId+"&ResultSetType=array";
					obj.clear();
					obj.reload(url);			
				}  
		 });
	});
}


function InitEvent(){
	$('#btnSave').bind('click', function(){
		if(!SaveFormData())return false;
	});
	$('#btnFind').bind('click', function(){
		var LocName=$('#LocName').combobox('getValue');
		var Resource=$('#Resource').combobox('getValue');
		var LocName=CheckComboxSelData("LocName",LocName);
		if (LocName==""){
			$.messager.alert("提示", "请选择科室", 'error')
			return false;	
		}
		LoadCureRBCResSchduleDataGrid();
	});  
}
function InitCureRBCResSchdule()
{
	var CureRBCResSchduleToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() {
                //$("#add-dialog").dialog("open");
                $('#LocList').combobox("enable")
	 			$('#ResourceList').combobox("enable")
	 			$('#TimeDesc').combobox("enable") 
	 			$('#Date').datebox("enable") 
                $('#add-dialog').window('open').window('resize',{width:300,height:450,top: 10,left:400});
	 			//清空表单数据
	 		  	$('#add-form').form("clear")  
            }
        },{
            text: '停诊',
            id:"stopsch",
            iconCls: 'icon-unuse',
            handler: function() {
	            UpdateScheduleStatus("S");               
            }
        },{
            text: '撤销停诊',
            id:"cancelstopsch",
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
                    { field: 'Rowid', title: 'ID', width: 1, sortable: true,hidden:true
					}, 
					{ field: 'DDCRSDate', title:'日期', width: 100, sortable: true, resizable: true  
					},
					{ field: 'LocDesc', title:'科室', width: 180, sortable: true, resizable: true  
					},
        			{ field: 'ResourceDesc', title: '资源', width: 120, sortable: true, resizable: true
					},
					{ field: 'TimeDesc', title: '时段', width: 80, sortable: true, resizable: true
					},
					{ field: 'StartTime', title: '开始时间', width: 80, sortable: true,resizable: true
					},
					{ field: 'EndTime', title: '结束时间', width: 80, sortable: true,resizable: true
					},
					{ field: 'ServiceGroupDesc', title: '服务组', width: 100, sortable: true,resizable: true
					},
					{ field: 'DDCRSStatus', title: '状态', width: 80, sortable: true,resizable: true
					},
					{ field: 'MaxNumber', title: '最大预约数', width: 80, sortable: true,resizable: true
					},
					//{ field: 'AutoNumber', title: '自动预约数', width: 80, sortable: true,resizable: true
					//},
					{ field: 'ChargeTime', title: '截止缴费时间', width: 100, sortable: true,resizable: true
					}
					/*,
					{ field: 'AvailPatType', title: '可用类型', width: 20, sortable: true,resizable: true
					},
					{ field: 'AutoAvtiveFlag', title: '自动预约启用开关', width: 20, sortable: true
					}*/,
					{ field: 'LocDr', title: 'LocDr', width: 1, sortable: true,hidden:true
					}, 
					{ field: 'ResourceDr', title: 'ResourceDr', width: 1, sortable: true,hidden:true
					}, 
					{ field: 'TimePeriodCode', title: 'TimePeriodCode', width: 1, sortable: true,hidden:true
					}, 
					{ field: 'ServiceGroupDr', title: 'ServiceGroupDr', width: 1, sortable: true,hidden:true
					}
    			 ]];
	CureRBCResSchduleDataGrid=$('#tabCureRBCResSchdule').datagrid({  
		fit : true,
		//width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		//url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"Rowid",
		pageSize:15,
		pageList : [15,50,100],
		columns :CureRBCResSchduleColumns,
		toolbar:CureRBCResSchduleToolBar,
		onClickRow:function(rowIndex, rowData){
			if (rowData.DDCRSStatus=="正常"){
				$("#cancelstopsch").linkbutton("disable")
				$("#stopsch").linkbutton("enable")
			}else{
				$("#stopsch").linkbutton("disable")
				$("#cancelstopsch").linkbutton("enable")
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
	});
	LoadCureRBCResSchduleDataGrid(true);
}
function LoadCureRBCResSchduleDataGrid(init)
{
	var CureLocName=$('#LocName').combobox('getValue');
	var CureLocName=CheckComboxSelData("LocName",CureLocName);
	var CureResource=$('#Resource').combobox('getValue');
	var CureResource=CheckComboxSelData("Resource",CureResource);
	var CureBookDate=$('#BookDate').datebox('getValue');
	var CureBookEndDate=$('#BookEndDate').datebox('getValue');
	if((CureLocName=="")&&(!init)){
		$.messager.alert('提示','请选择科室');   
        return false;	
	}
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.RBCResSchdule",
		QueryName:"QueryResApptSchdule",
		'LocId':CureLocName,
		'ResourceId':CureResource,
		'BookStartDate':CureBookDate,
		'ResGroupID':"",
		'BookEndDate':CureBookEndDate,
		Pagerows:CureRBCResSchduleDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		CureRBCResSchduleDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
		CureRBCResSchduleDataGrid.datagrid('unselectAll');
	})
}
function InitWinComb(){
	var HospDr=Util_GetSelHospID();
	//资源列表
	var CureResourceListObj=$HUI.combobox('#ResourceList',{     
		valueField:'TRowid',   
		textField:'TResDesc'   
	});
	//科室列表
	var CureLocListObj=$HUI.combobox('#LocList',{});
	InitLoc("LocList",CureResourceListObj);
	
  	//时段列表
	var CureTimeDescListObj=$HUI.combobox('#TimeDesc',{ 
		valueField:'Rowid',   
		textField:'Desc',
		url:$URL+"?ClassName=DHCDoc.DHCDocCure.RBCResPlan&QueryName=QueryBookTime&HospID="+HospDr+"&ResultSetType=array",
		onSelect:function(record){
			var Rowid=record.Rowid;
			var StartTime=record.StartTime;
			var EndTime=record.EndTime;
			var EndChargTime=record.EndChargTime;
			$("#StartTime").val(StartTime);
			$("#EndTime").val(EndTime);
			$("#ChargTime").val(EndChargTime);
			/*$.m({
				ClassName:"DHCDoc.DHCDocCure.RBCTimePeriodSet",
				MethodName:"GetCureRBCTimePeriodSetById",
				'Id':Rowid,
			},function(objScope){
				if (objScope=="") return;
				var TempArr=objScope.split("^");
				$("#StartTime").val(TempArr[2]);
				$("#EndTime").val(TempArr[3]);
				$("#ChargTime").val(TempArr[4]);
			})*/			
		} 
	});
	//星期列表
	var CureWeekListObj=$HUI.combobox('#Week',{
		valueField:'WeekId',   
		textField:'WeekName',
		url:$URL+"?ClassName=DHCDoc.DHCDocCure.RBCResPlan&QueryName=QueryWeek&ResultSetType=array",
	});
	//服务组列表
	var CureServiceGroupListObj=$HUI.combobox('#ServiceGroup',{
		valueField:'Rowid',   
		textField:'Desc',
		url:$URL+"?ClassName=DHCDoc.DHCDocCure.RBCServiceGroupSet&QueryName=QueryServiceGroup&HospID="+HospDr+"&ResultSetType=array",
	});	
}
function CheckData(){
	var Date=$('#Date').datebox('getValue');
	if(Date=="")
	{
		$.messager.alert('Warning','请选择日期');   
        return false;
	}
	var LocId=$('#LocList').combobox('getValue');
	var LocId=CheckComboxSelData("LocList",LocId);
	if(LocId=="")
	{
		 $.messager.alert("错误", "请选择科室", 'error')
        return false;
	}
	var ResourceId=$('#ResourceList').combobox('getValue');
	var ResourceId=CheckComboxSelData("ResourceList",ResourceId);
	if(ResourceId=="")
	{
		 $.messager.alert("错误", "请选择资源", 'error')
        return false;
	}
	var TimeDesc=$('#TimeDesc').combobox('getValue');
	var TimeDesc=CheckComboxSelData("TimeDesc",TimeDesc);
	if(TimeDesc=="")
	{
		$.messager.alert('Warning','请选择时段');   
        return false;
	}
	var ServiceGroup=$('#ServiceGroup').combobox('getValue');
	var ServiceGroup=CheckComboxSelData("ServiceGroup",ServiceGroup);
	if(ServiceGroup=="")
	{
		$.messager.alert('Warning','请选择服务组');   
        return false;
	}
	var StartTime=$("#StartTime").val();
	if(StartTime=="")
	{
		$.messager.alert('Warning','请填写开始时间');   
        return false;
	}
	var EndTime=$("#EndTime").val();
	if(EndTime=="")
	{
		$.messager.alert('Warning','请填写结束时间');   
        return false;
	}
	var Max=$("#Max").val();
	if(Max=="")
	{
		$.messager.alert('Warning','请填写最大预约数');   
        return false;
	}
	var Max=parseFloat(Max);
	if(Max<=0){
		$.messager.alert("提示","预约数请填写大于0整数");
		return false;		
	}
	var AutoNumber="" //$("#AutoNumber").val();
	if ((+AutoNumber!=0)&&(parseInt(AutoNumber)>parseInt(Max))){
		$.messager.alert('Warning','自动预约数不能大于最大预约数');   
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
	var ChargTime=$("#ChargTime").val();
	if (Rowid=="")
	{
		var InputPara=Date+"^"+LocId+"^"+ResourceId+"^"+TimeDesc+"^"+StartTime+"^"+EndTime+"^"+ServiceGroup+"^"+Max+"^"+AutoNumber+"^"+ChargTime;
		//alert(InputPara);
		$.m({
			ClassName:"DHCDoc.DHCDocCure.RBCResSchdule",
			MethodName:"InsertOneRBCSchedule",
			'Para':InputPara,
			'UserID':session['LOGON.USERID'],
			'hisui':"1",
		},function testget(value){
			if(value=="0"){
				$.messager.show({title:"提示",msg:"保存成功"});	
				$("#add-dialog").dialog( "close" );
				LoadCureRBCResSchduleDataGrid(true);
				return true;							
			}else{
				var err=value
				if ((value==101)) err="该资源同一时段已经排过班次";
				$.messager.alert('提示',"保存失败:"+err);
				return false;
			}
		});
	}else{
		var InputPara=Rowid+"^"+TimeDesc+"^"+StartTime+"^"+EndTime+"^"+ServiceGroup+"^"+Max+"^"+AutoNumber+"^"+ChargTime;
		$.m({
			ClassName:"DHCDoc.DHCDocCure.RBCResSchdule",
			MethodName:"UpdateOneRBCSchedule",
			'Para':InputPara,
			'UserID':session['LOGON.USERID'],			
		},function testget(value){
			if(value=="0"){
				$.messager.show({title:"提示",msg:"保存成功"});	
				$("#add-dialog").dialog( "close" );
				LoadCureRBCResSchduleDataGrid()
				return true;								
			}else{
				var err=value
				if ((value==101)) err="该资源同一时段已经排过班次";
				$.messager.alert('提示',"保存失败:"+err);
				return false;
			}
		});
	}
}
///修改表格函数
function UpdateGridData(){
	var rows = CureRBCResSchduleDataGrid.datagrid('getSelections');
	if (rows.length ==1) {
		//$("#add-dialog").dialog("open");
		$('#add-dialog').window('open').window('resize',{width:300,height:450,top: 10,left:400});
		//清空表单数据
		$('#add-form').form("clear")
		$('#LocList').combobox('setValue',rows[0].LocDr)
		var CureResourceListObj=$HUI.combobox("#ResourceList");
		var url = $URL+"?ClassName=DHCDoc.DHCDocCure.Config&QueryName=QueryResource&LocID="+rows[0].LocDr+"&ResultSetType=array";
		CureResourceListObj.clear();
		CureResourceListObj.reload(url);
		CureResourceListObj.setValue(rows[0].ResourceDr);
		$('#TimeDesc').combobox('setValue',rows[0].TimePeriodCode)
		$('#ServiceGroup').combobox('setValue',rows[0].ServiceGroupDr)
		$('#add-form').form("load",{
			Rowid:rows[0].Rowid,
			Date:rows[0].DDCRSDate,
			StartTime:rows[0].StartTime,
			EndTime:rows[0].EndTime,
			Max:rows[0].MaxNumber,
			//AutoNumber:rows[0].AutoNumber,
			ChargTime:rows[0].ChargeTime	 	 
		})
		$('#LocList').combobox("disable")
		$('#ResourceList').combobox("disable")
		$('#TimeDesc').combobox("disable") 
		$('#Date').datebox("disable")    
	}else if (rows.length>1){
		$.messager.alert("错误","您选择了多行！",'err')
	}else{
		$.messager.alert("错误","请选择一行！",'err')
	}
}

function UpdateScheduleStatus(flag){
	
	var rows = CureRBCResSchduleDataGrid.datagrid("getSelections");
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
					'UserID':session['LOGON.USERID']
				},function testget(value){
			        if(value=="0"){
				    	//CureRBCResSchduleDataGrid.datagrid('load');
				    	LoadCureRBCResSchduleDataGrid();
				       	$.messager.show({title:"提示",msg:"执行成功"});
			        }else if(value=="101"){
				        $.messager.alert('提示',"执行失败:"+"存在有效的相同记录,无法撤销停诊");
				    }else{
				       	$.messager.alert('提示',"执行失败:"+value);
			        }
			   });
            }
        });
    } else {
        $.messager.alert("提示", "请选择要停诊的行", "error");
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