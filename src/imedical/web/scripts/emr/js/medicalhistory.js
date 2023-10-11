$(function(){
	initBackground();
	getPatinentInfo();
	initCategory();
	initMedicalHistory();
	setMedHistoryLog("EMR.MedHistory.Login");
});

//加载患者信息
function getPatinentInfo()
{
    
    jQuery.ajax({
			type : "POST", 
			dataType : "text",
			url : "../EMRservice.Ajax.MedicalHistory.cls",
			async : true,
			data : {
					"Action":"GetPatientInfo",			
					"PatientID":patientID,			
					"HospitalID":hospitalID
				},
			success : function(d) {
	           		if (d != "")
		            {
		            	setPatientInfo(eval(d));
		            }
			},
			error : function(d) { alert("getPatinentInfo error");}
		});
}
//设置患者信息
function setPatientInfo(patientInfo) {
	if ("undefined"==typeof HISUIStyleCode || HISUIStyleCode==""){
		// 炫彩版
		var patTextCss = "patTextColor";
	}else if (HISUIStyleCode=="lite"){
		// 极简版
		var patTextCss = "patTextEasy";
	}else{
		// 炫彩版
		var patTextCss = "patTextColor";
	}
	
	var htmlStr = ""
	if (patientInfo[0].gender == "男")
	{
		var sexCss = "man";
		if (patTextCss == "patTextEasy") {sexCss = "manCss";}
		htmlStr = htmlStr + "<img class='"+sexCss+"'>";
	}
	else if (patientInfo[0].gender == "女")
	{
		var sexCss = "woman";
		if (patTextCss == "patTextEasy") {sexCss = "womanCss";}
		htmlStr = htmlStr + "<img class='"+sexCss+"'>";
	}
	
	htmlStr = htmlStr + '<span style="margin: 0px 5px 0px 48px;">'
			+ patientInfo[0].name + '</span>';
	
	htmlStr = htmlStr + '<span>/</span>';
	
	htmlStr = htmlStr + '<span style="margin: 0px 10px;">'
			+ patientInfo[0].gender + '</span>';
	
	htmlStr = htmlStr + '<span>/</span>';
	
	htmlStr = htmlStr + '<span style="margin: 0px 10px;">'
			+ patientInfo[0].age + '</span>';
	
	htmlStr = htmlStr + '<span>/</span>';
	
	htmlStr = htmlStr + '<span style="margin: 0px 0px 0px 10px;">登记号:</span>';
	
	htmlStr = htmlStr + '<span style="margin: 0px 10px;" class="'+patTextCss+'">'
			+ patientInfo[0].papmiNo + '</span>';
			
	htmlStr = htmlStr + '<span>出生日期:</span>';
	
	htmlStr = htmlStr + '<span style="margin: 0px 10px;" class="'+patTextCss+'">'
			+ patientInfo[0].birthday + '</span>';

	$('#patientInfo').append(htmlStr);
	jQuery(".patientInfo").css("display", "inline-block");
}

function initCategory()
{
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLMedicalHistoryType",
					"Method":"GetTypeCategory"
				},
			success : function(d) {
	           		if (d != "")
	           		{
		           		data = eval("("+d+")");
		           		setCategory(data);
	           		}
			},
			error : function(d) { alert("initCategory error");}
		});	
}

//用tree方法加载目录
function setCategory(data)
{
    $('#CategoryTree').tree({  
        lines:true,
        data:data,
        onSelect:function(node){
           if ((typeof(node.rowid) == "undefined")||(node.rowid == "")) return;
           var boxid = node.rowid + "cate";
           document.getElementById(boxid).scrollIntoView();
        },
        lines:true,autoNodeHeight:true	 
    });
}

function initMedicalHistory()
{
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"Stream",
					"Class":"EMRservice.BL.BLMedicalHistory",
					"Method":"GetMedHistoryQuesData",			
					"p1":patientID
				},
			success : function(d) {
	           		if (d != "")
	           		{
		           		data = eval("("+d+")");
		           		setMedHistory(data);
	           		}
			},
			error : function(d) { alert("initMedicalHistory error");}
		});	
}

function setMedHistory(data)
{
	for (var i=0;i<data.length;i++)
    {
	    var type = data[i].Code;
	    var desc = data[i].Desc;
	    
	    var boxid = data[i].Id + "box";
	    var cateID = data[i].Id + "cate";
	    $('#content').append('<div id='+cateID+'></div><div id='+boxid+' class="hisui-panel medBox" data-options="title:\''+desc+'\',border:true,headerCls:\'panel-header-gray\',iconCls:\'icon-paper\'"></div>');
	    
	    if (type == "HDSD00.13.037")
	    {
		    addAllergy(boxid);
	    }
	    else
	    {
	    	getQuestData(type,boxid);
	    }
	    if (i == data.length-1)
		{
			$("#"+boxid).addClass("boxbottom");
		}		        
    }
    //addSaveButton();
	$.parser.parse('#content');
}

