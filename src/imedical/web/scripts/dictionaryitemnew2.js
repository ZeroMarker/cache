<!--js dictionaryitemnew2.js-->
/*
 * 通用字典项目维护
 * FileName: dictionaryitemnew2.js
 * zjb 2022-08-16
 */
<!--入口函数-->
var ChoDicCode="";
var TreeSehKey="";
var ChooTreeID=0; //选中tree的id，为了刷新tree后再次默认选中之前选的
var searchDicListKey=""
$(function() {
	setPageLayout();
});
function setPageLayout() {
	
	
	var tableName = "User.INSUTarContrast";
	var defHospId = 2;//
	$("#hospital").combobox({
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBL.BDP.BDPMappingHOSP&QueryName=GetHospDataForCombo&ResultSetType=array&tablename=' + tableName,
		method: 'GET',
		valueField: 'HOSPRowId',
		textField: 'HOSPDesc',
		editable: false,
		blurValidValue: true,
		onLoadSuccess: function(data) {
			$(this).combobox('select', defHospId);
		},
		onChange: function(newValue, oldValue) {
			loadDicTree(TreeSehKey);
		}
	});
	//initdicconfigCombo();
	iniTreeGrid();
	
	
	//SetDicInfoItem("SYS","");
	DeleteDic();
	UpdateData();
	ClearData();
	
	$("#searchTree").searchbox({
		searcher: function(value) {
			TreeSehKey=value;
			loadDicTree(value);
		}
	});
	$("#searchDicList").searchbox({
		searcher: function(value) {
			searchDicListKey=value;
			SetDicInfoItem(ChoDicCode, value);
		}
	});
	//有效标记
	$HUI.combobox("#ActFlag", {
		panelHeight: 150,
		url: $URL,
		editable: false,
		valueField: 'DicCode',
		textField: 'DicDesc',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.CFG.COM.DictionaryCtl";
			param.QueryName = "QueryDicDataInfo";
			param.Type = "ActFlag";
			param.KeyCode="";
			param.ResultSetType = 'array';
			return true;
		},
		onLoadSuccess: function (data) {
			/* if (data.length > 1) {
				$(this).combobox("select", data[0].DicCode);
			} */
		},
		onChange:function(val){
			
		}
	});
	//$(".tree-expanded-hover").disabled(false);
	///功能说明：导入字典信息
	$('#ImportBtn').click(function() {
		var UserDr = "1";
		var GlobalDataFlg = "0"; //是否保存到临时global的标志 1 保存到临时global 0 保存到表中(必须有类名和方法名)
		var ClassName = "BILL.CFG.COM.DictionaryCtl"; //导入处理类名
		var MethodName = "ImportDicdataByExcel"; //导入处理方法名
		var ExtStrPam = ""; //备用参数()
		//Insuqc_ExcelTool.ExcelImport(ClassName,MethodName,"0",ExtStrPam,UserDr,2,SetDicInfoItem());
		ExcelImport(GlobalDataFlg, ClassName, MethodName, ExtStrPam,SetDicInfoItem);		
	});
}

