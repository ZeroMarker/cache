function InitViewScreenEvent(obj)
{
	var _DHCICUCode=ExtTool.StaticServerObject('web.DHCICUCode');
	
	obj.LoadEvent = function(args)
	{
		//ȡĬ��ҩƷ����ҽ��
		var ret=_DHCICUCode.GetOrdDefault();
		var OrdDefaultStr=ret.split("@");
		//alert(ret);
		if(OrdDefaultStr)
		{
			obj.defaultOrd.setRawValue(OrdDefaultStr[1]);
			obj.defaultOrd.setValue(OrdDefaultStr[0]);
		}
	};
	
	
	//����Ĭ��ҩƷ����ҽ��
	obj.saveDefaultOrdButton_click = function()
	{
		var OrdDefaultId=obj.defaultOrd.getValue();
		var ret=_DHCICUCode.SaveDefaultOrdData(OrdDefaultId);
		if(ret=="0")
		{
			Ext.Msg.alert("��ʾ","����ɹ�!");
		}
		else
		{
			Ext.Msg.alert("��ʾ","����ʧ��!");
		}
	}
	
	//"���>>"��ť
	obj.AddOrdInstrucButton_click = function()
	{
		var rcs = obj.dphcin.getSelectionModel().getSelections();
		var len=rcs.length;
		if(len>0)
		{
			for(var i=0; i< len; i++)
			{
				var phcinrowid=rcs[i].get("phcinrowid");
				var phcinDesc=rcs[i].get("phcinDesc");
				if(isExist(phcinrowid))
				{
					continue;
				}
				var flag=""
				var flag=SaveUnUsePhcin(phcinrowid);
				if(flag==0)
				{
					var rec = new (obj.unUsePhcinDescStore.recordType)();
					rec.set('unusephcinid',phcinrowid);
					rec.set('unusephcindesc',phcinDesc);
					obj.unUsePhcinDescStore.add(rec);
				}
			}
		}
		else
		{
			Ext.Msg.alert("��ʾ","����������ҩ;����ѡ��һ��");
		}
	}
	
	//�ж�Ҫ��ӵ���ҩ;���Ƿ��ڲ���������ҽ���д���
	function isExist(phcinrowid)
	{
		for(var i=0; i<obj.unUsePhcinDescStore.getCount(); i++)
		{
			var unusephcinid=obj.unUsePhcinDescStore.getAt(i).get("unusephcinid");
			if(phcinrowid==unusephcinid)
			{
				return true;
			}
		}
		return false;
	}
	
	//"�Ƴ�<<"��ť
	obj.DelOrdInstrucButton_click=function()
	{
		var rcs = obj.unUsePhcinDesc.getSelectionModel().getSelections();
		var len=rcs.length;
		
		if(len>0)
		{
			for(var i=0;i<len;i++)
			{
				obj.unUsePhcinDescStore.remove(rcs[i]);
				SaveUnUsePhcin("");
			}
		}
		else
		{
			Ext.Msg.alert("��ʾ","�������ڲ���������ҽ������ҩ;����ѡ��һ��");
		}
	}
	
	//���治��������ҽ������ҩ;��
	function SaveUnUsePhcin(PHCINIdStr)
	{
		//var PHCINIdStr="";
		for(var i=0; i<obj.unUsePhcinDescStore.getCount(); i++)
		{
			var unusephcinid=obj.unUsePhcinDescStore.getAt(i).get("unusephcinid");
			if(PHCINIdStr=="")
			{
				PHCINIdStr=unusephcinid;
			}
			else
			{
				PHCINIdStr=PHCINIdStr+"^"+unusephcinid;
			}
		}
		var ret=_DHCICUCode.SaveUnusePhcin(PHCINIdStr);
		//alert(PHCINIdStr+"/"+ret)
		if(ret!="0")
		{
			Ext.Msg.alert("��ʾ","���治��������ҽ������ҩ;��ʧ��!");
			return 1;
		}
		else
		{
			return 0;
		}
		
	}
	
	obj.saveButton_click=function()
	{
		var ancorowid=obj.dancoDesc.getValue();
		var phcinrowidStr="";
		var rcs = obj.dphcin.getSelectionModel().getSelections();
		var len=rcs.length;
		if(len==0)
		{
			alert("��ѡ����ҩ;��");
			return;
		}
		for(var i=0; i< rcs.length; i++)
		{
			var phcinrowid=rcs[i].get("phcinrowid");
			if(phcinrowidStr=="")
			{
				phcinrowidStr=phcinrowid;
			}
			else
			{
				phcinrowidStr=phcinrowidStr+"^"+phcinrowid;
			}
		}
		//alert("ancorowid:"+ancorowid);
		//alert("phcinrowidStr:"+phcinrowidStr);
		if(ancorowid=="")
		{
			Ext.Msg.alert("��ʾ","����ҩƷҽ������Ϊ��");
			return;
		}
		var ret=_DHCICUCode.SaveOrdPhcinData(ancorowid,phcinrowidStr);
		if(ret=="0")
		{
			Ext.Msg.alert("��ʾ","����ɹ�");
			obj.dancoDesc.setValue("");
      		//obj.dphcinID.SetValue("");
      		obj.dphcinStore.removeAll();
      		obj.dphcinStore.load({});
			obj.retGridPanelStore.load({});
		}
		else
		{
			Ext.Msg.alert("��ʾ","����ʧ��:"+ret);
		}
	}
	
	obj.deleteButton_click=function()
	{
		var dancoRowid=obj.dancoDesc.getValue();
		if(dancoRowid!="")
		{
			//alert(dancoRowid);
			//return;
			var ret=_DHCICUCode.DelOrdPhcinData(dancoRowid);
			if(ret=="0")
			{
				Ext.Msg.alert("��ʾ","ɾ���ɹ�");
				obj.dancoDesc.setValue("");
				obj.dphcinStore.removeAll();
      			obj.dphcinStore.load({});
				obj.retGridPanelStore.load({});
			}
			else
			{
				Ext.Msg.alert("��ʾ","ɾ��ʧ��:"+ret);
			}
		}
		else
		{
			Ext.Msg.alert("��ʾ","����ҩƷҽ������Ϊ��!");
		}
	}
	
	obj.findButton_click=function()
	{
		obj.retGridPanelStore.load({});
	}
	
	obj.retGridPanel_rowclick=function()
	{
		var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  	if (rc)
	  	{
		  	obj.dancoDesc.setValue(rc.get("dancoRowid"));
		  	obj.dancoDesc.setRawValue(rc.get("dancoDesc"));
		  	
		  	obj.dphcin.getSelectionModel().clearSelections();//�������ѡ��
		  	
		  	var phcinrowidStr=rc.get("dphcinRowid");
		  	var phcinrowidArray=phcinrowidStr.split("^");
		  	var firstSelectRowIndex=-1;
		  	var rowIndex=0;
		  	for(var i=0; i<obj.dphcinStore.getCount(); i++)
		  	{
			  	var dphcinid=obj.dphcinStore.getAt(i).get("phcinrowid");
			  	for(var j=0; j<phcinrowidArray.length; j++)
			  	{
				  	if(dphcinid==phcinrowidArray[j])
				  	{
					  	obj.dphcin.getSelectionModel().selectRow(rowIndex, true);
					  	//��һ��ѡ�е���
					  	if(firstSelectRowIndex==-1)
					  	{
						  	firstSelectRowIndex=rowIndex;
						}
					}
				  	
				}
				rowIndex++;
			}
			//�۽�����һ��ѡ�е���
			if(firstSelectRowIndex>=0)
			{
			  	obj.dphcin.getView().focusRow(firstSelectRowIndex);
			}
	  	}
	}
}