

function PathWayEpEvent(obj) {
	var EpService = ExtTool.StaticServerObject("web.DHCCPW.MRC.PathWayEp");
	obj.LoadEvent = function()
  {};
  obj.AddPahtWayEp=function(){              //为指定的临床路径添加一条阶段。
  		var desc=obj.PathWayEpDesc.getValue();
  		if(desc==""){
  			Ext.MessageBox.show({
	           title: 'Failed',
	           msg: '描述不能为空!',
	           buttons: Ext.MessageBox.OK,
	           icon:Ext.MessageBox.WARNING
				}); //Modified By LiYang 2011-05-28 提示统一风格  			
  			//alert("描述不能为空")
  			return;	
  		}
  		var episode=obj.PathWayEpnum.getValue();
  		if(episode==""){
  			Ext.MessageBox.show({
	           title: 'Failed',
	           msg: '序号不能为空!',
	           buttons: Ext.MessageBox.OK,
	           icon:Ext.MessageBox.WARNING
				}); //Modified By LiYang 2011-05-28 提示统一风格   			
  			//alert("序号不能为空")
  			return;
  		}
  		//检查序号是否重复
  		var checkVal=EpService.CheckSameEpisode(episode,obj.pathRowid,"")
  		if(checkVal==1){
  			Ext.MessageBox.show({
	           title: 'Failed',
	           msg: '序号有重复，请重新输入!',
	           buttons: Ext.MessageBox.OK,
	           icon:Ext.MessageBox.WARNING
				}); //Modified By LiYang 2011-05-28 提示统一风格     			
  			//alert("序号有重复，请重新输入")
  			return	
  		}
  		//检查序号是否重复
  		var notes=obj.PathWayEpNote.getValue();
  		var AddPathWayEpMethod=document.getElementById('AddPathWayEpMethod');
  		if(AddPathWayEpMethod){
  			var encmeth=AddPathWayEpMethod.value;
  		}else{
  			var encmeth=""	
  		}
  		var addVal=cspRunServerMethod(encmeth,obj.pathRowid,desc,episode,notes)
  		if(addVal<0){
  			Ext.MessageBox.show({
	           title: 'Failed',
	           msg: '添加失败!',
	           buttons: Ext.MessageBox.OK,
	           icon:Ext.MessageBox.WARNING
			});
  		}else{
			obj.PathWayEpGridStore.load({});
			//Modified By LiYang 2010-12-25 暂时禁止刷新主界面的树形控件
			//var mainPanel=Ext.getCmp('main-tree')
			//var rootNode=mainPanel.getNodeById(obj.pathRowid)
			//if(rootNode){                           //判断指定id的结点是否存在，如果存在就在此结点下添加子结点。
			//    var treeLoader=mainPanel.getLoader()
			//		var rootNode=mainPanel.getNodeById(obj.pathRowid)
			//		treeLoader.load(rootNode);
			 
			//}
			obj.PathWayEpClear();
			window.parent.RefreshContentTree();    //by wuqk  2011-07-27  刷新路径内容树
  		}
  } 
	obj.setEpisode=function(){
		var GetNewEpisodeMethod=document.getElementById('GetNewEpisodeMethod');
		if(GetNewEpisodeMethod){
			var encmeth=GetNewEpisodeMethod.value;	
		}else{
			var encmeth=""	
		}
		var episode=cspRunServerMethod(encmeth,obj.pathRowid);
		obj.PathWayEpnum.setValue(episode);
	}
	obj.PathWayEpClear=function(){
		obj.pathWayEpRowid=""
		obj.PathWayEpDesc.setValue("");
		obj.PathWayEpnum.setValue("");
		obj.setEpisode();
		obj.PathWayEpNote.setValue();
		obj.PathWayEpGrid.getSelectionModel().clearSelections()   //取消选中。
	}
	obj.PathWayEpSelect=function(){
		var record=obj.PathWayEpGrid.getSelectionModel().getSelected();
		obj.pathWayEpRowid=record.get('Rowid');
		obj.PathWayEpDesc.setValue(record.get('desc'))
		obj.PathWayEpnum.setValue(record.get('episode'))
		obj.PathWayEpNote.setValue(record.get('notes'))
	}
	obj.UpdatePathWayEp=function(){     //修改指定的临床路径的一个阶段。
			if(obj.pathWayEpRowid==""){
  			Ext.MessageBox.show({
	           title: 'Failed',
	           msg: '请选择一条记录!',
	           buttons: Ext.MessageBox.OK,
	           icon:Ext.MessageBox.WARNING
				}); //Modified By LiYang 2011-05-28 提示统一风格     					
				//alert("请选择一条记录")	
				return;
			}
			var desc=obj.PathWayEpDesc.getValue();
  		if(desc==""){
  			Ext.MessageBox.show({
	           title: 'Failed',
	           msg: '描述不能为空!',
	           buttons: Ext.MessageBox.OK,
	           icon:Ext.MessageBox.WARNING
				}); //Modified By LiYang 2011-05-28 提示统一风格    			
  			//alert("描述不能为空")
  			return;	
  		}
  		var episode=obj.PathWayEpnum.getValue();
  		if(episode==""){
  			Ext.MessageBox.show({
	           title: 'Failed',
	           msg: '序号不能为空!',
	           buttons: Ext.MessageBox.OK,
	           icon:Ext.MessageBox.WARNING
				}); //Modified By LiYang 2011-05-28 提示统一风格     			
  			//alert("序号不能为空")
  			return;
  		}
  		//检查序号是否重复
  		var checkVal=EpService.CheckSameEpisode(episode,obj.pathRowid,obj.pathWayEpRowid)
  		if(checkVal==1){
  			alert("序号有重复，请重新输入")
  			return	
  		}
  		//检查序号是否重复
  		var notes=obj.PathWayEpNote.getValue();
  		var UpdatePathWayEpMethod=document.getElementById('UpdatePathWayEpMethod')
  		if(UpdatePathWayEpMethod){
  			var encmeth=UpdatePathWayEpMethod.value;	
  		}else{
  			var encmeth=""	
  		}
  		var updateVal=cspRunServerMethod(encmeth,obj.pathWayEpRowid,desc,episode,notes)
  		if(updateVal<0){
  			Ext.MessageBox.show({
	           title: 'Failed',
	           msg: '修改失败!',
	           buttons: Ext.MessageBox.OK,
	           icon:Ext.MessageBox.WARNING
			});
  		}else{
			obj.PathWayEpGridStore.load({});
			//Modified By LiYang 2010-12-25 因为不是同一个Window所以暂时不刷新树形控件
			//var mainPanel=Ext.getCmp('main-tree')
			//var updateNode=mainPanel.getNodeById(obj.pathWayEpRowid)
			//if(updateNode){
			//	updateNode.setText(desc+" "+episode)	
			//}
			//mainPanel.loadEpisode(pathNode)
			obj.PathWayEpClear();
			window.parent.RefreshContentTree();    //by wuqk  2011-07-27  刷新路径内容树
  		}
	}
	obj.DeletePathWayEp=function(){
			if(obj.pathWayEpRowid==""){
				Ext.MessageBox.show({
		           title: 'Failed',
		           msg: '请选择一条记录!',
		           buttons: Ext.MessageBox.OK,
		           icon:Ext.MessageBox.ERROR
				});				//Modified By LiYang 2011-05-21 统一风格
				//alert("请选择一条记录")	
				return;
			}
			//Update By NiuCaicai 2011-07-21 FixBug:121 临床路径维护--基础信息维护-路径表单维护-删除表单项目时提示信息有误
			Ext.MessageBox.confirm('删除', '确定删除这个阶段?', function(btn,text){
			//Ext.MessageBox.confirm('删除', '确定删除这个项目大类?', function(btn,text){
				if(btn=="yes"){
					var DeletePathWayEpMethod=document.getElementById('DeletePathWayEpMethod');
					if(DeletePathWayEpMethod){
						var encmeth=DeletePathWayEpMethod.value;	
					}else{
						var encmeth=""	
					}
					var deleteVal=cspRunServerMethod(encmeth,obj.pathWayEpRowid);
					if(deleteVal<0){
						Ext.MessageBox.show({
				           title: 'Failed',
				           msg: '删除失败!',
				           buttons: Ext.MessageBox.OK,
				           icon:Ext.MessageBox.ERROR
						});
					}else{
						obj.PathWayEpGridStore.load({});
						//Modified By LiYang 2010-12-25 因为不是同一个Window所以暂时不刷新树形控件
						//var mainPanel=Ext.getCmp('main-tree')
						//var node=mainPanel.getNodeById(obj.pathWayEpRowid)
						//if(node){
						//	node.remove();
						//}
						
						obj.PathWayEpClear();
		  			window.parent.RefreshContentTree();    //by wuqk  2011-07-27  刷新路径内容树
					}
				}
			});
	}
}

