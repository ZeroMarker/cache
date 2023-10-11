/**
 * @abstract combobox和combotree模糊查询 
 * @author chenying
 * @date 2018-03-20
 */

document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/ChinesePY.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/pageLoading.js"> </script>');

var MainFalg =tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPPageSizeForMain");
var PopFalg =10 //tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPPageSizeForPop"); 
var AutFalg =tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPPageSizeForAut"); 
var ComboFalg =tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPPageSizeForCombo"); 
(MainFalg == "") ? PageSizeMain=20 : PageSizeMain = parseInt(MainFalg);    //主表格默认显示条数  PageSizeMain
(PopFalg == "") ?  PageSizePop=12 : PageSizePop = parseInt(PopFalg);    //弹出窗口表格默认显示条数 PageSizePop
(AutFalg == "") ?  PageSizeAut=20 : PageSizeAut = parseInt(AutFalg);    //授权树默认显示条数  PageSizeAut
(ComboFalg == "") ? PageSizeCombo=10 : PageSizeCombo =parseInt(ComboFalg);   //下拉框默认显示条数   PageSizeCombo
 //备份form表单 submit方法
var _submit = $.fn.form.methods.submit
//重写 方法中的url
$.fn.form.methods.submit = function(opt,params){
    var fn = {
        url:''
        //onSubmit:function(param){}
    }
    if(params.url){
	  var MWToken = ""
      if("undefined"!=typeof websys_getMWToken){
        MWToken=websys_getMWToken()//在url里加token
      }else if("undefined"!=typeof parent.CDSS_GetToken){
        MWToken=parent.CDSS_GetToken()//在url里加token
      }else if("undefined"!=typeof parent.parent.CDSS_GetToken){
        MWToken=parent.parent.CDSS_GetToken()//在url里加token
      }
      if(MWToken){
	  	fn.url = params.url+"&MWToken="+MWToken
	  }else{
	  	fn.url = params.url
	  } 
    }
    //扩展增强处理 
    var _opt = $.extend(params,{  
    	url:fn.url
    });
    return _submit(opt,params);    
}

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
        /*up:function(){  
            console.log('up');  
        },  
        down:function(){  
            console.log('down');  
        },  
        enter:function(){  
            console.log('enter');  
        }
        ,  */
        query:function(q){  
            //2018-12-18检索时显示子节点和所有父节点。
            var t = $(this).combotree('tree');  
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
        //只查询出符合条件的节点（无论父节点还是子节点）。
        searchLeaf: function(jqTree, searchText) {  
            searchText=searchText.toUpperCase();
            
            //easyui tree的tree对象。可以通过tree.methodName(jqTree)方式调用easyui tree的方法  
            var tree = this;  
            //获取所有的树节点  
            var nodeList = getAllNodes(jqTree, tree);  
            console.log(nodeList) 
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
                console.log(matchedNodeList)
                //隐藏所有节点  
                for (var i=0; i<nodeList.length; i++) {  
                    $(".tree-node-targeted", nodeList[i].target).removeClass("tree-node-targeted");  
                    $(nodeList[i].target).hide();  
                }             
                  
                //展示匹配的子节点。
                function showMatchedLeafNode(jqTree, tree, node) {  
                    //展示所有父节点  
                    $(node.target).show();  
                    $(".tree-title", node.target).addClass("tree-node-targeted");  
                    var pNode = node;  
                    while ((pNode = tree.getParent(jqTree, pNode.target))) {  
                        $(pNode.target).show();  
                        console.log( pNode.target)
                        
                    } 
                }
                //展示所有匹配的节点以及父节点              
                for (var i=0; i<matchedNodeList.length; i++) {  
                    showMatchedLeafNode(jqTree, tree, matchedNodeList[i]);  
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
 * 重写方法：datagrid的[hideColumn,showColumn]
 * 解决问题：复合表头隐藏列时表头出现错位
 * 
 * 需要引入上一篇中的jquery.table2tree.js
 * @author  attwice@qq.com
 * @date    2013/12/11
 */
/*(function($){
    $.extend($.fn.datagrid.methods, {
        hideColumn:function (jq, field){
            return jq.each(function(){
                if($(this).datagrid("getColumnOption",field).hidden){
                    return;
                }
                
                var panel = $(this).datagrid("getPanel");
                panel.find("td[field=\""+field+"\"]").hide();
                
                var thiscell = getFieldTh(jq, field);
                if(!jq.data('table2tree')){
                    jq.table2tree({container:'thead'});
                }
                var upcells = jq.table2tree('getParentCells', thiscell);
                for(var i = 0; i < upcells.length; i++){
                    var uptd = panel.find('.datagrid-view2 tr.datagrid-header-row:eq(' + upcells[i].row + ') td:eq(' + upcells[i].col + ')');
                    var colspan = uptd.attr('colspan') || 1;
                    if(colspan == 1){
                        uptd.css('display','none');
                    }else{
                        uptd.attr('colspan',Number(colspan)-1);
                    }
                }
                
                $(this).datagrid("getColumnOption",field).hidden=true;
                $(this).datagrid("fitColumns");
            });
        },
        showColumn:function (jq, field){
            return jq.each(function(){
                if(!$(this).datagrid("getColumnOption",field).hidden){
                    return;
                }
                var panel=$(this).datagrid("getPanel");
                panel.find("td[field=\""+field+"\"]").show();               
                
                var thiscell = getFieldTh(jq, field);
                if(!jq.data('table2tree')){
                    jq.table2tree({container:'thead'});
                }
                var upcells = jq.table2tree('getParentCells', thiscell);
                for(var i = 0; i < upcells.length; i++){
                    var uptd = panel.find('.datagrid-view2 tr.datagrid-header-row:eq(' + upcells[i].row + ') td:eq(' + upcells[i].col + ')');
                    var colspan = uptd.attr('colspan') || 1;
                    if(uptd.css('display') == 'none'){
                        uptd.css('display','');
                    }else{
                        uptd.attr('colspan',Number(colspan)+1);
                    }
                }       
                
                $(this).datagrid("getColumnOption",field).hidden=false;
                $(this).datagrid("fitColumns");
            });
        } 
    });
    
    //获取field所在单元格dom
    function getFieldTh(jq, field){
        var trs =  jq.find("thead tr");
        //表头只有一行时直接返回
        if(trs.length <= 1) return;
        //该单元格坐标
        var rowIndex = 0, colIndex = 0, computedColIndex = 0;
        outer:for(var i = 0; i < trs.length; i++){
            var ths = $(trs.get(i)).find("th");
            var totalColspan = 0;
            for(var j = 0; j < ths.length; j++){
                var th = $(ths.get(j));
                var colspan = th.attr('colspan') || 1;
                totalColspan += Number(colspan);
                var dataOptions = th.attr('data-options');
                if(dataOptions && dataOptions.indexOf("field:'" + field + "'") != -1 || th.attr('field') == field){
                    return th.get(0);
                    //break outer;
                }
            }
        }
    }   
})(jQuery);

*/
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




/** 
 * @author chenying
 *  
 * @requires jQuery,EasyUI 
 *  
 * 为datagrid、treegrid增加表头菜单，用于显示或隐藏列，注意：冻结列不在此菜单中 
 */  
var createGridHeaderContextMenu = function(e, field) {  
    e.preventDefault();  
    var grid = $(this); //grid本身 
    var headerContextMenu = this.headerContextMenu; //grid上的列头菜单对象 
    //if (!headerContextMenu) {   ///如果拖拽列顺序，右键列头菜单顺序也变
        var tmenu = $('<div style="width:185px;overflow-y:auto;overflow-x:yes;"></div>').appendTo('body');  
        var fields = grid.datagrid('getColumnFields');  
        for ( var i = 0; i < fields.length; i++) {  
            var fildOption = grid.datagrid('getColumnOption', fields[i]);  
            var treeField=grid.datagrid('options').treeField;  //需要考虑树形列表里树分级列不能隐藏2018-04-18
            if (fields[i]!=treeField)
            {
                if (!fildOption.hidden) {  
                    $('<div iconCls="icon-ok" field="' + fields[i] + '"/>').html(fildOption.title).appendTo(tmenu);    //??
                } else {  
                    $('<div iconCls="icon-empty" field="' + fields[i] + '"/>').html(fildOption.title).appendTo(tmenu);  
                }  
              }
        }  
        headerContextMenu = this.headerContextMenu = tmenu.menu({  
            onClick : function(item) {  
                var field = $(item.target).attr('field');  
                var tablename=grid.datagrid('options').ClassTableName;
                ///??如果最后一个 还要隐藏，需要提示
                if (item.iconCls == 'icon-ok') {  
                    
                    grid.datagrid('hideColumn', field);  
                    var index="hidden"+"^"+field+"^"+"false";
                    var result = tkMakeServerCall("web.DHCBL.BDP.BDPUserHabitHisUi","SaveData",session['LOGON.USERID'],tablename,index);    
                    $(this).menu('setIcon', {  
                        target : item.target,  
                        iconCls : 'icon-empty'  
                    });  
                } else {  
                    grid.datagrid('showColumn', field); 
                    var index="hidden"+"^"+field+"^"+"true";
                    var result = tkMakeServerCall("web.DHCBL.BDP.BDPUserHabitHisUi","SaveData",session['LOGON.USERID'],tablename,index);
                    $(this).menu('setIcon', {  
                        target : item.target,  
                        iconCls : 'icon-ok'  
                    });  
                }  
            }  
        });  
    //}  
    headerContextMenu.menu('show', {  
        left : e.pageX,  
        top : e.pageY  
    });  
};  
$.fn.datagrid.defaults.onHeaderContextMenu = createGridHeaderContextMenu;  
$.fn.treegrid.defaults.onHeaderContextMenu = createGridHeaderContextMenu; 



/**
 * @abstract 树过滤
 * @author 陈莹
 * @return findByRadioCheck("mytree",searchtext,FilterCKv)     mytree为树的id,  searchtext为检索描述，FilterCKv为0（全部）,1（已选）,2（未选）
 * date:2018-3-29 
 */
findByRadioCheck = function(treeid,searchtext,FilterCKFlag){
        searchtext=searchtext.toUpperCase();
        //获取所有的树节点  
        var roots = $("#"+treeid).tree("getRoots");
        var nodeList = getChildNodeIDs(roots);
        function getChildNodeIDs(nodes) {   
            var childNodeID = [];  
            if (nodes && nodes.length>0) {             
                for (var i=0; i<nodes.length; i++) {  
                    childNodeID.push(nodes[i].id);
                    $(nodes[i].target).show();
                    //(nodes[i].target).attr("hidden",false);  //IE6、7、8下没效果
                    if (nodes[i].children && nodes[i].children.length > 0) {
                        childNodeID = childNodeID.concat(getChildNodeIDs(nodes[i].children));
                    }
                }  
            }  
            return childNodeID;  
        }
        //选择全部，则展示所有树节点  
        if ((FilterCKFlag == 0)&&(searchtext=="")) { 
            return;
        }  
        var matchedNodeList=[]
        //搜索匹配的节点并高亮显示  
        if (nodeList && nodeList.length>0) {  
            for (var i=0; i<nodeList.length; i++) {  
                var nodeid = nodeList[i];
                var node=$('#'+treeid).tree('find', nodeid);
                if ((((FilterCKFlag==1)&&(node.checked==true))||((FilterCKFlag==2)&&(node.checked==false))||(FilterCKFlag == 0))&&((isMatch(searchtext, node.text))))
                {
                    matchedNodeList.push(nodeid);  
                }  
            }  
            var  newmatchedNodeList=matchedNodeList
            //获取所有匹配的节点以及他的父节点及子节点       
            for (var i=0; i<matchedNodeList.length; i++) {
                var node = $('#'+treeid).tree('find', matchedNodeList[i]);
                var parent = $('#'+treeid).tree('getParent', node.target);
                while(parent)
                {
                    newmatchedNodeList.push(parent.id);  //第一个父节点
                    parent = $('#'+treeid).tree('getParent', parent.target);  //循环所有父节点
                    if(parent)
                    {
                        //if (!IsInArray(newmatchedNodeList,parent.id))
                        if (!isMatch(("^"+parent.id+"^"), ("^"+newmatchedNodeList.join("^")+"^")))      
                        {
                            newmatchedNodeList.push(parent.id);
                        }
                    }
                    else
                    {
                        break;
                    }
                }
            }  
            for (var i=0; i<nodeList.length; i++) {
                //if (!IsInArray(newmatchedNodeList,nodeList[i])) 
                if (!isMatch(("^"+nodeList[i]+"^"),("^"+newmatchedNodeList.join("^")+"^")))
                {
                    var node=$('#'+treeid).tree('find', nodeList[i]);
                    
                    $(node.target).hide();  ///缺点：反应慢   IE8下能用 
                    //$(node.target).attr("hidden",true);  //IE6、7、8下没效果
                }   
            }
        }  
    }
    
    
    
    
    
    
    
    
    /**
 * @abstract 用于HISUI中datagrid扩展的封装方法
 * @author ybq
 * @param $('#mygrid').datagrid("addToolbar",[{"text":"排序","handler":function(),"iconCls":'icon-lt-rt-37'}])   //添加按钮
 * @param $('#mygrid').datagrid("removeToolbar","修改")    //根据btn的名称删除按钮
 * @param $('#mygrid').datagrid（'columnMoving'）          //grid列可移动 移动结束保存用户习惯  tablename在保存用户习惯时使用
 * @param $('#mygrid').datagrid（'moveColumn',tablename）          //grid移动列,结束时要再次激活columnMoving
 * @return addToolbar();removeToolbar();columnMoving;moveColumn;
 * @CreatDate:2018-3-24
 * @UpdataDate:2018-3-31
 */
    

$.extend($.fn.datagrid.methods, {
  addToolbar: function(jq, items){  
       return jq.each(function(){  
            var dpanel = $(this).datagrid('getPanel');
            var toolbar = dpanel.children("div.datagrid-toolbar");

             //var toolbar = $(this).parent().prev("div.datagrid-toolbar");
             var tr = toolbar.find("tr");
             for(var i = 0;i<items.length;i++){
                 var item = items[i];

                 if(item === "-"){
                     toolbar.append('<div class="datagrid-btn-separator"></div>');
                 }else{
                    
                    try{
                        var td = $("<td></td>").appendTo(tr);
                        var b = $("<a href=\"javascript:void(0)\"></a>").appendTo(td);
                        b[0].onclick = eval(item.handler || function () {});
                        b.linkbutton($.extend({}, item, {
                                plain : true
                            }));
                    }catch(e){
                         var btn=$("<a href=\"javascript:void(0)\"></a>");
                         btn[0].onclick=eval(item.handler||function(){});
                         //btn.css("float","left").appendTo(toolbar).linkbutton($.extend({},item,{plain:true}));
                         btn.appendTo(toolbar).linkbutton($.extend({},item,{plain:true}));
                    }

                    

                 }
             }
             toolbar = null;
         });  

   },
  removeToolbar: function(jq, param){
    return jq.each(function(){
        var btns = $(this).parent().prev("div.datagrid-toolbar").find("a");
        var cbtn = null;
        if(typeof param == "number"){
            cbtn = btns.eq(param);
        }else if(typeof param == "string"){
            var text = null;
            btns.each(function(){
                text = $(this).data().linkbutton.options.text;
                if(text == param){
                   cbtn = $(this);
                   text = null;
                   return;
                }
          });
        }
        if(cbtn){
            var prev = cbtn.prev()[0];
            var next = cbtn.next()[0];
            if(prev && next && prev.nodeName == "DIV" && prev.nodeName == next.nodeName){
                $(prev).remove();
            }else if(next && next.nodeName == "DIV"){
                $(next).remove();
            }else if(prev && prev.nodeName == "DIV"){
                $(prev).remove();
            }
            cbtn.remove();
            cbtn= null;
        }
    });
  },
  
  columnMoving: function(jq){
        return jq.each(function(){
            var target = this;
            var cells = $(this).datagrid('getPanel').find('div.datagrid-header td[field]');
            var usertableName=$(this).datagrid('options').ClassTableName;
            var sqltableName=$(this).datagrid('options').SQLTableName;
            var rowidname=$(this).datagrid('options').idField;
            cells.draggable({
                revert:true,
                cursor:'pointer',
                edge:5,
                proxy:function(source){
                    var p = $('<div class="tree-node-proxy tree-dnd-no" style="display:none;position:absolute;border:1px solid #ff0000"/>').appendTo('body');
                    p.html($(source).text());
                    p.hide();
                    return p;
                },
                onBeforeDrag:function(e){
                    e.data.startLeft = $(this).offset().left;
                    e.data.startTop = $(this).offset().top;
                },
                onStartDrag: function(){
                    $(this).draggable('proxy').css({
                        left:-10000,
                        top:-10000
                    });
                },
                onDrag:function(e){
                    //右键点击列标题时，标题在标题框中飘过显示一下 2018-08-13
                    /*$(this).draggable('proxy').show().css({
                        left:e.pageX+15,
                        top:e.pageY+15
                    });*/
                    return false;
                }
            }).droppable({
                accept:'td[field]',
                onDragOver:function(e,source){
                    $(source).draggable('proxy').removeClass('tree-dnd-no').addClass('tree-dnd-yes');
                    $(this).css('border-left','1px solid #ff0000');
                },
                onDragLeave:function(e,source){
                    $(source).draggable('proxy').removeClass('tree-dnd-yes').addClass('tree-dnd-no');
                    $(this).css('border-left',0);
                },
                onDrop:function(e,source){
                    $(this).css('border-left',0);
                    var fromField = $(source).attr('field');
                    var toField = $(this).attr('field');
                    setTimeout(function(){
                        swapField(target,usertableName,fromField,toField);
                        $(target).datagrid();
                        $(target).datagrid('columnMoving');
                        function savecolumnmoved(fromField,toField,usertableName){
                            var index="";
                            if (fromField!=toField)
                            {
                                var index="move"+"^"+fromField+"^"+toField;
                                var result = tkMakeServerCall("web.DHCBL.BDP.BDPUserHabitHisUi","SaveData",session['LOGON.USERID'],usertableName,index);
                            }
                        }
                        savecolumnmoved(fromField,toField,usertableName)
                        //console.log(rowidname);
                        //HISUI_Funlib_Translation(target);
                        HISUI_Funlib_Sort(target);
                        //DisableFlag(DisableArray);
                    },0);
                }
            });
            
        });
    },
  moveColumn:function(jq,value){
    return jq.each(function(){  
      var fromAdndto=value.split('-');
      var usertableName=fromAdndto[0];
      var from=fromAdndto[1];
      var to=fromAdndto[2];
      swapField(this,usertableName,from,to);
    })
  }
});

/**
 * @abstract 用于grid中保存用户习惯
 * @author ybq
 * @param ShowUserHabit('ybqgrid',"User.CTCareProv");
 * @return obj
 * date:2018-3-31
 */
function ShowUserHabit(gridid){
    var usertableName=$('#'+gridid).datagrid('options').ClassTableName;
    //var columnsArray=$('#'+gridid).datagrid('options').columns;
    ///2018-07-10 对本来就显示的列和隐藏列 过滤操作
    var hidearray=new Array(),showarray=new Array()
    var columns=$('#'+gridid).datagrid('options').columns; ///columns[0]是object 
    for (var i in columns[0])
    {
        if ((columns[0][i].hidden==false)||(columns[0][i].hidden== null))
        {
            showarray.push(columns[0][i].field)
        }
        
        if (columns[0][i].hidden==true)
        {
            hidearray.push(columns[0][i].field)
        }
        
    }
    if (usertableName!=undefined)
    {
        var result = tkMakeServerCall("web.DHCBL.BDP.BDPUserHabitHisUi","ShowUserHabit",session['LOGON.USERID'],usertableName);
        if (result.indexOf("^")>-1)
        {
            if (result.indexOf(",")>-1)
            {
                var str= result.split(',');
                for(var i=0;i<str.length;i++){
                    var info=str[i].split('^');
                    try{
                        if(info[0]=="move"){
                          
                              $('#'+gridid).datagrid("moveColumn",usertableName+'-'+info[1]+'-'+info[2]);
                          
                        }
                        if(info[0]=="hidden"){
                            var field =info[1]
                            if(info[2]=="false"){    //hidden false 为隐藏，true 为显示
                                if(IsInArray(showarray,field))
                                {
                                    $('#'+gridid).datagrid('hideColumn', field)   ///隐藏列再显示的时候 自动根据数据决定列宽？？？怎么让他按照比例来？
                                }
                            }
                            if(info[2]=="true"){   //hidden false 为隐藏，true 为显示
                                
                                if(IsInArray(hidearray,field))
                                {
                                    $('#'+gridid).datagrid('showColumn', field)
                                    $('#'+gridid).datagrid('autoSizeColumn', field)
                                }
                            }
                           
                        }
                    }
                    catch(e){}
                }
            }
            else
            {
                var info=result.split('^');
                try{
                    if(info[0]=="move"){
                        $('#'+gridid).datagrid("moveColumn",usertableName+'-'+info[1]+'-'+info[2]);
                    }
                  
                
                    if(info[0]=="hidden"){
                        var field =info[1]
                        
                             if(info[2]=="false"){    //hidden false 为隐藏，true 为显示
                                if(IsInArray(showarray,field))
                                {
                                    $('#'+gridid).datagrid('hideColumn', field)   ///隐藏列再显示的时候 自动根据数据决定列宽？？？怎么让他按照比例来？
                                }
                            }
                            if(info[2]=="true"){   //hidden false 为隐藏，true 为显示
                                
                                if(IsInArray(hidearray,field))
                                {
                                    $('#'+gridid).datagrid('showColumn', field)
                                    $('#'+gridid).datagrid('autoSizeColumn', field)
                                }
                            }
                       
                    }
                }
                catch(e){}
            }
            try
            {
                //treegrid因为没有列拖拽功能，不用重新加载，否则影响树节点展开功能 2018-06-14
                if($('#'+gridid).datagrid('options').treeField==undefined)
                {
                    $('#'+gridid).datagrid();
                }
                
            }
            catch(e){}
            
        }
    }
}


/**
 * @abstract 用于grid中移动列调用函数
 * @author ybq
 * @param swapField(gridID,usertableName,from,to)
 * @return obj
 * date:2018-3-31
 */

function swapField(grid,usertableName,from,to){
    var columns = $(grid).datagrid('options').columns;
    //alert(JSON.stringify(columns))
    var cc = columns[0];
    _swap(from,to);
    function _swap(fromfiled,tofiled){
        var fromtemp;
        var totemp;
        var fromindex = 0;
        var toindex = 0;
        for(var i=0; i<cc.length; i++){
            if (cc[i].field == fromfiled){
                fromindex = i;
                fromtemp = cc[i];
            }
            if(cc[i].field == tofiled){
                toindex = i;
                totemp = cc[i];
            }
        }
        cc.splice(fromindex,1,totemp);
        cc.splice(toindex,1,fromtemp);
    }
    //$(grid).datagrid();
    $(grid).datagrid('columnMoving',usertableName);
}


/**
 * @abstract 用于HISUI中获取grid列表Rowid
 * @author ybq
 * @param grid,RowidName
 * @return Rowid
 * date:2018-3-24
 */
HISUI_Funlib_GetRowid=function(grid,RowidName){
  if(typeof(grid)=="string"){
    var _record=$('#'+grid).datagrid('getSelected');
  }; 
  if(typeof(grid)=="object"){
    var _record=$(grid).datagrid('getSelected');
  }
  //var _record=grid.getSelected();
  if(_record==null){
      $.messager.alert('错误提示','请选中一条数据！','error');
      return
  }

  for(var value in _record){//遍历对象属性名
      var rowid=_record[value];
      if(value==RowidName){
          return rowid
      }
  }
};
/**
 * @abstract 封装的翻译按钮
 * @author ybq
 * @param HISUI_Funlib_Translation('mygrid');
 * @return obj
 * date:2018-3-24
 */
HISUI_Funlib_Translation=function(grid){
   var sqltableName="",RowidName="";
  if(typeof(grid)=="string"){
    sqltableName=$('#'+grid).datagrid('options').SQLTableName
    RowidName=$('#'+grid).datagrid('options').idField
  }; 
  if(typeof(grid)=="object"){
    sqltableName=$(grid).datagrid('options').SQLTableName
    RowidName=$(grid).datagrid('options').idField
  }
  var flag=tkMakeServerCall('web.DHCBL.BDP.BDPTranslation','IfTransLation',sqltableName);
   if(flag=="true"){
    return ;
  }  
  var TransWin='<div id="TransWin" style="width:460px;height:auto;resizable:true;padding:10px;overflow:hidden; fit="true"></div>';
    var formsave='<form id="Transform-save">';
    var Transdiv='<div><table cellspacing=10 id="Transtable"><tr ><td style="text-align: right;width:64px;">翻译语言</td><td><input id="TextTrans" class="textbox hisui-combobox" style="width:207px"></input></td></tr></table></div>';
    //var tablegrid='<table id="Transtable"> </table >';
  var truewidth="460"

  function CreatTransDom(data){
    $(".tr-add").remove();  //插入元素前把之前插入的删除
    var data=eval('('+data+')');
    var length=data.totalCount;
    var flag=data.success
    if (flag!="false")
    {
        var height=155+40*length
        if (length>0){
            for(var i=0;i<length;i++){
              var descBefore=data.data[i].BTFieldDesc;
              var descAfter=data.data[i].BTTransDesc;
              var FieldName=data.data[i].BTFieldName;
              var TitleDesc=data.data[i].TitleDesc;
              var classAllName=data.data[i].classAllName;
              if (descBefore=="") continue
              //var tr= '<tr class="tr-add"><td style="width:100px;text-align:center">'+TitleDesc+'</td><td><input id="'+FieldName+'F" name="'+FieldName+'" type="text" class="hisui-validatebox" style="width:200px"></td><td style="text-align:center">'+descBefore+'</td></tr>';
              var tr= '<tr class="tr-add"><td style="text-align: right;width:64px;" id="titledesc">'+TitleDesc+'</td><td><input id="'+FieldName+'F" name="'+FieldName+'"  class="hisui-validatebox textbox" style="width:200px"></td><td style=""><input id="'+FieldName+'BF" name="'+FieldName+'B"  class="hisui-validatebox textbox" style="width:130px;"></td></tr>';
              $('#Transtable').append(tr);
              $('#'+FieldName+'F').validatebox({
                  //required: true
              });
              $("input[name="+FieldName+"]").val(descAfter);
              $("input[name="+FieldName+"B]").val(descBefore);
              var box = $("#"+FieldName+"BF");
              var value = box.prop("disabled");
                if(value == false){
                    box.attr("disabled", true);
                    //box.validatebox("setDisabled",true);
                    //box.validatebox("validate");
                }
                truewidth=$("#titledesc").outerWidth()+$("#"+FieldName+"F").outerWidth()+$("#"+FieldName+"BF").outerWidth()+20+40
                
                
            }
            /*
            $('#TransWin').dialog({
                height: height
            }).dialog("open");
            */

            
        }
    }
    else
    {       
        $.messager.alert("提示","没有需要翻译的字段,请在表结构登记界面设置是否可翻译!","error")
    }
  }
  function trans(sqltableName,languagecode,rowid){    ///加载form方法
    var flag=""
    $.ajax({
      url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPTranslation&pClassMethod=OpenData",
      data:{"TableName":sqltableName,"Languages":languagecode,"rowid":rowid},
      type:'POST',
      success:function(data){
        //$("#Transtable").empty();
        
        var resultdata=eval('('+data+')');
        flag=resultdata.success
        if (flag!="false")
        {
            CreatTransDom(data);
        }
      }
    });
    /*setTimeout(function(){

            
            $('#TransWin').dialog('open');
            $('#TransWin').window('center');
            $("#tran_save").removeClass("l-btn l-btn-small").addClass("l-btn l-btn-small green");
    },50)*/
    return flag
    //$('#TransWin').show();
  }
  function Save(mywin,sqltableName,languages,rowid,args){     ///保存方法
    $.ajax({
      url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPTranslation&pClassMethod=SaveData",
      data:{"TableName":sqltableName,"Languages":languages,"rowid":rowid,'args':args},
      type:'POST',
      success:function(data){
        var data=eval('('+data+')');
        if(data.success=='true'){
          $.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});
          //$("#Transtable").empty();
          mywin.close();
        }
        else{
          var errorMsg="修改失败！";
          if(data.errorinfo){
            errorMsg=errorMsg+'</br>错误信息:'+data.errorinfo
          }
          $.messager.alert('错误提示',errorMsg,'error')
        }
      }
    });
  }
  TransBtn=function(){
    var rowid=HISUI_Funlib_GetRowid(grid,RowidName);
    if(rowid==null) {
      return
    }    
    
    var num=tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","GetTransNum",sqltableName)
    if (num==0) //不显示翻译弹窗
    {
        $.messager.alert("提示","没有需要翻译的字段,请在表结构登记界面设置是否可翻译!","error")
        return
    }
    else
    {
        $("#Transform-save").empty();
        $('body').append(TransWin);
        $('#TransWin').append(formsave);
        $('#Transform-save').append(Transdiv);
        //$('#Transform-save').append(tablegrid);
        
        $('#TextTrans').combobox({
          //url:$URL+"?ClassName=web.DHCBL.BDP.BDPTranslation&QueryName=GetDataForCmb1&ResultSetType=array",
          url:$URL+"?ClassName=web.DHCBL.CT.SSLanguage&QueryName=GetDataForCmb1&ResultSetType=array",
          valueField:'CTLANCode',
          textField:'CTLANDesc',
          onBeforeLoad:function(param){
            param.table=sqltableName
          },
          onLoadSuccess:function(){
            var languagedesc=$(this).combobox('getData')[0].CTLANDesc;
            var languagecode=$(this).combobox('getData')[0].CTLANCode;
            $('#TextTrans').combobox('setText',languagedesc);
            $('#TextTrans').combobox('setValue',languagecode);

            trans(sqltableName,languagecode,rowid);
          },
          onSelect:function(record){
            var languagecode=record.CTLANCode;
            trans(sqltableName,languagecode,rowid);
            
          }
        });
        var Transwin=$HUI.dialog('#TransWin',{
          iconCls:'icon-w-switch',
          width:truewidth,
          resizable:true,
          title:'翻译',
          modal:true,
          buttons:[{
            text:'保存',
            id:'tran_save',
            handler:function(){
              if($('#Transform-save').form('validate')==false){
                return
              };
              var value="";
              var args="";
              $('#Transtable tr').each(function(){
                value=$(this).find('td').find('input').attr('name');
                if ((value!=undefined)&&(value!=""))
                {
                    value=value+'^'+$(this).find('td').find('input').val();
                    if(args!=""){
                      //args=args+';'+value
                      args=args+'&#'+value
                    }
                    else{
                      args=value
                    }
                }
              });
              var languagecode=$('#TextTrans').combobox('getValue');
              Save(Transwin,sqltableName,languagecode,rowid,args)
              
            }
          },{
           text:'关闭',
            handler:function(){
              //$("#Transtable").empty();
              Transwin.close();
            }
          }]
        });
           
        setTimeout(function(){
            if (truewidth!=460)
                {

                        $('#TransWin').dialog('resize',{width:truewidth})

                }
            },200)
                
            
        $('#TransWin').dialog('open');
        $('#TransWin').window('center');
        $("#tran_save").removeClass("l-btn l-btn-small").addClass("l-btn l-btn-small green"); 

            
        
        
        
        
    }
        
    
  };
 if(typeof(grid)=="object"){
    $(grid).datagrid("addToolbar",[{"text":"翻译","handler":TransBtn,"iconCls":'icon-translate-word'}])
  }
  if(typeof(grid)=="string"){
    $('#'+grid).datagrid("addToolbar",[{"text":"翻译","handler":TransBtn,"iconCls":'icon-translate-word'}])
  }
};
/**
 * @abstract 封装的排序按钮
 * @author ybq
 * @param HISUI_Funlib_Sort('mygrid');
 * @return obj
 * date:2018-3-24
 */
HISUI_Funlib_Sort=function(grid){

     var usertableName="",RowidName="";
     if(typeof(grid)=="string"){
        usertableName=$('#'+grid).datagrid('options').ClassTableName
        }; 
     if(typeof(grid)=="object"){
        usertableName=$(grid).datagrid('options').ClassTableName
        
      }
    
  var indexs="";var sortstr="";
  var sortWin='<div id="sortWin" style="width:600px;height:450px;padding:10px;"></div>';
  var sortGrid='<table id="sortGrid" data-options="fit:true,bodyCls:\'panel-body-gray\'"></table>';
  $('body').append(sortWin);
  $('#sortWin').append(sortGrid);
  // $('.datagrid-toolbar tr').append('<a plain="true" id="SortBtn" >排序</a>');
  // $('#SortBtn').linkbutton({
  //     iconCls: 'icon-lt-rt-37'
  // });
  GridLoad=function(usertableName,type,dir){
    sortstr="";
    $('#sortGrid').datagrid('load',{
      ClassName:"web.DHCBL.BDP.BDPSort",
      QueryName:"GetList",
      'tableName':usertableName,
      'type':type,
      'dir':dir
    });
    $('#sortGrid').datagrid('unselectAll');
  };
  var columns=[[
    {field:'SortId',title:'SortId',hidden:true},
    {field:'RowId',title:'对应表RowId',hidden:true},
    {field:'Desc',title:'描述',width:180},
    {field:'SortType',title:'排序类型',hidden:true},
    {field:'SortNum',title:'顺序号',editor:{'type':'numberbox'},width:180}
  ]];
  var sortGrid=$HUI.datagrid('#sortGrid',{
      url: $URL,
      queryParams:{
        ClassName:"web.DHCBL.BDP.BDPSort",
        QueryName:"GetList",
        'tableName':usertableName
      },
      columns: columns,  //列信息
      pagination: true,   //pagination  boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
      pageSize:20,
      pageList:[5,10,14,15,20,25,30,50,75,100,200,300,500,1000],
      singleSelect:true,
      idField:'SortId',
      fit:true,
      rownumbers:true,    //设置为 true，则显示带有行号的列。
      fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
      //remoteSort:false,  //定义是否从服务器排序数据。定义是否从服务器排序数据。true
      //toolbar:'#mytbar'
      toolbar:[],
      onClickCell:function(index, field, value){
        if(indexs!==""){
           $(this).datagrid('endEdit', indexs);
        }
        $(this).datagrid('beginEdit', index);
        indexs=index;
      },
      onAfterEdit:function(index, row, changes){
        var type=$HUI.combobox('#TextSort').getText();
        if(JSON.stringify(changes)!="{}"){
          if(sortstr!==""){
            sortstr=sortstr+'*'+usertableName+'^'+row.RowId+'^'+type+'^'+row.SortNum+'^'+row.SortId;
          }
          else{
            sortstr=usertableName+'^'+row.RowId+'^'+type+'^'+row.SortNum+'^'+row.SortId;
          }
        }
      },
      onClickRow:function(index,row){
      },
      onDblClickRow:function(index, row){
      }
  });
 var toolbardiv='<div id="Sortb"><table cellspacing=10><tr><td>排序类型</td><td><input id="TextSort" style="width:157px"></input></td><td><a plain="true" id="SortRefreshBtn" style="">重置</a><a plain="true" id="SortSaveBtn" >保存</a><a plain="true" id="SortUpBtn" >升序</a><a plain="true" id="SortLowBtn" >降序</a></td></tr></table></div>';

  $('#sortWin .datagrid-toolbar tr').append(toolbardiv);
  $('#SortRefreshBtn').linkbutton({
      iconCls: 'icon-reload'
  });
  $('#SortSaveBtn').linkbutton({
      iconCls: 'icon-save'
  });
  $('#SortUpBtn').linkbutton({
      iconCls: 'icon-arrow-top'
  });
  $('#SortLowBtn').linkbutton({
      iconCls: 'icon-arrow-bottom'
  });
  $('#SortRefreshBtn').click(function(event) {
    //$('#TextSort').combobox('reload');
    $HUI.combobox('#TextSort').reload();
    $HUI.combobox('#TextSort').setValue();
    GridLoad(usertableName,'','');


  });

  $('#SortUpBtn').click(function(event) {
    var type=$HUI.combobox('#TextSort').getText();
    GridLoad(usertableName,type,'ASC')
  });
  $('#SortLowBtn').click(function(event) {
    var type=$HUI.combobox('#TextSort').getText();
    GridLoad(usertableName,type,'DESC')
  });

  SortBtn=function(){
    var Sortwin=$HUI.dialog('#sortWin',{
      iconCls:'icon-w-list',
      resizeable:true,
      title:'排序(排序类型可手动录入)',
      modal:true, 
      onOpen:function(){
          GridLoad(usertableName,"",'ASC') // 重新载入数据
      },
      onClose:function(){
      }
    });
    $('#TextSort').combobox({
      url:$URL+"?ClassName=web.DHCBL.BDP.BDPSort&QueryName=GetDataForCmb1&ResultSetType=array",
      valueField:'SortType',
      textField:'SortType',
      onBeforeLoad:function(param){
        param.tableName=usertableName
      },
      onLoadSuccess:function(){
      },
      onSelect:function(record){
        var type=record.SortType;
        GridLoad(usertableName,type,'')
      }
    });
  };
  $('#SortSaveBtn').click(function(event){
    var type=$HUI.combobox('#TextSort').getText();
    if(type==""){
      $.messager.alert('错误提示','排序类型不能为空！','error');
      return
    }
    if(indexs!=""){
      $('#sortGrid').datagrid('endEdit', indexs);
    }
    if(sortstr==""){
      $.messager.alert('错误提示','请先修改数据！','error');
      return
    }

    $.ajax({
      url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPSort&pClassMethod=SaveData",
      data:{"sortstr":sortstr,"type":type},
      type:'POST',
      success:function(data){
        var data=eval('('+data+')');
        if(data.success=='true'){
            $.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});
         
          var types=$HUI.combobox('#TextSort').getText();
          GridLoad(usertableName,types,'')
          //$HUI.combobox('#TextSort').reload();
        }
        else{
          var errorMsg="修改失败！";
          if(data.errorinfo){
            errorMsg=errorMsg+'</br>错误信息:'+data.errorinfo
          }
          $.messager.alert('错误提示',errorMsg,'error')
        }
      }
    });
  });
  if(typeof(grid)=="string"){
    $('#'+grid).datagrid("addToolbar",[{"text":"排序","handler":SortBtn,"iconCls":'icon-sort'}])
  }
  if(typeof(grid)=="object"){
    $(grid).datagrid("addToolbar",[{"text":"排序","handler":SortBtn,"iconCls":'icon-sort'}])
  }
};
/**
 * @abstract 用于grid中Yes/No标记
 * @author ybq
 * @param formatter:ReturnFlagIcon
 * @return
 * date:2018-3-24
 * update:2019-11-18 zrf
 */
