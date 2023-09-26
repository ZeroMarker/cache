
//debugger;
Ext.QuickTips.init();

var northPanel = new Ext.FormPanel({
    id: 'northPanel',
    labelWidth: 75,
    labelAlign: 'right',
    frame: true,
    //bodyStyle:'padding:5px 5px 0',
    //width: 500,
    //layout:'north',
    items: [{
        xtype: 'fieldset',
        title: '基本信息',
        collapsible: true,
        autoHeight: true,
        defaults: {
            width: 210
        },
        defaultType: 'textfield',
        items: [{
            id: 'requestUser',
            fieldLabel: '申请人',
            name: 'requestUser',
            value: currAuthor
            //allowBlank:false
        }, {
            id: 'requestDept',
            fieldLabel: '申请科室',
            name: 'requestDept',
            value: userLocDes
        }, {
            id: 'actionType',
            xtype: 'combo',
            fieldLabel: '权限类型',
            name: 'actionType',
            hiddenName: 'value',
            mode: 'local',
            store: new Ext.data.SimpleStore({
                fields: ['value', 'text'],
                data: [['view', '界面模板浏览'], ['save', '保存'], ['print', '打印'], ['commit', '提交'], ['switch', '选择模板'], ['switchtemplate', '更新模板'], ['chiefcheck', '主任医师签名'], ['attendingcheck', '主治医生签名'], ['browse', '病历浏览']]
            }),
            valueField: 'value',
            displayField: 'text',
            typeAhead: true,
            mode: 'local',
            triggerAction: 'all',
            emptyText: '请选择一种权限类型...',
            selectOnFocus: true,
            //增加多选  for Bug #1614前端要求病历申请授权可以批量处理多个病历操作 --add by yang 2012-4-13
            tpl: '<tpl for="."><div class="x-combo-list-item"><span><input type="checkbox" {[values.check?"checked":""]}  value="{[values.text]}" /></span><span >{text}</span></div></tpl>',
            onSelect: function(record, index){
                if (this.fireEvent('beforeselect', this, record, index) !== false) {
                    record.set('check', !record.get('check'));
                    var str = [];//页面显示的值
                    var strvalue = [];//传入后台的值
                    this.store.each(function(rc){
                        if (rc.get('check')) {
                            str.push(rc.get('text'));
                            strvalue.push(rc.get('value'));
                        }
                    });
                    this.setValue(str.join());
                    this.value = strvalue.join();
                    this.fireEvent('select', this, record, index);
                }
            }
            //**********************************************************************************
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
        handler: commitRequest
    }]
});

var Tree = Ext.tree;
var treeLoader = new Tree.TreeLoader({
    dataUrl: "../web.eprajax.actionappointchapter.cls?EpisodeID=" + episodeID + "&PatientID=" + patientID + "&ActionType=0"
});

var tree = new Tree.TreePanel({
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
    loader: treeLoader,
    id: "myTree"
});

var rootNode = new Tree.AsyncTreeNode({
    text: '请选择病历范围',
    nodeType: 'async',
    draggable: false,
    id: "RT0"
});

//抛出异常时的处理				
treeLoader.on("loadexception", function(tree, node, response){
    var obj = response.responseText;
    alert(obj);
});

tree.setRootNode(rootNode);
rootNode.expand(true);

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
        width: 174,
		height: 50,
        maxLength: 1000
    }, {
        xtype: 'textarea',
        id: 'beforeRequestContent',
        fieldLabel: befReqConFL,
        //grow: true,
        //preventScrollbars: true,
        allowBank: false,
        width: 174,
		height: 50,
        maxLength: 1000
    }, {
        xtype: 'textarea',
        id: 'afterRequestContent',
        fieldLabel: aftReqConFL,
        //grow: true,
        //preventScrollbars: true,
        allowBank: false,
        width: 174,
		height: 51,
		//height: 41,
        maxLength: 1000
    }
	]
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

