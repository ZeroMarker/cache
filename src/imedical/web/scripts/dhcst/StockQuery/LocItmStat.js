// /����: ���ͳ��
// /����: ���ͳ��
// /��д�ߣ�gwj
// /��д����: 2013.03.26
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gIncId='';
	var gStrParam='';
	var gStrParamBatch='';
	var gUserId = session['LOGON.USERID'];	
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	if(gParamCommon.length<1){
		GetParamCommon();  //��ʼ��������������
	}
	ChartInfoAddFun();
	// ��¼����Ĭ��ֵ
	SetLogInDept(PhaDeptStore, "PhaLoc");
	
	
	function ChartInfoAddFun() {
		var PhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : $g('����') ,
					id : 'PhaLoc',
					name : 'PhaLoc',
					anchor : '90%',
					//width : 140,
					groupId:gGroupId,
                    listeners : {
	                    'select' : function(e) {SetDefaultSCG();}
					}
				});
	function SetDefaultSCG()
	{
		 Ext.getCmp("StkGrpType").setValue("");
		 var SelLocId=Ext.getCmp('PhaLoc').getValue();//add wyx ����ѡ��Ŀ��Ҷ�̬��������
         StkGrpType.getStore().removeAll();
         StkGrpType.getStore().setBaseParam("locId",SelLocId)
         StkGrpType.getStore().setBaseParam("userId",UserId)
         StkGrpType.getStore().setBaseParam("type",App_StkTypeCode)
         StkGrpType.getStore().load();
         Ext.getCmp("StkCat").setValue("");
	}
    
		var DateTime = new Ext.ux.DateField({
					fieldLabel : $g('����') ,
					id : 'DateTime',
					name : 'DateTime',
					anchor : '90%',
					//width : 140,
					value : new Date()
				});
		
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //��ʶ��������
			//width : 140,
			anchor:'90%',
			LocId:gLocId,
			UserId:gUserId,
			fieldLabel : $g('����') 
		}); 

		StkGrpType.on('select', function() {
			Ext.getCmp("StkCat").setValue("");
		});

		var StkCat = new Ext.ux.ComboBox({
					fieldLabel : $g('������') ,
					id : 'StkCat',
					name : 'StkCat',
					anchor : '90%',
					//listWidth : 250,
					store : StkCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					params:{StkGrpId:'StkGrpType'}
		});


		var PhManufacturer = new Ext.ux.ComboBox({
					fieldLabel : $g('������ҵ') ,
					id : 'PhManufacturer',
					name : 'PhManufacturer',
					anchor : '90%',
					//width : 140,
					store : PhManufacturerStore,
					valueField : 'RowId',
					displayField : 'Description',
					filterName:'PHMNFName'
		});
	
				
		var LocManGrp=new Ext.ux.ComboBox({
		        fieldLabel :$g( '������') ,
		        id : 'LocManGrp',
		        name : 'LocManGrp',
		        anchor : '90%',
		        store : LocManGrpStore,
		        valueField : 'RowId',
		        displayField : 'Description',
		        params:{locId:'PhaLoc'}
    	});
    
		var StkBin = new Ext.ux.ComboBox({
					fieldLabel : $g('��λ��') ,
					id : 'StkBin',
					name : 'StkBin',
					anchor : '90%',
					//width : 140,
					store : LocStkBinStore,
					valueField : 'RowId',
					displayField : 'Description',
					params:{LocId:'PhaLoc'},
					filterName:'Desc'
		});

		var ManageDrug = new Ext.form.Checkbox({
					fieldLabel : $g('����ҩ') ,
					id : 'ManageDrug',
					name : 'ManageDrug',
					anchor : '90%',				
					height : 10,
					checked : false
		});

		//��������
		var UseFlag = new Ext.form.Checkbox({
					//fieldLabel : '��������',
					boxLabel:$g('����') ,
					hideLabel:true,
					labelWidth:30,
					id : 'UseFlag',
					name : 'UseFlag',
					anchor : '90%',					
					height : 10,
					checked : false
		});
		
		//�ų�������
		var NotUseFlag = new Ext.form.Checkbox({
					//fieldLabel : '�ų�������',
					boxLabel:$g('�ų�') ,
					hideLabel:true,
					id : 'NotUseFlag',
					name : 'NotUseFlag',
					anchor : '90%',					
					height : 10,
					checked : false
		});
				
		var UseTime = new Ext.form.TextField({
				fieldLabel : '',
				id : 'UseTime',
				name : 'UseTime',
				anchor : '80%',
				width : 40,
				hideLabel : true, 
				value : '6'
		});
		
			
		var NotUseTime = new Ext.form.TextField({
				fieldLabel : '',
				id : 'NotUseTime',
				name : 'NotUseTime',
				anchor : '80%',
				width : 40,
				hideLabel : true, 
				value : '6'
		});
    
    // ��հ�ť
		var RefreshBT = new Ext.Toolbar.Button({
					text : $g('����') ,
					tooltip : $g('�������') ,
					iconCls : 'page_clearscreen',
					width : 70,
					height : 30,
					handler : function() {
						clearData();
					}
				});

		
		 //��շ���
		 
		function clearData() {
			gStrParam='';
			Ext.getCmp("DateTime").setValue(new Date());			
			Ext.getCmp("ManageDrug").setValue(false);
			Ext.getCmp("UseFlag").setValue(false);
			Ext.getCmp("NotUseFlag").setValue(false);
			Ext.getCmp("StkCat").setValue('');
			SetLogInDept(PhaLoc.getStore(), "PhaLoc");
			SetDefaultSCG();
			Ext.getCmp("PhManufacturer").setValue('');
			Ext.getCmp("LocManGrp").setValue('');
			Ext.getCmp("StkBin").setValue('');
			gIncId="";
			StockQtyGrid.store.removeAll();
			StockQtyGrid.getView().refresh();
			BatQtyGrid.store.removeAll();
			BatQtyGrid.getView().refresh();
		}
		
		


		// ��ѯ��ť
		var SearchBT = new Ext.Toolbar.Button({
					text : $g('��ѯ') ,
					tooltip : $g('�����ѯ') ,
					iconCls : 'page_find',
					width : 70,
					height : 30,
					handler : function() {
						StockQtyGrid.getStore().removeAll();
						searchData();
					}
				});
    
		// ��ѯ����
		 
		function searchData() {
			
			// ��ѡ����
			var sphaLoc = Ext.getCmp("PhaLoc").getValue();
			var sphaLocdesc = Ext.getCmp("PhaLoc").getRawValue();
			//wyx add 2014-01-15
			if (sphaLocdesc ==""||sphaLocdesc == null || sphaLoc.length <= 0) {
				Msg.info("warning", $g("���Ҳ���Ϊ�գ�") );
				Ext.getCmp("PhaLoc").focus();
				return;
			}
			if (sphaLoc == null || sphaLoc.length <= 0) {
				Msg.info("warning", $g("���Ҳ���Ϊ�գ�") );
				Ext.getCmp("PhaLoc").focus();
				return;
			}
			var datetmp=Ext.getCmp("DateTime").getValue()
			if (datetmp=="") {
				Msg.info("warning", $g("���ڲ���Ϊ�գ�")) ;
				Ext.getCmp("DateTime").focus();
				return;
				}
			var date = Ext.getCmp("DateTime").getValue().format(App_StkDateFormat).toString();
			var StkGrpRowId = Ext.getCmp("StkGrpType").getValue();
			//var StockType = Ext.getCmp("Type").getValue();
			
			if (date == null || date.length <= 0) {
				Msg.info("warning", $g("���ڲ���Ϊ�գ�")) ;
				Ext.getCmp("DateTime").focus();
				return;
			}
			if ((StkGrpRowId == null || StkGrpRowId.length <= 0)&(gParamCommon[9]=="N")) {
				Msg.info("warning", $g("���鲻��Ϊ�գ�")) ;
				Ext.getCmp("StkGrpType").focus();
				return;
			}
			
			
			// ��ѡ����
			var StkCat = Ext.getCmp("StkCat").getValue();
			var PhcCatList = "";
			//var PhcCat = Ext.getCmp("PhcCat").getValue();
			var ManageDrug = (Ext.getCmp("ManageDrug").getValue()==true?'Y':'N');
			var UseFlag = (Ext.getCmp("UseFlag").getValue()==true?'Y':'N');
			var NotUseFlag = (Ext.getCmp("NotUseFlag").getValue()==true?'Y':'N');
			var Phmanid=Ext.getCmp("PhManufacturer").getValue();
			var ManGrpId=Ext.getCmp("LocManGrp").getValue();
			var SBid=Ext.getCmp("StkBin").getValue();
			var MoveMon=Ext.getCmp('UseTime').getValue();
			var NotMoveNon=Ext.getCmp('NotUseTime').getValue();
		
/// ����id^����^����id^����id^������id^
/// ��λid^�Ƿ����ҩ^����^6�����н���^�ų�����^6�����޽���^
			
			var strParam=sphaLoc+"^"+date+"^"+StkGrpRowId+"^"+Phmanid+"^"+ManGrpId+"^"+SBid+"^"+ManageDrug+"^"+UseFlag+"^"+MoveMon+"^"+NotUseFlag+"^"+NotMoveNon+"^"+StkCat;
			
			StockStatStore.setBaseParam("Params",strParam);
		
			var pageSize=StatuTabPagingToolbar.pageSize;
			
			
			var activeTab=tabPanel.getActiveTab();
			
			if(activeTab.id=="ItmDetail"){
				StockStatStore.load({params:{start:0,limit:pageSize,Sort:'',Dir:'',Params:strParam}});
			}
			else{
				BatStatStore.load({params:{start:0,limit:pageSize,Sort:'',Dir:'',Params:strParam}});
			}
		}

		// ��水ť
		var SaveAsBT = new Ext.Toolbar.Button({
					text : $g('���') ,
					tooltip : $g('���ΪExcel') ,
					iconCls : 'page_excel',
					width : 70,
					height : 30,
					handler : function() {
						var activeTab=tabPanel.getActiveTab();
						if(activeTab.id=="ItmDetail"){
							ExportAllToExcel(StockQtyGrid);
						}else{
							ExportAllToExcel(BatQtyGrid);
						}
					}
		});
		
		function manFlagRender(value){
			if(value==="1"){
				return $g('����ҩ') 	;		
			}else if(value==="0"){
				return $g('�ǹ���ҩ') ;
			}else return ""
		}
				
		

		var nm = new Ext.grid.RowNumberer({width:30});
		var sm = new Ext.grid.CheckboxSelectionModel({singleSelect:true});
		var StockQtyCm = new Ext.grid.ColumnModel([{
					header : "INCIRowID",
					dataIndex : 'Inci',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header :$g( '����') ,
					dataIndex : 'InciCode',
					width : 100,
					align : 'left',
					sortable : true
					//,
					//renderer:cellMerge
				}, {
					header : $g("����") ,
					dataIndex : 'InciDesc',
					width : 200,
					align : 'left',
					sortable : true
					//,
					//renderer:cellMerge
				}, {
					header : $g("��λ") ,
					dataIndex : 'StkBin',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : $g('���(��װ��λ)') ,
					dataIndex : 'PurStockQty',
					width : 100,
					align : 'right',
					//hidden:true,
					sortable : true,
					renderer:SetNumber
				}, {
					header :$g( "��װ��λ") ,
					dataIndex : 'PurUomDesc',
					width : 50,
					align : 'left',
					sortable : false
				}, {
					header : $g("���(������λ)") ,
					dataIndex : 'StockQty',
					width : 100,
					align : 'right',
					sortable : true,
					renderer:SetNumber
				}, {
					header : $g("������λ") ,
					dataIndex : 'BUomDesc',
					width : 40,
					align : 'left',
					sortable : false
				}, /*{
					header : $g("���(��λ)") ,
					dataIndex : 'StkQtyUom',
					width : 100,
					align : 'left',
					sortable : true
				}, */{
					header : $g("���ۼ�") ,
					dataIndex : 'Sp',
					width : 80,
					align : 'right',
					sortable : false,
				}, {
					header :$g( "���½���") ,
					dataIndex : 'Rp',
					width : 80,
					align : 'right',
					sortable : false
				}, {
					header : $g('�ۼ۽��') ,
					dataIndex : 'SpAmt',
					width : 120,
					align : 'right',
					sortable : false,
				}, {
					header : $g('���۽��') ,
					dataIndex : 'RpAmt',
					width : 120,
					align : 'right',
					sortable : false,
				}, {
					header :$g( "���") ,
					dataIndex : 'Spec',
					width : 100,
					align : 'left',
					sortable : false
				}, {
					header : $g('������ҵ') ,
					dataIndex : 'ManfDesc',
					width : 50,
					align : 'left',
					sortable : false
				},{
					header : $g("�Ƿ����ҩ") ,
					dataIndex : 'ManFlag',
					width : 120,
					align : 'left',
					sortable : false,
					renderer:manFlagRender
				}]);
		StockQtyCm.defaultSortable = true;
    	var myBigTimeout = 900000;  
		// ����·��
		var DspPhaUrl = DictUrl
					+ 'locitmstataction.csp?actiontype=LocItmStat';
		
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : DspPhaUrl,
					method : "POST",
					timeout: myBigTimeout
				});
		// ָ���в���
		var fields = ["Inci","InciCode","InciDesc","BUomDesc","BUomId","StockQty",
		"StkQtyUom","StkBin","PurUomDesc","PurUomId",
	  "PurStockQty","Spec","ManfDesc","Sp","SpAmt","Rp","RpAmt","ManFlag"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "Inci",
					fields : fields
				});
		
		// ���ݼ�
		var StockStatStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader,
					remoteSort:true,
					baseParams:{
						Params:''
					}
					
				});
				
	  var nmbat = new Ext.grid.RowNumberer({width:30});
		var smbat = new Ext.grid.CheckboxSelectionModel({singleSelect:true});
		var BatQtyCm = new Ext.grid.ColumnModel([{
					header : "Inclb",
					dataIndex : 'Inclb',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "INCIRowID",
					dataIndex : 'Inci',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				},{
					header : $g('����') ,
					dataIndex : 'InciCode',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : $g("����") ,
					dataIndex : 'InciDesc',
					width : 200,
					align : 'left',
					sortable : true
				}, {
					header : $g("��λ") ,
					dataIndex : 'StkBin',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : $g("����") ,
					dataIndex : 'Btno',
					width : 100,
					align : 'left',
					sortable : false
				}, {
					header : $g("��Ч��") ,
					dataIndex : 'Expdate',
					width : 100,
					align : 'left',
					sortable : false
				}, {
					header : $g('���(��װ��λ)') ,
					dataIndex : 'PurStockQty',
					width : 100,
					align : 'right',
					//hidden:true,
					sortable : true,
					renderer:SetNumber
				}, {
					header : $g("��װ��λ"), 
					dataIndex : 'PurUomDesc',
					width : 50,
					align : 'left',
					sortable : false
				}, {
					header : $g("���(������λ)") ,
					dataIndex : 'StockQty',
					width : 100,
					align : 'right',
					sortable : true,
					renderer:SetNumber
				}, {
					header : $g("������λ") ,
					dataIndex : 'BUomDesc',
					width : 40,
					align : 'left',
					sortable : false
				}, /*{
					header :$g( "���(��λ)",
					dataIndex : 'StkQtyUom',
					width : 100,
					align : 'left',
					sortable : true
				},*/ {
					header : $g("���ۼ�") ,
					dataIndex : 'Sp',
					width : 80,
					align : 'right',
					sortable : false,
				}, {
					header : $g("���½���") ,
					dataIndex : 'Rp',
					width : 80,
					align : 'right',
					sortable : false,
				}, {
					header : $g('�ۼ۽��') ,
					dataIndex : 'SpAmt',
					width : 120,
					align : 'right',
					sortable : false
				}, {
					header : $g('���۽��') ,
					dataIndex : 'RpAmt',
					width : 120,
					align : 'right',
					sortable : false,
				}, {
					header : $g('���') ,
					dataIndex : 'Spec',
					width : 50,
					align : 'left',
					sortable : false
				}, {
					header : $g('������ҵ') ,
					dataIndex : 'ManfDesc',
					width : 50,
					align : 'left',
					sortable : false
				},{
					header : $g("���ξ�Ӫ��ҵ") ,
					dataIndex : 'PVenDesc',
					width : 150,
					align : 'left',
					//renderer : Ext.util.Format.usMoney,
					sortable : true
				},  {
					header : $g("�Ƿ����ҩ") ,
					dataIndex : 'ManFlag',
					width : 120,
					align : 'left',
					sortable : false,
					renderer:manFlagRender
				}]);
		BatQtyCm.defaultSortable = true;
				
		// ����·��
		var BatQtystatUrl = DictUrl
					+ 'locitmstataction.csp?actiontype=LocBatStat&start=&limit=';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxybat = new Ext.data.HttpProxy({
					url : BatQtystatUrl,
					method : "POST"
				});
		// ָ���в���
		var batfields = ["Inclb","Inci","InciCode","InciDesc","BUomDesc","BUomId","StockQty",
		"StkQtyUom","StkBin","Btno","Expdate","PurUomDesc","PurUomId",
	  "PurStockQty","Spec","ManfDesc","Sp","SpAmt","Rp","RpAmt","PVenDesc","ManFlag"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var readerbat = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "Inclb",
					fields : batfields
				});		
				
		var BatStatStore = new Ext.data.Store({
					proxy : proxybat,
					reader : readerbat,
					remoteSort:true,
					baseParams:{
						Params:''
					}
					
				});
    
		var StatuTabPagingToolbar = new Ext.PagingToolbar({
					store : StockStatStore,
					pageSize : PageSize,
					displayInfo : true,
					displayMsg : $g('��ǰ��¼ {0} -- {1} �� �� {2} ����¼') ,
					emptyMsg : "No results to display",
					prevText : $g("��һҳ") ,
					nextText : $g("��һҳ") ,
					refreshText : $g("ˢ��") ,
					lastText : $g("���ҳ") ,
					firstText : $g("��һҳ") ,
					beforePageText : $g("��ǰҳ") ,
					afterPageText :$g( "��{0}ҳ") ,
					emptyMsg : $g("û������") 
		});
		
		var StatuTabPagingToolbar2 = new Ext.PagingToolbar({
					store : BatStatStore,
					pageSize : PageSize,
					displayInfo : true,
					displayMsg : $g('��ǰ��¼ {0} -- {1} �� �� {2} ����¼') ,
					emptyMsg : "No results to display",
					prevText : $g("��һҳ") ,
					nextText :$g( "��һҳ") ,
					refreshText : $g("ˢ��") ,
					lastText :$g( "���ҳ") ,
					firstText :$g( "��һҳ") ,
					beforePageText : $g("��ǰҳ") ,
					afterPageText : $g("��{0}ҳ") ,
					emptyMsg : $g("û������") 
		});
    
		var StockQtyGrid = new Ext.grid.GridPanel({
					id:'StockQtyGrid',
					region : 'center',
					cm : StockQtyCm,
					store : StockStatStore,
					trackMouseOver : true,
					stripeRows : true,
					//sm : sm, //new Ext.grid.CheckboxSelectionModel(),
					loadMask : true
					//,
					//bbar : StatuTabPagingToolbar
		});
		
		var BatQtyGrid = new Ext.grid.GridPanel({
					id:'BatQtyGrid',
					region : 'center',
					cm : BatQtyCm,
					store : BatStatStore,
					trackMouseOver : true,
					stripeRows : true,
					//sm : sm, //new Ext.grid.CheckboxSelectionModel(),
					loadMask : true
					//,
					//bbar : StatuTabPagingToolbar2
		});
		
		//�ϲ�DetailGridLB����ͬ��ҩƷ��Ϣ
