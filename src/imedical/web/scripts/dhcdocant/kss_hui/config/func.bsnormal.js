/**
 * func.bsnormal.js
 * 
 * Copyright (c) 2016-2017 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2017-03-09
 * 
 */
var PageLogicObj = {
	m_Grid: "",
	m_UPMYFVAL:"",
	m_UPMZLVAL:"",
	m_UPMYFLEVEL_Val:"",
	m_UPMZLLEVEL_Val:"",
	m_UPMYF_Val: "",
	m_UPMZL_Val: "",
	m_Hosp: ""
}

$(function(){
	//��ʼ��
	Init();
	
	//�¼���ʼ��
	InitEvent();
	
	//ҳ��Ԫ�س�ʼ��
	PageHandle();
})

function Init(){
	
	InitEasyUITool();
	autoFit();
	InitCombox();
	//LoadMultipleData("LABOECATE", "OEItemCat");
	//LoadMultipleData("OETYPE", "OEType");
	//InitData();
	InitHospList();
	
}

function InitEvent(){
	$("#i-save").click(SaveBSNormal)
	$(window).resize(autoFit);
}

function PageHandle(){
	var upmYF = $("#UPMYFLEVEL").combobox("getValue")||"";
	var upmZL = $("#UPMZLLEVEL").combobox("getValue")||"";
	PageLogicObj.m_UPMYFLEVEL_Val = upmYF;
	PageLogicObj.m_UPMZLLEVEL_Val = upmZL;
	LoadMultipleData("UPMYFVAL", "UPMYF", upmYF);
	LoadMultipleData("UPMZLVAL", "UPMZL", upmZL);
	setMulitData("UPMYFVAL", PageLogicObj.m_UPMYFVAL);
	setMulitData("UPMZLVAL", PageLogicObj.m_UPMZLVAL);
	/*
	if ((PageLogicObj.m_UPMYF_Val == "")||(PageLogicObj.m_UPMYF_Val == 0)){
		PageLogicObj.m_UPMYFLEVEL.disable();
		$("#UPMYFVAL").attr("disabled",true);
	}
	if ((PageLogicObj.m_UPMZL_Val == "")||(PageLogicObj.m_UPMZL_Val == 0)){
		PageLogicObj.m_UPMZLLEVEL.disable();
		$("#UPMZLVAL").attr("disabled",true);
	}
	*/
}
function InitEasyUITool () {
	$.extend($.fn.validatebox.defaults.rules, {   
		gtnums: {   
			validator: function(value,param){
				return value > param[0];   
			},   
			message: '��ֵ�������{0}'
		}   
	});  
}
//
function InitData(inHosp) {
	//ͳһ���ùȸ�ģʽ
	var isIE = 2	//(window.ActiveXObject || "ActiveXObject" in window)?"1":"2";
	if (!inHosp) return false;
	var inHosp = inHosp||session['LOGON.HOSPID'];
	var myXml = $.cm({
		ClassName:"DHCAnt.KSS.Config.BSNormal",
		MethodName:"GetBSNormalSetting",
		isIE:isIE,
		inHosp:inHosp,
		dataType:"text"
	},false); 
	if (myXml!=""){
		//alert(myXml);
		SetInfoByXML(myXml,isIE);
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
			if (myItemName == "UPMYFVAL") {
				PageLogicObj.m_UPMYFVAL = myItemValue;
			}
			if (myItemName == "UPMZLVAL") {
				PageLogicObj.m_UPMZLVAL = myItemValue;
			}
			var _$id=$("#" + myItemName);
			if (_$id.length>0){
				if (_$id.hasClass("hisui-combobox")){
					//_$id.combobox("setValue",myItemValue);
					if (myItemName == "UPMYFLEVEL") {
						PageLogicObj.m_UPMYFVAL = jsonData[0]["UPMYFVAL"];
					}
					if (myItemName == "UPMZLLEVEL") {
						PageLogicObj.m_UPMZLVAL = jsonData[0]["UPMZLVAL"];
					}
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
					if ((myItemValue=="UPMYFVAL")||(myItemValue=="UPMZLVAL")) {
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
					
					
				} else {
					_$id.val(myItemValue);
				}
			}
		}
		delete(xmlDoc);
	} else {
		var jsonData = $.parseJSON(XMLStr);
		//console.log(jsonData)
		var myparseinfo = ServerObj.BSNoramlEntity;
		var myary = myparseinfo.split("^");
		for (var myIdx=1; myIdx<myary.length; myIdx++){
			var cid = myary[myIdx];
			var _$id=$("#"+cid);
			var myItemValue = jsonData[0][cid];
			//console.log(cid + "" + myItemValue)
			if (cid == "UPMYF") {
				PageLogicObj.m_UPMYF_Val = myItemValue;
			}
			if (cid == "UPMZL") {
				PageLogicObj.m_UPMZL_Val = myItemValue;
			}
			if (cid == "UPMYFVAL") {
				PageLogicObj.m_UPMYFVAL = myItemValue;
			}
			if (cid == "UPMZLVAL") {
				PageLogicObj.m_UPMZLVAL = myItemValue;
			}
			
			
			if (_$id.hasClass("hisui-combobox")){
					if (cid == "UPMYFLEVEL") {
						PageLogicObj.m_UPMYFVAL = jsonData[0]["UPMYFVAL"];
					}
					if (cid == "UPMZLLEVEL") {
						PageLogicObj.m_UPMZLVAL = jsonData[0]["UPMZLVAL"];
					}
					//console.log("myItemValue: "+myItemValue+"cid: "+cid)
					//_$id.combobox("select",myItemValue);
					
					if (myItemValue!="") {
						_$id.combobox("select",myItemValue);
					} else {
						_$id.combobox("setValue",myItemValue);
					}
					
					
			}else if(_$id.hasClass("hisui-checkbox")){
				if ((myItemValue=="Y")||(myItemValue=="1")){
					_$id.checkbox('check');
				}else{
					_$id.checkbox('uncheck');
				}
			} else if (_$id.hasClass("radiogroup")) {
				_$id.find("input[value='"+ myItemValue +"']").radio('check');
			} else if (_$id.hasClass("hisui-numberspinner")) {
				_$id.numberspinner("setValue",myItemValue);
			} else if (_$id.hasClass("multiple")) {
				if (myItemValue == "") {
					continue;
				}
				if ((myItemValue=="UPMYFVAL")||(myItemValue=="UPMZLVAL")) {
					continue;
				}
				var size = $("#" + cid + " option").size();
				if (size > 0) {
					$.each($("#" + cid + " option"), function(i,own){
						//ARCICRowId + ">" + n.ARCICDesc
						$(this).removeProp("selected")
						var cValue = $(this).attr("value");
						if ((","+myItemValue+",").indexOf(","+cValue+",")>=0) {
							//$(this).attr("selected",true);
							$(this).prop("selected", 'selected')
						}
					})
				}	   
				
				
			} else {
				_$id.val(myItemValue);
			}
			
		}
	}
	
}

