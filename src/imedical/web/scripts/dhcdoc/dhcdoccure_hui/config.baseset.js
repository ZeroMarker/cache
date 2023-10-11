/// Descript: 治疗常规设置
/// Descript: config.baseset.js
PageLogicObj={
	ConfigParaDataGrid:"",
	editRowCP:undefined,
	AddEditRowCP:undefined
}
var arrayObj = new Array(
	  //new Array("Check_DHCDocCureNeedTriage","DHCDocCureNeedTriage"),
	  //new Array("Check_DHCDocCureAppDoseQty","DHCDocCureAppDoseQty"),
	  //new Array("Check_DHCDocCureAppHiddenOtherUser","DHCDocCureAppHiddenOtherUser"),
	  //new Array("Check_DHCDocCureAppointAllowExec","DHCDocCureAppointAllowExec"),
	  //new Array("Check_DHCDocCureWorkQrySelf","DHCDocCureWorkQrySelf"),
	  //new Array("Check_DHCDocCureAppQryNotWithTab","DHCDocCureAppQryNotWithTab")
);
var arrayObj2 = new Array(
	  //new Array("Check_DHCDocCureAdviseInsertOrd","DHCDocCureAdviseInsertOrd"),
	  //new Array("Check_DHCDocCureUseCall","DHCDocCureUseCall")
);
var arrayObj1 = new Array(
	  new Array("Text_DHCDocCureFTPIPAddress","DHCDocCureFTPIPAddress"),
	  new Array("Text_DHCDocCureFTPPort","DHCDocCureFTPPort"),
	  new Array("Text_DHCDocCureFTPUserCode","DHCDocCureFTPUserCode"),
	  new Array("Text_DHCDocCureFTPPassWord","DHCDocCureFTPPassWord"),
	  new Array("Text_DHCDocCureFTPPassWordC","DHCDocCureFTPPassWordC"),
	  new Array("Text_DHCDocCureFTPUploadPath","DHCDocCureFTPUploadPath"),
	  new Array("Text_DHCDocCureRecordContent","DHCDocCureRecordContent")
	  //new Array("Text_DHCDocCureLinkPage","DHCDocCureLinkPage"),
	  //new Array("Text_DHCDocCureRecordLinkPage","DHCDocCureRecordLinkPage"),
	  //new Array("Text_DHCDocCureAssLinkPage","DHCDocCureAssLinkPage")
);
$(document).ready(function(){
	InitHospList();
	PageLogicObj.ConfigParaDataGrid=InitConfigParaDataGrid();
	InitEvent();
	InitCache();
})

function InitHospList()
{
	var hospStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	var hospComp = GenHospComp("Doc_Cure_CommonConfig",hospStr);
	hospComp.jdata.options.onSelect = function(e,t){		
		Init();
		PageHandle();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
		PageHandle();
	}
}

