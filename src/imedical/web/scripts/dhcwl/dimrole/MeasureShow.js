(function(){
	Ext.ns("dhcwl.dimrole.MeasureShow");
})();
//-------------------------------------------------------------度量维护维护界面----------------------------------------------------------
//-------------------------------------------------------------以下是度量grid----------------------------------------------------------

dhcwl.dimrole.MeasureShow=function(){
	var serviceUrl="dhcwl/measuredimrole/measure.csp";
	var outThis=this;
	var columnModel = new Ext.grid.ColumnModel([
        {header:'ID',dataIndex:'meaID',sortable:true, width: 30, sortable: true,menuDisabled : true,hidden:true},
        {header:'编码',dataIndex:'meaCode', width: 80, sortable: true,menuDisabled : false},
        {header:'描述',dataIndex:'meaDesc', width: 100, sortable: true,menuDisabled : false},
        {header:'数据源',dataIndex:'meaDSource',width: 240, sortable: true,menuDisabled : false},
        {header:'计算数据项',dataIndex:'meaCalItem',sortable:true, width: 240, sortable: false,menuDisabled : true},
        {header:'统计口径',dataIndex:'meastaCal',sortable:true, width: 240, sortable: false,menuDisabled : true},
        {header:'维护时间',dataIndex:'meaDate',id:'meadataSource',sortable:true, width: 120, sortable: false,menuDisabled : true},
		{header:'创建人',dataIndex:'meaCreator',sortable:true, width: 100, sortable: false,menuDisabled : true}
    ]);
	
	var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=getMeasureInfor'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'meaID'},
            	{name: 'meaCode'},
            	{name: 'meaDesc'},
            	{name: 'meaDSource'},
            	{name: 'meaCalItem'},
            	{name: 'meastaCal'},
            	//{name: 'meaCreator'},
            	{name: 'meaDate'},
				{name: 'meaCreator'}
       		]
    	})
    });
    store.proxy.setUrl(encodeURI("dhcwl/measuredimrole/measure.csp?action=getMeasureInfor&onePage=1&start=0&limit=16"));
	store.load();
	
	var pageTool=new Ext.PagingToolbar({
        pageSize: 16,
        store: store,
        displayInfo: true,
        displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
        emptyMsg: "没有记录"
    });
	
	//度量grid
    var meaGrid = new Ext.grid.GridPanel({
        stripeRows:true,
        loadMask:true,
        height:450,        
        store: store,
		autoExpandColumn: 'meadataSource',
        cm: columnModel,
		bbar:pageTool,
        sm: new Ext.grid.RowSelectionModel({
        	singleSelect: true,
            listeners: {
            }
        }),
		tbar: new Ext.Toolbar([{
            xtype:'label',
			text:'查找: '
        },{
			xtype    :'textfield',
			name     :'MeaSearchShow',
			id     :'MeaSearchShow',
			enableKeyEvents: true,
			listeners :{
				'keypress':function(ele,event){
					if ((event.getKey() == event.ENTER)){
						var selNodes = tree.getSelectionModel().getSelectedNode();
						tree.getSelectionModel().unselect(selNodes);
						refresh();
					}
				}
			}
		},"-",{
			text: '<span style="line-Height:1">帮助</span>',
        	icon: '../images/uiimages/help.png',
            handler:function(){
				Helpwin.show();
            }
		}]),
        listeners :{
        	'click':function(ele,event){
        	 }
         }

    });
    //-------------------------------------------------------以下是度量form---------------------------------------
   
	
	var meaForm = new Ext.FormPanel({
        style: {
            "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },
        labelAlign: 'right',
		frame : true,
		labelWidth : 60,
		items:[{
			layout:'column',
			items:[{
				columnWidth:.50,
				layout:'form',
				defaultType:'textfield',
				defaults:{
					width:170
				},
				items:[{
					fieldLabel:'查找',
					name     :'addMeasureSearchshow',
					id     :'addMeasureSearchshow',
					enableKeyEvents: true,
					listeners :{
						'keypress':function(ele,event){
							if ((event.getKey() == event.ENTER)){
								refresh();
							}
						}
					}
				}]
			}]
		}]
	});
	

	//------------------------------------------------以下是整体界面的布局管理-----------------------------------------
    
	var meaPanel =new Ext.Panel ({ 
    	title:'度量展示',
		layout: {
			type: 'vbox',
			pack: 'start',
			align: 'stretch'
		},
		
    	defaults: { border :false},
        items: [{
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
					items:meaGrid
				}]
			}]
        }]
    });
	
    
	
	
	
	//------------------------------------------------------------------------以下是tree配置------------------------------------------------------------
	
	var tree = new Ext.tree.TreePanel({
		id:"cfgTreePane",
		autoScroll : true,
		animate : true,
		containerScroll : true,
		loader : new Ext.tree.TreeLoader({
		      dataUrl : serviceUrl+'?action=getMeasureTree'// OrgTreeJsonData.action就是要动态载入数据的请求地址，这里请求时会提交一个参数为node的值，值为root即new Tree.AsyncTreeNode()对象的id值
		        })
		});
	var root = new Ext.tree.AsyncTreeNode({
		text : '度量树',
		draggable : false,
		id : 'root'
	});
	tree.setRootNode(root);
	
	tree.on('afterrender', function(t){
		tree.getRootNode().expand(false,true,function(){
 		var nodeArray=tree.getRootNode();
        });  
 	});
	
	tree.on('click', function(node,e){
		Ext.get("MeaSearchShow").clean("dddd");
		var nodeID=node.attributes.id;
		store.proxy.setUrl(encodeURI("dhcwl/measuredimrole/measure.csp?action=getMeasureInfor&start=0&limit=16&onePage=1&nodeID="+nodeID));
		store.load();
	});

	
	var TaskGroupManagerPanel=new Ext.Panel({
	 	id:"TaskGroupManager",
		title:'度量展示',
		layout:'border',
		defaults: {
		    split: true
		},
		closable:true,  		
		border:false,
		items: [{
			id:"TaskGroupCfgPan",
		    region:'west',
			title: '度量树',
		    border: false,
		    split:true,
		    collapsible: true,
		    margins: '0 0 0 5',
	        width: 275,
	        minSize: 100,
	        maxSize: 500,
	        layout:'fit',
		    items:tree
		},{
		    region:'center',
		    layout:'fit',
		    items:[{
		    	id:"TaskCfgPan",
				border:false,
			    layout:'fit',
			    items:meaPanel
			    }]
		}]
		});

	
	
	//------------------------------------------------------------------以上是tree配置-----------------------------------------------------------------
    
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
			html:' <iframe scrolling="auto" frameborder="0" width="100%" height="100%" src="../scripts/dhcwl/dimrole/help/度量管理.htm"></iframe>'
		}
	 })
  
	function refresh(){
		var measureSearch=Ext.get('MeaSearchShow').getValue();
		store.proxy.setUrl(encodeURI("dhcwl/measuredimrole/measure.csp?action=getMeasureInfor&start=0&limit=16&onePage=1&measureSearch="+measureSearch));
		store.load();
    }
	
	this.getMeasureShowCfgPanel=function(){
		return TaskGroupManagerPanel;
	}
}  
//})
