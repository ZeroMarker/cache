// DHCPEResultAnalysis.hisui.js
// dhcperesultanalysis.hisui.csp

var ScreenWidth = $(window).width();
var ScreenHeight = $(window).height();

var First = "Y";
var glabalType = "Aud";

$(function() {
	InitCombobox();
	InitData();
	
	$("#BQuery").click(function() {  // 分析查询
		BQuery_click();
    });
	
	$("#BSearch").click(function() {  // 体征查询
		BSearch_click();
    });
    
    $("#BClear").click(function() {  // 条件维护 清屏
		BClear_click("");
    });
    
    $("#BSave").click(function() {
		BSave_click(); 
    });
    
    $("#BSymptomsEdit").click(function() {
		ShowSymptomsEditWin(); 
    });
    
    $.m({
		ClassName:"web.DHCPE.Statistic.IllnessStatistic",
		MethodName:"GetResultAnalysisErrInfo",
		Type:glabalType
	}, function(data) {
		var ret = data.split("^");
		if (ret[0] == "-1") {
			$.messager.alert("提示", ret[1], "error");
    		$('#BSetAllTarget').linkbutton('enable');
    		$("#BSetAllTarget").click(function() {
				SetAllTarget(); 
		    });
			return false;
		} else {
    		$('#BSetAllTarget').linkbutton('disable');
    		if (ret[0] == "1") {
	    		$.messager.alert("提示", ret[1], "info");
    		}
		}
	});
    
	$(".inherit-border, .inherit-border>div:first-child").css("border-color", borderColor1);
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEResultAnalysis.raq");
    /*
    // hisui bug tab下的layout center 无高度 已提交需求
	$HUI.tabs("#TabDiv", {
		onSelect:function(title, index) {
			if (title == "条件维护" && First == "Y") {
				$(".ResizeDiv1").layout("resize");
				First = "N";
			}
		}
	});
    
	$(".ResizeDiv").layout("resize");  // hisui bug 已提交需求
	*/
});

function InitCombobox() {

	// 性别	
	$HUI.combobox("#Sex", {
		valueField:"id",
		textField:"text",
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'N',text:$g('不限'), selected:'true'},
			{id:'M',text:$g('男')},
			{id:'F',text:$g('女')}
		]
	});
	
	// 年龄段
	$HUI.combobox("#AgeGroup", {
		valueField:"id",
		textField:"text",
		panelHeight:"auto",
		editable:false,
		data:[  // id 解释:年龄段上下限（左开右闭 0<age<=15）,间隔,年龄段数量（用于类中变量的生成）
			{id:'15-65,10,7',text:$g('15-65岁 间隔10')},
			{id:'20-60,10,6',text:$g('20-60岁 间隔10')},
			{id:'25-65,10,6',text:$g('25-65岁 间隔10'), selected:'true'},
			{id:'20-70,10,7',text:$g('20-70岁 间隔10')},
			{id:'15-55,20,4',text:$g('15-55岁 间隔20')},
			{id:'20-60,20,4',text:$g('20-60岁 间隔20')},
			{id:'25-65,20,4',text:$g('25-65岁 间隔20')},
			{id:'15-75,20,5',text:$g('15-75岁 间隔20')}
		]
	});
	
	// 合同
	$HUI.combobox("#ContractID", {
		url:$URL+"?ClassName=web.DHCPE.Contract&QueryName=SerchContract&ResultSetType=array",
		valueField:"TID",
		textField:"TName",
		panelHeight:"auto",
		allowNull:true,
		editable:true,
		onSelect:function(record){
			var GBIDesc = $("#GBIDesc").val();
			$("#Groups").datagrid("load", {ClassName:"web.DHCPE.Report.GroupCollect",QueryName:"GADMList",GBIDesc:GBIDesc,ContractID:record.TID});
		},
		onChange:function(newValue, oldValue) {
			if (newValue =="" || newValue == undefined || newValue == "undefined" || newValue == null || newValue =="null" || newValue == "NULL") {
				$("#ContractID").combobox("setValue", "");
				var GBIDesc = $("#GBIDesc").val();
				$("#Groups").datagrid("load", {ClassName:"web.DHCPE.Report.GroupCollect",QueryName:"GADMList",GBIDesc:GBIDesc,ContractID:""});
			} 
		}
		
	});
	
	$HUI.combobox("#UseRange", {
		valueField:"id",
		textField:"text",
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'U',text:$g('个人')},
			{id:'S',text:$g('全科'), selected:'true'}
		]
	});
	
	$HUI.combobox("#UseRangeWin", {
		valueField:"id",
		textField:"text",
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'U',text:$g('个人')},
			{id:'S',text:$g('全科'), selected:'true'}
		]
	});
}

function InitData() {
	InitSymptomsData();
	InitGroupsListData();
	InitOrdSetsListData();
	InitSymptomsListData();
	InitAnalysisResultCondition();
}

