//完整的格式化js方法  var time2 = new Date().format("yyyy-MM-dd HH:mm:ss");
//c#后台的格式化方法 now.Date.ToString("yyyy-MM-dd HH:mm:ss")
Date.prototype.format = function (fmt) {
    var o = {
        "M+": this.getMonth() + 1,                 //月份 
        "d+": this.getDate(),                    //日 
        "H+": this.getHours(),                   //小时 
        "m+": this.getMinutes(),                 //分 
        "s+": this.getSeconds(),                 //秒 
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
        "S": this.getMilliseconds()             //毫秒 
    };
    //处理年份
    var reYear = /(y+)/;
    var resultYear = reYear.exec(fmt);
    if (resultYear) {
        var yearformatPart = resultYear[0];//匹配到的格式化字符
        var yearVal = (this.getFullYear() + "").substr(4 - yearformatPart.length);
        fmt = fmt.replace(yearformatPart, yearVal);
    }
    for (var k in o) {
        var re = new RegExp("(" + k + ")");
        var res = re.exec(fmt);
        if (res) {
            var Val = "" + o[k];//本次需要替换的数据 
            var formatPart = res[0];//匹配到的格式化字符
            var replaceVal = (formatPart.length == 1) ? (Val) : (("00" + Val).substr(Val.length));
            fmt = fmt.replace(formatPart, replaceVal);
        }
    }
    return fmt;
}
Date.prototype.AddDays = function (days) {
    var olddays = this.getDate();
    var newdays = olddays + days;
    this.setDate(newdays);
    return this;
}
/*获取到年月日，时分秒，毫秒几个值，然后生成日期
第一个参数为格式化的日期字符串，格式化的字符串
测试代码
var data=new Date();
var  format ="yyyy-MM-dd HH:mm:ss";
var text=data.format(format);
alert(text);
var data2=parserToDate(text,format);
alert(data2.format(format));
 */
function parserToDate(dateText, format) {
    if (!dateText) { //空值
        return new Date();
    }
    if (dateText=="t") { //今天
        return new Date();
    }
    //定义默认值，默认值根据当前时间生成
    var defaultVal = new Date();
    var year = defaultVal.getFullYear();
    var month = defaultVal.getMonth() + 1;
    var day = defaultVal.getDate();
    var hours = defaultVal.getHours();
    var minutes = defaultVal.getMinutes();
    var seconds = defaultVal.getSeconds();
    var milliseconds = defaultVal.getMilliseconds();
    //定义正则
    var o = [{
        reg: "y+"
    }, //年份
		{
		    reg: "M+"
		}, //月份
		{
		    reg: "d+"
		}, //日
		{
		    reg: "H+"
		}, //小时
		{
		    reg: "m+"
		}, //分
		{
		    reg: "s+"
		}, //秒
		{
		    reg: "S"
		} //毫秒
    ];
    //获取到年月日，时分秒，毫秒几个值在字符串中的先后位置
    var index = 1;
    for (var j = 0; j < format.length; j++) {
        var onechar = format[j];
        for (var i = 0; i < o.length; i++) {
            var onepart = o[i]
            var onepartReg = onepart.reg;
            if (onepartReg[0] == onechar) {
                if (!onepart.index) {
                    onepart.index = index; //获取到年月日，时分秒，毫秒几个值在字符串中的先后位置
                    index++;
                }
                break;
            }
        }

    }
    //生成匹配的正则表达式
    for (var i = 0; i < o.length; i++) {
        var onepart = o[i]
        var onepartReg = onepart.reg;
        var re = new RegExp("(" + onepartReg + ")");
        var res = re.exec(format);
        if (res) {
            var formatPart = res[0]; //匹配到的格式化字符
            var replaceVal = "([0-9]{" + formatPart.length + "})"; //不能使用/d匹配,会和日期的d冲突
            format = format.replace(formatPart, replaceVal);
        }
    }
    //保存获取到的各个部分和位置
    var dataInfo = {};
    var re = new RegExp(format);
    var res = re.exec(dateText);
    //去掉第一个匹配，记录匹配到的数据
    if (res) {
        for (var i = 1; i < res.length; i++) {
            dataInfo[i] = res[i]; //记录年月日，时分秒，毫秒几个值在字符串中的位置和对应的值
        }
    } else {     
        return new Date();
    }
    if (o[0].index) //年份存在
    {
        var index = o[0].index;
        year = dataInfo[index];
    }
    if (o[1].index) //月份存在
    {
        var index = o[1].index;
        month = dataInfo[index];
    }
    if (o[2].index) //日存在
    {
        var index = o[2].index;
        day = dataInfo[index];
    }
    if (o[3].index) //小时存在
    {
        var index = o[3].index;
        hours = dataInfo[index];
    }
    if (o[4].index) //分存在
    {
        var index = o[4].index;
        minutes = dataInfo[index];
    }
    if (o[5].index) //秒存在
    {
        var index = o[5].index;
        seconds = dataInfo[index];
    }
    if (o[6].index) //毫秒存在
    {
        var index = o[6].index;
        milliseconds = dataInfo[index];
    }
    //月份是从0开始的
    return new Date(year, month - 1, day, hours, minutes, seconds, milliseconds);
}

function isTime(str,pName) {
    var a = str.match(/^(\d{1,2})(:)(\d{1,2})$/);
    if (a == null) {
        if (!!pName)
            alert('【' + pName + '】不是时间格式');
        return false;
    }
    if (a[1] > 24 || a[3] > 60) {
        if (!!pName)
            alert("【" + pName + "】时间格式不对");
        return false
    }
    return true;
}

function FormatDateByyyyyMMdd(value,format)
{
    var text = value;
    var Format = format;
    if (Format != "yyyy-MM-dd") {
        var data2 = parserToDate(value, Format);
        text = data2.format("yyyy-MM-dd");
    }
    return text;
}

