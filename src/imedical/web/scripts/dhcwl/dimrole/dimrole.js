(function(){
	Ext.ns("dhcwl.dimrole.dimrole");
})();
//-------------------------------------------------------------维度角色维护界面----------------------------------------------------------
//-------------------------------------------------------------以下是维度维护-------------------------------------------------------
//Ext.onReady(function() {
dhcwl.dimrole.dimrole=function(){
	var serviceUrl="dhcwl/measuredimrole/dimrole.csp";
	var outThis=this;
	var choicegrpId="";
	var strPara="";
	var columnModel = new Ext.grid.ColumnModel([
        {header:'ID',dataIndex:'dimID',sortable:true, width: 70, sortable: true,menuDisabled : true},
        {header:'维度编码',dataIndex:'dimCode', width: 100, sortable: true,menuDisabled : true},
        {header:'维度名称',dataIndex:'dimName', width: 110, sortable: true,menuDisabled : true},
        {header:'维度描述',dataIndex:'dimDesc', width: 110, sortable: true,menuDisabled : true},
        {header:'备注',dataIndex:'dimRemark', width: 100, sortable: true,menuDisabled : true},
        {header:'创建人',dataIndex:'dimCreator',sortable:true, width: 80, sortable: true,menuDisabled : true}
    ]);
	
	var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=getDimInfor'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'dimID'},
            	{name: 'dimCode'},
            	{name: 'dimName'},
            	{name: 'dimDesc'},
            	{name: 'dimRemark'},
            	{name: 'dimCreator'}
       		]
    	})
    });
    store.load()
	//维度grid
    var dimGrid = new Ext.grid.GridPanel({
        stripeRows:true,
        loadMask:true,
        height:450,        
        store: store,
        resizeAble:true,
        enableColumnResize :true,
        cm: columnModel,
        sm: new Ext.grid.RowSelectionModel({
        	singleSelect: true,
            listeners: {
            }
        }),
        listeners :{
        	'click':function(ele,event){
        		refresh();
        	 }
         },
		tbar: new Ext.Toolbar([{
            xtype:'label',
			text:'查找: '
        },{
			fieldLabel : '查找',
			xtype:'textfield',
			name: 'search',
			id	: 'search',
			enableKeyEvents: true,
			listeners :{
				'keypress':function(ele,event){
					searcheValue=Ext.get("search").getValue();//获取搜索值
					if ((event.getKey() == event.ENTER)){
						//alert(searcheValue);
						store.proxy.setUrl(encodeURI(serviceUrl+'?action=getDimInfor&searcheValue='+searcheValue));
						store.load();
					}
				}
			}
		}])

    });
    
    //维度Form
	/*var dimForm = new Ext.FormPanel({
        height: 100,
        width:600,
        labelAlign: 'right',
        bodyStyle:'padding:5px',
        style: {
            "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },
        frame : true,
		bodyStyle:'padding:5px',
		labelWidth : 60,
        
		items : [{
			layout : 'column',
			items : [
			{ 
				columnWidth : .8,
				layout : 'form',
				defaultType : 'textfield',
				defaults : {
					width : 200
				},
				items : [{
					fieldLabel : '查找',
					xtype:'textfield',
					name: 'search',
					id	: 'search',
					enableKeyEvents: true,
					listeners :{
						'keypress':function(ele,event){
							searcheValue=Ext.get("search").getValue();//获取搜索值
							if ((event.getKey() == event.ENTER)){
								//alert(searcheValue);
								store.proxy.setUrl(encodeURI(serviceUrl+'?action=getDimInfor&searcheValue='+searcheValue));
								store.load();
							}
						}
					}
				}]
			}]
		}]
	});*/
	
	//-------------------------------------------------------------以下是维度角色维护-------------------------------------------------------
	
    var selectedKpiIds=[];
	var csm = new Ext.grid.CheckboxSelectionModel()     //新建复选框的对象，使用的时候直接写  'csm' 
    var columnModelSubGrp = new Ext.grid.ColumnModel([
        {header:'ID',dataIndex:'ID',width: 30, sortable: true,menuDisabled : true},
        {header:'维度角色编码',dataIndex:'DimRoleCode',sortable:true,  width: 100, sortable: true,menuDisabled : true},
        {header:'维度角色名称',dataIndex:'DimRoleName',sortable:true,  width: 120, sortable: true,menuDisabled : true},
        {header:'维度角色描述',dataIndex:'DimRoleDesc',sortable:true,  width: 120, sortable: true,menuDisabled : true},
        {header:'创建人',dataIndex:'DimRoleCreator',sortable:true,  width: 60, sortable: true,menuDisabled : true},
        {header:'创建时间',dataIndex:'DimRoleDate',sortable:true,  width: 80, sortable: true,menuDisabled : true}
    ]);
    columnModelSubGrp.defaultSortable = true;
    var storeSubGrp = new Ext.data.Store({
    	proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=getDimRole'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNums',
            root: 'root',
        	fields:[
        		{name: 'ID'},
            	{name: 'DimRoleCode'},
            	{name: 'DimRoleName'},
            	{name: 'DimRoleDesc'},
            	{name: 'DimRoleCreator'},
            	{name: 'DimRoleDate'}
       		]
    	})
    });
    
    //storeSubGrp.setDefaultSort('ItmGrpDetSort', 'asc');    
    //storeSubGrp.load();
    var dimRoleGrid = new Ext.grid.GridPanel({
        id:'subgroupGrid',
        stripeRows:true,
        loadMask:true,
        height:450,  
        //width:300,
        store: storeSubGrp,
        resizeAble:true,
        //autoHeight:true,
        enableColumnResize :true,
        cm: columnModelSubGrp,
        sm:csm,   //new Ext.grid.RowSelectionModel(),
        enableDragDrop: true,   //拖动排序用的属性
        dropConfig: {           //拖动排序用的属性
            appendOnly:true  
        },
		tbar:new Ext.Toolbar([
        {
        	//text:'新增',
			text: '<span style="line-Height:1">新增</span>',
        	icon: '../images/uiimages/edit_add.png',
            handler:function(){
            	var rowObj=dimGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				if(len < 1){
					Ext.Msg.show({title:'注意',msg:'请先选择需要维护的维度！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
			    }else{
			    	addDimRoleWin.show();
			    }
            }
        },"-",{
        	//text:'修改',
			text: '<span style="line-Height:1">修改</span>',
			icon: '../images/uiimages/pencil.png',
        	handler: function() {
        		var rowObj=dimRoleGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				if(len < 1){
					Ext.Msg.show({title:'注意',msg:'请选择需要操作的条目！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}else{
					modifyDimRoleWin.show();
				}
        	}
        },"-",{
        	//text:'作废',
			text: '<span style="line-Height:1">作废</span>',
			icon: '../images/uiimages/edit_remove.png',
        	handler: function() {
        		var rowObj=dimRoleGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				if(len < 1){
					Ext.Msg.show({title:'注意',msg:'请选择需要操作的条目！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}else{
					var ID=rowObj[0].get("ID");
					Ext.MessageBox.confirm('警告！！','作废后不可再恢复,确认要作废么？',function(btn){
						if(btn=='yes'){
							dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=deleteDimrole&ID='+ID,null,function(jsonData){
								if(!jsonData){
					                	Ext.Msg.show({title:'错误',msg:"作废失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					                	return;
					            }
					            if(jsonData.success){
					            	if (jsonData.tip=="ok") {
					            		Ext.Msg.show({title:'提示',msg:"作废成功！",buttons: Ext.Msg.OK});
					            		refresh();
					                }else{
										Ext.Msg.alert("提示","作废失败了！");
					                }
					            }else{
					                Ext.Msg.show({title:'错误',msg:"处理响应数据失败！\n"+jsonData.tip,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					                return;
					            }},outThis);
		 				}
		 			});
				}
        	}
        }])
    });
    
   
    //维度角色Form
	/*var dimRoleForm = new Ext.FormPanel({
		frame: true,
        height: 150,
        width:600,
        labelAlign: 'left',
        bodyStyle:'padding:5px',
        style: {
            "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },
        layout: 'table',
        defaultConfig:{width:130},
        tbar:new Ext.Toolbar([
        {
        	//text:'新增',
			text: '<span style="line-Height:1">新增</span>',
        	icon: '../images/uiimages/edit_add.png',
            handler:function(){
            	var rowObj=dimGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				if(len < 1){
					Ext.Msg.show({title:'注意',msg:'请先选择需要维护的维度！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
			    }else{
			    	addDimRoleWin.show();
			    }
            }
        },"-",{
        	//text:'修改',
			text: '<span style="line-Height:1">修改</span>',
			icon: '../images/uiimages/pencil.png',
        	handler: function() {
        		var rowObj=dimRoleGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				if(len < 1){
					Ext.Msg.show({title:'注意',msg:'请选择需要操作的条目！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}else{
					modifyDimRoleWin.show();
				}
        	}
        },"-",{
        	//text:'作废',
			text: '<span style="line-Height:1">作废</span>',
			icon: '../images/uiimages/edit_remove.png',
        	handler: function() {
        		var rowObj=dimRoleGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				if(len < 1){
					Ext.Msg.show({title:'注意',msg:'请选择需要操作的条目！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}else{
					var ID=rowObj[0].get("ID");
					Ext.MessageBox.confirm('警告！！','作废后不可再恢复,确认要作废么？',function(btn){
						if(btn=='yes'){
							dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=deleteDimrole&ID='+ID,null,function(jsonData){
								if(!jsonData){
					                	Ext.Msg.show({title:'错误',msg:"作废失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					                	return;
					            }
					            if(jsonData.success){
					            	if (jsonData.tip=="ok") {
					            		Ext.Msg.show({title:'提示',msg:"作废成功！",buttons: Ext.Msg.OK});
					            		refresh();
					                }else{
										Ext.Msg.alert("提示","作废失败了！");
					                }
					            }else{
					                Ext.Msg.show({title:'错误',msg:"处理响应数据失败！\n"+jsonData.tip,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					                return;
					            }},outThis);
		 				}
		 			});
				}
        	}
        }])
	});*/
    
	//------------------------------------------------------------以下是维度角色的新增和修改界面-----------------------------------------------
	
	var addDimRoleForm=new Ext.FormPanel({
		//title:"新增维度角色",
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
				columnWidth:.33,
				layout:'form',
				defaultType:'textfield',
				defaults:{
					width:120
				},
				items:[{
					fieldLabel :'编码',
					name	  :'dimRoleCode',
					id	  :'dimRoleCode'
				},{
					fieldLabel :'创建人',
					name	  :'dimRoleCreator',
					id	  :'dimRoleCreator'
				}]
			},{
				columnWidth:.33,
				layout:'form',
				defaultType:'textfield',
				defaults:{
					width:120
				},
				items:[{
					fieldLabel:'名称',
					name	 :'dimRoleName',
				    id	 :'dimRoleName'
				},{
					fieldLabel:'创建日期',
					xtype	 :'datefield',
					name     :'dimCreatDate',
					id     :'dimCreatDate',
					value    :new Date(),
					disabled :true
				}]
			},{
				columnWidth:.33,
				layout:'form',
				defaultType:'textfield',
				defaults:{
					width:120
				},
				items:[{
					fieldLabel:'描述',
					name	 :'dimRoleDesc',
					id	 :'dimRoleDesc'
				}]
			}]
		}],
		buttons:new Ext.Toolbar([
        {
        	//text:'保存',
			text: '<span style="line-Height:1">保存</span>',
        	icon: '../images/uiimages/filesave.png',
        	handler:function(){
        		var rowObj=dimGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				if(len < 1){
					Ext.Msg.show({title:'注意',msg:'请选择需要维护的维度！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
			    }else{
			    	var ID=rowObj[0].get("dimID");
			    }
        		var dimRoleCode=Ext.get('dimRoleCode').getValue();
                var dimRoleCreator=Ext.get('dimRoleCreator').getValue();
                var dimRoleName=Ext.get('dimRoleName').getValue();
                var dimRoleDesc=Ext.get('dimRoleDesc').getValue();
                var reg=/[\$\#\@\&\%\!\*\^\~||\-\(\)\']/;
                var reg2=/^\d/;
                var reg3=/\s/;
                if(reg.test(dimRoleCode)||(reg2.test(dimRoleCode))||(reg3.test(dimRoleCode))){
                	alert("编码不能包括$,#,@,&,%,*,^,!,~,||,-,(,),'以及空格等特殊字符，并且不能以数字开头");
                	//Ext.get("kpiCode").focus();
                	return;
                }
                paraValues='dimRoleCode='+dimRoleCode+'&dimRoleCreator='+dimRoleCreator+'&dimRoleName='+dimRoleName+'&dimRoleDesc='+dimRoleDesc+'&dimID='+ID;
        		//alert(dimRoleCode+" "+dimRoleCreator+" "+dimRoleName+" "+dimRoleDesc+" "+ID);
        		//return;
                dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=addimrole&'+paraValues
	                ,null,function(jsonData){
	                	if(!jsonData){
	                		Ext.Msg.show({title:'错误',msg:"增加失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	                		return;
	                	}
	                	if(jsonData.success){
	                		if (jsonData.tip=="ok") {
	                			Ext.Msg.show({title:'提示',msg:"增加成功！",buttons: Ext.Msg.OK});
	                			var form=addDimRoleForm.getForm();
	                    		form.setValues({dimRoleCode:'',dimRoleCreator:'',dimRoleName:'',dimRoleDesc:''});
	                    		addDimRoleWin.hide();
	                    		refresh();
	                		}else{
	                			var form=addDimRoleForm.getForm();
	                    		form.setValues({dimRoleCode:'',dimRoleCreator:'',dimRoleName:'',dimRoleDesc:''});
								Ext.Msg.alert("提示",jsonData.tip);
	                		}
	                	}else{
	                		Ext.Msg.show({title:'错误',msg:"处理响应数据失败！\n"+jsonData.tip,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	                		return;
	                	}
	                },outThis);
        	}
        },'-',{
        	//text: '关闭',
			text: '<span style="line-Height:1">关闭</span>',
        	icon: '../images/uiimages/undo.png',
        	handler:function(){
        		var form=addDimRoleForm.getForm();
        		form.setValues({dimRoleCode:'',dimRoleCreator:'',dimRoleName:'',dimRoleDesc:''});
        		addDimRoleWin.hide();
        	}
        }])
	});
	
	var modifyDimRoleForm=new Ext.FormPanel({
		//title:"修改维度角色",
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
				columnWidth:.44,
				layout:'form',
				defaultType:'textfield',
				defaults:{
					width:120
				},
				items:[{
					fieldLabel :'名称',
					name	  :'dimRMoifyName',
					id	  :'dimRMoifyName'
				},{
					fieldLabel:'创建日期',
					xtype	 :'datefield',
					name     :'dimModifyDate',
					id     :'dimModifyDate',
					value    :new Date(),
					disabled :true
				}]
			},{
				columnWidth:.44,
				layout:'form',
				defaultType:'textfield',
				defaults:{
					width:120
				},
				items:[{
					fieldLabel :'描述',
					name	  :'dimRMoifyDesc',
					id	  :'dimRMoifyDesc'
				}]
			}]
		}],
		buttons:new Ext.Toolbar([
        {
        	//text:'保存',
			text: '<span style="line-Height:1">保存</span>',
        	icon: '../images/uiimages/filesave.png',
        	handler:function(){
        		var rowObj=dimRoleGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				if(len < 1){
					Ext.Msg.show({title:'注意',msg:'请选择需要操作的条目！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}else{
					var ID=rowObj[0].get("ID");
					var dimRMoifyDesc=Ext.get('dimRMoifyDesc').getValue();
					var dimRMoifyName=Ext.get('dimRMoifyName').getValue();
					paraValues='dimRMoifyName='+dimRMoifyName+'&dimRMoifyDesc='+dimRMoifyDesc+'&ID='+ID+'&dimModifyDate='+dimModifyDate;
					Ext.MessageBox.confirm('提示','确认修改么？',function(btn){
						if(btn=='yes'){
							dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=modifyDimrole&'+paraValues,null,function(jsonData){
								if(!jsonData){
					                	Ext.Msg.show({title:'错误',msg:"修改失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					                	return;
					            }
					            if(jsonData.success){
					            	if (jsonData.tip=="ok") {
					            		Ext.Msg.show({title:'提示',msg:"修改成功！",buttons: Ext.Msg.OK});
					            		refresh();
					            		modifyDimRoleWin.hide();
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
        		var form=modifyDimRoleForm.getForm();
        		form.setValues({dimRMoifyCode:'',dimRMoifyCreator:''});
        		modifyDimRoleWin.hide();
        	}
        }])
	});
	//------------------------------------------------------------以上是维度角色的新增和修改界面----------------------------------------
	
    var dimRolePanel =new Ext.Panel ({ 
    	title:'维度角色维护',
		layout: {
			type: 'vbox',
			pack: 'start',
			align: 'stretch'
		},
		closable:true,
    	defaults: { border :false},
        items: [/*{ 
			border :false,
			flex:0.6,
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
					items:dimForm
				},{
					flex:1,
					layout:"fit",
					items:dimRoleForm					
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
					items:dimGrid
				},{
					flex:1,
					layout:"fit",
					items:dimRoleGrid					
				}]
			}]
        }]
    });
    
    //this.refresh=function(){
	function refresh(){
		var rowObj=dimGrid.getSelectionModel().getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'因为不可抗拒 因素,没有刷新成功！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
	    }else{
	    	ID=rowObj[0].get("dimID");
	    	storeSubGrp.proxy.setUrl(encodeURI(serviceUrl+'?action=getDimRole&dimID='+ID));
	    	storeSubGrp.load();
	    }
    }
    
    /*this.mainWin=new Ext.Viewport({
    	id:'maintainDimRole',
        //renderTo:Ext.getBody(),
        autoShow:true,
        expandOnShow:true,
        resizable:true,
        layout: 'fit',
        items: [dimRolePanel]
    });*/
    
    var addDimRoleWin=new Ext.Window({
    	//id：'addDimRoleWin',
		title  :'维度角色新增',
    	layout :'fit',
    	width  :600,
    	height :200,
    	items  :[addDimRoleForm],
		listeners:{
			'close':function(){
				addDimRoleWin.close();
				addDimRoleWin.hide(); 
			}
    	}
    });
    
    var modifyDimRoleWin=new Ext.Window({
		title  :'维度角色修改',
    	layout :'fit',
    	width  :500,
    	height :200,
    	items  :[modifyDimRoleForm],
		listeners:{
			'close':function(){
				modifyDimRoleWin.close();
				modifyDimRoleWin.hide(); 
			}
    	}
    });
	this.getDimroleCfgPanel=function(){
		return dimRolePanel;
	}
//})
}