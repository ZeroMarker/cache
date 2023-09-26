var ManfCm, ManfGrid;
var HospId=gHospId;
var TableName="PH_Manufacturer";
var init = function () {
	var ManfBox = $HUI.combobox('#ParManf', {
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function () {
			ManfBox.clear();
			var Params=JSON.stringify(addSessionParams({BDPHospital:HospId}));
			var url=$URL + '?ClassName=web.DHCSTMHUI.APCVendCat&QueryName=GetPhManufacturer&ResultSetType=array&Params='+Params;
			ManfBox.reload(url);
		}
	});
	
	
	function InitHosp() {
		var hospComp=InitHospCombo(TableName,gSessionStr,ManfGrid);
		if (typeof hospComp ==='object'){
			HospId=$HUI.combogrid('#_HospList').getValue();
			Query();
			$('#_HospList').combogrid("options").onSelect=function(index,record){
				HospId=record.HOSPRowId;
				$UI.clearBlock('#MainConditions');
				Query();
			};
		}
	}
	
	function Query(){
		var SessionParmas=addSessionParams({BDPHospital:HospId});
		var Paramsobj=$UI.loopBlock('MainConditions');
		var Params=JSON.stringify(jQuery.extend(true,Paramsobj,SessionParmas));
		$UI.clearBlock('#BasicConditions');
		$UI.clearBlock('#QualifyConditions');
		$UI.clear(ManfGrid);
		ManfGrid.load({
			ClassName: 'web.DHCSTMHUI.ItmManfNew',
				QueryName: 'ItmManf',
				Params: Params
		});
	}
	
	ManfCm = [[{
				title: "操作",
				field: 'Icon',
				width: 50,
				align: 'center',
				formatter: function (value, row, index) {
					var str = "<a href='#' onclick='ManfPicWin(" + row.RowId + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/img.png' title='查看图片' border='0'></a>";
					return str;
				}
			}, {
				title: 'RowId',
				field: 'RowId',
				width: 50,
				saveCol: true,
				hidden: true
			}, {
				title: '代码',
				field: 'ManfCode',
				width: 100
			}, {
				title: '名称',
				field: 'ManfDesc',
				width: 150
			}, {
				title: '电话',
				field: 'Tel',
				width: 100
			}, {
				title: '地址',
				field: 'Address',
				width: 150
			}
		]];

	ManfGrid = $UI.datagrid('#ManfGrid', {
			lazy: false,
			queryParams: {
				ClassName: 'web.DHCSTMHUI.ItmManfNew',
				QueryName: 'ItmManf'
			},
			columns: ManfCm,
			fitColumns: true,
			onSelect: function (Index, Row) {
				Clear();
				Select(Row.RowId);
			},
			onLoadSuccess: function (data) {
				if (data.rows.length > 0) {
					ManfGrid.selectRow(0);
				}
			}
		});
	
	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			Query();
		}
	});
	
	$UI.linkbutton('#AddBT_1', {
		onClick: function () {
			Clear();
			$("#Status_1").combobox('setValue', "Y");
		}
	});
	$UI.linkbutton('#AddBT_2', {
		onClick: function () {
			Clear();
		}
	});
	$UI.linkbutton('#SaveBT_1', {
		onClick: function () {
			Save();
		}
	});
	$UI.linkbutton('#SaveBT_2', {
		onClick: function () {
			Save();
		}
	});
	$UI.linkbutton('#UpLoadBT', {
		onClick: function () {
			var RowId = $('#RowId').val();
			if (RowId == "") {
				$UI.msg('alert', '请先选择或保存厂商信息!');
				return;
			}
			var Qualifications = $("#Qualifications").combo('getValue');
			if (Qualifications == "" || Qualifications == null) {
				$UI.msg('alert', '请选择资质信息!');
				return;
			}
			UpLoadWin(RowId, Qualifications);
		}
	});

	$UI.linkbutton('#TakePhotoBT', {
		onClick: function () {
			var RowId = $('#RowId').val();
			if (RowId == "") {
				$UI.msg('alert', '请先选择或保存厂商信息!');
				return;
			}
			var Qualifications = $("#Qualifications").combo('getValue');
			if (Qualifications == "" || Qualifications == null) {
				$UI.msg('alert', '请选择资质信息!');
				return;
			}
			TakePhotoWin(RowId, Qualifications);
		}
	});
	InitHosp();
}
$(init);

