/**
 * @ģ��:     ��ҩ����������ѯ
 * @��д����: 2021-08-09
 * @��д��:   MaYuqiang
 */
var tmpSplit = DHCPHA_CONSTANT.VAR.MSPLIT;
var gLocId = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID ;
var gHospId = DHCPHA_CONSTANT.SESSION.GHOSP_ROWID ;
var ComPropData		// ��������
var AppPropData		// ģ������
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID;
$(function () {
	PHA_COM.SetPanel('#pha_herb_v2_queryworkload', $('#pha_herb_v2_queryworkload').panel('options').title);
	InitDict();
	InitGridWorkLoad();
	InitSetDefVal();
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
	$('#conStartDate').datebox('setValue', 't');
    $('#conEndDate').datebox('setValue', 't');
    $('#conStartTime').timespinner('setValue', '00:00:00');
    $('#conEndTime').timespinner('setValue', '23:59:59');
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
        url: PHA_STORE.DocLoc().url,
        width: combWidth
	});
	// ҵ������
    PHA.ComboBox('conBusType', {
        width: combWidth,
        data: [
            { RowId: 'DISP', Description: $g('��ҩ') },
            { RowId: 'RETURN', Description: $g('��ҩ') }
        ],
        panelHeight: 'auto',
        onSelect: function () {}
	});
	// ҩʦ����
    PHA.ComboBox('conUserType', {
        width: combWidth,
        data: [
            { RowId: 'Disp', Description: $g('��ҩҩʦ') },
            { RowId: 'Check', Description: $g('�˶�ҩʦ') },
            { RowId: 'FY', Description: $g('��ҩҩʦ') }
        ],
        panelHeight: 'auto',
		onLoadSuccess: function(){
			$('#conUserType').combobox('select', 'Disp');
		},
        onSelect: function () {
			//queryWorkLoad();
		}
	});
}

/**
 * ��ʼ�����������
 * @method InitGridWorkLoad
 */
function InitGridWorkLoad() {
	var columns = [[ 
		{
			field: 'TUserId',	
			title: 'ҩʦId',	
			align: 'left', 
			width: 100,
			hidden: true
		},{
			field: 'TUserName',	
			title: 'ҩʦ����',	
			align: 'left', 
			width: 150
		},{
			field: 'TUserCode',	
			title: 'ҩʦ����',	
			align: 'left', 
			width: 150
		},
		{
			field: 'TPrescQty',	
			title: '������',
			align: 'right', 
			width: 150
		},
		{
			field: 'TPrescAmt',	
			title: '���',
			align: 'right', 
			width: 150
		},
		{
			field: 'TPrescFactor',
			title: '����', 	
			align: 'right', 
			width: 150
		},
		{
			field: 'TPrescDrugKind', 	
			title: 'ζ��', 	
			align: 'right', 
			hidden: false ,
			width: 150
		}
	]];
	var dataGridOption = {
		fit: true,
		singleSelect: true,
		columns: columns,
		toolbar: '#toolBarWorkLoad',
		url: $URL,
		queryParams: {
			ClassName: "PHA.HERB.Query.WorkLoad",
			QueryName: "QueryWorkLoad",
		},
		rownumbers: true,
		rowStyler: function(rowIndex, rowData){
			if(rowData['TUserName'] == $g("С��")){
				return 'color:blue;';
			}
			if(rowData['TUserName'] == $g("�ϼ�")){
				return 'color:red;';
			}
			if(rowData['TUserName'] == $g("�ܼ�")){
				return 'color:red;';
			}
		},
		onLoadSuccess: function(data){
			var rows = data.rows;
			for(var i = 0; i < rows.length; i++){
				var row = rows[i];
				var rowNum = row['typeNum'];
				if(rowNum != ""){
					$('#gridWorkLoad').datagrid("mergeCells",{
						index: (i - rowNum + 1),
						field: 'deptLoc',
						rowspan: rowNum,
						colspan: 0
					});	
				}
			}
		}
	};
	PHA.Grid("gridWorkLoad", dataGridOption);
}
/**
 * ��ѯ��ҩ��������
 * @method queryPrtLabList
 */
function queryWorkLoad(){
	var pJson = GetQueryParamsJson();
	if (pJson == "") {
		return;
	}
	$('#gridWorkLoad').datagrid('query', {
		pJsonStr: JSON.stringify(pJson)
	});
}

/**
 * ��ѯ������JSON
 * @method GetQueryParamsJson
 */
function GetQueryParamsJson() {
	var userType = $('#conUserType').combobox('getValue') || '';
	if (userType == ''){
		$.messager.alert('��ʾ',"ҩʦ���Ͳ���Ϊ�գ�","info");
		return;
	}
    return {
        startDate: $("#conStartDate").datebox('getValue'),
        endDate: $("#conEndDate").datebox('getValue'),
        startTime: $('#conStartTime').timespinner('getValue'),
        endTime: $('#conEndTime').timespinner('getValue'),
		phaLocId: $('#conPhaLoc').combobox('getValue') || '',
		docLocId: $('#conDocLoc').combobox('getValue') || '',
		admType: $('#conAdmType').combobox('getValue') || '',
		busType: $('#conBusType').combobox('getValue') || '',
		userType: userType
    };
}

/*
 * ����
 * @method Clear
 */
function Clear() {
	$('#gridWorkLoad').datagrid('clear');
	$('#conPhaLoc').combobox('select', gLocId);
    $('#conAdmType').combobox('clear');
	$('#conDocLoc').combobox('clear');
	$('#conBusType').combobox('clear');
	InitSetDefVal();
	$('#conUserType').combobox('select', 'Disp');
}