//
function SaveBSNormal() {
	var InHosp = PageLogicObj.m_Hosp.getValue()||"";
	if (InHosp=="") {
		$.messager.alert("��ʾ", "����ѡ��Ժ����", "warning");
		return false;
	}
	var BSNoramlXML = GetBSNormalInfo();
	var passFlag = ValidateData();
	if (!passFlag) {
		return false;
	}
	var result = $.cm({ 
		ClassName:"DHCAnt.KSS.Config.BSNormal",
		MethodName:"DBSave",
		InHosp:InHosp,
		dataType:"text",
		BSNoramlXML:BSNoramlXML
	},false);
	if (result != 0) {
		$.messager.alert("��ʾ", "����ʧ��, "+ result, "error");
		return false;
	}
	InitData(InHosp);
	$.messager.alert("��ʾ", "����ɹ�", "info");
	return false;		
}

function ValidateData() {
	var yfDays = $("#YFDRUGTIME").val();
	if (yfDays <=0 ) {
		$.messager.alert("��ʾ", "Ԥ�������������0��", "warning");
		return false
	}
	return true;
}
function GetBSNormalInfo(){
	var myxml = "";
	var myparseinfo = ServerObj.BSNoramlEntity;
	var myxml = GetEntityClassInfoToXML(myparseinfo)
	return myxml;
}

