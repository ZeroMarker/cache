$(function() {
	if (HISUIStyleCode === 'lite') {
		// 极简UI调整按钮"选取文件"按钮(本身是一个div)
		$('#AddPicBT').css('height', 28);
		$('.webuploader-pick + div').css('height', 28);
		$('.webuploader-pick').css('border-radius', 2).css('background', '#339EFF').css('padding', '4px 15px 6px 15px');
	}
});

var uploader = null;
$(function(FilePick, PicList) {
	/* init webuploader*/
	var $list = $(PicList);
	var thumbnailWidth = 0.4; // 缩略图高度和宽度 （单位是像素），当宽高度是0~1的时候，是按照百分比计算，具体可以看api文档
	var thumbnailHeight = 0.4;

	uploader = WebUploader.create({
		// 选完文件后，是否自动上传。
		auto: false,

		// swf文件路径
		swf: '${ctxStatic }/webupload/Uploader.swf',

		// 文件接收服务端。
		server: 'dhcstmhui.picupload.csp',

		// 选择文件的按钮。可选。
		// 内部根据当前运行是创建，可能是input元素，也可能是flash.
		pick: FilePick,
		// 只允许选择图片文件。
		accept: {
			title: 'Images',
			extensions: 'gif,jpg,jpeg,bmp,png,pdf,doc,docx,xls,xlsx,txt',
			mimeTypes: ''
		},
		method: 'POST'
	});
	// 当有文件添加进来的时候
	uploader.on('fileQueued', function(file) {
		var $li = $(
				'<div id="' + file.id + '" class="file-item thumbnail">'
				+ '<img>'
				+ '<div id="filename" class="info">' + file.name + '</div>'
			+ '</div>'
			),
			$img = $li.find('img');

		// $list为容器jQuery实例
		$list.append($li);

		// 创建缩略图
		// 如果为非图片文件，可以不用调用此方法。
		// thumbnailWidth x thumbnailHeight 为 100 x 100
		uploader.makeThumb(file, function(error, src) {
			if (error) {
				// $img.replaceWith('<span>不能预览</span>');
				return;
			}

			$img.attr('src', src);
		}, thumbnailWidth, thumbnailHeight);
	});
	// 文件上传过程中创建进度条实时显示。
	uploader.on('uploadProgress', function(file, percentage) {
		var $li = $('#' + file.id),
			$percent = $li.find('.progress span');

		// 避免重复创建
		if (!$percent.length) {
			$percent = $('<p class="progress"><span></span></p>')
				.appendTo($li)
				.find('span');
		}

		$percent.css('width', percentage * 100 + '%');
	});

	// 文件上传成功，给item添加成功class, 用样式标记上传成功。
	uploader.on('uploadSuccess', function(file, ret) {
		var $li = $('#' + file.id);
		$success = $li.find('div.success');
		// 避免重复创建
		if (!$success.length) {
			$success = $('<div class="success"></div>').appendTo($li);
		}
		if (ret.success == 0) {
			$li.addClass('upload-state-done');
			$UI.msg('success', '上传成功!');
			$success.text('上传成功!');
		} else {
			$UI.msg('error', ret.msg);
			$success.text('上传失败!');
		}
	});

	// 文件上传失败，显示上传出错。
	uploader.on('uploadError', function(file) {
		var $li = $('#' + file.id),
			$error = $li.find('div.error');

		// 避免重复创建
		if (!$error.length) {
			$error = $('<div class="error"></div>').appendTo($li);
		}

		$error.text('上传失败');
	});

	// 完成上传完了，成功或者失败，先删除进度条。
	uploader.on('uploadComplete', function(file) {
		$('#' + file.id).find('.progress').remove();
	});
	uploader.setParams = function(Params) {
		uploader.options.formData = { Params: Params, actiontype: 'UpLoad' };
	};
	uploader.clear = function() {
		$list.empty();
	};
}('#AddPicBT', '#PicList'));

