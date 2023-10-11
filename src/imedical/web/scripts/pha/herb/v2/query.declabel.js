/**
 * @ģ��:     ��ҩ������ҩ����ӡͳ��
 * @��д����: 2022-10-28
 * @��д��:   MaYuqiang
 */
var gLocId = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID ;
var PHA_HERB_QUERY_DECLABEL = {
    Pid: tkMakeServerCall('PHA.COM.Base', 'NewPid')
};
PHAHERB_COM.KillTmpOnUnLoad('PHA.HERB.Query.DECLabel', PHA_HERB_QUERY_DECLABEL.Pid);
$(function () {
	InitDict();
	InitGridPrescList();
	$('#btnFind').on('click', QueryHandler);
	/*
	$('#btnPrintLabel').on('click', 
		PrintDECLabel("")
	);
	*/
	$('#btnPrintList').on('click', PrintHandler);
	//$('#btnClearScreen').on('click', Clear);
	
	$('#conPrescNo').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
	        QueryHandler();
	        PrintDECLabel($(this).val());
        }
    });
	//�������лس��¼�
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})
	
});

function InitDict() {
    var combWidth = 160;
    $('#conStartDate').datebox('setValue', 't');
    $('#conEndDate').datebox('setValue', 't');
    // ��������
    PHA.ComboBox('conAdmType', {
        width: combWidth,
        data: [
            { RowId: 'O', Description: '����' },
            { RowId: 'I', Description: 'סԺ' }
        ],
        panelHeight: 'auto',
        onSelect: function () {}
	});
	$('#conAdmType').combobox('setValue', 'I');
	// ��ӡ״̬
    PHA.ComboBox('conPrintState', {
        width: combWidth,
        data: [
        	{ RowId: '0', Description: 'ȫ��' },
            { RowId: '1', Description: '�Ѵ�ӡ' },
            { RowId: '2', Description: 'δ��ӡ' }
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
 * ��ʼ�������б�
 * @method InitGridPrescList
 */
function InitGridPrescList() {
	var columns = [
		[	{
				field: 'TPhaLocDesc',
				title: 'ִ�п���',
				align: 'left',
				width: 130
			},{
				field: 'TWardDesc',
				title: '����Ԫ',
				align: 'left',
				width: 150
			},{
				field: 'TDocLocDesc',
				title: '��������',
				align: 'left',
				width: 150
			}, {
				field: 'TPatNo',
				title: '�ǼǺ�',
				align: 'left',
				width: 100
			}, {
				field: 'TMRNo',
				title: '������',
				align: 'left',
				width: 100
			}, {
				field: 'TBedNo',
				title: '����',
				align: 'left',
				width: 80
			}, {
				field: 'TPrescNo',
				title: '������',
				align: 'left',
				width: 130
			}, {
				field: 'TPatName',
				title: '����',
				align: 'left',
				width: 70
			}, {
				field: 'TDurDesc',
				title: '����',
				align: 'left',
				width: 70
			}, {
				field: 'TDaliyPackQty',
				title: 'ÿ�ݼ���',
				align: 'left',
				width: 70
			}, {
				field: 'TSinglePack',
				title: '���ҩ',
				align: 'left',
				width: 70
			}, {
				field: 'TInstruc',
				title: '�÷�',
				align: 'left',
				width: 70
			}, {
				field: 'TOrdDateTime',
				title: '��������',
				align: 'left',
				width: 160
			}, {
				field: 'TPrescProp',
				title: '��������',
				align: 'left',
				width: 80
			}, {
				field: 'TPrintSign',
				title: '��ӡ״̬',
				align: 'left',
				width: 80
			}, {
				field: 'TSign',
				title: 'ǩ��',
				align: 'left',
				width: 70
			}, {
				field: 'TPhbdId',
				title: 'TPhbdId',
				align: 'left',
				width: 80,				
				hidden: true
			}
		]
	];
	var dataGridOption = {
		 url: '',
        columns: columns,
        fitColumns: true,
        showFooter: true,
        toolbar: [],
        pageNumber: 1,
        pageSize: 100,
		loadFilter: PHAHERB_COM.LocalFilter,
		onLoadSuccess: function () {
            $(this).datagrid('loaded');
        }
	};
	PHA.Grid("gridPrescList", dataGridOption);
}


/**
 * ��ѯ����
 * @method QueryHandler
 */
function QueryHandler() {
    $('#gridPrescList').datagrid('loading');
    setTimeout(Query, 100);
}

function Query() {
    var pJson = GetQueryParamsJson();
    var ret = $.cm(
        {
            ClassName: 'PHA.HERB.Query.DECLabel',
            MethodName: 'Collect',
            pJsonStr: JSON.stringify(pJson),
            pid: PHA_HERB_QUERY_DECLABEL.Pid,
            dataType: 'text'
        },
        false
    );
    //var sort = $('#gridPrescList').datagrid('options').sortName;
    //var order = $('#gridInci').datagrid('options').sortOrder;
    var rowsData = $.cm(
        {
            ClassName: 'PHA.HERB.Query.DECLabel',
            QueryName: 'QueryDECLabel',
            pJsonStr: JSON.stringify(pJson),
            pid: PHA_HERB_QUERY_DECLABEL.Pid,
            rows: 9999,
            page: 1
        },
        false
    );

    $('#gridPrescList').datagrid('loadData', rowsData);
    $('#conPrescNo').val('');	
}

/**
 * ��ѯ������JSON
 * @method GetQueryParamsJson
 */
function GetQueryParamsJson() {
	var admType = $('#conAdmType').combobox('getValue') || '';
	if (admType == ""){
		$.messager.alert('��ʾ',"�������Ͳ���Ϊ��!","info");
        return;	
	}
    return {
        startDate: $("#conStartDate").datebox('getValue'),
        endDate: $("#conEndDate").datebox('getValue'),
        startTime: $('#conStartTime').timespinner('getValue'),
        endTime: $('#conEndTime').timespinner('getValue'),
		phaLocId: gLocId,
		admType: admType,
		prescNo: $('#conPrescNo').val(),
		printSate: $('#conPrintState').combobox('getValue') || '',
		docLocId: $('#conDocLoc').combobox('getValue') || '',
    };
}

/* ��ӡ��ҩС�� */
function PrintDECLabel(prescNo)
{
	if (prescNo == ""){
		var gridSelect = $("#gridPrescList").datagrid("getSelected");
		if (gridSelect !== null){
			var prescNo = gridSelect.TPrescNo ;
		}
	}
	if (prescNo == ""){
		$.messager.alert('��ʾ',"����ѡ����Ҫ��ӡ�Ĵ���!","info");
		return;
	}	
	HERB_PRINTCOM.DECLabel(prescNo);
	return ;
}


// ������ҩ��ӡ��Ϣ
function PrintHandler() 
{
	//PHA_COM.ExportGrid("gridPrescList");
	if ($('#gridPrescList').datagrid('getData').rows.length === 0) {
        PHA.Popover({
            msg: 'û������',
            type: 'alert'
        });
        return;
    }
    var printTitle = "�ɶ���ҽҩ��ѧ����ҽԺ���Ĵ�ʡ��ҽԺ"; 
    var para = {
	    printTitle: printTitle + "��ҩ����ǩ�ձ�",
        countDate: $('#conStartDate').datebox('getValue') + '��' + $('#conEndDate').datebox('getValue'),
        printUserName: session['LOGON.USERNAME']
    };

    var list = $('#gridPrescList').datagrid('getData').originalRows;

    PRINTCOM.XML({
        printBy: 'lodop',
        XMLTemplate: 'PHAHERB_DECLabelList',
        data: {
            Para: para,
            List: list
        },
        preview: false,
        listBorder: { style: 4, startX: 1, endX: 275 },
        page: { rows: 15, x: 245, y: 2, fontname: '����', fontbold: 'true', fontsize: '12', format: 'ҳ�룺{1}/{2}' }
    });
    return ;
}

/*
 * ����
 * @method Clear
 */
function Clear() {
	$('#gridPrescList').datagrid('clear');
	$('#conStartDate').datebox('setValue', 't');
    $('#conEndDate').datebox('setValue', 't');
	$('#conPrescNo').val("");
	return ;
}

//��������
/*
window.onload=function(){
	setTimeout("QueryHandler()",500);
}
*/

