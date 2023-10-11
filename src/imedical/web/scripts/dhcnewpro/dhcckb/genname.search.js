//===========================================================================================
// Author：      kemaolin
// Date:		 2020-01-20
// Description:	 新版临床知识库-通用名查询
//===========================================================================================

var tempDataId=serverCall("web.DHCCKBCommon","GetDicIdByCode",{'code':'GeneralData'}); //通用名字典Id
var tempElemId=serverCall("web.DHCCKBCommon","GetDicIdByCode",{'code':'TempElement'}); //模板元素Id
//var extraAttr = "KnowType";			// 知识类型(附加属性)
//var extraAttrValue = "ModelFlag" 	// 实体标记(附加属性值)
//var extraAttrDic = "DictionFlag"	//字典标记
//var propId="" //实体属性Id
var tempId="" //模板Id
var dicID=""; //实体Id	
var editRow=0,editsubRow = 0;	

/// JQuery 初始化页面
$(function(){ 
	
	initPageDefault(); 
})

/// 页面初始化函数
function initPageDefault(){
	
	InitButton();			// 按钮响应事件初始化
	initTempElemGrid();
	InitSubDataList();
	initSearchbox();
}

/// 按钮响应事件初始化
function InitButton(){

	$("#insert").bind("click",SubInsertRow); //模板新增行
	$("#save").bind("click",SubSaveRow); //模板保存
	$("#delete").bind("click",SubDelRow); //模板删除
	
	$("#reset").bind("click",InitPageInfo);	// 重置

}

// 查询
function QueryDicList()
{
	var parDesc = $HUI.searchbox("#queryCode").getValue();
	
	$('#templist').datagrid('load',{
		id:tempDataId,
		parrefFlag:0,
		parDesc:parDesc
	}); 
}

function initSearchbox(){
	$('#queryCode').searchbox({
	    searcher:function(value,name){
	   		QueryDicList();
	    }	   
});
}


// 重置
function InitPageInfo(){
	$HUI.searchbox('#queryCode').setValue("");
	QueryDicList();	

}



//=================================通用名查询列表=================================================
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
	var columns=[[ 
		{field:'formGenDesc',title:'带剂型通用名'},
		{field:'proNameDesc',title:'商品名',width:200,align:'left',editor:textEditor},
		{field:'manfDesc',title:'生产厂家',width:400,align:'left',editor:textEditor}
	]];
	
	///  定义datagrid
	var option = {
		fitColumns:true,
		singleSelect : true,
	    //onDblClickRow: function (rowIndex, rowData) {},	//双击选择行编辑
	    onClickRow: function(rowIndex,rowData){
	 	}, 
	};
	 //w ##class(web.DHCCKBDicLinkAttr).QueryDicLinkAttr("10","1","4072^2860^5282")
	var GenNameID=tempId;
	var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=QueryByGeneralNameID&GenNameID="+GenNameID;
	new ListComponent('tempElement', columns, uniturl, option).Init();
}


//==================================================通用名字典列表============================================================//
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
	 		var GenNameID=tempId //+"^"+ tempElemId
	 		$("#tempElement").datagrid("load",{"GenNameID":GenNameID});

	 	}, 
		onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editsubRow != ""||editsubRow == 0) { 
                $("#templist").datagrid('endEdit', editsubRow); 
            } 
            $("#templist").datagrid('beginEdit', rowIndex); 
            var editors = $('#templist').datagrid('getEditors', rowIndex);    //wangxuejian 2021-05-19 失去焦点关闭编辑行  
	             for (var i = 0; i < editors.length; i++)   
                {  
                   var e = editors[i]; 
              	   $(e.target).bind("blur",function()
              	   {  
                      $("#templist").datagrid('endEdit', rowIndex);
                    });   
                  
                  } 
            
            editsubRow = rowIndex; 
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