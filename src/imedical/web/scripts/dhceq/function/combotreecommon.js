document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/ChinesePY.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/pageLoading.js"> </script>');

/** chenying 20181122 
 * 判断searchText是否与targetText匹配 
 * @param searchText 检索的文本 
 * @param targetText 目标文本 
 * @return true-检索的文本与目标文本匹配；否则为false. 
 */ 
function isMatch(searchText, targetText) {  
	  return $.trim(targetText)!="" && ((targetText.toUpperCase().indexOf(searchText.toUpperCase())!=-1)||((Pinyin.GetJPU(targetText)).indexOf(searchText.toUpperCase())!=-1));
}  

 /**chenying 20181122 
	* 判断数据是否存在数组中 
	* @param arr 数组
	* @param val 检索的字符串 
	* @return true-存在；否则为false. 
	*/ 
function IsInArray(arr,val){
	 try {
		 return (arr.indexOf(val)>-1)
	 }
	 catch(e)
	 {
		 return ($.inArray(val,arr)>-1)
		 //return (isMatch(("^"+val+"^"),("^"+arr.join("^")+"^")))  //2018-11-22适应支持ie8低版本
	 }
}

(function(){  
    //combobox可编辑，自定义模糊查询  
    $.fn.combobox.defaults.editable = true;  
    $.fn.combobox.defaults.filter = function(q, row){  
        var opts = $(this).combobox('options');  
        ///update by chenying @20180803  下拉框支持模糊检索和首拼检索
        return ((row[opts.textField].indexOf(q) >= 0)||(Pinyin.GetJP(row[opts.textField]).indexOf(q.toLowerCase()) >= 0));  
    };  
    //combotree可编辑，自定义模糊查询  
    $.fn.combotree.defaults.editable = true;  
    $.extend($.fn.combotree.defaults.keyHandler,{  
        up:function(){  
            console.log('up');  //PgUp
        },  
        down:function(){  
            console.log('down');  ////PgDn
        },  
        enter:function(){
            //2018-12-18检索时显示子节点和所有父节点。
            //改为回车时检索，实时检索数据多较慢 czf 20210429
            //输入框为空时显示所有节点并折叠 CZF0136 2021-05-20
	        var q=$(this).combotree('getText');	
	        if(q=="")
	        {
		        var that = this;
		    	var opts = $(this).combotree('options'); 
                opts.onShowPanel = function(){  
                    $(that).combo('showPanel');
                	var t = $(that).combotree('tree'); 
                	var checknodes=t.tree('getChecked');	//输入框为空时设置节点未选中 2022-07-10
                	for(var i=0; i<checknodes.length; i++){
                        t.tree('uncheck',checknodes[i].target);
                    }
					var nodes = t.tree('getChildren');  
                    for(var i=0; i<nodes.length; i++){
                        $(nodes[i].target).show();
                        //t.tree('uncheck',nodes[i].target);
                    }
                    var RootNodes=t.tree('getRoots');
                    for(var i=0; i<RootNodes.length; i++){
	                    t.tree('collapseAll',RootNodes[i].target);
                    }
                    
                };  
	            $(this).combo('options').onShowPanel = opts.onShowPanel();  
		    }
		    else
		    {
			    var t = $(this).combotree('tree');  
			    var checknodes=t.tree('getChecked');	//每次查询清除之前选中内容
            	for(var i=0; i<checknodes.length; i++){
                    t.tree('uncheck',checknodes[i].target);
                } 
	            var nodes = t.tree('getChildren');  
				var matchedNodeList = [];  
	            for(var i=0; i<nodes.length; i++){  
	                var node = nodes[i];
					if (isMatch(q, node.text)) {  
						matchedNodeList.push(node);  
					}  
					$(".tree-node-targeted", node.target).removeClass("tree-node-targeted");  
					$(node.target).hide();  
	            }  
				
				//展示所有匹配的节点以及父节点            
				for (var i=0; i<matchedNodeList.length; i++) {
					var node = matchedNodeList[i];
					$(node.target).show();  
					$(".tree-title", node.target).addClass("tree-node-targeted");  
					var pNode = node;  
					while ((pNode = $(this).combotree('tree').tree('getParent',pNode.target))) {  
						$(pNode.target).show();               
					}  
					//展开到该节点  
					$(this).combotree('tree').tree('expandTo', node.target);  
				} 
			}
        },
        query:function(q){
	       var element=this.id;		//输入改变值时清空元素DR的值 czf 20210429 begin
	       if (element.indexOf("_")>-1)
	       {
		       var elementdr=element.split("_")[0];
		       $("#"+elementdr).val("");
		   }						//输入改变值时清空元素DR的值 czf 20210429 end
           /* var opts = $(this).combotree('options');  
            if (!opts.hasSetEvents){  
                opts.hasSetEvents = true;  
                var onShowPanel = opts.onShowPanel;  
                opts.onShowPanel = function(){  
					var nodes = t.tree('getChildren');  
                    for(var i=0; i<nodes.length; i++){  
                        $(nodes[i].target).show();  
                    }  
                    onShowPanel.call(this);  
                };  
                $(this).combo('options').onShowPanel = opts.onShowPanel;  
            }  
			*/
        } 
    });  
	
})(jQuery);

