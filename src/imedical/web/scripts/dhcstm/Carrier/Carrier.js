// ����:�����̹���
// ��д����:2012-05-10
var MPNumber = "";
//=========================���������=============================
var conditionCodeField = new Ext.form.TextField({
    id:'conditionCodeField',
    fieldLabel:'����',
    allowBlank:true,
    //width:180,
    listWidth:180,
    emptyText:'����...',
    anchor:'90%',
    selectOnFocus:true
});

var conditionDescField = new Ext.form.TextField({
    id:'conditionDescField',
    fieldLabel:'����',
    allowBlank:true,
    //width:150,
    listWidth:150,
    emptyText:'����...',
    anchor:'90%',
    selectOnFocus:true
});
var conditionMPNumberField = new Ext.form.TextField({
	id:'conditionMPNumberField',
	fieldLabel:'�ֻ���',
	allowBlank:true,
	listWidth:150,
	emptyText:'�ֻ��š���',
	anchor:'90%',
	selectOnFocus:true
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
        },{
	        name : 'MPNumber',
	        type : 'string'
	        }
    ]);
                    
    var NewRecord = new record({
        RowId:'',
        Code:'',
        Desc:'',
        MPNumber:''
    });
                    
    CarrierGridDs.add(NewRecord);
    CarrierGrid.startEditing(CarrierGridDs.getCount() - 1, 1);
}
    
var CarrierGrid="";
//��������Դ
var CarrierGridUrl = 'dhcstm.carrieraction.csp';
var CarrierGridProxy= new Ext.data.HttpProxy({url:CarrierGridUrl+'?actiontype=query',method:'POST'});
var CarrierGridDs = new Ext.data.Store({
    proxy:CarrierGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
        totalProperty:'results',
        pageSize:35
    }, [
        {name:'RowId'},
        {name:'Code'},       
        {name:'Desc'},
        {name:'MPNumber'}
        
        
    ]),
    remoteSort:false,
    pruneModifiedRecords:true
});

//ģ��
var CarrierGridCm = new Ext.grid.ColumnModel([
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
                        CarrierGrid.startEditing(CarrierGridDs.getCount() - 1, 2);
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
                       CarrierGrid.startEditing(CarrierGridDs.getCount() - 1, 3);
                    }
                }
            }
        })
        
    },{
	   
        header:"�ֻ���",
        id:'MPNumber',
        dataIndex:'MPNumber',
        width:300,
        align:'left',
        sortable:true,
        editor: new Ext.form.TextField({
            id:'numberField',
            allowBlank:true,
            listeners:{
                specialKey:function(field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        addNewRow();
                    }
                }
            }
        })
	    }
	    
]);

//��ʼ��Ĭ��������
CarrierGridCm.defaultSortable = true;

var findCarrier = new Ext.Toolbar.Button({
    text:'��ѯ',
    tooltip:'��ѯ',
    iconCls:'page_find',
    width : 70,
    height : 30,
    handler:function(){
        var conditionCode = Ext.getCmp('conditionCodeField').getValue();
        var conditionDesc = Ext.getCmp('conditionDescField').getValue();
        var conditionType=App_StkTypeCode;
        var MPNumber = Ext.getCmp('conditionMPNumberField').getValue();
        CarrierGridDs.load({params:{start:0,limit:CarrierPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:conditionCode,conditionDesc:conditionDesc,conditionType:conditionType,MPNumber:MPNumber}});
    }
});

var addCarrier = new Ext.Toolbar.Button({
    text:'�½�',
    tooltip:'�½�',
    iconCls:'page_add',
    width : 70,
    height : 30,
    handler:function(){
        addNewRow();
    }
});

