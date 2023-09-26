/// DHCBillGridList.js
function ListCommon2() {
    var urlAdd; //添加，修改记录对应的url
    var urlAjax; //删除和获取列表对应的url
    var tableid; //列表对应的table 的id
    var titleText = ""; //弹出框对应的标题
    var winid = "#win"; //弹出框对应的div的id
    var columns; //列表对应的列定义
    var toolbars; //自定义工具条对应的div的id
    var queryParams; //其他需要返回到服务端的查询参数
    var colkey; //
    var toolbarsType; //是否自定义工具条
    var WindowWidth = 600; //弹出框的宽度
    var WindowHeight = 400; //弹出框的高度
    var PageSize = 10; //每页显示多少条记录 只能为 [10, 20, 30, 40, 50,100,200]
    this.initList = function (aurlAdd, aurlAjax, atableid, atitleText, awinid, acolumns, atoolbarsType, aWindowWidth, aWindowHeight) {
        urlAdd = aurlAdd;
        urlAjax = aurlAjax;
        if (atableid) {
            tableid = atableid;
        }
        if (atitleText) {
            titleText = atitleText;
        }
        if (atitleText) {
            winid = awinid;
        }
        if (aWindowWidth) {
            WindowWidth = aWindowWidth;
        }
        if (aWindowHeight) {
            WindowHeight = aWindowHeight;
        }
        columns = acolumns;
        toolbarsType = atoolbarsType;
    };
    //每页显示多少条记录 只能为 [10, 20, 30, 40, 50,100,200]
    this.SetPageSize = function (aPageSize) {
        if (aPageSize) {
            PageSize = aPageSize;
        }
    }
    this.initData = function () {
        if (!toolbarsType) {
            toolbars = [{ text: '添加', iconCls: 'icon-add', handler: Add }, '-', { text: '编辑', iconCls: 'icon-edit', handler: this.Edit }
                         	, '-', { text: '删除', iconCls: 'icon-cancel', handler: this.delMsg }
                           ];
        } else {
            toolbars = toolbarsType;
        }
        ReadOperation();
        queryParams = this.GetqueryParams(); //     
        $(tableid).datagrid({//加载列表
            url: urlAjax + '?OperationType=list',
            columns: columns,
            toolbar: toolbars,
            idField: colkey,
            pagination: this.GetIsPage(),
            pageSize: PageSize,
            sortName: this.GetOrderField(),
            sortOrder: this.GetOrderType(),
            rownumbers: true, fitColumns: true,
            striped: true,
            method: "post",
            nowrap: this.GetIsTab(), //默认为true
            striped: true,
            queryParams: this.GetqueryParams(),
            showFooter: true
            , pageList: [10, 20, 30, 40, 50, 100, 200],
            rowStyler: this.GetrowStyler,
            onLoadSuccess: function (data) {
                if (data.total == 0) {
                    var body = $(this).data().datagrid.dc.body2;
                    body.find('table tbody').append('<tr><td width="' + body.width() + '" style="height: 25px; text-align: center;">没有数据</td></tr>');
                }
            }

        });

        $("#add").click(function (e) {//绑定添加按钮
            Add();
        })

        $("#edit").bind('click', { obj: this }, function (event) {//绑定修改按钮
            event.data.obj.Edit();

        })
        $("#del").bind('click', { obj: this }, function (event) {//绑定删除按钮
            event.data.obj.delMsg();
        })
        $("#btnQuery").bind('click', { obj: this }, function (event) {
            var queryParamsnew = event.data.obj.GetqueryParams(); //绑定查询按钮
            $(tableid).datagrid('load', queryParamsnew)
            $(tableid).datagrid('unselectAll');
        })
    }
    this.GetqueryParams = function () {//需要传递给后台的参数
        var NameList = this.Getcolsinfo();
        var otherQueryParams = this.GetOtherQueryParams();
        if (!otherQueryParams) {
            return { colkey: colkey, colsinfo: NameList }
        }
        else {
            return otherQueryParams;
        }
    }
    this.GetrowStyler = function () {
        return null;
    }
    this.GetOtherQueryParams = function () {//在需要其他需要的参数时需要重写 再有条件时需要重写，传递查询条件
        return null;
    }
    this.GetOrderField = function () {//默认的排序字段
        return colkey;
    }
    this.GetOrderType = function () {//默认的排序字方式，升序或者降序 'desc' 'asc'
        return 'desc';
    }
    this.GetIsPage = function () {
        return true;
    }
    this.GetIsTab = function () {//默认的是否换行，默认为true(不换行)
        return true;
    }
    this.Getcolsinfo = function () {//获取所有绑定列的字段名称
        var fieldNameList = [];
        if (columns.length > 0) {
            for (var i = 0; i < columns[0].length; i++) {
                fieldNameList.push(columns[0][i].field);
            }
        }
        else {
            alert("未绑定数据");
        }
        colkey = fieldNameList[fieldNameList.length - 1];
        var NameList = fieldNameList.join(",");
        return NameList
    }
    function Add() {
        var url = urlAdd;
        ShowdialogWindow("增加" + titleText, url);

    }
    this.Edit = function (editId) {
        var id;
        var obj = typeof (editId);
        var item;
        var url;
        if (!editId || obj == "object") {//工具条中修改
            var items = $(tableid).datagrid('getSelections');
            var length = items.length;
            if (length == 0) {
                $.messager.alert('提示', '请选择一条记录然后编辑');
                return;
            } else if (length > 1) {
                $.messager.alert('提示', '由于一次只能编辑一条记录，所以只能修改第一条记录');
                return;
            }
            item = items[0];
            url = urlAdd + '?' + GetEditUrl(item);
        }
        else {//列表行中的修改
            id = editId;
            if (arguments.length == 1) {//传递的是一个参数
                url = urlAdd + '?' + 'Id=' + id;
            } else {
                url = urlAdd + '?';
                for (var i = 0; i < arguments.length; i++) {//传递的是多个参数 查询字符串为id0=value0&id1=value1&id2=value2
                    if (i < arguments.length - 1) {
                        url = url + 'id' + i + "=" + arguments[i] + "&";
                    } else {
                        url = url + 'id' + i + "=" + arguments[i];
                    }
                }
            }
        }
        ShowdialogWindow("修改" + titleText, url);
    }

    function ShowdialogWindow(title, url) {//修改和添加的弹出框
        var _content = '<iframe id="FRMdetail"  frameborder="0"  src=' + url + ' style="width:100%;height:100%;" ></iframe>';
        $(winid).dialog({
            width: WindowWidth,
            height: WindowHeight,
            modal: true,
            content: _content,
            title: title,
            draggable: true,
            resizable: true,
            shadow: true,
            minimizable: false
        });
    }
    this.windowclose = function () {
        $(winid).window('close');
    }
    this.SaveOkCallback = function () {//保存成功后回调的函数
        this.windowclose();
        $(tableid).datagrid('reload');
        $(tableid).datagrid('unselectAll');
    }
    this.SaveOkCallback2 = function () {//保存成功后回调的函数
        //   this.windowclose();
        $(tableid).datagrid('reload');
        $(tableid).datagrid('unselectAll');
    }
    this.delMsg = function (delId) {
        var length = 1;
        var id;
        var items; var obj = typeof (delId);
        if (!delId || obj == "object") {
            items = $(tableid).datagrid('getSelections');
            length = items.length;
            if (length == 0) {
                $.messager.alert('提示', '请至少选择一条记录然后删除');
                return;
            }
        }
        else {
            id = delId;
        }
        var text = '你确认删除' + length + '条记录吗?';
        if (length == 1) {
            text = '你确认删除该条记录吗?';
        }
        $.messager.confirm('提示', text, function (r) {
            if (r) {
                if (!delId) {
                    var idList = [];
                    $.each(items,
                            function (key, value) {
                                var id = GetId(value); // in case we're changing the key
                                idList.push(id);
                            });
                    id = idList.join(",");
                }
                del(id)
            }
        });
    }

    function del(id) {//删除调用的ajax方法
        $.ajax({ type: "post",
            url: urlAjax + "?OperationType=del&id=" + id,
            success: function (msg) {
                var obj = jQuery.parseJSON(msg);
                if (obj.IsSuccess == true) {
                    $.messager.alert('提示', obj.Msg, 'info', selectcallback);

                }
                else {
                    $.messager.alert('提示', obj.Msg);
                }
            }
        });
    }

    function selectcallback() {////删除成功后回调的函数
        // obj.SaveOkCallback();
        $(winid).window('close');
        $(tableid).datagrid('reload');
        $(tableid).datagrid('unselectAll');
    }
    function ReadOperation() {//读取权限信息，返回没有的权限
        if (ShouldCheckOperationRight()) {
            if (OperationList == undefined) {
                $.ajax({ type: "post",
                    url: urlAjax + "?OperationType=OperationRight",
                    success: function (msg) {
                        var Operation = msg;
                        OperationList = Operation;
                        ManageOperation(Operation);
                    }
                });
            }
        }
    }

}

