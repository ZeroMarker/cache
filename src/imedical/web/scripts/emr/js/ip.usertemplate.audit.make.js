$(function(){
	initMakePage();
	setButtonStatus();
	init();
})

//初始化模板制作页面的方法
function initMakePage()
{
	setdatabindPage();
	setElementEvent();
	setFontData();
	setFontSizeData();
	initKBCateTree();
	initKBTreeMenu();
}

//设置按钮状态
function setButtonStatus()
{
	$('#btnAdd').hide();
	$('#btnCommit').hide();
}

//
function init()
{
	model = {
		"id":UserTempCode,
		"TemplateVersionId":TemplateVersionId,
		"TemplateType":"department",
		"node":{
			"id":"user^"+UserTempId,
			"attributes":{
				"Code":UserTempCode,
				"TemplateVersionId":TemplateVersionId,
				"nodetype":"leaf",
				"Status":"0"
			}
		}
	}
	openTemplate();
	$("#setPropty").accordion('select', '章节属性');
}