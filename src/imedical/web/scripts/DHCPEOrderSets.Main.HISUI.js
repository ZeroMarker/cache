// DHCPEOrderSets.Main.HISUI.js
// dhcpeordersets.main.hisui.csp
// by zhongricheng

var WIDTH = $(document).width();
var ItemType = "N", LisType = "N", MedType = "N", OtherType = "N", OrdSetsType = "N", IsShow = "N", IsFit = "N";
$("#OrderSetsSearch").css("width", WIDTH*0.5);

$(function() {
	InitCombobox();
	InitARCOSDataGrid();
	
	InitARCOSDetailDataGrid("");
	
	// 初始化项目
	InitItemDataGrid("#QryRisItemList","NoShow");
	InitItemDataGrid("#QryLisItemList","NoShow");
	InitItemDataGrid("#QryMedicalItemList","NoShow");
	InitItemDataGrid("#QryOtherItemList","NoShow");
	// 初始化套餐
	InitOrdSetsDataGrid("#QryOrdSetsList","NoShow");
	
	$("#BSearch").click(function() {
		BSearch_click();
    });
    
    $("#BClear").click(function() {
		BClear_click("0");
    });
	
	$("#BSearchRisItem").click(function() {
		BSearchItem_click("R");
    });
    $("#RisItem").keydown(function(e) {
		if(e.keyCode==13){
			BSearchItem_click("R");
		}
	});
    
    $("#BSearchLisItem").click(function() {
		BSearchItem_click("L");
    });
    $("#LisItem").keydown(function(e) {
		if(e.keyCode == 13){
			BSearchItem_click("L");
		}
	});
    
    $("#BSearchMedicalItem").click(function() {
		BSearchItem_click("M");
    });
    $("#MedicalItem").keydown(function(e) {
		if(e.keyCode == 13){
			BSearchItem_click("M");
		}
	});
    
    $("#BSearchOtherItem").click(function() {
		BSearchItem_click("O");
    });
    $("#OtherItem").keydown(function(e) {
		if(e.keyCode == 13){
			BSearchItem_click("O");
		}
	});
    
    $("#BSearchOrdSets").click(function() {
		BSearchOS_click();
    });
    $("#OrdSets").keydown(function(e) {
		if(e.keyCode == 13){
			BSearchOS_click();
		}
	});
	
	$("#ItemDoseQtyWin").blur(function(){
		var IDQty = $("#ItemDoseQtyWin").numberbox("getValue");
		if (IDQty < 0) {
			$("#ItemDoseQtyWin").numberbox("setValue","");
			$.messager.alert("提示","剂量不能为负数！", "info", function() { $("#ItemDoseQtyWin").focus(); });
			return false;
		}
	});
	
	$("#ItemLinkDoctorWin").blur(function() {
		var LD = $("#ItemLinkDoctorWin").val();
		if (LD != "") {
			var reg = /^\d+(?=\.{0,1}\d+$|$)/;
	  		if (!reg.test(LD)) {
				$("#ItemLinkDoctorWin").val("");
				$.messager.alert("提示","关联请输入正数！", "info", function() { $("#ItemLinkDoctorWin").focus(); });
				return false;
			}
		}
	});
});

// 初始化控件
function InitCombobox() {
	$.cm({
		ClassName:"web.DHCPE.HISUIOrderSets",
		MethodName:"GetARCItemCatID"
	},function(Data){
		$("#Category").val("医嘱套");
		$("#csubCatID").val(Data.ARCItemCatDesc);
		$("#subCatID").val(Data.ARCItemCatID);
	});
	
	// VIP等级	
	$HUI.combobox("#OrderSetVIPWin", {
		url:$URL+"?ClassName=web.DHCPE.HISUIOrderSets&QueryName=SearchVIPLevel&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		allowNull:false,
		panelHeight:"200",
		editable:false,
		onAllSelectClick: function(e) {
			var arr = $(this).combobox("getValues");
			if (arr && arr != "") {
				
			} else {
				
			}
		}
	});
	
	// VIP等级	
	$HUI.combobox("#NetSetsVIPWin", {
		url:$URL+"?ClassName=web.DHCPE.HISUIOrderSets&QueryName=SearchVIPLevel&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		//multiple:true,
		//rowStyle:'checkbox', //显示成勾选行形式
		panelHeight:"auto",
	    panelMaxHeight:150, //最大高度
		allowNull:false,
		editable:false,
		onLoadSuccess: function(data){
	        $("#NetSetsVIPWin").combobox("select", data[0].id);
	    }
		/*
		onAllSelectClick: function(e) {
			var arr = $(this).combobox("getValues");
			if (arr && arr != "") {
				
			} else {
				
			}
		}
		*/
	});
	
	// 性别	
	$HUI.combobox("#OrderSetSexWin", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'',text:'不限'},
			{id:'1',text:'男'},
			{id:'2',text:'女'}
		]
	});
	
	// 性别	
	$HUI.combobox("#NetSetsSexWin", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'不限',text:'不限'},
			{id:'男',text:'男'},
			{id:'女',text:'女'}
		]
	});
	
	// 条件
	$HUI.combobox("#Conditiones", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'1',text:'个人'},
			{id:'2',text:'科室',selected:'true'}
			//{id:'3',text:'全院'}
		]
	});
	
	// 条件
	$HUI.combobox("#ConditionesWin", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'1', text:'个人'},
			{id:'2', text:'科室', selected:'true'}
			//{id:'3', text:'全院'}
		]
	});
	
	// 可用科室	
	$HUI.combobox("#OSLocWin", {
		url:$URL+"?ClassName=web.DHCPE.HISUIOrderSets&QueryName=QueryLoc&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		defaultFilter:4,
		onSelect:function(record) {   // 选中增加
		},
		onBeforeLoad:function(param){
			param.LocText = param.q;
			param.Type="B";
			param.LocID=session['LOGON.CTLOCID'];
			param.hospId = session['LOGON.HOSPID']; 
		}

	});
	
	// 可用团体
	$HUI.combobox("#OrderSetsPGBIWin", {
		url:$URL+"?ClassName=web.DHCPE.HISUIOrderSets&QueryName=QueryPGBI&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		defaultFilter:4,
		onSelect:function(record) {   // 选中增加
		},
		onLoadSuccess:function(data) {
		}
	});
		
	// 站点
	$HUI.combobox("#Station", {
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStation&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		editable:false,
		onSelect:function(record){
			var SelRowData = $("#OrderSetsList").datagrid("getSelected");
			if ( SelRowData ) {
				$("#QryRisItemList").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Item",TargetFrame:"PreItemList",Item:$("#RisItem").val(),StationID:record.id,PreIADMID:"",BType:"B",LocID:session['LOGON.CTLOCID'],hospId:session['LOGON.HOSPID']}); 
			}
		}
	});
	
	// 项目类型（网上套餐）
	$HUI.combobox("#NetSetsItemTypeWin", {
		url:$URL+"?ClassName=web.DHCPE.NetPre.OrdSetsInfo&QueryName=GetItemType&ResultSetType=array",
		valueField:'TID',
		textField:'TDesc',
		editable:false
	});
	
	// 
	$HUI.combobox("#NetSetsBaseActiveWin", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'Y', text:'是', selected:'true'},
			{id:'N', text:'否'}
		]
	});
	
	$HUI.tabs("#QryItem", {
		onSelect:function(title, index) {
			if (IsShow == "Y") {
				if (title == "检查项目" && ItemType == "N") {
					InitItemDataGrid("#QryRisItemList","Item");
					ItemType = "Y";
				} else if (title == "检验项目" && LisType == "N") {
					InitItemDataGrid("#QryLisItemList","Lab");
					LisType = "Y";
				} else if (title == "药品项目" && MedType == "N") {
					InitItemDataGrid("#QryMedicalItemList","Medical");
					MedType = "Y";
				} else if (title == "其他项目" && OtherType == "N") {
					InitItemDataGrid("#QryOtherItemList","Other");
					OtherType = "Y";
				} else if (title == "套餐项目" && OrdSetsType == "N") {
					InitOrdSetsDataGrid("#QryOrdSetsList","");
					OrdSetsType = "Y";
				}
			}
		}
	});
}

// ****************************************************套餐维护********************************************************************** //

// 初始化医嘱套表格
function InitARCOSDataGrid() {
	$HUI.datagrid("#OrderSetsList", {
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.HISUIOrderSets",
			QueryName:"SearchPEOrderSets",
			UserID:session["LOGON.USERID"],  // $.session.get('USERID'),
			subCatID:$("#subCatID").val(),
			Conditiones:$("#Conditiones").combobox('getValue'),
			HospID:session['LOGON.HOSPID']

		},
		method: 'get',
		idField: 'ARCOSRowid',
		treeField: 'ARCOSOrdSubCat',
		columns:[[
			{field:'ARCOSRowid', title:'RowId', hidden:true},
			{field:'ARCOSOrdCatDR', title:'ARCOSOrdCatDR', hidden:true}, // 大类ID
			{field:'ARCOSOrdSubCatDR' ,title:'ARCOSOrdSubCatDR', hidden:true},  // 子类ID
			{field:'ARCOSEffDateFrom', title:'有效日期', hidden:true},
			{field:'FavRowid', title:'FavRowid', hidden:true},
			{field:'FavUserDr', title:'FavUserDr', hidden:true},  // 用户
			{field:'FavDepDr', title:'FavDepDr', hidden:true},  // 科室
			{field:'MedUnit', title:'MedUnit', hidden:true},  // 组
		
			{field:'OSExBreak', title:'OSExBreak', hidden:true},  // 拆分
			{field:'OSExSex', title:'OSExSex', hidden:true},  // 性别
			{field:'OSExDeit', title:'OSExDeit', hidden:true},  // 早餐
			{field:'OSLoc', title:'OSLoc', hidden:true},    // 可用科室
			{field:'OSExVIPLevel', title:'OSExVIPLevel', hidden:true},  // VIPID
			{field:'OSExPGBId', title:'OSExPGBId', hidden:true},   // 团体
			
			{field:'ARCOSOrdCat', title:'大类', hidden:true},
			
			{field:'ARCOSOrdSubCat', title:'子类',},
			{field:'ARCOSCode',title:'代码'},
			{field:'ARCOSDesc',title:'描述'},
			{field:'ARCOSAlias',title:'别名'},
			{field:'AddUser',title:'创建人'},
			
			{field:'BreakDesc', title:'拆分', align:'center'},  // 拆分
			{field:'SexDesc', title:'对应性别', align:'center'},  // 性别
			{field:'VIPDesc',title:'套餐等级'},
			{field:'DeitDesc',title:'早餐', hidden:true},
			{field:'LocDesc',title:'可用科室'},
			{field:'PGDesc',title:'可用团体'},  
			{field:'OSExPrice',title:'套餐价格', align:'right'},  // 价格

			//{field:'FavUserDesc', title:'用户', hidden:true},
			//{field:'FavDepDesc', title:'维护科室', hidden:true},
			//{field:'MedUnitDesc', title:'组名', hidden:true},
			
			/*
			{field:'IsBreakable',title:'操作',formatter:function(value,rowData,rowIndex){
				return "<a href='#' onclick='DeleteARCOS("+rowData.ARCOSRowid+")'>\
							<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/>\
						</a>";
				}
			},
			*/
		]],
		collapsible: true, //收起表格的内容
		lines:true,
		striped:true, // 条纹化
		rownumbers:true,
		fit:true,
		animate:true,
		pagination:true,   // 树形表格 不能分页
		pageSize:25,
		pageList:[10,25,50,100],
		singleSelect:true,
		toolbar: [
		/*
		{**
			iconCls: 'icon-search',
			text:'查询',
			handler: function(){
				BSearch_click();
			}
		},**
		*/
		{
			iconCls: 'icon-add',
			text:'新增',
			handler: function(){
				BClear_click("1");
				$("#OrderSetsWin").show();
				
				$.cm({
					ClassName:"web.DHCPE.HISUIOrderSets",
					MethodName:"GetARCItemCatID"
				},function(Data){
					$("#CategoryWin").val("医嘱套");
					$("#csubCatIDWin").val(Data.ARCItemCatDesc);
					$("#CategoryIDWin").val(Data.Category);
					$("#subCatIDWin").val(Data.ARCItemCatID);
				});
				
				// 代码
				var ARCOSCode=getnum(7);
				if ($("#CodeWin")) { $("#CodeWin").val(ARCOSCode); }
				
				$("#OrderSetsPGBIWin").combobox("setValue","UN");
					 
				var myWin = $HUI.dialog("#OrderSetsWin",{
					iconCls:'icon-w-add',
					resizable:true,
					title:'新增',
					modal:true,
					buttonAlign:'center',
					buttons:[{
						text:'保存',
						handler:function(){
							BAdd_click("Add");
						}
					},{
						text:'关闭',
						handler:function(){
							myWin.close();
						}
					}]
				});
			}
		},{
			iconCls: 'icon-write-order',
			text:'修改',
			id:'BUpd',
			disabled:true,
			handler: function(){
				$("#OrderSetsWin").show();
				
				var SelRowData = $("#OrderSetsList").datagrid("getSelected");
				if (!SelRowData) { 
					$.messager.alert("提示","请选择待修改的医嘱套！", "info"); 
					return false; 
				}

				$("#CategoryWin").val(SelRowData.ARCOSOrdCat);
				$("#csubCatIDWin").val(SelRowData.ARCOSOrdSubCat);
				$("#CategoryIDWin").val(SelRowData.ARCOSOrdCatDR);
				$("#subCatIDWin").val(SelRowData.ARCOSOrdSubCatDR);
				
				$("#CodeWin").val(SelRowData.ARCOSCode);  // 代码
				$("#DescWin").val(SelRowData.ARCOSDesc).validatebox("validate");  // 描述
				$("#AliasWin").val(SelRowData.ARCOSAlias).validatebox("validate");  // 别名
				
				// 条件  
				var InUser = SelRowData.FavUserDr;
				var FavDepList = SelRowData.FavDepDr;
				var DocMedUnit = SelRowData.MedUnit;
				var FavHospDr = SelRowData.FavHospDr;
				var FavUserHospDr = SelRowData.FavUserHospDr;
				//alert(FavHospDr+"^"+FavUserHospDr+"^"+InUser)

				var Conditiones="";
				if (InUser == "") {
					if (FavDepList == "") {
						//if (DocMedUnit == "") { Conditiones = "3"; }
						if ((DocMedUnit == "")&&(FavHospDr!="")&&(FavHospDr==FavUserHospDr)) { Conditiones = "3"; }
					} else {
						if (DocMedUnit == "") { Conditiones = "2"; }
					}
				} else {
					if (FavDepList == "") {
						if (DocMedUnit == "") { Conditiones = "1"; }
					} else {
						if (DocMedUnit != "") { Conditiones = "4"; }
					}
				}
				if (Conditiones == "") Conditiones = "2";
				$("#ConditionesWin").combobox("setValue", Conditiones);
				var iOSExVIPLevel=SelRowData.OSExVIPLevel;
				$("#OrderSetVIPWin").combobox("setValues", iOSExVIPLevel.split(","));  // VIP等级
				$("#OrderSetSexWin").combobox("setValue", SelRowData.OSExSex);  // 性别
				if (SelRowData.OSExBreak == "Y") $("#IsBreakWin").checkbox("setValue", true);  // 拆分
				else $("#IsBreakWin").checkbox("setValue", false);
				//if (SelRowData.OSExDeit == "Y") $("#IsDeitWin").checkbox("setValue", true);  // 早餐
				//else $("#IsDeitWin").checkbox("setValue", false);
				
				var PGBI = SelRowData.OSExPGBId;
				if (PGBI == "") PGBI = "UN";
				$("#OrderSetsPGBIWin").combobox("setValue", PGBI);  // 团体
				
				var myWin = $HUI.dialog("#OrderSetsWin",{
					iconCls:'icon-w-edit',
					resizable:true,
					title:'修改',
					modal:true,
					buttonAlign:'center',
					buttons:[{
						text:'修改',
						handler:function(){
							BAdd_click("Upd");
						}
					},{
						text:'关闭',
						handler:function(){
							myWin.close();
						}
					}]
				});
			}
		},{
			iconCls: 'icon-cancel',
			text:'删除',
			id:'BDel',
			disabled:true,
			handler: function(){
				BDel_click();
			}
		},
		/*
		*{#*
			iconCls: 'icon-remove',
			text:'清屏',
			handler: function(){
				BClear_click("0");
			}
		*},#*
		*/
		/*
		{
			iconCls: 'icon-house',
			text:'可用科室',
			id:'BLoc',
			disabled:true,
			handler: function(){
				$("#OrderSetsLocWin").show();
				
				$("#OSLocWin").combobox("setValue","");
				
				var SelRowData = $("#OrderSetsList").datagrid("getSelected");
				InitARCOSLocDataGrid(SelRowData.ARCOSRowid);
				
				var myWin = $HUI.dialog("#OrderSetsLocWin",{
					iconCls:'icon-w-home',
					resizable:true,
					title:'可用科室维护',
					modal:true,
					onClose: function() {
						$("#AddOSLocBtnWin").unbind("click");
						$("#DelOSLocBtnWin").unbind("click");
						$("#CloseOSLocBtnWin").unbind("click");
					},
					onOpen: function () {
						$("#AddOSLocBtnWin").click(function() { BUpdLoc_click("1"); });
						$("#DelOSLocBtnWin").click(function() { BUpdLoc_click("0"); });
						$("#CloseOSLocBtnWin").click(function() { myWin.close(); });
					}
				});
			}
		},
		*/
		{
			iconCls: 'icon-show-set',
			text:'网上套餐',
			id:'BNetOS',
			disabled:true,
			handler: function(){
				//BSelWeb_click();
				//return false;
					
				var SelRowData = $("#OrderSetsList").datagrid("getSelected");
				if (!SelRowData) { 
					$.messager.alert("提示","请选择待维护的医嘱套！", "info"); 
					return false; 
				}

				$("#NetSetsWin").show();
								
				var NetOSInfo = $.cm({ClassName:"web.DHCPE.NetPre.OrdSetsInfo", MethodName:"GetHisSetsInfoNew", SetsID:SelRowData.ARCOSRowid, LocID:session["LOGON.CTLOCID"]}, false);
				InitNetSetsWin(NetOSInfo);
			    
			    if (NetOSInfo.ID != "") {
				    NetOSItemType(NetOSInfo.ID);
			    }
			    NetBaseType();

				var myWin = $HUI.dialog("#NetSetsWin",{
					iconCls:'icon-w-eye',
					resizable:true,
					title:'网上套餐维护',
					modal:true,
					onClose: function() {
						$("#UndoNetSetsBtnWin").unbind("click");
						$("#AddNetSetsBtnWin").unbind("click");
						$("#DelNetSetsItemTypeWin").unbind("click");
						$("#AddNetSetsItemTypeWin").unbind("click");
						$("#DelNetSetsItemDescWin").unbind("click");
						$("#AddNetSetsItemDescWin").unbind("click");
						$("#DelNetSetsItemDetailWin").unbind("click");
						$("#AddNetSetsItemDetailWin").unbind("click");
						$("#AddNetSetsBaseDescWin").unbind("click");
						$("#UpdNetSetsBaseDescWin").unbind("click");
						InitNetSetsWin("");
					},
					onOpen: function () {
						$("#UndoNetSetsBtnWin").click(function() { NetOSOption(SelRowData, "Undo"); });  // 网上套餐信息撤销
						
					    $("#AddNetSetsBtnWin").click(function() { NetOSOption(SelRowData, "Add"); });  // 网上套餐信息保存
						
						$("#DelNetSetsItemTypeWin").click(function() { NetOSItemTypeOption("Del"); });  // 网上套餐项目类型删除
						
						$("#AddNetSetsItemTypeWin").click(function() { NetOSItemTypeOption("Add"); });  // 网上套餐项目类型保存
							
						$("#DelNetSetsItemDescWin").click(function() { NetOSItemDescOption("Del"); });  // 网上套餐项目删除
						
						$("#AddNetSetsItemDescWin").click(function() { NetOSItemDescOption("Add"); });  // 网上套餐项目新增
						
						$("#DelNetSetsItemDetailWin").click(function() { NetOSItemDetailOption("Del"); });  // 网上套餐项目明细删除
						
						$("#AddNetSetsItemDetailWin").click(function() { NetOSItemDetailOption("Add"); });  // 网上套餐项目明细新增
						
						$("#AddNetSetsBaseDescWin").click(function() { NetOSBaseTypeOption("Add"); });  // 项目类型新增
						
						$("#UpdNetSetsBaseDescWin").click(function() { NetOSBaseTypeOption("Upd"); });  // 项目类型修改
					}
				});
			}
		}],		
		onClickRow: function (rowIndex, rowData) {  // 选择行事件 	
			
			InitARCOSDetailDataGrid(rowData.ARCOSRowid);  // 医嘱明细  
			
			//$('#OrderSets').layout("collapse","west");  // 折叠事件
			//$('#OrderSets').layout("expand","east");  // 展开事件
			//$('#OrderSets').layout("expand","south");
			
			// 初始化项目
			//ItemType = "N", LisType = "N", MedType = "N", OtherType = "N";
			var tab = $("#QryItem").tabs("getSelected");
			var title = tab.panel("options").title;
			
			if (IsShow == "N") {
				if (title == "检查项目" && ItemType == "N") {
					InitItemDataGrid("#QryRisItemList","Item");
					ItemType = "Y";
				} else if (title == "检验项目" && LisType == "N") {
					InitItemDataGrid("#QryLisItemList","Lab");
					LisType = "Y";
				} else if (title == "药品项目" && MedType == "N") {
					InitItemDataGrid("#QryMedicalItemList","Medical");
					MedType = "Y";
				} else if (title == "其他项目" && OtherType == "N") {
					InitItemDataGrid("#QryOtherItemList","Other");
					OtherType = "Y";
				} else if (title == "套餐项目" && OrdSetsType == "N") {
					InitOrdSetsDataGrid("#QryOrdSetsList","");
					OrdSetsType = "Y";
				}
				IsShow = "Y";
			} else {
				if (title == "检查项目") SetRowStyle("#QryRisItemList");
				else if (title == "检验项目") SetRowStyle("#QryLisItemList");
				else if (title == "药品项目") SetRowStyle("#QryMedicalItemList");
				else if (title == "其他项目") SetRowStyle("#QryOtherItemList");
				else if (title == "套餐项目") InitOrdSetsDataGrid("#QryOrdSetsList","");
			}
			//InitItemDataGrid("#QryRisItemList","Item");
			//InitItemDataGrid("#QryLisItemList","Lab");
			//InitItemDataGrid("#QryMedicalItemList","Medical");
			//InitItemDataGrid("#QryOtherItemList","Other");
			
			//$("#Code").val(rowData.ARCOSCode);
			//$("#Desc").val(rowData.ARCOSDesc);
			//$("#Alias").val(rowData.ARCOSAlias);
			
			$('#BUpd').linkbutton('enable');
			$('#BDel').linkbutton('enable');
			$('#BLoc').linkbutton('enable');
			$('#BNetOS').linkbutton('enable'); 
			
		},
		onDblClickRow: function (rowIndex, rowData) {  // 双击行事件
		},
		onLoadSuccess:function(data){
			
		}
	});
}

