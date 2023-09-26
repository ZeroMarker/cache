//Create by zzp
// 20150521
//�ṹ������
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
	          title : '��ܰ��ʾ',
			  msg : '��ѡ�������͡���',
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
   Ext.MessageBox.confirm('��ʾ', '"'+nodetext+'"�����ӽڵ㣬�Ƿ�Ҫ����ɾ�������ɾ����ɾ�������ӽڵ�', function(btn) {
   if(btn=='yes'){
    var Deletenodesubret=objAudit1.DeleteDirTree(nodeid,nodesubret,ipAdress);
	if (Deletenodesubret=="1"){
	Ext.MessageBox.alert('Status','ɾ���ɹ���');
	}
	else{
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : 'ɾ��ʧ�ܣ��������'+Deletenodesubret,
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
   Ext.MessageBox.confirm('��ʾ', '�Ƿ�Ҫɾ����'+nodetext+'��', function(btn) {
   if(btn=="yes"){
   var Deletenoderet=objAudit1.DeleteDirTree(nodeid,nodesubret,ipAdress);
	if (Deletenoderet=="1"){
	Ext.MessageBox.alert('Status','ɾ���ɹ���');
	var url='PMP.Document.csp?actiontype=DirTree&InPut='+Ext.getCmp('DirTreeType').getValue();
	obj.nodeid.dataUrl=url+"&parent=0";	
	Ext.getCmp('DirTree').getNodeById("roo").reload();   
	}
	else{
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : 'ɾ��ʧ�ܣ��������'+Deletenoderet,
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
	          title : '��ܰ��ʾ',
			  msg : '����ѡ��Ŀ��ڵ�',
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
	          title : '��ܰ��ʾ',
			  msg : '����ѡ��Ŀ��ڵ�',
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
	          title : '��ܰ��ʾ',
			  msg : '���ⲻ��Ϊ��~~~~',
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
	          title : '��ܰ��ʾ',
			  msg : '�ӽڵ�ѡ���ѡѡ��Ŀ��ڵ㣡',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
     return;
	};
	var input=nodeid+"^"+typeid+"^"+flag+"^"+sub+"^"+ipAdress;
	//        �ڵ�id    ����id   ������ʶ  �ӽڵ㣨1,0��IP
	var AddDirRet=objAudit1.AddDirTree(input,titlename);
	if(AddDirRet=="1"){
	//obj.DirTree.getRootNode().reload();
	Ext.MessageBox.alert('Status','�����ɹ���');
	obj.menuwindAddDir.close();
	Ext.getCmp('DirTree').getRootNode().reload();
	}
	else{
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '����ʧ�ܣ�������룺'+AddDirRet,
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