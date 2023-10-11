/**
 * @ģ��:     ��ҩ����-�շ�
 * @��д����: 2019-07-05
 * @��д��:   hulihua
 */
var decPdCode = "SF";
var Number = 0;
var pageTbNum = 15;
var NowTAB=""; 			//��¼��ǰҳǩ��tab
$(function () {
	InitDict();
	InitGridScanPresc();
	InitGridBatPresc();
	InitGridColPresc();
	InitSetDefVal("");
	$('#txtBarCode').on('keypress', function (event) {
		if (event.keyCode == "13") {
			var tabTitle = $('#tabsColPre').tabs('getSelected').panel('options').title;
			if (tabTitle != "ɨ���շ�") {
				$("#tabsColPre").tabs("select", 0);
			}
			var barDecLocId = $("#cmbBarDecLoc").combobox('getValue');
			if (barDecLocId == "") {
				PHA.Popover({
					msg: "����ѡ���ҩ���ң�",
					type: 'alert'
				});
				$('#txtBarCode').val("");
				return;
			};
			if (this.value.trim() == "") {
				PHA.Popover({
					msg: "������Ϊ�գ�",
					type: 'alert'
				});
				$('#txtBarCode').val("");
				return;
			}
			
			ScanExecute(this.value);
			$(this).val("");
		}
	});

	$("#tabsColPre").on("click", ChangeTabs);
});

/**
 * ��ʼ�����
 * @method InitDict
 */
function InitDict() {
	PHA.ComboBox("cmbDecLoc", {
		url: PHA_DEC_STORE.DecLoc().url
	});
	PHA.ComboBox("cmbPhaLoc", {
		url: PHA_DEC_STORE.Pharmacy("").url
	});
	PHA.ComboBox("cmbBarDecLoc", {
		url: PHA_DEC_STORE.DecLoc().url
	});
}

/**
 * ���ؼ�����ʼֵ
 * @method InitSetDefVal
 */
function InitSetDefVal(clearFlag) {
	//��������
	var ComPropData = $.cm({	
		ClassName: "PHA.DEC.Com.Method", 
		MethodName: "GetAppProp", 
		UserId: gUserID, 
		LocId: gLocId, 
		SsaCode: "DEC.COMMON", 
		AppCode:""
		}, false)
		$HUI.radio("#radioAll").setValue(true);
		if(parseInt(ComPropData.ScanPageTbNum)>0){
			pageTbNum=parseInt(ComPropData.ScanPageTbNum);
		}
		$("#cmbBarDecLoc").combobox("setValue", ComPropData.DefaultDecLoc);	
		if (clearFlag ==""){
			$("#tabsColPre").tabs("select", parseInt(ComPropData.OperateModel));
		}
		if(ComPropData.PrescView=="Y") { 
			DEC_PRESC.Layout("mainLayout", {width: ComPropData.PrescWidth});	//��ʾ����Ԥ��panel
		}
		var tabId= $('#tabsColPre').tabs('getSelected').attr("id");
		NowTAB = tabId;		
		if (NowTAB == "tabPresc") {
			//$('#colprelayout').layout('collapse', 'north');
			$("#chkOnlyColPre").parent().css('visibility','hidden');
			$('#txtBarCode').focus(); 
			$("#cmbDecLoc").combobox("setValue", "");
			$("#cmbPhaLoc").combobox("setValue", "");
			$HUI.datebox("#dateColStart").disable();
			$HUI.datebox("#dateColEnd").disable();
			$HUI.timespinner("#timeColStart").disable();
			$HUI.timespinner("#timeColEnd").disable();
			$HUI.combobox("#cmbDecLoc").disable();
			$HUI.combobox("#cmbPhaLoc").disable();
			$HUI.radio("[name='busType']").disable();
			$HUI.checkbox("#onlyColPre").disable();
			
		} else {
			if (NowTAB == "tabBatPresc") {
				$("#chkOnlyColPre").parent().css('visibility','hidden');
			}
			else{
				$("#chkOnlyColPre").parent().css('visibility','visible');
			}	
			//$('#colprelayout').layout('expand', 'north');
			$("#cmbDecLoc").combobox("setValue", ComPropData.DefaultDecLoc);
			$("#cmbPhaLoc").combobox("setValue", ComPropData.DefaultPhaLoc);
			$HUI.datebox("#dateColStart").enable();
			$HUI.datebox("#dateColEnd").enable();
			$HUI.timespinner("#timeColStart").enable();
			$HUI.timespinner("#timeColEnd").enable();
			$HUI.combobox("#cmbDecLoc").enable();
			$HUI.combobox("#cmbPhaLoc").enable();
			$HUI.radio("[name='busType']").enable();
			$HUI.checkbox("#onlyColPre").enable();
		
			//��������
			$.cm({
				ClassName: "PHA.DEC.Com.Method",
				MethodName: "GetAppProp",
				UserId: gUserID,
				LocId: gLocId,
				SsaCode: "DEC.COLPRESC"
			}, function (jsonColData) {
				if (NowTAB == "tabPresc"){
					return ;
				}
				$("#dateColStart").datebox("setValue", jsonColData.ColStartDate);
				$("#dateColEnd").datebox("setValue", jsonColData.ColEndDate);
				$('#timeColStart').timespinner('setValue', "00:00:00");
				$('#timeColEnd').timespinner('setValue', "23:59:59");
				
			});
			if (clearFlag ==""){
				setTimeout("Query()",1000);
			}
		}
}

