/**
 * @ģ��:     ��ѯͳ��-��ҩ������ͳ��
 * @��д����: 2019-08-29
 * @��д��:   hulihua
 */
$(function(){
	InitDict();
	InitSetDefVal();
	InitGridWorkLoad(); //��ʼ�����
})

/**
 * ��ʼ�����
 * @method InitDict
 */
function InitDict() {
	PHA.ComboBox("cmbDecLoc", {
		editable: false,
		url: PHA_DEC_STORE.DecLoc().url,
	});
	
	PHA.ComboBox("cmbProcess", {
		url: LINK_CSP + '?ClassName=PHA.DEC.Com.Store&MethodName=DecProDict&locId=' + gLocId,
	});
}

/**
 * ���ؼ�����ʼֵ
 * @method InitSetDefVal
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
		$("#dateStart").datebox("setValue", jsonComData.StatStartDate);
		$("#dateEnd").datebox("setValue", jsonComData.StatEndDate);
		$('#timeStart').timespinner('setValue', "00:00:00");
		$('#timeEnd').timespinner('setValue', "23:59:59");
		$("#cmbDecLoc").combobox("setValue", jsonComData.DefaultDecLoc);
	});
}

/**
 * ��ʼ�������շ����
 * @method InitGridWorkLoad
 */
function InitGridWorkLoad() {
	var columns = [
		[ {
				field: 'TUserCode',
				title: '����',
				align: 'left',
				width: 120
			}, {
				field: 'TUserName',
				title: '����',
				align: 'left',
				width: 130
			}, {
				field: 'TPstDesc',
				title: 'ҵ������',
				align: 'left',
				width: 130
			}, {
				field: 'TPreForm',
				title: '��������',
				align: 'left',
				width: 140
			}, {
				field: 'TOPPreNum',
				title: '���ﴦ��ҵ����',
				align: 'left',
				width: 130
			}, {
				field: 'TOPPreFacTor',
				title: ' ���︶��ҵ����',
				align: 'left',
				width: 130
			}, {
				field: 'TOPPreCount',
				title: '����ζ��ҵ����',
				align: 'left',
				width: 130
			}, {
				field: 'TIPPreNum',
				title: 'סԺ����ҵ����',
				align: 'left',
				width: 130
			}, {
				field: 'TIPPreFacTor',
				title: 'סԺ����ҵ����',
				align: 'left',
				width: 130
			}, {
				field: 'TIPPreCount',
				title: 'סԺζ��ҵ����',
				align: 'left',
				width: 130
			}, {
				field: 'TUserNum',
				title: 'TUserNum',
				align: 'center',
				width: 10,
				hidden: true  
			}, {
				field: 'TDictNum',
				title: 'TDictNum',
				align: 'center',
				width: 10,
				hidden: true  
			}
		]
	];
	var dataGridOption = {
		rownumbers: true,
		columns: columns,
		pageSize: 50,
		pageList: [50, 100, 200],
		pagination: true,
		toolbar: '#toolBarWorkLoad',
		border: true ,
		singleSelect: false,
		url: $URL,
		queryParams: {
			ClassName: "PHA.DEC.WorkLoad.Query",
			QueryName: "WorkLoad",
		},
		rowStyler: function(rowIndex, rowData){
			if(rowData['TPstDesc'] == "С��"){
				return 'background-color:#F4F6F5;';
			}
			else if(rowData['TUserCode'] == "�ܼ�"){
				return 'font-weight:bolder;background-color:#F4F6F5';
			}
		},
		onLoadSuccess: function(data){
			var rows = data.rows;
			var userEd = 1;
			var pstEd = 1;
			var formEd = 1;
			for(var i = (rows.length-1); i >=0 ; i--){
				var row = rows[i];
				if(rows[i-1]){
					if((rows[i-1]['TUserCode'] != row['TUserCode'])&&(row['TUserCode']!="")){
						$('#gridWorkLoad').datagrid("mergeCells",{
							index: i,
							field: 'TUserCode',
							rowspan: userEd
						});
						$('#gridWorkLoad').datagrid("mergeCells",{
							index: i,
							field: 'TUserName',
							rowspan: userEd
						});
						userEd = 1;
					}else{
						++userEd;	
					}
					if(rows[i-1]['TPstDesc'] != row['TPstDesc']){
						$('#gridWorkLoad').datagrid("mergeCells",{
							index: i,
							field: 'TPstDesc',
							rowspan: pstEd
						});
						pstEd = 1;
					}else{
						++pstEd;	
					}
					if(rows[i-1]['TPstDesc'] != row['TPstDesc']){
						$('#gridWorkLoad').datagrid("mergeCells",{
							index: i,
							field: 'TPstDesc',
							rowspan: formEd
						});
						formEd = 1;
					}else{
						++formEd;	
					}
				}
			}
		}
	};
	PHA.Grid("gridWorkLoad", dataGridOption);
}

/**
 * ����
 * @method Clear
 */
function Clear() {
	InitSetDefVal();
	$("#cmbProcess").combobox('setValue', "");
	$('#gridWorkLoad').datagrid('clear');
}

/**
 * ��ѯ����
 * @method Query
 */
function Query() {
	var params = GetParams();
	if (params == "") {
		return;
	}
	$('#gridWorkLoad').datagrid('query', {
		ParamStr: params
	});
}

/**
 * ��ȡ����Ԫ��ֵ
 * @method GetParams
 */
function GetParams() {
	var stDate = $("#dateStart").datebox('getValue');
	var enDate = $("#dateEnd").datebox('getValue');
	var stTime = $('#timeStart').timespinner('getValue');
	var enTime = $('#timeEnd').timespinner('getValue');
	var declocid = $('#cmbDecLoc').combobox("getValue") || "";
	var decPstId = $('#cmbProcess').combobox("getValue") || "";
	var params = stDate + "^" + enDate + "^" + stTime + "^" + enTime + "^" + declocid + "^" +decPstId;
	return params;
}