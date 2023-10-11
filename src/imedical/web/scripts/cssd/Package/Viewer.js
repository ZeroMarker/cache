var FtpParamObj = GetAppPropValue('CSSDFTPFILEM');
var httpHref = window.location.href;
var httpPre = 'http://';
if (httpHref.indexOf('https') >= 0) {
	httpPre = 'https://';
}
var gPackageId;
function ViewPic(PackageId) {
	$('#PkgId').val(PackageId);
	gPackageId = PackageId;
	$HUI.dialog('#ViewPic', {
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
			GetFileInfo(gPackageId);
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
		uploader.callback = function(Params) {
			
		};
	}('#AddViewPicBT', '#PicsList'));
	var tmpl = "<li class='imgbox'><a href='javascript:void(0)' onclick='clickPic(this)' name='${ImgSrc}'>"
				+ '<img id=${RowId} data-original=' + httpPre + FtpParamObj.FtpHttpSrc + '${ImgSrc} src=' + httpPre + FtpParamObj.FtpHttpSrc + '${ImgSrc} alt=${ImgSrc}>'
				+ '</a></li>'
				+ "<div style='text-align:left'>${FileName}</div>";	// 图片展示名称
	// 文件列表展示名称
	var tmpln = "<li><a href='#' onclick='clickFile(this)' id=${RowId} ondblclick='PreviewPdfFiles(this)' name='${ImgSrc}'>&nbsp;${FileName}</a></li>";
	// 获取选择缩略图的图片地址
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
		// $("#largeImg").empty();
		$('#showimg').empty();
		$.tmpl(tmpl, data).appendTo('#PicsList');
		$('#PicsList').each(function() {
			var i = $(this);
			var p = i.find('li');
			var l = p.find('img');
			var srci = l.attr('src');
			$('#showimg').attr('src', srci);
			p.click(function() {
				if ($(this).hasClass('selectedpic')) {
					$(this).removeClass('selectedpic');
				} else {
					$(this).addClass('selectedpic').siblings('li').removeClass('selectedpic');
				}
				var imgsrc = GetSrcSelected();
				// $("#showimg").css("background-image","url("+imgsrc+")").css(" background-repeat","no-repeat").css('background-size','100% 100%');
				$('#showimg').attr('src', imgsrc);
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
	function GetFileInfo(PkgId) {
		$('#PicsList').empty();
		$('#PdfLists').empty();
		$('#showimg').attr('src', '');
		$.cm({
			ClassName: 'web.CSSDHUI.PackageInfo.Package',
			MethodName: 'GetPkgImgInfo',
			PkgId: PkgId,
			Type: 'JPG'
		}, function(jsonData) {
			showPics(jsonData);	// 获取数据展示图片
		});
		
		$.cm({
			ClassName: 'web.CSSDHUI.PackageInfo.Package',
			MethodName: 'GetPkgImgInfo',
			PkgId: PkgId,
			Type: 'PDF'
		}, function(jsonData) {
			showFiles(jsonData);	// 获取数据展示文件
		});
	}
	// /图片浏览上传功能点击实现
	// /图片浏览上传功能，点击添加图片按钮弹出框效果
	$UI.linkbutton('#UpLoadViewPicBT', {
		onClick: function() {
			var PkgId = $('#PkgId').val();
			var PkgDesc = $('#PkgDesc').val();
			var PkgInfo = { PkgId: PkgId, PkgDesc: PkgDesc, Type: 'Package' };
			var Params = JSON.stringify(addSessionParams(PkgInfo));
			uploader.setParams(Params);
			uploader.upload();
		}
	});
	
	$('#DeletePicBT').on('click', DeletePic);
	function DeletePic() {	// 删除图片
		var PkgId = $('#PkgId').val();
		var ImgId = GetIdSelected();
		if (isEmpty(ImgId)) {
			$UI.msg('alert', '请选择要删除的图片或文件!');
			return;
		}
		var DelParams = JSON.stringify(addSessionParams({ PkgId: PkgId, Type: 'Package' }));
		$.cm({
			ClassName: 'web.CSSDHUI.PackageInfo.Package',
			MethodName: 'jsDelPkgImg',
			ImgId: ImgId,
			Params: DelParams
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', '删除成功!');
				$('#PicsList').empty();
				$('#showimg').attr('src', '');
				GetFileInfo(PkgId);
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
				// FileUrl 文件路径是全局变量，点击选中文件的时候进行赋值
				if (FileUrl === '' || FileUrl === undefined) {
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
	$HUI.dialog('#ViewPic', {
		onOpen: function() {
			GetFileInfo(gPackageId);	// //获取消毒对应的图片\文件
		}
	});
};
$(initViewPicWin);

function clickFile(File) {
	$('#PdfLists').each(function() {
		var i = $(this);
		var p = i.find('li');
		$(p).removeClass('selectedfile');
	});
	FileSrc = File.name;
	var url = httpPre + FileSrc;
	$('#showimg').attr('src', url);
}

function clickPic(File) {
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
	var url = httpPre + FtpParamObj.FtpHttpSrc + FileSrc;
	$('#pdfContainer').attr('src', '../scripts/cssd/ExtUX/pdfjs/web/viewer.html?file=' + url + '#page=1');
}

