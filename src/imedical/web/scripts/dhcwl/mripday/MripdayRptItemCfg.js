(function(){
	Ext.ns("dhcwl.mripday.MripdayRptItemCfg");
})();

dhcwl.mripday.MripdayRptItemCfg=function(){
	var serviceUrl="dhcwl/mripday/mripdayRptCfg.csp";
	var RptItemRptDR="";
	var RptItemRptDesc="";
	var RptItemCode="";
	var outThis=this;
	var detailRptItemWin=null;

	var quickMenu=new Ext.menu.Menu({
		//autoWidth:true,
		boxMinWidth:150,
		ignoreParentClicks:true,
    	items:[
    		{
    			text:'私有明细配置',
    			handler:function(){
			 		var isSel=toGrid.getSelectionModel().getSelected();
					if (!isSel) {
						Ext.MessageBox.alert("提示","请先选择报表！");
						return;
					}   				
			    	var OPTLItemDR=isSel.get('ID');			//关联的出入转报表项
			    	var OPTLItemDesc=isSel.get('ItemDesc');	
			    	//var RptItemRptDR					关联的出入转报表
 				

    				//if (detailRptItemWin==null) {
    					detailRptItemWin=new dhcwl.mripday.MripdayDetailRptItemCfg();
    				//}
    				detailRptItemWin.setSubWinParam(RptItemRptDR,OPTLItemDR,RptItemRptDesc,OPTLItemDesc);
    				detailRptItemWin.showWin(outThis);

     			}
    		}/*,{
   			text:'默认明细报表配置',
    			handler:function(){
    				//if (detailRptItemWin==null) {
    					detailRptItemWin=new dhcwl.mripday.MripdayDetailRptItemCfg();
    				//}
    				detailRptItemWin.setSubWinParam(RptItemRptDR,"",RptItemRptDesc,"");
    				detailRptItemWin.showWin(outThis);

     			}    		
    			
    		}*/]
	});	
	
	var ItemType="";
	var parentWin=null;
	
	var fromColumnModel = new Ext.grid.ColumnModel([
        {header:'编码',dataIndex:'ItemCode',sortable:true, width: 100, sortable: true,menuDisabled : true
        },{header:'描述',dataIndex:'ItemDesc',sortable:true, width: 180, sortable: true,menuDisabled : true}
        ]);
	var toColumnModel = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),
        {header:'编码',dataIndex:'ItemCode',sortable:true, width: 100, sortable: true,menuDisabled : true
        },{header:'描述',dataIndex:'ItemDesc',sortable:true, width: 180, sortable: true,menuDisabled : true}
        ]);        
        
    var fromStore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:'dhcwl/mripday/mripdayItemCfg.csp?action=searchItem&start=0&limit=21&onePage=1&ExceptRptDR='+RptItemRptDR}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'ID'},
            	{name: 'ItemCode'},
            	{name: 'ItemDesc'}
       		]
    	})
    });
    
    var toStore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=selRptItem&RptItemRptDR='+RptItemRptDR+'&start=0&limit=21&onePage=1'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'ID'},			
        		{name: 'ItemCode'},
            	{name: 'ItemDesc'}
       		]
    	})
    });    
    

    var fromGrid = new Ext.grid.GridPanel({
    	title:'可选统计项',
        height:350,
        width:370,
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
				var cursor=toGrid.getBottomToolbar().cursor ;
				var RptItemOPTLItemDR=selRec.get('ID');
				var RptItemDesc =selRec.get('ItemDesc');
				var RptItemCode=selRec.get('ItemCode');
				var RptItemOrder=toGrid.getStore().getTotalCount();
				
				act="?action=addRptItem&RptItemOPTLItemDR="+RptItemOPTLItemDR
				act=act+"&RptItemRptDR="+RptItemRptDR+"&RptItemCode="+RptItemCode+"&RptItemDesc="+RptItemDesc+"&cursor="+cursor;
	
				fromGrid.getStore().remove(selRec);
				toGrid.getStore().add(selRec);	        		
        		
        		updateRptItem(act);
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
    	title:'已选统计项',
        height:350,
        width:370,
        store: toStore,
        cm: toColumnModel,
        sm: new Ext.grid.RowSelectionModel({
        	singleSelect: true,
            listeners: {
 
            	
            }
        }),
        listeners:{
        	'contextmenu':function(event){
        		event.preventDefault();
        		quickMenu.showAt(event.getXY());
        	},
        	'rowdblclick' : function(th, rowIndex, e ) {
	        	var selRec=toGrid.getSelectionModel().getSelected();
				var RptItemOPTLItemDR=selRec.get('ID');				
				act="?action=delRptItem&RptItemOPTLItemDR="+RptItemOPTLItemDR;
				act=act+"&RptItemRptDR="+RptItemRptDR
				toGrid.getStore().remove(selRec);
				fromGrid.getStore().add(selRec);	
				updateRptItem(act);
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
    
   
    //fromStore.load({params:{start:0,limit:21}});	
	//toStore.load({params:{start:0,limit:21}});
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
	
    var dimSelPanel =new Ext.Panel({
    	//title:'报表配置',
    	layout:"table",
        layoutConfig:{columns:3},
        items: [fromGrid,actform,toGrid]

    });
    
    
	//	定义指标选取窗口
	var selItemWin = new Ext.Window({
		id:'selItemWin',
		title:'报表项配置',
        width:830,
		height:420,
		resizable:false,
		//closeAction:'hide',
		closeAction:'close',
		layout:'border',
		modal:true,
		id : 'dhcwl_mripday_rptItemWin',
		items:[{
			region:'center',
			items:dimSelPanel
		}],
        buttons: [
        	/*{
            text:'确认',
            handler:OnConfirm
        },
        */{
            text: '<span style="line-Height:1">关闭</span>',
            icon: '../images/uiimages/cancel.png',
            handler: OnCancel
        }],		
		listeners:{
			'close':function(p){
				/*
				 
				selItemWin.destroy();
				selItemWin.close();
				if(dhcwl_mripday_rptItemWin){
					dhcwl_mripday_rptItemWin=null;
				}		
				*/	
				parentWin.refresh();
				
				
			}

		}
	});

	function onBtnClick(btn){
		var act="";
   		partCalExp=btn.getId();  //add by chenyi.2017-03-17
   		//var pageSize=toGrid.getBottomToolbar().pageSize ;
   		var cursor=toGrid.getBottomToolbar().cursor ;
		if(partCalExp==">"){
			var selRec=fromGrid.getSelectionModel().getSelected();
			if (!selRec) {
				return;
			} 
			
			var RptItemOPTLItemDR=selRec.get('ID');
			var RptItemDesc =selRec.get('ItemDesc');
			var RptItemCode=selRec.get('ItemCode');
			var RptItemOrder=toGrid.getStore().getTotalCount();
			
			act="?action=addRptItem&RptItemOPTLItemDR="+RptItemOPTLItemDR
			act=act+"&RptItemRptDR="+RptItemRptDR+"&RptItemCode="+RptItemCode+"&RptItemDesc="+RptItemDesc+"&cursor="+cursor;

			fromGrid.getStore().remove(selRec);
			toGrid.getStore().add(selRec);	
			
		}else{
			var selRec=toGrid.getSelectionModel().getSelected();
			if (!selRec) {
				return;
			}   	
			if(partCalExp==" < "){
				
				var RptItemOPTLItemDR=selRec.get('ID');				
				act="?action=delRptItem&RptItemOPTLItemDR="+RptItemOPTLItemDR;
				act=act+"&RptItemRptDR="+RptItemRptDR
				toGrid.getStore().remove(selRec);
				fromGrid.getStore().add(selRec);				
				
			}else if(partCalExp=="∧"){
				var selIndex=toGrid.getStore().indexOf(selRec);
				if (selIndex<=0) return;
				toGrid.getStore().remove(selRec);
				toGrid.getStore().insert(selIndex-1,selRec);	
				toGrid.getSelectionModel().selectRow(selIndex-1);
				act="?action=updateItemOrder&RptItemRptDR="+RptItemRptDR+"&cursor="+cursor;
				
			}else if(partCalExp=="∨"){
				var selIndex=toGrid.getStore().indexOf(selRec);
				var cnt=toGrid.getStore().getCount();
				if (selIndex==cnt-1) return;
				toGrid.getStore().remove(selRec);
				toGrid.getStore().insert(selIndex+1,selRec);				
				toGrid.getSelectionModel().selectRow(selIndex+1);
				act="?action=updateItemOrder&RptItemRptDR="+RptItemRptDR+"&cursor="+cursor;
			}
		}
		
		//var count=toGrid.getStore().getTotalCount();
		updateRptItem(act);

    }    
    
    function updateRptItem(act){
    	
		var count=toGrid.getStore().getCount() ;		
		var aryRptItemOPTLItemDRs=[];
		var aryRptItemOrders=[];
		for(var i=0;i<=count-1;i++){
			var rec=toGrid.getStore().getAt(i);
			RptItemOPTLItemDR=rec.get('ID'); 
			aryRptItemOPTLItemDRs.push(RptItemOPTLItemDR);
		}

        var url=serviceUrl+act;
		dhcwl.mkpi.Util.ajaxExc(url,{aryRptItemOPTLItemDRs:aryRptItemOPTLItemDRs.join(",")},function(jsonData){
				if(jsonData.success==true && jsonData.tip=="ok"){
					if(jsonData.TipMSG) {
								Ext.MessageBox.alert("提示",jsonData.TipMSG);
								
								
					}
	
				}else{
					Ext.Msg.alert("提示","操作失败！");
				}
				refreshFrom();
				refreshTo();	
				},this);		    	
    }
	this.showWin=function(parent){
		parentWin=parent;
		var winTitle="当前编辑: ' "+RptItemRptDesc+" '报表";
		selItemWin.setTitle(winTitle);
		selItemWin.show();
		refreshFrom();
		refreshTo();


        fromStore.proxy=new Ext.data.HttpProxy({url:encodeURI('dhcwl/mripday/mripdayItemCfg.csp?action=searchItem&start=0&limit=21&onePage=1&ExceptRptDR='+RptItemRptDR)}); 
		toStore.proxy=new Ext.data.HttpProxy({url:encodeURI(serviceUrl+'?action=selRptItem&RptItemRptDR='+RptItemRptDR+'&start=0&limit=21&onePage=1')});
	}
	this.getParent=function(){
		return parentWin;
	}
	
	this.setSubWinParam=function(rptDR,rptCode,rptDesc){
		
		RptItemRptDR=rptDR;
		RptItemRptDesc=rptDesc;
		//RptItemRptCode=rptDesc;

	}
	function clearForm(){
		/*
    	var form=itemCustomCfgForm.getForm();
    	form.setValues({ItemType:'',CustomFun:''});
    	*/
    }
    
    function OnConfirm() {
    	OnCancel()
    	/*
    	var count=toGrid.getStore().getCount();
    	var dimPro="";
    	for(var index=0;index<=count-1;index++){
    		rec=toGrid.getStore().getAt(index);
    		dimCode=rec.get('dimCode');
    		if (dimPro!="") dimPro=dimPro+";";
    		dimPro=dimPro+dimCode;
    	}
    	var dimValue = typeform.getForm().findField('ItemType').getValue();
    	var rptCfgForm=parentWin.getForm();
    	rptCfgForm.getForm().findField('RptType').setValue(dimValue);
     	rptCfgForm.getForm().findField('RptDimProCode').setValue(dimPro);   	
		selItemWin.hide();
		*/
   		/*
        //1、判断是否有重复类型的数据。不能有重复类型的数据
    	var form=itemCustomCfgForm.getForm();
        var values=form.getValues(false);

        var formItemType=values.ItemType;
        var store=itemCustomCfgGrid.getStore();
        var count=store.getCount();
        
        for(i=0;i<=count-1;i++){
        	var gridItemType=store.getAt(i).get('ItemType');
        	if(gridItemType==formItemType){
	       		Ext.MessageBox.alert("提示","该类型统计项已存在，不能重复配置！");
	       		return;        		
        	}
        }
        //2、取到form中的值
       
        var itemType=values.ItemType;
        var customFun=values.CustomFun;

        
        if(!itemType||!customFun){
	       		Ext.MessageBox.alert("提示","统计项数据填写不完整！");
	       		return;                	       	
        }
		
        //3、写后台数据
 
        paraValues='OPTLItemDR='+OPTLItemDR+'&CustomFun='+customFun+'&ItemType='+formItemType;
        var url=serviceUrl+'?action=addCustomItem&'+paraValues
		dhcwl.mkpi.Util.ajaxExc(url,null,function(jsonData){
				if(jsonData.success==true && jsonData.tip=="ok"){
					//刷新grid
					Ext.MessageBox.alert("提示","操作成功！");
					store.reload();
				}else{
					Ext.Msg.alert("提示","操作失败！");
					}
					
				},this);	
        
        */

    }
    
    function refreshFrom(){
		fromGrid.getStore().proxy.setUrl(encodeURI('dhcwl/mripday/mripdayItemCfg.csp?action=searchItem&start=0&limit=21&onePage=1&ExceptRptDR='+RptItemRptDR));
		fromGrid.getStore().load({params:{start:0,limit:21}});
	    fromGrid.show();   
  	
    }
    
    function refreshTo(){
		toGrid.getStore().proxy.setUrl(encodeURI(serviceUrl+'?action=selRptItem&RptItemRptDR='+RptItemRptDR+'&start=0&limit=21&onePage=1'));
		toGrid.getStore().load({params:{start:0,limit:21}});
	    toGrid.show();   
  	
    }    
    
    function refreshFrom2(){
        fromStore=fromGrid.getStore();	
        toStore=toGrid.getStore();
        for(i=0;i<=toStore.getCount()-1;i++){
        	for(j=fromStore.getCount()-1;j>=0;j--){
        		if (toStore.getAt(i)=fromStore.getAt(j)){
        			fromStore.removeAt(j);
        		}
        	}
        	
        }
    }

    
    
    function OnCancel() {
		//selItemWin.hide();  
    	//parentWin.refresh();
    	selItemWin.close();
    }
	
	function OnShowKPIWin() {
		
		
	}
}