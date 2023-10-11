//===========================================================================================
// Author：      lidong
// Date:		 2022-9-7
// Description:	 术语规则弹出页面
//===========================================================================================
var editRow = 0;
var subEditRow = 0; 
var valeditRow = 0;
var extraAttr = "KnowType";			// 知识类型(附加属性)
var extraAttrValue = "DictionFlag" 	// 字典标记(附加属性值)
var parref = "";					// 具体药品id
var dicParref = "";					// 药品实体id
var EntLinkId="";					// 属性Id
var DataType=""
var Parref=""
var NodeId=""
/// 页面初始化函数
function initPageDefault(){
	
	InitButton();			// 按钮响应事件初始化
	InitCombobox();			// 初始化combobox
	InitDataList();			// 实体DataGrid初始化定义
	InitTree();
	
	InitGetData()
	
	$('#showlist').panel('resize', {
        height:$(window).height()-105
    }); 
     if (DataType=="tree"){
		$("#dictree").resizable({
	   		maxHeight : $(window).height()-105
		});
    }else{
		$("#DicList").datagrid('resize', { 
            height : $(window).height()-105
   		});
	}	

}
/// 初始化加载入参信息 /字典名称/记录名/操作人
function InitGetData(){
	Parref = getParam("Parref");				//术语规则字典ID
	NodeId = getParam("NodeId");				//特殊人群规则ID
	          
}

/// 按钮响应事件初始化
function InitButton(){

	$("#reset").bind("click",InitPageInfo);	// 重置	
	
	$("#treereset").bind("click",InitTreeData);	// 重置		
	
	$('#queryCode').searchbox({
		
	    searcher:function(value,name){
		    if (DataType == "tree"){
				$("#dictree").tree("search", value)
			}else{
				QueryDicList();
			}
	    }	   
	});		
	
	$('#treequery').searchbox({
		
	    searcher:function(value,name){
		    if (DataType == "tree"){
				$("#dictree").tree("search", value)
			}
	    }	   
	});	
		
}
/// 初始化combobox
function InitCombobox(){
	
	/// 初始化分类检索框
	var option = {
		mode:"remote",
		valueField:'value',
		textField:'text',		
        onSelect:function(option){
	       dicParref = option.value;
	       runClassMethod("web.DHCCKBEditDiction","GetDicDataType",{'dicID':dicParref},function(ret){
				DataType=ret;
				},'text',false);
		   if(DataType=="tree")
		   	   {
			   $("#treediv").show();
			   $("#griddiv").hide();
			   $("#toolbartree").show();
			   var uniturl = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+dicParref+"&hospID="+LgHospID+"&groupID="+LgGroupID+"&locID="+LgCtLocID+"&userID="+LgUserID
			   $('#dictree').tree({url:uniturl}); 
			   $("#DicList").datagrid("reload")
			   }
			   else
			   {
			   $("#treediv").hide();
			   $("#toolbartree").hide();	
			   $("#griddiv").show();
	       	   $("#DicList").datagrid("load",{"id":dicParref});
	       	   $("#dictree").tree("reload")
			   }

	    }
	}; 
	var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue="+extraAttrValue+"&drugType="+InitDrugType();
	new ListCombobox("dicType",url,'',option).init(); 
	new ListCombobox("treeType",url,'',option).init();
	
	$('#dicDesc').combobox({
		url:url,
		valueField: 'value',
		textField: 'text',
		blurValidValue:true,
		editable:false
	})
	
	
}

function InitComboboxAll(){
		$("#dictree").tree("search", "")
		$('#linkattrlist').datagrid('loadData',[]);	    
	}
