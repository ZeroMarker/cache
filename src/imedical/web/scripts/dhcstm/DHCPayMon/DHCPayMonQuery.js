// /名称: 付款月报明细查询
// /描述: 付款月报明细查询
// /编写者：zhangdongmei
// /编写日期: 2012.11.23
	

	var gUserId = session['LOGON.USERID'];	
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gIncid="";
	var Url=DictUrl	+ 'paymonaction.csp?';
	var today=new Date();
	var growid=""
	var activeTabtmp=""

	var PhaLoc = new Ext.ux.LocComboBox({
		id : 'PhaLoc',
		name : 'PhaLoc',
		fieldLabel : '科室',
		listWidth : 200,
		groupId:gGroupId
	});

	var StYear=new Ext.form.TextField({
		fieldLabel:'月份',
		id:'StYear',
		name:'StYear',
		anchor:'90%',
		width:80,
		value:today.getFullYear()
	});
	var StMonth=new Ext.form.TextField({
		fieldLabel:'',
		id:'StMonth',
		name:'StMonth',
		anchor:'90%',
		width:80,
		value:((today.getMonth()-10)<=0?1:(today.getMonth()-10))
	});
	
	var EdYear=new Ext.form.TextField({
		fieldLabel:'',
		id:'EdYear',
		name:'EdYear',
		anchor:'90%',
		width:80,
		value:today.getFullYear()
	});
	
	var EdMonth=new Ext.form.TextField({
		fieldLabel:'',
		id:'EdMonth',
		name:'EdMonth',
		anchor:'90%',
		width:80,
		value:(today.getMonth()+1)
	});
		// 查询按钮
	var SearchBT = new Ext.Toolbar.Button({
				id : "SearchBT",
				text : '查询',
				tooltip : '点击查询',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {  
					Query();
				}
			});
	// 打印付款月报明细
	var printBT = new Ext.Toolbar.Button({
		id : "printBT",
		text : '打印',
		tooltip : '打印付款月报明细',
		width : 70,
		height : 30,
		iconCls : 'page_print',
		handler : function() {
			PrintPayMon(growid,activeTabtmp);
		}
	});
	
	//查询付款月报
	function Query(){
		var stYear=Ext.getCmp('StYear').getValue();
		var stMonth=Ext.getCmp('StMonth').getValue();
		var stDate=stYear+'-'+stMonth+'-'+'01';
		var edYear=Ext.getCmp('EdYear').getValue();
		var edMonth=Ext.getCmp('EdMonth').getValue();
		var edDate=edYear+'-'+edMonth+'-'+'01';
		var Loc=Ext.getCmp('PhaLoc').getValue();
		
		MainStore.removeAll();
		MainStore.load({params:{LocId:Loc,StartDate:stDate,EndDate:edDate}});
	}

	function renderRecQty(value, metaData, record, rowIndex, colIndex, store){
		var curUrl=window.location.href;
		var host=window.location.host;
		var pathName=window.location.pathname;
		var pos=pathName.indexOf("/csp");
		var commonPath=pathName.substring(0,pos);
		var Loc=Ext.getCmp('PhaLoc').getValue();
		var selectRecord=MainGrid.getSelectionModel().getSelected();
		var startDate=selectRecord.get("frDate");
		var endDate=selectRecord.get("toDate");
		var incId=record.get("inci"),incDesc=record.get("incidesc");
		var DateFlag=1;  //按审核日期统计
		var QueryParams=Loc+","+startDate+","+endDate+","+incId+","+incDesc+","+DateFlag;
		var newUrl="http://"+host+"/"+commonPath+"/csp/dhcstm.ingdrecquery.csp?QueryParams={0}"
		return String.format('<a href='+newUrl+' target="_blank">{1}',QueryParams,value);
		
	}
	
		
	var MainStore=new Ext.data.JsonStore({
		auroDestroy:true,
		url:Url+"actiontype=Query",
		sotreId:'MainStore',
		root:'rows',
		totalProperty:'results',
		idProperty:'pmRowid',
		fields:['pmRowid','locDesc','MonthDate','frDate','toDate','LastRpAmt','ArrearRpAmt','PayedRpAmt','EndRpAmt']
	});
	
	var MainGrid=new Ext.ux.GridPanel({
		id:'MainGrid',
		title:'付款月报',
		region:'west',
		width:200,
		store:MainStore,
		cm:new Ext.grid.ColumnModel([{
			header:'Rowid',
			dataIndex:'pmRowid',
			width:100,
			align:'left',
			hidden:true
		},{
			header:'科室',
			dataIndex:'locDesc',
			width:120,
			align:'left',
			sortable:true
		},{
			header:'月份',
			dataIndex:'MonthDate',
			width:100,
			align:'left',
			sortable:true
		},{
			header:'月报起始日期',
			dataIndex:'frDate',
			width:100,
			align:'left',
			sortable:true
		},{
			header:'月报截止日期',
			dataIndex:'toDate',
			width:100,
			align:'left',
			sortable:true
		},{
			header : "上期结余金额",
			dataIndex : 'LastRpAmt',
			width : 100,
			align : 'right',
			sortable : true
		},{
			header : "本期增加金额",
			dataIndex : 'ArrearRpAmt',
			width : 100,
			align : 'right',
			sortable : true
		},{
			header : "本期付款金额",
			dataIndex : 'PayedRpAmt',
			width : 100,
			align : 'right',
			sortable : true
		},{
			header : "本期结余金额",
			dataIndex : 'EndRpAmt',
			width : 100,
			align : 'right',
			sortable : true
		}]),
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		autoScroll:true
	})
	
	MainGrid.addListener('rowclick',function(grid,rowindex,e){
		FireTabChange(tabPanel);
	});
	var mainForm = new Ext.ux.FormPanel({
        height:150,
		title:'付款月报明细查询',
		tbar : [SearchBT,'-',printBT],
		region:'north',
		items:[{
			layout:'column',
			xtype: 'fieldset',
			title:'查询条件',
			style:'padding:0px 20px 0px 0px',
			defaults: {border:false},
			items:[{
				columnWidth: 0.3,
				xtype: 'fieldset',
				items: [PhaLoc]
			},{
				columnWidth: 0.5,
				xtype: 'compositefield',								
				items : [
							{ xtype: 'displayfield', value: '月报范围：'},
							StYear,
							{ xtype: 'displayfield', value: '年'},
							StMonth,
							{ xtype: 'displayfield', value: '月   -----'},
							EdYear,
							{ xtype: 'displayfield', value: '年'},
							EdMonth,
							{xtype:'displayfield',value:'月'}
						]
			}]
		}]						
	});
	
	var PayMDetailRpPanel = new Ext.Panel({
		autoScroll:true,
		layout:'fit',
		html:'<iframe id="framePayMDetailRp" height="100%" width="100%" src="../scripts/dhcmed/img/logon_bg2.jpg"/>'
	});
	var PayMLBDetailRpPanel = new Ext.Panel({
		autoScroll:true,
		layout:'fit',
		html:'<iframe id="framePayMLBDetailRp" height="100%" width="100%" src="../scripts/dhcmed/img/logon_bg2.jpg"/>'
	});
	var tabPanel=new Ext.TabPanel({
		region:'center',
		activeTab:0,
		items:[{
				title:'付款月报汇总(供应商)',
				id:'ReportPayMDetailRp',
				layout:'fit',
				items:[PayMDetailRpPanel]
			},{
				title:'付款月报明细(供应商分类)',
				id:'ReportPayMLBDetailRp',
				layout:'fit',
				items:[PayMLBDetailRpPanel]
			}
		]
	})

	tabPanel.addListener('tabchange',function(tabpanel,panel){
		var record=MainGrid.getSelectionModel().getSelected();
		if(record){
			var rowid=record.get("pmRowid");
			growid=rowid;
			var PayMonth = record.get("MonthDate");
			activeTabtmp=panel;
			var mainData=GetPayMonMain(growid);
			var mainArr=mainData.split("^");
			var LocId=mainArr[2];
			var month=mainArr[1]
			var LocDesc=mainArr[3]
			var fromdate=mainArr[4]
			var todate=mainArr[5]
			var createdate=mainArr[6]
			var createUser=mainArr[7]
			var createTime=mainArr[8]
		    if(panel.id=="ReportPayMDetailRp"){
				//库存分类汇总
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_PayMDetailRp.raq'
					+"&growid="+growid+"&LocDesc="+LocDesc+"&fromdate="+fromdate
					+"&todate="+todate+"&createdate="+createdate+"&createUser="+createUser
					+"&createTime="+createTime+"&HospDesc="+App_LogonHospDesc;
				var reportFrame=document.getElementById("framePayMDetailRp");
				reportFrame.src=p_URL;
			}else if(panel.id=="ReportPayMLBDetailRp"){
				//库存分类汇总
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_PayMLBDetailRp.raq'
					+"&growid="+growid+"&LocDesc="+LocDesc+"&fromdate="+fromdate
					+"&todate="+todate+"&createdate="+createdate+"&createUser="+createUser
					+"&createTime="+createTime+"&HospDesc="+App_LogonHospDesc;
				var reportFrame=document.getElementById("framePayMLBDetailRp");
				reportFrame.src=p_URL;
			}
		}
	});
	
	Ext.onReady(function() {
		Ext.QuickTips.init();
		Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
		var myPanel = new Ext.ux.Viewport({
			layout : 'border',
			items : [mainForm,MainGrid,tabPanel]
		});
		Query();
	});
	
	function FireTabChange(tabPanel){
		var activePanelId=tabPanel.getActiveTab().id;
		if(activePanelId=="ReportPayMDetailRp")
		{
			tabPanel.fireEvent('tabchange',tabPanel,tabPanel.getActiveTab());
		}
	}