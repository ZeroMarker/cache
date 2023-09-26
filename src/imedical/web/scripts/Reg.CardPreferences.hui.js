var PageLogicObj={
	m_RowId:"",
	m_ClassName:"web.DHCBL.Patient.DHCPatientUpdateLog"
}
$(function(){
	//初始化
	Init()
	//事件初始化
	InitEvent()
	var xmlInfo=tkMakeServerCall("web.DHCBL.UDHCCommFunLibary","GetClassPropertyList","web.DHCEntity.Configure.PatEnroll")
	
})
function Init(){
	var hospComp = GenHospComp("Doc_Reg_CardRegDef");
	hospComp.jdata.options.onSelect = function(e,t){
		$("#ObjectTypeSearch").combobox("select","");
		DataListLoad();
		InitCardType();
		InitPatType();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		//初始化界面上ComboBox
		InitComboBox()
		InitDataGrid()
		InitLookup()
		//注册配置加载数据
		DataListLoad()
	}
}
function InitEvent(){
	//定义新增按钮事件
	$("#Save").click(AddClick);
	$("#BFind").click(DataListLoad);
}
function InitDataGrid(){
	//,:%String,DefualtProvince:%String,:%String,:%String,:%String,:%String
	var Columns=[[    
        {field:'ID',title : '',width : 1,hidden:true},
		{field:'ObjectType',title : '优先级类型',sortable: true, resizable: true},
		{field:'ObjectTypeReference',title : '值',width:100,sortable: true, resizable: true},
		{field:'PatMasFlag',title : '写入患者基本信息',sortable: true, resizable: true},
		{field:'AccManageFLag', title: '写入患者账户信息',sortable: true, resizable: true},
		{field:'CardRefFlag',title : '写入卡信息',sortable: true, resizable: true},
        {field:'DefaultCountryDesc',title : '默认国家', sortable: true, resizable: true},
		{field:'DefaultProvinceDesc',title : '默认省份', sortable: true, resizable: true},
		{field:'DefaultCityDesc',title : '默认城市', sortable: true, resizable: true},
		{field:'DefaultNationDesc',title : '默认民族', sortable: true, resizable: true},
		{field:'DefaultCardTypeDesc',title : '默认卡类型', sortable: true, resizable: true},
		{field:'DefaultIDEquipDesc',title : '默认身份证读取设备', sortable: true, resizable: true},
		{field:'DefaultPatTypeDesc',title : '默认的患者类型', sortable: true, resizable: true},
		{field:'PatTypeList',title : '患者类型', sortable: true, resizable: true},
		{field:'CardTypeList',title : '卡类型', sortable: true, resizable: true}	
	]];
	var dataGrid=$("#DataList").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 20,
		idField:'RowID',
		columns :Columns,
		toolbar: [
		{
			iconCls: 'icon-add ',
			text:'新增',
			handler: function(){
				$("#DataList").datagrid('uncheckAll');
				PageLogicObj.m_RowId="";
				clear()
				$("#ObjectType").combobox("enable")
				$("#ObjectData").lookup("enable")
				$("#Win").dialog("open")
				$("#Win").dialog("center")
			}
		},{
			iconCls: 'icon-write-order',
			text:'修改',
			handler: function(){
				if(PageLogicObj.m_RowId==""){
					$.messager.alert("提示", "请选择要修改的数据", 'info');
					return 
				}
				DataGridSelect(PageLogicObj.m_RowId)
				$("#Win").dialog("open")
				$("#Win").dialog("center")
			}
		},{
			iconCls: 'icon-cancel',
			text:'删除',
			handler: function(){
				DeleteClick()
			}
		}],
		onDblClickRow:function(index, rowData){
			PageLogicObj.m_RowId=rowData["ID"]
			DataGridSelect(PageLogicObj.m_RowId)
			$("#Win").dialog("open")
			$("#Win").dialog("center")
		},
		onSelect:function(index,rowData){
			PageLogicObj.m_RowId=rowData["ID"]
		}
	});
	dataGrid.datagrid('loadData',{ 'total':'0',rows:[] });
	return dataGrid;
}
function DataListLoad(){
	if($("#ObjectDataSearch").lookup("getText")==""){
		$("#ObjectDataSearch").val("");
		$("#ObjectDataSearchId").val("")
	}
	var HospID=$("#_HospList").combobox("getValue")
	$.cm({
	    ClassName : "web.DHCBL.Configure.PatEnroll",
	    QueryName : "FindPreferences",
		ObjectType: $("#ObjectTypeSearch").combobox("getValue"),
		ObjectReference:$("#ObjectDataSearchId").val(),
		HospID:HospID,
	    rows:99999
	},function(GridData){
		$("#DataList").datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		$("#DataList").datagrid("clearSelections")
	});
}
function InitComboBox(){
	var cbox = $HUI.combobox("#ObjectTypeSearch", {
		valueField: 'Value',
		textField: 'Desc', 
		editable:true,
		data: [
			{Value:"U",Desc:"用户"},
			{Value:"L",Desc:"科室"},
			{Value:"G",Desc:"安全组"},
			{Value:"H",Desc:"医院"}
		],
		onSelect:function(rowData){
			$("#ObjectDataSearch").lookup('setText','');
        	$("#ObjectDataSearchId").val('');
		},
		onChange:function(newValue,oldValue){
            if (newValue==""){
	            $("#ObjectDataSearch").lookup('setText','');
                $("#ObjectDataSearchId").val('');
            }
        }
	});
	var cbox = $HUI.combobox("#ObjectType", {
		valueField: 'Value',
		textField: 'Desc', 
		editable:true,
		data: [
			{Value:"U",Desc:"用户"},
			{Value:"L",Desc:"科室"},
			{Value:"G",Desc:"安全组"},
			{Value:"H",Desc:"医院"}
		],
		onSelect:function(rowData){
			if(rowData) {
				$("#ObjectData").lookup('enable').lookup('setText','');
	            $("#ObjectDataId").val('');
	            if (rowData.Value=="H") {
	            	var HospId=$("#_HospList").combobox("getValue");
	            	var HospName=$("#_HospList").combobox("getText");
	            	$("#ObjectData").lookup('disable').lookup('setText',HospName);
	            	$("#ObjectDataId").val(HospId);
	            }
           	}
		},
		onChange:function(newValue,oldValue){
            if (newValue==""){
	            $("#ObjectData").lookup('setText','');
                $("#ObjectDataId").val('');
            }
        }
	});
	//初始化 写入患者基本信息标志
	$.cm({
			ClassName:"web.DHCBL.Configure.PrefParas",
			QueryName:"GetYesNoInfo",
			rows:99999
		},function(GridData){
			var cbox = $HUI.combobox("#PatMasFlag", {
					valueField: 'Value',
					textField: 'Desc', 
					editable:true,
					data: GridData["rows"]
			 });
	});
	//初始化 写入患者账户信息标志 
	$.cm({
			ClassName:"web.DHCBL.Configure.PrefParas",
			QueryName:"GetYesNoInfo",
			rows:99999
		},function(GridData){
			var cbox = $HUI.combobox("#AccManageFLag", {
					valueField: 'Value',
					textField: 'Desc', 
					editable:true,
					data: GridData["rows"]
			 });
	});
	//初始化 写入卡信息标志
	$.cm({
			ClassName:"web.DHCBL.Configure.PrefParas",
			QueryName:"GetYesNoInfo",
			rows:99999
		},function(GridData){
			var cbox = $HUI.combobox("#CardRefFlag", {
					valueField: 'Value',
					textField: 'Desc', 
					editable:true,
					data: GridData["rows"]
			 });
	});
	InitCardType();
	//初始化 默认身份证读取设备
	$.cm({
			ClassName:"web.UDHCCardCommLinkRegister",
			QueryName:"ReadHardComList",
			HardGroupType:"IE",
			rows:99999
		},function(GridData){
			var cbox = $HUI.combobox("#DefaultIDEquipDR", {
					valueField: 'HGRowID',
					textField: 'HGDesc', 
					editable:true,
					data: GridData["rows"]
			 });
	});
	//初始化 患者类型
	InitPatType();	
}
function PropertyLinkNameLoad(){
	var SubClassUserName=tkMakeServerCall("web.DHCBL.Patient.DHCPatientUpdateLog","PropertyLinkClassNameNew",$("#ClassNameId").val(),$("#ClassPropertyId").val())
	$.cm({
			ClassName:"web.DHCBL.Patient.DHCPatientUpdateLog",
			QueryName:"SelectPropertyNew",
			ClsName:SubClassUserName,
			rows:99999
		},function(GridData){
			var cbox = $HUI.combobox("#PropertyLinkName", {
					valueField: 'propertyName',
					textField: 'propertyName', 
					editable:true,
					data: GridData["rows"]
			 });
	});
}
function InitLookup(){
	//初始化 国家
	$("#Country").lookup({
			url:$URL,
            mode:'remote',
			method:"Get",
            idField:'ID',
            textField:'Description',
            columns:[[  
                {field:'Description',title:'国家',width:150}, 				
                {field:'ID',title:'',width:50,hidden:true} 
            ]],
			pagination:true,
			panelWidth:300,
			panelHeight:300,
			isCombo:true,
			queryOnSameQueryString:true,
			queryParams:{ClassName: 'web.CTCountryNew',QueryName: 'LookUp'},
			onBeforeLoad:function(param){
				var desc=param['q'];
				//if (desc=="") return false;
				param = $.extend(param,{desc:desc});
			},
            pagination:true,
            onSelect:function(index,rowData){
                $("#DefaultCountryDR").val(rowData["ID"])
                $("#Province,#City").lookup('setText','');
                $("#DefaultProvinceDR,#DefaultCityDR").val('');
            }
    });
	//初始化 省份
	$("#Province").lookup({
			url:$URL,
            mode:'remote',
			method:"Get",
            idField:'ID',
            textField:'Description',
            columns:[[  
                {field:'Description',title:'省份',width:150}, 				
                {field:'ID',title:'',width:50,hidden:true} 
            ]],
			pagination:true,
			panelWidth:300,
			panelHeight:300,
			isCombo:true,
			queryOnSameQueryString:true,
			queryParams:{ClassName: 'web.CTProvinceNew',QueryName: 'LookUp'},
			onBeforeLoad:function(param){
				var desc=param['q'];
				var lookdefaultCountryId=$("#DefaultCountryDR").val()
				param = $.extend(param,{lookDefaultProvinceDR:desc,defaultCountryDR:lookdefaultCountryId});
			},
            pagination:true,
            onSelect:function(index,rowData){
                $("#DefaultProvinceDR").val(rowData["HIDDEN"])
                $("#City").lookup('setText','');
                $("#DefaultCityDR").val('');
            }
    });
	//初始化 城市
	$("#City").lookup({
			url:$URL,
            mode:'remote',
			method:"Get",
            idField:'ID',
            textField:'Description',
            columns:[[  
                {field:'Description',title:'城市',width:150}, 				
                {field:'ID',title:'',width:50,hidden:true} 
            ]],
			pagination:true,
			panelWidth:300,
			panelHeight:300,
			isCombo:true,
			queryOnSameQueryString:true,
			queryParams:{ClassName: 'web.CTCity',QueryName: 'LookUpWithProv'},
			onBeforeLoad:function(param){
				var desc=param['q'];
				//if (desc=="") return false;
				var lookdefaultProvinceId=$("#DefaultProvinceDR").val()
				param = $.extend(param,{desc:desc,ProvinceDR:lookdefaultProvinceId});
			},
            pagination:true,
            onSelect:function(index,rowData){
                $("#DefaultCityDR").val(rowData["HIDDEN"])
            }
    });
	//初始化 民族
	$("#Nation").lookup({
			url:$URL,
            mode:'remote',
			method:"Get",
            idField:'ID',
            textField:'Description',
            columns:[[  
                {field:'Description',title:'民族',width:150}, 				
                {field:'ID',title:'',width:50} 
            ]],
			pagination:true,
			panelWidth:300,
			panelHeight:300,
			isCombo:true,
			queryOnSameQueryString:true,
			queryParams:{ClassName: 'web.CTNationNew',QueryName: 'LookUp'},
			onBeforeLoad:function(param){
				var desc=param['q'];
				param = $.extend(param,{lookDefaultNationDR:desc});
			},
            pagination:true,
            onSelect:function(index,rowData){
                $("#DefaultNationDR").val(rowData["HIDDEN"])
            }
    });
	//初始化 优先级类型数据
	$("#ObjectDataSearch").lookup({
			url:$URL,
            mode:'remote',
			method:"Get",
            idField:"Id",
            textField:'Desc',
            columns:[[  
                {field:'Desc',title:'名称',width:150}, 	
				{field:'Code',title:'代码',width:150}, 					
                {field:'Id',title:'',width:50,hidden:true} 
            ]],
			pagination:true,
			panelWidth:400,
			panelHeight:300,
			isCombo:true,
			queryOnSameQueryString:true,
			queryParams:{ClassName: "web.DHCBL.Configure.PatEnroll",QueryName: "GetObjectTypeData"},
			onBeforeLoad:function(param){
				var desc=param['q'];
				var ObjectType=$("#ObjectTypeSearch").combobox("getValue")
				var HospID=$("#_HospList").combobox("getValue")
				param = $.extend(param,{desc:desc,ObjectType:ObjectType,HospID:HospID});
			},
            pagination:true,
            onSelect:function(index,rowData){
                $("#ObjectDataSearchId").val(rowData["Id"])
            }
    });
	//初始化 优先级类型数据
	$("#ObjectData").lookup({
			url:$URL,
            mode:'remote',
			method:"Get",
            idField:"Id",
            textField:'Desc',
            columns:[[  
                {field:'Desc',title:'名称',width:150}, 	
				{field:'Code',title:'代码',width:150}, 					
                {field:'ID',title:'',width:50} 
            ]],
			pagination:true,
			panelWidth:300,
			panelHeight:300,
			isCombo:true,
			queryOnSameQueryString:true,
			queryParams:{ClassName: "web.DHCBL.Configure.PatEnroll",QueryName: "GetObjectTypeData"},
			onBeforeLoad:function(param){
				var desc=param['q'];
				var ObjectType=$("#ObjectType").combobox("getValue")
				var HospID=$("#_HospList").combobox("getValue")
				param = $.extend(param,{desc:desc,ObjectType:ObjectType,HospID:HospID});
			},
            pagination:true,
            onSelect:function(index,rowData){
                $("#ObjectDataId").val(rowData["Id"]);
                var ObjectType=$("#ObjectType").combobox('getValue');
				if (ObjectType=="H"){
                	InitCardType(rowData["Id"]);
                	InitPatType(rowData["Id"]);
                }
            }
    });
}
function SaveData(RowId){
	if(!CheckData()) return 
	PageLogicObj.m_RowId=""
	//获取编辑框里的数据
	var ObjectType=$("#ObjectType").combobox("getValue")
	var ObjectReference=$("#ObjectDataId").val()
	var xml=GetXML()
	$m({
		ClassName:"web.DHCBL.Configure.PatEnroll",
		MethodName:"DHCSaveDataToServerNew",
		RowId:RowId,
		ObjectType:ObjectType,
		ObjectReference:ObjectReference,
		XmlData:xml
	},function(txtData){
		if(txtData==0){
			if(RowId==""){
				$.messager.popover({msg: '新增成功！',type:'success',timeout: 1000});
			}else{
				$.messager.popover({msg: '更新成功！',type:'success',timeout: 1000});
			}
			DataListLoad()
			clear()
			$("#Win").dialog("close")
		}else{
			if(txtData=="-1"){
				$.messager.alert("提示", "数据保存失败:该优先级已经存在,不能重复添加!", 'info');
				return
			}
			$.messager.alert("提示", "数据保存失败", 'info');
		}
	});
}
function CheckData(){
	var Country=$("#Country").lookup("getText")
	if(Country==""){
		$("#CountryId").val("")
	}
	var Province=$("#Province").lookup("getText")
	if(Province==""){
		$("#ProvinceId").val("")
	}
	var City=$("#City").lookup("getText")
	if(City==""){
		$("#CityId").val("")
	}
	var Nation=$("#Nation").lookup("getText")
	if(Nation==""){
		$("#NationId").val("")
	}
	if(!Country&&Province){
		$.messager.alert("提示", "国家不能为空", 'info');
		return false
	}
	var ObjectData=$("#ObjectData").lookup("getText")
	if(ObjectData==""){
		$("#ObjectDataId").val("")
		$.messager.alert("提示", "优先级数据不能为空", 'info');
		return false
	}
	var ObjectType=$("#ObjectType").combobox("getValue")
	if(ObjectType==""){
		$.messager.alert("提示", "优先级类型不能为空", 'info');
		return false
	}
	return true
}
function AddClick(){
	SaveData(PageLogicObj.m_RowId)
}

