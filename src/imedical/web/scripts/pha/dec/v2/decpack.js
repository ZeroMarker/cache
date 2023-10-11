/**
 * @ģ��:     ��ҩ��-ҩ��װ��
 * @��д����: 2021-03-01
 * @��д��:   MaYuqiang
 */
var NowTAB = ""; 	//��¼��ǰҳǩ��tab
var locId = session['LOGON.CTLOCID'];
var opUser = session['LOGON.USERID'];
var curDeptId = ""	//������������ܿ���(����->ҩ��;סԺ->����)
var curDeptDesc = ""
var prescrArr = []	// ��������
var LogonInfo = gGroupId + "^" + locId + "^" + opUser + "^" + gHospID;
var HDDActiveFlag = tkMakeServerCall("web.DHCST.Common.AppCommon", "GetAppPropValue","HDD.COMMON","SystemActiveFlag",LogonInfo)
$(function () {
	InitDict();
	InitGridScanPresc();
	InitGridBatchPresc();
	// �����Żس��¼�
	$("#txtBarCode").on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var barCode = $.trim($("#txtBarCode").val());
			if (barCode == "") {
				PHA.Popover({
					msg: "������Ϊ�գ�",
					type: 'alert'
				});
				$('#txtBarCode').val("");
				return;
			}
			AddBarCodeInfo(barCode);
			$(this).val("");
		}
	})
	// �ǼǺŻس��¼�
	$('#txtPatNo').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var patno = $.trim($("#txtPatNo").val());
			if (patno != "") {
				$(this).val(PHA_COM.FullPatNo(patno));
				query();
			}
		}
	});
	// ���Żس��¼�
	$("#txtCardNo").on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var cardNo = $.trim($("#txtCardNo").val());
			if (cardNo != "") {
				BtnReadCardHandler();
			}
		}
	})
	
	$('#readCard').on('click', BtnReadCardHandler) ;
	// ��ѡ���¼�,�л�ҳǩ�Զ���ѯ
	$("#dispTab").tabs({
		onSelect: function(title, index){
			var tabId = $('#dispTab').tabs('getSelected').attr("id");
			if (title == "ɨ��װ��"){
				NowTAB = tabId
				$('#txtBarCode').focus();
				$("#dateStart").datebox("setValue", "");
				$("#dateEnd").datebox("setValue", "");
				$('#timeStart').timespinner('setValue', "");
				$('#timeEnd').timespinner('setValue', "");
				$HUI.datebox("#dateStart").disable();
				$HUI.datebox("#dateEnd").disable();
				$HUI.timespinner("#timeStart").disable();
				$HUI.timespinner("#timeEnd").disable();
				$('#txtCardNo').val("").prop('disabled', true);
				$('#txtPatNo').val("").prop('disabled', true);
			}
			else {
				NowTAB = tabId
				$.cm({	
					ClassName: "PHA.DEC.Com.Method", 
					MethodName: "GetAppProp", 
					UserId: gUserID, 
					LocId: gLocId, 
					SsaCode: "DEC.OUTDISP", 
					AppCode:""
					}, function(AppPropData){
						$("#dateStart").datebox("setValue", AppPropData.DispStartDate);
						$("#dateEnd").datebox("setValue", AppPropData.DispEndDate);
						$('#timeStart').timespinner('setValue', "00:00:00");
						$('#timeEnd').timespinner('setValue', "23:59:59");
					
						$HUI.datebox("#dateStart").enable();
						$HUI.datebox("#dateEnd").enable();
						$HUI.timespinner("#timeStart").enable();
						$HUI.timespinner("#timeEnd").enable();
						$('#txtCardNo').val("").prop('disabled', false);
						$('#txtPatNo').val("").prop('disabled', false);
						queryBatchPrescList() ;
				});
			}
			
		}
	})
});

/**
 * ��ʼ�����
 * @method InitDict
 */
