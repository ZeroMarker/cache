/**
 * @ģ��:     ��ҩ��-��ҩ����
 * @��д����: 2021-01-18
 * @��д��:   MaYuqiang
 */
var decCode = "FF";	// ��ҩ���̱�ʶ
var NowTAB = ""; 	// ��¼��ǰҳǩ��tab
var locId = session['LOGON.CTLOCID'];
var opUser = session['LOGON.USERID'];
var logonInfo = gGroupId + "^" + gLocId + "^" + gUserID + "^" + gHospID;
var ComPropData ;	// ��������
var AppPropData ;	// ��������
PHA_COM.ResizePhaColParam.auto = false;
$(function () {
	InitDict();
	InitGridScanPresc();
	InitGridBatchPresc();
	InitGridDispedPresc();
	// �����Żس��¼�
	$("#txtBarCode").on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var barCode = $.trim($("#txtBarCode").val());
			if (barCode != "") {
				queryScanPrescList();
			}
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
			var tabId= $('#dispTab').tabs('getSelected').attr("id");
			NowTAB = tabId;	
			ColPrescView("");
			if (title == "ɨ�뷢��"){
				$('#txtBarCode').focus();
				$("#dateStart").datebox("setValue", "");
				$("#dateEnd").datebox("setValue", "");
				$('#timeStart').timespinner('setValue', "");
				$('#timeEnd').timespinner('setValue', "");
				$HUI.datebox("#dateStart").disable();
				$HUI.datebox("#dateEnd").disable();
				$HUI.timespinner("#timeStart").disable();
				$HUI.timespinner("#timeEnd").disable();
				
				$("#cmbPhaLoc").combobox("setValue","")
				$('#cmbAdmType').combobox("setValue","")
				$HUI.combobox("#cmbDecLoc").disable();
				$HUI.combobox("#cmbPhaLoc").disable();
				$HUI.combobox("#cmbAdmType").disable();
				$('#txtCardNo').val("").prop('disabled', true);
				$('#txtPatNo').val("").prop('disabled', true);
			}
			else {
			
				$("#dateStart").datebox("setValue", AppPropData.DispStartDate);
				$("#dateEnd").datebox("setValue", AppPropData.DispEndDate);
				$('#timeStart').timespinner('setValue', "00:00:00");
				$('#timeEnd').timespinner('setValue', "23:59:59");
				$("#cmbDecLoc").combobox("setValue", ComPropData.DefaultDecLoc);
				$("#cmbPhaLoc").combobox("setValue", ComPropData.DefaultPhaLoc);
				
				$HUI.datebox("#dateStart").enable();
				$HUI.datebox("#dateEnd").enable();
				$HUI.timespinner("#timeStart").enable();
				$HUI.timespinner("#timeEnd").enable();
				$HUI.combobox("#cmbDecLoc").enable();
				$HUI.combobox("#cmbPhaLoc").enable();
				$HUI.combobox("#cmbAdmType").enable();
				$('#txtCardNo').val("").prop('disabled', false);
				$('#txtPatNo').val("").prop('disabled', false);
				if (title == "��������"){		
					$('#gridBatchPresc').datagrid('clear');
					setTimeout("queryBatchPrescList();",500)
				}
				else {
					$('#gridDispedPresc').datagrid('clear');
					setTimeout("queryDispedPrescList();",500)
				}
				
			}
			
		}
	})
});

/**
 * ��ʼ�����
 * @method InitDict
 */
