var i=0;j=0;
var txt=new Array();
txt[0]="←";
txt[1]="↖"; 
txt[2]="↑";
txt[3]="↗";
txt[4]="→";
txt[5]="↘";
txt[6]="↓";
txt[7]="↙";

var fortime;
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
	 
	 	return;
	};
	obj.btRecord_click= function()
	{ 
        //  if (TheSMSobj==null){InitSMSWin();} 
        //   TheSMSobj.SMSWin.show();
        var selflag;
        for(var i = 0; i < obj.typeradio.items.getCount(); i++) 
        { if (obj.typeradio.items.itemAt(i).checked) selflag=obj.typeradio.items.itemAt(i).inputValue; }
       
        obj.GridPanelMSStoreProxy.on('beforeload', function(objProxy, param){
        param.ClassName = 'web.DHCHM.MessageSend';
        param.QueryName = 'FindRecord';
        param.Arg1 ="" ;
        param.Arg2 = "";
        param.Arg3 = selflag;
        param.ArgCnt = 3;
        
        });
    
    obj.GridPanelMS.store.load();
    obj.GridPanelMS.getSelectionModel().selectAll();
   
   
	};
	obj.btNew_click = function()
	{
      if (obj.btNew.text!='停止自动发送') 
      { 
      	fortime=setInterval(obj.timework,1);
      	obj.btNew.setText('停止自动发送');
      }else{ 
        clearInterval(fortime);
        obj.btNew.setText('启动自动发送');
      }
	};
	obj.timework=function(){
		//alert('a');
		
		i=i+1;j=j+1;
		if (i>7) i=0;
		obj.cellno .setText(txt[i]);
		if (j>1000){
				obj.btRecord_click();
		} 
		if (j>1050){
			j=0;clearInterval(fortime);
			if (obj.GridPanelMSStore.getCount()>0)
			{
			obj.GridPanelMS.getSelectionModel().selectAll();
		  SMSSend();
	  	};
			fortime=setInterval(obj.timework,300);
		}
	}
	obj.btClear_click= function()
	{ 
         obj.GridPanelMSStore.removeAll();
       

	};
}