function ReturnFlagIcon(value){
  if(value=='Y'||value=='1')
  {
    //return "<img src='../scripts/bdp/Framework/icons/yes.png' style='border: 0px'/>";
    if((typeof HISUIStyleCode=='string') && (HISUIStyleCode=='lite')){ //极简模式
        return "<font color='#13AE37'>是</font>"
    }else{
        return "<font color='#21BA45'>是</font>"
    }
  }
    else if(value=='N'||value=='0')
  {
    //return "<img src='../scripts/bdp/Framework/icons/no.png' style='border: 0px'/>";
    if((typeof HISUIStyleCode=='string') && (HISUIStyleCode=='lite')){ //极简模式
        return "<font color='#EE0F0F'>否</font>"
    }else{
        return "<font color='#FF3D2C'>否</font>"
    }
  }
  else
    {
    return "";
  }
}

/**
 * @abstract: 用于grid中自定义快捷键
 * @author: ybq
 * @param: KeyMap(disableflag)
 * @return:
 * date:2018-3-24
 */
function KeyMap(disableflag){
  var keyvalue="";
  
  var OneKeyUp=tkMakeServerCall("web.DHCBL.BDP.BDPConfig","IfOneKeyMap");
  if(OneKeyUp=='N'){
    return
  }
  
  var KeyMapStr= tkMakeServerCall("web.DHCBL.BDP.BDPConfig","ShowKeyMapValue")
  var KeyMapArr=KeyMapStr.split('^');

  var AddindexS=KeyMapArr[0].indexOf('SHIFT');
  var AddindexC=KeyMapArr[0].indexOf('CTRL');
  var AddindexA=KeyMapArr[0].indexOf('ALT');

  var UpdataindexS=KeyMapArr[1].indexOf('SHIFT');
  var UpdataindexC=KeyMapArr[1].indexOf('CTRL');
  var UpdataindexA=KeyMapArr[1].indexOf('ALT');

  var DelindexS=KeyMapArr[2].indexOf('SHIFT');
  var DelindexC=KeyMapArr[2].indexOf('CTRL');
  var DelindexA=KeyMapArr[2].indexOf('ALT');

  var HelpindexS=KeyMapArr[3].indexOf('SHIFT');
  var HelpindexC=KeyMapArr[3].indexOf('CTRL');
  var HelpindexA=KeyMapArr[3].indexOf('ALT');

  var AddFlagCode=KeyMapArr[0].split('+');
  var AddFalgLen=AddFlagCode.length-1;
  var Addkeys=AddFlagCode[AddFalgLen];

  var UpdataFlagCode=KeyMapArr[1].split('+');
  var UpdataFalgLen=UpdataFlagCode.length-1;
  var Updatakeys=UpdataFlagCode[UpdataFalgLen];

  var DelFlagCode=KeyMapArr[2].split('+');
  var DelFalgLen=DelFlagCode.length-1;
  var Delkeys=DelFlagCode[DelFalgLen];

  var HelpFlagCode=KeyMapArr[3].split('+');
  var HelpFalgLen=HelpFlagCode.length-1;
  var Helpkeys=HelpFlagCode[HelpFalgLen];

  $(document).keydown(function(event) {
    if(event&&event.keyCode){
      keyvalue=event.key;
    }
    var timer = setTimeout(function () {
      keyvalue="";
    },1000);
    keyvalue=keyvalue.toUpperCase();
    if(disableflag.indexOf('add_btn')<0){
      if((AddindexS>=0)&&(AddindexC>=0)&&(AddindexA>=0)){
        if((event.shiftKey==true)&&(event.ctrlKey==true)&&(event.altKey==true)&&(keyvalue==Addkeys)){
          AddData();
        }
      }
      if((AddindexS>=0)&&(AddindexC>=0)&&(AddindexA<0)){
        if((event.shiftKey==true)&&(event.ctrlKey==true)&&(event.altKey==false)&&(keyvalue==Addkeys)){
          AddData();
        }
      }
      if((AddindexS>=0)&&(AddindexC<0)&&(AddindexA>=0)){
        if((event.shiftKey==true)&&(event.ctrlKey==false)&&(event.altKey==true)&&(keyvalue==Addkeys)){
          AddData();
        }
      }
      if((AddindexS<0)&&(AddindexC>=0)&&(AddindexA>=0)){
        if((event.shiftKey==false)&&(event.ctrlKey==true)&&(event.altKey==true)&&(keyvalue==Addkeys)){
          AddData();
        }
      }
      if((AddindexS>=0)&&(AddindexC<0)&&(AddindexA<0)){
        if((event.shiftKey==true)&&(event.ctrlKey==false)&&(event.altKey==false)&&(keyvalue==Addkeys)){
          AddData();
        }
      }
      if((AddindexS<0)&&(AddindexC>=0)&&(AddindexA<0)){
        if((event.shiftKey==false)&&(event.ctrlKey==true)&&(event.altKey==false)&&(keyvalue==Addkeys)){
          AddData();
        }
      }
      if((AddindexS<0)&&(AddindexC<0)&&(AddindexA>=0)){
        if((event.shiftKey==false)&&(event.ctrlKey==false)&&(event.altKey==true)&&(keyvalue==Addkeys)){
          AddData();
        }
      }
    }
    if(disableflag.indexOf('updata_btn')<0){
        
      if((UpdataindexS>=0)&&(UpdataindexC>=0)&&(UpdataindexA>=0)){
        if((event.shiftKey==true)&&(event.ctrlKey==true)&&(event.altKey==true)&&(keyvalue==Updatakeys)){
          UpdateData()
        }
      }
      if((UpdataindexS>=0)&&(UpdataindexC>=0)&&(UpdataindexA<0)){
        if((event.shiftKey==true)&&(event.ctrlKey==true)&&(event.altKey==false)&&(keyvalue==Updatakeys)){
          UpdateData()
        }
      }
      if((UpdataindexS>=0)&&(UpdataindexC<0)&&(UpdataindexA>=0)){
        if((event.shiftKey==true)&&(event.ctrlKey==false)&&(event.altKey==true)&&(keyvalue==Updatakeys)){
          UpdateData()
        }
      }
      if((UpdataindexS<0)&&(UpdataindexC>=0)&&(UpdataindexA>=0)){
        if((event.shiftKey==false)&&(event.ctrlKey==true)&&(event.altKey==true)&&(keyvalue==Updatakeys)){
          UpdateData()
        }
      }
      if((UpdataindexS>=0)&&(UpdataindexC<0)&&(UpdataindexA<0)){
        if((event.shiftKey==true)&&(event.ctrlKey==false)&&(event.altKey==false)&&(keyvalue==Updatakeys)){
          UpdateData()
        }
      }
      if((UpdataindexS<0)&&(UpdataindexC>=0)&&(UpdataindexA<0)){
        if((event.shiftKey==false)&&(event.ctrlKey==true)&&(event.altKey==false)&&(keyvalue==Updatakeys)){
          UpdateData()
        }
      }
      if((UpdataindexS<0)&&(UpdataindexC<0)&&(UpdataindexA>=0)){
        if((event.shiftKey==false)&&(event.ctrlKey==false)&&(event.altKey==true)&&(keyvalue==Updatakeys)){
          UpdateData()
        }
      }
    }
    if(disableflag.indexOf('del_btn')<0){
      if((DelindexS>=0)&&(DelindexC>=0)&&(DelindexA>=0)){
        if((event.shiftKey==true)&&(event.ctrlKey==true)&&(event.altKey==true)&&(keyvalue==Delkeys)){
          DelData()
        }
      }
      if((DelindexS>=0)&&(DelindexC>=0)&&(DelindexA<0)){
        if((event.shiftKey==true)&&(event.ctrlKey==true)&&(event.altKey==false)&&(keyvalue==Delkeys)){
          DelData()
        }
      }
      if((DelindexS>=0)&&(DelindexC<0)&&(DelindexA>=0)){
        if((event.shiftKey==true)&&(event.ctrlKey==false)&&(event.altKey==true)&&(keyvalue==Delkeys)){
          DelData()
        }
      }
      if((DelindexS<0)&&(DelindexC>=0)&&(DelindexA>=0)){
        if((event.shiftKey==false)&&(event.ctrlKey==true)&&(event.altKey==true)&&(keyvalue==Delkeys)){
          DelData()
        }
      }
      if((DelindexS>=0)&&(DelindexC<0)&&(DelindexA<0)){
        if((event.shiftKey==true)&&(event.ctrlKey==false)&&(event.altKey==false)&&(keyvalue==Delkeys)){
          DelData()
        }
      }
      if((DelindexS<0)&&(DelindexC>=0)&&(DelindexA<0)){
        if((event.shiftKey==false)&&(event.ctrlKey==true)&&(event.altKey==false)&&(keyvalue==Delkeys)){
          DelData()
        }
      }
      if((DelindexS<0)&&(DelindexC<0)&&(DelindexA>=0)){
        if((event.shiftKey==false)&&(event.ctrlKey==false)&&(event.altKey==true)&&(keyvalue==Delkeys)){
          DelData()
        }
      }
    }
      
    if((HelpindexS>=0)&&(HelpindexC>=0)&&(HelpindexA>=0)){
      if((event.shiftKey==true)&&(event.ctrlKey==true)&&(event.altKey==true)&&(keyvalue==Helpkeys)){
        alert('帮助')
      }
    }
    if((HelpindexS>=0)&&(HelpindexC>=0)&&(HelpindexA<0)){
      if((event.shiftKey==true)&&(event.ctrlKey==true)&&(event.altKey==false)&&(keyvalue==Helpkeys)){
        alert('帮助')
      }
    }
    if((HelpindexS>=0)&&(HelpindexC<0)&&(HelpindexA>=0)){
      if((event.shiftKey==true)&&(event.ctrlKey==false)&&(event.altKey==true)&&(keyvalue==Helpkeys)){
        alert('帮助')
      }
    }
    if((HelpindexS<0)&&(HelpindexC>=0)&&(HelpindexA>=0)){
      if((event.shiftKey==false)&&(event.ctrlKey==true)&&(event.altKey==true)&&(keyvalue==Helpkeys)){
        alert('帮助')
      }
    }
    if((HelpindexS>=0)&&(HelpindexC<0)&&(HelpindexA<0)){
      if((event.shiftKey==true)&&(event.ctrlKey==false)&&(event.altKey==false)&&(keyvalue==Helpkeys)){
        alert('帮助')
      }
    }
    if((HelpindexS<0)&&(HelpindexC>=0)&&(HelpindexA<0)){
      if((event.shiftKey==false)&&(event.ctrlKey==true)&&(event.altKey==false)&&(keyvalue==Helpkeys)){
        alert('帮助')
      }
    }
    if((HelpindexS<0)&&(HelpindexC<0)&&(HelpindexA>=0)){
      if((event.shiftKey==false)&&(event.ctrlKey==false)&&(event.altKey==true)&&(keyvalue==Helpkeys)){
        alert('帮助')
      }
    }
  });
}
/**
 * @abstract: 快捷键的配置面板
 * @author: ybq
 * @param: KeyMapWin() 
 * @return: obj(快捷键的配置面板)
 * date:2018-4-10
 */
