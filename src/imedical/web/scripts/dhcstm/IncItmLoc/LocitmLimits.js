// /����: ���ҿ��������ά��
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
        groupId:gGroupId
    });
    
    // ��������
    var StkGrpType=new Ext.ux.StkGrpComboBox({ 
        id : 'StkGrpType',
        name : 'StkGrpType',
        StkType:App_StkTypeCode,     //��ʶ��������
        UserId:gUserId,
        LocId:gLocId,
        anchor : '90%'
    }); 
    
    var InciDesc = new Ext.form.TextField({
		fieldLabel : '��������',
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
     * �������ʴ��岢���ؽ��
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
    }
    // ��ѯ��ť
    var SearchBT = new Ext.Toolbar.Button({
		text : '��ѯ',
		tooltip : '�����ѯ',
		iconCls : 'page_find',
		width : 70,
		height : 30,
		handler : function() {
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
        var StkGrpRowId = Ext.getCmp("StkGrpType").getValue();
        gStrParam=phaLoc+"^"+gIncId+"^"+StkGrpRowId;
        var PageSize=StatuTabPagingToolbar.pageSize;
        ItmLocStore.setBaseParam('Params',gStrParam);   //��ҳʱ�����������ᶪʧ
        ItmLocStore.removeAll();
        ItmLocStore.load({params:{start:0,limit:PageSize}});
    }
    
    // ��հ�ť
    var RefreshBT = new Ext.Toolbar.Button({
		text : '���',
		tooltip : '������',
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
        Ext.getCmp("StkGrpType").setValue("");
        Ext.getCmp("StkGrpType").getStore().load();
        SetLogInDept(Ext.getCmp("PhaLoc").getStore(), "PhaLoc");
        Ext.getCmp("InciDesc").setValue('');
        ItmLocGrid.store.removeAll();
        ItmLocGrid.getView().refresh();
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
			if(CheckDataBeforeSave()==true){                  
				save(); 
			}                    
		}
	});
    function CheckDataBeforeSave(){
	    var rowCount = ItmLocGrid.getStore().getCount();
        for (var i = 0; i < rowCount; i++) {
            var rowData = ItmLocStore.getAt(i); 
            //���������ݷ����仯ʱִ����������           
			var MaxQty=rowData.get("MaxQty");
			var MinQty=rowData.get("MinQty");
			MaxQty=parseFloat(MaxQty)
			MinQty=parseFloat(MinQty)
			if((MaxQty!=0)&&(MaxQty<MinQty)){
				var n=i+1
				Msg.info("warning","��"+n+"�п������С�ڿ������!");
				return
			} 
		}
	    return true;	    
    }  
	          
    function save(){       
        var ListDetail="";
		var mr=ItmLocStore.getModifiedRecords();
		var data="";
		var rows="";
		for(var i=0;i<mr.length;i++){
			var LocId=Ext.getCmp("PhaLoc").getValue();
			var ILERowId = mr[i].data["ILERowId"].trim();
			var SpecRowId = mr[i].data["SpecRowId"].trim();
			var Inci = mr[i].data["Inci"];
			var SpecDesc = mr[i].data["SpecDesc"];
			var MaxQty = mr[i].data["MaxQty"];
			var MinQty = mr[i].data["MinQty"];	
			var dataRow =LocId+"^"+ILERowId+"^"+SpecRowId +"^"+Inci+"^"+SpecDesc+"^"+MaxQty+"^"+MinQty;
			
			if(ListDetail==""){
				ListDetail = dataRow;
			}else{
				ListDetail = ListDetail+xRowDelim()+dataRow;
			}
		}
		var url = DictUrl
				+ "locitmlimitsaction.csp?actiontype=Save";
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
					Query();

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

    var nm = new Ext.grid.RowNumberer();
    var ItmLocCm = new Ext.grid.ColumnModel([nm, {
			header : "SpecRowId",
			dataIndex : 'SpecRowId',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		},{
			header : "ILERowId",
			dataIndex : 'ILERowId',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		},{
			header : "Inci",
			dataIndex : 'Inci',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : '���ʴ���',
			dataIndex : 'InciCode',
			width : 140,
			align : 'left',
			sortable : true,
			hidden : false
		}, {
			header : "��������",
			dataIndex : 'InciDesc',
			width : 200,
			align : 'left',
			sortable : true
		},{
			header : "������",
			dataIndex : 'SpecDesc',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "������λ",
			dataIndex : 'BUomDesc',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "��װ��λ",
			dataIndex : 'PUomDesc',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "<font color=blue>�������</font>",
			dataIndex : 'MaxQty',
			width : 100,
			align : 'right',
			sortable : true,
			editor:new Ext.form.NumberField({
				selectOnFocus:true,
				listeners:{
					specialkey: function(field, e){
						var num=e.getKey();						
						if(num == e.ENTER){                                 
							var index=GetColIndex(ItmLocGrid,"MinQty");
							var cell=ItmLocGrid.getSelectionModel().getSelectedCell();
							var row=cell[0];
							ItmLocGrid.startEditing(row,index);
						}
					}
				}
			})			
		},{
			header:"<font color=blue>�������</font>",
			dataIndex:"MinQty",
			width : 100,
			align : 'right',
			sortable : true,
			editor:new Ext.form.NumberField({
				selectOnFocus:true,
				listeners:{
					specialkey:function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER) {
								addNewRow()
						}
					}
				}
			})		
		}]);
    ItmLocCm.defaultSortable = true;

    // ����·��
    var DspPhaUrl = DictUrl
                + 'locitmlimitsaction.csp?actiontype=Query&start=&limit=';
    // ͨ��AJAX��ʽ���ú�̨����
    var proxy = new Ext.data.HttpProxy({
                url : DspPhaUrl,
                method : "POST"
            });
    // ָ���в���
    var fields = ["SpecRowId","ILERowId", "Inci", "InciCode", "InciDesc","SpecDesc","BUomDesc","PUomDesc","MaxQty","MinQty"];
    // ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
    var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "SpecRowId",
		fields : fields
	});
    // ���ݼ�
    var ItmLocStore = new Ext.data.Store({
		proxy : proxy,
		pruneModifiedRecords : true,
		reader : reader
		
	});
    var StatuTabPagingToolbar = new Ext.PagingToolbar({
        store : ItmLocStore,
        pageSize : PageSize,
        displayInfo : true
    });
	var ItmLocGrid = new Ext.ux.EditorGridPanel({
		region: 'center',
		id : 'ItmLocGrid',
		title: '���ҿ����<font color=blue>��ɫ��ʾ����Ϊ�ɱ༭��</font>',
		id:'ItmLocGrid',
		cm : ItmLocCm,
		store : ItmLocStore,
		trackMouseOver : true,
		stripeRows : true,
		sm : new Ext.grid.CellSelectionModel({}),
		clicksToEdit : 1,
		bbar:StatuTabPagingToolbar,
		loadMask : true
	});
