/**
 * groupauth.hui.js ҽ��վ��ȫ�鹦����Ȩ
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2018-08-10
 * 
 * ע��˵��
 * TABLE: 
 */
 
//ҳ��ȫ�ֱ���
var PageLogicObj = {
	m_LGird : "",
	m_MenuType: "",
	m_MenuGrid: "",
	m_GoupId: "",
	m_MenuWin: "",
	ordClass:"web.DHCDocConfig", //DHCDoc.DHCDocConfig.CommonFunction
	ordGetMethod:"GetConfigNode1",
	ordSaveMethod:"SaveConfig1",
	
	GroupId:"",
	LocId:"",
	InValue:""
}
$(function(){
	//��ʼ��ҽԺ
	var hospComp = GenHospComp("Doc_Config_GroupAuth");
	hospComp.jdata.options.onSelect = function(e,t){
		PageLogicObj.m_GoupId="";
		$("#i-tab").tabs('select',0);
		Init();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		//��ʼ��
		Init();
	}
	//�¼���ʼ��
	InitEvent();
	//ҳ��Ԫ�س�ʼ��
	//PageHandle();
})

function Init(){
	PageLogicObj.m_LGird = InitLGrid();
	//LoadDepConfig();
	LoadDocConfig();
	LoadOrdConfig();
	LoadYSZConfig();
	//LoadGHConfig();
	//LoadZLConfig();
	LoadMenuAuthConfig();
	
}
function InitEvent(){
	$("#i-find").click(findConfig);
	$("#menu-find").click(findMenuConfig);
	$("#i-desc").keydown(function (event) {
		if (event.which == 13 || event.which == 9) {
			findConfig();
		}
	});
	$("#LocDesc").keydown(function(e){
		if(e.which == 13 || event.which == 9){
			LocDesckeydownHanlder()
		}
	})
	$("#DocDesc").keydown(function(e){
		if(e.which == 13 || event.which == 9){
			DocDesckeydownHanlder()
		}
	})
	$('#i-tab').tabs({
	  onSelect: function(title,index){
		  if (PageLogicObj.m_GoupId!=""){
			  if (title=="ҽ��¼����������"){
				  LoadNewZLConfig(PageLogicObj.m_GoupId);
			  }
		  }else{
			  if (title=="ҽ��¼����������"){
				  $("#i-show").removeClass("c-hidden");
				  $("#i-newZL").addClass("c-hidden");
			  }
		  }
	  }
   });
	//$("#i-add").click(function(){opDialog("add")});
	$(document.body).bind("keydown",BodykeydownHandler)
}

function InitMenuEvent(){
	$("#menu-edit").click(menuDiag);
	//$("#menu-delete").click(deleteMenu);
}

function PageHandle(){
	//
}

//1��������������
function LoadDepConfig(groupId) {
	$("#depUL").empty();
	$HUI.panel("#depPanel",{
		title:"�Һ�����",
		fit:true,
		collapsible:false,
		tools:[{ 
			iconCls:'icon-w-save',
			 handler:function(){
				var inStr = "";   
				$("#depUL>li.active").each(function () {
					if (inStr == "") {
						inStr = $(this).attr("value");
					} else {
						inStr = inStr + "!" + $(this).attr("value");
					}
				});
				if ((!groupId)||(groupId=="")) {
					return false;
				}
				var RoomStr = tkMakeServerCall("web.DHCOPRegConfig","SaveGroupRegRoom",groupId,inStr);
				if (RoomStr == 0 ) {
					$.messager.popover({msg: '����ɹ���',type:'success'});
				}
				
			}
		}]
	});
	if ((!groupId)||(groupId=="")) {
		$("#depUL").append("<li value='0' class='tip'>������ѡ������ȫ�飡</li>");
		return false;
	} 
	var RoomStr = tkMakeServerCall("web.DHCOPRegConfig","GetRoomStr");
	var GroupRegRoomStr = tkMakeServerCall("web.DHCOPRegConfig","GetGroupRegRoom",groupId);
	if (GroupRegRoomStr != "" ) {
		GroupRegRoomStr = "!" + GroupRegRoomStr + "!" ;
	}
	if (RoomStr!=""){
		var RoomArr=RoomStr.split("^")
		for(var i=0; i< RoomArr.length; i++) {
			var curRecord = RoomArr[i].split(String.fromCharCode(1));
			$("#depUL").append("<li value="+curRecord[0]+">"+curRecord[1]+"</li>");
		}
	}
	$("#depUL>li").each(function () {
		var cid = $(this).attr("value");
		var bol = (GroupRegRoomStr.indexOf("!"+ cid + "!") >=0)&&(GroupRegRoomStr != "") ; 
		if (bol) {
			$(this).addClass('active');
		} else {
			$(this).removeClass('active');
		}
	});
	
	$("#depUL>li").on('click', function(){
		if ($(this).hasClass("active")) {
			$(this).removeClass('active');
		} else {
			$(this).addClass('active');
		}
		
	})
				
}