function InitDict() {
	// ��������
	ComPropData = $.cm({	
		ClassName: "PHA.DEC.Com.Method", 
		MethodName: "GetAppProp", 
		UserId: gUserID, 
		LocId: gLocId, 
		SsaCode: "DEC.COMMON", 
		AppCode:""
		}, false)
	// ģ������
	AppPropData = $.cm({	
		ClassName: "PHA.DEC.Com.Method", 
		MethodName: "GetAppProp", 
		UserId: gUserID, 
		LocId: gLocId, 
		SsaCode: "DEC.OUTDISP", 
		AppCode:""
		}, false);
		
	if(ComPropData.PrescView=="Y") { 
		DEC_PRESC.Layout("mainLayout", {width: ComPropData.PrescWidth});	//��ʾ����Ԥ��panel
	};
	PHA.ComboBox("cmbDecLoc", {
		width: '120',
		url: PHA_DEC_STORE.DecLoc().url
	});
	PHA.ComboBox("cmbPhaLoc", {
		width: '120',
		url: PHA_DEC_STORE.Pharmacy("").url
	});
	
	$("#dispTab").tabs("select", parseInt(ComPropData.OperateModel));
	
	// ��������
    PHA.ComboBox('cmbAdmType', {
        data: [
            { RowId: 'O', Description: $g('����') },
            { RowId: 'I', Description: $g('סԺ') }
        ],
        panelHeight: 'auto',
        onSelect: function () {}
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
	$("#cmbDecLoc").combobox("setValue", ComPropData.DefaultDecLoc);
		
	var tabId= $('#dispTab').tabs('getSelected').attr("id");
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
		$HUI.combobox("#cmbDecLoc").disable();
		$HUI.combobox("#cmbPhaLoc").disable();
		$HUI.combobox("#cmbAdmType").disable();
		$('#txtCardNo').val("").prop('disabled', true);
		$('#txtPatNo').val("").prop('disabled', true);	
	}
	else {
			$("#dateStart").datebox("setValue", AppPropData.DispStartDate);
			$("#dateEnd").datebox("setValue", AppPropData.DispEndDate);
			$('#timeStart').timespinner('setValue', "00:00:00");
			$('#timeEnd').timespinner('setValue', "23:59:59");
			
			$HUI.datebox("#dateStart").enable();
			$HUI.datebox("#dateEnd").enable();
			$HUI.timespinner("#timeStart").enable();
			$HUI.timespinner("#timeEnd").enable();
			$HUI.combobox("#cmbDecLoc").enable();
			$HUI.combobox("#cmbPhaLoc").enable();
			$HUI.combobox("#cmbAdmType").enable();
			$('#txtCardNo').val("").prop('disabled', false);
			$('#txtPatNo').val("").prop('disabled', false);	
			if (NowTAB == "tabDispBatch"){						
				setTimeout("queryBatchPrescList();",1000)
			}
			else {
				setTimeout("queryDispedPrescList();",1000)
			}
	}
}
/**
 * ��ʼ��ɨ�뷢�Ŵ����б�
 * @method InitGridScanPresc
 */
function InitGridScanPresc() {
	var columns = [[ 
//		{
//			field:'pdCheck',
//			checkbox: true	
//		},
		{
			field:'curProDesc', 	
			title:'��ǰ����',	
			align:'left', 
			width: 70, 
			styler:function(value,row,index){
				if (row.curProDesc == "��ǩ") {
                        return 'background-color:#a849cb;color:white;';
                    }
                else if (row.curProDesc == "����") {
					return 'background-color:#6557d3;color:white;';
                }
			}
		},
		{
			field:'dispNum',	
			title:'���Ÿ���',		
			align:'right', 
			width: 80,
			editor: {
				type: 'numberbox',
				options: {
					required: false,
					onChange: function(nval, oval){
		            	$("#gridScanPresc").datagrid('endEditing');
		        	}
				}
			}
		},
		{	field:'pdpmId',		
			title:'pdpmId',		
			hidden:'true',	
			width: 50
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
			field:'prescNo', 	
			title:'������',	  	
			align:'left', 
			width: 130
		},
		{
			field: 'dispedNum',	
			title: '�ѷ��Ÿ���',	
			align: 'right', 
			width: 90
		},
		{
			field: 'toDispNum',	
			title: '�����Ÿ���',	
			align: 'right', 
			width: 90
		},
		{
			field:'preFacTor',	
			title:'�ܸ���',		
			align:'right', 
			width: 60
		}, 
		{
			field:'deptLocDesc', 	
			title:'����',	  	
			align:'left', 
			width: 150
		}, 
		{
			field:'decTypeDesc', 	
			title:'��ҩ����', 	
			align:'left', 
			width: 70
		}, 
		{
			field:'decDate',	
			title:'�շ�ʱ��', 	
			align:'left', 
			width: 160
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
			width: 160
		},
		{
			field:'cookCost',	
			title:'��ҩ��',		
			align:'left', 
			width: 150,
			nowrap:false
		},
		{
			field:'allDispFlag',	
			title:'ȫ�����ű�־',		
			align:'left', 
			width: 150,
			hidden:true
		}
	]];
	var dataGridOption = {
		url: $URL,
		toolbar: '#gridScanDispBar',
		columns: columns,
		singleSelect: false,
		selectOnCheck: true,
		checkOnSelect: true,
		nowrap:false,
		rownumbers: true,		
		queryParams: {
			ClassName: "PHA.DEC.DecDisp.Query",
			QueryName: "QueryPrescInfo",
			pJsonStr: ''
		},
		onSelect: function(rowIndex, rowData){
			var prescNo = rowData.prescNo;
			ColPrescView(prescNo);
		},
		onClickCell: function(rowIndex, field, value) {
			if (field == "dispNum"){
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'dispNum'
                });
            }else {
                $(this).datagrid('endEditing');
            }
        },
		onLoadSuccess: function(data) {
			if(data.rows.length==0){ return; }
			var row = data.rows[0];
			var prescNo = row.prescNo;
			$('#gridScanPresc').datagrid('selectRow', 0);
			ColPrescView(prescNo);
		}
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
		{
			field:'curProDesc', 	
			title:'��ǰ����',	
			align:'left', 
			width: 70, 
			styler:function(value,row,index){
				if (row.curProDesc == "��ǩ") {
                	return 'background-color:#a849cb;color:white;';
                }
                else {
					return 'background-color:#6557d3;color:white;';
                }
			}
		},
		{
			field:'dispNum',	
			title:'���Ÿ���',		
			align:'right', 
			width: 80,
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					onChange: function(nval, oval){
		            	$("#gridBatchPresc").datagrid('endEditing');
		        	}
				}
			}
		},
		{	field:'pdpmId',		
			title:'pdpmId',		
			hidden:'true',	
			width: 50
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
			field:'prescNo', 	
			title:'������',	  	
			align:'left', 
			width: 130
		},
		{
			field: 'dispedNum',	
			title: '�ѷ��Ÿ���',	
			align: 'right', 
			width: 90
		},
		{
			field: 'toDispNum',	
			title: '�����Ÿ���',	
			align: 'right', 
			width: 90
		},
		{
			field:'preFacTor',	
			title:'�ܸ���',		
			align:'right', 
			width: 60
		}, 
		{
			field:'deptLocDesc', 	
			title:'����',	  	
			align:'left', 
			width: 150
		}, 
		{
			field:'decTypeDesc', 	
			title:'��ҩ����', 	
			align:'left', 
			width: 70
		}, 
		{
			field:'decDate',	
			title:'�շ�ʱ��', 	
			align:'left', 
			width: 160
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
			width: 160
		},
		{
			field:'cookCost',	
			title:'��ҩ��',		
			align:'left', 
			width: 150,
			nowrap:false
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
			ClassName: "PHA.DEC.DecDisp.Query",
			QueryName: "QueryPrescList",
			pJsonStr: ''
		},
		onSelect: function(rowIndex, rowData){
			var prescNo = rowData.prescNo;
			ColPrescView(prescNo);
		},
		onClickCell: function(rowIndex, field, value) {
			if (field == "dispNum"){
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'dispNum'
                });
            }else {
                $(this).datagrid('endEditing');
            }
        },
		onLoadSuccess: function(data) {
			if(data.rows.length==0){ return; }
			$("#gridBatchPresc").datagrid("checkAll");
			var row = data.rows[0];
			var prescNo = row.prescNo;
			ColPrescView(prescNo);
		}
	};
	PHA.Grid("gridBatchPresc", dataGridOption);
}

