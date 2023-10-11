
/// 创建HISUI-Dialog弹窗
function createExportDialog(iframeId, iframeContent,callback,arr){
    var dialogId = "dialogExport";
    var dialogTitle = "导出图片";
    var width = "280";
    var height = "150";
    
    if ($("#modalIframe").length<1)
	{
        $("body").append('<iframe id="modalIframe" style="position: absolute; z-index: 1999; width: 100%; height: 100%; top: 0;left:0;scrolling:no;" frameborder="0"></iframe>');
    }
	else
	{
        $("#modalIframe").css("display","block");
    }
    $("body").append("<div id='"+dialogId+"'</div>");
	if (isNaN(width)) width = 800;
	if (isNaN(height)) height = 500;  
    if(document.getElementById("editor")&&(judgeIsIE()==false))
    	document.getElementById("editor").style.visibility="hidden"; //隐藏插件
	var cspIdx = iframeContent.indexOf(".csp");
    if (cspIdx > 0)
    {
	    if (iframeContent.indexOf("?") > 0)
	    {
		    cspIdx = cspIdx + 5;
		    iframeContent = iframeContent.slice(0,cspIdx)+"MWToken="+getMWToken()+"&"+iframeContent.slice(cspIdx);
		}
		else
		{
		    cspIdx = cspIdx + 4;
		    iframeContent = iframeContent.slice(0,cspIdx)+"?MWToken="+getMWToken()+iframeContent.slice(cspIdx);
		}
	}
    var returnValue = "";
    $HUI.dialog('#'+dialogId,{ 
        title: dialogTitle,
        width: width,
        height: height,
        cache: false,
        collapsible: false,
        minimizable:false,
        maximizable:false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        isTopZindex: true,
        content: iframeContent,
        onBeforeClose:function(){
            var tempFrame = $('#'+iframeId)[0].contentWindow;
			if (tempFrame.dialogBeforeClose)
			{
				tempFrame.dialogBeforeClose();
			}
            if (tempFrame && tempFrame.returnValue)
			{
				returnValue = tempFrame.returnValue;
			    if ((returnValue !== "") &&(typeof(callback) === "function"))
				{
                    callback(returnValue,arr);
                }
			}
        },
        onClose:function(){
            $("#modalIframe").hide();
            if(document.getElementById("editor"))
    			document.getElementById("editor").style.visibility="visible"; //隐藏插件
			//$("#"+dialogId).dialog('destroy'); 创建病程病历时，模态窗自动关闭，执行该方法，jquery-1.11.3.min.js报对象不支持此方法，注释即可
			selectedToothObj = "";//关闭dialog框时，将牙位图使用的全局变量清空；此全局变量，在双击牙位图图片打开编辑页面时，将牙位图中的牙位牙面信息传给dialog框 add by niucaicai
        }
    });
}

//关闭dialog,子页面调用
function closeDialog(dialogId)
{
	$HUI.dialog('#'+dialogId).close();
}

//获取Token
function getMWToken(){
	try{
		return websys_getMWToken();
	}catch(e){
		return "";
	}
	
}
