/**
 * ҩ��ͳ�� - ͨ��
 * @creator pushuangcai
 */
var STAT_COM = {
    QueryRep: function (title, reportName, params) {
        STAT_COM.Report.Query(title, reportName, params);
    },
    ClearRep: function () {
        STAT_COM.Report.Clear();
    },
    Report: {
        CSP: 'dhccpmrunqianreport.csp',
        $RepTabs: (function(){
            return $('#pha-stat-reptab'); 
        }()),
        Suffix: '.rpx',
        /**
         * ���ر���
         * @param {string} title ��������
         * @param {string} reportName ������
         * @param {object} params ����
         */
        Query: function (title, reportName, params) {
            if (params == null) {
                return;
            }
            if ((params.InputStr === "null") || (params.InputStr === null)){
                return;
            }
            STAT_COM.Report._AddRepTab(title, reportName);
            STAT_COM.Report._Load(reportName, params);
        },
        /**
         * ����Ѵ򿪱���
         */
        Clear: function(){
            var allTabs = STAT_COM.Report.$RepTabs.tabs('tabs');
            while (allTabs.length > 1){
                STAT_COM.Report.$RepTabs.tabs('close', 1);
            }
        },
        MWToken: (function(){
            if ('undefined' !== typeof websys_getMWToken){
                return websys_getMWToken();
            }
            return '';
        }()),
        _reportFile: function(reportName){
            return reportName + STAT_COM.Report.Suffix;
        },
        _Url: function (reportName, params) {
            var url = STAT_COM.Report.CSP;
            url += '?reportName=' + STAT_COM.Report._reportFile(reportName);
    
            url += '&MWToken=' + STAT_COM.Report.MWToken;
            if (typeof params.InputStr === "string"){
                params.InputStr = JSON.parse(params.InputStr);
            }
            /* �������Ʋ��̶����е�ͷ�ۣ�������������ķ���һ�£��������ݵĴ���һ�¾ͺð��� */
            params.InputStr.statistic = reportName;
            params.InputStr.parType = reportName;
            params.InputStr.hospId = session['LOGON.HOSPID'];

            url += STAT_COM.Report._FormatParam(params);

            url += '&HOSPID=' + session['LOGON.HOSPID'];
            url += '&HospDesc=' + session['LOGON.HOSPDESC'];
            url += '&UserName=' + session['LOGON.USERNAME'];
            url += '&StartDate=' + params.InputStr.startDate || "";
            url += '&EndDate=' + params.InputStr.endDate || "";
            return url;
        },
        _FormatParam: function(params){
            if (typeof params !== 'object'){
                return params;
            }
            var paramsStr = "";
            for (var key in params){
                var value = params[key];
                if (typeof value === 'object'){
                    value = JSON.stringify(value);
                }
                paramsStr += '&' + key + '=' + value;
            }
            return paramsStr;
        },
        _Load: function(reportName, params){
            var reportUrl = STAT_COM.Report._Url(reportName, params);
            $('#iframe-' + reportName).attr("src", reportUrl);
        },
        _AddRepTab :function (title, reportName) {
            if (!STAT_COM.Report.$RepTabs.tabs('exists', title)) {
                STAT_COM.Report.$RepTabs.tabs('add', {
                    title: title,
                    content: "<iframe id='iframe-" + reportName + "' style='display:block;width:99.6%;height:99%' src=''/>",
                    closable: true
                });
            }
            STAT_COM.Report.$RepTabs.tabs('select', title);
        }
    }
}