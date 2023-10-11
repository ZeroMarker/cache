const viewMeta = {
	zoom: 1,
	degreen: 0
}
const app = {
	pdfDoc: {},
	curPdf: null,
	curIndex: 1,
	curPage: null
}
const tagMeta = {
	oldIndex: 0,
	curIndex: 0,
	isDelete: false
}
const pdfjsLib = window['pdfjs-dist/build/pdf'];
pdfjsLib.GlobalWorkerOptions.workerSrc = '../scripts/epr/pdfjs-2.2.228-dist/build/pdf.worker.js';

//全局
var FSPDFView = FSPDFView || {
	EpisodeID: '',
	FileInfo: null
};

(function (win) {
	$(function () {
		InitMRCatalogue();
		LoadEvent();
	});
}(window));

function InitMRCatalogue() {
	$.ajax({
		url: '../DHCEPRFS.web.eprajax.AjaxPDFView.cls',
		data: {
			Action: 'pdfpathlist',
			EpisodeID: EpisodeID,
			DataServiceUrl: DataServiceUrl
		},
		type: 'post',
		async: false,
		dataType: 'json',
		success: function(data) {
			if (data.rows.length > 0) {
				InitListItem(data);
			}
		},
		error: function(data) {
			alert('获取病案目录错误');
			return;
		}
	});
}
//初始化
function InitListItem(jsonData) {
	if(jsonData.rows == 0) return;
	FSPDFView.FileInfo = jsonData.rows;
	listHtmlStr = '';
	for (var i = 0;i < FSPDFView.FileInfo.length;i++) {
		var row = FSPDFView.FileInfo[i];
		listHtmlStr += '<li><a href="#" class="mrlist-item">' + row.ItemDesc + '</a></li>'
	}
	$('#mrbottomlist').append(listHtmlStr);
	GetDoc(0);
}
//事件绑定
function LoadEvent() {
	$('.mrlist-item').click(function() {
		var curItemIndex = $(this).parent().index();
		ChangeItem(curItemIndex);
	});
	$('#tstbPageNum').on('keypress', function(event) {
		if (event.keyCode == '13') {
			ChangePage();
		}
	});
	$('#tsbPre').on('click',function() {
		Pre();
	});
	$('#tsbNext').on('click',function() {
		Next();
	});
	$('#tsbZoomIn').on('click',function() {
		ZoomIn();
	});
	$('#tsbZoomOut').on('click',function() {
		ZoomOut();
	});
	$('#tsbRotateCW').on('click',function() {
		RotateCW();
	});
	$('#tsbRotateACW').on('click',function() {
		RotateACW();
	});
}
//切换PDF
function ChangeItem(itemIndex) {
	tagMeta.curIndex = itemIndex;
	if(tagMeta.curIndex == tagMeta.oldIndex) return;
	tagMeta.oldIndex = tagMeta.curIndex;
	$('.mrlist-item').each(function(){
		$(this).parent().removeClass('active');
		if ($(this).parent().index()==itemIndex){
			$(this).parent().addClass('active');
		}
	});
	app.curIndex = 1
	GetDoc(tagMeta.curIndex);
}

//通过url获取pdf并渲染第一页
function GetDoc(itemIndex) {
	var fileName = FSPDFView.FileInfo[itemIndex].ItemDesc;
	var fileUrl = FSPDFView.FileInfo[itemIndex].FilePath;
	if(fileName in app.pdfDoc){
		app.curPdf = app.pdfDoc.name;
		app.curPdf.getPage(app.curIndex).then(function(page) {
			app.curPage = page;
			renderPage();
		})
	}
	else{
		var loadingTask = pdfjsLib.getDocument({ url: fileUrl,cMapUrl: ".././scripts/epr/pdfjs-2.2.228-dist/web/cmaps/",cMapPacked: true});
		//var loadingTask = pdfjsLib.getDocument(fileUrl);
			loadingTask.promise.then(function(pdf) {
			app.pdfDoc.name = fileName;
			console.log();
			app.curPdf = pdf;
			app.curPdf.getPage(app.curIndex).then(function(page) {
				app.curPage = page;
				renderPage();
			})
		})
	}
}
//渲染页面
function renderPage() {
	app.curPdf.getPage(app.curIndex).then(function(page) {
		app.curPage = page;
		let scale = viewMeta.zoom;
		let rotation = viewMeta.degreen;
		let viewport = page.getViewport({scale:scale,rotation:rotation});
		let canvas = document.querySelector('#pdfCanvas');
		canvas.width = 0;
		canvas.height = 0;
		canvas.context = null;
		let ctx = canvas.getContext('2d');
		let w = viewport.width*viewMeta.zoom;
		let h = viewport.height*viewMeta.zoom;
		canvas.width = w;
		canvas.height = h;
		ctx.setTransform(viewMeta.zoom,0,0,viewMeta.zoom,0,0);
		page.render({
			canvasContext: ctx,
			viewport: viewport
		}).promise.then(function() {
			renderWatermark();  //加水印
		})
		$('#tstbPageNum').val(app.curIndex);
		document.getElementById('tslTotalPage').innerHTML = '第' + app.curIndex + '页/共' + app.curPdf._pdfInfo.numPages + '页';
	})
}
//渲染水印, 平铺水印
function renderWatermark() {
	let canvas = document.querySelector('#pdfCanvas');
	let ctx = canvas.getContext('2d');
	let water = document.createElement('canvas');
	water.width = 200;
	water.height = 200;
	let waterCtx = water.getContext('2d');
	waterCtx.rotate(-18 * Math.PI / 180);
	waterCtx.font = '14px 黑体';
	waterCtx.fillStyle = 'rgba(255,0,0,0.5)';
	waterCtx.textAlign = 'left';
	waterCtx.textBaseline = 'middle';
	waterCtx.fillText('仅供参考', 50, 50);
	let pattern = ctx.createPattern(water,'repeat');
	ctx.rect(0,0,canvas.width,canvas.height);
	ctx.fillStyle = pattern;
	ctx.fill();
}

//跳转页数
function ChangePage() {
	var pageNumStr = $('#tstbPageNum').val();
	if(isNaN(pageNumStr)) {
		alert('请输入数字');
		return;
	}
	var pageNum = parseInt(pageNumStr);
	if (pageNum <= 0) pageNum = 1;
	if (pageNum > app.curPdf._pdfInfo.numPages) pageNum = app.curPdf._pdfInfo.numPages;
	if(app.curIndex == pageNum) return;
	app.curIndex = pageNum;
	renderPage();
}
//上一页
function Pre() {
	if(app.curIndex == 1) return;
	app.curIndex--;
	renderPage();
}
//下一页
function Next() {
	if(app.curIndex == app.curPdf._pdfInfo.numPages) return;
	app.curIndex++;
	renderPage();
}
//放大
function ZoomIn() {
	if(viewMeta.zoom >= 2) return;
	viewMeta.zoom += 0.2;
	renderPage(app.curPage);
}
//缩小
function ZoomOut() {
	if(viewMeta.zoom == 0.4) return;
	viewMeta.zoom -= 0.2;
	renderPage(app.curPage);
}
//顺时针旋转
function RotateCW() {
	viewMeta.degreen += 90;
	renderPage(app.curPage);
}
//逆时针旋转
function RotateACW() {
	viewMeta.degreen -= 90;
	renderPage(app.curPage);
}
