//===========================================================================================
// Author：      qunianpeng
// Date:		 2019-06-28
// Description:	 新版临床知识库-实体维护属性
//===========================================================================================

var editRow = 0;
var subEditRow = 0; 
var extraAttr = "KnowType";			// 知识类型(附加属性)
var extraAttrValue = "ModelFlag" 	// 实体标记(附加属性值)
var parref = "";					// 具体药品id
var dicParref = ""					// 药品实体id
/// 页面初始化函数
function initPageDefault(){
	
	InitDataList();		// 页面DataGrid初始化定义
	InitButton();		// 按钮响应事件初始化
	InitCombobox();		// 初始化combobox
	InitSubDataList();  // 页面DataGrid初始化定义
	InitAttrValueList(); // 
}


/// 按钮响应事件初始化
function InitButton(){

	$("#insert").bind("click",InsertRow);	// 增加新行
	
	$("#save").bind("click",SaveRow);		// 保存
	
	$("#delete").bind("click",DeleteRow);	// 删除
	
	$("#find").bind("click",QueryDicList);	// 查询
	
	$("#reset").bind("click",InitPageInfo);	// 重置
	
	/// 代码.描述查询
	//$("#code,#desc").bind("keypress",QueryDicList);	
	$('#queryCode').searchbox({
	    searcher:function(value,name){
	   		QueryDicList();
	    }	   
	});
	
	$("#subinsert").bind("click",SubInsertRow);	// 增加新行
	
	$("#subsave").bind("click",SubSaveRow);		// 保存
	
	$("#subdel").bind("click",SubDelRow);	// 删除
	
	$("#subfind").bind("click",SubQueryDicList);	// 查询
	
	$("#test").bind("click",AddAttrValue);	// 查询
	//$("#subreset").bind("click",InitPageInfo);	// 重置
	
}

/// 初始化combobox
function InitCombobox(){
		
	/// 初始化分类检索框
	var option = {
		panelHeight:"auto",
		mode:"remote",
		valueField:'value',
		textField:'text',		
        onSelect:function(option){
	        dicParref = option.value;
	       	QueryDicList();
	    }
	}; 
	var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue="+extraAttrValue;
	new ListCombobox("dicType",url,'',option).init(); 	
}


/// 页面DataGrid初始定义通用名
function InitDataList(){
						
	// 编辑格
	var texteditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	// 定义columns
	var columns=[[   	 
			{field:'dicID',title:'rowid',hidden:true},
			{field:'dicCode',title:'代码',width:200,align:'left',editor:texteditor},
			{field:'dicDesc',title:'描述',width:300,align:'left',editor:texteditor},
			{field:'parref',title:'父节点id',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'parrefDesc',title:'父节点',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'linkDr',title:'关联',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'linkDesc',title:'关联描述',width:300,align:'left',editor:texteditor,hidden:true}
			/* {field:'Operating',title:'操作',width:380,align:'left',formatter:SetCellOperation} */
			
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
 			parref=rowData.dicID;  
		   	SubQueryDicList(rowData.dicID);		 
		}, 
		onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
           /*  if (editRow != ""||editRow == 0) { 
                $("#diclist").datagrid('endEdit', editRow); 
            } 
            $("#diclist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex;  */
        }
		  
	}
	var params = ""
	var uniturl = $URL+"?ClassName=web.DHCCKBEditProp&MethodName=GetDicInstanceByParref&extraAttr="+"DataSource"+"&parref="+parref+"&params="+params;
	
	new ListComponent('diclist', columns, uniturl, option).Init();
	
}

// 插入新行
function InsertRow(){
	
	if(editRow>="0"){
		$("#diclist").datagrid('endEdit', editRow);		//结束编辑，传入之前编辑的行
	}
	$("#diclist").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		/* row: {ID:'', Code:'', Desc:'',Type:"",TypeDr:""} */
		row: {}
	});
	$("#diclist").datagrid('beginEdit', 0);				//开启编辑并传入要编辑的行
	editRow=0;
}

