var CureRBCResPlanDataGrid;
var CureWeekListObj;
var CureTimeDescListObj;
var CureServiceGroupListObj;
var CureResourceListObj;
$(document).ready(function(){
	//Init();
	InitHospUser()
 	InitEvent();
});	

function InitHospUser(){
	var hospStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	var hospComp = GenHospComp("Doc_Cure_SchePlan",hospStr);
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
		textField:'TResDesc',
		onSelect:function(){
			LoadCureRBCResPlanDataGrid();		
		}
	});
	//科室列表
	InitLoc("LocName",CureResourceObj);
	
	InitCureRBCResPlan();	
	InitWinComb();
}

function InitEvent(){
	$('#btnSave').bind('click', function(){
		if(!SaveFormData())return false;
	});
	$('#btnImport').click(ImportTemplate);
	$('#btnFind').bind('click', function(){
		var LocName=$('#LocName').combobox('getValue');
		var Resource=$('#Resource').combobox('getValue');
		if (LocName==""){
			$.messager.alert("提示", "请选择科室!", 'warning')
			return false;	
		}
		LoadCureRBCResPlanDataGrid();
	});
	$('#btnGenByLoc').click(function(){
		CreateResApptSchuldeByLoc();
	});	
	$('#btnGen').click(function(){
		CreateResApptSchulde();
	});	
}

function ImportTemplate(){
	var src="doccure.rbcresplan.import.hui.csp";
	if(typeof websys_writeMWToken=='function') src=websys_writeMWToken(src);
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("importDiag","导入", 850, 545,"icon-w-import","",$code,"");
}