//2������ҽ����������
//2.1�����ؿ���
function LoadDocConfig(groupId,LocDesc) {
	$("#docLocUL").empty();
	
	if(!LocDesc) LocDesc=""
	var inStr = "";
	var H_docPanel = $HUI.panel("#docPanel",{
		title:"ҽ������",
		fit:true,
		collapsible:false
	});
	//H_docPanel.maximize();
	LoadDocConfigInfo(groupId);
	if ((!groupId)||(groupId=="")) {
		$("#docLocUL").append("<li value='0' class='tip'>������ѡ��ȫ�飡</li>");
		return false;
	}
	PageLogicObj.GroupId=groupId
	var LocStr = tkMakeServerCall("DHCDoc.DHCDocConfig.CommonFunction","GetGroupAdmLoc",groupId,LocDesc,$HUI.combogrid('#_HospList').getValue());
	if(LocStr=="") return false;
	var LocArr=LocStr.split("^")
	for(var i=0; i< LocArr.length; i++) {
		var curRecord = LocArr[i].split("&");
		var desc = curRecord[1];
		var valueArr = curRecord[0].split(String.fromCharCode(1));
		var curLocid = valueArr[0];
		var curValue = "!" + valueArr[1] + "!";
		$("#docLocUL").append("<li value='" + curValue + "' loc='" + curLocid + "' >"+desc+"</li>");
	}
	/*
	$("#depUL>li").each(function () {
		var cid = $(this).attr("value");
		var bol = (GroupRegRoomStr.indexOf("!"+ cid + "!") >=0)&&(GroupRegRoomStr != "") ; 
		if (bol) {
			$(this).addClass('active');
		} else {
			$(this).removeClass('active');
		}
	});
	*/
	$("#docLocUL>li").on('click', function(){
		var id = $(this).attr("loc");
		var value = $(this).attr("value");
		$(this).addClass('active');
		$("#docLocUL>li").each(function () {
			var cid = $(this).attr("loc");
			if (cid!=id) {
				$(this).removeClass('active');
			}
		});
		LoadDocConfigInfo(groupId,id,value);
	})
	
				
}

//2������ҽ����������
//2.2������ҽ��
function LoadDocConfigInfo(groupId,locId,inValue,DocDesc) {
	$("#docUL").empty();
	//alert(inValue);
	if(!DocDesc) DocDesc=""
	$HUI.panel("#docPanel2",{
		title:"�Һ�ҽ��",
		fit:true,
		border:true,
		collapsible:false,
		tools:[{ 
			iconCls:'icon-w-save',
			 handler:function(){ 
				var inStr="",comStr="";
				if ((!locId)||(locId=="")) {
					return false;
				}
				
				if ((inValue == "!!")&&($("#docUL>li.active").length==0)) {	//ԭ���ÿ���ʲô��û��,����ʲô��ûѡ
					$.messager.alert("��ʾ", "��û�������޸�!", 'info');
					return false;
				}
				$("#docUL>li.active").each(function () {
					var curLiValue = $(this).attr("value");
					var bol = inValue.indexOf("!" + curLiValue + "!") >= 0
					if (comStr == "") {
						comStr = curLiValue;
					} else {
						comStr = comStr + "!" + curLiValue;
					}
					if (inStr == "") {
						//if (bol) inStr = "-^" + curLiValue;
						//else  inStr = "+^" + curLiValue;
						if (!bol) inStr = curLiValue;
					} else {
						//if (bol) inStr = inStr + "!" + "-^" + curLiValue;
						//else  inStr = inStr + "!" + "+^" + curLiValue;
						if (!bol) inStr = inStr + "!" + curLiValue;
					}
					
				});
				comStr = "!" + comStr + "!";
				if (comStr == inValue) {	
					$.messager.alert("��ʾ", "��û�������޸�!", 'info');
					return false;
				}
				//�ҳ�inArr�в�����ѡ�����ֵ
				inArr = inValue.split("!");
				var subStr = "";
				for (var i=0; i< inArr.length; i++) {
					var curVal = inArr[i];
					if (curVal=="") continue;
					if (comStr.indexOf("!"+ curVal + "!")<0) {
						if (subStr == "") subStr = curVal;
						else  subStr = subStr + "!" + curVal;
					}
				}
				var RoomStr = tkMakeServerCall("DHCDoc.DHCDocConfig.CommonFunction","SaveGroupRes",groupId,inStr,subStr);
				if (RoomStr == 0 ) {
					$.messager.popover({msg: '����ɹ���',type:'success'});
					LoadDocConfig(groupId);
					$("#docLocUL li[loc='" + locId + "']").trigger("click");
				}
				
			}
		}]
	});
	
	if ((!locId)||(locId=="")) {
		$("#docUL").append("<li value='0' class='tip'>������ѡ����ң�</li>");
		return false;
	}
	PageLogicObj.LocId=locId
	var DocStr = tkMakeServerCall("DHCDoc.DHCDocConfig.CommonFunction","GetDocByLoc",locId,DocDesc,$HUI.combogrid('#_HospList').getValue());
	if(DocStr=="") return false;
	var DocArr=DocStr.split("^")
	for(var i=0; i< DocArr.length; i++) {
		var curRecord = DocArr[i].split("!");
		var HiddenType=curRecord[2];
		if (HiddenType=="Y"){
			var tmp="<li value="+curRecord[0]+" style='display:none;'>"+curRecord[1]+"</li>"
		}else{
			var tmp="<li value="+curRecord[0]+">"+curRecord[1]+"</li>"
		}
		$("#docUL").append(tmp);
	}
	
	$("#docUL>li").on('click', function(){
		var id = $(this).attr("value");
		if ($(this).hasClass("active")) {
			$(this).removeClass('active');
		} else {
			$(this).addClass('active');
		}
	})
	
	var compareLocId = inValue;
	$("#docUL>li").each(function () {
		var cid = $(this).attr("value");
		cid = "!" + cid + "!";
		if (compareLocId.indexOf(cid) >= 0) {
			if (!$(this).hasClass('active')) {
				$(this).addClass('active');
			}
		} else {
			$(this).removeClass('active');
		}
	});
				
}

