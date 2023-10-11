/*!
 * Ext JS Library 3.2.1
 * Copyright(c) 2006-2010 Ext JS, Inc.
 * licensing@extjs.com
 * http://www.extjs.com/license
 */
/**
 * @class Ext.ux.tree.TreeGrid
 * @extends Ext.tree.TreePanel
 * 
 * @xtype treegrid
 */
 /**
 * @version Base on Ext3.2.1
 * @author 2017-09-06 by 高姗姗 
 * 说明：
 * 	1.TreeGrid功能扩展
 *  2.扩展功能：
 *  	右键菜单(添加本级、添加下级、修改、删除)
 *  	拖拽
 *  	添加、修改、删除、拖拽操作后保留节点的展开收起状态
 * 	3.公共方法:
 * 		loadTreeAdd()   ----添加成功后调用
 * 		loadTreeOther() ----修改删除成功后调用
 *  4.使用方法：
 *  document.write('<link rel="stylesheet" type="text/css" href="../scripts/bdp/Framework/css/treegrid.css"/>');
	document.write('<script type="text/javascript" src="../scripts_lib/ext3.2.1/examples/ux/treegrid/TreeGridSorter.js"></script>');
	document.write('<script type="text/javascript" src="../scripts_lib/ext3.2.1/examples/ux/treegrid/TreeGridColumnResizer.js"></script>');
	//document.write('<script type="text/javascript" src="../scripts_lib/ext3.2.1/examples/ux/treegrid/TreeGridNodeUI.js"></script>'); //复选框不可用
	document.write('<script type="text/javascript" src="../scripts_lib/ext3.2.1/examples/ux/treegrid/TreeGridLoader.js"></script>');
	document.write('<script type="text/javascript" src="../scripts_lib/ext3.2.1/examples/ux/treegrid/TreeGridColumns.js"></script>');
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/TreeGrid.js"></script>');
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/TreeGridNodeUI.js"></script>'); //复选框可用
    var treePanel = new Ext.ux.tree.TreeGrid({
    	frame:true,
    	region:'center',
    	rootId : "TreeRoot",
    	dragUrl: DRAG_ACTION_URL, //拖拽方法
 		AddMethod:AddSame, //右键菜单添加本级方法
 		comboId:"treeCombox", //下拉树id
 		requestUrl: TREE_ACTION_URL+'&LastLevel=',
        columns:[ {
				header : '业务执行动作',
				width : 240,
				dataIndex : 'TKBBETBusExe'
			},{
				header : '代码',
				width : 240,
				dataIndex : 'TKBBETCode'
			},{
				header : '业务场景',
				width : 240,
				dataIndex : 'TKBBETBusScene'
			},{
				header : '业务接口',
				width : 240,
				dataIndex : 'TKBINMDesc'
			},{
				header : '是否激活',
				width : 240,
				dataIndex : 'TKBBETActive',
				renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
			},{
				header : 'id',
				width : 60,
				dataIndex : 'id',
				hidden:true
			}]
    })
 */
