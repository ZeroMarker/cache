(function(){
	Ext.ns("dhcwl.mkpi.KpiRptCfg");
})();

dhcwl.mkpi.KpiRptCfg=function(){

     //Ext.QuickTips.init();
    var rptCfgRec = Ext.data.Record.create([{
        name: 'RptCfg_RowID',
        type: 'string'
    }, {
        name: 'RptCfg_Code',
        type: 'string'
    }, {
        name: 'RptCfg_Desc',
        type: 'string'
    },{
        name: 'RptCfg_URL',
        type: 'string'
    }]);

	var rptProxy=new Ext.data.HttpProxy({url:"dhcwl/kpi/kpirptcfgdata.csp?action=getNode"});
    var store = new Ext.data.GroupingStore({
        id:"rptCfgStore",
        reader: new Ext.data.JsonReader({
             	totalProperty: 'totalNum',
            	root: 'root',       	
        		fields: rptCfgRec}),
            	/*
            	fields:[
           		{name: 'RptCfg_RowID'},
            	{name: 'RptCfg_Code'},
            	{name: 'RptCfg_Desc'},
            	{name: 'RptCfg_URL'}      	
            	]}),
            	*/
        proxy: rptProxy      
     });

    var editor = new Ext.ux.grid.RowEditor({
        saveText: 'Update',
        clicksToEdit:2
    });

    var grid = new Ext.grid.GridPanel({
    	id:"rptCfgGridPanel",
        store: store,
        height: 275,
        autoExpandColumn: 'RptCfg_RowID',
        plugins: [editor],
        view: new Ext.grid.GroupingView({
            markDirty: false
        }),
        tbar: [{
            iconCls: 'icon-user-add',
            text: '新增报表',
            handler: function(){
                var e = new rptCfgRec({
                    RptCfg_RowID: '',
                    RptCfg_Code: '请更新此code',
                    RptCfg_Desc: 'desc',
                    RptCfg_URL: 'url'
                });
                editor.stopEditing();
                
                
                
      			var code="请更新此code";
      			var desc="desc";
       			var url="url"
				var tree=Ext.ComponentMgr.get('cfgTreePanel');
				var selNode = tree.getSelectionModel().getSelectedNode();
				var pcode=selNode.id;
				var url=encodeURI("dhcwl/kpi/kpirptcfgdata.csp?action=add"+"&code="+code+"&desc="+desc+"&url="+url+"&pcode="+pcode);
				dhcwl.mkpi.Util.ajaxExc(url,null,function(jsonData){
 						if(jsonData.success==true && jsonData.tip=="ok"){
 							var rowid=jsonData.ROWID;
 							if(rowid) {
 								e.set('RptCfg_RowID',rowid);
 								//e.RptCfg_RowID=rowid
 								store.insert(0, e);
				                grid.getView().refresh();
				                grid.getSelectionModel().selectRow(0);
				                editor.startEditing(0);
 							}
 						}
 						else {
 								Ext.Msg.show({
											title : '新增错误',
											msg : "SQLCODE:"+jsonData.SQLCODE,
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});							
 						}
 						
 					},this);	                
 
            }
        },'-',{
            ref: '../removeBtn',
            iconCls: 'icon-user-delete',
            text: '删除报表',
            disabled: true,
            handler: function(){
                editor.stopEditing();
                var s = grid.getSelectionModel().getSelections();
                for(var i = 0, r; r = s[i]; i++){
                    store.remove(r);
                }
            }
        }],

        bbar:new Ext.PagingToolbar({
            pageSize: 10,
            store: store,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录"
        }),        
        
        columns: [
        new Ext.grid.RowNumberer(),
        {
            id: 'RptCfg_RowID',
            header: 'RowID',
            dataIndex: 'RptCfg_RowID',
            width: 50,
            sortable: true,
            editor: {
                xtype: 'textfield',
                disabled: true,
                allowBlank: true
            }
        },{
            header: '编码',
            dataIndex: 'RptCfg_Code',
            width: 150,
            sortable: true,
            editor: {
                xtype: 'textfield',
                allowBlank: false
             }
        },{
            //xtype: 'datecolumn',
            header: '描述',
            dataIndex: 'RptCfg_Desc',
            width: 150,
            sortable: true,
            editor: {
                xtype: 'textfield',
                allowBlank: false
            }
        },{
            header: '报表文件',
            dataIndex: 'RptCfg_URL',
            width: 250,
            sortable: true,
            
            editor: {
                xtype: 'textfield',
                allowBlank: true
            }
            
            /*由于浏览器的原因，本地路径无法显示，只能显示文件名，所以此处暂时屏蔽
            editor: {
	            xtype: 'fileuploadfield',
	            id: 'form-file',
	            emptyText: 'Select an image',
	            fieldLabel: 'Photo',
	            name: 'photo-path',
	            buttonText: '',
	            buttonCfg: {
	                iconCls: 'upload-icon'
	            }
            }
            */
         }]
    });

    
    		//修改
      		store.on('update',function(record,operation){
      			//ar rowid=record.get("RptCfg_RowID");
      			var rowid=operation.data.RptCfg_RowID;
      			var code=operation.data.RptCfg_Code;
      			var desc=operation.data.RptCfg_Desc;
       			var url=operation.data.RptCfg_URL
				var editor2=editor;
 
				var url=encodeURI("dhcwl/kpi/kpirptcfgdata.csp?action=update&rowid="+rowid+"&code="+code+"&desc="+desc+"&url="+url);
				 dhcwl.mkpi.Util.ajaxExc(url,null,function(jsonData){
 						if(jsonData.success==true && jsonData.tip!="ok"){
 							refreshRptCfg();
 							Ext.Msg.show({
											title : '更新错误',
											msg : "SQLCODE:"+jsonData.SQLCODE,
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
 						}
  						
 					},this);					
				
				
				
      		})      
      		//新增
      		/*
     		store.on('add2',function(record,operation){
       			var code=operation[0].data.RptCfg_Code;
      			var desc=operation[0].data.RptCfg_Desc;
       			var url=operation[0].data.RptCfg_URL
				var tree=Ext.ComponentMgr.get('cfgTreePanel');
				var selNode = tree.getSelectionModel().getSelectedNode();
				var pcode=selNode.id;
				var url=encodeURI("dhcwl/kpi/kpirptcfgdata.csp?action=add"+"&code="+code+"&desc="+desc+"&url="+url+"&pcode="+pcode);
				dhcwl.mkpi.Util.ajaxExc(url);
				//store.reload();

				 dhcwl.mkpi.Util.ajaxExc(url,null,function(jsonData){
 						if(jsonData.success==true && jsonData.tip=="ok"){
 							var rowid=jsonData.ROWID;
 							if(rowid) {
 								var insRec=store.getAt(0);
 								insRec.set('RptCfg_RowID',rowid);			

 								//operation[0].data.RptCfg_RowID=rowid;
 							}
 						}
 						else {
 							
 						}
 						
 					},this);	

      		}) 
      		*/
      		//
     		store.on('remove',function(record,operation){
      			var rowid=operation.data.RptCfg_RowID;
      			var code=operation.data.RptCfg_Code;
      			var desc=operation.data.RptCfg_Desc;
       			var url=operation.data.RptCfg_URL

				var url=encodeURI("dhcwl/kpi/kpirptcfgdata.csp?action=del&rowid="+rowid+"&code="+code);
				//var url=escape("dhcwl/kpi/KpiRptCfgData.csp?action=update&rowid="+rowid+"&code="+code+"&desc="+desc+"&url="+url);
				dhcwl.mkpi.Util.ajaxExc(url);

      		})                           		
            
         store.load({params:{start:0,limit:10}});
        
        grid.getSelectionModel().on('selectionchange', function(sm){
        	grid.removeBtn.setDisabled(sm.getCount() < 1);
    	});
 
       grid.getSelectionModel().on('rowselect', function(sm,rowIndex,r){
       		grid.removeBtn.setDisabled(sm.getCount() < 1);
        	
        	var dimCfgPanel = Ext.getCmp('dimCfgPanel');
        	var url="dhcwl/kpi/kpidimcfgdata.csp?action=getNode&PCode='"+r.get("RptCfg_Code")+"'";   	
        	url=encodeURI(url);   	
        	dimCfgPanel.store.proxy=new Ext.data.HttpProxy({url:url}); 
    		dimCfgPanel.store.reload();
    	});
    
 	this.getRptCfgPanel=function(){
		return grid;
	}   

	refreshRptCfg=function(){
		var tree=Ext.ComponentMgr.get('cfgTreePanel');
		var selNode = tree.getSelectionModel().getSelectedNode();
		var pcode=selNode.id;
		
		store.proxy=new Ext.data.HttpProxy({url:"dhcwl/kpi/kpirptcfgdata.csp?action=getNode&PCode='"+pcode+"'"}); 
		store.reload();		

	}
}