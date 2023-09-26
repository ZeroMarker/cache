function refreshData() {
    queryData();
}

// 查询
function queryData() {
    $('#oeordData').datagrid('loading');
    $('#checkPnl').html('');

    var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'getOeordForGrd', episodeID, ssgroupID);
    ajaxGET(data, function (ret) {
        $('#oeordData').datagrid('loadData', $.parseJSON(ret).rows);
        $('#oeordData').datagrid('loaded');
    }, function (ret) {
        alert('getOeordForGrd error:' + ret);
    });
}

//设置数据
function setDataGrid() {
    $('#oeordData').datagrid({
        pageSize : 10,
        pageList : [10, 20, 30],
        loadMsg : '数据装载中......',
        autoRowHeight : true,
        rownumbers : true,
        pagination : false,
        //singleSelect : true,
        checkOnSelect : true,
        //selectOnCheck: true,
        fitColumns : true,
        fit : true,
        columns : [
            [{
                    field : 'ck',
                    checkbox : true
                }, {
                    field : 'oeord',
                    title : '医嘱内容',
                    halign : 'center',
                    width : 350
                }, {
                    field : 'oeordType',
                    title : '医嘱类型',
                    halign : 'center',
                    align : 'center',
                    width : 0,
                    hidden : true
                }
            ]
        ],
        view : groupview,
        groupField : 'oeordType',
        groupFormatter : function (value, rows) {
            var groupText = value + ' - ' + rows.length;
            if (isOPDisplayBtnByOeord == 'Y') {
                if (value != "其他") {
                    var htmlStr = '<a href="#" id="' + value + '" class="easyui-linkbutton l-btn" data-options="plain:true" onclick="insertData(this);return false;"><span class="l-btn-left"><span class="l-btn-text">' + value + '引用</span></span></a>&nbsp&nbsp';
                    $('#checkPnl').append(htmlStr);
                }
            }
            return groupText;
        },
        onLoadSuccess:function(){
            if (isOPDisplayBtnByOeord == 'Y') {
                if (document.getElementById('checkPnl').innerText != "") {
                    var htmlStr = '<a href="#" id="all" class="easyui-linkbutton l-btn" data-options="plain:true" onclick="insertData(this);return false;"><span class="l-btn-left"><span class="l-btn-text">全部引用</span></span></a>&nbsp&nbsp';
                    $('#checkPnl').prepend(htmlStr);
                    resize();
                }
            }
        }
    });

}

//引用按钮
function insertData(obj){
    var result = "";
    var separate = "\n";
    var space = "    ";//草药空格间隔
    var blank = "  ";//草药带序号时,换行的空格间隔
    var num = 0;
    var oeordType = $(obj).attr('id');
    var rows = $('#oeordData').datagrid('getRows');
    
    for (var idx = 0; idx < rows.length; idx++) {
        if (oeordType === "all"){
            if (rows[idx].oeordType != "其他") {
                if ((result != "")&&(rows.length-1 > idx)) result = result + separate;
                num = num + 1;
                if (rows[idx].oeordType === "草药") {
                    result = result + num + ".";
                    var str = rows[idx].oeord.split(",");
                    for (var j=0;j<str.length;j++) {
                        if (j === str.length-1) {
                            if (str[j].split(" ")[2] != "") {
                                result = result + str[j].split(" ")[0] + str[j].split(" ")[1] + separate + str[j].split(" ")[2];
                            }else {
                                result = result + str[j].split(" ")[0] + str[j].split(" ")[1];
                            }
                        }else {
                            result = result + str[j] + space;
                        }
                        if (!((j+1)%4) && (j!=str.length-1)) result = result.substring(0,result.length-space.length) + separate + blank;
                    }
                }else {
                    result = result + num + "." + rows[idx].oeord;
                }
            }
        }else if (rows[idx].oeordType === oeordType) {
            if ((result != "")&&(rows.length-1 > idx)) result = result + separate;
            num = num + 1;
            if (oeordType === "草药") {
                result = result + num + ".";
                var str = rows[idx].oeord.split(",");
                for (var j=0;j<str.length;j++) {
                    if (j === str.length-1) {
                        if (str[j].split(" ")[2] != "") {
                            result = result + str[j].split(" ")[0] + str[j].split(" ")[1] + separate + str[j].split(" ")[2];
                        }else {
                            result = result + str[j].split(" ")[0] + str[j].split(" ")[1];
                        }
                    }else {
                        result = result + str[j] + space;
                    }
                    if (!((j+1)%4) && (j!=str.length-1)) result = result.substring(0,result.length-space.length) + separate + blank;
                }
            }else {
                result = result + num + "." + rows[idx].oeord;
            }
        }
    }
    
    if (result != "") {
        var param = {
            "action" : "insertText",
            "text" : result
        };
        parent.eventDispatch(param);
    }
}

//设置引用按钮区域checkPnl的高度
function resize(){
    if (document.getElementById('checkPnl').innerText != "") {
        $('#checkPnl').panel('resize', {
            height: 30
        });
        $('body').layout('resize');
    }else {
        $('#checkPnl').panel('resize', {
            height: 0
        });
        $('body').layout('resize');
    }
}

//引用数据
function getData() {

    var result = "";
    separate = "\n";
    var space = "    ";//草药空格间隔
    var blank = "  ";//带序号,换行空格间隔(关联医嘱、草药每四个换行后的空格)
    var checkedItems = $('#oeordData').datagrid('getChecked');
    $.each(checkedItems, function (index, item) {
        var num = index + 1;
        if (item.oeordType === "草药") {
            var str = item.oeord.split(",");
            result = result + num + ".";
            for (var j=0;j<str.length;j++) {
                if (j === str.length-1) {
                    if (str[j].split(" ")[2] != "") {
                        result = result + str[j].split(" ")[0] + str[j].split(" ")[1] + separate + str[j].split(" ")[2];
                    }else {
                        result = result + str[j].split(" ")[0] + str[j].split(" ")[1] ;
                    }
                }else {
                    result = result + str[j] + space;
                }
                if (!((j+1)%4) && (j!=str.length-1)) result = result.substring(0,result.length-space.length) + separate + "  ";
            }
        }else {
            result = result + num + "." + item.oeord;
        }
        if (checkedItems.length-1 > index) result = result + separate;
    });

    var param = {
        "action" : "insertText",
        "text" : result
    };
    parent.eventDispatch(param);
    UnCheckAll();
}

//去掉选择
function UnCheckAll() {
    $("#oeordData").datagrid("uncheckAll");
}

function ReLoadLabInfo() {
    refreshData();
}

$(function () {
    setDataGrid();
    queryData();
    parent.HisTools.refreshOeOrdGrd = function () {
        refreshData();
    };
});
