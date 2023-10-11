/**
  *sufan
  *2020-12-29
  *按标记统计日志数据
  *
 **/
var hospArr = [{"value":"东华标准版数字化医院总院","text":'东华标准版数字化医院[总院]'},{"value":"东华标准版数字化医院分院","text":'东华标准版数字化医院[分院]'},{"value":"哈尔滨医科大学第一附属医院","text":'哈尔滨医科大学第一附属医院'},{"value":"哈尔滨医科大学第一附属医院20201203","text":'哈尔滨医科大学第一附属医院(20201203)'},{"value":"武汉市第一医院","text":'武汉市第一医院'},{"value":"江苏盐城中医","text":'江苏盐城中医'},{"value":"哈尔滨医科大学第一附属医院20201215","text":'哈尔滨医科大学第一附属医院(20201215)'},{"value":"哈尔滨医科大学第一附属医院20201221","text":'哈尔滨医科大学第一附属医院(20201221)'}];
hospArr.push({"value":"哈尔滨医科大学第一附属医院20201224","text":'哈尔滨医科大学第一附属医院(20201224)'});

var signArr = [{"value":"complet","text":'规则错误，已完成'},{"value":"uwcomplet","text":'规则错误，未完成'},{"value":"partcomp","text":'规则错误，部分完成'},{"value":"partcompcon","text":'规则错误，部分完成，需用户确认'},{"value":"partcompproame","text":'规则错误，部分完成，需修正程序'}, {"value":"partcompruleimp","text":'规则错误，部分完成，需完善规则'},{"value":"partcompdicimp","text":'规则错误，部分完成，需完善字典'},{"value":"verifycorrect","text":'规则正确，需验证'},{"value":"affirmcorrect","text":'规则正确，需用户确认'},{"value":"achievecorrect","text":'规则正确，已完成'}];

/// 页面初始化函数
function initPageDefault(){

	initDataGrid();      /// 页面DataGrid初始定义
	initBlButton();      /// 页面Button 绑定事件
	initCombobox();		 /// 页面Combobox初始定义
}

/// 页面DataGrid初始定义
function initDataGrid(){
	
	/// 文本编辑格
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	///  定义columns
	var columns=[[
		{field:'monId',title:'monId',width:50,editor:textEditor,hidden:true},
		{field:'monItmId',title:'monItmId',width:100,editor:textEditor,hidden:true},
		{field:'drug',title:'药品名称',width:400,editor:textEditor},
		{field:'remarks',title:'审核备注',width:150,editor:textEditor},
		{field:'exasignval',title:'审核标记',width:200,editor:textEditor},
		{field:'drugOutParam',title:'审核结果',width:200,editor:textEditor}
	]];
	
	///  定义datagrid
	var option = {
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {		//双击选择行编辑
           
        }
	};
	
	var fromdate = $("#fromdate").datebox('getValue');
	var todate = $("#todate").datebox('getValue');
	var sign = $HUI.combobox('#sign').getValue();
	var hosp = $HUI.combobox('#hosp').getText();
	var params = fromdate +"^"+ todate +"^"+ sign +"^"+ hosp;
	var uniturl = $URL+"?ClassName=web.DHCCKBMonLogQuery&MethodName=QueryMonData&params="+params;
	new ListComponent('monloglist', columns, uniturl, option).Init();
}

/// 页面 Button 绑定事件
function initBlButton()
{	
	///  查询
	$('#find').bind("click",query);

}

/// 页面 initCombobox 绑定事件
function initCombobox()
{
	// 院区
	$HUI.combobox("#hosp",{
		data:hospArr,
		valueField: "value", 
		textField: "text",
		editable:true,
		mode:'remote',
		onSelect:function(ret){
			query();
		}
	})
	
	// 审核标记
	$HUI.combobox("#sign",{
		data:signArr,
		valueField: "value", 
		textField: "text",
		editable:true,
		mode:'remote',
		onSelect:function(ret){
			query();
		}
	})
}

///查询
function query()
{
	var fromdate = $("#fromdate").datebox('getValue');
	var todate = $("#todate").datebox('getValue');
	var sign = $HUI.combobox('#sign').getValue();
	var hosp = $HUI.combobox('#hosp').getText();
	var params = fromdate +"^"+ todate +"^"+ sign +"^"+ hosp;
	$("#monloglist").datagrid('load',{'params':params});
}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })