//20210802
var dhc={
    /*
    获取url传递的参数值
    */
    getUrlParam:function(name)
    {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
        var r = window.location.search.substr(1).match(reg);
        if (r != null) return unescape(r[2]);
        return null;
    }	
}
var RowId=dhc.getUrlParam("RowId");
var opsId=dhc.getUrlParam("opsId");
var MouldId=dhc.getUrlParam("MouldId");
var Index=dhc.getUrlParam("Index");

if (RowId>0) {
 
var moudl=dhccl.runServerMethod(ANCLS.BLL.OperFollowup,"GetFollowupMouldDetails",MouldId)
//alert(moudl)
$("#Mould").append(moudl.result);
$("#Mould").append('<form id="followupForm" method="post"><div class="form-rows" style="text-align:center"><div class="form-row"><span class="form-btn"><a href="#" id="btnSave" class="hisui-linkbutton">保存</a></span><span><a href="#" id="btnFinish" class="hisui-linkbutton">本次随访完成</a></span></div></div></form>');
}
else{
$("#Mould").append('<div  id="OperFollowupDayDetailsNull" name="OperFollowupDayDetailsNull" style="width: 536px;color:#999999;line-Height:500px;text-align:center;">当前记录无数据</div>');
}
function initPage(){
    //设置默认值
    initForm();
    setCheckChange();   //加载元素属性
    initFollowupDetails();
}

function initForm(){

    //保存随访明细
    $("#btnSave").linkbutton({
        onClick: function() {
            saveFollowupDetails(".operdata");
        }
    });

    //随访完成
    $("#btnFinish").linkbutton({
        onClick: function() {
            if(RowId){
                var ret=isDataIntegrityNew(".operdata");
                //alert(ret)
                if(ret!="")
                {
                    $.messager.alert("提示",ret,"error")
                    return;
                }
                var ret=dhccl.runServerMethod(ANCLS.BLL.OperFollowup,"FinishFollowupDetails",RowId);
                //alert(123)
                if (ret=="0")
                {
					var retAnAudit=dhccl.runServerMethodNormal("web.DHCANAdaptor","UpdateOperCircle",opsId,session.UserID,"20");
                    saveFollowupDetails(".operdata");
                    //刷新随访列表
                    var sibling = parent.document.getElementById("OperFollowupDayList").contentWindow;
                    sibling.$("#followupList").datagrid("reload");
                }
            }
            else
            {
                $.messager.alert("提示","请选择一行！","error");
                return;
            }
        }
    });
}


function setCheckChange() {
    $("input[type='checkbox']").each(function(index, item) {
        var dataFormItem = $(this).attr("data-formitem");
        if ($(this).hasClass("hisui-checkbox") && dataFormItem && dataFormItem !== "") {
            $(this).checkbox("options").onCheckChange = checkboxCheckChange;
        }
    });
}

function checkboxCheckChange(e, value) {
    var curCheckItem = $(this);
    var formItem = $(this).attr("data-formitem");
    if (!formItem || formItem === "") return;
    var checkSelector = "#" + $(this).attr("id");
    var dataSelector = "#" + formItem;
    //return;
    if (value === false) {
        operDataManager.setFormDataValue(formItem, $(this).attr("id"), value);
        if (operDataManager.checkChangeCallBack) {
            operDataManager.checkChangeCallBack();
        }
        return;
    }
   
    var multiChoice = $(dataSelector).attr("data-multiple") === "N" ? false : true;
    if (multiChoice === true) return;
    var groupSelector = "input[data-formitem='" + formItem + "']";
    var checkLabel = $(this).attr("label");
    if (!checkLabel || checkLabel === "") {
        checkLabel = $(this).attr("value");
    }
    $(groupSelector).each(function(index, item) {
        var curLabel = $(this).attr("label");
        if (!curLabel || curLabel === "") {
            curLabel = $(this).attr("value");
        }
        if (curLabel !== checkLabel) {
            $(this).checkbox("setValue", false);
        }
    });
    operDataManager.setFormDataValue(formItem, $(this).attr("id"), value);
    if (operDataManager.checkChangeCallBack) {
        operDataManager.checkChangeCallBack();
    }
}

//加载随访明细
function initFollowupDetails()
{
    clearData(".operdata")
    if(RowId)
    {
        var operDatas = getOperDatas();
        operDataManager.setFormOperDatas(operDatas);
    }
}

//保存随访明细
function saveFollowupDetails(selector)
{
    if(RowId){
        var operDataSelector = (selector && selector != "") ? selector : ".operdata";
        var operDatas = getFormOperDatas(operDataSelector);
        if (!operDatas || !operDatas.length || operDatas.length <= 0) return;
        var jsonData = dhccl.formatObjects(operDatas);  
        var ret=dhccl.runServerMethod(ANCLS.BLL.OperFollowup,"SaveFollowupDetails",RowId,jsonData);
        if(ret=="0")
        {
            $.messager.alert("提示","保存成功！")
            initFollowupDetails();
        }
        else
        {
            $.messager.alert("提示","保存失败，原因："+ret,"error")
        }
    }
    else
    {
        $.messager.alert("提示","请选择一行随访记录！","error");
        return;
    }
}

