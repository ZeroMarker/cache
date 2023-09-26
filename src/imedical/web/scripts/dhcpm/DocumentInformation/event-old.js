//Create by zzp
// 20150515
//��ͬ��Ϣ����
function InitviewScreenEvent(obj) {
	var objAudit = ExtTool.StaticServerObject("web.PMP.Common");
	//obj.intCurrRowIndex = -1;
	obj.LoadEvent = function(args){
		obj.ContractAdd.on("click", obj.ContractAdd_OnClick, obj);  //�����¼� 
		
		obj.ContractUpdate.on("click", obj.ContractUpdate_OnClick, obj);  //�޸� �¼�
		
		obj.ContractDelete.on("click",obj.ContractDelete_OnClick,obj);  //ɾ���¼�
		
		obj.ContractQuery.on("click", obj.ContractQuery_OnClick, obj);  //��ѯ�¼�  
		
		obj.ContractBatch.on("click", obj.ContractBatch_OnClick, obj ); //�����¼�  
		
		obj.ContractCode.on("specialkey", obj.ContractCode_specialkey,obj)  //��ͬ����س��¼�
		
		obj.ContractName.on("specialkey", obj.ContractName_specialkey,obj)  //��ͬ���ƻس��¼�
		
		obj.ContractMenu.on("specialkey", obj.ContractMenu_specialkey,obj)  //��Ҫ���ݻس��¼�
		
		obj.ContractStatus.on("specialkey", obj.ContractStatus_specialkey,obj)  //��ͬ״̬�س��¼�
		
		obj.ContractGridPanel.on("rowdblclick", obj.ContractGridPanel_rowclick,obj)  //˫�����¼�
		
		//obj.TelGridPanel.on("rowclick", obj.TelGridPanel_cellclick,obj)  //�е����¼�
		
		obj.ContractGridPanel.on('cellclick',obj.ContractGridPanel_CellClick,obj)  
			
	};
	obj.ContractAdd_OnClick=function(){
	try{
		distrObj = new ContractMenuWind();
	    distrObj.ContractRowid.setValue('');
	    distrObj.ContractFlag.setValue('Add');
	    distrObj.menuwindadd.show();
	}catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	obj.ContractUpdate_OnClick=function(){
	var _record = obj.ContractGridPanel.getSelectionModel().getSelected();
	if(!_record){
	  Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '��ѡ����Ҫ�޸ĵ�����!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	}
	else {
	try{
	    var ContractGridRowid=_record.get('ContractGridRowid');
		var ContractGridCode=_record.get('ContractGridCode');
		var ContractGridDesc=_record.get('ContractGridDesc');
		var ContractGridFPartyid=_record.get('ContractGridFPartyid');
	    distrObj = new ContractMenuWind();
	    distrObj.ContractRowid.setValue(ContractGridRowid);
		distrObj.ContractMenuCode.setValue(ContractGridCode);
		distrObj.ContractMenuDesc.setValue(ContractGridDesc);
	    distrObj.ContractFlag.setValue('Update');
		if (ContractGridFPartyid!=""){
		 distrObj.ContractMenuSupplierStore .on('load', function (){
         distrObj.ContractMenuFirstParty.setValue(ContractGridFPartyid);    
         });
		};
	    distrObj.menuwindadd.show();
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	};
	obj.ContractDelete_OnClick=function(){
	var _record = obj.ContractGridPanel.getSelectionModel().getSelected();
	if(!_record){
	  Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '��ѡ����Ҫɾ��������!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	}
	else {
	try{
	var ContractGridRowid=_record.get('ContractGridRowid');
	alert("ɾ���¼�");
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	};
	obj.ContractQuery_OnClick=function(){
	obj.ContractGridStore.removeAll();
	obj.ContractGridStore.load({params : {start:0,limit:22}});
	};
	obj.ContractBatch_OnClick=function(){
	obj.ContractCode.setValue("");
	obj.ContractName.setValue("");
	obj.ContractMenu.setValue("");
	obj.ContractStatus.setValue("");
	obj.ContractQuery_OnClick();
	};
	obj.ContractCode_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.ContractQuery_OnClick();
	};
	};
	obj.ContractName_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.ContractQuery_OnClick();
	};
	};
	obj.ContractMenu_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.ContractQuery_OnClick();
	};
	};
	obj.ContractStatus_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.ContractQuery_OnClick();
	};
	};
	obj.ContractGridPanel_rowclick=function(){
	obj.ContractUpdate_OnClick();
	};
	obj.ContractGridPanel_CellClick=function(grid, rowIndex, columnIndex, e){
	var btn = e.getTarget('.controlBtn');  
	if (btn){  
    var t = e.getTarget();  
    var record = obj.ContractGridPanel.getStore().getAt(rowIndex);  
	var control = t.className; 
	var ContractGridRowid=record.get('ContractGridRowid');
	obj.Contractid.setValue(ContractGridRowid);
	if(control=="ContractDetail"){
	try{
	alert("�鿴����");
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	if(control=="EditDetail"){
	try{
	distrObj = new ContractDetailsWind(ContractGridRowid);
	distrObj.ContractDetailsid.setValue(ContractGridRowid);
	distrObj.menuwindDetails.show();
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	if(control=="Download"){
	try{
	distrObj = new ContracAdjunct(ContractGridRowid,"PMP_Contract");
	distrObj.ContracAdjunctStore.removeAll();
	distrObj.ContracAdjunctStore.load({params : {start:0,limit:10}});
	distrObj.menuwindContracAd.show();
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	if(control=="RelevancyMode"){
	try{
	distrObj = new ContractModeWind();
	distrObj.ContractModRowid.setValue(ContractGridRowid);
	distrObj.ContractModeStore.removeAll();
	distrObj.ContractModeStore.load({params : {start:0,limit:10}});
	distrObj.menuwindMode.show();
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	}
	};
}

function ContractMenuWindEvent(obj){
      var objAudit = ExtTool.StaticServerObject("web.PMP.Document");
      obj.LoadEvent = function(){
      obj.ContractMenuAdd.on("click", obj.ContractMenuAdd_OnClick, obj);     //���� �¼�
	  obj.ContractMenuDelete.on("click", obj.ContractMenuDelete_OnClick, obj);  //���� �¼�
   };
   obj.ContractMenuAdd_OnClick=function(){
   try{
   alert("�����¼�");
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
   };
   obj.ContractMenuDelete_OnClick=function(){
   obj.menuwindadd.close();
   };
}
function ContractModeWindEvent(obj){
     var objAudit = ExtTool.StaticServerObject("web.PMP.Document");
      obj.LoadEvent = function(){
	  
	  obj.ContractModeAdd.on("click", obj.ContractMenuAdd_OnClick, obj);     //���� �¼�
	  
	  obj.ContractModeQuery.on("click", obj.ContractModeQuery_OnClick, obj);  //��ѯ�¼�
	  
	  obj.ContractModeBatch.on("click",obj.ContractModeBatch_OnClick,obj);  //�����¼�
	  
	  obj.ContractModeReturn.on("click",obj.ContractModeReturn_OnClick,obj);  //�����¼�
	  
	  obj.ContractModeCode.on("specialkey", obj.ContractModeCode_specialkey,obj)  //ģ�����س��¼�
		
	  obj.ContractModeName.on("specialkey", obj.ContractModeName_specialkey,obj)  //ģ�����ƻس��¼�
	  };
	  obj.ContractMenuAdd_OnClick=function(){
	  try{
	       var ContractModRowid=obj.ContractModRowid.getValue('');
	       distrObj = new ContractModeAddWind();
	       distrObj.ContractAddRowid.setValue(ContractModRowid);
	       distrObj.menuwindModeN.show();
	     }catch(err)
	      {
	        ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	      };
	  };
	  obj.ContractModeQuery_OnClick=function(){
	  obj.ContractModeStore.removeAll();
	  obj.ContractModeStore.load({params : {start:0,limit:10}});
	  };
	  obj.ContractModeBatch_OnClick=function(){
	  obj.ContractModeCode.setValue("");
	  obj.ContractModeName.setValue("");
	  obj.ContractModeQuery_OnClick();
	  };
	  obj.ContractModeCode_specialkey=function(field,e){
	  if (e.keyCode== 13){
	    obj.ContractModeQuery_OnClick();
		};
	  };
	  obj.ContractModeName_specialkey=function(field,e){
	  if (e.keyCode== 13){
	    obj.ContractModeQuery_OnClick();
		};
	  };
	  obj.ContractModeReturn_OnClick=function(){
	  obj.ContractModRowid.setValue('');
	  obj.menuwindMode.close();
	  };
};
function ContractModeAddWindEvent(obj){
   var objAudit = ExtTool.StaticServerObject("web.PMP.Document");
      obj.LoadEvent = function(){
	    obj.ContractModeNAdd.on("click",obj.ContractModeNAdd_OnClick,obj);  //�����¼�
		
		obj.ContractModeNDelete.on("click",obj.ContractModeNDelete_OnClick,obj); // �����¼�
		
	  };
	  obj.ContractModeNAdd_OnClick=function(){
	  alert("��������¼�");
	  };
	  obj.ContractModeNDelete_OnClick=function(){
	  obj.menuwindModeN.close();
	  };
};
function ContractDetailsWindEvent(obj){
      var objAudit = ExtTool.StaticServerObject("web.PMP.Document");
       obj.LoadEvent = function(){
	   obj.tree.on("click",obj.tree_OnClick,obj);  //���νṹ�����¼�
	   
	   obj.ContractDetailsSub.on("change",obj.ContractDetailsSub_OnClick,obj);
	   
	   obj.ContractDetailsQuery.on("click",obj.ContractDetailsQuery_OnClick,obj);
	   
	   obj.ContractDetailsAdd.on("click",obj.ContractDetailsAdd_OnClick,obj);
	  };
	  obj.ContractDetailsAdd_OnClick=function(){
	  
	  alert('�����¼�');
	  };
	  obj.ContractDetailsQuery_OnClick=function(){
	  alert('Ԥ���¼�');
	  };
	  obj.ContractDetailsSub_OnClick=function(){
	  if (obj.ContractDetailsSub.checked==true){
	   Ext.getCmp("ContractDetailMenui").setValue('');
	   obj.ContractDetailsTitle.setValue('');
	  };
	  };
	  obj.tree_OnClick=function(node,event){
	  var Rowid=node.id;
	  var Text=node.text;
	  obj.ContractDetailsTitle.setValue(Text);
	  try{
	     var MenuRet=objAudit.ContractDetailsMenu(Rowid);
		 if(MenuRet!=""){
		 Ext.getCmp("ContractDetailMenui").setValue(MenuRet.split("@@")[0]);    //��htmledit��ֵ
		 //var Solutionivalue=Ext.getCmp("ContractDetailMenui").getValue();   //htmledit��ȡֵ
		 }
		 else{
		 Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '��������!',
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
};

function ContracAdjunctEvent(obj){
   var objAudit = ExtTool.StaticServerObject("web.PMP.Document");
        obj.LoadEvent = function(){
	    obj.ContracAdjunctAdd.on("click",obj.ContracAdjunctAdd_OnClick,obj);
		
		obj.ContracAdjunctPanel.on('cellclick',obj.ContracAdjunctPanel_CellClick,obj)  
	   
	   };
	obj.ContracAdjunctAdd_OnClick=function(){
    BrowseFolder('');
	if (VerStrstr!=""){
	var FileName=objAudit.AddFileName(VerStrstr);  //User_"^"_type_"^"_flag_"^"_date
	var OldName=VerStrstr.split("\\")[VerStrstr.split("\\").length-1];
	var Plant = obj.ContracAdjunctStore.recordType;
	var p = new Plant({ConAdRowid:'',ConAdName:OldName,ConAdFileType:FileName.split("^")[1],ConAdDate:FileName.split("^")[3],ConAdUser:FileName.split("^")[0],ConAdType:FileName.split("^")[2],ConAdFtpName:'',ConAdFalg:'',ConAdAll:VerStrstr});
    //AdjunctObGrid.stopEditing();
    obj.ContracAdjunctStore.insert(0, p);
	};
	};
	obj.ContracAdjunctPanel_CellClick=function(grid, rowIndex, columnIndex, e){
	var btn = e.getTarget('.controlBtn');  
	if (btn){  
    var t = e.getTarget();  
    var record = obj.ContracAdjunctPanel.getStore().getAt(rowIndex);  
	var control = t.className; 
	var ConAdRowid=record.get('ConAdRowid');
	if(control=="Download"){
	try{
	alert("���غ�ͬ����");
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	if(control=="EditDetail"){
	try{
	alert("ɾ����ͬ����");
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	};
	};
};