// 删除选中行
function DeleteRow(){
	
	var rowsData = $("#diclist").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCCKBDiction","DeleteDic",{"typeID":rowsData.ID},function(jsonString){
					$('#diclist').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

/// 保存编辑行
function SaveRow(){
	
	if(editRow>="0"){
		$("#diclist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#diclist").datagrid('getChanges');
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

		var tmp=$g(rowsData[i].ID) +"^"+ $g(rowsData[i].CDCode) +"^"+ $g(rowsData[i].CDDesc);
		
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	var attrData = extraAttr +"^"+ extraAttrValue;

	//保存数据
	runClassMethod("web.DHCCKBDiction","SaveUpdate",{"params":params,"attrData":attrData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert('提示','保存失败！','warning');
			InitPageInfo();
			return;	
		}else{
			$.messager.alert('提示','保存成功！','info');
			InitPageInfo();
			return;
		}
		
		//$('#diclist').datagrid('reload'); //重新加载
	});
}

/// 删除数据
function DeleteRow(){
	 
	var rowsData = $("#diclist").datagrid('getSelected'); 						// 选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {	// 提示是否删除
			if (res) {
				runClassMethod("web.DHCCKBDiction","DeleteDic",{"dicID":rowsData.ID},function(jsonString){
					if (jsonString == 0){
						$('#diclist').datagrid('reload'); //重新加载
					}else{
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

// 查询
function QueryDicList()
{
	var params = $HUI.searchbox("#queryCode").getValue();

	$('#diclist').datagrid('load',{
		extraAttr:"DataSource",
		parref:dicParref,
		params:params
	}); 
}


/// 页面DataGrid初始定义通用名
function InitSubDataList(){
						
	// 编辑格
	var texteditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	var attreditor={  
		type: 'combobox',	//设置编辑格式
		options: {
			url: "",
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			blurValidValue:true,
			onSelect:function(option){
				var ed=$("#linkattrlist").datagrid('getEditor',{index:subEditRow,field:'attrDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#linkattrlist").datagrid('getEditor',{index:subEditRow,field:'attrID'});
				$(ed.target).val(option.value);
			},
			onShowPanel:function(){				
				var ed=$("#linkattrlist").datagrid('getEditor',{index:subEditRow,field:'attrDesc'});
				///设置级联指针
				var params=parref+"^"+"LinkProp"+ "^"+ dicParref;
				var unitUrl=$URL+"?ClassName=web.DHCCKBEditProp&MethodName=GetDicAttrList&params="+ params;
				$(ed.target).combobox('reload',unitUrl);
			}
		 }
	}
	
	// 定义columns	 // linkRowID^attrID^dataType^linkAttrDr^linkAttrValue
	var columns=[[   // 关联表id ,属性id,属性描述，属性的数据类型, 属性值id，属性值描述(需要鼠标悬浮时间)	 
			{field:'linkRowID',title:'rowid',hidden:true},
			{field:'attrID',title:'属性id',width:60,align:'left',editor:texteditor,hidden:true},
			{field:'attrDesc',title:'属性',width:300,align:'left',editor:attreditor},
			{field:'dataType',title:'数据类型',width:300,align:'left',hidden:false},
			{field:'linkAttrDr',title:'属性值ID',width:300,align:'left',editor:texteditor,hidden:false},
			{field:'linkAttrValue',title:'属性值',width:300,align:'left',editor:texteditor,hidden:false}
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
		   
		}, 
		onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (subEditRow != ""||subEditRow == 0) { 
                $("#linkattrlist").datagrid('endEdit', subEditRow); 
            } 
            $("#linkattrlist").datagrid('beginEdit', rowIndex); 
            
            subEditRow = rowIndex; 
            dataGridBindEnterEvent(rowIndex);
        }
		  
	}
	var params = "" +"^"+ "LinkProp";
	var uniturl = $URL+"?ClassName=web.DHCCKBEditProp&MethodName=GetLinkAttrListData&params="+params;

	new ListComponent('linkattrlist', columns, uniturl, option).Init();
	
}

/// sub插入新行
function SubInsertRow(){
	
	if(subEditRow>="0"){
		$("#linkattrlist").datagrid('endEdit', subEditRow);		//结束编辑，传入之前编辑的行
	}
	$("#linkattrlist").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		/* row: {ID:'', Code:'', Desc:'',Type:"",TypeDr:""} */
		row: {}
	});
	$("#linkattrlist").datagrid('beginEdit', 0);				//开启编辑并传入要编辑的行
	subEditRow=0;
	dataGridBindEnterEvent(subEditRow);
}

/// sub保存
function SubSaveRow(){
	
	var parrefObj = $("#diclist").datagrid('getSelected');
	var tmpparref = $g(parrefObj.dicID)
	
	if(subEditRow>="0"){
		$("#linkattrlist").datagrid('endEdit', subEditRow);
	}

	var rowsData = $("#linkattrlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
	
		if((rowsData[i].linkAttrValue=="")){
			$.messager.alert("提示","属性值不能为空!"); 
			return false;
		}
		var linkAttrValue = $g(rowsData[i].linkAttrDr) =="" ? $g(rowsData[i].linkAttrValue) :"" ;	// 属性值id不为空，则内容字段为空
		var tmp=$g(rowsData[i].linkRowID) +"^"+ tmpparref +"^"+ $g(rowsData[i].attrID) +"^"+ linkAttrValue +"^"+ $g(rowsData[i].linkAttrDr);
		
		dataList.push(tmp);
	} 
	var ListData=dataList.join("&&");

	//保存数据
	runClassMethod("web.DHCCKBDicLinkAttr","SaveDicAttr",{"ListData":ListData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert('提示','保存失败！','warning');
			SubQueryDicList(parref);
			return;	
		}else{
			$.messager.alert('提示','保存成功！','info');
			SubQueryDicList(parref);
			return;
		}
		
		//$('#diclist').datagrid('reload'); //重新加载
	});
}

/// sub删除
function SubDelRow(){

	var rowsData = $("#linkattrlist").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCCKBDicLinkAttr","DelDicAttr",{"linkRowID":rowsData.linkRowID},function(jsonString){
					$('#linkattrlist').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

function SubQueryDicList(id){

	//var params = $HUI.searchbox("#subQueryCode").getValue();
	$('#linkattrlist').datagrid('load',{
		params:id +"^"+"LinkProp"
	}); 
}

/// 
function dataGridBindEnterEvent(index){
	
	subEditRow=index;
		
	var rows = $("#linkattrlist").datagrid("getRows");
	var row = rows[index];
	var htmlType=$g(row.dataType);
	if (htmlType == ""){htmlType="textarea"}
	
	var editors = $('#linkattrlist').datagrid('getEditors', index);
	for(var i=0;i<editors.length;i++){
		var workRateEditor = editors[i];
		
		//属性值  linkAttrValue
		if(workRateEditor.field=="linkAttrValue"){
			workRateEditor.target.mousedown(function(e){
				var ed=$("#linkattrlist").datagrid('getEditor',{index:index, field:'linkAttrValue'});		
				var input = $(ed.target).val();
				divComponent({tarobj:$(ed.target),htmlType:htmlType,width: 400,height: 260},function(obj){
					//var ed=$("#linkattrlist").datagrid('getEditor',{index:index, field:'linkAttrDr'});						
					//$(ed.target).val(obj);				
				})				
			});
		}
		else{
			workRateEditor.target.mousedown(function(e){
					$("#win").remove();;
			});
			workRateEditor.target.focus(function(e){
					$("#win").remove();;
			});
		}
	}
}

// 重置
function InitPageInfo(){
	
	//$("#code").val("");
	//$("#desc").val("");
	$HUI.searchbox('#queryCode').setValue("");
	QueryDicList();	
	//$("#div-img").show();

}

/// 页面属性值treeGrid初始定义
function InitAttrValueList(){
						
	// 定义columns
	var columns=[[     
			{field:'id',title:'id',width:80,sortable:true,hidden:true},
			{field:'code',title:'代码',width:80,sortable:true,hidden:true},
			{field:'desc',title:'属性',width:360,sortable:true,hidden:false},
			{field:'_parentId',title:'parentId',width:80,sortable:true,hidden:true}				
		 ]]

	var option={	
		height:$(window).height()-105,
		idField: 'id',
		treeField:'desc',
		checkbox:true,
		fitColumns:true,	//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		lines:true,		
		showHeader:false,
		pagination:false,
		rownumbers:false,
		//pageSize:30,
		//pageList:[30,60,90],				
		onDblClickRow: function (rowIndex, rowData) {	//双击选择行编辑
        }		  
	}
	
	var params = ""
	var uniturl = "" //$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonNew&attrID=99&input=" //$URL+"?ClassName=web.DHCSTPHCMADDEXTLIB&MethodName=QueryLibItemDs";
	new ListTreeGrid('mygrid', columns, uniturl, option).Init();
	
}

///	编辑属性值 
function AddAttrValue(){
	//var htmlType="textarea" //attrId
	var htmlType="treegrid";
	$("#myWin").show();
	
	if (htmlType == "textarea"){
	
	}else if (htmlType == "treegrid"){
		
	}else if(htmlType == "input"){
		
	}else if(htmlType == "checkbox"){
	
	}else{
	
	}
	var options={}
	options.url=$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonNew&attrID=99&input=" 
	$('#mygrid').treegrid(options);
	$('#mygrid').treegrid('reload');
	/*$('#mygrid').datagrid('reload',  { 
	    ClassName:"web.DHCCKBQueryDic",
	    QueryName:"GetTreeJsonNew",
	    attrID:"99",
        input:""
	});
	*/
	
	$("#my"+htmlType).show();	
	
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
				console.log($('#mygrid').treegrid('getCheckedNodes','checked'));
				SaveDicTree()
			}
		},{
			text:'关闭',
			handler:function(){
				myWin.close();
			}
		}]
	});	
}

/// 保存属性值
function SaveAttrValue(){



}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
