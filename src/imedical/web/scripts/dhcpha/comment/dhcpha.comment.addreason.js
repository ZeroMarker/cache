///description:处方点评-点评相关配置--点评原因维护
var unitsUrl = 'dhcpha.comment.addreason.save.csp';
Ext.onReady(function() {

    Ext.QuickTips.init(); // 浮动信息提示
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

    var ReaAddButton = new Ext.Button({
        width: 65,
        id: "ReaAddBtn",
        text: '增加',
        iconCls:"page_add",
        listeners: {
            "click": function() {

                ReaAddClick();

            }
        }

    })

    var ReaUpdButton = new Ext.Button({
        width: 65,
        id: "ReaUpdBtn",
        text: '修改',
        iconCls:"page_modify",
        listeners: {
            "click": function() {

                ReaUpdClick();

            }
        }

    })

    var ReaDelButton = new Ext.Button({
        width: 65,
        id: "ReaDelBtn",
        text: '删除',
        iconCls:"page_delete",
        listeners: {
            "click": function() {

                ReaDelClick();

            }
        }

    })

    var ReaCodeField = new Ext.form.TextField({

        width: 100,
        id: "ReaCodeTxt",

        fieldLabel: "代码"
    })

    var ReaDescField = new Ext.form.TextField({

        width: 400,
        id: "ReaDescTxt",

        fieldLabel: "原因描述"
    })

    var ReaLevelField = new Ext.form.TextField({

        width: 30,
        id: "ReaLevelTxt",
        fieldLabel: "原因分级"
    })

    ///不合格方式
    var wayurl = 'dhcpha.comment.addway.save.csp';

    var ComBoWayDs = new Ext.data.Store({
        autoLoad: true,
        proxy: new Ext.data.HttpProxy({
            url: wayurl + '?action=QueryActiveWayDs',
            method: 'POST'
        }),
        reader: new Ext.data.JsonReader({
            totalProperty: "results",
            root: 'rows',
            id: 'wayrowid'
        },
        ['waydesc', 'wayrowid'])

    });

    var ComBoWay = new Ext.form.ComboBox({
        store: ComBoWayDs,
        displayField: 'waydesc',
        mode: 'local',
        width: 150,
        id: 'waycomb',
        emptyText: '',
        listWidth: 200,
        valueField: 'wayrowid',
        emptyText: '选择方式...',
        fieldLabel: '方式'
    });

    ComBoWay.on("select",
    function(cmb, rec, id) {

        var way = cmb.getValue();
        LoadTreeDataEvent(way);
        Ext.getCmp("ReaCodeTxt").setValue("");
        Ext.getCmp("ReaDescTxt").setValue("");
    });

    // 创建一个简写
    var Tree = Ext.tree;

    // 定义根节点的Loader
    var treeloader = new Tree.TreeLoader({

        dataUrl: unitsUrl + '?action=ListTreeData'

    });

    // 添加一个树形面板
    var treepanel = new Tree.TreePanel({

        tbar: ['方式:', ComBoWay],

        region: 'west',

        title: '不合格原因维护',

        width: 300,

        split: true,

        frame: true,

        autoScroll: true,

        containerScroll: true,

        rootVisible: true,

        loader: treeloader

    });

    // 异步加载根节点
    var rootnode = new Tree.AsyncTreeNode({

        text: "请选择方式",

        id: 'id',

        value: '0',

        level: '0',

        draggable: false,
        // 根节点不容许拖动
        expanded: true

    });

    // 为tree设置根节点
    treepanel.setRootNode(rootnode);

    // 响应加载前事件，传递node参数
    treeloader.on('beforeload',
    function(treeloader, node) {

        if (node == rootnode) {
            node.attributes.id = '0';
        }

        treeloader.baseParams = {
            id: node.attributes.id,
            level: node.attributes.level,
            waycode: Ext.getCmp("waycomb").getValue(),
            actiontype: 'load'
        }

    },
    this);;

    // 设置树的点击事件
    function treeClick(node, e) {
        TreeNodeClickEvent(node.attributes.id);
    }

    // 增加鼠标单击事件
    treepanel.on('click', treeClick);
    var treegridcm = new Ext.grid.ColumnModel({
        columns: [

        {
            header: '代码',
            dataIndex: 'reasoncode',
            width: 130
        },
        {
            header: '描述',
            dataIndex: 'reasondesc',
            width: 430
        },
        {
            header: 'rowid',
            dataIndex: 'reasondrowid',
            width: 40,
            hidden:true
        }

        ]
    });

    var treegridds = new Ext.data.Store({
        proxy: "",
        reader: new Ext.data.JsonReader({
            root: 'rows',
            totalProperty: 'results'
        },
        ['reasoncode', 'reasondesc', 'reasondrowid'

        ]),
        remoteSort: true
    });

    var treegrid = new Ext.grid.GridPanel({
		title:"不合格原因明细列表",
        id: 'treegridID',
        region: 'center',
        width: 650,
        autoScroll: true,
        enableHdMenu: false,
        ds: treegridds,
        cm: treegridcm,
        enableColumnMove: false,
        view: new Ext.ux.grid.BufferView({
            // custom row height
            rowHeight: 25,
            // render rows as they come into viewable area.
            scrollDelay: false

        }),

        //tbar:['代码','-',ReaCodeField,'描述',ReaDescField,'-',ReaLevelField,'-',ReaAddButton,'-',ReaUpdButton,'-',ReaDelButton], 
        tbar: ['代码', ReaCodeField, '描述', ReaDescField, ReaAddButton, '-', ReaUpdButton, '-', ReaDelButton],
        //bbar: treegridcmPagingToolbar,
        trackMouseOver: 'true'
    });
    treegrid.on('rowclick',
    function(grid, rowIndex, e) {
        var selectedRow = treegridds.data.items[rowIndex];
        var reasoncode = selectedRow.data["reasoncode"];
        var reasondesc = selectedRow.data["reasondesc"];
        Ext.getCmp("ReaCodeTxt").setValue(reasoncode);
        Ext.getCmp("ReaDescTxt").setValue(reasondesc);

    });
    ///view
    var por = new Ext.Viewport({

        layout: 'border',
        // 使用border布局
        items: [treepanel, treegrid]

    });

    ///-----------------------Events----------------------

    Ext.getCmp("ReaLevelTxt").setDisabled(true); ///只读

    ///增加原因
    function ReaAddClick() {
        var reasonway = Ext.getCmp("waycomb").getValue();
        if (reasonway == "") {
            Ext.Msg.show({
                title: '提示',
                msg: '请先选择方式!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return;
        }
        
        var reasonlevel = Ext.getCmp("ReaLevelTxt").getValue();
        
        if ((reasonlevel == "")||(reasonlevel == undefined) ){
            Ext.Msg.show({
                title: '提示',
                msg: '请先选择左侧原因!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return;
        }
        
        var reasoncode = Ext.getCmp("ReaCodeTxt").getValue();
        if (reasoncode == "") {
            Ext.Msg.show({
                title: '提示',
                msg: '请先录入代码!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return;
        }

        var reasondesc = Ext.getCmp("ReaDescTxt").getValue();
        if (reasondesc == "") {
            Ext.Msg.show({
                title: '提示',
                msg: '请先录入描述!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return;
        }
       

        

        ///数据库交互
        Ext.Ajax.request({
            url: unitsUrl + '?action=ReaAdd&ReaDesc=' + reasondesc + '&ReaLevel=' + reasonlevel + '&ReaCode=' + reasoncode + '&ReaWayCode=' + reasonway,
            waitMsg: '删除中...',
            failure: function(result, request) {
                Ext.Msg.show({
                    title: '错误',
                    msg: '请检查网络连接!',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });
            },
            success: function(result, request) {
                var jsonData = Ext.util.JSON.decode(result.responseText);
                if (jsonData.retvalue == 0) {
                    Ext.Msg.show({
                        title: '提示',
                        msg: '保存成功!',
                        buttons: Ext.Msg.OK,
                        icon: Ext.MessageBox.INFO
                    });
                    QueryReasonByLevel(reasonlevel, reasonway);
                    LoadTreeDataEvent(reasonway);
                } else {
                    if (jsonData.retvalue == -99) {
                        Ext.Msg.alert("提示", "代码已存在,不能增加!");
                    } else if (jsonData.retvalue == -98) {
                        Ext.Msg.alert("提示", "描述已存在,不能增加!");
                    } else {
                        Ext.Msg.alert("提示", "保存失败!返回值: " + jsonData.retinfo);
                    }

                }
            },

            scope: this
        });

    }

    ///根据结点分级查找原因数据
    function QueryReasonByLevel(reasonlevel, reasonway) {
        treegridds.removeAll();
        treegridds.proxy = new Ext.data.HttpProxy({
            url: unitsUrl + '?action=QueryReasonByLevel&ReaLevel=' + reasonlevel + '&ReaWayCode=' + reasonway
        });
        treegridds.load({
            callback: function(r, options, success) {
                if (success == false) {
                    Ext.Msg.show({
                        title: '注意',
                        msg: '查询失败 !',
                        buttons: Ext.Msg.OK,
                        icon: Ext.MessageBox.INFO
                    });
                }
            }
        });
        Ext.getCmp("ReaCodeTxt").setValue("");
        Ext.getCmp("ReaDescTxt").setValue("");
    }

    ///树的单击结点的事件
    function TreeNodeClickEvent(nodelevel) {

        var way = Ext.getCmp("waycomb").getValue();
        if (way == "") {
            Ext.Msg.show({
                title: '注意',
                msg: '请先选择方式 !',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return;
        }
        Ext.getCmp("ReaLevelTxt").setValue(nodelevel);
        QueryReasonByLevel(nodelevel, way);

    }

    ///修改原因的事件
    function ReaUpdClick() {
        var row = Ext.getCmp("treegridID").getSelectionModel().getSelections();
        if (row.length == 0) {
            Ext.Msg.show({
                title: '提示',
                msg: '未选中记录!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return;
        }
        var reasonID = row[0].data.reasondrowid; //原因ID       
        var reasondesc = Ext.getCmp("ReaDescTxt").getValue(); //描述
        var reasonlevel = Ext.getCmp("ReaLevelTxt").getValue(); //分级
        var reasoncode = Ext.getCmp("ReaCodeTxt").getValue();
        if (reasoncode == "") {
            Ext.Msg.show({
                title: '提示',
                msg: '请先录入代码!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return;
        }
        if (reasondesc == "") {
            Ext.Msg.show({
                title: '提示',
                msg: '请先录入描述!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return;
        }
        reasonway = Ext.getCmp("waycomb").getValue();
        ///数据库交互
        Ext.Ajax.request({
            url: unitsUrl + '?action=ReaUpd&ReaDesc=' + reasondesc + '&ReasonID=' + reasonID + '&ReaCode=' + reasoncode,
            waitMsg: '更新中...',
            failure: function(result, request) {
                Ext.Msg.show({
                    title: '错误',
                    msg: '请检查网络连接!',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });
            },
            success: function(result, request) {
                var jsonData = Ext.util.JSON.decode(result.responseText);
                if (jsonData.retvalue == 0) {
                    Ext.Msg.show({
                        title: '提示',
                        msg: '保存成功!',
                        buttons: Ext.Msg.OK,
                        icon: Ext.MessageBox.INFO
                    });
                    QueryReasonByLevel(reasonlevel, reasonway);
                    LoadTreeDataEvent(reasonway);
                } else if (jsonData.retvalue == -99) {
                    Ext.Msg.alert("提示", "修改后代码已存在,不能修改!");
                } else if (jsonData.retvalue = -98) {
                    Ext.Msg.alert("提示", "修改后描述已存在,不能修改!");
                } else {
                    Ext.Msg.alert("提示", "保存失败!返回值: " + jsonData.retinfo);
                }
            },
            scope: this
        });
    }

    ///修改原因的事件
    function ReaDelClick() {
        var row = Ext.getCmp("treegridID").getSelectionModel().getSelections();
        if (row.length == 0) {
            Ext.Msg.show({
                title: '提示',
                msg: '未选中记录!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return;
        }
        Ext.MessageBox.confirm('注意', '确认要删除吗 ? ', DelClickResult);
    }
    ///删除确认动作
    function DelClickResult(btn) {
        if (btn == "no") {
            return;
        }
        var row = Ext.getCmp("treegridID").getSelectionModel().getSelections();
        var reasonID = row[0].data.reasondrowid; //原因ID       
        var reasondesc = Ext.getCmp("ReaDescTxt").getValue(); //描述
        var reasonlevel = Ext.getCmp("ReaLevelTxt").getValue(); //分级
        var reasonway = Ext.getCmp("waycomb").getValue();
        ///数据库交互删除
        Ext.Ajax.request({
            //url:unitsUrl+'?action=ReaDel&ReasonID='+reasonID ,
            url: unitsUrl + '?action=ReaDel&ReasonID=' + reasonID + '&ReaLevel=' + reasonlevel + '&ReaWayCode=' + reasonway,
            waitMsg: '删除中...',
            failure: function(result, request) {
                Ext.Msg.show({
                    title: '错误',
                    msg: '请检查网络连接!',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });
            },
            success: function(result, request) {
                var jsonData = Ext.util.JSON.decode(result.responseText);
                if (jsonData.retvalue == 0) {
                    Ext.Msg.show({
                        title: '提示',
                        msg: '删除成功!',
                        buttons: Ext.Msg.OK,
                        icon: Ext.MessageBox.INFO
                    });
                    QueryReasonByLevel(reasonlevel, reasonway);
                    LoadTreeDataEvent(reasonway);
                } else {
                    Ext.Msg.alert("提示", "删除失败!返回值: " + jsonData.retinfo);

                }
            },
            scope: this
        });

    }
    //重新加载树	
    function LoadTreeDataEvent(way) {
        treepanel.getLoader().load(treepanel.getRootNode(),
        function(treeNode) {});
        treepanel.expandAll();
        rootnode.setText(Ext.getCmp("waycomb").getRawValue());
    }
});