// /����: ���۵���ѯ
// /����: ���۵���ѯ
// /��д�ߣ�zhangdongmei
// /��д����: 2013.01.04

Ext.onReady(function(){
    var gLocId=session['LOGON.CTLOCID'];
    var gUserId=session['LOGON.USERID'];
    var HospId=session['LOGON.HOSPID'];
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    
    // ���۵���
    var AspBatNo= new Ext.ux.TextField({
                fieldLabel : '���۵���',
                id : 'AspBatNo',
                name : 'AspBatNo'
            });

    // ��ʼ����
    var StartDate = new Ext.ux.DateField({
                fieldLabel : '��ʼ����',
                id : 'StartDate',
                name : 'StartDate',
                value : new Date().add(Date.DAY,-1)
            });

    // ��������
    var EndDate = new Ext.ux.DateField({
                fieldLabel : '��������',
                id : 'EndDate',
                name : 'EndDate',
                value : new Date()
            });

    // ����
    var StkGrpType=new Ext.ux.StkGrpComboBox({ 
        id : 'StkGrpType',
        name : 'StkGrpType',
        fieldLabel:'<font color=blue>��     ��</font>',
        StkType:App_StkTypeCode,     //��ʶ��������
        LocId:gLocId,
        UserId:gUserId,
        anchor : '90%'
       
    }); 
    
    var IncId=new Ext.ux.TextField({
            id:'IncId',
            name:'IncId',
            value:''
    });
        
    var IncDesc=new Ext.ux.TextField({
        id:'IncDesc',
        name:'IncDesc',
        fieldLabel:'��������',
        listeners:{
            'specialkey':function(field,e){
                var keycode=e.getKey();
                if(keycode==13){
                    var input=field.getValue();
                    var stkgrpid=Ext.getCmp("StkGrpType").getValue();
						GetPhaOrderWindow(input, stkgrpid, App_StkTypeCode,
									"", "N", "", HospId, getDrugList);
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
                    data : [['N', 'δ���'], ['A', '�����δ��Ч'],
                            ['Y', '����Ч']]
                });
    var Type = new Ext.ux.LocalComboBox({
                fieldLabel : '���۵�״̬',
                id : 'Type',
                name : 'Type',
                store : TypeStore
           
            });
        
    // ������ť
    var searchBT = new Ext.ux.Button({
                text : '��ѯ',
                tooltip : '�����ѯ������Ϣ',
                iconCls : 'page_find',
                handler : function() {
                    searchAspData();
                }
            });

    function searchAspData() {
        
        var StartDate = Ext.getCmp("StartDate").getValue()
        if(StartDate!=null && StartDate!=""){
        	StartDate=StartDate.format(ARG_DATEFORMAT);
        }
        if(StartDate==null||StartDate.length <= 0) {
            Msg.info("warning", "��ʼ���ڲ���Ϊ�գ�");
            return;
        }
        var EndDate = Ext.getCmp("EndDate").getValue();
        if(EndDate!=null && EndDate!=""){
        	EndDate=EndDate.format(ARG_DATEFORMAT);
        }
        if(EndDate==null||EndDate.length <= 0) {
            Msg.info("warning", "��ֹ���ڲ���Ϊ�գ�");
            return;
        }

        var AspBatNo = Ext.getCmp("AspBatNo").getValue();
        var StkGrpId=Ext.getCmp("StkGrpType").getValue();
		var IncDesc=Ext.getCmp("IncDesc").getValue();
		if(IncDesc==""){Ext.getCmp("IncId").setValue("");}
		var ItmId=Ext.getCmp("IncId").getValue();
		if(ItmId!=""&ItmId!=null){
			IncDesc="";
		}
        var Status=Ext.getCmp("Type").getValue();
        var Others=AspBatNo+"^"+Status+"^"+ItmId+"^"+StkGrpId+"^"+IncDesc;
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
        			Msg.info("error","��ѯ������鿴��־!");
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

    /*
    // �����ť�Ƿ����
    function changeButtonEnable(str) {
        var list = str.split("^");
        for (var i = 0; i < list.length; i++) {
            if (list[i] == "1") {
                list[i] = false;
            } else {
                list[i] = true;
            }
        }

        Ext.getCmp("SearchInItBT").setDisabled(list[0]);
        Ext.getCmp("SearchRqNoBT").setDisabled(list[1]);
        Ext.getCmp("ClearBT").setDisabled(list[2]);
        Ext.getCmp("AddBT").setDisabled(list[3]);
        Ext.getCmp("SaveBT").setDisabled(list[4]);
        Ext.getCmp("DeleteBT").setDisabled(list[5]);
        Ext.getCmp("DeleteDrugBT").setDisabled(list[6]);
        Ext.getCmp("CheckBT").setDisabled(list[7]);
    }
    */
    // ��հ�ť
    var clearBT = new Ext.Toolbar.Button({
                text : '���',
                tooltip : '������',
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
    var MasterInfoUrl = DictUrl + 'inadjpricebatchaction.csp?actiontype=QueryAspBatNo';
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
                header : "���۵���",
                dataIndex : 'AspBatNo',
                width : 120,
                align : 'left',
                sortable : true
            }, {
                header : "����������",
                dataIndex : 'AspDate',
                width : 100,
                align : 'left',
                sortable : true
            }, {
                header : '������',
                dataIndex : 'AspUser',
                width : 100,
                align : 'left',
                sortable : true
            }]);
    MasterInfoCm.defaultSortable = true;
    var MasterInfoPageToolBar=new Ext.ux.PagingToolbar({
        store:MasterInfoStore,
        pageSize:PageSize
             
    });
    var MasterInfoGrid = new Ext.ux.GridPanel({
        id : 'MasterInfoGrid',
        region:'west',
        width:'250',
        title:'���۵�(����)��Ϣ',
        split:true,
        collapsible:true,
        cm : MasterInfoCm,
        sm : new Ext.grid.RowSelectionModel({singleSelect : true}),
        store : MasterInfoStore,
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
    var DetailInfoUrl = DictUrl + 'inadjpricebatchaction.csp?actiontype=QueryAspBatDetail';
    // ͨ��AJAX��ʽ���ú�̨����
    var proxy = new Ext.data.HttpProxy({
                url : DetailInfoUrl,
                method : "GET"
            });
    
    // ָ���в���
    // rowid ������ �������� ���۵�λ ��ǰ�ۼ� �����ۼ� ��ۣ��ۼۣ� ��ǰ���� ������� ��ۣ����ۣ� ����ԭ�� ����ļ��� ����ļ�����ʱ�� ������
    var fields = ["AspBatId", "Incib","StkCatDesc", "InciDesc", "AspUomDesc",
            "PriorSpUom", "ResultSpUom", "DiffSpUom", "PriorRpUom",
            "ResultRpUom", "DiffRpUom", "Remark", "WarrentNo",
            "WnoDate", "CreatUserName","AdjUserName","Status","AdjReasonDesc","BatExp"];
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
                header : "״̬",
                dataIndex : 'Status',
                width : 80,
                align : 'left',
                sortable : true
            }, {
                header : "������",
                dataIndex : 'StkCatDesc',
                width : 80,
                align : 'left',
                sortable : true
            }, {
                header : '��������',
                dataIndex : 'InciDesc',
                width : 180,
                align : 'left',
                sortable : true
            }, {
                header : "���۵�λ",
                dataIndex : 'AspUomDesc',
                width : 80,
                align : 'left',
                sortable : true
            }, {
                header : "��ǰ�ۼ�",
                dataIndex : 'PriorSpUom',
                width : 80,
                align : 'right',
                sortable : true
            }, {
                header : "�����ۼ�",
                dataIndex : 'ResultSpUom',
                width : 80,
                align : 'right'
            }, {
                header : "���(�ۼ�)",
                dataIndex : 'DiffSpUom',
                width : 80,
                align : 'right',
                sortable : true
            }, {
                header : "��ǰ����",
                dataIndex : 'PriorRpUom',
                width : 80,
                align : 'right',
                sortable : true
            }, {
                header : "�������",
                dataIndex : 'ResultRpUom',
                width : 80,
                align : 'right',
                sortable : true
            }, {
                header : "���(����)",
                dataIndex : 'DiffRpUom',
                width : 80,
                align : 'right',
                sortable : true
            }, {
                header : "����ԭ��",
                dataIndex : 'AdjReasonDesc',
                width : 80,
                align : 'left',
                sortable : true
            }, {
                header : "����ļ���",
                dataIndex : 'WarrentNo',
                width : 80,
                align : 'left',
                sortable : true
            }, {
                header : "����ļ�����",
                dataIndex : 'WnoDate',
                width : 100,
                align : 'left',
                sortable : true
            }, {
                header : "�Ƶ���",
                dataIndex : 'CreatUserName',
                width : 100,
                align : 'left',
                sortable : true
            }, {
                header : "�����",
                dataIndex : 'AdjUserName',
                width : 100,
                align : 'left',
                sortable : true
            }, {
                header : "����/��Ч��",
                dataIndex : 'BatExp',
                width : 180,
                align : 'left',
                sortable : true
            }]);
    DetailInfoCm.defaultSortable = true;
    var DetailInfoPageToolBar=new Ext.ux.PagingToolbar({
        store:DetailInfoStore,
        pageSize:PageSize
        
    });
    var DetailInfoGrid = new Ext.ux.GridPanel({
		id:'DetailInfoGrid',
		title : '���۵�(����)��ϸ',
		region:'center',
		cm : DetailInfoCm,
		sm : new Ext.grid.RowSelectionModel({
					singleSelect : true
				}),
		store : DetailInfoStore,
		bbar:DetailInfoPageToolBar
	});
    var InfoForm= new Ext.ux.FormPanel({
        title:'���۵�(����)��ѯ',
        id : "InfoForm",
        tbar : [searchBT, '-', clearBT],        
        items : [{
			xtype : 'fieldset',
			title : '��ѯ����',
			defaults: {border:false,xtype:'fieldset',columnWidth:.3},
			layout: 'column',
			style : 'padding:5px 0px 0px 5px',
			items : [{
				items : [StartDate,EndDate]
			}, {
				items : [AspBatNo,Type]
			}, {
				items : [StkGrpType,IncDesc]
			}]
        }]              
    });
    

    var mainPanel = new Ext.ux.Viewport({
        layout : 'border',
        items : [InfoForm,MasterInfoGrid,DetailInfoGrid]
    });
});
