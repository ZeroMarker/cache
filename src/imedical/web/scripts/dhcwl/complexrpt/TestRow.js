(function(){
	Ext.ns("dhcwl.complexrpt.TestRow");
})();
dhcwl.complexrpt.TestRow=function(rptCode,rptName){
	this.rptCode=rptCode,this.rptName=rptName;

	/// 初始化节点提示qtip
	//if(!Ext.isIE){Ext.QuickTips.init();}
	var outthis=this;
	var parentWin;
	var rptCodes='';
	var preUrl="dhcwl/complexrpt/";

	/// 统计项模型定义:列
	var columnModelItem = new Ext.grid.ColumnModel([
        {header:'名称',dataIndex:'statItemDesc', width: 165, autoWidth:true, sortable: false
        },{header:'编码',dataIndex:'statItemCode', width: 105, sortable: false
        }
    ]);
    
    /// 统计项模型定义:行
	var rowModelItem = new Ext.grid.ColumnModel([
        {header:'名称',dataIndex:'statItemDesc', width: 165, autoWidth:true, sortable: false
        },{header:'编码',dataIndex:'statItemCode', width: 105, sortable: false
        }
    ]);

    //var sm=new Ext.grid.RowSelectionModel({singleSelect:true});
    var storeItemRow = new Ext.data.Store({
    	autoLoad : true,
        proxy: new Ext.data.HttpProxy({url:preUrl+'rptdimservice.csp?action=getRptCfg&rptCode='+outthis.rptCode+'&codeType=Row'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
            	{name: 'statItemCode'},
            	{name: 'statItemDesc'}
       		]
    	})
    });
    
    var storeItemCol = new Ext.data.Store({
    	autoLoad : true,
        proxy: new Ext.data.HttpProxy({url:preUrl+'rptdimservice.csp?action=getRptCfg&rptCode='+outthis.rptCode+'&codeType=Col'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
            	{name: 'statItemCode'},
            	{name: 'statItemDesc'}
       		]
    	})
    });
    var itemRecorde= Ext.data.Record.create([
        {name: 'statItemCode', type: 'string'},
        {name: 'statItemDesc', type: 'string'}
	]);
	
	
	/// 统计内容模型定义
	var columnModelContext = new Ext.grid.ColumnModel([
        {header:'统计内容名称',dataIndex:'statDesc', width: 125, sortable: false //不允许排序
        },{header:'统计内容编码',dataIndex:'statCode', width: 105, sortable: false 
        }
    ]);

    //var sm=new Ext.grid.RowSelectionModel({singleSelect:true});
    var storeContext = new Ext.data.Store({
    	//autoLoad : true,
        proxy: new Ext.data.HttpProxy({url:preUrl+'statitemservice.csp?action=mulSearch&statType=C&statFlag=Y'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
            	{name: 'statCode'},
            	{name: 'statDesc'}
       		]
    	})
    });
    
      var selContentstore = new Ext.data.Store({
    	autoLoad : true,
        proxy: new Ext.data.HttpProxy({url:preUrl+'rptdimservice.csp?action=getRptCfgContent&rptCode='+outthis.rptCode+'&codeType=Content'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
            	{name: 'statCode'},
            	{name: 'statDesc'}
       		]
    	})
    });
    