var editIndex=undefined;
var activedgid=undefined;
var modifyBeforeRow = {};
var modifyAfterRow = {};
function endEditing(dgid){
		if (activedgid == undefined){return true}
		if (editIndex == undefined){return true}
		if ($('#'+dgid).datagrid('validateRow', editIndex)){
			//列表中下拉框实现，修改后把回写Desc，因为formatter显示的是desc字段
			
			//解决下拉框显示所选描述问题
			var editors = $('#'+dgid).datagrid('getEditors', editIndex);
			for (var i=0;i<editors.length;i++)
    		{
	    		if (editors[i].type == "combobox")
	    		{
		    		var ed = $('#'+dgid).datagrid('getEditor', {index:editIndex,field:editors[i].field});
					if (ed){
						var Desc = $(ed.target).combobox('getText');
						$('#'+dgid).datagrid('getRows')[editIndex][editors[i].field + 'Desc'] = Desc;
					}
	    		}
    		}
			
			$('#'+dgid).datagrid('endEdit', editIndex);
			modifyAfterRow = $('#'+dgid).datagrid('getRows')[editIndex];
			var aStr = JSON.stringify(modifyAfterRow);
			var bStr = JSON.stringify(modifyBeforeRow);
        editIndex = undefined;
        return true;
    } else {
        return false;
    }
}
function onClickCell(index, field){
    if (editIndex != index){
        if (endEditing($(this).attr("id"))){
            $(this).datagrid('selectRow', index)
                    .datagrid('beginEdit', index);
            var ed = $(this).datagrid('getEditor', {index:index,field:field});
            if (ed){
                ($(ed.target).data('textbox') ? $(ed.target).textbox('textbox') : $(ed.target)).focus();
            }
            editIndex = index;
			modifyBeforeRow = $.extend({},$(this).datagrid('getRows')[editIndex]);
        } else {
            setTimeout(function(){
                $(this).datagrid('selectRow', editIndex);
            },0);
        }
    }
}

function onClickRow(index){
	if ((activedgid != $(this).attr("id"))||(editIndex!=index)) {
		if (endEditing(activedgid)){
			$(this).datagrid('selectRow', index)
					.datagrid('beginEdit', index);
			activedgid = $(this).attr("id");
			editIndex = index;
			modifyBeforeRow = $.extend({},$(this).datagrid('getRows')[editIndex]);
			
			var dgid = $(this).attr("id");
			var quesID = dgid.replace(/dg/g, '');
	        var scripts = $('#'+quesID).attr("scripts");
	        if (scripts != "{}")
	        {
		        var curScripts = getScriptByTrigger(eval("("+scripts+")"),"datagridSelect")
		        for(var i=0;i<curScripts.length;i++)
				{		
					var scriObj = curScripts[i];
					//增加级联脚本
		    		if (scriObj.typeCode == "setLinkData")
		    		{
			    		var ed = $('#'+dgid).datagrid('getEditor', { index: editIndex, field: scriObj.TriField });
			    		var valueOld = $(ed.target).combobox('getValue');
					    $(ed.target).combobox({ onSelect: function (record) {
							var code = record.Code;
					        var linktarget = $('#'+dgid).datagrid('getEditor',{'index':editIndex,'field':scriObj.LinkField}).target;
			                linktarget.combobox('clear');
			                var linkData = getLinkData(code,record.Desc,scriObj);
			                linktarget.combobox('loadData',linkData);
			                if (linkData.length > 0)
			                {
			                	linktarget.combobox('setValue',linkData[0].Code);
			                }

						}
						});
						if (valueOld != "")
						{
							$(ed.target).combobox('setValue',valueOld);
						}
						else
						{
							$(ed.target).combobox('clear');
						}
		    		}
				}
	    		
	        }
			
			//绑定回车新增行事件（只有文本输入框可响应）
			var editors = $('#'+dgid).datagrid('getEditors', editIndex);
			for (var i=0;i<editors.length;i++)
    		{
	    		var editor = editors[i];
				$(editor.target).bind('keyup', function (e) {
					var code = e.keyCode || e.which;
					if (code == 13) {
			    		append(dgid);
					}
				});
    		}
	        
	        /*var editors = $('#'+dgid).datagrid('getEditors', editIndex);
			for (var i=0;i<editors.length;i++)
    		{
	    		if (editors[i].type == "combobox")
	    		{
		    		var ed = $('#'+dgid).datagrid('getEditor', {index:editIndex,field:editors[i].field});
					if (ed){
						var Desc = $(ed.target).combobox('getText');
						if (Desc == "")
						{
							$(ed.target).combobox('clear');
						}
						
					}
	    		}
    		}*/
			
		} else {
			$(this).datagrid('selectRow', editIndex);
		}
	}
}

function onEndEdit(index, row){
    var ed = $(this).datagrid('getEditor', {
        index: index,
        field: 'productid'
    });
}
function append(dgid){
    if (endEditing(activedgid)){
        var length = $('#'+dgid).datagrid('getRows').length;
    	if (length != "0")
    	{
	    	var lastRow = $('#'+dgid).datagrid('getData').rows[length - 1];
	    	var hasValue = "0";
	    	Object.keys(lastRow).forEach(function(key){
				if (lastRow[key] != "")
				{
					hasValue = "1";
				}
				
			});
			if (hasValue == "0")
			{
				$.messager.alert("提示信息","表格最后一行为空数据，请填写后再新增！");
				return;
			}
    	}
        
        $('#'+dgid).datagrid('appendRow',{});
        editIndex = $('#'+dgid).datagrid('getRows').length-1;
        $('#'+dgid).datagrid('selectRow', editIndex)
                .datagrid('beginEdit', editIndex);
                
        activedgid = dgid;
        var quesID = dgid.replace(/dg/g, '');
        var scripts = $('#'+quesID).attr("scripts");
        if (scripts != "{}")
        {
	        var curScripts = getScriptByTrigger(eval("("+scripts+")"),"datagridSelect")
	        for(var i=0;i<curScripts.length;i++)
			{		
				var scriObj = curScripts[i];
				//增加级联脚本
	    		if (scriObj.typeCode == "setLinkData")
	    		{
		    		var ed = $('#'+dgid).datagrid('getEditor', { index: editIndex, field: scriObj.TriField });
				    $(ed.target).combobox({ onSelect: function (record) {
						var code = record.Code;
				        var linktarget = $('#'+dgid).datagrid('getEditor',{'index':editIndex,'field':scriObj.LinkField}).target;
		                linktarget.combobox('clear');
		                var linkData = getLinkData(code,record.Desc,scriObj);
		                linktarget.combobox('loadData',linkData);
		                if (linkData.length > 0)
		                {
		                	linktarget.combobox('setValue',linkData[0].Code);
		                }

					}
					});
					$(ed.target).combobox('clear');
	    		}
			}
        }
        
        //绑定回车新增行事件（只有文本输入框可响应）
		var editors = $('#'+dgid).datagrid('getEditors', editIndex);
		for (var i=0;i<editors.length;i++)
		{
    		var editor = editors[i];
			$(editor.target).bind('keyup', function (e) {
				var code = e.keyCode || e.which;
				if (code == 13) {
		    		append(dgid);
				}
			});
		}
        
        /*var ed = $('#'+dgid).datagrid('getEditor', { index: editIndex, field: '1' });
			    $(ed.target).combobox({ onSelect: function (record) {
					var a = record;
					alert(record.Code);
			        //$('#List2').datagrid('acceptChanges');
			        //setTotal('List2', 'col3', 'Summation_1');//合计车辆总数，设置总数

			    }
			});
		$(ed.target).combobox('clear');*/
		
		/*var ed = $('#'+dgid).datagrid('getEditor', { index: editIndex, field: 'delete' });
		    $(ed.target).bind('click', function(){
				deleteRow(dgid,editIndex);
		    });*/
	}
}

