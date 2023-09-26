(function(){
	Ext.ns("dhcwl.vermanagement.formload");
})();

Ext.onReady(function() {
    var serviceUrl="dhcwl/VerManagement/vmservice.csp";
	var outThis=this
	var choicesubgrpId=""
	var hisID=""
	
   var quickMenu=new Ext.menu.Menu({
	boxMinWidth:150,
    ignoreParentClicks:true,
        items:[
    	    {
    			text:'版本历史',
    			handler:function(cmp,event){
    				var sm = vmtypeGrid.getSelectionModel();
                    var recordhis= sm.getSelected();              	
                    hisID=recordhis.get('vmDr');
					var showvminfo = new dhcwl.vermanagement.showvninfo(hisID);
					showvminfo.wvinfoWin();
    			}
    		}
    	]
	})
	
	var columnModel = new Ext.grid.ColumnModel([
        {header:'ID',dataIndex:'vmDr',sortable:true, width: 30, sortable: true,menuDisabled : true},
        {header:'产品名称',dataIndex:'vmdName',sortable:true, width: 80, sortable: true,menuDisabled : true},
        {header:'产品版本',dataIndex:'vmdCode', width: 60, sortable: true,menuDisabled : true},
        {header:'产品作者',dataIndex:'vmdTSName', width: 60, sortable: true,menuDisabled : true},
        {header:'发布日期',dataIndex:'vmdUpDate', width: 80, sortable: true,menuDisabled : true},
		{header:'安装日期',dataIndex:'vmdInstallDate', width: 80, sortable: true,menuDisabled : true},
		{header:'安装时间',dataIndex:'vmdInstallTime', width: 80, sortable: true,menuDisabled : true},
		{header:'备注',dataIndex:'vmdRemarks', width: 900, sortable: true,menuDisabled : true}
    ]);

    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=vmSearch'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'vmDr'},
            	{name: 'vmdName'},
				{name: 'vmdCode'},
            	{name: 'vmdTSName'},
            	{name: 'vmdUpDate'},
            	{name: 'vmdInstallDate'},
				{name: 'vmdInstallTime'},
				{name: 'vmdRemarks'}
       		]
    	})
    });
    store.load()
    
    var vmgroupForm =new Ext.FormPanel();
    var vmtypeGrid = new Ext.grid.GridPanel({
        stripeRows:true,
        loadMask:true,
        height:480,
        store: store,
        cm: columnModel,
        sm: new Ext.grid.RowSelectionModel({
        	singleSelect: true,
            listeners: {
            	rowselect: function(sm, row, rec) {
				    var id=rec.get("ID");
            		var form=vmgroupForm.getForm();
                	form.loadRecord(rec);
                	form.setValues({ID:id});
             	}
            }
        }),
        listeners:{
        	'contextmenu':function(event){
        		event.preventDefault();
        	    quickMenu.showAt(event.getXY());
        	}
        }
		});
    var mainWin=new Ext.Window({
	                renderTo:Ext.getbody,
					resizable:false,
					maximized :true, 
					maxinizable:false,
					closable:false,
	                width:570,
					height:500,
					layout:'fit',
                    title:'版本管理V1.0.0',
					items:vmtypeGrid
					});
					mainWin.show();     
					})
					/*
	var formPanel = new Ext.FormPanel({
          id: 'vali',
          labelWidth: 75, // label settings here cascade unless overridden
          frame:true,
          bodyStyle:'padding:5px 5px 0',
          width: 350,
          defaults: {width: 230},
          defaultType: 'textfield',
          items: [{id: 'username',fieldLabel: '用户名',name:'username',allowBlank: false,blankText: '必填'},
          {id: 'password', fieldLabel: '密 码',name:'password'}]
         })	
    var win = new Ext.Window({ 
           renderTo:Ext.getbody,
           title:'请登录', 
           width:380,
           autoHeight: 'true',
           resizable: false,
           modal:true,
           closeAction: 'hide',
           buttonAlign:'center',
           items:formPanel,
           buttons:[{text: '确定',handler: function(){
		             var username=Ext.getCmp('username').getValue();	
                     var password=Ext.getCmp('password').getValue();
                     var codeflag = tkMakeServerCall('DHCWL.VerManagement.LandingQuery','CheckPassWord',username,password);
					 if (codeflag =='1'){
					 win.hide();
					 mainWin.show();};					  
					 else
					 {Ext.Msg.show({title : '温馨提示',msg : '账户或密码错误'})}
					 }},{text: '取消',handler: function(){win.hide();}},
                      {text: '重置',handler: function(){
                       Ext.getCmp('username').setValue("");
                       Ext.getCmp('password').setValue("");
                      }}]});
					  win.show(); */
					  