function GetColumnsinfos(columns) {
    var fieldNameList = [];
    if (columns.length > 0) {
        for (var i = 0; i < columns[0].length; i++) {
            fieldNameList.push(columns[0][i].field);
        }
    }
    else {
        alert("未绑定数据");
    }
    var NameList = fieldNameList.join(",");
    return NameList
}
function GetEditUrl(item) {//工具条上的修改需要调用此方法，在修改记录时，如果需要传递多个参数，请重写 查询字符串为id0=value0&id1=value1&id2=value2
    return 'Id=' + GetId(item);
}
function GetId(item) {//在删除时此方法返回删除时调用的主键编号，只有一个返回值，在修改时如果只传递一个参数也会调用此方法   
    alert('未定义方法GetId');
}
//时间转化
function Operationdate(value, rowData, rowIndex) {
    if (value == "") {
        return "";
    }
    var mydate = new Date(value);
    var monthstr = mydate.getMonth() + 1;
    if (monthstr < 10) {
        monthstr = "0" + monthstr;
    }
    var datestr = mydate.getDate();
    if (datestr < 10) {
        datestr = "0" + datestr;
    }
    return mydate.getFullYear() + "-" + monthstr + "-" + datestr;
}
//金额转化
function OperationMoney(value, rowData, rowIndex) {
    if (value == "") {
        return "￥0.00";
    }
    return formatCurrency(value);
}
function fomartOperation(value, rowData, rowIndex) {//生成行内的修改和删除按钮和事件
    var a = [];
    if (OperationList == undefined) {
        a.push("<a style='text-decoration:none;'  onclick=\"javascript:obj.Edit('", value, "')\"><span class='icon-edit'  title='编辑'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>&nbsp;&nbsp;&nbsp;&nbsp;");
        a.push("<a style='text-decoration:none;' onclick=\"javascript:obj.delMsg('", value, "')\"><span class='icon-cancel' title='删除'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>&nbsp;");
    } else {
        if (OperationList.indexOf("edit") < 0) {
            a.push("<a style='text-decoration:none;'  onclick=\"javascript:obj.Edit('", value, "')\"><span class='icon-edit'  title='编辑'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>&nbsp;&nbsp;&nbsp;&nbsp;");
        }
        if (OperationList.indexOf("del") < 0) {
            a.push("<a style='text-decoration:none;'  onclick=\"javascript:obj.delMsg('", value, "')\"><span class='icon-cancel' title='删除'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>&nbsp;");
        }
    }
    return a.join("");
}
function receiveMessage(e) {//html5定义的方法，在关闭修改和i添加的frame时，需要调用
    var data = e.data;
    if (data == "windowclose") {
        obj.windowclose();
    } else if (data == "SaveOkCallback") {
        obj.SaveOkCallback();
    } else if (data == "SaveOkCallback2") {
        obj.SaveOkCallback2();
    } else {
        alert("未定义方法");
    }
}
function SaveOkCallback() {////关闭iframe时，调用父窗体的方法
    var t = window.parent;
    if (!t.obj.windowclose) {
        t.postMessage("SaveOkCallback", '*'); //html5定义的方法
    } else {
        t.obj.SaveOkCallback();
    }
}
function windowclose() {//关闭iframe时，调用父窗体的方法
    var t = window.parent;
    if (!t.obj.windowclose) {
        t.postMessage("windowclose", '*'); //html5定义的方法
    } else {
        t.obj.windowclose();
    }
}
if (typeof window.addEventListener != 'undefined') {///html5定义的方法，在关闭修改和i添加的frame时，需要调用
    window.addEventListener('message', receiveMessage, false);
} else if (typeof window.attachEvent != 'undefined') {
    window.attachEvent('onmessage', receiveMessage);
}
function formatCurrency(num) {
    var sign = "";
    if (isNaN(num)) {
        num = 0;
    }
    if (num < 0) {
        sign = "-";
    }
    var strNum = num + "";
    var arr1 = strNum.split(".");
    var hasPoint = false; //是否有小数部分  
    var piontPart = ""; //小数部分  
    var intPart = strNum; //整数部分  
    if (arr1.length >= 2) {
        hasPoint = true;
        piontPart = arr1[1];
        intPart = arr1[0];
    }

    var res = ''; //保存添加逗号的部分  
    var intPartlength = intPart.length; //整数部分长度  
    var maxcount = Math.ceil(intPartlength / 3); //整数部分需要添加几个逗号  
    for (var i = 1; i <= maxcount; i++)//每三位添加一个逗号  
    {
        var startIndex = intPartlength - i * 3; //开始位置  
        if (startIndex < 0)//开始位置小于0时修正为0  
        {
            startIndex = 0;
        }
        var endIndex = intPartlength - i * 3 + 3; //结束位置  
        var part = intPart.substring(startIndex, endIndex) + ",";
        res = part + res;
    }
    res = res.substr(0, res.length - 1); //去掉最后一个逗号  
    if (hasPoint) {
        return "￥" + sign + res + "." + piontPart;
    }
    else {
        return "￥" + sign + res;
    }

}
$(document).ready(function () {
    $(":text").keydown(function (event) {
        if (event.which == 13) {
            $("#btnQuery").click();
        }
    });
});

