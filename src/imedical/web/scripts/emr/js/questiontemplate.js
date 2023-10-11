$(function(){
	initType();	
	initQuestion();
});

function initType()
{
	var cbox = $HUI.combobox("#type",{
		valueField:'Code',
		textField:'Desc',
		multiple:false,
		selectOnNavigation:false,
		panelHeight:"auto",
		url:'../EMRservice.Ajax.common.cls?OutputType=String&Class=EMRservice.BL.BLMedicalHistoryType&Method=GetTypeList', 
		editable:false,
		onChange:function(){
	        var type = $("#type").combobox("getValue");
	        if (type != "") {
	            queryData();
	        }
	    }
	});	

}

function initQuestion()
{
	var param = getParam();
	$('#questionData').datagrid({
	    headerCls:'panel-header-gray',
        pageSize: 10,
        pageList: [10, 20, 30],
        loadMsg: '数据装载中......',
        autoRowHeight: true,
        url: '../EMRservice.Ajax.QuestionData.cls?Action=GetQuestionData',
        rownumbers: true,
        pagination: false,
        singleSelect: true,
        queryParams: param,
        idField: 'QuestionID',
        fit: true,
        remoteSort: false,
		onSelect:function(rowIndex, rowData){
	         currentType = rowData.QuestionTypeCode;
			 getQuestValue(rowData.QuestionID);
			 if ((rowData.IsPublish == "1")||(rowData.IsPublish == "-1"))
			 {
				 $('#saveButton').linkbutton("disable");
			 }
			 else
			 {
				 $('#saveButton').linkbutton("enable");
			 }
	    },
	    columns:[[  
				{field:'QuestionID',title:'QuestionID',width:80,hidden: true},
				{field:'QuestionTitle',title:'题目',width:450,sortable:true},
				{field:'QuestionType',title:'题型',width:90,sortable:true},
				{field:'IsPublish',title:'发布状态',width:80,sortable:true,formatter:operatePublish}
			]]
    });
}

//获取查询参数
function getParam() {
    var type = $("#type").combobox("getValue");
    var param = {
        MedHistoryType: type
    };
    return param;
}

// 查询
function queryData() {
    var param = getParam();
    $('#questionData').datagrid('load', param);
    $('#content').empty();
	$('#property').empty();
	$('#questionData').datagrid("unselectAll");
	$('#saveButton').linkbutton("disable");
}

document.getElementById("text").onclick = function(){
 	
 	var html = $('<div class="box"><div class="name">单行文本</div><div class=""><input class="textbox addtextbox" id="" style=""></div></div>');
 	addElement("text",html);
};


document.getElementById("textarea").onclick = function(){	
 	
 	var html = $('<div id="textarea" class="box"><div class="name">多行文本</div><div class=""><textarea id="" class="textbox addtextbox" rows="6" cols="60" style="width:overflow:hidden;"></textarea></div>');
 	addElement("textarea",html);
};

document.getElementById("radio").onclick = function(){
 	
 	var html = $('<div class="box"><div class="name">单选框</div><div class=""><input class="hisui-radio" id="" value="" type="radio" name="newRadio" label="选项1"><input class="hisui-radio" id="" value="" type="radio" name="newRadio" label="选项2"><input class="hisui-radio" id="" value="" type="radio" name="newRadio" label="选项3"></div>');
 	addElement("radio",html);
};

document.getElementById("checkbox").onclick = function(){
 	
 	var html = $('<div class="box"><div class="name">多选框</div><div class=""><input class="hisui-checkbox" id="" value="" type="checkbox" name="newCheckbox" label="选项1"><input class="hisui-checkbox" id="" value="" type="checkbox" name="newCheckbox" label="选项2"><input class="hisui-checkbox" id="" value="" type="checkbox" name="newCheckbox" label="选项3"></div>');
 	addElement("checkbox",html);
};

document.getElementById("combobox").onclick = function(){
 	
 	var html = $('<div class="box"><div class="name">下拉框（单选）</div><div class=""><select id="combobox" class="hisui-combobox" name="newcombobox" style="width:300px;" data-options=""><option value="option1">选项1</option><option value="option2">选项2</option><option value="option3">选项3</option></select></div>');
 	addElement("combobox",html);
};

document.getElementById("comboboxMult").onclick = function(){
 	
 	var html = $('<div class="box"><div class="name">下拉框（多选）</div><div class=""><select id="comboboxMult" class="hisui-combobox" name="newcomboboxMult" style="width:300px;" data-options="multiple:true"><option value="option1">选项1</option><option value="option2">选项2</option><option value="option3">选项3</option></select></div>');
 	addElement("comboboxMult",html);
};

document.getElementById("datagrid").onclick = function(){
 	  
    var html = $('<div class="box"></div>');
    
    var table = '<div class="name">表格</div><table id="dg" class="hisui-datagrid" title="表格" style="width:700px;height:auto" data-options="iconCls: \'icon-edit\',singleSelect: true,headerCls:\'panel-header-gray\',toolbar: \'#tb\',onClickCell: onClickCell,onEndEdit: onEndEdit"><thead><tr><th data-options="field:\'unitcost\',width:80,align:\'center\',editor:{type:\'numberbox\',options:{precision:2}}">Unit Cost</th><th data-options="field:\'feetypeid\',width:150,formatter:function(value,row){return row.feetypename;},editor:{type:\'combobox\',options:{valueField:\'feetypeid\',textField:\'feetypename\',data:[{\'feetypeid\':1,\'feetypename\':\'自费\'},{\'feetypeid\':2,\'feetypename\':\'职工\'},{\'feetypeid\':3,\'feetypename\':\'医保\'}],required:true,blurValidValue:true}}">feeType</th><th data-options="field:\'attr1\',width:250,editor:\'text\'">Attribute</th><th data-options="field:\'status\',width:60,align:\'center\',editor:{type:\'checkbox\',options:{on:\'P\',off:\'\'}}">Status</th></tr></thead></table>';   
    
    var toolbar = '<div id="tb" style="height:auto"><a href="javascript:void(0)" class="hisui-linkbutton" data-options="iconCls:\'icon-add\',plain:true" onclick="append()">新增</a><a href="javascript:void(0)" class="hisui-linkbutton" data-options="iconCls:\'icon-remove\',plain:true" onclick="removeit()">删除</a><a href="javascript:void(0)" class="hisui-linkbutton" data-options="iconCls:\'icon-save\',plain:true" onclick="acceptit()">保存</a></div>'
    
    $(html).append(table);
    $(html).append(toolbar);
    addElement("datagrid",html);
};

var editIndex=undefined;
var modifyBeforeRow = {};
var modifyAfterRow = {};
function endEditing(){
		if (editIndex == undefined){return true}
		if ($('#dg').datagrid('validateRow', editIndex)){
			//列表中下拉框实现，修改后把回写Desc，因为formatter显示的是desc字段
			var ed = $('#dg').datagrid('getEditor', {index:editIndex,field:'Code'});
			if (ed){
				var Desc = $(ed.target).combobox('getText');
				$('#dg').datagrid('getRows')[editIndex]['Desc'] = Desc;
				$('#dg').datagrid('endEdit', editIndex);
			}
			modifyAfterRow = $('#dg').datagrid('getRows')[editIndex];
        editIndex = undefined;
        return true;
    } else {
        return false;
    }
}
function onClickCell(index, field){
    if (editIndex != index){
        if (endEditing()){
            $('#dg').datagrid('selectRow', index)
                    .datagrid('beginEdit', index);
            var ed = $('#dg').datagrid('getEditor', {index:index,field:field});
            if (ed){
                ($(ed.target).data('textbox') ? $(ed.target).textbox('textbox') : $(ed.target)).focus();
            }
            editIndex = index;
			modifyBeforeRow = $.extend({},$('#dg').datagrid('getRows')[editIndex]);
        } else {
            setTimeout(function(){
                $('#dg').datagrid('selectRow', editIndex);
            },0);
        }
    }
}
function onEndEdit(index, row){
    var ed = $(this).datagrid('getEditor', {
        index: index,
        field: 'productid'
    });
}
function append(){
    if (endEditing()){
        $('#dg').datagrid('appendRow',{});
        editIndex = $('#dg').datagrid('getRows').length-1;
        $('#dg').datagrid('selectRow', editIndex)
                .datagrid('beginEdit', editIndex);
    }
}
function removeit(){
    if (editIndex == undefined){return}
    $('#dg').datagrid('cancelEdit', editIndex)
            .datagrid('deleteRow', editIndex);
    editIndex = undefined;
}
function acceptit(){
    if (endEditing()){
        $('#dg').datagrid('acceptChanges');
    }
}     

document.getElementById("number").onclick = function(){
 	
 	var html = $('<div class="box"><div class="name">数字</div><div class=""><input id="newNumber" class="hisui-numberbox textbox longInput" type="text"></input></div></div>');
 	addElement("number",html);
};

document.getElementById("date").onclick = function(){
 	
 	var html = $('<div class="box"><div class="name">日期</div><div class=""><input id="newDate" class="hisui-datebox textbox" data-options="" style="width:200px;"></div></div>');
 	addElement("date",html);
};

document.getElementById("time").onclick = function(){
 	
 	var html = $('<div class="box"><div class="name">时间</div><div class=""><input class="hisui-timespinner" data-options="showSeconds:true" style="border-radius: 2px;width:200px;"></div></div>');
 	addElement("time",html);
};

function addElement(questType,html)
{
	currentType = questType;
	var basecode = getBasecode();
 	if (basecode == "") return;
	$('#content').empty();
	$('#property').empty();
	$('#questionData').datagrid("unselectAll");
		
	$('#content').append(html);
 	$.parser.parse('#content');
 	getProperty(questType,"init");
	
	$('#saveButton').linkbutton("enable");
}

function getBasecode()
{
	var basecode = $("#type").combobox('getValue'); 
	if (basecode == "")
	{
		$.messager.alert("提示信息","请先在下拉框中选择基础类型！");
	}
	return basecode;
}

function CheckCode()
{
	var result = "0";
	var curCode = getCode();
	if (curCode == "")
	{
		$.messager.alert("提示信息","请先输入题目代码！");
	}
	else if(checkCorrect(curCode) == "1")
	{
		$.messager.alert("提示信息","题目代码只可包含数字和英文字母！");
	}
	else
	{
		result = "1";
	}
	return result;
}

function checkCorrect(str)
{
	var result = "0";
	for(var i = 0;i < str.length; i++){
		var curStr = str.charCodeAt(i);
		if ((curStr < 48)||(curStr > 122)||((curStr > 57)&&(curStr < 65))||((curStr > 90)&&(curStr < 97))) 
		{
			result = "1";
			return result;
		}
	}
	
	return result;
}

