(function(){
	Ext.ns("dhcwl.mripday.MripdayDetailRptItemCfg");
})();
///描述: 		明细报表配置页面
///编写者：		WZ
///编写日期: 		2014-11
dhcwl.mripday.MripdayDetailRptItemCfg=function(){
	var serviceUrl="dhcwl/mripday/mripdayDetailRptCfg.csp";
	var ItemType="KPIDetailItem";
	var rptDR="";
	var rptDesc="";
	var OPTLItem="";
	var itemDesc="";
	var parentWin=null;
	
	var fromColumnModel = new Ext.grid.ColumnModel([
        {header:'编码',dataIndex:'detailCode',sortable:true, width: 100, sortable: true,menuDisabled : true
        },{header:'描述',dataIndex:'detailDesc',sortable:true, width: 180, sortable: true,menuDisabled : true}
        ]);
	var toColumnModel = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),
        {header:'编码',dataIndex:'detailCode',sortable:true, width: 100, sortable: true,menuDisabled : true
        },{header:'描述',dataIndex:'detailDesc',sortable:true, width: 180, sortable: true,menuDisabled : true}
        ]);        
        
    var fromStore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=SearchOPTLDetailItem&ItemType='+ItemType+'&ExceptOPTLItem='+OPTLItem+'&rptDR='+rptDR+'&start=0&limit=21&onePage=1'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'ID'},
            	{name: 'detailCode'},
            	{name: 'detailDesc'}
       		]
    	})
    });
    
    var toStore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=SearchDetailRptItem&ItemType='+ItemType+'&OPTLItem='+OPTLItem+'&rptDR='+rptDR+'&start=0&limit=21&onePage=1'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'ID'},        	
            	{name: 'detailCode'},
            	{name: 'detailDesc'}
       		]
    	})
    });    
    

    var fromGrid = new Ext.grid.GridPanel({
    	title:"可选明细统计项",
        height:350,
        width:360,
        store: fromStore,
        cm: fromColumnModel,
        sm: new Ext.grid.RowSelectionModel({
        	singleSelect: true,
            listeners: {
            }
        }),
        listeners:{

        	'rowdblclick' : function(th, rowIndex, e ) {
       			/*
       			var selRec=fromGrid.getStore().getAt(rowIndex);
				fromGrid.getStore().remove(selRec);
				toGrid.getStore().add(selRec);
				*/
				
				var selRec=fromGrid.getSelectionModel().getSelected();
				var DetTtpe=DetailTypeform.getForm().findField('DetailType').getValue();  //获取当前类型
				if (OPTLItem&&(DetTtpe=='PUBLIC')){
					Ext.Msg.alert("提示","公共明细，请到报表配置界面，双击'明细报表'单元格配置！");
					return;
				}
				if (!selRec) {
					return;
				} 
				fromGrid.getStore().remove(selRec);
				toGrid.getStore().add(selRec);	
				addDetailRptItem(OPTLItem,rptDR,itemDesc);
        	}

        },
        bbar:new Ext.PagingToolbar({
            pageSize: 21,
            store: fromStore,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录"
        })
    });

    var toGrid = new Ext.grid.GridPanel({
    	title:"已选明细统计项",
        height:350,
        width:360,
        store: toStore,
        cm: toColumnModel,
        sm: new Ext.grid.RowSelectionModel({
        	singleSelect: true,
            listeners: {
 
            	
            }
        }),
        listeners:{

       		'rowdblclick' : function(th,rowIndex, e ){
       			/*
       			var selRec=toGrid.getStore().getAt(rowIndex);
				toGrid.getStore().remove(selRec);
				fromGrid.getStore().add(selRec);
				*/
				var selRec=toGrid.getSelectionModel().getSelected();
				var DetTtpe=DetailTypeform.getForm().findField('DetailType').getValue();  //获取当前类型
				if (OPTLItem&&(DetTtpe=='PUBLIC')){
					Ext.Msg.alert("提示","公共明细，请到报表配置界面，双击'明细报表'单元格配置！");
					return;
				}
				if (!selRec) {
					return;
				}   	
				toGrid.getStore().remove(selRec);
				fromGrid.getStore().add(selRec);				
  				addDetailRptItem(OPTLItem,rptDR,itemDesc);
				
       		}     
  	
        	
        },
        bbar:new Ext.PagingToolbar({
            pageSize: 21,
            store: toStore,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录"
        })
    });
    

	

    //store.load({params:{start:0,limit:21}});	
	
     var actform = new Ext.FormPanel({
     	width:70,
     	height:350,
		layout: {
		    type:'vbox',
		    padding:'5',
		    pack:'center',
		    align:'center'
		},
		defaults:{margins:'0 0 5 0'},
		items:[{
		    xtype:'button',
		  	id: '>',
		    icon: '../images/uiimages/moveright.png',
		  	width:40,
		  	handler:onBtnClick
		    //icon:'up2.gif', 
		    //cls:'x-btn-text-icon'
			//iconCls: 'add16'
		},{
		    xtype:'button',
		    id: ' < ',
		    icon: '../images/uiimages/moveleft.png',
		  	width:40,
		  	handler:onBtnClick
		},{
		    xtype:'button',
		    id: '∧',
		    icon: '../images/uiimages/moveup.png',
		  	width:40,
		  	handler:onBtnClick
		},{
		    xtype:'button',
		    id: '∨',
		    icon: '../images/uiimages/movedown.png',
		    margins:'0',
		  	width:40,
		  	handler:onBtnClick
		}]

    });
	
    var detailRptItemPanel =new Ext.Panel({
    	//title:'报表配置',
    	layout:"table",
        layoutConfig:{columns:3},
        items: [fromGrid,actform,toGrid]

    });
    
    var detailTypeCbo = new Ext.form.ComboBox({ 
            xtype: 			'combo',
            mode:           'local',
            displayField:   'typeDesc',
            triggerAction:  'all',
            forceSelection: true,
            editable:       false,
            name:           'DetailType',
            hiddenName:     'DetailType',
            displayField:   'typeDesc',
            valueField:     'typevalue',
            store: new Ext.data.JsonStore({
		        fields : ['typevalue','typeDesc' ],
		        data   : [
 	    			{typevalue:'PUBLIC', typeDesc:'公共明细'}, 
	    		 	{typevalue:'PRIVATE', typeDesc:'私有明细'}	            
		        ]
		    }),
            emptyText : '请选择', 
            id: 'detailTypeID',
            listeners: {
             	'select' : function(combo,record,index ) {
            		var typevalue=record.get('typevalue');
            		//alert(typevalue);
            		if (typevalue=="PUBLIC"){
		           		//refreshGridByType(ItemType,rptDR,''); 
            			//刷新左边grid
		   				fromGrid.getStore().proxy.setUrl(encodeURI(serviceUrl+'?action=SearchOPTLDetailItem&ItemType='+ItemType+'&ExceptOPTLItem='+''+'&rptDR='+rptDR+'&start=0&limit=21&onePage=1'));
		   				fromGrid.getStore().load({params:{start:0,limit:21}});
		   				fromGrid.show(); 
	   					//刷新右边grid
	   					toGrid.getStore().proxy.setUrl(encodeURI(serviceUrl+'?action=SearchDetailRptItem&ItemType='+ItemType+'&OPTLItem='+''+'&rptDR='+rptDR+'&start=0&limit=21&onePage=1'));
	   					toGrid.getStore().load({params:{start:0,limit:21}});
	   					toGrid.show();  
            		}else{
						//refreshGridByType(ItemType,rptDR,OPTLItem);
            			//刷新左边grid
		   				fromGrid.getStore().proxy.setUrl(encodeURI(serviceUrl+'?action=SearchOPTLDetailItem&ItemType='+ItemType+'&ExceptOPTLItem='+OPTLItem+'&rptDR='+rptDR+'&start=0&limit=21&onePage=1'));
		   				fromGrid.getStore().load({params:{start:0,limit:21}});
		   				fromGrid.show(); 
	   					//刷新右边grid
	   					toGrid.getStore().proxy.setUrl(encodeURI(serviceUrl+'?action=SearchDetailRptItem&ItemType='+ItemType+'&OPTLItem='+OPTLItem+'&rptDR='+rptDR+'&start=0&limit=21&onePage=1'));
	   					toGrid.getStore().load({params:{start:0,limit:21}});
	   					toGrid.show();  
            		}
            	}
            }
            
	});	
	
    var DetailTypeform = new Ext.FormPanel({
        frame: true,
        height: 50,
        labelAlign: 'left',
        bodyStyle:'padding:5px',
        style: {
        	//"margin-left": "10px", // when you add custom margin in IE 6...
            "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },
        layout: 'table',
        defaultConfig:{width:140},
        layoutConfig: {columns:6},
        items:[
		{
            html:'明细类型：'
        }, detailTypeCbo
        ]
    });
    
	//	定义窗口
	var detailRptItemWin = new Ext.Window({
		id:'detailRptItemWin',
		title:'明细报表配置',
        width:810,
		height:470,
		resizable:false,
		closeAction:'close',
		layout:'border',
		modal:true,
		items:[
			{
			region:'north',
			height:80,
			layout:'fit',
			items:DetailTypeform
			},{
			region:'center',
			items:detailRptItemPanel
			}
		],
        buttons: [{
            text: '<span style="line-Height:1">关闭</span>',
            icon: '../images/uiimages/cancel.png',
            handler: OnCancel
        }],		
		listeners:{
			'close':function(){
				///detailRptItemWin.hide();
				//parentWin.getParent().refresh();  add by chenyi.2015-09-14
			}
		}
	});

	function onBtnClick(btn){
		
		var DetTtpe=DetailTypeform.getForm().findField('DetailType').getValue();  //获取当前类型
		var act="";
   		partCalExp=btn.getId();
		if(partCalExp==">"){
			var selRec=fromGrid.getSelectionModel().getSelected();
			if (!selRec) {
				return;
			} 

			if (OPTLItem&&(DetTtpe=='PUBLIC')){
				Ext.Msg.alert("提示","公共明细，请到报表配置界面，双击'明细报表'单元格配置！");
				return;
			}
			fromGrid.getStore().remove(selRec);
			toGrid.getStore().add(selRec);	
			
		}else{
			var selRec=toGrid.getSelectionModel().getSelected();
			if (!selRec) {
				return;
			}   	
			if(partCalExp==" < "){
				if (OPTLItem&&(DetTtpe=='PUBLIC')){
					Ext.Msg.alert("提示","公共明细，请到报表配置界面，双击'明细报表'单元格配置！");
					return;
				}
				toGrid.getStore().remove(selRec);
				fromGrid.getStore().add(selRec);				
				
			}else if(partCalExp=="∧"){
				var selIndex=toGrid.getStore().indexOf(selRec);
				if (OPTLItem&&(DetTtpe=='PUBLIC')){
					Ext.Msg.alert("提示","公共明细，请到报表配置界面，双击'明细报表'单元格配置！");
					return;
				}
				if (selIndex<=0) return;
				toGrid.getStore().remove(selRec);
				toGrid.getStore().insert(selIndex-1,selRec);	
				toGrid.getSelectionModel().selectRow(selIndex-1);
				
			}else if(partCalExp=="∨"){
				var selIndex=toGrid.getStore().indexOf(selRec);
				var cnt=toGrid.getStore().getCount();
				if (OPTLItem&&(DetTtpe=='PUBLIC')){
					Ext.Msg.alert("提示","公共明细，请到报表配置界面，双击'明细报表'单元格配置！");
					return;
				}
				if (selIndex==cnt-1) return;
				toGrid.getStore().remove(selRec);
				toGrid.getStore().insert(selIndex+1,selRec);				
				toGrid.getSelectionModel().selectRow(selIndex+1);
			}
		}
		addDetailRptItem(OPTLItem,rptDR,itemDesc);
		
    }    
    
    function addDetailRptItem(OPTLItem,rptDR,itemDesc){
		act="?action=addDetailRptItem&OPTLItemDR="+OPTLItem+"&RptDR="+rptDR+"&ItemDesc="+itemDesc;
		var count=toGrid.getStore().getCount() ;		
		var aryOPTLDetailItemDRs=[];
		var aryRptItemOrders=[];
		for(var i=0;i<=count-1;i++){
			var rec=toGrid.getStore().getAt(i);
			var OPTLDetailItemDR=rec.get('ID'); 
			aryOPTLDetailItemDRs.push(OPTLDetailItemDR);
		}
        var url=serviceUrl+act;
		dhcwl.mkpi.Util.ajaxExc(url,{aryOPTLDetailItemDRs:aryOPTLDetailItemDRs.join(",")},function(jsonData){
				if(jsonData.success==true && jsonData.tip=="ok"){

				}else{
					Ext.Msg.alert("提示","操作失败！");
					}
					
				},this);	    	
    }
    
    
	this.showWin=function(parent){
		parentWin=parent;
		var winTitle="";
		if (itemDesc!="") winTitle="当前编辑: ' "+rptDesc+" '报表中' "+itemDesc+" '统计项关联的明细报表";
		else winTitle="当前编辑: ' "+rptDesc+" '报表中默认明细报表";
		detailRptItemWin.setTitle(winTitle);
		
		//如果统计项id是空的（即从主表默认明细进入界面），不可选择（关联明细）。
		if (OPTLItem==""){
			//设置默认值：公共明细
			DetailTypeform.getForm().findField('DetailType').setValue("PUBLIC");
			Ext.getCmp('detailTypeID').disable()
		}
		else{
			//设置默认值：私有明细
			DetailTypeform.getForm().findField('DetailType').setValue("PRIVATE");
			Ext.getCmp('detailTypeID').enable();
		}
		
		detailRptItemWin.show();
		refreshFrom();
		refreshTo();
		//var str='ItemType='+ItemType+'&ExceptOPTLItem='+OPTLItem+'&rptDR='+rptDR;
		//alert(str);
        fromStore.proxy=new Ext.data.HttpProxy({url:encodeURI(serviceUrl+'?action=SearchOPTLDetailItem&ItemType='+ItemType+'&ExceptOPTLItem='+OPTLItem+'&rptDR='+rptDR+'&start=0&limit=21&onePage=1')}); 
		toStore.proxy=new Ext.data.HttpProxy({url:encodeURI(serviceUrl+'?action=SearchDetailRptItem&ItemType='+ItemType+'&OPTLItem='+OPTLItem+'&rptDR='+rptDR+'&start=0&limit=21&onePage=1')});
		

	}

	this.setSubWinParam=function(RptItemRptDR,OPTLItemDR,RptItemRptDesc,OPTLItemDesc){
		rptDR=RptItemRptDR;
		OPTLItem=OPTLItemDR;
		rptDesc=RptItemRptDesc;
		itemDesc=OPTLItemDesc;

	}

    function refreshFrom(){
		fromGrid.getStore().proxy.setUrl(encodeURI(serviceUrl+'?action=SearchOPTLDetailItem&ItemType='+ItemType+'&ExceptOPTLItem='+OPTLItem+'&rptDR='+rptDR+'&start=0&limit=21&onePage=1'));
		fromGrid.getStore().load({params:{start:0,limit:21}});
	    fromGrid.show();   
  	
    }
    
    function refreshTo(){
		toGrid.getStore().proxy.setUrl(encodeURI(serviceUrl+'?action=SearchDetailRptItem&ItemType='+ItemType+'&OPTLItem='+OPTLItem+'&rptDR='+rptDR+'&start=0&limit=21&onePage=1'));
		toGrid.getStore().load({params:{start:0,limit:21}});
	    toGrid.show();   
  	
    }   
       
    function OnCancel() {
		//detailRptItemWin.hide();   
    	detailRptItemWin.close();
		//parentWin.getParent().refresh();   add by chenyi.2015-09-14
    }

}