/**
 * �л�ҳǩ
 * @method ChangeTabs
 */
function ChangeTabs() {
	var tabId= $('#tabsColPre').tabs('getSelected').attr("id");
	if(NowTAB==tabId){
		return;
	}
	NowTAB=tabId;
	if (NowTAB == "tabPresc") {
		//$('#colprelayout').layout('collapse', 'north');
		$("#chkOnlyColPre").parent().css('visibility','hidden');
		$('#txtBarCode').focus();
		$("#dateColStart").datebox("setValue", "");
		$("#dateColEnd").datebox("setValue", "");
		$('#timeColStart').timespinner('setValue', "");
		$('#timeColEnd').timespinner('setValue', "");
		$("#cmbDecLoc").combobox("setValue", "");
		$("#cmbPhaLoc").combobox("setValue", "");
		$HUI.datebox("#dateColStart").disable();
		$HUI.datebox("#dateColEnd").disable();
		$HUI.timespinner("#timeColStart").disable();
		$HUI.timespinner("#timeColEnd").disable();
		$HUI.combobox("#cmbDecLoc").disable();
		$HUI.combobox("#cmbPhaLoc").disable();
		$HUI.radio("[name='busType']").disable();
		$HUI.checkbox("#onlyColPre").disable();
	}else{
		//��������
		$.cm({
			ClassName: "PHA.DEC.Com.Method",
			MethodName: "GetAppProp",
			UserId: gUserID,
			LocId: gLocId,
			SsaCode: "DEC.COMMON",
		}, function (jsonComData) {
			$("#cmbDecLoc").combobox("setValue", jsonComData.DefaultDecLoc);
			$("#cmbPhaLoc").combobox("setValue", jsonComData.DefaultPhaLoc);	
		});
			
		$HUI.datebox("#dateColStart").enable();
		$HUI.datebox("#dateColEnd").enable();
		$HUI.timespinner("#timeColStart").enable();
		$HUI.timespinner("#timeColEnd").enable();
		$HUI.combobox("#cmbDecLoc").enable();
		$HUI.combobox("#cmbPhaLoc").enable();
		$HUI.radio("[name='busType']").enable();
		$HUI.checkbox("#onlyColPre").enable();
		//��������
		$.cm({
			ClassName: "PHA.DEC.Com.Method",
			MethodName: "GetAppProp",
			UserId: gUserID,
			LocId: gLocId,
			SsaCode: "DEC.COLPRESC"
		}, function (jsonColData) {
			$("#dateColStart").datebox("setValue", jsonColData.ColStartDate);
			$("#dateColEnd").datebox("setValue", jsonColData.ColEndDate);
			$('#timeColStart').timespinner('setValue', "00:00:00");
			$('#timeColEnd').timespinner('setValue', "23:59:59");
			
		});
		
		if ($(".panel.layout-panel.layout-panel-north").css("top") != "0px"){
			//$('#colprelayout').layout('expand', 'north');
		}
		
		if(NowTAB == "tabBatPresc"){
			$("#chkOnlyColPre").parent().css('visibility','hidden');
			$('#gridBatPresc').datagrid('clear');	
		}else{
			$("#chkOnlyColPre").parent().css('visibility','visible');
			$('#gridColPresc').datagrid('clear');	
		}
		
	
		setTimeout("Query()",500);
	}
	
}

