/*
 * @模块:     煎药方案维护
 * @编写日期: 2019-08-07
 * @编写人:   hulihua
 */
$(function () {
	InitDict();
	InitGridDecScheme();
});

/*
 * 初始化组件
 * @method InitDict
 */
function InitDict() {
	var activeData = [{ "RowId": "Y", "Description": "可用" }, { "RowId": "N", "Description": "不可用" }];
	var YOrNData = [{ "RowId": "Y", "Description": "是" }, { "RowId": "N", "Description": "否" }];
	PHA.ComboBox("cmbActive", {
		data: activeData
	});
	
	PHA.ComboBox("cmbPresForm", {
		url: PHA_DEC_STORE.PrescForm().url
	});
	var presEffectData = [{
				"RowId": "一般类",
				"Description": "一般类"
			}, {
				"RowId": "解表类",
				"Description": "解表类"
			}, {
				"RowId": "滋补类",
				"Description": "滋补类"
			}
		]
	PHA.ComboBox("cmbPresEffect", {
		data: presEffectData
	});
	PHA.ComboBox("cmbSecDec", {
		data: YOrNData
	});
	PHA.ComboBox("cmbPaste", {
		data: YOrNData
	});
	PHA.ComboBox("qCmbScheState", {
		width: 110,
		//placeholder: '方案状态...',
		data: activeData,
		onSelect: function (selData) {
			queryGrid();
		}
	});
	
	PHA.ComboBox("qCmbPresEffect", {
		width: 110,
		//placeholder: '处方功效...',
		data: presEffectData,
		onSelect: function (selData) {
			queryGrid();
		}
	});
	PHA.ComboBox("qCmbSecDec", {
		width: 110,
		//placeholder: '是否二煎...',
		data: YOrNData,
		onSelect: function (selData) {
			queryGrid();
		}
	});
	PHA.ComboBox("qCmbPaste", {
		width: 110,
		//placeholder: '是否制膏...',
		data: YOrNData,
		onSelect: function (selData) {
			queryGrid();
		}
	});
	PHA.ComboBox("qCmbPresForm", {
		width: 110,
		//placeholder: '处方剂型...',
		url: PHA_DEC_STORE.PrescForm().url,
		onSelect: function (selData) {
			queryGrid();
		}
	});
	$("#qTxtScheName").on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			queryGrid();
		}
	});
}
/*
 * 初始化方案表格
 * @method InitGridDecScheme
 */
