/**
 * @ģ��:     ��ҩ������ҩ�Ѳ�ѯ
 * @��д����: 2021-01-11
 * @��д��:   MaYuqiang
 */
var tmpSplit = DHCPHA_CONSTANT.VAR.MSPLIT;
var gLocId = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID ;
var gHospId = DHCPHA_CONSTANT.SESSION.GHOSP_ROWID ;
var ComPropData		// ��������
var AppPropData		// ģ������
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID;
$(function () {
	PHA_COM.SetPanel('#pha_herb_v2_queryfeestat', $('#pha_herb_v2_queryfeestat').panel('options').title);
	InitDict();
	InitGridFee();
	InitSetDefVal();
	//�ǼǺŻس��¼�
	$('#conPatNo').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var patno=$.trim($("#conPatNo").val());
			if (patno!=""){
				var newpatno=NumZeroPadding(patno,DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
				$(this).val(newpatno);
				queryLocFeeList();
			}	
		}
	});
});

/**
 * ���ؼ�����ʼֵ
 * @method InitSetDefVal
 */
 function InitSetDefVal() {
	//��������
	// ��������
	ComPropData = $.cm({	
		ClassName: "PHA.HERB.Com.Method", 
		MethodName: "GetAppProp", 
		LogonInfo: LogonInfo, 
		SsaCode: "HERB.PC", 
		AppCode:""
		}, false)

    $("#conStartDate").datebox("setValue", ComPropData.QueryStartDate);
    $("#conEndDate").datebox("setValue", ComPropData.QueryEndDate);
	$('#conStartTime').timespinner('setValue', ComPropData.QueryStartTime);
	$('#conEndTime').timespinner('setValue', ComPropData.QueryEndTime);
	
}

/**
 * ��ʼ�����
 * @method InitDict
 */
function InitDict(){
	var combWidth = 160;

    // ��ҩ����
    PHA.ComboBox('conPhaLoc', {
        url: PHA_STORE.Pharmacy('').url,
		panelHeight: 'auto',
		width: combWidth,
        onLoadSuccess: function (data) {
            $(this).combobox('selectDefault', gLocId);
        }
    });
    // ��������
    PHA.ComboBox('conAdmType', {
        width: combWidth,
        data: [
            { RowId: 'O,E', Description: $g('�ż���') },
            { RowId: 'I', Description: $g('סԺ') }
        ],
        panelHeight: 'auto',
        onSelect: function () {}
	});
	// ��������
    PHA.ComboBox('conDocLoc', {
        url: PHA_HERB_STORE.DocLoc().url,
        width: combWidth
	});
	// ��ҩ��
	PHA.ComboBox("conCookFeeItem", {
		multiple: false,
		url: PHA_HERB_STORE.CookFeeItem(gLocId).url
	});
	// ��ҩ����
    PHA.ComboBox('conWardLoc', {
        url: PHA_STORE.WardLoc().url,
        width: combWidth
	});
	// �����ѱ�
    PHA.ComboBox('conBillType', {
        width: combWidth,
        url: PHA_STORE.PACAdmReason(gHospId).url
    });
}

/**
 * ��ʼ����ҩ�ѱ��
 * @method InitGridFee
 */
function InitGridFee() {
	var columns = [[ 
		{
			field: 'TDeptLoc',	
			title: '��������/����',	
			align: 'left', 
			width: 300
		},
		{
			field: 'TFeeItem',		
			title: '��Ŀ',		
			align: 'left', 
			width: 200
		},
		{
			field: 'TOutAmt',	
			title: '�ż�����',
			align: 'right', 
			width: 150
		},
		{
			field: 'TInAmt',
			title: 'סԺ���', 	
			align: 'right', 
			width: 150
		},
		{
			field: 'TTotalAmt', 	
			title: '�ϼƽ��', 	
			align: 'right', 
			width: 150
		},
		{
			field: 'TFeeNum', 	
			title: 'TFeeNum', 	
			align: 'left', 
			hidden: true
		}
	]];
	var dataGridOption = {
		fit: true,
		singleSelect: true,
		columns: columns,
		toolbar: '#toolBarFee',
		url: $URL,
		queryParams: {
			ClassName: "PHA.HERB.Query.FeeStat",
			QueryName: "QueryCookFee",
		},
		rownumbers: true,
		rowStyler: function(rowIndex, rowData){
			if(rowData['item'] == "С��"){
				return 'color:red;';
			}
		},
		onLoadSuccess: function(data){
			var rows = data.rows;
			for(var i = 0; i < rows.length; i++){
				var row = rows[i];
				var rowNum = row['typeNum'];
				if(rowNum != ""){
					$('#gridFee').datagrid("mergeCells",{
						index: (i - rowNum + 1),
						field: 'deptLoc',
						rowspan: rowNum,
						colspan: 0
					});	
				}
			}
		}
	};
	PHA.Grid("gridFee", dataGridOption);
}
/**
 * ��ѯ��ҩ������
 * @method queryPrtLabList
 */
function queryLocFeeList(){
	var pJson = GetQueryParamsJson();
	if (pJson == "") {
		return;
	}
	$('#gridFee').datagrid('query', {
		pJsonStr: JSON.stringify(pJson)
	});
}

/**
 * ��ѯ������JSON
 * @method GetQueryParamsJson
 */
function GetQueryParamsJson() {
    return {
        startDate: $("#conStartDate").datebox('getValue'),
        endDate: $("#conEndDate").datebox('getValue'),
        startTime: $('#conStartTime').timespinner('getValue'),
        endTime: $('#conEndTime').timespinner('getValue'),
		phaLocId: $('#conPhaLoc').combobox('getValue') || '',
		admType: $('#conAdmType').combobox('getValue') || '',
		wardLocId: $('#conWardLoc').combobox('getValue') || '',
		prescNo: $('#conPrescNo').val(),
		docLocId: $('#conDocLoc').combobox('getValue') || '',
		feeItem: $('#conCookFeeItem').combobox('getValue') || '',
		billType: $('#conBillType').combobox('getValue') || '' ,
		patNo: $('#conPatNo').val()

    };
}

/*
 * ����
 * @method Clear
 */
function Clear() {
	InitSetDefVal();
	$('#conPhaLoc').combobox('select', gLocId);
    $('#conAdmType').combobox('clear');
	$('#conWardLoc').combobox('clear');
	$('#conPrescNo').val('');
	$('#conDocLoc').combobox('clear');
	$('#conCookFeeItem').combobox('clear');
	$('#conBillType').combobox('clear');
	$('#conPatNo').val('')
	$('#gridFee').datagrid('clear');
	
}