function InitDict() {
	var ComPropData = $.cm({	
		ClassName: "PHA.DEC.Com.Method", 
		MethodName: "GetAppProp", 
		UserId: gUserID, 
		LocId: gLocId, 
		SsaCode: "DEC.COMMON", 
		AppCode:""
		}, false)
	PHA.ComboBox("cmbDecLoc", {
		width: '120',
		url: PHA_DEC_STORE.DecLoc().url,
		onLoadSuccess: function() {
			$("#cmbDecLoc").combobox("setValue", ComPropData.DefaultDecLoc);
		}  
	});
	PHA.ComboBox("cmbPhaLoc", {
		width: '120',
		url: PHA_DEC_STORE.Pharmacy("").url,
		onLoadSuccess: function() {
			$("#cmbPhaLoc").combobox("setValue", ComPropData.DefaultPhaLoc);
		}
	});
	PHA.ComboBox("cmbWardLoc", {
		width: '155',
		url: PHA_STORE.WardLoc("","").url,
		onLoadSuccess: function() {
			//$("#cmbWardLoc").combobox("setValue", ComPropData.DefaultPhaLoc);
		}
	});	
	
	// ��������
    PHA.ComboBox('cmbAdmType', {
        width: '155',
        data: [
            { RowId: 'O', Description: $g('����') },
            { RowId: 'I', Description: $g('סԺ') }
        ],
        panelHeight: 'auto',
        onLoadSuccess: function(data) {
			//$("#cmbAdmType").combobox("setValue", "O");
		} 
	});
	//������
	PHA.ComboBox("cmbCardType", {
		width: '110',
		url: PHA_DEC_STORE.CardType("").url,
		onLoadSuccess: function(data) {
			var data = $("#cmbCardType").combobox("getData")
			$.each(data, function(key, val){
				var defaultflag = val.RowId.split("^")[8];
				if(defaultflag=="Y"){
					$("#cmbCardType").combobox("setValue", val.RowId);
				}
			})	
		} 
	});
	// ����Ĭ��ֵ
	$.cm({	
		ClassName: "PHA.DEC.Com.Method", 
		MethodName: "GetAppProp", 
		UserId: gUserID, 
		LocId: gLocId, 
		SsaCode: "DEC.OUTDISP", 
		AppCode:""
		}, function(AppPropData){
			var tabId= $('#dispTab').tabs('getSelected').attr("id");
			if (NowTAB == "tabScanDisp"){
				return ;	
			}
			$("#dateStart").datebox("setValue", AppPropData.DispStartDate);
			$("#dateEnd").datebox("setValue", AppPropData.DispEndDate);
			$('#timeStart').timespinner('setValue', "00:00:00");
			$('#timeEnd').timespinner('setValue', "23:59:59");
			//$("#txtBarCode").focus();
		});
		
	$("#dispTab").tabs("select",parseInt(ComPropData.OperateModel));	
	var tabId = $('#dispTab').tabs('getSelected').attr("id");
	NowTAB = tabId;	
	if (NowTAB == "tabScanDisp"){
		$('#txtBarCode').focus();
		$("#dateStart").datebox("setValue", "");
		$("#dateEnd").datebox("setValue", "");
		$('#timeStart').timespinner('setValue', "");
		$('#timeEnd').timespinner('setValue', "");
		$HUI.datebox("#dateStart").disable();
		$HUI.datebox("#dateEnd").disable();
		$HUI.timespinner("#timeStart").disable();
		$HUI.timespinner("#timeEnd").disable();
		$('#txtCardNo').val("").prop('disabled', true);
		$('#txtPatNo').val("").prop('disabled', true);	
	}
	else {
		$.cm({	
			ClassName: "PHA.DEC.Com.Method", 
			MethodName: "GetAppProp", 
			UserId: gUserID, 
			LocId: gLocId, 
			SsaCode: "DEC.OUTDISP", 
			AppCode:""
			}, function(AppPropData){
				$("#dateStart").datebox("setValue", AppPropData.DispStartDate);
				$("#dateEnd").datebox("setValue", AppPropData.DispEndDate);
				$('#timeStart').timespinner('setValue', "00:00:00");
				$('#timeEnd').timespinner('setValue', "23:59:59");
				$HUI.datebox("#dateStart").enable();
				$HUI.datebox("#dateEnd").enable();
				$HUI.timespinner("#timeStart").enable();
				$HUI.timespinner("#timeEnd").enable();
				$('#txtCardNo').val("").prop('disabled', false);
				$('#txtPatNo').val("").prop('disabled', false);
			});	
	}
}
/**
 * ��ʼ��ɨ��װ�䴦���б�
 * @method InitGridScanPresc
 */