function DeleteClick(){
	if(PageLogicObj.m_RowId==""){
		$.messager.alert("提示", "请选择要删除的记录", 'info');
		return 
	}
	$m({
		ClassName:"web.DHCBL.Configure.PatEnroll",
		MethodName:"Delete",
		RowID:PageLogicObj.m_RowId
	},function(txtData){
		if(txtData==0){
			$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
			DataListLoad()
			clear()
			PageLogicObj.m_RowId=""
		}
	});
}
function DataGridSelect(RowId){
	$.cm({
		ClassName:"web.DHCBL.Configure.PatEnroll",
		MethodName:"GetObjectTypeDataById",
		RowId:RowId
	},function(JsonData){
		if(JsonData!=""){
			$.each(JsonData,function(name,value){
				if((name=="PatTypeList")||(name=="CardTypeList")){
					$("#"+name).combobox("setValues",value)
				}else{
					setValue(name,value)
				}
			})
		}
		if(RowId!=""){
			$("#ObjectType").combobox("disable")
			$("#ObjectData").lookup("disable")
		}
	});
}
///根据元素的classname获取元素值
function getValue(id){
	if(id=="") return ""
	if(typeof $("#"+id)[0]=="undefined") return ""
	var className=$("#"+id).attr("class")
	if(typeof className =="undefined"){
		if (id.indexOf("DR")>=0){
			var tmpid=id.replace("Default","").replace("DR","");
			if ($("#"+tmpid).attr("class").indexOf("lookup")>=0){
				var txt=$("#"+tmpid).lookup("getText");
				if(txt==""){ 
					$("#"+id).val("")
				}
			}
		}
		return $("#"+id).val()
	}
	if(className.indexOf("hisui-switchbox")>=0){
		var val=$("#"+id).switchbox("getValue")
		return val=(val?'Y':'N')
	}else if(className.indexOf("hisui-lookup")>=0){
		var txt=$("#"+id).lookup("getText")
		//如果放大镜文本框的值为空,则返回空值
		if(txt!=""){ 
			var val=$("#"+id).val()
		}else{
			var val=""
			$("#"+id+"Id").val("")
		}
		return val
	}else if(className.indexOf("hisui-combobox")>=0){
		var val=$("#"+id).combobox("getValue")
		if(typeof val=="undefined"){
			return ""
		}
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
		$("#"+id).val(val)
		return 
	}
	if(className.indexOf("hisui-switchbox")>=0){
		val=(val=="Y"?true:false)
		$("#"+id).switchbox("setValue",val)
	}else if(className.indexOf("hisui-combobox")>=0){
		
		$("#"+id).combobox("setValue",val)
	}else if(className.indexOf("hisui-datebox")>=0){
		$("#"+id).datebox("setValue",val)
	}else if(className.indexOf("lookup-text")>=0){
		$("#"+id).lookup("setText",val)
		$("#"+id+"Id").val(val)
	}else{
		$("#"+id).val(val)
	}
	return ""
}
///编辑窗口清屏
function clear(){
	$("#ObjectType,#PatMasFlag,#AccManageFLag,#CardRefFlag").combobox("setValue","")
	$("#DefaultCardTypeDR,#DefaultIDEquipDR,#DefaultPatTypeDR").combobox("setValue","")
	$("#PatTypeList,#CardTypeList").combobox("clear").combobox("select","")
	$("#ObjectData,#Country,#Province,#City,#Nation").lookup("setText","")
	$("#ObjectDataId,#DefaultCountryDR,#DefaultProvinceDR,#DefaultCityDR,#DefaultNationDR").val("")
}

