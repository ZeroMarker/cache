/*
 * FileName: dhcbillmenu.tarfactor.js
 * User: TangTao
 * Date: 2014-04-10
 * Description: 病人折扣记账系数
 */

var EditIndex = -1;
var m_AdmReaonDr = "";
var m_TarCateDr = "";
var m_TarSubCateDr = "";
var m_TarItemDr = "";
var m_RegFacDr = "";
var m_AdmType = "";
var m_ArcimDr = "";

$(function () {
	initGrid();
	if (BDPAutDisableFlag('BtnAdd')) {
		$('#BtnAdd').hide();
	}
	if (BDPAutDisableFlag('BtnUpdate')) {
		$('#BtnUpdate').hide();
	}
	if (BDPAutDisableFlag('BtnDelete')) {
		$('#BtnDelete').hide();
	}
	if (BDPAutDisableFlag('BtnSave')) {
		$('#BtnSave').hide();
	}
	
	var tableName = "Bill_IP_Param";
	var defHospId = $.m({
		ClassName: "web.DHCBL.BDP.BDPMappingHOSP",
		MethodName: "GetDefHospIdByTableName",
		tableName: tableName,
		HospID: PUBLIC_CONSTANT.SESSION.HOSPID
	}, false);
	$("#hospital").combobox({
		panelHeight: 150,
		width: 300,
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
			//优惠类型
			var url = $URL + "?ClassName=DHCBILLConfig.DHCBILLSysType&QueryName=FindRegFactor&ResultSetType=array";
			$("#tTBRegCombo").combobox("clear").combobox("reload", url);
			
			//费别
			var url = $URL + "?ClassName=DHCBILLConfig.DHCBILLSysType&QueryName=FindAdmReason&ResultSetType=array";
			$("#tTBAdmReaCombo").combobox("clear").combobox("reload", url);
			
			//收费子类
			var url = $URL + "?ClassName=DHCBILLConfig.DHCBILLSysType&QueryName=FindTarSubCate&ResultSetType=array";
			$("#tTBCateCombo").combobox("clear").combobox("reload", url);
			
			FindClick();
		}
	});
	
	//优惠类型
	$("#tTBRegCombo").combobox({
		valueField: 'RCDRowID',
        textField: 'RCDDesc',
        onBeforeLoad:function(param){
			$.extend(param, {HospId: getValueById("hospital")});
			return true;
		},
		onChange:function(newValue, oldValue) {
			FindClick();
		}
	});
	
	//费别
	$("#tTBAdmReaCombo").combobox({
		valueField: 'RowID',
        textField: 'READesc',
        onBeforeLoad:function(param) {
			$.extend(param, {Code: "", Desc: "", HospId: getValueById("hospital")});
			return true;
		},
		onChange: function(newValue, oldValue){
			FindClick();
		}
	});
	
	//收费子类
	$("#tTBCateCombo").combobox({
		valueField: 'rowid',
        textField: 'desc',
        onBeforeLoad:function(param) {
	        $.extend(param, {
					Code: '',
					Desc: '',
					TarCate: '',
					CateDr1: 'SC',
					CateDr2: 'TCC',
					CateDr3: 'CC',
					HospId: getValueById("hospital")
		        });
			return true;
		},
		onChange:function(newValue, oldValue){
			FindClick();
		}
	});
});