//    storeItemCol.on({
//    	'load':function(store,records ){
//    		 alert(store.getAt(0).get('statItemDesc'));
//    		 alert(records[0].get('statItemDesc'));
//    		statModeCombo.setValue(records[0].get('statItemDesc'))
//    	}
//	});
    
    var contextRecorde= Ext.data.Record.create([
        {name: 'statCode', type: 'string'},
        {name: 'statDesc', type: 'string'}
	]);
	
	
	/// 待选的统计内容GridPanel
	var choicedSearcheCond="",searcheValue="";
    var contextListPanel = new Ext.grid.GridPanel({
    	title:'统计内容选项',
        id:"contextListPanel",
        width:288,
        height:420,
        resizeAble:true,
        collapsed:true,
        //autoHeight:true,
        enableColumnResize :true,
        store: storeContext,
        cm: columnModelContext,
        autoScroll: true,
//        bbar:new Ext.PagingToolbar({
//            pageSize: 6,
//            store: storeContext,
//            displayInfo: true,
//            displayMsg: '共{2}条',
//            emptyMsg: "没有记录"
//        }),
        listeners:{
        	"rowdblclick":function(pGrid,pIndex,pEvent){
        		var sm=contextListPanel.getSelectionModel();
        		if(!sm) return;
        		var record = sm.getSelected();
        		if(!record) return;
                var contextCode=record.get("statCode");
                var contextDesc=record.get("statDesc");
                var selStore=selectedContextPanel.getStore();
                if (!checkDataSame(contextCode,selStore)){
                	var recordeData={"statCode":contextCode,"statDesc":contextDesc};
                	selStore.add(new contextRecorde(recordeData));
                }else{
                	Ext.Msg.show({title:'注意',msg:'已选择此项目，不能重复选择！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
                }
        	}
        }
        /*
        tbar: new Ext.Toolbar(
        ['搜索：',
        	{
	        	id:'setSearcheCont',
	        	width: 110,
				xtype:'combo',
	        	mode:'local',
	        	emptyText:'请选择搜索类型',
	        	triggerAction:  'all',
	        	forceSelection: true,
	        	editable: false,
	        	displayField:'name',
	        	valueField:'value',
	        	store:new Ext.data.JsonStore({
	        		fields:['name', 'value'],
	            	data:[
	            		{name : '统计内容代码', value: 'Code'},
	                	{name : '统计内容名称', value: 'Name'}
	         		]
	         	}),
	             	listeners:{
	        			'select':function(combo){
	        				choicedSearcheCond=combo.getValue(); //valueField: ele.getValue(); //displayField: combo.getRawValue()
	        			}
	        		}
			},'&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp',{
					id:'setSearcheContValue',
					width:100,
	        		xtype: 'textfield',
	            	//flex : 1,
	            	enableKeyEvents: true,
	            	allowBlank: true,
	            	listeners :{
	            		'keypress':function(ele,event){
	            			searcheValue=Ext.get("setSearcheContValue").getValue();
	            			//按键的ASCII值等回车键的ASCII值时检索数据
	            			if ((event.getKey() == event.ENTER)){
	            				storeContext.proxy.setUrl(encodeURI(preUrl+"statitemservice.csp?action=singleSearche&searcheCond="+choicedSearcheCond+"&searcheValue="+searcheValue+"&statType=C"+"&statFlag=Y"+"&start=0&limit=6"));
	            				storeContext.load();
	            				contextListPanel.show();
	            			}
	            		}
	           		}
	    	}
        ])*/
    });
   storeContext.load({params:{start:0,limit:6}});
   
	/// 已选的统计内容GridPanel
    var selectedContextPanel = new Ext.grid.GridPanel({
    	title:'选中的统计内容',
        id:"selectedContextPanel",
        width:238,
        height:308,
        //resizeAble:true,
        cm: columnModelContext,
        sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
        //store: new Ext.data.ArrayStore({}),
        store:selContentstore,
        enableColumnResize :true,
        listeners:{
        	"rowdblclick":function(pGrid,pIndex,pEvent){
        		var sm=selectedContextPanel.getSelectionModel();
        		if(!sm) return;
        		var record = sm.getSelected();
        		if(!record) return;
                selectedContextPanel.getStore().removeAt(pIndex);
        	}
        }
    });
    
    /// 统计模式下拉列表
    var statModeCombo=new Ext.form.ComboBox({
    	id : 'statModeCombo',
		width : 140,
		editable:false,
		xtype : 'combo',
		mode : 'remote',
		triggerAction : 'all',
		emptyText:'请选择报表统计模式',
		name : 'statModeCombo',
		displayField : 'modeDesc',
		valueField : 'modeCode',
		store : new Ext.data.Store({
			autoLoad : true,
			proxy:new Ext.data.HttpProxy({url:'dhcwl/complexrpt/rptdimservice.csp?action=getStatModeCombo'}),
			reader:new Ext.data.ArrayReader({},[{name:'modeCode'},{name:'modeDesc'}])
		}),
		listeners :{
//			'select':function(combox){
//				//statModeCombo.setValue(combox.getRawValue());
//			},
			'afterrender': function(combo) {
				url=encodeURI('dhcwl/complexrpt/rptdimservice.csp?action=getRptCfgMode&rptCode='+outthis.rptCode);
  				dhcwl.complexrpt.Util.ajaxExc(url,{},
					function(jsonData){
						if(jsonData.success==true && jsonData.tip=="ok"){
							var statDatas=jsonData.data;
							if(statDatas[1]){
								combo.setValue(statDatas[0].modeCode);
								combo.setRawValue(statDatas[1].modeDesc);
							}else{
								return;
							}
						}else{
							return;
						}
					},this);
          }
		}
	});
	
		//带待选统计模式的表单
   		var modeForm=new Ext.FormPanel({
        //id: 'kpi-list',
    	height: 58,
        frame: true,
        //autoScroll:true,
        //labelAlign: 'left',
        bodyStyle:'padding:5px',
        //defaultConfig:{width:110},
        layout: 'table',
        layoutConfig: {columns:3},
        items:[{
            html:'统计模式：'
        },statModeCombo]
	});
	
	//行列条件选择按钮
	rowColBar=new Ext.Toolbar([
           '条件类型：',
           	{
               name: 'rowflag',
               id:'rowcon',
               xtype: 'radiogroup',
               columns: [80, 80],
               vertical: true,
               items: [
                {boxLabel: '行条件', name: 'rowflag', inputValue: 1,checked: true},   
                {boxLabel: '列条件', name: 'rowflag',inputValue: 2}   
               ]
            }
        ])
	
	/// 已选的行条件GridPanel
    var selectedRowPanel = new Ext.grid.GridPanel({
    	title:'行条件',
        id:"selectedRowPanel",
        width:278,
        height:275,
        resizeAble:true,
        enableDragDrop:true,
        ddGroup: "RowGridDD",
        cm: rowModelItem,
        //viewConfig:{forceFit:true},
        sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
        //store: new Ext.data.ArrayStore({}),
        store: storeItemRow,
        enableColumnResize :true,
        listeners:{
        	"rowdblclick":function(pGrid,pIndex,pEvent){
        		var sm=selectedRowPanel.getSelectionModel();
        		if(!sm) return;
        		var record = sm.getSelected();
        		if(!record) return;
                selectedRowPanel.getStore().removeAt(pIndex);
                reflashcolWith(selectedRowPanel,0,"statItemDesc");
        	},
        	"contextmenu":function(e){
        		var sm=selectedRowPanel.getSelectionModel();
        		if(!sm) return;
        		var record = sm.getSelected();
        		if(!record) return;
                var target = e.getTarget();  
                e.stopEvent() ;  
                var view = selectedRowPanel.getView(); 
                rowIndex = view.findRowIndex(target); 
				rowMenu.showAt(e.getXY());
            }
        }
    });

    /// 已选的列条件GridPanel
    var selectedColPanel = new Ext.grid.GridPanel({
    	title:'列条件',
        id:"selectedColPanel",
        width:278,
        height:275,
        resizeAble:true, //是否允许改变列宽
        enableColumnMove:false, //是否列拖放
        enableDragDrop:true,
        ddGroup: "ColGridDD",
        cm: columnModelItem,
        sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
        store: storeItemCol,
        enableColumnResize :true,
//		dropConfig: {
//			appendOnly:true
//		},
        listeners:{
        	"rowdblclick":function(pGrid,pIndex,pEvent){
        		var sm=selectedColPanel.getSelectionModel();
        		if(!sm) return;
        		var record = sm.getSelected();
        		if(!record) return;
                selectedColPanel.getStore().removeAt(pIndex);
                reflashcolWith(selectedColPanel,0,"statItemDesc");
        	},
        	"contextmenu":function(e){
        		var sm=selectedColPanel.getSelectionModel();
        		if(!sm) return;
        		var record = sm.getSelected();
        		if(!record) return;
                var target = e.getTarget(); //获得HTMLelement
                e.stopEvent();
                var view = selectedColPanel.getView();
                rowIndex = view.findRowIndex(target);
                colMenu.showAt(e.getXY());
            }

        }
    });
    
    // 渲染selectedColPanel列
    selectedColPanel.on('render', function(grid){
		var store = grid.getStore();  // Capture the Store.
		var view = grid.getView();    // Capture the GridView.
		selectedColPanel.tip = new Ext.ToolTip({
			target: view.mainBody,    // The overall target element.
			delegate: '.x-grid3-row', // Each grid row causes its own seperate show and hide.
			trackMouse: true,         // 跟随鼠标移动   
			renderTo: document.body,  // Render immediately so that tip.body can be referenced prior to the first show.
			listeners: {              // Change content dynamically depending on which element triggered the show.
				beforeshow: function updateTipBody(tip){
					var rowIndex = view.findRowIndex(tip.triggerElement);
					tip.body.dom.innerHTML = "选中记录，拖动或右键可以改变顺序哦！";
				}
			}
		});
		// 拖拽改变顺序
		var colddrow = new Ext.dd.DropTarget(grid.getEl(),{
        	ddGroup : 'ColGridDD',
        	copy    : false, //拖动是否带复制属性
        	notifyDrop : function(dd, e, data){ //对应的函数处理拖放事件
            	var row = data.selections;
            	var index = dd.getDragData(e).rowIndex;
            	if (typeof(index)!=typeof(1)) { //选中的区域不合适就退出
                	return false;
            	}
            	// 修改store
            	var array=[];
            	for(var i=0;i<row.length;i++){
                	var cindex = index+i;
                	array.push(cindex);
            		if(!this.copy) grid.getStore().remove(row[i]);
            		grid.getStore().insert(cindex, row[i]);
            	}
            	var sm = Ext.getCmp('selectedColPanel').getSelectionModel();
            	sm.clearSelections();
            	grid.getView().refresh(); //刷新
            	grid.getSelectionModel().selectRows(array);
            	//updateIndex();
            	return true;
        	}
    	});
    	// 从树拖拽添加列条件
    	// grid.getView().scroller.dom 或者 grid.getView().el.dom
    	var rowddrow = new Ext.dd.DropTarget(grid.getView().el.dom,{
        	ddGroup : 'treeGridDD', //拖拽源
        	copy    : false, //拖动是否带复制属性
        	notifyDrop : function(dd, e, data){ //对应的函数处理拖放事件
        			if(!dd.dragData.node){
        				return false;
        			}
        		var sFlag=Ext.getCmp('rowcon').getValue().inputValue;
        		if (sFlag==2){
        			var cNode=dd.dragData.node;
            		//var pNode=cNode.parentNode;
            		var rowcolData=getSelRuleValue(cNode);
            		if (!checkNodeSame(rowcolData,grid.getStore())){
						var recordeData={"statItemDesc":rowcolData[0],"statItemCode":rowcolData[1]};
                		grid.getStore().add(new itemRecorde(recordeData));
                		reflashcolWith(selectedColPanel,0,"statItemDesc");
            			grid.getView().refresh(); //刷新
            		}else{
            			Ext.Msg.show({title:'注意',msg:'已选择此项目，不能重复选择！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
            		}
            		
        		}else{
        			Ext.Msg.show({title:'注意',msg:'请先选中【列条件】，然后再拖拽！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
        		}
        		return true;
        	}
    	});
	});
	
	
    // 渲染selectedRowPanel行
    selectedRowPanel.on('render', function(grid){
		var store = grid.getStore();  // Capture the Store.
		var view = grid.getView();    // Capture the GridView.
		selectedRowPanel.tip = new Ext.ToolTip({
			target: view.mainBody,    // The overall target element.
			delegate: '.x-grid3-row', // Each grid row causes its own seperate show and hide.
			trackMouse: true,         // 跟随鼠标移动   
			renderTo: document.body,  // Render immediately so that tip.body can be referenced prior to the first show.
			listeners: {             // Change content dynamically depending on which element triggered the show.
				beforeshow: function updateTipBody(tip){
					var rowIndex = view.findRowIndex(tip.triggerElement);
					tip.body.dom.innerHTML = "选中记录，拖动或右键可以改变顺序哦！";
				}
			}
		});

		// 拖拽改变顺序
		var rowddrow = new Ext.dd.DropTarget(grid.getEl(),{
        	ddGroup : 'RowGridDD',
        	copy    : false, //拖动是否带复制属性
        	notifyDrop : function(dd, e, data){ //对应的函数处理拖放事件
            	var row = data.selections;
            	var index = dd.getDragData(e).rowIndex;
            	if (typeof(index)!=typeof(1)) { //选中的区域不合适就退出
                	return false;
            	}
            	// 修改store
            	var array=[];
            	for(var i=0;i<row.length;i++){
                	var cindex = index+i;
                	array.push(cindex);
            		if(!this.copy) grid.getStore().remove(row[i]);
            		grid.getStore().insert(cindex, row[i]); // 开始插入位置index
            	}
            	var sm = Ext.getCmp('selectedRowPanel').getSelectionModel();
            	sm.clearSelections();
            	grid.getView().refresh(); //刷新
            	grid.getSelectionModel().selectRows(array); //选中拖动前的行
            	//updateIndex();
        	}
    	});
    	// 从树拖拽添加行条件
    	// var DropTargetEl = this.getView ().el.dom.childNodes [0].childNodes [1];
    	// grid.getView().scroller.dom.scrollTop 滚动条顶部
    	var rowddrow = new Ext.dd.DropTarget(grid.getView().el.dom,{
        	ddGroup : 'treeGridDD', //拖拽源
        	copy    : false, //拖动是否带复制属性
        	notifyDrop : function(dd, e, data){ //对应的函数处理拖放事件
        			if(!dd.dragData.node){
        				return false;
        			}
        		var sFlag=Ext.getCmp('rowcon').getValue().inputValue;
        		if (sFlag==1){
        			var cNode=dd.dragData.node;
            		//var pNode=cNode.parentNode;
            		var rowcolData=getSelRuleValue(cNode);
            		if (!checkNodeSame(rowcolData,grid.getStore())){
						var recordeData={"statItemDesc":rowcolData[0],"statItemCode":rowcolData[1]};
                		grid.getStore().add(new itemRecorde(recordeData));
                		reflashcolWith(selectedRowPanel,0,"statItemDesc");
            			grid.getView().refresh(); //刷新
            		}else{
            			Ext.Msg.show({title:'注意',msg:'已选择此项目，不能重复选择！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
            		}
            		
        		}else{
        			Ext.Msg.show({title:'注意',msg:'请先选中【行条件】，然后再拖拽！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
        		}
        		return true;
        	}
    	});
	});
    
	/*
    //拖动排序代码
   var drogAndDrap = new Ext.dd.DropTarget(selectedColPanel.getEl(),{
        ddGroup : 'GridDD',
        copy    : false,
        notifyDrop : function(dd, e, data) {
            var rows = data.selections;
            var index = dd.getDragData(e).rowIndex;
            if (typeof(index)!=typeof(1)) {
                return;
            }
            //确定正序还是倒序
            var mark = true;
            gridIndex = StoreMain.indexOf(rows[0]);
            if(index<gridIndex) mark = false;
            
            for(i = 0; i < rows.length; i++) {
           	 var rowData;
            	if(mark){
            		rowData = rows[i];
                 }else{
                	rowData = rows[rows.length-i-1];
                }
                if(!this.copy) 
                    grid.getStore().remove(rowData);
                grid.getStore().insert(index, rowData);
            }
            var sm = Ext.getCmp('sortCriteriaListGrid').getSelectionModel();
            sm.clearSelections();
            selectedColPanel.getView().refresh();//刷新 
            //拖动结束后的处理逻辑
            //updateIndex();        
        }
    });
    */
    var colMenu = new Ext.menu.Menu({
    	boxMinWidth:80,
		ignoreParentClicks:true,
        items: [{
            text: '最上',
            iconCls: 'arrow-up-icon',
            handler: function(){
                if(rowIndex == 0) {
                    return;
                }
                var data = selectedColPanel.store.data.items[rowIndex].data;
                var record = new Ext.data.Record({
                    statItemCode:data.statItemCode,
                    statItemDesc: data.statItemDesc
                });
                selectedColPanel.getStore().removeAt(rowIndex);
                selectedColPanel.getStore().insert(0, record);
                //selectedColPanel.getSelectionModel().selectRow(0);  // 选中移动行
                selectedColPanel.getView().refresh();    
            },
            scope: this
        },{
            text: '上移',
            iconCls: 'arrow-upon-icon',
            handler: function(){
                if(rowIndex == 0) {
                    return;
                }
                var data = selectedColPanel.store.data.items[rowIndex].data;
                var record = new Ext.data.Record({
                    statItemCode:data.statItemCode,
                    statItemDesc: data.statItemDesc
                });
                selectedColPanel.getStore().removeAt(rowIndex);
                selectedColPanel.getStore().insert(rowIndex - 1, record);
                //selectedColPanel.getSelectionModel().selectRow(rowIndex - 1);
                selectedColPanel.getView().refresh();
            },
            scope: this
        }, {
            text: '下移',
            iconCls: 'arrow-downward-icon',
            handler: function(){
                if(rowIndex < selectedColPanel.getStore().getCount() - 1){
                    var data = selectedColPanel.store.data.items[rowIndex].data;
                    var record = new Ext.data.Record({
                    	statItemCode:data.statItemCode,
                    	statItemDesc: data.statItemDesc
                    });
                    selectedColPanel.getStore().removeAt(rowIndex);
                    selectedColPanel.getStore().insert(rowIndex + 1, record);
                    //selectedColPanel.getSelectionModel().selectRow(rowIndex + 1);
                    selectedColPanel.getView().refresh();
                }
            },
            scope: this
        },{
            text: '最下',
            iconCls: 'arrow-down-icon',
            handler: function(){
                if(rowIndex < selectedColPanel.getStore().getCount() - 1){
                    var data = selectedColPanel.store.data.items[rowIndex].data;
                    var record = new Ext.data.Record({
                    	statItemCode:data.statItemCode,
                    	statItemDesc: data.statItemDesc
                    });
                    selectedColPanel.getStore().removeAt(rowIndex);
                    selectedColPanel.getStore().insert((selectedColPanel.getStore().getCount()), record);
                    //selectedColPanel.getSelectionModel().selectRow((selectedColPanel.getStore().getCount()-1)); // 选中移动行
                    selectedColPanel.getView().refresh();
                }
            },
            scope: this
        }]
    });
    var rowMenu = new Ext.menu.Menu({
    	boxMinWidth:80,
		ignoreParentClicks:true,
        items: [{
            text: '最上', 
            iconCls: 'arrow-up-icon',  
            handler: function(){
                if(rowIndex == 0) {
                    return;
                }
                var data = selectedRowPanel.store.data.items[rowIndex].data;
                var record = new Ext.data.Record({
                    statItemCode:data.statItemCode,
                    statItemDesc: data.statItemDesc
                });
                selectedRowPanel.getStore().removeAt(rowIndex);
                selectedRowPanel.getStore().insert(0, record);
                //selectedRowPanel.getSelectionModel().selectRow(0);  // 选中移动行
                selectedRowPanel.getView().refresh();    
            },
            scope: this
        },{ 
            text: '上移', 
            iconCls: 'arrow-upon-icon',  
            handler: function(){ 
                if(rowIndex == 0) { 
                    return; 
                } 
                var data = selectedRowPanel.store.data.items[rowIndex].data; 
                var record = new Ext.data.Record({ 
                    statItemCode:data.statItemCode, 
                    statItemDesc: data.statItemDesc
                }); 
                selectedRowPanel.getStore().removeAt(rowIndex);  
                selectedRowPanel.getStore().insert(rowIndex - 1, record);  
                //selectedRowPanel.getSelectionModel().selectRow(rowIndex - 1);  
                selectedRowPanel.getView().refresh();        
            }, 
            scope: this 
        }, 
        { 
            text: '下移', 
            iconCls: 'arrow-downward-icon',  
            handler: function(){ 
                if(rowIndex < selectedRowPanel.getStore().getCount() - 1){ 
                    var data = selectedRowPanel.store.data.items[rowIndex].data; 
                    var record = new Ext.data.Record({
                    	statItemCode:data.statItemCode, 
                    	statItemDesc: data.statItemDesc
                    }); 
                    selectedRowPanel.getStore().removeAt(rowIndex);  
                    selectedRowPanel.getStore().insert(rowIndex + 1, record);  
                    //selectedRowPanel.getSelectionModel().selectRow(rowIndex + 1);  
                    selectedRowPanel.getView().refresh();        
                } 
            }, 
            scope: this 
        },{
            text: '最下',
            iconCls: 'arrow-down-icon',
            handler: function(){
                if(rowIndex < selectedRowPanel.getStore().getCount() - 1){
                    var data = selectedRowPanel.store.data.items[rowIndex].data;
                    var record = new Ext.data.Record({
                    	statItemCode:data.statItemCode,
                    	statItemDesc: data.statItemDesc
                    });
                    selectedRowPanel.getStore().removeAt(rowIndex);
                    selectedRowPanel.getStore().insert((selectedRowPanel.getStore().getCount()), record);
                    //selectedRowPanel.getSelectionModel().selectRow((selectedColPanel.getStore().getCount()-1)); // 选中移动行
                    selectedRowPanel.getView().refresh();
                }
            },
            scope: this
        }] 
    });

    
    // 过滤表达式
    emptyOutputValue = '过滤表达式......';
    var textZone = new Ext.form.TextArea({
		id:'colTextZone',
		title:'输出',
		width:600,
		height:135,
		enableKeyEvents:true,
		value:emptyOutputValue,
		maskRe:/37|38|39|40/,   // 键盘键左右上下
		listeners :{
			'afterrender': function(textZone) {
				url=encodeURI('dhcwl/complexrpt/rptdimservice.csp?action=getRptCfgFilter&rptCode='+outthis.rptCode);
  				dhcwl.complexrpt.Util.ajaxExc(url,{},
					function(jsonData){
						if(jsonData.success==true && jsonData.tip=="ok"){
							var statDatas=jsonData.data;
							if(statDatas[0]){
								textZone.setValue(statDatas[0].filterStr);
							}else{
								return;
							}
						}else{
							return;
						}
					},this);
          }
		}
	});
	
	var outputPanel = new Ext.Panel({
		title:'过滤条件',
		width:790,
		height:173,
		frame:true,
		monitorResize:true,
		layout:'border',
		items:[{region:'center',
			items:textZone
		},{
			region:'east',
			width:150,
			//layout:'table',
			//layoutConfig:{columns:1},
			items:[{
				html:'',
				height:20
			},{
				width:60,
				frame:'true',
				height:25,

				text: '<span style="line-Height:1">过滤条件</span>',
				icon   : '../images/uiimages/filter.png',
				xtype:'button',
				listeners:{
					'click':function(){
						var rptFilterCfg = new dhcwl.complexrpt.RptFilterCfg();
						var fill=textZone.getValue();
						if ((fill==emptyOutputValue)||(fill=="")){
							rptFilterCfg.show();
						}else{
							Ext.getCmp('textZone').setValue(fill);
							rptFilterCfg.show();
						}
						
					}
				}
			},{
				html:'',
				height:20
			},{
				width:60,
				frame:'true',
				height:25,

				text: '<span style="line-Height:1">清空数据</span>',
				icon   : '../images/uiimages/clearscreen.png',
				xtype:'button',
				listeners:{
					'click':function(){
						Ext.getCmp('colTextZone').setValue("");
					}
				}
			}]
		}]
		
	});
	
	/*
	//定义树的加载器 
        var treeLoader = new Ext.ux.tree.TreeGridLoader({ 
            dataUrl : "../Cost_JsonDb.ashx?tablename=boq_model&parentSysId=0" 
        });
      */
	//// 待选的统计项树
     //var tree = new Ext.ux.tree.TreeGrid({
	 var tree = new Ext.tree.TreePanel( {
		id:"cfgTreePanel",
		enableSort : false,
		autoScroll : true,
		animate : true,
		//enableDD : true,
		enableDrag : true,
		ddGroup : 'treeGridDD',
		//draggable : true, // 是否允许拖拽
		//loadMask:{msg:"数据加载中，请稍等..."},
		containerScroll : true,
		lines :true,
        columns:[{
            header: '描述',
            width: 155,
            dataIndex: 'text'
        },{
            header: '编码',
            width: 105,
            dataIndex: 'code'
        }],
        loader: new Ext.tree.TreeLoader()
//		loader: new Ext.tree.TreeLoader({
//			dataUrl : 'dhcwl/complexrpt/rptdimservice.csp?action=getStatTreeData'
//		})
		/*
		 * ////控制单选
		listeners:{
			"scope":this,
			"checkchange" : function(node, checked) {//传递两个参数,一个是当前节点,一个是当前节点的选中状态
				node.attributes.checked = checked;//将当前状态付给node
				var chs = tree.getChecked();//获取当前树中被选中的所有节点
				for (var i = 0; i < chs.length; i++) {//循环判断,
					if (chs[i].attributes['id'] != node.attributes['id']) {//第i个节点是否与刚刚选中的节点的id相同,
						chs[i].ui.toggleCheck(!checked);//如果不同,则执行checked的反操作,也就是选中了变成未选中
					}
				}
			}
		}
		*/
		});

    //var root = new Ext.tree.AsyncTreeNode({
	var root = new Ext.tree.TreeNode({
		code:"root",
		className:"",
	 	parentNO:'',
	 	NO:'root',
	 	//id:'root',
	    iconCls:'task-folder',
		text : '统计项目树',
		draggable : false,
	    expanded: true
		//checked :false
		  });
		
		tree.setRootNode(root);
//		tree.loader = new Ext.tree.TreeLoader({
//			dataUrl: encodeURI('dhcwl/complexrpt/rptdimservice.csp?action=getStatTreeData')
//		});
		
		//添加树事件
		tree.on({
			'dblclick':function(node, e){
				if(!node.hasChildNodes()){
					var rowcolData=getSelRuleValue(node);
					if(rowcolData.length==0){
						return;
                	}
					var sFlag=Ext.getCmp('rowcon').getValue().inputValue;
					if (sFlag==1){
						selStore=selectedRowPanel.getStore();
						selPanel=selectedRowPanel;
        			}
        			if (sFlag==2){
        				selStore=selectedColPanel.getStore();
        				selPanel=selectedColPanel;
        			}
                	var recordeData={"statItemDesc":rowcolData[0],"statItemCode":rowcolData[1]};
                	if (!checkNodeSame(rowcolData,selStore)){
                		selStore.add(new itemRecorde(recordeData));
                		reflashcolWith(selPanel,0,"statItemDesc");
                	}else{
                		Ext.Msg.show({title:'注意',msg:'已选择此项目，不能重复选择！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
                	}
         
        		}else{
                }
           	},
           	'click':function(node, e){
				//node.toggle(); //改变树节点的收缩与展开状态
				if((node.attributes.className=="DHCWL.ComplexRpt.StatItem")&&(!node.hasChildNodes())){
					treeStatCode=node.attributes.code;
					updateTree(treeStatCode,'dimProGrp','GetKpiDimAndPro');
					tree.expandPath(node.getPath()); // 展开某一节点 tree.getNodeById(node.id)
				}else{
					treeStatCode="";
					return;
				}
       		}
		});
		
       var treePanel = new Ext.Panel({
            //region: 'center',
            //margins:'3 3 3 0',
       		title:'统计项',
       		collapsed:true,
       		closeAction:'hide',
            layout:'fit',
            items:tree
        });
        
	var accordion = new Ext.Panel({
 		//region:'west',
    	//margins:'5 0 5 5',
		title : '统计项分类菜单：',
      	//split:true,
       	width: 290,
       	height : 423,
      	layout:'accordion',
      	items: [treePanel, contextListPanel]
	});
	
	/// 行列条件窗体
  	var rowPanel = new Ext.Panel({
		layout: {
        	type: 'table', 
        	columns: 2,
        	rowumns: 2
    	},
		items : [{
				rowspan: 1,
				colspan: 2,
				width : 560,
				height : 32,
				items : rowColBar
		},{
				colspan: 1,
				rowspan: 1,
				width : 280,
				height : 280,
				items : selectedRowPanel
		},{
				colspan: 1,
				rowspan: 1,
				width : 280,
				height : 280,
				items : selectedColPanel
		}]
  	});
        
    ///// 窗体1
  	var winPanel = new Ext.Panel({
		title : '',
		layout: {
        	type: 'table', 
        	columns: 3,
        	rowumns: 3
    	},
		items : [{
			rowspan: 2,
			items : [{
				//autoScroll : true,
				width : 290,
				height : 65,
				layout:'fit',
				items : modeForm
			},{
				width : 290,
				height : 425,
				items : accordion
			}]
								
		},{
				colspan: 1,
				rowspan: 1,
				width : 560,
				height : 310,
				items : rowPanel
		},{
				colspan: 1,
				rowspan: 1,
				width : 240,
				height : 310,
				items : selectedContextPanel
								
		},{
			colspan: 2,
			rowspan: 1,
			width : 800,
			height : 175,
			items : outputPanel
		}]
	});
			
	var rptCfgWin = new Ext.Window({
				id : 'rowmainWin',
				title : '报表行列条件配置',
				//autoShow : true,
				//expandOnShow : true,
				resizable : true,
				closable:true,
				plain:true,
        		columns: 1,
				width:1100,
				height:580,
				layout : 'column',
				modal:true,
				items:winPanel,
				buttons: [
	        	{
	            	text: '<span style="line-Height:1">保存</span>',
	            	icon   : '../images/uiimages/filesave.png',
	            	handler:OnConfirm
	        	},
	        	{
					text: '<span style="line-Height:1">关闭</span>',
	            	icon   : '../images/uiimages/cancel.png',
	            	handler: OnCancel
	        	}]
	        	//buttonAlign:"center",
		});
			
	rptCfgWin.on('afterrender',function(){
			updateTree(rptCodes,'dim','GetKpiDimAndPro');
	})
	
	function OnCancel(){
	     rptCfgWin.close();
	}
	
	function OnConfirm(){
		var paraValues;
		var outFilter = textZone.getValue();
		if (emptyOutputValue==outFilter){
			outFilter="";
		}
		var outRowStore=selectedRowPanel.getStore();
		var outColStore=selectedColPanel.getStore();
		var outContextStore=selectedContextPanel.getStore();
		var outRowString=GetStoreSpellStr(outRowStore,"statItemCode");
		var outColString=GetStoreSpellStr(outColStore,"statItemCode");
		var outContextString=GetStoreSpellStr(outContextStore,"statCode");
		var outMode=statModeCombo.getValue();
		if(outMode==""){
			Ext.Msg.show({title:'注意',msg:'统计模式不能为空！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		if(outRowString==""){
			Ext.Msg.show({title:'注意',msg:'报表行条件不能为空！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		if(outContextString==""){
			Ext.Msg.show({title:'注意',msg:'统计内容不能为空！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		//alert(outRowString+" ^ "+outColString+" ^ "+outContextString+" ^ "+outMode+" ^ "+outFilter+" ^ "+outthis.rptCode)
		paraValues='rptCode='+outthis.rptCode+'&rptMode='+outMode+'&rptContext='+outContextString+'&rptRow='+outRowString+'&rptCol='+outColString;
   		//dhcwl.complexrpt.Util.ajaxExc(preUrl+'rptcfgservice.csp?action=AddRptCfg&'+paraValues);
   		dhcwl.complexrpt.Util.ajaxExc(preUrl+'rptcfgservice.csp?action=AddRptCfg&'+paraValues,{
   			rptFilter:outFilter
   		},function(jsonData){
			if(jsonData.success==true && jsonData.tip=="ok"){
        		Ext.Msg.alert("提示","保存成功！");
			}else{
				Ext.Msg.alert("提示",jsonData.tip);
			}		
		},this);
		rptCfgWin.close();
	}
	
	//向树控件添加一个节点
	function updateTree(rptCodes,flag,statAction){
		var url=encodeURI('dhcwl/complexrpt/rptdimservice.csp?action='+statAction);
		dhcwl.complexrpt.Util.ajaxExc(url,
			{
				statCodes:rptCodes,
				Flag:flag
			},
			function(jsonData){
				if(jsonData.success==true && jsonData.tip=="ok"){
					var treeDatas=jsonData.data; 
					var len=treeDatas.length;
					var startNode=tree.getRootNode();
					var childNode;
					for (var i=0;i<=len-1;i++) {
						className=treeDatas[i].className;
						var dragFlag=true;
						var iconCls='tree-leaf'
						if (treeDatas[i].className=="DHCWL.ComplexRpt.StatItem") {
							dragFlag=false;
							iconCls='tree-folder-open';
						}
						childNode = new Ext.tree.TreeNode({
							code:treeDatas[i].code,
							className:treeDatas[i].className,
							parentNO:treeDatas[i].parentNO,
							NO:treeDatas[i].NO,
							//iconCls:'task-folder',
							iconCls:iconCls,
							text :treeDatas[i].text,
							draggable : dragFlag,
							singleClickExpand : true, //单击展开该节点的子节点
							expanded: false
							//qtip : "双击或拖动节点，可添加行列条件哦！" //节点上的提示信息
							//qtip:treeDatas[i].text+"-----"+treeDatas[i].code
							//icon：节点图标对应的路径,
							//iconCls：应用到节点图标上的样式,
							//checked:checkedFlag
						});
						// 增加树节点
						var pNode=searchNodeByPNO(startNode,treeDatas[i].parentNO);
						if (pNode.length>0) {
							pNode[0].appendChild(childNode);
						}
					}
				}else{
					}
			rptCfgWin.body.unmask();
		},this);
		if (flag=="dim"){
			rptCfgWin.body.mask("数据加载中，请稍等");
		}
	}
	
	function getSelRuleValue(node){
		var itemNode="";
		var proNode="";
		var rowcolArray=[];
		var parentCode="";
		if(!node.attributes.className){
			return rowcolArray;
		}
		if (node.attributes.className!='DHCWL.ComplexRpt.StatItem') {
			itemNode=node.parentNode;
			proNode=node;
			parentCode=itemNode.attributes.code
			if((parentCode=="ItemGrp")||(parentCode=="ItemSubGrpCode")||(parentCode=="ItemSubGrpDesc")||(parentCode=="ItemSubGrpOrder")){
				codestr=itemNode.attributes.NO+"("+proNode.attributes.code+")";
				descstr=itemNode.attributes.text+"("+proNode.attributes.text+")";
			}else{
				codestr=itemNode.attributes.code+"."+proNode.attributes.code;
				descstr=itemNode.attributes.text+"."+proNode.attributes.text;
			}
			rowcolArray.push(descstr);
			rowcolArray.push(codestr);
		}
		return rowcolArray;
	}
	
	function searchNodeByPNO(startNode,PNO) {
	    var r = [];
	    var f = function(){
	    	var attrib=this.attributes;
	    	if (attrib.NO==PNO){
				r.push(this);
	    	}
	    };
	    // 从当前节点开始向下迭代调用指定函数，如果指定函数返回false则将终止迭代。
	    startNode.cascade(f);
	    return r;
	}
	
	function checkNodeSame(nodeData,objPanelStore){
			var flag=0;
			if (nodeData.length<2) return flag;
			var len=objPanelStore.data.length; //长度
			for (var i = len-1; i > -1; i--){
				if (nodeData[1]==objPanelStore.getAt(i).get('statItemCode')){
					var flag=1;
					return flag;
				}
			}
			return flag;
		}
		
		
		function GetStoreSpellStr(objStore,gCode){
			var codeStr=""
			var len=objStore.data.length; //长度
			for (var i = 0; i < len; i++){
				if (codeStr==""){
					codeStr=objStore.getAt(i).get(gCode);
				}else{
					codeStr=codeStr+","+objStore.getAt(i).get(gCode);
				}
			}
			return codeStr;
		}
   	
		
		function checkDataSame(nodeData,objPanelStore){
			var flag=0;
			if (!nodeData) return flag;
			var len=objPanelStore.data.length; //长度
			for (var i = len-1; i > -1; i--){
				if (nodeData==objPanelStore.getAt(i).get('statCode')){
					var flag=1;
					return flag;
				}
			}
			return flag;
		}
		
		function reflashcolWith(panel,colIndex,colCode){
			var swith=165;
			var pStore=panel.getStore();
			var iLen=0;
			var len=pStore.data.length; //长度
			if(len==0){
				return;
			}
			for (var i = len-1; i > -1; i--){
				//var length=pStore.data.items[i].data.statItemDesc.length;
				var length=pStore.getAt(i).get(colCode).length;
				if (iLen<length){
					iLen=length;
				}
			}
			if(iLen<12){ //小于默认长度退出
				panel.colModel.setColumnWidth(colIndex,swith);
				return;
			}
			panel.colModel.setColumnWidth(colIndex,iLen*12);
			return;
		}
		
		/// 默认加载时改变行模型宽度
    	storeItemRow.on("load",function(store){
    		reflashcolWith(selectedRowPanel,0,"statItemDesc");
    	});
    	/// 默认加载时改变列模型宽度
    	storeItemCol.on("load",function(store){
    		reflashcolWith(selectedColPanel,0,"statItemDesc");
    	});
		
		this.showRptCfgWin=function(){
			return rptCfgWin;
		}
}