function checkChinese(str)
{
	var result = "0";
	for(var i = 0;i < str.length; i++){
		if(str.charCodeAt(i) > 255) 
		{
			result = "1";
			return result;
		}
	}
	
	return result;
}

function IsCodeExist()
{
	var result = "0";
	var code = getCode();
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLQuestionData",
					"Method":"IsCodeExist",			
					"p1":code
				},
			success : function(d) {
	           		if (d == "1")
	           		{
		           		result = "1";
		           		$.messager.alert("提示信息","题目代码需唯一，此代码库中已存在，请修改后重新保存！");
	           		}
			},
			error : function(d) { alert("IsCodeExist error");}
		});
	return result;
}

function SaveDetail()
{
	if (CheckCode() == "0") return;
	
	var selectQuest = $("#questionData").datagrid("getSelected");
	var medHistoryType = $("#type").combobox("getValue");
	var questID = "";
	if (selectQuest == null)
	{
		if (IsCodeExist() == "1") return;
		var action = "add";
	}
	else
	{
		
		var action = "update";
		questID = selectQuest.QuestionID;
	}
	
	var obj = getProperty(currentType,"getPropty");
	
	jQuery.ajax({
			type : "POST", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLQuestionData",
					"Method":"ChangeData",			
					"p1":medHistoryType,
					"p2":currentType,			
					"p3":action,		
					"p4":questID,			
					"p5":JSON.stringify(obj)
				},
			success : function(d) {
	           		if (d == "1")
	           		{
		           		$.messager.alert("提示信息","保存成功");
		           		queryData();
	           		}
			},
			error : function(d) { alert("SaveDetail error");}
		});
}

function getProperty(questType,action)
{
	var result = "";
	jQuery.ajax({
		type : "GET", 
		dataType : "text",
		url : "../EMRservice.Ajax.common.cls",
		async : false,
		data : {
				"OutputType":"String",
				"Class":"EMRservice.BL.BLQuestTypeProperty",
				"Method":"GetPropertyByType",			
				"p1":questType
			},
		success : function(d) {
           		if (d != "")
           		{
	           		if (action == "init")
	           		{
		           		initProperties(eval("["+d+"]")[0]);
	           		}
	           		else if (action == "getPropty")
	           		{
		           		result = getPropty(eval("["+d+"]")[0]);
	           		}
	           		
           		}
		},
		error : function(d) { alert("getProperty error");}
	});
	return result;	
}

function initProperties(data)
{
	var html = "";
	for (var i=0;i<data.length;i++)
    {
        var code = data[i].Code;
        if (code == "title")
        {
	        html = html + initTitle();
        }
        else if(code == "code")
        {
	        html = html + initCode();
        }
        else if(code == "required")
        {
	        html = html + initRequired();
        }
        else if(code == "minlength")
        {
	        html = html + initMinlength();
        }
        else if(code == "maxlength")
        {
	        html = html + initMaxlength();
        }
        else if(code == "defaultdata")
        {
	        html = html + initDefault();
        }
        else if(code == "inputBoxSize")
        {
	        html = html + initInputBoxSize();
        }
        else if(code == "dataset")
        {
	        html = html + initDataset();
        }
        else if(code == "arrangeType")
        {
	        html = html + initArrangeType();
        }
        else if(code == "optionType")
        {
	        html = html + initOptionType();
        }
        else if(code == "minValue")
        {
	        html = html + initMinValue();
        }
        else if(code == "maxValue")
        {
	        html = html + initMaxValue();
        }
        else if(code == "decimalDigits")
        {
	        html = html + initDecimalDigits();
        }
        else if(code == "includeMax")
        {
	        html = html + initIncludeMax();
        }
        else if(code == "includeMin")
        {
	        html = html + initIncludeMin();
        }
        else if(code == "dateFormat")
        {
	        html = html + initDateFormat();
        }
        else if(code == "timeFormat")
        {
	        html = html + initTimeFormat();
        }
        else if (code == "addcol")
        {
	        html = html + initAddcol();
        }
        else if (code == "scripts")
        {
	        html = html + initScripts();
        }
        else if (code == "url")
        {
	        html = html + initURL();
        }
    }
    $("#property")[0].innerHTML = html;
    $.parser.parse('#property');
}

function initTitle()
{
	var str ='<div class="propertyDiv"><span class="NameDiv">'+emrTrans("题目名称")+'</span>'
	 	 + '<input id="title" class="textbox longInput" style=""></div>'
	return str;	
}

function initCode()
{
	var str ='<div class="propertyDiv"><span class="NameDiv">'+emrTrans("题目代码")+'</span>'
	 	 + '<input id="code" class="textbox longInput" style=""></div>'
	return str;	
}

function initRequired()
{
    var str ='<div id="required" class="propertyDiv"><span class="NameDiv">是否必填</span><input class="hisui-radio" id="requiredtrue" value="true" type="radio" name="required" label="必填"><input class="hisui-radio" id="requiredfalse" value="false" type="radio" name="required" label="非必填"></div>';
    return str;
}

//最小长度
function initMinlength()
{
	var str ='<div class="propertyDiv"><span class="NameDiv">'+emrTrans("最小长度")+'</span>'
	 	 +'<input id="minlength" class="hisui-numberbox textbox longInput" type="text"></input></div>'
	return str; 
}