// 体征列表
function InitSymptomsData() {
	$HUI.datagrid("#Symptoms", {
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.PositiveRecord",
			QueryName:"FindPositiveRecord",
			Type:"Q"
		},
		
		collapsible: true, //收起表格的内容
		lines:true,
		striped:true, // 条纹化
		rownumbers:true,
		border:false,
		fit:true,
		fitColumns:true,
		animate:true,
		//pagination:true,   // 树形表格 不能分页
		//pageSize:25,
		//pageList:[10,25,50,100],	
		singleSelect: false,
		checkOnSelect: true, //如果为false, 当用户仅在点击该复选框的时候才会被选中或取消
		selectOnCheck: true,
		
		columns:[[
			{field:'ID', title:'ID', hidden:true},
			{field:'Code', title:'Code', hidden:true},
			{field:'MSeq', title:'MSeq', hidden:true},
			{field:'FSeq' ,title:'FSeq', hidden:true},
			{field:'TUseRange', title:'TUseRange', hidden:true},
			
			{field:'SymptomsID', title:'选择', align:'center', checkbox:true},
			{field:'Name', title:'体征描述', width:80}
		]],
		
		onClickRow: function (rowIndex, rowData) {  // 选择行事件
		},
		onDblClickRow: function (rowIndex, rowData) {  // 双击行事件
		},
		onLoadSuccess:function(data){
		}
	});
}

// 团体列表
function InitGroupsListData() {
	$HUI.datagrid("#Groups", {
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.Report.GroupCollect",
			QueryName:"GADMList",
			GBIDesc:"",
			ContractID:""
		},
		collapsible: true, //收起表格的内容
		lines:true,
		striped:true, // 条纹化
		rownumbers:true,
		border:false,
		fit:true,
		fitColumns:true,
		animate:true,
		//pagination:true,   // 树形表格 不能分页
		//pageSize:25,
		//pageList:[10,25,50,100],	
		singleSelect: false,
		checkOnSelect: true, //如果为false, 当用户仅在点击该复选框的时候才会被选中或取消
		selectOnCheck: true,
		columns:[[
			{field:'TGRowId', title:'TGRowId', hidden:true},
			{field:'TGDesc', title:'TGDesc', hidden:true},
			{field:'TAdmDate', title:'TAdmDate', hidden:true},
			
			{field:'GroupsID', title:'选择', align:'center', checkbox:true},
			{field:'GroupsDesc', title:'团体名称', width:8, formatter: function(value, rowData, rowIndex) {
				var title="";
				if (rowData.TGRowId == ("ALLI")) {
					title="全部个人"
				} else if (rowData.TGRowId == ("ALLG")) {
					title="全部团体"
				} else {
					title="到达日期：" + rowData.TAdmDate
				}
				return "<a id='GroupsDesc_" + rowData.TGRowId + "' href='#' title='"
						+ title
						+ "' class='hisui-tooltip' data-options='position:\"right\",showDelay:50' style='text-decoration: none;color: black;'>"
						+ rowData.TGDesc + "</a>";
				}
			}
		]],	
		onClickRow: function (rowIndex, rowData) {  // 选择行事件
		},
		onDblClickRow: function (rowIndex, rowData) {  // 双击行事件
		},
		onLoadSuccess:function(data){
		}
	});
}

// 套餐列表
function InitOrdSetsListData() {
	$HUI.datagrid("#OrdSets", {
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.HISUIOrderSets",
			QueryName:"SearchPEOrderSets",
			UserID:"",
			subCatID:"",
			Conditiones:"",
			Desc:""
		},
		collapsible: true, //收起表格的内容
		lines:true,
		striped:true, // 条纹化
		rownumbers:true,
		border:false,
		fit:true,
		fitColumns:true,
		animate:true,
		//pagination:true,   // 树形表格 不能分页
		//pageSize:25,
		//pageList:[10,25,50,100],	
		singleSelect: false,
		checkOnSelect: true, //如果为false, 当用户仅在点击该复选框的时候才会被选中或取消
		selectOnCheck: true,
		columns:[[
			{field:'ARCOSRowid', title:'RowId', hidden:true},
			{field:'ARCOSDesc', title:'ARCOSDesc', hidden:true},
			{field:'BreakDesc', title:'BreakDesc', hidden:true},  // 拆分
			{field:'SexDesc', title:'SexDesc', hidden:true},  // 性别
			{field:'VIPDesc',title:'VIPDesc', hidden:true},  
			
			{field:'OrdSetsID', title:'选择', align:'center', checkbox:true},
			{field:'OrdSetsDesc', title:'套餐描述', width:8, formatter: function(value, rowData, rowIndex) {
				var title = "性别：" + rowData.SexDesc + "\r\nVIP等级：" + rowData.VIPDesc;
				return "<a id='OrdSetsDesc_" + rowData.ARCOSRowid + "' href='#' title='"
						+ title
						+ "' class='hisui-tooltip' data-options='position:\"right\",showDelay:50' style='text-decoration: none;color: black;'>"
						+ rowData.ARCOSDesc + "</a>";
				}
			}
			
		]],	
		onClickRow: function (rowIndex, rowData) {  // 选择行事件
		},
		onDblClickRow: function (rowIndex, rowData) {  // 双击行事件
		},
		onLoadSuccess:function(data){
		}
	});
}