function InitGridDecScheme() {
	var columns = [
		[{
				field: 'TDecScheId',
				title: 'TDecScheId',
				halign: 'center',
				align: 'center',
				width: 100,
				hidden: true
			}, {
				field: 'TScheCode',
				title: '方案代码',
				align: 'left',
				width: 80
			}, {
				field: 'TScheDesc',
				title: '方案名称',
				align: 'left',
				width: 140
			}, {
				field: 'TActiveFlag',
				title: '方案状态',
				align: 'left',
				width: 80,
				formatter: function (value, row, index) {
					if (value == "Y") {
						return "可用";		//PHA_COM.Fmt.Grid.Yes.Icon;
					} else if (value == "N") {
						return "不可用";		//PHA_COM.Fmt.Grid.No.Icon;
					} else  {
						return "";		//PHA_COM.Fmt.Grid.No.Icon;
					}
				}
			}, {
				field: 'TPresForm',
				title: '处方剂型',
				align: 'left',
				width: 120
			}, {
				field: 'TPresEffect',
				title: '处方功效',
				align: 'left',
				hidden: true ,
				width: 100
			}, {
				field: 'TSoakInt',
				title: '浸泡时长(分)',
				align: 'left',
				width: 100
			}, {
				field: 'TFirDecInt',
				title: '首煎时长(分)',
				align: 'left',
				width: 100
			}, {
				field: 'TFirWaterQua',
				title: '首煎加水量(ML)',
				align: 'left',
				width: 120
			}, {
				field: 'TSecDecFlag',
				title: '是否二煎',
				align: 'left',
				width: 80,
				formatter: function (value, row, index) {
					if (value == "Y") {
						return "是";		//PHA_COM.Fmt.Grid.Yes.Icon;
					} else {
						return "否";		//PHA_COM.Fmt.Grid.No.Icon;
					}
				}
			}, {
				field: 'TPasteFlag',
				title: '是否制膏',
				align: 'left',
				width: 80,
				formatter: function (value, row, index) {
					if (value == "Y") {
						return "是";		//PHA_COM.Fmt.Grid.Yes.Icon;
					} else {
						return "否";		//PHA_COM.Fmt.Grid.No.Icon;
					}
				}
			}, {
				field: 'TSecDecInt',
				title: '二煎时长(分)',
				align: 'left',
				width: 100
			}, {
				field: 'TSecWaterQua',
				title: '二煎加水量(ML)',
				align: 'left',
				width: 120
			}, {
				field: 'TTemper',
				title: '温度(℃)',
				align: 'left',
				width: 60
			}, {
				field: 'TPressure',
				title: '压强(帕)',
				align: 'left',
				width: 80
			}, {
				field: 'TPresFormDr',
				title: '处方剂型外键',
				align: 'left',
				width: 10,
				hidden: true
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.DEC.CfDecSche.Query',
			QueryName: 'QueryProSche'
		},
		toolbar: "#gridDecSchemeBar",
		columns: columns,
		onDblClickRow: function (rowIndex) {
			MainTain("U");
		},
        onRowContextMenu: function(){
			return false;	
		}
	};
	PHA.Grid("gridDecScheme", dataGridOption);
}

function MainTain(type) {
    var gridSelect = $('#gridDecScheme').datagrid('getSelected');
    if (type == "U") {
        if (gridSelect == null) {
            PHA.Popover({
                msg: "请先选中需要修改的记录",
                type: 'alert'
            });
            return;
        }
		$("#txtScheCode").val(gridSelect.TScheCode);
		$('#txtScheDesc').val(gridSelect.TScheDesc);
		$('#txtScheCode').validatebox('validate');
		$('#txtScheDesc').validatebox('validate');
		$("#cmbActive").combobox('setValue', gridSelect.TActiveFlag);
		$("#cmbPresForm").combobox('setValue', gridSelect.TPresFormDr);
		$("#cmbPresEffect").combobox('setValue', gridSelect.TPresEffect);
		$('#txtPressure').val(gridSelect.TPressure);
		$('#txtSoakInt').val(gridSelect.TSoakInt);
		$('#txtFirDecInt').val(gridSelect.TFirDecInt); 
		$('#txtFirWaterQua').val(gridSelect.TFirWaterQua);
		$("#cmbSecDec").combobox('setValue', gridSelect.TSecDecFlag);
		$('#txtSecDecInt').val(gridSelect.TSecDecInt); 
		$('#txtSecWaterQua').val(gridSelect.TSecWaterQua);
		$('#txtTemper').val(gridSelect.TTemper);
		$("#cmbPaste").combobox('setValue', gridSelect.TPasteFlag);
    } else if (type = "A") {
        $('#txtScheCode').val("");
		$('#txtScheDesc').val("");
		$("#cmbActive").combobox('clear');
		$("#cmbPresForm").combobox('clear');
		$("#cmbPresEffect").combobox('clear');
		$('#txtPressure').val("");
		$('#txtSoakInt').val("");
		$('#txtFirDecInt').val(""); 
		$('#txtFirWaterQua').val("");
		$("#cmbSecDec").combobox('clear');
		$('#txtSecDecInt').val(""); 
		$('#txtSecWaterQua').val("");
		$('#txtTemper').val("");
		$("#cmbPaste").combobox('clear');
    }
    $('#gridDecSchemeWin').window({ 'title': "煎药方案" + ((type == "A") ? "新增" : "编辑") })
    $('#gridDecSchemeWin').window('open');
}

/*
 * 保存数据
 * @method SaveData
 */
function SaveData(){
	var scheCode = $('#txtScheCode').val().trim();
	var scheDesc = $('#txtScheDesc').val().trim();
	var activeFlag = $("#cmbActive").combobox('getValue');
	var prescForm = $("#cmbPresForm").combobox('getValue');
	var prescEffect = ""	//$("#cmbPresEffect").combobox('getValue');
	var pressure = $('#txtPressure').val().trim();
	var soakInt = $('#txtSoakInt').val().trim();
	var firDecInt = $('#txtFirDecInt').val().trim(); 
	var firWaterQua = $('#txtFirWaterQua').val().trim();
	var secDecFlag = $("#cmbSecDec").combobox('getValue');
	var secDecInt = $('#txtSecDecInt').val().trim(); 
	var secWaterQua = $('#txtSecWaterQua').val().trim();
	var temperature = $('#txtTemper').val().trim();
	var pasteFlag = $("#cmbPaste").combobox('getValue');	//是否制膏
	var winTitle = $("#gridDecSchemeWin").panel('options').title;
	var decScheId = "";
	if (winTitle.indexOf("编辑") >= 0){
		var gridSelect = $('#gridDecScheme').datagrid('getSelected');
        decScheId = gridSelect.TDecScheId;
    }
	if((scheCode=="")||(scheCode==null)){
		PHA.Popover({
			msg: "方案代码不能为空！",
			type: 'alert'
		});
		return;
	}
	if((scheDesc=="")||(scheDesc==null)){
		PHA.Popover({
			msg: "方案名称不能为空！",
			type: 'alert'
		});
		return;
	}
	if((activeFlag=="")||(activeFlag==null)){
		PHA.Popover({
			msg: "方案状态不能为空！",
			type: 'alert'
		});
		return;
	}
	if((prescForm=="")||(prescForm==null)){
		PHA.Popover({
			msg: "处方剂型不能为空！",
			type: 'alert'
		});
		return;
	}
	/*
	if((prescEffect=="")||(prescEffect==null)){
		PHA.Popover({
			msg: "处方功效不能为空！",
			type: 'alert'
		});
		return;
	}
	*/
	var dataStr1=scheCode+"^"+scheDesc+"^"+activeFlag+"^"+prescForm+"^"+prescEffect
	var dataStr2=pressure+"^"+soakInt+"^"+firDecInt+"^"+firWaterQua+"^"+secDecFlag
	var dataStr3=secDecInt+"^"+secWaterQua+"^"+temperature+"^"+pasteFlag
	var dataStr=dataStr1+"^"+dataStr2+"^"+dataStr3;
	$m({
		ClassName:"PHA.DEC.CfDecSche.OperTab",
		MethodName:"SavOrUpData",
		ProScheId:decScheId,
		SqlStr:dataStr
	},function(txtData){
		var retCode=txtData.split("^")[0];
		if(retCode==0){
			PHA.Popover({
				msg: "保存成功！",
				type: 'success'
			});
			$('#gridDecSchemeWin').window('close');
			$('#gridDecScheme').datagrid('query');
		}else{
			PHA.Popover({
				msg: "保存失败，" + txtData.split("^")[1],
				type: 'alert'
			});
			return;
		}
	});
}
/*
 * 获取参数值
 * @method CloseWin
 */
function getParam() {
	var scheName = $("#qTxtScheName").val();
	var scheState = $("#qCmbScheState").combobox("getValue");
	var presEffect = "" //$("#qCmbPresEffect").combobox("getValue");
	var secDec = $("#qCmbSecDec").combobox("getValue");
	var presForm = $("#qCmbPresForm").combobox("getValue");
	var paste = $("#qCmbPaste").combobox("getValue");
	return scheName +"^"+ scheState +"^"+ presForm +"^"+ secDec +"^"+  presEffect +"^"+ paste;
}
/*
 * 加载表格数据
 * @method InitGridDecScheme
 */
function queryGrid(){
	$('#gridDecScheme').datagrid('query',{
		inputStr: getParam()	
	});
}
/*
 * 清空界面
 * @method Clear
 */
function Clear(){
	$("#qTxtScheName").val("");
	$("#qCmbScheState").combobox("setValue","");
	$("#qCmbPresEffect").combobox("setValue","");
	$("#qCmbSecDec").combobox("setValue","");
	$("#qCmbPresForm").combobox("setValue","");
	$('#gridDecScheme').datagrid('clear');
	$("#qCmbPaste").combobox("setValue","");
}
/*
 * 关闭弹出框
 * @method CloseWin
 */
function CloseWin() {
	$('#gridDecSchemeWin').window('close');
}