/** 
 * 1）扩展jquery easyui tree的节点检索方法。使用方法如下： 
 * $("#treeId").tree("search", searchText);   
 * 其中，treeId为easyui tree的根UL元素的ID，searchText为检索的文本。 
 * 如果searchText为空或""，将恢复展示所有节点为正常状态 
 */  
(function($) {    
      
    $.extend($.fn.tree.methods, { 
    	//2018-11-30展开一个节点，展开下面第一级子节点，而不是只符合查询条件的数据。 chenying
        expandFirstChildNodes: function(jqTree, node) {
			var tree = this; 
        	var children = tree.getChildren(jqTree, node.target);   ///是所有下级节点
            if (children && children.length>0) {  
                for (var i=0; i<children.length; i++) {
                	var pNode = tree.getParent(jqTree, children[i].target)
					if (pNode.id==node.id)
                	{
                		$(".tree-node-targeted", children[i].target).removeClass("tree-node-targeted");  
                    	$(children[i].target).show();  
                	}
                	
                     
                }  
            } 
        },
		expandAllChildNodes: function(jqTree, node) {
			var tree = this; 
        	var children = tree.getChildren(jqTree, node.target);   ///是所有下级节点
            if (children && children.length>0) {  
                for (var i=0; i<children.length; i++) {
                	$(".tree-node-targeted", children[i].target).removeClass("tree-node-targeted");  
                    	
					$(children[i].target).show();  
                }  
            } 
        },
        /** 
         * 扩展easyui tree的搜索方法 
         * @param tree easyui tree的根DOM节点(UL节点)的jQuery对象 
         * @param searchText 检索的文本 
         * @param this-context easyui tree的tree对象 
         */  
    	
        search: function(jqTree, searchText) {  
        	searchText=searchText.toUpperCase();
        	
            //easyui tree的tree对象。可以通过tree.methodName(jqTree)方式调用easyui tree的方法  
            var tree = this;  
            //获取所有的树节点  
            var nodeList = getAllNodes(jqTree, tree);  
              
            //如果没有搜索条件，则展示所有树节点  
            searchText = $.trim(searchText);  
            if (searchText == "") {  
                for (var i=0; i<nodeList.length; i++) {  
                    $(".tree-node-targeted", nodeList[i].target).removeClass("tree-node-targeted");  
                    $(nodeList[i].target).show();  
                }  
                //展开已选择的节点（如果之前选择了）  
                var selectedNode = tree.getSelected(jqTree);  
                if (selectedNode) {  
                    tree.expandTo(jqTree, selectedNode.target);  
                }  
                return;  
            }  
              
            //搜索匹配的节点并高亮显示  
            var matchedNodeList = [];  
            if (nodeList && nodeList.length>0) {  
                var node = null;  
                for (var i=0; i<nodeList.length; i++) {  
                    node = nodeList[i];  
                    if (isMatch(searchText, node.text)) {  
                        matchedNodeList.push(node);  
                    }  
                }  
                  
                //隐藏所有节点  
                for (var i=0; i<nodeList.length; i++) {  
                    $(".tree-node-targeted", nodeList[i].target).removeClass("tree-node-targeted");  
                    $(nodeList[i].target).hide();  
                }             
                  
                //折叠所有节点  
                tree.collapseAll(jqTree);  
                  
                //展示所有匹配的节点以及父节点              
                for (var i=0; i<matchedNodeList.length; i++) {  
                    showMatchedNode(jqTree, tree, matchedNodeList[i]);  
                }  
            }      
        }, 
        /** 
         * 展示节点的子节点（子节点有可能在搜索的过程中被隐藏了） 
         * @param node easyui tree节点 
         */  
        showChildren: function(jqTree, node) {  
            //easyui tree的tree对象。可以通过tree.methodName(jqTree)方式调用easyui tree的方法  
            var tree = this;  
              
            //展示子节点  
            if (!tree.isLeaf(jqTree, node.target)) {  
                var children = tree.getChildren(jqTree, node.target);  
                if (children && children.length>0) {  
                    for (var i=0; i<children.length; i++) {  
                        //if ($(children[i].target).is(":hidden")) {  
                            $(children[i].target).show();  
                       // }  
                    }  
                }  
            }     
        },  
          
        /** 
         * 将滚动条滚动到指定的节点位置，使该节点可见（如果有滚动条才滚动，没有滚动条就不滚动） 
         * @param param { 
         *    treeContainer: easyui tree的容器（即存在滚动条的树容器）。如果为null，则取easyui tree的根UL节点的父节点。 
         *    targetNode:  将要滚动到的easyui tree节点。如果targetNode为空，则默认滚动到当前已选中的节点，如果没有选中的节点，则不滚动 
         * }  
         */  
        scrollTo: function(jqTree, param) {  
            //easyui tree的tree对象。可以通过tree.methodName(jqTree)方式调用easyui tree的方法  
            var tree = this;  
              
            //如果node为空，则获取当前选中的node  
            var targetNode = param && param.targetNode ? param.targetNode : tree.getSelected(jqTree);  
              
            if (targetNode != null) {  
                //判断节点是否在可视区域                 
                var root = tree.getRoot(jqTree);  
                var $targetNode = $(targetNode.target);  
                var container = param && param.treeContainer ? param.treeContainer : jqTree.parent();  
                var containerH = container.height();  
                var nodeOffsetHeight = $targetNode.offset().top - container.offset().top;  
                if (nodeOffsetHeight > (containerH - 30)) {  
                    var scrollHeight = container.scrollTop() + nodeOffsetHeight - containerH + 30;  
                    container.scrollTop(scrollHeight);  
                }                             
            }  
        }  
    });  
      
      
      
      
    /** 
     * 展示搜索匹配的节点 
     */  
    function showMatchedNode(jqTree, tree, node) {  
        //展示所有父节点  
        $(node.target).show();  
        $(".tree-title", node.target).addClass("tree-node-targeted");  
        var pNode = node;  
        while ((pNode = tree.getParent(jqTree, pNode.target))) {  
            $(pNode.target).show();               
        }  
        //展开到该节点  
        tree.expandTo(jqTree, node.target);  
        //如果是非叶子节点，需折叠该节点的所有子节点  
        if (!tree.isLeaf(jqTree, node.target)) {  
            tree.collapse(jqTree, node.target);  
        }  
    }      
      
   
      
    /** 
     * 获取easyui tree的所有node节点 
     */  
    function getAllNodes(jqTree, tree) {  
        var allNodeList = jqTree.data("allNodeList");  
        if (!allNodeList) {  
            var roots = tree.getRoots(jqTree);  
            allNodeList = getChildNodeList(jqTree, tree, roots);  
            jqTree.data("allNodeList", allNodeList);  
        }  
        return allNodeList;  
    }  
      
    /** 
     * 定义获取easyui tree的子节点的递归算法 
     */  
    function getChildNodeList(jqTree, tree, nodes) {  
        var childNodeList = [];  
        if (nodes && nodes.length>0) {             
            var node = null;  
            for (var i=0; i<nodes.length; i++) {  
                node = nodes[i];  
                childNodeList.push(node);  
                if (!tree.isLeaf(jqTree, node.target)) {  
                    var children = tree.getChildren(jqTree, node.target);  
                    childNodeList = childNodeList.concat(getChildNodeList(jqTree, tree, children));  
                }  
            }  
        }  
        return childNodeList;  
    }  
})(jQuery);

