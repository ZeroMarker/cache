
function DeptPathWay(pathNode){
	var obj = new Object();
	//var path=pathNode.id.split("_")
	obj.pathWayRowid="";//path[0]
	obj.findField=new Ext.form.TextField({    //生成用于查询的输入框
    	id:'cpwFind',
    	width:150
    	//height:50
    });
    obj.findBtn=new Ext.Button({     //生成查询按钮
    	id:'cpwFindBtn',
    	text:'查询'	
    });
    obj.findTbar=new Ext.Toolbar({  //生成查询工具栏对象
    		items:[
    			obj.findField,
    			obj.findBtn
    		]
    });
	obj.AllDeptStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.AllDeptStore = new Ext.data.Store({
		proxy: obj.AllDeptStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'code', mapping: 'code'}
			,{name: 'desc', mapping: 'desc'}
		])
	});
	//obj.GridPanel2CheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.AllDeptGrid = new Ext.grid.GridPanel({
		id : 'AllDeptGrid'
		,height : 439
		,buttonAlign : 'center'
		,width : 230
		,region : 'west'
		,store : obj.AllDeptStore,
		ddGroup: 'secondGridDDGroup',
		enableDragDrop   : true,
		stripeRows: true,
		viewConfig: {
           forceFit: true
     }
		,title : '全部科室'
		,columns: [
			{header: '科室名称', width: 200, dataIndex: 'desc', sortable: true}
		],
		 tbar:obj.findTbar
		});
	obj.PathWayOfDeptStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.PathWayOfDeptStore = new Ext.data.Store({
		proxy: obj.PathWayOfDeptStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'code', mapping: 'code'}
			,{name: 'desc', mapping: 'desc'}
		])
	});
	//obj.GridPanel3CheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.PathWayOfDeptGrid = new Ext.grid.GridPanel({
		id : 'PathWayOfDeptGrid'
		,height : 439
		,buttonAlign : 'center'
		,width : 230
		,region : 'center'
		,store : obj.PathWayOfDeptStore,
		ddGroup: 'firstGridDDGroup',
		enableDragDrop   : true,
		stripeRows: true,
		viewConfig: {
           forceFit: true
     }
		,title : '临床路径所属科室'
		,columns: [
			{header: '科室名称', width: 200, dataIndex: 'desc', sortable: true}
		]});
	obj.DeptPathWin = new Ext.Viewport({
		id : 'DeptPathWay',
		title:""//"为 "+pathNode.text+" 指定科室"
		,height : 450
		,buttonAlign : 'center'
		,width : 520
		,layout : 'border',
		modal:true
		,items:[
			obj.AllDeptGrid
			,obj.PathWayOfDeptGrid
		]
	});
	/*obj.DeptPathWin.on('show',function(){
		var firstGridDropTargetEl =  obj.AllDeptGrid.getEl();
		var firstGridDropTarget = new Ext.dd.DropTarget(firstGridDropTargetEl, {
                ddGroup    : 'firstGridDDGroup',
                notifyDrop : function(ddSource, e, data){
                var records =  ddSource.dragData.selections;
                Ext.each(records, function(item){
                var pathRowid=obj.pathWayRowid
                var deptRowid=item.get('Rowid');
                var delVal=obj.deleteDeptPath(deptRowid,pathRowid);
                if(delVal){  
                	ddSource.grid.store.remove(item)
                }
               });       
               //从obj.DeptPathGrid里移出临床路径
               return true
              }
              
     });	
    var secondGridDropTargetEl = obj.PathWayOfDeptGrid.getEl();
		var secondGridDropTarget = new Ext.dd.DropTarget(secondGridDropTargetEl, {
                ddGroup    : 'secondGridDDGroup',
                notifyDrop : function(ddSource, e, data){
                        var records =  ddSource.dragData.selections;
                        //向obj.DeptPathGrid里添加记录
                        obj.ToDeptPathGrid(records)
                        return true
                }
        }); 
	})*/
	obj.AllDeptStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.DeptPahtWay';
			param.QueryName = 'GetDept';
			param.Arg1=obj.findField.getValue();
			param.ArgCnt = 1;
	});
	obj.AllDeptStore.load({});
	obj.PathWayOfDeptStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.DeptPahtWay';
			param.QueryName = 'GetPathToDept';
			param.Arg1=obj.pathWayRowid
			param.ArgCnt = 1;
	});
	obj.PathWayOfDeptStore.load({});
	DeptPathWayEvent(obj);
	obj.findBtn.on('click',function(){
			obj.AllDeptStore.load({});
	})
	obj.findField.on('specialkey',obj.FindFieldEnter,obj)
	//事件处理代码
  obj.LoadEvent();
  return obj;
}

