//Create by zzp
// 20150427
//ģ��ά��
function InitviewScreenEvent(obj) {
	var objAudit = ExtTool.StaticServerObject("web.PMP.Common");
	//obj.intCurrRowIndex = -1;
	obj.LoadEvent = function(args){
		
		
		obj.ModeuleAdd.on("click", obj.ModeuleAdd_OnClick, obj);  //�����¼� 
		
		obj.ModeuleUpdate.on("click", obj.ModeuleUpdate_OnClick, obj);  //�޸� �¼�
		
		obj.ModeuleQuery.on("click", obj.ModeuleQuery_OnClick, obj);  //��ѯ�¼�  
		
		obj.ModeuleBatch.on("click", obj.ModeuleBatch_OnClick, obj ); //�����¼�  
		
		obj.ModeuleName.on("specialkey", obj.ModeuleName_specialkey,obj)  //ģ�����ƻس��¼�
		
		obj.ModeuleStandby1.on("specialkey", obj.ModeuleStandby1_specialkey,obj)  //�汾�Żس��¼�
		
		obj.ModeuleCode.on("specialkey", obj.ModeuleCode_specialkey,obj)  //��ϵ��ʽ�س��¼�
		
		obj.ModeuleStatus.on("specialkey", obj.ModeuleStatus_specialkey,obj)  //�����ʼ��س��¼�
		
		//obj.ModeuleGridPanel.on("rowdblclick", obj.ModeuleGridPanel_rowclick,obj)  //˫�����¼�
		
		//obj.ModeuleGridPanel.on("rowclick", obj.ModeuleGridPanel_cellclick,obj)  //�е����¼�
		
		obj.ModeuleGridPanel.on("rowdblclick", obj.ModeuleGridPanel_rowclick,obj)  //˫�����¼�
		
		obj.ModeuleGridPanel.on('cellclick',obj.ModeuleGridPanel_CellClick,obj)  
			
	};
    obj.ModeuleGridPanel_CellClick=function(grid, rowIndex, columnIndex, e){
	var btn = e.getTarget('.controlBtn');  
	if (btn){  
    var t = e.getTarget();  
    var record = obj.ModeuleGridPanel.getStore().getAt(rowIndex);  
	var control = t.className; 
	var ModeuleGridRowid=record.get('ModeuleGridRowid');
	if(control=="ContractDetail"){
	try{
	    distrObj = new ModeuleImproWind();
		distrObj.ModeuleIMRowid.setValue(ModeuleGridRowid);
	    distrObj.menuwindMode.show();
		distrObj.ModeuleImproStore.removeAll();
	    distrObj.ModeuleImproStore.load({params : {start:0,limit:20}});
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	}
	};
	obj.ModeuleGridPanel_rowclick=function(rowIndex,columnIndex,e){
	obj.ModeuleUpdate_OnClick();
	//distrObj = new ModeuleImproWind();
    //distrObj.ModeuleIMRowid.setValue(ModeuleGridRowid);
	};
	obj.ModeuleAdd_OnClick=function(){
	try{
		distrObj = new ModeuleMenuWind();
		distrObj.ModRowid.setValue('');
	    distrObj.ModFlag.setValue('Add');
	    distrObj.ModName.setValue('');
	    distrObj.ModCode.setValue('');
	    //distrObj.ModProName.setValue('');
	    distrObj.ModSdy1.setValue('');
	    //distrObj.ModPerJ.setValue('');
	    distrObj.ModPerUser.setValue('');
	    distrObj.ModEar.setValue('');
	    distrObj.menuwind.show();
	}catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	}; 
	};
	obj.ModeuleUpdate_OnClick=function(){
	var _record = obj.ModeuleGridPanel.getSelectionModel().getSelected();
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
	   distrObj = new ModeuleMenuWind();
	   var ModeuleGridRowid=_record.get('ModeuleGridRowid');
	   var ModeuleGridName=_record.get('ModeuleGridName');
	   var ModeuleGridCode=_record.get('ModeuleGridCode');
	   var ModeuleGridStandby1=_record.get('ModeuleGridStandby1');
	   var ModeuleGridProduct=_record.get('ModeuleGridProduct');
	   var ModeuleGridStandby2=_record.get('ModeuleGridStandby2');
	   var ModeuleGridProduct1=_record.get('ModeuleGridProduct1');
	   var ModeuleGridStatus=_record.get('ModeuleGridStatus');
	   var ModeuleGridPlanDate=_record.get('ModeuleGridPlanDate');
	   var ModeuleGridActuclDate=_record.get('ModeuleGridActuclDate');
	   var ModeuleGridRemark=_record.get('ModeuleGridRemark');
	   var ModeuleGridCPid=_record.get('ModeuleGridCPid');  //��Ʒ
	   var ModeuleGridContractid=_record.get('ModeuleGridContractid'); //��ͬ
	   var ModeuleGridGroupid=_record.get('ModeuleGridGroupid');  //����
	   if (ModeuleGridCPid!=""){
	   distrObj.ModeulePerPCStore .on('load', function (){
       distrObj.ModProPC.setValue(ModeuleGridCPid);    
         });
	   };
	   if (ModeuleGridGroupid!=""){
	   distrObj.ModeulePerGroupStore .on('load', function (){
       distrObj.ModProGroup.setValue(ModeuleGridGroupid);    
         });
	   };
	   if (ModeuleGridContractid!=""){
	   distrObj.ModeulePerContractStore .on('load', function (){
       distrObj.ModProContract.setValue(ModeuleGridContractid);    
         });
	   };
	   var ModRowidRet=objAudit.SelectModRowid(ModeuleGridRowid);
	   distrObj.ModRowid.setValue(ModeuleGridRowid);
	   distrObj.ModFlag.setValue('Update');
	   distrObj.ModName.setValue(ModeuleGridName);
	   distrObj.ModCode.setValue(ModeuleGridCode);
	   distrObj.ModeuleProNameStore .on('load', function (){
       distrObj.ModProName.setValue(ModRowidRet.split("^")[1]);    
         });
	   //distrObj.ModProName.setValue(ModeuleGridProduct);  
	   distrObj.ModSdy1.setValue(ModeuleGridStandby1);
	   distrObj.ModPerJStore .on('load', function (){
       distrObj.ModPerJ.setValue(ModRowidRet.split("^")[0]);    
         });
	   //distrObj.ModPerJ.setValue(ModeuleGridProduct1);
	   distrObj.ModPerUser.setValue(ModeuleGridStandby2);
	   distrObj.ModEar.setValue(ModeuleGridRemark);
	   distrObj.ModStatusStore .on('load', function (){
       distrObj.ModStatus.setValue(ModRowidRet.split("^")[2]);    
         });
	   //distrObj.ModStatus.setValue(ModeuleGridStatus);
	   if (ModeuleGridPlanDate!=""){
	   distrObj.ModPanDate.setValue(ModeuleGridPlanDate);
	   };
	   if (ModeuleGridActuclDate!=""){
	   distrObj.ModDate.setValue(ModeuleGridActuclDate);
	   };
	   distrObj.menuwind.show();
	}catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	} 
	};
	};
	obj.ModeuleName_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.ModeuleQuery_OnClick();
	};
	};
	obj.ModeuleStatus_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.ModeuleQuery_OnClick();
	};
	};
	obj.ModeuleStandby1_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.ModeuleQuery_OnClick();
	};
	};
	obj.ModeuleCode_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.ModeuleQuery_OnClick();
	};
	};
	obj.ModeuleQuery_OnClick=function(){
	var ModeuleName=obj.ModeuleName.getValue();
	var ModeuleStandby1=obj.ModeuleStandby1.getValue();
	var ModeuleCode=obj.ModeuleCode.getValue();
	var ModeuleStatus=obj.ModeuleStatus.getValue();
	var InPut=ModeuleName+"^"+ModeuleStandby1+"^"+ModeuleCode+"^"+ModeuleStatus;
    obj.ModeuleGridStore.removeAll();
	obj.ModeuleGridStore.load({params : {start:0,limit:20}});
	};
	obj.ModeuleBatch_OnClick=function(){
	obj.ModeuleName.setValue("");
	obj.ModeuleStandby1.setValue("");
	obj.ModeuleCode.setValue("");
	obj.ModeuleStatus.setValue("");
	obj.ModeuleGridStore.removeAll();
	obj.ModeuleGridStore.load();
	};
}

