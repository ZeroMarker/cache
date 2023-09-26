function InitViewport1Event(obj) 
{
	var TheOBJ = ExtTool.StaticServerObject("web.DHCHM.MessageSend");

	obj.LoadEvent = function(args)
  {};
  
	obj.btSend_click = function()
	{
		//发送
     //做个发送列表串
      var User = session['LOGON.USERID'];
     // User=1;
      var MessageID=obj.param1.getValue();
      if (MessageID=="") 
          { ExtTool.alert("请选择要发送杂志!");return;}
      var SendList="";
      var Valuestr=MessageID+"^"+obj.SDesc.getValue()+"^"+User;
    
    
    var rs=obj.GridPanelMS.getSelectionModel().getSelections();
    
       Ext.each(rs,function(){
       	  
       	  if (SendList!="") SendList=SendList+"^"; 
       	   SendList=SendList+this.get("OQEId");
       })
     
        if (SendList=="")  {
        	 ExtTool.alert("提示","发送人员列表为空！发送失败!");
        	 return;
        }
    /*
      var temp;
	    var num=TheMainobj.GridPanelMS.getStore().getCount(); 
	  //  alert(num);
	    if(num>0)
	    {
       for(var i=0;i<num;i++)
       {
       	temp=TheMainobj.GridPanelMS.getStore().getAt(i);
       	if (SendList!="") SendList=SendList+"^"; 
       	SendList=SendList+temp.get("OQEId");
       };
      }else{
      	  ExtTool.alert("提示","发送人员列表为空！发送失败!");
		       return;
      }
      */
      //alert(SendList);
      
      
        
		     var ret = TheOBJ.CMagazineSendSaveData(Valuestr,SendList);	
		     if(ret<0) 
         {
		       ExtTool.alert("提示","发送失败！");
		       return;
		     }else{
			      ExtTool.alert("提示","发送成功！");
			   }
			
			
	};
	obj.btNew_click = function()
	{ 
          if (TheWindowsobj==null){     	
          	InitWindow8();
          }
          TheWindowsobj.Window8.show();
	};
	
};
