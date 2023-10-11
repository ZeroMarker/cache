/**
  *qunianpeng 
  *2019-06-28
  *分类树维护
  *
 **/
var editRow = 0; 
var parref = getParam("parref");    //实体ID
var extraAttr = "KnowType";			// 附加属性-知识类型
var extraAttrValue = "AttrFlag" 	// knowledge-实体

/// 页面初始化函数
function initPageDefault(){
	if(parref==	""){parref = $("#drugCatID").val()}
	InitTree();     	/// 初始分类树
	InitBlButton(); 	/// 页面 Button 绑定事件
	InitCombobox();
}

/// 字典分类树
function InitTree(){
	
	var url = "" //$URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
	var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJson&parref="+parref 
	var option = {
		height:$(window).height()-105,   ///需要设置高度，不然数据展开太多时，列头就滚动上去了。
		multiple: true,
		lines:true,
		fitColumns:true,
		animate:true,
        onClick:function(node, checked){
	       
	        var isLeaf = $("#dictree").tree('isLeaf',node.target);   /// 是否是叶子节点
	        if (isLeaf){
		        							   
	        }else{
		    	//$("#attrtree").tree('toggle',node.target);   /// 点击项目时,直接展开/关闭
		    }
	    },
	    onContextMenu: function(e, node){
			
			e.preventDefault();
			$(this).tree('select', node.target);
			var node = $("#dictree").tree('getSelected');
			if (node == null){
				$.messager.alert("提示","请选中节点后重试!"); 
				return;
			}
				
			// 显示快捷菜单
			$('#right').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		},
	    onExpand:function(node, checked){
			var childNode = $("#dictree").tree('getChildren',node.target)[0];  /// 当前节点的子节点
	        var isLeaf = $("#dictree").tree('isLeaf',childNode.target);        /// 是否是叶子节点
	        if (isLeaf){
	        }
		}
	};
	new CusTreeUX("dictree", url, option).Init();
	//$('#CheckPart').tree('options').url = uniturl;
	//$('#CheckPart').tree('reload');		
}


/// 页面 Button 绑定事件
function InitBlButton(){
	
	///  增加
	//$('#insert').bind("click",AddDataTree);	
	
}

///
function InitCombobox(){
	//上级分类
	$HUI.combotree('#parref',{
		 url:$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJson&parref="+parref
	});
}


//点击添加同级节点按钮
function AddSameDataTree() {
	
	RefreshData();
	var options={};
	options.url=$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJson&parref="+parref
	$('#parref').combotree(options);
	$('#parref').combotree('reload')
	
	$("#myWin").show();
	var myWin = $HUI.dialog("#myWin",{
		iconCls:'icon-addlittle',
		resizable:true,
		title:'添加',
		modal:true,
		buttonAlign : 'center',
		buttons:[{
			text:'保存',
			//iconCls:'icon-save',
			id:'save_btn',
			handler:function(){
				SaveDicTree("");
			}
		},{
			text:'继续添加',
			//iconCls:'icon-save',
			id:'save_btn',
			handler:function(){
				TSaveDicTree();
			}
		},{
			text:'关闭',
			handler:function(){
				myWin.close();
			}
		}]
	});	
	
	var record =$("#dictree").tree('getSelected');
	if (record){
		var parentNode=$("#dictree").tree("getParent",record.target)			
		$('#parref').combotree('setValue', $g(parentNode.id));
	}
}

 //点击添加子节点按钮
function AddDataTree() {
	RefreshData();
	var options={};
	options.url=$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJson&parref="+parref
	$('#parref').combotree(options);
	$('#parref').combotree('reload')
	
	$("#myWin").show();
	var myWin = $HUI.dialog("#myWin",{
		iconCls:'icon-addlittle',
		resizable:true,
		title:'添加',
		modal:true,
		buttonAlign : 'center',
		buttons:[{
			text:'保存',
			//iconCls:'icon-save',
			id:'save_btn',
			handler:function(){
				SaveDicTree()
			}
		},{
			text:'继续添加',
			//iconCls:'icon-save',
			id:'save_btn',
			handler:function(){
				TAddDicTree("")
			}
		},{
			text:'关闭',
			handler:function(){
				myWin.close();
			}
		}]
	});	
	
	var record =$("#dictree").tree('getSelected');
	
	if (record){
		//$("#treeID").val(record.id);
		//var parentNode=$("#dictree").tree("getParent",record.target)	
		//if (parentNode){	
		//alert(record.id)	
			$('#parref').combotree('setValue', $g(record.id));
		//}
	}
}
	
	///继续添加
