(function(){
	Ext.ns("dhcwl.KDQ.ShowStatData");
})();
///描述: 		查询对象
///编写者：		WZ
///编写日期: 		2016-11
dhcwl.KDQ.ShowStatData=function(pObj){
	var serviceUrl="dhcwl/kpidataquery/showstatdata.csp";
	var outThis=this;
	var parentObj=pObj;
	var thisRptCode="";
	var thisRptTitle="";
	var thisRptType="";
	var qryParam=new Object();
	
    var reader = new Ext.data.ArrayReader({}, [
			{name: 'descript'},
			{name:'itemCls'}
    ]);
	
    var cfgStore = new Ext.data.GroupingStore({
		autoDestroy: true,
        reader:reader,
		groupField:'itemCls'
    });	
	
	var cfgCm = new Ext.grid.ColumnModel({
        columns: [{
            header: '描述',
			id:'descript',		//这个ID必须要，用在grid的autoExpandColumn中
            dataIndex: 'descript',
            width: 150
        }, {
            header: '类型',
            dataIndex: 'itemCls',
            width: 80
        }]
	})	

    var cfgGrid = new Ext.grid.GridPanel({
		title:'报表配置',
        store: cfgStore,
        cm: cfgCm,
		autoExpandColumn: 'descript',
        view: new Ext.grid.GroupingView({
            forceFit:true,
            groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Items" : "Item"]})'
        })
    });	

function StringObj(id) {
		this.myID=id;
		this.aryData=new Array();
		this.add=add;
		this.del=del;
		this.getStrData=getStrData;
		this.setStrData=setStrData;
		this.isExist=isExist;
		function add(str) {
			var isExist=false;
			for (x in this.aryData)
			{
				if (this.aryData[x]==str)  return;
			}
			this.aryData.push(str)
		}
		
		function del(str) {
			//modify by wz.2017-06-15
			var pos = this.aryData.indexOf(str);
			this.aryData.remove(str);
			return;
			
			for(var i=0;i<this.aryData.length;i++) {
				if (this.aryData[i]==str) {
					this.aryData.splice(i,1);
					return;
				}
			}

		}
		
		function getStrData(separator) {
			return this.aryData.join(separator);
		}
		
		function setStrData(strData) {
			this.aryData.length=0;
			if (strData=="") return;
			this.aryData=strData.split(",");
		}

		function isExist(str) {
			//modify by wz.2017-6-15;
			return this.aryData.indexOf(str)>=0;
			
			var isExist=false;
			for (x in this.aryData)
			{
				if (this.aryData[x]==str) {
					isExist=true;
					break;
				}
			}	
			return isExist;
		}
		
	}	

    var conditionGrid = new Ext.grid.PropertyGrid({
		title:'查询条件',
        propertyNames: {},
        source: {},
		customEditors: {},		
        viewConfig : {
            forceFit: true,
            scrollOffset: 2 // the grid will never have scrollbars
        }
    });	
	

	var showStatPanel=new Ext.Panel({
		title:'显示统计数据',
		layout:'border',	
		defaults: {
		    split: true
		},
		closable:true,
		items: [
		{
			title:'查询及配置',
			width: 200,
			layout: 'border',
	    	//id: 'layout-browser',
	        region:'east',
	        border: false,
	        split:true,
			collapsible: true,
			margins: '0 0 0 0',
			items: [{
				region:'north',
				split: true,
				height: 200,
				//minSize: 150,	
				id:'conditionRegn',
				items:conditionGrid,
				layout:'fit'
			},{
				region: 'center',	
				layout:'fit',
				items:cfgGrid
			}],
			tbar:new Ext.Toolbar({
				layout: 'hbox',
				items : [		
				{
					text: '加载',
					icon   : '../scripts/dhcwl/BasicDataQuery/shared/icons/fam/add.gif'	,
					handler:OnLoadRptCfg
				}
				,{
					text: '查询',
					icon   : '../scripts/dhcwl/BasicDataQuery/shared/icons/fam/refresh.gif'	,
					handler:OnQueryKBQData
				}/*,{
					text: '刷新报表',
					icon   : '../scripts/dhcwl/BasicDataQuery/shared/icons/fam/refresh.gif'	,
					handler:OnFreshKBQData
				}*/]	
			})				
		},		
		{
		    region:'center',
		    layout:'fit',
			id:'viewPanelID'
			//,autoScroll: true	
			 //loader:{ url: "dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-KPIDataQry.raq",autoLoad:true, scripts: true}			
			
			
			/*
			items:[{
				id:'viewPanelID',
				layout:'fit'
				
			}]
			*/
			
		}]		
    });

	function OnLoadRptCfg() {
		var initAttrib=new Object();
		initAttrib.rptType="";
		initAttrib.usedFor="exec";
		initAttrib.curRptName="";
		
		var saveWin=new dhcwl.KDQ.SaveAsWin(outThis);
		saveWin.onLoadCallback=LoadRpt;
		saveWin.initAttrib(initAttrib);
		saveWin.initForLoad();
		//saveWin.initForSave();
		saveWin.show();			
		
	}
	
	function LoadRpt(outRptCode,outRptID) {
		thisRptCode=outRptCode;
		dhcwl.mkpi.Util.ajaxExc(serviceUrl,
		{
			action:"getLoadRptCfgData",
			rptCode:outRptCode
		},function(jsonData){
			if(jsonData.success==true && jsonData.tip=="ok" && jsonData.MSG=='SUCESS'){
				updateGrids(jsonData.cfgData);
			}else{
				Ext.Msg.alert("操作失败",jsonData.MSG);
			}
		},this);
	}
	
    this.getShowStatPanel=function(){
    	return showStatPanel;
    }  

	function updateGrids(cfgData) {
		cfgStore.removeAll();

		var insData = {
			descript: "报表编码:"+thisRptCode,
			itemCls:"总览"
		};		
		var p = new cfgStore.recordType(insData); // create new record
		cfgStore.add(p); 			
		
		var rptDesc=cfgData.rptDesc;
		thisRptTitle=rptDesc;
		var insData = {
			descript: "报表标题:"+rptDesc,
			itemCls:"总览"
		};	
		var p = new cfgStore.recordType(insData); // create new record
		cfgStore.add(p); 		

		var rptBusinessType=cfgData.rptBusinessType;
		var insData = {
			descript: "业务类型:"+rptBusinessType,
			itemCls:"总览"
		};	
		var p = new cfgStore.recordType(insData); // create new record
		cfgStore.add(p); 

		var rptType=cfgData.rptType;
		thisRptType=rptType;
		var insData = {
			descript: "报表类型:"+rptType,
			itemCls:"总览"
		};	
		var p = new cfgStore.recordType(insData); // create new record
		cfgStore.add(p); 
		
		var rptUser=cfgData.rptUser;
		var insData = {
			descript: "报表作者:"+rptUser,
			itemCls:"总览"
		};	
		var p = new cfgStore.recordType(insData); // create new record
		cfgStore.add(p); 
 		
		aryRptsub=cfgData.rptsub;
		var aryConditionCfg=new Array();
		for(var i=0;i<aryRptsub.length;i++)
		{
			var p = new cfgStore.recordType(aryRptsub[i]); // create new record
			cfgStore.add(p); 
			
			if (aryRptsub[i].itemCls=="查询项") {
				aryConditionCfg.push(aryRptsub[i]);
			}
		}
		
	
		//if (aryConditionCfg.length>0 ) 
		rebuildConditionGrid(aryConditionCfg);
		rebuildcorssRpt();
	}
	
	function rebuildcorssRpt() {
		
		var raqName=""
		if (thisRptType=="行式报表") raqName="DTHealth-DHCWL-KPIDataQry.raq";
		else if(thisRptType=="交叉报表")  raqName="DTHealth-DHCWL-KPIDataQryCross.raq";
		var gridContainer=Ext.getCmp("viewPanelID");
		
		
		gridContainer.add(
		{
			//title: '查询结果',
			html: '<iframe id="runqianRpt" width=100% height=100% src="dhccpmrunqianreport.csp?reportName='+raqName+'"></iframe>'	
			//,forceLayout :true
			,autoScroll: true	
			//,preventBodyReset :true 			
		})		
		gridContainer.doLayout(); 
		
		
		
		
		/*
		var templatePanel=new Ext.Panel({
			 id: 'myPanel',
			 title: 'Anchor Layout',                                
			 loader:{ url: "dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-KPIDataQry.raq",autoLoad:true, scripts: true}//加载1.htm页面
		});			
		
		
		
		var gridContainer=Ext.getCmp("viewPanelID");
		gridContainer.removeAll();
		gridContainer.add(templatePanel);
		*/
		
		/*
		//另一种方法
		var panel=Ext.getCmp("viewPanelID");
		panel.load({
			//url:"dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-KPIDataQry.raq",
			//discardUrl: true,

			//url:'https://www.baidu.com/',
			url:'dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-KPIDataQry.raq',
			scripts:true
		});		
		
		//panel.doLayout();
		*/
	}
	
	function rebuildConditionGrid(aryConditionCfg){

        var propertyNames= {
            startDate: '开始日期',
            endDate: '结束日期'
		};
		var sd=new Date().format(GetWebsysDateFormat());
		var ed=new Date().format(GetWebsysDateFormat());
		var source= {
			startDate:sd,
			endDate:ed
		};
		var customEditors= {
			'startDate': new Ext.grid.GridEditor(new Ext.form.DateField({format:GetWebsysDateFormat()})),
			'endDate': new Ext.grid.GridEditor(new Ext.form.DateField({format:GetWebsysDateFormat()}))
		};
		for (var i=0;i<aryConditionCfg.length;i++) {
			var descript=aryConditionCfg[i].descript;
			var code=aryConditionCfg[i].code;
			var value=aryConditionCfg[i].value;
			propertyNames[code]=descript;
			source[code]=value;

			var valueCombo=new Ext.form.ComboBox({
								allowBlank:true,
								listWidth :300,
								pageSize :15,
								minChars :0,
								displayField:   'value',
								valueField:     'value',
								store:new Ext.data.Store({
										proxy: new Ext.data.HttpProxy({url:'dhcwl/kpidataquery/filterCfg.csp'+'?action=getSearchItemValue'}),
										reader: new Ext.data.JsonReader({
											totalProperty: 'totalNum',
											root: 'root',
											fields:[
												//{name: 'description'},
												{name: 'value'}
											]
										}),
										listeners :{
											'load':function(store,records,options) {
												store.each(function(rc){  
													if (store.chkCboStr.isExist(rc.get("value"))) rc.set('check',true);
												});
											}
										}										
										
									}),	
								mode:           'remote',
								triggerAction:  'all',
								typeAhead: true,
								tpl:'<tpl for="."><div class="x-combo-list-item"><span><input type="checkbox" {[values.check?"checked":""]}  value="{[values.value]}" style="height: 12px;"/>&nbsp{value}</span></div></tpl>', 
				
								onSelect : function(record, index){  
									if(this.fireEvent('beforeselect', this, record, index) !== false){ 
										record.set('check',!record.get('check'));
										if (record.get('check')) {
											this.chkCboStr.add(record.get('value'))
										}else{
											this.chkCboStr.del(record.get('value'))											
										}
										
										this.setValue(this.chkCboStr.getStrData());  
										this.value=this.chkCboStr.getStrData();  
										this.fireEvent('select', this, record, index);
									}  
								},
								listeners :{
									'expand':function(combo) {
										var v=combo.getValue();
										this.chkCboStr.setStrData(v);
									},
									'afterrender':function(comp) {
										comp.getStore().chkCboStr=comp.chkCboStr;
									}
								}
							})	;			

			valueCombo.chkCboStr=new StringObj(i+1);
			customEditors[code]=new Ext.grid.GridEditor(valueCombo);	
		}

		//var newConditionGrid=conditionGrid.cloneConfig({propertyNames:propertyNames,source:source,customEditors:customEditors});
		var newConditionGrid = new Ext.grid.PropertyGrid({
			title:'查询条件',
			propertyNames: propertyNames,
			source: source,
			customEditors: customEditors,		
			viewConfig : {
				forceFit: true,
				scrollOffset: 2 // the grid will never have scrollbars
			},
			initComponent: function () {	//重写initComponent,注释掉排序。
					this.customRenderers = this.customRenderers || {};
					this.customEditors = this.customEditors || {};
					this.lastEditRow = null;
					var b = new Ext.grid.PropertyStore(this);
					this.propStore = b;
					var a = new Ext.grid.PropertyColumnModel(this, b);
					//b.store.sort("name", "ASC");
					this.addEvents("beforepropertychange", "propertychange");
					this.cm = a;
					this.ds = b.store;
					Ext.grid.PropertyGrid.superclass.initComponent.call(this);
					this.mon(this.selModel, "beforecellselect", function (e, d, c) {
						if (c === 0) {
							this.startEditing.defer(200, this, [d, 1]);
							return false;
						}
					}, this);
				}			
		});	
		
		newConditionGrid.on('beforeedit',function(obj){
			if (obj.record.get("name")!="startDate" && obj.record.get("name")!="endDate"  ) {
				var col=obj.column;
				var row=obj.row;
				var cm=obj.grid.getColumnModel();
				var editor=cm.getCellEditor( col, row ) ;
				
				delete editor.field.lastQuery;

				var rec=obj.record;
				var code=rec.get("name");
				editor.field.getStore().setBaseParam("code",code);
			}
		});	
		
		newConditionGrid.on('validateedit',function(e){
			//e.record.data[e.field] = e.value.format(GetWebsysDateFormat());
			if(e.record.data.name=="startDate" || e.record.data.name=="endDate") {
				e.value=e.value.format(GetWebsysDateFormat());
			}
		});	

		newConditionGrid.on('beforepropertychange',function(source,recordId,value,oldValue){
			/*
			if (recordId=="startDate" || recordId=="endDate") {
				value=value.format(GetWebsysDateFormat());
			}
			*/
		});	


		var container= conditionGrid.ownerCt ;
		container.items.clear();
		container.items.add(null,newConditionGrid);
		container.doLayout();
		
	}
	
	function OnQueryKBQData() {
		
		
		if (Ext.getCmp('conditionRegn').items.getCount()<=0) return;

		var startDate="";
		var endDate="";
		
		var conditionGrid=Ext.getCmp('conditionRegn').items.first();
		
		if (thisRptCode=="") {
			Ext.Msg.alert("提示","查询之前需要先加载报表！");
			return;
		}
		
		var args="";
		//报表统计项
		for(i=0;i<conditionGrid.getStore().getCount();i++) {
			var rec=conditionGrid.getStore().getAt(i);
			var express=rec.get("name").replace("->",".");
			var value=rec.get("value");
			
			if (rec.get("name")=="startDate") {
				if (!value) {
					Ext.Msg.alert("提示","请输入查询开始日期和结束日期！");
					return;					
				}
				startDate=value;//value.format(GetWebsysDateFormat());
				continue;
			}
			if (rec.get("name")=="endDate") {
				if (!value) {
					Ext.Msg.alert("提示","请输入查询开始日期和结束日期！");
					return;					
				}				
				endDate=value;//value.format(GetWebsysDateFormat());
				continue;
			}	
				
			if (value=="") continue;
			if (args=="") args=express+"equal"+value;
			else args=args+"separator"+express+"equal"+value;
		}	
				
		var gridContainer=Ext.getCmp("viewPanelID");

		var raqName=""
		if (thisRptType=="行式报表") raqName="DTHealth-DHCWL-KPIDataQry.raq";
		else if(thisRptType=="交叉报表")  raqName="DTHealth-DHCWL-KPIDataQryCross.raq";

		var strParams="&rptCode="+thisRptCode+"&startDate="+startDate+"&endDate="+endDate+"&searchArgs="+args+"&rptTitle="+thisRptTitle;
		var iframe = gridContainer.el.dom.getElementsByTagName("iframe")[0];
		iframe.src = 'dhccpmrunqianreport.csp?reportName='+raqName+ strParams;	

		//gridContainer.doLayout(); 
	}
	
	function OnFreshKBQData() {
		/*
		var gridContainer=Ext.getCmp("viewPanelID");
		var iframe = gridContainer.el.dom.getElementsByTagName("iframe")[0];
		iframe.contentDocument.getElementsByTagName("frame")[0].contentWindow.location.reload(true);
		*/
		
		
		var gridContainer=Ext.getCmp("viewPanelID");
		var oldsize=gridContainer.getSize();  

		gridContainer.setSize(oldsize.width-1,oldsize.height); 
		var oldsize=gridContainer.getSize();  
		gridContainer.setSize(oldsize.width+1,oldsize.height); 		
		
	}

}