/**
 * ��ʼ���ѷ��Ŵ����б�
 * @method InitGridDispedPresc
 */
function InitGridDispedPresc() {
	var columns = [[ 
		{
			field:'pdpmItmId',		
			title:'��ҩ�ӱ�Id',		
			hidden:true, 	
			width: 70 
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
			field:'prescNo', 	
			title:'������',	  	
			align:'left', 
			width: 130
		}, 
		{
			field:'ordLocDesc', 	
			title:'��������',	  	
			align:'left', 
			width: 150
		},
		{
			field:'phaLocDesc',	
			title:'����ҩ��',	
			align:'left', 
			width: 100
		},
		{
			field:'decTypeDesc', 	
			title:'��ҩ����', 	
			align:'left', 
			width: 70 
		},
		{
			field:'dispNum',	
			title:'���Ÿ���',		
			align:'right', 
			width: 80 
		},
		{
			field:'preFacTor',	
			title:'�ܸ���',		
			align:'right', 
			width: 60 
		},
		{
			field:'dispUser',	
			title:'������',		
			align:'left', 
			width: 80 
		},
		{
			field:'dispDate',	
			title:'����ʱ��',	
			align:'left', 
			width: 160
		},
		{
			field:'comFlag',	
			title:'��ɱ�־', 	
			align:'left', 
			width: 70 
		},
		{
			field:'pdDate',	
			title:'�շ�ʱ��', 	
			align:'left', 
			hidden : true ,
			width: 160
		},
		{
			field:'preCount',	
			title:'ζ��',		
			align:'left', 
			hidden:true ,
			width: 45 
		}, 
		{
			field:'preForm',	
			title:'��������',	
			align:'left', 
			hidden:true ,
			width: 80 
		}, 
		{
			field:'preEmFlag',	
			title:'�Ƿ�Ӽ�',	
			align:'left', 
			width: 70 
		}, 
		{
			field:'operUser',	
			title:'������',		
			align:'left', 
			hidden:true ,
			width: 80 
		},
		{
			field:'operDate',	
			title:'����ʱ��',	
			align:'left', 
			hidden:true ,
			width: 160
		},
		{
			field:'cookCost',	
			title:'��ҩ��',		
			align:'left', 
			hidden : true ,
			width: 150
		}
	]];
	var dataGridOption = {
		toolbar: [],
		columns: columns,
		url: $URL,
		rownumbers: true,
		nowrap:false,
		queryParams: {
			ClassName: "PHA.DEC.DecDisp.Query",
			QueryName: "QueryDispedPrescList",
			pJsonStr: ''
		},
		onSelect: function(rowIndex, rowData){
			var prescNo = rowData.prescNo;
			ColPrescView(prescNo);
		}
	};
	PHA.Grid("gridDispedPresc", dataGridOption);
}

