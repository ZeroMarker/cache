

function DeptPathWayEvent(obj) {
	obj.LoadEvent = function()
  {};
 	obj.ToDeptPathGrid=function(selections){      //向临床路径所属科室的grid里添加科室
			var deptModel=obj.AllDeptGrid.getSelectionModel();
  		var pathDeptModel=obj.PathWayOfDeptGrid.getSelectionModel()
			if(selections.length==0){
  			alert("请选择科室")
  			return;	
  		}
  		if(obj.pathWayRowid==""){
  			alert("请选择临床路径")
  			return	
  		}
  		pathDeptModel.clearSelections()
  		Ext.each(selections, function(item) {   
  			
  												//选择的临床路径和已经有的临床路径有相同时刚不能添加。
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
		                        
		                        //保存到数据库
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
				ExtTool.alert("提示"," 指定科室失败!");
				return false;
			}else{
					obj.PathWayOfDeptStore.load({});
					obj.RefreshVerTree(); //Add By LiYang 2011-02-19保存后自动刷新科室常用列表 
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
				ExtTool.alert("提示"," 移出失败!");
				return false;
			}else{
					obj.PathWayOfDeptStore.load({});
					obj.RefreshVerTree();//Add By LiYang 2011-02-19保存后自动刷新科室常用列表
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