function InitGridScanPresc() {
	var columns = [[ 
		{
			field:'pdCheck',
			checkbox: true	
		},
		{	field:'pdpmItmId',		
			title:'pdpmItmId',		
			hidden:'true',	
			width: 50
		},
		{
			field:'prescNo', 	
			title:'������',	  	
			align:'left', 
			width: 130
		},
		{
			field:'locDesc', 	
			title:'ҩ��/����',	  	
			align:'left', 
			width: 150
		}, 
		{
			field:'dispNum',	
			title:'���Ÿ���',		
			align:'left', 
			width: 80
		},
		{
			field:'dispUserName',	
			title:'������Ա',		
			align:'left', 
			width: 80
		},
		{
			field:'dispDateTime',	
			title:'����ʱ��',		
			align:'left', 
			width: 120
		},
		{
			field:'patNo',		
			title:'�ǼǺ�',		
			align:'left', 
			width: 100
		}, 
		{
			field:'patName',	
			title:'��������',	
			align:'left', 
			width: 100
		}, 
		{
			field:'preFacTor',	
			title:'�ܸ���',		
			align:'right', 
			width: 60
		}, 
		
		{
			field:'decTypeDesc', 	
			title:'��������', 	
			align:'left', 
			width: 70
		}, 
		{
			field:'decDate',	
			title:'�շ�ʱ��', 	
			align:'left', 
			width: 150
		},
		{
			field:'preCount',	
			title:'ζ��',		
			align:'right', 
			width: 45
		}, 
		{
			field:'preForm',	
			title:'��������',	
			align:'left', 
			width: 80
		}, 
		{
			field:'preEmFlag',	
			title:'�Ƿ�Ӽ�',	
			align:'left', 
			width: 65
		}, 
		{
			field:'phaLocDesc',	
			title:'��������',	
			align:'left', 
			width: 100
		}, 
		{
			field:'operUserName',	
			title:'������',		
			align:'left', 
			width: 80
		},
		{
			field:'operDate',	
			title:'����ʱ��',	
			align:'left', 
			width: 150
		},
		{
			field:'cookCost',	
			title:'��ҩ��',		
			align:'right', 
			width: 150,
			nowrap:false
		},
		{	field:'locId',		
			title:'ҩ��/����Id',		
			hidden:'true',	
			width: 50
		}
	]];
	var dataGridOption = {
		url: '',
		rownumbers: true,
		toolbar: '#gridScanDispBar',
		columns: columns,
		pagination: false,
		singleSelect: false,
		selectOnCheck: true,
		checkOnSelect: true,
		exportXls: false,
		nowrap:false
	};
	PHA.Grid("gridScanPresc", dataGridOption);
}

/**
 * ��ʼ��ɨ�뷢�Ŵ����б�
 * @method InitGridBatchPresc
 */
function InitGridBatchPresc() {
	var columns = [[ 
		{
			field:'pdCheck',
			checkbox: true	
		},
		{	field:'pdpmItmId',		
			title:'pdpmItmId',		
			hidden:'true',	
			width: 50
		},
		{
			field:'prescNo', 	
			title:'������',	  	
			align:'left', 
			width: 130
		},
		{
			field:'locDesc', 	
			title:'ҩ��/����',	  	
			align:'left', 
			width: 150
		}, 
		{
			field:'dispNum',	
			title:'���Ÿ���',		
			align:'left', 
			width: 80
		},
		{
			field:'dispUserName',	
			title:'������Ա',		
			align:'left', 
			width: 80
		},
		{
			field:'dispDateTime',	
			title:'����ʱ��',		
			align:'left', 
			width: 120
		},
		{
			field:'patNo',		
			title:'�ǼǺ�',		
			align:'left', 
			width: 100
		}, 
		{
			field:'patName',	
			title:'��������',	
			align:'left', 
			width: 100
		}, 
		{
			field:'preFacTor',	
			title:'�ܸ���',		
			align:'right', 
			width: 60
		}, 
		
		{
			field:'decTypeDesc', 	
			title:'��������', 	
			align:'left', 
			width: 70
		}, 
		{
			field:'decDate',	
			title:'�շ�ʱ��', 	
			align:'left', 
			width: 150
		},
		{
			field:'preCount',	
			title:'ζ��',		
			align:'right', 
			width: 45
		}, 
		{
			field:'preForm',	
			title:'��������',	
			align:'left', 
			width: 80
		}, 
		{
			field:'preEmFlag',	
			title:'�Ƿ�Ӽ�',	
			align:'left', 
			width: 65
		}, 
		{
			field:'phaLocDesc',	
			title:'��������',	
			align:'left', 
			width: 100
		}, 
		{
			field:'operUserName',	
			title:'������',		
			align:'left', 
			width: 80
		},
		{
			field:'operDate',	
			title:'����ʱ��',	
			align:'left', 
			width: 150
		},
		{
			field:'cookCost',	
			title:'��ҩ��',		
			align:'right', 
			width: 150,
			nowrap:false
		},
		{	field:'locId',		
			title:'ҩ��/����Id',		
			hidden:'true',	
			width: 50
		}
	]];
	var dataGridOption = {
		toolbar: '#gridDispBatchBar',
		columns: columns,
		url: $URL,
		singleSelect: false,
		selectOnCheck: true,
		checkOnSelect: true,
		nowrap:false,
		rownumbers: true,		
		queryParams: {
			ClassName: "PHA.DEC.DecPack.Query",
			QueryName: "QueryPrescList",
			pJsonStr: ''
		},
		onLoadSuccess: function () {
			$('#gridBatchPresc').datagrid('uncheckAll');
		}
	};
	PHA.Grid("gridBatchPresc", dataGridOption);
}

/**
 * ��ѯ��װ������
 * @method query
 */
function query(){
	queryBatchPrescList() ;
}

/**
 * ɨ�뷢�ţ���ѯ����������
 * @method queryPrtLabList
 */
function AddBarCodeInfo(barCode){	
	var pJson = GetParamsJson();
	var jsonArr = $.cm({
			ClassName: "PHA.DEC.DecPack.Query",
			MethodName: "GetBarCodeInfo",
			BarCode: barCode,
			pJsonStr: JSON.stringify(pJson),
			HospId: gHospID ,
			dataType: 'json'
		}, false);
	
	var jsonData = jsonArr[0] ;
	var jsonData = JSON.parse(jsonData)
	var retCode = jsonData.retCode ;
	if (retCode < 0) {
		PHA.Popover({
			msg: jsonData.retMessage,
			type: 'alert'
		});
		return;
	}
	
	var deptId = jsonData.locId ;
	var prescNo = jsonData.prescNo ;
	
	if ((prescrArr.indexOf(prescNo)>-1)&&(prescrArr.length>0)){
		PHA.Popover({showType: "show", msg: "�ô����ڵ�ǰ�����Ѿ�ɨ���������ظ�ɨ�룡", type: 'alert', timeout:2000});
		return ;
	}
	else {
		prescrArr.push(prescNo)	
	}
	
	if (curDeptId !== ""){
		if (curDeptId !== deptId){
			PHA.Popover({showType: "show", msg: "��ǰɨ�账���� "+curDeptDesc+" �Ĵ�������֮ǰɨ��ҩ����һ�£�", type: 'alert', timeout:3000});
			return;	
		}
	}
	else {
		curDeptId = deptId
		curDeptDesc	= jsonData.locDesc
	}	
	
	for (var i = 0; i < jsonArr.length; i++){
		var jsonData = jsonArr[i] ;
		var jsonData = JSON.parse(jsonData) ;
		$('#gridScanPresc').datagrid('insertRow', {
			index: 0,
			row: jsonData
		});		
	}
		
}

/**
 * �������ţ���ѯ����������
 * @method queryPrtLabList
 */
function queryBatchPrescList(){
	$('#gridBatchPresc').datagrid('clear');
	var pJson = GetParamsJson();
	if (pJson == "") {
		return;
	}
	$('#gridBatchPresc').datagrid('query', {
		pJsonStr: JSON.stringify(pJson)
	});
}


/**
 * ��ȡɨ�뷢�Ž���Ԫ��ֵ
 * @method GetQueryParamsJson
 */
