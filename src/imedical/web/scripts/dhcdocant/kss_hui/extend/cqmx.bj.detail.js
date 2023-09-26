/**
 * func.bsnormal.js
 * 
 * Copyright (c) 2016-2017 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2017-03-09
 * 
 */
var PageLogicObj = {
	m_Grid: ""
}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();
	
	//页面元素初始化
	//PageHandle();
})

function Init(){
	autoFit();
	InitSideEffect();
	InitCombox();
	InitPatientInfo();
	
}

function InitEvent(){		
	$('html,body').animate({scrollTop:0},300);
	$(window).resize(autoFit);
	
	//保存
	$("#i-save").click(function () {
		var cqmxInfo = GetCqmxInfo();
		$m({
			ClassName:"DHCAnt.KSS.Extend.CQMXBJ",
			MethodName:"UnifySaveCqmx",
			saveUser:session['LOGON.USERID'],
			saveType:"UNIFY",
			saveInfo:cqmxInfo,
			execId: ServerObj.Cqmxid
		},function(responseData){
			if (responseData == 0) {
				$.messager.alert("提示","保存成功！","info", function() {
					parent.findConfig();
					parent.destroyDialog("EditCQMXInfo");
				});
			} else {
				$.messager.alert("提示","保存失败！","error");
			}
			
		})
	
	});
	
	$(".anchor-list li a").mouseover(function(){
		$(this).addClass("anchor-cur");
	});
	$(".anchor-list li a").mouseout(function(){
		$(this).removeClass("anchor-cur");
	});

	$("#nav1").click(function() {
		$(window).scrollTop($("#goto1").offset().top-10);
	});
	$("#nav2").click(function() {
		$(window).scrollTop($("#goto2").offset().top-10);
	}); 
	$("#nav3").click(function() {
		$(window).scrollTop($("#goto3").offset().top-10);
	});
	$("#nav4").click(function() {
		$(window).scrollTop($("#goto4").offset().top-10);
	});
	$("#nav5").click(function() {
		$(window).scrollTop($("#goto5").offset().top-10);
	});
	
	var h1 = $("#goto1").offset().top;
	var h2 = $("#goto2").offset().top;
	var h3 = $("#goto3").offset().top;
	var h4 = $("#goto4").offset().top;
	var h5 = $("#goto5").offset().top;
	
	$(document).scroll(function(){
		var CH = $(document).scrollTop();
		if (CH>h5) {
			toggleNav(5,5);
		} else if (CH>h4) {
			toggleNav(4,5);
		} else if (CH>h3) {
			toggleNav(3,5);
		} else if (CH>h2) {
			toggleNav(2,5);
		} else if (CH < 10){
			toggleNav(0,5);
		} else {
			toggleNav(1,5);
		}

	})
}

function PageHandle(){
	//
}

