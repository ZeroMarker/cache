var cdssFlag = false;

function CDSSTFZW(){
	this.init=function(){
		 var win = websys_getMenuWin();  // 获得顶层框架window对象
		 
		 tocdss = win.getWebsysToCDSS('cnki');
         
         var cdss = win.getWebsysCDSS('cnki');
		 cdss.listen(function (msg) {
		  // 得到cdss消息
		  if (msg != undefined && msg != "" && msg != "undefined"){
		    msg = JSONparse(msg);
		    var type = msg.type;
		    var value = JSONstringify(msg.jsonData);
		  }
		});
		
	}
	
	this.getData=function(param,actionType){
		var _this=this;
		var action=actionType.toUpperCase();
		if(action==="DELETE") return
		var docId = param.emrDocId	
		var instanceID = param.id

		jQuery.ajax({
		type: "get",
		dataType: "json",
		url: '../EMRservice.Ajax.common.cls',
		async: false,
		data: {
			"OutputType":"Stream",
			"Class":"DHCDoc.Interface.Inside.TFZWCDSS",
			"Method":"KnowledgeBase",
			"p1":episodeID,
			"p2":userID,
			"p3":userLocID,
			"p4":setting.hospitalID
		},
		success: function(d) {
			
		 	tocdss.targets["CNKI_CDSS"].send(JSON.stringify(d));
		        
			
		},
		error : function(d) { 
			console.log(d)
			HISAlert("CDSSTFZW error","提示信息");
		}
	});
	}
}