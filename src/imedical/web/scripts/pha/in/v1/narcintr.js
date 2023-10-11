/**
 * ����:   	 ����ҩƷ���� - ����ҩƷ̨�˲�ѯ
 * ��д��:   Huxiaotian
 * ��д����: 2021-06-09
 * csp:		 pha.in.v1.narcintr.csp
 * js:		 pha/in/v1/narcintr.js
 */
PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = 'ҩ��';
PHA_COM.App.Csp = 'pha.in.v1.narcintr.csp';
PHA_COM.App.Name = '����ҩƷ̨�˲�ѯ';
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = true;
PHA_COM.VAR = {};
PHA_COM.VAR.SetDefaultTask = null;

$(function() {
	InitDict();
	InitGridIntrDsipRet();
	InitGridIntrTotal();
	InitGridIntrDetail();
	InitEvents();
	InitConfig();
});

// ��ʼ�� - ���ֵ�
function InitDict(){
	PHA.ComboBox('phLocId', {
		placeholder: '��ҩ����...',
		url: PHA_STORE.CTLoc().url + '&TypeStr=D&HospId=' + session['LOGON.HOSPID']
	});
	PHA.ComboBox('poisonIdStr', {
		placeholder: '���Ʒ���...',
		url: PHA_STORE.PHCPoison().url,
		multiple: true,
		rowStyle: 'checkbox',
		selectOnNavigation: false
	});
	PHA.ComboBox('stkCatGrpId', {
		placeholder: '����...',
		width: 154,
		url: PHA_STORE.DHCStkCatGroup().url + '&HospId=' + session['LOGON.HOSPID'],
		onSelect: function(){
			$('#stkCatId').combobox('clear');
			$('#stkCatId').combobox('reload');
		}
	});
	PHA.ComboBox('stkCatId', {
		placeholder: '������...',
		width: 154,
		url: PHA_STORE.INCStkCat().url + '&HospId=' + session['LOGON.HOSPID'],
		onBeforeLoad: function(param){
			var stkCatGrpId = $('#stkCatGrpId').combobox('getValue');
			param.CatGrpId = stkCatGrpId;
		}
	});
	PHA.ComboBox('intrTypeStr', {
		placeholder: 'ҵ������...',
		url: PHA_STORE.Url + 'ClassName=PHA.IN.Narc.Com&QueryName=DictTmp&dicType=IntrType',
		multiple: true,
		rowStyle: 'checkbox',
		selectOnNavigation: false
	});
	// ҩƷ����
	var inciOptions = PHA_STORE.INCItm();
	inciOptions.url = $URL;
	inciOptions.width = 160;
	inciOptions.placeholder = 'ҩƷ...';
	PHA.ComboGrid('inci', inciOptions);
	
	// ��Ĭ��ֵ
	InitDictVal();
}
function InitDictVal(){
	PHA.SetComboVal('phLocId', session['LOGON.CTLOCID']);
	var tab = $('#tabsIntr').tabs('getSelected');
	var tabIndex = $('#tabsIntr').tabs('getTabIndex',tab);
	if (tabIndex == 0) {
		$('#intrTypeStr').combobox('setValues', ['P', 'Y', 'F', 'H']);
	}
}

// ��ʼ�� - �¼���
function InitEvents(){
	$('#btnFind').on('click', Query);
    $('#btnClear').on('click', Clear);
    
    $('#tabsIntr').tabs({
		onSelect: function(title){
			$('#intrTypeStr').combobox('clear');
			// �ۺ�ҵ��̨��
			if (title == $g('�ۺ�ҵ��̨��')) {
				var $tabOpts = $('#tabsIntr').tabs('options');
				if (!$tabOpts.isInitLayout) {
					PHA_COM.ResizePanel({
						layoutId: 'layoutIntr',
						region: 'north',
						height: 0.5
					});
					$('#tabsIntr').tabs('options').isInitLayout = true;
				}
			}
			// ����ҩ̨��
			if (title == $g('��/��ҩҵ��̨��')) {
				$('#intrTypeStr').combobox('setValues', ['P', 'Y', 'F', 'H']);
			}
		}
	});
}

