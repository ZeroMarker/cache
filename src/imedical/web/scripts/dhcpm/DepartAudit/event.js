//Create by zzp
// 20150427
//������������
function InitviewScreenEvent(obj) {
	var objAudit = ExtTool.StaticServerObject("web.PMP.Common");
	//obj.intCurrRowIndex = -1;
	obj.LoadEvent = function(args){
		
		
		obj.DepartAdd.on("click", obj.DepartAdd_OnClick, obj);  //�����¼� 
		
		obj.DepartUpdate.on("click", obj.DepartUpdate_OnClick, obj);  //�޸� �¼�
		
		obj.DepartQuery.on("click", obj.DepartQuery_OnClick, obj);  //��ѯ�¼�  
		
		obj.DepartBatch.on("click", obj.DepartBatch_OnClick, obj ); //�����¼�  
		
		obj.DepartLoc.on("specialkey", obj.DepartLoc_specialkey,obj)  //���һس��¼�
		
		obj.DepartUser.on("specialkey", obj.DepartUser_specialkey,obj)  //�û��س��¼�
		
		obj.DepartGridPanel.on("rowdblclick", obj.DepartGridPanel_rowclick,obj)  //˫�����¼�
			
	};
	obj.DepartGridPanel_rowclick=function(rowIndex,columnIndex,e){
	obj.DepartUpdate_OnClick();
	};
	obj.DepartAdd_OnClick=function(){
	try{
		distrObj = new DepartMenuWind();
		distrObj.DepartRowid.setValue('');
	    distrObj.DepartFlag.setValue('Add');
	    distrObj.menuwind.show();
	}catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	}
	};
	obj.DepartUpdate_OnClick=function(){
	var _record = obj.DepartGridPanel.getSelectionModel().getSelected();
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
	var AuditRowid=_record.get('AuditRowid');
	var AuditLocName=_record.get('AuditLocDr');
	var AuditUserName=_record.get('AuditUserDr');
	var Typedesc=_record.get('Typedesc');
	var TypeRowid=objAudit.SelectTypeRowid(AuditRowid);
	distrObj = new DepartMenuWind();
	distrObj.DepartRowid.setValue(AuditRowid);
	distrObj.DepartFlag.setValue('Update');
	distrObj.DepartLocStore.on('load', function (){
       distrObj.DepartAddLoc.setValue(AuditLocName);    
         });
	distrObj.DepartUserStore.on('load', function (){
       distrObj.DepartAddUser.setValue(AuditUserName);    
         });
	if(Typedesc!=""){
	distrObj.DepartTypeStore.on('load', function (){
       distrObj.DepartAddType.setValue(TypeRowid);    
         });
	};
	distrObj.menuwind.show();
	}catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	};
	obj.DepartLoc_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.DepartQuery_OnClick();
	};
	};
	obj.DepartUser_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.DepartQuery_OnClick();
	};
	};
	obj.DepartQuery_OnClick=function(){
    obj.DepartGridStore.removeAll();
	obj.DepartGridStore.load({params : {start:0,limit:20}});
	};
	obj.DepartBatch_OnClick=function(){
	obj.DepartLoc.setValue("");
	obj.DepartUser.setValue("");
	obj.DepartType.setValue("");
	obj.DepartGridStore.removeAll();
	obj.DepartGridStore.load({params : {start:0,limit:20}});
	};
}


function DepartMenuWindEvent(obj){
      var objAudit = ExtTool.StaticServerObject("web.PMP.Common");
      obj.LoadEvent = function(){
      obj.DepartMenuAdd.on("click", obj.DepartMenuAdd_OnClick, obj);  //���� �¼�
	  obj.DepartMenuDelete.on("click", obj.DepartMenuDelete_OnClick, obj);  //���� �¼�
   };
   obj.DepartMenuAdd_OnClick=function(){
    var DepartRowid=obj.DepartRowid.getValue();
    var DepartFlag=obj.DepartFlag.getValue();
    var DepartAddLoc=obj.DepartAddLoc.getValue();
    var DepartAddUser=obj.DepartAddUser.getValue();
    var DepartAddType=obj.DepartAddType.getValue();
	if (DepartAddLoc==""){
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '���Ҳ���Ϊ��!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	if (DepartAddUser==""){
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '�û�����Ϊ��!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	if (DepartAddType=="���ҷ���") {
	DepartAddType="L";
	};
	if (DepartAddType=="�������") {
	DepartAddType="F";
	};
	if (DepartAddType==""){DepartAddType="L"}
	if (DepartAddType==""){
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '���Ͳ���Ϊ��!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	try {
	 var inupt=DepartRowid+"^"+DepartFlag+"^"+DepartAddLoc+"^"+DepartAddUser+"^"+DepartAddType;
	 var UpdateRet=objAudit.DepartUpdate(inupt);
	 if (UpdateRet=="1"){
	  ExtTool.LoadCurrPage('DepartGridPanel');
	  Ext.MessageBox.alert('���', '�����������');
	  obj.menuwind.close();
	  
	  //ExtTool.LoadCurrPage('DepartGridPanel');
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
   obj.DepartMenuDelete_OnClick=function(){
   obj.menuwind.close();
   };

}

