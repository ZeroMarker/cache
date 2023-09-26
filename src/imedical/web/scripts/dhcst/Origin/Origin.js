// ����:���ع���
// ��д����:2012-05-10

var OriginGridUrl = 'dhcst.originaction.csp';
GetParamCommon();
var conditionCodeField = new Ext.form.TextField({
    id:'conditionCodeField',
    fieldLabel:'����',
    allowBlank:true,
    emptyText:'����...',
    anchor:'90%',
    selectOnFocus:true
});
var conditionDescField = new Ext.form.TextField({
    id:'conditionDescField',
    fieldLabel:'����',
    allowBlank:true,
    emptyText:'����...',
    anchor:'90%',
    selectOnFocus:true
});

var conditionAliasField = new Ext.form.TextField({
    id:'conditionAliasField',
    fieldLabel:'����',
    allowBlank:true,
    emptyText:'����...',
    anchor:'90%',
    selectOnFocus:true
});

var conditionHospField = new Ext.ux.ComboBox({
	fieldLabel : 'ҽԺ',
	id : 'conditionHospField',
	store : HospStore,
	allowBlank:true,
	emptyText:'ҽԺ...',
	anchor:'90%',
	selectOnFocus:true,
	hidden:true
});

var HospGirdField = new Ext.ux.ComboBox({
	fieldLabel : 'ҽԺ',
	id : 'HospGirdField',
	store : HospStore,
	listeners:{
		specialKey:function(field, e) {
			if(e.getKey() == Ext.EventObject.ENTER){
				addNewRow();
			}
		}
	}
});
 
function addNewRow() {
    var record = Ext.data.Record.create([
        {
            name : 'RowId',
            type : 'int'
        }, {
            name : 'Code',
            type : 'string'
        }, {
            name : 'Desc',
            type : 'string'
        }, {
            name : 'Alias',
            type : 'string'
        }, {
            name : 'HospId',
            type : 'string'
        },{
	    	name : 'HospDesc' ,
	    	type : 'string'
	    }
    ]);
                    
    var NewRecord = new record({
        RowId:'',
        Code:'',
        Desc:'',
        Alias:'',
        HospId:'',
        HospDesc:''
    });        
    OriginGridDs.add(NewRecord);
	var lastRow = OriginGridDs.getCount() - 1;
	if ( gParamCommon[6]!=2){
		var rowData = OriginGrid.getStore().getAt(lastRow);
		addComboData(HospGirdField.getStore(),session['LOGON.HOSPID'],App_LogonHospDesc);
		rowData.set("HospId", session['LOGON.HOSPID']); 
	}  
    OriginGrid.startEditing(OriginGridDs.getCount() - 1, 1);
}
    
var OriginGrid="";
//��������Դ
var OriginGridProxy= new Ext.data.HttpProxy({url:OriginGridUrl+'?actiontype=query',method:'POST'});
var OriginGridDs = new Ext.data.Store({
    proxy:OriginGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
        totalProperty:'results',
        pageSize:30
    }, [
        {name:'RowId'},
        {name:'Code'},       
        {name:'Desc'},
        {name:'Alias'},
        {name:'HospId'},
        {name:'HospDesc'} 
        
    ]),
    remoteSort:false,
    pruneModifiedRecords:true
});

//ģ��
var OriginGridCm = new Ext.grid.ColumnModel([
     new Ext.grid.RowNumberer(),
     {
        header:"����",
        dataIndex:'Code',
        width:180,
        align:'left',
        sortable:true,
        editor: new Ext.form.TextField({
            id:'codeField',
            allowBlank:false,
            listeners:{
                specialKey:function(field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        OriginGrid.startEditing(OriginGridDs.getCount() - 1, 2);
                    }
                }
            }
        })
    },{
        header:"����",
        dataIndex:'Desc',
        width:300,
        align:'left',
        sortable:true,
        editor: new Ext.form.TextField({
            id:'descField',
            allowBlank:false,
            listeners:{
                specialKey:function(field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        OriginGrid.startEditing(OriginGridDs.getCount() - 1, 3);
                    }
                }
            }
        })
    },{
        header:"����",
        dataIndex:'Alias',
        width:300,
        align:'left',
        sortable:true,
        editor: new Ext.form.TextField({
            id:'aliasField',
            allowBlank:true,
            listeners:{
                specialKey:function(field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        OriginGrid.startEditing(OriginGridDs.getCount() - 1, 4);
                    }
                }
            }
        })
    },{
        header:"ҽԺ",
        dataIndex:'HospId',
        width:300,
        align:'left',
        sortable:true,
		hidden:true,
        editor: new Ext.grid.GridEditor(HospGirdField),
		renderer:Ext.util.Format.comboRenderer2(HospGirdField,'HospId','HospDesc')
	}  
]);

