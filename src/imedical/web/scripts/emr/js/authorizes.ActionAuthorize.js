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
        defaults: { width: 210 },
        defaultType: 'textfield',
        items: [{
            id: 'authorizeUser',
            fieldLabel: '会诊医生',
            name: 'authorizeUser',
            value: consDocDesc
        }, {
            id: 'authorizeDept',
            fieldLabel: '会诊科室',
            name: 'authorizeDept',
            value: consLocDesc
        }, {
            id: 'appointType',
            xtype: 'combo',
            fieldLabel: '授权对象',
            name: 'appointType',
            hiddenName: 'value',
            mode: 'local',
            name: 'appointType',
            readOnly: true,
            store: new Ext.data.SimpleStore({
                        fields: ['value', 'text'],
                        data: [
                               ['0', '会诊医生'],
                               ['1', '会诊科室']]
                        }),
            valueField: 'value',
            displayField: 'text',
            typeAhead: true,
            mode: 'local',
            triggerAction: 'all',
            emptyText: '请选择一种授权对象...',
            selectOnFocus: true
        },{
            id: 'actionType',
            xtype: 'combo',
            fieldLabel: '权限类型',
            name: 'actionType',
            hiddenName: 'value',
            mode: 'local',
            name: 'actionType',
            readOnly: true,
            store: new Ext.data.SimpleStore({
                        fields: ['value', 'text'],
                        data: [
                               /* 会诊病历授权仅限浏览病历操作
                               ['view', '界面模板浏览'],
                               ['save', '保存'],
                               ['print', '打印'],
                               ['commit', '提交'],
                               ['switch', '选择模板'],
                               ['switchtemplate', '更新模板'],
                               ['chiefcheck', '主任医师签名'],
                               ['attendingcheck', '主治医生签名'],
							   ['save', '保存'],
                               */
							   ['view', '查看病历']]
                        }),
            valueField: 'value',
            displayField: 'text',
            typeAhead: true,
            mode: 'local',
            triggerAction: 'all',
            emptyText: '请选择一种权限类型...',
            selectOnFocus: true,
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
        }]
    }],
    tbar: 
    [
        {
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
        }, 
        '->', '-',
        { id: 'btnCommit', name: 'btnCommit', text: '提交', cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/btnConfirm.gif', pressed: false, handler: CommitAuthorize },
        '-',
        { id: 'btnCancel', name: 'btnCancel', text: '取消', cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/btnConfirm.gif', pressed: false, handler: CancelAuthorize}
    ]
});

var Tree = Ext.tree;
var treeLoader = new Tree.TreeLoader({ 
	//dataUrl: "../web.eprajax.actionappointchapter.cls?EpisodeID=" + episodeID + "&PatientID=" + patientID + "&ActionType=0" 
	dataUrl: "../EMRservice.Ajax.AppointConsultation.cls?Action=getJson&EpisodeID=" + episodeID + "&PatientID=" + patientID + "&consdocID=" + consdocID + "&consLocID=" + consLocID
});

var tree = new Tree.TreePanel({
    //el:"currentDocs",
    rootVisible: false,
    autoScroll: true,
    trackMouseOver: false,
    //title:'当前病历范围',
    animate: false,
    containerScroll: true,
    bodyStyle: 'padding:5px 5px 0',
    lines: true,
    checkModel: 'cascade',
    //autoHeight:true,
    height: 500,
    border: true,
    loader: treeLoader,
    id: "myTree"
    //tbar:treeTbar,
    //bbar:treeBbar
});

var rootNode = new Tree.AsyncTreeNode({
    text: '请选择病历范围',
    nodeType: 'async',
    draggable: false,
    id: "RT0"
});

//抛出异常时的处理				
treeLoader.on("loadexception", function(tree, node, response) {
    var obj = response.responseText;
    alert(obj);
});

tree.setRootNode(rootNode);
rootNode.expand(true);