// 分析查询
function BQuery_click() {
	var errStr = tkMakeServerCall("web.DHCPE.Statistic.IllnessStatistic", "GetResultAnalysisErrInfo", glabalType);
	var errInfo = errStr.split("^");
	if (errInfo[0] != "0") {
		$.messager.alert("提示", "无法保存并更新，" + errInfo[1], "info");
		// $.messager.popover({msg:"无法保存并更新，" + errInfo[1], type:"alert", timeout: 3000, showType:"slide"});
		if (errInfo[0] == "1") {
			$('#BSetAllTarget').linkbutton('disable');
		} else {
			$('#BSetAllTarget').linkbutton('enable');
		}
		return false;
	} else {
		$('#BSetAllTarget').linkbutton('disable');
	}
	
	//var BeginDate = "", EndDate = "", Type = "", AgeRange = "", SexDR = "N", PositiveRecords = "", PGADM = "", Other = ""
	var BeginDate = $("#BeginDate").datebox('getValue');
	if (BeginDate == "") {
		$.messager.alert("提示", "请输入开始日期！", "info");
		// $.messager.popover({msg:"请输入开始日期！", type:"alert", timeout: 3000, showType:"slide"});
		return false;
	}
	
	var EndDate = $("#EndDate").datebox('getValue');
	if (EndDate == "") { 
		$.messager.alert("提示", "请输入结束日期！", "info");
		// $.messager.popover({msg:"请输入结束日期！", type:"alert", timeout: 3000, showType:"slide"});
		return false;
	}
	
	var PositiveRecords = "";  // 体征  $ 分割
	var SymptomsRows = $("#Symptoms").datagrid("getChecked");  //获取的是数组，多行数据
	for(var i = 0; i <SymptomsRows.length; i++){
		if (PositiveRecords == "") PositiveRecords = SymptomsRows[i].ID;
		else PositiveRecords = PositiveRecords + "$" + SymptomsRows[i].ID;
	}
	if (PositiveRecords == "") {
		$.messager.alert("提示", "请选择体征再查询！", "info"); 
		// $.messager.popover({msg:"请选择体征再查询！", type:"alert", timeout: 3000, showType:"slide"});
		return false;
	}
	
	var AgeGroup = $("#AgeGroup").combobox('getValue');
	if (AgeGroup == "") { 
		$.messager.alert("提示", "请选择年龄段再查询！", "info"); 
		//$.messager.popover({msg:"请选择年龄段再查询！", type:"alert", timeout: 3000, showType:"slide"}); 
		return false; 
	}
	var AgeNum = AgeGroup.split(",")[2];
	
	var AgeRange = $("#AgeFrom").val() + "-" + $("#AgeTo").val();
	var SexDR = $("#Sex").combobox('getValue');
	
	var GADM = "";  // 团体ID DHC_PE_GADM  $ 分割
	var GroupsRows = $("#Groups").datagrid("getChecked");  //获取的是数组，多行数据
	for(var i = 0; i < GroupsRows.length; i++) {
		if (GADM == "") GADM = GroupsRows[i].TGRowId;
		else GADM = GADM + "$" + GroupsRows[i].TGRowId;
	}
	
	var PreOrdSets = "";   // 套餐   $ 分割
	var OrdSetsRows = $("#OrdSets").datagrid("getChecked");  //获取的是数组，多行数据
	for(var i = 0; i < OrdSetsRows.length; i++) {
		if (PreOrdSets == "") PreOrdSets = OrdSetsRows[i].ARCOSRowid;
		else PreOrdSets = PreOrdSets + "$" + OrdSetsRows[i].ARCOSRowid;
	}
	
	var Other = AgeGroup + "$" + PreOrdSets;   // 年龄段 ^ 套餐
	var CurLocDr = session["LOGON.CTLOCID"];
	
	var src = "&BeginDate=" + BeginDate
			+ "&EndDate=" + EndDate
			+ "&Type=" + glabalType
			+ "&AgeRange=" + AgeRange
			+ "&AgeGroup=" + AgeGroup
			+ "&SexDR=" + SexDR
			+ "&PositiveRecords=" + PositiveRecords
			+ "&GADM=" + GADM
			+ "&Other=" + Other
			+ "&ShowList=" + ""
			+ "&CurLocDr=" + CurLocDr
			;
	//alert(src);
	
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEResultAnalysis" + AgeNum + ".raq" + src);
	// $("#ReportFile").attr("src", "dhccpmrunqianreport.csp?reportName=DHCPEResultAnalysis" + AgeNum + ".raq" + src);
	
}

// 重新生成指标
function SetAllTarget() {
	
	var errStr = tkMakeServerCall("web.DHCPE.Statistic.IllnessStatistic", "GetResultAnalysisErrInfo", glabalType);
	var errInfo = errStr.split("^");
	if (errInfo[0] == "1") {
		$.messager.alert("提示", errInfo[1], "info");
		// $.messager.popover({msg:"无法保存并更新，" + errInfo[1], type:"alert", timeout: 3000, showType:"slide"});
		return false;
	}
	
	$.messager.confirm("重新生成指标", "重新生成所有指标，会先把已有的指标删除再重新生成，是否继续？", function (r) {
		if (r) {
			$.m({
				ClassName:"web.DHCPE.Statistic.IllnessStatistic",
				MethodName:"SetAllTarget",
				Type:glabalType
			}, function(ret) {
				if (ret == "OVER") {
					$.messager.alert("提示", "更新成功", "info");
				} else {
		    		$.messager.alert("提示", "更新失败", "info");
				}
			});
		}
	});
}

// 团体查询
function SearchGBIDesc() {
	var ContractID = $("#ContractID").combobox("getValue");
	var GBIDesc = $("#GBIDesc").val();
	
	$("#Groups").datagrid("load", {ClassName:"web.DHCPE.Report.GroupCollect",QueryName:"GADMList",GBIDesc:GBIDesc,ContractID:ContractID});
}

// 套餐查询
function SearchOSDesc() {
	var OSDesc = $("#OSDesc").val();
	
	$("#OrdSets").datagrid("load", {ClassName:"web.DHCPE.HISUIOrderSets",QueryName:"SearchPEOrderSets",UserID:"",subCatID:"",Conditiones:"",Desc:OSDesc});
}