function GetParamsJson() {
	var startDate = $("#dateStart").datebox('getValue')||'' ;
	var endDate = $("#dateEnd").datebox('getValue')||''
	var decLocId = $('#cmbDecLoc').combobox("getValue") || "";
	var phaLocId = $('#cmbPhaLoc').combobox("getValue") || "";
	var admType = $('#cmbAdmType').combobox("getValue") || "";
	var wardLocId = $('#cmbWardLoc').combobox("getValue") || "";
	var tabId= $('#dispTab').tabs('getSelected').attr("id");
	
	if (admType == ""){
		PHA.Popover({showType: "show", msg: "�������Ͳ���Ϊ�գ�", type: 'alert', timeout:2000});
		return "";	
	}
	if (decLocId == ""){
		PHA.Popover({showType: "show", msg: "��ҩ�Ҳ���Ϊ�գ�", type: 'alert', timeout:2000});
		return "";	
	}
	if ((phaLocId == "")&&(admType == "O")){
		PHA.Popover({showType: "show", msg: "��������Ϊ����ʱҩ�����Ҳ���Ϊ�գ�", type: 'alert', timeout:2000});
		return "";	
	}
	if ((wardLocId == "")&&(admType == "I")){
		PHA.Popover({showType: "show", msg: "��������ΪסԺʱ��������Ϊ�գ�", type: 'alert', timeout:2000});
		return "";	
	}if ((wardLocId != "")&&(admType == "O")){
		PHA.Popover({showType: "show", msg: "��������Ϊ����ʱ�����ٰ��ղ�����ѯ��", type: 'alert', timeout:2000});
		return "";	
	}
	if (tabId !== "tabScanDisp"){
		if ((startDate == "")||(endDate == "")){
			PHA.Popover({showType: "show", msg: "��ʼ���ڡ���ֹ���ڲ���Ϊ�գ�", type: 'alert'});
			return "";
		}
	}
    return {
		patNo : $('#txtPatNo').val(),
		startDate : startDate ,
		endDate : endDate ,
		startTime : $('#timeStart').timespinner('getValue')||'' ,
		endTime : $('#timeEnd').timespinner('getValue')||'' ,
		phaLocId : phaLocId ,
		decLocId : decLocId ,
		admType : admType ,
		wardLocId : wardLocId,
		logonLocId : locId

    };
}

//����
function BtnReadCardHandler() {
	var readcardoptions = {
		CardTypeId: "",
		CardNoId: "txtCardNo",
		PatNoId: "txtPatNo"
	}
	PHA_COM.ReadCard(readcardoptions, query) ; 
}

/**
 * ȷ��װ��
 * @method Pack
 */
function Pack() {
	
	var decLocId = $('#cmbDecLoc').combobox("getValue")||'' ;
	if (decLocId == ""){
		PHA.Popover({ showType: "show",	msg: "������������Ҳ���Ϊ�գ�����ҩ�Ҳ���Ϊ�գ�", type: 'error'});	
		return ;
	}
	var decType = $('#cmbAdmType').combobox("getValue") || "";
	if ((decType == "O")||(HDDActiveFlag == "Y")){
		var toLocId = $('#cmbPhaLoc').combobox("getValue") || "";
		if (toLocId == ""){
			PHA.Popover({ showType: "show",	msg: "��������տ��Ҳ���Ϊ�գ���ҩ�����Ҳ���Ϊ�գ�ע��������������ϵͳ֮��סԺҩ�����ܷ��ŵ�������", type: 'error'});	
			return ;
		}
	}
	else{
		var toLocId = $('#cmbWardLoc').combobox("getValue") || "";	
		if (toLocId == ""){
			PHA.Popover({ showType: "show",	msg: "��������տ��Ҳ���Ϊ�գ�����������Ϊ�գ�", type: 'error'});	
			return ;
		}
	}
	
	var boxStatus = "10"
	// ����������Ϣ
	var mainData = decLocId + "^" + toLocId + "^" + gUserID + "^" + boxStatus
	
	var preList = GetCheckedPreArr() ;
	if (preList == ""){
		PHA.Popover({ showType: "show",	msg: "δ��ȡ����װ����Ϣ", type: 'error'});	
		return ;
	}
		
	$cm({
		ClassName: "PHA.DEC.DecPack.OperTab",
		MethodName: "SavePack",
		params: mainData,
		preList: preList,
		logonInfo: LogonInfo,
		dataType: "text"
	},function(retData) {
		var retArr = retData.split("^");
		var result = parseInt(retArr[0]);
		if (result < 0){ 
			PHA.Popover({ showType: "show",	msg: retData, type: 'error'	});
			return ;
		}else{
			PHA.Popover({ showType: "show",	msg: "װ��ɹ���", type: 'success' });
			PrintBoxLabel(result) ;
			
			DeleteCheckRows() ;
			return ;
		}
		
	});	
	
}

