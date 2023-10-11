//===========================================================================================
// Author：      kemaolin
// Date:		 2020-01-20
// Description:	 新版临床知识库-模板维护属性
//===========================================================================================

var tempDataId=serverCall("web.DHCCKBCommon","GetDicIdByCode",{'code':'TempData'}); //模板字典Id
var tempElemCode="TempElement"  //模板元素Code
var tempElemId=serverCall("web.DHCCKBCommon","GetDicIdByCode",{'code':'TempElement'}); //模板元素Id
var extraAttr = "KnowType";			// 知识类型(附加属性)
var extraAttrValue = "ModelFlag" 	// 实体标记(附加属性值)
var extraAttrDic = "DictionFlag"	//字典标记
//var propId="" //实体属性Id
var propList=[];
var delPropList=[];
var tempId="" //模板Id
var dicID=""; //实体Id	
var editRow=0 //,editsubRow = 0;	
var queryDicID="";
var queryParams="";
var TempWinFlag="";   //sufan  记录弹窗类型
/// JQuery 初始化页面
$(function(){ 
	
	initPageDefault(); 
})

/// 页面初始化函数
function initPageDefault(){
	
	InitButton();			// 按钮响应事件初始化
	//InitCombobox();			// 初始化combobox
	InitEntityCombobox();
	InitDicCombobox();
	initTempElemGrid();
	initAttrGrid();
	initTempTree();				//sufan 2020-03-27 新增加载方法
	//InitSubDataList();		//sufan 2020-03-27 模板以树形加载维护，先注释
	
}

/// 按钮响应事件初始化
function InitButton(){

	$("#insert").bind("click",SubInsertRow); //模板新增行
	$("#save").bind("click",SubSaveRow); //模板保存
	$("#delete").bind("click",SubDelRow); //模板删除
	$("#addTempElem").bind("click",addTempElem); //添加模板元素 
	$("#removeTempElem").bind("click",removeTempElem); //移除模板元素 	
	//检索框
	$('#queryEnt').searchbox({
	    searcher:function(value,name){
	   		queryEnt();
	    }	   
	});	
	
	$('#queryDic').searchbox({
	    searcher:function(value,name){
	   		queryDic();
	    }	   
	});
	$("#canwin").bind("click",canWin); 		//关闭窗口
	
	$("#saveTree").bind("click",saveTree);
	
	$('#tempsearch').searchbox({
	    searcher:function(value,name){
	   		QueryTemp();
	    }	   
	});	
	
}

// 查询
function queryEnt()
{
	var query = $HUI.searchbox("#queryEnt").getValue();
	
	$('#attrlist').datagrid('load',{
		query:query,
		listType:1,
		params:queryParams
	}); 
}
function queryDic()
{
	var query = $HUI.searchbox("#queryDic").getValue();
	
	$('#attrlist').datagrid('load',{
		query:query,
		listType:0,
		id:queryDicID
	}); 
}
/// 初始化combobox
//=================================实体下拉框=================================================
function InitEntityCombobox(){
		
	/// 初始化分类检索框
	var option = {
		panelHeight:"250", //auto
		mode:"remote",
		valueField:'value',
		textField:'text',		
        onSelect:function(option){
	       dicID = option.value;
 		   var params=dicID +"^"+ "LinkProp";
 		   queryParams=params;
		   $("#attrlist").datagrid("load",{"params":params,'listType':1});
	    }
	}; 
	var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue="+extraAttrValue;
	new ListCombobox("entityType",url,'',option).init(); 	
}

//=================================字典下拉框=================================================
function InitDicCombobox(){
		
	/// 初始化分类检索框
	var option = {
		panelHeight:"250", //auto
		mode:"remote",
		valueField:'value',
		textField:'text',		
        onSelect:function(option){
	       dicID = option.value;
	       queryDicID=dicID;
	       //$("#attrlist").datagrid('options').url=$URL+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicByID";
 		   //var params=dicID +"^"+ "LinkProp"
		   $("#attrlist").datagrid("load",{'id':dicID,'listType':0});
	    }
	}; 
	var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue="+extraAttrDic;
	new ListCombobox("dicType",url,'',option).init(); 	
}

