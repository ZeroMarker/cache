
function InitViewport1Event(obj) {
	
	var TheOBJ = ExtTool.StaticServerObject("web.DHCHM.BaseDataSet");
	var selid="";
	obj.LoadEvent = function(args)
  {};
  
	obj.btSave_click = function()
	{ var separete = '^';
		var tmp ='';
		 
		if(obj.ECQuestionnaireDR.getValue()=="") {
			ExtTool.alert("��ʾ","�ʾ���Ϊ�գ�");
			return;
		}
		if(obj.EExpression.getValue()=="") {
			ExtTool.alert("��ʾ","���ʽ����Ϊ�գ�");
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
				ExtTool.alert("��ʾ","����ʧ�ܣ�");
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
		obj.FormPanel3.buttons[0].setText('����');
	};
	obj.btFind_click = function()
	{
	};
	obj.ItemList_rowclick = function(g,row,e)
	{ 
		
		var record = g.getStore().getAt(row);
		obj.FormPanel3.getForm().loadRecord(record);
		selid = g.getSelectionModel().getSelected().id;
		 
	
		obj.FormPanel3.buttons[0].setText('����');
	};
	obj.btDelete_click = function()
	{	var id = selid;
		
		if(id == "") {
			ExtTool.alert("��ʾ","��ѡ��һ����¼��");
			return;
		}
		Ext.MessageBox.confirm("��ʾ","��ȷ��Ҫɾ����¼"+id+"?", function(button,text){ 
				if(button=='yes'){
					
		try
		{ // alert(id);
			var ret = TheOBJ.CExpressionDelete(id);	
			if(ret.split("^")[0] == -1) {
				ExtTool.alert("ʧ��");
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
/*Viewport1��������ռλ��*/










































































































































































































































































































}

