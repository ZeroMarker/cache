//problemspresc.js
//问题处方

var LevelArr = [{"value":"normal","text":'提示'},{"value":"tips","text":'提醒'},{"value":"warn","text":'警示'},{"value":"forbid","text":'禁止'}];

$(function(){
	
	initCombobox();	
	initMainList();
	//initDatagrid();
	//initBtn();

});


// 初始化界面控件
function initCombobox(){
	
	// 开始日期
	$HUI.datebox("#startDate").setValue(formatDate(0));
	
	/// 结束日期
	$HUI.datebox("#endDate").setValue(formatDate(0));	
	
	//科室
	$('#ctLoc').combobox({ 
		url:$URL+'?ClassName=web.DHCCKBCommonCom&MethodName=JsonLoc&HospID='+LgHospID,
		valueField: 'value',
		textField: 'text',
		mode:'remote',
		blurValidValue:true,
		onSuccess:function(data){
			var a=data;
			
		}
	})
	
	// 管理级别
	$('#manLevel').combobox({ 
		data:LevelArr,
		valueField: 'value',
		textField: 'text'		
	})
	
}

/// 初始化加载数据列表
function initMainList(){	

	//  定义columns
	var columns=[[
		{field:'edit',title:'查看',width:50,align:'center',formatter:setCellEditSymbol,hidden:false},
		{field:'prescNo',title:'处方号',width:120,align:'center'},
		{field:'stDate',title:'开方日期',width:120,align:'center'},			
		{field:'patname',title:'患者姓名',width:120,align:'center'},		
		{field:'patsex',title:'性别',width:80,align:'center'},
		{field:'patage',title:'出生日期',width:100},
		{field:'patloc',title:'科室',align:'center',width:120},
		{field:'patdoc',title:'医生',align:'center',width:100},
		{field:'patdis',title:'诊断',align:'center',width:200},
		{field:'manlevel',title:'管理级别',width:100,align:'center'},		
		{field:'warnmsg',title:'预警消息',width:400},
		{field:'reason',title:'强制审核原因',width:200},
		{field:'cmrowId',title:'日志id',hidden:true}
	]];
	
	var option={	
		columns:columns,
		bordr:false,	
		fitColumns:false,
		singleSelect:true,	
		striped: true, 	
		pagination:true,
		rownumbers:true,
		loadMsg: '正在加载信息...',
		pageSize:50,
		pageList:[50,100,150],		
 		onClickRow:function(rowIndex,rowData){}, 
		onDblClickRow: function (rowIndex, rowData) {			
		}       
	}        
			
	var uniturl = ""
	new ListComponent('main', columns, uniturl, option).Init();
}


///设置查看连接
function setCellEditSymbol(value, rowData, rowIndex){
				
	return "<a href='#' onclick=\"showEditWin('"+rowData.cmrowId+"')\"><img src='../scripts/dhcadvEvt/images/adv_sel_8.png' border=0/></a>";

}

/// 查看详情
function showEditWin(cmRowID){	

	var linkUrl ="dhcckb.problemdetail.csp?cmRowID=" +cmRowID;

	commonShowWin({
		url: linkUrl,
		title: $g("预警消息明细"),
		width: document.body.offsetWidth - 100, //window.screen.availWidth - 30,
		height: window.screen.availHeight - 50
	})	
}


/// 查询
function query(){

	var startDate=$("#startDate").datebox('getValue');  //起始时间
	var endDate=$("#endDate").datebox('getValue');		//结束时间
	var manLevel = $HUI.combobox("#manLevel").getValue();// 管理级别
	var ctLoc = $HUI.combobox("#ctLoc").getText();	// 科室
	
	var params = startDate +"^"+ endDate +"^"+ manLevel +"^"+ ctLoc;
	var uniturl = $URL+"?ClassName=web.DHCCKBProblemsPresc&MethodName=QueryProblemsPresc&params="+params;
	$("#main").datagrid("options").url = uniturl;
	$("#main").datagrid("load",{"params":params}); 


}

/// 重置
function reset(){
	
	$HUI.datebox("#startDate").setValue(GetCurSystemDate(0));  // 开始日期
	$HUI.datebox("#endDate").setValue(GetCurSystemDate(0));	  // 结束日期	
	$HUI.combobox("#manLevel").setValue("");			  /// 管理级别
	$HUI.combobox("#ctLoc").setValue("");			  // 科室
	
	query();
}