function initGrid() {
	var CateColumns = [[{
				field: 'TFRowId',
				title: 'TFRowId',
				hidden: true
			}, {
				field: 'TFADMTYPEDesc',
				title: '就诊类型',
				width: 100,
				sortable: true,
				resizable: true,
				editor: {
					type: 'combobox',
					options: {
						valueField: 'id',
						textField: 'name',
						data: [{id: 'A', name: '全部'},
							   {id: 'E', name: '急诊'},
						       {id: 'O', name: '门诊'},
						       {id: 'I', name: '住院'},
						       {id: 'H', name: '体检'}
						],
						onSelect: function (rec) {
							if (rec) {
								m_AdmType = rec.id;     //获取选中的就诊类型ID
							}
						}
					}
				}
			}, {
				field: 'TFRegFac',
				title: '优惠类型',
				width: 100,
				sortable: true,
				resizable: true,
				editor: {
					type: 'combobox',
					options: {
						url: $URL + '?ClassName=DHCBILLConfig.DHCBILLSysType&QueryName=FindRegFactor&ResultSetType=array',
						valueField: 'RCDRowID',
						textField: 'RCDDesc',
						onBeforeLoad: function(param) {
							$.extend(param, {HospId: getValueById("hospital")});
							return true;
						},
						onSelect: function (rec) {
							if (rec) {
								m_RegFacDr = rec.RCDRowID; //获取选中的ID
							}
						},
						onChange: function (newVal, oldValue) {
							if (!newVal) {
								m_RegFacDr = "";
							}
						}
					}
				}
			}, {
				field: 'TFAdmReaDesc',
				title: '费别',
				width: 100,
				sortable: true,
				resizable: true,
				editor: {
					type: 'combobox',
					options: {
						url: $URL + '?ClassName=DHCBILLConfig.DHCBILLSysType&QueryName=FindAdmReason&ResultSetType=array',
						valueField: 'RowID',
						textField: 'READesc',
						onBeforeLoad:function(param){
							$.extend(param, {Code: "", Desc: "", HospId: getValueById("hospital")});
							return true;
						},
						onSelect: function (rec) {
							if (rec) {
								m_AdmReaonDr = rec.RowID; //获取选中的就诊类型ID
							}
						},
						onChange: function (newVal, oldValue) {
							if (!newVal) {
								m_AdmReaonDr = "";
							}
						}
					}
				}
			}, {
				field: 'TFTarCateDesc',
				title: '收费项目大类',
				width: 100,
				sortable: true,
				resizable: true,
				editor: {
					type: 'combobox',
					options: {
						url: $URL + '?ClassName=DHCBILLConfig.DHCBILLSysType&QueryName=FindTarCate&ResultSetType=array',
						valueField: 'rowid',
						textField: 'desc',
						onBeforeLoad:function(param){
							$.extend(param, {Code: "", Desc: "", CateDr: "CC", HospId: getValueById("hospital")});
							return true;
						},
						onSelect: function (rec) {
							if (!rec) {
								return;
							}
							m_TarCateDr = rec.rowid;  //获取选中的收费大类ID
							var thTarCateDr = $.m({
									ClassName: "DHCBILLConfig.DHCBILLSysType",
									MethodName: "GetTarCateBySubCate",
									TarSubCateDr: m_TarSubCateDr,
									CateDr: "SC"
								}, false);
							if (thTarCateDr != m_TarCateDr) {
								//置空收费项目子类数据
								m_TarSubCateDr = "";
								var thisEd = $('#tTarCate').datagrid('getEditor', {index: EditIndex, field: 'TFTarSubCateDesc'});
								if (thisEd) {
									var url = $URL + '?ClassName=DHCBILLConfig.DHCBILLSysType&QueryName=FindTarSubCate&ResultSetType=array';
									$(thisEd.target).combobox('clear').combobox('reload', url);
								}
								
								var thTarRowidStr = $.m({
										ClassName: "DHCBILLConfig.DHCBILLSysType",
										MethodName: "GetTarCateByTarRowid",
										TarRowid: m_TarItemDr,
										CateDr: "SC"
									}, false);
								if (thTarRowidStr.split("^")[0] != m_TarCateDr) {
									//置空收费项数据
									m_TarItemDr = "";
									var thisEd = $('#tTarCate').datagrid('getEditor', {index: EditIndex, field: 'TFTarIDesc'});
									if (thisEd) {
										$(thisEd.target).combobox('clear').combobox("loadData", []);
									}
									//清空医嘱项目数据
									m_ArcimDr = "";
									var thisEd = $('#tTarCate').datagrid('getEditor', {index: EditIndex, field: 'TFArcimDesc'});
									if (thisEd) {
										$(thisEd.target).combobox('clear').combobox('disable');
									}
								}
							}
						},
						onChange: function (newValue, oldValue) {
							if (!newValue) {
								m_TarCateDr = "";
								//置空收费项目子类数据
								m_TarSubCateDr = "";
								var thisEd = $('#tTarCate').datagrid('getEditor', {index: EditIndex, field: 'TFTarSubCateDesc'});
								var url = $URL + '?ClassName=DHCBILLConfig.DHCBILLSysType&QueryName=FindTarSubCate&ResultSetType=array';
								if (thisEd) {
									$(thisEd.target).combobox('clear').combobox('reload', url);
								}

								//置空收费项数据
								m_TarItemDr = "";
								var thisEd = $('#tTarCate').datagrid('getEditor', {index: EditIndex, field: 'TFTarIDesc'});
								if (thisEd) {
									$(thisEd.target).combobox('clear').combobox('loadData', []); //清除原来的数据
								}
								//清空医嘱项目数据
								m_ArcimDr = "";
								var thisEd = $('#tTarCate').datagrid('getEditor', {index: EditIndex, field: 'TFArcimDesc'});
								if (thisEd) {
									$(thisEd.target).combobox('clear').combobox('disable');
								}
							}
						}
					}
				}
			}, {
				field: 'TFTarSubCateDesc',
				title: '收费项目子类',
				width: 100,
				sortable: true,
				resizable: true,
				editor: {
					type: 'combobox',
					options: {
						url: $URL + '?ClassName=DHCBILLConfig.DHCBILLSysType&QueryName=FindTarSubCate&ResultSetType=array',
						valueField: 'rowid',
						textField: 'desc',
						onBeforeLoad:function(param) {
							$.extend(param, {
								Code: "",
								Desc: "",
								TarCate: m_TarCateDr,
								CateDr1: "SC",
								CateDr2: "TCC",
								CateDr3: "CC",
								HospId: getValueById("hospital")
							});
							return true;
						},
						onSelect: function (rec) {
							if (!rec) {
								return;
							}
							m_TarSubCateDr = rec.rowid; //获取选中的收费子类ID
							var thTarRowidStr = $.m({
									ClassName: "DHCBILLConfig.DHCBILLSysType",
									MethodName: "GetTarCateByTarRowid",
									TarRowid: m_TarItemDr,
									CateDr: "SC"
								}, false);
							if (thTarRowidStr.split("^")[1] != rec.rowid) {
								//置空收费项数据
								m_TarItemDr = "";
								var thisEd = $('#tTarCate').datagrid('getEditor', {index: EditIndex, field: 'TFTarIDesc'});
								if (thisEd) {
									$(thisEd.target).combobox('clear').combobox('loadData', []);    //清除原来的数据
								}
								//清空医嘱项目数据
								m_ArcimDr = "";
								var thisEd = $('#tTarCate').datagrid('getEditor', {index: EditIndex, field: 'TFArcimDesc'});
								if (thisEd) {
									$(thisEd.target).combobox('clear').combobox('disable');
								}
							}
						},
						onChange: function (newValue, oldValue) {
							if (!newValue) {
								m_TarSubCateDr = "";
								//置空收费项数据
								m_TarItemDr = "";
								var thisEd = $('#tTarCate').datagrid('getEditor', {index: EditIndex, field: 'TFTarIDesc'});
								if (thisEd) {
									$(thisEd.target).combobox('clear').combobox('loadData', []); //清除原来的数据
								}
								//清空医嘱项目数据
								m_ArcimDr = "";
								var thisEd = $('#tTarCate').datagrid('getEditor', {index: EditIndex, field: 'TFArcimDesc'});
								if (thisEd) {
									$(thisEd.target).combobox('clear').combobox('disable');
								}
							}
						}
					}
				}
			}, {
				field: 'TFTarIDesc',
				title: '收费项目名称',
				width: 250,
				sortable: true,
				resizable: true,
				editor: {
					type: 'combobox',
					options: {
						panelHeight: 200,
						url: $URL + '?ClassName=DHCBILLConfig.DHCBILLFIND&QueryName=FindTarItem&ResultSetType=array',
						mode: 'remote',
						method: 'get',
						delay: 200,
						blurValidValue: true,
						valueField: 'rowid',
						textField: 'desc',
						onBeforeLoad: function (param) {
							var CateEd = $('#tTarCate').datagrid('getEditor', {index: EditIndex, field: 'TFTarCateDesc'});
							var CateEdValue = CateEd ? $(CateEd.target).combobox('getValue') : "";
							var SubCateEd = $('#tTarCate').datagrid('getEditor', {index: EditIndex, field: 'TFTarSubCateDesc'});
							var SubCateEdValue = SubCateEd ? $(SubCateEd.target).combobox('getValue') : "";
							if (!SubCateEdValue && !param.q) {
								return false;
							}
							$.extend(param, {
								alias: param.q,                     //别名
								str: SubCateEdValue + PUBLIC_CONSTANT.SEPARATOR.CH2 + CateEdValue,                //入参串
								HospID: getValueById("hospital")    //医院ID
							});
							return true;
					 	},
						onSelect: function (rec) {
							m_TarItemDr = rec.rowid; //获取选中的收费项目ID
							var thisEd = $('#tTarCate').datagrid('getEditor', {index: EditIndex, field: 'TFArcimDesc'});
							if (thisEd) {
								$(thisEd.target).combobox('enable');
							}
						},
						onChange: function (newValue, oldValue) {
							if (!newValue) {
								m_TarItemDr = "";
								m_ArcimDr = "";
								var thisEd = $('#tTarCate').datagrid('getEditor', {index: EditIndex, field: 'TFArcimDesc'});
								if (thisEd) {
									$(thisEd.target).combobox('clear').combobox('disable');
								}
							}
						}
					}
				}
			}, {
				field: 'TFArcimDesc',
				title: '医嘱项目名称',
				width: 300,
				sortable: true,
				resizable: true,
				editor: {
					type: 'combobox',
					options: {
						panelHeight: 200,
						mode: 'remote',
						method: 'get',
						delay: 300,
						blurValidValue: true,
						valueField: 'ArcimRowID',
						textField: 'ArcimDesc',
						disabled: true,
						onBeforeLoad: function (param) {
							if (!($.trim(param.q).length > 1)) {
								return false;
							}
							$.extend($(this).combobox("options"), {url: $URL})
							var sessionStr = PUBLIC_CONSTANT.SESSION.USERID + "^" + "" + "^" + "" + "^" + getValueById("hospital");
							$.extend(param, {ClassName: "BILL.COM.ItemMast", QueryName: "FindARCItmMast", ResultSetType: "array", alias: param.q, sessionStr: sessionStr});
							return true;
						},
						onSelect: function (rec) {
							if (rec) {
								m_ArcimDr = rec.ArcimRowID;
							}
						},
						onChange: function (newValue, oldValue) {
							if (!newValue) {
								m_ArcimDr = "";
							}
						}
					}
				}
			}, {
				field: 'TFStartDate',
				title: '开始日期',
				width: 120,
				editor: 'datebox',
				sortable: true,
				resizable: true
			}, {
				field: 'TFEndDate',
				title: '结束日期',
				width: 120,
				editor: 'datebox',
				sortable: true,
				resizable: true
			}, {
				field: 'TFDiscRate',
				title: '折扣系数',
				width: 80,
				editor: 'text',
				sortable: true,
				resizable: true
			}, {
				field: 'TFPayorRate',
				title: '记账系数',
				width: 80,
				editor: 'text',
				sortable: true,
				resizable: true
			}, {
				field: 'TFAlterLevel',
				title: '支付限额',
				width: 80,
				editor: 'text',
				sortable: true,
				resizable: true
			}, {
				field: 'TFAlterPayorRate',
				title: '限额比例',
				width: 80,
				editor: 'text',
				sortable: true,
				resizable: true
			}, {
				field: 'TFUpDate',
				title: '更新日期',
				width: 100,
				sortable: true,
				resizable: true
			}, {
				field: 'TFUpTime',
				title: '更新时间',
				width: 80,
				sortable: true,
				resizable: true
			}, {
				field: 'TFUpUser',
				title: '更新用户',
				width: 80,
				sortable: true,
				resizable: true
			}, {
				field: 'TFRegFacDr',
				title: 'TFRegFacDr',
				hidden: true
			}, {
				field: 'TFPITDR',
				title: 'TFPITDR',
				hidden: true
			}, {
				field: 'TFTARSCDR',
				title: 'TFTARSCDR',
				hidden: true
			}, {
				field: 'TFTARCDR',
				title: 'TFTARCDR',
				hidden: true
			}, {
				field: 'TFADMTYPE',
				title: 'TFADMTYPE',
				hidden: true
			}, {
				field: 'TFHospDr',
				title: 'TFHospDr',
				hidden: true
			}, {
				field: 'TFTARIDR',
				title: 'TFTARIDR',
				hidden: true
			}, {
				field: 'TFArcimDr',
				title: 'TFArcimDr',
				hidden: true
			}
		]];

	// 初始化DataGrid
	$('#tTarCate').datagrid({
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		fitColumns: false,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		columns: CateColumns,
		toolbar: '#tToolBar',
		onLoadSuccess: function (data) {
			EditIndex = -1;
			m_AdmReaonDr = "";
			m_TarCateDr = "";
			m_TarSubCateDr = "";
			m_TarItemDr = "";
			m_RegFacDr = "";
			m_AdmType = "";
			m_ArcimDr = "";
		},
		onBeginEdit: function(index, row) {
			onBeginEditHandler(index, row);
		}
	});
}

