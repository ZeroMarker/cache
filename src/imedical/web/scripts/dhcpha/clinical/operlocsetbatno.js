/// Creator: 	bianshuai
/// CreateDate: 2016-04-17
/// Descript:	修改发药

var editRow="";  //当前编辑行号
var phac = "";   //发药表ID
var url="dhcpha.clinical.action.csp";
var dspScArr = [{"value":"10","text":'单据'}, {"value":"20","text":'全天'}];
$(function(){

	phac=getParam("phac");
	
	//初始化界面默认信息
	InitDefault();
	
	//初始化咨询信息列表
	InitMainList();
	
	//初始化界面按钮事件
	InitWidListener();
})

///初始化界面默认信息
function InitDefault(){
	
}

/// 界面元素监听事件
function InitWidListener(){

	//$("a:contains('查询')").bind("click",queryDispDetail);
}

///药品拆零主信息
function InitMainList(){

	// 文本编辑格
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	//设置其为可编辑
	var tdrRanEditor={
		type: 'combobox',//设置编辑格式
		options: {
			data:dspScArr,
			valueField: "value", 
			textField: "text",
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				var ed=$("#tdrMList").datagrid('getEditor',{index:editRow,field:'dspSCode'});
				$(ed.target).val(option.value);  //设置范围代码
				var ed=$("#tdrMList").datagrid('getEditor',{index:editRow,field:'dspSDesc'});
				$(ed.target).combobox('setValue', option.text);  //设置范围代码
			}
		}
	}
	
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:"phac",title:'phac',width:100},
		{field:"operRoomDesc",title:'房间号',width:100},
		{field:"inci",title:'inci',width:100},
		{field:"inciDesc",title:'药品',width:260},
		{field:'dspBatNo',title:'批号',width:120,editor:textEditor},
		{field:'dspQty',title:'数量',width:100,editor:textEditor},
		{field:'dspUom',title:'单位',width:100},
		{field:'dspSCode',title:'dspSCode',width:100,hidden:true,editor:textEditor},
		{field:'dspSDesc',title:'修改范围',width:100,editor:tdrRanEditor},
		{field:'dspEdit',title:'编辑',width:100,align:'center',formatter:SetCellOpUrl}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'修改批号',
		singleSelect : true,
 		onClickRow:function(rowIndex, rowData){
 		},
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if ((editRow != "")||(editRow == "0")) { 
                $("#tdrMList").datagrid('endEdit', editRow); 
            } 
            $("#tdrMList").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        }
	};
		
	var tdrMainListComponent = new ListComponent('tdrMList', columns, '', option);
	tdrMainListComponent.Init();

	/**
	 * 初始化显示横向滚动条
	 */
	//initScroll("#tdrMList");
	
	/// 拆零药品明细
	 queryDispDetail();
}

/// 查询发药明细
function queryDispDetail(){
	
	$('#tdrMList').datagrid({
		url:url+'?action=QueryDspDetList',
		queryParams:{
			phac : phac}
	});
}

/// 修改发药批次
function modDispDetBat(rowIndex){
	
    if ((rowIndex != "")||(rowIndex == "0")) { 
        $("#tdrMList").datagrid('endEdit', rowIndex); 
    } 
    
    var rowData = $('#tdrMList').datagrid('getData').rows[rowIndex];
    var phac = rowData.phac;  		   ///发药表ID
    var inci = rowData.inci;           ///库存项ID
    var roomNum = rowData.roomNum;     ///房间号
	var dspBatNo = rowData.dspBatNo;   ///批号
	var dspQty = rowData.dspQty;       ///数量
	var dspSCode = rowData.dspSCode;   ///范围
	var param = inci +"^"+ dspBatNo +"^"+ dspQty +"^"+ dspSCode +"^"+ roomNum;

	$.post(url+'?action=modDispDetBat',{"phac":phac, "param":param},function(jsonString){
		var jsonObj = jQuery.parseJSON(jsonString);
		if (jsonObj.ErrorCode == 0){
			$.messager.alert("提示:","修改成功！");
			queryDispDetail();
		}else{
			$.messager.alert("提示:","修改失败,错误原因：" + jsonObj.ErrorMessage);
		}
	});
}

/// 编辑
function SetCellOpUrl(value, rowData, rowIndex)
{
	var html = "<a href='#' onclick='modDispDetBat("+rowIndex+")'>修改数据</a>";
    return html;
}
