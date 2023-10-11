$(function(){
	initColData();
    initHistory(); 
});

function initColData()
{
	$HUI.datagrid('#colData',{
	    headerCls:'panel-header-gray',
        loadMsg: '数据装载中......',
        autoRowHeight: true,
        rownumbers: true,
        pagination: false,
        singleSelect: true,
        idField: 'ColID',
        fit: true,
        border:true,
        remoteSort: false,
        onBeforeSelect:function(rowIndex, rowData){
			 var selectCol = $("#colData").datagrid("getSelected");
			 var prevIndex = $("#colData").datagrid("getRowIndex",selectCol);
			 if (prevIndex == rowIndex)
			 {
				 return false;
			 }
			 else if(prevIndex != "-1")
			 {
				var property = getProperty(selectCol.TypeCode);
				var newTitle = property.Title;
				if (newTitle == "") {newTitle = selectCol.ColTitle;}
				$('#colData').datagrid('updateRow',{
				    index: prevIndex,
				    row: {
				        ColTitle: newTitle,
				        ColType: selectCol.ColType,
				        TypeCode: selectCol.TypeCode,
				        Property: JSON.stringify(property)
				    }
				});
			 }
	    },
		onSelect:function(rowIndex, rowData){
		 	initproperty(rowData.TypeCode);
		 	var curProperty = rowData.Property;
		 	if (curProperty != "")
		 	{
			 	setProperty( eval("("+curProperty+")"));
		 	}
	    },
	    columns:[[  
				{field:'ColID',title:'QuestionID',width:80,hidden: true},
				{field:'ColTitle',title:'列名',width:300,sortable:true},
				{field:'ColType',title:'列类型',width:100,sortable:true},
				{field:'TypeCode',title:'类型代码',width:100,hidden: true},
				{field:'Property',title:'属性',width:100,hidden: true}
			]]
    });
}

function initHistory()
{
	var colData = parent.$("#addcol").val();
	if (colData == "") return;
	var colObj = JSON.parse(colData); 
	for(var i=0;i<colObj.length;i++)
	{
		var property = JSON.stringify(getHistoryObj(colObj[i]));
		
		$('#colData').datagrid('appendRow',{
		    ColTitle: colObj[i].title,
		    ColType: getTypeName(colObj[i].editor.type),
		    TypeCode: colObj[i].editor.type,
		    Property: property
		});
	}
}

function AddCol()
{
	var selectCol = $("#colData").datagrid("getSelected");
	if (selectCol != null)
	{
		var prevIndex = $("#colData").datagrid("getRowIndex",selectCol);
		var property = getProperty(selectCol.TypeCode);
		var newTitle = property.Title;
		if (newTitle == "") {newTitle = selectCol.ColTitle;}
		$('#colData').datagrid('updateRow',{
		    index: prevIndex,
		    row: {
		        ColTitle: newTitle,
		        ColType: selectCol.ColType,
		        TypeCode: selectCol.TypeCode,
		        Property: JSON.stringify(property)
		    }
		});
	}
	
	createModalDialog("addColTypeDialog","添加列类型","350","350","iframeAddType","<iframe id='iframeAddType' scrolling='auto' frameborder='0' src='emr.addcoltype.csp' style='width:320px; height:310px; display:block;'></iframe>",ColCallBack,"")
}

function addTypeCallBack(returnValue)
{
	if ((returnValue == "")||(typeof(returnValue) == "undefined")) 
	{
		return;
	}
	var addType = returnValue;
	addColElement(addType);
}

function ColCallBack(returnValue,arr)
{
	$('#property').empty();
	$('#colData').datagrid('clearSelections');
}

function DeleteCol()
{
	var selectCol = $("#colData").datagrid("getSelected");
	if (selectCol != null)
	{
		var curIndex = $("#colData").datagrid("getRowIndex",selectCol);
		$("#colData").datagrid("deleteRow",curIndex);
		$('#property').empty();
	}
	else
	{
		$.messager.alert("提示信息","请先选中列数据！");
	}
}

