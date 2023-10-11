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
	m_QueDateTableGrid:""
}
$(document).ready(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	InitCache();
});
function InitCache(){
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function Init() {
	InitFType();
}
function InitEvent () {
	$('input[name=HandleDataType]').radio({
		onChecked:function (e) {
			if('OrdTempDataType'==$(e.target).attr('id')){
				$('input[name=OrdFavType]').next().show();
			}else{
				$('input[name=OrdFavType]').next().hide();
			}
		}
	});
	//查询
	$('#FindButton').click(FindHandler);
	//清空
	$('#resetButton').click(resetCondition);
	//导入
	$('#Import').click(ImportHandler);
	//导出
	$('#Export').click(ExportHandler);
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
	var HospName=ParamsArr[7],HospID=ParamsArr[8];
	if (HandleDataType=="OrdTemp"){
		//医嘱模板
		FindOrdTempHandler(OperType,CTLocID,CTLocName,UserID,UserName,AppKey,HospID)
	}else if (HandleDataType=="DiaTemp"){
		//诊断模板
		FindDiagTempHandler(OperType,CTLocID,CTLocName,UserID,UserName,AppKey,HospID)
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
		{field:'DoseUom',title:'剂量单位',width:70},
		{field:'Instr',title:'用法',width:70},
		{field:'PHFreq',title:'频次',width:70},
		{field:'Durat',title:'疗程',width:70},
		{field:'PackQty',title:'数量',width:70},
		{field:'PackUom',title:'数量单位',width:100},
		{field:'SkinTest',title:'皮试',width:70},
		{field:'SkinAction',title:'皮试备注',width:100},
		{field:'Notes',title:'备注',width:100},
		{field:'TPAAdmType',title:'就诊类型',width:70},
		{field:'SpeedFlowRate',title:'流速',width:70},
		{field:'FlowRateUnit',title:'流速单位',width:100},
		{field:'ExceedReason',title:'超量原因',width:100},
		{field:'RecLocDesc',title:'接收科室',width:120},
		{field:'RecLocCode',title:'接收科室代码',width:120},
		{field:'RecLocHospCode',title:'接收科室所在院区代码',width:100},
		{field:'OrderFreqTimeDoseStr',title:'同频次不同剂量串',width:100},
		{field:'OrderFreqWeekStr',title:'周频次选择串',width:100}
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
		{field:'CMDuratDesc',title:'草药付数',width:80},
		{field:'CMFreqDesc',title:'草药频次',width:80},
		{field:'CMInstrDesc',title:'草药用法',width:80},
		{field:'CMDoseQty',title:'一次用量',width:80},
		{field:'CMNotes',title:'草药备注',width:100},
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
		{field:'DoseUOM',title:'剂量单位',width:70},
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
function FindDiagTempHandler(OperType,CTLocID,CTLocName,UserID,UserName,AppKey,HospID){
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
		{field:'HospDesc',title:'院区',width:200},
		{field:'FavCatType',title:'分类代码',width:100},
		{field:'TypeValueDesc',title:'分类值描述',width:100},
		{field:'TypeValueCode',title:'分类值代码',width:90},
		{field:'Cat',title:'模板分类名',width:90},
		{field:'DiagType',title:'类型',width:50},
		{field:'ICDCode',title:'ICD代码',width:100},
		{field:'Prefix',title:'前缀',width:100},
		{field:'ICDDesc',title:'ICD描述',width:300},
		{field:'Note',title:'备注',width:150},
		{field:'SyndCode',title:'证型代码',width:80},
		{field:'SyndDesc',title:'证型描述',width:200},
		{field:'SyndNote',title:'证型备注',width:100}
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
	    HospRowId:HospID,
	    Pagerows:PageOBJ.m_QueDateTableGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageOBJ.m_QueDateTableGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
	
}
///查询医嘱模板数据
function FindOrdTempHandler(OperType,CTLocID,CTLocName,UserID,UserName,AppKey,HospID){
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
		{field:'HospDesc',title:'院区',width:200},
		{field:'FavCatType',title:'分类代码',width:250},
		{field:'TypeValueDesc',title:'分类值描述',width:100},
		{field:'TypeValueCode',title:'分类值代码',width:90},
		{field:'Cat',title:'大类',width:100},
		{field:'SubCat',title:'子分类',width:100},
		{field:'ItemType',title:'医嘱或医嘱套',width:100},
		{field:'ItemDesc',title:'项目描述',width:300},
		{field:'itemNotes',title:'备注',width:100},
		{field:'PartCodeInfo',title:'部位代码列表',width:150},
		{field:'TypeValue',title:'分类值',width:60},
		{field:'ItemID',title:'项目ID',width:100}
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
	    HospRowId:HospID,
	    Pagerows:PageOBJ.m_QueDateTableGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageOBJ.m_QueDateTableGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
	
}
//清空
function resetCondition(){
	$('#FType,#FTypeValue').combobox('setValue','');
	$("#Departments").radio("uncheck");
	$("#Personal").radio("uncheck");
	$("#TemplateExcel").filebox("clear");
	if(PageOBJ.m_QueDateTableGrid)
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
				var val=data['rows'][i][id];
				val=val.replace(/'/g,"")
				Str +="xlSheet.cells("+(i+2)+","+(j+1)+")='"+val+"';";
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
				var val=data['rows'][i][id];
				val=val.replace(/'/g,"")
				Str +="xlSheet.cells("+(i+2)+","+(j+1)+")='"+val+"';";
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
		var TitleList="*院区代码"+String.fromCharCode(9)+"分类代码"+String.fromCharCode(9)+"*分类值"+String.fromCharCode(9)+"*分类值描述"+String.fromCharCode(9)+"*分类值代码"+String.fromCharCode(9)+"*大类"+String.fromCharCode(9)+"*子分类"+String.fromCharCode(9)+"*医嘱或医嘱套"+String.fromCharCode(9)+"项目ID"+String.fromCharCode(9)+"*项目描述 "+String.fromCharCode(9)+"*部位代码列表"+String.fromCharCode(9)+"备注";
		for (var i=0;i<TitleList.split(String.fromCharCode(9)).length;i++) {
			Str +="xlSheet.cells("+(1)+","+(i+1)+")='"+TitleList.split(String.fromCharCode(9))[i]+"';";
		}
		var data=$.cm({
		   ClassName:"web.DHCDocPrefTabs",
		   QueryName:"FindPrefTabs",
		   objtype:ObjectType, 
		   objvalue:ObjectReference,
		   paramKey:AppKey,
		   HospRowId:session['LOGON.HOSPID'],
		   rows:99999
		},false);
		for (var i=0;i<data['total'];i++){
			var j=0;
			for ( var id in data['rows'][i]) {
				var val=data['rows'][i][id];
				val=val.replace(/'/g,"")
				Str +="xlSheet.cells("+(i+2)+","+(j+1)+")='"+val+"';";
				j++;
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
}

//导入
function ImportHandler(){
	var HandleDataType = $('input:radio[name="HandleDataType"]:checked').val();
	if ((HandleDataType == undefined)||(HandleDataType == "")){
		$.messager.alert("提示","请选择需要操作的数据类型!","info");
		return false;
	}
	/*var fileObj = $("#TemplateExcel").filebox("files");
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
	}*/
	var fileName=""
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
	var str ="(function test(x){"+
			"var oXL = new ActiveXObject('Excel.Application');"+
			"var fileName=''; "+
			//http://127.0.0.1/dthealth/med/Results/Template/tpl.xlsx
			"var fileName = oXL.Application.GetOpenFilename ('Excel Spreadsheets (*.xls), *.xls');" +
			"if (fileName==''){return '';}" +
			"var oWB = oXL.Workbooks.open(fileName);"+
			"oWB.worksheets(1).select();"+
			"var oSheet = oWB.ActiveSheet;  "+
			"var rows =  oSheet.usedrange.rows.count;"+
			" var ret=0;"+
			"var Spl=String.fromCharCode(2);"+
			"var tempStr='';"+ 
			"for (var i = 2; i <= rows; i++) {"+
				"var ObjectType=oSheet.Cells(i, 1).value==undefined?'':oSheet.Cells(i,1).value;"+
			"var ObjectCode=oSheet.Cells(i, 3).value==undefined?'':oSheet.Cells(i,3).value;"+
			"var HospCode=oSheet.Cells(i, 4).value==undefined?'':oSheet.Cells(i,4).value;"+
			"var ARCIMCode=oSheet.Cells(i, 5).value==undefined?'':oSheet.Cells(i,5).value;"+
			"var Priority=oSheet.Cells(i, 7).value==undefined?'':oSheet.Cells(i,7).value;"+

			"var Dose=oSheet.Cells(i, 8).value==undefined?'':oSheet.Cells(i,8).value;"+
			"var DoseUom=oSheet.Cells(i, 9).value==undefined?'':oSheet.Cells(i,9).value;"+
			"var Instr=oSheet.Cells(i, 10).value==undefined?'':oSheet.Cells(i,10).value;"+
			"var PHFreq=oSheet.Cells(i, 11).value==undefined?'':oSheet.Cells(i,11).value;"+
			"var Durat=oSheet.Cells(i, 12).value==undefined?'':oSheet.Cells(i,12).value;"+

			"var PackQty=oSheet.Cells(i, 13).value==undefined?'':oSheet.Cells(i,13).value;"+
			"var SkinTest=oSheet.Cells(i, 14).value==undefined?'':oSheet.Cells(i,14).value;"+
			"var SkinAction=oSheet.Cells(i, 15).value==undefined?'':oSheet.Cells(i,15).value;"+
			"var Notes=oSheet.Cells(i, 16).value==undefined?'':oSheet.Cells(i,16).value;"+
			"var TPAAdmType=oSheet.Cells(i, 17).value==undefined?'':oSheet.Cells(i,17).value;"+

			"var SpeedFlowRate=oSheet.Cells(i, 18).value==undefined?'':oSheet.Cells(i,18).value;"+
			"var FlowRateUnit=oSheet.Cells(i, 19).value==undefined?'':oSheet.Cells(i,19).value;"+
			"var ExceedReason=oSheet.Cells(i, 20).value==undefined?'':oSheet.Cells(i,20).value;"+
			"var RecLocCode=oSheet.Cells(i, 22).value==undefined?'':oSheet.Cells(i,22).value;"+
			"var RecLocHospCode=oSheet.Cells(i, 23).value==undefined?'':oSheet.Cells(i,23).value;"+
			"var RelevanceNo='';"+
			"var OrderFreqTimeDoseStr=oSheet.Cells(i, 24).value==undefined?'':oSheet.Cells(i,24).value;"+
			"var OrderFreqWeekStr=oSheet.Cells(i, 25).value==undefined?'':oSheet.Cells(i,25).value;"+
			"var PackUom=oSheet.Cells(i, 26).value==undefined?'':oSheet.Cells(i,26).value;"+
			"var onetempStr=ObjectType+Spl+ObjectCode+Spl+HospCode+Spl+ARCIMCode+Spl+Priority;"+
			"onetempStr=onetempStr+Spl+Dose+Spl+DoseUom+Spl+Instr+Spl+PHFreq+Spl+Durat;"+
			"onetempStr=onetempStr+Spl+PackQty+Spl+SkinTest+Spl+SkinAction+Spl+Notes+Spl+TPAAdmType;"+
			"onetempStr=onetempStr+Spl+SpeedFlowRate+Spl+FlowRateUnit+Spl+ExceedReason+Spl+RecLocCode+Spl+RecLocHospCode;"+
			"onetempStr=onetempStr+Spl+RelevanceNo+Spl+OrderFreqTimeDoseStr+Spl+OrderFreqWeekStr+Spl+PackUom;"+
			"if (tempStr=='') {tempStr=onetempStr;}else{tempStr=tempStr+String.fromCharCode(1)+onetempStr;}"+
			
				 "};"+
			"oXL.Application.Quit();"+
			"return tempStr;}());";
	CmdShell.notReturn = 0;    //有返回值调用
	var rtn =CmdShell.EvalJs(str);     //运行代码且得到返回值 
	var Str=rtn.rtn
	if (Str!=""){
		var tempStr=""
		var Count=0
		var ret=0
		var retInfo=""
		for (var i = 0; i < Str.split(String.fromCharCode(1)).length; i++) { 
			var onetempStr=Str.split(String.fromCharCode(1))[i]
			if (tempStr=='') {tempStr=onetempStr;}else{tempStr=tempStr+String.fromCharCode(1)+onetempStr;}
			if ((tempStr!="")&&(Count>50)){
				rtn=tkMakeServerCall("web.DHCDocPrefTabs","ImportDocItemDefaultXls",tempStr,session['LOGON.USERID']);
				retnumber=rtn.split("^")[0]
				retInfo=retInfo+rtn.split("^")[1]
				ret=parseFloat(ret)+parseFloat(retnumber)
				tempStr="";
				Count=0;
			}
			Count=Count+1;
		}
		if (tempStr!=""){
			rtn=tkMakeServerCall("web.DHCDocPrefTabs","ImportDocItemDefaultXls",tempStr,session['LOGON.USERID']);
			retnumber=rtn.split("^")[0]
			retInfo=retInfo+rtn.split("^")[1]
			ret=parseFloat(ret)+parseFloat(retnumber)
		}
		$.messager.alert("提示", "导入成功"+ret+"条数据!"+retInfo, 'info');
		
	}
	
	return	
}
///导入医嘱套
function ImportARCOSHandler(fileName){
	var str ="(function test(x){"+
			"var oXL = new ActiveXObject('Excel.Application');"+
			//http://127.0.0.1/dthealth/med/Results/Template/tpl.xlsx
			"var fileName=''; "+
			"var fileName = oXL.Application.GetOpenFilename ('Excel Spreadsheets (*.xls), *.xls');" +
			"if (fileName==''){return '';}" +
			"var oWB = oXL.Workbooks.open(fileName);"+
			"oWB.worksheets(1).select();"+
			"var oSheet = oWB.ActiveSheet;  "+
			"var rows =  oSheet.usedrange.rows.count;"+
			" var ret=0;"+
			"var Spl=String.fromCharCode(2);"+
			"var tempStr='';"+ 
			"for (var i = 2; i <= rows; i++) {"+
				"var ARCOSNum=oSheet.Cells(i, 1).value==undefined?'':oSheet.Cells(i,1).value;"+
				"var ARCOSCode=oSheet.Cells(i, 3).value==undefined?'':oSheet.Cells(i,3).value;"+
				"var ARCOSDesc=oSheet.Cells(i, 4).value==undefined?'':oSheet.Cells(i,4).value;"+
			"var ARCOSAlias=oSheet.Cells(i, 5).value==undefined?'':oSheet.Cells(i,5).value;"+
			"var ARCOSOrdCat=oSheet.Cells(i, 6).value==undefined?'':oSheet.Cells(i,6).value;"+
			"var ARCOSOrdSubCat=oSheet.Cells(i, 7).value==undefined?'':oSheet.Cells(i,7).value;"+

			"var UserCode=oSheet.Cells(i, 10).value==undefined?'':oSheet.Cells(i,10).value;"+
			"var LocCode=oSheet.Cells(i, 12).value==undefined?'':oSheet.Cells(i,12).value;"+
			"var FavMedUnitDesc=oSheet.Cells(i, 13).value==undefined?'':oSheet.Cells(i,13).value;"+
			"var HospCode=oSheet.Cells(i, 14).value==undefined?'':oSheet.Cells(i,14).value;"+
			"var CelerType=oSheet.Cells(i, 15).value==undefined?'':oSheet.Cells(i,15).value;"+
			"var CMPrescTypeCode=oSheet.Cells(i, 16).value==undefined?'':oSheet.Cells(i,16).value;"+
			"var CMDuratDesc=oSheet.Cells(i, 17).value==undefined?'':oSheet.Cells(i,17).value;"+
			"var CMFreqDesc=oSheet.Cells(i, 18).value==undefined?'':oSheet.Cells(i,18).value;"+
			"var CMInstrDesc=oSheet.Cells(i, 19).value==undefined?'':oSheet.Cells(i,19).value;"+
			"var CMDoseQty=oSheet.Cells(i, 20).value==undefined?'':oSheet.Cells(i,20).value;"+
			"var CMNotes=oSheet.Cells(i, 21).value==undefined?'':oSheet.Cells(i,21).value;"+
			
			"var ARCIMCode=oSheet.Cells(i, 26).value==undefined?'':oSheet.Cells(i,26).value;"+
			"var DoseQty=oSheet.Cells(i, 28).value==undefined?'':oSheet.Cells(i,28).value;"+
			"var DoseUOM=oSheet.Cells(i, 29).value==undefined?'':oSheet.Cells(i,29).value;"+
			"var Frequence=oSheet.Cells(i, 30).value==undefined?'':oSheet.Cells(i,30).value;"+
			"var Duration=oSheet.Cells(i, 31).value==undefined?'':oSheet.Cells(i,31).value;"+
			"var Instruction=oSheet.Cells(i, 32).value==undefined?'':oSheet.Cells(i,32).value;"+
			"var PackQty=oSheet.Cells(i, 33).value==undefined?'':oSheet.Cells(i,33).value;"+
			"var PackQtyBillUOM=oSheet.Cells(i, 34).value==undefined?'':oSheet.Cells(i,34).value;"+
			"var DHCDocOrdRecLocCode=oSheet.Cells(i, 35).value==undefined?'':oSheet.Cells(i,35).value;"+
			"var DHCDocOrdRecHospCode=oSheet.Cells(i, 36).value==undefined?'':oSheet.Cells(i,36).value;"+
			"var ARCOSItmLinkDoctor=oSheet.Cells(i, 37).value==undefined?'':oSheet.Cells(i,37).value;"+
			"var Tremark=oSheet.Cells(i, 38).value==undefined?'':oSheet.Cells(i,38).value;"+
			"var OECPRDesc=oSheet.Cells(i, 39).value==undefined?'':oSheet.Cells(i,39).value;"+
			"var SampleDesc=oSheet.Cells(i, 40).value==undefined?'':oSheet.Cells(i,40).value;"+
			"var NO=oSheet.Cells(i, 41).value==undefined?'':oSheet.Cells(i,41).value;"+
			"var OrderPriorRemarks=oSheet.Cells(i, 42).value==undefined?'':oSheet.Cells(i,42).value;"+
			"var DHCDocOrdStage=oSheet.Cells(i, 43).value==undefined?'':oSheet.Cells(i,43).value;"+
			"var DHCMustEnter=oSheet.Cells(i, 44).value==undefined?'':oSheet.Cells(i,44).value;"+
			"var SpeedFlowRate=oSheet.Cells(i, 45).value==undefined?'':oSheet.Cells(i,45).value;"+
			"var FlowRateUnit=oSheet.Cells(i, 46).value==undefined?'':oSheet.Cells(i,46).value;"+
			"var OrderBodyPartLabel=oSheet.Cells(i, 47).value==undefined?'':oSheet.Cells(i,47).value;"+
			"var NotifyClinician=oSheet.Cells(i, 48).value==undefined?'':oSheet.Cells(i,48).value;"+
			"var SkinTest=oSheet.Cells(i, 49).value==undefined?'':oSheet.Cells(i,49).value;"+
			"var SkinTestAction=oSheet.Cells(i, 50).value==undefined?'':oSheet.Cells(i,50).value;"+
			"var RemoveCeler=oSheet.Cells(i, 51).value==undefined?'':oSheet.Cells(i,51).value;"+
			"var ARCOSEffDateFrom='';"+

			"var onetempStr=ARCOSNum+Spl+ARCOSCode+Spl+ARCOSDesc+Spl+ARCOSAlias+Spl+ARCOSOrdCat;"+
			"onetempStr=onetempStr+Spl+ARCOSOrdSubCat+Spl+ARCOSEffDateFrom+Spl+UserCode+Spl+LocCode+Spl+FavMedUnitDesc;"+
			"onetempStr=onetempStr+Spl+HospCode+Spl+CelerType+Spl+CMPrescTypeCode+Spl+CMDuratDesc+Spl+CMFreqDesc;"+
			"onetempStr=onetempStr+Spl+CMInstrDesc+Spl+CMDoseQty+Spl+CMNotes+Spl+Spl;"+
			"onetempStr=onetempStr+Spl+Spl+Spl+Spl+Spl;"+
			
			"onetempStr=onetempStr+Spl+ARCIMCode+Spl+DoseQty+Spl+DoseUOM+Spl+Frequence+Spl+Duration;"+
			"onetempStr=onetempStr+Spl+Instruction+Spl+PackQty+Spl+PackQtyBillUOM+Spl+DHCDocOrdRecLocCode+Spl+DHCDocOrdRecHospCode;"+
			"onetempStr=onetempStr+Spl+ARCOSItmLinkDoctor+Spl+Tremark+Spl+OECPRDesc+Spl+SampleDesc+Spl+NO;"+
			"onetempStr=onetempStr+Spl+OrderPriorRemarks+Spl+DHCDocOrdStage+Spl+DHCMustEnter+Spl+SpeedFlowRate+Spl+FlowRateUnit;"+
			"onetempStr=onetempStr+Spl+OrderBodyPartLabel+Spl+NotifyClinician+Spl+SkinTest+Spl+SkinTestAction+Spl+RemoveCeler;"+
			"if (tempStr=='') {tempStr=onetempStr;}else{tempStr=tempStr+String.fromCharCode(1)+onetempStr;}"+
			
				 "};"+
			"oXL.Application.Quit();"+
			"return tempStr;}());";
	CmdShell.notReturn = 0;    //有返回值调用
	var rtn =CmdShell.EvalJs(str);     //运行代码且得到返回值 
	var Str=rtn.rtn
	if (Str!=""){
		var tempStr=""
		var Count=0
		var ret=0
		var retInfo=""
		for (var i = 0; i < Str.split(String.fromCharCode(1)).length; i++) { 
			var onetempStr=Str.split(String.fromCharCode(1))[i]
			if (tempStr=='') {tempStr=onetempStr;}else{tempStr=tempStr+String.fromCharCode(1)+onetempStr;}
			if ((tempStr!="")&&(Count>50)){
				rtn=tkMakeServerCall("web.DHCDocPrefTabs","ImportARCOSXls",tempStr);
				retnumber=rtn.split("^")[0]
				retInfo=retInfo+rtn.split("^")[1]
				ret=parseFloat(ret)+parseFloat(retnumber)
				tempStr="";
				Count=0;
			}
			Count=Count+1;
		}
		if (tempStr!=""){
			rtn=tkMakeServerCall("web.DHCDocPrefTabs","ImportARCOSXls",tempStr);
			retnumber=rtn.split("^")[0]
			retInfo=retInfo+rtn.split("^")[1]
			ret=parseFloat(ret)+parseFloat(retnumber)
		}
		$.messager.alert("提示", "导入成功"+ret+"条数据!"+retInfo, 'info');
		
	}
	//document.getElementById("resultdiv").innerText = rtn; 
	return;
}
//导入诊断模板
function ImportDiagTempHandler(fileName){
	var str ="(function test(x){"+
			"var oXL = new ActiveXObject('Excel.Application');"+
			"var fileName=''; "+
			"var fileName = oXL.Application.GetOpenFilename ('Excel Spreadsheets (*.xls), *.xls');" +
			"if (fileName==''){return '';}" +
			"var oWB = oXL.Workbooks.open(fileName);"+
			"oWB.worksheets(1).select();"+
			"var oSheet = oWB.ActiveSheet;  "+
			"var rows =  oSheet.usedrange.rows.count;"+
			" var ret=0;"+
			"var Spl=String.fromCharCode(2);"+
			"var tempStr='';"+ 
			"for (var i = 2; i <= rows; i++) {"+
				"var TypeCode=oSheet.Cells(i, 2).value;"+
				"var TypeValue=oSheet.Cells(i, 3).value;"+
				"var Cat=oSheet.Cells(i, 6).value;"+
				"var DiagType=oSheet.Cells(i, 7).value;"+
				"var ICDCode=oSheet.Cells(i, 8).value;"+
				"var Note=oSheet.Cells(i, 10).value==undefined?'':oSheet.Cells(i,10).value;"+
				"var SyndCode=oSheet.Cells(i, 11).value==undefined?'':oSheet.Cells(i,11).value;"+
				"var SyndNote=oSheet.Cells(i, 13).value==undefined?'':oSheet.Cells(i,13).value;"+
				"var Prefix=oSheet.Cells(i, 14).value==undefined?'':oSheet.Cells(i,14).value;"+
				"var onetempStr=TypeCode+Spl+TypeValue+Spl+DiagType+Spl+ICDCode+Spl+Note;"+
				"onetempStr=onetempStr+Spl+SyndCode+Spl+SyndNote+Spl+Prefix+Spl+Cat;"+
				"if (tempStr=='') {tempStr=onetempStr;}else{tempStr=tempStr+String.fromCharCode(1)+onetempStr;}"+
			"};"+
			"oXL.Application.Quit();"+
			"return tempStr;}());";
	CmdShell.notReturn = 0;    //有返回值调用
	var rtn =CmdShell.EvalJs(str);     //运行代码且得到返回值 
	var Str=rtn.rtn
	if (Str!=""){
		var tempStr=""
		var Count=0
		var ret=0
		var retInfo=""
		for (var i = 0; i < Str.split(String.fromCharCode(1)).length; i++) { 
			var onetempStr=Str.split(String.fromCharCode(1))[i]
			if (tempStr=='') {tempStr=onetempStr;}else{tempStr=tempStr+String.fromCharCode(1)+onetempStr;}
			if ((tempStr!="")&&(Count>50)){
				retnumber=tkMakeServerCall("web.DHCDocPrefTabs","ImportDiagTempXls",tempStr);
				ret=parseFloat(ret)+parseFloat(retnumber)
				tempStr="";
				Count=0;
			}
			Count=Count+1;
		}
		if (tempStr!=""){
			retnumber=tkMakeServerCall("web.DHCDocPrefTabs","ImportDiagTempXls",tempStr);

			ret=parseFloat(ret)+parseFloat(retnumber)
		}
		$.messager.alert("提示", "导入成功"+ret+"条数据!", 'info');
		FindHandler();
		
	}
	//document.getElementById("resultdiv").innerText = rtn; 
	return;
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
	var BeforeCode=""
	var Count=0
	
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
			
			
			
			//同一列名分两次导入会有问题，这里按列名拆分
			if ((tempStr!="")&&(Count>50)&&(BeforeCode!=valueCode)){
				console.log(i+","+Count+","+tempStr);
				ret=ret+tkMakeServerCall("web.DHCDocPrefTabs","ImportDiagTempXls",tempStr);
				tempStr="";
				Count=0;
			}
			if (tempStr=="") tempStr=onetempStr
			else tempStr=tempStr+String.fromCharCode(1)+onetempStr
			Count=Count+1;
			BeforeCode=valueCode;
			
			
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
	var str ="(function test(x){"+
			"var oXL = new ActiveXObject('Excel.Application');"+
			"var fileName=''; "+
			"var fileName = oXL.Application.GetOpenFilename ('Excel Spreadsheets (*.xls), *.xls');" +
			"if (fileName==''){return '';}" +
			"var oWB = oXL.Workbooks.open(fileName);"+
			"oWB.worksheets(1).select();"+
			"var oSheet = oWB.ActiveSheet;  "+
			"var rows =  oSheet.usedrange.rows.count;"+
			" var ret=0;"+
			"var Spl=String.fromCharCode(2);"+
			"var tempStr='';"+ 
			"for (var i = 2; i <= rows; i++) {"+
				"var FavCatType=oSheet.Cells(i, 2).value||'';"+
				"var TypeValue=oSheet.Cells(i, 3).value||'';"+
				"var Cat=oSheet.Cells(i,6).value==undefined?'':oSheet.Cells(i,6).value;"+
				"var SubCat=oSheet.Cells(i,7).value==undefined?'':oSheet.Cells(i,7).value;"+
				"var ItemID=oSheet.Cells(i,9).value||'';"+
				"var PartCodeInfo=oSheet.Cells(i, 11).value||'';"+
				"var Note=oSheet.Cells(i,12).value==undefined?'':oSheet.Cells(i,12).value;"+
				"var ItemType=oSheet.Cells(i,8).value||'';"+
				"var onetempStr=FavCatType+Spl+TypeValue+Spl+Cat+Spl+SubCat+Spl+ItemID+Spl+PartCodeInfo+Spl+Note+Spl+ItemType;"+
				"if (tempStr=='') {tempStr=onetempStr;}else{tempStr=tempStr+String.fromCharCode(1)+onetempStr;}"+
			"};"+
			"oXL.Application.Quit();"+
			"return tempStr;}());";
	CmdShell.notReturn = 0;    //有返回值调用
	var rtn =CmdShell.EvalJs(str);     //运行代码且得到返回值 
	var Str=rtn.rtn
	if (Str!=""){
		var tempStr=""
		var Count=0
		var ret=0
		var retInfo=""

		for (var i = 0; i < Str.split(String.fromCharCode(1)).length; i++) { 
			var onetempStr=Str.split(String.fromCharCode(1))[i]
			if (tempStr=='') {tempStr=onetempStr;}else{tempStr=tempStr+String.fromCharCode(1)+onetempStr;}
			if ((tempStr!="")&&(Count>50)){
				ret=tkMakeServerCall("web.DHCDocPrefTabs","ImportPreferenceXls",tempStr);
				tempStr="";
				Count=0;
			}
			Count=Count+1;
		}
		if (tempStr!=""){
			ret=tkMakeServerCall("web.DHCDocPrefTabs","ImportPreferenceXls",tempStr);
		}
		$.messager.alert("提示", "导入成功"+ret, 'info');
		FindHandler();
	}
	//document.getElementById("resultdiv").innerText = rtn; 
	return;
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
    var BeforeCode=""
	var Count=0
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
			
			//同一列名分两次导入会有问题，这里按列名拆分
			if ((tempStr!="")&&(Count>50)&&(BeforeCode!=valueCode)){
				console.log(i+","+Count+","+tempStr);
				ret=tkMakeServerCall("web.DHCDocPrefTabs","ImportPreferenceXls",tempStr);
				tempStr="";
				Count=0;
			}
			
			if (tempStr=="") tempStr=onetempStr
			else tempStr=tempStr+String.fromCharCode(1)+onetempStr
			Count=Count+1;
			BeforeCode=valueCode;
         }  
    } catch(e) {  
    }  
    
    
    if (tempStr!=""){
		console.log("fin:"+tempStr);
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
	var CTLocName='',CTLocID='',UserName='',UserID='',HospName='',HospID='';
	var OperType=$('#FType').combobox('getValue');
	if(OperType=='Personal'){
		UserName=$('#FTypeValue').combobox('getText');
		UserID=$('#FTypeValue').combobox('getValue');
	}else if(OperType=='Departments'){
		CTLocName=$('#FTypeValue').combobox('getText');
		CTLocID=$('#FTypeValue').combobox('getValue');
	}else if(OperType=='Hospital'){
		HospName=$('#FTypeValue').combobox('getText');
		HospID=$('#FTypeValue').combobox('getValue');
	}
	var AppKey = $('input[name=OrdFavType]:checked').attr('id')||'';
	var HandleDataType = $('input:radio[name="HandleDataType"]:checked').val();
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
	HospID=session['LOGON.HOSPID'];
	return HandleDataType+"^"+OperType+"^"+CTLocName+"^"+CTLocID+"^"+UserName+"^"+UserID+"^"+AppKey+'^'+HospName+'^'+HospID;
}
function InitFType()
{
	$('#FType').combobox({
		url:'',
		editable:false,
		data:[{value:'',text:'全部'},{value:'Personal',text:'个人'},{value:'Departments',text:'科室'}],	//,{value:'Hospital',text:'医院'}
		onSelect:function(){
			InitFTypeValue();
		},
		onLoadSuccess:function(){
			InitFTypeValue();
		}
	});
}
function InitFTypeValue()
{
	var FType=$('#FType').combobox('getValue');
	if(FType==''){
		$('#FTypeValue').combobox({url:'',data:[]});
	}else if(FType=='Personal'){
		$('#FTypeValue').combobox({
			url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=LookUpUser&desc=&ResultSetType=array&HospId="+session['LOGON.HOSPID'],
			valueField:'ID',
			textField:'USER',
			filter: function(q, row){
				var ops = $(this).combobox('options');  
				var mCode = row.USER.toUpperCase().indexOf(q.toUpperCase()) >= 0
				var mValue = row[ops.textField].indexOf(q) >= 0;
				return mCode||mValue;  
				}
		});
	}else if(FType=='Departments'){
		$('#FTypeValue').combobox({
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
		});
	}else{
		$('#FTypeValue').combobox({
			url:$URL+"?ClassName=DHCDoc.OPDoc.Workflow&QueryName=QueryHosp&ResultSetType=array",
			valueField:'id',
			textField:'text',
			mode: "local",
			filter: function(q, row){
				var ops = $(this).combobox('options');  
				var mCode = row.code.toUpperCase().indexOf(q.toUpperCase()) >= 0
				var mValue = row[ops.textField].indexOf(q) >= 0;
				return mCode||mValue;  
			}
		});
	}
}