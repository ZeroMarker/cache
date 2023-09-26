(function(){
	Ext.ns("dhcwl.mripday.MripdayItemCalCfg");
})();
///描述: 		计算类统计项配置页面
///编写者：		WZ
///编写日期: 		2014-11
dhcwl.mripday.MripdayItemCalCfg=function(){
	var OPTLItemDR=null;
	var calItemDesc=null;
	var CalRowID=null;
	var CalExpOld=null;
	var serviceUrl="dhcwl/mripday/mripdayItemCfg.csp";
	
	var quickMenu=new Ext.menu.Menu({
		boxMinWidth:150,
		ignoreParentClicks:true,
    	items:[
    		{
    			text:'删除',
    			handler:function(){
			 		
			 		var isSel=itemCalCfgGrid.getSelectionModel().getSelected();
					if (!isSel) {
						Ext.MessageBox.alert("提示","请先选择统计项！");
						return;
					}  
					var rowID=isSel.get('RowID');
			    	var OPTLItemDR=isSel.get('OPTLItemDR');
			        paraValues='OPTLItemDR='+OPTLItemDR+'&RowID='+rowID;
			        var url=serviceUrl+'?action=delCalItem&'+paraValues
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
        {header:'ID',dataIndex:'ID',sortable:true, width: 50, sortable: true,menuDisabled : true
        },{header:'编码',dataIndex:'ItemCode',sortable:true, width: 120, sortable: true,menuDisabled : true
        },{header:'描述',dataIndex:'ItemDesc', width: 240, sortable: true,menuDisabled : true
        },{header:'统计项类别',dataIndex:'ItemType', width: 120, sortable: true,menuDisabled : true}
    ]);
    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=searchItem&start=0&limit=21&onePage=1'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'ID'},
            	{name: 'ItemCode'},
            	{name: 'ItemDesc'},
            	{name: 'ItemType'}
       		]
    	})
    });
    var Record = Ext.data.Record.create([
    	{name: 'ID',type:'integer'},
    	{name: 'ItemCode', type: 'string'},
        {name: 'ItemDesc', type: 'string'},
        {name: 'ItemType', type: 'string'}
    ]);
    var itemCalCfgGrid = new Ext.grid.GridPanel({
        height:330,
        store: store,
        cm: columnModel,
        sm: new Ext.grid.RowSelectionModel({
        	singleSelect: true,
            listeners: {
            }
        }),
        listeners:{
        	/*'contextmenu':function(event){
        		event.preventDefault();
        		quickMenu.showAt(event.getXY());
        	},*/
        	'rowdblclick': function(th, rowIndex, e) {
        		
        		var rec=th.getStore().getAt(rowIndex);
        		var ItemCode=rec.get("ItemCode");
            	var calExp=Ext.get('CalExp').getValue();
            	calExp=calExp+'<'+ItemCode+'>';
				var form=itemCalCfgForm.getForm();
				form.setValues({CalExp:calExp});                   	
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
    
    /*
    itemTypeCbo = new Ext.form.ComboBox({ 
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
	    		 	{typevalue:'Ward', typeDesc:'病区'}	            
		        ]
		    }),
            emptyText : '请选择', 
            name: 'itemType'
	});	
	*/
	
	
    var itemCalCfgForm = new Ext.FormPanel({
        frame: true,
        height: 60,
        labelAlign: 'right',
        bodyStyle:'padding:5px',
        style: {
             "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },
		labelWidth : 65,
		bodyStyle : 'padding:5px',
		layout : 'column',
		items:[
		{
			columnWidth : .4,
			layout : 'form',
			defaultType : 'textfield',
			items : [{
							fieldLabel : '描述',
				            xtype:'textfield',
				            name: 'ItemDesc',
				            disabled:true
											
					}]
			},{
			columnWidth : .5,
			layout : 'form',
			defaultType : 'textfield',
			anchor:'85%',
			items : [{
						fieldLabel : '运算关系',
			            xtype:'textfield',
			            name: 'CalExp',
			            id: 'CalExp',
			            width:250
				       //disabled:true				
					}]
		}
		]
        /*
        layout: 'table',
        defaultConfig:{width:140},
        layoutConfig: {columns:7},
        items:[
		{
        	html: '描述：'
        },{
            xtype:'textfield',
            name: 'ItemDesc',
            disabled:true
        },
        {
        	html: '运算关系：'
        },{
            xtype:'textfield',
            name: 'CalExp',
            width:250
        }]
        */
    });
    store.load({params:{start:0,limit:21}});	
	
    var itemCalBtns = new Ext.FormPanel({
        frame: true,
        height: 400,
        labelAlign: 'left',
        title: '运算符',
        bodyStyle:'padding:15px',
        
        style: {
        	//"margin-left": "10px", // when you add custom margin in IE 6...
            "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },
        layout: 'table',
        defaults: {        
        	width:40,
            height:40

        },
        layoutConfig: {columns:2},
        items:[
		{
            xtype:'button',
            text:'(',
            name: 'btn1',
            handler:onBtnClick
        },
		{
            xtype:'button',
            text:')',
            name: 'btn2',
            handler:onBtnClick
        },		{
            xtype:'button',
            text:'+',
            name: 'btn3',
            handler:onBtnClick
        },		{
            xtype:'button',
            text:'-',
            name: 'btn4',
            handler:onBtnClick
        },		{
            xtype:'button',
            text:'*',
            name: 'btn5',
            handler:onBtnClick
        },		{
            xtype:'button',
            text:'/',
            name: 'btn6',
            handler:onBtnClick
        },		{
            xtype:'button',
            text:'←',
            name: 'btn7',
            handler:function(){
            	var calExp=Ext.get('CalExp').getValue();
            	var length=calExp.length;
            	if (length<=0) return;
            	calExp=calExp.substr(0,length-1);
				var form=itemCalCfgForm.getForm();
				form.setValues({CalExp:calExp});            	
            }
        },		{
            xtype:'button',
            text:'C',
            name: 'btn8',
            handler:function(){
				var form=itemCalCfgForm.getForm();
				form.setValues({CalExp:''});
            }
        }]
    });    
    
    
    
    
 	var optPanel = new Ext.Panel({
 			region:'center',
            layout:'border',
            width:700,
            collapsible: false,
            items:[{
	            	region:'west',
	            	width: 340,
	            	items:itemCalCfgGrid
            	},
            	{
	            	region:'center',
	            	width: 150,
	            	items:itemCalBtns            		
            	}
            ]
        });
	
	//	定义指标选取窗口
	var calWin = new Ext.Window({
		id:'calWin',
		title:'计算类统计项配置',
        width:700,
		height:470,
		resizable:false,
		closeAction:'hide',
		modal:true,
		layout:'border',
				defaults: {
				    split: true,
				    border: false
				},
				items: [{
				    region: 'north',
				    height: 70,
					layout:'fit',
				    items:itemCalCfgForm
				},{

				    region:'west',
				    width: 550,
				    items:itemCalCfgGrid
				},{
				    region:'center',
				    width: 150,
				    items:itemCalBtns
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
				calWin.hide();
			}
		}
	});

	this.showWin=function(){
		calWin.show();
		clearForm();
		
		var form=itemCalCfgForm.getForm();
    	form.setValues({ItemDesc:calItemDesc});
       	paraValues='OPTLItemDR='+OPTLItemDR
        var url=serviceUrl+'?action=searchCalItem&'+paraValues
		dhcwl.mkpi.Util.ajaxExc(url,null,function(jsonData){
				if(jsonData.success==true && jsonData.tip=="ok"){
					CalExpOld=jsonData.CalExp;
					CalRowID=jsonData.CalRowID;
					form.setValues({CalExp:CalExpOld});
				}else{
					Ext.Msg.alert("提示","操作失败！");
					}
				},this);	  		

    	
	}
	
	this.setSubWinParam=function(itemDR,itemDesc){
		OPTLItemDR=itemDR;
		calItemDesc=itemDesc
		
	}
	function clearForm(){
    	var form=itemCalCfgForm.getForm();
    	form.setValues({CustomFun:''});
    }
    
    function OnConfirm() {
    	var form=itemCalCfgForm.getForm();
        var values=form.getValues(false);       
        var CalExp=values.CalExp;

        if(!CalExp){
	       		Ext.MessageBox.alert("提示","统计项数据填写不完整！");
	       		return;                	       	
        }
        
        paraValues="OPTLItemDR="+OPTLItemDR+"&CalRowID="+CalRowID;
        var url=serviceUrl+'?action=addCalItem&'+paraValues;
		//dhcwl.mkpi.Util.ajaxExc(url,null,function(jsonData){
        dhcwl.mkpi.Util.ajaxExc(url,
        	{'CalExp':CalExp}
			,function(jsonData){
				if(jsonData.success==true && jsonData.tip=="ok"){
					if(jsonData.rptName){
						Ext.MessageBox.alert("提示","下面的报表使用了统计项之前的配置："+jsonData.rptName+"  !请先删除这些报表！");
						return;
					}
					else{
						if (CalRowID=="") {
							CalRowID=jsonData.ROWID;
						}
						
						refresh();
						Ext.Msg.alert("提示","操作成功！");
					}
				}else{
					Ext.Msg.alert("提示","操作失败！");
					}
					
				},this);	
        
    }
    
    function refresh(){
		itemCalCfgGrid.getStore().proxy.setUrl(encodeURI(serviceUrl+'?action=searchCalItem&start=0&limit=21&onePage=1'));
		itemCalCfgGrid.getStore().load();
	    itemCalCfgGrid.show();      	
    }
    function OnCancel() {
    	calWin.hide();
    }
	
   function onBtnClick(btn){
   	   	if(!Ext.get('CalExp')) return ;
   		partCalExp=btn.getText();

    	var calExp=Ext.get('CalExp').getValue();
    	calExp=calExp+partCalExp;
		var form=itemCalCfgForm.getForm();
		form.setValues({CalExp:calExp});                 	
    }    

}