//===========================================================================================
// Author：      qunianpeng
// Date:		 2030-01-02
// Description:	 新版临床知识库-字典数据引用出处
//===========================================================================================

var extraAttr = "KnowType";			// 知识类型(附加属性)
var extraAttrValue = "DictionFlag" 	// 字典标记(附加属性值)
var parref = "";					// 具体字典id
var dicParref = ""					// 字典表id
var datatype=""
var newparref=""          	        //修改为的具体字典id
var newothername=""                 //加入的别名
var parrefFlag=0;					// qunianpeng  对于树是否显示叶子节点标记
/// 页面初始化函数
function initPageDefault(){
	
	InitButton();		// 按钮响应事件初始化
	InitCombobox();		// 初始化combobox
	InitDataList();		// 实体DataGrid初始化定义
	InitSubDataList();  // 属性DataGrid初始化定义
	resizeH();
}

// 自适应
function resizeH(){

	$('#showlist').resizable( {
        height:$(window).height()-125
    }); 
   
   if (datatype=="tree"){
		$("#dictree").resizable({
	   		maxHeight : $(window).height()-125
		});
    }else{
		$("#diclist").datagrid('resize', { 
            height : $(window).height()-125
   		});
	}	
}

/// 按钮响应事件初始化
function InitButton(){
	
	$("#reset").bind("click",InitPageInfo);	// 重置	
	
	/// 代码.描述查询
	//$("#code,#desc").bind("keypress",QueryDicList);	
	$('#queryCode').searchbox({
	    searcher:function(value,name){
		    QueryDicList();
	    }	   
	});	
	$("#resetvalue").bind("click",RestValue);	
	
	$("#find").bind("click",QueryDicList);			// 新增查询按钮 qunianpeng 2020/4/8	
	
	$("#updruledic").bind('click',UpdRuleDic)		// 修改规则中字典的元素归属
		
}

/// 初始化combobox
function InitCombobox(){

	/// 初始化分类检索框
	var option = {
		//panelHeight:"auto",
		mode:"remote",
		valueField:'value',
		textField:'text',		
        onSelect:function(option){
	        dicParref = option.value;
	        runClassMethod("web.DHCCKBGetDicSourceUtil","GetDicDataType",{"dicID":dicParref},function(jsonString){
				datatype=jsonString;
				$HUI.combotree("#propType").setValue("");
				if (jsonString == "tree"){
					$("#list").hide();
					$("#tree").show();
					InitTree();
					resizeH();
				}
				else{					
					$("#list").show();
					$("#tree").hide();
					QueryDicList();
					resizeH();					
				}
			},'text',false);				
	    }
	}; 
	var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue="+extraAttrValue;
	new ListCombobox("dicType",url,'',option).init(); 	
	
	//字典 sufan 20200623 增加
	$('#dicDesc').combobox({
		url:url,
		valueField: 'value',
		textField: 'text',
		blurValidValue:true,
		mode:'remote',
		onSelect:function(option){
			
			/*var params = LgHospID +"^"+ LgGroupID +"^"+ LgCtLocID +"^"+ LgUserID;
			var parrefId = option.value;
			if (option.text == "药学分类字典"){
				var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=GetTreeCombobox&parref="+parrefId+"&params="+params;
			}else{
				var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicComboboxByID&id="+parrefId +"&parrefFlag="+"0"+"&params="+params;;
			}
			$("#dicData").combobox('reload',url);*/
		}
	})
	
	//字典数据 sufan 20200623 增加
	$('#dicData').combobox({
		//url:'',
		valueField: 'id',
		textField: 'text',
		blurValidValue:true,
		mode:'remote',
		onShowPanel:function(){
			
			var params = LgHospID +"^"+ LgGroupID +"^"+ LgCtLocID +"^"+ LgUserID;	
			var parrefId = $HUI.combobox("#dicDesc").getValue(); 
			var parrText = $HUI.combobox("#dicDesc").getText();
			if (parrText == "药学分类字典"){
				var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=GetTreeCombobox&parref="+parrefId+"&params="+params;
			}else{
				var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicComboboxByID&id="+parrefId +"&parrefFlag="+"0"+"&params="+params;;
			}
			$('#dicData').combobox('reload',url);
		}	
	})
	
	/// 属性树 qunianpeng 2020/4/7
	var attrValue = "AttrFlag" 
	var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+attrValue;
	var options={
		url:uniturl,
		onSelect:function(option){
			dicParref = option.id;
			parrefFlag =1;
			$HUI.combobox("#dicType").setValue("");
			QueryDicList();		
		}
	};

	$('#propType').combotree(options);
	$('#propType').combotree('reload')
	
	/// 属性下拉树
	var options={
		url:uniturl,
		onSelect:function(option){
				
		}
	};
	$('#dicprop').combotree(options);
	$('#dicprop').combotree('reload')
	
	
	///院区
	///新增院区sufan 2020-07-15
    var uniturl = $URL+"?ClassName=web.DHCCKBCommonUtil&MethodName=QueryHospList"  
    $HUI.combobox("#hosp",{
	     url:uniturl,
	     valueField:'value',
			textField:'text',
			panelHeight:"150",
			mode:'remote',
			onSelect:function(ret){
				SubQueryDicList();
			}
	   })
}