function GetEntityClassInfoToXML(ParseInfo) {
	var myxmlstr="";
	try{
		var myary=ParseInfo.split("^");
		var xmlobj=new XMLWriter();
		xmlobj.BeginNode(myary[0]);
		for(var myIdx=1;myIdx<myary.length;myIdx++){
			xmlobj.BeginNode(myary[myIdx]);
			var cid = myary[myIdx];
			var _$id=$("#"+myary[myIdx]);
			if (_$id.length==0){
				var node=myary[myIdx];
				var Len=node.length-2;
				var id=node.substring(0,Len);
				if ($("#"+id).length>0){
					if ($("#"+id).hasClass("hisui-combobox")){
						var myval=$("#"+id).combobox("getValue");
					}else{
						var myval=$("#"+id).val();
					}
			    }
			} else {
				if (_$id.hasClass("hisui-combobox")){
					var myval=_$id.combobox("getValue");
				} else if(_$id.hasClass("hisui-checkbox")){
					var myval="0";
					if (_$id.checkbox('getValue')) myval="1";
				} else if (_$id.hasClass("multiple")) {
					var myval = "";
					var size = $("#" + cid + " option").size();
					if (size > 0) {
						$.each($("#" + cid + " option:selected"), function(i,own){
							//console.log(own)	//<option value="1">��ҩƬ��</option>
							var cvalue = $(own).val();	
							var ctext = $(own).text();
							
							if (myval == "") myval = cvalue
							else myval = myval + "," + cvalue
						})
						//DataList=DataList+String.fromCharCode(2)+param2+String.fromCharCode(1)+CatIDStr
					}	   
					
				} else if (_$id.hasClass("radiogroup")) {
					var myval = _$id.find("input[type='radio']:checked").val();
				} else {
					var myval=_$id.val();
				}
			}
			xmlobj.WriteString(myval);
			xmlobj.EndNode();
		}
		xmlobj.Close();
		myxmlstr = xmlobj.ToString();
	}catch(Err){
		$.messager.alert("��ʾ","Error: " + Err.description);
	}	
	return myxmlstr;
}

