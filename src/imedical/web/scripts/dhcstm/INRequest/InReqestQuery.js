// /����: ����ִ�������ѯ
// /����: ����ִ�������ѯ
// /��д�ߣ�zhangxiao
// /��д����: 2014.02.28
Ext.onReady(function(){
	
	 var userId = session['LOGON.USERID'];
	 var gGroupId=session['LOGON.GROUPID'];
	 var gLocId=session['LOGON.CTLOCID'];
     var gIncId='';
     Ext.QuickTips.init();
     Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;	
     
	var Loc = new Ext.ux.LocComboBox({
		id:'Loc',
		anchor:'95%',
		fieldLabel:'������',
		emptyText:'������...',
		groupId:gGroupId,
		protype : INREQUEST_LOCTYPE,
		linkloc:gLocId,
		listeners:
		{
			'select':function(cb)
			{
				var requestLoc=cb.getValue();
				var defprovLocs=tkMakeServerCall("web.DHCSTM.DHCTransferLocConf","GetDefLoc",requestLoc,gGroupId)
				var mainArr=defprovLocs.split("^");
				var defprovLoc=mainArr[0];
				var defprovLocdesc=mainArr[1];
				addComboData(Ext.getCmp('SupplyLoc').getStore(),defprovLoc,defprovLocdesc);
				Ext.getCmp("SupplyLoc").setValue(defprovLoc);
				var provLoc=Ext.getCmp('SupplyLoc').getValue();
				Ext.getCmp("StkGrpType").setFilterByLoc(requestLoc,provLoc);			
			}
		}
	});
	var SupplyLoc = new Ext.ux.ComboBox({
		id:'SupplyLoc',
		fieldLabel:'��������',
		anchor:'95%',
		store:frLocListStore,
		displayField:'Description',
		valueField:'RowId',
		listWidth:210,
		emptyText:'��������...',
		filterName:'FilterDesc',
		params:{LocId:'Loc'},
		listeners:
		{
			'select':function(cb)
			{
				var provLoc=cb.getValue();
				var requestLoc=Ext.getCmp('Loc').getValue();
				Ext.getCmp("StkGrpType").setFilterByLoc(requestLoc,provLoc);
			}
		}	
	});
	//��ʼ����
	var startDate = new Ext.ux.DateField({
		id:'startDate',
		//width:210,
		listWidth:210,
		allowBlank:true,
		fieldLabel:'��ʼ����',
		anchor:'95%',
		value:new Date().add(Date.DAY,-7)
	});
	//��ֹ����
	var endDate = new Ext.ux.DateField({
		id:'endDate',
		//width:210,
		listWidth:210,
		allowBlank:true,
		fieldLabel:'��ֹ����',
		anchor:'95%',
		value:new Date()
	});
	// ��������ת��
	var PartlyStatusS = new Ext.form.Checkbox({
				fieldLabel : '��������ת��',
				id : 'PartlyStatusS',
				name : 'PartlyStatus',
				anchor : '90%',
				width : 120,
				checked : false,
				disabled : false
			});
	
	// ��ʾ�����ת�Ƶ�������ϸ
	var ShowTransfered = new Ext.form.Checkbox({
				fieldLabel : '��ʾת���������',
				id : 'ShowTransfered',
				name : 'ShowTransfered',
				anchor : '90%',
				width : 120,
				checked : false,
				disabled : false
			});
	// ��������
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //��ʶ��������
			LocId:gLocId,
			UserId:userId,
			anchor:'90%',
			width : 200
		}); 
		//�Զ����ص�½���ҵ�Ĭ�Ϲ�������
		Loc.fireEvent('select',Loc);
		// ��������
		var InciDesc = new Ext.form.TextField({
			fieldLabel : '��������',
			id : 'InciDesc',
			name : 'InciDesc',
			anchor : '90%',
			width : 150,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var stktype = Ext.getCmp("StkGrpType").getValue();
						GetPhaOrderInfo(field.getValue(), stktype);
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
			Ext.getCmp("InciDesc").setValue(record.get("InciDesc"));
		}		
    // ��ѯ��ť
    var SearchBT = new Ext.Toolbar.Button({
	               text : '��ѯ',
	               tooltip : '�����ѯ',
	               width : 70,
	               height : 30,
	               iconCls:'page_find',
	               handler : function() {
		        	  Query();
		           }
	           });
	 //��ѯ����
	 function Query(){
		var Loc=Ext.getCmp("Loc").getValue();
		if(Loc==null||Loc.length<=0){
			Msg.info("warning","��ѡ��������!");
			return;
		}
		var SupplyLoc=Ext.getCmp("SupplyLoc").getValue(); 
		var startDate=Ext.getCmp("startDate").getValue();
		var endDate=Ext.getCmp("endDate").getValue();		
		if(startDate!=""){
			startDate = startDate.format(ARG_DATEFORMAT);
		}
		if(endDate!=""){
			endDate = endDate.format(ARG_DATEFORMAT);
		}
		var StkGrpType=Ext.getCmp("StkGrpType").getValue();
		var inciDesc = Ext.getCmp("InciDesc").getValue();
		if (inciDesc == "" || inciDesc == null){
			gIncId="";
		}
		if(gIncId!=""&gIncId!=null){
			inciDesc="";
		}
		var ListParam=Loc+'^'+SupplyLoc+'^'+startDate+'^'+endDate+'^'+StkGrpType+'^'+gIncId+'^'+inciDesc;
		var Page=GridPagingToolbar.pageSize;
		MasterStore.setBaseParam('ParamStr',ListParam);
		MasterStore.removeAll();
		MasterStore.load({
			params:{start:0,limit:Page},
			callback:function(r,options,success){
				if(success==false){
					Msg.info("error", "��ѯ������鿴��־!");
				}else{if(r.length>0){
					MasterGrid.getSelectionModel().selectFirstRow();
					MasterGrid.getSelectionModel().fireEvent('rowselect',this,0);
					MasterGrid.getView().focusRow(0);
					}
				}
			}
		});
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();

		}
	// ��հ�ť
	var ClearBT = new Ext.Toolbar.Button({
					text : '���',
					tooltip : '������',
					width : 70,
					height : 30,
					iconCls : 'page_clearscreen',
					handler : function() {
						clearData();
					}
				});
	//��պ���
	function clearData(){
		Ext.getCmp("InciDesc").setValue("");
		Ext.getCmp("SupplyLoc").setValue("");
		Ext.getCmp("startDate").setValue(new Date().add(Date.DAY,-7))
		Ext.getCmp("endDate").setValue(new Date())
		MasterGrid.store.removeAll();
		MasterGrid.getView().refresh();
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
		
		}			
	// ����·��
	var MasterUrl = DictUrl	+ 'inrequestqueryaction.csp?actiontype=QueryReq';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["req", "reqNo", "toLoc","toLocDesc", "frLocDesc", "date","time", "comp", 
	"userName","status","transferStatus","comp"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "req",
				fields : fields
			});
	// ���ݼ�
	var MasterStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var MasterCm = new Ext.grid.ColumnModel([nm, {
				header : "RowId",
				dataIndex : 'req',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "���󵥺�",
				dataIndex : 'reqNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "������",
				dataIndex : 'toLocDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'frLocDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'date',
				width : 90,
				align : 'center',
				sortable : true
			}, {
				header : "����ʱ��",
				dataIndex : 'time',
				width : 90,
				align : 'center',
				sortable : true
			}, {
				header : "�������",
				dataIndex : 'status',
				width : 120,
				align : 'left',
				renderer: renderReqType,
				sortable : true
			},{
			header:'���״̬',
			dataIndex:'comp',
			align:'center',
			width:100,
			sortable:true,
			renderer:function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
	    	}, {
				header : "�Ƶ���",
				dataIndex : 'userName',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "ת��״̬",
				dataIndex : 'transferStatus',
				width : 80,
				align : 'left',
				renderer: renderStatus,
				sortable : true
			}]);
	MasterCm.defaultSortable = true;
	function renderStatus(value){
		var InstrfStatus='';
		if(value==0){
			InstrfStatus='δת��';			
		}else if(value==1){
			InstrfStatus='����ת��';
		}else if(value==2){
			InstrfStatus='ȫ��ת��';
		}
		return InstrfStatus;
	}
	function renderReqType(value){
		var ReqType='';
		if(value=='O'){
			ReqType='���쵥';
		}else if(value=='C'){
			ReqType='����ƻ�';
		}
		return ReqType;
	}			
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:MasterStore,
		pageSize:PageSize,
		displayInfo:true
	});			
	var MasterGrid = new Ext.grid.GridPanel({
					region : 'center',
					title : '����',
					cm : MasterCm,
					sm : new Ext.grid.RowSelectionModel({
								singleSelect : true
							}),
					store : MasterStore,
					trackMouseOver : true,
					stripeRows : true,
					loadMask : true,
					bbar:[GridPagingToolbar]
				});			
     
     // ���ӱ��񵥻����¼�
	MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r)  {
		var ReqId = MasterStore.getAt(rowIndex).get("req");
		var ReqLocDesc=MasterStore.getAt(rowIndex).get("toLocDesc");
		var ReqLocId=MasterStore.getAt(rowIndex).get("toLoc");
		//addComboData(RequestPhaLocS.getStore(),ReqLocId,ReqLocDesc);
		//Ext.getCmp("RequestPhaLocS").setValue(ReqLocId);
		//var show=(Ext.getCmp("ShowTransfered").getValue()==true?1:0);
		DetailStore.removeAll();
		DetailStore.setBaseParam('req',ReqId);
		//DetailStore.setBaseParam('TransferedFlag',show);
		
		DetailStore.load({params:{start:0,limit:GridDetailPagingToolbar.pageSize,sort:'req',dir:'Desc'}});
	});
	
	// ������ϸ
	// ����·��
	var DetailUrl =DictUrl+
		'inrequestaction.csp?actiontype=queryDetail';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	
	// ָ���в���
	var fields = ["rowid", "inci", "code","desc","qty", "uom", "uomDesc", "spec", "qtyApproved",
			 "manf", "sp", "spAmt","generic","drugForm", "remark","transQty","NotTransQty","stkQty","SpecDesc"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "rowid",
				fields : fields
			});
	// ���ݼ�
	var DetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, {
				header : "������ϸRowId",
				dataIndex : 'rowid',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "����RowId",
				dataIndex : 'inci',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : '���ʴ���',
				dataIndex : 'code',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '��������',
				dataIndex : 'desc',
				width : 230,
				align : 'left',
				sortable : true
			}, {
				header : "���",
				dataIndex : 'spec',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "������",
				dataIndex : 'SpecDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "��Ӧ�����",
				dataIndex : 'stkQty',
				width : 80,
				align : 'right',
				sortable : true				
			}, {
				header : "��������",
				dataIndex : 'qty',
				width : 80,
				align : 'right',
				sortable : true	
			}, {
				header : "��׼����",
				dataIndex : 'qtyApproved',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "��ת������",
				dataIndex : 'transQty',
				width : 80,
				align : 'right',
				sortable : true				
			}, {
				header : "δת������",
				dataIndex : 'NotTransQty',
				width : 80,
				align : 'right',
				sortable : true				
			}, {
				header : "��λ",
				dataIndex : 'uomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "�ۼ�",
				dataIndex : 'sp',
				width : 60,
				align : 'right',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'manf',
				width : 180,
				align : 'left',
				sortable : true
			}]);
	var GridDetailPagingToolbar = new Ext.PagingToolbar({
		store:DetailStore,
		pageSize:PageSize,
		displayInfo:true
	});

	var DetailGrid = new Ext.grid.GridPanel({
				region : 'south',
				id : 'DetailGrid',
				title : '������ϸ',
				height : gGridHeight,
				cm : DetailCm,
				store : DetailStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:GridDetailPagingToolbar,
				sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
				viewConfig:{
					getRowClass : function(record,rowIndex,rowParams,store){
						var stkQty=parseInt(record.get("stkQty"));
						var reqQty=parseInt(record.get("qty"));
						var complete=(Ext.getCmp("ShowTransfered").getValue()==true?1:0);
						if(complete==0 && stkQty<reqQty){
							return 'classRed';	
						}
					}
				}
			});
	
	var HisListTab = new Ext.form.FormPanel({
			region : 'north',
			autoHeight : true,
			title : '����ִ�������ѯ',
			labelWidth: 60,	
			labelAlign : 'right',
			frame : true,
			tbar : [SearchBT, '-', ClearBT],			
			items : [{
				xtype:'fieldset',
				title:'��ѯ����',
				style : 'padding:5px 0px 0px 5px;',
				layout: 'column',    // Specifies that the items will now be arranged in columns
				defaults: {border:false},    // Default config options for child items
				items:[{ 				
					columnWidth: 0.25,
	            	xtype: 'fieldset',
	            	items: [Loc,SupplyLoc]					
				},{ 				
					columnWidth: 0.25,
	            	xtype: 'fieldset',	            
	            	items: [startDate,endDate]					
				},{ 				
					columnWidth: 0.25,
	            	xtype: 'fieldset',	            	
	            	items: [StkGrpType]					
				},{ 				
					columnWidth: 0.25,
	            	xtype: 'fieldset',	            	
	            	items: [InciDesc]					
				}]
			}]			
		});

		// ҳ�沼��
		var mainPanel = new Ext.ux.Viewport({
					layout : 'border',
					items : [HisListTab, MasterGrid, DetailGrid]
				});

})