function ModeuleMenuWindEvent(obj){
      var objAudit = ExtTool.StaticServerObject("web.PMP.Common");
      obj.LoadEvent = function(){
      obj.ModAdd.on("click", obj.ModAdd_OnClick, obj);  //���� �¼�
	  obj.ModDelete.on("click", obj.ModDelete_OnClick, obj);  //���� �¼�
	  
   };
   obj.ModAdd_OnClick=function(){
    var ModRowid=obj.ModRowid.getValue();
    var ModFlag=obj.ModFlag.getValue();
    var ModName=obj.ModName.getValue();
    var ModCode=obj.ModCode.getValue();
    var ModProName=obj.ModProName.getValue();
    var ModSdy1=obj.ModSdy1.getValue();
	var ModPerJ=obj.ModPerJ.getValue();
	var ModPerUser=obj.ModPerUser.getValue();
	var ModStatus=obj.ModStatus.getValue();
	var ModPanDate=obj.ModPanDate.getValue();
	var ModDate=obj.ModDate.getValue();
	var ModEar=obj.ModEar.getValue();
	var ModProPC=obj.ModProPC.getValue();
	var ModProContract=obj.ModProContract.getValue();
	var ModProGroup=obj.ModProGroup.getValue();
	if (ModProPC==""){
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '��Ʒ�������ܿ�!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	}
	if (ModProName==""){
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '����״̬���ܿ�!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	}
	if(ModPanDate!=""){
	ModPanDate=ModPanDate.format('Y-m-d');
	};
	if(ModDate!=""){
	ModDate=ModDate.format('Y-m-d');
	};
	if (ModDate>new Date().format('Y-m-d')){
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : 'ʵ���������ڲ��ܴ��ڽ���!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	if (ModName==""){
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : 'ģ�����Ʋ���Ϊ��!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	if (ModCode==""){
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : 'ģ����벻��Ϊ��!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	if (ModSdy1==""){
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '�汾�Ų���Ϊ��!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	if (ModPerJ==""){
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '��Ʒ�鲻��Ϊ��!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	if (ModStatus==""){
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '״̬����Ϊ��!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	if (ModProName==""){
	Ext.MessageBox.confirm('��ʾ', '��ĿΪ�գ��Ƿ�Ҫ����������', function(btn) {
	if (btn=="yes"){
	try {
	  var Input=ModRowid+"^"+ModFlag+"^"+ModName+"^"+ModCode+"^"+ModProName+"^"+ModSdy1+"^"+ModPerJ+"^"+ModPerUser+"^"+ModStatus+"^"+ModPanDate+"^"+ModDate+"^"+ModProPC+"^"+ModProContract+"^"+ModProGroup;
	  var AddUpdateRet=objAudit.ModAddUpdate(Input,ModEar);
	  if (AddUpdateRet=="1"){
	  Ext.MessageBox.alert('���', '�����������');
	  obj.menuwind.close();
	  ExtTool.LoadCurrPage('ModeuleGridPanel');
	  }
	  else{
	  Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '���ݲ���ʧ�ܣ�������룺'+AddUpdateRet,
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	   return;
	  };
	  
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	}
	}
	else{
	return;
	};
	});
	}
	else {
	try {
	  var Input=ModRowid+"^"+ModFlag+"^"+ModName+"^"+ModCode+"^"+ModProName+"^"+ModSdy1+"^"+ModPerJ+"^"+ModPerUser+"^"+ModStatus+"^"+ModPanDate+"^"+ModDate+"^"+ModProPC+"^"+ModProContract+"^"+ModProGroup;
	  var AddUpdateRet=objAudit.ModAddUpdate(Input,ModEar);
	  if (AddUpdateRet=="1"){
	  Ext.MessageBox.alert('���', '�����������');
	  obj.menuwind.close();
	  ExtTool.LoadCurrPage('ModeuleGridPanel');
	  }
	  else{
	  Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '���ݲ���ʧ�ܣ�������룺'+AddUpdateRet,
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
   };
   obj.ModDelete_OnClick=function(){
   obj.menuwind.close();
   };

}

