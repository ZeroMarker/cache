/**
 * @description ҩƷά��-ҽ����
 */
var ARCITMMAST_RowId = "";
var ARCITMMAST_KeyWord = "";
var ARCITMMAST_Style = {
	ComboWidth: 237
};

function ARCITMMAST() {
	$.parser.parse($("#lyArcItmMast").parent());
	InitGridARCItmMast();
	InitGridARCSKTINFO();
	InitGridDHCArcItemAut();
	InitDictARCItmMast();
	InitKeyWordARCItmMast();
	InitDiagDrugUom();
	$("#btnCleanArcim").on("click", ClrARCItmMast);
	$("#btnFindArcim").on("click", QueryARCItmMast);
	$('#conArcimAlias').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			QueryARCItmMast();
			$('#conArcimAlias').focus().select();
		}
	});
	$("#btnAddARCItmMast").on("click", function () {
		PHA.Confirm("��ʾ", "��ȷ��������?", function () {
			AddARCItmMast();
			ARCItmMastControler();
		});
	});
	$("#btnSaveARCItmMast").on("click", function () {
		if (PHA_COM.Param.App.SaveConfirm === "Y"){
			PHA.ConfirmPrompt("������ʾ", "��ȷ��<span style='font-weight:bold;'> ���� </span>�� ?", function(){
				SaveARCItmMast("");
			});
		}else{
			PHA.Confirm("��ʾ", "��ȷ�ϱ�����?", function () {
				SaveARCItmMast("");
			});
		}
	});
	$("#btnSaveAsARCItmMast").on("click",ShowARCItmMastSaveAs);
	$("#btnMaxARCItmMast").on("click", function () {
		PHA_UX.MaxCode({
			tblName: "ARC_ItmMast",
			codeName: "ARCIM_Code",
			title: "��ѯҽ���������"
		}, function (code) {
			$("#arcimCode").val(code);
		});
	});
	$("#btnAliasARCItmMast").on("click", AliasARCItmMast);
	$("#btnPHCFormDoseEquiv").on("click", PHCFormDoseEquiv);
	$("#btnAddARCItmMastINCItm").on("click", AddARCItmMastINCItm);
	$('#btnEditDrugUom').on('click', DrugUomHandler);
	MakeToolTip();
}

/**
 * @description ��ʼ���ؼ���
 */
function InitKeyWordARCItmMast() {
	$("#kwARCItmMast").keywords({
		singleSelect: true,
		onClick: function (v) {
			var vId = v.id;
			if (ARCITMMAST_RowId == "") {
				if ((vId == "kwARCItmMastLimit") || (vId == "kwARCItmMastSkinLink")) {
					PHA.Popover({
						msg: 'û��ѡ��ҩƷ,�����������,���ȱ���',
						type: 'alert'
					});
					// $("#kwARCItmMast").keywords("select", vId);
				}
			}
			if (vId == "kwARCItmMastAll") {
				$("[name='kwARCItmMastGrp']").show();
			} else {
				$("[name='kwARCItmMastGrp']").hide();
				$("[name='kwARCItmMastGrp']#" + vId).show();
			}
			$("#gridDHCArcItemAut").datagrid("resize", {
				width: 300,
				height: 300
			});
			$("#gridARCSKTINFO").datagrid("resize", {
				width: 300,
				height: 300
			});
			ARCITMMAST_KeyWord = vId;
		},
		items: [{
				text: 'ȫ����Ϣ',
				id: 'kwARCItmMastAll'
			},
			{
				text: '������Ϣ',
				id: 'kwARCItmMastBase'
			},
			{
				text: 'ҩѧ��Ϣ',
				id: 'kwARCItmMastPhc'
			},
			{
				text: '������ҩ',
				id: 'kwARCItmMastLimit'
			}
		]
	});
	$("#kwARCItmMast").keywords("select", "kwARCItmMastAll");
}

/**
 * @description ��ʼ�������ֵ�
 */
