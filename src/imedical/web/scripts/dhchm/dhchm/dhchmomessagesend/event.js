function InitViewport1Event(obj) {
	
	var TheOBJ = ExtTool.StaticServerObject("web.DHCHM.MessageSend");
		var selid="";
	obj.LoadEvent = function(args)
  {};
  
	obj.btSend_click = function()
	{ 
	//TheMainobj.GridPanelMS.getStore().getAt(1).set("vResult","sssssss");
	//TheMainobj.GridPanelMS.getView().refresh(); 
	 	
	 	SMSSend();
	 	SendType=0;obj.btNew.enable();
	 	return;
	};
	obj.btRecord_click= function()
	{ 
        //  if (TheSMSobj==null){InitSMSWin();} 
        //   TheSMSobj.SMSWin.show();
       
        obj.GridPanelMSStoreProxy.on('beforeload', function(objProxy, param){
        param.ClassName = 'web.DHCHM.MessageSend';
        param.QueryName = 'FindRecord';
        param.Arg1 = "";
        param.Arg2 = "";
        param.Arg3 = "";
        param.ArgCnt = 3;
        
        });
    
    obj.GridPanelMS.store.load();
    SendType=1;obj.btNew.disable() ;
	};
	obj.btNew_click = function()
	{ 
          if (TheWindowsobj==null){InitWindow8();} 
          TheWindowsobj.Window8.show();

	};
	obj.btClear_click= function()
	{ 
         obj.GridPanelMSStore.removeAll();
         SendType=0;obj.btNew.enable();

	};
}

