/// imedical/web/scripts/websys.StandardType.js
var StandardTypeList = "#StandardTypeGrid";
var StandardTypeItemList = "#StandardTypeItemGrid";
var ItemReferenceList = "#ReferenceGrid";
var StandardTypeDtoClassName = "websys.dto.StandardTypeDto"
var StandardTypeItemDtoClassName = "websys.dto.StandardTypeItemDto"
var ItemReferenceDtoClassName = "websys.dto.ItemReferenceDto"
var standardTypeItemParentRef = ""
var ItemReferParentRef = ""
var ObjectTypeData = [{"id":"G","text":"安全组"},{"id":"L","text":"科室"},{"id":"U","text":"人员"},{"id":"H","text":"医院"}];
var ObjectTypeBizData = {"U":[],"L":[],"G":[],"H":[]};
var defaultCallBackRefresh1 = function(rtn){
	if (rtn.success==1){
		$(StandardTypeList).datagrid('load');
		standardTypeItemParentRef = ""
		$(StandardTypeItemList).datagrid('load');
		ItemReferParentRef = ""
		$(ItemReferenceList).datagrid('load');
		$.messager.popover({msg:rtn.msg,type:'success'});
	}else{
		$.messager.popover({msg:rtn.msg,type:'error'});
	}
}
var defaultCallBackRefresh2 = function(rtn){
	if (rtn.success==1){
		$(StandardTypeItemList).datagrid('load');
		ItemReferParentRef = ""
		$(ItemReferenceList).datagrid('load');
		$.messager.popover({msg:rtn.msg,type:'success'});
	}else{
		$.messager.popover({msg:rtn.msg,type:'error'});
	}
}
function initComboboxData() {
	$q({
           ClassName:"web.SSUser",
           QueryName:"FindAll"	
	},function(Data){
		var rowData = Data.rows;
		for (var i = 0; i < rowData.length; i++) {
			var json = {};
			json.id = rowData[i].ID; // HIDDEN
			json.text = rowData[i].Name;
			ObjectTypeBizData["U"].push(json)
		}
	});
	$q({
           ClassName:"web.CTLoc",
           QueryName:"LookUpLoc"
	},function(Data){
		var rowData = Data.rows;
		for (var i = 0; i < rowData.length; i++) {
			var json = {};
			json.id = rowData[i].HIDDEN
			json.text = rowData[i].Description;
			ObjectTypeBizData["L"].push(json)
		}
	});
	$q({
           ClassName:"web.SSGroup",
           QueryName:"Find",
		   desc:""		
	},function(Data){
		var rowData = Data.rows;
		for (var i = 0; i < rowData.length; i++) {
			var json = {};
			json.id = rowData[i].ID; // HIDDEN
			json.text = rowData[i].SSGRPDesc;
			ObjectTypeBizData["G"].push(json)
		}
	});
	$q({
           ClassName:"web.CTHospital",
           QueryName:"LookUp",
		   desc:""		
	},function(Data){
		var rowData = Data.rows;
		for (var i = 0; i < rowData.length; i++) {
			var json = {};
			json.id = rowData[i].HIDDEN;
			json.text = rowData[i].Description;
			ObjectTypeBizData["H"].push(json)
		}
	});
}
$('#find2').click(function(){
	if (!$(this).linkbutton('options').disabled){
		$(StandardTypeItemList).datagrid('load');
	}
});
$('#find1').click(function(){
	if (!$(this).linkbutton('options').disabled){
		$(StandardTypeList).datagrid('load');
	}
});
$('#Code').keypress(function(event){
	// 查询 input 框 Enter键 之后
	if (event.keyCode == "13"){
		$(StandardTypeList).datagrid('load');
	}
});

