dhcwl.mkpi.ErrorCheck = function(){
	
	var lastParaValue="", funcPrototype="";
	
	var quickMenu=new Ext.menu.Menu({
		boxMinWidth:140,
		ignoreParentClicks:true,
		items:[{
				text:'数据指标展示',
				handler:function(){
					var errRow=errorCheckGrid.getSelectionModel().getSelected();
					if (!errRow) {
						Ext.MessageBox.alert("提示","请先选择一条记录！");
						return;
					}
					var errTxt=errRow.get("errorCheckInfor")
            		win.show();
            		Ext.getCmp('kpiCodes').setValue(errTxt);
				}
		}]
	});
	//		定义grid列模型
	var errorCheckColumnModel = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{header:'错误类型',dataIndex:'errorCheckType',sortable:true,width:15,menuDisabled : true,width:300},
		{header:'详细错误',dataIndex:'errorCheckInfor',sortable:true,menuDisabled : true,width:550}
	]);
	
	//		定义grid数据源
	var errorCheckStore = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:'dhcwl/kpi/kpiservice.csp?action=getErrorKpiInfor'}),
		reader:new Ext.data.JsonReader({
			totalProperty:'totalNum',
			root:'root',
			fields:[
				{name:'errorCheckType'},
				{name:'errorCheckInfor'}
			]
		})
	});
	
	var errorCheckRecord = new Ext.data.Record.create([
		{name:'errorCheckType',type:'string'},
		{name:'errorCheckInfor',type:'string'}
	]);
	
	//		定义grid样式
	var errorCheckGrid = new Ext.grid.GridPanel({
		id:'errorCheckGrid',
		store:errorCheckStore,
		height:550,
		frame:true,
		columnLines: true,
		viewConfig:{
			markDirty :false,
			forceFit: true
		},
		cm:errorCheckColumnModel,
		sm: new Ext.grid.RowSelectionModel({
        	singleSelect: true,
        	listeners: {
        		/*rowselect: function(sm, row, rec) {
            		var errTxt=rec.get("errorCheckInfor");
            		win.show();
            		Ext.getCmp('kpiCodes').setValue(errTxt);
            	}*/
        	}
        }),
        tbar:new Ext.Toolbar([{
			//text:'刷新',
			text: '<span style="line-Height:1">刷新</span>',
			icon: '../images/uiimages/reload2.png',
			handler:function(){
				errorCheckStore.load();
				errorCheckGrid.show();
			}
		}])
	});
	
	errorCheckGrid.on('contextmenu',function( e ){
		e.preventDefault();
		quickMenu.showAt(e.getXY());
	})
	
	var errorCheckPanel = new Ext.Panel({
		id:'errorCheckPanel',
		monitorResize:true,
		//layout:'table',
		//layoutConfig:{columns:1},
		//items:[{
			//height:550,
			layout:'fit',
			items:errorCheckGrid
		//}]
	});
	
	
	
	var setForm=new Ext.form.FormPanel({
    	frame: true,
        
        labelAlign: 'right',
        bodyStyle:'padding:15px',
        style: {
            "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },
        buttonAlign: 'center',
        buttons:[{
        	//text:'关闭',
        	text: '<span style="line-Height:1">关闭</span>',
        	icon: '../images/uiimages/cancel.png',
        	handler:function(){
        		win.hide(); 
        	}
        }],
        items:[{
        	fieldLabel:'错误信息',
			anchor:'95%',
			height:120,
			xtype: "textarea",
			id: "kpiCodes"
        }]
	})
	
	var win=new Ext.Window({
		title:'错误信息展示',
		closable:true,
		modal : true,
		width : 600,
		height: 250,
		resizable : false,
		plain : true,
		layout : 'fit',
		items : [setForm],
		listeners:{
			'close':function(){
				win.close();
				win.hide(); 
			}
    	}
	});
	
	this.InitPanelSize = function() {
		if ((!!errorCheckPanel)&&(!!errorCheckForm)&&(!!errorCheckGrid)) {
			var parentWidth = errorCheckPanel.getWidth();
			errorCheckForm.setWidth(parentWidth-10);
			errorCheckGrid.setWidth(parentWidth-10);
		}
	}
	
	this.GetErrorCheckPanel = function(){
		//errorCheckStore.load();
		//errorCheckGrid.show();
		return errorCheckPanel;
	}
	this.LoadErrorInfor=function(){
		errorCheckStore.load();
		errorCheckGrid.show();
	}
	
}