/**
* 2019-01-17 ZhYW
*/
function onBeginEditHandler(index, row) {
	var ed = $('#tTarCate').datagrid('getEditor', {
			index: index,
			field: 'TFDiscRate',
		});
	$(ed.target).bind('keypress', function (e) {
		return setLimitFloat(e);
	});
	var ed = $('#tTarCate').datagrid('getEditor', {
			index: index,
			field: 'TFPayorRate',
		});
	$(ed.target).bind('keypress', function (e) {
		return setLimitFloat(e);
	});
	var ed = $('#tTarCate').datagrid('getEditor', {
			index: index,
			field: 'TFAlterLevel',
		});
	$(ed.target).bind('keypress', function (e) {
		return setLimitFloat(e);
	});
	var ed = $('#tTarCate').datagrid('getEditor', {
			index: index,
			field: 'TFAlterPayorRate',
		});
	$(ed.target).bind('keypress', function (e) {
		return setLimitFloat(e);
	});
}

function initLoadGrid(ExpStr) {
	ExpStr = getValueById("hospital") + "^" + ExpStr;
	var queryParams = {
		ClassName: "DHCBILLConfig.DHCBILLSysType",
		QueryName: "FindTarFactor",
		SHExpStr: ExpStr
	};
	loadDataGridStore("tTarCate", queryParams);
}