//3������ҽ��¼������
function LoadOrdConfig(groupId) {
	//$("#ordUL").empty();
	
	//var inStr = "";
	var H_ordPanel = $HUI.panel("#ordPanel",{
		title:"ҽ��¼�밲ȫ��Ȩ��",
		fit:true,
		collapsible:false,
		tools:[{ 
			iconCls:'icon-w-save',
			 handler:function(){   
				if ((!groupId)||(groupId=="")) {
					return false;
				}
				var blmode = treemain = oneprint = daylimit = orderlimit = 0;
				if ($("#ord-blmode").checkbox("getValue")) blmode = 1;
				if ($("#ord-treemain").checkbox("getValue")) treemain=1;
				//if ($("#ord-oneprint").checkbox("getValue")) oneprint=1;
				if ($("#ord-daylimit").checkbox("getValue")) daylimit=1;
				if ($("#ord-orderlimit").checkbox("getValue")) orderlimit=1;
				
				var rtn = tkMakeServerCall(PageLogicObj.ordClass, PageLogicObj.ordSaveMethod, "SupplementMode", groupId,blmode,GetHospId());
				rtn = tkMakeServerCall(PageLogicObj.ordClass, PageLogicObj.ordSaveMethod, "NoAdmValidDaysLimit", groupId,daylimit,GetHospId());
				rtn = tkMakeServerCall(PageLogicObj.ordClass, PageLogicObj.ordSaveMethod, "TreeMaintain", groupId,treemain,GetHospId());
				//rtn = tkMakeServerCall(PageLogicObj.ordClass, PageLogicObj.ordSaveMethod, "ClickPrnConfig", groupId,oneprint);
				rtn = tkMakeServerCall(PageLogicObj.ordClass, PageLogicObj.ordSaveMethod, "OrderLimit", groupId,orderlimit,GetHospId());
				if (rtn == 0 ) {
					$.messager.popover({msg: '����ɹ���',type:'success'});
				}
				
			}
		}]
	});
	if ($("#i-ord-tip").length>0) {
		$("#i-ord-tip").remove();
	}
	if ((!groupId)||(groupId=="")) {
		$("#ordUL").append("<li id='i-ord-tip' value='0' class='tip'>������ѡ��ȫ�飡</li>");
		return false;
	}
	$("#ordUL>li").each(function () {
		var hasHidden = $(this).hasClass("c-hidden");
		if (hasHidden) {
			$(this).removeClass("c-hidden");
		} 
	});
	var _content = "<ul><li style='font-weight:bold'>ҽ����¼˵��</li>" + 
		"<li style='color:#008FF0;'>һ�����ҽ������</li>" + 
		"<li>1���������ظ�¼������ࡢ��ͬͨ������ҽ��</li>" +
		"<li>2���������һ����������õ�ҽ�����ﻼ��ͬһ�ξ��ﲻ�ܳ��������������סԺ����ͬһ�첻�ܳ�������</li>" +
		"<li>3��������ͬ��ҽ��?ȷ���Ƿ�Ҫ����</li>" + 
		"<li>4����ҩƷ���ظ�ҽ����ʾ���ظ�����걾��ʾ���ظ������ѿ�ҽ��(����)</li>" +
		"<li>5��סԺ��������Ѻ�����</li>"+
		"<li>6��ҽ������ʾǿ�Ʋ��������ڣ���ҽ��¼������Ϸ�����ʾ��Ϣ��</li>"+ 
		"<li style='color:#008FF0;'>����ҽ��������ҩ</li>" + 
		"<li>1���ܲ������������ҩ��ֻ�ܿ��Էѣ�</li>" + 
		"<li>2���Ѿ�������ͬ��ҽ�������Ƴ���,�������ٿ���</li>"+
		"<li>3���ز���Ŀ,�����ز������ڿ�ҽ����ҽ����Ӧ֢��ʾ������</li>" +
		"<li style='color:#008FF0;'>���������˰�ť�Ŀ���</li>" + 
		"<li>1���ٴ�·����顢Ѻ����</li>"
	$("#ord-info").popover({
		//title:'���ҽ���Ŀ���',
		//backdrop:true,
		content:_content
	});
	var TreeMaintain = tkMakeServerCall(PageLogicObj.ordClass,PageLogicObj.ordGetMethod,"TreeMaintain",groupId,GetHospId());
	//var ClickPrnConfig = tkMakeServerCall(PageLogicObj.ordClass,PageLogicObj.ordGetMethod,"ClickPrnConfig",groupId);
	//���ܾ�����Ч��������
	var NoAdmValidDaysLimit = tkMakeServerCall(PageLogicObj.ordClass,PageLogicObj.ordGetMethod,"NoAdmValidDaysLimit",groupId,GetHospId());
	//��¼ģʽ
	var SupplementMode = tkMakeServerCall(PageLogicObj.ordClass,PageLogicObj.ordGetMethod,"SupplementMode",groupId,GetHospId());
	//û����Ͽ��Կ�ҽ��
	var OrderLimit = tkMakeServerCall(PageLogicObj.ordClass,PageLogicObj.ordGetMethod,"OrderLimit",groupId,GetHospId());
	if (TreeMaintain == 1) $("#ord-treemain").checkbox("check");
	else $("#ord-treemain").checkbox("uncheck");
	
	//if (ClickPrnConfig == 1) $("#ord-oneprint").checkbox("check");
	//else $("#ord-oneprint").checkbox("uncheck");
	
	if (NoAdmValidDaysLimit == 1) $("#ord-daylimit").checkbox("check");
	else $("#ord-daylimit").checkbox("uncheck");
	
	if (SupplementMode == 1) $("#ord-blmode").checkbox("check");
	else $("#ord-blmode").checkbox("uncheck");
	
	if (OrderLimit == 1) $("#ord-orderlimit").checkbox("check");
	else $("#ord-orderlimit").checkbox("uncheck");
}

