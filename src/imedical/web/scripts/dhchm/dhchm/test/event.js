function InitViewportMainEvent(obj){
	
    obj.LoadEvent = function(args){
    }
    obj.ButtonT_click = function(){
    	
    	
    	Ext.air.Sound.play("D:\\2010-05-07\83.mp3",0);
    	return;
        //var tmp = ExtTool.RunServerMethod("test.hhh", "go");
        Ext.Ajax.request({
            url: 'dhchm.control.req.csp', //在csp中执行业务逻辑，write数据
            method: 'post',
            waitMsg: '加载中...',
            success: function(response, opts){
                //对接收到的数据就行处理
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
    /*ViewportMain新增代码占位符*/



























}