/**
 * ��ʼ��ɨ���շ����
 * @method InitGridScanPresc
 */
function InitGridScanPresc() {
	var columns = [
		[{
				field: 'TPrescNo',
				title: '������',
				align: 'left',
				width: 120
			}, {
				field: 'TPreFacTor',
				title: '����',
				align: 'left',
				width: 70
			}, {
				field: 'TPreCount',
				title: 'ζ��',
				align: 'left',
				width: 70
			}, {
				field: 'TPreForm',
				title: '��������',
				align: 'left',
				width: 80
			}, {
				field: 'TPreEmFlag',
				title: '�Ƿ�Ӽ�',
				align: 'left',
				width: 70
			}, {
				field: 'TPhaLocDesc',
				title: '��������',
				align: 'left',
				width: 120
			}, {
				field: 'TOperUser',
				title: '������',
				align: 'left',
				width: 100
			}, {
				field: 'TOperDate',
				title: '����ʱ��',
				align: 'left',
				width: 150
			}, {
				field: 'TPatNo',
				title: '�ǼǺ�',
				align: 'left',
				width: 120
			}, {
				field: 'TPatName',
				title: '��������',
				align: 'left',
				width: 120
			}, {
				field: 'TDocLocDesc',
				title: '��������',
				align: 'left',
				width: 180
			}, {
				field: 'TCookCost',
				title: '��ҩ��',
				align: 'left',
				width: 150
			}
		]
	];
	var dataGridOption = {
		url: '',
		fit: true,
		rownumbers: true,
		columns: columns,
		nowrap:false ,
		pagination: false,
		toolbar: '#gridScanPrescBar',
		singleSelect: true,
		onRowContextMenu: function(){
			return false;	
		},
		onSelect: function (rowIndex, rowData) {
			var prescNo = rowData.TPrescNo;
			ColPrescView(prescNo);
		},
	};
	PHA.Grid("gridScanPresc", dataGridOption);
}

/**
 * ��ʼ�������շ����
 * @method InitGridBatPresc
 */
function InitGridBatPresc() {
	var columns = [
		[{
				field: 'gridPreSelect',
				checkbox: true
			}, {
				field: 'TPrescNo',
				title: '������',
				align: 'left',
				width: 120
			}, {
				field: 'TPreFacTor',
				title: '����',
				align: 'left',
				width: 60
			}, {
				field: 'TPreCount',
				title: 'ζ��',
				align: 'left',
				width: 60
			}, {
				field: 'TPreForm',
				title: '��������',
				align: 'left',
				width: 80
			}, {
				field: 'TPreEmFlag',
				title: '�Ƿ�Ӽ�',
				align: 'left',
				width: 70
			}, {
				field: 'TPhaLocDesc',
				title: '��������',
				align: 'left',
				width: 120
			}, {
				field: 'TOperUser',
				title: '������',
				align: 'left',
				width: 100
			}, {
				field: 'TOperDate',
				title: '����ʱ��',
				align: 'left',
				width: 150
			}, {
				field: 'TPatNo',
				title: '�ǼǺ�',
				align: 'left',
				width: 120
			}, {
				field: 'TPatName',
				title: '��������',
				align: 'left',
				width: 120
			}, {
				field: 'TDocLocDesc',
				title: '��������',
				align: 'left',
				width: 180
			}, {
				field: 'TCookCost',
				title: '��ҩ��',
				align: 'left',
				width: 140
			}, {
				field: 'TPointer',
				title: 'ָ��ID',
				align: 'left',
				hidden: true
			}, {
				field: 'TDispType',
				title: '��ҩ����',
				align: 'left',
				hidden: true
			}
		]
	];
	var dataGridOption = {
		url: '',
		fit: true,
		toolbar: '#gridBatPrescBar',
		rownumbers: true,
		columns: columns,
		pageSize: 50,
		pageList: [50, 100, 200],
		pagination: true,
		singleSelect: false,
		selectOnCheck: true,
		checkOnSelect: true,
		nowrap:false ,
		url: $URL,
		queryParams: {
			ClassName: "PHA.DEC.ColPre.Query",
			QueryName: "BatColPre",
		},
		onLoadSuccess: function () {
			$('#gridBatPresc').datagrid('uncheckAll');
		}
	};
	PHA.Grid("gridBatPresc", dataGridOption);
}

/**
 * ��ʼ�����շ����
 * @method InitGridColPresc
 */
