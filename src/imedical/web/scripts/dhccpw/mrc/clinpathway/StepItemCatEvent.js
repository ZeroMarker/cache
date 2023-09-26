/*!
 * 编写日期:2010-04-27
 * 作者：李宇峰
 * 说明：临床路径子类维护界面的事件
 * 名称：StepItemCatEvent.js
 */

function StepItemCatEvent(obj) {
	
	obj.currRowIndex = -1; //Modified By LiYang 2011-05-26
	
	obj.LoadEvent = function()
  {};
  obj.AddItemCat=function(){
  	if(!obj.ItemCatCode.validate()) return;
  	if(!obj.ItemCatDesc.validate()) return;
  	var code=obj.ItemCatCode.getValue();
  	var checkVal=obj.checkItemCode(code,"");
  	if(checkVal==1){
	 	  	Ext.MessageBox.show({
		          title: 'Failed',
		          msg: '代码已存在，请重新输入!',
		          buttons: Ext.MessageBox.OK,
		          icon:Ext.MessageBox.WARNING
				}); //统一提示风格 Modified By Liyang 2011-05-26     		
  		//alert("代码已存在，请重新输入")
  		obj.ItemCatCode.setValue("");
  		return
  	}
  	var desc=obj.ItemCatDesc.getValue();
  	if(!obj.ItemCatDateFrom.validate()) return
  	var dateFrom=obj.ItemCatDateFrom.getValue();
  	if(!obj.ItemCatDateTo.validate()) return
  	if(dateFrom!=""){
  		dateFrom=dateFrom.format("Y-m-d");
  	}else{
  		dateFrom=""	
	 	Ext.MessageBox.show({
		   title: 'Failed',
		   msg: '请填写开始日期!',
		   buttons: Ext.MessageBox.OK,
		   icon:Ext.MessageBox.WARNING
		}); //Modified By LiYang 2011-06-03  FixBug:56     	  		
  		
  		return;
  	}
  	var dateTo=obj.ItemCatDateTo.getValue();
  	if(dateTo!=""){
  		dateTo=dateTo.format("Y-m-d");	
  		if(dateTo<dateFrom){
	 	  	Ext.MessageBox.show({
		          title: 'Failed',
		          msg: '开始日期不能大于结束日期!',
		          buttons: Ext.MessageBox.OK,
		          icon:Ext.MessageBox.WARNING
				}); //统一提示风格 Modified By Liyang 2011-05-26     			
  			//alert("开始日期不能大于结束日期")
  			return;	
  		}
  	}else{
  		dateTo=""	
  	}
  	var AddStepItemCatMethod=document.getElementById('AddStepItemCatMethod')
  	if(AddStepItemCatMethod){
  		var encmeth=AddStepItemCatMethod.value;	
  	}else{
  		var encmeth=""	
  	}
  	var addVal=cspRunServerMethod(encmeth,code,desc,dateFrom,dateTo)
  	if(addVal<0){
  		Ext.MessageBox.show({
           title: 'Failed',
           msg: '添加失败!',
           buttons: Ext.MessageBox.OK,
           icon:Ext.MessageBox.WARNING
		});
  	}else{
		obj.StepItemCatGridStore.load({});
		obj.ClearItem();
  	}
  	
  }
  obj.checkItemCode=function(Code,Rowid){
  		var CheckItemCodeMethod=document.getElementById('CheckItemCodeMethod')
  		if(CheckItemCodeMethod){
  			var encmeth=CheckItemCodeMethod.value;	
  		}else{
  			var encmeth=""	
  		}
  		var checkVal=cspRunServerMethod(encmeth,Code,Rowid)
  		return checkVal;
  }
  obj.ClearItem=function(){ 
  	obj.ItemRowid=""
  	obj.ItemCatCode.reset();
  	obj.ItemCatDesc.reset();
  	obj.ItemCatDateFrom.reset();
  	obj.ItemCatDateTo.reset();
  	obj.ItemCatCode.enable(true);
  	obj.ItemCatCode.focus();
  }
  obj.UpdateItem=function(){     //修改一条记录。
  	if(obj.ItemRowid==""){
 	  	Ext.MessageBox.show({
	          title: 'Failed',
	          msg: '请选择一条记录!',
	          buttons: Ext.MessageBox.OK,
	          icon:Ext.MessageBox.WARNING
			}); //统一提示风格 Modified By Liyang 2011-05-26      		
  		//alert("请选择一条记录!")
  		return	
  	}
  	if(!obj.ItemCatCode.validate()) return;
  	if(!obj.ItemCatDesc.validate()) return;
  	var code=obj.ItemCatCode.getValue();
  	var checkVal=obj.checkItemCode(code,obj.ItemRowid);
  	if(checkVal==1){
 	  	Ext.MessageBox.show({
	          title: 'Failed',
	          msg: '代码已存在，请重新输入!',
	          buttons: Ext.MessageBox.OK,
	          icon:Ext.MessageBox.WARNING
			}); //统一提示风格 Modified By Liyang 2011-05-26     		
  		//alert("代码已存在，请重新输入")
  		obj.ItemCatCode.setValue("");
  		return
  	}
  	var desc=obj.ItemCatDesc.getValue();
  	if(!obj.ItemCatDateFrom.validate()) return
  	var dateFrom=obj.ItemCatDateFrom.getValue();
  	if(!obj.ItemCatDateTo.validate()) return
  	if(dateFrom!=""){
  		dateFrom=dateFrom.format("Y-m-d");
  	}else{
  		dateFrom=""	
  		return;
  	}
  	var dateTo=obj.ItemCatDateTo.getValue();
  	if(dateTo!=""){
  		dateTo=dateTo.format("Y-m-d");	
  		if(dateTo<dateFrom){
 	  		Ext.MessageBox.show({
	           title: 'Failed',
	           msg: '开始日期不能大于结束日期!',
	           buttons: Ext.MessageBox.OK,
	           icon:Ext.MessageBox.WARNING
				}); //统一提示风格 Modified By Liyang 2011-05-26   			
  			//alert("开始日期不能大于结束日期")
  			return;	
  		}
  	}else{
  		dateTo=""	
  	}
  	var UpdateStepItemCatMethod=document.getElementById('UpdateStepItemCatMethod')
  	if(UpdateStepItemCatMethod){
  		var encmeth=UpdateStepItemCatMethod.value;	
  	}else{
  		var encmeth=""	
  	}
  	var updateVal=cspRunServerMethod(encmeth,obj.ItemRowid,code,desc,dateFrom,dateTo)
  	if(updateVal<0){
  		Ext.MessageBox.show({
           title: 'Failed',
           msg: '修改失败!',
           buttons: Ext.MessageBox.OK,
           icon:Ext.MessageBox.WARNING
		});
  	}else{
		obj.StepItemCatGridStore.load({});
		obj.ClearItem();
  	}
  }
  obj.DeleteItem=function(){
  		if(obj.ItemRowid==""){
	  		Ext.MessageBox.show({
	           title: 'Failed',
	           msg: '请选择要删除的记录!',
	           buttons: Ext.MessageBox.OK,
	           icon:Ext.MessageBox.WARNING
				}); //统一提示风格 Modified By Liyang 2011-05-26  			
  			//alert("请选择要删除的记录")	
  			return;
  		}
  		Ext.MessageBox.confirm('删除', '确定删除这个项目大类?', function(btn,text){
				if(btn=="yes"){
        	var DeleteStepItemCatMethod=document.getElementById('DeleteStepItemCatMethod');
		  		if(DeleteStepItemCatMethod){
		  			var encmeth=DeleteStepItemCatMethod.value;	
		  		}else{
		  			var encmeth=""	
		  		}
		  		var deleteVal=cspRunServerMethod(encmeth,obj.ItemRowid)
		  		if(deleteVal<0){
	  				Ext.MessageBox.show({
			           title: 'Failed',
			           msg: '删除失败!',
			           buttons: Ext.MessageBox.OK,
			           icon:Ext.MessageBox.ERROR
					});
		  		}else{
					obj.StepItemCatGridStore.load({});
					obj.ClearItem();
					obj.currRowIndex = -1;	//Modified by zhaoyu 2012-12-05 临床路径维护-项目大类-删除信息后，添加新的数据，提示“已经建立的大类不允许修改” 194
	  			}
        }
       });
  		
  }
  obj.ItemSelected=function(sm, rowIdx, r){
  	if(obj.currRowIndex != rowIdx)
  	{
	  	var record=obj.StepItemCatGrid.getSelectionModel().getSelected();	
	  	obj.ItemRowid=record.get('Rowid');
	  	obj.ItemCatCode.setValue(record.get('Code'));
		obj.ItemCatCode.disable(true);
	  	obj.ItemCatDesc.setValue(record.get('Desc'));
	  	obj.ItemCatDateFrom.setValue(record.get('DateFrom'));
	  	obj.ItemCatDateTo.setValue(record.get('DateTo'));
	  	obj.currRowIndex = rowIdx;
  	}
  	else
  	{
 	  	obj.ItemRowid="";
	  	obj.ItemCatCode.setValue("");
	  	obj.ItemCatCode.enable(true);
	  	obj.ItemCatDesc.setValue("");
	  	obj.ItemCatDateFrom.setRawValue("");
	  	obj.ItemCatDateTo.setRawValue(""); 	
	  	obj.ItemCatCode.focus();	
  		obj.currRowIndex = -1;
  	}
  		
  }
  
  obj.btnSaveOnclick = function()
  {
  	if(obj.currRowIndex == -1)
  	{
  		obj.AddItemCat();
  	}
  	else
  	{
	  	obj.UpdateItem();
  		
  	}
  }
}