// 显示体征条件维护窗口
function ShowSymptomsEditWin(){
	var new_Width = ScreenWidth - 100;
	var new_Height = ScreenHeight - 100;
	
    $("#SymptomsEditWin").css("width", new_Width);
    $("#SymptomsEditWin").css("height", new_Height);
    
	//BClear_click("Win");
	$("#SymptomsEditWin").show();

	var myWin = $HUI.dialog("#SymptomsEditWin", {
		iconCls:"icon-w-add",
		resizable:true,
		title:"体征条件维护",
		modal:true,
		buttonAlign:"center",
	});
}

// 条件维护 体征
function InitSymptomsListData() {
	$HUI.datagrid("#SymptomsList", {
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.PositiveRecord",
			QueryName:"FindPositiveRecord",
			Type:"Q"
		},
		columns:[[
			{field:'ID', title:'ID', hidden:true},
			
			{field:'Code', title:'体征编码'},
			{field:'Name', title:'体征描述'},
			{field:'MSeq', title:'男性顺序'},
			{field:'FSeq', title:'女性顺序'},  
			{field:'TUseRange', title:'作用范围', formatter: function(value, rowData, rowIndex) {
					if (value == "否") { return "个人"; }
					else if (value == "是") { return "全科"; }
					else if (value == "U") { return "个人"; }
					else if (value == "S") { return "全科"; }
					return "";
				}
			}
		]],
		collapsible: true, //收起表格的内容
		lines:true,
		striped:true, // 条纹化
		rownumbers:true,
		border:false,
		fit:true,
		fitColumns:true,
		animate:true,
		//pagination:true,   // 树形表格 不能分页
		//pageSize:25,
		//pageList:[10,25,50,100],
		
		showPageList:false,
		beforePageText:'第',
		afterPageText:'页,共{pages}页',
		pagination:true,
			
		singleSelect:true,
		toolbar: [{
			iconCls: 'icon-add',
			text:'新增',
			handler: function(){
				
				BClear_click("Win");
				$("#SymptomsListOptWin").show();
				
				var myWin = $HUI.dialog("#SymptomsListOptWin", {
					iconCls:"icon-w-add",
					resizable:true,
					title:"新增",
					modal:true,
					buttonAlign:"center",
					buttons:[{
						text:"保存",
						handler:function(){
							BAdd_click();
						}
					},{
						text:"关闭",
						handler:function(){
							myWin.close();
						}
					}]
				});
			}
		}, {
			iconCls: "icon-write-order",
			text:"修改",
			id:"BUpd",
			disabled:true,
			handler: function(){
				$("#SymptomsListOptWin").show();
				
				var SelRowData = $("#SymptomsList").datagrid("getSelected");
				if (!SelRowData) {
					$.messager.alert("提示", "请选择需要修改的行！", "info");
					//$.messager.popover({msg: "请选择需要修改的行", type:"alert"});
					return false;
				}
				$("#SymptomCodeWin").val(SelRowData.Code);  // 体征编号
				$("#SymptomDescWin").val(SelRowData.Name);  // 体征描述
				$("#SymptomManSeqWin").numberbox("setValue", SelRowData.MSeq);  // 男性顺序
				$("#SymptomFemanSeqWin").numberbox("setValue", SelRowData.FSeq);  // 女性顺序
				if (SelRowData.TUseRange == "否" || SelRowData.TUseRange == "个人") { $("#UseRangeWin").combobox("setValue", "U"); }
				else { $("#UseRangeWin").combobox("setValue", "S"); }
				
				var myWin = $HUI.dialog("#SymptomsListOptWin",{
					iconCls:'icon-w-edit',
					resizable:true,
					title:'修改',
					modal:true,
					buttonAlign:'center',
					buttons:[{
						text:'修改',
						handler:function(){
							BUpd_click();
						}
					},{
						text:'关闭',
						handler:function(){
							myWin.close();
						}
					}]
				});
			}
		}],
		onClickRow: function (rowIndex, rowData) {  // 选择行事件
			// $("#SymptomCode").val(rowData.Code);  // 体征编号
			// $("#SymptomDesc").val(rowData.Name);  // 体征描述
			// $("#SymptomManSeq").numberbox("setValue", rowData.MSeq);  // 男性顺序
			// $("#SymptomFemanSeq").numberbox("setValue", rowData.FSeq);  // 女性顺序
			// $("#UseRange").combobox("setValue", rowData.TUseRange);  // 作用范围
			
			$('#BUpd').linkbutton('enable');
			
			$("#AnalysisResultCondition").datagrid("load", {ClassName:"web.DHCPE.ExcuteExpress", QueryName:"FindExpress", ParrefRowId:rowData.ID, Type:"PR", CTLOCID:session["LOGON.CTLOCID"]}); 
			
			ConditioneditIndex = undefined;  // 重置可编辑的行号
			
			$("#NorInfo").val("");
			
		},
		onDblClickRow: function (rowIndex, rowData) {  // 双击行事件
			//$("#SymptomsList").datagrid("unselectRow");
		},
		onLoadSuccess:function(data){
		}
	});
}

// 条件维护 查询
function BSearch_click(){
	var SymptomCode = $("#SymptomCode").val();  // 体征编号
	var SymptomDesc = $("#SymptomDesc").val();  // 体征描述
	var UserID = session["LOGON.USERID"];
	var SymptomManSeq = $("#SymptomManSeq").val();  // 男性顺序
	var SymptomFemanSeq = $("#SymptomFemanSeq").val();  // 女性顺序
	var UseRange = $("#UseRange").combobox("getValue");  // 作用范围
	if (UseRange == "") { UseRange = "S"; }
	
	$HUI.datagrid("#SymptomsList", {
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.PositiveRecord",
			QueryName:"FindPositiveRecord",
			Type:"Q",
			iCode:SymptomCode,
			iDesc:SymptomDesc,
			iMSeq:SymptomManSeq,
			iFSeq:SymptomFemanSeq,
			iUserRange:UseRange
		}
	});
}