var saveCarrier = new Ext.Toolbar.Button({
    text:'����',
    tooltip:'����',
    iconCls:'page_save',
    width : 70,
    height : 30,
    handler:function(){
        //��ȡ���е��¼�¼ 
        var mr=CarrierGridDs.getModifiedRecords();
        var data="";
        for(var i=0;i<mr.length;i++){
            var code = mr[i].data["Code"].trim();
            var desc = mr[i].data["Desc"].trim();
            var type = App_StkTypeCode;
            var MPNumber = mr[i].data["MPNumber"].trim();
            
            /*var reg =/^0{0,1}(13[0-9]|15[0-9]|18[3-9])[0-9]{8}$/;      ///������ʽƥ���ֻ���
            if(!reg.test(MPNumber)) 
        { 
        
           
            alert("�����ֻ����벻��ȷ������������"); 
            //CarrierGridDs.load({params:{start:0,limit:CarrierPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionDesc:Ext.getCmp('conditionDescField').getValue(),conditionType:App_StkTypeCode,MPNumber:MPNumber}});
            return ; 
        }*/ 
           
            if((code!="")&&(desc!="")){
                var dataRow = mr[i].data["RowId"]+"^"+code+"^"+desc+"^"+type+"^"+MPNumber;
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
        	var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
            Ext.Ajax.request({
                url: CarrierGridUrl+'?actiontype=save',
                params: {data:data},
                failure: function(result, request) {
                	 mask.hide();
                    Msg.info("error", "������������!");
                },
                success: function(result, request) {
                    var jsonData = Ext.util.JSON.decode( result.responseText );
                     mask.hide();
                    if (jsonData.success=='true') {
                        Msg.info("success", "����ɹ�!");
                        CarrierGridDs.load({params:{start:0,limit:CarrierPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionDesc:Ext.getCmp('conditionDescField').getValue(),conditionType:App_StkTypeCode,MPNumber:MPNumber}});
                    }else{
	                    if(jsonData.info==-1){
							Msg.info("error", "�����ظ�!");
						}else if(jsonData.info==-2){
							Msg.info("error", "�����ظ�!");
						}else{
							 Msg.info("error", "����ʧ��!" +jsonData.info);
						}
                        CarrierGridDs.load({params:{start:0,limit:CarrierPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionDesc:Ext.getCmp('conditionDescField').getValue(),conditionType:App_StkTypeCode,MPNumber:MPNumber}});
                    }
                },
                scope: this
            });
        }
    }
});

var saveAs = new Ext.Toolbar.Button({
	text:'���',
	height:30,
	width:70,
	iconCls:'page_save',
	handler:function(){
		gridSaveAsExcel(CarrierGrid);
	}

});


var deleteCarrier = new Ext.Toolbar.Button({
    text:'ɾ��',
    tooltip:'ɾ��',
    iconCls:'page_delete',
    width : 70,
    height : 30,
    handler:function(){
        var cell = CarrierGrid.getSelectionModel().getSelectedCell();
        if(cell==null){
            Msg.info("error", "��ѡ������!");
            return false;
        }else{
            var record = CarrierGrid.getStore().getAt(cell[0]);
            var RowId = record.get("RowId");
            if(RowId!=""){
                Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
                    function(btn) {
                        if(btn == 'yes'){
                        	var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
                            Ext.Ajax.request({
                                url:CarrierGridUrl+'?actiontype=delete&rowid='+RowId,
                                waitMsg:'ɾ����...',
                                failure: function(result, request) {
                                	 mask.hide();
                                    Msg.info("error", "������������!");
                                },
                                success: function(result, request) {
                                    var jsonData = Ext.util.JSON.decode( result.responseText );
                                     mask.hide();
                                    if (jsonData.success=='true') {
                                        Msg.info("success", "ɾ���ɹ�!");
                                        CarrierGridDs.load({params:{start:0,limit:CarrierPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionDesc:Ext.getCmp('conditionDescField').getValue(),conditionType:App_StkTypeCode}});
                                    }else{
                                        if(jsonData.info==-1){
                                            Msg.info("error", "�����������ʶ�����ʹ�ù�������ɾ��!");
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

//��ҳ������
var CarrierPagingToolbar = new Ext.PagingToolbar({
    store:CarrierGridDs,
    pageSize:35,
    displayInfo:true,
    displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg:"û�м�¼",
    doLoad:function(C){
        var B={},
        A=this.getParams();
        B[A.start]=C;
        B[A.limit]=this.pageSize;
        B[A.sort]='RowId';
        B[A.dir]='desc';
        B['conditionCode']=Ext.getCmp('conditionCodeField').getValue();
        B['conditionDesc']=Ext.getCmp('conditionDescField').getValue();
        B['conditionType']=App_StkTypeCode;
        B['MPNumber']=MPNumber;
        if(this.fireEvent("beforechange",this,B)!==false){
            this.store.load({params:B});
        }
    }
});
   //var CarrierGridUrl = 'dhcstm.carrieraction.csp';
var CarrierGridProxy= new Ext.data.HttpProxy({url:CarrierGridUrl+'?actiontype=select',method:'POST'});
 var DrugInfoGridds = new Ext.data.Store({
    proxy:CarrierGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
        totalProperty:'results',
        pageSize:35
    }, [
        {name:'InciRowid'},
        {name:'InciCode'},       
        {name:'InciDesc'},
        {name:'Spec'},
        {name:'Manf'},
        {name:'PurUom'},       
        {name:'BUom'},
        {name:'StkCat'},
        {name:'Rp'},
        {name:'Sp'}
    ]),
    remoteSort:false,
    pruneModifiedRecords:true
});
var nm = new Ext.grid.RowNumberer();
	
var DrugInfoCm = new Ext.grid.ColumnModel([nm, 
	{
		header : "�����id",
		dataIndex : 'InciRowid',
		width : 80,
		align : 'left',
		sortable : true,
		hidden : true,
		hideable : false
	}, {
		header : "���ʴ���",
		dataIndex : 'InciCode',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : '��������',
		dataIndex : 'InciDesc',
		width : 200,
		align : 'left',
		sortable : true
	}, {
		header : "���",
		dataIndex : 'Spec',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : '��ⵥλ',
		dataIndex : 'PurUom',
		width : 70,
		align : 'left',
		sortable : true
	}, {
		header : "������λ",
		dataIndex : 'BUom',
		width : 80,
		align : 'left',
		sortable : true
	},  {
		header : "������",
		dataIndex : 'StkCat',
		width : 150,
		align : 'left',
		sortable : true
	},  {
		header : "����",
		dataIndex : 'Rp',
		width : 150,
		align : 'left',
		sortable : true
	},  {
		header : "�ۼ�",
		dataIndex : 'Sp',
		width : 150,
		align : 'left',
		sortable : true
	}
]);
DrugInfoCm.defaultSortable = true;

var CarrierPagingToolbar = new Ext.PagingToolbar({
	store : CarrierGridDs,
	pageSize : 30,
	displayInfo : true,
	displayMsg : '��ǰ��¼ {0} -- {1} �� �� {2} ����¼',
	emptyMsg : "No results to display",
	prevText : "��һҳ",
	nextText : "��һҳ",
	refreshText : "ˢ��",
	lastText : "���ҳ",
	firstText : "��һҳ",
	beforePageText : "��ǰҳ",
	afterPageText : "��{0}ҳ",
	emptyMsg : "û������"
});
		
var DrugInfoGrid = new Ext.grid.GridPanel({
	id:'DrugInfoGrid',
	title:'����������ϸ',
	region:'south',
	height:200,
	width : 200,
	autoScroll:true,
	cm:DrugInfoCm,
	store:DrugInfoGridds,
	trackMouseOver : true,
	stripeRows : true,
	sm : new Ext.grid.RowSelectionModel({singleSelect:false}),
	loadMask : true,
	bbar:CarrierPagingToolbar		
});

//���
CarrierGrid = new Ext.grid.EditorGridPanel({
    store:CarrierGridDs,
    title:'��������ϸ',
    cm:CarrierGridCm,
    trackMouseOver:true,
    region:'center',
    height:690,
    stripeRows:true,
    sm:new Ext.grid.CellSelectionModel({}),
    loadMask:true,
    bbar:CarrierPagingToolbar,
    clicksToEdit:1
});
CarrierGridDs.load({params:{start:0,limit:CarrierPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionDesc:Ext.getCmp('conditionDescField').getValue(),conditionType:App_StkTypeCode,MPNumber:MPNumber}});

var formPanel = new Ext.ux.FormPanel({
	title:'������ά��',
    tbar:[findCarrier,'-',addCarrier,'-',saveCarrier,'-',saveAs],		//,'-',deleteCarrier
    items : [{
		xtype : 'fieldset',
		title : '��ѯ����',
		layout : 'column',	
		style : 'padding:5px 0px 0px 5px',
		defaults:{border:false,columnWidth : .3,xtype:'fieldset'},
		items : [{
				items : [conditionCodeField]
			}, {
				items : [conditionDescField]
			},{
				items : [conditionMPNumberField]	
		}]
    }]
});

//==== ��ӱ��ѡȡ���¼�=============//
CarrierGrid.on('rowclick',function(grid,rowIndex,e){
	var selectedRow = CarrierGridDs.data.items[rowIndex];
	tmpSelectedScheme=selectedRow.data['RowId'];
	DrugInfoGridds.proxy = new Ext.data.HttpProxy({url: CarrierGridUrl+'?actiontype=select&rowid='+tmpSelectedScheme,method:'POST'});
	DrugInfoGridds.load({params:{start:0,limit:CarrierPagingToolbar.pageSize,sort:'RowId',dir:'desc',rowid:tmpSelectedScheme}});
});	

//=========================���������=============================

//===========ģ����ҳ��===============================================
Ext.onReady(function(){
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    
    var mainPanel = new Ext.ux.Viewport({
        layout:'border',
        items:[formPanel,CarrierGrid,DrugInfoGrid],
        renderTo:'mainPanel'
    });
});
	