function getScriptByTrigger(scriptObj,trigger)
{
	var Scripts = new Array();
	for(var i=0;i<scriptObj.length;i++)
	{		
		if (trigger == scriptObj[i].trigger)
		{
			Scripts.push(scriptObj[i]);
		}  
	}
	return Scripts;
}

function getLinkData(code,desc,obj)
{
	var result = [];
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":obj.ClassName,
					"Method":obj.MethodName,			
					"p1":code,
					"p2":desc
				},
			success : function(d) {
	           		if (d != "")
	           		{
		           		result = eval("("+d+")");
	           		}
			},
			error : function(d) { alert("getLinkData error");}
		});	
	
	return result;
}

function removeit(dgid){
    var length = $('#'+dgid).datagrid('getRows').length;
    if (length == "0"){return}
    
    var selectRow = $('#'+dgid).datagrid('getSelected');
    if (selectRow == null) return;
    
    if (endEditing(activedgid)){
    
	    editIndex = $('#'+dgid).datagrid('getRowIndex',selectRow);
	    
	    if (editIndex == undefined){return}
	    activedgid = dgid;
	    $('#'+dgid).datagrid('cancelEdit', editIndex)
	            .datagrid('deleteRow', editIndex);
	    if (editIndex > 0)
	    {
		    editIndex = editIndex - 1;
		    $('#'+dgid).datagrid('selectRow',editIndex);
	    }
	    else
	    {
	    	editIndex = undefined;
	    }
	    /*$('#'+dgid).datagrid('acceptChanges');
	    var value = $('#'+dgid).datagrid('getRows');
	    for (var i=value.length-1;i>=0;i--)
	    {
		    if (value[i]["delete"] == "1")
		    {
	            $('#'+dgid).datagrid('deleteRow', i);
		    }
	    }
	    var length = $('#'+dgid).datagrid('getRows').length;
	    for (var i=0;i<length;i++)
	    {
		    $('#'+dgid).datagrid('beginEdit', i);
	    }*/
    }
}

function deleteRow(dgid,rowIndex)
{
	$('#'+dgid).datagrid('deleteRow', rowIndex);
}

function acceptit(dgid){
    if (endEditing(dgid)){
        $('#'+dgid).datagrid('acceptChanges');
    }
}  

function acceptChanges(dgid){
		var selectRow = $('#'+dgid).datagrid('getSelected');
    	if (selectRow == null) {return true}
    	editIndex = $('#'+dgid).datagrid('getRowIndex',selectRow);
    	
		if (editIndex == undefined){return true}
		if ($('#'+dgid).datagrid('validateRow', editIndex)){
			//列表中下拉框实现，修改后把回写Desc，因为formatter显示的是desc字段
			
			var editors = $('#'+dgid).datagrid('getEditors', editIndex);
			for (var i=0;i<editors.length;i++)
    		{
	    		if (editors[i].type == "combobox")
	    		{
		    		var ed = $('#'+dgid).datagrid('getEditor', {index:editIndex,field:editors[i].field});
					if (ed){
						var Desc = $(ed.target).combobox('getText');
						$('#'+dgid).datagrid('getRows')[editIndex][editors[i].field + 'Desc'] = Desc;
					}
	    		}
    		}
			
			$('#'+dgid).datagrid('endEdit', editIndex);
			modifyAfterRow = $('#'+dgid).datagrid('getRows')[editIndex];
			var aStr = JSON.stringify(modifyAfterRow);
			var bStr = JSON.stringify(modifyBeforeRow);
        editIndex = undefined;
        return true;
    } else {
        return false;
    }
}   

function addQuestion(questType,data,title,questID,value,boxid)
{
	if (questType == "text")
	{
		addText(data,title,questID,value,boxid);
	}
	else if(questType == "textarea")
	{
		addTextarea(data,title,questID,value,boxid);
	}
	else if(questType == "radio")
	{
		addRadio(data,title,questID,value,boxid);
	}
	else if(questType == "checkbox")
	{
		addCheckbox(data,title,questID,value,boxid);
	}
	else if(questType == "combobox")
	{
		addCombobox(data,title,questID,value,boxid);
	}
	else if(questType == "datagrid")
	{
		addDatagrid(data,title,questID,value,boxid);
	}
	else if(questType == "number")
	{
		addNumber(data,title,questID,value,boxid);
	}
	else if(questType == "date")
	{
		addDate(data,title,questID,value,boxid);
	}
	else if(questType == "time")
	{
		addTime(data,title,questID,value,boxid);
	}
}