function InitCombox () {
	//Ժ��
	/* PageLogicObj.m_Hosp = $HUI.combobox("#i-hosp", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.Authority&QueryName=QryHosp&ResultSetType=array",
		valueField:'id',
		textField:'text',
		blurValidValue:true,
		onSelect:function(record) {
			InitData(record.id);
		}
		
	});	 */
	
	PageLogicObj.m_SAMEKSSONCE = $HUI.combobox("#SAMEKSSONCE", {
		valueField:'id',
		textField:'text',
		data:[
			{id:'SAMEKSS',text:'���ݿ���ҩ�Ｖ���ж�'},
			{id:'COMMONNAME',text:'����ͨ�������ж�'},
			{id:'WHONET',text:'����WHONET���ж�'}
		]
	});
	PageLogicObj.m_EOE = $HUI.combobox("#EOE", {
		valueField:'id',
		textField:'text',
		data:[
			{id:'1',text:'���Ƶ����ˣ�������ҩƷ'},
			{id:'2',text:'���Ƶ��˺;���ҩƷ'}
		]
	});	
	PageLogicObj.m_CONDEPNUM = $HUI.combobox("#CONDEPNUM", {
		valueField:'id',
		textField:'text',
		data:[
			{id:'1',text:'1��'},
			{id:'2',text:'2��'},
			{id:'3',text:'3��'}
		]
	});	
	
	/* PageLogicObj.m_DEFAULTCONDEP = $HUI.combobox("#DEFAULTCONDEP", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.Authority&QueryName=QryGetdep&InHosp="+GetHosp()+"&ResultSetType=array",
		valueField:'id',
		textField:'text',
		mode: "local",
		blurValidValue:true,
		filter: function(q, row){
			var ops = $(this).combobox('options');  
			var mCode = false;
			if (row.code) {
				mCode = row.code.toUpperCase().indexOf(q.toUpperCase()) >= 0
			}
			var mValue = row[ops.textField].indexOf(q) >= 0;
			return mCode||mValue;  
		},
		onSelect:function(record) {
			PageLogicObj.m_DEFAULTCONDOC.setValue("");
			var locid = PageLogicObj.m_DEFAULTCONDEP.getValue()||""		//record.id;
			var url = $URL+"?ClassName=DHCAnt.KSS.Config.Authority&QueryName=QryDoctor&depid="+locid+"&ctcarptype=&docFlag=&ResultSetType=array";
			PageLogicObj.m_DEFAULTCONDOC.reload(url);
		},
		onHidePanel:function() {
			var locid = PageLogicObj.m_DEFAULTCONDEP.getValue()||"";
			if (locid == "") {
				PageLogicObj.m_DEFAULTCONDOC.setValue("");
				var url = $URL+"?ClassName=DHCAnt.KSS.Config.Authority&QueryName=QryDoctor&depid=&ctcarptype=&docFlag=1&ResultSetType=array";
				PageLogicObj.m_DEFAULTCONDOC.reload(url);
			}
		}
		
	});	 
	
	PageLogicObj.m_DEFAULTCONDOC = $HUI.combobox("#DEFAULTCONDOC", {
		url:$URL+"?ClassName=DHCAnt.KSS.Config.Authority&QueryName=QryDoctor&depid=&ctcarptype=&docFlag=1&ResultSetType=array",
		valueField:'id',
		textField:'text',
		blurValidValue:true,
		onSelect:function(record) {
			var locid = PageLogicObj.m_DEFAULTCONDEP.getValue()||"";
			if (locid == "") {
				$.messager.alert("��ʾ","����ѡ�����","warning");
				PageLogicObj.m_DEFAULTCONDOC.setValue("");
				return false;
			}
		}
		
	});	
	*/
	PageLogicObj.m_DOCAUTHNUM = $HUI.combobox("#DOCAUTHNUM", {
		valueField:'id',
		textField:'text',
		data:[
			{id:'1',text:'1��'},
			{id:'3',text:'3��'},
			{id:'9',text:'9��'}
		]
	});
	
	PageLogicObj.m_MCQMX = $HUI.combobox("#MCQMX", {
		valueField:'id',
		textField:'text',
		data:[
			//{id:'1',text:'��׼ģʽ'},
			{id:'2',text:'��Ŀģʽ'}
		]
	});
	
	PageLogicObj.m_LABWAY = $HUI.combobox("#LABWAY", {
		valueField:'id',
		textField:'text',
		data:[
			{id:'LABLABOECATE',text:'ҽ�����෽ʽ'},
			{id:'LABARCIM',text:'ҽ���ʽ'}
		]
	});	
	
	//Ԥ������
	PageLogicObj.m_UPMYF = $HUI.combobox("#UPMYF", {
		valueField:'id',
		textField:'text',
		data:[
			{id:'1',text:'�������'},
			{id:'2',text:'�������'},
			{id:'0',text:'������'}
		],
		onSelect: function (record) {
			if (record.id==0) {
				PageLogicObj.m_UPMYFLEVEL.disable();
				$("#UPMYFVAL").attr("disabled",true);
			}else {
				PageLogicObj.m_UPMYFLEVEL.enable();
				$("#UPMYFVAL").removeAttr("disabled",true);
			}
			
		}
	});
	
	//���ƿ���
	PageLogicObj.m_UPMZL = $HUI.combobox("#UPMZL", {
		valueField:'id',
		textField:'text',
		data:[
			{id:'1',text:'�������'},
			{id:'2',text:'�������'},
			{id:'0',text:'������'}
		],
		onSelect: function (record) {
			if (record.id==0) {
				PageLogicObj.m_UPMZLLEVEL.disable();
				$("#UPMZLVAL").attr("disabled",true);
			}else {
				PageLogicObj.m_UPMZLLEVEL.enable();
				$("#UPMZLVAL").removeAttr("disabled",true);
			}
			
		}
	});
	
	PageLogicObj.m_UPMYFLEVEL = $HUI.combobox("#UPMYFLEVEL", {
		valueField:'id',
		textField:'text',
		data:[
			{id:'OBJ',text:'ʹ��Ŀ�Ĵ���'},
			{id:'ITEM',text:'ʹ��Ŀ������'},
			{id:'USE',text:'ʹ��Ŀ��'}
		],
		onSelect: function (record) {
			var upmYF = $("#UPMYFLEVEL").combobox("getValue")||"";
			LoadMultipleData("UPMYFVAL", "UPMYF", upmYF);
			setMulitData("UPMYFVAL", PageLogicObj.m_UPMYFVAL)
		}
	});
	
	PageLogicObj.m_UPMZLLEVEL = $HUI.combobox("#UPMZLLEVEL", {
		valueField:'id',
		textField:'text',
		data:[
			{id:'OBJ',text:'ʹ��Ŀ�Ĵ���'},
			{id:'ITEM',text:'ʹ��Ŀ������'},
			{id:'USE',text:'ʹ��Ŀ��'}
		],
		onSelect: function (record) {
			var upmZL = $("#UPMZLLEVEL").combobox("getValue")||"";
			LoadMultipleData("UPMZLVAL", "UPMZL", upmZL);
			setMulitData("UPMZLVAL", PageLogicObj.m_UPMZLVAL)
		}
	});
	
	$("#EMNUM").numberspinner("disable");
	PageLogicObj.m_EMLEVEL = $HUI.combobox("#EMLEVEL", {
		valueField:'id',
		textField:'text',
		data:[
			{id:'1',text:'ͬһҩƷ + ҽ��'},
			{id:'2',text:'ͬһҩƷ + ����'},
			{id:'3',text:'����ҩƷ + ҽ��'},
			{id:'4',text:'����ҩƷ + ����'}
		],
		onSelect: function (record) {
			$("#EMNUM").numberspinner("enable");
		},
		onHidePanel:function() {
			var cVal = PageLogicObj.m_EMLEVEL.getValue()||"";
			if (cVal == "") {
				$("#EMNUM").numberspinner("setValue","");
				$("#EMNUM").numberspinner("disable");
			}
		}
	});
	
	PageLogicObj.m_TWOAPP = $HUI.combobox("#TWOAPP", {
		valueField:'id',
		textField:'text',
		data:[
			{id:'1',text:'ҽ����'},
			{id:'2',text:'ͨ����'}
		]
	});
	
}

