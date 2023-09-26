/**
 * exportoetpl.hui.js 医嘱模板导入导出
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2018-08-10
 * 
 * 注解说明
 * TABLE: 
 */
 
//页面全局变量
var PageOBJ = {
	m_UserCombox : "",
	m_DepCombox: "",
	m_QueDateTableGrid:""
}

$(document).ready(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	
});
function Init() {
	//科室
	var locCombo = $HUI.combobox("#FCTLocName", {
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=LookUpCTLoc&desc=&ResultSetType=array&HospId="+session['LOGON.HOSPID'],
		valueField:'ID',
		textField:'CTLOC',
		mode: "local",
		filter: function(q, row){
			var ops = $(this).combobox('options');  
			var mCode = false;
			if (row.ContactName) {
				mCode = row.ContactName.toUpperCase().indexOf(q.toUpperCase()) >= 0
			}
			var mValue = row[ops.textField].indexOf(q) >= 0;
			return mCode||mValue;  
		}
	})
	PageOBJ.m_DepCombox = locCombo;
	
	//用户
	var userCombo = $HUI.combobox("#FUserName", {
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=LookUpUser&desc=&ResultSetType=array&HospId="+session['LOGON.HOSPID'],
		valueField:'ID',
		textField:'USER'
		
		
	})
	PageOBJ.m_UserCombox = userCombo;
}

function InitEvent () {
	$("#Departments").radio({
		onChecked:function () {
			PageOBJ.m_UserCombox.disable();
			PageOBJ.m_DepCombox.enable();
			PageOBJ.m_UserCombox.setValue("");
		}
	})
	
	$("#Personal").radio({
		onChecked:function () {
			PageOBJ.m_DepCombox.disable();
			PageOBJ.m_UserCombox.enable();
			PageOBJ.m_DepCombox.setValue("");
		}
	})
	
	//查询
	$('#FindButton').click(FindHandler);
	
	//清空
	$('#resetButton').click(resetCondition);
	
	//导入
	$('#Import').click(ImportHandler);
	
	//导出
	$('#Export').click(ExportHandler);
	
	//
	$(document.body).bind("keydown",BodykeydownHandler)
	
	$('#Template_tabs').tabs({
		onSelect: function (title,index) {
			$(".tpl ul>li").each(function(){
				$(this).on("click",function() {
					if ($(this).hasClass("active")) {
						$(this).removeClass("active");
					} else {
						$(this).addClass("active");
					}
					
				})
			})
		}
	});
}

