(function(){
	Ext.ns("dhcwl.schema");
})();
dhcwl.schema.CalDef=function(pObj){
	Ext.QuickTips.init();
	var parentObj=pObj;
	var winOfThis=this;
	var treeNodeID=null;
	var serviceUrl="dhcwl/measuredimrole/measure.csp";
	var selStart=0;
	var selEnd=0;
	var useBy="";
	var availableItemStore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=getConfCal'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'ID'},
            	{name: 'name'},
            	{name: 'description'},
            	{name: 'type'}
       		]
    	})
    });
	
    var availableItemGrid = new Ext.grid.GridPanel({
		title:'数据项',
        store: availableItemStore,
        columns: [
			{header:'ID',dataIndex:'ID',sortable:true, width: 100, sortable: true,menuDisabled : true,hidden:true},
			{header:'名称',dataIndex:'name',sortable:true, width: 200, sortable: true,menuDisabled : true},
			{header:'描述',dataIndex:'description',sortable:true, width: 100, sortable: true,menuDisabled : true,id:'description'},
			{header:'类型',dataIndex:'type',sortable:true, width: 60, sortable: true,menuDisabled : true}
		],
		autoExpandColumn: 'description',
		tbar:new Ext.Toolbar({
			
		})
	})
	availableItemStore.load();

	var funTree = new Ext.tree.TreePanel({
			title:'函数',
			autoScroll : true,
			animate : true,
			containerScroll: true,
			rootVisible: false,
			//frame: true,
			root: {
				nodeType: 'async'
			},
			dataUrl: 'dhcwl/schema/schemacaldef.csp'
		});	
  
   	var availableTabs=new Ext.TabPanel({
        activeTab: 0,
		tabPosition: 'bottom',
        items:[
			availableItemGrid,
			funTree
			]
    });

	
	var lastInputString="00";
	var expTextArea=new Ext.form.TextArea({
		hideLabel: true,
		id: 'exp',
		//anchor: '100% -53',
		maskRe:/37|38|39|40/	//	/37|38|39|40|8|13|32/屏蔽方向左、上、右、下、退格、回车、空格外的其他按键
		
	});
	expTextArea.readOnly=true;

var schemaCalWin=new Ext.Window({
        width:900,
		height:600,
		modal:true,
		resizable:false,
		closeAction:'close',
		buttonAlign:'center',
		title:'表达式定义',
		layout:'border',
		defaults: {
			split: true
		},
		items: [
		{
			title: '可选项',
			region:'west',
			width: 400,
			minSize: 100,
			maxSize: 350,
			layout:'fit',
			items:[availableItemGrid]
		},{
			region: 'south',
			height: 150,
			minSize: 75,
			maxSize: 250,
			layout:'fit',
			items:expTextArea
		},{
			collapsible: false,
			region:'center'	,
			title:'表达式',
			//xtype: 'textarea',
			layout:'fit',
			items:funTree
		}],
		buttons: [
			{
				//text: '确定',
				text: '<span style="line-Height:1">确定</span>',
				icon   : '../images/uiimages/ok.png',
				handler: OnConfirm
			},{
				//text:'清空',
				text: '<span style="line-Height:1">清空</span>',					
				icon   : '../images/uiimages/clearscreen.png',
				handler:OnClear
			},{
				//text: '取消',
				text: '<span style="line-Height:1">取消</span>',
				icon   : '../images/uiimages/cancel.png',
				handler: OnCancel
			}
		]		
    });	

	schemaCalWin.on('close',function(){
		if (calWin){
			calWin.close();
			calWin.destroy();
		}
	})
	
	funTree.on('dblclick',function(node, e ) {
		if(node.isLeaf()) {
			var exp=Ext.getCmp("exp").getValue();
			if ((node.attributes.text=="...")||(node.attributes.text=="字符串")||(node.attributes.text=="数字")){
				handleCalInfor(node.attributes.text);
				return;
			}
			var functVal=" "+node.attributes.expV+ " ";
			exp=exp+functVal;
			Ext.getCmp("exp").setValue(exp);
			
			Ext.getCmp("exp").focus();			
		}
	});	     

	availableItemGrid.on('rowdblclick',function( th, rowIndex, e ) {
		var rec=availableItemGrid.getSelectionModel().getSelected();

		if (!rec) return;
		var itemName=" "+rec.get("name")+" ";
		var exp=Ext.getCmp("exp").getValue();
		exp=exp+itemName;
		Ext.getCmp("exp").setValue(exp);
		
		Ext.getCmp("exp").focus();
		
	});
	
	//双击自定义内容调用这个方法
	function handleCalInfor(infor){
		calWin.show();
		//form.setValues({infor:''});
		if (infor=="..."){
			calWin.setTitle("函数名填写");
		}
		if (infor=="字符串"){
			calWin.setTitle("字符串填写");
		}
		if (infor=="数字"){
			calWin.setTitle("数字填写");
		}
		
	}
	
	//------------------------------------------------------------以下自定义填写form信息----------------------------------------------------
	var form=new Ext.FormPanel({
		//title:"修改度量信息",
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
					fieldLabel :'内容填写',
					name	  :'infor',
					id	  :'infor'
				}]
			}]
		}],
		buttons:new Ext.Toolbar([
        {
			text: '<span style="line-Height:1">确定</span>',
        	icon: '../images/uiimages/filesave.png',
        	handler:function(){
				var exp=Ext.getCmp("exp").getValue();
				var value=Ext.get('infor').getValue();
				var node=funTree.getSelectionModel().getSelectedNode();
				if (node.attributes.text=="..."){
					var functVal=" "+value+"("+" ";
				}
				if (node.attributes.text=="字符串"){
					var functVal=" '"+value+"' ";
				}
				if (node.attributes.text=="数字"){
					var functVal=" "+value+" ";
				}
				exp=exp+functVal;
				Ext.getCmp("exp").setValue(exp);
				Ext.getCmp('infor').setValue("");
				calWin.hide();
				//return;
					
        	}
        },'-',{
			text: '<span style="line-Height:1">取消</span>',
        	icon: '../images/uiimages/undo.png',
        	handler:function(){
				Ext.getCmp('infor').setValue("");
				calWin.hide();
        	}
        }])
	});
	
	var calWin=new Ext.Window({
		title:'自定义填写',
		id   :'calWin',
    	layout :'fit',
		closable:true, 
		closeAction: "hide",
		//border:false,
    	width  :300,
    	height :200,
    	items  :[form],
		listeners:{
			'close':function(){
			}
    	}
    });
	//------------------------------------------------------------以下自定义填写form信息----------------------------------------------------
	
	function OnConfirm()
	{
		parentObj.setCalF(Ext.getCmp("exp").getValue());
		winOfThis.getWin().close();
		return;		
	}
	function OnClear()
	{
		Ext.getCmp("exp").setValue("");
	}
	function OnCancel()
	{
		winOfThis.getWin().close();
		return;		
	}
	this.setParentObj=function(parentObj){
		this.parentObj=parentObj;
	}   
	   
   this.show=function()
   {
	   schemaCalWin.show();
   }
	
	this.getWin=function()
	{
		return schemaCalWin;
	}

 }