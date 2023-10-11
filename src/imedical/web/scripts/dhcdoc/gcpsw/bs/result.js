/**
 * result.js
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-04-28
 * 
 * 
 */
$(function() {
	Init();
	InitEvent();
})


function Init(){
	InitPLObject();
	AutoFit();
	InitPrjGrid();
	InitPatGrid();
	StopButtonEvent("#RemoveAdm,#BackAdm")
}
function InitEvent () {
	$("#FindPat").click(FindPat_Handle);
	$("#FindAdm").click(FindAdm_Handle);
	$('#i-layout').layout('panel', 'center').panel({
		onResize: function (w,h) { 
			AutoFit();	
		}
	});
	$(window).resize(AutoFit);
	
	$("#RDel").checkbox({
		onChecked:function () {
			$("#RemoveAdm").linkbutton('disable');
			$("#BackAdm").linkbutton('enable');
			FindPat_Handle()
		},
		onUnchecked: function () {
			$("#RemoveAdm").linkbutton('enable');
			$("#BackAdm").linkbutton('disable');
			FindPat_Handle()
		}
	})
	
	$("#RemoveAdm").click(RemoveAdm_Handle)
	$("#BackAdm").click(BackAdm_Handle)
}

function InitLisEvent () {
	$(".c-link").click(function() {
		var ITID=$(this).attr("value"),
			PKID=$(this).attr("pkid"),
			code=$(this).attr("code"),
			Text=$(this).text();
			
		var Lis = ""
		if (code == "InLis") Lis=PLObject.v_InLisObj[ITID];
		else Lis=PLObject.v_OutLisObj[ITID];
		
		var URL = "gcpsw.bs.result.lis.csp?ITID="+ITID+"&PKID="+PKID+"&Lis="+Lis+"&code="+code;
		websys_showModal({
			url:URL,
			iconCls: 'icon-w-edit',
			title:Text,
			closable:false,
			width:600,height:500,
			CallBackFunc:SetLis
		})
		
	})
}
function SetLis(PLis,ITID) {
	PLObject.v_InLisObj[ITID] = PLis
	//PLObject.v_Lis = PLis;
	//debug(PLObject.v_InLisObj,"PLObject.v_InLisObj")
	return false;
}
function RemoveAdm_Handle () {
	var selected = PLObject.m_PatGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	
	$.messager.confirm("提示", "确认移至回收站？",function (r) {
		if (r) {
			$m({
				ClassName:"DHCDoc.GCPSW.BS.Result",
				MethodName:"ChgRDel",
				RID:selected.id,
				Val:1
			}, function(result){
				if (result == 0) {
					$.messager.alert("提示", "移除成功！", "info");
					FindPat_Handle();
					return true;
				} else {
					$.messager.alert("提示", "移除失败：" + result , "info");
					return false;
				}
			});
		}
		
	});
	
	
	
}

function BackAdm_Handle() {
	var selected = PLObject.m_PatGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	
	$.messager.confirm("提示", "确认还原么？",function (r) {
		if (r) {
			$m({
				ClassName:"DHCDoc.GCPSW.BS.Result",
				MethodName:"ChgRDel",
				RID:selected.id,
				Val:0
			}, function(result){
				if (result == 0) {
					$.messager.alert("提示", "还原成功！", "info");
					FindPat_Handle();
					return true;
				} else {
					$.messager.alert("提示", "还原失败：" + result , "info");
					return false;
				}
			});
		}
		
	});
}

function ClearCondition() {
	$("#li-sex").find("input").radio('uncheck');
	$("#s-age,#e-age,#s-height,#e-height,#s-weight,#e-weight,#s-BMI,#e-BMI").val("")
	$("#InDiag").empty();
	$("#OutDiag").empty();
	$("#InLis").empty();
	$("#OutLis").empty();
}

