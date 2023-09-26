(function(){
	Ext.ns("dhcwl.docappcfg.DockpiCalWindow");
})();
///描述: 		计算类统计项配置页面
///编写者：		WZ
///编写日期: 		2014-11
dhcwl.docappcfg.DockpiCalWindow=function(docClass,docType){
	this.mdocType = docType;
	this.mdocClass = docClass;
	//alert(docType);
	var OPTLItemDR=null;
	var calItemDesc=null;
	var CalRowID=null;
	var CalExpOld=null;
	var padocType = null;
	var serviceUrl="dhcwl/docappcfg/getdocfilterdef.csp";
	var serviceUrlt="dhcwl/docappcfg/savekpirel.csp";
	
	var columnModel = new Ext.grid.ColumnModel([
        {header:'ID',dataIndex:'ID',sortable:true, width: 50, sortable: true
        },{header:'医生指标代码',dataIndex:'MDocKPIDefCode', width: 100, sortable: true 
        },{header:'医生指标描述',dataIndex:'MDocKPIDefDesc', width: 100, sortable: true 
        },{header:'创建日期',dataIndex:'MDocKPIUpdateDate', width: 80, sortable: true
        },{header:'医生指标分类',dataIndex:'MDocKPIDefClass',width:70,sortable: true
        },{header:'医生指标类别',dataIndex:'MDocKPIDefCategory',width:70,sortable: true
        },{header:'医生指标归类',dataIndex:'MDocKPIDefType',width:80,sortable: true
        }
    ]);
     var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=mulSearchClass&MDocKPIDefClass='+encodeURI(this.mdocClass)+'&MDocKPIDefType='+encodeURI(this.mdocType)}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
            	{name: 'ID'},
            	{name: 'MDocKPIDefCode'},
            	{name: 'MDocKPIDefDesc'},
            	{name: 'MDocKPIUpdateDate'},
            	{name: 'MDocKPIDefClass'},
            	{name: 'MDocKPIDefCategory'},
            	{name: 'MDocKPIDefType'}
       		]
    	})
    });
     var Record= Ext.data.Record.create([
        {name: 'ID', type: 'int'},
        {name: 'MDocKPIDefCode', type: 'string'},
        {name: 'MDocKPIDefDesc', type: 'string'},
        {name: 'MDocKPIUpdateDate',type: 'string'},
        {name: 'MDocKPIDefClass', type: 'string'},
        {name: 'MDocKPIDefCategory', type: 'string'},
        {name: 'MDocKPIDefType', type: 'string'}
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
        	'rowdblclick': function(th, rowIndex, e) {
        		var rec=th.getStore().getAt(rowIndex)
        		var ItemCode=rec.get("MDocKPIDefCode");
            	var calExp=Ext.get('CalExp').getValue();
            	calExp=calExp+ItemCode;
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
    
    
    

	
	
    var itemCalCfgForm = new Ext.FormPanel({
        frame: true,
        height: 70,
        labelAlign: 'left',
        bodyStyle:'padding:5px',
        style: {
             "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },
        layout: 'table',
        defaultConfig:{width:140},
        layoutConfig: {columns:7},
        items:[
		{
        	html: '描述：'
        },{
            xtype:'textfield',
            name: 'ItemDesc',
            id: 'ItemDesc',
            disabled:true
        },
        {
        	html: '运算关系：'
        },{
            xtype:'textfield',
            name: 'CalExp',
            id: 'CalExp',
            width:250
        }]
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
		title:'计算类指标配置',
        width:720,
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
				    items:itemCalCfgForm
				},{

				    region:'west',
				    width: 570,
				    items:itemCalCfgGrid
				},{
				    region:'center',
				    width: 150,
				    items:itemCalBtns
				}],
        buttons: [{
            text:'确认',
            handler:OnConfirm
        },{
            text: '退出',
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
		store.proxy = new Ext.data.HttpProxy({
			url : serviceUrl+'?action=mulSearchClass&MDocKPIDefClass='+encodeURI(padocClass)+'&MDocKPIDefType='+encodeURI(padocType)
		});
		store.load();
		var form=itemCalCfgForm.getForm();
    	form.setValues({ItemDesc:mdocCode});
       	paraValues='mdocKpiId='+mdocKpiId;
        var url=serviceUrlt+'?action=searchCalItem&'+paraValues
		dhcwl.mkpi.Util.ajaxExc(url,null,function(jsonData){
				if(jsonData.success==true && jsonData.tip=="ok"){
					CalExpOld=jsonData.CalExp;
					if (CalExpOld!= "") {
						calWin.buttons[0].setText("修改");
						}else{
						calWin.buttons[0].setText("确认");	
							}
					form.setValues({CalExp:CalExpOld});
				}else{
					Ext.Msg.alert("提示","操作失败！");
					}
				},this);	 	
		
    	
	}
	
	this.setSubWinParam=function(docKpiId,docCode,docClass,docType){
		mdocKpiId=docKpiId;
		mdocCode=docCode;
		padocType = docType;
		padocClass = docClass;
	}
	function clearForm(){
    	var form=itemCalCfgForm.getForm();
    	form.setValues({CustomFun:''});
    }
    
    function OnConfirm() {
    	var form=itemCalCfgForm.getForm();
        var values=form.getValues(false);       
        var CalExp=values.CalExp;
	    var kpi = values.ItemDesc;
        if(!CalExp){
	       		Ext.MessageBox.alert("提示","统计项数据填写不完整！");
	       		return;                	       	
        }
        paraValues="mdocKpiId="+mdocKpiId+"&calExp="+encodeURIComponent(CalExp);
        if(this.text=="确认"){
        var url=serviceUrlt+'?action=addCalItem&'+paraValues;
        }else{
	    var url=serviceUrlt+'?action=updateCalItem&'+paraValues;    
	        }
		Ext.lib.Ajax.request(
			'GET',
			url,
			{success:function(response){
				var result = Ext.decode(response.responseText);
				Ext.Msg.alert('信息',result.msg);
				},failure:function(){}},
				form.getValues(true)
				
		);
        
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