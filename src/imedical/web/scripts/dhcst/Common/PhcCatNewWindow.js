///药学多级分类弹框

function PhcCatNewSelect(gNewPhcCatId,Fn) {	
	var phcmulticatdescstr=""
	var phcmulticatrowid=""
	var closeflag=""
	var unitsUrl = 'dhcst.phccatmaintainaction.csp';
	var gQueryDesc=""
	var newcatid="" 
	setCommFlag();
    Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
      var AddRootBT = new Ext.Toolbar.Button({
			text : $g('增加一级分类'),
			tooltip : $g('点击增加一级分类'),
			//iconCls : 'page_find',
			width : 70,
			height : 30,
			handler : function() {
				CatAdd("0","");
				treepanel.getRootNode().reload();
			}
     })
     var AddBT = new Ext.Toolbar.Button({
			text : $g('增加'),
			tooltip : $g('点击增加'),
			//iconCls : 'page_find',
			width : 70,
			height : 30,
			handler : function() {
				var node=treepanel.getSelectionModel().getSelectedNode();  //获取选中节点
				CatAdd(node.attributes.id,node.text);
				treepanel.getRootNode().reload();
			}
     })  
     var DeleteBT = new Ext.Toolbar.Button({
			text : $g('删除'),
			tooltip : $g('点击删除'),
			//iconCls : 'page_find',
			width : 70,
			height : 30,
			handler : function() {
			}
     })  
     var QueryBT = new Ext.Toolbar.Button({
			text : $g('查询'),
			tooltip : $g('点击查询'),
			//iconCls : 'page_find',
			width : 70,
			height : 30,
			handler : function() {
				gQueryDesc=Ext.getCmp("M_PhcDesc").getValue();
				treepanel.getRootNode().reload();
				gQueryDesc=""
			}
     })   
          var KongBT = new Ext.Toolbar.Button({
			text : $g('维护为空'),
			tooltip : $g('点击维护为空！'),
			//iconCls : 'page_find',
			width : 70,
			height : 30,
			handler : function() {
					closeflag="1"
                    window.close();
			}
     }) 
	 var M_PhcDesc = new Ext.form.TextField({
			fieldLabel : $g('药学分类描述'),
			id : 'M_PhcDesc',
			name : 'M_PhcDesc',
			anchor : '90%',
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						gQueryDesc=Ext.getCmp("M_PhcDesc").getValue();
				        treepanel.getRootNode().reload();
				        gQueryDesc=""
					}
				}
			}
		}); 
	

  


	// 创建一个简写

	var Tree = Ext.tree;

	// 定义根节点的Loader

	var treeloader = new Tree.TreeLoader({

				dataUrl : unitsUrl + '?action=ListTreeDataById'

			});

	// 添加一个树形面板

	var treepanel = new Tree.TreePanel({
				region : 'center',				
				//width : 500,
				split : true,
				//height : 300,
				frame : true,
				autoScroll : true,
				enableDD : false,
				containerScroll : true,
				border : true,
				animate : true,
				rootVisible:true,
				loader : treeloader,
				listeners: {        
                	afterrender: function(node) { 
                	}        
            	} ,
				tbar:[$g('检索:'),
					new Ext.form.TextField({
						id:'FindTreeText',
						width:150,
						emptyText:$g('请输入查找内容'),
						enableKeyEvents: true,
						listeners:{
							keyup:function(node, event) {
								findByKeyWordFiler(node, event);
							},
							scope: this
						}
					}), '-', 
					{
						text:$g('清空'),
						iconCls:'page_clearscreen',
						handler:function(){
							clearFind();
						}
					  } ,'-',
					{
						text:$g('传递空值'),
						iconCls:'page_refresh',
						handler:function(){
							closeflag="1"
		                    window.close();
						} //清除树过滤
				}]
			});

	// 异步加载根节点
	var rootnode = new Tree.AsyncTreeNode({

				text : $g('药学多级分类'),

				id : 'id',

				value : '0',

				level : '0',

				draggable : false , // 根节点不容许拖动

				expanded : true

			});

	// 为tree设置根节点

	treepanel.setRootNode(rootnode);
	// 响应加载前事件，传递node参数

	treeloader.on('beforeload', function(treeloader, node) {
				if (node == rootnode) {
					node.attributes.id = '0';
				}
				treeloader.baseParams = {
					id : node.attributes.id,
					level : node.attributes.level,
					checkednode : newcatid,
					querydesc:gQueryDesc,
					actiontype : 'load'
				}

			}, this);
	// 设置树的点击事件

	function treeClick(node, e) {
                 
                 //if (node.isLeaf()){
	                var url="dhcst.phccatmaintainaction.csp?action=GetAllCat&CatId="+node.attributes.id;
			        var catdescstr=ExecuteDBSynAccess(url);
			        phcmulticatdescstr=catdescstr;
					phcmulticatrowid=node.attributes.id;
                    closeflag="1"
                    window.close();
               // }


	}

	// 增加鼠标双击事件

	treepanel.on('dblclick', treeClick);
	
	treepanel.on('expandnode', function(node) { 
		if(node.attributes.id==newcatid){     
		    node.select();//此节点被选中
		}       
	}, this);

   var selectreasongridcm = new Ext.grid.ColumnModel({ 
	  columns:[
       
	        {header:$g('描述'),dataIndex:'reasondesc',width:300},
	        {header:'rowid',dataIndex:'reasonrowid',width:40},
	        {header:$g('分级'),dataIndex:'reasonlevel',width:40}  
	          ]   
	});
 
 
    var selectreasongridds = new Ext.data.Store({
	proxy: "",
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'reasondesc',
            'reasonrowid',
            'reasonlevel'
	    
		]),
		
		

        remoteSort: true
});
	function rightClickFn(grid,rowindex,e){ 
	    e.preventDefault();
	    rightClick.showAt(e.getXY());
		selectreasongrid.getSelectionModel().selectRow(rowindex); 
    }
        
    var HisListTab = new Ext.form.FormPanel({
			labelAlign : 'right',
			frame : true,
			autoScroll : false,
			region : 'north',	
			bodyStyle:'padding:5px 0px 0px 0px'
			//tbar : [M_PhcDesc, '-', QueryBT,'-',KongBT]
    })
