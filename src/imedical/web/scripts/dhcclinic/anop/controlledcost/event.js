function InitViewScreenEvent(obj)
{
	var _DHCANOPControlledCost=ExtTool.StaticServerObject('web.DHCANOPControlledCost');
	var _DHCANOPNurRecord=ExtTool.StaticServerObject('web.DHCANOPNurRecord');
	var _DHCANOPArrangeExtend=ExtTool.StaticServerObject('web.DHCANOPArrangeExtend');
	//var _DHCLCNUREXCUTE=ExtTool.StaticServerObject('web.DHCLCNUREXCUTE');
	//var _DHCSTINTERFACE=ExtTool.StaticServerObject('web.DHCSTINTERFACE');
	//var intReg=/^[1-9]\d*$/;
	var UserId=session['LOGON.USERID'];
	obj.LoadEvent=function(args)
	{
		if(opaId!="")
		{
		    var res=_DHCANOPNurRecord.GetPatInfo(opaId);
		    var patInfo=res.split("^");
		    LoadData(patInfo);
		   
		}
		obj.txtPatname.disable();
		obj.txtPatSex.disable();
		obj.txtPatAge.disable();
		obj.txtPatWard.disable();
		obj.txtPatBedNo.disable();
		obj.txtMedCareNo.disable();
		obj.patOpName.disable();
		obj.total.disable();
		obj.unit.disable();
		obj.univalent.disable();
		
	}
	function LoadData(patInfo)
	 {
		  obj.txtPatname.setValue(patInfo[1]); //姓名
		  obj.txtPatSex.setValue(patInfo[2]); //性别
	   obj.txtPatAge.setValue(patInfo[3]); //年龄
	   if (patInfo[21].split("-").length>1)
	   {
		   patWard=patInfo[21].split("-")[1]
	   }
	   else patWard=patInfo[21]
	   obj.txtPatWard.setValue(patWard); //病区
	   obj.txtPatBedNo.setValue(patInfo[16]); //床号
	   obj.txtMedCareNo.setValue(patInfo[4]); 
	   obj.patOpName.setValue(patInfo[8]);
	     
	 }
	 obj.LoadCombox=function(combox,item)
	{
	 if("undefined" == typeof item) return;
	 var itemList=item.split("!")
	 if(itemList.length>1)
	 {
	 combox.setValue(itemList[0]);
	 combox.setRawValue(itemList[1])
	 }
	}
	obj.article_select=function()
	{
	    var articleId=obj.article.getValue()
	    var retStr=_DHCANOPControlledCost.GetBatInfoByIncil(articleId)
	    if (retStr=="") return;
	    var batInfo=retStr.split("^");
	    if (batInfo.length<7) return;
	    obj.univalent.setValue(batInfo[4]);
	    obj.unit.setValue(batInfo[5]);
	}
	obj.btnAdd_click=function()
	 {
	  var articleId=obj.article.getValue();
	  var articleDesc=obj.article.getRawValue();
	  var checkFlag=_DHCANOPControlledCost.CheckValidData(articleDesc,articleId);
	  if(checkFlag==0)
	  {
		alert("请从下拉菜单中选择物品")
	   return;  
	  }

	  var unit=obj.unit.getValue()
	  var amount=obj.amount.getValue()
	  var total=obj.total.getValue()
	  if(articleId=="")
	  {
	   alert("请选择物资材料")
	   return;
	  }
	  var ret=_DHCANOPControlledCost.SaveArticleInfo(opaId,articleId,unit,amount,total,UserId)
	 if(ret==0) {
		 alert("添加成功");
		 obj.article.setValue("");
		obj.ArticleId.setValue("");
		obj.article.setRawValue("");	//物品
		obj.univalent.setValue("");	//单价
		obj.unit.setValue("");	//单位
		obj.amount.setValue("");	//数量
		obj.total.setValue("");	//总计

	 }
	  obj.retGridPanelStore.load({});
	  //obj.retGridPanelStore.commitChanges() 
	 }
	 //修改
	 obj.btnUpdate_click=function()
	 {
	  var carticleId=obj.article.getValue()
	  if(carticleId=="")
	  {
	   alert("请选择物资材料")
	   return;
	  }
	  var articleDesc=obj.article.getRawValue();
	  var checkFlag=_DHCANOPControlledCost.CheckValidData(articleDesc,carticleId);
	  if(checkFlag==0)
	  {
		alert("请从下拉菜单中选择物品")
	   return;  
	  }
	  var cunit=obj.unit.getValue();
	  var camount=obj.amount.getValue();
	  var ctotal=obj.total.getValue();
	  var cunivalent=obj.univalent.getValue();	//单价
	 // alert(opaId+"^"+carticleId+"^"+cunit+"^"+camount+"^"+UserId+"^"+cunivalent)
	  var ret=_DHCANOPControlledCost.UpdateArticleInfoFromList(opaId,carticleId,cunit,camount,UserId,cunivalent)
	  if(ret==0){
		  alert("修改成功");
		  }
		  else
		  {
			  alert(ret)
		  }
	  obj.retGridPanelStore.load({});
	  //obj.retGridPanelStore.commitChanges() 
	 }

	 obj.btnDelete_click=function(ev)
	 {
		 var articleId=obj.ArticleId.getValue()
		 if (articleId=="")
		 {
			 alert("物资ID不能为空")
			 return;
		 }
		 var ret=_DHCANOPControlledCost.DeleteArticleInfo(opaId,articleId)
		 if(ret!=0)
				{
					ExtTool.alert("警告",ret);
				}
				else
				{
					alert("删除成功!");
					obj.article.setValue("");
					obj.ArticleId.setValue("");
					obj.article.setRawValue("");	//物品
					obj.univalent.setValue("");	//单价
					obj.unit.setValue("");	//单位
					obj.amount.setValue("");	//数量
					obj.total.setValue("");	//总计
				}
		 obj.retGridPanelStore.reload();
	 }
	 
	 
	 obj.btnClose_click=function()
	 {
	   window.close()
	 }
	 
	 obj.retGridPanel_rowclick=function() //点击后获取数据
	{
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj)
	    {
		    selectObj.set('checked',!selectObj.get('checked'));
			
			obj.article.setValue(selectObj.get('articleId'));
			obj.ArticleId.setValue(selectObj.get('articleId'));
			obj.article.setRawValue(selectObj.get('tArticle'));	//物品
			obj.univalent.setValue(selectObj.get('tUnivalent'));	//单价
			obj.unit.setValue(selectObj.get('tUnit'));	//单位
			obj.amount.setValue(selectObj.get('tAmount'));	//数量
			obj.total.setValue(selectObj.get('tTotal'));	//总计
			obj.OpaId.setValue(selectObj.get('opaId'));
	    }
	}
	 //判断是否可以编辑
	obj.retGridPanel_beforeedit=function(ev) 
	{
		if((ev.field=='tArticle')||(ev.field=='tUnivalent'))
		{
			//ExtTool.alert("提示","不能在列表里修改物品名称或者单价!");
			//return false;
		}
		if(ev.field=='tTotal')
		{
			ExtTool.alert("提示","总成本不需手工修改!");
			return false;
		}
	}

	obj.retGridPanel_validateedit=function(ev)
	{
	}

	obj.retGridPanel_afteredit=function(ev) 
	{
		var tUnivalent=ev.record.data.tUnivalent;
		var articleId=ev.record.data.articleId;
		var tUnit=ev.record.data.tUnit;
		var tAmount=ev.record.data.tAmount;
		var ret=_DHCANOPControlledCost.UpdateArticleInfoFromList(opaId,articleId,tUnit,tAmount,UserId,tUnivalent)
		if(isNaN(ret))
				{
					ExtTool.alert("警告",ret);
					obj.retGridPanelStore.reload();
				}
				else
				{
					ev.record.set('tTotal',ret);
					//obj.retGridPanelStore.reload();
				}
		
	}

}