//最大长度
function initMaxlength()
{
	var str ='<div class="propertyDiv"><span class="NameDiv">'+emrTrans("最大长度")+'</span>'
	 	 +'<input id="maxlength" class="hisui-numberbox textbox longInput" type="text"></input></div>'
	return str; 
}

function initDefault()
{
	var str ='<div class="propertyDiv"><span class="NameDivThree">'+emrTrans("默认值")+'</span>'
	 	 + '<input id="defaultdata" class="textbox longInput" id="" style=""></div>'
	return str;	
}

function initInputBoxSize()
{	
	var str ='<div id="inputBoxSize" class="propertyDiv"><span class="NameDiv">输入框大小</span><input class="hisui-radio" id="" value="short" type="radio" name="inputBoxSize" label="短"><input class="hisui-radio" id="" value="medium" type="radio" name="inputBoxSize" label="中"><input class="hisui-radio" id="" value="long" type="radio" name="inputBoxSize" label="长"></div>';
    return str;
}

function initDataset()
{
	var str ='<div class="propertyDiv"><div class="NameDiv">'+emrTrans("选项集合：在集合中输入备选项(每行一个 描述|ID)")+'</div>'
	 	 + '<textarea id="dataset" class="textbox" rows="6" cols="80" style="width:405px;overflow:hidden;"></textarea></div>'
	return str;	
}

function initArrangeType()
{
	var str ='<div id="arrangeType" class="propertyDiv"><span class="NameDiv">横竖排显示</span><input class="hisui-radio" id="" value="row" type="radio" name="arrangeType" label="横排显示"><input class="hisui-radio" id="" value="col" type="radio" name="arrangeType" label="竖排显示"></div>';
    return str;
}

function initOptionType()
{
	var str ='<div id="optionType" class="propertyDiv"><span class="NameDiv">单选多选类型</span><input class="hisui-radio" id="" value="1" type="radio" name="optionType" label="单选"><input class="hisui-radio" id="" value="0" type="radio" name="optionType" label="多选"></div>';
    return str;
}

function initMinValue()
{
	var str ='<div class="propertyDiv"><span class="NameDivThree">'+emrTrans("最小值")+'</span>'
	 	 +'<input id="minValue" class="hisui-numberbox textbox longInput" type="text"></input></div>'
	return str; 
}

function initMaxValue()
{
	var str ='<div class="propertyDiv"><span class="NameDivThree">'+emrTrans("最大值")+'</span>'
	 	 +'<input id="maxValue" class="hisui-numberbox textbox longInput" type="text"></input></div>'
	return str; 
}

function initDecimalDigits()
{
	var str ='<div class="propertyDiv"><span class="NameDiv">'+emrTrans("小数点位数")+'</span>'
	 	 +'<input id="decimalDigits" class="hisui-numberbox textbox" type="text" style="width:326px !important;;margin-top:2px !important;"></input></div>'
	return str; 
}

function initIncludeMax()
{
	var str ='<div id="includeMax" class="propertyDiv" style="display:none;"><span class="NameDiv">是否包含最大值</span><input class="hisui-radio" id="includeMaxYes" value="1" type="radio" name="includeMax" label="包含"><input class="hisui-radio" id="includeMaxNo" value="0" type="radio" name="includeMax" label="不包含"></div>';
    return str;
}

function initIncludeMin()
{
	var str ='<div id="includeMin" class="propertyDiv" style="display:none;"><span class="NameDiv">是否包含最小值</span><input class="hisui-radio" id="includeMinYes" value="1" type="radio" name="includeMin" label="包含"><input class="hisui-radio" id="includeMinNo" value="0" type="radio" name="includeMin" label="不包含"></div>';
    return str;
}

function initDateFormat()
{
	return "";
}

function initTimeFormat()
{
	return "";
}

function initAddcol()
{
	var str ='<div id="addcol" class="propertyDiv"><a href="#" class="hisui-linkbutton" style="" onclick="Addcol()">添加列属性</a></div>';
    return str;
}

function initScripts()
{
	var str ='<div id="addscipts" class="propertyDiv"><a href="#" class="hisui-linkbutton" style="" onclick="AddScipts()">添加脚本</a></div>';
    return str;
}

function initURL()
{
	var str ='<div id="url" class="propertyDiv"><a href="#" class="hisui-linkbutton" style="" onclick="AddURL()">添加数据源</a></div>';
    return str;
}

function selectQuestion(questType,data)
{
	if (questType == "text")
	{
		addText(data);
	}
	else if(questType == "textarea")
	{
		addTextarea(data);
	}
	else if(questType == "radio")
	{
		addRadio(data);
	}
	else if(questType == "checkbox")
	{
		addCheckbox(data);
	}
	else if(questType == "combobox")
	{
		addCombobox(data);
	}
	else if(questType == "datagrid")
	{
		addDatagrid(data);
	}
	else if(questType == "number")
	{
		addNumber(data);
	}
	else if(questType == "date")
	{
		addDate(data);
	}
	else if(questType == "time")
	{
		addTime(data);
	}
}

function addText(data)
{
	var html = $('<div class="box"><div class="name">单行文本</div><div class=""><input class="textbox addtextbox" id="defaultInput" style=""></div></div>');
 	setElement("text",html);
}

function addTextarea(data)
{
	var html = $('<div id="textarea" class="box"><div class="name">多行文本</div><div class=""><textarea id="defaultInput" class="textbox addtextbox" rows="6" cols="60" style="overflow:hidden;"></textarea></div>');
 	setElement("text",html);
}

