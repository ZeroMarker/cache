$(function(){
	initKbtree();
	initHistory();
});


function initKbtree()
{
	$("#frameKbtree").attr("src","emr.opdoc.kbtree.csp?EpisodeID="+episodeID+"&flagFirst="+flagFirst+"&VisitType="+visitType+"&MWToken="+getMWToken());	
}

function initHistory()
{
	$("#framHistory").attr("src","emr.opdoc.sectionhistory.csp?EpisodeID="+episodeID+"&MWToken="+getMWToken());	
}

window.onresize = function(){
    location.reload();
};

/// 创建HISUI-Dialog弹窗
function createModalDialog(dialogId, dialogTitle, width, height, iframeId, iframeContent,callback,arr){
	parent.createModalDialog(dialogId, dialogTitle, width, height, iframeId, iframeContent,callback,arr);
}

//关闭dialog,子页面调用
function closeDialog(dialogId)
{
	parent.closeDialog(dialogId);
}