//=================================模板属性关联列表=================================================
///模板属性关联列表
function initTempElemGrid()
{
	/// 文本编辑格
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	///  定义columns
	var columns=[[ //ID^DLADicDr^DLAAttrCode^DLAAttrCodeDesc^DLAAttrDr^DLAAttrDesc^DLAResult
		{field:'linkRowId',title:'linkRowId',width:50,editor:textEditor,hidden:false},
		{field:'attrCodeDr',title:'attrCodeDr',width:50,hidden:true},
		{field:'attrCodeDesc',title:'attrCodeDesc',width:450,hidden:true},
		{field:'attrValueDr',title:'元素id',width:100},
		{field:'attrValue',title:'描述',width:450},
		{field:'attrResult',title:'attrResult',width:450,hidden:true}
	]];
	
	///  定义datagrid
	var option = {
		fitColumns:true,
		//singleSelect : true,
	    //onDblClickRow: function (rowIndex, rowData) {},	//双击选择行编辑
	    //onClickRow: function(rowIndex,rowData){
	 	//}, 
	};
	 //w ##class(web.DHCCKBDicLinkAttr).QueryDicLinkAttr("10","1","4072^2860^5282")
	var params=tempId +"^"+ tempElemId;
	var uniturl = $URL+"?ClassName=web.DHCCKBDicLinkAttr&MethodName=QueryDatagridDicLinkAttr&params="+params;
	new ListComponent('tempElement', columns, uniturl, option).Init();
}

/// 属性移除
function removeTempElem(){

	//var rowsData = $("#tempElement").datagrid('getSelected'); //选中要删除的行
	//if (rowsData != null) {
	delPropList=$("#tempElement").datagrid('getSelections');
	var RowIDList=""
	$.each(delPropList,function(index,item){
		if(RowIDList==""){
			RowIDList=item.linkRowId
		}else{
			RowIDList=RowIDList+"&"+item.linkRowId
		}
	})
	if(RowIDList!=""){
		//$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
		//	if (res) {
				runClassMethod("web.DHCCKBDicLinkAttr","DelData",{"params":RowIDList},function(jsonString){					
					if (jsonString==0){
						var params=tempId +"^"+ tempElemId;
						$('#tempElement').datagrid('load',{'params':params}); //重新加载
					}
					else{
						 $.messager.alert('提示','删除失败.失败代码'+jsonString,'warning');
					}
					
				})
		//	}
		//});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

//保存模板元素
function addTempElem(){
	
	var node = $("#tempTree").tree('getSelected');
	var isLeaf = $("#tempTree").tree('isLeaf',node.target);   /// 是否是叶子节点
    if (!isLeaf){
        $.messager.alert("提示","请选择末级节点添加！")
        return;
    }
    tempId=node.id;
	propList=$("#attrlist").datagrid('getSelections');
	if(propList.length==0){
		$.messager.alert("提示","请选择实体属性")
		return;	
	}
	var listData=""
	
	$.each(propList,function(index,item){
		if(listData==""){
			listData="^"+tempId+"^"+tempElemId+"^"+item.ID+"^"+tempElemCode;
		}else{
			listData=listData+"&&"+"^"+tempId+"^"+tempElemId+"^"+item.ID+"^"+tempElemCode;
		}
	})
	//var ListStr="0" +"^"+ tempId +"^"+ tempElemId +"^"+ "" +"^"+ ""
	//var ListData ="^"+tempId+"^"+tempElemId+"^"+propId+"^"+tempElemCode;
	//var Type="datagrid" ;
	//保存数据
	runClassMethod("web.DHCCKBDicLinkAttr","saveGridData",{"ListData":listData,"repeatFlag":1},function(jsonString){
		if (jsonString < 0){
			$.messager.alert('提示','保存失败！','warning');
			var params=tempId +"^"+ tempElemId;
			$('#tempElement').datagrid('load',{'params':params}); //重新加载
			return;	
		}else{
			//$.messager.alert('提示','保存成功！','info');
	 		var params=tempId +"^"+ tempElemId;
			$('#tempElement').datagrid('load',{'params':params}); //重新加载
			return;
		}
	});
}
//======================================实体属性列表===========================================================

///实体属性列表
function initAttrGrid()
{
	/// 文本编辑格
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	///  定义columns
	var columns=[[ //ID^DLADicDr^DLAAttrCode^DLAAttrCodeDesc^DLAAttrDr^DLAAttrDesc^DLAResult
		{field:'ID',title:'ID',width:50,editor:textEditor,hidden:true},
		{field:'code',title:'代码',width:50,hidden:true},
		{field:'desc',title:'描述',width:650}
	]];
	
	///  定义datagrid
	var option = {
		fitColumns:true,
		//singleSelect : true,
	    //onDblClickRow: function (rowIndex, rowData) {},	//双击选择行编辑
	    //onClickRow: function(rowIndex,rowData){
	 	//	propId=rowData.ID;
	 	//}, 
	};
	
	var params=dicID +"^"+ "LinkProp"
	//var uniturl = $URL+"?ClassName=web.DHCCKBRangeCat&MethodName=QueryDicAttr&params="+params;
	var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicAndAttrList&params="+params+"&listType=1";
	new ListComponent('attrlist', columns, uniturl, option).Init();
}

//==================================================模板维护部分============================================================//
/// 页面DataGrid初始定义通用名
function InitSubDataList(){				
	// 编辑格
	var texteditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	// 定义columns
	var columns=[[   	 
			{field:'ID',title:'rowid',hidden:true},
			{field:'CDCode',title:'代码',width:200,align:'left',editor:texteditor},
			{field:'CDDesc',title:'描述',width:400,align:'left',editor:texteditor},
			{field:'Parref',title:'父节点id',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'ParrefDesc',title:'父节点',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'CDLinkDr',title:'关联',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'CDLinkDesc',title:'关联描述',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'KnowType',title:"数据类型",width:200,align:'left',hidden:true},
			{field:'Operating',title:'操作',width:200,align:'center',formatter:SetCellOperation} 
			
		 ]]

	var option={	
		//bordr:false,
		//fit:true,
		fitColumns:true,
		singleSelect:true,	
		//nowrap: false,
		//striped: true, 
		//pagination:true,
		//rownumbers:true,
		//pageSize:30,
		//pageList:[30,60,90],		
 		onClickRow:function(rowIndex,rowData){
	 		tempId=rowData.ID;
	 		//var params=tempId +"^"+ tempElemCode
	 		var params=tempId +"^"+ tempElemId
	 		$("#tempElement").datagrid("load",{"params":params});

	 	}, 
		onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editRow != ""||editRow == 0) { 
                $("#templist").datagrid('endEdit', editRow); 
            } 
            $("#templist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        },
        onLoadSuccess:function(data){
            $('.mytooltip').tooltip({
            trackMouse:true,
            onShow:function(e){
              $(this).tooltip('tip').css({});
            }
          });          
        }	
		  
	}
	var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicByID&id="+tempDataId+"&parrefFlag=0&parDesc=";
	new ListComponent('templist', columns, uniturl, option).Init();
	
}

/// sub插入新行
function SubInsertRow(){
	
	if(editRow>="0"){
		$("#templist").datagrid('endEdit', editRow);		//结束编辑，传入之前编辑的行
	}
	$("#templist").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		/* row: {ID:'', Code:'', Desc:'',Type:"",TypeDr:""} */
		row: {}
	});
	$("#templist").datagrid('beginEdit', 0);				//开启编辑并传入要编辑的行
	editRow=0;
}