/*
    var HisListTab = new Ext.ux.FormPanel({
        title:'���ҿ��������ά��',
        tbar : [SearchBT, '-',SaveBT,'-',RefreshBT],            
        items : [{
			xtype : 'fieldset',
			title : '��ѯ����',
			layout : 'column',
			style : 'padding:5px 0px 0px 5px',
			defaults:{border:false,xtype:'fieldset'},
			items:[{
					columnWidth:0.3,
					items:[PhaLoc]
				},{
					columnWidth:0.3,
					items:[StkGrpType]
				},{
					columnWidth:0.3,
					items:[InciDesc]
				}]
        }]
    });

    // 5.2.ҳ�沼��
    var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [  HisListTab,ItmLocGrid],
		renderTo : 'mainPanel'
	}); 
	*/
    var HisListTab = new Ext.form.FormPanel({
        title:'���ҿ��������ά��',
        labelwidth : 30,
        height : 120,
        labelAlign : 'right',
        region: 'north',
        frame : true,
        tbar : [SearchBT, '-',SaveBT,'-',RefreshBT],            
        items : [{
			layout:'column',
			title:'��ѯ����',
			xtype:'fieldset',
			style:'padding:0px 0px 0px 0px;',
			defaults: {border:false}, 
			items:[{
					columnWidth:0.34,
					xtype:'fieldset',
					defaults: {width: 180},
					items:[PhaLoc]
				},{
					columnWidth:0.33,
					xtype:'fieldset',
					defaults: {width: 180},
					items:[StkGrpType]
				},{
					columnWidth:0.33,
					xtype:'fieldset',
					defaults: {width: 150},
					items:[InciDesc]    
				}]
        }]
    });

    // 5.2.ҳ�沼��
    var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [  HisListTab,
			{
				region: 'center',                                      
				//title: '���ҿ����---<font color=blue>��ɫ��ʾ����Ϊ�ɱ༭��</font>',
				layout: 'fit', // specify layout manager for items
				items: ItmLocGrid                             
			}
		],
		renderTo : 'mainPanel'
	});  
})