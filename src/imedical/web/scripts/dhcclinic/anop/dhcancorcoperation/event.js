function InitViewScreenEvent(obj)
{
	//20151013+dyl+��׼���޸�
	var _DHCANCOrc=ExtTool.StaticServerObject('web.DHCANCOrc');
	obj.LoadEvent = function(args) 
	{
	};
    var SelectedRowID = 0;
	var preRowID=0;
	
	obj.retGridPanel_rowclick = function()
	{
	  var rc ="";
	  rc =obj.retGridPanel.getSelectionModel().getSelected();
	  var linenum=obj.retGridPanel.getSelectionModel().lastActive;
	  if (rc)
	  {
		SelectedRowID=rc.get("tOperId");
	    if(preRowID!=SelectedRowID)
	    {   
	    	var AnCoplStr="";
			var BodssStr="";
			var ancOPCStr="";
			var OperPositionStr="";
		    obj.RowId.setValue(rc.get("tOperId"));
		    obj.ancORCCode.setValue(rc.get("tOperCode"));
		     obj.ancORCCode.disable();
		    obj.ancORCDesc.setValue(rc.get("tOperDesc")); 
		    obj.ancORCDesc.disable();
		    //obj.AnCoplDr.setValue(rc.get("tAncoplId"));20160830+dyl
		     //obj.AnCoplDr.setRawValue(rc.get("tAncoplDesc"));
		    obj.opType.setValue(rc.get("tOpTypeCode"));
		    obj.opType.setRawValue(rc.get("tOpType"));
		    obj.BodssDr.setValue(rc.get("tBodsId"));
		    obj.ancOPCModelDr.setValue(rc.get("tBldtpId"));
		    obj.OperPositionModelDr.setValue(rc.get("tOperPositionId"));
		   	obj.OperCategModelDr.setValue(rc.get("tOperCategId"));
		    preRowID=SelectedRowID;
	    }
	    else
	    {
		  
		    obj.ancORCCode.setValue("");
		    obj.ancORCCode.enable();
		  	obj.ancORCDesc.setValue("");
		  	obj.ancORCDesc.enable();
		    obj.RowId.setValue("");
		    //obj.AnCoplDr.setValue("");20160830+dyl
		    obj.BodssDr.setValue("");
		    obj.ancOPCModelDr.setValue("");
		    obj.OperPositionModelDr.setValue("");
		    obj.opType.setValue("");	//��������
		    obj.OperCategModelDr.setValue("");	//��������
		    obj.retGridPanel.getSelectionModel().deselectRow(linenum);
		    SelectedRowID = 0;
		    preRowID=0;
		    
		}
	  }
	};
	//����
	obj.addbutton_click = function()
	{
		///var opaId=obj.opaId.getValue();
        //var Rowid=obj.RowId.getValue();
        //��������
        var ancORCDesc=obj.ancORCDesc.getValue();
        if(ancORCDesc=="")
        {
	        Ext.Msg.alert("��ʾ","����Ϊ��");
	        return;
        }
        //��������
        var ancORCCode=obj.ancORCCode.getValue();
         if(ancORCCode=="")
        {
	        Ext.Msg.alert("��ʾ","����Ϊ��");
	        return;
        }
        //������ģ��ͣ��+20160830+dyl
        //var AnCoplDr=obj.AnCoplDr.getValue();
        //alert(AnCoplDr);
        //������λ
        var BodssDr=obj.BodssDr.getValue();
         //alert(BodssDr);
         //�е�����
        var ancOPCModelDr=obj.ancOPCModelDr.getValue();
         //alert(ancOPCModelDr);
         //������λ
        var OperPositionModelDr=obj.OperPositionModelDr.getValue();
         //alert(OperPositionModelDr);
         //������ģ��ͣ��+20160830+dyl:AnCoplDr
         var dhcOrcOperStr=""+"^"+ancOPCModelDr+"^"+BodssDr+"^"+OperPositionModelDr
         //alert(dhcOrcOperStr);
         //�������ࣺ
         var OperCateDr=obj.OperCategModelDr.getValue();
         //��������
         var opType=obj.opType.getValue();
		var ret =_DHCANCOrc.AddDHCOrcOperation(ancORCDesc,ancORCCode,dhcOrcOperStr,OperCateDr,opType);
	
		//alert(ret);
		if(ret<0)
		{
		  Ext.Msg.alert("��ʾ","����ʧ�ܣ�");	
		}
		else
		{
		  	Ext.Msg.alert("��ʾ","���ӳɹ���",function(){
	  	  	obj.RowId.setValue("");
	  	  	obj.ancORCCode.setValue("");
	  	  	obj.ancORCDesc.setValue("");
	  	  	//obj.AnCoplDr.setValue("");	//20160830+dyl
	  	  	obj.BodssDr.setValue("");
	  	  	obj.opType.setValue("");
	  	  	obj.ancOPCModelDr.setValue("");
	  	  	obj.OperPositionModelDr.setValue("");
	  	  	obj.OperCategModelDr.setValue("");
	  	  	obj.retGridPanelStore.removeAll();
	  	  	obj.retGridPanelStore.load({
		  	   params : {
				start:0
				,limit:200
			}
		  	  	}); 
		 	});
	     }
	 };

	
	//�޸�
	obj.updatebutton_click = function()
	{
		///var opaId=obj.opaId.getValue();
        var Rowid=obj.RowId.getValue();
        if(Rowid=="")
        {
	         Ext.Msg.alert("��ʾ","��ѡ��һ����¼");
	        return;
        }
        //��������
        var ancORCCode=obj.ancORCCode.getValue();
        
        //������ģ��ͣ��+20160830+dyl
       // var AnCoplDr=obj.AnCoplDr.getValue();
        //alert(AnCoplDr);
        //������λ
        var BodssDr=obj.BodssDr.getValue();
         //alert(BodssDr);
         //�е�����
        var ancOPCModelDr=obj.ancOPCModelDr.getValue();
         //alert(ancOPCModelDr);
         //������λ
        var OperPositionModelDr=obj.OperPositionModelDr.getValue();
         //alert(OperPositionModelDr);
         //var dhcOrcOperStr=AnCoplDr+"^"+ancOPCModelDr+"^"+BodssDr+"^"+OperPositionModelDr
         //������ģ��ͣ��+20160830+dyl
         var dhcOrcOperStr=""+"^"+ancOPCModelDr+"^"+BodssDr+"^"+OperPositionModelDr
         //
         //alert(dhcOrcOperStr);
         //�������ࣺ
         var OperCateDr=obj.OperCategModelDr.getValue();
         //��������
         var opType=obj.opType.getValue();
         //alert(opType)
		var ret =_DHCANCOrc.SaveDHCOrcOperation(Rowid,dhcOrcOperStr,OperCateDr,opType);
	
		//alert(ret);
		if(ret<0)
		{
		  Ext.Msg.alert("��ʾ","����ʧ�ܣ�");	
		}
		else
		{
		  Ext.Msg.alert("��ʾ","���³ɹ���",function(){
	  	  	 //var linenum=obj.retGridPanel.getSelectionModel().lastActive;
	  	  	 //obj.retGridPanel.getSelectionModel().deselectRow(linenum);
	  	  	obj.RowId.setValue("");
	  	  	obj.ancORCCode.setValue("");
	  	  	obj.ancORCDesc.setValue("");
	  	  	obj.ancORCCode.enable();	//20160830
	  	  	obj.ancORCDesc.enable();
	  	  	//obj.AnCoplDr.setValue("");20160830+dyl
	  	  	obj.BodssDr.setValue("");
	  	  	obj.opType.setValue("");
	  	  	obj.ancOPCModelDr.setValue("");
	  	  	obj.OperPositionModelDr.setValue("");
	  	  	obj.OperCategModelDr.setValue("");
	  	  	obj.retGridPanelStore.removeAll();
	  	  	obj.retGridPanelStore.load({
		  	   params : {
				start:0
				,limit:200
			}
		  	  	}); 
		 	});
	     }
	 };


	
	obj.deletebutton_click = function()
	{
      var Rowid=obj.RowId.getValue();
	  if(Rowid=="")
	  {
	    Ext.Msg.alert("��ʾ","��ѡ��һ��Ҫɾ���ļ�¼��");
	    return;
	  }
	  Ext.Msg.confirm("ѡ��","ȷ��Ҫɾ����",function(btn){
	  	if(btn=="no")return;
	  	var ret=_DHCANCOrc.DeleteDHCOrcOperation(Rowid);
	  	//alert(ret);
	  	if(ret==-1)
	  	  Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  	else
	  	  Ext.Msg.alert("��ʾ","ɾ���ɹ���",function(){
	  	  	obj.RowId.setValue("");
	  	  	obj.ancORCCode.setValue("");
	  	  	obj.ancORCDesc.setValue("");
	  	  	obj.ancORCCode.enable();	//20160830
	  	  	obj.ancORCDesc.enable();
	  	  	//obj.AnCoplDr.setValue("");20160830+dyl
	  	  	obj.BodssDr.setValue("");
	  	  	obj.ancOPCModelDr.setValue("");
	  	  	obj.OperPositionModelDr.setValue("");
	  	  	obj.OperCategModelDr.setValue("");
	  	  	obj.retGridPanelStore.removeAll();
	  	  	obj.retGridPanelStore.load({
		  	   params : {
				start:0
				,limit:200
			}
		  	  	}); 	  	
	  	  	});
	  	}
	  );
	};
   obj.findbutton_click = function(){
   obj.retGridPanelStore.load({
	   params : {
				start:0
				,limit:200
			}

	   });
   obj.RowId.setValue("");
   obj.ancORCCode.setValue("");
   obj.ancORCDesc.setValue("");
   };	
}
