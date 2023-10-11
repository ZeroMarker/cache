var now = new Date(); // 当前日期
var nowDayOfWeek = now.getDay(); // 今天本周的第几天
var nowDay = now.getDate(); // 当前日
var nowMonth = now.getMonth(); // 当前月
var nowYear = now.getYear(); // 当前年
nowYear += (nowYear < 2000) ? 1900 : 0;

// 获取当前日期
function getNowDate() {
    var date = new Date();
    var year = date.getFullYear();
    var month = date.getMonth() + 1;
    var day = date.getDate();
    return year + "-" + month + "-" + day;
}
// 获取当前日期前X天
function getBeforeDate(daynum) {
    var now = new Date();
    var before = new Date(now.getTime() - daynum * 24 * 60 * 60 * 1000);
    var year = before.getFullYear();
    var month = before.getMonth() + 1;
    var date = before.getDate();
    return year + "-" + month + "-" + date;
}
// 获取当前日期后X天
function getAfterDate(daynum) {
    var now = new Date();
    var before = new Date(now.getTime() + daynum * 24 * 60 * 60 * 1000);
    var year = before.getFullYear();
    var month = before.getMonth() + 1;
    var date = before.getDate();
    return year + "-" + month + "-" + date;
}
// 获取当月第一天
function getFirstDayOfMonth() {
    var date = new Date();
    var year = date.getFullYear();
    var month = date.getMonth() + 1;
    return year + "-" + month + "-01";
}
// 获取当月最后一天
function getLastDayOfMonth() {
    var date = new Date();
    var year = date.getFullYear();
    var month = date.getMonth() + 1;
    var day = new Date(year, month, 0);
    return year + "-" + month + "-" + day.getDate();
}

var DateUtil = {
     /**
      * 获得当前日期
      * 
      * @returns
      */
     getNowDay : function() {
         return this.formatDate(new Date());
     },
     /**
      * 获得本周的开始时间
      * 
      * @returns
      */
     getStartDayOfWeek : function() { //获取到当前的年 ,月  ,当前日+1-当前日为本周的第几天 时间格式化后 即可获取星期一的 时间
         var day = nowDayOfWeek || 7;
         return this.formatDate(new Date(now.getFullYear(), nowMonth, nowDay + 1 - day));
     },
     /**
      * 获得本周的结束时间
      * 
      * @returns
      */
     getEndDayOfWeek : function() { //获取到当前的年 ,月  ,当前日+7-当前日为本周的第几天 时间格式化后 即可获取星期日的 时间
         var day = nowDayOfWeek || 7;
         return this.formatDate(new Date(now.getFullYear(), nowMonth, nowDay + 7 - day));
     },
     /**
      * 获得本月的开始时间
      * 
      * @returns
      */
     getStartDayOfMonth : function() {// 获取到 当前 年,月 ,日=1 时间格式化后 即可
         var monthStartDate = new Date(nowYear, nowMonth, 1);
         return this.formatDate(monthStartDate);
     },
     /**
      * 获得本月的结束时间
      * 
      * @returns
      */
     getEndDayOfMonth : function() {  //获取 当前 年,月,本月天数 时间格式化后 即可
         var monthEndDate = new Date(nowYear, nowMonth, this.getMonthDays());
         return this.formatDate(monthEndDate);
     },
     /**
      * 获得本月天数
      * 
      * @returns
      */
     getMonthDays : function() {  //获取本月天数 用后一月的格式化时间减去当前月的格式化时间 除以1天的毫秒数 即可
         var monthStartDate = new Date(nowYear, nowMonth, 1);
         var monthEndDate = new Date(nowYear, nowMonth + 1, 1);
         var days = (monthEndDate - monthStartDate) / (1000 * 60 * 60 * 24);
         return days;
     },
      /**
      * 获得本季度开始
      * 
      * @returns
      */
     getQuarterStart :function(){ //判断当月的月份处于哪个季度的范围 赋值给变量   日期为1 时间格式化即可
         var m = 0;
         if(nowMonth<3){//012
             m = 0
         }else if(2<nowMonth && nowMonth<6){//345
             m =3
         }else if(5<nowMonth && nowMonth<8){//678
             m = 6
         }else if(nowMonth>8){ //9 10 11
             m = 9
         }
         var quarterStart = new Date(nowYear,m,1)
         return this.formatDate(quarterStart)
 
     },
      /**
      * 获得本季度结束
      * 
      * @returns
      */
      getQuarterEnd :function(){  //同上 但是需要获取季度结束月的后一月减去一天的时间 就能获取 本季度的格式化时间了
         var m = 0;
         if(nowMonth<3){//012
             m = 3
         }else if(2<nowMonth && nowMonth<6){//345
             m =6
         }else if(5<nowMonth && nowMonth<8){//678
             m = 9
         }else if(nowMonth>8){ //9 10 11
             m = 0
         }
         var quarterEnd = new Date(nowYear,m,1).getTime()-(60*60*24*1000)
         return this.formatDate(new Date(quarterEnd))
 
     },
     /**
      * @param 日期格式化
      * @returns {String}
      */
     formatDate : function(date) {
         var myyear = date.getFullYear();
         var mymonth = date.getMonth() + 1;
         var myweekday = date.getDate();
  
         if (mymonth < 10) {
             mymonth = "0" + mymonth;
         }
         if (myweekday < 10) {
             myweekday = "0" + myweekday;
         }
         return (myyear + "-" + mymonth + "-" + myweekday);
     }
 };