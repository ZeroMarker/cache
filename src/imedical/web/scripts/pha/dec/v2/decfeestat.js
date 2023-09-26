/**
 * @ģ��:     ��ҩ��ѯ-��ҩ�Ѳ�ѯ
 * @��д����: 2019-08-29
 * @��д��:   pushuangcai
 */
$(function () {
	InitDict();
	InitGridDecFee();
	SetDefVal();
});
/**
 * ��ʼ�����
 * @method InitDict
 */
function InitDict(){
	PHA.ComboBox("cmbDecLoc", {
		url: PHA_DEC_STORE.DecLoc().url,
	});
	PHA.ComboBox("cmbPhaLoc", {
		url: PHA_DEC_STORE.Pharmacy("").url
	});
	PHA.ComboBox("cmbDocLoc", {
		url: PHA_DEC_STORE.DocLoc().url
	});
	PHA.ComboBox("cmbCookFeeItem", {
		multiple: true,
		url: PHA_DEC_STORE.CookFeeItem().url
	});
}
/**
 * ����Ĭ��ֵ
 * @method SetDefVal
 */
function SetDefVal(){
	$.cm({	
		ClassName: "PHA.DEC.Com.Method", 
		MethodName: "GetAppProp", 
		UserId: gUserID, 
		LocId: gLocId, 
		SsaCode: "DEC.COMMON", 
		AppCode:""
		}, function(AppPropData){
			$("#cmbDecLoc").combobox("setValue", AppPropData.DefaultDecLoc);
			$("#dateStart").datebox("setValue", AppPropData.StatStartDate);
			$("#dateEnd").datebox("setValue", AppPropData.StatEndDate);
			$("#cmbPhaLoc").combobox("setValue", AppPropData.DefaultPhaLoc);
			$('#timeStart').timespinner('setValue',"00:00:00");
			$('#timeEnd').timespinner('setValue',"23:59:59");
			$('#cmbDocLoc').combobox("setValue","");
			$('#cmbCookFeeItem').combobox("clear");
			//$(":radio[name='statFlag'][value="+ "DQ" +"]").iCheck('check'); 
			$HUI.radio("input[value='DQ']").check();
		});
	$('#gridDecFee').datagrid('clear');	
}

/**
 * ��ʼ����ҩ�ѱ��
 * @method InitGridDecFee
 */
function InitGridDecFee() {
	var columns = [[ 
		{field: 'deptLoc',	title: '��������',	align: 'left', width: 100},
		{field: 'item',		title: '��Ŀ',		align: 'left', width: 120},
		{field: 'outAmt',	title: '�ż�����',align: 'right', width: 100},
		{field: 'inAmt', 	title: 'סԺ���', 	align: 'right', width: 100},
		{field: 'total', 	title: '�ϼƽ��', 	align: 'right', width: 100},
		{field: 'typeNum', 	title: 'typeNum', 	align: 'left', hidden: true}
	]];
	var dataGridOption = {
		fit: true,
		singleSelect: true,
		columns: columns,
		toolbar: '#toolBarDecFee',
		border: true,
		url: $URL,
		queryParams: {
			ClassName: "PHA.DEC.DecFee.Query",
			QueryName: "QueryDecFee",
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
					$('#gridDecFee').datagrid("mergeCells",{
						index: (i - rowNum + 1),
						field: 'deptLoc',
						rowspan: rowNum,
						colspan: 0
					});	
				}
			}
		}
	};
	PHA.Grid("gridDecFee", dataGridOption);
}
/**
 * ��ѯ��ҩ������
 * @method queryPrtLabList
 */
function queryLocFeeList(){
	var inputStr = getParams();
	if(!inputStr) return;
	$('#gridDecFee').datagrid('query', {
		inputStr: inputStr
	});
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
	var stTime = $('#timeStart').timespinner('getValue')||"";
	var enTime = $('#timeEnd').timespinner('getValue')||"";
	var locId = $('#cmbDecLoc').combobox("getValue")||"";
	if(locId==""){
		PHA.Popover({showType: "show", msg: "��ѡ���ҩ�ң�", type: 'alert'});
		return null;
	}
	var phaLocId = $('#cmbPhaLoc').combobox("getValue")||"";
	var docLocId = $('#cmbDocLoc').combobox("getText")||"";
	var statFlag = $("input[name='statFlag']:checked").val() || "";
	var feeItem = $('#cmbCookFeeItem').combobox("getText")||"";
	var params = stDate +"^"+ enDate +"^"+ stTime +"^"+ enTime +"^"+ locId;
		params += "^"+ phaLocId +"^"+ docLocId +"^"+ statFlag +"^"+ feeItem;
	return params;
}
