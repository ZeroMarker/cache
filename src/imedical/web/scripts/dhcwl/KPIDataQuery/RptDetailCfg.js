(function(){
	Ext.ns("dhcwl.KDQ.RptDetailCfg");
})();
//////////////////////////////////////////////////////////////////////
///描述: 		明细报表配置页面
///编写者：		WZ
///编写日期: 	2017-6
//////////////////////////////////////////
dhcwl.KDQ.RptDetailCfg=function(pObj){
	var serviceUrl="dhcwl/kpidataquery/rptdetailcfg.csp";
	var outThis=this;
	var parentObj=pObj;
	var rptCode="";
	var curRptSaveArgs=new Object();	//保存配置时需要用到的参数
	curRptSaveArgs.rptCode="";
	curRptSaveArgs.descript="";
	curRptSaveArgs.businessType="";
				
	///////////////////////////////////////////////////////////////////////////////////////
	//组件
	//菜单：保存
	var saveMenu = new Ext.menu.Menu({
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
	
	//列显示grid之store
	var itemStoreData = [];	
    var itemStore = new Ext.data.ArrayStore({
		autoDestroy: true,
        fields: [
			{name: 'code'},
			{name: 'descript'},
			{name:'type'},
			{name:'IsAggregate'},
			{name:'dimOrMeasure'},
			{name:'showFormat'}
        ]
    });
	//列显示grid之ColumnModel
	var itemCm = new Ext.grid.ColumnModel({
        columns: [{
            header: '编码',
            dataIndex: 'code',
            width: 130
        }, {
            header: '描述',
			id:'detailItemdescript',		//这个ID必须要，用在grid的autoExpandColumn中
            dataIndex: 'descript',
            width: 220
			,editor: new Ext.form.TextField({allowBlank: true})
        }, {
            header: '合计',
            dataIndex: 'IsAggregate',
            width: 80
			//,xtype: 'checkcolumn'
        }, {
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
    //列显示grid
    var itemGrid = new Ext.grid.EditorGridPanel({
		border:false,
        store: itemStore,
        stripeRows: true,
        autoExpandColumn: 'detailItemdescript',
		cm: itemCm,
        sm: new Ext.grid.RowSelectionModel({singleSelect: true}),
		stripeRows: true,
		view:new Ext.grid.GridView({markDirty:false}),
		
		enableDragDrop: true,   //拖动排序用的属性
		dropConfig: {           //拖动排序用的属性
			appendOnly:true  
		}, 
		ddGroup: 'itemGridDD'
    });	
	
	itemStore.loadData(itemStoreData);
	

	var filterObj=new dhcwl.KDQ.FilterCfg();	//过滤规则页面对象
	var filterPanel=filterObj.getFilterPanel();
	
	//明细报表主面板
    var rptDetailCfgPanel =new Ext.Panel({
		title:'行式表格显示',
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
			}	
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
				//border:false,	
				title: '列显示',
				flex:3,
				layout:'fit',
				items:itemGrid	//列显示grid		
			},{
				//border:false,	
				title:'数据过滤',
				flex:3,
				layout:'fit',
				items:filterPanel	//过滤面板
				
			}]
		},{
			region:'center',
			layout:'fit',
			id:'previewDetailRpt',
			tbar:new Ext.Toolbar({
				layout: 'hbox',
				items : ['日期范围:',
				{
					xtype: 'datefield',
					name : 'startDate',
					id : 'detailStartDate',
					//format:'Y-m-d'
					format:GetWebsysDateFormat(),
					value:new Date()
				},{
					xtype: 'displayfield',
					value : '-'
				},{
					xtype: 'datefield',
					name : 'endDate',
					id : 'detailEndDate',
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
				id:'runqianRptDetail',    
				frameName: 'runqianRptDetail',	
				html: '<iframe id="runqianRptDetail" width=100% height=100% src="dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-KPIDataQry.raq"></iframe>'	
				,autoScroll: true	
			}]
			
		}]
    });

	/////////////////////////////////////////////////////////////////////////////////////////////
	//函数
	
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
			
			var previewContainer=Ext.getCmp("previewDetailRpt");
			var iframe = previewContainer.el.dom.getElementsByTagName("iframe")[0];
			iframe.src = 'dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-KPIDataQry.raq';			
			
			
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
				var showFormat=rec.type=="measure"?"#0.00":"-";
				var dOrM=rec.type=="dim"?"维度":"度量";
				
				var aryDesc=rec.descript.split("-");
				
				
				var insData = {
					code: rec.code,
					descript: aryDesc[aryDesc.length-1],
					type:"col",
					IsAggregate:IsAggregate,
					dimOrMeasure:dOrM,
					showFormat:showFormat
				};
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

		var startDate=Ext.get("detailStartDate").getValue();
		var endDate=Ext.get("detailEndDate").getValue();	
		if (startDate=="" || endDate=="") {
			Ext.Msg.alert("提示","请填写‘日期范围’！");
			return;
		}
		
		if (itemStore.getCount()<=0){
			Ext.Msg.alert("提示","请配置列条件！");
			return;
		}
		
		var aryRecs=new Array();
		//报表统计项
		for(i=0;i<itemStore.getCount();i++) {
			var order=i+1;
			var item=new Array();
			var rec=itemStore.getAt(i);
			var dOrM=rec.get("dimOrMeasure")=="维度"?"dim":"measure";
			var express=rec.get("dimOrMeasure")=="维度"?rec.get("code").replace("->","."):rec.get("code");
			item.push("Code"+String.fromCharCode(2)+rec.get("code"));
			item.push("Descript"+String.fromCharCode(2)+rec.get("descript"));
			item.push("Type"+String.fromCharCode(2)+"col");
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
			rptType:"grpRpt",
			rptCode:'tempSysRpt',
			dataSrcType:"KPI",
			businessType:"",
			descript:""	//描述
		},function(jsonData){
			if(jsonData.success==true && jsonData.tip=="ok"){
				var startDate=Ext.get("detailStartDate").getValue();
				var endDate=Ext.get("detailEndDate").getValue();
				var searchArgs=filterObj.getSearchItemArgs();
				var strParams="&rptCode=tempSysRpt&startDate="+startDate+"&endDate="+endDate+"&searchArgs="+searchArgs;
				var previewContainer=Ext.getCmp("previewDetailRpt");
				var iframe = previewContainer.el.dom.getElementsByTagName("iframe")[0];
				iframe.src = 'dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-KPIDataQry.raq'+strParams;

			}else{
				Ext.Msg.alert("操作失败",jsonData.MSG);
			}
		},this);	
		

	}
	


	function OnSaveAsRptCfg() {
		var initAttrib=new Object();
		initAttrib.rptType="grpRpt";
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
		//var recAct=callargsObj.act;
		
		var action="saveRptCfg";

		var aryRecs=new Array();
		//报表统计项
		for(i=0;i<itemStore.getCount();i++) {
			var order=i+1;
			var item=new Array();
			var rec=itemStore.getAt(i);
			var dOrM=rec.get("dimOrMeasure")=="维度"?"dim":"measure";
			var express=rec.get("dimOrMeasure")=="维度"?rec.get("code").replace("->","."):rec.get("code");
			item.push("Code"+String.fromCharCode(2)+rec.get("code"));
			item.push("Descript"+String.fromCharCode(2)+rec.get("descript"));
			item.push("Type"+String.fromCharCode(2)+"col");
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
			rptType:"grpRpt",
			//recAct:recAct,			//插入还是更新
			rptCode:inRptCode,
			dataSrcType:"KPI",
			//userID:"",
			businessType:businessType,
			descript:descript	//描述
		},function(jsonData){
			if(jsonData.success==true && jsonData.tip=="ok"){
				Ext.Msg.alert("提示","操作成功！");
				rptCode=inRptCode;
				rptDetailCfgPanel.setTitle("行式表格显示——"+rptCode);
				
				//
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
		initAttrib.rptType="grpRpt";
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
				rptDetailCfgPanel.setTitle("行式表格显示——"+jsonData.cfgData.Code);
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
			if (rec.type=="col") {
				var IsAggregate=rec.IsAggregate;
				var showFormat=rec.showFormat;
				if (!IsAggregate) IsAggregate="-";
				if (!showFormat) showFormat="-";
				var dOrM=rec.dimOrMeasure;	//"维度","度量"
				var descript=rec.descript;
				var insData = {
					code: rec.code,
					descript: descript,
					type:rec.type,
					IsAggregate:IsAggregate,
					dimOrMeasure:dOrM,
					showFormat:showFormat
				};
				
				var p = new itemStore.recordType(insData); // create new record
				itemStore.add(p);					
				//整理传入的指标编码
				if (dOrM=="度量") {
					kpiC=rec.code;
					if(kpiCodes=="") {
						kpiCodes=kpiC;
					}else{
						kpiCodes=kpiCodes+","+kpiC;
					}
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
	
    this.getRptDetailDataCfgPanel=function(){
    	return rptDetailCfgPanel;
    }  	
	
	
	
	itemGrid.on("afterrender",function(component){
		var ddrow = new Ext.dd.DropTarget(itemGrid.getView().scroller.dom, {
			ddGroup : 'itemGridDD',
			copy    : false,//拖动是否带复制属性
			notifyDrop : function(dd, e, data) { //对应的函数处理拖放事件
				// 选中了多少行
				var rows = data.selections;
				// 拖动到第几行
				var index = dd.getDragData(e).rowIndex;
				if (typeof(index) == "undefined") {
					return;
				}
				// 修改store
				for(i = 0; i < rows.length; i++) {
					var rowData = rows[i];
					if(!this.copy) itemStore.remove(rowData);
					itemStore.insert(index, rowData);
				}
			}
		}); 	
	});
	
	
	//清除当前配置
	function clearCurCfg() {
		rptCode='';
		rptDetailCfgPanel.setTitle("行式表格显示——NULL");
		itemStore.removeAll();
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
				IsAggregate:rec.get('IsAggregate'),
				showFormat:rec.get('showFormat')
			};
			rptProObj.CallBack=updateRec;
			rptProObj.ModifyRec=rec;
			rptProObj.initV(oldValueObj);
			rptProWin.show();
			
			
			
			/*
			Ext.MessageBox.show({
					   title:'汇总？',
					   msg: '是否在报表中对此统计项进行汇总?',
					   buttons: Ext.MessageBox.YESNOCANCEL,
					   fn: function (btn) {
						   if (btn=="yes") {
							   grid.getStore().getAt(rowIndex).set("IsAggregate",true);
						   }else if  (btn=="no") {
								grid.getStore().getAt(rowIndex).set("IsAggregate",false);							   
						   }
					   },
					   icon: Ext.MessageBox.QUESTION
				   });	
			*/				   

		}
	}
	
	this.getMyName=function() {
		return "RptDetailCfg";
		
	}
	
	function updateRec(rec,newVObj) {
		for (var v in newVObj) {
			rec.set(v,newVObj[v]);
		}
		
	}
}

