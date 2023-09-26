var navPage = window.frames["frameNav"];
var editPage = window.frames["framRecord"];
$(function(){
	initEditor();
	initNavPage();
	initDocument();
});

function initNavPage()
{
	$("#frameNav").attr("src","emr.ip.navigation.csp?EpisodeID="+setting.episodeId +"&CategoryID="+setting.categoryId);	
}

///编辑器///////////////////////////////////////////////////
function initEditor()
{
	$("#framRecord").attr("src","emr.ip.edit.csp?EpisodeID="+setting.episodeId);
}
///打开病历
function operateRecord(param)
{
	$("#nav").css("display","none");
	$("#editor").css("display","block");
	if (window.frames["framRecord"])
	editPage.InitDocument(param);
}
//初始化打开病历
function initDocument()
{
	var iframeRecord = document.getElementById("framRecord");
	if (iframeRecord.attachEvent){ // 兼容IE写法
		iframeRecord.attachEvent("onload", function(){
			// iframe framRecord加载完成后要进行的操作
			if (!window.frames["framRecord"]) return;
			var iframe = editPage.document.getElementById("framRecordTool");
			if (iframe.attachEvent){ // 兼容IE写法
				iframe.attachEvent("onload", function(){
					// iframe framRecordTool加载完成后要进行的操作
					operateRecord(recordParam);
				})
			} else {
				iframe.onload = function(){
					// iframe加载完成后要进行的操作
					operateRecord(recordParam);
				}
			}
		})
	} else {
		iframeRecord.onload = function(){
			// iframe framRecord加载完成后要进行的操作
			if (!window.frames["framRecord"]) return;
			var iframe = editPage.document.getElementById("framRecordTool");
			if (iframe.attachEvent){ // 兼容IE写法
				iframe.attachEvent("onload", function(){
					// iframe framRecordTool加载完成后要进行的操作
					operateRecord(recordParam);
				})
			} else {
				iframe.onload = function(){
					// iframe加载完成后要进行的操作
					operateRecord(recordParam);
				}
			}
		}
	}
}

function gotoNav()
{
	$("#nav").css("display","block");
	$("#editor").css("display","none");
	navPage.init();
	editPage.unLockDocumnet();
	editPage.clearDocument();
}

function gotoEdit()
{
	$("#nav").css("display","none");
	$("#editor").css("display","block");
}

///关闭时有修改提示是否保存
window.onbeforeunload = function()
{
    if ((editPage)&&(editPage.savePrompt("") == "cancel"))
	{
		return '';
	}
}

///修改标题名称
function changeCurrentTitle(title,categoryId)
{
	setting.categoryId = categoryId;
	navPage.changeCategoryId(categoryId);
}
//关闭病历页签(若阻止关闭，则return false)
function onBeforeCloseTab()
{
	if ((editPage)&&(editPage.savePrompt("") == "cancel"))
	{
		return false;
	}
	return true;
}

function showDiaglog(title,width,height,content)
{
	$HUI.dialog('#dialog',{  
	    title: title,  
	    width: width,  
	    height: height,
	    content: content,  
	    closed: true,  
	    cache: false, 
	    isTopZindex:true, 
	    modal: true
	});
	$HUI.dialog('#dialog').open();	
}

function setPrintInfo(flag)
{
	if (flag == "true")
	{
		$.messager.progress({
			title: "提示",
			msg: '正在打印病历',
			text: '打印中....'
		});
	}
	else
	{
		$.messager.progress("close");
	}
}

//平台使用 如果返回false,不切换Chart页签
function chartOnBlur(){
    if (editPage) {
        var editFlag = editPage.savePrompt("");
        if (editFlag == "cancel") {
            return false;
        }else if (editFlag == "unsave") {
            editPage.resetModifyState("","false");
        }
    }
    return true;
}
