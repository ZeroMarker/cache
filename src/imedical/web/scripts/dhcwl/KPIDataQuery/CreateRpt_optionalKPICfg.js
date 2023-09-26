(function(){
	Ext.ns("dhcwl.KDQ.CreateRptOptinalKpiCfg");
})();
///描述: 		查询对象
///编写者：		WZ
///编写日期: 		2016-11
dhcwl.KDQ.CreateRptOptinalKpiCfg=function(createR){
	var createRpt=createR;
	var serviceUrl="dhcwl/kpidataquery/createrptoptinalkpicfg.csp";
	var outThis=this;
	var inParam;
	var filterStr="";

	
	///////////////////////////////////////////////////////////////////////////////////////
	/////可选指标
	var optionalKPIStore = new Ext.data.Store({
 		proxy: new Ext.data.HttpProxy({url:'dhcwl/kpidataquery/createrpt.csp?action=getOptionalKPI'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
				{name:'code'},
				{name:'descript'},
				{name:'roles'}
			]
    	})
    });
	
	var sm = new Ext.grid.CheckboxSelectionModel();	
	var optionalKPICml = new Ext.grid.ColumnModel({
		default:{
			sortable: true,
			menuDisabled : true
		},
		columns:[
			sm,
			{header:'编码',dataIndex:'code',width: 150},
			{header:'描述',id:'descript',dataIndex:'descript',width: 100},
			{header:'角色',dataIndex:'roles',width: 80}
		]
	});


	
   var optionalKPIGrid = new Ext.grid.GridPanel({
        //height:480,
		title:'可选度量统计项',
		sm: sm,
		//layout:'fit',
        store: optionalKPIStore,
        cm: optionalKPICml,
		autoExpandColumn: 'descript',
		stripeRows: true,
		view:new Ext.grid.GridView({markDirty:false})
	});	

	optionalKPIStore.on('load',function(thisStore, records, options){
		var selInx=-1;
		var roleCnt=100;
		for(var i=0;i<records.length;i++){
			if(records[i].get("roles").split(",").length<roleCnt) {
				roleCnt=records[i].get("roles").split(",").length;
				selInx=i;
			}
		}
		if (selInx!=-1) {
			optionalKPIGrid.getSelectionModel().selectRow(selInx);
		}
	})
	
    this.getOptionalKPIPanel=function(){
    	return optionalKPIGrid;
    }    

	this.updateCreateData=function(inP) {
		inParam=inP;	

		var searchItemRoles=inParam.searchItemRoles;
		optionalKPIStore.setBaseParam("dimCodes",inParam.roles+","+searchItemRoles);
		optionalKPIStore.setBaseParam("businessType",inParam.businessType);
		optionalKPIStore.setBaseParam("selectedKpis",inParam.selectedKpis);
		optionalKPIStore.reload();
		
	}	

	
	this.show=function(){
    	optionalKPIGrid.show();
    } 
	
	this.getOptionalKPI=function() {
		var ret="";
		var arySelRecs=optionalKPIGrid.getSelectionModel().getSelections();
		for(var i=0;i<arySelRecs.length;i++){
			if (ret=="") ret=arySelRecs[i].get("code")+String.fromCharCode(2)+arySelRecs[i].get("descript");
			else ret=ret+","+arySelRecs[i].get("code")+String.fromCharCode(2)+arySelRecs[i].get("descript");
		}
		return ret;
	}
	
	this.getOptionalKPIDesc=function() {
		var ret="";
		var arySelRecs=optionalKPIGrid.getSelectionModel().getSelections();
		for(var i=0;i<arySelRecs.length;i++){
			if (ret=="") ret=arySelRecs[i].get("descript");
			else ret=ret+","+arySelRecs[i].get("descript");
		}
		return ret;
	}	
	
	this.getOptionalKPICode=function() {
		var ret="";
		var arySelRecs=optionalKPIGrid.getSelectionModel.getSelections();
		for(var i=0;i<arySelRecs.length;i++){
			if (ret=="") ret=arySelRecs[i].get("code");
			else ret=ret+","+arySelRecs[i].get("code");
		}
		return ret;
	}	
}