function addText(data,title,questID,value,boxid)
{
	var html = $('<div class="box"><div class="name">'+title+'</div><div class="" style="width:550px;"><input class="textbox addtextbox" id="defaultInput"></div></div>');
 	var scripts = getPropertyByData(data,"scripts");
 	$(html).attr({"id":questID,"questType":"text","scripts":JSON.stringify(scripts)});
 	var required = getPropertyByData(data,"required");
 	if (required == "true")
	{
		$('#'+questID+" .name").prepend('<span class="requiredFlag">*</span>');
		$(html).attr({"needValue":required});
	}
 	setElement("text",html,boxid);
 	setText(questID,value);
}

function addTextarea(data,title,questID,value,boxid)
{
	var html = $('<div id="textarea" class="box"><div class="name">'+title+'</div><div ><textarea id="defaultInput" class="textbox" rows="5" cols="80" style="width:99.2%;"></textarea></div>');
 	var scripts = getPropertyByData(data,"scripts");
 	$(html).attr({"id":questID,"questType":"textarea","scripts":JSON.stringify(scripts)});
 	var required = getPropertyByData(data,"required");
 	if (required == "true")
	{
		$('#'+questID+" .name").prepend('<span class="requiredFlag">*</span>');
		$(html).attr({"needValue":required});
	}
 	setElement("textarea",html,boxid);
 	setTextarea(questID,value);
}

function addRadio(data,title,questID,value,boxid)
{
	var dataset = getPropertyByData(data,"dataset");
	var scripts = getPropertyByData(data,"scripts");
	var arrangeType = getPropertyByData(data,"arrangeType");
	var choice = value.split("|");
	value = choice[0];
	var content = '<div class="name">'+title+'</div>';
	for (var i=0;i<dataset.length;i++)
    {
        var desc = dataset[i].Desc;
        var code = dataset[i].Code;
        var id = questID + code;
        var checkFlag = "0";
        if (arrangeType == "col")
        {
	        content = content + '<div class="radioCol">';
        }
        if (((value == "")&&(i == 0))||((value != "")&&(value == code)))
        {
	        checkFlag = "1";
        }
        if (checkFlag == "1")
        {
	        content = content + '<input class="hisui-radio" id='+id+' value='+code+' checked="true" type="radio" name='+questID+' label='+desc+'>';
        }
        else
        {
        	content = content + '<input class="hisui-radio" id='+id+' value='+code+' type="radio" name='+questID+' label='+desc+'>';
        }
        if (arrangeType == "col")
        {
	        content = content + '</div>';
        }
        else
        {
	        content = content + '<span class="radioRow"></span>';
        }
    }
    		
	var html = $('<div class="box"></div>');
	$(html).append(content);
	$(html).attr({"id":questID,"questType":"radio","scripts":JSON.stringify(scripts)});
	var required = getPropertyByData(data,"required");
 	if (required == "true")
	{
		$('#'+questID+" .name").prepend('<span class="requiredFlag">*</span>');
		$(html).attr({"needValue":required});
	}
 	setElement("radio",html,boxid);
 	//setRadio(questID,value);
 	
 	$HUI.radio("[name="+questID+"]",{
        onChecked:function(e,value){
            var select = $(e.target).attr("value");
            //var id = $(e.target).attr("name");
            var curScripts = getScriptByTrigger(scripts,"choose")
            
            var script = getScriptObj(select,curScripts);
            setShowStatus(script.Action,script.Value);
        }
    });
}

function getScriptObj(code,scripts)
{
	var result = {"trigger":"choose","triAction":"","TriCondition":"","Action":"","Value":"","typeCode":"selectShowHide"};
	if (scripts.length == "0") return;
	for (i=0;i<scripts.length;i++ )
	{
		if ((scripts[i].typeCode == "selectShowHide")&&(scripts[i].TriCondition == code))
		{
			result = scripts[i];
			return result;
		}
	}	
	return result;
}

function setShowStatus(action,data)
{
	if (data == "") return;
	var strs = data.split("^"); 
	for (i=0;i<strs.length;i++ )
	{
		if (document.getElementById(strs[i]) != null)
		{
			if (action == "show")
			{
				document.getElementById(strs[i]).style.display="block"; 
				var scripts = $("#"+strs[i]).attr("scripts");
				
				if ((typeof(scripts)!= "undefined")&&(scripts != "[]"))
				{
					scripts = eval("("+scripts+")");
					var curScripts = getScriptByTrigger(scripts,"load")
					for(var j=0;j<curScripts.length;j++)
					{
						var scriptObj = curScripts[j];
						if (scriptObj.typeCode == "hideThis")
						{
							if ((scriptObj.Condition = "Sex")&&(getPatientSex() == scriptObj.CondValue))
							{
								document.getElementById(strs[i]).style.display="none";
							}
						}
					}
				}
			}
			else if (action == "hide")
			{
				document.getElementById(strs[i]).style.display="none";
			}	
		}
	} 	
}

