﻿$(function() {
	if (HISUIStyleCode === 'lite') {
		// 极简UI调整按钮"选取文件"按钮(本身是一个div)
		$('#AddViewPicBT').css('height', 28);
		$('.webuploader-pick + div').css('height', 28);
		$('.webuploader-pick').css('border-radius', 2).css('background', '#339EFF').css('padding', '4px 15px 6px 15px');
	}
});

var uploader = null;
var PkgId = null;
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
		if (ret.success === '0') {
			$li.addClass('upload-state-done');
			$UI.msg('success', '上传成功!');
		} else {
			$UI.msg('error', ret.msg);
			$success.text('上传失败!');
		}
		GetPackagePic(PkgId);
		GetPackageFile(PkgId);
		PkgId = null;
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
		PkgId = Params.PkgId;
	};
}('#AddViewPicBT', '#PicsList'));
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
		var lnk = 'cssdhui.takepiccommon.csp';
		lnk = lnk + '?Params=' + Params;
		TakePhotoWindow = window.open(lnk, 'take_photo', 'height=600,width=800,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=yes,location=no, status=yes');
	} else {
		TakePhotoWindow.SetType(Params);
		TakePhotoWindow.focus();
	}
};