function InitCache () {
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function Init(){
	var UserHospID=GetSelHospID();
	var DocCureUseBase=$.m({
		ClassName:"DHCDoc.DHCDocCure.VersionControl",
		MethodName:"UseBaseControl",
		HospitalId:UserHospID,
		dataType:"text"
	},false);
	var DisableFlag=true;
	if(DocCureUseBase==1){
		DisableFlag=false;
		SetDisable(DisableFlag)
		//基础版本保证分诊不启用，防止无意勾选造成困扰
		var SwitchDataStr="";
		for( var i=0;i<arrayObj.length;i++) {
			var param1=arrayObj[i][0];
			var param2=arrayObj[i][1];
			var CheckedValue=0;
			//if ($("#"+param1+"").is(":checked")) {
			if ($HUI.switchbox("#"+param1+"").getValue()) {
				CheckedValue=1;
			}
			if(SwitchDataStr=="") SwitchDataStr=param2+String.fromCharCode(1)+CheckedValue;
			else  SwitchDataStr=SwitchDataStr+String.fromCharCode(2)+param2+String.fromCharCode(1)+CheckedValue;		  
		}
		$.m({
			ClassName:"web.DHCDocConfig",
			MethodName:"SaveConfig",
			Coninfo:SwitchDataStr,
			HospId:UserHospID
		},function(value){
			ConfigDataLoad();
		});
	}else{
		SetDisable(DisableFlag);
		ConfigDataLoad();
	}
	
	LoadLocData();
	PageLogicObj.ConfigParaDataGrid.datagrid("reload");
}

function InitEvent(){
	$('#SaveConfig').click(SaveConfigData)
}

function PageHandle(){
}

function SetDisable(DisableFlag){
	for( var i=0;i<arrayObj.length;i++) {
		var param1=arrayObj[i][0];
		var param2=arrayObj[i][1];
		$HUI.switchbox("#"+param1+"").setValue(DisableFlag);
		$HUI.switchbox("#"+param1+"").setActive(DisableFlag)
	}	
	for( var i=0;i<arrayObj1.length;i++) {
	   	var param1=arrayObj1[i][0];
	   	var param2=arrayObj1[i][1];
	   	break; //暂时没有需要不可用的textbox
	   	if(param1=="Text_DHCDocCureRecordContent"){
			continue;   	
		}
	   	$("#"+param1).prop({
			disabled:(!DisableFlag),   	
		})
	}	
}

function LoadLocData(){
	$("#List_DHCDocCureLoc").empty();
	var UserHospID=GetSelHospID();
	$.m({
		ClassName:"DHCDoc.DHCDocCure.Config",
		MethodName:"FindLocListBroker",
		HospId:UserHospID,
	},function(objScope){
		var vlist = ""; 
		var selectlist="";
		var objScopeArr=objScope.split(String.fromCharCode(1))
		for(var i=0;i<objScopeArr.length;i++){
			var oneLoc=	objScopeArr[i];
			if(oneLoc==""){
				continue	
			}
			var oneLocArr=oneLoc.split(String.fromCharCode(2))
			var LocRowID=oneLocArr[0];
			var LocDesc=oneLocArr[1];
			var selected=oneLocArr[2];
			vlist += "<option value=" + LocRowID + ">" + LocDesc + "</option>"; 
			selectlist=selectlist+"^"+selected
		}
		$("#List_DHCDocCureLoc").append(vlist); 
		for (var j=1;j<=selectlist.split("^").length;j++){
			if(selectlist.split("^")[j]==1){
				$("#List_DHCDocCureLoc").get(0).options[j-1].selected = true;
			}
		}
	});
    
}

//保存其他配置信息
function SaveConfigData()
{
	SaveConfigParaGridData();
	
	var LocDataStr=""
	var size = $("#List_DHCDocCureLoc option").size();
	if(size>0){
		$.each($("#List_DHCDocCureLoc  option:selected"), function(i,own){
			var svalue = $(own).val();
			if (LocDataStr=="") LocDataStr=svalue
			else LocDataStr=LocDataStr+"^"+svalue
		})
		LocDataStr="DHCDocCureLocStr"+String.fromCharCode(1)+LocDataStr
	}
	var SwitchDataStr="";
	for( var i=0;i<arrayObj.length;i++) {
		var param1=arrayObj[i][0];
		var param2=arrayObj[i][1];
		var CheckedValue=0;
		//if ($("#"+param1+"").is(":checked")) {
		if ($HUI.switchbox("#"+param1+"").getValue()) {
			CheckedValue=1;
		}
		if(SwitchDataStr=="") SwitchDataStr=param2+String.fromCharCode(1)+CheckedValue;
		else  SwitchDataStr=SwitchDataStr+String.fromCharCode(2)+param2+String.fromCharCode(1)+CheckedValue;		  
	}
	for( var i=0;i<arrayObj2.length;i++) {
		var param1=arrayObj2[i][0];
		var param2=arrayObj2[i][1];
		var CheckedValue=0;
		//if ($("#"+param1+"").is(":checked")) {
		if ($HUI.switchbox("#"+param1+"").getValue()) {
			CheckedValue=1;
		}
		if(SwitchDataStr=="") SwitchDataStr=param2+String.fromCharCode(1)+CheckedValue;
		else  SwitchDataStr=SwitchDataStr+String.fromCharCode(2)+param2+String.fromCharCode(1)+CheckedValue;		  
	}
	
	var TextConfigStr="";
	var FTPPassWord="",FTPPassWordC="";
	var errFlag=0;
	for( var i=0;i<arrayObj1.length;i++) {
	   	var param1=arrayObj1[i][0];
	   	var param2=arrayObj1[i][1];
	   	var paramval=$("#"+param1).val();
	   	if(param2=="DHCDocCureFTPPassWord"){
		   	FTPPassWord=paramval;
	   	}
	   	else if(param2=="DHCDocCureFTPPassWordC"){
		   	FTPPassWordC=paramval;
		   	//continue;
	   	}else if(param2=="DHCDocCureLinkPage"){
			var nameReg = /(.+(?=[csp]$))/  ;
			if((paramval!="")&&(!nameReg.test(paramval))){
				errFlag=1;
				$.messager.alert('提示',"治疗申请浏览 格式错误,请重试.","info",function(){
					$("#"+param1).focus()	
				});
				break;
			}
		}else{
			 var paramval=$.trim(paramval);  	
		}
	   	if(TextConfigStr==""){
		   	TextConfigStr=param2+String.fromCharCode(1)+paramval;
		}else{
		   	TextConfigStr=TextConfigStr+String.fromCharCode(2)+param2+String.fromCharCode(1)+paramval;
		}
	}
	if(errFlag==1){
		return false;	
	}
	if(FTPPassWord!=FTPPassWordC){
		$.messager.alert('提示',"FTP用户密码与确认密码不一致,请重试.","info");
		return false;	
	}
	var DataStr=LocDataStr;
	var DataStr=DataStr+String.fromCharCode(2)+SwitchDataStr;
	var DataStr=DataStr+String.fromCharCode(2)+TextConfigStr;
	var hospID=GetSelHospID();
	var value=$.cm({
		ClassName:"web.DHCDocConfig",
		MethodName:"SaveConfig",
		_headers:{'X-Accept-Tag':1},
		Coninfo:DataStr,
		HospId:hospID
	},false)
	if(value=="0"){
		//$.messager.show({title:"提示",msg:"保存成功"});
		$.messager.popover({msg: '保存成功！',type:'success',timeout: 3000})			
	}else{
		$.messager.alert('提示','保存失败！',"warning");	
	}
}

function ConfigDataLoad(){
	var hospID=GetSelHospID();
	LoadCheckData(hospID);
	
	for( var i=0;i<arrayObj1.length;i++) {
		var param1=arrayObj1[i][0];
		var param2=arrayObj1[i][1];
		LoadTextData(param1,param2,hospID);	    
	}
}
function LoadTextData(param1,param2,hospID){
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Config",
		MethodName:"getDefaultData",
		value:param2,
		HospID:hospID
	},function(objScope){
		if(objScope.result=="0"){
			objScope.result="";	
		}
		$("#"+param1+"").val(objScope.result);
	})	
}

