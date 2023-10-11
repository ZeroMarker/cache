//为jquery扩展实用方法
/**
*@author: wanghc
*@date: 2014-10-29
*@param: data    object             {ClassName:'',MethodName:'',QueryName:'',dataType:"json"|"text"|..., args}
*@param: success function|boolean   successCallback|async
*
*e.g:  
* $cm({
*  ClassName:"websys.DHCMessageReceiveType",
*  MethodName:"Save",
*  Code:CodeJObj.val(),
*  Desc:DescJObj.val(),
*  Id:ReceiveIdJObj.val()
* },function(){alert("success");})
*or 
* var rtn = $cm({...},false)
*/
function $cm(data,success,error){
	if(!!$ && !$.extend){$ = jQuery; }
	if ("undefined"==typeof $){return false};
	var result,dataType="json";
	if (data["dataType"]){
		dataType = data["dataType"];
	}
	$.ajax({
		url:"websys.Broker.cls",
		data:data,
		type:"post",
		async:success===false?false:true,
		dataType:dataType,
		success:function(rtn){
			if ((typeof rtn=="string") && rtn.indexOf("window.open(\"dhc.bdp.mkblogon.csp?RELOGON=1\",\"RELOGON\",\"toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=no,resizable=no\"")>-1){
				top.window.open("dhc.bdp.mkblogon.csp?RELOGON=1","RELOGON","toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=no,resizable=no");
			}else{
				if (success && success.call) {
					if (rtn.success) rtn.success= parseInt(rtn.success)
					success.call(this,rtn);
				}
				if (success===false) result = rtn;
			}
		},
		error:function(data,textStatus){
			if (typeof error=="function"){
				error.apply(this,arguments);
			}else{
				debugger;
				alert('JQuery: RunClassMethodError !\n'+textStatus); 
			}
		}
	});
	if (success===false) return result;
};
