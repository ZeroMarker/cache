// ����:��ֵƷ����ά��
// ��д����:2014-06-20  

//=========================���Ҷ���=============================
var gUserId = session['LOGON.USERID'];  
var gLocId=session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];

// ����
var StkGrpType=new Ext.ux.StkGrpComboBox({ 
    id : 'StkGrpType',
    name : 'StkGrpType',
    StkType:App_StkTypeCode,     //��ʶ��������
    LocId:gLocId,
    UserId:gUserId,
    anchor:'90%'
});
// ����inci
var Inci = new Ext.form.TextField({
    fieldLabel : 'Inci',
    id : 'Inci',
    name : 'Inci',
    anchor : '90%',
    valueNotFoundText : '',
    value:""
        });
// ��������
var InciDesc = new Ext.form.TextField({
    fieldLabel :'��������',
    id:'InciDesc',
    name:'InciDesc',
    anchor:'90%',
    listeners : {
    specialkey : function(field, e) {
    if (e.getKey() == Ext.EventObject.ENTER) {
        var stktype = Ext.getCmp("StkGrpType").getValue();
        //var stktype =296    //ֻ��ʾ��ֵ�Ĳ�
        
        GetPhaOrderInfo2(field.getValue(), stktype);
                    }
                }
            }
        });
        
    /*var PhaLoc = new Ext.ux.LocComboBox({
        fieldLabel : '����',
        id : 'PhaLoc',
        name : 'PhaLoc',
        anchor : '90%',
        valueNotFoundText : '',
        groupId:gGroupId
    });*/
    
 var PhaLoc=new Ext.ux.LocComboBox({
    id:'PhaLoc',
    anchor:'90%',
    fieldLabel:'��������',
    emptyText:'��ѡ��...',
    defaultLoc:''
});
var PublicBiddingStore = new Ext.data.SimpleStore({
        fields : ['RowId', 'Description'],
        data : [['1', '�����Լ�'], ['0', '�����Լ�']]
    });
    var PublicBidding = new Ext.form.ComboBox({
        fieldLabel : '����',
        id : 'PublicBidding',
        name : 'PublicBidding',
        anchor : '90%',
        store : PublicBiddingStore,
        valueField : 'RowId',
        displayField : 'Description',
        mode : 'local',
        allowBlank : true,
        triggerAction : 'all',
        selectOnFocus : true,
        listWidth : 150,
        forceSelection : true
    });    
    
//����ҩƷ���岢���ؽ��
function GetPhaOrderInfo2(item, group) {
                        
    if (item != null && item.length > 0) {
        GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", "",
                        getDrugList2);
        }
}   
// ���ط���
function getDrugList2(record) {
    if (record == null || record == "") {
        return;
    }
    var inciDr = record.get("InciDr");
    var inciCode=record.get("InciCode");
    var inciDesc=record.get("InciDesc");
    Ext.getCmp("Inci").setValue(inciDr);
    Ext.getCmp("InciDesc").setValue(inciDesc);
}
function GetPhaOrderInfo(item, group) {
                        
            if (item != null && item.length > 0) {
                GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", "",
                        getDrugList);
            }
        }