function GetXML(){
	var xmlInfo=tkMakeServerCall("web.DHCBL.UDHCCommFunLibary","GetClassPropertyList","web.DHCEntity.Configure.PatEnroll")
	var myxmlstr="";
	try
	{
		var myary=xmlInfo.split("^");
		//var xmlobj=new XMLWriter();
		//xmlobj.BeginNode(myary[0]);
		myxmlstr=myxmlstr+"<"+myary[0]+">"
		for(var myIdx=1;myIdx<myary.length;myIdx++){
			//xmlobj.BeginNode(myary[myIdx]);
			myxmlstr=myxmlstr+"<"+myary[myIdx]+">"
			if((myary[myIdx]=="PatTypeList")||((myary[myIdx]=="CardTypeList"))){
				var myvalArr = $("#"+myary[myIdx]).combobox("getValues")
				if(myvalArr.length>0) {
					//var myvalArr=myval.split(",");
					var myCount=myvalArr.length
					for (var mySMIdx=0;mySMIdx<myCount;mySMIdx++){
						var myOptValue=myvalArr[mySMIdx];
						var myvalary=myOptValue.split("^");
						myxmlstr=myxmlstr+"<"+myary[myIdx]+"Item"+">"
						myxmlstr=myxmlstr+myOptValue
						myxmlstr=myxmlstr+"</"+myary[myIdx]+"Item"+">"
					}
				}
			}else{
				var myval = getValue(myary[myIdx]);
				//xmlobj.WriteString(myval);
				myxmlstr=myxmlstr+myval
			}
			//xmlobj.EndNode();
			myxmlstr=myxmlstr+"</"+myary[myIdx]+">"
			
		}
		myxmlstr=myxmlstr+"</"+myary[0]+">"
		//myxmlstr = xmlobj.ToString();
	}catch(Err)
	{
		alert("Error: " + Err.description);
	}
	
	return myxmlstr;
}

