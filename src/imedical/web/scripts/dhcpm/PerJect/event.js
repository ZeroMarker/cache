//Create by zzp
// 20150427
//��Ŀά��
function InitviewScreenEvent(obj) {
	var objAudit = ExtTool.StaticServerObject("web.PMP.Common");
	//obj.intCurrRowIndex = -1;
	obj.LoadEvent = function(args){
		
		
		obj.JectAdd.on("click", obj.JectAdd_OnClick, obj);  //�����¼� 
		
		obj.JectUpdate.on("click", obj.JectUpdate_OnClick, obj);  //�޸� �¼�
		
		obj.JectQuery.on("click", obj.JectQuery_OnClick, obj);  //��ѯ�¼�  
		
		obj.JectBatch.on("click", obj.JectBatch_OnClick, obj ); //�����¼�  
		
		obj.JectName.on("specialkey", obj.JectName_specialkey,obj)  //���һس��¼�
		
		obj.JectHosp.on("specialkey", obj.JectHosp_specialkey,obj)  //�û��س��¼�
		
		obj.JectCode.on("specialkey", obj.JectCode_specialkey,obj)  //��ϵ��ʽ�س��¼�
		
		obj.JectUser.on("specialkey", obj.JectUser_specialkey,obj)  //�����ʼ��س��¼�
		
		//obj.JectGridPanel.on("rowdblclick", obj.JectGridPanel_rowclick,obj)  //˫�����¼�
		
		//obj.JectGridPanel.on("rowclick", obj.JectGridPanel_cellclick,obj)  //�е����¼�
		
		obj.JectGridPanel.on("rowdblclick", obj.JectGridPanel_rowclick,obj)  //˫�����¼�
			
	};

	obj.JectGridPanel_rowclick=function(rowIndex,columnIndex,e){
	obj.JectUpdate_OnClick();
	};
	obj.JectAdd_OnClick=function(){
	try{
		distrObj = new JectMenuWind();
	}catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	} 
	   var RetRowid=objAudit.SelectRetRowid(""); 
	   distrObj.AUJectRowid.setValue('');
	   distrObj.AUJectFlag.setValue('Add');
	   distrObj.AUJectName.setValue('');
	   distrObj.AUJectCode.setValue('');
	   distrObj.AUJectDel.setValue('');
	   distrObj.AUJectDD.setValue('');
	   distrObj.AUJectTel.setValue('');
	   distrObj.AUJectBZ.setValue('');
	   if (RetRowid!=""){
	    distrObj.JectHosStore .on('load', function (){
        distrObj.AUJectHosName.setValue(RetRowid.split("^")[1]);    
         });
	   //distrObj.AUJectHosName.setValue(RetRowid.split("^")[2]);
	   distrObj.AUJectName.setValue(RetRowid.split("^")[2]);
	   distrObj.AUJectCode.setValue(RetRowid.split("^")[3]);
	   };
	   distrObj.menuwind.show();
	
	};
	obj.JectUpdate_OnClick=function(){
	var _record = obj.JectGridPanel.getSelectionModel().getSelected();
	if(!_record){
	  Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '��ѡ����Ҫ�޸ĵ�����!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	}
	else {
	distrObj = new JectMenuWind();
	var JectGridRowid=_record.get('JectGridRowid');
	var JectGridName=_record.get('JectGridName');
	var JectGridHosName=_record.get('JectGridHosName');
	var JectGridUser=_record.get('JectGridUser');
	var JectGridUserZL=_record.get('JectGridUserZL');
	var JectGridCode=_record.get('JectGridCode');
	var JectGridType=_record.get('JectGridType');
	var JectGridDel=_record.get('JectGridDel');
	var JectGridDelDD=_record.get('JectGridDelDD');
	var JectGridTel=_record.get('JectGridTel');
	var JectGridDate=_record.get('JectGridDate');
	var JectGridCreatUser=_record.get('JectGridCreatUser');
	var JectGridbz=_record.get('JectGridbz');
	var RetRowid=objAudit.SelectRetRowid(JectGridRowid);      //"PRO"_"^"_ҽԺid_"^"_��Ŀ����id_"^"_��Ŀ����id_"^"_��Ŀ״̬id
	   distrObj.AUJectRowid.setValue(JectGridRowid);
	   distrObj.AUJectFlag.setValue('Update');
	   distrObj.AUJectName.setValue(JectGridName);
	   distrObj.AUJectCode.setValue(JectGridCode);
	   distrObj.AUJectDel.setValue(JectGridDel);
	   distrObj.AUJectDD.setValue(JectGridDelDD);
	   distrObj.AUJectTel.setValue(JectGridTel);
	   distrObj.AUJectBZ.setValue(JectGridbz);
	   if(JectGridHosName){
	    distrObj.JectHosStore .on('load', function (){
        distrObj.AUJectHosName.setValue(RetRowid.split("^")[1]);    
         });
	   //distrObj.AUJectHosName.valueField.setValue(RetRowid.split("^")[1]);
	   //distrObj.AUJectHosName.setValue(JectGridHosName);
	   };
	   if(JectGridUser){
	    distrObj.JectUserStore .on('load', function (){
        distrObj.AUJectUser.setValue(RetRowid.split("^")[2]);    
         });
	   //distrObj.AUJectUser.setValue(JectGridUser);
	   };
	   if(JectGridUserZL){
	    distrObj.JectUserStore .on('load', function (){
        distrObj.AUJectUserZL.setValue(RetRowid.split("^")[3]);    
         });
	   //distrObj.AUJectUserZL.setValue(JectGridUserZL);
	   };
	   if(JectGridType){
	   distrObj.JectPerTypeStore .on('load', function (){
        distrObj.AUJectType.setValue(RetRowid.split("^")[4]);    
         });
	   //distrObj.AUJectType.setValue(JectGridType);
	   };
	   distrObj.menuwind.show();
	};
	};
	obj.JectName_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.JectQuery_OnClick();
	};
	};
	obj.JectUser_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.JectQuery_OnClick();
	};
	};
	obj.JectHosp_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.JectQuery_OnClick();
	};
	};
	obj.JectCode_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.JectQuery_OnClick();
	};
	};
	obj.JectQuery_OnClick=function(){
	var JectName=obj.JectName.getValue();
	var JectHosp=obj.JectHosp.getValue();
	var JectCode=obj.JectCode.getValue();
	var JectUser=obj.JectUser.getValue();
	var InPut=JectName+"^"+JectHosp+"^"+JectCode+"^"+JectUser;
    obj.JectGridStore.removeAll();
	obj.JectGridStore.load({params:{InPut:InPut}});
	};
	obj.JectBatch_OnClick=function(){
	obj.JectName.setValue("");
	obj.JectHosp.setValue("");
	obj.JectCode.setValue("");
	obj.JectUser.setValue("");
	obj.JectGridStore.removeAll();
	obj.JectGridStore.load();
	};
}

