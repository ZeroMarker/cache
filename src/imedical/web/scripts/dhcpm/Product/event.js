//Create by zzp
// 20150515
//��Ʒ����
var ProdTabMessage="";
var ProdInputOld="";
var ProdInputNew="";
var ProdTabFieldName="PPDRowid@@PPDCode@@PPDDesc@@PPDType@@PPDVersions@@PPDStandard@@PPDSupplierDR@@PPDProducerDR@@PPDProducerDR@@PPDUnit@@PPDPrice@@PPDTotalPrice@@PPDPurchaseData@@PPDPurchaseTime@@PPDPurchaseUser@@PPDGoodsData@@PPDGoodsTime@@PPDGoodsUser@@PPDRemark"
function InitviewScreenEvent(obj) {
	var objAudit = ExtTool.StaticServerObject("web.PMP.Document");
	//obj.intCurrRowIndex = -1;
	obj.LoadEvent = function(args){
		
		
		obj.ProductAdd.on("click", obj.ProductAdd_OnClick, obj);  //�����¼� 
		
		obj.ProductUpdate.on("click", obj.ProductUpdate_OnClick, obj);  //�޸� �¼�
		
		obj.ProductDelete.on("click",obj.ProductDelete_OnClick, obj);  //ɾ���¼�
		
		obj.ProductQuery.on("click", obj.ProductQuery_OnClick, obj);  //��ѯ�¼�  
		
		obj.ProductBatch.on("click", obj.ProductBatch_OnClick, obj ); //�����¼�  
		
		obj.ProductCode.on("specialkey", obj.ProductCode_specialkey,obj)  //����س��¼�
		
		obj.ProductDesc.on("specialkey", obj.ProductDesc_specialkey,obj)  //�����س��¼�
		
		obj.ProductGridPanel.on("rowdblclick", obj.ProductGridPanel_rowclick,obj)  //˫�����¼�
		
		//obj.TelGridPanel.on("rowclick", obj.TelGridPanel_cellclick,obj)  //�е����¼�
			
	};
	obj.ProductAdd_OnClick=function (){
		try{
			distrObj = new ProductMenuWind();
			distrObj.ProductRowid.setValue('');
			distrObj.ProductFlag.setValue('Add');
			distrObj.ProductMenuCode.setValue('');
			distrObj.ProductMenuDesc.setValue('');
			distrObj.menuwindadd.show();
		}catch(err)
		{
		   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		};
	};
		obj.ProductUpdate_OnClick=function(){
	var _record = obj.ProductGridPanel.getSelectionModel().getSelected();
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
				distrObj = new ProductMenuWind();
				
				var ProductGridRowid=_record.get('ProductGridRowid');
				distrObj.ProductRowid.setValue(ProductGridRowid);
				distrObj.ProductFlag.setValue('Update');
				var ProductGridCode=_record.get('ProductGridCode');
				distrObj.ProductMenuCode.setValue(ProductGridCode);
				var ProductGridDesc=_record.get('ProductGridDesc');
				distrObj.ProductMenuDesc.setValue(ProductGridDesc);
				var ProductGridTypeid=_record.get('ProductGridTypeid');
				var ProductGridType=_record.get('ProductGridType');
				if (ProductGridTypeid!=""){
		           distrObj.ProductMenuTypeStore.on('load', function (){
                   distrObj.ProductMenuType.setValue(ProductGridTypeid);    
                   });
		          };
				var ProductGridVersions=_record.get('ProductGridVersions');
				distrObj.ProductMenuVersions.setValue(ProductGridVersions);
				var ProductGridStandard=_record.get('ProductGridStandard');
				distrObj.ProductMenuStandard.setValue(ProductGridStandard);
				var ProductGridSupplier=_record.get('ProductGridSupplier');
				var ProductGridProducer=_record.get('ProductGridProducer');
				var ProductGridUnit=_record.get('ProductGridUnit');
				var ProductGridSupplierid=_record.get('ProductGridSupplierid');
				if (ProductGridSupplierid!=""){
		           distrObj.ProductMenuSupplierStore.on('load', function (){
                   distrObj.ProductMenuSupplier.setValue(ProductGridSupplierid);    
                   });
		          };
				var ProductGridProducerid=_record.get('ProductGridProducerid');
				if (ProductGridProducerid!=""){
		           distrObj.ProductMenuSupplierStore.on('load', function (){
                   distrObj.ProductMenuProducer.setValue(ProductGridProducerid);    
                   });
		          };
				var ProductGridCount=_record.get('ProductGridCount');
				distrObj.ProductMenuCount.setValue(ProductGridCount);
				var ProductGridUnitid=_record.get('ProductGridUnitid');
				if (ProductGridUnitid!=""){
		           distrObj.ProductMenuUnitStore.on('load', function (){
                   distrObj.ProductMenuUnit.setValue(ProductGridUnitid);    
                   });
		          };
				var ProductGridPrice=_record.get('ProductGridPrice');
				distrObj.ProductMenuPrice.setValue(ProductGridPrice);
				var ProductGridTotalPrice=_record.get('ProductGridTotalPrice');
				distrObj.ProductMenuTotalPrice.setValue(ProductGridTotalPrice);
				var ProductGridPData=_record.get('ProductGridPData');
				distrObj.ProductMenuPurchaseData.setValue(ProductGridPData);
				var ProductGridPTime=_record.get('ProductGridPTime');
				distrObj.ProductMenuPurchaseTime.setValue(ProductGridPTime);
				var ProductGridPUserid=_record.get('ProductGridPUserid');
				var ProductGridPUser=_record.get('ProductGridPUser');
				if (ProductGridPUserid!=""){
		           distrObj.PUUserStore.on('load', function (){
                   distrObj.ProductMenuPurchaseUser.setValue(ProductGridPUserid);    
                   });
		          };
				var ProductGridGData=_record.get('ProductGridGData');
				distrObj.ProductMenuGoodsData.setValue(ProductGridGData);
				var ProductGridGTime=_record.get('ProductGridGTime');
				distrObj.ProductMenuGoodsTime.setValue(ProductGridGTime);
				var ProductGridGUserid=_record.get('ProductGridGUserid');
				var ProductGridGUser=_record.get('ProductGridGUser');
				if (ProductGridGUserid!=""){
		           distrObj.PUUserStore.on('load', function (){
                   distrObj.ProductMenuGoodsUser.setValue(ProductGridGUserid);    
                   });
		          };
				var ProductGridRemark=_record.get('ProductGridRemark');
				distrObj.ProductMenuRemark.setValue(ProductGridRemark);
				
				ProdInputOld=ProductGridRowid
				ProdInputOld=ProdInputOld+"@@"+ProductGridCode
				ProdInputOld=ProdInputOld+"@@"+ProductGridDesc
				ProdInputOld=ProdInputOld+"@@"+ProductGridType
				//ProdInputOld=ProdInputOld+"@@"+ProductGridTypeid
				ProdInputOld=ProdInputOld+"@@"+ProductGridVersions
				ProdInputOld=ProdInputOld+"@@"+ProductGridStandard
				ProdInputOld=ProdInputOld+"@@"+ProductGridSupplier
				//ProdInputOld=ProdInputOld+"@@"+ProductGridSupplierid
				ProdInputOld=ProdInputOld+"@@"+ProductGridProducer
				//ProdInputOld=ProdInputOld+"@@"+ProductGridProducerid
				ProdInputOld=ProdInputOld+"@@"+ProductGridCount
				ProdInputOld=ProdInputOld+"@@"+ProductGridUnit
				//ProdInputOld=ProdInputOld+"@@"+ProductGridUnitid
				ProdInputOld=ProdInputOld+"@@"+ProductGridPrice
				ProdInputOld=ProdInputOld+"@@"+ProductGridTotalPrice
				ProdInputOld=ProdInputOld+"@@"+ProductGridPData
				ProdInputOld=ProdInputOld+"@@"+ProductGridPTime
				ProdInputOld=ProdInputOld+"@@"+ProductGridPUser
				//ProdInputOld=ProdInputOld+"@@"+ProductGridPUserid
				ProdInputOld=ProdInputOld+"@@"+ProductGridGData
				ProdInputOld=ProdInputOld+"@@"+ProductGridGTime
				ProdInputOld=ProdInputOld+"@@"+ProductGridGUser
				ProdInputOld=ProdInputOld+"@@"+ProductGridRemark
				
				distrObj.menuwindadd.show();
			}catch(err)
			{
			   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
			};
		};
	};
	obj.ProductDelete_OnClick=function(){
		var _record = obj.ProductGridPanel.getSelectionModel().getSelected();
		if(!_record){
		  Ext.Msg.show({
				  title : '��ܰ��ʾ',
				  msg : '��ѡ����Ҫɾ��������!',
				  icon : Ext.Msg.WARNING,
				  buttons : Ext.Msg.OK
				  });
		}
		else {
			var ProductGridRowid=_record.get('ProductGridRowid');
			//delete start
			Ext.MessageBox.confirm('��ʾ', '��Ҫɾ����ǰѡ��Ĳ�Ʒ��Ϣ���Ƿ�Ҫ����������', function(btn) {
				if (btn=="yes"){
					try {
						var AUJectBZ="Delete"
						ProdInputNew=ProductGridRowid
						ProdInputNew=ProdInputNew+"@@@@@@@@@@@@@@@@�ɷ���@@����@@@@@@@@@@@@"	
						
						var AddUpdateRet=objAudit.ProductAddUpdate(ProdInputNew,AUJectBZ).split("^")[0];
						if (AddUpdateRet=="1"){
							ProdTabMessage="PMP_Product@@"+ProductGridRowid+"@@"+AUJectBZ+"@@"+getIpAddress();
							var AddUpdateLogRet=objAudit.PMPOperatingRecord(ProdTabMessage,"","","");
							if (AddUpdateLogRet=="1"){
								Ext.MessageBox.alert('���', 'ɾ���������');
								ExtTool.LoadCurrPage('ProductGridPanel');
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
	obj.ProductQuery_OnClick=function(){
		obj.ProductGridStore.removeAll();
		obj.ProductGridStore.load({params : {start:0,limit:22}});
	};
	obj.ProductBatch_OnClick=function (){
		obj.ProductCode.setValue("");
		obj.ProductDesc.setValue("");
		obj.ProductSupplier.setValue("");
		obj.ProductType.setValue("");
		obj.ProductQuery_OnClick();
	};
	obj.ProductCode_specialkey=function(field,e){
		if (e.keyCode== 13){
			obj.ProductQuery_OnClick();
		};
	};
	obj.ProductDesc_specialkey=function(field,e){
		if (e.keyCode== 13){
			obj.ProductQuery_OnClick();
		};
	};
	obj.ProductGridPanel_rowclick=function(rowIndex,columnIndex,e){
		obj.ProductUpdate_OnClick();
	};
}

function ProductMenuWindEvent(obj){
    var objAudit = ExtTool.StaticServerObject("web.PMP.Document");
    obj.LoadEvent = function(){
     	obj.ProductMenuAdd.on("click", obj.ProductMenuAdd_OnClick, obj);  //���� �¼�
	 	obj.ProductMenuDelete.on("click", obj.ProductMenuDelete_OnClick, obj);  //���� �¼�
	};
obj.ProductMenuAdd_OnClick=function(){
	//ȡֵ��ʼ
	var ProductGridRowid=distrObj.ProductRowid.getValue();
	//var CompanyGridRowid=distrObj.ProductFlag.getValue('Update');
	var ProductGridCode=distrObj.ProductMenuCode.getValue();
	var ProductGridDesc=distrObj.ProductMenuDesc.getValue();
	var ProductGridType=distrObj.ProductMenuType.getValue();
	if (obj.ProductMenuType.getRawValue()==ProductGridType){ProductGridType=""};
	var ProductGridVersions=distrObj.ProductMenuVersions.getValue();
	var ProductGridStandard=distrObj.ProductMenuStandard.getValue();
	var ProductGridSupplier=distrObj.ProductMenuSupplier.getValue();
	if (obj.ProductMenuSupplier.getRawValue()==ProductGridSupplier){ProductGridSupplier=""};
	var ProductGridProducer=distrObj.ProductMenuProducer.getValue();
	if (obj.ProductMenuProducer.getRawValue()==ProductGridProducer){ProductGridProducer=""};
	var ProductGridCount=distrObj.ProductMenuCount.getValue();
	var ProductGridUnit=distrObj.ProductMenuUnit.getValue();
	var ProductGridPrice=distrObj.ProductMenuPrice.getValue();
	var ProductGridTotalPrice=distrObj.ProductMenuTotalPrice.getValue();
	var ProductGridPData=distrObj.ProductMenuPurchaseData.getValue();
	if(ProductGridPData!=""){
		ProductGridPData=ProductGridPData.format('Y-m-d');
	};
	var ProductGridPTime=distrObj.ProductMenuPurchaseTime.getValue();
	var ProductGridPUser=distrObj.ProductMenuPurchaseUser.getValue();
	if (obj.ProductMenuPurchaseUser.getRawValue()==ProductGridPUser){ProductGridPUser=""};
	var ProductGridGData=distrObj.ProductMenuGoodsData.getValue();
	if(ProductGridGData!=""){
		ProductGridGData=ProductGridGData.format('Y-m-d');
	};
	var ProductGridGTime=distrObj.ProductMenuGoodsTime.getValue();
	var ProductGridGUser=distrObj.ProductMenuGoodsUser.getValue();
	if (obj.ProductMenuGoodsUser.getRawValue()==ProductGridGUser){ProductGridGUser=""};
	var ProductGridRemark=distrObj.ProductMenuRemark.getValue();
	
	var AUJectBZ="Update"
	if (ProductGridRowid==""){ProductGridRowid="0";AUJectBZ="Add"};

	if (ProductGridCode==""){
	Ext.Msg.show({
	          title : '��ܰ��ʾ',
			  msg : '��Ʒ���벻��Ϊ��!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	if (ProductGridDesc==""){
	Ext.Msg.show({
			  title : '��ܰ��ʾ',
			  msg : '��Ʒ���Ʋ���Ϊ��!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	//alert(ProductGridPData);
	ProdInputNew=ProductGridRowid
	ProdInputNew=ProdInputNew+"@@"+ProductGridCode
	ProdInputNew=ProdInputNew+"@@"+ProductGridDesc
	ProdInputNew=ProdInputNew+"@@"+ProductGridType
	//ProdInputNew=ProdInputNew+"@@"+ProductGridTypeid
	ProdInputNew=ProdInputNew+"@@"+ProductGridVersions
	ProdInputNew=ProdInputNew+"@@"+ProductGridStandard
	ProdInputNew=ProdInputNew+"@@"+ProductGridSupplier
	//ProdInputNew=ProdInputNew+"@@"+ProductGridSupplierid
	ProdInputNew=ProdInputNew+"@@"+ProductGridProducer
	//ProdInputNew=ProdInputNew+"@@"+ProductGridProducerid
	ProdInputNew=ProdInputNew+"@@"+ProductGridCount
	ProdInputNew=ProdInputNew+"@@"+ProductGridUnit
	//ProdInputNew=ProdInputNew+"@@"+ProductGridUnitid
	ProdInputNew=ProdInputNew+"@@"+ProductGridPrice
	ProdInputNew=ProdInputNew+"@@"+ProductGridTotalPrice
	ProdInputNew=ProdInputNew+"@@"+ProductGridPData
	ProdInputNew=ProdInputNew+"@@"+ProductGridPTime
	ProdInputNew=ProdInputNew+"@@"+ProductGridPUser
	//ProdInputNew=ProdInputNew+"@@"+ProductGridPUserid
	ProdInputNew=ProdInputNew+"@@"+ProductGridGData
	ProdInputNew=ProdInputNew+"@@"+ProductGridGTime
	ProdInputNew=ProdInputNew+"@@"+ProductGridGUser
	ProdInputNew=ProdInputNew+"@@"+ProductGridRemark

	var OpProdInputOld="" 
	var OpProdInputNew="" 
	var OpProdTabFieldName=""
	var j=0
	
	TempProdInputOld=ProdInputOld.split("@@")
	TempProdInputNew=ProdInputNew.split("@@")
	TempProdTabFieldName=ProdTabFieldName.split("@@")
	//alert(TempProdTabFieldName.length)
	for (i=1;i<TempProdTabFieldName.length ;i++ ) 
	{ 
		if ((TempProdInputNew[i]!=TempProdInputOld[i])&&(TempProdInputNew[i]!=""))
		{
			if (OpProdInputOld!="")
			{
				OpProdInputOld=OpProdInputOld+"@@"+TempProdInputOld[i]
				OpProdInputNew=OpProdInputNew+"@@"+TempProdInputNew[i]
				OpProdTabFieldName=OpProdTabFieldName+"@@"+TempProdTabFieldName[i]
				j=j+1
			}else
			{
				OpProdInputOld=TempProdInputOld[i]
				OpProdInputNew=TempProdInputNew[i]
				OpProdTabFieldName=TempProdTabFieldName[i]
				j=j+1
			}
		}
	} 
	
	if (j==0){
	Ext.Msg.show({
			  title : '��ܰ��ʾ',
			  msg : '��Ʒ��Ϣû�б仯������Ҫ�޸�!',
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
										
					var AddUpdateRet=objAudit.ProductAddUpdate(ProdInputNew,AUJectBZ);
					var rowidd=AddUpdateRet.split("^")[1],AddUpdateRet=AddUpdateRet.split("^")[0]
					if (AddUpdateRet=="1"){
						ProdTabMessage="PMP_Product@@"+rowidd+"@@"+AUJectBZ+"@@"+getIpAddress();
						//alert(ProdTabFieldName);
						var AddUpdateLogRet=objAudit.PMPOperatingRecord(ProdTabMessage,OpProdInputOld,OpProdInputNew,OpProdTabFieldName);
						if (AddUpdateLogRet=="1"){
							Ext.MessageBox.alert('���', '�����������');
							obj.menuwindadd.close();
							ExtTool.LoadCurrPage('ProductGridPanel');
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
	obj.ProductMenuDelete_OnClick=function(){
		obj.menuwindadd.close();
	};

}