// 编辑格
var texteditor={
	type: 'text',//设置编辑格式
	options: {
		required: true //设置编辑规则属性
	}
}

/// 实体DataGrid初始定义通用名
function InitDataList(){
	
	// 定义columns
	var columns=[[   	 
			{field:'ID',title:'rowid',hidden:true},
			{field:'CDCode',title:'代码',width:200,align:'left',editor:texteditor},
			{field:'CDDesc',title:'描述',width:400,align:'left',editor:texteditor},
			{field:'Parref',title:'父节点id',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'ParrefDesc',title:'父节点',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'CDLinkDr',title:'关联',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'CDLinkDesc',title:'关联描述',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'KnowType',title:"数据类型",width:200,align:'left',hidden:true}

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
 			newothername=rowData.CDDesc;  //加入的别名   
 			parref=rowData.ID;  
		   	SubQueryDicList();		 
		}, 
		onDblClickRow: function (rowIndex, rowData) { }
		  
	}
	var uniturl = "" //$URL+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicByID&id="+dicParref+"&parrefFlag=0&parDesc=";
	new ListComponent('diclist', columns, uniturl, option).Init();
	
}

/// 属性DataGrid初始定义通用名
function InitSubDataList(){
	// ruleID^drugID^drugName^libaryID^libaryDesc^left^leftDesc"
	// 定义columns	
	var columns=[[   
			{field:'ck',title:'操作',checkbox:'true',width:80,align:'left'},
			{field:'drugName',title:'药品名称',width:280,align:'left'},
			{field:'libaryDesc',title:'关系',width:100,align:'left'},
			{field:'leftDesc',title:'列',width:100,align:'left'},
			{field:'ruleID',title:'引用处id',width:60,align:'left',hidden:true},
			{field:'ruleMark',title:'引用处id',width:80,align:'left'},
			{field:'Operating',title:'规则详情',width:50,align:'center',formatter:SetCellOperation},  //xww 2021-08-06
			{field:'marks',title:'marks',width:80,align:'left',hidden:true}
	 ]]

	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:false,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],		
 		onClickRow:function(rowIndex,rowData){    
 		
		}, 		
		onLoadSuccess:function(data){         
        }		  
	}
	var params = "";
	var uniturl = "" //$URL+"?ClassName=web.DHCCKBEditProp&MethodName=GetAttrListData&params="+params;
	new ListComponent('linkattrlist', columns, uniturl, option).Init();			
}

