/*发生级联时，应该调用的函数,用于判断是否满足条件
满足返回true，否则返回false
第一个参数为input的值，第二个参数为参与比较的值

多选，下拉多选时集合元素相等
第一个参数ValueByNameOrId是通过getValueByName，getValueById获取到的值需要处理后变成简单的文字，而不是对象
第二个参数simpleValArry是此函数需要用到的其他参数，是一个数组
因为
*/
//空数组,没有选中
function EqEmptyArray(ValueByNameOrId) {
    return ValueByNameOrId.length==0;
}
//非空数组,有选中
function EqUnEmptyArray(ValueByNameOrId) {
    return !EqEmptyArray(ValueByNameOrId);
}
//text12集合包含text1的任意元素
function ContainsAnyArry(idListString, text12) {
    var strs1 = new Array(); //定义一数组 
    strs1 = idListString.split(","); //字符分割 
    var strs2 = new Array(); //定义一数组 
    if ($.isArray(text12))//可能是数组
    {
        strs2 = text12; //字符分割 
    }
    else {
        strs2 = text12.split(","); //字符分割 
    }
    var has = false;
    for (var i = 0; i < strs2.length; i++) {
        var item1 = strs2[i];     
        for (var j = 0; j < strs1.length; j++) {
            var item2 = strs1[j];
            if (item2 == item1) {
                has = true;
                return has;
            }
        }
    }
    return has;
}
//text12集合不包含text1的任意元素
function NoContainsAnyArry(idListString, text12) {
    return !ContainsAnyArry(idListString, text12);
}
//无论是什么数据替换为指定值
function ConstText(ValueByNameOrId) {
    return true;
}
//空字符串
function EqEmptyText(ValueByNameOrId) {
    return "" == ValueByNameOrId;
}
//非空字符串
function EqUnEmptyText(ValueByNameOrId) {
    return !EqEmptyText(ValueByNameOrId);
}
//包含串
function ContainsText(ValueByNameOrId, simpleValArry) {
    var simpleVal = simpleValArry[0];
    return ValueByNameOrId.indexOf(simpleVal) != -1;
}
//不包含串
function NContainsText(ValueByNameOrId, simpleValArry) {
    var simpleVal = simpleValArry[0];
    return ValueByNameOrId.indexOf(simpleVal) == -1;
}
//等于
function EqText(ValueByNameOrId, simpleValArry) {
    var simpleVal = simpleValArry[0];
    return simpleVal == ValueByNameOrId;
}
//不等于
function NEqText(ValueByNameOrId, simpleValArry) {
    var simpleVal = simpleValArry[0];
    return simpleVal != ValueByNameOrId;
}
//大于
function GrText(ValueByNameOrId, simpleValArry) {
    var simpleVal = simpleValArry[0];
    return ValueByNameOrId > simpleVal;
}
//大于等于
function GrEqText(ValueByNameOrId, simpleValArry) {

    return GrText(ValueByNameOrId, simpleValArry) || EqText(ValueByNameOrId, simpleValArry);
}
//小于
function LeText(ValueByNameOrId, simpleValArry) {
    var simpleVal = simpleValArry[0];
    return ValueByNameOrId < simpleVal;
}
//小于等于
function LeEqText(ValueByNameOrId, simpleValArry) {
    var simpleVal = simpleValArry[0];
    return LeText(ValueByNameOrId, simpleVal) || EqText(ValueByNameOrId, simpleVal);
}

