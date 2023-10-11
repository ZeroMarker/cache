/**
 * FileName: dhcbill.opbill.unhandlist.js
 * Author: ZhYW
 * Date: 2022-01-14
 * Description: 收费员未结算查询
 */

$(function () {
    initQueryMenu();
    initUnHandList();
});

function initQueryMenu() {
    $HUI.linkbutton("#btn-find", {
        onClick: function () {
            loadUnHandList();
        }
    });

    $HUI.linkbutton("#btn-print", {
        onClick: function () {
            printClick();
        }
    });

    //收费员
    $HUI.combobox("#userName", {
        panelHeight: 150,
        url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryInvUser&ResultSetType=array&invType=O&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
        valueField: 'id',
        textField: 'text',
        defaultFilter: 5
    });
}

function initUnHandList() {
    GV.UnHandList = $HUI.datagrid("#unHandList", {
        fit: true,
        border: false,
        singleSelect: true,
        rownumbers: true,
        pagination: true,
        pageSize: 20,
        className: "web.DHCOPBillUnHand",
        queryName: "FindUnHandDetail",
        onColumnsLoad: function (cm) {
            for (var i = (cm.length - 1); i >= 0; i--) {
                if ($.inArray(cm[i].field, ["Tjob", "TUserRowid"]) != -1) {
                    cm[i].hidden = true;
                    continue;
                }
                if (!cm[i].width) {
                    cm[i].width = 100;
                }
            }
            cm.push({
                title: '明细',
                field: 'TDtl',
                align: 'center',
                width: 80,
                formatter: function (value, row, index) {
                    return "<a href='javascript:;' class='datagrid-cell-img' title='明细' onclick='openDtlView(" + JSON.stringify(row) + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png'/></a>";
                }
            });
        },
        onLoadSuccess: function (data) {
            $(".datagrid-cell-img").tooltip();
        }
    });
}

function loadUnHandList() {
    var queryParams = {
        ClassName: "web.DHCOPBillUnHand",
        QueryName: "FindUnHandDetail",
        UserDr: getValueById("userName") || "",
        HospId: PUBLIC_CONSTANT.SESSION.HOSPID
    };
    loadDataGridStore("unHandList", queryParams);
}

function openDtlView(row) {
    var _content = "<div id=\"dtl-mod-dlg\" style=\"padding:10px;\">"
					+ "<table id=\"dtlList\"></table>"
				+ "</div>";
    $("body").append(_content);
    $("#dtl-mod-dlg").dialog({
        width: 1000,
        height: 650,
        iconCls: 'icon-w-list',
        title: '发票明细',
        draggable: false,
        modal: true,
        onBeforeOpen: function () {
            $HUI.datagrid("#dtlList", {
                fit: true,
                bodyCls: 'panel-body-gray',
                singleSelect: true,
                rownumbers: true,
                pagination: true,
                pageSize: 20,
                className: "web.DHCOPBillUnHand",
		        queryName: "FindUnHandDetailByUser",
		        onColumnsLoad: function (cm) {
		            for (var i = (cm.length - 1); i >= 0; i--) {
		                if (!cm[i].width) {
		                    cm[i].width = 100;
		                }
		            }
		        },
                url: $URL,
                queryParams: {
                    ClassName: "web.DHCOPBillUnHand",
                    QueryName: "FindUnHandDetailByUser",
                    UserRowid: row.TUserRowid,
                    Job: row.Tjob
                }
            });
        },
        onClose: function () {
            $("body").remove("#dtl-mod-dlg");
            $("#dtl-mod-dlg").dialog("destroy");
        }
    });
}

/**
 * 打印
 */
function printClick() {
    var userId = getValueById("userName");
    var fileName = "DHCBILL-OPBILL-UnHandDetail.rpx&UserDr=" + userId + "&HospId=" + PUBLIC_CONSTANT.SESSION.HOSPID;
    var width = $(window).width() * 0.8;
    var height = $(window).height() * 0.8;
    DHCCPM_RQPrint(fileName, width, height);
}