//判断必填内容
function isDataIntegrityNew(clsSelector){
    var ret=true,messages=[];

    $(clsSelector).each(function(index,el){
        var selector = "#" + $(el).attr("id");
        var enabled=operDataManager.getOperDataAbleStatus(selector);
        //alert(selector+"^"+enabled)
        if(enabled===false) return;
        var required=$(selector).attr("data-required");
        if(required!=="Y"){
            return;
        }
        
        var dataRowId=$(selector).attr("data-rowid");
        var dataValue=$(selector).attr("data-value");
        var dataScore=$(selector).attr("data-score");
        var dataMsg=$(selector).attr("data-title");
        if((dataRowId && dataRowId!=="") && ((dataValue && dataValue!=="") || (dataScore && dataScore!==""))) return;

        var hasDirtyValue=operDataManager.existsDirtyValue(selector);
        //alert(selector+"^"+hasDirtyValue)
        if(hasDirtyValue) return;
        ret=false;
        messages.push("未选择"+" "+dataMsg);
    });
    var message="";
    if(messages.length>0){
        message=messages.join(",");
    }
    return message;
}

//获取随访明细
function getOperDatas() {
    var operDatas = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.OperFollowup,
        QueryName: "FindFollowupDetails",
        Arg1: RowId,
        ArgCnt: 1
    }, "json");
    return operDatas;
}

//获取随访明细内容(保存用)
function getFormOperDatas(clsSelector) {
    var valueArr = [];
    var dataValue = null;
    var operDatas = [];
    $(clsSelector).each(function(index, el) {
        valueArr.length = 0;
        dataValue = null;
        var selector = "#" + $(el).attr("id");
        //alert(selector)
        var enabled = operDataManager.getControlAbleStatus($(selector));
        if (enabled === false) return;
        var checkSelector = "input[data-formitem='" + $(el).attr("id") + "']";
        if ($(checkSelector).length > 0) {
            var controlEnabled;
            $(checkSelector).each(function(checkInd, checkItem) {
                enabled = operDataManager.getControlAbleStatus($(checkItem));
                if (enabled === false)
                {
                    controlEnabled=false;
                    return;
                }
                var checkValue = false;
                if ($(checkItem).hasClass("hisui-checkbox")) {
                    checkValue = $(checkItem).checkbox("getValue");
                } else if ($(checkItem).hasClass("hisui-radio")) {
                    checkValue = $(checkItem).radio("getValue");
                }
                if (!checkValue) return;
                if (valueArr.length > 0) valueArr.push(splitchar.comma);
                var curLabel = $(checkItem).attr("label");
                if (!curLabel || curLabel === "") {
                    curLabel = $(checkItem).attr("value");
                }
                
                valueArr.push(curLabel);
            });
            if(controlEnabled===false) return;
            dataValue = valueArr.join(splitchar.empty);
        } else {
            dataValue = operDataManager.getControlValue($(el));
        }
        var dataControl=$(selector).attr("data-control");
        if(dataControl && dataControl==="N"){
            dataValue=$(selector).attr("data-value");
        }
        var dataScore = $(el).attr("data-score");
        var operDataId = $(el).attr("data-rowid");
        // 如果不是已保存过的数据，且数据值或分数值为空，那么不保存
        if ((!operDataId || operDataId === "") && (!dataValue || dataValue === "") && (!dataScore || dataScore === "")) return;
        operDatas.push({
            RowId: $(el).attr("data-rowid"),
            RecordSheet: session.RecordSheetID,
            DataItem: $(el).attr("id"),
            DataValue: dataValue,
            UpdateUserID: session.UserID,
            ClassName: "CIS.AN.OperFollowupDetails",
            DataScore: dataScore ? dataScore : ""
        });
    });

    return operDatas;
}

//清除随访明细(切换记录用)
function clearData(clsSelector) {
    $(clsSelector).each(function(index, el) {
        var selector = "#" + $(el).attr("id");
        //alert(selector)
        var enabled = operDataManager.getControlAbleStatus($(selector));
        if (enabled === false) return;
        var checkSelector = "input[data-formitem='" + $(el).attr("id") + "']";
        if ($(checkSelector).length > 0) {
            var controlEnabled;
            $(checkSelector).each(function(checkInd, checkItem) {
                enabled = operDataManager.getControlAbleStatus($(checkItem));
                if (enabled === false)
                {
                    controlEnabled=false;
                    return;
                }
                var checkValue = false;
                if ($(checkItem).hasClass("hisui-checkbox")) {
                    $(checkItem).checkbox('setValue',false);
                } else if ($(checkItem).hasClass("hisui-radio")) {
                    checkValue = $(checkItem).radio('setValue',false);
                }
                if (!checkValue) return;
                var curLabel = $(checkItem).attr("label");
                if (!curLabel || curLabel === "") {
                    curLabel = $(checkItem).attr("value");
                }
            });
            if(controlEnabled===false) return;
        } else {
            clearControlValue($(el));
        }
        $(el).removeAttr("data-rowid")
        
       
    });
}

//清除界面元素内容
function clearControlValue(jqueryObj) {
    if (jqueryObj.hasClass(Controls.ComboBox)) {
         ret = jqueryObj.combobox("clear");
    } else if (jqueryObj.hasClass(Controls.CheckBox)) {
        jqueryObj.checkbox('setValue',false);

    } else if (jqueryObj.hasClass(Controls.Radio)) {
        jqueryObj.radio('setValue',false);
    } else if (jqueryObj.hasClass(Controls.DateBox)) {
        jqueryObj.datebox("clear");
    } else if (jqueryObj.hasClass(Controls.DateTimeBox)) {
        jqueryObj.datetimebox("clear");
    } else if (jqueryObj.hasClass(Controls.ValidateBox)) {
        jqueryObj.val("");
    } else if (jqueryObj.hasClass(Controls.NumberBox)) {
        jqueryObj.numberbox('setValue',"")
    } else if (jqueryObj.hasClass(Controls.TimeSpinner)) {
        queryObj.timespinner('setValue',"")
    } else {
        jqueryObj.val("");
    }
}

$(document).ready(initPage);