function getDrugList(record) {
    if (record == null || record == "") {
        return;
        }
    var cell = LVConfigGrid.getSelectionModel().getSelectedCell();
            // ѡ����
    var row = cell[0];
    var rowData = LVConfigGrid.getStore().getAt(row);
    var inciDr = record.get("InciDr");
    var inciCode=record.get("InciCode");
    var inciDesc=record.get("InciDesc");
    var spec=record.get("Spec");
    
     rowData.set("RowId",inciDr);
     rowData.set("InciCode",inciCode);
     rowData.set("InciDesc",inciDesc);
     rowData.set("Spec",spec);
     var colindex=GetColIndex(LVConfigGrid,"LocDescId");
     LVConfigGrid.startEditing(cell[0],colindex);
}
var findLVConfig = new Ext.Toolbar.Button({
    text:'��ѯ',
    tooltip:'��ѯ',
    iconCls:'page_find',
    width : 70,
    height : 30,
    handler:function(){
        
        Query();
        
    }
});
function deleteDetail()
{
    var cell = ConfigGrid.getSelectionModel().getSelectedCell();
        if(cell==null){
                Msg.info("error","��ѡ������!");
               return false;}
         else{ 
               var record = ConfigGrid.getStore().getAt(cell[0]);
               var RowId = record.get("LvRowId");
            
                Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
                function(btn){
                       if(btn=="yes"){
                           
                           var url = "dhcstm.LVConfigaction.csp?actiontype=DeleteEj&lvrowid="+RowId;
                           var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
                           Ext.Ajax.request({
                              url:url,
                               waitMsg:'ɾ����...',
                                failure: function(result, request) {
                                    Msg.info("error","������������!");
                                     mask.hide();
                                },
                                success: function(result, request) {
                                    var jsonData = Ext.util.JSON.decode( result.responseText );
                                     mask.hide();
                                     if (jsonData.success=='true') {
                                        Msg.info("success","ɾ���ɹ�!");
                                        //Query()
                                        ConfigGridDs.reload();
                                      }
                                      else{
                                        Msg.info("error","ɾ��ʧ��!");
                                    }
                                },
                                scope: this
                               });
                               
                               }
                           
                           })
      
    
                 }
}
function updateOrder(){
    var ListDetail="";
    var rowCount = ConfigGrid.getStore().getCount();
    for (var i = 0; i < rowCount; i++) {
        var rowData = ConfigGridDs.getAt(i);
        //���������ݷ����仯ʱִ����������
        if(rowData.data.newRecord || rowData.dirty){
            
            var RowId=rowData.get("LvRowId"); 
            var InciId=rowData.get("LvInciId");
            
            var LocCode=rowData.get("LvLocDescId");  
            
            var LVNumber=rowData.get("LvLVNumber");
            var cat=rowData.get("PublicBidding")
            var LvMonthNumber=rowData.get("LvMonthNumber");
                
            if(InciId=="")
            {Msg.info("error","��"+(i+1)+"�����ݲ�����!");return}
         
            var str= RowId + "^"+ InciId+"^"+LocCode+"^"+LVNumber+"^"+cat+"^"+LvMonthNumber
            if(ListDetail==""){
                ListDetail=str;
            }else{
                ListDetail=ListDetail+RowDelim+str;
            }
        }
    }   
    
    if(ListDetail==""){
        Msg.info("error","û���޸Ļ����������!");
        return false;
    }else{
        //alert(ListDetail);
        var url ="dhcstm.lvconfigaction.csp?actiontype=updateEjLvConfig";
        var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
        Ext.Ajax.request({
            url : url,
            method : 'POST',
            params:{LvListDetail:ListDetail},
            waitMsg : '������...',
            success : function(result, request) {
                var jsonData = Ext.util.JSON.decode(result.responseText);
                mask.hide();        
                if (jsonData.success == 'true') {
                    // ˢ�½���
                    Msg.info("success", "����ɹ�!");
                    //Query()
                    ConfigGridDs.reload();
                }else{
                    var ret=jsonData.info;
                    Msg.info("error", "���治�ɹ���"+ret);
                    
                }
            },
            scope : this
        });
    }
}
var SaveBT = new Ext.Toolbar.Button({
    id : "SaveBT",
    text : '����',
    tooltip : '�������',
    width : 70,
    height : 30,
    iconCls : 'page_save',
    handler : function() {saveOrder();}
    });


 var LocDesc = new Ext.ux.LocComboBox({
    id:'LocDesc',
    anchor:'90%',
    fieldLabel:'��������',
    emptyText:'��ѡ��...',
    defaultLoc:'',
     listeners : {
                specialkey : function(field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        //Ext.GetColIndex('LVNumber').focus(); 
                        var cell = LVConfigGrid.getSelectionModel().getSelectedCell();
                         var colIndex=GetColIndex(LVConfigGrid,'LVNumber');
                         LVConfigGrid.startEditing(cell[0], colIndex);
                    }
                }
            }
});

