
function InitViewport1Event(obj) {
	
	var TheOBJ = ExtTool.StaticServerObject("web.DHCHM.BaseDataSet");
	
	var selid0="";var selid="";
	
	obj.LoadEvent = function(args)
  {
  	obj.SCQuestionnaireDRStore.load();
  	};
  
	obj.btSave_click = function()
	{ 
		
		var separete = '^';
		var tmp ='';
		 
		if(obj.SCCode.getValue()=="") {
			ExtTool.alert("提示","代码不能为空！");
			return;
		}
		if(obj.SCDesc.getValue()=="") {
			ExtTool.alert("提示","描述不能为空！");
			return;
		}
		
		
		
		//"SCActive^SCCode^SCDesc^SCMonths^SCPrice^SCRemark"
		if (obj.SCActive.getValue()==false ) 		tmp += 'N'+ separete; else tmp += 'Y'+ separete;			
    tmp += obj.SCCode.getValue()+ separete;
		tmp += obj.SCDesc.getValue()+ separete;
		tmp += obj.SCMonths.getValue()+ separete;
		tmp += obj.SCPrice.getValue()+ separete;
		tmp += obj.SCRemark.getValue();
		
		
	//alert (tmp);
	
		try
		{       
		//alert (selid0);	
			
			var ret = TheOBJ.CServiceClassSaveData(selid0,tmp,"");	
			
		

			if(ret<0) {
				ExtTool.alert("提示","保存失败！");
				return;
			}
			else{
				
			  
				
				
				//代码重复报错	
			  var infoStr=ret.split("^");
	      if (infoStr[0]=="-1") {
	    ExtTool.alert ("提示", ''+infoStr[1]);
	    obj.ItemListStore.load({
		params: {
                	start: 0,
                	limit: 20
            	}
	});}else
	{
		//此处设置更新 和 新建之后的 GRID显示 （插入更新 位置提前等）
		obj.ID.setValue(ret);
		ExtTool.FormToGrid(selid0,obj.ItemList,obj.FormPanel3);
		
	}
	obj.btCancel_click();
			}
		}catch(err)
		{
			
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
			
		}
		
	};
	obj.btCancel_click = function()
	{	obj.FormPanel3.getForm().reset();
		obj.FormPanel3.buttons[0].setText('保存');
		selid0="";obj.ID.setValue(selid);
		  obj.SCCode.focus(true,3); 
	};
	obj.btFind_click = function()
	{obj.ItemListStore.load({
		params: {
                	start: 0,
                	limit: 20
            	}
	});
	};
	//表格点击
	obj.ItemList_cellclick = function(g,row,col,e)
{};
	

	obj.btSubSave_click = function()
	{//子表保存 
			var separete = '^';
		var tmp ='';
		 
		if(obj.SCQLParRef.text=="") {
			ExtTool.alert("提示","所属服务类型不能为空！");
			return;
		}
	//	alert(obj.SCQuestionnaireDR.getValue());
		if(obj.SCQuestionnaireDR.getValue()=="") {
			ExtTool.alert("提示","问卷不能为空！");
			return;
		}
		
		if(obj.SCQLOrder.getValue()=="") {
			ExtTool.alert("提示","顺序不能为空！");
			return;
		}
//obj.GridPanel10Store.each(function(record){alert(record.get('QDesc'));});

		

		var index = obj.GridPanel10Store.find('SCQLCQuestionnaireDR',obj.SCQuestionnaireDR.getValue());  
		//var index = obj.GridPanel10Store.getCount()
		if (index>=0&& selid==""){
		 ExtTool.alert("提示","该问卷已经添加，不能重复！");
		return;}
		//
		
		//SCQLParRef^ID^SCQLCQuestionnaireDR^SCQLOrder^SCQLRemark^childsub
	
   // tmp += obj.SCQLParRef.text+ separete;
   // tmp += separete;
	//	tmp += obj.SCQLCQuestionnaireDR.getValue()+ separete;
	//	tmp += obj.SCQLOrder.getValue()+ separete;
//		tmp += separete;
	//	tmp += separete;
	
	  tmp += obj.SCQLParRef.text+ separete;
  	tmp += obj.SCQuestionnaireDR.getValue()+ separete;
		tmp += obj.SCQLOrder.getValue();
	
		
	//alert (tmp);
	
		try
		{       
		//	alert(selid);
			
			var ret = TheOBJ.CSCQLinkSaveData(selid,tmp,"");	
			
		

			if(ret<0) {
				ExtTool.alert("提示","保存失败！");
				return;
			}
			else{
				
				
				
				//代码重复报错	
			  var infoStr=ret.split("^");
	      if (infoStr[0]=="-1") {

	       ExtTool.alert ("提示", '重复的ID！  '+infoStr[1]);
	       obj.ItemListStore.load({
		params: {
                	start: 0,
                	limit: 20
            	}
	});}else 
	{obj.GridPanel10Store.load({
		params: {
                	start: 0,
                	limit: 20
            	}
	});
				obj.ID1.setValue(ret);
				selid="";
		
	}
	obj.btSubCancel_click();
		   	}
		}catch(err)
		{
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}
	
	};
	//
	obj.btSubCancel_click = function()
	{
		
		obj.FormPanel2.getForm().reset();
		selid="";
		obj.ID1.setValue(selid);
		  obj.SCQuestionnaireDR.focus(true,3); 
	};
	
	//----------左表格点击------------------------
	obj.ItemList_rowclick = function(g,row,e)
	{
			var record = g.getStore().getAt(row);
		if  (record.get('SCActive')=='Y') record.set('SCActive',true);
		if  (record.get('SCActive')=='N')  record.set('SCActive',false); 
	//	alert(record.get('SCActive'));
		obj.FormPanel3.getForm().loadRecord(record);
		//obj.FormPanel3.buttons[0].setText('更新');
		
		
		//obj.FormPanel2.getForm().reset();
		//obj.FormPanel2.buttons[0].setText('保存');
		//selid="";
	
	
	//obj.thepopwin.setVisible(true);

 //  var fieldName = g.getSelectionModel().getSelected();
 //   selid0=fieldName.id;
 
 	 selid0 =obj.ID.getValue();  
 	 selid="";
 	 //obj.FormPanel2.getForm().reset();
 	 obj.btSubCancel_click();
 	 
    obj.SCQLParRef.setText(selid0);
    obj.GridPanel10Store.load({
		params: {
                	start: 0,
                	limit: 20
            	}
	});
		
	};
	
	//---------右表格点击------------------------
	
	obj.GridPanel10_rowclick = function(g,row,e)
	{
		var record = g.getStore().getAt(row);
		obj.SCQuestionnaireDR.setValue(record.get('SCQLCQuestionnaireDR'));
		obj.FormPanel2.getForm().loadRecord(record);
		
		 //selid = g.getSelectionModel().getSelected().id;
		 
		  selid =obj.ID1.getValue();
		 
		//obj.FormPanel2.buttons[0].setText('更新');
		//alert(record.get('SCQLCQuestionnaireDR'));
	
	};
	//--------删除-------------------------
	obj.btDelete_click = function()
	{
		
		var id = selid;
		
		if(id == "") {
			ExtTool.alert("提示","请选择一条记录！");
			return;
		}
		Ext.MessageBox.confirm("提示","您确定要删除记录"+id+"?", function(button,text){ 
				if(button=='yes'){
				//	alert(button);
					try
		{  
			


			

			
		//	alert(id);
			var ret = TheOBJ.CSCQLinkDelete(id);	
			if(ret.split("^")[0] == -1) {
				ExtTool.alert("失败");
				return;
			}
			else{
			        obj.btSubCancel_click();
				obj.GridPanel10Store.load({
		params: {
                	start: 0,
                	limit: 20
            	}
	});
			}
		}catch(err)
		{
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}
					
					}
}); 
		
		
	};
/*Viewport1新增代码占位符*/
















































































































































































































































































































































































































}

