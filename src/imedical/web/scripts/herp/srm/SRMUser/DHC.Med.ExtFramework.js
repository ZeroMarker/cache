Ext.BLANK_IMAGE_URL='../scripts_lib/ext3.1.0/resources/images/default/s.gif';
var ExtTool = new Object();


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
					   msg: "<div style='overflow:scroll;height=300px;width:500px;text-align:left'>请在CSP文件中增加'<input type=\"hidden\" id=\"MethodRunClassMethod\" value=\"<%=##Class(%CSP.Page).Encrypt($LB(\"DHCMed.ClassMethodService.RunClassMethod\"))%>\"/>\').RunClassMethod</div>",
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
    try
    {
    	var tmpStr = ""
    	tmpStr += "调用类:" + ClassName + "\n";
    	tmpStr += "调用方法名:" + MethodName + "\n";
    	for(var i = 2; i < arguments.length; i ++)
    	{
    		tmpStr += "调用参数" + (i - 1) + ":" + arguments[i] + "\n";
    	}
    	var tmpResult = strResult;
    	if(tmpResult == null)
    		tmpResult = "";
    	if(tmpResult.indexOf("<RESULT>OK</RESULT>") > -1)
    	{
    		tmpStr += "返回结果:【" + tmpResult.replace("<RESULT>OK</RESULT>", "") + "】\n";
    		window.console.info(tmpStr);
    	}else
    	{
    		tmpStr += "此函数调用出错！返回结果:【" + tmpResult + "】\n";
    		window.console.error(tmpStr);
    	}
    }catch(err)
    {
    }    
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
    var strURL = "./csp/DHCMed.ClassMethodServiceHelper.cls";
	
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
	var strResult = ExtTool.RunServerMethod("DHCMed.ClassMethodService", "StaticObject", ClassName);
	eval(strResult);
	return objTmp;
	
};

//向下拉框中增加项目
//objCbo:需要增加内容的下拉框
//Display:显示的内容
//Value对应的值（也就是Rowid）
ExtTool.AddComboItem = function(objCbo, Display, Value)
{
	var rstStore=0;
	var objStore = objCbo.initialConfig.store; 
	for (var indStore=0; indStore < objStore.getCount(); indStore++)
	{
		var rcStore = objStore.getAt(indStore);
		if ((rcStore.get(objCbo.initialConfig.valueField)==Value)||(rcStore.get(objCbo.initialConfig.displayField)==Display))
		{
			objCbo.setValue(Value);
			rstStore = 1;
		}
	}
	if (rstStore != '1')
	{
		var strExp="var rec = new Ext.data.Record({" + 
	    	objCbo.initialConfig.valueField + ": Value," +
	    	objCbo.initialConfig.displayField + ": Display});"
		eval(strExp);
		objStore.add([rec]);
		objCbo.setValue(Value);
	}
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
	objConfig.url = "./dhc.med.query.CSP";
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
    var strColLst = ExtTool.RunServerMethod("DHCMed.QueryService", "GetQueryStore", ClassName, QueryName);
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
  		var strColModal = ExtTool.RunServerMethod("DHCMed.QueryService", "GetQueryGridHeaderDeclare",  ClassName, QueryName);
  		eval(strColModal);
  		return colModel;	
}

//Add By LiYang 2011-05-14 通过字符串创建ColumnModal，用来制作可变列数的表格
ExtTool.CreateColumnModalByString = function(strTemplate)
{
	var strRow = "";
	var arryRows = strTemplate.split("^");
	var arryFields = new Array();
	for(var i = 0; i < arryRows.length; i ++)
	{
		strRow = arryRows[i];
		if(strRow == "")
			continue;
		arryFields[arryFields.length] = 
			{
				header : strRow,
				//width : 100,
				//sortable: true,
				dataIndex : "Col" + i //所有列名 均以  Col1  Col2  Col(n) 来表示
			};
	}
	/*return new Ext.grid.ColumnModel({
		columns : arryFields
	    ,defaults: {
	        sortable: true,
	        menuDisabled: true,
	        width: 100
	    }
	});*/
	return arryFields;
}

//Add By LiYang 2011-05-14 通过字符串创建Store，用来制作可变列数的表格
ExtTool.CreateStoreByString = function(strTemplate, objProxy)
{
	var strRow = "";
	var arryRows = strTemplate.split("^");
	var arryFields = new Array();
	for(var i = 0; i < arryRows.length; i ++)
	{
		strRow = arryRows[i];
		if(strRow == "")
			continue;
		arryFields[arryFields.length] = 
			{
				name: "Col" + i, 
				mapping : "Col" + i//所有列名 均以  Col1  Col2  Col(n) 来表示
			};
	}
	return new Ext.data.Store({
		proxy: objProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'id'
		}, 
		arryFields
		)
	});
}

