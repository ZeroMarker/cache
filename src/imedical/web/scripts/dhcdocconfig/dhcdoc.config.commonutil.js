
(function($){
	$.dhc = {
		util : {
			_QUERY_URL : './dhcdoc.config.query.grid.easyui.csp',
			_METHOD_URL : './dhcdoc.config.method.easyui.csp',
			runServerMethod : function(className,methodName,async,callback,objScope,extraArg){
				var params = new Object();
				var ArgCnt=arguments.length-6;
				for (var i=6; i<arguments.length; i++) {
					params["Arg" + (i -5)] = arguments[i];
				}
				params.ClassName = className;
				params.MethodName = methodName;
				params.ArgCnt = ArgCnt;
				$.ajax({
				   type: 'POST',
				   url: this._METHOD_URL,
				   data: params,
				   dataType: 'json',
				   async: async,
				   success: function(data, textStatus, jqXHR){
						callback.call(objScope,data.result, extraArg);
				   },
				   error: function(XMLHttpRequest, textStatus, errorThrown){
						alert(textStatus+"("+errorThrown+")");
				   }
				});
			},
			runServerQuery : function(queryInfo,async, callback, objScope, extraArg){
				var arryArgs = new Array();
				var params = new Object();
				params.ClassName = queryInfo.ClassName;
				params.QueryName = queryInfo.QueryName;
				for(var i = 0; i < queryInfo.ArgCnt ; i ++)
				{
					params["Arg" + (i + 1)] = queryInfo["Arg" + (i + 1)];
				}
				params.ArgCnt = queryInfo.ArgCnt;
				$.ajax({
				   type: 'POST',
				   url: this._QUERY_URL,
				   data: params,
				   dataType: 'json',
				   async: async,
				   success: function(data, textStatus, jqXHR){
						//console.log(data);
						callback.call(objScope,data, extraArg);
				   },
				   error: function(XMLHttpRequest, textStatus, errorThrown){
					   /// alert(XMLHttpRequest.responseText)
						alert(textStatus+"("+errorThrown+")");
				   }
				});
			}
		}
	}
})(jQuery)