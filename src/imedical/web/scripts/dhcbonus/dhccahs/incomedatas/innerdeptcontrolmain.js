InnerDeptControl = function() {
    var deptTypeDr = "11";
    Ext.MessageBox.confirm('��ʾ',
		'ȷ��Ҫת������ô?',
    	    function(btn) {
    	        if (btn == 'yes') {
	    	         var loadMask = new Ext.LoadMask(document.body, {msg : '�������������������...'});
						                             loadMask.show();
						Ext.Ajax.timeout=720000; //zjw 20160608
    	            Ext.Ajax.request({
    	                url: 'dhc.ca.incomedatasexe.csp?action=innerdept&monthDr=' + monthDr + '&deptTypeDr=' + deptTypeDr,
    	                waitMsg: '������...',
    	                failure: function(result, request) {
	    	                 loadMask.hide();
    	                    Ext.Msg.show({ title: '��ʾ', msg: '����ִ���������Ժ�鿴!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
    	                     
    	                },
    	                success: function(result, request) {
	    	                 loadMask.hide();
    	                    var jsonData = Ext.util.JSON.decode(result.responseText);
    	                    if (jsonData.success == 'true') {
    	                        Ext.Msg.show({ title: 'ע��', msg: 'ˢ�³ɹ�!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
    	                        incomeDatasDs.load({ params: { start: incomeDatasPagingToolbar.cursor, limit: incomeDatasPagingToolbar.pageSize, monthDr: monthDr} });
    	                    } else {
    	                        Ext.Msg.show({ title: 'ע��', msg: 'ˢ��ʧ��!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
    	                    }
    	                },
    	                scope: this
    	            });
    	        }
    	    }
		);
};