function LoadCheckData(hospID){
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Config",
		MethodName:"getCureConfigData",
		HospID:hospID
	},function(JsonObj){
		//var JsonObj=JSON.parse(Json); 
		var ScopeValue="";
		for(var i=0;i<arrayObj.length;i++) {
			var param1=arrayObj[i][0];
			var param2=arrayObj[i][1];
			var ScopeValue=JsonObj[param2];
			if (ScopeValue==1){	
				ScopeValue = true;
			}else{
				ScopeValue = false;
			}
			$HUI.switchbox("#"+param1+"").setValue(ScopeValue);
			if(param1=="Check_DHCDocCureAppointAllowExec" && ScopeValue==true){
				var obj=$HUI.switchbox('#Check_DHCDocCureAppDoseQty')
				obj.setValue(true);
				obj.setActive(false);
			}
		}	
		var ScopeValue="";
		for(var i=0;i<arrayObj2.length;i++) {
			var param1=arrayObj2[i][0];
			var param2=arrayObj2[i][1];
			var ScopeValue=JsonObj[param2];
			if (ScopeValue==1){	
				ScopeValue = true;
			}else{
				ScopeValue = false;
			}
			$HUI.switchbox("#"+param1+"").setValue(ScopeValue);
		}	
	})
}

function GetSelHospID(){
	var HospID=session['LOGON.HOSPID']
	if($("#_HospList").length>0){
		var HospID=$HUI.combogrid('#_HospList').getValue();
		if ((!HospID)||(HospID=="")) {
			HospID=session['LOGON.HOSPID'];
		}
	}
	return HospID;
}
function CureAppointAllowExecChange(e,obj){
	if (obj.value) {
		var obj=$HUI.switchbox('#Check_DHCDocCureAppDoseQty')
		obj.setValue(true);
		obj.setActive(false);
	}else{
		$HUI.switchbox('#Check_DHCDocCureAppDoseQty').setActive(true);
	}
}

