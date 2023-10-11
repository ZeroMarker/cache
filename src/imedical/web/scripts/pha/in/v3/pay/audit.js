/**
 * 付款管理 - 确认
 * @creator 云海宝
 */
$(function () {
    /**
     * 内部全局
     */
    var biz = {
        data: {
            status: '',
            handleStatus: '',
            defaultData: [
                {
                    startDate: PHA_UTIL.GetDate('t'),
                    endDate: PHA_UTIL.GetDate('t'),
                    loc: session['LOGON.CTLOCID']
                }
            ]
        },
        getData: function (key) {
            return this.data[key];
        },
        setData: function (key, data) {
            this.data[key] = data;
        }
    };
    var components = PAY_COMPONENTS();
    var com = PAY_COM;
    var settings = com.GetSettings();

    components('Date', 'startDate');
    components('Date', 'endDate');
    components('Loc', 'loc');
    components('Status', 'status'); // 会计确认 | 库管确认
    components('Vendor', 'vendor');
    components('PayCheckMode', 'checkMode');
    components('FilterField', 'filterField');
    components('MainGrid', 'gridMain', {
        toolbar: '#gridMainBar',
        rownumbers: true,
        onClickRow: function () {
            var pJson = com.Condition('#qCondition', 'get');
            pJson.payID = com.GetSelectedRow('#gridMain', 'payID');
            com.QueryItmGrid('gridItm', pJson);
        },
        onLoadSuccess: function (data) {
            com.ValidateGridData(data);
            $('#gridItm').datagrid('clear');
        }
    });
    var rebuildColumns = PHA_COM.RebuildColumns(components('ItmGridColmuns', 'gridItm'), {
        hiddenFields: ['gCheck']
    });
    components('ItmGrid', 'gridItm', {
        columns: rebuildColumns.columns,
        frozenColumns: rebuildColumns.frozenColumns
    });

    /**
     * 注册事件
     */

    PHA_EVENT.Bind('#btnFind', 'click', function () {
        var pJson = com.Condition('#qCondition', 'get');
        pJson.status = 'COMP';
        com.QueryMainGrid('gridMain', pJson);
    });
    PHA_EVENT.Bind('#btnClean', 'click', function () {
        com.Condition('#qCondition', 'clear');
        $('#gridMain, #gridItm').datagrid('clear');
        SetDefaults();
    });
    PHA_EVENT.Bind('#btnAuditByPurch', 'click', function () {
        biz.setData('handleStatus', 'AuditByPurch');

        if (com.GetSelectedRow('#gridMain', 'purchDate') !== '') {
            components('Pop', '已确认过');
            return;
        }
        Audit();
    });
    PHA_EVENT.Bind('#btnAuditByAccount', 'click', function () {
        if (com.GetSelectedRow('#gridMain', 'accountDate') !== '') {
            components('Pop', '已确认过');
            return;
        }
        var sel = com.GetSelectedRow('#gridMain');
        if (sel === null) {
            components('Pop', '请先选择记录');
            return;
        }
        var payID = sel.payID;
        if (payID === '') {
            return;
        }
        $('#win4Account').window({});
        $('#link-vendor').text(sel.vendorDesc);
        $('#link-no').text(sel.no);
        $('#link-amt').text(sel.payAmt);
        com.Condition('#win4Account', 'clear');
    });
    PHA_EVENT.Bind('#btnOk4Account', 'click', function () {
        biz.setData('handleStatus', 'AuditByAccount');
        var dataObj = com.Condition('#win4Account .pha-con-table', 'get', { doType: 'save' });
        if (dataObj === undefined) {
            return;
        }
        Audit(dataObj);
    });
    PHA_EVENT.Bind('#btnCancel4Account', 'click', function () {
        $('#win4Account').window('close');
    });

    PHA_EVENT.Bind('#btnAuditByTreasure', 'click', function () {
        if (com.GetSelectedRow('#gridMain', 'treasureDate') !== '') {
            components('Pop', '已确认过');
            return;
        }
        biz.setData('handleStatus', 'AuditByTreasure');
        Audit();
    });
    PHA_EVENT.Bind('#btnPrint', 'click', function () {
        com.Print(com.GetSelectedRow('#gridMain', 'payID'));
    });
    /* 付款凭证 start */
    PHA_EVENT.Bind('#btnVoucher', 'click', function () {
        if (com.GetSelectedRow('#gridMain', 'voucherNo') !== '') {
            components('Pop', '已生成付款凭证');
            return;
        }
        var sel = com.GetSelectedRow('#gridMain');
        if(sel == null){
	        components('Pop', '请选择记录');
            return;
        }
        var payID = sel.payID;
        if (payID === '') {
            return;
        }
        $('#win4Voucher').window({});
        $('#voucher-vendor').text(sel.locDesc);
        com.Condition('#win4Voucher', 'clear');
        
        var date = new Date();
        $('#voucher-year').numberbox('setValue', date.getFullYear());
        $('#voucher-mon').numberbox('setValue', date.getMonth() + 1);
        
    });
    PHA_EVENT.Bind('#btnOk4Voucher', 'click', function () {
        biz.setData('handleStatus', 'CreateVoucher');
        var dataObj = com.Condition('#win4Voucher .pha-con-table', 'get', { doType: 'save' });
        if (dataObj === undefined) {
            return;
        }
        dataObj['payID'] = com.GetSelectedRow('#gridMain').payID;
        com.Invoke(com.Fmt2ApiMethod('CreateVoucher'), dataObj, function (retData) {
            if (typeof retData === 'string') {
                PHA.Alert('', retData, 'warning');
            } else {
                $('#win4Voucher').window('close');
                $('#btnFind').click();
            }
        });
    });
    PHA_EVENT.Bind('#btnCancel4Voucher', 'click', function () {
        $('#win4Voucher').window('close');
    });
    /* 付款凭证 end */
    
    /**
     * 函数
     */
    function SetDefaults() {
        PHA.SetVals(biz.getData('defaultData'));
    }

    function Audit(dataObj) {
        dataObj = dataObj || {};
        var funcName = com.Fmt2ApiMethod(biz.getData('handleStatus'));
        if (funcName === '') {
            return;
        }
        var payID = com.GetSelectedRow('#gridMain', 'payID');
        if (payID === '') {
            components('Pop', '请先选择记录');
            return;
        }
        if (funcName === 'HandleAudit4Account'){ // 如果是'会计确认' 且 应付金额 和 付款金额不一致时才弹出确认提示框。
	        var sel = com.GetSelectedRow('#gridMain');
	        var payAmt = sel.payAmt;
	        if (parseFloat(payAmt) != parseFloat(dataObj.checkAmt)){
		        PHA.Confirm('提示', '应付金额与支付金额不一致,您确认执行会计确认吗?', function () {
		            ExeAudit(funcName, dataObj, payID);
		        });
	        }
	        else{
		        ExeAudit(funcName, dataObj, payID);
	        }
        }
        else{
	        ExeAudit(funcName, dataObj, payID);
        }
        /*
        PHA.Loading('Show');
        com.Invoke(funcName, $.extend(dataObj, { payID: payID }), function (retData) {
            PHA.Loading('Hide');
            if (typeof retData === 'string') {
                PHA.Alert('', retData, 'warning');
            } else {
                components('Pop', '确认成功');
                try {
                    $('#win4Account').window('close');
                } catch (error) {}
                com.UpdateRow('#gridMain', com.GetSelectedRowIndex('#gridMain'), { payID: payID });
                // 连续操作的选中行
                // $('#gridMain').datagrid('reload');
            }
        });
        */
    }
    /* 因为要比对付款金额，执行'确认'操作的方法单独提取出来 */
    function ExeAudit(funcName, dataObj, payID){
	    PHA.Loading('Show');
        com.Invoke(funcName, $.extend(dataObj, { payID: payID }), function (retData) {
            PHA.Loading('Hide');
            if (typeof retData === 'string') {
                PHA.Alert('', retData, 'warning');
            } else {
                components('Pop', '确认成功');
                try {
                    $('#win4Account').window('close');
                } catch (error) {}
                com.UpdateRow('#gridMain', com.GetSelectedRowIndex('#gridMain'), { payID: payID });
                // 连续操作的选中行
                // $('#gridMain').datagrid('reload');
            }
        });
    }
    
    setTimeout(function () {
        SetDefaults();
        com.SetPage('pha.in.v3.pay.audit.csp');
    }, 0);
});
