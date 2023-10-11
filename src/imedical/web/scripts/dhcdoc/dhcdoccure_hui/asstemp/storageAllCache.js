var storageAllCache=(function(){
	function storage(CacheMapRowIDStr,CacheMapIDStr){
		if (CacheMapRowIDStr!=""){
			var MapStrArry=CacheMapRowIDStr.split("^")
			var MapIDStrArr=CacheMapIDStr.split("^")
			for (var i = 0; i < MapIDStrArr.length; i++) {
				var OneMapID=MapIDStrArr[i]
				var OneMapRowID=MapStrArry[i]
				storageOneCache(OneMapID,OneMapRowID)
			}
		}
	}
	
	function storageOneCache(OneMapID,OneMapRowID){
		var rtnObj = {}
		var arrayObj = new Array(
			new Array(".hisui-radio"),
	      	new Array(".textbox"),
	      	new Array(".hisui-timespinner"),
		  	new Array(".hisui-datetimebox"),
		  	new Array(".hisui-checkbox")
		);
		for( var j=0;j<arrayObj.length;j++) {
			var domSelector=arrayObj[j][0]
			var $nodes=$("#"+OneMapID).find(domSelector)
			for (var i=0; i< $nodes.length; i++){
				var domId = $nodes[i]['id']||"";
				if (domId == "") {
					continue;
				}
				var componentType = "" //getComponentType(domId)
				var isJump=isDisplay=""  //supportJump(componentType);
				var domName = "";
				var _$label = $("label[for="+domId+"]");
				if (_$label.length > 0){
				   domName = _$label[0].innerHTML;
				   isDisplay=$(_$label[0]).css("display");
				}
				if(isDisplay=="none"){
					domName=domName+String.fromCharCode(1)+"Y";
				}
				rtnObj[domId] = domName;
			}
		}
		var domJson = JSON.stringify(rtnObj);
		var responseText = $.m({
				ClassName: "web.DHCDocAPPBL",
				MethodName: "InsertBLItemMulit",
				BLTempRowID:OneMapRowID,domJson:domJson
			},false);
	}
	
	return {
		"storage":storage
	}
})();