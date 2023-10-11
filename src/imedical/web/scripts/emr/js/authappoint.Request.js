
//debugger;
Ext.QuickTips.init();
var rootNode, tree;
var actionString = '';
var actionNameString = '';
var requestPriv = '';
//liuzhongwan 16/07/11更改Ajax获取数据的类型为Stream，并将其他内容的加载放在ajax的回调中
Ext.onReady(function(){
Ext.Ajax.request({
	//dataType: "text",
	url: "../EMRservice.Ajax.AuthAppoint.cls?EpisodeID=" + episodeID + "&PatientID=" + patientID + "&Action=getJson",
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
				items: [{xtype: 'checkbox', fieldLabel: '权限类型', labelStyle: 'padding-bottom: 0; padding-top: 0; width: 75px', id: 'selectall', boxLabel: '全选', listeners: {'check': function(){onselectall(this.checked);}}},
					    ]
			},{
				columnWidth: .2,
				layout: 'form',
				items: [{xtype: 'checkbox', hideLabel: true, id: 'save', boxLabel: '保存', checked: AllowText, listeners:{'check': function(){checkauthor(this);}}},
					    {xtype: 'checkbox', hideLabel: true, id: 'delete', boxLabel: '删除', checked: AllowText, listeners:{'check': function(){checkauthor(this);}}},]
			},{
				columnWidth: .2,
				layout: 'form',
				items: [{xtype: 'checkbox', hideLabel: true, id: 'print', boxLabel: '打印', checked: AllowText, listeners:{'check': function(){checkauthor(this);}}},
					    {xtype: 'checkbox', hideLabel: true, id: 'view', boxLabel: '查看病历', checked: AllowText, listeners:{'check': function(){checkauthor(this);}}}]
			},{
				columnWidth: .2,
				layout: 'form',
				items: [{xtype: 'checkbox', hideLabel: true, id: 'new', boxLabel: '创建病历', checked: AllowText, listeners:{'check': function(){checkauthor(this);}}}]
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
    }, '->', '-', 
	{
        id: 'btnHistory',
        name: 'btnHistory',
        text: '申请历史',
        cls: 'x-btn-text-icon',
        icon: '../scripts/epr/Pics/browser.gif',
        pressed: false,
        //handler: commitRequest,
		listeners: {"click": InitHistoryWindow}
    },
	{
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
setDefault(AllowText);
function setDefault(flag){
	Ext.getCmp('save').setValue(flag);
	Ext.getCmp('print').setValue(flag);
	Ext.getCmp('delete').setValue(flag);
	Ext.getCmp('view').setValue(flag);
	Ext.getCmp('new').setValue(flag);
}
function onselectall(flag){
	Ext.getCmp('save').setValue(flag);
	Ext.getCmp('print').setValue(flag);
	Ext.getCmp('delete').setValue(flag);
	Ext.getCmp('view').setValue(flag);
	Ext.getCmp('new').setValue(flag);
}
function isselectall(){
	return Ext.getCmp('save').checked&&Ext.getCmp('print').checked&&Ext.getCmp('delete').checked&&Ext.getCmp('view').checked&&Ext.getCmp('new').checked;
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
        height: 60,
        maxLength: 1000
    }, {
        xtype: 'textarea',
        id: 'beforeRequestContent',
        fieldLabel: befReqConFL,
        //grow: true,
        //preventScrollbars: true,
        allowBank: false,
        width: 180,
        height: 50,
        maxLength: 1000
    }, {
        xtype: 'textarea',
        id: 'afterRequestContent',
        fieldLabel: aftReqConFL,
        //grow: true,
        //preventScrollbars: true,
        allowBank: false,
        width: 180,
        height: 50,
        maxLength: 1000
    }, {
        xtype: 'textarea',
        id: 'requestNumber',
        fieldLabel: requestNumber,
        //grow: true,
        //preventScrollbars: true,
        allowBank: false,
        width: 180,
        height: 20,
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
        height: 153,
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
});

//医生在权限申请时，如果该病历是已复印过的，则提示医生"此份病历已经被复印过，是否继续申请权限并让病案室回退病历？" add by niucaicai 2017-10-26
if (IsCopyed == 1)
{	
	Ext.MessageBox.show({
			title: "提示",
			msg: "此份病历已经被复印过，是否继续申请权限，并让病案室回退病历？",
			buttons: {ok:"是",cancel:"否"},
			closable: false,
			//multiline: true,  //此属性为true则显示一个输入框
			fn: function(r){
				if (r == "ok")
				{
					return;
				}
				else if (r == "cancel")
				{
					cancelRequest();
				}
			}
	});
}

});//onready

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
    var HasSealed = "N";
    var requestCateCharpter = "";
    for (var i = 0; i < rootNode.childNodes.length; i++) {
        var cgNode = rootNode.childNodes[i];
        for (var j = 0; j < cgNode.childNodes.length; j++) {
            var ccNode = cgNode.childNodes[j];
            if (ccNode.leaf && ccNode.attributes.checked) {
                
                if (ccNode.attributes.IsSealed == "Y")
                {
                    HasSealed = "Y";
                }
                
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
    
    //已封存病历不能进行权限申请
    if (HasSealed == "Y") {
        Ext.MessageBox.alert('操作提示', '不能对已封存病历进行权限申请！');
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
	//只对实例病历进行 创建病历 操作申请，给出提示; add by niucaicai 2018-03-13
	var ActionHasNew = "0";
	if (actionString.indexOf("new") >= 0)
	{
		ActionHasNew = "1";
	}
	
	var CharpterOnlyHasRecord = "1"
	for (var j=0;j<requestCateCharpter.split("^").length ;j++ )
	{
		//alert(requestCateCharpter.split("^")[j].indexOf("||"));
		if (requestCateCharpter.split("^")[j].indexOf("||") < 0)
		{
			CharpterOnlyHasRecord = "0"
		}
	}

	if ((ActionHasNew == "1")&&(CharpterOnlyHasRecord == "1"))
	{
		alert("不能只对实例病历进行 创建病历 操作申请!");
		return;
	}
	
	//对空模板申请操作时，必须带有“新建”操作
	if ((ActionHasNew == "0")&&(CharpterOnlyHasRecord == "0"))
	{
		alert("对空模板申请操作权限时，必须带有'新建'操作！");
		return;
	}
	
    //没有申请原因
    var requestReason = Ext.getCmp('requestReason').getValue();
    var beforeRequestContent = Ext.getCmp('beforeRequestContent').getValue();
    var afterRequestContent = Ext.getCmp('afterRequestContent').getValue();
    var requestNumber = Ext.getCmp('requestNumber').getValue();
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
	
			//病历已打印 申请权限时提示
			Ext.Ajax.request({
				url: '../EMRservice.Ajax.AuthAppoint.cls',
				params: {
					Action: "getRequestPriv",
					EpisodeID: episodeID,
				},
				success: function(response, opts){
					var requestPriv = eval(response.responseText);
					for(var i=0;i<requestPriv.length;i++){
						if (requestPriv[i].requestPriv !== "0"){
							var view = confirm(requestPriv[i].requestPriv);
							if(!view){
								cancelRequest();
							}else{
								Ext.Ajax.request({
										url: '../EMRservice.Ajax.AuthAppoint.cls',
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
											AfterRequestContent: afterRequestContent,
											RequestNumber: requestNumber
										},
										success: function(response, opts){
											//alert(response.responseText);
											if ((response.responseText !== "-1")||(response.responseText !== "0")) {
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
							}else{	
							Ext.Ajax.request({
								url: '../EMRservice.Ajax.AuthAppoint.cls',
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
									AfterRequestContent: afterRequestContent,
									RequestNumber: requestNumber
								},
								success: function(response, opts){
								//alert(response.responseText);
									if ((response.responseText !== "-1")||(response.responseText !== "0")) {
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
				},
				failure: function(response, opts){
					Ext.MessageBox.alert('提示', response.responseText);
				}
			});
	
		}
		}
	});

	
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