function InitDictARCItmMast() {
	var opts = $.extend({}, PHA_STORE.PHCGeneric(), {
		width: 494
	})
	PHA.LookUp("conPhcGene", opts);
	var opts = $.extend({}, PHA_STORE.PHCGeneric(), {
		width: 588,
	});
	PHA.LookUp("phcGene", opts);
	PHA.ComboBox("conArcimStat", {
		panelHeight: "auto",
		data: [{
			RowId: "ALL",
			Description: "ȫ��"
		}, {
			RowId: "ACTIVE",
			Description: "����"
		}, {
			RowId: "STOP",
			Description: "ͣ��"
		}]
	});
	$("#conArcimStat").combobox("setValue","ALL");
	PHA.ComboBox("conArcimOrdCat", {
		url: PHA_STORE.OECOrderCategory().url,
		onSelect: function (data) {
			$("#conArcimItemCat").combobox("reload", PHA_STORE.ARCItemCat().url + "&InputStr=" + data.RowId || "");
			$("#conArcimItemCat").combobox("clear");
		}
	});
	PHA.ComboBox("conArcimItemCat", {
		mode:"remote",
		url: PHA_STORE.ARCItemCat().url,
		onBeforeLoad: function (param) {
			param.QText = param.q;
			param.InputStr=$("#conArcimOrdCat").combobox("getValue")||""
		}
	});
	PHA.ComboBox("arcimBillGrp", {
		url: PHA_STORE.ARCBillGrp().url,
		width: ARCITMMAST_Style.ComboWidth,
		onSelect: function (data) {
			$("#arcimBillSub").combobox("reload", PHA_STORE.ARCBillSub().url + "&InputStr=" + data.RowId || "");
			$("#arcimBillSub").combobox("clear");
		}
	});
	PHA.ComboBox("arcimBillSub", {
		mode:"remote",
		url: PHA_STORE.ARCBillSub().url,
		width: ARCITMMAST_Style.ComboWidth,
		onBeforeLoad: function (param) {
			param.QText = param.q;
			param.InputStr = $("#arcimBillGrp").combobox("getValue")||""
		}
	});
	PHA.ComboBox("arcimOrdCat", {
		url: PHA_STORE.OECOrderCategory().url,
		width: ARCITMMAST_Style.ComboWidth,
		onSelect: function (data) {
			$("#arcimItemCat").combobox("reload", PHA_STORE.ARCItemCat().url + "&InputStr=" + data.RowId || "");
			$("#arcimItemCat").combobox("clear");
		}
	});
	PHA.ComboBox("arcimItemCat", {
		mode:"remote",
		url: PHA_STORE.ARCItemCat().url,
		width: ARCITMMAST_Style.ComboWidth,
		onBeforeLoad: function (param) {
			param.QText = param.q;
			param.InputStr=$("#arcimOrdCat").combobox("getValue")||""
		}
	});
	PHA.ComboBox("phcUom", {
		url: PHA_STORE.CTUOM().url,
		width: ARCITMMAST_Style.ComboWidth,
		onSelect: function (data) {
			var newUrl = PHA_STORE.WHODDDUOM().url + "&Arcim=" + ARCITMMAST_RowId;
			$("#phcWHODDDUom").combobox("reload", newUrl).combobox("clear");
		}
	});
	PHA.ComboBox("phcWHODDDUom", {
		url: PHA_STORE.WHODDDUOM().url,
		width: 120,
		panelHeight:"auto",
		onShowPanel:function(){
			if (ARCITMMAST_RowId==""){
				$(this).combobox("clear").combobox('loadData', []);
			}
		},
		onSelect: function (data) {
			CalcuDDD();
		}
	});
	PHA.ComboBox("arcimPri", {
		url: PHA_STORE.OECPriority().url,
		width: ARCITMMAST_Style.ComboWidth
	});
	PHA.ComboBox("phcPoison", {
		url: PHA_STORE.PHCPoison().url,
		width: ARCITMMAST_Style.ComboWidth
	});
	PHA.ComboBox("phcFreq", {
		url: PHA_STORE.PHCFreq().url,
		width: ARCITMMAST_Style.ComboWidth
	});
	PHA.ComboBox("phcDura", {
		url: PHA_STORE.PHCDuration().url,
		width: ARCITMMAST_Style.ComboWidth
	});
	PHA.ComboBox("phcInstuc", {
		url: PHA_STORE.PHCInstruc().url,
		width: ARCITMMAST_Style.ComboWidth
	});
	PHA.ComboBox("phcHighRisk", {
		//url: PHA_STORE.PHCDFHighRisk().url,
		url: PHA_STORE.ComDictionary("HighRiskType").url,//��Ϊȡͨ���ֵ� WangYaJun 2019-07-24
		width: ARCITMMAST_Style.ComboWidth,
		panelHeight: "auto"
	});
	PHA.ComboBox("phcOTC", {
		url: PHA_STORE.DHCSTOFFICODE("Gpp").url,
		width: ARCITMMAST_Style.ComboWidth,
		panelHeight: "auto"
	});
	PHA.ComboBox("phcCHSpec", {
		url: PHA_STORE.PHCDFCHPhSpecInstr().url,
		width: ARCITMMAST_Style.ComboWidth
	});
	var opts = $.extend({}, PHA_STORE.WHONET(), {
		width: ARCITMMAST_Style.ComboWidth
	})
	PHA.LookUp("phcWHONET", opts);

	var numArr = [
		"#arcimNoOfCumDays",
		"#arcimMaxQty",
		"#arcimWarnQty",
		"#arcimMaxCumDose",
		"#arcimMaxQtyDay",
		"#phcGranulesFac",
		"#phcDDD"
	];
	PHA.NumberBox(numArr.join(","), {
		width: ARCITMMAST_Style.ComboWidth - 1,
		precision: 4,
		min: 0
	}, "$")
	PHA.NumberBox("phcWHODDD", {
		width: 112,
		precision: 4,
		min: 0
	})

	PHA.DateBox("#arcimStDate,#arcimEdDate", {
		width: ARCITMMAST_Style.ComboWidth
	}, "$");

	$("#phcWHODDD").on("blur", CalcuDDD);
}


/**
 * @description ��ʼ��ҽ������
 */
function InitGridARCItmMast() {
	var columns = [
		[{
				field: "arcimId",
				title: 'arcimId',
				width: 100,
				hidden: true
			},
			{
				field: "arcimCode",
				title: '����',
				width: 150
			},
			{
				field: "arcimDesc",
				title: '����',
				width: 300
			},
			{
				field: "geneName",
				title: '����ͨ����',
				width: 200
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.IN.ARCItmMast.Query',
			QueryName: 'ARCItmMast',
			IsNull: "Y",
			HospId: PHA_COM.Session.HOSPID
		},
		pagination: true,
		columns: columns,
		fitColumns: false,
		toolbar: "#gridARCItmMastBar",
		enableDnd: false,
		onSelect: function (rowIndex, rowData) {
			ARCITMMAST_RowId = rowData.arcimId;
			QueryARCItmMastDetail();
		},
		onDblClickRow: function (rowIndex, rowData) {
			SwitchToINCItm(rowData.arcimId, "");
		},
		onLoadSuccess: function (data) {
			// alert(JSON.stringify($(this).datagrid("options").queryParams))
			// alert(JSON.stringify(data))
			// �״��л�������DRUG_SwitchType�Ǹ���
			if (DRUG_SwitchType == "") {
				var pageSize = $("#gridARCItmMast").datagrid('getPager').data("pagination").options.pageSize;
				var total = data.total;
				if ((data.curPage > 0) && (total > 0) && (total <= pageSize)) {
					$("#gridARCItmMast").datagrid("selectRow", 0)
				}
			}else{
				DRUG_SwitchType="";
			}
			ARCItmMastControler();
		}
	};
	PHA.Grid("gridARCItmMast", dataGridOption);
}

/**
 * @description	��ѯ���
 * @params:		inciId ������л�ҽ����ʱ,�ɴ��ò���
 */
function QueryARCItmMast(inciId) {
	inciId = inciId || "" ;
	if (typeof(inciId)=="object"){
		inciId="";
	}
	CleanARCItmMastDetail();
	var valsArr = PHA.DomData("#gridARCItmMastBar", {
		doType: "query"
	});
	var valsStr = valsArr.join("^");
	$("#gridARCItmMast").datagrid("query", {
		InputStr: valsStr,
		IsNull: "",
		InciId:inciId
	});
}

/**
 * @description ����
 */
function AddARCItmMast() {
	$("#gridARCItmMast").datagrid("clearSelections");
	CleanARCItmMastDetail();
	$("#phcGene").focus();
	ARCITMMAST_RowId = "";
}

/**
 * @description ����
 */
function ClrARCItmMast() {
	PHA.DomData("#gridARCItmMastBar", {
		doType: "clear"
	});
	$("#conArcimStat").combobox("setValue","ALL");
	$("#conArcimItemCat").combobox("reload");
}

/**
 * @description ����
 * @param {String} saveType 
 * @param {String} copyType ���ҽ������ͬʱ��ת�����ʱ��Ϊ��
 */
function SaveARCItmMast(saveType, copyType) {
	saveType = saveType || "";
	copyType = copyType || "";
	if (saveType != "") {
		$("#PHA_ARCITMMAST_SAVEAS").dialog("close");
	}
	var valsArr = PHA.DomData("#dataARCItmMast", {
		doType: "save",
		retType: "Json"
	});
	var valsStr = valsArr.join("^");
	if (valsStr == "") {
		return;
	}
	var jsonDataStr = JSON.stringify(valsArr[0]);
	var saveRet = $.cm({
		ClassName: 'PHA.IN.ARCItmMast.Save',
		MethodName: 'SaveArcPhc',
		ArcimId: saveType == "" ? ARCITMMAST_RowId : "",
		JsonDataStr: jsonDataStr,
		LogonStr: PHA_COM.Session.ALL,
		dataType: 'text'
	}, false);
	if (saveRet.indexOf("msg") >= 0) {
		PHA.Alert('��ʾ', saveRet, "error");
		return;
	}
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert('��ʾ', saveInfo, saveVal);
		return;
	} else {
		PHA.Popover({
			msg: saveType == "" ? "����ɹ�" : "���ɹ�",
			type: 'success'
		});
		if (copyType != "") {
			SwitchToINCItm(saveVal, "AddInci", ARCITMMAST_RowId);
		}
		ARCITMMAST_RowId = saveVal;
		QueryARCItmMastDetail();
	}
}