function TAddDicTree(){	

	SaveDicTree();
}
//点击修改按钮
function UpdateDataTree() {
	
	RefreshData();
	
	$('#parref').combotree('reload',$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJson&parref="+parref)
	var record = $("#dictree").tree("getSelected"); 
	if (!(record))
	{	
		$.messager.alert('错误提示','请先选择一条记录!',"error");
		return;
	}
	var id=record.id;
	if (record){
		$("#treeID").val(record.id);
		var parentNode=$("#dictree").tree("getParent",record.target)	
		if (parentNode){		
			$('#parref').combotree('setValue', $g(parentNode.id));
		}
		$("#treeCode").val(record.code);
		$("#treeDesc").val(record.text);
	}
	$("#myWin").show(); 
	var myWin = $HUI.dialog("#myWin",{
		iconCls:'icon-updatelittle',
		resizable:true,
		title:'修改',
		modal:true,
		//height:$(window).height()-70,
		buttons:[{
			text:'保存',
			//iconCls:'icon-save',
			id:'save_btn',
			handler:function(){
				SaveDicTree()
			}
		},{
			text:'关闭',
			//iconCls:'icon-cancel',
			handler:function(){
				RefreshData();
				myWin.close();
			}
		}]
	});
}	

///新增、更新
function SaveDicTree(){
			
	var treeID=$("#treeID").val();	
	var treeCode=$.trim($("#treeCode").val());
	if (treeCode==""){
		$.messager.alert('错误提示','代码不能为空!',"error");
		return;
	}
	var treeDesc=$.trim($("#treeDesc").val())
	if (treeDesc==""){
		$.messager.alert('错误提示','描述不能为空!',"error");
		return;
	}
	///上级分类
	if ($('#parref').combotree('getText')==''){
		$('#parref').combotree('setValue','')
	}
	
	var setParref = $('#parref').combotree('getValue')=="" ? parref : $('#parref').combotree('getValue') // 分类为空,则默认挂在分类字典下面
	var params=$g(treeID) +"^"+ $g(treeCode) +"^"+ $g(treeDesc) +"^"+ $g(setParref)

	var attrData = "";

	//保存数据
	runClassMethod("web.DHCCKBDiction","SaveUpdate",{"params":params,"attrData":attrData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert('提示','保存失败！','warning');
			$('#dictree').tree('reload'); //重新加载
			return;	
		}else{
			//$.messager.alert('提示','保存成功！','info');
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			CloseWin();
			$('#dictree').tree('reload'); //重新加载
			return;
		}	
		
	});	
	
	//$('#mygrid').treegrid('reload');  // 重新载入当前页面数据 
	//$('#myWin').dialog('close'); // close a dialog

	//$.messager.alert('操作提示',errorMsg,"error");

}

///删除
function DelDataTree(){    
              
	var record = $("#dictree").tree("getSelected"); 
	if (!(record))
	{	$.messager.alert('错误提示','请先选择一条记录!',"error");
		return;
	}
	//var childrenNodes = $("#dictree").tree('getChildren',record.target);
	var isLeaf = $("#dictree").tree('isLeaf',record.target);   /// 是否是叶子节点
	if (isLeaf){
			$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
				if (r){			
					//保存数据
					runClassMethod("web.DHCCKBDiction","DeleteDic",{"dicID":record.id},function(jsonString){
						if (jsonString != 0){
							$.messager.alert('提示','删除失败！','warning');
							$('#dictree').tree('reload'); //重新加载
							return;	
						}else{
							//$.messager.alert('提示','保存成功！','info');
							$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
							$('#dictree').tree('reload'); //重新加载
							return;
						}	
						
					});
				}
			});	
	}else{
		$.messager.confirm('提示', '【<font color=red>当前分类下有子分类，删除分类时会同时删除所有的子分类</font>】<br/>确定要删除所选的数据吗?', function(r){
				if (r){			
					//保存数据
					runClassMethod("web.DHCCKBDiction","DeleteAllDic",{"dicID":record.id},function(jsonString){
						if (jsonString != 0){
							$.messager.alert('提示','删除失败！','warning');
							$('#dictree').tree('reload'); //重新加载
							return;	
						}else{
							//$.messager.alert('提示','保存成功！','info');
							$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
							$('#dictree').tree('reload'); //重新加载
							return;
						}	
						
					});
				}
			});
		
	}

	
}

/// 重置方法
function ClearData(){
	
	$("#FindTreeText").val("");
	$('#dictree').tree('reload')
	//$('#dictree').tree('uncheckAll');
	$('#dictree').find('.tree-node-selected').removeClass('tree-node-selected'); //取消树的节点选中
}

/// 查询方法
function SearchData(){
	var desc=$.trim($("#FindTreeText").val());
	$("#dictree").tree("search", desc)
	$('#dictree').find('.tree-node-selected').removeClass('tree-node-selected'); //取消树的节点选中

	
}

/// 清空数据
function RefreshData(){
	
	$("#treeID").val("");
	$("#treeCode").val("");
	$("#treeDesc").val("");
	$('#parref').combotree('setValue','');
};


function CloseWin(){

	$HUI.dialog("#myWin").close();
};

	
/// 查找检查项目树
function findRangeTree(PyCode){
	
	var params = PyCode +"^"+ CatId;
	var url = LINK_CSP+'?ClassName=web.DHCCKBRangeCat&MethodName=QueryRangeCatTree&params='+params;
	$("#RangeCat").tree('options').url =encodeURI(url);
	$("#RangeCat").tree('reload');
}

///设置操作明细连接
function SetCellOperation(value, rowData, rowIndex){

	var btnGroup = "<a style='margin-right:10px;' href='#' onclick=\"OpenWin('"+rowData.ID+"','prop')\"><img src='../scripts/dhcnewpro/images/adv_sel_11.png' border=0/>属性</a>";
	btnGroup = btnGroup + "<a style='margin-right:10px;' href='#' onclick=\"OpenWin('"+rowData.ID+"','linkprop')\"><img src='../scripts/dhcnewpro/images/adv_sel_11.png' border=0/>附加属性</a>";
	
	return btnGroup;
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })