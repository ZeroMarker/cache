//Create by zzp
// 20150515
//��ͬ��Ϣ����
function InitviewScreenEvent(obj) {
	var objAudit = ExtTool.StaticServerObject("web.PMP.Common");
	var objAudit1 = ExtTool.StaticServerObject("web.PMP.Document");
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
		var ContractGridGroupid=_record.get('ContractGridGroupid');
		var ContractGridStatusid=_record.get('ContractGridStatusid');
		var ContractGridTypeid=_record.get('ContractGridTypeid');
		var ContractGridPrincipal=_record.get('ContractGridPrincipal');
		var ContractGridContractDate=_record.get('ContractGridContractDate');
		var ContractGridContractTime=_record.get('ContractGridContractTime');
		var ContractGridEffectiveDate=_record.get('ContractGridEffectiveDate');
		var ContractGridEffectiveTime=_record.get('ContractGridEffectiveTime');
		var ContractGridFUser=_record.get('ContractGridFUser');
		var ContractGridSUser=_record.get('ContractGridSUser');
		var ContractGridTPartyid=_record.get('ContractGridTPartyid');
		var ContractGridSPartyid=_record.get('ContractGridSPartyid');
		var ContractGridTUser=_record.get('ContractGridTUser');
		var ContractGridModeEid=_record.get('ContractGridModeEid');
		var ContractGridCondeMid=_record.get('ContractGridCondeMid');
		var ContractGridSourceid=_record.get('ContractGridSourceid');
		var ContractGridDepartment=_record.get('ContractGridDepartment');
		var ContractGridTotalMone=_record.get('ContractGridTotalMone');
		var ContractGridCurrencyid=objAudit1.ContractCurrency(ContractGridRowid);
		var ContractGridFinishDate=_record.get('ContractGridFinishDate');
		var ContractGridFinishTime=_record.get('ContractGridFinishTime');
		var ContractGridMenu=_record.get('ContractGridMenu');
		var ContractGridAbnormal=_record.get('ContractGridAbnormal');
		var ContractGridPigeonhol=_record.get('ContractGridPigeonhol');
		var ContractGridElecticC=_record.get('ContractGridElecticC');
		var ContractGridRemark=_record.get('ContractGridRemark');
		var ContractGridDate=_record.get('ContractGridDate');
		var ContractGridTime=_record.get('ContractGridTime');
		//var ContractGridSourceid=_record.get('ContractGridRemark');
	    distrObj = new ContractMenuWind();
	    distrObj.ContractRowid.setValue(ContractGridRowid);
		distrObj.ContractMenuCode.setValue(ContractGridCode);
		distrObj.ContractMenuDesc.setValue(ContractGridDesc);
		distrObj.ContractMenuPrincipal.setValue(ContractGridPrincipal);
		distrObj.ContractMenuContractDate.setValue(ContractGridContractDate);
		distrObj.ContractMenuContractTime.setValue(ContractGridContractTime);
		distrObj.ContractMenuEffectiveDate.setValue(ContractGridEffectiveDate);
		distrObj.ContractMenuEffectiveTime.setValue(ContractGridEffectiveTime);
		distrObj.ContractMenuFirstUser.setValue(ContractGridFUser);
		distrObj.ContractMenuSecondUser.setValue(ContractGridSUser);
		distrObj.ContractMenuThirdUser.setValue(ContractGridTUser);
		distrObj.ContractMenuDepartment.setValue(ContractGridDepartment);
		distrObj.ContractMenuTotalMoney.setValue(ContractGridTotalMone);
		
		distrObj.ContractMenuFinishDate.setValue(ContractGridFinishDate);
		distrObj.ContractMenuFinishTime.setValue(ContractGridFinishTime);
		distrObj.ContractMenuMenu.setValue(ContractGridMenu);
		distrObj.ContractMenuAbnormal.setValue(ContractGridAbnormal);
		distrObj.ContractMenuRemark.setValue(ContractGridRemark);
	    distrObj.ContractFlag.setValue('Update');
		if (ContractGridFPartyid!=""){
		 distrObj.ContractMenuSupplierStore.on('load', function (){
         distrObj.ContractMenuFirstParty.setValue(ContractGridFPartyid);    
         });
		};

		if (ContractGridSPartyid!=""){
		 distrObj.ContractMenuSupplierStore.on('load', function (){
         distrObj.ContractMenuSecondParty.setValue(ContractGridSPartyid);    
         });
		};
		if (ContractGridStatusid!=""){
		 distrObj.ContractMenuSupplierStore.on('load', function (){
         distrObj.ContractMenuStatus.setValue(ContractGridStatusid);    
         });
		};
		if (ContractGridTPartyid!=""){
		 distrObj.ContractMenuSupplierStore.on('load', function (){
         distrObj.ContractMenuThirdParty.setValue(ContractGridTPartyid);    
         });
		};
	   if (ContractGridGroupid!=""){
		 distrObj.ContractMenuGroupStore.on('load', function (){
         distrObj.ContractMenuGroup.setValue(ContractGridGroupid);    
         });
		};
		if (ContractGridTypeid!=""){
		 distrObj.ContractMenuTypeStore.on('load', function (){
         distrObj.ContractMenuType.setValue(ContractGridTypeid);    
         });
		};
		if (ContractGridModeEid!=""){
		 distrObj.ContractMenuSupplierStore.on('load', function (){
         distrObj.ContractMenuModeE.setValue(ContractGridModeEid);    
         });
		};
		if (ContractGridCondeMid!=""){
		 distrObj.ContractMenuCModeStore.on('load', function (){
         distrObj.ContractMenuCMode.setValue(ContractGridCondeMid);    
         });
		};
		if (ContractGridSourceid!=""){
		 distrObj.ContractMenuSourceStore.on('load', function (){
         distrObj.ContractMenuSource.setValue(ContractGridSourceid);    
         });
		};
		if (ContractGridCurrencyid!=""){
		 distrObj.ContractMenuCurrencyStore.on('load', function (){
         distrObj.ContractMenuCurrency.setValue(ContractGridCurrencyid);    
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
	var objAudit = ExtTool.StaticServerObject("web.PMP.Document");
	try{
	var ContractGridRowid=_record.get('ContractGridRowid');
	var ipAdress=getIpAddress()
	var input=ContractGridRowid+"^"+ipAdress
	var ret=objAudit.ContractDel(input)
	 if (ret.split("!")[0]=="1"){
		    if(ret.split("!")[1]=="1"){
				Ext.MessageBox.alert('���', '�����������');
				ExtTool.LoadCurrPage('ContractGridPanel');
		    }
		    else{
			    Ext.Msg.show({
	      	    title : '��ܰ��ʾ',
				  msg : '����ɾ���ɹ���ͬ��������¼����������룺'+ret,
				  icon : Ext.Msg.WARNING,
				  buttons : Ext.Msg.OK
				  });
			    }
		 }
		 else {
			 Ext.Msg.show({
	      	    title : '��ܰ��ʾ',
				  msg : '���ݲ���ʧ�ܣ�������룺'+ret,
				  icon : Ext.Msg.WARNING,
				  buttons : Ext.Msg.OK
				  });
		return;}

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
		var ContractGridRowid=record.get('ContractGridRowid');
		var ContractGridCode=record.get('ContractGridCode');
		var ContractGridDesc=record.get('ContractGridDesc');
		var ContractGridFPartyid=record.get('ContractGridFPartyid');
		var ContractGridGroupid=record.get('ContractGridGroupid');
		var ContractGridStatusid=record.get('ContractGridStatusid');
		var ContractGridTypeid=record.get('ContractGridTypeid');
		var ContractGridPrincipal=record.get('ContractGridPrincipal');
		var ContractGridContractDate=record.get('ContractGridContractDate');
		var ContractGridContractTime=record.get('ContractGridContractTime');
		var ContractGridEffectiveDate=record.get('ContractGridEffectiveDate');
		var ContractGridEffectiveTime=record.get('ContractGridEffectiveTime');
		var ContractGridFUser=record.get('ContractGridFUser');
		var ContractGridSUser=record.get('ContractGridSUser');
		var ContractGridTPartyid=record.get('ContractGridTPartyid');
		var ContractGridSPartyid=record.get('ContractGridSPartyid');
		var ContractGridTUser=record.get('ContractGridTUser');
		var ContractGridModeEid=record.get('ContractGridModeEid');
		var ContractGridCondeMid=record.get('ContractGridCondeMid');
		var ContractGridSourceid=record.get('ContractGridSourceid');
		var ContractGridDepartment=record.get('ContractGridDepartment');
		var ContractGridTotalMone=record.get('ContractGridTotalMone');
		var ContractGridCurrencyid=objAudit1.ContractCurrency(ContractGridRowid);
		var ContractGridFinishDate=record.get('ContractGridFinishDate');
		var ContractGridFinishTime=record.get('ContractGridFinishTime');
		var ContractGridMenu=record.get('ContractGridMenu');
		var ContractGridAbnormal=record.get('ContractGridAbnormal');
		var ContractGridPigeonhol=record.get('ContractGridPigeonhol');
		var ContractGridElecticC=record.get('ContractGridElecticC');
		var ContractGridRemark=record.get('ContractGridRemark');
		var ContractGridDate=record.get('ContractGridDate');
		var ContractGridTime=record.get('ContractGridTime');
		//var ContractGridSourceid=_record.get('ContractGridRemark');
	    var distrObj = new ContractMenuWind();
	    distrObj.ContractRowid.setValue(ContractGridRowid);
		distrObj.ContractMenuCode.setValue(ContractGridCode);
		distrObj.ContractMenuDesc.setValue(ContractGridDesc);
		distrObj.ContractMenuPrincipal.setValue(ContractGridPrincipal);
		distrObj.ContractMenuContractDate.setValue(ContractGridContractDate);
		distrObj.ContractMenuContractTime.setValue(ContractGridContractTime);
		distrObj.ContractMenuEffectiveDate.setValue(ContractGridEffectiveDate);
		distrObj.ContractMenuEffectiveTime.setValue(ContractGridEffectiveTime);
		distrObj.ContractMenuFirstUser.setValue(ContractGridFUser);
		distrObj.ContractMenuSecondUser.setValue(ContractGridSUser);
		distrObj.ContractMenuThirdUser.setValue(ContractGridTUser);
		distrObj.ContractMenuDepartment.setValue(ContractGridDepartment);
		distrObj.ContractMenuTotalMoney.setValue(ContractGridTotalMone);
		
		distrObj.ContractMenuFinishDate.setValue(ContractGridFinishDate);
		distrObj.ContractMenuFinishTime.setValue(ContractGridFinishTime);
		distrObj.ContractMenuMenu.setValue(ContractGridMenu);
		distrObj.ContractMenuAbnormal.setValue(ContractGridAbnormal);
		distrObj.ContractMenuRemark.setValue(ContractGridRemark);
	    distrObj.ContractFlag.setValue('View');
		
		
		if (ContractGridFPartyid!=""){
		 distrObj.ContractMenuSupplierStore.on('load', function (){
         distrObj.ContractMenuFirstParty.setValue(ContractGridFPartyid);    
         });
		};

		if (ContractGridSPartyid!=""){
		 distrObj.ContractMenuSupplierStore.on('load', function (){
         distrObj.ContractMenuSecondParty.setValue(ContractGridSPartyid);    
         });
		};
		if (ContractGridStatusid!=""){
		 distrObj.ContractMenuSupplierStore.on('load', function (){
         distrObj.ContractMenuStatus.setValue(ContractGridStatusid);    
         });
		};
		if (ContractGridTPartyid!=""){
		 distrObj.ContractMenuSupplierStore.on('load', function (){
         distrObj.ContractMenuThirdParty.setValue(ContractGridTPartyid);    
         });
		};
		if (ContractGridGroupid!=""){
		 distrObj.ContractMenuGroupStore.on('load', function (){
         distrObj.ContractMenuGroup.setValue(ContractGridGroupid);    
         });
		};
		if (ContractGridTypeid!=""){
		 distrObj.ContractMenuTypeStore.on('load', function (){
         distrObj.ContractMenuType.setValue(ContractGridTypeid);    
         });
		};
		if (ContractGridModeEid!=""){
		 distrObj.ContractMenuSupplierStore.on('load', function (){
         distrObj.ContractMenuModeE.setValue(ContractGridModeEid);    
         });
		};
		if (ContractGridCondeMid!=""){
		 distrObj.ContractMenuCModeStore.on('load', function (){
         distrObj.ContractMenuCMode.setValue(ContractGridCondeMid);    
         });
		};
		if (ContractGridSourceid!=""){
		 distrObj.ContractMenuSourceStore.on('load', function (){
         distrObj.ContractMenuSource.setValue(ContractGridSourceid);    
         });
		};
		if (ContractGridCurrencyid!=""){
		 distrObj.ContractMenuCurrencyStore.on('load', function (){
         distrObj.ContractMenuCurrency.setValue(ContractGridCurrencyid);    
         });
		};
		distrObj.menuwindadd.show()
		distrObj.ContractMenuAdd.hide();
		//Ext.getCmp('ContractMenuAdd').getEl().up('.x-form-item').setDisplayed(false);
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
	distrObj = new AdjunctAllWind(ContractGridRowid,"PMP_Contract");
	distrObj.AdjunctAllTypeStore.removeAll();
	distrObj.AdjunctAllType.setValue("PMP_Contract")
	distrObj.AdjunctAllRowid.setValue(ContractGridRowid)
	distrObj.AdjunctAllTypeStore.load({params : {start:0,limit:10}});
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
   var ContractRowid=obj.ContractRowid.getValue();
    var ContractFlag=obj.ContractFlag.getValue();
    var ContractMenuCode=obj.ContractMenuCode.getValue();
    var ContractMenuDesc=obj.ContractMenuDesc.getValue();
    var ContractMenuGroup=obj.ContractMenuGroup.getValue();
    var ContractMenuType=obj.ContractMenuType.getValue();
    var ContractMenuPrincipal=obj.ContractMenuPrincipal.getValue();
    var ContractMenuContractDate=obj.ContractMenuContractDate.getValue();
    var ContractMenuContractTime=obj.ContractMenuContractTime.getValue();
    var ContractMenuEffectiveDate=obj.ContractMenuEffectiveDate.getValue();
    var ContractMenuEffectiveTime=obj.ContractMenuEffectiveTime.getValue();
    var ContractMenuStatus=obj.ContractMenuStatus.getValue();
    var ContractMenuFirstParty=obj.ContractMenuFirstParty.getValue();
    var ContractMenuFirstUser=obj.ContractMenuFirstUser.getValue();
    var ContractMenuSecondParty=obj.ContractMenuSecondParty.getValue();
    var ContractMenuSecondUser=obj.ContractMenuSecondUser.getValue();
    var ContractMenuThirdParty=obj.ContractMenuThirdParty.getValue();
    var ContractMenuThirdUser=obj.ContractMenuThirdUser.getValue();
    var ContractMenuModeE=obj.ContractMenuModeE.getValue();
    var ContractMenuCMode=obj.ContractMenuCMode.getValue();
    var ContractMenuSource=obj.ContractMenuSource.getValue();
    var ContractMenuDepartment=obj.ContractMenuDepartment.getValue();
    var ContractMenuTotalMoney=obj.ContractMenuTotalMoney.getValue();
    var ContractMenuCurrency=obj.ContractMenuCurrency.getValue();
    var ContractMenuFinishDate=obj.ContractMenuFinishDate.getValue();
    var ContractMenuFinishTime=obj.ContractMenuFinishTime.getValue();
    var ContractMenuMenu=obj.ContractMenuMenu.getValue();
    var ContractMenuAbnormal=obj.ContractMenuAbnormal.getValue();
    var ContractMenuRemark=obj.ContractMenuRemark.getValue();
	var ipAdress=getIpAddress()
	if (ContractMenuContractDate!=""){
       ContractMenuContractDate=ContractMenuContractDate.format('Y-m-d');
   };
   if (ContractMenuEffectiveDate!=""){
       ContractMenuEffectiveDate=ContractMenuEffectiveDate.format('Y-m-d');
   };
    if (ContractMenuFinishDate!=""){
       ContractMenuFinishDate=ContractMenuFinishDate.format('Y-m-d');
   };
   
	if (ContractMenuCode==""){
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '��ͬ���벻��Ϊ��!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	if (ContractMenuDesc==""){
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '��ͬ���Ʋ���Ϊ��!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	if (ContractMenuGroup==""){
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '��ͬ���鲻��Ϊ��!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	if (ContractMenuType==""){
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '��ͬ���Ͳ���Ϊ��!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	if (ContractMenuFirstParty==""){
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '��ѡ��׷���˾!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	if (ContractMenuSecondParty==""){
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '��ѡ���ҷ���˾!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	if (ContractMenuModeE==""){
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '��ѡ�����з�ʽ!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	if (ContractMenuSource==""){
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '��ѡ��ɹ���Դ!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	if (ContractMenuTotalMoney==""){
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '����д��ͬ���!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	if (ContractMenuCurrency==""){
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '��ѡ��ɹ�����!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	if (ContractMenuEffectiveDate<ContractMenuContractDate){
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '��Ч���ڲ�������ǩ������!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
		if (ContractMenuFinishDate<ContractMenuEffectiveDate){
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '������ڲ���������Ч����!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};ContractMenuModeE
	
   try{
	    //alert(ContractMenuPrincipal);
   		var input=ContractRowid+"^"+ContractFlag+"^"+ContractMenuCode+"^"+ContractMenuDesc+"^"+ContractMenuGroup;
	 	input=input+"^"+ContractMenuType+"^"+ContractMenuPrincipal+"^"+ContractMenuContractDate+"^"+ContractMenuContractTime+"^"+ContractMenuEffectiveDate;
	    input=input+"^"+ContractMenuEffectiveTime+"^"+ContractMenuStatus+"^"+ContractMenuFirstParty+"^"+ContractMenuFirstUser+"^"+ContractMenuSecondParty;
		input=input+"^"+ContractMenuSecondUser+"^"+ContractMenuThirdParty+"^"+ContractMenuThirdUser+"^"+ContractMenuModeE+"^"+ContractMenuCMode;
		input=input+"^"+ContractMenuSource+"^"+ContractMenuDepartment+"^"+ContractMenuTotalMoney+"^"+ContractMenuCurrency+"^"+ContractMenuFinishDate;
		input=input+"^"+ContractMenuFinishTime+"^"+ContractMenuMenu+"^"+ContractMenuAbnormal+"^"+ContractMenuRemark+"^"+ipAdress;
		//alert(input);
		var UpdateRet=objAudit.ContractAdd(input);
	    if (UpdateRet.split("!")[0]=="1"){
		    if(UpdateRet.split("!")[1]=="1"){
				Ext.MessageBox.alert('���', '�����������');
				distrObj.menuwindadd.close();
				ExtTool.LoadCurrPage('ContractGridPanel');
		    }
		    else{
			    Ext.Msg.show({
	      	    title : '��ܰ��ʾ',
				  msg : '���ݲ���ɹ���ͬ��������¼����������룺'+UpdateRet,
				  icon : Ext.Msg.WARNING,
				  buttons : Ext.Msg.OK
				  });
			    }
		 }
		 else {
			 Ext.Msg.show({
	      	    title : '��ܰ��ʾ',
				  msg : '���ݲ���ʧ�ܣ�������룺'+UpdateRet,
				  icon : Ext.Msg.WARNING,
				  buttons : Ext.Msg.OK
				  });
		return;}
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
	  var ContractRowid=obj.ContractAddRowid.getValue();
      var ContractMode=obj.ContractModeN.getValue();
      if (ContractMode=="")
      {
		   Ext.Msg.show({
	      	    title : '��ܰ��ʾ',
				  msg : '��ѡ��ģ����Ϣ!',
				  icon : Ext.Msg.WARNING,
				  buttons : Ext.Msg.OK
				  });
	    }
      var ipAdress=getIpAddress();
	  try{
		var input=ContractRowid+"^"+ContractMode+"^"+ipAdress
		var UpdateRet=objAudit.AddContractMode(input);
	    if (UpdateRet.split("!")[0]=="Exist"){
		    
			Ext.MessageBox.alert('����ʧ��', '���չ�ϵ�Ѵ��ڣ�');
			return;		 
	    }
	    if (UpdateRet.split("!")[0]=="1"){
		    if(UpdateRet.split("!")[1]=="1"){
			    ExtTool.LoadCurrPage('ContractModePanel');
				Ext.MessageBox.alert('���', '�����������');
				obj.menuwindModeN.close();
		    }
		    else{
			    Ext.Msg.show({
	      	    title : '��ܰ��ʾ',
				  msg : '���ݲ���ɹ���ͬ��������¼����������룺'+UpdateRet,
				  icon : Ext.Msg.WARNING,
				  buttons : Ext.Msg.OK
				  });
			    }
		 }
		 else {
			 Ext.Msg.show({
	      	    title : '��ܰ��ʾ',
				  msg : '���ݲ���ʧ�ܣ�������룺'+UpdateRet,
				  icon : Ext.Msg.WARNING,
				  buttons : Ext.Msg.OK
				  });
		return;}
		  }
	 catch(err)
	 {
		 ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		 }
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

	  var Title=obj.ContractDetailsTitle.getValue();
	    if  (Title==""){
			Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '����д����',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
			return;
		  
	  }
	  //alert(obj.ContractDetailsSub.checked)
	  if(obj.ContractDetailsSub.checked==false)
	  {
		  var subFlag=0
		  var actionFlag="Update"
		  }
		else{
			var subFlag=1
			var actionFlag="Add"	
		}
	  var ipAdress=getIpAddress()
	  var node=obj.tree.getSelectionModel().getSelectedNode()
	  var ContractId=obj.ContractDetailsid.getValue()
	  if (!node)
	  {
		  ContractDetialRowid=ContractId+"||id";
		  actionFlag="Add"
	  }
	  else
	  {
		  ContractDetialRowid=node.id;
	  }
	  var ContractMenu=Ext.getCmp("ContractDetailMenui").getValue()
	  try{
		 var input=ContractDetialRowid+"^"+actionFlag+"^"+Title+"^"+subFlag+"^"+ContractMenu+"^"+ipAdress;
		 //alert(input);
		 var DetailRet=objAudit.AddContractDetails(input);
		 if(DetailRet.split("!")[0]=="1"){
		 	 if(DetailRet.split("!")[1]=="1"){
				Ext.MessageBox.alert('���', '�����������');
				Ext.getCmp('tree').getRootNode().reload();
		   		 }
		    else{
			    Ext.Msg.show({
	      	    title : '��ܰ��ʾ',
				msg : '���ݲ���ɹ���ͬ��������¼����������룺'+DetailRet,
				icon : Ext.Msg.WARNING,
				buttons : Ext.Msg.OK
				  });
			    }
		 }
		 else if(DetailRet.split("!")[0]=="min"){
				Ext.Msg.show({
				title : '��ܰ��ʾ',
				msg : '���ݲ���ʧ�ܣ��ѵ���СĿ¼�����޷���������ӱ���',
				icon : Ext.Msg.WARNING,
				buttons : Ext.Msg.OK
				});
				return;
				};
		 else{
		 Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '���ݲ���ʧ�ܣ��������'+DetailRet,
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
	
	  obj.ContractDetailsQuery_OnClick=function(){
	  Ext.MessageBox.alert('Status','���ڿ����У������ڴ�������');
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