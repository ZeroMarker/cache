var FieldJson={
	CCMCode:"Code",
	CCMDesc:"Name",
	CCMComGroupDR:"GroupName",
	CCMCLASSID:"ClassID",
	CCMOBJECTID:"ObjectID",
	CCMDLLType:"DLLType",
	CCMVersion:"Version",
	CCMCodeBase:"CodeBase",
	CCMJSFunctionName:"JsFunctionName",
	CCMEquipPort:"EquipPort",
	CCMDateFrom:"DateFrom",
	CCMDateTo:"DateTo"
}
var PageLogicObj={
	ComManagerId:"",
	DLLObj:""
}
$(function(){
	//初始化
	Init()
	//事件初始化
	InitEvent()
	//硬件参数初始化
	ComManagerListGridLoad()
})
function Init(){
	InitComManagerListGrid()
	//InitDLLFunction()
	PageLogicObj.DLLObj=new InitWin()
	
}
function InitEvent(){
	$("#BFind").click(ComManagerListGridLoad)
}
function InitComManagerListGrid(){
	//ID:%String,Code:%String,Desc:%String,GroupName:%String,ClassID:%String,ObjectID:%String,Version:%String,CodeBase:%String,EquipPort:%String,JSFunctionName:%String,DLLType:%String,DateFrom:%String,DateTo:%String,GroupID:%String
	var Columns=[[ 
		{field:'ID',title:'',hidden:true},
		{field:'Code',title:'代码',width:50},
		{field:'Desc',title:'描述',width:80},
		{field:'GroupName',title:'硬件组',width:80},
		{field:'ClassID',title:'ClassID ',width:120},
		{field:'ObjectID',title:'ObjectID',width:120},
		{field:'Version',title:'版本',width:80},
		{field:'CodeBase',title:'CodeBase',width:80},
		{field:'EquipPort',title:'端口号',width:80},
		{field:'JSFunctionName',title:'JS函数',width:80},
		{field:'DLLType',title:'DLL文件类型',width:100},
		{field:'DateFrom',title:'起始日期',width:100},
		{field:'DateTo',title:'结束日期',width:100},
		{field:'GroupID',title:'',width:100,align:'center',hidden:true}
	]]
	var ComManagerListGrid=$("#ComManagerList").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		//pagination : true,  
		//pageSize: 20,
		idField:'EpisodeID',
		columns :Columns,
		toolbar: [
		{
			iconCls: 'icon-add ',
			text:'新增',
			handler: function(){
				PageLogicObj.ComManagerId=""
				$("#ComManagerList").datagrid("unselectAll")
				LoadComManagerWin("Add")
				clearComManagerWin()
			}
		},{
			iconCls: 'icon-write-order',
			text:'修改',
			handler: function(){
				if(PageLogicObj.ComManagerId==""){
					$.messager.alert("提示", "请选择硬件设备!", 'info');
					return 
				}
				LoadComManagerWin("Update")
				setTimeout("LoadComManagerData('"+PageLogicObj.ComManagerId+"')",100)
				
			}
		}
		/*,{
			iconCls: 'icon-cancel',
			text:'删除',
			handler: function(){
				
			}
		}*/
		],
		onCheck:function(index, row){
			
		},onSelect:function(index,rowData){
			var ComManagerId=rowData["ID"];
			PageLogicObj.ComManagerId=ComManagerId
			PageLogicObj.DLLObj.DataGridLoad(ComManagerId)
		},
		onDblClickRow:function(index, row){
			var ComManagerId=row["ID"];
			PageLogicObj.ComManagerId=ComManagerId
			LoadComManagerWin("Update")
			//LoadComManagerData(PageLogicObj.ComManagerId)
			setTimeout("LoadComManagerData('"+PageLogicObj.ComManagerId+"')",100)
		}
	});
	ComManagerListGrid.datagrid('loadData',{ 'total':'0',rows:[] });
	return ComManagerListGrid;
}
function ComManagerListGridLoad(){
	$.cm({
	    ClassName : "web.DHCBL.CARD.CardHardComManager",
	    QueryName : "CardHardComManagerQuery",
		CodeSearch:$("#SearchCode").val(),
		NameSearch:$("#SearchDesc").val(),
	    rows:99999
	},function(GridData){
		$("#ComManagerList").datagrid('uncheckAll').datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	});
}
function LoadComManagerWin(WinType){
	if(typeof $("#ComManagerWin")[0]=="undefined"){
			$.ajax("reg.cardhardcommanager.win.csp", {
			"type" : "GET",
			"dataType" : "html",
			"success" : function(data, textStatus) {
				$("#previewPanelTemp").html(data)
				var title="设备硬件参数"
				if(WinType=="Add"){
					title="正在新增【设备硬件参数】"
				}
				$('#ComManagerWin').dialog({
					title:title,
					resizable:true,
					modal:true,
					closed:true
				});
				InitComManagerWin()
				$("#ComManagerWin").dialog("center")
				$("#ComManagerWin").dialog("open")
			}
		});
	}else{
		$("#ComManagerWin").dialog("center")
		$("#ComManagerWin").dialog("open")
		var title="设备硬件参数"
		if(WinType=="Add"){
			title="正在新增【设备硬件参数】"
		}
		$("#ComManagerWin").dialog("setTitle",title)
	}
}
function InitComManagerWin(){
	
	var cbox = $HUI.datebox("#DateFrom", {})
	var cbox = $HUI.datebox("#DateTo", {})
	$HUI.combobox("#GroupName", {})
	$HUI.combobox("#DLLType", {})
	
	//初始化硬件组
	$.cm({
			ClassName:"web.DHCBL.CARD.CardHardComGroup",
			QueryName:"CardHardGroupQuery",
			Name:"",
			rows:99999
		},function(GridData){
			var cbox = $HUI.combobox("#GroupName", {
					valueField: 'ID',
					textField: 'Name', 
					editable:true,
					data: GridData["rows"],
					onChange:function(newValue,oldValue){
						if (newValue=="") $(this).combobox('setValue','');
					}
			 });
	});
	//初始化DLL文件类型
	$.cm({
			ClassName:"web.DHCBL.UDHCCommFunLibary",
			QueryName:"InitListObjectValueNew",
			ClassName1:"User.DHCCardHardComManager",
			PropertyName:"CCMDLLType",
			rows:99999
		},function(GridData){
			var cbox = $HUI.combobox("#DLLType", {
					valueField: 'ValueList',
					textField: 'DisplayValue', 
					editable:true,
					data: GridData["rows"],
					onChange:function(newValue,oldValue){
						if (newValue=="") $(this).combobox('setValue','');
					}
			 });
	});
	
	
	$HUI.linkbutton("#Save",{})
	$("#Save").bind("click",SaveClick)
}

