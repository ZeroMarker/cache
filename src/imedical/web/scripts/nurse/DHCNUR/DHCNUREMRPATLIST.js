///add by yjn
function InitializeForm() {
    var patientTree = CreateTree("patientTree");
	var west_item = new Ext.Panel({
        title: '病人列表',
        id: 'FsPats',
        height: 1000,			  
		split: true,
		border: true,
		collapsible: true, 
		layout: "absolute",
		layoutConfig: {
			animate: true
		},
        items: [patientTree]
    });
    var anchorPanel = new Ext.Panel({
        // layout : 'anchor',
        items: [{
            xtype: 'fieldset',
            //collapsible: true,
            title: '病人查询',
            id: 'FsSort',
            labelWidth: 80,
            collapsible: true,
            frame: false,
            items: [{
                xtype: 'checkbox',
                id: 'ckbGroup',
                checked: false,
                fieldLabel: '专业组'
            }, {
                xtype: 'textfield',
                id: 'regNo',
                fieldLabel: '病人ID',
                listeners:{
                    specialKey:function(field,e) {
                        if(e.getKey() == Ext.EventObject.ENTER){
                            initTree();
                        }
                    }
                }
            }, {
                xtype: 'textfield',
                id: 'patName',
                fieldLabel: '当前病人',
                disabled:true,
                style:{
                   color:'red'
                }
            }, {
                xtype: 'button',
                id: 'butFind',
                text:'查询',
                width:80,
                style:{
                    marginLeft:115
                },
                handler:initTree
            }]
        },west_item]
    });

    var viewPort = new Ext.Viewport({
        layout: 'absolute',
        id: "viewPort",
        width:'100%',
        defaults: {
            border: true,
            frame: true,
            bodyBorder: true
        },
        items: [{
            region: 'west',
            width: '100%',
            height: 1000,
            minWidth: 140,
            split: true,
            items: [anchorPanel]
            //collapsible: true
        }]
    });
    // var disposeStatInfo=new Ext.form.
}
function CreateTree(patientTree) {
    var loader = new Ext.tree.TreeLoader({
        dataUrl: '../csp/dhc.nurse.ext.common.getdataold.csp?className=Nur.QueryBroker&methodName=GetTreeEmr&type=Method&ctlocDr=' + session['LOGON.CTLOCID'] + "&adm=" + EpisodeID + "&groupSort=false"
    });
    var root = new Ext.tree.AsyncTreeNode({
        text: "全病区",
        iconCls: 'all'
    });
    var tree = new Ext.tree.TreePanel({
        root: root,
        // animate : true,
        // frame:true,
        // tbar:[new Ext.form.ComboBox({id:"dsds"})],
        autoScroll: true,
        id: 'patientTree',
        rootVisible: true,
        width: '100%',
        height: 600,
        containerScroll: true,
        autoScroll: true,
        loader: loader
    });
    return tree;
}
function InitializeValue() {
    // 调整病人列表高度
    var FsSort = Ext.getCmp("FsSort");
    var patientTree = Ext.getCmp("patientTree");
    // 病人列表数的点击事件
    patientTree.on('checkchange', function (node) {

    })
    patientTree.on('click', function (node) {
        node.getUI().toggleCheck();
        lnk = "dhcnuremrnewIP.csp?EpisodeID=" + node.id;
        parent.frames['right'].location.href = lnk;
        setDefaultRegNo(node.id);
        setDefaultName();
    });
    patientTree.expandAll();
    // 专业组排序
    Ext.getCmp("ckbGroup").on("check", initTree);
    //initGroup();
    //Ext.getCmp("ckbGroup").checked=true;
}
function initGroup() {
    var patientTree = Ext.getCmp("patientTree");
    var loader = patientTree.getLoader();
    loader.dataUrl = '../csp/dhc.nurse.ext.common.getdataold.csp?className=Nur.QueryBroker&methodName=GetTreeEmr&type=Method&ctlocDr=' + session['LOGON.CTLOCID'] + "&adm=" + EpisodeID + "&groupSort=" + Ext.getCmp("ckbGroup").getValue();
    loader.load(patientTree.getRootNode(), function () {
        patientTree.expandAll();
    });
}
function GetSelNode() {
    alert(EpisodeID);
}
//加载默认病人的id号
function setDefaultRegNo(adm) {
    if(adm!=""){
        EpisodeID=adm;
    }
    var defaultRegName = tkMakeServerCall("Nur.DHCNurAddition", "GetPatRegNameByAdm", EpisodeID);
    var defaultRegNo = defaultRegName.split('^')[0].toString();
    //var defaultName = defaultRegName.split('^')[1].toString();
    Ext.getCmp('regNo').setValue(defaultRegNo);
    //Ext.getCmp('patName').setValue(defaultName);
}
//加载默认病人姓名
function setDefaultName(){
    var regNo=Ext.getCmp('regNo').getValue();
    var patName=tkMakeServerCall("Nur.DHCNurAddition", "GetPatNameByRegNo", regNo);
    Ext.getCmp('patName').setValue(patName);
}
function initTree(){
    var patientTree = Ext.getCmp("patientTree");
    var regNo=Ext.getCmp('regNo').getValue();
	var num=regNo.length;
	if(regNo!="")
	{
		for (var i=0; i<10-num; i++) {  

			regNo="0"+regNo;
		}
	}
	
	Ext.getCmp('regNo').setValue(regNo);
    var loader = patientTree.getLoader();
    loader.dataUrl = '../csp/dhc.nurse.ext.common.getdataold.csp?className=Nur.QueryBroker&methodName=GetTreeEmr&type=Method&ctlocDr=' + session['LOGON.CTLOCID'] + "&adm=" + EpisodeID + "&groupSort=" + Ext.getCmp("ckbGroup").getValue()+"&regNo="+regNo;
    loader.load(patientTree.getRootNode(), function () {
        patientTree.expandAll();
    });
    setDefaultName();
}
Ext.onReady(function () {
    InitializeForm();
    setDefaultRegNo("");
    setDefaultName();
    InitializeValue();
    //GetSelNode();   
});