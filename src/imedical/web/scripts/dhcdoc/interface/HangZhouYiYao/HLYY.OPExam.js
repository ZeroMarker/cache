//
var PageLogicObj = {
    m_Time: 60,		//�Ⱥ�ʱ��
    m_seachTime: 2,	//���ʱ��
    m_Interval: ""
}
$(function(){
	//��ʼ��
	Init();
	//�¼���ʼ��
	InitEvent();
});

function Init(){
	LoadOrderTableData();
	PageLogicObj.m_Interval=window.setInterval(SetTime, 1000);
}

function InitEvent() {
	$("#BClose").bind("click",function(){
		var rtn=$.m({
		    ClassName:"web.DHCDocHLYYHZYY",
		    MethodName:"CheckBeforeUse",
		    EpisodeID:ServerObj.EpisodeID,
			PrescNoStr:ServerObj.PrescNoStr
		},false);
		var rtnArr=rtn.split("^");
		if ((rtnArr[0]=="-2")||(rtnArr[0]=="-11")||(rtnArr[0]=="11")) {
			$.messager.alert("��ʾ","����δ����Ĵ���,���ȴ���");
            return false;
		}
		websys_showModal("close");
	})
}

function LoadOrderTableData() {
	$.cm({
		ClassName:"web.DHCDocHLYYHZYY",
		MethodName:"GetOEPrescInfo",
		EpisodeID:ServerObj.EpisodeID,
		PrescNoStr:ServerObj.PrescNoStr
	},function(jsonData){
		removeTable();
		var len=jsonData.length;
		var RanderTable=function (i){
			//setTimeout(function(){
				BuildTable(jsonData[i]);
				i++;
				if (i<len){
					RanderTable(i);
				}
			//})
		}
		RanderTable(0);		
	});
}

function removeTable(){
	var $table=$("[id$='_TablePanle']");
		$table.remove();
}

function BuildTable(data){
	var panel=$("#prescItem");
	var temp=$("#templtable-div");
	var tool=temp.clone();
	tool.removeAttr("style").removeAttr("id");
	tool.attr("id",data["id"]+"Panle");
	panel.append(tool);
	var oneHeight=47; 
	var dataLen=data["rows"].length;
	if (dataLen<=1){
		var PanelMaxHeight=oneHeight*3;
	}else{
		var PanelMaxHeight=oneHeight*(dataLen-1)+100;
	}
	tool.height(PanelMaxHeight);
	var columns=new Array();
	var head=data["head"];
	for(var i=0,len=head.length;i<len;++i){
		var field=data["rowCols"][i].data;
		var title=head[i];
		var isHidden=data["HiddenCols"][i][field];
		if (isHidden=="Y"){
			columns.push({"field":field,"title":title,"hidden":true});
		}else{
			if (field=="OEItemID"){
				columns.push({"field":field,"title":title,formatter:function(value,rec){
					var btn = '<a class="editcls" onclick="ordDetailInfoShow(\'' + rec.OEItemID + '\')">'+value+'</a>';
				    return btn;
				}});
			}else{
				columns.push({"field":field,"title":title});
			}
		}
	}
	var newcolumns=new Array();
	newcolumns.push(columns);
	var content='<table class="simplydatagrid" data-options="headerCls:'+"'panel-header-gray'"+'" id="'+data["id"]+'"></table> ' //hisui-datagrid
	tool.append(content);
	if (data["titleClass"]=="") data["titleClass"]="panel-header-gray";
	var title=data["title"];
	if ((title.indexOf("ǩ")>-1)&&(title.indexOf("ǩ ")==-1)) {
		var titleArr=title.split("ǩ");
		title=titleArr[0]+'<a href="#" onClick=DoubleSignClick(\''+data["id"]+'\') class="editbutton">'+"ǩ"+'</a>';
		title=title+"  "+'<a href="#" onClick=StopOrdClick(\''+data["id"]+'\') class="editbutton">'+"ͣ"+'</a>'+titleArr[1];
	}
	if (title.indexOf("��")>-1) {
		var titleArr=title.split("��");
		title=titleArr[0]+'<a href="#" onClick=StopOrdClick(\''+data["id"]+'\') class="editbutton">'+"ͣ"+'</a>'+titleArr[1];
	}
	var type=data["id"].split("_")[0];
	var tableId=data["id"];
	$("#"+data["id"]).simplydatagrid({
		title:title,
		headerCls:data["titleClass"],
		id:data["id"],
		idField:'OEItemID',
		columns: newcolumns,
		data:data["rows"],
		border:false,
	});
}