// 查询
function BSearch_click(){
	
	// 套餐列表
	var HospID=session['LOGON.HOSPID']
	
	$("#OrderSetsList").datagrid('clearSelections'); //取消选中状态

	$("#OrderSetsList").datagrid('load',{
			ClassName:"web.DHCPE.HISUIOrderSets",
			QueryName:"SearchPEOrderSets",
			UserID:session['LOGON.USERID'], // $.session.get('USERID'),
			subCatID:$("#subCatID").val(),
			Conditiones:$("#Conditiones").combobox('getValue'),
			Code:$("#Code").val(),
			Desc:$("#Desc").val(),
			Alias:$("#Alias").val(),
			HospID:HospID
		}); 

	InitARCOSDetailDataGrid("");
}

// 新增
function BAdd_click(type){
	// $.messager.alert("提示","Add", "info");
	if ( type == "Upd" ) { 
		var SelRowData = $("#OrderSetsList").datagrid("getSelected");
		if (SelRowData) {
			var FavRowid = SelRowData.FavRowid;
			var ARCOSRowid = SelRowData.ARCOSRowid;
			var tPGBId = SelRowData.OSExPGBId;
			if (tPGBId == "") tPGBId = "UN"; 
			if (FavRowid == "" || ARCOSRowid == "") {
				$.messager.alert("提示","请选择医嘱套进行修改。", "info");
				return false; 
			}
		} else {
			$.messager.alert("提示","请选择医嘱套进行修改。", "info");
			return false; 
		}
	}
	var ARCOSCatID="", ARCOSCode="", ARCOSDesc="", ARCOSAlias="", Conditiones="", ARCOSEffDateFrom="";
	
	var UserID = session["LOGON.USERID"]
	var UserCode = session["LOGON.USERCODE"];
	var	CTLOCID = session["LOGON.CTLOCID"];
	var HospID=session['LOGON.HOSPID']
	var LogonHospID=session['LOGON.HOSPID']

	//var ARCOSCatID = 12;  // 医嘱套ID OEC_OrderCategory
	if ($("#CategoryIDWin").val().replace(/(^\s*)|(\s*$)/g,'') != "") { ARCOSCatID = $("#CategoryIDWin").val(); }
	else { $.messager.alert("警告", "医嘱套大类为空，请和管理员联系!", "info"); return false; }
	
	if ($("#subCatIDWin").val().replace(/(^\s*)|(\s*$)/g,'') != "") { subCatID = $("#subCatIDWin").val(); }
	else { $.messager.alert("警告", "医嘱套子类为空，请和管理员联系!", "info"); return false; }
	
	if ($("#CodeWin").val().replace(/(^\s*)|(\s*$)/g,"") != "") { ARCOSCode = $("#CodeWin").val(); }
	else { $.messager.alert("警告", "医嘱套代码为空，请和管理员联系!", "info"); return false; }
	
	if ($("#DescWin").val().replace(/(^\s*)|(\s*$)/g,"") != "") { ARCOSDesc = $("#DescWin").val(); }
	else { $.messager.alert("提示", "医嘱套描述不能为空！", "info"); return false; }
	
	if ($("#AliasWin").val().replace(/(^\s*)|(\s*$)/g,"") != "") { ARCOSAlias = $("#AliasWin").val(); }
	else { $.messager.alert("提示", "医嘱套别名不能为空！", "info"); return false; }

	if ($("#ConditionesWin").combobox('getValue').replace(/(^\s*)|(\s*$)/g,"") != "") { Conditiones = $("#ConditionesWin").combobox('getValue'); }
	else { $.messager.alert("提示", "条件不能为空！", "info"); return false; }
		
	// 医嘱套的名字要加上Code
	if (ARCOSDesc.indexOf("-") < 0) {
		ARCOSDesc = UserCode + "-" + ARCOSDesc;
	}
	// $.messager.alert("提示","ARCOSDesc:"+ARCOSCode, "info")
	
	// 取组
	var DocMedUnit = $.m({ClassName:"web.DHCUserFavItems", MethodName:"GetMedUnit", Guser:UserID, CTLOCID:CTLOCID}, false);
	var FavDepList = "";
	var InUser = UserID;
	
	// 条件判断设置相关值
	if (Conditiones == "1") {  // 个人
		FavDepList = "";
		DocMedUnit = "";
		HospID="";
	} else if (Conditiones == "2") {  // 科室
		InUser = "";
		FavDepList = CTLOCID;
		DocMedUnit = "";
		HospID="";
	} else if (Conditiones == "3") { // 全院
		InUser = "";
		FavDepList = "";
		DocMedUnit = "";
		HospID=HospID;
	} else if (Conditiones == "4") {
		FavDepList = "";
		if (DocMedUnit == "") {
			$.messager.alert("提示", "您没有被加入到登陆科室有效的组内,不能进行该条件保存", "info");
			return false;
		}
	}
	
	var VIPLevel="", Break="", Sex="", Deit="", PGBId="", InString="", ret;
	
	PGBId = $("#OrderSetsPGBIWin").combobox("getValue");  // 团体
	if (PGBId == undefined) {
		$.messager.alert("提示", "可用团体不能为空", "info");
		return false;
	}
	
	VIPLevel = $("#OrderSetVIPWin").combobox("getValues");  // 套餐等级
	
	cBreak = $("#IsBreakWin").checkbox("getValue");  // OSE_Break	可否拆分
	if (cBreak) { Break = "Y"; }
	else { Break = "N"; }
	
	Sex = $("#OrderSetSexWin").combobox('getValue');  // OSE_Sex_DR 对应性别
	
	var Deit = "N"
	/*cDeit = $("#IsDeitWin").checkbox("getValue");  // OSE_Break	可否拆分
	if (cDeit) { Deit = "Y"; }
	else { Deit = "N"; }
	*/

	
	InString = VIPLevel + "^" + Break + "^" + Sex + "^" + Deit + "^" + PGBId;
	// $.messager.alert("提示",VIPLevel + " , " + Break + " , " + Sex + " , " + Deit, "info");//return false;
	if (type == "Add") {
		// 生效日期ARCOSEffDateFrom
		if ($("#curDateWin").val() != "") { ARCOSEffDateFrom = $("#curDateWin").val(); }
		else { ARCOSEffDateFrom = daysBetween(""); }
		
		// $.messager.alert("提示",InUser+","+ARCOSCode+","+ARCOSDesc+","+ARCOSCatID+","+subCatID+","+ARCOSEffDateFrom+","+ARCOSAlias+","+UserID+","+FavDepList+","+DocMedUnit+")");
		// return false;
		// ret=tkMakeServerCall("web.DHCUserFavItems","InsertUserARCOS",InUser,ARCOSCode,ARCOSDesc,ARCOSCatID,subCatID,ARCOSEffDateFrom,ARCOSAlias,UserID,FavDepList,DocMedUnit)
		// ret=tkMakeServerCall("web.DHCPE.OrderSets","InsertUserARCOS",InUser,ARCOSCode,ARCOSDesc,ARCOSCatID,subCatID,ARCOSEffDateFrom,ARCOSAlias,UserID,FavDepList,DocMedUnit,"");
		// FavRowid_$C(1)_ARCOSRowid_$C(1)_ARCOSCode
		
		$.m({
			ClassName:"web.DHCPE.HISUIOrderSets",
			MethodName:"InsertUserARCOS",
			UserRowid:InUser,
			ARCOSCode:ARCOSCode,
			ARCOSDesc:ARCOSDesc,
			ARCOSCatID:ARCOSCatID,
			ARCOSSubCatID:subCatID,
			ARCOSEffectDate:ARCOSEffDateFrom,
			ARCOSAlias:ARCOSAlias,
			UserID:UserID,
			FavDepList:FavDepList,
			DocMedUnit:DocMedUnit,
			HospID:HospID,
			InString:InString,
			LogonHospID:LogonHospID,

		},function(ret){  // FavRowid_$C(1)_ARCOSRowid_$C(1)_ARCOSCode
			if (ret == "-1") {
				$.messager.alert("提示","保存医嘱套失败您可能填写了已经使用的代码!", "info");
				return false;
			}
			$.messager.alert("提示","保存成功!", "info");
			var arr = new Array();
			arr = ret.split(String.fromCharCode(1));
			var iFavRowid = arr[0];
			var iARCOSRowid = arr[1];
			var iARCOSCode = arr[2];
			var OSExData=$.cm({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetARCOSData", ARCOSRowid:iARCOSRowid}, false);
			$("#OrderSetsList").datagrid("insertRow", {
				index:0,
				row:{
					ARCOSRowid:iARCOSRowid,
					ARCOSOrdCatDR:ARCOSCatID,	// 大类ID
					ARCOSOrdSubCatDR:subCatID,	// 子类ID
					ARCOSEffDateFrom:ARCOSEffDateFrom,
					FavRowid:iFavRowid,
					FavUserDr:InUser,			// 用户		
					FavDepDr:FavDepList,		// 科室
					MedUnit:DocMedUnit,			// 组
		
					OSExBreak:OSExData.Break,			// 拆分
					OSExSex:OSExData.Sex,				// 性别
					OSExDeit:OSExData.Deit,				// 早餐
					OSExVIPLevel:OSExData.VIPLevel,		// VIPID
					OSExPGBId:OSExData.PGBId,			// 团体ID
			
					ARCOSOrdCat:"医嘱套",
					ARCOSOrdSubCat:"体检医嘱套",
					ARCOSCode:iARCOSCode,
					ARCOSDesc:ARCOSDesc,
					ARCOSAlias:ARCOSAlias,
			
					BreakDesc:OSExData.BreakDesc,  // 拆分
					SexDesc:OSExData.SexDesc,  // 性别 $("#OrderSetSexWin").combobox('getValue')
					VIPDesc:OSExData.VIPDesc,
					DeitDesc:OSExData.DeitDesc,
					PGDesc:OSExData.PGDesc,
					OSExPrice:OSExData.OSExPrice,  // 价格
					FavHospDr:HospID,
				    FavUserHospDr:HospID,

				}
			});
			
			//$("#OrderSetsWin").window("close");
			BClear_click("1");
			//$.cm({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetARCItemCatID"}, function(Data){ $("#CategoryWin").val("医嘱套"); $("#csubCatIDWin").val(Data.ARCItemCatDesc); $("#CategoryIDWin").val(Data.Category); $("#subCatIDWin").val(Data.ARCItemCatID);});
			var ARCOSCode=getnum(7); if ($("#CodeWin")) { $("#CodeWin").val(ARCOSCode); } // 代码
			$("#OrderSetsPGBIWin").combobox("setValue","UN");
		}); 
	} else if (type == "Upd"){
		ARCOSEffDateFrom = SelRowData.ARCOSEffDateFrom;  // 生效日期ARCOSEffDateFrom
		// $.messager.alert("提示",FavRowid+","+ARCOSCode+","+ARCOSDesc+","+ARCOSCatID+","+subCatID+","+ARCOSEffDateFrom+","+ARCOSAlias+","+FavDepList+","+DocMedUnit+","+UserID+","+InString);
		// ret=tkMakeServerCall("web.DHCUserFavItems","UpdateUserARCOS",FavRowid,ARCOSCode,ARCOSDesc,ARCOSCatID,subCatID,ARCOSEffDateFrom,ARCOSAlias,FavDepList,DocMedUnit,InUser);
			var amtflag = $.cm({ ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"IsHaveAmount", ARCOSRowid:ARCOSRowid}, false);
		//alert(amtflag)
		if (amtflag == "1") {
			var BreakNowStr=InString.split("^");
			var BreakNow=BreakNowStr[1];
			if(BreakNow=="Y"){var BreakDescNow="可拆分";}
			else{var BreakDescNow="不可拆";}
			
			if((BreakNow=="Y")&&(BreakDescNow!=SelRowData.BreakDesc)){
				var AmtData = $.cm({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetOrdSetsAmount", ARCOSRowId:ARCOSRowid}, false);
              
				$.messager.confirm("确认", "该套餐已定价，若拆分套餐则会恢复原价，确认拆分？", function(r){
				if (r){
						UndoPrice("0");
						InitARCOSDetailDataGrid(ARCOSRowid);
						$.m({
							ClassName:"web.DHCPE.HISUIOrderSets",
							MethodName:"UpdateUserARCOS",
							FavRowid:FavRowid,
							ARCOSCode:ARCOSCode,
							ARCOSDesc:ARCOSDesc,
							ARCOSCatID:ARCOSCatID,
							ARCOSSubCatID:subCatID,
							ARCOSEffectDate:ARCOSEffDateFrom,
							ARCOSAlias:ARCOSAlias,
							FavDepList:FavDepList,
							DocMedUnit:DocMedUnit,
							UserDr:InUser,
							InString:InString,
							FavHospDr:HospID

						}, function(ret) {
							if (ret == "0") {
								$.messager.alert("提示", "修改成功!", "info");
								var SelRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelRowData);
								var OSExData=$.cm({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetARCOSData", ARCOSRowid:ARCOSRowid}, false);
				                        
								$("#OrderSetsList").datagrid("updateRow", {
									index: SelRowIndex,
									row:{
											FavUserDr:UserID,			// 用户
											FavDepDr:FavDepList,		// 科室
											MedUnit:DocMedUnit,			// 组
	
											OSExBreak:OSExData.Break,			// 拆分
											OSExSex:OSExData.Sex,				// 性别
											OSExDeit:OSExData.Deit,				// 早餐
											OSExVIPLevel:OSExData.VIPLevel,		// VIPID
											OSExPGBId:OSExData.PGBId,			// 团体ID
											ARCOSDesc:ARCOSDesc,
											ARCOSAlias:ARCOSAlias,
		
											BreakDesc:OSExData.BreakDesc,  // 拆分
											SexDesc:OSExData.SexDesc,  // 性别 $("#OrderSetSexWin").combobox('getValue')
											VIPDesc:OSExData.VIPDesc,
											DeitDesc:OSExData.DeitDesc,
											PGDesc:OSExData.PGDesc,
											OSExPrice:AmtData.Amount,  // 价格
										}
									});
								$("#OrderSetsWin").window("close");
						} else { 
								$.messager.alert("提示", "更新失败!", "info");
								return false;
						}
					});	
				} else {
					return false;
				}
			});
			
		}else{
			$.m({
				ClassName:"web.DHCPE.HISUIOrderSets",
				MethodName:"UpdateUserARCOS",
				FavRowid:FavRowid,
				ARCOSCode:ARCOSCode,
				ARCOSDesc:ARCOSDesc,
				ARCOSCatID:ARCOSCatID,
				ARCOSSubCatID:subCatID,
				ARCOSEffectDate:ARCOSEffDateFrom,
				ARCOSAlias:ARCOSAlias,
				FavDepList:FavDepList,
				DocMedUnit:DocMedUnit,
				UserDr:InUser,
				InString:InString,
				FavHospDr:HospID
			}, function(ret) {
				if (ret == "0") {
					$.messager.alert("提示", "修改成功!", "info");
	   
						var SelRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelRowData);
						var OSExData=$.cm({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetARCOSData", ARCOSRowid:ARCOSRowid}, false);
	
						$("#OrderSetsList").datagrid("updateRow", {
							index: SelRowIndex,
							row:{
								FavUserDr:UserID,			// 用户
								FavDepDr:FavDepList,		// 科室
								MedUnit:DocMedUnit,			// 组

								OSExBreak:OSExData.Break,			// 拆分
								OSExSex:OSExData.Sex,				// 性别
								OSExDeit:OSExData.Deit,				// 早餐
								OSExVIPLevel:OSExData.VIPLevel,		// VIPID
								OSExPGBId:OSExData.PGBId,			// 团体ID
								ARCOSDesc:ARCOSDesc,
								ARCOSAlias:ARCOSAlias,

								BreakDesc:OSExData.BreakDesc,  // 拆分
								SexDesc:OSExData.SexDesc,  // 性别 
								VIPDesc:OSExData.VIPDesc,
								DeitDesc:OSExData.DeitDesc,
								PGDesc:OSExData.PGDesc,
								OSExPrice:OSExData.OSExPrice,  // 价格
							}
						});
						$("#OrderSetsWin").window("close");
					} else { 
						$.messager.alert("提示", "更新失败!", "info");
						return false;
					}
				});
			}
		} else {
			$.m({
				ClassName:"web.DHCPE.HISUIOrderSets",
				MethodName:"UpdateUserARCOS",
				FavRowid:FavRowid,
				ARCOSCode:ARCOSCode,
				ARCOSDesc:ARCOSDesc,
				ARCOSCatID:ARCOSCatID,
				ARCOSSubCatID:subCatID,
				ARCOSEffectDate:ARCOSEffDateFrom,
				ARCOSAlias:ARCOSAlias,
				FavDepList:FavDepList,
				DocMedUnit:DocMedUnit,
				UserDr:InUser,
				InString:InString,
				FavHospDr:HospID
			}, function(ret) {
					if (ret == "0") {
							$.messager.alert("提示", "修改成功!", "info");
	
							var SelRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelRowData);
							var OSExData=$.cm({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetARCOSData", ARCOSRowid:ARCOSRowid}, false);
	
							$("#OrderSetsList").datagrid("updateRow", {
								index: SelRowIndex,
								row:{
										FavUserDr:UserID,			// 用户
										FavDepDr:FavDepList,		// 科室
										MedUnit:DocMedUnit,			// 组

										OSExBreak:OSExData.Break,			// 拆分
										OSExSex:OSExData.Sex,				// 性别
										OSExDeit:OSExData.Deit,				// 早餐
										OSExVIPLevel:OSExData.VIPLevel,		// VIPID
										OSExPGBId:OSExData.PGBId,			// 团体ID
										ARCOSDesc:ARCOSDesc,
										ARCOSAlias:ARCOSAlias,
	
										BreakDesc:OSExData.BreakDesc,  // 拆分
										SexDesc:OSExData.SexDesc,  // 性别 $("#OrderSetSexWin").combobox('getValue')
										VIPDesc:OSExData.VIPDesc,
										DeitDesc:OSExData.DeitDesc,
										PGDesc:OSExData.PGDesc,
										OSExPrice:OSExData.OSExPrice,  // 价格
									}
								});
							$("#OrderSetsWin").window("close");
					} else { 
							$.messager.alert("提示", "更新失败!", "info");
							return false;
						}
			});
		}
	}
}

// 删除
function BDel_click(){
	var SelRowData = $("#OrderSetsList").datagrid("getSelected");
	var SelRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelRowData);
	if ( !SelRowData ) { $.messager.alert("提示","请选择医嘱套进行删除！", "info"); return false; }
	var UserID = session["LOGON.USERID"];
	var FavRowid = SelRowData.FavRowid;
	var ARCOSRowid = SelRowData.ARCOSRowid;
	$.messager.confirm("确认", "确定删除该套餐吗？", function(r) {
		if (r){
			$.m({
				ClassName:"web.DHCPE.HISUIOrderSets",
				MethodName:"DeleteUserARCOS", 
				iFavRowid:FavRowid,
				iARCOSRowid:ARCOSRowid
			}, function(ReturnValue) {
				if (ReturnValue != "0") {
					$.messager.alert("提示", ReturnValue+"删除医嘱套失败。", "info");
				}else{
					$.messager.alert("提示", "删除医嘱套成功。", "info");
					$("#OrderSetsList").datagrid("deleteRow", SelRowIndex);
					// 需要清空查询条件
					BClear_click("0");
				}
			});	
		}
	});
}

// 清屏
function BClear_click(Type) {
	if (Type == "0") {
		$("#Code").val("");
		$("#Desc").val("");
		$("#Alias").val("");
		$("#Conditiones").combobox("setValue", "2");
	}

	$("#CodeWin").val("");
	$("#DescWin").val("").validatebox("validate");
	$("#AliasWin").val("").validatebox("validate");
	$("#ConditionesWin").combobox("setValue", "2");
	$("#OrderSetVIPWin").combobox("setValues","");
	$("#OrderSetSexWin").combobox("setValue","");  // 性别
	$("#IsBreakWin").checkbox("setValue", false);  // 拆分
	//$("#IsDeitWin").checkbox("setValue", false);	 // 早餐
	$("#OSLocWin").combobox("setValue","");
	$("#OrderSetsPGBIWin").combobox("setValue","");
	BSearch_click();
}

// 可用科室维护
function BUpdLoc_click(Type) {
	var SelOSRowData = $("#OrderSetsList").datagrid("getSelected");
	if ( !SelOSRowData ) { $.messager.alert("提示","请选择医嘱套再进行套餐可用科室维护的操作！", "info"); return false; }
	var ARCOSRowid = SelOSRowData.ARCOSRowid;
	var loc = "", locdesc = "";
	if (Type == "1") {
		loc = $("#OSLocWin").combobox("getValue");
		locdesc = $("#OSLocWin").combobox("getText");
		
		$.m({
			ClassName:"web.DHCPE.HISUIOrderSets",
			MethodName:"SetARCOSLocInfo",
			ARCOSRowid:ARCOSRowid,
			LocId:loc,
			flag:Type
		}, function(ret) {
			if (ret == "0") {
				$.messager.alert("提示", "增加成功!", "info");
				
				$("#OSLocTable").datagrid("insertRow", {index:0, row:{LocId:loc, LocDesc:locdesc}});
		
				var SelOSRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelOSRowData);
				var OSExData=$.cm({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetARCOSData", ARCOSRowid:ARCOSRowid}, false);
				$("#OrderSetsList").datagrid("updateRow", {index: SelOSRowIndex, row:{OSLoc:OSExData.LocId, LocDesc:OSExData.LocDesc}});
				
				$("#OrderSetsLocWin").window("close");
			} else { 
				$.messager.alert("提示", "增加失败!" + ret.split("^")[1], "info");
				return false;
			}
		});
	} else if (Type == "0") {
		var SelRowData = $("#OSLocTable").datagrid("getSelected");
		if ( !SelRowData ) { $.messager.alert("提示","请选择需要删除的科室！", "info"); return false; }
		$.messager.confirm("确认", "确定删除该可用科室吗？", function(r){
			if (r){
				loc = SelRowData.LocId;
				locdesc = SelRowData.LocDesc;
				
				$.m({
					ClassName:"web.DHCPE.HISUIOrderSets",
					MethodName:"SetARCOSLocInfo",
					ARCOSRowid:ARCOSRowid,
					LocId:loc,
					flag:Type
				}, function(ret) {
					if (ret == "0") {
						$.messager.alert("提示", "删除成功!", "info");
							
						var SelRowData = $("#OSLocTable").datagrid("getSelected");
						var SelRowIndex = $("#OSLocTable").datagrid("getRowIndex", SelRowData);
						$("#OSLocTable").datagrid("deleteRow", SelRowIndex);
		
						var SelOSRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelOSRowData);
						var OSExData=$.cm({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetARCOSData", ARCOSRowid:ARCOSRowid}, false);
						$("#OrderSetsList").datagrid("updateRow", {index: SelOSRowIndex, row:{OSLoc:OSExData.LocId, LocDesc:OSExData.LocDesc}});
						
						$("#OrderSetsLocWin").window("close");
						
					} else { 
						$.messager.alert("提示", "删除失败!" + ret.split("^")[1], "info");
						return false;
					}
				});
			}
		});
	}
}

function InitNetSetsWin(NetOSInfo) {
	$("#NetSetsDescWin").val(NetOSInfo.Desc).validatebox("validate");  // 描述
	$("#NetSetsPriceWin").numberbox("setValue",NetOSInfo.Price).validatebox("validate");  // 价格
	$("#NetSetsSortWin").numberbox("setValue",NetOSInfo.Sort).validatebox("validate");  // 序号
				
	var iNetOSVIPLevel = NetOSInfo.VIPLevel;
	if (iNetOSVIPLevel != "") {
		$("#NetSetsVIPWin").combobox("setValue", iNetOSVIPLevel);  // 套餐等级
	} else {
		var val = $("#NetSetsVIPWin").combobox("getData");
		$("#NetSetsVIPWin").combobox('select', val[0].id);
    
	}
	$("#NetSetsSexWin").combobox("setValue", NetOSInfo.Sex);  // 性别
	$("#NetSetsRemrkWin").val(NetOSInfo.Remark);  // 备注
				
	if (NetOSInfo.GIFlag == "I") $("#NetSetsIsPGWin").checkbox("setValue", false);  // 团体
	else $("#NetSetsIsPGWin").checkbox("setValue", true);
	if (NetOSInfo.ActiveFlag == "Y") $("#NetSetsActiveWin").checkbox("setValue", true);  // 激活
	else $("#NetSetsActiveWin").checkbox("setValue", false);
	ClearNetOS("");
	NetOSItemDesc("");
	NetOSItemDetail("");
	
	if(NetOSInfo.ID == "") {
		NetOSItemType("");
	}
	if(NetOSInfo.ID != "") {
		NetOSItemType(NetOSInfo.ID);
	}

}

// 操作网上套餐
function NetOSOption(SelRowData, Type) {
	var NetOSInfo = $.cm({ClassName:"web.DHCPE.NetPre.OrdSetsInfo", MethodName:"GetHisSetsInfoNew", SetsID:SelRowData.ARCOSRowid, LocID:session["LOGON.CTLOCID"]}, false);
	if (Type == "Add") {
		var StrInfo = "", NOSHisSetsID = "", NOSDesc = "", NOSVIPLevel = "", NOSSex = "";
		var NOSRemak = "", NOSSort = "", NOSGIFlag = "", NOSLocID = "", NOSActive = "";
		
		NOSHisSetsID = SelRowData.ARCOSRowid;
		if ($("#NetSetsDescWin").val() == "") { $.messager.alert("提示", "未选择医嘱套!", "info"); return false; }
		
		NOSDesc = $("#NetSetsDescWin").val();  // 描述
		if ($("#NetSetsDescWin").val() == "") { $.messager.alert("提示", "描述不能为空!", "info"); return false; }
		
		NOSSort = $("#NetSetsSortWin").numberbox("getValue");  // 序号
		if (NOSSort == "") { $.messager.alert("提示", "序号不能为空!", "info"); return false; }
		
		NOSVIPLevel = $("#NetSetsVIPWin").combobox("getValue");  // 套餐等级
		if (NOSVIPLevel == "") { $.messager.alert("提示", "套餐等级不能为空!", "info"); return false; }
		
		NOSSex = $("#NetSetsSexWin").combobox("getValue");  // 性别
		if (NOSSex == "") { $.messager.alert("提示", "性别不能为空!", "info"); return false; }
		NOSRemak = $("#NetSetsRemrkWin").val();  // 备注
		NOSLocID = session["LOGON.CTLOCID"];  // 科室
		
		cIsIG = $("#NetSetsIsPGWin").checkbox("getValue");  // 团体
		if (cIsIG) { NOSGIFlag = "G"; }
		else { NOSGIFlag = "I"; }
			    	
		cIsActive = $("#NetSetsActiveWin").checkbox("getValue");  // 激活
		if (cIsActive) { NOSActive = "Y"; }
		else { NOSActive = "N"; }
		
		StrInfo = NOSHisSetsID + "^" + NOSDesc + "^^" + NOSVIPLevel + "^" + NOSSex + "^" + NOSRemak + "^" + NOSSort + "^" + NOSGIFlag + "^" + NOSLocID + "^" + NOSActive;
		
		$.m({ClassName:"web.DHCPE.NetPre.OrdSetsInfo", MethodName:"SaveOrdSets", ID:NetOSInfo.ID, StrInfo:StrInfo},
			function(ret) {
				if (ret.split("^")[0] == "-1") { $.messager.alert("提示", "保存失败!" + ret.split("^")[1], "info"); return false; }
				else { $.messager.alert("提示", "保存成功!", "info"); NetOSItemType(ret); }
			}
		);
	} else if (Type == "Undo") {
		if (NetOSInfo.ID == "") { $.messager.alert("提示", "ID为空，无法撤销！", "info"); return false; }
		
		$.messager.confirm("确认", "确定撤销该网上套餐？", function(r){
			if (r){
				$.m({ClassName:"web.DHCPE.NetPre.OrdSetsInfo", MethodName:"DeleteOrdSets", ID:NetOSInfo.ID},
					function(ret) {
						if (ret == "0") {
							$.messager.alert("提示", "撤销成功!", "info");
							var NetOSInfo = $.cm({ClassName:"web.DHCPE.NetPre.OrdSetsInfo", MethodName:"GetHisSetsInfoNew", SetsID:SelRowData.ARCOSRowid, LocID:session["LOGON.CTLOCID"]}, false);
							InitNetSetsWin(NetOSInfo);
						} else {
							$.messager.alert("提示", "撤销失败!", "info");
							return false;
						}
					}
				);
			}
		});
	}
}

// 项目类型维护
function NetBaseType() {
	$HUI.datagrid("#tNetOrdSetsBaseDescWin", {
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.NetPre.OrdSetsInfo",
			QueryName:"GetItemType",
			Show:"ALL"
		},
		columns:[[
			{field:'TID', title:'TID', hidden:true},
			
			{field:'TDesc', title:'描述'},
			{field:'TActive', title:'激活', align:'center',
				formatter: function(value, rowData, rowIndex) {
					if (value == "Y") return "是";
					else return "否";
				}
			}
		]],
		collapsible:true, //收起表格的内容
		border:false,
		lines:true,
		striped:true, // 条纹化
		rownumbers:true,
		fit:true,
		fitColumns:true,
		animate:true,
		
		pagination:false,
		//showPageList:false,
		//showRefresh:true,
		//beforePageText:'第',
		//afterPageText:'页,共{pages}页', displayMsg:'共{total}条',
		
		singleSelect:true,
		onClickRow: function (rowIndex, rowData) {  // 选择行事件 	
			$("#NetSetsBaseDescWin").val(rowData.TDesc);
			$("#NetSetsBaseActiveWin").combobox("setValue",rowData.TActive);
		},
		onLoadSuccess:function(data){
			
		}
	});
}

// 项目类型操作
function NetOSBaseTypeOption(Type) {
	var SelNetOSBaseTypeRowData = $("#tNetOrdSetsBaseDescWin").datagrid("getSelected");
	var TID = "";
	if ( SelNetOSBaseTypeRowData ) { TID = SelNetOSBaseTypeRowData.TID; }
	
	var typeDesc = $("#NetSetsBaseDescWin").val();
	if (typeDesc == "") { $.messager.alert("提示", "描述不能为空！", "info"); return false; }
	
	var active = $("#NetSetsBaseActiveWin").combobox("getValue");  // 激活
	
	if (Type == "Add") {
		$.m({ClassName:"web.DHCPE.NetPre.OrdSetsInfo", MethodName:"UpdItemType", ID:"", Desc:typeDesc, Active:active},
			function(ret) {
				if (ret.split("^")[0] == "0"){
					$.messager.alert("提示", "项目基础类型增加成功！", "info");
					$("#tNetOrdSetsBaseDescWin").datagrid("insertRow", {
						index:0,
						row:{
							TID: ret.split("^")[1],
							TDesc: typeDesc,
							TActive: active
						}
					});
					$HUI.combobox("#NetSetsItemTypeWin", "reload");
					
					$("#NetSetsBaseDescWin").val("");
					$("#NetSetsBaseActiveWin").combobox("setValue","Y");
				} else if (ret.split("^")[0] == "-1") { 
					$.messager.alert("提示", "项目基础类型增加失败！" + ret.split("^")[1], "info"); 
					return false; 
				} else { 
					$.messager.alert("提示", "项目基础类型增加失败！", "info"); 
					return false; 
				}
			}
		);
	} else if (Type == "Upd") {
		if ( TID == "" ) { $.messager.alert("提示","请先选择类型再进行修改操作！", "info"); return false; }

		$.m({ClassName:"web.DHCPE.NetPre.OrdSetsInfo", MethodName:"UpdItemType", ID:TID, Desc:typeDesc, Active:active},
			function(ret) { 
				if (ret == "0") { 
					$.messager.alert("提示", "项目基础类型修改成功！", "info");
					//var CurSelRowData = $("#tNetOrdSetsBaseDescWin").datagrid("getSelected");
					var CurSelRowIndex = $("#tNetOrdSetsBaseDescWin").datagrid("getRowIndex", SelNetOSBaseTypeRowData);
					$("#tNetOrdSetsBaseDescWin").datagrid("updateRow", {
						index: CurSelRowIndex,
						row:{
							TDesc: typeDesc,
							TActive: active
						}
					});
					$HUI.combobox("#NetSetsItemTypeWin", "reload");
					$("#NetSetsItemTypeWin").combobox("setValue","")
					$("#tNetOrdSetsItemTypeWin").datagrid("reload");
				} else {
					$.messager.alert("提示", "项目基础类型修改失败！" + ret.split("^")[1], "info");
					return false;
				}
			}
		);
	}
}

// 网上套餐项目分类
function NetOSItemType(ID) {
	$HUI.datagrid("#tNetOrdSetsItemTypeWin", {
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.NetPre.OrdSetsInfo",
			QueryName:"SearchSetsItemType",
			ParRef:ID
		},
		columns:[[
			{field:'TID', title:'TID', hidden:true},
			{field:'TItemTypeID', title:'TItemTypeID', hidden:true},
			
			{field:'TItemTypeDesc',title:'类型',width:30},
			{field:'TSort',title:'序号'}
		]],
		collapsible:true, //收起表格的内容
		border:false,
		lines:true,
		striped:true, // 条纹化
		rownumbers:true,
		fit:true,
		fitColumns:true,
		animate:true,
		
		pagination:true,
		showPageList:false,
		showRefresh:true,
		beforePageText:'第',
		afterPageText:'页,共{pages}页', displayMsg:'共{total}条',
		
		singleSelect:true,
		onClickRow: function (rowIndex, rowData) {  // 选择行事件 	
			NetOSItemDesc(rowData.TID);
		},
		onLoadSuccess:function(data){
			$("#NetSetsIDWin").val(ID);
		}
	});
}

// 网上套餐项目分类操作
function NetOSItemTypeOption(Type) {
	var SelNetOSItemTypeRowData = $("#tNetOrdSetsItemTypeWin").datagrid("getSelected");
	var TID = "";
	if ( SelNetOSItemTypeRowData ) { TID = SelNetOSItemTypeRowData.TID; }
	
	if (Type == "Add") {
		var pID = $("#NetSetsIDWin").val();
		if (pID == "") { $.messager.alert("提示", "请先维护网上套餐信息!", "info"); return false; }
		
		var itemType = $("#NetSetsItemTypeWin").combobox("getValue");
		if (itemType == "") { $.messager.alert("提示", "请选择项目类型", "info"); return false; }
		
		var sort = $("#NetSetsTypeSortWin").numberbox("getValue");  // 序号
		if (sort == "") { $.messager.alert("提示", "序号不能为空!", "info"); return false; }
		
		var itemTypeDesc = $("#NetSetsItemTypeWin").combobox("getText");
		
		var Info = pID + "^" + itemType + "^" + sort ;
		
		$.m({ClassName:"web.DHCPE.NetPre.OrdSetsInfo", MethodName:"SaveSetsItemType", ID:"", StrInfo:Info},
			function(ret) {
				if (ret.split("^")[0] == "-1") { 
					$.messager.alert("提示", "项目类型增加失败!", "info"); 
					return false; 
				} else if (ret.split("^")[0] == "-2") { 
					$.messager.alert("提示", "项目类型增加失败!" + ret.split("^")[1], "info"); 
					return false; 
				//} else if (ret > 0) {
				} else {
					$.messager.alert("提示", "项目类型增加成功!", "info");
					$("#tNetOrdSetsItemTypeWin").datagrid("insertRow", {
						index:0,
						row:{
							TID: ret,
							TItemTypeID: itemType,
							
							TSort: sort, // 序号
							TItemTypeDesc: itemTypeDesc, // 项目类别
						}
					});
					ClearNetOS("Type");
					//ClearNetOS("Desc");
					//ClearNetOS("Detail");
					//NetOSItemDesc(ret);
				}
			}
		);
	} else if (Type == "Del") {
		if ( TID == "" ) { $.messager.alert("提示","请先选择项目类型再进行删除操作！", "info"); return false; }
		
		$.messager.confirm("确认", "确定删除该项目分类？", function(r){
			if (r){
				$.m({ClassName:"web.DHCPE.NetPre.OrdSetsInfo", MethodName:"DeleteSetsItemType", ID:TID},
					function(ret) { 
						if (ret == "0") { 
							$.messager.alert("提示", "项目类型删除成功!", "info"); 
							NetOSItemDesc("");
							var CurSelRowData = $("#tNetOrdSetsItemTypeWin").datagrid("getSelected");
							var CurSelRowIndex = $("#tNetOrdSetsItemTypeWin").datagrid("getRowIndex", CurSelRowData);
							$("#tNetOrdSetsItemTypeWin").datagrid("deleteRow", CurSelRowIndex);
							ClearNetOS("Desc");
							
							NetOSItemDetail("");
							var CurSelRowData = $("#tNetOrdSetsItemDescWin").datagrid("getSelected");
							var CurSelRowIndex = $("#tNetOrdSetsItemDescWin").datagrid("getRowIndex", CurSelRowData);
							$("#tNetOrdSetsItemDescWin").datagrid("deleteRow", CurSelRowIndex);
							ClearNetOS("Detail");
						} else {
							$.messager.alert("提示", "项目类型删除失败!", "info");
							return false;
						}
					}
				);
			}
		});
	}
}

// 网上套餐项目
function NetOSItemDesc(ID) {
	$HUI.datagrid("#tNetOrdSetsItemDescWin", {
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.NetPre.OrdSetsInfo",
			QueryName:"SearchSetsItem",
			ParRef:ID
		},
		columns:[[
			{field:'TID', title:'TID', hidden:true},
			
			{field:'TDesc',title:'项目描述',width:30},
			{field:'TSort',title:'序号'}
		]],
		collapsible: true, //收起表格的内容
		border:false,
		lines:true,
		striped:true, // 条纹化
		rownumbers:true,
		fit:true,
		fitColumns:true,
		animate:true,
		
		showPageList:false,
		showRefresh:true,
		afterPageText:'页,共{pages}页',
		beforePageText:'第', displayMsg:'共{total}条',
		pagination:true,
		
		singleSelect:true,
		onClickRow: function (rowIndex, rowData) {  // 选择行事件 	
			NetOSItemDetail(rowData.TID);
		},
		onLoadSuccess:function(data) {
		}
	});
}

// 网上套餐项目操作
function NetOSItemDescOption(Type) {
	
	var TID = "";
	var SelNetOSItemDescRowData = $("#tNetOrdSetsItemDescWin").datagrid("getSelected");
	if ( SelNetOSItemDescRowData ) { TID = SelNetOSItemDescRowData.TID; }	
	
	if (Type == "Add") {
		var SelNetOSItemTypeRowData = $("#tNetOrdSetsItemTypeWin").datagrid("getSelected");
		var pID = "";
		if ( SelNetOSItemTypeRowData ) { pID = SelNetOSItemTypeRowData.TID; }
		if (pID == "") { $.messager.alert("提示", "请先选择网上套餐项目类型!", "info"); return false; }
		
		var itemDesc = $("#NetSetsItemDescWin").val();
		if (itemDesc == "") { $.messager.alert("提示", "项目描述不能为空!", "info"); return false; }
				
		var sort = $("#NetSetsDescSortWin").numberbox("getValue");  // 序号
		if (sort == "") { $.messager.alert("提示", "序号不能为空!", "info"); return false; }
				
		Info = pID + "^" + itemDesc + "^" + sort;
		var SelNetOSItemDescRowData = $("#tNetOrdSetsItemDescWin").datagrid("getSelected");
		
		$.m({ClassName:"web.DHCPE.NetPre.OrdSetsInfo", MethodName:"SaveSetsItem", ID:"", StrInfo:Info},
			function(ret) {
				if (ret.split("^")[0] == "-1") {
					$.messager.alert("提示", "项目描述增加失败!", "info");
					return false;
				} else if (ret.split("^")[0] == "-2") { 
					$.messager.alert("提示", "项目描述增加失败!" + ret.split("^")[1], "info"); 
					return false; 
				//} else if (ret > 0) {
				} else {
					$.messager.alert("提示", "项目描述增加成功!", "info");
					$("#tNetOrdSetsItemDescWin").datagrid("insertRow", {
						index:0,
						row:{
							TID: ret,
							TDesc: itemDesc,
							TSort: sort, // 序号
						}
					});
					ClearNetOS("Desc");
					//ClearNetOS("Detail");
					//NetOSItemDetail(ret);
				}
			}
		);
	} else if (Type == "Del") {
		if ( TID == "" ) { $.messager.alert("提示","请先选择项目描述再进行删除操作！", "info"); return false; }
		$.messager.confirm("确认", "确定删除该项目描述？", function(r){
			if (r){
				$.m({ClassName:"web.DHCPE.NetPre.OrdSetsInfo", MethodName:"DeleteSetsItem", ID:TID},
					function(ret) { 
						if (ret == "0") {
							$.messager.alert("提示", "项目描述删除成功!", "info");
							NetOSItemDetail("");
							var CurSelRowData = $("#tNetOrdSetsItemDescWin").datagrid("getSelected");
							var CurSelRowIndex = $("#tNetOrdSetsItemDescWin").datagrid("getRowIndex", CurSelRowData);
							$("#tNetOrdSetsItemDescWin").datagrid("deleteRow", CurSelRowIndex);
							ClearNetOS("Detail");
						} else {
							$.messager.alert("提示", "项目描述删除失败!", "info");
							return false;
						}
					}
				);
			}
		});
	}
}

// 网上套餐细项描述
function NetOSItemDetail(ID) {
	$HUI.datagrid("#tNetOrdSetsItemDetailWin", {
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.NetPre.OrdSetsInfo",
			QueryName:"SearchSetsItemDetail",
			ParRef:ID
		},
		columns:[[
			{field:'TID', title:'TID', hidden:true},
			
			{field:'TDesc',title:'细项描述',width:30},
			{field:'TIntent',title:'检查目的',width:30},
			{field:'TSort',title:'序号'}
		]],
		collapsible: true, //收起表格的内容
		border:false,
		lines:true,
		striped:true, // 条纹化
		rownumbers:true,
		fit:true,
		fitColumns:true,
		animate:true,
		pagination:true,
		pageSize:25,
		pageList:[10,25,50,100],
		singleSelect:true,
		onClickRow: function (rowIndex, rowData) {  // 选择行事件 	
			
		},
		onLoadSuccess:function(data) {
		}
	});
}

// 网上套餐项目明细操作
function NetOSItemDetailOption(Type) {
	var TID = "";
	var SelNetOSItemDetailRowData = $("#tNetOrdSetsItemDetailWin").datagrid("getSelected");
	if (SelNetOSItemDetailRowData) {TID = SelNetOSItemDetailRowData.TID;}
	
	if (Type == "Add") {
		var pID = "";
		var SelNetOSItemDescRowData = $("#tNetOrdSetsItemDescWin").datagrid("getSelected");
		if ( SelNetOSItemDescRowData ) { pID = SelNetOSItemDescRowData.TID; }	
		if (pID == "") { $.messager.alert("提示", "请选择网上套餐项目描述!", "info"); return false; }
				
		var itemDetail = $("#NetSetsItemDetailWin").val();
		if (itemDetail == "") { $.messager.alert("提示", "细项描述不能为空!", "info"); return false; }
				
		var sort = $("#NetSetsDetailSortWin").numberbox("getValue");  // 序号
		if (sort == "") { $.messager.alert("提示", "序号不能为空!", "info"); return false; }
				
		var intent = $("#NetSetsDetailIntentWin").val();
		var Info = pID + "^" + itemDetail + "^" + intent + "^" + sort;
		
		$.m({ClassName:"web.DHCPE.NetPre.OrdSetsInfo", MethodName:"SaveSetsItemDetail", ID:"", StrInfo:Info},
			function(ret) {
				if (ret.split("^")[0] == "-1") {
					$.messager.alert("提示", "细项明细增加失败!", "info");
					return false;
				} else if (ret.split("^")[0] == "-2") { 
					$.messager.alert("提示", "细项明细增加失败!" + ret.split("^")[1], "info"); 
					return false; 
				//} else if (ret > 0) {
				} else {
					$.messager.alert("提示", "细项明细增加成功!", "info");
					$("#tNetOrdSetsItemDetailWin").datagrid("insertRow", {
						index:0,
						row:{
							TID: ret,
							TDesc: itemDetail,
							TIntent: intent,
							TSort: sort, // 序号
						}
					});
					ClearNetOS("Detail");
				}
			}
		);
	} else if (Type == "Del") {
		if ( TID == "" ) { $.messager.alert("提示","请先选择细项明细再进行删除操作！", "info"); return false; }
		$.messager.confirm("确认", "确定删除该细项明细？", function(r){
			if (r){
				$.m({ClassName:"web.DHCPE.NetPre.OrdSetsInfo", MethodName:"DeleteSetsItemDetail", ID:TID},
					function(ret) { 
						if (ret == "0") {
							$.messager.alert("提示", "细项明细删除成功!", "info");
							
							var CurSelRowData = $("#tNetOrdSetsItemDetailWin").datagrid("getSelected");
							var CurSelRowIndex = $("#tNetOrdSetsItemDetailWin").datagrid("getRowIndex", CurSelRowData);
							$("#tNetOrdSetsItemDetailWin").datagrid("deleteRow", CurSelRowIndex);
						} else {
							$.messager.alert("提示", "细项明细删除失败!", "info");
							return false;
						}
					}
				);
			}
		});
	}
}

function ClearNetOS(Type) {
	if (Type == "Type" || Type == "") {
		$("#NetSetsItemTypeWin").combobox('setValue',"");
		$("#NetSetsTypeSortWin").numberbox('setValue',"");
	}
	if (Type == "Desc" || Type == "") {
		$("#NetSetsItemDescWin").val("");
		$("#NetSetsDescSortWin").numberbox('setValue',"");
	}
	if (Type == "Detail" || Type == "") {
		$("#NetSetsItemDetailWin").val("");
		$("#NetSetsDetailSortWin").numberbox('setValue',"");
		$("#NetSetsDetailIntentWin").val("");
	}
}

// 网上套餐
function BSelWeb_click() {
	var SelOSRowData = $("#OrderSetsList").datagrid("getSelected");
	if ( !SelOSRowData ) { $.messager.alert("提示","请选择医嘱套再维护网上套餐！", "info"); return false; }
	var ARCOSRowid = SelOSRowData.ARCOSRowid;
	var lnk = "dhcpenetsetsmanager.csp?&HisSetsID=" + ARCOSRowid;

	window.open(lnk,"_blank","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,top=100,left=100,width=1200,height=700");
}

// ************************************************可用科室维护************************************************************************** //

// 初始化医嘱套可用科室表格
function InitARCOSLocDataGrid(ARCOSRowId){
	$HUI.datagrid("#OSLocTable",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.HISUIOrderSets",
			QueryName:"OrdSetsLocs",
			ARCOSRowId:ARCOSRowId
		},		
		columns:[[
			{field:'LocId', title:'科室ID', width:100},
			{field:'LocDesc', title:'科室描述', width:400}
		]],
		tatle:"体检医嘱套可用科室",
		striped:true, // 条纹化
		rownumbers:true,
		pagination:true,
		pageSize:15,
		pageList:[10,15,20,25,30,35,40],
		fit:true,
		fitColumns:true,
		singleSelect:true,
		toolbar: [],
		onLoadSuccess: function (data) {  },
		onClickRow: function (rowIndex, rowData) {  }      // 选择行事件  
	});
}

// ************************************************明细维护************************************************************************** //

// 初始化医嘱套明细表格
function InitARCOSDetailDataGrid(ARCOSRowid){
	$HUI.datagrid("#OrderSetsDetailList",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.HISUIOrderSets",
			QueryName:"SearchPEOrderSetsDetail",
			ARCOSRowid:ARCOSRowid,
			QueryFlag:"1",
			Type:"B",
			LocID:session['LOGON.CTLOCID'],
			hospId:session['LOGON.HOSPID']

		},		
		columns:[[
			{field:'ARCOSItemRowid', title:'ARCOSItemRowid', hidden:true},  // 项目明细ID
			{field:'ARCIMRowid', title:'ARCIMRowid', hidden:true},  // ARCIM
			{field:'ARCOSItemUOMDR' ,title:'ARCOSItemUOMDR', hidden:true},  // 单位
			{field:'ARCOSItemFrequenceDR', title:'ARCOSItemFrequenceDR', hidden:true},  // 频次
			{field:'ARCOSItemDurationDR', title:'ARCOSItemDurationDR', hidden:true},  // 疗程
			{field:'ARCOSItemInstructionDR', title:'ARCOSItemInstructionDR', hidden:true},  // 用法
			{field:'ARCOSItemCatDR', title:'ARCOSItemCatDR', hidden:true},  // 
			{field:'ARCOSItemSubCatDR', title:'ARCOSItemSubCatDR', hidden:true},  // 
			{field:'ARCOSItemOrderType', title:'ARCOSItemOrderType', hidden:true},  // 
			{field:'ARCOSDHCDocOrderTypeDR', title:'ARCOSDHCDocOrderTypeDR', hidden:true},  // 医嘱类型
			{field:'SampleID', title:'SampleID', hidden:true},  // 标本
			{field:'ITMSerialNo', title:'ITMSerialNo', hidden:true},  // 
			{field:'OrderPriorRemarksDR', title:'OrderPriorRemarksDR', hidden:true},  // 
			
			{field:'NO', title:'序号', align:'center', hidden:true},
			{field:'IsBreakable', title:'操作', align:'center',
				formatter:function(value,rowData,rowIndex){
					// icon-cancel
					return "<a href='#' onclick='UpdateDetail(\"" + rowData.ARCOSItemRowid + "\",\"" + rowIndex + "\")'>\<img style='' src='../scripts_lib/hisui-0.1.0/dist/css/icons/write_order.png' border=0/>\</a>"
						 + "<a href='#' onclick='DeleteDetail(\"" + rowData.ARCOSItemRowid + "\",\"" + rowData.ARCIMRowid + "\",\"" + rowIndex + "\",\"" + ARCOSRowid + "\")'>\<img style='padding-left:7px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/>\</a>"
						 ;
				}
			},
			{field:'ARCIMDesc',title:'名称'},
			{field:'ARCOSDHCDocOrderType',title:'医嘱类型',align:'center'},
			/*
			{field:'DHCDocOrdRecLoc',title:'接收科室',
				formatter:function(value,rowData,rowIndex){
					var arr=new Array();
					if (value.indexOf("-") > 0) {
						arr = value.split("-");
					}
					return arr[1];
				}
			},
			*/
			{field:'SampleDesc',title:'标本',align:'center'},
			{field:'ItmPrice',title:'价格',align:'right',
				formatter: function(value,rowData,rowIndex){
					var value = $.m({
						ClassName:"web.DHCPE.Handle.ARCItmMast",
						MethodName:"GetItmPrice",
						ARCIMRowid:rowData.ARCIMRowid,
					}, false);
					return parseFloat(value).toFixed(2);
				}
			},
			{field:'ARCOSItemQty',title:'数量',align:'center'},
			{field:'ARCOSItemBillUOM',title:'单位',align:'center'},
			{field:'ARCOSItemDoseQty',title:'剂量',align:'center'},
			{field:'ARCOSItemUOM',title:'剂量单位',align:'center'},
			{field:'ARCOSItemFrequence',title:'频次',align:'center'},
			{field:'ARCOSItemDuration',title:'疗程'},
			{field:'ARCOSItemInstruction',title:'用法'},
			{field:'ARCOSItmLinkDoctor',title:'关联'},
			{field:'Tremark',title:'备注'},
			{field:'OrderPriorRemarks',title:'附加说明'}
		]],
		tatle:"套餐项目明细",
		striped:true, // 条纹化
		rownumbers:true,
		pagination:true,
		pageSize:15,
		pageList:[10,15,20,25,30,35,40],
		fit:true,
		fitColumns:true,
		border:false,
		singleSelect:true,
		toolbar: [
		/**
		{
			iconCls: "icon-remove",
			text: "删除",
			handler: function() {
				BDelDetail_click();
			}
		},
		**/
		{
			iconCls: 'icon-arrow-top',
			text:'上移',
			handler: function(){
				var rowData = $('#OrderSetsDetailList').datagrid('getSelected');
				var rowIndex = $('#OrderSetsDetailList').datagrid('getRowIndex',rowData); 
				if (rowIndex >= 0){
					IMove(rowData,rowIndex,-1);
				} else {
					$.messager.alert("提示", "请选择一行进行移动！", "info");
				}
			}
		},{
			iconCls: 'icon-arrow-bottom',
			text:'下移',
			handler: function(){
				var rowData = $('#OrderSetsDetailList').datagrid('getSelected');
				var rowIndex = $('#OrderSetsDetailList').datagrid('getRowIndex',rowData); 
				if (rowIndex >= 0){
					IMove(rowData,rowIndex,1);
				} else {
					$.messager.alert("提示", "请选择一行进行移动！", "info");
				}
			}
		},{
			iconCls: 'icon-fee',
			text:'套餐定价',
			handler: function(){
				var SelRowData = $("#OrderSetsList").datagrid("getSelected");
				var SelRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelRowData);
				if ( !SelRowData ) { $.messager.alert("提示","请选择医嘱套再进行套餐定价！", "info"); return false; }
				if(SelRowData.BreakDesc=="可拆分"){
					$.messager.alert("提示","选择的医嘱套是可拆分的不能进行套餐定价！", "info"); 
					return false;
			    }

				ClearPrice();
				$("#OrderSetsPriceWin").show();

				var ARCOSDesc = SelRowData.ARCOSDesc;
				var AmtData = $.cm({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetOrdSetsAmount", ARCOSRowId:ARCOSRowid,Type:"B",LocID:session['LOGON.CTLOCID'],hospId:session['LOGON.HOSPID']}, false);
					
				if (AmtData.Amount <= 0) {
					$.messager.alert("提示","医嘱套原价格为零，不需要定价！","info");
					$("#OrderSetsPriceWin").window("close");
					return false;
				}
				
				$("#OSDescWin").val(ARCOSDesc);   // 套餐描述
				$("#OSAmountWin").val(AmtData.Amount);   // 套餐原价
				$("#OSPriceWin").val(AmtData.ARCOSPrice);   // 套餐定价
	       	
				var myWin = $HUI.dialog("#OrderSetsPriceWin", {
					iconCls:'icon-w-paid',
					resizable:true,
					title:'套餐定价',
					modal:true,
					buttonAlign:'center',
					buttons:[{
						text:'确定',
						handler:function(){
							UpdPrice();
						}
					},{
						text:'撤销',
						handler:function(){
							UndoPrice("1");
						}
					}]
				});				
			}
		},{}],
		onLoadSuccess: function (data) {
			InitToolbarForARCOSPrice(ARCOSRowid);
		},
		onClickRow: function (rowIndex, rowData) {  // 选择行事件     	
		}
	});
}

function InitDrugInfo(Id) {	
	// 剂量单位
	$HUI.combobox("#ItemUOMWin", {
		url:$URL+"?ClassName=web.DHCPE.HISUIOrderSets&QueryName=OrdSetsDrugsInfo&CombName=ItemDoseUOM&ARCIMRowid=" + Id + "&ResultSetType=array",
		valueField:'Id',
		textField:'Desc',
		defaultFilter:4
	});
	// 频次
	$HUI.combobox("#ItemFrequenceWin", {
		url:$URL+"?ClassName=web.DHCPE.HISUIOrderSets&QueryName=OrdSetsDrugsInfo&CombName=ItemFreq&ResultSetType=array",
		valueField:'Id',
		textField:'Desc',
		defaultFilter:4
	});
	// 用法
	$HUI.combobox("#ItemInstructionWin", {
		url:$URL+"?ClassName=web.DHCPE.HISUIOrderSets&QueryName=OrdSetsDrugsInfo&CombName=ItemInstruction&ResultSetType=array",
		valueField:'Id',
		textField:'Desc',
		defaultFilter:4
	});
	// 疗程
	$HUI.combobox("#ItemDurationWin", {
		url:$URL+"?ClassName=web.DHCPE.HISUIOrderSets&QueryName=OrdSetsDrugsInfo&CombName=ItemDuration&ResultSetType=array",
		valueField:'Id',
		textField:'Desc',
		defaultFilter:4
	});
	// 备注
	$HUI.combobox("#ItemRemarkWin", {
		url:$URL+"?ClassName=web.DHCPE.HISUIOrderSets&QueryName=OrdSetsDrugsInfo&CombName=Remark&ResultSetType=array",
		valueField:'Desc',
		textField:'Desc',
		defaultFilter:4
	});
	// 附加说明
	$HUI.combobox("#ItemPriorRemarksWin", {
		url:$URL+"?ClassName=web.DHCPE.HISUIOrderSets&QueryName=OrdSetsDrugsInfo&CombName=PriorRemarks&ResultSetType=array",
		valueField:'Id',
		textField:'Desc',
		defaultFilter:4
	});
}

function ItemClear(Data) {
	$("#ItemDescWin").val(Data.ARCIMDesc);
	$("#ItemDoseQtyWin").numberbox('setValue',Data.ARCOSItemDoseQty);
	$("#ItemUOMWin").combobox('setValue',Data.ARCOSItemUOMDR);
	$("#ItemFrequenceWin").combobox('setValue',Data.ARCOSItemFrequenceDR);
	$("#ItemInstructionWin").combobox('setValue',Data.ARCOSItemInstructionDR);
	$("#ItemDurationWin").combobox('setValue',Data.ARCOSItemDurationDR);
	$("#ItemLinkDoctorWin").val(Data.ARCOSItmLinkDoctor);
	$("#ItemRemarkWin").combobox('setValue',Data.Tremark);
	$("#ItemPriorRemarksWin").combobox('setValue',Data.OrderPriorRemarksDR);
}

function BDelDetail_click(){
	var SelOSRowData = $("#OrderSetsList").datagrid("getSelected");
	var ARCOSRowid = SelOSRowData.ARCOSRowid;
	if (ARCOSRowid != "") {
		var SelRowData = $("#OrderSetsDetailList").datagrid("getSelected");
		var SelRowIndex = $("#OrderSetsDetailList").datagrid("getRowIndex", SelRowData);
		if (SelRowData) {
			DeleteDetail(SelRowData.ARCOSItemRowid, SelRowData.ARCIMRowid, SelRowIndex, ARCOSRowid);
		} else { 
			$.messager.alert("提示","请选择一行进行删除！", "info");
			return false;
		}	
	} else {
		$.messager.alert("提示","没有选择医嘱套！","info");
		return false;
	}
}

function UpdateDetail(ItemRowid, curIndex) {
	// 判断是否药品医嘱
	var itemInfo = $.cm({ ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetOSItemData", OSItemId:ItemRowid}, false);
	if (itemInfo.ARCOSItemOrderType == "R") {
		$("#AddMedItemWin").show();
				
		InitDrugInfo(itemInfo.ARCIMRowid);
		ItemClear(itemInfo)
		
		var myWin = $HUI.dialog("#AddMedItemWin", {
			iconCls:'icon-w-plus',
			resizable:true,
			title:'药品信息',
			modal:true,
			onClose: function() {
				ItemClear("");
			},
			onOpen: function () {
			},
			buttonAlign:'center',
			buttons:[{
				text:'确定',
				handler:function(){
					var DoseQty = $("#ItemDoseQtyWin").val();
					var DoseUOM = $("#ItemUOMWin").combobox('getValue');
					var Frequence = $("#ItemFrequenceWin").combobox('getValue');
					var Instruction = $("#ItemInstructionWin").combobox('getValue');
					var Duration = $("#ItemDurationWin").combobox('getValue');
					var LinkDoctor = $("#ItemLinkDoctorWin").val();
					var remark = $("#ItemRemarkWin").combobox('getValue');
					var PriorRemarksDR = $("#ItemPriorRemarksWin").combobox('getValue');
					
					var itemStr = DoseQty + "^" + DoseUOM + "^" + Frequence + "^" + Instruction + "^" + Duration + "^" + LinkDoctor + "^" + remark + "^" + PriorRemarksDR;
					var data = $.m({
						ClassName:"web.DHCPE.HISUIOrderSets",
						MethodName:"UpdOSItemData",
						OSItemId:ItemRowid,
						Data:itemStr
					}, function (ret) {
						if (ret == "0") {
							$.messager.alert("提示","更新成功！","info");
							curIndex = parseInt(curIndex);
							var OSItemData=$.cm({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetOSItemData", OSItemId:ItemRowid}, false);
							$("#OrderSetsDetailList").datagrid("updateRow", {
								index:curIndex,
								row:{
									ARCOSItemUOMDR:OSItemData.ARCOSItemUOMDR,
									ARCOSItemFrequenceDR:OSItemData.ARCOSItemFrequenceDR,
									ARCOSItemDurationDR:OSItemData.ARCOSItemDurationDR,
									ARCOSItemInstructionDR:OSItemData.ARCOSItemInstructionDR,
									OrderPriorRemarksDR:OSItemData.OrderPriorRemarksDR,
									
									ARCOSItemDoseQty:OSItemData.ARCOSItemDoseQty,
									ARCOSItemUOM:OSItemData.ARCOSItemUOM,
									ARCOSItemFrequence:OSItemData.ARCOSItemFrequence,
									ARCOSItemDuration:OSItemData.ARCOSItemDuration,
									ARCOSItemInstruction:OSItemData.ARCOSItemInstruction,
									ARCOSItmLinkDoctor:OSItemData.ARCOSItmLinkDoctor,
									Tremark:OSItemData.Tremark,
									OrderPriorRemarks:OSItemData.OrderPriorRemarks
								}
							});
							ItemClear("");
							myWin.close();
						}
					});
					return data;
				}
			},{
				text:'取消',
				handler:function(){
					ItemClear("");
					myWin.close();
				}
			}]
		});
	} else {
		$.messager.alert("提示","非药品项目不需要修改！","info");
		return false;
	}
}

function DeleteDetail(ItemRowid, ARCIMRowid, ind, ARCOSRowid) {
	var amtflag = $.cm({ ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"IsHaveAmount", ARCOSRowid:ARCOSRowid}, false);
	if (amtflag == "1") {
		/*if ( confirm("该套餐已定价，若删除项目则会恢复原价，确认删除？")) {
			UndoPrice("0");
		} 
		*/
		$.messager.confirm("确认", "该套餐已定价，若删除项目则会恢复原价，确认删除？", function(r){
			if (r){
				UndoPrice("0");
				$.m({
					ClassName:"web.DHCARCOrdSets",
					MethodName:"DeleteItem",
					ARCOSItemRowid:ItemRowid,
					ARCIMRowid:ARCIMRowid
				}, function(ret) {
				if ( ret == 0 ) {
					$.messager.alert("提示","删除成功！", "info");
			
					$("#OrderSetsDetailList").datagrid("deleteRow", ind);
			
					var iPrice = $.cm({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"UpdateOSExPrice", ARCOSRowid:ARCOSRowid}, false);
					var SelOSRowData = $("#OrderSetsList").datagrid("getSelected");
					var SelOSRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelOSRowData);
			
					$("#OrderSetsList").datagrid("updateRow", {
						index: SelOSRowIndex,
						row:{
							OSExPrice: parseFloat(iPrice).toFixed(2)+"元",  // 价格
					}
				});
			
					InitToolbarForARCOSPrice(ARCOSRowid);
						
					SetRowStyle("#QryRisItemList");
					SetRowStyle("#QryLisItemList");
					SetRowStyle("#QryMedicalItemList");
					SetRowStyle("#QryOtherItemList");
				} else {
					$.messager.alert("提示","删除失败！", "info");
					$("#OrderSetsDetailList").datagrid('load',{ClassName:"web.DHCARCOrdSets",QueryName:"FindOSItem",ARCOSRowid:ARCOSRowid,QueryFlag:"1"}); 
				}
			});
	
		}else {
				return false;
			}
		});
	
		
	} else if (amtflag == "-1") {
		$.messager.alert("提示","非体检医嘱套，请核实！", "info");
		return false;
	} else {
		$.m({
			ClassName:"web.DHCARCOrdSets",
			MethodName:"DeleteItem",
			ARCOSItemRowid:ItemRowid,
			ARCIMRowid:ARCIMRowid
		}, function(ret) {
			if ( ret == 0 ) {
				$.messager.alert("提示","删除成功！", "info");
				
				$("#OrderSetsDetailList").datagrid("deleteRow", ind);
				
				var iPrice = $.cm({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"UpdateOSExPrice", ARCOSRowid:ARCOSRowid}, false);
				var SelOSRowData = $("#OrderSetsList").datagrid("getSelected");
				var SelOSRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelOSRowData);
				
				$("#OrderSetsList").datagrid("updateRow", {
					index: SelOSRowIndex,
					row:{
						OSExPrice: parseFloat(iPrice).toFixed(2)+"元",  // 价格
					}
				});
				
				InitToolbarForARCOSPrice(ARCOSRowid);
				
				SetRowStyle("#QryRisItemList");
				SetRowStyle("#QryLisItemList");
				SetRowStyle("#QryMedicalItemList");
				SetRowStyle("#QryOtherItemList");
			} else {
				$.messager.alert("提示","删除失败！", "info");
				$("#OrderSetsDetailList").datagrid('load',{ClassName:"web.DHCARCOrdSets",QueryName:"FindOSItem",ARCOSRowid:ARCOSRowid,QueryFlag:"1"}); 
			}
		});
	}
}

// 增加医嘱套明细
function IAdd(AddType,Id,AddAmount,Index,tablename){
	var ARCOSRowid="",ItemQty=1,DHCDocOrdRecLoc="",flag;
	
	var SelOSRowData = $("#OrderSetsList").datagrid("getSelected");
	if (SelOSRowData) { ARCOSRowid = SelOSRowData.ARCOSRowid; }  // 医嘱套ID
	else { $.messager.alert("提示","请选择医嘱套！", "info"); return false; }

	//判断是否存在排斥项目
	var ExcludeFlag=tkMakeServerCall("web.DHCPE.HISUIOrderSets","IsExcludeArcItem",ARCOSRowid,Id)
     if(ExcludeFlag=="1"){
	       $.messager.alert("提示","存在排斥项目，不允许添加","info");
           return false;
    }

	// 判断医嘱套中是否有该医嘱
	flag = $.m({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"IsHaveItemInOrdSets", ARCOSRowid:ARCOSRowid, ArcimRowId:Id}, false);
	if (flag == 1) { $.messager.alert("提示", "该项目已存在，请勿重复添加！", "info"); return false; }
	
	// 标本
	var SampleId = $.m({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetDefLabSpecId", ArcimRowId:Id}, false);
	// 0 单位   1 接收科室
	var rtn = $.cm({ ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetItemLocIdAndUOMId", ArcimRowId:Id}, false);

	DHCDocOrdRecLoc = rtn.RecLoc;
	if (DHCDocOrdRecLoc == "") {
		$.messager.confirm("确认", "该项目没有接收科室，确认添加？", function(r){
			if (r){
				var amtflag = $.cm({ ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"IsHaveAmount", ARCOSRowid:ARCOSRowid}, false);
				if (amtflag == "1") {
					$.messager.confirm("确认", "该套餐已定价，若再添加项目则会恢复原价，确认添加？", function(r){
						if (r){
							UndoPrice("0");
							IAddItem(SelOSRowData, ARCOSRowid, Id, SampleId, DHCDocOrdRecLoc)
						}
					});	
				} else if (amtflag == "-1") {
					$.messager.alert("提示","非体检医嘱套，请核实！", "info");
					return false;
				} else {
					IAddItem(SelOSRowData, ARCOSRowid, Id, SampleId, DHCDocOrdRecLoc)
				}
				
			}
		});
	} else {
		var amtflag = $.cm({ ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"IsHaveAmount", ARCOSRowid:ARCOSRowid}, false);
		if (amtflag == "1") {
			$.messager.confirm("确认", "该套餐已定价，若再添加项目则会恢复原价，确认添加？", function(r){
				if (r){
					UndoPrice("0");
					IAddItem(SelOSRowData, ARCOSRowid, Id, SampleId, DHCDocOrdRecLoc)
				}
			});	
		} else if (amtflag == "-1") {
			$.messager.alert("提示","非体检医嘱套，请核实！", "info");
			return false;
		} else {
			IAddItem(SelOSRowData, ARCOSRowid, Id, SampleId, DHCDocOrdRecLoc)
		}
	}
}

function IAddItem(SelOSRowData, ARCOSRowid, Id, SampleId, DHCDocOrdRecLoc) {
	// 判断是否药品医嘱
	var itemInfo = $.cm({ ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetItemTypeAndDesc", ARCIMRowid:Id}, false);
	if (itemInfo.ItemOrderType == "R") {
		$("#AddMedItemWin").show();
						
		InitDrugInfo(Id);
						
		$("#ItemDescWin").val(itemInfo.ARCIMDesc);
						
		var myWin = $HUI.dialog("#AddMedItemWin", {
			iconCls:'icon-w-plus',
			resizable:true,
			title:'药品信息',
			modal:true,
			onClose: function() {
				ItemClear("");
			},
			onOpen: function () {
			},
			buttonAlign:'center',
			buttons:[{
				text:'确定',
				handler:function(){
					ItemDoseQty = $("#ItemDoseQtyWin").val();
					ItemDoseUOMID = $("#ItemUOMWin").combobox('getValue');
					ItemFrequenceID = $("#ItemFrequenceWin").combobox('getValue');
					ItemInstructionID = $("#ItemInstructionWin").combobox('getValue');
					ItemDurationID = $("#ItemDurationWin").combobox('getValue');
					ItmLinkDoctor = $("#ItemLinkDoctorWin").val();
					remark = $("#ItemRemarkWin").combobox('getValue');
					OrderPriorRemarksDR = $("#ItemPriorRemarksWin").combobox('getValue');
					
					var data = $.m({
						ClassName:"web.DHCARCOrdSets",
						MethodName:"InsertItem",
						ARCOSRowid:ARCOSRowid,
						ARCIMRowid:Id,
						ItemQty:1,
						ItemDoseQty:ItemDoseQty,
						ItemDoseUOMID:ItemDoseUOMID,
						ItemFrequenceID:ItemFrequenceID,
						ItemDurationID:ItemDurationID,
						ItemInstructionID:ItemInstructionID,
						ItmLinkDoctor:ItmLinkDoctor,
						remark:remark,
						DHCDocOrderTypeID:3,  // ^OECPR  3  临时医嘱
						SampleId:SampleId,
						ARCOSItemNO:"",
						OrderPriorRemarksDR:OrderPriorRemarksDR,
						DHCDocOrderRecLoc:DHCDocOrdRecLoc
					}, function (ret) {
						//$("#OrderSetsDetailList").datagrid('load',{ClassName:"web.DHCARCOrdSets",QueryName:"FindOSItem",ARCOSRowid:ARCOSRowid,QueryFlag:"1"}); 
						//return ret;
						if (ret.indexOf("||") > 0) {
							var OSItemData=$.cm({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetOSItemData", OSItemId:ret}, false);
							$("#OrderSetsDetailList").datagrid("insertRow", {
								index:(OSItemData.ITMSerialNo - 1),
								row:{
									ARCOSItemRowid:OSItemData.ARCOSItemRowid,
									ARCIMRowid:OSItemData.ARCIMRowid,
									ARCOSItemUOMDR:OSItemData.ARCOSItemUOMDR,
									ARCOSItemFrequenceDR:OSItemData.ARCOSItemFrequenceDR,
									ARCOSItemDurationDR:OSItemData.ARCOSItemDurationDR,
									ARCOSItemInstructionDR:OSItemData.ARCOSItemInstructionDR,
									ARCOSItemCatDR:OSItemData.ARCOSItemCatDR,
									ARCOSItemSubCatDR:OSItemData.ARCOSItemSubCatDR,
									ARCOSItemOrderType:OSItemData.ARCOSItemOrderType,
									ARCOSDHCDocOrderTypeDR:OSItemData.ARCOSDHCDocOrderTypeDR,
									SampleID:OSItemData.SampleID,
									ITMSerialNo:OSItemData.ITMSerialNo,
									OrderPriorRemarksDR:OSItemData.OrderPriorRemarksDR,
									NO:OSItemData.ITMSerialNo,
									ARCIMDesc:OSItemData.ARCIMDesc,
									ARCOSDHCDocOrderType:OSItemData.ARCOSDHCDocOrderType,
									//DHCDocOrdRecLoc:OSItemData.DHCDocOrdRecLoc,
									SampleDesc:OSItemData.SampleDesc,
									ItmPrice:OSItemData.ItmPrice,
									ARCOSItemQty:OSItemData.ARCOSItemQty,
									ARCOSItemBillUOM:OSItemData.ARCOSItemBillUOM,
									ARCOSItemDoseQty:OSItemData.ARCOSItemDoseQty,
									ARCOSItemUOM:OSItemData.ARCOSItemUOM,
									ARCOSItemFrequence:OSItemData.ARCOSItemFrequence,
									ARCOSItemDuration:OSItemData.ARCOSItemDuration,
									ARCOSItemInstruction:OSItemData.ARCOSItemInstruction,
									ARCOSItmLinkDoctor:OSItemData.ARCOSItmLinkDoctor,
									Tremark:OSItemData.Tremark,
									OrderPriorRemarks:OSItemData.OrderPriorRemarks
								}
							});
							
							var OSPrice = $.cm({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"UpdateOSExPrice", ARCOSRowid:ARCOSRowid}, false);
							var SelOSRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelOSRowData);
							$("#OrderSetsList").datagrid("updateRow", {
								index: SelOSRowIndex,
								row:{
									OSExPrice:parseFloat(OSPrice).toFixed(2)+"元",  // 价格
								}
							});
							InitToolbarForARCOSPrice(ARCOSRowid);
							
							SetRowStyle("#QryRisItemList");
							SetRowStyle("#QryLisItemList");
							SetRowStyle("#QryMedicalItemList");
							SetRowStyle("#QryOtherItemList");
							ItemClear("");
							myWin.close();
						}
					});
					return data;
				}
			},{
				text:'取消',
				handler:function(){
					ItemClear("");
					myWin.close();
				}
			}]
		});
	} else {
		var data = $.m({
			ClassName:"web.DHCARCOrdSets",
			MethodName:"InsertItem",
			ARCOSRowid:ARCOSRowid,
			ARCIMRowid:Id,
			ItemQty:1,
			ItemDoseQty:"",
			ItemDoseUOMID:"",
			ItemFrequenceID:"",
			ItemDurationID:"",
			ItemInstructionID:"",
			ItmLinkDoctor:"",
			remark:"",
			DHCDocOrderTypeID:3,  // ^OECPR  3  临时医嘱
			SampleId:SampleId,
			ARCOSItemNO:"",
			OrderPriorRemarksDR:"",
			DHCDocOrderRecLoc:DHCDocOrdRecLoc
		}, function (ret) {
			//$("#OrderSetsDetailList").datagrid('load',{ClassName:"web.DHCARCOrdSets",QueryName:"FindOSItem",ARCOSRowid:ARCOSRowid,QueryFlag:"1"}); 
			//return ret;
			if (ret.indexOf("||") > 0) {
				var OSItemData=$.cm({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetOSItemData", OSItemId:ret}, false);
				$("#OrderSetsDetailList").datagrid("insertRow", {
					index:(OSItemData.ITMSerialNo - 1),
					row:{
						ARCOSItemRowid:OSItemData.ARCOSItemRowid,
						ARCIMRowid:OSItemData.ARCIMRowid,
						ARCOSItemUOMDR:OSItemData.ARCOSItemUOMDR,
						ARCOSItemFrequenceDR:OSItemData.ARCOSItemFrequenceDR,
						ARCOSItemDurationDR:OSItemData.ARCOSItemDurationDR,
						ARCOSItemInstructionDR:OSItemData.ARCOSItemInstructionDR,
						ARCOSItemCatDR:OSItemData.ARCOSItemCatDR,
						ARCOSItemSubCatDR:OSItemData.ARCOSItemSubCatDR,
						ARCOSItemOrderType:OSItemData.ARCOSItemOrderType,
						ARCOSDHCDocOrderTypeDR:OSItemData.ARCOSDHCDocOrderTypeDR,
						SampleID:OSItemData.SampleID,
						ITMSerialNo:OSItemData.ITMSerialNo,
						OrderPriorRemarksDR:OSItemData.OrderPriorRemarksDR,
						NO:OSItemData.ITMSerialNo,
						ARCIMDesc:OSItemData.ARCIMDesc,
						ARCOSDHCDocOrderType:OSItemData.ARCOSDHCDocOrderType,
						//DHCDocOrdRecLoc:OSItemData.DHCDocOrdRecLoc,
						SampleDesc:OSItemData.SampleDesc,
						ItmPrice:OSItemData.ItmPrice,
						ARCOSItemQty:OSItemData.ARCOSItemQty,
						ARCOSItemBillUOM:OSItemData.ARCOSItemBillUOM,
						ARCOSItemDoseQty:OSItemData.ARCOSItemDoseQty,
						ARCOSItemUOM:OSItemData.ARCOSItemUOM,
						ARCOSItemFrequence:OSItemData.ARCOSItemFrequence,
						ARCOSItemDuration:OSItemData.ARCOSItemDuration,
						ARCOSItemInstruction:OSItemData.ARCOSItemInstruction,
						ARCOSItmLinkDoctor:OSItemData.ARCOSItmLinkDoctor,
						Tremark:OSItemData.Tremark,
						OrderPriorRemarks:OSItemData.OrderPriorRemarks
					}
				});
				
				var OSPrice = $.cm({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"UpdateOSExPrice", ARCOSRowid:ARCOSRowid}, false);
				var SelOSRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelOSRowData);
				$("#OrderSetsList").datagrid("updateRow", {
					index: SelOSRowIndex,
					row:{
						OSExPrice:parseFloat(OSPrice).toFixed(2)+"元",  // 价格
					}
				});
				InitToolbarForARCOSPrice(ARCOSRowid);
				
				SetRowStyle("#QryRisItemList");
				SetRowStyle("#QryLisItemList");
				SetRowStyle("#QryMedicalItemList");
				SetRowStyle("#QryOtherItemList");
				
				return data;
			}
		});
	}
}

// 移动  flag -1 上移   1 下移
function IMove(Data,Index,flag) {
	var ARCOSRowid="";
	
	var SelOSRowData = $("#OrderSetsList").datagrid("getSelected");
	if (SelOSRowData) { ARCOSRowid = SelOSRowData.ARCOSRowid; }  // 医嘱套ID
	else { $.messager.alert("提示","请选择医嘱套！", "info");return false; }
	if (ARCOSRowid == "") { $.messager.alert("提示","请选择医嘱套！", "info");return false; }
	if (Data) {
		// 当前行序号和ID
		if (Data.ITMSerialNo != "") { var toup = Data.ITMSerialNo; }
		else { return false; }
		if (Data.ARCOSItemRowid != "") { var upid = Data.ARCOSItemRowid; }
		else { return false; }
		
		var changeRowData = $('#OrderSetsDetailList').datagrid('getRows');
		if( !changeRowData[Index + flag] ) return false;
		var rowData = changeRowData[Index + flag];
		
		// 交换行的序号和ID
		if (rowData.ITMSerialNo != "") { var todown = rowData.ITMSerialNo; }
		else { return false; }
		if (rowData.ARCOSItemRowid != "") { var downid = rowData.ARCOSItemRowid; }
		else { return false; }
		
        UpdateSerialNO(downid,toup);
        UpdateSerialNO(upid,todown);
        
        $("#OrderSetsDetailList").datagrid('load',{ClassName:"web.DHCARCOrdSets",QueryName:"FindOSItem",ARCOSRowid:ARCOSRowid,QueryFlag:"1"}); 
	}
}

// 更新序列
function UpdateSerialNO(ARCOSItemRowid,SerNO) {
	$.m({
		ClassName:"web.DHCPE.HISUIOrderSets",
		MethodName:"UpdateItemSerialNo",
		ARCOSItemRowid:ARCOSItemRowid,
		ItemSerialNo:SerNO,
		ArcimId:""
	},function(rtn){
		
	});
	///var rtn=tkMakeServerCall("web.DHCARCOrdSets","UpdateItemSerialNo",ARCOSItemRowid,SerNO,arcimid)


	//tkMakeServerCall("web.DHCARCOrdSets","UpdateItemSerialNo",ARCOSItemRowid,SerNO)
}


// 明细菜单栏中显示套餐价格
function InitToolbarForARCOSPrice(ARCOSRowid) {
	if (ARCOSRowid == "") return "";
	var AmtData = $.cm({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetOrdSetsAmount",ARCOSRowId:ARCOSRowid,Type:"B",LocID:session['LOGON.CTLOCID'],hospId:session['LOGON.HOSPID']}, false);
	$("#OSAmountWin").val(AmtData.Amount);   // 套餐原价
	$("#OSPriceWin").val(AmtData.ARCOSPrice);   // 套餐定价
				
	var gridToolbar = $("#OrderSetsDetailDiv .datagrid-toolbar table tr td:nth-child(4)");
	gridToolbar.empty();
	gridToolbar.append("<span>原价：</span><span style='font-size:14px;color:brown;font-weight:700;'>" + AmtData.Amount + "</span>元&nbsp;&nbsp;售价：</span><span style='font-size:14px;color:red;font-weight:700;'>" + AmtData.ARCOSPrice + "</span>元</span>");
}

// ************************************************价格维护************************************************************************** //

// 套餐定价
function UpdPrice() {
	var obj, Date = "", Price = "", ARCOSRowid = "", ARCOSAmount = "";
	
	var SelRowData = $("#OrderSetsList").datagrid("getSelected");
	var SelRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelRowData);
	if ( !SelRowData ) { $.messager.alert("提示","请选择体检医嘱套再进行套餐定价！","info"); return false; }
	ARCOSRowid = SelRowData.ARCOSRowid;
	
	if ($("#OSDateWin").val() != "") { Date = $("#OSDateWin").val(); }
	else { $.messager.alert("提示","当前日期为空，请刷新界面","info"); return false; }

	if ($("#OSAmountWin").val() != "") { ARCOSAmount = $("#OSAmountWin").val(); }

		
	if (($("#OSAmtWin").val() == "") && (($("#OSDiscountWin").val() == ""))) {
		$.messager.alert("提示","请输入 销售定价 或 销售折扣.","info");
		return false;
	} else {
		if ($("#OSAmtWin").val() != "") {
			Price_change("Amt");
		} else {
			Price_change("Dis");
		}
	}
	
	if ($("#OSAmtWin").val() != "") { Price=$("#OSAmtWin").val(); } 
		
	var MoneyF = /(^[1-9]([0-9]+)?(\.[0-9]{1,2})?$)|(^(0){1}$)|(^[0-9]\.[0-9]([0-9])?$)/;
	if (($("#OSAmtWin").val() != "") && (!MoneyF.test(Price))) {
		$.messager.alert("提示","请输入正确金额.","info");
		return false;
	}
	
	$.m({  // var rtn = tkMakeServerCall("web.DHCPE.OrderSets","UpdateARCOSPrice",ARCOSRowid,Date,Date,Price,"");
		ClassName:"web.DHCPE.HISUIOrderSets",
		MethodName:"UpdateARCOSPrice",
		ARCOSRowid:ARCOSRowid,
		DateFrom:Date,
		DateTo:Date,
		Price:Price,
		Amount:ARCOSAmount
	}, function(rtn) {
		if (rtn == "0") {
			$.messager.alert("提示","套餐价格更新成功！","info");
			
			//var OSExData=$.cm({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetARCOSData", ARCOSRowid:ARCOSRowid}, false);
			
			$("#OrderSetsList").datagrid("updateRow", {
				index: SelRowIndex,
				row:{
					OSExPrice:Price+"元", // OSExData.OSExPrice,  // 价格
				}
			});
			InitToolbarForARCOSPrice(ARCOSRowid);
			$("#OrderSetsPriceWin").window("close");
			
		} else {
			$.messager.alert("提示","套餐价格更新失败！"+rtn,"info");
		}
	});
	ClearPrice();
}

// 还原价格
function UndoPrice(Flag) {
	var ARCOSRowid = "", ARCOSAmount = 0;
	
	var SelRowData = $("#OrderSetsList").datagrid("getSelected");
	var SelRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelRowData);
	if ( !SelRowData) { $.messager.alert("提示","请选择医嘱套再进行套餐定价！","info"); return false; }
	ARCOSRowid = SelRowData.ARCOSRowid;
	if ($("#OSAmountWin").val() != "") { ARCOSAmount = $("#OSAmountWin").val(); }
	$.m({  // var rtn = tkMakeServerCall("web.DHCPE.OrderSets","UpdateARCOSPrice",ARCOSRowid,"","","","");
		ClassName:"web.DHCPE.HISUIOrderSets",
		MethodName:"UpdateARCOSPrice",
		ARCOSRowid:ARCOSRowid,
		DateFrom:"",
		DateTo:"",
		Price:""
	}, function(rtn) {
		if (rtn == "0") {
			if (Flag == "1") {
				$.messager.alert("提示","套餐价格还原成功！","info");

				$("#OrderSetsList").datagrid("updateRow", {
					index: SelRowIndex,
					row:{
						OSExPrice:ARCOSAmount+"元", // OSExData.OSExPrice,  // 价格
					}
				});
				
				InitToolbarForARCOSPrice(ARCOSRowid);
				$("#OrderSetsPriceWin").window("close");
			}
		} else {
			$.messager.alert("提示","套餐价格还原失败！"+rtn,"info");
		}
	});	
	ClearPrice();
}

function Price_change(type) {
	var Price = "", Discount = "";
	var userId = session["LOGON.USERID"];
	if ($("#OSAmountWin").val() > 0) {
		
		var ARCOSAmount = $("#OSAmountWin").val();
		
		if (type == "Amt") {
			if ($("#OSAmtWin").val() != "") {
				Price = $("#OSAmtWin").val();
			}
			if (isNaN(Price)) {
				$.messager.alert("提示","请输入正确价格！","info");
				$("#OSAmtWin").val("");		
				return false;
			}
			$("#OSDiscountWin").val("");
			Discount = (Price / ARCOSAmount * 100).toFixed(2);
			$("#OSDiscountWin").val(Discount);
		} else {	
			if ($("#OSDiscountWin").val() != "") {
				Discount = $("#OSDiscountWin").val();
			}
			if (isNaN(Discount)) {
				$.messager.alert("提示","请输入正确折扣！","info");
				$("#OSDiscountWin").val("");
				return false;
			}
			$("#OSAmtWin").val("");
			Price = (Discount / 100 * ARCOSAmount ).toFixed(2);
			$("#OSAmtWin").val(Price);			
		}
		
		var Dflag = UserDiscount(userId,Discount);
		if (Dflag == 0) { ClearPrice();return false; }
		
	} else {
		$.messager.alert("提示","医嘱套原价格为零，不需要定价！","info");
	}
}

function UserDiscount(userId,Discount) {
	var DFLimit = $.m({ClassName:"web.DHCPE.ChargeLimit", MethodName:"DFLimit", UserId:userId}, false);
	// DFLimit=tkMakeServerCall("web.DHCPE.ChargeLimit","DFLimit",userId);   // 取UserId的最大折扣率
	
	if (DFLimit==0) {
		ClearPrice();
		$.messager.alert("提示", "没有打折权限", "info");
	    return 0;
	}
	if (+DFLimit>+Discount) {
		ClearPrice();
		$.messager.alert("提示", "权限不足,您的折扣权限为:"+DFLimit+"%", "info");
		return 0;
	}
	return 1;
}

function ClearPrice() {
	$("#OSAmtWin").numberbox('setValue',"");
	$("#OSDiscountWin").numberbox('setValue',"");
}

// ************************************************项目维护************************************************************************** //

// 初始化项目详情表格
function InitItemDataGrid(tablename,type) {
	$HUI.datagrid(tablename,{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.StationOrder",
			QueryName:"StationOrderList",
			Type:type,
			TargetFrame:"PreItemList",
			PreIADMID:"", 
			StationID:"",
			BType:"B",
			LocID:session['LOGON.CTLOCID'],
			hospId:session['LOGON.HOSPID']
		},
		columns:[[
			{field:'TUOM', title:'单位', hidden:true},
			
			{field:'STORD_ARCIM_DR', title:'操作', align:'center', formatter:function(value,row,index) {
					return "<a href='#' onclick='IAdd(\"ITEM\", \"" + value + "\", \"" + row.STORD_ARCIM_Price + "\", \"" + index + "\", \"" + tablename + "\")'>\
					<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' border=0/>\
					</a>";
				}
			},
			{field:'STORD_ARCIM_Code', title:'编码', width:15},
			{field:'STORD_ARCIM_Desc', title:'名称', width:55},
			{field:'STORD_ARCIM_Price', title:'价格', align:'right', width:8, formatter:function(value,row,index) {
					return parseFloat(value).toFixed(2);
				}
			},
			{field:'TLocDesc',title:'站点', width:15}
		]],
		striped:true, // 条纹化
		pagination:true,
		pageSize:25,
		pageList:[10,25,50,100],
		fit:true,
		border:false,
		fitColumns:true,
		singleSelect:true,
		//toolbar: [],
		rowStyler: function(rowIndex,rowData) {
			//return SetRowStyle(rowIndex,rowData,tablename);  
        },
		onDblClickRow:function(rowIndex,rowData){
			var ItemType = "ITEM";
			var ItemId = rowData.STORD_ARCIM_DR;
			var AddAmount = rowData.STORD_ARCIM_Price;
			
			IAdd(ItemType, ItemId, AddAmount, rowIndex, tablename);
			
			var obj = $(tablename).datagrid('getSelections');
			var selobj = $(tablename).datagrid("selectRecord",rowData.STORD_ARCIM_DR);
			selobj.css("background","#ccc");
		},
		onLoadSuccess: function (data) {
			SetRowStyle(tablename);
		},
		onClickRow: function (rowIndex, rowData) {  // 选择行事件     	
		}
	});
}

function InitOrdSetsDataGrid(tablename,type) {
	var ARCOSRowid = "";
	var SelRowData = $("#OrderSetsList").datagrid("getSelected");
	if ( SelRowData ) ARCOSRowid = SelRowData.ARCOSRowid;
	
	$HUI.datagrid(tablename,{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.HISUIOrderSets",
			QueryName:"SearchPECanCopyOS",
			ARCOSRowid:ARCOSRowid,
			Desc:$("#OrdSets").val(),
			Type:type,
			LocID:session['LOGON.CTLOCID'],
			HospID:session['LOGON.HOSPID']
		},
		columns:[[
			{field:'OSExSex', title:'OSExSex', hidden:true},
			{field:'OSExVIPLevel', title:'OSExVIPLevel', hidden:true},
			{field:'OSExLoc', title:'OSExLoc', hidden:true},
			
			{field:'ARCOSRowid', title:'操作', align:'center', formatter:function(value,row,index) {
					return "<a href='#' onclick='ShowCopyOrdSetsItem(\"" + row.ARCOSRowid + "\")'>\
					<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' border=0/>\
					</a>";
				}
			},
			{field:'ARCOSDesc', title:'套餐名称', width:35},
			{field:'SexDesc', title:'性别', align:'center'},
			{field:'VIPDesc', title:'VIP等级', width:30},
			{field:'LocDesc',title:'可用科室', width:30},
			{field:'OSExPrice',title:'售价', align:'right'}
		]],
		striped:true, // 条纹化
		pagination:true,
		pageSize:25,
		pageList:[10,25,50,100],
		fit:true,
		border:false,
		fitColumns:true,
		singleSelect:true,
		onDblClickRow:function(rowIndex,rowData){
			ShowCopyOrdSetsItem(rowData.ARCOSRowid);
		},
		onClickRow: function (rowIndex, rowData) {  // 选择行事件     	
		}
	});
}

function SetRowStyle(tablename) {
	
	var SelRowData = $("#OrderSetsList").datagrid("getSelected");
//	//var SelRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelRowData);
	if ( SelRowData ) {
		var ARCOSRowid = SelRowData.ARCOSRowid;
		
		var rows = $(tablename).datagrid("getRows");
		for(var i=0;i<rows.length;i++) {
			var tableDiv = tablename.replace(/List/g, "Div");
			var gridTrbar = $(tableDiv+" .datagrid-btable tbody tr:nth-child(" + ( i + 1 ) + ")");
			if (gridTrbar) {
				var flag = $.m({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"IsHaveItemInOrdSets", ARCOSRowid:ARCOSRowid, ArcimRowId:rows[i].STORD_ARCIM_DR}, false);
				if (flag == "1") {
					gridTrbar.css("background-color", "#CCCCCC");
				} else if ( (i % 2) == 0) {
					gridTrbar.css("background-color", "#FAFAFA");
				} else {
					gridTrbar.css("background-color", "#FFFFFF");
				}
				//return "background-color:#ccc;";
			}
		}
	}
}

// 显示套餐项目
function ShowCopyOrdSetsItem(id) {
	var SelRowData = $("#OrderSetsList").datagrid("getSelected");
	if ( SelRowData ) {
		var ARCOSRowid = SelRowData.ARCOSRowid;
		$("#CopyOSItemWin").show();
		
		$HUI.datagrid("#CopyOSItemList",{
			url:$URL,
			queryParams:{
				ClassName:"web.DHCPE.HISUIOrderSets",
				QueryName:"SearchPEOrderSetsDetail",
				ARCOSRowid:id,
				QueryFlag:"1",
				Type:"B",
				LocID:session['LOGON.CTLOCID'],
				hospId:session['LOGON.HOSPID']
			},		
			columns:[[
				{field:'ARCOSItemRowid', title:'ARCOSItemRowid', checkbox:true},  // ,hidden:true},  // 项目明细ID
				//{field:'ARCIMRowid', title:'ARCIMRowid', hidden:true},  // ARCIM
				//{field:'ARCOSItemUOMDR' ,title:'ARCOSItemUOMDR', hidden:true},  // 单位
				//{field:'ARCOSItemFrequenceDR', title:'ARCOSItemFrequenceDR', hidden:true},  // 频次
				//{field:'ARCOSItemDurationDR', title:'ARCOSItemDurationDR', hidden:true},  // 疗程
				//{field:'ARCOSItemInstructionDR', title:'ARCOSItemInstructionDR', hidden:true},  // 用法
				//{field:'ARCOSItemCatDR', title:'ARCOSItemCatDR', hidden:true},  // 
				//{field:'ARCOSItemSubCatDR', title:'ARCOSItemSubCatDR', hidden:true},  // 
				//{field:'ARCOSItemOrderType', title:'ARCOSItemOrderType', hidden:true},  // 
				//{field:'ARCOSDHCDocOrderTypeDR', title:'ARCOSDHCDocOrderTypeDR', hidden:true},  // 医嘱类型
				//{field:'SampleID', title:'SampleID', hidden:true},  // 标本
				//{field:'ITMSerialNo', title:'ITMSerialNo', hidden:true},  // 
				//{field:'OrderPriorRemarksDR', title:'OrderPriorRemarksDR', hidden:true},  // 
				
				//{field:'NO', title:'序号', align:'center', hidden:true},
				{field:'ARCIMDesc',title:'名称'},
				{field:'ARCOSDHCDocOrderType',title:'医嘱类型',align:'center'},
				{field:'SampleDesc',title:'标本',align:'center'},
				{field:'ItmPrice',title:'价格',align:'right',
					formatter: function(value,rowData,rowIndex){
						var value = $.m({
							ClassName:"web.DHCPE.Handle.ARCItmMast",
							MethodName:"GetItmPrice",
							ARCIMRowid:rowData.ARCIMRowid,
						}, false);
						return parseFloat(value).toFixed(2);
					}
				},
				{field:'ARCOSItemQty',title:'数量',align:'center'},
				{field:'ARCOSItemBillUOM',title:'单位',align:'center'},
				{field:'ARCOSItemDoseQty',title:'剂量',align:'center'},
				{field:'ARCOSItemUOM',title:'剂量单位',align:'center'},
				{field:'ARCOSItemFrequence',title:'频次',align:'center'},
				{field:'ARCOSItemDuration',title:'疗程'},
				{field:'ARCOSItemInstruction',title:'用法'},
				{field:'ARCOSItmLinkDoctor',title:'关联'},
				{field:'Tremark',title:'备注'},
				{field:'OrderPriorRemarks',title:'附加说明'}
			]],
			tatle:"套餐项目明细",
			striped:true, // 条纹化
			rownumbers:true,
			singleSelect:false,
			pagination:true,
			pageSize:25,
			pageList:[10,25,40,100],
			fit:true,
			fitColumns:true,
			border:false,
			//toolbar: [],
			onLoadSuccess: function (data) {
				if (data) {
					$.each(data.rows, function (index, item) {
						var value = $.m({
							ClassName:"web.DHCPE.HISUIOrderSets",
							MethodName:"IsHaveItemInOrdSets",
							ARCOSRowid:ARCOSRowid,
							ArcimRowId:item.ARCIMRowid
						}, false);
						if (value == "0") {
	                        $("#CopyOSItemList").datagrid('checkRow', index);
						} else {
		                    $("#CopyOSItemDiv [type='checkbox']")[0].disabled = true;
		                    $("#CopyOSItemDiv [type='checkbox']")[index + 1].disabled = true;
	                    }
	                });
				}
			},
			onClickRow: function (rowIndex, rowData) {  // 选择行事件
				if ($("#CopyOSItemDiv [type='checkbox']")[rowIndex + 1].disabled) {
					$("#CopyOSItemDiv [type='checkbox']")[rowIndex + 1].checked = false;
					$("#CopyOSItemDiv [type='checkbox']")[0].checked = false;
					$("#CopyOSItemList").datagrid("unselectRow", rowIndex);
					return false;
				}
			}
		});
		
		var myWin = $HUI.dialog("#CopyOSItemWin", {
			iconCls:'icon-copy',
			resizable:true,
			title:'复制套餐项目',
			modal:true,
			onClose: function() {
				$("#BCopyOSItem").unbind("click");
			},
			onOpen: function() {
				$("#BCopyOSItem").click(function() {
					BCopyOSItem_click(ARCOSRowid);
			    });
			}
		});
	}
}

// 复制套餐项目
function BCopyOSItem_click(selRowid) {
	var rowsData = $("#CopyOSItemList").datagrid("getSelections");
	if (rowsData) {
		var ArcimInfo = "";
		for(var rowIndex in rowsData){
			if (ArcimInfo == "") {
				ArcimInfo = rowsData[rowIndex].ARCOSItemRowid;
			} else {
				ArcimInfo = ArcimInfo + "^" +rowsData[rowIndex].ARCOSItemRowid;
			}
		}
		if (ArcimInfo != "") {
			var amtflag = $.cm({ ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"IsHaveAmount", ARCOSRowid:selRowid}, false);
			if (amtflag == "1") {
				$.messager.confirm("确认", "该套餐已定价，若再添加项目则会恢复原价，确认添加？", function(r){
					if (r){
						UndoPrice("0");
						var rtn = $.m({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"BatchUpdateUserARCOS", ARCOSRowid:selRowid, ArcimInfo:ArcimInfo}, false);
						if (rtn == "1") {
							$.messager.alert("提示", "复制成功", "info");
							$("#OrderSetsDetailList").datagrid("reload");
							$("#CopyOSItemWin").window("close");
						}
					}
				});	
			} else if (amtflag == "-1") {
				$.messager.alert("提示","非体检医嘱套，请核实！", "info");
				return false;
			} else {
				var rtn = $.m({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"BatchUpdateUserARCOS", ARCOSRowid:selRowid, ArcimInfo:ArcimInfo}, false);
			
				if (rtn == "1") {
					$.messager.alert("提示", "复制成功", "info");
					$("#OrderSetsDetailList").datagrid("reload");
					$("#CopyOSItemWin").window("close");
				}
			}
		} else {
			$.messager.alert("提示", "没有选择复制的项目，请重新选择！", "info");
		}
	} else {
		$.messager.alert("提示", "没有需要复制的项目，请重新选择！", "info");
	}
	return false;
}

function GetTableTrID(name) {
	var p = $(name).prev().find('div table:eq(1)');
	var ID = $(p).find('tbody tr:first').attr('id');
	if (ID != undefined && ID != '' && ID.length > 3) {
		ID = ID.toString().substr(0, ID.toString().length - 1);
	}
	return ID;
}

// 查询项目
function BSearchItem_click(type) {
	var SelRowData = $("#OrderSetsList").datagrid("getSelected");
	if ( SelRowData ) {
		if (type == "R") $("#QryRisItemList").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Item",TargetFrame:"PreItemList",Item:$("#RisItem").val(),StationID:$("#Station").combobox("getValue"),PreIADMID:"",BType:"B",LocID:session['LOGON.CTLOCID'],hospId:session['LOGON.HOSPID']}); 
		else if (type == "L") $("#QryLisItemList").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Lab",TargetFrame:"PreItemList",Item:$("#LisItem").val(),PreIADMID:"",StationID:"",BType:"B",LocID:session['LOGON.CTLOCID'],hospId:session['LOGON.HOSPID']}); 
		else if (type == "M") $("#QryMedicalItemList").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Medical",TargetFrame:"PreItemList",Item:$("#MedicalItem").val(),PreIADMID:"",StationID:"",BType:"B",LocID:session['LOGON.CTLOCID'],hospId:session['LOGON.HOSPID']}); 
		else if (type == "O") $("#QryOtherItemList").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Other",TargetFrame:"PreItemList",Item:$("#OtherItem").val(),PreIADMID:"",StationID:"",BType:"B",LocID:session['LOGON.CTLOCID'],hospId:session['LOGON.HOSPID']}); 
	}
}

// 查询套餐
function BSearchOS_click() {
	var ARCOSRowid = "";
	var SelRowData = $("#OrderSetsList").datagrid("getSelected");
	if ( SelRowData ) {
		ARCOSRowid = SelRowData.ARCOSRowid;
	} else {
		//$.messager.alert("提示","请先选择体检医嘱套！","info");
		return false;
	}
	
	$("#QryOrdSetsList").datagrid("load", {
		ClassName:"web.DHCPE.HISUIOrderSets",
		QueryName:"SearchPECanCopyOS",
		ARCOSRowid:ARCOSRowid,
		Desc:$("#OrdSets").val(),
		Type:"",
		LocID:session["LOGON.CTLOCID"],
		HospID:session["LOGON.HOSPID"]
	}); 
}

// ************************************************其他函数************************************************************************** //

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[0];
}

var jschars = ['0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'];
// 取随机值
function getnum(num){
	var str=""
	for(var i=0;i<num;i++){
		var id=Math.ceil(Math.random()*35);
		str+=jschars[id];
	}
	return str;
}

// 当前时间 格式 yyyy-MM-DD
function Dateformatter(date){  
    var y = date.getFullYear();  
    var m = date.getMonth()+1;  
    var d = date.getDate();  
    return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);  
}

function OnPropChanged(event, type) {
	if (event.propertyName.toLowerCase() == "value") {
		if (type == "OS") {
			BSearchOS_click();
		} else {
			BSearchItem_click(type);
		}
	}
}

// 当前日期距 1840-12-31 的天数
function daysBetween(Date) {
	var OneYear = "1840", OneMonth = "12", OneDay = "31";
	if (iDate == "") {
		var mydate = new Date();
		OneYear = mydate.getFullYear();  //获取完整的年份(4位,1970-????)
		OneMonth = mydate.getMonth()+1;  //获取当前月份(0-11,0代表1月)
		OneDay = mydate.getDate();       //获取当前日(1-31)
	} else {
		OneYear = iDate.split("-")[0];
		OneMonth = iDate.split("-")[1];
		OneDay = iDate.split("-")[2];
	}
	var cha=((Date.parse(OneMonth+'/'+OneDay+'/'+OneYear) - Date.parse("12/31/1840"))/86400000);
	return Math.abs(Math.floor(cha));
}