function MoveUp()
{
	var row = $('#colData').datagrid('getSelected');
	if (row == null) 
	{	
		$.messager.alert("提示信息","请先选中列数据！");
		return;
	}
	var rowindex = $('#colData').datagrid('getRowIndex',row);
	if (rowindex === 0) {return; }
	$('#colData').datagrid('insertRow',{"index":rowindex-1,"row":row});
	$('#colData').datagrid('deleteRow',rowindex+1);
	$('#colData').datagrid('selectRow',rowindex-1);
}

function MoveDown()
{
	var row = $('#colData').datagrid('getSelected');
	if (row == null) 
	{	
		$.messager.alert("提示信息","请先选中列数据！");
		return;
	}
	var rowindex = $('#colData').datagrid('getRowIndex',row);
	
	var rows=$("#colData").datagrid("getRows").length;
	if (rowindex === rows-1) {return; }
	$('#colData').datagrid('insertRow',{"index":rowindex+2,"row":row});
	$('#colData').datagrid('deleteRow',rowindex);
	$('#colData').datagrid('selectRow',rowindex+1);
}

function addColElement(questType)
{
	if (questType == "text")
	{
		addText();
	}
	else if(questType == "checkbox")
	{
		addCheckbox();
	}
	else if(questType == "combobox")
	{
		addCombobox();
	}
	else if(questType == "numberbox")
	{
		addNumber();
	}
	else if(questType == "datebox")
	{
		addDate();
	}
	else if(questType == "datetimebox")
	{
		addTime();
	}
}

function addText()
{
 	addElement("文本","文本","text")
}

function addCheckbox()
{		
 	addElement("勾选框","勾选框","checkbox")
}

function addCombobox()
{  		
 	addElement("下拉框","下拉框","combobox")
}

function addNumber()
{
 	addElement("数字","数字","numberbox")
}

function addDate()
{
 	addElement("日期","日期","datebox")
}

function addTime()
{
 	addElement("时间","时间","datetimebox")
}

function addElement(colTitle,colType,typeCode)
{
	$('#property').empty();
	
	$('#colData').datagrid('appendRow',{
	    ColTitle: colTitle,
	    ColType: colType,
	    TypeCode: typeCode,
	    Property: ''
	});
	
 	initproperty(typeCode);
 	$.parser.parse('#property');
}

function initTitle()
{
	var str ='<div class="propertyDiv"><div class="NameDiv">'+emrTrans("列名称")+'</div>'
	 	 + '<input id="title" class="textbox longInput" id="" style=""></div>'
	$('#property').append(str);
}

function initWidth()
{
	var str ='<div class="propertyDiv"><div>'+emrTrans("列宽度")+'</div>'
	 	 +'<input id="colWidth" class="hisui-numberbox textbox longInput" type="text"></input></div>'
	$('#property').append(str);
}

function initRequired()
{
    var str ='<div id="required" class="propertyDiv"><div class="name">是否必填</div><input class="hisui-radio" id="requiredtrue" value="true" type="radio" name="required" label="必填"><input class="hisui-radio" id="requiredfalse" value="false" type="radio" name="required" label="非必填"></div>';
    $('#property').append(str);
}

function initDataset()
{
	var str ='<div class="propertyDiv"><div class="NameDiv">'+emrTrans("选项集合：在集合中输入备选项(每行一个 描述|ID)")+'</div>'
	 	 + '<textarea id="dataset" class="textbox" rows="6" cols="80" style="width:340px;overflow:hidden;"></textarea></div>'
	$('#property').append(str);
}

function initCheckboxValue()
{
	var str ='<div class="propertyDiv"><div>'+emrTrans("勾选的取值")+'</div>'
	 	 +'<input id="onValue" class="textbox longInput" type="text"></input></div>'
	 	 
	 	 str = str + '<div class="propertyDiv"><div>'+emrTrans("未勾选取值")+'</div>'
	 	 +'<input id="offValue" class="textbox longInput" type="text"></input></div>'
	 	 
	$('#property').append(str);
}

function initDecimalDigits()
{
	var str ='<div class="propertyDiv"><div>'+emrTrans("小数点位数")+'</div>'
	 	 +'<input id="decimalDigits" class="hisui-numberbox textbox longInput" type="text"></input></div>'
	$('#property').append(str);
}

