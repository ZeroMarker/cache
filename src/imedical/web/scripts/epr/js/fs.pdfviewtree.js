// const app = {
// 	pdfDoc: {},
// 	curPdf: null,
// 	curIndex: 1,
// 	curPage: null
// }
const tagMeta = {
	oldIndex: 0,
	curIndex: 0,
	isDelete: false
}


//在初始化的时候需要修改水印相关信息，在每次加载的时候，还原展示信息
const viewMeta = 
{
	zoom: 1.34,
	degreen: 0,
	watermark:{
		font:"14px 黑体",//字体大小与样 14px 黑体
		fillText:"仅供参考",//水印文本 仅供参考
		color:"rgba(255,0,0,0.5)",//颜色 rgba(0,255,255,0.3)
		textAlign:"left",//向那个方向倾斜 left
		parttern:"repeat",//水印模式 repeat
		rotate:-18 * Math.PI / 180 //旋转部分
	}
}


const pdfBasicInfo = {
	curPdfIndex:0,
	curPdf:null,
	oldPath:"",
	newPath:""
};

const itemDetailInfo = 
{
	curNode:null,
	preNode:null,
	nextNode:null
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
		$('#tt').tree({
			url:'../DHCEPRFS.web.eprajax.AjaxConfigMRViewItem.cls?EpisodeID='+EpisodeID+"&DataServiceUrl="+DataServiceUrl
		});
		LoadEvent();
	});
}(window));
//事件绑定
function LoadEvent() {
	$('#tt').tree({
            onClick: function(node){
				$('#tt').tree('toggle', node.target);
                if(node.children==null)
                {
                     pdfBasicInfo.newPath = node.attributes.url;
                     if(pdfBasicInfo.oldPath!=pdfBasicInfo.newPath)
                     {
						 itemDetailInfo.curNode = node.target;
						 if(node.target.parentNode.previousElementSibling!=null)
						 {
							let preNode = node.target.parentNode.previousElementSibling.children[0];
							if(preNode==null && !preNode.classList.contains('tree-node')) 
						 	{
							 	itemDetailInfo.preNode=null;
						 	}
						 	else
						 	{
							 	itemDetailInfo.preNode = preNode;
						 	}
						 }
						 else
						 {
							 itemDetailInfo.preNode = null;
						 }
						 
						 if(node.target.parentNode.nextElementSibling!=null)
						 {
							let nextNode = node.target.parentNode.nextElementSibling.children[0];
						 	if(nextNode==null && !nextNode.classList.contains('tree-node'))
						 	{
								itemDetailInfo.nextNode = null;
							}
							else
							{
								itemDetailInfo.nextNode = nextNode;
							}
						 }
						 else
						 {
							 itemDetailInfo.nextNode = null;
						 }
						 
						 
                         pdfBasicInfo.oldPath =pdfBasicInfo.newPath;
                         GetDoc2(pdfBasicInfo.oldPath);
                     }
                }
            }
        });
	$('.mrlist-item').click(function() {
		var curItemIndex=$(this).parent().index();
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
	$('#search-reason').keydown(function(e){
		if(e.keyCode==13)
		{
			console.log(111);
			search();
		}
	})
}
//切换PDF
function ChangeItem(itemIndex){
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
function GetDoc(itemIndex){
	var fileName = FSPDFView.FileInfo[itemIndex].ItemDesc;
	var fileUrl = FSPDFView.FileInfo[itemIndex].FilePath;
	if(fileName in app.pdfDoc){
		app.curPdf = app.pdfDoc.name;
		app.curPdf.getPage(app.curIndex).then(function(page){
			app.curPage = page;
			renderPage();
		})
	}
	else{
		var loadingTask = pdfjsLib.getDocument({ url: fileUrl,cMapUrl: ".././scripts/epr/pdfjs-2.2.228-dist/web/cmaps/",cMapPacked: true});
		//var loadingTask = pdfjsLib.getDocument(fileUrl);
			loadingTask.promise.then(function(pdf){
			app.pdfDoc.name = fileName;
			app.curPdf = pdf;
			app.curPdf.getPage(app.curIndex).then(function(page){
				app.curPage = page;
				renderPage();
			})
		})
	}
}
	
	
function GetDoc2(fileUrl)
{
	viewMeta.degreen = 0;
	//viewMeta.zoom = 1;
	pdfBasicInfo.curPdfIndex = 1;
	var loadingTask = pdfjsLib.getDocument(fileUrl);
	loadingTask.promise.then(function(pdf){
		pdfBasicInfo.curPdf = pdf;
		renderPage();
		});
}
 
//渲染页面
function renderPage () {
	pdfBasicInfo.curPdf.getPage(pdfBasicInfo.curPdfIndex).then(function(page){
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
				viewport:viewport
			}).promise.then(function() {
				renderWatermark();  //加水印
			})
			$('#tstbPageNum').val(pdfBasicInfo.curPdfIndex);
			document.getElementById('tslTotalPage').innerHTML = '第' + pdfBasicInfo.curPdfIndex + '页/共' + pdfBasicInfo.curPdf._pdfInfo.numPages + '页';
		});
}
//渲染水印, 平铺水印
function  renderWatermark () {
	let canvas = document.querySelector('#pdfCanvas');
	let ctx = canvas.getContext('2d');
	let water = document.createElement('canvas');
	water.width = 200;
	water.height = 200;
	let waterCtx = water.getContext('2d');
	waterCtx.rotate(viewMeta.watermark.rotate);
	waterCtx.font = viewMeta.watermark.font;
	waterCtx.fillStyle = viewMeta.watermark.color;
	waterCtx.textAlign = viewMeta.watermark.textAlign;
	waterCtx.textBaseline = 'middle';
	waterCtx.fillText(logID, 50, 50);
	let pattern = ctx.createPattern(water,viewMeta.watermark.parttern);
	ctx.rect(0,0,canvas.width,canvas.height);
	ctx.fillStyle = pattern;
	ctx.fill();
}

//跳转页数
function ChangePage(){
	var pageNumStr = $('#tstbPageNum').val();
	if(isNaN(pageNumStr)) {
		alert('请输入数字');
		return;
	}
	var pageNum = parseInt(pageNumStr);
	if (pageNum <= 0) pageNum = 1;
	if (pageNum > apdfBasicInfo.curPdf._pdfInfo.numPages) pageNum = app.curPdf._pdfInfo.numPages;
	if(curPdfIndex == pageNum) return;
	pdfBasicInfo.curPdfIndex = pageNum;
	renderPage();
}
//上一页
function Pre(){
	if(pdfBasicInfo.curPdfIndex == 1) 
	{
		if(itemDetailInfo.preNode!=null)
		{
			itemDetailInfo.nextNode = itemDetailInfo.curNode;
			itemDetailInfo.curNode = itemDetailInfo.preNode;
			if(itemDetailInfo.curNode.parentNode.previousElementSibling!=null)
			{
				let preNode = itemDetailInfo.curNode.parentNode.previousElementSibling.children[0];
				if(preNode==null && !preNode.classList.contains('tree-node')) 
				{
					itemDetailInfo.preNode=null;
				}
				else
				{
					itemDetailInfo.preNode = preNode;
				}
			}
			else
			{
				itemDetailInfo.preNode = null;
			}			 
			itemDetailInfo.curNode.click();


		}
		return;
	}
	pdfBasicInfo.curPdfIndex--;
	renderPage();
}
//下一页
function Next() {
	if(pdfBasicInfo.curPdfIndex == pdfBasicInfo.curPdf._pdfInfo.numPages)
	{
		if(itemDetailInfo.nextNode!=null)
		{
			itemDetailInfo.preNode = itemDetailInfo.curNode;
			itemDetailInfo.curNode = itemDetailInfo.nextNode;
			if(itemDetailInfo.curNode.parentNode.nextElementSibling!=null)
			{
				let nextNode = itemDetailInfo.curNode.parentNode.nextElementSibling.children[0];
				if(nextNode==null && !nextNode.classList.contains('tree-node'))
				{
					itemDetailInfo.nextNode = null;
				}
				else
				{
					itemDetailInfo.nextNode = nextNode;
				}
			}
			else
			{
				itemDetailInfo.nextNode = null;
			}
			itemDetailInfo.curNode.click();
		}
		return;
	}
	pdfBasicInfo.curPdfIndex++;
	renderPage();
}
//放大
function ZoomIn() {
	if(viewMeta.zoom >= 2) return;
	viewMeta.zoom += 0.2;
	renderPage();
}
//缩小
function ZoomOut() {
	if(viewMeta.zoom == 0.4) return;
	viewMeta.zoom -= 0.2;
	renderPage();
}
//顺时针旋转
function RotateCW() {
	viewMeta.degreen += 90;
	renderPage();
}
//逆时针旋转
function RotateACW() {
	viewMeta.degreen -= 90;
	renderPage();
}


//获取选中的
function getChecked(){
        
	var nodes = $('#tt').tree('getChecked');
	var s = '';
	for(var i=0; i<nodes.length; i++){
		if(nodes[i].children==null)
		{
			if (s != '') s += ',';
			s += nodes[i].text;
		}
		
	}
	return s;
}

//搜索
function search(){
	var value = $('#search-reason').val();
	var search_content = $.trim(value);
	var parentNode=$('#tt').tree("getRoots"); //得到tree顶级node
	$(".tree-node-searched").removeClass("tree-node-searched");
	if(search_content == ""){
		$("#tt").tree("expandAll"); //展开所有
		$("#searchResult").html("未输入查询条件");
	}else{
		$("#tt").tree("collapseAll"); //折叠所有
		searchTree(parentNode, search_content);
	}
}							

function searchTree(parentNode,searchCon){
	var children;
	var matchedNodeList = [];
	for(var i=0;i<parentNode.length;i++){ //循环顶级 node
		children = $("#tt").tree("getChildren",parentNode[i].target);//获取顶级node下所有子节点
		if(children){ //如果有子节点
			for(var j = 0 ; j < children.length ; j++){ //循环所有子节点
				if(children[j].text.indexOf(searchCon)>=0){ //判断节点text是否包含搜索文本
					expandParent(children[j]);
					matchedNodeList.push(children[j]);
				}
			}
		}
		/**if(parentNode[i].text.indexOf(searchCon)>=0){
			expandParent(parentNode[i]);
			matchedNodeList.push(parentNode[i]);
		}*/
	}
	$("#searchResult").html("查询到"+matchedNodeList.length+"条结果");
	for (var i=0; i<matchedNodeList.length; i++) {
		showMatchedNode(matchedNodeList[i]);
	}
	if(matchedNodeList.length == 0){
		$("#orgTree").tree("expandAll"); //展开所有
	}
};

//展开匹配结果的父节点
function expandParent(node){
	var parent = node;
	var t = true;
	do {
		parent = $("#tt").tree("getParent",parent.target); //获取此节点父节点
		if(parent){ //如果存在
			t=true;
			$("#tt").tree("expand",parent.target);
		}else{
			t=false;
		}
	}while (t);
};

//高亮显示匹配结果
function showMatchedNode(node) {//展示所有父节点
	$(node.target).show();
	$(".tree-title", node.target).addClass("tree-node-searched");
}
