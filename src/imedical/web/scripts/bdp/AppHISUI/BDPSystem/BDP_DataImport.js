/*
* @Author: 基础数据平台-陈莹
* @Date:   2022-09-05
* @描述:BDP数据导入-菜单+框架
*/
var init=function()
{
	var EXECUTABLE_ACTION_URL ="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPEIMenu&pClassMethod=GetExecutableTreeJsonHISUI&EIflag=I";
	
	var itemtree=$('#itemtree').tree({
    	url:EXECUTABLE_ACTION_URL,
    	animate:true,
    	lines:true,
		checkbox:false,
		cascadeCheck:false,
    	formatter:function(node){
	    	if ($(this).tree('isLeaf', node.target))  //叶子节点
        	{
        		if (node.imported=='Y')
	        	{
		    		//导入过的菜单，菜单颜色显示红色
		    		var s= '<font color="red">'+node.text+'</font>';
		    		return s;
		    	}
		    	else
		    	{
		    		return node.text;
		    	}
        	}
    	},
    	onBeforeExpand:function(node){
			//展开一个节点，展开下面第一级子节点，而不是只符合查询条件的数据。 
			$(this).tree('expandFirstChildNodes',node)
        },
        onSelect: function(node){  //选择节点，加载右侧导入界面。
        	if ($(this).tree('isLeaf', node.target))  //只有选择叶子节点，才加载右侧导入界面。
        	{
        		var tab = $('#myTabs').tabs('getSelected');  // 获取选择的面板
        		var url= "dhc.bdp.ct.importdata.csp?AutCode="+node.myCode;
				if ('undefined'!==typeof websys_getMWToken)
		        {
					url += "&MWToken="+websys_getMWToken() //增加token
				}
				$('#myTabs').tabs('update', {
					tab: tab,
					options: {
						title: node.text,
						content:'<iframe scrolling="no" frameborder="0" src="'+url+'" style="padding:0;margin:0;width:100%;height:100%;overflow:hidden"></iframe>'
					}
				});
        	}
		},
		onBeforeSelect: function(node){
			var selectedNode = $(this).tree('getSelected');	// get checked nodes
			if((selectedNode)&&($(this).tree('isLeaf', selectedNode.target)))  //之前有选中节点&&之前选中的节点是叶子节点
			{
				if(selectedNode.text.indexOf('color="red"')<0)  //之前选中的节点不包括红色
				{
					var ImportedFlag =tkMakeServerCall("web.DHCBL.BDP.BDPEIMenu","GetImportedFlag",selectedNode.myCode);  //判断是否有导入成功过
					if (ImportedFlag=="Y") 
					{
						$(this).tree('update', {
							target: selectedNode.target,
							text: '<font color="red">'+selectedNode.text+'</font>'
						});
					}
				}
			}
		}
	});
	//树菜单的检索事件	
	$('#FindTreeText').searchbox({
		searcher:function(value,name){
			//查出包含查询条件的上一级及与符合查询条件的菜单同级的所有菜单
			$("#itemtree").tree("searchLeaf", value);     //FunLibUI.js里新增searchLeaf
		}
	});
	//重置事件
	$("#btnRefresh").click(function(e) {
		$("#FindTreeText").searchbox('setValue', ''); 
		$("#itemtree").tree("searchLeaf", '');
	});
	
	 /** 如果未开启BDP数据导入授权，则禁用此页面。 */
	var BDPDataImportFlag =tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPDataImport");
	if (BDPDataImportFlag != "Y")
	{
		$.messager.alert('提示','未开启BDP数据导入授权，请在平台配置下开启，或者联系管理员。',"error");
		$("<div class=\"datagrid-mask\"></div>").css({
	        display: "block",
	        width: "100%",
	        height: $(window).height()
	    }).appendTo("body");
	    
		
	}
	
}
$(init);