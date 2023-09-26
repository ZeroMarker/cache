function InitViewScreenEvent(obj)
{
	var _DHCICUCommonOrdMapping=ExtTool.StaticServerObject('web.DHCICUCommonOrdMapping');
	var curRow="",lastRow=""
	obj.retGridPanel_rowclick=function()
	{
		var rc = obj.retGridPanel.getSelectionModel().getSelected();
	    if (rc)
	    {
		    obj.ViewSuperCat.setValue(rc.get("tViewSuperCatIDT"));
		    obj.ViewSuperCat.setRawValue(rc.get("tViewSuperCatDescT"));
		    obj.ViewCat.setValue(rc.get("tViewCatIDT"));
		    obj.ViewCat.setRawValue(rc.get("tViewCatDescT"));
		    
		    obj.Arcim.setValue(rc.get("tArcimIDT"));
		    obj.Arcim.setRawValue(rc.get("tArcimDescT"));
		    obj.OeoriNote.setValue(rc.get("tOeoriNoteT"));
		    
		    obj.Anco.setValue(rc.get("tAncoId"));
		    obj.Anco.setRawValue(rc.get("tAncoDesc"));
		    obj.SpeedUnit.setValue(rc.get("tSpeedUnitId"));
		    obj.SpeedUnit.setRawValue(rc.get("tSpeedUnitDesc"));
		    obj.Uom.setValue(rc.get("tUomId"));
		    obj.Uom.setRawValue(rc.get("tUomDesc"));
		    
		    obj.PrepareVolume.setValue(rc.get("tPrepareVolume"));
		    obj.Abbreviate.setValue(rc.get("tAbbreviate"));
		    obj.Qty.setValue(rc.get("tQty"));
		    
		    obj.DefSpeed.setValue(rc.get("tDefSpeed"));
		    obj.Density.setValue(rc.get("tDensity"));
		    obj.Dept.setValue(rc.get("tDeptId"));
		    obj.Dept.setRawValue(rc.get("tDeptDesc"));
		    
		}
	};
	obj.retGridPanel_rowdblclick=function()
	{
		obj.ViewSuperCat.setValue("");
		    obj.ViewSuperCat.setRawValue("");
		    obj.ViewCat.setValue("");
		    obj.ViewCat.setRawValue("");
		    obj.Arcim.setValue("");
		    obj.Arcim.setRawValue("");
		    obj.OeoriNote.setValue("");
		    
		    obj.Anco.setValue("");
		    obj.Anco.setRawValue("");
		    obj.SpeedUnit.setValue("");
		    obj.SpeedUnit.setRawValue("");
		    obj.Uom.setValue("");
		    obj.Uom.setRawValue("");
		    
		    obj.PrepareVolume.setValue("");
		    obj.Abbreviate.setValue("");
		    obj.Qty.setValue("");
		    
		    obj.DefSpeed.setValue("");
		    obj.Density.setValue("");
		    obj.Dept.setValue("");
		    obj.Dept.setRawValue("");
		
		
	}
	obj.findButton_click=function()
	{
		//20160913+dyl
		obj.retGridPanelStore.removeAll();
		//alert(obj.ViewSuperCat.getValue()+"/"+obj.ViewCat.getValue()+"/"+obj.Arcim.getValue()+"/"+obj.OeoriNote.getValue())
		obj.retGridPanelStore.reload({});
		obj.ViewSuperCat.setValue("");
		    obj.ViewSuperCat.setRawValue("");
		    obj.ViewCat.setValue("");
		    obj.ViewCat.setRawValue("");
		    obj.Arcim.setValue("");
		    obj.Arcim.setRawValue("");
		    obj.OeoriNote.setValue("");
		    
		    obj.Anco.setValue("");
		    obj.Anco.setRawValue("");
		    obj.SpeedUnit.setValue("");
		    obj.SpeedUnit.setRawValue("");
		    obj.Uom.setValue("");
		    obj.Uom.setRawValue("");
		    
		    obj.PrepareVolume.setValue("");
		    obj.Abbreviate.setValue("");
		    obj.Qty.setValue("");
		    
		    obj.DefSpeed.setValue("");
		    obj.Density.setValue("");
		    obj.Dept.setValue("");
		    obj.Dept.setRawValue("");
		
		
	}
	obj.addButton_click=function()
	{
		var ViewCatFlag=false;
		var ArcimFlag=false;
		var AncoFlag=false;
		var UomFlag=false;
		var viewSuperCat = obj.ViewSuperCat.getValue();
		if(viewSuperCat=="")
		{
			Ext.Msg.alert("��ʾ","ҽ�����಻��Ϊ��");
			return;
		}
		
		var viewCat = obj.ViewCat.getValue();
		var arcim=obj.Arcim.getValue();
		var speedUnit=obj.SpeedUnit.getValue();
		var anco=obj.Anco.getValue();
		if((anco=="")&&(viewSuperCat!=""))
		{
			Ext.Msg.alert("��ʾ","����ҽ������Ϊ��");
			return;
		}
		var oeoriNote=obj.OeoriNote.getValue();
		if ((viewCat=="")&&(arcim!=""))
		{
			Ext.Msg.alert("��ʾ","����ѡ��ҽ��������ѡ��ҽ����");
			return;
		}
		if (((viewCat=="")||(arcim==""))&&(oeoriNote!=""))
		{
			Ext.Msg.alert("��ʾ","����ѡ��ҽ��������ѡ��ҽ��������дҽ����ע");
			return;
		}
		if (((viewCat=="")||(arcim==""))&&(speedUnit!=""))
		{
			Ext.Msg.alert("��ʾ","����ѡ��ҽ��������ѡ��ҽ��������д�ٶ�");
			return;
		}
		var uom=obj.Uom.getValue();
		var density=obj.Density.getValue();
		var qty=obj.Qty.getValue();
		var prepareVolume=obj.PrepareVolume.getValue();
		var abbreviate=obj.Abbreviate.getValue();
		var defSpeed=obj.DefSpeed.getValue();
		var deptId=obj.Dept.getValue();
		
		//---20190109 YuanLin ������ֻ��ѡ��������д
		//ҽ������
		var ViewCatNum=obj.ViewCatStore.data.items.length;
		var ViewCatItems=obj.ViewCatStore.data.items;
		if(viewCat!="")
		{
			if(ViewCatNum!=0)
			{
				for (var i = 0; i < ViewCatNum; i++)
				{
					if (viewCat == ViewCatItems[i].data.RowId)
					{
						ViewCatFlag = true;
						break;
					}
				}
				if(!ViewCatFlag)
				{
					ExtTool.alert("��ʾ","ҽ���������������ѡ��!");
					return ;
				}
			}
			if(ViewCatNum==0)
			{
				ExtTool.alert("��ʾ","ҽ���������������ѡ��!");
				return ;
			}
		}
		else
		{
			var ViewCatRaw=obj.ViewCat.getRawValue();
			if(ViewCatRaw!="")
			{
				ExtTool.alert("��ʾ","ҽ���������������ѡ��!");
				return ;
			}
		}
		//ҽ����
		var ArcimNum=obj.ArcimStore.data.items.length;
		var ArcimItems=obj.ArcimStore.data.items;
		if(arcim!="")
		{
			if(ArcimNum!=0)
			{
				for (var i = 0; i < ArcimNum; i++)
				{
					if (arcim == ArcimItems[i].data.ARCIMastRowID)
					{
						ArcimFlag = true;
						break;
					}
				}
				if(!ArcimFlag)
				{
					ExtTool.alert("��ʾ","ҽ�������������ѡ��!");
					return ;
				}
			}
			if(ArcimNum==0)
			{
				ExtTool.alert("��ʾ","ҽ�������������ѡ��!");
				return ;
			}
		}
		else
		{
			var ArcimRaw=obj.Arcim.getRawValue();
			if(ArcimRaw!="")
			{
				ExtTool.alert("��ʾ","ҽ�������������ѡ��!");
				return ;
			}
		}
		//����ҽ��
		var AncoNum=obj.AncoStore.data.items.length;
		var AncoItems=obj.AncoStore.data.items;
		if(anco!="")
		{
			if(AncoNum!=0)
			{
				for (var i = 0; i < AncoNum; i++)
				{
					if (anco == AncoItems[i].data.rowid)
					{
						AncoFlag = true;
						break;
					}
				}
				if(!AncoFlag)
				{
					ExtTool.alert("��ʾ","����ҽ�����������ѡ��!");
					return ;
				}
			}
			if(AncoNum==0)
			{
				ExtTool.alert("��ʾ","����ҽ�����������ѡ��!");
				return ;
			}
		}
		else
		{
			var AncoRaw=obj.Anco.getRawValue();
			if(AncoRaw!="")
			{
				ExtTool.alert("��ʾ","����ҽ�����������ѡ��!");
				return ;
			}
		}
		//��λ
		var UomNum=obj.UomStore.data.items.length;
		var UomItems=obj.UomStore.data.items;
		if(uom!="")
		{
			if(UomNum!=0)
			{
				for (var i = 0; i < UomNum; i++)
				{
					if (uom == UomItems[i].data.ANCSURowId)
					{
						UomFlag = true;
						break;
					}
				}
				if(!UomFlag)
				{
					ExtTool.alert("��ʾ","��λ���������ѡ��!");
					return ;
				}
			}
			if(UomNum==0)
			{
				ExtTool.alert("��ʾ","��λ���������ѡ��!");
				return ;
			}
		}
		else
		{
			var UomRaw=obj.Uom.getRawValue();
			if(UomRaw!="")
			{
				ExtTool.alert("��ʾ","��λ���������ѡ��!");
				return ;
			}
		}
		//alert(viewSuperCat+","+viewCat+","+arcim+","+speedUnit+","+anco+","+oeoriNote+","+uom+","+density+","+qty+","+prepareVolume+","+abbreviate+","+defSpeed+","+deptId);
		var ret = _DHCICUCommonOrdMapping.InsertOrdMapping(viewSuperCat,viewCat,arcim,speedUnit,anco,oeoriNote,uom,density,qty,prepareVolume,abbreviate,defSpeed,deptId);
		if(ret=="0")
		{
			Ext.Msg.alert("��ʾ","��ӳɹ�");
			obj.retGridPanelStore.load({});
			obj.ViewSuperCat.setValue("");
		    obj.ViewSuperCat.setRawValue("");
		    obj.ViewCat.setValue("");
		    obj.ViewCat.setRawValue("");
		    obj.Arcim.setValue("");
		    obj.Arcim.setRawValue("");
		    obj.OeoriNote.setValue("");
		    
		    obj.Anco.setValue("");
		    obj.Anco.setRawValue("");
		    obj.SpeedUnit.setValue("");
		    obj.SpeedUnit.setRawValue("");
		    obj.Uom.setValue("");
		    obj.Uom.setRawValue("");
		    
		    obj.PrepareVolume.setValue("");
		    obj.Abbreviate.setValue("");
		    obj.Qty.setValue("");
		    
		    obj.DefSpeed.setValue("");
		    obj.Density.setValue("");
		    obj.Dept.setValue("");
		    obj.Dept.setRawValue("");
		}
		else
		{
			Ext.Msg.alert("��ʾ","���ʧ��:"+ret);
		}
	};
	
	obj.deleteButton_click=function()
	{
		var viewSuperCat = obj.ViewSuperCat.getValue();
		if(viewSuperCat=="")
		{
			Ext.Msg.alert("��ʾ","ҽ�����಻��Ϊ��");
			return;
		}
		var viewCat = obj.ViewCat.getValue();
		var arcim=obj.Arcim.getValue();
		var oeoriNote=obj.OeoriNote.getValue();
		var closeWindow = confirm("�Ƿ�ȷ��ɾ��?")
		if(!closeWindow)
		{
			window.close()
		}
		else
		{
		var ret = _DHCICUCommonOrdMapping.DeleteOrdMapping(viewSuperCat,viewCat,arcim,oeoriNote);
		if(ret=="0")
		{
			Ext.Msg.alert("��ʾ","ɾ���ɹ�");
			//obj.retGridPanelStore.load({});
			
			obj.ViewSuperCat.setValue("");
		    obj.ViewSuperCat.setRawValue("");
		    obj.ViewCat.setValue("");
		    obj.ViewCat.setRawValue("");
		    obj.Arcim.setValue("");
		    obj.Arcim.setRawValue("");
		    obj.OeoriNote.setValue("");
		    
		    obj.Anco.setValue("");
		    obj.Anco.setRawValue("");
		    obj.SpeedUnit.setValue("");
		    obj.SpeedUnit.setRawValue("");
		    obj.Uom.setValue("");
		    obj.Uom.setRawValue("");
		    
		    obj.PrepareVolume.setValue("");
		    obj.Abbreviate.setValue("");
		    obj.Qty.setValue("");
		    
		    obj.DefSpeed.setValue("");
		    obj.Density.setValue("");
		    obj.Dept.setValue("");
		    obj.Dept.setRawValue("");
		    obj.retGridPanelStore.load({});
		}
		else
		{
			Ext.Msg.alert("��ʾ","ɾ��ʧ��:"+ret);
		}
	}
	};
	
	obj.saveButton_click=function()
	{
		var ViewCatFlag=false;
		var ArcimFlag=false;
		var AncoFlag=false;
		var UomFlag=false;
		var viewSuperCat = obj.ViewSuperCat.getValue();
		if(viewSuperCat=="")
		{
			Ext.Msg.alert("��ʾ","ҽ�����಻��Ϊ��");
			return;
		}
		
		var viewCat = obj.ViewCat.getValue();
		var arcim=obj.Arcim.getValue();
		var speedUnit=obj.SpeedUnit.getValue();
		var anco=obj.Anco.getValue();
		if((anco=="")&&(viewSuperCat!=""))
		{
			Ext.Msg.alert("��ʾ","����ҽ������Ϊ��");
			return;
		}
		var oeoriNote=obj.OeoriNote.getValue();
		var uom=obj.Uom.getValue();
		var density=obj.Density.getValue();
		var qty=obj.Qty.getValue();
		var prepareVolume=obj.PrepareVolume.getValue();
		var abbreviate=obj.Abbreviate.getValue();
		var defSpeed=obj.DefSpeed.getValue();
		var deptId=obj.Dept.getValue();
		//---20190109 YuanLin ������ֻ��ѡ��������д
		//ҽ������
		var ViewCatNum=obj.ViewCatStore.data.items.length;
		var ViewCatItems=obj.ViewCatStore.data.items;
		if(viewCat!="")
		{
			if(ViewCatNum!=0)
			{
				for (var i = 0; i < ViewCatNum; i++)
				{
					if (viewCat == ViewCatItems[i].data.RowId)
					{
						ViewCatFlag = true;
						break;
					}
				}
				if(!ViewCatFlag)
				{
					ExtTool.alert("��ʾ","ҽ���������������ѡ��!");
					return ;
				}
			}
			if(ViewCatNum==0)
			{
				ExtTool.alert("��ʾ","ҽ���������������ѡ��!");
				return ;
			}
		}
		else
		{
			var ViewCatRaw=obj.ViewCat.getRawValue();
			if(ViewCatRaw!="")
			{
				ExtTool.alert("��ʾ","ҽ���������������ѡ��!");
				return ;
			}
		}
		//ҽ����
		var ArcimNum=obj.ArcimStore.data.items.length;
		var ArcimItems=obj.ArcimStore.data.items;
		if(arcim!="")
		{
			if(ArcimNum!=0)
			{
				for (var i = 0; i < ArcimNum; i++)
				{
					if (arcim == ArcimItems[i].data.ARCIMastRowID)
					{
						ArcimFlag = true;
						break;
					}
				}
				if(!ArcimFlag)
				{
					ExtTool.alert("��ʾ","ҽ�������������ѡ��!");
					return ;
				}
			}
			if(ArcimNum==0)
			{
				ExtTool.alert("��ʾ","ҽ�������������ѡ��!");
				return ;
			}
		}
		else
		{
			var ArcimRaw=obj.Arcim.getRawValue();
			if(ArcimRaw!="")
			{
				ExtTool.alert("��ʾ","ҽ�������������ѡ��!");
				return ;
			}
		}
		//����ҽ��
		var AncoNum=obj.AncoStore.data.items.length;
		var AncoItems=obj.AncoStore.data.items;
		if(anco!="")
		{
			if(AncoNum!=0)
			{
				for (var i = 0; i < AncoNum; i++)
				{
					if (anco == AncoItems[i].data.rowid)
					{
						AncoFlag = true;
						break;
					}
				}
				if(!AncoFlag)
				{
					ExtTool.alert("��ʾ","����ҽ�����������ѡ��!");
					return ;
				}
			}
			if(AncoNum==0)
			{
				ExtTool.alert("��ʾ","����ҽ�����������ѡ��!");
				return ;
			}
		}
		else
		{
			var AncoRaw=obj.Anco.getRawValue();
			if(AncoRaw!="")
			{
				ExtTool.alert("��ʾ","����ҽ�����������ѡ��!");
				return ;
			}
		}
		//��λ
		var UomNum=obj.UomStore.data.items.length;
		var UomItems=obj.UomStore.data.items;
		if(uom!="")
		{
			if(UomNum!=0)
			{
				for (var i = 0; i < UomNum; i++)
				{
					if (uom == UomItems[i].data.ANCSURowId)
					{
						UomFlag = true;
						break;
					}
				}
				if(!UomFlag)
				{
					ExtTool.alert("��ʾ","��λ���������ѡ��!");
					return ;
				}
			}
			if(UomNum==0)
			{
				ExtTool.alert("��ʾ","��λ���������ѡ��!");
				return ;
			}
		}
		else
		{
			var UomRaw=obj.Uom.getRawValue();
			if(UomRaw!="")
			{
				ExtTool.alert("��ʾ","��λ���������ѡ��!");
				return ;
			}
		}
		if ((viewCat=="")&&(arcim!=""))
		{
			Ext.Msg.alert("��ʾ","����ѡ��ҽ��������ѡ��ҽ����");
			return;
		}
		if (((viewCat=="")||(arcim==""))&&(oeoriNote!=""))
		{
			Ext.Msg.alert("��ʾ","����ѡ��ҽ��������ѡ��ҽ��������дҽ����ע");
			return;
		}
		if (((viewCat=="")||(arcim==""))&&(speedUnit!=""))
		{
			Ext.Msg.alert("��ʾ","����ѡ��ҽ��������ѡ��ҽ��������д�ٶ�");
			return;
		}
		var rc = obj.retGridPanel.getSelectionModel().getSelected();
	    if (rc)
	    {
		    var PreViewSuperCatDr=rc.get("tViewSuperCatIDT");
		    var PreViewCatDr=rc.get("tViewCatIDT");
		    var PreArcimDr=rc.get("tArcimIDT");
		    var PreOeoriNote=rc.get("tOeoriNoteT");
		}
		var ret = _DHCICUCommonOrdMapping.UpdateOrdMapping(viewSuperCat,viewCat,arcim,speedUnit,anco,oeoriNote,uom,density,qty,prepareVolume,abbreviate,defSpeed,deptId,PreViewSuperCatDr,PreViewCatDr,PreArcimDr,PreOeoriNote);
		if(ret=="0")
		{
			Ext.Msg.alert("��ʾ","����ɹ�");
			obj.retGridPanelStore.load({});
			obj.ViewSuperCat.setValue("");
		    obj.ViewSuperCat.setRawValue("");
		    obj.ViewCat.setValue("");
		    obj.ViewCat.setRawValue("");
		    obj.Arcim.setValue("");
		    obj.Arcim.setRawValue("");
		    obj.OeoriNote.setValue("");
		    
		    obj.Anco.setValue("");
		    obj.Anco.setRawValue("");
		    obj.SpeedUnit.setValue("");
		    obj.SpeedUnit.setRawValue("");
		    obj.Uom.setValue("");
		    obj.Uom.setRawValue("");
		    
		    obj.PrepareVolume.setValue("");
		    obj.Abbreviate.setValue("");
		    obj.Qty.setValue("");
		    
		    obj.DefSpeed.setValue("");
		    obj.Density.setValue("");
		    obj.Dept.setValue("");
		    obj.Dept.setRawValue("");
		}
		else
		{
			Ext.Msg.alert("��ʾ","����ʧ��:"+ret);
		}
	};
}