function setCommFlag(){
    newcatid=gNewPhcCatId;
}
//**************** 树检索功能 ****************************************//
	var timeOutId = null;
	var treeFilter = new Ext.tree.TreeFilter(treepanel, {
		clearBlank : true,
		autoClear : true
	});
	// 保存上次隐藏的空节点
	var hiddenPkgs = [];
	var findByKeyWordFiler = function(node, event) {
		clearTimeout(timeOutId);// 清除timeOutId
		treepanel.expandAll();// 展开树节点
		// 为了避免重复的访问后台，给服务器造成的压力，采用timeOutId进行控制，如果采用treeFilter也可以造成重复的keyup
		timeOutId = setTimeout(function() {
			// 获取输入框的值
			var text = node.getValue();
			// 根据输入制作一个正则表达式，'i'代表不区分大小写
			var re = new RegExp(Ext.escapeRe(text), 'i');
			// 先要显示上次隐藏掉的节点
			Ext.each(hiddenPkgs, function(n) {
				n.ui.show();
			});
			hiddenPkgs = [];
			if (text != "") {
				treeFilter.filterBy(function(n) {
					// 只过滤叶子节点，这样省去枝干被过滤的时候，底下的叶子都无法显示
					return !n.isLeaf() || re.test(n.text);
				});
				// 如果这个节点不是叶子，而且下面没有子节点，就应该隐藏掉
				treepanel.root.cascade(function(n) {
					if(n.id!='0'){
						if(!n.isLeaf() &&judge(n,re)==false&& !re.test(n.text)){
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
	// 过滤不匹配的非叶子节点或者是叶子节点
	var judge =function(n,re){
		var str=false;
		n.cascade(function(n1){
			if(n1.isLeaf()){
				if(re.test(n1.text)){ str=true;return; }
			} else {
				if(re.test(n1.text)){ str=true;return; }
			}
		});
		return str;
	};
	// 清除树过滤
	var clearFind = function () {
		Ext.getCmp('FindTreeText').reset();
		treepanel.root.cascade(function(n) {
					if(n.id!='0'){
							n.ui.show();
						}
				});
	}

	var panel = new Ext.Panel({
		activeTab:0,
		region:'north',
		items:[HisListTab]                                 
	});
	
	var window = new Ext.Window({
			title:$g('药学多级分类(双击选取)'),
			layout:'border',
			modal:true,
			width : document.body.clientWidth*0.6,
			height : document.body.clientHeight*0.85,
			items:[treepanel]
		});
	window.show();	
	window.on('close', function(panel) {
			if (closeflag=="")
			{
				
			}
			else
			{
				Fn(phcmulticatdescstr,phcmulticatrowid)
			}
		});
		
}