function addCheckbox(data,title,questID,value,boxid)
{
	var dataset = getPropertyByData(data,"dataset");
	var arrangeType = getPropertyByData(data,"arrangeType");
	
	var content = '<div class="name">'+title+'</div>';
	for (var i=0;i<dataset.length;i++)
    {
        var desc = dataset[i].Desc;
        var code = dataset[i].Code;
        var id = questID + i;
        
        if (arrangeType == "col")
        {
	        content = content + '<div class="checkCol"><input class="hisui-checkbox" id='+id+' value='+code+' type="checkbox" name='+questID+' label='+desc+'></div>';   
        }
        else
        {
        	content = content + '<input class="hisui-checkbox" id='+id+' value='+code+' type="checkbox" name='+questID+' label='+desc+'><span class="checkRow"></span>';   
        }    
    }
    		
	var html = $('<div class="box"></div>');
	$(html).append(content);
	$(html).attr({"id":questID,"questType":"checkbox"});
	var required = getPropertyByData(data,"required");
 	if (required == "true")
	{
		$('#'+questID+" .name").prepend('<span class="requiredFlag">*</span>');
		$(html).attr({"needValue":required});
	}
 	setElement("checkbox",html,boxid);
 	setCheckbox(questID,value);
 	$HUI.checkbox("[name="+questID+"]",{
        onChecked:function(e,value){
            var select = $(e.target).attr("value");
            if (select == "other")
            {
	            $("#"+questID).append($('<div><textarea id="other" class="textbox" rows="5" cols="80" style="width:98.5%;padding:5px 10px 0 0;overflow:hidden;"></textarea></div>'));
            }
        },
        onUnchecked:function(e,value){
	        var select = $(e.target).attr("value");
            if (select == "other")
            {
	            $("#"+questID).find(".textbox").remove();
            }
        }
    });
}

function addCombobox(data,title,questID,value,boxid)
{
	var dataset = getPropertyByData(data,"dataset");
	var cbid = "combobox"+questID;
    var Choices = new Array();
    for (var i=0;i<dataset.length;i++)
    {
        var desc = dataset[i].Desc;
        var code = dataset[i].Code;
        Choices.push({"id":code,"text":desc});  
    }
    
    var content = '<div class="name">'+title+'</div><select id='+cbid+' class="hisui-combobox" name="newcombobox" style="width:300px;" data-options=""></select>';
    	
	var html = $('<div class="box"></div>');
	$(html).append(content);
	$(html).attr({"id":questID,"questType":"combobox","scripts":JSON.stringify(scripts)});
	var required = getPropertyByData(data,"required");
 	if (required == "true")
	{
		$('#'+questID+" .name").prepend('<span class="requiredFlag">*</span>');
		$(html).attr({"needValue":required});
	}
 	setElement("combobox",html,boxid);
 	var scripts = getPropertyByData(data,"scripts");
 	$.parser.parse('#'+questID);
 	$HUI.combobox("#"+cbid,{
		multiple:false,
		selectOnNavigation:false,
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:Choices,
		onChange:function(n,o){
	        var curScripts = getScriptByTrigger(scripts,"choose")
            var script = getScriptObj(n,curScripts);
            if ((script != undefined)&&(script !=""))
            {
            	setShowStatus(script.Action,script.Value);
            }
	    }
	});
 	setCombobox(questID,value,scripts);
}

function addDatagrid(data,title,questID,value,boxid)
{	
	var colData = getPropertyByData(data,"addcol");
	var headHtml = $('<thead></thead>');
	var tr = $('<tr></tr>');
	
	//var th = $('<th>选中</th>');
    //var deleteEditor = {"type":"checkbox","options":{"on":"1","off":"0"}};
    //$(th).attr('data-options', 'field:"delete",width:"16",align:"center",editor:'+ JSON.stringify(deleteEditor));
    //$(th).attr('data-options', 'field:"delete",width:"40"');
    //$(tr).append(th);
	
	for (var i=0;i<colData.length;i++)
    {
        var th = $('<th>'+colData[i].title+'</th>');
        if (colData[i].editor.type == "combobox")
        {
	        //colData[i].editor.options.onChange = "onSelectDgCombobox";
	        $(th).attr('data-options', 'field:"'+colData[i].field+'",width:"'+colData[i].width+'",formatter:function(value,row){return row["'+colData[i].field+'Desc"];},editor:'+ JSON.stringify(colData[i].editor));
	        //$(th).attr('data-options', 'field:"'+colData[i].field+'",width:"'+colData[i].width+'",formatter:combFormatter,onSelect: onSelectDgCombobox,editor:'+ JSON.stringify(colData[i].editor));
	        //$(th).attr('data-options', 'field:"'+colData[i].field+'",width:"'+colData[i].width+'",formatter:combFormatter,editor:'+ JSON.stringify(colData[i].editor));
        }
        else
        {
	        $(th).attr('data-options', 'field:"'+colData[i].field+'",width:"'+colData[i].width+'",editor:'+ JSON.stringify(colData[i].editor));
        }
        
        $(tr).append(th);
    }
    
    /*var th = $('<th>删除</th>');
    var deleteEditor = {type:"linkbutton",options:{iconCls:"icon-remove"}};
    $(th).attr('data-options', 'field:"delete",width:"40",align:"center",editor:'+ JSON.stringify(deleteEditor));
    $(tr).append(th);*/
    
    $(headHtml).append(tr);
    
    var html = $('<div class="box" style="height:300px;"></div>');
    var tableID = "dg"+questID;
    var table = $('<table id="'+ tableID+'" class="hisui-datagrid" title="'+title+'" style="height:500px;" data-options="singleSelect: true,fit:true,rownumbers:true,headerCls:\'panel-header-gray\',toolbar: \'#tb'+questID+'\',onClickRow: onClickRow,onEndEdit: onEndEdit"></table>');
    
    $(table).attr({"id":tableID});   
    $(table).append(headHtml);
    
    //var toolbar = '<div id="tb'+questID+'" style="height:auto"><a id="" href="javascript:void(0)" class="hisui-linkbutton" data-options="iconCls:\'icon-add\',plain:true" onclick="append(\''+tableID+'\')">新增</a><a href="javascript:void(0)" class="hisui-linkbutton" data-options="iconCls:\'icon-remove\',plain:true" onclick="removeit(\''+tableID+'\')">删除</a><a href="javascript:void(0)" class="hisui-linkbutton" data-options="iconCls:\'icon-save\',plain:true" onclick="acceptit(\''+tableID+'\')">保存</a></div>';
    var toolbar = '<div id="tb'+questID+'" style="height:auto"><a id="" href="javascript:void(0)" class="hisui-linkbutton" data-options="iconCls:\'icon-add\',plain:true" onclick="append(\''+tableID+'\')">Add 新增</a><a href="javascript:void(0)" class="hisui-linkbutton" data-options="iconCls:\'icon-remove\',plain:true" onclick="removeit(\''+tableID+'\')">Delete 删除</a></div>';
    
    $(html).append('<div class="name" style="display:none;">'+title+'</div>');
    //$(html).append('<div class="name"></div>');
    $(html).append(table);
    $(html).append(toolbar);
    var scripts = getPropertyByData(data,"scripts");
    $(html).attr({"id":questID,"questType":"datagrid","scripts":JSON.stringify(scripts)});
    
    setElement("datagrid",html,boxid);
    setDatagrid(questID,value,scripts)
    $.parser.parse('#'+questID);
    var required = getPropertyByData(data,"required");
 	if (required == "true")
	{
		$('#'+questID+" .name").prepend('<span class="requiredFlag">*</span>');
		$(html).attr({"needValue":required});
	}
}

