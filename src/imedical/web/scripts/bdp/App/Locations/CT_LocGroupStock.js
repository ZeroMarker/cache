/// 名称: 科室-库存授权	
/// 描述: 科室-库存授权	
/// 编写者： 基础数据平台组-高姗姗
/// 编写日期:2015-12-4
/**----------------------------------库存授权部分--------------------------------------**/	

    Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	var TREE_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSGroupStockLocations&pClassMethod=GetTreeJson";
	/** 菜单面板 */
	var menuTreeLoader = new Ext.tree.TreeLoader({
				nodeParameter: "ParentID"/*,
				dataUrl: TREE_QUERY_ACTION_URL + '&LocId=' +Ext.getCmp("Hidden_GroupStock_CTLocID").getValue()*/
			});
	
	var menuPanel = new Ext.tree.TreePanel({
			region: 'center',
			//xtype:'treepanel',
			id: 'menuConfigTreePanel',
			expanded:true,
			root: ssordroot=new Ext.tree.AsyncTreeNode({
					id:"menuTreeRoot",
					draggable:false,  //可拖拽的
					expanded:true  //根节点自动展开
					
				}),
			loader: menuTreeLoader,
			autoScroll: true,
			containerScroll: true,
			rootVisible:false,///
			tbar:[{xtype: 'textfield',id: 'Hidden_GroupStock_CTLocID',hidden : true},
					'检索',
					new Ext.form.TextField({
						id:'FindTreeText',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('FindTreeText'),
						width:150,
						emptyText:'请输入查找内容',
						enableKeyEvents: true,
						listeners:{
							keyup:function(node, event) {
								findByKeyWordFiler(node, event);
							},
							scope: this
						}
					}), '-', {
						text:'清空',
						id:'refresh',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('refresh'),
						iconCls:'icon-refresh',
						handler:function(){clearFind();} //清除树过滤
					}/*,'-',{
						xtype:'panel',
						baseCls:'x-plain',
						height:30,
						items:[
							{
							xtype : 'radiogroup',
							columns: [60, 60, 60],
				            items : [{
			            		id : 'radio1',
			            		boxLabel : "全部",
			            		name : 'FilterCK',
			            		inputValue : '0',
			            		checked : true,
			            		listeners : {
					            	'check' : function(com, checked){
					            		if(checked){
					            			menuTreeLoader.dataUrl = TREE_QUERY_ACTION_URL+ '&LocId='+Ext.getCmp("Hidden_GroupStock_CTLocID").getValue();
					            			menuPanel.root.reload();
					            		}
					            	},
					            	scope : this
					            }
			            	}, {
			            		id : 'radio2',
			            		boxLabel : "已选",
			            		name : 'FilterCK',
			            		inputValue : '1',
			            		listeners : {
					            	'check' : function(com, checked){
					            		if(checked){
					            			menuTreeLoader.dataUrl = TREE_QUERY_ACTION_URL + '&FilterCK=checked' + '&LocId='+Ext.getCmp("Hidden_GroupStock_CTLocID").getValue();
					            			menuPanel.root.reload();
					            		}
					            	},
					            	scope : this
					            }
			            	}, {
			            		id : 'radio3',
			            		boxLabel : "未选",
			            		name : 'FilterCK',
			            		inputValue : '2',
			            		listeners : {
					            	'check' : function(com, checked){
					            		if(checked){
					            			menuTreeLoader.dataUrl = TREE_QUERY_ACTION_URL + '&FilterCK=unchecked' + '&LocId='+Ext.getCmp("Hidden_GroupStock_CTLocID").getValue();
					            			menuPanel.root.reload();
					            		}
					            	},
					            	scope : this
					            }
			            	}]
			            }]
					}*/
					] 
	});
	  	menuPanel.on("checkchange",function (node, checked){
			if (checked==true){//添加
				//alert(menuPanel.getChecked())//获取到所有打对勾的checkbox
				
				var ID=node.id;
				var arryTmpRowId = ID.split("^");
				var STCTLOCDR=arryTmpRowId[0];
				var STParRef = arryTmpRowId[1];
				var SaveTreePanelResult = tkMakeServerCall("web.DHCBL.CT.SSGroupStockLocations","SaveTreePanel",STCTLOCDR,STParRef);
			
			}
			else{//删除
				var ID=node.id;
				var arryTmpRowId = ID.split("^");
				var STCTLOCDR=arryTmpRowId[0];
				var STParRef = arryTmpRowId[1];
				var DeleteTreePanelResult = tkMakeServerCall("web.DHCBL.CT.SSGroupStockLocations","DeleteTreePanel",STCTLOCDR,STParRef);
			}
		},this,{stopEvent:true});
		
    function getCTLocGroupStockPanel(){
	var winCTLocGroupStock = new Ext.Window({
			title:'',
			width:700,
            height:500,
			layout:'fit',
			plain:true,//true则主体背景透明
			modal:true,
			frame:true,
			//autoScroll: true,
			collapsible:true,
			hideCollapseTool:true,
			titleCollapse: true,
			bodyStyle:'padding:3px',
			buttonAlign:'center',
			closeAction:'hide',
            labelWidth:55,
			items: menuPanel,
			listeners:{
				"show":function(){
					Ext.getCmp('FindTreeText').reset();
					hiddenPkgs = [];
				},
				"hide":function(){
				},
				"close":function(){
				}
			}
		});
  	return winCTLocGroupStock;
}

/*******************************检索功能********************************/	
	var timeOutId = null;

	var treeFilter = new Ext.tree.TreeFilter(menuPanel, {
		clearBlank : true,
		autoClear : true
	});

	// 保存上次隐藏的空节点
	var hiddenPkgs = [];
	var findByKeyWordFiler = function(node, event) {
		clearTimeout(timeOutId);// 清除timeOutId
		menuPanel.expandAll();// 展开树节点
		//alert(node)
		// 为了避免重复的访问后台，给服务器造成的压力，采用timeOutId进行控制，如果采用treeFilter也可以造成重复的keyup
		timeOutId = setTimeout(function() {
			// 获取输入框的值
			var text = node.getValue();
			// 根据输入制作一个正则表达式，'i'代表不区分大小写
			var re = new RegExp(Ext.escapeRe(text), 'i');
			// 先要显示上次隐藏掉的节点
			Ext.each(hiddenPkgs, function(n) {
				n.ui.show();
			})
			hiddenPkgs = [];
			if (text != "") {
				menuPanel.root.cascade(function(n) {
					if(n.id!='menuTreeRoot'){
						//增加判断大写首拼/小写首拼 是否符合筛选条件 2021-01-07
						if((!re.test(n.text))&&(!re.test(Pinyin.GetJP(n.text)))&&(!re.test(Pinyin.GetJPU(n.text))))
						{
							hiddenPkgs.push(n);
							n.ui.hide();
						}
					}
				});
			} else {
				treeFilter.clear();
				return;
			}
		}, 500);
	}
	// 清除树过滤
	var clearFind = function () {
		Ext.getCmp('FindTreeText').reset();
		menuPanel.root.cascade(function(n) {
					if(n.id!='menuTreeRoot'){
						n.ui.show();
					}
			});
	}
	/*************************************************************/

	