function InitGridColPresc() {
	var columns = [
		[{
				field: 'TPrescNo',
				title: '������',
				align: 'left',
				width: 130
			}, {
				field: 'TPreFacTor',
				title: '����',
				align: 'left',
				width: 70
			}, {
				field: 'TPreCount',
				title: 'ζ��',
				align: 'left',
				width: 70
			}, {
				field: 'TPreForm',
				title: '��������',
				align: 'left',
				width: 80
			}, {
				field: 'TPreEmFlag',
				title: '�Ƿ�Ӽ�',
				align: 'left',
				width: 70
			}, {
				field: 'TPhaLocDesc',
				title: '��������',
				align: 'left',
				width: 130
			}, {
				field: 'TColUser',
				title: '�շ���',
				align: 'left',
				width: 130
			}, {
				field: 'TColDate',
				title: '�շ�ʱ��',
				align: 'left',
				width: 150
			}, {
				field: 'TPatNo',
				title: '�ǼǺ�',
				align: 'left',
				width: 120
			}, {
				field: 'TPatName',
				title: '��������',
				align: 'left',
				width: 140
			}, {
				field: 'TDecLocDesc',
				title: '��ҩ����',
				align: 'left',
				width: 130
			}, {
				field: 'TDecType',
				title: '��ҩ����',
				align: 'left',
				width: 80
			}, {
				field: 'TPdpmId',
				title: '��ҩID',
				align: 'left',
				hidden: true
			}
		]
	];
	var dataGridOption = {
		url: '',
		fit: true,
		rownumbers: true,
		columns: columns,
		pageSize: 50,
		pageList: [50, 100, 200],
		pagination: true,
		singleSelect: true,
		selectOnCheck: false,
		checkOnSelect: false,
		url: $URL,
		queryParams: {
			ClassName: "PHA.DEC.ColPre.Query",
			QueryName: "AlrColPre",
		}
	};
	PHA.Grid("gridColPresc", dataGridOption);
}

/**
 * ɨ��ִ��
 * @method ScanExecute
 */
function ScanExecute(barCode) {
	var barCode = barCode.trim();
	//var prescNo = rowData.TPrescNo;
	var barDecLocId = $("#cmbBarDecLoc").combobox('getValue');
	var LogonInfo = gGroupId + "^" + barDecLocId+ "^" + gUserID
			
	var jsonData = $cm({
			ClassName: "PHA.DEC.ColPre.Query",
			MethodName: "GetBarCodeInfo",
			BarCode: barCode,
			DecLocID: barDecLocId,
			LogonInfo: LogonInfo ,
			dataType: 'json'
		}, false);
	var retCode = jsonData.retCode;
	if (retCode < 0) {
		PHA.Popover({
			msg: jsonData.retMessage,
			type: 'alert'
		});
		return;
	} else {
		var decLocId = $('#cmbBarDecLoc').combobox("getValue") || "";
		$.m({
			ClassName: "PHA.DEC.ColPre.OperTab",
			MethodName: "ScanSave",
			PrescNo: barCode,
			ProUserId: gUserID,
			ProdCode: decPdCode,
			DecLodId: decLocId,
			HospId: gHospID
		}, function (retData) {
			var retArr = retData.split("^");
			if (retArr[0] < 0) {
				$.messager.alert('��ʾ', retArr[1], 'warning');
				return ;
			} else {
				PHA.Popover({
					msg: "�շ��ɹ���",
					type: 'success'
				});
				ColPrescView(barCode);
				$('#gridScanPresc').datagrid('insertRow', {
					index: 0,
					row: jsonData
				});
				Number = Number + 1; //������id˳���
				$('#gridScanPresc').datagrid('selectRow', 0);
				var totalRows = $('#gridScanPresc').datagrid('getRows').length;
				if (totalRows > pageTbNum) { //�������õ�������ÿ����һ������ɾ��һ��֮ǰ������
					if ((Number - pageTbNum) != 0) {
						$('#gridScanPresc').datagrid('deleteRow', pageTbNum);
					}
				}
			}
			$('#txtBarCode').focus();
		});
	}

}

/**
 * ����Ԥ��
 * @method PrescView
 */
function ColPrescView(prescno){
	var phartype = "O";
	if(prescno.indexOf("I")>-1){
		phartype = "I";
	}
	var cyflag = "Y";
	DEC_PRESC.Presc("divPreLayout", {
		PrescNo: prescno, 
		AdmType: phartype,
		CY: cyflag
	}); 
}

