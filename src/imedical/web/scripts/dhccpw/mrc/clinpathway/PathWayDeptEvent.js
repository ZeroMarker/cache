

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
	obj.BtnRightClick=function(){  //向指定的科室添加临床路径
		
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
				ExtTool.alert("提示"," 指定科室失败!");
				return false;
			}else{
				obj.DeptPathStore.load({});
				window.parent.RefreshPathVerFn(); //Add By LiYang 2011-02-19自动刷新科室常用列表
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
				ExtTool.alert("提示"," 移出失败!");
				return false;
			}else{
				obj.DeptPathStore.load({});
				window.parent.RefreshPathVerFn(); //Add By LiYang 2011-02-19自动刷新科室常用列表
				return true;
			}
		}catch(err){
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
			return false;
		}	
	}
	obj.ToDeptPathGrid=function(selections){      //向科室常用临床路径的grid里添加临床路径
		var pathModel=obj.AllPathWayGrid.getSelectionModel();
		var DeptPathModel=obj.DeptPathGrid.getSelectionModel()
		if(selections.length==0){
			alert("请选择临床路径");
			return;
		}
		if(obj.DeptCom.getValue()==""){
			alert("请选择科室");
			return;
		}
		DeptPathModel.clearSelections();
		Ext.each(selections, function(item) {   
			
			//选择的临床路径和已经有的临床路径有相同时刚不能添加。
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
		  	
		  	//保存到数据库
		  	obj.saveDeptPath(obj.DeptCom.getValue(),pathRowid);
		  }
	  	//obj.AllPathWayGrid.store.remove(item)   
	  });  
	  pathModel.clearSelections(); 
	  DeptPathModel.selectRecords(selections);	
	}
	obj.ToAllPathWayGrid=function(selections){       //从科室常用临床路径中移出记录
		var pathModel=obj.AllPathWayGrid.getSelectionModel();
		var DeptPathModel=obj.DeptPathGrid.getSelectionModel();
		if(selections.length==0){
			alert("请选择临床路径");
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
	
	//保存常用科室临床路径列表后自动刷新科室常用临床路径列表 
	obj.RefreshVerTree = function()
	{
		window.parent.RefreshDepPath();
	}
}

