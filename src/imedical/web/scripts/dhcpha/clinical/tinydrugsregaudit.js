
var url="dhcpha.clinical.action.csp";
var tdrStatusArray = [{"value":"N","text":'待审核'}, {"value":"Y","text":'已审核'}];
$(function(){
	
	//初始化界面默认信息
	InitTinyDrugRegDefault();
	
	//初始化咨询信息列表
	InitTinyDrugRegMainList();
	InitTinyDrugRegDetList();
	
	//初始化界面按钮事件
	InitTinyWidgetListener();
})

///初始化界面默认信息
function InitTinyDrugRegDefault(){
	
	/**
	 * 拆零日期
	 */
	$("#tdrStartDate").datebox("setValue", formatDate(0));
	$("#tdrEndDate").datebox("setValue", formatDate(0));
	
	/**
	 * 拆零科别
	 */
	var tdrDeptCombobox = new ListCombobox("tdrDept",url+'?action=QueryConDept','');
	tdrDeptCombobox.init();
	
	$("#tdrDept").combobox("setValue",LgCtLocID);
	
	/**
	 * 拆零人员
	 */
	var tdrUserCombobox = new ListCombobox("tdrUser",url+'?action=GetDeptUser&LgLocID='+LgCtLocID,'',{});
	tdrUserCombobox.init();
	
		
	/**
	 * 审核状态
	 */
	var tdrChkStatusCombobox = new ListCombobox("tdrChkStatus",'',tdrStatusArray,{panelHeight:"auto"});
	tdrChkStatusCombobox.init();
	
	$("#tdrChkStatus").combobox("setValue","N");
	
}

/// 界面元素监听事件
function InitTinyWidgetListener(){

	$("a:contains('审核')").bind("click",anditTinyDrugsRegDet);
	$("a:contains('查询')").bind("click",queryTinyDrugsRegDet);
	$("#tdrInciDesc").bind("keydown",function(event){
        if(event.keyCode == "13"){
			if ($("#tdrInciDesc").val() == ""){return;}
			var mydiv = new UIDivWindow($("#tdrInciDesc"), $("#tdrInciDesc").val(), setCurrEditCellVal);
            mydiv.init();
        }
    });
}
/// 给当前编辑栏赋值
function setCurrEditCellVal(rowObj){
	
	if (rowObj == null){
		$("#tdrInciDesc").focus().select();  ///设置焦点 并选中内容
		return;
	}
	///药品名称	
	$("#tdrInciDesc").val(rowObj.InciDesc);
	///药品名称ID	
	$("#tdrInci").val(rowObj.InciDr);
}
///药品拆零主信息
function InitTinyDrugRegMainList(){
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:"tdrNo",title:'拆零单号',width:120},
		{field:"tdrCDate",title:'日期',width:100},
		{field:"tdrCTime",title:'时间',width:100},
		{field:'tdrDept',title:'拆零科室',width:160},
		{field:'tdrUser',title:'拆零人',width:100},
		{field:'tdrPurDesc',title:'拆零目的',width:100},
		{field:'tdrComFlag',title:'是否完成',width:80,align:'center'},
		{field:'tdrChkFlag',title:'是否核对',width:80,align:'center'},
		{field:'tdrChkDate',title:'核对日期',width:100},
		{field:'tdrChkTime',title:'核对时间',width:100},
		{field:'tdrChkUsr',title:'核对人',width:100},
		{field:'tdrID',title:'tdrID',width:80,hidden:true}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'拆零单据',
		singleSelect : true,
 		onClickRow:function(rowIndex, rowData){
	 		
	 		$('#tdrDetList').datagrid({
				url:url+'?action=QueryTdrNoDetList',
				queryParams:{
					tdrID : rowData.tdrID}
			});
        },
		onLoadSuccess:function(data){
			var rows = $("#tdrMainList").datagrid('getRows');
			if (rows.length != "0"){
				$('#tdrMainList').datagrid('selectRow',0);
				var rowData = $('#tdrMainList').datagrid('getSelected');
				$('#tdrDetList').datagrid({
					url:url+'?action=QueryTdrNoDetList',
					queryParams:{
						tdrID : rowData.tdrID}
				});
			}
		} 
	};
		
	var tdrMainListComponent = new ListComponent('tdrMainList', columns, '', option);
	tdrMainListComponent.Init();

	/**
	 * 初始化显示横向滚动条
	 */
	//initScroll("#tdrMainList");	
}

///初始化拆包明细
function InitTinyDrugRegDetList(){
	
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'tdrInciCode',title:'代码',width:100},
		{field:'tdrInciDesc',title:'药品名称',width:260},
		{field:'tdrSpec',title:'规格',width:120},
		{field:'tdrManf',title:'产地',width:200},
		{field:'tdrBatNo',title:'批号',width:120},
		{field:'tdrExpDate',title:'效期',width:145},
		{field:'tdrQty',title:'拆零数量',width:120},
		{field:'tdrMacSitNum',title:'药位号',width:100},
		{field:'tdrUom',title:'单位',width:120}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'拆零明细',
		//nowrap:false,
		singleSelect : true
	};
		
	var tdrDetListComponent = new ListComponent('tdrDetList', columns, '', option);
	tdrDetListComponent.Init();

	/**
	 * 初始化显示横向滚动条
	 */
	//initScroll("#tdrDetList");
}

/// 查询药品拆零明细
function queryTinyDrugsRegDet(){
	
	//1、清空datagrid 
	$('#tdrMainList').datagrid('loadData', {total:0,rows:[]}); 
	$('#tdrDetList').datagrid('loadData', {total:0,rows:[]}); 

	//2、查询
	var tdrStartDate = $('#tdrStartDate').datebox('getValue');   //起始日期
	var tdrEndDate = $('#tdrEndDate').datebox('getValue'); 	     //截止日期
	var tdrDept = $('#tdrDept').combobox('getValue');         	 //拆零科室
	var tdrUser = $('#tdrUser').combobox('getValue');  	 		 //拆零人员
	var tdrChkStatus = $('#tdrChkStatus').combobox('getValue');  	 //审核状态
    var Incidr = $('#tdrInci').val();                                //药品ID
	var ListData = tdrStartDate + "^" + tdrEndDate + "^" + tdrDept + "^" + tdrUser +"^"+ tdrChkStatus+"^"+Incidr;

	$('#tdrMainList').datagrid({
		url:url+'?action=QueryTdrNo',
		queryParams:{
			param : ListData}
	});
}

/// 审核药品拆零明细
function anditTinyDrugsRegDet(){
	
	var rowData = $("#tdrMainList").datagrid('getSelected'); //选中行
	//保存数据
	$.post(url+'?action=SetTindyChkFlag',{"tdrID":rowData.tdrID, "tdrUserID":LgUserID},function(jsonString){
		var jsonTdrObj = jQuery.parseJSON(jsonString);
		if (jsonTdrObj.ErrorCode == "0"){
			$.messager.alert("提示:","<font style='font-size:20px;'>审核成功！</font>");
			$('#tdrMainList').datagrid('reload'); //重新加载
		}else{
			$.messager.alert("提示:","<font style='font-size:20px;'>审核错误,错误原因:</font><font style='font-size:20px;color:red;'>"+jsonTdrObj.ErrorMessage+"</font>");
			return;
		}
	});
}