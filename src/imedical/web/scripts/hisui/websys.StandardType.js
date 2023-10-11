/// imedical/web/scripts/websys.StandardType.js
var StandardTypeList = "#StandardTypeGrid";
var StandardTypeItemList = "#StandardTypeItemGrid";
var ItemReferenceList = "#ReferenceGrid";
var StandardTypeDtoClassName = "websys.dto.StandardTypeDto"
var StandardTypeItemDtoClassName = "websys.dto.StandardTypeItemDto"
var ItemReferenceDtoClassName = "websys.dto.ItemReferenceDto"
var standardTypeItemParentRef = ""
var ItemReferParentRef = ""
var ObjectTypeData = [{ "id": "U", "text": "人员" }, { "id": "L", "text": "科室" }, { "id": "G", "text": "安全组" }, {"id":"T","text":"科室分类"},{"id":"H","text":"医院"}];
var ObjectTypeBizData = { "U": [], "L": [], "G": [], "T": [{id:"O",text:"门诊"}, {id:"I",text:"住院"}, {id:"E",text:"急诊"}, {id:"H",text:"体检"}],"H":[]};
function getStandardTypeTranData(ItemId){
	var LangsJson = $cm({ClassName:"websys.dto.StandardTypeItemDto",QueryName:"FindDescTrans",ItemRowId:ItemId},false);
	LangsJsonRows = LangsJson.rows;
	var rtnArr = [];
	for (var i=0; i<LangsJsonRows.length; i++){
		rtnArr.push({name:LangsJsonRows[i].TLangDesc,value:LangsJsonRows[i].TVal,editor:'text'})
	}
	return rtnArr;
}
function standardTypeShowDescTrans(cn,pn,ItemId,val){
	if ($("#StandardType_pgrid").length>0) return ; /*已打开翻译界面*/
	var mytDivObj = $('#StandardType_TransDiv');
	if (mytDivObj.length==0){
		mytDivObj = $('<div id="StandardType_TransDiv"></div>').appendTo("body");
	}
	mytDivObj.dialog({
		title:"【"+val+"】"+$g("Translate"),
		modal:true,isTopZindex:true,width:360,height:500,maximizable:true,resizable:true,
		content: '<table id="StandardType_pgrid"></table>',
		onBeforeClose:function(){
			$("#StandardType_pgrid").datagrid('getPanel').panel('destroy');
		}, //不同界面公共dialog对象,grid不同界面不同
		toolbar:[{
			text:"Save",
			iconCls:'icon-save',
			handler:function(){
				var itemPLIST = [],valPLIST=[];
				var rows = $("#StandardType_pgrid").datagrid("getRows");
				for (var i=0;i<rows.length;i++){itemPLIST.push(rows[i].name);valPLIST.push(rows[i].value)}
				$cm({
					ClassName:"websys.dto.StandardTypeItemDto",MethodName:"SaveDescTransItem",
					dataType:'text',
					ItemRowId:ItemId,
					iPLIST:itemPLIST,
					vPLIST:valPLIST
					},
					function(rtn){
						if(rtn==1){
							$("#StandardType_pgrid").datagrid("acceptChanges").parent().find('td[field="value"]').removeClass('datagrid-value-changed');
							$.messager.popover({msg:"保存翻译成功",type:'info'});
						 }else{
							$.messager.popover({msg:"Save Fail"+rtn,type:'error',timeout:3000});
						};
					
				});
			}
		}]
	}).show();
	$("#StandardType_pgrid").propertygrid({border:false,data:getStandardTypeTranData(ItemId),fit:true});
}
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
           QueryName:"ListAll",
           rows:20000	
	},function(Data){
		var rowData = Data.rows;
		for (var i = 0; i < rowData.length; i++) {
			var json = {};
			json.id = rowData[i].SSUSRRowId; // HIDDEN
			json.text = rowData[i].SSUSRName+"-"+rowData[i].SSUSRInitials;
			ObjectTypeBizData["U"].push(json)
		}
	});
	$q({
           ClassName:"web.CTLoc",
           QueryName:"LookUpLoc",
           rows:20000
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
		   desc:"",
           rows:10000
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
           ClassName:"web.DHCBL.CT.CTHospital",//"web.CTHospital",
           QueryName:"GetDataForCmb1", //"LookUp",
		   desc:""		
	},function(Data){
		var rowData = Data.rows;
		for (var i = 0; i < rowData.length; i++) {
			var json = {};
			json.id = rowData[i].HOSPRowId;
			json.text = rowData[i].HOSPDesc;
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
		displayMsg:'共{total}条',
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
		afterToolbar:[{text:'翻译',handler:function(){
				var cn = "websys.StandardTypeItem";
				var pn = "Description";
				var RowID = "",val="";
				var row = $(StandardTypeItemList).datagrid("getSelected");
				if (row){ RowID = row['RowID'];val=row[pn] }
				if (RowID!=""){
					standardTypeShowDescTrans(cn,pn,RowID,val);
				}
			},iconCls:"icon-transfer",id:"Tab2TransBtn"}
		],
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
			$("#Tab2TransBtn").linkbutton('disable');
		},
		onSelect:function(rowIndex,rowData){
			ItemReferParentRef = rowData.RowID
			$(ItemReferenceList).datagrid('load');
			$("#Tab2TransBtn").linkbutton('enable');
		},
		onBeginEdit:function(i,d){
			if (d.Code.slice(0,12)=="SysTitleTmpl"){
				var ed2 = $(this).datagrid('getEditor', { 'index': i, field: 'StoredValue' });
				$(ed2.target).templateprompt({
					url:$URL,
					mode:'remote',
					queryParams:{ClassName:'BSP.SYS.BL.Param',QueryName:'Find'},
					pagination:true,
					idField: 'PCode', 
					onBeforeLoad:function(param){
						param = $.extend(param,{q:param.q});
						return true;
					},
					panelWidth:430,
					panelHeight:300,
					columns:[[
						{field:'PCode',title:'占位符',width:200},
						{field:'PDesc',title:'说明',width:200}
					]]
				});
			}
			//loadObjectSelectData(d["ObjectType"],i);
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
							defaultFilter:6,
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
							defaultFilter:6,
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
			if (!row.ObjectReference || !row.ObjectType){
				$.messager.popover({msg:"类型与类型值不能为空！",type:'info'});
				return false;
			}
			var param ={
				"dto.entity.AppKey":row.AppKey
				,"dto.entity.AppSubKey":row.AppSubKey
				,"dto.entity.Data":row.Data||""
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