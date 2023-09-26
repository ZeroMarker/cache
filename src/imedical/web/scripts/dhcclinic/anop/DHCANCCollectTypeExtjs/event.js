function InitViewScreenEvent(obj)
{
	var _DHCANCCollectType = ExtTool.StaticServerObject('web.DHCANCCollectType');
	
	obj.LoadEvent=function(args)
	{

		var hpDevs=_DHCANCCollectType.GetHPDeves();
		var MSrvIP=_DHCANCCollectType.GetMSrvIP();
		
		obj.hpDevs.setValue(hpDevs);
		
		var strArr=MSrvIP.split("^");
		if(strArr.length>=2)
		{
			obj.ANCCTSource.setValue(strArr[1]);
			obj.MSrvIP.setValue(strArr[0]);
		}
	};
	
	
	obj.retGridPanel_rowclick=function()
	{
		var rc = obj.retGridPanel.getSelectionModel().getSelected();
		if(rc)
		{
			obj.ANCCTCode.setValue(rc.get("tCode"));
			obj.ANCCTDesc.setValue(rc.get("tDesc"));
			obj.ANCCTSource.setValue(rc.get("tSource"));
			obj.ANCCTActive.setValue(rc.get("tANCCTActive"));
			obj.ANCCTActive.setRawValue(rc.get("tANCCTActive")=="Y"?"��":"��");
			obj.ANCCTRowid.setValue(rc.get("trowid"));
			
			obj.retGridItemPanelStore.load({});
		}
	};
	
	obj.addButton_click=function()
	{
		var ANCCTCode=obj.ANCCTCode.getValue();
		var ANCCTDesc=obj.ANCCTDesc.getValue();
		var ANCCTActive=(obj.ANCCTActive.getValue()=="1"?"Y":"N");
		var ANCCTSource=obj.ANCCTSource.getValue();
		
		if(ANCCTCode==""||ANCCTDesc==""||ANCCTActive==""||ANCCTSource=="")
		{
			Ext.Msg.alert("��ʾ","����,����,Source,ANCCTActive������Ϊ��");
			return;
		}
		
		var ret=_DHCANCCollectType.InsertDHCANCCollectType(ANCCTCode,ANCCTDesc,ANCCTActive,ANCCTSource);
		if(ret=="0")
		{
			Ext.Msg.alert("��ʾ","���ӳɹ�!",function(){
				obj.ANCCTCode.setValue("");
				obj.ANCCTDesc.setValue("");
				obj.ANCCTActive.setValue("");
				obj.ANCCTActive.setRawValue("");
				obj.ANCCTSource.setValue("I");
				obj.ANCCTRowid.setValue("");
				
				obj.retGridPanelStore.load({});
				obj.retGridItemPanelStore.load({});
			});
		}
		else
		{
			Ext.Msg.alert("��ʾ","����ʧ��:"+ret);
			return;
		}
		
	};
	
	obj.updateButton_click=function()
	{
		var ANCCTRowid=obj.ANCCTRowid.getValue();
		if(ANCCTRowid=="")
		{
			Ext.Msg.alert("��ʾ","��ѡ��һ��");
			return;
		}
		
		var ANCCTCode=obj.ANCCTCode.getValue();
		var ANCCTDesc=obj.ANCCTDesc.getValue();
		var ANCCTActive=(obj.ANCCTActive.getValue()=="1"?"Y":"N");
		var ANCCTSource=obj.ANCCTSource.getValue();
		
		if(ANCCTCode==""||ANCCTDesc==""||ANCCTActive==""||ANCCTSource=="")
		{
			Ext.Msg.alert("��ʾ","����,����,Source,ANCCTActive������Ϊ��");
			return;
		}
		
		var ret=_DHCANCCollectType.UPDATEDHCANCCollectType(ANCCTRowid,ANCCTCode,ANCCTDesc,ANCCTActive);
		if(ret=="0")
		{
			Ext.Msg.alert("��ʾ","���³ɹ�!",function(){
				obj.ANCCTCode.setValue("");
				obj.ANCCTDesc.setValue("");
				obj.ANCCTActive.setValue("");
				obj.ANCCTActive.setRawValue("");
				obj.ANCCTSource.setValue("I");
				obj.ANCCTRowid.setValue("");
				
				obj.retGridPanelStore.load({});
				obj.retGridItemPanelStore.load({});
			})
		}
		else
		{
			Ext.Msg.alert("��ʾ","����ʧ��:"+ret);
			return;
		}
	};
	
	obj.deleteButton_click=function()
	{
		var ANCCTRowid=obj.ANCCTRowid.getValue();
		if(ANCCTRowid=="")
		{
			Ext.Msg.alert("��ʾ","��ѡһ��Ҫɾ���ļ�¼��");
			return;
		}
		
		Ext.Msg.confirm("ѡ��","ȷ��Ҫɾ����",function(btn){
	  		if(btn=="no")
	  		{
		  		return;
	  		}
	  		var ret=_DHCANCCollectType.DeleteDHCANCCollectType(ANCCTRowid);
	  		if(ret!="0")
	  		{
	  	  		Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  	  		return;
	  		}
	  		else
	  		{
		  		Ext.Msg.alert("��ʾ","ɾ���ɹ���");
	  	 	 	obj.ANCCTCode.setValue("");
				obj.ANCCTDesc.setValue("");
				obj.ANCCTActive.setValue("");
				obj.ANCCTActive.setRawValue("");
				obj.ANCCTSource.setValue("A");
				obj.ANCCTRowid.setValue("");
				
				obj.retGridPanelStore.load({});
				obj.retGridItemPanelStore.load({});
				
				obj.retGridPanel.getSelectionModel().clearSelections();//�������ѡ��
	  		}
	    });	
	};
	
	obj.findButton_click=function()
	{
		obj.retGridPanelStore.load({});
		obj.retGridItemPanelStore.load({});
	};
	
	
	obj.setDevesButton_click=function()
	{
		var hpDevs=""
		hpDevs=obj.hpDevs.getValue();
		var MSrvIP=obj.MSrvIP.getValue();
		alert(hpDevs+MSrvIP)
		var ret1=_DHCANCCollectType.SetHPDeves(hpDevs);
		
		var ret2=_DHCANCCollectType.SetMSrvIP(MSrvIP);
		
		Ext.Msg.alert("��ʾ","���óɹ���");
	};
	
	obj.copyButton_click=function()
	{
		var srcDev=obj.srcDev.getValue();
		var dstDev=obj.dstDev.getValue();
		
		if(srcDev=="")
		{
			Ext.Msg.alert("��ʾ","Source Device����Ϊ�գ�");
			return;
		}
		
		if(dstDev=="")
		{
			Ext.Msg.alert("��ʾ","dest Deivice����Ϊ�գ�");
			return;
		}
		
		var ret=_DHCANCCollectType.CopyDevChNo(srcDev,dstDev);
		if(ret=="0")
		{
			Ext.Msg.alert("��ʾ","���Ƴɹ���");
			return
		}
		else
		{
			Ext.Msg.alert("��ʾ","����ʧ�ܣ�");
			return
		}
	};
	
	
	obj.retGridItemPanel_rowclick=function()
	{
		var rc = obj.retGridItemPanel.getSelectionModel().getSelected();
		if(rc)
		{
			obj.Code.setValue(rc.get("tCode"));
			obj.ANCCTActiveItem.setValue(rc.get("tANCCTIActive"));
			obj.ANCCTActiveItem.setRawValue(rc.get("tANCCTIActive")=="Y"?"��":"��");
			obj.ANCCTIChannelNo.setValue(rc.get("tANCCTIChannelNo"));
			obj.ANCCTIComOrd.setValue(rc.get("tANCCTIComOrdDr"));
			obj.ANCCTIComOrd.setRawValue(rc.get("tANCCTIComOrdDrDesc"));
			obj.ItemRowid.setValue(rc.get("trowid"));
		}
	}
	
	obj.addButtonItem_click=function()
	{
		var Code=obj.Code.getValue();
		var ANCCTIChannelNo=obj.ANCCTIChannelNo.getValue();
		var ANCCTActive=(obj.ANCCTActiveItem.getValue()=="1"?"Y":"N");
		var ANCCTIParref=obj.ANCCTRowid.getValue();
		var ANCCTIComOrdDr=obj.ANCCTIComOrd.getValue();
		
		if(ANCCTIParref=="")
		{
			Ext.Msg.alert("��ʾ","���ڼ໤�豸��ѡ��һ��!");
			return;
		}
		
		var ret=_DHCANCCollectType.InsertDHCANCCollectTypeitem(Code, ANCCTIChannelNo, ANCCTActive, ANCCTIParref, ANCCTIComOrdDr);
		if(ret=="0")
		{
			Ext.Msg.alert("��ʾ","���ӳɹ�!",function(){
				obj.Code.setValue("");
				obj.ANCCTActiveItem.setValue("");
				obj.ANCCTActiveItem.setRawValue("");
				obj.ANCCTIChannelNo.setValue("");
				obj.ANCCTIComOrd.setValue("");
				obj.ANCCTIComOrd.setRawValue("");
				obj.ItemRowid.setValue("");
				obj.retGridItemPanel.getSelectionModel().clearSelections();//�������ѡ��
				
				
	  	  		obj.retGridItemPanelStore.load({});  	
	  	  	});
		}
		else
		{
			Ext.Msg.alert("��ʾ","����ʧ��:"+ret);
			return;
		}
	}
	
	
	obj.deleteButtonItem_click=function()
	{
		var Rowid=obj.ItemRowid.getValue();
		if(Rowid=="")
		{
			Ext.Msg.alert("��ʾ","��ѡ��һ��");
			return;
		}
		
		Ext.Msg.confirm("ѡ��","ȷ��Ҫɾ����",function(btn){
	  		if(btn=="no")
	  		{
		  		return;
	  		}
	  		var ret=_DHCANCCollectType.DeleteDHCANCCollectTypeitem(Rowid);
	  		if(ret!="0")
	  		{
	  	  		Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  		}
	  		else
	  		{
		  		Ext.Msg.alert("��ʾ","ɾ���ɹ���");
	  	 	 	obj.Code.setValue("");
				obj.ANCCTActiveItem.setValue("");
				obj.ANCCTActiveItem.setRawValue("");
				obj.ANCCTIChannelNo.setValue("");
				obj.ANCCTIComOrd.setValue("");
				obj.ANCCTIComOrd.setRawValue("");
				obj.ItemRowid.setValue("");
				obj.retGridItemPanel.getSelectionModel().clearSelections();//�������ѡ��
				
	  	  		obj.retGridItemPanelStore.load({});
	  		}
	    });	
	}
	
	obj.updateButtonItem_click=function()
	{
		var Rowid=obj.ItemRowid.getValue();
		var Code=obj.Code.getValue();
		var ANCCTIChannelNo=obj.ANCCTIChannelNo.getValue();
		var ANCCTActive=(obj.ANCCTActiveItem.getValue()=="1"?"Y":"N");
		var ANCCTIParref=obj.ANCCTRowid.getValue();
		var ANCCTIComOrdDr=obj.ANCCTIComOrd.getValue();
		
		if(ANCCTIParref=="")
		{
			Ext.Msg.alert("��ʾ","���ڼ໤�豸��ѡ��һ��!");
			return;
		}
		
		alert(Rowid+"^"+Code+"^"+ANCCTIChannelNo+"^"+ANCCTActive+"^"+ANCCTIParref+"^"+ANCCTIComOrdDr)
		
		var ret=_DHCANCCollectType.UPDATEDHCANCCollectTypeitem(Rowid, Code, ANCCTIChannelNo, ANCCTActive, ANCCTIParref, ANCCTIComOrdDr);
		if(ret=="0")
		{
			Ext.Msg.alert("��ʾ","���³ɹ�!",function(){
				obj.Code.setValue("");
				obj.ANCCTActiveItem.setValue("");
				obj.ANCCTActiveItem.setRawValue("");
				obj.ANCCTIChannelNo.setValue("");
				obj.ANCCTIComOrd.setValue("");
				obj.ANCCTIComOrd.setRawValue("");
				obj.ItemRowid.setValue("");
				obj.retGridItemPanel.getSelectionModel().clearSelections();//�������ѡ��
				
	  	  		obj.retGridItemPanelStore.load({});  	
	  	  	});
		}
		else
		{
			Ext.Msg.alert("��ʾ","����ʧ��:"+ret);
			return;
		}
	}
}