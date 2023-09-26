
costDistMain = function(dataStore, grid, pagingTool) {

    var rowObj = grid.getSelections();
    var len = rowObj.length;
    var repdr = "";
    var rowid = "";
    var repname = "";
    var monthDr = "";
    var active = "";
    if (len < 1) {
        Ext.Msg.show({ title: 'ע��', msg: '��ѡ��ɱ���̯��!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.WARNING });
        return;
    }
    else {
        active = rowObj[0].get("active");
        rowid = rowObj[0].get("rowid");
        repdr = rowObj[0].get("deptSetDr");
        repname = rowObj[0].get("deptSetName");
    }
    if (active != "Y") {
	    //'����Ϊ'+'<span style="color:red;">��Ч����</span>'+'�������ݷ�̯!'  zjw 20160708 ǰ̨�ͺ�̨���ɱ仯ʹ��
        Ext.Msg.show({ title: 'ע��', msg: '����Ϊ<span style="color:red;">��Ч����</span>�������ݷ�̯!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.WARNING });
        return;
    }


    var monthsDs = new Ext.data.Store({
        proxy: "",
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowid', 'code', 'name', 'desc', 'start', 'end', 'dataFinish'])
    });
    var months = new Ext.form.ComboBox({
        id: 'months',
        fieldLabel: '��������',
        width: 100,
        listWidth: 260,
        allowBlank: false,
        store: monthsDs,
        //readOnly:true,
        valueField: 'rowid',
        displayField: 'name',
        triggerAction: 'all',
        emptyText: 'ѡ���������...',
        pageSize: 10,
        minChars: 1,
        selectOnFocus: true,
        forceSelection: true
    });
    monthsDs.on('beforeload', function(ds, o) {
        ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.vouchdatasexe.csp?action=months&searchValue=' + Ext.getCmp('months').getRawValue(), method: 'GET' });
    });
    months.on('select', function(combo, record, index) {
        monthDr = combo.getValue();
    });
    var window = new Ext.Window({
        title: '�ɱ���̯',
        width: 300,
        height: 100,
        layout: 'fit',
        plain: true,
        modal: true,
        bodyStyle: 'padding:5px;',
        buttonAlign: 'center',
        items: [months],
        buttons: [
		{
		    text: 'ִ�з�̯',
		    handler: function() {
		        if (months.getValue() == "") {
		            Ext.Msg.show({ title: 'ע��', msg: '��ѡ���������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.WARNING });
		            return;
		        }
		        
		        Ext.Ajax.request({
		            url: costDistSetsUrl + '?action=checkResult&monthDr=' + monthDr + '&costSetsDr=' + rowid,
		            waitMsg: '������...',
		            failure: function(result, request) {
			           
		                Ext.Msg.show({ title: '����', msg: '������������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
		            },
		            success: function(result, request) {
		                var jsonData = Ext.util.JSON.decode(result.responseText);
		                
		                if (jsonData.success == 'true') {
			                Ext.Ajax.timeout=720000; //zjw 20160608
		        			//var mask=ShowLoadMask(Ext.getBody(),"������..."); //zjw 20160608
		        			var loadMask = new Ext.LoadMask(document.body, {msg : '�������������������...'});
						    loadMask.show();
		                    Ext.Ajax.request({
		                        url: costDistSetsUrl + '?action=doDist&monthDr=' + monthDr + '&costSetsDr=' + rowid,
		                        waitMsg: '������...',
		                        failure: function(result, request) {
			                         loadMask.hide(); //zjw 20160608
		                            Ext.Msg.show({ title: '����', msg: '������������!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
		                        },
		                        success: function(result, request) {
		                            var jsonData = Ext.util.JSON.decode(result.responseText);
		                            loadMask.hide(); //zjw 20160608
		                            if (jsonData.success == 'true') {
		                                Ext.Msg.show({ title: 'ע��', msg: jsonData.info, buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
		                                window.close();
		                            }
		                            else {
		                                var message = "";
		                                message = "SQLErr: " + jsonData.info;
		                                Ext.Msg.show({ title: '����', msg: message, buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
		                            }
		                        },
		                        scope: this
		                    });
		                }
		                else {
		                    var message ="�뵽\"�鿴��̯���\"����ɾ�����ݺ�����!";
		                    Ext.Msg.show({ title: '����', msg: message, buttons: Ext.Msg.OK, icon: Ext.MessageBox.ERROR });
		                }
		            },
		            scope: this
		        });
				Ext.Msg.show({ title: 'ע��', msg: "���ݷ�̯��,���Եȣ�", buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
				window.close();
		    }
		},
    	{
    	    text: 'ȡ��',
    	    handler: function() { window.close(); }
}]
    });

    window.show();
};