function addRadio(data)
{
	var dataset = getPropertyByData(data,"dataset");
	
	var arrangeType = getPropertyByData(data,"arrangeType");
	
	var content = '<div class="name">单选框</div>';
	for (var i=0;i<dataset.length;i++)
    {
        var desc = dataset[i].Desc;
        var code = dataset[i].Code;
        if (arrangeType == "col")
        {
	        content = content + '<div><input class="hisui-radio" id="" value='+code+' type="radio" name="newRadio" label='+desc+'></div>';
        }
        else
        {
        	content = content + '<input class="hisui-radio" id="" value='+code+' type="radio" name="newRadio" label='+desc+'>';
        }
    }
    		
	var html = $('<div class="box"></div>');
	$(html).append(content);
 	setElement("radio",html);
}

function addCheckbox(data)
{
	var dataset = getPropertyByData(data,"dataset");
	
	var arrangeType = getPropertyByData(data,"arrangeType");
	
	var content = '<div class="name">多选框</div>';
	for (var i=0;i<dataset.length;i++)
    {
        var desc = dataset[i].Desc;
        var code = dataset[i].Code;
        if (arrangeType == "col")
        {
	        content = content + '<div><input class="hisui-checkbox" id="" value='+code+' type="checkbox" name="newCheckbox" label='+desc+'></div>';       
        }
        else
        {
        	content = content + '<input class="hisui-checkbox" id="" value='+code+' type="checkbox" name="newCheckbox" label='+desc+'>';     
        }  
    }
    		
	var html = $('<div class="box"></div>');
	$(html).append(content);
 	setElement("checkbox",html);
}

function addCombobox(data)
{
	var dataset = getPropertyByData(data,"dataset");
	
	var content = '<div class="name">下拉框</div><select id="combobox" class="hisui-combobox" name="newcombobox" style="width:300px;" data-options="">';
	for (var i=0;i<dataset.length;i++)
    {
        var desc = dataset[i].Desc;
        var code = dataset[i].Code;
        content = content + '<option value='+code+'>'+desc+'</option>';  
    }
    content = content + '</select>';
    		
	var html = $('<div class="box"></div>');
	$(html).append(content);
 	setElement("combobox",html);
}

function addDatagrid(data)
{	
	var colData = getPropertyByData(data,"addcol");
	var headHtml = $('<thead></thead>');
	var tr = $('<tr></tr>');
	for (var i=0;i<colData.length;i++)
    {
        var th = $('<th>'+colData[i].title+'</th>');
        if (colData[i].editor == "combobox")
        {
	        $(th).attr('data-options', 'field:"'+colData[i].field+'",width:150,formatter:function(value,row){return row.Desc;},editor:'+ JSON.stringify(colData[i].editor));
        }
        else
        {
	        $(th).attr('data-options', 'field:"'+colData[i].field+'",width:150,editor:'+ JSON.stringify(colData[i].editor));
        }
        
        $(tr).append(th);
    }
    $(headHtml).append(tr);
    
    var html = $('<div class="box"></div>');
    
    var table = $('<div class="name">表格</div><table id="dg" class="hisui-datagrid" title="表格" style="width:690px;height:auto" data-options="iconCls: \'icon-edit\',headerCls:\'panel-header-gray\',singleSelect: true,toolbar: \'#tb\',onClickCell: onClickCell,onEndEdit: onEndEdit"></table>');   
    $(table).append(headHtml);
    
    var toolbar = '<div id="tb" style="height:auto"><a href="javascript:void(0)" class="hisui-linkbutton" data-options="iconCls:\'icon-add\',plain:true" onclick="append()">新增</a><a href="javascript:void(0)" class="hisui-linkbutton" data-options="iconCls:\'icon-remove\',plain:true" onclick="removeit()">删除</a></div>'
    
    $(html).append(table);
    $(html).append(toolbar);
    setElement("datagrid",html);
}

function combFormatter(value,row)
{
	return row.Desc;
}

function getTableHtml(data)
{
	var result = '<thead><tr>';
	
	for (var i=0;i<data.length;i++)
    {
        result = result + '<th data-options="field:'+data[i].field+',width:150,formatter:function(value,row){return row.Desc;},editor:\''+ JSON.stringify(data[i].editor) +'\'">'+data[i].title+'</th>';
    }
	
	result = result + '</tr></thead>';
	return result;
}

function addNumber(data)
{
	var html = $('<div class="box"><div class="name">数字</div><div class=""><input id="newNumber" class="hisui-numberbox textbox longInput" type="text"></input></div></div>');
 	setElement("number",html);
}

function addDate(data)
{
	var html = $('<div class="box"><div class="name">日期</div><div class=""><input id="newDate" class="hisui-datebox textbox" data-options="" style="width:200px;"></div></div>');
 	setElement("date",html);
}

function addTime(data)
{
	var html = $('<div class="box"><div class="name">时间</div><div class=""><input class="hisui-timespinner" data-options="showSeconds:true" style="border-radius: 2px;width:200px;"></div></div>');
 	setElement("time",html);
}

function setElement(questType,html)
{
	currentType = questType;
	var basecode = getBasecode();
 	if (basecode == "") return;
	$('#content').empty();
	$('#property').empty();
		
	$('#content').append(html);
 	$.parser.parse('#content');
 	getProperty(questType,"init");
}

