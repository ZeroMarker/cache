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
			//1^�ǣ�0^�񣺺�̨���
			obj.ANCCTActive.setValue(rc.get("tANCCTActive")=="Y"?"1":"0");
			obj.ANCCTActive.setRawValue(rc.get("tANCCTActive")=="Y"?"��":"��");
			obj.ANCCTRowid.setValue(rc.get("trowid"));
			
			ReloadItemPanelStore();
				obj.Code.setValue("");
				obj.Code.enable() ;
				obj.ANCCTActiveItem.setValue("");
				obj.ANCCTActiveItem.setRawValue("");
				obj.ANCCTIChannelNo.setValue("");
				obj.ANCCTIComOrd.setValue("");
				obj.ANCCTIComOrd.setRawValue("");
				obj.ItemRowid.setValue("");
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
		//��Ӹ��ж�
		var repeatret=_DHCANCCollectType.CompareCollectType(ANCCTCode,"")
		if(repeatret==1)
		{
			var flag=confirm("���������ظ�,ȷ�ϼ������?")
			if(flag)
			{
			}
			else
			{
				return;
			}
			
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
				
				ReloadItemPanelStore();
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
		//1^�ǣ�0^�񣺺�̨���Y��N
		var ANCCTSource=obj.ANCCTSource.getValue();
		
		if(ANCCTCode==""||ANCCTDesc==""||ANCCTActive==""||ANCCTSource=="")
		{
			Ext.Msg.alert("��ʾ","����,����,Source,ANCCTActive������Ϊ��");
			return;
		}
		//��Ӹ��ж�
		var repeatret=_DHCANCCollectType.CompareCollectType(ANCCTCode,ANCCTRowid)
		if(repeatret==1)
		{
			var flag=confirm("���������ظ�,ȷ�ϼ����޸�?")
			if(flag)
			{
			}
			else
			{
				return;
			}
			
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
				
				ReloadItemPanelStore();
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
				obj.ANCCTSource.setValue("I");
				obj.ANCCTRowid.setValue("");
				
				obj.retGridPanelStore.load({});
				//20160928+dyl
				obj.Code.setValue("");
				obj.ANCCTActiveItem.setValue("");
				obj.ANCCTActiveItem.setRawValue("");
				obj.ANCCTIChannelNo.setValue("");
				obj.ANCCTIComOrd.setValue("");
				obj.ANCCTIComOrd.setRawValue("");
				obj.ItemRowid.setValue("");
				

				ReloadItemPanelStore();
	  		}
	    });	
	};
	
	obj.findButton_click=function()
	{	obj.retGridPanelStore.removeAll();
		obj.retGridPanelStore.load({});
		obj.ANCCTCode.setValue("");
		obj.ANCCTDesc.setValue("");
		obj.ANCCTActive.setValue("");
		obj.ANCCTActive.setRawValue("");
		obj.ANCCTSource.setValue("I");
		obj.ANCCTRowid.setValue("");
		ReloadItemPanelStore();
	};
	
	
	obj.setDevesButton_click=function()
	{
		var hpDevs=obj.hpDevs.getValue();
		var MSrvIP=obj.MSrvIP.getValue();
		
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
	
	var curRow="",lastRow=""
	obj.retGridItemPanel_rowclick=function()
	{
		var rc = obj.retGridItemPanel.getSelectionModel().getSelected();
		if(rc)
		{
			obj.Code.setValue(rc.get("tCode"))
			curRow=obj.Code.getValue();
			if(curRow!=lastRow)
			{
				obj.Code.setValue(rc.get("tCode"));
				obj.Code.disable() ;
				obj.ANCCTActiveItem.setValue(rc.get("tANCCTIActive")=="Y"?"1":"0");
				obj.ANCCTActiveItem.setRawValue(rc.get("tANCCTIActive")=="Y"?"��":"��");
				obj.ANCCTIChannelNo.setValue(rc.get("tANCCTIChannelNo"));
				obj.ANCCTIComOrd.setValue(rc.get("tANCCTIComOrdDr"));
				obj.ANCCTIComOrd.setRawValue(rc.get("tANCCTIComOrdDrDesc"));
				obj.ItemRowid.setValue(rc.get("trowid"));
				lastRow=curRow;
			}
			else
			{
				obj.Code.setValue("");
				obj.Code.enable() ;
				obj.ANCCTActiveItem.setValue("");
				obj.ANCCTActiveItem.setRawValue("");
				obj.ANCCTIChannelNo.setValue("");
				obj.ANCCTIComOrd.setValue("");
				obj.ANCCTIComOrd.setRawValue("");
				obj.ItemRowid.setValue("");
				curRow="";
				lastRow=curRow;
			}
		}
		else
		{
			obj.Code.enable() ;
		}
	}
	//20160902+dyl
	obj.addButtonItem_click=function()
	{
		var ANCCTIComOrdFlag=false;
		var Code=obj.Code.getValue();
		if(Code=="")
	    {
		    ExtTool.alert("��ʾ","��Ų���Ϊ��!");	
			return; 
	    }
		var ANCCTIChannelNo=obj.ANCCTIChannelNo.getValue();
		 if(ANCCTIChannelNo=="")
	    {
		    ExtTool.alert("��ʾ","ͨ���Ų���Ϊ��!");	
			return; 
	    }
		var ANCCTActive=(obj.ANCCTActiveItem.getValue()=="1"?"Y":"N");
		var ANCCTIParref=obj.ANCCTRowid.getValue();
		var ANCCTIComOrdDr=obj.ANCCTIComOrd.getValue();
		 if(ANCCTIComOrdDr=="")
	    {
		    ExtTool.alert("��ʾ","�໤��Ŀ���Ʋ���Ϊ��!");	
			return; 
	    }
		if(ANCCTIParref=="")
		{
			Ext.Msg.alert("��ʾ","���ڼ໤�豸��ѡ��һ��!");
			return;
		}
		//---20190109 YuanLin ������ֻ��ѡ��������д
		var ANCCTIComOrdNum=obj.ANCCTIComOrdStore.data.items.length;
		var ANCCTIComOrdItems=obj.ANCCTIComOrdStore.data.items;
		if(ANCCTIComOrdDr!="")
		{
			if(ANCCTIComOrdNum!=0)
			{
				for (var i = 0; i < ANCCTIComOrdNum; i++)
				{
					if (ANCCTIComOrdDr == ANCCTIComOrdItems[i].data.MDIRowid)
					{
						ANCCTIComOrdFlag = true;
						break;
					}
				}
				if(!ANCCTIComOrdFlag)
				{
					ExtTool.alert("��ʾ","�໤��Ŀ�������������ѡ��!");
					return ;
				}
			}
			if(ANCCTIComOrdNum==0)
			{
				ExtTool.alert("��ʾ","�໤��Ŀ�������������ѡ��!");
				return ;
			}
		}
		else
		{
			var ANCCTIComOrdRaw=obj.ANCCTIComOrd.getRawValue();
			if(ANCCTIComOrdRaw!="")
			{
				ExtTool.alert("��ʾ","�໤��Ŀ�������������ѡ��!");
				return ;
			}
		}
		//alert(Code+"/"+ANCCTIChannelNo+"/"+ANCCTActive+"/"+ANCCTIParref+"/"+ANCCTIComOrdDr)
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
				
				ReloadItemPanelStore();			
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
				
				ReloadItemPanelStore();
	  		}
	    });	
	}
	//20160902+����
	obj.updateButtonItem_click=function()
	{
		var ANCCTIComOrdFlag=false;
		var Rowid=obj.ItemRowid.getValue();
		if(Rowid=="")
	    {
		    ExtTool.alert("��ʾ","��ѡ��һ����¼!");	
			return; 
	    }
		var Code=obj.Code.getValue();
		 if(Code=="")
	    {
		    ExtTool.alert("��ʾ","��Ų���Ϊ��!");	
			return; 
	    }
		var ANCCTIChannelNo=obj.ANCCTIChannelNo.getValue();
		 if(ANCCTIChannelNo=="")
	    {
		    ExtTool.alert("��ʾ","ͨ���Ų���Ϊ��!");	
			return; 
	    }
		var ANCCTActive=(obj.ANCCTActiveItem.getValue()=="1"?"Y":"N");
		var ANCCTIParref=obj.ANCCTRowid.getValue();
		var ANCCTIComOrdDr=obj.ANCCTIComOrd.getValue();
		 if(ANCCTIComOrdDr=="")
	    {
		    ExtTool.alert("��ʾ","�໤��Ŀ���Ʋ���Ϊ��!");	
			return; 
	    }
		//20160902+dyl
		//alert(ANCCTActive)
		if(ANCCTIParref=="")
		{
			Ext.Msg.alert("��ʾ","���ڼ໤�豸��ѡ��һ��!");
			return;
		}
		//---20190109 YuanLin ������ֻ��ѡ��������д
		var ANCCTIComOrdNum=obj.ANCCTIComOrdStore.data.items.length;
		var ANCCTIComOrdItems=obj.ANCCTIComOrdStore.data.items;
		if(ANCCTIComOrdDr!="")
		{
			if(ANCCTIComOrdNum!=0)
			{
				for (var i = 0; i < ANCCTIComOrdNum; i++)
				{
					if (ANCCTIComOrdDr == ANCCTIComOrdItems[i].data.MDIRowid)
					{
						ANCCTIComOrdFlag = true;
						break;
					}
				}
				if(!ANCCTIComOrdFlag)
				{
					ExtTool.alert("��ʾ","�໤��Ŀ�������������ѡ��!");
					return ;
				}
			}
			if(ANCCTIComOrdNum==0)
			{
				ExtTool.alert("��ʾ","�໤��Ŀ�������������ѡ��!");
				return ;
			}
		}
		else
		{
			var ANCCTIComOrdRaw=obj.ANCCTIComOrd.getRawValue();
			if(ANCCTIComOrdRaw!="")
			{
				ExtTool.alert("��ʾ","�໤��Ŀ�������������ѡ��!");
				return ;
			}
		}
		//alert(Rowid+"^"+Code+"^"+ANCCTIChannelNo+"^"+ANCCTActive+"^"+ANCCTIParref+"^"+ANCCTIComOrdDr)
		
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
				 
				ReloadItemPanelStore();
	  	  	});
		}
		else
		{
			Ext.Msg.alert("��ʾ","����ʧ��:"+ret);
			return;
		}
	};
	
	function ReloadItemPanelStore()
	{
		var ANCCTSource=obj.ANCCTSource.getValue();
		obj.retGridItemPanel.getSelectionModel().clearSelections();//�������ѡ��
				
	  	obj.retGridItemPanelStore.load({}); 
		/*var ANCCTSource=obj.ANCCTSource.getValue();
		if(ANCCTSource=="I")
		{
			obj.ANCCTIComOrdStoreProxy.on('beforeload', function(objProxy, param){
				param.ClassName = 'web.DHCICUBedEquip';
				param.QueryName = 'FindMoniDataItem';
				param.Arg1 = obj.ANCCTIComOrd.getRawValue();
				param.ArgCnt = 1;
			});
			obj.ANCCTIComOrdStore.load({});
		}
		else
		{
			obj.ANCCTIComOrdStoreProxy.on('beforeload', function(objProxy, param){
				param.ClassName = 'web.DHCANCCollectType';
				param.QueryName = 'FindMoniDataItem';
				param.Arg1 = obj.ANCCTIComOrd.getRawValue();
				param.ArgCnt = 1;
			});
			obj.ANCCTIComOrdStore.load({});
		}
		
		obj.retGridItemPanel.getSelectionModel().clearSelections();//�������ѡ��
		obj.retGridItemPanelStore.removeAll();
	  	obj.retGridItemPanelStore.load({}); 
		*/
	}
}