//界面元素和表里字段对照 
var FieldJson={
	
}
function InitCardType(HospID){
	if (!HospID) var HospID=$("#_HospList").combobox("getValue");
	//初始化 卡信息
	$.cm({
		ClassName:"web.DHCBL.Configure.PatEnroll",
		QueryName:"GetCardTypeList",
		HospID:HospID,
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#DefaultCardTypeDR", {
			valueField: 'CTD_RowID',
			textField: 'CTD_Desc', 
			editable:true,
			data: GridData["rows"]
		});
		//初始化卡类型列表
		var cbox = $HUI.combobox("#CardTypeList",{
			valueField:'CTD_RowID', textField:'CTD_Desc', multiple:true, selectOnNavigation:false,panelHeight:"auto",
			rowStyle:'checkbox', //显示成勾选行形式
			data:GridData["rows"],
			panelHeight:200,
			editable:false
		});
	});
}
function InitPatType(HospID){
	if (!HospID) var HospID=$("#_HospList").combobox("getValue");
	$.cm({
			ClassName:"DHCDoc.DHCDocConfig.PACADM",
			QueryName:"GetCTSocialstatusList",
			HospId:HospID,
			rows:99999
		},function(GridData){
			var cbox = $HUI.combobox("#DefaultPatTypeDR", {
					valueField: 'SSRowId',
					textField: 'SSDesc', 
					editable:true,
					data: GridData["rows"]
			});
			//初始化患者类型列表
			var cbox = $HUI.combobox("#PatTypeList",{
				valueField:'SSRowId', textField:'SSDesc', multiple:true, selectOnNavigation:false,panelHeight:"auto",
				rowStyle:'checkbox', //显示成勾选行形式
				data:GridData["rows"],
				panelHeight:300,
				editable:false,
			}); 
	});
}