// /����:��ҩסԺ��ѯ
// /����: ��ҩסԺ��ѯ
// /��д�ߣ�wyx
// /��д����: 2014.11.03
var SDate
var STime
var EDate
var ETime
var SPrescno
var SState
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	//if(gParam.length<1){
	//	GetParam();  //��ʼ����������
	//}
	ChartInfoAddFun();
	function ChartInfoAddFun() {

		
		// ��ʼ����
		var StartDate = new Ext.ux.DateField({
					fieldLabel : '��ʼ����',
					id : 'StartDate',
					name : 'StartDate',
					anchor : '90%',
					format : 'Y-m-d',
					width : 100,
					value : DefaultStDate()
				});
	  var StartTime=new Ext.form.TextField({
		 fieldLabel : '<font color=blue>��ʼʱ��</font>',
		id : 'StartTime',
		name : 'StartTime',
		anchor : '90%',
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:'ʱ���ʽ������ȷ��ʽhh:mm:ss',
		width : 120
	  });

		// ��ֹ����
		var EndDate = new Ext.ux.DateField({
					fieldLabel : '��ֹ����',
					id : 'EndDate',
					name : 'EndDate',
					anchor : '90%',
					format : 'Y-m-d',
					width : 100,
					value : DefaultEdDate()
				});
	var EndTime=new Ext.form.TextField({
		fieldLabel : '<font color=blue>��ֹʱ��</font>',
		id : 'EndTime',
		name : 'EndTime',
		anchor : '90%',
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:'ʱ���ʽ������ȷ��ʽhh:mm:ss',
		width : 120
	});
		

	   var Prescno = new Ext.form.TextField({		
					fieldLabel : '������',
					id : 'Prescno',
					name : 'Prescno',
					anchor : '90%',
					width : 140
	   })
	   //var MBCUser = new Ext.ux.DoctorDsComboBox({		
					//fieldLabel : '������',
					//id : 'MBCUser',
					//name : 'MBCUser',
					//anchor : '90%'
	  // })
		     // ��ҩ����Ա
           var MBCUser = new Ext.ux.MBCUserComboBox({
					fieldLabel : '������',
					id : 'MBCUser',
					name : 'MBCUser',
					anchor : '90%'
		});
		Ext.getCmp("MBCUser").setValue('');
					//����
	var LocWard=new Ext.ux.LocWardComboBox({
		id : 'LocWard',
		name : 'LocWard',
		anchor:'90%'
	});

	      //ִ�п���
           //var LocWard = new Ext.ux.ExeLocComboBox({
		//			fieldLabel : '����',
		//			id : 'LocWard',
		//			name : 'LocWard',
		//			anchor : '90%'
		//});
	 /*     //��ҩ״̬

	  var MBCState = new Ext.ux.form.LovCombo({
		id : 'MBCState',
		name : 'MBCState',
		fieldLabel : '��ҩ״̬',
		//listWidth : 100,
		anchor: '90%',
		//labelStyle : "text-align:left;width:100;",
		labelSeparator : '',
		separator:'^',	//����id��^����
		hideOnSelect : false,
		//maxHeight : 200,
		editable:false,
		store : GetMBCStateStore ,
		valueField : 'RowId',
		displayField : 'Description',
		triggerAction : 'all'
	});
	*/
		// ��ѯ��ť
		var SearchBT = new Ext.Toolbar.Button({
					id:"SearchBT",
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
		var ClearBT = new Ext.Toolbar.Button({
					id:'ClearBT',
					text : '���',
					tooltip : '������',
					width : 70,
					height : 30,
					iconCls : 'page_refresh',
					handler : function() {
						clearData();
					}
				});

		// ��ӡ��ť
		var PrintBT = new Ext.Toolbar.Button({
					id:'PrintBT',
					text : '��ӡ',
					tooltip : '�����ӡ',
					width : 70,
					height : 30,
					iconCls : 'page_print',
					handler : function() {
					 var MBCUser=Ext.getCmp("MBCUser").getValue();
                                    var LocWard=Ext.getCmp("LocWard").getValue();
						PrintJYInpha(LocWard,MBCUser,SDate,STime,EDate,ETime,SPrescno,SState);
					}
				});
				
		/**
		 * ��ѯ����
		 */
		function Query() {

                     var StartDate = Ext.getCmp("StartDate").getValue();
			if(StartDate!=""){
				StartDate=StartDate.format('Y-m-d');
			}else{
				Msg.info("warning","��ѡ��ʼ����!");
				return;
			}
			SDate=StartDate
			var StartTime = Ext.getCmp("StartTime").getValue();
			STime=StartTime
			var EndDate = Ext.getCmp("EndDate").getValue()
			if(EndDate!=""){
				EndDate=EndDate.format('Y-m-d');
			}else{
				Msg.info("warning","��ѡ���ֹ����!");
				return;
			}
			EDate=EndDate
			var EndTime = Ext.getCmp("EndTime").getValue()
                     ETime=EndTime
                     var MBCUser=Ext.getCmp("MBCUser").getValue();
                     var LocWard=Ext.getCmp("LocWard").getValue();
                     var Prescno=Ext.getCmp("Prescno").getValue();
                     SPrescno=Prescno
                     //var State=Ext.getCmp('MBCState').getValue();
                     var State="50" //��ҩ���״̬                     
			SState=State
			var ListParam=StartDate+'&'+StartTime+'&'+EndDate+'&'+EndTime+'&'+MBCUser+'&'+LocWard+'&'+Prescno+'&'+State
			
			var Page=GridPagingToolbar.pageSize;
			MasterStore.setBaseParam("ParamStr",ListParam);
			MasterStore.removeAll();
		       MasterStore.setBaseParam('start',0);
		       MasterStore.setBaseParam('limit',Page);
		       MasterStore.setBaseParam('actiontype','QueryInpha');
		       MasterStore.load();
		}

		/**
		 * ��շ���
		 */
		function clearData() {
			Ext.getCmp("StartDate").setValue(DefaultStDate());
			Ext.getCmp("EndDate").setValue(DefaultEdDate());
			MasterGrid.store.removeAll();
			
			PrintBT.setDisabled(true);
		}
 
		// ��Ϣ�б�
		// ����·��
		var MasterUrl = 'dhcst.mbccolldrugaction.csp?action=QueryInpha';;
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : MasterUrl,
					method : "POST"
				});

				// ָ���в���
		var fields = ["MBCId","LocWard","PatNo","MedNo","BedNo","PatName","Prescno","FsQty","State","dreat"];
		
		//
		              //"
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "MBCId",
					fields : fields
				});
		// ���ݼ�
		var MasterStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader,
					baseParams:{ParamStr:''}
				});
		
	var nm = new Ext.grid.RowNumberer();
	var MasterCm = new Ext.grid.ColumnModel([nm,{
        	header:"rowid",
        	dataIndex:'MBCId',
        	width:100,
        	align:'left',
        	sortable:true,
        	hidden:true
	 }, {
        	header:"����",
        	dataIndex:'LocWard',
        	width:100,
        	align:'left',
        	sortable:true
	 },{
        	header:"������",
        	dataIndex:'Prescno',
        	width:200,
        	align:'left',
        	sortable:true
	 },{
        	header:"�Ƿ��շ���",
        	dataIndex:'dreat',
        	width:200,
        	align:'left',
        	sortable:true
	 },{
        	header:"�ǼǺ�",
        	dataIndex:'PatNo',
        	width:200,
        	align:'left',
        	sortable:true
	 },{
        	header:"סԺ��",
        	dataIndex:'MedNo',
        	width:200,
        	align:'left',
        	sortable:true
	 },{
        	header:"����",
        	dataIndex:'BedNo',
        	width:200,
        	align:'left',
        	sortable:true
	 },{
        	header:"��������",
        	dataIndex:'PatName',
        	width:200,
        	align:'left',
        	sortable:true
	 },{
        	header:"����",
        	dataIndex:'FsQty',
        	width:200,
        	align:'left',
        	sortable:true
	 },{
        	header:"״̬",
        	dataIndex:'State',
        	width:200,
        	align:'left',
        	sortable:true
	 }
	]);
		MasterCm.defaultSortable = true;
		
		var GridPagingToolbar = new Ext.PagingToolbar({
			store:MasterStore,
			pageSize:PageSize,
			displayInfo:true,
			displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
			emptyMsg:"û�м�¼"
		});
		
		var MasterGrid = new Ext.grid.GridPanel({
					region : 'center',
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
	
	
	    //����Grid������ʾ����
	//Creator:wyx 2014-10-15
    MasterGrid.on('mouseover',function(e){
		
		var rowCount = MasterGrid.getStore().getCount();
		if (rowCount>0)
		{  
			var ShowInCellIndex=3;  //�ڵڼ�����ʾ
			var index = MasterGrid.getView().findRowIndex(e.getTarget());
			var record = MasterGrid.getStore().getAt(index);
			if (record)
			{
				var MBCId=record.data.MBCId;
				var Prescno=record.data.Prescno;
			}
			ShowAllMBCAcrtionWin(e,MasterGrid,ShowInCellIndex,Prescno,MBCId);
		}

	},this,{buffer:200});			
		
		var HisListTab = new Ext.form.FormPanel({
					labelwidth : 30,
					labelAlign : 'right',
					frame : true,
					title:'��ҩסԺ��ѯ',
					autoScroll : false,
					bodyStyle : 'padding:0px 0px 0px 0px;',					
					tbar : [SearchBT, '-', ClearBT, '-', PrintBT],
					items:[{
						xtype:'fieldset',
						title:'��ѯ����',
						layout: 'column',    // Specifies that the items will now be arranged in columns
						style:'padding:5px 0px 0px 0px;',
						items : [{ 				
							columnWidth: 0.2,
			            	xtype: 'fieldset',
			            	labelWidth: 60,	
			            	defaults: {width: 100, border:false},    // Default config options for child items
			            	defaultType: 'textfield',
			            	autoHeight: true,
			              border: false,
			            	items: [StartDate,StartTime]
							
						},{ 				
							columnWidth: 0.2,
			            	xtype: 'fieldset',
			            	labelWidth: 60,	
			            	defaults: {width: 100, border:false},    // Default config options for child items
			            	defaultType: 'textfield',
			            	autoHeight: true,
			              border: false,
			            	items: [EndDate,EndTime]
							
						},{ 				
					columnWidth: 0.2,
			            	xtype: 'fieldset',
			            	labelWidth: 60,	
			            	defaults: {width: 100, border:false},    // Default config options for child items
			            	defaultType: 'textfield',
			            	autoHeight: true,
			              border: false,
			            	items: [MBCUser,Prescno]
							
						},{ 				
					columnWidth: 0.2,
			            	xtype: 'fieldset',
			            	labelWidth: 60,	
			            	defaults: {width: 100, border:false},    // Default config options for child items
			            	defaultType: 'textfield',
			            	autoHeight: true,
			              border: false,
			            	items: [LocWard]
							
						}
						
						
			            	 ]
						
						
					}]
				});
	

		// ҳ�沼��
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [            // create instance immediately
			            {
			                region: 'north',
			                height: 155, // give north and south regions a height
			                layout: 'fit', // specify layout manager for items
			                items:HisListTab
			            }, {
			                region: 'center',
			                title: '��ҩסԺ��ѯ',			               
			                layout: 'fit', // specify layout manager for items
			                items: MasterGrid 
			            }
	       			],
					renderTo : 'mainPanel'
				});
				
		//Query();
	}


})