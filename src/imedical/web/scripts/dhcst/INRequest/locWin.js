selectReqLoc = function(Fn,req,transflag){
	var ReqLoc = new Ext.ux.LocComboBox({
		id:'ReqLoc',
		anchor:'95%',
		fieldLabel:'请求部门',
		emptyText:'请求部门...',
		groupId:gGroupId
	});
	ReqLoc.on('select', function(e) {
	    Ext.getCmp("ProLoc").setValue("");
	    Ext.getCmp("ProLoc").setRawValue("");
	});
	var ProLoc = new Ext.ux.LocComboBox({
		id:'ProLoc',
		fieldLabel:'供给部门',
		anchor:'95%',
		emptyText:'供给部门...',
		defaultLoc:{},
		relid:Ext.getCmp("ReqLoc").getValue(),
		protype:'RF',
		params : {relid:'ReqLoc'}
	});
	var confirmB = new Ext.Toolbar.Button({
		iconCls:'page_save',
		height:30,
		width:70,
		text:'确定',
		tooltip:'确定',
		handler:function(){
			var frLocId = Ext.getCmp('ProLoc').getValue();
			var toLocId = Ext.getCmp('ReqLoc').getValue();
			if(frLocId==""){
				alert("供给部门不能为空!")
				return;
				}
			if(toLocId==""){
				alert("请求部门不能为空!")
				return;
				}
			Fn(req,toLocId,frLocId,transflag);
			locWin.close();
		}
	});
	var closeB = new Ext.Toolbar.Button({
		iconCls:'page_delete',
		height:30,
		width:70,
		text:'关闭',
		tooltip:'关闭',
		handler:function(){
			locWin.close();
		}
	});
	var conPanel = new Ext.form.FormPanel({
		region:'north',
		labelwidth:0,
		autoScroll:true,
		labelAlign:'right',
		autoHeight: true, 
		frame:true,
		tbar:[confirmB,'-',closeB],
		layout:'fit',
		bodyStyle:'padding:5px',
		items:[{
			xtype:'fieldset',
			title:'请求和供给部门',
			//width:960,
			//height:73,
			frame:true,
			autoHeight:true,
			bodyStyle:'padding:0px;',
			labelWidth:60,
			items:[{
				columnWidth:.3,layout:'form',items:[ProLoc,ReqLoc]
			}]
		}]
	});
    var locWin = new Ext.Window({
		title:'选取请求和供给部门',
		width:500,	
		height:100,
		xtype:'fieldset',
		layout:'column',
		labelWidth:20,
		plain:true,
		modal:true,
		defaults: {border:false},
		//bodyStyle:'padding:5px;',
		//buttonAlign:'center',
		items:[{
		  columnWidth: 0.5,
	      xtype: 'fieldset',
	      items: ReqLoc
		},{
		  columnWidth: 0.5,
	      xtype: 'fieldset',
	      items: ProLoc
		}],
		//items:[{columnWidth:.3,layout:'form',items:[SupplyLoc,ReqLoc]}],
		buttons:[confirmB,'-',closeB]
	});
	//显示窗口
	locWin.show();
};