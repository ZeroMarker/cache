/*
 * FileName: dhcbillmenu.tarfactor.js
 * User: TangTao
 * Date: 2014-04-10
 * Function: 病人折扣记账系数
 * Description:
 */

var lastIndex = "";
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
				title: '类型',
				width: 100,
				sortable: true,
				resizable: true,
				editor: {
					type: 'combobox',
					options: {
						valueField: 'id',
						textField: 'name',
						data: [{id: 'A', name: '全部'},
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
							m_TarCateDr = rec.rowid; //获取选中的收费大类ID
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
							}
							var thTarRowid = $.m({
									ClassName: "DHCBILLConfig.DHCBILLSysType",
									MethodName: "GetTarCateBySubCate",
									TarSubCateDr: m_TarSubCateDr,
									CateDr: "SC"
								}, false);
							var thisEd = $('#tTarCate').datagrid('getEditor', {index: EditIndex, field: 'TFTarCateDesc'});
							if (thisEd) {
								$(thisEd.target).combobox('select', thTarRowid);
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
						delay: 500,
						blurValidValue: true,
						valueField: 'rowid',
						textField: 'desc',
						onBeforeLoad: function (param) {
							var SubCateEd = $('#tTarCate').datagrid('getEditor', {index: EditIndex, field: 'TFTarSubCateDesc'});
							var SubCateEdValue = SubCateEd ? $(SubCateEd.target).combobox('getValue') : "";
							if (!SubCateEdValue && !param.q) {
								return false;
							}
							$.extend(param, {
								code: "",                           //项目代码
								desc: "",                           //项目名称 根据输入数据查询
								alias: param.q,                     //别名
								str: SubCateEdValue,                //入参串
								HospID: getValueById("hospital")    //医院ID
							});
							return true;
					 	},
						onSelect: function (rec) {
							m_TarItemDr = rec.rowid; //获取选中的收费项目ID
							var thTarRowidStr = $.m({
									ClassName: "DHCBILLConfig.DHCBILLSysType",
									MethodName: "GetTarCateByTarRowid",
									TarRowid: m_TarItemDr,
									CateDr: "SC"
								}, false);
							var thisEd = $('#tTarCate').datagrid('getEditor', {index: EditIndex, field: 'TFTarCateDesc'});
							if (thisEd) {
								$(thisEd.target).combobox('select', thTarRowidStr.split("^")[0]);
							}
							var thisEd = $('#tTarCate').datagrid('getEditor', {index: EditIndex, field: 'TFTarSubCateDesc'});
							if (thisEd) {
								$(thisEd.target).combobox('select', thTarRowidStr.split("^")[1]);
							}
							var thisEd = $('#tTarCate').datagrid('getEditor', {index: EditIndex, field: 'TFArcimDesc'});
							if (thisEd) {
								$(thisEd.target).combobox('enable');
							}
						},
						onChange: function (newValue, oldValue) {
							if (!newValue) {
								m_TarItemDr = "";
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
						url: $URL + '?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem&ResultSetType=array',
						mode: 'remote',
						method: 'get',
						delay: 500,
						blurValidValue: true,
						valueField: 'ArcimRowID',
						textField: 'ArcimDesc',
						disabled: true,
						onBeforeLoad: function (param) {
							if (!param.q) {
								return false;
							}
							$.extend(param, {Alias: param.q, HospId: getValueById("hospital")});
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
				width: 100,
				editor: 'datebox',
				sortable: true,
				resizable: true
			}, {
				field: 'TFEndDate',
				title: '结束日期',
				width: 100,
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
				title: '项目子类ID',
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
		data: [],
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
			beginEditRowHandler(index, row);
		}
	});
}

/**
* 2019-01-17 ZhYW
*/
function beginEditRowHandler(index, row) {
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
	//$('#tTarCate').datagrid('endEdit', lastIndex);
	lastIndex = $('#tTarCate').datagrid('getRows').length - 1;
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
	lastIndex = $('#tTarCate').datagrid('getRows').length - 1;
	$('#tTarCate').datagrid('selectRow', lastIndex);
	$('#tTarCate').datagrid('beginEdit', lastIndex);
	EditIndex = lastIndex;
});

$('#BtnUpdate').bind('click', function () {
	var selected = $('#tTarCate').datagrid('getSelected');
	if (selected) {
		var thisIndex = $('#tTarCate').datagrid('getRowIndex', selected);
		if ((EditIndex != -1) && (EditIndex != thisIndex)) {
			$.messager.alert('提示', "一次只能修改一条记录", 'info');
			return;
		}
		$('#tTarCate').datagrid('beginEdit', thisIndex);
		$('#tTarCate').datagrid('selectRow', thisIndex);
		EditIndex = thisIndex;
		var selected = $('#tTarCate').datagrid('getSelected');

		var thisEd = $('#tTarCate').datagrid('getEditor', {index: EditIndex, field: 'TFAdmReaDesc'});
		$(thisEd.target).combobox('select', selected.TFPITDR);
		var thisEd = $('#tTarCate').datagrid('getEditor', {index: EditIndex, field: 'TFTarCateDesc'});
		$(thisEd.target).combobox('select', selected.TFTARCDR);
		var thisEd = $('#tTarCate').datagrid('getEditor', {index: EditIndex, field: 'TFTarSubCateDesc'});
		$(thisEd.target).combobox('select', selected.TFTARSCDR);
		m_TarItemDr = selected.TFTARIDR;
		var thisEd = $('#tTarCate').datagrid('getEditor', {index: EditIndex, field: 'TFRegFac'});
		$(thisEd.target).combobox('select', selected.TFRegFacDr);
		var thisEd = $('#tTarCate').datagrid('getEditor', {index: EditIndex, field: 'TFADMTYPEDesc'});
		$(thisEd.target).combobox('select', selected.TFADMTYPE);
		m_ArcimDr = selected.TFArcimDr;
	}
});

$('#BtnSave').bind('click', function () {
	$('#tTarCate').datagrid('acceptChanges');
	var selected = $('#tTarCate').datagrid('getSelected');
	if (selected) {
		// selected.TFRowId为undefined，说明是新建项目，调用保存接口
		if (selected.TFRowId == "") {
			var tmpTarSubCateDesc = selected.TFTarSubCateDesc || "";
			var tmpTarCateDesc = selected.TFTarCateDesc || "";
			if ((tmpTarSubCateDesc == "") && (tmpTarCateDesc == "")) {
				$.messager.alert('提示', "收费项目子类与收费项目大类同时为空，不允许添加", 'info');
				EditIndex = -1;
				initLoadGrid("");
				return;
			}
			var tmpStartDate = selected.TFStartDate || "";
			if (tmpStartDate == "") {
				$.messager.alert('提示', "开始日期为空，不允许添加", 'info');
				EditIndex = -1;
				initLoadGrid("");
				return;
			}
			if ((selected.TFDiscRate == "") && (selected.TFPayorRate == "")) {
				$.messager.alert('提示', "折扣、记账系数同时为空，不允许添加", 'info');
				EditIndex = -1;
				initLoadGrid("");
				return;
			}
			var tmpAdmReaDesc = selected.TFAdmReaDesc || "";
			var tmpRegFac = selected.TFRegFac || "";
			if ((tmpAdmReaDesc != "") && (tmpRegFac != "")) {
				$.messager.alert('提示', "折扣设置不允许同时选择优惠类型和费别，只能选择一个设置优惠", 'info');
				EditIndex = -1;
				initLoadGrid("");
				return;
			}
			var hospId = getValueById("hospital");
			var tmpArcimDesc = selected.TFArcimDesc || "";
			
			var FactorStr = "^" + tmpAdmReaDesc + "^" + tmpTarSubCateDesc + "^" + selected.TFTarIDesc;
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
					$.messager.alert('提示', "结束日期不能小于等于今日", 'info');
					break;
				default:
					$.messager.alert('提示', "保存失败，错误代码：" + rtn, 'error');
				}
				EditIndex = -1;
				initLoadGrid("");
			});
		} else {
			$('#tTarCate').datagrid('selectRow', EditIndex);
			var selected = $('#tTarCate').datagrid('getSelected');
			var tmpTarSubCateDesc = selected.TFTarSubCateDesc || "";
			var tmpTarCateDesc = selected.TFTarCateDesc || "";
			if (tmpTarSubCateDesc == "" && tmpTarCateDesc == "") {
				$.messager.alert('提示', "收费项目子类与收费项目大类同时为空，不允许修改", 'info');
				EditIndex = -1;
				initLoadGrid("");
				return;
			}
			var tmpStartDate = selected.TFStartDate || "";
			if (tmpStartDate == "") {
				$.messager.alert('提示', "开始日期为空，不允许修改", 'info');
				EditIndex = -1;
				initLoadGrid("");
				return;
			}
			if ((selected.TFDiscRate == "") && (selected.TFPayorRate == "")) {
				$.messager.alert('提示', "折扣、记账系数同时为空，不允许修改", 'info');
				EditIndex = -1;
				initLoadGrid("");
				return;
			}
			var tmpAdmReaDesc = selected.TFAdmReaDesc || "";
			var tmpRegFac = selected.TFRegFac || "";
			if (( tmpAdmReaDesc != "") && ( tmpRegFac != "")) {
				$.messager.alert('提示', "折扣设置不允许同时选择优惠类型和费别，只能选择一个设置优惠", 'info');
				EditIndex = -1;
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
					$.messager.alert('提示', "结束日期不能小于等于今日", 'info');
					break;
				default:
					$.messager.alert('提示', "修改失败，错误代码：" + rtn, 'error');
				}
				EditIndex = -1;
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
					if (rtn == "0") {
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