function KeyMapWin(){
  var Win='<div id="KeyMapWin"><form id="KeyMapform" style="margin:10px"><table id="KeyMaptable"></table></form><div>';
  $('body').append(Win);
  $('#KeyMaptable').append('<tr><td>添加功能&nbsp;</td><td><input id="AddKeyMap" ></input></td></tr>');
  $('#KeyMaptable').append('<tr><td>修改功能&nbsp;</td><td><input id="UpdataKeyMap" ></input></td></tr>');
  $('#KeyMaptable').append('<tr><td>删除功能&nbsp;</td><td><input id="DelKeyMap" ></input></td></tr>');
  $('#KeyMaptable').append('<tr><td>帮助功能&nbsp;</td><td><input id="HelpKeyMap" ></input></td></tr>');
  var KeyMapData=tkMakeServerCall("web.DHCBL.BDP.BDPConfig","ShowKeyMapValue"); 
  var KeyMapArr=KeyMapData.split("^");
  $('#AddKeyMap').val(KeyMapArr[0]);
  $('#UpdataKeyMap').val(KeyMapArr[1]);
  $('#DelKeyMap').val(KeyMapArr[2]);
  $('#HelpKeyMap').val(KeyMapArr[3]);
  CreatKey('AddKeyMap');
  CreatKey('UpdataKeyMap');
  CreatKey('DelKeyMap');
  CreatKey('HelpKeyMap');
  var KeyMapWin=$HUI.dialog('#KeyMapWin',{
      iconCls:'icon-write-order',
      resizeable:true,
      title:'快捷键配置',
      modal:true,
      buttons:[{
        text:'保存',
        iconCls:'KeyMap_btn_save',
        handler:function(){
          var str=$('#AddKeyMap').val().toUpperCase()+"^"+$('#UpdataKeyMap').val().toUpperCase()+"^"+$('#DelKeyMap').val().toUpperCase()+"^"+$('#HelpKeyMap').val().toUpperCase();
          var saveflag =tkMakeServerCall("web.DHCBL.BDP.BDPConfig","SaveKeyMapData",str);
          if(saveflag){
            $.messager.alert("提示","保存成功!",'info')
            $("#KeyMaptable").empty();
            KeyMapWin.close();
          }else{
            $.messager.alert("提示","保存失败!",'error')
          }   
        }
      },{
        text:'关闭',
        iconCls:'KeyMap_btn_close',
        handler:function(){
          $("#KeyMaptable").empty();
          KeyMapWin.close();
        }
      }]
    });
  function CreatKey(id){
    var keyvalue=""
    $('#'+id).keydown(function(event){
      keyvalue=event.key;
      var timer = setTimeout(function () {
        keyvalue="";
      },200);
      if((event.shiftKey==true)&&(event.ctrlKey==true)&&(event.altKey==true)&&(keyvalue!="")){
        $('#'+id).val('Shift+Ctrl+Alt+');
      }
      if((event.shiftKey==true)&&(event.ctrlKey==true)&&(event.altKey==false)&&(keyvalue!="")){
        $('#'+id).val('Shift+Ctrl+');
      }
      if((event.shiftKey==true)&&(event.ctrlKey==false)&&(event.altKey==true)&&(keyvalue!="")){
        $('#'+id).val('Shift+Alt+');
      }
      if((event.shiftKey==false)&&(event.ctrlKey==true)&&(event.altKey==true)&&(keyvalue!="")){
        $('#'+id).val('Ctrl+Alt+');
      }
      if((event.shiftKey==true)&&(event.ctrlKey==false)&&(event.altKey==false)&&(keyvalue!="")){
        $('#'+id).val('Shift+');
      }
      if((event.shiftKey==false)&&(event.ctrlKey==true)&&(event.altKey==false)&&(keyvalue!="")){
        $('#'+id).val('Ctrl+');
      }
      if((event.shiftKey==false)&&(event.ctrlKey==false)&&(event.altKey==true)&&(keyvalue!="")){
        $('#'+id).val('Alt+');
      }
      if((event.shiftKey==false)&&(event.ctrlKey==false)&&(event.altKey==false)&&(keyvalue!="")){
        $('#'+id).val('Shift+Ctrl+');
      }
    });
  }
}

