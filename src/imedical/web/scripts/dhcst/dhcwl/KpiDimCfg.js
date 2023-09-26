(function(){
	Ext.ns("dhcwl.mkpi.KpiDimCfg");
})();

dhcwl.mkpi.KpiDimCfg=function(){
	     //Ext.QuickTips.init();
var outThis=this;
var serviceUrl='dhcwl/kpi/kpidimcfgdata.csp';

var proxy = new Ext.data.HttpProxy({
    url: 'dhcwl/kpi/KpiDimCfgData.csp?action=getNode'
});

var reader = new Ext.data.JsonReader({
    totalProperty: 'totalNum',
    root: 'root'      	
}, [
    {name: 'KpiCfg_RowID',type: 'string'},
    {name: 'KpiCfg_Code',type: 'string', allowBlank: false},
    {name: 'KpiCfg_DimCfgRule',type: 'string', allowBlank: true},
    {name: 'KpiCfg_KpiFilterRule',type: 'string', allowBlank: true},
    //{name: 'KpiCfg_PCode', allowBlank: false},    
    {name: 'KpiCfg_OrderNum',type: 'string', allowBlank: true}
]);

var editor = new Ext.ux.grid.RowEditor({
    saveText: 'Update',
    clicksToEdit:2
});
    
var store = new Ext.data.Store({
    id: 'storeDimCfg',
    //restful: true,     
    proxy: proxy,
    reader: reader
    //writer: writer,    
    //autoSave:true
    
});

var dimColumns =  [
    {header: "RowID", width: 40, sortable: true, dataIndex: 'KpiCfg_RowID'},
    {header: "编码", width: 100, sortable: true, dataIndex: 'KpiCfg_Code'},
    {header: "指标参数", width: 150, sortable: true, dataIndex: 'KpiCfg_DimCfgRule'},
    {header: "过滤参数", width: 150, sortable: true, dataIndex: 'KpiCfg_KpiFilterRule'},
    {header: "指标序号", width: 50, sortable: true, dataIndex: 'KpiCfg_OrderNum', editor: {
                xtype: 'textfield',
                allowBlank: true
             }}

];

     var dimGrid = new Ext.grid.GridPanel({
         id:'dimCfgPanel',
         iconCls: 'icon-grid',
         height: 275,
        store: store,
        plugins: [editor],
        columns : dimColumns,
        
       bbar:new Ext.PagingToolbar({
            pageSize: 10,
            store: store,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录"
        }),                
        tbar: [{
            text: '配置',
            iconCls: 'silk-add',
            handler: onAdd
        }, '-', {
            text: '删除',
            iconCls: 'silk-delete',
            handler: onDelete
        }],
        viewConfig: {
        	markDirty: false,
            forceFit: true
        }
    });

    /**
     * onAdd
     */
    function onAdd(btn, ev) {

    		var selectedKpis=[];
			var setRuleWin=new dhcwl.mkpi.showkpidata.SetKpiRule();
			setRuleWin.setSelectedKpiArr(selectedKpis);
			setRuleWin.setParentWin(outThis);  
			setRuleWin.show();

    }
    /**
     * onDelete
     */
    function onDelete() {
        var rec = dimGrid.getSelectionModel().getSelected();
        if (!rec) {
            return false;
        }
		kpiCfgRowID=rec.get("KpiCfg_RowID");
		dhcwl.mkpi.Util.ajaxExc(serviceUrl, {
				'action' : 'del',					
	            'KpiCfg_RowID': kpiCfgRowID
				}, function(jsonData) {
				jsonData = Ext.util.JSON.decode(jsonData);
				if(jsonData.success==true && jsonData.tip=="ok"){
					dimGrid.store.remove(rec);
				}else{ 
						Ext.Msg.show({
									title : '新增错误',
									msg : "SQLCODE:"+jsonData.SQLCODE,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
				}
	
				}, outThis, true);		        
        

    }
	
	
	store.load({params:{start:0,limit:10}});

	this.getDimCfgPanel=function(){
		return dimGrid;
	}
	
	
	this.setKpiRule=function(name,rule){
		if(name=="") name=rule;
		if(rule=="") return;

		var kpis=rule.split(",");
		var i=0;
		
		var rptCfgPanel=Ext.getCmp('rptCfgGridPanel');
		var selRow=rptCfgPanel.getSelectionModel().getSelected();
		if (!selRow) return;
		var PCode=selRow.get("RptCfg_Code");
				
		var kpisLen=kpis.length;
		serviceUrl=encodeURI(serviceUrl);
		for (i=0;i<=kpisLen-1;i++) {
			var kpiStr=kpis[i].split(":");
			var dimStr="";
			if(kpiStr[1]){
				dimStr=kpiStr[1];
			}else{
				dimStr="";
			}

			var stIdx=store.find('KpiCfg_Code',kpiStr[0]);
			if (stIdx<0) {

				dhcwl.mkpi.Util.ajaxExc(serviceUrl, {
						'action' : 'add',					
			            'KpiCfg_Code': kpiStr[0],
			            'KpiCfg_DimCfgRule' : dimStr,
			            'KpiCfg_KpiFilterRule':'',
			            'KpiCfg_PCode':PCode,
			            'KpiCfg_OrderNum':'',
			            'kpiInx':i
						}, function(jsonData) {
						jsonData = Ext.util.JSON.decode(jsonData);
						if(jsonData.success==true && jsonData.tip=="ok"){
 							var rowid=jsonData.ROWID;
 							if(rowid) {

 								var kpiInx=jsonData.kpiInx;
								var kpiStr=kpis[kpiInx].split(":");
								var stIdx=store.find('KpiCfg_Code',kpiStr[0]);
								var dimStr="";
								if(kpiStr[1]){
									dimStr=kpiStr[1];
								}else{
									dimStr="";
								} 								

								var u = new dimGrid.store.recordType({
								KpiCfg_RowID : rowid,
								KpiCfg_Code: kpiStr[0],
								KpiCfg_DimCfgRule : dimStr,
								KpiCfg_KpiFilterRule:'',
								//KpiCfg_PCode:PCode,
								KpiCfg_OrderNum:''
								});

		        				dimGrid.store.insert(0, u);      
 							}
 						}else{ 
	 							Ext.Msg.show({
											title : '新增错误',
											msg : "SQLCODE:"+jsonData.SQLCODE,
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
						}
			
						}, outThis, true);		        
		        }else{
					dhcwl.mkpi.Util.ajaxExc(serviceUrl, {
						'action' : 'update',					
			            'KpiCfg_Code': kpiStr[0],
			            'KpiCfg_DimCfgRule' : dimStr,
			            'kpiInx':i
						}, function(jsonData) {
						jsonData = Ext.util.JSON.decode(jsonData);
						if(jsonData.success==true && jsonData.tip=="ok"){

							var kpiInx=jsonData.kpiInx;
							var kpiStr=kpis[kpiInx].split(":");
							var stIdx=store.find('KpiCfg_Code',kpiStr[0]);
							var dimStr="";
							if(kpiStr[1]){
								dimStr=kpiStr[1];
							}else{
								dimStr="";
							} 			
							var updateRec=store.getAt(stIdx);
  							updateRec.set('KpiCfg_DimCfgRule',dimStr)
 							
 						}else{ 
	 							Ext.Msg.show({
											title : '新增错误',
											msg : "SQLCODE:"+jsonData.SQLCODE,
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
						}
			

						}, outThis, true);					
			}

		}

	}
	
	
    		//修改
	
		store.on('update',function(record,operation){
			//return;
      			var rowid=operation.data.KpiCfg_RowID;
      			if(typeof(operation.modified.KpiCfg_OrderNum)=='undefined') return
      			else{
      			
				var orderNum=operation.data.KpiCfg_OrderNum;
				dhcwl.mkpi.Util.ajaxExc(serviceUrl, {
					'action' : 'updateOrderNum',					
		            'KpiCfg_RowID': rowid,
		            'KpiCfg_OrderNum':orderNum
					}, function(jsonData) {
					//if(jsonData.success==true && jsonData.tip=="ok"){
					jsonData = Ext.util.JSON.decode(jsonData);
					if(jsonData.success!=true || jsonData.tip!="ok"){
							Ext.Msg.show({
								title : '修改错误',
								msg : "SQLCODE:"+jsonData.SQLCODE,
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					}	
						//outThis.refresh();
					}, outThis, true);		        
      			}
      		})      
	
	
}