//Add By LiYang 2013-01-08 运行Query的方法
//QueryInfo:query的说明
//      ClassName:类名
//      Arg1--ArgN:参数
//      ArgCnt:参数个数
//callback:query运行成功后的回调函数，它需要接受query的结果。结果是返回行的数组
//objScope:callback函数的作用域。
//extraArg : 希望传给callback函数的自定义参数
ExtTool.RunQuery = function(QueryInfo, callback, objScope, extraArg)
{
	var arryArgs = new Array();
	var params = new Object();
	params.ClassName = QueryInfo.ClassName;
	params.QueryName = QueryInfo.QueryName;
	for(var i = 0; i < QueryInfo.ArgCnt ; i ++)
	{
		params["Arg" + (i + 1)] = QueryInfo["Arg" + (i + 1)];
	}
	params.ArgCnt = QueryInfo.ArgCnt;
	Ext.Ajax.request({   
		params : params,
		url: ExtToolSetting.RunQueryPageURL,
	    success: function(response, params) {
		  var obj = Ext.decode(response.responseText);
		  
		  var arryResult = new Array();
		  for(var i = 0; i < obj.total; i ++)
		  {
			arryResult[arryResult.length] = obj.record[i];
		  }
		  callback.call(objScope, arryResult, extraArg);
		},
	    failure: function(response, params) {
		  ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
		}
	});	
}

//update by zf 2014-09-02 IE11兼容模式报错，Session超时
ExtTool.MethodSignature = ExtTool.GetMethodSignature();
//ExtTool.MethodSignature = RunClassMethodEncrypt;

// 新增grid 选择框种类 只可读

Ext.grid.CheckColumnR = function(config){
    Ext.apply(this, config);
    if(!this.id){
        this.id = Ext.id();
    }
    this.renderer = this.renderer.createDelegate(this);
};

Ext.grid.CheckColumnR.prototype ={
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
            record.set(this.dataIndex, record.data[this.dataIndex]);
            record.commit();
        }
    },

    renderer : function(v, p, record){
        p.css += ' x-grid3-check-col-td'; 
        return '<div class="x-grid3-check-col'+(v?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
    }
}; 


/*
/ 基本信息面板
/ by wuqk 2011-07-21
/ 调用##class(DHCMed.Base.Patient).GetJsonById(1)
/ 用法示例：
/ var PatientPanl = new ExtTool.PatientPanel({PatientId:'142709'});
*/
ExtTool.PatientPanel = Ext.extend(Ext.Panel, {
	width : this.width,// || 200,
	height : this.height,// || 200,
	frame : this.frame||true,
	//data : {},
	tpl : new Ext.XTemplate(
								'<table border=.1 width=100%>',
									'<tr>',
										'<td align="right">登记号:</td><td align="left">{PapmiNo}</td>',
										'<td align="right">姓名:</td><td align="left">{PatientName}</td>',
										'<td align="right">性别:</td><td align="left">{Sex}</td>',
										'<td align="right">婚否:</td><td align="left">{Marital}</td>',
										'<td align="right">电话:</td><td align="left">{Telephone}</td>',
									'</tr>',
									'<tr>',
										'<td align="right">病案号:</td><td align="left">{InPatientMrNo}</td>',
										'<td align="right">出生日期:</td align="left"><td>{Birthday}</td>',
										'<td align="right">年龄:</td><td align="left">{Age}</td>',
										'<td align="right">国籍:</td><td align="left">{Country}</td>',
										'<td align="right">民族:</td><td align="left">{Nation}</td>',
									'</tr>',
									'<tr>',
										'<td align="right">家庭住址:</td><td colspan=3  align="left">{Address}</td>',
										'<td align="right">工作单位:</td><td colspan=3  align="left">{WorkAddress}</td>',
										'<td align="right">身份证号码:</td><td align="left">{PersonalID}</td>',
									'</tr>',
								'</table>'
  ),
	patientId:this.PatientId,
	initComponent: function(){
		ExtTool.PatientPanel.superclass.initComponent.apply(this, arguments);
		var objPatient=ExtTool.StaticServerObject("DHCMed.Base.Patient");
		var datastr=objPatient.GetJsonById(this.PatientId);
		try{
			if (datastr!="") this.data=Ext.decode(datastr);}
		catch(e){
		}
	},
	onRender:function(ct, position) {
		ExtTool.PatientPanel.superclass.onRender.call(this, ct, position);
		if (this.data!=null)
			this.tpl.overwrite(this.body, this.data);
	}
})

