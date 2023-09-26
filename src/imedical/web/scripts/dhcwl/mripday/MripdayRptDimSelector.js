(function(){
	Ext.ns("dhcwl.mripday.MripdayRptDimSelector");
})();
///描述: 		报表纬度配置页面
///编写者：		WZ
///编写日期: 		2014-11
dhcwl.mripday.MripdayRptDimSelector=function(){
	var serviceUrl="dhcwl/mripday/mripdayRptCfg.csp";
	var ItemType="";
	var rptCode="";
	var parentWin=null;
	var initGrids=0;
	
	var fromColumnModel = new Ext.grid.ColumnModel([
        {header:'编码',dataIndex:'dimCode',sortable:true, width: 100, sortable: true,menuDisabled : true
        },{header:'描述',dataIndex:'dimDesc',sortable:true, width: 180, sortable: true,menuDisabled : true}
        ]);
	var toColumnModel = new Ext.grid.ColumnModel([
        {header:'编码',dataIndex:'dimCode',sortable:true, width: 100, sortable: true,menuDisabled : true
        },{header:'描述',dataIndex:'dimDesc',sortable:true, width: 180, sortable: true,menuDisabled : true}
        ]);        
        
    var fromStore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=selDimPro&ItemType='+ItemType}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
            	{name: 'dimCode'},
            	{name: 'dimDesc'}
       		]
    	}),
    	listeners:{
        	'load' : function(th,recordsoptions ) {
        		if (initGrids==0) return;
        		initGrids=0;
        		var rptCfgForm=parentWin.getForm();
		     	var dimPro=rptCfgForm.getForm().findField('RptDimProCode').getValue(); 		
		     	var aryDimPro=dimPro.split(";");

		     	for (i=0;i<=aryDimPro.length-1;i++){
		     		var recCnt=fromGrid.getStore().getCount();			     		
		     		for(j=recCnt-1;j>=0;j--){
		     			var rec=fromGrid.getStore().getAt(j);
		     			var dimCode=rec.get('dimCode');
		     			if (dimCode==aryDimPro[i]) {
				 			fromGrid.getStore().remove(rec);
							toGrid.getStore().add(rec);	      				
		     			}
		     		}
		     	}        		
        	}
    	}
    });
    
    var toStore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=selRptPro&rptCode='+rptCode+'&start=0&limit=21&onePage=1'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
            	{name: 'dimCode'},
            	{name: 'dimDesc'}
       		]
    	})
    });    
    

    var fromGrid = new Ext.grid.GridPanel({
        height:200,
        width:290,
        store: fromStore,
        cm: fromColumnModel,
        sm: new Ext.grid.RowSelectionModel({
        	singleSelect: true,
            listeners: {
            }
        }),
        listeners:{
        	'rowdblclick' : function(th, rowIndex, e ) {
       			var selRec=fromGrid.getStore().getAt(rowIndex);
				fromGrid.getStore().remove(selRec);
				toGrid.getStore().add(selRec);
        	}
        }
    });

    var toGrid = new Ext.grid.GridPanel({
        height:200,
        width:290,
        store: toStore,
        cm: fromColumnModel,
        sm: new Ext.grid.RowSelectionModel({
        	singleSelect: true,
            listeners: {
 
            	
            }
        }),
        listeners:{
       		'rowdblclick' : function(th,rowIndex, e ){
       			var selRec=toGrid.getStore().getAt(rowIndex);
				toGrid.getStore().remove(selRec);
				fromGrid.getStore().add(selRec);
       		}       	
        	
        }
    });
    
    itemTypeCboDim = new Ext.form.ComboBox({ 
            xtype: 'combo',
            mode:           'local',
            displayField:   'typeDesc',
            triggerAction:  'all',
            forceSelection: true,
            editable:       false,
            name:           'ItemType',
            hiddenName:     'ItemType',
            displayField:   'typeDesc',
            valueField:     'typevalue',
            store: new Ext.data.JsonStore({
		        fields : ['typevalue','typeDesc' ],
		        data   : [
 	    			{typevalue:'CTLOC', typeDesc:'科室'}, 
	    		 	{typevalue:'WARD', typeDesc:'病区'}	            
		        ]
		    }),
            emptyText : '请选择', 
            id: 'itemTypeID',
            listeners: {
             	'select' : function(combo,record,index ) {
            		var typevalue=record.get('typevalue');
            		refreshFrom(typevalue);
            		toGrid.getStore().removeAll();
            	}
            }
	});	

	
	
    var typeform = new Ext.FormPanel({
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
            html:'类型：'
        }, itemTypeCboDim
        ]
    });
    //store.load({params:{start:0,limit:21}});	
	
     var actform = new Ext.FormPanel({
     	width:70,
     	height:200,
		layout: {
		    type:'vbox',
		    padding:'5',
		    pack:'center',
		    align:'center'
		},
		defaults:{margins:'0 0 5 0'},
		items:[{
		    xtype:'button',
		  	//text: '>',
		    id: '>',
		  	icon: '../images/uiimages/moveright.png',
		  	width:40,
		  	handler:onBtnClick
		},{
		    xtype:'button',
		    //text: ' < ',
		    id: '<',
		    icon: '../images/uiimages/moveleft.png',
		  	width:40,
		  	handler:onBtnClick
		},{
		    xtype:'button',
		    icon: '../images/uiimages/moveup.png',
		    //text: '∧',
		    id:'∧',
		  	width:40,
		  	handler:onBtnClick
		},{
		    xtype:'button',
		    //text: '∨',
		    id: '∨',
		    icon: '../images/uiimages/movedown.png',
		    margins:'0',
		  	width:40,
		  	handler:onBtnClick
		}]

    });
	
    var dimSelPanel =new Ext.Panel({
    	layout:"table",
        layoutConfig:{columns:3},
        items: [fromGrid,actform,toGrid]

    });
    
    
	//	定义指标选取窗口
	var selDimWin = new Ext.Window({
		id:'selDimWin',
		title:'维度属性配置',
        width:670,
		height:320,
		resizable:false,
		layout:'border',
		modal:true,
		closeAction:'hide',
		items:[{
			region:'north',
			height:70,
			layout:'fit',
			items:typeform
		},{
			region:'center',
			items:dimSelPanel
		}],
        buttons: [{
            text: '<span style="line-Height:1">保存</span>',	
            icon: '../images/uiimages/filesave.png',
            handler:OnConfirm
        },{
            text: '<span style="line-Height:1">关闭</span>',
            icon: '../images/uiimages/cancel.png',
            handler: OnCancel
        }],		
		listeners:{
			'close':function(){
				selDimWin.hide();
			}
		}
	});

	function onBtnClick(btn){

   		//partCalExp=btn.getText();
   		partCalExp=btn.getId();
		if(partCalExp==">"){
			var selRec=fromGrid.getSelectionModel().getSelected();
			if (!selRec) {
				return;
			} 
			fromGrid.getStore().remove(selRec);
			toGrid.getStore().add(selRec);			
			
		}else{
			var selRec=toGrid.getSelectionModel().getSelected();
			if (!selRec) {
				return;
			}   	
			if(partCalExp=="<"){
				toGrid.getStore().remove(selRec);
				fromGrid.getStore().add(selRec);
			}else if(partCalExp=="∧"){
				var selIndex=toGrid.getStore().indexOf(selRec);
				if (selIndex<=0) return;
				toGrid.getStore().remove(selRec);
				toGrid.getStore().insert(selIndex-1,selRec);	
				toGrid.getSelectionModel().selectRow(selIndex-1);
				
			}else if(partCalExp=="∨"){
				var selIndex=toGrid.getStore().indexOf(selRec);
				var cnt=toGrid.getStore().getCount();
				if (selIndex==cnt-1) return;
				toGrid.getStore().remove(selRec);
				toGrid.getStore().insert(selIndex+1,selRec);				
				toGrid.getSelectionModel().selectRow(selIndex+1);
			}
		}
    }    
    
	this.showWin=function(parent){
		parentWin=parent;
		selDimWin.show();
		
    	var rptCfgForm=parentWin.getForm();
    	var dimValue=rptCfgForm.getForm().findField('RptType').getValue();
     	var dimPro=rptCfgForm.getForm().findField('RptDimProCode').getValue(); 		

     	toGrid.getStore().removeAll();

     	typeform.getForm().findField('ItemType').setValue(dimValue);
     	initGrids=1;
     	refreshFrom(dimValue);
		if (dimPro!="") Ext.getCmp('itemTypeID').disable()
		else Ext.getCmp('itemTypeID').enable();
	}
	
	this.setSubWinParam=function(itemDR,itemDesc){
		/*
		OPTLItemDR=itemDR;
		customItemDesc=itemDesc
		*/
	}

    
    function OnConfirm() {
    	
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
		selDimWin.hide();


    }
    
    function refreshFrom(formItemType){
	
		fromGrid.getStore().proxy.setUrl(encodeURI(serviceUrl+'?action=selDimPro&ItemType='+formItemType));
		fromGrid.getStore().load();
	    fromGrid.show();  
  	
    }
    function OnCancel() {
		selDimWin.hide();    	
    }
	
	function OnShowKPIWin() {
		
		
	}
}