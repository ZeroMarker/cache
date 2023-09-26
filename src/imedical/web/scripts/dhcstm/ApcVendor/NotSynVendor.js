// ����:��Ӧ�̹���
// ��д����:2012-05-14

//=========================��Ӧ�����=============================
var currVendorRowId='';

var userId = session['LOGON.USERID'];
    var groupId = session['LOGON.GROUPID'];
    var locId = session['LOGON.CTLOCID'];
    var RParam=groupId+"^"+locId+"^"+userId
    function GetParam(){
        var gParam=""
        var url = 'dhcstm.ftpcommon.csp?actiontype=GetParamProp&GroupId=' + groupId
                + '&LocId=' + locId + '&UserId=' + userId;
        var response = ExecuteDBSynAccess(url);
        var jsonData = Ext.util.JSON.decode(response);
        if (jsonData.success == 'true') {
            var info = jsonData.info;
            if (info != null || info != '') {
                gParam = info.split('^');
            }
        }
    
        return gParam;
    }
    var gParam=GetParam()
    var ftpsrc = "http://" + gParam[5];
    
    var picSrc="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"
   
    var PicUrl = 'dhcstm.synpicaction.csp?actiontype=QuerySynNotAuditVendorPic';
    // ͨ��AJAX��ʽ���ú�̨����
    var proxy = new Ext.data.HttpProxy({
                url : PicUrl,
                method : "POST"
                });
            // ָ���в���
    var fields = ["rowid","picsrc","imgtype"];
            // ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
    var reader = new Ext.data.JsonReader({
                root : 'rows',
                totalProperty : "results",
                fields : fields
                });
    // ���ݼ�
    var PicStore = new Ext.data.Store({
                    proxy : proxy,
                    reader : reader
                    });

    var picTpl = new Ext.XTemplate(
        '<tpl for=".">',
            '<div style="padding:5px; height:230px; width:210px; float:left;" class="select_pic" >',
                '<img  class="pic" src="' + ftpsrc + '{picsrc}"style="height:210; width:210;"position: relative;>',
                '<p><font color=blue size="2">{imgtype}</font></p>',
            '</div>',
        '</tpl>'
    );

    var picView = new Ext.DataView({
        store : PicStore,
        tpl : picTpl,
        frame : true,
        singleSelect : true,
        autoScroll:true,
        trackOver : true,
        selectedClass : 'selected-pic',
        overClass : 'over-pic',
        itemSelector : 'div.select_pic',
        emptyText : 'û��Ҫ��ʾ������ͼƬ',
        listeners : {
            'dblclick' : function(v, r) {
            var src = PicStore.getAt(r).get('picsrc')
            var type=PicStore.getAt(r).get('imgtype')
            var allsrc = ftpsrc + src;
            var image = new Image();
            image.src = ftpsrc + src;
            //document.body.appendChild(image); //����ͼƬ
            var OpenWindow=window.open(allsrc,"",'height='+(image.height+30)+',width='+(image.width+30)+',resizable=yes,scrollbars=yes,status =yes')
            }
        }
    });
    

var conditionCodeField = new Ext.form.TextField({
    id:'conditionCodeField',
    fieldLabel:'��Ӧ�̴���',
    allowBlank:true,
    //width:180,
    listWidth:180,
    //emptyText:'��Ӧ�̴���...',
    anchor:'90%',
    selectOnFocus:true
});
    
var conditionNameField = new Ext.form.TextField({
    id:'conditionNameField',
    fieldLabel:'��Ӧ������',
    allowBlank:true,
    //width:150,
    listWidth:150,
    //emptyText:'��Ӧ������...',
    anchor:'90%',
    selectOnFocus:true
});


//��������Դ
var APCVendorGridUrl = 'dhcstm.synpicaction.csp';
var APCVendorGridProxy= new Ext.data.HttpProxy({url:APCVendorGridUrl+'?actiontype=QuerySynNotAuditVendor',method:'POST'});
var APCVendorGridDs = new Ext.data.Store({
    proxy:APCVendorGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
        totalProperty:'results',
        pageSize:35
    }, [
        {name:'rowid'},
        {name:'code'},
        {name:'desc'}
    ]),
    remoteSort:false
});

//ģ��
var APCVendorGridCm = new Ext.grid.ColumnModel([
     //new Ext.grid.RowNumberer(),
    {
        header:"����",
        dataIndex:'desc',
        width:190,
        align:'left',
        sortable:true
    }
]);

//��������Դ
var DetailGridUrl = 'dhcstm.synpicaction.csp';
var DetailGridProxy= new Ext.data.HttpProxy({url:APCVendorGridUrl+'?actiontype=QuerySynNotAuditVendorDetail',method:'POST'});
var DetailGridDs = new Ext.data.Store({
    proxy:DetailGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
        totalProperty:'results',
        pageSize:35
    }, [
        {name:'rowid'},
        {name:'desc'},
        {name:'regno'},
        {name:'regdate'},
        {name:'type'}
    ]),
    remoteSort:false
});

//ģ��
var DetailGridCm = new Ext.grid.ColumnModel([
     //new Ext.grid.RowNumberer(),
    {
        header:"rowid",
        dataIndex:'rowid',
        width:100,
        align:'left',
        hidden:'true',
        sortable:true
    },{
        header:"����",
        dataIndex:'desc',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"֤����",
        dataIndex:'regno',
        width:180,
        align:'left',
        sortable:true
    },{
        header:"����",
        dataIndex:'regdate',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"����",
        dataIndex:'type',
        width:80,
        hidden:'true',
        align:'left',
        sortable:true
    }
]);