/**
 * ��ѯ����
 * @method Query
 */
function Query() {
	if (NowTAB == "tabPresc") {
		return;
	}
	var params = GetParams();
	if (params == "") {
		return;
	}
	var tabTitle = $('#tabsColPre').tabs('getSelected').panel('options').title;
	if (tabTitle == "�����շ�") {
		//$('#gridBatPresc').datagrid('uncheckAll');
		$('#gridBatPresc').datagrid('query', {
			ParamStr: params
		});
	} else if (tabTitle == "���շ���ѯ") {
		var decLocId = $('#cmbDecLoc').combobox("getValue") || "";
		if (decLocId == "") {
			PHA.Popover({
				msg: "����ѡ����Ҫ��ѯ�ļ�ҩ�ң�",
				type: 'alert'
			});
			return;
		}
		$('#gridColPresc').datagrid('query', {
			ParamStr: params
		});
	} else {
		$.messager.alert("��ʾ", "��ҳǩ�����ѯ��", "info");
		return;
	}
}

/*
 * ����
 * @method Clear
 */
function Clear() {
	InitSetDefVal("Y");
	$('#gridScanPresc').datagrid('clear');
	$('#gridBatPresc').datagrid('clear');
	$('#gridColPresc').datagrid('clear');
	ColPrescView("")
	$('#txtBarCode').val("");
}

/**
 * ��ȡ����Ԫ��ֵ
 * @method GetParams
 */
function GetParams() {
	var stDate = $("#dateColStart").datebox('getValue');
	var enDate = $("#dateColEnd").datebox('getValue');
	var stTime = $('#timeColStart').timespinner('getValue');
	var enTime = $('#timeColEnd').timespinner('getValue');
	var locId = $('#cmbPhaLoc').combobox("getValue") || "";
	var type = $("input[name='busType']:checked").val() || ""; 
	var onlyCPFlag = ($('#chkOnlyColPre').checkbox('getValue')==true?'Y':'N');
	var decLocId = $('#cmbDecLoc').combobox("getValue") || "";
	
	var params = stDate + "^" + enDate + "^" + stTime + "^" + enTime + "^" + locId ;
	var params = params + "^" + type +"^"+ onlyCPFlag +"^"+ decLocId + "^" + gGroupId + "^" + gUserID;
	
	return params;
}

/**
 * ��ȡѡ�м�¼��������ϸ�Ĵ�����
 * @method SaveBat
 */
function GetCheckedPreArr() {
	var batPreArr = [];
	var gridBatPrescChecked = $('#gridBatPresc').datagrid('getChecked');
	for (var i = 0; i < gridBatPrescChecked.length; i++) {
		var checkedData = gridBatPrescChecked[i];
		var dispType = checkedData.TDispType;
		var pointer = checkedData.TPointer;
		var dataStr = dispType + "^" + pointer;
		if (batPreArr.indexOf(dataStr) < 0) {
			batPreArr.push(dataStr);
		}
	}
	return batPreArr.join("!!");
}

/**
 * �����շ�
 * @method SaveBat
 */
function SaveBat() {
	var preDataStr = GetCheckedPreArr();
	if (preDataStr == "") {
		PHA.Popover({
			msg: "�빴ѡ��Ҫ��ȡ�Ĵ�����",
			type: 'alert'
		});
		return;
	}
	var decLocId = $('#cmbDecLoc').combobox("getValue") || "";
	if (decLocId == "") {
		PHA.Popover({
			msg: "��ѡ����յļ�ҩ�ң�",
			type: 'alert'
		});
		return;
	}
	$.m({
		ClassName: "PHA.DEC.ColPre.OperTab",
		MethodName: "SaveBatch",
		MultiDataStr: preDataStr,
		ProUserId: gUserID,
		ProdCode: decPdCode,
		DecLodId: decLocId,
		HospId: gHospID
	}, function (retData) {
		if (retData.indexOf("Msg") >= 0) {
			$.messager.alert('��ʾ', JSON.parse(retData).msg, 'error');
			return;
		}
		var retArr = retData.split("^");
		if (retArr[0] < 0) {
			$.messager.alert('��ʾ', retArr[1], 'warning');
			return;
		} else {
			PHA.Popover({
				msg: "�շ��ɹ���",
				type: 'success'
			})
		}
		Query();
	});

}