/// 实体datagrid重置
function InitPageInfo(){	

	$HUI.searchbox('#queryCode').setValue("");
	QueryDicList();	
	SubQueryDicList();
}
function InitTreeData()
{
	$HUI.searchbox('#treequery').setValue("");
	$("#dictree").tree("search", "")
}
/// 实体DataGrid初始定义通用名
function InitDataList(){
	
	// 定义columns
	var columns=[[   	 
			{field:'ID',title:'rowid',hidden:true},
			{field:'CDCode',title:'代码',width:200,align:'left',editor:texteditor},
			{field:'CDDesc',title:'描述',width:300,align:'left',editor:texteditor},
			{field:'CDParref',title:'父节点id',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'CDParrefDesc',title:'父节点',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'CDLinkDr',title:'关联',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'KnowType',title:"数据类型",width:200,align:'left',hidden:true},
			{field:'CDLinkDesc',title:'关联描述',width:300,align:'left',editor:texteditor,hidden:true}
		]]

	var option={	
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
 			parref=rowData.ID;  
		}, 
		onDblClickRow: function (rowIndex, rowData) { }
		  
	}
	var params = ""
	var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicByID&id="+parref+"&parrefFlag=0&parDesc="+params;
	
	new ListComponent('DicList', columns, uniturl, option).Init();
	
}

/// 字典分类树
function InitTree(){
	var url = "" 
	var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJson&parref="+parref 
	var option = {
		height:$(window).height()-105,  
		multiple: true,
		lines:true,
		fitColumns:true,
		animate:true,
        onClick:function(node, checked){
	        parref=node.id;          
		   	SubQueryDicList();	
	       
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
}

/// 实体datagrid查询
function QueryDicList()
{
	var params = $HUI.searchbox("#queryCode").getValue();

	$('#DicList').datagrid('load',{
		extraAttr:"DataSource",
		id:dicParref,
		parDesc:params
	}); 
}
//查找树的节点
function QueryTreeList()
{
	var desc=$HUI.searchbox("#myChecktreeDesc").getValue();
	$("#dictree").tree("search", desc)
	$('#dictree').find('.tree-node-selected').removeClass('tree-node-selected'); //取消树的节点选中
}
function InitTreeData()
{
	$HUI.searchbox('#treequery').setValue("");
	$("#dictree").tree("search", "")
}
// 编辑格
var texteditor={
	type: 'text',//设置编辑格式
	options: {
		required: true //设置编辑规则属性
	}
}
/// 药品类型
function InitDrugType(){	

	var drugType = getParam("DrugType");	
	return drugType;
}
function SaveTermRule(){
	var Parref = getParam("Parref");
	var NodeId = getParam("NodeId");
	var LoginInfo = getParam("LoginInfo");
	var ClientIPAdd = getParam("ClientIPAdd");
	
	var selecItm=$("#DicList").datagrid('getSelected');
	var dicId=selecItm.ID
	var dicCode=selecItm.CDCode
	var dicDesc=selecItm.CDDesc
	var node=$("#dictree").tree('getSelected');
	
	/* var params=""+"^"+NodeId+"^"+dicParref+"^"+dicId+"^"+"" */
	
	var params=NodeId+"^"+dicId
	
	//ListData, Type, LoginInfo, ClientIPAddress
	runClassMethod("web.DHCCKBDefinitionRule","SaveTermRule",{"ListData":params,"Type":"tree","LoginInfo":LoginInfo,"ClientIPAddress":ClientIPAdd},function(jsonString){
	
		if (jsonString >= 0){
			$.messager.popover({msg: '保存成功！！',type:'success',timeout: 1000});		
			return;	
		}else if(jsonString == -100){
			$.messager.alert('提示','已存在对照数据，请勿重复保存','warning');
			
		}else{
			$.messager.alert('提示','保存失败！','warning');
			
		}		
	});
	
	
	
}

/// 获取参数
function getParam(paramName){
	
    var paramValue = "";
    var isFound = false;
    if (this.location.search.indexOf("?") == 0 && this.location.search.indexOf("=")>1){
        arrSource = unescape(this.location.search).substring(1,this.location.search.length).split("&");
        var i = 0;
        while (i < arrSource.length && !isFound){
            if (arrSource[i].indexOf("=") > 0){
                 if (arrSource[i].split("=")[0].toLowerCase()==paramName.toLowerCase()){
                    paramValue = arrSource[i].split("=")[1];
                    isFound = true;
                 }
            }
            i++;
        } 
    }
   return paramValue;
}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })