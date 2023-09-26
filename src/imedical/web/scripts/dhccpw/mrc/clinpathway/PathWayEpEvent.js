

function PathWayEpEvent(obj) {
	var EpService = ExtTool.StaticServerObject("web.DHCCPW.MRC.PathWayEp");
	obj.LoadEvent = function()
  {};
  obj.AddPahtWayEp=function(){              //Ϊָ�����ٴ�·�����һ���׶Ρ�
  		var desc=obj.PathWayEpDesc.getValue();
  		if(desc==""){
  			Ext.MessageBox.show({
	           title: 'Failed',
	           msg: '��������Ϊ��!',
	           buttons: Ext.MessageBox.OK,
	           icon:Ext.MessageBox.WARNING
				}); //Modified By LiYang 2011-05-28 ��ʾͳһ���  			
  			//alert("��������Ϊ��")
  			return;	
  		}
  		var episode=obj.PathWayEpnum.getValue();
  		if(episode==""){
  			Ext.MessageBox.show({
	           title: 'Failed',
	           msg: '��Ų���Ϊ��!',
	           buttons: Ext.MessageBox.OK,
	           icon:Ext.MessageBox.WARNING
				}); //Modified By LiYang 2011-05-28 ��ʾͳһ���   			
  			//alert("��Ų���Ϊ��")
  			return;
  		}
  		//�������Ƿ��ظ�
  		var checkVal=EpService.CheckSameEpisode(episode,obj.pathRowid,"")
  		if(checkVal==1){
  			Ext.MessageBox.show({
	           title: 'Failed',
	           msg: '������ظ�������������!',
	           buttons: Ext.MessageBox.OK,
	           icon:Ext.MessageBox.WARNING
				}); //Modified By LiYang 2011-05-28 ��ʾͳһ���     			
  			//alert("������ظ�������������")
  			return	
  		}
  		//�������Ƿ��ظ�
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
	           msg: '���ʧ��!',
	           buttons: Ext.MessageBox.OK,
	           icon:Ext.MessageBox.WARNING
			});
  		}else{
			obj.PathWayEpGridStore.load({});
			//Modified By LiYang 2010-12-25 ��ʱ��ֹˢ������������οؼ�
			//var mainPanel=Ext.getCmp('main-tree')
			//var rootNode=mainPanel.getNodeById(obj.pathRowid)
			//if(rootNode){                           //�ж�ָ��id�Ľ���Ƿ���ڣ�������ھ��ڴ˽��������ӽ�㡣
			//    var treeLoader=mainPanel.getLoader()
			//		var rootNode=mainPanel.getNodeById(obj.pathRowid)
			//		treeLoader.load(rootNode);
			 
			//}
			obj.PathWayEpClear();
			window.parent.RefreshContentTree();    //by wuqk  2011-07-27  ˢ��·��������
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
		obj.PathWayEpGrid.getSelectionModel().clearSelections()   //ȡ��ѡ�С�
	}
	obj.PathWayEpSelect=function(){
		var record=obj.PathWayEpGrid.getSelectionModel().getSelected();
		obj.pathWayEpRowid=record.get('Rowid');
		obj.PathWayEpDesc.setValue(record.get('desc'))
		obj.PathWayEpnum.setValue(record.get('episode'))
		obj.PathWayEpNote.setValue(record.get('notes'))
	}
	obj.UpdatePathWayEp=function(){     //�޸�ָ�����ٴ�·����һ���׶Ρ�
			if(obj.pathWayEpRowid==""){
  			Ext.MessageBox.show({
	           title: 'Failed',
	           msg: '��ѡ��һ����¼!',
	           buttons: Ext.MessageBox.OK,
	           icon:Ext.MessageBox.WARNING
				}); //Modified By LiYang 2011-05-28 ��ʾͳһ���     					
				//alert("��ѡ��һ����¼")	
				return;
			}
			var desc=obj.PathWayEpDesc.getValue();
  		if(desc==""){
  			Ext.MessageBox.show({
	           title: 'Failed',
	           msg: '��������Ϊ��!',
	           buttons: Ext.MessageBox.OK,
	           icon:Ext.MessageBox.WARNING
				}); //Modified By LiYang 2011-05-28 ��ʾͳһ���    			
  			//alert("��������Ϊ��")
  			return;	
  		}
  		var episode=obj.PathWayEpnum.getValue();
  		if(episode==""){
  			Ext.MessageBox.show({
	           title: 'Failed',
	           msg: '��Ų���Ϊ��!',
	           buttons: Ext.MessageBox.OK,
	           icon:Ext.MessageBox.WARNING
				}); //Modified By LiYang 2011-05-28 ��ʾͳһ���     			
  			//alert("��Ų���Ϊ��")
  			return;
  		}
  		//�������Ƿ��ظ�
  		var checkVal=EpService.CheckSameEpisode(episode,obj.pathRowid,obj.pathWayEpRowid)
  		if(checkVal==1){
  			alert("������ظ�������������")
  			return	
  		}
  		//�������Ƿ��ظ�
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
	           msg: '�޸�ʧ��!',
	           buttons: Ext.MessageBox.OK,
	           icon:Ext.MessageBox.WARNING
			});
  		}else{
			obj.PathWayEpGridStore.load({});
			//Modified By LiYang 2010-12-25 ��Ϊ����ͬһ��Window������ʱ��ˢ�����οؼ�
			//var mainPanel=Ext.getCmp('main-tree')
			//var updateNode=mainPanel.getNodeById(obj.pathWayEpRowid)
			//if(updateNode){
			//	updateNode.setText(desc+" "+episode)	
			//}
			//mainPanel.loadEpisode(pathNode)
			obj.PathWayEpClear();
			window.parent.RefreshContentTree();    //by wuqk  2011-07-27  ˢ��·��������
  		}
	}
	obj.DeletePathWayEp=function(){
			if(obj.pathWayEpRowid==""){
				Ext.MessageBox.show({
		           title: 'Failed',
		           msg: '��ѡ��һ����¼!',
		           buttons: Ext.MessageBox.OK,
		           icon:Ext.MessageBox.ERROR
				});				//Modified By LiYang 2011-05-21 ͳһ���
				//alert("��ѡ��һ����¼")	
				return;
			}
			//Update By NiuCaicai 2011-07-21 FixBug:121 �ٴ�·��ά��--������Ϣά��-·����ά��-ɾ������Ŀʱ��ʾ��Ϣ����
			Ext.MessageBox.confirm('ɾ��', 'ȷ��ɾ������׶�?', function(btn,text){
			//Ext.MessageBox.confirm('ɾ��', 'ȷ��ɾ�������Ŀ����?', function(btn,text){
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
				           msg: 'ɾ��ʧ��!',
				           buttons: Ext.MessageBox.OK,
				           icon:Ext.MessageBox.ERROR
						});
					}else{
						obj.PathWayEpGridStore.load({});
						//Modified By LiYang 2010-12-25 ��Ϊ����ͬһ��Window������ʱ��ˢ�����οؼ�
						//var mainPanel=Ext.getCmp('main-tree')
						//var node=mainPanel.getNodeById(obj.pathWayEpRowid)
						//if(node){
						//	node.remove();
						//}
						
						obj.PathWayEpClear();
		  			window.parent.RefreshContentTree();    //by wuqk  2011-07-27  ˢ��·��������
					}
				}
			});
	}
}

