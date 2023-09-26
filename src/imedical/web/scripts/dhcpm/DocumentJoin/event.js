//Create by zzp
// 20150515
//文档管理
function InitviewScreenEvent(obj) {
	var objAudit = ExtTool.StaticServerObject("web.PMP.Document");
	var objAudit1 = ExtTool.StaticServerObject("DHCPM.Application.PMApply");
    var ip=getIpAddress();
	obj.LoadEvent = function(args){
	    
		obj.DocumentAdd.on("click",obj.DocumentAdd_OnClick,obj) ;//新增事件
		
		obj.DocumentUpdate.on("click",obj.DocumentUpdate_OnClick,obj) ;//更新事件
		
		obj.DocumentDelete.on("click",obj.DocumentDelete_OnClick,obj) ;//删除事件
		
		obj.DocumentQuery.on("click",obj.DocumentQuery_OnClick,obj) ;//查询事件
		
		obj.DocumentBatch.on("click",obj.DocumentBatch_OnClick,obj) ;//重置事件
		
		obj.DocumentName.on("specialkey", obj.DocumentName_specialkey,obj)  //名称回车事件
		
        obj.Documenttree.on("click",obj.Documenttree_OnClick,obj);  //个人文件树形结构单击事件
		
		obj.Documenttreeshore.on("click",obj.Documenttreeshore_OnClick,obj);  //共享文件树形结构单击事件
		
		obj.Documenttreesh.on("click",obj.Documenttreesh_OnClick,obj);  //文件接收树形结构单击事件 
		
		obj.DocumentGridPanel.on('cellclick',obj.DocumentGridPanel_CellClick,obj)  
		/*
		obj.Documenttree.on("contextmenu",function(node,e){  
                e.preventDefault();  
                node.select();  
                obj.Documentmenu.showAt(e.getXY());  
            }); 
			
		obj.Documenttreeshore.on("contextmenu",function(node,e){  
                e.preventDefault();  
                node.select();  
                obj.Documentmenu.showAt(e.getXY());  
            });
			
		obj.Documenttreesh.on("contextmenu",function(node,e){  
                e.preventDefault();  
                node.select();  
                obj.Documentmenu.showAt(e.getXY());  
            });
		*/
	
	};
	obj.DocumentGridPanel_CellClick=function(grid, rowIndex, columnIndex, e){
	var btn = e.getTarget('.controlBtn');  
	if (btn){  
    var t = e.getTarget();  
    var record = obj.DocumentGridPanel.getStore().getAt(rowIndex);  
	var control = t.className; 
	var DocumentGridRowid=record.get('DocumentGridRowid');
	var DocumentGridDesc=record.get('DocumentGridDesc');
	var DocumentGridFtpName=record.get('DocumentGridFtpName');
	if(control=="Download"){
	try{
	BrowseFolder(DocumentGridDesc);
	if(VerStrstr!=DocumentGridDesc){
	var ret=FileDownload(VerStrstr,DocumentGridFtpName,"DownLoad");
	if(ret==true){
	var newrowid=objAudit.NewRowid(DocumentGridRowid);
	var downret=objAudit1.PMPDownloads(newrowid,"PMP_Document",ip);
	var DownloadsCountRet=objAudit.DownloadsCount(DocumentGridRowid);
	obj.DocumentQuery_OnClick();
	Ext.MessageBox.alert('Status','下载成功！'+VerStrstr);
	}
	else{
	Ext.Msg.show({
	          title : '温馨提示',
			  msg : '下载失败：'+DocumentGridDesc,
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	    return;
	};
	}
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	if(control=="receive"){
	try{
	var PDMReceiveRet=objAudit.PDMReceive(DocumentGridRowid);
	if(PDMReceiveRet=="1"){
	obj.DocumentQuery_OnClick();
	Ext.MessageBox.alert('Status','接收成功！');
	}
	else{
	Ext.Msg.show({
	          title : '温馨提示',
			  msg : '接收失败！',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	    return;
	};
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	if(control=="Delete"){
	try{
	Ext.MessageBox.alert('Status','暂时不提供删除功能！');
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	if(control=="DeleteShare"){
	try{
	var PDMShareRet=objAudit.PDMShare(DocumentGridRowid,"N");
	if (PDMShareRet=="1"){
	obj.DocumentQuery_OnClick();
	Ext.MessageBox.alert('Status','取消共享成功！');
	}
	else{
	Ext.Msg.show({
	          title : '温馨提示',
			  msg : '取消共享失败！',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	    return;
	};
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	if(control=="Share"){
	try{
	var PDMShareRet=objAudit.PDMShare(DocumentGridRowid,"Y");
	if (PDMShareRet=="1"){
	obj.DocumentQuery_OnClick();
	Ext.MessageBox.alert('Status','共享成功！');
	}
	else{
	Ext.Msg.show({
	          title : '温馨提示',
			  msg : '共享失败！',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	    return;
	};
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	}
	};
	obj.DocumentName_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.DocumentQuery_OnClick();
	};
	};
	obj.DocumentAdd_OnClick=function(){
	var domtype=obj.DocumentType.getValue();
	if(domtype=="myself"){
	var node=obj.Documenttree.getSelectionModel().getSelectedNode()
	var nodeid=node.id;
	};
	if(domtype=="share"){
	var node=obj.Documenttreeshore.getSelectionModel().getSelectedNode()
	var nodeid=node.id;
	};
	if(domtype=="Documenttreesh"){
	var node=obj.Documenttree.getSelectionModel().getSelectedNode()
	var nodeid=node.id;
	};
	//var nodeid=obj.DocumentID.getValue();
	if(nodeid==""){
	Ext.Msg.show({
	          title : '温馨提示',
			  msg : '请在左侧选择需要存放的目录!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	    return;
	}
	else{
	    distrObj = new AddDocumentWind();
		distrObj.AddDoFileType.setValue(domtype);
		distrObj.AddDoFileRowid.setValue(nodeid);
	    distrObj.menuwindAddDo.show();
	};
	};
	obj.DocumentUpdate_OnClick=function(){
	var _record = obj.DocumentGridPanel.getSelectionModel().getSelected();
	if(!_record){
	  Ext.Msg.show({
	          title : '温馨提示',
			  msg : '请选择需要修改的数据!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	}
	else {
	Ext.MessageBox.alert('Status','暂时不提供修改功能！');
	};
	};
	obj.DocumentDelete_OnClick=function(){
	var _record = obj.DocumentGridPanel.getSelectionModel().getSelected();
	if(!_record){
	  Ext.Msg.show({
	          title : '温馨提示',
			  msg : '请选择需要修改的数据!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	}
	else {
	Ext.MessageBox.alert('Status','暂时不提供删除功能！');
	};
	};
	obj.DocumentQuery_OnClick=function(){
	obj.DocumentGridStore.removeAll();
	obj.DocumentGridStore.load({params : {start:0,limit:20}});
	};
	obj.DocumentBatch_OnClick=function(){
	obj.DocumentName.setValue('');
	obj.DocumentQuery_OnClick();
	};
	obj.Documenttree_OnClick=function(node,event){
	  var Rowid=node.id;
	  var Text=node.text;
	  obj.DocumentID.setValue(Rowid);
	  obj.DocumentType.setValue('myself');
	  obj.DocumentGridStore.removeAll();
	  obj.DocumentGridStore.load({params : {start:0,limit:20}});
	  };
	 obj.Documenttreeshore_OnClick=function(node,event){
	  var Rowid=node.id;
	  var Text=node.text;
	  obj.DocumentID.setValue(Rowid);
	  obj.DocumentType.setValue('share');
	  obj.DocumentGridStore.removeAll();
	  obj.DocumentGridStore.load({params : {start:0,limit:20}});
	  };
	 obj.Documenttreesh_OnClick=function(node,event){
	  var Rowid=node.id;
	  var Text=node.text;
	  obj.DocumentID.setValue(Rowid);
	  obj.DocumentType.setValue('receive');
	  obj.DocumentGridStore.removeAll();
	  obj.DocumentGridStore.load({params : {start:0,limit:20}});
	  };
	
}

function AddDocumentWindEvent(obj){
      var objAudit = ExtTool.StaticServerObject("web.PMP.FileDownload");
	  var objAudit1 = ExtTool.StaticServerObject("web.PMP.Document");
      var sysFileSize=objAudit.FileSize()*1024;
      var PortDll = new ActiveXObject("FtpPortDLL.FtpPortList");
      obj.LoadEvent = function(args){
	  
	  obj.AddDoFileAdd.on("click",obj.AddDoFileAdd_OnClick,obj);  //保存事件
	  
	  obj.AddDoFileDelete.on("click",obj.AddDoFileDelete_OnClick,obj); //取消事件
	  
	  obj.AddDoFileAddFile.on("click",obj.AddDoFileAddFile_OnClick,obj); //添加附件事件
	  
	  obj.AddDoFileGridPanel.on('cellclick',obj.AddDoFileGridPanel_CellClick,obj)  
	  };
	  obj.AddDoFileGridPanel_CellClick=function(grid, rowIndex, columnIndex, e){
	  var btn = e.getTarget('.controlBtn');  
	   if (btn){  
        var t = e.getTarget();  
        var record = obj.AddDoFileGridPanel.getStore().getAt(rowIndex);
        //var records=obj.AddDoFileGridPanel.getSelectionModel().getSelection();		
	    var control = t.className; 
	    //var DocumentGridRowid=record.get('DocumentGridRowid');
	    if(control=="AddDelete"){
	   try{
		 obj.AddDoFileGridStore.remove(record);
	    }catch(err)
	    {
	     ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	    };
	   };
	  };
	}
	  obj.AddDoFileAdd_OnClick=function(){
	   var type=obj.AddDoFileType.getValue();
	   var nodeid=obj.AddDoFileRowid.getValue();
	   var ip=getIpAddress();
	   var recuser=obj.AddDoFileUser.getValue();
	   var FileShire=obj.AddDoFileShire.getValue();  
	   for(var batchNum = 0; batchNum < obj.AddDoFileGridStore.getCount(); batchNum++){
       var objbatch = obj.AddDoFileGridStore.getAt(batchNum);
	   var AddDoFileGridSize=objbatch.get("AddDoFileGridSize");
	   var AddDoFileGridType=objbatch.get("AddDoFileGridType");
	   var FileUrl=objbatch.get("AddDoFileUrl");
	   var ret=FileDownload(FileUrl,"","UpLoad");
	   var ret0=ret.split("//")[0];
	   var ret1=ret.split("//")[1];
	   var newtype=""
	   if(ret0="true"){
	     //              类型     树形节点id ip     接收用户    是否分享    新文件名     操作类型         源文件         文件大小
	     var InputString=type+"^"+nodeid+"^"+ip+"^"+recuser+"^"+FileShire+"^"+ret1+"^"+"PMP_Document"+"^"+FileUrl+"^"+AddDoFileGridSize;
		 var AddDocmenRet=objAudit1.AddDocumentFile(InputString,'');  //第二参数为后期填写备注使用
		 if (AddDocmenRet!="1"){
		 Ext.MessageBox.alert('Status',FileUrl+'数据保存失败！');
		 newtype="1"
		 }
		 
	   }
	   else{
	   Ext.MessageBox.alert('Status',FileUrl+'文件上传失败！');
	   newtype="1"
	   };
	   if(newtype!="1"){
	    Ext.MessageBox.alert('Status','操作成功！');
		obj.menuwindAddDo.close();
		ExtTool.LoadCurrPage('DocumentGridPanel');
	   };
	   }
	  };
	  obj.AddDoFileDelete_OnClick=function(){
	  obj.menuwindAddDo.close();
	  };
	  obj.AddDoFileAddFile_OnClick=function(){
	  BrowseFolder('');
	  if(VerStrstr!=""){
	  var FileName=VerStrstr.split("\\")[VerStrstr.split("\\").length-1];
	  var FileType=FileName.split(".")[FileName.split(".").length-1];
	  var FielSizeBit=PortDll.FileSize(VerStrstr);
	  if (FielSizeBit/1024>sysFileSize){
	  Ext.Msg.show({
	          title : '温馨提示',
			  msg : '文件大小超出系统规定',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
		return;
	  }
	  else{
	  if(FielSizeBit>1024){
	     FielSizeBit=FielSizeBit/1024;
		 if(FielSizeBit>1024){
		   FielSizeBit=FielSizeBit/1024;
		   if(FielSizeBit>1024){
		     FielSizeBit=FielSizeBit/1024;
			 if(FielSizeBit>1024){
		        FielSizeBit=FielSizeBit/1024;
				FielSizeBit=FielSizeBit.toFixed(2)+"TB"
			 }
			 else{
			    FielSizeBit=FielSizeBit.toFixed(2)+"GB"
			 };
		   }
		   else{
		     FielSizeBit=FielSizeBit.toFixed(2)+"M"
		   };
		 }
		 else{
		   FielSizeBit=FielSizeBit.toFixed(2)+"KB"
		 };
	  }
	  else{
	    FielSizeBit=FielSizeBit+"KB"
	  };
	  };
	  var Plant = obj.AddDoFileGridStore.recordType;
	  var p = new Plant({AddDoFileGridRowid:'',AddDoFileGridDesc:FileName,AddDoFileGridCode:'',AddDoFileGridSize:FielSizeBit,AddDoFileGridType:FileType,AddDoFileUrl:VerStrstr});
      //AdjunctObGrid.stopEditing();
      obj.AddDoFileGridStore.insert(0, p);
	  };
	  };
}