function getPropty(data)
{
	var obj = {};
	for (var i=0;i<data.length;i++)
    {
        var code = data[i].Code;
        if (code == "title")
        {
	        obj.title = getTitle();
        }
        else if(code == "code")
        {
	        obj.code = getCode();
        }
        else if(code == "required")
        {
	        obj.required = getRequired();
        }
        else if(code == "minlength")
        {
	        obj.minlength = getMinlength();
        }
        else if(code == "maxlength")
        {
	        obj.maxlength = getMaxlength();
        }
        else if(code == "defaultdata")
        {
	        obj.defaultdata = getDefaultdata();
        }
        else if(code == "inputBoxSize")
        {
	        obj.inputBoxSize = getInputBoxSize();
        }
        else if(code == "dataset")
        {
	        obj.dataset = getDataset();
        }
        else if(code == "arrangeType")
        {
	        obj.arrangeType = getArrangeType();
        }
        else if(code == "optionType")
        {
	        obj.optionType = getOptionType();
        }
        else if(code == "minValue")
        {
	        obj.minValue = getMinValue();
        }
        else if(code == "maxValue")
        {
	        obj.maxValue = getMaxValue();
        }
        else if(code == "decimalDigits")
        {
	        obj.decimalDigits = getDecimalDigits();
        }
        else if(code == "includeMax")
        {
	        obj.includeMax = getIncludeMax();
        }
        else if(code == "includeMin")
        {
	        obj.includeMin = getIncludeMin();
        }
        else if(code == "dateFormat")
        {
	        obj.dateFormat = getDateFormat();
        }
        else if(code == "timeFormat")
        {
	        obj.timeFormat = getTimeFormat();
        }
        else if(code == "addcol")
        {
	        obj.addcol = getAddcol();
        }
        else if(code == "scripts")
        {
	        obj.scripts = getScripts();
        }
        else if(code == "url")
        {
	        obj.url = getURL();
        }
    }
    return obj;
}

function getTitle()
{
	var result = $("#title").val();	
	return result;
}

function getCode()
{
	var result = $("#code").val();	
	return result;
}

function getRequired()
{
	var result = $("input[name='required']:checked").val();
	if (typeof(result) == "undefined") {result = "";}
	return result;
}

function getMinlength()
{
	var result = $("#minlength").val();	
	return result;
}

function getMaxlength()
{
	var result = $("#maxlength").val();	
	return result;
}

function getDefaultdata()
{
	var result = $("#defaultdata").val();	
	return result;
}

function getInputBoxSize()
{
	var result = $("input[name='inputBoxSize']:checked").val();
	if (typeof(result) == "undefined") {result = "";}
	return result;
}

function getDataset()
{
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
	
	var result = JSON.stringify(Choices);
	return result;
	
}

function getArrangeType()
{
	var result = $("input[name='arrangeType']:checked").val();
	if (typeof(result) == "undefined") {result = "";}
	return result;
}

function getOptionType()
{
	var result = $("input[name='optionType']:checked").val();
	if (typeof(result) == "undefined") {result = "";}
	return result;
}

function getMinValue()
{
	var result = $("#minValue").val();	
	return result;
}

function getMaxValue()
{
	var result = $("#maxValue").val();	
	return result;
}

function getDecimalDigits()
{
	var result = $("#decimalDigits").val();	
	return result;
}

function getIncludeMax()
{
	var result = $("input[name='includeMax']:checked").val();
	if (typeof(result) == "undefined") {result = "";}
	return result;
}

function getIncludeMin()
{
	var result = $("input[name='includeMin']:checked").val();
	if (typeof(result) == "undefined") {result = "";}
	return result;
}

function getDateFormat()
{
	return "";
}

function getTimeFormat()
{
	return "";
}

function getAddcol()
{
	var result = $("#addcol").val();	
	return result;
}

function getScripts()
{
	var result = $("#addscipts").val();	
	return result;
}

function getURL()
{
	var result = $("#url").val();	
	return result;
}

function getQuestValue(questID)
{
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLQuestDataSub",
					"Method":"GetDataSub",			
					"p1":questID
				},
			success : function(d) {
	           		if (d != "")
	           		{
		           		data = eval("("+d+")");
		           		selectQuestion(currentType,data);
		           		setQuestValue(data);
	           		}
			},
			error : function(d) { alert("getQuestValue error");}
		});	
}

function setQuestValue(data)
{
	var obj = {};
	for (var i=0;i<data.length;i++)
    {
        var code = data[i].PropertyCode;
		var value = data[i].PropertyValue;
        if (code == "title")
        {
	        setTitle(value);
	        if ((typeof($(".box .name")) == "object")&&(typeof($(".box .name")[0]) != "undefined"))
	        {
	        	$(".box .name")[0].innerText = value;
	        }
        }
        else if(code == "code")
        {
	        setCode(value);
        }
        else if(code == "required")
        {
	        setRequired(value);
        }
        else if(code == "minlength")
        {
	        setMinlength(value);
        }
        else if(code == "maxlength")
        {
	        setMaxlength(value);
        }
        else if(code == "defaultdata")
        {
	        setDefaultdata(value);
	        $("#defaultInput").val(value);	
        }
        else if(code == "inputBoxSize")
        {
	        setInputBoxSize(value);
        }
        else if(code == "dataset")
        {
	        setDataset(value);
        }
        else if(code == "arrangeType")
        {
	        setArrangeType(value);
        }
        else if(code == "optionType")
        {
	        setOptionType(value);
        }
        else if(code == "minValue")
        {
	        setMinValue(value);
        }
        else if(code == "maxValue")
        {
	        setMaxValue(value);
        }
        else if(code == "decimalDigits")
        {
	        setDecimalDigits(value);
        }
        else if(code == "includeMax")
        {
	        setIncludeMax(value);
        }
        else if(code == "includeMin")
        {
	        setIncludeMin(value);
        }
        else if(code == "dateFormat")
        {
	        setDateFormat(value);
        }
        else if(code == "timeFormat")
        {
	        setTimeFormat(value);
        }
        else if(code == "addcol")
        {
	        setAddcol(value);
        }
        else if(code == "scripts")
        {
	        setAddscipts(value);
        }
        else if(code == "url")
        {
	        setURL(value);
        }
    }
    return obj;
}