function InitConfigParaDataGrid() {
	var ConfigParaDataGrid = $('#tblConfigPara').datagrid({
		fit: true,
		width: 'auto',
		border: false,
		url: $URL + "?ClassName=DHCDoc.DHCDocCure.Config&QueryName=FindCureConfigPara",
		striped: true,
		fitColumns: false,
		rownumbers: true,
		singleSelect: true,
		autoRowHeight: false,
		pagination: true,
		pageSize: 10,
		pageList: [10, 20, 50],
		idField: "RowID",
		columns: [
			[{
					field: 'CPCode',
					title: '配置代码',
					width: 180,
					align: 'left',
					editor: {
						type: 'text',
						options: {}
					}
				},
				{
					field: 'CPDesc',
					title: '配置名称',
					width: 250,
					align: 'left',
					editor: {
						type: 'text',
						options: {}
					}
				},
				{
					field: 'CPValue',
					title: '配置数值',
					width: 200,
					align: 'left',
					editor: {
						type: 'text',
						options: {}
					}
				},
				{
					field: 'CPNote',
					title: '配置描述',
					width: 300,
					align: 'left',
					editor: {
						type: 'text',
						options: {}
					},
					formatter: function(value, row, index) {
						return '<a href="###" onmouseover=ShowDetail(this);' + ">" + value + "</a>"
					}
				},
				{
					field: 'CPActive',
					title: '是否激活',
					width: 80,
					align: 'left',
					editor: {
						type: 'icheckbox',
						options: {
							on: 'Y',
							off: '',
							onCheckChange: function(e, value) {

							}
						}
					}
				},
				{
					field: 'RowID',
					title: 'RowID',
					width: 20,
					align: 'left',
					hidden: true
				}
			]
		],
		toolbar: [{
				text: '新增',
				iconCls: 'icon-add',
				handler: function() {
					PageLogicObj.editRowCP = undefined;
					PageLogicObj.ConfigParaDataGrid.datagrid("rejectChanges");
					PageLogicObj.ConfigParaDataGrid.datagrid("unselectAll");

					if (PageLogicObj.editRowCP != undefined) {
						PageLogicObj.ConfigParaDataGrid.datagrid("endEdit", PageLogicObj.editRowCP);
						return;
					} else {
						//添加时如果没有正在编辑的行，则在datagrid的第一行插入一行
						PageLogicObj.ConfigParaDataGrid.datagrid("insertRow", {
							index: 0,
							row: {}
						});
						//将新插入的那一行开户编辑状态
						PageLogicObj.ConfigParaDataGrid.datagrid("beginEdit", 0);
						//给当前编辑的行赋值
						PageLogicObj.editRowCP = 0;
						PageLogicObj.AddEditRowCP = 0;
					}
				}
			}, {
				text: '保存',
				iconCls: 'icon-save',
				handler: function() {
					SaveConfigParaGridData();
				}
			},
			{
				text: '取消编辑',
				iconCls: 'icon-redo',
				handler: function() {
					PageLogicObj.editRowCP = undefined;
					PageLogicObj.AddEditRowCP = undefined;
					PageLogicObj.ConfigParaDataGrid.datagrid("rejectChanges");
					PageLogicObj.ConfigParaDataGrid.datagrid("unselectAll");
				}
			}
		],
		onDblClickRow: function(rowIndex, rowData) {
			if (PageLogicObj.editRowCP != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存", "error");
				return false;
			}
			PageLogicObj.ConfigParaDataGrid.datagrid("beginEdit", rowIndex);
			PageLogicObj.editRowCP = rowIndex;
		},
		onBeforeLoad: function(param) {
			PageLogicObj.AddEditRowCP = undefined;
			PageLogicObj.editRowCP = undefined;
			if (PageLogicObj.ConfigParaDataGrid) PageLogicObj.ConfigParaDataGrid.datagrid("unselectAll").datagrid("rejectChanges");
			var Hospital = GetSelHospID();
			param = $.extend(param, {
				HospID: Hospital
			});
		}
	});
	return ConfigParaDataGrid;
}