function iniTreeGrid(){
	$HUI.tree("#SYSTree", {
		/* idField:'Rowid',
		rownumbers:true,
    	treeField:'DicCode',
		onDblClickRow:function(index,row){
			if(row.TreeStatus=="0"){
				if(row.state == "closed"){
					$(this).treegrid('expand',index);
				}else{
					$(this).treegrid('collapse',index);
				}
			}
		},
		fit: true,
		border: false,
		singleSelect: true,
		//fitColumns: true,
		pagination: true,
		pageList:[50,100],
		pageSize: 50,
		columns: [[
			{title: '字典类型', field: 'DicCode',
			formatter:function(val,row,index){
				var rtn = row.TreeStatus=="0"?row.DicCode:row.DicCodeD;
				
				return rtn;	
			}
			},
			{title: '字典描述', field: 'DicDescD', width: 150,
			 formatter:function(val,row,index){
				var rtn = row.TreeStatus=="0"?row.DicDesc:row.DicDescD;
				
				return rtn;	
			}
			},
		]], */
		lines:true,
		animate: true,
		onBeforeCollapse:function(node){//节点折叠前触发，返回 false 则取消折叠动作。
            //if(node.type==0){
               return false;//不让折叠
            //}
        },
		onLoadSuccess: function(data) {
				$("#SYSTree li:eq("+ChooTreeID+")").find("div").addClass("tree-node-selected");   //设置一个节点高亮  
           		var n = $("#SYSTree").tree("getSelected");  
           		if(n!=null){  
                $("#SYSTree").tree("select",n.target);    //相当于默认点击了一下节点，执行onSelect方法  
           } 
		},
		onClick: function (data) {
			//$(this).tree("toggle", data.target);
		},
		onSelect: function(data) {
			ChooTreeID=data.id-1;
			ChoDicCode=data.attributes.DicCode;
			SetDicInfoItem(data.attributes.DicCode);
			
		},
		onLoadError:function(a){
			//alert(2)
		}
	});
}
function loadDicTree(TreeKey){
	
	$.cm({
		ClassName:"BILL.CFG.COM.DictionaryCtl",
		QueryName:"QueryDetComboxInfo",
		KeyCode:TreeKey,
		hospDr:  getValueById("hospital"),
		rows:999999
	},function(jsonData){	
	/* 	var rows = 0;
		for (i=0;i<jsonData.rows.length;i++){
			if(jsonData.rows[i].TreeStatus == "0"){
				jsonData.rows[i]['state']='closed';
				rows++;
			}
		};
		jsonData.total = rows;
		$('#SYSTree').treegrid('loadData',jsonData); */
		//转换数据成tree结构
		var CharData=[];
		var ChildNum=0;
		for (i=0;i<jsonData.rows.length;i++) 
		{
			var objData={};
			if(jsonData.rows[i].DicCode == "SYS"){
				objData.id=i+1;
				objData.text=jsonData.rows[i].DicDesc+"("+jsonData.rows[i].DicNum+")";
				objData.state='open';//closed
				objData.TreeFlo='0';//父级
				objData.children=[];
				objData.attributes=jsonData.rows[i];
				CharData.push(objData);
				ChildNum=ChildNum+1;
				
			}
			else
			{
				objData.id=i+1;
				objData.TreeFlo='1';//子级
				objData.text=jsonData.rows[i].DicDesc+"("+jsonData.rows[i].DicNum+")";
				objData.attributes=jsonData.rows[i];
				//objData.state='closed';
				CharData[ChildNum-1]['children'].push(objData);
			}
		}
		//tree赋值
		$('#SYSTree').tree({ data: CharData });
	});
	
	//var treesel=$("#SYSTree").parents();
	//$("#SYSTree").tree('select',treesel);
}

