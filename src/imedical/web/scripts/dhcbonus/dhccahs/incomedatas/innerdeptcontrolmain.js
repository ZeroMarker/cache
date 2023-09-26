InnerDeptControl = function() {
    var deptTypeDr = "11";
    Ext.MessageBox.confirm('提示',
		'确定要转换部门么?',
    	    function(btn) {
    	        if (btn == 'yes') {
	    	         var loadMask = new Ext.LoadMask(document.body, {msg : '正在向服务器发送请求...'});
						                             loadMask.show();
						Ext.Ajax.timeout=720000; //zjw 20160608
    	            Ext.Ajax.request({
    	                url: 'dhc.ca.incomedatasexe.csp?action=innerdept&monthDr=' + monthDr + '&deptTypeDr=' + deptTypeDr,
    	                waitMsg: '保存中...',
    	                failure: function(result, request) {
	    	                 loadMask.hide();
    	                    Ext.Msg.show({ title: '提示', msg: '正在执行请求，请稍后查看!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
    	                     
    	                },
    	                success: function(result, request) {
	    	                 loadMask.hide();
    	                    var jsonData = Ext.util.JSON.decode(result.responseText);
    	                    if (jsonData.success == 'true') {
    	                        Ext.Msg.show({ title: '注意', msg: '刷新成功!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
    	                        incomeDatasDs.load({ params: { start: incomeDatasPagingToolbar.cursor, limit: incomeDatasPagingToolbar.pageSize, monthDr: monthDr} });
    	                    } else {
    	                        Ext.Msg.show({ title: '注意', msg: '刷新失败!', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
    	                    }
    	                },
    	                scope: this
    	            });
    	        }
    	    }
		);
};