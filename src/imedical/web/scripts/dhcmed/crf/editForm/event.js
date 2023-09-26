function InitViewscreenEvent(obj) {	
	obj.LoadEvent = function()
  {
  	obj.txtFormID.setValue(FormID);
  	obj.txtCName.setValue(CName);
  	obj.txtEName.setValue(EName);
  	ExtTool.AddComboItem(obj.txtBusiness,BusinessName,BusinessCode);
  /*	obj.editGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CR.PO.FormStatus';
			param.QueryName = 'QueryFormStatus';
			param.Arg1 =obj.txtFormID.getValue(); 
			param.ArgCnt = 1;
		});		
		obj.editGridPanelStore.load({});*/
  };
	var formSev=ExtTool.StaticServerObject("DHCMed.CR.PO.Form");
	var formStatus=ExtTool.StaticServerObject("DHCMed.CR.PO.FormStatus");
	obj.updateForm=function()
	{
		var tmp=obj.txtFormID.getValue()+"^";
		if(obj.txtCName.getValue()==""){
			tmp+=obj.txtEName.getValue()+"^";
		}
		else{
			tmp+=obj.txtCName.getValue()+"^";
		}	
		tmp+=obj.txtEName.getValue()+"^";
		tmp+=ESchema+"^"+ProCode+"^";
		tmp+=obj.txtBusiness.getValue();
		
  //保存表单定义信息
		try
		{
			var NewID=formSev.Update(tmp);
			if(NewID>0) {
				ExtTool.alert("提示","保存表单定义信息成功！");
				if(FormID=="")
				{
					FormID=NewID;
				}
				return;
			}
		}catch(err)
		{
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}
	};
	obj.updateFormSta=function()
	{
		//保存表单状态列表
		var m = obj.editGridPanelStore.getRange(0,obj.editGridPanelStore.getCount());
   // var data='';       
    for (var i = 0; i < m.length; i++) 
    {
    	var data='';
    	var record = m[i];
    	var fields = record.fields.keys; 
      for (var j = 1; j < fields.length-2; j++) 
      {        	
           var name = fields[j];
           var value = record.data[name]; 
           data+=value+"^"; 
      }	
      for (var j = fields.length-2; j < fields.length; j++) 
      {        	
           var name = fields[j];
           var value = record.data[name]; 
           if(value)
		         data+="1^";
		       else
		         data+="0^"; 
      }
   //   data+="#";
    //保存表单状态列表
      try
			{			
					var NewID=formStatus.UpdateStatus(FormID,data);
					if(NewID!=""){
						if(NewID<0) {
							ExtTool.alert("提示","保存表单状态列表失败！");
						}
						else{
							ExtTool.alert("提示","保存表单状态列表成功！");
						}
					}
				//	return;
			}catch(err)
			{
				ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
			}
		}
	};
	obj.onAdd = function()
	{
      var input = document.getElementById("input"); 
      for(var i = 0; i < input.length; i ++ ) { 
				if(input[i].selected == true) { 
					if( obj.editGridPanelStore.getCount()== 0){ 
							obj.editGridAdd(input[i].value,input[i].innerText);
					} 
					//确保状态代码不重复
					var isExist = false; 
					var m = obj.editGridPanelStore.getRange(0,obj.editGridPanelStore.getCount());
					
					for (var j = 0; j < m.length; j++) 
		      { 
		      	var record = m[j];
		        var value = record.data["StatusCode"];
						if (value== input[i].value){ 
							isExist = true; 
							break; 
						} 
					} 					
					if (isExist == false){ 
						obj.editGridAdd(input[i].value,input[i].innerText);
					} 
				} 
			}
	};
	obj.editGridAdd=function(code,name)
	{
		var Plant = obj.editGridPanel.getStore().recordType;
	    var p = new Plant({
	        StatusCode: code,
	        StatusName: name,
	        IsSubmitData: 0,
	        IsCheckData: 0
	    });
	    var n=obj.editGridPanelStore.getCount();
	    obj.editGridPanel.stopEditing();
	    obj.editGridPanelStore.insert(n, p);
	    obj.editGridPanel.getView().refresh();
	    obj.editGridPanel.startEditing(0,0);
	};
	obj.onDelete = function()
	{	
    var sm = obj.editGridPanel.getSelectionModel();    
    var cell = sm.getSelectedCell();
		var record = obj.editGridPanelStore.getAt(cell[0]);
		obj.editGridPanelStore.remove(record);
		obj.editGridPanel.getView().refresh();
		if(record.data["FormStaID"]){
			{
			try
				{
					var ret=formStatus.DeleteById(record.data["FormStaID"]);
					if(ret!=0) {
						ExtTool.alert("提示","删除失败！");
						return;
					}
				}catch(err)
				{
					ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
				}
			}
		}
	};
}