function InitPatientInfo () {
	$m({
		ClassName:"DHCAnt.KSS.Extend.CQMXBJ",
		MethodName:"GetPatientInfo",
		admid:ServerObj.EpisodeID,
		locid:"",
		arcim:ServerObj.ArcimDr
	},function(responseData){
		if (responseData != "") {
			var resultArr = responseData.split("^");
			$("#PatName").val(resultArr[0]);
			$("#IPNo").val(resultArr[1]);
			$("#Age").val(resultArr[2]);
			$("#Sex").val(resultArr[4]);
			$("#AdmLoc").val(resultArr[5]);
			$("#InDiagnosis").val(resultArr[3]);
			
			//赋值隐藏元素值
			$("#Locid").val(resultArr[6]);
			$("#ArcimDesc").val(resultArr[7]);
			$("#Admid").val(ServerObj.EpisodeID);
			$("#ArcimDr").val(ServerObj.ArcimDr);
			$("#ApplyDr").val(ServerObj.ApplyDr);
			$("#AimDr").val(ServerObj.AimDr);
			
		}
	})
}
function InitSideEffect() {
	$m({
		ClassName:"DHCAnt.KSS.Extend.CQMXBJ",
		MethodName:"LoadSideEffect"
	},function(responseData){
		var resultArr = responseData.split(String.fromCharCode(1));
		for (var i=0;i<resultArr.length;i++) {
			var record = resultArr[i].split("^");
			var id = record[0];
			var desc = record[1];
			var code = record[2];
			var dom = "<input id='seffect-"+ code +"' class='hisui-checkbox' type='checkbox' value='"+ id +"' label='"+ desc +"'>";
			$("#SideEffect").append($(dom));
			//$(dom).checkbox();
		}
		$("#SideEffect input").each(function(){
			var _id = $(this).attr("id");
			$(this).checkbox({
				onChecked:function (e,inValue) {
					if (_id == "seffect-01") {
						$("#SideEffect input").each(function(){
							var _id = $(this).attr("id");
							if (_id != "seffect-01") {
								$(this).checkbox("uncheck");
							}
						})
					} else if (_id == "seffect-04") {
						$("#TLJSpecimen").combobox("enable");
						$("#TLJLabDate").datebox("enable");
						$("#TLJReportDate").datebox("enable");
					} else if (_id == "seffect-05") {
						$("#BDGJSpecimen").combobox("enable");
						$("#BDGJLabDate").datebox("enable");
						$("#BDGJReportDate").datebox("enable");
					} else if (_id == "seffect-06") {
						$("#CGJSpecimen").combobox("enable");
						$("#CGJLabDate").datebox("enable");
						$("#CGJReportDate").datebox("enable");
					} else {
						$("#seffect-01").checkbox("uncheck");
					}
				},
				onUnchecked: function (e,inValue) {
					if (_id == "seffect-04") {
						$("#TLJSpecimen").combobox("disable").combobox("clear");
						$("#TLJLabDate").datebox("disable").datebox("clear");
						$("#TLJReportDate").datebox("disable").datebox("clear");
					} else if (_id == "seffect-05") {
						$("#BDGJSpecimen").combobox("disable").combobox("clear");
						$("#BDGJLabDate").datebox("disable").datebox("clear");
						$("#BDGJReportDate").datebox("disable").datebox("clear");
					} else if (_id == "seffect-06") {
						$("#CGJSpecimen").combobox("disable").combobox("clear");
						$("#CGJLabDate").datebox("disable").datebox("clear");
						$("#CGJReportDate").datebox("disable").datebox("clear");
					} else {}
				}
			});
		})
		InitData();
		/*
		$("#seffect-01").checkbox({
			onChecked:function (e,inValue) {
				$("#SideEffect input").each(function(){
					var _id = $(this).attr("id");
					if (_id != "seffect-01") {
						$(this).checkbox("uncheck");
					}
				})
			}
		})*/
		
	});
}

