

function DeptPathWayEvent(obj) {
	obj.LoadEvent = function()
  {};
 	obj.ToDeptPathGrid=function(selections){      //���ٴ�·���������ҵ�grid����ӿ���
			var deptModel=obj.AllDeptGrid.getSelectionModel();
  		var pathDeptModel=obj.PathWayOfDeptGrid.getSelectionModel()
			if(selections.length==0){
  			alert("��ѡ�����")
  			return;	
  		}
  		if(obj.pathWayRowid==""){
  			alert("��ѡ���ٴ�·��")
  			return	
  		}
  		pathDeptModel.clearSelections()
  		Ext.each(selections, function(item) {   
  			
  												//ѡ����ٴ�·�����Ѿ��е��ٴ�·������ͬʱ�ղ�����ӡ�
  												var checkVal=false
  												var deptRowid=item.get('Rowid')
  												var items=obj.PathWayOfDeptGrid.getStore().data.items;
  												var len=items.length
  												for(var i=0;i<len;i++){
  													var record=items[i].data
  													if(deptRowid==record['Rowid']){
  															checkVal=true;
  															break;
  													}	
  												}
  												if(!checkVal){
		                        obj.PathWayOfDeptGrid.store.add(item) 
		                        //obj.addDeptPath.push(item)
		                        
		                        //���浽���ݿ�
		                        obj.saveDeptPath(deptRowid,obj.pathWayRowid)
		                        
		                        
		                      }
                         //obj.AllPathWayGrid.store.remove(item)   
                      });  
    	deptModel.clearSelections() 
    	pathDeptModel.selectRecords(selections)	
	}
	obj.saveDeptPath=function(deptRowid,pathRowid){   
			try{
			var DeptPathServer = ExtTool.StaticServerObject("web.DHCCPW.MRC.DeptPahtWay");
			var ret = DeptPathServer.AddDeptPath(deptRowid,pathRowid);
			if(ret<0) {
				ExtTool.alert("��ʾ"," ָ������ʧ��!");
				return false;
			}else{
					obj.PathWayOfDeptStore.load({});
					obj.RefreshVerTree(); //Add By LiYang 2011-02-19������Զ�ˢ�¿��ҳ����б� 
					return true
			}
		}catch(err){
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
			return false
		}
	}
	obj.deleteDeptPath=function(deptRowid,pathRowid){
		try{
			var DeptPathServer = ExtTool.StaticServerObject("web.DHCCPW.MRC.DeptPahtWay");
			var ret = DeptPathServer.DeleteDeptPath(deptRowid,pathRowid);
			if(ret!=0) {
				ExtTool.alert("��ʾ"," �Ƴ�ʧ��!");
				return false;
			}else{
					obj.PathWayOfDeptStore.load({});
					obj.RefreshVerTree();//Add By LiYang 2011-02-19������Զ�ˢ�¿��ҳ����б�
					return true
			}
		}catch(err){
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
			return false
		}	
	}
	obj.FindFieldEnter=function(f,e){
		if(e.getKey()===e.ENTER){
			obj.AllDeptStore.load({});
			e.stopPropagation();
		}	
	}

	obj.RefreshVerTree = function()
	{
		window.parent.RefreshDepPath();
		window.alert("AAAA");
	}
}

