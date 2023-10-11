$(function() {
	function initUI() {
		initCombobox();
		initSearchForm();
		initGrid();
		
	}

	function search() {
		initBabyData();
	}

	function initBabyData() {
		$('#babyGrid').datagrid('clearSelections');
		$HUI.datagrid('#babyGrid').load();
		
		/*$('#pAdmLoc').combogrid({
		panelWidth:450,
		delay: 500,
		mode: 'remote',
		url:$URL+"?ClassName=web.DHCAntCVMsgCfg&QueryName=FindLoc",
		onBeforeLoad:function(param){
			param.HospId=GV.HospId||'';
			param.desc=param.q;
			return true;
		},
		idField:"LocId",textField:"LocDesc",
		columns:[[{field:'LocDesc',title:'��������',width:200},{field:'LocCode',title:'���Ҵ���',width:200}]],
		pagination:true
		})*/
	}


	function initSearchForm() {
		function filter(q, row) {
			var opts = $(this).combobox('options');
			var text = row[opts.textField];
			var pyjp = getPinyin(text).toLowerCase();
			if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
				return true;
			}
			return false;
		}

		//��ʼ������ʱ��
		$('#startDate').datebox('setValue', dateCalculate(now, 0));
		$('#endDate').datebox('setValue', dateCalculate(now, 0));
		if (session['LOGON.CTLOCDESC']!="����") {
		var NowLocDesc=session['LOGON.CTLOCDESC'];
		}
		//$('#LocCode').val(NowLocDesc);
		$('#LocCode').combobox('setValue', NowLocDesc);
		$('#LocCode').combobox('getData');
		/*//��ʼ��������combox
		$HUI.combobox('#outCome', {
			valueField: 'ID',
			textField: 'desc',
			url: $NURURL + '?className=Nur.IP.Delivery&methodName=findOutCome',
			onSelect: function(record) {},
			filter: filter
		});*/
		
		

		$('#searchBtn').click(search);
		$('#outBtn').click(exportData);
		$('#printBtn').click(print);
	}
	function initCombobox() {
		$HUI.combobox("#LocCode", {
			url: $URL + '?ClassName=web.UDHCJFDischQuery&QueryName=FindWard&ResultSetType=array',  //����
			mode: 'remote',
			valueField: 'id',
			textField: 'text',
			//value: session['LOGON.CTLOCDESC'],
			onBeforeLoad: function (param) {
				param.desc = param.q;
				param.hospId =session['LOGON.HOSPID'];
			}
		});
	}
	/*$HUI.combobox("#LocCode", {
	url: $URL + '?ClassName=web.UDHCJFQFPATIENT&QueryName=FindDept&ResultSetType=array',  //����
	mode: 'remote',
	valueField: 'id',
	textField: 'text',
	onBeforeLoad: function (param) {
		param.desc = param.q;
		param.hospId = "2"  //PUBLIC_CONSTANT.SESSION.HOSPID;
	}
	});*/

	function initGrid() {
	var defaultPageSize = 25;
	var defaultPageList = [25, 50, 100, 200, 500];
    $('#babyGrid').datagrid({
        url: $NURURL + '?className=Nur.NIS.Service.DataSourse.NewEmr&methodName=findNurDataByDate',
        pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		pageSize: defaultPageSize,
		pageList: defaultPageList,
		onBeforeLoad:befordLoadFun,
        columns: [[
            { field: 'Date', title: '����', width: 100 },
			{ field: 'Time', title: 'ʱ��', width: 100 },
            { field: 'name', title: '����', width: 100 },
			{ field: 'bedCode', title: '����', width: 100 },
            { field: 'medeCareNocheck', title: 'סԺ��', width: 100 },
            { field: 'LocDesc', title: '����', width: 180 },
            { field: 'Item1', title: '��ʶ��ֵ', width: 150 },
            { field: 'Item2', title: '����ѹ��ֵ', width: 150 },
            { field: 'Item3', title: '������ֵ', width: 150 },
            { field: 'Item4', title: '������ֵ', width: 150 },
            { field: 'Item5', title: '���·�ֵ', width: 150 },
            { field: 'Item6', title: 'Ѫ����ֵ', width: 150 },
            { field: 'Item7', title: '�ܷ�', width: 150 }, // 
        ]],
        idField: 'medeCareNocheck',
    });
}
	function befordLoadFun(param)
{
	var medNo = $('#medNoInput').val();
	var minGra = $('#minGrade').val();
	var maxGra = $('#maxGrade').val();
	//var locCode = $('#LocCode').val(); 
	var locCode =$("#LocCode").combobox("getText");
	var page = param.page;
	var rows = param.rows;
	param.parameter1 = $HUI.datebox('#startDate').getValue();
	param.parameter2 = $HUI.datebox('#endDate').getValue();
	param.parameter3 = medNo;
	param.parameter4 = minGra;
	param.parameter5 = maxGra;
	param.parameter6 = locCode;
	param.parameter7 = page;
	param.parameter8 = rows;
	return true;     
}
	function exportData(){
		var startDate = $HUI.datebox('#startDate').getValue();
		var endDate = $HUI.datebox('#endDate').getValue();
		var medNo = $('#medNoInput').val();
		var minGra = $('#minGrade').val();
		var maxGra = $('#maxGrade').val();
		var queryName="findNurDataByDateQ";
		var excelName="MEWS����";
		var rtn=$cm({
			dataType: "text",
			ResultSetType: "Excel",
			ExcelName: excelName,
			ClassName: "Nur.NIS.Service.DataSourse.NewEmr",
			QueryName: queryName,
			startDate: startDate,
			endDate: endDate,
			medeCareNo: medNo,
			minGrade: minGra,
			maxGrade: maxGra
		},false);
		location.href = rtn;
	}

	/*function saveHearingScreening() {
		var rowsData = $('#babyGrid').datagrid('getSelections')
		if (rowsData.length === 0) {
			$.messager.alert("��ʾ", "��ѡ����Ҫ�����Ӥ����Ϣ!", 'info');
			return;
		}
		var errors = [];
		for (var i = 0; i < rowsData.length; i++) {
			var rowData = rowsData[i];
			var babyID = rowData['babyID'];
			var index = $('#babyGrid').datagrid('getRowIndex', babyID)
			$('#babyGrid').datagrid('selectRow', index).datagrid('endEdit', index);
			var leftEarFlag = rowData['leftEarFlag'];
			var rightEarFlag = rowData['rightEarFlag'];

			var babyName = rowData['babyName'];
			var ret = tkMakeServerCall("Nur.IP.Delivery", "saveHearingScreening", babyID, leftEarFlag, rightEarFlag);
			if (ret != 0) {
				errors.push(errors);
			}
		}
		if (errors.length !== 0) {
			$.messager.alert("��ʾ", errors.join(",") + "����ʧ��!", 'info');
		}
		search();
	}*/

	/*function print() {
		var rowsData = $('#babyGrid').datagrid('getSelections')
		if (rowsData.length === 0) {
			$.messager.alert("��ʾ", "��ѡ����Ҫ��ӡ��Ӥ����Ϣ!", 'info');
			return;
		}
		var xlsExcel, xlsSheet, xlsBook;
		var titleRows, titleCols, LeftHeader, CenterHeader, RightHeader;
		var LeftFooter, CenterFooter, RightFooter, frow, fCol, tRow, tCol;
		var path, fileName, fso;
		path = tkMakeServerCall("web.DHCLCNUREXCUTE", "GetPath");
		fileName = path + "procbabyinfo.xls";
		xlsExcel = new ActiveXObject("Excel.Application");

		xlsBook = xlsExcel.Workbooks.Add(fileName)
		xlsSheet = xlsBook.ActiveSheet
		var hospitalDesc = tkMakeServerCall("Nur.IP.Delivery", "getHospitalDesc", session['LOGON.CTLOCID']);
		xlsSheet.cells(1, 1) = hospitalDesc + " " + "�������嵥"
		fontcell(xlsSheet, 1, 1, 1, 16);
		var Num = 2
		for (var i = 0; i < rowsData.length; i++) {

			var babyID = rowData['babyID'];
			var prtdata = tkMakeServerCall("web.DHCPADelBaby", "GetPrintData", babyID)
			var str = prtdata.split("^");
			Num = Num + 1
			xlsSheet.cells(Num, 1) = str[0];
			xlsSheet.cells(Num, 2) = str[1];
			xlsSheet.cells(Num, 3) = str[2];

			xlsSheet.cells(Num, 4) = str[5];
			xlsSheet.cells(Num, 5) = str[6];

			xlsSheet.cells(Num, 6) = str[10];
			xlsSheet.cells(Num, 7) = str[12];
			xlsSheet.cells(Num, 8) = str[13];
			xlsSheet.cells(Num, 9) = str[14];
			xlsSheet.cells(Num, 10) = str[15];

		}
		xlsExcel.Visible = true
		xlsSheet.PrintPreview
		//xlsSheet.PrintOut(); 
		//xlsSheet = null;
		xlsBook.Close(savechanges = false)
		xlsBook = null;
		xlsExcel.Quit();
		xlsExcel = null;
	}*/
	initUI();

})