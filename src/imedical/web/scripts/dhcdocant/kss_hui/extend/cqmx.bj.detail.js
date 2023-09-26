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
	//��ʼ��
	Init();
	
	//�¼���ʼ��
	InitEvent();
	
	//ҳ��Ԫ�س�ʼ��
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
	
	//����
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
				$.messager.alert("��ʾ","����ɹ���","info", function() {
					parent.findConfig();
					parent.destroyDialog("EditCQMXInfo");
				});
			} else {
				$.messager.alert("��ʾ","����ʧ�ܣ�","error");
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
			
			//��ֵ����Ԫ��ֵ
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
	//��Ժ��һ���
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
		pagination : true,//�Ƿ��ҳ   
		rownumbers:true,//���   
		collapsible:false,//�Ƿ���۵���   
		fit: true,//�Զ���С   
		pageSize: 10,//ÿҳ��ʾ�ļ�¼������Ĭ��Ϊ10   
		pageList: [10],//��������ÿҳ��¼�������б�   
		method:'post', 
		idField: 'Rowid',    
		textField: 'desc',    
		/*
		onLoadSuccess: function(data) { // ��ǰ�����ҳ�����ݡ�
            $.each(data.rows, function(index, value) {
                if ("7770" == value.Rowid) { // value.id��idField���Զ�Ӧ��ֵ
                    find = true;// ѭ����ǰ����ҳ�����ݣ����ȡ����ֵ��Ĭ��ֵһ�£������ó��ҵ�
                }
            });
            if (!find) {
                // combogrid��ȡ��һҳҳ��
                var nextPage = $('#FirstDiagnosisDr').combogrid('grid').datagrid('options').pageNumber + 1;
                $('#FirstDiagnosisDr').combogrid('grid').datagrid('getPager').pagination("select", nextPage);
            }
        },*/
	
		columns: [[  
			{field:'desc',title:'����',width:400,sortable:true},
			{field:'code',title:'����',width:120,sortable:true},
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
	
	//�Ƿ�Ժ��
	$HUI.combobox("#SenseHospital", {
		valueField:'id',
		textField:'text',
		data:[
			{id:'Y',text:'��'},
			{id:'N',text:'��'}
		]
	});	
	
	//��Ⱦ��λ
	$HUI.combobox("#InfectionSite", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.BaseData&QueryName=QryAllbasedata&type=CQMXSITE&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		blurValidValue:true
		
	});	
	
	//��Ӧ֢
	$HUI.combobox("#Indication", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.BaseData&QueryName=QryAllbasedata&type=CQMXIND&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		blurValidValue:true
		
	});	
	
	//����Ȩ��
	$HUI.combobox("#PrescAuth", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.BaseData&QueryName=QryAllbasedata&type=CQMXPAuth&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		blurValidValue:true
		
	});	
	
	//��Ⱦ���
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
		pagination : true,//�Ƿ��ҳ   
		rownumbers:true,//���   
		collapsible:false,//�Ƿ���۵���   
		fit: true,//�Զ���С   
		pageSize: 10,//ÿҳ��ʾ�ļ�¼������Ĭ��Ϊ10   
		pageList: [10],//��������ÿҳ��¼�������б�   
		method:'post', 
		idField: 'Rowid',    
		textField: 'desc',    
		columns: [[    
			{field:'desc',title:'����',width:400,sortable:true},
			{field:'code',title:'����',width:120,sortable:true},
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
	
	//��ҩЧ��
	$HUI.combobox("#MedicationEffect", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.BaseData&QueryName=QryAllbasedata&type=CQMXMEffect&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		blurValidValue:true
		
	});	
	
	//��������
	$HUI.combobox("#AdjustPlan", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.BaseData&QueryName=QryAllbasedata&type=CQMXAPlan&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		blurValidValue:true
		
	});	
	
	//��ԭѧ֤��
	$HUI.combobox("#EtiologyEvidence", {
		valueField:'id',
		textField:'text',
		data:[
			{id:'Y',text:'��'},
			{id:'N',text:'��'}
		]
	});	
	
	//�걾����
	$HUI.combobox("#SpecimenType", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.BaseData&QueryName=QryAllbasedata&type=CQMXSType&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		blurValidValue:true
		
	});	
	
	//��ԭѧ֤��
	$HUI.combobox("#LabResult", {
		valueField:'id',
		textField:'text',
		data:[
			{id:'1',text:'����'},
			{id:'2',text:'����'}
		]
	});	
	
	//ϸ������
	$HUI.combobox("#BacteriaName", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.BaseData&QueryName=QryAllbasedata&type=CQMXBCName&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		blurValidValue:true
		
	});	
	
	//�Ƿ���̼��ùϩ
	$HUI.combobox("#CQMXResist", {
		valueField:'id',
		textField:'text',
		data:[
			{id:'Y',text:'��'},
			{id:'N',text:'��'}
		]
	});	
	
	//CQMXҩ������
	$HUI.combobox("#CQMXResistName", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.BaseData&QueryName=QryAllbasedata&type=CQMXResistName&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		blurValidValue:true
		
	});	
	
	//�Ƿ�����ӻ���
	$HUI.combobox("#TGCResist", {
		valueField:'id',
		textField:'text',
		data:[
			{id:'Y',text:'��'},
			{id:'N',text:'��'}
		]
	});	
	
	//TGCҩ������
	$HUI.combobox("#TGCResistName", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.BaseData&QueryName=QryAllbasedata&type=CQMXTGCResistName&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		blurValidValue:true
		
	});	
	
	//�ͼ�걾�Ƿ����Ⱦ������
	$HUI.combobox("#LabRelateInfectDiag", {
		valueField:'id',
		textField:'text',
		data:[
			{id:'Y',text:'��'},
			{id:'N',text:'��'}
		]
	});	
	
	//ͭ�̼ٵ������ͼ�걾
	$HUI.combobox("#TLJSpecimen", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.BaseData&QueryName=QryAllbasedata&type=CQMXSType&ResultSetType=array",
		valueField:'id',
		disabled:true,
		textField:'desc',
		blurValidValue:true
		
	});	
	
	//�����˾��ͼ�걾
	$HUI.combobox("#BDGJSpecimen", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.BaseData&QueryName=QryAllbasedata&type=CQMXSType&ResultSetType=array",
		valueField:'id',
		disabled:true,
		textField:'desc',
		blurValidValue:true
		
	});	
	
	//���˾��ͼ�걾
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
	//	$.messager.alert("��ʾ","Error: " + Err.description);
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
			$.messager.alert("��ʾ",xmlDoc.parseError.reason); 
			return; 
		}
		var nodes = xmlDoc.documentElement.childNodes; 
		
		for (var i=0; i<nodes.length; i++) {
			var myItemName = nodes(i).nodeName;	//OSKJ��1
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

 