//ģ�� RowId InciId InciDesc Spec LocDescId  LVNumber
var nm = new Ext.grid.RowNumberer();
var LVConfigGridCm = new Ext.grid.ColumnModel([nm,{
        header : "RowId",
        dataIndex : 'RowId',
        width : 120,
        align : 'left',
        sortable : true,
        hidden : true
        },
        {
        header : "���ʴ���",
        dataIndex : 'InciCode',
        width : 110,
        align : 'left',
        sortable : true
        },{
        header:"��������",
        dataIndex:'InciDesc',
        width:250,
        align:'left',
        sortable:true,
        editor :new Ext.grid.GridEditor(new Ext.form.TextField({
                                selectOnFocus : true,
                                allowBlank : false,
                                listeners : {
                                    specialkey : function(field, e) {
                                        if (e.getKey() == Ext.EventObject.ENTER) {
                                            var group = Ext.getCmp("StkGrpType").getValue();
                                            GetPhaOrderInfo(field.getValue(),group);
                                            
                                        }
                                    }
                                }
                            }))
      },{
        header : "���",
        dataIndex : 'Spec',
        width : 100,
        align : 'left',
        sortable : true
        },{
        header : "��������",
        dataIndex : 'LocDescId',
        width : 110,
        align : 'left',
        sortable : true,
        editor : new Ext.grid.GridEditor(LocDesc),
        renderer :Ext.util.Format.comboRenderer2(LocDesc,"LocDescId","LocDesc") 
        },{
        header : "����",
        dataIndex : 'PublicBidding',
        width : 110,
        align : 'left',
        sortable : true,
        editor : new Ext.grid.GridEditor(PublicBidding),
        renderer :Ext.util.Format.comboRenderer2

(PublicBidding,"PublicBidding","PublicBiddingDesc") 
        },{
        header:"����������",
        dataIndex:'LVNumber',
        width:90,
        align:'right',
        sortable:true,
        editor :new Ext.grid.GridEditor(new Ext.form.NumberField({
                                //selectOnFocus : true
                                
                            }))
      },{
        header:"����������",
        dataIndex:'LVMonthNumber',
        width:90,
        align:'right',
        sortable:true,
        editor :new Ext.grid.GridEditor(new Ext.form.NumberField({
                                //selectOnFocus : true
                                
                            }))
      }
]);
//��ʼ��Ĭ��������
LVConfigGridCm.defaultSortable = true;




// ����·��
var DetailUrl ='dhcstm.lvconfigaction.csp?actiontype=find';
// ͨ��AJAX��ʽ���ú�̨����
var proxy = new Ext.data.HttpProxy({
            url : DetailUrl,
            method : "POST"
    });
        
// ָ���в���
        //RowId InciId  InciCode InciDesc Spec LocDescId  LVNumber
var fields = ["RowId", "InciCode","InciDesc","Spec", 

"LocDescId","LocDesc","LVNumber","LVMonthNumber"];
        
        
// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
var reader = new Ext.data.JsonReader({
        root : 'rows',
        totalProperty : "results",
        id : "RowId",
        fields : fields
});
// ���ݼ�
var LVConfigGridDs = new Ext.data.Store({
        proxy : proxy,
        reader : reader
});  
            
//���湩Ӧ��Ŀ��ϸ
function saveOrder(){
    var ListDetail="";
    var rowCount = LVConfigGrid.getStore().getCount();
    for (var i = 0; i < rowCount; i++) {
        var rowData = LVConfigGridDs.getAt(i);
        //���������ݷ����仯ʱִ����������
        if(rowData.data.newRecord || rowData.dirty){
            
            //var RowId=rowData.get("RowId"); 
            var InciId=rowData.get("RowId");
            
            var LocCode=rowData.get("LocDescId");  
            
            var LVNumber=rowData.get("LVNumber");    
            var LVScat=rowData.get("PublicBidding");
            var LVMonthNumber=rowData.get("LVMonthNumber");
            if(InciId==""||LocCode=="")
            {Msg.info("error","��"+(i+1)+"�����ݲ�����!");return}
         
            var str= InciId+"^"+LocCode+"^"+LVNumber+"^"+LVScat+"^"+LVMonthNumber
            if(ListDetail==""){
                ListDetail=str;
            }else{
                ListDetail=ListDetail+RowDelim+str;
            }
        }
    }   
    
    if(ListDetail==""){
        Msg.info("error","û���޸Ļ����������!");
        return false;
    }else{
        
        var url ="dhcstm.lvconfigaction.csp?actiontype=saveEjlocqty";
        var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
        Ext.Ajax.request({
            url : url,
            method : 'POST',
            params:{ListData:ListDetail},
            waitMsg : '������...',
            success : function(result, request) {
                var jsonData = Ext.util.JSON.decode(result.responseText);
                mask.hide();        
                if (jsonData.success == 'true') {
                    // ˢ�½���
                    Msg.info("success", "����ɹ�!");
                    Query()
                }else{
                    var ret=jsonData.info;
                    Msg.info("error", "���治�ɹ���"+ret);
                    
                }
            },
            scope : this
        });
    }
}
           
