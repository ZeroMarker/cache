/**
 * @ģ��:     ��ҩ����״̬ɨ��ִ��
 * @��д����: 2021-04-23
 * @��д��:   MaYuqiang
 * csp:pha.herb.v2.scanexecute.csp
 * js: pha/herb/v2/scanexecute.js
 */
var tmpSplit = DHCPHA_CONSTANT.VAR.MSPLIT;
PHA_COM.App.ProCode = "HERB"
PHA_COM.App.ProDesc = "��ҩ����"
PHA_COM.App.Csp = "pha.herb.v2.scanexecute.csp"
PHA_COM.App.Name = "��ҩ״̬ɨ��ִ��"
var ComPropData;	// ��������
var gLocId = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID ;
var gHospId = DHCPHA_CONSTANT.SESSION.GHOSP_ROWID ;
var prescArr = []	// ��ɨ�봦��
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID ;
var PAPMINUM = 0;	// ����˳���
var CURPAPMI = "";
$(function () {
	PHA_COM.SetPanel('#pha_herb_v2_scanexe', $('#pha_herb_v2_scanexe').panel('options').title);
	InitGridPrescList();
	InitSetDefVal();
	InitDict();
	$('#btnExecute').on('click', Execute);
	$('#btnClear').on('click', Clear);
	
	//�����Żس��¼�
	$('#txtPrescNo').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var prescNo=$.trim($("#txtPrescNo").val());
			if (prescNo!=""){
				//AddPrescInfo(prescNo);
				ExecuteScan(prescNo)
			}	
		}
	});
	
	//�������лس��¼�
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})
	
});

/**
 * ���ؼ�����ʼֵ
 * @method InitSetDefVal
 */
function InitSetDefVal() {
	//��������	
	$('#txtUserCode').val('');
	$('#txtPrescNo').val('');
	// ��������
	ComPropData = $.cm({	
		ClassName: "PHA.HERB.Com.Method", 
		MethodName: "GetAppProp", 
		LogonInfo: LogonInfo, 
		SsaCode: "HERB.PC", 
		AppCode:""
	}, false)
}

function InitDict(){
	/// ִ��״̬�б�	
	var QueryType = "Exe" ;
	PHA.ComboBox("cmbState", {
		url: PHA_HERB_STORE.Process(gLocId,QueryType,gHospId,"","PC").url,
		width: 155,
		onLoadSuccess: function(){
			
		},
		onSelect: function (selData) {
			$('#gridPrescList').datagrid('uncheckAll');
			$('#gridPrescList').datagrid('clear');
			prescArr = [] ;
			PAPMINUM = 0;
			CURPAPMI = "";
		}
	});
	//$("#chk-autoexe").parent().css('visibility','hidden');

}
	
	/**
 * ��ʼ�������б�
 * @method InitGridOutPrescList
 */
