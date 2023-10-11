/**
 * @ģ��:     ��ҩ����-��ǩ
 * @��д����: 2019-06-04
 * @��д��:   pushuangcai
 */
var decNumber = "DQ";	//��ҩ����
var PAGESIZE = 30;		//����
var NowTAB=""; 			//��¼��ǰҳǩ��tab
var ComPropData;		//��������
var PrintPropData;		//��������
var logonInfo = gGroupId + "^" + gLocId + "^" + gUserID + "^" + gHospID;
$(function () {
	InitDict();
	InitGridPresc();
	InitGridPrescList();
	InitGridPrescListPrt();
	
	$("#txtBarCode").on('keypress',function(event){
		if(window.event.keyCode == "13"){
			savePrtLabState();
		}
	})
	$("#txtPackNum").on('keypress',function(event){
		if(window.event.keyCode == "13"){
			$("#txtBarCode").focus();
		}
	})
	//�ǼǺŻس��¼�
	$('#txtPatNo').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var patno = $.trim($("#txtPatNo").val());
			if (patno != "") {
				$(this).val(PHA_COM.FullPatNo(patno));
				queryPrtLabList();
			}
		}
	});
//	setTimeout(function(){
//		$("#tabPrt").tabs({ 		// ��ѡ���¼�,�л�ҳǩ�Զ���ѯ
//			onSelect: function(title, index){ 
//				queryPrtLabList(); 
//			}
//		})
//	}, 1000);
	
	$("#tabPrt").on("click", ChangeTabs);
	SetDefVal(true);  
});
/**
 * ��ʼ�����
 * @method InitDict
 */
function InitDict() {
	PHA.ComboBox("cmbDecLoc", {
		url: PHA_DEC_STORE.DecLoc().url,
	});
	PHA.ComboBox("cmbPhaLoc", {
		url: PHA_DEC_STORE.Pharmacy("").url
	});
	PHA.ComboBox("cmbDocLoc", {
		url: PHA_DEC_STORE.DocLoc().url
	});	
}
/**
 * ��ʼ������Ĭ��ֵ
 * @method SetDefVal
 * @InitFlag	����ҳ��ʱΪtrue��������ť����ʱΪfalse
 */
function SetDefVal(InitFlag) {
	if(typeof(InitFlag)=="undefined"){InitFlag=false} 
	ComPropData = $.cm({	
		ClassName: "PHA.DEC.Com.Method", 
		MethodName: "GetAppProp", 
		UserId: gUserID, 
		LocId: gLocId, 
		SsaCode: "DEC.COMMON", 
		AppCode:""
		}, false)
	PrintPropData = $.cm({	
		ClassName: "PHA.DEC.Com.Method", 
		MethodName: "GetAppProp", 
		UserId: gUserID, 
		LocId: gLocId, 
		SsaCode: "DEC.PRINTLAB", 
		AppCode:""
		},false)
			
	if(parseInt(ComPropData.ScanPageTbNum)>0){
		PAGESIZE=parseInt(ComPropData.ScanPageTbNum);
	}	
	if(ComPropData.ViewDecInfo=="Y") {
		//��ʾ��ҩ��Ϣpanel
		var decInfoId = DEC_PRINT.DecInfo("mainLayout");	
		ComPropData.decInfoId = decInfoId;
		DEC_PRINT.VIEW(decInfoId, {PrescNo: ""});	
	}
	$("#cmbDecLoc").combobox("setValue", ComPropData.DefaultDecLoc);
	if (InitFlag){
		$("#tabPrt").tabs("select",parseInt(ComPropData.OperateModel));
	}
	var tabId= $('#tabPrt').tabs('getSelected').attr("id");
	NowTAB=tabId;	
	
	$('#txtEditNum').val("");
	$('#txtPackNum').val("");
	$('#txtReEditNum').val("");
	$("#txtBarCode").val("");
	$("input[label='ȫ��']").radio("check");
	
	//����Ĭ��ֵ
	if (NowTAB == "tabScanLable"){
		$HUI.datebox("#dateStart").disable();
		$HUI.datebox("#dateEnd").disable();
		$HUI.timespinner("#timeStart").disable();
		$HUI.timespinner("#timeEnd").disable();
		$HUI.combobox("#cmbDocLoc").disable();
		$HUI.combobox("#cmbPhaLoc").disable();
		$('#txtPatNo').val("").prop('disabled', true);		
	}
	else {		
		$("#dateStart").datebox("setValue", PrintPropData.PrtStartDate);
		$("#dateEnd").datebox("setValue", PrintPropData.PrtEndDate);
		$('#timeStart').timespinner('setValue',"00:00:00");
		$('#timeEnd').timespinner('setValue',"23:59:59");
		$('#cmbDocLoc').combobox("setValue","");
		$("#cmbPhaLoc").combobox("setValue", ComPropData.DefaultPhaLoc);
		$("#cmbDecLoc").combobox("setValue", ComPropData.DefaultDecLoc);
	
		$HUI.datebox("#dateStart").enable();
		$HUI.datebox("#dateEnd").enable();
		$HUI.timespinner("#timeStart").enable();
		$HUI.timespinner("#timeEnd").enable();
		$HUI.combobox("#cmbDocLoc").enable();
		$HUI.combobox("#cmbPhaLoc").enable();
		$('#txtPatNo').val("").prop('disabled', false);	
	}
}
/**
 * ��ʼ��ɨ���ǩ���
 * @method InitGridPresc
 */
function InitGridPresc() {
	var columns = [[ 
		{field: 'type',		title: '��ҩ����',	align: 'left', width: 80},
		{field: 'labNum',	title: '��ǩ��',	align: 'left', width: 80},
		{field: 'patNo',	title: '�ǼǺ�',	align: 'left', width: 120},
		{field: 'patName',	title: '��������',	align: 'left', width: 100},
		{field: 'prescno', 	title: '������', 	align: 'left', width: 150},
		{field: 'pdLoc', 	title: '����', 		align: 'left', width: 200}
	]];
	var dataGridOption = {
		url: '',
		fit: true,
		pagination: false,
		singleSelect: true,
		columns: columns,
		toolbar: '#toolBarPresc',
		queryParams: {
			ClassName: "",
			QueryName: ""
		},
		rownumbers: true,
		idField: "prescno",
		onSelect: function(rowIndex, rowData){
			var prescno = rowData.prescno;
			if(ComPropData.ViewDecInfo=="Y") { 
				DEC_PRINT.VIEW(ComPropData.decInfoId, {PrescNo: prescno});	
			}
		},
        	onRowContextMenu: function(){
			return false;	
		}
	};
	PHA.Grid("gridPresc", dataGridOption);
}
/**
 * ��ʼ��������ǩ���
 * @method InitGridPrescList
 */
function InitGridPrescList() {
	var columns = [[ 
		{field:'pdCheck',	checkbox: true },
		{field:'labNum',	title:'��ǩ��',		align:'left', width: 60,
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					onChange: function(nval, oval){
		            	$("#gridPrescList").datagrid('endEditing');
		        	}
				}
			}
		},
		{field:'patNo',		title:'�ǼǺ�',		align:'left', width: 100}, 
		{field:'patName',	title:'��������',	align:'left', width: 80 }, 
		{field:'prescno', 	title:'������',	  	align:'left', width: 130}, 
		{field:'deptLoc', 	title:'����',	  	align:'left', width: 150}, 
		{field:'pdPst', 	title:'��ǰ����',	align:'left', width: 70 }, 
		{field:'pdType', 	title:'��ҩ����', 	align:'left', width: 70 }, 
		{field:'comFlag',	title:'��ɱ�־', 	align:'left', width: 70 }, 
		{field:'pdDate',	title:'����ʱ��', 	align:'left', width: 150},
		{field:'preFacTor',	title:'����',		align:'left', width: 45 }, 
		{field:'preCount',	title:'ζ��',		align:'left', width: 45 }, 
		{field:'preForm',	title:'��������',	align:'left', width: 70 }, 
		{field:'preEmFlag',	title:'�Ƿ�Ӽ�',	align:'left', width: 70 }, 
		{field:'phaLoc',	title:'��������',	align:'left', width: 100}, 
		{field:'operUser',	title:'������',		align:'left', width: 80 },
		{field:'operDate',	title:'����ʱ��',	align:'left', width: 150},
		{field:'cookCost',	title:'��ҩ��',		align:'right', width: 150}
	]];
	var dataGridOption = {
		fit: true,
		toolbar: '#toolBarPrescList',
		rownumbers: true,
		pagination: true,
		singleSelect: false,
		selectOnCheck: true,
		checkOnSelect: true,
		nowrap:false,
		columns: columns,
		url: $URL,
		idField: 'prescno',
		queryParams: {
			ClassName: "PHA.DEC.PrtLab.Query",
			QueryName: "QueryPrtLabList",
			inputStr: '',
			logonInfo: logonInfo
		},
		onSelect: function(rowIndex, rowData){
			var prescno = rowData.prescno;
			if(ComPropData.ViewDecInfo=="Y") { 
				DEC_PRINT.VIEW(ComPropData.decInfoId, {PrescNo: prescno});	
			}
		},
		onClickCell: function(rowIndex, field, value) {
			if (field == "labNum"){
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'labNum'
                });
            }else {
                $(this).datagrid('endEditing');
            }
        },
		onLoadSuccess: function () {
			$('#gridPrescList').datagrid('uncheckAll');
		}
	};
	PHA.Grid("gridPrescList", dataGridOption);
}
/**
 * ��ʼ���Ѵ�ǩ��ǩ���
 * @method InitGridPrescListPrt
 */