$('#BtnAdd').bind('click', function () {
	var lastIndex = $('#tTarCate').datagrid('getRows').length - 1;
	$('#tTarCate').datagrid('selectRow', lastIndex);
	var selected = $('#tTarCate').datagrid('getSelected');
	if (selected) {
		if (selected.TFRowId == "") {
			$.messager.alert('提示', "不能同时添加多条", 'info');
			return;
		}
	}
	if ((EditIndex >= 0)) {
		$.messager.alert('提示', "一次只能修改一条记录", 'info');
		return;
	}
	$('#tTarCate').datagrid('appendRow', {
		TFRowId: '',
		TFADMTYPEDesc: '',
		TFRegFac: '',
		TFAdmReaDesc: '',
		TFTarCateDesc: '',
		TFTarSubCateDesc: '',
		TFTarIDesc: '',
		TFStartDate: '',
		TFEndDate: '',
		TFDiscRate: '',
		TFPayorRate: '',
		TFAlterLevel: '',
		TFAlterPayorRate: '',
		TFArcimDesc: ''
	});
	var lastIndex = $('#tTarCate').datagrid('getRows').length - 1;
	$('#tTarCate').datagrid('selectRow', lastIndex);
	$('#tTarCate').datagrid('beginEdit', lastIndex);
	EditIndex = lastIndex;
});

