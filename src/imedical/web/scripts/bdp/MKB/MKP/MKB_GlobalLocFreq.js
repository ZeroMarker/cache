/*
 * @Author: 基础数据平台-范文凯
 * @Date:   2020-03-15
 * @Last Modified by:   admin
 * @Last Modified time: 2020-03-15
 * @描述:全局化词表标记
 */
var init = function() {
    var LocFreqcolumns = [
        [{
            field: 'MKBGLFRowId',
            title: 'RowId',
            hidden: true,
            width: 100
        }, {
            field: 'LocName',
            title: '科室名称',
            width: 100
        }, {
            field: 'LocFreq',
            title: '开立频次',
            width: 100
        }]
    ];
    var LocFreqlist = $HUI.datagrid("#locfreqgrid", {
        url: $URL, //QUERY_ACTION_URL
        queryParams: {
            ClassName: "web.DHCBL.MKB.MKBGlobal",
            QueryName: "GetLocFreq",
            'GlobalID': GlobalID
        },
        columns: LocFreqcolumns, //列信息
        pagination: true,
        pageSize: 50,
        idField: 'MKBGLFRowId',
        rownumbers: false, //设置为 true，则显示带有行号的列。
        fixRowNumber: true,
        fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        //toolbar: '#aliasTools',
        scrollbarSize: 0,
        remoteSort: false
    });
}
$(init);