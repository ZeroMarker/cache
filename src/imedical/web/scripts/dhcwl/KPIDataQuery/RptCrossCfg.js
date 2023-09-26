(function(){
	Ext.ns("dhcwl.KDQ.RptCrossCfg");
})();
///描述: 		查询对象
///编写者：		WZ
///编写日期: 		2016-11
dhcwl.KDQ.RptCrossCfg=function(pObj){
	var serviceUrl="dhcwl/kpidataquery/rptcrosscfg.csp";
	var outThis=this;
	var parentObj=pObj;
	var rptCode="";
	var curRptSaveArgs=new Object();
	curRptSaveArgs.rptCode="";
	curRptSaveArgs.descript="";
	curRptSaveArgs.businessType="";
				

	var saveMenu = new Ext.menu.Menu({
        //id: 'saveMenu',
        items: [
            {
				//id:'menuSave',
                text: '保存',
                handler: OnSaveRptCfg
            },{
				//id:'menuSaveas',				
                text: '另存',
                handler: OnSaveAsRptCfg				
			}]				
	});
		
	function ClsItemGrid(ddGroupName) {
		this.getItemGridPanel=getItemGridPanel;
		var itemStoreData = [];	
		var itemStore = new Ext.data.ArrayStore({
			autoDestroy: true,
			fields: [
				{name: 'code'},
				{name: 'descript'},
				{name:'type'},
				{name:'dimOrMeasure'}
			]
		});
		
		var itemCm = new Ext.grid.ColumnModel({
			columns: [{
				header: '编码',
				dataIndex: 'code',
				width: 130
			}, {
				header: '描述',
				id:'crossItemdescript',		//这个ID必须要，用在grid的autoExpandColumn中
				dataIndex: 'descript',
				width: 220
				,editor: new Ext.form.TextField({allowBlank: true})
			},{
				xtype: 'actioncolumn',
				header: '修改',
				width: 50,
				items: [{        
					icon   : '../images/uiimages/config.png',  // Use a URL in the icon config
					tooltip: '修改设置',
					handler: function(grid, rowIndex, colIndex) {
						rowConfig(grid, rowIndex, colIndex);
					}
				}]
				
			}]
		})		
	   // create the colItemGrid
		var ItemGrid = new Ext.grid.EditorGridPanel({
			border:false,
			store: itemStore,
			stripeRows: true,
			autoExpandColumn: 'crossItemdescript',
			cm: itemCm,
			sm: new Ext.grid.RowSelectionModel({singleSelect: true}),
			stripeRows: true,
			view:new Ext.grid.GridView({markDirty:false}),
			
			enableDragDrop: true,   //拖动排序用的属性
			/*
			dropConfig: {           //拖动排序用的属性
				appendOnly:true  
			}, 
			*/
			ddGroup:ddGroupName// 'ItemGridDD',
		});	

		function getItemGridPanel() {
			return ItemGrid;
		}
		
		
		ItemGrid.on("afterrender",function(component){
			var ddrow = new Ext.dd.DropTarget(ItemGrid.getView().scroller.dom, {
				ddGroup : ddGroupName,//'ItemGridDD',
				copy    : false,//拖动是否带复制属性
				notifyDrop : function(dd, e, data) { //对应的函数处理拖放事件
					// 选中了多少行
					var rows = data.selections;
					// 拖动到第几行
					var index = dd.getDragData(e).rowIndex;
					if (typeof(index) == "undefined") {
						//index=0;
						if (ItemGrid.getStore().getCount()==0) index=0;
						else return;
					}
					// 修改store
					for(i = 0; i < rows.length; i++) {
						var rowData = rows[i];
						if(!this.copy) data.grid.getStore().remove(rowData);
						ItemGrid.getStore().insert(index, rowData);
					}
				}
			}); 	
		});		
		
	}
	//度量统计项
		var measureitemStoreData = [];	
		var measureitemStore = new Ext.data.ArrayStore({
			autoDestroy: true,
			fields: [
				{name: 'code'},
				{name: 'descript'},
				{name:'type'},
				{name:'dimOrMeasure'},
				{name:'showFormat'}
			]
		});
		
		var measureitemCm = new Ext.grid.ColumnModel({
			columns: [{
				header: '编码',
				dataIndex: 'code',
				width: 130
			}, {
				header: '描述',
				id:'crossItemdescript',		//这个ID必须要，用在grid的autoExpandColumn中
				dataIndex: 'descript',
				width: 220
				,editor: new Ext.form.TextField({allowBlank: true})
			},{
				header: '显示格式',
				dataIndex: 'showFormat',
				width: 80
			},{
				xtype: 'actioncolumn',
				header: '修改',
				width: 50,
				items: [{        
					icon   : '../images/uiimages/config.png',  // Use a URL in the icon config
					tooltip: '修改设置',
					handler: function(grid, rowIndex, colIndex) {
						rowConfig(grid, rowIndex, colIndex);
					}
				}]
				
			}]
		})		
	   // create the colItemGrid
		var measureItemGrid = new Ext.grid.EditorGridPanel({
			border:false,
			store: measureitemStore,
			stripeRows: true,
			autoExpandColumn: 'crossItemdescript',
			cm: measureitemCm,
			sm: new Ext.grid.RowSelectionModel({singleSelect: true}),
			stripeRows: true,
			view:new Ext.grid.GridView({markDirty:false}),
			
			enableDragDrop: true,   //拖动排序用的属性
			/*
			dropConfig: {           //拖动排序用的属性
				appendOnly:true  
			}, 
			*/
			ddGroup:"measureItemDD"// 'ItemGridDD',
		});	
		
		measureItemGrid.on("afterrender",function(component){
			var ddrow = new Ext.dd.DropTarget(measureItemGrid.getView().scroller.dom, {
				ddGroup : "measureItemDD",//'ItemGridDD',
				copy    : false,//拖动是否带复制属性
				notifyDrop : function(dd, e, data) { //对应的函数处理拖放事件
					// 选中了多少行
					var rows = data.selections;
					// 拖动到第几行
					var index = dd.getDragData(e).rowIndex;
					if (typeof(index) == "undefined") {
						//index=0;
						if (measureItemGrid.getStore().getCount()==0) index=0;
						else return;
					}
					// 修改store
					for(i = 0; i < rows.length; i++) {
						var rowData = rows[i];
						if(!this.copy) data.grid.getStore().remove(rowData);
						measureItemGrid.getStore().insert(index, rowData);
					}
				}
			}); 	
		});		
	
	
   // create the colItemGrid
    var colItemGrid = new ClsItemGrid("colRowItemDD").getItemGridPanel();
    var rowItemGrid = new ClsItemGrid("colRowItemDD").getItemGridPanel();	
    //var measureItemGrid = new ClsItemGrid("measureItemDD").getItemGridPanel();	

	
	///////////////////////////////////////////////////////////////////////////////////////
	///预览
	
	var preDetailViewColumnModel = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
        {header:'ID',dataIndex:'ID',sortable:true, width: 30, sortable: true,menuDisabled : true
        },{header:'名称',dataIndex:'Name',sortable:true, width: 160, sortable: true,menuDisabled : true
        },{header:'描述',dataIndex:'Descript', width: 160, sortable: true,menuDisabled : true
        }
    ]);
	
    var preDetailViewStore = new Ext.data.Store({
        //proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=getPreviewData&start=0&limit=50'}),
		proxy: new Ext.data.HttpProxy({
			url:serviceUrl,
			listeners:{
				'exception':function(proxy,type,action,options,response,arg ){
					rptCrossCfgPanel.body.unmask();
					try {
						jsonData = Ext.util.JSON.decode(response.responseText);
						Ext.Msg.alert("提示",jsonData.MSG);
					} catch (e) {
						Ext.Msg.show({
									title : '错误',
									msg : "处理响应数据失败！响应数据为：\n"
											+ (response.responseText),
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
						return;
					}					
				}	
			}				
			
			}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'ID'},
            	{name: 'Name'},
            	{name: 'Descript'},
       		]
    	})
    });	
	
	
	var filterObj=new dhcwl.KDQ.FilterCfg();
	var filterPanel=filterObj.getFilterPanel();
	

    var rptCrossCfgPanel =new Ext.Panel({
		title:'交叉表格显示',
		tbar :new Ext.Toolbar({
			layout: 'hbox',
			items : [
			{
				text: '<span style="line-Height:1">新建</span>',
				icon   : '../images/uiimages/edit_add.png',	
				xtype:'button',
				handler:OnCreate
			},"-",{
				text: '<span style="line-Height:1">保存</span>',				
				icon   : '../images/uiimages/filesave.png',
				menu: saveMenu  	
			},"-",{
				text: '<span style="line-Height:1">加载</span>',
				icon   : '../images/uiimages/read.png',
				xtype:'button',
				handler:OnLoadRptCfg
			}/*,"-",{
				text: '<span style="line-Height:1">查询</span>',
				icon   : '../images/uiimages/search.png',
				xtype:'button',
				handler:OnQryRptData
			},"-",{
				text: '<span style="line-Height:1">清空</span>',					
				icon   : '../images/uiimages/clearscreen.png',
				xtype:'button',
				handler:OnClear
			}	*/		
			]}),	
		layout:'border',
		items:[
		{
			split:true,
			collapsible: true,
			margins: '0 0 0 0',
			height:400,
			region:'north',				
			border:false,				
			//flex:1,
			layout: {
				type:'hbox',
				padding:'0',
				align:'stretch'
			},
			items: [
			{
				border:false,	
				flex:1,				
				layout: {
					type:'vbox',
					padding:'0',
					align:'stretch'
				},
				items: [
				{	
					title: '列显示',
					flex:3,
					layout:'fit',
					items:colItemGrid	
				},{
					title: '行显示',
					flex:3,
					layout:'fit',
					items:rowItemGrid					
				}]				
			},{
				border:false,				
				flex:1,
				layout: {
					type:'vbox',
					padding:'0',
					align:'stretch'
				},
				items: [
				{	
					title: '度量',
					flex:3,
					layout:'fit',
					items:measureItemGrid		
				},{
					title:'数据过滤',
					flex:3,
					layout:'fit',
					items:filterPanel					
				}]									
			}]
		},{
			region:'center',
			layout:'fit',
			id:'previewCrossRpt',
			tbar:new Ext.Toolbar({
				layout: 'hbox',
				items : ['日期范围:',
				{

					xtype: 'datefield',
					name : 'startDate',
					id : 'crossStartDate',
					//format:'Y-m-d'
					format:GetWebsysDateFormat(),
					value:new Date()
				},
				{
					xtype: 'displayfield',
					value : '-'
				},
				{
					xtype: 'datefield',
					name : 'endDate',
					id : 'crossEndDate',
					//format:'Y-m-d'
					format:GetWebsysDateFormat(),
					value:new Date()
				},"-",{
					name:'searchRptData',
					text:'<span style="line-Height:1">查询</span>',	
					xtype:'button',
					handler:OnQryRptData
			}
			]}),
			//items:preDetailViewGrid
			items:[{
				title: '查询结果',
				id:'runqianRptCross',    
				frameName: 'runqianRptDetail',
				//html: '<iframe id="runqianRpt" width=100% height=100% src= ></iframe>'		
				html: '<iframe id="runqianRptDetail" width=100% height=100% src="dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-KPIDataQryCross.raq"></iframe>'	
				,autoScroll: true					
			}]
			
		}]
    });

	//清除
	function OnClear() {
		
		
	}
	
	//新建
	function OnCreate() {	

		
		
		
		if (curRptSaveArgs.rptCode!="") {
			Ext.MessageBox.confirm('确认', '如果新建配置，那么当前配置将被清空（不会影响已保存的配置），继续吗？', function(id){
			 if (id=="no") {
				return;               	
			 }
			//清除当前配置
			clearCurCfg();
			curRptSaveArgs.rptCode="";
			curRptSaveArgs.descript="";
			curRptSaveArgs.businessType="";			
			var createWin=new dhcwl.KDQ.CreateRpt(outThis);
			createWin.CallBack=addRptItemsCfg;
			createWin.show();
			
			var previewContainer=Ext.getCmp("previewCrossRpt");
			var iframe = previewContainer.el.dom.getElementsByTagName("iframe")[0];
			iframe.src = 'dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-KPIDataQryCross.raq';			
			})	
		}else{
			//清除当前配置
			clearCurCfg();
			curRptSaveArgs.rptCode="";
			curRptSaveArgs.descript="";
			curRptSaveArgs.businessType="";				
			var createWin=new dhcwl.KDQ.CreateRpt(outThis);
			createWin.CallBack=addRptItemsCfg;
			createWin.show();
		}		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
	

	//由新建数据生成报表配置数据
	function addRptItemsCfg(newRptCfg) {
		var kpiCodes="";
		var length=newRptCfg.length;
		for(i=0;i<length;i++) {
			var rec=newRptCfg[i];
			if (rec.type=="dim" || rec.type=="measure") {
				
				var IsAggregate=rec.type=="measure"?"是":"-";
				var dOrM=rec.type=="dim"?"维度":"度量";
				
				var aryDesc=rec.descript.split("-");
				var type="col";
				
				var insData = {
					code: rec.code,
					descript: aryDesc[aryDesc.length-1],
					type:type,
					IsAggregate:IsAggregate,
					dimOrMeasure:dOrM
				};

				var itemStore=null;
				if (rec.type=="dim") {
					if (rec.isStatItem=="列显示") {
						insData.type="col";
						itemStore=colItemGrid.getStore();
					}else{
						insData.type="row";
						itemStore=rowItemGrid.getStore();
					}
				
				}else if (rec.type=="measure") {
					itemStore=measureItemGrid.getStore();
					insData.showFormat="#0.00";
				}
				
				if(itemStore.find("code",rec.code)==-1) {	//如果之前已经选择过维度或度量，就不继续添加
					var p = new itemStore.recordType(insData); // create new record
					itemStore.add(p);			
				};					
					
				//整理传入的指标编码
				if (rec.type=="measure") {
					kpiC=rec.code;
					if(kpiCodes=="") {
						kpiCodes=kpiC;
					}else{
						kpiCodes=kpiCodes+","+kpiC;
					}
				}
			}else if(rec.type=="filter") {
				var rec=newRptCfg[i];
				var filterText=rec.text;
				filterObj.addFilterText(filterText);
			}else if(rec.type=="searchItem") {
				filterObj.addSearchItem(rec);
			}
		}
		
		//filterObj.addFilterKpiCodes(kpiCodes);
		filterObj.setFilterKpiCodes(kpiCodes);
		
	}
	
	
	function OnQryRptData() {
		var startDate=Ext.get("crossStartDate").getValue();
		var endDate=Ext.get("crossEndDate").getValue();	
		if (startDate=="" || endDate=="") {
			Ext.Msg.alert("提示","请填写‘日期范围’！");
			return;
		}

		if (colItemGrid.getStore().getCount()<=0){
			Ext.Msg.alert("提示","请配置列条件！");
			return;
		}		
		if (rowItemGrid.getStore().getCount()<=0){
			Ext.Msg.alert("提示","请配置行条件！");
			return;
		}			
		if (measureItemGrid.getStore().getCount()<=0){
			Ext.Msg.alert("提示","请配置度量！");
			return;
		}		
		
		
		var descript=curRptSaveArgs.descript;
		var businessType="";
		var action="saveRptCfg";

		var aryRecs=new Array();
		//列条件统计项
		for(i=0;i<colItemGrid.getStore().getCount();i++) {
			var order=i+1;
			var item=new Array();
			var rec=colItemGrid.getStore().getAt(i);
			var dOrM="dim";
			var express=rec.get("code").replace("->",".");
			item.push("Code"+String.fromCharCode(2)+rec.get("code"));
			item.push("Descript"+String.fromCharCode(2)+rec.get("descript"));
			item.push("Type"+String.fromCharCode(2)+"col");
			item.push("dimOrMeasure"+String.fromCharCode(2)+dOrM);
			item.push("Order"+String.fromCharCode(2)+order);
			item.push("Express"+String.fromCharCode(2)+express);
			aryRecs.push(item);
		}
		//行条件统计项
		for(i=0;i<rowItemGrid.getStore().getCount();i++) {
			var order=i+1;
			var item=new Array();
			var rec=rowItemGrid.getStore().getAt(i);
			var dOrM="dim";
			var express=rec.get("code").replace("->",".");
			item.push("Code"+String.fromCharCode(2)+rec.get("code"));
			item.push("Descript"+String.fromCharCode(2)+rec.get("descript"));
			item.push("Type"+String.fromCharCode(2)+"row");
			item.push("dimOrMeasure"+String.fromCharCode(2)+dOrM);
			item.push("Order"+String.fromCharCode(2)+order);
			item.push("Express"+String.fromCharCode(2)+express);
			aryRecs.push(item);
		}		
		//度量统计项
		for(i=0;i<measureItemGrid.getStore().getCount();i++) {
			var order=i+1;
			var item=new Array();
			var rec=measureItemGrid.getStore().getAt(i);
			var dOrM="measure";
			var express=rec.get("code");
			item.push("Code"+String.fromCharCode(2)+rec.get("code"));
			item.push("Descript"+String.fromCharCode(2)+rec.get("descript"));
			item.push("Type"+String.fromCharCode(2)+"measure");
			item.push("IsAggregate"+String.fromCharCode(2)+rec.get("IsAggregate"));
			item.push("dimOrMeasure"+String.fromCharCode(2)+dOrM);
			item.push("Order"+String.fromCharCode(2)+order);
			item.push("Express"+String.fromCharCode(2)+express);
			item.push("ShowFormat"+String.fromCharCode(2)+rec.get("showFormat"));
			aryRecs.push(item);
		}		

		//过滤规则
		var filterText=filterObj.getFilterText();
		var searchItems=filterObj.getSearchItem();
	
		
		dhcwl.mkpi.Util.ajaxExc("dhcwl/kpidataquery/saverptcfg.csp",
		{
			action:"saveRpt",
			recs:aryRecs,
			filterText:filterText,
			searchItem:searchItems,
			rptType:"crossRpt",
			//recAct:recAct,			//插入还是更新
			rptCode:"tempSysRpt",
			dataSrcType:"KPI",
			businessType:"",
			descript:""	//描述
		},function(jsonData){
			if(jsonData.success==true && jsonData.tip=="ok"){
				var startDate=Ext.get("crossStartDate").getValue();
				var endDate=Ext.get("crossEndDate").getValue();
				var strParams="&rptCode=tempSysRpt&startDate="+startDate+"&endDate="+endDate+"&rptTitle="+curRptSaveArgs.descript;
				var previewContainer=Ext.getCmp("previewCrossRpt");
				var iframe = previewContainer.el.dom.getElementsByTagName("iframe")[0];
				iframe.src = 'dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-KPIDataQryCross.raq'+strParams;
			}else{
				Ext.Msg.alert("操作失败",jsonData.MSG);
			}
		},this);			
		
		
		
		
		
		
	}
	


	function OnSaveAsRptCfg() {
		var initAttrib=new Object();
		initAttrib.rptType="crossRpt";
		initAttrib.usedFor="save";
		initAttrib.curRptName=curRptSaveArgs.rptCode;
		
		var saveWin=new dhcwl.KDQ.SaveAsWin(outThis);
		saveWin.onSaveAsCallback=SaveRpt;
		saveWin.initAttrib(initAttrib);
		
		saveWin.initForSave();
		saveWin.show();	
	}
	
	function OnSaveRptCfg() {
		//如果当前配置没有保存过，那么保存和另存都是另存。
		//如果保存过，那么：保存-保存到当前配置中

		if (curRptSaveArgs.rptCode=="") {
			//另存为
			OnSaveAsRptCfg();
		}else{
			//保存
			SaveRpt(curRptSaveArgs);
		}

	}
	
	function SaveRpt(callargsObj) {
		var inRptCode=callargsObj.rptCode;
		var descript=callargsObj.descript;
		var businessType=callargsObj.businessType;
		var action="saveRptCfg";

		var aryRecs=new Array();
		//列条件统计项
		for(i=0;i<colItemGrid.getStore().getCount();i++) {
			var order=i+1;
			var item=new Array();
			var rec=colItemGrid.getStore().getAt(i);
			var dOrM="dim";
			var express=rec.get("code").replace("->",".");
			item.push("Code"+String.fromCharCode(2)+rec.get("code"));
			item.push("Descript"+String.fromCharCode(2)+rec.get("descript"));
			item.push("Type"+String.fromCharCode(2)+"col");
			item.push("dimOrMeasure"+String.fromCharCode(2)+dOrM);
			item.push("Order"+String.fromCharCode(2)+order);
			item.push("Express"+String.fromCharCode(2)+express);
			aryRecs.push(item);
		}
		//行条件统计项
		for(i=0;i<rowItemGrid.getStore().getCount();i++) {
			var order=i+1;
			var item=new Array();
			var rec=rowItemGrid.getStore().getAt(i);
			var dOrM="dim";
			var express=rec.get("code").replace("->",".");
			item.push("Code"+String.fromCharCode(2)+rec.get("code"));
			item.push("Descript"+String.fromCharCode(2)+rec.get("descript"));
			item.push("Type"+String.fromCharCode(2)+"row");
			item.push("dimOrMeasure"+String.fromCharCode(2)+dOrM);
			item.push("Order"+String.fromCharCode(2)+order);
			item.push("Express"+String.fromCharCode(2)+express);
			aryRecs.push(item);
		}		
		//度量统计项
		for(i=0;i<measureItemGrid.getStore().getCount();i++) {
			var order=i+1;
			var item=new Array();
			var rec=measureItemGrid.getStore().getAt(i);
			var dOrM="measure";
			var express=rec.get("code");
			item.push("Code"+String.fromCharCode(2)+rec.get("code"));
			item.push("Descript"+String.fromCharCode(2)+rec.get("descript"));
			item.push("Type"+String.fromCharCode(2)+"measure");
			item.push("IsAggregate"+String.fromCharCode(2)+"是");
			item.push("dimOrMeasure"+String.fromCharCode(2)+dOrM);
			item.push("Order"+String.fromCharCode(2)+order);
			item.push("Express"+String.fromCharCode(2)+express);
			item.push("ShowFormat"+String.fromCharCode(2)+rec.get("showFormat"));
			aryRecs.push(item);
		}		

		//过滤规则
		var filterText=filterObj.getFilterText();
		var searchItems=filterObj.getSearchItem();
		dhcwl.mkpi.Util.ajaxExc("dhcwl/kpidataquery/saverptcfg.csp",
		{
			action:"saveRpt",
			recs:aryRecs,
			filterText:filterText,
			searchItem:searchItems,
			rptType:"crossRpt",
			//recAct:recAct,			//插入还是更新
			rptCode:inRptCode,
			dataSrcType:"KPI",
			businessType:businessType,
			descript:descript	//描述
		},function(jsonData){
			if(jsonData.success==true && jsonData.tip=="ok"){
				Ext.Msg.alert("提示","操作成功！");
				rptCode=inRptCode;
				rptCrossCfgPanel.setTitle("交叉表格显示——"+rptCode);

				if (curRptSaveArgs!=callargsObj) {
					curRptSaveArgs.rptCode=callargsObj.rptCode;
					curRptSaveArgs.descript=callargsObj.descript;
					curRptSaveArgs.businessType=callargsObj.businessType;
				}

			}else{
				Ext.Msg.alert("操作失败",jsonData.MSG);
			}
		},this);		
	}

 	function OnLoadRptCfg() {

		var saveWin=new dhcwl.KDQ.SaveAsWin(outThis);

		var initAttrib=new Object();
		initAttrib.rptType="crossRpt";
		initAttrib.usedFor="load";
		//initAttrib.curRptName=rptName;
		saveWin.initAttrib(initAttrib);
	
		saveWin.initForLoad();
		saveWin.onLoadCallback=LoadRpt;
		saveWin.show();		
		
	}
	
	function LoadRpt(outRptCode,outRptID) {

		dhcwl.mkpi.Util.ajaxExc("dhcwl/kpidataquery/saverptcfg.csp",
		{
			action:"getRptDetailCfgData",
			rptCode:outRptCode 	//过滤项标识,
		},function(jsonData){
			if(jsonData.success==true && jsonData.tip=="ok" && jsonData.MSG=='SUCESS'){
				curRptSaveArgs.rptCode=jsonData.cfgData.Code;
				curRptSaveArgs.descript=jsonData.cfgData.Descript;
				curRptSaveArgs.businessType=jsonData.cfgData.BusinessType;
				refreshGrids(jsonData.cfgData);
				rptCrossCfgPanel.setTitle("交叉表格显示——"+jsonData.cfgData.Code);
			}else{
				Ext.Msg.alert("操作失败",jsonData.MSG);
			}
		},this);

	}
	
	function refreshGrids(cfgData) {
		//清除当前配置
		clearCurCfg();
		var newRptCfg=cfgData.rptsub;
		var kpiCodes="";
		var length=newRptCfg.length;
				
		for(i=0;i<length;i++) {
			var rec=newRptCfg[i];
			var dOrM=rec.dimOrMeasure;	//"维度","度量"
			var descript=rec.descript;
			var insData = {
				code: rec.code,
				descript: descript,
				type:rec.type,
				dimOrMeasure:dOrM
			};			
			var itemStore=null;
			if (rec.type=="col") {
					itemStore=colItemGrid.getStore();
					var p = new itemStore.recordType(insData); // create new record
					itemStore.add(p);					
			}else if(rec.type=="row"){
					itemStore=rowItemGrid.getStore();
					var p = new itemStore.recordType(insData); // create new record
					itemStore.add(p);
			}else if (rec.type=="measure") {
				itemStore=measureItemGrid.getStore();
				insData.showFormat=rec.showFormat;
				var p = new itemStore.recordType(insData); // create new record
				itemStore.add(p);
				//整理传入的指标编码
				var kpiC=rec.code;
				if(kpiCodes=="") {
					kpiCodes=kpiC;
				}else{
					kpiCodes=kpiCodes+","+kpiC;
				}				
				
			}else if(rec.type=="filter") {
				var rec=newRptCfg[i];
				var filterText=rec.Express;
				filterObj.addFilterText(filterText);
			}else if(rec.type=="searchitem") {
				filterObj.addSearchItem(rec);
			}
		}
		//filterObj.addFilterKpiCodes(kpiCodes);	
		filterObj.setFilterKpiCodes(kpiCodes);			
	}
	
	function OnShowHelpData()
	{
		var helpDataObj=new dhcwl.BDQ.HelpData()
		var helpDataWin=helpDataObj.getHelpDataWin();
		helpDataWin.show();

	}
	
    this.getRptCrossCfgObjPanel=function(){
    	return rptCrossCfgPanel;
    }  	
	

	
	//清除当前配置
	function clearCurCfg() {
		rptCode='';
		rptCrossCfgPanel.setTitle("交叉表格显示——NULL");
		//itemStore.removeAll();
		colItemGrid.getStore().removeAll();
		rowItemGrid.getStore().removeAll();
		measureItemGrid.getStore().removeAll();		
		filterObj.setFilterText("");
		filterObj.removeSearchItem();
	}
	
	function rowConfig(grid, rowIndex, colIndex){
		if (grid.getStore().getAt(rowIndex).get("dimOrMeasure")=="维度") {
			Ext.MessageBox.prompt('属性入参', '设置属性入参:', function(btn, text){
				if (btn=="ok") {
					//如果是维度，提示输入属性入参
					var code=grid.getStore().getAt(rowIndex).get("code");
					if (text=="") {
						var newCode=code.split("(")[0];
						grid.getStore().getAt(rowIndex).set("code",newCode);
					}else{
						var newCode=code.split("(")[0]+"("+text+")";
						grid.getStore().getAt(rowIndex).set("code",newCode);			
					}
				}
			});
		}else {
			var rptProObj=new dhcwl.KDQ.RptItemPro();
			var rptProWin=rptProObj.getRptItemProWin();
			
			
			
			var rec=grid.getStore().getAt(rowIndex);
			
			var oldValueObj={
				descript:rec.get('descript'),
				//IsAggregate:rec.get('IsAggregate'),
				showFormat:rec.get('showFormat')
			};
			rptProObj.CallBack=updateRec;
			rptProObj.ModifyRec=rec;
			rptProObj.initV(oldValueObj);
			rptProWin.show();					

		}
	}
	
	this.getMyName=function() {
		return "RptCrossCfg";
		
	}

	function updateRec(rec,newVObj) {
		for (var v in newVObj) {
			rec.set(v,newVObj[v]);
		}
		
	}
	
}