/**
 * ��ȡѡ�д�װ���¼
 * @method SaveBat
 */
function GetCheckedPreArr() {
	var batPreArr = [];
	var tabId= $('#dispTab').tabs('getSelected').attr("id");
	if (tabId == "tabScanDisp"){
		var selData = $("#gridScanPresc").datagrid("getChecked");
	}
	else {
		var selData = $("#gridBatchPresc").datagrid("getChecked");
	}
	if (selData==null){
		PHA.Popover({showType: "show", msg: "����ѡ����Ҫװ��Ĵ�����", type: 'alert'});
		return;
	}
	
	for (var i = 0; i < selData.length; i++) {
		var checkedData = selData[i];
		var pdpmItmId = checkedData.pdpmItmId ;
		var dispNum = checkedData.dispNum ;
		var prescNo = checkedData.prescNo ;
		var dataStr = pdpmItmId + "^" + dispNum + "^" + prescNo;
		if (batPreArr.indexOf(dataStr) < 0) {
			batPreArr.push(dataStr);
		}
	}
	return batPreArr.join("!!");
}

/**
 * �ѷ��Ų�ѯ��������
 * @method Clear
 */
function Clear(){
	var ComPropData = $.cm({	
		ClassName: "PHA.DEC.Com.Method", 
		MethodName: "GetAppProp", 
		UserId: gUserID, 
		LocId: gLocId, 
		SsaCode: "DEC.COMMON", 
		AppCode:""
		}, false)
	$("#cmbDecLoc").combobox("setValue", ComPropData.DefaultDecLoc);
	$("#cmbPhaLoc").combobox("setValue", ComPropData.DefaultPhaLoc);
	$('#txtBarCode').val("");
	$('#txtPatNo').val("");
	$('#txtCardNo').val("");
	$("#cmbAdmType").combobox("setValue", "");
	$('#cmbWardLoc').combobox("setValue","") ;
	$('#gridScanPresc').datagrid('clear');
	$('#gridScanPresc').datagrid('uncheckAll');
	$('#gridBatchPresc').datagrid('clear');
	$('#gridBatchPresc').datagrid('uncheckAll');
	$("#txtBarCode").focus();
	prescrArr = []
	if (NowTAB == "tabScanDisp"){
		$("#dateStart").datebox("setValue", "");
		$("#dateEnd").datebox("setValue", "");
		$('#timeStart').timespinner('setValue', "");
		$('#timeEnd').timespinner('setValue', "");
		
	}
	else {
		$.cm({	
			ClassName: "PHA.DEC.Com.Method", 
			MethodName: "GetAppProp", 
			UserId: gUserID, 
			LocId: gLocId, 
			SsaCode: "DEC.OUTDISP", 
			AppCode:""
			}, function(AppPropData){
				$("#dateStart").datebox("setValue", AppPropData.DispStartDate);
				$("#dateEnd").datebox("setValue", AppPropData.DispEndDate);
				$('#timeStart').timespinner('setValue', "00:00:00");
				$('#timeEnd').timespinner('setValue', "23:59:59");
				
			});	
	}
}

/**
 * ɾ��ѡ����
 * @method DeleteCheckRows
 */
function DeleteCheckRows() {
	var tabId= $('#dispTab').tabs('getSelected').attr("id");
	if (tabId == "tabScanDisp"){
		var gridId = "gridScanPresc" ;
	}
	else {
		var gridId = "gridBatchPresc" ;
	}
	var $grid = $("#" + gridId);
	var checkData = $grid.datagrid("getChecked");
	var length = checkData.length ;
	if(length == 0){
		return ;
	}
	
	for (var i = (length - 1); i >= 0; i--) {
		var row = $grid.datagrid('getRowIndex', checkData[i]);
		$grid.datagrid('deleteRow',row);
	}
	$grid.datagrid('uncheckAll');
	return ;	
}

