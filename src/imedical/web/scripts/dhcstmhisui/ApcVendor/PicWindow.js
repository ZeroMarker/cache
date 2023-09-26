// 供应商资质图片查询编辑窗口
var PicName;
function clickPic(pic) {
	PicName = pic.name;
}
var VendorPicWin = function (Vendor) {
	$HUI.dialog('#VendorPicWin').open();

	$UI.linkbutton('#PicQueryBT', {
		onClick: function () {
			Query();
		}
	});

	$UI.linkbutton('#ClearBT', {
		onClick: function () {
			Clear();
		}
	});

	$UI.linkbutton('#SaveBT', {
		onClick: function () {
			var Qualification = $("#Qualification").combo('getValue');
			if (Qualification == "" || Qualification == null) {
				$UI.msg('alert', '请选择图片重新归档的资质信息!');
				return;
			}
			if (PicName == "" || PicName == undefined) {
				$UI.msg('alert', '请选择要重新归档的图片!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.APCVenNew',
				MethodName: 'UpdatePicInfo',
				PicName: PicName,
				Type: Qualification
			}, function (jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					Query();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	$UI.linkbutton('#DeleteBT', {
		onClick: function () {
			if (PicName == "" || PicName == undefined) {
				$UI.msg('alert', '请选择要删除的图片!');
				return;
			}
			var Params = JSON.stringify(sessionObj);
			$.cm({
				ClassName: 'web.DHCSTMHUI.APCVenNew',
				MethodName: 'DeletePicInfo',
				PicName: PicName,
				Params: Params
			}, function (jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					Query();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	$UI.linkbutton('#AuditBT', {
		onClick: function () {
			if (PicName == "" || PicName == undefined) {
				$UI.msg('alert', '请选择要审核的图片!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.APCVenNew',
				MethodName: 'AuditPicInfo',
				PicName: PicName
			}, function (jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					Query();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	$UI.linkbutton('#DenyBT', {
		onClick: function () {
			if (PicName == "" || PicName == undefined) {
				$UI.msg('alert', '请选择要拒绝的图片!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.APCVenNew',
				MethodName: 'DenyPicInfo',
				PicName: PicName
			}, function (jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					Query();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	function Clear() {
		$UI.clearBlock('#Conditions');
		$HUI.checkbox('#AuditFlag').setValue('');
		$('#Qualification').combobox('setValue', '');
		$('#PicLists').empty();
		$('#PicLists').viewer('destroy');
		PicName = "";
	}

	function Query() {
		$('#PicLists').empty();
		$('#PicLists').viewer('destroy');
		PicName = "";
		var ParamsObj = $UI.loopBlock('#Conditions');
		if ((ParamsObj.comLic == '') && (ParamsObj.insRegLic == '') && (ParamsObj.legalComm == '') && (ParamsObj.taxLic == '') && (ParamsObj.insBusLic == '')
			 && (ParamsObj.socialCreditComm == '') && (ParamsObj.gspLic == '') && (ParamsObj.insProLic == '') && (ParamsObj.qualityComm == '') && (ParamsObj.orgCode == '')
			 && (ParamsObj.inletRLic == '') && (ParamsObj.salsPhoto == '') && (ParamsObj.agentAuth == '') && (ParamsObj.inletRegLic == '') && (ParamsObj.salesID == '')
			 && (ParamsObj.vendorAgreement == '') && (ParamsObj.saleServComm == '') && (ParamsObj.salesLic == '')) {
			$UI.msg('alert', '请选择资质信息!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		var AuditFlag = ($HUI.checkbox('#AuditFlag').getValue()) == true ? 'Y' : 'N';
		var FtpParamObj = GetAppPropValue('DHCSTFTPFILEM');
		var tmpl = "<li class='imgbox'><a href='javascript:void(0)' onclick='clickPic(this)' name='${PicSrc}'><img data-original=http://" + FtpParamObj.FtpHttpSrc + "${PicSrc} src=http://" + FtpParamObj.FtpHttpSrc + "${PicSrc} alt=${ImgType}></a></li>" +
			"<div style='text-align:center'>${ImgType}</div>";
		function showPics(data) {
			$.tmpl(tmpl, data).appendTo('#PicLists');
			$("#PicLists").each(function(){
			var i=$(this);
			var p=i.find("li");
			p.click(function(){
					if(!!$(this).hasClass("selectedpic")){
						$(this).removeClass("selectedpic");
					}else{
						$(this).addClass("selectedpic").siblings("li").removeClass("selectedpic");
					}
				})
			})
			$('#PicLists').viewer({
				zIndex: 9999999999999
			});
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.APCVenNew',
			MethodName: 'GetVendorImage',
			Vendor: Vendor,
			Params: Params,
			AuditFlag: AuditFlag
		}, function (jsonData) {
			showPics(jsonData);
		});
	}
	Clear();
}
// 供应商资质图片上传窗口
var UpLoadWin = function (Vendor, Qualify) {
	uploader.reset();
	uploader.clear();
	var Params = {
		Vendor: Vendor,
		Type: 'Vendor',
		PicType: Qualify
	};
	Params = JSON.stringify(addSessionParams(Params));
	uploader.setParams(Params)
	$HUI.dialog('#UpLoadWin').open()
	uploader.refresh();
	$UI.linkbutton('#UpLoadPicBT', {
		onClick: function () {
			var count=0;
			$("#PicList").each(function(){
				var i=$(this);
				var p=i.find("img");
				count=p.length;
			})
			if (count<=0){
				$UI.msg('alert','没有需要上传的图片！')
 				return false;
			}
			uploader.upload();
		}
	});
}
// 供应商资质图片拍照窗口
var VendorTakePicWindow;
var TakePhotoWin = function (Vendor, Qualify) {
	var AppName = 'DHCSTVENDORMTM';
	if ((!VendorTakePicWindow) || (VendorTakePicWindow.closed)) {
		var lnk = 'dhcstmhui.takepiccommon.csp';
		lnk = lnk + "?AppName=" + AppName;
		lnk = lnk + "&RowId=" + Vendor;
		lnk = lnk + "&typeCode=" + Qualify;
		lnk = lnk + "&typeDesc=" + "";
		lnk = lnk + "&GroupId=" + session['LOGON.GROUPID'];
		lnk = lnk + "&LocId=" + session['LOGON.CTLOCID'];
		lnk = lnk + "&UserId=" + session['LOGON.USERID'];
		VendorTakePicWindow = window.open(lnk, "take_photo", "height=600,width=800,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=yes,location=no, status=yes");
	} else {
		VendorTakePicWindow.SetType(AppName, Vendor, Qualify, "", session['LOGON.GROUPID'], session['LOGON.CTLOCID'], session['LOGON.USERID']);
		VendorTakePicWindow.focus();
	}
}
