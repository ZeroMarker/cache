/**
 * ������� - ȷ��
 * @creator �ƺ���
 */
$(function () {
    /**
     * �ڲ�ȫ��
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
    components('Status', 'status'); // ���ȷ�� | ���ȷ��
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
     * ע���¼�
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
            components('Pop', '��ȷ�Ϲ�');
            return;
        }
        Audit();
    });
    PHA_EVENT.Bind('#btnAuditByAccount', 'click', function () {
        if (com.GetSelectedRow('#gridMain', 'accountDate') !== '') {
            components('Pop', '��ȷ�Ϲ�');
            return;
        }
        var sel = com.GetSelectedRow('#gridMain');
        if (sel === null) {
            components('Pop', '����ѡ���¼');
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
            components('Pop', '��ȷ�Ϲ�');
            return;
        }
        biz.setData('handleStatus', 'AuditByTreasure');
        Audit();
    });
    PHA_EVENT.Bind('#btnPrint', 'click', function () {
        com.Print(com.GetSelectedRow('#gridMain', 'payID'));
    });
    /* ����ƾ֤ start */
    PHA_EVENT.Bind('#btnVoucher', 'click', function () {
        if (com.GetSelectedRow('#gridMain', 'voucherNo') !== '') {
            components('Pop', '�����ɸ���ƾ֤');
            return;
        }
        var sel = com.GetSelectedRow('#gridMain');
        if(sel == null){
	        components('Pop', '��ѡ���¼');
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
    /* ����ƾ֤ end */
    
    /**
     * ����
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
            components('Pop', '����ѡ���¼');
            return;
        }
        if (funcName === 'HandleAudit4Account'){ // �����'���ȷ��' �� Ӧ����� �� �����һ��ʱ�ŵ���ȷ����ʾ��
	        var sel = com.GetSelectedRow('#gridMain');
	        var payAmt = sel.payAmt;
	        if (parseFloat(payAmt) != parseFloat(dataObj.checkAmt)){
		        PHA.Confirm('��ʾ', 'Ӧ�������֧����һ��,��ȷ��ִ�л��ȷ����?', function () {
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
                components('Pop', 'ȷ�ϳɹ�');
                try {
                    $('#win4Account').window('close');
                } catch (error) {}
                com.UpdateRow('#gridMain', com.GetSelectedRowIndex('#gridMain'), { payID: payID });
                // ����������ѡ����
                // $('#gridMain').datagrid('reload');
            }
        });
        */
    }
    /* ��ΪҪ�ȶԸ����ִ��'ȷ��'�����ķ���������ȡ���� */
    function ExeAudit(funcName, dataObj, payID){
	    PHA.Loading('Show');
        com.Invoke(funcName, $.extend(dataObj, { payID: payID }), function (retData) {
            PHA.Loading('Hide');
            if (typeof retData === 'string') {
                PHA.Alert('', retData, 'warning');
            } else {
                components('Pop', 'ȷ�ϳɹ�');
                try {
                    $('#win4Account').window('close');
                } catch (error) {}
                com.UpdateRow('#gridMain', com.GetSelectedRowIndex('#gridMain'), { payID: payID });
                // ����������ѡ����
                // $('#gridMain').datagrid('reload');
            }
        });
    }
    
    setTimeout(function () {
        SetDefaults();
        com.SetPage('pha.in.v3.pay.audit.csp');
    }, 0);
});