function getProperty(questType)
{
	var obj = {};
	if (questType == "text")
	{
		obj = getText();
	}
	else if(questType == "checkbox")
	{
		obj = getCheckbox();
	}
	else if(questType == "combobox")
	{
		obj = getCombobox();
	}
	else if(questType == "numberbox")
	{
		obj = getNumber();
	}
	else if(questType == "datebox")
	{
		obj = getDate();
	}
	else if(questType == "datetimebox")
	{
		obj = getTime();
	}
	return obj;
}

function getText()
{
	var obj = getBasePropty();
	obj.ElemType = "text";
	
	return obj;
}

function getCheckbox()
{
	var obj = getBasePropty();
	obj.ElemType = "checkbox";
	obj.OnValue = $("#onValue").val();
	obj.OffValue = $("#offValue").val();
	return obj;
}

function getCombobox()
{
	var obj = getBasePropty();
	obj.ElemType = "combobox";
	obj.Required = $("input[name='required']:checked").val();
	if (typeof(obj.Required) == "undefined") {obj.Required = "";}
	obj.Dataset = getDataset();
	return obj;
}

function getNumber()
{
	var obj = getBasePropty();
	obj.ElemType = "numberbox";
	obj.DecimalDigits = $("#decimalDigits").val();
	return obj;
}

function getDate()
{
	var obj = getBasePropty();
	obj.ElemType = "datebox";
	
	return obj;
}

function getTime()
{
	var obj = getBasePropty();
	obj.ElemType = "datetimebox";
	
	return obj;
}

function getBasePropty()
{
	var obj = {};
	obj.Title = $("#title").val();
	obj.Width = $("#colWidth").val();
    return obj;
}

function getDataset()
{
	if (($("#dataset").val() == undefined)||($("#dataset").val() == "")) {return;}
	var list = $("#dataset").val().split("\n");
	var Choices = new Array();
	for (i=0;i<list.length;i++)
	{
		if (list[i] != "")
		{
			var value = i;
			if ((list[i].split("|")[1] != undefined)&&(list[i].split("|")[1] != ""))
			{
				value = list[i].split("|")[1];
			}
			Choices.push({"Code":value,"Desc":list[i].split("|")[0]});
		}
	}
	return Choices;
	
}

function setProperty(obj)
{	
	if (!obj || obj == "") return;
	setBasePropty(obj);
	
	if (typeof(obj.Dataset) != "undefined")
	{
		setDataset(obj.Dataset);
	}
	
	if (typeof(obj.OnValue) != "undefined")
	{
		setOnValue(obj.OnValue);
	}
	
	if (typeof(obj.OffValue) != "undefined")
	{
		setOffValue(obj.OffValue);
	}
	
	if (typeof(obj.DecimalDigits) != "undefined")
	{
		setDecimalDigits(obj.DecimalDigits);
	}
	
	if (typeof(obj.Required) != "undefined")
	{
		setRequired(obj.Required);
	}
}

//设置元素基本属性
function setBasePropty(obj)
{	
	setTitle(obj.Title);
	setWidth(obj.Width);	
}

function setTitle(value)
{
	$("#title").val(value);	
}

function setWidth(value)
{
	$("#colWidth").val(value);	
}

function setRequired(value)
{
	if (value == "") return;
	$HUI.radio("input[name='required'][value="+ value +"]").setValue(true);
}

function setDataset(value)
{
	var text = "";
	for(var i=0;i<value.length;i++)
	{
		text = text + value[i].Desc+"|"+value[i].Code +"\n";
	}
	$("#dataset").val(text);
}

function setOnValue(value)
{
	$("#onValue").val(value);
}

function setOffValue(value)
{
	$("#offValue").val(value);
}

function setDecimalDigits(value)
{
	$("#decimalDigits").val(value);
}

function initproperty(type)
{
	$('#property').empty();
	initTitle();
 	initWidth();
 	if (type == "checkbox")
 	{
	 	initCheckboxValue();
 	}
 	else if(type == "combobox")
 	{
	 	initRequired();
	 	initDataset();
 	}
 	else if(type == "numberbox")
 	{
	 	initDecimalDigits();
 	}
 	$.parser.parse('#property');
}