/**
 * @description ��ѯ�Ҳ���ϸ
 */
function QueryARCItmMastDetail() {
	ARCItmMastControler();
	$.cm({
		ClassName: 'PHA.IN.ARCItmMast.Query',
		MethodName: 'SelectARCItmMast',
		ArcimId: ARCITMMAST_RowId,
		ResultSetType: 'Array'
	}, function (arrData) {
		PHA.DomData("#dataARCItmMast", {
			doType: "clear"
		});
		if (arrData.msg) {
			PHA.Alert("������ʾ", arrData.msg, "error");
		} else {
			PHA.SetVals(arrData);
			$("#gridARCSKTINFO").datagrid("query", {
				ArcimId: ARCITMMAST_RowId
			});
			$("#gridDHCArcItemAut").datagrid("query", {
				ArcimId: ARCITMMAST_RowId
			});
		}
	})
}

/**
 * @description ���Ҳ���ϸ
 */
function CleanARCItmMastDetail() {
	PHA.DomData("#dataARCItmMast", {
		doType: "clear"
	});
	$("#gridARCSKTINFO").datagrid("clear");
	$("#gridDHCArcItemAut").datagrid("clear");
	$("#arcimBillSub").combobox("reload");
	$("#arcimItemCat").combobox("reload");
		
	ARCITMMAST_RowId = "";
}

/**
 * @description ���������
 */
function AddARCItmMastINCItm() {
	if (ARCITMMAST_RowId == "") {
		PHA.Popover({
			msg: '����ѡ��ҽ����,��������������ȱ���',
			type: 'alert'
		});
		return;
	}
	SwitchToINCItm(ARCITMMAST_RowId, "AddInci")
}
/**
 * @description �л�ҳǩ
 * @param {String} arcimId ҽ����Id
 * @param {String} type �л���ʽ(AddInci:���������)
 * @param {String} origArcimId ���ǰ��ҽ����Id
 * 
 */
function SwitchToINCItm(arcimId, type, origArcimId) {
	if (type == "AddInci") {
		var chkRet = $.cm({
			ClassName: 'PHA.IN.Drug.Switch',
			MethodName: 'CheckARCItmMastToINCItm',
			ArcimId: arcimId,
			dataType: 'text'
		}, false);
		var chkArr = chkRet.toString().split('^');
		if (chkArr[0] < 0) {
			PHA.Popover({
				msg: '�ѹ��������,�����л��������',
				type: 'alert'
			});
			return;
		}
	}
	origArcimId = origArcimId || "";
	$('#tabsDrug').tabs("select", "�����");
	$.cm({
		ClassName: 'PHA.IN.Drug.Switch',
		MethodName: 'ARCItmMastToINCItm',
		ArcimId: arcimId,
		Type: type,
		OrigArcimId: origArcimId,
		ResultSetType: 'Array'
	}, function (arrData) {
		if (arrData.msg) {
			PHA.Alert("������ʾ", arrData.msg, "error");
		} else {
			ClrINCItm();
			PHA.SetVals(arrData);
			DRUG_SwitchType = type;
			QueryINCItm();
			PHA.SetVals(arrData);
			if (type == "AddInci") {
				if (PHA_COM.Param.App.SameCode == "Y") {
					$("#inciCode").val($("#arcimCode").val());
				}
				if (PHA_COM.Param.App.SameDesc == "Y") {
					$("#inciDesc").val($("#arcimDesc").val());
				}
			}
			INCItmControler();
			if (origArcimId != "") {
				$("#btnSaveAsINCItm").click();
			}
		}
	})
}
/**
 * @description ��Ч��λά��
 */