// 条件维护 新增
function BAdd_click() {
	var SymptomCode = $("#SymptomCodeWin").val();  // 体征编号
	if (SymptomCode == "") {
		$.messager.alert("提示", "请输入体征编号！", "info");
		//$.messager.popover({msg: '请输入体征编号！',type:'alert'});
		return false;
	}
	
	var SymptomDesc = $("#SymptomDescWin").val();  // 体征描述
	if (SymptomDesc == "") { $.messager.alert("提示","请输入体征描述！","info"); return false; }
	
	var UserID = session["LOGON.USERID"];
	if (UserID == "") { $.messager.alert("提示", "未获取到用户信息，请重新登陆！","info"); return false; }
	
	var SymptomManSeq = $("#SymptomManSeqWin").val();  // 男性顺序
	var SymptomFemanSeq = $("#SymptomFemanSeqWin").val();  // 女性顺序
	var UseRange = $("#UseRangeWin").combobox("getValue");  // 作用范围
	if (UseRange == "") { UseRange = "S"; }
	
	var InString = "" + "^" + SymptomCode + "^" + SymptomDesc + "^" + SymptomManSeq + "^" + SymptomFemanSeq + "^" + UseRange + "^" + UserID;
	$.m({
		ClassName:"web.DHCPE.PositiveRecord",
		MethodName:"Update",
		InString:InString,
		Type:"Q"
	},function(ret){
		var Id=ret.split("^")[1];
		ret=ret.split("^")[0];
		if (ret != "0") {
			$.messager.alert("提示", "新增失败！可能原因：体征编号或体征描述重复。", "error");
			return false;
		}
		$.messager.alert("提示", "新增成功！", "success");
		
		$("#SymptomsList").datagrid("insertRow", {
			index:0,
			row:{
				ID:Id,
				Code:SymptomCode,
				Name:SymptomDesc,
				MSeq:SymptomManSeq,
				FSeq:SymptomFemanSeq,  
				TUseRange:(UseRange="否"?"个人":"全科")
			}
		});
		$("#SymptomsListOptWin").window("close");
		$("#SymptomsList").datagrid('load',{
			    ClassName:"web.DHCPE.PositiveRecord",
				QueryName:"FindPositiveRecord",
				Type:"Q",
				iCode:$("#SymptomCode").val(),
				iDesc:$("#SymptomDesc").val(),
				iMSeq:$("#SymptomManSeq").val(),
				iFSeq:$("#SymptomFemanSeq").val(),
				iUserRange:$("#UseRange").combobox("getValue")
			
			    });

		// BClear_click("");
	});			
}

// 条件维护 修改
function BUpd_click() {
	var SymptomsId = "";
	var SelRowData = $("#SymptomsList").datagrid("getSelected");
	if (SelRowData) SymptomsId = SelRowData.ID;
	if (SymptomsId == "") { $.messager.alert("提示", "请选择需要修改的行！", "info"); return false; }
	
	var SymptomCode = $("#SymptomCodeWin").val();  // 体征编号
	if (SymptomCode == "") { $.messager.alert("提示", "请输入体征编号！", "info"); return false; }
	
	var SymptomDesc = $("#SymptomDescWin").val();  // 体征描述
	if (SymptomDesc == "") { $.messager.alert("提示", "请输入体征描述！", "info"); return false; }
	
	var UserID = session["LOGON.USERID"];
	if (UserID == "") { $.messager.alert("提示", "未获取到用户信息，请重新登陆！", "info"); return false; }
	
	var SymptomManSeq = $("#SymptomManSeqWin").val();  // 男性顺序
	var SymptomFemanSeq = $("#SymptomFemanSeqWin").val();  // 女性顺序
	var UseRange = $("#UseRangeWin").combobox("getValue");  // 作用范围
	if (UseRange == "" || UseRange == "1") { UseRange = "S"; }
	
	var InString = SymptomsId + "^" + SymptomCode + "^" + SymptomDesc + "^" + SymptomManSeq + "^" + SymptomFemanSeq + "^" + UseRange + "^" + UserID;
	
	$.m({
		ClassName:"web.DHCPE.PositiveRecord",
		MethodName:"Update",
		InString:InString,
		Type:"Q"
	},function(ret){
		var Id=ret.split("^")[1];
		ret=ret.split("^")[0];
		if (ret != "0") {
			$.messager.alert("提示", "修改失败！可能原因：体征编号或体征描述重复。", "error");
			return false;
		}
		$.messager.alert("提示","修改成功！","success");
		
		var SelRowData = $("#SymptomsList").datagrid("getSelected");
		var SelRowIndex = $("#SymptomsList").datagrid("getRowIndex", SelRowData);
		$("#SymptomsList").datagrid("updateRow", {
			index:SelRowIndex,
			row:{
				ID:Id,
				Code:SymptomCode,
				Name:SymptomDesc,
				MSeq:SymptomManSeq,
				FSeq:SymptomFemanSeq,  
				TUseRange:(UseRange=="否"?"个人":"全科")
			}
		});
		
		$("#SymptomsListOptWin").window("close");
		$("#SymptomsList").datagrid('load',{
		    ClassName:"web.DHCPE.PositiveRecord",
			QueryName:"FindPositiveRecord",
			Type:"Q",
			iCode:$("#SymptomCode").val(),
			iDesc:$("#SymptomDesc").val(),
			iMSeq:$("#SymptomManSeq").val(),
			iFSeq:$("#SymptomFemanSeq").val(),
			iUserRange:$("#UseRange").combobox("getValue")
		});
	}); 
}

