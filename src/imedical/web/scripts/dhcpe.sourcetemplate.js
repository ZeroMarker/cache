/**
 * Description: 号源模板管理
 * FileName: dhcpe.sourcetemplate.js
 * Creator: wangguoying
 * Date: 2022-10-10
 */
var _GV = {
    className: "web.DHCPE.SourceManager",
    weekDescArr: ["日", "一", "二", "三", "四", "五", "六"]
}

function init() {
    init_content();
    init_event();
}

function init_event() {
    $("#BCreate").click(function (e) {
        create();
    });
}

/**
* [获取创建模式]
* @Author wangguoying
* @Date 2022-08-25
*/
function getMode() {
    return $("input[name='CreateMode']:checked").val();
}


/**
* [获取表头列信息]  
* @Author wangguoying
* @Date 2022-10-10
*/
function getColumns() {
    var th1 = [{ field: "TCategory", width: 100, title: "类别", rowspan: 2, align: "center" },
    { field: "TType", width: 100, title: "类型", rowspan: 2, align: "center" },
    { width: 160, title: "周一", colspan: 2 },
    { width: 160, title: "周二", colspan: 2 },
    { width: 160, title: "周三", colspan: 2 },
    { width: 160, title: "周四", colspan: 2 },
    { width: 160, title: "周五", colspan: 2 },
    { width: 160, title: "周六", colspan: 2 },
    { width: 160, title: "周日", colspan: 2 }
    ],
        th2 = [
            { field: "NUM_I_1", width: 80, title: "内部", align: "center" },
            { field: "NUM_O_1", width: 80, title: "外部", align: "center" },
            { field: "NUM_I_2", width: 80, title: "内部", align: "center" },
            { field: "NUM_O_2", width: 80, title: "外部", align: "center" },
            { field: "NUM_I_3", width: 80, title: "内部", align: "center" },
            { field: "NUM_O_3", width: 80, title: "外部", align: "center" },
            { field: "NUM_I_4", width: 80, title: "内部", align: "center" },
            { field: "NUM_O_4", width: 80, title: "外部", align: "center" },
            { field: "NUM_I_5", width: 80, title: "内部", align: "center" },
            { field: "NUM_O_5", width: 80, title: "外部", align: "center" },
            { field: "NUM_I_6", width: 80, title: "内部", align: "center" },
            { field: "NUM_O_6", width: 80, title: "外部", align: "center" },
            { field: "NUM_I_0", width: 80, title: "内部", align: "center" },
            { field: "NUM_O_0", width: 80, title: "外部", align: "center" }
        ];
    return [th1, th2];
}


function init_content() {
    $HUI.datagrid("#template-list", {
        url: $URL,
        queryParams: {
            ClassName: _GV.className,
            QueryName: "QueryPreTemplate",
            LocID: session["LOGON.CTLOCID"]
        },
        columns: getColumns(),
        onClickCell: function (index, field, value) {
            if (field.indexOf("NUM") >= 0) {
                set_time(field);
            }
        },
        onLoadSuccess: function (data) {
            var mark = 1;
            for (var i = 1; i < data.rows.length; i++) {
                if (data.rows[i]['TCategory'] == data.rows[i - 1]['TCategory']) {
                    mark += 1;
                    $(this).datagrid('mergeCells', {
                        index: i + 1 - mark,
                        field: 'TCategory',
                        rowspan: mark
                    });
                } else {
                    mark = 1;
                }
            }
        },
        fit: true,
        border: false,
        fitColumns: true,
        pagination: true,
        pageSize: 20,
        pageList: [20, 100, 200],
        singleSelect: true
    });
}

/**
 * [根据模板创建排班] 
 * @Author wangguoying
 * @Date 2022-03-25
 */
function create() {
    var startDate = $("#StartDate").datebox("getValue");
    var endDate = $("#EndDate").datebox("getValue");
    if (startDate == "" || endDate == "") {
        $.messager.popover({
            msg: "开始时间和创建时间不能为空！",
            type: "error"
        });
        return false;
    }

    var pm = new Promise((resolve, reject) => {
        var existDate = tkMakeServerCall(_GV.className, "GetExistPrecordDate", session["LOGON.CTLOCID"], startDate, endDate);
        if (existDate == "") {
            resolve();
        } else {
            $.messager.confirm("提示", "【" + existDate + "】存在预约记录，本次创建将会跳过这些日期，是否继续？", function (r) {
                if (r) {
                    resolve();
                }
            });
        }
    });
    pm.then(() => {
        var mode = getMode();
        var ret = tkMakeServerCall(_GV.className, "CreateByTemplate", startDate, endDate, mode, session["LOGON.CTLOCID"], session["LOGON.USERID"]);
        if (parseInt(ret) < 0) {
            $.messager.popover({ msg: ret.split("^")[1], type: "error" });
            return false;
        } else {
            $.messager.popover({ msg: "创建成功", type: "success" });
        }
    });
}


/**
 * [设置时段模板]
 * @param    {[String]}    field    [列名称]
 * @return   {[object]}    
 * @Author wangguoying
 * @Date 2022-03-23
 */
function set_time(field) {
    var cls = field.split("_")[1],
        clsName = cls == "I" ? "内部号源" : "外部号源";
    var weekNum = field.split("_")[2];
    var lnk = "dhcpe.sourcetemplate.time.csp?LocID=" + session["LOGON.CTLOCID"] + "&WeekNum=" + weekNum + "&Class=" + cls;
    parent.$('#TemplateTimeDialog').dialog({
        title: '时段模板： ' + '【周' + _GV.weekDescArr[weekNum] + '】 ' + clsName,
        iconCls: "icon-w-clock",
        closable: false,
        width: 1200,
        height: 580,
        cache: false,
        content: "<iframe src='" + PEURLAddToken(lnk) + "' style='width:100%;height:100%;border:0'></iframe> ",
        modal: true,
        buttons: [{
            text: '确定',
            iconCls: 'icon-w-ok',
            handler: function () {
                $("#template-list").datagrid("reload");
                parent.$HUI.dialog('#TemplateTimeDialog').close();
            }
        }, {
            text: '关闭',
            iconCls: 'icon-w-cancel',
            handler: function () { $("#template-list").datagrid("reload"); parent.$HUI.dialog('#TemplateTimeDialog').close(); }
        }]
    });

}



$(init);