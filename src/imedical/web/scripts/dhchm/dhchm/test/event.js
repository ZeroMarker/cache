function InitViewportMainEvent(obj){
	
    obj.LoadEvent = function(args){
    }
    obj.ButtonT_click = function(){
    	
    	
    	Ext.air.Sound.play("D:\\2010-05-07\83.mp3",0);
    	return;
        //var tmp = ExtTool.RunServerMethod("test.hhh", "go");
        Ext.Ajax.request({
            url: 'dhchm.control.req.csp', //��csp��ִ��ҵ���߼���write����
            method: 'post',
            waitMsg: '������...',
            success: function(response, opts){
                //�Խ��յ������ݾ��д���
                var fn = new Function("test", response.responseText);
                var panel = fn();
                obj.FormPanelT.add(panel);
                obj.FormPanel3.setActiveTab(panel.getId());
                obj.FormPanelT.doLayout();
            },
            failure: function(response, opts){
                console.log('server-side failure with status code ' + response.status);
            },
            scope: this
        });
        
        
        //obj.FormPanelT.add(tmp);
        //obj.FormPanelT.doLayout();
    };
    /*ViewportMain��������ռλ��*/



























}
