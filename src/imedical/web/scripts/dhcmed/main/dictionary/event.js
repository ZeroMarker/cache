
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
		
		//Add By LiYang 2014-07-16 FixBug:1353 系统配置-基础字典-右击页面最底端字典记录，不能显示出右键菜单
		var objPos = e.getXY();
		if(screen.height - objPos[1] < 300) //判断一下用户鼠标右键单击位置，如果太靠下了的话，就把Y值减掉一些，使菜单位置上移
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
			ExtTool.alert("提示","请先选中一行!");
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
	*DicType编辑函数
	*/
	obj.DicTypeEdit = function(){		
		var selectObj = obj.GridPanelSYS.getSelectionModel().getSelected();
		if (selectObj){
			var objEdit = new InitwinEdit("SYS",selectObj,obj);
			objEdit.winEdit.show();
		}
		else{
			ExtTool.alert("提示","请先选中一行!");
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
		obj.winItems.setTitle("字典维护-" + strDesc);
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
	*arg1：dicType   --字典类型
	*arg2: obj       --字典对象
	*arg3: parentWin --父窗体
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
	*加载数据
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
		//obj.DateFrom.setValue(arryFields[6]); //Modified By LiYang 2014-07-14 FixBug:系统管理-基础字典-修改字典类别（或修改字典项目），选择维护了开始日期和截止日期的记录，修改保存报错"zUpdate+23DHCMed.SSDictionary.1"
		//obj.DateTo.setValue(arryFields[7]); //Modified By LiYang 2014-07-14 FixBug:系统管理-基础字典-修改字典类别（或修改字典项目），选择维护了开始日期和截止日期的记录，修改保存报错"zUpdate+23DHCMed.SSDictionary.1"
		obj.cboProductStore.load({
			callback: function(){obj.cboProduct.setValue(arryFields[8]);}
		})
		//Add By LiYang 2014-07-14 FixBug:1325  系统管理-基础字典-修改字典类别（或修改字典项目），弹出的编辑界面不显示医院信息
		obj.HispsDescsStore.load({
			callback : function(){
				if (arryFields[4]!=0)  //add by yhb 医学死亡证明管理-基础配置-基础字典-修改字典类别(或修改字典项目)-选择一条【医院】为空的记录,编辑界面【医院】为"0"
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
	
	/*清屏*/
	obj.clearForm = function(){		
  		//可通过FormPanel.getForm().reset()方法为整个Form初始化
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
			ExtTool.alert("提示","代码不能为空！");
			return;
		}
		if(obj.Description.getValue()=="") {
			ExtTool.alert("提示","描述不能为空！");
			return;
		}
	/*	if((obj.DateFrom.getValue()=="")&&(obj.DateFrom.getRawValue()!="")) {
			ExtTool.alert("提示","开始日期不能为空！");
			return;
		}
		if((obj.DateTo.getValue()=="")&&(obj.DateTo.getRawValue()!="")) {
			ExtTool.alert("提示","结束日期不能为空！");
			return;
		}
		if(obj.DateFrom.getValue()>obj.DateTo.getValue()) {
			ExtTool.alert("提示","开始日期不能大于结束日期！");
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
				ExtTool.alert("提示","代码重复，请重新填写！");
				return;
			}
		}
		// fix bug 117305 先判断类别有效性再更新
		var IsActive=obj.Active.getValue()? "1" : "0"
		if((obj.dicType != "SYS")&&(IsActive == 1))
		{
		
			var retB = dicServer.CheckIsActive(obj.dicType);
			if(retB == 0)
			{
				ExtTool.alert("提示","该字典项目所属的字典类别有效性为'No',请修改其有效性！");	
				return;
			}
		}
		//try
		//{       
			var ret = dicPersistent.Update(tmp,separete);		
			if(ret<0) {
				if(ret == "-2")
					ExtTool.alert("提示","输入的代码与列表中的项目代码重复！");
				else
					ExtTool.alert("提示","保存失败！");
				return;
			}
			else{
				var IsActive=obj.Active.getValue()? "1" : "0"
				if((obj.dicType == "SYS")&&(IsActive == 0))
				{
					var retA = dicServer.ChangeIsActive(obj.Code.getValue());
					if(retA > 0) ExtTool.alert("提示","该字典类别下所有字典项目的有效性已置为'No'！");
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
