Ext.BLANK_IMAGE_URL='../scripts_lib/ext3.2.1/resources/images/default/s.gif';
Ext.QuickTips.init();
//Ext.form.Field.prototype.msgTarget="side";
//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
var ExtTool = new Object();

// 重载 Ext.data.Store.prototype.applySort 函数以修复 DataStore 对汉字排序异常的问题    
// var _applySort = Ext.data.Store.prototype.applySort;            
//如有需要，保存原 applySort 函数的引用    
Ext.data.Store.prototype.applySort = function(){ //重载 applySort    
    if (this.sortInfo && !this.remoteSort) {
        var s = this.sortInfo, f = s.field;
        var st = this.fields.get(f).sortType;
        var fn = function(r1, r2){
            var v1 = st(r1.data[f]), v2 = st(r2.data[f]);
            // 添加:修复汉字排序异常的Bug    
            if (typeof(v1) == "string") { //若为字符串，    
                return v1.localeCompare(v2);//则用 localeCompare 比较汉字字符串, Firefox 与 IE 均支持    
            }
            // 添加结束    
            return v1 > v2 ? 1 : (v1 < v2 ? -1 : 0);
        };
        this.data.sort(s.direction, fn);
        if (this.snapshot && this.snapshot != this.data) {
            this.snapshot.sort(s.direction, fn); 
        }  
    }
};
Ext.grid.CheckColumn = function(config){
    Ext.apply(this, config);
    if(!this.id){
        this.id = Ext.id();
    }
    this.renderer = this.renderer.createDelegate(this);
};

