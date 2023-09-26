
function InitviewMainEvent(obj)
{	
	obj.CurrDicType = "";
	obj.CurrNode = null;
	
	obj.LoadEvent = function(args)
	{
	}
	
	obj.objDicTreeClick = function(objNode)
	{
		var arryField = objNode.id.split("-");
		obj.CurrDicType = arryField[1];
		obj.CurrNode = objNode;
		obj.gridItemsStore.load(
			{
					params :	{
							ClassName : 'DHCMed.SSService.DictionarySrv',
							QueryName : 'QryDictionary',
							Arg1 : arryField[1],
							Arg2 : '',
							ArgCnt : 2
					}
			}
		);
	}
	
	obj.objDicTree_contextmenu = function(node, e)
	{
		var arryField = node.id.split("-");
		Ext.getCmp("mnuNewDic").enable();
		Ext.getCmp("mnuNewDicItem").enable();
		Ext.getCmp("mnuModifyDic").enable();
		switch(arryField[0])
		{
			case 'product':
				//Ext.getCmp("mnuNewDic").disable();
				Ext.getCmp("mnuNewDicItem").disable();
				Ext.getCmp("mnuModifyDic").disable();
				break;
			case 'dicType':
				Ext.getCmp("mnuNewDic").disable();
				//Ext.getCmp("mnuNewDicItem").disable();
				//Ext.getCmp("mnuModifyDic").disable();
				break;	
		}
		
		//Add By LiYang 2014-07-16 FixBug:1353 ϵͳ����-�����ֵ�-�һ�ҳ����׶��ֵ��¼��������ʾ���Ҽ��˵�
		var objPos = e.getXY();
		if(screen.height - objPos[1] < 300) //�ж�һ���û�����Ҽ�����λ�ã����̫�����˵Ļ����Ͱ�Yֵ����һЩ��ʹ�˵�λ������
			objPos[1] -= 80;
		obj.objDicMenu.showAt(e.getXY());
		obj.objCurrSelNode = node;
	}
	
	obj.mnuNewDic_click = function()
	{
		var objFrm = new InitwinEdit("SYS", obj, "");
		objFrm.winEdit.show();
	}

	obj.mnuNewDicItem_click = function()
	{
		var objFrm = new InitwinEdit(obj.CurrDicType, obj, "");
		objFrm.winEdit.show();
	}
	
	obj.mnuModifyDic_click = function()
	{
		var arryField = obj.CurrNode.id.split("-");
		var objFrm = new InitwinEdit("SYS", obj, arryField[2]);
		objFrm.winEdit.show();
	}	
	
	
	obj.objDicItems_dblclick = function(objNode, objEvent)
	{
		if(objNode == null)
			return;
		var arryIDFields = objNode.id.split("-");
		switch(arryIDFields[0])
		{
			case "root":
				break;
			case "product":
				break;
			case "dicType":
				var objItems = new InitwinItems(arryIDFields[1], objNode.text);
				objItems.winItems.show();			
				break;
		}
		//select a row ,get type code first
		var selectObj = obj.GridPanelSYS.getSelectionModel().getSelected();
		if (selectObj){
			var objItems = new InitwinItems(selectObj.get("Code"),selectObj);
			objItems.winItems.show();
		}
		else{
			ExtTool.alert("��ʾ","����ѡ��һ��!");
		}
		
	};
	
	obj.gridItems_rowdblclick = function(objGrid, rowIndex)
	{
		var objRec = obj.gridItemsStore.getAt(rowIndex);
		var objFrmEdit = new InitwinEdit(obj.CurrDicType, obj, objRec.get("myid"));
		objFrmEdit.winEdit.show();
		
	}
	
	
	
	
	obj.btnAdd_click = function()
	{
		var objEdit = new InitwinEdit("SYS",null);
		objEdit.winEdit.show();
	};
	obj.btnEdit_click = function()
	{
		obj.DicTypeEdit();
	};
	obj.GridPanelSYS_rowdblclick = function()
	{
		obj.btnDicItems_click();
	};
	
	/*
	*DicType�༭����
	*/
	obj.DicTypeEdit = function(){		
		var selectObj = obj.GridPanelSYS.getSelectionModel().getSelected();
		if (selectObj){
			var objEdit = new InitwinEdit("SYS",selectObj,obj);
			objEdit.winEdit.show();
		}
		else{
			ExtTool.alert("��ʾ","����ѡ��һ��!");
		}
	}

}