//4������ҽ��¼������
function LoadYSZConfig(groupId) {
	var H_yszPanel = $HUI.panel("#yszPanel",{
		title:"����ҽ��վ��ת����",
		fit:true,
		collapsible:false,
		tools:[{ 
			iconCls:'icon-w-save',
			 handler:function(){   
				if ((!groupId)||(groupId=="")) {
					return false;
				}
				var newzl = yszCase = 0;
				if ($("#ysz-newzl").checkbox("getValue")) newzl = 1;
				if ($("#ysz-case").checkbox("getValue")) yszCase = 1;
				var rtn = tkMakeServerCall(PageLogicObj.ordClass, PageLogicObj.ordSaveMethod, "OutDocEntryMTR", groupId,yszCase,GetHospId());
				rtn = tkMakeServerCall(PageLogicObj.ordClass, PageLogicObj.ordSaveMethod, "NewOutPatList", groupId,newzl,GetHospId());
				if (rtn == 0 ) {
					$.messager.popover({msg: '����ɹ���',type:'success'});
				}
				
			}
		}]
	});
	var H_yszPanel = $HUI.panel("#yszOutPatLPanel",{
		title:"����ҽ���б��Ѿ�������",
		fit:true,
		collapsible:false,
		tools:[{ 
			iconCls:'icon-w-save',
			 handler:function(){   
				if ((!groupId)||(groupId=="")) {
					return false;
				}
				var yszOutPatL = "";
				if ($("#yszOutPatL-seqno").radio("getValue")) yszOutPatL = "1";
				if ($("#yszOutPatL-ArriveTime").radio("getValue")) yszOutPatL = "2";
				var rtn = tkMakeServerCall(PageLogicObj.ordClass, PageLogicObj.ordSaveMethod, "OutPatListArrive", groupId,yszOutPatL,GetHospId());
				if (rtn == 0 ) {
					$.messager.popover({msg: '����ɹ���',type:'success'});
				}
				
			}
		}]
	});
	if ($("#i-ysz-tip").length>0) {
		$("#i-ysz-tip").remove();
	}
	if ($("#i-yszOutPatL-tip").length>0) {
		$("#i-yszOutPatL-tip").remove();
	}
	if ((!groupId)||(groupId=="")) {
		$("#yszUL").append("<li id='i-ysz-tip' value='0' class='tip'>������ѡ��ȫ�飡</li>");
		$("#yszOutPatLUL").append("<li id='i-yszOutPatL-tip' value='0' class='tip'>������ѡ��ȫ�飡</li>");
		return false;
	}
	$("#yszUL>li").each(function () {
		var hasHidden = $(this).hasClass("c-hidden");
		if (hasHidden) {
			$(this).removeClass("c-hidden");
		} 
	});
	$("#yszOutPatLUL>li").each(function () {
		var hasHidden = $(this).hasClass("c-hidden");
		if (hasHidden) {
			$(this).removeClass("c-hidden");
		} 
	});
	var yszCase = tkMakeServerCall(PageLogicObj.ordClass,PageLogicObj.ordGetMethod,"OutDocEntryMTR",groupId,GetHospId());
	var newzl = tkMakeServerCall(PageLogicObj.ordClass,PageLogicObj.ordGetMethod,"NewOutPatList",groupId,GetHospId());
	var OutPatListArrive=tkMakeServerCall(PageLogicObj.ordClass,PageLogicObj.ordGetMethod,"OutPatListArrive",groupId,GetHospId());
	//alert(yszCase + ": " + newzl);
	
	$("#ysz-case").checkbox({
		onChecked: function () {
			$("#ysz-newzl").checkbox("uncheck");
		}
	});
	
	$("#ysz-newzl").checkbox({
		onChecked: function () {
			$("#ysz-case").checkbox("uncheck");
		}
	});
	$("#yszOutPatL-seqno").radio({
		onChecked: function () {
			$("#yszOutPatL-ArriveTime").radio("uncheck");
		}
	});
	$("#yszOutPatL-ArriveTime").radio({
		onChecked: function () {
			$("#yszOutPatL-seqno").radio("uncheck");
		}
	});
	if (newzl == 1) $("#ysz-newzl").checkbox("check");
	else $("#ysz-newzl").checkbox("uncheck");
	
	if (yszCase == 1) $("#ysz-case").checkbox("check");
	else $("#ysz-case").checkbox("uncheck");
	if (OutPatListArrive==1){$("#yszOutPatL-seqno").radio("check");
	}else if(OutPatListArrive==2){$("#yszOutPatL-ArriveTime").radio("check");}
	
}

//5�����ض���ԤԼ�Һ�����
function LoadGHConfig(groupId) {
	$HUI.panel("#ghPanel",{
		title:"��������+ԤԼ�Һ�����",
		fit:true,
		collapsible:false,
		tools:[{ 
			iconCls:'icon-w-save',
			 handler:function(){   
				if ((!groupId)||(groupId=="")) {
					return false;
				}
				var newzl = yszCase = 0;
				if ($("#ysz-newzl").radio("getValue")) newzl = 1;
				if ($("#ysz-case").radio("getValue")) yszCase = 1;
				var rtn = tkMakeServerCall(PageLogicObj.ordClass, PageLogicObj.ordSaveMethod, "OutDocEntryMTR", groupId,yszCase,GetHospId());
				rtn = tkMakeServerCall(PageLogicObj.ordClass, PageLogicObj.ordSaveMethod, "NewOutPatList", groupId,newzl,GetHospId());
				if (rtn == 0 ) {
					$.messager.popover({msg: '����ɹ���',type:'success'});
				}
				
			}
		}]
	});
	
	if ((!groupId)||(groupId=="")) {
		$("#ghUL").append("<li id='i-card-tip' value='0' class='tip'>������ѡ��ȫ�飡</li>");
		return false;
	}
	if ($("#i-card-tip").length>0) {
		$("#i-card-tip").remove();
	}
	
	$("#ghUL>li").each(function () {
		var hasHidden = $(this).hasClass("c-hidden");
		if (hasHidden) {
			$(this).removeClass("c-hidden");
		} 
	});
	var _content = "<ul>" + 
		"<li style='color:#008FF0;'>һ��ʹ����֪</li>" + 
		"<li>1������Ϊ�Ƕ���ԤԼ�ҺŰ�ȫ��ά�������� </li>" +
		"<li>2��������˵����ο�������ԤԼ�ҺŽӿ�����˵���ĵ�.docx��</li></ul>"
	$("#gh-info").popover({
		content:_content
	});
}