var OperationList = undefined;
function ShouldCheckOperationRight() {//是否需要检测权限，默认不需要，也就是具有所有权限
    return false;
}
function ManageOperation() {    //根据权限隐藏没有权限的按钮
    if (OperationList.indexOf("edit") >= 0) {
        $("#edit").css("display", "none");
    }
    if (OperationList.indexOf("add") >= 0) {
        $("#add").css("display", "none");
    }
    if (OperationList.indexOf("del") >= 0) {
        $("#del").css("display", "none");
    }
}
//窗口id ，标题，请求页面，宽 ，高
function showwin(winid, title, url, mywidth, myheight) {//修改和添加的弹出框
    var _content = '<iframe id="FRMdetail"  frameborder="0"  src=' + url + ' style="width:100%;height:100%;" ></iframe>';
    $(winid).dialog({
        width: mywidth,
        height: myheight,
        modal: true,
        content: _content,
        title: title,
        draggable: true,
        resizable: true,
        shadow: true,
        minimizable: false
    });
}
function clearNoNum(obj) {
    //先把非数字的都替换掉，除了数字和.
    obj.value = obj.value.replace(/[^\d.]/g, "");
    //必须保证第一个为数字而不是.
    obj.value = obj.value.replace(/^\./g, "");
    //保证只有出现一个.而没有多个.
    obj.value = obj.value.replace(/\.{2,}/g, ".");
    //保证.只出现一次，而不能出现两次以上
    obj.value = obj.value.replace(".", "$#$").replace(/\./g, "").replace("$#$", ".");
}