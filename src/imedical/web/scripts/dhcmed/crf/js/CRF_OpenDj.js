/*
 * 该文件负责打开表单的时候进行的检查和判断，后期事件的绑定，数据的获取等功能
 * 作  者：佘斌
 * 时  间：2010-09-20
 * 注  意：使用该文件时候请在前面引用jQuery-1.4.1类库
 */
var basePath = fcpubdata.path;
var TableName =  GetFormName();           //表单名称
var Parameters = GetParameters(); 
var curFormId = GetParameter("formid");
var PrimaryKey = GetParameter("keyid");   //主键值


/*
* 字典控件数据列表双击的时候触发的事件，该事件实现了数据的提取和保存
*/
var rowdblclick = function (CurObjId, DisplayField, DataField) {
    var o = $("#" + CurObjId);
    var ConfigDataArr = o.attr('ConfigStr');
    var ConfigData = eval("(" + ConfigDataArr + ")");

    o.val(DisplayField);
    o.attr("Eval", DataField);
    $("#dicDiv").remove();
}

//显示字典的列表
function SetData(o, data, configInfo) {
    if ($("#dicDiv").length != 0) {
        $("#dicDiv").remove();
    } else {
        var curid = o.attr("id");
        var innerStr = "";
        if (data.length > 0) {
            var curHeight = parseInt(o.attr("clientHeight"));
            var curWidth = parseInt(o.attr("clientWidth"));

            var curTop = o.css("posTop") + curHeight + 2;
            var curLeft = o.css("posLeft");

            while (o.parent().length > 0) {
                if (o.parent().css("posTop") != undefined) {
                    curTop += o.parent().css("posTop");
                }
                if (o.parent().css("posLeft") != undefined) {
                    curLeft += o.parent().css("posLeft");
                }
                o = o.parent();
            }
            innerStr = "<div id='dicDiv' style='position:absolute; display:inline; z-index:999; width:" + (curWidth + 2).toString() + "px; height:200px; line-height:150%; background-color:White; border:1px solid #7F9DB9; overflow:auto; top:" + curTop + "; left:" + curLeft + "'>";
            innerStr += "<ul style='list-style-type:none; padding-left:0px; margin-left:0px;'>";

            var tmpDispFieldName = configInfo.DisplayFieldName == null ? "显示" : configInfo.DisplayFieldName;
            var tmpDataFieldName = configInfo.DataFieldName == null ? "取值" : configInfo.DataFieldName;
            $(data).each(function (i, d) {
            	//Modified By LiYang 2013-12-26 将双击从下拉框中取值改为单击取值
                innerStr += "<li style='cursor:pointer;' EVal='" + d[tmpDataFieldName] + "' onmouseover='javascript:$(this).css(\"background-color\",\"#e1e8fb\")' onmouseout='javascript:$(this).parent().find(\"li\").css(\"background-color\",\"#ffffff\")' onclick='rowdblclick(\"" + curid + "\",\"" + d[tmpDispFieldName] + "\", \"" + d[tmpDataFieldName] + "\")'>";
                innerStr += d[tmpDispFieldName];
                innerStr += "</li>";
            });
            innerStr += "</ul>";
            innerStr += "</div>";
            return innerStr;
        }
    }
}

var setValue = function (id, val) {
    $("#" + id).val(val);
    var curControlType = $("#" + id).attr("controltype");
    switch (curControlType) {
        case "radio":
            {
                $("#" + id).find("input[value='" + val + "']").click();
                break;
            }
        case "checkbox":
            {
                var trueValue = $("#" + id).attr("trueValue");
                var falseValue = $("#" + id).attr("falseValue");
                $("#" + id).find("input[type='checkbox']").attr("checked", curValue == trueValue);
                $("#" + id).click();
                $("#" + id).val(curValue);
                break;
            }
        case "dictionary":
            {
                $("#" + id).val(val);
                $("#" + id).attr("Eval", val);
                break;
            }
        default:
            {
                $("#" + id).val(val.replace(/DHC-HCHH-DHC/g, '\n'));
                break;
            }
    }
    $("#externallstdiv").remove();
}

var OpenExternalData = function (curid) {
    if ($("#externallstdiv").length != 0) {
        $("#externallstdiv").remove();
    } else {
        $("#externallstdiv").remove();
        var ConfigStr = $("#" + curid).attr("ExternalDataInterfaceConfig");
        var ConfigObj = eval("(" + ConfigStr + ")");

        var o = $("#" + curid);
        var curHeight = parseInt(o.attr("clientHeight"));
        var curWidth = parseInt(o.attr("clientWidth"));

        var curTop = o.css("posTop") + curHeight + 2;
        var curLeft = o.css("posLeft") + 2;

        while (o.parent().length > 0) {
            if (o.parent().css("posTop") != undefined) {
                curTop += o.parent().css("posTop");
            }
            if (o.parent().css("posLeft") != undefined) {
                curLeft += o.parent().css("posLeft");
            }
            o = o.parent();
        }

        var innerStr = "<div id='externallstdiv' style='position:absolute; width:" + curWidth.toString() + "px" + "; top:" + curTop.toString() + "px" + "; left:" + curLeft.toString() + "px; height:150px; overflow-x:hidden; overflow-y:scroll; line-height:160%; background-color:White; border:1px solid'>";
     /*   //modify by mxp 2013-5-7  
     		if (ExternalDataArr != null) {
            if (ExternalDataArr[ConfigObj.ID] != null) {
                try {
                    var DataArr = ExternalDataArr[ConfigObj.ID];

                    innerStr += "<div style='cursor:pointer' ondblclick='java" + "script:setValue(\"" + curid + "\", $(this).text())'>" + DataArr + "</div>";
                    //                    for (var i = 0; i < DataArr.length; i++) {
                    //                        innerStr += "<div style='cursor:pointer' ondblclick='java" + "script:setValue(\"" + curid + "\", $(this).text())'>" + DataArr[i] + "</div>";
                    //                    }
                } catch (e) {
                    //do nothing;
                }
            }
        }
       */ 
        innerStr += "</div>";

        $("body").append(innerStr);
    }
}


/*
 * 表单控件的自定义单击事件, sKey表示是用户自定义的参数
 */
function bill_onclick(sKey) {
    //如果要得到事件的发起者，请使用下面的代码
    var o = event.srcElement;
    var thisval = $(o).val();
    switch ($(o).attr("controltype")) {
        case undefined:
            {
                var curControlType = $(o).parent().attr("controltype");
                if (curControlType == "dictionary") {
                }
                else if (curControlType == "checkbox") {
                    var o = event.srcElement;
                    var p = event.srcElement.parentElement;
                    if ($(o).attr("checked")) {
                        $(p).val($(p).attr("truevalue"));
                    } else {
                        $(p).val($(p).attr("falsevalue"));
                    }
                }
                break;
            }
        case "datetext":
            {
                
                break;
            }
        default:
            {
                break;
            }
    }
    eval(sKey);
}

function OpenDictionaryData(sid) {
		//debugger;
    if (sid != "") {
        var curObj = $("#" + sid);
        if (curObj.attr("controltype") == "dictionary") {
            //分别获取当前的编码值和汉子值
            var thisHval = $.trim(curObj.val());
            var thisEval = $.trim(curObj.attr("Eval"));
            
            //得到当前的配置信息
            TmpConfigStr = curObj.attr("ConfigStr");

            if (TmpConfigStr != null) {
                var reciveData = eval("(" + TmpConfigStr + ")");
                //解析静态数据（有静态数据和动态数据的时候，以静态数据为准）
                if (reciveData["StaticData"] != null) {
                    var staticStr = "";
                    var DataArr = new Array();
                    for (var p in reciveData.StaticData) {
                        var DataObj = new Object();
                        DataObj["显示"] = p.toString();
                        DataObj["取值"] = reciveData.StaticData[p];
                        DataArr.push(DataObj);
                    }
                    staticStr = SetData(curObj, DataArr, reciveData);
                    $("body").append(staticStr);
                } else {
                		var dicConfig = eval("(" + TmpConfigStr + ")");
                		var objDic = new Object();

                    objDic.dicCode = dicConfig.TableList;
                    
                    var WhereConditions = dicConfig.WhereConditions;
                    if (WhereConditions != "" ){
                    	var ConditionList = WhereConditions.split("^");
                    	WhereConditions = "";
                    	for (var i=0; i<ConditionList.length; i++){
                    		argument = ConditionList[i];
                    		try {
	                    		if (argument.indexOf("@")>=0){
	                    			if(argument.indexOf("@@")>=0)
	                    				argument = $(argument.replace("@@","#")).attr("Eval");
	                    			else
	                    				argument = $(argument.replace("@","#")).val();
	                    		}
	                    		//add by mxp 2014-11-10 字典添加request参数处理
	                    		if (argument.indexOf("%request") >= 0 ) {
     								argument = GetParameter(argument.split(".")[1]);
     							}
                    		}
                    		catch(e){
                    			argument=""
                    		}
                    		WhereConditions += argument;
                    		if ((i+1)<ConditionList.length) {WhereConditions+="^"}
                    	}
                    	objDic.WhereConditions = WhereConditions;
                    }
                    objDic.Preview = 0;
                    
                    $.ajax({
                        type: "POST",
                        url: fcpubdata.previewDic,  //basePath + "/Form.do/RunQuery",
                        data: objDic,
                        success: function (obj) {
                        		obj =  eval("("+obj+")");
                            if (obj.Result) {
                                //var data = eval(obj.DataObject);
                                var data = obj.record;
                                var innerStr = SetData(curObj, data, reciveData);
                                $("body").append(innerStr);
                            } else {
                            	alert(obj.Message);
                            }
                        }
                    });
                }
            }
        }
    }
}

/*
 * 表单控件的自定义的焦点离开的事件
 */
function bill_onexit(sKey) {
    if (!validthis()) {
        return false;
    } else {
        eval(sKey);
    }
}

/*
* 表单控件的自定义的双击的事件
*/
function bill_ondblclick(sKey, srcKey) {
    var o = event.srcElement;
    if (srcKey !=null && srcKey != "") {
        o = $("#" + srcKey)[0]
    }
    var thisval = $(o).val();
    switch ($(o).attr("controltype")) {
        case "datetext":
            {
                $eform("选择日期", srcKey);
                break;
            }
        default:
            {
                break;
            }
    }
    eval(sKey);
}

/*
* 表单控件的自定义的进入的事件
*/
function bill_onenter(sKey) {
    var o = event.srcElement;
    $(o).removeAttr("IsValid");
    eval(sKey);
}

/*
* 表单控件的自定义的键盘按下的事件
*/
function bill_onkeydown(sKey) {
    var o = event.srcElement;
    var thisval = $(o).val();
    switch ($(o).parent().attr("controltype")) {
        case "dictionary":
            {
                //DicValue = thisval;
                //$eform("选择日期");
                break;
            }
        default:
            {
                break;
            }
    }
    eval(sKey);
}

/*
* 表单控件的自定义的键盘弹起的事件
*/
function bill_onkeyup(sKey) {
    var o = event.srcElement;
    var thisval = $(o).val();
    switch ($(o).parent().attr("controltype")) {
        case "dictionary":
            {
//                if ($.trim(DicValue) != $.trim(thisval)) {
//                    alert(thisval);
//                }
                break;
            }
        default:
            {
                break;
            }
    }
    eval(sKey);
}

function bill_onmouseover() {
    var o = event.srcElement;
    switch ($(o).attr("controltype")) {
        case "dictionary":
            {
//                $("#CRFSmartDiv").remove();
//                var curId = $(o).attr("id");
//                var FloatButtonStr = "<input id='CRFSmartDiv' style='position:absolute' style='width:25px; height:20px' type='button' onclick='OpenDictionaryData(\"" + curId + "\")' value=' ... ' />";
//                $(o).parent().append(FloatButtonStr);
//                $("#CRFSmartDiv").css("top", $(o).css("top"));
//                $("#CRFSmartDiv").css("left", (parseInt($(o).css("left").replace("px", "")) + parseInt($(o).css("width").replace("px", ""))).toString() + "px");
                break;
        }
        case "text" :
        {
        	break;
        }
        case "datetext" :
        case "timetext" :
        {
        	break;
        }
        default:
            {
                if (o.parentElement.controltype == "dictionary") {
                    //$(o).parent().find("input[type='button']").show();
                } else {
                    //配置了外部数据接口要显示读取外部的数据的按钮
                    var ConfigStr = $(o).attr("ExternalDataInterfaceConfig");
                    if (ConfigStr != undefined && ConfigStr != "") {
                        var ConfigObj = eval("(" + ConfigStr + ")");
                        if (ConfigObj != null && ConfigObj != "") {
                            $("#CRFSmartDiv").remove();
                            var curId = $(o).attr("id");
                            var FloatButtonStr = "<input id='CRFSmartDiv' style='position:absolute' style='width:25px; height:20px' type='button' onclick='OpenExternalData(\"" + curId + "\")' value=' ... ' />";
                            $(o).parent().append(FloatButtonStr);
                            $("#CRFSmartDiv").css("top", $(o).css("top"));
                            $("#CRFSmartDiv").css("left", (parseInt($(o).css("left").replace("px", "")) + parseInt($(o).css("width").replace("px", ""))).toString() + "px");
                        }
                    }
                }
                break;
            }
    }
}

function bill_onmouseout() {
    var o = event.srcElement;
    switch ($(o).attr("controltype")) {
        case "dictionary":
            {
                break;
            }
        default:
            {
                if (o.parentElement != null && o.parentElement.controltype == "dictionary") {
                } else {
                    
                }
                break;
            }
    }
}

//DataField类
var DataField = function () {
    //this.TableName = "";
    this.EName = "";
    //this.Type = "";  //目前只有int和varchar
    this.Value = null;
    //this.Length = 0;
    //this.IsKey = false;
}

//将所有控件上的数据封装到一个DataField数组中去
function MakeAllDataField(ControlsArr) {
    var ret = new Array();
    var pathArr = location.pathname.split("/");
    var TableName =  GetFormName(); //pathArr[pathArr.length - 1].split(".")[0];
    for (var i = 0; i < ControlsArr.length; i++) {
        var TmpData = new DataField();
        TmpData.TableName = TableName;
        TmpData.TableType = "CRF";
        TmpData.EName = escape($(ControlsArr[i]).attr("id"));
        if ($(ControlsArr[i]).attr("controltype") == "numbertext") {
            TmpData.Type = "int";
        } else if ($(ControlsArr[i]).attr("controltype") == "datetext" || $(ControlsArr[i]).attr("controltype") == "timetext") {
            TmpData.Type = "datetime";
        } else {
            TmpData.Type = "varchar";
        }
        if ($(ControlsArr[i]).attr("controltype") == "dictionary") {
            var ValArr = new Array();
            var dicEValue = $(ControlsArr[i]).attr("Eval");
            dicEValue = dicEValue == undefined ? "" : dicEValue;
            ValArr.push(escape(dicEValue));
            TmpData.Value = ValArr;

            var TmpHData = new DataField();
            TmpHData.TableName = TmpData.TableName;
            TmpHData.TableType = TmpData.TableType;
            TmpHData.EName = "H"+escape($(ControlsArr[i]).attr("id"));
            var ValHArr = new Array();
            var dicHValue = $(ControlsArr[i]).val();
            dicHValue = dicHValue == undefined ? "" : dicHValue;
            ValHArr.push(escape(dicHValue));
            TmpHData.Value = ValHArr;
            ret.push(TmpHData);
        }
        else if ($(ControlsArr[i]).attr("controltype") == "radio") {
            var ValArr = new Array();
            ValArr.push(escape($(ControlsArr[i]).val()));
            TmpData.Value = ValArr;

            var TmpHData = new DataField();
            TmpHData.TableName = TmpData.TableName;
            TmpHData.TableType = TmpData.TableType;
            TmpHData.EName = "H" + escape($(ControlsArr[i]).attr("id"));
            var ValHArr = new Array();
            var dicHValue = $(ControlsArr[i]).find("input[value=" + $(ControlsArr[i]).val() + "]").attr("text")
            dicHValue = dicHValue == undefined ? "" : dicHValue;
            ValHArr.push(escape(dicHValue));
            TmpHData.Value = ValHArr;
            ret.push(TmpHData);
        }
        else {
            var ValArr = new Array();
            ValArr.push(escape($(ControlsArr[i]).val()));
            TmpData.Value = ValArr;
            TmpData.Value = $(ControlsArr[i]).val();
        }
        ret.push(TmpData);
    }
    return ret;
}


//将所有控件上的数据封装到一个对象中去
function MakeDataObject(ControlsArr) {
    var ret = new Object();
    
    for (var i = 0; i < ControlsArr.length; i++) {
        
        EName = escape($(ControlsArr[i]).attr("id"));
        if ($(ControlsArr[i]).attr("controltype") == "dictionary") {

            Value = $(ControlsArr[i]).attr("Eval");
            Value = Value == undefined ? "" : Value;
            
            HEName = "H"+$(ControlsArr[i]).attr("id");
            HValue = $(ControlsArr[i]).val();
            HValue = HValue == undefined ? "" : HValue;
            //ret[HEName]=HValue;
            ret[HEName]=HValue.replace(/,/g,"，");
            
        }
        else if ($(ControlsArr[i]).attr("controltype") == "radio") {

            Value = $(ControlsArr[i]).val();
            Value=Value.replace(/,/g,"，");

            HEName = "H" + ($(ControlsArr[i]).attr("id"));
            HValue = $(ControlsArr[i]).find("input[value=" + $(ControlsArr[i]).val() + "]").attr("text")
            HValue = HValue == undefined ? "" : HValue;
            //ret[HEName]=HValue;
            ret[HEName]=HValue.replace(/,/g,"，");
        }
        else if ($(ControlsArr[i]).attr("controltype") == "timetext") {
            Value = $(ControlsArr[i]).val().replace(/:/g,"-");
        }
        else {
        	Value=$(ControlsArr[i]).val();
            //var ValArr = new Array();
            //ValArr.push(escape($(ControlsArr[i]).val()));
            //TmpData.Value = ValArr;
            //TmpData.Value = $(ControlsArr[i]).val();
        }
        Value=Value.replace(/,/g,"，");
        ret[EName]=Value;
    }
    return ret;
}

//得到当前表单的名称
function GetFormName() {
    var ret = GetParameter("EName");
    /*
    var ParamStrArr = location.href.split("?");
    if (ParamStrArr.length > 1) {
        var ParamsArr = ParamStrArr[0].split("/");
        var PALength = ParamsArr.length;
        if (PALength > 0) {
            ret = ParamsArr[PALength - 1].split(".")[0];
        }
    }*/
    return ret;
}

function GetParameter(param) {
    var ret = "";
    var ParamStrArr = location.href.split("?");
    if (ParamStrArr.length > 1) {
        var ParamsArr = ParamStrArr[1].split("&");
        if (ParamsArr.length > 0) {
            for (var i = 0; i < ParamsArr.length; i++) {
                var keyValueDic = ParamsArr[i].split("=");
                if (keyValueDic.length > 0) {
                    var ParamKey = keyValueDic[0];
                    if (ParamKey.toLowerCase() == param.toLowerCase()) {
                        ret = keyValueDic[1];
                        return ret;
                    }
                }
            }
        }
    }
    return ret;
}

function GetParameters() {
    var ret = new Object();
    var ParamStrArr = location.href.split("?");
    if (ParamStrArr.length > 1) {
        var ParamsArr = ParamStrArr[1].split("&");
        if (ParamsArr.length > 0) {
            for (var i = 0; i < ParamsArr.length; i++) {
                var keyValueDic = ParamsArr[i].split("=");
                if (keyValueDic.length > 0) {
                    var ParamKey = keyValueDic[0];
                        ret[ParamKey] = keyValueDic[1];
                    }
                }
            }
    }
    return ret;
}

//关联病例和就诊信息
function AddPatAndAdm(PatProjGrpID, curBatchID, curAdmID,DataArr) {
    //关联病人入组ID
    var TmpDataPat = new DataField();
    TmpDataPat.EName = "PatProjGrpID";
    TmpDataPat.Type = "varchar";
    var ValArrPat = new Array();
    ValArrPat.push(PatProjGrpID);
    TmpDataPat.Value = ValArrPat;
    DataArr.push(TmpDataPat);

    //就诊
    var TmpDataBatch = new DataField();
    TmpDataBatch.EName = "NUM";
    TmpDataBatch.Type = "int";
    var ValArrBatch = new Array();
    ValArrBatch.push(curBatchID);
    TmpDataBatch.Value = ValArrBatch;
    DataArr.push(TmpDataBatch);

    var TmpDataAdmID = new DataField();
    TmpDataAdmID.EName = "EPISODEID";
    TmpDataAdmID.Type = "varchar";
    var ValArrAdmID = new Array();
    ValArrAdmID.push(curAdmID);
    TmpDataAdmID.Value = ValArrAdmID;
    DataArr.push(TmpDataAdmID);
}

function CheckValueIsNull(DataControls) {
	var error = "";
	
	for (var i = 0; i < DataControls.length; i++) {
		var value = "";
		var isNull = DataControls[i].notNull;
		if (!isNull) continue;
		if($(DataControls[i]).attr("controltype") == "radio"){
			var HValue = $(DataControls[i]).find("input[value=" + $(DataControls[i]).val() + "]").attr("text");
			value = HValue == undefined ? "" : HValue;
		}		
		/*if(DataControls[i].tagName=="INPUT")
		{
			var value = $(DataControls[i]).val()
			var isNull = DataControls[i].notNull;
		}*/
		else{
			value = $(DataControls[i]).val()
		}
				
		if((value=="")&&(isNull)){
			//var itemID = DataControls[i].id;
			var itemDesc = DataControls[i].china;
			if (error=="")
				error += itemDesc;
			else
				error += "、"+itemDesc;
		}
	}
	//error += "不能为空!";
	return error;
}

/*
 *  表单数据的保存（先验证，后保存）
 */
function DjSave(statusCode,isCheck) {
    var retFlag = false;
    var pathArr = location.pathname.split("/");
    //var TableName = pathArr[pathArr.length - 1].split(".")[0];
    
    var PatProjGrpID = GetParameter("patprojgrpid");
    var curBatchID = GetParameter("batchid");
    var curAdmID = GetParameter("episodeid");
    var curAudited = GetParameter("audited");
    var curIsDyn = GetParameter("IsDyn");

    var DataControls = $("[controltype='text'],[controltype='textarea'],[controltype='radio'],[controltype='checkbox'],[controltype='combobox'],[controltype='dictionary'],[controltype='numbertext'],[controltype='datetext'],[controltype='timetext']");
	//验证非空控件值
	var checkNull=CheckValueIsNull(DataControls);
	if(checkNull){
		alert(checkNull+"不能为空!");
		return;
	}
    //验证
    if(isCheck=="1"){    	
	    var nCount = $("input[IsValid='false']").length + $("select[IsValid='false']").length;
	    if (parseInt(nCount) > 0) {
	        alert("表单信息验证失败，不能保存，请检查数据的合法性！");
	        return ;
	    }
 	}
   //debugger;
    //业务分流
    //var DataArr = MakeAllDataField(DataControls);
    var DataObject=MakeDataObject(DataControls);
    var url = basePath;
    var params = null;
    /*
    if (PrimaryKey == null || PrimaryKey == "") {                   //新增
        //关联病例和就诊信息
        AddPatAndAdm(PatProjGrpID, curBatchID, curAdmID, DataArr);
        url = url + "/Form.do/AddData";
        params = { FormId: curFormId };
    } else {
        if (curAudited == "1") {                                    //审核 
            url = url + "/Form.do/SaveAuditedData";
            params = { KeyId: PrimaryKey };
        } else if (curIsDyn == "1") {                              //动态入组
            url = url + "/Form.do/SaveExternalCaseData";
            params = { FormId: curFormId, KeyId: PrimaryKey };
        } else {                                                   //修改
            url = url + "/Form.do/UpdateData";
            params = { KeyId: PrimaryKey };
        }
    }*/


    //补充参数
    if (PrimaryKey!=""){
    	DataObject["ID"]=PrimaryKey;
    }
    DataObject["CurrentStatusCode"]=statusCode; //"01";   //报告状态代码
		params = { FormId: curFormId };
		// modify by mxp
		DataObject["FormVerDR"]=GetParameter("formVerId");
    params.formVerId=GetParameter("formVerId");
	
	// Add By LiYang 2013-10-27 存储PatientID和EpisodeID两个项目
	var strCurrPatientID = GetParameter("PatientID");
	var strCurrEpisodeID = GetParameter("EpisodeID");
	if(strCurrPatientID == null)
		strCurrPatientID = "";
	if(strCurrEpisodeID == null)
		strCurrEpisodeID = "";	
	DataObject.PatientID = strCurrPatientID;
	DataObject.EpisodeID = strCurrEpisodeID;
	
	//add by mxp 2013-12-17 存储GoalUserID (职业暴露)
	var strCurrGoalUserID = GetParameter("GoalUserID");
	if(strCurrGoalUserID == null)
		strCurrGoalUserID = "";
	DataObject.GoalUserID = strCurrGoalUserID;
	
    params.keyId=GetParameter("keyId");
    
    //params.FormInfo = $.toJSON(formObj);
    //params.DataStr = $.toJSON(DataArr);
    params.DataStr = $.toJSON(DataObject);
//debugger;
		params.ClassName = "DHCMed.CR.BO.DataService";
		params.MethodName = "SaveData";
    $.ajax({
        type: "POST",
        url:  fcpubdata.runMethod,  //"dhcmed.crf.savedata.csp",
				dataType: "text",
        async: false,
        data: params,
        success: function (ret) {
        	ret = eval("("+ret+")");        	
            if (ret.Result) {
                retFlag = ret.Result; 
                window.PrimaryKey = ret.DataObject["keyid"]; //返回数据库ID值 Modified By LiYang 2013-10-29
                //debugger;
                alert("表单信息保存完毕！");
            } else {
                alert("表单信息保存失败！错误信息：" + ret.Message);
            }
        },
				error:function(e,i){
					debugger;
				}
    });

    return retFlag;
}

function validthis() {
    var o = event.srcElement;
    var thisval = $(o).val();
    if (thisval != "") {
        switch ($(o).attr("controltype")) {
            case "numbertext":
                {
                    //验证规则说明： 开头可以是0个或者1个“+/-”符号。后面是整数和小数，小数位不是必须的，但是如果写了小数点，小数位置控制在1到10之间
                    var reg = /^[+-]?(?:[1-9][0-9]*|0)(?:\.[0-9]{1,10})?$/;
                    var blret = reg.test(thisval);
                    if (!blret) {
                        $(o).css("color", "red");
                        $(o).attr("IsValid", "false");
                    } else {
                        $(o).css("color", "black");
                        $(o).attr("IsValid", "true");
                    }
                    return blret;
                    break;
                }
            case "datetext":
                {
                    //验证规则说明： 验证日期，格式应该为YYYY-MM-DD
                    var reg = /((^((1[8-9]\d{2})|([2-9]\d{3}))(-)(10|12|0?[13578])(-)(3[01]|[12][0-9]|0?[1-9])$)|(^((1[8-9]\d{2})|([2-9]\d{3}))(-)(11|0?[469])(-)(30|[12][0-9]|0?[1-9])$)|(^((1[8-9]\d{2})|([2-9]\d{3}))(-)(0?2)(-)(2[0-8]|1[0-9]|0?[1-9])$)|(^([2468][048]00)(-)(0?2)(-)(29)$)|(^([3579][26]00)(-)(0?2)(-)(29)$)|(^([1][89][0][48])(-)(0?2)(-)(29)$)|(^([2-9][0-9][0][48])(-)(0?2)(-)(29)$)|(^([1][89][2468][048])(-)(0?2)(-)(29)$)|(^([2-9][0-9][2468][048])(-)(0?2)(-)(29)$)|(^([1][89][13579][26])(-)(0?2)(-)(29)$)|(^([2-9][0-9][13579][26])(-)(0?2)(-)(29)$))/;
                    var blret = reg.test(thisval);
                    if (!blret) {
                        $(o).css("color", "red");
                        $(o).attr("IsValid", "false");
                    } else {
                        $(o).css("color", "black");
                        $(o).attr("IsValid", "true");
                    }
                    return blret;
                    break;
                }
            case "timetext":
                {
                    //验证规则说明： 验证时间，格式应该为HH:MM:SS
                    var reg = /^(?:[01]\d|2[0-3])(?::[0-5]\d){2}$/;
                    var blret = reg.test(thisval);
                    if (!blret) {
                        $(o).css("color", "red");
                        $(o).attr("IsValid", "false");
                    } else {
                        $(o).css("color", "black");
                        $(o).attr("IsValid", "true");
                    }
                    return blret;
                    break;
                }
            default:
                {
                    return true;
                    break;
                }
        }
    } else {
        $(o).css("color", "black");
        $(o).attr("IsValid", "true");
    }
    
}

function $eform(sKey, srcKey) {
    switch (sKey) {
        case "第一页": oDsMain.FirstPage(); break;
        case "上一页": oDsMain.PrevPage(); break;
        case "下一页": oDsMain.NextPage(); break;
        case "最后页": oDsMain.LastPage(); break;

        case "新增": oDsMain.Append(); oDsMain.fset_cont1(); fcpubdata.keyValue = ''; break;
        case "删除": DelGridRow(oDsMain); oDsMain.PrevPage(); break;

        case "复制新增": oDsMain.AppendCopy(); oDsMain.fset_cont1(); fcpubdata.keyValue = ''; break;

        case "新增保存": fcpubdata.keyValue = ''; var sR = DjSave(); if (IsSpace(sR)) { alert('新增保存成功!'); oDsMain.Append(); } else { alert(sR); } break;
        case "修改保存": fcpubdata.keyValue = new Eapi.RunForm().getKeyFieldValue(); DjSaveShow(); break;
        case "表单保存好后提示": DjSaveShow(); break;
        case "表单保存": DjSave(); break;
        case "表单保存好后退出": DjSave('退出'); break;

        case "表格第一页": oDsGrid.FirstPage(); break;
        case "表格上一页": oDsGrid.PrevPage(); break;
        case "表格下一页": oDsGrid.NextPage(); break;
        case "表格最后页": oDsGrid.LastPage(); break;
        case "增加行": oDsGrid.Append(); break;
        case "删除行": oDsGrid.Delete(); break;
        case "删除行且删除记录": DelGridRow(oDsGrid); break;
        case "删除表格多选行": MultiDelGridRow(oDsGrid); break;
        case "表格保存": GridSave(oDsGrid); break;
        case "表格保存好后退出": GridSave(oDsGrid, '退出'); break;
        case "表格选中多行": GridMultiSel(); break;

        case "选择日期": SelectDate(undefined,srcKey); break;
        case "计算器": ShowCalc(); break;
        case "关闭窗口": CloseBill(); break;
        case "刷新条件格式": contTermStyle(); break;
        case "刷新权限控制": if (typeof (EformCheckRoleInfo) == "function") EformCheckRoleInfo(); break;
    }
}

/*
 * 解析函数库中的参数的方法
 * 参数说明： paramStr : 传递到函数库中的参数的原型
 * 返回值：参数的数组
*/
function SplitParams(paramStr) {
    var ret = new Array();
    var ParamArr = paramStr.split("SplitP,");
    for (var i = 0; i < ParamArr.length; i++) {
        var TmpParam = ParamArr[i].split("PointP.");
        if (TmpParam.length == 1) {//传入的是值
            ret.push(TmpParam[0].toString());
        } else {  //传入的是表达式
            var sid = '\'' + '#' + TmpParam[0].toString() + '\'';
            var expressStr = '$(' + sid + ')' + '.' + TmpParam[1].toString();
            var ParamValue = eval("(" + expressStr + ")");
            ret.push(ParamValue);
        }
    }
    return ret;
}

//自定义的Round的方法，四舍五入保留到第N位
//val数值， t保留t位小数
function DHCRound(val, t) {
    return new Number(val.toString().substring(0, val.toString().indexOf(".") + t + 1));
}

function FindObjInArr(Arr, p, v) {
    var ret = null;
    for (var i = 0; i < Arr.length; i++) {
        if (Arr[i][p] == v) {
            ret = Arr[i];
        }
    }
    return ret;
}


function BuildExternalArr(Arr, p, o) {
	  var flag = 0;
    for (var i = 0; i < Arr.length; i++) {
        if (Arr[i][p] == o[p]) {
        		flag = 1;
        		if (Arr[i]["Arguments"].length < o["Arguments"].length){
        			Arr[i]["Arguments"] = o["Arguments"];
        		}            
        }
    }
    if (flag == 0) {Arr.push(o)}
    return Arr;
}

function BuildExternalArguments(Arr) {
	  var flag = 0;
    for (var i = 0; i < Arr.length; i++) {        
    		if (Arr[i]["Arguments"] != ""){
     			var args = Arr[i]["Arguments"].split(",");
     			var args_value = ""
     			for (var j = 0; j<args.length; j++) {
     				a_t = args[j];
     				if (a_t.indexOf("@") == 0 ){
     					val =  $("#"+a_t.substr(1)).val();
     				}
     				else if (a_t.indexOf("%request") == 0 ) {
     					val = GetParameter(a_t.split(".")[1]);
     				}
     				else {
     					val = a_t;
     				}
     				args_value += val;
     				args_value += ","
     			}
     			args_value = args_value.substr(0, args_value.length-1);
     			Arr[i]["Arguments"] = args_value;
    		}           
    }
    return Arr;
}

//外部数据集合
//var ExternalDataArr; 

//初始化时加载外部接口方法
//调用外部接口数据
//为了减少网络轮询次数，采用一次收集一次发送一次解析的机制
function LoadExternalData() {
    var ObjArr = new Array();
    var ExternalControls = $("*[ExternalDataInterfaceConfig]");   
    ExternalControls.each(function (i, d) {
        var configStr = $(d).attr("ExternalDataInterfaceConfig");
       //  debugger;
        if (configStr != "") {
            curConfigObj = eval("(" + configStr + ")");
            if (curConfigObj != null) {
            		if (curConfigObj.InitData) {    //页面初始化时加载
            			ObjArr = BuildExternalArr(ObjArr, "ID", curConfigObj);
            	}
            }
        }
    });
    
    ObjArr = BuildExternalArguments(ObjArr);
    //alert($.toJSON(ObjArr));
    var ExternalDataArr = LoadExternalDataRequest(ObjArr);
    
    SetExternalData(ExternalDataArr);
}

function LoadExternalDataRequest(ExternalArr){
	var ExternalDataArr = "";
	if (ExternalArr.length==0) {return ExternalDataArr}
	$.ajax({
      type: "POST",
      //url: basePath + "/Form.do/GetExternalDataList",
      url: fcpubdata.runMethod,
      dataType: "text",
      //data: { JsonStr: $.toJSON(ObjArr), BatchID: curBatchId },
      data: { Externals: $.toJSON(ExternalArr), ClassName:"DHCMed.CR.BO.ExternalInterface",MethodName:"LoadData"},
      async: false,
      success: function (ret) {
      		ret = eval("(" + ret + ")");
          if (ret.Result) {
              if (ret.DataObject != null && ret.DataObject != "") {
                  //ExternalDataArr = eval("(" + ret.DataObject + ")");
                  ExternalDataArr = ret.DataObject;
              }
          } else {
              alert("获取外部接口数据失败！错误信息：" + ret.Message);
          }
      }
   });
   return ExternalDataArr;
}


function SetExternalData(ExternalDataArr){
	var strErrorStr = "";
	var curConfigObj = null;
	if (ExternalDataArr != null) {
        var iFlag = 0;
        var ExternalControls = $("*[ExternalDataInterfaceConfig]");
        ExternalControls.each(function (i, d) {
            var configStr = $(d).attr("ExternalDataInterfaceConfig");
            if (configStr != "") {
                curConfigObj = eval("(" + configStr + ")");
                if (curConfigObj != null) {
                    try {
                        var data = ExternalDataArr[curConfigObj.ID][curConfigObj.ItemProp];
                        if (data != null) {
                            switch ($(d).attr("controltype")) {
                                case "radio":
                                    {
                                        $(d).find("input[value='" + data + "']").attr("checked", true);
                                        $(d).find("input[text='" + data + "']").attr("checked", true); //Add Bu LiYang 2013-12-28  当被绑定数据为文本描述时，可以根据描述进行绑定
                                        break;
                                    }
                                case "checkbox":
                                    {
                                        var curValue = data;
                                        var trueValue = $(d).attr("trueValue");
                                        var falseValue = $(d).attr("falseValue");
                                        $(d).find("input[type='checkbox']").attr("checked", curValue == trueValue);
                                        $(d).val(curValue);
                                        break;
                                    }
                                case "div":
                                    {
                                        $(d).html(data);
                                        break;
                                    }
                                case "dictionary": //Add By LiYang 2013-12-21
                                	//debugger;
                                	//data = "I10  03";
                                	LoadDicExtraData(d.id, data);
                                	break;
                                default:
                                    {
                                        $(d).val(data);
                                        break;
                                    }
                            }
                            $(d).val(data);
                        }
                    } catch (e) {
                        iFlag++;
                        strErrorStr +=iFlag + "、配置代码：" + curConfigObj.ItemCode + ",绑定属性：" + curConfigObj.ItemProp + ",传入参数：" + curConfigObj.Arguments + "，错误信息：" + e.message + "\r\n";
                    }
                }
            }
        });
        if (iFlag > 0) {
        		strErrorStr += "当前URL：" + window.location.href;
            alert("有 " + iFlag.toString() + " 个外部数据接口出现问题，可能对业务造成影响！请联系管理员！\r\n" +  strErrorStr);
        }
    }
}

///Add By LiYang 2013-12-21 处理字典项目的外部接口
function LoadDicExtraData(sid, data) {
    if (sid != "") {
        var curObj = $("#" + sid);
        if (curObj.attr("controltype") == "dictionary") {
            //分别获取当前的编码值和汉子值
            var thisHval = $.trim(curObj.val());
            var thisEval = $.trim(curObj.attr("Eval"));
            
            //得到当前的配置信息
            TmpConfigStr = curObj.attr("ConfigStr");

            if (TmpConfigStr != null) {
                var reciveData = eval("(" + TmpConfigStr + ")");
                //解析静态数据（有静态数据和动态数据的时候，以静态数据为准）
                if (reciveData["StaticData"] != null) {
                    var staticStr = "";
                    var DataArr = new Array();
                    for (var p in reciveData.StaticData) {
                        var DataObj = new Object();
                        DataObj["显示"] = p.toString();
                        DataObj["取值"] = reciveData.StaticData[p];
                        if(DataObj["显示"] == data)
                        {
                						curObj.val(DataObj["显示"]);
                						curObj.attr("Eval", DataObj["取值"]);                        	
                        }
                    }
                } else {
                		var dicConfig = eval("(" + TmpConfigStr + ")");
                		var objDic = new Object();

                    objDic.dicCode = dicConfig.TableList;
                    objDic.WhereConditions = dicConfig.WhereConditions.replace("@"+sid, data); //encodeURIComponent(data);
                    objDic.Preview = 0;
                    //debugger;
                    $.ajax({
                        type: "POST",
                        url: fcpubdata.previewDic,  //basePath + "/Form.do/RunQuery",
                        data: objDic,
                        success: function (obj) {
                        		obj =  eval("("+obj+")");
                            if (obj.Result) {
                                //var data = eval(obj.DataObject);
                                //if(obj.total > 0)
                                //	debugger;
                                //var data = obj.record;
                                var isBind = false;
                                for(var i = 0; i < obj.total ; i ++)
                                {
                                	if((obj.record[i][reciveData.DisplayFieldName] != data)&&(obj.record[i][reciveData.DataFieldName].indexOf(data) < 0)) continue;
                  								curObj.val(obj.record[i][reciveData.DisplayFieldName]);
                									curObj.attr("Eval", obj.record[i][reciveData.DataFieldName]);                    
                									isBind = true;                 	
                                }
                                if(!isBind)
                                	alert('没有成功绑定外部数据接口！\r\n元素名称：' + sid + '\r\n被绑定的值：' + data );
                                //var innerStr = SetData(curObj, data, reciveData);
                                //$("body").append(innerStr);
                            } else {
                            	alert(obj.Message);
                            }
                        }
                    });
                }
            }
        }
    }
}

