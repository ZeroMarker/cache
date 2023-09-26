// /����: ��汨��-��������
// /����:  ��汨��-��������
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.14
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gStrParam='';
	var gIncId='';
	var gGroupId=session['LOGON.GROUPID'];
	var gUserId=session['LOGON.USERID'];
	var gLocId=session['LOGON.CTLOCID'];
	
	//ͳ�ƿ���
	var PhaLoc = new Ext.ux.LocComboBox({
			fieldLabel : '����',
			id : 'PhaLoc',
			name : 'PhaLoc',
			anchor:'90%',
			groupId:gGroupId,
			stkGrpId : 'StkGrpType'
		});
		
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		StkType:App_StkTypeCode,     //��ʶ��������
		anchor:'90%',
		width : 140,
		LocId:gLocId,
		UserId:gUserId,
		childCombo : 'DHCStkCatGroup'
	}); 
	
	var DHCStkCatGroup = new Ext.ux.ComboBox({
				fieldLabel : '������',
				id : 'DHCStkCatGroup',
				name : 'DHCStkCatGroup',
				anchor : '90%',
				store : StkCatStore,
				valueField : 'RowId',
				displayField : 'Description',
				params:{StkGrpId:'StkGrpType'}
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
						searchData();
					}
				});

		/**
		 * ��ѯ����
		 */
		function searchData() {
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
			// ��ѡ����
			var StkGrpRowId = Ext.getCmp("StkGrpType").getValue();
			var DHCStkCatGroup = Ext.getCmp("DHCStkCatGroup").getValue();
		
			gStrParam=phaLoc+"^"+StkGrpRowId+"^"+DHCStkCatGroup+"^"+gIncId;
			
			var pageSize=StatuTabPagingToolbar.pageSize;
			StockQtyStore.load({params:{start:0,limit:pageSize,Params:gStrParam}});

		}
				
		// ��հ�ť
		var RefreshBT = new Ext.Toolbar.Button({
					text : '���',
					tooltip : '������',
					iconCls : 'page_refresh',
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
			Ext.getCmp("DHCStkCatGroup").setValue('');			
			StockQtyGrid.store.removeAll();
			StockQtyGrid.getView().refresh();
		}

		var nm = new Ext.grid.RowNumberer();
		var sm = new Ext.grid.CheckboxSelectionModel();
		var StockQtyCm = new Ext.grid.ColumnModel([nm, {
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
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "��������",
					dataIndex : 'InciDesc',
					width : 200,
					align : 'left',
					sortable : true
				}, {
					header : "������",
					dataIndex : 'SpecDesc',
					width : 90,
					align : 'left',
					sortable : true
				}, {
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
				}, {
					header : "���ÿ��",
					dataIndex : 'AvaQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "�������",
					dataIndex : 'MaxQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "�������",
					dataIndex : 'MinQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : '������',
					dataIndex : 'IncscDesc',
					width : 150,
					align : 'left',
					sortable : true
				}]);
		StockQtyCm.defaultSortable = true;

		// ����·��
		var DspPhaUrl = DictUrl
					+ 'locitmstkaction.csp?actiontype=jsLocItmSpecStkQtyLimitWarn&start=&limit=';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : DspPhaUrl,
					method : "POST"
				});
		// ָ���в���
		var fields = ["ILERowId", "Inci", "InciCode", "InciDesc","SpecDesc", "BUomDesc", "PUomDesc", "AvaQty",
				"MaxQty", "MinQty", "IncscDesc"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "ILERowId",
					fields : fields
				});
		// ���ݼ�
		var StockQtyStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader
				});

		var StatuTabPagingToolbar = new Ext.PagingToolbar({
					store : StockQtyStore,
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
					emptyMsg : "û������",
					doLoad:function(C){
						var B={},
						A=this.getParams();
						B[A.start]=C;
						B[A.limit]=this.pageSize;
						B[A.sort]='desc';
						B[A.dir]='ASC';
						
						B['Params']=gStrParam;
						if(this.fireEvent("beforechange",this,B)!==false){
							this.store.load({params:B});
						}
					}
				});

		var StockQtyGrid = new Ext.ux.GridPanel({
					id:'StockQtyGrid',
					region : 'center',
					cm : StockQtyCm,
					store : StockQtyStore,
					trackMouseOver : true,
					stripeRows : true,
					//sm : new Ext.grid.CheckboxSelectionModel(),
					sm:sm,
					loadMask : true,
					bbar : StatuTabPagingToolbar,
					viewConfig:{getRowClass : function(record,rowIndex,rowParams,store){ 
						var StkQty=record.get("AvaQty");
						var MaxQty=record.get("MaxQty");
						var MinQty=record.get("MinQty");
						if(parseFloat(StkQty)>MaxQty){
							return 'classRed';
						}else if(parseFloat(StkQty)<MinQty){
							return 'classGrassGreen';
						}					
                    }
            	}
		});
	
var HisListTab = new Ext.form.FormPanel({
			labelwidth : 30,
			region : 'north',
			title:"��汨��-����������������",
			height : 200,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			bodyStyle : 'padding:10px 1px 1px 5px;',
			tbar : [SearchBT, '-', RefreshBT],		
		    items:[{
						layout : 'column',	
						title:'��ѯ����',	
						xtype: 'fieldset',
						defaults: { border:false},
						items : [{
									columnWidth:0.3,
									autoHeight : true,
									height:150,
									xtype: 'fieldset',
									defaults: {width: 180, border:false},    // Default config options for child items
									items : [PhaLoc,InciDesc]
								},{
									columnWidth:0.25,
									autoHeight : true,
									height:150,
									xtype: 'fieldset',
									defaults: {width: 180, border:false},    // Default config options for child items
									items : [StkGrpType,DHCStkCatGroup]
								},{
									columnWidth:0.2,
									autoHeight : true,
									height:150,
									xtype: 'fieldset',
									defaultType: 'textfield',
									defaults: {width: 80, border:false},    // Default config options for child items
									items : [{
										fieldLabel:'�������������',
										//style:{background-color:'#FF0000'},
										cls: 'my-background-Red'
									},{
										fieldLabel:'�������������',							
										cls: 'my-background-GrassGreen'
									}]
								}]
		    }]	
		});
// 5.2.ҳ�沼��
		var mainPanel = new Ext.ux.Viewport({
					layout : 'border',
					items : [ HisListTab       
			               
			            , {
			                region: 'center',
			                title: '��ϸ',			               
			                layout: 'fit', // specify layout manager for items
			                items: StockQtyGrid       
			               
			            }
	       			],
					renderTo : 'mainPanel'
				});
})