/**
 * @Creator: Huxiaotian 2018-09-20
 * @Desc: 货位顺序维护（备药路径）
 * @Csp: csp/phain.mtdrawsort.csp
 * @Js: scripts/pharmacy/herb/phain.mtdrawsort.js
 */
var curLocId = session['LOGON.CTLOCID'];
$(function() {
    //初始化函数
    InitFormData();
    InitGridMain();
    InitGridDetail();
    InitDialogGrid();
    
    //绑定事件
    $('#txt-stkbin').on('keypress', function(event) {
        if (event.keyCode == "13") {
            QueryDetail();
        }
    });
    $('#btn-Find').on("click", Query);
    $('#btn-Clear').on('click', Clear)
    $('#btnAdd').on("click", AddFn);
    $('#btnSave').on("click", SaveFn);
    $('#btnDelete').on("click", DeleteFn);
    $('#btn-CreateSortNum').on("click", function(){
	    $('#dialog-setNum').window('open');
	    QueryStkShelves();
	});
    
    Query(); 
});

//---------------------------------------
function InitFormData() {
    // 药房
    $("#cmb-PhaLoc").combobox({
		placeholder:'请选择药房...',
		valueField: 'RowId',
		textField: 'Description',
		mode: 'remote',
		width: 180,
		editable: false,
		url: $URL + "?ClassName=PHA.MOB.Dictionary&QueryName=LocList&ResultSetType=array",
        onLoadSuccess: function() {
            var datas = $("#cmb-PhaLoc").combobox("getData");
            for (var i = 0; i < datas.length; i++) {
                if (datas[i].RowId == curLocId) {
                    $("#cmb-PhaLoc").combobox("setValue", datas[i].RowId); //默认值
                    break;
                }
            }
        },
        onSelect: function(data) {}
	});
	
	// 药品名称
	$("#cmg-Inci").combogrid({
		idField: 'incRowId',
        textField: 'incDesc',
		placeholder:'药品名称...',
		pagination: true,
		pageList:[10,20,50],
		pageSize:10,
		width: 260,
		panelWidth: 600,
		mode: 'remote',
		columns: [[
            { field: 'incRowId', title: 'incItmRowId', width: 80, sortable: true, hidden: true },
            { field: 'incCode', title: '药品代码', width: 100, sortable: true },
            { field: 'incDesc', title: '药品名称', width: 360, sortable: true },
            { field: 'incSpec', title: '规格', width: 100, sortable: true }
        ]],
        url: $URL + "?ClassName=PHA.MOB.Dictionary&QueryName=IncItm",
        onBeforeLoad: function(param){
	        param.filterText = param.q;
	    },
		onSelect: function(rowIndex, rowData){
			//alert(rowIndex);
		}
	});
}

function InitGridMain() {
    var columns = [[
		{ field: "ID", title: 'ID', width: 80, hidden: true },
		{ field: 'DSCode', title: '代码', width: 150,
			editor: {
            	type: 'text',
                options: {
                	required: false
                }
            }
        },
		{ field: 'DSDesc', title: '描述', width: 200,
			editor: {
            	type: 'text',
                options: {
                	required: false
                }
            }
        },
		{ field: 'PhLocId', title: 'PhLocId', width: 150, hidden: true }
    ]];
    var dataGridOption = {
        url: $URL,
        fitColumns: true, //横向滚动条
        border: false,
        toolbar: "#gridMainBar",
        rownumbers: false,
        columns: columns,
        pagination: true,
        singleSelect: true,
        onSelect: function(rowIndex, rowData) {
	        QueryDetail();
	    },
	    onLoadSuccess: function() {
            var rows = $("#grid-main").datagrid('getRows');
            if(rows.length>0){
	            $("#grid-main").datagrid('selectRow',0);
	        }
        },
        //行数据编辑
        onClickRow: function(rowIndex, rowData){
		    $(this).datagrid('endEditing');
		},
	    onDblClickRow: function(rowIndex, rowData){
		    beginEditFn(rowIndex, rowData, "DSCode");
	    },
	    onBeginEdit: function(rowIndex, rowData){
		    onBeginEditFn(rowIndex, rowData, "DSCode");
		},
		onEndEdit: function(rowIndex, rowData, changes){
			onEndEditFn(rowIndex, rowData);
		}
    };
    
    DHCPHA_HUI_COM.Grid.Init("grid-main", dataGridOption);
}