function InitGridPrescListPrt() {
	var columns = [[ 
		{field:'pdCheck',	checkbox: true },
		{field:'labNum',	title:'��ǩ��',		align:'left', width: 60,
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					onChange: function(nval, oval){
		            	$("#gridPrescListPrt").datagrid('endEditing');
		        	}
				}
		}},
		{field:'patNo',		title:'�ǼǺ�',		align:'left', width: 100}, 
		{field:'patName',	title:'��������',	align:'left', width: 80 }, 
		{field:'prescno', 	title:'������',	  	align:'left', width: 130}, 
		{field:'deptLoc', 	title:'����',	  	align:'left', width: 150}, 
		{field:'pdPst', 	title:'��ǰ����',	align:'left', width: 70 }, 
		{field:'pdPrtDate',	title:'��ǩʱ��', 	align:'left', width: 150},
		{field:'pdPrtUser',	title:'��ǩ��',		align:'left', width: 80 },
		{field:'pdType', 	title:'��ҩ����', 	align:'left', width: 70 }, 
		{field:'comFlag',	title:'��ɱ�־', 	align:'left', width: 70 }, 
		{field:'pdDate',	title:'����ʱ��', 	align:'left', width: 150},
		{field:'preFacTor',	title:'����',		align:'left', width: 45 }, 
		{field:'preCount',	title:'ζ��',		align:'left', width: 45 }, 
		{field:'preForm',	title:'��������',	align:'left', width: 70 }, 
		{field:'preEmFlag',	title:'�Ƿ�Ӽ�',	align:'left', width: 70 }, 
		{field:'phaLoc',	title:'��������',	align:'left', width: 100}, 
		{field:'operUser',	title:'������',		align:'left', width: 80 },
		{field:'operDate',	title:'����ʱ��',	align:'left', width: 150},
		{field:'cookCost',	title:'��ҩ��',		align:'right', width: 150}
	]];
	var dataGridOption = {
		fit: true,
		toolbar: '#toolBarPrescListPrt',
		rownumbers: true,
		pagination: true,
		singleSelect: false,
		selectOnCheck: true,
		checkOnSelect: true,
		width : 1500 ,
		nowrap:false,
		idField: 'prescno',
		columns: columns,
		url: $URL,
		queryParams: {
			ClassName: "PHA.DEC.PrtLab.Query",
			QueryName: "QueryPrtLabList",
			inputStr: ''
		},
		onSelect: function(rowIndex, rowData){
			var prescno = rowData.prescno;
			if(ComPropData.ViewDecInfo=="Y") { 
				DEC_PRINT.VIEW(ComPropData.decInfoId, {PrescNo: prescno});	
			}
		},
		onClickCell: function(rowIndex, field, value) {
			if (field == "labNum"){
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'labNum'
                });
            }else {
                $(this).datagrid('endEditing');
            }
        },
		onLoadSuccess: function () {
			$('#gridPrescListPrt').datagrid('uncheckAll');
		}
	};
	PHA.Grid("gridPrescListPrt", dataGridOption);
}
/**
 * �����ǩ����,����Ԥ����ʾ����ӡ���б���������
 * @method savePrtLabState
 */
