///显示需要关联库存项的医嘱项信息
///2017-04-13 lihui
///

var arcinfoWin="";
GetArcforLinkInci=function(Fn){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	///控制弹窗打开多次
	var garcinfoWindowFlag = typeof(garcinfoWindowFlag)=='undefined'?false:garcinfoWindowFlag;
	if(arcinfoWin){
	   arcinfoWin.show();
	   return;
	}
	if(garcinfoWindowFlag){
		return;
	}
	var ArcinfoUrl='dhcstm.showarcinfoforlinkinci.csp?actiontype=GetArcInfo';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : ArcinfoUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["ArcitmId","ArcCode","ArcDesc","BillUomId","BillUomDesc","ArcSubCatId","ArcSubCat",
	              "BillCat","BillSubCatId","BillSubCat","OwnFlag","PriorId","Priority","WoStock",
	              "InsuDesc","SX","OeMessage","EffDate","EffDateTo","OrdCat","OrdCatId","ArcAlias",
	              "scDr","scDesc","acDr","acDesc","mcDr","mcDesc","icDr","icDesc","ocDr","ocDesc","ecDr","ecDesc",
	              "tariCode","tariDesc","feeFlag","newmcDr","newmcDesc","TarPrice"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "ArcitmId",
		fields : fields
	});
	// 数据集
	var ArcinfoStore = new Ext.data.Store({
		proxy : proxy,
		reader : reader,
		remoteSort: true,
		listeners : {
				load : function(store, records, options){
					if(records.length > 0){
						sm.selectFirstRow();
					}
				}
			}
	});
	
	var nm = new Ext.grid.RowNumberer();
	var sm =new Ext.grid.CheckboxSelectionModel({singleSelect:true});
	var ArcinfoCm = new Ext.grid.ColumnModel([nm,sm,
		{
		    header : "Arcid",
			dataIndex : 'ArcitmId',
			width : 80,
			align : 'left',
			hidden:true
		},{
			
			header : "医嘱代码",
			dataIndex : 'ArcCode',
			width : 80,
			align : 'left',
			sortable : true
	    },{
		    header : "医嘱名称",
			dataIndex : 'ArcDesc',
			width : 80,
			align : 'left',
			sortable : true 
		},{
			header : "计价单位",
			dataIndex : 'BillUomDesc',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "售价",
			dataIndex : 'TarPrice',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "医嘱大类",
			dataIndex : 'OrdCat',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "医嘱子类",
			dataIndex : 'ArcSubCat',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "费用大类",
			dataIndex : 'BillCat',
			width : 80,
			align : 'left',
			hidden:true,
			sortable : true
		},{
			header : "费用子类",
			dataIndex : 'BillSubCat',
			width : 80,
			align : 'left',
			hidden:true,
			sortable : true
		},{
			header : "独立医嘱",
			dataIndex : 'OwnFlag',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "医嘱优先级",
			dataIndex : 'Priority',
			width : 80,
			align : 'left',
			hidden:true,
			sortable : true
		},{
			header : "无库存医嘱",
			dataIndex : 'WoStock',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "医保名称",
			dataIndex : 'InsuDesc',
			width : 80,
			align : 'left',
			hidden:true,
			sortable : true
		},{
			header : "缩写",
			dataIndex : 'SX',
			width : 80,
			align : 'left',
			hidden:true,
			sortable : true
		},{
			header : "医嘱提示",
			dataIndex : 'OeMessage',
			width : 80,
			align : 'left',
			hidden:true,
			sortable : true
		},{
			header : "生效日期",
			dataIndex : 'EffDate',
			width : 80,
			align : 'left',
			hidden:true,
			sortable : true
		},{
			header : "截止日期",
			dataIndex : 'EffDateTo',
			width : 80,
			align : 'left',
			//hidden:true,
			sortable : true
		},{
			header : "收费子分类",
			dataIndex : 'scDesc',
			width : 80,
			align : 'left',
			hidden:true,
			sortable : true
		},{
			header : "门诊子分类",
			dataIndex : 'ocDesc',
			width : 80,
			align : 'left',
			hidden:true,
			sortable : true
		},{
			header : "核算子分类",
			dataIndex : 'ecDesc',
			width : 80,
			align : 'left',
			hidden:true,
			sortable : true
		},{
			header : "病历首页子分类",
			dataIndex : 'mcDesc',
			width : 100,
			align : 'left',
			hidden:true,
			sortable : true
		},{
			header : "会计子分类",
			dataIndex : 'acDesc',
			width : 80,
			align : 'left',
			hidden:true,
			sortable : true
		},{
			header : "新病历首页子分类",
			dataIndex : 'newmcDesc',
			width : 110,
			align : 'left',
			hidden:true,
			sortable : true
		}]);
	
   var ArcinfoToolbar = new Ext.PagingToolbar({
			store:ArcinfoStore,
			pageSize:PageSize,
			id:'ArcinfoToolbar',
			displayInfo:true
	});
	
	//选取
	var retBT = new Ext.Toolbar.Button({
				text : '选取',
				tooltip : '确认选取',
				iconCls : 'page_goto',
				handler : function() {
					returnArcinfoData();
				}
			});
	function returnArcinfoData(){
	         var selectrow=ArcinfoGrid.getSelectionModel().getSelected();
	         var Arcid=selectrow.get("ArcitmId");
	         var linkedarc=tkMakeServerCall("web.DHCSTM.ShowArcinfoForlinkInci","IfLinkInci",Arcid);
	         if (linkedarc=="Y")
	         {
		         Msg.info("warning","此医嘱已经存在关联的库存项,请联系管理员处理!");
		         return;
		     }
	         if (selectrow.length == 0) {
				Msg.info("warning", "请选择要返回的医嘱信息！");
			} else {
			    Fn(selectrow);
			    arcwindow.hide();
			}
	}		
	
	//关闭
	var closBT =new Ext.Toolbar.Button({
		text : '关闭',
		tooltip : '点击关闭',
		iconCls : 'page_delete',
		handler : function() {
			if (Ext.getCmp('arcwindow')){
				Ext.getCmp('arcwindow').close();
			}
		}
	});
	//医嘱代码
	var Arccode= new Ext.form.TextField({
		fieldLabel : '医嘱代码',
		id : 'Arccode',
		name : 'Arccode',
		anchor : '90%',
		valueNotFoundText : ''
	});
	//医嘱名称
	var Arcdesc= new Ext.form.TextField({
		fieldLabel : '医嘱名称',
		id : 'Arcdesc',
		name : 'Arcdesc',
		anchor : '90%',
		valueNotFoundText : ''
	});
	//医嘱大类
	var Arcordc= new Ext.ux.ComboBox({
		fieldLabel : '医嘱大类',
		id : 'Arcordc',
		name : 'Arcordc',
		store : OrderCategoryStore,
		valueField : 'RowId',
		displayField : 'Description',
		childCombo : ['Arccat']
	});
	//医嘱子类
	var Arccat= new Ext.ux.ComboBox({
		fieldLabel : '医嘱子类',
		id : 'Arccat',
		name : 'Arccat',
		store : ArcItemCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'Desc',
		params:{OrderCat:'Arcordc'}  //Arcordc为医嘱大类的id
	});
	
	//查询
	var searchBT = new Ext.Toolbar.Button({
			text : '查询',
			tooltip : '点击查询',
			iconCls : 'page_find',
			width : 70,
			height : 30,
			handler : function() {
				arcrefreshGrid();
			}
		});
	//是否只显示没有关联库存项的信息
	var Nolink = new Ext.form.Checkbox({
			id : 'Nolink',
			hideLabel : true,
			boxLabel : '仅未关联的医嘱',
			checked:true
		});
	
	var ArcinfoGrid = new Ext.ux.GridPanel({
		id:'ArcinfoGrid',
		region:'center',
		autoScroll:true,
		cm:ArcinfoCm,
		store:ArcinfoStore,
		trackMouseOver : true,
		stripeRows : true,
		sm : sm,
		//loadMask : true,
		tbar : [retBT, '-', closBT,'医嘱代码',Arccode,'医嘱名称',Arcdesc,'医嘱大类',Arcordc,'医嘱子类',Arccat,searchBT,Nolink],
		bbar : ArcinfoToolbar,
		listeners : {
			'rowdblclick' : function() {
				returnArcinfoData();
			},
			'keydown' : function(e) {	// 回车事件
				if (e.getKey() == Ext.EventObject.ENTER) {
					returnArcinfoData();
				}
			}
		}
	});
	var arcwindow = new Ext.Window({
		title : '医嘱收费项信息',
		id:'arcwindow',
		width : 1050,
		height : 500,
		layout:'border',
		plain : true,
		modal : true,
		buttonAlign : 'center',
		items : [{region:'center',layout:'fit',width:500,split:true,items:ArcinfoGrid}],
		listeners:{
			'show':function(){
				garcinfoWindowFlag=true;	//通过全局变量控制多个window显示的问题,close时置为false
				arcrefreshGrid();
			},
			'close' : function(panel) {
				arcinfoWin=null;
				garcinfoWindowFlag=false;
			},
			'hide' : function(panel) {
				arcinfoWin=arcwindow;
				garcinfoWindowFlag=false;
			}
		}
	});
	arcwindow.show();
	
	function arcrefreshGrid(){
		var Arccdoe=Ext.getCmp("Arccode").getValue();
		var Arcdesc=Ext.getCmp("Arcdesc").getValue();
		var Arcordc=Ext.getCmp("Arcordc").getValue();
		var Arccat=Ext.getCmp("Arccat").getValue();
		var nolinkflag=Ext.getCmp("Nolink").getValue()?"Y":"N";
		var Others=Arcordc+"^"+Arccat+"^"+nolinkflag;
		ArcinfoStore.removeAll();
		ArcinfoStore.setBaseParam("arccdoe",Arccdoe);
		ArcinfoStore.setBaseParam("arcdesc",Arcdesc);
		ArcinfoStore.setBaseParam("others",Others);
	    ArcinfoStore.load({
			params:{start:0, limit:ArcinfoToolbar.pageSize},
			callback:function(r, options, success){
				if (!success || r.length==0) {
					Msg.info('warning','没有任何符合的记录！');
					//if(window&&Filter==0){
						//window.hide();
					//}
				} else if(r.length>0) {
					ArcinfoGrid.getSelectionModel().selectFirstRow();// 选中第一行并获得焦点
					ArcinfoGrid.getView().focusRow(0);
				}
			}
		});
	}
}