var createWestTab1 = function(){
	$(StandardTypeList).mgrid({
		className:"websys.dto.StandardTypeDto",
		queryName:"Find",
		editGrid:true,
		key:StandardTypeList.substr(1, StandardTypeList.length - 5),
		title:"",
		fit:true,
		autoSizeColumn:true,
		fitColumns:true,
		pageSize:10,
		onColumnsLoad:function(cm){
			for (var i=0;i<cm.length;i++){
				if(cm[i]['field']=="Code"){
					cm[i].editor = {type:'text'};
				}
			}
		},
		insOrUpdHandler:function(row){
			if (!row.Code){
				$.messager.popover({msg:"类型不能为空！",type:'info'});
				return false;
			}
			var param ={
				"dto.StandardType.Code":row.Code
			};
			$.extend(param,this.insReq,{
				"dto.entity.id":""
			});
			$cm(param,defaultCallBack);
		},
		getNewRecord:function(){
			return {"Code":""};
		},
		delHandler:function(row){
			var _t = this;
			$.messager.confirm("删除", "确定删除【"+row.Code+"】记录?", function (r) {
				if (r) {
					$.extend(_t.delReq,{"dto.StandardType.Code":row.Code});
					$cm(_t.delReq,defaultCallBackRefresh1);
				}
			});
		},
		onBeforeLoad:function(p){
			p.Code = getValueById("Code");
		},
		updReq:{hidden: true},
		onSelect:function(rowIndex,rowData){
			standardTypeItemParentRef = rowData.Code
			$(StandardTypeItemList).datagrid('load');
			ItemReferParentRef = ""
			$(ItemReferenceList).datagrid('load');
		}
	});
}

var createCenterTab2 = function(){
	$(StandardTypeItemList).mgrid({
		className:"websys.dto.StandardTypeItemDto",
		queryName:"Find",
		editGrid:true,
		key:StandardTypeItemList.substr(1, StandardTypeItemList.length - 5),
		title:"",
		fit:true,
		pageSize:15,
		onColumnsLoad:function(cm){
			for (var i=0;i<cm.length;i++){
				if (cm[i]['field']=="RowID"){
					cm[i].hidden=true;
				}
				if((cm[i]['field']=="Code")||(cm[i]['field']=="Description")||(cm[i]['field']=="StoredValue")||(cm[i]['field']=="ExtraValue")){
					cm[i].editor = {type:'text'};
				}
				if(cm[i]['field']=="StoredValue"){
					if ("undefined"==typeof cm[i].width) cm[i].width = 80;
				}
			}
		},
		insOrUpdHandler:function(row){
			var param ={
				"dto.entity.ParRef":standardTypeItemParentRef,"dto.entity.Code":row.Code,"dto.entity.Description":row.Description,"dto.entity.StoredValue":row.StoredValue,"dto.entity.ExtraValue":row.ExtraValue
			};
			if (!row.Code){
				$.messager.popover({msg:"代码不能为空！",type:'info'});
				return false;
			}
			if (row.RowID==""){
				$.extend(param,this.insReq,{
					"dto.entity.id":""
				});
			}else{
				$.extend(param,this.updReq,{
					"dto.entity.id":row.RowID
				});
			}
			$cm(param,defaultCallBack);
		},
		getNewRecord:function(){
			if(!standardTypeItemParentRef) {
				$.messager.popover({msg:"请先在右侧选择类型！",type:'error'});
				return false;	
			}
			return {"RowID":"","Code":"","Description":"","StoredValue":"","ExtraValue":""};
		},
		delHandler:function(row){
			var _t = this;
			$.messager.confirm("删除", "确定删除【"+row.Code+"】记录?", function (r) {
				if (r) {
					$.extend(_t.delReq,{
						"dto.entity.id":row.RowID
					});
					$cm(_t.delReq,defaultCallBackRefresh2);
				}
			});
		},
		onBeforeLoad:function(p){
			p.ParRef = standardTypeItemParentRef
			if($("#Code2").val()) p.Code = $("#Code2").val();
			if($("#Desc2").val()) p.Description = $("#Desc2").val();
		},
		onSelect:function(rowIndex,rowData){
			ItemReferParentRef = rowData.RowID
			$(ItemReferenceList).datagrid('load');
		},		
		a:1
	});
}

