// /����: ���ҿ��������Ϣ
// /����: ���ҿ��������Ϣ
// /��д�ߣ�liangjiaquan
// /��д����: 2015.05.19
Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    var gIncId='';
    var gGroupId=session['LOGON.GROUPID'];  
    var gLocId=session['LOGON.CTLOCID'];
    var gUserId=session['LOGON.USERID'];
    
    var PhaLoc = new Ext.ux.LocComboBox({
        fieldLabel : '����',
        id : 'PhaLoc',
        name : 'PhaLoc',
        anchor : '90%',
        valueNotFoundText : '',
        groupId:gGroupId,
        listeners : {
			'select' : function(e) {
                          var SelLocId=Ext.getCmp('PhaLoc').getValue();//add wyx ����ѡ��Ŀ��Ҷ�̬��������
                          StkGrpType.getStore().removeAll();
                          StkGrpType.getStore().setBaseParam("locId",SelLocId)
                          StkGrpType.getStore().setBaseParam("userId",gUserId)
                          StkGrpType.getStore().setBaseParam("type",App_StkTypeCode)
                          StkGrpType.getStore().load();
			}
	    }
    });
    
    
    // ҩƷ����
    var StkGrpType=new Ext.ux.StkGrpComboBox({ 
    	fieldLabel : '����',
        id : 'StkGrpType',
        name : 'StkGrpType',
        StkType:App_StkTypeCode,     //��ʶ��������
        UserId:gUserId,
        LocId:gLocId,
        anchor : '90%'
    }); 
    
    var InciDesc = new Ext.form.TextField({
                fieldLabel : 'ҩƷ����',
                id : 'InciDesc',
                name : 'InciDesc',
                anchor : '90%',
                listeners : {
                    specialkey : function(field, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            var inputDesc=field.getValue();
                            var stkGrp=Ext.getCmp("StkGrpType").getValue();
                            GetPhaOrderInfo(inputDesc,stkGrp);
                        }
                    }
                }
            });
	/**
     * ����ҩƷ���岢���ؽ��
     */
    function GetPhaOrderInfo(item, stktype) {
        if (item != null && item.length > 0) {
            GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N", "0", "",getDrugList);
        }
    }
    /**
     * ���ط���
     */
    function getDrugList(record) {
        if (record == null || record == "") {
            return;
        }
        gIncId = record.get("InciDr");
        var incDesc=record.get("InciDesc");
        Ext.getCmp("InciDesc").setValue(incDesc);
        //Query();
    }
    
    // ��ѯ��ť
    var SearchBT = new Ext.Toolbar.Button({
                text : '��ѯ',
                tooltip : '�����ѯ',
                iconCls : 'page_find',
                width : 70,
                height : 30,
                handler : function() {
	                //Msg.info("error", "��,�ù��ܻ�û�������,��ʱ������ʹ�á�����");
	                //return;
                    Query();
                }
            });
    
    /**
     * ��ѯ����
     */
    function Query() {
        // ��ѡ����
        var phaLoc = Ext.getCmp("PhaLoc").getValue();
        if (phaLoc == null || phaLoc.length <= 0) {
            Msg.info("warning", "���Ҳ���Ϊ�գ�");
            Ext.getCmp("PhaLoc").focus();
            return;
        }
        if(Ext.getCmp("InciDesc").getValue()==""){
            gIncId="";
        }
		ItmLocBatStore.removeAll();
        var StkGrpRowId = Ext.getCmp("StkGrpType").getValue();
        var BatchLockType = Ext.getCmp("BatchLockType").getValue();
        var StkLockType = Ext.getCmp("StkLockType").getValue();
        var StockType = Ext.getCmp("StockType").getValue();
        gStrParam=phaLoc+"^"+gIncId+"^"+StkGrpRowId+"^"+BatchLockType+"^"+StockType+"^"+StkLockType;
        var PageSize=StatuTabPagingToolbar.pageSize;
        ItmLocBatStore.setBaseParam('Params',gStrParam);   //��ҳʱ�����������ᶪʧ
        ItmLocBatStore.load({params:{start:0,limit:PageSize}});
    }
    
    
    
    // ��հ�ť
    var RefreshBT = new Ext.Toolbar.Button({
                text : '����',
                tooltip : '�������',
                iconCls : 'page_clearscreen',
                width : 70,
                height : 30,
                handler : function() {
                    clearData();
                }
            });
    
    /**
     * ��շ���
     */
    function clearData() {
        gStrParam='';   
        gIncId='';
        SetLogInDept(GetGroupDeptStore,'PhaLoc');
        Ext.getCmp('BatchLockType').setValue('0');
        Ext.getCmp("StockType").setValue('');
        Ext.getCmp("InciDesc").setValue('');
        StkGrpType.getStore().setBaseParam("locId",gLocId)
		StkGrpType.getStore().setBaseParam("userId",gUserId)
		StkGrpType.getStore().setBaseParam("type",App_StkTypeCode)
		StkGrpType.getStore().load();
        //ItmLocBatGrid.store.removeAll();
        ItmLocBatGrid.getStore().removeAll();
        ItmLocBatGrid.store.load({params:{start:0,limit:0}});
        ItmLocBatGrid.getView().refresh();
    }
    
     
    // ���水ť
    var SaveBT = new Ext.Toolbar.Button({
                id : "SaveBT",
                text : '����',
                tooltip : '�������',
                width : 70,
                height : 30,
                iconCls : 'page_save',
                handler : function() {

                    // ������ҿ�������Ϣ        
                    //Msg.info("error", "��,�ù��ܻ�û�������,��ʱ������ʹ�á�����");
                    //return;           
                    save();                     
                }
            });
    
    
    function save(){
        
        var ListDetail="";
        var mr=ItmLocBatStore.getModifiedRecords();
        var data="";
        var rows="";
        for(var i=0;i<mr.length;i++){
            var inclb = mr[i].data["inclb"].trim();
            var batchlocflag=mr[i].data["lockFlag"];
            if(batchlocflag=="N"){batchlocflag="Y";}
            else{batchlocflag="N";} 
            var stkflag=mr[i].data["stkFlag"];
            if(stkflag=="N"){stkflag="Y";}
            else{stkflag="N";} 
            var dataRow =inclb + "^" + batchlocflag + "^" + stkflag;
            if(ListDetail==""){
                ListDetail = dataRow;
            }else{
                ListDetail = ListDetail+xRowDelim()+dataRow;
            }
        }
        var url = DictUrl
                + "incitmlcbtaction.csp?actiontype=SaveBatch";
        Ext.Ajax.request({
                    url : url,
                    params:{Detail:ListDetail},
                    method : 'POST',
                    waitMsg : '������...',
                    success : function(result, request) {
                        var jsonData = Ext.util.JSON
                                .decode(result.responseText);
                        if (jsonData.success == 'true') {
                            Msg.info("success", "����ɹ�!");
                            // ˢ�½���
                            //Query();
                            ItmLocBatStore.reload();
                        } else {
                            var ret=jsonData.info;
                            if(ret==-1){
                                Msg.info("error", "û����Ҫ���������!");
                            }else {
                                Msg.info("error", "������ϸ���治�ɹ���"+ret);
                            }
                        }
                    },
                    scope : this
                });
    }
    
    var StockTypeStore=new Ext.data.SimpleStore({
        fields : ['RowId', 'Description'],
        data : [['-1', '�����'], ['0', '����'], ['1', '�����']]
    });
    var StockType=new Ext.form.ComboBox({
        fieldLabel : '�������',
        id : 'StockType',
        name : 'StockType',
        anchor : '90%',
        store : StockTypeStore,
        mode : 'local',
        valueField : 'RowId',
        displayField : 'Description',
        allowBlank : true,
        triggerAction : 'all',
        selectOnFocus : true,
        forceSelection : true,
        minChars : 1,
        pageSize : 20,
        listWidth : 240,
        valueNotFoundText : '',
        enableKeyEvents : true
    });
    
    Ext.getCmp('StockType').setValue('');
    
    
    var BatchLockStore=new Ext.data.SimpleStore({
        fields : ['RowId', 'Description'],
        data : [['0', 'ȫ��'], ['1', '������'], ['2', '������']]
    });
    var BatchLockType=new Ext.form.ComboBox({
        fieldLabel : 'ҽ������',
        id : 'BatchLockType',
        name : 'BatchLockType',
        anchor : '90%',
        store : BatchLockStore,
        mode : 'local',
        valueField : 'RowId',
        displayField : 'Description',
        allowBlank : true,
        triggerAction : 'all',
        selectOnFocus : true,
        forceSelection : true,
        minChars : 1,
        pageSize : 20,
        listWidth : 250,
        valueNotFoundText : '',
        enableKeyEvents : true
    });
    
    Ext.getCmp('BatchLockType').setValue('0');
    
    var StkLockStore=new Ext.data.SimpleStore({
        fields : ['RowId', 'Description'],
        data : [['0', 'ȫ��'], ['1', '������'], ['2', '������']]
    });
    
    var StkLockType=new Ext.form.ComboBox({
        fieldLabel : '������',
        id : 'StkLockType',
        name : 'StkLockType',
        anchor : '90%',
        store : StkLockStore,
        mode : 'local',
        valueField : 'RowId',
        displayField : 'Description',
        allowBlank : true,
        triggerAction : 'all',
        selectOnFocus : true,
        forceSelection : true,
        minChars : 1,
        pageSize : 20,
        listWidth : 250,
        valueNotFoundText : '',
        enableKeyEvents : true
    });
    
    Ext.getCmp('StkLockType').setValue('0');
    
    /*
	var InsuCatGrid="";
	//��������Դ
	var gridUrl = 'dhcst.incitmlcbtaction.csp';
	var InsuCatGridProxy= new Ext.data.HttpProxy({url:gridUrl+'?actiontype=GetInsuCatInfo',method:'GET'});
	var InsuCatGridDs = new Ext.data.Store({
		proxy:InsuCatGridProxy,
	    reader:new Ext.data.JsonReader({
			totalProperty:'results',
	        root:'rows'
	    }, [
			{name:'Rowid'},
			{name:'Type'},
			{name:'ZFPercent'},
			{name:'YBPercent'}
		]),
	    remoteSort:false
	});

	//ģ��
	var InsuCatGridCm = new Ext.grid.ColumnModel([
		 new Ext.grid.RowNumberer(),
		 {
	        header:"ҽ������",
	        dataIndex:'Type',
	        width:80,
	        align:'left',
	        sortable:true
	    },{
	        header:"�Ը�����",
	        dataIndex:'ZFPercent',
	        width:80,
	        align:'left',
	        sortable:true
	    },{
	        header:"ҽ������",
	        dataIndex:'YBPercent',
	        width:80,
	        align:'left',
	        sortable:true
	    }
	]);

	//��ʼ��Ĭ��������
	InsuCatGridCm.defaultSortable = true;

	//���
	InsuCaGrid = new Ext.grid.GridPanel({
		store:InsuCatGridDs,
		cm:InsuCatGridCm,
		trackMouseOver:true,
		width:200,
		height:100,
		stripeRows:true,
		sm:new Ext.grid.RowSelectionModel({}),
		loadMask:true
	});
	*/
    var ChkLockFlag=new Ext.grid.CheckColumn({
       header: '<font color=blue>ҽ�����ν���</font>',
       dataIndex: 'lockFlag',
       width: 100
    });
    
    var ChkStkLockFlag=new Ext.grid.CheckColumn({
       header: '<font color=blue>������ν���</font>',
       dataIndex: 'stkFlag',
       width: 100
    });
    
    var nm = new Ext.grid.RowNumberer();
    var ItmLocBatCm = new Ext.grid.ColumnModel([nm, {
                header : "Rowid",
                dataIndex : 'inclb',
                width : 50,
                align : 'left',
                sortable : true,
                hidden : true
            },ChkLockFlag,ChkStkLockFlag, {
                header : '����',
                dataIndex : 'code',
                width : 60,
                align : 'left',
                sortable : true,
                hidden : false
            }, {
                header : "����",
                dataIndex : 'desc',
                width : 170,
                align : 'left',
                sortable : true
            },{
                header : "���",
                dataIndex : 'spec',
                width : 80,
                align : 'left',
                sortable : true
            },{
                header : "����",
                dataIndex : 'manf',
                width : 110,
                align : 'left',
                sortable : true
            },{
                header : "����",
                dataIndex : 'batchNo',
                width : 80,
                align : 'left',
                sortable : true
            },{
                header : "Ч��",
                dataIndex : 'batchExp',
                width : 80,
                align : 'left',
                sortable : true
            },{
                header : "������λ",
                dataIndex : 'bUomDesc',
                width : 80,
                align : 'left',
                sortable : true
            },{
                header : "��װ��λ",
                dataIndex : 'pUomDesc',
                width : 80,
                align : 'left',
                sortable : true
            },{
                header:"���",
                dataIndex:"stkQty",
                width : 80,
                align : 'left',
                sortable : true
            },{
                header:"���ÿ��",
                dataIndex:"avaQty",
                width : 80,
                align : 'left',
                sortable : true
            },{
                header:"����",
                dataIndex:"Rp",
                width : 80,
                align : 'left',
                sortable : true
            },{
                header:"�ۼ�",
                dataIndex:"Sp",
                width : 80,
                align : 'left',
                sortable : true
            }]);
    ItmLocBatCm.defaultSortable = true;

    // ����·��
    var DspPhaUrl = DictUrl
                + 'incitmlcbtaction.csp?actiontype=QueryBatch&start=&limit=';
    // ͨ��AJAX��ʽ���ú�̨����
    var proxy = new Ext.data.HttpProxy({
                url : DspPhaUrl,
                method : "POST"
            });
    // ָ���в���
    var fields = ["inclb","code","desc","spec","manf","batchNo","batchExp","bUomDesc","pUomDesc","stkQty","avaQty","Rp","Sp","lockFlag","stkFlag"];
    // ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
    var reader = new Ext.data.JsonReader({
                root : 'rows',
                totalProperty : "results",
                id : "inclb",
                fields : fields
            });
    // ���ݼ�
    var ItmLocBatStore = new Ext.data.Store({
                proxy : proxy,
                pruneModifiedRecords : true,
                reader : reader
                
            });
    var StatuTabPagingToolbar = new Ext.PagingToolbar({
        store : ItmLocBatStore,
        pageSize : PageSize,
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
    var ItmLocBatGrid = new Ext.grid.EditorGridPanel({
                id:'ItmLocBatGrid',
                region : 'center',
                cm : ItmLocBatCm,
                store : ItmLocBatStore,
                trackMouseOver : true,
                stripeRows : true,
                sm : new Ext.grid.CellSelectionModel({}),
                clicksToEdit : 1,
                bbar:StatuTabPagingToolbar,
                plugins: [ChkLockFlag,ChkStkLockFlag],
                loadMask : true
            });

var HisListTab = new Ext.form.FormPanel({
        title:'���ҿ��������Ϣ',
        labelWidth : 60,
        height : DHCSTFormStyle.FrmHeight(2),
        labelAlign : 'right',
        region: 'north',
        frame : true,
        tbar : [SearchBT,'-',RefreshBT, '-',SaveBT],            
        items : [{
                    layout:'column',
                    title:'��ѯ����',
                    xtype:'fieldset',
                    style:DHCSTFormStyle.FrmPaddingV,
                    defaults: {border:false}, 
                    items:[{
                            columnWidth:0.33,
                            xtype:'fieldset',
                            defaults: {width: 150},
                            items:[PhaLoc,StkGrpType]
                          },{
                            columnWidth:0.33,
                            xtype:'fieldset',
                            defaults: {width: 150},
                            items:[StockType,BatchLockType]
                          },{
                            columnWidth:0.33,
                            xtype:'fieldset',
                            defaults: {width: 150},
                            items:[InciDesc,StkLockType]
                          }]
        }]
    });

    // 5.2.ҳ�沼��
    var mainPanel = new Ext.Viewport({
                layout : 'border',
                items : [  HisListTab,
                    {
                         region: 'center',                                      
                         title: '���ҿ����---<font color=blue>��ɫ��ʾ����Ϊ�ɱ༭��</font>',
                         layout: 'fit', // specify layout manager for items
                         items: ItmLocBatGrid                             
                    }
                ],
                renderTo : 'mainPanel'
            });
    

    
})