/**
 * @abstract: 用于grid中元素是否可编辑
 * @author: ybq
 * @param: DisableFlag(DisableArray) 
 * @return:
 * date:2018-4-10
 */
var disablebtnflag=[];
DisableFlag=function(DisableArray){
  
  if(typeof(DisableArray) != 'undefined')
  {
    for(var property in DisableArray){
      if((DisableArray[property]=='N')&&(property.indexOf('btn')<0)){
        var doms=$("#"+property).parent();
        var arrowspan=doms.find('.combo-arrow');
        var dom=doms.find('input');
        var ins=doms.find('ins');
        for(var j=0;j<=(dom.length-1);j++){
          dom[j].setAttribute("readonly","readonly");
          dom[j].style.setProperty('background-color','rgb(235, 235, 228)');
        }
        arrowspan.unbind();
        arrowspan.css("background-color",'rgb(235, 235, 228)');
        ins.unbind();
        ins.css("background-color",'rgb(235, 235, 228)');
      }
      if((DisableArray[property]=='N')&&(property.indexOf('btn')>=0)){
        $("#"+property).linkbutton('disable');
        disablebtnflag.push(property);
      }
    }
  }
}
/**
 * @abstract: 用于grid中返回按钮是否可用
 * @author: ybq
 * @param: ReturnDisableFlagbtn(btn,disablebtnflag)
 * @return: true/false
 * date:2018-4-10
 */
