(function(){
	Ext.ns("dhcwl.dimrole.dimroleShow");
})();
//-------------------------------------------------------------维度角色维护界面----------------------------------------------------------
//-------------------------------------------------------------以下是维度维护-------------------------------------------------------
//Ext.onReady(function() {
dhcwl.dimrole.dimroleShow=function(){
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
        		refreshShow();
        	 }
         },
		 tbar: new Ext.Toolbar([{
            xtype:'label',
			text:'查找: '
        },{
			fieldLabel : '查找',
			xtype:'textfield',
			name: 'searchShow',
			id	: 'searchShow',
			enableKeyEvents: true,
			listeners :{
				'keypress':function(ele,event){
					searcheValue=Ext.get("searchShow").getValue();//获取搜索值
					if ((event.getKey() == event.ENTER)){
						//alert(searcheValue);
						store.proxy.setUrl(encodeURI(serviceUrl+'?action=getDimInfor&searcheValue='+searcheValue));
						store.load();
					}
				}
			}
		},'-',{
		   text: '<span style="line-Height:1">帮助</span>',
		   icon   : '../images/uiimages/help.png',
    	   handler:function(){
			   Helpwin.show();
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
					name: 'searchShow',
					id	: 'searchShow',
					enableKeyEvents: true,
					listeners :{
						'keypress':function(ele,event){
							searcheValue=Ext.get("searchShow").getValue();//获取搜索值
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
        }
    });
    
   
    //维度角色Form
	var dimRoleForm = new Ext.FormPanel({
		frame: true,
        height: 150,
        width:600,
        labelAlign: 'left',
        bodyStyle:'padding:5px',
        style: {
            "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },
        layout: 'table',
        defaultConfig:{width:130}
	});
    
	
    var dimRolePanel =new Ext.Panel ({ 
    	title:'维度角色展示',
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
			html:' <iframe scrolling="auto" frameborder="0" width="100%" height="100%" src="../scripts/dhcwl/dimrole/help/维度角色管理.htm"></iframe>'
		}
	})
    
    //this.refreshShow=function(){
	function refreshShow(){
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
	this.getDimroleShowCfgPanel=function(){
		return dimRolePanel;
	}
//})
}
