function InitViewScreenEvent(obj)
{
	var _DHCICUPara=ExtTool.StaticServerObject('web.DHCICUPara');
	obj.LoadEvent = function(args)
	{

	};
  var SelectedRowID = 0;
	var preRowID=0;	    
	obj.retGridPanel_rowclick=function()
    {
	    var rc = obj.retGridPanel.getSelectionModel().getSelected();
	    if (rc){
		    SelectedRowID=rc.get("TTemplateID");
		    if(preRowID!=SelectedRowID)
		    {
			    obj.tempid.setValue(rc.get("TTemplateID"));
			    obj.ctlocdesc.setValue(rc.get("TDeptID"));
			    obj.tempname.setValue(rc.get("TTemplateName"));
			    
			    obj.number.setValue("");
			    obj.itemcode.setValue("");
			    obj.itemname.setValue("");
			    obj.viewcat.setValue("");
			    obj.itemcomord.setValue("");
			    obj.propertyid.setValue("");
			    obj.proitems.setValue("");
			    obj.provalue.setValue("");
			    obj.viewitem.setValue("");
			     
			    preRowID=SelectedRowID;
		    }
		    else
		    {
			    obj.tempid.setValue("");
			    obj.itemid.setValue("");
			    obj.ctlocdesc.setValue("");
			    obj.tempname.setValue("");
			    obj.number.setValue("");
			    obj.itemcode.setValue("");
			    obj.itemname.setValue("");
			    obj.viewcat.setValue("");
			    obj.itemcomord.setValue("");
			    obj.propertyid.setValue("");
			    obj.proitems.setValue("");
			    obj.provalue.setValue("");
			    obj.viewitem.setValue("");
			    SelectedRowID = 0;
		        preRowID=0;
		        
	            obj.retGridPanelproStoreProxy.on('beforeload', function(objProxy, param){
	            param.ClassName = 'web.DHCICUPara';
		        param.QueryName = 'FindICUParaItemDetails';
		        param.Arg1 =obj.itemid.getValue();
		        param.ArgCnt = 1;
		        
	       });
	       obj.retGridPanelproStore.load({
		     params : {
		            start:0
		            ,limit:20       	
	       	}}); 
		    }
		    obj.retGridPanelitemStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.DHCICUPara';
		    param.QueryName = 'FindICUParaItem';
		    param.Arg1 = obj.ctlocdesc.getValue();
		    param.Arg2 = "";
		    param.Arg3 = "";
		    param.Arg4 = "";
		    param.ArgCnt = 4;
	        });
	     obj.retGridPanelitemStore.load({
	     params : {
		            start:0
		            ,limit:20
	     	}});
	        
	    }
    }
    obj.addtemp_click=function()
    {
	    if(obj.ctlocdesc.getValue()=="")
		{
			ExtTool.alert("��ʾ","���Ҳ���Ϊ��!");	
			return;
		}
		var ctlocid=obj.ctlocdesc.getValue();
		var tempname=obj.tempname.getValue();
		var ret=_DHCICUPara.AddICUPara(ctlocid,tempname);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("��ʾ","���ʧ��!");
		}
		else 
		{
			Ext.Msg.alert("��ʾ","��ӳɹ�!",function(){
			obj.tempid.setValue("");
			obj.ctlocdesc.setValue("");
			obj.tempname.setValue("");
	  	  	obj.retGridPanelStore.load({});  	
	  	  	});
		}
    }
    obj.updatetemp_click=function()
    {
	    if(obj.tempid.getValue()=="")
		{
			ExtTool.alert("��ʾ","��¼ID����Ϊ��!");	
			return;
		}
	    if(obj.ctlocdesc.getValue()=="")
		{
			ExtTool.alert("��ʾ","���Ҳ���Ϊ��!");	
			return;
		}
		var tempid=obj.tempid.getValue();
		var ctlocid=obj.ctlocdesc.getValue();
		var tempname=obj.tempname.getValue();
		var ret=_DHCICUPara.UpdateICUPara(tempid,ctlocid,"",tempname);
		if(ret!='0') 
		{ 
		     Ext.Msg.alert("��ʾ","����ʧ��!");
		}
		else 
		{
			Ext.Msg.alert("��ʾ","���³ɹ�!",function(){
			obj.tempid.setValue("");
			obj.ctlocdesc.setValue("");
			obj.tempname.setValue("");
	  	  	obj.retGridPanelStore.load({});  	
	  	  	});
		}		
    }
     obj.deletetemp_click=function()
    {
	    if(obj.tempid.getValue()=="")
		{
			ExtTool.alert("��ʾ","��¼ID����Ϊ��!");	
			return;
		}
	   
		var tempid=obj.tempid.getValue();
		if(tempid==1)
		{
			ExtTool.alert("��ʾ","��¼IDΪ1������ɾ��!");
			return;
		}
		var closeWindow = confirm("�Ƿ�ȷ��ɾ��?")
			 if(!closeWindow)
			 {
			  window.close()
			 }
			 else
			 {
					var ret=_DHCICUPara.DeleteICUPara(tempid);
					if(ret!='0') 
					{ 
					     Ext.Msg.alert("��ʾ","ɾ��ʧ��!");
					}
					else 
					{
						Ext.Msg.alert("��ʾ","ɾ���ɹ�!",function(){
						obj.tempid.setValue("");
						obj.ctlocdesc.setValue("");
						obj.tempname.setValue("");
				  	  	obj.retGridPanelStore.load({});
				  	  	obj.retGridPanelitemStore.load({}); 
				  	  	obj.retGridPanelproStore.load({});   	
				  	  	});
					}	
			}	
    }
    var SelectedRowID1 = 0;
	  var preRowID1=0;	  
    obj.retGridPanelitem_rowclick=function()
    {
	    var rc = obj.retGridPanelitem.getSelectionModel().getSelected();
	    if (rc){
		    SelectedRowID1=rc.get("TID");
		    if(preRowID1!=SelectedRowID1)
		    {
			    obj.itemid.setValue(rc.get("TID"));
			    obj.number.setValue(rc.get("TSeqNo"));
			    obj.itemcode.setValue(rc.get("TItemCode"));
			    obj.itemname.setValue(rc.get("TItemDesc"));
			    obj.viewcat.setValue(rc.get("TViewCatID"));
			    obj.itemcomord.setValue(rc.get("TComOrdID"));
			    //20160913+dyl
			     obj.propertyid.setValue("");
			    obj.proitems.setValue("");
			    obj.provalue.setValue("");
			    obj.viewitem.setValue("");

			    preRowID1=SelectedRowID1;
		    }
		    else
		    {
			    obj.itemid.setValue("");
			    obj.number.setValue("");
			    obj.itemcode.setValue("");
			    obj.itemname.setValue("");
			    obj.viewcat.setValue("");
			    obj.itemcomord.setValue("");
			    SelectedRowID1 = 0;
		        preRowID1=0;
		    }
		   //alert(obj.itemid.getValue());
	   	 obj.retGridPanelproStoreProxy.on('beforeload', function(objProxy, param){
		  param.ClassName = 'web.DHCICUPara';
		  param.QueryName = 'FindICUParaItemDetails';
		  param.Arg1 =obj.itemid.getValue();
		  param.ArgCnt = 1;
	    });	
	    obj.retGridPanelproStore.load({});     
	    }     
    }
    obj.finditem_click=function()
    {
	    	//alert(obj.ctlocdesc.getValue()+"/"+obj.viewcat.getValue()+"/"+obj.itemcomord.getValue())
	     obj.retGridPanelitemStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.DHCICUPara';
		    param.QueryName = 'FindICUParaItem';
		    param.Arg1 = obj.ctlocdesc.getValue();
		    param.Arg2 = obj.viewcat.getValue();
		    param.Arg3 = obj.itemcomord.getValue();
		    param.Arg4 = obj.itemname.getValue();
		    param.ArgCnt = 4;
	        });
	     obj.retGridPanelitemStore.load({
	     params : {
		            start:0
		            ,limit:20
	     	}});
    }
    obj.additem_click=function()
    {
	    if(obj.tempid.getValue()=="")
	    {
		   	ExtTool.alert("��ʾ","ģ��ID����Ϊ��!");	
			return; 
	    }
	   	    var number=obj.number.getValue();
	    if(number=="")
	    {
		    ExtTool.alert("��ʾ","��Ų���Ϊ��!");	
			return; 
	    }
	    var viewcat=obj.viewcat.getValue();
	    if(viewcat=="")
	    {
		    ExtTool.alert("��ʾ","��ʾ���಻��Ϊ��!");	
			return; 
	    }
	    var itemcode=obj.itemcode.getValue();
	    if(itemcode=="")
	    {
		    ExtTool.alert("��ʾ","���벻��Ϊ��!");	
			return; 
	    }
	    var itemname=obj.itemname.getValue();
	    if(itemname=="")
	    {
		    ExtTool.alert("��ʾ","���Ʋ���Ϊ��!");	
			return; 
	    }
	    var itemcomord=obj.itemcomord.getValue();
	    if(itemcomord=="")
	    {
		    ExtTool.alert("��ʾ","����ҽ������Ϊ��!");	
			return; 
	    }
	    var tempid=obj.tempid.getValue();
	    //alert(itemcomord+"#"+number+"#"+viewcat+"#"+itemcode+"#"+itemname+"#"+tempid)
	    var ret=_DHCICUPara.AddICUParaItem(itemcomord,number,viewcat,itemcode,itemname,tempid);
	    
	    if(ret!='0') 
		{ 
		     Ext.Msg.alert("��ʾ","���ʧ��!");
		}
		else 
		{
			Ext.Msg.alert("��ʾ","��ӳɹ�!",function(){
			obj.itemid.setValue("");
			obj.itemcomord.setValue("");
			obj.number.setValue("");
			obj.viewcat.setValue("");
			obj.itemcode.setValue("");
			obj.itemname.setValue("");
	  	  	obj.retGridPanelitemStore.load({});  	
	  	  	});
		}
    }
    
    obj.updateitem_click=function()
    {
	    if(obj.itemid.getValue()=="")
	    {
		   	ExtTool.alert("��ʾ","ID����Ϊ��!");	
			return; 		    
	    }
	    if(obj.tempid.getValue()=="")
	    {
		   	ExtTool.alert("��ʾ","ģ��ID����Ϊ��!");	
			return; 
	    }
	    var itemid=obj.itemid.getValue();
	    var tempid=obj.tempid.getValue();	
	    var itemcomord=obj.itemcomord.getValue();
	    if(itemcomord=="")
	    {
		    ExtTool.alert("��ʾ","����ҽ������Ϊ��!");	
			return; 
	    }
	    var viewcat=obj.viewcat.getValue();
	    if(viewcat=="")
	    {
		    ExtTool.alert("��ʾ","��ʾ���಻��Ϊ��!");	
			return; 
	    }
	    var number=obj.number.getValue();
	    if(number=="")
	    {
		    ExtTool.alert("��ʾ","��Ų���Ϊ��!");	
			return; 
	    }
	    var itemcode=obj.itemcode.getValue();
	     if(itemcode=="")
	    {
		    ExtTool.alert("��ʾ","���벻��Ϊ��!");	
			return; 
	    }
	    var itemname=obj.itemname.getValue();
	     if(itemname=="")
	    {
		    ExtTool.alert("��ʾ","��������Ϊ��!");	
			return; 
	    }
	    var ret=_DHCICUPara.UpdateICUParaItem(itemid,tempid,itemcomord,viewcat,number,itemcode,itemname);
	    
	    if(ret!='0') 
		{ 
		     Ext.Msg.alert("��ʾ","����ʧ��!");
		}
		else 
		{
			Ext.Msg.alert("��ʾ","���³ɹ�!",function(){
			obj.itemid.setValue("");
			obj.itemcomord.setValue("");
			obj.number.setValue("");
			obj.viewcat.setValue("");
			obj.itemcode.setValue("");
			obj.itemname.setValue("");
	  	  	obj.retGridPanelitemStore.load({});  	
	  	  	});
		}	    	      
    }
    
    obj.deleteitem_click=function()
    {
	    var itemid=obj.itemid.getValue();
	    if(itemid=="")
	    {
		   	ExtTool.alert("��ʾ","��ѡ��һ��Ҫɾ���ļ�¼!");	
			return; 		    
	    }
	    
	    Ext.Msg.confirm("ѡ��","ȷ��Ҫɾ����",function(btn){
	  	if(btn=="no")return;
	  	var ret=_DHCICUPara.DeleteICUParaItem(itemid);
	  	if(ret==-1)
	  	  Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  	else
	  	  Ext.Msg.alert("��ʾ","ɾ���ɹ���",function(){
			obj.itemid.setValue("");
			obj.itemcomord.setValue("");
			obj.number.setValue("");
			obj.viewcat.setValue("");
			obj.itemcode.setValue("");
			obj.itemname.setValue("");
			//20160918+dyl
			obj.propertyid.setValue("");
			    obj.proitems.setValue("");
			    obj.provalue.setValue("");
			    obj.viewitem.setValue("");
	  	  	obj.retGridPanelitemStore.load({});
	  	  	obj.retGridPanelproStore.load({}); 	//20160913+dyl
		  });
	    }
	    );	    	    
    }
    SelectedRowID2=0
    preRowID2=0
    obj.retGridPanelpro_rowclick=function()
    {
	    var rc = obj.retGridPanelpro.getSelectionModel().getSelected();
	    if (rc){
		    SelectedRowID2=rc.get("TPropertyValueID");
		    if(preRowID2!=SelectedRowID2)
		    {
			    obj.propertyid.setValue(rc.get("TPropertyValueID"));
			    obj.proitems.setValue(rc.get("TPropertyItemID"));
			    obj.provalue.setValue(rc.get("TPropertyValue"));
			    obj.viewitem.setValue(rc.get("TDisplayItemDesc"));
			    preRowID2=SelectedRowID2;
		    }
		    else
		    {
			    obj.propertyid.setValue("");
			    obj.proitems.setValue("");
			    obj.provalue.setValue("");
			    obj.viewitem.setValue("");
			    SelectedRowID2 = 0;
		        preRowID2=0;
		    }
	    }   
    }
    
    obj.addpro_click=function()
    {
	   // alert(1);
	    if(obj.itemid.getValue()=="")
	    {
		   	ExtTool.alert("��ʾ","ģ����ID����Ϊ��!");	
			return; 			    
	    }
	    var proitems=obj.proitems.getValue();
	    if(proitems=="")
	    {
		    ExtTool.alert("��ʾ","�������Ϊ��!");	
			return; 
	    }
	    var provalue=obj.provalue.getValue();
	    if(provalue=="")
	    {
		    ExtTool.alert("��ʾ","����ֵ����Ϊ��!");	
			return; 
	    }
	    var itemid=obj.itemid.getValue();
	    //alert(proitems+"#"+provalue+"#"+itemid)
	    var ret=_DHCICUPara.AddICUParaItemDetails(proitems,provalue,itemid);
	    if(ret!='0') 
		{ 
		     Ext.Msg.alert("��ʾ","���ʧ��!");
		}
		else 
		{
			Ext.Msg.alert("��ʾ","��ӳɹ�!",function(){
			//obj.propertyid.setValue("");
			obj.proitems.setValue("");
			obj.provalue.setValue("");
			obj.viewitem.setValue("");
	  	  	obj.retGridPanelproStore.load({});  	
	  	  	});
		}	    
    }
    
    obj.updatepro_click=function()
    {
	    if (obj.propertyid.getValue()=="")
	    {
		   	ExtTool.alert("��ʾ","������ID����Ϊ��!");	
			return; 		    
	    }
	    if(obj.itemid.getValue()=="")
	    {
		   	ExtTool.alert("��ʾ","ģ����ID����Ϊ��!");	
			return; 			    
	    }
	    var propertyid=obj.propertyid.getValue();
	    var itemid=obj.itemid.getValue();
	    
	    var proitems=obj.proitems.getValue();
	     if(proitems=="")
	    {
		    ExtTool.alert("��ʾ","�������Ϊ��!");	
			return; 
	    }
	    var provalue=obj.provalue.getValue();
	     if(provalue=="")
	    {
		    ExtTool.alert("��ʾ","����ֵ����Ϊ��!");	
			return; 
	    }

	    
	    var ret=_DHCICUPara.UpdateICUParaItemDetails(propertyid,itemid,proitems,provalue);
	    if(ret!='0') 
		{ 
		     Ext.Msg.alert("��ʾ","����ʧ��!");
		}
		else 
		{
			Ext.Msg.alert("��ʾ","���³ɹ�!",function(){
			obj.propertyid.setValue("");
			obj.proitems.setValue("");
			obj.provalue.setValue("");
			obj.viewitem.setValue("");
	  	  	obj.retGridPanelproStore.load({});  	
	  	  	});
		}		    	    
    }
    
    obj.deletepro_click=function()
    {
	    var propertyid=obj.propertyid.getValue()
	    if (propertyid=="")
	    {
		   	ExtTool.alert("��ʾ","��ѡ��һ��Ҫɾ���ļ�¼!");	
			return; 		    
	    }
	    Ext.Msg.confirm("ѡ��","ȷ��Ҫɾ����",function(btn){
	  	if(btn=="no")return;
	  	var ret=_DHCICUPara.DeleteICUParaItemDetails(propertyid);
	  	if(ret==-1)
	  	  Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  	else
	  	  Ext.Msg.alert("��ʾ","ɾ���ɹ���",function(){
			obj.propertyid.setValue("");
			obj.proitems.setValue("");
			obj.provalue.setValue("");
			obj.viewitem.setValue("");
	  	  	obj.retGridPanelproStore.load({}); 
		  });
	    }
	    );		    	    
    }
}