function Save()
{
	saveCurProperty();
	
	var Properties = new Array();
    var rows = $("#colData").datagrid("getRows");
	for(var i=0;i<rows.length;i++)
	{
		if (rows[i].Property != "")
		{
			var property = eval("("+rows[i].Property+")");
        	var editor = getEditorJson(property);
        	var width = property.Width;
        	if (width == "") {width = 150;}
		}
		else
		{
			if (rows[i].TypeCode == "checkbox")
			{
				var editor = {"type":rows[i].TypeCode,"options":{"on":"1","off":"0"}};
			}
			else if(rows[i].TypeCode == "combobox")
			{
				var editor = {"type":rows[i].TypeCode,"options":{"valueField":"Code","textField":"Desc","data":[]}};
			}
			else
			{
				var editor = {"type":rows[i].TypeCode};
			}
			var width = 150;
		}
        var fieldid = "field" + i;
        Properties.push({"field":fieldid,"title":rows[i].ColTitle,"width":width,"editor":editor});
	}
	
	var result = JSON.stringify(Properties);
	window.returnValue = result;
	closeWindow();
}

function getEditorJson(obj)
{
	var Editor = {};
	if (obj.ElemType == "numberbox")
	{
		Editor = {"type":obj.ElemType,"options":{"precision":obj.DecimalDigits}};
	}
	else if(obj.ElemType == "checkbox")
	{
		Editor = {"type":obj.ElemType,"options":{"on":obj.OnValue,"off":obj.OffValue}};
	}
	else if(obj.ElemType == "combobox")
	{
		var required = "";
		if (obj.Required == "true") {required = "true";}
		Editor = {"type":obj.ElemType,"options":{"valueField":"Code","textField":"Desc","required":required,"data":obj.Dataset}};
	}
	else
	{
		Editor = {"type":obj.ElemType};
	}
	return Editor;
}

function saveCurProperty()
{
	var selectCol = $("#colData").datagrid("getSelected");
	if (selectCol != null)
	{
		var curIndex = $("#colData").datagrid("getRowIndex",selectCol);
		var property = getProperty(selectCol.TypeCode);
		var newTitle = property.Title;
		if (newTitle == "") {newTitle = selectCol.ColTitle;}
		$('#colData').datagrid('updateRow',{
		    index: curIndex,
		    row: {
		        ColTitle: newTitle,
		        ColType: selectCol.ColType,
		        TypeCode: selectCol.TypeCode,
		        Property: JSON.stringify(property)
		    }
		});
	}
}

function getHistoryObj(colData)
{
	var obj = {};
	var type = colData.editor.type;
	obj.ElemType = colData.editor.type;
	obj.Title = colData.title;
	obj.Width = colData.width;
	
	if (typeof(colData.editor.options) == "object")
	{
		if (type == "text")
		{
			
		}
		else if(type == "checkbox")
		{
			obj.OnValue = colData.editor.options.on;
			obj.OffValue = colData.editor.options.off;
		}
		else if(type == "combobox")
		{
			obj.Dataset = colData.editor.options.data;
			obj.Required = colData.editor.options.required;
		}
		else if(type == "numberbox")
		{
			obj.DecimalDigits = colData.editor.options.precision;
		}
		else if(type == "datebox")
		{
			
		}
		else if(type == "datetimebox")
		{
			
		}
	}
	return obj;
}

function getTypeName(typeCode)
{
	var result = "";
	if (typeCode == "text")
	{
		result = "文本";
	}
	else if(typeCode == "checkbox")
	{
		result = "勾选框";
	}
	else if(typeCode == "combobox")
	{
		result = "下拉框";
	}
	else if(typeCode == "numberbox")
	{
		result = "数字";
	}
	else if(typeCode == "datebox")
	{
		result = "日期";
	}
	else if(typeCode == "datetimebox")
	{
		result = "时间";
	}
	return result;
}

//关闭窗口
function closeWindow()
{
	parent.closeDialog("AddColDialog");	
}