function savePrtLabState(){
	var prescno = $("#txtBarCode").val();
	if(prescno==""){
		PHA.Popover({showType: "show", msg: "������Ϊ�գ�", type: 'alert'});
		return;
	}
	var type = $("input[name='busType']:checked").val() || "";
	var decLocId = $('#cmbDecLoc').combobox("getValue")||session['LOGON.CTLOCID'];
	var opUser = session['LOGON.USERID'];
	var packNum = $('#txtPackNum').numberbox('getValue');
	/*
	if(packNum == ""){
		PHA.Popover({showType: "show", msg: "�������ǩ������", type: 'alert'});
		return;
	}else
	*/ 
	if((packNum <=0)&&(packNum !== "")){
		PHA.Popover({showType: "show", msg: "��ǩ�����������0��", type: 'alert'});
		return;
	}

	var params = prescno +"^"+ decNumber +"^"+ opUser +"^"+ type +"^"+ decLocId +"^"+ packNum;
	$cm({
		ClassName: "PHA.DEC.PrtLab.OperTab",
		MethodName: "SavePrtLabSta",
		params: params,
		dataType: "text"
	},function(retData) {
		var retArr = retData.split("^");
		var result = parseInt(retArr[0]);
		if (result < 0){ 
			PHA.Popover({
				showType: "show",
				msg: retData,
				type: 'error'
			});
		}else{
			var prtData = DEC_PRINT.Data({PrescNo: prescno});
			$("#gridPresc").datagrid("insertRow",{
				index: 0, 
				row:{
					type: prtData.Para.Type, 
					labNum: prtData.Para.LabNum,
					patNo: prtData.Para.PatNo,
					patName: prtData.Para.PatName, 
					prescno: prescno, 
					pdLoc: prtData.Para.DeptLoc 
				}
			})
			$("#gridPresc").datagrid("selectRecord",prescno);
			var totalRows =$('#gridPresc').datagrid('getRows').length;
			if(totalRows>PAGESIZE){		//�������õ�������ÿ����һ������ɾһ��֮ǰ������
				$("#gridPresc").datagrid("deleteRow",PAGESIZE);
			}
			DEC_PRINT.PRINT.LodopPrint({PrescNo: prescno});
		}
		$("#txtBarCode").val("");
		$('#txtPackNum').numberbox('setValue', '');
		$("#txtBarCode").focus();
	});	
}
/**
 * ��ѯ��ǩ����
 * @method queryPrtLabList
 */
function queryPrtLabList(){	
	var tabTitle = $('#tabPrt').tabs('getSelected').panel('options').title;
	if (tabTitle == "ɨ���ǩ") {
		PHA.Popover({showType: "show", msg: "ɨ���ǩ�����ѯ��ֱ��ɨ�뼴�ɣ�", type: 'alert'});
		return ;
	}
	var inputStr = getParams();
	if(!inputStr) return;
	
	if (tabTitle == "������ǩ") {
		var prtFalg = "false";
		inputStr = inputStr +"^"+ prtFalg;
		$('#gridPrescList').datagrid('query', {
			inputStr: inputStr
		});
	}else if(tabTitle == "�Ѵ�ǩ��ѯ"){
		var prtFalg = "true";
		inputStr = inputStr +"^"+ prtFalg;
		$('#gridPrescListPrt').datagrid('query', {
			inputStr: inputStr
		});
	}
}
/**
 * ��ȡ����Ԫ��ֵ
 * @method getParams
 */