function setTitle(value)
{
	$("#title").val(value);	
}

function setCode(value)
{
	$("#code").val(value);	
}

function setRequired(value)
{
	if (value == "") return;
	$HUI.radio("input[name='required'][value="+ value +"]").setValue(true);
}

function setMinlength(value)
{
	$("#minlength").val(value);	 
}

function setMaxlength(value)
{
	$("#maxlength").val(value);	 
}

function setDefaultdata(value)
{
	$("#defaultdata").val(value);	 
}

function setInputBoxSize(value)
{
	if (value == "") return;
	$HUI.radio("input[name='inputBoxSize'][value="+ value +"]").setValue(true);
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

function setArrangeType(value)
{
	if (value == "") return;
	$HUI.radio("input[name='arrangeType'][value="+ value +"]").setValue(true);
}

function setOptionType(value)
{
	if (value == "") return;
	$HUI.radio("input[name='optionType'][value="+ value +"]").setValue(true);
}

function setMinValue(value)
{
	$("#minValue").val(value);
}

function setMaxValue(value)
{
	$("#maxValue").val(value);
}

function setIncludeMax(value)
{
	if (value == "") return;
	$HUI.radio("input[name='includeMax'][value="+ value +"]").setValue(true);
}

function setIncludeMin(value)
{
	if (value == "") return;
	$HUI.radio("input[name='includeMin'][value="+ value +"]").setValue(true);
}

function setDecimalDigits(value)
{
	$("#decimalDigits").val(value);
}

function setDateFormat(value)
{
	
}

function setTimeFormat(value)
{
	
}

function setAddcol(value)
{
	$("#addcol").val(JSON.stringify(value));
}

function setAddscipts(value)
{
	$("#addscipts").val(JSON.stringify(value));
}

function setURL(value)
{
	$("#url").val(JSON.stringify(value));
}

function getPropertyByData(data,type)
{
	var obj = {};
	var obj = {};
	for (var i=0;i<data.length;i++)
    {
        var code = data[i].PropertyCode;
        if (code == type)
        {
	        obj = data[i].PropertyValue;
        }
    }
    return obj;
}

function Addcol()
{
	var iframeContent = "<iframe id='iframeAddCol' scrolling='no' frameborder='0' src='emr.adddatagridcol.csp?MWToken="+getMWToken()+"' style='width:900px; height:550px; display:block;'></iframe>"
	createModalDialog("AddColDialog","添加列类型","905","590","iframeAddCol",iframeContent,addColCallBack,"");
}

function addColCallBack(returnValue)
{
	if ((returnValue == "")||(typeof(returnValue) == "undefined")) 
	{
		return;
	}
	//var addType = returnValue;
	$("#addcol").val(returnValue);
}

function AddScipts()
{
	var medHistoryType = $("#type").combobox("getValue");
	var iframeContent = "<iframe id='iframeEditScipts' scrolling='no' frameborder='0' src='emr.medhistoryeditscripts.csp?MedHistoryType="+medHistoryType+"&QuestType="+currentType+"&MWToken="+getMWToken()+"' style='width:1000px; height:650px; display:block;'></iframe>"
	createModalDialog("EditSciptsDialog","编辑脚本","1005","690","iframeEditScipts",iframeContent,editSciptsCallBack,"");
}

function editSciptsCallBack(returnValue)
{
	if ((returnValue == "")||(typeof(returnValue) == "undefined")) 
	{
		return;
	}
	//var addscipts = returnValue;
	$("#addscipts").val(returnValue);
}

function AddURL()
{
	var url = $("#url").val();;
	var iframeContent = "<iframe id='iframeAddURL' scrolling='no' frameborder='0' src='emr.medhistoryaddurl.csp?URL="+url+"' style='width:450px; height:250px; display:block;'></iframe>"
	createModalDialog("AddURLDialog","添加数据源","455","290","iframeAddURL",iframeContent,addURLCallBack,"");
}

function addURLCallBack(returnValue)
{
	if ((returnValue == "")||(typeof(returnValue) == "undefined")) 
	{
		return;
	}
	$("#url").val(returnValue);
}

function publish()
{
	var row = $('#questionData').datagrid('getSelected');
	if (row == null) 
	{	
		$.messager.alert("提示信息","请先选中病史题目信息表格中数据！");
		return;
	}
	
	jQuery.ajax({
			type : "POST", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : true,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLQuestionData",
					"Method":"PublishQuestion",			
					"p1":row.QuestionID			
				},
			success : function(d) {
	           		if (d == "1")
	           		{
		           		$.messager.alert("提示信息","发布成功");
		           		var rowindex = $('#questionData').datagrid('getRowIndex',row);
						$('#questionData').datagrid('updateRow',{
						    index: rowindex,
						    row: {
						        IsPublish: "1"
						    }
						});
						$('#saveButton').linkbutton("disable");
	           		}
			},
			error : function(d) { alert("publish error");}
		});
}

