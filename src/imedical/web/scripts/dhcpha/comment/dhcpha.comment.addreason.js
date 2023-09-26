///description:��������-�����������--����ԭ��ά��
var unitsUrl = 'dhcpha.comment.addreason.save.csp';
Ext.onReady(function() {

    Ext.QuickTips.init(); // ������Ϣ��ʾ
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

    var ReaAddButton = new Ext.Button({
        width: 65,
        id: "ReaAddBtn",
        text: '����',
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
        text: '�޸�',
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
        text: 'ɾ��',
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

        fieldLabel: "����"
    })

    var ReaDescField = new Ext.form.TextField({

        width: 400,
        id: "ReaDescTxt",

        fieldLabel: "ԭ������"
    })

    var ReaLevelField = new Ext.form.TextField({

        width: 30,
        id: "ReaLevelTxt",
        fieldLabel: "ԭ��ּ�"
    })

    ///���ϸ�ʽ
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
        emptyText: 'ѡ��ʽ...',
        fieldLabel: '��ʽ'
    });

    ComBoWay.on("select",
    function(cmb, rec, id) {

        var way = cmb.getValue();
        LoadTreeDataEvent(way);
        Ext.getCmp("ReaCodeTxt").setValue("");
        Ext.getCmp("ReaDescTxt").setValue("");
    });

    // ����һ����д
    var Tree = Ext.tree;

    // ������ڵ��Loader
    var treeloader = new Tree.TreeLoader({

        dataUrl: unitsUrl + '?action=ListTreeData'

    });

    // ���һ���������
    var treepanel = new Tree.TreePanel({

        tbar: ['��ʽ:', ComBoWay],

        region: 'west',

        title: '���ϸ�ԭ��ά��',

        width: 300,

        split: true,

        frame: true,

        autoScroll: true,

        containerScroll: true,

        rootVisible: true,

        loader: treeloader

    });

    // �첽���ظ��ڵ�
    var rootnode = new Tree.AsyncTreeNode({

        text: "��ѡ��ʽ",

        id: 'id',

        value: '0',

        level: '0',

        draggable: false,
        // ���ڵ㲻�����϶�
        expanded: true

    });

    // Ϊtree���ø��ڵ�
    treepanel.setRootNode(rootnode);

    // ��Ӧ����ǰ�¼�������node����
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

    // �������ĵ���¼�
    function treeClick(node, e) {
        TreeNodeClickEvent(node.attributes.id);
    }

    // ������굥���¼�
    treepanel.on('click', treeClick);
    var treegridcm = new Ext.grid.ColumnModel({
        columns: [

        {
            header: '����',
            dataIndex: 'reasoncode',
            width: 130
        },
        {
            header: '����',
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
		title:"���ϸ�ԭ����ϸ�б�",
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

        //tbar:['����','-',ReaCodeField,'����',ReaDescField,'-',ReaLevelField,'-',ReaAddButton,'-',ReaUpdButton,'-',ReaDelButton], 
        tbar: ['����', ReaCodeField, '����', ReaDescField, ReaAddButton, '-', ReaUpdButton, '-', ReaDelButton],
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
        // ʹ��border����
        items: [treepanel, treegrid]

    });

    ///-----------------------Events----------------------

    Ext.getCmp("ReaLevelTxt").setDisabled(true); ///ֻ��

    ///����ԭ��
    function ReaAddClick() {
        var reasonway = Ext.getCmp("waycomb").getValue();
        if (reasonway == "") {
            Ext.Msg.show({
                title: '��ʾ',
                msg: '����ѡ��ʽ!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return;
        }
        
        var reasonlevel = Ext.getCmp("ReaLevelTxt").getValue();
        
        if ((reasonlevel == "")||(reasonlevel == undefined) ){
            Ext.Msg.show({
                title: '��ʾ',
                msg: '����ѡ�����ԭ��!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return;
        }
        
        var reasoncode = Ext.getCmp("ReaCodeTxt").getValue();
        if (reasoncode == "") {
            Ext.Msg.show({
                title: '��ʾ',
                msg: '����¼�����!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return;
        }

        var reasondesc = Ext.getCmp("ReaDescTxt").getValue();
        if (reasondesc == "") {
            Ext.Msg.show({
                title: '��ʾ',
                msg: '����¼������!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return;
        }
       

        

        ///���ݿ⽻��
        Ext.Ajax.request({
            url: unitsUrl + '?action=ReaAdd&ReaDesc=' + reasondesc + '&ReaLevel=' + reasonlevel + '&ReaCode=' + reasoncode + '&ReaWayCode=' + reasonway,
            waitMsg: 'ɾ����...',
            failure: function(result, request) {
                Ext.Msg.show({
                    title: '����',
                    msg: '������������!',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });
            },
            success: function(result, request) {
                var jsonData = Ext.util.JSON.decode(result.responseText);
                if (jsonData.retvalue == 0) {
                    Ext.Msg.show({
                        title: '��ʾ',
                        msg: '����ɹ�!',
                        buttons: Ext.Msg.OK,
                        icon: Ext.MessageBox.INFO
                    });
                    QueryReasonByLevel(reasonlevel, reasonway);
                    LoadTreeDataEvent(reasonway);
                } else {
                    if (jsonData.retvalue == -99) {
                        Ext.Msg.alert("��ʾ", "�����Ѵ���,��������!");
                    } else if (jsonData.retvalue == -98) {
                        Ext.Msg.alert("��ʾ", "�����Ѵ���,��������!");
                    } else {
                        Ext.Msg.alert("��ʾ", "����ʧ��!����ֵ: " + jsonData.retinfo);
                    }

                }
            },

            scope: this
        });

    }

    ///���ݽ��ּ�����ԭ������
    function QueryReasonByLevel(reasonlevel, reasonway) {
        treegridds.removeAll();
        treegridds.proxy = new Ext.data.HttpProxy({
            url: unitsUrl + '?action=QueryReasonByLevel&ReaLevel=' + reasonlevel + '&ReaWayCode=' + reasonway
        });
        treegridds.load({
            callback: function(r, options, success) {
                if (success == false) {
                    Ext.Msg.show({
                        title: 'ע��',
                        msg: '��ѯʧ�� !',
                        buttons: Ext.Msg.OK,
                        icon: Ext.MessageBox.INFO
                    });
                }
            }
        });
        Ext.getCmp("ReaCodeTxt").setValue("");
        Ext.getCmp("ReaDescTxt").setValue("");
    }

    ///���ĵ��������¼�
    function TreeNodeClickEvent(nodelevel) {

        var way = Ext.getCmp("waycomb").getValue();
        if (way == "") {
            Ext.Msg.show({
                title: 'ע��',
                msg: '����ѡ��ʽ !',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return;
        }
        Ext.getCmp("ReaLevelTxt").setValue(nodelevel);
        QueryReasonByLevel(nodelevel, way);

    }

    ///�޸�ԭ����¼�
    function ReaUpdClick() {
        var row = Ext.getCmp("treegridID").getSelectionModel().getSelections();
        if (row.length == 0) {
            Ext.Msg.show({
                title: '��ʾ',
                msg: 'δѡ�м�¼!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return;
        }
        var reasonID = row[0].data.reasondrowid; //ԭ��ID       
        var reasondesc = Ext.getCmp("ReaDescTxt").getValue(); //����
        var reasonlevel = Ext.getCmp("ReaLevelTxt").getValue(); //�ּ�
        var reasoncode = Ext.getCmp("ReaCodeTxt").getValue();
        if (reasoncode == "") {
            Ext.Msg.show({
                title: '��ʾ',
                msg: '����¼�����!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return;
        }
        if (reasondesc == "") {
            Ext.Msg.show({
                title: '��ʾ',
                msg: '����¼������!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return;
        }
        reasonway = Ext.getCmp("waycomb").getValue();
        ///���ݿ⽻��
        Ext.Ajax.request({
            url: unitsUrl + '?action=ReaUpd&ReaDesc=' + reasondesc + '&ReasonID=' + reasonID + '&ReaCode=' + reasoncode,
            waitMsg: '������...',
            failure: function(result, request) {
                Ext.Msg.show({
                    title: '����',
                    msg: '������������!',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });
            },
            success: function(result, request) {
                var jsonData = Ext.util.JSON.decode(result.responseText);
                if (jsonData.retvalue == 0) {
                    Ext.Msg.show({
                        title: '��ʾ',
                        msg: '����ɹ�!',
                        buttons: Ext.Msg.OK,
                        icon: Ext.MessageBox.INFO
                    });
                    QueryReasonByLevel(reasonlevel, reasonway);
                    LoadTreeDataEvent(reasonway);
                } else if (jsonData.retvalue == -99) {
                    Ext.Msg.alert("��ʾ", "�޸ĺ�����Ѵ���,�����޸�!");
                } else if (jsonData.retvalue = -98) {
                    Ext.Msg.alert("��ʾ", "�޸ĺ������Ѵ���,�����޸�!");
                } else {
                    Ext.Msg.alert("��ʾ", "����ʧ��!����ֵ: " + jsonData.retinfo);
                }
            },
            scope: this
        });
    }

    ///�޸�ԭ����¼�
    function ReaDelClick() {
        var row = Ext.getCmp("treegridID").getSelectionModel().getSelections();
        if (row.length == 0) {
            Ext.Msg.show({
                title: '��ʾ',
                msg: 'δѡ�м�¼!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.INFO
            });
            return;
        }
        Ext.MessageBox.confirm('ע��', 'ȷ��Ҫɾ���� ? ', DelClickResult);
    }
    ///ɾ��ȷ�϶���
    function DelClickResult(btn) {
        if (btn == "no") {
            return;
        }
        var row = Ext.getCmp("treegridID").getSelectionModel().getSelections();
        var reasonID = row[0].data.reasondrowid; //ԭ��ID       
        var reasondesc = Ext.getCmp("ReaDescTxt").getValue(); //����
        var reasonlevel = Ext.getCmp("ReaLevelTxt").getValue(); //�ּ�
        var reasonway = Ext.getCmp("waycomb").getValue();
        ///���ݿ⽻��ɾ��
        Ext.Ajax.request({
            //url:unitsUrl+'?action=ReaDel&ReasonID='+reasonID ,
            url: unitsUrl + '?action=ReaDel&ReasonID=' + reasonID + '&ReaLevel=' + reasonlevel + '&ReaWayCode=' + reasonway,
            waitMsg: 'ɾ����...',
            failure: function(result, request) {
                Ext.Msg.show({
                    title: '����',
                    msg: '������������!',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.ERROR
                });
            },
            success: function(result, request) {
                var jsonData = Ext.util.JSON.decode(result.responseText);
                if (jsonData.retvalue == 0) {
                    Ext.Msg.show({
                        title: '��ʾ',
                        msg: 'ɾ���ɹ�!',
                        buttons: Ext.Msg.OK,
                        icon: Ext.MessageBox.INFO
                    });
                    QueryReasonByLevel(reasonlevel, reasonway);
                    LoadTreeDataEvent(reasonway);
                } else {
                    Ext.Msg.alert("��ʾ", "ɾ��ʧ��!����ֵ: " + jsonData.retinfo);

                }
            },
            scope: this
        });

    }
    //���¼�����	
    function LoadTreeDataEvent(way) {
        treepanel.getLoader().load(treepanel.getRootNode(),
        function(treeNode) {});
        treepanel.expandAll();
        rootnode.setText(Ext.getCmp("waycomb").getRawValue());
    }
});