function combFormatter(value,row,index)
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

function addNumber(data,title,questID,value,boxid)
{
	var dataObj = changeToObj(data);
	var numID = "Num" + questID;
	var decimalDigits = dataObj.decimalDigits || "\'\'";
	var maxValue = dataObj.maxValue || "\'\'";
	var minValue = dataObj.minValue || "\'\'";
	var html = $('<div class="box"><div class="name">'+title+'</div><div class=""><input id='+numID+' class="hisui-numberbox textbox" data-options="precision:'+decimalDigits+',fix:false,max:'+maxValue+',min:'+minValue+'"></input></div></div>');
 	var scripts = getPropertyByData(data,"scripts");
 	$(html).attr({"id":questID,"questType":"number","scripts":JSON.stringify(scripts)});
 	var required = getPropertyByData(data,"required");
 	if (required == "true")
	{
		$('#'+questID+" .name").prepend('<span class="requiredFlag">*</span>');
		$(html).attr({"needValue":required});
	}
 	setElement("number",html,boxid);
 	setNumber(questID,value);
 	$.parser.parse('#'+questID);
 	
 	$("#"+numID).on('blur',function(e){
		for(var i=0;i<scripts.length;i++)
		{		
			var scriObj = scripts[i];
			if (scriObj.typeCode == "inputShowHide")
			{		
				var value = $(this).numberbox('getValue');
				if (scriObj.TriCondition == "high")
				{
					if (parseFloat(value) > parseFloat(scriObj.TriValue))
					{
						numberShowHide(scriObj.Value,scriObj.Action);
					}
				}
				else if(scriObj.TriCondition == "equal")
				{
					if (parseFloat(value) = parseFloat(scriObj.TriValue))
					{
						numberShowHide(scriObj.Value,scriObj.Action);
					}
				}
				else if(scriObj.TriCondition == "low")
				{
					if (parseFloat(value) < parseFloat(scriObj.TriValue))
					{
						numberShowHide(scriObj.Value,scriObj.Action);
					}
				}
			}
		}
	});
 	
}

function numberShowHide(questID,action)
{
	if (action == "hide")
	{
		$("#"+questID).hide();
	}
	else
	{
		$("#"+questID).show();
	}
}

function addDate(data,title,questID,value,boxid)
{
	var dateid = "date"+questID;
	var content = '<div class="name">'+title+'</div><div class=""><input id='+dateid+' value="'+value+'" class="hisui-datebox textbox" data-options="" style="width:200px;"></div>';
	var html = $('<div class="box"></div>');
	$(html).append(content);
 	$(html).attr({"id":questID,"questType":"date"});
 	var required = getPropertyByData(data,"required");
 	if (required == "true")
	{
		$('#'+questID+" .name").prepend('<span class="requiredFlag">*</span>');
		$(html).attr({"needValue":required});
	}
 	setElement("date",html,boxid);
}

function addTime(data,title,questID,value,boxid)
{
	var html = $('<div class="box"><div class="name">'+title+'</div><div class=""><input id="Time" class="hisui-timespinner" data-options="showSeconds:true" style="border-radius: 2px;width:200px;"></div></div>');
 	$(html).attr({"id":questID,"questType":"time"});
 	var required = getPropertyByData(data,"required");
 	if (required == "true")
	{
		$('#'+questID+" .name").prepend('<span class="requiredFlag">*</span>');
		$(html).attr({"needValue":required});
	}
 	setElement("time",html,boxid);
 	setTime(questID,value);
}

function setElement(questType,html,boxid)
{
	$('#'+boxid).append(html);
}

function getQuestData(historyType,boxid)
{
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"Stream",
					"Class":"EMRservice.BL.BLQuestionData",
					"Method":"GetAllQuestData",			
					"p1":historyType,			
					"p2":patientID
				},
			success : function(d) {
	           		if (d != "")
	           		{
		           		data = eval("("+d+")");
		           		setQuestData(data,boxid);
		           		setQuestValue(data);
	           		}
			},
			error : function(d) { alert("getQuestData error");}
		});	
}

function setQuestData(data,boxid)
{
	for (var i=0;i<data.length;i++)
    {
        var type = data[i].QuestionTypeCode;
		var property = data[i].Property;
		var title = data[i].QuestionTitle;
		var questID = data[i].QuestionID;
		var value = data[i].QuestValue;
		addQuestion(type,property,title,questID,value,boxid);
    }
}

