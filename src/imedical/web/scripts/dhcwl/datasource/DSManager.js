(function(){
	Ext.ns("dhcwl.codecfg.SecCodeCfgGroup");
})();
//*************************************************************该页面为数据源维护的主页面****************************************************
Ext.onReady(function() {
	var serviceUrl="dhcwl/measuredimrole/datasource.csp";
	var selectSecGrpID="";
	var selectSecGrpDesc="";
	var selectSecGrpItemID="";
	var selectSecGrpItemDesc="";
	var helpwin="";
    var outThis=this;
	var csm=new Ext.grid.CheckboxSelectionModel({
		
	});
	
	var columnModel = new Ext.grid.ColumnModel([
	    new Ext.grid.RowNumberer(),
        {header:'ID',dataIndex:'ID',sortable:true, width: 30, sortable: false,menuDisabled : true,hidden:true},        
        {header:'统计项名称',dataIndex:'itemName', width: 250, sortable: false,menuDisabled : true},
        {header:'统计项描述',dataIndex:'itemDesc',sortable:false, width: 145, sortable: false,menuDisabled : true},
        {header:'统计项分类',dataIndex:'itemType',sortable:true, width: 80, sortable: true,menuDisabled : true},
        {header:'数据项类型',dataIndex:'dataType', width:140, sortable: false,menuDisabled : true},
        {header:'包名',dataIndex:'tableName', width: 100, sortable: false,menuDisabled : true},
		{header:'表名',dataIndex:'packName', width: 200, sortable: false,menuDisabled : true},
		{header:'表达式',dataIndex:'expvalue', width: 150, sortable: false,menuDisabled : true}
    ]);
	
	var store = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({url:"dhcwl/measuredimrole/datasource.csp?action=getDSItemInfor"}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'ID'},
            	{name: 'itemName'},
            	{name: 'itemDesc'},
            	{name: 'itemType', direction: "ASC"},
				{name: 'dataType'},
            	{name: 'tableName'},
            	{name: 'packName'},
				{name: 'expvalue'}
       		]
    	})
    });
	
	store.load();
	var pageTool=new Ext.PagingToolbar({
        pageSize: 20,
        store: store,
        displayInfo: true,
        displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
        emptyMsg: "没有记录",
        listeners :{
			'change':function(pt,page){
			}
		}
    });
	
    var dataSourceItemGrid = new Ext.grid.GridPanel({
        stripeRows:true,
        loadMask:true,
        height:470,        
        store: store,
        resizeAble:true,
        enableColumnResize :true,
        cm: columnModel,
        sm: csm,
        viewConfig: {forceFit: true},
        //bbar:pageTool,
        listeners:{
        	'contextmenu':function(event){
        		event.preventDefault();
        	}
        }
        
    }); 
	
	
   this.setSelectValue=function(value){
		Ext.getCmp('kpiExcode').setValue(value);
		return;
    }
   
   var secGrpstore=new Ext.data.Store({
	   proxy:new Ext.data.HttpProxy({url:'dhcwl/codecfg/seccodecfgservice.csp?'}),
		   reader:new Ext.data.ArrayReader({},[{name:'value'},{name:'name'}])
   });
   
   var grpcombo=new Ext.form.ComboBox({
	   id           :'grpcombo',
	   listWidth    :300,
	   xtype        :'combo',
	   mode         :'local',
	   triggerAction:'all',
	   //forceSelection: true,
	   editable     :false,
	   fieldLabel   :'数据源选择',
	   name         :'grpcombo',
	   hiddenName   :'title',
	   displayField :'name',
	   valueField   :'value',
	   store        :secGrpstore,
	   tpl:'<tpl for=".">'+'<div class="x-combo-list-item" style="height:18px;">'+'{name}'+'</div>'+'</tpl>',
	   listeners :{
		   'beforequery':function(e){
			   secGrpstore.proxy.setUrl(encodeURI(serviceUrl+'?action=getDSCombo'));
			   secGrpstore.load();
			   return false;
		   },
		   'select':function(combox){
			   refresh();
		   }
		   
	   }
   })
   
   
   
   var top = new Ext.FormPanel({
       frame : true,
		height : 100,
		labelAlign : 'right',
		bodyStyle:'padding:5px',
		labelWidth : 90,
		style : {
			"margin-right" : Ext.isIE6? (Ext.isStrict ? "-10px" : "-13px"): "0"
		},items : [{
			layout : 'column',
			items : [{ 
				columnWidth : .40,
				layout : 'form',
				defaultType : 'textfield',
				defaults : {
					width : 350
				},
				items : [{
					xtype: 'compositefield',
					fieldLabel : '数据源选择',
					defaults: {
						//flex: 2
						width:300
					},
					items:[grpcombo,{
						html: '<IMG id="kpiDimImg" src="../images/websys/lookup.gif" onclick="getProManage()">'
					}]
				}]
			},{ 
				columnWidth : .25,
				layout : 'form',
				defaultType : 'textfield',
				defaults : {
					width : 150
				},
				items : [{
            	   xtype:'textfield',
                   id:'itemDetail',
                   fieldLabel: '搜索',
                   name: 'itemDetail',
				   enableKeyEvents: true,
				   listeners :{
						'keypress':function(ele,event){
							refresh();
						}
					}
               }]
			}]
		}],
			

       tbar: [{
		   text: '<span style="line-Height:1">度量与口径维护</span>',
		   icon   : '../images/uiimages/edit_add.png',
           handler:function(){
			  var form=top.getForm();
              var values=form.getValues(false);
              var tableName=Ext.getCmp('grpcombo').getValue();
			  if (tableName==""){
				  Ext.Msg.alert("提示","请选择数据源后进行操作！");
				  return;
			  }
			  dhcwl_datasource_dsitemCfg=new dhcwl.datasource.dsitemCfg();
			  dhcwl_datasource_dsitemCfg.setParentAct(outThis);
			  dhcwl_datasource_dsitemCfg.show(tableName);
           }
       },'-',{
		    text: '<span style="line-Height:1">修改</span>',
			icon   : '../images/uiimages/pencil.png',
			handler:function(){
				var rowObj=dataSourceItemGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				if(len < 1){
					Ext.Msg.show({title:'注意',msg:'请选择需要操作的条目！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}else{
					modifyDataSourceWin.show();
					var form=modifyDataSourceForm.getForm();
					form.setValues({dsMoifyDesc:''});
				}
			}
	   },'-',{
			text: '<span style="line-Height:1">作废</span>',
			icon   : '../images/uiimages/edit_remove.png',
			handler:function(){
				var rowObj=dataSourceItemGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				if(len < 1){
					Ext.Msg.show({title:'注意',msg:'请选择需要操作的条目！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}else{
					var ID=rowObj[0].get("ID");
					paraValues='ID='+ID;
					Ext.MessageBox.confirm('提示','作废后将不能恢复,确认作废么？',function(btn){
						if(btn=='yes'){
							dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=deleteDSItem&'+paraValues,null,function(jsonData){
								if(!jsonData){
					                	Ext.Msg.show({title:'错误',msg:"作废失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					                	return;
					            }
					            if(jsonData.success){
					            	if (jsonData.tip=="ok") {
					            		Ext.Msg.show({title:'提示',msg:"作废成功！",buttons: Ext.Msg.OK});
					            		refresh();
					                }else{
										Ext.Msg.alert("提示",jsonData.tip);
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
		   text: '<span style="line-Height:1">清空</span>',					
		   icon   : '../images/uiimages/clearscreen.png',
		   handler:function(){
			   var form=top.getForm();
			   form.setValues({grpcombo:'',itemDetail:''});
			   refresh();
		   }
	   },'-',{
		   text: '<span style="line-Height:1">帮助</span>',
		   icon   : '../images/uiimages/help.png',
    	   handler:function(){
			   Helpwin.show();
    	   }
       }]
   });
   //---------------------------------------------------------------以下为修改功能-------------------------------------------------------------
   var modifyDataSourceForm=new Ext.FormPanel({
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
				columnWidth:.84,
				layout:'form',
				defaultType:'textfield',
				defaults:{
					width:120
				},
				items:[{
					fieldLabel :'描述',
					name	  :'dsMoifyDesc',
					id	  :'dsMoifyDesc'
				}]
			}]
		}],
		buttons:new Ext.Toolbar([
        {
			text: '<span style="line-Height:1">保存</span>',
        	icon: '../images/uiimages/filesave.png',
        	handler:function(){
        		var rowObj=dataSourceItemGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				if(len < 1){
					Ext.Msg.show({title:'注意',msg:'请选择需要操作的条目！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}else{
					var ID=rowObj[0].get("ID");
					var modifyDesc=Ext.get('dsMoifyDesc').getValue();
					paraValues='modifyDesc='+modifyDesc+'&ID='+ID;
					Ext.MessageBox.confirm('提示','确认修改么？',function(btn){
						if(btn=='yes'){
							dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=modifyDSItem&'+paraValues,null,function(jsonData){
								if(!jsonData){
					                	Ext.Msg.show({title:'错误',msg:"修改失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					                	return;
					            }
					            if(jsonData.success){
					            	if (jsonData.tip=="ok") {
					            		Ext.Msg.show({title:'提示',msg:"修改成功！",buttons: Ext.Msg.OK});
					            		refresh();
					            		modifyDataSourceWin.hide();
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
			text: '<span style="line-Height:1">关闭</span>',
        	icon: '../images/uiimages/undo.png',
        	handler:function(){
        		var form=modifyDataSourceForm.getForm();
        		form.setValues({dimRMoifyCode:'',dimRMoifyCreator:''});
        		modifyDataSourceWin.hide();
        	}
        }])
	});
	
	var modifyDataSourceWin=new Ext.Window({
		title  :'明细数据修改',
    	layout :'fit',
    	width  :300,
    	height :150,
    	items  :[modifyDataSourceForm],
		listeners:{
			'close':function(){
				modifyDataSourceWin.close();
				modifyDataSourceWin.hide(); 
			}
    	}
    });
   //---------------------------------------------------------------以上为修改功能-------------------------------------------------------------
   
   
   var Helpwin = new Ext.Window({
		title : '页面说明',
		width:850,
		height: 550,
		layout : 'fit',
		plain : true,
		modal : true,
		frame : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		closeAction : 'hide',
		items : helphtml={
			html:' <iframe scrolling="auto" frameborder="0" width="100%" height="100%" src="../scripts/dhcwl/datasource/help/数据源管理文档.htm"></iframe>'
		}
	})
    this.getProManage=function(){
    	var secProManageObj = new dhcwl.codecfg.SecProManage();
    	secProManageObj.showWin();
    }
	this.refresh=function(){
		var tableName=Ext.getCmp('grpcombo').getValue();
		var detail=Ext.getCmp('itemDetail').getValue();
		store.proxy.setUrl(encodeURI("dhcwl/measuredimrole/datasource.csp?action=getDSItemInfor&start=0&limit=16&onePage=1&tableName="+tableName+"&detail="+detail));
		store.load();
	}
    
	var codecfggroupPanel =new Ext.Panel ({ //Viewport({
    	title:'数据源维护',
		layout: {
			type: 'vbox',
			pack: 'start',
			align: 'stretch'
		},
		
    	defaults: { border :false},
        items: [{ 
			border :false,
			flex:1,
			layout:"fit",
            items:top
            //items:kpiForm
    	},{
			border :false,
			flex:5,
			layout:"fit",
            items:dataSourceItemGrid
        }]
    });
	this.mainWin=new Ext.Viewport({
	id:'maintainCodeCfgGroup',
    autoShow:true,
    expandOnShow:true,
    resizable:true,
    layout: 'fit',
    items: [codecfggroupPanel]
    });
})