/**
 * @abstract 扩展jquery easyui treegrid的节点检索方法
 * @method $("#mygrid").treegrid("search", searchText); 
 * @mygrid为easyui treegrid的id,searchText为检索的文本。 如果searchText为空或""，将恢复展示所有节点为正常状态 
 * @author chenying
 * @date 2018-03-20
 */
(function($) {    
    
    $.extend($.fn.treegrid.methods, {
      //2018-11-30展开一个节点，展开下面第一级子节点，而不是只符合查询条件的数据。 chenying
      expandFirstChildNodes: function(jqTreegrid, parentid) {	      	
        	var Childrows = jqTreegrid.treegrid('getChildren', parentid);
        	var newmatchedNodeList=[],newNOmatchedNodeList=[];
            for(var i=0; i<Childrows.length; i++){
            	var pNode = jqTreegrid.treegrid("getParent",Childrows[i].id);   	
            	var childnodes = jqTreegrid.treegrid('getChildren', Childrows[i].id)   ///获取的是所有的下级节点 包括子节点的子节点等等
            	if (childnodes.length>0)
            	{
	            	jqTreegrid.treegrid("collapse",Childrows[i].id)
            		///注意：不加的话 有子节点的节点会第一次单击时不会展开。
	            	/*jqTreegrid.treegrid('update',{   //导致IE8下提示：停止运行此脚本吗?此页面上的脚本造成 Web 浏览器运行速度减慢。如果继续运行，您的计算机将可能停止响应。
							id:Childrows[i].id,
							row:{"state":"closed"}
					})*/
            	}
            	try
            	{
	            	if (pNode.id==parentid)
	            	{
	            		newmatchedNodeList.push(Childrows[i].id);
	            	}
	            	else
	            	{
	            		newNOmatchedNodeList.push(Childrows[i].id);
	            	}	
            	}
            	catch(e)
            	{
	            	
            	}
            }
            jqTreegrid.treegrid('getPanel').find('.datagrid-row').each(function(){
				if (IsInArray(newmatchedNodeList,$(this).attr('node-id')))
                {
	                $(this).show();
                   // $(this).attr('hidden',false)   
                }
                if (IsInArray(newNOmatchedNodeList,$(this).attr('node-id')))
                {
	                $(this).hide();
                    //$(this).attr('hidden',true)  //IE8下不起作用
                }
            })
      },
      //2018-11-30add 展开一个节点，展开下面所有子节点，而不是只符合查询条件的数据。 chenying
      expandAllChildNodes: function(jqTreegrid, parentid) {
        	var Childrows = jqTreegrid.treegrid('getChildren', parentid);
        	var newmatchedNodeList=[];
            for(var i=0; i<Childrows.length; i++){
            	newmatchedNodeList.push(Childrows[i].id);
            }
            jqTreegrid.treegrid('getPanel').find('.datagrid-row').each(function(){
				if (IsInArray(newmatchedNodeList,$(this).attr('node-id')))
                {
	                $(this).show();
                    //$(this).attr('hidden',false)
                }
                
            })
       },
       search: function(jqTreegrid, searchText) { 
       		searchText=searchText.toUpperCase();
       		//如果没有搜索条件，则展示所有树节点  
            searchText = $.trim(searchText); 
            if (searchText == "") { 
            	jqTreegrid.datagrid('getPanel').find('.datagrid-row').each(function(){
	            	$(this).show();
            		//$(this).attr('hidden',false)		
	            })
                jqTreegrid.treegrid("expandAll")   ///总是执行完才展开??
                return;  
            }
            else
			{
	            //获取所有的节点   
	            var roots=jqTreegrid.treegrid('getRoots'); //得到tree顶级node   
	            var nodeList=getChildNodeListG(roots)  //所有节点，不区分子节点
	            jqTreegrid.treegrid("expandAll")
	            
	            //搜索匹配的节点
	            var matchedNodeList = [];  
	            if (nodeList && nodeList.length>0) {
	                var node = null;  
	                for (var i=0; i<nodeList.length; i++) {
	                    node = nodeList[i];  
	                    var flag=0
	                    var obj=jqTreegrid.treegrid('find',node)
	                    for(var item in obj){   ///所有字段都检索  检索时不包含属性内容代码列-MKBTPDCode
	                        if ((item=="id")||(item=="ID")||(item=="children")||(item=="_parentId")||(item=="state")||(item=="checked")||(item=="MKBTPDCode")) continue
	                        if (isMatch(searchText, obj[item])) {  
	                           flag=1
	                        }
	                    }
	                    if (flag==1){  matchedNodeList.push(node);  } 
	                }  
	                //获取所有匹配的节点以及他的父节点及子节点       
	                var newmatchedNodeList=[]      
	                for (var i=0; i<matchedNodeList.length; i++) {  
	                    newmatchedNodeList=showMatchedNode(newmatchedNodeList,matchedNodeList[i]);  
	                }  
	                ///chenying update @20180515
	                //jqTreegrid.treegrid('getPanel').find('.datagrid-row tr[node-id]').each(function(){
	                jqTreegrid.treegrid('getPanel').find('.datagrid-row').each(function(){
						if (IsInArray(newmatchedNodeList,$(this).attr('node-id')))
	                    {
	                        
	                        $(this).show();     //兼容IE8 2018-12-20 chenying
	                        //$(this).attr('hidden',false)  //IE8下不起作用 
	                        
	                    }
	                    else
	                    {
		                    $(this).hide();
	                        //$(this).attr('hidden',true)   //IE8下不起作用
	                    }   
		            })
		           
		            
	            }
            }
            
            /** 
             * 将搜索匹配的节点 及其所有父节点。子节点存到数组中
             */  
            function showMatchedNode(narray,nodeid) {  
                //展示所有父节点  
                if (!IsInArray(narray,nodeid)){ narray.push(nodeid)}
                var pNode = jqTreegrid.treegrid("find",nodeid);  
                if (pNode)
                {
                    narray=showChild(narray,pNode)
                
                }
                
                while(pNode){
					pNode = jqTreegrid.treegrid("getParent",pNode.id)
					if(pNode)
				    {
						if (!IsInArray(narray,pNode.id)) {
	                        narray.push(pNode.id)
	                     }
					}
					else
					{
						break;
					}
				}
               
                // 展开所有子级
                function showChild(narray,node){
                    if (node.children && node.children.length > 0) {
                        for(var m=0;m<node.children.length;m++){ //循环顶级 node
                            if (!IsInArray(narray,node.children[m].id)) { narray.push(node.children[m].id)}
                            if (node.children[m].children && node.children[m].children.length > 0) {
                                showChild(narray,node.children[m])
                            }
                        } 
                    }
                    return narray
                };
                return narray
            }  
            
           
            
            ///获取节点的子节点，递归
            function getChildNodeListG(parentNode)
            {
                var ChildNodeList=[]
                for(var i=0;i<parentNode.length;i++){ //循环顶级 node
                    ChildNodeList.push(parentNode[i].id)
                    if (parentNode[i].children && parentNode[i].children.length > 0) {
                        ChildNodeList = ChildNodeList.concat(getChildNodeListG(parentNode[i].children))
                    }
                }  
                return ChildNodeList
            }
        }
            
    });  
      
         
})(jQuery);