function setMulitData(myItemName, myItemValue) {
	//alert(myItemName + ": " + myItemValue)
	var size = $("#" + myItemName + " option").size();
	if (size > 0) {
		$.each($("#" + myItemName + " option"), function(i,own){
			var cValue = $(this).attr("value");
			
			if ((","+myItemValue+",").indexOf(","+cValue+",")>=0) {
				$(this).attr("selected",true);
			}
		})
	}	   
}

function autoFit() {
	//https://www.cnblogs.com/goloving/p/7113567.html
	var docW = $(document).width(); 
	var winW = $(window).width(); //$(document.body).width()
	var panelW = Math.floor((winW-50)*0.33);
	$(".c-panel").css("width",panelW);
	var PW = $(".c-panel").outerWidth();
	var PH = $(".c-panel").height();
	$('.c-padding').panel("resize",{
		width:PW,
		height:PH
	});
}

function LoadMultipleData(param1,param2,param3,InHosp){
	param3 = param3||"";
	InHosp = InHosp||"";
	var MultipleOBJ = $.cm({ 
		ClassName:"DHCAnt.KSS.Config.BSNormal", 
		QueryName:"QryMultipleData",
		MType:param2,
		ParID:param3,
		InHosp:InHosp,
		rows:99999
	},false);
	
	var vlist = ""; 
	var selectlist = "";
	jQuery.each(MultipleOBJ.rows, function(i, n) { 
		vlist += "<option value=" + n.id + ">" + n.desc + "</option>"; 
   });
   $("#"+param1+"").empty();
   $("#"+param1+"").append(vlist); 
}

function clearData() {
	$(".hisui-checkbox").checkbox("uncheck");
}