function InitLoc(parame,Obj){
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
					Obj.clear();
					Obj.reload(url);
					LoadCureRBCResPlanDataGrid();				
				}  
		 });
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
	
	//星期列表
	var CureWeekListObj=$HUI.combobox('#Week',{
		valueField:'WeekId',   
		textField:'WeekName',
		url:$URL+"?ClassName=DHCDoc.DHCDocCure.RBCResPlan&QueryName=QueryWeek&ResultSetType=array",
	});
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
			$HUI.timespinner("#StartTime").disable();
			$HUI.timespinner("#EndTime").disable();
			$HUI.timespinner("#ChargTime").disable();
			/*
			$.m({
				ClassName:"DHCDoc.DHCDocCure.RBCTimePeriodSet",
				MethodName:"GetCureRBCTimePeriodSetById",
				'Id':Rowid,
			},function(objScope){
				if (objScope=="") return;
				var TempArr=objScope.split("^");
				$("#StartTime").val(TempArr[2]);
				$("#EndTime").val(TempArr[3]);
				$("#ChargTime").val(TempArr[4]);
				//$('#StartTime').timespinner("disable")
				//$('#EndTime').timespinner("disable")
				//$('#ChargTime').timespinner("disable")
				var SObj=$HUI.timespinner("#StartTime").disable();
				var EObj=$HUI.timespinner("#EndTime").disable();
				var CObj=$HUI.timespinner("#ChargTime").disable();
			})	*/		
		} 
	});
	//服务组列表
	var CureServiceGroupListObj=$HUI.combobox('#ServiceGroup',{
		valueField:'Rowid',   
		textField:'Desc',
		url:$URL+"?ClassName=DHCDoc.DHCDocCure.RBCServiceGroupSet&QueryName=QueryServiceGroup&HospID="+HospDr+"&ResultSetType=array",
	});	
}
function CheckData(){
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
	var Week=$('#Week').combobox('getValue');
	var Week=CheckComboxSelData("Week",Week);
	if(Week=="")
	{
		$.messager.alert('提示','请选择星期', 'warning');   
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
		$.messager.alert('提示','请选择服务组',"warning");   
        return false;
	}
	var StartTime=$("#StartTime").val();
	if(StartTime=="")
	{
		$.messager.alert('提示','请填写开始时间',"warning");   
        return false;
	}
	var EndTime=$("#EndTime").val();
	if(EndTime=="")
	{
		$.messager.alert('提示','请填写结束时间',"warning");   
        return false;
	}
	var Max=$("#Max").val();
	if(Max=="")
	{
		$.messager.alert('提示','请填写最大预约数',"warning");   
        return false;
	}
	var Max=parseFloat(Max);
	if(Max<=0){
		$.messager.alert("提示","预约数请填写大于0整数","warning");
		return false;		
	}
	var AutoNumber=""; //$("#AutoNumber").val();
	if ((+AutoNumber!=0)&&(parseInt(AutoNumber)>parseInt(Max))){
		$.messager.alert('提示','自动预约数不能大于最大预约数',"warning");   
        return false;
	}
	return true;
}
///修改表格函数
function SaveFormData(){
	if(!CheckData()) return false;
	var Rowid=$("#Rowid").val();
	var LocId=$('#LocList').combobox('getValue');
	var ResourceId=$('#ResourceList').combobox('getValue');   
	var Week=$('#Week').combobox('getValue');
	var TimeDesc=$('#TimeDesc').combobox('getValue');
	var ServiceGroup=$('#ServiceGroup').combobox('getValue');
	var StartTime=$("#StartTime").val();
	var EndTime=$("#EndTime").val();
	var Max=$("#Max").val();
	var AutoNumber=""; //$("#AutoNumber").val();
	var ChargTime=$("#ChargTime").val();
	var InputPara=Rowid+"^"+LocId+"^"+ResourceId+"^"+Week+"^"+TimeDesc+"^"+ServiceGroup+"^"+StartTime+"^"+EndTime+"^"+Max+"^"+AutoNumber+"^"+ChargTime;
	$.m({
		ClassName:"DHCDoc.DHCDocCure.RBCResPlan",
		MethodName:"SaveCureRBCResPlan",
		'value':InputPara
	},function testget(value){
		if(value=="0"){
			$.messager.popover({msg: '保存成功!',type:'success',timeout: 3000})
			LoadCureRBCResPlanDataGrid(true);
			if(Rowid==""){
				$.messager.confirm("提示", "是否继续新增?",function(r){
					if(r){
					}else{
						$("#add-dialog").dialog( "close" );
					}
				})
			}
			return true;							
		}else{
			var errmsg="";
			if (value==100)errmsg=",必填数据不能为空或者不合法";
			else if (value==101)errmsg=",已经存在同时段的模板,不能重复添加";
			else errmsg=value;
			$.messager.alert("错误","保存失败"+errmsg,"error")
			return false;
		}
	});
}
///修改表格函数
function UpdateGridData(Type){
	var rows = CureRBCResPlanDataGrid.datagrid('getSelections');
	if (rows.length ==1) {
		//$("#add-dialog").dialog("open");
		$('#add-dialog').window('open');
		//清空表单数据
		$('#add-form').form("clear")
		$('#LocList').combobox('setValue',rows[0].LocId)
		//var url = "./dhcdoc.cure.query.combo.easyui.csp?ClassName=DHCDoc.DHCDocCure.Config&QueryName=QueryResource&Arg1="+rows[0].LocId+"&ArgCnt=1";
		//$('#ResourceList').combobox('clear');
		//$('#ResourceList').combobox('reload',url);
		//$('#ResourceList').combobox('setValue',rows[0].ResSourceDR)
		var CureResourceListObj=$HUI.combobox("#ResourceList");
		var url = $URL+"?ClassName=DHCDoc.DHCDocCure.Config&QueryName=QueryResource&LocID="+rows[0].LocId+"&ResultSetType=array";
		CureResourceListObj.clear();
		CureResourceListObj.reload(url);
		CureResourceListObj.setValue(rows[0].ResSourceDR);
		$('#Week').combobox('setValue',rows[0].TWeekNum)
		$('#TimeDesc').combobox('setValue',rows[0].TTimePeriodCode)
		$('#ServiceGroup').combobox('setValue',rows[0].TSerivceGourpId)
		
		if(Type=="Copy"){
			var formObj={
				StartTime:rows[0].TStartTime,
				EndTime:rows[0].TEndTime,
				Max:rows[0].TMax,
				AutoNumber:rows[0].TAutoNumber,
				ChargTime:rows[0].TChargTime	 	 
			}
			$('#btnSave').linkbutton({ text:'复制' ,iconCls:"icon-w-copy"});  	
		}else{
			var formObj={
				Rowid:rows[0].TRowid,
				StartTime:rows[0].TStartTime,
				EndTime:rows[0].TEndTime,
				Max:rows[0].TMax,
				AutoNumber:rows[0].TAutoNumber,
				ChargTime:rows[0].TChargTime	 	 
			}
			$('#btnSave').linkbutton({ text:'修改' ,iconCls:"icon-w-update"});  	
		}
		$('#add-form').form("load",formObj)
		 
	}else if (rows.length>1){
		$.messager.alert("提示","您选择了多行！","warning")
	}else{
		$.messager.alert("提示","请选择一行！","warning")
	}
}

