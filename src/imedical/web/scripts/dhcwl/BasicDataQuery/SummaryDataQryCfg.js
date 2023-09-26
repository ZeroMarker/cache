(function(){
	Ext.ns("dhcwl.BDQ.SummaryDataQryCfg");
})();
///描述: 		查询对象
///编写者：		WZ
///编写日期: 		2016-11
dhcwl.BDQ.SummaryDataQryCfg=function(pObj){
	var serviceUrl="dhcwl/basedataquery/dataqrycfg.csp";
	var outThis=this;
	var parentObj=pObj;
	var rptName="";
	var rptID="";
	var comboQryObj=""
	//Ext.QuickTips.init();
	
	var tree = new Ext.tree.TreePanel({
		ddGroup: 'treeNodeDDGroup',
		enableDrag:true,
		border:false,
		autoScroll : true,
		animate : true,
		containerScroll : true,
		loader : new Ext.tree.TreeLoader({
		      dataUrl : "dhcwl/basedataquery/dataqrycfg.csp?action=getSumItemNode"
		        }),
		tbar:new Ext.Toolbar({
        	items : [		
			"查询对象：",
			{
				allowBlank:true,
				emptyText:'请选择',
				//msgTarget: 'side',	
				xtype:'combo',
				id:'SumComboQryObjName',
				triggerAction:  'all',
				editable: false,
				displayField:   'Descript',
				valueField:     'Name',
				store:new Ext.data.Store({
						proxy: new Ext.data.HttpProxy({url:'dhcwl/basedataquery/queryobj.csp?action=getBDQObj'}),
						reader: new Ext.data.JsonReader({
							totalProperty: 'totalNum',
							root: 'root',
							fields:[
								{name: 'Descript'},
								{name: 'Name'}
							]
						})
					}),	
				mode:           'remote',
				//forceSelection: false,			
                typeAhead: true,
                // transform the data already specified in html
                listClass: 'x-combo-list-small'	,								
				listeners:{
					'beforeselect':function(combo,record,index) {
						var oldQryObjName=Ext.getCmp("SumComboQryObjName").getValue();
						var qryObjName=record.get('Name');
						if (oldQryObjName!=qryObjName) {
							/*
							rootNode=tree.getRootNode();
							rootNode.remove();
							var root = new Ext.tree.AsyncTreeNode({
									text : 'root',
									draggable : false,
									id : 'root',//默认的node值：?node=-100
									type:'dir'
								  });
							tree.setRootNode(root);		
							root.loader = new Ext.tree.TreeLoader({
								dataUrl:'dhcwl/basedataquery/dataqrycfg.csp?action=getSumItemNode&QryObjName='+qryObjName
							});	

							if (qryObjName.indexOf("]")>=0 ) {
								qryObjName=qryObjName.split("[")[1];
								qryObjName=qryObjName.split("]")[0];	
							}	
							*/
							refreshTree(qryObjName);
							
							
							comboDateItem.setValue("");
							comboDateItem.getStore().setBaseParam("qryObjName",qryObjName);	//更新日期区间过滤
							comboDateItem.getStore().reload();
							delete comboDateItem.lastQuery;

							//行显示项
							rowStore.removeAll();
							//列显示项
							colStore.removeAll();
							//列显示项
							measureStore.removeAll();
							//过滤
							filterStore.removeAll();
							//数据显示
							var gridContainer=Ext.getCmp("summaryViewGridID");
							var iframe = gridContainer.el.dom.getElementsByTagName("iframe")[0];
							iframe.src = 'dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-BaseDataQry2.raq';
							
							
							rptName="";
							SummaryDataQryCfgPanel.setTitle("交叉表格显示");
								
							
						}			
					}
					/*,
					'expand':function(combo) {
					},
					'collapse':function(combo) {		
					},
					'afterrender':function(combo) {
							Ext.getCmp("SumComboQryObjName").getStore().reload();
							Ext.getCmp("SumComboQryObjName").focus();
							setTimeout('Ext.getCmp("SumComboQryObjName").expand();',1);
							setTimeout('Ext.getCmp("SumComboQryObjName").collapse();',100);
					}
					*/
				}	
			}]	
		}),				
				
		listeners:{

			'beforeload':function(node){
				if (node.id=="root") return;
				if (node.id=="dimChild") {
					var qryObjName=Ext.getCmp("SumComboQryObjName").getValue();
					
					if (qryObjName.indexOf("]")>=0 ) {
						qryObjName=qryObjName.split("[")[1];
						qryObjName=qryObjName.split("]")[0];	
					}					
					node.loader = new Ext.tree.TreeLoader({
						dataUrl:'dhcwl/basedataquery/dataqrycfg.csp?action=getSumItemNode&itemType=dim&QryObjName='+qryObjName
					});
				}else if (node.id=="measureChild"){
					var qryObjName=Ext.getCmp("SumComboQryObjName").getValue();
					if (qryObjName.indexOf("]")>=0 ) {
						qryObjName=qryObjName.split("[")[1];
						qryObjName=qryObjName.split("]")[0];	
					}					
					
					node.loader = new Ext.tree.TreeLoader({
						dataUrl:'dhcwl/basedataquery/dataqrycfg.csp?action=getSumItemNode&itemType=measure&QryObjName='+qryObjName
					});
				}else{
					node.loader = new Ext.tree.TreeLoader({
						dataUrl:'dhcwl/basedataquery/dataqrycfg.csp?action=getPropertyNode&ItemID='+node.id
					});					
				}
			}

		}
		});

	var root = new Ext.tree.AsyncTreeNode({
			text : 'root',
			draggable : false,
			id : 'root',//默认的node值：?node=-100
			type:'dir'
		  });


	tree.setRootNode(root);	
	
	var rowStoreData = [];	
	var colStoreData = [];	
	var measureStoreData = [];	
	var filterStoreData = [];	
    var rowStore = new Ext.data.ArrayStore({
		autoDestroy: true,
        fields: [
           {name: 'name'},
           {name: 'descript'},
		   {name:'itemObj'},
		   {name:'inPam'}
        ]
    });	
	
	var colStore = new Ext.data.ArrayStore({
		autoDestroy: true,
        fields: [
           {name: 'name'},
           {name: 'descript'},
		   {name:'itemObj'},
		   {name:'inPam'}
        ]
    });	
	
	var measureStore = new Ext.data.ArrayStore({
		autoDestroy: true,
        fields: [
           {name: 'name'},
           {name: 'descript'},
		   {name:'itemObj'}
        ]
    });	

    var filterStore = new Ext.data.ArrayStore({
		autoDestroy: true,
        fields: [
           {name: 'name'},
           {name: 'descript'},
		   {name: 'logicalOperators'},
		   {name: 'filterV'},
		   {name:'itemObj'},
		   {name:'inPam'}
        ]
    });	
	
	var rowCm = new Ext.grid.ColumnModel({
        columns: [{
            header: '名称',
            dataIndex: 'name',
            width: 130
        }, {
            header: '描述',
			id:'rowdescript',		//这个ID必须要，用在grid的autoExpandColumn中
            dataIndex: 'descript',
            width: 220
        }, {
            header: '入参',
            dataIndex: 'inPam',
            width: 50,
			editor: new Ext.form.TextField({allowBlank: true})
        },{
			xtype: 'actioncolumn',
			header: '删除',
			width: 50,
			items: [{        
				//icon   : '../scripts/dhcwl/BasicDataQuery/shared/icons/fam/delete.gif',  // Use a URL in the icon config
				icon   : '../images/uiimages/edit_remove.png',
				tooltip: '移除',
				handler: function(grid, rowIndex, colIndex) {
					grid.getStore().removeAt(rowIndex);
				}
			}]
			
		}]
	})

	var colCm = new Ext.grid.ColumnModel({
        columns: [{
            header: '名称',
            dataIndex: 'name',
            width: 130
        }, {
            header: '描述',
			id:'coldescript',		//这个ID必须要，用在grid的autoExpandColumn中
            dataIndex: 'descript',
            width: 220
        }, {
            header: '入参',
            dataIndex: 'inPam',
            width: 50,
			editor: new Ext.form.TextField({allowBlank: true})
        },{
			xtype: 'actioncolumn',
			header: '删除',
			width: 50,
			items: [{        
				//icon   : '../scripts/dhcwl/BasicDataQuery/shared/icons/fam/delete.gif',  // Use a URL in the icon config
				icon   : '../images/uiimages/edit_remove.png',
				tooltip: '移除',
				handler: function(grid, rowIndex, colIndex) {
					grid.getStore().removeAt(rowIndex);
				}
			}]
			
		}]
	})		

	var measureCm = new Ext.grid.ColumnModel({
        columns: [{
            header: '名称',
            dataIndex: 'name',
            width: 130
        }, {
            header: '描述',
			id:'measuredescript',		//这个ID必须要，用在grid的autoExpandColumn中
            dataIndex: 'descript',
            width: 220
        },{
			xtype: 'actioncolumn',
			header: '删除',
			width: 50,
			items: [{        
				//icon   : '../scripts/dhcwl/BasicDataQuery/shared/icons/fam/delete.gif',  // Use a URL in the icon config
				icon   : '../images/uiimages/edit_remove.png',
				tooltip: '移除',
				handler: function(grid, rowIndex, colIndex) {
					grid.getStore().removeAt(rowIndex);
				}
			}]
			
		}]
	})	

	var filterCm = new Ext.grid.ColumnModel({
        columns: [{
            header: '名称',
            dataIndex: 'name',
            width: 100
        }, {
            header: '描述',
			id:'filterdescript',		//这个ID必须要，用在grid的autoExpandColumn中
            dataIndex: 'descript',
            width: 120
        }, {
            header: '入参',
            dataIndex: 'inPam',
            width: 50,
			editor: new Ext.form.TextField({allowBlank: true})
        }, {
            header: '运算符',
            dataIndex: 'logicalOperators',
            width: 50,		    
			editor: new Ext.form.ComboBox({
				displayField:   'description',
				valueField:     'value',
				store:          new Ext.data.JsonStore({
					fields : ['description', 'value'],
					data   : [
						{description : '=',   value: '='}
					   ,{description : '>',   value: '>'}
					   ,{description : '<',   value: '<'}
					   ,{description : '>=',   value: '>='}
					   ,{description : '<=',   value: '<='}
					   ,{description : '!=',   value: '!='}
					   ,{description : 'like',   value: 'like'}
					]
				}),	
				mode:           'local',
				triggerAction:  'all',
                typeAhead: true
            })
        }, {
            header: '过滤值',
            dataIndex: 'filterV',
            width: 80,
			editor: new Ext.form.TextField({allowBlank: false})
        },{
			xtype: 'actioncolumn',
			header: '删除',
			width: 50,
			items: [{        
				//icon   : '../scripts/dhcwl/BasicDataQuery/shared/icons/fam/delete.gif',  // Use a URL in the icon config
				icon   : '../images/uiimages/edit_remove.png',
				tooltip: '移除',
				handler: function(grid, rowIndex, colIndex) {
					filterStore.removeAt(rowIndex);
				}
			}]
		}]
	})	
	
   // create the itemGrid
    var rowGrid = new Ext.grid.EditorGridPanel({
		ddGroup: 'treeNodeDDGroup',
		border:false,
        store: rowStore,
        stripeRows: true,
        autoExpandColumn: 'rowdescript',
		cm: rowCm,
        title: '行显示',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect: true}),
		enableDrag:true,
		view:new Ext.grid.GridView({markDirty:false})
    });	
    var colGrid = new Ext.grid.EditorGridPanel({
		ddGroup: 'treeNodeDDGroup',
		border:false,
        store: colStore,
        stripeRows: true,
        autoExpandColumn: 'coldescript',
		cm: colCm,
        title: '列显示',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect: true}),
		enableDrag:true,
		view:new Ext.grid.GridView({markDirty:false})
    });	
    var measureGrid = new Ext.grid.GridPanel({
		ddGroup: 'treeNodeDDGroup',
		border:false,
        store: measureStore,
        stripeRows: true,
        autoExpandColumn: 'measuredescript',
		cm: measureCm,
        title: '度量',
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect: true}),
		enableDrag:true,
		view:new Ext.grid.GridView({markDirty:false})
    });		

    var filterGrid = new Ext.grid.EditorGridPanel({
		flex:1,
		border:false,
        store: filterStore,
        stripeRows: true,
        autoExpandColumn: 'filterdescript',
		cm: filterCm,
		title:'过滤条件',
		stripeRows: true,
		clicksToEdit: 1,
		sm: new Ext.grid.RowSelectionModel({singleSelect: true}),
		enableDrag:true,
		view:new Ext.grid.GridView({markDirty:false})
    });	
	
	colStore.loadData(colStoreData);	
	rowStore.loadData(rowStoreData);
	measureStore.loadData(measureStoreData);
	filterStore.loadData(filterStoreData);	
	
	
   // create the itemGrid

	var comboDateItem=new Ext.form.ComboBox({
				//columnWidth: .1,

				allowBlank:false,
				//msgTarget: 'side',
				name:'comboDateItem',
				id:'summaryComboDateItem',
				displayField:   'description',
				valueField:     'value',
				store:new Ext.data.Store({
						proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=getDateItem'}),
						reader: new Ext.data.JsonReader({
							totalProperty: 'totalNum',
							root: 'root',
							fields:[
								{name: 'description'},
								{name: 'value'}
							]
						})
					}),	
				mode:           'remote',
				triggerAction:  'all',				
                typeAhead: true,
                listClass: 'x-combo-list-small'
            })
			
	var preSummaryViewGrid = null;

	 var saveMenu = new Ext.menu.Menu({
        //id: 'saveMenu',
        items: [
            {
				//id:'menuSave',
                text: '保存',
                handler: OnSaveRptCfg
            },{
				//id:'menuSaveas',				
                text: '另存',
                handler: OnSaveAsRptCfg				
			}]				
	})
	
    var SummaryDataQryCfgPanel =new Ext.Panel({
		title:'交叉表格显示',
		layout:'border',
		
			items: [
			{
				split:true,
				height:400,
				region:'north',				
				layout: {
					type:'vbox',
					padding:'0',
					align:'stretch',
					border:false
				},
				bbar :new Ext.Toolbar({
					layout: 'hbox',
					items : ['日期范围:',comboDateItem,
					{

						xtype: 'datefield',
						name : 'startDate',
						id : 'sumStartDate',
						format:GetWebsysDateFormat()
						//format:'Y-m-d'
					},
					{
						xtype: 'displayfield',
						value : '-'
					},
					{
						xtype: 'datefield',
						name : 'endDate',
						id : 'sumEndDate',
						format:GetWebsysDateFormat()
						//format:'Y-m-d'
					}/*,{
						xtype:'spacer',
						flex:1
					},*/
					,"-",
					/*
					{
						xtype:'button',
						width:100,
						text: '导出执行代码',
						handler: OnOutputQry
					},
					*/{
						xtype:'button',
						width:100,
						text: '查询',
						handler: OnQryData
					},{
						xtype:'spacer',
						flex:1
					},{
						width:120,
						text: '保存查询配置',
						//handler: OnSaveRptCfg
						menu: saveMenu  						

					},{
						xtype:'button',
						width:120,
						text: '加载查询配置',
						handler: OnLoadRptCfg
					},{
						xtype:'spacer',
						flex:1
					},{
						width:100,
						text: '操作说明',
						handler: OnShowHelpData
					}
					
					
					]}),
				
				
				items: [
				{		
					border:false,
					flex:1,
					layout: {
						type:'hbox',
						padding:'0',
						align:'stretch',
						border:false
					},
					items: [
					{
						title:'选择统计项',
						flex:2,
						layout:'fit',
						items:tree
					},{
						flex:3,
						layout:'fit',
						layout: {
							type:'vbox',
							padding:'0',
							align:'stretch',
							border:false
						},	
						defaults: {
							flex: 1
						},			
						items:[rowGrid,colGrid]			
					},{
						flex:3,
						layout:'fit',
						layout: {
							type:'vbox',
							padding:'0',
							align:'stretch',
							border:false
						},	
						defaults: {
							flex: 1
						},				
						items:[
							measureGrid,filterGrid					
							]
					}]
				}/*,actForm*/]
			},{
				region:'center',
				layout:'fit',
				id:'summaryViewGridID',
				items:[{
					title: '查询结果',
					id:'runqianRpt',    
					frameName: 'runqianRpt',
					//html: '<iframe id="runqianRpt" width=100% height=100% src= ></iframe>'		
					html: '<iframe id="runqianRpt" width=100% height=100% src="dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-BaseDataQry2.raq"></iframe>'	
					,autoScroll: true
				}]				

			}]


    });

	var colGridDropTarget=null;
	colGrid.on("afterrender",function(component){
		var colGridDropTargetEl =  colGrid.getView().scroller.dom;

		colGridDropTarget = new Ext.dd.DropTarget(colGridDropTargetEl, {
				ddGroup    : 'treeNodeDDGroup',
				notifyDrop : function(ddSource, e, data){
					if (!!ddSource.tree) {
						var node=data.node;
						var store=colGrid.getStore();			
						var descript=node.text;
						var parentNode=node.parentNode;
						
						if (store.getCount()==5) {
							Ext.Msg.alert("提示","列显示项不能超过5条！");
							return;
						}
						
						if (parentNode.text!="维度" && parentNode.text!="度量") {
							descript=parentNode.text+"->"+descript
						}
						var name="";
						if (node.attributes.itemName) name=node.attributes.itemName;
						else name=node.attributes.DimProCode;
						var insData = {
							name: name,
							descript: descript,
							itemObj: node,
							inPam:""
						};
						var p = new store.recordType(insData); // create new record
						var pos=store.getCount()
						store.insert(pos, p); 							

					}else if(colGrid.id==data.grid.id) {
						var rows = data.selections;
						var index = ddSource.getDragData(e).rowIndex;
						if (typeof(index) == "undefined") {
							//index=0;
							if (colGrid.getStore().getCount()==0) index=0;
							else return;
						}
						// 修改store
						for(i = 0; i < rows.length; i++) {
							var rowData = rows[i];
							if(!this.copy) data.grid.getStore().remove(rowData);
							colGrid.getStore().insert(index, rowData);
						}						
						
					}
					return true				
				}
		});			




	})

	var rowGridDropTarget=null;
	rowGrid.on("afterrender",function(component){
		var rowGridDropTargetEl =  rowGrid.getView().scroller.dom;
		rowGridDropTarget = new Ext.dd.DropTarget(rowGridDropTargetEl, {
				ddGroup    : 'treeNodeDDGroup',
				notifyDrop : function(ddSource, e, data){
					if (!!ddSource.tree) {
						var node=data.node;
						var store=rowGrid.getStore();			
						var descript=node.text;
						var parentNode=node.parentNode;
						if (store.getCount()==5) {
							Ext.Msg.alert("提示","行显示项不能超过5条！");
							return;
						}
						if (parentNode.text!="维度" && parentNode.text!="度量") {
							descript=parentNode.text+"->"+descript
						}
						var name="";
						if (node.attributes.itemName) name=node.attributes.itemName;
						else name=node.attributes.DimProCode;
						var insData = {
							name: name,
							descript: descript,
							itemObj: node,
							inPam:""
						};
						var p = new store.recordType(insData); // create new record
						var pos=store.getCount()
						store.insert(pos, p); 							
						
					}else if(rowGrid.id==data.grid.id) {
						var rows = data.selections;
						var index = ddSource.getDragData(e).rowIndex;
						if (typeof(index) == "undefined") {
							//index=0;
							if (rowGrid.getStore().getCount()==0) index=0;
							else return;
						}
						// 修改store
						for(i = 0; i < rows.length; i++) {
							var rowData = rows[i];
							if(!this.copy) data.grid.getStore().remove(rowData);
							rowGrid.getStore().insert(index, rowData);
						}						
						
					}
					return true
				}
		});	

		
	})
	
	var measureGridDropTarget=null;
	measureGrid.on("afterrender",function(component){
		var measureGridDropTargetEl =  measureGrid.getView().scroller.dom;
		measureGridDropTarget = new Ext.dd.DropTarget(measureGridDropTargetEl, {
				ddGroup    : 'treeNodeDDGroup',
				notifyDrop : function(ddSource, e, data){
					if (!!ddSource.tree) {
						var node=data.node;
						var store=measureGrid.getStore();			
						var descript=node.text;
						
						if (node.parentNode.text!="度量") {
							Ext.Msg.alert("提示","请在左边树中选择'度量'统计项");
							return;
						}
						if (store.getCount()==5) {
							Ext.Msg.alert("提示","度量显示项不能超过5条！");
							return;
						}						
						
						/*
						var parentNode=node.parentNode;
						if (parentNode.id!="root") {
							descript=parentNode.text+"->"+descript
						}
						*/
						var name="";
						if (node.attributes.itemName) name=node.attributes.itemName;
						else name=node.attributes.DimProCode;
						var insData = {
							name: name,
							descript: descript,
							itemObj: node
						};
						var p = new store.recordType(insData); // create new record
						var pos=store.getCount()
						store.insert(pos, p); 							
					}else if(measureGrid.id==data.grid.id) {
						var rows = data.selections;
						var index = ddSource.getDragData(e).rowIndex;
						if (typeof(index) == "undefined") {
							//index=0;
							if (measureGrid.getStore().getCount()==0) index=0;
							else return;
						}
						// 修改store
						for(i = 0; i < rows.length; i++) {
							var rowData = rows[i];
							if(!this.copy) data.grid.getStore().remove(rowData);
							measureGrid.getStore().insert(index, rowData);
						}						
						
					}
					return true
				}
		});			
		
	})	
	
	filterGrid.on("validateedit",function(e){	
		if (e.column!=4) return;
		var newV=e.value;
		var patt1 = new RegExp("\'");
		//var patt1 = new RegExp("[^\']","g");
		var result = patt1.test(newV);
		if (result==true) {
			Ext.Msg.alert("提示","过滤值不能包含单引号！");
			e.cancel =true;	
		}
		if (!!newV) {
			if (newV.substr(0,1)!="\"" && newV.substr(newV.length-1,1)!="\"") {
				e.value="\""+e.value+"\"";
			}
		}
	})

	
	var filterGridDropTarget=null;
	filterGrid.on("afterrender",function(component){
		var filterGridDropTargetEl =  filterGrid.getView().scroller.dom;
		filterGridDropTarget = new Ext.dd.DropTarget(filterGridDropTargetEl, {
				ddGroup    : 'treeNodeDDGroup',
				notifyDrop : function(ddSource, e, data){
					if (!!ddSource.tree) {
						var node=data.node;
						var store=filterGrid.getStore();			
						var descript=node.text;
						var parentNode=node.parentNode;
						/*
						if (parentNode.id!="root") {
							descript=parentNode.text+"->"+descript
						}
						*/
						if (parentNode.text!="维度" && parentNode.text!="度量") {
							descript=parentNode.text+"->"+descript
						}
						var name="";
						if (node.attributes.itemName) name=node.attributes.itemName;
						else name=node.attributes.DimProCode;
						var insData = {
							name: name,
							descript: descript,
							logicalOperators:'',
							filterV:'',
							itemObj: node,
							inPam:""
						};
						var p = new store.recordType(insData); // create new record
						var pos=store.getCount()
						store.insert(pos, p); 							
						
						return true
					}
				}
		});			
		
	})	

	
	function OnLoadRptCfg() {
		var saveWin=new dhcwl.BDQ.SaveAsWin(outThis);

		var initAttrib=new Object();
		initAttrib.rptType="corssRpt";
		initAttrib.usedFor="load";
		//initAttrib.curRptName=rptName;
		saveWin.initAttrib(initAttrib);

		
		saveWin.initForLoad();
		saveWin.onLoadCallback=LoadRpt;
		saveWin.show();			
	}
	
	function LoadRpt(outRptName,outRptID) {


		dhcwl.mkpi.Util.ajaxExc(serviceUrl,
		{
			action:"getLoadRptCfgData",
			rptName:outRptName,//过滤项标识,
			rptID:outRptID
		},function(jsonData){
			if(jsonData.success==true && jsonData.tip=="ok" && jsonData.MSG=='SUCESS'){
				
				updateGrids(jsonData.cfgData);
				rptName=outRptName;
				rptID=outRptID;
				SummaryDataQryCfgPanel.setTitle("交叉表格显示——"+rptName);
				//CloseWins();
				var gridContainer=Ext.getCmp("summaryViewGridID");
				var iframe = gridContainer.el.dom.getElementsByTagName("iframe")[0];
				iframe.src = 'dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-BaseDataQry2.raq';
				
			}else{
				Ext.Msg.alert("操作失败",jsonData.MSG);
			}
		},this);
	}
	
	function updateGrids(cfgData) {
		rowStore.removeAll();
		colStore.removeAll();
		measureStore.removeAll();
		filterStore.removeAll();
		


		var baseObjName=cfgData.baseObjName;
		Ext.getCmp("SumComboQryObjName").focus();
		var baseObjNameDesc=cfgData.baseObjNameDesc;
		Ext.getCmp("SumComboQryObjName").setValue(baseObjNameDesc+"["+baseObjName+"]");
		//setTimeout('Ext.getCmp("SumComboQryObjName").focus();Ext.getCmp("SumComboQryObjName").setValue(baseObjName);',1);
		//Ext.getCmp("SumComboQryObjName").selectByValue(baseObjName);
		//comboQryObj=baseObjName;
		//Ext.getCmp("SumComboQryObjName").getStore().reload();

		//Ext.getCmp("SumComboQryObjName").expand();
		//delete Ext.getCmp("SumComboQryObjName").lastQuery;
		//Ext.getCmp("SumComboQryObjName").focus();
		//setTimeout('Ext.getCmp("SumComboQryObjName").expand();',1);
		//Ext.getCmp("SumComboQryObjName").setValue(baseObjName);
		//setTimeout('Ext.getCmp("SumComboQryObjName").collapse();',50);
		
		
		var dateItemName=cfgData.DateItemName;
		var dateItemNameDesc=cfgData.dateItemNameDesc;		
		var curDate=dhcwl.mkpi.Util.nowDate();
		Ext.getCmp("sumStartDate").setValue(curDate);
		Ext.getCmp("sumEndDate").setValue(curDate);		
		
		
		delete comboDateItem.lastQuery;				
		comboDateItem.getStore().setBaseParam("qryObjName",baseObjName);	//更新日期区间过滤
		comboDateItem.getStore().reload();
		//comboDateItem.focus();
		comboDateItem.setValue(dateItemNameDesc+"["+dateItemName+"]");
		
		//setTimeout('comboDateItem.focus();comboDateItem.setValue(dateItemName);',500);
		Ext.getCmp("SumComboQryObjName").focus();
		
		
		
		aryRptsub=cfgData.rptsub;
		
		for(var i=0;i<aryRptsub.length;i++)
		{
			
			var item=aryRptsub[i].item;
			var node=new Object();
			id=item.split("(")[0];
			node.id=id;
			var len=id.split("->").length;
			var name=id.split("->")[len-1];
			
			var descript=aryRptsub[i].descript;

			var insData = {
				name: name,
				descript: descript,
				itemObj: node//,
				//inPam:inPam
			};			
			
			if(aryRptsub[i].type=="row") {
				var inPam=item.split("(")[1].split(")")[0];
				insData.inPam=inPam;
				var p = new rowStore.recordType(insData); // create new record
				var pos=rowStore.getCount();
				rowStore.insert(pos, p); 					
			}
			if(aryRptsub[i].type=="col") {
				var inPam=item.split("(")[1].split(")")[0];
				insData.inPam=inPam;
				var p = new colStore.recordType(insData); // create new record
				var pos=colStore.getCount()
				colStore.insert(pos, p); 					
			}			
			
			
			if(aryRptsub[i].type=="measure") {
				var p = new measureStore.recordType(insData); // create new record
				var pos=measureStore.getCount()
				measureStore.insert(pos, p); 					
			}
			
			if(aryRptsub[i].type=="filter") {
				var inPam=item.split("(")[1].split(")")[0];
				insData.inPam=inPam;
				insData.logicalOperators=item.split("^")[1];
				insData.filterV=item.split("^")[2];
				var p = new filterStore.recordType(insData); // create new record
				var pos=filterStore.getCount()
				filterStore.insert(pos, p); 					
			}
		}
	
	}
	
	function OnQryData() {
		//1、校验数据
		var qryObjName=Ext.getCmp("SumComboQryObjName").getValue();	//查询对象
		if (qryObjName=="") {
			Ext.Msg.alert("提示","查询对象为空，请先选择查询对象！");
			return;
		}
		
		var dateItem=Ext.getCmp("summaryComboDateItem").getValue();	//日期区间
		//var startDate=Ext.getCmp("sumStartDate").getRawValue();
		var startDate=Ext.getCmp("sumStartDate").getValue().format('Y-m-d');
		//var endDate=Ext.getCmp("sumEndDate").getRawValue();		
		var endDate=Ext.getCmp("sumEndDate").getValue().format('Y-m-d');
		if (dateItem=="" || startDate=="" || endDate=="") {
			Ext.Msg.alert("提示","日期区间为空，请先选择日期区间！");
			return;
		}		
		
		//行显示项
		if (rowStore.getCount()<1) {
			Ext.Msg.alert("提示","行显示项为空，请先选择行显示项！");
			return;
		}			
		//列显示项
		/*add by wz.2017-11-16
		if (colStore.getCount()<1) {
			Ext.Msg.alert("提示","列显示项为空，请先选择列显示项！");
			return;
		}		
		*/
		//列显示项
		if (measureStore.getCount()<1) {
			Ext.Msg.alert("提示","度量项为空，请先选择度量项！");
			return;
		}		
		
		//rebuildStoreAndCol();	//modify by wz.2017-12-18
		QryDataOutRaq();
		
	}

	function QryDataOutRaq() {
		var newRptName="tempSysRpt";
		var remarks="系统临时表";
		var recAct="saveTempSysRpt";
		var action="saveRptCfg";
		//var recAct="";
		
		var paramRows="";
		var tStore=rowStore;
		for(var i=0;i<tStore.getCount();i++)
		{
			var nodeObj=tStore.getAt(i).get('itemObj');
			var inPam=tStore.getAt(i).get('inPam');
			if (paramRows!="") paramRows=paramRows+","
			paramRows=paramRows+nodeObj.id+"("+inPam+")";	
		}

		var paramCols="";
		var tStore=colStore;
		for(var i=0;i<tStore.getCount();i++)
		{
			var nodeObj=tStore.getAt(i).get('itemObj');
			var inPam=tStore.getAt(i).get('inPam');
			if (paramCols!="") paramCols=paramCols+","
			paramCols=paramCols+nodeObj.id+"("+inPam+")";
		}			
		
		//3、度量
		var paramMeasure="";
		var tStore=measureStore;
		for(var i=0;i<tStore.getCount();i++)
		{
			var nodeObj=tStore.getAt(i).get('itemObj');
			if (paramMeasure!="") paramMeasure=paramMeasure+","
			paramMeasure=paramMeasure+nodeObj.id;
		}		
		
		//paramMeasure=measureStore.getAt(0).get('itemObj').id;
		
		//4、区间		
		var daterangeItem=Ext.getCmp("summaryComboDateItem").getValue();
		if (daterangeItem.indexOf("]")>=0 ) {
			daterangeItem=daterangeItem.split("[")[1];
			daterangeItem=daterangeItem.split("]")[0];	
		}
		//5、过滤
		var filterIDs="";
		var filterOperas="";
		var filterValues="";
		for(var i=0;i<filterStore.getCount();i++)
		{
			var operator=filterStore.getAt(i).get('logicalOperators');
			var nodeObj=filterStore.getAt(i).get('itemObj');
			var filterV=filterStore.getAt(i).get('filterV');
			var inPam=filterStore.getAt(i).get('inPam');
			if (filterIDs!="") filterIDs=filterIDs+","
			filterIDs=filterIDs+nodeObj.id+"("+inPam+")^"+operator+"^"+filterV;
		}
		
		var qryObjName=Ext.getCmp("SumComboQryObjName").getValue();
		if (qryObjName.indexOf("]")>=0 ) {
			qryObjName=qryObjName.split("[")[1];
			qryObjName=qryObjName.split("]")[0];	
		}		
		
		

		dhcwl.mkpi.Util.ajaxExc(serviceUrl,
		{
			action:action,
			rptType:"corssRpt",
			recAct:recAct,			//插入还是更新
			rptName:newRptName,
			qryObjName:qryObjName,//查询对象
			paramRows:paramRows,//行条件
			paramCols:paramCols,//列条件
			paramMeasure:paramMeasure,//度量
			daterangeItem:daterangeItem,//查询日期字段
			filterIDs:filterIDs,//过滤项标识
			Remarks:remarks	//备注
		},function(jsonData){
			if(jsonData.success==true && jsonData.tip=="ok"){
				var rptID=jsonData.RptID;
				var startDate=Ext.getCmp("sumStartDate").getValue().format('Y-m-d');
				var endDate=Ext.getCmp("sumEndDate").getValue().format('Y-m-d');
				var strParams="&rptID="+rptID+"&daterangeStart="+startDate+"&daterangeEnd="+endDate;
				var gridContainer=Ext.getCmp("summaryViewGridID");
				var iframe = gridContainer.el.dom.getElementsByTagName("iframe")[0];
				iframe.src = 'dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-BaseDataQry2.raq'+strParams ;			
			
			
			}else{
				Ext.Msg.alert("操作失败",jsonData.MSG);
			}
		},this);		
		
		
	}
	
	
	function OnSaveAsRptCfg() {
		
			var initAttrib=new Object();
			initAttrib.rptType="corssRpt";
			initAttrib.usedFor="save";
			initAttrib.curRptName=rptName;
			var saveWin=new dhcwl.BDQ.SaveAsWin(outThis);
			saveWin.onSaveAsCallback=SaveRpt;
			saveWin.initAttrib(initAttrib);
			saveWin.initForSave();
			saveWin.show();		
	}
	
	function OnSaveRptCfg() {
		//如果当前配置没有保存过，那么保存和另存都是另存。
		//如果保存过，那么：保存-保存到当前配置中
		if (rptName=="") {
			//另存为
			OnSaveAsRptCfg();
		}else{
			//保存
			SaveRpt(rptName,"","update");
		}
	}
	
	function SaveRpt(newRptName,remarks,recAct) {
		var action="saveRptCfg";
		//var recAct="";
		
		var inRptName=""
		
		if (newRptName!="") {
			inRptName=newRptName;
			//recAct="insert";
		}else{
			inRptName=rptName;
			//recAct="update";		
		}
		var paramRows="";
		var tStore=rowStore;
		for(var i=0;i<tStore.getCount();i++)
		{
			var nodeObj=tStore.getAt(i).get('itemObj');
			var inPam=tStore.getAt(i).get('inPam');
			if (paramRows!="") paramRows=paramRows+","
			paramRows=paramRows+nodeObj.id+"("+inPam+")";	
		}

		var paramCols="";
		var tStore=colStore;
		for(var i=0;i<tStore.getCount();i++)
		{
			var nodeObj=tStore.getAt(i).get('itemObj');
			var inPam=tStore.getAt(i).get('inPam');
			if (paramCols!="") paramCols=paramCols+","
			paramCols=paramCols+nodeObj.id+"("+inPam+")";
		}			
		
		//3、度量
		var paramMeasure="";
		var tStore=measureStore;
		for(var i=0;i<tStore.getCount();i++)
		{
			var nodeObj=tStore.getAt(i).get('itemObj');
			if (paramMeasure!="") paramMeasure=paramMeasure+","
			paramMeasure=paramMeasure+nodeObj.id;
		}		
		
		//paramMeasure=measureStore.getAt(0).get('itemObj').id;
		
		//4、区间		
		var daterangeItem=Ext.getCmp("summaryComboDateItem").getValue();
		if (daterangeItem.indexOf("]")>=0 ) {
			daterangeItem=daterangeItem.split("[")[1];
			daterangeItem=daterangeItem.split("]")[0];	
		}
		//5、过滤
		var filterIDs="";
		var filterOperas="";
		var filterValues="";
		for(var i=0;i<filterStore.getCount();i++)
		{
			var operator=filterStore.getAt(i).get('logicalOperators');
			var nodeObj=filterStore.getAt(i).get('itemObj');
			var filterV=filterStore.getAt(i).get('filterV');
			var inPam=filterStore.getAt(i).get('inPam');
			if (filterIDs!="") filterIDs=filterIDs+","
			filterIDs=filterIDs+nodeObj.id+"("+inPam+")^"+operator+"^"+filterV;
		}
		
		var qryObjName=Ext.getCmp("SumComboQryObjName").getValue();

		if (qryObjName.indexOf("]")>=0 ) {
			qryObjName=qryObjName.split("[")[1];
			qryObjName=qryObjName.split("]")[0];	
		}
		dhcwl.mkpi.Util.ajaxExc(serviceUrl,
		{
			action:action,
			rptType:"corssRpt",
			recAct:recAct,			//插入还是更新
			rptName:inRptName,
			qryObjName:qryObjName,//查询对象
			paramRows:paramRows,//行条件
			paramCols:paramCols,//列条件
			paramMeasure:paramMeasure,//度量
			daterangeItem:daterangeItem,//查询日期字段
			filterIDs:filterIDs,//过滤项标识
			Remarks:remarks	//备注
		},function(jsonData){
			if(jsonData.success==true && jsonData.tip=="ok"){
				Ext.Msg.alert("提示","操作成功！");
				rptName=inRptName;
				SummaryDataQryCfgPanel.setTitle("交叉表格显示——"+rptName);
				//CloseWins();
			}else{
				Ext.Msg.alert("操作失败",jsonData.MSG);
			}
		},this);			
	}


	
	
	function OnMoveDown() {
		
	}
    
	function rebuildStoreAndCol(){
		
		var qryObjName=Ext.getCmp("SumComboQryObjName").getValue();		
		if (qryObjName.indexOf("]")>=0 ) {
			qryObjName=qryObjName.split("[")[1];
			qryObjName=qryObjName.split("]")[0];	
		}
		var paramMeasure=null;
		//1、设置行条件
		var fields=new Array();
		var paramRows="";
		var inPamRows=""
		var tStore=rowStore;
		for(var i=0;i<tStore.getCount();i++)
		{
			var header=tStore.getAt(i).get('descript'); 
			var nodeObj=tStore.getAt(i).get('itemObj');
			var dataIndex=nodeObj.id;
			if (paramRows!="") {
				paramRows=paramRows+",";
				inPamRows=inPamRows+",";
			}
			paramRows=paramRows+nodeObj.id;	
			inPamRows=inPamRows+tStore.getAt(i).get('inPam');
			dim={dataIndex:dataIndex,direction: 'ASC',width: 100};
			var field={name:nodeObj.id,   type: 'string'};
			fields.push(field);	//重建store中的field			
			
		}

		//2、设置列条件
		var paramCols="";
		var inPamCols=""
		var tStore=colStore;
		for(var i=0;i<tStore.getCount();i++)
		{
			var header=tStore.getAt(i).get('descript');
			
			var nodeObj=tStore.getAt(i).get('itemObj');
			var dataIndex=nodeObj.id;	
			if (paramCols!="") {
				paramCols=paramCols+",";
				inPamCols=inPamCols+",";
			}
			paramCols=paramCols+nodeObj.id;	
			inPamCols=inPamCols+tStore.getAt(i).get('inPam');
			dim={dataIndex:dataIndex,direction:'ASC',width: 200};
			var field={name:nodeObj.id,   type: 'string'};
			fields.push(field);	//重建store中的field	
		}		
		
		//3、设置度量
		var paramMeasureDesc="";
		var paramMeasure="";
		for(var i=0;i<measureStore.getCount();i++) {
			var descript=measureStore.getAt(i).get('descript');
			
			var measure=measureStore.getAt(i).get('itemObj').id;
			if (paramMeasure!="") {
				paramMeasureDesc=paramMeasureDesc+',';
				paramMeasure=paramMeasure+',';
			}
			//paramMeasureDesc=paramMeasureDesc+encodeURI(descript);
			paramMeasureDesc=paramMeasureDesc+descript;
			paramMeasure=paramMeasure+measure;
		}

		var gridContainer=Ext.getCmp("summaryViewGridID");
	
		//4、日期区间

		var dateItem=Ext.getCmp("summaryComboDateItem").getValue();
		//var startDate=Ext.getCmp("sumStartDate").getRawValue();
		var startDate=Ext.getCmp("sumStartDate").getValue().format('Y-m-d');
		//var endDate=Ext.getCmp("sumEndDate").getRawValue();		
		var endDate=Ext.getCmp("sumEndDate").getValue().format('Y-m-d');
		//5、过滤grid
		var filterIDs="";
		var filterOperas="";
		var filterValues="";
		var inPamfilter=""
		for(var i=0;i<filterStore.getCount();i++)
		{
			var logicalOperators=filterStore.getAt(i).get('logicalOperators');
			var nodeObj=filterStore.getAt(i).get('itemObj');
			var filterV=filterStore.getAt(i).get('filterV');
			inPamfilter=inPamfilter+","+filterStore.getAt(i).get('inPam');
			filterIDs=filterIDs+","+nodeObj.id;
			filterOperas=filterOperas+","+logicalOperators;;
			filterValues=filterValues+","+filterV;
		}
		


		var strParams='&qryObjName='+qryObjName+'&paramRows='+paramRows+'&inPamRows='+inPamRows+'&paramCols='+paramCols;
		strParams=strParams+'&inPamCols='+inPamCols+'&paramMeasure='+paramMeasure+'&paramMeasureDesc='+paramMeasureDesc+'&daterangeItem='+dateItem+'&daterangeStart='+startDate+'&daterangeEnd='+endDate+'&rptName='+rptName;
		strParams=strParams+'&filterIDs='+filterIDs+'&filterOperas='+filterOperas+'&filterValues='+filterValues+'&inPamfilter='+inPamfilter;
		//strParams=encodeURI(strParams);
		var iframe = gridContainer.el.dom.getElementsByTagName("iframe")[0];
		iframe.src = 'dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-BaseDataQry.raq'+strParams ;
		//strParams='&kpi=PatLocTarEC&startDate='+startDate+'&endDate='+endDate+"&isRealData=R";
		//iframe.src = 'dhccpmrunqianreport.csp?reportName=jltest.raq'+strParams ;
		
	}
	function OnShowHelpData()
	{
		var helpDataObj=new dhcwl.BDQ.HelpData()
		var helpDataWin=helpDataObj.getHelpDataWin();
		helpDataWin.show();

	}	
    this.getSummaryDataQryCfgPanel=function(){
    	return SummaryDataQryCfgPanel;
    }

	function refreshTree(qryObjName) {
		rootNode=tree.getRootNode();
		rootNode.remove();
		var root = new Ext.tree.AsyncTreeNode({
				text : 'root',
				draggable : false,
				id : 'root',//默认的node值：?node=-100
				type:'dir'
			  });
		tree.setRootNode(root);			
		if (qryObjName.indexOf("]")>=0 ) {
			qryObjName=qryObjName.split("[")[1];
			qryObjName=qryObjName.split("]")[0];	
		}
		
		root.loader = new Ext.tree.TreeLoader({
			dataUrl:'dhcwl/basedataquery/dataqrycfg.csp?action=getSumItemNode&QryObjName='+qryObjName
		});			
		
	}	
}

