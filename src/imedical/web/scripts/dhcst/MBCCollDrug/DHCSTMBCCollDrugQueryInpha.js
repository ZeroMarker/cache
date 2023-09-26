// /名称:煎药住院查询
// /描述: 煎药住院查询
// /编写者：wyx
// /编写日期: 2014.11.03
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
	//	GetParam();  //初始化参数配置
	//}
	ChartInfoAddFun();
	function ChartInfoAddFun() {

		
		// 起始日期
		var StartDate = new Ext.ux.DateField({
					fieldLabel : '起始日期',
					id : 'StartDate',
					name : 'StartDate',
					anchor : '90%',
					format : 'Y-m-d',
					width : 100,
					value : DefaultStDate()
				});
	  var StartTime=new Ext.form.TextField({
		 fieldLabel : '<font color=blue>开始时间</font>',
		id : 'StartTime',
		name : 'StartTime',
		anchor : '90%',
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:'时间格式错误，正确格式hh:mm:ss',
		width : 120
	  });

		// 截止日期
		var EndDate = new Ext.ux.DateField({
					fieldLabel : '截止日期',
					id : 'EndDate',
					name : 'EndDate',
					anchor : '90%',
					format : 'Y-m-d',
					width : 100,
					value : DefaultEdDate()
				});
	var EndTime=new Ext.form.TextField({
		fieldLabel : '<font color=blue>截止时间</font>',
		id : 'EndTime',
		name : 'EndTime',
		anchor : '90%',
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:'时间格式错误，正确格式hh:mm:ss',
		width : 120
	});
		

	   var Prescno = new Ext.form.TextField({		
					fieldLabel : '处方号',
					id : 'Prescno',
					name : 'Prescno',
					anchor : '90%',
					width : 140
	   })
	   //var MBCUser = new Ext.ux.DoctorDsComboBox({		
					//fieldLabel : '操作人',
					//id : 'MBCUser',
					//name : 'MBCUser',
					//anchor : '90%'
	  // })
		     // 煎药室人员
           var MBCUser = new Ext.ux.MBCUserComboBox({
					fieldLabel : '操作人',
					id : 'MBCUser',
					name : 'MBCUser',
					anchor : '90%'
		});
		Ext.getCmp("MBCUser").setValue('');
					//病区
	var LocWard=new Ext.ux.LocWardComboBox({
		id : 'LocWard',
		name : 'LocWard',
		anchor:'90%'
	});

	      //执行科室
           //var LocWard = new Ext.ux.ExeLocComboBox({
		//			fieldLabel : '科室',
		//			id : 'LocWard',
		//			name : 'LocWard',
		//			anchor : '90%'
		//});
	 /*     //煎药状态

	  var MBCState = new Ext.ux.form.LovCombo({
		id : 'MBCState',
		name : 'MBCState',
		fieldLabel : '煎药状态',
		//listWidth : 100,
		anchor: '90%',
		//labelStyle : "text-align:left;width:100;",
		labelSeparator : '',
		separator:'^',	//科室id用^连接
		hideOnSelect : false,
		//maxHeight : 200,
		editable:false,
		store : GetMBCStateStore ,
		valueField : 'RowId',
		displayField : 'Description',
		triggerAction : 'all'
	});
	*/
		// 查询按钮
		var SearchBT = new Ext.Toolbar.Button({
					id:"SearchBT",
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
		var ClearBT = new Ext.Toolbar.Button({
					id:'ClearBT',
					text : '清空',
					tooltip : '点击清空',
					width : 70,
					height : 30,
					iconCls : 'page_refresh',
					handler : function() {
						clearData();
					}
				});

		// 打印按钮
		var PrintBT = new Ext.Toolbar.Button({
					id:'PrintBT',
					text : '打印',
					tooltip : '点击打印',
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
		 * 查询方法
		 */
		function Query() {

                     var StartDate = Ext.getCmp("StartDate").getValue();
			if(StartDate!=""){
				StartDate=StartDate.format('Y-m-d');
			}else{
				Msg.info("warning","请选择开始日期!");
				return;
			}
			SDate=StartDate
			var StartTime = Ext.getCmp("StartTime").getValue();
			STime=StartTime
			var EndDate = Ext.getCmp("EndDate").getValue()
			if(EndDate!=""){
				EndDate=EndDate.format('Y-m-d');
			}else{
				Msg.info("warning","请选择截止日期!");
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
                     var State="50" //煎药完成状态                     
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
		 * 清空方法
		 */
		function clearData() {
			Ext.getCmp("StartDate").setValue(DefaultStDate());
			Ext.getCmp("EndDate").setValue(DefaultEdDate());
			MasterGrid.store.removeAll();
			
			PrintBT.setDisabled(true);
		}
 
		// 信息列表
		// 访问路径
		var MasterUrl = 'dhcst.mbccolldrugaction.csp?action=QueryInpha';;
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : MasterUrl,
					method : "POST"
				});

				// 指定列参数
		var fields = ["MBCId","LocWard","PatNo","MedNo","BedNo","PatName","Prescno","FsQty","State","dreat"];
		
		//
		              //"
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "MBCId",
					fields : fields
				});
		// 数据集
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
        	header:"科室",
        	dataIndex:'LocWard',
        	width:100,
        	align:'left',
        	sortable:true
	 },{
        	header:"处方号",
        	dataIndex:'Prescno',
        	width:200,
        	align:'left',
        	sortable:true
	 },{
        	header:"是否当日服用",
        	dataIndex:'dreat',
        	width:200,
        	align:'left',
        	sortable:true
	 },{
        	header:"登记号",
        	dataIndex:'PatNo',
        	width:200,
        	align:'left',
        	sortable:true
	 },{
        	header:"住院号",
        	dataIndex:'MedNo',
        	width:200,
        	align:'left',
        	sortable:true
	 },{
        	header:"床号",
        	dataIndex:'BedNo',
        	width:200,
        	align:'left',
        	sortable:true
	 },{
        	header:"患者姓名",
        	dataIndex:'PatName',
        	width:200,
        	align:'left',
        	sortable:true
	 },{
        	header:"付数",
        	dataIndex:'FsQty',
        	width:200,
        	align:'left',
        	sortable:true
	 },{
        	header:"状态",
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
			displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
			emptyMsg:"没有记录"
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
	
	
	    //设置Grid悬浮显示窗体
	//Creator:wyx 2014-10-15
    MasterGrid.on('mouseover',function(e){
		
		var rowCount = MasterGrid.getStore().getCount();
		if (rowCount>0)
		{  
			var ShowInCellIndex=3;  //在第几列显示
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
					title:'煎药住院查询',
					autoScroll : false,
					bodyStyle : 'padding:0px 0px 0px 0px;',					
					tbar : [SearchBT, '-', ClearBT, '-', PrintBT],
					items:[{
						xtype:'fieldset',
						title:'查询条件',
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
	

		// 页面布局
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
			                title: '煎药住院查询',			               
			                layout: 'fit', // specify layout manager for items
			                items: MasterGrid 
			            }
	       			],
					renderTo : 'mainPanel'
				});
				
		//Query();
	}


})