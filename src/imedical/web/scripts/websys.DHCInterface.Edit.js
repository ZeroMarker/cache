var cls = "websys.DHCInterface";
var createParamsTbl = function(params,paramsChange){
	if (params!==""){
		var html=[];
		if (paramsChange) {
			html.push("<table><tr><td class='listtitle' style='color:red;'>参数说明(参数有改变)</td><tr><td class='i-tableborder'>");
		}else{
			html.push("<table><tr><td class='listtitle'>参数说明</td><tr><td class='i-tableborder'>");
		}
		
		html.push("<table class='tblList tbllist' cellspacing=0>");
		var arr = params.split(",");
		html.push("<tr><th>参数变量名</th><th>参数描述</th></tr>")
		if (arr.length>0){
			for (var i =0; i<arr.length; i++){
				var t = arr[i].split(":")[0].split("^")[0].split("=")[0];
				html.push("<tr><td>"+t+"</td><td><input data-key='"+t+"' ")
				if(arr[i].split("^").length>1) html.push("value='"+arr[i].split("^")[1]+"'")
				html.push("/></td></tr>")
			}
		}
		html.push("</td></tr></table>")
		html.push("</table>")
		$(".paramstd").html(html.join(""));
	}
}
var MthSelectHandler = function(rowIndex, rowData){
	createParamsTbl(rowData["Params"],false);
	//$("#Params").val(rowData["Params"])
}
var init = function(){
	var initValdate =function(){
		// 通过类型disabled
		var newVal = $("#Type").combogrid("getValue");
		if (newVal=="E"){
			$("#WSDLPath").prop("disabled",true);
			$("#Query").combo("disable");
		}else{
			$("#WSDLPath").prop("disabled",false);
			$("#Query").combo("enable");
		}
		// 参数处理 ,判断维护方法后,入参是否有变化
		var oldParams = $("#Params").val();
		var newParams = $("#NewParams").val();
		var oldParamsArr = oldParams.split(",");
		var newParamsArr = newParams.split(",");
		var Params = [],paramsChange=false,t="",ot="";
		for(var i =0; i<newParamsArr.length; i++){
			var c = ":"; 
			/*param As %String="" => param:%String=""*/
			/*param As %String => param:%String*/
			/*param="" => param=""*/
			if (newParamsArr[i].indexOf(":")>-1) {
				c = ":";
			}else{
				c = "=";
			}
			t = newParamsArr[i].split(c)[0];
			ot="";
			if (i<oldParamsArr.length){
				ot = oldParamsArr[i].split("^")[0];
			}
			if( ot !== t){
				paramsChange = true;
				Params.push(t);
			}else{
				Params.push(oldParamsArr[i]);
			}
		}
		if (newParamsArr.length<oldParamsArr.length){
			paramsChange = true;
		}
		createParamsTbl(Params.join(","),paramsChange);
	}
	$("#Del").click(function(){
		var ID = $("#ID").val();
		$.ajaxRunServerMethod({ClassName:cls,MethodName:"Del",
			ID:ID},
			function(rtn){
				if(parseInt(rtn)>0){
					$.messager.alert("提示","操作成功!");
					opener.$("#Find").click();
				}else{
					$.messager.alert("提示",rtn.split("^")[1]);
				}
			}
		);
	});	
	$("#Update").click(function(){
		var ID = $("#ID").val();
		var Code = $("#Code").val();
		var Caption = $("#Caption").val();
		var Model = $("#Model").val();
		var SubPath = $("#SubPath").val();
		var Mth = $("#Mth").combogrid("getValue");
		var Cls = $("#Cls").combogrid("getValue");
		var Note = $("#Note").val();
		var Query = $("#Query").combogrid("getValue");
		var Source = $("#Source").val();
		var WSDLPath = $("#WSDLPath").val();
		var RunTimeout = $("#RunTimeout").val();
		// 组织参数值
		var Params = "";
		$(".tbllist input").each(function(ind,itm){
			var t = $(itm);
			if (Params!==""){ Params += ",";}
			Params += t.data("key") + "^" + t.val() ;
		});
		//var Params = $("#Params").val();
		var Type = $("#Type").combogrid("getValue");
		var AllowWSInvoke = "off";
		if ($("#AllowWSInvoke").prop("checked")){
			AllowWSInvoke = "on";
		}
		var DisableFilterVal = "off";
		if ($("#DisableFilter").prop("checked")){
			DisableFilterVal = "on";
		}
		var EnableTransactionVal = "off";
		if ($("#EnableTransaction").prop("checked")){
			EnableTransactionVal = "on";
		}
		var EnableLogVal = "off";
		if ($("#EnableLog").prop("checked")){
			EnableLogVal = "on";
		}
		var NotUpdateTimeoutVal = "off";
		if ($("#NotUpdateTimeout").prop("checked")){
			NotUpdateTimeoutVal = "on";
		}
		var GrantPathsVal = "";
		$("#GrantPaths option:selected").each(function(){
 			GrantPathsVal +="^"+$(this).val();
 		})
 	
		$.ajaxRunServerMethod({ClassName:cls,MethodName:"Save",
			ID:ID,Code:Code,Caption:Caption,Cls:Cls,Mth:Mth,Model:Model,Query:Query,Note:Note,Source:Source,
			WSDLPath:WSDLPath,Params:Params,AllowWSInvoke:AllowWSInvoke,
			Type:Type,SubPath:SubPath,GrantPaths:GrantPathsVal,
			DisableFilter:DisableFilterVal,
			RunTimeout:RunTimeout,
			EnableTransaction:EnableTransactionVal,
			EnableLog:EnableLogVal,
			NotUpdateTimeout:NotUpdateTimeoutVal
			},
			function(rtn){
				if(parseInt(rtn)>0){
					$.messager.alert("提示","操作成功!");
					opener.$("#Find").click();
				}else{
					$.messager.alert("提示",rtn.split("^")[1]);
				}
			}
		);

	});
	$("#Type").combogrid({onChange:function(newVal,oldVal){
		initValdate();
	}});
	$("#Cls").combogrid({onChange:function(newVal,oldVal){
		$("#Mth").combogrid("setValue","");
		var g1 =$("#Mth").combogrid("grid");
		g1.datagrid("load");
		$("#Query").combogrid("setValue","");
		var g2 =$("#Query").combogrid("grid");
		g2.datagrid("load");
	}});	
	$("#WSDLPath").on("keydown",function(evt){
		if (evt.keyCode==13){
			$.ajaxRunServerMethod({ClassName:cls,MethodName:"GetServiceClsName",
				wsdl:$("#WSDLPath").val()},
				function(rtn){
					$("#Cls").combogrid("setValue",rtn);
					$.messager.alert("提示","成功生成代理类:"+rtn+",请选择方法.");
				}
			);
		}
	});
	/*$("#Cls").combogrid("options").onChange=function(newVal,oldVal){
		alert(newVal);
	};*/
	initValdate();
}
$(init);