ReturnDisableFlagbtn=function(btn,disablebtnflag){
  var _btnflag=0;
  for(var i=0;i<=disablebtnflag.length-1;i++){
      if(disablebtnflag[i].indexOf(btn)>=0){
      _btnflag=1;
    }
  }
  if(_btnflag){
    return true
  }
  else{
    return false
  }
}
/**
 * @abstract: 用于获取url传的参数
 * @author: chenghegui
 * @param: paramname
 * @return: param
 * @date:2018-4-23
 */
GetURLParams=function(name){
    var search =document.location.search;
    var pattern =new RegExp("[?&]"+name+"\=([^&]+)", "g");
    var matcher = pattern.exec(search);
    var items =null;
    if(null !=matcher){
    try{
        items = decodeURIComponent(decodeURIComponent(matcher[1]));
    }catch(e){
        try{
            items =decodeURIComponent(matcher[1]);
        }catch(e){
            items = matcher[1];
        }
      }
    }
 return items;
}
/**
 * @abstract: 用于获取浏览器信息
 * @author: chenghegui
 * @param: 
 * @return: 类似"Chrome:64","IE:11","IE:8"
 * @date:2018-6-6
 */
//获取浏览器
getBrowserAndVersion=function(){
    var Sys = {};
    var ua = navigator.userAgent.toLowerCase();
    var s;
    (s = ua.match(/msie ([\d.]+)/)) ? Sys.ie = s[1] :
    (s = ua.match(/firefox\/([\d.]+)/)) ? Sys.firefox = s[1] :
    (s = ua.match(/chrome\/([\d.]+)/)) ? Sys.chrome = s[1] :
    (s = ua.match(/opera.([\d.]+)/)) ? Sys.opera = s[1] :
    (s = ua.match(/version\/([\d.]+).*safari/)) ? Sys.safari = s[1] : 0;

    //获取浏览器版本   
    var browerInfo="" 
    if(Sys.ie) browerInfo='IE:'+Sys.ie;   //非IE11
    else if(Sys.firefox) browerInfo='Firefox:'+Sys.firefox;
    else if(Sys.chrome) browerInfo='Chrome:'+Sys.chrome;
    else if(Sys.opera) browerInfo='Opera:'+Sys.opera;
    else if(Sys.safari) browerInfo='Safari:'+Sys.safari;
    else if ("ActiveXObject" in window)
    {
        browerInfo="IE:11"
    }
    else
    {
        browerInfo=""
    }
    return browerInfo;
}
    
 
/**
 * @abstract: 下拉检索框
 * @author: chenying
 * @param: paramname
 * @return: param
 * @date:2018-05-16
 */
$.parser.plugins.push("searchcombobox");//注册扩展组件
$.fn.searchcombobox = function (options, param) {//定义扩展组件

    //当options为字符串时，说明执行的是该插件的方法。
    if (typeof options == "string") { return $.fn.combobox.apply(this, arguments); }
    options = options || {};

    //当该组件在一个页面出现多次时，this是一个集合，故需要通过each遍历。
    return this.each(function () {
        var jq = $(this);

        //$.fn.combobox.parseOptions(this)作用是获取页面中的data-options中的配置
        var opts = $.extend({}, $.fn.combobox.parseOptions(this), options);
        //把配置对象myopts放到$.fn.combobox这个函数中执行。
        var myopts = $.extend(true, {
            delay:50,  //单位ms ，延迟查询
                  hasDownArrow:false, //隐藏下拉箭头
              mode:'remote',
              limitToList:false,  //设置为true时，输入的值只能是列表框中的内容
            enterNullValueClear:false,  //当为false时，在输入框内回车，没有匹配值不清空输入框。
            valueField: 'ID',
            textField: 'Desc',
            panelWidth:250,
            panelHeight:'auto',
            onSelect:function () 
            {   
                jq.combobox('textbox').focus();
            }
        }, opts);
        $.fn.combobox.call(jq, myopts);
        
        ///2020-05-29chenying 加载前获取输入框的值
        jq.combobox({
            onBeforeLoad: function(param){
                param.q = decodeURI(decodeURI(jq.combobox('getText')));

            /*},
            
            formatter : function(row) {
               // 名称过长时截取前一段，
               if (row.Desc != null) {
                    if (row.Desc.length > 15) {
                        var opts = jq.combobox('options');
                        var Desc = row[opts.textField];
         
                        row.Desc = Desc.substring(0, 15);
                        
                    }
                }
                return row.Desc;
            */
            }
        });
        /*jq.combobox('panel').bind('mouseover',function () {
            jq.tooltip({
                position: 'bottom',
                content: '<span style="color:white">' + val[i].Desc + '</span>',
                onShow: function () {
                    $(this).tooltip('tip').css({
                       // backgroundColor: '#dc3c00',
                      //  borderColor: '#dc3c00'
                    });
                },
                onHide: function () {
                    $(this).tooltip('destroy');                
                }
            }).tooltip("show");
        });*/
        jq.combobox('textbox').bind('click',function(){ 
            if (jq.combobox('getText')!="...")
            {
                jq.combobox('reload');
            }
            jq.combobox('textbox').focus().select()  //2018-09-05 重新点击时 默认之前输入的值为选中状态，方便删除
            jq.combobox('showPanel');
            if(jq.combobox('panel').height()>400)
            {
                jq.combobox('panel').height("400");  //限制弹出框的最大高度
            }  
            
        });
        
        
    });
};


/**
 * @abstract:  保存历史和频次记录
 * @author: chenying
 * @param:  调用： RefreshSearchData("User.CTUOM","15","A","kg") 
 * @flag:A / D
 * @return: param
 * @date:2018-05-17
 */   
