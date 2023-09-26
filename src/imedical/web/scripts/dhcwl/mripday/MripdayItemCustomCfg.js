(function(){
	Ext.ns("dhcwl.mripday.MripdayItemCustomCfg");
})();
///描述: 		自定义统计项配置页面
///编写者：		WZ
///编写日期: 		2014-11
dhcwl.mripday.MripdayItemCustomCfg=function(){
	var OPTLItemDR=null;
	var customItemDesc=null;
	var serviceUrl="dhcwl/mripday/mripdayItemCfg.csp";
	
	var quickMenu=new Ext.menu.Menu({
		boxMinWidth:150,
		ignoreParentClicks:true,
    	items:[
    		{
    			text:'删除',
    			handler:function(){
			 		
			 		var isSel=itemCustomCfgGrid.getSelectionModel().getSelected();
					if (!isSel) {
						Ext.MessageBox.alert("提示","请先选择统计项！");
						return;
					}  
					var rowID=isSel.get('RowID');
			    	var OPTLItemDR=isSel.get('OPTLItemDR');
			    	var itemType=isSel.get('ItemType');
			        paraValues='OPTLItemDR='+OPTLItemDR+'&ItemType='+itemType+'&RowID='+rowID;
			        var url=serviceUrl+'?action=delCustomItem&'+paraValues
					dhcwl.mkpi.Util.ajaxExc(url,null,function(jsonData){
							if(jsonData.success==true && jsonData.tip=="ok"){
								if(jsonData.rptName){
									Ext.MessageBox.alert("提示","下面的报表使用了这个统计项配置："+jsonData.rptName+"!请先删除这些报表！");
									return;
								}
								else{
									refresh();
									Ext.Msg.alert("提示","操作成功！");
								}
							}else{
								Ext.Msg.alert("提示","操作失败！");
								}
								
							},this);			    	
     			}
    		}]
	});	
	
	var columnModel = new Ext.grid.ColumnModel([
        {header:'ID',dataIndex:'RowID',sortable:true, width: 30, sortable: true,menuDisabled : true
        },{header:'统计项ID',dataIndex:'OPTLItemDR',sortable:true, width: 80, sortable: true,menuDisabled : true
        },{header:'类型',dataIndex:'ItemType', width: 160, sortable: true,menuDisabled : true        
        },{header:'取数方法',dataIndex:'CustomFun',sortable:true, width: 80, sortable: true,menuDisabled : true}
    ]);
    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=searchCustomItem&OPTLItemDR='+OPTLItemDR+'&start=0&limit=21&onePage=1'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'RowID'},
            	{name: 'OPTLItemDR'},
            	{name: 'ItemType'},
            	{name: 'CustomFun'}
       		]
    	})
    });
    var Record = Ext.data.Record.create([
    	{name: 'RowID',type:'string'},
    	{name: 'OPTLItemDR', type: 'string'},
    	{name: 'ItemType', type: 'string'},
    	{name: 'CustomFun', type: 'string'}
    ]);
    var itemCustomCfgGrid = new Ext.grid.GridPanel({
        height:120,
        store: store,
        cm: columnModel,
        sm: new Ext.grid.RowSelectionModel({
        	singleSelect: true,
            listeners: {
            	rowselect: function(sm, row, rec) {
             	}
            }
        }),
        listeners:{
        	'contextmenu':function(event){
        		event.preventDefault();
        		quickMenu.showAt(event.getXY());
        	}
        },
        bbar:new Ext.PagingToolbar({
            pageSize: 21,
            store: store,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录"
        })
    });

    
    itemTypeCboCus = new Ext.form.ComboBox({ 
            xtype: 'combo',
            width:120,
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
            name: 'itemType'
	});	

	
	
    var itemCustomCfgForm = new Ext.FormPanel({
        frame: true,
        height: 60,
        labelAlign: 'left',
        bodyStyle:'padding:5px',
        style: {
        	//"margin-left": "10px", // when you add custom margin in IE 6...
            "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },
          labelAlign : 'right',
		labelWidth : 75,
		//bodyStyle : 'padding:5px',
		layout : 'column',
		items:[
		{
			columnWidth : .33,
			layout : 'form',
			defaultType : 'textfield',
			items : [{
							fieldLabel : '描述',
				            xtype:'textfield',
				            name: 'ItemDesc',
				            disabled:true,
				            anchor:'100%'
											
					}]
			},{
			columnWidth : .33,
			layout : 'form',
			defaultType : 'textfield',
			anchor:'90',
			items : [{
							fieldLabel : '类型',
							xtype:'compositefield',
							items:[itemTypeCboCus],
				            //width:162,
				            anchor:'100%'			
						}]
		},{
			columnWidth : .33,
			layout : 'form',
			defaultType : 'textfield',
			items : [{
							fieldLabel : '自定义方法',
				            xtype:'textfield',
				            name: 'CustomFun',
				            anchor:'100%'
											
					}]
			}
		]
        /*
        layout: 'table',
        defaultConfig:{width:140},
        layoutConfig: {columns:6},
        items:[
		{
        	html: '描述：'
        },{
            xtype:'textfield',
            name: 'ItemDesc',
            disabled:true
        },{
            html:'类型：'
        }, itemTypeCbo,
        {
        	html: '自定义方法：'
        },{
            xtype:'textfield',
            name: 'CustomFun',
            width:160
        }]
        */
    });
    store.load({params:{start:0,limit:21}});	
	
 
	
	//	定义指标选取窗口
	var customWin = new Ext.Window({
		id:'customWin',
		title:'自定义类统计项配置',
        width:700,
		height:250,
		resizable:false,
		closeAction:'hide',
		layout:'border',
		modal:true,
		items:[{
			region:'north',
			height:60,
			layout:'fit',
			items:itemCustomCfgForm
		},{
			region:'center',
			items:itemCustomCfgGrid
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
				customWin.hide();
			}
		}
	});

	this.showWin=function(){
		customWin.show();
		clearForm();
		
		var form=itemCustomCfgForm.getForm();
    	form.setValues({ItemDesc:customItemDesc});
    	refresh();
	}
	
	this.setSubWinParam=function(itemDR,itemDesc){
		OPTLItemDR=itemDR;
		customItemDesc=itemDesc
		
	}
	function clearForm(){
    	var form=itemCustomCfgForm.getForm();
    	form.setValues({ItemType:'',CustomFun:''});
    }
    
    function OnConfirm() {
   	
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
					refresh()
				}else{
					Ext.Msg.alert("提示","操作失败！");
					}
					
				},this);	
    }
    
    function refresh(){
    	
		itemCustomCfgGrid.getStore().proxy.setUrl(encodeURI(serviceUrl+'?action=searchCustomItem&OPTLItemDR='+OPTLItemDR+'&start=0&limit=21&onePage=1'));
		itemCustomCfgGrid.getStore().load();
	    itemCustomCfgGrid.show();      	
    }
    function OnCancel() {
    	customWin.hide();
    }
	
	function OnShowKPIWin() {
		
		
	}
}