//6������ҽ��¼����������
function LoadZLConfig(groupId) {
	$HUI.panel("#zlPanel",{
		title:"ҽ��¼��+�в�ҩ¼������",
		fit:true,
		collapsible:false,
		tools:[{ 
			iconCls:'icon-w-save',
			 handler:function(){ 
				var UserID=session['LOGON.USERID'];
				$("#fUIConfig").form("submit",{
					url : "oeorder.oplistcustom.new.request.csp?action=Config_Set&UserID="+UserID+"&GroupID="+groupId+"&LoginGroupRowId="+ServerObj.LoginGroupRowId ,
					onSubmit: function(param){
						//console.log(param);
						var patSearchDefCon=$('input:radio[name="PatFind"]:checked').val()
						if (patSearchDefCon==undefined) patSearchDefCon="";
						param.layoutConfig1=$("#layoutConfig1").radio('getValue')?true:false;
						param.layoutConfig2=$("#layoutConfig2").radio('getValue')?true:false;	
						param.OrderPriorConfig1=$("#OrderPriorConfig1").radio('getValue')?true:false;
						param.OrderPriorConfig2=$("#OrderPriorConfig2").radio('getValue')?true:false;	
						param.ShowList1=$("#ShowList1").radio('getValue')?true:false;
						param.ShowList2=$("#ShowList2").radio('getValue')?true:false;			
						param.DefaultExpendList=$("#DefaultExpendList").radio('getValue')?true:false;
						param.DefaultExpendTemplate=$("#DefaultExpendTemplate").radio('getValue')?true:false;
						param.BigFont=$("#BigFont").radio('getValue')?true:false;
						param.SmallFont=$("#SmallFont").radio('getValue')?true:false;
						param.ShowGridFootBar=$("#ShowGridFootBar").radio('getValue')?true:false;
						param.isEditCopyItem=$("#isEditCopyItem").checkbox('getValue')?true:false;
						param.DefaultCloseList=$("#DefaultCloseList").radio('getValue')?true:false;
						param.isSetTimeLog=$("#isSetTimeLog").checkbox('getValue')?true:false;
						param.PatSearchDefCon=patSearchDefCon;
						//param.OrdEntryScale=$("#OrdEntryScale").slider('getValue');
						param.DefaultPopTemplate=$("#DefaultPopTemplate").checkbox('getValue')?true:false;
						// �г�ҩ������
						param.ViewGroupSum_UserID=$("#ViewGroupSum_UserID").combobox("getValue"); 
						param.DefaultCMExpendTemplate=$("#DefaultCMExpendTempl").radio('getValue')?true:false;
						param.DefaultCMCloseTemplate=$("#DefaultCMCloseTempl").radio('getValue')?true:false;
					},
					success:function(data){
						var data = eval('(' + data + ')');
						if (data.success) {
							$.messager.alert("��ʾ",data.message,"info")		
						}
					}
				});
				
			}
		}]
	});
	
	if ((!groupId)||(groupId=="")) {
		$("#zlUL").append("<li id='i-zl-tip' value='0' class='tip'>������ѡ��ȫ�飡</li>");
		return false;
	}
	if ($("#i-zl-tip").length>0) {
		$("#i-zl-tip").remove();
	}
	
	$("#zlUL>li").each(function () {
		var hasHidden = $(this).hasClass("c-hidden");
		if (hasHidden) {
			$(this).removeClass("c-hidden");
		} 
	});
	
	//
	$HUI.combobox("#ViewGroupSum_UserID", {
		valueField: 'id',
		textField: 'text', 
		editable:false,
		data: [{"id":1,"text":1},{"id":2,"text":2},{"id":3,"text":3},{"id":4,"text":4}]
	});
	 
	var Node="UIConfigObj_Group";
	var SubNode=groupId;
	$.cm({
		ClassName:"web.DHCDocConfig",
		MethodName:"GetConfigNode1",
		Node:Node, SubNode:SubNode,
		dataType:"text"
	},function(UIConfigObj){
		if (UIConfigObj=="") var UIConfigObj="{}"
		var data = eval('(' + UIConfigObj + ')');
		$("#layoutConfig1").radio("setValue",data['layoutConfig1']);
		$("#layoutConfig2").radio("setValue",data['layoutConfig2']);
		$("#OrderPriorConfig1").radio("setValue",data['OrderPriorConfig1']);
		$("#OrderPriorConfig2").radio("setValue",data['OrderPriorConfig2']);
		$("#ShowList1").radio("setValue",data['ShowList1']);
		$("#ShowList2").radio("setValue",data['ShowList2']);
	  	$("#DefaultExpendList").radio("setValue",data['DefaultExpendList']);
	  	$("#DefaultExpendTemplate").radio("setValue",data['DefaultExpendTemplate']);
		$("#DefaultCloseList").radio("setValue",data['DefaultCloseList']);
	  	$("#BigFont").radio("setValue",data['BigFont']);
	  	$("#SmallFont").radio("setValue",data['SmallFont']);
	  	$("#ShowGridFootBar").radio("setValue",data['ShowGridFootBar']);
		$("#isEditCopyItem").checkbox("setValue",data['isEditCopyItem']);
		$("#isSetTimeLog").checkbox("setValue",data['isSetTimeLog']);
		//$("#OrdEntryScale").slider('setValue',data['OrdEntryScale']);
		$("#DefaultPopTemplate").checkbox('setValue',data['DefaultPopTemplate']);
		$("#DefaultCMExpendTempl").radio('setValue',data['DefaultCMExpendTemplate']);
		$("#DefaultCMCloseTempl").radio('setValue',data['DefaultCMCloseTemplate']);
	});
	var Node2="ViewGroupSum_Group";
	var SubNode2=groupId;
	$.cm({
		ClassName:"web.DHCDocConfig",
		MethodName:"GetConfigNode1",
		Node:Node2, SubNode:SubNode2,
		dataType:"text"
	},function(ViewGroupSumUserID){
		if (ViewGroupSumUserID=="") ViewGroupSumUserID=4;
		$("#ViewGroupSum_UserID").combobox("select",ViewGroupSumUserID);
	});
}

