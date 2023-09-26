(function(){
	Ext.ns("dhcwl.BDQ.DetailDataQryCfg");
})();
///描述: 		查询对象
///编写者：		WZ
///编写日期: 		2016-11
dhcwl.BDQ.DetailDataQryCfg=function(pObj){
	var serviceUrl="dhcwl/basedataquery/dataqrycfg.csp";
	var outThis=this;
	var parentObj=pObj;
	var rptName="";
	
	var tree = new Ext.tree.TreePanel({
		//ddGroup: 'treeNodeDDGroup',
		ddGroup: 'itemGridDDGroup',
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
				/*
				allowBlank:false,
				xtype:'combo',
				id:'ComboQryObjName',
				mode:'local',
				//emptyText:'请选择搜索类型',
				triggerAction:  'all',
				editable: false,
				displayField:   'description',
				valueField:     'name',
				store:          new Ext.data.JsonStore({
					fields : ['description', 'name'],
					data   : [
						{description : '收入',   name: 'dhc_workload'}
					   ,{description : '挂号',   name: 'DHCWorkRegReport'}
					   ,{description : '出入转',   name: 'DHCMRIPDay'}
					   ,{description : '手术',   name: 'DHCWL_AnOperation'}
					   ,{description : '病案',   name: 'dhcmrinfo'}
					   ,{description : '收入',   name: 'Data.DHCWorkLoad'}
					]
				})
				*/
				allowBlank:false,
				xtype:'combo',
				id:'ComboQryObjName',
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
				triggerAction:  'all',
				//forceSelection: true,
				//editable:       false,				
                typeAhead: true,
                // transform the data already specified in html
                listClass: 'x-combo-list-small'	,
				
				listeners:{
					'beforeselect':function(combo,record,index) {
						var oldQryObjName=Ext.getCmp("ComboQryObjName").getValue();
						var qryObjName=record.get('Name');
						if (oldQryObjName!=qryObjName) {
							refreshTree(qryObjName);
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
							if (qryObjName.indexOf("]")>=0 ) {
								qryObjName=qryObjName.split("[")[1];
								qryObjName=qryObjName.split("]")[0];	
							}							
							root.loader = new Ext.tree.TreeLoader({
								dataUrl:'dhcwl/basedataquery/dataqrycfg.csp?action=getSumItemNode&QryObjName='+qryObjName
							});	
							*/

							comboDateItem.setValue("");
							comboDateItem.getStore().setBaseParam("qryObjName",qryObjName);	//更新日期区间过滤
							comboDateItem.getStore().reload();
							delete comboDateItem.lastQuery;
							
							itemStore.removeAll();
							filterStore.removeAll();
							
							//preDetailViewGrid.getColumnModel().setConfig([]) ;
							
							rptName="";
							DetailDataQryCfgPanel.setTitle("网格/分组表格显示");
							
							
						}			
					}
				}				
			}]	
		}),				
				
		listeners:{

			'beforeload':function(node){
				if (node.id=="root") return;
				if (node.id=="dimChild") {
					var qryObjName=Ext.getCmp("ComboQryObjName").getValue();
					if (qryObjName.indexOf("]")>=0 ) {
						qryObjName=qryObjName.split("[")[1];
						qryObjName=qryObjName.split("]")[0];	
					}						
					node.loader = new Ext.tree.TreeLoader({
						dataUrl:'dhcwl/basedataquery/dataqrycfg.csp?action=getSumItemNode&itemType=dim&QryObjName='+qryObjName
					});
				}else if (node.id=="measureChild"){
					var qryObjName=Ext.getCmp("ComboQryObjName").getValue();
					
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

    var itemStoreData = [];	
    var itemStore = new Ext.data.ArrayStore({
		autoDestroy: true,
        fields: [
           {name: 'name'},
           {name: 'itemDescript'},
		   {name:'itemObj'},
		   {name:'inPam'}
        ]
    });	
	
	var itemCm = new Ext.grid.ColumnModel({
        columns: [{
            header: '名称',
            dataIndex: 'name',
            width: 130
        }, {
            header: '描述',
			id:'itemDescript',		//这个ID必须要，用在grid的autoExpandColumn中
            dataIndex: 'itemDescript',
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
				//icon   : '../scripts/dhcwl/BasicDataQuery/shared/icons/fam/delete.gif',  
				icon   : '../images/uiimages/edit_remove.png',
				tooltip: '移除',
				handler: function(grid, rowIndex, colIndex) {
					itemStore.removeAt(rowIndex);
				}
			}]
			
		}]
	})		
   // create the itemGrid
    var itemGrid = new Ext.grid.EditorGridPanel({
		enableDragDrop: true,   //拖动排序用的属性
		ddGroup: 'itemGridDDGroup',
		//enableDragDrop: true, 		
		border:false,
        store: itemStore,
        stripeRows: true,
        autoExpandColumn: 'itemDescript',
		cm: itemCm,
		sm: new Ext.grid.RowSelectionModel({singleSelect: true}),
        title: '列显示',
		stripeRows: true,
		view:new Ext.grid.GridView({markDirty:false})
    });	
	
	itemStore.loadData(itemStoreData);
	
    var filterStoreData = [];	
    var filterStore = new Ext.data.ArrayStore({
		autoDestroy: true,
        fields: [
           {name: 'name'},
           {name: 'Descript'},
		   {name: 'logicalOperators'},
		   {name: 'filterV'},
		   {name:'itemObj'},
		   {name:'inPam'}
        ]
    });	
	
	var filterCm = new Ext.grid.ColumnModel({
        columns: [{
            header: '名称',
            dataIndex: 'name',
            width: 100
        }, {
            header: '描述',
			id:'Descript',		//这个ID必须要，用在grid的autoExpandColumn中
            dataIndex: 'Descript',
            width: 120
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
					filterStore.removeAt(rowIndex);
				}
			}]
		}]
	})		
	
	var filterView=new Ext.grid.GridView({markDirty:false});
   // create the itemGrid
    var filterGrid = new Ext.grid.EditorGridPanel({
		flex:1,
		border:false,
        store: filterStore,
        stripeRows: true,
        autoExpandColumn: 'Descript',
		cm: filterCm,
		//title:'其他过滤条件',
		stripeRows: true,
		clicksToEdit: 1,
		view:filterView
    });	
	
	filterStore.loadData(filterStoreData);


	
	var comboDateItem=new Ext.form.ComboBox({
				allowBlank:false,
				name:'comboDateItem',
				id:'detailComboDateItem',
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
				//forceSelection: true,
				//editable:       false,				
                typeAhead: true,
                // transform the data already specified in html
                listClass: 'x-combo-list-small'
            })
			
			
	

	
 
	
	
	/*
    var preDetailViewGrid = new Ext.grid.GridPanel({
        //height:480,
		title:'查询结果',
        store: preDetailViewStore,
        cm: preDetailViewColumnModel,
		bbar: new Ext.PagingToolbar({
			pageSize:50,
			store:preDetailViewStore,
			displayInfo:true,
			displayMsg:'{0}~{1}条,共 {2} 条',
			emptyMsg:'sorry,data not found!',
			items: [

			]
		})
    });		
	*/


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
	
	var QryDataMenu = new Ext.menu.Menu({
        //id: 'saveMenu',
        items: [
            {
				//id:'menuSave',
                text: '页面显示',
                handler: OnQryData
            },{
				//id:'menuSaveas',				
                text: '润乾显示',
                handler: OnQryData				
			}]				
	})

    var DetailDataQryCfgPanel =new Ext.Panel({
		title:'网格/分组表格显示',
		layout:'border',
		items:[
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
					id : 'detailStartDate',
					format:GetWebsysDateFormat()
				},
				{
					xtype: 'displayfield',
					value : '-'
				},
				{
					xtype: 'datefield',
					name : 'endDate',
					id : 'detailEndDate',
					format:GetWebsysDateFormat()
				},
				"聚合",
				{
					//margins:{top:0, right:0, bottom:0, left:20},
					xtype:'checkbox',
					//width:100,
					//<span style="line-Height:1">查询HIS菜单</span>
					//boxLabel: '聚合',
					//boxLabel: '<span style="line-Height:1">聚合</span>',
					id: 'chkAggregat'
				},{
					xtype:'spacer',
					flex:1
				},'-',
				{
					width:100,
					text: '查询',
					menu: QryDataMenu
				},{
					xtype:'spacer',
					flex:1
				},'-',{
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
					align:'stretch'
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
					items:itemGrid			
				},{
					title:'过滤条件',
					flex:3,
					region:'center',
					layout: {
						type:'vbox',
						//padding:'5,0',
						align:'stretch',
						border:true
					},
					items:[filterGrid]	
					
				}]
			}]
			
		},{
			region:'center',
			layout:'fit',
			id:'outputContainer'//,
			//items:[preDetailViewGrid]
			
		}]
    });

	
	
	
	var itemGridDropTarget=null;
	itemGrid.on("afterrender",function(component){
		
		var itemGridDropTargetEl =  itemGrid.getView().scroller.dom;
		itemGridDropTarget = new Ext.dd.DropTarget(itemGridDropTargetEl, {
				//ddGroup    : 'treeNodeDDGroup',
				ddGroup : "itemGridDDGroup",//'ItemGridDD',
				notifyDrop : function(ddSource, e, data){
					if (!!ddSource.tree) {
					
						var node=data.node;
						var itemStore=itemGrid.getStore();			
						var descript=node.text;
						var parentNode=node.parentNode;
						//if (parentNode.id!="root") {
						if (parentNode.text!="维度" && parentNode.text!="度量") {
							descript=parentNode.text+"->"+descript
						}
						var name="";
						if (node.attributes.itemName) name=node.attributes.itemName;
						else name=node.attributes.DimProCode;
						var insData = {
							name: name,
							itemDescript: descript,
							itemObj: node,
							inPam:""
						};
						var p = new itemStore.recordType(insData); // create new record
						var pos=itemStore.getCount()
						itemStore.insert(pos, p); 							
						return true						
					}else{
						var rows = data.selections;
						// 拖动到第几行
						var index = ddSource.getDragData(e).rowIndex;
						if (typeof(index) == "undefined") {
							//index=0;
							if (itemGrid.getStore().getCount()==0) index=0;
							else return;
						}
						// 修改store
						for(i = 0; i < rows.length; i++) {
							var rowData = rows[i];
							if(!this.copy) data.grid.getStore().remove(rowData);
							itemGrid.getStore().insert(index, rowData);
						}												
					}
				}
		});	

		/*
		var ddrow = new Ext.dd.DropTarget(itemGrid.getView().scroller.dom, {
			ddGroup : "itemGridDDGroup",//'ItemGridDD',
			copy    : false,//拖动是否带复制属性
			notifyDrop : function(dd, e, data) { //对应的函数处理拖放事件
				// 选中了多少行
				var rows = data.selections;
				// 拖动到第几行
				var index = dd.getDragData(e).rowIndex;
				if (typeof(index) == "undefined") {
					//index=0;
					if (itemGrid.getStore().getCount()==0) index=0;
					else return;
				}
				// 修改store
				for(i = 0; i < rows.length; i++) {
					var rowData = rows[i];
					if(!this.copy) data.grid.getStore().remove(rowData);
					itemGrid.getStore().insert(index, rowData);
				}
			}
		}); 	*/
		

		
		
	})

	var filterGridDropTarget=null;
	filterGrid.on("afterrender",function(component){
		var filterGridDropTargetEl =  filterGrid.getView().scroller.dom;
		filterGridDropTarget = new Ext.dd.DropTarget(filterGridDropTargetEl, {
				ddGroup    : 'itemGridDDGroup',
				notifyDrop : function(ddSource, e, data){
					if (!!ddSource.tree) {
						var node=data.node;
						var filterStore=filterGrid.getStore();			
						var descript=node.text;
						var parentNode=node.parentNode;
						//if (parentNode.id!="root") {
						if (parentNode.text!="维度" && parentNode.text!="度量") {
							descript=parentNode.text+"->"+descript
						}

						var name="";
						if (node.attributes.itemName) name=node.attributes.itemName;
						else name=node.attributes.DimProCode;
						var insData = {
							name: name,
							Descript: descript,
							logicalOperators:'',
							filterV:'',
							itemObj: node,
							inPam:""
						};
						var p = new filterStore.recordType(insData); // create new record
						var pos=filterStore.getCount()
						filterStore.insert(pos, p); 							
						
						return true
					}
				}
		});			
		
	})	

	filterGrid.on("validateedit",function(e){	
		if (e.column!=3) return;
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
	
	function OnOutputQry() {
		
		
	}
	
	function OnQryData(btn) {
		//1、校验数据
		var qryObjName=Ext.getCmp("ComboQryObjName").getValue();	//查询对象
		if (qryObjName=="") {
			Ext.Msg.alert("提示","查询对象为空，请先选择查询对象！");
			return;
		}
		
		var dateItem=Ext.getCmp("detailComboDateItem").getValue();	//日期区间
		//var startDate=Ext.getCmp("detailStartDate").getRawValue();
		var startDate=Ext.getCmp("detailStartDate").getValue().format('Y-m-d');
		//var endDate=Ext.getCmp("detailEndDate").getRawValue();	
		var endDate=Ext.getCmp("detailEndDate").getValue().format('Y-m-d');
		if (dateItem=="" || startDate=="" || endDate=="") {
			Ext.Msg.alert("提示","日期区间为空，请先选择日期区间！");
			return;
		}		
		
		//统计项
		if (itemStore.getCount()<1) {
			Ext.Msg.alert("提示","列显示项为空，请先选择列显示项！");
			return;
		}		

		//2、查询数据
		var isAggregat=Ext.getCmp("chkAggregat").getValue();
		
		if (btn.text=="页面显示") {
			if (!isAggregat) {
				OnQryDeatilData();
			}
			else{
				OnQryAggregatData();
			}	
		}else{
			if (!isAggregat) {
				//OnQryDataOutRaq("detail");
				OnQryDataOutRaq2();
			}
			else{
				//OnQryDataOutRaq("aggregat");
				OnQryDataOutRaq2();
			}
		}		
		
	}
	function OnQryDataOutRaq2(newRptName,remarks,recAct){
		var newRptName="tempSysRpt";
		var remarks="系统临时表";
		var recAct="saveTempSysRpt";

		var action="saveRptCfg";
		//var recAct="";


		var paramCols="";
		var tStore=itemStore;
		for(var i=0;i<tStore.getCount();i++)
		{
			var nodeObj=tStore.getAt(i).get('itemObj');
			var inPam=tStore.getAt(i).get('inPam');
			if (paramCols!="") paramCols=paramCols+","
			paramCols=paramCols+nodeObj.id+"("+inPam+")";
		}			

		//4、区间		
		var daterangeItem=Ext.getCmp("detailComboDateItem").getValue();
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
		
		var qryObjName=Ext.getCmp("ComboQryObjName").getValue();
		if (qryObjName.indexOf("]")>=0 ) {
			qryObjName=qryObjName.split("[")[1];
			qryObjName=qryObjName.split("]")[0];	
		}		

		var isAggregat=0;
		if(Ext.getCmp("chkAggregat").getValue()) isAggregat=1;	//是否聚合
		
		dhcwl.mkpi.Util.ajaxExc(serviceUrl,
		{
			action:action,
			rptType:"grpRpt",
			recAct:recAct,			//插入还是更新
			rptName:newRptName,
			qryObjName:qryObjName,//查询对象
			paramCols:paramCols,//列条件
			daterangeItem:daterangeItem,//查询日期字段
			filterIDs:filterIDs,//过滤项标识
			IsAggregat:isAggregat,//是否聚合
			Remarks:remarks	//备注
		},function(jsonData){
			if(jsonData.success==true && jsonData.tip=="ok"){
				var rptID=jsonData.RptID;
				var startDate=Ext.getCmp("detailStartDate").getValue().format('Y-m-d');
				var endDate=Ext.getCmp("detailEndDate").getValue().format('Y-m-d');
				var strParams="&rptID="+rptID+"&daterangeStart="+startDate+"&daterangeEnd="+endDate;
				src = 'dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-BaseDataQryDetail2.raq'+strParams ;	
				var outputContainer=Ext.getCmp("outputContainer");	
				outputContainer.removeAll();
				outputContainer.add(
				{
						title: '查询结果',
						id:'runqianRptDetail',    
						frameName: 'runqianRptDetail',		
						html: '<iframe id="runqianRptDetail" width=100% height=100% src="'+src+'"></iframe>',	
						autoScroll: true				
				})		
				outputContainer.doLayout();				
			}else{
				Ext.Msg.alert("操作失败",jsonData.MSG);
			}
		},this);	









	
	}
	
	function OnQryDataOutRaq(qryType){
		var paramCols="";
		var inPamCols="";
		for(var i=0;i<itemStore.getCount();i++)
		{
			var header=itemStore.getAt(i).get('itemDescript');
			var nodeObj=itemStore.getAt(i).get('itemObj');
			if (paramCols!="" ) {
				paramCols=paramCols+",";
				inPamCols=inPamCols+",";
			}
			paramCols=paramCols+nodeObj.id;
			inPamCols=inPamCols+itemStore.getAt(i).get('inPam');
		}
		//1、日期区间
		var dateItem=Ext.getCmp("detailComboDateItem").getValue();
		if (dateItem.indexOf("]")>=0 ) {
			dateItem=dateItem.split("[")[1];
			dateItem=dateItem.split("]")[0];	
		}		
		
		
		var startDate=Ext.getCmp("detailStartDate").getValue().format('Y-m-d');
		var endDate=Ext.getCmp("detailEndDate").getValue().format('Y-m-d');	

		//2、过滤grid
		var filterIDs="";
		var filterOperas="";
		var filterValues="";
		var inPamfilter="";
		for(var i=0;i<filterStore.getCount();i++)
		{
			var logicalOperators=filterStore.getAt(i).get('logicalOperators');
			var nodeObj=filterStore.getAt(i).get('itemObj');
			var filterV=filterStore.getAt(i).get('filterV');
			if (filterIDs!="") {
				inPamfilter=inPamfilter+",";
				filterIDs=filterIDs+",";
				filterOperas=filterOperas+",";
				filterValues=filterValues+",";
			}
			
			inPamfilter=inPamfilter+filterStore.getAt(i).get('inPam');
			filterIDs=filterIDs+nodeObj.id;
			filterOperas=filterOperas+logicalOperators;;
			filterValues=filterValues+filterV;
		}
		
		var qryObjName=Ext.getCmp("ComboQryObjName").getValue();
					
		if (qryObjName.indexOf("]")>=0 ) {
			qryObjName=qryObjName.split("[")[1];
			qryObjName=qryObjName.split("]")[0];	
		}					
 	

		var strParams='&qryObjName='+qryObjName+'&paramCols='+paramCols;
		strParams=strParams+'&inPamCols='+inPamCols+'&daterangeItem='+dateItem+'&daterangeStart='+startDate+'&daterangeEnd='+endDate+'&rptName='+rptName;
		strParams=strParams+'&filterIDs='+filterIDs+'&filterOperas='+filterOperas+'&filterValues='+filterValues+'&inPamfilter='+inPamfilter+'&qryType='+qryType;
		
		//src = encodeURI('dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-BaseDataQryDetail.raq'+strParams );	
		src = 'dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-BaseDataQryDetail.raq'+strParams ;	
		var outputContainer=Ext.getCmp("outputContainer");	
		outputContainer.removeAll();
		outputContainer.add(
		{
				title: '查询结果',
				id:'runqianRptDetail',    
				frameName: 'runqianRptDetail',		
				html: '<iframe id="runqianRptDetail" width=100% height=100% src="'+src+'"></iframe>',	
				autoScroll: true				
		})		
		outputContainer.doLayout();
		
		//src = 'dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-BaseDataQryDetail.raq';	

		/*
		var outputContainer=Ext.getCmp("outputContainer");	
		outputContainer.removeAll();
		outputContainer.add(
		{
				title: '查询结果',
				id:'runqianRptDetail',    
				frameName: 'runqianRptDetail',		
				html: '<iframe id="runqianRptDetail" width=100% height=100% ></iframe>',	
				autoScroll: true				
		})		
		outputContainer.doLayout();		

		var gridContainer=Ext.getCmp("outputContainer");
		var iframe = gridContainer.el.dom.getElementsByTagName("iframe")[0];
		iframe.src = 'dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-BaseDataQryDetail.raq'+strParams ;
		outputContainer.doLayout();	
		*/
	}
	
	
	function OnQryDeatilData() {
		rebuildStoreAndCol("detail");
	}

	function OnQryAggregatData() {
		rebuildStoreAndCol("aggregat");
	}
	
	
   
	function rebuildStoreAndCol(qryType){
		
		var preDetailViewColumnModel = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(),
			{header:'ID',dataIndex:'ID',sortable:true, width: 30, sortable: true,menuDisabled : true
			},{header:'名称',dataIndex:'Name',sortable:true, width: 160, sortable: true,menuDisabled : true
			},{header:'描述',dataIndex:'Descript', width: 160, sortable: true,menuDisabled : true
			}
		]);
		
		var preDetailViewStore = new Ext.data.Store({
			//proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=getPreviewData&start=0&limit=50'}),
			proxy: new Ext.data.HttpProxy({
				url:serviceUrl,
				listeners:{
					'exception':function(proxy,type,action,options,response,arg ){
						DetailDataQryCfgPanel.body.unmask();
						try {
							jsonData = Ext.util.JSON.decode(response.responseText);
							Ext.Msg.alert("提示",jsonData.MSG);
						} catch (e) {
							Ext.Msg.show({
										title : '错误',
										msg : "处理响应数据失败！响应数据为：\n"
												+ (response.responseText),
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
							return;
						}					
					}	
				}				
				
				}),
			reader: new Ext.data.JsonReader({
				totalProperty: 'totalNum',
				root: 'root',
				fields:[
					{name: 'ID'},
					{name: 'Name'},
					{name: 'Descript'},
				]
			})
		});		
	
		var preDetailViewGrid = new Ext.grid.GridPanel({
			//height:480,
			title:'查询结果',
			store: preDetailViewStore,
			cm: preDetailViewColumnModel,
			bbar: new Ext.PagingToolbar({
				pageSize:50,
				store:preDetailViewStore,
				displayInfo:true,
				displayMsg:'{0}~{1}条,共 {2} 条',
				emptyMsg:'sorry,data not found!',
				items: [

				]
			})
		});		
	
		var aryColCfg=new Array();
		aryColCfg.push(new Ext.grid.RowNumberer());
		var fields=new Array();
		var paramCols="";
		var inPamCols="";
		for(var i=0;i<itemStore.getCount();i++)
		{
			var header=itemStore.getAt(i).get('itemDescript');
			var nodeObj=itemStore.getAt(i).get('itemObj');
			if (paramCols!="" ) {
				paramCols=paramCols+",";
				inPamCols=inPamCols+",";
			}
			paramCols=paramCols+nodeObj.id;
			inPamCols=inPamCols+itemStore.getAt(i).get('inPam');
			var field={name:nodeObj.id};
			fields.push(field);	//重建store中的field
			
			//重建ColumnModel中的Column
			var col=new Ext.grid.Column({
							header: header,
							dataIndex: nodeObj.id,
							width: 100
				});
			aryColCfg.push(col);	
		}
		//重建reader

		preDetailViewGrid.getStore().reader=new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
			fields:fields
		})

		//重建ColumnModel中的Column
		preDetailViewGrid.getColumnModel().setConfig(aryColCfg) ;	
		
		preDetailViewGrid.getStore().on('load', function(store,records,options) {
			DetailDataQryCfgPanel.body.unmask();
		});		
		preDetailViewGrid.getStore().on('exception', function(misc) {
			//DetailDataQryCfgPanel.body.unmask();
		});			
		
		
		//return;
		//过滤规则
		
		//1、日期区间

		var dateItem=Ext.getCmp("detailComboDateItem").getValue();
		if (dateItem.indexOf("]")>=0 ) {
			dateItem=dateItem.split("[")[1];
			dateItem=dateItem.split("]")[0];	
		}		
		
		var startDate=Ext.getCmp("detailStartDate").getValue().format('Y-m-d');	
		var endDate=Ext.getCmp("detailEndDate").getValue().format('Y-m-d');	

		//2、过滤grid
		var filterIDs="";
		var filterOperas="";
		var filterValues="";
		var inPamfilter="";
		for(var i=0;i<filterStore.getCount();i++)
		{
			var logicalOperators=filterStore.getAt(i).get('logicalOperators');
			var nodeObj=filterStore.getAt(i).get('itemObj');
			var filterV=filterStore.getAt(i).get('filterV');
			if (filterIDs!="") {
				inPamfilter=inPamfilter+",";
				filterIDs=filterIDs+",";
				filterOperas=filterOperas+",";
				filterValues=filterValues+",";
			}
			
			inPamfilter=inPamfilter+filterStore.getAt(i).get('inPam');
			filterIDs=filterIDs+nodeObj.id;
			filterOperas=filterOperas+logicalOperators;;
			filterValues=filterValues+filterV;
		}
		

					   
		var qryObjName=Ext.getCmp("ComboQryObjName").getValue();
		
		if (qryObjName.indexOf("]")>=0 ) {
			qryObjName=qryObjName.split("[")[1];
			qryObjName=qryObjName.split("]")[0];	
		}		
		
		preDetailViewGrid.getStore().setBaseParam("qryObjName",qryObjName);		//查询对象
		preDetailViewGrid.getStore().setBaseParam("paramCols",paramCols);		//统计项
		preDetailViewGrid.getStore().setBaseParam("inPamCols",inPamCols);
		
		
		
		preDetailViewGrid.getStore().setBaseParam("action","previewDetailData");

		preDetailViewGrid.getStore().setBaseParam("daterangeItem",dateItem);			//查询日期字段
		preDetailViewGrid.getStore().setBaseParam("daterangeStart",startDate);			//查询日期开始
		preDetailViewGrid.getStore().setBaseParam("daterangeEnd",endDate);			//查询日期结束
		
		
		preDetailViewGrid.getStore().setBaseParam("filterIDs",filterIDs);			//过滤项标识
		preDetailViewGrid.getStore().setBaseParam("filterOperas",filterOperas);		//过滤项操作费
		preDetailViewGrid.getStore().setBaseParam("filterValues",filterValues);		//过滤值		
		preDetailViewGrid.getStore().setBaseParam("inPamfilter",inPamfilter);
		preDetailViewGrid.getStore().setBaseParam("qryType",qryType);
		preDetailViewGrid.getStore().removeAll();
		preDetailViewGrid.getStore().reload({params:{start:0,limit:50}});
		
		DetailDataQryCfgPanel.body.mask("正在读取数据，请稍候！");
		//DetailDataQryCfgPanel.body.unmask();
		
		var outputContainer=Ext.getCmp("outputContainer");			
		outputContainer.removeAll();
		outputContainer.add(preDetailViewGrid);
		outputContainer.doLayout();		
	}
	
 


	function OnSaveAsRptCfg() {
		
			var initAttrib=new Object();
			initAttrib.rptType="grpRpt";
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

		var paramCols="";
		var tStore=itemStore;
		for(var i=0;i<tStore.getCount();i++)
		{
			var nodeObj=tStore.getAt(i).get('itemObj');
			var inPam=tStore.getAt(i).get('inPam');
			if (paramCols!="") paramCols=paramCols+","
			paramCols=paramCols+nodeObj.id+"("+inPam+")";
		}			

		//4、区间		
		var daterangeItem=Ext.getCmp("detailComboDateItem").getValue();
		
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
		
		var qryObjName=Ext.getCmp("ComboQryObjName").getValue();
		
		if (qryObjName.indexOf("]")>=0 ) {
					qryObjName=qryObjName.split("[")[1];
					qryObjName=qryObjName.split("]")[0];
		}		
							

		var isAggregat=0;
		if(Ext.getCmp("chkAggregat").getValue()) isAggregat=1;	//是否聚合
		
		dhcwl.mkpi.Util.ajaxExc(serviceUrl,
		{
			action:action,
			rptType:"grpRpt",
			recAct:recAct,			//插入还是更新
			rptName:inRptName,
			qryObjName:qryObjName,//查询对象
			paramCols:paramCols,//列条件
			daterangeItem:daterangeItem,//查询日期字段
			filterIDs:filterIDs,//过滤项标识
			IsAggregat:isAggregat,//是否聚合
			Remarks:remarks	//备注
		},function(jsonData){
			if(jsonData.success==true && jsonData.tip=="ok"){
				Ext.Msg.alert("提示","操作成功！");
				rptName=inRptName;
				DetailDataQryCfgPanel.setTitle("网格/分组表格显示——"+rptName);
				//CloseWins();
			}else{
				Ext.Msg.alert("操作失败",jsonData.MSG);
			}
		},this);			
	}

 	function OnLoadRptCfg() {
		var saveWin=new dhcwl.BDQ.SaveAsWin(outThis);

		var initAttrib=new Object();
		initAttrib.rptType="grpRpt";
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
				DetailDataQryCfgPanel.setTitle("网格/分组表格显示——"+rptName);
			}else{
				Ext.Msg.alert("操作失败",jsonData.MSG);
			}
		},this);
	}
	
	function updateGrids(cfgData) {
		itemStore.removeAll();
		filterStore.removeAll();
		//preDetailViewGrid.getStore().removeAll();
		
		var baseObjName=cfgData.baseObjName;
		var baseObjNameDesc=cfgData.baseObjNameDesc;
		Ext.getCmp("ComboQryObjName").setValue(baseObjNameDesc+"["+baseObjName+"]");
		var dateItemName=cfgData.DateItemName;
		var dateItemNameDesc=cfgData.dateItemNameDesc;
		
		refreshTree(baseObjName);
		
		var curDate=dhcwl.mkpi.Util.nowDate();
		Ext.getCmp("detailStartDate").setValue(curDate);
		Ext.getCmp("detailEndDate").setValue(curDate);
		
		delete comboDateItem.lastQuery;				
		comboDateItem.getStore().setBaseParam("qryObjName",baseObjName);	//更新日期区间过滤
		comboDateItem.getStore().reload();
		comboDateItem.setValue(dateItemNameDesc+"["+dateItemName+"]");

		var isAggregat=false;
		if (cfgData.IsAggregat=="1") isAggregat=true;
		if(Ext.getCmp("chkAggregat").setValue(isAggregat));
		
		
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
				itemDescript: descript,
				itemObj: node//,
				//inPam:inPam
			};			
			
			if(aryRptsub[i].type=="col") {
				var inPam=item.split("(")[1].split(")")[0];
				insData.inPam=inPam;
				var p = new itemStore.recordType(insData); // create new record
				var pos=itemStore.getCount()
				itemStore.insert(pos, p); 					
			}			
			
			if(aryRptsub[i].type=="filter") {
				var inPam=item.split("(")[1].split(")")[0];
				insData.inPam=inPam;
				insData.Descript=descript;
				insData.logicalOperators=item.split("^")[1];
				insData.filterV=item.split("^")[2];
				var p = new filterStore.recordType(insData); // create new record
				var pos=filterStore.getCount()
				filterStore.insert(pos, p); 					
			}
		}
	
	}
	
	function OnShowHelpData()
	{
		var helpDataObj=new dhcwl.BDQ.HelpData()
		var helpDataWin=helpDataObj.getHelpDataWin();
		helpDataWin.show();

	}
	
    this.getDetailDataQryCfgPanel=function(){
    	return DetailDataQryCfgPanel;
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

