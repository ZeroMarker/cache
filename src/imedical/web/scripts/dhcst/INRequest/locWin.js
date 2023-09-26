selectReqLoc = function(Fn,req,transflag){
	var ReqLoc = new Ext.ux.LocComboBox({
		id:'ReqLoc',
		anchor:'95%',
		fieldLabel:'������',
		emptyText:'������...',
		groupId:gGroupId
	});
	ReqLoc.on('select', function(e) {
	    Ext.getCmp("ProLoc").setValue("");
	    Ext.getCmp("ProLoc").setRawValue("");
	});
	var ProLoc = new Ext.ux.LocComboBox({
		id:'ProLoc',
		fieldLabel:'��������',
		anchor:'95%',
		emptyText:'��������...',
		defaultLoc:{},
		relid:Ext.getCmp("ReqLoc").getValue(),
		protype:'RF',
		params : {relid:'ReqLoc'}
	});
	var confirmB = new Ext.Toolbar.Button({
		iconCls:'page_save',
		height:30,
		width:70,
		text:'ȷ��',
		tooltip:'ȷ��',
		handler:function(){
			var frLocId = Ext.getCmp('ProLoc').getValue();
			var toLocId = Ext.getCmp('ReqLoc').getValue();
			if(frLocId==""){
				alert("�������Ų���Ϊ��!")
				return;
				}
			if(toLocId==""){
				alert("�����Ų���Ϊ��!")
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
		text:'�ر�',
		tooltip:'�ر�',
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
			title:'����͹�������',
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
		title:'ѡȡ����͹�������',
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
	//��ʾ����
	locWin.show();
};