tree.on("checkchange", function(node, checked) {
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
				//过滤掉无效状态的节点
				if(node.parentNode.childNodes[i].attributes.disabled){
					continue;
				}
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
			//过滤掉无效状态的节点
			if(node.childNodes[i].attributes.disabled){
				continue;
			}
            node.childNodes[i].attributes.checked = checked;
            node.childNodes[i].getUI().checkbox.checked = checked;
        }
    }
});

var view = new Ext.Viewport({
    id: 'authorizeViewPort',
    shim: false,
    animCollapse: false,
    constrainHeader: true,
    collapsible: true,
    margins: '0 0 0 0',
    layout: "border",
    border: false,
    items: [{
        border: true,
        region: 'north',
        height: 180,
        split: true,
        collapsible: true,
        items: northPanel
    }, {
        border: true,
        region: 'center',
        layout: 'fit',
        split: true,
        collapsible: true,
        items: tree
    }]
});

SetTextFieldDisable();

tree.render('tree');
tree.doLayout();

function SetTextFieldDisable() {
    //设置默认“授权给科室”复选框选中状态
    if (appointType == "") appointType = 1;
    Ext.getCmp('appointType').setValue(appointType);
    Ext.getCmp('actionType').setValue("view");
    //设置申请人、申请科室不可改
    var txtUserName = Ext.getCmp('authorizeUser');
    txtUserName.setDisabled(true);
    var txtUserLocDes = Ext.getCmp('authorizeDept');
    txtUserLocDes.setDisabled(true);
}

function CommitAuthorize() {
    //debugger;
    
    //获取当前的授权类型（个人还是科室）
    appointType = Ext.getCmp('appointType').getValue();

    //debugger;
    var count = 0;
    var requestCateCharpter = "";
    for (var i = 0; i < rootNode.childNodes.length; i++) {
        var cgNode = rootNode.childNodes[i];
        for (var j = 0; j < cgNode.childNodes.length; j++) {
            var ccNode = cgNode.childNodes[j];
			//过滤掉无效的节点
			if (ccNode.attributes.disabled)
			{
				continue;
			}
            if (ccNode.leaf && ccNode.attributes.checked) {
                var cateInfo = ccNode.id.substring(2, ccNode.id.length);
                if (requestCateCharpter == "")
                { requestCateCharpter = cateInfo; }
                else
                { requestCateCharpter = requestCateCharpter + "^" + cateInfo; }
            }
        }
    }

    if (requestCateCharpter == "") {
        Ext.MessageBox.alert('操作提示', '请选择授权病历范围!');
        return;
    }

	//获取申请操作
	var cbxType = Ext.getCmp('actionType');
    var actionString = cbxType.getValue();
    if (actionString == "") {
        Ext.MessageBox.alert('操作提示', '请选择一种权限类型再提交申请!');
        return;
    }

	var actionArray = actionString.split(',');
    var actionCount = actionArray.length;

    for (var i = 0; i < actionCount; i++) {
        //获取每个操作
        var action = actionArray[i];
		Ext.Ajax.request({
			url: '../EMRservice.Ajax.AppointConsultation.cls',
			timeout: 5000,
			params: { Action: "authorize", EpisodeID: episodeID, PatientID: patientID, ConsultID: consultID, RequestCateCharpter: requestCateCharpter, AuthorizeUserID: consdocID, AuthorizeLocID: consLocID, EPRAction: action, ConsultType: consultType, AppointUserID: userID, AppointType: appointType },
			success: function(response, opts) {
				//debugger;
				if (response.responseText == "1") {
					parent.parent.Ext.getCmp('authorizeWin').close(this);
				} else if (response.responseText == "-3") {
					Ext.MessageBox.alert('操作提示', '当前会诊记录已经授权!');
				} else {
					Ext.MessageBox.alert('操作提示', '申请权限操作提交失败!');
				}
			},
			failure: function(response, opts) {
				Ext.MessageBox.alert('提示', response.responseText);
			}
		});
	}
}

function CancelAuthorize() {
    var win = parent.parent.Ext.getCmp('authorizeWin');
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