//7��������ҽ���˵�Ȩ�޷���
function LoadMenuAuthConfig (groupId) {
	if ((!groupId)||(groupId=="")) {
		//$("#menuPanel").removeClass("c-hidden");
		$("#menu-tip").removeClass("c-hidden");
		$("#menu-search").addClass("c-hidden");
		return false;
	} else {
		$("#menu-search").removeClass("c-hidden");
		$("#menu-tip").addClass("c-hidden");
		//$("#menuPanel").addClass("c-hidden");
		
		PageLogicObj.m_MenuType = $HUI.combobox("#menu-type", {
			url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=QryMenuType&parentNode=menuTreeRoot&groupid=" + groupId + "&ResultSetType=array",
			valueField:'code',
			textField:'desc',
			onSelect: function (rowIndex, rowData) {
				$("#menu-find").trigger("click");
			}
		});
		
		var columns = [[
			{field:'code',title:'����',width:100,hidden:true},
			{field:'desc',title:'Ȩ������',width:100},
			{field:'func',title:'������',width:100},
			{field:'showFunc',title:'��ʾ����',width:100},
			{field:'checkflag',title:'�Ƿ���ʾ',width:80,
				formatter:function(value,row,index){
					if (value == 1) {
						return "<span class='c-ok'>��</span>"
					} else {
						return "<span class='c-no'>��</span>"
					}
				}
			},
			{field:'id',title:'ID',width:60,hidden:true}
		]];
		PageLogicObj.m_MenuGrid = $HUI.datagrid("#menu-grid", {
			fit : true,
			border : false,
			striped : true,
			singleSelect : true,
			fitColumns : true,
			rownumbers:true,
			//autoRowHeight : false,
			pagination : true,  
			headerCls:'panel-header-gray',
			//pageSize:14,
			//pageList : [14,20,50],
			url:$URL,
			queryParams:{
				ClassName : "DHCDoc.DHCDocConfig.CommonFunction",
				QueryName : "QryMenuType",
				parentNode: PageLogicObj.m_MenuType.getValue(),
				groupid: groupId
			},
			columns :columns,
			toolbar:[{
					text:'�޸�',
					id:'menu-edit',
					iconCls: 'icon-edit'
				}/*,{
					text:'ɾ��',
					id:'menu-delete',
					iconCls: 'icon-cancel'
				}*/
			]
		});
		InitMenuEvent();
	}
}

//8������ ҽ��¼����������
function LoadNewZLConfig(groupId) {
	$("#i-show").addClass("c-hidden");
	$("#i-newZL").removeClass("c-hidden");
	var lnk = "oeorder.oplistcustom.config.hui.csp?GroupRowId=" + groupId;
	$("#i-newZL").attr("src",lnk);
}
//
function deleteMenu() {
	var selected = PageLogicObj.m_MenuGrid.getSelected();
	if (!selected) {
		$.messager.alert("��ʾ","��ѡ��һ����¼...","info")
		return false;
	}
	$.messager.confirm("ɾ��", "��ȷ��ɾ��ô?", function (r) {
		if (r) {
			
			$.messager.alert("��ʾ", "ɾ���ɹ���" , "info");
		} 
	});
}

function saveMenu() {
	var selected = PageLogicObj.m_MenuGrid.getSelected();
	if (!selected) {
		$.messager.alert("��ʾ","��ѡ��һ����¼...","info")
		return false;
	}
	var id = selected.id;
	var check = $("#menu-dg-check").checkbox("getValue");
	var desc = $("#menu-dg-name").val();
	var func = $("#menu-dg-func").val();
	var showFunc = $("#menu-dg-showFunc").val();
	if (check) {
		check = 1;
	} else {
		check = 0;
	}
	var para = id + "!" + desc + "!" + func + "!" + showFunc + "!" + check ;
	
	$m({
		ClassName: "DHCDoc.DHCDocConfig.CommonFunction",
		MethodName: "SaveMenuGroupSetting",
		codes: para,
		groupid: PageLogicObj.m_GoupId
	},function(txtData){
		if (txtData == 0) {
			//$.messager.alert("��ʾ","����ɹ�...","info")
			PageLogicObj.m_MenuWin.close();
			PageLogicObj.m_MenuGrid.reload();
		} else {
			$.messager.alert("��ʾ","����ʧ�ܣ�" + txtData ,"info")
		}
	});
}