function InitCombox () {
	//var find = false;
	//入院第一诊断
	$HUI.combogrid("#FirstDiagnosisDrBox", {
		panelWidth:500,
		panelHeight:300,
		//required:true,
		delay: 500,    
		mode: 'remote',    
		url:$URL+"?ClassName=DHCAnt.KSS.Extend.CQMX&QueryName=LookUpWithAlias",
		fitColumns: true,   
		striped: true,   
		editable:true,   
		pagination : true,//是否分页   
		rownumbers:true,//序号   
		collapsible:false,//是否可折叠的   
		fit: true,//自动大小   
		pageSize: 10,//每页显示的记录条数，默认为10   
		pageList: [10],//可以设置每页记录条数的列表   
		method:'post', 
		idField: 'Rowid',    
		textField: 'desc',    
		/*
		onLoadSuccess: function(data) { // 当前请求的页面数据。
            $.each(data.rows, function(index, value) {
                if ("7770" == value.Rowid) { // value.id与idField属性对应的值
                    find = true;// 循环当前请求页面数据，如果取出的值与默认值一致，则设置成找到
                }
            });
            if (!find) {
                // combogrid获取下一页页码
                var nextPage = $('#FirstDiagnosisDr').combogrid('grid').datagrid('options').pageNumber + 1;
                $('#FirstDiagnosisDr').combogrid('grid').datagrid('getPager').pagination("select", nextPage);
            }
        },*/
	
		columns: [[  
			{field:'desc',title:'名称',width:400,sortable:true},
			{field:'code',title:'代码',width:120,sortable:true},
			{field:'Rowid',title:'ID',width:120,sortable:true,hidden:false},
		]],
		onSelect: function (record){
			var selected = $('#FirstDiagnosisDrBox').combogrid('grid').datagrid('getSelected');  
			if (selected) { 
			  $('#FirstDiagnosisDrBox').combogrid("options").value=selected.Rowid;
			}; 
			$("#FirstDiagnosisDrDesc").val(selected.desc);	//$("#FirstDiagnosisDrBox").combogrid("getText")
			$("#FirstDiagnosisDr").val(selected.Rowid);		//$("#FirstDiagnosisDrBox").combogrid("getValue")
		 },
		 onBeforeLoad:function(param){
			 var desc=param['q'];
			 param = $.extend(param,{desc:param["q"]});
		 }
	});
	
	//是否院感
	$HUI.combobox("#SenseHospital", {
		valueField:'id',
		textField:'text',
		data:[
			{id:'Y',text:'是'},
			{id:'N',text:'否'}
		]
	});	
	
	//感染部位
	$HUI.combobox("#InfectionSite", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.BaseData&QueryName=QryAllbasedata&type=CQMXSITE&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		blurValidValue:true
		
	});	
	
	//适应症
	$HUI.combobox("#Indication", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.BaseData&QueryName=QryAllbasedata&type=CQMXIND&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		blurValidValue:true
		
	});	
	
	//处方权限
	$HUI.combobox("#PrescAuth", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.BaseData&QueryName=QryAllbasedata&type=CQMXPAuth&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		blurValidValue:true
		
	});	
	
	//感染诊断
	$HUI.combogrid("#InfectionDiagnosisDrBox", {
		panelWidth:500,
		panelHeight:300,
		//required:true,
		delay: 500,    
		mode: 'remote',    
		url:$URL+"?ClassName=DHCAnt.KSS.Extend.CQMX&QueryName=LookUpWithAlias",
		fitColumns: true,   
		striped: true,   
		editable:true,   
		pagination : true,//是否分页   
		rownumbers:true,//序号   
		collapsible:false,//是否可折叠的   
		fit: true,//自动大小   
		pageSize: 10,//每页显示的记录条数，默认为10   
		pageList: [10],//可以设置每页记录条数的列表   
		method:'post', 
		idField: 'Rowid',    
		textField: 'desc',    
		columns: [[    
			{field:'desc',title:'名称',width:400,sortable:true},
			{field:'code',title:'代码',width:120,sortable:true},
			{field:'Rowid',title:'ID',width:120,sortable:true,hidden:false},
		]],
		onSelect: function (record){
			var selected = $('#InfectionDiagnosisDrBox').combogrid('grid').datagrid('getSelected');  
			if (selected) { 
			  $('#InfectionDiagnosisDrBox').combogrid("options").value=selected.Rowid;
			}
			$("#InfectionDiagnosisDrDesc").val(selected.desc);
			$("#InfectionDiagnosisDr").val(selected.Rowid);
		 },
		 onBeforeLoad:function(param){
			 var desc=param['q'];
			 param = $.extend(param,{desc:param["q"]});
		 }
	});
	
	//用药效果
	$HUI.combobox("#MedicationEffect", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.BaseData&QueryName=QryAllbasedata&type=CQMXMEffect&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		blurValidValue:true
		
	});	
	
	//调整方案
	$HUI.combobox("#AdjustPlan", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.BaseData&QueryName=QryAllbasedata&type=CQMXAPlan&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		blurValidValue:true
		
	});	
	
	//病原学证据
	$HUI.combobox("#EtiologyEvidence", {
		valueField:'id',
		textField:'text',
		data:[
			{id:'Y',text:'有'},
			{id:'N',text:'无'}
		]
	});	
	
	//标本类型
	$HUI.combobox("#SpecimenType", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.BaseData&QueryName=QryAllbasedata&type=CQMXSType&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		blurValidValue:true
		
	});	
	
	//病原学证据
	$HUI.combobox("#LabResult", {
		valueField:'id',
		textField:'text',
		data:[
			{id:'1',text:'阴性'},
			{id:'2',text:'阳性'}
		]
	});	
	
	//细菌名称
	$HUI.combobox("#BacteriaName", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.BaseData&QueryName=QryAllbasedata&type=CQMXBCName&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		blurValidValue:true
		
	});	
	
	//是否耐碳氢霉烯
	$HUI.combobox("#CQMXResist", {
		valueField:'id',
		textField:'text',
		data:[
			{id:'Y',text:'是'},
			{id:'N',text:'否'}
		]
	});	
	
	//CQMX药敏名称
	$HUI.combobox("#CQMXResistName", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.BaseData&QueryName=QryAllbasedata&type=CQMXResistName&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		blurValidValue:true
		
	});	
	
	//是否耐替加环素
	$HUI.combobox("#TGCResist", {
		valueField:'id',
		textField:'text',
		data:[
			{id:'Y',text:'是'},
			{id:'N',text:'否'}
		]
	});	
	
	//TGC药敏名称
	$HUI.combobox("#TGCResistName", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.BaseData&QueryName=QryAllbasedata&type=CQMXTGCResistName&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		blurValidValue:true
		
	});	
	
	//送检标本是否与感染诊断相关
	$HUI.combobox("#LabRelateInfectDiag", {
		valueField:'id',
		textField:'text',
		data:[
			{id:'Y',text:'是'},
			{id:'N',text:'否'}
		]
	});	
	
	//铜绿假单胞菌送检标本
	$HUI.combobox("#TLJSpecimen", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.BaseData&QueryName=QryAllbasedata&type=CQMXSType&ResultSetType=array",
		valueField:'id',
		disabled:true,
		textField:'desc',
		blurValidValue:true
		
	});	
	
	//不动杆菌送检标本
	$HUI.combobox("#BDGJSpecimen", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.BaseData&QueryName=QryAllbasedata&type=CQMXSType&ResultSetType=array",
		valueField:'id',
		disabled:true,
		textField:'desc',
		blurValidValue:true
		
	});	
	
	//肠杆菌送检标本
	$HUI.combobox("#CGJSpecimen", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.BaseData&QueryName=QryAllbasedata&type=CQMXSType&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		disabled:true,
		blurValidValue:true
		
	});	
}