// 条件维护 清屏
function BClear_click(Type) {
	if (Type == "Win") {
		$("#SymptomCodeWin").val("");  // 体征编号
		$("#SymptomDescWin").val("");  // 体征描述
		$("#SymptomManSeqWin").numberbox("setValue", "");  // 男性顺序
		$("#SymptomFemanSeqWin").numberbox("setValue", "");  // 女性顺序
		$("#UseRangeWin").combobox("setValue", "S");  // 作用范围
	} else {
		$("#SymptomCode").val("");  // 体征编号
		$("#SymptomDesc").val("");  // 体征描述
		$("#SymptomManSeq").numberbox("setValue", "");  // 男性顺序
		$("#SymptomFemanSeq").numberbox("setValue", "");  // 女性顺序
		$("#UseRange").combobox("setValue", "S");  // 作用范围
		//SetRowStyle("#SymptomsList");
	}
}

// 条件维护 表达式
function InitAnalysisResultCondition() {
	$HUI.datagrid("#AnalysisResultCondition",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.ExcuteExpress",
			QueryName:"FindExpress",
			ParrefRowId:"",
			Type:"",
			CTLOCID:session["LOGON.CTLOCID"]
		},
		fit:true,
		border:false,
		striped:true,
		fitColumns:true,
		autoRowHeight:false,
		singleSelect:true,
		selectOnCheck:false,
		columns:[[
		    {field:"TPreBracket", title:"前置括号", editor:{
					type:"combobox",
					options:{
						valueField:"id",
						textField:"text",
						data:[
							{id:"(",text:"("}, {id:"((",text:"(("}, {id:"(((",text:"((("}, {id:"((((",text:"(((("}, {id:"(((((",text:"((((("}
						]
					}
				}
		    },	
		    {field:"TItemID", title:"项目", width:130, formatter:function(value,row){
					return row.TItem;
				}, editor:{
					type:'combobox',
					options:{
						valueField:'OD_RowId',
						textField:'OD_Desc',
						method:'get',
						//mode:'remote',
						url:$URL+"?ClassName=web.DHCPE.Report.PosQuery&QueryName=FromDescOrderDetailB&CTLOCID=" + session["LOGON.CTLOCID"] + "&ResultSetType=array",
						onBeforeLoad:function(param){
							//param.Desc = param.q;
						},
						onSelect:function (rowData) {
							var String = "^" + rowData.OD_Code + "^" + rowData.OD_RowId;
							
							var NorInfo = tkMakeServerCall("web.DHCPE.ODStandard", "GetNorInfo", String);
							$("#NorInfo").val(NorInfo);
						}
						
					}
					
					/*
					type:"combogrid",
					options:{
						panelWidth:235,
						url:$URL + "?ClassName=web.DHCPE.Report.PosQuery&QueryName=FromDescOrderDetail",
						mode:"remote",
						delay:200,
						idField:"OD_RowId",
						textField:"OD_Desc",
						onBeforeLoad:function (param) {
							param.Desc = param.q;
						},
						onSelect:function (rowIndex, rowData) {
							var String = "^" + rowData.OD_Code + "^" + rowData.OD_RowId;
							
							var NorInfo = tkMakeServerCall("web.DHCPE.ODStandard", "GetNorInfo", String);
							$("#NorInfo").val(NorInfo);
						},
						columns:[[
							{field:"OD_RowId", title:"ID"},
							{field:"OD_Desc", title:"名称", width:120},
							{field:"OD_Code", title:"编码", width:100}
						]]
					}
					*/
		    	}
		    },
		    {field:"TOperator", title:"运算符", align:"center", formatter: function(value,row){
					return row.TOperatorname;
				}, editor:{
					type:"combobox",
					options:{
						valueField:"id",
						textField:"text",
						data:[
							{id:">",text:"大于"}, {id:">=",text:"大于等于"}, {id:"<",text:"小于"}, {id:"<=",text:"小于等于"},
							{id:"[",text:"包含"}, {id:"'[",text:"不包含"}, {id:"=",text:"等于"}, {id:"'=",text:"不等于"}
						]
					}
				}
		    },
			{field:"TReference", title:"参考值", width:70, editor:"text"},
			{field:"TSex", title:"性别", align:"center", formatter:function(value,row){
					return row.TSexname;
				}, editor:{
					type:"combobox",
					options:{
						valueField:"id",
						textField:"text",
						data:[
							{id:"N",text:"不限"}, {id:"M",text:"男"}, {id:"F",text:"女"}
						]
					}
				}
			},
			{field:"TNoBloodFlag", title:"非血", align:"center", editor:{
					type:"icheckbox",
					options:{on:"Y",off:"N"}
				}
			},
			{field:"TAgeRange", title:"年龄", align:"center", editor:"text"},
			{field:"TAfterBracket", title:"后置括号", editor:{
					type:"combobox",
					options:{
						valueField:"id",
						textField:"text",
						data:[
							{id:")",text:")"}, {id:"))",text:"))"}, {id:")))",text:")))"}, {id:"))))",text:"))))"}, {id:")))))",text:")))))"}
						]
					}
				}
			},
			{field:"TRelation", title:"关系", align:"center", formatter:function(value,row){
					return row.TRelationname;
				}, editor:{
					type:"combobox",
					options:{
						valueField:"id",
						textField:"text",
						data:[
							{id:"||",text:"或者"}, {id:"&&",text:"并且"}
						]
					}
				}
			},
			{field:"TAdd", title:"新增一行", align:"center", editor:{
					type:"linkbutton",
					options:{
						text:"新增一行",
						handler:function(){
							var NewConditioneditIndex = ConditioneditIndex + 1;
							ConditionendEditing();
							$("#AnalysisResultCondition").datagrid("insertRow", {
								index: NewConditioneditIndex,
								row: {
									TPreBracket:"",
									TItemID:"",
									TOperator:"",
									TReference:"",
									TSex:"",
									TNoBloodFlag:"",
									TAgeRange:"",
									TAfterBracket:"",
									TRelation:"",
									TAdd:"新增一行",
									TDelete:"删除一行"
								}
							});
							$("#AnalysisResultCondition").datagrid("selectRow", NewConditioneditIndex).datagrid("beginEdit", NewConditioneditIndex);
							ConditioneditIndex = NewConditioneditIndex;
						}
					}
				}
			},
			{field:"TDelete", title:"删除一行", align:"center", editor: {
					type:"linkbutton",
					options:{
						text:"删除一行",
						handler:function() {
							$("#AnalysisResultCondition").datagrid("deleteRow",ConditioneditIndex);
							ConditioneditIndex = undefined;
						}
					}
				}
			}
		]],
		onClickRow: function (rowIndex, rowData) {
			ConditionClickRow(rowIndex);
		},
		onAfterEdit: function (rowIndex,rowData,changes) {
			
		},
		onSelect: function (rowIndex, rowData) {
		}
	});	
}