RefreshSearchData=function(table,rowid,flag,desc){
    //alert(table+","+rowid+","+flag+","+desc)
    var dataStr="";
    if ((flag=="A")&(rowid!="")&(desc!=""))  //添加或者单击
    {
        dataStr=table+"^"+rowid+"^"+desc
        var rs=tkMakeServerCall("web.DHCBL.BDP.BDPDataHistory","SaveFH",dataStr)
    }
    if ((flag=="D")&(rowid!=""))  //删除
    {
        dataStr=table+"^"+rowid
        var rs=tkMakeServerCall("web.DHCBL.BDP.BDPDataHistory","DeleteFH",dataStr)
    }
    
}


//chenying
//公共--删除方法
//Datagrid_DelData("mygrid",DELETE_ACTION_URL)
Datagrid_DelData=function(gridid,deleteUrl)
{        
    var record = $('#'+gridid).datagrid('getSelected'); 
    if (!(record))
    {   
        $.messager.alert('错误提示','请先选择一条记录!','error');
        return;
    }
    var idfield=$('#'+gridid).datagrid('options').idField;
    if(!idfield)
    {
        $.messager.alert('错误提示','获取不到列表的idField!','error');
        return;
        
    }
    var id=eval('('+'record.'+idfield+')');
    $.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
        if (r){ 
            $.ajax({
                url:deleteUrl,  
                data:{
                    'id':id
                },  
                type:'POST',   
                success: function(data){
                          var data=eval('('+data+')'); 
                          if (data.success == 'true') {
                                
                                $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
                                $('#'+gridid).datagrid('reload');  // 重新载入当前页面数据  
                                $('#'+gridid).datagrid('unselectAll');  // 清空列表选中数据
                          } 
                          else { 
                                var errorMsg ='删除失败！'
                                if (data.info) {
                                    errorMsg =errorMsg+ '<br/>错误信息:' + data.info
                                }
                                $.messager.alert('操作提示',errorMsg,'error');
                        }           
                }  
            })
        }
    });
    
}

//chenying
//公共--删除方法
//Treegrid_DelData("mygrid",DELETE_ACTION_URL)
Treegrid_DelData=function(gridid,deleteUrl)
{        
    var record = $('#'+gridid).treegrid('getSelected'); 
    if (!(record))
    {   
        $.messager.alert('错误提示','请先选择一条记录!','error');
        return;
    }
    var idfield=$('#'+gridid).treegrid('options').idField;
    if(!idfield)
    {
        $.messager.alert('错误提示','获取不到列表的idField!','error');
        return;
        
    }
    var id=eval('('+'record.'+idfield+')');
    $.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
        if (r){ 
            $.ajax({
                url:deleteUrl,  
                data:{
                    'id':id
                },  
                type:'POST',   
                success: function(data){
                          var data=eval('('+data+')'); 
                          if (data.success == 'true') {
                                $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
                                $('#'+gridid).treegrid('remove',id); 
                          } 
                          else { 
                                var errorMsg ='删除失败！'
                                if (data.info) {
                                    errorMsg =errorMsg+ '<br/>错误信息:' + data.info
                                }
                                $.messager.alert('操作提示',errorMsg,'error');
                        }           
                }  
            })
        }
    });
    
}


//chenying
//公共--删除方法
//Tree_DelData("mytree",DELETE_ACTION_URL)
Tree_DelData=function(treeid,deleteUrl)
{        
    var record = $('#'+treeid).tree('getSelected'); 
    if (!(record))
    {   
        $.messager.alert('错误提示','请先选择一条记录!','error');
        return;
    }
    $.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
        if (r){ 
            $.ajax({
                url:deleteUrl,  
                data:{
                    'id':record.id
                },  
                type:'POST',   
                success: function(data){
                          var data=eval('('+data+')'); 
                          if (data.success == 'true') {
                                $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
                                $('#'+treeid).tree('remove',node.target); 
                          } 
                          else { 
                                var errorMsg ='删除失败！'
                                if (data.info) {
                                    errorMsg =errorMsg+ '<br/>错误信息:' + data.info
                                }
                                $.messager.alert('操作提示',errorMsg,'error');
                        }           
                }  
            })
        }
    });
    
}

/**
 * @abstract: 树形列表添加和修改数据后 重新加载部分节点
 * @author: chenying
 *  var parentid=$('#ParentMenuDr').combotree('getValue')
 * @param:  调用： ReloadTreegridNode("mygrid",parentid,5)
 * @notice： treegrid必须定义idField
 * @flag:  
 * @return: param
 * @date:2018-05-23
 */  
function ReloadTreegridNode(gridid,newparentid,id)
{
    if (id=="")  //新增
    {
        if (newparentid!="") {
             
             //$('#'+gridid).treegrid("collapse",newparentid)  //2018-12-20替换原来的 
             $('#'+gridid).treegrid('update',{id: newparentid,row: {state:'closed'}});
             
             
             //
        }
        
        //父节点为根节点时重新加载整个数据
        $('#'+gridid).treegrid('reload',newparentid);
        setTimeout(function(){
             $('#'+gridid).treegrid('expandFirstChildNodes',newparentid);
        },"500")
            
            
    }
    if (id!="")  //修改
    {
         ///重新加载这条数据所在原父节点和新父节点 下的所有子节点 
        var parentNode = $('#'+gridid).treegrid('getParent',id)
        if(parentNode){ 
            var oldparentid=parentNode.id;
        }
        else {
            var oldparentid="";
        } 
        if (newparentid==oldparentid)
        {
            $('#'+gridid).treegrid('reload',newparentid);
            setTimeout(function(){
                 $('#'+gridid).treegrid('expandFirstChildNodes',newparentid);
            },"500")
            
        }
        else
        {
            $('#'+gridid).treegrid('remove',id); 
            if (newparentid!="") { 
                //$('#'+gridid).treegrid("collapse",newparentid)  //2018-12-20替换原来的 
                $('#'+gridid).treegrid('update',{id: newparentid,row: {state:'closed'}});
            }
            $('#'+gridid).treegrid('reload',newparentid); 
            setTimeout(function(){
                 $('#'+gridid).treegrid('expandFirstChildNodes',newparentid);
            },"500")
        }
    }
}
/**
 * @abstract: 树形列表修改时判断父级是否选择了自己或者子节点
 * @author: chenying/shixiaowei
 * @param:  调用： if (justFlag(comboId,recordId,"mygrid")) {return; }
 * @flag:   
 * @return: param
 * @date:2018-06-13
 */ 
function justFlag(comboId,recordId,gridid)
{
        var flag=0;
        if((comboId!="")&&(recordId!=""))
        {
            if(comboId==recordId)
            {
                $.messager.alert('错误提示','树形层级分类有误！',"error");
                return 1;               
            }
            var parent=$('#'+gridid).treegrid('getParent',comboId);
            if(parent)
            {
                var parentId=parent.id;
                if(recordId==parentId)
                {
                    $.messager.alert('错误提示','树形层级分类有误！',"error");
                    return 1;
                }
                else
                {
                    if (justFlag(parentId,recordId,gridid))
                    {
                        return 1;
                    }
                }
            } 
        }
        return 0;
    }

/**
 * @abstract: 扩展单选下拉框和多选下拉框
 * @author: ybq　修改ｂｙ谷雪萍　可编辑表格里单选框样式有问题　$HUI.checkbox改为$HUI.radio
 * @param:  
        调用： 注意：comboboxs弃用 改用HISUI的$HUI.combobox加属性rowStyle:'checkbox', //显示成勾选行形式
        editor:{
            type:'comboboxradio',   comboboxradio或comboboxs
            options:{
                valueField:'CTCPTRowId',
                textField:'CTCPTDesc',
                url:$URL+"?ClassName=web.DHCBL.CT.CTCarPrvTp&QueryName=GetDataForCmb1&ResultSetType=array"
        }
 * @flag:   
 * @return: obj
 * @date:2018-07-12
 */ 
 
$.extend($.fn.datagrid.defaults.editors, {  
   comboboxradio: {
        init: function (container, options) {
            var cid=Math.floor((Math.random()*1000)+1);
            var comboboxradio = $("<input type=\"text\">").appendTo(container);
            options.formatter= function (row) { //formatter方法就是实现了在每个下拉选项前面增加checkbox框的方法  
                var opts = $(this).combobox('options');  
                //return '<label class="eaitor-label"><input class="eaitor-radio" type="radio"><span></span></label>' + row[opts.textField]  
                return "<input type='checkbox' class='eaitor-radio' id='"+cid+"-"+row[opts.valueField]+"' value='"+row[opts.valueField]+"'>"+row[opts.textField];
            },
            options.onShowPanel=function(){
                var $target=$(this)
                //将单选框渲染成hisui样式
                $HUI.radio('.eaitor-radio',{
                    onChecked:function(){//当点击单选框时，选中值
                        var check_id=$(this).attr("value");
                        if($target.combobox('getValue')!=check_id){
                            $target.combobox('select',check_id);
                            $target.combobox('hidePanel')
                        }
                    }               
                });
                var arr=$(this).combobox('getValue');
                $HUI.radio('#'+cid+"-"+arr).setValue(true);
                $('.eaitor-radio').each(function(){
                    if($(this).parent().hasClass('hischeckbox_square-blue')){
                        $(this).parent().removeClass('hischeckbox_square-blue').addClass('hisradio_square-blue')
                    }
                })
            };
            options.onSelect=function(row){
                var opts = $(this).combobox('options'); 
                $HUI.radio('.eaitor-radio').setValue(false);
                $HUI.radio('#'+cid+"-"+row[opts.valueField]).setValue(true);
            }
            comboboxradio.combobox(options || {});
            return comboboxradio;
        }, destroy: function (target) {
            $(target).combobox("destroy");
        }, getValue: function (target) {
            var opts = $(target).combobox("options");
            if (opts.multiple) {
                return $(target).combobox("getValues").join(opts.separator);
            } else {
                return $(target).combobox("getValue");
            }
        }, setValue: function (target, value) {
            var opts = $(target).combobox("options");
            if (opts.multiple) {
                if (value) {
                    $(target).combobox("setValues", value.split(opts.separator));
                } else {
                    $(target).combobox("clear");
                }
            } else {
                $(target).combobox("setValue", value);
            }
        }, resize: function (target, width) {
            $(target).combobox("resize", width);
        }
    },
    comboboxs: {
        init: function (container, options) {
            var cid=Math.floor((Math.random()*1000)+1);
            var comboboxs = $("<input type=\"text\">").appendTo(container);
            options.formatter=function (row) { //formatter方法就是实现了在每个下拉选项前面增加checkbox框的方法  
                var opts = $(this).combobox('options');  
                return "<input type='checkbox' class='eaitor-checkbox' id='"+cid+"-"+row[opts.valueField]+"' value='"+row[opts.valueField]+"'>"+row[opts.textField];
            };
            options.onShowPanel= function () {  //下拉框数据加载成功调用  
                var $target=$(this)
                //将多选框渲染成hisui样式
                $HUI.checkbox('.eaitor-checkbox',{
                    onChecked:function(){//当点击复选框时，选中值
                        var check_id=$(this).attr("value");
                        $target.combobox('select',check_id);
                     },
                    onUnchecked:function(){
                        var check_id=$(this).attr("value");
                        $target.combobox('unselect',check_id);                          
                    }                       
                });
                var arr=$(this).combobox('getValues');
                for(var j = 0; j < arr.length; j++) {
                    $HUI.checkbox('#'+cid+"-"+arr[j]).setValue(true);
                }  
            };  
            options.onSelect= function (row) { //选中一个选项时调用  
                
                var opts = $(this).combobox('options'); 
                $HUI.checkbox('#'+cid+"-"+row[opts.valueField]).setValue(true); 
            };
            options.onUnselect=function (row) {//不选中一个选项时调用  
                var opts = $(this).combobox('options'); 
                $HUI.checkbox('#'+cid+"-"+row[opts.valueField]).setValue(false); 
            };
            comboboxs.combobox(options || {});
            return comboboxs;
        }, destroy: function (target) {
            $(target).combobox("destroy");
        }, getValue: function (target) {
            var opts = $(target).combobox("options");
            if (opts.multiple) {
                return $(target).combobox("getValues").join(opts.separator);
            } else {
                return $(target).combobox("getValue");
            }
        }, setValue: function (target, value) {
            var opts = $(target).combobox("options");
            if (opts.multiple) {
                if (value) {
                    $(target).combobox("setValues", value.split(opts.separator));
                } else {
                    $(target).combobox("clear");
                }
            } else {
                $(target).combobox("setValue", value);
            }
        }, resize: function (target, width) {
            $(target).combobox("resize", width);
        }
    }
});