function JectMenuWindEvent(obj){
      var objAudit = ExtTool.StaticServerObject("web.PMP.Common");
      obj.LoadEvent = function(){
      obj.AUJectAdd.on("click", obj.AUJectAdd_OnClick, obj);  //���� �¼�
	  obj.AUJectDelete.on("click", obj.AUJectDelete_OnClick, obj);  //���� �¼�
	  
   };
   obj.AUJectAdd_OnClick=function(){
    var AUJectRowid=obj.AUJectRowid.getValue();
    var AUJectFlag=obj.AUJectFlag.getValue();
    var AUJectName=obj.AUJectName.getValue();
    var AUJectCode=obj.AUJectCode.getValue();
    var AUJectHosName=obj.AUJectHosName.getValue();
    var AUJectUser=obj.AUJectUser.getValue();
	var AUJectUserZL=obj.AUJectUserZL.getValue();
	var AUJectType=obj.AUJectType.getValue();
	var AUJectDel=obj.AUJectDel.getValue();
	var AUJectDD=obj.AUJectDD.getValue();
	var AUJectTel=obj.AUJectTel.getValue();
	var AUJectBZ=obj.AUJectBZ.getValue();
	if (AUJectType==""){AUJectType="Y"};
	if (AUJectName==""){
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '��Ŀ���Ʋ���Ϊ��!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	if (AUJectCode==""){
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '��Ŀ���벻��Ϊ��!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	if (AUJectHosName==""){
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : 'ҽԺ���Ʋ���Ϊ��!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	if (AUJectUser==""){
	Ext.MessageBox.confirm('��ʾ', '��Ŀ����Ϊ�գ��Ƿ�Ҫ����������', function(btn) {
	if (btn=="yes"){
	try {
	  var Input=AUJectFlag+"^"+AUJectName+"^"+AUJectCode+"^"+AUJectHosName+"^"+AUJectUser+"^"+AUJectUserZL+"^"+AUJectType+"^"+AUJectDel+"^"+AUJectDD+"^"+AUJectTel+"^"+AUJectRowid;
	  var AddUpdateRet=objAudit.ProAddUpdate(Input,AUJectBZ);
	  if (AddUpdateRet=="1"){
	  Ext.MessageBox.alert('���', '�����������');
	  obj.menuwind.close();
	  ExtTool.LoadCurrPage('JectGridPanel');
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
	  var Input=AUJectFlag+"^"+AUJectName+"^"+AUJectCode+"^"+AUJectHosName+"^"+AUJectUser+"^"+AUJectUserZL+"^"+AUJectType+"^"+AUJectDel+"^"+AUJectDD+"^"+AUJectTel+"^"+AUJectRowid;
	  var AddUpdateRet=objAudit.ProAddUpdate(Input,AUJectBZ);
	  if (AddUpdateRet=="1"){
	  Ext.MessageBox.alert('���', '�����������');
	  obj.menuwind.close();
	  ExtTool.LoadCurrPage('JectGridPanel');
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
   obj.AUJectDelete_OnClick=function(){
   obj.menuwind.close();
   };

}