function toggleNav(cid,len) {
	for (var i=1;i<=len;i++) {
		if (i == cid) {
			$("#nac" + i).removeClass("circle");
			$("#nac" + i).addClass("circle-pic");
		} else {
			$("#nac" + i).removeClass("circle-pic");
			$("#nac" + i).addClass("circle");	
		}
	}
}

function autoFit() {
	var mainW = $("#main").width();
	var panelW = mainW;		//Math.floor((winW-50)*0.33);
	$(".c-panel").css("width",panelW);
	var PW = $(".c-panel").outerWidth();
	$(".c-panel").each(function(){
		var PH = $(this).height();
		$(this).find(".c-padding").panel("resize",{
			width:PW,
			height:PH
		});
	});
}

function GetCqmxInfo(){
	var myxml = "";
	var myparseinfo = ServerObj.CQMXBJEntity;
	var myxml = GetEntityClassInfoToXML(myparseinfo)
	return myxml;
}

function GetEntityClassInfoToXML(ParseInfo) {
	var myxmlstr="";
	//try{
		var myary=ParseInfo.split("^");
		var xmlobj=new XMLWriter();
		xmlobj.BeginNode(myary[0]);
		for(var myIdx=1;myIdx<myary.length;myIdx++){
			xmlobj.BeginNode(myary[myIdx]);
			var cid = myary[myIdx];
			var _$id=$("#"+myary[myIdx]);
			if (_$id.length==0){
				//todo
			} else {
				if (_$id.hasClass("hisui-combobox")){
					var myval=_$id.combobox("getValue")||"";
				} else if (_$id.hasClass("hisui-combogrid")) {
					var myval=_$id.combogrid("getValue")||"";
				} else if (_$id.hasClass("hisui-datebox")) {
					var myval=_$id.datebox("getValue")||"";
				} else if (_$id.hasClass("checkgroup")) {
					var myval=[];
					$("#" + cid + " input:checkbox:checked").each(function() {
						myval.push($(this).val());
					});
					myval = myval.join(",");
				} else {
					var myval=_$id.val();
				}
			}
			xmlobj.WriteString(myval);
			xmlobj.EndNode();
		}
		xmlobj.Close();
		myxmlstr = xmlobj.ToString();
	//}catch(Err){
	//	$.messager.alert("提示","Error: " + Err.description);
	//}	
	return myxmlstr;
}

function InitData() {
	var IsIE = (window.ActiveXObject || "ActiveXObject" in window)?"1":"2";
	var myXml = $.cm({
		ClassName:"DHCAnt.KSS.Extend.CQMXBJ",
		MethodName:"GetCqmxInfo",
		IsIE:IsIE,
		Cqmxid:ServerObj.Cqmxid,
		dataType:"text"
	},false); 
	if (myXml!=""){
		SetInfoByXML(myXml,IsIE);
	}
}

