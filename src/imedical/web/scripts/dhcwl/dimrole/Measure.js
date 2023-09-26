(function(){
	Ext.ns("dhcwl.dimrole.Measure");
})();
//-------------------------------------------------------------度量维护维护界面----------------------------------------------------------
//-------------------------------------------------------------以下是度量grid----------------------------------------------------------
//Ext.onReady(function() {
dhcwl.dimrole.Measure=function(){
	var serviceUrl="dhcwl/measuredimrole/measure.csp";
	var outThis=this;
	var columnModel = new Ext.grid.ColumnModel([
        {header:'ID',dataIndex:'meaID',sortable:true, width: 70, sortable: true,menuDisabled : true},
        {header:'编码',dataIndex:'meaCode', width: 100, sortable: true,menuDisabled : false},
        {header:'描述',dataIndex:'meaDesc', width: 150, sortable: true,menuDisabled : false},
        {header:'数据源',dataIndex:'meaDSource', width: 200, sortable: true,menuDisabled : false},
        {header:'计算数据项',dataIndex:'meaCalItem',sortable:true, width: 200, sortable: false,menuDisabled : true},
        {header:'统计口径',dataIndex:'meastaCal',sortable:true, width: 200, sortable: false,menuDisabled : true},
        {header:'创建人',dataIndex:'meaCreator',sortable:true, width: 100, sortable: false,menuDisabled : true},
        {header:'维护时间',dataIndex:'meaDate',sortable:true, width: 100, sortable: false,menuDisabled : true}
    ]);
	
	var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=getMeasureInfor'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'meaID'},
            	{name: 'meaCode'},
            	{name: 'meaDesc'},
            	{name: 'meaDSource'},
            	{name: 'meaCalItem'},
            	{name: 'meastaCal'},
            	{name: 'meaCreator'},
            	{name: 'meaDate'}
       		]
    	})
    });
    store.proxy.setUrl(encodeURI("dhcwl/measuredimrole/measure.csp?action=getMeasureInfor&onePage=1&start=0&limit=16"));
	store.load();
	
	var pageTool=new Ext.PagingToolbar({
        pageSize: 16,
        store: store,
        displayInfo: true,
        displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
        emptyMsg: "没有记录"
    });
	
	//度量grid
    var meaGrid = new Ext.grid.GridPanel({
        stripeRows:true,
        loadMask:true,
        height:450,        
        store: store,
        resizeAble:true,
        enableColumnResize :true,
        cm: columnModel,
		bbar:pageTool,
        sm: new Ext.grid.RowSelectionModel({
        	singleSelect: true,
            listeners: {
            }
        }),
		 tbar: new Ext.Toolbar([
			{
				xtype:'label',
				text:'查找: '
			},{
				//fieldLabel:'查找',
				xtype   :'textfield',
				name     :'addMeasureSearch',
				id     :'addMeasureSearch',
				enableKeyEvents: true,
				listeners :{
					'keypress':function(ele,event){
						if ((event.getKey() == event.ENTER)){
							localRefresh();
						}
					}
				}
			},"-",{
        	//text:'新增',
			text: '<span style="line-Height:1">新增</span>',
        	icon: '../images/uiimages/edit_add.png',
            handler:function(){
            	addMeasureObj=new dhcwl.dimrole.AddMeasure(store);
				addMeasureObj.setParentWin(outThis);
            	addMeasureObj.showWin();
            }
			},"-",{
				//text:'修改',
				text: '<span style="line-Height:1">修改</span>',
				icon: '../images/uiimages/pencil.png',
				handler: function() {
					var rowObj=meaGrid.getSelectionModel().getSelections();
					var len = rowObj.length;
					if(len < 1){
						Ext.Msg.show({title:'注意',msg:'请选择需要维护的维度！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}else{
						modifyMeasureWin.show();
					}
				}
			},"-",{
				//text:'作废',
				text: '<span style="line-Height:1">作废</span>',
				icon: '../images/uiimages/edit_remove.png',
				handler: function() {
					var rowObj=meaGrid.getSelectionModel().getSelections();
					var len = rowObj.length;
					if(len < 1){
						Ext.Msg.show({title:'注意',msg:'请选择需要维护的维度！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}else{
						var ID=rowObj[0].get("meaID");
					}
					Ext.MessageBox.confirm('提示!!','关联此度量的指标度量将会删除并且作废后不能恢复,您确认作废么？',function(btn){
						if(btn=='yes'){
							dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=deleteMeasure&ID='+ID,null,function(jsonData){
								if(!jsonData){
									Ext.Msg.show({title:'错误',msg:"作废失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									return;
								}
								if(jsonData.success){
									if (jsonData.tip=="ok") {
										Ext.Msg.show({title:'提示',msg:"作废成功！",buttons: Ext.Msg.OK});
										localRefresh();
										modifyMeasureWin.hide();
									}else{
										Ext.Msg.alert("提示","作废操作失败了！");
									}
								}else{
									Ext.Msg.show({title:'错误',msg:"处理响应数据失败！\n"+jsonData.tip,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									return;
								}},outThis);
						}
						});
				}
			} 
		 ])

    });
    //-------------------------------------------------------以下是度量form---------------------------------------
    var dataSourceCombo=new Ext.form.ComboBox({
		width : 130,
		editable:false,
		xtype : 'combo',
		mode : 'remote',
		triggerAction : 'all',
		//emptyText:'请选择数据源',
		fieldLabel : '数据源',
		name : 'addataSource',
		id : 'addataSource',
		displayField : 'code',
		valueField : 'ID',
		store : new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({url:serviceUrl+'?action=getDataSource'}),
			reader:new Ext.data.ArrayReader({},[{name:'ID'},{name:'code'}])
		}),
		tpl:'<tpl for=".">' +   
			'<div class="x-combo-list-item" style="height:18px;">' +   
			'{code}' +   
			'</div>'+   
			'</tpl>',	
		listeners :{
			'select':function(combox){
				dataSourceCombo.setValue(combox.getRawValue());
				calItemCombo.setValue("");
				meastaCalCombo.setValue("");
			}
		}
	});
    
    var mstore=new Ext.data.Store({
  	   proxy:new Ext.data.HttpProxy({url:serviceUrl+'?action=getCalItem'}),
  		   reader:new Ext.data.ArrayReader({},[{name:'value'},{name:'name'}])
     });
    var calItemCombo=new Ext.form.ComboBox({
		width : 130,
		editable:false,
		xtype : 'combo',
		mode : 'remote',
		triggerAction : 'all',
		//emptyText:'请选择计算项',
		fieldLabel : '计算项',
		name : 'addcalMeasure',
		id : 'addcalMeasure',
		displayField : 'name',
		valueField : 'value',
		tpl:'<tpl for=".">' +   
			'<div class="x-combo-list-item" style="height:18px;">' +   
			'{name}' +   
			'</div>'+   
			'</tpl>',
		store : mstore,
		listeners :{
			'beforequery':function(e){
				ID=Ext.getCmp('addataSource').getValue();
				if (ID==""){
					return
				}
	     		mstore.proxy.setUrl(encodeURI(serviceUrl+'?action=getCalItem&ID='+ID));
	     		mstore.load();
	     		return false;
	     	},
			'select':function(combox){
				calItemCombo.setValue(combox.getRawValue());
			}
		}
	});
    
    var meastastore=new Ext.data.Store({
   	   proxy:new Ext.data.HttpProxy({url:serviceUrl+'?action=getMeastaCal'}),
   		   reader:new Ext.data.ArrayReader({},[{name:'value'},{name:'name'}])
      });
    var meastaCalCombo=new Ext.form.ComboBox({
		width : 130,
		editable:false,
		xtype : 'combo',
		mode : 'remote',
		triggerAction : 'all',
		//emptyText:'请选择统计口径',
		fieldLabel : '统计口径',
		name : 'addMeasureCal',
		id   : 'addMeasureCal',
		displayField : 'name',
		valueField : 'value',
		tpl:'<tpl for=".">' +   
			'<div class="x-combo-list-item" style="height:18px;">' +   
			'{name}' +   
			'</div>'+   
			'</tpl>',
		store : meastastore,
		listeners :{
			'beforequery':function(e){
				ID=Ext.getCmp('addataSource').getValue();
				if (ID==""){
					return
				}
				meastastore.proxy.setUrl(encodeURI(serviceUrl+'?action=getMeastaCal&ID='+ID));
				meastastore.load();
	     		return false;
	     	},
			'select':function(combox){
				meastaCalCombo.setValue(combox.getRawValue());
			}
		}
	});
    
	//度量Form
	/*var meaForm = new Ext.FormPanel({
		bodyStyle:'padding:5px',
        style: {
            "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },
        labelAlign: 'right',
		frame : true,
		bodyStyle:'padding:5px',
		labelWidth : 60,
		items:[{
			layout:'column',
			items:[{
				columnWidth:.30,
				layout:'form',
				defaultType:'textfield',
				defaults:{
					width:170
				},
				items:[dataSourceCombo,{
					fieldLabel:'编码',
					name     :'measureCode',
					id     :'measureCode',
					enableKeyEvents: true,
					listeners :{
						'keypress':function(ele,event){
							if ((event.getKey() == event.ENTER)){
								refresh();
							}
						}
					}
				}]
			},{
				columnWidth:.25,
				layout:'form',
				defaultType:'textfield',
				defaults:{
					width:140
				},
				items:[calItemCombo,{
					fieldLabel :'描述',
					name	   :'measureDesc',
					id	       :'measureDesc',
					enableKeyEvents: true,
					listeners :{
						'keypress':function(ele,event){
							if ((event.getKey() == event.ENTER)){
								refresh();
							}
						}
					}
				}]
			},{
				columnWidth:.25,
				layout:'form',
				defaultType:'textfield',
				defaults:{
					width:140
				},
				items:[meastaCalCombo,{
					fieldLabel :'创建人',
					name	   :'measureCreator',
					id	       :'measureCreator',
					enableKeyEvents: true,
					listeners :{
						'keypress':function(ele,event){
							if ((event.getKey() == event.ENTER)){
								refresh();
							}
						}
					}
				}]
			},{
				columnWidth:.20,
				layout:'form',
				defaultType:'textfield',
				defaults:{
					width:120
				},
				items:[{
					fieldLabel :'创建时间',
					xtype	   :'datefield',
					name	   :'measureDate',
					id	       :'measureDate',
					disabled   :true
				}]
			}]
		}],
        tbar:new Ext.Toolbar([
        {
        	text:'新增',
            handler:function(){
            	addMeasureObj=new dhcwl.dimrole.AddMeasure(store);
				addMeasureObj.setParentWin(outThis);
            	addMeasureObj.showWin();
            }
        },"-",{
        	text:'修改',
        	handler: function() {
        	}
        },"-",{
        	text:'作废',
        	handler: function() {
        	}
        },"-",{
        	text:'查询',
        	handler: function() {
        		var dataSource=Ext.get('addataSource').getValue();
				var calMeasure=Ext.get('addcalMeasure').getValue();
				var measureCal=Ext.get('addMeasureCal').getValue();
				var code=Ext.get('measureCode').getValue();
				var desc=Ext.get('measureDesc').getValue();
				var creator=Ext.get('measureCreator').getValue();
				Ext.Msg.alert("title",dataSource+" "+calMeasure+" "+measureCal+" "+code+" "+desc+" "+creator);
        	}
        }])
	});*/
	
	/*var meaForm = new Ext.FormPanel({
		bodyStyle:'padding:5px',
        style: {
            "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },
        labelAlign: 'right',
		frame : true,
		bodyStyle:'padding:5px',
		labelWidth : 60,
		items:[{
			layout:'column',
			items:[{
				columnWidth:.50,
				layout:'form',
				defaultType:'textfield',
				defaults:{
					width:170
				},
				items:[{
					fieldLabel:'查找',
					name     :'addMeasureSearch',
					id     :'addMeasureSearch',
					enableKeyEvents: true,
					listeners :{
						'keypress':function(ele,event){
							if ((event.getKey() == event.ENTER)){
								refresh();
							}
						}
					}
				}]
			}]
		}],
        tbar:new Ext.Toolbar([
        {
        	text:'新增',
            handler:function(){
            	addMeasureObj=new dhcwl.dimrole.AddMeasure(store);
				addMeasureObj.setParentWin(outThis);
            	addMeasureObj.showWin();
            }
        },"-",{
        	text:'修改',
        	handler: function() {
				var rowObj=meaGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				if(len < 1){
					Ext.Msg.show({title:'注意',msg:'请选择需要维护的维度！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
			    }else{
			    	modifyMeasureWin.show();
			    }
        	}
        },"-",{
        	text:'作废',
        	handler: function() {
				var rowObj=meaGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				if(len < 1){
					Ext.Msg.show({title:'注意',msg:'请选择需要维护的维度！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
			    }else{
			    	var ID=rowObj[0].get("meaID");
			    }
				Ext.MessageBox.confirm('提示!!','作废后将不能恢复确认作废么？',function(btn){
					if(btn=='yes'){
						dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=deleteMeasure&ID='+ID,null,function(jsonData){
							if(!jsonData){
								Ext.Msg.show({title:'错误',msg:"作废失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								return;
							}
							if(jsonData.success){
								if (jsonData.tip=="ok") {
									Ext.Msg.show({title:'提示',msg:"作废成功！",buttons: Ext.Msg.OK});
									refresh();
									modifyMeasureWin.hide();
								}else{
									Ext.Msg.alert("提示","作废操作失败了！");
								}
							}else{
								Ext.Msg.show({title:'错误',msg:"处理响应数据失败！\n"+jsonData.tip,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								return;
							}},outThis);
					}
		 			});
        	}
        }/*,"-",{
        	text:'查询',
        	handler: function() {
        		var dataSource=Ext.get('addataSource').getValue();
				var calMeasure=Ext.get('addcalMeasure').getValue();
				var measureCal=Ext.get('addMeasureCal').getValue();
				var code=Ext.get('measureCode').getValue();
				var desc=Ext.get('measureDesc').getValue();
				var creator=Ext.get('measureCreator').getValue();
				Ext.Msg.alert("title",dataSource+" "+calMeasure+" "+measureCal+" "+code+" "+desc+" "+creator);
        	}
        }])
	});*/
	
	//------------------------------------------------以下是修改界面的设计-------------------------------------------
	
	var modifyMeasureForm=new Ext.FormPanel({
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
					name	  :'meaMoifyDesc',
					id	  :'meaMoifyDesc'
				},{
					fieldLabel:'创建日期',
					xtype	 :'datefield',
					name     :'dimModifyDate',
					id     :'dimModifyDate',
					value    :new Date(),
					disabled :true
				}]
			}]
		}],
		buttons:new Ext.Toolbar([
        {
        	//text:'保存',
			text: '<span style="line-Height:1">保存</span>',
        	icon: '../images/uiimages/filesave.png',
        	handler:function(){
        		var rowObj=meaGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				if(len < 1){
					Ext.Msg.show({title:'注意',msg:'请选择需要操作的条目！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}else{
					var ID=rowObj[0].get("meaID");
					var meaMoifyDesc=Ext.get('meaMoifyDesc').getValue();
					paraValues='meaMoifyDesc='+meaMoifyDesc+'&ID='+ID;
					Ext.MessageBox.confirm('提示','确认修改么？',function(btn){
						if(btn=='yes'){
							dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=modifyMeasure&'+paraValues,null,function(jsonData){
								if(!jsonData){
					                	Ext.Msg.show({title:'错误',msg:"修改失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					                	return;
					            }
					            if(jsonData.success){
					            	if (jsonData.tip=="ok") {
					            		Ext.Msg.show({title:'提示',msg:"修改成功！",buttons: Ext.Msg.OK});
					            		localRefresh();
					            		modifyMeasureWin.hide();
					                }else{
										Ext.Msg.alert("提示","修改失败了！");
					                }
					            }else{
					                Ext.Msg.show({title:'错误',msg:"处理响应数据失败！\n"+jsonData.tip,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					                return;
					            }},outThis);
		 				}
		 			});
				}
        	}
        },'-',{
        	//text: '关闭',
			text: '<span style="line-Height:1">关闭</span>',
        	icon: '../images/uiimages/undo.png',
        	handler:function(){
        		var form=modifyMeasureForm.getForm();
        		form.setValues({dimRMoifyDesc:''});
        		modifyMeasureWin.hide();
        	}
        }])
	});
	
	
	
	
	
	//------------------------------------------------以下是整体界面的布局管理-----------------------------------------
    
	var meaPanel =new Ext.Panel ({ 
    	title:'度量配置',
		layout: {
			type: 'vbox',
			pack: 'start',
			align: 'stretch'
		},
		closable:true, 
    	defaults: { border :false},
        items: [/*{ 
			border :false,
			flex:0.70,
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
					items:meaForm
				}]
			}]
    	},*/{
			border :false,
			flex:3,
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
					items:meaGrid
				}]
			}]
        }]
    });
    
    //this.refresh=function(){
	this.refresh=function(){
		/*var dataSource=Ext.get('addataSource').getValue();
		var calMeasure=Ext.get('addcalMeasure').getValue();
		var measureCal=Ext.get('addMeasureCal').getValue();
		var code=Ext.get('measureCode').getValue();
		var desc=Ext.get('measureDesc').getValue();
		var creator=Ext.get('measureCreator').getValue();*/
		var measureSearch=Ext.get('addMeasureSearch').getValue();
		//paraValues='dataSource='+dataSource+'&calMeasure='+calMeasure+'&measureCal='+measureCal+'&code='+code+'&desc='+desc+'&creator'+creator;
		//store.proxy.setUrl(encodeURI("dhcwl/measuredimrole/measure.csp?action=getMeasureInfor&start=0&limit=20&onePage=1&"+paraValues));
		store.proxy.setUrl(encodeURI("dhcwl/measuredimrole/measure.csp?action=getMeasureInfor&start=0&limit=16&onePage=1&measureSearch="+measureSearch));
		store.load();
    }
	
	function localRefresh(){
		var measureSearch=Ext.get('addMeasureSearch').getValue();
		store.proxy.setUrl(encodeURI("dhcwl/measuredimrole/measure.csp?action=getMeasureInfor&start=0&limit=16&onePage=1&measureSearch="+measureSearch));
		store.load();
	}
	
	
	
	var modifyMeasureWin=new Ext.Window({
		title:'度量修改',
    	layout :'fit',
		//border:false,
    	width  :300,
    	height :200,
    	items  :[modifyMeasureForm],
		listeners:{
			'close':function(){
				modifyMeasureWin.close();
				modifyMeasureWin.hide(); 
			}
    	}
    });
    
    /*this.mainWin=new Ext.Viewport({
    	id:'maintainDimRole',
        autoShow:true,
        expandOnShow:true,
        resizable:true,
        layout: 'fit',
        items: [meaPanel]
    });*/
    
	this.getMeasureCfgPanel=function(){
		return meaPanel;
	}
//})
}
