//Create by zzp
// 20150515
//��˾����

var CompTabMessage="";
var CompInputOld="";
var CompInputNew="";
var CompTabFieldName="PCRowid@@PCCode@@PCDesc@@PCAddress@@PCPhone@@PCWebsite@@PCEmeail@@PCLawPerson@@PCType@@PCListing@@PCPhone1@@PCPhone2@@PCPostCdoe@@PCEmeail1@@PCEmeail2@@PCRemark";

function InitviewScreenEvent(obj) {
	var objAudit = ExtTool.StaticServerObject("web.PMP.Document");

	//obj.intCurrRowIndex = -1;
	obj.LoadEvent = function(args){

		obj.CompanyAdd.on("click", obj.CompanyAdd_OnClick, obj);  //�����¼� 
		
		obj.CompanyUpdate.on("click", obj.CompanyUpdate_OnClick, obj);  //�޸� �¼�
		
		obj.CompanyQuery.on("click", obj.CompanyQuery_OnClick, obj);  //��ѯ�¼�  
		
		obj.CompanyBatch.on("click", obj.CompanyBatch_OnClick, obj ); //�����¼�  
		
		obj.CompanyDelete.on("click", obj.CompanyDelete_OnClick, obj ); //ɾ���¼�  
		
		obj.CompanyTel.on("specialkey", obj.CompanyTel_specialkey,obj)  //��ϵ��ʽ�س��¼�
		
		obj.CompanyCode.on("specialkey", obj.CompanyCode_specialkey,obj)  //����س��¼�
		
		obj.CompanyDesc.on("specialkey", obj.CompanyDesc_specialkey,obj)  //�����س��¼�
		
		obj.CompanyAddress.on("specialkey",obj.CompanyAddress_specialkey,obj)  //��ַ�س��¼�
		
		obj.CompanyGridPanel.on("rowdblclick", obj.CompanyGridPanel_rowclick,obj)  //˫�����¼�
		
		//obj.CompanyGridPanel.on("rowclick", obj.CompanyGridPanel_cellclick,obj)  //�е����¼�
			
	};
	obj.CompanyAdd_OnClick=function (){
	try{
		distrObj = new CompanyMenuWind();
	    distrObj.CompanyRowid.setValue('');
	    distrObj.CompanyFlag.setValue('Add');
	    distrObj.CompanyMenuCode.setValue('');
	    distrObj.CompanyMenuDesc.setValue('');
	    distrObj.CompanyMenuTel.setValue('');	    
	    
	    distrObj.menuwindadd.show();
	}catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	obj.CompanyUpdate_OnClick=function(){
	var _record = obj.CompanyGridPanel.getSelectionModel().getSelected();
	if(!_record){
	  Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '��ѡ����Ҫ�޸ĵ�����!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	}
	else {
	//alert("�����¼�0");
	try{
	    var CompanyGridRowid=_record.get('CompanyGridRowid');
		distrObj = new CompanyMenuWind();
	    distrObj.CompanyRowid.setValue(CompanyGridRowid);
	    distrObj.CompanyFlag.setValue('Update');
	    var CompanyGridCode=_record.get('CompanyGridCode');
	    distrObj.CompanyMenuCode.setValue(CompanyGridCode);
	    var CompanyGridDesc=_record.get('CompanyGridDesc');
	    distrObj.CompanyMenuDesc.setValue(CompanyGridDesc);
	    var CompanyGridAddress=_record.get('CompanyGridAddress');
	    distrObj.CompanyMenuAddress.setValue(CompanyGridAddress);
	    var CompanyGridPhone=_record.get('CompanyGridPhone');
	    distrObj.CompanyMenuTel.setValue(CompanyGridPhone);
	    var CompanyGridWebsite=_record.get('CompanyGridWebsite');
	    distrObj.CompanyMenuWebsite.setValue(CompanyGridWebsite);
	    var CompanyGridEmail=_record.get('CompanyGridEmail');
	    distrObj.CompanyMenuEmeail.setValue(CompanyGridEmail);
	    var CompanyGridLawPerson=_record.get('CompanyGridLawPerson');
	    distrObj.CompanyMenuLawPerson.setValue(CompanyGridLawPerson);
	    var CompanyGridType=_record.get('CompanyGridType');
		var CompanyGridTypeid=_record.get('CompanyGridTypeid');
		if (CompanyGridTypeid!=""){
			distrObj.CompanyMenuTypeStore.on('load', function (){
        		distrObj.CompanyMenuType.setValue(CompanyGridTypeid);    
        	});
		};
	    var CompanyGridListing=_record.get('CompanyGridListing');
	    var CompanyGridPhone1=_record.get('CompanyGridPhone1');
	    distrObj.CompanyMenuTel1.setValue(CompanyGridPhone1);
	    var CompanyGridPhone2=_record.get('CompanyGridPhone2');
	    distrObj.CompanyMenuTel2.setValue(CompanyGridPhone2);
	    var CompanyGridPostCdoe=_record.get('CompanyGridPostCdoe');
	    distrObj.CompanyMenuPostCdoe.setValue(CompanyGridPostCdoe);
	    var CompanyGridEmail1=_record.get('CompanyGridEmail1');
	    distrObj.CompanyMenuEmeail1.setValue(CompanyGridEmail1);
	    var CompanyGridEmail2=_record.get('CompanyGridEmail2');
	    distrObj.CompanyMenuEmeail2.setValue(CompanyGridEmail2);
	    var CompanyGridRemark=_record.get('CompanyGridRemark');
	    distrObj.CompanyMenuRemark.setValue(CompanyGridRemark);
		
		var CompanyGridListingid=_record.get('CompanyGridListingid');
	    if (CompanyGridListingid!=""){
		 distrObj.CompanyMenuListingStore.on('load', function (){
         distrObj.CompanyMenuListing.setValue(CompanyGridListingid);    
         });
		};		
		CompInputOld=CompanyGridRowid
		CompInputOld=CompInputOld+"@@"+CompanyGridCode
		CompInputOld=CompInputOld+"@@"+CompanyGridDesc
		CompInputOld=CompInputOld+"@@"+CompanyGridAddress
		CompInputOld=CompInputOld+"@@"+CompanyGridPhone
		CompInputOld=CompInputOld+"@@"+CompanyGridWebsite
		CompInputOld=CompInputOld+"@@"+CompanyGridEmail
		CompInputOld=CompInputOld+"@@"+CompanyGridLawPerson
		CompInputOld=CompInputOld+"@@"+CompanyGridType
		CompInputOld=CompInputOld+"@@"+CompanyGridListing
		CompInputOld=CompInputOld+"@@"+CompanyGridPhone1
		CompInputOld=CompInputOld+"@@"+CompanyGridPhone2
		CompInputOld=CompInputOld+"@@"+CompanyGridPostCdoe
		CompInputOld=CompInputOld+"@@"+CompanyGridEmail1
		CompInputOld=CompInputOld+"@@"+CompanyGridEmail2
		CompInputOld=CompInputOld+"@@"+CompanyGridRemark
		
	    distrObj.menuwindadd.show();
	}catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	};
	obj.CompanyQuery_OnClick=function(){
	 //ȡֵ��ʼ
		var CompanyTCode=obj.CompanyCode.getValue();
		var CompanyTDesc=obj.CompanyDesc.getValue();
		var CompanyTAddress=obj.CompanyAddress.getValue();
		var CompanyTTel=obj.CompanyTel.getValue();

		var InPut1=CompanyTCode+"^"+CompanyTDesc+"^"+CompanyTAddress+"^"+CompanyTTel;
		obj.CompanyGridStore.removeAll();
		obj.CompanyGridStore.load({params:{InPut:InPut1}});
	};
	obj.CompanyBatch_OnClick=function(){		
		obj.CompanyCode.setValue("");
		obj.CompanyDesc.setValue("");
		obj.SysText.setValue("");
		obj.CompanyTel.setValue("");
		obj.CompanyGridStore.removeAll();
		obj.CompanyGridStore.load();
	};
	obj.CompanyDelete_OnClick=function(){
	var _record = obj.CompanyGridPanel.getSelectionModel().getSelected();
	if(!_record){
	  Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '��ѡ����Ҫ�޸ĵ�����!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	}
	else {
	    var CompanyGridRowid=_record.get('CompanyGridRowid');
		//delete start
		Ext.MessageBox.confirm('��ʾ', '��Ҫɾ����ǰѡ��Ĺ�˾��Ϣ���Ƿ�Ҫ����������', function(btn) {
			if (btn=="yes"){
				try {
					var AUJectBZ="Delete"
					CompInputNew=CompanyGridRowid
					CompInputNew=CompInputNew+"@@@@@@@@@@@@@@@@�ɷ���@@����@@@@@@@@@@@@"	
					
					var AddUpdateRet=objAudit.CompanyAddUpdate(CompInputNew,AUJectBZ,getIpAddress());
					if (AddUpdateRet=="1"){
						CompTabMessage="PMP_Company@@"+CompanyGridRowid+"@@"+AUJectBZ+"@@"+getIpAddress();
						var AddUpdateLogRet=objAudit.PMPOperatingRecord(CompTabMessage,"","","");
						if (AddUpdateLogRet=="1"){
							Ext.MessageBox.alert('���', 'ɾ���������');
							ExtTool.LoadCurrPage('CompanyGridPanel');
						}
						else{
							Ext.Msg.show({
							  title : '��ܰ��ʾ',
							  msg : 'ɾ�����ݳɹ�����־����ʧ�ܣ�������룺'+AddUpdateLogRet,
							  icon : Ext.Msg.WARNING,
							  buttons : Ext.Msg.OK
							  });
							return;
						}; 
					}
					else{
						Ext.Msg.show({
						  title : '��ܰ��ʾ',
						  msg : 'ɾ�����ݲ���ʧ�ܣ�������룺'+AddUpdateRet,
						  icon : Ext.Msg.WARNING,
						  buttons : Ext.Msg.OK
						  });
						return;
					}; 
				}catch(err){
					ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
				}
			}
			else{
				return;
			};
		});
		//delete end
	};
	};
	obj.CompanyAddress_specialkey=function (field,e){
		if (e.keyCode== 13){
			obj.CompanyQuery_OnClick();
		};
	};
		obj.CompanyTel_specialkey=function(field,e){
		if (e.keyCode== 13){
			obj.CompanyQuery_OnClick();
		};
	};
	obj.CompanyCode_specialkey=function (field,e){
		if (e.keyCode== 13){
			obj.CompanyQuery_OnClick();
		};
	};
	obj.CompanyDesc_specialkey=function(field,e){
		if (e.keyCode== 13){
			obj.CompanyQuery_OnClick();
		};
	};
	obj.CompanyGridPanel_rowclick=function(rowIndex,columnIndex,e){
		obj.CompanyUpdate_OnClick();
	};
}
function CompanyMenuWindEvent(obj){
    var objAudit = ExtTool.StaticServerObject("web.PMP.Document");
	var ipAdress=getIpAddress()
	obj.LoadEvent = function(args){
	    obj.CompanyMenuAdd.on("click", obj.CompanyMenuAdd_OnClick, obj);  //�����¼� 
		
		obj.CompanyMenuDelete.on("click", obj.CompanyMenuDelete_OnClick, obj);  //�����¼�
	};
    obj.CompanyMenuAdd_OnClick=function (){
	 //ȡֵ��ʼ
	var CompanyGridRowid=obj.CompanyRowid.getValue();
	var CompanyGridCode=obj.CompanyMenuCode.getValue();
	var CompanyGridDesc=obj.CompanyMenuDesc.getValue();
	var CompanyGridAddress=obj.CompanyMenuAddress.getValue();
	var CompanyGridPhone=obj.CompanyMenuTel.getValue();
	var CompanyGridWebsite=obj.CompanyMenuWebsite.getValue();
	var CompanyGridEmail=obj.CompanyMenuEmeail.getValue();
	var CompanyGridLawPerson=obj.CompanyMenuLawPerson.getValue();
	var CompanyGridType=obj.CompanyMenuType.getValue();
	if (obj.CompanyMenuType.getRawValue()==CompanyGridType){CompanyGridType=""};
	var CompanyGridListing=obj.CompanyMenuListing.getValue();
	if (obj.CompanyMenuListing.getRawValue()==CompanyGridListing){CompanyGridListing=""};
	if (CompanyGridListing=="δ����"){
		CompanyGridListing="N"
	}else if (CompanyGridListing=="������"){
		CompanyGridListing="Y"
	}else if (CompanyGridListing=="����"){
		CompanyGridListing="Other"
	};
	var CompanyGridPhone1=obj.CompanyMenuTel1.getValue();
	var CompanyGridPhone2=obj.CompanyMenuTel2.getValue();
	var CompanyGridPostCdoe=obj.CompanyMenuPostCdoe.getValue();
	var CompanyGridEmail1=obj.CompanyMenuEmeail1.getValue();
	var CompanyGridEmail2=obj.CompanyMenuEmeail2.getValue();
	var CompanyGridRemark=obj.CompanyMenuRemark.getValue();	
	
	CompInputNew=CompanyGridRowid
	CompInputNew=CompInputNew+"@@"+CompanyGridCode
	CompInputNew=CompInputNew+"@@"+CompanyGridDesc
	CompInputNew=CompInputNew+"@@"+CompanyGridAddress
	CompInputNew=CompInputNew+"@@"+CompanyGridPhone
	CompInputNew=CompInputNew+"@@"+CompanyGridWebsite
	CompInputNew=CompInputNew+"@@"+CompanyGridEmail
	CompInputNew=CompInputNew+"@@"+CompanyGridLawPerson
	CompInputNew=CompInputNew+"@@"+CompanyGridType
	CompInputNew=CompInputNew+"@@"+CompanyGridListing
	CompInputNew=CompInputNew+"@@"+CompanyGridPhone1
	CompInputNew=CompInputNew+"@@"+CompanyGridPhone2
	CompInputNew=CompInputNew+"@@"+CompanyGridPostCdoe
	CompInputNew=CompInputNew+"@@"+CompanyGridEmail1
	CompInputNew=CompInputNew+"@@"+CompanyGridEmail2
	CompInputNew=CompInputNew+"@@"+CompanyGridRemark	

	var AUJectBZ="Update"
	if (CompanyGridRowid==""){CompanyGridRowid="0";AUJectBZ="Add"};

	if (CompanyGridCode==""){
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '��˾���벻��Ϊ��!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	if (CompanyGridDesc==""){
	Ext.Msg.show({
			  title : '��ܰ��ʾ',
			  msg : '��˾���Ʋ���Ϊ��!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	
	var OpCompInputOld="" 
	var OpCompInputNew="" 
	var OpCompTabFieldName=""
	var j=0

	TempCompInputOld=CompInputOld.split("@@")
	TempCompInputNew=CompInputNew.split("@@")
	TempCompTabFieldName=CompTabFieldName.split("@@")
	
	for (i=1;i<TempCompTabFieldName.length ;i++ ) 
	{ 
		if ((TempCompInputNew[i]!=TempCompInputOld[i])&&(TempCompInputNew[i]!=""))
		{
			if (OpCompInputOld!="")
			{
				OpCompInputOld=OpCompInputOld+"@@"+TempCompInputOld[i]
				OpCompInputNew=OpCompInputNew+"@@"+TempCompInputNew[i]
				OpCompTabFieldName=OpCompTabFieldName+"@@"+TempCompTabFieldName[i]
				j=j+1
			}else
			{
				OpCompInputOld=TempCompInputOld[i]
				OpCompInputNew=TempCompInputNew[i]
				OpCompTabFieldName=TempCompTabFieldName[i]
				j=j+1
			}
		}
	} 
	
	if (j==0){
	Ext.Msg.show({
			  title : '��ܰ��ʾ',
			  msg : '��˾��Ϣû�б仯������Ҫ�޸�!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	
	//���濪ʼ
	var AUJectUser=""
	if (AUJectUser==""){
		Ext.MessageBox.confirm('��ʾ', '���������޸Ľ��б��棬�Ƿ�Ҫ����������', function(btn) {
			if (btn=="yes"){
				try {					
					var AddUpdateRet=objAudit.CompanyAddUpdate(CompInputNew,AUJectBZ,ipAdress);
					if (AddUpdateRet=="1"){
						//CompTabMessage="PMP_Company@@"+CompanyGridRowid+"@@"+AUJectBZ+"@@"+getIpAddress();
						//alert(CompTabFieldName);
						//var AddUpdateLogRet=objAudit.PMPOperatingRecord(CompTabMessage,OpCompInputOld,OpCompInputNew,OpCompTabFieldName);
						if (AddUpdateRet=="1"){
							Ext.MessageBox.alert('���', '�����������');
							obj.menuwindadd.close();
							ExtTool.LoadCurrPage('CompanyGridPanel');
						}
						else{
							Ext.Msg.show({
							  title : '��ܰ��ʾ',
							  msg : '�������ݳɹ�����־����ʧ�ܣ�������룺'+AddUpdateLogRet,
							  icon : Ext.Msg.WARNING,
							  buttons : Ext.Msg.OK
							  });
							return;
						}; 
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
				}catch(err){
					ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
				}
			}
			else{
				return;
			};
		});
	}
	else {

	};
	 //�������
	};
	obj.CompanyMenuDelete_OnClick=function(){
		obj.menuwindadd.close();
	};
}