function InitwinItemsEvent(obj) {
	var parentView = objControlArry['viewMain'];
	var dicType;
	var objEdit
	obj.LoadEvent = function(args)
	{	
		dicType = args[0];
		var strDesc = args[1];
		//var objData = args[1];
		obj.winItems.setTitle("�ֵ�ά��-" + strDesc);
		objEdit = new InitwinEdit(dicType,null,obj);
		objEdit.fPanel.setHeight(210);
		obj.panelEdit.add(objEdit.fPanel);
		
		obj.gridItemsStoreProxy.on('beforeload', function(objProxy, param){
				param.ClassName = 'DHCMed.SSService.DictionarySrv';
				param.QueryName = 'QryDictionary';
				param.Arg1 = dicType;
				param.Arg2 = '';
				param.ArgCnt = 2;
		});
		obj.gridItemsStore.load();
	};
	
	
	obj.gridItems_rowclick = function()
	{		
		var rowIndex = arguments[1];
		var objData = obj.gridItemsStore.getAt(rowIndex);
		objEdit.LoadData(objData.get("myid"));
	};
}



function InitwinEditEvent(obj)
{	
	
	var hospServer = ExtTool.StaticServerObject("DHCMed.Base.Hospital");
	var dicServer = ExtTool.StaticServerObject("DHCMed.SSService.DictionarySrv");
	var dicPersistent = ExtTool.StaticServerObject("DHCMed.SS.Dictionary");
	var parentView = objControlArry['viewMain'];
	var dicType;
	var parentWin;
	/*
	*arg1��dicType   --�ֵ�����
	*arg2: obj       --�ֵ����
	*arg3: parentWin --������
	*/
	obj.LoadEvent = function(args)
	{	
		obj.dicType = args[0];
		//var objData = arguments[0][1];
		obj.parentWin = args[1];
		if((args[2] == "")||(args[2] == null))
			return;
		obj.LoadData(args[2]);
	}
	/*
	*��������
	*/
	obj.LoadData = function(ID){
		var strDic = dicPersistent.GetStringById(ID, "^");
		if(strDic == "")
			return;
		var arryFields = strDic.split("^");
		obj.txtType.setValue(arryFields[3]);
		obj.txtRowid.setValue(arryFields[0]);
		obj.Code.setValue(arryFields[1]);
		obj.Code.setReadOnly(true);
		obj.Code.setDisabled(true);
		obj.Description.setValue(arryFields[2]);	
		obj.Active.setValue(arryFields[5] == "1");
		//obj.DateFrom.setValue(arryFields[6]); //Modified By LiYang 2014-07-14 FixBug:ϵͳ����-�����ֵ�-�޸��ֵ���𣨻��޸��ֵ���Ŀ����ѡ��ά���˿�ʼ���ںͽ�ֹ���ڵļ�¼���޸ı��汨��"zUpdate+23DHCMed.SSDictionary.1"
		//obj.DateTo.setValue(arryFields[7]); //Modified By LiYang 2014-07-14 FixBug:ϵͳ����-�����ֵ�-�޸��ֵ���𣨻��޸��ֵ���Ŀ����ѡ��ά���˿�ʼ���ںͽ�ֹ���ڵļ�¼���޸ı��汨��"zUpdate+23DHCMed.SSDictionary.1"
		obj.cboProductStore.load({
			callback: function(){obj.cboProduct.setValue(arryFields[8]);}
		})
		//Add By LiYang 2014-07-14 FixBug:1325  ϵͳ����-�����ֵ�-�޸��ֵ���𣨻��޸��ֵ���Ŀ���������ı༭���治��ʾҽԺ��Ϣ
		obj.HispsDescsStore.load({
			callback : function(){
				if (arryFields[4]!=0)  //add by yhb ҽѧ����֤������-��������-�����ֵ�-�޸��ֵ����(���޸��ֵ���Ŀ)-ѡ��һ����ҽԺ��Ϊ�յļ�¼,�༭���桾ҽԺ��Ϊ"0"
				obj.HispsDescs.setValue(arryFields[4]); 
			}
		});
		
		
		/*
		if (dicType){
			obj.txtType.setValue(dicType);
			if (objData){

				if (objData.get("Active")=="YES"){
					obj.Active.setValue(true);
				}
				else{
					obj.Active.setValue(false);
				}
				if (objData.get("HospDr")!=""){
					ExtTool.AddComboItem(obj.HispsDescs,objData.get("HispsDescs"),objData.get("HospDr"));
				}				
				obj.DateFrom.setValue(objData.get("DateFrom"));
				obj.DateTo.setValue(objData.get("DateTo"));
			}
			else{
				obj.clearForm();
				//obj.fPanel.getForm().reset();
			}
		}		*/
	}
	
	/*����*/
	obj.clearForm = function(){		
  		//��ͨ��FormPanel.getForm().reset()����Ϊ����Form��ʼ��
		obj.fPanel.getForm().reset();
		obj.Code.setReadOnly(false);
		obj.Code.setDisabled(false);
		/*
		obj.txtRowid.reset();
		obj.Code.reset();
		obj.Code.setReadOnly(false);
		obj.Code.setDisabled(false);
		obj.Description.reset();
		obj.HispsDescs.reset();
		obj.Active.reset();
		obj.DateFrom.reset();
		obj.DateTo.reset();*/
	}
	obj.btnSave_click = function()
	{		
        if(obj.Code.getValue()=="") {
			ExtTool.alert("��ʾ","���벻��Ϊ�գ�");
			return;
		}
		if(obj.Description.getValue()=="") {
			ExtTool.alert("��ʾ","��������Ϊ�գ�");
			return;
		}
	/*	if((obj.DateFrom.getValue()=="")&&(obj.DateFrom.getRawValue()!="")) {
			ExtTool.alert("��ʾ","��ʼ���ڲ���Ϊ�գ�");
			return;
		}
		if((obj.DateTo.getValue()=="")&&(obj.DateTo.getRawValue()!="")) {
			ExtTool.alert("��ʾ","�������ڲ���Ϊ�գ�");
			return;
		}
		if(obj.DateFrom.getValue()>obj.DateTo.getValue()) {
			ExtTool.alert("��ʾ","��ʼ���ڲ��ܴ��ڽ������ڣ�");
			return;
		}
      */	var separete = String.fromCharCode(1);
		var tmp = obj.txtRowid.getValue()+ separete;
		tmp += obj.Code.getValue()+ separete;
		tmp += obj.Description.getValue() + separete;
		tmp += obj.dicType + separete;
   		tmp += obj.HispsDescs.getValue() + separete;
		tmp += (obj.Active.getValue()? "1" : "0") + separete;	
		tmp += obj.DateFrom.getRawValue() + separete;
	 	tmp += obj.DateTo.getRawValue() + separete;
	 	tmp += obj.cboProduct.getValue() + separete;
	 	if(obj.txtRowid.getValue()==""){
			var CKCode=dicPersistent.CheckCode(obj.dicType,obj.Code.getValue())
			if(CKCode==1){
				ExtTool.alert("��ʾ","�����ظ�����������д��");
				return;
			}
		}
		// fix bug 117305 ���ж������Ч���ٸ���
		var IsActive=obj.Active.getValue()? "1" : "0"
		if((obj.dicType != "SYS")&&(IsActive == 1))
		{
		
			var retB = dicServer.CheckIsActive(obj.dicType);
			if(retB == 0)
			{
				ExtTool.alert("��ʾ","���ֵ���Ŀ�������ֵ������Ч��Ϊ'No',���޸�����Ч�ԣ�");	
				return;
			}
		}
		//try
		//{       
			var ret = dicPersistent.Update(tmp,separete);		
			if(ret<0) {
				if(ret == "-2")
					ExtTool.alert("��ʾ","����Ĵ������б��е���Ŀ�����ظ���");
				else
					ExtTool.alert("��ʾ","����ʧ�ܣ�");
				return;
			}
			else{
				var IsActive=obj.Active.getValue()? "1" : "0"
				if((obj.dicType == "SYS")&&(IsActive == 0))
				{
					var retA = dicServer.ChangeIsActive(obj.Code.getValue());
					if(retA > 0) ExtTool.alert("��ʾ","���ֵ�����������ֵ���Ŀ����Ч������Ϊ'No'��");
				}
				
				var arryField = obj.parentWin.CurrNode.id.split("-");
				parentView.CurrDicType = arryField[1];
				parentView.gridItemsStore.load(
					{
							params :	{
									ClassName : 'DHCMed.SSService.DictionarySrv',
									QueryName : 'QryDictionary',
									Arg1 : arryField[1],
									Arg2 : '',
									ArgCnt : 2
							}
					}
				);			
				obj.winEdit.close();	
				
				if(obj.dicType == "SYS")
				{
					var objParentNode= obj.parentWin.objDicTree.getRootNode();
					//objParentNode.clear();
					obj.parentWin.objDicTreeLoader.load(
						objParentNode,
						function(objNode)
						{
							//window.alert(objNode);
						}
					);
				}
				
				
				/*
				obj.txtRowid.setValue(ret);
				if (dicType=="SYS"){
					obj.winEdit.close();
					parentView.GridPanelSYSStore.load({params : {start:0,limit:20}});
				}
				else{
					parentWin.gridItemsStore.load(
					
					
					);
					obj.clearForm();
				}*/
	        }
		//}catch(err)
		//{
		//	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		//}
	};
	obj.btnCancel_click = function()
	{
		if (dicType=="SYS"){
			obj.winEdit.close();
			//parentView.GridPanelSYSStore.load({params : {start:0,limit:20}});
		}
		else{
			//parentWin.winItems.close();
			//parentView.GridPanelSYSStore.load({params : {start:0,limit:20}});
		}
		obj.winEdit.close();
	};
}
