// /����: ���۵���ѯ
// /����: ���۵���ѯ
// /��д�ߣ�zhangdongmei
// /��д����: 2013.01.04

Ext.onReady(function(){
    var gLocId=session['LOGON.CTLOCID'];
    var gUserId=session['LOGON.USERID'];
	var adjNo=""
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    
    // ���۵���
    var AspNo= new Ext.form.TextField({
		fieldLabel : '���۵���',
		id : 'AspNo',
		name : 'AspNo',
		anchor:'90%',
		width : 120
	});

    // ��ʼ����
    var StartDate = new Ext.ux.DateField({
		fieldLabel : '��ʼ����',
		id : 'StartDate',
		name : 'StartDate',
		anchor:'90%',
		width : 120,
		value : new Date().add(Date.DAY,-1)
	});

    // ��������
    var EndDate = new Ext.ux.DateField({
		fieldLabel : '��������',
		id : 'EndDate',
		name : 'EndDate',
		anchor:'90%',
		width : 120,
		value : new Date()
	});

    // ��������
    var StkGrpType=new Ext.ux.StkGrpComboBox({ 
        id : 'StkGrpType',
        name : 'StkGrpType',
        fieldLabel:'<font color=blue>��     ��</font>',
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
        fieldLabel:'��������',
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
		data : [['No', 'δ���'], ['Audit', '�����δ��Ч'],
				['Yes', '����Ч']]
	});
    var Type = new Ext.form.ComboBox({
		fieldLabel : '���۵�״̬',
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

	var ExcludeNew = new Ext.form.Checkbox({
		boxLabel : '�ų����ε���',
		id : 'ExcludeNew',
		name : 'ExcludeNew',
		anchor : '100%',
		checked : true
	});
            
    // ������ť
    var searchBT = new Ext.Toolbar.Button({
		text : '����',
		tooltip : '�������������Ϣ',
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
        var AspNo = Ext.getCmp("AspNo").getValue();
        var StkGrpId=Ext.getCmp("StkGrpType").getValue();       
		var IncDesc=Ext.getCmp("IncDesc").getValue();
        if(IncDesc==""){Ext.getCmp("IncId").setValue("");}
		var ItmId=Ext.getCmp("IncId").getValue();
		if(ItmId!=""&ItmId!=null){
			IncDesc="";
		}
        var Status=Ext.getCmp("Type").getValue();
        var ExcludeNew=Ext.getCmp("ExcludeNew").getValue()?1:0;
        var Others=AspNo+"^"+Status+"^"+ItmId+"^"+StkGrpId+"^"+ExcludeNew+"^"+IncDesc;
        MasterInfoStore.setBaseParam("StartDate",StartDate);
        MasterInfoStore.setBaseParam("EndDate",EndDate);
        MasterInfoStore.setBaseParam("Others",Others);
        var PageSize=MasterInfoPageToolBar.pageSize;
        DetailInfoGrid.getStore().removeAll();
        DetailInfoGrid.getView().refresh();
        MasterInfoStore.removeAll();
        MasterInfoStore.load({
        	params:{start:0,limit:PageSize},
			callback : function(r,options, success){
				if(success==false){
     				Msg.info("error", "��ѯ������鿴��־!");
     			}else{
     				if(r.length>0){
     					MasterInfoGrid.getSelectionModel().selectFirstRow();
     					MasterInfoGrid.fireEvent('rowselect',this,0);
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
        Ext.getCmp("AspNo").setValue("");
        Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY,-1));
        Ext.getCmp("EndDate").setValue(new Date());
        Ext.getCmp("StkGrpType").getStore().load();
        Ext.getCmp("Type").setValue("");
        Ext.getCmp("IncDesc").setValue("");
        MasterInfoGrid.getStore().removeAll();
        MasterInfoGrid.getView().refresh();
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
    var MasterInfoUrl = DictUrl + 'inadjpriceaction.csp?actiontype=QueryAspNo';
    // ͨ��AJAX��ʽ���ú�̨����
    var proxy = new Ext.data.HttpProxy({
		url : MasterInfoUrl,
		method : "POST"
	});
    // ָ���в���
    // ���۵��� ���һ�θ������� ���һ�θ�����
    // 
    var fields = ["AspNo", "AspDate", "AspUser"];
    // ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
    var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "AspNo",
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
			dataIndex : 'AspNo',
			width : 100,
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
    var MasterInfoPageToolBar=new Ext.PagingToolbar({
        store:MasterInfoStore,
        pageSize:PageSize,
        displayInfo:true,
        displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
        emptyMsg:'û�м�¼',
        firstText:'��һҳ',
        lastText:'���һҳ',
        nextText:'��һҳ',
        prevText:'��һҳ'      
    });
    var MasterInfoGrid = new Ext.grid.GridPanel({
		title : '���۵���Ϣ',
        region:'west',
		width:250,
		split:true,
		collapsible:true,
		minSize:200,
		maxSize:350,
		layout:'fit',
		margins: '0 5 0 0',
        id : 'MasterInfoGrid',
        cm : MasterInfoCm,
        sm : new Ext.grid.RowSelectionModel({
			singleSelect : true,
			listeners : {
				rowselect : function(sm,rowIndex,record){
					var aspno=record.get('AspNo');
					var status=Ext.getCmp("Type").getValue();
					var stkgrpid=Ext.getCmp("StkGrpType").getValue();
					var incid=Ext.getCmp("IncId").getValue();
					if(Ext.getCmp("IncDesc").getValue()==""){incid="";}
					adjNo=aspno;
					DetailInfoStore.setBaseParam("AspNo",aspno);
					DetailInfoStore.setBaseParam("Status",status);
					DetailInfoStore.setBaseParam("StkGrpId",stkgrpid);
					DetailInfoStore.setBaseParam("IncId",incid);					
					var pageSize=DetailInfoPageToolBar.pageSize;
					DetailInfoStore.load({params:{start:0,limit:pageSize}});
				}
			}
		}),
        store : MasterInfoStore,
        trackMouseOver : true,
        stripeRows : true,
        loadMask : true,
        bbar:MasterInfoPageToolBar
    });
	
    // ����·��
    var DetailInfoUrl = DictUrl + 'inadjpriceaction.csp?actiontype=QueryAspDetail';
    // ͨ��AJAX��ʽ���ú�̨����
    var proxy = new Ext.data.HttpProxy({
		url : DetailInfoUrl,
		method : "GET"
	});
    // ָ���в���
    // rowid ������ �������� ���۵�λ ��ǰ�ۼ� �����ۼ� ��ۣ��ۼۣ� ��ǰ���� ������� ��ۣ����ۣ� ����ԭ�� ����ļ��� �ƻ���Ч���� ʵ����Ч���� ����ļ�����ʱ�� ������
    var fields = ["AspId", "StkCatDesc","InciCode","InciDesc", "AspUomDesc",
            "PriorSpUom", "ResultSpUom", "DiffSpUom", "PriorRpUom",
            "ResultRpUom", "DiffRpUom", "Remark", "WarrentNo","PreExecuteDate",
            "ExecuteDate","WnoDate", "AdjUserName","Status","AdjReasonDesc","AuditUserName","ExeUserName","Spec"];
    // ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
    var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "AspId",
		fields : fields
	});
    // ���ݼ�
    var DetailInfoStore = new Ext.data.Store({
        proxy : proxy,
        reader : reader,
        baseParams:{
            AspNo:'',
            Status:'',
            StkGrpId:'',
            IncId:''
        }
    });
    var nm = new Ext.grid.RowNumberer();
    var DetailInfoCm = new Ext.grid.ColumnModel([nm, {
			header : "AspId",
			dataIndex : 'AspId',
			width : 100,
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
		},{
			header : '���ʴ���',
			dataIndex : 'InciCode',
			width : 100,
			align : 'left',
			sortable : true
		},{
			header : '��������',
			dataIndex : 'InciDesc',
			width : 180,
			align : 'left',
			sortable : true
		},{
			header : '���',
			dataIndex : 'Spec',
			width : 100,
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
		},{
			header : "�ƻ���Ч����",
			dataIndex : 'PreExecuteDate',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "ʵ����Ч����",
			dataIndex : 'ExecuteDate',
			width : 100,
			align : 'left',
			sortable : true
		},  {
			header : "��۱�������",
			dataIndex : 'WnoDate',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "�Ƶ���",
			dataIndex : 'AdjUserName',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "�����",
			dataIndex : 'AuditUserName',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "��Ч��",
			dataIndex : 'ExeUserName',
			width : 100,
			align : 'left',
			sortable : true
		}]);
    DetailInfoCm.defaultSortable = true;
    var DetailInfoPageToolBar=new Ext.PagingToolbar({
        store:DetailInfoStore,
        pageSize:PageSize,
        displayInfo:true,
        displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
        emptyMsg:'û�м�¼',
        firstText:'��һҳ',
        lastText:'���һҳ',
        nextText:'��һҳ',
        prevText:'��һҳ'      
    });
    // ��ӡ
	var PrintBT= new Ext.Toolbar.Button({
		id : "PrintBT",
		text : '��ӡ',
		tooltip : '��ӡ��ϸ',
		width : 70,
		height : 30,
		iconCls : 'page_print',
		handler : function(){
			PrintDetail();
		}
	});
	function PrintDetail(){
		var AspNo = adjNo;
		var status=Ext.getCmp("Type").getValue();
		var stkgrpid=Ext.getCmp("StkGrpType").getValue();
		var incid=Ext.getCmp("IncId").getValue();
		var reportFrame=document.getElementById("frameReport");
		var Strparms=AspNo+"^"+status+"^"+stkgrpid+"^"+incid
		fileName="DHCSTM_ItmAdj.raq&Strparms="+Strparms+"";
		DHCSTM_DHCCPM_RQPrint(fileName);
	}
    var DetailInfoGrid = new Ext.grid.GridPanel({
		region:'center',
        layout:'fit',
		title : '���۵���ϸ',
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

    var InfoForm = new Ext.ux.FormPanel({
        title:'���۵���ѯ',
        id : "InfoForm",
        tbar : [searchBT, '-', clearBT,'-',PrintBT],        
        items : [{
			xtype : 'fieldset',
			title : '��ѯ����',
			style:'padding:5px 0px 0px 5px',
			defaults: {xtype:'fieldset',border:false},
			layout: 'column',
			items : [{
				columnWidth : .25,
				items : [StartDate,EndDate]
			}, {
				columnWidth : .25,
				items : [AspNo,Type]
			}, {
				columnWidth : .25,
				items : [StkGrpType,IncDesc]
			}, {
				columnWidth : .25,
				items : [ExcludeNew]
			}]
        }]              
    });

    var mainPanel = new Ext.ux.Viewport({
        layout : 'border',
        items : [InfoForm,MasterInfoGrid,DetailInfoGrid]
    });   
});