function PHCFormDoseEquiv() {
	if (ARCITMMAST_RowId == "") {
		PHA.Popover({
			msg: 'û��ѡ��ҩƷ,�����������,���ȱ���',
			type: 'alert'
		});
		return;
	}
	$('#diagPHCFormDoseEquiv').dialog({
		iconCls: 'icon-w-edit',
		modal: true,
		onBeforeClose: function () {
			$.cm({
				ClassName: 'PHA.IN.PHCFormDoseEquiv.Query',
				MethodName: 'GetEqUomStr',
				ArcimId: ARCITMMAST_RowId,
				dataType: 'text'
			}, function (text) {
				$("#phcEqData").val(text);
				$("#phcWHODDDUom").combobox("reload");
			})
		}
	}).dialog('open');

	var eqUom = PHA.EditGrid.ComboBox({
		required: true,
		tipPosition: "top",
		url: PHA_STORE.CTUOM().url
	});
	var columns = [
		[{
				field: "eqId",
				title: '��Ч��λId',
				hidden: true,
				width: 100
			},
			{
				field: "eqUom",
				title: '��Ч��λ',
				width: 100,
				editor: eqUom,
				descField: "eqUomDesc",
				formatter: function (value, row, index) {
					return row.eqUomDesc
				}
			},
			{
				field: "eqUomDesc",
				title: '��Ч��λ����',
				width: 50,
				hidden: true
			},
			{
				field: "eqQty",
				title: '��Ч����',
				width: 100,
				align: "right",
				editor: {
					type: 'numberbox',
					options: {
						tipPosition: "top",
						required: true,
						precision: 5
					}
				}
			},
			{
				field: "eqDefQty",
				title: 'ȱʡ����',
				width: 100,
				align: "right",
				editor: {
					type: 'numberbox',
					options: {
						precision: 5
					}
				}
			},
			{
				field: "eqDefFlag",
				title: 'Ĭ��',
				width: 50,
				align: "center",
				editor: {
					type: 'icheckbox',
					options: {
						on: 'Y',
						off: 'N'
					}
				},
				formatter: function (value, row, index) {
					if (value == "Y") {
						return PHA_COM.Fmt.Grid.Yes.Chinese;
					} else {
						return PHA_COM.Fmt.Grid.No.Chinese;
					}
				}
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: "PHA.IN.PHCFormDoseEquiv.Query",
			QueryName: "PHCFormDoseEquiv",
			ArcimId: ARCITMMAST_RowId
		},
		pagination: false,
		columns: columns,
		fitColumns: false,
		enableDnd: false,
		onClickRow: function (rowIndex, rowData) {
			$(this).datagrid("endEditing");
		},
		onDblClickCell: function (rowIndex, field, value) {
			$(this).datagrid('beginEditRow', {
				rowIndex: rowIndex
			});
		},
		toolbar: [{
				iconCls: 'icon-add',
				text: '����',
				handler: function () {
					var $grid = $("#gridPHCFormDoseEquiv");
					if (ARCITMMAST_RowId == "") {
						PHA.Popover({
							msg: 'û��ѡ��ҩƷ,�����������,���ȱ���',
							type: 'alert'
						});
						return;
					}
					$grid.datagrid('addNewRow', {
						editField: "eqUom"
					});
				}
			}, {
				iconCls: 'icon-save',
				text: '����',
				handler: function () {
					var $grid = $("#gridPHCFormDoseEquiv");
					if ($grid.datagrid('endEditing')==false){
						PHA.Popover({
								msg: "������ɱ�����",
								type: 'alert'
							});
							return;
					}
					var rows=$grid.datagrid('getRows');
					var delCnt=0;
					for (var rowI=0;rowI<rows.length;rowI++){
						var rowData=rows[rowI];
						if ((rowData.eqDefFlag || "")=="Y"){
							delCnt++;
							if (delCnt>1){
								PHA.Popover({
									msg: "��������һ����Ч��λ��ΪĬ��",
									type: 'alert'
								});
								return;					
							}
						}
					}
					var gridChanges = $grid.datagrid('getChanges');
					var gridChangeLen = gridChanges.length;
					if (gridChangeLen == 0) {
						PHA.Popover({
							msg: "û����Ҫ���������",
							type: 'alert'
						});
						return;
					}
					var inputStrArr = [];
					for (var i = 0; i < gridChangeLen; i++) {
						var iData = gridChanges[i];
						if ($grid.datagrid('getRowIndex', iData) < 0) {
							continue;
						}
						var params = (iData.eqId || "") + "^" + (iData.eqUom || "") + "^" + (iData.eqQty || "") + "^" + (iData.eqDefQty || "") + "^" + (iData.eqDefFlag || "");
						inputStrArr.push(params)
					}
					var inputStr = inputStrArr.join("!!");
					var saveRet = $.cm({
						ClassName: "PHA.IN.PHCFormDoseEquiv.Save",
						MethodName: "SaveMulti",
						ArcimId: ARCITMMAST_RowId,
						MultiDataStr: inputStr,
						dataType: "text"
					}, false);
					var saveArr = saveRet.split('^');
					var saveVal = saveArr[0];
					var saveInfo = saveArr[1];
					if (saveVal < 0) {
						PHA.Alert('��ʾ', saveInfo, saveVal);
					} else {
						// ��������,�ɹ�ֱ��ˢ��
						$grid.datagrid("reload");
					}
				}
			},
			{
				iconCls: 'icon-remove',
				text: 'ɾ��',
				handler: function () {
					var $grid = $("#gridPHCFormDoseEquiv");
					var gridSelect = $grid.datagrid("getSelected") || "";
					if (gridSelect == "") {
						PHA.Popover({
							msg: "����ѡ����Ҫɾ���ļ�¼",
							type: 'alert'
						});
						return;
					}
					PHA.Confirm("ɾ����ʾ", "��ȷ��ɾ����?", function () {
						var eqId = gridSelect.eqId || "";
						var rowIndex = $grid.datagrid('getRowIndex', gridSelect);
						if (eqId != "") {
							var saveRet = $.cm({
								ClassName: "PHA.IN.PHCFormDoseEquiv.Save",
								MethodName: "Delete",
								EqId: eqId,
								dataType: "text"
							}, false);
							var saveArr = saveRet.split('^');
							var saveVal = saveArr[0];
							var saveInfo = saveArr[1];
							if (saveVal < 0) {
								PHA.Alert('��ʾ', saveInfo, saveVal);
								return;
							}
						}
						$grid.datagrid("deleteRow", rowIndex);
					});
				}
			}
		]
	};
	PHA.Grid("gridPHCFormDoseEquiv", dataGridOption);
}
/**
 * @description ����ά��
 */
function AliasARCItmMast() {
	if (ARCITMMAST_RowId == "") {
		PHA.Popover({
			msg: 'û��ѡ��ҩƷ,�����������,���ȱ���',
			type: 'alert'
		});
		return;
	}
	PHA_UX.Alias({
		title: "ҽ�������",
		queryParams: {
			ClassName: "PHA.IN.ARCAlias.Query",
			QueryName: "ARCAlias",
			ArcimId: ARCITMMAST_RowId
		},
		saveParams: {
			ClassName: "PHA.IN.ARCAlias.Save",
			MethodName: "SaveMulti",
			ArcimId: ARCITMMAST_RowId
		},
		deleteParams: {
			ClassName: "PHA.IN.ARCAlias.Save",
			MethodName: "Delete"
		}
	}, function (text) {
		$.cm({
			ClassName: 'PHA.IN.ARCAlias.Query',
			MethodName: 'GetArcimAliasStr',
			ArcimId: ARCITMMAST_RowId,
			dataType: 'text'
		}, function (text) {
			$("#arcimAliasData").val(text);
		})
	});
}
/**
 * ������ҩ
 */
function InitGridDHCArcItemAut() {
	var pointerUrl = $URL + "?ResultSetType=Array&ClassName=PHA.IN.DHCArcItemAut.Query&QueryName=AutTypePointer&HospId="+PHA_COM.Session.HOSPID;
	var autRelation = PHA.EditGrid.ComboBox({
		required: true,
		editable: false,
		tipPosition: "top",
		data: [{
			RowId: "AND",
			Description: "����"
		}, {
			RowId: "OR",
			Description: "����"
		}]
	});
	var autType = PHA.EditGrid.ComboBox({
		required: true,
		editable: false,
		tipPosition: "top",
		data: [{
			RowId: "KS",
			Description: "����"
		}, {
			RowId: "ZC",
			Description: "ְ��"
		}, {
			RowId: "YS",
			Description: "ҽ��"
		}, {
			RowId: "JB",
			Description: "���˼���"
		}],
		onSelect: function (data) {
			ReLoadPointer();
		}
	});
	var autOperate = PHA.EditGrid.ComboBox({
		required: true,
		editable: false,
		tipPosition: "top",
		data: [{
			RowId: "=",
			Description: "����"
		}, {
			RowId: "<>",
			Description: "������"
		}, {
			RowId: ">=",
			Description: "���ڵ���"
		}]
	});
	var autPointer = PHA.EditGrid.ComboBox({
		required: true,
		tipPosition: "top",
		mode: "remote"
	});
	var columns = [
		[{
				field: "autId",
				title: 'autId',
				width: 50,
				hidden: true
			},
			{
				field: "autRelation",
				title: '��ϵ',
				width: 100,
				descField: "autRelaDesc",
				editor: autRelation,
				formatter: function (value, row, index) {
					return row.autRelaDesc
				}

			},
			{
				field: "autRelaDesc",
				title: '��ϵ����',
				width: 100,
				hidden: true
			}, {
				field: "autType",
				title: '����',
				width: 100,
				descField: "autTypeDesc",
				editor: autType,
				formatter: function (value, row, index) {
					return row.autTypeDesc
				}
			}, {
				field: "autTypeDesc",
				title: '��������',
				width: 100,
				hidden: true
			}, {
				field: "autOperate",
				title: '����',
				width: 100,
				descField: "autOperateDesc",
				editor: autOperate,
				formatter: function (value, row, index) {
					return row.autOperateDesc
				}
			},
			{
				field: "autOperateDesc",
				title: '��������',
				width: 100,
				hidden: true
			}, {
				field: "autPointer",
				title: '����',
				width: 300,
				descField: "autPointerDesc",
				editor: autPointer,
				formatter: function (value, row, index) {
					return row.autPointerDesc
				}
			}, {
				field: "autPointerDesc",
				title: '��������',
				width: 300,
				hidden: true
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.IN.DHCArcItemAut.Query',
			QueryName: 'DHCArcItemAut'
		},
		pagination: false,
		columns: columns,
		fitColumns: true,
		autoRowHeight: true,
		toolbar: [{
			iconCls: 'icon-add',
			text: '����',
			handler: function () {
				if (ARCITMMAST_RowId == "") {
					PHA.Popover({
						msg: 'û��ѡ��ҩƷ,�����������,���ȱ���',
						type: 'alert'
					});
					return;
				}
				$("#gridDHCArcItemAut").datagrid('addNewRow', {
					editField: "autRelation"
				});
			}
		}, {
			iconCls: 'icon-save',
			text: '����',
			handler: function () {
				var $grid = $("#gridDHCArcItemAut");
				if ($grid.datagrid('endEditing')==false){
					PHA.Popover({
						msg: "������ɱ�����",
						type: 'alert'
					});
					return;
				}
				var gridChanges = $grid.datagrid('getChanges');
				var gridChangeLen = gridChanges.length;
				if (gridChangeLen == 0) {
					PHA.Popover({
						msg: "û����Ҫ���������",
						type: 'alert'
					});
					return;
				}
				var inputStrArr = [];
				for (var i = 0; i < gridChangeLen; i++) {
					var iData = gridChanges[i];
					if ($grid.datagrid('getRowIndex', iData) < 0) {
						continue;
					}
					var params = (iData.autId || "") + "^" + (iData.autRelation || "") + "^" + (iData.autType || "") + "^" + (iData.autOperate || "") + "^" + (iData.autPointer || "");
					inputStrArr.push(params)
				}
				var inputStr = inputStrArr.join("!!");
				var saveRet = $.cm({
					ClassName: "PHA.IN.DHCArcItemAut.Save",
					MethodName: "SaveMulti",
					ArcimId: ARCITMMAST_RowId,
					MultiDataStr: inputStr,
					dataType: "text"
				}, false);
				var saveArr = saveRet.split('^');
				var saveVal = saveArr[0];
				var saveInfo = saveArr[1];
				if (saveVal < 0) {
					PHA.Alert('��ʾ', saveInfo, saveVal);
				} else {
					// ��������,�ɹ�ֱ��ˢ��
					$grid.datagrid("reload");
				}
			}
		}, {
			iconCls: 'icon-remove',
			text: 'ɾ��',
			handler: function () {
				var gridSelect = $("#gridDHCArcItemAut").datagrid("getSelected") || "";
				if (gridSelect == "") {
					PHA.Popover({
						msg: "����ѡ����Ҫɾ���ļ�¼",
						type: 'alert'
					});
					return;
				}
				PHA.Confirm("ɾ����ʾ", "��ȷ��ɾ����?", function () {
					var autId = gridSelect.autId || "";
					var rowIndex = $('#gridDHCArcItemAut').datagrid('getRowIndex', gridSelect);
					if (autId != "") {
						var saveRet = $.cm({
							ClassName: "PHA.IN.DHCArcItemAut.Save",
							MethodName: "Delete",
							AutId: autId,
							dataType: "text"
						}, false);
						var saveArr = saveRet.split('^');
						var saveVal = saveArr[0];
						var saveInfo = saveArr[1];
						if (saveVal < 0) {
							PHA.Alert('��ʾ', saveInfo, saveVal);
							return;
						}
					}
					$('#gridDHCArcItemAut').datagrid("deleteRow", rowIndex);
				});
			}
		}],
		enableDnd: false,
		onClickRow: function (rowIndex, rowData) {
			$(this).datagrid("endEditing");
		},
		onDblClickCell: function (rowIndex, field, value) {
			$(this).datagrid('beginEditRow', {
				rowIndex: rowIndex
			});
			var editIndex = $(this).datagrid('options').editIndex;
			if (editIndex == rowIndex) {
				ReLoadPointer("Grid");
			}
		}
	};
	PHA.Grid("gridDHCArcItemAut", dataGridOption);

	function ReLoadPointer(LoadType) {
		LoadType = LoadType || "";
		var $grid = $("#gridDHCArcItemAut");
		// �˴��Դ��ڱ༭
		var editIndex = $grid.datagrid('options').editIndex;
		var autTypeEd = $grid.datagrid('getEditor', {
			index: editIndex,
			field: 'autType'
		});
		var autPointerEd = $grid.datagrid('getEditor', {
			index: editIndex,
			field: 'autPointer'
		});
		var $autPointer = $(autPointerEd.target);
		var $autType = $(autTypeEd.target);
		var typeId = $autType.combobox("getValue");
		var gridSelect = $grid.datagrid("getSelected");
		var pointerData = {
			RowId: gridSelect.autPointer,
			Description: gridSelect.autPointerDesc
		};
		$autPointer.combobox("loadData", [pointerData]);
		$autPointer.combobox("options").url = pointerUrl + "&Type=" + typeId
		// $autPointer.combobox("reload", pointerUrl + "&Type=" + typeId);
		if (LoadType == "") {
			$autPointer.combobox("reload");
			$autPointer.combobox("clear");
		} else {
			// $autPointer.combobox("reload")
		}
	}
}
/**
 * @description Ƥ��ҽ������
 */
function InitGridARCSKTINFO() {
	var options = {
		panelWidth: "500",
		required: true
	};
	options = $.extend({}, PHA_STORE.ArcItmMast("Y"), options);
	ARCSKTINFO_ArcimRea = PHA.EditGrid.ComboGrid(options)
	var columns = [
		[{
				field: "sktId",
				title: 'sktId',
				width: 50,
				hidden: true
			},
			{
				field: "sktArcReaCode",
				title: '����',
				width: 100
			},
			{
				field: "sktArcReaDr",
				title: '����',
				width: 300,
				hidden: false,
				descField: "sktArcReaDesc",
				editor: ARCSKTINFO_ArcimRea,
				formatter: function (value, row, index) {
					return row.sktArcReaDesc
				}
			},
			{
				field: "sktArcReaDesc",
				title: '��������',
				width: 300,
				hidden: true
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.IN.ARCSKTINFO.Query',
			QueryName: 'ARCSKTINFO'
		},
		pagination: false,
		columns: columns,
		fitColumns: true,
		toolbar: [{
			iconCls: 'icon-add',
			text: '����',
			handler: function () {
				if (ARCITMMAST_RowId == "") {
					PHA.Popover({
						msg: 'û��ѡ��ҩƷ,�����������,���ȱ���',
						type: 'alert'
					});
					return;
				}
				$("#gridARCSKTINFO").datagrid('addNewRow', {
					editField: "sktArcReaDr"
				});
			}
		}, {
			iconCls: 'icon-save',
			text: '����',
			handler: function () {
				var $grid = $("#gridARCSKTINFO");
				if ($grid.datagrid('endEditing')==false){
					PHA.Popover({
							msg: "������ɱ�����",
							type: 'alert'
						});
						return;
				}
				var gridChanges = $grid.datagrid('getChanges');
				var gridChangeLen = gridChanges.length;
				if (gridChangeLen == 0) {
					PHA.Popover({
						msg: "û����Ҫ���������",
						type: 'alert'
					});
					return;
				}
				var inputStrArr = [];
				for (var i = 0; i < gridChangeLen; i++) {
					var iData = gridChanges[i];
					if ($grid.datagrid('getRowIndex', iData) < 0) {
						continue;
					}
					var sktId=iData.sktId || "";
					var sktArcReaDr=iData.sktArcReaDr || "";
					var sktArcReaDesc=iData.sktArcReaDesc || "";
					if (sktArcReaDr==sktArcReaDesc){
						PHA.Popover({
							msg: "��"+sktArcReaDesc+"��,����ֵ����,���ѯ�����ݺ�ѡ�в���",
							type: 'alert'
						});	
						return;
					}
					var params = sktId + "^" +sktArcReaDr;
					inputStrArr.push(params)
				}
				var inputStr = inputStrArr.join("!!");
				var saveRet = $.cm({
					ClassName: "PHA.IN.ARCSKTINFO.Save",
					MethodName: "SaveMulti",
					ArcimId: ARCITMMAST_RowId,
					MultiDataStr: inputStr,
					dataType: "text"
				}, false);
				var saveArr = saveRet.split('^');
				var saveVal = saveArr[0];
				var saveInfo = saveArr[1];
				if (saveVal < 0) {
					PHA.Alert('��ʾ', saveInfo, saveVal);
				} else {
					// ��������,�ɹ�ֱ��ˢ��
					$grid.datagrid("reload");
				}
			}
		}, {
			iconCls: 'icon-remove',
			text: 'ɾ��',
			handler: function () {
				var gridSelect = $("#gridARCSKTINFO").datagrid("getSelected") || "";
				if (gridSelect == "") {
					PHA.Popover({
						msg: "����ѡ����Ҫɾ���ļ�¼",
						type: 'alert'
					});
					return;
				}
				PHA.Confirm("ɾ����ʾ", "��ȷ��ɾ����?", function () {
					var sktId = gridSelect.sktId || "";
					var rowIndex = $('#gridARCSKTINFO').datagrid('getRowIndex', gridSelect);
					if (sktId != "") {
						var saveRet = $.cm({
							ClassName: "PHA.IN.ARCSKTINFO.Save",
							MethodName: "Delete",
							SktId: sktId,
							dataType: "text"
						}, false);
						var saveArr = saveRet.split('^');
						var saveVal = saveArr[0];
						var saveInfo = saveArr[1];
						if (saveVal < 0) {
							PHA.Alert('��ʾ', saveInfo, saveVal);
							return;
						}
					}
					$('#gridARCSKTINFO').datagrid("deleteRow", rowIndex);
				})
			}
		}],
		enableDnd: false,
		onClickRow: function (rowIndex, rowData) {
			$(this).datagrid("endEditing");
		}
	};
	PHA.Grid("gridARCSKTINFO", dataGridOption);
}

/**
 * @description ����DDD
 */
function CalcuDDD() {
	var saveRet = $.cm({
		ClassName: 'PHA.IN.PHCDrgMast.Query',
		MethodName: 'CalcuDDD',
		ArcimId: ARCITMMAST_RowId,
		WHODDD: $("#phcWHODDD").val(),
		WHODDDUomId: PHA.DoVal("get", "hisui-combobox", "phcWHODDDUom"),
		dataType: 'text'
	}, false);
	$("#phcDDD").numberbox("setValue", saveRet);
}
/**
 * @description ���ƿɱ༭
 */
function ARCItmMastControler() {
	var controlJson = $.cm({
		ClassName: 'PHA.IN.ARCItmMast.Query',
		MethodName: 'Controller',
		ArcimId: ARCITMMAST_RowId,
		dataType: 'json',
	}, false);
	if (controlJson.CheckUsed == "Y") {
		$("#phcUom").combobox("readonly", true);
	}else{
		$("#phcUom").combobox("readonly", false);
	}
}

/**
 * ��洰��ѡ��
 */
function ShowARCItmMastSaveAs() {
	var _winDivId = "PHA_ARCITMMAST_SAVEAS";
	var _winDiv = '' +
		'<div id=' + _winDivId + ' style="overflow:hidden;padding-left:10px;padding-right:10px;">' +
		'	<div class="pha-row" >' +
		'		<a class="hisui-linkbutton" style="width:100%" onclick="SaveARCItmMast(\'SaveAs\')">�����ҽ����</a>' +
		'	</div>' +
		'	<div class="pha-row" >' +
		'		<a class="hisui-linkbutton green" style="width:100%" onclick="SaveARCItmMast(\'SaveAs\',\'Inci\')">������ͬ����ת�������</a>' +
		'	</div>' +
		'	<div class="pha-row" >' +
		'		<a class="hisui-linkbutton red" style="width:100%" onclick="$(\'#PHA_ARCITMMAST_SAVEAS\').dialog(\'close\');">�ر�</a>' +
		'	</div>' +
		'</div>'
	$("body").append(_winDiv);
	$.parser.parse($("#" + _winDivId));
	$('#' + _winDivId).dialog({
		title: '���ѡ��',
		collapsible: false,
		iconCls: "icon-w-copy",
		resizable: false,
		maximizable: false,
		minimizable: false,
		closable: false,
		border: false,
		closed: true,
		modal: true,
		width: 275,
		height: 170,
		onClose: function () {
			$(this).window("destroy");
		}
	}).dialog("open");
}
function DrugUomHandler() {
    $('#btnEditDrugUom').on('click', function () {
        if (ARCITMMAST_RowId === '') {
            PHA.Popover({
                msg: '����ѡ����Ҫ�޸ĵ�λ��ҽ����',
                type: 'alert'
            });
            return;
        }
        if ($('#phcUom').combobox('options').readonly === true) {
            PHA.Popover({
                msg: 'ҽ������ѹ����Ŀ�����ѷ���ҵ��',
                type: 'alert'
            });
            return;
        }
	    $('#diagDrugUom').dialog('open');
	    $('#gridDrugUom').datagrid('query', {
	        Arcim: ARCITMMAST_RowId
	    });
    });
}
function InitDiagDrugUom() {
    var cntcnt = 0;
    var drugPUomArr = ['pUom', 'outUom', 'inUom'];
    var drugBUom = PHA.EditGrid.ComboBox({
        required: false,
        tipPosition: 'top',
		defaultFilter: 4,
        url: PHA_STORE.CTUOM().url,
        onBeforeLoad: function (params) {
            params.ToUomId = $('#diagDrugUom_Uom').combobox('getValue');
        },
        onLoadSuccess: function (data) {
            var $this = $(this);
            var gridSelect = $('#gridDrugUom').datagrid('getSelected');
            var bUom = gridSelect.bUom;
            $this.combobox('clear');
            var dataLen = data.length;
            var selectFlag = false;
            data.forEach(function (rowData) {
                if (rowData.RowId === bUom || dataLen === 1) {
                    $this.combobox('select', rowData.RowId);
                    selectFlag = true;
                }
            });
            if (selectFlag === false) {
                $this.combobox('options').onSelect.call(null, { RowId: '', Description: '' });
            }
        },
        onSelect: function (data) {
            var rowID = data.RowId;
            var gridRowEditIndex = $('#gridDrugUom').datagrid('options').editIndex;
            if (gridRowEditIndex != undefined) {
                drugPUomArr.forEach(function (uomID) {
                    var ed = $('#gridDrugUom').datagrid('getEditor', {
                        index: gridRowEditIndex,
                        field: uomID
                    });
                    if (ed) {
                        $(ed.target).combobox('options').url = PHA_STORE.CTUOM().url;
                        $(ed.target).combobox('reload');
                    }
                });
            }
        }
    });

    // ��ҩ��λ ��ⵥλ����
    var drugPUom = PHA.EditGrid.ComboBox({
        required: false,
        tipPosition: 'top',
		defaultFilter: 4,
        onBeforeLoad: function (params) {
            var toUom = '';
            var gridRowEditIndex = $('#gridDrugUom').datagrid('options').editIndex;
            if (gridRowEditIndex != undefined) {
                var ed = $('#gridDrugUom').datagrid('getEditor', {
                    index: gridRowEditIndex,
                    field: 'bUom'
                });
                if (ed) {
                    toUom = $(ed.target).combobox('getValue');
                }
            }
            if (toUom === '') {
                toUom = 999999999;
            }
            params.ToUomId = toUom;
        },
        onLoadSuccess: function (data) {
            var $this = $(this);
            var curValue = $this.combobox('getValue');
            $this.combobox('clear');
            var dataLen = data.length;
            data.forEach(function (rowData) {
                if (rowData.RowId === curValue || dataLen === 1) {
                    $this.combobox('select', rowData.RowId);
                }
            });
        }
    });

    PHA.ComboBox('diagDrugUom_Uom', {
        url: PHA_STORE.CTUOM().url,
        onSelect: function (data) {
            var rowID = data.RowId;
            var gridRowEditIndex = $('#gridDrugUom').datagrid('options').editIndex;
            if (gridRowEditIndex != undefined) {
                var ed = $('#gridDrugUom').datagrid('getEditor', {
                    index: gridRowEditIndex,
                    field: 'bUom'
                });
                if (ed) {
                    $(ed.target).combobox('reload');
                }
            }
        }
    });

    var columns = [
        [
            {
                field: 'inci',
                title: 'inci',
                width: 50,
                hidden: true
            },
            {
                field: 'inciDesc',
                title: '���������',
                width: 300
            },
            {
                field: 'bUom',
                title: '������λ',
                width: 100,
                editor: drugBUom,
                descField: 'bUomDesc',
                formatter: function (value, row, index) {
                    return row.bUomDesc;
                }
            },
            {
                field: 'bUomDesc',
                title: '������λ����',
                width: 100,
                hidden: true
            },
            {
                field: 'pUom',
                title: '��ⵥλ',
                width: 100,
                editor: drugPUom,
                descField: 'pUomDesc',
                formatter: function (value, row, index) {
                    return row.pUomDesc;
                }
            },
            {
                field: 'pUomDesc',
                title: '��ⵥλ����',
                width: 100,
                hidden: true
            },
            {
                field: 'outUom',
                title: '���﷢ҩ��λ',
                width: 100,
                editor: drugPUom,
                descField: 'outUomDesc',
                formatter: function (value, row, index) {
                    return row.outUomDesc;
                }
            },
            {
                field: 'outUomDesc',
                title: '���﷢ҩ��λ����',
                width: 100,
                hidden: true
            },
            {
                field: 'inUom',
                title: 'סԺ��ҩ��λ',
                width: 100,
                editor: drugPUom,
                descField: 'inUomDesc',
                formatter: function (value, row, index) {
                    return row.inUomDesc;
                }
            },
            {
                field: 'inUomDesc',
                title: 'סԺ��ҩ��λ����',
                width: 100,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.Drug.Query',
            QueryName: 'DrugUomData'
        },
        exportXls: false,
        columns: columns,
        toolbar: '',
        pagination: false,
        onClickRow: function (rowIndex, rowData) {
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex
            });
        },
        onLoadSuccess: function (data) {
            if (data.total > 0) {
                var firstRowData = data.rows[0];
                $('#diagDrugUom_ArcimDesc').html(firstRowData.arcimDesc);
                $('#diagDrugUom_Uom').combobox('setValue', firstRowData.phcUom);
            }
        }
    };
    PHA.Grid('gridDrugUom', dataGridOption);
    $('#btnSaveUom')
        .unbind()
        .on('click', function () {
            $('#gridDrugUom').datagrid('endEditing');
            var phcUom = $('#diagDrugUom_Uom').combobox('getValue');
            if (phcUom === '') {
                PHA.Popover({
                    msg: 'ҩѧ������λ����Ϊ��',
                    type: 'alert'
                });
                return;
            }
            var inciJsonArr = [];
            var arcimJson = {
                arcim: ARCITMMAST_RowId,
                phcUom: phcUom
            };
            var gridRows = $('#gridDrugUom').datagrid('getRows');
            for (var i = 0; i < gridRows.length; i++) {
                var rowData = gridRows[i];
                var bUom = rowData.bUom || '';
                var pUom = rowData.pUom || '';
                var outUom = rowData.outUom || '';
                var inUom = rowData.inUom || '';
                if (bUom === '' || pUom === '' || outUom === '' || inUom === '') {
                    PHA.Popover({
                        msg: '����λ���ܴ��ڿ�ֵ',
                        type: 'alert'
                    });
                    return;
                }
                var inciJson = {
                    inci: rowData.inci,
                    bUom: bUom,
                    pUom: pUom,
                    outUom: outUom,
                    inUom: inUom
                };
                inciJsonArr.push(inciJson);
            }
            var saveRet = $.cm(
                {
                    ClassName: 'PHA.IN.Drug.Save',
                    MethodName: 'UpdateDrugUomHandler',
                    arcimJsonStr: JSON.stringify(arcimJson),
                    inciJsonStr: JSON.stringify(inciJsonArr),
                    dataType: 'text'
                },
                false
            );
            if (saveRet.indexOf('msg') >= 0) {
                PHA.Alert('��ʾ', saveRet, 'error');
                return;
            }

            var saveArr = saveRet.split('^');
            var saveVal = saveArr[0];
            var saveInfo = saveArr[1];
            if (saveVal < 0) {
                PHA.Alert('��ʾ', saveInfo, saveVal);
                return;
            } else {
                PHA.Popover({
                    msg: '����ɹ�',
                    type: 'success'
                });
                $('#gridDrugUom').datagrid('reload');
                QueryARCItmMastDetail();
            }
        });
    $('#btnResetUom').on('click', function () {
        $('#gridDrugUom').datagrid('reload');
    });
}