/**
 * @abstract /treegrid 拖拽功能
 * @author chenying
 * @date 2018-03-20
 */

(function($){
    $.extend($.fn.treegrid.defaults, {
        onBeforeDrag: function(row){},  // return false to deny drag
        contextmenu: function(row){},   // 右键菜单
        onContextMenu: function(e, row){},
        onStartDrag: function(row){},
        onStopDrag: function(row){},
        onDragEnter: function(targetRow, sourceRow){},  // return false to deny drop
        onDragOver: function(targetRow, sourceRow){},   // return false to deny drop
        onDragLeave: function(targetRow, sourceRow){},
        onBeforeDrop: function(targetRow, sourceRow, point){},
        onDrop: function(targetRow, sourceRow, point){} // point:'append','top','bottom'
    });
    
    $.extend($.fn.treegrid.methods, {
        enableDnd: function(jq, id){
            if (!$('#treegrid-dnd-style').length){
                $('head').append(
                        '<style id="treegrid-dnd-style">' +
                        '.treegrid-row-top td{border-top:1px solid red}' +
                        '.treegrid-row-bottom td{border-bottom:1px solid red}' +
                        '.treegrid-row-append .tree-title{border:1px solid red}' +
                        '</style>'
                );
            }
            return jq.each(function(){
                var target = this;
                var state = $.data(this, 'treegrid');
                state.disabledNodes = [];
                var t = $(this);
                var opts = state.options;
                if (id){
                    var nodes = opts.finder.getTr(target, id);
                    var rows = t.treegrid('getChildren', id);
                    for(var i=0; i<rows.length; i++){
                        nodes = nodes.add(opts.finder.getTr(target, rows[i][opts.idField]));
                    }
                } else {
                    var nodes = t.treegrid('getPanel').find('tr[node-id]');
                }
                nodes.draggable({
                    disabled:false,
                    revert:true,
                    cursor:'pointer',
                    proxy: function(source){
                        var row = t.treegrid('find', $(source).attr('node-id'));
                        var p = $('<div class="tree-node-proxy"></div>').appendTo('body');
                        p.html('<span class="tree-dnd-icon tree-dnd-no">&nbsp;</span>'+row[opts.treeField]);
                        p.hide();
                        return p;
                    },
                    deltaX: 15,
                    deltaY: 15,
                    onBeforeDrag:function(e){
                        if (opts.onBeforeDrag.call(target, getRow(this)) == false){return false}
                        if ($(e.target).hasClass('tree-hit') || $(e.target).parent().hasClass('datagrid-cell-check')){return false;}
                        if (e.which != 1){return false;}
                        $(this).next('tr.treegrid-tr-tree').find('tr[node-id]').droppable({accept:'no-accept'});
//                      var tr = opts.finder.getTr(target, $(this).attr('node-id'));
//                      var treeTitle = tr.find('span.tree-title');
//                      e.data.startX = treeTitle.offset().left;
//                      e.data.startY = treeTitle.offset().top;
//                      e.data.offsetWidth = 0;
//                      e.data.offsetHeight = 0;
                    },
                    onStartDrag:function(){
                        $(this).draggable('proxy').css({
                            left:-10000,
                            top:-10000
                        });
                        var row = getRow(this);
                        opts.onStartDrag.call(target, row);
                        state.draggingNodeId = row[opts.idField];
                    },
                    onDrag:function(e){
                        var x1=e.pageX,y1=e.pageY,x2=e.data.startX,y2=e.data.startY;
                        var d = Math.sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2));
                        if (d>3){   // when drag a little distance, show the proxy object
                            $(this).draggable('proxy').show();
                            var tr = opts.finder.getTr(target, $(this).attr('node-id'));
                            var treeTitle = tr.find('span.tree-title');
                            e.data.startX = treeTitle.offset().left;
                            e.data.startY = treeTitle.offset().top;
                            e.data.offsetWidth = 0;
                            e.data.offsetHeight = 0;
                        }
                        this.pageY = e.pageY;
                    },
                    onStopDrag:function(){
                        $(this).next('tr.treegrid-tr-tree').find('tr[node-id]').droppable({accept:'tr[node-id]'});
                        for(var i=0; i<state.disabledNodes.length; i++){
                            var tr = opts.finder.getTr(target, state.disabledNodes[i]);
                            tr.droppable('enable');
                        }
                        state.disabledNodes = [];
                        var row = t.treegrid('find', state.draggingNodeId);
                        opts.onStopDrag.call(target, row);
                    }
                }).droppable({
                    accept:'tr[node-id]',
                    onDragEnter: function(e, source){
                        if (opts.onDragEnter.call(target, getRow(this), getRow(source)) == false){
                            allowDrop(source, false);
                            var tr = opts.finder.getTr(target, $(this).attr('node-id'));
                            tr.removeClass('treegrid-row-append treegrid-row-top treegrid-row-bottom');
                            tr.droppable('disable');
                            state.disabledNodes.push($(this).attr('node-id'));
                        }
                    },
                    onDragOver:function(e,source){
                        var nodeId = $(this).attr('node-id');
                        if ($.inArray(nodeId, state.disabledNodes) >= 0){return}
                        var pageY = source.pageY;
                        var top = $(this).offset().top;
                        var bottom = top + $(this).outerHeight();
                        
                        allowDrop(source, true);
                        var tr = opts.finder.getTr(target, nodeId);
                        tr.removeClass('treegrid-row-append treegrid-row-top treegrid-row-bottom');
                        if (pageY > top + (bottom - top) / 2){
                            if (bottom - pageY < 5){
                                tr.addClass('treegrid-row-bottom');
                            } else {
                                tr.addClass('treegrid-row-append');
                            }
                        } else {
                            if (pageY - top < 5){
                                tr.addClass('treegrid-row-top');
                            } else {
                                tr.addClass('treegrid-row-append');
                            }
                        }
                        if (opts.onDragOver.call(target, getRow(this), getRow(source)) == false){
                            allowDrop(source, false);
                            tr.removeClass('treegrid-row-append treegrid-row-top treegrid-row-bottom');
                            tr.droppable('disable');
                            state.disabledNodes.push(nodeId);
                        }
                    },
                    onDragLeave:function(e,source){
                        allowDrop(source, false);
                        var tr = opts.finder.getTr(target, $(this).attr('node-id'));
                        tr.removeClass('treegrid-row-append treegrid-row-top treegrid-row-bottom');
                        opts.onDragLeave.call(target, getRow(this), getRow(source));
                    },
                    onDrop:function(e,source){
                        var dest = this;
                        var action, point;
                        var tr = opts.finder.getTr(target, $(this).attr('node-id'));
                        if (tr.hasClass('treegrid-row-append')){
                            action = append;
                            point = 'append';
                        } else {
                            action = insert;
                            point = tr.hasClass('treegrid-row-top') ? 'top' : 'bottom';
                        }
                        
                        var dRow = getRow(this);
                        var sRow = getRow(source);
                        if (opts.onBeforeDrop.call(target, dRow, sRow, point) == false){
                            tr.removeClass('treegrid-row-append treegrid-row-top treegrid-row-bottom');
                            return;
                        }
                        action(sRow, dRow, point);
                        tr.removeClass('treegrid-row-append treegrid-row-top treegrid-row-bottom');
                        
                    }
                });
                
                
                function allowDrop(source, allowed){
                    var icon = $(source).draggable('proxy').find('span.tree-dnd-icon');
                    icon.removeClass('tree-dnd-yes tree-dnd-no').addClass(allowed ? 'tree-dnd-yes' : 'tree-dnd-no');
                }
                function getRow(tr){
                    var nodeId = $(tr).attr('node-id');
                    return t.treegrid('find', nodeId);
                }
                function append(sRow, dRow){
                    doAppend();
                    if (dRow.state == 'closed'){
                        t.treegrid('expand', dRow[opts.idField]);
                    }
                    
                    function doAppend(){
	                    var data = t.treegrid('pop', sRow[opts.idField]);
                        t.treegrid('append', {
                            parent: dRow[opts.idField],
                            data: [data]
                        });
                        opts.onDrop.call(target, dRow, data, 'append');
                        var parentid="";
                        var idArray=[];
                        
                        parentid=dRow.id
                        var ParentNode=t.treegrid("find",dRow.id);
                        idArray.push(sRow.id)
                        if (ParentNode.children && ParentNode.children.length > 0) {
                            for(var i=0;i<ParentNode.children.length;i++)
                            {
                                if (ParentNode.children[i].id==sRow.id) continue;
                                var nodeid=ParentNode.children[i].id
                                idArray.push(nodeid)
                            }
                        }
                        var orderstr=idArray.join("^")
                        
                        $.ajax({
                            url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName="+t.treegrid("options").ClassName+"&pClassMethod="+t.treegrid("options").DragMethodName,  //t.treegrid("options").dragUrl 
                            data:{"id":sRow.id,'parentid':parentid,'orderstr':orderstr},  
                            type:"POST",
                            success: function(data){
                                 	  var data=eval('('+data+')'); 
									  if (data.success == 'true') {
										 // alert(sRow.id+"^"+parentid)
										   //t.treegrid('reload',parentid)
										   t.treegrid('expandFirstChildNodes',parentid)
									  } 
									  else { 
									  		t.treegrid('reload');
											var errorMsg ="保存失败！"
											if (data.errorinfo) {
												errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
											}
											$.messager.alert('操作提示',errorMsg,'error');
											
							
									}	
                                } 
                            });
                        
                    }
                }
                function insert(sRow, dRow, point){
	                var param = {};
                    if (point == 'top'){
                        param.before = dRow[opts.idField];
                    } else {
                        param.after = dRow[opts.idField];
                    }
                    
                    var data = t.treegrid('pop', sRow[opts.idField]);
                    param.data = data;
                    t.treegrid('insert', param);
                    opts.onDrop.call(target, dRow, data, point);
                    
                    var parentid="";
                    var idArray=[];
                    
                    
                    ///dRow目标行,sRow 被移动行，point：top/bottom/append
                    var ParentNode =t.treegrid("getParent",dRow.id);
                    if (ParentNode)
                    {
                        parentid=ParentNode.id
                        if (ParentNode.children && ParentNode.children.length > 0) 
                        {
                            for(var i=0;i<ParentNode.children.length;i++)
                            {
                                if (ParentNode.children[i].id==sRow.id) continue
                                var nodeid=ParentNode.children[i].id
                                
                                if (ParentNode.children[i].id==dRow.id)
                                {
                                    if (point=="top")
                                    {
                                        nodeid=sRow.id+"^"+ParentNode.children[i].id
                                    }
                                    if (point=="bottom")
                                    {
                                        nodeid=ParentNode.children[i].id+"^"+sRow.id
                                    }
                                }
                                idArray.push(nodeid)
                                
                            }
                        }
                    }
                    else
                    {
                        ///第一级，根节点为空时
                        ThisNode=t.treegrid('getRoots')
                        if (ThisNode && ThisNode.length > 0) 
                        {
                            for(var i=0;i<ThisNode.length;i++)
                            {
                                if (ThisNode[i].id==sRow.id) continue
                                var nodeid=ThisNode[i].id
                                if (ThisNode[i].id==dRow.id)
                                {
                                    if (point=="top")
                                    {
                                        nodeid=sRow.id+"^"+ThisNode[i].id
                                    }
                                    if (point=="bottom")
                                    {
                                        nodeid=ThisNode[i].id+"^"+sRow.id
                                    }
                                }
                                idArray.push(nodeid)
                                
                            }
                        }
                    }
                    var orderstr=idArray.join("^")
                     $.ajax({
                            url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName="+t.treegrid("options").ClassName+"&pClassMethod="+t.treegrid("options").DragMethodName,  //t.treegrid("options").dragUrl 
                            data:{"id":sRow.id,'parentid':parentid,'orderstr':orderstr},  
                            type:"POST",
                            success: function(data){
                            		  var data=eval('('+data+')'); 
									  if (data.success == 'true') {
										  	//t.treegrid('reload',parentid)
										  	t.treegrid('expandFirstChildNodes',parentid)
										 	//alert(sRow.id+"^"+parentid)
									  } 
									  else { 
									  		t.treegrid('reload');
											var errorMsg ="保存失败！"
											if (data.errorinfo) {
												errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
											}
											$.messager.alert('操作提示',errorMsg,'error');
											
							
									}	
                                } 
                            });
                }
            });
        },
        disableDnd:function(jq,id){
			return jq.each(function() {
				var target = this;
				var state = $.data(this, 'treegrid');
				state.disabledNodes = [];
				var t = $(this);
				var opts = state.options;
				if (id) {
					var nodes = opts.finder.getTr(target, id);
					var rows = t.treegrid('getChildren', id);
					for (var i = 0; i < rows.length; i++) {
						nodes = nodes.add(opts.finder.getTr(target, rows[i][opts.idField]));
					}
				} else {
					var nodes = t.treegrid('getPanel').find('tr[node-id]');
				}
				nodes.draggable({
					disabled: true,
					revert: true,
					cursor: 'pointer'});
			});
		}
        
        
    });
})(jQuery);
