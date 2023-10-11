var now = new Date(); // ��ǰ����
var nowDayOfWeek = now.getDay(); // ���챾�ܵĵڼ���
var nowDay = now.getDate(); // ��ǰ��
var nowMonth = now.getMonth(); // ��ǰ��
var nowYear = now.getYear(); // ��ǰ��
nowYear += (nowYear < 2000) ? 1900 : 0;

// ��ȡ��ǰ����
function getNowDate() {
    var date = new Date();
    var year = date.getFullYear();
    var month = date.getMonth() + 1;
    var day = date.getDate();
    return year + "-" + month + "-" + day;
}
// ��ȡ��ǰ����ǰX��
function getBeforeDate(daynum) {
    var now = new Date();
    var before = new Date(now.getTime() - daynum * 24 * 60 * 60 * 1000);
    var year = before.getFullYear();
    var month = before.getMonth() + 1;
    var date = before.getDate();
    return year + "-" + month + "-" + date;
}
// ��ȡ��ǰ���ں�X��
function getAfterDate(daynum) {
    var now = new Date();
    var before = new Date(now.getTime() + daynum * 24 * 60 * 60 * 1000);
    var year = before.getFullYear();
    var month = before.getMonth() + 1;
    var date = before.getDate();
    return year + "-" + month + "-" + date;
}
// ��ȡ���µ�һ��
function getFirstDayOfMonth() {
    var date = new Date();
    var year = date.getFullYear();
    var month = date.getMonth() + 1;
    return year + "-" + month + "-01";
}
// ��ȡ�������һ��
function getLastDayOfMonth() {
    var date = new Date();
    var year = date.getFullYear();
    var month = date.getMonth() + 1;
    var day = new Date(year, month, 0);
    return year + "-" + month + "-" + day.getDate();
}

var DateUtil = {
     /**
      * ��õ�ǰ����
      * 
      * @returns
      */
     getNowDay : function() {
         return this.formatDate(new Date());
     },
     /**
      * ��ñ��ܵĿ�ʼʱ��
      * 
      * @returns
      */
     getStartDayOfWeek : function() { //��ȡ����ǰ���� ,��  ,��ǰ��+1-��ǰ��Ϊ���ܵĵڼ��� ʱ���ʽ���� ���ɻ�ȡ����һ�� ʱ��
         var day = nowDayOfWeek || 7;
         return this.formatDate(new Date(now.getFullYear(), nowMonth, nowDay + 1 - day));
     },
     /**
      * ��ñ��ܵĽ���ʱ��
      * 
      * @returns
      */
     getEndDayOfWeek : function() { //��ȡ����ǰ���� ,��  ,��ǰ��+7-��ǰ��Ϊ���ܵĵڼ��� ʱ���ʽ���� ���ɻ�ȡ�����յ� ʱ��
         var day = nowDayOfWeek || 7;
         return this.formatDate(new Date(now.getFullYear(), nowMonth, nowDay + 7 - day));
     },
     /**
      * ��ñ��µĿ�ʼʱ��
      * 
      * @returns
      */
     getStartDayOfMonth : function() {// ��ȡ�� ��ǰ ��,�� ,��=1 ʱ���ʽ���� ����
         var monthStartDate = new Date(nowYear, nowMonth, 1);
         return this.formatDate(monthStartDate);
     },
     /**
      * ��ñ��µĽ���ʱ��
      * 
      * @returns
      */
     getEndDayOfMonth : function() {  //��ȡ ��ǰ ��,��,�������� ʱ���ʽ���� ����
         var monthEndDate = new Date(nowYear, nowMonth, this.getMonthDays());
         return this.formatDate(monthEndDate);
     },
     /**
      * ��ñ�������
      * 
      * @returns
      */
     getMonthDays : function() {  //��ȡ�������� �ú�һ�µĸ�ʽ��ʱ���ȥ��ǰ�µĸ�ʽ��ʱ�� ����1��ĺ����� ����
         var monthStartDate = new Date(nowYear, nowMonth, 1);
         var monthEndDate = new Date(nowYear, nowMonth + 1, 1);
         var days = (monthEndDate - monthStartDate) / (1000 * 60 * 60 * 24);
         return days;
     },
      /**
      * ��ñ����ȿ�ʼ
      * 
      * @returns
      */
     getQuarterStart :function(){ //�жϵ��µ��·ݴ����ĸ����ȵķ�Χ ��ֵ������   ����Ϊ1 ʱ���ʽ������
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
      * ��ñ����Ƚ���
      * 
      * @returns
      */
      getQuarterEnd :function(){  //ͬ�� ������Ҫ��ȡ���Ƚ����µĺ�һ�¼�ȥһ���ʱ�� ���ܻ�ȡ �����ȵĸ�ʽ��ʱ����
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
      * @param ���ڸ�ʽ��
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