function clearComManagerWin(){
	$("#Code").val("")
	$("#Desc").val("")
	$("#GroupName").combobox("setValue","")
	$("#ClassID").val("")
	$("#ObjectID").val("")
	$("#DLLType").combobox("setValue","")
	$("#Version").val("Version")
	
}
function SaveClick(){
	if(!CheckBefore()) return 
	var dataJson={}
	$.each(FieldJson,function(name,value){
		var val=getValue(value)
		val='"'+val+'"'
		eval("dataJson."+name+"="+val)
	})
	var jsonStr=JSON.stringify(dataJson)
	$m({
		ClassName:"web.DHCBL.CARD.CardHardComManager",
		MethodName:"SaveByJson",
		ComManagerId:PageLogicObj.ComManagerId,
		JsonStr:jsonStr
	},function(txtData){
		if(txtData==0){
			//alert("新增加卡类型成功")
			ComManagerListGridLoad()
			$('#ComManagerWin').dialog('close')
		}else{
			$.messager.alert("提示", "数据保存失败", 'info');
		}
	});
}
///保存前的正确性判断
function CheckBefore(){
	var Code=$.trim($("#Code").val())
	if(Code==""){
		$.messager.alert("提示", "代码不能为空", 'info');
		$("#Code").focus()
		return false
	}
	var Desc=$.trim($("#Name").val())
	if(Desc==""){
		$.messager.alert("提示", "描述不能为空", 'info');
		$("#Desc").focus()
		return false
	}
	var DateFrom=$("#DateFrom").datebox("getValue")
	if(DateFrom==""){
		$.messager.alert("提示", "起始日期不能为空", 'info');
		$("#DateFrom").focus()
		return false
	}
	var GroupName=$("#GroupName").combobox("getValue");
	if (GroupName==undefined) GroupName="";
	if(GroupName==""){
		$.messager.alert("提示", "硬件组不能为空", 'info');
		$("#DateFrom").focus()
		return false
	}
	var EquipPort=$.trim($("#EquipPort").val())
	if((EquipPort!="1")&&(EquipPort!="0")&&(EquipPort!="3")&&(EquipPort!="2")&&(EquipPort!="4")&&(EquipPort!="5")){
		var EquipPortflag=dhcsys_confirm("设备端口号为空，可以填写0,1,2,3,4,5；是否继续保存?")
		if(!EquipPortflag){
			$("#DateFrom").focus()
			return false
		}
	}
	return true 
}
///加载设备数据
function LoadComManagerData(ComManagerId){
	clearComManagerWin()
	$.cm({
		ClassName:"web.DHCBL.CARD.CardHardComManager",
		MethodName:"GetComManagerDataJson",
		ComManagerId:ComManagerId,
		jsonFiledStr:JSON.stringify(FieldJson)
	},function(CardTypeData){
		if(CardTypeData!=""){
			$.each(CardTypeData,function(name,value){
				setValue(name,value)
			})
			$("#ComManagerWin").dialog("setTitle","正在修改【"+$("#Name").val()+"】")
		}
	});
}


///根据元素的classname获取元素值
function getValue(id){
	var className=$("#"+id).attr("class")
	if(typeof className =="undefined"){
		return ""
	}
	if(className.indexOf("hisui-switchbox")>=0){
		var val=$("#"+id).switchbox("getValue")
		return val=(val?'Y':'N')
	}else if(className.indexOf("hisui-combobox")>=0){
		var val=$("#"+id).combobox("getValue")
		if(typeof val =="undefined") val=""
		return val
	}else if(className.indexOf("hisui-datebox")>=0){
		return $("#"+id).datebox("getValue")
	}else{
		return $("#"+id).val()
	}
	return ""
}
///给元素赋值
function setValue(id,val){
	var className=$("#"+id).attr("class")
	if(typeof className =="undefined"){
		return ""
	}
	if(className.indexOf("hisui-switchbox")>=0){
		val=(val=="Y"?true:false)
		$("#"+id).switchbox("setValue",val)
	}else if(className.indexOf("hisui-combobox")>=0){
		$("#"+id).combobox("setValue",val)
	}else if(className.indexOf("hisui-datebox")>=0){
		$("#"+id).datebox("setValue",val)
	}else{
		$("#"+id).val(val)
	}
	return ""
}
///卡类型编辑窗口清屏
function clearComManagerWin(){
	$.each(FieldJson,function(name,value){
		var val='"'+""+'"'
		setValue(value,"")
	})
}
