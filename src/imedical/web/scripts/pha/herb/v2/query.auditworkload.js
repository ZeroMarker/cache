/**
 * @ģ��:     ��ҩ��������˹�������ѯ
 * @��д����: 2022-03-02
 * @��д��:   MaYuqiang
 */
var tmpSplit = DHCPHA_CONSTANT.VAR.MSPLIT;
var gLocId = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID ;
var gHospId = DHCPHA_CONSTANT.SESSION.GHOSP_ROWID ;
var ComPropData		// ��������
var AppPropData		// ģ������
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID;
$(function () {
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
}

/**
 * ��ʼ�����������
 * @method InitGridWorkLoad
 */
function InitGridWorkLoad() {
	var columns = [[ 
		{
			field: 'TUserId',	
			title: '���ҩʦId',	
			align: 'right', 
			width: 100,
			hidden: true
		},{
			field: 'TUserName',	
			title: '���ҩʦ',	
			align: 'right', 
			width: 150
		},{
			field: 'TAuditNum',	
			title: '�������',	
			align: 'right', 
			width: 150
		},
		{
			field: 'TPassNum',		
			title: 'ͨ������',		
			align: 'right', 
			width: 150
		},
		{
			field: 'TFailNum',	
			title: '��ͨ������',
			align: 'right', 
			width: 150
		},
		{
			field: 'TAcceptNum',	
			title: 'ҽ����������',
			align: 'right', 
			width: 150
		},
		{
			field: 'TAppealNum',
			title: 'ҽ�����߳ɹ�����', 	
			align: 'right', 
			width: 150
		}
	]];
	var dataGridOption = {
		fit: true,
		singleSelect: true,
		columns: columns,
		toolbar: '#toolBarAuditWorkLoad',
		border: true,
		url: $URL,
		queryParams: {
			ClassName: "PHA.HERB.Query.WorkLoad",
			QueryName: "QueryAuditWorkLoad",
		},
		rownumbers: true,
		rowStyler: function(rowIndex, rowData){
			if(rowData['TUserName'] == $g("�ϼ�")){
				return 'color:red;';
			}
			
		},
		onLoadSuccess: function(data){
			
		}
	};
	PHA.Grid("gridAuditWorkLoad", dataGridOption);
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
	$('#gridAuditWorkLoad').datagrid('query', {
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
		docLocId: $('#conDocLoc').combobox('getValue') || '',
		admType: $('#conAdmType').combobox('getValue') || '',
    };
}

/*
 * ����
 * @method Clear
 */
function Clear() {
	$('#gridAuditWorkLoad').datagrid('clear');
	InitSetDefVal();
	$('#conPhaLoc').combobox('select', gLocId);
    $('#conAdmType').combobox('clear');
	$('#conDocLoc').combobox('clear');
}
