//Create by zzp
// 20150427
//ϵͳ����
function InitviewScreenEvent(obj) {
	var objAudit = ExtTool.StaticServerObject("web.PMP.Common");
	//obj.intCurrRowIndex = -1;
	obj.LoadEvent = function(args){
		
		
		obj.TelAdd.on("click", obj.TelAdd_OnClick, obj);  //�����¼� 
		
		obj.TelUpdate.on("click", obj.TelUpdate_OnClick, obj);  //�޸� �¼�
		
		obj.TelQuery.on("click", obj.TelQuery_OnClick, obj);  //��ѯ�¼�  
		
		obj.TelBatch.on("click", obj.TelBatch_OnClick, obj ); //�����¼�  
		
		obj.TelLoc.on("specialkey", obj.TelLoc_specialkey,obj)  //���һس��¼�
		
		obj.TelUser.on("specialkey", obj.TelUser_specialkey,obj)  //�û��س��¼�
		
		obj.TelText.on("specialkey", obj.TelText_specialkey,obj)  //��ϵ��ʽ�س��¼�
		
		obj.TelEmail.on("specialkey", obj.TelEmail_specialkey,obj)  //�����ʼ��س��¼�
		
		//obj.TelGridPanel.on("rowdblclick", obj.TelGridPanel_rowclick,obj)  //˫�����¼�
		
		//obj.TelGridPanel.on("rowclick", obj.TelGridPanel_cellclick,obj)  //�е����¼�
			
	};
	/*
	obj.TelGridPanel_cellclick=function(){
	
	};
	*/
	obj.TelAdd_OnClick=function(){
	var teltyperet=objAudit.UserTelType();
	if(teltyperet.split('^')[0]=="1"){
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '���Ѿ�������ϵ��ʽ��ֻ�ܽ����޸�!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	try{
		distrObj = new TelMenuWind();
	}catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	} 
	   distrObj.TelMenuName.setValue(teltyperet.split('^')[1]);
	   distrObj.TelRowid.setValue('');
	   distrObj.TelFlag.setValue('Add');
	   distrObj.TelMenuText.setValue('');
	   distrObj.TelMenuEmail.setValue('');
	   distrObj.TelMenubz.setValue('');
	   distrObj.menuwind.show();
	};
	obj.TelUpdate_OnClick=function(){
	var _record = obj.TelGridPanel.getSelectionModel().getSelected();
	if(!_record){
	  Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '��ѡ����Ҫ�޸ĵ�����!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	}
	else {
	var TelGridRowid=_record.get('TelGridRowid');
	var teltyperet=objAudit.UserTelType();
	if(teltyperet.split('^')[2]!=TelGridRowid){
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '��ֻ�ܽ����޸ı��˵���Ϣ!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	else {
	var TelGridName=_record.get('TelGridName');
	var TelGridTel=_record.get('TelGridTel');
	var TelGridEmail=_record.get('TelGridEmail');
	var TelGridbz=_record.get('TelGridbz');
	try {
	distrObj = new TelMenuWind();
	distrObj.TelMenuName.setValue(TelGridName);
	distrObj.TelRowid.setValue(TelGridRowid);
	distrObj.TelFlag.setValue('Update');
	distrObj.TelMenuText.setValue(TelGridTel);
	distrObj.TelMenuEmail.setValue(TelGridEmail);
	distrObj.TelMenubz.setValue(TelGridbz);
	distrObj.menuwind.show();
	}catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	} 
	};
	};
	};
	/*
	obj.TelGridPanel_rowclick=function(rowIndex,columnIndex,e){
	obj.TelUpdate_OnClick();
	};
	*/
	obj.TelLoc_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.TelQuery_OnClick();
	};
	};
	obj.TelEmail_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.TelQuery_OnClick();
	};
	};
	obj.TelUser_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.TelQuery_OnClick();
	};
	};
	obj.TelText_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.TelQuery_OnClick();
	};
	};
	obj.TelQuery_OnClick=function(){
	var TelText=obj.TelText.getValue();
	var TelLoc=obj.TelLoc.getValue();
	var TelUser=obj.TelUser.getValue();
	var TelEmail=obj.TelEmail.getValue();
	var InPut=TelText+"^"+TelLoc+"^"+TelUser+"^"+TelEmail;
    obj.TelGridStore.removeAll();
	obj.TelGridStore.load({params:{InPut:InPut}});
	};
	obj.TelBatch_OnClick=function(){
	obj.TelText.setValue("");
	obj.TelLoc.setValue("");
	obj.TelUser.setValue("");
	obj.TelEmail.setValue("");
	obj.TelGridStore.removeAll();
	obj.TelGridStore.load();
	};
}
function TelMenuWindEvent(obj){
      var objAudit = ExtTool.StaticServerObject("web.PMP.Common");
      obj.LoadEvent = function(){
      obj.TelMenuAdd.on("click", obj.TelMenuAdd_OnClick, obj);  //���� �¼�
	  obj.TelMenuDelete.on("click", obj.TelMenuDelete_OnClick, obj);  //���� �¼�
   };
   obj.TelMenuAdd_OnClick=function(){
    var TelMenuName=obj.TelMenuName.getValue();
    var TelRowid=obj.TelRowid.getValue();
    var TelFlag=obj.TelFlag.getValue();
    var TelMenuText=obj.TelMenuText.getValue();
    var TelMenuEmail=obj.TelMenuEmail.getValue();
    var TelMenubz=obj.TelMenubz.getValue();
	if (TelMenuText==""){
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '��ϵ��ʽ����Ϊ��!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	try {
	 var inupt=TelRowid+"^"+TelFlag+"^"+TelMenuText+"^"+TelMenuEmail+"^"+TelMenubz;
	 var UpdateRet=objAudit.TelUpdate(inupt);
	 if (UpdateRet=="1"){
	  Ext.MessageBox.alert('���', '�����������');
	  obj.menuwind.close();
	  ExtTool.LoadCurrPage('TelGridPanel');
	 }
	 else {
	 Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '���ݲ���ʧ�ܣ�������룺'+UpdateRet,
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
   obj.TelMenuDelete_OnClick=function(){
   obj.menuwind.close();
   };

}