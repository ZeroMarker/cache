///����: ����Ƶ�
///��д�ߣ�gwj
///��д����: 2012.09.24
function PayFromRec(FnR) {
	var URL="dhcst.payaction.csp"
	var ManuOp=false;
	var saveOK=true;
	payLocRowId=Ext.getCmp("PhaLoc").getValue();

	var readerV=new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "vendor",
		fields:[{name:'RowId',mapping:'vendor'},{name:'Description',mapping:'vendorName'}]
	});

	var VendorToPayStore=new Ext.data.Store({
		url:URL+"?actiontype=queryVendor",
		reader:readerV,
		listeners:{
			'beforeload':function(store){
				var userId = session['LOGON.USERID'];
		        var groupId=session['LOGON.GROUPID'];
				var sd=Ext.getCmp('StartDateR').getRawValue();
				var ed=Ext.getCmp('EndDateR').getRawValue();
				var vendor=Ext.getCmp('VendorR').getValue();
				var StrParam=sd+"^"+ed+"^"+payLocRowId+"^"+vendor+"^"+groupId+"^"+userId;
				var page=vendorListPTB.pageSize;
				store.baseParams={start:0,limit:page,strParam:StrParam};			
			},
			'load':function(){
				if (VendorToPayStore.getCount()>0){
					vendorListGrid.getSelectionModel().selectFirstRow();
					vendorListGrid.focus();
					vendorListGrid.getView().focusRow(0);
				}			
			}
		}
	});		
		
	var vendorListPTB = new Ext.PagingToolbar({
		id:'vendorListPTB',
		store:VendorToPayStore,
		pageSize:40,
		displayInfo:true,
		displayMsg:'��ʾ��{0}��{1}����¼��һ��{2}��',	
		emptyMsg:"û�м�¼"
	});

	var nm = new Ext.grid.RowNumberer();
	var vendorListCM=new Ext.grid.ColumnModel([nm,
		{
			header:'RowId',
			dataIndex:'RowId',
			hidden:true
		},
		{
			header:'��Ӧ������',
			width:190,
			dataIndex:'Description',
			align:'left',
			sortable:true
		}]);
	var vendorListGrid=new Ext.grid.GridPanel({
		cm:vendorListCM,
		store:VendorToPayStore,
		sm : new Ext.grid.RowSelectionModel({
			singleSelect : true
		}),
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		bbar:[vendorListPTB]
	});


	// ��������
	var VendorR = new Ext.ux.VendorComboBox({
		fieldLabel : '��Ӧ��',
		id : 'VendorR',
		name : 'VendorR',
		anchor : '90%',
		emptyText : '��Ӧ��...'
	});
		
	 

	// ��ʼ����
	var StartDateR = new Ext.ux.DateField({
		fieldLabel : '��ʼ����',
		id : 'StartDateR',
		name : 'StartDateR',
		anchor : '90%',
		width : 120,
		value : new Date().add(Date.DAY, - 30)
	});

	// ��ֹ����
	var EndDateR = new Ext.ux.DateField({
		fieldLabel : '��ֹ����',
		id : 'EndDateR',
		name : 'EndDateR',
		anchor : '90%',
		width : 120,
		value : new Date()
	});
		
	var payNoR=new Ext.form.TextField({
		fieldLabel : '�����',
		id : 'payNoR',
		name : 'payNoR',
		anchor : '90%',
		disabled:true,
		width : 120
	});

	//�����־
	var PoisonFlagR = new Ext.form.Checkbox({
		fieldLabel : '�����־',
		id : 'PoisonFlagR',
		name : 'PoisonFlagR',
		anchor : '90%',
		checked : false
	});

	//���θ�����
	var payTotalAmtR=new Ext.form.TextField(
	{
		fieldLabel:'�����ܶ�',
		id:'totalAmtR',
		anchor : '90%',
		disabled:true

	})

	// ��ѯ��ť
	var SearchBTR = new Ext.Toolbar.Button({
		text : '��ѯ',
		tooltip : '�����ѯ',
		width : 70,
		height : 30,
		iconCls : 'page_find',
		handler : function() {
			Query();
		}
	});
	// ��հ�ť
	var ClearBTR = new Ext.Toolbar.Button({
		text : '����',
		tooltip : '�������',
		width : 70,
		height : 30,
		iconCls : 'page_clearscreen',
		handler : function() {
			clearData();
		}
	});

	// ȷ����ť
	var saveBTR = new Ext.Toolbar.Button({
		text : '���渶�',
		tooltip : '�������',
		width : 70,
		height : 30,
		iconCls : 'page_save',
		handler : function() {
			Save();
		}
	});
	// ȡ����ť
	var CancelBTR = new Ext.Toolbar.Button({
		text : '�ر�',
		tooltip : '����˳�������',
		width : 70,
		height : 30,
		iconCls : 'page_close',
		handler : function() {
			fromRecWindow.close();
		}
	});


	/**
	 * ��ѯ����
	 */
	function Query() {
		if (payLocRowId == null || payLocRowId.length <= 0) {
			Msg.info("warning", "��ѡ��������!");
			return;
		}
	    VendorToPayStore.removeAll();
	    ItmToPayStore.removeAll();
	    VendorToPayStore.load();
	}


	/**
	 * ��շ���
	 */
	function clearData() { 
		vendorListGrid.store.removeAll();
		vendorListGrid.getView().refresh();
		gVendorRowId="";
		
		ItmToPayGrid.store.removeAll();
		ItmToPayGrid.getView().refresh();
		
		Ext.getCmp('VendorR').setValue('');
		Ext.getCmp('PoisonFlagR').setValue(false);
		Ext.getCmp('payNoR').setValue('');
		
		payTotalAmtR.setValue('');
		
		gPayRowId="";
	}


	function cancelFind()
	{
		fromRecWindow.close();
		
	}

		
	// ����·��
	var ItmToPayUrl = URL	+ '?actiontype=queryItmToPay';

	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
		url : ItmToPayUrl,
		method : "POST"
		});
	// ָ���в���
	var fields = ['RowId','No','gdDate','gdTime','gdAuditUserName','ingri','inclb','inci',
	'inciCode','inciDesc','spec','manf','uomDesc','qty','rp','rpAmt','sp','spAmt',
	'payedAmt','restAmt',{name:'amt',mapping:'amt',type:'float'},'invNo','invAmt','invDate','sxNo','batNo','expDate','type','poison'];


	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "pay",
		fields : fields
	});

	// ���ݼ�
	var ItmToPayStore = new Ext.data.Store({
			proxy : proxy,
			reader : reader,
			listeners:{
				'beforeload':function(store)
				{	
					store.removeAll();
					var vendor="";			
					var sd=Ext.getCmp('StartDateR').getRawValue();
					var ed=Ext.getCmp('EndDateR').getRawValue();
					var userId = session['LOGON.USERID'];
		            var groupId=session['LOGON.GROUPID'];
					var strParam=payLocRowId+"^"+gVendorRowId+"^"+sd+"^"+ed+"^"+groupId+"^"+userId;
					store.baseParams={start:0,limit:9999,strParam:strParam	}			
				}
			}
		});
		
	var nm = new Ext.grid.RowNumberer();
	var sm=new Ext.grid.CheckboxSelectionModel({
		checkOnly:true,
		listeners:{
			'rowselect':function(t,ind,rec)
			{
				if (ManuOp==false){
					var toBePayAmt=rec.get('restAmt');
					rec.set('amt',toBePayAmt);  //ʹ��<��������>���
					rec.commit();
				}
				ManuOp=false;
				TotalAmt(); 
				CheckPoison();
				
				
			},
			'rowdeselect':function(t,ind,rec)
			{
				var toBePayAmt=rec.get('restAmt');
				rec.set('amt','');  //ȡ��ʹ��<��������>���
				rec.commit();
				TotalAmt();
				CheckPoison();
			}
		}
	});

	/*�����ܽ��*/
	function TotalAmt()
	{
	  var cnt=ItmToPayGrid.store.getTotalCount() ;
	  var store=ItmToPayGrid.getStore();
	  var sumAmt=0;
	  for (var i=0;i<cnt;i++){
	  	var rec=store.getAt(i);
	  	var amt=rec.get('amt');
	  	sumAmt=sumAmt+ Number(amt);
	  }
	  payTotalAmtR.setValue(sumAmt);
	  
	}
	//����Ƿ��������ҩƷ
	function CheckPoison()
	{   
	    var rowCnt=0;
	    var poisonflag=0;
	    var rowCount = ItmToPayGrid.getStore().getCount();
	    for (var i = 0; i < rowCount; i++) {			
	    var sm=ItmToPayGrid.getSelectionModel();
	    if(sm.isSelected(i)==true){	
	       var rowData = ItmToPayGrid.store.getAt(i);
	       
	       var poison=rowData.get("poison");
	       
	       if (poison=='Y') {poisonflag='1'}
	      
	      }
	    }
	    if (poisonflag=='1') {
		    Ext.getCmp('PoisonFlagR').setValue(true);
		}else {
			Ext.getCmp('PoisonFlagR').setValue(false);
		}
	}
	var ItmToPayCm = new Ext.grid.ColumnModel([nm,sm,	
			{
			header : "RowId",
			dataIndex : 'RowId',
			width : 100,
			align : 'left',
			sortable : true,
			hidden : true,
			editable:false
		}, 
	 	{
			header : "����",
			align : 'left',
			dataIndex : 'No',
			editable:false,
			width:120	
		}, 
		{
			header : '����',
			dataIndex : 'type',	
			align : 'left',
			width:50,
			editable:false
		},
		{
			header : '������',
			align : 'right',
			dataIndex : 'amt',
			editable:true,
			editor: new Ext.ux.NumberField({
				formatType: 'FmtRA',
				selectOnFocus: true,
				allowNegative: false,
				allowBlank: false
			})
		}, 
	 	{
			header : "����",   //�������
			dataIndex : 'gdDate',
			align : 'left',
			editable:false
		}, 
	 	{
			header : "ʱ��",  //���ʱ��
			dataIndex : 'gdTime',
			align : 'left',
			width:50,
			editable:false
		}, 
	 	{
			header : "�����",
			dataIndex : 'gdAuditUserName',
			align : 'left',
			editable:false
		}, 
	 	{
			header : "��ϸrowid",
			dataIndex : 'ingri',
			hidden:true,
			editable:false
		}, 	 
	 	{
			header : "inclb",
			dataIndex : 'inclb',
			hidden:true,
			editable:false
		}, 
	 	{
			header : "inci",
			dataIndex : 'inci'	,
			hidden:true,
			editable:false
		}, 				
	 	{
			header : "����",
			dataIndex : 'inciCode',
			editable:false
		}, 			
		{
			header : "����",
			dataIndex : 'inciDesc'	,
			width:200,
			editable:false
		}, 							
								
	 	{
			header : '���',
			dataIndex : 'spec',	
			width:80,
			editable:false
		}, 		
		 	{
			header : '����',
			dataIndex : 'manf'	
		}, 		
		 	{
			header : '��λ',
			dataIndex : 'uomDesc',
			editable:false	
		}, 	
		{
			header : '����',
			dataIndex : 'qty',	
			align : 'right',
			editable:false
		}, 		
		 		 	{
			header : '����',
			dataIndex : 'rp',
			align : 'right',
			editable:false
		}, 	
		 		{
			header : '���۽��',
			dataIndex : 'rpAmt'	,
			align : 'right',
			editable:false
		}, 		
		 	{
			header : '�ۼ�',
			dataIndex : 'sp',	
			align : 'right',
			editable:false,
			editable:false
		}, 	{
			header : '�ۼ۽��',
			dataIndex : 'spAmt'	,
			align : 'right',
			editable:false
		},
			{
			header : '�Ѹ����',
			align : 'right',
			dataIndex : 'payedAmt'	,
			editable:false
		}, 		
			{
			header : '�������',
			align : 'right',
			dataIndex : 'restAmt',
			editable:false
		}, 		
		 		{
			header : '��Ʊ��',
			dataIndex : 'invNo'	
		}, 		
		 	{
			header : '��Ʊ���',
			dataIndex : 'invAmt',	
			align : 'right',
			editable:false
		}, 		
		 	{
			header : '��Ʊ����',
			dataIndex : 'invDate',
			align : 'left',
			editable:false
		}, 	{
			header : '���е�',
			dataIndex : 'sxNo'	
		}, 		
		 	{
			header : '����',
			dataIndex : 'batNo'	,
			editable:false
		}, 		
		 	{
			header : '��Ч��',
			dataIndex : 'expDate',	
			align : 'left',
			editable:false
		}, 		
		 	{
			header : '������',
			dataIndex : 'poison',	
			align : 'left',
			editable:false
		}
	]);
			
	ItmToPayCm.defaultSortable = true;

	var ItmToPayGrid = new Ext.grid.EditorGridPanel({
		title : '',
		id:'ItmToPayGrid',
		height : 170,
		cm : ItmToPayCm,
		clicksToEdit:1,
		sm:sm,
		store : ItmToPayStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		listeners:{
			'afteredit':function(e)
			{
				if (e.field=='amt')
				{
					ManuOp=true;
					e.record.commit();				
					e.grid.getSelectionModel().selectRow(e.row,true);
					TotalAmt();
				}
			}
		}
	});

		vendorListGrid.getSelectionModel().on('rowselect',function(sm,rowIndex,rec){
			gVendorRowId = vendorListGrid.getStore().getAt(rowIndex).get("RowId");
			ItmToPayStore.removeAll();
			ItmToPayStore.load();
		});

	/*
	 * �ݴ�����(���ݴ洢��)
	 * StoreId - �洢��
	 * */
	function StoreItmData(StoreId)
	{	
		var RowDataBlock=50; //����	
		if (StoreId!="") 
		{
			var ListDetail="";
			var rowCnt=0;
			var rowCount = ItmToPayGrid.getStore().getCount();
			for (var i = 0; i < rowCount; i++) {			
				var sm=ItmToPayGrid.getSelectionModel();
				if(sm.isSelected(i)==true){
					var rowData = ItmToPayGrid.store.getAt(i);	
					var pointer=rowData.get("ingri");
					var inci=rowData.get("inci");
					var recAmt=rowData.get("rpAmt");
					var payAmt=rowData.get("amt");
					//var disc=rowData.get("disc");
					var disc="" ;
					var type=rowData.get("type");
	   
					var str =""+ "^" + pointer + "^" + inci + "^"+ recAmt + "^" + payAmt + "^"+disc+ "^"+ type;
				
					if(ListDetail==""){	ListDetail=str;	}
					else {ListDetail=ListDetail+xRowDelim()+str;}
					
					rowCnt=rowCnt++;
					if (rowCnt==RowDataBlock)
					{
						SendToStoreData(StoreId,ListDetail);
						//alert(ListDetail);
						rowCnt=0;   //����
						ListDetail="";
					}
					
				}
			}
			//alert(ListDetail);
			if (ListDetail!="")  //����һ��
			{ 
				SendToStoreData(StoreId,ListDetail);	
				//alert(ListDetail);	
				}
			}

	}
	//����GridPanelѡ�е�����
	function getSelectedCount(grid) 
	{
		if (grid)
		{return grid.getSelectionModel().getCount();}
		else
		{return 0;}
	}
	  
	/*���� */
	function Save()
	{
		
		saveOK=true;
		var verdorCount=getSelectedCount(vendorListGrid);
		if (verdorCount==0){saveOK=false;Msg.info("warning","δѡ��Ӧ��!");return;}
		var selectedCount=getSelectedCount(ItmToPayGrid);
		if (selectedCount==0){saveOK=false;Msg.info("warning","δѡ�񵥾�!");return;}
		var loc=payLocRowId; 
		var vendor=gVendorRowId;
		var poisonFlag=(Ext.getCmp('PoisonFlagR').getValue()==true?'Y':'');
		Ext.Ajax.request({
			 url:URL+"?actiontype=UpdPay"+"&loc="+payLocRowId+'&vendor='+vendor+"&poison="+poisonFlag,    //ȡ���洢��
			 success: function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					var pay= jsonData.info;	
				    //������ϸ
					if (pay>0) {
						var rowCnt=0;
						var handledRowCnt=0;
						var rowCount = ItmToPayGrid.getStore().getCount();
						var detailDataStr="";
						for (var i = 0; i < rowCount; i++) {			
							var sm=ItmToPayGrid.getSelectionModel();
							if(sm.isSelected(i)==true){
								var rowData = ItmToPayGrid.store.getAt(i);	
								var pointer=rowData.get("ingri");
								var inci=rowData.get("inci");
								var recAmt=rowData.get("rpAmt");
								var payAmt=rowData.get("amt");
								var payi="";
								var disc="" ;
								var type=rowData.get("type");			   
								var detailData= pointer + "^" + inci + "^"+ recAmt + "^" + payAmt + "^"+disc+ "^"+ type;
								detailDataStr=(detailDataStr=="")?detailData:detailDataStr+"!!"+detailData;										
							}
						}
						if (detailDataStr==""){
							Msg.info('warning','�빴ѡ��Ҫ���������');
						}
						var saveRet=tkMakeServerCall("web.DHCST.DHCPayItm","UpdatePay",pay,detailDataStr);
						if (saveRet!=0){
							var saveArr=saveRet.split("^");
							if (saveArr[0]<0){
								Msg.info('warning',saveArr[1]);
								saveOK=false;
								ItmToPayStore.load();
								return;							
							}
						}
						if (saveOK==true)
						{
							payRowId=pay;
							FnR(pay);
							fromRecWindow.close();
						}
					}
					else
					{
						saveOK=false;
						saveBT.enable();
						Msg.info('error','�������ʧ��!');}
				}
				
				else
				{
					saveOK=false;
					saveBT.enable();
				 	Msg.info('error','�������ʧ��!')
				}
			 },
			failure:function(){
				saveOK=false;
				saveBT.enable();
				Msg.info('error','����ʧ��,������������!')
			}
		});
		
	}

	function fn()
	{
		if (saveOK==true)
		{
			alert('ˢ��')	;
		
		}

	}
	/*���Ͳ���������*/
	function SendToStoreData(StoreId,detailData)
	{
		Ext.Ajax.request({
			url:URL+'?actiontype=StorePayItm',
			method:"POST",
			params: {storeId:StoreId,detailData:detailData},
			success:function(result,request){
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if  (jsonData.success=='true')
				{	
					Execute(StoreId)   //ִ�б���
				}
			}
		});
	}

	/*ִ�б���*/
	function Execute(StoreId)
	{
		var VenId = gVendorRowId ;//��Ӧ��rowid	
		var LocId=payLocRowId ; //�������rowid
		var CreateUser = session['LOGON.USERID'];	;
		var PonFlag = (Ext.getCmp("PoisonFlagR").getValue()==true?'Y':'N');
		
		var MainInfo = VenId + "^" + LocId + "^" + CreateUser + "^" + PonFlag ;
		//alert(MainInfo);
		var url = URL+ "?actiontype=save&MainInfo=" + MainInfo+"&StoreId="+StoreId;
		
		Ext.Ajax.request({
			url : url,
			method : 'POST',
			waitMsg : '������...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON
						.decode(result.responseText);
				if (jsonData.success == 'true') {
					// ��ɵ���
					Msg.info("success", "���渶��ɹ�!");								
					ItmToPayGrid.store.reload();
					
				} else {
					var ret=jsonData.info;
					if(ret==-99){
						Msg.info("error", "����ʧ��,���ܱ���!");
					}else if(ret==-4){
						Msg.info("error", "���渶�������Ϣʧ��!");
					}else if(ret==-5){
						Msg.info("error", "���渶���ϸʧ��!");
					}else {
						Msg.info("error", "������ϸ���治�ɹ���"+ret);
					}
					
				}
			},
			scope : this
		});

	}

	var fromRecList = new Ext.form.FormPanel({
		labelWidth : 60,
		region:"north",
		labelAlign : 'right',
		frame : true,
		bodyStyle : 'padding:5px;',
		tbar : [SearchBTR, '-', ClearBTR,'-',saveBTR,'-',CancelBTR],
		layout: 'fit',	
	    items : [{
			layout: 'column',    // Specifies that the items will now be arranged in columns
			items:[{ 	
				title:'��ѯ����',			
				columnWidth: 0.7,
	        	xtype: 'fieldset',		            	
	        	defaultType: 'textfield',
	        	defaults: {border:false},
	        	layout: 'column', 
	        	items: [{ 				
					columnWidth: 0.3,
		        	xtype: 'fieldset',		            	
		        	defaultType: 'textfield',
		        	items: [StartDateR]
				},{ 				
					columnWidth: 0.3,
		        	xtype: 'fieldset',		            	
		        	defaultType: 'textfield',
		        	items: [EndDateR]
				},{ 				
					columnWidth: 0.4,
		        	xtype: 'fieldset',		            	
		        	defaultType: 'textfield',
		        	items: [VendorR]
				}]
			},{ 	
				title:'��ⵥ��Ϣ',			
				columnWidth: 0.3,
	        	xtype: 'fieldset',		            	
	        	defaultType: 'textfield',
	        	defaults: {border:false},
	        	layout: 'column', 
	        	items: [{ 				
					columnWidth: 0.6,
		        	xtype: 'fieldset',		            	
		        	defaultType: 'textfield',
		        	items: [payTotalAmtR]
				},{ 				
					columnWidth: 0.4,
		        	xtype: 'fieldset',		            	
		        	defaultType: 'textfield',
		        	items: [PoisonFlagR]
				}]
			}]
	    }]

	});
	
	var fromRecWindow = new Ext.Window({
		title:'���/�˻�������',
		width : document.body.clientWidth*0.9,
		height : document.body.clientHeight*0.9,
		layout : 'border',
		plain:true,
		modal:true,
		items:[
			{
	            region: 'north',
	            height: DHCSTFormStyle.FrmHeight(1)-28, 
	            layout: 'fit',
	            items:fromRecList
	        }, {
	            region: 'west',			               
	            layout: 'fit', 
	            width:300,
	            items: vendorListGrid       
	        }, {
	            region: 'center',		
	            	               
	            layout: 'fit', 
	            items: ItmToPayGrid       
           
	        }
        ] 
	});
	fromRecWindow.show();
}