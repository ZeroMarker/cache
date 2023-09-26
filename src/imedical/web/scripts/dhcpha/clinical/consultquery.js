
/// Creator:    bianshuai
/// CreateDate: 2015-01-29
/// Descript:   咨询回复列表

var url="dhcpha.clinical.action.csp";
var consStatusArr = [{"value":"","text":'全部'}, {"value":"Y","text":'完成'}, {"value":"N","text":'未完成'}];
$(function(){
	
	$("#startDate").datebox("setValue", formatDate(-2));  //Init起始日期
	$("#endDate").datebox("setValue", formatDate(0));  	  //Init结束日期
	
	$("a:contains('查询')").bind("click",queryConsultDetail);
	
	/**
	 * 咨询记录状态
	 */
	var consStatusCombobox = new ListCombobox("consStatus",'',consStatusArr,{panelHeight:"auto"});
	consStatusCombobox.init();
	
	/**
	 * 咨询部门
	 */
	 $('#consDept').combobox({
		mode:'remote',		
		onShowPanel:function(){ //qunianpeng 2017/8/14 支持拼音码和汉字
			$('#consDept').combobox('reload',url+'?action=GetAllLocNewVersion&hospId='+LgHospID+'  ')
			//$('#dept').combobox('reload',url+'?action=SelAllLoc&HospID='+HospID)
		}
	}); 
	//var conDeptCombobox = new ListCombobox("consDept",url+'?action=QueryConDept','',{});
	//conDeptCombobox.init();
	
	///回车事件 wangxuejian   2016/09/19
	$('#drug').bind('keypress',function(event){
		if(event.keyCode == "13"){
			var unitUrl = url+'?action=QueryArcItmDetail&Input='+$('#drug').val(); 
			//var unitUrl =  "&Input="+$('#drug').val();
			/// 调用医嘱项列表窗口
			new ListComponentWin($('#drug'), "", "600px", "" , unitUrl, ArcColumns, setCurrEditRowCellVal).init();
		}
	})
	
	
	InitConsultList(); //初始化咨询信息列表

})

// wangxuejian 2016-09-19
ArcColumns = [[
	    {field:'itmDesc',title:'医嘱项名称',width:220},
	    {field:'itmCode',title:'医嘱项代码',width:100},
	    {field:'itmPrice',title:'单价',width:100},
		{field:'itmID',title:'itmID',width:80}
	]];	

///查询按钮医嘱项响应函数
function setCurrEditRowCellVal(rowObj){
	if (rowObj == null){
		$('#drug').focus().select();  ///设置焦点 并选中内容
		return;
	}
	$('#drug').val(rowObj.itmDesc);  /// 医嘱项
}
//初始化病人列表
function InitConsultList()
{
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'consultID',title:'consultID',width:80,hidden:true},
		{field:'finiFlag',title:'完成标志',width:50,align:'center',formatter:SetCellUrl},
		{field:'consDate',title:'咨询日期',width:100},
		{field:'consTime',title:'咨询时间',width:90},
		{field:'quesType',title:'问题类型',width:120},
		{field:'consIden',title:'咨询身份',width:100},
		{field:'consDept',title:'咨询部门',width:160},
		{field:'consName',title:'咨询人',width:100},
		{field:'consTele',title:'联系电话',width:100},
		{field:'consDesc',title:'问题描述',width:500},
		{field:'ansCount',title:'回复次数',width:100},
		{field:'LkDetial',title:'操作',width:100,align:'center',formatter:SetCellOpUrl}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'咨询问题列表',
                singleSelect : true
		};
	var conDetListComponent = new ListComponent('conDetList', columns, '', option);
	conDetListComponent.Init();
	
	initScroll("#conDetList");//初始化显示横向滚动条
        $('#conDetList').datagrid('loadData', {total:0,rows:[]});
}

 /**
  * 新建咨询窗口
  */
function newCreateConsultWin(consultID){
	
	var option = {
		minimizable : false,
		maximizable : true,
		collapsible:true
		};
	var newConWindowUX = new WindowUX('列表', 'newConWin', '930', '550', option);
	newConWindowUX.Init();
	
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.replyconsult.csp?consultID='+consultID+'"></iframe>';
	$('#newConWin').html(iframe);
}

 /**
  * 查询咨询数据
  */
function queryConsultDetail(){
	
	//1、清空datagrid 
	$('#conDetList').datagrid('loadData', {total:0,rows:[]});
	
	//2、查询
	var startDate=$('#startDate').datebox('getValue');   //起始日期
	var endDate=$('#endDate').datebox('getValue');       //截止日期
	
	var consStatus=$('#consStatus').combobox('getValue');    //问题类型
	var consDept=$('#consDept').combobox('getValue');        //咨询部门
	var params=startDate +"^"+ endDate +"^^^" + consStatus +"^"+ consDept+"^^"+LgHospID;
	
	$('#conDetList').datagrid({
		url:url + "?action=QueryPhConsult",	
		queryParams:{
			params:params}
	});
}

//操作
function SetCellUrl(value, rowData, rowIndex)
{
	var html = "";
	if (value == "Y"){
		html = "<span style='margin:0px 5px;font-weight:bold;color:red;'>完成</span>";		
	}else{
		html = "<span style='margin:0px 5px;font-weight:bold;color:green;'>No</span>";
		}
    return html;
}

//操作
function SetCellOpUrl(value, rowData, rowIndex)
{
	var html = "";
	if (rowData.finiFlag == "Y"){
		html = "<a href='#' onclick='newCreateConsultWin("+rowData.consultID+")' style='margin:0px 5px;font-weight:bold;color:red;text-decoration:none;'>查看回复列表</a>";
		
	}else{
		html = "<a href='#' onclick='newCreateConsultWin("+rowData.consultID+")'>查看回复列表</a>";
		}
    return html;
}