function SetCondition(PID) {
	ClearCondition();
	$cm({
		ClassName:"DHCDoc.GCPSW.Model.BSKPI",
		MethodName:"GetInfo",
		PID:PID
	},function(MObj){
		debug(MObj,"MOBJ")
		if (MObj.sex) {
			$("#li-sex").find("input[value='"+ MObj.sex +"']").checkbox('check');
		}
		if (MObj.age) {
			var ageArr=MObj.age.split(",")
			$("#s-age").val(ageArr[0])
			$("#e-age").val(ageArr[1])
		}
		if (MObj.height) {
			var arr=MObj.height.split(",")
			$("#s-height").val(arr[0])
			$("#e-height").val(arr[1])
		}
		if (MObj.weight) {
			var arr=MObj.weight.split(",")
			$("#s-weight").val(arr[0])
			$("#e-weight").val(arr[1])
		}
		if (MObj.BMI) {
			var arr=MObj.BMI.split(",")
			$("#s-BMI").val(arr[0])
			$("#e-BMI").val(arr[1])
		}
		$("#InDiag").append($(MObj.InDiagHtml));
		$("#OutDiag").append($(MObj.OutDiagHtml));
		$("#InLis").append($(MObj.InLisHtml));
		$("#OutLis").append($(MObj.OutLisHtml));
		$(".c-checkbox,.c-checkbox2").checkbox();
		SetLisObj(MObj);
		//InitLisEvent();
		FindPat_Handle();
	});

}
function SetDefaultButton() {
	$("#RDel").checkbox("uncheck");
	$("#RemoveAdm").linkbutton('enable');
	$("#BackAdm").linkbutton('disable');	
}
function InitCombox() {
	PLObject.m_TPL = $HUI.combobox("#i-tpl", {
		url:$URL+"?ClassName=DHCDoc.Chemo.CFG.Template&QueryName=QryTPL&ResultSetType=array",
		valueField:'id',
		textField:'name',
		blurValidValue:true,
		onSelect: function () {
			findConfig();
		}
	});
}

function InitPLObject() {
	PLObject.v_PID="";
	PLObject.v_RID="";
	
	PLObject.v_InLis="";
	PLObject.v_OutLis="";
	PLObject.v_InLisVal="";
	PLObject.v_OutLisVal="";
	//Query后台参数
	PLObject.v_InLisObj={};
	PLObject.v_OutLisObj={};
	//解析参数对象
	PLObject.v_InLisValObj={};
	PLObject.v_OutLisValObj={};
}

function SetLisObj (MObj) {
	PLObject.v_InLis = MObj.InLis||"";
	PLObject.v_OutLis = MObj.OutLis||"";
	PLObject.v_InLisVal = MObj.InLisVal||"";
	PLObject.v_OutLisVal = MObj.OutLisVal||"";
	debug(PLObject,"PLObject")
	if (PLObject.v_InLisVal) {
		//5||2#Test^12/5||1#WhiteCell^1!s-Platelet^1!e-Platelet^3
		//3||1^0013^1,2^FULL^1#D001^3950||1!D002^3949||1!D003^11730||1
		var TempArr = PLObject.v_InLisVal.split("/")
		for (i=0; i<TempArr.length; i++) {
			var rec = TempArr[i];
			var recArr = rec.split("#");
			var keyArr = recArr[0].split("^")
			var List= recArr[1]
			var key = keyArr[0]
			PLObject.v_InLisValObj[key]=rec
		}
	}
	
	if (PLObject.v_OutLisVal) {
		//5||2#Test^12/5||1#WhiteCell^1!s-Platelet^1!e-Platelet^3
		var TempArr = PLObject.v_OutLisVal.split("/")
		for (i=0; i<TempArr.length; i++) {
			var rec = TempArr[i];
			var recArr = rec.split("#");
			var keyArr = recArr[0].split("^")
			var List= recArr[1]
			var key = keyArr[0]
			PLObject.v_OutLisValObj[key]=rec
		}
	}
	
	if (PLObject.v_InLis) {
		var TempArr = PLObject.v_InLis.split(",")
		for (i=0; i<TempArr.length; i++) {
			PLObject.v_InLisObj[TempArr[i]]=PLObject.v_InLisValObj[TempArr[i]]
		}
	}
	if (PLObject.v_OutLis) {
		var TempArr = PLObject.v_OutLis.split(",")
		for (i=0; i<TempArr.length; i++) {
			PLObject.v_OutLisObj[TempArr[i]]=PLObject.v_OutLisValObj[TempArr[i]]
		}
	}
	
	//debug(PLObject.v_OutLisObj,"v_OutLisObj");
}

function InitPrjGrid(){
	var columns = [[
		{field:'code',title:'代码',width:60,hidden:true},
		{field:'desc',title:'项目',width:100},
		{field:'startDate',title:'开始日期',width:100},
		{field:'endDate',title:'结束日期',width:100},
		{field:'gcpName',title:'科研项目',width:100},
		{field:'id',title:'id',width:100,hidden:true}
	]]
	var toolbar =[			
		] 
	var DataGrid = $HUI.datagrid("#list-prj", {
		fit : true,
		striped : true,
		border:false,
		singleSelect : true,
		fitColumns : false,
		rownumbers:false,
		//autoRowHeight : false,
		pagination : true,  
		//headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.GCPSW.BS.Result",
			QueryName : "QryPrj",
			UserID: session['LOGON.USERID']
		},
		onSelect: function (rowIndex, rowData) {
			PLObject.v_PID = rowData.id;
			SetDefaultButton();
			SetCondition(rowData.id)
			//FindPat_Handle();
			
		},
		toolbar:toolbar,
		columns :columns,
		onLoadSuccess: function (data) {
		    if (data.rows.length == 0) {}
		    else {
		        //$(this).datagrid("selectRow", 0);
		    }
		}

	});
	
	PLObject.m_PrjGrid = DataGrid;
}

function InitPatGrid(){
	var columns = [[
		{field:'PatName',title:'患者',width:100},
		{field:'PatNo',title:'患者ID',width:100},
		{field:'sexDesc',title:'性别',width:100},
		{field:'age',title:'年龄',width:100},
		{field:'height',title:'身高(cm)',width:100},
		{field:'weight',title:'体重(kg)',width:100},
		{field:'BMI',title:'BMI(kg/m2)',width:100},
		{field:'telPhone',title:'联系方式',width:100},
		{field:'admLoc',title:'最近一次就诊科室',width:100,hidden:true},
		{field:'admDoc',title:'最近一次接诊医生',width:100,hidden:true},
		{field:'PatientID',title:'PatientID',width:100,hidden:true},
		{field:'id',title:'id',width:100,hidden:false}
	]]
	var toolbar =[	
			{
				text:'查看就诊',
				id:'FindAdm',
				iconCls: 'icon-end-adm'
			},
			{
				text:'移至回收站',
				id:'RemoveAdm',
				iconCls: 'icon-remove'
			},
			{
				text:'还原',
				id:'BackAdm',
				iconCls: 'icon-back'
			}		
		] 
	var DataGrid = $HUI.datagrid("#list-pat", {
		fit : true,
		striped : true,
		border:false,
		singleSelect : true,
		fitColumns : true,
		rownumbers:false,
		//autoRowHeight : false,
		pagination : true,  
		//headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.GCPSW.BS.Result",
			QueryName : "QryResult"
		},
		onSelect: function (rowIndex, rowData) {
			PLObject.v_RID = rowData.id;
		},
		toolbar:toolbar,
		columns :columns,
		onLoadSuccess: function (data) {
		    if (data.rows.length == 0) {}
		    else {
		        //$(this).datagrid("selectRow", 0);
		    }
		}

	});
	
	PLObject.m_PatGrid = DataGrid;
}

function FindPat_Handle () {
	
	//个人基本信息
	var sex = [];
		$('#li-sex input:checked').each(function(){  
		    sex.push($(this).val());
		});  
		sex=sex.join('-')
	
	var age = $.trim($("#s-age").val())+"-"+$.trim($("#e-age").val()),
		height = $.trim($("#s-height").val())+"-"+$.trim($("#e-height").val()),
		weight = $.trim($("#s-weight").val())+"-"+$.trim($("#e-weight").val()),
		BMI = $.trim($("#s-BMI").val())+"-"+$.trim($("#e-BMI").val());
	
	//诊断
	var InDiag=[],
		OutDiag=[];
		$('#InDiag input:checked').each(function(){  
		    InDiag.push($(this).val());
		}); 
		$('#OutDiag input:checked').each(function(){  
		    OutDiag.push($(this).val());
		}); 
		InDiag=InDiag.join('-');
		OutDiag=OutDiag.join('-');
		
	//检验
	var InLis=[],
		OutLis=[];
		/*$('#InLis input:checked').each(function(){  
			var val = $(this).val();
			var record = val + "#" + PLObject.v_InLisObj[val];
		    InLis.push(record);
		}); 
		$('#OutLis input:checked').each(function(){  
			var val = $(this).val();
			var record = val + "#" + (PLObject.v_OutLisObj[val]||"");
		    OutLis.push(record);
		}); */
		{
			//3||1^0013^1,2^FULL^1#D001^3950||1!D002^3949||1!D003^11730||1
			console.log(PLObject.v_InLisObj)
			for(var key  in PLObject.v_InLisObj){
				var cval = PLObject.v_InLisObj[key];
				if (typeof cval == "undefined") {
					continue	
				}
				var itInfo = cval.split("#")[0];
				var ikInfo = cval.split("#")[1];
				var itArr = itInfo.split("^");
				var value = itArr[3]
				var section = itArr[4]
				var sid = "InLisS-"+itArr[1],
					eid = "InLisE-"+itArr[1],
					bid = "InLis-"+itArr[1];
				if (section == "1") {
					var svalue = $.trim($("#"+sid).val());
					var evalue = $.trim($("#"+eid).val());
					value = svalue + "," + evalue
				} else {
					value = $.trim($("#"+bid).val()); 	
				}
				var final = itArr[0]+"^"+itArr[1]+"^"+value+"^"+itArr[3]+"^"+itArr[4];
				final = final + "#" + ikInfo;
				InLis.push(final);
			}	
		}
		InLis=InLis.join('/');
		OutLis=OutLis.join('/');
	//
	var PersonArr = {
		sex:sex,
		age:age,
		height:height,
		weight:weight,
		BMI:BMI
	}
	
	var DiagArr = {
		InDiag:InDiag,
		OutDiag:OutDiag
	}
	var LisArr = {
		InLis:InLis,
		OutLis:OutLis
	}
	
	//var KPIContent = $.trim($("#KPIContent").val());
	debug(JSON.stringify(LisArr),"LisArr")
	
	var RDel = $("#RDel").checkbox("getValue")?1:0;
	var ExtArr = RDel
	PLObject.m_PatGrid.reload({
		ClassName : "DHCDoc.GCPSW.BS.Result",
		QueryName : "QryResult",
		PID: PLObject.v_PID,
		ExtArr: ExtArr,
		PersonArr:JSON.stringify(PersonArr),
		DiagArr:JSON.stringify(DiagArr),
		LisArr:JSON.stringify(LisArr),
		InHosp:session['LOGON.HOSPID']
	});
}

function FindAdm_Handle () {
	var selected = PLObject.m_PatGrid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	//debug(selected,"selected")
	var URL = "gcpsw.bs.result.adm.csp?PatientID="+selected.PatientID;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'就诊列表',
		width:$(window).width()-100,height:$(window).height()-100
	})
	
	
}

function AutoFit() {
	var docW = $(document).width(); 
	var winW = $("#i-center").width();
	var panelW = Math.floor((winW-30)*0.33);
	$(".condition").css("width",panelW);
	var PW = $(".condition").outerWidth();
	var PH = $(".condition").height();
	$('.c-panel').panel("resize",{
		width:PW,
		height:PH
	});
}