//��ʼ��Ĭ��������
OriginGridCm.defaultSortable = true;

var findOrigin = new Ext.Toolbar.Button({
    text:'��ѯ',
    tooltip:'��ѯ',
    iconCls:'page_find',
    width : 70,
    height : 30,
    handler:function(){
	    QueryOrigin();
    }
});

var addOrigin = new Ext.Toolbar.Button({
    text:'�½�',
    tooltip:'�½�',
    iconCls:'page_add',
    width : 70,
    height : 30,
    handler:function(){
        addNewRow();
    }
});

var saveOrigin = new Ext.Toolbar.Button({
    text:'����',
    tooltip:'����',
    iconCls:'page_save',
    width : 70,
    height : 30,
    handler:function(){
        //��ȡ���е��¼�¼ 
        var mr=OriginGridDs.getModifiedRecords();
        var data="";
        for(var i=0;i<mr.length;i++){
            var code = mr[i].data["Code"].trim();
            var desc = mr[i].data["Desc"].trim();
            var type = App_StkTypeCode;
            var alias = mr[i].data["Alias"].trim();
            var hospId=mr[i].data["HospId"].trim();
            if (code==""){
	             Msg.info("warning", "����Ϊ��");
            	return false;       
	        }
	        if (desc==""){
		       	Msg.info("warning", "����Ϊ��");
            	return false;
		    }
            if((code!="")&&(desc!="")){
                var dataRow = mr[i].data["RowId"]+"^"+code+"^"+desc+"^"+type+"^"+alias+"^"+hospId;
                if(data==""){
                    data = dataRow;
                }else{
                    data = data+xRowDelim()+dataRow;
                }
            }
        }
        
        if(data==""){
            Msg.info("error", "û���޸Ļ����������!");
            return false;
        }else{
            Ext.Ajax.request({
                url: OriginGridUrl+'?actiontype=save',
                params: {data:data},
                failure: function(result, request) {
                    Msg.info("error", "������������!");
                },
                success: function(result, request) {
                    var jsonData = Ext.util.JSON.decode( result.responseText );
                    if (jsonData.success=='true') {
                        Msg.info("success", "����ɹ�!");
                        OriginGridDs.load({params:{start:0,limit:OriginPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionDesc:Ext.getCmp('conditionDescField').getValue(),conditionType:App_StkTypeCode}});
                    }else{
                        Msg.info("error", "����ʧ��!" +jsonData.info);
                        //OriginGridDs.load({params:{start:0,limit:OriginPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionDesc:Ext.getCmp('conditionDescField').getValue(),conditionType:App_StkTypeCode}});
                    }
                },
                scope: this
            });
        }
    }
});

var saveAsOrigin = new Ext.Toolbar.Button({
	text:'���',
	iconCls:'page_excel',
	handler:function(){
		ExportAllToExcel(OriginGrid);
	}
});


var deleteOrigin = new Ext.Toolbar.Button({
    text:'ɾ��',
    tooltip:'ɾ��',
    iconCls:'page_delete',
    width : 70,
    height : 30,
    handler:function(){
        var cell = OriginGrid.getSelectionModel().getSelectedCell();
        if(cell==null){
            Msg.info("error", "��ѡ������!");
            return false;
        }else{
            var record = OriginGrid.getStore().getAt(cell[0]);
            var RowId = record.get("RowId");
            if(RowId!=""){
                Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
                    function(btn) {
                        if(btn == 'yes'){
                            Ext.Ajax.request({
                                url:OriginGridUrl+'?actiontype=delete&rowid='+RowId,
                                waitMsg:'ɾ����...',
                                failure: function(result, request) {
                                    Msg.info("error", "������������!");
                                },
                                success: function(result, request) {
                                    var jsonData = Ext.util.JSON.decode( result.responseText );
                                    if (jsonData.success=='true') {
                                        Msg.info("success", "ɾ���ɹ�!");
                                        OriginGridDs.load({params:{start:0,limit:OriginPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionDesc:Ext.getCmp('conditionDescField').getValue(),conditionType:App_StkTypeCode}});
                                    }else{
                                        if(jsonData.info==-1){
                                            Msg.info("error", "������ҩƷ������ʹ�ù�������ɾ��!");
                                        }else{
                                            Msg.info("error", "ɾ��ʧ��!");
                                        }
                                    }
                                },
                                scope: this
                            });
                        }
                    }
                )
            }else{
                Msg.info("error", "�����д�,û��RowId!");
            }
        }
    }
});