/*
/ 就诊信息面板
/ by wuqk 2011-07-21
/ 调用##class(DHCMed.Base.PatientAdm).GetJsonById(1)
/ 用法示例：
/ var EpisodePanel = new ExtTool.EpisodePanel({EpisodeId:'77281'});
*/
ExtTool.EpisodePanel = Ext.extend(Ext.Panel, {
	width : this.width,// || 200,
	height : this.height,// || 200,
	frame : this.frame||true,
	//data : {},
	tpl : new Ext.XTemplate(
								'<table border=.1 width=100%>',
									'<tr>',
										'<td align="right">登记号:</td><td align="left">{values.objPatient.PapmiNo}</td>',
										'<td align="right">姓名:</td><td align="left">{values.objPatient.PatientName}</td>',
										'<td align="right">性别:</td><td align="left">{values.objPatient.Sex}</td>',
										'<td align="right">婚否:</td><td align="left">{values.objPatient.Marital}</td>',
										'<td align="right">电话:</td><td align="left">{values.objPatient.Telephone}</td>',
									'</tr>',
									'<tr>',
										//'<td align="right">病案号:</td><td align="left">{values.objPatient.InPatientMrNo}</td>',   //modify by liyi 2014-12-16 改为通过就诊号获取病案系统的病案号
										'<td align="right">病案号:</td><td align="left">{MrNo}</td>',
										'<td align="right">出生日期:</td align="left"><td>{values.objPatient.Birthday}</td>',
										'<td align="right">年龄:</td><td align="left">{values.objPatient.PatAge}</td>',
										'<td align="right">国籍:</td><td align="left">{values.objPatient.Country}</td>',
										'<td align="right">民族:</td><td align="left">{values.objPatient.Nation}</td>',
									'</tr>',
									'<tr>',
										'<td align="right">家庭住址:</td><td colspan=3  align="left">{values.objPatient.Address}</td>',
										'<td align="right">工作单位:</td><td colspan=3  align="left">{values.objPatient.WorkAddress}</td>',
										'<td align="right">身份证号码:</td><td align="left">{values.objPatient.PersonalID}</td>',
									'</tr>',
									'<tr>',
										'<td align="right">科室:</td><td align="left">{Department}</td>',
										'<td align="right">就诊类型:</td><td align="left">',
												'<tpl if="AdmType==\'I\'">住院</tpl>',
												'<tpl if="AdmType==\'O\'">门诊</tpl>',					
												'<tpl if="AdmType==\'E\'">急诊</tpl>',										
											'</td>',
										'<td align="right">就诊日期:</td><td align="left">{AdmitDate}</td>',
										'<td align="right">就诊时间:</td><td align="left">{AdmitTime}</td>',
										'<td align="right">医生:</td><td align="left">{DoctorName}</td>',
									'</tr>',
									'<tpl if="AdmType==\'I\'">',
										'<tr>',
											'<td align="right">病区:</td><td align="left">{Ward}</td>',
											'<td align="right">床位:</td align="left"><td>{Bed}</td>',
											'<td align="right">状态:</td><td align="left">',
													'<tpl if="Status==\'A\'">在院</tpl>',
													'<tpl if="Status==\'D\'">出院</tpl>',
													' </td>',
											'<td align="right">出院日期:</td><td align="left">{DisDate}</td>',
											'<td align="right">出院时间:</td><td align="left">{DisTime}</td>',
										'</tr>',
									'</tpl>',
								'</table>'
  ),
	EpisodeId:this.EpisodeId,
	PatientId:this.PatientId || '',
	initComponent: function(){
		ExtTool.EpisodePanel.superclass.initComponent.apply(this, arguments);
		var objEpisode=ExtTool.StaticServerObject("DHCMed.Base.PatientAdm");
		var objPatient=ExtTool.StaticServerObject("DHCMed.Base.Patient");
		var datastr=objEpisode.GetJsonById(this.EpisodeId);
		try{
			if (datastr!="") this.data=Ext.decode(datastr);
			this.PatientId=this.data.PatientID;
			var patientStr=objPatient.GetJsonById(this.PatientId);
			this.data.objPatient=Ext.decode(patientStr);
			/*
			if (this.data.objPatient.Age>0) this.data.objPatient.PatAge=this.data.objPatient.Age+"岁";
			if (this.data.objPatient.AgeMonth>0) this.data.objPatient.PatAge=this.data.objPatient.AgeMonth+"月";
			if (this.data.objPatient.AgeDay>0) this.data.objPatient.PatAge=this.data.objPatient.AgeDay+"天";
			*/
			//update by pylian 2015-09-17 统一调用年龄计算方法
			this.data.objPatient.PatAge = ExtTool.RunServerMethod("DHCMed.SSIO.FromHisSrv","GetPapmiAge",this.PatientId,this.EpisodeId,this.data.AdmitDate,this.data.AdmitTime);
			
				
			//Add By LiYang 2014-12-23如果病案号为空，需要调用病案接口函数查询病案号
			if((this.data.objPatient.InPatMrNo == "")&&(this.EpisodeId != ""))
			{
				this.data.objPatient.InPatMrNo = ExtTool.RunServerMethod("DHCMed.SSService.CommonCls","GetMrNoByAdm",this.EpisodeId);
			}
		}
		catch(e){
			window.alert(e.message);
		}
	},
	onRender:function(ct, position) {
		ExtTool.EpisodePanel.superclass.onRender.call(this, ct, position);
		if (this.data!=null)
			this.tpl.overwrite(this.body, this.data);
	}
})

ExtTool.LoadCurrPage = function(gridId)
{
	if (gridId) {
		var objGrid = Ext.getCmp(gridId);
		if (objGrid) {
			if (objGrid.getBottomToolbar()) {
				var start=objGrid.getBottomToolbar().cursor;
				var limit=objGrid.getBottomToolbar().pageSize;
				objGrid.getStore().load({params:{start:start,limit:limit}});
			}
		}
	}
}