function InitGridPrescList() {
	var columns = [
		[	{
				field:'pdCheck',	
				checkbox: true 
			}, {
				field: 'TPrescNo',
				title: '������',
				align: 'left',
				width: 80,
				hidden:true
			}, {
				field: 'TPrescState',
				title: '��ǰ״̬',
				align: 'left',
				width: 100,
				hidden: true
			}, {
				field: 'TPrescInfo',
				title: '������Ϣ',
				align: 'left',
				width: 1700
			}, {
				field: 'TOrdInfo',
				title: 'ҩƷ��Ϣ',
				align: 'left',
				width: 100,
				hidden:true
			}, {
				field: 'TPhbdId',
				title: '��ҩҵ���Id',
				align: 'left',
				width: 70,
				hidden:true
			},{
				field: 'TaltFlag',
				title: '�б�ɫ��־',
				align: 'left',
				width: 70,
				hidden:true
			},{
				field: 'TPapmiNum',
				title: '����˳���',
				align: 'left',
				width: 70,
				hidden:true
			},{
				field: 'TPapmi',
				title: '����id',
				align: 'left',
				width: 70,
				hidden:true
			}
			
		]
	];
	
	var dataGridOption = {
		fit: true,
		rownumbers: true,
		columns: columns,
		nowrap:false ,
		exportXls: false,
		pagination: false,
		singleSelect: false,
		toolbar: '#gridScanExeBar',
		rowStyler: HERB.Grid.RowStyler.PersonAlt,
		url: $URL,
		onClickRow: function (rowIndex, rowData) {
			//$("#gridPrescList").datagrid("expandRow",rowIndex);
		},
		groupField:'TPrescNo',
		view: detailview,
		detailFormatter:function(rowIndex, rowData){
			var ordInfo = rowData.TOrdInfo ;
			var ordInfoData = ordInfo.split("&&")
			var num = 0
			var detailHtml = '<div style="padding-top:0px">';
			for (num = 0;num<ordInfoData.length;num++){
				var ordDetailInfo = ordInfoData[num] ;
				var ordDetailData = ordDetailInfo.split("^")
				var inciDesc = ordDetailData[0] ;
				var qty = ordDetailData[1] ;
				var remark = ordDetailData[2] ;
				
				detailHtml += '<div class="herb">';
					detailHtml += '<div class="herb-name">' + inciDesc + '</div>';
					detailHtml += '<div class="herb-remark">' + remark + '</div>';
					detailHtml += '<div class="herb-qty">' + qty + '</div>';
				detailHtml += '</div>'	;				
			}
			detailHtml += '</div>'
			return detailHtml;
			
		},
		/*
		onExpandRow:function(rowIndex, rowData){
			alert(rowIndex)
		},*/
		onLoadSuccess:function(data){
			var row = $("#gridPrescList").datagrid("getRows");
			for (var r = 0; r < row.length; r++)
			{
				$("#gridPrescList").datagrid("expandRow",r);
			}	
		}
		
	};
	PHA.Grid("gridPrescList", dataGridOption);
}

/// ɨ��ִ��
function ExecuteScan(prescNo){
	console.log("prescNo:"+prescNo);
	// ��֤ɨ�账��
	var pJson = GetParamsJson();
	var jsonData = $.cm({
			ClassName: "PHA.HERB.Execute.Query",
			MethodName: "GetPrescInfo",
			prescNo: prescNo,
			pJsonStr: JSON.stringify(pJson),
			exeFlag: "N" ,
			HospId: gHospID ,
			dataType: 'json'
		}, false);
	
	var retCode = jsonData.retCode ;
	if (retCode < 0) {
		PHA.Popover({
			msg: jsonData.retMessage,
			type: 'alert',
			timeout: 2000
		});
		return;
	}	
	//var prescNo = jsonData.TPrescNo ;
	var phbdId = jsonData.TPhbdId ;
	PAPMINUM = jsonData.TPapmiNum ;
	CURPAPMI = jsonData.TPapmi ;
	if ((prescArr.indexOf(prescNo) > -1)&&(prescArr.length > 0)){
		PHA.Popover({
			showType: "show", 
			msg: "�ô����ڵ�ǰ�����Ѿ�ɨ���������ظ�ɨ�룡", 
			type: 'alert', 
			timeout:2000
		});
		return ;
	}
	
	// ִ��״̬
	var UserCode = $('#txtUserCode').val() ;
	var proDictId = $('#cmbState').combobox("getValue") ;
	var params = phbdId + tmpSplit + UserCode + tmpSplit + proDictId ;
	
	$.m({
		ClassName: "PHA.HERB.Execute.Save",
		MethodName: "Execute",
		param: params,
		logonInfo: LogonInfo 
	}, function (retData) {
		var retArr = retData.split("^")
		if (retArr[0] < 0) {
			$.messager.alert('��ʾ', retArr[1], 'warning');
			return;
		}
		else {
			// ִ�гɹ��󽫴������뵽��ɨ��
			prescArr.push(prescNo)
			// ��ִ����Ĵ�����Ϣ���ص�������
			var jsonData = $.cm({
				ClassName: "PHA.HERB.Execute.Query",
				MethodName: "GetPrescInfo",
				prescNo: prescNo,
				pJsonStr: JSON.stringify(pJson),
				exeFlag: "Y" ,
				HospId: gHospID ,
				dataType: 'json'
			}, false);
		
			var retCode = jsonData.retCode ;
			if (retCode < 0) {
				PHA.Popover({
					msg: jsonData.retMessage,
					type: 'alert',
					timeout: 2000
				});
				return;
			}
			else {
				var printPYDProCode = ComPropData.PrintPYDProCode;
				var proDictCode =  tkMakeServerCall("PHA.HERB.Com.Data", "GetProCodeById", proDictId)
				if (proDictCode == printPYDProCode){
					HERB_PRINTCOM.PYD(phbdId,"");
				}
			}
			$('#gridPrescList').datagrid('insertRow', {
				index: 0,
				row: jsonData
			});
			$("#gridPrescList").datagrid("expandRow",0);		
			
			$('#txtPrescNo').val('');		
				
		}
		
	});
	
	
}

