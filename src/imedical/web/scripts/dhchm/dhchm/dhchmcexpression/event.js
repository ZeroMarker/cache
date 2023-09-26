
function InitViewport1Event(obj) {
	
	var TheOBJ = ExtTool.StaticServerObject("web.DHCHM.BaseDataSet");
	var selid="";
	obj.LoadEvent = function(args)
  {};
  
	obj.btSave_click = function()
	{ var separete = '^';
		var tmp ='';
		 
		if(obj.ECQuestionnaireDR.getValue()=="") {
			ExtTool.alert("提示","问卷不能为空！");
			return;
		}
		if(obj.EExpression.getValue()=="") {
			ExtTool.alert("提示","表达式不能为空！");
			return;
		}
		
		//EAgeMax^EAgeMin^ECQuestionnaireDR^EExpression^EExpressionType^EParameters^ERemark^ESex^ESourceID^EType^EUnit
		tmp += obj.EAgeMax.getValue()+ separete;
		tmp += obj.EAgeMin.getValue()+ separete;
		tmp += obj.ECQuestionnaireDR.getValue()+ separete;
		tmp += obj.EExpression.getValue()+ separete;
		tmp += obj.EExpressionType.getValue()+ separete;
		tmp += obj.EParameters.getValue()+ separete;
		tmp += obj.ERemark.getValue()+ separete;
		tmp += obj.ESex.getValue()+ separete;
		//tmp += obj.EType.getValue()+ separete;
		tmp += separete;
	  tmp +="1"+ separete;
		tmp += obj.EUnit.getValue();
	
	
//	tmp="44^33^2^55^77^66^99^22^1^1^88";
//		alert(tmp);
		

    
		
	
	
		try
		{       
		//	alert(selid);
			
			var ret = TheOBJ.CExpressionSaveData(selid,tmp,"");	
			
		

			if(ret<0) {
				ExtTool.alert("提示","保存失败！");
				return;
			}
			else{
				obj.ItemListStore.load();
			}
		}catch(err)
		{
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}
		
	};
	obj.btCancel_click = function()
	{obj.FormPanel3.getForm().reset();
	  selid="";
		obj.FormPanel3.buttons[0].setText('保存');
	};
	obj.btFind_click = function()
	{
	};
	obj.ItemList_rowclick = function(g,row,e)
	{ 
		
		var record = g.getStore().getAt(row);
		obj.FormPanel3.getForm().loadRecord(record);
		selid = g.getSelectionModel().getSelected().id;
		 
	
		obj.FormPanel3.buttons[0].setText('更新');
	};
	obj.btDelete_click = function()
	{	var id = selid;
		
		if(id == "") {
			ExtTool.alert("提示","请选择一条记录！");
			return;
		}
		Ext.MessageBox.confirm("提示","您确定要删除记录"+id+"?", function(button,text){ 
				if(button=='yes'){
					
		try
		{ // alert(id);
			var ret = TheOBJ.CExpressionDelete(id);	
			if(ret.split("^")[0] == -1) {
				ExtTool.alert("失败");
				return;
			}
			else{
				obj.ItemListStore.load();
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