var ConditioneditIndex = undefined;
function ConditionClickRow(index) {
	if (ConditioneditIndex != index) {
		if (ConditionendEditing()){
			$("#AnalysisResultCondition").datagrid("getRows")[index]["TAdd"] = "新增一行";
			$("#AnalysisResultCondition").datagrid("getRows")[index]["TDelete"] = "删除一行";
			$("#AnalysisResultCondition").datagrid("selectRow", index).datagrid("beginEdit", index);
						
			ConditioneditIndex = index;
		} else {
			$("#AnalysisResultCondition").datagrid("selectRow", ConditioneditIndex);
		}
	}
}

function ConditionendEditing(){
	if (ConditioneditIndex == undefined) { return true; }
	if ($("#AnalysisResultCondition").datagrid("validateRow", ConditioneditIndex)) {
		
		// 细项
		var ed = $("#AnalysisResultCondition").datagrid("getEditor", {index:ConditioneditIndex, field:"TItemID"});
		if (ed == null) { return true; }
		var ItemDesc = $(ed.target).combobox("getText");
		$("#AnalysisResultCondition").datagrid("getRows")[ConditioneditIndex]["TItem"] = ItemDesc;
		
		// 操作符
		var ed = $("#AnalysisResultCondition").datagrid("getEditor", {index:ConditioneditIndex, field:"TOperator"});
		if (ed == null) { return true; }
		var TOperatorname = $(ed.target).combobox("getText");
		$("#AnalysisResultCondition").datagrid("getRows")[ConditioneditIndex]["TOperatorname"] = TOperatorname;
		
		// 性别
		var ed = $("#AnalysisResultCondition").datagrid("getEditor", {index:ConditioneditIndex, field:"TSex"});
		if (ed == null) { return true; }
		var TSexname = $(ed.target).combobox("getText");
		$("#AnalysisResultCondition").datagrid("getRows")[ConditioneditIndex]["TSexname"] = TSexname;
		
		// 关系
		var ed = $("#AnalysisResultCondition").datagrid("getEditor", {index:ConditioneditIndex, field:"TRelation"});
		if (ed == null) { return true; }
		var TRelationname = $(ed.target).combobox("getText");
		$("#AnalysisResultCondition").datagrid("getRows")[ConditioneditIndex]["TRelationname"] = TRelationname;
		
		$("#AnalysisResultCondition").datagrid("endEdit", ConditioneditIndex);
				
		ConditioneditIndex = undefined;
		return true;
	} else {
		return false;
	}
}

