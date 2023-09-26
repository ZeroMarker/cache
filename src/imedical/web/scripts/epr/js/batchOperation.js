Ext.onReady(function() {
    Ext.QuickTips.init();

    var url = '../web.eprajax.toAuthRecord.cls?EpisodeID=' + episodeID + '&CurAction=Commit' + '&UserID=' + userID + '&SSGoupID=' + ssGroupID + '&CTLocID=' + ctLocID;
    var store = new Ext.data.JsonStore({
        url: url,
        fields: [{
            name: 'OrderID',
            type: 'int'
        }, {
            name: 'PrintDocID'
        }, {
            name: 'PrintType'
        }, {
            name: 'EPRNum'
        }, {
            name: 'RecordName'
        }, {
            name: 'RecordTitle'
        }, {
            name: 'RecordStatus'
        }, {
            name: 'SignStatus'
        }, {
            name: 'HappenDate'
        }, {
            name: 'HappenTime'
        }, {
            name: 'HasPrivilege'
        }, {
            name: 'InstanceDataID'
        }]
    });

    store.on('loadexception', function(proxy, options, response, e) {
        alert(response.responseText);
        //setDllVisibility("visible");
    });


    store.setDefaultSort('OrderID', 'asc');
    store.load();

    var cm = new Ext.grid.ColumnModel([{
        header: '顺序号',
        dataIndex: 'OrderID',
        width: 50,
        sortable: true,
        type: 'int'
    }, {
        header: '提交权限',
        dataIndex: 'HasPrivilege',
        width: 70,
        sortable: true
    }, {
        header: '病历名称',
        dataIndex: 'RecordName',
        width: 120,
        sortable: true
    }, {
        header: '病历标题',
        dataIndex: 'RecordTitle',
        width: 125,
        sortable: true
    }, {
        header: '发生日期',
        dataIndex: 'HappenDate',
        width: 75,
        sortable: true
    }, {
        header: '发生时间',
        dataIndex: 'HappenTime',
        width: 75,
        sortable: true
    }, {
        header: '病历状态',
        dataIndex: 'RecordStatus',
        width: 95,
        sortable: true
    }, {
        header: '签名状态',
        dataIndex: 'SignStatus',
        width: 120,
        sortable: true,
        resizable: true
    }, {
        header: '执行状态',
        dataIndex: 'OperateStatus',
        width: 120,
        sortable: true,
        resizable: true
    }]);

    function cancel() {
        Ext.getCmp('detailWin').close();
    }

    function confirmCommit() {

        var objUCPrint = document.getElementById('UCPrint');

        var store = Ext.getCmp('detailGrid').store;
        if (store.getCount() < 1) {
            alert("无可提交病历!");
            return;
        }
        debugger;
        //验证key的密码
        var key = Ext.getCmp("cbxKey").value;
        var txtpwd = Ext.getCmp("txtpwd").getValue();
        if ((typeof(key) == "undefined") || (trim(txtpwd) == ""))
            return;
        if (!userLogin(key, txtpwd)) {
            alert("登录失败!");
            return false;
        }

        var commitCount = 0;
        var commitOKCount = 0;
        for (var i = 0; i < store.getCount(); i++) {
            var record = store.getAt(i);
            var OrderID = record.get("OrderID");
            var printDocID = record.get("PrintDocID");
            var printType = record.get("PrintType");
            var eprNum = record.get("EPRNum");
            var happenDate = record.get("HappenDate");
            var happenTime = record.get("HappenTime");
            var instanceDataID = record.get("InstanceDataID");
            var recordName = record.get('RecordName');

            if (record.get('HasPrivilege') == '0') {
                continue;
            }

            commitCount = commitCount + 1;

            //检查质控
            if ("1" != objUCPrint.BatchQuality(episodeID, printType, printDocID, eprNum, instanceDataID, userID)) {
                //alert(recordName + " 检查质控未通过!");
                refreshStatus(OrderID, "检查质控未通过!");
                continue;
            }
            //获取内容
            var content = '';
            if ('Multiple' == printType){
	            content = objUCPrint.GetContent(episodeID, '', eprNum, instanceDataID, userID);
	        }
            else {
	            content = objUCPrint.GetContent(episodeID, printDocID, eprNum, instanceDataID, userID);
	        }
         
            if ('' == content) {
                //alert(recordName + " 获取内容失败!");
                refreshStatus(OrderID, "获取内容失败!");
                continue;
            }
            //本地签名
            var cert = GetSignCert(key);
            var UsrCertCode = GetUniqueID(cert);
            var contentHash = HashData(content);
            var signValue = SignedData(contentHash, key);
            if ('' == signValue) {
				refreshStatus(OrderID, "签名失败!");    
	        }
            //服务器验证签名
            var err = objUCPrint.BatchCASign(episodeID, printDocID, eprNum, instanceDataID, UsrCertCode, contentHash, signValue);
            if ("" != err) {
                //alert("签名失败：" +recordName + " " +err);
                refreshStatus(OrderID, "签名验证失败!" + " " +err);
                continue;
            }
            //提交操作
            if ("1" != objUCPrint.BatchCommit(episodeID, printType, printDocID, eprNum, instanceDataID, happenDate, happenTime, userID)) {
                //alert(recordName + " 提交失败!");
                refreshStatus(OrderID, "提交失败!");    
                continue;
            }

            commitOKCount = commitOKCount + 1;
            refreshStatus(OrderID, "提交成功!"); 
        }

        if (commitCount < 1) {
            alert("没有权限提交病历!");
            return;
        }

        alert("成功提交病历" + commitOKCount + "份!");
        store.reload();
    }


    var key = new Ext.data.Record.create([{
        name: 'keyName',
        type: 'string',
        mapping: 0
    }, {
        name: 'uniqueID',
        type: 'string',
        mapping: 1
    }]);
    var userData = "";
    var lstUsers = GetUserList();
	var arrUsers = lstUsers.split('&&&');
	// debugger;
	for (var i = 0; i < arrUsers.length; i++) {
		var user = arrUsers[i];
		if (user != "") {
			var keyName = user.split('||')[0];
			var uniqueID = user.split('||')[1];
			if (i > 0) {
				userData += ",";
			}
			userData += "['" + keyName + "','" + uniqueID + "']";
		}
	}
    var keyProxy = new Ext.data.MemoryProxy(eval("[" + userData + "]"));
    var keyReader = new Ext.data.ArrayReader({}, key);
    var keyStore = new Ext.data.Store({
        proxy: keyProxy,
        reader: keyReader,
        autoLoad: true
    });

    var tbar = new Ext.Toolbar({
        border: false,
        items: ['-', '选择证书：', {
            id: 'cbxKey',
            name: 'cbxKey',
            xtype: 'combo',
            fieldLabel: '选择证书',
            width: 140,
            mode: 'local',
            triggerAction: 'all',
            hiddenName: 'txtKeyName',
            store: keyStore,
            displayField: 'keyName',
            valueField: 'uniqueID',
            readOnly: true,
            allowBlank: false,
            emptyText: '请选择证书!',
            blankText: '请选择证书!'
        }, '密码：', {
            id: 'txtpwd',
            name: 'txtpwd',
            xtype: 'textfield',
            inputType: 'password',
            width: 140,
            fieldLabel: '密码',
            allowBlank: false,
            blankText: '请输入密码!'
        }, '-', {
            id: 'btnConfirmCommit',
            text: '批量提交',
            pressed: false,
            handler: confirmCommit
        }]
    });

    var grid = new Ext.grid.GridPanel({
        id: 'detailGrid',
        layout: 'fit',
        border: false,
        region: 'center',
        store: store,
        cm: cm,
        forceFit: true,
        autoScroll: true,
        frame: true,
        stripeRows: true,
        columnLines: true
    });

    var win = new Ext.Viewport({
        id: 'caCommit',
        layout: 'border',
        shim: false,
        frame: true,
        animCollapse: false,
        constrainHeader: true,
        collapsible: true,
        margins: '0 0 0 0',
        border: false,
        items: [{
            region: 'north',
            height: 30,
            margins: '5 5 5 5',
            items: tbar
        }, {
            title: '状态查询',
            id: 'detailPanel',
            region: 'center',
            margins: '5 5 5 5',
            layout: 'border',
            items: grid
        }]
    });

    // 删除左右两端的空格
    function trim(str) {
        return str.replace(/(^\s*)|(\s*$)/g, "");
    }

    function refreshStatus(OrderID, status) {
        var count = Ext.getCmp('detailGrid').getStore().getCount();
        for (var i = 0; i < count; i++) {
            var rec = Ext.getCmp('detailGrid').getStore().getAt(i);
            if (rec.get("OrderID") == OrderID) {
                rec.set("OperateStatus", status);
                return;
            }
        }
    }
});
