/**
 * @ģ��:     ��ҩ���ܾ���ҩ��ѯ
 * @��д����: 2021-08-09
 * @��д��:   MaYuqiang
 */
var tmpSplit = DHCPHA_CONSTANT.VAR.MSPLIT;
var gLocId = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID ;
var gHospId = DHCPHA_CONSTANT.SESSION.GHOSP_ROWID ;
var SessionWard = session['LOGON.WARDID'] || "";
var ComPropData		// ��������
var AppPropData		// ģ������
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID;
$(function () {
	PHA_COM.SetPanel('#pha_herb_v2_queryrefusedisp', $('#pha_herb_v2_queryrefusedisp').panel('options').title);
	InitDict();
	InitGridRefuseDisp();
	InitSetDefVal();
	//�ǼǺŻس��¼�
	$('#conPatNo').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var patno=$.trim($("#conPatNo").val());
			if (patno!=""){
				var newpatno=NumZeroPadding(patno,DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
				$(this).val(newpatno);
				queryRefuseDisp();
			}	
		}
	});
	if (SessionWard !="") {
    	$("#cancelRefuse").parent().css('visibility','hidden');
    }
});
//alert("EpisodeID:"+EpisodeID)
window.onload = function () {
    if (EpisodeID != '') {
        var patinfo = tkMakeServerCall('web.DHCSTPharmacyCommon', 'GetPatInfoByAdm', EpisodeID);
        patinfo = JSON.parse(patinfo);
        patinfo = patinfo[0];
        $('#conPatNo').val(patinfo.PatNo);
        queryRefuseDisp();
    }
    //Query();
};

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
	if (session['LOGON.WARDID'] == ""){
		$("#conPhaLoc").combobox("setValue", gLocId);
	}
	else {
		$("#conPhaLoc").combobox("setValue", ComPropData.DefaultLoc4Req);
	}
	
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
            //$(this).combobox('selectDefault', gLocId);
        }
    });
    
}

/**
 * ��ʼ���ܷ�ҩ��ѯGrid
 * @method InitGridRefuseDisp
 */
function InitGridRefuseDisp() {
	var columns = [[ 
		{
			field: 'phaomId',	
			title: '��˱�Id',	
			align: 'left', 
			width: 100,
			hidden: true
		},{
			field: 'TPapmi',	
			title: '����id',	
			align: 'left', 
			width: 100,
			hidden: true
		},{
			field: 'TPatName',	
			title: '��������',	
			align: 'left', 
			width: 100
		},{
			field: 'TPatNo',	
			title: '�ǼǺ�',	
			align: 'left', 
			width: 100
		},
		{
			field: 'TPhaLocId',		
			title: '��ҩ����Id',		
			align: 'left', 
			width: 100,
			hidden: true
		},
		{
			field: 'TPhaLocDesc',	
			title: '��ҩ����',
			align: 'left', 
			width: 100
		},
		{
			field: 'TAdmLocDesc',	
			title: '����/ҽ������',
			align: 'left', 
			showTip: true,
			tipWidth: 200,
			width: 120
		},
		{
			field: 'TPrescNo',
			title: '������', 	
			align: 'left', 
			width: 150
		},
		{
			field: 'TPrescState',
			title: 'ҽ��״̬', 	
			align: 'left', 
			width: 100
		},
		{
			field: 'TOrdDateTime',
			title: '��ҽ��ʱ��', 	
			align: 'left', 
			width: 200
		},
		{
			field: 'TRefuseUserName',
			title: '�ܾ���', 	
			align: 'left', 
			width: 100
		},
		{
			field: 'TRefuseDateTime', 	
			title: '�ܾ�ʱ��', 	
			align: 'left',
			width: 200
		},
		{
			field: 'TRefuseReason', 	
			title: '�ܾ�ԭ��', 	
			align: 'left', 
			showTip: true,
			width: 200
		},
		{
			field: 'TPhaomAppType', 	
			title: '�ܾ�����', 	
			align: 'left', 
			width: 100,
			hidden: true
		}
	]];
	var dataGridOption = {
		fit: true,
		singleSelect: true,
		columns: columns,
		toolbar: '#toolBarRefuseDisp',
		url: $URL,
		queryParams: {
			ClassName: "PHA.HERB.Query.RefuseDisp",
			QueryName: "QueryRefuseDisp",
		},
		rownumbers: true
	};
	PHA.Grid("gridRefuseDisp", dataGridOption);
}
/**
 * ��ѯ��ҩ��������
 * @method queryPrtLabList
 */
function queryRefuseDisp(){
	var pJson = GetQueryParamsJson();
	if (pJson == "") {
		return;
	}
	$('#gridRefuseDisp').datagrid('query', {
		pJsonStr: JSON.stringify(pJson)
	});
}

/**
 * ��ѯ������JSON
 * @method GetQueryParamsJson
 */
function GetQueryParamsJson() {
	if (session['LOGON.WARDID'] == ""){
		var wardLocId = ""
	}
	else {
		var wardLocId = gLocId
	}
    return {
        startDate: $("#conStartDate").datebox('getValue'),
        endDate: $("#conEndDate").datebox('getValue'),
        startTime: $('#conStartTime').timespinner('getValue'),
        endTime: $('#conEndTime').timespinner('getValue'),
		phaLocId: $('#conPhaLoc').combobox('getValue') || '',
		patNo: $('#conPatNo').val(),
		wardLocId: wardLocId
    };
}

/*
 * �����ܾ�
 * @method cancelRefuse
 */
function cancelRefuse(){
	var gridSelect = $("#gridRefuseDisp").datagrid("getSelected");
	if (gridSelect == null){
		$.messager.alert('��ʾ',"����ѡ����Ҫ�����ܾ���ҩ�Ĵ���!","info");
		return;
	}
	var prescNo = gridSelect.TPrescNo;
	var type = gridSelect.TPhaomAppType;
	var phaomId = gridSelect.phaomId;
	var params = gUserID + tmpSplit + prescNo + tmpSplit + type + tmpSplit + phaomId ;
	$.m({
		ClassName: "PHA.HERB.Dispen.Save",
		MethodName: "CancelHerbRefDisp",
		params: params ,
		hospId: gHospID
	}, function (retData) {
		var retArr = retData.split("^")
		if (retArr[0] < 0) {
			$.messager.alert('��ʾ', retArr[1], 'warning');
			return;
		}
		queryRefuseDisp();
	});
	
}

/*
 * ����
 * @method Clear
 */
function Clear() {
	$('#gridRefuseDisp').datagrid('clear');
	InitSetDefVal();
	$('#conPatNo').val("");
}