function DeleteGridData(){
	var rows = CureRBCResPlanDataGrid.datagrid("getSelections");
    if (rows.length > 0) {
        $.messager.confirm("提示", "确定删除吗?",
        function(r) {
            if (r) {
				var ids = [];
                for (var i = 0; i < rows.length; i++) {
                    ids.push(rows[i].TRowid);
                }
                var ID=ids.join(',')
                //alert(ID);
				$.m({
					ClassName:"DHCDoc.DHCDocCure.RBCResPlan",
					MethodName:"DeleteCureRBCResPlan",
					'Rowid':ID,
				},function testget(value){
			        if(value=="0"){
				       //CureRBCResPlanDataGrid.datagrid('load');
				       LoadCureRBCResPlanDataGrid();
				       CureRBCResPlanDataGrid.datagrid('unselectAll');
				       $.messager.popover({msg: '删除成功',type:'success',timeout: 3000})
			        }else{
				       $.messager.alert('提示',"删除失败:"+value);
			        }
			  
			   });
            }
        });
    } else {
        $.messager.alert("提示", "请选择要删除的行","warning");
    }	
}

function InitCureRBCResPlan()
{
	var CureRBCResPlanToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
              	$('#add-dialog').window('open');
	 			//清空表单数据
	 		  	$('#add-form').form("clear");
	 		  	$('#btnSave').linkbutton({ text:'保存' ,iconCls:"icon-w-save"});   
            }
        },
       {
            text: '删除',
            iconCls: 'icon-remove',
            handler: function() {
	            DeleteGridData();               
            }
        },{
			text: '修改',
			iconCls: 'icon-edit',
			handler: function() {
				UpdateGridData();
			}
		},{
			text: '复制',
			iconCls: 'icon-copy',
			handler: function() {
				UpdateGridData("Copy");
			}
		}];
	var CureRBCResPlanColumns=[[    
                    { field: 'TRowid', title: 'ID', width: 1, sortable: true,hidden:true
					},
					{ field: 'LocDesc', title:'科室', width: 200, sortable: true,resizable: true  
					},
					{ field: 'LocId', title:'LocId', width: 10, sortable: true ,hidden:true 
					},
					{ field: 'ResSourceDR', title:'ResSourceDR', width: 10, sortable: true ,hidden:true  
					},
					{ field: 'ResourceDesc', title:'资源', width: 150, sortable: true ,resizable: true 
					}, 
					{ field: 'TWEEK', title:'星期', width: 80, sortable: true,resizable: true  
					},
        			{ field: 'TTimeDesc', title: '时段', width: 80, sortable: true,resizable: true
					},
					{ field: 'TServiceGroup', title: '服务组', width: 120, sortable: true, resizable: true
					},
					{ field: 'TStartTime', title: '开始时间', width: 100, sortable: true,resizable: true
					},
					{ field: 'TEndTime', title: '结束时间', width: 100, sortable: true,resizable: true
					},
					{ field: 'TMax', title: '最大预约数', width: 100, sortable: true,resizable: true
					},
					//{ field: 'TAutoNumber', title: '自动预约数', width: 20, sortable: true,resizable: true
					//},
					{ field: 'TChargTime', title: '截止缴费时间', width: 100, sortable: true,resizable: true
					},
					{ field: 'TWeekNum', title: 'TWeekNum', width: 1, sortable: true,hidden:true
					},
					{ field: 'TSerivceGourpId', title: 'TServiceGroupId', width: 1, sortable: true,hidden:true
					},
					{ field: 'TTimePeriodCode', title: 'TTimePeriodCode', width: 1, sortable: true,hidden:true
					}
    			 ]];
	CureRBCResPlanDataGrid=$('#tabCureRBCResPlan').datagrid({  
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
		idField:"TRowid",
		pageSize:10,
		pageList : [10,25,50],
		columns :CureRBCResPlanColumns,
		toolbar:CureRBCResPlanToolBar,
		onClickRow:function(rowIndex, rowData){
			//TRowid=rowData.TRowid
		},
		onDblClickRow:function(rowIndex, rowData){ 
			UpdateGridData();	
       	}

	});
	LoadCureRBCResPlanDataGrid(true);
}
function LoadCureRBCResPlanDataGrid(init)
{
	var CureLocName=$('#LocName').combobox('getValue');
	var CureResource=$('#Resource').combobox('getValue');
	if((CureLocName=="")&&(!init)){
		$.messager.alert('提示','请选择科室',"warning");   
        return false;	
	}
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.RBCResPlan",
		QueryName:"QueryResourceWeekPlan",
		'LocId':CureLocName,
		'ResourceId':CureResource,
		Pagerows:CureRBCResPlanDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		CureRBCResPlanDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})
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
		}else if (id=="Week"){
			var CombValue=Data[i].WeekId  
			var CombDesc=Data[i].WeekName
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
///生成资源排班
function CreateResApptSchuldeByLoc()
{
	var LocId=$('#LocName').combobox('getValue');
	var StartDate=$('#StartDate').combobox('getValue');
	var EndDate=$('#EndDate').combobox('getValue');
	var LocId=CheckComboxSelData("LocName",LocId);
	var ResourceId=$('#Resource').combobox('getValue');
	var ResourceId=CheckComboxSelData("Resource",ResourceId);
	if(LocId=="")
	{
		$.messager.alert("提示", "请选择科室","warning")
        return false;
	}
	var Info=LocId+"^"+StartDate+"^"+EndDate+"^"+ResourceId;
	$.m({
		ClassName:"DHCDoc.DHCDocCure.RBCResSchdule",
		MethodName:"CreateResApptSchulde",
		'Info':Info,
		'UserID':session['LOGON.USERID'],
		'hisui':"1",
	},function testget(value){
		if(value=="0"){
			$.messager.popover({msg: "生成资源计划成功!",type:'success',timeout: 3000})
		}else{
			var err=""
			if(value=="1000") err="请检查排班模板数据是否存在问题"
			$.messager.alert('提示',"生成资源计划失败!"+err,"error");
		}
						  
	});
}

function CreateResApptSchulde()
{
	var StartDate=$('#StartDate').combobox('getValue');
	var EndDate=$('#EndDate').combobox('getValue');
	var HospDr=Util_GetSelHospID();
	if((StartDate=="")||(EndDate=="")){
		$.messager.alert("提示", "开始日期或结束日期不能为空!","warning")
        return false;
	}
	$.m({
		ClassName:"DHCDoc.DHCDocCure.RBCResSchdule",
		MethodName:"GenCreateResApptSchulde",
		'StartDate':StartDate,
		'EndDate':EndDate,
		'UserID':session['LOGON.USERID'],
		HospDr:HospDr
	},function testget(value){
		if(value=="0"){
			$.messager.popover({msg: "生成资源计划成功!",type:'success',timeout: 3000})
		}else{
			var err=""
			if(value=="1000") err="请检查排班模板数据是否存在问题"
			$.messager.alert('提示',"生成资源计划失败!"+err,"error");
		}
						  
	});
}

function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' style='overflow:hidden;' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content,
        onClose:function(){
	        destroyDialog(id);
	    }
    });
}

function destroyDialog(id){
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}