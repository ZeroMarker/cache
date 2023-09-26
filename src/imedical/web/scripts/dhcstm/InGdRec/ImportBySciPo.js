// /����: ����
function ImportBySciPo(Fn) {
	var gUserId = session['LOGON.USERID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	var SCIPoLoc = new Ext.ux.LocComboBox({
		fieldLabel : '����',
		id : 'SCIPoLoc',
		emptyText : '����...',
		groupId : gGroupId,
		disabled : true
	});
	// ��ⵥ��
	var SxNo = new Ext.form.TextField({
		fieldLabel : '��������',
		id : 'SxNo',
		anchor : '90%',
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					Ext.getCmp("SxNo").setValue(GetRealSynNo( Ext.getCmp("SxNo").getValue()));
					PoQuery();
				}
			}
		}
	});
	/*
* �������е���
**/
function GetRealSynNo(syno){
    
    if(syno.indexOf("{")==-1){
        return syno;
    }else{
        var len=syno.length
        var ffa=syno.substring(len-2,len);
        var tmp=eval('('+syno+')');
        
        return tmp.text
    }
    
}
	var SCIPoReqLoc = new Ext.ux.LocComboBox({
		fieldLabel : '�깺����',
		id : 'SCIPoReqLoc',
		emptyText : '�깺����...',
		defaultLoc : {},
		disabled : true
	});
	
	var SCIPoNo = new Ext.form.TextField({
		fieldLabel : '������',
		readOnly:true,
		id : 'SCIPoNo',
		anchor : '90%'
	});
	
	var SCIPoVendor = new Ext.ux.VendorComboBox({
		id : 'SCIPoVendor',
		fieldLabel : '��Ӧ��',
		disabled : true
	});
	
	var SCIPoDate = new Ext.form.TextField({
		fieldLabel : '��������',
		id : 'SCIPoDate',
		readOnly : true,
		anchor : '90%'
	});
	// ��ѯ������ť
	var PoSearchBT = new Ext.ux.Button({
				id : "PoSearchBT",
				text : '��ѯ',
				tooltip : '�����ѯ����',
				iconCls : 'page_find',
				handler : function() {
					PoQuery();
				}
			});


	// ��հ�ť
	var PoClearBT = new Ext.ux.Button({
				id : "PoClearBT",
				text : '���',
				tooltip : '������',
				width : 70,
				height : 30,
				iconCls : 'page_clearscreen',
				handler : function() {
					PoclearData();
				}
			});
	/**
	 * ��շ���
	 */
	function PoclearData() {
		SciPoDetailGrid.store.removeAll();
		SciPoDetailGrid.getView().refresh();
		
	}
	/**
	 * �رշ���
	 */
	var PocloseBT = new Ext.Toolbar.Button({
				id : "PocloseBT",
				text : '�ر�',
				tooltip : '�رս���',
				iconCls : 'page_delete',
				height:30,
				width:70,
				handler : function() {
					//var flg = false;
					Powin.close();
				}
			});
	// ���水ť
	var PoSaveBT = new Ext.ux.Button({
				id : "PoSaveBT",
				text : '����',
				tooltip : '�������',
				iconCls : 'page_save',
				handler : function() {
					if(SciPoDetailGrid.activeEditor != null){
						SciPoDetailGrid.activeEditor.completeEdit();
					}
					if(PoCheckDataBeforeSave()==true){
						Posave();
					}
				}
			});

	/**
	 * ������ⵥǰ���ݼ��
	 */
	function PoCheckDataBeforeSave() {
		// 1.�ж���������Ƿ�Ϊ��
		var rowCount = SciPoDetailGrid.getStore().getCount();
		if (rowCount <= 0) {
			Msg.info("warning", "����ϸ!");
			return false;
		}
		return true;
	}
	
	/**
	 * ������ⵥ
	 */
	function Posave() {
		var Ingr = '';
		var VenId =Ext.getCmp("SCIPoVendor").getValue();
		var Completed = 'N';
		var LocId = Ext.getCmp("SCIPoLoc").getValue();
		var CreateUser = gUserId;
		var ExchangeFlag ='N';
		var PresentFlag = 'N';
		var IngrTypeId = "";    //�������(2014-01-27:���θ�Ϊ��,���д���)
		var PurUserId ="";
		var StkGrpId = "";
		var PoId="";  //����id
		var ReqLoc=Ext.getCmp("SCIPoReqLoc").getValue();  //�깺����
		var SxNo = Ext.getCmp("SxNo").getValue();  //���е���
		
		var MainInfo = VenId + "^" + LocId + "^" + CreateUser + "^" + PresentFlag + "^"
				+ ExchangeFlag + "^" + IngrTypeId + "^" + PurUserId + "^"+StkGrpId+"^"+PoId+"^^^"+ReqLoc;
		var ListDetail="";
		var rowCount = SciPoDetailGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var rowData = SciPoDetailStore.getAt(i);
			var Ingri='';
			var IncId = rowData.get("IncId");
			var BatchNo = rowData.get("BatNo");
			var ExpDate = Ext.util.Format.date(rowData.get("ExpDate"),ARG_DATEFORMAT);
			var ManfId = rowData.get("ManfId");
			var IngrUomId = rowData.get("PurUomId");
			//var RecQty = rowData.get("AvaQty");
			var RecQty = rowData.get("AvaBarcodeQty"); 
			var Rp = rowData.get("Rp");
			var Sp = rowData.get("Sp");
			var NewSp = Sp;
			var InvNo ='';
			var InvDate ='';
			var PoItmId=rowData.get("PoItmId");
			var OrderDetailSubId=rowData.get("OrderDetailSubId");
			var str = Ingri + "^" + IncId + "^"	+ BatchNo + "^" + ExpDate + "^" + ManfId
					+ "^" + IngrUomId + "^" + RecQty+ "^" + Rp + "^" + NewSp + "^" + SxNo
					+ "^" + InvNo + "^" + InvDate+"^"+PoItmId+"^^"
					+ "^^^^^"
					+ "^^^^"+OrderDetailSubId + "^"
					+ "^" + Sp;
			if(ListDetail==""){
				ListDetail=str;
			}else{
				ListDetail=ListDetail+RowDelim+str;
			}
		}
		var url = DictUrl
				+ "ingdrecaction.csp?actiontype=Save";
		Ext.Ajax.request({
					url : url,
					method : 'POST',
					params : {Ingr:Ingr,MainInfo:MainInfo,ListDetail:ListDetail},
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							// ˢ�½���
							var IngrRowid = jsonData.info;
							Msg.info("success", "����ɹ�!");
							// 7.��ʾ��ⵥ����
							// ��ת������Ƶ�����
							Fn(IngrRowid);
							Powin.close();
						} else {
							var ret=jsonData.info;
							if(ret==-99){
								Msg.info("error", "����ʧ��,���ܱ���!");
							}else if(ret==-2){
								Msg.info("error", "������ⵥ��ʧ��,���ܱ���!");
							}else if(ret==-3){
								Msg.info("error", "������ⵥʧ��!");
							}else if(ret==-4){
								Msg.info("error", "δ�ҵ�����µ���ⵥ,���ܱ���!");
							}else if(ret==-5){
								Msg.info("error", "������ⵥ��ϸʧ��!");
							}else {
								Msg.info("error", "������ϸ���治�ɹ���"+ret);
							}
						}
					},
					scope : this
				});
	}
	// ��ʾ��������
	function PoQuery() {
		var SxNo = Ext.getCmp("SxNo").getValue();
		var HVFlag = 'N';
		var mask = ShowLoadMask(Powin.body, "���������Ժ�...");
		Ext.Ajax.request({
			url: 'dhcstm.sciaction.csp?actiontype=getOrderDetail',
			params: {SxNo : SxNo, HVFlag : HVFlag},
			waitMsg: '������...',
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				mask.hide();
				if(!Ext.isEmpty(jsonData)){
					if(!Ext.isEmpty(jsonData['Main']) && !Ext.isEmpty(jsonData['Detail'])){
						if(jsonData['Detail']['results'] > 0){
							PoHisListTab.getForm().setValues(jsonData['Main']);
							SciPoDetailGrid.getStore().loadData(jsonData['Detail']);
						}else{
							Msg.info('warning', 'δ�ҵ����ϵĵ�����ϸ,��ȷ���Ƿ��ֵ����!');
						}
					}else{
						Msg.info('warning', '�õ����Ѵ���!');
					}
				}else{
					Msg.info("warning", "δ�ҵ����ϵĵ���!");
				}
			},
			scope: this
		});
	}
	// ����·��
	var DetailUrl =DictUrl+
		'sciaction.csp?actiontype=getOrderDetail';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["PoItmId", "IncId", "IncCode","IncDesc","PurUomId", "PurUom", "AvaQty", "Rp",
			 "ManfId", "Manf", "Sp","BatNo",{name:'ExpDate',type:'date',dateFormat:DateFormat}, "BUomId", "ConFac","PurQty","ImpQty",
			 "BatchReq","ExpReq","Spec","BarcodeQty","AvaBarcodeQty","SpecDesc","CerNo","CerExpDate","HighValueFlag","BarCode","OrderDetailSubId"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				fields : fields
			});
	// ���ݼ�
	var SciPoDetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader,
				pruneModifiedRecords:true
			});
	var sm2=new Ext.grid.CheckboxSelectionModel({
			listeners : {
				beforerowselect :function(sm,rowIndex,keepExisting ,record  ) {
					var hvflag=record.get("HighValueFlag")
					if (hvflag=='Y'){Msg.info("warning","��ֵ������ȥ��ֵע����浼�붩��!");return false}
				}
			}
	})
	var nm = new Ext.grid.RowNumberer();
	var SciPoDetailCm = new Ext.grid.ColumnModel([nm,sm2,{
				header : "������ϸid",
				dataIndex : 'PoItmId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "����RowId",
				dataIndex : 'IncId',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : '���ʴ���',
				dataIndex : 'IncCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '��������',
				dataIndex : 'IncDesc',
				width : 230,
				align : 'left',
				sortable : true
			}, {
				header : '���',
				dataIndex : 'Spec',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '������',
				dataIndex : 'SpecDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '��ֵ��־',
				dataIndex : 'HighValueFlag',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'AvaBarcodeQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'Rp',
				width : 60,
				align : 'right',
				sortable : true
			}, {
				header : "�ۼ�",
				dataIndex : 'Sp',
				width : 60,
				align : 'right',
				
				sortable : true
			},{
				header : "��������",
				dataIndex : 'PurQty',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "���������",
				dataIndex : 'ImpQty',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "����������",
				dataIndex : 'BarcodeQty',
				width : 80,
				align : 'left',
				sortable : true
			},{
				header : "ע��֤����",
				dataIndex : 'CerNo',
				width : 80,
				align : 'left',
				sortable : true
			},{
				header : "ע��֤Ч��",
				dataIndex : 'CerExpDate',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'BarCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'BatNo',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "Ч��",
				dataIndex : 'ExpDate',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'BarCode',
				width : 80,
				align : 'left',
				sortable : true
			}]);
	
	var SciPoDetailGrid = new Ext.ux.EditorGridPanel({
				id:'SciPoDetailGrid',
				region: 'center',
				title: '������ϸ',
				cm : SciPoDetailCm,
				store : SciPoDetailStore,
				sm:sm2,
				clicksToEdit:1
			});
	var PoHisListTab = new Ext.ux.FormPanel({
		labelWidth : 60,
		tbar : [PoSearchBT,'-',PoClearBT, '-',PoSaveBT, '-',PocloseBT],
		layout: 'column',
		items:[{
				columnWidth: 0.3,
				xtype:'fieldset',
				style : 'padding:5px 0px 0px 5px',
				title:'��ѯ����',
				items: [SxNo]
			},{
				columnWidth: 0.7,
				layout: 'column',
				xtype:'fieldset',
				style : 'padding:5px 0px 0px 5px;margin:0px 0px 0px 5px;',
				title:'������Ϣ',
				defaults: {layout : 'form'},
				items:[{
					columnWidth: 0.33,
					items: [SCIPoLoc]
				},{
					columnWidth: 0.33,
					items: [SCIPoNo,SCIPoVendor]
				},{
					columnWidth: 0.33,
					items: [SCIPoReqLoc,SCIPoDate]
				}]
			}]
	});

	// ҳ�沼��
	var Powin = new Ext.Window({
				title : '��ƽ̨��������',
				modal : true,
				width : gWinWidth,
				height : gWinHeight * 0.9,
				layout : 'border',
				items : [PoHisListTab,SciPoDetailGrid]
			});
	//ҳ�������ɺ��Զ���������
	Powin.show()
	SxNo.focus(true,100)
	
}