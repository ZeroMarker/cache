//Create by zzp
// 20150505
//Ȩ�޹���
function InitviewScreenEvent(obj) {
	var objAudit = ExtTool.StaticServerObject("web.PMP.Common");
	//obj.intCurrRowIndex = -1;
	obj.LoadEvent = function(args){	
	    obj.PerAdd.on("click", obj.PerAdd_OnClick, obj);  //�����¼� 
		
		obj.PerUpdate.on("click", obj.PerUpdate_OnClick, obj);  //�޸� �¼�
		
		obj.PerQuery.on("click", obj.PerQuery_OnClick, obj);  //��ѯ�¼�  
		
		obj.PerBatch.on("click", obj.PerBatch_OnClick, obj ); //�����¼� 

        obj.PerDelete.on("click", obj.PerDelete_OnClick, obj ); //ɾ���¼�		
		
		obj.PerName.on("specialkey", obj.PerName_specialkey,obj)  //��Ŀ���ƻس��¼�
		
		obj.PerSName.on("specialkey", obj.PerSName_specialkey,obj)  //�������ƻس��¼�
		
		obj.PerLive.on("specialkey", obj.PerLive_specialkey,obj)  //Ȩ�޼���س��¼�
		
		obj.PerGridPanel.on("rowclick", obj.PerGridPanel_cellclick,obj)  //�е����¼�
		
		obj.PerDetailLoc.on("specialkey", obj.PerDetailLoc_specialkey,obj)  //��ϸ�������ͻس��¼�
		
		obj.PerDetailUser.on("specialkey", obj.PerDetailUser_specialkey,obj)  //��ϸ�û��س��¼�
		
		obj.PerDetailAdd.on("click", obj.PerDetailAdd_OnClick, obj ); //Ȩ����ϸ�����¼�  
		
		obj.PerDetailUpdate.on("click", obj.PerDetailUpdate_OnClick, obj);  //Ȩ����ϸ�����¼� 
		
		obj.PerDetailDelete.on("click", obj.PerDetailDelete_OnClick, obj);  //��ϸɾ���¼�
		
		obj.PerDetailQuery.on("click", obj.PerDetailQuery_OnClick, obj);  //ģ���ѯ�¼�
		
		obj.PerDetailBatch.on("click", obj.PerDetailBatch_OnClick, obj);   //��ϸ�����¼�
		
		//obj.PUGridPanel.on("rowdblclick", obj.PUGridPanel_rowclick,obj)  //����ʦgrid˫�����¼�
		
		//obj.PUModulePanel.on("rowdblclick", obj.PUModulePanel_rowclick,obj)  //ģ��grid˫�����¼�
	};
	obj.PerGridPanel_cellclick=function(rowIndex,columnIndex,e){
	var _record = obj.PerGridPanel.getSelectionModel().getSelected();
	var Rowid=_record.get('PermisRowid');
	obj.PerRowidHid.setValue(Rowid);
	obj.PerDetailGridStore.removeAll();
	obj.PerDetailGridStore.load({params : {start:0,limit:10}});
	};
	obj.PerDetailUpdate_OnClick=function(){
	var _record = obj.PerDetailGridPanel.getSelectionModel().getSelected();
	if(!_record){
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '��ѡ����Ҫ�޸ĵ�����!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	}
	else{
	try{
	var PermisSRowid=_record.get('PermisSRowid');
	var PermisSUserId=_record.get('PermisSUserId');
	var PermisSLocId=_record.get('PermisSLocId');
	distrObj = new PerAddUpDetailWind();
    distrObj.PerDetailAddRowid.setValue(PermisSRowid);
	distrObj.PerDetailAddFlag.setValue('Update');
	if (PermisSUserId!=""){
	    distrObj.PerDetailUserStore .on('load', function (){
        distrObj.PerDetailAddUser.setValue(PermisSUserId);    
         });
	};
	if (PermisSLocId!=""){
	    distrObj.PerDetailLocStore .on('load', function (){
        distrObj.PerDetailLocType.setValue(PermisSLocId);    
         });
	};
	distrObj.menuwind.show();
	}catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	} 
	}
	};
	obj.PerDetailAdd_OnClick=function(){
	try{
	    var PerRowid=obj.PerRowidHid.getValue();
		if (PerRowid==""){
		Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '��ѡ���������!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	    return;
		}
		else {
		distrObj = new PerAddUpDetailWind();
		distrObj.PerDetailAddRowid.setValue(PerRowid);
	    distrObj.PerDetailAddFlag.setValue('Add');
	    distrObj.menuwind.show();
		};
	}catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	} 
	};
	obj.PerDetailDelete_OnClick=function(){
	var _record = obj.PerDetailGridPanel.getSelectionModel().getSelected();
	if(!_record){
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '��ѡ����Ҫɾ��������!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	}
	else{
	try{
	var PermisSRowid=_record.get('PermisSRowid');
	Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫɾ������������?', function(btn) {
	if(btn=='yes'){
	//alert(PermisSRowid);
	var DeletePermisRet=objAudit.DeletePermisDetail(PermisSRowid);
	if (DeletePermisRet=="0"){
	Ext.MessageBox.alert('�ɹ�', '����ɾ���ɹ���');
	obj.PerBatch_OnClick();
	}
	else {
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '����ʧ�ܣ�������룺'+DeletePermisRet,
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	}
	else{
	return;
	}
	});
	}catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	}
	
	};
	};
	obj.PerDetailQuery_OnClick=function(){
	obj.PerDetailGridStore.removeAll();
	obj.PerDetailGridStore.load({params : {start:0,limit:10}});
	};
	function obj.PerDelete_OnClick(){
	var _record = obj.PerGridPanel.getSelectionModel().getSelected();
	if(!_record){
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '��ѡ����Ҫɾ��������!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	}
	else{
	try{
	var PermisRowid=_record.get('PermisRowid');
	Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫɾ������������?', function(btn) {
	if(btn=='yes'){
	var DeletePermisRet=objAudit.DeletePermission(PermisRowid);
	if (DeletePermisRet=="1"){
	Ext.MessageBox.alert('�ɹ�', '����ɾ���ɹ���');
	obj.PerBatch_OnClick();
	}
	else {
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '����ʧ�ܣ�������룺'+DeletePermisRet,
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	}
	else{
	return;
	}
	});
	}catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	}
	
	};
	};
	obj.PerAdd_OnClick=function(){   //Ȩ�������¼�
	try{
		distrObj = new PerAddUpWind();
		distrObj.PermisSAddRowid.setValue('');
	    distrObj.PermisSAddFlag.setValue('Add');
	    distrObj.menuwind.show();
	}catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	} 
	   
	};
	obj.PerUpdate_OnClick=function(){
	var _record = obj.PerGridPanel.getSelectionModel().getSelected();
	if(!_record){
	  Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '��ѡ����Ҫ�޸ĵ�����!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	}
	else {
	try{
	    distrObj = new PerAddUpWind();
	    var PermisRowid=_record.get('PermisRowid');
		var PermisPerId=_record.get('PermisPerId');
		var PermisMustAuId=_record.get('PermisMustAuId');
		var PermisLiveName=_record.get('PermisLiveName');
		var PermisLive=_record.get('PermisLive');
		var PermisAuditId=_record.get('PermisAuditId');
		var PermisTAuditId=_record.get('PermisTAuditId');
		var PermisTypeid=_record.get('PermisTypeid');
		if (PermisTypeid!=""){
		distrObj.PerCATtypeStore .on('load', function (){
        distrObj.PermisSAddType.setValue(PermisTypeid);    
         });
		};
		if (PermisPerId!=""){
		distrObj.PerProNameStore .on('load', function (){
        distrObj.PermisSAddPerName.setValue(PermisPerId);    
         });
		};
		if (PermisTAuditId!=""){
		distrObj.PermisTAuditStore .on('load', function (){
        distrObj.PermisSAddACTT.setValue(PermisTAuditId);    
         });
		};
		if (PermisAuditId!=""){
		distrObj.PerStatusStore .on('load', function (){
        distrObj.PermisSAddACT.setValue(PermisAuditId);    
         });
		};
	    if (PermisMustAuId!=""){
		distrObj.PermisMustAuStore .on('load', function (){
        distrObj.PermisSMustA.setValue(PermisMustAuId);    
         });
		};
		distrObj.PermisSAddName.setValue(PermisLiveName);
		distrObj.PermisSAddLive.setValue(PermisLive);
		distrObj.PermisSAddRowid.setValue(PermisRowid);
	    distrObj.PermisSAddFlag.setValue('Update');
	    distrObj.menuwind.show();
	}catch(err)
	{
	    ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	}
	
	};
	};
	obj.PerQuery_OnClick=function(){
	obj.PerRowidHid.setValue('');
	obj.PerGridStore.removeAll();
	obj.PerGridStore.load({params : {start:0,limit:10}});
	obj.PerDetailGridStore.removeAll();
	obj.PerDetailGridStore.load({params : {start:0,limit:10}});
	};
	obj.PerBatch_OnClick=function(){
	obj.PerName.setValue("");
	obj.PerRowidHid.setValue('');
	obj.PerSName.setValue("");
	obj.PerLive.setValue("");
	obj.PerGridStore.removeAll();
	obj.PerGridStore.load({params : {start:0,limit:10}});
	obj.PerDetailGridStore.removeAll();
	obj.PerDetailGridStore.load({params : {start:0,limit:10}});
	};
	obj.PerDetailBatch_OnClick=function(){
	obj.PerDetailLoc.setValue("");
	obj.PerDetailUser.setValue('');
	obj.PerDetailGridStore.removeAll();
	obj.PerDetailGridStore.load({params : {start:0,limit:10}});
	};
	obj.PerName_specialkey=function(field,e){
	if ((e.keyCode== 13)||(e.keyCode== 8)){
	obj.PerQuery_OnClick();
	};
	};
	obj.PerSName_specialkey=function(field,e){
	if ((e.keyCode== 13)||(e.keyCode== 8)){
	obj.PerQuery_OnClick();
	};
	};
	obj.PerLive_specialkey=function(field,e){
	if ((e.keyCode== 13)||(e.keyCode== 8)){
	obj.PerQuery_OnClick();
	};
	};
	obj.PerDetailLoc_specialkey=function(field,e){
	if ((e.keyCode== 13)||(e.keyCode== 8)){
	obj.PerDetailQuery_OnClick();
	};
	};
	obj.PerDetailUser_specialkey=function(field,e){
	if ((e.keyCode== 13)||(e.keyCode== 8)){
	obj.PerDetailQuery_OnClick();
	};
	};
}
function PerAddUpWindEvent(obj){
    var objAudit = ExtTool.StaticServerObject("web.PMP.Common");
	//obj.intCurrRowIndex = -1;
	obj.LoadEvent = function(args){	
	    obj.PermisSAdd.on("click", obj.PermisSAdd_OnClick, obj);  //�����¼� 
		
		obj.PermisSDelete.on("click", obj.PermisSDelete_OnClick, obj);  //�����¼�
	}
  obj.PermisSAdd_OnClick=function(){
   try{
   var PermisSAddRowid=obj.PermisSAddRowid.getValue();
   var PermisSAddFlag=obj.PermisSAddFlag.getValue();
   var PermisSAddPerName=obj.PermisSAddPerName.getValue();
   var PermisSMustA=obj.PermisSMustA.getValue();
   var PermisSAddName=obj.PermisSAddName.getValue();
   var PermisSAddLive=obj.PermisSAddLive.getValue();
   var PermisSAddACT=obj.PermisSAddACT.getValue();
   var PermisSAddUser=obj.PermisSAddUser.getValue();
   var PermisSAddACTT=obj.PermisSAddACTT.getValue();
   var PermisSAddType=obj.PermisSAddType.getValue();
   if (PermisSAddType==""){
   Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '��������͡�Ϊ������Ŀ!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
   };
   if (PermisSAddPerName==""){
   Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '��ѡѡ����Ŀ!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
   };
   if (PermisSMustA==""){
   Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '��������ˡ�����Ϊ��!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
   };
   if (PermisSAddName==""){
   Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '��Ȩ�����ơ�����Ϊ��!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
   };
   if (PermisSAddACT==""){
   Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '����˽��������Ϊ��!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
   };
   //           Rowid                ��������             ��Ŀ����          ������˱�ʶ      Ȩ������            Ȩ�޼���            ��˽��         Ȩ���û�         ������˱�־        �������
   var input=PermisSAddRowid+"^"+PermisSAddFlag+"^"+PermisSAddPerName+"^"+PermisSMustA+"^"+PermisSAddName+"^"+PermisSAddLive+"^"+PermisSAddACT+"^"+PermisSAddUser+"^"+PermisSAddACTT+"^"+PermisSAddType;
   var AddUpdatePermisRet=objAudit.AddUpdatePermis(input);
   if (AddUpdatePermisRet=="1"){
      Ext.MessageBox.alert('�ɹ�', '�����ɹ���');
      obj.menuwind.close();
	  ExtTool.LoadCurrPage('PerGridPanel');
	  ExtTool.LoadCurrPage('PerDetailGridPanel');
	}
	else {
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '����ʧ�ܣ�������룺'+AddUpdatePermisRet,
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
   }catch(err)
	{
	    ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	}
  };
  obj.PermisSDelete_OnClick=function(){
  obj.menuwind.close();
  };
}

function PerAddUpDetailWindEvent(obj){
   var objAudit = ExtTool.StaticServerObject("web.PMP.Common");
	//obj.intCurrRowIndex = -1;
	obj.LoadEvent = function(args){	
	    obj.PerDetailAdd.on("click", obj.PerDetailAdd_OnClick, obj);  //�����¼� 
		
		obj.PerDetailDelete.on("click", obj.PerDetailDelete_OnClick, obj);  //�޸� �¼�
	}
	obj.PerDetailAdd_OnClick=function(){
	try{
       var PerDetailAddRowid=obj.PerDetailAddRowid.getValue();
       var PerDetailAddFlag=obj.PerDetailAddFlag.getValue();
       var PerDetailAddUser=obj.PerDetailAddUser.getValue();
       var PerDetailLocType=obj.PerDetailLocType.getValue();
	   if (PerDetailAddUser==""){
	   Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '���û����ơ�����Ϊ��!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	    return;
	   };
	   if ((PerDetailAddFlag=="Add")&&(PerDetailLocType=="")){
	    var LocTypeRet=objAudit.PerLocType(PerDetailAddRowid,PerDetailAddUser,'');
		if (LocTypeRet=="1"){
		Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '���û��Ѿ�����ȫ��Ȩ��',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	    return;
		};
	   };
	   if ((PerDetailAddFlag=="Add")&&(PerDetailLocType!="")){
	   var LocTypeRet=objAudit.PerLocType(PerDetailAddRowid,PerDetailAddUser,PerDetailLocType);
		if (LocTypeRet=="1"){
		Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '���û��Ѿ����ڸÿ�������Ȩ��',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	    return;
		};
	   };
	   var input=PerDetailAddRowid+"^"+PerDetailAddFlag+"^"+PerDetailAddUser+"^"+PerDetailLocType;
	   var AddUpdateRet=objAudit.AddUpdatePerDetail(input);
	   if (AddUpdateRet=="1"){
	   Ext.MessageBox.alert('�ɹ�', '�����ɹ���');
       obj.menuwind.close();
	   ExtTool.LoadCurrPage('PerGridPanel');
	   ExtTool.LoadCurrPage('PerDetailGridPanel');
	   }
	   else{
	   Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '����ʧ�ܣ�������룺'+AddUpdateRet,
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	    return;
	   };
	   }catch(err)
	{
	    ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	}
	
	};
	obj.PerDetailDelete_OnClick=function(){
	obj.menuwind.close();
	};
}