// ��ʼ�� - ���
function InitGridIntrDsipRet(){
	var columns = [
		[
			{
				title: "ҵ��ʱ��",
				field: "intrDT",
				width: 155
			}, {
				title: "��������",
				field: "docLocDesc",
				width: 120
			}, {
				title: "�ǼǺ�",
				field: "patNo",
				width: 95
			}, {
				title: "����",
				field: "patName",
				width: 100
			}, {
				title: "�Ա�",
				field: "patSex",
				width: 60,
				align: 'center'
			}, {
				title: "����",
				field: "patAge",
				width: 60
			}, {
				title: "֤����",
				field: "patIDNo",
				width: 140
			}, {
				title: "�绰",
				field: "patTel",
				width: 110
			}, {
				title: "������",
				field: "prescNo",
				width: 120
			}, {
				title: "���",
				field: "diagnosis",
				width: 120
			}, {
				title: "ҩƷ����",
				field: "inciCode",
				width: 100
			}, {
				title: "ҩƷ����",
				field: "inciDesc",
				width: 170
			}, {
				title: "���",
				field: "inciSpec",
				width: 90
			}, {
				title: "����ҽ��", // ��ʱ��Ҫ. Huxt 2021-06-11
				field: "docUserName",
				width: 100
			}, {
				title: "����",
				field: "intrQty",
				width: 65,
				align: 'right'
			}, {
				title: "��λ",
				field: "intrUomDesc",
				width: 60
			}, {
				title: "����(��)",
				field: "bQty",
				width: 65,
				align: 'right'
			}, {
				title: "������λ",
				field: "bUomDesc",
				width: 70
			}, {
				title: "����(��)",
				field: "pQty",
				width: 70,
				align: 'right'
			}, {
				title: "��ⵥλ",
				field: "pUomDesc",
				width: 70
			}, {
				title: "��������(��)",
				field: "curBQty",
				width: 95,
				align: 'right'
			}, {
				title: "�ۼ۽��",
				field: "spAmt",
				width: 70,
				align: 'right'
			}, {
				title: "������",
				field: "curSpAmt",
				width: 130,
				align: 'right'
			}, {
				title: "����",
				field: "incibNo",
				width: 100
			}, {
				title: "��ҩ��",
				field: "pyUserName",
				width: 80
			}, {
				title: "��ҩ��",
				field: "fyUserName",
				width: 80
			}, {
				title: "ҵ������",
				field: "intrTypeDesc",
				width: 70
			}, {
				title: "����ҩƷ���",
				field: "INCINo",
				width: 100
			}, {
				title: "�Ǽǿ���",
				field: "regLocDesc",
				width: 110
			}, {
				title: "�Ǽ���",
				field: "regUserName",
				width: 100
			}, {
				title: "�Ǽ�����",
				field: "regDate",
				width: 90
			}, {
				title: "�Ǽ�ʱ��",
				field: "regTime",
				width: 90
			}, {
				title: "�ǼǱ�ע",
				field: "remarks",
				width: 120
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.IN.Narc.Trans',
			QueryName: 'IntrDispRet'
		},
		singleSelect: true,
		pagination: true,
		columns: columns,
		gridSave: true,
		toolbar: [],
		onClickCell: function(index, field, value) {},
		onLoadSuccess: function(data){}
	};
	PHA.Grid('gridIntrDsipRet', dataGridOption);
}

// ��ʼ�� - ҩƷ̨��
function InitGridIntrTotal(){
	var columns = [
		[
			{
				title: "incil",
				field: "incil",
				width: 100,
				hidden: true
			}, {
				title: "ҩƷ����",
				field: "inciCode",
				width: 100
			}, {
				title: "ҩƷ����",
				field: "inciDesc",
				width: 180
			}, {
				title: "���",
				field: "inciSpec",
				width: 90
			}, {
				title: "��Ӫ��ҵ",
				field: "venDesc",
				width: 120
			}, {
				title: "������ҵ",
				field: "manfName",
				width: 120
			}, {
				title: "��ⵥλ",
				field: "pUomDesc",
				width: 70
			}, {
				title: "������λ",
				field: "bUomDesc",
				width: 70
			}, {
				title: "�ڳ�����(��)",
				field: "begQty",
				width: 110,
				align: 'right',
				hidden: true
			}, {
				title: "�ڳ�����",
				field: "begQtyUom",
				width: 110,
				align: 'right'
			}, {
				title: "�ڳ����(��)",
				field: "begRpAmt",
				width: 130,
				align: 'right'
			}, {
				title: "�ڳ����(��)",
				field: "begSpAmt",
				width: 130,
				align: 'right'
			}, {
				title: "��ĩ����(��)",
				field: "endQty",
				width: 110,
				align: 'right',
				hidden: true
			}, {
				title: "��ĩ����",
				field: "endQtyUom",
				width: 110,
				align: 'right'
			}, {
				title: "��ĩ���(��)",
				field: "endRpAmt",
				width: 130,
				align: 'right'
			}, {
				title: "��ĩ���(��)",
				field: "endSpAmt",
				width: 130,
				align: 'right'
			}, {
				title: "��������(��)",
				field: "plusQty",
				width: 100,
				align: 'right'
			}, {
				title: "��������(��)",
				field: "minusQty",
				width: 100,
				align: 'right'
			}, {
				title: "���ӽ��",
				field: "plusSpAmt",
				width: 100,
				align: 'right'
			}, {
				title: "���ٽ��",
				field: "minusSpAmt",
				width: 100,
				align: 'right'
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.IN.Narc.Trans',
			QueryName: 'IntrTotal'
		},
		singleSelect: true,
		pagination: true,
		columns: columns,
		toolbar: [],
		onSelect: function(rowIndex, rowData) {
			QueryIntrDetail();
		},
		gridSave: false,
		onLoadSuccess: function(data){}
	};
	PHA.Grid('gridIntrTotal', dataGridOption);
}

// ��ʼ�� - ̨����ϸ
function InitGridIntrDetail(){
	var columns = [
		[
			{
				title: "intr",
				field: "intr",
				width: 100,
				hidden: true
			}, {
				title: "ҵ������",
				field: "intrDT",
				width: 155
			}, {
				title: "ҵ������",
				field: "intrTypeDesc",
				width: 90
			}, {
				title: "����Ч��",
				field: "batStr",
				width: 175
			}, {
				title: "����(��)",
				field: "pQty",
				width: 70,
				align: 'right'
			}, {
				title: "��ⵥλ",
				field: "pUomDesc",
				width: 70
			}, {
				title: "�ۼ�",
				field: "pSp",
				width: 100,
				align: 'right'
			}, {
				title: "����",
				field: "pRp",
				width: 100,
				align: 'right'
			}, {
				title: "�ۼ۽��",
				field: "spAmt",
				width: 100,
				align: 'right'
			}, {
				title: "���۽��",
				field: "rpAmt",
				width: 100,
				align: 'right'
			}, {
				title: "��������(��)",
				field: "curPQty",
				width: 110,
				align: 'right'
			}, {
				title: "������(��)",
				field: "curSpAmt",
				width: 130,
				align: 'right'
			}, {
				title: "������(��)",
				field: "curRpAmt",
				width: 130,
				align: 'right'
			}, {
				title: "������",
				field: "userName",
				width: 110
			}, {
				title: "ҵ��ID",
				field: "intrPointer",
				width: 150,
				hidden: true
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.IN.Narc.Trans',
			QueryName: 'IntrDetail'
		},
		singleSelect: true,
		pagination: true,
		columns: columns,
		toolbar: [],
		gridSave: true,
		onClickCell: function(index, field, value) {},
		onLoadSuccess: function(data){}
	};
	PHA.Grid('gridIntrDetail', dataGridOption);
}

/*
* �������
*/
function Query() {
	var tab = $('#tabsIntr').tabs('getSelected');
	var tabTndex = $('#tabsIntr').tabs('getTabIndex', tab);
	if (tabTndex == 0) {
		QueryIntrDsipRet();
	} else {
		QueryIntrTotal();
	}
	
}
function QueryIntrDsipRet(){
	var formData = GetFormData();
	
	var needTypeArr = ['P', 'Y', 'F', 'H'];
	var intrTypeStr = formData.intrTypeStr;
	var intrTypeArr = intrTypeStr.split(',');
	for (var i in intrTypeArr) {
		var iType = intrTypeArr[i] || '';
		if (needTypeArr.indexOf(iType) < 0) {
			PHA.Popover({
				msg: "ҵ������ֻ��ѡ��[סԺ��ҩ/סԺ��ҩ/���﷢ҩ/������ҩ]",
				type: "alert"
			});
			return;
		}
	}
	
	$('#gridIntrDsipRet').datagrid('query', {
		pJsonStr: JSON.stringify(formData)
	});
}
function QueryIntrTotal(){
	var formData = GetFormData();
	$('#gridIntrDetail').datagrid('clear');
	$('#gridIntrTotal').datagrid('query', {
		pJsonStr: JSON.stringify(formData)
	});
}
function QueryIntrDetail(){
	var formData = GetFormData();
	var selRow = $('#gridIntrTotal').datagrid('getSelected');
	if (selRow == null) {
		return;
	}
	formData.incil = selRow.incil || '';
	$('#gridIntrDetail').datagrid('query', {
		pJsonStr: JSON.stringify(formData)
	});
}

// ��ȡ����
function GetFormData(){
	var formDataArr = PHA.DomData('#panelNarcIntr', {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return;
	}
	var formData = formDataArr[0];
	// ҽԺ
	formData.hospId = session['LOGON.HOSPID'];
	return formData;
}

// ��ս���
function Clear(){
	PHA.DomData('#panelNarcIntr', {
		doType: 'clear'
	});
	$('#startDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Reg.StDate']));
	$('#endDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Reg.EdDate']));
	PHA.SetComboVal('poisonIdStr', PHA_COM.VAR.CONFIG['Com.PoisonIdStr']);
	$('#inci').combogrid('setValue', '');
	$('#stkCatId').combobox('reload');
	$('#gridIntrDsipRet').datagrid('clear');
	$('#gridIntrTotal').datagrid('clear');
	$('#gridIntrDetail').datagrid('clear');
	InitDictVal();
}

function InitConfig() {
	$.cm({
		ClassName: 'PHA.IN.Narc.Com',
		MethodName: 'GetConfigParams',
		InputStr: PHA_COM.Session.ALL
	}, function(retJson) {
		// ���ݸ�ȫ��
		PHA_COM.VAR.CONFIG = retJson;
		$('#startDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Reg.StDate']));
		$('#endDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Reg.EdDate']));
		PHA.SetComboVal('poisonIdStr', PHA_COM.VAR.CONFIG['Com.PoisonIdStr']);
	}, function(error){
		console.dir(error);
		alert(error.responseText);
	});
}