function stopPropagation(e) { 
    　　if (e.stopPropagation) 
    　　　　e.stopPropagation(); 
    　　else 
    　　　　e.cancelBubble = true; 
    }

///用于可视化功能元素授权
var checkflag=[];
function Disable(action,author,menuid,ObjectType,ObjectReference){
    if(action==1){
        //添加右上角刷新按钮
        $('body').append('<div  ><img  id="imgrefresh" style="height:auto;width:auto;position:absolute;top:1%;left:95%;z-index:99;cursor:pointer;opacity:0.5" src="../scripts_lib/hisui-0.1.0/dist/css/icons/big/refresh.png" alt="刷新"></img></div>');
        $('#imgrefresh').mousedown(function(event) {
            window.location.reload();
        });

        $('body').append('<ul id="contextmenu" style="z-index:999999;display:none;position:absolute;background:#FFFFFF"><li ><a id="enablebtn" style="font-size:150%">启用</a></li><li><a id="disablebtn" style="font-size:150%">禁用</a></li></ul>');
        //禁用元素
        if(BDPFunLibDisableArray!="undefined"){
            for(var params in BDPFunLibDisableArray){
                if($('#'+params)[0]!=undefined){
                    if($('#'+params)[0].tagName=='A'){
                        $('#'+params).linkbutton('disable');
                        $('#'+params)[0].disabled=true;
                    }
                    if($('#'+params)[0].tagName=='INPUT'){
                        if($('#'+params).next()[0]!=undefined){
                            if($('#'+params).next()[0].tagName=='INS'){
                                $('#'+params).next().unbind('click mouseover'); 
                                $('#'+params).next()[0].readonly=true;
                                $('#'+params).parent().addClass('disabled')
                                //$('#'+params).parent().removeClass('hischeckbox_square-blue').addClass('hischeckbox_square-blue.disabled')
                                //$('#'+params).parent().next().append('<span>    已禁用</span>').unbind('click mouseover');
                            }
                            if($('#'+params).next()[0].tagName=='SPAN'){
                                $('#'+params).next()[0].readonly=true;
                                $('#'+params).next().find("input").attr("readonly",true)
                                    .css({'background-color':'#EBEBE4'})[0].readonly=true;
                                $('#'+params).next().find(".combo-arrow").unbind('click');
                            }
                        }
                        else{
                            $('#'+params).attr("readonly",true);
                            $('#'+params)[0].readonly=true;
                            $('#'+params).css({'background-color':'#EBEBE4'});
                        }
                    }
                }   
            }
        }
        //判断是否开启可视化功能元素授权
        if(!author){
            return
        }
        $('body').bind("contextmenu", function(){
            return false;
        });
        enableDom=function(id){
            var flag;
            $('* input,a,span,ins').each(function(index, el) {
                if($(this)[0].id==id){
                    flag=1
                }
            });
            if(flag){
                var target='#'+id;
                var elmentid=$(target)[0].id;
                if($(target).next()[0]!=undefined){
                    target=$(target).next()
                }
                saveData(target,elmentid,'enable')
                $('#disabledelment').find('p').each(function(index, el) {
                    if($(this)[0].textContent==elmentid){
                        $(this).remove()
                    }
                });
            }
            else{
                $.messager.alert('提示信息','该元素为自动生成,请先激活该元素所在面板！');   
            }
        }
        //右下角已禁用元素列表-滑动显示
        $('body').append('<div  ><img  id="imgdisabledelment" style="height:auto;width:auto;position:absolute;top:80%;left:85%;z-index:99;cursor:pointer;opacity:0.5" src="../scripts/bdp/Framework/icons/mkb/tooltipbtn.png" alt="收藏夹"></img></div>');
        $('body').append('<div  ><div  id="disabledelment" style="background:#3F3F3F;height:89%;width:40%;position:absolute;top:10%;left:100%;z-index:99;"><p style="color:#008FF0;margin:10px;font-size:20px">已禁用元素:</p></div></div>');
        $("#imgdisabledelment").mouseover(function(){
            $("#imgdisabledelment").css({opacity:1});  
            $("#disabledelment").animate({left:'75%'});
        });
        $("#disabledelment").mouseleave(function(){
           $("#imgdisabledelment").css({opacity:0.5});  
           $("#disabledelment").animate({left:'100%'});
        });
        if(BDPFunLibDisableArray!="undefined"){
            for(var params in BDPFunLibDisableArray){
                $('#disabledelment').append('<p style="color:#FFFFFF;margin:10px" >'+params+'<a href="javascript:void(0)""  onclick=enableDom("'+params+'")><img style="margin-left:5px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png"></img></a></p>')
            }
        } 
        
        $('#enablebtn').hover(function(){
            $(this).parent().next().css({'background':'#FFFFFF'})
            $(this).parent().css({'background':'#aaccf6'})
        }).bind("contextmenu", function(){
            return false;
        });
        $('#disablebtn').hover(function(){
            $(this).parent().prev().css({'background':'#FFFFFF'})
            $(this).parent().css({'background':'#aaccf6'})
        }).bind("contextmenu", function(){
            return false;
        });
        //按条件给功能元素添加右键事件-禁用或启用
        $('* input,a,span,ins').each(function(index, el) {
            var target=this;
            if(($(target)[0].id!="")&&($(target)[0].id!="disablebtn")&&($(target)[0].id!="enablebtn")){
                var elmentid=$(target)[0].id;
                
                if(($(target).next()[0]!=undefined)&&($(target).next()[0].tagName=="INS")){
                    target=$(target).next()
                }
                mouseEvent(target,elmentid)    
            }
        });
    }
    if(action==2){
        
        $('* ins').each(function(index, el) {
            if($(this).prev()[0].id!=""){
                if(BDPFunLibDisableArray!="undefined"){
                    for(var params in BDPFunLibDisableArray){
                        if($(this).prev()[0].id==params){
                            if($(this).parent().is('.hischeckbox_square-blue')){
                                $(this).parent().css({'background-position':'-72px 0','cursor':'default'});
                            }
                            if($(this).parent().is('.hischeckbox_square-blue.checked')){
                                $(this).parent().css({'background-position':'-96px 0'});
                            }
                        }
                    }
                }
                if(checkflag[$(this).prev()[0].id]==1){
                    if($(this).parent().is('.hischeckbox_square-blue')){
                        $(this).parent().css({'background-position':'0 0','cursor':'pointer'});
                    }
                    if($(this).parent().is('.hischeckbox_square-blue.checked')){
                        $(this).parent().css({'background-position':'-48px 0'});
                    }
                }
                if(checkflag[$(this).prev()[0].id]==2){
                    if($(this).parent().is('.hischeckbox_square-blue')){
                        $(this).parent().css({'background-position':'-72px 0','cursor':'pointer'});
                    }
                    if($(this).parent().is('.hischeckbox_square-blue.checked')){
                        $(this).parent().css({'background-position':'-96px 0'});
                    }
                }
            }
        });
        $('.dialog-button a').each(function(index, el) {
            if($(this)[0].id!=""){
                if(BDPFunLibDisableArray!="undefined"){
                    for(var params in BDPFunLibDisableArray){
                        if($(this)[0].id==params){
                            $(this).linkbutton('disable');
                            $(this)[0].disabled=true;
                        }
                    }
                }
                //判断是否开启可视化功能元素授权
                if(!author){
                    return
                }
                var elmentid=$(this)[0].id;
                mouseEvent(this,elmentid);
            }
        });
    }    

    function transtDesc(params){
        switch(params){
            case 'add_btn':
                return '添加'
                break;
            case 'update_btn':
                return '修改'
                break;
            case 'del_btn':
                return '删除'
                break;
            case 'btnSearch':
                return '查询'
                break;
            case 'btnRefresh':
                return '重置'
                break;
            case 'TextCode':
                return '代码(查询框)'
                break; 
            case 'TextDesc':
                return '描述(查询框)'
                break;   
            case 'save_btn':
                return '保存'
                break; 
            case 'close_btn':
                return '关闭'
                break;  
            default: 
                return params                                  
        }
    }
    
    function saveData(target,elmentid,type){

        function enabledom(){
            if($(target)[0].tagName=='A'){
                $(target).linkbutton('enable');
                $(target)[0].disabled=false;
                $('#enablebtn').hide(); 
            }
            if($(target)[0].tagName=='INPUT'){
                $(target).attr("readonly",false);
                $(target)[0].readonly=false;
                $(target).css({'background-color':'#ffffff'});
                $('#enablebtn').hide(); 
            }
            if($(target)[0].tagName=='INS'){
                //$(target).parent().next().find('span').remove(); 
                $(target)[0].readonly=false;
                checkflag[elmentid]=1
                if($(target).parent().is('.hischeckbox_square-blue')){
                    $(target).parent().css({'background-position-x':'0','cursor':'pointer'});
                }
                if($(target).parent().is('.hischeckbox_square-blue.checked')){
                    $(target).parent().css({'background-position-x':'-48px'});
                }
                $('#enablebtn').hide(); 
            }
            if($(target)[0].tagName=='SPAN'){
                $(target)[0].readonly=false;
                $(target).find("input").attr("readonly",false)
                    .css({'background-color':'#ffffff'})[0].readonly=false;
                $('#enablebtn').hide();

            }
            
        }
        function disabledom(){
            if($(target)[0].tagName=='A'){
                $(target).linkbutton('disable');
                $(target)[0].disabled=true;
                $('#disablebtn').hide(); 
            }
            if($(target)[0].tagName=='INPUT'){
                $(target).attr("readonly",true);
                $(target)[0].readonly=true;
                $(target).css({'background-color':'#EBEBE4'});
                $('#disablebtn').hide(); 
            }
            if($(target)[0].tagName=='INS'){
                $(target).unbind('click mouseover'); 
                //$(target).parent().next().append('<span>    已禁用</span>').unbind('click mouseover'); 
                $(target)[0].readonly=true;
               checkflag[elmentid]=2
                if($(target).parent().is('.hischeckbox_square-blue')){
                    $(target).parent().css({'background-position-x':'-72px','cursor':'default'});
                }
                if($(target).parent().is('.hischeckbox_square-blue.checked')){
                    $(target).parent().css({'background-position-x':'-96px'});
                }
                $('#disablebtn').hide(); 
                
            }
            if($(target)[0].tagName=='SPAN'){
                $(target)[0].readonly=true;
                $(target).find("input").attr("readonly",true)
                    .css({'background-color':'#EBEBE4'})[0].readonly=true;
                $(target).find(".combo-arrow").unbind('click');
                $('#disablebtn').hide();
            }
            
        }
        $.ajax({
            url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPAuthorize&pClassMethod=SaveAuthorizeDataNew",
            data:{ObjectType:ObjectType,ObjectReference:ObjectReference,Data:elmentid+':'+type,id:menuid},
            type:'GET',
            success:function(data){
            var data=eval('('+data+')');
            if(data.success=='true'){
                if(type=='enable'){
                    enabledom();
                    
                }
                if(type=='disable'){
                    disabledom();
                    
                }
            }
            else{
                var errorMsg="修改失败！";
                if(data.errorinfo){
                    errorMsg=errorMsg+'</br>错误信息:'+data.errorinfo
                }
                $.messager.alert('错误提示',errorMsg,'error')
            }
          }
        });
    }

    function mouseEvent(target,elmentid){
        $(target).unbind('mouseup').mouseup(function(e) {
            $('#enablebtn').unbind('click').click(function(){
                $('#disabledelment').find('p').each(function(index, el) {
                    if($(this)[0].innerHTML==elmentid){
                        $(this).remove()
                    }
                });
                
                saveData(target,elmentid,'enable')
                
            });
            $('#disablebtn').unbind('click').click(function(){
                $('#disabledelment').append('<p style="color:#FFFFFF;margin:10px" >'+elmentid+'<a href="javascript:void(0)""  onclick=enableDom("'+elmentid+'")><img style="margin-left:5px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png"></img></a></p>')
                saveData(target,elmentid,'disable')
                
            });
            if (3 == e.which) {
                //右键为3
                $("#contextmenu").find('li').css({'display':'block','padding':'0 8px 0 8px','cursor':'pointer'});
                if($(target)[0].tagName=='A'){
                    if($(target)[0].disabled){
                        $('#disablebtn').hide();
                        $('#enablebtn').show()
                    }
                    else{
                        $('#enablebtn').hide();
                        $('#disablebtn').show()
                    }
                }
                else{
                    if($(target)[0].readonly){
                        $('#disablebtn').hide();
                        $('#enablebtn').show()
                    }
                    else{
                        $('#enablebtn').hide();
                        $('#disablebtn').show()
                    }
                }
                //
                $("#contextmenu").css({
                    "left": $(this).offset().left+55,
                    "top": $(this).offset().top+4
                }).show();
                $('#contextmenu').hover("",function(event) {
                    setTimeout(function(){
                        $("#contextmenu").hide()
                        $("#contextmenu").find('li').css({'background':'#FFFFFF'})
                    },200)
                });
            } else if (1 == e.which) {

            }
        })
    } 
}


