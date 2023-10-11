$(function(){
	loadDocument({id:recordID,emrVersion:emrVersion});
	function loadDocument(obj){
		var id = obj.id;
		var version = obj.emrVersion;
		var privileges = getPrivilege("BrowsePrivilege",id,version);
		if (!privileges||privileges.canView == "0")
		{
			$(document.body).html('<div id="promptMessage" style="font-size:20px;font-weight:bold;padding:10px 0 0 5px;position:relative;width:100%;height:100%"></div>');
			$("#promptMessage").html('<img style="position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);"  src="../scripts/emr/image/icon/noview.png"  alt="您没有权限查看当前病历" />');
			return;
		}
		ajaxPOSTCommon({
			data:{
				action:"GET_RECORD_HTML",
				params:{
					episodeID:episodeID,
					recordID:id||"",
					emrVersion:version||""
					},
				product:product,
				module:module
			},
			isAsync:false,
			onSuccessRes:function(ret){
				if("true" === ret.success){
                    if (ret.errorCode){
	                     parent.$.messager.alert("数据请求失败提示", ret.errorMessage, "info");
                        showResult("",ret.errorMessage);      
                    }else{
	                    showResult(ret.data.value||"出错啦！");
                    }
					
				}else{
                $.messager.alert("失败", "ajaxPOSTCommon:请求失败", "error");
            	}
			}
			});
		}
		function showResult(result,message){
			var mainDom = document.getElementById("main");
			mainDom.innerHTML="";
			var frame = document.createElement("iframe");
			frame.style.width="100%";
			frame.style.height="100%";
			frame.style.border="none";
			frame.src="";
			frame.id = "content";
			frame.name = "content";
			mainDom.appendChild(frame);
			var newpage = window.frames["content"];
					
			if(!result||result===""||message){
				newpage.document.write("<div style=\"width:500px;margin:0 auto;\">"+(message||"该病历无法解析!")+"</div>");
			}else{
				newpage.document.write(result);	
				}				
		}
	///脚本权限:获取是否能够查看病历的权限
	function getPrivilege(type,instanceId,version)
	{
		var result = "";
		ajaxPOSTCommon({
			data:{
				action:"GET_RECORD_PRIVILEGE",
				params:{
					recordID:instanceId||"",
					episodeID:  episodeID,
					patientID:  patientID,
					userid:userid,
					userloc:userloc,
					ssgroupid:ssgroupid,
					emrVersion:version||""
					},
				product:product,
				module:module
			},
			isAsync:false,
			onSuccess:function(res){
				result = res;
				}
			});
		return result;	
	}
	window.loadDocument = loadDocument;
	})