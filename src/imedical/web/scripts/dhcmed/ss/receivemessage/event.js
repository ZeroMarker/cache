
function InitViewportEvent(obj)
{	
	var objRec=""
	var objMess = ExtTool.StaticServerObject("DHCMed.SSService.MessageSrv");
	obj.LoadEvent = function(args)
	{
	}
	obj.RecListGrid_rowclick = function()
	{
		var rowIndex = arguments[1];
		objRec = obj.RecListGridStore.getAt(rowIndex);
		obj.MessContent.setValue(objRec.get("Message"));
		if(objRec.get("ReadDate")=="") obj.BtnRead.enable(true);
		else obj.BtnRead.disable(true);
	};
	obj.BtnFind_click = function()
	{
		obj.RecListGridStore.load();
	};
	obj.BtnRead_click = function()
	{
        var ret=objMess.AddReadDateTime(objRec.get("rowid"));
        obj.RecListGridStore.load();
        obj.BtnRead.disable(true);
        obj.MessContent.setValue("");
	};
	obj.IsRead_check = function()
	{
		obj.RecListGridStore.load();
	};
	obj.SendUser_select = function()
	{
		obj.RecListGridStore.load();
	};
}
/*
var Runner = function(){
    var f = function(v, pbar, btn, count, cb){
        return function(){
            if(v > count){
                cb();
            }else{
                    pbar.updateProgress(v/count, 'ÔÄ¶Á ' + v + ' of '+count+'...');
            }
       };
    };
    return {
        run : function(pbar, btn, count, cb){
            var ms = 5000/count;
            for(var i = 1; i < (count+2); i++){
               setTimeout(f(i, pbar, btn, count, cb), i*ms);
            }
        }
    }
}();
*/