var formatter2 = function (value, rowData, rowIndex) {
	if (rowData.ObjectType=="") return ;
	var DataArray = ObjectTypeBizData[rowData.ObjectType];
	for(var i = 0; i < DataArray.length; i++) {
		if (DataArray[i].id == value) {
			return DataArray[i].text;
		}
	}	
	return value;
}
var formatter1 = function (value, rowData, rowIndex) {
	for(var i = 0; i < ObjectTypeData.length; i++) {
		if (ObjectTypeData[i].id == value) {
			return ObjectTypeData[i].text;
		}
	}
	return value;
}
var loadObjectSelectData = function(ObjectType,rowIndex){
	rowIndex = rowIndex||$(ItemReferenceList).datagrid("options").currEditIndex;
	ObjectType = ObjectType||"";
	if (ObjectType==""){
		var t2 = $(ItemReferenceList).datagrid('getEditor', {'index':rowIndex,'field':'ObjectType'}).target;
		ObjectType = t2.combobox("getValue");
	}
	if (ObjectType=="") return [];
	var target1 = $(ItemReferenceList).datagrid('getEditor', {'index':rowIndex,'field':'ObjectReference'}).target;
	target1.combobox('loadData',ObjectTypeBizData[ObjectType]);
}
var createSouthTab3 = function(){
	$(ItemReferenceList).mgrid({
		className:ItemReferenceDtoClassName,
		queryName:"Find",
		editGrid:true,
		key:ItemReferenceList.substr(1, ItemReferenceList.length - 5),
		title:"标准子类型参数",
		fit:true,
		pageSize:15,
		onColumnsLoad:function(cm){
			for (var i=0;i<cm.length;i++){
				if( (cm[i]['field']=="ID")||(cm[i]['field']=="AppKey")||(cm[i]['field']=="AppSubKey")){
					cm[i].hidden=true;
				}
				if((cm[i]['field']=="ObjectType")){
					cm[i].formatter =formatter1;
					if ("undefined"==typeof cm[i].width) cm[i].width = 80;
					cm[i].editor={
						type:'combobox',
						readonly : false,
						options:{
							data:ObjectTypeData,
							valueField:"id",
							textField:"text",
							onSelect:function(){
								var rowIndex = $(ItemReferenceList).datagrid("options").currEditIndex;
								var target1 = $(ItemReferenceList).datagrid('getEditor', {'index':rowIndex,'field':'ObjectReference'}).target;
								target1.combobox('setValue', "");
							}
						}
					}
				}
				if((cm[i]['field']=="ObjectReference")){
					cm[i].formatter = formatter2;
					if ("undefined"==typeof cm[i].width) cm[i].width = 160;
					cm[i].editor={
						type:'combobox',
						readonly : false,
						options:{
							valueField:"id",
							textField:"text",
							onShowPanel:loadObjectSelectData	
						}
					}	
				}
				if ((cm[i]['field']=="Data")){
					cm[i].editor = {type:'text'};
					if ("undefined"==typeof cm[i].width) cm[i].width = 400;
				}
			}
		},
		insOrUpdHandler:function(row){
			if (!row.Data || !row.ObjectReference || !row.ObjectType){
				$.messager.popover({msg:"所有单元格数据不能为空！",type:'info'});
				return false;
			}
			var param ={
				"dto.entity.AppKey":row.AppKey
				,"dto.entity.AppSubKey":row.AppSubKey
				,"dto.entity.Data":row.Data
				,"dto.entity.ObjectReference":row.ObjectReference
				,"dto.entity.ObjectType":row.ObjectType
			};
			if (row.ID==""){
				$.extend(param,this.insReq,{
					"dto.entity.id":""
				});
			}else{
				$.extend(param,this.updReq,{
					"dto.entity.id":row.ID
				});
			}
			$cm(param,defaultCallBack);
		},
		getNewRecord:function(){
			if(!ItemReferParentRef) {
				$.messager.popover({msg:"请先在上侧选择一行记录！",type:'error'});
				return false;	
			}
			return {"ID":"","AppKey":"STANDARD","AppSubKey":ItemReferParentRef,"Data":"","ObjectReference":"","ObjectType":""};
		},
		delHandler:function(row){
			var _t = this;
			$.messager.confirm("删除", "确定删除记录?", function (r) {
				if (r) {
					$.extend(_t.delReq,{"dto.entity.id":row.ID});
					$cm(_t.delReq,defaultCallBack);
				}
			});
		},
		onBeforeLoad:function(p){
			p.AppKey = "STANDARD";
			p.AppSubKey = ItemReferParentRef;
		},
		onBeginEdit:function(i,d){
			loadObjectSelectData(d["ObjectType"],i);
		}
	});
}
$(function(){
	initComboboxData();
	createWestTab1();
	createCenterTab2();
	createSouthTab3();
});