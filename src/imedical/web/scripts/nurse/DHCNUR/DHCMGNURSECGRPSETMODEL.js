var DHCMGSecGrpT101=new Ext.data.Store({
	proxy:new Ext.data.HttpProxy({
		url:"../csp/dhc.nurse.ext.common.getdata.csp"
	}),
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results',
		fields:[{
			'name':'Group',
			'mapping':'Group'
		}, {
			'name':'ID',
			'mapping':'ID'
		}]
	}),
	baseParams:{
		className:'web.DHCMgNurChildPage',
		methodName:'SSGROUP',
		type:'Query'
	}
});

Ext.onReady(function(){
	var fheight=document.body.offsetHeight;
	var fwidth=document.body.offsetWidth;
	var grid1=new Ext.grid.GridPanel({
		id:'mygrid',
		name:'mygrid',
		title:'安全组',
		loadMask:true,
		clicksToEdit:1,
		stripeRows:true,
		height:fheight,
		width:267,
		tbar:[{
			id:'mygridbut1',
			text:'新建'
		},{
			id:'mygridbut2',
			text:'修改'
		}],
		store:DHCMGSecGrpT101,
		colModel:new Ext.grid.ColumnModel({
			columns:[{
				header:'安全组',
				dataIndex:'Group',
				width:272,
				editor:new Ext.grid.GridEditor(new Ext.form.TextField({
					readOnly:false
				}))
			},{
				header:'RowId',
				dataIndex:'ID',
				width:10,
				editor:new Ext.grid.GridEditor(new Ext.form.TextField({
					readOnly:false
				}))
			}],
			rows:[],
			defaultSortable:false
		}),
		enableColumnMove:false,
		viewConfig:{
			forceFit:false
		},
		plugins : [new Ext.ux.plugins.GroupHeaderGrid()],
		sm : new Ext.grid.RowSelectionModel({
			singleSelect : false
		}),
		bbar : new Ext.PagingToolbar({
			store : DHCMGSecGrpT101,
			displayInfo : true,
			pageSize : 10
		})
	});
	var gridpanel=new Ext.Panel({
		id : 'mygridpl',
		name : 'mygrid',
		tabIndex : '0',
		x : 0,y : 0,
		height : fheight,
		width : 267,
		layout : 'fit',
		border : false,
		items:[grid1]
	});
	//
	var itmmould = cspRunServerMethod(getmouldext1);

	var centeritem = new Ext.Panel({
		// 自动收缩按钮
		//collapsible : true,
		x:267,y:0,
		border:false,
		width:225,
		height:fheight,
		layout:'accordion',
		extraCls:'roomtypegridbbar',
		layoutConfig:{
			animate:true
		},
		region:'center',
		items:eval(itmmould)
	});
	new Ext.form.FormPanel({
		height:600,
		width: 800,
		id:'gform',
		autoScroll:true,
		layout: 'absolute',
		items:centeritem,
		renderTo: Ext.getBody()
	});
	var fm=Ext.getCmp('gform');
	fm.setHeight(fheight);
	fm.setWidth(fwidth);
  fm.add(gridpanel);
	var mould=cspRunServerMethod(getmould1);
	var mouldarr = mould.split('^')
	for (i = 0; i < mouldarr.length; i++) {
		itm = mouldarr[i].split('|');
		if (mouldarr[i] == "")
			continue;
		var root = new Ext.tree.AsyncTreeNode({	});
		var tree1 = new Ext.tree.TreePanel({
			renderTo : itm[0],
			id:itm[0]+"1",
			root : root,// 定位到根节点
			autoScroll: true,
			height:285,
		  containerScroll: true,
			animate : true,// 开启动画效果
			enableDD : true,// 不允许子节点拖动
			border : true,// 没有边框
			rootVisible : true,// 设为false将隐藏根节点，很多情况下，我们选择隐藏根节点增加美观性
			loader : new Ext.tree.TreeLoader({
				dataUrl:"../DHCMGNUR.MgNurSecPageSet.cls?mouldid="+ itm[1]
			})
		});
	  tree1.expandAll();
    tree1.on("click", function(node) {
			if ((!arguments[1]) != true) {
				node.getUI().toggleCheck();
			}
			var childNodeArray = node.childNodes;
			if (childNodeArray.length == 0) {
				return;
			}
			for (var i = 0; i < childNodeArray.length; i++) {
				childNodeArray[i].getUI().toggleCheck(node.getUI().isChecked());
				arguments.callee(childNodeArray[i], false)
			}
		})
	}
	BodyLoadHandler();
})