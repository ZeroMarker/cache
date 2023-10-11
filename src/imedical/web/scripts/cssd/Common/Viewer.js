var gPointerType, gPointer, FileSrc;
var FtpParamObj = GetAppPropValue('CSSDFTPFILEM');
var httpHref = window.location.href;
var httpPre = 'http://' + FtpParamObj.FtpHttpSrc;
if (httpHref.indexOf('https') >= 0) {
	httpPre = 'https://' + FtpParamObj.FtpHttpSrc;
}
function ViewPic(PointerType, Pointer) {
	gPointerType = PointerType;
	gPointer = Pointer;
	$HUI.dialog('#ViewPicWin', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
}
var initViewPicWin = function() {
	$(function() {
		if (HISUIStyleCode === 'lite') {
			// 极简UI调整按钮"选取文件"按钮(本身是一个div)
			$('#AddViewPicBT').css('height', 28);
			$('.webuploader-pick + div').css('height', 28);
			$('.webuploader-pick').css('border-radius', 2).css('background', '#339EFF').css('padding', '4px 15px 6px 15px');
		}
	});
	var uploader = null;
	$(function(FilePick, PicList) {
		/* init webuploader*/
		var $list = $(PicList);
		var thumbnailWidth = 120; // 缩略图高度和宽度 （单位是像素），当宽高度是0~1的时候，是按照百分比计算，具体可以看api文档
		var thumbnailHeight = 120;
		uploader = WebUploader.create({
			// 选完文件后，是否自动上传。
			auto: false,
			// swf文件路径
			swf: '${ctxStatic }/webupload/Uploader.swf',
			// 文件接收服务端。
			server: 'cssdhui.picupload.csp',
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
			var tip = '未上传';
			var $li = $(
					'<div id="' + file.id + '" class="file-item thumbnail">'
					+ '<img>'
					+ '<div id="filename" class="info">' + file.name + '</div>'
				+ '</div>'
				// '<li id="' + file.id + '" class="imgbox newImg">' +
				//	'<img >' +
				// '</li>'+
				// '<div style="text-align:center;color:red;" value="0" >' + file.name +'-未上传'+'</div>'
				),
				$img = $li.find('img');
			
			// $list为容器jQuery实例
			$list.append($li);
			// 遮罩层
			$("<div class=\"datagrid-mask\"  style='z-index:9999'></div>").css({ display: 'block', opacity: 0.5, width: $('.newImg').outerWidth(), height: $('.newImg').outerHeight() }).appendTo($('.newImg'));
			// $("<div class=\"datagrid-mask-msg\" style='z-index:9999;font-size:12px;color:red'></div>").html(tip).appendTo(".newImg").css({ display: "block",width: ($(".newImg").outerWidth()-20)/2, left: ($(".newImg").outerWidth()-100)/ 2, top: ($(".newImg").outerHeight()-100) / 2,height:"auto" });  
			// 创建缩略图
			// 如果为非图片文件，可以不用调用此方法。
			// thumbnailWidth x thumbnailHeight 为 100 x 100
			uploader.makeThumb(file, function(error, src) {
				if (error) {
					$img.replaceWith('<span>不能预览</span>');
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
			if (ret.success == '0') {
				$li.addClass('upload-state-done');
				$UI.msg('success', '上传成功!');
			} else {
				$UI.msg('error', ret.msg);
				$success.text('上传失败!');
			}
			GetFileInfo();
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
			uploader.options.formData = { Params: Params, actiontype: 'CommonUpLoad' };
		};
		uploader.clear = function() {
			$list.empty();
		};
		uploader.callback = function(Params) {
			
		};
	}('#AddViewPicBT', '#PicsList'));
	
	// 图片列表
	var tmpl = "<li class='imgbox'><a href='javascript:void(0)' onclick='clickPic(this)' name='${FileSrc}'>"
			+ '<img id=${RowId} data-original=' + httpPre + '${FileSrc} src=' + httpPre + '${FileSrc} alt=${FileSrc}>'
			+ '</a></li>'
			+ "<div style='text-align:left'>${FileName}</div>";
	// 文件列表展示名称
	var tmpln = "<li><a href='#' id=${RowId} onclick='clickFile(this)' ondblclick='PreviewPdfFiles(this)' src=" + httpPre + "${FileSrc} name='${FileSrc}'>${FileName}</a></li>";

	// 获取选择缩略图的图片地址;
	function GetSrcSelected() {
		var src = '';
		$('#PicsList .selectedpic').each(function() {
			var i = $(this);
			var p = i.find('img');
			src = p.attr('src');
		});
		if (isEmpty(src)) {
			$('#PdfLists .selectedfile').each(function() {
				var i = $(this);
				var p = i.find('a');
				src = p.attr('src');
			});
		}
		return src;
	}
	
	function showPics(data) {
		$('#PicsList').empty();
		$('#showimg').empty();
		$.tmpl(tmpl, data).appendTo('#PicsList');
		$('#PicsList').each(function() {
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
	}

	function showFiles(data) {
		$('#PdfLists').empty();
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
	}

	function GetFileInfo() {
		$('#PicsList').empty();
		$('#PdfLists').empty();
		$('#showimg').attr('src', '');
		$.cm({
			ClassName: 'web.CSSDHUI.CommonFile',
			MethodName: 'GetFileInfo',
			Params: JSON.stringify({ PointerType: gPointerType, Pointer: gPointer, FileType: 'JPG' })
		}, function(jsonData) {
			showPics(jsonData);	// 获取数据展示图片
		});

		$.cm({
			ClassName: 'web.CSSDHUI.CommonFile',
			MethodName: 'GetFileInfo',
			Params: JSON.stringify({ PointerType: gPointerType, Pointer: gPointer, FileType: 'PDF' })
		}, function(jsonData) {
			showFiles(jsonData);	// 获取数据展示文件
		});
	}

	// /图片浏览上传
	$UI.linkbutton('#UpLoadViewPicBT', {
		onClick: function() {
			var Params = JSON.stringify(addSessionParams({ Pointer: gPointer, PointerType: gPointerType }));
			uploader.setParams(Params);
			uploader.upload();
		}
	});
		
	$UI.linkbutton('#DeletePicBT', {
		onClick: function() {
			DeletePic();
		}
	});
	function DeletePic() {
		var RowId = GetIdSelected();
		if (isEmpty(RowId)) {
			$UI.msg('alert', '请选择要删除的文件!');
			return;
		}
		var Params = JSON.stringify(addSessionParams({ RowId: RowId }));
		$.cm({
			ClassName: 'web.CSSDHUI.CommonFile',
			MethodName: 'jsDelete',
			Params: Params
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', '删除成功!');
				GetFileInfo();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	function GetIdSelected() {
		var id = '';
		$('#PicsList .selectedpic').each(function() {
			var i = $(this);
			var p = i.find('img');
			id = p.attr('id');
		});
		if (isEmpty(id)) {
			$('#PdfLists .selectedfile').each(function() {
				var i = $(this);
				var p = i.find('a');
				id = p.attr('id');
			});
		}
		return id;
	}

	// 下载文件功能
	$UI.linkbutton('#FileDownBT', {
		onClick: function() {
			var FileUrl = GetSrcSelected();
			if (isEmpty(FileUrl)) {
				$UI.msg('alert', '请选择要删除的图片或文件!');
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
	
	$HUI.dialog('#ViewPicWin', {
		onOpen: function() {
			GetFileInfo();
		}
	});
};
$(initViewPicWin);

function clickPic(File) {
	$('#PdfLists').each(function() {
		var i = $(this);
		var p = i.find('li');
		$(p).removeClass('selectedfile');
	});
	FileSrc = File.name;
	var url = httpPre + FileSrc;
	$('#showimg').attr('src', url);
}

function clickFile(File) {
	$('#PicsList').each(function() {
		var i = $(this);
		var p = i.find('li');
		$(p).removeClass('selectedpic');
	});
	FileSrc = File.name;
	$('#showimg').attr('src', '');
}

// 目前只支持pdf预览
function PreviewPdfFiles(File) {
	$('#PicsList').each(function() {
		var i = $(this);
		var p = i.find('li');
		$(p).removeClass('selectedpic');
	});
	$('#showimg').attr('src', '');
	FileSrc = File.name;
	var FileSuffix = FileSrc.split('.')[1];
	if ((FileSuffix !== 'PDF') && (FileSuffix !== 'pdf')) {
		return;
	}
	$HUI.dialog('#ShowPdfWin', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
	var url = httpPre + FileSrc;
	$('#pdfContainer').attr('src', '../scripts/cssd/ExtUX/pdfjs/web/viewer.html?file=' + url + '#page=1');
}

// 图片拍照窗口
var TakePhotoWindow;
var TakePhotoWin = function(PointerType, Pointer) {
	var Params = {
		PointerType: PointerType,
		Pointer: Pointer
	};
	Params = JSON.stringify(addSessionParams(Params));
	if ((!TakePhotoWindow) || (TakePhotoWindow.closed)) {
		var lnk = 'cssdhui.takepiccommon.csp';
		lnk = lnk + '?Params=' + Params;
		TakePhotoWindow = window.open(lnk, 'take_photo', 'height=600,width=800,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=yes,location=no, status=yes');
	} else {
		TakePhotoWindow.SetType(Params);
		TakePhotoWindow.focus();
	}
};