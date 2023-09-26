(function(){
	Ext.ns("dhcwl.RptMgmt.ShowMain");
})();
///描述: 		查询对象
///编写者：		WZ
///编写日期: 		2016-11
dhcwl.RptMgmt.ShowMain=function(pObj){
	var serviceUrl="dhcwl/rptmgmt/showmain.csp";

	var actParam=new Object();

		//属性快捷菜单
	var propertyQuickMenu=new Ext.menu.Menu({
		//autoWidth:true,
		boxMinWidth:120,
		ignoreParentClicks:true,
		items:[
			{   			
				text:'显示明细数据',
				//icon   : '../scripts/dhcwl/BasicDataQuery/shared/icons/fam/flag_red.gif',  // Use a URL in the icon config

				handler:function(cmp,event){					
				var rec=showMainGrid.getSelectionModel().getSelected();
					if (!rec) {
						Ext.Msg.alert("提示","请选择一条数据！");
						return;
					}					


					var RaqName=rec.get("RaqName");
					var CSPName=rec.get("CSPName");
					var AuxiliaryMenuName=rec.get("AuxiliaryMenuName");
					var showTemplate=new dhcwl.RptMgmt.MgmtShowTemplate();
					showTemplate.showMgmtDataWin(RaqName,CSPName,AuxiliaryMenuName);

				}
			},{
				text:'显示链接文本',
				handler:function(cmp,event){					
				var rec=showMainGrid.getSelectionModel().getSelected();
					if (!rec) {
						Ext.Msg.alert("提示","请选择一条数据！");
						return;
					}					

					var RaqName=rec.get("RaqName");
					var CSPName=rec.get("CSPName");
					var AuxiliaryMenuName=rec.get("AuxiliaryMenuName");
					var showTemplate=new dhcwl.RptMgmt.MgmtShowTemplate();
					showTemplate.showHyperlinkWin(RaqName,CSPName,AuxiliaryMenuName);			
				}
			}
		]
	});		
	

	
    var store = new Ext.data.Store({
        //proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=getSavedMgmt'}),
		proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=getSavedMgmt2'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
				{name:'ID'},
				{name:'AdvUser'},
				{name:'AuxiliaryMenuName'},
				{name:'CSPName'},
				{name:'CreateDate'},
				{name:'Demo'},
				{name:'DepMaintainer'},
				{name:'Filter'},
				{name:'HisTableName'},
				{name:'KPIName'},
				{name:'MenuName'},
				{name:'ProMaintainer'},
				{name:'ProgramLogic'},
				{name:'QueryName'},
				{name:'RaqName'},
				{name:'RowColShow'},
				{name:'Spec'},
				{name:'UPdateDate'},
				{name:'UsedByDep'}
			]
    	})
    });
	
    // row expander
	/*
    var expander = new Ext.ux.grid.RowExpander({
        tpl : new Ext.Template(
			'<br>',
			'<p><b>主程序query:</b> {QueryName}</p><br>',
			'<p><b>统计口径:</b> {Spec}</p><br>',
			'<p><b>显示条件:</b> {RowColShow}</p><br>',
			'<p><b>指标:</b> {KPIName}</p><br>',
			'<p><b>业务表:</b> {HisTableName}</p><br>',
			'<p><b>逻辑说明:</b> {ProgramLogic}</p><br>',
            '<p><b>数据条件:</b> {Filter}</p><br>',
            '<p><b>备注:</b> {Demo}</p>'
        )
    });
	*/

		
	var columnModel = new Ext.grid.ColumnModel({
            defaults: {
                width: 100,
                sortable: false
            },
            columns: [
				new Ext.grid.RowNumberer(),
                //expander,	
				{header:'菜单名称',dataIndex:'MenuName', width: 150},
				{header:'raq名称',dataIndex:'RaqName', width: 150},
				{header:'CSP名称',dataIndex:'CSPName', width: 150},
				{header:'当前页面(标题)名称',dataIndex:'AuxiliaryMenuName', width: 150},
				//{header:'主程序query',dataIndex:'QueryName', width: 150},
				//{header:'统计口径',dataIndex:'Spec'},
				//{header:'业务表',dataIndex:'HisTableName'},
				//{header:'指标',dataIndex:'KPIName'},
				//{header:'数据条件',dataIndex:'Filter'},
				//{header:'显示条件',dataIndex:'RowColShow'},
				//{header:'逻辑说明',dataIndex:'ProgramLogic'},
				{header:'高级客户',dataIndex:'AdvUser', width: 80},
				{header:'项目工程师',dataIndex:'ProMaintainer', width: 80},
				{header:'开发工程师',dataIndex:'DepMaintainer', width: 80},
				//{header:'备注',dataIndex:'Demo'},
				{header:'日期',dataIndex:'CreateDate', width: 80},
				{header:'最后更新日期',dataIndex:'UPdateDate', width: 80},
				
				{header:'使用（科室）部门',dataIndex:'UsedByDep', width: 150}
				/*,
				{
					xtype: 'actioncolumn',
					header: '明细',
					width: 50,
					items: [{        
						icon   : '../scripts/dhcwl/BasicDataQuery/shared/icons/fam/flag_red.gif',  // Use a URL in the icon config
						handler: function(grid, rowIndex, colIndex) {
							var RaqName=store.getAt(rowIndex).get("RaqName");
							var CSPName=store.getAt(rowIndex).get("CSPName");
							var AuxiliaryMenuName=store.getAt(rowIndex).get("AuxiliaryMenuName");
							var showTemplate=new dhcwl.RptMgmt.MgmtShowTemplate();
							showTemplate.showMgmtDataWin(RaqName,CSPName,AuxiliaryMenuName);
						}
					}]
					
				},{
					xtype: 'actioncolumn',
					header: '链接文本',
					width: 50,
					items: [{        
						icon   : '../scripts/dhcwl/BasicDataQuery/shared/icons/fam/page_link.gif',  // Use a URL in the icon config
						handler: function(grid, rowIndex, colIndex) {
							var RaqName=store.getAt(rowIndex).get("RaqName");
							var CSPName=store.getAt(rowIndex).get("CSPName");
							var AuxiliaryMenuName=store.getAt(rowIndex).get("AuxiliaryMenuName");
							var showTemplate=new dhcwl.RptMgmt.MgmtShowTemplate();
							showTemplate.showHyperlinkWin(RaqName,CSPName,AuxiliaryMenuName);
						}
					}]
					
				}
				*/
			]
	});

    var showMainGrid = new Ext.grid.GridPanel({
        store: store,
        cm: columnModel,
		
		//plugins: expander,
        //collapsible: true,
        animCollapse: false,
        iconCls: 'icon-grid',
		
        viewConfig: {
            forceFit:true
        }, 		
		
        tbar:new Ext.Toolbar({
        	layout: 'hbox',
        	items : [		
			{
				text: '<span style="line-Height:1">增加</span>',
				icon   : '../images/uiimages/edit_add.png',	
				xtype:'button',
				handler:OnAdd
			},	
			"-",
			{
				text: '<span style="line-Height:1">修改</span>',
				icon   : '../images/uiimages/pencil.png',
				xtype:'button',
				name:'btnModify',
				disabled: true,
				handler:OnModify				
			},	
			"-",
			{
				text: '<span style="line-Height:1">对比</span>',
				icon   : '../images/uiimages/compare.png',
				xtype:'button',
				handler:OnCompare				
			},	
			"-",
			{
				text: '<span style="line-Height:1">导出</span>',
				icon   : '../images/uiimages/redo.png',
				xtype:'button',
				name:'btnModify',
				handler:OnExp				
			},	
			"-",
			{
				text: '<span style="line-Height:1">导入</span>',
				icon   : '../images/uiimages/importdata.png',
				xtype:'button',
				handler:OnImp				
			},{
				xtype:'spacer',
				flex:1
			},
			/*'菜单名称:',
			{
				name:'MenuName',
				//width: 100,	
				xtype:'textfield'	
			},
			"-",
			"Raq名称:",
			{
				name:'RaqName',
				xtype:'textfield'
			},			
			"-",
			"CSP名称:",
			{
				name:'CSPName',
				xtype:'textfield'
			},
			*/
			'查询值:',
			{
				name:'searchValue',
				//width: 100,	
				xtype:'textfield'	
			},
			"-",
			{
				text: '<span style="line-Height:1">查询</span>',
				icon   : '../images/uiimages/search.png',		
				xtype:'button',
				handler:OnSearch
			},	
			"-",
			{
				text: '<span style="line-Height:1">清空</span>',					
				icon   : '../images/uiimages/clearscreen.png',
				xtype:'button',
				handler:OnReset			
			}				
				
			]
		}),			
		
		
		
		//autoExpandColumn: 'descript',
		bbar: new Ext.PagingToolbar({
			pageSize:50,
			store:store,
			displayInfo:true,
			displayMsg:'{0}~{1}条,共 {2} 条',
			emptyMsg:'sorry,data not found!'
		})
    });	


	showMainGrid.on('contextmenu',function(e){
		e.preventDefault();
		propertyQuickMenu.showAt(e.getXY());		
	});	
	
	showMainGrid.getStore().reload({params:{start:0,limit:50}});
	
	showMainGrid.getSelectionModel().on('selectionchange', function(sm){
		var menuNameInx=showMainGrid.getTopToolbar().items.findIndex("name","btnModify");
		var MenuName=showMainGrid.getTopToolbar().items.itemAt(menuNameInx).setDisabled(sm.getCount() < 1);
    });	

		
	function OnAdd(){
		var addWin=new dhcwl.RptMgmt.AddMain();
		actParam.curAct='add';
		addWin.OnAddCallback=OnAddCallback;
		addWin.initParam(actParam);
		addWin.show();
		
	}
	
	function OnModify() {
		var addWin=new dhcwl.RptMgmt.AddMain();
		actParam.curAct='modify';
		var selRec=showMainGrid.getSelectionModel().getSelected();
		actParam.curSelRec=selRec
		addWin.OnUpdateCallback=OnUpdateCallback;
		addWin.initParam(actParam);
		addWin.show();		
	}
	
	function OnCompare() {
		
		var compareWin=new dhcwl.RptMgmt.Compare();
		compareWin.show();
		
	};
	
	function OnUpdateCallback() {
		showMainGrid.getStore().reload({params:{start:showMainGrid.getBottomToolbar().cursor,limit:50}});
	};
	
	function OnAddCallback() {
		showMainGrid.getBottomToolbar().moveLast() ;
	};
	
	var showMainPanel=new Ext.Panel({
		title:'展示查询数据',
		layout:'fit',	
		items: showMainGrid
		
    });

	function OnSearch() {
		/*
		//1、得到页面查询值
		var menuNameInx=showMainGrid.getTopToolbar().items.findIndex("name","MenuName");
		var MenuName=showMainGrid.getTopToolbar().items.itemAt(menuNameInx).getValue();
		var raqNameInx=showMainGrid.getTopToolbar().items.findIndex("name","RaqName");
		var RaqName=showMainGrid.getTopToolbar().items.itemAt(raqNameInx).getValue();
		var cSPNameInx=showMainGrid.getTopToolbar().items.findIndex("name","CSPName");
		var CSPName=showMainGrid.getTopToolbar().items.itemAt(cSPNameInx).getValue();
		
		//2、设置查询参数
		showMainGrid.getStore().setBaseParam("MenuName",MenuName);	
		showMainGrid.getStore().setBaseParam("RaqName",RaqName);	
		showMainGrid.getStore().setBaseParam("CSPName",CSPName);	
		showMainGrid.getStore().reload({params:{start:0,limit:50}});
		*/
		var searchValueInx=showMainGrid.getTopToolbar().items.findIndex("name","searchValue");
		var searchValue=showMainGrid.getTopToolbar().items.itemAt(searchValueInx).getValue();
		showMainGrid.getStore().setBaseParam("searchValue",searchValue);
		showMainGrid.getStore().reload({params:{start:0,limit:50}});		
	}
	
	function OnReset() {
		/*
		var menuNameInx=showMainGrid.getTopToolbar().items.findIndex("name","MenuName");
		var MenuName=showMainGrid.getTopToolbar().items.itemAt(menuNameInx).setValue("");
		var raqNameInx=showMainGrid.getTopToolbar().items.findIndex("name","RaqName");
		var RaqName=showMainGrid.getTopToolbar().items.itemAt(raqNameInx).setValue("");
		var cSPNameInx=showMainGrid.getTopToolbar().items.findIndex("name","CSPName");
		var CSPName=showMainGrid.getTopToolbar().items.itemAt(cSPNameInx).setValue("");
		
		//2、设置查询参数
		showMainGrid.getStore().setBaseParam("MenuName","");	
		showMainGrid.getStore().setBaseParam("RaqName","");	
		showMainGrid.getStore().setBaseParam("CSPName","");		
		*/
		var searchValueInx=showMainGrid.getTopToolbar().items.findIndex("name","searchValue");
		var searchValue=showMainGrid.getTopToolbar().items.itemAt(searchValueInx).setValue("");
		showMainGrid.getStore().setBaseParam("searchValue","");
		
	}
	
	function OnImp() {
		var impObj=new dhcwl.RptMgmt.Import();	
		impObj.OnImpCallback=OnAddCallback;
		impObj.showFileWin();		
	}
	
	
	function OnExp() {
		var expObj=new dhcwl.RptMgmt.Export();	
		expObj.showRangeWin();
	}
    this.getShowMainPanel=function(){
    	return showMainPanel;
    }  


}