Ext.ux.tree.TreeGrid = Ext.extend(Ext.tree.TreePanel, {
    rootVisible : false,
    useArrows : true,
    lines : false,
    borderWidth : Ext.isBorderBox ? 0 : 2, // the combined left/right border for each cell
    cls : 'x-treegrid',

    columnResize : true,
    enableSort : true,
    reserveScrollOffset : true,
    enableHdMenu : true,
    /**封装配置开始**/
    enableDD: true, //节点是否可移动
    rootId : this.rootId, //根节点id
    nodeStr : '', //加载一级节点时保留节点展开收起状态传参 
	comboId:this.comboId, //弹出窗下拉树id
	flag : 0,
    /**封装配置结束**/
    
    columnsText : 'Columns',

    initComponent : function() {
        if(!this.root) {
            this.root = new Ext.tree.AsyncTreeNode({id:this.rootId, text: 'Root'});
        }
        
        // initialize the loader
        var l = this.loader;
        if(!l){
            l = new Ext.ux.tree.TreeGridLoader({
                dataUrl: this.dataUrl,
                requestMethod: this.requestMethod,
                store: this.store
            });
        }else if(Ext.isObject(l) && !l.load){
            l = new Ext.ux.tree.TreeGridLoader(l);
        }
        else if(l) {
            l.createNode = function(attr) {
                if (!attr.uiProvider) {
                    attr.uiProvider = Ext.ux.tree.TreeGridNodeUI;
                }
                return Ext.tree.TreeLoader.prototype.createNode.call(this, attr);
            }
        }
        this.loader = l;
                            
        Ext.ux.tree.TreeGrid.superclass.initComponent.call(this);                    
        
        this.initColumns();
        
        if(this.enableSort) {
            this.treeGridSorter = new Ext.ux.tree.TreeGridSorter(this, this.enableSort);
        }
        
        if(this.columnResize){
            this.colResizer = new Ext.tree.ColumnResizer(this.columnResize);
            this.colResizer.init(this);
        }
        
        var c = this.columns;
        if(!this.internalTpl){                                
            this.internalTpl = new Ext.XTemplate(
                '<div class="x-grid3-header">',
                    '<div class="x-treegrid-header-inner">',
                        '<div class="x-grid3-header-offset">',
                            '<table cellspacing="0" cellpadding="0" border="0"><colgroup><tpl for="columns"><col /></tpl></colgroup>',
                            '<thead><tr class="x-grid3-hd-row">',
                            '<tpl for="columns">',
                            '<td class="x-grid3-hd x-grid3-cell x-treegrid-hd" style="text-align: {align};" id="', this.id, '-xlhd-{#}">',
                                '<div class="x-grid3-hd-inner x-treegrid-hd-inner" unselectable="on">',
                                     this.enableHdMenu ? '<a class="x-grid3-hd-btn" href="#"></a>' : '',
                                     '{header}<img class="x-grid3-sort-icon" src="', Ext.BLANK_IMAGE_URL, '" />',
                                 '</div>',
                            '</td></tpl>',
                            '</tr></thead>',
                        '</div></table>',
                    '</div></div>',
                '</div>',
                '<div class="x-treegrid-root-node">',
                    '<table class="x-treegrid-root-table" cellpadding="0" cellspacing="0" style="table-layout: fixed;"></table>',
                '</div>'
            );
        }
        
        if(!this.colgroupTpl) {
            this.colgroupTpl = new Ext.XTemplate(
                '<colgroup><tpl for="columns"><col style="width: {width}px"/></tpl></colgroup>'
            );
        }
    },

    initColumns : function() {
        var cs = this.columns,
            len = cs.length, 
            columns = [],
            i, c;

        for(i = 0; i < len; i++){
            c = cs[i];
            if(!c.isColumn) {
                c.xtype = c.xtype ? (/^tg/.test(c.xtype) ? c.xtype : 'tg' + c.xtype) : 'tgcolumn';
                c = Ext.create(c);
            }
            c.init(this);
            columns.push(c);
            
            if(this.enableSort !== false && c.sortable !== false) {
                c.sortable = true;
                this.enableSort = true;
            }
        }

        this.columns = columns;
    },

    onRender : function(){
        Ext.tree.TreePanel.superclass.onRender.apply(this, arguments);

        this.el.addClass('x-treegrid');
        
        this.outerCt = this.body.createChild({
            cls:'x-tree-root-ct x-treegrid-ct ' + (this.useArrows ? 'x-tree-arrows' : this.lines ? 'x-tree-lines' : 'x-tree-no-lines')
        });
        
        this.internalTpl.overwrite(this.outerCt, {columns: this.columns});
        
        this.mainHd = Ext.get(this.outerCt.dom.firstChild);
        this.innerHd = Ext.get(this.mainHd.dom.firstChild);
        this.innerBody = Ext.get(this.outerCt.dom.lastChild);
        this.innerCt = Ext.get(this.innerBody.dom.firstChild);
        
        this.colgroupTpl.insertFirst(this.innerCt, {columns: this.columns});
        
        if(this.hideHeaders){
            this.header.dom.style.display = 'none';
        }
        else if(this.enableHdMenu !== false){
            this.hmenu = new Ext.menu.Menu({id: this.id + '-hctx'});
            if(this.enableColumnHide !== false){
                this.colMenu = new Ext.menu.Menu({id: this.id + '-hcols-menu'});
                this.colMenu.on({
                    scope: this,
                    beforeshow: this.beforeColMenuShow,
                    itemclick: this.handleHdMenuClick
                });
                this.hmenu.add({
                    itemId:'columns',
                    hideOnClick: false,
                    text: this.columnsText,
                    menu: this.colMenu,
                    iconCls: 'x-cols-icon'
                });
            }
            this.hmenu.on('itemclick', this.handleHdMenuClick, this);
        }
    },

    setRootNode : function(node){
        node.attributes.uiProvider = Ext.ux.tree.TreeGridRootNodeUI;        
        node = Ext.ux.tree.TreeGrid.superclass.setRootNode.call(this, node);
        if(this.innerCt) {
            this.colgroupTpl.insertFirst(this.innerCt, {columns: this.columns});
        }
        return node;
    },
    
    clearInnerCt : function(){
        if(Ext.isIE){
            var dom = this.innerCt.dom;
            while(dom.firstChild){
                dom.removeChild(dom.firstChild);
            }
        }else{
            Ext.ux.tree.TreeGrid.superclass.clearInnerCt.call(this);
        }
    },
    
    initEvents : function() {
        Ext.ux.tree.TreeGrid.superclass.initEvents.apply(this, arguments);

        this.mon(this.innerBody, 'scroll', this.syncScroll, this);
        this.mon(this.innerHd, 'click', this.handleHdDown, this);
        this.mon(this.mainHd, {
            scope: this,
            mouseover: this.handleHdOver,
            mouseout: this.handleHdOut
        });
        /**封装事件开始**/
        /**拖拽功能*/
        this.on('movenode',function(panel, node , oldParent , newParent , index){
        	var orderstr=""
        	var childnodes=newParent.childNodes; 
	    	for(var i=0;i<childnodes.length;i++)
	    	{
	    		var rootnode = childnodes[i];
	    		if (orderstr!="")
	    		{
	    			var orderstr=orderstr+"^"+rootnode.id;
	    		}
	    		else
	    		{
	    			var orderstr=rootnode.id;
	    		}
	    	}
        	Ext.Ajax.request({
				url : this.dragUrl , 		
				method : 'POST',	
				params : {
						'id' : node.id,
						'parentid' : newParent.id,
						'orderstr' : orderstr
				},
				callback : function(options, success, response) {	
					if(success){
						var jsonData = Ext.util.JSON.decode(response.responseText);
						if (jsonData.success == 'true') {
							panel.selModel.select(node) //拖拽过后选中（加亮显示）
							/*Ext.apply(this.loader.baseParams,{LastLevel:"TreeRoot",nodeStr:this.nodeStr});
							this.store.load();*/
						}else{
							var errorMsg ='';
							if(jsonData.info){
								errorMsg='<br />'+jsonData.info
							}
							Ext.Msg.show({
								title:'提示',
								msg:errorMsg,
								minWidth:210,
								icon:Ext.Msg.ERROR,
								buttons:Ext.Msg.OK
							});
						}
					}
				}								
			})
        });
        this.on('beforeexpand',function(p){
        	flag=1;
        })
        /**节点收起设置节点状态参数*/
        this.on('collapsenode',function(node){
        	if (flag=1){
        		if (this.nodeStr!=""){
			 		this.nodeStr=this.nodeStr+"^<"+node.id+">";
			 	}else{
			 		this.nodeStr="<"+node.id+">";
			 	}
        	}else{
        		this.nodeStr=this.nodeStr.replace("<"+node.id+">","");
        	}
        });
        /**节点展开设置节点状态参数*/
        this.on('expandnode',function(node){
        	if (flag=1){
        		this.nodeStr=this.nodeStr.replace("<"+node.id+">","");
        	}else{
        		if (this.nodeStr!=""){
			 		this.nodeStr=this.nodeStr+"^<"+node.id+">";
			 	}else{
			 		this.nodeStr="<"+node.id+">";
			 	}
        	}
        });
        /**右键菜单*/
        this.on('contextmenu',function(node, e){
        	if(this.nodemenu==null){
			this.nodemenu=new Ext.menu.Menu({  			
				items: [
				{
		            iconCls :'icon-add',
		            handler: this.AddMethod,
		            id:'menuAddSame',
		            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuAddSame'),
		            text: '添加本级'
		        },{
		            iconCls :'icon-add',
		            handler: AddData,
		            id:'menuAddData',
		            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuAddData'),
		            text: '添加下级'
		        },{
		            iconCls :'icon-Update',
		            handler: UpdateData,
		             id:'menuUpdateData',
		            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuUpdateData'),
		            text: '修改'
		        },{
		            iconCls :'icon-delete',
		            handler: DelData,
		            id:'menuDelData',
		            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuDelData'),
		            text: '删除'
		         },{
		            iconCls :'icon-refresh',
		            handler: Refresh,
		            id:'menuRefresh',
		            disabled : Ext.BDP.FunLib.Component.DisableFlag('menuRefresh'),
		            text: '刷新'
		        }]     	
			}); 
			}
			this.nodemenu.showAt(e.getXY());//menu的showAt，不要忘记
			this.getSelectionModel().select(node);
        });
        /**加载*/
        this.on('beforeload',function(node){
        	if (node.isRoot) {   //首次加载
                 this.loader.dataUrl = this.requestUrl+"TreeRoot&nodeStr="+this.nodeStr;
	           }else { 
	                 var nodeId = node.attributes["id"]; //取得点击节点名称
	                 var rqtUrl = this.requestUrl + nodeId; //得到新的URL地址
	                        if (node.attributes.loader.dataUrl) {
	                            this.loader.dataUrl = rqtUrl+"&nodeStr="+this.nodeStr //点击节点,后台请求数据
	                        }
	           }
	        this.root.attributes.loader = null; //防止节点的重复加载
        });
        /**封装事件结束**/
    },
    
    onResize : function(w, h) {
        Ext.ux.tree.TreeGrid.superclass.onResize.apply(this, arguments);
        
        var bd = this.innerBody.dom;
        var hd = this.innerHd.dom;

        if(!bd){
            return;
        }

        if(Ext.isNumber(h)){
            bd.style.height = this.body.getHeight(true) - hd.offsetHeight + 'px';
        }

        if(Ext.isNumber(w)){                        
            var sw = Ext.num(this.scrollOffset, Ext.getScrollBarWidth());
            if(this.reserveScrollOffset || ((bd.offsetWidth - bd.clientWidth) > 10)){
                this.setScrollOffset(sw);
            }else{
                var me = this;
                setTimeout(function(){
                    me.setScrollOffset(bd.offsetWidth - bd.clientWidth > 10 ? sw : 0);
                }, 10);
            }
        }
    },

    updateColumnWidths : function() {
        var cols = this.columns,
            colCount = cols.length,
            groups = this.outerCt.query('colgroup'),
            groupCount = groups.length,
            c, g, i, j;

        for(i = 0; i<colCount; i++) {
            c = cols[i];
            for(j = 0; j<groupCount; j++) {
                g = groups[j];
                g.childNodes[i].style.width = (c.hidden ? 0 : c.width) + 'px';
            }
        }
        
        for(i = 0, groups = this.innerHd.query('td'), len = groups.length; i<len; i++) {
            c = Ext.fly(groups[i]);
            if(cols[i] && cols[i].hidden) {
                c.addClass('x-treegrid-hd-hidden');
            }
            else {
                c.removeClass('x-treegrid-hd-hidden');
            }
        }

        var tcw = this.getTotalColumnWidth();                        
        Ext.fly(this.innerHd.dom.firstChild).setWidth(tcw + (this.scrollOffset || 0));
        this.outerCt.select('table').setWidth(tcw);
        this.syncHeaderScroll();    
    },
                    
    getVisibleColumns : function() {
        var columns = [],
            cs = this.columns,
            len = cs.length,
            i;
            
        for(i = 0; i<len; i++) {
            if(!cs[i].hidden) {
                columns.push(cs[i]);
            }
        }        
        return columns;
    },

    getTotalColumnWidth : function() {
        var total = 0;
        for(var i = 0, cs = this.getVisibleColumns(), len = cs.length; i<len; i++) {
            total += cs[i].width;
        }
        return total;
    },

    setScrollOffset : function(scrollOffset) {
        this.scrollOffset = scrollOffset;                        
        this.updateColumnWidths();
    },

    // private
    handleHdDown : function(e, t){
        var hd = e.getTarget('.x-treegrid-hd');

        if(hd && Ext.fly(t).hasClass('x-grid3-hd-btn')){
            var ms = this.hmenu.items,
                cs = this.columns,
                index = this.findHeaderIndex(hd),
                c = cs[index],
                sort = c.sortable;
                
            e.stopEvent();
            Ext.fly(hd).addClass('x-grid3-hd-menu-open');
            this.hdCtxIndex = index;
            
            this.fireEvent('headerbuttonclick', ms, c, hd, index);
            
            this.hmenu.on('hide', function(){
                Ext.fly(hd).removeClass('x-grid3-hd-menu-open');
            }, this, {single:true});
            
            this.hmenu.show(t, 'tl-bl?');
        }
        else if(hd) {
            var index = this.findHeaderIndex(hd);
            this.fireEvent('headerclick', this.columns[index], hd, index);
        }
    },

    // private
    handleHdOver : function(e, t){                    
        var hd = e.getTarget('.x-treegrid-hd');                        
        if(hd && !this.headersDisabled){
            index = this.findHeaderIndex(hd);
            this.activeHdRef = t;
            this.activeHdIndex = index;
            var el = Ext.get(hd);
            this.activeHdRegion = el.getRegion();
            el.addClass('x-grid3-hd-over');
            this.activeHdBtn = el.child('.x-grid3-hd-btn');
            if(this.activeHdBtn){
                this.activeHdBtn.dom.style.height = (hd.firstChild.offsetHeight-1)+'px';
            }
        }
    },
    
    // private
    handleHdOut : function(e, t){
        var hd = e.getTarget('.x-treegrid-hd');
        if(hd && (!Ext.isIE || !e.within(hd, true))){
            this.activeHdRef = null;
            Ext.fly(hd).removeClass('x-grid3-hd-over');
            hd.style.cursor = '';
        }
    },
                    
    findHeaderIndex : function(hd){
        hd = hd.dom || hd;
        var cs = hd.parentNode.childNodes;
        for(var i = 0, c; c = cs[i]; i++){
            if(c == hd){
                return i;
            }
        }
        return -1;
    },
    
    // private
    beforeColMenuShow : function(){
        var cols = this.columns,  
            colCount = cols.length,
            i, c;                        
        this.colMenu.removeAll();                    
        for(i = 1; i < colCount; i++){
            c = cols[i];
            if(c.hideable !== false){
                this.colMenu.add(new Ext.menu.CheckItem({
                    itemId: 'col-' + i,
                    text: c.header,
                    checked: !c.hidden,
                    hideOnClick:false,
                    disabled: c.hideable === false
                }));
            }
        }
    },
                    
    // private
    handleHdMenuClick : function(item){
        var index = this.hdCtxIndex,
            id = item.getItemId();
        
        if(this.fireEvent('headermenuclick', this.columns[index], id, index) !== false) {
            index = id.substr(4);
            if(index > 0 && this.columns[index]) {
                this.setColumnVisible(index, !item.checked);
            }     
        }
        
        return true;
    },
    
    setColumnVisible : function(index, visible) {
        this.columns[index].hidden = !visible;        
        this.updateColumnWidths();
    },

    /**
     * Scrolls the grid to the top
     */
    scrollToTop : function(){
        this.innerBody.dom.scrollTop = 0;
        this.innerBody.dom.scrollLeft = 0;
    },

    // private
    syncScroll : function(){
        this.syncHeaderScroll();
        var mb = this.innerBody.dom;
        this.fireEvent('bodyscroll', mb.scrollLeft, mb.scrollTop);
    },

    // private
    syncHeaderScroll : function(){
        var mb = this.innerBody.dom;
        this.innerHd.dom.scrollLeft = mb.scrollLeft;
        this.innerHd.dom.scrollLeft = mb.scrollLeft; // second time for IE (1/2 time first fails, other browsers ignore)
    },
    
    registerNode : function(n) {
        Ext.ux.tree.TreeGrid.superclass.registerNode.call(this, n);
        if(!n.uiProvider && !n.isRoot && !n.ui.isTreeGridNodeUI) {
            n.ui = new Ext.ux.tree.TreeGridNodeUI(n);
        }
    },
    /**封装方法开始**/
     /**修改删除成功后加载*/
    loadTreeOther : function(){
    	var _record = this.getSelectionModel().getSelectedNode();
		if (_record == null) {
			//this.loader.dataUrl = this.requestUrl+"TreeRoot&nodeStr="+this.nodeStr;
			this.root.reload();//this.store.load(); 
		 } else {
		 	if (_record.parentNode.id=="TreeRoot"){
			 	//this.loader.dataUrl = this.requestUrl+"TreeRoot&nodeStr="+this.nodeStr;
		 		this.root.reload();//this.store.load(); 
		 	}else{
		 		var countChild=0
		 		_record.parentNode.eachChild(function(n){
		 			countChild=countChild+1;
		 		});
		 		if (countChild==1){
		 			if(_record.parentNode.parentNode.id=="TreeRoot"){ //现调用方法，解决-删除某分类文件夹的所有下级后-该分类仍以文件夹的形式显示
				 		//this.loader.dataUrl = this.requestUrl+"TreeRoot&nodeStr="+this.nodeStr;
						this.root.reload();//this.store.load(); 
			 		}else{
			 			this.getNodeById(_record.parentNode.parentNode.id).reload();
			 		}
		 		}else{
		 			this.getNodeById(_record.parentNode.id).reload();//原调用方法
		 		}
		 	}
		 }
		//刷新树形下拉框的数据
 		 Ext.getCmp(this.comboId).treePanel.root.reload();
 		 //清除树形列表的选中状态
 		 this.getSelectionModel().clearSelections();
    },
    /**添加成功后加载*/
    loadTreeAdd : function(){
    	if (Ext.get(this.comboId).getValue() == "") {//如果上级分类为空
            //this.loader.dataUrl = this.requestUrl+"TreeRoot&nodeStr="+this.nodeStr;
    		this.root.reload();//this.store.load();
			//刷新树形下拉框的数据
 		 	Ext.getCmp(this.comboId).treePanel.root.reload();
		 } else {//如果上级分类不空
		 	var _record = this.getSelectionModel().getSelectedNode();
		 	if (_record!=null){//如果选中节点 
		 	    //刷新当前选中节点的父节点
		 		if (_record.parentNode.id=="TreeRoot"){
		            //this.loader.dataUrl = this.requestUrl+"TreeRoot&nodeStr="+this.nodeStr;
					this.root.reload();//this.store.load();
			 	}else{
			 		this.getNodeById(_record.parentNode.id).reload();
			 	}
		 	}
		 	//刷新树形下拉框的数据
 		 	Ext.getCmp(this.comboId).treePanel.root.reload();
			//刷新上级分类节点
	 		//this.getNodeById(Ext.getCmp(this.comboId).getValue()).reload();
		 }
    }
    /**封装方法结束**/
});

Ext.reg('treegrid', Ext.ux.tree.TreeGrid);