// /����: ���ת���Ƶ�
// /����: ���ת���Ƶ�
// /��д�ߣ�zhangdongmei
// /��д����: 2012.07.18
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	//ȡ��������
	if(gParam==null ||gParam.length<1){			
		GetParam();		
	}
	if(gParamCommon.length<1){
		GetParamCommon();  //��ʼ��������������
	}
	var ProType=GetRecTransType();
	ChartInfoAddFun();
	function ChartInfoAddFun() {
		
	
		// ��������
		var SupplyPhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : $g('��������'),
					id : 'SupplyPhaLoc',
					name : 'SupplyPhaLoc',
					anchor:'90%',
					width : 120,
					emptyText : $g('��������...'),
					groupId:gGroupId,
		                     listeners : {
			                 'select' : function(e) {
                                      var SelLocId=Ext.getCmp('SupplyPhaLoc').getValue();//add wyx ����ѡ��Ŀ��Ҷ�̬��������
                                      StkGrpType.getStore().removeAll();
                                      StkGrpType.getStore().setBaseParam("locId",SelLocId)
                                      StkGrpType.getStore().setBaseParam("userId",userId)
                                      StkGrpType.getStore().setBaseParam("type",App_StkTypeCode)
                                      StkGrpType.getStore().load();
                                      GetParam(e.value);	//�޸Ĺ������Һ�,�Թ�����������Ϊ׼
                                      
			               }
	                        }
				});
		SupplyPhaLoc.on('change', function(e) {
	    Ext.getCmp("RequestPhaLoc").setValue("");
       });
        // ������
		var RequestPhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : $g('������'),
					id : 'RequestPhaLoc',
					name : 'RequestPhaLoc',
					anchor:'90%',
					width : 120,
					emptyText : $g('������...'),
					defaultLoc:{},
					relid:Ext.getCmp("SupplyPhaLoc").getValue(),
					protype:ProType,
					params : {relid:'SupplyPhaLoc'}
		});
		// ҩƷ����
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //��ʶ��������
			LocId:gLocId,
			UserId:userId,
			anchor:'90%',
			width : 200,
			fieldLabel : $g('�ࡡ����')
		}); 

		// ��������
		var OperateOutType = new Ext.ux.ComboBox({
			fieldLabel : $g('��������'),
			id : 'OperateOutType',
			name : 'OperateOutType',
			store : OperateOutTypeStore,
			valueField : 'RowId',
			displayField : 'Description'
		});
		OperateOutTypeStore.load();
		// Ĭ��ѡ�е�һ������
		OperateOutTypeStore.on('load', function() {
               setDefaultOutType();
		});
	  function setDefaultOutType()
	  {
		var operatecount=OperateOutTypeStore.getTotalCount();
		if (operatecount > 0){	
			var operatei=0;
			for (operatei = 0; operatei < operatecount; operatei++) {
				var defaultflag=OperateOutTypeStore.getAt(operatei).data.Default;
				if (defaultflag == "Y") {
					OperateOutType.setValue(OperateOutTypeStore.getAt(operatei).data.RowId);
				}
			}
			if (OperateOutType.getValue() == "") {  //û��Ĭ��Ĭ�ϵ�һ��
				OperateOutType.setValue(OperateOutTypeStore.getAt(0).data.RowId);
			}
		}
	  }
		// ת�Ƶ���
		var InItNo = new Ext.form.TextField({
					fieldLabel : $g('ת�Ƶ���'),
					id : 'InItNo',
					name : 'InItNo',
					anchor : '90%',
					width : 120,
					disabled : true
				});
			//=========ͳ�����=======		
		// ��ҳ����
		var NumAmount = new Ext.form.TextField({
					emptyText : $g('��ҳ����'),
					id : 'NumAmount',
					name : 'NumAmount',
					anchor : '90%',
					width:200
				});	
		// ���ۺϼ�
		var RpAmount = new Ext.form.TextField({
					emptyText : $g('���ۺϼ�'),
					id : 'RpAmount',
					name : 'RpAmount',
					width:200,
					anchor : '90%'
				});			
		// �ۼۺϼ�
		var SpAmount = new Ext.form.TextField({
					emptyText : $g('�ۼۺϼ�'),
					id : 'SpAmount',
					name : 'SpAmount',
					anchor : '90%',
					width:200
				});
		//zhangxiao20130815			
		function GetAmount(){
			var RpAmt=0
			var SpAmt=0
			var Count = DetailGrid.getStore().getCount();
			for (var i = 0; i < Count; i++) {
				var rowData = DetailStore.getAt(i);
				var RecQty = rowData.get("qty");
				var Rp = rowData.get("rp");
				var Sp = rowData.get("sp");
				var RpAmt1=accMul(Rp,RecQty);
				var SpAmt1=accMul(Sp,RecQty);
			    RpAmt=RpAmt+RpAmt1;
			    SpAmt=SpAmt+SpAmt1;
				}
			Count=$g("��ǰ����:")+" "+Count	
			RpAmt=$g("���ۺϼ�:")+" "+FormatGridRpAmount(RpAmt)+" "+$g("Ԫ")
			SpAmt=$g("�ۼۺϼ�:")+" "+FormatGridRpAmount(SpAmt)+" "+$g("Ԫ")
			Ext.getCmp("NumAmount").setValue(Count)	
			Ext.getCmp("RpAmount").setValue(RpAmt)	
			Ext.getCmp("SpAmount").setValue(SpAmt)	
			}		
		//=========ͳ�����=======	

		// ����
		var InItDate = new Ext.form.DateField({
					fieldLabel : $g('�Ƶ�����'),
					id : 'InItDate',
					name : 'InItDate',
					anchor : '90%',
					width : 120,
					value : new Date(),
					disabled : true
				});

		// ���
		var InItFlag = new Ext.form.Checkbox({
					fieldLabel : $g('�ꡡ����'),
					id : 'InItFlag',
					name : 'InItFlag',
					anchor : '90%',
					width : 120,
					checked : false,
					disabled : true
				});

		// ��ע
		var Remark = new Ext.form.TextField({
					fieldLabel : $g('������ע'),
					id : 'Remark',
					name : 'Remark',
					anchor : '90%',
					width : 120,
					disabled : false
				});

		//���󵥺�
		var ReqNo = new Ext.form.TextField({
					fieldLabel : $g('���󵥺�'),
					id : 'ReqNo',
					name : 'ReqNo',
					anchor : '90%',
					width : 120,
					disabled : true
				});
				
				//���󵥺�
		var ReqNoID = new Ext.form.TextField({
					fieldLabel : $g('���󵥺�ID'),
					id : 'ReqNoID',
					name : 'ReqNoID',
					anchor : '90%',
					width : 120,
					hidden:true,
					disabled : true
				});
				
		// ��ѯת�Ƶ���ť
		var SearchInItBT = new Ext.Toolbar.Button({
					id : "SearchInItBT",
					text : $g('��ѯ'),
					tooltip : $g('�����ѯת�Ƶ�'),
					width : 70,
					height : 30,
					iconCls : 'page_find',
					handler : function() {
						if(Ext.getCmp("SupplyPhaLoc").getValue()==""){
							Msg.info("warning",$g("�������Ų���Ϊ��!"));
							return;
						}
						StockTransferSearch(DetailStore,Query);
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
			SetLogInDept(SupplyPhaLoc.getStore(),'SupplyPhaLoc');
			Ext.getCmp("RequestPhaLoc").setValue("");
			Ext.getCmp("InItNo").setValue("");
			Ext.getCmp("InItDate").setValue(new Date());
			Ext.getCmp("Remark").setValue("");
			Ext.getCmp("InItFlag").setValue(0);
			Ext.getCmp("SupplyPhaLoc").setDisabled(0);
			Ext.getCmp("ReqNo").setValue("");
			Ext.getCmp("ReqNoID").setValue("");
			Ext.getCmp("StkGrpType").setDisabled(false);
			gInitId="";
			//=====zhangxiao20130816===
			Ext.getCmp("NumAmount").setValue("");
			Ext.getCmp("RpAmount").setValue("");
			Ext.getCmp("SpAmount").setValue("");
			//=====zhangxiao20130816===
			DetailGrid.store.removeAll();
			DetailGrid.getView().refresh();
			// �����ť�Ƿ����
			//��ѯ^���^�½�^����^ɾ��^���^ȡ�����
			changeButtonEnable("1^1^1^0^0^0^0");
		}

		// �½���ť
		var AddBT = new Ext.Toolbar.Button({
					id : "AddBT",
					text : $g('����һ��'),
					tooltip : $g('�������'),
					width : 70,
					height : 30,
					iconCls : 'page_add',
					handler : function() {
						if(gParam[7]=='Y'){
							Msg.info("warning",$g("ֻ�ܸ�������ת���Ƶ�,����������¼!"));
							return;
						}
						// �ж�ת�Ƶ��Ƿ������
						var initFlag = Ext.getCmp("InItFlag").getValue();
						if (initFlag != null && initFlag != 0) {
							Msg.info("warning", $g("ת�Ƶ�����ɲ����޸�!"));
							return;
						}

						var requestphaLoc = Ext.getCmp("RequestPhaLoc")
								.getValue();
						if (requestphaLoc == null || requestphaLoc.length <= 0) {
							Msg.info("warning", $g("��ѡ��������!"));
							return;
						}
						var supplyphaLoc = Ext.getCmp("SupplyPhaLoc")
								.getValue();
						if (supplyphaLoc == null || supplyphaLoc.length <= 0) {
							Msg.info("warning", $g("��ѡ��Ӧ����!"));
							return;
						}
						if (requestphaLoc == supplyphaLoc) {
							Msg.info("warning", $g("�����ź͹�Ӧ���Ų�����ͬ!"));
							return;
						}
		                var StkGrpType = Ext.getCmp("StkGrpType").getRawValue();			
                
                                          //var StkGrpType = Ext.getCmp("StkGrpType").getValue();
                        if ((StkGrpType == null || StkGrpType.length <= 0)&(gParamCommon[9]=="N")) {
			            	Msg.info("warning", $g("��ѡ������!"));
			                return;
			            }
						var operatetype = Ext.getCmp("OperateOutType")
								.getValue();
						if (operatetype == null || operatetype.length <= 0) {
							Msg.info("warning", $g("��ѡ���������!"));
							return;
						}

						// �ж��Ƿ��Ѿ��������
						var rowCount = DetailGrid.getStore().getCount();
						if (rowCount > 0) {
							var rowData = DetailStore.data.items[rowCount - 1];
							var data = rowData.get("inci");	//initi --> inci
							if (data == null || data.length <= 0) {
								//Msg.info("warning", "�Ѵ����½���!");
								DetailGrid.startEditing(DetailStore.getCount() - 1, 4);
								return;
							}
						}
						Ext.getCmp("StkGrpType").setDisabled(true);
						// ����һ��
						addNewRow();
						//��ѯ^���^�½�^����^ɾ��^���^ȡ�����
						changeButtonEnable("1^1^1^1^1^1^0");
					}
				});
		/**
		 * ����һ��
		 */
		function addNewRow() {
			// �ж��Ƿ��Ѿ��������
			var rowCount = DetailGrid.getStore().getCount();
			if (rowCount > 0) {
				var rowData = DetailStore.data.items[rowCount - 1];
				var data = rowData.get("inci");
				if (data == null || data.length <= 0) {
					var colindex=GetColIndex(DetailGrid,"inciDesc");
					DetailGrid.startEditing(DetailStore.getCount() - 1, colindex);
					return;
				}
			}
			var record = Ext.data.Record.create([{
						name : 'initi',
						type : 'string'
					}, {
						name : 'inrqi',
						type : 'string'
					}, {
						name : 'inci',
						type : 'string'
					}, {
						name : 'inciCode',
						type : 'string'
					}, {
						name : 'inciDesc',
						type : 'string'
					}, {
						name : 'inclb',
						type : 'string'
					}, {
						name : 'batexp',
						type : 'string'
					}, {
						name : 'manfName',
						type : 'string'
					}, {
						name : 'inclbQty',
						type : 'double'
					}, {
						name : 'qty',
						type : 'double'
					}, {
						name : 'uom',
						type : 'string'
					}, {
						name : 'sp',
						type : 'double'
					}, {
						name : 'reqQty',
						type : 'double'
					}, {
						name : 'stkbin',
						type : 'string'
					}, {
						name : 'reqLocStkQty',
						type : 'double'
					}, {
						name : 'spec',
						type : 'string'
					}, {
						name : 'gene',
						type : 'string'
					}, {
						name : 'formDesc',
						type : 'string'
					}, {
						name : 'spAmt',
						type : 'double'
					}, {
						name : 'rp',
						type : 'double'
					}, {
						name : 'ConFac',
						type : 'double'
					}, {
						name : 'BUomId',
						type : 'string'
					}, {
						name : 'inclbDirtyQty',
						type : 'double'
					}, {
						name : 'dirtyQty',
						type : 'double'
					},{
						name : 'inclbAvaQty',
						type : 'double'
					}, {
						name : 'remark',
						type : 'string'
					}, {
						name : 'InsuCode',
						type : 'string'
					}, {
						name : 'InsuDesc',
						type : 'string'
					}
					
					]);
			var NewRecord = new record({
						initi : '',
						inrqi : '',
						inci : '',
						inciCode : '',
						inciDesc : '',
						inclb : '',
						batexp : '',
						manfName : '',
						inclbQty : '',
						qty : '',
						uom : '',
						sp : '',
						reqQty : '',
						stkbin : '',
						reqLocStkQty : '',
						spec : '',
						gene : '',
						formDesc : '',
						spAmt : '',
						rp : '',
						ConFac : 0,
						BUomId : '',
						dirtyQty:0,
						inclbDirtyQty : '',
						inclbAvaQty : '',
						remark : '',
						InsuCode:'',
						InsuDesc:''
					});
			DetailStore.add(NewRecord);
			var colindex=GetColIndex(DetailGrid,"inciDesc");
			DetailGrid.getSelectionModel().select(DetailStore.getCount() - 1, colindex);
			DetailGrid.startEditing(DetailStore.getCount() - 1, colindex);
			changeElementEnable();
		};

		// ���水ť
		var SaveBT = new Ext.Toolbar.Button({
					id : "SaveBT",
					text : $g('����'),
					tooltip : $g('�������'),
					width : 70,
					height : 30,
					iconCls : 'page_save',
					handler : function() {
						Ext.getCmp("SaveBT").disable();
						setTimeout(ChangeSaveBtn,3000);//�����ִ��
						if(gParam[7]=='Y'){
							Msg.info("warning",$g("ֻ�ܸ�������ת���Ƶ�,���ɱ����¼�¼!"));
							return;
						}
						if(DetailGrid.activeEditor != null){
							DetailGrid.activeEditor.completeEdit();
						}
						// ����ת�Ƶ�
						if(CheckDataBeforeSave()==true){
							saveOrder();
							// �����ť�Ƿ����
							//��ѯ^���^�½�^����^ɾ��^���^ȡ�����
							//changeButtonEnable("1^1^1^1^1^1^0");
						}
					}
				});
		function ChangeSaveBtn()
		{
			Ext.getCmp("SaveBT").enable();
		}		
		/**
		 * ������ⵥǰ���ݼ��
		 */		
		function CheckDataBeforeSave() {
					
			// �ж�ת�Ƶ��Ƿ������
			var initFlag = Ext.getCmp("InItFlag").getValue();
			if (initFlag != null && initFlag != 0) {
				Msg.info("warning", $g("ת�Ƶ�����ɲ����޸�!"));
				return false;
			}

			var requestphaLoc = Ext.getCmp("RequestPhaLoc")
					.getValue();
			if (requestphaLoc == null || requestphaLoc.length <= 0) {
				Msg.info("warning", $g("��ѡ��������!"));
				return false;
			}
			var supplyphaLoc = Ext.getCmp("SupplyPhaLoc")
					.getValue();
			if (supplyphaLoc == null || supplyphaLoc.length <= 0) {
				Msg.info("warning", $g("��ѡ��Ӧ����!"));
				return false;
			}
			if (requestphaLoc == supplyphaLoc) {
				Msg.info("warning", $g("�����ź͹�Ӧ���Ų�����ͬ!"));
				return false;
			}
		       var StkGrpType = Ext.getCmp("StkGrpType").getRawValue();			
                
                     //var StkGrpType = Ext.getCmp("StkGrpType").getValue();
                      if ((StkGrpType == null || StkGrpType.length <= 0)&(gParamCommon[9]=="N")) {
			   Msg.info("warning", $g("��ѡ������!"));
			    return;
			  }
			var operatetype = Ext.getCmp("OperateOutType")
					.getValue();
			if (operatetype == null || operatetype.length <= 0) {
				Msg.info("warning", $g("��ѡ���������!"));
				return false;
			}
			// 1.�ж�ת��ҩƷ�Ƿ�Ϊ��
			var rowCount = DetailGrid.getStore().getCount();
			// ��Ч����
			var count = 0;
			for (var i = 0; i < rowCount; i++) {
				var item = DetailStore.getAt(i).get("inci");
				if (item != undefined) {
					count++;
				}
			}
			if (rowCount <= 0 || count <= 0) {
				Msg.info("warning", $g("������ת����ϸ!"));
				return false;
			}
			// 2.������䱳��
			for (var i = 0; i < rowCount; i++) {
				changeBgColor(i, "white");
			}
			// 3.�ж��ظ��������ο��ҩƷ
			for (var i = 0; i < rowCount - 1; i++) {
				for (var j = i + 1; j < rowCount; j++) {
					var item_i = DetailStore.getAt(i).get("inclb");;
					var item_j = DetailStore.getAt(j).get("inclb");;
					if (item_i != undefined && item_j != undefined
							&& item_i == item_j) {
						changeBgColor(i, "yellow");
						changeBgColor(j, "yellow");
						Msg.info("warning", $g("ҩƷ�����ظ�������������!"));
						return false;
					}
				}
			}
			// 4.ҩƷ��Ϣ�������
			var rowCount = DetailGrid.getStore().getCount();
			for (var i = 0; i < rowCount; i++) {
				var rowData = DetailStore.getAt(i);
				var code = rowData.get("inciCode");
				if (code == null || code.length == 0) {
					continue;
				}
				var item = rowData.get("inci");
				if (item == undefined) {
					Msg.info("warning", $g("ҩƷ��Ϣ�������!"));
					DetailGrid.getSelectionModel().select(i, 1);
					changeBgColor(i, "yellow");
					return false;
				}
				var qty = DetailStore.getAt(i).get("qty");
				if ((item != undefined) && (qty == null || qty <= 0)) {
					Msg.info("warning", $g("ת����������С�ڻ����0!"));
					DetailGrid.getSelectionModel().select(i, 1);
					changeBgColor(i, "yellow");
					return false;
				}
				var initi = DetailStore.getAt(i).get("initi") || '';
				var avaQty = DetailStore.getAt(i).get("inclbAvaQty");
				var dirtyQty=DetailStore.getAt(i).get("dirtyQty");    //����ռ������
				var inclbQty=DetailStore.getAt(i).get("inclbQty");    //��������
				var inclbDirtyQty=DetailStore.getAt(i).get("inclbDirtyQty");    //ռ������
				var NewAvaQty=inclbQty-(inclbDirtyQty-dirtyQty)
				//alert(initi+"^"+qty+"^"+NewAvaQty)
				if ((item != undefined) && ( (initi==""&&(qty - avaQty-dirtyQty) > 0)) ||(initi!=""&&(qty-NewAvaQty)>0)) {
					Msg.info("warning", $g("ת���������ܴ��ڿ��ÿ������!"));
					DetailGrid.getSelectionModel().select(i, 1);
					changeBgColor(i, "yellow");
					return false;
				}
				
				//����ת�������Ƿ�����С���ж� 2020-02-20 yangsj
                if(gParam[11]!="Y")  //Y ����¼��С��
                {
	                
                    var buomId=rowData.get("BUomId")
                    var uom=rowData.get("uom")
                    var buomQty=qty
                    if(buomId!=uom)
                    {
                        var fac=rowData.get("ConFac")
                        buomQty=Number(fac).mul(qty);
                    }
                    if((buomQty.toString()).indexOf(".")>=0)
                    {
	                    Msg.info("warning", rowData.get("inciDesc")+$g(" ת����������ɻ�����λ֮�����С��������ת�Ƴ��⣡��˶�ת�Ƴ������ã�ת����������Ϊ������λ�Ƿ�����С��!"));
	                    return;
                    }
                    
                }
				
			}
			
			return true;
		}
		

		/**
		 * ����ת�Ƶ�
		 */
		function saveOrder() {
			//��Ӧ����RowId^�������RowId^���ת������RowId^��������RowId^��ɱ�־^����״̬^�Ƶ���RowId^����RowId^�������^��ע
			var inItNo = Ext.getCmp("InItNo").getValue();
			var supplyPhaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
			var requestPhaLoc = Ext.getCmp("RequestPhaLoc").getValue();
			var reqid=Ext.getCmp("ReqNoID").getValue();
			//alert(reqid)
			var operatetype = Ext.getCmp("OperateOutType").getValue();	
			var Complete='N';
			var Status=10;
			var StkGrpId = Ext.getCmp("StkGrpType").getValue();
			var StkType = App_StkTypeCode;					
			var remark = Ext.getCmp("Remark").getValue();
		//alert(remark)	
			var MainInfo = supplyPhaLoc + "^" + requestPhaLoc + "^" + reqid + "^" + operatetype + "^"
					+ Complete + "^" + Status + "^" + userId + "^"+StkGrpId+"^"+StkType+"^"+remark;
			//��ϸid^����id^����^��λ^������ϸid^��ע
			var ListDetail="";
			var rowCount = DetailGrid.getStore().getCount();
			for (var i = 0; i < rowCount; i++) {
				var rowData = DetailStore.getAt(i);	
				//���������ݷ����仯ʱִ����������

				if(rowData.data.newRecord || rowData.dirty){
					var Initi = rowData.get("initi");
					var Inclb = rowData.get("inclb");
					if((Inclb!="")&&(Inclb!=null)){
						var Qty = rowData.get("qty");
						var UomId = rowData.get("uom");
						var ReqItmId = rowData.get("inrqi");
						var Remark = rowData.get("remark");
					
						var str = Initi + "^" + Inclb + "^"	+ Qty + "^" + UomId + "^"
								+ ReqItmId + "^" + Remark;	
						if(ListDetail==""){
							ListDetail=str;
						}
						else{
							ListDetail=ListDetail+xRowDelim()+str;
						}
					}
				}
			}
			if ((gInitId=="")&&(ListDetail==""))
			{
					Msg.info("warning",$g("û����Ҫ���������!"));
					return false;
			}
			if(!IsFormChanged(HisListTab) && (ListDetail=="")){
				Msg.info("warning",$g("û����Ҫ���������!"));
				return false;
			}
			var url = DictUrl
					+ "dhcinistrfaction.csp?actiontype=Save";
			var loadMask=ShowLoadMask(Ext.getBody(),$g("������..."));
			Ext.Ajax.request({
						url : url,
						params:{Rowid:gInitId,MainInfo:MainInfo,ListDetail:ListDetail},
						method : 'POST',
						waitMsg : $g('������...'),
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								// ˢ�½���
								var InitRowid = jsonData.info;
								Msg.info("success", $g("����ɹ�!"));
								// 7.��ʾ���ⵥ����
								Query(InitRowid);
								//���ݲ��������Զ���ӡ
								if(gParam[3]=='Y'){
									PrintInIsTrf(InitRowid,gParam[8]);
								}
							} else {
								var ret=jsonData.info;								
								Msg.info("error", $g("���治�ɹ���")+ret);								
							}
						},
						scope : this
					});
			loadMask.hide();
		}

		// ɾ����ť
		var DeleteBT = new Ext.Toolbar.Button({
					id : "DeleteBT",
					text : $g('ɾ��'),
					tooltip : $g('���ɾ��'),
					width : 70,
					height : 30,
					iconCls : 'page_delete',
					disabled : true,
					handler : function() {
						deleteData();
					}
				});

		function deleteData() {
			// �ж�ת�Ƶ��Ƿ������
			var inItFlag = Ext.getCmp("InItFlag").getValue();
			if (inItFlag != null && inItFlag != 0) {
				Msg.info("warning", $g("ת�Ƶ�����ɲ���ɾ��!"));
				return;
			}

			var inItNo = Ext.getCmp("InItNo").getValue();
			if (inItNo == null || inItNo.length <= 0) {
				Msg.info("warning", $g("û����Ҫɾ����ת�Ƶ�!"));
				return;
			}

			Ext.MessageBox.show({
						title : $g('��ʾ'),
						msg : $g('�Ƿ�ȷ��ɾ������ת�Ƶ�?'),
						buttons : Ext.MessageBox.YESNO,
						fn : showDeleteIt,
						icon : Ext.MessageBox.QUESTION
					});

		}

		/**
		 * ɾ��ת�Ƶ���ʾ
		 */
		function showDeleteIt(btn) {
			if (btn == "yes") {
				var inItNo = Ext.getCmp("InItNo").getValue();
				var url = DictUrl
						+ "dhcinistrfaction.csp?actiontype=Delete&Rowid="
						+ gInitId;

				Ext.Ajax.request({
							url : url,
							method : 'POST',
							waitMsg : $g('��ѯ��...'),
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == 'true') {
									// ɾ������
									Msg.info("success", $g("ת�Ƶ�ɾ���ɹ�!"));
									clearData();
								} else {
									Msg.info("error", $g("ת�Ƶ�ɾ��ʧ��:")+jsonData.info);
								}
							},
							scope : this
						});
			}
		}

		/**
		 * ɾ��ѡ����ҩƷ
		 */
		function deleteDetail() {
			// �ж�ת�Ƶ��Ƿ������
			var inItFlag = Ext.getCmp("InItFlag").getValue();
			if (inItFlag != null && inItFlag != 0) {
				Msg.info("warning", $g("ת�Ƶ�����ɲ���ɾ��!"));
				return;
			}
			var cell = DetailGrid.getSelectionModel().getSelectedCell();
			if (cell == null) {
				Msg.info("warning", $g("û��ѡ����!"));
				return;
			}
			// ѡ����
			var row = cell[0];
			var record = DetailGrid.getStore().getAt(row);
			var InItIRowId = record.get("initi");
			if (InItIRowId == null || InItIRowId.length <= 0) {
				DetailGrid.getStore().remove(record);
				DetailGrid.getView().refresh();
				changeElementEnable();
				GetAmount();
			} else {
				Ext.MessageBox.show({
							title : $g('��ʾ'),
							msg :$g( '�Ƿ�ȷ��ɾ����ҩƷ��Ϣ?'),
							buttons : Ext.MessageBox.YESNO,
							fn : showResult,
							icon : Ext.MessageBox.QUESTION
						});
			}
		}
		/**
		 * ɾ����ʾ
		 */
		function showResult(btn) {
			if (btn == "yes") {
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				var row = cell[0];
				var record = DetailGrid.getStore().getAt(row);
				var InItIRowId = record.get("initi");
				
				// ɾ����������
				var url = DictUrl
						+ "dhcinistrfaction.csp?actiontype=DeleteDetail&RowId="
						+ InItIRowId ;

				Ext.Ajax.request({
							url : url,
							method : 'POST',
							waitMsg : $g('��ѯ��...'),
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == 'true') {
									Msg.info("success", $g("ɾ���ɹ�!"));
									DetailGrid.getStore().remove(record);
									DetailGrid.getView().refresh();
									changeElementEnable();
									GetAmount();
								} else {
									Msg.info("error", $g("ɾ��ʧ��!"));
								}
							},
							scope : this
						});
			}
		}

		// ��ɰ�ť
		var CheckBT = new Ext.Toolbar.Button({
					id : "CheckBT",
					text : $g('���'),
					tooltip : $g('������'),
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					disabled : true,
					handler : function() {
						var InItFlag = Ext.getCmp('InItFlag').getValue();
			            var mod = isDataChanged();
			            if (mod && (!InItFlag)) {
			                Ext.Msg.confirm($g('��ʾ'), $g('�����ѷ����ı�,�Ƿ���Ҫ��������?'),
			                    function(btn) {
			                        if (btn == 'yes') {
			                            return;
			                        } else {
			                            Complete();
			                        }

			                    }, this);
			            } else {
			                Complete();
			            }
					}
				});

		function isDataChanged() {
	        var changed = false;
	        var count1 = DetailGrid.getStore().getCount();
	        //�����������Ƿ����޸�
	        //�޸�Ϊ�������޸����ӱ�������ʱ������ʾ
	        if ((IsFormChanged(HisListTab)) && (count1 != 0)) {
	            changed = true;
	        };
	        if (changed) return changed;
	        //����ϸ�����Ƿ����޸�
	        var count = DetailGrid.getStore().getCount();
	        for (var index = 0; index < count; index++) {
	            var rec = DetailGrid.getStore().getAt(index);
	            //���������ݷ����仯ʱִ����������
	            if (rec.data.newRecord || rec.dirty) {
	                changed = true;
	            }
	        }
	        return changed;
	    }
	    
		/**
		 * ���ת�Ƶ�
		 */
		function Complete() {
			// �ж�ת�Ƶ��Ƿ������
			var inItFlag = Ext.getCmp("InItFlag").getValue();
			if (inItFlag != null && inItFlag != 0) {
				Msg.info("warning", $g("ת�Ƶ������!"));
				return;
			}
			
			if (gInitId=='') {
				Msg.info("warning", $g("û����Ҫ��ɵ�ת�Ƶ�!"));
				return;
			}
			var rowCount = DetailGrid.getStore().getCount();
			if (rowCount<1){
				Msg.info('warning',$g('ת�Ƶ���ϸ������,�������!'));
				return;
			}
			var StkGrpType = Ext.getCmp("StkGrpType").getRawValue();			
			//var StkGrpType = Ext.getCmp("StkGrpType").getValue();
			if ((StkGrpType == null || StkGrpType.length <= 0)&(gParamCommon[9]=="N")) {
				Msg.info("warning", $g("��ѡ������!"));
				return;
			}
			var operatetype = Ext.getCmp("OperateOutType")
								.getValue();
		    if (operatetype == null || operatetype.length <= 0) {
							Msg.info("warning", $g("��ѡ���������!"));
							return;
						}
			var url = DictUrl
					+ 'dhcinistrfaction.csp?actiontype=MakeComplete&Rowid='
					+ gInitId+'&Status=11&Complete=Y&Type='+operatetype;

			Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : $g('��ѯ��...'),
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								// ��˵���
								Msg.info("success", $g("�ɹ�!"));
								Ext.getCmp("InItFlag").setValue(1);
								
								//��ѯ^���^�½�^����^ɾ��^���^ȡ�����
								changeButtonEnable("1^1^0^0^0^0^1");
							} else {
								Msg.info("error", $g("ʧ��:")+jsonData.info);
							}
						},
						scope : this
					});
		}

		// ȡ����ɰ�ť
		var CancelCmpBT = new Ext.Toolbar.Button({
					id : "CancelCmpBT",
					text : $g('ȡ�����'),
					tooltip : $g('���ȡ�����'),
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					disabled : true,
					handler : function() {
						CancelComplete();
					}
				});
		/**
		 * ȡ�����ת�Ƶ�
		 */
		function CancelComplete() {
			// �ж�ת�Ƶ��Ƿ������
			var inItFlag = Ext.getCmp("InItFlag").getValue();
			if (inItFlag != null && inItFlag != 1) {
				Msg.info("warning",$g( "ת�Ƶ���δ���!"));
				return;
			}
			
			if (gInitId=='') {
				Msg.info("warning", $g("û����Ҫȡ����ɵ�ת�Ƶ�!"));
				return;
			}
			var operatetype = Ext.getCmp("OperateOutType")
								.getValue();
		    if (operatetype == null || operatetype.length <= 0) {
							Msg.info("warning", $g("��ѡ���������!"));
							return;
						}
			var url = DictUrl
					+ 'dhcinistrfaction.csp?actiontype=MakeComplete&Rowid='
					+ gInitId+'&Status=10&Complete=N'+'&Type='+operatetype;

			Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : $g('��ѯ��...'),
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								// ��˵���
								Msg.info("success", $g("�ɹ�!"));
								Ext.getCmp("InItFlag").setValue(0);
								
								//��ѯ^���^�½�^����^ɾ��^���^ȡ�����
								changeButtonEnable("1^1^1^1^1^1^0");
								
							} else {
								Msg.info("error", $g("ʧ�ܣ�")+jsonData.info);
							}
						},
						scope : this
					});
		}

		// ɾ����ϸ
		var DeleteDetailBT = new Ext.Toolbar.Button({
					id : "DeleteDetailBT",
					text : $g('ɾ��һ��'),
					tooltip : $g('���ɾ��'),
					width : 70,
					height : 30,
					iconCls : 'page_delete',
					//disabled : true,
					handler : function() {
						deleteDetail();
					}
		});
		
		// ���󵥰�ť
		var SelReqBT = new Ext.Toolbar.Button({
				id : "SelReqBT",
				text : $g('ѡȡ����'),
				tooltip : $g('�����ѯ����'),
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					var FrLoc=Ext.getCmp("SupplyPhaLoc").getValue();
					if(FrLoc==null){
						Msg.info("warning",$g("��ѡ��Ӧ����!"))
						return;
					}
					SelReq(FrLoc,Query);
				}
		});
		
		// ��ӡ��ť
		var PrintBT = new Ext.Toolbar.Button({
					text : $g('��ӡ'),
					tooltip : $g('�����ӡ'),
					width : 70,
					height : 30,
					iconCls : 'page_print',
					handler : function() {
						if (gInitId ==null || gInitId=="") {
							Msg.info("warning", $g("û����Ҫ��ӡ��ת�Ƶ�!"));
							return;
						}
						PrintInIsTrf(gInitId,gParam[8]);
					}
				});
				
		// ��λ
		var CTUom = new Ext.form.ComboBox({
					fieldLabel : $g('��λ'),
					id : 'CTUom',
					name : 'CTUom',
					anchor : '90%',
					width : 120,
					store : CTUomStore,
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

		// ��ʾ���ⵥ����
		function Query(InitRowid) {
			if (InitRowid == null || InitRowid =='') {
				return;
			}
			var url = DictUrl
					+ "dhcinistrfaction.csp?actiontype=Select&Rowid="
					+ InitRowid;
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : $g('��ѯ��...'),
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								var list = jsonData.info.split("^");
								//alert("jsonData.info="+jsonData.info)
								if (list.length > 0) {
									gInitId=InitRowid;
									Ext.getCmp("InItNo").setValue(list[8]);
									addComboData(SupplyPhaLoc.getStore(),list[6],list[26]);
									Ext.getCmp("SupplyPhaLoc").setValue(list[6]);
									addComboData(RequestPhaLoc.getStore(),list[12],list[27]);
									Ext.getCmp("RequestPhaLoc").setValue(list[12]);
								    //OperateOutTypeStore.load();
								    addComboData(OperateOutType.getStore(),list[21],list[33]);
									Ext.getCmp("OperateOutType").setValue(list[21]);
									Ext.getCmp("StkGrpType").setValue(list[24]);
									Ext.getCmp("InItDate").setValue(list[29]);	
									Ext.getCmp("InItFlag").setValue(list[14]=='Y'?true:false);
									Ext.getCmp("Remark").setValue(list[9]);
									Ext.getCmp("ReqNo").setValue(list[28]);	
									Ext.getCmp("ReqNoID").setValue(list[30]);	
										
									// �����ť�Ƿ����
									//��ѯ^���^����^����^ɾ��^���^ȡ�����
									var CompFlag =list[14];
									if(CompFlag=="Y"){
										changeButtonEnable("1^1^0^0^0^0^1");
									}else{
										changeButtonEnable("1^1^1^1^1^1^0");
									}
									// ��ʾ��ⵥ��ϸ����
									getDetail(InitRowid);
								}
							} else {
								Msg.info("warning", jsonData.info);
							}
							SetFormOriginal(HisListTab);
						},
						scope : this
					});				
		}
		// ��ʾ���ⵥ��ϸ����
		function getDetail(InitRowid) {
			if (InitRowid == null || InitRowid=='') {
				return;
			}
			DetailStore.removeAll();
			DetailStore.load({params:{start:0,limit:999,Parref:InitRowid}});
		}
	
		// ת����ϸ
		// ����·��
		var DetailUrl =DictUrl+
		'dhcinistrfaction.csp?actiontype=QueryInIsTrfDetail&Parref=&start=0&limit=999';
			//'dhcinistrfaction.csp?actiontype=QueryDetail&Parref=&start=0&limit=999';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : DetailUrl,
					method : "POST"
				});
		
		// ָ���в���
		var fields = ["initi", "inrqi", "inci","inciCode",
				"inciDesc", "inclb", "batexp", "manf","manfName",
				 "qty", "uom", "sp","status","remark",
				"reqQty", "inclbQty", "reqLocStkQty", "stkbin",
				"pp", "spec", "gene", "formDesc","newSp",
				"spAmt", "rp","rpAmt", "ConFac", "BUomId", 
				"inclbDirtyQty", "inclbAvaQty","TrUomDesc","dirtyQty","InsuCode",
				"InsuDesc"
				];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "initi",
					fields : fields
				});
		// ���ݼ�
		var DetailStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader
				});
		DetailStore.on('load', function() {
              changeElementEnable();
		});
		var nm = new Ext.grid.RowNumberer();
		var DetailCm = new Ext.grid.ColumnModel([nm, {
					header : $g("ת��ϸ��RowId"),
					dataIndex : 'initi',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : $g("ҩƷRowId"),
					dataIndex : 'inci',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : $g('ҩƷ����'),
					dataIndex : 'inciCode',
					width : 80,
					align : 'left',
					sortable : true,
					editor : new Ext.form.TextField({
						selectOnFocus : true,
						allowBlank : false,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									// �ж�ת�Ƶ��Ƿ������
									var initFlag = Ext.getCmp("InItFlag")
											.getValue();
									if (initFlag != null && initFlag != 0) {
										Msg.info("warning", $g("ת�Ƶ�����ɲ����޸�!"));
										return;
									}

									var stkgrp = Ext.getCmp("StkGrpType")
											.getValue();
									GetPhaOrderInfo(field.getValue(), stkgrp);
								}
							}
						}
					})
				}, {
					header : $g('ҩƷ����'),
					dataIndex : 'inciDesc',
					width : 230,
					align : 'left',
					sortable : true,
					editor : new Ext.form.TextField({
						selectOnFocus : true,
						allowBlank : false,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									// �ж�ת�Ƶ��Ƿ������
									var initFlag = Ext.getCmp("InItFlag")
											.getValue();
									if (initFlag != null && initFlag != 0) {
										Msg.info("warning", $g("ת�Ƶ�����ɲ����޸�!"));
										return;
									}

									var stkgrp = Ext.getCmp("StkGrpType")
											.getValue();
									GetPhaOrderInfo(field.getValue(), stkgrp);
								}
							}
						}
					})
				}, {
					header : $g("����RowId"),
					dataIndex : 'inclb',
					width : 180,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : $g("����/Ч��"),
					dataIndex : 'batexp',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : $g("������ҵ"),
					dataIndex : 'manfName',
					width : 180,
					align : 'left',
					sortable : true
				}, {
					header : $g("��������"),
					dataIndex : 'inclbAvaQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : $g("ת������"),
					dataIndex : 'qty',
					width : 80,
					align : 'right',
					sortable : true,
					editor : new Ext.ux.NumberField({
						selectOnFocus : true,
						formatType:'FmtSQ',
						allowBlank : false,
						allowNegative: false, 
						listeners : {
							specialkey : function(field, e) {
								var rowCount = DetailGrid.getStore().getCount();
								if (e.getKey() == Ext.EventObject.ENTER) {
									// �ж�ת�Ƶ��Ƿ������
									var inItFlag = Ext.getCmp("InItFlag").getValue();
									if (inItFlag != null && inItFlag != 0) {
										Msg.info("warning", $g("ת�Ƶ�����ɲ����޸�!"));
										return;
									}
									var qty = field.getValue();
									if (qty == null || qty.length <= 0) {
										Msg.info("warning", $g("ת����������Ϊ��!"));
										return;
									}
									if (qty <= 0) {
										Msg.info("warning",$g( "ת����������С�ڻ����0!"));
										return;
									}
									var cell = DetailGrid.getSelectionModel().getSelectedCell();
									var record = DetailGrid.getStore().getAt(cell[0]);
									var salePriceAMT = accMul(record.get("sp"),qty);
									record.set("spAmt",	salePriceAMT);
									var AvaQty = record.get("inclbAvaQty");
									
									var initi = record.get("initi") || '';
									var dirtyQty=record.get("dirtyQty");    //����ռ������
									var inclbQty=record.get("inclbQty");    //��������
									var inclbDirtyQty=record.get("inclbDirtyQty");    //��ռ����
									var NewAvaQty=inclbQty-(inclbDirtyQty-dirtyQty)
									//alert(initi+"^"+qty+"^"+NewAvaQty)
									
									if ((initi==""&&qty > AvaQty)||(initi!=""&&qty>NewAvaQty)) {
										Msg.info("warning", $g("ת���������ܴ��ڿ��ÿ������!"));
										return;
									}
									
									//����ת�������Ƿ�����С���ж� 2020-02-20 yangsj
		                            if(gParam[11]!="Y")  //"Y" ����¼��С��
		                            {
			                            var buomId=record.get("BUomId")
			                            var uom=record.get("uom")
			                            var buomQty=qty
			                            if(buomId!=uom)
			                            {
				                            var fac=record.get("ConFac")
				                            buomQty=Number(fac).mul(qty);
			                            }
			                            if((buomQty.toString()).indexOf(".")>=0)
			                            {
				                            Msg.info("warning", $g("ת����������ɻ�����λ֮�����С��������ת�Ƴ��⣡��˶�ת�Ƴ������ã�ת����������Ϊ������λ�Ƿ�����С��!"));
			                                return;
			                            }
			                            
		                            }
									
									
									// ����һ��
									addNewRow();
									GetAmount();
								}
								if(e.getKey()==Ext.EventObject.UP){  //yunhaibao,20160420
									if(event.keyCode==38){
										if(event.preventDefault){event.preventDefault();}
										else {event.keyCode=38;} 
									}
									var inItFlag = Ext.getCmp("InItFlag").getValue();
									if (inItFlag != null && inItFlag != 0) {
										Msg.info("warning", $g("ת�Ƶ�����ɲ����޸�!"));
										return;
									}
									var cell = DetailGrid.getSelectionModel().getSelectedCell();
                                    var row=cell[0]-1;
									var col=GetColIndex(DetailGrid,"qty");
                                    if(row>=0){
                                        DetailGrid.getSelectionModel().select(row,col);
                                        DetailGrid.startEditing(row,col);
                                    }
                                }
						
                                if(e.getKey()==Ext.EventObject.DOWN){
									if(event.keyCode==40){
										if(event.preventDefault){event.preventDefault();}
										else {event.keyCode=40;} 
									}
									var inItFlag = Ext.getCmp("InItFlag").getValue();
									if (inItFlag != null && inItFlag != 0) {
										Msg.info("warning",$g( "ת�Ƶ�����ɲ����޸�!"));
										return;
									}
									var cell = DetailGrid.getSelectionModel().getSelectedCell();
                                    var row=cell[0]+1;
									var col=GetColIndex(DetailGrid,"qty");
                                    if(row<rowCount){
                                        DetailGrid.getSelectionModel().select(row,col);
                                        DetailGrid.startEditing(row,col);
                                    }
                                }
							}
						}
					})
				}, {
					header : $g("ת�Ƶ�λ"),
					dataIndex : 'uom',
					width : 80,
					align : 'left',
					sortable : true,
					renderer : Ext.util.Format.comboRenderer2(CTUom,"uom","TrUomDesc"), // pass combo instance to reusable renderer					
					editor : new Ext.grid.GridEditor(CTUom)
				}, {
					header :$g("����"),
					dataIndex : 'rp',
					width : 60,
					align : 'right',
					
					sortable : true
				}, {
					header : $g("�ۼ�"),
					dataIndex : 'sp',
					width : 60,
					align : 'right',
					
					sortable : true
				}, {
					header : $g("��������"),
					dataIndex : 'reqQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : $g("��λ��"),
					dataIndex : 'stkbin',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : $g("���󷽿��"),
					dataIndex : 'reqLocStkQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : $g("���ο��"),
					dataIndex : 'inclbQty',
					width : 90,
					align : 'right',
					sortable : true
				}, {
					header : $g("����ռ������"),
					dataIndex : 'dirtyQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : $g("ռ������"),
					dataIndex : 'inclbDirtyQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : $g("�����ۼ�"),
					dataIndex : 'newSp',
					width : 100,
					align : 'right',
					hidden:true,
					sortable : true
				}, {
					header : $g("���"),
					dataIndex : 'spec',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : $g("����ͨ����"),
					dataIndex : 'gene',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : $g("����"),
					dataIndex : 'formDesc',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : $g("�ۼ۽��"),
					dataIndex : 'spAmt',
					width : 100,
					align : 'right',					
					sortable : true,
        			renderer:FormatGridSpAmount
				}, {
					header : $g("ת����"),
					dataIndex : 'ConFac',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header :$g( "������λ"),
					dataIndex : 'BUomId',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header :$g( "ת�������ӱ�RowId"),
					dataIndex : 'inrqi',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header :$g( "����ҽ������"),
					dataIndex : 'InsuCode',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header :$g( "����ҽ������"),
					dataIndex : 'InsuDesc',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : true
				}
				
				 ]);
		var GridColSetBT = new Ext.Toolbar.Button({
			text:$g('������'),
			tooltip:$g('������'),
			iconCls:'page_gear',
			handler:function(){
			GridColSet(DetailGrid,"DHCSTTRANSFER");
			}
		});
		var DetailGrid = new Ext.grid.EditorGridPanel({
					id : 'DetailGrid',
					title:$g('���ת�Ƶ�'),
					tbar:[AddBT,'-',DeleteDetailBT,'-',GridColSetBT],
					region : 'center',
					cm : DetailCm,
					store : DetailStore,
					trackMouseOver : true,
					stripeRows : true,
					loadMask : true,
					sm : new Ext.grid.CellSelectionModel({}),
					bbar:new Ext.Toolbar({items:[NumAmount,RpAmount,SpAmount]}),
					clicksToEdit : 1
				});
		 DetailGrid.getView().on('refresh',function(Grid){
			GetAmount();
			})
		DetailGrid.on('afteredit',function(e){    //yunhaibao,�������¼��޸�������֤����������
			if(e.field=="qty"){
				/*if (e.value == null || e.value.length <= 0) {
					Msg.info("warning", "ת����������Ϊ��!");
					return;
				}
				if (e.value <= 0) {
					Msg.info("warning", "ת����������С�ڻ����0!");
					return;
				}
				if (e.record.get("inclbAvaQty")<e.value)
				{
					Msg.info("warning", "ת���������ܴ��ڿ�������!");
					return;
				}*/
				var salePriceAMT = e.record.get("sp")* e.value;
				//var realPriceAMT = e.record.get("rp")* e.value;
				e.record.set("spAmt",salePriceAMT);	
				//e.record.set("rpAmt",realPriceAMT);	
				GetAmount();
			}
		})
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
			grid.getSelectionModel().select(rowindex,0);
			e.preventDefault(); 
			rightClick.showAt(e.getXY()); 
		}

		/**
		 * ����ҩƷ���岢���ؽ��
		 */
		function GetPhaOrderInfo(item, stkgrp) {
			var phaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
			var phaLocRQ = Ext.getCmp("RequestPhaLoc").getValue();
			if (item != null && item.length > 0) {
				IncItmBatWindow(item, stkgrp, App_StkTypeCode, phaLoc, "N", "1", "",phaLocRQ,
						returnInfo);
			}
		}
		
		/**
		 * ����������Ϣ
		 */
		function returnInfo(record) {
			if (record == null || record == "") {
				return;
			}
		//for(var i=0;i<record.length;i++){
			var cell = DetailGrid.getSelectionModel().getSelectedCell();
			var selectRow = cell[0];
			// ����ظ�����
			var INITIINCLBDR = record.get("Inclb");
			var INCLBWARNFLAG= record.get("InclbWarnFlag");
			if (INCLBWARNFLAG=="1"){
				if (gParam[10]=="Y"){
					Msg.info("warning", $g("��ҩƷ�������ѹ���,������¼��"));  //��ʾ+����
					var colindex=GetColIndex(DetailGrid,"inciDesc");
					if(colindex>0){
						DetailGrid.getSelectionModel().select(selectRow, colindex);
						DetailGrid.startEditing(selectRow, colindex);
					}
					return;
				}
				else{
					Msg.info("warning",$g( "��ҩƷ�������ѹ���!"));  //����ʾ
				}
			}
			else if (INCLBWARNFLAG=="2"){
				Msg.info("warning", $g("��ҩƷ������״̬Ϊ������!"));
				return;
			}
			var rowCount = DetailGrid.getStore().getCount();
			for (var i = 0; i < rowCount; i++) {
				var item = DetailStore.getAt(i).get("inclb");
				if (i == selectRow) {
					continue;
				}
				if (item != undefined && INITIINCLBDR == item) {
					Msg.info("warning",$g( "ҩƷ�����ظ�������������!"));
					return;
				}
			}

			// DetailStore.getAt(selectRow).set("INITIRowId", "");
			DetailStore.getAt(selectRow).set("inci", record.get("InciDr"));
			DetailStore.getAt(selectRow).set("inciCode", record.get("InciCode"));
			DetailStore.getAt(selectRow).set("inciDesc", record.get("InciDesc"));
			DetailStore.getAt(selectRow).set("inclb",record.get("Inclb"));
			DetailStore.getAt(selectRow).set("batexp",record.get("BatExp"));
			DetailStore.getAt(selectRow).set("manfName",record.get("Manf"));
			DetailStore.getAt(selectRow).set("inclbQty",record.get("InclbQty"));
			addComboData(CTUomStore,record.get("PurUomId"),record.get("PurUomDesc"));
			DetailStore.getAt(selectRow).set("uom",	record.get("PurUomId"));
			DetailStore.getAt(selectRow).set("rp",record.get("Rp"));
			DetailStore.getAt(selectRow).set("sp",record.get("Sp"));
			//DetailStore.getAt(selectRow).set("reqQty", record.get("ReqQty"));
			DetailStore.getAt(selectRow).set("stkbin", record.get("StkBin"));
			DetailStore.getAt(selectRow).set("reqLocStkQty",record.get("RequrstStockQty"));
			DetailStore.getAt(selectRow).set("newSp",record.get("BatSp"));
			DetailStore.getAt(selectRow).set("spec", record.get("Spec"));
			DetailStore.getAt(selectRow).set("gene",record.get("GeneName"));
			DetailStore.getAt(selectRow).set("formDesc", record.get("PhcFormDesc"));
			DetailStore.getAt(selectRow).set("ConFac", record.get("ConFac"));
			DetailStore.getAt(selectRow).set("BUomId",record.get("BUomId"));
			DetailStore.getAt(selectRow).set("inclbDirtyQty", record.get("DirtyQty"));
			DetailStore.getAt(selectRow).set("inclbAvaQty", record.get("AvaQty"));
			DetailStore.getAt(selectRow).set("InsuCode", record.get("InsuCode"));
			DetailStore.getAt(selectRow).set("InsuDesc", record.get("InsuDesc"));

			var index=GetColIndex(DetailGrid,"qty");
			if(index>0){
				DetailGrid.getSelectionModel().select(cell[0], index);
				DetailGrid.startEditing(cell[0], index);
			}
			GetAmount();
		}

		/**
		 * ��λչ���¼�
		 */
		CTUom.on('beforequery', function(combo) {
					var cell = DetailGrid.getSelectionModel().getSelectedCell();
					var record = DetailGrid.getStore().getAt(cell[0]);
					var InciDr = record.get("inci");
					var url = DictUrl
							+ 'drugutil.csp?actiontype=INCIUom&ItmRowid='
							+ InciDr;
					CTUomStore.proxy = new Ext.data.HttpProxy({
								url : url
							});
					CTUom.store.removeAll();
					CTUom.store.load();
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
					var TrUom = record.get("uom");    //Ŀǰ��ʾ�ĳ��ⵥλ
					var Sp = record.get("sp");
					var Rp = record.get("rp");
					var NewSp = record.get("newSp");
					var InclbQty=record.get("inclbQty");
					var ReqStkQty=record.get("reqLocStkQty");
					var DirtyQty=record.get("inclbDirtyQty");
					var AvaQty=record.get("inclbAvaQty");
					var ReqQty=record.get("reqQty");
					var TrQty=record.get("qty");
					var NowDirtyQty = record.get("dirtyQty");
					if (value == null || value.length <= 0) {
						return;
					} else if (TrUom == value) {
						return;
					} else if (value==BUom) {     //��ѡ��ĵ�λΪ������λ��ԭ��ʾ�ĵ�λΪ��λ
						//record.set("sp",Number(Sp).div(ConFac));
						//record.set("newSp",Number(NewSp).div(ConFac));
						//record.set("rp", Number(Rp).div(ConFac));
						//record.set("inclbQty", Number(InclbQty).mul(ConFac) );
						record.set("reqLocStkQty", Number(ReqStkQty).mul(ConFac));
						//record.set("inclbDirtyQty", Number(DirtyQty).mul(ConFac));
						//record.set("inclbAvaQty", Number(AvaQty).mul(ConFac) );
						record.set("reqQty", Number(ReqQty).mul(ConFac) );
						//record.set("dirtyQty", Number(NowDirtyQty).mul(ConFac));
					} else{  //��ѡ��ĵ�λΪ��λ��ԭ���ǵ�λΪС��λ
						//record.set("sp", Number(Sp).mul(ConFac) ); 
						//record.set("newSp", Number(NewSp).mul(ConFac) );
						//record.set("rp", Number(Rp).mul(ConFac) );
						//record.set("inclbQty", Number(InclbQty).div(ConFac));
						record.set("reqLocStkQty", Number(ReqStkQty).div(ConFac));
						//record.set("inclbDirtyQty",  Number(DirtyQty).div(ConFac));
						//record.set("inclbAvaQty", Number(AvaQty).div(ConFac));
						record.set("reqQty", Number(ReqQty).div(ConFac));
						//record.set("dirtyQty", Number(NowDirtyQty).div(ConFac));
					}
					var Inclb=record.get("inclb");
					var QtyAndPriceInfo = tkMakeServerCall("web.DHCST.Util.DrugUtil","GetIncilbInfo",Inclb,value)
					if (QtyAndPriceInfo=="") return;
					var InfoArr = QtyAndPriceInfo.split("^")
					record.set("sp", InfoArr[0] ); 
					record.set("rp", InfoArr[1] );
					record.set("inclbQty", InfoArr[2]);
					record.set("inclbDirtyQty",  InfoArr[3]);
					record.set("inclbAvaQty", InfoArr[4]);
					var initi = record.get("initi");
					var dirtyQtyUom= tkMakeServerCall("web.DHCST.DHCINIsTrfItm","GetDirtyQtyBuUom",initi,value)
					record.set("dirtyQty", dirtyQtyUom);
					record.set("uom", combo.getValue());
		});

		// �任����ɫ
		function changeBgColor(row, color) {
			DetailGrid.getView().getRow(row).style.backgroundColor = color;
		}

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
			//��ѯ^���^�½�^����^ɾ��^���^ȡ�����
			SearchInItBT.setDisabled(list[0]);
			ClearBT.setDisabled(list[1]);
			//AddBT.setDisabled(list[2]);
			SaveBT.setDisabled(list[3]);
			DeleteBT.setDisabled(list[4]);			
			CheckBT.setDisabled(list[5]);
			CancelCmpBT.setDisabled(list[6]);
		}
		function changeElementEnable()
		{
			if (DetailGrid.getStore().getCount()==0){
				Ext.getCmp("StkGrpType").setDisabled(false);
				SupplyPhaLoc.setDisabled(false);
			}
			else{
				Ext.getCmp("StkGrpType").setDisabled(true);
				SupplyPhaLoc.setDisabled(true);
			}
		}
		var HisListTab = new Ext.form.FormPanel({
			labelWidth : 60,
//			id:'HisListTab',
			labelAlign : 'right',
			frame : true,
			region : 'north',
			height:DHCSTFormStyle.FrmHeight(3),
			title:$g('���ת���Ƶ�'),
			autoScroll : false,
			//bodyStyle : 'padding:5px 0px 0px 0px;',
			tbar : [SearchInItBT, '-',  ClearBT, '-', SaveBT, '-', CheckBT, '-', CancelCmpBT,'-',SelReqBT,'-',PrintBT, '-', DeleteBT],
			items:[{
				xtype:'fieldset',
				title:$g('ת�Ƶ���Ϣ'),
				layout: 'column',    // Specifies that the items will now be arranged in columns
				style:DHCSTFormStyle.FrmPaddingV,
				items : [{ 				
					columnWidth: 0.33,
	            	xtype: 'fieldset',
	            	//labelWidth: 60,	
	            	defaults: {width: 220, border:false},    // Default config options for child items
	            	defaultType: 'textfield',
	            	autoHeight: true,
	            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
	            	border: false,
	            	//style: {
	                //	"margin-left": "10px", // when you add custom margin in IE 6...
	               	//	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0",  // you have to adjust for it somewhere else
	               	//	"margin-bottom": "10px"
	            	//},
	            	items: [SupplyPhaLoc,RequestPhaLoc,StkGrpType]
					
				},{ 				
					columnWidth: 0.33,
	            	xtype: 'fieldset',
	            	//labelWidth: 60,	
	            	defaults: {width: 140, border:false},    // Default config options for child items
	            	defaultType: 'textfield',
	            	autoHeight: true,
	            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
	            	border: false,
	            	//style: {
	                //	"margin-left": "10px", // when you add custom margin in IE 6...
	                //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
	            	//},
	            	items: [InItNo,InItDate,OperateOutType]
					
				},{ 				
					columnWidth: 0.33,
	            	xtype: 'fieldset',
	            	//labelWidth: 60,	
	            	defaults: {width: 140, border:false},    // Default config options for child items
	            	defaultType: 'textfield',
	            	autoHeight: true,
	            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
	            	border: false,
	            	//style: {
	                //	"margin-left": "10px", // when you add custom margin in IE 6...
	                //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
	            	//},
	            	items: [ReqNo,ReqNoID,Remark,InItFlag]
					
				}]
			}]
		});

		// ˫���¼�
		DetailGrid.on('rowdblclick', function() {
					// �ж�ת�Ƶ��Ƿ������
					var initFlag = Ext.getCmp("InItFlag").getValue();
					if (initFlag != null && initFlag != 0) {
						Msg.info("warning", $g("ת�Ƶ�����ɲ����޸�!"));
						return;
					}
					var cell = DetailGrid.getSelectionModel().getSelectedCell();
					var selectRow = cell[0];
					var item = DetailStore.getAt(selectRow).get("IncName");
					GetPhaOrderInfo(item, "");
				});

		// ҳ�沼��
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [HisListTab, DetailGrid],
					renderTo : 'mainPanel'
				});
		
		// ��¼����Ĭ��ֵ
		SetLogInDept(PhaDeptStore, "SupplyPhaLoc");
		RefreshGridColSet(DetailGrid,"DHCSTTRANSFER"); 
		if(gInitId!=undefined && gInitId!='' && gFlag==1){
			Query(gInitId);
		}
		//�򿪿��ת���Ƶ�����ʱ����������ȷ���Ƿ����Զ���ʾ�����������
		if(gFlag!=1 && gParam[6]=='Y'){
			var FrLoc=Ext.getCmp("SupplyPhaLoc").getValue();
			if(FrLoc!=null && FrLoc!=""){
				SelReq(FrLoc,Query,1);			}			
		}
		
	}
	 
})
