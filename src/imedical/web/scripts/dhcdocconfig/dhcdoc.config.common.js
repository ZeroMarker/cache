/**
*医生站EasyUI组件开发公用JS
*郭宝平
*2014-03-05
**/
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
		QUERY_GRID_URL : "./dhcdoc.config.query.grid.easyui.csp",
		QUERY_COMBO_URL : "./dhcdoc.config.query.combo.easyui.csp",
		METHOD_URL : "./dhc.method.easyui.csp"
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