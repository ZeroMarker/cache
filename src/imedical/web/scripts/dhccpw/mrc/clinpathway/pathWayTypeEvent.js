

function pathWayTypeEvent(obj) {
	
	obj.currRowIndex = -1; //Modified By LiYang 2011-05-28 去除添加按钮
	
	obj.LoadEvent = function()
  {};
  obj.PathTypeAdd_click = function(){                 //添加类型方法
  	var code=obj.PathTypeCode.getValue();
  	var desc=obj.PathTypeDesc.getValue();
  	if(code==""){
 		Ext.MessageBox.show({
			title: 'Failed',
			msg: 'Code不能为空!',
			buttons: Ext.MessageBox.OK,
			icon:Ext.MessageBox.ERROR
		}); //Modified By LiYang 2011-05-21 FixBug:55 临床路径维护--基础字典维护-路径类型维护-建议统一提示信息框的显示风格 		
  		//alert("Code不能为空")
  		return	
  	}
  	if(desc==""){
 		Ext.MessageBox.show({
			title: 'Failed',
			msg: '类型名称不能为空!',
			buttons: Ext.MessageBox.OK,
			icon:Ext.MessageBox.ERROR
		}); //Modified By LiYang 2011-05-21 FixBug:55 临床路径维护--基础字典维护-路径类型维护-建议统一提示信息框的显示风格 		  		
  		//alert("类型名称不能为空")
  		return	
  	}
		var CheckTypeCodeMethod=document.getElementById('CheckTypeCodeMethod');
		if(CheckTypeCodeMethod){
			var encmeth=CheckTypeCodeMethod.value;	
		}else{
			var encmeth=""	
		}
		var checkCodeVal=cspRunServerMethod(encmeth,code,"");
		if(checkCodeVal==1){
	 		Ext.MessageBox.show({
				title: 'Failed',
				msg: 'Code有重复的，请重新添加!',
				buttons: Ext.MessageBox.OK,
				icon:Ext.MessageBox.ERROR
			}); //Modified By LiYang 2011-05-21 FixBug:55 临床路径维护--基础字典维护-路径类型维护-建议统一提示信息框的显示风格 		  				
			//alert("Code有重复的，请重新添加")
			return;	
		}
		var AddTypeCodeMethod=document.getElementById('AddTypeCodeMethod')
		if(AddTypeCodeMethod){
			var encmeth=AddTypeCodeMethod.value;
		}else{
			var encmeth=""	
		}
		var addVal=cspRunServerMethod(encmeth,code,desc);
		if(addVal>=0){
			obj.PathTypeGridStore.load({});	
			obj.ClearAllValue();
			//Ext.getCmp("way-tree").loadTypes();
		}else{
			Ext.MessageBox.show({
				title: 'Failed',
				msg: '添加失败!',
				buttons: Ext.MessageBox.OK,
				icon:Ext.MessageBox.ERROR
			});
		}
	
	};
	obj.updateType=function(){
		var code=obj.PathTypeCode.getValue();
  	var desc=obj.PathTypeDesc.getValue();
  	if(code==""){
	 	Ext.MessageBox.show({
			title: 'Failed',
			msg: 'Code不能为空!',
			buttons: Ext.MessageBox.OK,
			icon:Ext.MessageBox.ERROR
		}); //Modified By LiYang 2011-05-21 FixBug:55 临床路径维护--基础字典维护-路径类型维护-建议统一提示信息框的显示风格 		  		
		//alert("Code不能为空")
  		return	
  	}
  	if(desc==""){
 	 	Ext.MessageBox.show({
			title: 'Failed',
			msg: '类型名称不能为空!',
			buttons: Ext.MessageBox.OK,
			icon:Ext.MessageBox.ERROR
		}); //Modified By LiYang 2011-05-21 FixBug:55 临床路径维护--基础字典维护-路径类型维护-建议统一提示信息框的显示风格 		  		
  		//alert("类型名称不能为空")
  		return	
  	}
		var CheckTypeCodeMethod=document.getElementById('CheckTypeCodeMethod');
		if(CheckTypeCodeMethod){
			var encmeth=CheckTypeCodeMethod.value;	
		}else{
			var encmeth=""	
		}
		var checkCodeVal=cspRunServerMethod(encmeth,code,obj.typeRowid1);
		if(checkCodeVal==1){
 	 	Ext.MessageBox.show({
			title: 'Failed',
			msg: 'Code有重复的，请重新添加!',
			buttons: Ext.MessageBox.OK,
			icon:Ext.MessageBox.ERROR
		}); //Modified By LiYang 2011-05-21 FixBug:55 临床路径维护--基础字典维护-路径类型维护-建议统一提示信息框的显示风格 		  		
//			alert("Code有重复的，请重新添加")
			return;	
		}
		if(obj.typeRowid1==""){
			return;	
		}
		var UpdateTypeMethod=document.getElementById('UpdateTypeMethod')
		if(UpdateTypeMethod){
			var encmeth=UpdateTypeMethod.value;	
		}else{
			var encmeth=""	
		}
		var updateVal=cspRunServerMethod(encmeth,obj.typeRowid1,code,desc);
		if(updateVal>=0){
				obj.PathTypeGridStore.load({});	
				//var pathPanel=Ext.getCmp("way-tree")
				//var typeNode=pathPanel.getNodeById(obj.typeRowid1+"_type")
				//typeNode.setText(desc)
				obj.ClearAllValue();
				//Add By Niucaicai 2011-07-19 FixBug:92 临床路径维护-基础信息维护-路径类型维护-删除一条记录后不能保存新的记录
				obj.currRowIndex = -1;
		}else{
			Ext.MessageBox.show({
				title: 'Failed',
				msg: '修改失败!',
				buttons: Ext.MessageBox.OK,
				icon:Ext.MessageBox.ERROR
			});
		}
	};
	obj.rowSelect=function(sm, rowIdx, r){
		//当选择grid中的个一行时所触发的事件
		if(obj.currRowIndex != rowIdx)
		{
			var record=obj.PathTypeGrid.getSelectionModel().getSelected();    //获得所选中的一行的Record对象
			obj.typeRowid1=record.get("typeRowid");
			obj.PathTypeCode.setValue(record.get("typeCode"));
			obj.PathTypeDesc.setValue(record.get("typeDesc"));		
			if (record.get("typeCode")=="SYNDROME"){    //add by wuqk 2011-07-21 并发症类型不能修改
				obj.PathTypeCode.setDisabled(true);
				obj.PathTypeDesc.setDisabled(true);
			}
			else{
				obj.PathTypeCode.setDisabled(false);
				obj.PathTypeDesc.setDisabled(false);
			}
			obj.currRowIndex = rowIdx;
		}
		else
		{
			obj.PathTypeCode.setDisabled(false);
			obj.PathTypeDesc.setDisabled(false);
			obj.typeRowid1="";
			obj.PathTypeCode.setValue("");
			obj.PathTypeDesc.setValue("");				
			obj.currRowIndex = -1;
		}

	};
	obj.deleteType=function(){
		if(obj.typeRowid1==""){
	 	 	Ext.MessageBox.show({
				title: 'Failed',
				msg: '请选择一行!',
				buttons: Ext.MessageBox.OK,
				icon:Ext.MessageBox.ERROR
			}); //Modified By LiYang 2011-05-21 FixBug:55 临床路径维护--基础字典维护-路径类型维护-建议统一提示信息框的显示风格 		  		
			//alert("请选择一行")
			return;	
		}	
		Ext.MessageBox.confirm('删除', '确定删除这个临床路径类型吗？', function(btn,text){
    			if(btn=="yes"){
						var DeleteTypeMethod=document.getElementById('DeleteTypeMethod')
						if(DeleteTypeMethod){
							var encmeth=DeleteTypeMethod.value;	
						}else{
							var encmeth=""
						}
						var deleteVal=cspRunServerMethod(encmeth,obj.typeRowid1);
						if(deleteVal>=0){
							obj.PathTypeGridStore.load({});
							//var pathPanel=Ext.getCmp("way-tree")
							//var typeNode=pathPanel.getNodeById(obj.typeRowid1+"_type")
							//typeNode.remove();
							obj.ClearAllValue();
							//Add By Niucaicai 2011-07-19 FixBug:92 临床路径维护-基础信息维护-路径类型维护-删除一条记录后不能保存新的记录
							obj.currRowIndex = -1;
						}else{
							Ext.MessageBox.show({
					           title: 'Failed',
					           msg: '删除失败!',
					           buttons: Ext.MessageBox.OK,
					           icon:Ext.MessageBox.ERROR
					   		});	
						}
           }
    });
		
		
	}
	obj.ClearAllValue=function(){
		obj.typeRowid1="";
		obj.PathTypeCode.reset();	
		obj.PathTypeDesc.reset();
		obj.PathTypeGrid.getSelectionModel().clearSelections()
		
	}
	
	obj.btnSaveOnclick = function()
	{
		if(obj.currRowIndex == -1)
		{
			obj.PathTypeAdd_click();
		}
		else
		{
			obj.updateType();
		}
			
	}
}