$('#BtnUpdate').bind('click', function () {
	var row = $('#tTarCate').datagrid('getSelected');
	if (row) {
		var thisIndex = $('#tTarCate').datagrid('getRowIndex', row);
		if ((EditIndex != -1) && (EditIndex != thisIndex)) {
			$.messager.alert('提示', "一次只能修改一条记录", 'info');
			return;
		}
		EditIndex = thisIndex;
		var regFacDR = row.TFRegFacDr;
		var admReaDR = row.TFPITDR;
		var tarCateDR = row.TFTARCDR;
		var tarSubCateDR = row.TFTARSCDR;
		var tarItemDR = row.TFTARIDR;
		var arcimDR = row.TFArcimDr;
		m_RegFacDr = regFacDR;
		m_AdmReaonDr = admReaDR;
		m_TarCateDr = tarCateDR;
		m_TarSubCateDr = tarSubCateDR;
		m_TarItemDr = tarItemDR;
		m_ArcimDr = arcimDR;
		
		$('#tTarCate').datagrid('beginEdit', thisIndex);
		$('#tTarCate').datagrid('selectRow', thisIndex);

		var thisEd = $('#tTarCate').datagrid('getEditor', {index: EditIndex, field: 'TFAdmReaDesc'});
		$(thisEd.target).combobox('select', admReaDR);
		var thisEd = $('#tTarCate').datagrid('getEditor', {index: EditIndex, field: 'TFTarCateDesc'});
		$(thisEd.target).combobox('select', tarCateDR);
		var thisEd = $('#tTarCate').datagrid('getEditor', {index: EditIndex, field: 'TFTarSubCateDesc'});
		$(thisEd.target).combobox('select', tarSubCateDR);
		var thisEd = $('#tTarCate').datagrid('getEditor', {index: EditIndex, field: 'TFRegFac'});
		$(thisEd.target).combobox('select', regFacDR);
		var thisEd = $('#tTarCate').datagrid('getEditor', {index: EditIndex, field: 'TFADMTYPEDesc'});
		$(thisEd.target).combobox('select', row.TFADMTYPE);
	}
});

