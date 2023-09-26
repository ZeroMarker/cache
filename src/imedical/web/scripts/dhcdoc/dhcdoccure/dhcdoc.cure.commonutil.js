var PUBLIC_CONSTANT={
	SESSION:{
		GROUP_ROWID : session['LOGON.GROUPID'],
        GROUP_DESC : session['LOGON.GROUPDESC'],
        GUSER_ROWID : session['LOGON.USERID'],
        GUSER_NAME : session['LOGON.USERNAME'],
        GUSER_CODE : session['LOGON.USERCODE'],
        GCTLOC_ROWID : session['LOGON.CTLOCID']
	},
	URL:{
		QUERY_GRID_URL : "./dhcdoc.cure.query.grid.easyui.csp",
		QUERY_COMBO_URL : "./dhcdoc.cure.query.combo.easyui.csp",
		METHOD_URL : "./dhcdoc.cure.method.easyui.csp"
	}
};
$.extend($.fn.datagrid.defaults.editors, {

    combogrid: {
         init: function(container, options){
            var input = $('<input class="combogrid-editable-input" />').appendTo(container); 
             input.combogrid(options);
             return input;
         },
         destroy: function(target){
             $(target).combogrid('destroy');
         },
         getValue: function(target){
            return $(target).combogrid('getValue');
         },
        setValue: function(target, value){
            $(target).combogrid('setValue', value);
         },
         resize: function(target, width){
             $(target).combogrid('resize',width);
         }
     }

 });

(function($){
	$.dhc = {
		util : {
			_QUERY_URL : './dhcdoc.cure.query.grid.easyui.csp',
			_METHOD_URL : './dhcdoc.cure.method.easyui.csp',
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