function cellMerge(value, meta, record, rowIndex, colIndex, store) {
	var lastRowCode="",lastRowDesc="",lastRowSpec="",lastRowUom="";
	if(rowIndex>0){
		lastRowCode=store.getAt(rowIndex - 1).get("incicode"),lastRowDesc=store.getAt(rowIndex - 1).get("incidesc"),
		lastRowSpec=store.getAt(rowIndex - 1).get("spec"),lastRowUom=store.getAt(rowIndex - 1).get("puomdesc");
	}
	var thisRowCode=store.getAt(rowIndex).get("incicode"),thisRowDesc=store.getAt(rowIndex).get("incidesc"),
	thisRowSpec=store.getAt(rowIndex).get("spec"),thisRowUom=store.getAt(rowIndex).get("puomdesc");
	var nextRowCode="",nextRowDesc="",nextRowSpec="",nextRowUom="";
	if(rowIndex<store.getCount()-1){
		nextRowCode=store.getAt(rowIndex+1).get("incicode"),nextRowDesc=store.getAt(rowIndex+1).get("incidesc"),
		nextRowSpec=store.getAt(rowIndex+1).get("spec"),nextRowUom=store.getAt(rowIndex+1).get("puomdesc");
	}
	
    var first = !rowIndex || (thisRowCode !==lastRowCode)||(thisRowDesc!==lastRowDesc)||(thisRowSpec!==lastRowSpec)||(thisRowUom!==lastRowUom),
    last = rowIndex >= store.getCount() - 1 || (thisRowCode !==nextRowCode)||(thisRowDesc!==nextRowDesc)||(thisRowSpec!==nextRowSpec)||(thisRowUom!==nextRowUom);
    meta.css += 'row-span' + (first ? ' row-span-first' : '') +  (last ? ' row-span-last' : '');
    if (first) {
        var i = rowIndex + 1;
        while (i < store.getCount() && thisRowCode == store.getAt(i).get("incicode")
        &&thisRowDesc==store.getAt(i).get("incidesc")&&thisRowSpec==store.getAt(i).get("spec")&&thisRowUom==store.getAt(i).get("puomdesc")) {
            i++;
        }
        var rowHeight = 25, padding = 6,
            height = (rowHeight * (i - rowIndex) - padding) + 'px';
        meta.attr = 'style="height:' + height + ';line-height:' + height + ';"';
    }
    return first ? value : '';
}
		
		
		var HisListTab = new Ext.form.FormPanel({
			labelWidth : 70,
			width : 300,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			bodyStyle : 'padding:10px 0px 0px 0px;',
			tbar : [SearchBT, '-', RefreshBT, '-', SaveAsBT],
			items : [{
						title:$g('��ѡ����') ,
						xtype:'fieldset',
						style:'padding:10px 0px 0px 0px',
						items:[PhaLoc,DateTime,StkGrpType]
					},
					StkCat,
					PhManufacturer,
					LocManGrp,StkBin,
				  ManageDrug,
				  {xtype: 'compositefield',align:'middle',items:[UseFlag,UseTime,{xtype:'tbtext',style:'padding-top:3px',text:'�����н�������'}]},
				  {xtype: 'compositefield',items:[NotUseFlag,NotUseTime,{xtype:'tbtext',style:'padding-top:3px',text:'�����޽���������'}]}
//				  {
//				  	items : [{
//							items : [
//							        {xtype: 'compositefield',
//							        	items:[UseFlag,UseTime,{xtype:'tbtext',text:'�����н���'}]},
//							        {xtype: 'compositefield',items:[NotUseFlag,NotUseTime,{xtype:'tbtext',text:'�����޽���'}]}
//							        ]
//						}]
//				  }
//				  {
//				  	layout : 'column',
//				  	items : [{
//					    	columnWidth : .5,
//							xtype : 'fieldset',
//							items : [UseFlag,NotUseFlag]
//						},{
//							columnWidth : .5,
//							//xtype: 'fieldset',
//							items : [
//							        {xtype: 'compositefield',
//							        	items:[UseTime,{xtype:'tbtext',text:'�����н���'}]},
//							        {xtype: 'compositefield',items:[NotUseTime,{xtype:'tbtext',text:'�����޽���'}]}
//							        ]
//						}]
//				  }
			 ]  	
		});
		
		var tabPanel=new Ext.TabPanel({
   		activeTab:1,
   		items:[{
   			title:$g('��Ŀ��ϸ') ,
   			id:'ItmDetail',
   			layout:'fit',
   			items:[StockQtyGrid]
   		},{
   			title:$g('������ϸ') ,
   			id:'BatDetail',
   			layout:'fit',
   			items:[BatQtyGrid]
   		}]
   })
tabPanel.on("afterrender",function(tab){tab.activate(0)})
		// 5.2.ҳ�沼��
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [            // create instance immediately
					         {
					        region: 'west',
			                split: true,
                			width: 300,
                			minSize: 200,
                			maxSize: 350,
                			collapsible: true,
			                title: $g('����') ,
			                layout: 'fit', // specify layout manager for items
			                items: HisListTab   
			             },{ 
			                	region:'center',
			                	title: $g('���') ,
			                	layout: 'fit', // specify layout manager for items
			                	items: tabPanel
			            }
	       			],
					renderTo : 'mainPanel'
		});
		
	}
	
})