var radioPanel = new Ext.Panel({
    id: 'radioPanel',
	frame: true,
    items: [
		//"病历是否已打印"此项数据暂时不用 modify by niucaicai 2016-3-16
		/*
		{
			xtype: 'panel',
			id: 'IsPrinted',
			layout:'column',
			frame: true,
			items:[
				{
					xtype: 'radio',
					id: 'YesPrinted',
					name: 'IsPrinted',
					boxLabel: '病历已打印'
				},
				{
					xtype: 'panel',
					id: 'PrintedGapPanel',
					width: 5
				},
				{
					xtype: 'radio',
					id: 'NoPrinted',
					name: 'IsPrinted',
					boxLabel: '病历未打印'
				}
			]
		}
		,
		*/{
			xtype: 'panel',
			id: 'IsCommitedPanel',
			layout:'column',
			frame: true,
			items:[
				{
					xtype: 'radio',
					id: 'YesCommited',
					name: 'IsCommited',
					boxLabel: '已送病案室'
				},
				{
					xtype: 'panel',
					id: 'CommitedGapPanel',
					width: 5
				},
				{
					xtype: 'radio',
					id: 'NoCommited',
					name: 'IsCommited',
					boxLabel: '未送病案室'
				}
			]
		}
	]
});

var EastPanel = new Ext.Panel({
    id: 'EastPanel',
    items: [
		radioPanel,
		reasonPanel
	]

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
        height: 150,
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
        items: EastPanel
    }, {
        border: true,
        region: 'center',
        layout: 'fit',
        width: 550,
        split: true,
        collapsible: true,
        items: tree
    }]
});

SetTextFieldDisable();

tree.render('tree');
tree.doLayout();

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
                if (requestCateCharpter == "") {
                    requestCateCharpter = cateInfo;
                }
                else {
                    requestCateCharpter = requestCateCharpter + "^" + cateInfo;
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
    var combo = Ext.getCmp('actionType');
    var actionString = combo.getValue(); //得到选择的所有操作，以逗号分隔 
    //没有勾选任何操作
    if (actionString == "") {
        Ext.MessageBox.alert('操作提示', '请选择一种权限类型再提交申请');
        return;
    }

	//判断“是否已打印”、“是否发送至病案室”是否选择
	var IsPrinted,IsCommited = "";
	/*
	var YesPrinted = Ext.getCmp('YesPrinted').checked;
	var NoPrinted = Ext.getCmp('NoPrinted').checked;
	if (YesPrinted)
	{
		IsPrinted = "Y";
	}
	else if (NoPrinted)
	{
		IsPrinted = "N";
	}
	else
	{
		Ext.MessageBox.alert('操作提示', '请选择 病历是否已打印 再提交申请');
        return;
	}
	*/

	var YesCommited = Ext.getCmp('YesCommited').checked;
	var NoCommited = Ext.getCmp('NoCommited').checked;
	if (YesCommited)
	{
		IsCommited = "Y";
	}
	else if (NoCommited)
	{
		IsCommited = "N";
	}
	else
	{
		Ext.MessageBox.alert('操作提示', '请选择 是否已送至病案室 再提交申请');
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
	if (EditMust[1] == "Y" && beforeRequestContent == "") {
        Ext.MessageBox.alert('操作提示', '请填写 修改前内容 再提交申请');
        return;
    }
	if (EditMust[2] == "Y" && afterRequestContent == "") {
        Ext.MessageBox.alert('操作提示', '请填写 修改后内容 再提交申请');
        return;
    }
	
    var actionArray = actionString.split(',');
    var actionCount = actionArray.length;
    
    for (var i = 0; i < actionCount; i++) {
        //获取每个操作
        var action = actionArray[i];
        //ajax交互
        Ext.Ajax.request({
            url: '../web.eprajax.EPRAction.cls',
            timeout: 5000,
            params: {
                Action: "request",
                EpisodeID: episodeID,
                RequestCateCharpter: requestCateCharpter,
                RequestUserID: userID,
                RequestDept: userLoc,
                EPRAction: action,
                RequestReason: requestReason,
                BeforeRequestContent: beforeRequestContent,
                AfterRequestContent: afterRequestContent,
				IsPrinted: IsPrinted,
				IsCommited: IsCommited
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
    }
    //全部成功，关闭窗口
    cancelRequest();
}

function cancelRequest(){
    var win = parent.Ext.getCmp('requestWin');
    win.close(this);
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
