
function InitOESubWindowEvent(obj) {
	obj.LoadEvent = function(args){
		obj.btnQuery.on("click", obj.btnQuery_OnClick, obj);
		obj.cboItemCat.on("expand", obj.cboItemCat_OnExpand, obj);
		obj.cboItemSubCat.on("expand", obj.cboItemSubCat_OnExpand, obj);
	};
	obj.cboItemCat_OnExpand = function(){
		obj.cboItemCatStore.load({});
	}
	obj.cboItemSubCat_OnExpand = function(){
		obj.cboItemSubCatStore.load({});
	}
	obj.btnQuery_OnClick = function()
	{
		obj.gpOeordItemStore.load({});
	}
}

function OeordItemLookUpHeader(EpisodeID)
{
    	var objOESubWindow = new InitOESubWindow(EpisodeID);
        objOESubWindow.OESubWindow.show();
		var numTop=(screen.availHeight-objOESubWindow.OESubWindow.height)/2;
		var numLeft=(screen.availWidth-objOESubWindow.OESubWindow.width)/2;
		objOESubWindow.OESubWindow.setPosition(numLeft,numTop);
        ExtDeignerHelper.HandleResize(objOESubWindow);
}