/**
 * ��ҩ����״ִ̬�� ɨ����
 * @method AddPrescInfo
 */
function AddPrescInfo(prescNo){	
	var pJson = GetParamsJson();
	var jsonData = $.cm({
			ClassName: "PHA.HERB.Execute.Query",
			MethodName: "GetPrescInfo",
			prescNo: prescNo,
			pJsonStr: JSON.stringify(pJson),
			HospId: gHospID ,
			dataType: 'json'
		}, false);
	
	//var jsonData = JSON.parse(jsonData)
	var retCode = jsonData.retCode ;
	if (retCode < 0) {
		PHA.Popover({
			msg: jsonData.retMessage,
			type: 'alert',
			timeout: 2000
		});
		return;
	}
	
	var prescNo = jsonData.TPrescNo ;
	
	if ((prescArr.indexOf(prescNo)>-1)&&(prescArr.length>0)){
		PHA.Popover({
			showType: "show", 
			msg: "�ô����ڵ�ǰ�����Ѿ�ɨ���������ظ�ɨ�룡", 
			type: 'alert', 
			timeout:2000
		});
		return ;
	}
	else {
		prescArr.push(prescNo)	
	}	
	
	$('#gridPrescList').datagrid('insertRow', {
		index: 0,
		row: jsonData
	});
	$("#gridPrescList").datagrid("expandRow",0);		
	
	$('#txtPrescNo').val('');	
}

/*
 * ��ҩ������ҩȷ��
 * @method Confirm
 */
function Execute(){
	var gridSelect = $("#gridPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫִ�еĴ���!","info");
		return;
	}	
	var phbdId = gridSelect.TPhbdId ;
	var UserCode = $('#txtUserCode').val() ;
	if (UserCode == ""){
		$.messager.alert('��ʾ',"ҩʦ���Ų���Ϊ��!","info");
		return;	
	}
	var proDictId = $('#cmbState').combobox("getValue")
	var params = phbdId + tmpSplit + UserCode + tmpSplit + proDictId ;
	
	$.m({
		ClassName: "PHA.HERB.Execute.Save",
		MethodName: "Execute",
		param: params,
		logonInfo: LogonInfo 
	}, function (retData) {
		var retArr = retData.split("^")
		if (retArr[0] < 0) {
			$.messager.alert('��ʾ', retArr[1], 'warning');
			return;
		}
		else {
			HERB_PRINTCOM.PYD(phbdId,"");
				
		}
		//QueryExecutePreList();
	});
}

/**
 * ��ѯ������JSON
 * @method GetParamsJson
 */
function GetParamsJson() {
    return {
        phaLocId: gLocId,
		toExeProId: $("#cmbState").combobox("getValue")||'',
		papmiNum: PAPMINUM,
		curPapmi: CURPAPMI
    };
}

/*
 * ����
 * @method Clear
 */
function Clear() {
	InitSetDefVal();
	$("#cmbState").combobox("setValue", "");
	$('#gridPrescList').datagrid('uncheckAll');
	$('#gridPrescList').datagrid('clear');
	//$('#chk-confirm').checkbox("uncheck",true) ;
	prescArr = [] ;
	PAPMINUM = 0;
	CURPAPMI = "";
}