function ShowDetail(that){
	$(that).webuiPopover({
		title:"",
		content:that.innerText,
		trigger:'hover',
		placement:'top',
		style:'inverse'
	});
	$(that).webuiPopover('show');	
}

function SaveConfigParaGridData(){
	if (PageLogicObj.editRowCP != undefined) {
		var SelRow = PageLogicObj.ConfigParaDataGrid.datagrid("selectRow", PageLogicObj.editRowCP).datagrid("getSelected");
		var RowID = SelRow["RowID"];
		var editors = PageLogicObj.ConfigParaDataGrid.datagrid('getEditors', PageLogicObj.editRowCP);
		
		var ConfigCode = $.trim(editors[0].target.val());
		var ConfigDesc = $.trim(editors[1].target.val());
		var ConfigValue = $.trim(editors[2].target.val());
		var ConfigNote = $.trim(editors[3].target.val());
		var ActiveFlag = editors[4].target.is(':checked');

		ActiveFlag=(ActiveFlag?"Y":"N");
	    if(ConfigCode==""){
	    	$.messager.alert('提示', "请填写配置代码","warning");
			return false; 
	    }
	    if(ConfigDesc==""){
	    	$.messager.alert('提示', "请填写配置描述","warning");
			return false; 
	    }
	    if(ConfigValue==""){
	    	$.messager.alert('提示', "请填写配置数值","warning");
			return false; 
	    }
	    var params=ConfigCode+"^"+ConfigDesc+"^"+ConfigValue+"^"+ConfigNote+"^"+ActiveFlag
		var params=params+"^"+GetSelHospID();
		var value = $.m({
			ClassName: "DHCDoc.DHCDocCure.Config",
			MethodName: "SaveCureConfigPara",
			RowID: RowID,
			params: params
		},false);
		if (value == "0") {
			PageLogicObj.ConfigParaDataGrid.datagrid("endEdit", PageLogicObj.editRowCP);
			PageLogicObj.editRowCP = undefined;
			PageLogicObj.ConfigParaDataGrid.datagrid('reload').datagrid('unselectAll');
		} else {
			if (value == "-1") value = "配置代码重复!";
			$.messager.alert('提示', "保存失败:" + value);
			return false;
		}
		PageLogicObj.editRowCP = undefined;
		PageLogicObj.AddEditRowCP = undefined;
	}	
}