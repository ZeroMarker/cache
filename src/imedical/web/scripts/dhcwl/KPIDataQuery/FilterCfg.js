(function(){
	Ext.ns("dhcwl.KDQ.FilterCfg");
})();
///描述: 		查询对象
///编写者：		WZ
///编写日期: 		2016-11
dhcwl.KDQ.FilterCfg=function(){
	var serviceUrl="dhcwl/kpidataquery/filterCfg.csp";
	var outThis=this;
	var kpiCodes="";
	
	//字符串类
	//支持add,del,getData
	//
	function StringObj() {
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
	
	var chkCboStr=new StringObj();

	var filterForm= new Ext.FormPanel({
		labelWidth: 80, // label settings here cascade unless overridden
		//labelAlign : 'right',
		hideLabels:true,
		//border:false,
		title:'过滤条件',
		layout:'fit',
        items:[{  	
				//fieldLabel:'过滤条件',
				name:'filterField',
				xtype: 'textarea'			
		}],
		tbar:new Ext.Toolbar({
			layout: 'hbox',
			items : [
			{
				id:'modifyBtn',
				
				text:'<span style="line-Height:1">修改</span>',	
				xtype:'button',
				handler:OnModify
			},"-",
			{
				id:'resetBtn',
				text:'<span style="line-Height:1">重置</span>',
				xtype:'button',
				handler:OnResetCond				
			}]
		})			
	});
	
    var store = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({url:serviceUrl}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
				//{name:'kpiCode'},
				{name:'code'},
				{name:'descript'},
				{name:'value'}
			]
    	})
    });	
	

	
	var valueCombo=new Ext.form.ComboBox({
								allowBlank:true,
								listWidth :300,
								pageSize :15,
								minChars :0,
								displayField:   'value',
								valueField:     'value',
								store:new Ext.data.Store({
										proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=getSearchItemValue'}),
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
													if (chkCboStr.isExist(rc.get("value"))) rc.set('check',true);
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
											chkCboStr.add(record.get('value'))
										}else{
											chkCboStr.del(record.get('value'))											
										}
										
										this.setValue(chkCboStr.getStrData());  
										this.value=chkCboStr.getStrData();  
										//this.collapse();  
										this.fireEvent('select', this, record, index);  										

										/*
										record.set('check',!record.get('check'));  
										var str=[];//页面显示的值  
										var strvalue=[];//传入后台的值  
										this.store.each(function(rc){  
											if(rc.get('check')){  
												str.push(rc.get('value'));  
												strvalue.push(rc.get('name'));  
											}  
										});  
										this.setValue(str.join());  
										this.value=strvalue.join();  
										//this.collapse();  
										this.fireEvent('select', this, record, index);  
										*/
									}  
								},
								listeners :{
									'expand':function(combo) {
										var v=combo.getValue();
										chkCboStr.setStrData(v);
									}
								}
								
							})	;

	var columnModel = new Ext.grid.ColumnModel({
            defaults: {
                width: 100,
                sortable: false
            },
            columns: [
				{header:'编码',dataIndex:'code', width: 150},
				{header:'描述',dataIndex:'descript', width: 150},
				{header:'值',dataIndex:'value', width: 150,editor: valueCombo}
			]
	});

    var conditionGrid = new Ext.grid.EditorGridPanel({
		//border:false,	
		title:'查询条件',
        store: store,
        cm: columnModel,
        viewConfig: {
            forceFit:true,
			markDirty:false
        }
		
    });	

	conditionGrid.on('beforeedit',function(obj){
		delete valueCombo.lastQuery;
		if (obj.field=="value") {
			var rec=obj.record;
			var code=rec.get("code");
			valueCombo.getStore().setBaseParam("code",code);
		}		
		
	});
	
	
	function OnModify() {

		var filterCfgObj=new dhcwl.KDQ.CreateRptFilterCfg(outThis);
		var filterWin=filterCfgObj.getFilterWin();		
		
		var dimproCode="";
		var conStore=conditionGrid.getStore();
		for(var i=0;i<conStore.getCount();i++) {
			var rec=conStore.getAt(i);
			var code=rec.get("code");
			var aryCode=code.split("->");
			var pCode=aryCode[0]+"."+aryCode[1];
			if (dimproCode=="") dimproCode=pCode;
			else dimproCode=dimproCode+","+pCode;
		}
	
		var param=new Object();
		param.orderFrom="ConfigRpt";
		//modify by wz.2017-6-6-6
		//param.kpiCodes="K0695,K0696";
		param.kpiCodes=kpiCodes;
		param.searchItemdimProCode=dimproCode;
		filterCfgObj.updateCreateData(param);
		filterCfgObj.CallBack=refreshFilterText;
		filterWin.show();
			
	};

	

	
	
	function OnResetCond(){
		refreshFilterText("");
	};
	
	var filterPanel = new Ext.Panel({
		border:false,
		layout: {
			type:'hbox',
			//padding:'5px',
			align:'stretch'
		},
		items: [
		{
			border:false,	
			flex:1,
			layout:'fit',
			items:filterForm
		},{
			border:false,	
			flex:1,
			layout:'fit',
			items:conditionGrid			
		}]		
	});	

    this.getFilterPanel=function(){
    	return filterPanel;
    }    

	this.addFilterText=function(filterText) {
		var fText=filterForm.getForm().findField("filterField").getValue();
		if (fText!="") fText=fText+","+filterText;
		else fText=filterText;
		filterForm.getForm().findField("filterField").setValue(fText);
	}
	
	this.setFilterText=function(filterText) {
		filterForm.getForm().findField("filterField").setValue(filterText);
	}	
	
	this.addFilterKpiCodes=function(kpiC){
		if (kpiCodes=="") kpiCodes=kpiC;
		else kpiCodes=kpiCodes+","+kpiC;
	}
	
	this.setFilterKpiCodes=function(kpiC){
		kpiCodes=kpiC;
	}
	
	this.getFilterText=function() {
		return filterForm.getForm().findField("filterField").getValue();
	}
	
	function refreshFilterText(fText) {
		
		filterForm.getForm().findField("filterField").setValue(fText);
	}
	
	this.addSearchItem=function(rec) {
		
		var value="";
		if (!!rec.value) value=rec.value
	
		var aryDesc=rec.descript.split("-");
		var insData = {
			code: rec.code,
			descript: aryDesc[aryDesc.length-1],
			value:value
		};
		
		var conStore=conditionGrid.getStore();
		if(conStore.find("code",rec.code)==-1) {	//如果之前已经选择过维度或度量，就不继续添加
			var p = new conStore.recordType(insData); // create new record
			conStore.add(p);			
		};		
	}
	
	this.getSearchItem=function() {
		var arySearchItems=new Array();
		//报表统计项
		for(i=0;i<conditionGrid.getStore().getCount();i++) {
			var order=i+1;
			var item=new Array();
			var rec=conditionGrid.getStore().getAt(i);
			var express=rec.get("code").replace("->",".");
			item.push("Code"+String.fromCharCode(2)+rec.get("code"));
			item.push("Descript"+String.fromCharCode(2)+rec.get("descript"));
			item.push("Order"+String.fromCharCode(2)+order);
			item.push("Express"+String.fromCharCode(2)+express);
			item.push("Value"+String.fromCharCode(2)+rec.get("value"));
			item.push("Type"+String.fromCharCode(2)+"searchitem");
			var itemStr=item.join(String.fromCharCode(3));
			//arySearchItems.push(item);
			arySearchItems.push(itemStr);
		}	
		return arySearchItems;
		
		
	}
	
	this.getSearchItemArgs=function() {
		var args="";
		//报表统计项
		for(i=0;i<conditionGrid.getStore().getCount();i++) {
			var rec=conditionGrid.getStore().getAt(i);
			var express=rec.get("code").replace("->",".");
			var value=rec.get("value");
			if (value=="") continue;
			if (args=="") args=express+"equal"+value;
			else args=args+"separator"+express+"equal"+value;
		}	
		return args;
	}	
	
	this.removeSearchItem=function() {
		conditionGrid.getStore().removeAll();
	}	
	

}

