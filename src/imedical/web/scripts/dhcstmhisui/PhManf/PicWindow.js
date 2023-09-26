// ��������ͼƬ��ѯ�༭����
var PicName;
function clickPic(pic) {
	PicName = pic.name;
}
var ManfPicWin = function (Manf) {
	$HUI.dialog('#ManfPicWin').open();

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
				$UI.msg('alert', '��ѡ��ͼƬ���¹鵵��������Ϣ!');
				return;
			}
			if (PicName == "" || PicName == undefined) {
				$UI.msg('alert', '��ѡ��Ҫ���¹鵵��ͼƬ!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.ItmManfNew',
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
				$UI.msg('alert', '��ѡ��Ҫɾ����ͼƬ!');
				return;
			}
			var Params = JSON.stringify(sessionObj);
			$.cm({
				ClassName: 'web.DHCSTMHUI.ItmManfNew',
				MethodName: 'DeleteManfPic',
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

	function Clear() {
		$UI.clearBlock('#Conditions');
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
		if ((ParamsObj.comLic == '') && (ParamsObj.orgCode == '') && (ParamsObj.insBusLic == '') && (ParamsObj.insProLic == '') && (ParamsObj.drugProLic == '')
			 && (ParamsObj.socialCreditCode == '') && (ParamsObj.taxLic == '')) {
			$UI.msg('alert', '��ѡ��������Ϣ!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
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
			ClassName: 'web.DHCSTMHUI.ItmManfNew',
			MethodName: 'GetManfImage',
			Manf: Manf,
			Params: Params
		}, function (jsonData) {
			showPics(jsonData);
		});
	}
	Clear();
}
// ��������ͼƬ�ϴ�����
var UpLoadWin = function (Manf, Qualify) {
	uploader.clear();
	var Params = {
		Manf: Manf,
		Type: 'Manf',
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
				$UI.msg('alert','û����Ҫ�ϴ���ͼƬ��')
 				return false;
			}
			uploader.upload();
		}
	});
}
// ��������ͼƬ���մ���
var ManfTakePicWindow;
var TakePhotoWin = function (Manf, Qualify) {
	var AppName = 'DHCSTPHMANFM';
	if ((!ManfTakePicWindow) || (ManfTakePicWindow.closed)) {
		var lnk = 'dhcstmhui.takepiccommon.csp';
		lnk = lnk + "?AppName=" + AppName;
		lnk = lnk + "&RowId=" + Manf;
		lnk = lnk + "&typeCode=" + Qualify;
		lnk = lnk + "&typeDesc=" + "";
		lnk = lnk + "&GroupId=" + session['LOGON.GROUPID'];
		lnk = lnk + "&LocId=" + session['LOGON.CTLOCID'];
		lnk = lnk + "&UserId=" + session['LOGON.USERID'];
		ManfTakePicWindow = window.open(lnk, "take_photo", "height=600,width=800,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=yes,location=no, status=yes");
	} else {
		ManfTakePicWindow.SetType(AppName, Manf, Qualify, "", session['LOGON.GROUPID'], session['LOGON.CTLOCID'], session['LOGON.USERID']);
		ManfTakePicWindow.focus();
	}
}
