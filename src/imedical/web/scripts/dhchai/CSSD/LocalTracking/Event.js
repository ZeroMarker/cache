//查询消毒科室病人信息 
//页面Event
function InitAssRateWinEvent(obj) {	
    obj.LoadEvent = function (args) {
        //打印
        obj.btnPrint = function () {
            $('#AssessRate').datagrid('print', '科室消毒人员信息');
        }
        //导出
        obj.btnexport = function () {
            $('#AssessRate').datagrid('toExcel', '科室消毒人员信息.xls');
        }
        obj.gridAssRate.load({
            ClassName: 'DHCHAI.DI.DHS.SyncCSSDInfo',
            QueryName: 'LocInfoTracking',
            iLocInfo: LocInfo,
            iDateFrom: DateFrom,
            iDateTo: DateTo,
            iBatNumS: BatNumS
        });
    }  
}	