function DeleteDic() {
	$('#DeleteBtn').click(function() {
		removeDic();
	});
}
function UpdateData() {
	$('#UpdateBtn').click(function() {
		updateData();
	});
}
function ClearData() {
	$('#clearBtn').click(function() {
		$('#DicCode').val("");
		$('#DicDesc').val("");
		$('#DefaultValue').val("");
		$("#StartDate").datebox("setValue", "");
		$("#EndDate").datebox("setValue", "");
		$('#EndDate').val("");
		//$('#Creator').val("");
		$('#DicMemo').val("");
		$('#DataSrcFilterMode').val("");	//数据源检索模式
		$('#DataSrcTableProperty').val("");	//数据源表名及字段名
		$('#DicList').datagrid('unselectAll');	//清除选择
	});
}
//业务类型下拉框
//业务类型下拉框
function initdicconfigCombo() {
	$HUI.combobox("#DicType", {
		valueField: 'DicCode',
		textField: 'DicDesc',
		url: $URL,
		onBeforeLoad: function(param) {
			param.ClassName = "BILL.CFG.COM.DictionaryCtl";
			param.QueryName = 'QueryDetComboxInfo';

			param.ResultSetType = 'Array';
			$("#DicType").combobox('setValue', "SYS");
		},
		onChange: function() {
			SetDicInfoItem();
			$('#DicCode').val("");
			$('#DicDesc').val("");
			$('#DefaultValue').val("");
			$("#StartDate").datebox("setValue", "");
			$('#EndDate').datebox("setValue", "");
			//$('#Creator').val("");
			$('#DicMemo').val("");
			$('#DataSrcFilterMode').val("");	//数据源检索模式
			$('#DataSrcTableProperty').val("");	//数据源表名及字段名
		}

	})

};
//字典明细信息列表
function SetDicInfoItem(DicCode,KeyCode) {
	//var DicType = $('#DicType').combobox('getValue');
	$('#DicList').datagrid({
		pagination: true,
		// 分页工具栏
		pageSize: 10,
		pageList: [10,20,50,100],
		singleSelect: true,
		striped: false,	// 显示斑马线效果
		fitColumns:false,
		border:false,
		//height: 300,
		rownumbers: true,
		fit: true,
		url: $URL,
		queryParams: {
			ClassName: "BILL.CFG.COM.DictionaryCtl",
			QueryName: "QueryDicDataInfo",
			KeyCode:KeyCode,
			Type: DicCode
		},
		columns: [[{
			field: 'ID',
			title: 'ID',
			hidden: true
		},
		{
			field: 'DicType',
			title: '字典类型',
			width: 150
		},
		{
			field: 'DicCode',
			title: '字典编码',
			width: 150
		},
		{
			field: 'DicDesc',
			title: '字典描述',
			width: 150
		},
		{
			field: 'DefaultValue',
			title: '默认值',
			width: 150,
			showTip:true
		},
		{
			field: 'ActFlag',
			title: '有效标志',
			width: 100,
			formatter: function (value, row, index) {
					var rtn = tkMakeServerCall("BILL.CFG.COM.DictionaryCtl","GetDicInfoByTypeCode","ActFlag", value, getValueById("hospital"),"4");
					return (value == "Y") ? rtn : "<font color='#f16e57'>" + rtn +"</font>";
			}
		},
		{
			field: 'StartDate',
			title: '开始日期',
			width: 100
		},
		{
			field: 'DateTo',
			title: '结束日期',
			width: 100
		},
		{
			field: 'Creator',
			title: '创建人',
			width: 100
		},
		{
			field: 'DicMemo',
			title: '使用场景',
			width: 100,
			showTip:true
		},
		{
			field: 'DataSrcFilterMode',
			title: '数据源检索模式',
			width: 150,
			showTip:true
		},
		{
			field: 'DataSrcTableProperty',
			title: '数据源表名及字段名',
			width: 150,
			showTip:true
		}
		]],
		onClickRow: function(rowIndex, rowData) {

			var selected = $('#DicList').datagrid('getSelected');
			if (selected) {
				SetEditAreaVaule(selected);
			} else {
				ClearEditeForm();
			}

		}
	});
}
//将选中的数据信息添加到字框架中		
function SetEditAreaVaule(data) {
	//$("#DicType").combobox('setValue', data.DicType);
	$('#DicCode').val(data.DicCode);
	$('#DicDesc').val(data.DicDesc);
	$('#DefaultValue').val(data.DefaultValue);
	$("#StartDate").datebox("setValue", data.StartDate);
	$("#EndDate").datebox("setValue", data.DateTo);
	//$('#Creator').val(data.Creator);
	$('#DicMemo').val(data.DicMemo);
	$('#DataSrcFilterMode').val(data.DataSrcFilterMode);	//数据源检索模式
	$('#DataSrcTableProperty').val(data.DataSrcTableProperty);	//数据源表名及字段名
	setValueById('ActFlag',data.ActFlag);
}
function ClearEditeForm(data) {
	//$("#DicType").combobox('setValue', data.DicType);
	$('#DicCode').val("");
	$('#DicDesc').val("");
	$('#DefaultValue').val("");
	$("#StartDate").datebox("setValue", "");
	$("#EndDate").datebox("setValue", "");
	//$('#Creator').val("");
	$('#DicMemo').val("");
	$('#DataSrcFilterMode').val("");	//数据源检索模式
	$('#DataSrcTableProperty').val("");	//数据源表名及字段名
	setValueById('ActFlag',"");
}