function getParams(){
	var stDate = $("#dateStart").datebox('getValue');
	if(stDate==""){
		PHA.Popover({showType: "show", msg: "��ѡ��ʼʱ�䣡", type: 'alert'});
		return null;
	}
	var enDate = $("#dateEnd").datebox('getValue');
	if(enDate==""){
		PHA.Popover({showType: "show", msg: "��ѡ���ֹʱ�䣡", type: 'alert'});
		return null;
	}
	var stTime = $('#timeStart').timespinner('getValue');
	var enTime = $('#timeEnd').timespinner('getValue');
	var locId = $('#cmbDecLoc').combobox("getValue")||"";
	if(locId==""){
		PHA.Popover({showType: "show", msg: "��ѡ���ҩ�ң�", type: 'alert'});
		return null;
	}
	var type = $("input[name='busType']:checked").val() || "";
	var phaLocId = $('#cmbPhaLoc').combobox("getValue")||"";
	var docLocId = $('#cmbDocLoc').combobox("getValue")||"";
	var patNo = $('#txtPatNo').val();
	var params = stDate +"^"+ enDate +"^"+ stTime +"^"+ enTime +"^"+ locId; 
		params += "^"+ type +"^"+ phaLocId +"^"+ decNumber +"^"+ docLocId +"^"+ patNo;
	return params;
}
/**
 * ������ӡ��ǩ
 * @method printSelPrtLab
 */
function printSelPrtLab(){
	var checkedData = $('#gridPrescList').datagrid('getChecked');
	if(checkedData.length==0){
		PHA.Popover({showType: "show", msg: "���ȹ�ѡ��Ҫ��ӡ�Ĵ�����", type: 'alert'});
		return;
	}
	var prescnoStr = "";
	for(var i in checkedData){
		var prescno = checkedData[i].prescno;
		var labNum = checkedData[i].labNum;
		if (labNum>0){
			var tmpPrescno = prescno +"@"+ labNum;
			prescnoStr = prescnoStr == "" ? tmpPrescno : prescnoStr +"!!"+ tmpPrescno;
		}
	}
	savePrtLabStateBatch(prescnoStr);
}
/**
 * ���������ǩ����
 * @method savePrtLabStateBatch
 */
function savePrtLabStateBatch(prescnoStr){
	if(prescnoStr == ""){ return; }
	var type = $("input[name='busType']:checked").val() || "";
	var decLocId = $('#cmbDecLoc').combobox("getValue")||"";
	var opUser = session['LOGON.USERID'];
	var params = prescnoStr +"^"+ decNumber +"^"+ opUser +"^"+ type +"^"+ decLocId + "^" ;
	$cm({
		ClassName: "PHA.DEC.PrtLab.OperTab",
		MethodName: "SavePrtLabStaBatch",
		params: params,
		dataType: "text"
	},function(retData) {
		var result = retData.split("^")[0];
		var errCode = retData.split("^")[1];
		if (result < 0){ 
			PHA.Popover({
				showType: "show",
				msg: retData,
				type: 'error'
			});
		}else{
			var prescnoArr = prescnoStr.split("!!");
			for(var i in prescnoArr){
				var prescno = prescnoArr[i].split("@")[0];
				DEC_PRINT.PRINT.LodopPrint({PrescNo: prescno});
			}
			queryPrtLabList();	
		}
	})
}
/**
 * �ش��ǩ
 * @method printPrtLab
 */
function printPrtLab(){
	var checkedData = $('#gridPrescListPrt').datagrid('getChecked');
	if(checkedData.length==0){
		PHA.Popover({showType: "show", msg: "���ȹ�ѡ��Ҫ��ӡ�Ĵ�����", type: 'alert'});
		return;
	}
	for(var i in checkedData){
		var prescno = checkedData[i].prescno;
		var labNum = checkedData[i].labNum;
		if (labNum>0){
			DEC_PRINT.PRINT.LodopPrint({PrescNo: prescno, Num: labNum});
		}
	}
}
/**
 * �����޸ı�ǩ����
 * @method editLabNumBat
 */
function editLabNumBat(){
	var labNum = $('#txtEditNum').numberbox('getValue');
	if(labNum == ""){
		PHA.Popover({showType: "show", msg: "�������ǩ������", type: 'alert'});
		return;
	}else if(labNum <=0){
		PHA.Popover({showType: "show", msg: "��ǩ�����������0��", type: 'alert'});
		return;
	}
	var checkedData = $('#gridPrescList').datagrid('getChecked');
	if(checkedData.length==0){
		PHA.Popover({showType: "show", msg: "���ȹ�ѡ��Ҫ�޸ĵĴ�����", type: 'alert'});
		return;
	}
	for(var i in checkedData){
		checkedData[i].labNum = labNum;
		var rowIndex = $('#gridPrescList').datagrid('getRowIndex', checkedData[i].prescno);
		$('#gridPrescList').datagrid('refreshRow', rowIndex)
	}
	$('#txtEditNum').numberbox('setValue', '');
}

