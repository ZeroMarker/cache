function InitViewportEvent(obj) {
	objEditorPanel = obj;
	obj.LoadEvent = function()
  	{
  	};
	obj.IDList_rowclick = function()
	{
		var rowIndex = arguments[1];
		var objRec = obj.IDListStore.getAt(rowIndex);
		if(objRec.get("rowid")==obj.IDRowid.getValue())
		{
			obj.IDRowid.setValue("");
			obj.IDCode.setValue("");
			obj.IDDesc.setValue("");
			obj.IDSubCatDr.setValue("");
			//obj.IDExpression.setValue("");
			document.getElementById("txtExpression").Text="";
			obj.IDRange.setValue("");
			obj.IDResume.setValue("");
			obj.IDSubCatDrStore.load();
			return;
		}
			obj.IDSubCatDrStore.load();
			obj.IDRowid.setValue(objRec.get("rowid"));
			obj.IDCode.setValue(objRec.get("IDCode"));
			obj.IDDesc.setValue(objRec.get("IDDesc"));
			//obj.IDSubCatDr.setValue(objRec.get("IDSubCatDr"));
			ExtTool.AddComboItem(obj.IDSubCatDr,objRec.get("CDDesc"),objRec.get("IDSubCatDr"));
			//obj.IDExpression.setValue(objRec.get("IDExpression"));
			document.getElementById("txtExpression").Text=objRec.get("IDExpression");
			obj.IDRange.setValue(objRec.get("IDRange"));
			obj.IDResume.setValue(objRec.get("IDResume"));
	};
	obj.btnFind_click = function()
	{
		obj.IDListStore.load({ params : { start:0 , limit:20 }});
	};
	obj.btnAdd_click = function()		// ��Ӽ����Ŀ
	{
		if(ValidateData(obj.IDCode,"���벻��Ϊ��!")==-1) return;
		if(ValidateData(obj.IDDesc,"��������Ϊ��!")==-1) return;
		if(ValidateData(obj.IDSubCatDr,"�ӷ��಻��Ϊ��!")==-1) return;
		if(document.getElementById("txtExpression").Text=="")
		{
			ExtTool.alert("��ʾ","���ʽ����Ϊ��!");
			return;
			
		}
		var objID = ExtTool.StaticServerObject("DHCMed.CC.ItemDic");
		var tmp = obj.IDRowid.getValue();
		tmp += "^"+obj.IDCode.getValue();
		tmp += "^"+obj.IDDesc.getValue();
		tmp += "^"+obj.IDSubCatDr.getValue();
		tmp += "^"+document.getElementById("txtExpression").Text; //obj.IDExpression.getValue();
		tmp += "^"+obj.IDRange.getValue();
		tmp += "^"+"";    //obj.IDResume.getValue();
		
		var ret=objID.Update(tmp);
		if(ret>0) 
		{
			obj.IDRowid.setValue();
			obj.IDCode.setValue();
			obj.IDDesc.setValue();
			obj.IDSubCatDr.setValue();
			//obj.IDExpression.setValue();
			obj.IDSubCatDrStore.load();
			document.getElementById("txtExpression").Text="";
			obj.IDRange.setValue();
			obj.IDResume.setValue();
			obj.IDListStore.load({params : {start:0,limit:20}});
		}
		else ExtTool.alert("��ʾ","����ʧ��!");
	};
	obj.btnEdit_click = function()
	{
	//���ڴ������¼��������
	//�����Ҫ��ȡ����������ʹ��var myArg = arguments[i]��ʽ 
	};
	obj.btnDelete_click = function()
	{
		var cIDRowid=obj.IDRowid.getValue();
	 	if(cIDRowid=="")
	 	{
	 		ExtTool.alert("��ʾ","����ѡ��һ�У�");
	 		return;
	 	}
		ExtTool.confirm('ѡ���','ȷ��ɾ��?',function(btn){
            if(btn=="no") return;
                	
            var objID = ExtTool.StaticServerObject("DHCMed.CC.ItemDic");
			var ret = objID.DeleteById(cIDRowid);
			if(ret==0)
				{
					obj.IDRowid.setValue("");
					obj.IDCode.setValue("");
					obj.IDDesc.setValue("");
					obj.IDSubCatDr.setValue("");
					//obj.IDExpression.setValue("");
					document.getElementById("txtExpression").Text="";
					obj.IDRange.setValue("");
					obj.IDResume.setValue("");
					obj.IDListStore.load({ params : { start:0 , limit:20 }});
				
					return;
				}
	 		if(ret<0)
	 			{
	 				ExtTool.alert("��ʾ","ɾ��ʧ��!");
	 				return;	
	 			}
           	});
	};

	obj.OEBtnFind_click = function()
	{
		obj.ARCIMListStore.load();
	};
	/*
	obj.OEBtnUpdate_click = function()
	{
		var rowid="";
		if(obj.nIDSubCatDr.getValue()=="")
		{
			ExtTool.alert("��ʾ","��Ŀ���಻��Ϊ��!");
			return;	
		}
		for(var i = 0; i < obj.ARCIMListStore.getCount(); i ++)  //����ҽ���б�
    	{
    		objData = obj.ARCIMListStore.getAt(i);
    		if(objData.get('checked')) 
    		{
    			if(rowid=="") rowid=objData.get('ArcimID')+"/"+objData.get('ArcimDesc');
    			else rowid=rowid+"^"+objData.get('ArcimID')+"/"+objData.get('ArcimDesc');
    		}
    	}
    	AddDataToItemDic(obj,rowid,"OE");	//�������Ŀ�ֵ�  DHCMed.CC.ItemDic ���������
	};
	*/
	obj.OEDesc_change = function()
	{
		obj.ARCIMListStore.load();
	};
	obj.DBtnFind_click = function()
	{
		obj.MRCICDDxListStore.load();
	};
	
	/*
	obj.DBtnUpdate_click = function()
	{
		var rowid="";
		if(obj.MRCIDSubCatDr.getValue()=="")
		{
			ExtTool.alert("��ʾ","��Ŀ���಻��Ϊ��!");
			return;	
		}
		for(var i = 0; i < obj.MRCICDDxListStore.getCount(); i ++)  //��������б�
    	{
    		objData = obj.MRCICDDxListStore.getAt(i);
    		if(objData.get('checked')) 
    		{
    			if(rowid=="") rowid=objData.get('MRCID')+"/"+objData.get('Descs');
    			else rowid=rowid+"^"+objData.get('MRCID')+"/"+objData.get('Descs');
    		}
    	}
    	MRCAddDataToItemDic(obj,rowid,"D");	//�������Ŀ�ֵ�  DHCMed.CC.ItemDic ���������
	};
	*/
	obj.CDicList_rowclick = function()
	{
		var rowIndex = arguments[1];
		var objRec = obj.CDicListStore.getAt(rowIndex);
		if(objRec.get("rowid")==obj.CDRowid.getValue())
		{
			obj.CDRowid.setValue("");
			obj.CDCode.setValue("");
			obj.CDDesc.setValue("");
			obj.CDType.setValue("");
			//obj.CDExpression.setValue("");
			document.getElementById("txtExpression").Text="";
			obj.CDResume.setValue("");
			
			return;
		}
			obj.CDRowid.setValue(objRec.get("rowid"));
			obj.CDCode.setValue(objRec.get("CDCode"));
			obj.CDDesc.setValue(objRec.get("CDDesc"));
			obj.CDType.setValue(objRec.get("CDType"));
			//obj.CDExpression.setValue(objRec.get("CDExpression"));
			document.getElementById("txtExpression").Text=objRec.get("IDExpression");
			obj.CDResume.setValue(objRec.get("CDResume"));
	};
	obj.CDBtnFind_click = function()
	{
		obj.CDicListStore.load({ params : { start:0 , limit:20 }});
	};
	obj.CDUpdate_click = function()
	{
		if(ValidateData(obj.CDCode,"���벻��Ϊ��!")==-1) return;
		if(ValidateData(obj.CDDesc,"��������Ϊ��!")==-1) return;
		if(ValidateData(obj.CDType,"���Ͳ���Ϊ��!")==-1) return;
	
		var objCD = ExtTool.StaticServerObject("DHCMed.CC.ContentDic");
		var tmp = obj.CDRowid.getValue();
		tmp += "^"+obj.CDCode.getValue();
		tmp += "^"+obj.CDDesc.getValue();
		tmp += "^"+obj.CDType.getValue();
		tmp += "^"+document.getElementById("txtExpression").Text; //obj.CDExpression.getValue();
		tmp += "^"+obj.CDResume.getValue();

		var ret=objCD.Update(tmp);
		if(ret>0) 
		{
			obj.CDRowid.setValue("");
			obj.CDCode.setValue("");
			obj.CDDesc.setValue("");
			obj.CDType.setValue("");
			//obj.CDExpression.setValue("");
			document.getElementById("txtExpression").Text="";//objRec.get("IDExpression");
			obj.CDResume.setValue("");
			obj.CDicListStore.load({ params : { start:0 , limit:20 }});
		}
		else ExtTool.alert("��ʾ","����ʧ��!"); 
	};
	obj.CDDelete_click = function()
	{
		var cCDRowid=obj.CDRowid.getValue();
	 	if(cCDRowid=="")
	 	{
	 		ExtTool.alert("��ʾ","����ѡ��һ�У�");
	 		return;
	 	}
		ExtTool.confirm('ѡ���','ȷ��ɾ��?',function(btn){
            if(btn=="no") return;
                	
            var objCD = ExtTool.StaticServerObject("DHCMed.CC.ContentDic");
			var ret = objCD.DeleteById(cCDRowid);
			if(ret==0)
				{	
					obj.CDRowid.setValue("");
					obj.CDCode.setValue("");
					obj.CDDesc.setValue("");
					obj.CDType.setValue("");
					obj.CDExpression.setValue("");
					obj.CDResume.setValue("");
					obj.CDicListStore.load({ params : { start:0 , limit:20 }});
				
					return;
				}
	 		if(ret<0)
	 			{
	 				ExtTool.alert("��ʾ","ɾ��ʧ��!");
	 				return;	
	 			}
           	});
	};
	obj.LabList_rowclick = function()
	{
		var rowIndex = arguments[1];
		var objRec = obj.LabListStore.getAt(rowIndex);
		if(objRec.get("rowid")==obj.LabRowid.getValue())
		{
			obj.LabRowid.setValue("");
			obj.LabCode.setValue("");
			obj.LabDesc.setValue("");
			obj.LabItmExplainStore.removeAll();
			obj.LabResume.setValue("");
			
			obj.LabRoom.setValue("");
			obj.LabItmDesc.setValue("");
			obj.LabOperChar.setValue("");
			obj.LabValue.setValue("");
			return;
		}
			obj.LabRowid.setValue(objRec.get("rowid"));
			obj.LabCode.setValue(objRec.get("CDCode"));
			obj.LabDesc.setValue(objRec.get("CDDesc"));
			obj.LabItmExplainStore.removeAll();
			
			var rec=new Ext.data.Record({		
				checked:true,
				Expresion:objRec.get("CDExpression"),
				HideText:objRec.get("CDDesc")
			});
			obj.LabItmExplainStore.add([rec]);     //��GridPanel���������ʱ����
			obj.LabItmExplainStore.load({ params : { start:0 , limit:20 }});
			obj.LabResume.setValue(objRec.get("CDResume"));
			obj.LabRoom.setValue("");
			obj.LabItmDesc.setValue("");
			obj.LabOperChar.setValue("");
			obj.LabValue.setValue("");
	};
	obj.LabRoom_select = function()
	{
		obj.LabItmDesc.setValue("");
		obj.LabItmDescStore.removeAll();
		obj.LabItmDescStore.load();
	};
	obj.LabItmDesc_select = function()
	{
		obj.LabValue.setValue("");
		obj.LabValueStore.removeAll();
		obj.LabValueStore.load({ params : { start:0 , limit:20 }});
	};
	obj.LabBtnAddItem_click = function()
	{
		if(ValidateData(obj.LabItmDesc,"������Ŀ����Ϊ��!")==-1) return;
		if(ValidateData(obj.LabOperChar,"����������Ϊ��!")==-1) return;
		//if(ValidateData(obj.LabValue,"ֵ����Ϊ��!")==-1) return;
		if(obj.LabValue.getRawValue()=="")
		{
			ExtTool.alert("��ʾ","ֵ����Ϊ��!");
			return;	
		}
		/*
		var rec=new Ext.data.Record({		
			checked:true,
			Expresion:"{" +obj.LabItmDesc.getValue()+"}"+"||"+obj.LabOperChar.getValue()+"||"+obj.LabValue.getValue()+"||",
			HideText:obj.LabItmDesc.getRawValue().split("|")[0]+obj.LabOperChar.getValue()+obj.LabValue.getRawValue()
		});
		*/
		var LabDescValue=obj.LabDesc.getValue();
		obj.LabCode.setValue(obj.LabItmDesc.getValue()+"|"+obj.LabOperChar.getRawValue()+"|"+obj.LabValue.getRawValue());
		
		obj.LabDesc.setValue(obj.LabItmDesc.getRawValue().split("|")[0]+obj.LabOperChar.getRawValue()+obj.LabValue.getRawValue());

		obj.LabItmExplainStore.add([rec]);     //��GridPanel���������ʱ����
		obj.LabItmExplainStore.load({ params : { start:0 , limit:20 }});
	};
	/*
	obj.LabBtnDelItem_click = function()		// ɾ�����ʽ
	{
		var LDesc="";
		var selectObj = obj.LabItmExplain.getSelectionModel().getSelected();
		if (selectObj){
			obj.LabItmExplainStore.remove(selectObj);
			obj.LabItmExplainStore.load({ params : { start:0 , limit:20 }});
			for(var i = 0; i < obj.LabItmExplainStore.getCount(); i ++)  //�������ʽ�б�
    		{
    			objData = obj.LabItmExplainStore.getAt(i);
    			if(LDesc=="") LDesc=objData.get('HideText');
    			else LDesc = LDesc+ " AND " +objData.get('HideText');
    		}
    		obj.LabDesc.setValue(LDesc);
		}
		else{
			ExtTool.alert("��ʾ","����ѡ��һ��!");
		}		
	};
	*/
	obj.LabBtnDelItem_click = function()
	{
		obj.LabRowid.setValue("");
		obj.LabCode.setValue("");
		obj.LabDesc.setValue("");
		obj.LabItmExplainStore.removeAll();
		obj.LabResume.setValue("");
		obj.LabRoom.setValue("");
		obj.LabItmDesc.setValue("");
		obj.LabOperChar.setValue("");
		obj.LabValue.setValue("");
	}
	obj.LabBtnFind_click = function()
	{
		obj.LabListStore.load({ params : { start:0 , limit:20 }});
	};
	
	/*
	obj.LabBtnUpdate_click = function()
	{
		var LabStr="";
		if(ValidateData(obj.LabCode,"���벻��Ϊ��!")==-1) return;
		if(ValidateData(obj.LabDesc,"��������Ϊ��!")==-1) return;

		if(obj.LabItmExplainStore.getCount()==0)
		{
			ExtTool.alert("��ʾ","���ʽ����Ϊ��!");
			return;
		}
		for(var i = 0; i < obj.LabItmExplainStore.getCount(); i ++)  //�������ʽ�б�
    	{
    		objData = obj.LabItmExplainStore.getAt(i);
    		if(LabStr=="") LabStr=objData.get('Expresion');
    		else LabStr+="&"+objData.get('Expresion');
    	}
		
		var objLab = ExtTool.StaticServerObject("DHCMed.CC.ContentDic");
		var tmp = obj.LabRowid.getValue();
		tmp += "^"+obj.LabCode.getValue();
		tmp += "^"+obj.LabDesc.getValue();
		tmp += "^"+"L";	// ����Ϊ����(L)
		tmp += "^"+LabStr;
		tmp += "^"+obj.LabResume.getValue();
		var ret=objLab.Update(tmp);
		if(ret>0) 
		{
			obj.LabRowid.setValue("");
			obj.LabCode.setValue("");
			obj.LabDesc.setValue("");
			obj.LabItmExplainStore.removeAll();
			obj.LabResume.setValue("");
			
			obj.LabRoom.setValue("");
			obj.LabItmDesc.setValue("");
			obj.LabOperChar.setValue("");
			obj.LabValue.setValue("");
			obj.LabListStore.load({ params : { start:0 , limit:20 }});
		}
		else ExtTool.alert("��ʾ","����ʧ��!"); 
	};
	*/
	obj.LabBtnDelete_click = function()
	{
		var cLabRowid=obj.LabRowid.getValue();
		if(cLabRowid=="")
		{
			alert("��ʾ","����ѡ��һ��!");
			return;	
		}
		ExtTool.confirm('ѡ���','ȷ��ɾ��?',function(btn){
            if(btn=="no") return;
                	
            var objLab = ExtTool.StaticServerObject("DHCMed.CC.ContentDic");
			var ret = objLab.DeleteById(cLabRowid);
			if(ret==0)
				{
					obj.LabRowid.setValue("");
					obj.LabCode.setValue("");
					obj.LabDesc.setValue("");
					obj.LabItmExplainStore.removeAll();
					obj.LabResume.setValue("");
					obj.LabRoom.setValue("");
					obj.LabItmDesc.setValue("");
					obj.LabOperChar.setValue("");
					obj.LabValue.setValue("");
					obj.LabListStore.load({ params : { start:0 , limit:20 }});
					return;
				}
	 		if(ret<0)
	 			{
	 				ExtTool.alert("��ʾ","ɾ��ʧ��!");
	 				return;	
	 			}
           	});
		
	};
	obj.tabPanel_tabchange=function()	// �ı����ʱ���¼�������
	{
		obj.CDicListStore.load({ params : { start:0 , limit:20 }});
		obj.LabListStore.load({ params : { start:0 , limit:20 }});
		
	}
		//*******************ҽ��**********************
	obj.ARCIMList_rowclick = function()
	{
		var rc = obj.ARCIMList.getSelectionModel().getSelected();
		var OERowid=rc.get("ArcimID");
		var OEDesc=rc.get("ArcimDesc");
		obj.retInfo="[ҽ��"+"||"+OERowid+"||"+OEDesc+"]";
		ProcessInputHelperEvent(obj.intSelStart, obj.intSelEnd, obj.retInfo);
		obj.LeftFPanel.collapse(true);
		
	}
	//*******************���*************************
	
	obj.MRCICDDxList_rowclick = function()
	{
		var rc = obj.MRCICDDxList.getSelectionModel().getSelected();
		var MRCRowid=rc.get("MRCID")
		var MRCDesc=rc.get("Descs")
		obj.retInfo="[���"+"||"+MRCRowid+"||"+MRCDesc+"]"
		ProcessInputHelperEvent(obj.intSelStart, obj.intSelEnd, obj.retInfo);
		obj.LeftFPanel.collapse(true);
	}
	//********************����************************
	obj.LabBtnUpdate_click = function()
	{	
		var LabExp=obj.LabCode.getValue();
		var LabDesc=obj.LabDesc.getValue();
		obj.retInfo="[����"+"||"+LabExp+"||"+LabDesc+"]";
		ProcessInputHelperEvent(obj.intSelStart, obj.intSelEnd, obj.retInfo);
		obj.LeftFPanel.collapse(true);
	}
	
	obj.intSelStart = 0;
	obj.intSelEnd = 0;
	obj.retInfo = "";
	obj.Interface = function()
	{
		var strType=arguments[0];
		obj.intSelStart = arguments[1];
		obj.intSelEnd = arguments[2];		
		var result = ""
	
		//obj.tabPanel.on('beforetabchange').activate=false;

		switch(strType)
		{
			case "ҽ��" : 
				obj.LeftFPanel.expand(true);
				obj.tabPanel.setActiveTab(0);
				break;
			case "���" :
				obj.LeftFPanel.expand(true);
				obj.tabPanel.setActiveTab(1);
				break;
			case "����" :
				obj.LeftFPanel.expand(true);
				obj.tabPanel.setActiveTab(2);
				break;
			
		}
		//window.alert(strType);
		//window.alert(obj.intSelStart);
		//window.alert(obj.intSelEnd);
	}
}
function ValidateData(tObj,str)
{
	if(tObj.getValue()=="")
	{
		ExtTool.alert("��ʾ",str);
		return -1;
	}
	else return 1;
}
function AddDataToItemDic(obj,rowid,str)
{
	var tmp=rowid.split("^");
	var objContentDicSrv = ExtTool.StaticServerObject("DHCMed.CCService.ContentDicSrv");	
	for(var i = 0; i < tmp.length; i ++)
    	{
    		var retData=objContentDicSrv.IsDataAdd(tmp[i].split("/")[0],str);  //�жϸ�ҽ��(���)�Ƿ������
    		
    		if(retData>0)  
    		{
    			var OERowid=tmp[i].split("/")[0];
    			var ret=window.confirm(tmp[i].split("/")[1]+'�����,ȷ�����ǣ�');
    			if(ret==true) InsertDataToItemDic(retData,OERowid,obj,str);		
    		}
    		else 
    		{
    				InsertDataToItemDic("",tmp[i].split("/")[0],obj,str);
    		}
    	}
}
function InsertDataToItemDic(IDRowid,ArcimRowid,obj,str)
{
	var ret="";
	var objArcim = ExtTool.StaticServerObject("DHCMed.Base.Arcim");
	var objID = ExtTool.StaticServerObject("DHCMed.CCService.ContentDicSrv");
	ret=objArcim.GetStringById(ArcimRowid);
	var tmp = IDRowid;						// rowid
	tmp += "^"+str+ArcimRowid;				// IDCode    "OE"+rowid
	tmp += "^"+ret.split("^")[2];			// IDDesc
	tmp += "^"+obj.nIDSubCatDr.getValue();	// �ӷ���
	tmp += "^"+"{"+str+ArcimRowid+"}";		//���ʽ
	tmp += "^"+"";							// ��Χ
	tmp += "^"+"";							// ��ע
	
	var retData=objID.AddInfoToDic(tmp,"OE");
	if(retData>0) 
		{
			obj.IDRowid.setValue();
			obj.IDCode.setValue();
			obj.IDDesc.setValue();
			obj.IDSubCatDr.setValue();
			obj.IDExpression.setValue();
			obj.IDRange.setValue();
			obj.IDResume.setValue();
			obj.IDListStore.load({ params : { start:0 , limit:20 }});
			obj.CDicListStore.load({ params : { start:0 , limit:20 }});
		}
	else ExtTool.alert("��ʾ","����ʧ��!");
}
function MRCAddDataToItemDic(obj,rowid,str)
{
	var tmp=rowid.split("^");
	var objContentDicSrv = ExtTool.StaticServerObject("DHCMed.CCService.ContentDicSrv");	
	for(var i = 0; i < tmp.length; i ++)
    	{
    		var retData=objContentDicSrv.IsDataAdd(tmp[i].split("/")[0],str);  //�жϸ�ҽ��(���)�Ƿ������
    		
    		if(retData>0)  
    		{
    			var DRowid=tmp[i].split("/")[0];
    			var ret=window.confirm(tmp[i].split("/")[1]+'�����,ȷ�����ǣ�');
    			if(ret==true) MRCInsertDataToItemDic(retData,DRowid,obj,str);		
    		}
    		else 
    		{
    				MRCInsertDataToItemDic("",tmp[i].split("/")[0],obj,str);
    		}
    	}
}
function MRCInsertDataToItemDic(IDRowid,MRCRowid,obj,str)
{
	var ret="";
	var objMRC = ExtTool.StaticServerObject("DHCMed.Base.MRCICDDx");
	var objID = ExtTool.StaticServerObject("DHCMed.CCService.ContentDicSrv");
	ret = objMRC.GetStringById(MRCRowid);
	var tmp = IDRowid;						// rowid
	tmp += "^"+str+MRCRowid;				// IDCode    "OE"+rowid
	tmp += "^"+ret.split("^")[2];			// IDDesc
	tmp += "^"+obj.MRCIDSubCatDr.getValue();	// �ӷ���
	tmp += "^"+"{"+str+MRCRowid+"}";		//���ʽ
	tmp += "^"+"";							// ��Χ
	tmp += "^"+"";							// ��ע
	
	var retData=objID.AddInfoToDic(tmp,"D");
	if(retData>0) 
		{
			obj.IDRowid.setValue();
			obj.IDCode.setValue();
			obj.IDDesc.setValue();
			obj.IDSubCatDr.setValue();
			obj.IDExpression.setValue();
			obj.IDRange.setValue();
			obj.IDResume.setValue();
			obj.IDListStore.load({ params : { start:0 , limit:20 }});
			obj.CDicListStore.load({ params : { start:0 , limit:20 }});
		}
	else ExtTool.alert("��ʾ","����ʧ��!");
}