//
var PageLogicObj = {
    m_Time: 60,		//等候时间
    m_seachTime: 2,	//间隔时间
    m_Interval: ""
}
$(function(){
	//初始化
	Init();
	//事件初始化
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
			$.messager.alert("提示","存在未处理的处方,请先处理");
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
	if ((title.indexOf("签")>-1)&&(title.indexOf("签 ")==-1)) {
		var titleArr=title.split("签");
		title=titleArr[0]+'<a href="#" onClick=DoubleSignClick(\''+data["id"]+'\') class="editbutton">'+"签"+'</a>';
		title=title+"  "+'<a href="#" onClick=StopOrdClick(\''+data["id"]+'\') class="editbutton">'+"停"+'</a>'+titleArr[1];
	}
	if (title.indexOf("禁")>-1) {
		var titleArr=title.split("禁");
		title=titleArr[0]+'<a href="#" onClick=StopOrdClick(\''+data["id"]+'\') class="editbutton">'+"停"+'</a>'+titleArr[1];
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
	$("#DivMsg").text("您的用药医嘱正在药师审核中，剩余"+PageLogicObj.m_Time+"秒，请等待...");
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
				window.parent.$.messager.popover({msg:"您的用药医嘱，药师人工审方通过，页面自动关闭",type:'success'});
				websys_showModal("close");
			}else if (rtnArr[0]!="-2") {
				$("#DivMsg").text("您的用药医嘱，药师人工审方已完毕，请在下方查看审方结果");
				window.clearInterval(PageLogicObj.m_Interval);
				LoadOrderTableData();
			}
		}
	}else{
		window.clearInterval(PageLogicObj.m_Interval);
		//此处是否处理表数据？后面要是再返回了怎么办？
		/*var rtn=$.m({
		    ClassName:"web.DHCDocHLYYHZYY",
		    MethodName:"SignHLYYInfo",
		    EpisodeID:ServerObj.EpisodeID,
			DataStr:ServerObj.PrescNoStr,
			SignNotes:"",
			UserID:session['LOGON.USERID'],
			OperType:"F"
		},false);*/
		dhcsys_alert("药师审方结果：等待超时,自动通过...")
		websys_showModal("close");
	}
}

function ordDetailInfoShow(OrdRowID){
	websys_showModal({
		url:"dhc.orderdetailview.csp?ord=" + OrdRowID,
		title:'医嘱明细',
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
    createModalDialog("DoubleSign","双签",380,240,iconCls,"确认",Content,"DoubleSignConfirm("+"'"+PrescNo+"'"+")");
    $("#SignNotes").focus();
}

function DoubleSignConfirm(PrescNo) {
	var SignNotes=$("#SignNotes").val();
	if (SignNotes==""){
		$.messager.alert("提示","请填写双签内容!","info",function(){
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
		$.messager.confirm("确认对话框", "确定停止处方号"+PrescNo+"?", function (r) {
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
			window.parent.$.messager.popover({msg:"您的用药医嘱全部处理完毕，页面自动关闭",type:'success'});
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
	//如果去掉关闭按钮，当用户点击窗体右上角X关闭时，窗体无法回调界面销毁事件，需要基础平台协助处理
	buttons.push({
		text:"关闭",
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
   $("body").remove("#"+id); //移除存在的Dialog
   $("#"+id).dialog('destroy');
}
