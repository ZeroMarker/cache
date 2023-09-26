Ext.BLANK_IMAGE_URL='../scripts_lib/ext3.1.0/resources/images/default/s.gif';
var ExtTool = new Object();

function websys_css_Func(){
	//去掉描述后面的冒号
	Ext.form.Field.prototype.labelSeparator = '';
}
websys_css_Func();

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
					   msg: "<div style='overflow:scroll;height=300px;width:500px;text-align:left'>请在CSP文件中增加'<input type=\"hidden\" id=\"MethodRunClassMethod\" value=\"<%=##Class(%CSP.Page).Encrypt($LB(\"web.DHCCPW.ClassMethodService.RunClassMethod\"))%>\"/>\').RunClassMethod</div>",
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
    eval(strExpression);  //fix IE11 点击【出入径明细查询】，进入页面时报错“错误: “strMethodSign”未定义”
    
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
    var strURL = "./csp/web.DHCCPW.ClassMethodServiceHelper.cls";

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
	var strResult = ExtTool.RunServerMethod("web.DHCCPW.ClassMethodService", "StaticObject", ClassName);
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
   window.eval(strExp);
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
	objConfig.url = "./dhccpw.query.CSP";
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
    var strColLst = ExtTool.RunServerMethod("web.DHCCPW.QueryService", "GetQueryStore", ClassName, QueryName);
    window.eval(strColLst);
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
  		var strColModal = ExtTool.RunServerMethod("web.DHCCPW.QueryService", "GetQueryGridHeaderDeclare",  ClassName, QueryName);
  		window.eval(strColModal);
  		return colModel;
}

ExtTool.GetParam = function(obj, key)
{
	var url = obj.location.href;
	var strParams = "";
	var pos = url.indexOf("?");
	var tmpArry = null;
	var strValue = "";
	var tmp = "";
	if( pos < 0){
		return "";
	}else{
	
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
}

//update by zf 2014-09-02 IE11兼容模式报错，Session超时
//ExtTool.MethodSignature = ExtTool.GetMethodSignature();
//ExtTool.MethodSignature = RunClassMethodEncrypt;
//update by pylian 20160323, fix bug 186036使用电子病历组归档系统生成PDF不成功
ExtTool.MethodSignature = (typeof(RunClassMethodEncrypt)=="undefined"?ExtTool.GetMethodSignature():RunClassMethodEncrypt);

/// add wangcs 2012-12-25 重写%排序
 Ext.data.Store.prototype.sortData =function(f, direction){
        direction = direction || 'ASC';
        var st = this.fields.get(f).sortType;
        var fn = function(r1, r2){
            var v1 = st(r1.data[f]), v2 = st(r2.data[f]);
			// zhaoyu 2013-05-06 查询统计-出入径明细查询，年龄中存在小于1岁时排序错误 256
			if (typeof(v1)=="string" && typeof(v2)=="string"){
				if (v1.indexOf("岁")>-1){
					v1=parseInt(v1.substring(0,v1.indexOf("岁")));
					v1=v1*10000;
				}else if (v1.indexOf("月")>-1){
					tmp1=v1.split("月");
					v1=parseInt(v1.substring(0,v1.indexOf("月")));
					v1=v1*100;
					if (tmp1[1].indexOf("天")>-1) {
						v1=v1+parseInt(tmp1[1].substring(0,tmp1[1].indexOf("天")));
					}
				}else if (v1.indexOf("天")>-1){
					v1=parseInt(v1.substring(0,v1.indexOf("天")));
				}else {
				}
				// 
				if (v2.indexOf("岁")>-1){
					v2=parseInt(v2.substring(0,v2.indexOf("岁")));
					v2=v2*10000;
				}else if (v2.indexOf("月")>-1){
					tmp2=v2.split("月");
					v2=parseInt(v2.substring(0,v2.indexOf("月")));
					v2=v2*100;
					if (tmp2[1].indexOf("天")>-1) {
						v2=v2+parseInt(tmp2[1].substring(0,tmp2[1].indexOf("天")));
					}
				}else if (v2.indexOf("天")>-1){
					v2=parseInt(v2.substring(0,v2.indexOf("天")));
				}else {
				}
			}
			//
            if (typeof(v1)=="string"&&typeof(v2)=="string"&&v1.indexOf("%")>-1&&v2.indexOf("%")>-1){
                v1=parseFloat(v1.substring(0,v1.indexOf("%")));
                v2=parseFloat(v2.substring(0,v2.indexOf("%")));
            }
            return v1 > v2 ? 1 : (v1 < v2 ? -1 : 0);
        };
        this.data.sort(direction, fn);
        if(this.snapshot && this.snapshot != this.data){
            this.snapshot.sort(direction, fn);
        }
}