/**
 * ��ѯ����������
 * @method queryPrtLabList
 */
function query(){
	var tab = $('#dispTab').tabs('getSelected');
	var tabIndex = $('#dispTab').tabs('getTabIndex',tab);
	if (tabIndex == 0){
		queryScanPrescList()
	}
	else if (tabIndex == 1){
		queryBatchPrescList()
	}
	else if (tabIndex == 2){
		queryDispedPrescList()
	}
}

/**
 * ɨ�뷢�ţ���ѯ����������
 * @method queryPrtLabList
 */
function queryScanPrescList(){
	var pJson = GetScanParamsJson();
	if (pJson == "") {
		return;
	}
	
	$('#gridScanPresc').datagrid('query', {
		pJsonStr: JSON.stringify(pJson),
		logonInfo: logonInfo
	});
}

/**
 * �������ţ���ѯ����������
 * @method queryPrtLabList
 */
function queryBatchPrescList(){
	if (NowTAB == "tabScanDisp") {
		return;
	}
	$('#gridBatchPresc').datagrid('uncheckAll');
	ColPrescView("");
	var pJson = GetQueryParamsJson();
	if (pJson == "") {
		return;
	}
	$('#gridBatchPresc').datagrid('query', {
		pJsonStr: JSON.stringify(pJson),
		logonInfo: logonInfo
	});
}

/**
 * ��ѯ�ѷ�������
 * @method queryDispedList
 */
function queryDispedPrescList(){
	
	if (NowTAB == "tabScanDisp") {
		return;
	}
	ColPrescView("");
	var pJson = GetQueryParamsJson();
	if (pJson == "") {
		return;
	}

	$('#gridDispedPresc').datagrid('query', {
		pJsonStr: JSON.stringify(pJson)
	});

}

