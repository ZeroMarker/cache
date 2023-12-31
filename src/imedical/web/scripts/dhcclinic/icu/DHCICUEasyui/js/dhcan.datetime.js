// 说明：JS时间Date格式化参数
// 参数：格式化字符串如：'yyyy-MM-dd HH:mm:ss'
// 结果：如2016-06-01 10:09:00
Date.prototype.format = function(fmt) { //author: meizz 
    var o = {
        "M+": this.getMonth() + 1,
        "d+": this.getDate(),
        "H+": this.getHours(),
        "m+": this.getMinutes(),
        "s+": this.getSeconds(),
        "q+": Math.floor((this.getMonth() + 3) / 3),
        "S": this.getMilliseconds()
    };
    var year = this.getFullYear();
    var yearstr = year + '';
    yearstr = yearstr.length >= 4 ? yearstr : '0000'.substr(0, 4 - yearstr.length) + yearstr;

    if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (yearstr + "").substr(4 - RegExp.$1.length));
    for (var k in o)
        if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
};

Date.prototype.add = function(milliseconds) {
    var m = this.getTime() + milliseconds;
    return new Date(m);
};
Date.prototype.addSeconds = function(second) {
    return this.add(second * 1000);
};
Date.prototype.addMinutes = function(minute) {
    return this.addSeconds(minute * 60);
};
Date.prototype.addHours = function(hour) {
    return this.addMinutes(60 * hour);
};

Date.prototype.addDays = function(day) {
    return this.addHours(day * 24);
};

Date.prototype.compareto = function(source, target) {
    var sourceTime = source.getTime(),
        targetTime = source.getTime();
    if (sourceTime > targetTime) {
        return 1;
    } else if (sourceTime === targetTime) {
        return 0;
    } else {
        return -1;
    }
}

Date.isValidDate = function(dateInstance) {
    var result = false;
    if (dateInstance instanceof Date) {
        if (isNaN(dateInstance.getTime())) {
            result = false;
        } else {
            result = true;
        }
    }
    return result;
}

Date.prototype.isValidDate = function() {
    var result = false;
    if (this instanceof Date) {
        if (isNaN(this.getTime())) {
            result = false;
        } else {
            result = true;
        }
    }
    return result;
}

/**
 * 尝试解析为日期对象
 * @param {string} s 
 */
Date.prototype.tryParse = function(s, format) {
    try {
        if (!(format && typeof format === 'string')) format = 'yyyy-MM-dd HH:mm:ss';
        var o = {
            'y+': this.setFullYear,
            'M+': this.setMonth,
            'd+': this.setDate,
            'H+': this.setHours,
            'm+': this.setMinutes,
            's+': this.setSeconds
        }

        var numRegExp = new RegExp('\\d+');

        var sortedO = {};

        if ($.trim(s)) {
            for (var pattern in o) {
                var exec = new RegExp(pattern).exec(format);
                if (exec) {
                    sortedO[exec.index] = {
                        pattern: pattern,
                        index: exec.index,
                        length: exec[0].length
                    }
                } else {
                    o[pattern].call(this, 0);
                }
            }
            var latestO = null,
                latestExecIndex = 0;
            var interval = 0;
            for (var index in sortedO) {
                var currentO = sortedO[index];
                if (latestO) {
                    interval = currentO.index - latestO.index - latestO.length;
                }

                var fragment = s.slice(latestExecIndex + interval, latestExecIndex + interval + currentO.length);
                var exec = numRegExp.exec(fragment);
                var value = 0;

                if (exec) {
                    value = Number(fragment.slice(exec.index, exec.index + exec[0].length));
                    if (currentO.pattern == 'M+') value = value - 1;
                    o[currentO.pattern].call(this, value);
					o[currentO.pattern].call(this, value);
                    latestExecIndex = latestExecIndex + interval + exec.index + exec[0].length;
                } else {
                    //throw 'not match!';
                }

                latestO = currentO;
            }
        }



    } catch (e) {
        var d = Date.parse(s);
        if (!isNaN(d)) {
            return new Date(d);
        } else {
            return new Date();
        }
    } finally {
        return this;
    }
}

/**
 * 时间差类型
 * @param {Date} minDT - 被减的时间
 * @param {Date} subDT - 减去的时间
 */
function TimeSpan(minDT, subDT) {
    this.minDT = minDT;
    this.subDT = subDT;
    this.totalMilliSeconds = (this.minDT.getTime() - this.subDT.getTime());
    this.totalSeconds = this.totalMilliSeconds / 1000;
    this.totalMinutes = this.totalSeconds / 60;
    this.totalHours = this.totalMinutes / 60;
    this.totalDays = this.totalHours / 24;

    this.day = Math.floor(this.totalDays);
    this.hour = Math.floor(this.totalHours) % 24;
    this.minute = Math.floor(this.totalMinutes) % 60;
    this.second = Math.floor(this.totalSeconds) % 60;
}