/// sub保存
function SubSaveRow(){
	
	if(editRow>="0"){
		$("#templist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#templist").datagrid('getChanges');
	
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].CDCode=="")||(rowsData[i].CDDesc=="")){
			$.messager.alert("提示","代码或描述不能为空!"); 
			return false;
		}

		var tmp=$g(rowsData[i].ID) +"^"+ $g(rowsData[i].CDCode) +"^"+ $g(rowsData[i].CDDesc) +"^"+ tempDataId;
		
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	var attrData = "";

	//保存数据
	runClassMethod("web.DHCCKBDiction","SaveUpdate",{"params":params,"attrData":attrData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert('提示','保存失败！','warning');
			return;	
		}else{
			$.messager.alert('提示','保存成功！','info');
			var params=tempId +"^"+ tempElemId
	 		$("#templist").datagrid("load",{"params":params});
			return;
		}	
	});
}

/// sub删除
function SubDelRow(){

	var rowsData = $("#templist").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCCKBDiction","DeleteDic",{"dicID":rowsData.ID},function(jsonString){					
					if (jsonString==0){
						var params=tempId +"^"+ tempElemId
	 					$("#templist").datagrid("load",{"params":params});
					}else if (jsonString == "-1"){
						 $.messager.alert('提示','该数据已被引用,不能直接删除！','warning');
					}
					else{
						 $.messager.alert('提示','删除失败.失败代码'+jsonString,'warning');
					}
					
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}
/*
/// sub 查询
function SubQueryDicList(id){
	
	var params = $HUI.searchbox("#subQueryCode").getValue();
	
	$('#templist').datagrid('load',{
		id:tempDataId,
		parrefFlag:0,
		parDesc:params
	}); 
}

// 重置
function InitSubPageInfo(){

	$HUI.searchbox('#subQueryCode').setValue("");
	SubQueryDicList();	

}
*/

//===========================================附加属性弹框========================================================

///设置操作明细连接
function SetCellOperation(value, rowData, rowIndex){
	var btn = "<img class='mytooltip' title='附加属性' onclick=\"OpenEditWin('"+rowData.ID+"','linkprop','"+rowData.DataType+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png' style='border:0px;cursor:pointer'>" 
    return btn;  
	
}

/// 属性值编辑框
function OpenEditWin(ID,model,dataType){

	var linkUrl="",title=""
	if (model == "list"){
		
		linkUrl = "dhcckb.addlist.csp"
		title = "字典维护"
		
	}else if (model =="prop"){
		
		linkUrl = "dhcckb.addattr.csp";
		title = "属性列表";
		
	}else if (model == "linkprop"){
		
		linkUrl = "dhcckb.addlinkattr.csp";
		title ="附加属性维护";
		
	}else {
		linkUrl = "dhcckb.addlist.csp"
		title = "字典维护"
	}	

	var openUrl = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+linkUrl+'?parref='+ID+'"></iframe>';

	if($('#winmodel').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="winmodel"></div>');
	$('#winmodel').window({
		title:title,
		collapsible:true,
		border:false,
		closed:"true",
		modal:true,
		//maximized:true,
		maximizable:true,
		minimizable:false,		
		width:$(window).width()-50, //800,
		height:$(window).height()-50,//500
	});	

	$('#winmodel').html(openUrl);
	$('#winmodel').window('open');

}
/*========================sufan 2020-03-27start===========================================================================*/
function initTempTree()
{
	
	uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryTempTree&ParentId='+tempDataId+"&Input=";
	var option = {
		multiple:true,
		lines:true,
		animate:true,
		dnd:true,
        onClick:function(node, checked){
	        var isLeaf = $("#tempTree").tree('isLeaf',node.target);   /// 是否是叶子节点
	        if (isLeaf){
		        var params=node.id +"^"+ tempElemId;
				$('#tempElement').datagrid('load',{'params':params}); //重新加载
	        }else{
		    	
		    }
	    }, 
		onContextMenu: function(e, node){
			
			e.preventDefault();
			var node = $("#tempTree").tree('getSelected');
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
		onLoadSuccess: function(node, data){
			
		}
	};
	new CusTreeUX("tempTree", uniturl, option).Init();
}
///保存模板
function newCreateItmCat(type)
{
	TempWinFlag = type;
	var node = $("#tempTree").tree('getSelected');
	newCreateItmCatWin(type);      
	InitItmCatDefault(type);   		
}

/// Window 定义
function newCreateItmCatWin(type){
	
	/// 分类窗口
	var option = {
		modal:false,
		collapsible:true,
		border:true,
		closed:"true"
	};
	
	var title = "新增下级";
	if (type == "S"){
		title = "增加同级";
	}
	if(type == "U"){
		title = "更新 ";
	}
	
	new WindowUX(title, 'samewin', '400', '200', option).Init();
}
/// 初始化界面默认信息
function InitItmCatDefault(type){
	
	$("#sametpdesc").val("");    	/// 描述
	$("#sametpcode").val("");   	/// 代码
	var node = $("#tempTree").tree('getSelected');
	if(type=="N"){
		$("#lastsameId").val(node.id);
		$("#lastsamedesc").val(node.text);
	}else if(type=="U"){
		var List = serverCall("web.DHCCKBDiction","GetLastList",{"Id":node.id});
		var Array = List.split("^"); 
		$("#sametpcode").val(node.code);
		$("#sametpdesc").val(node.text);
		$("#lastsameId").val(Array[0]);
		$("#lastsamedesc").val(Array[1]);
		
	}else{
		var List = serverCall("web.DHCCKBDiction","GetLastList",{"Id":node.id});
		var Array = List.split("^"); 
		$("#lastsameId").val(Array[0]);
		$("#lastsamedesc").val(Array[1]);
	}
}
/// 关闭窗口
function canWin()
{
	$("#samewin").window('close');
}
///保存
function saveTree()
{
	var node = $("#tempTree").tree('getSelected');
	var Code = $("#sametpcode").val();
	var Desc = $("#sametpdesc").val();
	if((Code=="")||(Desc=="")){
		$.messager.alert("提示","代码或描述不能为空！");
		return;
	}
	var LastId = $("#lastsameId").val();
	if(TempWinFlag == "U"){
		var ListData = node.id +"^"+ Code +"^"+ Desc +"^"+ LastId;
		
	}else{
		var ListData = "" +"^"+ Code +"^"+ Desc +"^"+ LastId;
	}
	//保存数据
	runClassMethod("web.DHCCKBDiction","SaveUpdate",{"params":ListData,"attrData":""},function(jsonString){
		if (jsonString < 0){
			$.messager.alert('提示','保存失败！','warning');
			return;	
		}else{
			$.messager.alert('提示','保存成功！','info');
			canWin();
			$("#tempTree").tree('reload');
			return;
		}	
	});
}
///删除
function DeleTree()
{
	
	var node = $("#tempTree").tree('getSelected');
	if (node != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCCKBDiction","DeleTree",{"dicID":node.id},function(jsonString){
					if(jsonString==-1){
						$.messager.alert("提示","该模板存在关联数据！");
						return;
					}
					$("#tempTree").tree('reload');
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}
///查询
function QueryTemp()
{
	var Input = $.trim($HUI.searchbox("#tempsearch").getValue());
	uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryTempTree&ParentId='+tempDataId+"&Input="+Input;
	$("#tempTree").tree('options').url =encodeURI(uniturl);
	$("#tempTree").tree('reload');
}
