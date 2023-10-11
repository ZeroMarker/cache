//===========================================================================================
// Author：      qunianpeng
// Date:		 2019-01-04
// Description:	 新版临床知识库-字典数据
//===========================================================================================

var editRow = 0;
var extraAttr = "KnowType";			// 知识类型(附加属性)
var extraAttrValue = "DictionFlag" 	// 字典标记(附加属性值)
var parref = getParam("parref");

/// 页面初始化函数
function initPageDefault(){
	
	InitButton();		// 按钮响应事件初始化
	InitCombobox();		// 初始化combobox
	InitSubDataList();  // 页面DataGrid初始化定义
}

/// 按钮响应事件初始化
function InitButton(){

	/// 代码.描述查询
	//$("#code,#desc").bind("keypress",QueryDicList);	
	$('#subQueryCode').searchbox({
	    searcher:function(value,name){
	   		SubQueryDicList();
	    }	   
	});
	
	$("#subinsert").bind("click",SubInsertRow);	// 增加新行
	
	$("#subsave").bind("click",SubSaveRow);		// 保存
	
	$("#subdel").bind("click",SubDelRow);	// 删除
	
	//$("#subfind").bind("click",SubQueryDicList);	// 查询
	
	$("#reset").bind("click",InitPageInfo);	// 重置
	
}

/// 初始化combobox
function InitCombobox(){}


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
 		onClickRow:function(rowIndex,rowData){}, 
		onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editRow != ""||editRow == 0) { 
                $("#subdiclist").datagrid('endEdit', editRow); 
            } 
            $("#subdiclist").datagrid('beginEdit', rowIndex); 
            
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
	var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicByID&id="+parref+"&parrefFlag=0&parDesc=";
	new ListComponent('subdiclist', columns, uniturl, option).Init();
	
}

/// sub插入新行
function SubInsertRow(){
	
	if(editRow>="0"){
		$("#subdiclist").datagrid('endEdit', editRow);		//结束编辑，传入之前编辑的行
	}
	$("#subdiclist").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		/* row: {ID:'', Code:'', Desc:'',Type:"",TypeDr:""} */
		row: {}
	});
	$("#subdiclist").datagrid('beginEdit', 0);				//开启编辑并传入要编辑的行
	editRow=0;
}

/// sub保存
function SubSaveRow(){
	
	if(editRow>="0"){
		$("#subdiclist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#subdiclist").datagrid('getChanges');
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

		var tmp=$g(rowsData[i].ID) +"^"+ $g(rowsData[i].CDCode) +"^"+ $g(rowsData[i].CDDesc) +"^"+ parref;
		
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	var attrData = "";

	//保存数据
	runClassMethod("web.DHCCKBDiction","SaveUpdate",{"params":params,"attrData":attrData},function(jsonString){
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

	var rowsData = $("#subdiclist").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCCKBDiction","DeleteDic",{"dicID":rowsData.ID},function(jsonString){
					$('#subdiclist').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

/// sub 查询
function SubQueryDicList(id){
	
	var params = $HUI.searchbox("#subQueryCode").getValue();
	
	$('#subdiclist').datagrid('load',{
		id:id,
		parrefFlag:0,
		parDesc:params
	}); 
}

// 重置
function InitPageInfo(){
	
	//$("#code").val("");
	//$("#desc").val("");
	$HUI.searchbox('#subQueryCode').setValue("");
	SubQueryDicList();	
	//$("#div-img").show();

}

///设置操作明细连接
function SetCellOperation(value, rowData, rowIndex){

	///<a href='#' onclick=\"showAuditListWin('"+a+"','"+a+"')\"><img src='../scripts/dhcnewpro/images/adv_sel_11.png' border=0/>集合</a>";
	/* var btnGroup="<a style='margin-right:10px;' href='#' onclick=\"switchMainSrc('"+rowData.ID+"','list','"+rowData.DataType+"')\">集合</a>"; */
	/*var btnGroup="";
	btnGroup = btnGroup + "<a style='margin-right:10px;display:none' href='#' onclick=\"OpenEditWin('"+rowData.ID+"','prop','"+rowData.DataType+"')\"><img src='../scripts/dhcnewpro/images/adv_sel_11.png' border=0/>属性</a>";
	btnGroup = btnGroup + "<a style='margin-right:10px;' href='#' onclick=\"OpenEditWin('"+rowData.ID+"','linkprop','"+rowData.DataType+"')\"><img src='../scripts/dhcnewpro/images/adv_sel_11.png' border=0/>附加属性</a>";
	
	return btnGroup;
	*/
	var btn = "<img class='mytooltip' title='附加属性' onclick=\"OpenEditWin('"+rowData.ID+"','linkprop','"+rowData.DataType+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png' style='border:0px;cursor:pointer'>" 
    return btn;  
}

/// 属性编辑框
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

	linkUrl += '?parref='+ID;
	if ("undefined"!==typeof websys_getMWToken){
		linkUrl += "&MWToken="+websys_getMWToken(); 
	}
	var openUrl = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+linkUrl+'"></iframe>';

	if($('#winmodel').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="winmodel"></div>');
	$('#winmodel').window({
		title:title,
		collapsible:true,
		border:false,
		closed:"true",
		modal:true,
		minimizable:false,
		//maximized:true,
		maximizable:true,
		width:900,
		height:550
	});	

	$('#winmodel').html(openUrl);
	$('#winmodel').window('open');

}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })
