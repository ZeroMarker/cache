/*
 * FileName:	dhcinsutaritemscom.js
 * User:		DingSH 
 * Date:		2019-05-30	
 * Description: 医保目录维护
 */

var GUser = session['LOGON.USERID'];
var HospDr = session['LOGON.HOSPID'];
var PUBLIC_CONSTANT = {
	SESSION: {
		HOSPID: session['LOGON.HOSPID'],
	}
}
var INTIMxmbm = ""

$(function () {
	InitInItemsDg();
	initKeyTypes();
	//关键字回车事件
	$("#tKeyWords").keydown(function (e) {
		if (e.keyCode == 13) {
			QryInTarItems();
		}
	});
	
});
//加载查询条件
function initKeyTypes() {
	$HUI.combobox("#tKeyType", {
		valueField: 'id', textField: 'text', panelHeight: "auto",
		data: [
			{ id: '0', text: '查询所有' }
			, { id: '1', text: '按拼音', selected: true }
			, { id: '2', text: '按代码' }
			, { id: '3', text: '按名称' }
		],
		defaultFilter: '1'
	});
	
	var tinsutypecombox = $('#tInsuType').combogrid({
		panelWidth: 350,
		panelHeight: 238,
		idField: 'cCode',
		textField: 'cDesc',
		rownumbers: true,
		url: $URL,
		onBeforeLoad: function (param) {
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName = 'QueryDic1';
			param.Type = 'TariType';
			param.HospDr = PUBLIC_CONSTANT.SESSION.HOSPID;
		},
		fit: true,
		pagination: false,
		columns: [[
			{ field: 'cCode', title: '代码', width: 60 },
			{ field: 'cDesc', title: '描述', width: 100 }
		]],
		fitColumns: true,
		onLoadSuccess: function (data) {
			tinsutypecombox.combogrid('setValue', data.rows[0].cCode);
		},
		onSelect: function (index, data) {
		}
	});
}

//查询医保目录
function QryInTarItems() {

	//var stdate=$('#stdate').datebox('getValue');
	//var endate=$('#endate').datebox('getValue');
	var InRowid = ""
	var KeyWords = $('#tKeyWords').val();
	var KeyType = $('#tKeyType').combobox("getValue");
	if (!arguments[0]) {		//WangXQ 20220608 限制查询关键字最小长度,切换院区时不判断
		if (KeyType == "") { 
			$.messager.alert("温馨提示", "请选择查询条件", "info")
			return
		}
		if (KeyType != "0" && KeyWords.length < 2) {
			$.messager.alert("温馨提示", "请输入关键字,关键字长度最少为2", "info")
			return
		}
	}
	$('#tInTarItems').datagrid('options').url = $URL;
	var InsuType = $('#tInsuType').combobox("getValue");
	$('#tInTarItems').datagrid('reload', {
		ClassName: 'web.INSUTarItemsCom',
		QueryName: 'QueryAll',
		txt: KeyWords,
		Class: KeyType,
		Type: InsuType,
		zfblTmp:"",
		ExpStr:"", 
		HospDr: PUBLIC_CONSTANT.SESSION.HOSPID
	});

}
//初始化医保目录gd
function InitInItemsDg() {
	//初始化datagrid
	$HUI.datagrid("#tInTarItems", {
		//url:$URL,
		fit: true,
		width: '100%',
		height: 800,
		border: false,
		singleSelect: true,
		rownumbers: true,
		data: [],
		frozenColumns: [[
			{
				field: 'TOpt',
				width: 40,
				title: '操作',
				align: 'center',
				formatter: function (value, row, index) {

					return "<img class='myTooltip' style='width:60' title='修改' onclick=\"InTarItemsEditClick("+"'"+index+"'"+")\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/write_order.png' style='border:0px;cursor:pointer'>";

				}
			}

		]],
		columns: [[
			{ field: 'RecordSum', title: 'RecordSum', width: 10, hidden: true },
			{ field: 'rowid', title: 'rowid', width: 10, hidden: true },
			{ field: 'INTIMxmbm', title: '医保项目编码', width: 140 },
			{ field: 'INTIMxmmc', title: '医保项目名称', width: 180 },
			{ field: 'INTIMjx', title: '剂型', width: 60 },
			{ field: 'INTIMgg', title: '规格', width: 60 },
			{ field: 'INTIMdw', title: '单位 ', width: 60 },
			{ field: 'INTIMsfdlbmDesc', title: '收费大类名称', width: 100 },
			//{field:'INTIMsfdlbm',title:'收费大类',width:10,hidden:true},
			{ field: 'INTIMzfbl1', title: '自付比例', width: 80 },
			{ field: 'INTIMtjdm', title: '项目等级', width: 80 },
			{
				field: 'INTIMflzb1', title: '是否医保', width: 80,
				formatter: function (value, row, index) {
					if (value == "Y") {
						return "是";
					} else {
						return "否";
					}
				}

			},
			{
				field: 'INTIMflzb2', title: '生效标志', width: 80,
				formatter: function (value, row, index) {
					if (value == "Y") {
						return "是";
					} else {
						return "否";
					}
				}
			},
			{ field: 'INTIMActiveDate', title: '生效日期', width: 100 },
			{ field: 'INTIMExpiryDate', title: '失效日期', width: 100 },
			{ field: 'INTIMDate', title: '更新日期', width: 100 },
			{ field: 'INTIMTime', title: '更新时间', width: 80 },
			{ field: 'INTIMUserName', title: '更新人', width: 60 },
			{ field: 'INTIMxmrj', title: '拼音码', width: 120 },
			{ field: 'INTIMsfxmbmdesc', title: '医保类别', width: 120 },
			{ field: 'INTIMsfxmbm', title: '医保类别', width: 10, hidden: true },
			{ field: 'INTIMxmlb', title: '项目类别', width: 100, hidden: true },
			{ field: 'INTIMXmlbDesc', title: '项目类别', width: 100 },
			{ field: 'INTIMyf', title: '用法', width: 80 },
			{ field: 'INTIMyl', title: '用量', width: 80 },
			{ field: 'INTIMtxbz', title: '限制用药标识', width: 150 },
			{ field: 'INTIMpzwh', title: '批准文号', width: 80 },
			{ field: 'INTIMUnique', title: '国家编码', width: 120 },
			{ field: 'INTIMyysmbm', title: '国家名称', width: 140 },
			{ field: 'INTIMspmc', title: '商品名称', width: 100 },
			{ field: 'INTIMspmcrj', title: '商品名称拼音码', width: 140 },
			{ field: 'INTIMyyjzjbz', title: '医院增加标识', width: 140 },
			{ field: 'INTIMsfdlbm', title: '收费大类编码', width: 120 },
			{ field: 'INTIMsl', title: '数量', width: 50, hidden: true },
			{ field: 'INTIMbzjg', title: '标准价格', width: 50, hidden: true },
			{ field: 'INTIMsjjg', title: '实际价格', width: 50, hidden: true },
			{ field: 'INTIMzgxj', title: '最高限价', width: 50, hidden: true },
			{ field: 'INTIMbpxe', title: '报批限额', width: 50, hidden: true },
			{ field: 'INTIMbz', title: '备注', width: 100, hidden: true },
			{ field: '"Index', title: '序号', width: 150, hidden: true },
			{ field: 'INTIMzfbl2', title: '自付比例2', width: 50, hidden: true },
			{ field: 'INTIMzfbl3', title: '自付比例3', width: 50, hidden: true },
			{ field: 'INTIMflzb3', title: '分类指标3', width: 50, hidden: true },
			{ field: 'INTIMflzb4', title: '分类指标4', width: 50, hidden: true },
			{ field: 'INTIMflzb5', title: '分类指标5', width: 50, hidden: true },
			{ field: 'INTIMflzb6', title: '分类指标6', width: 50, hidden: true },
			{ field: 'INTIMflzb7', title: '分类指标7', width: 50, hidden: true },
			{ field: 'INTIMljzfbz', title: '累计增负标识', width: 50, hidden: true },
			{ field: 'INTIMfplb', title: '发票类别', width: 50, hidden: true },
			{ field: 'INTIMDicType', title: '目录类别', width: 50, hidden: true },
			{ field: 'INTIMHospDr', title: '院区指针', width: 50, hidden: true }
		]],
		pageSize: 20,
		pagination: true,
		onClickRow: function (rowIndex, rowData) {
		},
		onDblClickRow: function (rowIndex, rowData) {

			InTarItemsEditClick(rowIndex);
		},
		onUnselect: function (rowIndex, rowData) {
			//alert(rowIndex+"-"+rowData.itemid)
		},
		onLoadSuccess: function (data) {
			var index = 0;
		}
	});

}



