

function PathWayDeptEvent(obj) {
	obj.LoadEvent = function()
  	{   
	 };
		
	obj.SelectDept=function(){
		//alert(obj.DeptCom.getValue())
		obj.DeptPathStore.load({});	
		obj.AllPathWayStore.load({});
	}
	obj.SelectCPWType=function(){
		obj.AllPathWayStore.load({});
	}
	obj.CPWKey_specialKey = function(field, e) {
		if (e.getKey() != Ext.EventObject.ENTER) return;
		obj.AllPathWayStore.load({});
	}
	obj.BtnRightClick=function(){  //��ָ���Ŀ�������ٴ�·��
		
		var pathModel=obj.AllPathWayGrid.getSelectionModel();
		var DeptPathModel=obj.DeptPathGrid.getSelectionModel()
		var selections=pathModel.getSelections()
		obj.ToDeptPathGrid(selections)
	  
	}
	obj.BtnLeftClick=function(){
		var pathModel=obj.AllPathWayGrid.getSelectionModel();
		var DeptPathModel=obj.DeptPathGrid.getSelectionModel()
		var selections=DeptPathModel.getSelections()
		obj.ToAllPathWayGrid(selections)
	}
	obj.onRowClick=function(g, rowIndex, e){
		var pathModel=obj.AllPathWayGrid.getSelectionModel();
		var lastClickIndex=obj.lastClickIndex
		if(lastClickIndex==rowIndex){
			pathModel.deselectRow(rowIndex)
			obj.lastClickIndex=-1
		}else{
			obj.lastClickIndex=rowIndex
		}
	}
	obj.onRowClick_Dept=function(g, rowIndex, e){
		var DeptPathModel=obj.DeptPathGrid.getSelectionModel()
		var lastClickIndex=obj.lastClickIndex_Dept;
		if(lastClickIndex==rowIndex){
			DeptPathModel.deselectRow(rowIndex);
			obj.lastClickIndex_Dept=-1;
		}else{
			obj.lastClickIndex_Dept=rowIndex;
		}
	}
	obj.saveDeptPath=function(deptRowid,pathRowid){
		try{
			var DeptPathServer = ExtTool.StaticServerObject("web.DHCCPW.MRC.DeptPahtWay");
			var ret = DeptPathServer.AddDeptPath(deptRowid,pathRowid);
			if(ret<0) {
				ExtTool.alert("��ʾ"," ָ������ʧ��!");
				return false;
			}else{
				obj.DeptPathStore.load({});
				window.parent.RefreshPathVerFn(); //Add By LiYang 2011-02-19�Զ�ˢ�¿��ҳ����б�
				return true;
			}
		}catch(err){
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
			return false;
		}
	}
	obj.deleteDeptPath=function(deptRowid,pathRowid){
		try{
			var DeptPathServer = ExtTool.StaticServerObject("web.DHCCPW.MRC.DeptPahtWay");
			var ret = DeptPathServer.DeleteDeptPath(deptRowid,pathRowid);
			if(ret<0) {
				ExtTool.alert("��ʾ"," �Ƴ�ʧ��!");
				return false;
			}else{
				obj.DeptPathStore.load({});
				window.parent.RefreshPathVerFn(); //Add By LiYang 2011-02-19�Զ�ˢ�¿��ҳ����б�
				return true;
			}
		}catch(err){
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
			return false;
		}	
	}
	obj.ToDeptPathGrid=function(selections){      //����ҳ����ٴ�·����grid������ٴ�·��
		var pathModel=obj.AllPathWayGrid.getSelectionModel();
		var DeptPathModel=obj.DeptPathGrid.getSelectionModel()
		if(selections.length==0){
			alert("��ѡ���ٴ�·��");
			return;
		}
		if(obj.DeptCom.getValue()==""){
			alert("��ѡ�����");
			return;
		}
		DeptPathModel.clearSelections();
		Ext.each(selections, function(item) {   
			
			//ѡ����ٴ�·�����Ѿ��е��ٴ�·������ͬʱ�ղ�����ӡ�
			var checkVal=false
			var pathRowid=item.get('ID')
			var items=obj.DeptPathGrid.getStore().data.items;
			var len=items.length;
			for(var i=0;i<len;i++){
				var record=items[i].data;
				if(pathRowid==record['ID']){
					checkVal=true;
					break;
				}	
			}
			if(!checkVal){
		  	obj.DeptPathGrid.store.add(item);
		  	obj.addDeptPath.push(item);
		  	
		  	//���浽���ݿ�
		  	obj.saveDeptPath(obj.DeptCom.getValue(),pathRowid);
		  }
	  	//obj.AllPathWayGrid.store.remove(item)   
	  });  
	  pathModel.clearSelections(); 
	  DeptPathModel.selectRecords(selections);	
	}
	obj.ToAllPathWayGrid=function(selections){       //�ӿ��ҳ����ٴ�·�����Ƴ���¼
		var pathModel=obj.AllPathWayGrid.getSelectionModel();
		var DeptPathModel=obj.DeptPathGrid.getSelectionModel();
		if(selections.length==0){
			alert("��ѡ���ٴ�·��");
			return;	
		}
		Ext.each(selections, function(item) {   
				//obj.AllPathWayGrid.store.add(item) 
				//obj.DeptPathGrid.store.remove(item) 
				var pathRowid=item.get('Rowid')
				var delVal=obj.deleteDeptPath(obj.DeptCom.getValue(),pathRowid); 
				if(delVal){  
					obj.DeptPathGrid.store.remove(item);
				}
		}); 
		//pathModel.selectRecords(selections)	
	}
	
	//���泣�ÿ����ٴ�·���б���Զ�ˢ�¿��ҳ����ٴ�·���б� 
	obj.RefreshVerTree = function()
	{
		window.parent.RefreshDepPath();
	}
}

