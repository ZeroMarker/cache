// /����: �ɹ��ƻ������Ƶ������ݿ�������ޣ�
// /����: �ɹ��ƻ������Ƶ������ݿ�������ޣ�
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.03

Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var LocId=session['LOGON.CTLOCID']

	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
		// ��������
	var PurLoc = new Ext.ux.LocComboBox({
		fieldLabel : '�ɹ�����',
		id : 'PurLoc',
		name : 'PurLoc',
		anchor : '90%',
		emptyText : '�ɹ�����...',
		groupId:session['LOGON.GROUPID'],
		listeners : {
			'select' : function(e) {
				var SelLocId=Ext.getCmp('PurLoc').getValue();//add wyx ����ѡ��Ŀ��Ҷ�̬��������
				StkGrpType.getStore().removeAll();
				StkGrpType.getStore().setBaseParam("locId",SelLocId)
				StkGrpType.getStore().setBaseParam("userId",userId)
				StkGrpType.getStore().setBaseParam("type",App_StkTypeCode)
				StkGrpType.getStore().load();
			}
		}
	});


	   // ҩƷ�б�
	    var ZBCombo=new Ext.ux.ZBComboBox({ 
			id : 'ZBComBoBox',
			name : 'ZBComBoBox',
			anchor : '90%'
		});


			// ������׼ȡ������
		var RepLevFac =new Ext.form.NumberField({
			fieldLabel : '������׼ȡ������',
			id : 'RepLevFac',
			emptyText:'0-1֮���С��',
			name : 'RepLevFac',
			anchor : '90%',
			enableKeyEvents:true,
			listeners:{
				'keyup':function(e){

					if(Ext.getCmp('RepLevFac').getRawValue()>1){
						Msg.info("warning", "ֻ��¼0-1֮���С��!");
                        Ext.getCmp('RepLevFac').setValue('');
					}
				}
		    }
	});

	// ҩƷ����
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		StkType:App_StkTypeCode,     //��ʶ��������
		LocId:session['LOGON.CTLOCID'],
		UserId:session['LOGON.USERID'],
		anchor : '90%'
	}); 
	// ������
var M_StkCat = new Ext.ux.ComboBox({
	fieldLabel : '������',
	id : 'M_StkCat',
	name : 'M_StkCat',
	store : StkCatStore,
	valueField : 'RowId',
	displayField : 'Description',
	params:{StkGrpId:'StkGrpType'}
});

	// ��ѯ��ť
	var SearchBT = new Ext.Toolbar.Button({
				text : '��ѯ',
				tooltip : '�����ѯ',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					Query();
				}
			});
	/**
	 * ��ѯ����
	 */
	function Query() {
		var PurLoc = Ext.getCmp("PurLoc").getValue();
		var fac =  Ext.getCmp("RepLevFac").getValue();
		var stkgrp=Ext.getCmp("StkGrpType").getValue();
		//������
        var stkCatId = Ext.getCmp('M_StkCat').getValue();
		var zbflagstr=Ext.getCmp("ZBComBoBox").getValue();
		if (zbflagstr=="")
		{
			zbflagstr=1;
		}
		if (PurLoc == undefined || PurLoc.length <= 0) {
			Msg.info("warning", "��ѡ��ɹ�����!");
			return;
		}

		//����id,����id,������׼ȡ������
		var ListParam=PurLoc+'^'+stkgrp+'^'+fac+'^'+userId+"^"+zbflagstr+"^"+stkCatId;					
		DetailStore.load({params:{start:0, limit:999,strParam:ListParam}});
	}
	