// 条件维护 表达式保存
function BSave_click() {
	ConditionendEditing();
	
	var ParrefRowId = ""
	var SelRowData = $("#SymptomsList").datagrid("getSelected");
	if (SelRowData) ParrefRowId = SelRowData.ID;
	if (ParrefRowId == "") {
		$.messager.alert("提示", "请先选择体征再维护对应的表达式！", "info");
		return false;
	}
	
	$("#ConfirmSaveWin").show();
	
	// 此处需增加按钮的取消点击事件 否则会更新已点击的行
	$("#BSaveAndUpdWin").unbind("click");
	$("#BSaveWin").unbind("click");
	$("#BCancelWin").unbind("click");
	
	var myWin = $HUI.dialog("#ConfirmSaveWin", {
		iconCls:"icon-w-star",
		title:"重要提示",
		modal:true,
		buttonAlign:"center",
		/*
		buttons:[{
			text:"&nbsp;保存并更新&nbsp;",
			handler:function() {
				if (Save(ParrefRowId)) {
					var Info = $.m({ClassName:"web.DHCPE.Statistic.IllnessStatistic", MethodName:"SetResultAnalysisTargetByPR", Type:glabalType, PositiveRecord:ParrefRowId}, false);
					if(Info != "") {
						$.messager.alert("提示","" + Info,"info");
					} else {
						$.messager.popover({msg:"正在生成指标。", type:"success", timeout: 5000, showType:"slide"});
					}
				} else {
					//$.messager.alert("提示","表达式保存失败！","info");
				}
				myWin.close();
			}
		},{
			text:"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;保存&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;",
			handler:function(){
				Save(ParrefRowId);
				myWin.close();
			}
		},{
			text:"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;取消&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;",
			handler:function(){
				myWin.close();
			}
		}]
		*/
	});
	
	$("#BSaveAndUpdWin").click(function() {  // 保存并更新
		var errStr = tkMakeServerCall("web.DHCPE.Statistic.IllnessStatistic", "GetResultAnalysisErrInfo", glabalType);
		var errInfo = errStr.split("^");
		if (errInfo[0] != "0") {
			$.messager.alert("提示", "无法保存并更新，" + errInfo[1], "info");
			// $.messager.popover({msg:"无法保存并更新，" + errInfo[1], type:"alert", timeout: 3000, showType:"slide"});
			if (errInfo[0] == "1") {
				$('#BSetAllTarget').linkbutton('disable');
			} else {
				$('#BSetAllTarget').linkbutton('enable');
			}
			return false;
		} else {
			$('#BSetAllTarget').linkbutton('disable');
		}
		
		if (Save(ParrefRowId)) {
			var Info = $.m({ClassName:"web.DHCPE.Statistic.IllnessStatistic", MethodName:"SetResultAnalysisTargetByPR", Type:glabalType, PositiveRecord:ParrefRowId}, false);
			if(Info != "") {
				$.messager.alert("提示","" + Info,"info");
			} else {
				$.messager.popover({msg:"正在生成指标。", type:"success", timeout: 5000, showType:"slide"});
			}
		} else {
			//$.messager.alert("提示","表达式保存失败！","info");
		}
		myWin.close();
	});
	
	$("#BSaveWin").click(function() {  // 保存
		Save(ParrefRowId);
		myWin.close();
	});
	
	$("#BCancelWin").click(function() {  // 取消
		myWin.close();
	});
		
}

function Save(ParrefRowId) {
	var Char_1 = String.fromCharCode(1);
	var Express = "";
	var rows = $("#AnalysisResultCondition").datagrid("getRows"); 
	
	for(var i=0; i<rows.length; i++){
		var OneRowInfo = "", Select = "N", PreBracket = "", ItemID = "", Operator = "", ODStandardID = "", Reference = "", AfterBracket = "", Relation =" ", Sex = "N";
		
		ItemID = rows[i].TItemID;
		
		if (ItemID == "") {
			//$.messager.alert("提示", "第" + (i+1) + "行，没有回车选择具体的项目！", "info");
			break;
			//return false;
		}
		
		PreBracket = rows[i].TPreBracket;
		AfterBracket = rows[i].TAfterBracket;
		Relation = rows[i].TRelation;
		Operator = rows[i].TOperator;
		Reference = rows[i].TReference;
		Sex = rows[i].TSex;
		if (Sex == "") { Sex = "N"; }
		NoBloodFlag = rows[i].TNoBloodFlag;
		ODStandardID = "";
		AgeRange = rows[i].TAgeRange;
		if(AgeRange != "") {
			if(AgeRange.indexOf("-") == -1) {
				$.messager.alert("提示", "输入年龄范围格式不正确,应为10-20!", "info");
				return false;
			}
			var AgeMin=AgeRange.split("-")[0];
			var AgeMax=AgeRange.split("-")[1];
			if((isNaN(AgeMin)) || (isNaN(AgeMax))) {
				$.messager.alert("提示","输入年龄不是数字!","info");
				return false;
			}
		}
		OneRowInfo = PreBracket + "^" + ItemID + "^" + Operator + "^" + ODStandardID + "^" + Reference + "^" + Sex + "^" + AfterBracket + "^" + Relation + "^" + NoBloodFlag + "^" + AgeRange;
		
		if (Express != "") {
			Express = Express + Char_1 + OneRowInfo;
		}else{
			Express = OneRowInfo;
		}
	}
	
	var iType = "PR";
	var ret = tkMakeServerCall("web.DHCPE.ExcuteExpress","SaveNewExpress",iType,ParrefRowId,Express);
	
	if (ret == 0){
		$("#AnalysisResultCondition").datagrid("load",{ClassName:"web.DHCPE.ExcuteExpress",QueryName:"FindExpress",ParrefRowId:ParrefRowId,Type:"PR",CTLOCID:session["LOGON.CTLOCID"]});
		return true;
	} else {
		return false;
	}
	return false;
}

function SetRowStyle(tablename) {
	var rows = $(tablename).datagrid("getRows");
	for(var i=0;i<rows.length;i++) {
		var tableDiv = tablename.replace(/List/g, "Div");
		var gridTrbar = $(tableDiv+" .datagrid-btable tbody tr:nth-child(" + ( i + 1 ) + ")");
		if (gridTrbar) {
			if ( (i % 2) == 0) {
				gridTrbar.css("background-color", "#FAFAFA");
			} else {
				gridTrbar.css("background-color", "#FFFFFF");
			}
		}
	}
}

function OnPropChanged(event, Type) {
	if (event.propertyName.toLowerCase() == "value") {
		if (Type == "Groups") {
			SearchGBIDesc();
		} else if (Type == "OrdSets") {
			SearchOSDesc();
		}
	}
}