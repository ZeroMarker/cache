var currentConfigId = "";

$(function () {
	
	$("#defaultBox").datagrid({
		title:"默认配置",
		fit:true,
		iconCls:"icon-paper",
		toolbar:"#defaultTool",
		headerCls:"panel-header-gray",
	});

	$("#dataBox1").datagrid({
		fit: true,
		singleSelect: true,
		rownumbers: true,
		headerCls: "panel-header-gray",
		bodyCls: "panel-header-gray",
		iconCls:"icon-paper",
		title: "签名配置",
		url: ANCSP.DataQuery,
		queryParams: {
			ClassName: "CIS.AN.CA.SignService",
			QueryName: "FindCASignConfig",
			ArgCnt: 0,
		},
		columns: [
			[{
					field: "VenderCode",
					title: "签名厂商代码",
					width: 150
				},
				{
					field: "SignType",
					title: "签名类型",
					width: 150
				},
				{
					field: "SignDesc",
					title: "说明",
					width: 200
				},
				{
					field: "JSPathInfo",
					title: "加载JS路径",
					width: 150,
					formatter: function (value, row, index) {
						return "<a href='#' onclick='showJSPathView(\"" + row.RowId + "\")'>" + "加载JS路径" + "</a>";
					}
				},
				{
					field: "CAConfigTest",
					title: "CA配置测试",
					width: 150,
					formatter: function (value, row, index) {
						var para = "VenderCode=" + encodeURI(row.VenderCode) + "&SignType=" + encodeURI(row.SignType) + "&SignDesc=" + encodeURI(row.SignDesc);
						return "<a href='#' onclick='showCAConfigTestView(\"" + para + "\")'>" + "CA配置测试" + "</a>";
					}
				},
				{
					field: "IsDefault",
					title: "是否默认",
					width: 200,
					hidden: true
				},
				{
					field: "IsDefaultDesc",
					title: "是否默认描述",
					width: 200,
					hidden: true
				},
				{
					field: "RowId",
					title: "RowId",
					width: 200,
					hidden: true
				},
			]
		],
		toolbar: "#dataTools1",
		onClickRow: function (rowIndex, rowData) {
			$("#VenderCode").val(rowData.VenderCode);
			$("#SignType").combobox("setValue", rowData.SignType);
			$("#SignDesc").val(rowData.SignDesc);
			$("#dataBox2").datagrid("reload");
		}
	});


	$("#SignType").combobox({
		valueField: "Code",
		textField: "Description",
		data: [{
				Code: "Pin",
				Description: "Pin"
			},
			{
				Code: "Face",
				Description: "Face"
			},
			{
				Code: "UKey",
				Description: "UKey"
			},
			{
				Code: "Phone",
				Description: "Phone"
			},
			{
				Code: "Sound",
				Description: "Sound"
			},
			{
				Code: "HandSign",
				Description: "HandSign"
			},
			{
				Code: "Common",
				Description: "Common"
			}
		]
	});

	$("#btnAdd").linkbutton({
		onClick: function () {
			var venderCode = $("#VenderCode").val();
			var signType = $("#SignType").combobox("getValue");
			if (venderCode === "") {
				$.messager.alert("提示", "厂商代码不能为空", "error");
				return;
			}
			if (signType === "") {
				$.messager.alert("提示", "签名类型不能为空", "error");
				return;
			}
			var signDesc = $("#SignDesc").val();

			var configData = [{
				VenderCode: venderCode,
				SignType: signType,
				SignDesc: signDesc,
				IsDefault: "N",
				RowId: "",
				ClassName: "CF.AN.CASignConfig"
			}];
			dhccl.saveDatas(ANCSP.DataListService, {
				jsonData: dhccl.formatObjects(configData)
			}, function (result) {
				dhccl.showMessage(result, "保存", null, null, function () {
					$("#VenderCode").val("");
					$("#SignType").combobox("setValue", "");
					$("#SignDesc").val("");
					$("#dataBox1").datagrid("reload");
					loadDefaultSign();
				});
			});
		}
	});

	$("#btnEdit").linkbutton({
		onClick: function () {
			var row = $("#dataBox1").datagrid("getSelected");
			if (!row) {
				$.messager.alert("提示", "请选择一行", "error");
				return;
			}

			var rowId = row.RowId;
			var isDefault = row.IsDefault;

			var venderCode = $("#VenderCode").val();
			var signType = $("#SignType").combobox("getValue");
			if (venderCode === "") {
				$.messager.alert("提示", "厂商代码不能为空", "error");
				return;
			}
			if (signType === "") {
				$.messager.alert("提示", "签名类型不能为空", "error");
				return;
			}
			var signDesc = $("#SignDesc").val();

			var configData = [{
				VenderCode: venderCode,
				SignType: signType,
				SignDesc: signDesc,
				IsDefault: isDefault,
				RowId: rowId,
				ClassName: "CF.AN.CASignConfig"
			}];
			dhccl.saveDatas(ANCSP.DataListService, {
				jsonData: dhccl.formatObjects(configData)
			}, function (result) {
				dhccl.showMessage(result, "保存", null, null, function () {
					$("#VenderCode").val("");
					$("#SignType").combobox("setValue", "");
					$("#SignDesc").val("");
					$("#dataBox1").datagrid("reload");
					loadDefaultSign();
				});
			});
		}
	});

	$("#btnDel").linkbutton({
		onClick: function () {
			var row = $("#dataBox1").datagrid("getSelected");
			if (!row) {
				$.messager.alert("提示", "请选择一行", "error");
				return;
			}

			$.messager.confirm('确认', '你是否确认删除?', function (r) {
				if (r) {
					var rowId = row.RowId;
					var result = dhccl.removeData("CF.AN.CASignConfig", rowId);

					dhccl.showMessage(result, "删除", null, null, function () {
						$("#VenderCode").val("");
						$("#SignType").combobox("setValue", "");
						$("#SignDesc").val("");
						$("#dataBox1").datagrid("reload");
						$("#dataBox2").datagrid("reload");
						loadDefaultSign();
					});
				}
			});
		}
	});

	$("#dataBox2").datagrid({
		fit: true,
		singleSelect: true,
		rownumbers: true,
		headerCls: "panel-header-gray",
		bodyCls: "panel-header-gray",
		iconCls:"icon-paper",
		title: "签名配置明细",
		url: ANCSP.DataQuery,
		columns: [
			[{
					field: "RowId",
					title: "RowId",
					width: 120,
					hidden: true
				}, {
					field: "CASignConfig",
					title: "CASignConfig",
					width: 120,
					hidden: true
				}, {
					field: "Key",
					title: "键",
					width: 120
				},
				{
					field: "Value",
					title: "值",
					width: 300
				}
			]
		],
		toolbar: "#dataTools2",
		onClickRow: function (rowIndex, rowData) {
			$("#Key").val(rowData.Key);
			$("#Value").val(rowData.Value);
		},
		onBeforeLoad: function (param) {
			var configId = "";
			var row = $("#dataBox1").datagrid("getSelected");
			if (row) configId = row.RowId;
			param.ClassName = "CIS.AN.CA.SignService";
			param.QueryName = "FindCASignConfigOption";
			param.Arg1 = configId;
			param.ArgCnt = 1;
		}
	});

	$("#btnAddOption").linkbutton({
		onClick: function () {
			var row = $("#dataBox1").datagrid("getSelected");
			if (!row) {
				$.messager.alert("提示", "请选择一行签名配置", "error");
				return;
			}

			var configId = row.RowId;

			var key = $("#Key").val();
			var value = $("#Value").val();
			if (key === "") {
				$.messager.alert("提示", "键不能为空", "error");
				return;
			}
			if (value === "") {
				$.messager.alert("提示", "值不能为空", "error");
				return;
			}

			var configOptionData = [{
				CASignConfig: configId,
				Key: key,
				Value: value,
				RowId: "",
				ClassName: "CF.AN.CASignConfigOption"
			}];
			dhccl.saveDatas(ANCSP.DataListService, {
				jsonData: dhccl.formatObjects(configOptionData)
			}, function (result) {
				dhccl.showMessage(result, "保存", null, null, function () {
					$("#Key").val("");
					$("#Value").val("");
					$("#dataBox2").datagrid("reload");
				});
			});
		}
	});

	$("#btnEditOption").linkbutton({
		onClick: function () {
			var row = $("#dataBox2").datagrid("getSelected");
			if (!row) {
				$.messager.alert("提示", "请选择一行签名配置明细", "error");
				return;
			}

			var rowId = row.RowId;
			var configId = row.CASignConfig;

			var key = $("#Key").val();
			var value = $("#Value").val();
			if (key === "") {
				$.messager.alert("提示", "键不能为空", "error");
				return;
			}
			if (value === "") {
				$.messager.alert("提示", "值不能为空", "error");
				return;
			}

			var configData = [{
				CASignConfig: configId,
				Key: key,
				Value: value,
				RowId: rowId,
				ClassName: "CF.AN.CASignConfigOption"
			}];
			dhccl.saveDatas(ANCSP.DataListService, {
				jsonData: dhccl.formatObjects(configData)
			}, function (result) {
				dhccl.showMessage(result, "保存", null, null, function () {
					$("#Key").val("");
					$("#Value").val("");
					$("#dataBox2").datagrid("reload");
				});
			});
		}
	});

	$("#btnDelOption").linkbutton({
		onClick: function () {
			var row = $("#dataBox2").datagrid("getSelected");
			if (!row) {
				$.messager.alert("提示", "请选择一行", "error");
				return;
			}

			$.messager.confirm('确认', '你是否确认删除?', function (r) {
				if (r) {
					var rowId = row.RowId;
					var result = dhccl.removeData("CF.AN.CASignConfigOption", rowId);

					dhccl.showMessage(result, "删除", null, null, function () {
						$("#Key").val("");
						$("#Value").val("");
						$("#dataBox2").datagrid("reload");
					});
				}
			});
		}
	});

	function loadDefaultSign() {
		var signDataList = dhccl.getDatas(ANCSP.DataQuery, {
			ClassName: "CIS.AN.CA.SignService",
			QueryName: "FindCASignConfig",
			ArgCnt: 0,
		}, "json");

		$('#DefaultSign').combogrid({
			panelWidth: 400,
			idField: 'RowId',
			textField: 'SignDesc',
			data: signDataList,
			columns: [
				[{
						field: "VenderCode",
						title: "签名厂商代码",
						width: 120
					},
					{
						field: "SignType",
						title: "签名类型",
						width: 80
					},
					{
						field: "SignDesc",
						title: "说明",
						width: 150
					},
					{
						field: "IsDefault",
						title: "是否默认",
						width: 200,
						hidden: true
					},
					{
						field: "IsDefaultDesc",
						title: "是否默认描述",
						width: 200,
						hidden: true
					},
					{
						field: "RowId",
						title: "RowId",
						width: 200,
						hidden: true
					},
				]
			]
		});

		var defaultSignId = "";
		for (var i = 0; i < signDataList.length; i++) {
			if (signDataList[i].IsDefault === "Y") {
				defaultSignId = signDataList[i].RowId;
				break;
			}
		}

		$('#DefaultSign').combogrid("setValue", defaultSignId);

		$("#dataBox1").datagrid("reload");
	}

	loadDefaultSign();

	$("#btnSaveDefaultSign").linkbutton({
		onClick: function () {
			var configId = $('#DefaultSign').combogrid("getValue");
			if (configId) {
				var result = dhccl.runServerMethodNormal("CIS.AN.CA.SignService", "SaveDefaultSignConfig", configId);
				dhccl.showMessage(result, "保存默认签名", null, null, function () {
					loadDefaultSign();
				});
			} else {
				$.messager.alert("提示", "请选择默认签名");
			}
		}
	});

	$("#jsPath_grid").datagrid({
		singleSelect: true,
		rownumbers: true,
		headerCls: "panel-header-gray",
		bodyCls: "panel-header-gray",
		title: "",
		width:1020,
		height:463,
		url: ANCSP.DataQuery,
		columns: [
			[{
					field: "JScriptPath",
					title: "加载其他js路径",
					width: 500
				},
				{
					field: "Note",
					title: "说明",
					width: 400
				},
				{
					field: "CASignConfig",
					title: "CA签名配置Id",
					width: 1,
					hidden: true
				},
				{
					field: "RowId",
					title: "RowId",
					width: 1,
					hidden: true
				},
			]
		],
		toolbar: "",
		onClickRow: function (rowIndex, rowData) {
			$("#JScriptPath").val(rowData.JScriptPath);
			$("#Note").val(rowData.Note);
		},
		onBeforeLoad: function (param) {
			param.ClassName = "CIS.AN.CA.SignService";
			param.QueryName = "FindCASignScript";
			param.Arg1 = currentConfigId;
			param.ArgCnt = 1;
		}
	});

	$("#btnAddJsPath").linkbutton({
		onClick: function () {
			if (!currentConfigId) {
				$.messager.alert("提示", "请选择一行签名配置", "error");
				return;
			}

			var jScriptPath = $("#JScriptPath").val();
			var note = $("#Note").val();
			if (jScriptPath === "") {
				$.messager.alert("提示", "js路径不能为空", "error");
				return;
			}

			var jsPathData = [{
				CASignConfig: currentConfigId,
				JScriptPath: jScriptPath,
				Note: note,
				RowId: "",
				ClassName: "CF.AN.CASignScript"
			}];
			dhccl.saveDatas(ANCSP.DataListService, {
				jsonData: dhccl.formatObjects(jsPathData)
			}, function (result) {
				dhccl.showMessage(result, "保存", null, null, function () {
					$("#JScriptPath").val("");
					$("#Note").val("");
					$("#jsPath_grid").datagrid("reload");
				});
			});
		}
	});

	$("#btnEditJsPath").linkbutton({
		onClick: function () {
			if (!currentConfigId) {
				$.messager.alert("提示", "请选择一行签名配置", "error");
				return;
			}

			var row = $("#jsPath_grid").datagrid("getSelected");
			if (!row) {
				$.messager.alert("提示", "请选择一行Js路径维护", "error");
				return;
			}

			var rowId = row.RowId;

			var jScriptPath = $("#JScriptPath").val();
			var note = $("#Note").val();
			if (jScriptPath === "") {
				$.messager.alert("提示", "js路径不能为空", "error");
				return;
			}

			var jsPathData = [{
				CASignConfig: currentConfigId,
				JScriptPath: jScriptPath,
				Note: note,
				RowId: rowId,
				ClassName: "CF.AN.CASignScript"
			}];
			dhccl.saveDatas(ANCSP.DataListService, {
				jsonData: dhccl.formatObjects(jsPathData)
			}, function (result) {
				dhccl.showMessage(result, "保存", null, null, function () {
					$("#JScriptPath").val("");
					$("#Note").val("");
					$("#jsPath_grid").datagrid("reload");
				});
			});
		}
	});

	$("#btnDelJsPath").linkbutton({
		onClick: function () {
			var row = $("#jsPath_grid").datagrid("getSelected");
			if (!row) {
				$.messager.alert("提示", "请选择一行", "error");
				return;
			}

			$.messager.confirm('确认', '你是否确认删除?', function (r) {
				if (r) {
					var rowId = row.RowId;
					var result = dhccl.removeData("CF.AN.CASignScript", rowId);

					dhccl.showMessage(result, "删除", null, null, function () {
						$("#JScriptPath").val("");
						$("#Note").val("");
						$("#jsPath_grid").datagrid("reload");
					});
				}
			});
		}
	});

	$("#JsPathDetailsDialog").dialog({
		title: "加载其他js路径维护",
		iconCls:"icon-w-edit",
		width:1040,
		buttons:[{
			text:"退出",
			iconCls:"icon-w-cancel",
			handler:function(){
				$("#JsPathDetailsDialog").dialog("close");
			}
		}],
		onClose: function(){
			$("#JScriptPath").val("");
			$("#Note").val("");
		}
	});
	
});

function showJSPathView(configId) {
	currentConfigId = configId;
	$("#JsPathDetailsDialog").dialog("open");
	$("#jsPath_grid").datagrid("reload");
}

function showCAConfigTestView(para){
	
	var url = "cf.an.casigntest.csp?" + para;
	var href="<iframe scrolling='yes' frameborder='0' src='" + url + "' style='width:100%;height:100%'></iframe>";
    $("#CAConfigTestDialog").dialog({
        content:href,		
		headerCls: "panel-header-gray",
		bodyCls: "panel-header-gray",
        title:"CA签名测试",
        iconCls:"icon-w-edit",
        resizable:true,
        width:608,
		height:652,
    });
	$("#CAConfigTestDialog").dialog("open");
	//var width = 900;  
	//var height = 600;
	//var top = (window.screen.height - 30 - height) / 2;
	//var left = (window.screen.width - 30 - width) / 2;
	//window.open(url, 'newwindow', 'height='+height+', width='+width+', top='+top+', left='+left+', toolbar=no, menubar=no, scrollbars=no, resizable=no,location=n o, status=no');
}