function save(){
	var purNo = '';
	var locId = Ext.getCmp('PurLoc').getValue();
	var stkGrpId = Ext.getCmp('StkGrpType').getValue();
	var rowCount = DetailGrid.getStore().getCount();				
	var data="";
	for(var i=0;i<rowCount;i++){
		var rowData = DetailStore.getAt(i);	
		var rowid = '';
		var incId = rowData.data["Inci"];
		var qty = rowData.data["Qty"];
		var uomId = rowData.data["PurUomId"];
		var vendorId = rowData.data["VenId"];
		var rp =rowData.data["Rp"];
		var manfId =rowData.data["ManfId"];
		var carrierId =rowData.data["CarrierId"];
		var reqLocId ='';
		var prolocqty=rowData.data["PurQty"];
		var dataRow = rowid+"^"+incId+"^"+qty+"^"+uomId+"^"+vendorId+"^"+rp+"^"+manfId+"^"+carrierId+"^"+reqLocId+"^"+prolocqty;
		if (qty!=0) {
		if(data==""){
			data = dataRow;
		}else{
			data = data+xRowDelim()+dataRow;
		}
	   }
	}

	var zbflagstr=Ext.getCmp("ZBComBoBox").getValue();
	if (zbflagstr=="")
	{
		zbflagstr=1;
	}
	if(data!=""){
		Ext.Ajax.request({
			url: DictUrl+'inpurplanaction.csp?actiontype=save',
			params:{purNo:purNo,locId:locId,stkGrpId:stkGrpId,userId:userId,data:data},
			failure: function(result, request) {
				Msg.info("error","������������!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					Msg.info("success","����ɹ�!");
				
					location.href="dhcst.inpurplan.csp?planNnmber="+jsonData.info+'&locId='+locId+'&zbFlag='+zbflagstr;
				}else{
					if(jsonData.info==-1){
						Msg.info("error","���һ���ԱΪ��!");
					}else if(jsonData.info==-99){
						Msg.info("error","����ʧ��!");
					}else if(jsonData.info==-2){
						Msg.info("error","���ɼƻ�����ʧ��!");
					}else if(jsonData.info==-3){
						Msg.info("error","����ƻ���ʧ��!");
					}else if(jsonData.info==-4){
						Msg.info("error","δ�ҵ�����µļƻ���!");
					}else if(jsonData.info==-5){
						Msg.info("error","����ƻ�����ϸʧ��,�������ɼƻ���!���ҩƷ���������Ƿ��в�����ҩƷ");
					}else if(jsonData.info==-7){
						Msg.info("error","ʧ��ҩƷ��������ϸ���治�ɹ�����ʾ���ɹ���ҩƷ!"+jsonData.info);
					}else{
						Msg.info("error","����ʧ��!"+jsonData.info);
					}
				}
			},
			scope: this
		});
	}
		}

	// ��հ�ť
	var ClearBT = new Ext.Toolbar.Button({
				text : '����',
				tooltip : '�������(Alt+C)',
				width : 70,
				height : 30,
				iconCls : 'page_clearscreen',
				handler : function() {
					clearData();
				}
			});
	/**
	 * ��շ���
	 */
	function clearData() {
		//Ext.getCmp("PurLoc").setValue("");
		Ext.getCmp("RepLevFac").setValue("");
		Ext.getCmp('M_StkCat').setValue("");
		Ext.getCmp('ZBComBoBox').setValue("");
		
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
		ShowAllLocStkQtyWin("",DetailGrid,3,"","");
	}

	// ���水ť
	var SaveBT = new Ext.Toolbar.Button({
				text : '����',
				tooltip : '�������',
				width : 70,
				height : 30,
				iconCls : 'page_save',
				handler : function() {
					save();
				}
			});

	
    
	var HelpBT = new Ext.Button({
		��������id:'HelpBtn',
				text : '����',
				width : 70,
				height : 30,
				renderTo: Ext.get("tipdiv"),
				iconCls : 'page_help'
				
			});
		
       


  
			// ��λ
	var CTUom = new Ext.form.ComboBox({
				fieldLabel : '��λ',
				id : 'CTUom',
				name : 'CTUom',
				anchor : '90%',
				width : 120,
				store : ItmUomStore,
				valueField : 'RowId',
				displayField : 'Description',
				allowBlank : false,
				triggerAction : 'all',
				emptyText : '��λ...',
				selectOnFocus : true,
				forceSelection : true,
				minChars : 1,
				pageSize : 10,
				listWidth : 250,
				valueNotFoundText : ''
			});
			/**
	 * ��λչ���¼�
	 */
	CTUom.on('expand', function(combo) {
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				var record = DetailGrid.getStore().getAt(cell[0]);
				var InciDr = record.get("Inci");
				ItmUomStore.removeAll();
				ItmUomStore.load({params:{ItmRowid:InciDr}});
	});

	/**
	 * ��λ�任�¼�
	 */
	CTUom.on('select', function(combo) {
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				var record = DetailGrid.getStore().getAt(cell[0]);

				var value = combo.getValue();        //Ŀǰѡ��ĵ�λid
				var BUom = record.get("BUomId");
				var ConFac = record.get("ConFac");   //��λ��С��λ��ת����ϵ					
				var PurUom = record.get("PurUomId");    //Ŀǰ��ʾ�Ĳɹ���λ
				var Rp = record.get("Rp");
				var StkQty = record.get("StkQty");
				var MaxQty=record.get("MaxQty");
				var MinQty=record.get("MinQty");
				var PurQty=record.get("PurQty");
				var RepQty=record.get("RepQty");
				var LevelQty=record.get("LevelQty");
				
				if (value == undefined || value.length <= 0) {
					return;
				} else if (PurUom == value) {
					return;
				} else if (value==BUom) {     //��ѡ��ĵ�λΪ������λ��ԭ��ʾ�ĵ�λΪ��λ
					record.set("Rp", Rp/ConFac);
					record.set("StkQty", StkQty*ConFac);
					record.set("MaxQty", MaxQty*ConFac);
					record.set("MinQty", MinQty*ConFac);
					record.set("RepQty", RepQty*ConFac);
					record.set("LevelQty", LevelQty*ConFac);
					record.set("PurQty", PurQty*ConFac);
				} else{  //��ѡ��ĵ�λΪ��λ��ԭ���ǵ�λΪС��λ
					record.set("Rp", Rp*ConFac);
					record.set("StkQty", StkQty/ConFac);
					record.set("MaxQty", MaxQty/ConFac);
					record.set("MinQty", MinQty/ConFac);
					record.set("RepQty", RepQty/ConFac);
					record.set("LevelQty", LevelQty/ConFac);
					record.set("PurQty", PurQty/ConFac);
				}
				record.set("PurUomId", combo.getValue());
	});
	
	
	
			/**
	 * ɾ��ѡ����ҩƷ
	 */
	function deleteDetail() {
		
		var cell = DetailGrid.getSelectionModel().getSelectedCell();
		if (cell == null) {
			Msg.info("warning", "û��ѡ����!");
			return;
		}
		// ѡ����
		var row = cell[0];
		var record = DetailGrid.getStore().getAt(row);			
		DetailGrid.getStore().remove(record);
		DetailGrid.getView().refresh();
	}
	
	// ת����ϸ
	// ����·��
	var DetailUrl =  DictUrl
				+ 'inpurplanaction.csp?actiontype=QueryLocItmForPurchByLim';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = [ "Inci","InciCode","InciDesc", "Spec","PurUomId", "PurUomDesc", "PurQty",
			 "VenDesc", "ManfDesc","StkQty","Rp","CarrierDesc", "MaxQty","MinQty","RepQty","LevelQty",
			 "BUomId","ConFac","VenId","ManfId","CarrierId","RepLev",{name:'Qty',convert:function(v,rec){return rec.PurQty;}},"ApcWarn","StkCatDesc"];
			
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "Inci",
				fields : fields
			});
	
	// ���ݼ�
	var DetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	
	//�������ҿ����Ϣ
	// ����·��
	var AllLocStkUrl =  DictUrl
				+ 'inpurplanaction.csp?actiontype=GetAllLocStk&start=&limit=';
	// ͨ��AJAX��ʽ���ú�̨����
	var AllLocStkProxy = new Ext.data.HttpProxy({
				url : AllLocStkUrl,
				method : "POST"
			});
	// ָ���в���
	var AllLocStkFields = [ "Loc","Uom","StkQty","MaxQty","MinQty","RepQty"];
			
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var AllLocStkReader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "Loc",
				fields : AllLocStkFields
			});
	var AllLocStkStore = new Ext.data.Store({
				proxy : AllLocStkProxy ,
				reader : AllLocStkReader
			});
	
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, {
				header : "ҩƷId",
				dataIndex : 'Inci',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : 'ҩƷ����',
				dataIndex : 'InciCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : 'ҩƷ����',
				dataIndex : 'InciDesc',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : '������',
				dataIndex : 'StkCatDesc',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "����ɹ���",
				dataIndex : 'PurQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "ʵ�ʲɹ���",
				dataIndex : 'Qty',
				width : 80,
				align : 'right',
				sortable : true,
				editor : new Ext.form.NumberField({
					selectOnFocus : true,
					allowBlank : false,
					listeners : {
						specialkey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								var qty = field.getValue();
								if (qty == null || qty.length <= 0) {
									Msg.info("warning", "�ɹ���������Ϊ��!");
									return;
								}
								if (qty < 0) {
									Msg.info("warning", "�ɹ���������С��0!");
									return;
								}									
							}
						}
					}
				})
			}, {
				header : "��λ",
				dataIndex : 'PurUomId',
				width : 80,
				align : 'left',
				sortable : true,
				renderer : Ext.util.Format.comboRenderer2(CTUom,"PurUomId","PurUomDesc"), // pass combo instance to reusable renderer					
				editor : new Ext.grid.GridEditor(CTUom)
			}, {
				header : "��Ӧ��",
				dataIndex : 'VenDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'ManfDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'Rp',
				width : 60,
				align : 'right',
				
				sortable : true
			}, {
				header : "�ɹ����ҿ��",
				dataIndex : 'StkQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "�������",
				dataIndex : 'MaxQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "�������",
				dataIndex : 'MinQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "��׼���",
				dataIndex : 'RepQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "�ο����",
				dataIndex : 'LevelQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "������׼",
				dataIndex : 'RepLev',
				width : 80,
				align : 'right',
				sortable : true
			},{
				header : "������",
				dataIndex : 'CarrierDesc',
				width : 80,
				align : 'right',
				sortable : true
			},{
				header : "������Ϣ",
				dataIndex : 'ApcWarn',
				width : 140,
				align : 'right',
				sortable : true
			}]);


	var DeleteItmBT=new Ext.Toolbar.Button({
		id:'DeleteItmBT',
		text:'ɾ��һ��',
		iconCls:'page_delete',
		handler:function(){
			deleteDetail();
		}
	});
	var GridColSetBT = new Ext.Toolbar.Button({
	text:'������',
    tooltip:'������',
    iconCls:'page_gear',
    //	width : 70,
    //	height : 30,
	handler:function(){
		GridColSet(DetailGrid,"DHCSTPURPLANBYLIM");
	}
    });

	
	var DetailGrid = new Ext.grid.EditorGridPanel({
				title : '',
				height : 200,
				cm : DetailCm,
				store : DetailStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				sm : new Ext.grid.CellSelectionModel({}),
				clicksToEdit : 1,
				tbar:[DeleteItmBT,'-',GridColSetBT]
			});
			
	DetailGrid.on('beforeedit',function(e){
		if(e.field=="PurUomId"){
			var uomid=e.record.get("PurUomId");
			var uomdesc=e.record.get("PurUomDesc");
			addComboData(CTUom.getStore(),uomid,uomdesc);
		}
	});
	
	
	var col1={ 				
			columnWidth: 0.25,
        	xtype: 'fieldset',
        	items: [PurLoc,M_StkCat]			
		}
	var col2={ 				
			columnWidth: 0.25,
        	xtype: 'fieldset',        	
        	items: [StkGrpType,ZBCombo]			
		}			
	var col3={ 				
			columnWidth: 0.25,
        	xtype: 'fieldset',        	
        	items: [RepLevFac]			
		}
	var col4={ 				
			columnWidth: 0.4,
        	xtype: 'fieldset',        	
        	items: []		
		}
	var HisListTab = new Ext.form.FormPanel({
		labelWidth: 120,	
		labelAlign : 'right',
		autoHeight:true,
		frame : true,
		autoScroll : false,
		tbar : [SearchBT, '-', ClearBT,'-',SaveBT,'-',HelpBT],		
		items : [{
			xtype:'fieldset',
			title:'��ѯ����',
			style : DHCSTFormStyle.FrmPaddingV,
			layout: 'column',    // Specifies that the items will now be arranged in columns		
			defaults: {border:false},  
			items:[col1,col2,col3,col4]
			}]
		
	});

	// ҳ�沼��
	var mainPanel = new Ext.Viewport({
				layout : 'border',
				items : [            // create instance immediately
		            {
		                region: 'north',
		                title:'�ɹ��ƻ����Ƶ�-���ݿ��������',
		                height: DHCSTFormStyle.FrmHeight(2), // give north and south regions a height
		                layout: 'fit', // specify layout manager for items
		                items:HisListTab
		            }, {
		                region: 'center',
		                title: '��ϸ',			               
		                layout: 'fit', // specify layout manager for items
		                items: DetailGrid       
		               
		            }
       			],
				renderTo : 'mainPanel'
			});




	//-------------------Events-------------------//

    //����Grid������ʾ����
	//Creator:LiangQiang 2013-11-20
    DetailGrid.on('mouseover',function(e){
		
		var rowCount = DetailGrid.getStore().getCount();
		if (rowCount>0)
		{  
			var ShowInCellIndex=3;  //�ڵڼ�����ʾ
			var index = DetailGrid.getView().findRowIndex(e.getTarget());
			var record = DetailGrid.getStore().getAt(index);
			if (record)
			{
				var desc=record.data.InciDesc;
				var inci=record.data.Inci;
				//alert(index+":"+desc+"^"+inci)
			}
	
			ShowAllLocStkQtyWin(e,DetailGrid,ShowInCellIndex,desc,inci);
		}

	},this,{buffer:200});



   /*��������ť����tip��ʾ
   * LiangQiang 2013-11-21
   */
   new Ext.ToolTip({
        target: 'HelpBtn',
        anchor: 'buttom',
        width: 500,
        anchorOffset: 50,
		hideDelay : 9000,
        html: "<font size=3 color=blue>������׼>=1,�Ҳ�����׼ȡ��������Ϊ�գ�����ɹ���=������׼*N,N=M+R" +  "      M=(��׼���-���ҿ��)/������׼��ȡ��������" +
				"((��׼���-���ҿ��)#������׼)/������׼<������׼ȡ������ʱ��R=0,����R=1,#����ȡ��" +"     ������׼<1,�򲹻���׼ȡ������Ϊ�գ�����ɹ���=��׼���-���ҿ��</font>"
    });


   /*���ؽ��水ť��ݼ�
   * LiangQiang 2013-11-22
   */
    Ext.getCmp('HelpBtn').focus('',100); //��ʼ��ҳ���ĳ��Ԫ�����ý���
   	var map = new Ext.KeyMap(document, [
	{
		key: [116], // F5
		fn: function(){ },
		//stopEvent: true,  //����
		scope: this
	},{
		key: [37,39,115], //�������,��,F4
		alt: true,   //Alt
		fn: function(){ },
		//stopEvent: true,
		scope: this
	}, {
		key: [82],  // ctrl + R
		ctrl: true, //Ctrl
		fn: function(){},
		//stopEvent: true,
		scope: this
	}, {
		key: [83],  // Alt + S  
		alt: true, 
		fn: function(){/*do anything*/},
		scope: this
	}, {
		key: [67],  // Alt + C  
		alt: true, 
		fn: function(){clearData();},
		scope: this
	}, {
		key: [81],  // Alt + Q
		alt: true, 
		fn: function(){},
		scope: this
	}, {
		key: [87],  // Alt + W
		alt: true, 
		fn: function(){},
		scope: this
	}, {
		key: [82],  // Alt + R
		alt: true, 
		fn: function(){},
		scope: this
	}, {
		key: [68],  // Alt + D
		alt: true, 
		fn: function(){},
		scope: this
	}, {
		key: [70],  // Alt + F
		alt: true, 
		fn: function(){},
		scope: this
	}, {
		key: [80],  // Alt + P
		alt: true, 
		fn: function(){},
		scope: this
	}]);
	map.enable();




})