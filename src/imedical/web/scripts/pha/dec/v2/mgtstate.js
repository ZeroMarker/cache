/**
 * ģ��:     ��ҩ״̬����
 * ��д����: 2022-09-01
 * ��д��:   MaYuqiang
 */
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID;
$(function () {
	InitDict(); //��ʼ��������
	InitGridQueryState(); //��ʼ�����
	InitSetDefVal(); //��Ĭ��ֵ
	queryStateInfo();
	$("#txt-prescno").on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			queryStateInfo();
		}
	});
	//�����Żس��¼�
	$("#txt-patno").on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			queryStateInfo();
		}
	});
	//�ǼǺŻس��¼�
	$('#txt-patno').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var patno = $.trim($("#txt-patno").val());
			if (patno != "") {
				$(this).val(PHA_COM.FullPatNo(patno));
				queryStateInfo();
			}
		}
	});
});
/**
 * ��ʼ�����
 * method InitDict
 */
function InitDict() {
	//��ҩ��
	PHA.ComboBox("cmbDecLoc", {
		width: 120,
		url: PHA_DEC_STORE.DecLoc().url,
		onSelect: function () {
			queryStateInfo();
		}
	});
	//��ǰ����
	PHA.ComboBox("cmbprocess", {
		width: 120,
		url: LINK_CSP + '?ClassName=PHA.DEC.Com.Store&MethodName=DecProDict&locId=' + gLocId,
		idField: 'RowId',
		textField: 'Description',
		method: 'get',
		onSelect: function () {
			queryStateInfo();
		}
	});
}
/**
 * ��ʼ����ϸ���
 * @method InitGridQueryState
 */
function InitGridQueryState() {
	var columns = [[{
				field: 'PDPIItmId',
				title: '��ҩ�ӱ�id',
				align: 'left',
				width: 100,
				hidden: true
			}, {
				field: 'patNo',
				title: '�ǼǺ�',
				align: 'left',
				width: 120
			}, {
				field: 'patName',
				title: '����',
				align: 'left',
				width: 120
			}, {
				field: 'prescNo',
				title: '������',
				align: 'left',
				width: 150,
				styler: function(value,row,index){
					return 'color:blue';
				}
			}, {
				field: 'curState',
				title: '��ǰ����',
				align: 'left',
				width: 100
			}, {
				field: 'decState',
				title: 'ִ������',
				align: 'left',
				width: 100
			}, {
				field: 'stateUserName',
				title: 'ִ����Ա',
				align: 'left',
				width: 100
			}, {
				field: 'stateDateTime',
				title: 'ִ��ʱ��',
				align: 'left',
				width: 180
			}, {
				field: 'stateEquiDesc',
				title: 'ִ���豸',
				align: 'left',
				width: 120
			}, {
				field: 'cancelUserName',
				title: '������Ա',
				align: 'left',
				width: 100
			}, {
				field: 'cancelDateTime',
				title: '����ʱ��',
				align: 'left',
				width: 180
			}
		]];
	var dataGridOption = {
		columns: columns,
		rownumbers: true,
		toolbar: '#toolBarDecState',
		border: true ,
		url: $URL,
		queryParams: {
			ClassName: "PHA.DEC.MGTState.Query",
			QueryName: "QueryStateInfo"
		},
		onLoadSuccess: function(data){
			var rows = data.rows;
			var patEd = 1;
			var prescEd = 1;
			for(var i = (rows.length-1); i >=0 ; i--){
				var row = rows[i];
				//debugger;
				if(rows[i-1]){
					if((rows[i-1]['patNo'] != row['patNo'])&&(row['patNo']!="")){
						$('#gridDecState').datagrid("mergeCells",{
							index: i,
							field: 'patNo',
							rowspan: patEd
						});
						$('#gridDecState').datagrid("mergeCells",{
							index: i,
							field: 'patName',
							rowspan: patEd
						});
						patEd = 1;
					}else{
						++patEd;	
					}
					if(rows[i-1]['prescNo'] != row['prescNo']){
						$('#gridDecState').datagrid("mergeCells",{
							index: i,
							field: 'prescNo',
							rowspan: prescEd
						});
						$('#gridDecState').datagrid("mergeCells",{
							index: i,
							field: 'curState',
							rowspan: prescEd
						});
						prescEd = 1;
					}else{
						++prescEd;	
					}
				}
				else {
					$('#gridDecState').datagrid("mergeCells",{
						index: i,
						field: 'patNo',
						rowspan: patEd
					});
					$('#gridDecState').datagrid("mergeCells",{
						index: i,
						field: 'patName',
						rowspan: patEd
					});	
					$('#gridDecState').datagrid("mergeCells",{
						index: i,
						field: 'prescNo',
						rowspan: prescEd
					});
					$('#gridDecState').datagrid("mergeCells",{
						index: i,
						field: 'curState',
						rowspan: prescEd
					});
				}
			}
			
		}
		
	};
	PHA.Grid("gridDecState", dataGridOption);
}

/**
 * ��ѯtable
 * method queryStateInfo
 */
function queryStateInfo() {
	var startDate = $("#startDate").datebox('getValue');
	var endDate = $("#endDate").datebox('getValue');
	var startTime = $('#startTime').timespinner('getValue') || "";
	var endTime = $('#endTime').timespinner('getValue') || "";
	var decLocId = $('#cmbDecLoc').combobox("getValue") || "";
	var decType = $("input[name='busType']:checked").val() || "";
	var curState = $('#cmbprocess').combobox("getValue") || "";
	var prescNo = $.trim($("#txt-prescno").val());
	var patNo = $.trim($("#txt-patno").val());
	var succFlag = $('#chk-success').is(':checked');
	var succFlag = succFlag == true ? "Y" : "N";
	
	var startDateTime = startDate+" "+startTime;
	var endDateTime = endDate +" "+endTime;
	var params = curState +"^"+ prescNo +"^"+ patNo +"^"+ decType +"^"+ succFlag;
	
	$('#gridDecState').datagrid('query', {
		startDateTime: startDateTime,
		endDateTime: endDateTime,
		decLocId: decLocId,
		params: params
	});
}

/**
 * ����ִ��
 * method cancelState
 */
function cancelState() {
	var selectRow = $('#gridDecState').datagrid("getSelected");
	if (selectRow == null){
		PHA.Popover({
			msg: "����ѡ����Ҫ������ִ��״̬��",
			type: 'alert'
		});	
	}
	var pdpiItmId = selectRow.PDPIItmId;
	
	var ret = $.m({
		ClassName: "PHA.DEC.MGTState.Api",
		MethodName: "CancelExecute",
		pdpiId: pdpiItmId,
		cancelUser: gUserID,
		logonInfo: LogonInfo
	}, false);
	
	if (ret == 0){
		PHA.Popover({msg: "�����ɹ�!", type: 'success'});
		queryStateInfo();
	}
	else {
		$.messager.alert('��ʾ',"��ҩ״̬����ʧ�ܣ�ԭ��Ϊ��"+ret,"info");
		return ;
	}
}

/**
 * ��Ĭ��ֵ
 * method InitSetDefVal
 */
function InitSetDefVal() {
	//��������
	$.cm({
		ClassName: "PHA.DEC.Com.Method",
		MethodName: "GetAppProp",
		UserId: gUserID,
		LocId: gLocId,
		SsaCode: "DEC.COMMON",
	}, function (jsonComData) {
		$("#startDate").datebox("setValue", jsonComData.StatStartDate);
		$("#endDate").datebox("setValue", jsonComData.StatEndDate);
		$('#startTime').timespinner('setValue', "00:00:00");
		$('#endTime').timespinner('setValue', "23:59:59");
		$("#cmbDecLoc").combobox("setValue", jsonComData.DefaultDecLoc);
	});
}
//���
function ClearConditions() {
	InitSetDefVal();
	$("#cmbDecLoc").combobox('setValue', "");
	$("#cmbprocess").combobox('setValue', "");
	$("#txt-prescno").val("");
	$("#txt-patno").val("");
	$("#chk-success").checkbox("uncheck");	
	$("input[label='ȫ��']").radio("check");
	$('#gridDecState').datagrid('loadData', {
		total: 0,
		rows: []
	});
}
