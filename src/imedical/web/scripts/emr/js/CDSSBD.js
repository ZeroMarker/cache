var cdssFlag = false;
function CDSSBD(){
	this.init=function(){
		if(cdssFlag) return
		var CDSSDiv=document.createElement("div");
		CDSSDiv.setAttribute("id","myWinCDSS");
		CDSSDiv.setAttribute("overflow","hidden");
		document.body.appendChild(CDSSDiv);
		CDSSDiv.style.top=300;
		CDSSDiv.style.left=1100;
		CDSSDiv.style.width=460;
		CDSSDiv.style.height=500;
		$("#myWinCDSS").dialog({
			title:'智能诊断',
			content:'<iframe id="myCDSS" name="myCDSS" src="emr.baidu.cdss.csp" frameborder="0" title="" border="false" style="height:99%;width:100%;"></iframe >'
		})
		$("#myWinCDSS").dialog("close");
		cdssFlag = true;
	}
	this.getData=function(param,actionType){
		var _this=this;
		var action=actionType.toUpperCase();
		if(action==="DELETE") return
		var docId = param.emrDocId	
		var instanceID = param.id
		var param="AEpisodeID:"+episodeID+",AUserLocID:"+userLocID+",AUserID:"+userID+",AInstanceID:"+param.id+",ADocID:"+docId+",AAction:"+action+",AType:"+episodeType+",ACdssTool:CDSSBD"
		jQuery.ajax({
		type: "get",
		dataType: "json",
		url: '../EMRservice.BOCDSSService.cls',
		async: false,
		data: {
			"action":"GetCDSSData",
			"param":param
		},
		success: function(d) {
			if(d.success==1){
				
				var cdss_data=d.message;
				/// 调用CDSS函数，刷新智能辅助诊断页面
				var iframe =document.getElementById("myCDSS"); 
				if (iframe.attachEvent) { 
					iframe.attachEvent("onload", function() {
						$("#myCDSS")[0].contentWindow.InvokeCDSS(cdss_data)
					}); 
				} else { 
					iframe.onload =function() { 
						$("#myCDSS")[0].contentWindow.InvokeCDSS(cdss_data)
					};
				}
				if(typeof iframe.contentWindow.InvokeCDSS != "undefined"){
					$("#myWinCDSS").dialog('open');
					iframe.contentWindow.InvokeCDSS(cdss_data);
				}
			}
		},
		error : function(d) { HISAlert("CDSSBD error","提示信息");}
	});
	}
}