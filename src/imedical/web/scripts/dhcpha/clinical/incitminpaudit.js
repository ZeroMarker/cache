
/// 麻精药品销毁登记审核
var url="dhcpha.clinical.action.csp";
var ddrStatusArray = [{"value":"N","text":'待审核'}, {"value":"Y","text":'已审核'}];
$(function(){
	
	//初始化界面默认信息
	InitDefault();
	
	//初始化咨询信息列表
	InitMainList();
	InitDetList();
	
	//初始化界面按钮事件
	InitWidListener();
})

///初始化界面默认信息
function InitDefault(){
	
	/**
	 * 申请日期
	 */
	$("#ddrStartDate").datebox("setValue", formatDate(0));
	$("#ddrEndDate").datebox("setValue", formatDate(0));
	
	/**
	 * 申请科别
	 */
	var ddrDeptCombobox = new ListCombobox("ddrDept",url+'?action=QueryConDept','');
	ddrDeptCombobox.init();
	
	//$("#ddrDept").combobox("setValue",LgCtLocID);
	
	/**
	 * 申请人员
	 */
	var ddrUserCombobox = new ListCombobox("ddrUser",url+'?action=SelUserByGrp&grpId=1','',{panelHeight:"auto"});
	ddrUserCombobox.init();
	
		
	/**
	 * 审核状态
	 */
	var ddrChkStatusCombobox = new ListCombobox("ddrChkStatus",'',ddrStatusArray,{panelHeight:"auto"});
	ddrChkStatusCombobox.init();
	
	$("#ddrChkStatus").combobox("setValue","N");
	
}

/// 界面元素监听事件
function InitWidListener(){

	$("a:contains('审核')").bind("click",audit);
	$("a:contains('查询')").bind("click",query);
}

///药品销毁主信息
function InitMainList(){
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:"ddrNo",title:'申请单号',width:120},
		{field:"ddrCDate",title:'日期',width:100},
		{field:"ddrCTime",title:'时间',width:100},
		{field:'ddrDept',title:'申请科室',width:160},
		{field:'ddrUser',title:'申请人员',width:100},
		{field:'ddrComFlag',title:'是否完成',width:80,align:'center'},
		{field:'ddrChkFlag',title:'是否核对',width:80,align:'center'},
		{field:'ddrChkDate',title:'核对日期',width:100},
		{field:'ddrChkTime',title:'核对时间',width:100},
		{field:'ddrChkUsr',title:'核对人',width:100},
		{field:'ddrID',title:'ddrID',width:80,hidden:true}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'申请单据',
		singleSelect : true,
 		onClickRow:function(rowIndex, rowData){
	 		
	 		$('#ddrDetList').datagrid({
				url:url+'?action=QueryInpNoDetList',
				queryParams:{
					ddrID : rowData.ddrID}
			});
        },
		onLoadSuccess:function(data){
			var rows = $("#ddrMainList").datagrid('getRows');
			if (rows.length != "0"){
				$('#ddrMainList').datagrid('selectRow',0);
				var rowData = $('#ddrMainList').datagrid('getSelected');
				$('#ddrDetList').datagrid({
					url:url+'?action=QueryInpNoDetList',
					queryParams:{
						ddrID : rowData.ddrID}
				});
			}
		} 
	};
		
	var ddrMainListComponent = new ListComponent('ddrMainList', columns, '', option);
	ddrMainListComponent.Init();

	/**
	 * 初始化显示横向滚动条
	 */
	//initScroll("#ddrMainList");	
}

///初始化拆包明细
function InitDetList(){
	
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'ddrInciCode',title:'代码',width:100},
		{field:'ddrInciDesc',title:'药品名称',width:260},
		{field:'ddrSpec',title:'规格',width:120},
		{field:'ddrManf',title:'产地',width:200},
		{field:'ddrQty',title:'限制数量',width:120},
		{field:'ddrUom',title:'单位',width:120},
		{field:'ddrRemark',title:'备注',width:2600}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'申请记录明细',
		//nowrap:false,
		singleSelect : true
	};
		
	var ddrDetListComponent = new ListComponent('ddrDetList', columns, '', option);
	ddrDetListComponent.Init();

	/**
	 * 初始化显示横向滚动条
	 */
	//initScroll("#ddrDetList");
}

/// 查询药品销毁明细
function query(){
	
	//1、清空datagrid 
	$('#ddrMainList').datagrid('loadData', {total:0,rows:[]}); 
	$('#ddrDetList').datagrid('loadData', {total:0,rows:[]}); 

	//2、查询
	var ddrStartDate = $('#ddrStartDate').datebox('getValue');   //起始日期
	var ddrEndDate = $('#ddrEndDate').datebox('getValue'); 	     //截止日期
	var ddrDept = $('#ddrDept').combobox('getValue');         	 //申请科室
	var ddrUser = $('#ddrUser').combobox('getValue');  	 		 //申请人员
	var ddrChkStatus = $('#ddrChkStatus').combobox('getValue');  	 //审核状态

	var ListData = ddrStartDate + "^" + ddrEndDate + "^" + ddrDept + "^" + ddrUser +"^"+ ddrChkStatus;

	$('#ddrMainList').datagrid({
		url:url+'?action=QueryInpNoList',
		queryParams:{
			param : ListData}
	});
}

/// 审核药品销毁明细
function audit(){
	
	var rowData = $("#ddrMainList").datagrid('getSelected'); //选中行
	//保存数据
	$.post(url+'?action=SetInpChkFlag',{"ddrID":rowData.ddrID, "ddrUserID":LgUserID},function(jsonString){
		var jsonddrObj = jQuery.parseJSON(jsonString);
		if (jsonddrObj.ErrorCode == "0"){
			$.messager.alert("提示:","<font style='font-size:20px;'>审核成功！</font>");
			$('#ddrMainList').datagrid('reload'); //重新加载
		}else{
			$.messager.alert("提示:","<font style='font-size:20px;'>审核错误,错误原因:</font><font style='font-size:20px;color:red;'>"+jsonddrObj.ErrorMessage+"</font>");
			return;
		}
	});
}