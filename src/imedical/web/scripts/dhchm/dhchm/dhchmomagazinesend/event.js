function InitViewport1Event(obj) 
{
	var TheOBJ = ExtTool.StaticServerObject("web.DHCHM.MessageSend");

	obj.LoadEvent = function(args)
  {};
  
	obj.btSend_click = function()
	{
		//����
     //���������б�
      var User = session['LOGON.USERID'];
     // User=1;
      var MessageID=obj.param1.getValue();
      if (MessageID=="") 
          { ExtTool.alert("��ѡ��Ҫ������־!");return;}
      var SendList="";
      var Valuestr=MessageID+"^"+obj.SDesc.getValue()+"^"+User;
    
    
    var rs=obj.GridPanelMS.getSelectionModel().getSelections();
    
       Ext.each(rs,function(){
       	  
       	  if (SendList!="") SendList=SendList+"^"; 
       	   SendList=SendList+this.get("OQEId");
       })
     
        if (SendList=="")  {
        	 ExtTool.alert("��ʾ","������Ա�б�Ϊ�գ�����ʧ��!");
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
      	  ExtTool.alert("��ʾ","������Ա�б�Ϊ�գ�����ʧ��!");
		       return;
      }
      */
      //alert(SendList);
      
      
        
		     var ret = TheOBJ.CMagazineSendSaveData(Valuestr,SendList);	
		     if(ret<0) 
         {
		       ExtTool.alert("��ʾ","����ʧ�ܣ�");
		       return;
		     }else{
			      ExtTool.alert("��ʾ","���ͳɹ���");
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