/**
 * ��ȡɨ�뷢�Ž���Ԫ��ֵ
 * @method GetScanParamsJson
 */
function GetScanParamsJson() {
    return {
		barCode : $('#txtBarCode').val(),
		logonLocId : $('#cmbDecLoc').combobox("getValue")||''		//locId
    };
}

/**
 * ��ȡɨ�뷢�Ž���Ԫ��ֵ
 * @method GetQueryParamsJson
 */
function GetQueryParamsJson() {
	var startDate = $("#dateStart").datebox('getValue')||'' ;
	var endDate = $("#dateEnd").datebox('getValue')||''
	var decLocId = $('#cmbDecLoc').combobox("getValue")||'' ;
	if ((startDate == "")||(endDate == "")){
		PHA.Popover({showType: "show", msg: "��ʼ���ڡ���ֹ���ڲ���Ϊ�գ�", type: 'alert'});
		return;
	}
	if (decLocId == ""){
		PHA.Popover({showType: "show", msg: "��ҩ�Ҳ���Ϊ�գ�", type: 'alert'});
		return;
	}
    return {
		// barCode : $('#txtBarCode').val(),
		patNo : $('#txtPatNo').val(),
		startDate : startDate ,
		endDate : endDate ,
		startTime : $('#timeStart').timespinner('getValue')||'' ,
		endTime : $('#timeEnd').timespinner('getValue')||'' ,
		phaLocId : $('#cmbPhaLoc').combobox("getValue")||'' ,
		decLocId : decLocId ,
		admType : $('#cmbAdmType').combobox("getValue")||'' ,
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
 * ȷ�Ϸ���
 * @method dispPresc
 */
function Disp() {
	var selData = $("#gridScanPresc").datagrid("getSelected");
	if(selData==null){
		PHA.Popover({showType: "show", msg: "����ѡ����Ҫ���ŵĴ�����", type: 'alert'});
		return;
	}
	
	var prescNo = selData.prescNo ;
	var dispNum = selData.dispNum ;
	var toDispNum = selData.toDispNum ;
	if (dispNum > toDispNum){
		PHA.Popover({ showType: "show",	msg: "���Ÿ������ܴ��ڴ����Ÿ���", type: 'error'	});
		return ;
	}
	if ((dispNum == "")||(dispNum.length == 0)){
		PHA.Popover({ showType: "show",	msg: "���Ÿ�������С�ڵ���0", type: 'error'	});
		return ;
	}
	if (dispNum <= 0){
		PHA.Popover({ showType: "show",	msg: "���Ÿ�������С�ڵ���0", type: 'error'	});
		return ;
	}
	var dispNumStr = dispNum.split(".")
	if (dispNumStr[0] !== dispNum){
		PHA.Popover({ showType: "show",	msg: "���Ÿ���������С��", type: 'error' });
		return ;		
	}
	var chkDispNumFlag = tkMakeServerCall("PHA.DEC.DecDisp.OperTab","ChkDispNumFlag",prescNo,dispNum,toDispNum,logonInfo)
	if (chkDispNumFlag !== "Y"){
		PHA.Popover({ showType: "show",	msg: chkDispNumFlag, type: 'error' });
		return ;		
	}
	var dispStr = prescNo + "," + dispNum
	if(!dispStr) return;
	var params = dispStr +"^"+ decCode +"^"+ opUser +"^"+ "" +"^"+ locId;
	
	$cm({
		ClassName: "PHA.DEC.DecDisp.OperTab",
		MethodName: "SaveDispPstBatch",
		params: params,
		logonInfo: logonInfo,
		dataType: "text"
	},function(retData) {
		var retArr = retData.split("^");
		var result = parseInt(retArr[0]);
		if (result < 0){ 
			PHA.Popover({ showType: "show",	msg: retData, type: 'error'	});
		}else{
			PHA.Popover({ showType: "show",	msg: "���ųɹ���", type: 'success' });
			queryScanPrescList();
			//ColPrescView("");
		}
		$('#txtBarCode').val("");
		$("#txtBarCode").focus();
	});	
	
}

/**
 * ��������
 * @method DispBatch
 */
function DispBatch() {
	var checkedData = $("#gridBatchPresc").datagrid("getChecked");
	if(checkedData.length==0){
		PHA.Popover({showType: "show", msg: "���ȹ�ѡ��Ҫ���ŵĴ�����", type: 'alert'});
		return;
	}
	var prescNoStr = "";
	for(var i in checkedData){
		var prescNo = checkedData[i].prescNo;
		var dispNum = checkedData[i].dispNum;
		var toDispNum = checkedData[i].toDispNum;
		if (dispNum > toDispNum){
			PHA.Popover({ showType: "show",	msg: "���Ÿ������ܴ��ڴ����Ÿ���", type: 'error'	});
			return ;
		}
		if ((dispNum == "")||(dispNum.length == 0)){
			PHA.Popover({ showType: "show",	msg: "���Ÿ�������С�ڵ���0", type: 'error'	});
			return ;
		}
		if (dispNum <= 0){
			PHA.Popover({ showType: "show",	msg: "���Ÿ�������С�ڵ���0", type: 'error'	});
			return ;
		}
		var dispNumStr = dispNum.split(".")
		if (dispNumStr[0] !== dispNum){
			PHA.Popover({ showType: "show",	msg: "���Ÿ���������С��", type: 'error' });
			return ;		
		}
		var chkDispNumFlag = tkMakeServerCall("PHA.DEC.DecDisp.OperTab","ChkDispNumFlag",prescNo,dispNum,toDispNum,logonInfo)
		if (chkDispNumFlag !== "Y"){
			PHA.Popover({ showType: "show",	msg: chkDispNumFlag, type: 'error' });
			return ;		
		}
		var dispStr = prescNo + "," + dispNum
		prescNoStr = prescNoStr == "" ? dispStr : prescNoStr +"!!"+ dispStr;
	}
	if(!prescNoStr) return;
	var params = prescNoStr +"^"+ decCode +"^"+ opUser +"^"+ "" +"^"+ locId;
	$cm({
		ClassName: "PHA.DEC.DecDisp.OperTab",
		MethodName: "SaveDispPstBatch",
		params: params,
		logonInfo: logonInfo,
		dataType: "text"
	},function(retData) {
		var retArr = retData.split("^");
		var result = parseInt(retArr[0]);
		if (result < 0){ 
			PHA.Popover({ showType: "show",	msg: retData, type: 'error'	});
		}else{
			PHA.Popover({ showType: "show",	msg: "���ųɹ���", type: 'success' });
			queryBatchPrescList();
			ColPrescView("");
		}

	});	
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
	if(ComPropData.PrescView=="Y") { 
		DEC_PRESC.Layout("mainLayout", {width: ComPropData.PrescWidth});	//��ʾ����Ԥ��panel
	}
	$("#cmbDecLoc").combobox("setValue", ComPropData.DefaultDecLoc);
	$('#txtBarCode').val("");
	$('#txtPatNo').val("");
	$('#txtCardNo').val("");
	$('#txtBarCode').focus();
	$('#cmbAdmType').combobox("setValue","") ,
	$('#gridBatchPresc').datagrid('uncheckAll');
	$('#gridScanPresc').datagrid('clear');
	$('#gridBatchPresc').datagrid('clear');
	$('#gridDispedPresc').datagrid('clear');
	ColPrescView("");
	
	if (NowTAB == "tabScanDisp"){
		$("#dateStart").datebox("setValue", "");
		$("#dateEnd").datebox("setValue", "");
		$('#timeStart').timespinner('setValue', "");
		$('#timeEnd').timespinner('setValue', "");
		$("#cmbPhaLoc").combobox("setValue","")
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
		$("#cmbPhaLoc").combobox("setValue", ComPropData.DefaultPhaLoc);
	}
	
	
}

/**
 * ����Ԥ��
 * @method PrescView
 */
function ColPrescView(prescNo){
	var phartype = "O";
	DEC_PRESC.Presc("divPreLayout", {
		PrescNo: prescNo, 
		AdmType: phartype,
		CY: "Y"
	}); 
}

