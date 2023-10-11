// /名称:库存动销查询
// /描述: 库存动销查询
// /编写者：zhangdongmei
// /编写日期: 2012.08.16
var gNewCatIdOther="";
var gNewCatId=""
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gStrParam='';
	var gGroupId=session['LOGON.GROUPID'];
	var gUserId=session['LOGON.USERID'];
	var gLocId=session['LOGON.CTLOCID'];
	//统计科室
	var PhaLoc = new Ext.ux.LocComboBox({
			fieldLabel : $g('科室'),
			id : 'PhaLoc',
			name : 'PhaLoc',
			anchor:'90%',
			groupId:gGroupId,
		        listeners : {
                    'select' : function(e) {
                             var SelLocId=Ext.getCmp('PhaLoc').getValue();//add wyx 根据选择的科室动态加载类组
                             StkGrpType.getStore().removeAll();
                             StkGrpType.getStore().setBaseParam("locId",SelLocId)
                             StkGrpType.getStore().setBaseParam("userId",UserId)
                             StkGrpType.getStore().setBaseParam("type",App_StkTypeCode)
                             StkGrpType.getStore().load();
			}
	}
		});
		// 起始日期
		var StartDate = new Ext.ux.DateField({
					fieldLabel : $g('开始日期'),
					id : 'StartDate',
					name : 'StartDate',
					anchor : '90%',
					width : 120,
					value : new Date().add(Date.DAY, - 30)
				});
		var StartTime=new Ext.form.TextField({
			fieldLabel : $g('开始时间'),
			id : 'StartTime',
			name : 'StartTime',
			anchor : '90%',
			regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
			regexText:$g('时间格式错误，正确格式hh:mm:ss'),
			width : 120
		});
		// 截止日期
		var EndDate = new Ext.ux.DateField({
					fieldLabel : $g('截止日期'),
					id : 'EndDate',
					name : 'EndDate',
					anchor : '90%',
					width : 120,
					value : new Date()
				});
		var EndTime=new Ext.form.TextField({
			fieldLabel : $g('截止时间'),
			id : 'EndTime',
			name : 'EndTime',
			anchor : '90%',
			regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
			regexText:$g('时间格式错误，正确格式hh:mm:ss'),
			width : 120
		});
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //标识类组类型
			anchor : '90%',
			UserId:gUserId,
			LocId:gLocId,
			fieldLabel:$g('类组')
		}); 

		StkGrpType.on('change', function() {
			Ext.getCmp("DHCStkCatGroup").setValue("");
		});
		var DHCStkCatGroup = new Ext.ux.ComboBox({
					fieldLabel : $g('库存分类'),
					id : 'DHCStkCatGroup',
					name : 'DHCStkCatGroup',
					store : StkCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					params:{StkGrpId:'StkGrpType'}
				});

		// 药学大类
		var PhcCat = new Ext.ux.ComboBox({
					fieldLabel : $g('药学大类'),
					id : 'PhcCat',
					name : 'PhcCat',
					anchor : '90%',
					store : PhcCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					filterName:'PhccDesc'
				});
		PhcCat.on('change',function(){
			Ext.getCmp("PhcSubCat").setValue("");
			Ext.getCmp("PhcMinCat").setValue("");
		});

		// 药学子类
		var PhcSubCat = new Ext.ux.ComboBox({
					fieldLabel : $g('药学子类'),
					id : 'PhcSubCat',
					name : 'PhcSubCat',
					anchor : '90%',
					store : PhcSubCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					params:{PhcCatId:'PhcCat'}
				});

		PhcSubCat.on('change',function(){
			Ext.getCmp("PhcMinCat").setValue("");
		});

		// 药学小类
		var PhcMinCat = new Ext.ux.ComboBox({
					fieldLabel : $g('药学小类'),
					id : 'PhcMinCat',
					name : 'PhcMinCat',
					anchor : '90%',
					store : PhcMinCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					params:{PhcSubCatId:'PhcSubCat'}
				});

	var PHCCATALLOTH = new Ext.form.TextField({
		fieldLabel : $g('药学分类'),
		id : 'PHCCATALLOTH',
		name : 'PHCCATALLOTH',
		//anchor : '90%',
		readOnly : true,
		valueNotFoundText : ''
	});
	function GetAllCatNew(catdescstr,newcatid){
		//if ((catdescstr=="")&&(newcatid=="")) {return;}
		Ext.getCmp("PHCCATALLOTH").setValue(catdescstr);
		gNewCatIdOther=newcatid;
	
	
	}

	var PHCCATALLOTHButton = new Ext.Button({
		id:'PHCCATALLOTHButton',
		text : $g('药学分类'),
		handler : function() {	
	       //var lnk="dhcst.phccatall.csp?gNewCatId="+gNewCatId;
	       //window.open(lnk,"_target","height=600,width=800,menubar=no,status=yes,toolbar=no,resizable=yes") ;
    	/*
	     var retstr=showModalDialog('dhcst.phccatall.csp?gNewCatId='+gNewCatIdOther,'','dialogHeight:600px;dialogWidth:1000px;center:yes;help:no;resizable:no;status:no;scroll:no;menubar=no;toolbar=no;location=no')
	       if (!(retstr)){
	          return;
	        }
        
	        if (retstr==""){
	          return;
	        }
     
		var phacstr=retstr.split("^")
		GetAllCatNew(phacstr[0],phacstr[1])
		*/
		PhcCatNewSelect(gNewCatId,GetAllCatNew)
	    }
	});

		// 查询按钮
		var SearchBT = new Ext.Toolbar.Button({
					text : $g('查询'),
					tooltip :$g('点击查询'),
					iconCls : 'page_find',
					width : 70,
					height : 30,
					handler : function() {
						searchData();
					}
				});

		/**
		 * 查询方法
		 */
		function searchData() {
			// 必选条件
			var phaLoc = Ext.getCmp("PhaLoc").getValue();
			if (phaLoc == null || phaLoc.length <= 0) {
				Msg.info("warning", $g("科室不能为空！"));
				Ext.getCmp("PhaLoc").focus();
				return;
			}
			var startDate = Ext.getCmp("StartDate").getRawValue();
			var endDate = Ext.getCmp("EndDate").getRawValue();
			if (startDate == undefined || startDate.length <= 0) {
				Msg.info("warning", $g("请选择开始日期!"));
				return;
			}
			if (endDate == undefined || endDate.length <= 0) {
				Msg.info("warning", $g("请选择截止日期!"));
				return;
			}
			var startTime=Ext.getCmp("StartTime").getRawValue();
			var endTime=Ext.getCmp("EndTime").getRawValue();
			if(startDate ==endDate && startTime>endTime){
				Msg.info("warning", $g("开始时间大于截止时间！"));
				return;
			}
			var stkGrpId=Ext.getCmp("StkGrpType").getValue();
			var stkCatId=Ext.getCmp("DHCStkCatGroup").getValue();
			var phcCatId=Ext.getCmp("PhcCat").getValue();
			var phcSubCatId=Ext.getCmp("PhcSubCat").getValue();
			var phcMinCatId=Ext.getCmp("PhcMinCat").getValue();
			var phcCatStr=phcCatId+','+phcSubCatId+','+phcMinCatId
			gStrParam=phaLoc+"^"+startDate+"^"+startTime+"^"+endDate+"^"+endTime
			+"^"+stkGrpId+"^"+stkCatId+"^"+phcCatStr+"^"+gNewCatIdOther;
			
			var pageSize=StatuTabPagingToolbar.pageSize;
			StockQtyStore.setBaseParam("Params",gStrParam);
			StockQtyStore.load({params:{start:0,limit:pageSize}});

		}
			// 另存按钮
		var SaveAsBT = new Ext.Toolbar.Button({
					text : $g('另存'),
					tooltip : $g('另存为Excel'),
					iconCls : 'page_excel',
					width : 70,
					height : 30,
					handler : function() {
						ExportAllToExcel(StockQtyGrid);

					}
				});			
		// 清空按钮
		var RefreshBT = new Ext.Toolbar.Button({
					text : $g('清屏'),
					tooltip : $g('点击清屏'),
					iconCls : 'page_clearscreen',
					width : 70,
					height : 30,
					handler : function() {
						clearData();
					}
				});

		/**
		 * 清空方法
		 */
		function clearData() {
			gStrParam='';
			Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, - 30));
			Ext.getCmp("EndDate").setValue(new Date());
			Ext.getCmp("StartTime").setValue('');
			Ext.getCmp("EndTime").setValue('');
			Ext.getCmp("StkGrpType").setValue('');
			Ext.getCmp("DHCStkCatGroup").setValue('');
			Ext.getCmp("PhcCat").setValue('');
			Ext.getCmp("PhcSubCat").setValue('');
			Ext.getCmp("PhcMinCat").setValue('');
			Ext.getCmp("PHCCATALLOTH").setValue("");
			gNewCatIdOther=""
			StockQtyGrid.store.removeAll();
			StockQtyGrid.getView().refresh();
		}
		
		
		
		var nm = new Ext.grid.RowNumberer();
		var sm = new Ext.grid.CheckboxSelectionModel();
		var StockQtyCm = new Ext.grid.ColumnModel([nm,  {
					header : "incil",
					dataIndex : 'incil',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : $g('代码'),
					dataIndex : 'code',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header :$g( "名称"),
					dataIndex : 'desc',
					width : 200,
					align : 'left',
					sortable : true
				}, {
					header : $g("规格"),
					dataIndex : 'spec',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : $g("单位"),
					dataIndex : 'pUomDesc',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : $g("库存量"),
					dataIndex : 'currStkQty',
					width : 100,
					align : 'right',
					sortable : true,
					renderer:SetNumber
				}, {
					header : $g("出数量"),
					dataIndex : 'OutQty',
					width : 100,
					align : 'right',
					sortable : true,
					renderer:SetNumber
				}, {
					header : $g("入数量"),
					dataIndex : 'InQty',
					width : 100,
					align : 'right',
					sortable : true,
					renderer:SetNumber
				}, {
					header : $g("出金额"),
					dataIndex : 'sumOutAmt',
					width : 60,
					align : 'right',
				
					sortable : true,
					renderer:SetNumber
				}, {
					header : $g("出进价金额"),
					dataIndex : 'sumOutRpAmt',
					width : 60,
					align : 'right',
					
					sortable : true,
					renderer:SetNumber
				}, {
					header : $g("入金额"),
					dataIndex : 'sumInAmt',
					width : 100,
					align : 'right',
					
					sortable : true,
					renderer:SetNumber
				}, {
					header :$g("入进价金额"),
					dataIndex : 'sumInRpAmt',
					width : 100,
					align : 'right',
					
					sortable : true,
					renderer:SetNumber
				}, {
					header : $g("生产企业"),
					dataIndex : 'manf',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : $g("货位"),
					dataIndex : 'sbDesc',
					width : 150,
					align : 'left',
					sortable : true
				}]);
		StockQtyCm.defaultSortable = true;

		// 访问路径
		var DspPhaUrl = DictUrl
					+ 'locitmstkaction.csp?actiontype=jsLocItmMoveInfo&start=&limit=';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : DspPhaUrl,
					method : "POST"
				});
		// 指定列参数
		var fields = ["incil","code", "desc","spec", "manf", "OutQty","pUomDesc","sumOutAmt","sumOutRpAmt",
				"InQty", "sumInAmt", "sumInRpAmt", "sbDesc","currStkQty"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "incil",
					fields : fields
				});
		// 数据集
		var StockQtyStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader,
					remoteSort:true
				});

		var StatuTabPagingToolbar = new Ext.PagingToolbar({
					store : StockQtyStore,
					pageSize : PageSize,
					displayInfo : true,
					displayMsg : $g('当前记录 {0} -- {1} 条 共 {2} 条记录'),
					emptyMsg : "No results to display",
					prevText :$g( "上一页"),
					nextText : $g("下一页"),
					refreshText : $g("刷新"),
					lastText :$g( "最后页"),
					firstText : $g("第一页"),
					beforePageText : $g("当前页"),
					afterPageText : $g("共{0}页"),
					emptyMsg : $g("没有数据")//,
					//doLoad:function(C){
						//var B={},
						//A=this.getParams();
						//B[A.start]=C;
						//B[A.limit]=this.pageSize;
						//B[A.sort]='desc';
						//B[A.dir]='ASC';
						
						//B['Params']=gStrParam;
						//if(this.fireEvent("beforechange",this,B)!==false){
						//	this.store.load({params:B});
						//}
					//}
				});

		var StockQtyGrid = new Ext.grid.GridPanel({
					id:'StockQtyGrid',
					region : 'center',
					cm : StockQtyCm,
					store : StockQtyStore,
					trackMouseOver : true,
					stripeRows : true,
					sm : sm,
					loadMask : true,
					bbar : StatuTabPagingToolbar
            	
		});
		
	var HisListTab = new Ext.form.FormPanel({
			labelWidth : 60,
			region : 'north',
			title:$g("库存动销查询"),
			autoHeight:true,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			tbar : [SearchBT,'-', RefreshBT, '-',SaveAsBT],	
			items:[{
				layout : 'column',
			    defaults: { border:false},	
			    xtype: 'fieldset',
			    title:$g('查询条件'),
			    style:DHCSTFormStyle.FrmPaddingV,
			    items:[{
					columnWidth:0.25,
					xtype: 'fieldset',									
					items : [PhaLoc,StkGrpType]
				  },{
					columnWidth:0.2,
					xtype: 'fieldset',									
					items : [StartDate,StartTime]
				  },{
					columnWidth:0.2,
					xtype: 'fieldset',									
					items : [EndDate,EndTime]
				  },{
					columnWidth:0.25,
					xtype: 'fieldset',						
					items : [{xtype:'compositefield',items:[PHCCATALLOTH,PHCCATALLOTHButton]},DHCStkCatGroup]
				  }]	
			}]				
			
		});

		// 5.2.页面布局
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [ 
						{
			                region: 'north',
			                height: DHCSTFormStyle.FrmHeight(2), // give north and south regions a height
			                layout: 'fit', // specify layout manager for items
			                items:HisListTab
			            }, {
			                region: 'center',
			                title: $g('明细'),			               
			                layout: 'fit', // specify layout manager for items
			                items: StockQtyGrid       
			               
			            }
	       			],
					renderTo : 'mainPanel'
				});
	
})