Ext.grid.CheckColumn.prototype ={
    init : function(grid){
        this.grid = grid;
        this.grid.on('render', function(){
            var view = this.grid.getView();
            view.mainBody.on('mousedown', this.onMouseDown, this);
        }, this);
    },

    onMouseDown : function(e, t){
        if(t.className && t.className.indexOf('x-grid3-cc-'+this.id) != -1){
            e.stopEvent();
            var index = this.grid.getView().findRowIndex(t);
            var record = this.grid.store.getAt(index);
            record.set(this.dataIndex, !record.data[this.dataIndex]);
            record.commit();
        }
    },

    renderer : function(v, p, record){
        p.css += ' x-grid3-check-col-td'; 
        return '<div class="x-grid3-check-col'+(v?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
    }
};



ExtTool.GetHttpRequest = function() 
{
    var ajaxHttpRequest = null;
    if (window.XMLHttpRequest) { //Mozilla, Opera, ...
        ajaxHttpRequest = new XMLHttpRequest();
        if (ajaxHttpRequest.overrideMimeType) {
            ajaxHttpRequest.overrideMimeType("text/xml");
        }
    }
    else if (window.ActiveXObject) { //IE
        try {
            ajaxHttpRequest = new ActiveXObject("Msxml2.XMLHTTP");
        }
        catch (e) {
            try {
                ajaxHttpRequest = new ActiveXObject("Microsoft.XMLHTTP");
            }
            catch (e) {
            }
        }
    }
    if (!ajaxHttpRequest) {
        throw new Error(999,"Fail to init AJAX");
    }
    return ajaxHttpRequest;
};

ExtTool.RunServerMethod = function(ClassName,MethodName) {
    //var objMethodSign = document.getElementById("MethodRunClassMethod");
    var strMethodSign = ExtTool.MethodSignature;
    /*if(objMethodSign == null)
    {
        	Ext.Msg.show({
					   title: '程序运行错误',
					   buttons: Ext.MessageBox.OK,
					   icon: Ext.MessageBox.ERROR
					});
					return null;
    }
    else
    {
    		strMethodSign = objMethodSign.value;
    }*/
    var strExpression = "var strResult = cspRunServerMethod(strMethodSign,ClassName,MethodName";
    for(var i = 2; i < arguments.length; i ++)
    {
			strExpression += ",arguments[" + i + "]"
    }
    strExpression += ");"
    eval(strExpression);
    if (strResult != null) {
        if (strResult.indexOf("<RESULT>OK</RESULT>") == 0)
        {
        	strResult = strResult.replace("<RESULT>OK</RESULT>", "");
        	if(strResult.indexOf("<ResultObject>") == 0)
        	{
        		strResult = strResult.replace("<ResultObject>", "");
        		eval(strResult);
        		return objTmp;
        	}
        	else
        	{
        		return strResult;
        	}
        }
        else
        {	
        	Ext.Msg.show({
					   title: '程序运行错误',
					   msg: "<div style='overflow:scroll;height=300px;width:500px;text-align:left'>"+strResult+"</div>",
					   buttons: Ext.MessageBox.OK,
					   icon: Ext.MessageBox.ERROR
					});
        	throw new Error(9999, strResult);
        }
    }
    else {
    	//window.location.reload(true);
    	/**/
    		var strMsg = strResult + "<BR/>";
    		strMsg += "调用类：" + ClassName + "<BR/>";
    		strMsg += "调用类方法：" + MethodName + "<BR/>";
    		for(var i = 2; i < arguments.length; i ++)
    		{
    			strMsg += "参数" + i + "：‘" + arguments[i] + "’<BR/>";
    		}
    		Ext.Msg.show({
					   title: '程序运行错误',
					   msg: "<div style='overflow:scroll;height=300px;width:500px;text-align:left'>"+strMsg+"</div>",
					   buttons: Ext.MessageBox.OK,
					   icon: Ext.MessageBox.ERROR
					});
        throw new Error(500, strMsg);
        
    }

};

ExtTool.RunServerMethod1 = function(ClassName,Method,Args)
{
	var strExp = "var ret=ExtTool.RunServerMethod(ClassName,Method";
	for(var i = 0; i < Args.length; i ++)
	{
		strExp += ",Args[" + i + "]"
	}
	strExp += ");"
	eval(strExp);
	return ret;
}

ExtTool.GetMethodSignature = function() {
    var objRequest = ExtTool.GetHttpRequest();
    var strURL = "./csp/web.DHCHM.ClassMethodServiceHelper.cls";

    objRequest.open("POST", strURL, false);
    objRequest.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    var strArg = "?a=a&Rnd=" + Math.random();
    objRequest.send(strArg);
    if (objRequest.status == 200) {
        return objRequest.responseText;//.replace("\r\n", "");
    }
    else {
        throw new Error(500, objRequest.responseText);
    }

};

ExtTool.StaticServerObject = function(ClassName) {
	var strResult = ExtTool.RunServerMethod("web.DHCHM.ClassMethodService", "StaticObject", ClassName);
	eval(strResult);
	return objTmp;
	
};

//向下拉框中增加项目
//objCbo:需要增加内容的下拉框
//Display:显示的内容
//Value对应的值（也就是Rowid）
ExtTool.AddComboItem = function(objCbo, Display, Value)
{
   objStore = objCbo.initialConfig.store; 
   var strExp="var rec = new Ext.data.Record({" + 
          objCbo.initialConfig.valueField + ": Value," +
          objCbo.initialConfig.displayField + ": Display});"
   eval(strExp);
   objStore.add([rec]);
   objCbo.setValue(Value);
}

ExtTool.ReplaceText = function(str, find, repl)
 {
 	var strTmp = str;
 	while(strTmp.indexOf(find) >=0)
 	{
 		strTmp = strTmp.replace(find, repl);	
 	}	
 	return strTmp;
 }
/*
ICON:
Ext.MessageBox.ERROR
Ext.MessageBox.INFO
Ext.MessageBox.QUESTION
Ext.MessageBox.WARNING

Button:
Ext.MessageBox.CANCEL
Ext.MessageBox.OK
Ext.MessageBox.OKCANCEL
Ext.MessageBox.YESNO
Ext.MessageBox.YESNOCANCEL
Ext.MessageBox.YESNOCANCEL

fn:
(example)
function(btn, text){
    if (btn == 'ok'){
        // process text value and close...
    }
*/
ExtTool.alert = function(title, message, icon, button, fn)
{
    Ext.Msg.show({
			  title: title,
				msg: message,
				buttons: (button == null ? Ext.MessageBox.OK : button),
				icon: (icon == null ? Ext.MessageBox.INFO : icon),
				fn : fn
		});	
};


/*
提示用户输入文本
title : String
The title bar text
msg : String
The message box body text
fn : Function
(optional) The callback function invoked after the message box is closed
scope : Object
(optional) The scope (this reference) in which the callback is executed. Defaults to the browser wnidow.
multiline : Boolean/Number
(optional) True to create a multiline textbox using the defaultTextHeight property, or the height in pixels to create the textbox (defaults to false / single-line)
value : String
(optional) Default value of the text input element (defaults to '')
*/
ExtTool.prompt = function(title, message, fn, scope, multiline, defaultValue)
{
	return Ext.MessageBox.prompt(title, message, fn, scope, multiline, defaultValue);
}

/*
Parameters:
title : String
The title bar text
msg : String
The message box body text
fn : Function
(optional) The callback function invoked after the message box is closed
scope : Object
(optional) The scope (this reference) in which the callback is executed. Defaults to the browser wnidow.
*/
ExtTool.confirm = function(title, msg, fn, scope)
{
	Ext.MessageBox.confirm(title, msg, fn, scope);
};

/*
Displays a message box with a progress bar. This message box has no buttons and is not closeable by the user. 
You are responsible for updating the progress bar as needed via Ext.MessageBox.updateProgress 
and closing the message box when the process is complete.

Parameters:
title : String
The title bar text
msg : String
The message box body text
progressText : String
(optional) The text to display inside the progress bar (defaults to '')
*/
ExtTool.progress = function(title, msg, progressText)
{
	Ext.MessageBox.progress(title, msg, progressText);
};

/*
Updates a progress-style message box's text and progress bar. 
Only relevant on message boxes initiated via Ext.MessageBox.progress or Ext.MessageBox.wait, 
or by calling Ext.MessageBox.show with progress: true.

Parameters:
value : Number
Any number between 0 and 1 (e.g., .5, defaults to 0)
progressText : String
The progress text to display inside the progress bar (defaults to '')
msg : String
The message box's body text is replaced with the specified string (defaults to undefined so that any existing body text will not get overwritten by default unless a new value is passed in)
*/
ExtTool.updateProgress = function(value, progressText, msg)
{
	Ext.MessageBox.updateProgress(value, progressText, msg);
};


  //get selected record of a grid
ExtTool.GetGridSelectedData = function(objGrid)
{
    var objSel = objGrid.getSelectionModel();
    var objData = null;
    if(objSel.selections.items.length > 0)
    {
	    objData = objSel.selections.items[0];
    }
	    return objData;
} ;

ExtTool.GetGridAllSelectedData = function(objGrid)
{
    var objSel = objGrid.getSelectionModel();
    var objData = null;
    var arry = new Array();
    if(objSel.selections.items.length > 0)
    {
	    objData = objSel.selections.items[0];
	    arry[arry.length - 1] = objData;
    }
	return arry;
};

ExtTool.SelectAllGridItem = function(objGrid, selStatus) {
    var objStore = objGrid.getStore();
    var objData = null;
    for (var i = 0; i < objStore.getCount(); i++) {
        objData = objStore.getAt(i);
        objData.set("checked", selStatus);
        objData.commit();
    }
};
    
    
ExtTool.SelectFirstItem = function(objCbo)
{
   objStore = objCbo.initialConfig.store;
   var objData = null; 
   if(objStore.getCount() > 0)
   {
        objData = objStore.getAt(0);
        objCbo.setValue(objData.get(objCbo.initialConfig.valueField));
   }
} 

ExtTool.GetComboRec = function(objCombo, valueField)
{
    var objStore = objCombo.initialConfig.store;
    if(objStore.getCount() == 0)
        return null;
    var strValue = objCombo.getValue();
    if((strValue == "") || (strValue == null))
        return null;
    var objRec = null;
    for(var i = 0; i < objStore.getCount(); i ++)
    {
        objRec = objStore.getAt(i);
        if(objRec.get(valueField) == strValue)
            return objRec;
    }
    return null;
}

ExtTool.SetComboValue = function(objCombo, ValueFieldName, FieldName, FieldValue) {
    var objStore = objCombo.initialConfig.store;
    if (objStore.getCount() == 0)
        return null;
    var strValue = objCombo.getValue();
    var objValue = null;
    var objRec = null;
    for (var i = 0; i < objStore.getCount(); i++) {
        objRec = objStore.getAt(i);
        if (objRec.get(FieldName) == FieldValue) {
            objValue = objRec.get(ValueFieldName);
            objCombo.setValue(objValue);
        }
    }
    return null;
}
    
ExtTool.GetComboSpecificValue = function(objCombo, valueField, objField, value, nullValue)
{
    var objStore = objCombo.initialConfig.store;
    if(objStore.getCount() == 0)
        return null;
    var strValue = value;
    if((strValue == "") || (strValue == null))
        return null;
    var objRec = null;
    for(var i = 0; i < objStore.getCount(); i ++)
    {
        objRec = objStore.getAt(i);
        if(objRec.get(valueField) == strValue)
            return objRec.get(objField);
    }
    return nullValue;
}

ExtTool.DeleteComboItem = function(objCombo, fieldName, Value)
{
    var objStore = objCombo.initialConfig.store;
    if(objStore.getCount() == 0)
        return null;
    var strValue = Value;
    if((fieldName == "") || (Value == null))
        return null;
    var objRec = null;
    for(var i = 0; i < objStore.getCount(); i ++)
    {
        objRec = objStore.getAt(i);
        if(objRec.get(fieldName) == Value)
        {
        	objStore.remove(objRec);
            break;
        }
    }
}  

ExtTool.GetParam = function(obj, key)
{
	var url = obj.location.href;
	var strParams = "";
	var pos = url.indexOf("?");
	var tmpArry = null;
	var strValue = "";
	var tmp = "";
	if( pos < 0)
	{
		return "";
	}
	else
	{
	
		strParams = url.substring(pos + 1, url.length);
		tmpArry = strParams.split("&");
		for(var i = 0; i < tmpArry.length; i++)
		{
			tmp = tmpArry[i];
			if(tmp.indexOf("=") < 0)
				continue;
			if(tmp.substring(0, tmp.indexOf("=")) == key)
				strValue = tmp.substring(tmp.indexOf("=") + 1, tmp.length);
		}
		return strValue;
	}
};

ExtTool.FillComboBox = function(objCombo, ClassName, QueryName)
{
	var objConfig = new Object();
	objConfig.url = "./dhchm.query.CSP";
	var ArgCnt = 0;
	objConfig.params = new Object();
	objConfig.params.ClassName = ClassName;
	objConfig.params.QueryName = QueryName;
	for(var i = 3; i < arguments.length; i ++)
	{
		objConfig.params["Arg" + i] = arguments[i];
		ArgCnt ++;
	}			
	objConfig.params.ArgCnt = ArgCnt;	
	objConfig.success = function(response, opts)
	{
		//try{
			var obj = Ext.decode(response.responseText);
			var objRec = null;
			var objTmp = null;
			var objStore = objCombo.getStore();
			var objField = null;
			var objItm = null;
			var RecType = Ext.data.Record.create(objStore.fields.items);
			for(var i = 0; i < obj.total; i ++)
			{
				objItm = obj.record[i];
				objRec = new RecType();
				for(var j = 0; j < objStore.fields.items.length; j ++)
				{
					objField = objStore.fields.items[j];
					objRec.set(objField.name, objItm[objField.mapping]);
					//a();
				}
				objStore.add([objRec]);
			}
			
			aaa();
			//window.alert("AAA");
		//}catch(err)
		//{
		//	window.alert(err.description);
		//}
	};
	Ext.Ajax.request(objConfig);
};

ExtTool.CreateDataStoreByQuery = function (ClassName, QueryName, fillParamFn) {
    var objProxy = new Ext.data.HttpProxy(
              new Ext.data.Connection({
                  url: ExtToolSetting.RunQueryPageURL
              }));
    objProxy.on('beforeload', function (objProxy, param) {
    	var arryParam = fillParamFn();
        param.ClassName = ClassName;
        param.QueryName = QueryName;
        param.ArgCnt = 0;
        if(arryParam != null)
        {
        	for (var i = 0; i < arryParam.length; i ++)
        	{
        		param["Arg"+(i + 1)] = arryParam[i];
        	}
        	param.ArgCnt = arryParam.length;
        }
    });
    var strColLst = ExtTool.RunServerMethod("web.DHCHM.QueryService", "GetQueryStore", ClassName, QueryName);
    eval(strColLst);
    var objStore = new Ext.data.Store({
        proxy: objProxy,
        reader: new Ext.data.JsonReader({
            root: 'record',
            totalProperty: 'total',
            idProperty: 'ID'
        },
		arryCol)
    });
    return objStore;
}

ExtTool.CreateColumnModalByQuery = function(ClassName,QueryName)
{
  		var strColModal = ExtTool.RunServerMethod("web.DHCHM.QueryService", "GetQueryGridHeaderDeclare",  ClassName, QueryName);
  		eval(strColModal);
  		return colModel;
}

ExtTool.MethodSignature = ExtTool.GetMethodSignature();
//根据ID串得到对应Value串
ExtTool.GetValuesByIds = function(ids){
    if (ids == "") 
        return "";
    var values = "";
    var idArr = ids.split("^");
    var i = idArr.length;
    for (var j = 0; j < i; j++) {
        var id = idArr[j];
        var oneValue = Ext.getCmp(id).getValue();
        if (Ext.getCmp(id).isXType('checkbox')) {
            if (oneValue) {
                oneValue = 'Y';
                
            }
            else {
                oneValue = 'N';
            }
        }
        if ((Ext.getCmp(id).isXType('datefield')) && (oneValue != "")) {
            oneValue = oneValue.format(ExtToolSetting.DateFormatString);
        }
        values = values + "^" + oneValue;
    }
    values = values.substring(1);
    return values;
}
ExtTool.CreateCombo = function(id,Desc,disabled,clsName,methodName){
	
    var strExpression = "var DataStr = ExtTool.RunServerMethod(clsName,methodName";
    for(var i = 5; i < arguments.length; i ++)
    {
			strExpression += ",arguments[" + i + "]"
    }
    strExpression += ");"
    eval(strExpression);
	
	var DataArr = eval(DataStr);

    var Field = new Ext.form.ComboBox({
        typeAhead: true,
        triggerAction: 'all',
        lazyRender: true,
        id: id,
        fieldLabel: Desc,
        mode: 'local',
		//anchor:width,
		//width:width,
		disabled:disabled,
        store: new Ext.data.ArrayStore({
            id: 0,
            fields: ['myId', 'displayText'],
            data: DataArr
        }),
        valueField: 'myId',
        displayField: 'displayText'
    });
	return Field;
};
ExtTool.SetTabIndex = function (ids){
	if (ids == "") 
        return "";
	var idArr = ids.split("^");
    	var i = idArr.length;
    	for (var j = 0; j < i; j++) {
        	var oneStr = idArr[j];
        	var oneArr=oneStr.split("$");
        	var id=oneArr[0];
        	var obj=Ext.getCmp(id);
        	var index=oneArr[1];;
        	Ext.apply(obj,{tabIndex:index});
    	}
}
ExtTool.TreePanel = function(cname, qname, arg1, fname, region, width, text) {

	var tree = new Ext.tree.TreePanel({

				region : region,
				width : width,
				autoScroll : true,
				animate : true,
				frame : true,
				autoHeight : true,
				loader : new Ext.tree.TreeLoader({
							dataUrl : ExtToolSetting.TreeQueryPageURL,
							baseParams : {
								ClassName : cname,
								QueryName : qname,
								ArgCnt : 1,
								Arg1 : arg1
							}
						}),
				root : new Ext.tree.AsyncTreeNode({
							id : '0',
							text : text
						})
			});
	tree.expandAll();
	tree.on('click', fname);
	return tree;
};


Ext.apply(Ext.form.VTypes,   
{  
//首先定义一个vtype名称，和他的验证函数，val参数是文本框的值，field是文本框。一般我就使用val和正则表达式比较就OK了。  
//然后定义一个vtype的报错信息，与vtype名称加Text后缀。OK了。  
password: function(val, field)   
{  
        if (field.initialPassField)   
        {  
            var pwd = Ext.getCmp(field.initialPassField);  
            return (val == pwd.getValue());   
        }  
        return true;  
},  
passwordText: '两次输入的密码不一致！',  
    
chinese:function(val,field)  
{  
        var reg = /^[\u4e00-\u9fa5]+$/i;  
        if(!reg.test(val))  
        {  
            return false;  
        }  
        return true;  
},  
chineseText:'请输入中文',  
    
age:function(val,field)  
{  
        try
        {  
            if(parseInt(val) >= 18 && parseInt(val) <= 100)  
                return true;  
            return false;  
        }  
        catch(err)   
        {  
            return false;  
        }  
},  
ageText:'年龄输入有误',  
    
alphanum:function(val,field)  
{  
        try
        {  
            if(!/\W/.test(val))  
                return true;  
            return false;  
        }  
        catch(e)  
        {  
            return false;  
        }  
},  
alphanumText:'请输入英文字母或是数字,其它字符是不允许的.',  
    
url:function(val,field)  
{  
        try
        {  
            if(/^(http|https|ftp):\/\/(([A-Z0-9][A-Z0-9_-]*)(\.[A-Z0-9][A-Z0-9_-]*)+)(:(\d+))?\/?/i.test(val))  
                return true;  
            return false;  
        }  
        catch(e)  
        {  
            return false;  
        }  
},  
urlText:'请输入有效的URL地址.',  
    
max:function(val,field)  
{  
        try
        {  
            if(parseFloat(val) <= parseFloat(field.max))  
                return true;  
            return false;  
        }  
        catch(e)  
        {  
            return false;  
        }  
},  
maxText:'超过最大值',  
    
min:function(val,field)  
{  
        try
        {  
            if(parseFloat(val) >= parseFloat(field.min))  
                return true;  
            return false;  
        }  
        catch(e)  
        {  
            return false;  
        }  
},  
minText:'小于最小值',  
        
datecn:function(val,field)  
{  
        try
        {  
            var regex = /^(\d{4})-(\d{2})-(\d{2})$/;  
            if(!regex.test(val)) return false;  
            var d = new Date(val.replace(regex, '$1/$2/$3'));  
            return (parseInt(RegExp.$2, 10) == (1+d.getMonth())) && (parseInt(RegExp.$3, 10) == d.getDate())&&(parseInt(RegExp.$1, 10) == d.getFullYear());  
        }  
        catch(e)  
        {  
            return false;  
        }  
},  
datecnText:'请使用这样的日期格式: yyyy-mm-dd. 例如:2008-06-20.',  
    
integer:function(val,field)  
{  
        try
        {  
            if(/^[-+]?[\d]+$/.test(val))  
                return true;  
            return false;  
        }  
        catch(e)  
        {  
            return false;  
        }  
},  
integerText:'请输入正确的整数',  
    
minlength:function(val,field)  
{  
        try
        {  
            if(val.length >= parseInt(field.minlen))  
                return true;  
            return false
        }  
        catch(e)  
        {  
            return false;  
        }  
},  
minlengthText:'长度过小',  
    
maxlength:function(val,field)  
{  
     try
     {  
        if(val.length <= parseInt(field.maxlen))  
            return true;  
        return false;  
     }  
     catch(e)  
     {  
        return false;  
     }  
},  
maxlengthText:'长度过大',  
    
ip:function(val,field)  
{  
        try
        {  
            if((/^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(val)))  
                return true;  
            return false;  
        }  
        catch(e)  
        {  
            return false;  
        }  
},  
ipText:'请输入正确的IP地址',  
    
phone:function(val,field)  
{  
        try
        {  
            if(/^((0[1-9]{3})?(0[12][0-9])?[-])?\d{6,8}$/.test(val))  
                return true;  
            return false;  
        }  
        catch(e)  
        {  
            return false;  
        }  
},  
phoneText:'请输入正确的电话号码,如:0920-29392929',  
    
mobilephone:function(val,field)  
{  
        try
        {  
            if(/(^0?[1][35][0-9]{9}$)/.test(val))  
                return true;  
            return false;  
        }  
        catch(e)  
        {  
            return false;  
        }  
},  
mobilephoneText:'请输入正确的手机号码',  
    
alpha:function(val,field)  
{  
        try
        {  
            if( /^[a-zA-Z]+$/.test(val))  
                return true;  
            return false;  
        }  
        catch(e)  
        {  
            return false;  
        }  
},  
alphaText:'请输入英文字母',  
    
money:function(val,field)  
{  
        try
        {  
            if(/^\d+\.\d{2}$/.test(val))          
                return true;  
        return false;     
        }  
        catch(e)  
        {  
            return false;     
        }  

},  
moneyText:'请输入正确的金额'
});

ExtTool.FormToGrid = function(tid,grid,form){
	if (tid == '') {
  	var record = Ext.data.Record.create(grid.getStore().fields.items);
		record = new record();
		grid.getStore().insert(0,record);
  }
  else {
    var sm = grid.getSelectionModel();
    var record = sm.getSelected();
  }
  
	var pp = form.findByType('textfield');
  var j = pp.length;
  for (var i = 0; i < j; i++) {
    var id = pp[i].getId();
    var value = pp[i].getValue();

    if ((pp[i].isXType('datefield')) && (value != "")) {
        value = value.format(ExtToolSetting.DateFormatString);
    }
    record.set(id,value);
  };
            
  var pp = form.findByType('checkbox');
  var j = pp.length;
  for (var i = 0; i < j; i++) {
  	var id = pp[i].getId();
  	var value = pp[i].getValue();
  	value = value.toString();
  	record.set(id,value);
  };
  
  var pp = form.findByType('htmleditor');
  var j = pp.length;
  for (var i = 0; i < j; i++) {
  	var id = pp[i].getId();
  	var value = pp[i].getValue();
    	record.set(id,value);
   }

return record //add by cxr
  
};