function LoadInternalData() {
    var InternalControls = $("*[InternalDataInterfaceConfig]");
    var InternalInterfaceArr = new Array();
    InternalControls.each(function (i, d) {
        var configStr = $(d).attr("InternalDataInterfaceConfig");
        if (configStr != null && configStr != "") {
            var configObj = eval("(" + configStr + ")");
            if (configObj != null && configObj.FieldID != null && configObj.FieldID != "") {
                InternalInterfaceArr.push(configObj);
            }
        }
    });

    var patprggrpid = GetParameter("patprojgrpid");
    var curBatchId = GetParameter("batchid");
    var keyid = GetParameter("keyid");
    var curFormName = GetFormName();

    var InternalDataArr = new Array();
    if (InternalInterfaceArr.length > 0 && patprggrpid != "" && curBatchId != "") {
        $.ajax({
            type: "POST",
            url: basePath + "/Form.do/GetInternalDataList",
            dataType: "json",
            data: { JsonStr: $.toJSON(InternalInterfaceArr), PatPrjGrpId: patprggrpid, BatchID: curBatchId, KeyId: keyid, FormName: curFormName },
            async: false,
            success: function (ret) {
                if (ret.Result) {
                    InternalDataArr = ret.DataObject;
                    for (var p in InternalDataArr) {
                        var pname = p.toString();
                        var pvalue = InternalDataArr[p];
                        $("#" + pname).val(pvalue);
                    }
                } else {
                    alert("获取内部接口数据失败！错误信息：" + ret.Message);
                }
            }
        });
    }
    ///
}


//设置字典和日期控件背景
function SetControlBackground() {
    //$("[controltype = 'datetext']").css("background", " white url(" + basePath + "/DHCWebForm/Images/Icons/datebg.gif) no-repeat right ");
    
    //日期控件中后面显示按钮，并且绑定单击事件
    $("[controltype = 'datetext']").each(function (i, d) {
        var tmpLeft = $(d).css("left").replace("px", "");
        var tmpWidth = $(d).css("width").replace("px", "");
        tmpLeft = (parseInt(tmpLeft) + parseInt(tmpWidth)).toString() + "px";
        var tmpId = $(d).attr("id");
       	var curElement = $("#" + tmpId);      	
        if(curElement[0].style.display==""){
       		$(d).parent().append("<img id=Date_Img_"+tmpId+" onclick='javascript:bill_ondblclick(undefined,\"" + tmpId + "\")' style='position:absolute; cursor:pointer; top:" + $(d).css("top") + "; left:" + tmpLeft + "; width:20px; height:20px;' src='" + fcpubdata.sourcePath + "Images/Icons/datebg.gif'/>");
    	}
    	if(curElement[0].style.display=="none"){
    		$(d).parent().append("<img id=Date_Img_"+tmpId+"disabled='disabled' onclick='javascript:bill_ondblclick(undefined,\"" + tmpId + "\")' style='display:none;position:absolute; cursor:pointer; top:" + $(d).css("top") + "; left:" + tmpLeft + "; width:20px; height:20px;' src='" + fcpubdata.sourcePath + "Images/Icons/datebg.gif'/>");
    	}
    	if((curElement[0].disabled)||(curElement[0].readOnly)){
       		$("#"+"Date_Img_"+tmpId).attr('disabled','true');
       		//$("#"+"Date_Img_"+tmpId).removeAttr('onclick');
       	}
    });

    //字典控件后面显示按钮，但是没有事件
    $("[controltype = 'dictionary']").each(function (i, d) {
        var tmpLeft = $(d).css("left").replace("px", "");
        var tmpWidth = $(d).css("width").replace("px", "");
        tmpLeft = (parseInt(tmpLeft) + parseInt(tmpWidth)).toString() + "px";
        var tmpId = $(d).attr("id");
    	var curElement = $("#" + tmpId);
        if(curElement[0].style.display==""){
       		$(d).parent().append("<img id=Dic_Img_"+tmpId+" onclick='OpenDictionaryData(\"" + tmpId + "\")' style='position:absolute; cursor:pointer; top:" + $(d).css("top") + "; left:" + tmpLeft + "; width:20px; height:20px;' src='" + fcpubdata.sourcePath + "Images/ef_designer_fccode2.gif'/>");
    	}
    	if(curElement[0].style.display=="none"){
    		$(d).parent().append("<img id=Dic_Img_"+tmpId+" onclick='OpenDictionaryData(\"" + tmpId + "\")' style='display:none;position:absolute; cursor:pointer; top:" + $(d).css("top") + "; left:" + tmpLeft + "; width:20px; height:20px;' src='" + fcpubdata.sourcePath + "Images/ef_designer_fccode2.gif'/>");
    	}
		if((curElement[0].disabled)||(curElement[0].readOnly)){
       		$("#"+"Dic_Img_"+tmpId).attr('disabled','true');
       	}
    });
    //$("[controltype = 'dictionary']").css("background", " white url(" + basePath + "/DHCWebForm/Images/ef_designer_fccode2.gif) no-repeat right ");
}

function SetFocusOrder() {
    $("input", "fieldset").attr("tabIndex", "3000");
    var orderXml = $("#SKbillsheet").attr("billtaborder");
    var orderDOM = SetDom(orderXml);
    if (orderDOM.documentElement != null && orderDOM.documentElement.childNodes != null){
    	for (var i = 0; i < orderDOM.documentElement.childNodes.length;i++ ) {
        var curNode = orderDOM.documentElement.childNodes[i];
        var sid = curNode.text.split("^")[0];
        $("#" + sid).attr("tabIndex", (i+1).toString());
    	}
    }
}

//处理表单打开前事件
function DoBLOpenBefore() {
    var beforEventStr = $("#SKbillsheet").attr("BLONopenBefore");
    if (beforEventStr != null && beforEventStr != "") {
        var beforEventEntity = eval("(" + beforEventStr + ")");
        if (beforEventEntity != null) {
            var funcStr = beforEventEntity.FuncExpress;
            eval(funcStr);
        }
    }
}