//等于
function EqNumber(ValueByNameOrId, simpleValArry) {
    var simpleVal = simpleValArry[0];
    if (ValueByNameOrId === "")
    {
        return false;
    }
    return (+simpleVal) == (+ValueByNameOrId);
}
//不等于
function NEqNumber(ValueByNameOrId, simpleValArry) {
    var simpleVal = simpleValArry[0];
    if (ValueByNameOrId === "") {
        return false;
    }
    return (+simpleVal) != (+ValueByNameOrId);
}
//大于
function GrNumber(ValueByNameOrId, simpleValArry) {
    var simpleVal = simpleValArry[0];
    if (ValueByNameOrId === "") {
        return false;
    }
    return (+ValueByNameOrId) > (+simpleVal);
}
//大于等于
function GrEqNumber(ValueByNameOrId, simpleValArry) {
    if (ValueByNameOrId === "") {
        return false;
    }
    return GrNumber(ValueByNameOrId, simpleValArry) || EqNumber(ValueByNameOrId, simpleValArry);
}
//小于
function LeNumber(ValueByNameOrId, simpleValArry) {
    var simpleVal = simpleValArry[0];
    if (ValueByNameOrId === "") {
        return false;
    }
    return (+ValueByNameOrId) < (+simpleVal);
}
//小于等于
function LeEqNumber(ValueByNameOrId, simpleValArry) {
    if (ValueByNameOrId === "") {
        return false;
    }
    return LeNumber(ValueByNameOrId, simpleValArry) || EqNumber(ValueByNameOrId, simpleValArry);
}
//范围>=Number1 &&<=Number2
function GrEqNumber1LeEqNumber2(ValueByNameOrId, simpleValArry) {
    if (ValueByNameOrId === "") {
        return false;
    }
    var simpleValArry2 = new Array();
    simpleValArry2.push(simpleValArry[1]);
    return GrEqNumber(ValueByNameOrId, simpleValArry) && LeEqNumber(ValueByNameOrId, simpleValArry2);
}
//范围>=Number1 &&<Number2
function GrEqNumber1LeNumber2(ValueByNameOrId, simpleValArry) {
    if (ValueByNameOrId === "") {
        return false;
    }
    var simpleValArry2 = new Array();
    simpleValArry2.push(simpleValArry[1]);
    return GrEqNumber(ValueByNameOrId, simpleValArry) && LeNumber(ValueByNameOrId, simpleValArry2);
}
//范围>Number1 &&<=Number2
function GrNumber1LeEqNumber2(ValueByNameOrId, simpleValArry) {
    if (ValueByNameOrId === "") {
        return false;
    }
    var simpleValArry2 = new Array();
    simpleValArry2.push(simpleValArry[1]);
    return GrNumber(ValueByNameOrId, simpleValArry) && LeEqNumber(ValueByNameOrId, simpleValArry2);
}
//范围>Number1 &&<Number2
function GrNumber1LeNumber2(ValueByNameOrId, simpleValArry) {
    if (ValueByNameOrId === "") {
        return false;
    }
    var simpleValArry2 = new Array();
    simpleValArry2.push(simpleValArry[1]);
    return GrNumber(ValueByNameOrId, simpleValArry) && LeNumber(ValueByNameOrId, simpleValArry2);
}

//Text>=Text1> &&Text<=Text2
function GrEqText1LeEqText2(ValueByNameOrId, simpleValArry) {
    var simpleValArry2 = new Array();
    simpleValArry2.push(simpleValArry[1]);
    return GrEqText(ValueByNameOrId, simpleValArry) && LeEqText(ValueByNameOrId, simpleValArry2);
}
//范围>=Text1 &&<Text2
function GrEqText1LeText2(ValueByNameOrId, simpleValArry) {
    var simpleValArry2 = new Array();
    simpleValArry2.push(simpleValArry[1]);
    return GrEqText(ValueByNameOrId, simpleValArry) && LeText(ValueByNameOrId, simpleValArry2);
}
//范围>Text1 &&<=Text2
function GrText1LeEqText2(ValueByNameOrId, simpleValArry) {
    var simpleValArry2 = new Array();
    simpleValArry2.push(simpleValArry[1]);
    return GrText(ValueByNameOrId, simpleValArry) && LeEqText(ValueByNameOrId, simpleValArry2);
}
//范围>Text1 &&<Text2
function GrText1LeText2(ValueByNameOrId, simpleValArry) {
    var simpleValArry2 = new Array();
    simpleValArry2.push(simpleValArry[1]);
    return GrText(ValueByNameOrId, simpleValArry) && LeText(ValueByNameOrId, simpleValArry2);
}
//两个集合包含的元素相等
function IsEqualArry(idListString, text12) {
    var strs1 = new Array(); //定义一数组 
    strs1 = idListString.split(","); //字符分割 
    var strs2 = new Array(); //定义一数组 
	if ($.isArray(text12))//可能是数组
	{  
      strs2 =text12; //字符分割 
	}
	else{
		  strs2 = text12.split(","); //字符分割 
	}
  
    var isEq = false;
    if (strs1.length == strs2.length) {
        for (var i = 0; i < strs1.length; i++) {
            var item1 = strs1[i];
            var has = false;
            for (var j = 0; j < strs2.length; j++) {
                var item2 = strs2[j];
                if (item2 == item1) {
                    has = true;
                    break;
                }
            }
            if (has == false) {
                return false;
            }
        }
        return true;
    }
    return isEq;
}