function Select(Manf) {
	$.cm({
		ClassName: 'web.DHCSTMHUI.ItmManfNew',
		MethodName: 'Select',
		Manf: Manf
	}, function (jsonData) {
		if(jsonData.success != 0){
			$UI.msg('error', '查询有误!');
			return;
		}
		$UI.fillBlock('#BasicConditions', jsonData.BasicData);
		$UI.fillBlock('#QualifyConditions', jsonData.CertData);
		$("#ManfDesc_1").validatebox("validate");
	});
}
function Clear() {
	$UI.clearBlock('#BasicConditions');
	$UI.clearBlock('#QualifyConditions');
	var Dafult = {
			Status: "A"
		}
	$UI.fillBlock('#BasicConditions', Dafult);
}
/*function Save() {
	var BasicObj = $UI.loopBlock('#BasicConditions');
	var QualifyObj = $UI.loopBlock('#QualifyConditions');
	var Basic = JSON.stringify(BasicObj);
	var Qualify = JSON.stringify(QualifyObj);
	$.cm({
		ClassName: 'web.DHCSTMHUI.ItmManfNew',
		MethodName: 'Save',
		Basic: Basic,
		Qualify: Qualify
	}, function (jsonData) {
		if (jsonData.success == 0) {
			$UI.msg('success', jsonData.msg);
			Select(jsonData.rowid);
		} else {
			$UI.msg('error', jsonData.msg);
		}
	});
}*/
function Save() {
	var BasicObj = $UI.loopBlock('#BasicConditions');
	var QualifyObj = $UI.loopBlock('#QualifyConditions');
	
	var CertArr = ['comLic', 'orgCode', 'insBusLic', 'insProLic', 'prodEprsHygLic',
		'socialCreditCode', 'businessRegNo', 'taxLic'
	];
	
	var CertObjArr = [];
	$.each(CertArr, function(item, CERTType){
		if(QualifyObj[CERTType+'RowId'] === undefined){
			return true;
		}
		var CERTRowId = ChangeEmptyToStr(QualifyObj[CERTType+'RowId']);
		var CERTText = QualifyObj[CERTType+'Text'];
		var CERTIssuedDept = ChangeEmptyToStr(QualifyObj[CERTType+'IssuedDept']);
		var CERTIssuedDate = ChangeEmptyToStr(QualifyObj[CERTType+'IssuedDate']);
		var CERTDateTo = ChangeEmptyToStr(QualifyObj[CERTType+'DateTo']);
		var CERTBlankedFlag = ChangeEmptyToStr(QualifyObj[CERTType+'BlankedFlag']);
		var CERTDelayFlag = ChangeEmptyToStr(QualifyObj[CERTType+'DelayFlag']);
		var CERTDelayDateTo = ChangeEmptyToStr(QualifyObj[CERTType+'DelayDateTo']);
		
		/*if(isEmpty(CERTRowId) && isEmpty(CERTText)){
			return true;
		}*/
		if ((isEmpty(CERTRowId))&&(isEmpty(CERTText))&&((!isEmpty(CERTIssuedDept))||(!isEmpty(CERTIssuedDate))||(!isEmpty(CERTDateTo))))
		{
			$UI.msg("alert","相关效期等不为空,则它的证号不允许为空");
			return false;
		}
		
		var CertObj = {
			CERTRowId: CERTRowId,
			CERTType: CERTType,
			CERTText: CERTText,
			CERTIssuedDept: CERTIssuedDept,
			CERTIssuedDate: CERTIssuedDate,
			CERTDateTo: CERTDateTo,
			CERTBlankedFlag: CERTBlankedFlag,
			CERTDelayFlag: CERTDelayFlag
		};
		CertObjArr.unshift(CertObj);
	});
	
	
	var SessionParmas=addSessionParams({BDPHospital:HospId});
	var Basic = JSON.stringify(jQuery.extend(true,BasicObj,SessionParmas));
	var Qualify = JSON.stringify(CertObjArr);
	$.cm({
		ClassName: 'web.DHCSTMHUI.ItmManfNew',
		MethodName: 'Save',
		Basic: Basic,
		Qualify: Qualify
	}, function (jsonData) {
		if (jsonData.success == 0) {
			$UI.msg('success', jsonData.msg);
			Select(jsonData.rowid);
		} else {
			$UI.msg('error', jsonData.msg);
		}
	});
}