//��ѯ����
function Query()
{
   
    LVConfigGridDs.removeAll();
    ConfigGridDs.removeAll();
    var parm=setParam();
    if(parm==-1){
        return;
    }else{
        LVConfigGridDs.setBaseParam('Param',setParam())
        LVConfigGridDs.load({
        params:{start:0,limit:LVConfigPagingToolbar.pageSize}
    });  
    }
   
}
// ��ѯ������ƴ��
function setParam(){
    var stc = Ext.getCmp("StkGrpType").getValue();
    if(stc==""){
        Msg.info("warning","��ѡ������");
        return -1;
    }
    var inic = Ext.getCmp("Inci").getValue();
    var desc = Ext.getCmp("InciDesc").getRawValue();
    if(desc==""||desc==null){
        inic="";
        
    }
    var loc = Ext.getCmp("PhaLoc").getValue();
    //alert(stc+"^"+inic+"^"+loc)
    return stc+"^"+inic+"^"+loc+"^"+gUserId;
}

      
var formPanel = new Ext.form.FormPanel({
    region : 'north',
	//autoHeight : true,
	title : '��������ά��',
	labelWidth : 60,
	labelAlign : 'right',
	frame : true,
	tbar : [findLVConfig,'-',SaveBT],
	height:135,
    bodyStyle : 'padding:10px 0px 0px 0px;',
	//layout: 'fit',
	items : [{
			xtype : 'fieldset',
			title : '��ѯ��Ϣ',
			layout : 'column',
			autoHeight:true,
			defaults : {border : false},
			items : [{
				columnWidth: 0.33,
				xtype: 'fieldset',
				items: [StkGrpType]
			},{
				columnWidth: 0.33,
				xtype: 'fieldset',
				items: [InciDesc]
			},{
				columnWidth: 0.33,
				xtype: 'fieldset',
				items: [PhaLoc]
			}
		    ]
    }]
    
  });
//tbar:[findLVConfig,'-',SaveBT],
//��ҳ������
var LVConfigPagingToolbar = new Ext.PagingToolbar({
    store:LVConfigGridDs,
    pageSize:15,
    displayInfo:true,
    displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg:"û�м�¼"
});

//���
LVConfigGrid = new Ext.grid.EditorGridPanel({
    store:LVConfigGridDs,
    cm:LVConfigGridCm,
    title:'���ʴ�ά����ϸ',
    trackMouseOver:true,
    clicksToEdit:1,
    region:'west',
    width:690,
    stripeRows:true,
    sm:new Ext.grid.CellSelectionModel({}),
    loadMask:true,
    listeners : {
        rowclick : function(grid,rowIndex,e){
            var inci = grid.store.getAt(rowIndex).get('RowId');
            var stc = Ext.getCmp("StkGrpType").getValue();
            var loc = Ext.getCmp("PhaLoc").getValue();
            var datalist=stc+"^"+inci+"^"+loc
            ConfigGridDs.removeAll(); 
            ConfigGridDs.setBaseParam('QueryParam',datalist)
            ConfigGridDs.load({params:{start:0,limit:ConfigPagingToolbar.pageSize}
    });
        }
    },
    bbar:LVConfigPagingToolbar
});
//==========================���ʶ���=============================