function InitTree(){
		
	var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonDataByNode&id="+dicParref+"&hospID="+LgHospID+"&groupID="+LgGroupID+"&locID="+LgCtLocID+"&userID="+LgUserID
	var option = {
		height:$(window).height()-105,   ///需要设置高度，不然数据展开太多时，列头就滚动上去了。
		multiple: true,
		lines:true,
		fitColumns:true,
		animate:true,
        onClick:function(node, checked){	       
	        var isLeaf = $("#dictree").tree('isLeaf',node.target);   /// 是否是叶子节点
	        parref=node.id;  
		   	SubQueryDicList();		
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



/// 实体datagrid查询
function QueryDicList()
{
	var params = $HUI.searchbox("#queryCode").getValue();	
	var referenceFlag=$HUI.checkbox("#referenceFlag").getValue()  //xww 2021-08-23
	if(datatype=="tree"){
		reloadTree();
	}else{
		var options={} // 
		options.url=encodeURI($URL+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicByID&id="+dicParref+"&parrefFlag="+parrefFlag+"&parDesc="+params+"&loginInfo="+LoginInfo+"&referenceFlag="+referenceFlag);
		$('#diclist').datagrid(options);
	}
}

/// 实体datagrid重置
function InitPageInfo(){	

	$HUI.searchbox('#queryCode').setValue("");
	QueryDicList();	
	SubQueryDicList();
	InitTree();	
	$HUI.combobox("#dicType").setValue("");
	$HUI.combotree("#propType").setValue("");
	dicParref="";
	$HUI.combobox("#hosp").setValue("");
}

/// 查询属性子页面
function SubQueryDicList(){

	var params=parref;
	var hospId = $HUI.combobox("#hosp").getValue();		//sufan 2020-12-24 新增医院入参
	var options={}
	options.url=$URL+"?ClassName=web.DHCCKBGetDicSourceUtil&MethodName=QueryDicSource&dicID="+params+"&hospId="+hospId;
	$('#linkattrlist').datagrid(options);
	$('#linkattrlist').datagrid('reload');
}
///修改为另一个/别名名称
function RestValue(){
	if(parref=="")
	{
		$.messager.alert('提示','请选择要修改的项!','warning');
		return;
	}
	//初始化dialog中的combobox
	var option = {
		panelHeight:"250",
		mode:"remote",
		valueField:'id',
		textField:'text',		
        onSelect:function(option){
	        newparref = option.id;
	    }
	}; 
	var params = LgHospID +"^"+ LgGroupID +"^"+ LgCtLocID +"^"+ LgUserID;
	 if (datatype == "tree"){
		
			var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=GetTreeCombobox&parref="+dicParref+"&params="+params;
			}else{
			var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicComboboxByID&id="+dicParref +"&parrefFlag="+"0"+"&params="+params;;
			}
	
	new ListCombobox("reactionnamerule",url,'',option).init(); 
	$HUI.dialog("#exaction").open();
	
	}
///dialog弹窗修改  保存
function SaveResetData(){
	if(newparref=="")
	{
		$.messager.alert('提示','未选中字典！');
		return;		
	}
		runClassMethod("web.DHCCKBGetDicSourceUtil","SaveResetAction",{"dicID":parref,"dicDataId":newparref,"otherName":newothername},function(jsonString){
					if (jsonString == 1){
						 $.messager.alert('提示','字典引用、规则引用修改成功！');
						//$('#diclist').datagrid('reload'); //重新加载
					}else if(jsonString == -1){
						 $.messager.alert('提示','规则引用修改成功！');
					}else if(jsonString == -2){
						 $.messager.alert('提示','字典引用修改成功！');
					}								
				})
				$HUI.dialog("#exaction").close();
}
///移动规则字典归属
function UpdRuleDic()
{
	var seltems=$('#linkattrlist').datagrid('getSelections')
	if(seltems.length==0){
		$.messager.alert("提示","请选择要修改的列表！");
		return;
	}
	
	$("#UpdDicWin").show();
	$HUI.combobox("#dicDesc").setValue("");	
	$HUI.combobox("#dicData").setValue("");	
	$HUI.combotree("#dicprop").setValue("");
	var option = {
		modal:true,
		collapsible : false,
		minimizable : false,
		maximizable : false,
		border:true,
		closed:"true"
	};
	var title = "修改规则字典引用";		
	new WindowUX(title, 'UpdDicWin', '360', '260', option).Init();
}
///保存规则引用
function saveDiction()
{
	var selitems = $('#linkattrlist').datagrid('getSelections');
	var preDicId = "";
	if(datatype == "tree"){
		var selnode = $('#dictree').tree('getSelected');
		preDicId = selnode.id;
	}else{
		var dicselitems = $('#diclist').datagrid('getSelected');
		preDicId = dicselitems.ID;
	}
	var dicData = $HUI.combobox("#dicData").getValue();
	
	var dicProp = $HUI.combotree("#dicprop").getValue();
	var dicArray = new Array();
	var dataList = [];
	for(var i=0;i<selitems.length;i++){
		var linkId = selitems[i].ruleID;
		var linktp = selitems[i].marks;
		var list = linkId +"^"+ linktp;
		if($.inArray(linktp,dicArray) < 0){
                dicArray.push(linktp);
        }
		dataList.push(list)
	}
	var listData = dataList.join("&");
	console.log(dicArray);
	if(dicArray.length != 1){
		closeDicWin();
		$.messager.alert("提示","请选择同一类型的记录修改！");
		return false;
	}
	runClassMethod("web.DHCCKBGetDicSourceUtil","ChangeRuleDic",
		{"listData":listData,"dicId":dicData,"preDicId":preDicId,"dicProp":dicProp},
		function(data){
			if(data==0){
				closeDicWin();
				$('#linkattrlist').datagrid("reload");
				$.messager.popover({msg: '保存成功！！',type:'success',timeout: 1000});
			}else{
				$.messager.alert("提示","修改失败,错误代码:"+data)
				return;
			}				
		}
	)
}
///查询树的方法  sufan2020-08-03
function reloadTree(){
	var Input=$.trim($HUI.searchbox("#queryCode").getValue());
	if(Input==""){
		var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonDataByNode&id="+dicParref+"&Input=";
	}else{
		var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+dicParref+"&Input="+Input;
	}
	$('#dictree').tree('options').url = encodeURI(url);	
	$('#dictree').tree('reload');
}

///设置规则明细连接 xww 2021-08-06
function SetCellOperation(value, rowData, rowIndex){

	var btn="无"
	if(rowData.ruleMark.indexOf("规则")>-1){
		var btn = "<img class='mytooltip' title='规则详情' onclick=\"OpenEditWin('"+rowData.ruleID+"','linkprop','"+rowData.drugID+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png' style='border:0px;cursor:pointer'>" 
	}
 	return btn;  

}

/// 设置规则明细连接 xww 2021-08-06
function OpenEditWin(ruleID,model,drugID){

	var linkUrl="dhcckb.rule.index0.csp",title=""

	var openUrl = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+linkUrl+'?ruleID='+ruleID+'&drugID='+drugID+'"></iframe>';

	if($('#winmodel').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="winmodel"></div>');
	$('#winmodel').window({
		title:"规则编辑器",
		collapsible:true,
		border:false,
		closed:"true",
		modal:true,
		maximized:true,
		maximizable:true,
		width:800,
		height:500
	});	

	$('#winmodel').html(openUrl);
	$('#winmodel').window('open');

}
///关闭窗口
function closeDicWin()
{
	$("#UpdDicWin").window('close')
}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })

