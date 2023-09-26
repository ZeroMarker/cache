﻿
//debugger;
Ext.QuickTips.init();
var rootNode, tree;
var actionString = '';
var actionNameString = '';
//liuzhongwan 16/07/11更改Ajax获取数据的类型为Stream，并将其他内容的加载放在ajax的回调中
Ext.onReady(function(){
Ext.Ajax.request({
	//dataType: "text",
	url: "../EMRservice.Ajax.Appoint.cls?EpisodeID=" + episodeID + "&PatientID=" + patientID + "&Action=getJson",
	method: "GET",
	success: function(d) {
		try{
			var treeJson = eval(d.responseText);
		}catch(e){
			treeJson = d.responseText.substr(1, d.responseText.length-2);
		}
//liuzhognwan 16/09/01 更改基本信息panel的布局，移除combobox菜单，改为checkbox阵列
var northPanel = new Ext.FormPanel({
	id: 'northPanel',
	labelWidth: 75,
	labelAlign: 'right',
	frame: true,
	items:[{
		xtype: 'fieldset',
		title: '基本信息',
		collapsible: true,
		autoHeight: true,
		items: [{
			layout: 'column',
			items:[{
				columnWidth: .4,
				layout: 'form',
				items: [{
					xtype: 'textfield',
					id: 'requestUser',
					fieldLabel: '申请人',
					name: 'requestUser',
					value: currAuthor
				}]
			},{
				columnWidth: .4,
				layout: 'form',
				items: [{
					xtype: 'textfield',
					id: 'requestDept',
					fieldLabel: '申请科室',
					name: 'requestDept',
					value: userLocDes
				}]
			}]
		},{
			layout: 'column',
			height:46,
			autoScroll: true,
			style: 'font-size: 12px',
			items: [{
				columnWidth: .3,
				layout: 'form',
				//style: 'height: 18px',
				items: [
					{xtype: 'checkbox', fieldLabel: '权限类型', labelStyle: 'padding-bottom: 0; padding-top: 0; width: 75px', id: 'selectall', boxLabel: '全选', listeners: {'check': function(){onselectall(this.checked);}}},
					{xtype: 'checkbox', hideLabel: true, style: 'margin-left:83px', id: 'view', boxLabel: '查看病历', checked: true, listeners:{'check': function(){checkauthor(this);}}}
					//,{xtype: 'checkbox', hideLabel: true, style: 'margin-left:83px;', id: 'reference', boxLabel: '文档对照', checked: true, listeners:{'check': function(){checkauthor(this);}}}
				]
			},{
				columnWidth: .2,
				layout: 'form',
				items: [
					{xtype: 'checkbox', hideLabel: true, id: 'save', boxLabel: '保存', checked: true, listeners:{'check': function(){checkauthor(this);}}},
					{xtype: 'checkbox', hideLabel: true, id: 'export', boxLabel: '导出文档', checked: true, listeners:{'check': function(){checkauthor(this);}}}
					//,{xtype: 'checkbox', hideLabel: true, id: 'residentcheck', boxLabel: '住院医师审核', checked: true, listeners:{'check': function(){checkauthor(this);}}}
				]
			},{
				columnWidth: .2,
				layout: 'form',
				items: [
					{xtype: 'checkbox', hideLabel: true, id: 'print', boxLabel: '打印', checked: true, listeners:{'check': function(){checkauthor(this);}}},
					{xtype: 'checkbox', hideLabel: true, id: 'copypaste', boxLabel: '复制粘贴', checked: true, listeners:{'check': function(){checkauthor(this);}}}
					//,{xtype: 'checkbox', hideLabel: true, id: 'chiefcheck', boxLabel: '主任医师审核', checked: true, listeners:{'check': function(){checkauthor(this);}}}
				]
			},{
				columnWidth: .2,
				layout: 'form',
				items: [
					{xtype: 'checkbox', hideLabel: true, id: 'delete', boxLabel: '删除', checked: true, listeners:{'check': function(){checkauthor(this);}}},
					{xtype: 'checkbox', hideLabel: true, id: 'new', boxLabel: '创建病历', checked: true, listeners:{'check': function(){checkauthor(this);}}}
					//,{xtype: 'checkbox', hideLabel: true, id: 'attendingcheck', boxLabel: '主治医师审核', checked: true, listeners:{'check': function(){checkauthor(this);}}}
				]
			}]
		}]
	}],
	tbar: [{
        id: 'btnCheckAll',
        name: 'btnCheckAll',
        text: '全选',
        cls: 'x-btn-text-icon',
        icon: '../scripts/epr/Pics/btnConfirm.gif',
        pressed: false,
        handler: CheckAllRequest
    }, {
        id: 'btnInverseAll',
        name: 'btnInverseAll',
        text: '反选',
        cls: 'x-btn-text-icon',
        icon: '../scripts/epr/Pics/btnConfirm.gif',
        pressed: false,
        handler: InverseAllRequest
    }, '->', '-', {
        id: 'btnCancel',
        name: 'btnCancel',
        text: '取消',
        cls: 'x-btn-text-icon',
        icon: '../scripts/epr/Pics/btnConfirm.gif',
        pressed: false,
        handler: cancelRequest
    }, {
        id: 'btnCommit',
        name: 'btnCommit',
        text: '提交',
        cls: 'x-btn-text-icon',
        icon: '../scripts/epr/Pics/btnConfirm.gif',
        pressed: false,
        //handler: commitRequest,
		listeners: {"click": commitRequest}
    }]
});

function onselectall(flag){
	Ext.getCmp('save').setValue(flag);
	Ext.getCmp('print').setValue(flag);
	Ext.getCmp('delete').setValue(flag);
	Ext.getCmp('copypaste').setValue(flag);
	//Ext.getCmp('residentcheck').setValue(flag);
	//Ext.getCmp('chiefcheck').setValue(flag);
	///Ext.getCmp('attendingcheck').setValue(flag);
	Ext.getCmp('new').setValue(flag);
	Ext.getCmp('view').setValue(flag);
	Ext.getCmp('export').setValue(flag);
	//Ext.getCmp('reference').setValue(flag);
}
function isselectall(){
	//return Ext.getCmp('save').checked&&Ext.getCmp('print').checked&&Ext.getCmp('delete').checked&&Ext.getCmp('copypaste').checked&&Ext.getCmp('residentcheck').checked&&Ext.getCmp('chiefcheck').checked&&Ext.getCmp('attendingcheck').checked&&Ext.getCmp('new').checked&&Ext.getCmp('view').checked&&Ext.getCmp('export').checked&&Ext.getCmp('reference').checked;
	return Ext.getCmp('save').checked&&Ext.getCmp('print').checked&&Ext.getCmp('delete').checked&&Ext.getCmp('copypaste').checked&&Ext.getCmp('new').checked&&Ext.getCmp('view').checked&&Ext.getCmp('export').checked;
}
function checkauthor(boxOBJ){
	if(boxOBJ.checked){
		if(actionString.length==0){
			actionString = boxOBJ.id;
			actionNameString = boxOBJ.boxLabel;
		}
		else{
			if(actionString.indexOf(boxOBJ.id)<0){
				actionString = actionString + ',' + boxOBJ.id;
				actionNameString = actionNameString + ',' + boxOBJ.boxLabel;
			}
		}
		if(isselectall()){
			var selectall = Ext.getCmp('selectall');
			selectall.purgeListeners();
			selectall.setValue(true);
			selectall.on('check', function(){onselectall(this.checked)});
		}
	}
	else{
		actionString = actionString.replace(boxOBJ.id,'');
		actionString = actionString.replace(',,',',');
		actionNameString = actionNameString.replace(boxOBJ.boxLabel,'');
		actionNameString = actionNameString.replace(',,',',');
		if(actionString.charAt(0)==','){			
			actionString=actionString.substr(1, actionString.length);
			actionNameString = actionNameString.substr(1, actionNameString.length);
		}
		if(actionString.charAt(actionString.length-1)==','){
			actionString=actionString.substr(0, actionString.length-1);
			actionNameString = actionNameString.substr(0, actionNameString.length-1);
		}
		var selectall = Ext.getCmp('selectall');
		selectall.purgeListeners();
		selectall.setValue(false);
		selectall.on('check', function(){onselectall(this.checked)});
	}
}
//end liuzhongwan 16/09/01


//liuzhongwan 16/07/11 新树定义
rootNode = new Ext.tree.AsyncTreeNode({
	text: '请选择病历范围',
	nodeType: 'async',
	draggable: false,
	expanded:true,
	children:treeJson,
	id: "RT0"
});

tree=new Ext.tree.TreePanel({
		
	rootVisible: false,
    autoScroll: true,
    trackMouseOver: false,
    //title:'病历范围',
    animate: false,
    containerScroll: true,
    bodyStyle: 'padding:5px 5px 0',
    lines: true,
    checkModel: 'cascade',
    //autoHeight:true,
    height: 600,
    border: true,
	root:rootNode,
    loader:new Ext.tree.TreeLoader(),
    id: "myTree"
   });


/*//抛出异常时的处理				
treeLoader.on("loadexception", function(tree, node, response){
    var obj = response.responseText;
    alert(obj);
});*/

//tree.setRootNode(rootNode);
//rootNode.expand(true);

tree.on("checkchange", function(node, checked){
    if (node.leaf) {
        if (!checked) {
            //任一子节点未选中，则不选中父节点
            node.parentNode.attributes.checked = false;
            node.parentNode.getUI().checkbox.checked = false;
        }
        else {
            //选中所有子节点，则选中父节点
            var totChecked = true;
            for (var i = 0; i < node.parentNode.childNodes.length; i++) {
                if (!node.parentNode.childNodes[i].attributes.checked) {
                    totChecked = false;
                    break;
                }
            }
            node.parentNode.attributes.checked = totChecked;
            node.parentNode.getUI().checkbox.checked = totChecked;
        }
    }
    else {
        //选中父节点，则选中所有子节点
        for (var i = 0; i < node.childNodes.length; i++) {
            node.childNodes[i].attributes.checked = checked;
            node.childNodes[i].getUI().checkbox.checked = checked;
        }
    }
});

var reasonPanel = new Ext.FormPanel({
    id: 'reasonPanel',
    frame: true,
    bodyStyle: 'padding:5px 5px 0',
    labelAlign: 'top',
    labelWidth: 200,
    items: [{
        xtype: 'textarea',
        id: 'requestReason',
        fieldLabel: reqReasonFL,
        //grow: true,
        //preventScrollbars: true,
        allowBank: false,
        width: 180,
        maxLength: 1000
    }, {
        xtype: 'textarea',
        id: 'beforeRequestContent',
        fieldLabel: befReqConFL,
        //grow: true,
        //preventScrollbars: true,
        allowBank: false,
        width: 180,
        maxLength: 1000
    }, {
        xtype: 'textarea',
        id: 'afterRequestContent',
        fieldLabel: aftReqConFL,
        //grow: true,
        //preventScrollbars: true,
        allowBank: false,
        width: 180,
        maxLength: 1000
    }]
			/*,
    tbar: [{
        id: 'status',
        pressed: false,
        handleMouseEvents: false,
        enable: false,
        text: '请填写申请权限的原因：<font color="FF0000">*</font>'
    }]
	*/
});

var view = new Ext.Viewport({
    id: 'requestViewPort',
    shim: false,
    animCollapse: false,
    constrainHeader: true,
    collapsible: true,
    width: 750,
    margins: '0 0 0 0',
    layout: "border",
    border: false,
    items: [{
        border: true,
        region: 'north',
        layout: 'fit',
        height: 155,
        split: true,
        collapsible: true,
        items: northPanel
    }, {
        border: true,
        region: 'east',
        layout: 'fit',
        width: 200,
        split: true,
        collapsible: true,
        items: reasonPanel
    }, {
        border: true,
		id: 'center-panel',
        region: 'center',
        layout: 'fit',
        width: 550,
        split: true,
        collapsible: true
        //items: tree
    }]
});

SetTextFieldDisable();
if(typeof(treeJson) == 'object'){
	Ext.getCmp('center-panel').add(tree);
	Ext.getCmp('center-panel').doLayout();
}else{
	Ext.getCmp('center-panel').add({
		xtype: 'textarea',
		style: 'font-size: 16',
		value: treeJson
	});
	Ext.getCmp('center-panel').doLayout();
}

	},
	error : function(d) { 
		alert("getTemplate error");
	}
});});//onready

function SetTextFieldDisable(){
    //设置申请人、申请科室不可改
    var txtUserName = Ext.getCmp('requestUser');
    txtUserName.setDisabled(true);
    var txtUserLocDes = Ext.getCmp('requestDept');
    txtUserLocDes.setDisabled(true);
}

function commitRequest(){
    //获取申请范围  
    var count = 0;
    var requestCateCharpter = "";
    for (var i = 0; i < rootNode.childNodes.length; i++) {
        var cgNode = rootNode.childNodes[i];
        for (var j = 0; j < cgNode.childNodes.length; j++) {
            var ccNode = cgNode.childNodes[j];
            if (ccNode.leaf && ccNode.attributes.checked) {
                var cateInfo = ccNode.id.substring(2, ccNode.id.length);
				//liuzhongwan
				var cateText = ccNode.text;
				if(ccNode.id.substring(0,2) == 'CT') cateText = cateText + '(模板)';
                if (requestCateCharpter == "") {
                    requestCateCharpter = cateInfo;
					requestCateText = cateText;
                }
                else {
                    requestCateCharpter = requestCateCharpter + "^" + cateInfo;
					requestCateText = requestCateText + "<br>" + cateText;
                }
            }
        }
    }
    //没有勾选任何范围
    if (requestCateCharpter == "") {
        Ext.MessageBox.alert('操作提示', '请选择申请范围');
        return;
    }
    
    //改为支持多选申请操作 for Bug #1614前端要求病历申请授权可以批量处理多个病历操作 --modified by yang 2012-4-13
    //获取申请操作
    //var combo = Ext.getCmp('actionType');
    //var actionString = combo.getValue(); //得到选择的所有操作，以逗号分隔 
    //没有勾选任何操作
    if (actionString == "") {
        Ext.MessageBox.alert('操作提示', '请选择一种权限类型再提交申请');
        return;
    }
    
    //没有申请原因
    var requestReason = Ext.getCmp('requestReason').getValue();
    var beforeRequestContent = Ext.getCmp('beforeRequestContent').getValue();
    var afterRequestContent = Ext.getCmp('afterRequestContent').getValue();
    if (EditMust[0] == "Y" && requestReason == "") {
        Ext.MessageBox.alert('操作提示', '请填写 申请的原因 再提交申请');
        return;
    }
	if (EditMust[0] == "Y" && LimitMust[0] > 0 && requestReason.length < LimitMust[0] ) {
        Ext.MessageBox.alert('操作提示', '申请的原因 至少' + LimitMust[0] + '个字');
        return;
    }
	if (EditMust[1] == "Y" && beforeRequestContent == "") {
        Ext.MessageBox.alert('操作提示', '请填写 修改前内容 再提交申请');
        return;
    }
	if (EditMust[1] == "Y" && LimitMust[1] > 0 && beforeRequestContent.length < LimitMust[1] ) {
        Ext.MessageBox.alert('操作提示', '修改前内容 至少' + LimitMust[1] + '个字');
        return;
    }
	if (EditMust[2] == "Y" && afterRequestContent == "") {
        Ext.MessageBox.alert('操作提示', '请填写 修改后内容 再提交申请');
        return;
    }
	if (EditMust[2] == "Y" && LimitMust[2] > 0 && afterRequestContent.length < LimitMust[2] ) {
        Ext.MessageBox.alert('操作提示', '修改后内容 至少' + LimitMust[2] + '个字');
        return;
    }

	//增加对特殊字符的过滤，不允许填写特殊字符  add by niucaicai 2016-12-27
	if (requestReason.indexOf("@") != -1 || requestReason.indexOf("#") != -1 || requestReason.indexOf("$") != -1 || requestReason.indexOf("%") != -1 || requestReason.indexOf("^") != -1 || requestReason.indexOf("&") != -1 || requestReason.indexOf("*") != -1 || requestReason.indexOf("-") != -1 || requestReason.indexOf("/") != -1 || requestReason.indexOf("\\") != -1)
	{
		alert("申请的原因 含有非法字符，请重新输入！");
		return;
	}
	if (beforeRequestContent.indexOf("@") != -1 || beforeRequestContent.indexOf("#") != -1 || beforeRequestContent.indexOf("$") != -1 || beforeRequestContent.indexOf("%") != -1 || beforeRequestContent.indexOf("^") != -1 || beforeRequestContent.indexOf("&") != -1 || beforeRequestContent.indexOf("*") != -1 || beforeRequestContent.indexOf("-") != -1 || beforeRequestContent.indexOf("/") != -1 || beforeRequestContent.indexOf("\\") != -1)
	{
		alert("修改前内容 含有非法字符，请重新输入！");
		return;
	}
	if (afterRequestContent.indexOf("@") != -1 || afterRequestContent.indexOf("#") != -1 || afterRequestContent.indexOf("$") != -1 || afterRequestContent.indexOf("%") != -1 || afterRequestContent.indexOf("^") != -1 || afterRequestContent.indexOf("&") != -1 || afterRequestContent.indexOf("*") != -1 || afterRequestContent.indexOf("-") != -1 || afterRequestContent.indexOf("/") != -1 || afterRequestContent.indexOf("\\") != -1)
	{
		alert("修改后内容 含有非法字符，请重新输入！");
		return;
	}
	
	//liuzhongwan 禁止为模板申请创建权限，若只为模板申请了new权限则自动追加save权限申请
	//liuzhongwan 弹出一个提示窗口用于屏蔽连续点击提交按钮的行为
	var msg = "<p>给予医生： " + currAuthor + " </p>"
            + "<p>患者： " + currPatient + " </p>"
            + "<p>操作： " + actionNameString + " </p>"
            + "<p><span style='float:left;'>范围： <div style='float:left;width:85%;height:150px;overflow-y:auto;'>" + requestCateText + " <div></span></p>";
	Ext.MessageBox.show({
		title: '确定申请授权？',
		msg: msg,
		buttons: {yes:"确定",no:"取消"},
		width: 400,
		closable: false,
		fn: function(r){
		if(r=='yes'){
			/*if ((requestCateCharpter.indexOf("||") != -1) && (actionString.indexOf("new") != -1)) {
				Ext.MessageBox.alert('错误', '不能为实例病历申请创建权限，请重新选择！');
				return;
			}
			var TempFlg = 0;
			var chapterArray = requestCateCharpter.split('^');
			for (var i = 0; i < chapterArray.length; i++) {
				if ((chapterArray[i].indexOf("||")<0) && (actionString.indexOf("new")>0) && (actionString.indexOf("save")<0)) {
					TempFlg = 1;
					break;
				}
			}
			if (TempFlg == 1) actionString = actionString+",save";*/
			//end liuzhongwan
	/*var actionArray = actionString.split(',');
    var actionCount = actionArray.length;
	
    for (var i = 0; i < actionCount; i++) {
        //获取每个操作
        var action = actionArray[i];
        //ajax交互
        Ext.Ajax.request({
            url: '../EMRservice.Ajax.Appoint.cls',
            timeout: 5000,
			async: false,
            params: {
                Action: "request",
                EpisodeID: episodeID,
                RequestCateCharpter: requestCateCharpter,
                RequestUserID: userID,
                RequestDept: userLoc,
                EPRAction: action,
                RequestReason: requestReason,
                BeforeRequestContent: beforeRequestContent,
                AfterRequestContent: afterRequestContent
            },
            success: function(response, opts){
                if (response.responseText == "1") {
                    //增加循环后将关闭窗口移出循环 --modified by yang 2012-4-13
                    //parent.Ext.getCmp('requestWin').close(this);
                    ;
                }
                else {
                    Ext.MessageBox.alert('操作提示', '申请权限操作提交失败');
                }
            },
            failure: function(response, opts){
                Ext.MessageBox.alert('提示', response.responseText);
            }
        });
    }*/
			Ext.Ajax.request({
				url: '../EMRservice.Ajax.Appoint.cls',
				timeout: 5000,
				params: {
					Action: "request",
					EpisodeID: episodeID,
					RequestCateCharpter: requestCateCharpter,
					RequestUserID: userID,
					RequestDept: userLoc,
					EPRAction: actionString,
					RequestReason: requestReason,
					BeforeRequestContent: beforeRequestContent,
					AfterRequestContent: afterRequestContent
				},
				success: function(response, opts){
					if (response.responseText == "1") {
                //增加循环后将关闭窗口移出循环 --modified by yang 2012-4-13
                //parent.Ext.getCmp('requestWin').close(this);
						Ext.MessageBox.alert('','权限申请已成功',function(){cancelRequest()});
					}
					else {
						Ext.MessageBox.alert('操作提示', '申请权限操作提交失败')
					}
				},
				failure: function(response, opts){
					Ext.MessageBox.alert('提示', response.responseText);
				}
			});
		}
		}
	});
    //全部成功，关闭窗口
    //cancelRequest();
	//end liuzhongwan
}