var HospWinButton = GenHospWinButton("PH_Manufacturer");

//�󶨵���¼�
HospWinButton.on("click" , function(){
	var cell = OriginGrid.getSelectionModel().getSelectedCell();
	if(cell==null){
		Msg.info("warning", "��ѡ������!");
		return;
	}
	var record = OriginGrid.getStore().getAt(cell[0]);
	var rowID = record.get("RowId");
	if (rowID===''){
		Msg.info("warning","���ȱ�������!");
		return;	
	}
    GenHospWin("DHC_STOrigin",rowID,function(){OriginGridDs.reload();}).show() 
});

var HospPanel = InitHospCombo('DHC_STOrigin',function(combo, record, index){
	HospId = this.value; 
	OriginGridDs.reload();
});

var formPanel = new Ext.form.FormPanel({
    labelWidth : 50,
    autoScroll:true,
    labelAlign : 'right',
    frame : true,
    autoScroll : true,
    autoHeight:true,
    tbar:[findOrigin,'-',addOrigin,'-',saveOrigin,'-',saveAsOrigin,'-',HospWinButton],
    items : [{
        xtype : 'fieldset',
        title : '��ѯ����',
        defaults: {border:false},
		style:DHCSTFormStyle.FrmPaddingV,
        layout : 'column',
        items : [{
            columnWidth : .25,
            xtype : 'fieldset',
            items : [conditionCodeField]
        }, {
            columnWidth : .25,
            xtype : 'fieldset',
            items : [conditionDescField]
        }, {
            columnWidth : .25,
            xtype : 'fieldset',
            items : [conditionAliasField]
        }, {
            columnWidth : .25,
            xtype : 'fieldset',
            items : [conditionHospField]
        }]
    }]
});

//��ҳ������
var OriginPagingToolbar = new Ext.PagingToolbar({
    store:OriginGridDs,
    pageSize:35,
    displayInfo:true,
    displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg:"û�м�¼"
});

//���
OriginGrid = new Ext.grid.EditorGridPanel({
    store:OriginGridDs,
    title:'������ϸ',
    cm:OriginGridCm,
    trackMouseOver:true,
    region:'center',
    height:690,
    stripeRows:true,
    sm:new Ext.grid.CellSelectionModel({}),
    loadMask:true,
    bbar:OriginPagingToolbar,
    clicksToEdit:1
});

/// ��ѯ����
function QueryOrigin(){
    var conditionCode = Ext.getCmp('conditionCodeField').getValue();
    var conditionDesc = Ext.getCmp('conditionDescField').getValue();
    var conditionType = App_StkTypeCode;
    var conditionAlias = Ext.getCmp('conditionAliasField').getValue();
    var conditionHosp = Ext.getCmp('conditionHospField').getValue();
    OriginGridDs.load({
	    params:{
		    start:0,
		    limit:OriginPagingToolbar.pageSize,
		    sort:'RowId',dir:'desc',
		    conditionCode:conditionCode,
		    conditionDesc:conditionDesc,
		    conditionType:conditionType,
		    conditionAlias:conditionAlias,
		    conditionHosp:conditionHosp
		},
		callback : function(o,response,success) { 
			if (success == false){  
				Ext.MessageBox.alert("��ѯ����",OriginGridDs.reader.jsonData.Error);  
			}
		}
	});
}

//===========ģ����ҳ��===============================================
Ext.onReady(function(){
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
     var panel = new Ext.Panel({
        title:'����ά��',
        activeTab:0,
        region:'north',
        height:DHCSTFormStyle.FrmHeight(1),
        layout:'fit',
        items:[formPanel]                                 
    });
    
    var mainPanel = new Ext.Viewport({
        layout:'border',
		items:[
			{
				region:'north',
				height:'500px',
				items:[HospPanel,panel]
			},OriginGrid
		],
        renderTo:'mainPanel'
    });
    QueryOrigin();
});
//===========ģ����ҳ��===============================================