var findAPCVendor = new Ext.Toolbar.Button({
	text:'��ѯ',
	tooltip:'��ѯ',
	iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		APCVendorGridDs.removeAll();
		APCVendorGridDs.load({params:{others:""}});
	}
});
var CheckBT = new Ext.Toolbar.Button({
                    id:'CheckBT',
                    text : '���ȷ��',
                    tooltip : '������ȷ��',
                    width : 70,
                    height : 30,
                    iconCls : 'page_gear',
                    handler : function() {
                        Audit();
                    }
                });
var RefuseBT = new Ext.Toolbar.Button({
                    id:'RefuseBT',
                    text : '�ܾ�',
                    tooltip : '����ܾ�',
                    width : 70,
                    height : 30,
                    iconCls : 'page_gear',
                    
                    handler : function() {
                        Refuse();
                    }
                });
function Audit(){
     var rowData=DetailGrid.getSelectionModel().getSelected();
            if (rowData ==null) {
                Msg.info("warning", "��ѡ����Ҫ��˵�֤��!");
                return;
            }
            
            var rowid = rowData.get("rowid");
            var type=rowData.get("type");
            var loadMask=ShowLoadMask(document.body,"�����...");
            var url ="dhcstm.synpicaction.csp?actiontype=AuditV&rowid="
                    + rowid+"&type="+type;

            Ext.Ajax.request({
                        url : url,
                        method : 'POST',
                        waitMsg : '��ѯ��...',
                        success : function(result, request) {
                            var jsonData = Ext.util.JSON
                                    .decode(result.responseText);
                            loadMask.hide();
                            if (jsonData.success == 'true') {
                                Msg.info("success", "��˳ɹ�!");
                                DetailGridDs.reload();
                                
                            } else {
                                var Ret=jsonData.info;
                                Msg.info("error", "���ʧ��:"+Ret);
                                
                                
                            }
                        },
                        scope : this
                    });
}
function Refuse(){
     var rowData=DetailGrid.getSelectionModel().getSelected();
            if (rowData ==null) {
                Msg.info("warning", "��ѡ����Ҫ�ܾ���֤��!");
                return;
            }
            
            var rowid = rowData.get("rowid");
            var type=rowData.get("type");
            var loadMask=ShowLoadMask(document.body,"�ܾ���...");
            var url ="dhcstm.synpicaction.csp?actiontype=RefuseV&rowid="
                    + rowid+"&type="+type;

            Ext.Ajax.request({
                        url : url,
                        method : 'POST',
                        waitMsg : '��ѯ��...',
                        success : function(result, request) {
                            var jsonData = Ext.util.JSON
                                    .decode(result.responseText);
                            loadMask.hide();
                            if (jsonData.success == 'true') {
                                Msg.info("success", "�ܾ��ɹ�!");
                                DetailGridDs.reload();
                                
                            } else {
                                var Ret=jsonData.info;
                                Msg.info("error", "�ܾ�ʧ��:"+Ret);
                                
                                
                            }
                        },
                        scope : this
                    });
}
var formPanel = new Ext.ux.FormPanel({
	title :' ��Ӧ���������',
	labelAlign : 'right',
	tbar : [findAPCVendor],
	items : [{
		xtype : 'fieldset',
		title : '��ѯ����',
		layout : 'column',
		items : [{
			columnWidth : .25,
			layout : 'form',
			items : [conditionCodeField]
		},{
			columnWidth : .25,
			layout : 'form',
			items : [conditionNameField]
		}]
	}]
});



//���
APCVendorGrid =new Ext.grid.GridPanel({
    store:APCVendorGridDs,
    cm:APCVendorGridCm,
    title:'��Ӧ����ϸ',
    trackMouseOver:true,
    region:'north',
    height:200,
    stripeRows:true,
    sm : new Ext.grid.RowSelectionModel({
                                singleSelect : true
                            }),
    loadMask:true
});
APCVendorGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
                    var rowData = APCVendorGridDs.data.items[rowIndex];
                    var vid = rowData.get("rowid");
                    DetailGridDs.removeAll();
                    DetailGridDs.load({params:{others:vid}});
});
DetailGrid = new Ext.grid.GridPanel({
	store:DetailGridDs,
	cm:DetailGridCm,
	title:'��ϸ',
	trackMouseOver:true,
	tbar:[CheckBT,'-',RefuseBT],
	region:'center',
	stripeRows:true,
	sm : new Ext.grid.RowSelectionModel({
		singleSelect : true
	}),
	loadMask:true
});

DetailGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
	var rowData = DetailGridDs.data.items[rowIndex];
	var type = rowData.get("type");
	PicStore.removeAll();
	PicStore.load({params:{others:type}});
});

APCVendorGridDs.load({params:{others:""}});

Ext.onReady(function(){
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

    var panel2 = new Ext.Panel({
        width:'400',
        region:'west',
        layout:'border',
        items:[APCVendorGrid,DetailGrid]                                 
    });
     var panel3 = new Ext.Panel({
        title:'ͼƬ',
        region:'center',
        items:[picView]
    });
    var mainPanel = new Ext.ux.Viewport({
        layout:'border',
        items:[formPanel,panel2,panel3],
        renderTo:'mainPanel'
    });
});