//查询
function FindHandler(){
	var Params=GetParams()
	if (Params==false){
		return;
	}
	var ParamsArr=Params.split("^");
	var HandleDataType=ParamsArr[0],OperType=ParamsArr[1],CTLocName=ParamsArr[2],CTLocID=ParamsArr[3];
	var UserName=ParamsArr[4],UserID=ParamsArr[5],AppKey=ParamsArr[6];
	if (HandleDataType=="OrdTemp"){
		//医嘱模板
		FindOrdTempHandler(OperType,CTLocID,CTLocName,UserID,UserName,AppKey)
	}else if (HandleDataType=="DiaTemp"){
		//诊断模板
		FindDiagTempHandler(OperType,CTLocID,CTLocName,UserID,UserName,AppKey)
	}else if (HandleDataType=="ARCOS"){
		//医嘱套
		FindARCOSHandler(OperType,CTLocID,CTLocName,UserID,UserName,AppKey)
	}else if (HandleDataType=="UserFav"){
		//用户常用用法
		FindDocItemDefaultHandler(OperType,CTLocID,CTLocName,UserID,UserName,AppKey)
	}
	
}
//查询用户常用用法
function FindDocItemDefaultHandler(OperType,CTLocID,CTLocName,UserID,UserName,AppKey){
	var objectReference = "";
	var ObjectType="";
	if(OperType == "Personal"){
		objectReference = UserID;
		ObjectType="User.SSUser";	//oeorder.entry.redrawprefs.other.csp
	}else if(OperType=="Departments"){
		objectReference = CTLocID;
		ObjectType="User.CTLoc";
	}
	var Columns=[[
		{field:'ObjectType',title:'存储类型代码',width:100},
		{field:'ObjectDesc',title:'存储类型描述',width:100},
		{field:'ObjectCode',title:'保存类型值',width:100},
		{field:'HospCode',title:'院区代码',width:100},
		{field:'RelevanceNo',title:'关联',hidden:true},
		{field:'ARCIMCode',title:'医嘱项代码',width:100},
		{field:'ArcimDesc',title:'医嘱项',width:200},
		{field:'Priority',title:'医嘱类型',width:100},
		{field:'Dose',title:'单次剂量',width:70},
		{field:'DoseUom',title:'计量单位',width:70},
		{field:'Instr',title:'用法',width:70},
		{field:'PHFreq',title:'频次',width:70},
		{field:'Durat',title:'疗程',width:70},
		{field:'PackQty',title:'数量',width:70},
		{field:'SkinTest',title:'皮试',width:70},
		{field:'SkinAction',title:'皮试备注',width:100},
		{field:'Notes',title:'备注',width:100},
		{field:'TPAAdmType',title:'就诊类型',width:70},
		{field:'SpeedFlowRate',title:'流速',width:70},
		{field:'FlowRateUnit',title:'流速单位',width:100},
		{field:'ExceedReason',title:'超量原因',width:100},
		{field:'RecLocDesc',title:'接收科室',width:120},
		{field:'RecLocCode',title:'接收科室代码',width:120},
		{field:'RecLocHospCode',title:'接收科室所在院区代码',width:100}
    ]]
	PageOBJ.m_QueDateTableGrid=$("#DateTable").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 15,
		pageList : [15,100,200],
		idField:'ARCIMCode',
		columns :Columns
	});
	$.q({
	    ClassName : "web.DHCDocPrefTabs",
	    QueryName : "FindDocItemDefault",
	    objtype:ObjectType,
	    objvalue:objectReference,
	    HospRowId:session['LOGON.HOSPID'],
	    Pagerows:PageOBJ.m_QueDateTableGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageOBJ.m_QueDateTableGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
///查询医嘱套信息
function FindARCOSHandler(OperType,CTLocID,CTLocName,UserID,UserName,AppKey){
	var objectReference = "";
	var ObjectType="";
	if(OperType == "Personal"){
		objectReference = UserID;
		ObjectType="User.SSUser";	//oeorder.entry.redrawprefs.other.csp
	}else if(OperType=="Departments"){
		objectReference = CTLocID;
		ObjectType="User.CTLoc";
	}
	var Columns=[[ 
		{field:'ARCOSNum',title:'医嘱套流水',width:50},
		{field:'ARCOSCode',title:'医嘱套代码',width:100},
		{field:'ARCOSDesc',title:'医嘱套名称',width:120},
		{field:'ARCOSAlias',title:'别名',width:100},
		{field:'ARCOSOrdCat',title:'大类',width:70},
		{field:'ARCOSOrdSubCat',title:'子类',width:70},
		{field:'ARCOSEffDateFrom',title:'起始日期',width:70},
		{field:'UserName',title:'用户',width:70},
		{field:'UserCode',title:'用户工号',width:70},
		{field:'LocDesc',title:'科室',width:70},
		{field:'LocCode',title:'科室代码',width:70},
		{field:'FavMedUnitDesc',title:'科室组',width:70},
		{field:'HospCode',title:'院区代码',width:70},
		{field:'CelerType',title:'快速标识',width:50},
		{field:'CMPrescTypeCode',title:'处方类型',width:120},
		{field:'CMDuratDesc',title:'付数',width:80},
		{field:'CMFreqDesc',title:'频次',width:80},
		{field:'CMInstrDesc',title:'用法',width:80},
		{field:'CMDoseQty',title:'一次用量',width:80},
		{field:'CMNotes',title:'备注',width:100},
		{field:'P1',width:100,hidden:true},
		{field:'P2',width:100,hidden:true},
		{field:'P3',width:100,hidden:true},
		{field:'P4',width:100,hidden:true},
		{field:'P5',width:100,hidden:true},
		{field:'NO',title:'序号',width:60},
		{field:'ARCOSItmLinkDoctor',title:'关联',width:40},
		{field:'ARCIMCode',title:'医嘱项代码',width:120},
		{field:'ARCIMDesc',title:'医嘱项名称',width:200},
		{field:'DoseQty',title:'单次剂量',width:70},
		{field:'DoseUOM',title:'计量单位',width:70},
		{field:'Frequence',title:'频次',width:70},
		{field:'Duration',title:'疗程',width:70},
		{field:'Instruction',title:'用法',width:100},
		{field:'PackQty',title:'数量',width:50},
		{field:'PackQtyBillUOM',title:'数量单位',width:100},
		{field:'DHCDocOrdRecLocCode',title:'接收科室代码',width:90},
		{field:'DHCDocOrdRecHospCode',title:'接收科室院区代码',width:90},
		{field:'Tremark',title:'备注',width:100},
		{field:'OECPRDesc',title:'医嘱类型',width:100},
		{field:'SampleDesc',title:'标本',width:70},
		{field:'OrderPriorRemarks',title:'附加说明',width:100},
		{field:'DHCDocOrdStage',title:'阶段',width:100},
		{field:'DHCMustEnter',title:'必填',width:100},
		{field:'SpeedFlowRate',title:'流速',width:100},
		{field:'FlowRateUnit',title:'流速单位',width:100},
		{field:'OrderBodyPartLabel',title:'部位',width:100},
		{field:'NotifyClinician',title:'加急',width:60},
		{field:'SkinTest',title:'皮试',width:60},
		{field:'SkinTestAction',title:'皮试备注',width:100},
		{field:'RemoveCeler',title:'快速例外',width:60}
    ]]
	PageOBJ.m_QueDateTableGrid=$("#DateTable").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 15,
		pageList : [15,100,200],
		idField:'ARCIMCode',
		columns :Columns
	});
	$.q({
	    ClassName : "web.DHCDocPrefTabs",
	    QueryName : "FindARCOS",
	    objtype:ObjectType,
	    objvalue:objectReference,
	    HospRowId:session['LOGON.HOSPID'],
	    Pagerows:PageOBJ.m_QueDateTableGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageOBJ.m_QueDateTableGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}

///查询诊断模板
function FindDiagTempHandler(OperType,CTLocID,CTLocName,UserID,UserName,AppKey){
	var objectReference = "";
	var ObjectType="";
	if(OperType == "Personal"){
		objectReference = UserID;
		ObjectType="User.SSUser";	//oeorder.entry.redrawprefs.other.csp
	}else if(OperType=="Departments"){
		objectReference = CTLocID;
		ObjectType="User.CTLoc";
	}
	$("#Instructions").remove();
	var Columns=[[ 
		{field:'MASHospCode',title:'医院代码',width:100},
		{field:'MASType',title:'类型',width:100},
		{field:'MASTypeDesc',title:'类型描述',width:100},
		{field:'MASTypeCode',title:'类型代码',width:60},
		{field:'MASDesc',title:'模板名称',width:100},
		{field:'MASIndex',title:'模板标号',width:50},
		{field:'ICDListNum',title:'列位置',width:50},
		{field:'ICDListIndex',title:'顺序编号',width:50},
		{field:'ALLDesc',title:'总描述',width:200},
		{field:'ICDDesc',title:'描述',width:100},
		{field:'ICDCode',title:'描述代码',width:100},
		{field:'ICDSyndromeCodeInfo',title:'证型代码',width:200}
    ]]
	PageOBJ.m_QueDateTableGrid=$("#DateTable").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 15,
		pageList : [15,100,200],
		idField:'ALLDesc',
		columns :Columns
	});
	$.q({
	    ClassName : "web.DHCDocPrefTabs",
	    QueryName : "FindDiagTemp",
	    objtype:ObjectType,
	    objvalue:objectReference,
	    HospRowId:session['LOGON.HOSPID'],
	    Pagerows:PageOBJ.m_QueDateTableGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageOBJ.m_QueDateTableGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
	
}
///查询医嘱模板数据
function FindOrdTempHandler(OperType,CTLocID,CTLocName,UserID,UserName,AppKey){
	var objectReference = "";
	var ObjectType="";
	if(OperType == "Personal"){
		//查询个人模版
		objectReference = UserID;
		ObjectType="User.SSUser";	//oeorder.entry.redrawprefs.other.csp
	}else if(OperType=="Departments"){
		//查询科室模版
		objectReference = CTLocID;
		ObjectType="User.CTLoc";
	}
	$("#Instructions").remove();
	var Columns=[[ 
		{field:'HospCode',title:'院区代码',width:100},
		{field:'valueDesc',title:'类型描述',width:100},
		{field:'valueCode',title:'类型代码',width:100},
		{field:'valueIndex',title:'类型索引',width:60},
		{field:'Type',title:'类型',width:100},
		{field:'AppKey',title:'应用代码',width:200},
		{field:'Tab',title:'表名',width:100},
		{field:'Col',title:'列名',width:70},
		{field:'ARCIMorARCOS',title:'医嘱或医嘱套',width:100},
		{field:'Desc',title:'项目描述',width:200},
		{field:'Code',title:'项目代码',width:200},
		{field:'Index',title:'序号',width:100},
		{field:'itemrowid',title:'项目ID',width:100},
		{field:'PartCodeInfo',title:'部位代码列表',width:200}
		
    ]]
	PageOBJ.m_QueDateTableGrid=$("#DateTable").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 15,
		pageList : [15,100,200],
		idField:'itemrowid',
		columns :Columns
	});
	$.q({
	    ClassName : "web.DHCDocPrefTabs",
	    QueryName : "FindPrefTabs",
	    objtype:ObjectType,
	    objvalue:objectReference,
	    paramKey:AppKey,
	    HospRowId:session['LOGON.HOSPID'],
	    Pagerows:PageOBJ.m_QueDateTableGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageOBJ.m_QueDateTableGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
	
}
//清空
function resetCondition(){
	PageOBJ.m_UserCombox.setValue("");
	PageOBJ.m_DepCombox.setValue("");
	$("#AppKey").val("");
	$("#Departments").radio("uncheck");
	$("#Personal").radio("uncheck");
	$("#TemplateExcel").filebox("clear");
	PageOBJ.m_UserCombox.enable();
	PageOBJ.m_DepCombox.enable();
	PageOBJ.m_QueDateTableGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',[]);
}


var componentxml ="\\temp\\excel\\"
var path = tkMakeServerCall("ext.util.String","GetPhysicalPath","",componentxml);
//导出
function ExportHandler(){
	var Params=GetParams()
	if (Params==false){
		return;
	}
	var ParamsArr=Params.split("^");
	var HandleDataType=ParamsArr[0],OperType=ParamsArr[1],CTLocName=ParamsArr[2],CTLocID=ParamsArr[3];
	var UserName=ParamsArr[4],UserID=ParamsArr[5],AppKey=ParamsArr[6];
	if (HandleDataType=="OrdTemp"){
		//医嘱模板
		ExportOETabItems(OperType,CTLocID,CTLocName,UserID,UserName,AppKey)
	}else if (HandleDataType=="DiaTemp"){
		//诊断模板
		ExportDiagTempHandler(OperType,CTLocID,CTLocName,UserID,UserName,AppKey)
	}else if (HandleDataType=="ARCOS"){
		//医嘱套
		ExportARCOSHandler(OperType,CTLocID,CTLocName,UserID,UserName,AppKey)
	}else if (HandleDataType=="UserFav"){
		//用户常用用法
		ExportDocItemDefaultHandler(OperType,CTLocID,CTLocName,UserID,UserName,AppKey)
	}
}
//导出用户常用用法
function ExportDocItemDefaultHandler(OperType,CTLocID,CTLocName,UserID,UserName,AppKey){
	var objectReference = "";
	var ObjectType="";
	if(OperType == "Personal"){
		objectReference = UserID;
		ObjectType="User.SSUser";
		xlsname=UserID;
	}else if(OperType=="Departments"){
		objectReference = CTLocID;
		ObjectType="User.CTLoc";
		xlsname=CTLocID;
	}else{
		xlsname="ALL";
	}
	var Str ="(function test(x){"
		Str +="var xlApp = new ActiveXObject('Excel.Application');"
		Str +="var xlBook = xlApp.Workbooks.Add();"
		Str +="var xlSheet = xlBook.ActiveSheet;"
		Str +="xlSheet.Columns.NumberFormatLocal = '@';"
		//设置工作薄名称  
		Str +="xlSheet.name = '"+xlsname+"DocItemDefault.xlsx';"; 
		var TitleList=$.m({
			 ClassName:"web.DHCDocPrefTabs",
			 MethodName:"GetQueryTitleList",
			 ClassQuery:"web.DHCDocPrefTabs:FindDocItemDefault"
		},false);
		TitleList=TitleList.split(String.fromCharCode(1))[1]
		for (var i=0;i<TitleList.split(String.fromCharCode(9)).length;i++) {
			Str +="xlSheet.cells("+(1)+","+(i+1)+")='"+TitleList.split(String.fromCharCode(9))[i]+"';";
		}	
		var data=$.cm({
		   ClassName:"web.DHCDocPrefTabs",
		   QueryName:"FindDocItemDefault",
		   objtype:ObjectType, 
		   objvalue:objectReference,
		   rows:99999
		},false);	
		for (var i=0;i<data['total'];i++){
			var j=0;
			for ( var id in data['rows'][i]) {
				Str +="xlSheet.cells("+(i+2)+","+(j+1)+")='"+data['rows'][i][id]+"';";
				j++;
			}
		}
		var filename=xlsname+"DocItemDefault.xls";
		Str += "var fname = xlApp.Application.GetSaveAsFilename('"+filename+"', 'Excel Spreadsheets (*.xls), *.xls');" 
		Str += "xlBook.SaveAs(fname);"
		Str +="xlApp.Visible = false;"
		Str +="xlApp.UserControl = false;"
		Str +="xlBook.Close(savechanges=false);"
		Str +="xlApp.Quit();"
		Str +="xlSheet=null;"
		Str +="xlBook=null;"
		Str +="xlApp=null;"
		Str +="return 1;}());";
	//以上为拼接Excel打印代码为字符串
	CmdShell.notReturn =1;   //设置无结果调用，不阻塞调用
	var rtn =CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
	/*var oXL = new ActiveXObject("Excel.Application"); //创建AX对象excel   
	var oWB = oXL.Workbooks.Add(); //获取workbook对象   
	var oSheet = oWB.ActiveSheet; //激活当前sheet
	oSheet.Columns.NumberFormatLocal = "@";
	//设置工作薄名称  
	oSheet.name = xlsname+"DocItemDefault"; 
	var TitleList=$.m({
		 ClassName:"web.DHCDocPrefTabs",
		 MethodName:"GetQueryTitleList",
		 ClassQuery:"web.DHCDocPrefTabs:FindDocItemDefault"
	},false);
	TitleList=TitleList.split(String.fromCharCode(1))[1]
	for (var i=0;i<TitleList.split(String.fromCharCode(9)).length;i++) {
		oSheet.Cells(1,i+1).value = TitleList.split(String.fromCharCode(9))[i];
	}	
	var data=$.cm({
	   ClassName:"web.DHCDocPrefTabs",
	   QueryName:"FindDocItemDefault",
	   objtype:ObjectType, 
	   objvalue:objectReference,
	   rows:99999
	},false);	
	for (var i=0;i<data['total'];i++){
		var j=0;
		for ( var id in data['rows'][i]) {
			oSheet.Cells(i+2,j+1).value = data['rows'][i][id];
			j++;
		}
	}
	oXL.Visible = false; //设置excel可见属性
	var fname = oXL.Application.GetSaveAsFilename(xlsname+"DocItemDefault.xls", "Excel Spreadsheets (*.xls), *.xls");
	oWB.SaveAs(fname);
	oWB.Close(savechanges=false);
	oXL.Quit();
	oXL=null;*/
	/*//后台直接导出
	var ret=tkMakeServerCall("web.DHCDocPrefTabs","ExportDocItemDefaultXls",ObjectType,objectReference,xlsname);
	if (ret==1){
		//下载到本地
	    var filename=xlsname+"DocItemDefault.xls";
	    //dhctt.file.csp
	    $("#DownLoad").attr("href","websys.file.utf8.csp?act=download&dirname="+path+"&filename="+unescape(filename)+"&servertype=HTTP");
	    //document.getElementById("DownLoad").click();
	    $("#DownLoad")[0].click();
	}else{
		$.messager.alert("提示", "文件导出失败!", 'info');
	}*/
}
//导出医嘱套
function ExportARCOSHandler(OperType,CTLocID,CTLocName,UserID,UserName,AppKey){
	var objectReference = "";
	var ObjectType="";
	if(OperType == "Personal"){
		objectReference = UserID;
		ObjectType="User.SSUser";
		xlsname=UserID;
	}else if(OperType=="Departments"){
		objectReference = CTLocID;
		ObjectType="User.CTLoc";
		xlsname=CTLocID;
	}else{
		xlsname="ALL";
	}
	var Str ="(function test(x){"
		Str +="var xlApp = new ActiveXObject('Excel.Application');"
		Str +="var xlBook = xlApp.Workbooks.Add();"
		Str +="var xlSheet = xlBook.ActiveSheet;"
		Str +="xlSheet.Columns.NumberFormatLocal = '@';"
		//设置工作薄名称  
		Str +="xlSheet.name = '"+xlsname+"ARCOS.xlsx';"; 
		var TitleList=$.m({
			 ClassName:"web.DHCDocPrefTabs",
			 MethodName:"GetQueryTitleList",
			 ClassQuery:"web.DHCDocPrefTabs:FindARCOS"
		},false);
		TitleList=TitleList.split(String.fromCharCode(1))[1]
		for (var i=0;i<TitleList.split(String.fromCharCode(9)).length;i++) {
			Str +="xlSheet.cells("+(1)+","+(i+1)+")='"+TitleList.split(String.fromCharCode(9))[i]+"';";
		}
		var data=$.cm({
		   ClassName:"web.DHCDocPrefTabs",
		   QueryName:"FindARCOS",
		   objtype:ObjectType, 
		   objvalue:objectReference,
		   rows:99999
		},false);	
		for (var i=0;i<data['total'];i++){
			var j=0;
			for ( var id in data['rows'][i]) {
				Str +="xlSheet.cells("+(i+2)+","+(j+1)+")='"+data['rows'][i][id]+"';";
				j++;
			}
		}
		var filename=xlsname+"ARCOS.xls";
		Str += "var fname = xlApp.Application.GetSaveAsFilename('"+filename+"', 'Excel Spreadsheets (*.xls), *.xls');" 
		Str += "xlBook.SaveAs(fname);"
		Str +="xlApp.Visible = false;"
		Str +="xlApp.UserControl = false;"
		Str +="xlBook.Close(savechanges=false);"
		Str +="xlApp.Quit();"
		Str +="xlSheet=null;"
		Str +="xlBook=null;"
		Str +="xlApp=null;"
		Str +="return 1;}());";
	//以上为拼接Excel打印代码为字符串
	CmdShell.notReturn =1;   //设置无结果调用，不阻塞调用
	var rtn =CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
	/*var oXL = new ActiveXObject("Excel.Application"); //创建AX对象excel   
	var oWB = oXL.Workbooks.Add(); //获取workbook对象   
	var oSheet = oWB.ActiveSheet; //激活当前sheet
	oSheet.Columns.NumberFormatLocal = "@";
	//设置工作薄名称  
	oSheet.name = xlsname+"ARCOS"; 
	var TitleList=$.m({
		 ClassName:"web.DHCDocPrefTabs",
		 MethodName:"GetQueryTitleList",
		 ClassQuery:"web.DHCDocPrefTabs:FindARCOS"
	},false);
	TitleList=TitleList.split(String.fromCharCode(1))[1]
	for (var i=0;i<TitleList.split(String.fromCharCode(9)).length;i++) {
		oSheet.Cells(1,i+1).value = TitleList.split(String.fromCharCode(9))[i];
	}	
	var data=$.cm({
	   ClassName:"web.DHCDocPrefTabs",
	   QueryName:"FindARCOS",
	   objtype:ObjectType, 
	   objvalue:objectReference,
	   rows:99999
	},false);	
	for (var i=0;i<data['total'];i++){
		var j=0;
		for ( var id in data['rows'][i]) {
			oSheet.Cells(i+2,j+1).value = data['rows'][i][id];
			j++;
		}
	}
	oXL.Visible = false; //设置excel可见属性
	var fname = oXL.Application.GetSaveAsFilename(xlsname+"ARCOS.xls", "Excel Spreadsheets (*.xls), *.xls");
	oWB.SaveAs(fname);
	oWB.Close(savechanges=false);
	oXL.Quit();
	oXL=null;*/
	/*
	//后台直接导出
	var ret=tkMakeServerCall("web.DHCDocPrefTabs","ExportARCOSXls",ObjectType,objectReference,xlsname);
	if (ret==1){
		//下载到本地
	    var filename=xlsname+"ARCOS.xls";
	    //dhctt.file.csp
	    $("#DownLoad").attr("href","websys.file.utf8.csp?act=download&dirname="+path+"&filename="+unescape(filename)+"&servertype=HTTP");
	    //document.getElementById("DownLoad").click();
	    $("#DownLoad")[0].click();
	}else{
		$.messager.alert("提示", "文件导出失败!", 'info');
	}*/
}
//导出诊断模板
function ExportDiagTempHandler(OperType,CTLocID,CTLocName,UserID,UserName,AppKey){
	var objectReference = "";
	var ObjectType="";
	if(OperType == "Personal"){
		objectReference = UserID;
		ObjectType="User.SSUser";
		xlsname=UserID;
	}else if(OperType=="Departments"){
		objectReference = CTLocID;
		ObjectType="User.CTLoc";
		xlsname=CTLocID;
	}else{
		xlsname="ALL";
	}
	var Str ="(function test(x){"
		Str +="var xlApp = new ActiveXObject('Excel.Application');"
		Str +="var xlBook = xlApp.Workbooks.Add();"
		Str +="var xlSheet = xlBook.ActiveSheet;"
		Str +="xlSheet.Columns.NumberFormatLocal = '@';"
		//设置工作薄名称  
		Str +="xlSheet.name = '"+xlsname+"DiagTemp.xlsx';"; 
		var TitleList=$.m({
			 ClassName:"web.DHCDocPrefTabs",
			 MethodName:"GetQueryTitleList",
			 ClassQuery:"web.DHCDocPrefTabs:FindDiagTemp"
		},false);
		TitleList=TitleList.split(String.fromCharCode(1))[1]
		for (var i=0;i<TitleList.split(String.fromCharCode(9)).length;i++) {
			Str +="xlSheet.cells("+(1)+","+(i+1)+")='"+TitleList.split(String.fromCharCode(9))[i]+"';";
		}	
		var data=$.cm({
		   ClassName:"web.DHCDocPrefTabs",
		   QueryName:"FindDiagTemp",
		   objtype:ObjectType, 
		   objvalue:objectReference,
		   rows:99999
		},false);	
		for (var i=0;i<data['total'];i++){
			var j=0;
			for ( var id in data['rows'][i]) {
				Str +="xlSheet.cells("+(i+2)+","+(j+1)+")='"+data['rows'][i][id]+"';";
				j++;
			}
		}
		var filename=xlsname+"DiagTemp.xls";
		Str += "var fname = xlApp.Application.GetSaveAsFilename('"+filename+"', 'Excel Spreadsheets (*.xls), *.xls');" 
		Str += "xlBook.SaveAs(fname);"
		Str +="xlApp.Visible = false;"
		Str +="xlApp.UserControl = false;"
		Str +="xlBook.Close(savechanges=false);"
		Str +="xlApp.Quit();"
		Str +="xlSheet=null;"
		Str +="xlBook=null;"
		Str +="xlApp=null;"
		Str +="return 1;}());";
	//以上为拼接Excel打印代码为字符串
	CmdShell.notReturn =1;   //设置无结果调用，不阻塞调用
	var rtn =CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
	/*var oXL = new ActiveXObject("Excel.Application"); //创建AX对象excel   
	var oWB = oXL.Workbooks.Add(); //获取workbook对象   
	var oSheet = oWB.ActiveSheet; //激活当前sheet
	oSheet.Columns.NumberFormatLocal = "@";
	//设置工作薄名称  
	oSheet.name = xlsname+"DocItemDefault"; 
	var TitleList=$.m({
		 ClassName:"web.DHCDocPrefTabs",
		 MethodName:"GetQueryTitleList",
		 ClassQuery:"web.DHCDocPrefTabs:FindDiagTemp"
	},false);
	TitleList=TitleList.split(String.fromCharCode(1))[1]
	for (var i=0;i<TitleList.split(String.fromCharCode(9)).length;i++) {
		oSheet.Cells(1,i+1).value = TitleList.split(String.fromCharCode(9))[i];
	}	
	var data=$.cm({
	   ClassName:"web.DHCDocPrefTabs",
	   QueryName:"FindDiagTemp",
	   objtype:ObjectType, 
	   objvalue:objectReference,
	   rows:99999
	},false);	
	for (var i=0;i<data['total'];i++){
		var j=0;
		for ( var id in data['rows'][i]) {
			oSheet.Cells(i+2,j+1).value = data['rows'][i][id];
			j++;
		}
	}
	oXL.Visible = false; //设置excel可见属性
	var fname = oXL.Application.GetSaveAsFilename(xlsname+"DiagTemp.xls", "Excel Spreadsheets (*.xls), *.xls");
	oWB.SaveAs(fname);
	oWB.Close(savechanges=false);
	oXL.Quit();
	oXL=null;*/
}
//导出医嘱模板
function ExportOETabItems(OperType,CTLocID,CTLocName,UserID,UserName,AppKey){	
	
	var ObjectType="";
	var ObjectReference="";
	var xlsname="";
	if(OperType == "Personal"){
		//查询个人模版
		ObjectReference=UserID;
		ObjectType="User.SSUser";
		xlsname=UserID;
	}else if(OperType=="Departments"){
		//查询科室模版
		ObjectReference=CTLocID;
		ObjectType="User.CTLoc";
		//xlsname=CTLocName+CTLocID;
		xlsname=CTLocID;
	}else{
		xlsname="ALL";
	}
	var Str ="(function test(x){"
		Str +="var xlApp = new ActiveXObject('Excel.Application');"
		Str +="var xlBook = xlApp.Workbooks.Add();"
		Str +="var xlSheet = xlBook.ActiveSheet;"
		Str +="xlSheet.Columns.NumberFormatLocal = '@';"
		//设置工作薄名称  
		Str +="xlSheet.name = '"+xlsname+"OrdTemplate.xlsx';"; 
		var TitleList="*院区代码"+String.fromCharCode(9)+"类型描述"+String.fromCharCode(9)+"*类型代码"+String.fromCharCode(9)+"*类型"+String.fromCharCode(9)+"*应用代码"+String.fromCharCode(9)+"*表名"+String.fromCharCode(9)+"*列名"+String.fromCharCode(9)+"*医嘱或医嘱套"+String.fromCharCode(9)+"项目描述"+String.fromCharCode(9)+"*项目代码 "+String.fromCharCode(9)+"*列索引"+String.fromCharCode(9)+"部位代码列表";
		for (var i=0;i<TitleList.split(String.fromCharCode(9)).length;i++) {
			Str +="xlSheet.cells("+(1)+","+(i+1)+")='"+TitleList.split(String.fromCharCode(9))[i]+"';";
		}
		var data=$.cm({
		   ClassName:"web.DHCDocPrefTabs",
		   QueryName:"FindPrefTabs",
		   objtype:ObjectType, 
		   objvalue:ObjectReference,
		   paramKey:AppKey,
		   rows:99999
		},false);
		for (var i=0;i<data['total'];i++){
			var onedata=data['rows'][i];
			var HospCode=onedata.HospCode;
			var valueDesc=onedata.valueDesc; 
			var valueCode=onedata.valueCode; 
			var AppKey1=onedata.AppKey; 
			
			var Type=onedata.Type;
			var Tab=onedata.Tab; 
			var Col=onedata.Col;
			var ARCIMorARCOS=onedata.ARCIMorARCOS;
			var Desc=onedata.Desc; 
			var Code=onedata.Code; 
			var Index=onedata.Index;
			var IndexArr=Index.split("||");
			var Index=IndexArr[0]+"||"+IndexArr[1];
			var itemrowid=onedata.itemrowid; 
			var PartCodeInfo=onedata.PartCodeInfo; 
			if (ARCIMorARCOS="ARCOS") Code=Code.replace(/-/g,"");
			var str=HospCode+String.fromCharCode(9)+valueDesc+String.fromCharCode(9)+valueCode+String.fromCharCode(9)+Type+String.fromCharCode(9)+AppKey1+String.fromCharCode(9)+Tab+String.fromCharCode(9)+Col+String.fromCharCode(9)+ARCIMorARCOS+String.fromCharCode(9)+Desc+String.fromCharCode(9)+Code+String.fromCharCode(9)+Index+String.fromCharCode(9)+PartCodeInfo;
			var strArr=str.split(String.fromCharCode(9));
			for (var j=0;j<strArr.length;j++) {
				Str +="xlSheet.cells("+(i+2)+","+(j+1)+")='"+strArr[j]+"';";
			}
		}
		var filename=xlsname+"OrdTemplate.xls";
		Str += "var fname = xlApp.Application.GetSaveAsFilename('"+filename+"', 'Excel Spreadsheets (*.xls), *.xls');" 
		Str += "xlBook.SaveAs(fname);"
		Str +="xlApp.Visible = false;"
		Str +="xlApp.UserControl = false;"
		Str +="xlBook.Close(savechanges=false);"
		Str +="xlApp.Quit();"
		Str +="xlSheet=null;"
		Str +="xlBook=null;"
		Str +="xlApp=null;"
		Str +="return 1;}());";
	//以上为拼接Excel打印代码为字符串
	CmdShell.notReturn =1;   //设置无结果调用，不阻塞调用
	var rtn =CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
	
	/*var oXL = new ActiveXObject("Excel.Application"); //创建AX对象excel   
	var oWB = oXL.Workbooks.Add(); //获取workbook对象   
	var oSheet = oWB.ActiveSheet; //激活当前sheet
	oSheet.Columns.NumberFormatLocal = "@";
	//设置工作薄名称  
	oSheet.name = xlsname+"OrdTemplate"; 
	var TitleList="*院区代码"+String.fromCharCode(9)+"类型描述"+String.fromCharCode(9)+"*类型代码"+String.fromCharCode(9)+"*类型"+String.fromCharCode(9)+"*应用代码"+String.fromCharCode(9)+"*表名"+String.fromCharCode(9)+"*列名"+String.fromCharCode(9)+"*医嘱或医嘱套"+String.fromCharCode(9)+"项目描述"+String.fromCharCode(9)+"*项目代码 "+String.fromCharCode(9)+"*列索引"+String.fromCharCode(9)+"部位代码列表";
	for (var i=0;i<TitleList.split(String.fromCharCode(9)).length;i++) {
		oSheet.Cells(1,i+1).value = TitleList.split(String.fromCharCode(9))[i];
	}	
	var data=$.cm({
	   ClassName:"web.DHCDocPrefTabs",
	   QueryName:"FindPrefTabs",
	   objtype:ObjectType, 
	   objvalue:ObjectReference,
	   paramKey:AppKey,
	   rows:99999
	},false);	
	for (var i=0;i<data['total'];i++){
		var onedata=data['rows'][i];
		var HospCode=onedata.HospCode;
		var valueDesc=onedata.valueDesc; 
		var valueCode=onedata.valueCode; 
		var AppKey1=onedata.AppKey; 
		
		var Type=onedata.Type;
		var Tab=onedata.Tab; 
		var Col=onedata.Col;
		var ARCIMorARCOS=onedata.ARCIMorARCOS;
		var Desc=onedata.Desc; 
		var Code=onedata.Code; 
		var Index=onedata.Index;
		var IndexArr=Index.split("||");
		var Index=IndexArr[0]+"||"+IndexArr[1];
		var itemrowid=onedata.itemrowid; 
		var PartCodeInfo=onedata.PartCodeInfo; 
		if (ARCIMorARCOS="ARCOS") Code=Code.replace(/-/g,"");
		var str=HospCode+String.fromCharCode(9)+valueDesc+String.fromCharCode(9)+valueCode+String.fromCharCode(9)+Type+String.fromCharCode(9)+AppKey1+String.fromCharCode(9)+Tab+String.fromCharCode(9)+Col+String.fromCharCode(9)+ARCIMorARCOS+String.fromCharCode(9)+Desc+String.fromCharCode(9)+Code+String.fromCharCode(9)+Index+String.fromCharCode(9)+PartCodeInfo;
		var strArr=str.split(String.fromCharCode(9));
		for (var j=0;j<strArr.length;j++) {
			oSheet.Cells(i+2,j+1).value = strArr[j];
		}
	}
	oXL.Visible = false; //设置excel可见属性
	var fname = oXL.Application.GetSaveAsFilename(xlsname+"OrdTemplate.xls", "Excel Spreadsheets (*.xls), *.xls");
	oWB.SaveAs(fname);
	oWB.Close(savechanges=false);
	oXL.Quit();
	oXL=null;*/
}

//导入
function ImportHandler(){
	var HandleDataType = $('input:radio[name="HandleDataType"]:checked').val();
	if ((HandleDataType == undefined)||(HandleDataType == "")){
		$.messager.alert("提示","请选择需要操作的数据类型!","info");
		return false;
	}
	var fileObj = $("#TemplateExcel").filebox("files");
	var fileObj2 = $("#TemplateExcel").filebox("options");
	if (fileObj.length == 0) {
		$.messager.alert("提示", "请选择模版!", 'info');
		return
	}
	var fileType = fileObj[0].type;
	if ((fileType != "application/vnd.ms-excel")&&(fileType != "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")) {
		$.messager.alert("提示", "请选择.xls或.xlsx格式的模版!", 'info');
		$("#TemplateExcel").filebox("clear");
		return
	}
	var fileName = $("#filebox_file_id_1").val();
	if (fileName == ""){
		fileName = fileObj[0].name;
	}
	
	if (HandleDataType=="OrdTemp"){
		//医嘱模板
		ImportOETabItems(fileName)
	}else if (HandleDataType=="DiaTemp"){
		//诊断模板
		ImportDiagTempHandler(fileName)
	}else if (HandleDataType=="ARCOS"){
		//医嘱套
		ImportARCOSHandler(fileName)
	}else if (HandleDataType=="UserFav"){
		//用户常用用法
		ImportDocItemDefaultHandler(fileName)
	}
}
///导入用户常用用法
function ImportDocItemDefaultHandler(fileName){
	//创建操作EXCEL应用程序的实例
	var oXL = new ActiveXObject("Excel.application");  
	//打开指定路径的excel文件
    var oWB = oXL.Workbooks.open(fileName);  
    //操作第一个sheet(从一开始，而非零)  
    oWB.worksheets(1).select();  
    var oSheet = oWB.ActiveSheet;  
    //使用的行数  
    var rows =  oSheet.usedrange.rows.count
    var ret=1;

    var tempStr=""
    var Spl=String.fromCharCode(2)
    try {  
         for (var i = 2; i <= rows; i++) { 
			var ObjectType=oSheet.Cells(i, 1).value==undefined?"":oSheet.Cells(i,1).value;
			var ObjectCode=oSheet.Cells(i, 3).value==undefined?"":oSheet.Cells(i,3).value;
			var HospCode=oSheet.Cells(i, 4).value==undefined?"":oSheet.Cells(i,4).value;
			var ARCIMCode=oSheet.Cells(i, 5).value==undefined?"":oSheet.Cells(i,5).value;
			var Priority=oSheet.Cells(i, 7).value==undefined?"":oSheet.Cells(i,7).value;

			var Dose=oSheet.Cells(i, 8).value==undefined?"":oSheet.Cells(i,8).value;
			var DoseUom=oSheet.Cells(i, 9).value==undefined?"":oSheet.Cells(i,9).value;
			var Instr=oSheet.Cells(i, 10).value==undefined?"":oSheet.Cells(i,10).value;
			var PHFreq=oSheet.Cells(i, 11).value==undefined?"":oSheet.Cells(i,11).value;
			var Durat=oSheet.Cells(i, 12).value==undefined?"":oSheet.Cells(i,12).value;

			var PackQty=oSheet.Cells(i, 13).value==undefined?"":oSheet.Cells(i,13).value;
			var SkinTest=oSheet.Cells(i, 14).value==undefined?"":oSheet.Cells(i,14).value;
			var SkinAction=oSheet.Cells(i, 15).value==undefined?"":oSheet.Cells(i,15).value;
			var Notes=oSheet.Cells(i, 16).value==undefined?"":oSheet.Cells(i,16).value;
			var TPAAdmType=oSheet.Cells(i, 17).value==undefined?"":oSheet.Cells(i,17).value;

			var SpeedFlowRate=oSheet.Cells(i, 18).value==undefined?"":oSheet.Cells(i,18).value;
			var FlowRateUnit=oSheet.Cells(i, 19).value==undefined?"":oSheet.Cells(i,19).value;
			var ExceedReason=oSheet.Cells(i, 20).value==undefined?"":oSheet.Cells(i,20).value;
			var RecLocCode=oSheet.Cells(i, 22).value==undefined?"":oSheet.Cells(i,22).value;
			var RecLocHospCode=oSheet.Cells(i, 23).value==undefined?"":oSheet.Cells(i,23).value;
			var RelevanceNo="";
			var OrderFreqTimeDoseStr=oSheet.Cells(i, 24).value==undefined?"":oSheet.Cells(i,24).value;
			var OrderFreqWeekStr=oSheet.Cells(i, 25).value==undefined?"":oSheet.Cells(i,25).value;
			var PackUom=oSheet.Cells(i, 26).value==undefined?"":oSheet.Cells(i,26).value;
			var onetempStr=ObjectType+Spl+ObjectCode+Spl+HospCode+Spl+ARCIMCode+Spl+Priority;
			onetempStr=onetempStr+Spl+Dose+Spl+DoseUom+Spl+Instr+Spl+PHFreq+Spl+Durat;
			onetempStr=onetempStr+Spl+PackQty+Spl+SkinTest+Spl+SkinAction+Spl+Notes+Spl+TPAAdmType;
			onetempStr=onetempStr+Spl+SpeedFlowRate+Spl+FlowRateUnit+Spl+ExceedReason+Spl+RecLocCode+Spl+RecLocHospCode;
			onetempStr=onetempStr+Spl+RelevanceNo+Spl+OrderFreqTimeDoseStr+Spl+OrderFreqWeekStr+Spl+PackUom;

			if (tempStr=="") tempStr=onetempStr
			else tempStr=tempStr+String.fromCharCode(1)+onetempStr
         }  
    } catch(e) {  
    }  
    
	if (tempStr!=""){
		ret=tkMakeServerCall("web.DHCDocPrefTabs","ImportDocItemDefaultXls",tempStr,session['LOGON.USERID']);
	}
	//退出操作excel的实例对象  
	oXL.Application.Quit();  
	//手动调用垃圾收集器  
	//CollectGarbage();
	$.messager.alert("提示", "导入成功"+ret+"条数据!", 'info');
	$("#TemplateExcel").filebox("clear");	
}
///导入医嘱套
function ImportARCOSHandler(fileName){
	//创建操作EXCEL应用程序的实例
	var oXL = new ActiveXObject("Excel.application");  
	//打开指定路径的excel文件
    var oWB = oXL.Workbooks.open(fileName);  
    //操作第一个sheet(从一开始，而非零)  
    oWB.worksheets(1).select();  
    var oSheet = oWB.ActiveSheet;  
    //使用的行数  
    var rows =  oSheet.usedrange.rows.count
    var ret=1;

    var tempStr=""
    var Spl=String.fromCharCode(2)
    try {  
         for (var i = 2; i <= rows; i++) { 
			var ARCOSNum=oSheet.Cells(i, 1).value==undefined?"":oSheet.Cells(i,1).value;
			var ARCOSCode=oSheet.Cells(i, 3).value==undefined?"":oSheet.Cells(i,3).value;
			var ARCOSDesc=oSheet.Cells(i, 4).value==undefined?"":oSheet.Cells(i,4).value;
			var ARCOSAlias=oSheet.Cells(i, 5).value==undefined?"":oSheet.Cells(i,5).value;
			var ARCOSOrdCat=oSheet.Cells(i, 6).value==undefined?"":oSheet.Cells(i,6).value;
			var ARCOSOrdSubCat=oSheet.Cells(i, 7).value==undefined?"":oSheet.Cells(i,7).value;
			var ARCOSEffDateFrom=""	//oSheet.Cells(i, 8).value==undefined?"":oSheet.Cells(i,8).value;
			var UserCode=oSheet.Cells(i, 10).value==undefined?"":oSheet.Cells(i,10).value;
			var LocCode=oSheet.Cells(i, 12).value==undefined?"":oSheet.Cells(i,12).value;
			var FavMedUnitDesc=oSheet.Cells(i, 13).value==undefined?"":oSheet.Cells(i,13).value;
			var HospCode=oSheet.Cells(i, 14).value==undefined?"":oSheet.Cells(i,14).value;
			var CelerType=oSheet.Cells(i, 15).value==undefined?"":oSheet.Cells(i,15).value;
			var CMPrescTypeCode=oSheet.Cells(i, 16).value==undefined?"":oSheet.Cells(i,16).value;
			var CMDuratDesc=oSheet.Cells(i, 17).value==undefined?"":oSheet.Cells(i,17).value;
			var CMFreqDesc=oSheet.Cells(i, 18).value==undefined?"":oSheet.Cells(i,18).value;
			var CMInstrDesc=oSheet.Cells(i, 19).value==undefined?"":oSheet.Cells(i,19).value;
			var CMDoseQty=oSheet.Cells(i, 20).value==undefined?"":oSheet.Cells(i,20).value;
			var CMNotes=oSheet.Cells(i, 21).value==undefined?"":oSheet.Cells(i,21).value;
			
			var ARCIMCode=oSheet.Cells(i, 26).value==undefined?"":oSheet.Cells(i,26).value;
			var DoseQty=oSheet.Cells(i, 28).value==undefined?"":oSheet.Cells(i,28).value;
			var DoseUOM=oSheet.Cells(i, 29).value==undefined?"":oSheet.Cells(i,29).value;
			var Frequence=oSheet.Cells(i, 30).value==undefined?"":oSheet.Cells(i,30).value;
			var Duration=oSheet.Cells(i, 31).value==undefined?"":oSheet.Cells(i,31).value;
			var Instruction=oSheet.Cells(i, 32).value==undefined?"":oSheet.Cells(i,32).value;
			var PackQty=oSheet.Cells(i, 33).value==undefined?"":oSheet.Cells(i,33).value;
			var PackQtyBillUOM=oSheet.Cells(i, 34).value==undefined?"":oSheet.Cells(i,34).value;
			var DHCDocOrdRecLocCode=oSheet.Cells(i, 35).value==undefined?"":oSheet.Cells(i,35).value;
			var DHCDocOrdRecHospCode=oSheet.Cells(i, 36).value==undefined?"":oSheet.Cells(i,36).value;
			var ARCOSItmLinkDoctor=oSheet.Cells(i, 37).value==undefined?"":oSheet.Cells(i,37).value;
			var Tremark=oSheet.Cells(i, 38).value==undefined?"":oSheet.Cells(i,38).value;
			var OECPRDesc=oSheet.Cells(i, 39).value==undefined?"":oSheet.Cells(i,39).value;
			var SampleDesc=oSheet.Cells(i, 40).value==undefined?"":oSheet.Cells(i,40).value;
			var NO=oSheet.Cells(i, 41).value==undefined?"":oSheet.Cells(i,41).value;
			var OrderPriorRemarks=oSheet.Cells(i, 42).value==undefined?"":oSheet.Cells(i,42).value;
			var DHCDocOrdStage=oSheet.Cells(i, 43).value==undefined?"":oSheet.Cells(i,43).value;
			var DHCMustEnter=oSheet.Cells(i, 44).value==undefined?"":oSheet.Cells(i,44).value;
			var SpeedFlowRate=oSheet.Cells(i, 45).value==undefined?"":oSheet.Cells(i,45).value;
			var FlowRateUnit=oSheet.Cells(i, 46).value==undefined?"":oSheet.Cells(i,46).value;
			var OrderBodyPartLabel=oSheet.Cells(i, 47).value==undefined?"":oSheet.Cells(i,47).value;
			var NotifyClinician=oSheet.Cells(i, 48).value==undefined?"":oSheet.Cells(i,48).value;
			var SkinTest=oSheet.Cells(i, 49).value==undefined?"":oSheet.Cells(i,49).value;
			var SkinTestAction=oSheet.Cells(i, 50).value==undefined?"":oSheet.Cells(i,50).value;
			var RemoveCeler=oSheet.Cells(i, 51).value==undefined?"":oSheet.Cells(i,51).value;

			var onetempStr=ARCOSNum+Spl+ARCOSCode+Spl+ARCOSDesc+Spl+ARCOSAlias+Spl+ARCOSOrdCat;
			onetempStr=onetempStr+Spl+ARCOSOrdSubCat+Spl+ARCOSEffDateFrom+Spl+UserCode+Spl+LocCode+Spl+FavMedUnitDesc;
			onetempStr=onetempStr+Spl+HospCode+Spl+CelerType+Spl+CMPrescTypeCode+Spl+CMDuratDesc+Spl+CMFreqDesc;
			onetempStr=onetempStr+Spl+CMInstrDesc+Spl+CMDoseQty+Spl+CMNotes+Spl+Spl;
			onetempStr=onetempStr+Spl+Spl+Spl+Spl+Spl;
			
			onetempStr=onetempStr+Spl+ARCIMCode+Spl+DoseQty+Spl+DoseUOM+Spl+Frequence+Spl+Duration;
			onetempStr=onetempStr+Spl+Instruction+Spl+PackQty+Spl+PackQtyBillUOM+Spl+DHCDocOrdRecLocCode+Spl+DHCDocOrdRecHospCode;
			onetempStr=onetempStr+Spl+ARCOSItmLinkDoctor+Spl+Tremark+Spl+OECPRDesc+Spl+SampleDesc+Spl+NO;
			onetempStr=onetempStr+Spl+OrderPriorRemarks+Spl+DHCDocOrdStage+Spl+DHCMustEnter+Spl+SpeedFlowRate+Spl+FlowRateUnit;
			onetempStr=onetempStr+Spl+OrderBodyPartLabel+Spl+NotifyClinician+Spl+SkinTest+Spl+SkinTestAction+Spl+RemoveCeler;
			if (tempStr=="") tempStr=onetempStr
			else tempStr=tempStr+String.fromCharCode(1)+onetempStr
         }  
    } catch(e) {  
    }  
    
    
	if (tempStr!=""){
		console.log(tempStr);
		ret=tkMakeServerCall("web.DHCDocPrefTabs","ImportARCOSXls",tempStr);
	}
	//退出操作excel的实例对象  
	oXL.Application.Quit();  
	//手动调用垃圾收集器  
	//CollectGarbage();
	$.messager.alert("提示", "导入成功"+ret+"条数据!", 'info');
	$("#TemplateExcel").filebox("clear");	
}
//导入诊断模板
function ImportDiagTempHandler(fileName){
	//创建操作EXCEL应用程序的实例
	var oXL = new ActiveXObject("Excel.application");  
	//打开指定路径的excel文件
    var oWB = oXL.Workbooks.open(fileName);  
    //操作第一个sheet(从一开始，而非零)  
    oWB.worksheets(1).select();  
    var oSheet = oWB.ActiveSheet;  
    //使用的行数  
    var rows =  oSheet.usedrange.rows.count
    var ret=1;

    var tempStr=""
    var Spl=String.fromCharCode(2)
    try {  
         for (var i = 2; i <= rows; i++) { 

			var HospCode=oSheet.Cells(i, 1).value==undefined?"":oSheet.Cells(i,1).value;
			var valueType=oSheet.Cells(i, 2).value==undefined?"":oSheet.Cells(i,2).value;
			var valueCode=oSheet.Cells(i, 4).value==undefined?"":oSheet.Cells(i,4).value;
			var MASDesc=oSheet.Cells(i, 5).value==undefined?"":oSheet.Cells(i,5).value;
			var MASIndex=oSheet.Cells(i, 6).value==undefined?"":oSheet.Cells(i,6).value;
			var ICDListNum=oSheet.Cells(i, 7).value==undefined?"":oSheet.Cells(i,7).value;
			
			var ICDListIndex=oSheet.Cells(i, 8).value==undefined?"":oSheet.Cells(i,8).value;
			var ICDDesc=oSheet.Cells(i, 10).value==undefined?"":oSheet.Cells(i,10).value;
			var ICDCode=oSheet.Cells(i, 11).value==undefined?"":oSheet.Cells(i,11).value;
			var ICDSyndromeCodeInfo=oSheet.Cells(i, 12).value==undefined?"":oSheet.Cells(i,12).value;

			var onetempStr=HospCode+Spl+valueType+Spl+valueCode+Spl+MASDesc+Spl+MASIndex;
			onetempStr=onetempStr+Spl+ICDListNum+Spl+ICDListIndex+Spl+ICDDesc+Spl+ICDCode+Spl+ICDSyndromeCodeInfo;
			if (tempStr=="") tempStr=onetempStr
			else tempStr=tempStr+String.fromCharCode(1)+onetempStr
         }  
    } catch(e) {  
    }  
    
    
	if (tempStr!=""){
		console.log(tempStr);
		ret=tkMakeServerCall("web.DHCDocPrefTabs","ImportDiagTempXls",tempStr);
	}
	//退出操作excel的实例对象  
	oXL.Application.Quit();  
	//手动调用垃圾收集器  
	//CollectGarbage();
	$.messager.alert("提示", "导入成功"+ret+"条数据!", 'info');
	$("#TemplateExcel").filebox("clear");	
}
//导入医嘱模板
function ImportOETabItems(fileName){
	/*var str ="(function test(x){"+
			"var xlApp = new ActiveXObject('Excel.Application');"+
			//http://127.0.0.1/dthealth/med/Results/Template/tpl.xlsx
			"var xlBook = xlApp.Workbooks.Open('"+fileName+"');"+
			"var xlSheet = xlBook.ActiveSheet;"+
			"var rtn = xlSheet.Cells(2,2).Value;"+
			"rtn += '^'+xlSheet.Cells(3,2).Value;"+
			"rtn += '^'+xlSheet.Cells(4,2).Value;"+
			"rtn += '^'+xlSheet.Cells(5,2).Value;"+
			"xlApp.Visible = true;"+
			"xlApp.UserControl = false;"+
			"xlBook.Close(savechanges=false);"+
			"xlApp.Quit();"+
			"xlSheet=null;"+
			"xlBook=null;"+
			"xlApp=null;"+
			"return rtn;}());";
			CmdShell.notReturn = 0;    //有返回值调用
			var rtn =CmdShell.EvalJs(str);     //运行代码且得到返回值 
			document.getElementById("resultdiv").innerText = rtn; 
			return;*/
		
	//创建操作EXCEL应用程序的实例
	var oXL = new ActiveXObject("Excel.application");  
	//打开指定路径的excel文件
    var oWB = oXL.Workbooks.open(fileName);  
    //操作第一个sheet(从一开始，而非零)  
    oWB.worksheets(1).select();  
    var oSheet = oWB.ActiveSheet;  
    //使用的行数  
    var rows =  oSheet.usedrange.rows.count
    var ret=1;

    var tempStr=""
    var Spl=String.fromCharCode(2)
    try {  
         for (var i = 2; i <= rows; i++) { 
			var HospCode=oSheet.Cells(i, 1).value==undefined?"":oSheet.Cells(i,1).value;
			var valueCode=oSheet.Cells(i, 3).value==undefined?"":oSheet.Cells(i,3).value;
			var valueType=oSheet.Cells(i, 4).value==undefined?"":oSheet.Cells(i,4).value;
			var Type=oSheet.Cells(i, 5).value==undefined?"":oSheet.Cells(i,5).value;
			var TabName=oSheet.Cells(i, 6).value==undefined?"":oSheet.Cells(i,6).value;
			
			var ColName=oSheet.Cells(i, 7).value==undefined?"":oSheet.Cells(i,7).value;
			var ARCIMorARCOS=oSheet.Cells(i, 8).value==undefined?"":oSheet.Cells(i,8).value;
			var ItemCode=oSheet.Cells(i, 10).value==undefined?"":oSheet.Cells(i,10).value;
			var Index=oSheet.Cells(i, 11).value==undefined?"":oSheet.Cells(i,11).value;
			var PartCodeInfo=oSheet.Cells(i, 12).value==undefined?"":oSheet.Cells(i,12).value;
			
			var onetempStr=HospCode+Spl+valueCode+Spl+valueType+Spl+Type+Spl+TabName;
			onetempStr=onetempStr+Spl+ColName+Spl+ARCIMorARCOS+Spl+ItemCode+Spl+Index+Spl+PartCodeInfo;
			if (tempStr=="") tempStr=onetempStr
			else tempStr=tempStr+String.fromCharCode(1)+onetempStr
         }  
    } catch(e) {  
    }  
    
    
    if (tempStr!=""){
		console.log(tempStr);
		ret=tkMakeServerCall("web.DHCDocPrefTabs","ImportPreferenceXls",tempStr);
	}
   //退出操作excel的实例对象  
   oXL.Application.Quit();  
    //手动调用垃圾收集器  
   //CollectGarbage();
   if(ret==1){
		$.messager.alert("提示", "导入成功!", 'info');
		$("#TemplateExcel").filebox("clear");	
	}else{
		$.messager.alert("提示", "导入失败：" + ret, 'info');
		return false;
	}
	//$('#FindButton').click();
}

function BodykeydownHandler(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	//浏览器中Backspace不可用  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        e.preventDefault();   
    }   
}

function GetParams(){
	var CTLocName = PageOBJ.m_DepCombox.getText();	//$("#FCTLocName").val();
	var CTLocID = PageOBJ.m_DepCombox.getValue();	//$("#FCTLocID").val();
	var UserName = PageOBJ.m_UserCombox.getText();	//$("#FUserName").val();
	var UserID = PageOBJ.m_UserCombox.getValue(); 	//$("#FUserID").val();
	var AppKey = $.trim($("#AppKey").val());
	var HandleDataType = $('input:radio[name="HandleDataType"]:checked').val();
	var OperType = $('input:radio[name="OperType"]:checked').val();
	if ((HandleDataType == undefined)||(HandleDataType == "")){
		$.messager.alert("提示","请选择需要操作的数据类型!","info");
		return false;
	}
	
	if ((OperType == undefined)&&(("^OrdTemp^DiaTemp^ARCOS^UserFav^").indexOf("^"+HandleDataType+"^")<0)){
		$.messager.alert("提示","请选择条件!","info");
		return false;
	}
	if(OperType == "Personal"){
		if(UserID==""){
			$.messager.alert("提示","请选择用户!","info");
			return false;
		}
	}else if(OperType=="Departments"){
		if(CTLocID==""){
			$.messager.alert("提示","请选择科室!","info");
			return false;
		}
		//查询科室模版
	}
	return HandleDataType+"^"+OperType+"^"+CTLocName+"^"+CTLocID+"^"+UserName+"^"+UserID+"^"+AppKey;
}