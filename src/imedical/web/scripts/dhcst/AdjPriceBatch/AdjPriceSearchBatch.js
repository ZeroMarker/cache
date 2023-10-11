// /����: ���۵���ѯ
// /����: ���۵���ѯ
// /��д�ߣ�zhangdongmei
// /��д����: 2013.01.04

Ext.onReady(function(){
    var gLocId=session['LOGON.CTLOCID'];
    var gUserId=session['LOGON.USERID'];
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    
    // ���۵���
    var AspBatNo= new Ext.form.TextField({
                fieldLabel : $g('���۵���'),
                id : 'AspBatNo',
                name : 'AspBatNo',
                anchor:'90%',
                width : 120
            });

    // ��ʼ����
    var StartDate = new Ext.ux.DateField({
                fieldLabel : $g('��ʼ����'),
                id : 'StartDate',
                name : 'StartDate',
                anchor:'90%',
                width : 120,
                value : new Date().add(Date.DAY,-1)
            });

    // ��������
    var EndDate = new Ext.ux.DateField({
                fieldLabel : $g('��������'),
                id : 'EndDate',
                name : 'EndDate',
                anchor:'90%',
                width : 120,
                value : new Date()
            });

    // ҩƷ����
    var StkGrpType=new Ext.ux.StkGrpComboBox({ 
        id : 'StkGrpType',
        name : 'StkGrpType',
        fieldLabel:'<font color=blue>'+$g('�ࡡ����')+'</font>',
        StkType:App_StkTypeCode,     //��ʶ��������
        LocId:gLocId,
        UserId:gUserId,
        width : 150,
        anchor:'90%'
    }); 
    
    var IncId=new Ext.form.TextField({
            id:'IncId',
            name:'IncId',
            value:''
    });
        
    var IncDesc=new Ext.form.TextField({
        id:'IncDesc',
        name:'IncDesc',
        fieldLabel:$g('ҩƷ����'),
        width:150,
        anchor:'90%',
        listeners:{
            'specialkey':function(field,e){
                var keycode=e.getKey();
                if(keycode==13){
                    var input=field.getValue();
                    var stkgrpid=Ext.getCmp("StkGrpType").getValue();
                    GetPhaOrderWindow(input, stkgrpid, App_StkTypeCode, "", "N","", "", getDrugList);
                }
            }
        }
    });
    
    /**
     * ���ط���
    */
    function getDrugList(record) {
        if (record == null || record == "") {
            return;
        }
        var inciDr = record.get("InciDr");
        var inciCode=record.get("InciCode");
        var inciDesc=record.get("InciDesc");
        Ext.getCmp("IncId").setValue(inciDr);
        Ext.getCmp("IncDesc").setValue(inciDesc);
    }
    
    var TypeStore = new Ext.data.SimpleStore({
                    fields : ['RowId', 'Description'],
                    data : [['N', $g('δ���')], ['A', $g('�����δ��Ч')],
                            ['Y', $g('����Ч')]]
                });
    var Type = new Ext.form.ComboBox({
                fieldLabel : $g('���۵�״̬'),
                id : 'Type',
                name : 'Type',
                width : 100,
                store : TypeStore,
                triggerAction : 'all',
                mode : 'local',
                valueField : 'RowId',
                displayField : 'Description',
                anchor:'90%',
                allowBlank : true,
                triggerAction : 'all',
                selectOnFocus : true,
                forceSelection : true,
                minChars : 1,
                editable : true,
                valueNotFoundText : ''
            });
        
    // ������ť
    var searchBT = new Ext.Toolbar.Button({
                text : $g('��ѯ'),
                tooltip : $g('�����ѯ������Ϣ'),
                iconCls : 'page_find',
                height:30,
                width:70,
                handler : function() {
                    searchAspData();
                }
            });

    function searchAspData() {
        
        var StartDate = Ext.getCmp("StartDate").getValue()
        if(StartDate!=null && StartDate!=""){
        	StartDate=StartDate.format(App_StkDateFormat);
        }
        if(StartDate==null||StartDate.length <= 0) {
            Msg.info("warning", $g("��ʼ���ڲ���Ϊ�գ�"));
            return;
        }
        var EndDate = Ext.getCmp("EndDate").getValue();
        if(EndDate!=null && EndDate!=""){
        	EndDate=EndDate.format(App_StkDateFormat);
        }
        if(EndDate==null||EndDate.length <= 0) {
            Msg.info("warning", $g("��ֹ���ڲ���Ϊ�գ�"));
            return;
        }

        var AspBatNo = Ext.getCmp("AspBatNo").getValue();
        var StkGrpId=Ext.getCmp("StkGrpType").getValue();        
        if(Ext.getCmp("IncDesc").getValue()==""){
	        Ext.getCmp("IncId").setValue("");
		}
		var ItmId=Ext.getCmp("IncId").getValue(); 
        var Status=Ext.getCmp("Type").getValue();
        var Others=AspBatNo+"^"+Status+"^"+ItmId+"^"+StkGrpId;
        MasterInfoStore.setBaseParam("StartDate",StartDate);
        MasterInfoStore.setBaseParam("EndDate",EndDate);
        MasterInfoStore.setBaseParam("Others",Others);
        var PageSize=MasterInfoPageToolBar.pageSize;
        MasterInfoStore.removeAll();
        DetailInfoGrid.getStore().removeAll();
        MasterInfoStore.load({
        	params:{start:0,limit:PageSize},
        	callback:function(r,options,success){
        		if(success==false){
        			Msg.info("error",$g("��ѯ������鿴��־!"));
        		}else{
        			if(r.length>0){
        				MasterInfoGrid.getSelectionModel().selectFirstRow();
	     				MasterInfoGrid.getSelectionModel().fireEvent('rowselect',this,0);
	     				MasterInfoGrid.getView().focusRow(0);
        			}
        		}
        	}
        });  
    }
		// ��水ť
	var SaveAsBT = new Ext.Toolbar.Button({
				text : $g('���'),
				tooltip : $g('���ΪExcel'),
				iconCls : 'page_excel',
				width : 70,
				height : 30,
				handler : function() {
					ExportAllToExcel(DetailInfoGrid);
					//gridSaveAsExcel(StockQtyGrid);
				}
			});
    // ��հ�ť
    var clearBT = new Ext.Toolbar.Button({
                text : $g('����'),
                tooltip : $g('�������'),
                iconCls : 'page_clearscreen',
                height:30,
                width:70,
                handler : function() {
                    clearData();
                }
            });

    function clearData() {
        Ext.getCmp("AspBatNo").setValue("");
        Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY,-1));
        Ext.getCmp("EndDate").setValue(new Date());
        Ext.getCmp("StkGrpType").getStore().load();
        Ext.getCmp("Type").setValue("");
        Ext.getCmp("IncDesc").setValue("");
        MasterInfoGrid.getStore().removeAll();
        MasterInfoGrid.getView().refresh();
        //DetailInfoPageToolBar.bind(DetailInfoGrid.getStore());
        DetailInfoGrid.getStore().removeAll();
        DetailInfoGrid.getView().refresh();
        
        
          DetailInfoGrid.getStore().totalLength=0;
         
          DetailInfoPageToolBar.updateInfo();
          DetailInfoPageToolBar.first.setDisabled(true);
          DetailInfoPageToolBar.prev.setDisabled(true);
          DetailInfoPageToolBar.next.setDisabled(true);
          DetailInfoPageToolBar.last.setDisabled(true); 
         
    }

    // ����·��
    var MasterInfoUrl = DictUrl + 'inadjpriceactionbatch.csp?actiontype=QueryAspBatNo';
    // ͨ��AJAX��ʽ���ú�̨����
    var proxy = new Ext.data.HttpProxy({
                url : MasterInfoUrl,
                method : "POST"
            });
    // ָ���в���
    // ���۵��� ���һ�θ������� ���һ�θ�����
    // 
    var fields = ["AspBatNo", "AspDate", "AspUser"];
    // ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
    var reader = new Ext.data.JsonReader({
                root : 'rows',
                totalProperty : "results",
                id : "AspBatNo",
                fields : fields
            });
    // ���ݼ�
    var MasterInfoStore = new Ext.data.Store({
                proxy : proxy,
                reader : reader,
                baseParams:{
                    StartDate:'',
                    EndDate:'',
                    Others:''               
                }
            });
    var nm = new Ext.grid.RowNumberer();
    var MasterInfoCm = new Ext.grid.ColumnModel([nm, {
                header : $g("���۵���"),
                dataIndex : 'AspBatNo',
                width : 120,
                align : 'left',
                sortable : true
            }, {
                header : $g("����������"),
                dataIndex : 'AspDate',
                width : 100,
                align : 'left',
                sortable : true
            }, {
                header : $g('������'),
                dataIndex : 'AspUser',
                width : 100,
                align : 'left',
                sortable : true
            }]);
    MasterInfoCm.defaultSortable = true;
    var MasterInfoPageToolBar=new Ext.PagingToolbar({
        store:MasterInfoStore,
        pageSize:PageSize,
        displayInfo:true,
        displayMsg:$g('�� {0} ���� {1}�� ��һ�� {2} ��'),
        emptyMsg:$g('û�м�¼'),
        firstText:$g('��һҳ'),
        lastText:$g('���һҳ'),
        nextText:$g('��һҳ'),
        prevText:$g('��һҳ')      
    });
    var MasterInfoGrid = new Ext.grid.GridPanel({
        id : 'MasterInfoGrid',
//        title : '���۵���Ϣ',
        height : 170,
        cm : MasterInfoCm,
        sm : new Ext.grid.RowSelectionModel({singleSelect : true}),
        store : MasterInfoStore,
        trackMouseOver : true,
        stripeRows : true,
        loadMask : true,
        bbar:MasterInfoPageToolBar
    });

    // ��ӱ�񵥻����¼�
    MasterInfoGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
        var aspBatNo = MasterInfoStore.getAt(rowIndex).get("AspBatNo");
        var status=Ext.getCmp("Type").getValue();
        var stkgrpid=Ext.getCmp("StkGrpType").getValue();
        var incid=Ext.getCmp("IncId").getValue();
        DetailInfoStore.setBaseParam("AspBatNo",aspBatNo);
        DetailInfoStore.setBaseParam("Status",status);
        DetailInfoStore.setBaseParam("StkGrpId",stkgrpid);
        DetailInfoStore.setBaseParam("IncId",incid);
        
        var pageSize=DetailInfoPageToolBar.pageSize;
        DetailInfoStore.load({params:{start:0,limit:pageSize}});
    });

    // ����·��
    var DetailInfoUrl = DictUrl + 'inadjpriceactionbatch.csp?actiontype=QueryAspBatDetail';
    // ͨ��AJAX��ʽ���ú�̨����
    var proxy = new Ext.data.HttpProxy({
                url : DetailInfoUrl,
                method : "GET"
            });
    
    // ָ���в���
    // rowid ������ ҩƷ���� ���۵�λ ��ǰ�ۼ� �����ۼ� ��ۣ��ۼۣ� ��ǰ���� ������� ��ۣ����ۣ� ����ԭ�� ����ļ��� ����ļ�����ʱ�� ������
    var fields = ["AspBatId", "Incib","StkCatDesc", "InciDesc", "AspUomDesc",
            "PriorSpUom", "ResultSpUom", "DiffSpUom", "PriorRpUom",
            "ResultRpUom", "DiffRpUom", "Remark", "WarrentNo",
            "WnoDate", "CreatUserName","AdjUserName","Status","AdjReasonDesc"];
    // ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
    var reader = new Ext.data.JsonReader({
                root : 'rows',
                totalProperty : "results",
                id : "AspBatId",
                fields : fields
            });
    // ���ݼ�
    var DetailInfoStore = new Ext.data.Store({
        proxy : proxy,
        reader : reader,
        baseParams:{
            AspBatNo:'',
            Status:'',
            StkGrpId:'',
            IncId:''
        }
    });
    
    var nm = new Ext.grid.RowNumberer();
    var DetailInfoCm = new Ext.grid.ColumnModel([nm, {
                header : "AspBatId",
                dataIndex : 'AspBatId',
                width : 100,
                align : 'left',
                sortable : true,
                hidden : true
            }, {   
		  header : "Incib",
		  dataIndex : 'Incib',
		  width : 80,
		  align : 'left',
		  sortable : true,
		  hidden : true
	     }, {
                header : $g("״̬"),
                dataIndex : 'Status',
                width : 80,
                align : 'left',
                sortable : true
            }, {
                header : $g("������"),
                dataIndex : 'StkCatDesc',
                width : 80,
                align : 'left',
                sortable : true
            }, {
                header : $g('ҩƷ����'),
                dataIndex : 'InciDesc',
                width : 180,
                align : 'left',
                sortable : true
            }, {
                header : $g("���۵�λ"),
                dataIndex : 'AspUomDesc',
                width : 80,
                align : 'left',
                sortable : true
            }, {
                header : $g("��ǰ�ۼ�"),
                dataIndex : 'PriorSpUom',
                width : 80,
                align : 'right',
                sortable : true
            }, {
                header : $g("�����ۼ�"),
                dataIndex : 'ResultSpUom',
                width : 80,
                align : 'right'
            }, {
                header : $g("���(�ۼ�)"),
                dataIndex : 'DiffSpUom',
                width : 80,
                align : 'right',
                sortable : true
            }, {
                header : $g("��ǰ����"),
                dataIndex : 'PriorRpUom',
                width : 80,
                align : 'right',
                sortable : true
            }, {
                header : $g("�������"),
                dataIndex : 'ResultRpUom',
                width : 80,
                align : 'right',
                sortable : true
            }, {
                header : $g("���(����)"),
                dataIndex : 'DiffRpUom',
                width : 80,
                align : 'right',
                sortable : true
            }, {
                header : $g("����ԭ��"),
                dataIndex : 'AdjReasonDesc',
                width : 80,
                align : 'left',
                sortable : true
            }, {
                header : $g("����ļ���"),
                dataIndex : 'WarrentNo',
                width : 80,
                align : 'left',
                sortable : true
            }, {
                header : $g("����ļ�����"),
                dataIndex : 'WnoDate',
                width : 100,
                align : 'left',
                sortable : true
            }, {
                header : $g("������"),
                dataIndex : 'CreatUserName',
                width : 100,
                align : 'left',
                sortable : true
            }, {
                header : $g("������"),
                dataIndex : 'AdjUserName',
                width : 100,
                align : 'left',
                sortable : true
            }]);
    DetailInfoCm.defaultSortable = true;
    var DetailInfoPageToolBar=new Ext.PagingToolbar({
        store:DetailInfoStore,
        pageSize:PageSize,
        displayInfo:true,
        displayMsg:$g('�� {0} ���� {1}�� ��һ�� {2} ��'),
        emptyMsg:$g('û�м�¼'),
        firstText:$g('��һҳ'),
        lastText:$g('���һҳ'),
        nextText:$g('��һҳ'),
        prevText:$g('��һҳ')      
    });
    var DetailInfoGrid = new Ext.grid.GridPanel({
                title : $g('���۵�(����)��ϸ'),
                height : 170,
                cm : DetailInfoCm,
                sm : new Ext.grid.RowSelectionModel({
                            singleSelect : true
                        }),
                store : DetailInfoStore,
                trackMouseOver : true,
                stripeRows : true,
                loadMask : true,
                bbar:DetailInfoPageToolBar
            });

    // ˫���¼�
   // MasterInfoGrid.on('rowdblclick', function() {
    //            returnData();
   //         });

    var InfoForm= new Ext.form.FormPanel({
        frame : true,
        labelWidth: 80, 
        title:$g('���۵�(����)��ѯ'),
        labelAlign : 'right',
        id : "InfoForm",
        tbar : [searchBT, '-',clearBT ,'-',SaveAsBT],        
        items : [{
            xtype : 'fieldset',
            title : $g('��ѯ����'),
            autoHeight : true,
            style: DHCSTFormStyle.FrmPaddingV,
            defaults: {border:false},    // Default config options for child items
            layout: 'column',    // Specifies that the items will now be arranged in columns
            items : [{
                columnWidth : .3,
                xtype:'fieldset',
                autoHeight: true,
                items : [StartDate,EndDate]
            }, {
                columnWidth : .3,
                xtype:'fieldset',
                autoHeight: true,
                items : [AspBatNo,Type]
            }, {
                columnWidth : .3,
                xtype:'fieldset',
                
                items : [StkGrpType,IncDesc]
            }]
        }]              
    });
    

    var mainPanel = new Ext.Viewport({
        layout : 'border',
        items : [{
            region:'north',
            height:DHCSTFormStyle.FrmHeight(2),
            layout:'fit',
            items:InfoForm
        },{ title : $g('���۵�(����)��Ϣ'),
            region:'west',
            width:250,
            split:true,
            collapsible:true,
            minSize:200,
            maxSize:350,
            layout:'fit',
            margins: '0 5 0 0',
            items:MasterInfoGrid
        },{
            region:'center',
            layout:'fit',
            items:DetailInfoGrid
        }]
    });
    
    
    
    
});