$('#BtnSave').bind('click', function () {
	$('#tTarCate').datagrid('acceptChanges');
	var selected = $('#tTarCate').datagrid('getSelected');
	if (selected) {
		// selected.TFRowId为undefined，说明是新建项目，调用保存接口
		if (selected.TFRowId == "") {
			var tmpTFTarIDesc = selected.TFTarIDesc || "";
			var tmpTarSubCateDesc = selected.TFTarSubCateDesc || "";
			var tmpTarCateDesc = selected.TFTarCateDesc || "";
			if ((tmpTFTarIDesc == "") && (tmpTarSubCateDesc == "") && (tmpTarCateDesc == "")) {
				$.messager.alert('提示', "收费项目、子类、大类不能同时为空", 'info');
				initLoadGrid("");
				return;
			}
			var tmpStartDate = selected.TFStartDate || "";
			if (tmpStartDate == "") {
				$.messager.alert('提示', "开始日期不能为空", 'info');
				initLoadGrid("");
				return;
			}
			if ((selected.TFDiscRate == "") && (selected.TFPayorRate == "")) {
				$.messager.alert('提示', "折扣、记账系数不能同时为空", 'info');
				initLoadGrid("");
				return;
			}
			var tmpAdmReaDesc = selected.TFAdmReaDesc || "";
			var tmpRegFac = selected.TFRegFac || "";
			if ((tmpAdmReaDesc != "") && (tmpRegFac != "")) {
				$.messager.alert('提示', "折扣设置不允许同时选择优惠类型和费别，只能选择一个设置优惠", 'info');
				initLoadGrid("");
				return;
			}
			var hospId = getValueById("hospital");
			var tmpArcimDesc = selected.TFArcimDesc || "";
			
			var FactorStr = "^" + tmpAdmReaDesc + "^" + tmpTarSubCateDesc + "^" + tmpTFTarIDesc;
			FactorStr = FactorStr + "^" + tmpStartDate + "^" + selected.TFEndDate + "^" + selected.TFDiscRate;
			FactorStr = FactorStr + "^" + selected.TFPayorRate + "^" + selected.TFAlterLevel + "^" + selected.TFAlterPayorRate;
			FactorStr = FactorStr + "^" + tmpRegFac + "^" + tmpTarCateDesc + "^" + selected.TFADMTYPEDesc;
			FactorStr = FactorStr + "^" + hospId + "^" + tmpArcimDesc;
			$.cm({
				ClassName: "DHCBILLConfig.DHCBILLSysType",
				MethodName: "InsertTarFactor",
				FactorStr: FactorStr,
				User: PUBLIC_CONSTANT.SESSION.USERID
			}, function (rtn) {
				var myAry = rtn.split("^");
				switch (myAry[0]) {
				case "0":
					$.messager.alert('提示', "保存成功", 'success');
					break;
				case "-1001":
					$.messager.alert('提示', "开始日期不能为空，且不能小于等于今日", 'info');
					break;
				case "-1002":
					$.messager.alert('提示', "结束日期不能小于今日", 'info');
					break;
				default:
					$.messager.alert('提示', "保存失败，错误代码：" + rtn, 'error');
				}
				initLoadGrid("");
			});
		} else {
			$('#tTarCate').datagrid('selectRow', EditIndex);
			var selected = $('#tTarCate').datagrid('getSelected');
			var tmpTFTarIDesc = selected.TFTarIDesc || "";
			var tmpTarSubCateDesc = selected.TFTarSubCateDesc || "";
			var tmpTarCateDesc = selected.TFTarCateDesc || "";
			if ((tmpTFTarIDesc == "") && (tmpTarSubCateDesc == "") && (tmpTarCateDesc == "")) {
				$.messager.alert('提示', "收费项目、子类、大类不能同时为空", 'info');
				initLoadGrid("");
				return;
			}
			var tmpStartDate = selected.TFStartDate || "";
			if (tmpStartDate == "") {
				$.messager.alert('提示', "开始日期不能为空", 'info');
				initLoadGrid("");
				return;
			}
			if ((selected.TFDiscRate == "") && (selected.TFPayorRate == "")) {
				$.messager.alert('提示', "折扣、记账系数不能同时为空", 'info');
				initLoadGrid("");
				return;
			}
			var tmpAdmReaDesc = selected.TFAdmReaDesc || "";
			var tmpRegFac = selected.TFRegFac || "";
			if (( tmpAdmReaDesc != "") && ( tmpRegFac != "")) {
				$.messager.alert('提示', "折扣设置不允许同时选择优惠类型和费别，只能选择一个设置优惠", 'info');
				initLoadGrid("");
				return;
			}
			var thisAdmReaDr = m_AdmReaonDr;
			var thisTarSubCate = m_TarSubCateDr;
			var thisTarItem = m_TarItemDr;
			var thisRegFacDr = m_RegFacDr;
			var thisTarCateDr = m_TarCateDr;
			var thisTFADMTYPE = m_AdmType;
			var thisTFArcimDr = m_ArcimDr;
			
			if (m_AdmReaonDr == "") {
				thisAdmReaDr = selected.TFAdmReaDesc;
			}
			if (m_TarCateDr == "") {
				thisTarCateDr = selected.TFTarCateDesc;
			}
			if (m_TarSubCateDr == "") {
				thisTarSubCate = selected.TFTarSubCateDesc;
			}
			if (m_TarItemDr == "") {
				thisTarItem = selected.TFTarIDesc;
			}
			if (m_RegFacDr == "") {
				thisRegFacDr = selected.TFRegFac;
			}
			if (m_AdmType == "") {
				thisTFADMTYPE = selected.TFADMTYPE;
			}
			
			var hospId = getValueById("hospital");
			if (m_ArcimDr == "") {
				thisTFArcimDr = selected.TFArcimDesc;
			}
			
			var FactorStr = selected.TFRowId + "^" + thisAdmReaDr + "^" + thisTarSubCate + "^" + thisTarItem;
			FactorStr = FactorStr + "^" + selected.TFStartDate + "^" + selected.TFEndDate + "^" + selected.TFDiscRate;
			FactorStr = FactorStr + "^" + selected.TFPayorRate + "^" + selected.TFAlterLevel + "^" + selected.TFAlterPayorRate;
			FactorStr = FactorStr + "^" + thisRegFacDr + "^" + thisTarCateDr + "^" + thisTFADMTYPE + "^" + hospId;
			FactorStr = FactorStr + "^" + thisTFArcimDr;
			$.cm({
				ClassName: "DHCBILLConfig.DHCBILLSysType",
				MethodName: "UpdateTarFactor",
				FactorStr: FactorStr,
				User: PUBLIC_CONSTANT.SESSION.USERID
			}, function (rtn) {
				var myAry = rtn.split("^");
				switch (myAry[0]) {
				case "0":
					$.messager.alert('提示', "修改成功", 'success');
					break;
				case "-1001":
					$.messager.alert('提示', "开始日期不能为空，且不能小于等于今日", 'info');
					break;
				case "-1002":
					$.messager.alert('提示', "结束日期不能小于今日", 'info');
					break;
				default:
					$.messager.alert('提示', "修改失败，错误代码：" + rtn, 'error');
				}
				initLoadGrid("");
			});
		}
	}
});

