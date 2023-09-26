//Create by zzp
// 20150521
//结构树管理
function InitviewScreenEvent(obj) {
	var objAudit = ExtTool.StaticServerObject("web.PMP.Common");
	var objAudit1=ExtTool.StaticServerObject("web.PMP.Document");
	var ipAdress=getIpAddress()
	obj.LoadEvent = function(args){
	  obj.DirTreeAdd.on("click",obj.DirTreeAdd_OnClick,obj);
	  
	  obj.DirTreeDelete.on("click",obj.DirTreeDelete_OnClick,obj);
	  
	  obj.DirTreeUpdate.on("click",obj.DirTreeUpdate_OnClick,obj);
	  
	  obj.DirTreeQuery.on("click",obj.DirTreeQuery_OnClick,obj);
	  
	  obj.DirTree.on("contextmenu",function(node,e){  
                e.preventDefault();  
                node.select();  
                obj.contextmenu.showAt(e.getXY());  
            }); 
 };
 obj.DirTreeAdd_OnClick=function(){
 try{
   var typeid=obj.DirTreeType.getValue();
   if(typeid==""){
    Ext.Msg.show({
	          title : '温馨提示',
			  msg : '请选择“树类型”！',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
     return;
   }
   var node=obj.DirTree.getSelectionModel().getSelectedNode()
   if(node){
   nodeid=node.id;
   nodetext=node.text;
   distrObj = new AddDirTreeWind(nodeid,typeid,'Add');
   distrObj.menuwindAddDir.show();
   }
   else{
   distrObj = new AddDirTreeWind('',typeid,'Add');
   distrObj.menuwindAddDir.show();
   };
   }catch(err)
	      {
	        ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	      };
 };
 obj.DirTreeDelete_OnClick=function(){
 var node=obj.DirTree.getSelectionModel().getSelectedNode()
  if(node){
   nodeid=node.id;
   nodetext=node.text;
   var nodesubret=objAudit1.DirTreeSub(nodeid);
   if(nodesubret!=""){
   Ext.MessageBox.confirm('提示', '"'+nodetext+'"存在子节点，是否要继续删除，如果删除将删除所有子节点', function(btn) {
   if(btn=='yes'){
    var Deletenodesubret=objAudit1.DeleteDirTree(nodeid,nodesubret,ipAdress);
	if (Deletenodesubret=="1"){
	Ext.MessageBox.alert('Status','删除成功！');
	}
	else{
	Ext.Msg.show({
	          title : '温馨提示',
			  msg : '删除失败，错误代码'+Deletenodesubret,
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
     return;
	}
	}
	else{
	return;
	};
	})
   }
   else{
   Ext.MessageBox.confirm('提示', '是否要删除：'+nodetext+'？', function(btn) {
   if(btn=="yes"){
   var Deletenoderet=objAudit1.DeleteDirTree(nodeid,nodesubret,ipAdress);
	if (Deletenoderet=="1"){
	Ext.MessageBox.alert('Status','删除成功！');
	var url='PMP.Document.csp?actiontype=DirTree&InPut='+Ext.getCmp('DirTreeType').getValue();
	obj.nodeid.dataUrl=url+"&parent=0";	
	Ext.getCmp('DirTree').getNodeById("roo").reload();   
	}
	else{
	Ext.Msg.show({
	          title : '温馨提示',
			  msg : '删除失败，错误代码'+Deletenoderet,
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
     return;
	}
   }
   else{
   return;
   };
   });
   };
   
   }
   else{
    Ext.Msg.show({
	          title : '温馨提示',
			  msg : '请先选择目标节点',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
     return;
   };
 };
 obj.DirTreeUpdate_OnClick=function(){
 var node=obj.DirTree.getSelectionModel().getSelectedNode()
  if(node){
   nodeid=node.id;
   nodetext=node.text;
   distrObj = new AddDirTreeWind(nodeid,'','Update');
   distrObj.AddDirTitle.setValue(nodetext);
   distrObj.menuwindAddDir.show();
   }
   else{
    Ext.Msg.show({
	          title : '温馨提示',
			  msg : '请先选择目标节点',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
     return;
   };
 };
 obj.DirTreeQuery_OnClick=function(){
 try{
    var url='PMP.Document.csp?actiontype=DirTree&InPut='+Ext.getCmp('DirTreeType').getValue();
	obj.nodeid.dataUrl=url+"&parent=0";	
	Ext.getCmp('DirTree').getNodeById("roo").reload();   
 }
 catch(err)
	      {
	        ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	      };
 };
}

function AddDirTreeWindEvent(obj,nodeid,typeid,flag){
	var objAudit = ExtTool.StaticServerObject("web.PMP.Common");
	var objAudit1=ExtTool.StaticServerObject("web.PMP.Document");
	var ipAdress=getIpAddress()
	obj.LoadEvent = function(args){
	  obj.AddDirAdd.on("click",obj.AddDirAdd_OnClick,obj)
	  
	  obj.AddDirUpdate.on("click",obj.AddDirUpdate_OnClick,obj)
	
	};
	
	obj.AddDirAdd_OnClick=function(){
	var titlename=obj.AddDirTitle.getValue().replace(/ /g,"");
	if (titlename==""){
	Ext.Msg.show({
	          title : '温馨提示',
			  msg : '标题不能为空~~~~',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
     return;
	} 
	if(obj.AddDirSub.checked==false){
	var sub=0;
	}
	else{
	var sub=1;
	};
	if((sub==1)&(nodeid=="")){
	Ext.Msg.show({
	          title : '温馨提示',
			  msg : '子节点选项，必选选择目标节点！',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
     return;
	};
	var input=nodeid+"^"+typeid+"^"+flag+"^"+sub+"^"+ipAdress;
	//        节点id    类型id   操作标识  子节点（1,0）IP
	var AddDirRet=objAudit1.AddDirTree(input,titlename);
	if(AddDirRet=="1"){
	//obj.DirTree.getRootNode().reload();
	Ext.MessageBox.alert('Status','操作成功！');
	obj.menuwindAddDir.close();
	Ext.getCmp('DirTree').getRootNode().reload();
	}
	else{
	Ext.Msg.show({
	          title : '温馨提示',
			  msg : '操作失败，错误代码：'+AddDirRet,
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
     return;
	};
	};
	obj.AddDirUpdate_OnClick=function(){
	obj.menuwindAddDir.close();
	};
}