function cancelRequest(){
	window.close();
}

//全选所有的
function CheckAllRequest(){
    for (var i = 0; i < rootNode.childNodes.length; i++) {
        var cgNode = rootNode.childNodes[i];
        cgNode.getUI().checkbox.checked = true;
        cgNode.attributes.checked = true;
        for (var j = 0; j < cgNode.childNodes.length; j++) {
            cgNode.childNodes[j].getUI().checkbox.checked = true;
            cgNode.childNodes[j].attributes.checked = true;
        }
    }
}

function InverseAllRequest(){
    //反选
    for (var i = 0; i < rootNode.childNodes.length; i++) {
        var cgNode = rootNode.childNodes[i];
        if (cgNode.getUI().checkbox.checked) {
            cgNode.getUI().checkbox.checked = false;
        }
        else {
            cgNode.getUI().checkbox.checked = true;
        }
        for (var j = 0; j < cgNode.childNodes.length; j++) {
            if (cgNode.childNodes[j].getUI().checkbox.checked) {
                cgNode.childNodes[j].getUI().checkbox.checked = false;
                cgNode.childNodes[j].attributes.checked = false;
            }
            else {
                cgNode.childNodes[j].getUI().checkbox.checked = true;
                cgNode.childNodes[j].attributes.checked = true;
            }
        }
    }
    //任一子节点未选中，则不选中父节点
    var IvChecked = true;
    for (var j = 0; j < cgNode.childNodes.length; j++) {
        if (!cgNode.childNodes[j].getUI().checkbox.checked) {
            IvChecked = false;
            break;
        }
    }
	 //修改反选最后一个目录如果没有子节点会一直选中的bug  add by yhy
    if (cgNode.childNodes.length > 0)
	{
		cgNode.getUI().checkbox.checked = IvChecked;
	}
}