$('#BtnDelete').bind('click', function () {
	var selected = $('#tTarCate').datagrid('getSelected');
	if (!selected) {
		$.messager.alert('提示', "请选择要删除的记录", 'info');
		return;
	}
	if (selected.TFRowId != "") {
		$.messager.confirm('确认', '您确认想要删除记录吗？', function (r) {
			if (r) {
				var FactorStr = selected.TFRowId + "^" + selected.TFAdmReaDesc + "^" + selected.TFTarSubCateDesc + "^" + selected.TFTarIDesc;
				FactorStr = FactorStr + "^" + selected.TFStartDate + "^" + selected.TFEndDate + "^" + selected.TFDiscRate;
				FactorStr = FactorStr + "^" + selected.TFPayorRate + "^" + selected.TFAlterLevel + "^" + selected.TFAlterPayorRate;
				$.m({
					ClassName: "DHCBILLConfig.DHCBILLSysType",
					MethodName: "DeleteTarFactor",
					FactorStr: FactorStr,
					User: PUBLIC_CONSTANT.SESSION.USERID
				}, function (rtn) {
					if (rtn == 0) {
						$.messager.alert('提示', "删除成功", 'success');
					} else {
						$.messager.alert('提示', "删除失败，错误代码：" + rtn, 'error');
					}
					initLoadGrid("");
				});
			}
		});
	}
});

$('#BtnFind').bind('click', function () {
	FindClick();
});

$('#tTBTarDescText').keyup(function () {
	if (event.keyCode == 13) {
		FindClick();
	}
});

function FindClick() {
	EditIndex = -1;
	var TBTarDescText = getValueById("tTBTarDescText");;
	var TBRegCombo = getValueById("tTBRegCombo");
	var TBAdmReaCombo = getValueById("tTBAdmReaCombo");
	var TBCateCombo = getValueById("tTBCateCombo");
	var Str = TBRegCombo + "^" + TBAdmReaCombo + "^" + TBCateCombo + "^" + TBTarDescText;
	initLoadGrid(Str);
}

/**
 * Creator: ZhYW
 * CreatDate: 2019-01-17
 * Description: 控制grid编辑框只能输入实数
 */
function setLimitFloat(e) {
	try {
		var key = websys_getKey(e);
		if (((key > 47) && (key < 58)) || (key == 46) || (key == 13)) {
			//如果输入金额过长导致溢出计算有误
			if ($(e.target).val().length > 11) {
				window.event.keyCode = 0;
				return websys_cancel();
			}
		} else {
			window.event.keyCode = 0;
			return websys_cancel();
		}
	} catch (e) {
	}
}