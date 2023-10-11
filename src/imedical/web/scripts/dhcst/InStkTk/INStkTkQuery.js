// /����: �̵㵥��ѯ
// /����: �̵㵥��ѯ
// /��д�ߣ�zhangdongmei
// /��д����: 2012.09.03
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gIncId="";
	var url=DictUrl+'instktkaction.csp';
	var gGroupId=session["LOGON.GROUPID"];
	
	var PhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : $g('����'),
				id : 'PhaLoc',
				name : 'PhaLoc',
				anchor : '90%',
				width : 140,
				emptyText : $g('����...'),
				groupId:gGroupId
			});
	
	var Complete=new Ext.form.Checkbox({
		fieldLabel:$g('�������'),
		id:'Complete',
		name:'Complete',
		width:80,
		disabled:false
	});
	
	var TkComplete=new Ext.form.Checkbox({
		fieldLabel:$g('ʵ�����'),
		id:'TkComplete',
		name:'TkComplete',
		width:80,
		disabled:false
	});
	
	var AdjComplete=new Ext.form.Checkbox({
		fieldLabel:$g('�������'),
		id:'AdjComplete',
		name:'AdjComplete',
		width:80,
		disabled:false
	});
	
	
	
	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
				fieldLabel : $g('��ʼ����'),
				id : 'StartDate',
				name : 'StartDate',
				anchor : '90%',
				width : 80,
				value : new Date().add(Date.DAY, - 30)
			});

	// ��������
	var EndDate = new Ext.ux.DateField({
				fieldLabel : $g('��������'),
				id : 'EndDate',
				name : 'EndDate',
				anchor : '90%',
				width : 80,
				value : new Date()
			});
			// ��水ť
	var SaveAsBT = new Ext.Toolbar.Button({
				text : $g('���'),
				tooltip :$g( '���ΪExcel'),
				iconCls : 'page_excel',
				width : 70,
				height : 30,
				handler : function() {
					ExportAllToExcel(InstDetailGrid);
				}
			});
	// ��ѯ��ť
	var QueryBT = new Ext.Toolbar.Button({
				text : $g('��ѯ'),
				tooltip : $g('�����ѯ'),
				iconCls : 'page_find',
				width : 70,
				height : 30,
				handler : function() {
					Query();
				}
			});
	
	//��ѯ�̵㵥
	function Query(){
	
		var StartDate = Ext.getCmp("StartDate").getValue().format(App_StkDateFormat).toString();;
		var EndDate = Ext.getCmp("EndDate").getValue().format(App_StkDateFormat).toString();
		var PhaLoc = Ext.getCmp("PhaLoc").getValue();	
		if(PhaLoc==""){
			Msg.info("warning", $g("��ѡ���̵����!"));
			return;
		}
		if(StartDate==""||EndDate==""){
			Msg.info("warning",$g( "��ѡ��ʼ���ںͽ�ֹ����!"));
			return;
		}
		var CompFlag=(Ext.getCmp('Complete').getValue()==true?'Y':'');
		var TkComplete=(Ext.getCmp('TkComplete').getValue()==true?'Y':'');;  //ʵ����ɱ�־
		var AdjComplete=(Ext.getCmp('AdjComplete').getValue()==true?'Y':'');;	//������ɱ�־
		var Page=GridPagingToolbar.pageSize;
		var StrParams=PhaLoc+'^'+StartDate+'^'+EndDate+'^'+CompFlag+'^'+TkComplete+'^'+AdjComplete;
		MasterInfoStore.setBaseParam('actiontype','Query');
		MasterInfoStore.setBaseParam('Params',StrParams);
		MasterInfoStore.load({params:{start:0, limit:Page,sort:'instNo',dir:'asc'}});
		InstDetailGrid.store.removeAll();
		InstDetailGrid.getView().refresh();
	}
	
	// ��հ�ť
	var RefreshBT = new Ext.Toolbar.Button({
				text : $g('����'),
				tooltip : $g('�������'),
				iconCls : 'page_clearscreen',
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
		
		gStrParams='';
		Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, - 30));
		Ext.getCmp("EndDate").setValue(new Date());
		Ext.getCmp("Complete").setValue(false);
		Ext.getCmp("TkComplete").setValue(false);
		Ext.getCmp("AdjComplete").setValue(false);
		Ext.getCmp("freezeZero").setValue(true);
		Ext.getCmp("countZero").setValue(true);
		Ext.getCmp("all").setValue(true);
		Ext.getCmp("InciDesc").setValue("");
		SetLogInDept(PhaDeptStore, "PhaLoc");
		gIncId="";
		
		MasterInfoGrid.store.removeAll();
	       MasterInfoGrid.store.load({params:{start:0,limit:0}});
		//MasterInfoGrid.getView().refresh();
		
		InstDetailGrid.store.removeAll();
	       InstDetailGrid.store.load({params:{start:0,limit:0}});
		//InstDetailGrid.getView().refresh();
	}

	// ָ���в���
	var fields = ["inst","instNo", "date", "time","userName","status","locDesc", "comp", "stktkComp",
			"adjComp","adj","manFlag","freezeUom","includeNotUse","onlyNotUse","scgDesc","scDesc","frSb","toSb"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "inst",
				fields : fields
			});
	// ���ݼ�
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : url,
				method : "POST"
			});
	var MasterInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});	
	
	function renderCompFlag(value){
		if(value=='Y'){
			return $g('���');
		}else{
			return $g('δ���')
		}	
	}
	function renderManaFlag(value){
		if(value=='Y'){
			return $g('����ҩ');
		}else{
			return $g('�ǹ���ҩ')
		}	
	}
	function renderYesNo(value){
		if(value=='Y'){
			return $g('��');
		}else{
			return $g('��')
		}	
	}
	var nm = new Ext.grid.RowNumberer();
	var MasterInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "RowId",
				dataIndex : 'inst',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true,
				hideable : false
			}, {
				header : $g("�̵㵥��"),
				dataIndex : 'instNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : $g("�̵�����"),
				dataIndex : 'date',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g('�̵�ʱ��'),
				dataIndex : 'time',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g('�̵���'),
				dataIndex : 'userName',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : $g('������ɱ�־'),
				dataIndex : 'comp',
				width : 100,
				align : 'center',
				renderer:renderCompFlag,
				sortable : true
			}, {
				header : $g('ʵ����ɱ�־'),
				dataIndex : 'stktkComp',
				width : 100,
				align : 'center',
				renderer:renderCompFlag,
				sortable : true
			}, {
				header : $g('������ɱ�־'),
				dataIndex : 'adjComp',
				width : 100,
				align : 'center',
				renderer:renderCompFlag,
				sortable : true
			}, {
				header : $g('����ҩ��־'),
				dataIndex : 'manFlag',
				width : 80,
				align : 'left',
				renderer:renderManaFlag,
				sortable : true
			}, {
				header : $g("���̵�λ"),
				dataIndex : 'freezeUom',
				width : 80,
				align : 'left',
				renderer:function(value){
					if(value==1){
						return $g('��ⵥλ');
					}else{
						return $g('������λ');
					}
				},
				sortable : true
			}, {
				header : $g("����������"),
				dataIndex : 'includeNotUse',
				width : 80,
				align : 'left',
				renderer:renderYesNo,
				sortable : true
			}, {
				header : $g("��������"),
				dataIndex : 'onlyNotUse',
				renderer:renderYesNo,
				width : 60,
				align : 'right',
				sortable : true
			}, {
				header : $g("����"),
				dataIndex : 'scgDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g("������"),
				dataIndex : 'scDesc',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : $g("��ʼ��λ"),
				dataIndex : 'frSb',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : $g("��ֹ��λ"),
				dataIndex : 'toSb',
				width : 100,
				align : 'right',
				sortable : true
			}]);
	MasterInfoCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
					store : MasterInfoStore,
					pageSize : PageSize,
					displayInfo : true,
					displayMsg : $g('��ǰ��¼ {0} -- {1} �� �� {2} ����¼'),
					emptyMsg : "No results to display",
					prevText : $g("��һҳ"),
					nextText : $g("��һҳ"),
					refreshText : $g("ˢ��"),
					lastText :$g( "���ҳ"),
					firstText : $g("��һҳ"),
					beforePageText : $g("��ǰҳ"),
					afterPageText : $g("��{0}ҳ"),
					emptyMsg : $g("û������")
				});
	var MasterInfoGrid = new Ext.grid.GridPanel({
				id : 'MasterInfoGrid',
				title : '',
				height : 170,
				cm : MasterInfoCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				store : MasterInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:[GridPagingToolbar]
			});
	
	MasterInfoGrid.on('rowclick',function(grid,rowindex,e){
		INStkTkFilter();
	});
			
	var nm = new Ext.grid.RowNumberer();
	var InstDetailGridCm = new Ext.grid.ColumnModel([nm, {
				header : "rowid",
				dataIndex : 'rowid',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			},{
				header:"inclb",
				dataIndex:'inclb',
				width:80,
				align:'left',
				sortable:true,
				hidden:true				
			},{
				header : $g('����'),
				dataIndex : 'code',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : $g("����"),
				dataIndex : 'desc',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : $g("���"),
				dataIndex : 'spec',
				width : 80,
				align : 'left',
				sortable : true
			},{
				header:$g('����'),
				dataIndex:'batchNo',
				width:80,
				align:'left',
				sortable:true
			}, {
				header:$g('Ч��'),
				dataIndex:'expDate',
				width:100,
				align:'left',
				sortable:true
			}, {
				header : $g("��λ"),
				dataIndex : 'uomDesc',
				width : 60,
				align : 'left',
				sortable : true
			}, {
				header : $g('��������'),
				dataIndex : 'freQty',
				width : 80,
				align : 'right',
				sortable : true
			},{
				header:$g('ʵ������'),
				dataIndex:'countQty',
				width:80,
				align:'right',
				sortable:true				
			},{
				header : $g("������ҵ"),
				dataIndex : 'manf',
				width : 140,
				align : 'left',
				sortable : true
			},{
				header:$g('��������'),
				dataIndex:'freDate',
				width:80,
				align:'left',
				sortable:true
			},{
				header:$g('����ʱ��'),
				dataIndex:'freTime',
				width:80,
				align:'left',
				sortable:true
			},{
				header:$g('ʵ������'),
				dataIndex:'countDate',
				width:80,
				align:'left',
				sortable:true
			},{
				header : $g("ʵ��ʱ��"),
				dataIndex : 'countTime',
				width : 80,
				align : 'left',
				sortable : true
			},{
				header:$g('ʵ����'),
				dataIndex:'countPersonName',
				width:80,
				align:'left',
				sortable:true
			},{
				header:$g('���̽��۽��'),
				dataIndex:'freezeRpAmt',
				width:120,
				align:'right',
				sortable:true
			},{
				header:$g('ʵ�̽��۽��'),
				dataIndex:'countRpAmt',
				width:120,
				align:'right',
				sortable:true
			},{
				header:$g('�����ۼ۽��'),
				dataIndex:'freezeSpAmt',
				width:120,
				align:'right',
				sortable:true
			},{
				header:$g('ʵ���ۼ۽��'),
				dataIndex:'countSpAmt',
				width:120,
				align:'right',
				sortable:true
			},{
				header:$g('���۲��'),
				dataIndex:'varianceRpAmt',
				width:120,
				align:'right',
				sortable:true
			},{
				header:$g('�ۼ۲��'),
				dataIndex:'varianceSpAmt',
				width:120,
				align:'right',
				sortable:true
			}]);
	InstDetailGridCm.defaultSortable = true;

	// ���ݼ�
	var InstDetailStore = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({
					url : url,
					method : "POST"
				}),
				reader :  new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "instw",
					fields : ["rowid","inclb", "inci", "code", "desc","spec", "manf", "batchNo", "expDate",
							"freQty", "uom", "uomDesc", "countQty","freDate","freTime",
							"countDate","countTime","countPersonName","variance","sp","rp","freezeSpAmt","freezeRpAmt","countSpAmt",
							"countRpAmt","varianceSpAmt","varianceRpAmt"]
				}),
				remoteSort:true,
				baseParams:{Parref:'',Params:''}
	});

	var StatuTabPagingToolbar = new Ext.PagingToolbar({
				store : InstDetailStore,
				pageSize : PageSize,
				displayInfo : true,
				displayMsg : $g('��ǰ��¼ {0} -- {1} �� �� {2} ����¼'),
				emptyMsg : "No results to display",
				prevText : $g("��һҳ"),
				nextText : $g("��һҳ"),
				refreshText : $g("ˢ��"),
				lastText : $g("���ҳ"),
				firstText : $g("��һҳ"),
				beforePageText : $g("��ǰҳ"),
				afterPageText : $g("��{0}ҳ"),
				emptyMsg : $g("û������")
			});
	
	var InciDesc = new Ext.form.TextField({
					fieldLabel :$g( 'ҩƷ����'),
					id : 'InciDesc',
					name : 'InciDesc',
					//anchor : '90%',
					width : 200,
					listeners : {
						specialkey : function(field, e) {
							var keyCode=e.getKey();
							if ( keyCode== Ext.EventObject.ENTER) {
								GetPhaOrderInfo(field.getValue(),'');
							}
						}
					}
				});

				/**
		 * ����ҩƷ���岢���ؽ��
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
			var inciCode=record.get("InciCode");
			var inciDesc=record.get("InciDesc");
			;
			Ext.getCmp("InciDesc").setValue(inciDesc);
			//Ext.getCmp('InciDr').setValue(inciDr);			
			;			
		}
	
	var Filter = new Ext.Toolbar.Button({
		id:'Filter',
		name:'Filter',
		text:'',
		iconCls:'page_find',
		handler:function(){
				INStkTkFilter();			
			}
	});
	
	function INStkTkFilter(){
		var record=MasterInfoGrid.getSelectionModel().getSelected();
		if(record){
			var Rowid=record.get('inst');
			var size=StatuTabPagingToolbar.pageSize;
			if(Ext.getCmp("InciDesc").getValue()==""){
				gIncId="";
			}
			//0:ȫ��,1:����ӯ,2:���̿�,3:��������,4:��������
			var statFlag=0;
			if(Ext.getCmp("onlySurplus").getValue()==true){
				statFlag=1;
			}else if(Ext.getCmp("onlyLoss").getValue()==true){
				statFlag=2;
			}else if(Ext.getCmp("onlyBalance").getValue()==true){
				statFlag=3;
			}else if(Ext.getCmp("onlyNotBalance").getValue()==true){
				statFlag=4;
			}
			//����Ϊ0
			var freezeZeroFlag=(Ext.getCmp("freezeZero").getValue()==true)?'Y':'N';
			//ʵ��Ϊ0
			var countZeroFlag=(Ext.getCmp("countZero").getValue()==true)?'Y':'N';
			InstDetailStore.setBaseParam('actiontype','QueryDetail');
			InstDetailStore.setBaseParam('Parref',Rowid);
			InstDetailStore.setBaseParam('Params',statFlag+"^"+gIncId+"^"+freezeZeroFlag+"^"+countZeroFlag);
			InstDetailStore.setBaseParam('sort','rowid');
			InstDetailStore.setBaseParam('dir','ASC');
			InstDetailStore.removeAll();
			InstDetailStore.load({params:{start:0,limit:size,sort:'rowid',dir:'ASC'}});	
		}
	}
	
	var InstDetailGrid = new Ext.grid.GridPanel({
				id:'InstDetailGrid',
				region : 'center',
				cm : InstDetailGridCm,
				store : InstDetailStore,
				trackMouseOver : true,
				stripeRows : true,
				title:$g('��ϸ'),
				sm : new Ext.grid.RowSelectionModel(),
				loadMask : true,
				bbar : StatuTabPagingToolbar,
				tbar:[
				{xtype:'radio',boxLabel:$g('����ӯ'),name:'loss',id:'onlySurplus',inputValue:1,width:'70px'},
				{xtype:'radio',boxLabel:$g('���̿�'),name:'loss',id:'onlyLoss',inputValue:2,width:'70px'},
				{xtype:'radio',boxLabel:$g('��������'),name:'loss',id:'onlyBalance',inputValue:3,width:'85px'},
				{xtype:'radio',boxLabel:$g('��������'),name:'loss',id:'onlyNotBalance',inputValue:4,width:'85px'},
				{xtype:'radio',boxLabel:$g('ȫ��'),name:'loss',inputValue:0,id:'all',checked:true,width:'60px'},
				'-',
				{xtype:'checkbox',boxLabel:$g('���̷���'),id:'freezeZero',checked:'true',width:'85px'},
				{xtype:'checkbox',boxLabel:$g('ʵ�̷���'),id:'countZero',checked:'true',width:'85px'},
				'-',
				$g("ҩƷ����"),InciDesc,
				Filter
				]
			});
	   
		var form = new Ext.form.FormPanel({
			labelwidth : 30,
			width : 400,
			labelAlign : 'right',
			frame : true,
			//bodyStyle : 'padding:10px 0px 0px 0px;',
			style: 'padding:0 0 0 0;',
			tbar:[QueryBT,'-',RefreshBT,'-',SaveAsBT],
			items:[{
					xtype:'fieldset',
					title:$g('��ѯ����'),
					style: 'padding:5px 0 0 0;',
					defaults:{width:160},
					items : [PhaLoc,StartDate,EndDate,Complete,TkComplete,AdjComplete]				
					
				}]  	
		});
	
		// 5.2.ҳ�沼��
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [{
			                region: 'west',
			                split: true,
			                collapsible: true, 
			                title:$g('�̵㵥(����)��ѯ'),
                			width: 300,  
                			minSize:250,
                			maxSize:400,              			
			                layout: 'border', // specify layout manager for items
			                items: [{
				                region: 'north',
				                split: false,
	                			height: DHCSTFormStyle.FrmHeight(6)-28,                			
				                layout: 'fit', // specify layout manager for items
				                items: form 				               
				            },{
			                	region:'center',
			                	layout:'fit',
			                	items:MasterInfoGrid 
			                }]     
			               
			            }, {             
			                region: 'center',	              
		                	layout:'fit',
		                	items:[InstDetailGrid]		                	
			            }
	       			],
					renderTo : 'mainPanel'
		});
		
})