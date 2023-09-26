//名称	DHCPEIllnessStatistic.hisui.js
//功能	疾病统计
//创建	2020.12.11
//创建人  ln

var ScreenWidth = $(window).width();
var ScreenHeight = $(window).height();

var First = "Y";

$(function() {
	InitCombobox();
	InitData();
	
	$("#BFind").click(function() {  // 分析查询
		BFind_click();
    });
	
	$("#CommonIllness").checkbox({

        onCheckChange:function(e,value){
		    SearchIllDesc(); 
	        
        }
    }); 
	
});

function InitCombobox() {
	
	//性别
	var SexDRObj = $HUI.combobox("#SexDR",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindSex&ResultSetType=array",
		valueField:'id',
		textField:'sex',
		panelHeight:'130',
	});
	
	//婚姻
	var MarriedDRObj = $HUI.combobox("#MarriedDR",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindMarried&ResultSetType=array",
		valueField:'id',
		textField:'married',
		panelHeight:'130',
	});
	
	// 合同
	$HUI.combobox("#ContractID", {
		url:$URL+"?ClassName=web.DHCPE.Contract&QueryName=SerchContract&ResultSetType=array",
		valueField:"TID",
		textField:"TName",
		panelHeight:"auto",
		allowNull:true,
		editable:true,
		onSelect:function(record){
			var GBIDesc = $("#GBIDesc").val();
			$("#Groups").datagrid("load", {ClassName:"web.DHCPE.Report.GroupCollect",QueryName:"GADMList",GBIDesc:GBIDesc,ContractID:record.TID});
		},
		onChange:function(newValue, oldValue) {
			if (newValue =="" || newValue == undefined || newValue == "undefined" || newValue == null || newValue =="null" || newValue == "NULL") {
				$("#ContractID").combobox("setValue", "");
				var GBIDesc = $("#GBIDesc").val();
				$("#Groups").datagrid("load", {ClassName:"web.DHCPE.Report.GroupCollect",QueryName:"GADMList",GBIDesc:GBIDesc,ContractID:""});
			} 
		}
		
	});
}

function InitData() {
	InitIllnessData();
	InitGroupsListData();
}

// 团体列表
function InitGroupsListData() {
	$HUI.datagrid("#Groups", {
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.Report.GroupCollect",
			QueryName:"GADMList",
			GBIDesc:"",
			ContractID:""
		},
		collapsible: true, //收起表格的内容
		lines:true,
		striped:true, // 条纹化
		rownumbers:true,
		border:false,
		fit:true,
		fitColumns:true,
		animate:true,
		//pagination:true,   // 树形表格 不能分页
		//pageSize:25,
		//pageList:[10,25,50,100],	
		singleSelect: false,
		checkOnSelect: true, //如果为false, 当用户仅在点击该复选框的时候才会被选中或取消
		selectOnCheck: true,
		columns:[[
			{field:'TGRowId', title:'TGRowId', hidden:true},
			{field:'TGDesc', title:'TGDesc', hidden:true},
			{field:'TAdmDate', title:'TAdmDate', hidden:true},
			
			{field:'GroupsID', title:'选择', align:'center', checkbox:true},
			{field:'GroupsDesc', title:'团体名称', width:8, formatter: function(value, rowData, rowIndex) {
				var title="";
				if (rowData.TGRowId == ("ALLI")) {
					title="全部个人"
				} else if (rowData.TGRowId == ("ALLG")) {
					title="全部团体"
				} else {
					title="到达日期：" + rowData.TAdmDate
				}
				return "<a id='GroupsDesc_" + rowData.TGRowId + "' href='#' title='"
						+ title
						+ "' class='hisui-tooltip' data-options='position:\"right\",showDelay:50' style='text-decoration: none;color: black;'>"
						+ rowData.TGDesc + "</a>";
				}
			}
		]],	
		onClickRow: function (rowIndex, rowData) {  // 选择行事件
		},
		onDblClickRow: function (rowIndex, rowData) {  // 双击行事件
		},
		onLoadSuccess:function(data){
		}
	});
}