function cancel()
{
	var row = $('#questionData').datagrid('getSelected');
	if (row == null) 
	{	
		$.messager.alert("提示信息","请先选中病史题目信息表格中数据！");
		return;
	}
	
	jQuery.ajax({
			type : "POST", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : true,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLQuestionData",
					"Method":"CancelPublishQuestion",			
					"p1":row.QuestionID			
				},
			success : function(d) {
	           		if (d == "1")
	           		{
		           		$.messager.alert("提示信息","取消发布成功");
		           		var rowindex = $('#questionData').datagrid('getRowIndex',row);
						$('#questionData').datagrid('updateRow',{
						    index: rowindex,
						    row: {
						        IsPublish: "0"
						    }
						});
						$('#saveButton').linkbutton("enable");
	           		}
	           		else if(d == "-1")
	           		{
		           		$.messager.alert("提示信息","该题已被医护人员填写保存，不可取消发布，请复制本题后作废！");
	           		}
			},
			error : function(d) { alert("cancelpublish error");}
		});
}

function remove()
{
	var row = $('#questionData').datagrid('getSelected');
	if (row == null) 
	{	
		$.messager.alert("提示信息","请先选中病史题目信息表格中数据！");
		return;
	}
	jQuery.ajax({
			type : "POST", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : true,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLQuestionData",
					"Method":"RemoveQuestion",			
					"p1":row.QuestionID			
				},
			success : function(d) {
	           		if (d == "1")
	           		{
		           		$.messager.alert("提示信息","作废成功");
		           		var rowindex = $('#questionData').datagrid('getRowIndex',row);
						$('#questionData').datagrid('deleteRow',rowindex);
	           		}
			},
			error : function(d) { alert("remove error");}
		});
}

function moveup()
{
	var row = $('#questionData').datagrid('getSelected');
	if (row == null) 
	{	
		$.messager.alert("提示信息","请先选中病史题目信息表格中数据！");
		return;
	}
	jQuery.ajax({
			type : "POST", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : true,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLQuestionData",
					"Method":"MoveSequence",			
					"p1":row.QuestionID,
					"p2":"UP"			
				},
			success : function(d) {
	           		if (d == "1")
	           		{
		           		$.messager.alert("提示信息","上移成功");
		           		var rowindex = $('#questionData').datagrid('getRowIndex',row);
						$('#questionData').datagrid('insertRow',{"index":rowindex-1,"row":row});
						$('#questionData').datagrid('deleteRow',rowindex+1);
						$('#questionData').datagrid('selectRow',rowindex-1);
	           		}
			},
			error : function(d) { alert("moveup error");}
		});
}

function movedown()
{
	var row = $('#questionData').datagrid('getSelected');
	if (row == null) 
	{	
		$.messager.alert("提示信息","请先选中病史题目信息表格中数据！");
		return;
	}
	
	jQuery.ajax({
			type : "POST", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : true,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLQuestionData",
					"Method":"MoveSequence",			
					"p1":row.QuestionID,
					"p2":"DOWN"			
				},
			success : function(d) {
	           		if (d == "1")
	           		{
		           		$.messager.alert("提示信息","下移成功");
		           		var rowindex = $('#questionData').datagrid('getRowIndex',row);
						$('#questionData').datagrid('insertRow',{"index":rowindex+2,"row":row});
						$('#questionData').datagrid('deleteRow',rowindex);
						$('#questionData').datagrid('selectRow',rowindex+1);
	           		}
			},
			error : function(d) { alert("movedown error");}
		});
}

function copy()
{
	var row = $('#questionData').datagrid('getSelected');
	if (row == null) 
	{	
		$.messager.alert("提示信息","请先选中病史题目信息表格中数据！");
		return;
	}
	
	jQuery.ajax({
			type : "POST", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLQuestionData",
					"Method":"CopyData",			
					"p1":row.QuestionID		
				},
			success : function(d) {
	           		if (d != "")
	           		{
		           		$.messager.alert("提示信息","复制成功");
		           		$('#questionData').datagrid('appendRow',{
							QuestionID: d,
							QuestionTitle: row.QuestionTitle,
							QuestionType: row.QuestionType,
							MedHistoryType: row.MedHistoryType,
							QuestionTypeCode: row.QuestionTypeCode,
							IsPublish: 0
						});
						var rows=$("#questionData").datagrid("getRows").length;
						$('#questionData').datagrid('selectRow',rows-1);
	           		}
			},
			error : function(d) { alert("copy error");}
		});
}

function operatePublish(val,row,index)
{
	if (row.IsPublish == "1")
	{
		var span = '<span>已发布</span>';  
		return span;
	}
	else if (row.IsPublish == "-1")
	{
		var span = '<span>作废</span>';  
		return span;
	}
	else
	{
		var span = '<span>未发布</span>';  
		return span;
	}
}

//封装基础平台websys_getMWToken()方法
function getMWToken()
{
    try{
        if (typeof(websys_getMWToken) != "undefined")
            return websys_getMWToken();
        return "";
    }catch(e) {
        return "";
    }
}