//=========================Lv====================================
//ģ�� RowId InciId InciDesc Spec LocDescId  LVNumber
var mm = new Ext.grid.RowNumberer();
var ConfigGridCm = new Ext.grid.ColumnModel([mm,{
        header : "LvRowId",
        dataIndex : 'LvRowId',
        width : 120,
        align : 'left',
        sortable : true,
        hidden : true
        },{
        header : "LvInciId",
        dataIndex : 'LvInciId',
        width : 120,
        align : 'left',
        sortable : true,
        hidden : true
        }, {
        header : "���ʴ���",
        dataIndex : 'LvInciCode',
        width : 150,
        align : 'left',
        sortable : true,
        hidden : true
        },{
        header:"��������",
        dataIndex:'LvInciDesc',
        width:250,
        align:'left',
        sortable:true,
        hidden : true
        
        },{
        header : "���",
        dataIndex : 'LvSpec',
        width : 150,
        align : 'left',
        sortable : true,
        hidden : true
        },{
        header : "����id",
        dataIndex : 'LvLocDescId',
        width : 120,
        align : 'left',
        sortable : true,
        hidden : true
        
        },{
        header : "��������",
        dataIndex : 'LvLocDesc',
        width : 150,
        align : 'left',
        sortable : true
        
        },{
        header:"����������",
        dataIndex:'LvLVNumber',
        width:100,
        align:'right',
        sortable:true,
        editor :new Ext.grid.GridEditor(new Ext.form.NumberField({}))
      },{
        header:"����������",
        dataIndex:'LvMonthNumber',
        width:100,
        align:'right',
        sortable:true,
        editor :new Ext.grid.GridEditor(new Ext.form.NumberField({}))
      }
      ,{
        header : "����",
        dataIndex : 'Stkcat',
        width : 150,
        align : 'left',
        renderer:function(v){
            if(v=="0"){
                return "�����Լ�"
            }
            else if(v=="1"){
                return "�����Լ�"
            }else{
                return ""
            }
        },
        sortable : true
        
        }
]);
//��ʼ��Ĭ��������
ConfigGridCm.defaultSortable = true;




// ����·��
var LvDetailUrl ='dhcstm.lvconfigaction.csp?actiontype=queryEj';
// ͨ��AJAX��ʽ���ú�̨����
var proxy = new Ext.data.HttpProxy({
            url : LvDetailUrl,
            method : "POST"
    });
        
// ָ���в���
        //RowId InciId  InciCode InciDesc Spec LocDescId  LVNumber
var fields = ["LvRowId", "LvInciId", "LvInciCode","LvInciDesc","LvSpec", 

"LvLocDescId","LvLocDesc","LvLVNumber","Stkcat","LvMonthNumber"];
        
        
// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
var reader = new Ext.data.JsonReader({
        root : 'rows',
        totalProperty : "results",
        fields : fields
});
// ���ݼ�
var ConfigGridDs = new Ext.data.Store({
        proxy : proxy,
        reader : reader
});  
            

           

  


//��ҳ������
var ConfigPagingToolbar = new Ext.PagingToolbar({
    store:ConfigGridDs,
    pageSize:30,
    displayInfo:true,
    displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg:"û�м�¼"
});

//���
var DeleteBT = new Ext.Toolbar.Button({
        id : "DeleteBT",
        text : 'ɾ��',
        tooltip : '���ɾ��',
        width : 70,
        height : 30,
        iconCls : 'page_delete',
        handler : function() {
            //CancleComplete();
            deleteDetail();
        }
    });
var UpdateBT = new Ext.Toolbar.Button({
        id : "UpdateBT",
        text : '�޸�',
        tooltip : '����޸�',
        width : 70,
        height : 30,
        iconCls : 'page_gear',
        handler : function() {
            updateOrder();
        }
    }); 
ConfigGrid = new Ext.grid.EditorGridPanel({
    store:ConfigGridDs,
    cm:ConfigGridCm,
    title:'������ά����ϸ',
    trackMouseOver:true,
    region:'center',
    stripeRows:true,
    sm:new Ext.grid.CellSelectionModel({}),
    loadMask:true,
    clicksToEdit:1,
    tbar:{items:[DeleteBT,'-',UpdateBT]},
    bbar:ConfigPagingToolbar
    
});

    
//===========ģ����ҳ��===========================================
Ext.onReady(function(){
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
  
    var mainPanel = new Ext.Viewport({
        layout:'border',
        items:[formPanel,LVConfigGrid,ConfigGrid]
    });
});
    
//===========ģ����ҳ��===========================================