// 发药明细列表
function InitGridDetail() {
    var columns = [[
    	{ field: 'TSBID', title: 'TSBID', width: 80, hidden: true },
        { field: 'TSBCode', title: '货位代码', width: 120 },
        { field: 'TSBDesc', title: '货位描述', width: 120 },
        { field: 'TDSiId', title: 'TDSiId', width: 80 , hidden: true},
        { field: 'TDSiSN', title: '货位顺序', width: 100, align: 'center',
        	editor:{
				type:'numberbox',
				options:{
					precision:0
				}
			},
			formatter: function(value,row,index){
				return  '<span style="color:red;font-weight:bold;border-bottom: 5px solid #E6EEF8" >'+ value+'</span>';
			}
		},
        { field: 'TDSId', title: 'TDSId', width: 80 , hidden: true},
        { field: 'TInciCode', title: '药品代码', width: 150, halign: 'left', align: 'left' },
        { field: 'TInciDesc', title: '药品名称', width: 180, halign: 'left', align: 'left' }
    ]];
    var dataGridOption = {
	    url: $URL,
        fitColumns: true,
        border: false,
        rownumbers: false,
        columns: columns,
        pagination: true,
        onLoadSuccess: function(data) {},
        onClickCell: function(rowIndex, field, value){
	        if (field=="TDSiSN"){
		        $(this).datagrid('beginEditRow', {
					rowIndex: rowIndex,
        			editField: field
    			});
    			
		    } else {
			    $(this).datagrid('endEditing');
			}
	    },
	    onEndEdit: function(rowIndex, rowData, changes){
			var selecteddata = $('#grid-detail').datagrid('getRows')[rowIndex];
			var dsid = selecteddata["TDSId"];
			var dsiid = selecteddata["TDSiId"];
			var dsisbid = selecteddata["TSBID"];
			var dsisn = selecteddata["TDSiSN"];
			if (dsisn == ""){
				$("#grid-detail").datagrid("selectRow", rowIndex);
				return false;
			}
			if (isNaN(parseFloat(dsisn)) == true){
				$("#grid-detail").datagrid("selectRow", rowIndex);
	    		return false;
	    	}
	    	if (parseFloat(dsisn) <= 0){
	    		$.messager.alert('错误提示',"第 "+'<span style="color:red;font-weight:bold;border-bottom: 5px solid #E6EEF8" >'+ (rowIndex+1)+'</span>'+" 行SN顺序不能小于0!","info");
	    		$("#grid-detail").datagrid("selectRow", rowIndex);
	    		return false;
	    	}
	    	
	    	var detaildata = dsid+"^"+dsiid+"^"+dsisn+"^"+dsisbid;
			savedata(detaildata);
		}
    };
    
    DHCPHA_HUI_COM.Grid.Init("grid-detail", dataGridOption);
}

// 查询
function Query() {
    var locId = $('#cmb-PhaLoc').combobox('getValue');
	if(locId==null || locId=="" || locId==undefined){
		locId = session['LOGON.CTLOCID'];
	}
    $('#grid-main').datagrid('load', {
		ClassName:'PHA.MOB.Config',
		MethodName:'GetDrawSortList',
		inputStr: locId
	});
}

// 查询明细
function QueryDetail() {
	var selRowData = $("#grid-main").datagrid('getSelected');
	if(selRowData == null){
		alert("请选择左侧路径!");
		return;
	}
	var mainId = selRowData.ID || "";
	var phLocId = selRowData.PhLocId || "";
	var stkBinDesc = $("#txt-stkbin").val() || "";
	stkBinDesc = $.trim(stkBinDesc);
	$("#txt-stkbin").val(stkBinDesc);
	var inci = $("#cmg-Inci").combogrid('getValue');
	
	var inputStr = phLocId +"^"+ mainId +"^"+ stkBinDesc +"^"+ inci;
    $('#grid-detail').datagrid('load', {
		ClassName: 'PHA.MOB.Config',
		MethodName: 'GetDrawSortDetailList',
		inputStr: inputStr
	});
}

// 清屏
function Clear() {
	//表格
    $("#grid-main").datagrid("clear");
    $("#grid-detail").datagrid("clear");
    //表单
	$('#cmb-PhaLoc').combobox('clear');
    $('#txt-stkbin').val('');
}

// --------------------------
// 开始编辑一行
function beginEditFn(rowIndex, rowData, myfield){
	$("#grid-main").datagrid('beginEditRow', {
		rowIndex: rowIndex,
        editField: myfield
    });
}

// 开始编辑时,某一格获得焦点,绑定失去焦点事件
function onBeginEditFn(rowIndex, rowData, myfield){
	var myEditor = $("#grid-main").datagrid('getEditor', {index:rowIndex, field:myfield});
	myEditor.target.focus();
	myEditor.target.select();
}

// 结束编辑时,验证数据合法性
function onEndEditFn(rowIndex, rowData){
	if(rowData.DSCode==""){
		alert('第'+(rowIndex+1)+'行，代码不能为空...');
		$("#grid-main").datagrid("selectRow", rowIndex);
	}
}

// 主表增删改函数调用
function AddFn(){
	$("#grid-main").datagrid('addNewRow', {
        editField: 'DSCode'
    });
}