function InTarItemsEditClick(rowIndex) {

	//LocRowIndex=rowIndex;
	var rowData = $('#tInTarItems').datagrid("getRows")[rowIndex]; //$('#dg').datagrid('fixColumnSize');       
	//initInItmFrm(rowIndex,rowData)
	//var rowData  = $('#tInTarItems').datagrid('getSelected'); //有bug
	if (!rowData ) {
	   $.messager.alert("温馨提示","请选择一条医保目录!", 'info');
	   return ;
	}
	var url = "dhcinsutareditcom.csp?&InItmRowid=" + rowData.rowid + "&INSUType=" + rowData.INTIMsfxmbm + "&Hospital=" + rowData.INTIMHospDr;
	websys_showModal({
		url: url,
		title: "修改-医保目录维护",
		iconCls: "icon-w-edit",
		width: "855",
		height: "660",
		onClose: function () {
			QryInTarItems(1);
		},

	}

	);

}

//查询医保目录对应是收费项
function btnTarQryClick(){
	var selected = $('#tInTarItems').datagrid('getSelected');
	if (!selected) {
	   $.messager.alert("温馨提示","请选择一条医保目录!", 'info');
	   return ;
	}
	var Rowid =selected.rowid 
	var url = "insutarcontrastpop.csp?&Rowid="+Rowid+"&INSUType="+selected.INTIMsfxmbm+"&Hospital=" + selected.INTIMHospDr + "&INTIMxmbm=" +selected.INTIMxmbm+ "&INSUType=" +selected.INTIMsfxmbm;
	websys_showModal({
		url: url,
		title: selected.INTIMxmmc+"--------对照的收费项",
		iconCls: "icon-w-edit",
		width: "920",
		height: "420",
		onClose: function () {
			
		}
	});

}
//目录扩展信息维护 2023-02-17
function  btnTarExtEditClick(){
	var rowData = $('#tInTarItems').datagrid('getSelected');
	if (!rowData) {
	   $.messager.alert("温馨提示","请选择一条医保目录!", 'info');
	   return ;
	}
	var InsuCode =rowData.INTIMxmbm;
	var InsuDesc =rowData.INTIMxmmc;
	var HiType =rowData.INTIMsfxmbm; 
	var HospId =rowData.INTIMHospDr; 
	var url = "dhcinsu.taritemsextedit.csp?InsuCode="+InsuCode+"&InsuDesc="+encodeURIComponent(InsuDesc)+"&HospId=" + HospId + "&HiType=" +HiType;
	websys_showModal({
		url: url,
		title: "【"+InsuDesc+"】"+"目录扩展信息维护",
		iconCls: "icon-w-edit",
		width: "760",
		height: "345",
		onClose: function () {
			
		}
	});

}



//医保目录导出
function InItmEpot() {
	try {
		var KeyWords = $('#tKeyWords').val();
		var KeyType = $('#tKeyType').combobox("getValue");
		var InsuType = $('#tInsuType').combobox("getValue");
		$.messager.progress({
			title: "提示",
			msg: '正在导出医保目录数据',
			text: '导出中....'
		});
		$cm({
			ResultSetType: "ExcelPlugin",
			ExcelName: "医保目录",
			PageName: "QueryAll",
			ClassName: "web.INSUTarItemsCom",
			QueryName: "QueryAll",
			txt: KeyWords,
			Class: KeyType,
			Type: InsuType,
			zfblTmp: ""
		}, function () {
			setTimeout('$.messager.progress("close");', 3 * 1000);
		});

		/*var InRowid=""
		var KeyWords=$('#tKeyWords').val();
		var KeyType=$('#tKeyType').combobox("getValue");
		var InsuType=$('#tInsuType').combobox("getValue");	
		var rtn = $cm({
		dataType:'text',
		ResultSetType:"Excel",
		ExcelName:"医保目录导出", //默认DHCCExcel
		ClassName:"web.INSUTarItemsCom",
		QueryName:"QueryAll",
		txt:KeyWords,
		Class:KeyType,
		Type:InsuType,
		zfblTmp:""
		 },false);
		 location.href = rtn;
		$.messager.progress({
					title: "提示",
					msg: '正在导出医保目录数据',
					text: '导出中....'
				});
		setTimeout('$.messager.progress("close");', 3 * 1000);	
		    
			return;*/
	} catch (e) {
		$.messager.alert("警告", e.message);
		$.messager.progress('close');
	};


}


function InItmImpt() {
	var filePath = ""
	var exec = '(function tst(){ var xlApp  = new ActiveXObject("Excel.Application");'
		+ 'var fName=xlApp.GetOpenFilename("Excel xlsx (*.xlsx), *.xlsx,Excel xls (*.xls), *.xls");'
		+ 'if (!fName){fName="";}'
		+ 'xlApp.Quit();'
		+ 'xlSheet=null;'
		+ 'xlApp=null;'
		+ 'return fName;}());'
	CmdShell.notReturn = 0;
	var rs = CmdShell.EvalJs(exec);
	if (rs.msg == 'success') {
		filePath = rs.rtn;
		importItm(filePath);
	} else {
		$.messager.alert('提示', '打开文件错误！' + rs.msg, 'error');
	}


}