//处理表单加载数据前事件
function DoBLLoadDataBefore() {
    var closeEventStr = $("#SKbillsheet").attr("BLONclose");
    if (closeEventStr != null && closeEventStr != "") {
        var closeEventEntity = eval("(" + closeEventStr + ")");
        if (closeEventEntity != null) {
            var funcStr = closeEventEntity.FuncExpress;
            eval(funcStr);
        }
    }
}

//表单加载数据
function DoBLLoadData() {
    var pathArr = location.pathname.split("/");


    var parTableName = new Array();

    var formObj = new Object();
    formObj["EName"] = TableName;
    formObj["Type"] = "CRF";
    parTableName.push(formObj);

    var Conditions = new Array();

    var curCondition = new DataField();
    curCondition.EName = "ID";
    var ValArr = new Array();
    ValArr.push(PrimaryKey);
    curCondition.Value = ValArr;
    curCondition.Condition = "=";
    curCondition.Type = "int";
    curCondition.TableName = TableName;
    curCondition.TableType = "CRF";
    Conditions.push(curCondition);
		
		if (PrimaryKey != "") {
			params = { keyId: PrimaryKey,formId: curFormId };
			//params.FormInfo = $.toJSON(formObj);
			
			params.ClassName = "DHCMed.CR.BO.DataService";
			params.MethodName = "GetInstanceData";
		
	    $.ajax({
	        type: "POST",
	        url:  fcpubdata.runMethod,  //"dhcmed.crf.getinstancedata.csp",
	        dataType: "text",
	        async: false,
	        data: params,
	        success: function (ret) {
	        	ret = eval("("+ret+")");
	          if (ret.Result) {
	              retFlag = true;
	              data = ret.DataObject;
	              //alert($.toJSON(data));
	              for (p in data){
	              	//按类型区分
	              	var curObj = $("#" + p.toString());
                  var curCurControlType = $("#" + p.toString()).attr("controltype");
                  if (curObj.length > 0) {
                      switch (curCurControlType) {
                          case "radio": 
                          	{
                          		var curValue = data[p.toString()];
                              if (curValue != null && curValue != "") {
                                  $("#" + p.toString()).find("input[value='" + curValue + "']").attr("checked", true);
                                  $("#" + p.toString()).find("input[value='" + curValue + "']").click();
                              }
                              break;
                             }
                          case "checkbox":
                          	{
                          		var curValue = data[p.toString()];
                              if (curValue != null && curValue != "") {
                                  var trueValue = $("#" + p.toString()).attr("trueValue");
                                  var falseValue = $("#" + p.toString()).attr("falseValue");
                                  if ($("#" + p.toString()).attr("disabled")) {
                                      $("#" + p.toString()).find("input[type='checkbox']").attr("checked", curValue == trueValue);
                                  } else {
                                      $("#" + p.toString()).find("input[type='checkbox']").attr("checked", curValue != trueValue);
                                      $("#" + p.toString()).find("input[type='checkbox']").click();
                                  }
                                  $("#" + p.toString()).val(curValue);
                              }
                              break;    
                          	}
                          case "dictionary":
                          	{
                          		var curValue = data[p.toString()];
                              if (curValue != null && curValue != "") {
                                  $("#" + p.toString()).val(data["H" + p.toString()]);
                                  $("#" + p.toString()).attr("Eval", data[p]);
                              }
                              break;
                          	}
                          default:
                          	{
                          		$("#" + p.toString()).val(data[p.toString()]);
                          	}
                      }
                   }
	              }
	              
	          } else {
	              alert("获取数据失败！错误信息：" + ret.Message);
	          }
	        },
					error:function(e,i){
						debugger;
					}
	    	});
		}
	
 }

//处理表单打开后事件
function DoBLOpenAfter() {
	var openEventStr = $("#SKbillsheet").attr("BLONopen");
	if (openEventStr != null && openEventStr != "") {
		var openEventEntity = eval("(" + openEventStr + ")");
		if (openEventEntity != null) {
			var funcStr = openEventEntity.FuncExpress;
			eval(funcStr);
		}
	}
}

$(document).ready(function () {
    //处理控件的焦点
    SetFocusOrder();
	
    //------------------------
    $("body").click(function () {
         $("#CRFSmartDiv").remove();
    });
	
    $("[controltype]").mouseover(function () {
        bill_onmouseover();
    });
	
    //处理表单打开之前的事件
    DoBLOpenBefore();
	
	var design = GetParameter("design");
	
	//调整打印、预览样式
	if ((GetParameter("printed") == "1")||(GetParameter("printed") == "3")) {
		$(document).find("*").unbind();                        //取消事件绑定
		$(document).find("*").removeAttr("onmouseover");       //取消事件绑定
		//$(document).find("*").css("background-color", "white");
		$(document).find("*").css("background-color", "transparent");
		$("#SKbillsheet").find("button").css("display", "none");
		var DataControls = $("[controltype='text'],[controltype='textarea'],[controltype='radio'],[controltype='checkbox'],[controltype='combobox'],[controltype='dictionary'],[controltype='numbertext'],[controltype='datetext'],[controltype='timetext']");
		for (var i = 0; i < DataControls.length; i++) {
			var p = DataControls[i];
			if (typeof p.style == 'object'){
				p.style.borderTop="";
				p.style.borderLeft="";
				p.style.borderRight="";
				p.style.borderBottom="";
			}
		}
		
		var DataControls = $("[controltype='textarea']");
		for (var i = 0; i < DataControls.length; i++) {
			var p = DataControls[i];
			if (typeof p.style == 'object'){
				p.style.width="100%";
				p.style.height="100%";
				p.style.border="none";
				p.style.overflow="hidden";
			}
		}
    } else {
		//设置背景色,统一用无色
		$(document).find("*").css("background-color", "transparent");
		
		//去掉单选钮边框
		var DataControls = $("[controltype='radio']");
        for (var i = 0; i < DataControls.length; i++) {
         	var p = DataControls[i];
			if (typeof p.style == 'object'){
				p.style.borderTop="";
				p.style.borderLeft="";
				p.style.borderRight="";
				p.style.borderBottom="";
			}
     	}
		
        //设置字典和日期控件背景
        SetControlBackground();

        //加载内部数据
        //LoadInternalData();

        //加载外部数据 
        if ((design=="")&&(PrimaryKey=="")){
       		LoadExternalData();
       	}
    }

    //处理表单数据加载的事件(暂时用close事件代替)
    DoBLLoadDataBefore();

    //加载数据
    if (design==""){
     	DoBLLoadData();
   	}

    //处理表单打开之后的事件
    DoBLOpenAfter();
     
    //输出打印
    if ((GetParameter("printed") == "2")||(GetParameter("printed") == "3")) {
		window.focus();
     	window.print();
     	//window.close();
    }
 });