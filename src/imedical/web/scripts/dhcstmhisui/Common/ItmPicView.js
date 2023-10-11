var PicName;
var FileTypeUrl = '';
var FtpParamObj = GetAppPropValue('DHCSTFTPFILEM');
function clickPic(File) {
	PicName = File.name;
}
function showFiles(File) {
	PicName = File.name;
	$HUI.dialog('#ShowPdfWin').open();
	var httpHref = window.location.href;
	var httpPre = 'http://';
	if (httpHref.indexOf('https') >= 0) {
		httpPre = 'https://';
	}
	var url = httpPre + FtpParamObj.FtpHttpSrc + PicName;
	$('#pdfContainer').attr('src', '../scripts/dhcstmhisui/ExtUX/pdfjs/web/viewer.html?file=' + url + '#page=1');
}
var init = function() {
	if (!isEmpty(gOeori) || !isEmpty(gInciId)) {
		Query();
	}

	function Query() {
		$('#ItmPicLists').empty();
		$('#ItmPicLists').viewer('destroy');
		$('#CertPicLists').empty();
		$('#CertPicLists').viewer('destroy');

		var httpHref = window.location.href;
		var httpPre = 'http://';
		if (httpHref.indexOf('https') >= 0) {
			httpPre = 'https://';
		}
		var tmpl = "<li class='imgbox'><a href='javascript:void(0)' onclick='clickPic(this)' name='${PicSrc}'>"
			+ '<img data-original=' + httpPre + FtpParamObj.FtpHttpSrc + '${PicSrc} src=' + httpPre + FtpParamObj.FtpHttpSrc + '${PicSrc} alt=${PicSrc}>'
			+ "</a></li><div style='text-align:center'>${ImgType}&nbsp;&nbsp;${FileName}</div>";
		var tmpln = "<li><a href='#' onclick='clickPic(this)' ondblclick='showFiles(this)' name='${PicSrc}'>${ImgType}&nbsp;&nbsp;${FileName}</a></li>";
		var Params = {
			InciId: gInciId,
			Oeori: gOeori
		};
		Params = JSON.stringify(addSessionParams(Params));
		$.cm({
			ClassName: 'web.DHCSTMHUI.UpLoadPic',
			MethodName: 'GetFileInfoByItm',
			Params: Params
		}, function(jsonData) {
			var InciJPGData = jsonData.InciJPG;
			var InciPDFData = jsonData.InciPDF;
			var VendorJPGData = jsonData.VendorJPG;
			var VendorPDFData = jsonData.VendorPDF;
			showItm(InciJPGData, InciPDFData, tmpl, tmpln);
			showVendor(VendorJPGData, VendorPDFData, tmpl, tmpln);
		});
		
		function showItm(InciJPGData, InciPDFData, tmpl, tmpln) {
			if ((InciJPGData != '') && (InciJPGData != undefined)) {
				if ($('#ItmPanel').hasClass('NoPic')) {
					$('#ItmPanel').removeClass('NoPic');
				}
				$.tmpl(tmpl, InciJPGData).appendTo('#ItmPicLists');
			}
			if ((InciPDFData != '') && (InciPDFData != undefined)) {
				if ($('#ItmPanel').hasClass('NoPic')) {
					$('#ItmPanel').removeClass('NoPic');
				}
				$.tmpl(tmpln, InciPDFData).appendTo('#ItmPicLists');
			}
			$('#ItmPicLists').viewer({
				zIndex: 9999999999999
			});
		}
		function showVendor(VendorJPGData, VendorPDFData, tmpl, tmpln) {
			if ((VendorJPGData != '') && (VendorJPGData != undefined)) {
				if ($('#CertPanel').hasClass('NoPic')) {
					$('#CertPanel').removeClass('NoPic');
				}
				$.tmpl(tmpl, VendorJPGData).appendTo('#CertPicLists');
			}
			if ((VendorPDFData != '') && (VendorPDFData != undefined)) {
				if ($('#CertPanel').hasClass('NoPic')) {
					$('#CertPanel').removeClass('NoPic');
				}
				$.tmpl(tmpln, VendorPDFData).appendTo('#CertPicLists');
			}
			$('#CertPicLists').viewer({
				zIndex: 9999999999999
			});
		}
	}
};
$(init);