function menuDiag() {
	var selected = PageLogicObj.m_MenuGrid.getSelected();
	if (!selected) {
		$.messager.alert("��ʾ","��ѡ��һ����¼...","info")
		return false;
	}
		
	if($('#menu-dg').hasClass("c-hidden")) {
		$('#menu-dg').removeClass("c-hidden");
	};
	if (selected.checkflag == 1) {
		$("#menu-dg-check").checkbox("check")
	} else {
		$("#menu-dg-check").checkbox("uncheck")
	}
	$("#menu-dg-name").val(selected.desc);
	$("#menu-dg-func").val(selected.func);
	$("#menu-dg-showFunc").val(selected.showFunc);
	
	var menuWin = $HUI.window('#menu-dg', {
		title: "�޸�",
		iconCls: "icon-w-edit",
		modal: true,
		minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
		onClose: function () {
			//$(this).window('destroy');
			$('#menu-dg').addClass("c-hidden");
		}
	});
	
	PageLogicObj.m_MenuWin = menuWin;
}
//
function InitLGrid(){
	//TABLE: DHCDocIPBDictory
	var columns = [[
		{field:'SSGRP_Desc',title:'��ȫ��',width:200},
		{field:'SSGRP_Rowid',title:'ID',width:60,hidden:false}
    ]]
	var DurDataGrid = $HUI.datagrid("#i-group", {
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		rownumbers:true,
		//autoRowHeight : false,
		pagination : true,  
		headerCls:'panel-header-gray',
		//pageSize:999,
		//pageList : [999,20,50],
		url:$URL,
		displayMsg:"",
		queryParams:{
			ClassName : "DHCDoc.DHCDocConfig.CommonFunction",
			QueryName : "FindGroup",
			value: "",
			HospRowId:$HUI.combogrid('#_HospList').getValue()
		},
		columns :columns,
		onSelect: function (rowIndex, rowData) {
			//alert(rowData.SSGRP_Rowid);
			//$("#i-tab").tabs('select',0);
			$("#LocDesc,#DocDesc").val("");
			PageLogicObj.m_GoupId = rowData.SSGRP_Rowid;
			//LoadDepConfig(rowData.SSGRP_Rowid);
			//LoadDocConfig(rowData.SSGRP_Rowid);
			LoadOrdConfig(rowData.SSGRP_Rowid);
			LoadYSZConfig(rowData.SSGRP_Rowid);
			//LoadGHConfig(rowData.SSGRP_Rowid);
			//LoadZLConfig(rowData.SSGRP_Rowid);
			LoadMenuAuthConfig(rowData.SSGRP_Rowid);
			var title = $('#i-tab').tabs('getSelected').panel("options").title
			if (title=="ҽ��¼����������"){
				LoadNewZLConfig(rowData.SSGRP_Rowid);
			}
		}
	});
	
	return DurDataGrid;
}

//�༭������
function opDialog(action) {
	var selected = PageLogicObj.m_DurDataGrid.getSelected();
	var tempValue = "",tempValue2 = "";
	var _title = "", _icon = "" ;
	if (action == "add") {
		_title = "���";
		_icon = "icon-add";
		$("#i-action").val("add");
		$("#i-id").val("");
	} else {
		if (!selected) {
			$.messager.alert("��ʾ","��ѡ��һ����¼...","info")
			return false;
		}
		_title = "�޸�";
		_icon = "icon-edit";
		$("#i-action").val("edit");
		$("#i-id").val(selected.Rowid);
		tempValue = selected.TArcimDesc;
		tempValue2 = selected.TlinkArcimDesc;
		PageLogicObj.m_TlinkArcimIDOld = selected.TlinkArcimID;
		PageLogicObj.m_TarcimIDOld = selected.TarcimID;
	}
	
	if($('#i-dialog').hasClass("c-hidden")) {
		$('#i-dialog').removeClass("c-hidden");
	};
	
	//
	PageLogicObj.m_DiagArcimCombox = $HUI.combogrid("#i-diag-arcim", {
		panelWidth: 500,
		idField: 'ArcimDR',
		textField: 'ArcimDesc',
		//method: 'get',
		columns: [[
			{field:'ArcimDesc',title:'��Ŀ����',width:100},
			{field:'ArcimDR',title:'��ĿID',width:30}
		]],
		pagination : true,
		url:$URL,
		queryParams:{
			ClassName : 'DHCDoc.DHCDocConfig.CommonFunction',
			QueryName : 'FindMasterItem',
			arcimdesc: tempValue
		},
		fitColumns: true,
		enterNullValueClear:false,
		onChange:function () {
			var curInput = PageLogicObj.m_DiagArcimCombox.getText();
			PageLogicObj.m_DiagArcimGrid.datagrid("reload", {
				ClassName : 'DHCDoc.DHCDocConfig.CommonFunction',
				QueryName : 'FindMasterItem',
				arcimdesc: curInput
			})
		},
		onSelect: function (rowIndex, rowData) {
			var curInput = rowData.ArcimDesc;	
			PageLogicObj.m_DiagArcimGrid.datagrid("reload", {
				ClassName : 'DHCDoc.DHCDocConfig.CommonFunction',
				QueryName : 'FindMasterItem',
				arcimdesc: curInput
			})
		}
	});
	PageLogicObj.m_DiagArcimGrid = PageLogicObj.m_DiagArcimCombox.grid();
	
	//
	PageLogicObj.m_NeedArcimCombox = $HUI.combogrid("#i-diag-needarcim", {
		panelWidth: 500,
		idField: 'ArcimDR',
		textField: 'ArcimDesc',
		//method: 'get',
		columns: [[
			{field:'ArcimDesc',title:'��Ŀ����',width:100},
			{field:'ArcimDR',title:'��ĿID',width:30}
		]],
		pagination : true,
		url:$URL,
		queryParams:{
			ClassName : 'DHCDoc.DHCDocConfig.CommonFunction',
			QueryName : 'FindMasterItem',
			arcimdesc: tempValue2
		},
		fitColumns: true,
		enterNullValueClear:false,
		onChange:function () {
			var curInput = PageLogicObj.m_NeedArcimCombox.getText();
			PageLogicObj.m_NeedArcimGrid.datagrid("reload", {
				ClassName : 'DHCDoc.DHCDocConfig.CommonFunction',
				QueryName : 'FindMasterItem',
				arcimdesc: curInput
			})
		},
		onSelect: function (rowIndex, rowData) {
			var curInput = rowData.ArcimDesc;	
			PageLogicObj.m_NeedArcimGrid.datagrid("reload", {
				ClassName : 'DHCDoc.DHCDocConfig.CommonFunction',
				QueryName : 'FindMasterItem',
				arcimdesc: curInput
			})
		}
	});
	PageLogicObj.m_NeedArcimGrid = PageLogicObj.m_NeedArcimCombox.grid();
	
	//����
	var sDateBox = $HUI.datebox("#i-diag-sdate",{
		//required:true  
	});
	
	var eDateBox = $HUI.datebox("#i-diag-edate",{
		//required:true  
	});
	
	PageLogicObj.m_SDateBox = sDateBox;
	PageLogicObj.m_EDateBox = eDateBox;
	if (action == "add") {
		sDateBox.setValue("");
		eDateBox.setValue("");
		PageLogicObj.m_NeedArcimCombox.setValue("");
		PageLogicObj.m_DiagArcimCombox.setValue("");
		$("#i-id").val("");
		$("#i-action").val("add");
	} else {
		$("#i-id").val(selected.LRowid);
		$("#i-action").val("edit");
		sDateBox.setValue(selected.TStDate);
		eDateBox.setValue(selected.TEndDate);
		setTimeout(function () {
			PageLogicObj.m_NeedArcimCombox.setValue(selected.TlinkArcimID);
			PageLogicObj.m_DiagArcimCombox.setValue(selected.TarcimID);
		},800)
		
	}
	
	var cWin = $HUI.window('#i-dialog', {
		title: _title,
		iconCls: _icon,
		modal: true,
		minimizable:false,
		maximizable:false,
		maximizable:false,
		collapsible:false,
		onClose: function () {
			//$(this).window('destroy');
			$('#i-dialog').addClass("c-hidden");
		}
	});
	
	PageLogicObj.m_Win = cWin;
}