function setQuestValue(data)
{
	for (var i=0;i<data.length;i++)
    {
        var property = data[i].Property;
		var questID = data[i].QuestionID;
		var scripts = getPropertyByData(property,"scripts");
        var type = data[i].QuestionTypeCode;
        
        if (scripts.length > 0)
        {
	        var curScripts = getScriptByTrigger(scripts,"load")
	        for(var j=0;j<curScripts.length;j++)
			{
				var scriptObj = curScripts[j];
				if (scriptObj.typeCode == "hideThis")
				{
					if ((scriptObj.Condition = "Sex")&&(getPatientSex() == scriptObj.CondValue))
			        {
				        document.getElementById(questID).style.display="none";
			        }
				}
			}
        }

		if (type == "radio")
		{
			var select = $("input[name="+questID+"]:checked").val();
			if (scripts.length > 0)
        	{
	            var script = getScriptObj(select,scripts);
	            if (typeof(script) != "undefined")
	            {
	            	setShowStatus(script.Action,script.Value);
	            }
            }
		}
    }
}

function getPatientSex()
{
	var result = "";
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.HISInterface.PatientInfoAssist",
					"Method":"Gender",			
					"p1":patientID,			
					"p2":hospitalID
				},
			success : function(d) {
	           		if (d != "")
	           		{
		           		data = d.split("^");
		           		result = data[2];
	           		}
			},
			error : function(d) { alert("getPatientSex error");}
		});	
	return result;
}

