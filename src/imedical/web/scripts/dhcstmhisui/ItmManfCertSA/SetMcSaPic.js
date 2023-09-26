var G_MC;
var G_PicName;
function clickPic(Pic){
	G_PicName = Pic.name;
}

function Clear() {
	$('#PicLists').empty();
	$('#PicLists').viewer('destroy');
}

function Query() {
	if(isEmpty(G_MC)){
		return;
	}
	var FtpParamObj = GetAppPropValue('DHCSTFTPFILEM');
	var tmpl = "<li class='imgbox'><a href='javascript:void(0)' onclick='clickPic(this)' name='${PicSrc}'><img data-original=http://" + FtpParamObj.FtpHttpSrc + "${PicSrc} src=http://" + FtpParamObj.FtpHttpSrc + "${PicSrc} alt=${ImgType}></a></li>" +
		"<div style='text-align:center'>${ImgType}</div>";
	function showPics(data) {
		$.tmpl(tmpl, data).appendTo('#PicLists');
		$('#PicLists').viewer({
			zIndex: 9999999999999
		});
	}
	$.cm({
		ClassName: 'web.DHCSTMHUI.DHCItmManfCertSAPic',
		MethodName: 'GetMCImage',
		MC: G_MC
	}, function (jsonData) {
		showPics(jsonData);
	});
}

function DelMCPic(){
	if (isEmpty(G_PicName)) {
		$UI.msg('alert', '请选择要删除的图片!');
		return;
	}
	var Params = JSON.stringify(sessionObj);
	$.cm({
		ClassName: 'web.DHCSTMHUI.DHCItmManfCertSAPic',
		MethodName: 'DelMCPic',
		PicName: G_PicName,
		Params: Params
	}, function(jsonData){
		if (jsonData.success === 0) {
			$UI.msg('success', jsonData.msg);
			Clear();
			Query();
		} else {
			$UI.msg('error', jsonData.msg);
		}
	});
}
	
// 厂商注册证图片查询编辑窗口
var McPicWin = function (MC) {
	G_MC = MC;
	if (MC == "" || MC == undefined) {
		$UI.msg('alert', '请先保存该厂商注册证信息!');
		return;
	}
	$HUI.dialog('#McPicWin').open();

	$UI.linkbutton('#UpLoadBT', {
		onClick: function () {
			UpLoadWin(MC);
		}
	});

	$UI.linkbutton('#TakePhotoBT', {
		onClick: function () {
			TakePhotoWin(MC);
		}
	});

	$UI.linkbutton('#DeletePicBT', {
		onClick: function () {
			$UI.confirm('您将要删除选中的图片,是否继续?', '', '', DelMCPic);
		}
	});

	Clear();
	Query();
}
// 厂商注册证图片上传窗口
var UpLoadWin = function (MC) {
	uploader.clear();
	var Params = {
		MC: MC,
		Type: 'MC',
		PicType: ""
	};
	Params = JSON.stringify(addSessionParams(Params));
	uploader.setParams(Params)
	$HUI.dialog('#UpLoadWin',{
		onClose: function(){
			Clear();
			Query();
		}
	}).open();
	uploader.refresh();
	$UI.linkbutton('#UpLoadPicBT', {
		onClick: function () {
			uploader.upload();
		}
	});
}
// 厂商注册证图片拍照窗口
var MCTakePicWindow;
var TakePhotoWin = function (MC) {
	var AppName = 'DHCSTPHMCM';
	if ((!MCTakePicWindow) || (MCTakePicWindow.closed)) {
		var lnk = 'dhcstmhui.takepiccommon.csp';
		lnk = lnk + "?AppName=" + AppName;
		lnk = lnk + "&RowId=" + MC;
		lnk = lnk + "&typeCode=" + "";
		lnk = lnk + "&typeDesc=" + "";
		lnk = lnk + "&GroupId=" + session['LOGON.GROUPID'];
		lnk = lnk + "&LocId=" + session['LOGON.CTLOCID'];
		lnk = lnk + "&UserId=" + session['LOGON.USERID'];
		MCTakePicWindow = window.open(lnk, "take_photo", "height=600,width=800,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=yes,location=no, status=yes");
	} else {
		MCTakePicWindow.SetType(AppName, MC, "", "", session['LOGON.GROUPID'], session['LOGON.CTLOCID'], session['LOGON.USERID']);
		MCTakePicWindow.focus();
	}
}