function deConfig () {
	var selected = PageLogicObj.m_DurDataGrid.getSelected();
	if (!selected) {
		$.messager.alert("��ʾ","��ѡ��һ����¼...","info")
		return false;
	}
	$.m({
			ClassName:"web.DHCDocOrdLinkContr",
			MethodName:"LinkOrdDel",
			arcim: selected.TarcimID,
			linkarcim:selected.TlinkArcimID,
			LRowid:selected.LRowid
		},function (responseText){
			if(responseText == 0) {
				$.messager.alert('��ʾ','ɾ���ɹ�',"info");
				PageLogicObj.m_DurDataGrid.reload();
			} else {
				$.messager.alert('��ʾ','�޸�ʧ��,�������: '+ responseText , "info");
				return false;
			}	
		})
}


//�����ֵ���Ϣ
function saveCfg() {
	var id = $("#i-id").val();
	var action = $("#i-action").val();
	var arcim = PageLogicObj.m_DiagArcimCombox.getValue();
	var needarcim = PageLogicObj.m_NeedArcimCombox.getValue();
	var sDate = PageLogicObj.m_SDateBox.getValue();
	var eDate = PageLogicObj.m_EDateBox.getValue();
	var paraStr = id + "^" + arcim + "^" + needarcim + "^" + sDate + "^" + eDate
	
	if (arcim == "") {
		$.messager.alert('��ʾ','ҽ�����Ϊ��!',"info");
		return false;
	}
	if (needarcim == "") {
		$.messager.alert('��ʾ','�迪ҽ�����Ϊ��!',"info");
		return false;
	}
	if (sDate == "") {
		$.messager.alert('��ʾ','��ʼʱ�䲻��Ϊ��!',"info");
		return false;
	}//LinkOrdInsert,LinkOrdUpdate,LinkOrdDel
	var methodName = "LinkOrdUpdate";
	if (action == "add") {
		methodName = "LinkOrdInsert";
		$.m({
			ClassName:"web.DHCDocOrdLinkContr",
			MethodName:methodName,
			arcim:arcim,
			linkarcim:needarcim,
			stdate:sDate,
			enddate:eDate
		},function (responseText){
			if(responseText == 0) {
				$.messager.alert('��ʾ','��ӳɹ�',"info");
				PageLogicObj.m_Win.close();
				PageLogicObj.m_DurDataGrid.reload();
				
			} else {
				$.messager.alert('��ʾ','���ʧ��,�������: '+ responseText , "info");
				return false;
			}	
		})
	} else {
		$.m({
			ClassName:"web.DHCDocOrdLinkContr",
			MethodName:methodName,
			arcim:arcim,
			linkarcim:needarcim,
			stdate:sDate,
			enddate:eDate,
			TarcimIDOld:PageLogicObj.m_TarcimIDOld,
			TlinkArcimIDOld:PageLogicObj.m_TlinkArcimIDOld,
			LRowid:id
		},function (responseText){
			if(responseText == 0) {
				$.messager.alert('��ʾ','�޸ĳɹ�',"info");
				PageLogicObj.m_Win.close();
				PageLogicObj.m_DurDataGrid.reload();
				
			} else {
				$.messager.alert('��ʾ','�޸�ʧ��,�������: '+ responseText , "info");
				return false;
			}	
		})
	}
}
function findConfig () {
	//var text = PageLogicObj.m_ArcimCombox.getText();
	var desc = $("#i-desc").val();
	PageLogicObj.m_LGird.reload({
		ClassName : "DHCDoc.DHCDocConfig.CommonFunction",
		QueryName : "FindGroup",
		value: desc,
		HospRowId:$HUI.combogrid('#_HospList').getValue()
	});
}
function findMenuConfig () {
	//var text = PageLogicObj.m_ArcimCombox.getText();
	var code = PageLogicObj.m_MenuType.getValue();
	PageLogicObj.m_MenuGrid.reload({
		ClassName : "DHCDoc.DHCDocConfig.CommonFunction",
		QueryName : "QryMenuType",
		parentNode: code,
		groupid: PageLogicObj.m_GoupId
	});
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
	//�������Backspace������  
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
function LocDesckeydownHanlder(){
	var LocDesc=$("#LocDesc").val()
	LoadDocConfig(PageLogicObj.GroupId,LocDesc)
}
function DocDesckeydownHanlder(){
	var DocDesc=$("#DocDesc").val()
	var inValue="";
	if ($("#docLocUL>li.active").length>0){
		inValue=$("#docLocUL>li.active").attr("value");
	}
	LoadDocConfigInfo(PageLogicObj.GroupId,PageLogicObj.LocId,inValue,DocDesc)
}
function GetHospId(){
	return $HUI.combogrid('#_HospList').getValue();
}