function SetInfoByXML(XMLStr,isIE){
	if (isIE == 1) {
		xMLStr = "<?xml version='1.0' encoding='gb2312'?>" + XMLStr
		var xmlDoc = DHCDOM_CreateXMLDOM();
		xmlDoc.async = false;
		xmlDoc.loadXML(XMLStr);
		if(xmlDoc.parseError.errorCode != 0) { 
			$.messager.alert("提示",xmlDoc.parseError.reason); 
			return; 
		}
		var nodes = xmlDoc.documentElement.childNodes; 
		
		for (var i=0; i<nodes.length; i++) {
			var myItemName = nodes(i).nodeName;	//OSKJ：1
			var myItemValue = nodes(i).text;
			var cid = myItemName;
			var _$id=$("#" + myItemName);
			if (_$id.length>0){
				if (_$id.hasClass("hisui-combobox")){
					//_$id.combobox("setValue",myItemValue);
					_$id.combobox("select",myItemValue);
					
				}else if(_$id.hasClass("hisui-checkbox")){
					if ((myItemValue=="Y")||(myItemValue=="1")){
						_$id.checkbox('check');
					}else{
						_$id.checkbox('uncheck');
					}
				} else if (_$id.hasClass("radiogroup")) {
					_$id.find("input[value='"+ myItemValue +"']").radio('check');
				} else if (_$id.hasClass("multiple")) {
					if (myItemValue == "") {
						continue;
					}
					var size = $("#" + myItemName + " option").size();
					if (size > 0) {
						$.each($("#" + myItemName + " option"), function(i,own){
							//ARCICRowId + ">" + n.ARCICDesc
							var cValue = $(this).attr("value");
							if ((","+myItemValue+",").indexOf(","+cValue+",")>=0) {
								$(this).attr("selected",true);
							}
						})
					}	   
					
					
				} else if (_$id.hasClass("hisui-datebox")) {
					_$id.datebox("setValue",myItemValue);
				} else if (_$id.hasClass("checkgroup")) {
					if (myItemValue == "") {
						continue;
					}
					var myItemValueStr = "," + myItemValue + ",";
					$("#" + cid + " input[type=checkbox]").each(function() {
						var cValue = "," + $(this).val() + ",";
						if (myItemValueStr.indexOf(cValue)>=0) {
							$(this).checkbox("check");
						}
					});
				} else if (_$id.hasClass("c-combogrid")) {
					var mid = myItemValue.split("^")[0];
					var text =  myItemValue.split("^")[1];
					$("#" + cid + "Desc").val(text);
					_$id.val(mid);
				} else {
					_$id.val(myItemValue);
				}
			}
		}
		delete(xmlDoc);
	} else {
		var jsonData = $.parseJSON(XMLStr);
		var myparseinfo = ServerObj.CQMXBJEntity;
		var myary = myparseinfo.split("^");
		for (var myIdx=1; myIdx<myary.length; myIdx++){
			var cid = myary[myIdx];
			var _$id=$("#"+cid);
			var myItemValue = jsonData[0][cid];
			if (_$id.hasClass("hisui-combobox")){
					_$id.combobox("select",myItemValue);
					
			}else if(_$id.hasClass("hisui-checkbox")){
				if ((myItemValue=="Y")||(myItemValue=="1")){
					_$id.checkbox('check');
				}else{
					_$id.checkbox('uncheck');
				}
			} else if (_$id.hasClass("radiogroup")) {
				_$id.find("input[value='"+ myItemValue +"']").radio('check');
			} else if (_$id.hasClass("multiple")) {
				if (myItemValue == "") {
					return false;
				}
				var size = $("#" + cid + " option").size();
				if (size > 0) {
					$.each($("#" + cid + " option"), function(i,own){
						//ARCICRowId + ">" + n.ARCICDesc
						var cValue = $(this).attr("value");
						if ((","+myItemValue+",").indexOf(","+cValue+",")>=0) {
							$(this).attr("selected",true);
						}
					})
				}	   
			} else if (_$id.hasClass("hisui-datebox")) { 
				_$id.datebox("setValue",myItemValue);
			} else if (_$id.hasClass("checkgroup")) {
				if (myItemValue == "") {
					continue;
				}
				var myItemValueStr = "," + myItemValue + ",";
				$("#" + cid + " input[type=checkbox]").each(function() {
					var cValue = "," + $(this).val() + ",";
					if (myItemValueStr.indexOf(cValue)>=0) {
						$(this).checkbox("check");
					}
				});
			} else if (_$id.hasClass("c-combogrid")) {
				var mid = myItemValue.split("^")[0];
				var text =  myItemValue.split("^")[1];
				$("#" + cid + "Desc").val(text);
				_$id.val(mid);
			} else {
				_$id.val(myItemValue);
			}
			
			
		}
	}
	
}

 