function SetTime(){
	$("#DivMsg").text("������ҩҽ������ҩʦ����У�ʣ��"+PageLogicObj.m_Time+"�룬��ȴ�...");
	PageLogicObj.m_Time--;
	if (PageLogicObj.m_Time>=0) {
		if (parseInt(PageLogicObj.m_Time)%parseInt(PageLogicObj.m_seachTime)==0) {
			var rtn=$.m({
			    ClassName:"web.DHCDocHLYYHZYY",
			    MethodName:"CheckBeforeUse",
			    EpisodeID:ServerObj.EpisodeID,
				PrescNoStr:ServerObj.PrescNoStr
			},false);
			var rtnArr=rtn.split("^");
			if (rtnArr[0]=="0") {
				window.parent.$.messager.popover({msg:"������ҩҽ����ҩʦ�˹���ͨ����ҳ���Զ��ر�",type:'success'});
				websys_showModal("close");
			}else if (rtnArr[0]!="-2") {
				$("#DivMsg").text("������ҩҽ����ҩʦ�˹�������ϣ������·��鿴�󷽽��");
				window.clearInterval(PageLogicObj.m_Interval);
				LoadOrderTableData();
			}
		}
	}else{
		window.clearInterval(PageLogicObj.m_Interval);
		//�˴��Ƿ�������ݣ�����Ҫ���ٷ�������ô�죿
		/*var rtn=$.m({
		    ClassName:"web.DHCDocHLYYHZYY",
		    MethodName:"SignHLYYInfo",
		    EpisodeID:ServerObj.EpisodeID,
			DataStr:ServerObj.PrescNoStr,
			SignNotes:"",
			UserID:session['LOGON.USERID'],
			OperType:"F"
		},false);*/
		dhcsys_alert("ҩʦ�󷽽�����ȴ���ʱ,�Զ�ͨ��...")
		websys_showModal("close");
	}
}

function ordDetailInfoShow(OrdRowID){
	websys_showModal({
		url:"dhc.orderdetailview.csp?ord=" + OrdRowID,
		title:'ҽ����ϸ',
		width:400,height:screen.availHeight-200
	});
}

function DoubleSignClick(tableId) {
	destroyDialog("DoubleSign");
	//
	var Content="<div id='DiagWin' style='margin-top: 5px;'>"+"<div style='margin:0 auto;border:none;'>" 
	Content=Content+"<textarea style='width:364px;height:128px;margin:5px;' class='' data-options='required:true' id='SignNotes'></textarea>"
	Content=Content+"</div>"+"</div>"
	//
    var iconCls="icon-w-msg";
    var PrescNo=tableId.split("_")[0];
    createModalDialog("DoubleSign","˫ǩ",380,240,iconCls,"ȷ��",Content,"DoubleSignConfirm("+"'"+PrescNo+"'"+")");
    $("#SignNotes").focus();
}

function DoubleSignConfirm(PrescNo) {
	var SignNotes=$("#SignNotes").val();
	if (SignNotes==""){
		$.messager.alert("��ʾ","����д˫ǩ����!","info",function(){
			$("#SignNotes").focus();
		});
		return false;
	}
	$.m({
		ClassName:"web.DHCDocHLYYHZYY",
		MethodName:"SignHLYYInfo",
		EpisodeID:ServerObj.EpisodeID,
		DataStr:PrescNo,
		SignNotes:SignNotes,
		UserID:session['LOGON.USERID'],
		OperType:"S"
	},function(val){
		if (val=="0"){
			LoadOrderTableData();
			destroyDialog("DoubleSign");
		}
	});
}

function StopOrdClick(tableId) {
	var PrescNo=tableId.split("_")[0];
	new Promise(function(resolve,rejected){
		$.messager.confirm("ȷ�϶Ի���", "ȷ��ֹͣ������"+PrescNo+"?", function (r) {
			if (r) {
				websys_showModal("options").HYLLStopOrd(ServerObj.EpisodeID,PrescNo,resolve);
			}else{
				resolve();
			}
		});
	}).then(function(){
		var rtn=$.m({
		    ClassName:"web.DHCDocHLYYHZYY",
		    MethodName:"CheckBeforeUse",
		    EpisodeID:ServerObj.EpisodeID,
			PrescNoStr:ServerObj.PrescNoStr
		},false);
		var rtnArr=rtn.split("^");
		if ((rtnArr[0]=="-2")||(rtnArr[0]=="-11")||(rtnArr[0]=="11")) {
			LoadOrderTableData();
		}else{
			window.parent.$.messager.popover({msg:"������ҩҽ��ȫ��������ϣ�ҳ���Զ��ر�",type:'success'});
			websys_showModal("close");
		}
	})
}

function createModalDialog(id, _title, _width, _height, _icon, _btntext, _content, _event){
	if(_btntext==""){
		var buttons="";
	}else{
		var buttons=[{
			text:_btntext,
			iconCls:_icon,
			handler:function(){
				if(_event!="") eval(_event);
			}
		}]
	}
	//���ȥ���رհ�ť�����û�����������Ͻ�X�ر�ʱ�������޷��ص����������¼�����Ҫ����ƽ̨Э������
	buttons.push({
		text:"�ر�",
		iconCls:'icon-w-close',
		handler:function(){
			destroyDialog(id);
		}
	});
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: false,
        content:_content,
        buttons:buttons,
        onClose:function(){
	        destroyDialog(id);
	    }
    });
}

function destroyDialog(id){
   $("body").remove("#"+id); //�Ƴ����ڵ�Dialog
   $("#"+id).dialog('destroy');
}
