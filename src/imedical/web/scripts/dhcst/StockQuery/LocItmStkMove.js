// /����: ̨�˲�ѯ
// /����: ̨�˲�ѯ
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.09
var gNewCatId="";
var GridSelectWinType="";
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	//var LoginLocId = session['LOGON.COMMUNITYROWID'];   //DTHealth��Ҫ��һ��
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    Ext.Ajax.timeout = 900000;
    /*
    Ext.getDoc().on("contextmenu", function(e){
	    e.stopEvent();
	});*/
    
   	if(gParamCommon.length<1){
		GetParamCommon();  //��ʼ�������������� 

	}
	ChartInfoAddFun();

	function ChartInfoAddFun() {

	//ͳ�ƿ���
	var PhaLoc = new Ext.ux.LocComboBox({
			fieldLabel : '����',
			id : 'PhaLoc',
			name : 'PhaLoc',
			groupId:gGroupId,
	        listeners : {
	            'select' : function(e) {
	                 var SelLocId=Ext.getCmp('PhaLoc').getValue();//add wyx ����ѡ��Ŀ��Ҷ�̬��������
	                 StkGrpType.getStore().removeAll();
	                 StkGrpType.getStore().setBaseParam("locId",SelLocId)
	                 StkGrpType.getStore().setBaseParam("userId",UserId)
	                 StkGrpType.getStore().setBaseParam("type",App_StkTypeCode)
	                 StkGrpType.getStore().load();
				}
			}
	});
		
	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
			fieldLabel : '��ʼ����',
			id : 'StartDate',
			name : 'StartDate',
			anchor : '90%',
			width : 120,
			value : new Date()
		});

	// ��������
	var EndDate = new Ext.ux.DateField({
			fieldLabel : '��������',
			id : 'EndDate',
			name : 'EndDate',
			anchor : '90%',
			width : 120,
			value : new Date()
		});	
	
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			fieldLabel:'�ࡡ����',
			StkType:App_StkTypeCode,     //��ʶ��������
			LocId:gLocId,
			UserId:userId,
			anchor:'90%'
		});
	StkGrpType.on('change',function(){
		Ext.getCmp("DHCStkCatGroup").setValue("");
	});
		
	var DHCStkCatGroup = new Ext.ux.ComboBox({
			fieldLabel : '������',
			id : 'DHCStkCatGroup',
			name : 'DHCStkCatGroup',
			anchor : '90%',
			width : 120,
			store : StkCatStore,
			valueField : 'RowId',
			displayField : 'Description',
			params:{StkGrpId:'StkGrpType'}
		});

	var InciDr = new Ext.form.TextField({
			fieldLabel : 'ҩƷRowId',
			id : 'InciDr',
			name : 'InciDr',
			anchor : '90%',
			width : 140,
			valueNotFoundText : ''
		});

	var ItmDesc = new Ext.form.TextField({
			fieldLabel : 'ҩƷ����',
			id : 'ItmDesc',
			name : 'ItmDesc',
			anchor : '90%',
			width : 160,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var StkGrp= Ext.getCmp("StkGrpType").getValue();
						GetPhaOrderInfo(field.getValue(),StkGrp);
						//GetPhaOrderInfo(field.getValue(),'');
					}
				}
			}
		});
				
	/**
	 * ����ҩƷ���岢���ؽ��
	 */
	function GetPhaOrderInfo(item, group) {
					
		if (item != null && item.length > 0) {
			GetPhaOrderWindow(item, group, App_StkTypeCode, "", "", "", "",
					getDrugList);
		}
	}

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
		;
		Ext.getCmp("ItmDesc").setValue(inciDesc);
		Ext.getCmp('InciDr').setValue(inciDr);			
		searchMainData();
		Ext.getCmp("ItmDesc").focus(true,1000);				
	}
	
	// ҩѧ����
	var PhcCat = new Ext.form.ComboBox({
			fieldLabel : 'ҩѧ����',
			id : 'PhcCat',
			name : 'PhcCat',
			anchor : '90%',
			width : 120,
			store : PhcCatStore,
			valueField : 'RowId',
			displayField : 'Description',
			allowBlank : true,
			triggerAction : 'all',
			selectOnFocus : true,
			forceSelection : true,
			minChars : 1,
			pageSize : 20,
			listWidth : 250,
			valueNotFoundText : '',
			enableKeyEvents : true,
			listeners : {
				'beforequery' : function(e) {
					refill(PhcCatStore, "PHCCat", Ext.getCmp('PhcCat')
									.getRawValue());
				}
			}
		});

