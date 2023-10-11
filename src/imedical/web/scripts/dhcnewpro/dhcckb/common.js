
document.write('<script type="text/javascript" src="../scripts/dhcnewpro/dhcckb/util/ChinesePY.js"> </script>');

/** qunianpeng 20190807
 * 判断searchText是否与targetText匹配 
 * @param searchText 检索的文本 
 * @param targetText 目标文本 
 * @return true-检索的文本与目标文本匹配；否则为false. 
 */ 
function isMatch(searchText, targetText) {  
	  return $.trim(targetText)!="" && ((targetText.toUpperCase().indexOf(searchText.toUpperCase())!=-1)||((Pinyin.GetJPU(targetText)).indexOf(searchText.toUpperCase())!=-1));
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
$(function() {    
      
    $.extend($.fn.tree.methods, { 
    	//2018-11-30展开一个节点，展开下面第一级子节点，而不是只符合查询条件的数据。 
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
                //tree.collapseAll(jqTree);  
                  
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
});

/**
* @通用弹出div层
* @param 	width 	 	|string 	|宽度
* @param 	height 	 	|string 	|高度
* @param 	code 	 	|string 	|病历字典code
* @param 	adm 	 	|string 	|就诊表ID
* @param 	input 	 	|string 	|入参
* @param 	emrType 	|string 	|表单类型
* @param 	htmlType 	|string 	|html类型
*						input
*						radio
*						checkbox  
*						tree
*						datagrid
* @author zhouxin
*/
function divComponent(opt,callback){
	
		var option={
			width: 400,
			height: 120,
			emrType:'review',
			htmlType:'radio',
			foetus:1
		}
		
		$.extend(option,opt);

		if ($("#win").length > 0){
			$("#win").remove();
		}
		var retobj={};	// 返回对象
			
		///创建弹出窗体
		var btnPos=option.tarobj.offset().top+ option.height;
		var btnLeft=option.tarobj.offset().left - tleft;
		
		if(option.foetus>1){
			option.height=option.height+32*(option.foetus-1)
		}
		$(document.body).append('<div id="win" style="width:'+ option.width +';height:'+option.height+';border:1px solid #E6F1FA;position:absolute;z-index:9999;background-color:#eee;"></div>') 
		var html='<div id="mydiv" class="hisui-layout" fit=true style="background-color:#eee;">'
		html=html+' <div data-options="region:\'center\',title:\'\',border:false,collapsible:false" style="background-color:#eee;height:'+option.height+'">';
		html=html+'<div id="divAttrTable" ></div>';
		if ((option.htmlType == "checkbox")||(option.htmlType == "radio")){				
		
		}		
		else if (option.htmlType == "textarea"){
		
			html=html+'<textarea id="divTable" type="text" border="1" class="hisui-validatebox" style="width:92%;height:200px;resize:none;overflow:hidden;margin:10px;!important" data-options="required:true"></textarea>';
			
		}
				
		html=html+'</div>';
		html=html+' <div data-options="region:\'south\',title:\'\',border:false,collapsible:false" style="text-align:center;background-color:#eee;">';
		html=html+'		<a href="#" class="hisui-linkbutton" id="saveDivWinBTN"  style="width:60px" >保存</a>';
		html=html+'		<a href="#" class="hisui-linkbutton"  id="removeDivWinBTN" style="width:60px"  >关闭</a>';
		html=html+'</div>';
		html=html+'</div>';
		$("#win").append(html);
		if (option.htmlType == "datagrid"){
		
			// 定义columns
			var columns=[[  
					{field:'ID',title:'RowId',hidden:true},
					{field:'CDCode',title:'代码',width:200,align:'center'},
					{field:'CDDesc',title:'描述',width:300,align:'center'}
					/* {field:'CDType',title:'父节点',width:300,align:'center'},
					{field:'CDTypeDesc',title:'类型',width:300,align:'center'},
					{field:'CDLinkDr',title:'关联ID',width:300,align:'center'}		 */			
				 ]]

			var options={	
				bordr:false,
				fit:true,
				fitColumns:true,
				singleSelect:true,	
				nowrap: false,
				striped: true, 
				pagination:true,
				rownumbers:true,
				pageSize:30,
				pageList:[30,60,90],		
		 		onClickRow:function(rowIndex,rowData){    
				     callback(rowData);
				}, 
				onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
		            if (editRow != ""||editRow == 0) { 
		                $("#divAttrTable").datagrid('endEdit', editRow); 
		            } 
		            $("#divAttrTable").datagrid('beginEdit', rowIndex); 
		            
		            editRow = rowIndex; 
		        }				  
			}
			var id=option.filed;
			var input=option.input;
			//var uniturl = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicList&params=^^";
			var uniturl =LINK_CSP+'?ClassName=web.DHCCKBDiction&MethodName=QueryDicByID&id='+id+"&parDesc="+encodeURIComponent(input)
			new ListComponent('divAttrTable', columns, uniturl, options).Init();
			
		}
		else if (option.htmlType == "tree"){	
				
			var url = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;

			var options = {
				multiple: true,
				lines:true,
				animate:true,
		        onClick:function(node, checked){		       
			        var isLeaf = $("#divAttrTable").tree('isLeaf',node.target);   /// 是否是叶子节点
			        if (isLeaf){
				        //$(option.tarobj).val(itmText); 		
						//$(ed.target).val(itmID);							
						$("#win").remove();	
			        }else{
				    	//$("#divAttrTable").tree('toggle',node.target);   /// 点击项目时,直接展开/关闭
				    }
				    $(option.tarobj).val(node.text);
				    callback(node);
			    },
			    onExpand:function(node, checked){
					var childNode = $("#divAttrTable").tree('getChildren',node.target)[0];  /// 当前节点的子节点
			        var isLeaf = $("#divAttrTable").tree('isLeaf',childNode.target);        /// 是否是叶子节点
			        if (isLeaf){
				        
			        }
				}
			};			
			new CusTreeUX("divAttrTable", url, options).Init();			
		}		

			
/* 		if ($g(opt.tarobj[0].value) != ""){
			$("#divTable").val($(option.tarobj).val());
		} */		
		
		$("#win").show();
		$.parser.parse($("#win"));
		var tleft = "";
		if((option.tarobj.offset().left+500)>document.body.offsetWidth){
			tleft= 500 - (document.body.offsetWidth - option.tarobj.offset().left);
		}
	
		$("#win").css("left",option.tarobj.offset().left - tleft);
		$("#win").css("top",option.tarobj.offset().top+ option.tarobj.outerHeight());
		//一胎的情况选radio选择了就关闭窗口
		/* if(option.foetus==1){
			$("#divTable").find("input[type='radio']").change(function() {
				$(option.tarobj).val($(this).val())
				$("#win").remove();	
			})
		} */
		$("#divTable").find("td").children().eq(0).focus();
		$("#saveDivWinBTN").on('click',function(){
			/*var retArr=[];
			$("#divTable").find("tr").each(function(){
			    
			    var rowData="";
			    if("radio"==option.htmlType){
				    rowData=$(this).find("input[type='radio']:checked").val()
				}
				if("input"==option.htmlType){
					var tdArr = $(this).children();
				    rowData = tdArr.eq(1).find('input').val();//收入金额
				}
			    retArr.push(rowData)
			});
			$(option.tarobj).val(retArr.join("/"))*/
			if (option.htmlType == "textarea"){
				$(option.tarobj).val($("#divTable").val());
			}	
				
			$("#win").remove();
		})

		$("#removeDivWinBTN").on('click',function(){
				$("#win").remove();
		});
		
		$(document).keyup(function(event){
			
			switch(event.keyCode) {
				case 27:
					$("#win").remove();
				case 96:
					$("#win").remove();
			}
		});
}


/**
* @datagrid中是否标记
* @param 	value 	 	|string 	|值
*						Y:是
*						N:否   
* @author zhouxin
*/
function FormatterYN(value){
	
  if(value=="Y"){
	return "<font color='#21ba45'>是</font>"
  }else if(value=="N"){
	return "<font color='#f16e57'>否</font>"
  }else{
    return "";
  }
}




/**
* @undefined转换
* @param 	value 	 	  
* @author 	qunianpeng
*/
var $g=function(value){
	
  if(value === undefined){
	value = "";
  }
  if( value == null){
	value = "";
	}
  return value;
}

/**
* @catId 药品分类id 
* @author zhouxin
*/
function getCrumbs(catId,incId,input,inputType){
	input=input=="undefined"?"":input;
	var crumbHtml=""
	runClassMethod(
		"web.DHCCKKBIndex",
		"GetCrumb",
		{
			'queryCat':catId,
			'incId':incId,
			'input':input,
			'inputType':inputType
		},function(data){
			var len=data.length-1;
			for(var i=len;i>=0;i--){
				if(i<len){
					crumbHtml+="<span  style='padding:0 5 0 5;color: #017bce'>/</span>";	
				}
				crumbHtml+="<a href='javascript:void(0);' ";
				if(data[i].type=="cat"){
					crumbHtml+="onclick='goCrumbTable(\""+data[i].id+"\",\""+data[i].desc+"\")' "
				}else if(data[i].type=="input"){
					
					crumbHtml+="onclick='goCrumbList(\""+input+"\",\""+inputType+"\")' "
				}else{
					crumbHtml+="onclick='goCrumbWiki("+data[i].id+")' "
				}
				crumbHtml+=" >" +data[i].desc+"</a>";
			}
		},
		"json",
		false
	)
	return 	crumbHtml;
}
function goCrumbTable(id,desc){
	//window.location.href="dhcckb.index.table.csp?catId="+id;
	window.parent.updTabsTitle(id,desc);
}
function goCrumbList(input,inputType){

	window.location.href="dhcckb.index.list.csp?input="+input+"&inputType="+inputType
}
function goCrumbWiki(id,catId,input,inputType,Loginfo,url){

	window.location.href="dhcckb.wiki.csp?IncId="+id+"&catId="+catId+"&input="+input+"&inputType="+inputType+"&url="+url + "&token="+ getToken();
	addClickTimes(id,Loginfo)
}


/**
* @i 查询分类 
* @author zhouxin
*/
function getQueryType(i){
	switch(i) {
     case 1:
        return "药品";
        break;
     case 2:
        return "适应症";
        break;
     case 3:
        return "禁忌症";
        break;
     default:
        return "";
	}
}


/**  
 * layout方法扩展   隐藏和显示layout布局  调用方式：$("#id").layout("show","west"); $("#id").layout("hidden","west")
 * @param {Object} jq  
 * @param {Object} region  
 */  
$.extend($.fn.layout.methods, {   
    /**  
     * 面板是否存在和可见  
     * @param {Object} jq  
     * @param {Object} params  
     */  
    isVisible: function(jq, params) {   
        var panels = $.data(jq[0], 'layout').panels;   
        var pp = panels[params];   
        if(!pp) {   
            return false;   
        }   
        if(pp.length) {   
            return pp.panel('panel').is(':visible');   
        } else {   
            return false;   
        }   
    },   
    /**  
     * 隐藏除某个region，center除外。  
     * @param {Object} jq  
     * @param {Object} params  
     */  
    hidden: function(jq, params) {   
        return jq.each(function() {   
            var opts = $.data(this, 'layout').options;   
            var panels = $.data(this, 'layout').panels;   
            if(!opts.regionState){   
                opts.regionState = {};   
            }   
            var region = params;   
            function hide(dom,region,doResize){   
                var first = region.substring(0,1);   
                var others = region.substring(1);   
                var expand = 'expand' + first.toUpperCase() + others;   
                if(panels[expand]) {   
                    if($(dom).layout('isVisible', expand)) {   
                        opts.regionState[region] = 1;   
                        panels[expand].panel('close');   
                    } else if($(dom).layout('isVisible', region)) {   
                        opts.regionState[region] = 0;   
                        panels[region].panel('close');   
                    }   
                } else {   
                    panels[region].panel('close');   
                }   
                if(doResize){   
                    $(dom).layout('resize');   
                }   
            };   
            if(region.toLowerCase() == 'all'){   
                hide(this,'east',false);   
                hide(this,'north',false);   
                hide(this,'west',false);   
                hide(this,'south',true);   
            }else{   
                hide(this,region,true);   
            }   
        });   
    },   
    /**  
     * 显示某个region，center除外。  
     * @param {Object} jq  
     * @param {Object} params  
     */  
    show: function(jq, params) {   
        return jq.each(function() {   
            var opts = $.data(this, 'layout').options;   
            var panels = $.data(this, 'layout').panels;   
            var region = params;   
  
            function show(dom,region,doResize){   
                var first = region.substring(0,1);   
                var others = region.substring(1);   
                var expand = 'expand' + first.toUpperCase() + others;   
                if(panels[expand]) {   
                    if(!$(dom).layout('isVisible', expand)) {   
                        if(!$(dom).layout('isVisible', region)) {   
                            if(opts.regionState[region] == 1) {   
                                panels[expand].panel('open');   
                            } else {   
                                panels[region].panel('open');   
                            }   
                        }   
                    }   
                } else {   
                    panels[region].panel('open');   
                }   
                if(doResize){   
                    $(dom).layout('resize');   
                }   
            };   
            if(region.toLowerCase() == 'all'){   
                show(this,'east',false);   
                show(this,'north',false);   
                show(this,'west',false);   
                show(this,'south',true);   
            }else{   
                show(this,region,true);   
            }   
        });   
    }   
}); 

///在光标维护加插入内容 sufan 2020-04-16
(function ($) {
    $.fn.extend({
        insertAtCaret: function (myValue) {
            var $t = $(this)[0];
            if (document.selection) {
                this.focus();
                sel = document.selection.createRange();
                sel.text = myValue;
                this.focus();
            }
            else
                if ($t.selectionStart || $t.selectionStart == '0') {
                    var startPos = $t.selectionStart;
                    var endPos = $t.selectionEnd;
                    var scrollTop = $t.scrollTop;
                    $t.value = $t.value.substring(0, startPos) + myValue + $t.value.substring(endPos, $t.value.length);
                    this.focus();
                    $t.selectionStart = startPos + myValue.length;
                    $t.selectionEnd = startPos + myValue.length;
                    $t.scrollTop = scrollTop;
                }
                else {
                    this.value += myValue;
                    this.focus();
                }
        }
    })
})(jQuery);

//点击数量
function addClickTimes(dicID,Loginfo){
	runClassMethod("web.DHCCKBDrugSearchLog","WriteDrugClick",{DicID:dicID, Loginfo:Loginfo},function(ret){
		
		})
	}
///**
// * 禁止页面内容复制 bianshuai 2020-03-13
// */
//document.onselectstart = function(){
//	return false; 
//};
//document.ondragstart = function(){
//	return false; 
//};


///**
// * 禁止页面内容复制 bianshuai 2021-06-16
// */
////屏蔽鼠标右键
//document.oncontextmenu = function () { return false; }
//document.onkeydown = function () {
//	var e = window.event || arguments[0];
//	//屏蔽F12
//	if (e.keyCode == 123) {
//		return false;
//		//屏蔽Ctrl+Shift+I
//	} else if ((e.ctrlKey) && (e.shiftKey) && (e.keyCode == 73)) {
//		return false;
//		//屏蔽Shift+F10
//	} else if ((e.shiftKey) && (e.keyCode == 121)) {
//		return false;
//	}
//};
/// 获取系统日期和时间
function SetDateTime(flag){
	var result=""
	runClassMethod("web.DHCCKBWriteLog","GetDateTime",{"flag":flag},function(val){	
	  result = val
	},"text",false)
	return result;
}