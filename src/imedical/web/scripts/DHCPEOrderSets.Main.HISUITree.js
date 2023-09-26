// DHCPEOrderSets.Main.HISUITree.js
// by zhongricheng

var WIDTH = $(document).width();
var ItemType = "N", LisType = "N", MedType = "N", OtherType = "N";
$("#OrderSetsSearch").css("width", WIDTH*0.5);

$(function() {
	InitCombobox();
	InitARCOSDataGrid();
	
	//InitARCOSDetailDataGrid();
	
	// 初始化项目
	//InitItemDataGrid("#QryRisItemList","Item");
	//InitItemDataGrid("#QryLisItemList","Lab");
	//InitItemDataGrid("#QryMedicalItemList","Medical");
	//InitItemDataGrid("#QryOtherItemList","Other");
	
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
		allowNull:true,
		panelHeight:"auto",
		editable:false
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
	
	// 条件
	$HUI.combobox("#Conditiones", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'1',text:'个人'},
			{id:'2',text:'科室',selected:'true'},
			{id:'3',text:'全院'}
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
			{id:'2', text:'科室', selected:'true'},
			{id:'3', text:'全院'}
		]
	});
	
	// 可用科室	
	$HUI.combobox("#OSLocWin", {
		url:$URL+"?ClassName=web.DHCPE.HISUIOrderSets&QueryName=QueryLoc&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		defaultFilter:4,
		onSelect:function(record) {   // 选中增加
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
		onSelect:function(record){
			$("#QryRisItemList").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Item",TargetFrame:"PreItemList",Item:$("#RisItem").val(),StationID:record.id}); 
		}
	});
	
	$HUI.tabs("#QryItem", {
		onSelect:function(title, index) {
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
			}
						
		}
	});
}

// ****************************************************套餐维护********************************************************************** //