var PicName;
var FileUrl = '';
function clickPic(File) {
	PicName = File.name;
	var FtpParamObj = GetAppPropValue('DHCSTFTPFILEM');
	var httpHref = window.location.href;
	var httpPre = 'http://';
	if (httpHref.indexOf('https') >= 0) {
		httpPre = 'https://';
	}
	var url = httpPre + FtpParamObj.FtpHttpSrc + PicName;
	FileUrl = url;
}
// 目前只支持pdf预览
function showFiles(File) {
	PicName = File.name;
	var FileSuffix = PicName.split('.')[1];
	if ((FileSuffix != 'PDF') && (FileSuffix != 'pdf')) {
		return;
	}
	var FtpParamObj = GetAppPropValue('DHCSTFTPFILEM');
	$HUI.dialog('#ShowPdfWin').open();
	var httpHref = window.location.href;
	var httpPre = 'http://';
	if (httpHref.indexOf('https') >= 0) {
		httpPre = 'https://';
	}
	var url = httpPre + FtpParamObj.FtpHttpSrc + PicName;
	$('#pdfContainer').attr('src', '../scripts/dhcstmhisui/ExtUX/pdfjs/web/viewer.html?file=' + url + '#page=1');
}
var ViewFileWin = function(OrgType, OrgId, GrpType, PointerType, Pointer, SubType, HospId) {
	if (Pointer == undefined) { Pointer = ''; }
	if (SubType == undefined) { SubType = ''; }
	$HUI.dialog('#ViewFileWin').open();
	
	var ViewFileType = $HUI.combobox('#ViewFileType', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetFileType&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ BDPHospital: HospId, OrgType: OrgType, GrpType: GrpType })),
		valueField: 'RowId',
		textField: 'Description'
	});

	$UI.linkbutton('#FileQueryBT', {
		onClick: function() {
			Query();
		}
	});

	$UI.linkbutton('#FileClearBT', {
		onClick: function() {
			Clear();
		}
	});

	$UI.linkbutton('#FileDeleteBT', {
		onClick: function() {
			if (PicName == '' || PicName == undefined) {
				$UI.msg('alert', '请选择要删除的文件!');
				return;
			}
			var Params = JSON.stringify(sessionObj);
			$.cm({
				ClassName: 'web.DHCSTMHUI.UpLoadPic',
				MethodName: 'jsDeleteFileInfo',
				PicName: PicName,
				Params: Params
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					Query();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	
	$UI.linkbutton('#FileDownBT', {
		onClick: function() {
			if (FileUrl == '' || FileUrl == undefined) {
				$UI.msg('alert', '请选择要下载的文件!');
				return;
			}
			var url = FileUrl.replace(/\\/g, '/');
			var $a = document.createElement('a');
			$a.setAttribute('href', url);
			$a.setAttribute('download', '');
			var evObj = document.createEvent('MouseEvents');
			evObj.initMouseEvent('click', true, true, window, 0, 0, 0, 0, 0, false, false, true, false, 0, null);
			$a.dispatchEvent(evObj);
		}
	});

	function Clear() {
		PicName = '';
		FileUrl = '';
		$UI.clearBlock('#FileConditions');
		$('#PicLists').empty();
		$('#PicLists').viewer('destroy');
		$('#PdfLists').empty();
		$('#PdfLists').viewer('destroy');
		if ((Pointer == '') && ((OrgType == 'Manf') || (OrgType == 'Vendor'))) {
			$('#ViewFileTypeLabel').parent().show();
			$('#FileQueryBT').parent().show();
			$('#FileClearBT').parent().show();
		} else {
			$('#ViewFileTypeLabel').parent().hide();
			$('#FileQueryBT').parent().hide();
			$('#FileClearBT').parent().hide();
		}
	}

	function Query() {
		PicName = '';
		FileUrl = '';
		$('#PicLists').empty();
		$('#PicLists').viewer('destroy');
		$('#PdfLists').empty();
		$('#PdfLists').viewer('destroy');
		if ((OrgId == '') && (Pointer == '')) {
			$UI.msg('alert', '请选择一条数据进行预览!');
			return;
		}
		var FtpParamObj = GetAppPropValue('DHCSTFTPFILEM');
		var httpHref = window.location.href;
		var httpPre = 'http://';
		if (httpHref.indexOf('https') >= 0) {
			httpPre = 'https://';
		}
		var tmpl = "<li class='imgbox'><a href='javascript:void(0)' onclick='clickPic(this)' name='${PicSrc}'>"
			+ '<img data-original=' + httpPre + FtpParamObj.FtpHttpSrc + '${PicSrc} src=' + httpPre + FtpParamObj.FtpHttpSrc + '${PicSrc} alt=${PicSrc}>'
			+ "</a></li><div style='text-align:center'>${ImgType}&nbsp;&nbsp;${FileName}</div>";
		var tmpln = "<li><a href='#' onclick='clickPic(this)' ondblclick='showFiles(this)' name='${PicSrc}'>${ImgType}&nbsp;&nbsp;${FileName}</a></li>";
		function showPics(data) {
			$.tmpl(tmpl, data).appendTo('#PicLists');
			$('#PicLists').each(function() {
				var i = $(this);
				var p = i.find('li');
				p.click(function() {
					if ($(this).hasClass('selectedpic')) {
						$(this).removeClass('selectedpic');
					} else {
						$(this).addClass('selectedpic').siblings('li').removeClass('selectedpic');
					}
				});
			});
			$('#PicLists').viewer({
				zIndex: 9999999999999
			});
			if (isEmpty(data)) {
				$('#PicLists').empty();
			}
		}
		function showFileList(data) {
			$.tmpl(tmpln, data).appendTo('#PdfLists');
			$('#PdfLists').each(function() {
				var i = $(this);
				var p = i.find('li');
				p.click(function() {
					if ($(this).hasClass('selectedfile')) {
						$(this).removeClass('selectedfile');
					} else {
						$(this).addClass('selectedfile').siblings('li').removeClass('selectedfile');
					}
				});
			});
			$('#PdfLists').viewer({
				zIndex: 9999999999999
			});
		}
		var ViewFileType = $('#ViewFileType').combobox('getValue');
		if (!isEmpty(ViewFileType)) {
			PointerType = ViewFileType;
		}
		var Params = {
			OrgType: OrgType,
			OrgId: OrgId,
			GrpType: GrpType,
			PointerType: PointerType,
			Pointer: Pointer,
			SubType: SubType,
			HospId: HospId
		};
		Params = JSON.stringify(addSessionParams(Params));
		$.cm({
			ClassName: 'web.DHCSTMHUI.UpLoadPic',
			MethodName: 'GetFileInfo',
			Params: Params
		}, function(jsonData) {
			var PDFData = jsonData.PDF;
			var JPGData = jsonData.JPG;
			showPics(JPGData);
			showFileList(PDFData);
		});
	}
	Clear();
	Query();
};
// 文件上传窗口
var UpLoadFileWin = function(OrgType, OrgId, GrpType, PointerType, Pointer, SubType) {
	if (SubType == undefined) { SubType = ''; }
	uploader.clear();
	var Params = {
		OrgType: OrgType,
		OrgId: OrgId,
		GrpType: GrpType,
		PointerType: PointerType,
		Pointer: Pointer,
		SubType: SubType
	};
	Params = JSON.stringify(addSessionParams(Params));
	uploader.setParams(Params);
	$HUI.dialog('#UpLoadFileWin').open();
	uploader.reset();
	$UI.linkbutton('#UpLoadFileBT', {
		onClick: function() {
			var count = 0;
			$('#PicList').each(function() {
				var i = $(this);
				var p = i.find('#filename');
				count = p.length;
			});
			if (count <= 0) {
				$UI.msg('alert', '没有需要上传的文件！');
				return false;
			}
			uploader.upload();
			$HUI.dialog('#UpLoadFileWin').close();
		}
	});
};
// 图片拍照窗口
var TakePhotoWindow;
var TakePhotoWin = function(OrgType, OrgId, GrpType, PointerType, Pointer, SubType) {
	var Params = {
		OrgType: OrgType,
		OrgId: OrgId,
		GrpType: GrpType,
		PointerType: PointerType,
		Pointer: Pointer,
		SubType: SubType
	};
	Params = JSON.stringify(addSessionParams(Params));

	if ((!TakePhotoWindow) || (TakePhotoWindow.closed)) {
		var lnk = 'dhcstmhui.takepiccommon.csp';
		lnk = lnk + '?Params=' + Params;
		TakePhotoWindow = window.open(lnk, 'take_photo', 'height=600,width=800,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=yes,location=no, status=yes');
	} else {
		TakePhotoWindow.SetType(Params);
		TakePhotoWindow.focus();
	}
};