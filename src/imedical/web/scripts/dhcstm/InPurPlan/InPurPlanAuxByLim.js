// /����: �ɹ��ƻ������Ƶ������ݿ�������ޣ�
// /����: �ɹ��ƻ������Ƶ������ݿ�������ޣ�
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.03

Ext.onReady(function() {
	var userId = session['LOGON.USERID'];

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
		stkGrpId : 'StkGrpType'
	});
			
			// ������׼ȡ������
	var RepLevFac =new Ext.form.NumberField({
			fieldLabel : '������׼ȡ������',
			id : 'RepLevFac',
			emptyText:'0-1֮���С��',
			name : 'RepLevFac',
			anchor : '90%'
	});

	// ��������
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		StkType:App_StkTypeCode,     //��ʶ��������
		LocId:session['LOGON.CTLOCID'],
		UserId:session['LOGON.USERID'],
		anchor : '90%'
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
		if (PurLoc == undefined || PurLoc.length <= 0) {
			Msg.info("warning", "��ѡ��ɹ�����!");
			return;
		}
        if(fac<0||fac>1){
	        Msg.info("warning","��׼��������Ӧ����0-1֮�����!");
	        return;
	        } 
		//����id,����id,������׼ȡ������
		var ListParam=PurLoc+'^'+stkgrp+'^'+fac+'^'+userId;				
		DetailStore.removeAll();
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
		var ProPurQty = rowData.data["PurQty"];
		var uomId = rowData.data["PurUomId"];
		var vendorId = rowData.data["VenId"];
		var rp =rowData.data["Rp"];
		var manfId =rowData.data["ManfId"];
		var carrierId =rowData.data["CarrierId"];
		var reqLocId ='';
		var dataRow = rowid+"^"+incId+"^"+qty+"^"+uomId+"^"+vendorId+"^"+rp+"^"+manfId+"^"+carrierId+"^"+reqLocId+"^^^^"+ProPurQty;
		if(data==""){
			data = dataRow;
		}else{
			data = data+xRowDelim()+dataRow;
		}
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
					location.href="dhcstm.inpurplan.csp?planNnmber="+jsonData.info+'&locId='+locId;
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
						Msg.info("error","����ƻ�����ϸʧ��,�������ɼƻ���!");
					}else if(jsonData.info==-7){
						Msg.info("error","ʧ�����ʣ�������ϸ���治�ɹ�����ʾ���ɹ�������!");
					}else{
						Msg.info("error","����ʧ��!");
					}
				}
			},
			scope: this
		});
	}
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
	/**
	 * ��շ���
	 */
	function clearData() {
		//Ext.getCmp("PurLoc").setValue("");
		Ext.getCmp("RepLevFac").setValue("");
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
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
	 * ɾ��ѡ��������
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
			 "BUomId","ConFac","VenId","ManfId","CarrierId","RepLev",{name:'Qty',convert:function(v,rec){return rec.PurQty;}},"ApcWarn"];
			
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				//totalProperty : "results",
				id : "Inci",
				fields : fields
			});
	
	// ���ݼ�
	var DetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, {
				header : "����Id",
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
				header : '��������',
				dataIndex : 'InciDesc',
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
								if (qty <= 0) {
									Msg.info("warning", "�ɹ���������С�ڻ����0!");
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
				header : '���',
				dataIndex : 'Spec',
				width : 180,
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
	
	var DetailGrid = new Ext.grid.EditorGridPanel({
				region : 'center',
				title : '��ϸ',
				tbar:[DeleteItmBT],
				cm : DetailCm,
				store : DetailStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				sm : new Ext.grid.CellSelectionModel({}),
				clicksToEdit : 1
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
        	items: [PurLoc]
		}
	var col2={ 				
			columnWidth: 0.2,
        	xtype: 'fieldset',
        	items: [StkGrpType,RepLevFac]
		}
	var HisListTab = new Ext.ux.FormPanel({
		title:'�ɹ��ƻ����Ƶ�-���ݿ��������',
		labelWidth: 60,
		tbar : [SearchBT, '-', ClearBT,'-',SaveBT],
		items : [{
			xtype:'fieldset',
			title:'��ѯ����',
			style : 'padding:5px 0px 0px 5px;',
			layout: 'column',
			defaults: {border:false},
			items:[col1,col2,{
					columnWidth:0.5,
					html:"<font size=2 color=blue>������׼>=1,�Ҳ�����׼ȡ��������Ϊ�գ�����ɹ���=������׼*N,N=M+R" +
						"<br>M=(��׼���-���ҿ��)/������׼��ȡ��������" +
						"<br>((��׼���-���ҿ��)#������׼)/������׼<������׼ȡ������ʱ��R=0,����R=1,#����ȡ��" +
						"<br>������׼<1,�򲹻���׼ȡ������Ϊ�գ�����ɹ���=��׼���-���ҿ��</font>"
					}]
		}]
	});

	// ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
				layout : 'border',
				items : [HisListTab, DetailGrid],
				renderTo : 'mainPanel'
			});

})