// 初始化医嘱套表格
function InitARCOSDataGrid() {
	$HUI.treegrid("#OrderSetsList", {
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.HISUIOrderSets",
			QueryName:"SearchPEOrderSets",
			UserID:session["LOGON.USERID"],  // $.session.get('USERID'),
			subCatID:$("#subCatID").val(),
			Conditiones:$("#Conditiones").combobox('getValue')
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
			
			{field:'ARCOSOrdSubCat', title:'子类', width:200,},
			{field:'ARCOSCode',title:'代码',align:'center'},
			{field:'ARCOSDesc',title:'描述'},
			{field:'ARCOSAlias',title:'别名',align:'center'},
			
			{field:'BreakDesc', title:'拆分', align:'center'},  // 拆分
			{field:'SexDesc', title:'对应性别', align:'center'},  // 性别
			{field:'VIPDesc',title:'套餐等级'},
			{field:'DeitDesc',title:'早餐', align:'center'},
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
		//pagination:true,   // 树形表格 不能分页
		//pageSize:10,
		//pageList:[10,15,20,25,50,100],
		singleSelect:true,
		toolbar: [{
			iconCls: 'icon-search',
			text:'查询',
			handler: function(){
				BSearch_click();
			}
		},{
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
			iconCls: 'icon-edit',
			text:'修改',
			id:'BUpd',
			disabled:true,
			handler: function(){
				$("#OrderSetsWin").show();
				
				var SelRowData = $("#OrderSetsList").treegrid("getSelected");
				$("#CategoryWin").val(SelRowData.ARCOSOrdCat);
				$("#csubCatIDWin").val(SelRowData.ARCOSOrdSubCat);
				$("#CategoryIDWin").val(SelRowData.ARCOSOrdCatDR);
				$("#subCatIDWin").val(SelRowData.ARCOSOrdSubCatDR);
				
				$("#CodeWin").val(SelRowData.ARCOSCode);  // 代码
				$("#DescWin").val(SelRowData.ARCOSDesc);  // 描述
				$("#AliasWin").val(SelRowData.ARCOSAlias);  // 别名
				
				// 条件  
				var InUser = SelRowData.FavUserDr;
				var FavDepList = SelRowData.FavDepDr;
				var DocMedUnit = SelRowData.MedUnit;
				var Conditiones="";
				if (InUser == "") {
					if (FavDepList == "") {
						if (DocMedUnit == "") { Conditiones = "3"; }
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
				if (SelRowData.OSExDeit == "Y") $("#IsDeitWin").checkbox("setValue", true);  // 早餐
				else $("#IsDeitWin").checkbox("setValue", false);
				
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
			iconCls: 'icon-remove',
			text:'删除',
			id:'BDel',
			disabled:true,
			handler: function(){
				BDel_click();
			}
		},{
			iconCls: 'icon-remove',
			text:'清屏',
			handler: function(){
				BClear_click("0");
			}
		},{
			iconCls: 'icon-house',
			text:'可用科室',
			id:'BLoc',
			disabled:true,
			handler: function(){
				$("#OrderSetsLocWin").show();
				
				$("#OSLocWin").combobox("setValue","");
				
				var SelRowData = $("#OrderSetsList").treegrid("getSelected");
				InitARCOSLocDataGrid(SelRowData.ARCOSRowid);
				
				var myWin = $HUI.dialog("#OrderSetsLocWin",{
					iconCls:'icon-w-edit',
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
		},{
			iconCls: 'icon-show-set',
			text:'网上套餐',
			id:'BWebOS',
			disabled:true,
			handler: function(){
				BSelWeb_click();
			}
		}],		
		onClickRow: function (rowIndex, rowData) {  // 选择行事件 	
			if ( rowData._parentId != "" ) {
				InitARCOSDetailDataGrid(rowData.ARCOSRowid);  // 医嘱明细  
				
				//$('#OrderSets').layout("collapse","west");  // 折叠事件
				//$('#OrderSets').layout("expand","east");  // 展开事件
				//$('#OrderSets').layout("expand","south");
				
				// 初始化项目
				ItemType = "N", LisType = "N", MedType = "N", OtherType = "N";
				var tab = $("#QryItem").tabs("getSelected");
				var title = tab.panel("options").title;
				if (title == "检查项目" && LisType == "N") {
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
				}
				//InitItemDataGrid("#QryRisItemList","Item");
				//InitItemDataGrid("#QryLisItemList","Lab");
				//InitItemDataGrid("#QryMedicalItemList","Medical");
				//InitItemDataGrid("#QryOtherItemList","Other");
				
		       	$("#Code").val(rowData.ARCOSCode);
		       	$("#Desc").val(rowData.ARCOSDesc);
		       	$("#Alias").val(rowData.ARCOSAlias);
				
				$('#BUpd').linkbutton('enable');
				$('#BDel').linkbutton('enable');
				$('#BLoc').linkbutton('enable');
				$('#BWebOS').linkbutton('enable'); 
			} else {
				$("#OrderSetsDetailList").datagrid('loadData',{total:0,rows:[]});
				
				BClear_click("0");
				
				$('#BUpd').linkbutton('disable');
				$('#BDel').linkbutton('disable');
				$('#BLoc').linkbutton('disable');
				$('#BWebOS').linkbutton('disable');
			}
		},
		onDblClickRow: function (rowIndex, rowData) {  // 双击行事件
			$("#OrderSetsList").treegrid("toggle",rowData.ARCOSRowid);
			
			//$("#OrderSetsDetailList").datagrid('loadData',{total:0,rows:[]});
		},
		onLoadSuccess:function(data){
			
		}
	});
}

// 查询
function BSearch_click(){
	// $.messager.alert("提示","Search");
	// 套餐列表
	$HUI.treegrid("#OrderSetsList",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.HISUIOrderSets",
			QueryName:"SearchPEOrderSets",
			UserID:session['LOGON.USERID'],  // $.session.get('USERID'),
			subCatID:$("#subCatID").val(),
			Conditiones:$("#Conditiones").combobox('getValue'),
			Code:$("#Code").val(),
			Desc:$("#Desc").val(),
			Alias:$("#Alias").val()
		}
	});
}

// 新增
function BAdd_click(type){
	// $.messager.alert("提示","Add");
	if ( type == "Upd" ) { 
		var SelRowData = $("#OrderSetsList").datagrid("getSelected");
		if (SelRowData) {
			var FavRowid = SelRowData.FavRowid;
			var ARCOSRowid = SelRowData.ARCOSRowid;
			var tPGBId = SelRowData.OSExPGBId;
			if (tPGBId == "") tPGBId = "UN"; 
			if (FavRowid == "" || ARCOSRowid == "") {
				$.messager.alert("提示","请选择医嘱套进行修改。");
				return false; 
			}
		} else {
			$.messager.alert("提示","请选择医嘱套进行修改。");
			return false; 
		}
	}
	var ARCOSCatID="", ARCOSCode="", ARCOSDesc="", ARCOSAlias="", Conditiones="", ARCOSEffDateFrom="";
	
	var UserID = session["LOGON.USERID"]
	var UserCode = session["LOGON.USERCODE"];
	var	CTLOCID = session["LOGON.CTLOCID"];
	
	//var ARCOSCatID = 12;  // 医嘱套ID OEC_OrderCategory
	if ($("#CategoryIDWin").val().replace(/(^\s*)|(\s*$)/g,'') != "") { ARCOSCatID = $("#CategoryIDWin").val(); }
	else { $.messager.alert("警告", "医嘱套大类为空，请和管理员联系!"); return false; }
	
	if ($("#subCatIDWin").val().replace(/(^\s*)|(\s*$)/g,'') != "") { subCatID = $("#subCatIDWin").val(); }
	else { $.messager.alert("警告", "医嘱套子类为空，请和管理员联系!"); return false; }
	
	if ($("#CodeWin").val().replace(/(^\s*)|(\s*$)/g,"") != "") { ARCOSCode = $("#CodeWin").val(); }
	else { $.messager.alert("警告", "医嘱套代码为空，请和管理员联系!"); return false; }
	
	if ($("#DescWin").val().replace(/(^\s*)|(\s*$)/g,"") != "") { ARCOSDesc = $("#DescWin").val(); }
	else { $.messager.alert("提示", "医嘱套描述不能为空！"); return false; }
	
	if ($("#AliasWin").val().replace(/(^\s*)|(\s*$)/g,"") != "") { ARCOSAlias = $("#AliasWin").val(); }
	else { $.messager.alert("提示", "医嘱套别名不能为空！"); return false; }

	if ($("#ConditionesWin").combobox('getValue').replace(/(^\s*)|(\s*$)/g,"") != "") { Conditiones = $("#ConditionesWin").combobox('getValue'); }
	else { $.messager.alert("提示", "条件不能为空！"); return false; }
		
	// 医嘱套的名字要加上Code
	if (ARCOSDesc.indexOf("-") < 0) {
		ARCOSDesc = UserCode + "-" + ARCOSDesc;
	}
	// $.messager.alert("提示","ARCOSDesc:"+ARCOSCode)
	
	// 取组
	var DocMedUnit = $.m({ClassName:"web.DHCUserFavItems", MethodName:"GetMedUnit", Guser:UserID, CTLOCID:CTLOCID}, false);
	var FavDepList = "";
	var InUser = UserID;
	
	// 条件判断设置相关值
	if (Conditiones == "1") {  // 个人
		FavDepList = "";
		DocMedUnit = "";
	} else if (Conditiones == "2") {  // 科室
		InUser = "";
		FavDepList = CTLOCID;
		DocMedUnit = "";
	} else if (Conditiones == "3") { // 全院
		InUser = "";
		FavDepList = "";
		DocMedUnit = "";
	} else if (Conditiones == "4") {
		FavDepList = "";
		if (DocMedUnit == "") {
			$.messager.alert("提示", "您没有被加入到登陆科室有效的组内,不能进行该条件保存");
			return false;
		}
	}
	
	var VIPLevel="", Break="", Sex="", Deit="", PGBId="", InString="", ret;
	
	PGBId = $("#OrderSetsPGBIWin").combobox("getValue");  // 团体
	if (PGBId == undefined) {
		$.messager.alert("提示", "可用团体不能为空");
		return false;
	}
	
	VIPLevel = $("#OrderSetVIPWin").combobox("getValues");  // 套餐等级
	
	cBreak = $("#IsBreakWin").checkbox("getValue");  // OSE_Break	可否拆分
	if (cBreak) { Break = "Y"; }
	else { Break = "N"; }
	
	Sex = $("#OrderSetSexWin").combobox('getValue');  // OSE_Sex_DR 对应性别
	
	cDeit = $("#IsDeitWin").checkbox("getValue");  // OSE_Break	可否拆分
	if (cDeit) { Deit = "Y"; }
	else { Deit = "N"; }
	
	InString = VIPLevel + "^" + Break + "^" + Sex + "^" + Deit + "^" + PGBId;
	// alert(VIPLevel + "  " + Break + "  " + Sex + "  " + Deit);return false;
	if (type == "Add") {
		// 生效日期ARCOSEffDateFrom
		if ($("#curDateWin").val() != "") { ARCOSEffDateFrom = $("#curDateWin").val(); }
		else { ARCOSEffDateFrom = 1; }
		
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
			HospID:"",
			InString:InString
		},function(ret){  // FavRowid_$C(1)_ARCOSRowid_$C(1)_ARCOSCode
			if (ret == "-1") {
				$.messager.alert("提示","保存医嘱套失败您可能填写了已经使用的代码!");
				return false;
			}
			$.messager.alert("提示","保存成功!");
			var arr = new Array();
			arr = ret.split(String.fromCharCode(1));
			var iFavRowid = arr[0];
			var iARCOSRowid = arr[1];
			var iARCOSCode = arr[2];
			var OSExData=$.cm({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetARCOSData", ArcimRowId:iARCOSRowid}, false);
			var pId = "PGBIdUN";
			if ( OSExData.PGBId != "" ) pId = "PGBId" + OSExData.PGBId;
			$("#OrderSetsList").treegrid('append', {
				parent: pId,//treegrid 父id 必须指定
				data: [{
					ARCOSRowid:iARCOSRowid,
					ARCOSOrdCatDR:ARCOSCatID,	// 大类ID
					ARCOSOrdSubCatDR:subCatID,	// 子类ID
					ARCOSEffDateFrom:ARCOSEffDateFrom,
					FavRowid:iFavRowid,
					FavUserDr:UserID,			// 用户
					FavDepDr:FavDepList,		// 科室
					MedUnit:DocMedUnit,			// 组
		
					OSExBreak:OSExData.Break,			// 拆分
					OSExSex:OSExData.Sex,				// 性别
					OSExDeit:OSExData.Deit,				// 早餐
					OSExVIPLevel:OSExData.VIPLevel,		// VIPID
					OSExPGBId:OSExData.PGBId,
			
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
				}]
			});
			
			/*
			$("#OrderSetsList").datagrid("insertRow", {
				index:0,
				row:{
					ARCOSRowid:iARCOSRowid,
					ARCOSOrdCatDR:ARCOSCatID,	// 大类ID
					ARCOSOrdSubCatDR:subCatID,	// 子类ID
					ARCOSEffDateFrom:ARCOSEffDateFrom,
					FavRowid:iFavRowid,
					FavUserDr:UserID,			// 用户
					FavDepDr:FavDepList,		// 科室
					MedUnit:DocMedUnit,			// 组
		
					OSExBreak:OSExData.Break,			// 拆分
					OSExSex:OSExData.Sex,				// 性别
					OSExDeit:OSExData.Deit,				// 早餐
					OSExVIPLevel:OSExData.VIPLevel,		// VIPID
			
					ARCOSOrdCat:"医嘱套",
					ARCOSOrdSubCat:"体检医嘱套",
					ARCOSCode:iARCOSCode,
					ARCOSDesc:ARCOSDesc,
					ARCOSAlias:ARCOSAlias,
			
					BreakDesc:OSExData.BreakDesc,  // 拆分
					SexDesc:OSExData.SexDesc,  // 性别 $("#OrderSetSexWin").combobox('getValue')
					VIPDesc:OSExData.VIPDesc,
					DeitDesc:OSExData.DeitDesc,
					OSExPrice:OSExData.OSExPrice,  // 价格
				}
			});
			*/
			
			$("#OrderSetsWin").window("close");
		}); 
	} else if (type == "Upd"){
		ARCOSEffDateFrom = SelRowData.ARCOSEffDateFrom;  // 生效日期ARCOSEffDateFrom
		// $.messager.alert("提示",FavRowid+","+ARCOSCode+","+ARCOSDesc+","+ARCOSCatID+","+subCatID+","+ARCOSEffDateFrom+","+ARCOSAlias+","+FavDepList+","+DocMedUnit+","+UserID+","+InString);
		// ret=tkMakeServerCall("web.DHCUserFavItems","UpdateUserARCOS",FavRowid,ARCOSCode,ARCOSDesc,ARCOSCatID,subCatID,ARCOSEffDateFrom,ARCOSAlias,FavDepList,DocMedUnit,InUser);
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
			InString:InString
		}, function(ret) {
			if (ret == "0") {
				$.messager.alert("提示", "修改成功!");
				if ( tPGBId != PGBId ) {
					if (tPGBId == "") {
						$("#OrderSetsList").treegrid("reload", "PGBIdUN");
						$("#OrderSetsList").treegrid("reload", "PGBId" + PGBId, {onLoadSuccess: function(data){ $("#OrderSetsList").treegrid("select", ARCOSRowid); }});
					}
					if (PGBId == "") {
						$("#OrderSetsList").treegrid("reload", "PGBId" + tPGBId);
						$("#OrderSetsList").treegrid("reload", "PGBIdUN", {onLoadSuccess: function(data){ $("#OrderSetsList").treegrid("select", ARCOSRowid); }});
					}
					if (tPGBId != "" && PGBId != "") {
						$("#OrderSetsList").treegrid("reload", "PGBId" + tPGBId);
						$("#OrderSetsList").treegrid("reload", "PGBId" + PGBId, {onLoadSuccess: function(data){ $.messager.alert("提示", ARCOSRowid);$("#OrderSetsList").treegrid("select", ARCOSRowid); }});
					}
				} else {
					var OSExData=$.cm({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetARCOSData", ArcimRowId:ARCOSRowid}, false);
					
					$('#OrderSetsList').treegrid('update',{
						id: ARCOSRowid,
						row:{
							FavUserDr:UserID,			// 用户
							FavDepDr:FavDepList,		// 科室
							MedUnit:DocMedUnit,			// 组
				
							OSExBreak:OSExData.Break,			// 拆分
							OSExSex:OSExData.Sex,				// 性别
							OSExDeit:OSExData.Deit,				// 早餐
							OSExVIPLevel:OSExData.VIPLevel,		// VIPID
							ARCOSDesc:ARCOSDesc,
							ARCOSAlias:ARCOSAlias,
					
							BreakDesc:OSExData.BreakDesc,  // 拆分
							SexDesc:OSExData.SexDesc,  // 性别 $("#OrderSetSexWin").combobox('getValue')
							VIPDesc:OSExData.VIPDesc,
							DeitDesc:OSExData.DeitDesc,
							OSExPrice:OSExData.OSExPrice,  // 价格
						}
					});
				}
				/*
				var SelRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelRowData);
				var OSExData=$.cm({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetARCOSData", ArcimRowId:ARCOSRowid}, false);
				
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
						ARCOSDesc:ARCOSDesc,
						ARCOSAlias:ARCOSAlias,
				
						BreakDesc:OSExData.BreakDesc,  // 拆分
						SexDesc:OSExData.SexDesc,  // 性别 $("#OrderSetSexWin").combobox('getValue')
						VIPDesc:OSExData.VIPDesc,
						DeitDesc:OSExData.DeitDesc,
						OSExPrice:OSExData.OSExPrice,  // 价格
					}
				});
				*/
				$("#OrderSetsWin").window("close");
			} else { 
				$.messager.alert("提示", "更新失败!");
				return false;
			}
		});
		// tkMakeServerCall("web.DHCPE.HISUIOrderSets","SetARCOSEx",ARCOSRowid,VIPLevel,Break,Sex,Deit);
	}
}

// 删除
function BDel_click(){
	var SelRowData = $("#OrderSetsList").treegrid("getSelected");
	//var SelRowData = $("#OrderSetsList").datagrid("getSelected");
	//var SelRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelRowData);
	if ( !SelRowData ) { $.messager.alert("提示","请选择医嘱套进行删除！"); return false; }
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
					$.messager.alert("提示", ReturnValue+"删除医嘱套失败.");
				}else{
					$.messager.alert("提示", "删除医嘱套成功.");
					$("#OrderSetsList").treegrid("remove", ARCOSRowid);
					//$("#OrderSetsList").datagrid("deleteRow", SelRowIndex);
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
	$("#DescWin").val("");
	$("#AliasWin").val("");
	$("#ConditionesWin").combobox("setValue", "2");
	$("#OrderSetVIPWin").combobox("setValues","");
	$("#OrderSetSexWin").combobox("setValue","");  // 性别
	$("#IsBreakWin").checkbox("setValue", false);  // 拆分
	$("#IsDeitWin").checkbox("setValue", false);	 // 早餐
	$("#OSLocWin").combobox("setValue","");
	$("#OrderSetsPGBIWin").combobox("setValue","");
}

// 可用科室维护
function BUpdLoc_click(Type) {
	var SelOSRowData = $("#OrderSetsList").treegrid("getSelected");
	if ( !SelOSRowData ) { $.messager.alert("提示","请选择医嘱套再进行套餐可用科室维护的操作！"); return false; }
	var ARCOSRowid = SelOSRowData.ARCOSRowid;
	var loc = "", locdesc = "";
	if (Type == "1") {
		loc = $("#OSLocWin").combobox("getValue");
		locdesc = $("#OSLocWin").combobox("getText");
	} else if (Type == "0") {
		var SelRowData = $("#OSLocTable").datagrid("getSelected");
		if ( !SelRowData ) { $.messager.alert("提示","请选择需要删除的科室！"); return false; }
		loc = SelRowData.LocId;
		locdesc = SelRowData.LocDesc;
	}
	$.m({
		ClassName:"web.DHCPE.HISUIOrderSets",
		MethodName:"SetARCOSLocInfo",
		ARCOSRowid:ARCOSRowid,
		LocId:loc,
		flag:Type
	}, function(ret) {
		if (ret == "0") {
			if (Type == "1") {
				$.messager.alert("提示", "增加成功!");
				
				$("#OSLocTable").datagrid("insertRow", {
					index:0,
					row:{
						LocId:loc,
						LocDesc:locdesc
					}
				});
				
			} else if (Type == "0") {
				$.messager.alert("提示", "删除成功!");
				
				var SelRowData = $("#OSLocTable").datagrid("getSelected");
				var SelRowIndex = $("#OSLocTable").datagrid("getRowIndex", SelRowData);
				$("#OSLocTable").datagrid("deleteRow", SelRowIndex);
			}
			
			var OSExData=$.cm({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetARCOSData", ArcimRowId:ARCOSRowid}, false);
			$("#OrderSetsList").treegrid("update", {
				id: ARCOSRowid,
				row:{
					OSLoc:OSExData.LocId,
					LocDesc:OSExData.LocDesc
				}
			});
			
			/*   表格用这个
			var SelOSRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelOSRowData);
			var OSExData=$.cm({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetARCOSData", ArcimRowId:ARCOSRowid}, false);
			$("#OrderSetsList").datagrid("updateRow", {
				index: SelOSRowIndex,
				row:{
					OSLoc:OSExData.LocId,
					LocDesc:OSExData.LocDesc
				}
			});
			*/
			
			$("#OrderSetsLocWin").window("close");
		} else { 
			if (Type == "1") { $.messager.alert("提示", "增加失败!" + ret.split("^")[1]); }
			else if (Type == "0") { $.messager.alert("提示", "删除失败!" + ret.split("^")[1]); }
			return false;
		}
	});
}

// 网上套餐
function BSelWeb_click() {
	var SelOSRowData = $("#OrderSetsList").treegrid("getSelected");
	//var SelOSRowData = $("#OrderSetsList").datagrid("getSelected");
	if ( !SelOSRowData ) { $.messager.alert("提示","请选择医嘱套再维护网上套餐！"); return false; }
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
			{field:'LocId', title:'科室ID', width:100, align:'center'},
			{field:'LocDesc', title:'科室描述', width:400}
		]],
		tatle:"医嘱套可用科室",
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
			ClassName:"web.DHCARCOrdSets",
			QueryName:"FindOSItem",
			ARCOSRowid:ARCOSRowid,
			QueryFlag:"1"
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
			{field:'IsBreakable',title:'操作',
				formatter:function(value,rowData,rowIndex){
					// icon-cancel
					return "<a href='#' onclick='DeleteDetail(\"" + rowData.ARCOSItemRowid + "\",\"" + rowData.ARCIMRowid + "\",\"" + rowIndex + "\")'>\<img style='padding-left:7px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/>\</a>";
				}
			},
			{field:'ARCIMDesc',title:'名称'},
			{field:'ARCOSDHCDocOrderType',title:'医嘱类型',align:'center'},
			{field:'DHCDocOrdRecLoc',title:'接收科室',
				formatter:function(value,rowData,rowIndex){
					var arr=new Array();
					if (value.indexOf("-") > 0) {
						arr = value.split("-");
					}
					return arr[1];
				}
			},
			{field:'SampleDesc',title:'标本',align:'center'},
			{field:'ItmPrice',title:'价格',align:'center',
				formatter: function(value,rowData,rowIndex){
					var value = $.m({
						ClassName:"web.DHCPE.Handle.ARCItmMast",
						MethodName:"GetItmPrice",
						ARCIMRowid:rowData.ARCIMRowid,
					}, false);
					return value;
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
		pageSize:25,
		pageList:[10,15,25,50,100],
		fit:true,
		singleSelect:true,
		toolbar: [{
			iconCls: "icon-remove",
			text: "删除",
			handler: function() {
				BDelDetail_click();
			}
		},{
			iconCls: 'icon-arrow-top',
			text:'上移',
			handler: function(){
				var rowData = $('#OrderSetsDetailList').datagrid('getSelected');
				var rowIndex = $('#OrderSetsDetailList').datagrid('getRowIndex',rowData); 
				if (rowIndex >= 0){
					IMove(rowData,rowIndex,-1);
				} else {
					$.messager.alert("提示", "请选择一行进行移动！");
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
					$.messager.alert("提示", "请选择一行进行移动！");
				}
			}
		},{
			iconCls: 'icon-fee',
			text:'套餐定价',
			handler: function(){
				var SelRowData = $("#OrderSetsList").treegrid("getSelected");
				//var SelRowData = $("#OrderSetsList").datagrid("getSelected");
				//var SelRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelRowData);
				if ( !SelRowData || SelRowData._parentId == "" ) { $.messager.alert("提示","请选择医嘱套再进行套餐定价！"); return false; }
				ClearPrice();
				$("#OrderSetsPriceWin").show();

				var ARCOSDesc = SelRowData.ARCOSDesc;
				var AmtData = $.cm({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetOrdSetsAmount", ARCOSRowId:ARCOSRowid}, false);
					
				if (AmtData.Amount <= 0) {
					$.messager.alert("提示","医嘱套原价格为零，不需要定价！","info");
					$("#OrderSetsPriceWin").window("close");
					return false;
				}
				
				$("#OSDescWin").val(ARCOSDesc);   // 套餐描述
				$("#OSAmountWin").val(AmtData.Amount);   // 套餐原价
				$("#OSPriceWin").val(AmtData.ARCOSPrice);   // 套餐定价
	       	
					 
				var myWin = $HUI.dialog("#OrderSetsPriceWin", {
					iconCls:'icon-fee',
					resizable:true,
					title:'套餐定价',
					modal:true,
					buttonAlign:'center',
					buttons:[{
						text:'定价',
						handler:function(){
							UpdPrice();
						}
					},{
						text:'还原',
						handler:function(){
							UndoPrice();
						}
					}]
				});				
			}
		},{}],
		onLoadSuccess: function (data) {
			var SelOSRowData = $("#OrderSetsList").treegrid("getSelected"); 
			if ( SelOSRowData._parentId != "" ) {
				// 初始化项目
				//InitItemDataGrid("#QryRisItemList","Item");
				//InitItemDataGrid("#QryLisItemList","Lab");
				//InitItemDataGrid("#QryMedicalItemList","Medical");
				//InitItemDataGrid("#QryOtherItemList","Other");
			} else {
				$("#QryRisItemList").datagrid('loadData',{total:0,rows:[]});
				$("#QryLisItemList").datagrid('loadData',{total:0,rows:[]});
				$("#QryMedicalItemList").datagrid('loadData',{total:0,rows:[]});
				$("#QryOtherItemList").datagrid('loadData',{total:0,rows:[]});
			}
		},
		onClickRow: function (rowIndex, rowData) {  // 选择行事件     	
		}
	});
}

function BDelDetail_click(){
	var SelOSRowData = $("#OrderSetsList").treegrid("getSelected");
	//var SelOSRowData = $("#OrderSetsList").datagrid("getSelected");
	if (SelOSRowData._parentId == "") { $.messager.alert("提示","请选择医嘱套再删除明细！"); return false; }
	
	var ARCOSRowid = SelOSRowData.ARCOSRowid;
	if (ARCOSRowid != "") {
		var SelRowData = $("#OrderSetsDetailList").datagrid("getSelected");
		var SelRowIndex = $("#OrderSetsDetailList").datagrid("getRowIndex", SelRowData);
		if (SelRowData) {
			DeleteDetail(SelRowData.ARCOSItemRowid, SelRowData.ARCIMRowid, SelRowIndex);
		} else { 
			$.messager.alert("提示","请选择一行进行删除！");
			return false;
		}	
	} else {
		$.messager.alert("提示","没有选择医嘱套！","info");
		return false;
	}
}

function DeleteDetail(ItemRowid, ARCIMRowid, ind) {
	$.m({
		ClassName:"web.DHCARCOrdSets",
		MethodName:"DeleteItem",
		ARCOSItemRowid:ItemRowid,
		ARCIMRowid:ARCIMRowid
	}, function(ret) {
		if ( ret == 0 ) {
			$.messager.alert("提示","删除成功！", "info");
			
			$("#OrderSetsDetailList").datagrid("deleteRow", ind);
			
			$("#QryRisItemList").datagrid({ rowStyler:function(index, row) { return SetRowStyle(index, row, "Del"); } });
			$("#QryLisItemList").datagrid({ rowStyler:function(index, row) { return SetRowStyle(index, row, "Del"); } });
			$("#QryMedicalItemList").datagrid({ rowStyler:function(index, row) { return SetRowStyle(index, row, "Del"); } });
			$("#QryOtherItemList").datagrid({ rowStyler:function(index, row) { return SetRowStyle(index, row, "Del"); } });
			
		} else {
			$.messager.alert("提示","删除失败！", "info");
		}
	});
}

// 增加医嘱套明细
function IAdd(AddType,Id,AddAmount,Index,tablename){
	var ARCOSRowid="",ItemQty=1,DHCDocOrdRecLoc="",flag;
	
	var SelOSRowData = $("#OrderSetsList").treegrid("getSelected");
	//var SelOSRowData = $("#OrderSetsList").datagrid("getSelected");
	if (SelOSRowData && SelOSRowData._parentId != "") { ARCOSRowid = SelOSRowData.ARCOSRowid; }  // 医嘱套ID
	else { $.messager.alert("提示","请选择医嘱套！", "info"); return false; }
	
	// 判断医嘱套中是否有该医嘱
	flag = $.m({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"IsHaveItemInOrdSets", ARCOSRowid:ARCOSRowid, ArcimRowId:Id}, false);
	if (flag == 1) { $.messager.alert("提示", "该项目已存在，请勿重复添加"); return false; }
	
	// 标本
	var SampleId = $.m({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetDefLabSpecId", ArcimRowId:Id}, false);
	// 0 单位   1 接收科室
	var rtn = $.cm({ ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetItemLocIdAndUOMId", ArcimRowId:Id}, false);

	DHCDocOrdRecLoc = rtn.RecLoc;
	if (DHCDocOrdRecLoc == "") {
		if ( !confirm("该项目没有接收科室，确认添加？") ) {
			return false;
		}
	}
	
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
		DHCDocOrderTypeID:3,
		SampleId:SampleId,
		ARCOSItemNO:"",
		OrderPriorRemarksDR:"",
		DHCDocOrderRecLoc:DHCDocOrdRecLoc,
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
					DHCDocOrdRecLoc:OSItemData.DHCDocOrdRecLoc,
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
		}
		
		$(tablename).datagrid({  
			rowStyler:function(index, row) { 
				return SetRowStyle(index, row, "Add"); 
			}  
		});
	});
	return data;
}

function GetTableTrID(name) {
	var p = $(name).prev().find('div table:eq(1)');
	var ID = $(p).find('tbody tr:first').attr('id');
	if (ID != undefined && ID != '' && ID.length > 3) {
		ID = ID.toString().substr(0, ID.toString().length - 1);
	}
	return ID;
}

// 移动  flag -1 上移   1 下移
function IMove(Data,Index,flag) {
	var ARCOSRowid="";
	var SelOSRowData = $("#OrderSetsList").treegrid("getSelected");
	//var SelOSRowData = $("#OrderSetsList").datagrid("getSelected");
	if (SelOSRowData && SelOSRowData._parentId != "") { ARCOSRowid = SelOSRowData.ARCOSRowid; }  // 医嘱套ID
	else { $.messager.alert("提示","请选择医嘱套！", "info");return false; }
	if (ARCOSRowid == "") { $.messager.alert("提示","请选择医嘱套！", "info");return false; }
	if (Data) {
		// 当前行序号和ID
		if (Data.ITMSerialNo != "") { var toup = Data.ITMSerialNo; }
		else { return false; }
		if (Data.ARCOSItemRowid != "") { var upid = Data.ARCOSItemRowid; }
		else { return false; }
		
		var changeRowData = $('#OrderSetsDetailList').datagrid('getRows');
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
		ClassName:"web.DHCARCOrdSets",
		MethodName:"UpdateItemSerialNo",
		ARCOSItemRowid:ARCOSItemRowid,
		ItemSerialNo:SerNO
	},function(rtn){
		
	});
	//tkMakeServerCall("web.DHCARCOrdSets","UpdateItemSerialNo",ARCOSItemRowid,SerNO)
}

// ************************************************价格维护************************************************************************** //

// 套餐定价
function UpdPrice() {
	var obj, Date = "", Price = "", ARCOSRowid = "", ARCOSAmount = "";
	
	var SelRowData = $("#OrderSetsList").treegrid("getSelected");
	//var SelRowData = $("#OrderSetsList").datagrid("getSelected");
	//var SelRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelRowData);
	if ( !SelRowData || SelRowData._parentId == "") { $.messager.alert("提示","请选择医嘱套再进行套餐定价！","info"); return false; }
	ARCOSRowid = SelRowData.ARCOSRowid;
	
	if ($("#OSDateWin").val() != "") { Date = $("#OSDateWin").val(); }
	else { $.messager.alert("提示","当前日期为空，请刷新界面","info"); return false; }

	if ($("#OSAmountWin").val() != "") { ARCOSAmount = $("#OSAmountWin").val(); }

		
	if (($("#OSAmtWin").val() == "") && (($("#OSDiscountWin").val() == ""))) {
		$.messager.alert("提示","请输入 套餐定价 或 折扣率.","info");
		return false;
	} else {
		if ($("#OSAmtWin").val() != "") Price_change("Amt");
		else  Price_change("Dis");
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
			
			//var OSExData=$.cm({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"GetARCOSData", ArcimRowId:ARCOSRowid}, false);
			
			$("#OrderSetsList").treegrid("update", {
				id: ARCOSRowid,
				row:{
					OSExPrice:Price+"元", // OSExData.OSExPrice,  // 价格
				}
			});
			
			/*
			$("#OrderSetsList").datagrid("updateRow", {
				index: SelRowIndex,
				row:{
					OSExPrice:Price+"元", // OSExData.OSExPrice,  // 价格
				}
			});
			*/
			$("#OrderSetsPriceWin").window("close");
			
		} else {
			$.messager.alert("提示","套餐价格更新失败！"+rtn,"info");
		}
	});
	ClearPrice();
}

// 还原价格
function UndoPrice() {
	var ARCOSRowid = "", ARCOSAmount = 0;
	
	var SelRowData = $("#OrderSetsList").treegrid("getSelected");
	//var SelRowData = $("#OrderSetsList").datagrid("getSelected");
	//var SelRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelRowData);
	if ( !SelRowData || SelRowData._parentId == "") { $.messager.alert("提示","请选择医嘱套再进行套餐定价！","info"); return false; }
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
			$.messager.alert("提示","套餐价格还原成功！","info");
			
			$("#OrderSetsList").treegrid("update", {
				id: ARCOSRowid,
				row:{
					OSExPrice:ARCOSAmount+"元", // OSExData.OSExPrice,  // 价格
				}
			});
			
			/*
			$("#OrderSetsList").datagrid("updateRow", {
				index: SelRowIndex,
				row:{
					OSExPrice:ARCOSAmount+"元", // OSExData.OSExPrice,  // 价格
				}
			});
			*/
			
			$("#OrderSetsPriceWin").window("close");
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
	$("#OSAmtWin").val("");
	$("#OSDiscountWin").val("");
}

// ************************************************项目维护************************************************************************** //

// 初始化项目详情表格
function InitItemDataGrid(tablename,type) {
	var Tem = "";
	$HUI.datagrid(tablename,{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.StationOrder",
			QueryName:"StationOrderList",
			Type:type,
			TargetFrame:"PreItemList"
		},
		columns:[[
			{field:'TUOM', title:'单位', hidden:true},
			
			{field:'STORD_ARCIM_DR', title:'操作', align:'center', width:7, formatter:function(value,row,index){
					return "<a href='#' onclick='IAdd(\"ITEM\", \"" + value + "\", \"" + row.STORD_ARCIM_Price + "\", \"" + index + "\", \"" + tablename + "\")'>\
					<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' border=0/>\
					</a>";
				}
			},
			{field:'STORD_ARCIM_Code', title:'编码', width:15},
			{field:'STORD_ARCIM_Desc', title:'名称', width:55},
			{field:'STORD_ARCIM_Price', title:'价格', align:'right', width:8},
			{field:'TLocDesc',title:'站点', width:15}
		]],
		striped:true, // 条纹化
		pagination:true,
		pageSize:25,
		pageList:[10,25,50,100],
		fit:true,
		fitColumns:true,
		singleSelect:true,
		rowStyler: function(rowIndex,rowData) {
			return SetRowStyle(rowIndex,rowData,"Add");  
        },
		onDblClickRow:function(rowIndex,rowData){
			var ItemType = "ITEM";
			var ItemId = rowData.STORD_ARCIM_DR;
			var AddAmount = rowData.STORD_ARCIM_Price;
			
			IAdd(ItemType, ItemId, AddAmount, rowIndex, tablename);
		},
		onClickRow: function (rowIndex, rowData) {  // 选择行事件     	
		}
	});
}

function SetRowStyle(rowIndex,rowData,Type) {
	var SelRowData = $("#OrderSetsList").treegrid("getSelected");
	//var SelRowData = $("#OrderSetsList").datagrid("getSelected");
	//var SelRowIndex = $("#OrderSetsList").datagrid("getRowIndex", SelRowData);
	if ( SelRowData && SelRowData._parentId != "") {
		var ARCOSRowid = SelRowData.ARCOSRowid;
		
		if (rowData) {
			var flag = $.m({ClassName:"web.DHCPE.HISUIOrderSets", MethodName:"IsHaveItemInOrdSets", ARCOSRowid:ARCOSRowid, ArcimRowId:rowData.STORD_ARCIM_DR}, false);
			if (flag == "1") {
				return "background-color:lightgreen;";
			}
		}
	}
	return "";
	
	var Data = $("#OrderSetsDetailList").datagrid('getData');
	var Tem="";
	for(var i = 0; i < Data.rows.length; i++) {
		if(Tem.indexOf("^" + i + "^") >= 0) {
			continue;
		}
   		var ARCIMRowid = Data.rows[i].ARCIMRowid;
   		
		if(rowData && rowData.STORD_ARCIM_DR == ARCIMRowid) {
			Tem = Tem + "^" + i + "^";
			return "background-color:lightgreen;";
		} else {
			if (Type == "Del") {
				if ((rowIndex % 2) == 0) {
                	return "";
                } else {
                    //return "background-color:#fafafa;";
                }
			}
		}
	}
	return ""
}

// 查询项目
function BSearchItem_click(type) {
	//$.messager.alert("type",type);
	if (type == "R") $("#QryRisItemList").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Item",TargetFrame:"PreItemList",Item:$("#RisItem").val(),StationID:$("#Station").combobox("getValue")}); 
	else if (type == "L") $("#QryLisItemList").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Lab",TargetFrame:"PreItemList",Item:$("#LisItem").val()}); 
	else if (type == "M") $("#QryMedicalItemList").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Medical",TargetFrame:"PreItemList",Item:$("#MedicalItem").val()}); 
	else if (type == "O") $("#QryOtherItemList").datagrid('load',{ClassName:"web.DHCPE.StationOrder",QueryName:"StationOrderList",Type:"Other",TargetFrame:"PreItemList",Item:$("#OtherItem").val()}); 
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
		BSearchItem_click(type);
	}
}