/// DHCBillGridList.js
function ListCommon2() {
    var urlAdd; //��ӣ��޸ļ�¼��Ӧ��url
    var urlAjax; //ɾ���ͻ�ȡ�б��Ӧ��url
    var tableid; //�б��Ӧ��table ��id
    var titleText = ""; //�������Ӧ�ı���
    var winid = "#win"; //�������Ӧ��div��id
    var columns; //�б��Ӧ���ж���
    var toolbars; //�Զ��幤������Ӧ��div��id
    var queryParams; //������Ҫ���ص�����˵Ĳ�ѯ����
    var colkey; //
    var toolbarsType; //�Ƿ��Զ��幤����
    var WindowWidth = 600; //������Ŀ��
    var WindowHeight = 400; //������ĸ߶�
    var PageSize = 10; //ÿҳ��ʾ��������¼ ֻ��Ϊ [10, 20, 30, 40, 50,100,200]
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
    //ÿҳ��ʾ��������¼ ֻ��Ϊ [10, 20, 30, 40, 50,100,200]
    this.SetPageSize = function (aPageSize) {
        if (aPageSize) {
            PageSize = aPageSize;
        }
    }
    this.initData = function () {
        if (!toolbarsType) {
            toolbars = [{ text: '���', iconCls: 'icon-add', handler: Add }, '-', { text: '�༭', iconCls: 'icon-edit', handler: this.Edit }
                         	, '-', { text: 'ɾ��', iconCls: 'icon-cancel', handler: this.delMsg }
                           ];
        } else {
            toolbars = toolbarsType;
        }
        ReadOperation();
        queryParams = this.GetqueryParams(); //     
        $(tableid).datagrid({//�����б�
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
            nowrap: this.GetIsTab(), //Ĭ��Ϊtrue
            striped: true,
            queryParams: this.GetqueryParams(),
            showFooter: true
            , pageList: [10, 20, 30, 40, 50, 100, 200],
            rowStyler: this.GetrowStyler,
            onLoadSuccess: function (data) {
                if (data.total == 0) {
                    var body = $(this).data().datagrid.dc.body2;
                    body.find('table tbody').append('<tr><td width="' + body.width() + '" style="height: 25px; text-align: center;">û������</td></tr>');
                }
            }

        });

        $("#add").click(function (e) {//����Ӱ�ť
            Add();
        })

        $("#edit").bind('click', { obj: this }, function (event) {//���޸İ�ť
            event.data.obj.Edit();

        })
        $("#del").bind('click', { obj: this }, function (event) {//��ɾ����ť
            event.data.obj.delMsg();
        })
        $("#btnQuery").bind('click', { obj: this }, function (event) {
            var queryParamsnew = event.data.obj.GetqueryParams(); //�󶨲�ѯ��ť
            $(tableid).datagrid('load', queryParamsnew)
            $(tableid).datagrid('unselectAll');
        })
    }
    this.GetqueryParams = function () {//��Ҫ���ݸ���̨�Ĳ���
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
    this.GetOtherQueryParams = function () {//����Ҫ������Ҫ�Ĳ���ʱ��Ҫ��д ��������ʱ��Ҫ��д�����ݲ�ѯ����
        return null;
    }
    this.GetOrderField = function () {//Ĭ�ϵ������ֶ�
        return colkey;
    }
    this.GetOrderType = function () {//Ĭ�ϵ������ַ�ʽ��������߽��� 'desc' 'asc'
        return 'desc';
    }
    this.GetIsPage = function () {
        return true;
    }
    this.GetIsTab = function () {//Ĭ�ϵ��Ƿ��У�Ĭ��Ϊtrue(������)
        return true;
    }
    this.Getcolsinfo = function () {//��ȡ���а��е��ֶ�����
        var fieldNameList = [];
        if (columns.length > 0) {
            for (var i = 0; i < columns[0].length; i++) {
                fieldNameList.push(columns[0][i].field);
            }
        }
        else {
            alert("δ������");
        }
        colkey = fieldNameList[fieldNameList.length - 1];
        var NameList = fieldNameList.join(",");
        return NameList
    }
    function Add() {
        var url = urlAdd;
        ShowdialogWindow("����" + titleText, url);

    }
    this.Edit = function (editId) {
        var id;
        var obj = typeof (editId);
        var item;
        var url;
        if (!editId || obj == "object") {//���������޸�
            var items = $(tableid).datagrid('getSelections');
            var length = items.length;
            if (length == 0) {
                $.messager.alert('��ʾ', '��ѡ��һ����¼Ȼ��༭');
                return;
            } else if (length > 1) {
                $.messager.alert('��ʾ', '����һ��ֻ�ܱ༭һ����¼������ֻ���޸ĵ�һ����¼');
                return;
            }
            item = items[0];
            url = urlAdd + '?' + GetEditUrl(item);
        }
        else {//�б����е��޸�
            id = editId;
            if (arguments.length == 1) {//���ݵ���һ������
                url = urlAdd + '?' + 'Id=' + id;
            } else {
                url = urlAdd + '?';
                for (var i = 0; i < arguments.length; i++) {//���ݵ��Ƕ������ ��ѯ�ַ���Ϊid0=value0&id1=value1&id2=value2
                    if (i < arguments.length - 1) {
                        url = url + 'id' + i + "=" + arguments[i] + "&";
                    } else {
                        url = url + 'id' + i + "=" + arguments[i];
                    }
                }
            }
        }
        ShowdialogWindow("�޸�" + titleText, url);
    }

    function ShowdialogWindow(title, url) {//�޸ĺ���ӵĵ�����
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
    this.SaveOkCallback = function () {//����ɹ���ص��ĺ���
        this.windowclose();
        $(tableid).datagrid('reload');
        $(tableid).datagrid('unselectAll');
    }
    this.SaveOkCallback2 = function () {//����ɹ���ص��ĺ���
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
                $.messager.alert('��ʾ', '������ѡ��һ����¼Ȼ��ɾ��');
                return;
            }
        }
        else {
            id = delId;
        }
        var text = '��ȷ��ɾ��' + length + '����¼��?';
        if (length == 1) {
            text = '��ȷ��ɾ��������¼��?';
        }
        $.messager.confirm('��ʾ', text, function (r) {
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

    function del(id) {//ɾ�����õ�ajax����
        $.ajax({ type: "post",
            url: urlAjax + "?OperationType=del&id=" + id,
            success: function (msg) {
                var obj = jQuery.parseJSON(msg);
                if (obj.IsSuccess == true) {
                    $.messager.alert('��ʾ', obj.Msg, 'info', selectcallback);

                }
                else {
                    $.messager.alert('��ʾ', obj.Msg);
                }
            }
        });
    }

    function selectcallback() {////ɾ���ɹ���ص��ĺ���
        // obj.SaveOkCallback();
        $(winid).window('close');
        $(tableid).datagrid('reload');
        $(tableid).datagrid('unselectAll');
    }
    function ReadOperation() {//��ȡȨ����Ϣ������û�е�Ȩ��
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
        alert("δ������");
    }
    var NameList = fieldNameList.join(",");
    return NameList
}
function GetEditUrl(item) {//�������ϵ��޸���Ҫ���ô˷��������޸ļ�¼ʱ�������Ҫ���ݶ������������д ��ѯ�ַ���Ϊid0=value0&id1=value1&id2=value2
    return 'Id=' + GetId(item);
}
function GetId(item) {//��ɾ��ʱ�˷�������ɾ��ʱ���õ�������ţ�ֻ��һ������ֵ�����޸�ʱ���ֻ����һ������Ҳ����ô˷���   
    alert('δ���巽��GetId');
}
//ʱ��ת��
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
//���ת��
function OperationMoney(value, rowData, rowIndex) {
    if (value == "") {
        return "��0.00";
    }
    return formatCurrency(value);
}
function fomartOperation(value, rowData, rowIndex) {//�������ڵ��޸ĺ�ɾ����ť���¼�
    var a = [];
    if (OperationList == undefined) {
        a.push("<a style='text-decoration:none;'  onclick=\"javascript:obj.Edit('", value, "')\"><span class='icon-edit'  title='�༭'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>&nbsp;&nbsp;&nbsp;&nbsp;");
        a.push("<a style='text-decoration:none;' onclick=\"javascript:obj.delMsg('", value, "')\"><span class='icon-cancel' title='ɾ��'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>&nbsp;");
    } else {
        if (OperationList.indexOf("edit") < 0) {
            a.push("<a style='text-decoration:none;'  onclick=\"javascript:obj.Edit('", value, "')\"><span class='icon-edit'  title='�༭'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>&nbsp;&nbsp;&nbsp;&nbsp;");
        }
        if (OperationList.indexOf("del") < 0) {
            a.push("<a style='text-decoration:none;'  onclick=\"javascript:obj.delMsg('", value, "')\"><span class='icon-cancel' title='ɾ��'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>&nbsp;");
        }
    }
    return a.join("");
}
function receiveMessage(e) {//html5����ķ������ڹر��޸ĺ�i��ӵ�frameʱ����Ҫ����
    var data = e.data;
    if (data == "windowclose") {
        obj.windowclose();
    } else if (data == "SaveOkCallback") {
        obj.SaveOkCallback();
    } else if (data == "SaveOkCallback2") {
        obj.SaveOkCallback2();
    } else {
        alert("δ���巽��");
    }
}
function SaveOkCallback() {////�ر�iframeʱ�����ø�����ķ���
    var t = window.parent;
    if (!t.obj.windowclose) {
        t.postMessage("SaveOkCallback", '*'); //html5����ķ���
    } else {
        t.obj.SaveOkCallback();
    }
}
function windowclose() {//�ر�iframeʱ�����ø�����ķ���
    var t = window.parent;
    if (!t.obj.windowclose) {
        t.postMessage("windowclose", '*'); //html5����ķ���
    } else {
        t.obj.windowclose();
    }
}
if (typeof window.addEventListener != 'undefined') {///html5����ķ������ڹر��޸ĺ�i��ӵ�frameʱ����Ҫ����
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
    var hasPoint = false; //�Ƿ���С������  
    var piontPart = ""; //С������  
    var intPart = strNum; //��������  
    if (arr1.length >= 2) {
        hasPoint = true;
        piontPart = arr1[1];
        intPart = arr1[0];
    }

    var res = ''; //������Ӷ��ŵĲ���  
    var intPartlength = intPart.length; //�������ֳ���  
    var maxcount = Math.ceil(intPartlength / 3); //����������Ҫ��Ӽ�������  
    for (var i = 1; i <= maxcount; i++)//ÿ��λ���һ������  
    {
        var startIndex = intPartlength - i * 3; //��ʼλ��  
        if (startIndex < 0)//��ʼλ��С��0ʱ����Ϊ0  
        {
            startIndex = 0;
        }
        var endIndex = intPartlength - i * 3 + 3; //����λ��  
        var part = intPart.substring(startIndex, endIndex) + ",";
        res = part + res;
    }
    res = res.substr(0, res.length - 1); //ȥ�����һ������  
    if (hasPoint) {
        return "��" + sign + res + "." + piontPart;
    }
    else {
        return "��" + sign + res;
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
function ShouldCheckOperationRight() {//�Ƿ���Ҫ���Ȩ�ޣ�Ĭ�ϲ���Ҫ��Ҳ���Ǿ�������Ȩ��
    return false;
}
function ManageOperation() {    //����Ȩ������û��Ȩ�޵İ�ť
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
//����id �����⣬����ҳ�棬�� ����
function showwin(winid, title, url, mywidth, myheight) {//�޸ĺ���ӵĵ�����
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
    //�Ȱѷ����ֵĶ��滻�����������ֺ�.
    obj.value = obj.value.replace(/[^\d.]/g, "");
    //���뱣֤��һ��Ϊ���ֶ�����.
    obj.value = obj.value.replace(/^\./g, "");
    //��ֻ֤�г���һ��.��û�ж��.
    obj.value = obj.value.replace(/\.{2,}/g, ".");
    //��֤.ֻ����һ�Σ������ܳ�����������
    obj.value = obj.value.replace(".", "$#$").replace(/\./g, "").replace("$#$", ".");
}