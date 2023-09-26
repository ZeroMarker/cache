(function(){
	Ext.ns("dhcwl.codecfg.SecProManage");
})();
/*--该js用于数据源维护--*/
Ext.onReady(function(){
});
dhcwl.codecfg.SecProManage=function(){
	//var dsModifyWin="";
	var outThis=this;
	var serviceUrl="dhcwl/measuredimrole/datasource.csp";
	
	var mstore=new Ext.data.Store({
	    proxy:new Ext.data.HttpProxy({url:'dhcwl/measuredimrole/datasource.csp?action=getDataSource'}),
		//reader:new Ext.data.ArrayReader({},[{name:'value'},{name:'name'}])
		reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields : ['cfgtableCode', 'cfgtableName']
    	})
   });
	
	var seccodecfgdimCombo={
		id : 'tableCombo',
		disabled : false,
		xtype : 'bdpcombo',
		width:150,
		fieldLabel : '表名',
		queryParam : "tableName",
		forceSelection : true,
		selectOnFocus : false,
		mode : 'local',
		pageSize : 10,
		listWidth : 250,
		valueField : 'cfgtableCode',
		displayField : 'cfgtableName',
		store:mstore,
		listeners:{
		   'beforequery':function(e){
			   packName=Ext.getCmp('package').getValue(); 
			   tableName=Ext.getCmp('tableCombo').getRawValue(); 
			   //alert(ID+" "+ID1);
			   //return;
			   selectSecGrpID="test"; 
			   mstore.proxy.setUrl(encodeURI('dhcwl/measuredimrole/datasource.csp?action=getDataSource&start=0&limit=10&onePage=1&packName='+packName+"&tableName="+tableName));
			   mstore.load();
			   return false;
		   },'select':function(e){
			   //alert("test");
			   dsForm.getForm().findField("package").disable();
			   
		   }
	   }
	};
    
    var dsForm=new Ext.form.FormPanel({
		frame : true,
		height : 100,
		labelAlign : 'right',
		bodyStyle:'padding:5px',
		labelWidth : 70,
		style : {
			"margin-right" : Ext.isIE6? (Ext.isStrict ? "-10px" : "-13px"): "0"
		},items : [{
			layout : 'column',
			items : [{ 
				columnWidth : .3,
				layout : 'form',
				defaultType : 'textfield',
				defaults : {
					width : 150
				},
				items : [{
					xtype     :'textfield',
					fieldLabel:'包名',
					name      :'package',
					id        :'package',
					value     :'User'
				}]
			},{ 
				columnWidth : .3,
				layout : 'form',
				defaultType : 'textfield',
				defaults : {
					width : 150
				},
				items : [seccodecfgdimCombo]
			},{ 
				columnWidth : .3,
				layout : 'form',
				defaultType : 'textfield',
				defaults : {
					width : 150
				},
				items : [{
					xtype     :'textfield',
					fieldLabel:'描述',
					name      :'dataSourceDesc',
					id        :'dataSourceDesc'
				}]
			}]
		}],
         tbar:new Ext.Toolbar([
         {
        	 //text:'增加',
			 text: '<span style="line-Height:1">增加</span>',
			 icon   : '../images/uiimages/edit_add.png',
        	 handler:function(){ 
                  var form=dsForm.getForm();
                  var values=form.getValues(false);
                  var dsDesc=Ext.get('dataSourceDesc').getValue();
                  var packageName=Ext.getCmp('package').getValue();     //codecfgdimCombo.getValue();
				  var tableName=Ext.getCmp('tableCombo').getRawValue();
                  //alert(dsCode+'@'+dataSourceCode+'@'+packageName+'@'+tableName);
                  //return;
                  if(!dsDesc||!packageName||!tableName){
                       	Ext.Msg.alert("提示","请将信息填写完整后再进行增加操作！");
                       	return;
                       }         
                  paraValues='dsDesc='+dsDesc+'&packageName='+packageName+'&tableName='+tableName;
                  clearForm();
                  dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=addDataSource&'+paraValues);
                  store.load();
                  kpiDataGrid1.show(); 
        	 }
         },'-',{
			 text: '<span style="line-Height:1">作废</span>',
			 icon   : '../images/uiimages/edit_remove.png',
        	 handler:function(){
             	var sm = kpiDataGrid1.getSelectionModel();
                var record = sm.getSelected();
                if(!sm||!record){
                		alert("请选择要作废的行！");
                		return;
				}
                Ext.Msg.confirm('信息', '确定要作废？', function(btn){
                    if (btn == 'yes') {
                        var ID=record.get("ID");
                 		//dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=delDataSource&ID='+ID);
						dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=delDataSource&ID='+ID,null,
						function(jsonData){
						if(jsonData.success==true && jsonData.tip=="ok"){
							store.remove(record);
							clearForm();
                			Ext.Msg.alert("提示","作废成功");
						}
						if(jsonData.success==true && jsonData.tip!="ok"){
							Ext.Msg.alert("提示",jsonData.tip);
						}
						},this);
                 		}
                 	});
        	 }
         },'-',{
			 text: '<span style="line-Height:1">修改</span>',
			 icon   : '../images/uiimages/update.png',
        	 handler:function(){
				var sm = kpiDataGrid1.getSelectionModel();
                var record = sm.getSelected();
                if(!sm||!record){
                	alert("请选择要更新的行！");
                	return;
				}
				var dsmodifyForm=new Ext.FormPanel({
					//title:"修改度量信息",
					border:false,
					bodyStyle:'padding:5px',
					style: {
						"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
					},
					labelAlign: 'right',
					buttonAlign: 'center',
					frame : true,
					bodyStyle:'padding:5px',
					labelWidth : 60,
					items:[{
						layout:'column',
						items:[{
							columnWidth:.84,
							layout:'form',
							defaultType:'textfield',
							defaults:{
								width:120
							},
							items:[{
								fieldLabel :'描述',
								name	  :'infor',
								id	  :'infor'
							}]
						}]
					}],
					buttons:new Ext.Toolbar([
					{
						text: '<span style="line-Height:1">确定</span>',
						icon: '../images/uiimages/filesave.png',
						handler:function(){
							var desc=Ext.get('infor').getValue();
							var sm = kpiDataGrid1.getSelectionModel();
							var record = sm.getSelected();
							if(!sm||!record){
								alert("请选择要更新的行！");
								return;
							}
							Ext.Msg.confirm('信息', '确定要更新？', function(btn){
								if (btn == 'yes') {
									var ID=record.get("ID");
									//var desc=record.get("dsDesc");
									if(!desc){
										alert("描述不能为空！");
										return;
									}
									paraValues='ID='+ID+'&desc='+desc;
									dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=modifyDS&'+paraValues);
									store.load();
									Ext.getCmp('infor').setValue("");
									dsModifyWin.close();
									}
								});
								
						}
					},'-',{
						text: '<span style="line-Height:1">取消</span>',
						icon: '../images/uiimages/undo.png',
						handler:function(){
							Ext.getCmp('infor').setValue("");
							dsModifyWin.close();
						}
					}])
				});
				var dsModifyWin=new Ext.Window({
					title:'描述修改',
					//id   :'dsModifyWin',
					layout :'fit',
					width  :300,
					height :200,
					items  :[dsmodifyForm]
				});
				dsModifyWin.show();
				//dsModifyWin.show();
				//return;
        	 }
         },'-',{
			 text: '<span style="line-Height:1">清空</span>',					
			 icon   : '../images/uiimages/clearscreen.png',
        	 handler:function(){
        		 clearForm();
        	 }
         }
      ])
    });
    
    var columnModel = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
        {header:'ID',dataIndex:'ID',sortable:false, width: 60, sortable: true,menuDisabled : true,hidden:true},
		{header:'包名',dataIndex:'dsPackage', width: 150, sortable: false,menuDisabled : true},
		{header:'类名',dataIndex:'dsTable', width: 249, sortable: false,menuDisabled : true},
        {header:'数据源描述',dataIndex:'dsDesc', width: 249, sortable: false,menuDisabled : true,editor:new Ext.grid.GridEditor(new Ext.form.TextField({}))}
    ]);
    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=getDSInfor'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'ID'},
				{name: 'dsPackage'},
				{name: 'dsTable'},
            	{name: 'dsDesc'}
       		]
    	})
    });
    store.load()
    
    var kpiDataGrid1 = new Ext.grid.EditorGridPanel({
	  	height:352,
        store: store,
        cm: columnModel,
        sm: new Ext.grid.RowSelectionModel({
        	singleSelect: true
        }),
        bbar:new Ext.PagingToolbar({
            pageSize: 21,
            store: store,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录"
        })
    });
	
	/*var dsModifyWin=new Ext.Window({
		title:'描述修改',
		id   :'dsModifyWin',
    	layout :'fit',
    	width  :300,
    	height :200,
    	items  :[dsmodifyForm]
    });*/
	
	//清空form内信息
    function clearForm(){
    	 var form=dsForm.getForm();
		 form.findField("package").enable();
         form.setValues({dataSourceDesc:'',tableCombo:''});
    }
    
    var mainWin=new Ext.Window({
		id:'dhcwl.mkpi.ViewDataSource',
		width : 800,
		height : 550,
		autoScroll:true,
		plain : true,
		title : '数据源维护',
		
		layout: {
			type: 'vbox',
			pack: 'start',
			align: 'stretch'
		},
        items: [{ 
			border :false,
			flex:1,
			layout:"fit",
            items:[
			{
				layout: {
					type: 'hbox',
					pack: 'start',
					align: 'stretch'
				},				
				items:[{
					flex:1,
					layout:"fit",
					items:dsForm
				}]
			}]
    	},{
			border :false,
			flex:4,
			layout:"fit",
            items:[{
				border :false,
				layout: {

					type: 'hbox',
					pack: 'start',
					align: 'stretch'
				},				
				items:[{
					flex:1,
					layout:"fit",
					items:kpiDataGrid1
				}]
			}]
        }],
    	listeners:{
    	}
	});
	this.showWin=function(){
		
		mainWin.show();
	}
}