$NURURL = "dhc.nurse.ip.common.getdata.csp"
/**
 * @description 日期格式化
 * @param {*} date 
 */
function formatDate(date) {
    if (date && typeof date === 'object') {
        var day = date.getDate();
        day = day < 10 ? ('0' + day) : day;
        var monthIndex = date.getMonth() + 1;
        monthIndex = monthIndex < 10 ? ('0' + monthIndex) : monthIndex;
        var year = date.getFullYear();
        return year + '-' + monthIndex + '-' + day;
    } else if (date && typeof date === 'string') {
        var reg = /((^((1[8-9]\d{2})|([2-9]\d{3}))([-\/\._])(10|12|0?[13578])([-\/\._])(3[01]|[12][0-9]|0?[1-9])$)|(^((1[8-9]\d{2})|([2-9]\d{3}))([-\/\._])(11|0?[469])([-\/\._])(30|[12][0-9]|0?[1-9])$)|(^((1[8-9]\d{2})|([2-9]\d{3}))([-\/\._])(0?2)([-\/\._])(2[0-8]|1[0-9]|0?[1-9])$)|(^([2468][048]00)([-\/\._])(0?2)([-\/\._])(29)$)|(^([3579][26]00)([-\/\._])(0?2)([-\/\._])(29)$)|(^([1][89][0][48])([-\/\._])(0?2)([-\/\._])(29)$)|(^([2-9][0-9][0][48])([-\/\._])(0?2)([-\/\._])(29)$)|(^([1][89][2468][048])([-\/\._])(0?2)([-\/\._])(29)$)|(^([2-9][0-9][2468][048])([-\/\._])(0?2)([-\/\._])(29)$)|(^([1][89][13579][26])([-\/\._])(0?2)([-\/\._])(29)$)|(^([2-9][0-9][13579][26])([-\/\._])(0?2)([-\/\._])(29)$))/gi;
        if (reg.test(date)) {
            return date;
        }
        else {
            var regDDMMYYY = /(0[1-9]|[12][0-9]|3[01])[/](0[1-9]|1[012])[/](19|20)[0-9]{2}/gi;
            if (regDDMMYYY.test(date)) {
                var yyyy = date.split('/')[2];
                var MM = date.split('/')[1];
                var dd = date.split('/')[0];
                date = yyyy + '-' + MM + '-' + dd;;
                if (reg.test(date)) {
                    return date;
                }
            }
        }
    }
    return '';
}
/**
 * @author SongChao
 * @description 比较第一个时期是否大于第二个日期
 * @param {*} date1 
 * @param {*} date2 
 */
function compareDate(date1,date2){
	date1=formatDate(date1);
	date2=formatDate(date2);
	var formatDate1 = new Date(date1);
    var formatDate2 = new Date(date2);
    if(formatDate1 > formatDate2)
    {
        return 1;
    }
	else if(formatDate1.getTime() == formatDate2.getTime())
    {
        return 0;
    }
    else
    {
        return -1;
    }
}
/**
 * @author SongChao
 * @description 比较第一个时期是否大于第二个日期
 * @param {*} date1 
 * @param {*} date2 
 */
function compareTime(time1,time2){
	var formatTime1 = new Date("2020-01-01 "+time1);
    var formatTime2 = new Date("2020-01-01 "+time2);
    if(formatTime1 > formatTime2)
    {
        return 1;
    }
	else if(formatTime1.getTime() == formatTime2.getTime())
    {
        return 0;
    }
    else
    {
        return -1;
    }
}
/**
 * @author SongChao
 * @description 日期加减运算
 * @param {*} date 
 * @param {*} days 
 */
function dateCalculate(date, days) {
    var ret = "";
    if (date && typeof date === 'object') {
        var now = date;
        now.setDate(now.getDate() + days);
        ret = formatDate(now);
    }
    else if (date && typeof date === 'string') {
        if (checkDate(date)) {
            var result = date.match(/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/);
            if (result == null)
                return false;
            var now = new Date(result[1], result[3] - 1, result[4]);
            now.setDate(now.getDate() + days);
            ret = formatDate(now);
        }
    }
    return $.fn.datebox.defaults.formatter(new Date(ret));
}
/**
 * @author SongChao
 * @description 验证日期格式
 * @param date
 * @return {boolean}
 */
function checkDate(date) {
    var result = date.match(/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/);
    if (result == null)
        return false;
    var d = new Date(result[1], result[3] - 1, result[4]);
    return (d.getFullYear() == result[1] && (d.getMonth() + 1) == result[3] && d.getDate() == result[4]);
}
/**
 * @author SongChao
 * @description 获取服务器时间
 * @return {boolean}
 */
function getServerTime(timeFormat,systemFormat) {
	timeFormat=timeFormat?timeFormat:"2";
	systemFormat=systemFormat?systemFormat:"";
    var jsonData = $cm({
        ClassName: "Nur.CommonInterface.SystemConfig",
        MethodName: "getCurrentDateTime",
        timeFormat:timeFormat, 
        systemFormat:systemFormat
    }, false);
    return jsonData;
}

/**
 * @author SongChao
 * @description 验证用户名密码
 * @return {boolean}
 */
function passwordConfirm(userCode, passWord) {
    var jsonData = $cm({
        ClassName: "Nur.CommonInterface.UserInfo",
        MethodName: "passwordConfirm",
        userCode: userCode,
        passWord: passWord
    }, false);
    return jsonData;
}

/**
 * @author SongChao
 * @description 登记号补0
 * @return {boolean}
 */
function completeRegNo(regNo) {
    var regNoNum = $cm({
        ClassName: "Nur.CommonInterface.SystemConfig",
        MethodName: "getRegNoNum"
    }, false);
    if (regNo.length < regNoNum) {
        for (var i = (regNoNum - regNo.length - 1); i >= 0; i--) {
            regNo = "0" + regNo;
        }
    }
    return regNo;
}