// 疾病列表
function InitIllnessData() {
	$HUI.datagrid("#IllDescs", {
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.HISUICommon",
			QueryName:"FindIllness",
			CommonIllness:"N",
			Desc:""
		},
		collapsible: true, //收起表格的内容
		lines:true,
		striped:true, // 条纹化
		rownumbers:true,
		border:false,
		fit:true,
		fitColumns:true,
		animate:true,
		//pagination:true,   // 树形表格 不能分页
		//pageSize:25,
		//pageList:[10,25,50,100],	
		singleSelect: false,
		checkOnSelect: true, //如果为false, 当用户仅在点击该复选框的时候才会被选中或取消
		selectOnCheck: true,
		columns:[[
			{field:'id', title:'RowId', hidden:true},
			{field:'Code', title:'Code', hidden:true},
            {field:'desc', title:'desc', hidden:true},
			
			{field:'IllnessID', title:'选择', align:'center', checkbox:true},
			{field:'IllnessDesc', title:'疾病描述', width:16, formatter: function(value, rowData, rowIndex) {
                var title = "代码：" + rowData.Code;				
				return "<a id='IllnessDesc_" + rowData.id + "' href='#' title='"	
                        + title				
						+ "' class='hisui-tooltip' data-options='position:\"right\",showDelay:50' style='text-decoration: none;color: black;'>"
						+ rowData.desc + "</a>";
				}
			}
			
		]],	
		onClickRow: function (rowIndex, rowData) {  // 选择行事件
		},
		onDblClickRow: function (rowIndex, rowData) {  // 双击行事件
		},
		onLoadSuccess:function(data){
		}
	});
}

// 疾病统计
function BFind_click(){
	var BeginDate = "", EndDate = "", SexDR = "", MarriedDR="";
	var BeginDate = $("#BeginDate").datebox('getValue');
	var EndDate = $("#EndDate").datebox('getValue');
	
	//var AgeRange = $("#AgeFrom").val() + "-" + $("#AgeTo").val();
	var SexDR = $("#SexDR").combobox('getValue');
	if (SexDR==undefined) {var SexDR="";}
	var MarriedDR = $("#MarriedDR").combobox('getValue');
	if (MarriedDR==undefined) {var MarriedDR="";}
	
	var GADMList = "";  // 团体ID DHC_PE_GADM  $ 分割
	var GroupsRows = $("#Groups").datagrid("getChecked");  //获取的是数组，多行数据
	for(var i = 0; i < GroupsRows.length; i++) {
		if (GADMList == "") GADMList = GroupsRows[i].TGRowId;
		else GADMList = GADMList + "^" + GroupsRows[i].TGRowId;
	}
	
	var IllnessList = "";   // 疾病   $ 分割
	var IllnessRows = $("#IllDescs").datagrid("getChecked");  //获取的是数组，多行数据
	for(var i = 0; i < IllnessRows.length; i++) {
		if (IllnessList == "") IllnessList = IllnessRows[i].id;
		else IllnessList = IllnessList + "^" + IllnessRows[i].id;
	}	
	if (IllnessList == "") {
		$.messager.alert("提示", "请选择疾病再查询！", "info"); 
		// $.messager.popover({msg:"请选择体征再查询！", type:"alert", timeout: 3000, showType:"slide"});
		return false;
	}
	
    var ret=tkMakeServerCall("web.DHCPE.Statistic.IllnessStatistic","SetTempIllnessGlobal",BeginDate, EndDate, MarriedDR, SexDR, IllnessList, GADMList,session['LOGON.CTLOCID'],session['LOGON.USERID'])
	var src="&BeginDate="+BeginDate+"&EndDate="+EndDate+"&USERID="+session['LOGON.USERID'];
	
	$("#ReportFile").attr("src", "dhccpmrunqianreport.csp?reportName=DHCPEIllnessStatistic.raq" + src);
	
}

// 团体查询
function SearchGBIDesc() {
	var ContractID = $("#ContractID").combobox("getValue");
	var GBIDesc = $("#GBIDesc").val();
	
	$("#Groups").datagrid("load", {ClassName:"web.DHCPE.Report.GroupCollect",QueryName:"GADMList",GBIDesc:GBIDesc,ContractID:ContractID});
}

// 疾病查询
function SearchIllDesc() {
	var IllDesc = $("#IllDesc").val();
	var iCommonIllness="N";
	var CommonIllness=$("#CommonIllness").checkbox('getValue');
	if (CommonIllness) {iCommonIllness="Y";} 
	$("#IllDescs").datagrid("load", {ClassName:"web.DHCPE.HISUICommon",QueryName:"FindIllness",Desc:IllDesc,CommonIllness:iCommonIllness});
}
