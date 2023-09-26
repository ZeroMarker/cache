var VendorCm, VendorGrid;
var HospId=gHospId;
var TableName="APC_Vendor";
var init = function () {
	function InitHosp() {
		var hospComp=InitHospCombo(TableName,gSessionStr,VendorGrid);
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
		$UI.clearBlock('#BasicCheckConditions');
		$UI.clearBlock('#QualifyConditions');
		$UI.clearBlock('#SalesManConditions');
		$UI.clear(VendorGrid);
		VendorGrid.load({
			ClassName: 'web.DHCSTMHUI.APCVenNew',
			QueryName: 'APCVendor',
			Params: Params
		});
	}
	
	var VendorCat = $HUI.combobox('#VendorCat', {
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function () {
			VendorCat.clear();
			var Params=JSON.stringify(addSessionParams({BDPHospital:HospId}));
			var url=$URL + '?ClassName=web.DHCSTMHUI.APCVendCat&QueryName=GetVendorCat&ResultSetType=array&Params='+Params;
			VendorCat.reload(url);
		}
	});
	
	var VendorCat_1 = $HUI.combobox('#VendorCat_1', {
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function () {
			VendorCat_1.clear();
			var Params=JSON.stringify(addSessionParams({BDPHospital:HospId}));
			var url=$URL + '?ClassName=web.DHCSTMHUI.APCVendCat&QueryName=GetVendorCat&ResultSetType=array&Params='+Params;
			VendorCat_1.reload(url);
		}
	});

	VendorCm = [[{
				title: "操作",
				field: 'Icon',
				width: 50,
				align: 'center',
				formatter: function (value, row, index) {
					var str = "<a href='#' onclick='VendorPicWin(" + row.RowId + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/img.png' title='查看图片' border='0'></a>";
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
				field: 'VendorCode',
				width: 100
			}, {
				title: '名称',
				field: 'VendorDesc',
				width: 200
			}, {
				title: '电话',
				field: 'Tel',
				width: 100
			}, {
				title: '分类',
				field: 'VendorCat',
				width: 100
			}, {
				title: '账户',
				field: 'CtrlAcct',
				width: 150
			}, {
				title: "注册资金",
				field: 'CrAvail',
				align: 'right',
				width: 100
			}, {
				title: "合同日期",
				field: 'LstPoDate',
				width: 100
			}, {
				title: "传真",
				field: 'Fax',
				width: 100
			}, {
				title: "法人",
				field: 'President',
				width: 100
			}, {
				title: "法人身份证",
				field: 'PresidentCard',
				width: 100
			}, {
				title: "法人电话",
				field: 'PresidentTel',
				width: 100
			}, {
				title: "最后业务日期",
				field: 'LstBsDate',
				width: 100
			}, {
				title: "使用标志",
				field: 'Status',
				width: 100,
				formatter: function (value, row, index) {
					if (value == "A") {
						return "使用";
					} else {
						return "停用";
					}
				}
			}
		]];

	VendorGrid = $UI.datagrid('#VendorGrid', {
			lazy: false,
			queryParams: {
				ClassName: 'web.DHCSTMHUI.APCVenNew',
				QueryName: 'APCVendor'
			},
			columns: VendorCm,
			onSelect: function (Index, Row) {
				Clear();
				Select(Row.RowId);
			},
			onLoadSuccess: function (data) {
				if (data.rows.length > 0) {
					VendorGrid.selectRow(0);
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
		}
	});
	$UI.linkbutton('#AddBT_2', {
		onClick: function () {
			Clear();
		}
	});
	$UI.linkbutton('#AddBT_3', {
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
	$UI.linkbutton('#SaveBT_3', {
		onClick: function () {
			Save();
		}
	});
	$UI.linkbutton('#UpLoadBT', {
		onClick: function () {
			var RowId = $('#RowId').val();
			if (RowId == "") {
				$UI.msg('alert', '请先选择或保存供应商信息!');
				return;
			}
			var Qualifications = $("#Qualifications").combo('getValue');
			if (Qualifications == "" || Qualifications == null) {
				$UI.msg('alert', '请选择资质信息!');
				return;
			}
			UpLoadWin(RowId,Qualifications);
		}
	});

	$UI.linkbutton('#TakePhotoBT', {
		onClick: function () {
			var RowId = $('#RowId').val();
			if (RowId == "") {
				$UI.msg('alert', '请先选择或保存供应商信息!');
				return;
			}
			var Qualifications = $("#Qualifications").combo('getValue');
			if (Qualifications == "" || Qualifications == null) {
				$UI.msg('alert', '请选择资质信息!');
				return;
			}
			TakePhotoWin(RowId,Qualifications);
		}
	});
	InitHosp();
}
$(init);

function Select(Vendor) {
	$.cm({
		ClassName: 'web.DHCSTMHUI.APCVenNew',
		MethodName: 'Select',
		Vendor: Vendor
	}, function (jsonData) {
		if(jsonData.success != 0){
			$UI.msg('error', '供应商信息查询有误!');
			return;
		}
		$UI.fillBlock('#BasicConditions', jsonData.BasicData);
		$UI.fillBlock('#BasicCheckConditions', jsonData.BasicData);
		$UI.fillBlock('#SalesManConditions', jsonData.BasicData);
		$UI.fillBlock('#QualifyConditions', jsonData.CertData);
		$('#VendorDesc_1').validatebox("validate");
	});
}
function Clear() {
	$UI.clearBlock('#BasicConditions');
	$UI.clearBlock('#BasicCheckConditions');
	$UI.clearBlock('#QualifyConditions');
	$UI.clearBlock('#SalesManConditions');
	var Dafult = {
			Status: "A"
		}
	$UI.fillBlock('#BasicConditions', Dafult)
}
function Save() {
	var BasicObj = $UI.loopBlock('#BasicConditions');
	var CheckObj = $UI.loopBlock('#BasicCheckConditions');
	var QualifyObj = $UI.loopBlock('#QualifyConditions');
	var SalesManObj = $UI.loopBlock('#SalesManConditions');
	
	//组织资质的Object
	var CertArr = ['comLic', 'taxLic', 'orgCode', 'insBusLic', 'agentAuth',
		'vendorAgreement', 'saleServComm', 'legalComm', 'qualityComm'
	];
	var CertObjArr = [];
	$.each(CertArr, function(item, CERTType){
		//这里从name上做约定,不同的资质,使用相同的写法(比如发证机关,都是拼接IssuedDept)
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
	var Check = JSON.stringify(CheckObj);
	var Qualify = JSON.stringify(CertObjArr);	//资质,使用修正后的数据
	var SalesMan = JSON.stringify(SalesManObj);
	$.cm({
		ClassName: 'web.DHCSTMHUI.APCVenNew',
		MethodName: 'Save',
		Basic: Basic,
		Check: Check,
		Qualify: Qualify,
		SalesMan: SalesMan
	}, function (jsonData) {
		if (jsonData.success == 0) {
			$UI.msg('success', jsonData.msg);
			Select(jsonData.rowid);
		} else {
			$UI.msg('error', jsonData.msg);
		}
	});
}