/**
 * �����޸ı�ǩ����(�Ѵ�ǩ��ѯ)
 * @method editLabNumBat
 */
function reEditLabNumBat(){
	var labNum = $('#txtReEditNum').numberbox('getValue');
	if(labNum == ""){
		PHA.Popover({showType: "show", msg: "�������ǩ������", type: 'alert'});
		return;
	}else if(labNum <=0){
		PHA.Popover({showType: "show", msg: "��ǩ�����������0��", type: 'alert'});
		return;
	}
	var checkedData = $('#gridPrescListPrt').datagrid('getChecked');
	if(checkedData.length==0){
		PHA.Popover({showType: "show", msg: "���ȹ�ѡ��Ҫ�޸ĵĴ�����", type: 'alert'});
		return;
	}
	for(var num in checkedData){
		checkedData[num].labNum = labNum;
		var rowIndex = $('#gridPrescListPrt').datagrid('getRowIndex', checkedData[num].prescno);
		$('#gridPrescListPrt').datagrid('refreshRow', rowIndex)
	}
	$('#txtReEditNum').numberbox('setValue', '');
}

/**
 * �л�ҳǩ
 * @method ChangeTabs
 */
function ChangeTabs() {
	var tabId= $('#tabPrt').tabs('getSelected').attr("id");
	if(NowTAB==tabId){
		return;
	}
	if(ComPropData.ViewDecInfo=="Y"){
		var decInfoId = DEC_PRINT.DecInfo("mainLayout");	
		DEC_PRINT.VIEW(decInfoId, {PrescNo: ""});
	}	
		
	NowTAB=tabId;
	if (NowTAB == "tabScanLable") {
		$('#gridPresc').datagrid('clear');
		$("#dateStart").datebox("setValue", "");
		$("#dateEnd").datebox("setValue", "");
		$('#timeStart').timespinner('setValue',"");
		$('#timeEnd').timespinner('setValue',"");
		$('#cmbDocLoc').combobox("setValue","");
		$("#cmbPhaLoc").combobox("setValue", "");
		$("#cmbDecLoc").combobox("setValue", ComPropData.DefaultDecLoc);
		$("#txtBarCode").focus();
		$HUI.datebox("#dateStart").disable();
		$HUI.datebox("#dateEnd").disable();
		$HUI.timespinner("#timeStart").disable();
		$HUI.timespinner("#timeEnd").disable();
		$HUI.combobox("#cmbDocLoc").disable();
		$HUI.combobox("#cmbPhaLoc").disable();
		$('#txtPatNo').val("").prop('disabled', true);
	}
	else{
		if (NowTAB == "tabPrintBatLable") {
			$('#gridPrescList').datagrid('clear');
		}
		else {
			$('#gridPrescListPrt').datagrid('clear');
		}
		$("#dateStart").datebox("setValue", PrintPropData.PrtStartDate);
		$("#dateEnd").datebox("setValue", PrintPropData.PrtEndDate);
		$('#timeStart').timespinner('setValue',"00:00:00");
		$('#timeEnd').timespinner('setValue',"23:59:59");
		$('#cmbDocLoc').combobox("setValue","");
		$("#cmbPhaLoc").combobox("setValue", ComPropData.DefaultPhaLoc);
		$("#cmbDecLoc").combobox("setValue", ComPropData.DefaultDecLoc);
		$HUI.datebox("#dateStart").enable();
		$HUI.datebox("#dateEnd").enable();
		$HUI.timespinner("#timeStart").enable();
		$HUI.timespinner("#timeEnd").enable();
		$HUI.combobox("#cmbDocLoc").enable();
		$HUI.combobox("#cmbPhaLoc").enable();
		$('#txtPatNo').val("").prop('disabled', false);	
		setTimeout("queryPrtLabList();",500);
	}
}



/*
 * ����
 * @method Clear
 */
function Clear() {
	$('#gridPresc').datagrid('clear');
	$('#gridPrescList').datagrid('clear');
	$('#gridPrescListPrt').datagrid('clear');
	SetDefVal(false);
	
}
