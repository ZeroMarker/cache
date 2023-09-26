///描述: 付款单制单
///编写者：gwj
///编写日期: 2012.09.24
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
		displayMsg:'显示第{0}到{1}条记录，一共{2}条',	
		emptyMsg:"没有记录"
	});

	var nm = new Ext.grid.RowNumberer();
	var vendorListCM=new Ext.grid.ColumnModel([nm,
		{
			header:'RowId',
			dataIndex:'RowId',
			hidden:true
		},
		{
			header:'供应商名称',
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


	// 供货厂商
	var VendorR = new Ext.ux.VendorComboBox({
		fieldLabel : '供应商',
		id : 'VendorR',
		name : 'VendorR',
		anchor : '90%',
		emptyText : '供应商...'
	});
		
	 

	// 起始日期
	var StartDateR = new Ext.ux.DateField({
		fieldLabel : '起始日期',
		id : 'StartDateR',
		name : 'StartDateR',
		anchor : '90%',
		width : 120,
		value : new Date().add(Date.DAY, - 30)
	});

	// 截止日期
	var EndDateR = new Ext.ux.DateField({
		fieldLabel : '截止日期',
		id : 'EndDateR',
		name : 'EndDateR',
		anchor : '90%',
		width : 120,
		value : new Date()
	});
		
	var payNoR=new Ext.form.TextField({
		fieldLabel : '付款单号',
		id : 'payNoR',
		name : 'payNoR',
		anchor : '90%',
		disabled:true,
		width : 120
	});

	//毒麻标志
	var PoisonFlagR = new Ext.form.Checkbox({
		fieldLabel : '毒麻标志',
		id : 'PoisonFlagR',
		name : 'PoisonFlagR',
		anchor : '90%',
		checked : false
	});

	//本次付款金额
	var payTotalAmtR=new Ext.form.TextField(
	{
		fieldLabel:'付款总额',
		id:'totalAmtR',
		anchor : '90%',
		disabled:true

	})

	// 查询按钮
	var SearchBTR = new Ext.Toolbar.Button({
		text : '查询',
		tooltip : '点击查询',
		width : 70,
		height : 30,
		iconCls : 'page_find',
		handler : function() {
			Query();
		}
	});
	// 清空按钮
	var ClearBTR = new Ext.Toolbar.Button({
		text : '清屏',
		tooltip : '点击清屏',
		width : 70,
		height : 30,
		iconCls : 'page_clearscreen',
		handler : function() {
			clearData();
		}
	});

	// 确定按钮
	var saveBTR = new Ext.Toolbar.Button({
		text : '保存付款单',
		tooltip : '点击保存',
		width : 70,
		height : 30,
		iconCls : 'page_save',
		handler : function() {
			Save();
		}
	});
	// 取消按钮
	var CancelBTR = new Ext.Toolbar.Button({
		text : '关闭',
		tooltip : '点击退出本窗口',
		width : 70,
		height : 30,
		iconCls : 'page_close',
		handler : function() {
			fromRecWindow.close();
		}
	});


	/**
	 * 查询方法
	 */
	function Query() {
		if (payLocRowId == null || payLocRowId.length <= 0) {
			Msg.info("warning", "请选择入库科室!");
			return;
		}
	    VendorToPayStore.removeAll();
	    ItmToPayStore.removeAll();
	    VendorToPayStore.load();
	}


	/**
	 * 清空方法
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

		
	// 访问路径
	var ItmToPayUrl = URL	+ '?actiontype=queryItmToPay';

	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
		url : ItmToPayUrl,
		method : "POST"
		});
	// 指定列参数
	var fields = ['RowId','No','gdDate','gdTime','gdAuditUserName','ingri','inclb','inci',
	'inciCode','inciDesc','spec','manf','uomDesc','qty','rp','rpAmt','sp','spAmt',
	'payedAmt','restAmt',{name:'amt',mapping:'amt',type:'float'},'invNo','invAmt','invDate','sxNo','batNo','expDate','type','poison'];


	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "pay",
		fields : fields
	});

	// 数据集
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
					rec.set('amt',toBePayAmt);  //使用<待付款金额>填充
					rec.commit();
				}
				ManuOp=false;
				TotalAmt(); 
				CheckPoison();
				
				
			},
			'rowdeselect':function(t,ind,rec)
			{
				var toBePayAmt=rec.get('restAmt');
				rec.set('amt','');  //取消使用<待付款金额>填充
				rec.commit();
				TotalAmt();
				CheckPoison();
			}
		}
	});

	/*计算总金额*/
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
	//检查是否包含毒麻药品
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
			header : "单号",
			align : 'left',
			dataIndex : 'No',
			editable:false,
			width:120	
		}, 
		{
			header : '类型',
			dataIndex : 'type',	
			align : 'left',
			width:50,
			editable:false
		},
		{
			header : '付款金额',
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
			header : "日期",   //审核日期
			dataIndex : 'gdDate',
			align : 'left',
			editable:false
		}, 
	 	{
			header : "时间",  //审核时间
			dataIndex : 'gdTime',
			align : 'left',
			width:50,
			editable:false
		}, 
	 	{
			header : "审核人",
			dataIndex : 'gdAuditUserName',
			align : 'left',
			editable:false
		}, 
	 	{
			header : "明细rowid",
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
			header : "代码",
			dataIndex : 'inciCode',
			editable:false
		}, 			
		{
			header : "名称",
			dataIndex : 'inciDesc'	,
			width:200,
			editable:false
		}, 							
								
	 	{
			header : '规格',
			dataIndex : 'spec',	
			width:80,
			editable:false
		}, 		
		 	{
			header : '厂商',
			dataIndex : 'manf'	
		}, 		
		 	{
			header : '单位',
			dataIndex : 'uomDesc',
			editable:false	
		}, 	
		{
			header : '数量',
			dataIndex : 'qty',	
			align : 'right',
			editable:false
		}, 		
		 		 	{
			header : '进价',
			dataIndex : 'rp',
			align : 'right',
			editable:false
		}, 	
		 		{
			header : '进价金额',
			dataIndex : 'rpAmt'	,
			align : 'right',
			editable:false
		}, 		
		 	{
			header : '售价',
			dataIndex : 'sp',	
			align : 'right',
			editable:false,
			editable:false
		}, 	{
			header : '售价金额',
			dataIndex : 'spAmt'	,
			align : 'right',
			editable:false
		},
			{
			header : '已付金额',
			align : 'right',
			dataIndex : 'payedAmt'	,
			editable:false
		}, 		
			{
			header : '待付金额',
			align : 'right',
			dataIndex : 'restAmt',
			editable:false
		}, 		
		 		{
			header : '发票号',
			dataIndex : 'invNo'	
		}, 		
		 	{
			header : '发票金额',
			dataIndex : 'invAmt',	
			align : 'right',
			editable:false
		}, 		
		 	{
			header : '发票日期',
			dataIndex : 'invDate',
			align : 'left',
			editable:false
		}, 	{
			header : '随行单',
			dataIndex : 'sxNo'	
		}, 		
		 	{
			header : '批号',
			dataIndex : 'batNo'	,
			editable:false
		}, 		
		 	{
			header : '有效期',
			dataIndex : 'expDate',	
			align : 'left',
			editable:false
		}, 		
		 	{
			header : '毒麻标记',
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
	 * 暂存数据(根据存储号)
	 * StoreId - 存储号
	 * */
	function StoreItmData(StoreId)
	{	
		var RowDataBlock=50; //行数	
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
						rowCnt=0;   //清零
						ListDetail="";
					}
					
				}
			}
			//alert(ListDetail);
			if (ListDetail!="")  //最后的一批
			{ 
				SendToStoreData(StoreId,ListDetail);	
				//alert(ListDetail);	
				}
			}

	}
	//返回GridPanel选中的行数
	function getSelectedCount(grid) 
	{
		if (grid)
		{return grid.getSelectionModel().getCount();}
		else
		{return 0;}
	}
	  
	/*保存 */
	function Save()
	{
		
		saveOK=true;
		var verdorCount=getSelectedCount(vendorListGrid);
		if (verdorCount==0){saveOK=false;Msg.info("warning","未选择供应商!");return;}
		var selectedCount=getSelectedCount(ItmToPayGrid);
		if (selectedCount==0){saveOK=false;Msg.info("warning","未选择单据!");return;}
		var loc=payLocRowId; 
		var vendor=gVendorRowId;
		var poisonFlag=(Ext.getCmp('PoisonFlagR').getValue()==true?'Y':'');
		Ext.Ajax.request({
			 url:URL+"?actiontype=UpdPay"+"&loc="+payLocRowId+'&vendor='+vendor+"&poison="+poisonFlag,    //取出存储号
			 success: function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					var pay= jsonData.info;	
				    //保存明细
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
							Msg.info('warning','请勾选需要保存的数据');
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
						Msg.info('error','主表更新失败!');}
				}
				
				else
				{
					saveOK=false;
					saveBT.enable();
				 	Msg.info('error','主表更新失败!')
				}
			 },
			failure:function(){
				saveOK=false;
				saveBT.enable();
				Msg.info('error','更新失败,请检查网络连接!')
			}
		});
		
	}

	function fn()
	{
		if (saveOK==true)
		{
			alert('刷新')	;
		
		}

	}
	/*发送并保存数据*/
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
					Execute(StoreId)   //执行保存
				}
			}
		});
	}

	/*执行保存*/
	function Execute(StoreId)
	{
		var VenId = gVendorRowId ;//供应商rowid	
		var LocId=payLocRowId ; //付款科室rowid
		var CreateUser = session['LOGON.USERID'];	;
		var PonFlag = (Ext.getCmp("PoisonFlagR").getValue()==true?'Y':'N');
		
		var MainInfo = VenId + "^" + LocId + "^" + CreateUser + "^" + PonFlag ;
		//alert(MainInfo);
		var url = URL+ "?actiontype=save&MainInfo=" + MainInfo+"&StoreId="+StoreId;
		
		Ext.Ajax.request({
			url : url,
			method : 'POST',
			waitMsg : '更新中...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON
						.decode(result.responseText);
				if (jsonData.success == 'true') {
					// 完成单据
					Msg.info("success", "保存付款单成功!");								
					ItmToPayGrid.store.reload();
					
				} else {
					var ret=jsonData.info;
					if(ret==-99){
						Msg.info("error", "加锁失败,不能保存!");
					}else if(ret==-4){
						Msg.info("error", "保存付款单主表信息失败!");
					}else if(ret==-5){
						Msg.info("error", "保存付款单明细失败!");
					}else {
						Msg.info("error", "部分明细保存不成功："+ret);
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
				title:'查询条件',			
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
				title:'入库单信息',			
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
		title:'入库/退货单付款',
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