
document.write('<script type="text/javascript" src="../scripts/dhcnewpro/dhcckb/util/ChinesePY.js"> </script>');

/** qunianpeng 20190807
 * �ж�searchText�Ƿ���targetTextƥ�� 
 * @param searchText �������ı� 
 * @param targetText Ŀ���ı� 
 * @return true-�������ı���Ŀ���ı�ƥ�䣻����Ϊfalse. 
 */ 
function isMatch(searchText, targetText) {  
	  return $.trim(targetText)!="" && ((targetText.toUpperCase().indexOf(searchText.toUpperCase())!=-1)||((Pinyin.GetJPU(targetText)).indexOf(searchText.toUpperCase())!=-1));
} 


(function(){  
    //combobox�ɱ༭���Զ���ģ����ѯ  
    $.fn.combobox.defaults.editable = true;  
    $.fn.combobox.defaults.filter = function(q, row){  
        var opts = $(this).combobox('options');  
        ///update by chenying @20180803  ������֧��ģ����������ƴ����
        return ((row[opts.textField].indexOf(q) >= 0)||(Pinyin.GetJP(row[opts.textField]).indexOf(q.toLowerCase()) >= 0));  
    };  
    //combotree�ɱ༭���Զ���ģ����ѯ  
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
			//2018-12-18����ʱ��ʾ�ӽڵ�����и��ڵ㡣
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
			
			//չʾ����ƥ��Ľڵ��Լ����ڵ�            
			for (var i=0; i<matchedNodeList.length; i++) {
				var node = matchedNodeList[i];
				$(node.target).show();  
				$(".tree-title", node.target).addClass("tree-node-targeted");  
				var pNode = node;  
				while ((pNode = $(this).combotree('tree').tree('getParent',pNode.target))) {  
					$(pNode.target).show();               
				}  
				//չ�����ýڵ�  
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
 * 1����չjquery easyui tree�Ľڵ����������ʹ�÷������£� 
 * $("#treeId").tree("search", searchText);   
 * ���У�treeIdΪeasyui tree�ĸ�ULԪ�ص�ID��searchTextΪ�������ı��� 
 * ���searchTextΪ�ջ�""�����ָ�չʾ���нڵ�Ϊ����״̬ 
 */  
$(function() {    
      
    $.extend($.fn.tree.methods, { 
    	//2018-11-30չ��һ���ڵ㣬չ�������һ���ӽڵ㣬������ֻ���ϲ�ѯ���������ݡ� 
        expandFirstChildNodes: function(jqTree, node) {
			var tree = this; 
        	var children = tree.getChildren(jqTree, node.target);   ///�������¼��ڵ�
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
        	var children = tree.getChildren(jqTree, node.target);   ///�������¼��ڵ�
            if (children && children.length>0) {  
                for (var i=0; i<children.length; i++) {
                	$(".tree-node-targeted", children[i].target).removeClass("tree-node-targeted");  
                    	
					$(children[i].target).show();  
                }  
            } 
        },
        /** 
         * ��չeasyui tree���������� 
         * @param tree easyui tree�ĸ�DOM�ڵ�(UL�ڵ�)��jQuery���� 
         * @param searchText �������ı� 
         * @param this-context easyui tree��tree���� 
         */  
    	
        search: function(jqTree, searchText) {  
        	searchText=searchText.toUpperCase();
            //easyui tree��tree���󡣿���ͨ��tree.methodName(jqTree)��ʽ����easyui tree�ķ���  
            var tree = this;  
            //��ȡ���е����ڵ�  
            var nodeList = getAllNodes(jqTree, tree);  
            //���û��������������չʾ�������ڵ�  
            searchText = $.trim(searchText);  
            if (searchText == "") {  
                for (var i=0; i<nodeList.length; i++) {  
                    $(".tree-node-targeted", nodeList[i].target).removeClass("tree-node-targeted");  
                    $(nodeList[i].target).show();  
                }  
                //չ����ѡ��Ľڵ㣨���֮ǰѡ���ˣ�  
                var selectedNode = tree.getSelected(jqTree);  
                if (selectedNode) {  
                    tree.expandTo(jqTree, selectedNode.target);  
                }  
                return;  
            }  
             
            //����ƥ��Ľڵ㲢������ʾ  
            var matchedNodeList = [];  
            if (nodeList && nodeList.length>0) {  
                var node = null;  
                for (var i=0; i<nodeList.length; i++) {  
                    node = nodeList[i];
                    
                    if (isMatch(searchText, node.text)) {  
                        matchedNodeList.push(node);  
                    }  
                }  
                  
                //�������нڵ� 
               
                for (var i=0; i<nodeList.length; i++) {  
                    $(".tree-node-targeted", nodeList[i].target).removeClass("tree-node-targeted"); 
                     
                    $(nodeList[i].target).hide();  
                }             
                //�۵����нڵ�  
                //tree.collapseAll(jqTree);  
                  
                //չʾ����ƥ��Ľڵ��Լ����ڵ�              
                for (var i=0; i<matchedNodeList.length; i++) {  
                    showMatchedNode(jqTree, tree, matchedNodeList[i]);  
                }   
            }      
        }, 
        /** 
         * չʾ�ڵ���ӽڵ㣨�ӽڵ��п����������Ĺ����б������ˣ� 
         * @param node easyui tree�ڵ� 
         */  
        showChildren: function(jqTree, node) {  
            //easyui tree��tree���󡣿���ͨ��tree.methodName(jqTree)��ʽ����easyui tree�ķ���  
            var tree = this;  
              
            //չʾ�ӽڵ�  
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
         * ��������������ָ���Ľڵ�λ�ã�ʹ�ýڵ�ɼ�������й������Ź�����û�й������Ͳ������� 
         * @param param { 
         *    treeContainer: easyui tree�������������ڹ��������������������Ϊnull����ȡeasyui tree�ĸ�UL�ڵ�ĸ��ڵ㡣 
         *    targetNode:  ��Ҫ��������easyui tree�ڵ㡣���targetNodeΪ�գ���Ĭ�Ϲ�������ǰ��ѡ�еĽڵ㣬���û��ѡ�еĽڵ㣬�򲻹��� 
         * }  
         */  
        scrollTo: function(jqTree, param) {  
            //easyui tree��tree���󡣿���ͨ��tree.methodName(jqTree)��ʽ����easyui tree�ķ���  
            var tree = this;  
              
            //���nodeΪ�գ����ȡ��ǰѡ�е�node  
            var targetNode = param && param.targetNode ? param.targetNode : tree.getSelected(jqTree);  
              
            if (targetNode != null) {  
                //�жϽڵ��Ƿ��ڿ�������                 
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
     * չʾ����ƥ��Ľڵ� 
     */  
    function showMatchedNode(jqTree, tree, node) {  
        //չʾ���и��ڵ�  
        $(node.target).show();  
        $(".tree-title", node.target).addClass("tree-node-targeted");  
        var pNode = node;  
        while ((pNode = tree.getParent(jqTree, pNode.target))) {  
            $(pNode.target).show();               
        }  
        //չ�����ýڵ�  
        tree.expandTo(jqTree, node.target);  
        //����Ƿ�Ҷ�ӽڵ㣬���۵��ýڵ�������ӽڵ�  
        if (!tree.isLeaf(jqTree, node.target)) {  
            tree.collapse(jqTree, node.target);  
        }  
    }      
   
      
    /** 
     * ��ȡeasyui tree������node�ڵ� 
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
     * �����ȡeasyui tree���ӽڵ�ĵݹ��㷨 
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
* @ͨ�õ���div��
* @param 	width 	 	|string 	|���
* @param 	height 	 	|string 	|�߶�
* @param 	code 	 	|string 	|�����ֵ�code
* @param 	adm 	 	|string 	|�����ID
* @param 	input 	 	|string 	|���
* @param 	emrType 	|string 	|������
* @param 	htmlType 	|string 	|html����
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
		var retobj={};	// ���ض���
			
		///������������
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
		html=html+'		<a href="#" class="hisui-linkbutton" id="saveDivWinBTN"  style="width:60px" >����</a>';
		html=html+'		<a href="#" class="hisui-linkbutton"  id="removeDivWinBTN" style="width:60px"  >�ر�</a>';
		html=html+'</div>';
		html=html+'</div>';
		$("#win").append(html);
		if (option.htmlType == "datagrid"){
		
			// ����columns
			var columns=[[  
					{field:'ID',title:'RowId',hidden:true},
					{field:'CDCode',title:'����',width:200,align:'center'},
					{field:'CDDesc',title:'����',width:300,align:'center'}
					/* {field:'CDType',title:'���ڵ�',width:300,align:'center'},
					{field:'CDTypeDesc',title:'����',width:300,align:'center'},
					{field:'CDLinkDr',title:'����ID',width:300,align:'center'}		 */			
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
				onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
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
			        var isLeaf = $("#divAttrTable").tree('isLeaf',node.target);   /// �Ƿ���Ҷ�ӽڵ�
			        if (isLeaf){
				        //$(option.tarobj).val(itmText); 		
						//$(ed.target).val(itmID);							
						$("#win").remove();	
			        }else{
				    	//$("#divAttrTable").tree('toggle',node.target);   /// �����Ŀʱ,ֱ��չ��/�ر�
				    }
				    $(option.tarobj).val(node.text);
				    callback(node);
			    },
			    onExpand:function(node, checked){
					var childNode = $("#divAttrTable").tree('getChildren',node.target)[0];  /// ��ǰ�ڵ���ӽڵ�
			        var isLeaf = $("#divAttrTable").tree('isLeaf',childNode.target);        /// �Ƿ���Ҷ�ӽڵ�
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
		//һ̥�����ѡradioѡ���˾͹رմ���
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
				    rowData = tdArr.eq(1).find('input').val();//������
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
* @datagrid���Ƿ���
* @param 	value 	 	|string 	|ֵ
*						Y:��
*						N:��   
* @author zhouxin
*/
function FormatterYN(value){
	
  if(value=="Y"){
	return "<font color='#21ba45'>��</font>"
  }else if(value=="N"){
	return "<font color='#f16e57'>��</font>"
  }else{
    return "";
  }
}




/**
* @undefinedת��
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
* @catId ҩƷ����id 
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
* @i ��ѯ���� 
* @author zhouxin
*/
function getQueryType(i){
	switch(i) {
     case 1:
        return "ҩƷ";
        break;
     case 2:
        return "��Ӧ֢";
        break;
     case 3:
        return "����֢";
        break;
     default:
        return "";
	}
}


/**  
 * layout������չ   ���غ���ʾlayout����  ���÷�ʽ��$("#id").layout("show","west"); $("#id").layout("hidden","west")
 * @param {Object} jq  
 * @param {Object} region  
 */  
$.extend($.fn.layout.methods, {   
    /**  
     * ����Ƿ���ںͿɼ�  
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
     * ���س�ĳ��region��center���⡣  
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
     * ��ʾĳ��region��center���⡣  
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

///�ڹ��ά���Ӳ������� sufan 2020-04-16
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

//�������
function addClickTimes(dicID,Loginfo){
	runClassMethod("web.DHCCKBDrugSearchLog","WriteDrugClick",{DicID:dicID, Loginfo:Loginfo},function(ret){
		
		})
	}
///**
// * ��ֹҳ�����ݸ��� bianshuai 2020-03-13
// */
//document.onselectstart = function(){
//	return false; 
//};
//document.ondragstart = function(){
//	return false; 
//};


///**
// * ��ֹҳ�����ݸ��� bianshuai 2021-06-16
// */
////��������Ҽ�
//document.oncontextmenu = function () { return false; }
//document.onkeydown = function () {
//	var e = window.event || arguments[0];
//	//����F12
//	if (e.keyCode == 123) {
//		return false;
//		//����Ctrl+Shift+I
//	} else if ((e.ctrlKey) && (e.shiftKey) && (e.keyCode == 73)) {
//		return false;
//		//����Shift+F10
//	} else if ((e.shiftKey) && (e.keyCode == 121)) {
//		return false;
//	}
//};
/// ��ȡϵͳ���ں�ʱ��
function SetDateTime(flag){
	var result=""
	runClassMethod("web.DHCCKBWriteLog","GetDateTime",{"flag":flag},function(val){	
	  result = val
	},"text",false)
	return result;
}