function importItm(filePath) {
	if (filePath == "") {
		$.messager.alert('提示', '请选择文件！', 'info')
		return;
	}
	$.messager.progress({
		title: "提示",
		msg: '医保目录导入中',
		text: '数据读取中...'
	});
	$.ajax({
		async: true,
		complete: function () {
			ReadItmExcel(filePath);
		}
	});

}
//读取Excel数据
function ReadItmExcel(filePath) {

	//读取excel
	var arr;
	try {
		arr = websys_ReadExcel(filePath);
		$.messager.progress("close");
	}
	catch (ex) {
		$.messager.progress("close");
		$.messager.alert('提示', '调用websys_ReadExcel异常：' + ex.message, 'error')
		return;
	}
	var rowCnt = arr.length
	$.messager.progress({
		title: "提示",
		msg: '医保目录导入',
		text: '导入中，共：' + (rowCnt - 1) + '条'
	});
	$.ajax({
		async: true,
		complete: function () {
			ItmArrSave(arr);
		}
	});
}
//医保目录数据保存
function ItmArrSave(arr) {

	//读取保存数据
	var ErrMsg = "";     //错误数据
	var errRowNums = 0;  //错误行数
	var sucRowNums = 0;  //导入成功的行数
	var rowCnt = arr.length
	try {
		for (i = 1; i < rowCnt; i++) {
			var rowArr = arr[i]
			var UpdateStr = "^" + rowArr.join("^")
			var savecode = tkMakeServerCall("web.INSUTarItemsCom", "Update", "", "", UpdateStr)
			if (savecode == null || savecode == undefined) savecode = -1

			if (savecode >= 0) {
				sucRowNums = sucRowNums + 1;
			} else {
				errRowNums = errRowNums + 1;
				if (ErrMsg == "") {
					ErrMsg = i + ":" + savecode;
				} else {
					ErrMsg = ErrMsg + "<br>" + i + ":" + savecode;
				}
			}
		}

		if (ErrMsg == "") {
			$.messager.progress("close");
			$.messager.alert('提示', '数据正确导入完成');
		} else {
			$.messager.progress("close");
			var tmpErrMsg = "导入成功：" + sucRowNums + "条，失败：" + errRowNums + "条。";
			tmpErrMsg = tmpErrMsg + "<br>失败数据行号：<br>" + ErrMsg;
			$.messager.alert('提示', tmpErrMsg, 'info');
		}
		return;
	}
	catch (ex) {
		$.messager.progress("close");
		$.messager.alert('提示', '保存医保目录数据异常：' + ex.message, 'error')
		return;
	}
	return;

}

function SetValue(value) {
	if (value == undefined) {
		value = "";
	}
	value = value.toString().replace(/\"/g, "");
	value = value.toString().replace(/\?/g, "");
	return value;
}
/*
 * 加载医院院区combogrid
 * tangzf 2019-7-18
 */
function selectHospCombHandle() {
	//$('#tInsuType').combobox('clear');
	$('#tInsuType').combobox('reload');
	QryInTarItems(1);	// WangXQ 20220616 切换院区不判断关键字长度	
}
/*
 * 单条增加医保目录
 * tangzf 2019-7-18
 */
function addINSUTarItems() {
	//var InsuType = getValueById('tInsuType');
	var InsuType = $('#tInsuType').combogrid("getValue");	//WangXQ 20221027
	if (InsuType == "") {
		$.messager.alert('提示', '医保类型不能为空', 'info');
		return;
	}
	var url = "dhcinsutareditcom.csp?&InItmRowid=&INSUType=" + InsuType + "&Hospital=" + PUBLIC_CONSTANT.SESSION.HOSPID;//?&ItmRowid= + rowData.Rowid;
	websys_showModal({
		url: url,
		title: "新增-医保目录维护",
		iconCls: "icon-w-edit",
		width: "855",
		height: "660",
		onClose: function () {
			QryInTarItems();
		}
	})
}
function ExportConfig() {
	var KeyWords = $('#tKeyWords').val();
	var KeyType = $('#tKeyType').combobox("getValue");
	var InsuType = $('#tInsuType').combobox("getValue");
	window.open("websys.query.customisecolumn.csp?CONTEXT=Kweb.INSUTarItemsCom:QueryAll&PAGENAME=QueryAll" + "&txt=" + KeyWords + "&KeyType=" + KeyType + "&Type=" + InsuType + "&zfblTmp=" + "");
}




