// /����: ���ݶ������
// /����: ���ݶ������
// /��д�ߣ�zhangdongmei
// /��д����: 2012.07.31
var IngrTypeId
var RecByPoPageSize=999;
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	if(gParam.length<1){
		GetParam();  //��ʼ����������
	}
	var PhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : $g('����'),
				id : 'PhaLoc',
				name : 'PhaLoc',
				anchor : '90%',
				emptyText : $g('��������...'),
				groupId:session['LOGON.GROUPID']
			});
	OperateInTypeStore.load();
		// Ĭ��ѡ�е�һ������
	OperateInTypeStore.on('load', function() {
					//OperateInType.setValue(1);
				setDefaultInType();
		  });
	 function setDefaultInType()
	    {
		if (OperateInTypeStore.getTotalCount() > 0){
                IngrTypeId=OperateInTypeStore.getAt(0).data.RowId;
          }

	  }
	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
				fieldLabel : $g('��ʼ����'),
				id : 'StartDate',
				name : 'StartDate',
				anchor : '90%',
				width : 120,
				value : new Date().add(Date.DAY, - 7)
			});
	// ��ֹ����
	var EndDate = new Ext.ux.DateField({
				fieldLabel : $g('��ֹ����'),
				id : 'EndDate',
				name : 'EndDate',
				anchor : '90%',
				width : 120,
				value : new Date()
			});
	
	var NotImp = new Ext.form.Checkbox({
				fieldLabel : $g('δ���'),
				id : 'NotImp',
				name : 'NotImp',
				anchor : '90%',
				width : 120,
				checked : true
			});
	var PartlyImp = new Ext.form.Checkbox({
		fieldLabel : $g('�������'),
		id : 'PartlyImp',
		name : 'PartlyImp',
		anchor : '90%',
		width : 120,
		checked : true
	});
	/*
	var AllImp = new Ext.form.Checkbox({
		fieldLabel : 'ȫ�����',
		id : 'AllImp',
		name : 'AllImp',
		anchor : '90%',
		width : 120,
		checked : false
	});
	*/
	// ��Ӫ��ҵ
	var Vendor = new Ext.ux.VendorComboBox({
			fieldLabel : $g('��Ӫ��ҵ'),
			id : 'Vendor',
			name : 'Vendor',
			anchor : '90%'
	});
		
	// ��ѯ������ť
	var SearchBT = new Ext.Toolbar.Button({
				id : "SearchBT",
				text : $g('��ѯ'),
				tooltip : $g('�����ѯ����'),
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					Query();
				}
			});


	// ��հ�ť
	var ClearBT = new Ext.Toolbar.Button({
				id : "ClearBT",
				text : $g('����'),
				tooltip : $g('�������'),
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
		SetLogInDept(Ext.getCmp("PhaLoc").getStore(),"PhaLoc");
	    Ext.getCmp("Vendor").setValue("");
		Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, - 7));
		Ext.getCmp("EndDate").setValue(new Date());
		Ext.getCmp("NotImp").setValue(true);
		Ext.getCmp("PartlyImp").setValue(true);
		
		MasterGrid.store.removeAll();
		DetailGrid.store.removeAll();
		DetailGrid.store.load({params:{start:0,limit:0}})
		DetailGrid.getView().refresh();
		
	}

	// ���水ť
	var SaveBT = new Ext.Toolbar.Button({
				id : "SaveBT",
				text :$g( '����'),
				tooltip : $g('�������'),
				width : 70,
				height : 30,
				iconCls : 'page_save',
				handler : function() {
					if(CheckDataBeforeSave()==true){
						save();						
					}
				}
			});

	/**
	 * ������ⵥǰ���ݼ��
	 */		
	function CheckDataBeforeSave() {
		var nowdate = new Date();
		var record = MasterGrid.getSelectionModel().getSelected();
		if(record==null){
			Msg.info("warning", $g("û����Ҫ���������!"));				
			return false;
		}
		
		var Status = record.get("PoStatus");				
		if (Status ==2) {
			Msg.info("warning", $g("�ö����Ѿ�ȫ����⣬���������!"));				
			return false;
		}			
		
		// �ж���ⲿ�ź͹������Ƿ�Ϊ��
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc == null || phaLoc.length <= 0) {
			Msg.info("warning",$g("��ѡ����ⲿ��!"));
			return false;
		}
		
		// 1.�ж����ҩƷ�Ƿ�Ϊ��
		var rowCount = DetailGrid.getStore().getCount();
		// ��Ч����
		var count = 0;
		for (var i = 0; i < rowCount; i++) {
			var item = DetailStore.getAt(i).get("IncId");
			if (item != "") {
				count++;
			}
		}
		if (rowCount <= 0 || count <= 0) {
			Msg.info("warning", $g("�����������ϸ!"));
			return false;
		}
		// 2.������䱳��
		for (var i = 0; i < rowCount; i++) {
			changeBgColor(i, "white");
		}
		// 3.�ж��ظ�����ҩƷ
		for (var i = 0; i < rowCount - 1; i++) {
			for (var j = i + 1; j < rowCount; j++) {
				var item_i = DetailStore.getAt(i).get("IncId");;
				var item_j = DetailStore.getAt(j).get("IncId");;
				if (item_i != "" && item_j != ""
						&& item_i == item_j) {
					changeBgColor(i, "yellow");
					changeBgColor(j, "yellow");
					Msg.info("warning", $g("ҩƷ�ظ�������������!"));
					return false;
				}
			}
		}
		// 4.ҩƷ��Ϣ�������
		for (var i = 0; i < rowCount; i++) {
			var expDateValue = DetailStore.getAt(i).get("ExpDate");
			var item = DetailStore.getAt(i).get("IncId");
			var incDesc=DetailStore.getAt(i).get("IncDesc");
			var ExpDate = new Date(Date.parse(expDateValue));
			var freedrugflag=DetailStore.getAt(i).get('FreeDrugFlag');
			
			if ((item != "")	&& (ExpDate.format("Y-m-d") <= nowdate.format("Y-m-d"))) {
				Msg.info("warning", incDesc+$g("����Ч�ڲ���С�ڻ���ڵ�ǰ����!"));
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				DetailGrid.getSelectionModel().select(cell[0], 1);
				changeBgColor(i, "yellow");
				return false;
			}
			
			var qty = DetailStore.getAt(i).get("PurQty");
			if ((item != "") && (qty == null || qty <= 0)) {
				Msg.info("warning", incDesc+$g("�������������С�ڻ����0!"));
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				DetailGrid.getSelectionModel().select(cell[0], 1);
				changeBgColor(i, "yellow");
				return false;
			}
			var realPrice = DetailStore.getAt(i).get("Rp");
			var sPrice = DetailStore.getAt(i).get("Sp");
			if(sPrice==0&&gParam[15]==1){
				Msg.info("warning", incDesc+$g("����ά����������!"));
				return false;
			}
			if (freedrugflag!="Y"){
				if((item != "")&&(realPrice == null || realPrice <= 0)) {
					Msg.info("warning", incDesc+$g("�������۲���С�ڻ����0!"));
					var cell = DetailGrid.getSelectionModel().getSelectedCell();
					DetailGrid.getSelectionModel().select(cell[0], 1);
					changeBgColor(i, "yellow");
					return false;
				}
			}else{
				if((item != "")&&(realPrice == null || realPrice < 0)){
					Msg.info("warning", incDesc+$g("�������۲���С��0!"));
					var cell = DetailGrid.getSelectionModel().getSelectedCell();
					DetailGrid.getSelectionModel().select(cell[0], 1);
					changeBgColor(i, "yellow");
					return false;
				}
			}
			if ((item != "")&& (Number(realPrice))>Number(sPrice)) {
				Msg.info("warning", incDesc+$g("�������۲��ܴ����ۼ�!"));
				var cell = DetailGrid.getSelectionModel()
						.getSelectedCell();
				//DetailGrid.getSelectionModel().select(cell[0], 1);
				changeBgColor(i, "yellow");
				return false;
			}
			var expDate = DetailStore.getAt(i).get("ExpDate").format('Y-m-d');
			var flag=ExpDateValidator(expDate);									
			if(flag==false){
				Msg.info('warning',incDesc+$g('����ҩƷ����ʧЧ������'+gParam[2]+'��!'));								    	
				var cell = DetailGrid.getSelectionModel()
						.getSelectedCell();
				//DetailGrid.getSelectionModel().select(cell[0], 1);
				changeBgColor(i, "yellow");
				return false;
				 }
			//������������Ƿ�����С���ж� 2020-02-21 yangsj
            if(gParam[19]!="Y")  //1 ����¼��С��
            {
        		var record = DetailStore.getAt(i)
                var buomId=record.get("BUomId")
                var purUomId=record.get("PurUomId")
                var buomQty=qty
                if(buomId!=purUomId)
                {
                    var fac=record.get("ConFac")
                    buomQty=Number(fac).mul(qty);
                }
                if((buomQty.toString()).indexOf(".")>=0)
                {
                    Msg.info("warning", record.get("IncDesc")+$g("�����������ɻ�����λ֮�����С����������⣡��˶�������ã������������Ϊ������λ�Ƿ�����С��!"));
                    return;
                }
                
            }	 
			
		}
		
		return true;
	}
	
	/**
	 * ������ⵥ
	 */
	function save() {
		var selectRecords = MasterGrid.getSelectionModel().getSelections();
		var record = selectRecords[0];	
		var IngrNo = '';
		var VenId = record.get("VenId");
		var Completed = 'N';
		var LocId = Ext.getCmp("PhaLoc").getValue();
		var CreateUser = userId;
		var ExchangeFlag ='N';
		var PresentFlag = 'N';
		//var IngrTypeId = 1;    //�������		
		var PurUserId = record.get("PurUserId");
		var StkGrpId = record.get("StkGrpId");
		var PoId=record.get("PoId");  //����id
		
		var MainInfo = VenId + "^" + LocId + "^" + CreateUser + "^" + PresentFlag + "^"
				+ ExchangeFlag + "^" + IngrTypeId + "^" + PurUserId + "^"+StkGrpId+"^"+PoId;
		var ListDetail="";
		var rowCount = DetailGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var rowData = DetailStore.getAt(i);					
								
			var Ingri='';
			var IncId = rowData.get("IncId");
			var BatchNo = rowData.get("BatNo");
			var ExpDate =Ext.util.Format.date(rowData.get("ExpDate"),App_StkDateFormat);
			var ManfId = rowData.get("ManfId");
			var IngrUomId = rowData.get("PurUomId");
			var RecQty = rowData.get("AvaQty");
			var Rp = rowData.get("Rp");
			var NewSp =rowData.get("Sp");
			var SxNo ='';
			var InvNo ='';
			var InvDate ='';
			var PoItmId=rowData.get("PoItmId");
			
			var str = Ingri + "^" + IncId + "^"	+ BatchNo + "^" + ExpDate + "^"
					+ ManfId + "^" + IngrUomId + "^" + RecQty+ "^" + Rp + "^" + NewSp + "^"
					+ SxNo + "^" + InvNo + "^" + InvDate+"^"+PoItmId;	
			if(ListDetail==""){
				ListDetail=str;
			}
			else{
				ListDetail=ListDetail+RowDelim+str;
			}
			
		}
		var url = DictUrl
				+ "ingdrecaction.csp?actiontype=Save";
		Ext.Ajax.request({
					url : url,
					method : 'POST',
					params : {IngrNo:IngrNo,MainInfo:MainInfo,ListDetail:ListDetail},
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							// ˢ�½���
							var IngrRowid = jsonData.info;
							Msg.info("success", $g("����ɹ�!"));
							// 7.��ʾ��ⵥ����
							// ��ת������Ƶ�����
							window.location.href='dhcst.ingdrec.csp?Rowid='+IngrRowid+'&QueryFlag=1';

						} else {
							var ret=jsonData.info;
							if(ret==-99){
								Msg.info("error", $g("����ʧ��,���ܱ���!"));
							}else if(ret==-2){
								Msg.info("error", $g("������ⵥ��ʧ��,���ܱ���!"));
							}else if(ret==-3){$g(
								Msg.info("error", "������ⵥʧ��!"));
							}else if(ret==-4){
								Msg.info("error", $g("δ�ҵ�����µ���ⵥ,���ܱ���!"));
							}else if(ret==-5){
								Msg.info("error", $g("������ⵥ��ϸʧ��!"));
							}else {
								Msg.info("error", $g("������ϸ���治�ɹ���")+ret);
							}
							
						}
					},
					scope : this
				});
		
	}

	/**
	 * ɾ��ѡ����ҩƷ
	 */
	function deleteDetail() {
		// �ж�ת�Ƶ��Ƿ������
		var cell = DetailGrid.getSelectionModel().getSelectedCell();
		if (cell == null) {
			Msg.info("warning", $g("û��ѡ����!"));
			return;
		}
		// ѡ����
		var row = cell[0];
		var record = DetailGrid.getStore().getAt(row);			
		DetailGrid.getStore().remove(record);
	
	}
	

	// ��λ
	var CTUom = new Ext.form.ComboBox({
				fieldLabel : $g('��λ'),
				id : 'CTUom',
				name : 'CTUom',
				anchor : '90%',
				width : 120,
				store : ItmUomStore,
				valueField : 'RowId',
				displayField : 'Description',
				allowBlank : false,
				triggerAction : 'all',
				emptyText : $g('��λ...'),
				selectOnFocus : true,
				forceSelection : true,
				minChars : 1,
				pageSize : 10,
				listWidth : 250,
				valueNotFoundText : ''
			});

	// ����������ҵ
	var Phmnf = new Ext.form.ComboBox({
				fieldLabel : $g('������ҵ'),
				id : 'Phmnf',
				name : 'Phmnf',
				anchor : '90%',
				width : 100,
				store : PhManufacturerStore,
				valueField : 'RowId',
				displayField : 'Description',
				allowBlank : false,
				triggerAction : 'all',
				emptyText : $g('������ҵ...'),
				selectOnFocus : true,
				forceSelection : true,
				minChars : 1,
				pageSize : 20,
				listWidth : 250,
				valueNotFoundText : '',
				listeners : {
					'beforequery' : function(e) {
						var filter=Ext.getCmp('Phmnf').getRawValue();
						PhManufacturerStore.reload({
							params : {
										start : 0,
										limit : 20,
										PHMNFName:filter
							}
						});
						
					}
				}
			});


	// ��ʾ��������
	function Query() {
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc =='' || phaLoc.length <= 0) {
			Msg.info("warning", $g("��ѡ�񶩹�����!"));
			return;
		}
		var startDate = Ext.getCmp("StartDate").getRawValue();
		var endDate = Ext.getCmp("EndDate").getRawValue();
		var notimp = (Ext.getCmp("NotImp").getValue()==true?0:'');
		var partlyimp = (Ext.getCmp("PartlyImp").getValue()==true?1:'');
		//var allimp = (Ext.getCmp("AllImp").getValue()==true?2:'');
		var Status=notimp+","+partlyimp;
		var Vendor = Ext.getCmp("Vendor").getValue();

		//��ʼ����^��ֹ����^������^��Ӫ��ҵid^����id^��ɱ�־^��˱�־^����״̬(δ��⣬������⣬ȫ�����)
		var ListParam=startDate+'^'+endDate+'^^'+Vendor+'^'+phaLoc+'^Y^^'+Status;
		var Page=GridPagingToolbar.pageSize;
		MasterStore.removeAll();
		DetailGrid.store.removeAll();
		MasterStore.setBaseParam("ParamStr",ListParam);
		MasterStore.load({
			params:{start:0, limit:Page},
			callback : function(r,options, success){
				if(success==false){
     				Msg.info("error", $g("��ѯ������鿴��־!"));
     			}else{
     				if(r.length>0){
	     				MasterGrid.getSelectionModel().selectFirstRow();
	     				MasterGrid.getSelectionModel().fireEvent('rowselect',this,0);
	     				MasterGrid.getView().focusRow(0);
     				}
     			}
     		}
		});

	}
	// ��ʾ��ⵥ��ϸ����
	function getDetail(Parref) {
		if (Parref == null || Parref=='') {
			return;
		}
		var strParam=Parref
		DetailStore.setBaseParam("Params",strParam);
		DetailStore.load({params:{start:0,limit:StatuTabPagingToolbar.pageSize}});
	}
	
	function renderPoStatus(value){
		var PoStatus='';
		if(value==0){
			PoStatus=$g('δ���');			
		}else if(value==1){
			PoStatus=$g('�������');
		}else if(value==2){
			PoStatus=$g('ȫ�����');
		}
		return PoStatus;
	}
	// ����·��
	var MasterUrl = DictUrl	+ 'inpoaction.csp?actiontype=Query';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["PoId", "PoNo", "PoLoc", "Vendor","PoStatus", "PoDate","PurUserId","StkGrpId","VenId"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "PoId",
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
				dataIndex : 'PoId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g("������"),
				dataIndex : 'PoNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : $g("��������"),
				dataIndex : 'PoLoc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : $g("��Ӫ��ҵ"),
				dataIndex : 'Vendor',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : $g("����״̬"),
				dataIndex : 'PoStatus',
				width : 90,
				align : 'left',
				sortable : true,
				renderer:renderPoStatus
			}, {
				header : $g("��������"),
				dataIndex : 'PoDate',
				width : 80,
				align : 'right',
				sortable : true
			}]);
	MasterCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:MasterStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:$g('�� {0} ���� {1}�� ��һ�� {2} ��'),
		emptyMsg:$g("û�м�¼")
	});
	var MasterGrid = new Ext.grid.GridPanel({
				title : '',
				height : 170,
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

	// ��ӱ�񵥻����¼�
	MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
		var PoId = MasterStore.getAt(rowIndex).get("PoId");
		var strParam=PoId
		DetailStore.setBaseParam("Params",strParam);
		DetailStore.load({params:{start:0,limit:StatuTabPagingToolbar.pageSize}});
	});
	
	// ������ϸ
	// ����·��
	var DetailUrl =DictUrl+
		'ingdrecaction.csp?actiontype=QueryPoDetailForRec&Parref=';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["PoItmId", "IncId", "IncCode","IncDesc","PurUomId", "PurUom", "AvaQty", "Rp","ManfId", "Manf", "Sp","BatNo",
			 {name:"ExpDate",type:"date",dateFormat:App_StkDateFormat}, "BUomId", "ConFac","PurQty","ImpQty",'FreeDrugFlag'];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "PoItmId",
				fields : fields
			});
	// ���ݼ�
	var DetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	
	/**
	 * ��ʾ��ϸǰ��װ�ر�Ҫ��combox
	 */
	DetailStore.on('beforeload',function(store,options){
		//װ�����е�λ
		var url = DictUrl
						+ 'drugutil.csp?actiontype=CTUom&CTUomDesc=&start=0&limit=9999';
		CTUomStore.proxy = new Ext.data.HttpProxy({
							url : url
						});
		CTUomStore.load();
		
		//װ������������ҵ
		PhManufacturerStore.reload({
			params : {
						start : 0,
						limit : 9999,
						PHMNFName:''
			}
		})
	});
	
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, {
				header : $g("������ϸid"),
				dataIndex : 'PoItmId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g("ҩƷRowId"),
				dataIndex : 'IncId',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g('ҩƷ����'),
				dataIndex : 'IncCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : $g('ҩƷ����'),
				dataIndex : 'IncDesc',
				width : 230,
				align : 'left',
				sortable : true
			}, {
				header : $g("����"),
				dataIndex : 'AvaQty',
				width : 80,
				align : 'right',
				sortable : true,
				editor : new Ext.form.NumberField({
					selectOnFocus : true,
					allowBlank : false,
					allowNegative:false,
					listeners : {
						specialkey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								
								var qty = field.getValue();
								if (qty == null || qty.length <= 0) {
									Msg.info("warning", $g("��������Ϊ��!"));
									return;
								}
								if (qty <= 0) {
									Msg.info("warning", $g("��������С�ڻ����0!"));
									return;
								}
								
								//������������Ƿ�����С���ж� 2020-02-21 yangsj
	                            if(gParam[19]!=1)  //1 ����¼��С��
	                            {
		                            var cell = DetailGrid.getSelectionModel().getSelectedCell();
                            		var record = DetailGrid.getStore().getAt(cell[0]);
		                            var buomId=record.get("BUomId")
		                            var purUomId=record.get("PurUomId")
		                            var buomQty=qty
		                            if(buomId!=purUomId)
		                            {
			                            var fac=record.get("ConFac")
			                            buomQty=Number(fac).mul(qty);
		                            }
		                            if((buomQty.toString()).indexOf(".")>=0)
		                            {
			                            Msg.info("warning", $g("�����������ɻ�����λ֮�����С����������⣡��˶�������ã������������Ϊ������λ�Ƿ�����С��!"));
		                                return;
		                            }
		                            
	                            }
																	
							}
						}
					}
				})
			}, {
				header : $g("��λ"),
				dataIndex : 'PurUomId',
				width : 80,
				align : 'left',
				sortable : true,
				renderer :  Ext.util.Format.comboRenderer2(CTUom,"PurUomId","PurUom"), // pass combo instance to reusable renderer					
				editor : new Ext.grid.GridEditor(CTUom)
			}, {
				header : $g("����"),
				dataIndex : 'Rp',
				width : 60,
				align : 'right',
			
				sortable : true,
				editor : new Ext.form.NumberField({
							selectOnFocus : true,
							allowBlank : false,
							listeners : {
								specialkey : function(field, e) {
									if (e.getKey() == Ext.EventObject.ENTER) {
										var cost = field.getValue();
										if (cost == null
												|| cost.length <= 0) {
											Msg.info("warning", $g("���۲���Ϊ��!"));
											return;
										}
										if (cost <= 0) {
											Msg.info("warning",
													$g("���۲���С�ڻ����0!"));
											return;
										}
										
										var cell = DetailGrid.getSelectionModel().getSelectedCell();
										DetailGrid.startEditing(cell[0], 10);
									}
								}
							}
				})
			}, {
				header : $g("�ۼ�"),
				dataIndex : 'Sp',
				width : 60,
				align : 'right',
				
				sortable : true
			},{
				header :$g( "������ҵ"),
				dataIndex : 'ManfId',
				width : 180,
				align : 'left',
				sortable : true,
				editor : new Ext.grid.GridEditor(Phmnf),
				renderer : Ext.util.Format.comboRenderer2(Phmnf,"ManfId","Manf") // pass combo instance to reusable renderer					
			}, {
				header : $g("����"),
				dataIndex : 'BatNo',
				width : 90,
				align : 'left',
				sortable : true,
				editor : new Ext.grid.GridEditor(new Ext.form.TextField({
					selectOnFocus : true,
					allowBlank : false,
					listeners : {
						specialkey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								
								var batchNo = field.getValue();
								if (batchNo == null || batchNo.length <= 0) {
									Msg.info("warning", $g("���Ų���Ϊ��!"));
									return;
								}
								var cell = DetailGrid.getSelectionModel()
										.getSelectedCell();
								DetailGrid.startEditing(cell[0], 11);
							}
						}
					}
				}))
			}, {
				header : $g("��Ч��"),
				dataIndex : 'ExpDate',
				width : 100,
				align : 'center',
				sortable : true,	
				renderer : Ext.util.Format.dateRenderer(App_StkDateFormat),
				editor : new Ext.form.DateField({
					selectOnFocus : true,
					allowBlank : false,
					listeners : {
						specialkey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								var expDate = field.getValue();
								if (expDate == null || expDate.length <= 0) {
									Msg.info("warning", $g("��Ч�ڲ���Ϊ��!"));
									return;
								}
								var nowdate = new Date();
								if (expDate.format("Y-m-d") <= nowdate
										.format("Y-m-d")) {
									Msg.info("warning", $g("��Ч�ڲ���С�ڻ���ڵ�ǰ����!"));
									return;
								}
									var expDate = field.getValue().format('Y-m-d');
									var flag=ExpDateValidator(expDate);									
								    if(flag==false){
								    	Msg.info('warning',$g('��ҩƷ����ʧЧ������')+gParam[2]+$g('��!'));								    	
								    }
																
							}
						}
					}
				})
				
			}, {
				header :$g( "��������"),
				dataIndex : 'PurQty',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : $g("���������"),
				dataIndex : 'ImpQty',
				width : 80,
				align : 'left',
				sortable : true
			},{
				header : $g("ת����"),
				dataIndex : 'ConFac',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g("������λ"),
				dataIndex : 'BUomId',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
	            header: $g("���ҩ��ʶ"),
	            dataIndex: 'FreeDrugFlag',
	            width: 80,
	            align: 'left',
	            sortable: true
        	}]);
	var StatuTabPagingToolbar = new Ext.PagingToolbar({
					store : DetailStore,
					pageSize : RecByPoPageSize,
					displayInfo : true,
					displayMsg : $g('��ǰ��¼ {0} -- {1} �� �� {2} ����¼'),
					prevText : $g("��һҳ"),
					nextText :$g( "��һҳ"),
					refreshText : $g("ˢ��"),
					lastText : $g("���ҳ"),
					firstText : $g("��һҳ"),
					beforePageText : $g("��ǰҳ"),
					afterPageText : $g("��{0}ҳ"),
					emptyMsg : $g("û������")
				});
	var DetailGrid = new Ext.grid.EditorGridPanel({
				id : 'DetailGrid',
				region : 'center',
				title : '',
				cm : DetailCm,
				store : DetailStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				sm : new Ext.grid.CellSelectionModel({}),
				clicksToEdit : 1,
				bbar:[StatuTabPagingToolbar]
			});
			
	/***
	**����Ҽ��˵�
	**/		
	DetailGrid.addListener('rowcontextmenu', rightClickFn);//�Ҽ��˵�����ؼ����� 
	var rightClick = new Ext.menu.Menu({ 
		id:'rightClickCont', 
		items: [ 
			{ 
				id: 'mnuDelete', 
				handler: deleteDetail, 
				text: $g('ɾ��' )
			}
		] 
	}); 
	
	//�Ҽ��˵�����ؼ����� 
	function rightClickFn(grid,rowindex,e){ 
		e.preventDefault(); 
		rightClick.showAt(e.getXY()); 
	}

	/**
	 * ��λչ���¼�
	 */
	CTUom.on('expand', function(combo) {
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				var record = DetailGrid.getStore().getAt(cell[0]);
				var InciDr = record.get("IncId");
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
				var PurUom = record.get("PurUomId");    //Ŀǰ��ʾ����ⵥλ
				var Sp = record.get("Sp");
				var Rp = record.get("Rp");
				
				if (value == null || value.length <= 0) {
					return;
				} else if (PurUom == value) {
					return;
				} else if (value==BUom) {     //��ѡ��ĵ�λΪ������λ��ԭ��ʾ�ĵ�λΪ��λ
					record.set("Sp", Sp/ConFac);
					record.set("Rp", Rp/ConFac);					
				} else{  //��ѡ��ĵ�λΪ��λ��ԭ���ǵ�λΪС��λ
					record.set("Sp", Sp*ConFac);
					record.set("Rp", Rp*ConFac);						
				}
				record.set("PurUomId", combo.getValue());
	});

	// �任����ɫ
	function changeBgColor(row, color) {
		DetailGrid.getView().getRow(row).style.backgroundColor = color;
	}

	var HisListTab = new Ext.form.FormPanel({
		labelWidth : 60,
		title:$g('����Ƶ�-���ݶ���'),
		labelAlign : 'right',
		autoHeight:true,
		frame : true,
		tbar : [SearchBT, '-',  ClearBT, '-', SaveBT],
		items : [{
			layout: 'column',    // Specifies that the items will now be arranged in columns
			xtype:'fieldset',
			title:$g('��ѯ����'),
			style:DHCSTFormStyle.FrmPaddingV,
			defaults: {border:false},    // Default config options for child items
			items:[{ 				
				columnWidth: 0.34,
	        	xtype: 'fieldset',
	        	items: [PhaLoc,Vendor]
				
			},{ 				
				columnWidth: 0.33,
	        	xtype: 'fieldset',
	        	items: [StartDate,EndDate]
				
			},{ 				
				columnWidth: 0.33,
				xtype: 'fieldset',
	        	items: [NotImp,PartlyImp]
				
			}]
		}]
	});

	// ҳ�沼��
	var mainPanel = new Ext.Viewport({
				layout : 'border',
					items : [            // create instance immediately
		            {
		                region: 'north',
		                height: DHCSTFormStyle.FrmHeight(2), // give north and south regions a height
		                layout: 'fit', // specify layout manager for items
		                items:HisListTab
		            }, {
		                region: 'west',
		                title: $g('����'),
		                collapsible: true,
		                split: true,
		                width: document.body.clientWidth*0.3, // give east and west regions a width
		                minSize: 175,
		                maxSize: 400,
		                margins: '0 5 0 0',
		                layout: 'fit', // specify layout manager for items
		                items: MasterGrid       
		               
		            }, {
		                region: 'center',
		                title: $g('������ϸ'),
		                layout: 'fit', // specify layout manager for items
		                items: DetailGrid       
		               
		            }
       			],
				renderTo : 'mainPanel'
			});
	//ҳ�������ɺ��Զ���������
	Query();
	
})