//删除
function removeDic() {
	var selectedRow = $('#DicList').datagrid('getSelected');
	if (!selectedRow) {
		$.messager.alert('消息', '请选择需要删除的行');
		return;
	}
	$.messager.confirm('消息', '您确定要删除该条记录吗?',
	function(r) {
		if (!r) {
			return;
		}
		var ID = selectedRow.ID;
		$.m({
			ClassName: "BILL.CFG.COM.DictionaryCtl",
			MethodName: "DeleteDicDataInfo",
			ID: ID
		}, function(value) {
			if (value.length != 0) {
				$.messager.alert('消息', value);
				ClearEditeForm(selectedRow);
				SetDicInfoItem(ChoDicCode,searchDicListKey);
				if ($("#SYSTree").tree("getSelected").attributes.DicCode == "SYS"){
					//$("#SYSTree").tree('reload');
					loadDicTree(TreeSehKey);
				}
				return;
			}
		});
	});
	
}

//更新
function updateData() {
	var DicCode = $('#DicCode').val(); //字典编码
	if ($.trim(DicCode) == "") {
		$.messager.alert('提示信息', "字典编码不能为空！");
		return;
	}
	var DicMemo = $('#DicMemo').val(); 
	if ($.trim(DicMemo) == "" ) {
		$.messager.alert('提示信息', "使用场景不能为空！");
		return;
	}
	var selectedRow = $('#DicList').datagrid('getSelected');
	if ((!selectedRow) || (selectedRow.ID == undefined)) {
		var TreeData=$("#SYSTree").tree("getSelected");
		var DataStr = TreeData.attributes.DicCode + "^" + $('#DicCode').val() + "^" + $("#DicDesc").val() + "^" + $("#DefaultValue").val() + "^" + $("#StartDate").datebox("getValue") + "^" + $("#EndDate").datebox("getValue") + "^" + session['LOGON.USERCODE'] + "^" + $("#DicMemo").val()+ "^" + $("#DataSrcFilterMode").val()+ "^" + $("#DataSrcTableProperty").val()+"^"+getValueById('ActFlag');
		$.m({
			ClassName: "BILL.CFG.COM.DictionaryCtl",
			MethodName: "SaveDicdataInfo",
			DataStr: DataStr
		}, function(value) {
			if (value.length != 0) {
				$.messager.alert('消息', value);
				var data="";//{DicType:$('#DicList').combobox('getValue')}
				ClearEditeForm(data);
				//SetDicInfoItem(ChoDicCode,searchDicListKey);
				//if ($("#SYSTree").tree("getSelected").attributes.DicCode == "SYS"){	
				loadDicTree(TreeSehKey);
				//}
			}
		});

	} else {
		var ID = selectedRow.ID;
		var TreeData=$("#SYSTree").tree("getSelected");
		var DicData=$("#DicList").datagrid("getSelected");
		var DataStr = ID + "^" + TreeData.attributes.DicCode + "^" + $('#DicCode').val() + "^" + $("#DicDesc").val() + "^" + $("#DefaultValue").val() + "^" + $("#StartDate").datebox("getValue") + "^" + $("#EndDate").datebox("getValue") + "^" + DicData.Creator + "^" + $("#DicMemo").val()+ "^" + $("#DataSrcFilterMode").val()+ "^" + $("#DataSrcTableProperty").val()+"^"+getValueById('ActFlag');
		$.m({
			ClassName: "BILL.CFG.COM.DictionaryCtl",
			MethodName: "UpdateDicDataInfo",
			DataStr: DataStr
		}, function(value) {
			if (value.length != 0) {
				$.messager.alert('消息', value);
				ClearEditeForm(selectedRow);
				SetDicInfoItem(ChoDicCode,searchDicListKey);
				//if ($("#SYSTree").tree("getSelected").attributes.DicCode == "SYS"){
					//$("#SYSTree").tree('reload');
					//loadDicTree(TreeSehKey);
				//}
				return;
			}
		});
	}
}