function getPropertyByData(data,type)
{
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

function getScriptActionObj(scripts,actionName)
{
	var data = $.grep(scripts,function(item){ 
	    return item.Action == actionName;
	});
	return data;
}

function addSaveButton()
{
	var html = $('<div class="saveButton"><a href="#" class="hisui-linkbutton" style="width:60px;" onclick="SaveData()">提交</a></div>');
	$('#content').append(html);
}

function SaveData()
{
	var instance = GetData();
	if (instance == "") return;
	jQuery.ajax({
			type : "POST", 
			dataType : "text",
			url : "../EMRservice.Ajax.MedicalHistory.cls",
			async : false,
			data : {
					"Action":"ChangeData",			
					"PatientID":patientID,			
					"QuestDatas":JSON.stringify(instance),
					"UserID":userID
				},
			success : function(d) {
	           		if (d == "1")
	           		{
		           		$.messager.alert("提示信息","保存成功");
		           		setMedHistoryLog("EMR.MedHistory.Save");
	           		}
	           		else
	           		{
		           		$.messager.alert("提示信息","保存失败");
	           		}
			},
			error : function(d) { alert("SaveData error");}
		});
}

function GetData()
{
	var Instance = new Array();
	var needWriteIds = "";
	$('#content .box').each(function()
	{
		var id = $(this).attr('id');
		var type = $(this).attr('questType');
		//var titleInfo = $(this).find(".name")[0].innerText.split("、");
		//var title = titleInfo[1];
		if (document.getElementById(id).style.display != "none")
		{
			var value = getQuestValue(id,type);
			var title = $(this).find(".name")[0].innerText;
			var required = $(this).attr('needValue');
			if (required == "true")
			{
				//去掉必填星号
				if (title != "")
				{
					title = title.substring(1);
				}
				if ((value == "")||(value == "[]"))
				{
					if (needWriteIds != "")
					{
						needWriteIds = needWriteIds + "^";
					}
					needWriteIds = needWriteIds + id;
				}
				else
				{
					$('#'+id).css("background","#FFFFFF");
				}
			}
			Instance.push({"QuestID":id,"QuestName":title,"QuestType":type,"Value":value});
		}
	});
	if (needWriteIds != "")
	{
		$.messager.alert("提示信息","请完成必填项再进行保存！必填项已用粉色背景色标记。");
		signRequired(needWriteIds);
		return "";
	}
	return Instance;
}

function signRequired(needWriteIds)
{
	strs = needWriteIds.split("^"); 
	for (i=0;i<strs.length;i++ )
	{
		//$('#'+strs[i]).css("border","2px solid red");
		$('#'+strs[i]).css("background","#ffe3e3");
	}
}

function getQuestValue(questID,questType)
{
	var value = "";
	if (questType == "text")
	{
		value = getText(questID);
	}
	else if(questType == "textarea")
	{
		value = getTextarea(questID);
	}
	else if(questType == "radio")
	{
		value = getRadio(questID);
	}
	else if(questType == "checkbox")
	{
		value = getCheckbox(questID);
	}
	else if(questType == "combobox")
	{
		value = getCombobox(questID);
	}
	else if(questType == "datagrid")
	{
		value = getDatagrid(questID);
	}
	else if(questType == "number")
	{
		value = getNumber(questID);
	}
	else if(questType == "date")
	{
		value = getDate(questID);
	}
	else if(questType == "time")
	{
		value = getTime(questID);
	}
	return value;
}

function getText(questID)
{
	var value = $("#"+questID).find(".textbox").val();
	return value;
}

function getTextarea(questID)
{
	var value = $("#"+questID).find(".textbox").val();
	return value;
}

function getRadio(questID)
{
	var value = $("input[name="+questID+"]:checked").val();
	var result = value + "|" + $("input[name="+questID+"]:checked").attr("label");
	return result;
}

function getCheckbox(questID)
{
	var value = ""
    $("#"+questID+" input:checkbox[name="+questID+"]:checked").each(function(i){
	   if (value != "")
	   {
		   value = value + "^";
	   }
	   if ($(this).val() == "other")
	   {
		   var tmpValue = $(this).val() + "|" + $("#"+questID).find(".textbox").val();
	   }
	   else
	   {
		   var tmpValue = $(this).val() + "|" + $(this).attr("label");
	   }
	   value = value + tmpValue;
	});
	return value;
}

function getCombobox(questID)
{
	var cbid = "combobox" + questID;
	var value = $("#"+cbid).combobox('getValue');
	var result = value + "|" + $("#"+cbid).combobox('getText');
	return result;
}

function getDatagrid(questID)
{
	var dgid = "dg" + questID;
	acceptChanges(dgid);
	acceptit(dgid);
	var value = $('#'+dgid).datagrid('getRows');
	//var tmpvalue = $('#'+dgid).datagrid('getData');
	var data = $.grep(value,function(item){ 
	    return item.isSave != '0';
	});
	//var jsonSearch = value.filter(function (e) { return e.APP == value; })
	/*if (value.length > 0)
	{
		for (var i=0;i<value.length;i++)
	    {
		    if (endEditing(dgid)){
		    	$('#'+dgid).datagrid('beginEdit', i);
		    }
	    }
	}*/
	return JSON.stringify(data);
}

function getNumber(questID)
{
	var value = $("#"+questID).find(".textbox").val();
	return value;
}

function getDate(questID)
{
	var dateid = "date" + questID;
	var value = dateFormat($("#"+dateid).datebox('getValue'));
	return value;
}

function getTime(questID)
{
	var value = $("#"+questID).find("#Time").timespinner('getValue');
	return value;
}

function setText(questID,value)
{
	if (value == "") return;
	$("#"+questID).find(".textbox").val(value);
}

function setTextarea(questID,value)
{
	if (value == "") return;
	$("#"+questID).find(".textbox").val(value);
}

function setRadio(questID,value)
{
	if (value == "") return;
	//$("input[name='"+ questID +"'][value="+ value +"]").attr("checked",true); 
	
	var choice = value.split("|");
	$HUI.radio("#"+questID+choice[0]).setValue(true);
	
}

function setCheckbox(questID,value)
{
	if (value == "") return;
	strs = value.split("^"); 
	for (i=0;i<strs.length;i++ )
	{
		var choice = strs[i].split("|");
		$("input[name='"+ questID +"'][value="+ choice[0] +"]").attr("checked",true);
		if (choice[0] == "other")
        {
            //$("#"+questID).append($('<input id="other" class="textbox" style="width:150px;margin-left:5px;"></input>'));
            $("#"+questID).append($('<div><textarea id="other" class="textbox" rows="5" cols="80" style="width:98.5%;margin-top:5px;overflow:hidden;"></textarea></div>'));
            $("#"+questID).find(".textbox").val(choice[1])
        }
	} 	
	
}

function setCombobox(questID,value,scripts)
{
	if (value == "") return;
	var cbid = "combobox" + questID;
	
	if (value != "")
	{
		var choice = value.split("|");
		$('#'+cbid).combobox("setValue",choice[0])
	}
}

function setDatagrid(questID,value,scripts)
{
	if (value == "") return;
	var dgid = "dg" + questID;
	$.parser.parse('#'+dgid);
	$('#'+dgid).datagrid({
		data: value,
        onLoadSuccess: function(data) { 
        	for (var i=0;i<data.total;i++)
		    {
			    if (endEditing(dgid)){
			    	//$('#'+dgid).datagrid('beginEdit', i);
			    	//$('#'+dgid).datagrid('selectRow', i)
                				//.datagrid('beginEdit', i);
                								
			       /*if (scripts.length > 0)
			        {
				        scriObj = scripts[0];
			    		if (scriObj.Action == "setLinkData")
			    		{
				    		var ed = $('#'+dgid).datagrid('getEditor', { index: i, field: scriObj.TriField });
						    $(ed.target).combobox({ onSelect: function (record) {
								var code = record.Code;
						        var linktarget = $('#'+dgid).datagrid('getEditor',{'index':i,'field':scriObj.LinkField}).target;
				                linktarget.combobox('clear');
				                var linkData = getLinkData(code,record.Desc,scriObj);
				                linktarget.combobox('loadData',linkData);
				                if (linkData.length > 0)
				                {
				                	linktarget.combobox('setValue',linkData[0].Code);
				                }

							}
							});
			    		}
			        }*/
                	
			    }
		    }
		    /*var ed = $('#'+dgid).datagrid('getEditor', { index: index, field: '1' });
			    $(ed.target).combobox({ onChange: function () {
					alert("ok");
			        //$('#List2').datagrid('acceptChanges');
			        //setTotal('List2', 'col3', 'Summation_1');//合计车辆总数，设置总数

			    }
			});*/
        }
	});
	
	
}

function setNumber(questID,value)
{
	if (value == "") return;
	$("#"+questID).find(".textbox").val(value);
}

function setTime(questID,value)
{
	if (value == "") return;
	$.parser.parse('#'+questID);
	$("#"+questID).find("#Time").timespinner('setValue', value);
}

function addAllergy(boxid)
{
	var html = $('<div class=""><iframe id="frameAllergy" src="" frameborder=0 style="width:90%;height:650px;margin:0;padding:0;overflow:hidden"></iframe></div>');
	$('#'+boxid).append(html);
	$("#frameAllergy").attr("src","dhcem.allergyenter.csp?PatientID="+patientID +"&EpisodeID="+episodeID);	
}

function changeToObj(data)
{
	var obj = {};
	for (var i=0;i<data.length;i++)
    {
        var code = data[i].PropertyCode;
        var value = data[i].PropertyValue;
        obj[code] = value;
    }
    return obj;
}

//初始化UI底色
function initBackground()
{
	if ("undefined"==typeof HISUIStyleCode || HISUIStyleCode==""){
		// 炫彩版
		
	}else if (HISUIStyleCode=="lite"){
		// 极简版
		$("#content").addClass("easyBackground");
		$(".south").addClass("easyBackground");
	}
}