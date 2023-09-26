//全局
var FSReviewDialog = FSReviewDialog || {
    ReasonSelectID: ""
};

//配置和静态
FSReviewDialog.Config = FSReviewDialog.Config || {
    ERROR_INFO: "错误",
    ERROR_INFO_NOREASON: "请填写退回原因",
    ERROR_INFO_OPERATION: "操作失败"
};

(function (win) {
    $(function () {

        //$('#inputReasonSelect').combogrid('grid').datagrid('reload');

        //------------------------------------------------------------------------------------------------------------------

        //退回原因弹窗
        $('#backBtn').on('click', function () {
            var reason = $('#inputReason').val();

            if (reason === "") {
                $.messager.alert(FSReviewDialog.Config.ERROR_INFO, FSReviewDialog.Config.ERROR_INFO_NOREASON, 'info');
            }
            else {
                var reason = $('#inputReason').val();

                window.dialogArguments.funObj.apply(this, [reason]);
                FSReviewCommon.CloseWebPage();
            }
        });

        $('#cancelBtn').on('click', function () {
            FSReviewCommon.CloseWebPage();
        });

        $('#inputReasonSelect').combogrid({
            idField: 'CategoryID',
            textField: 'CategoryDesc',
            url: "../DHCEPRFS.web.eprajax.AjaxReview.cls?Action=loadreasoncategory&UserID=" + userID,
            method: 'get',
            panelWidth: 266,
            showHeader: false,
			fitColumns: true,
            singleSelect: true,
            columns: [[
                { field: 'CategoryID', title: 'CategoryID', width: 80, hidden: true },
                { field: 'CategoryCode', title: 'CategoryCode', width: 80, hidden: true },
                { field: 'CategoryDesc', title: 'CategoryDesc', width: 266 },
                { field: 'Reason', title: 'Reason', width: 250, hidden: true }
            ]],
            onSelect: function () {
                var row = $('#inputReasonSelect').combogrid('grid').datagrid('getSelected');
                $('#inputReason').val(row.Reason);
                FSReviewDialog.ReasonSelectID = row.CategoryID;
            }
        });

        $('#addReasonBtn').on('click', function () {
            var inputText = $('#inputReasonSelect').combogrid('getValue');
            if (inputText === "") {
                return;
            }

            var reason = $('#inputReason').val();

            var obj = $.ajax({
                url: "../DHCEPRFS.web.eprajax.AjaxReview.cls?Action=addreasoncategory&UserID=" + userID + "&Reason=" + encodeURI(reason) + "&Category=" + encodeURI(inputText),
                type: 'post',
                async: false
            });

            var ret = obj.responseText;
            if (ret === "1") {
                FSReviewDialog.ReasonSelectID = "";
                $('#inputReasonSelect').combogrid('grid').datagrid('reload');
            }
            else {
                alert(FSReviewDialog.Config.ERROR_INFO_OPERATION);
            }
        });

        $('#removeReasonBtn').on('click', function () {
            if (FSReviewDialog.ReasonSelectID == "") {
                return;
            }

            var obj = $.ajax({
                url: "../DHCEPRFS.web.eprajax.AjaxReview.cls?Action=removereasoncategory&Category=" + FSReviewDialog.ReasonSelectID,
                type: 'post',
                async: false
            });

            var ret = obj.responseText;
            if (ret === "1") {
                FSReviewDialog.ReasonSelectID = "";
                $('#inputReasonSelect').combogrid('grid').datagrid('reload');
            }
            else {
                alert(FSReviewDialog.Config.ERROR_INFO_OPERATION);
            }
        });

        $('#saveReasonBtn').on('click', function () {
            if (FSReviewDialog.ReasonSelectID == "") {
                return;
            }
            var reason = $('#inputReason').val();

            var obj = $.ajax({
                url: "../DHCEPRFS.web.eprajax.AjaxReview.cls?Action=savereasoncategory&Category=" + FSReviewDialog.ReasonSelectID + "&Reason=" + encodeURI(reason),
                type: 'post',
                async: false
            });

            var ret = obj.responseText;
            if (ret === "1") {
                FSReviewDialog.ReasonSelectID = "";
                $('#inputReasonSelect').combogrid('grid').datagrid('reload');
            }
            else {
                alert(FSReviewDialog.Config.ERROR_INFO_OPERATION);
            }
        });

    });
}(window));