var PHCCATALL = new Ext.form.TextField({
	fieldLabel : 'ҩѧ����',
	id : 'PHCCATALL',
	name : 'PHCCATALL',
	anchor : '90%',
	readOnly : true,
	valueNotFoundText : ''
});
function GetAllCatNew(catdescstr,newcatid){
	//if ((catdescstr=="")&&(newcatid=="")) {return;}
	Ext.getCmp("PHCCATALL").setValue(catdescstr);
	gNewCatId=newcatid;
	
	
}

var PHCCATALLButton = new Ext.Button({
	id:'PHCCATALLButton',
	text : 'ҩѧ����',
	handler : function() {	
		PhcCatNewSelect(gNewCatId,GetAllCatNew)

    }
});
	var PHCDFPhcDoDR = new Ext.ux.ComboBox({
					fieldLabel : '���Ʒ���',
					id : 'PHCDFPhcDoDR',
					name : 'PHCDFPhcDoDR',
					store : PhcPoisonStore,
					valueField : 'RowId',
					displayField : 'Description'
				});
				
	// ��������ֵ����
	function refill(store, type, filter) {
		var url = "";
		if (type == "PHCCat") {
			url = DictUrl + 'drugutil.csp?actiontype=PhcCat&PhccDesc='
					+ filter + '&start=0&limit=999';
		}
		store.removeAll();
		store.proxy = new Ext.data.HttpProxy({
					url : encodeURI(url)
				});
		store.reload({
					params : {
						start : 0,
						limit : 20
					}
				});
	}
		
	//����ҩ
	var ManageDrug = new Ext.form.Checkbox({
			boxLabel : '����ҩ',
			id : 'ManageDrug',
			name : 'ManageDrug',
			anchor : '90%',
			checked : false
		});
	
	//ҵ�������־
	var RetAspFlag = new Ext.form.Checkbox({
		boxLabel : '�Ƿ���ʾҵ������',
		id : 'RetAspFlag',
		name : 'RetAspFlag',
		anchor : '90%',
		checked : true
	});
				
	var TypeStore = new Ext.data.SimpleStore({
			fields : ['RowId', 'Description'],
			data : [['0', 'ȫ��'], ['1', '������'], ['2', '��������']]
		});
	//ͳ�Ʊ�־
	var QueryFlag = new Ext.form.ComboBox({
			fieldLabel : 'ͳ�Ʊ�־',
			id : 'QueryFlag',
			name : 'QueryFlag',
			anchor : '90%',
			width : 100,
			store : TypeStore,
			valueField : 'RowId',
			displayField : 'Description',
			mode : 'local',
			allowBlank : true,
			triggerAction : 'all',
			selectOnFocus : true,
			listWidth : 150,
			forceSelection : true
		});
	Ext.getCmp("QueryFlag").setValue(0);
	
	/// ҵ������
	var TransType = new Ext.form.ComboBox({
		fieldLabel : 'ҵ������',
		id : 'TransType',
		name : 'TransType',
		anchor : '90%',					
		store : TransTypeStore,
		valueField : 'RowId',
		displayField : 'Description',
		mode : 'local',
		allowBlank : true,
		triggerAction : 'all',
		selectOnFocus : true,
		listWidth : 150,
		forceSelection : true
	});
	
	// ������ť
	var searchBT = new Ext.Toolbar.Button({
				text : '��ѯ',
				tooltip : '�����ѯ̨��',
				iconCls : 'page_find',
				height:30,
				width:70,
				handler : function() {
					searchMainData();
				}
			});		
	// ��水ť
	var SaveAsBT = new Ext.Toolbar.Button({
				text : '���',
				tooltip : '���ΪExcel',
				iconCls : 'page_export',
				width : 70,
				height : 30,
				handler : function() {
					GridSelectWinType=1
					GridSelectWin.show();
					
					//gridSaveAsExcel(StockQtyGrid);
				}
			});		
	var GridColSetBT = new Ext.Toolbar.Button({
	      text:'������',
          tooltip:'������',
          iconCls:'page_gear',
	      handler:function(){
		      GridSelectWinType=2
		      GridSelectWin.show();
	      }
        });
       	// ȷ����ť
	var returnBT = new Ext.Toolbar.Button({
				text : 'ȷ��',
				tooltip : '���ȷ��',
				iconCls : 'page_goto',
				handler : function() {
					var selectradio = Ext.getCmp('GridSelectModel').getValue();
			        if(selectradio){
			            var selectModel =selectradio.inputValue;	
						if (selectModel=='1') {
							if (GridSelectWinType==1){
								ExportAllToExcel(MasterInfoGrid);		
							}
							else{
								GridColSet(MasterInfoGrid,"DHCSTLOCSTKMOVE");
							} 
						}
						else {
							if (GridSelectWinType==1){
								ExportAllToExcel(DetailInfoGrid);		
							}
							else{
								GridColSet(DetailInfoGrid,"DHCSTLOCSTKMOVEDETAIL");
							}							
						}						
			         }
			         GridSelectWin.hide();
			         GridSelectWinType="";
				}
			});

	// ȡ����ť
	var cancelBT = new Ext.Toolbar.Button({
				text : 'ȡ��',
				tooltip : '���ȡ��',
				iconCls : 'page_delete',
				handler : function() {
					GridSelectWin.hide();
				}
			});

      //ѡ��ť
	 var GridSelectWin=new Ext.Window({
			title:'ѡ��',
			width : 200,
			height : 110,
			labelWidth:100,
			closeAction:'hide' ,
			plain:true,
			modal:true,
			items:[{
				  xtype:'radiogroup',
				  id:'GridSelectModel',
				  anchor: '95%',
				  columns: 2,
				  style: 'padding:10px 10px 10px 10px;',
				  items : [{
						 checked: true,				             
				             boxLabel: '̨��',
				             id: 'GridSelectModel1',
				             name:'GridSelectModel',
				             inputValue: '1' 							
						},{
						 checked: false,				             
				             boxLabel: '̨����ϸ',
				             id: 'GridSelectModel2',
				             name:'GridSelectModel',
				             inputValue: '2' 							
						}]
			        }],
			
			buttons:[returnBT,cancelBT]
			})	
	function priceRender(val){
		//var val = Ext.util.Format.number(val,'0.00'); //����������
		if (this.header.indexOf("��")>=0){
			val=FormatGridRp(val);
		}else{
			val=FormatGridSp(val);
		}	
		return val;
	}	
	function amountRender(val){
		//var val = Ext.util.Format.number(val,'0.00'); //����������
		if (this.header.indexOf("��")>=0){
			val=FormatGridRpAmount(val);
		}else{
			val=FormatGridSpAmount(val);
		}
		if(val<0){
			return '<span style="color:red;">'+val+'</span>';
		}else if(val>0){
			return '<span style="color:green;">'+val+'</span>';
		}
		return val;
	}
	function searchMainData() {
		
		//wyx add 2014-01-15
		var StartDatetmp = Ext.getCmp("StartDate").getValue()
		if (StartDatetmp=="") {
		    Msg.info("warning", "��ʼ���ڲ���Ϊ�գ�");
		    Ext.getCmp("StartDate").focus();
		    return;
				}
		
		var StartDate = Ext.getCmp("StartDate").getValue().format(App_StkDateFormat)
				.toString();;
		if(StartDate==null||StartDate.length <= 0) {
			Msg.info("warning", "��ʼ���ڲ���Ϊ�գ�");
			return;
		}
		var EndDatetmp = Ext.getCmp("EndDate").getValue()
		if (EndDatetmp=="") {
		    Msg.info("warning", "��ֹ���ڲ���Ϊ�գ�");
		    Ext.getCmp("EndDate").focus();
		    return;
				}
		var EndDate = Ext.getCmp("EndDate").getValue().format(App_StkDateFormat)
				.toString();
		if(EndDate==null||EndDate.length <= 0) {
			Msg.info("warning", "��ֹ���ڲ���Ϊ�գ�");
			return;
		}
		
		var PhaLocDesc = Ext.getCmp("PhaLoc").getRawValue();
		if (PhaLocDesc ==""||PhaLocDesc == null || PhaLocDesc.length <= 0) {
				Msg.info("warning", "���Ҳ���Ϊ�գ�");
				Ext.getCmp("PhaLoc").focus();
				return;
			}
		var PhaLoc = Ext.getCmp("PhaLoc").getValue();
		if(PhaLoc==null||PhaLoc.length <= 0) {
			Msg.info("warning", "���Ҳ���Ϊ�գ�");
			return;
		}
		
		var StkGrp= Ext.getCmp("StkGrpType").getValue();
		var StkCat= Ext.getCmp("DHCStkCatGroup").getValue();
		var ItmDesc=Ext.getCmp("ItmDesc").getValue();
		var ItmRowid="";
		if(ItmDesc!="" & ItmDesc.length>0){
			ItmRowid= Ext.getCmp("InciDr").getValue();
		}
		
		var PhcCat= Ext.getCmp("PhcCat").getValue();
		var PoisonCat= Ext.getCmp("PHCDFPhcDoDR").getValue();
		var ManageFlag= Ext.getCmp("ManageDrug").getValue();
		if(ManageFlag==true){
			ManageFlag=1;
		}
		else{
			ManageFlag="";
		}
		var StateFlag= Ext.getCmp("QueryFlag").getValue();
		var TransType=Ext.getCmp("TransType").getValue();
		var Others=StkGrp+"^"+StkCat+"^"+ItmRowid+"^"+PhcCat+"^"+PoisonCat+"^"+ManageFlag+"^"+StateFlag+"^"+gNewCatId+"^"+TransType;
		MasterInfoStore.setBaseParam('startdate',StartDate);
		MasterInfoStore.setBaseParam('enddate',EndDate);
		MasterInfoStore.setBaseParam('phaloc',PhaLoc);
		MasterInfoStore.setBaseParam('others',Others);
		var size=StatuTabPagingToolbar.pageSize;
		MasterInfoStore.removeAll();
		DetailInfoGrid.store.removeAll();
		MasterInfoStore.load({
			params:{start:0,limit:size},
			callback : function(r,options, success){
				if(success==false){
     				Ext.MessageBox.alert("��ѯ����",this.reader.jsonData.Error);
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

	// ��հ�ť
	var clearBT = new Ext.Toolbar.Button({
				text : '����',
				tooltip : '�������',
				iconCls : 'page_clearscreen',
				height:30,
				width:70,
				handler : function() {
					clearData();
				}
			});

	function clearData() {
		SetLogInDept(PhaLoc.getStore(),'PhaLoc');
		Ext.getCmp("StartDate").setValue(new Date());
		Ext.getCmp("EndDate").setValue(new Date());
		Ext.getCmp("StkGrpType").getStore().load();
		Ext.getCmp("DHCStkCatGroup").setValue('');
		Ext.getCmp("PhcCat").setValue('');
		Ext.getCmp("PHCDFPhcDoDR").setValue('');
		Ext.getCmp("QueryFlag").setValue(0);
		Ext.getCmp("ItmDesc").setValue('');
		Ext.getCmp("ManageDrug").setValue(false);
		Ext.getCmp("RetAspFlag").setValue(true);
		
		Ext.getCmp("TransType").setValue('');
		MasterInfoGrid.store.removeAll();
		MasterInfoGrid.store.load({params:{start:0,limit:0}});
		DetailInfoGrid.store.removeAll();
		DetailInfoGrid.store.load({params:{start:0,limit:0}});
		Ext.getCmp("PHCCATALL").setValue("");
	}

	// 3�رհ�ť
	var closeBT = new Ext.Toolbar.Button({
				text : '�ر�',
				tooltip : '�رս���',
				iconCls : 'close',
				handler : function() {
					window.close();
				}
			});

				
	// ����·��
	var MasterInfoUrl = DictUrl
					+ 'locitmstkaction.csp?actiontype=LocItmStkMoveSum&start=0&limit=20';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : MasterInfoUrl,
				method : "POST"
			});
	// ָ���в���
	// INCIL^��������^���������^������^��ⵥλ^������λ^�ڳ�����(������λ)
	// ^�ڳ�����(����λ)^�ڳ����(����)^�ڳ����(�ۼ�)^��ĩ����(������λ)^��ĩ����(����λ)
	// ^��ĩ���(����)^��ĩ���(�ۼ�)
	// 
	var fields = ["INCIL", "InciCode", "InciDesc","StkCat","PurUom","BUom","BegQty","BegQtyUom",
	"BegRpAmt","BegSpAmt","EndQty","EndQtyUom","EndRpAmt","EndSpAmt","PlusQty","MinusQty"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "INCIL",
				fields : fields
			});
	// ���ݼ�
	var MasterInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader,
				remoteSort:true
			});
	var nm = new Ext.grid.RowNumberer();
	var MasterInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "INCIL",
				dataIndex : 'INCIL',
				width : 20,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "ҩƷ����",
				dataIndex : 'InciDesc',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : '��ⵥλ',
				dataIndex : 'PurUom',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '��������',
				dataIndex : 'PlusQty',
				width : 100,
				align : 'right',
				sortable : true,
				renderer:FormatGridQty
			}, {
				header : '��������',
				dataIndex : 'MinusQty',
				width : 100,
				align : 'right',
				sortable : true,
				renderer:FormatGridQty
			}, {
				header : '������λ',
				dataIndex : 'BUom',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '�ڳ����',
				dataIndex : 'BegQtyUom',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '�ڳ����(����)',
				dataIndex : 'BegRpAmt',
				width : 100,
				align : 'right',
				renderer:amountRender,
				sortable : true
			}, {
				header : '�ڳ����(�ۼ�)',
				dataIndex : 'BegSpAmt',
				width : 100,
				align : 'right',
				renderer:amountRender,
				sortable : true
			}, {
				header : '��ĩ���',
				dataIndex : 'EndQtyUom',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '��ĩ���(����)',
				dataIndex : 'EndRpAmt',
				width : 100,
				align : 'right',
				renderer:amountRender,
				sortable : true
			}, {
				header : '��ĩ���(�ۼ�)',
				dataIndex : 'EndSpAmt',
				width : 100,
				align : 'right',
				renderer:amountRender,
				sortable : true
			}, {
				header : '������',
				dataIndex : 'StkCat',
				width : 100,
				align : 'left',
				sortable : true
			}]);
	MasterInfoCm.defaultSortable = true;
	var StatuTabPagingToolbar = new Ext.PagingToolbar({
		store : MasterInfoStore,
		pageSize : PageSize,
		displayInfo : true,
		displayMsg : '��ǰ��¼ {0} -- {1} �� �� {2} ����¼',
		prevText : "��һҳ",
		nextText : "��һҳ",
		refreshText : "ˢ��",
		lastText : "���ҳ",
		firstText : "��һҳ",
		beforePageText : "��ǰҳ",
		afterPageText : "��{0}ҳ",
		emptyMsg : "û������"
	});
	var MasterInfoGrid = new Ext.grid.GridPanel({
				id : 'MasterInfoGrid',
				title : '',
				height : 250,
				cm : MasterInfoCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true,
							listeners:{
								'rowselect': function(sm,rowIndex,r){
									var Incil = MasterInfoStore.getAt(rowIndex).get("INCIL");
									var StartDate = Ext.getCmp("StartDate").getValue().format(App_StkDateFormat).toString();;
									var EndDate = Ext.getCmp("EndDate").getValue().format(App_StkDateFormat).toString();
									var TransType=Ext.getCmp("TransType").getValue();
									var size=StatuTabPagingToolbar2.pageSize;
									var RetAspFlag= Ext.getCmp("RetAspFlag").getValue();
									if(RetAspFlag==true){
										RetAspFlag=1;
									}
									else{
										RetAspFlag=0;
									}
									DetailInfoStore.setBaseParam('incil',Incil);
									DetailInfoStore.setBaseParam('startdate',StartDate);
									DetailInfoStore.setBaseParam('enddate',EndDate);
									DetailInfoStore.setBaseParam('transtype',TransType);
									DetailInfoStore.setBaseParam('RetAspFlag',RetAspFlag);
									DetailInfoStore.load({
										params:{start:0,limit:size},
										callback : function(r,options, success){
											if(success==false){
												Ext.MessageBox.alert("��ѯ����",this.reader.jsonData.Error);
											}
										}
									});
								}
							}
						}),
				store : MasterInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				columnLines      : true,
				loadMask : true,
				bbar : StatuTabPagingToolbar
			});

	// ��ӱ�񵥻����¼�
	MasterInfoGrid.on('rowclick', function(grid, rowIndex, e) {
	});

	// ����·��
	var DetailInfoUrl = DictUrl
					+ 'locitmstkaction.csp?actiontype=LocItmStkMoveDetail&start=0&limit=20';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : DetailInfoUrl,
				method : "POST"
			});
	
	// ָ���в���
	//ҵ������^����^��λ^�ۼ�^����^��������(������λ)^��������(����λ)^��������(������λ)
	//^��������(����λ)^�������(����)^�������(�ۼ�)^�����^������Ϣ^ժҪ
	//^��ĩ���(����)^��ĩ���(�ۼ�)^��Ӧ��^����^������	
	var fields = ["TrId","TrDate", "BatExp", "PurUom", "Sp","Rp","EndQty","EndQtyUom",
			"TrQty", "TrQtyUom", "RpAmt", "SpAmt","TrNo","TrAdm","TrMsg",
			"EndRpAmt", "EndSpAmt", "Vendor", "Manf","OperateUser","TypeFlag"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "TrId",
				fields : fields
			});
	// ���ݼ�
	var DetailInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader,
				remoteSort:true
			});
	var nm = new Ext.grid.RowNumberer();
	var DetailInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "TrId",
				dataIndex : 'TrId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "����ʱ��",
				dataIndex : 'TrDate',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : '����Ч��',
				dataIndex : 'BatExp',
				width : 185,
				align : 'left',
				sortable : true
			}, {
				header : "��λ",
				dataIndex : 'PurUom',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "�ۼ�",
				dataIndex : 'Sp',
				width : 60,
				align : 'right',
				renderer:priceRender,				
				sortable : true
			}, {
				header : "����",
				dataIndex : 'Rp',
				width : 60,
				renderer:priceRender,
				align : 'right'
			}, {
				header : "��������",
				dataIndex : 'EndQtyUom',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'TrQtyUom',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "���۽��",
				dataIndex : 'RpAmt',
				width : 100,
				renderer:amountRender,
				align : 'right',
				
				sortable : true
			}, {
				header : "�ۼ۽��",
				dataIndex : 'SpAmt',
				width : 100,
				renderer:amountRender,
				align : 'right',
				
				sortable : true
			}, {
				header : "�����",
				dataIndex : 'TrNo',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "������Ϣ",
				dataIndex : 'TrAdm',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "ҵ������",
				dataIndex : 'TrMsg',
				width : 65,
				align : 'left',
				sortable : true
			}, {
				header : "������(����)",
				dataIndex : 'EndRpAmt',
				width : 100,
				renderer:amountRender,
				align : 'right',
				
				sortable : true
			}, {
				header : "������(�ۼ�)",
				dataIndex : 'EndSpAmt',
				width : 100,
				renderer:amountRender,
				align : 'right',
				
				sortable : true
			}, {
				header : "��Ӧ��",
				dataIndex : 'Vendor',
				width : 160,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'Manf',
				width : 160,
				align : 'left',				
				sortable : true
			}, {
				header : "������",
				dataIndex : 'OperateUser',
				width : 65,
				align : 'left',				
				sortable : true
			}, {
				header : "TypeFlag",
				dataIndex : 'TypeFlag',
				width : 65,
				align : 'left',				
				sortable : true,
				hidden : true
			}]);
	DetailInfoCm.defaultSortable = true;
	var StatuTabPagingToolbar2 = new Ext.PagingToolbar({
		store : DetailInfoStore,
		pageSize : 20,
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
		emptyMsg : "û������"
	});
	var DetailInfoGrid = new Ext.grid.GridPanel({
				title : '',
				height : 170,
				cm : DetailInfoCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				store : DetailInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				columnLines      : true,
				loadMask : true,
				bbar : StatuTabPagingToolbar2,
				viewConfig : {
					getRowClass: function(record, rowIndex,rowParams,store){
						var TypeFlag=record.get('TypeFlag');
						if(TypeFlag=="1"){return 'classGrassGreen'}
					}
				}
			});
    //�Ҽ��˵�����ؼ����� 
	function rightClickFn(grid,rowindex,e){
		//grid.getSelectionModel().select(rowindex,0);
		grid.getSelectionModel().selectRow(rowindex);
		var rows=DetailInfoGrid.getSelectionModel().getSelections() ; 
		selectedRow = rows[0];
		var TrId = selectedRow.get("TrId");
		if(TrId.indexOf("RetAsp")>-1)
		{
			return;
		}
		e.preventDefault(); 
		rightClick.showAt(e.getXY()); 
	}
	var rightClick = new Ext.menu.Menu({ 
		id:'rightClickCont', 
		items: [ 
			{ 
				id: 'mnumodTransBat',   //�����޸����� bianshuai 2014-04-23
				handler: mQueryBusDetail, 
				text: 'ҵ����ϸ��ѯ' 
			}
		] 
	});
    DetailInfoGrid.addListener('rowcontextmenu', rightClickFn);
    function mQueryBusDetail()
    {
		var rows=DetailInfoGrid.getSelectionModel().getSelections() ; 
		if(rows.length==0){
			Ext.Msg.show({title:'����',msg:'��ѡ��Ҫ�鿴��̨����ϸ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		}else {
			selectedRow = rows[0];
			var TrId = selectedRow.get("TrId");
			if(TrId.indexOf("RetAsp")>-1)
			{
				TrId=TrId.split("RetAsp")[1];
				//Msg.info("warning", "��������û��ҵ����ϸ����鿴ԭҵ���¼��");
				//return;
			}
		   	BusDetailWin(TrId)
		}
	}


	var HisListTab = new Ext.form.FormPanel({
			labelWidth : 80,
			region : 'north',
			labelAlign : 'right',
			frame : true,
			title:"̨�˲�ѯ",
			tbar : [searchBT, '-', clearBT,'-',SaveAsBT,'-',GridColSetBT],		
		    items:[{
						layout : 'column',			
						items : [{
									columnWidth:0.25,
									autoHeight : true,
									xtype: 'fieldset',
									title:'��ѡ����',	
									style:DHCSTFormStyle.FrmPaddingV+"background",  //css���;������������
									layout : 'column',	
									defaults: { border:false},    // Default config options for child items
									items : [{
										columnWidth:1,
										xtype: 'fieldset',
										border:false,									
										items : [PhaLoc,StartDate,EndDate]
									}]
								},{
									columnWidth:0.75,
									autoHeight : true,									
									xtype: 'fieldset',
									title:'��ѡ����',
									style:DHCSTFormStyle.FrmPaddingV+"margin-left:10px",	
									defaults: { border:false}, 
									layout : 'column',	
									items : [{
												columnWidth:0.35,
												xtype: 'fieldset',
												border:false,									
												items : [StkGrpType,DHCStkCatGroup,ItmDesc]
											},{
												xtype: 'fieldset',
												columnWidth:0.25,
												border:false,											
												items : [PHCDFPhcDoDR,QueryFlag,TransType]
											},{
												columnWidth:0.4,
												xtype: 'fieldset',
												border:false,
												items : [{xtype:'compositefield',items:[PHCCATALL,PHCCATALLButton]},ManageDrug,RetAspFlag]
											}]										
								}]
		    }]	
		});
	// 5.2.ҳ�沼��
	var mainPanel = new Ext.Viewport({
				layout : 'border',				
				items : [{
							region:'north',
							height:DHCSTFormStyle.FrmHeight(3)-10,
							layout:'fit',
			                items:HisListTab
			            },
			            {
							region:'center',
							split:true,
							layout:'fit',
			                items:MasterInfoGrid
			            },{
							region:'south',
							split: true,
							minSize:0,
							maxSize:document.body.clientHeight*0.6,
							height:document.body.clientHeight*0.45,
							layout:'fit',
			                items:DetailInfoGrid
			            }]
			});
			RefreshGridColSet(MasterInfoGrid,"DHCSTLOCSTKMOVE");
		    RefreshGridColSet(DetailInfoGrid,"DHCSTLOCSTKMOVEDETAIL");

}
});