/*发生级联时，应该调用的函数,用于设置指定元素的值，或者调用指定函数
如果返回 undefined，则不需要设定值，否则需要设定值
单选多选的返回值为逗号","分隔的值,表示选中相应选项
日期为格式为"yyyy-MM-dd"的字符串
时间为格式为"HH:mm"的字符串
下拉，下拉多选，下拉单选输入框的格式为，source表示应该拥有的下拉选项，values表示应该默认选中的选项
{
	source: [{
			Text: "下拉多选选项1",
			Value: "1"
		}, {
			Text: "下拉多选选项2",
			Value: "2"
		}
	],
	values: [{
							Text: "下拉多选选项1",
							Value: "1"
						}]
}


*/
//倒7天
function GetDayminus_7() {
    var date = (new Date().AddDays(-7)).format("yyyy-MM-dd");
    return date;
}
//前一天
function GetYesterdayDate() {
    var date = (new Date().AddDays(-1)).format("yyyy-MM-dd");
    return date;
}
//当前日期
function GetCurrentDate() {
    var date = (new Date()).format("yyyy-MM-dd");
    return date;
}
//后一天
function GetTomorrowDate() {
    var date = (new Date().AddDays(1)).format("yyyy-MM-dd");
    return date;
}
//当前时间
function GetCurrentTime() {
    //var date = (new Date()).format("HH:mm");
    //return date;
    return GetServerNowTime();
}
//触发单击事件
function FireBtnClick(sender, currentvalue) {
    $("#" + sender).click();
    return undefined;
}

//自动签名
function GetCaName(sender, currentvalue) {

    var sender = $("#" + sender);
    //if (!HasValueByName(id))      //yucz 2020-2-25   注释的原因，如果护士A完成了录入，那么护士B进行修改时，应该记录护士B才对（覆盖签名）。
    JobNumEnterToName(sender, true);
    return undefined;
}

//清空签名
function ClearCaName(sender, currentvalue) {
    SetOneValue(sender, "");
    var sender = $("#" + sender);
    ClearSign(sender);
    return undefined;
}

//刷新数据源(带参数)
function RefreshDataSource(sender, currentvalue, sourceId) {
    var specifyFileds = [sender];
    var keyvalues = { keys: [], vals: [] };
    keyvalues.keys.push(sourceId);
    keyvalues.vals.push(currentvalue);
    var queryParam = ObjectToUrlParams(keyvalues, "^");;

    GetDataFromService(null, specifyFileds, null, queryParam);
}

//清空当前值
function ClearDisplayVal(sender, currentvalue, sourceId) {
    var helper = GetElementHelper(sender);
    helper.Clear(sender);
}

//单元格编辑自动签名（默认值）
function CellEditGetDefaultCaName() {
    var caName = "";
    var userCode = session['LOGON.USERCODE'];
    var dataPost = {};
    dataPost["userCode"] = session['LOGON.USERCODE'];
    dataPost["hospitalID"] = session['LOGON.HOSPID'];
    dataPost["locID"] = session['LOGON.CTLOCID'];
    var url = WebIp + "/csp/dhcnurmpgetdata.csp?ClassName=NurMp.Sources.Comm&MethodName=getUserName";
    url = GetMWToken(url);
    $.ajax({
        type: "POST",
        url: url,
        data: { datapost: JSON.stringify(dataPost) },
        async: false,
        success: function (msg) {

            var reMsg = JSON.parse(msg);
            if (!MsgIsOK(reMsg)) {
                console.log($g("获取签名账户失败"));
            }
            else
                caName = "CA" + reMsg.data + "*" + userCode;
        }
    });

    return caName;
}

//级联控制元素文本
function GetCascadingTextValue(sender, currentvalue) {

    if (!!currentvalue) {
        if ($.isArray(currentvalue)) {
            var vals = PickDropListTextValues(currentvalue);
            return vals.join();
        }
		else if ($.isPlainObject(currentvalue)){
			return currentvalue.Text;
		}
        else {
            return currentvalue;
        }
    }
    else
        return undefined;
}

//级联控制元素的数值(下拉系，单选，多选)
function GetCascadingNumberValue(sender, currentvalue) {

    if (!!currentvalue) {
        if ($.isArray(currentvalue)) {
            var vals = PickDropListNumberValues(currentvalue);
            return vals.join();
        }
		else if ($.isPlainObject(currentvalue)){
			return !!currentvalue.NumberValue ? currentvalue.NumberValue : currentvalue.Value;
		}
        else {
            return currentvalue;
        }
    }
    else
        return undefined;
}

//获取服务器当前时间
function GetServerNowTime()
{
    var nowTime = tkMakeServerCall("NurMp.Template.EventSet", "getServerTime");
    var newDate = new Date().toDateString();
    return (new Date(newDate + " " + nowTime)).format("HH:mm");
}
//获取表格编辑时，某列绑定了数据源，取它的数据
//使用场景：表格编辑，新增行（默认值的一种）
function GetTableEditDataSourceRefDefaultValue(identity)
{
    var testReg = /^edit/;
    var templateVersionGuid = "";
    var specifyFiled = identity;
    if (testReg.test(identity)) {
        var tableID = GetTableIdByIndentity(identity);
        var opts = $('#' + tableID).datagrid('options');
        specifyFiled = GetTableFieldByIndentity(identity);
        templateVersionGuid = opts.bandingTemplateGuid;
    }

    var re = "";
    var dataPost = {};
    var queryObj = GetQueryObject();
    if (!!templateVersionGuid) {
        dataPost["templateVersionGuid"] = templateVersionGuid;
    } else {
        dataPost["templateVersionGuid"] = window.TemplateGUID;
    }
    if (!!specifyFiled) {
        dataPost["specifyFileds"] = [specifyFiled];
    }
    if (!!queryObj["EpisodeID"])
        dataPost["EpisodeID"] = queryObj["EpisodeID"];
    else
        dataPost["EpisodeID"] = window.EpisodeID;
    var url = WebIp + "/csp/dhcnurmpgetdata.csp?ClassName=NurMp.TemplateSet&MethodName=GetCodeList";
    url = GetMWToken(url);
    $.ajax({
        type: "POST",
        url: url,
        data: { datapost: JSON.stringify(dataPost) },
        async: false, 
        success: function (msg) {
            var reMsg = JSON.parse(msg);
            if (!MsgIsOK(reMsg)) {
                console.log("获取表格编辑数据源默认值失败：" + reMsg.msg);
            }
            else {
                if (!!reMsg.data[specifyFiled])
                    re = reMsg.data[specifyFiled];
            }         
        }
    });

    return re;
}

//获取根据表头加载数据项
function GetTableEditDyTitleDependency(identity) {

    var title = "";
    var field = GetTableFieldByIndentity(identity);
    var titleSpan = $("td[field='" + field + "']").find("span").first();
    if (titleSpan.length == 0)
        return { source: [], values: [] };
    else
        title = $(titleSpan).text();

    var LocID = session['LOGON.CTLOCID'];
    var ModelID = GetQueryString("ModelId");
    var ColInfo = [{ dropInputId: field, dyTitle: title }];

    var jsonData = $cm({
        ClassName: "NurMp.Service.Template.Header",
        MethodName: "GetHeaderColItem",
        ColInfo: JSON.stringify(ColInfo),
        LocID: LocID,
        ModelID: ModelID
    }, false);


    var ret = jsonData[field];
    return ret;
}


//获取根据表头加载数据项批量
function GetTableEditDyTitleDependencyBatch(ColInfo) {

    var LocID = session['LOGON.CTLOCID'];
    var ModelID = GetQueryString("ModelId");

    var jsonData = $cm({
        ClassName: "NurMp.Service.Template.Header",
        MethodName: "GetHeaderColItem",
        ColInfo: JSON.stringify(ColInfo),
        LocID: LocID,
        ModelID: ModelID
    }, false);


    return jsonData;
}