// 保存主表
function SaveFn(){
	var locId = $('#cmb-PhaLoc').combobox('getValue');
	$("#grid-main").datagrid('endEditing');
	var gridData = $('#grid-main').datagrid('getData');
	var rows = gridData.rows.length;
	var allData = gridData.rows;
	var paramStr = "";
	for(var i=0;i<rows;i++){
		var myID = allData[i]["ID"] || "";
		var myPhLocId = allData[i]["PhLocId"] || locId;
		var myCode = allData[i]["DSCode"];
		var myDesc = allData[i]["DSDesc"];
		var oneStr = myID + "^" + myPhLocId + "^" + myCode + "^" + myDesc;
		if(oneStr!="^^^"){
			if (paramStr==""){
				paramStr = oneStr;
			} else {
				paramStr = paramStr + "||" + oneStr;
			}
		}
	}
	
	//保存数据
	var retStr = tkMakeServerCall('PHA.MOB.Config', 'SaveDrawSort', paramStr);
	var retArr = retStr.split("^");
	if(parseFloat(retArr[0]) != 0){
		$.messager.alert('提示', retArr[1]);
	} else {
		$.messager.alert('提示', retArr[1]);
		Query();
	}
}

// 删除主表
function DeleteFn(){
	var selRowData = $('#grid-main').datagrid('getSelected');
	if (selRowData == null) {
		$.messager.alert('提示', "没有选中数据...");
		return ;
	}
	var selID = selRowData['ID'];
	if (selID == null || selID==undefined || selID=="") {
		$.messager.alert('提示', "数据没有保存...");
		Query();
		return ;
	}
	
	$.messager.confirm('确认','您确认想要删除所选的备药排序规则记录吗？', function(r){
		if (!r){
			return;
		}
		var retStr = tkMakeServerCall('PHA.MOB.Config', 'DelDrawSort', selID);
		var retArr = retStr.split("^");
		if(parseFloat(retArr[0]) != 0){
			$.messager.alert('提示', retArr[1]);
		} else {
			$.messager.alert('提示', retArr[1]);
			Query();
		}
	});
}

// 保存备药规则明细的SN
function savedata(detaildata){
	var retStr = tkMakeServerCall("PHA.MOB.Config", "SaveDrawSortDetail", detaildata);
	var retArr = retStr.split("^");
	if(parseFloat(retArr[0]) != 0){
		$.messager.alert('提示', retArr[1]);
	} else {
		//$.messager.alert('提示', retArr[1]);
		$("#grid-detail").datagrid('reload');
	}
}

// ----------------------------------
// 以下为自动生成货位路径的方法
// 初始化表格
function InitDialogGrid(){
    //定义列
    var columns = [
    	[
        	{ field: 'StkShelves', title: '货架名称', width: 100 },
        	{ field: 'StkShelvesNum', title: '货架顺序号', width: 100,
        	  	editor:{
					type:'numberbox',
					options:{
						precision:0
					}
				}
			}
    	]
    ];
	
	//Grid基本配置
    var dataGridOption = {
	    url: $URL,
	    fitColumns: true,
        //rownumbers: true,
        columns: columns,
        singleSelect: true,
        striped: false,
        selectOnCheck: false,
        checkOnSelect: false,
        pagination: false,
        onLoadSuccess: function(data) {},
        rowStyler: function(rowIndex, rowData) {},
        onDblClickRow: function(rowIndex, rowData) {},
	    onCilckRow:function(rowIndex, rowData) {},
		onSelect: function(rowIndex, rowData) {},
		onClickCell: function(rowIndex, field, value){
	        if (field=="StkShelvesNum"){
		        $(this).datagrid('beginEditRow', {
					rowIndex: rowIndex,
        			editField: field
    			});
		    } else {
			    $(this).datagrid('endEditing');
			}
	    }
    };
    
    //Grid初始化
    $("#grid-dialog-setNum").datagrid(dataGridOption);
}

function QueryStkShelves(){
	$("#grid-dialog-setNum").datagrid('load', {
		ClassName: 'PHA.MOB.Config',
		MethodName: 'QueryStkShelves',
	});
}

function SaveStkShelves(){
	$.messager.alert('提示', "需定义生成规则");
	return;
	
	var selRowData = $("#grid-main").datagrid('getSelected');
	if(selRowData == null){
		alert("请选择左侧路径!");
		return;
	}
	var mainId = selRowData.ID;
	
	$("#grid-dialog-setNum").datagrid('endEditing');
	var retStr = "";
	var gridData = $('#grid-dialog-setNum').datagrid('getData');
	var rows = gridData.rows.length;
	if (rows == 0) {
		alert("页面没有数据,无法打印!");
		return ;
	}
	var allData = gridData.rows;
	for(var i=0; i<rows; i++){
		var StkShelves = allData[i].StkShelves || "";
		var StkShelvesNum = allData[i].StkShelvesNum || "";
		if(StkShelvesNum == ""){
			continue;
		}
		var oneRow = StkShelves + "^" + StkShelvesNum;
		if(retStr == ""){
			retStr = oneRow;
		}else{
			retStr = retStr + "|@|" + oneRow;
		}
	}
	if(retStr == ""){
		alert("请填写货架顺序!");
		return;
	}
	
	var ret = tkMakeServerCall("PHA.MOB.Config", "SaveStkShelves", mainId, retStr);
	var retArr = ret.split("^");
	if(retArr[0] < 0){
		$.messager.alert("温馨提示", "生成失败"+retArr[1], "info");
	} else {
		$('#dialog-setNum').window('close');
		$.messager.alert("温馨提示", "生成成功", "info");
	}
}