function InitHospList() {
	PageLogicObj.m_Hosp = GenHospComp("Ant_Config_Func_BaseSet");
	PageLogicObj.m_Hosp.jdata.options.onSelect = function(rowIndex,data){
		LoadMultipleData("LABOECATE", "OEItemCat","",data.HOSPRowId);
		LoadMultipleData("OETYPE", "OEType","",data.HOSPRowId);
		InitDeafultDep(data.HOSPRowId);
		InitData(data.HOSPRowId);
	}
	PageLogicObj.m_Hosp.jdata.options.onLoadSuccess= function(data){
		LoadMultipleData("LABOECATE", "OEItemCat","",session['LOGON.HOSPID']);
		LoadMultipleData("OETYPE", "OEType","",session['LOGON.HOSPID']);
		InitDeafultDep(session['LOGON.HOSPID']);
		InitData(session['LOGON.HOSPID']);
	}
}

function GetHosp() {
	if (PageLogicObj.m_Hosp == "") {
		return session['LOGON.HOSPID'];
	}
	var hospValue = PageLogicObj.m_Hosp.getValue()||""
	if (hospValue == "") {
		return session['LOGON.HOSPID'];
	}
	return hospValue;
	
	
}

function InitDeafultDep(inHosp) {
	inHosp = inHosp||"";
	if (inHosp == "") inHosp = GetHosp();
	PageLogicObj.m_DEFAULTCONDEP = $HUI.combobox("#DEFAULTCONDEP", {
		//url:$URL+"?ClassName=DHCAnt.KSS.Config.Authority&QueryName=QryGetdep&InHosp="+inHosp+"&ResultSetType=array",
		url:$URL+"?ClassName=DHCAnt.KSS.Config.BaseData&QueryName=QryConLoc&InHosp="+inHosp+"&ResultSetType=array",
		valueField:'id',
		textField:'text',
		mode: "local",
		blurValidValue:true,
		filter: function(q, row){
			var ops = $(this).combobox('options');  
			var mCode = false;
			if (row.code) {
				mCode = row.code.toUpperCase().indexOf(q.toUpperCase()) >= 0
			}
			var mValue = row[ops.textField].indexOf(q) >= 0;
			return mCode||mValue;  
		},
		onSelect:function(record) {
			PageLogicObj.m_DEFAULTCONDOC.setValue("");
			var locid = PageLogicObj.m_DEFAULTCONDEP.getValue()||""		//record.id;
			//var url = $URL+"?ClassName=DHCAnt.KSS.Config.Authority&QueryName=QryDoctor&depid="+locid+"&ctcarptype=&docFlag=&ResultSetType=array";
			var url = $URL+"?ClassName=DHCAnt.KSS.MainInterface&QueryName=QryConsultationDoc&ctLocId="+locid+"&ResultSetType=array";
			PageLogicObj.m_DEFAULTCONDOC.reload(url);
		},
		onHidePanel:function() {
			var locid = PageLogicObj.m_DEFAULTCONDEP.getValue()||"";
			if (locid == "") {
				PageLogicObj.m_DEFAULTCONDOC.setValue("");
				//var url = $URL+"?ClassName=DHCAnt.KSS.Config.Authority&QueryName=QryDoctor&depid=&ctcarptype=&docFlag=1&ResultSetType=array";
				var url = $URL+"?ClassName=DHCAnt.KSS.MainInterface&QueryName=QryConsultationDoc&ctLocId=&ResultSetType=array";
				PageLogicObj.m_DEFAULTCONDOC.reload(url);
			}
		}
		
	});	
	
	PageLogicObj.m_DEFAULTCONDOC = $HUI.combobox("#DEFAULTCONDOC", {
		//url:$URL+"?ClassName=DHCAnt.KSS.Config.Authority&QueryName=QryDoctor&depid=&ctcarptype=&docFlag=1&ResultSetType=array",
		url:$URL+"?ClassName=DHCAnt.KSS.MainInterface&QueryName=QryConsultationDoc&ctLocId=&ResultSetType=array",
		valueField:'id',
		textField:'text',
		blurValidValue:true,
		onSelect:function(record) {
			var locid = PageLogicObj.m_DEFAULTCONDEP.getValue()||"";
			if (locid == "") {
				$.messager.alert("��ʾ","����ѡ�����","warning");
				PageLogicObj.m_DEFAULTCONDOC.setValue("");
				return false;
			}
		}
		
	});	
	
}

