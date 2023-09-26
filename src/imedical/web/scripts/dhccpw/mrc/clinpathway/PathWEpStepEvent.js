

function PathWEpStepEvent(obj) {
  var StepService = ExtTool.StaticServerObject("web.DHCCPW.MRC.PathWEpStep");
  obj.LoadEvent = function(){};
  obj.AddStep=function(){
  	var day=obj.StepDay.getValue();
  	if(day==""){
  	  Ext.MessageBox.show({
	          title: '提示',
	          msg: '时间不能为空!',
	          buttons: Ext.MessageBox.OK,
	          icon:Ext.MessageBox.WARNING
			}); //统一提示风格 Modified By Liyang 2011-05-26    		
  		//alert("时间不能为空")
  		return
  	}
  	var dayUnit=obj.cboStepDayUnit.getValue();
  	if(dayUnit==""){
  	  Ext.MessageBox.show({
	          title: '提示',
	          msg: '时间单位不能为空!',
	          buttons: Ext.MessageBox.OK,
	          icon:Ext.MessageBox.WARNING
			}); //统一提示风格 Modified By Liyang 2011-05-26     		
  		//alert("时间单位不能为空")
  		return
  	}
  	var desc=obj.StepDesc.getValue();
	if(desc==""){	//	Modified by zhaoyu 2012-11-16 临床路径维护--路径表单维护-添加步骤，【步骤描述】为空时，提示不明确 缺陷编号189
  	  Ext.MessageBox.show({
	          title: '提示',
	          msg: '步骤描述不能为空!',
	          buttons: Ext.MessageBox.OK,
	          icon:Ext.MessageBox.WARNING
			}); //统一提示风格     		
  		//alert("步骤描述不能为空")
  		return
  	}
  	var dayNum=obj.StepDayNum.getValue();
  	if(dayNum==""){
  	  Ext.MessageBox.show({
	          title: '提示',
	          msg: '步骤序号不能为空!',
	          buttons: Ext.MessageBox.OK,
	          icon:Ext.MessageBox.WARNING
			}); //统一提示风格 Modified By Liyang 2011-05-26      		
  		//alert("步骤序号不能为空")
  		return	
  	}
  	//检查序号是否重复 
  	var checkVal=StepService.CheckSameDayNum(dayNum,obj.EpRowid,"")
  	if(checkVal==1){
  	  Ext.MessageBox.show({
	          title: '提示',
	          msg: '序号有重复，请重新输入!',
	          buttons: Ext.MessageBox.OK,
	          icon:Ext.MessageBox.WARNING
			}); //统一提示风格 Modified By Liyang 2011-05-26    		
  		//alert("序号有重复，请重新输入")
  		return	
  	}
  	//检查序号是否重复
  	var AddStepMethod=document.getElementById('AddStepMethod')
  	if(AddStepMethod){
  		var encmeth=AddStepMethod.value;	
  	}else{
  		var encmeth=""	
  	}
  	var StepTypeCode=obj.cboStepType.getValue();    //add by wuqk 2011-07-25
  	var addVal=cspRunServerMethod(encmeth,obj.EpRowid,day,desc,dayNum,dayUnit,StepTypeCode);
  	if(addVal<0){
  		Ext.MessageBox.show({
           title: 'Failed',
           msg: '添加失败!',
           buttons: Ext.MessageBox.OK,
           icon:Ext.MessageBox.WARNING
		});
  	}else{
		obj.PathWEpStepGridStore.load({});	
		//Modified By LiYang 2010-12-25 暂时禁止刷新主界面的树形控件
		//var stepRowid=Val[1]
		//var mainPanel=Ext.getCmp('main-tree');
		//var epNode=mainPanel.getNodeById(obj.EpRowid);
		//var treeLoader=mainPanel.getLoader() 
		//treeLoader.load(epNode);                     //重新加载新加载的结点的父结点。
		obj.ClearStep();
		window.parent.RefreshContentTree();    //by wuqk  2011-07-27  刷新路径内容树
  	}
  }
  obj.ClearStep=function(){          //清空输入框里的值
  	obj.StepRowid=""
  	obj.StepDay.setValue();
  	obj.cboStepDayUnit.setValue();
  	obj.StepDesc.setValue();
	obj.cboStepType.setValue();	//Add by zhaoyu 2012-11-27 路径表单维护--路径步骤维护--清除步骤类型无效 217
  	obj.StepDayNum.setValue();
  	obj.setStepDayNum();
  	obj.PathWEpStepGrid.getSelectionModel().clearSelections();    //取消选中
  }
  obj.setStepDayNum=function(){
  	var GetNewDayNumMethod=document.getElementById('GetNewDayNumMethod')
  	if(GetNewDayNumMethod){
  		var encmeth=GetNewDayNumMethod.value;	
  	}else{
  		var encmeth=""	
  	}
  	var stepDayNum=cspRunServerMethod(encmeth,obj.EpRowid)
  	obj.StepDayNum.setValue(stepDayNum)
  }
  obj.PathWEpStepSelect=function(){
  	//getSelectionModel().getSelected();
  	var record=obj.PathWEpStepGrid.getSelectionModel().getSelected();
  	obj.StepRowid=record.get('StepRowid');
  	obj.StepDay.setValue(record.get('StepDay'));
  	if (record.get('StepDayUnit')==""){           // add by wuqk 2011-07-25 默认时间单位为天
  		obj.cboStepDayUnit.setValue('D');
  	}
  	else{
  		obj.cboStepDayUnit.setValue(record.get('StepDayUnit'));
  	}
  	obj.cboStepType.setValue(record.get('StepTypeCode'));
  	
  	//obj.cboStepDayUnit.setValue(record.get('StepDayUnit'));
  	//obj.cboStepDayUnit.setRawValue(record.get('StepDayUnitDesc'));
  	obj.StepDesc.setValue(record.get('StepDesc'))
  	obj.StepDayNum.setValue(record.get('StepDayNum'))
  }
  obj.UpdateStep=function(){
  	if(obj.StepRowid==""){
  	  Ext.MessageBox.show({
	          title: '提示',
	          msg: '请选择一条记录!',
	          buttons: Ext.MessageBox.OK,
	          icon:Ext.MessageBox.WARNING
			}); //统一提示风格 Modified By Liyang 2011-05-26    	  		
  		//alert("请选择一条记录")	
  	}
  	var day=obj.StepDay.getValue();
  	if(day==""){
  	  Ext.MessageBox.show({
	          title: '提示',
	          msg: '步骤时间不能为空!',
	          buttons: Ext.MessageBox.OK,
	          icon:Ext.MessageBox.WARNING
			}); //统一提示风格 Modified By Liyang 2011-05-26    		
  		//alert("步骤时间不能为空")
  		return	
  	}
  	var dayUnit=obj.cboStepDayUnit.getValue();
  	if(dayUnit==""){
  	  Ext.MessageBox.show({
	          title: '提示',
	          msg: '步骤时间单位不能为空!',
	          buttons: Ext.MessageBox.OK,
	          icon:Ext.MessageBox.WARNING
			}); //统一提示风格 Modified By Liyang 2011-05-26  	  		
  		//alert("步骤时间单位不能为空")
  		return	
  	}
  	var desc=obj.StepDesc.getValue();
	if(desc==""){	//	Modified by zhaoyu 2012-11-16 临床路径维护--路径表单维护-添加步骤，【步骤描述】为空时，提示不明确 缺陷编号189
  	  Ext.MessageBox.show({
	          title: '提示',
	          msg: '步骤描述不能为空!',
	          buttons: Ext.MessageBox.OK,
	          icon:Ext.MessageBox.WARNING
			}); //统一提示风格     		
  		//alert("步骤描述不能为空")
  		return
  	}
  	var dayNum=obj.StepDayNum.getValue();
  	if(dayNum==""){
  	  Ext.MessageBox.show({
	          title: '提示',
	          msg: '步骤序号不能为空!',
	          buttons: Ext.MessageBox.OK,
	          icon:Ext.MessageBox.WARNING
			}); //统一提示风格 Modified By Liyang 2011-05-26  	  		
  		//alert("步骤序号不能为空")
  		return	
  	}
  	/*
  	var checkVal=StepService.CheckSameDayNum(dayNum,obj.EpRowid,obj.StepRowid)
  	if(checkVal==1){
  		alert("序号有重复，请重新输入")
  		return	
  	}
  	*/
  	var UpdateStepMethod=document.getElementById('UpdateStepMethod')
  	if(UpdateStepMethod){
  		var encmeth=UpdateStepMethod.value;	
  	}else{
  		var encmeth=""	
  	}
  		var StepTypeCode=obj.cboStepType.getValue();    //add by wuqk 2011-07-25
  		var updateVal=cspRunServerMethod(encmeth,obj.StepRowid,day,desc,dayNum,dayUnit,StepTypeCode)
  		if(updateVal<0){
  			Ext.MessageBox.show({
				   title: 'Failed',
				   msg: '修改失败!',
				   buttons: Ext.MessageBox.OK,
				   icon:Ext.MessageBox.WARNING
			});	
  		}else{
			obj.PathWEpStepGridStore.load({});	
			obj.ClearStep();
			/*  bug  // by wuqk 2011-07-21
			var mainPanel=Ext.getCmp('main-tree');                 //main-tree -> objContentTree by wuqk 
			var updateNode=mainPanel.getNodeById(obj.StepRowid1)    //pathWayEpRowid-> StepRowid1 by wuqk 
			if(updateNode){
				updateNode.setText(desc+" "+dayNum+" "+day+"ds")
			}*/
		  window.parent.RefreshContentTree();    //by wuqk  2011-07-27  刷新路径内容树
  		}
  }
  obj.DeleteStep=function(){
  	if(obj.StepRowid==""){
  	  Ext.MessageBox.show({
	          title: '提示',
	          msg: '请选择一条记录!',
	          buttons: Ext.MessageBox.OK,
	          icon:Ext.MessageBox.WARNING
			}); //统一提示风格 Modified By Liyang 2011-05-26  		
  		//alert("请选择一条记录")
		return	//	Modified by zhaoyu 2012-11-27 路径表单维护--路径步骤维护--没有选中任何一项，点击【删除】提示信息有误 190	
  	}
  	//Update By NiuCaicai 2011-07-21 FixBug:121 临床路径维护--基础信息维护-路径表单维护-删除表单项目时提示信息有误
  	Ext.MessageBox.confirm('删除', '确定删除这个步骤?', function(btn,text){
    //Ext.MessageBox.confirm('删除', '确定删除这个阶段?', function(btn,text){
			if(btn=="yes"){
		  	var DeleteStepMethod=document.getElementById('DeleteStepMethod');
		  	if(DeleteStepMethod){
		  		var encmeth=DeleteStepMethod.value;	
		  	}else{
		  		var encmeth=""	
		  	}
		  	var deleteVal=cspRunServerMethod(encmeth,obj.StepRowid)
		  	if(deleteVal<0){
		  		Ext.MessageBox.show({
		           title: 'Failed',
		           msg: '删除失败!',
		           buttons: Ext.MessageBox.OK,
		           icon:Ext.MessageBox.ERROR
				});
		  	}else{
				obj.PathWEpStepGridStore.load({});	
				/*  bug  // by wuqk 2011-07-21
				var mainPanel=Ext.getCmp('main-tree');
				var node=mainPanel.getNodeById(obj.StepRowid)
				if(node){
						node.remove();
				}*/
				obj.ClearStep();
		  	window.parent.RefreshContentTree();    //by wuqk  2011-07-27  刷新路径内容树
		  	}
		  }
		});
  }
  obj.DayKepress=function(textfield,e){    //控制"天数输入栏"只能输入数字。
 
		var allowed = '0123456789';
		var k = e.getKey();
		if (!Ext.isIE && (e.isSpecialKey() || k == e.BACKSPACE || k == e.DELETE)) {
			return;
		}
		var c = e.getCharCode();
		if (allowed.indexOf(String.fromCharCode(c)) === -1) {
			e.stopEvent();
		}

	}
}

