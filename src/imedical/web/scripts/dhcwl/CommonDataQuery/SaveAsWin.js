(function(){
	Ext.ns("dhcwl.CDQ.SaveAs");
})();
///描述: 		查询对象
///编写者：		WZ
///编写日期: 		2016-11
dhcwl.CDQ.SaveAsWin=function(pObj){
	var serviceUrl="dhcwl/commondataquery/saverptcfg.csp";
	var outThis=this;
	var parentObj=pObj;
	var rptName="";
	var initAttrib;
	
	
	var columnModel = new Ext.grid.ColumnModel({
            defaults: {
                width: 100,
                sortable: false
            },
			columns: [
				{header:'查询名称',dataIndex:'QryName', width: 100},
				{header:'nameSpace',dataIndex:'NameSpace', width: 100},
				{header:'routine',dataIndex:'Routine', width: 100},
				{header:'function',dataIndex:'Fun', width: 100},
				{header:'其他参数',dataIndex:'OtherParam', width: 100},
				{header:'报表标题',dataIndex:'RptTitle', width: 70}
			]
    });
    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=getRtpCfg'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
				{name: 'RptID'},
            	{name: 'QryName'},
				{name: 'NameSpace'},
				{name: 'Routine'},
				{name: 'Fun'},
            	{name: 'OtherParam'},
				{name: 'RptTitle'}
			]
    	})
    });

    var rptGrid = new Ext.grid.GridPanel({
        height:480,
		title:'已保存报表',
		//layout:'fit',
        store: store,
        cm: columnModel,
		viewConfig: {
			forceFit: true
		}
    });
	
	var saveAsWin = new Ext.Window({
        width:700,
		height:500,
		resizable:false,
		closable : false,
		title:'加载',
		modal:true,
		layout: 'fit',
		items: rptGrid,		

		buttons: [
		{
			text:"加载",	
			id:'btnLoad',
			handler:OnLoad			
		},{
			text: '关闭',
			handler: CloseWins
		}]
	});	
	

	
	function OnLoad() {
		if(outThis.onLoadCallback)
		{
			var selRec=rptGrid.getSelectionModel().getSelected();
			if (!selRec) {
				Ext.Msg.alert("提示","请选择配置！");
				return;
			}
			var param=new Object();
			param.rptID=selRec.get('RptID');
			param.qryName=selRec.get('QryName');
			param.nameSpace=selRec.get('NameSpace');
			param.routine=selRec.get('Routine');
			param.fun=selRec.get('Fun');
			param.otherParam=selRec.get('OtherParam');
			param.rptTitle=selRec.get('RptTitle');

			outThis.onLoadCallback(param);
			saveAsWin.close();
			return;
		}
				
	}
	function CloseWins() {
			saveAsWin.close();
	}
 

	this.getSaveAsWin=function() {
		return saveAsWin;
	}
	
	this.show=function() {
		saveAsWin.show();
		//store.load(({params:{start:0,limit:50}});
		store.load();
	}

	//保存数据时调用
	this.initForSave=function() {
	}
	

}