/**
 * @abstract 用于HISUI中禁用元素
 * @author zrf
 * @param    DisableItem(menuid)
 * @return 
 * date:2021-12-1
 */
function DisableItem(menuid){

    //获取被封禁的元素列 w ##class(web.DHCBL.MKB.FunctionalElement).GetDisableItemCode(216)   
    var itemstr=tkMakeServerCall("web.DHCBL.MKB.FunctionalElement", "GetDisableItemCode",menuid);
    //判断字符串是否全是中文
    function isChinese(temp)
    {
        var re=/[^\u4e00-\u9fa5]/;
        if(re.test(temp)) return false;
        return true;
    }

    //CodeSearch^TextSearch^QFlag^btnAdd^btnEdit^CMKBExport
    if (itemstr!="")
    {
        for (var m=0;m<itemstr.length;m++)
        {
            var itemcode=itemstr.split("^")[m]
            if (itemcode!=undefined)
            {
                var flag=isChinese(itemcode)
                if (flag)   //代码全是中文
                {
                    /*
                    $("div.editbutton").each(function(){
                        var sobj=$(this)
                        var obj=$(this)[0]
                        obj.setAttribute('data-options','disabled:false');
                        $(this)[0].onclick=''
                        $(this).css("opacity",0.3)
                    })
                    */
                    $(".editbutton").each(function(){
                        var obj=$(this) 
                        var sobj=obj[0]
                        var bttext=obj.context.innerText 
                        bttext=$.trim(bttext)   
                        var tagname=$(this).prop("tagName")
                        if ((tagname=="DIV")||(tagname=="div"))
                        {
                            if (bttext==itemcode)
                            {
                                var obj=$(this)[0]
                                obj.setAttribute('data-options','disabled:false');
                                $(this)[0].onclick=''
                                $(this).css("opacity",0.3)
                                //$(this).attr("disabled","disabled");
                               // $(this)[0].disabled = false;
                              // $(this).attr('data-options','disabled:false')
                               // $(this).setAttribute("style"," pointer-events:none;cursor: default;opacity: 0.3;");
                                //document.getElementById("btnDiv").setAttribute("disabled", "disabled");
                            }
                        }
                        else
                        {
                            if (bttext==itemcode)
                            {
                                //$(this).attr('disabled',true)
                                $(this)[0].onclick=''
                                $(this).css("opacity",0.3)
                            }
                        }
                              
                            
                    })
                }
                else{
                    var itemobj=document.getElementById(itemcode)
                    if ((itemobj==undefined)||(itemobj==null))
                    {
                        continue   
                    }
                    var classstr=$("#"+itemcode).attr("class");

                    if ((classstr==undefined)||(classstr==null))
                    {
                        continue   
                    }
                    else if (classstr=="searchbox-button")      //searchcombobox中的按钮
                    {
                        $("#"+itemcode).attr("href","javascript:void(0)");
                        $("#"+itemcode).attr("disabled", "disabled").unbind();
                        $("#"+itemcode).removeAttr("onclick");
                    }
                    else if (classstr.indexOf("searchbox")!=-1)     //searchbox
                    {
                        $("#"+itemcode).searchbox({ disabled: true}); 
                       // $("#"+itemcode).attr("disabled", true);
                        //$("#"+itemcode).searchbox('textbox').attr('disabled','disabled');
                    }
                    /*
                    else if (classstr=="combobox-f combo-f")
                    {
                        $("#"+itemcode).searchcombobox({ disabled: true });
                    }
                    */
                    
                    else if (classstr.indexOf("combo")!=-1)      //combobox
                    {
                        $("#"+itemcode).combobox({ disabled: true });
                    }
                    else if (classstr.indexOf("validatebox")!=-1)      //validatebox
                    {
                        $("#"+itemcode).attr("disabled", true);
                        //$("#"+itemcode).attr("readonly", true);
                    }
                    else if (classstr.indexOf("datebox")!=-1)      //datebox
                    {
                        $("#"+itemcode).datebox({ disabled: true });
                    }
                    else if (classstr.indexOf("datetimebox")!=-1)      //datetimebox
                    {
                        $("#"+itemcode).datetimebox({ disabled: true });
                    }
                    else if ((classstr.indexOf("button")!=-1)||(classstr.indexOf("btn")!=-1))     //button
                    {
                        $("#"+itemcode).linkbutton('disable');
                        //$("#"+itemcode).unbind() 
                    }
                    else if (classstr.indexOf("load")!=-1)      //load按钮
                    {
                        $("#"+itemcode).attr("href","javascript:void(0)");
                        $("#"+itemcode).attr("disabled", "disabled").unbind();
                        $("#"+itemcode).removeAttr("onclick");
                        $("#"+itemcode).css("opacity",0.3)
                    }
                    else if ((classstr.indexOf("lable")!=-1))   //lable
                    {
                        document.getElementById(itemcode).onclick=''; 
                    }
                }
                    

                    
            }
            else
            {
                break
            }   

        }
    }
    return true

};

/**
 * @abstract 获取当前日期
 * @author zrf
 * @param    getCurentDateStr()
 * @return 
 * date:2022-11-11
 */
    function getCurentDateStr()
    { 
        var now = new Date();
        var year = now.getFullYear();       //年
        var month = now.getMonth() + 1;     //月
        var day = now.getDate();            //日
        var clock = year + "-";
        if(month < 10) clock += "0";       
        clock += month + "-";
        if(day < 10) clock += "0"; 
        clock += day;
        return clock; 
    }

/**
 * @abstract 获取当前日期时间
 * @author zrf
 * @param    getCurentTimeStr()
 * @return 
 * date:2022-11-11
 */
    function getCurentTimeStr(){
        var myDate = new Date();
        //获取当前年
        var year = myDate.getFullYear();
        //获取当前月
        var month = myDate.getMonth() + 1;
        //获取当前日
        var day = myDate.getDate();
        var h = myDate.getHours(); //获取当前小时数(0-23)
        var m = myDate.getMinutes(); //获取当前分钟数(0-59)
        var s = myDate.getSeconds();
        var clock = year + "-";
        if(month < 10) clock += "0";       
        clock += month + "-";
        if(day < 10) clock += "0"; 
        clock += day;
        clock=clock+" "
        if(h < 10) clock += "0"; 
        clock += h;
        if(m < 10) clock += "0"; 
        clock += m;
        if(s < 10) clock += "0"; 
        clock += s;
        return clock;
    }

/**
 * @abstract 扩展校验框校验规则 验证规则（常用的）
 * @author zrf
 * @param    eg:<input id="POSSeqNo" name="POSSeqNo" type="text" class="textbox hisui-validatebox" style="width:200px" validType="PInteger"  data-options="">
 * @return 
 * date:2022-121-2
 */
$.extend($.fn.validatebox.defaults.rules, {
                chinese : {// 验证中文  
                    validator : function(value) {  
                        return /^[\u0391-\uFFE5]+$/i.test(value);  
                    },  
                    message : '请输入中文'  
                },  
                english : {// 验证英语  
                    validator : function(value) {  
                        return /^[A-Za-z]+$/i.test(value);  
                    },  
                    message : '请输入英文'  
                },                  
                ip : {// 验证IP地址
                    validator : function(value) {
                        return /d+.d+.d+.d+/i.test(value);
                    },
                    message : 'IP地址格式不正确'
                },
                ZIP: {
                    validator: function (value, param) {
                        return /^[1-9]\d{5}$/i.test(value);
                    },
                    message: '邮政编码不存在'
                },
                QQ: {
                    validator: function (value, param) {
                        return /^[1-9]\d{4,9}$/i.test(value);
                    },
                    message: 'QQ号码不正确'
                },
                mobile: {
                    validator: function (value, param) {
                        return /^(13|15|18)\d{9}$/i.test(value);
                    },
                    message: '手机号码不正确'
                },
                tel:{
                    validator:function(value,param){

                        return /^((\(\d{2,3}\))|(\d{3}\-))?(\(0\d{2,3}\)|0\d{2,3}-)?[1-9]\d{6,7}(\-\d{1,4})?$/i.test(value)
                    },
                    message:'电话号码不正确'
                },
                mobileAndTel: {
                    validator: function (value, param) {
                        return /^(13|15|18)\d{9}$/i.test(value) || /^((\(\d{2,3}\))|(\d{3}\-))?(\(0\d{2,3}\)|0\d{2,3}-)?[1-9]\d{6,7}(\-\d{1,4})?$/i.test(value);
                    },
                    message: '手机/电话号码不正确'
                },
                number: {
                    validator: function (value, param) {
                        return /^[0-9]+.?[0-9]*$/.test(value);
                    },
                    message: '请输入数字'
                },
                floatOrInt : {// 验证是否为小数或整数  
                    validator : function(value) {  
                        return /^(\d{1,3}(,\d\d\d)*(\.\d{1,3}(,\d\d\d)*)?|\d+(\.\d+))?$/i.test(value);  
                    },  
                    message : '请输入小数或整数'  
                },                
                PositiveInteger:{
                    validator:function(value,param){
                        var type=/^[1-9]\d*$/
                        return type.test(value);
                    },
                    message: '请输入正整数'
                    
                },                
                NegativeInteger:{
                    validator:function(value,param){
                        return /^-[1-9]\d*$/.test(value);
                    },
                    message: '请输入负整数'
                    
                },
                NotPositiveInteger:{
                    validator:function(value,param){
                        return /^((-\d+)|(0+))$/.test(value);
                    },
                    message: '请输入非正整数（负整数 + 0）'
                    
                },
                NotNegativeInteger:{
                    validator:function(value,param){
                        return /^[0-9]+?$/.test(value);
                    },
                    message: '请输入非负整数（正整数 + 0）'
                    
                },
                Integer:{
                    validator:function(value,param){
                        return /^-?\d+$/.test(value);
                    },
                    message: '请输入整数'
                    
                },
                Float:{
                    validator:function(value,param){
                        return /^(-?\d+)(\.\d+)?$/.test(value);
                    },
                    message: '请输入浮点数'
                    
                },
                PositiveFloat:{
                    validator:function(value,param){
                        return /^[1-9]\d*\.\d*|0\.\d*[1-9]\d*$/.test(value);
                    },
                    message: '请输入正浮点数'
                    
                },
                NegativeFloat:{
                    validator:function(value,param){
                        return /^(-\d+)(\.\d+)?$/.test(value);
                    },
                    message: '请输入负浮点数'
                    
                }, 
                NotPositiveFloat:{
                    validator:function(value,param){
                        return /^((-\d+(\.\d+)?)|(0+(\.0+)?))$/.test(value);
                    },
                    message: '请输入非正浮点数（负浮点数 + 0）'
                    
                },
                NotNegativeFloat:{
                    validator:function(value,param){
                        return /^\d+(\.\d+)?$/.test(value);
                    },
                    message: '请输入非负浮点数（正浮点数 + 0）'
                    
                },  
                range:{
                    validator:function(value,param){
                        if(/^[1-9]\d*$/.test(value)){
                            return value >= param[0] && value <= param[1]
                        }else{
                            return false;
                        }
                    },
                    message:'输入的数字在{0}到{1}之间'
                },
                minLength:{
                    validator:function(value,param){
                        return value.length >=param[0]
                    },
                    message:'至少输入{0}个字'
                },
                maxLength:{
                    validator:function(value,param){
                        return value.length<=param[0]
                    },
                    message:'最多{0}个字'
                },
                idCode:{
                    validator:function(value,param){
                        return /^\d{15}(\d{2}[A-Za-z0-9])?$/i.test(value);
                    },
                    message: '身份证号码格式不正确'
                },
                email:{  
                    validator : function(value){  
                    return /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/.test(value);   
                    },
                    message : '请输入有效的电子邮件账号' 
                }
            })

        