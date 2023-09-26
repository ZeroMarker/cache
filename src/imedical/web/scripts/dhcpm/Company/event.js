//Create by zzp
// 20150515
//公司管理

var CompTabMessage="";
var CompInputOld="";
var CompInputNew="";
var CompTabFieldName="PCRowid@@PCCode@@PCDesc@@PCAddress@@PCPhone@@PCWebsite@@PCEmeail@@PCLawPerson@@PCType@@PCListing@@PCPhone1@@PCPhone2@@PCPostCdoe@@PCEmeail1@@PCEmeail2@@PCRemark";

function InitviewScreenEvent(obj) {
	var objAudit = ExtTool.StaticServerObject("web.PMP.Document");

	//obj.intCurrRowIndex = -1;
	obj.LoadEvent = function(args){

		obj.CompanyAdd.on("click", obj.CompanyAdd_OnClick, obj);  //新增事件 
		
		obj.CompanyUpdate.on("click", obj.CompanyUpdate_OnClick, obj);  //修改 事件
		
		obj.CompanyQuery.on("click", obj.CompanyQuery_OnClick, obj);  //查询事件  
		
		obj.CompanyBatch.on("click", obj.CompanyBatch_OnClick, obj ); //重置事件  
		
		obj.CompanyDelete.on("click", obj.CompanyDelete_OnClick, obj ); //删除事件  
		
		obj.CompanyTel.on("specialkey", obj.CompanyTel_specialkey,obj)  //联系方式回车事件
		
		obj.CompanyCode.on("specialkey", obj.CompanyCode_specialkey,obj)  //编码回车事件
		
		obj.CompanyDesc.on("specialkey", obj.CompanyDesc_specialkey,obj)  //描述回车事件
		
		obj.CompanyAddress.on("specialkey",obj.CompanyAddress_specialkey,obj)  //地址回车事件
		
		obj.CompanyGridPanel.on("rowdblclick", obj.CompanyGridPanel_rowclick,obj)  //双击击事件
		
		//obj.CompanyGridPanel.on("rowclick", obj.CompanyGridPanel_cellclick,obj)  //行单击事件
			
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
	          title : '温馨提示',
			  msg : '请选择需要修改的数据!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	}
	else {
	//alert("更新事件0");
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
	 //取值开始
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
	          title : '温馨提示',
			  msg : '请选择需要修改的数据!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	}
	else {
	    var CompanyGridRowid=_record.get('CompanyGridRowid');
		//delete start
		Ext.MessageBox.confirm('提示', '将要删除当前选择的公司信息，是否要继续操作？', function(btn) {
			if (btn=="yes"){
				try {
					var AUJectBZ="Delete"
					CompInputNew=CompanyGridRowid
					CompInputNew=CompInputNew+"@@@@@@@@@@@@@@@@股份制@@其他@@@@@@@@@@@@"	
					
					var AddUpdateRet=objAudit.CompanyAddUpdate(CompInputNew,AUJectBZ,getIpAddress());
					if (AddUpdateRet=="1"){
						CompTabMessage="PMP_Company@@"+CompanyGridRowid+"@@"+AUJectBZ+"@@"+getIpAddress();
						var AddUpdateLogRet=objAudit.PMPOperatingRecord(CompTabMessage,"","","");
						if (AddUpdateLogRet=="1"){
							Ext.MessageBox.alert('完成', '删除数据完成');
							ExtTool.LoadCurrPage('CompanyGridPanel');
						}
						else{
							Ext.Msg.show({
							  title : '温馨提示',
							  msg : '删除数据成功，日志操作失败，错误代码：'+AddUpdateLogRet,
							  icon : Ext.Msg.WARNING,
							  buttons : Ext.Msg.OK
							  });
							return;
						}; 
					}
					else{
						Ext.Msg.show({
						  title : '温馨提示',
						  msg : '删除数据操作失败，错误代码：'+AddUpdateRet,
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
	    obj.CompanyMenuAdd.on("click", obj.CompanyMenuAdd_OnClick, obj);  //保存事件 
		
		obj.CompanyMenuDelete.on("click", obj.CompanyMenuDelete_OnClick, obj);  //返回事件
	};
    obj.CompanyMenuAdd_OnClick=function (){
	 //取值开始
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
	if (CompanyGridListing=="未上市"){
		CompanyGridListing="N"
	}else if (CompanyGridListing=="已上市"){
		CompanyGridListing="Y"
	}else if (CompanyGridListing=="其他"){
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
	          title : '温馨提示',
			  msg : '公司编码不能为空!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	if (CompanyGridDesc==""){
	Ext.Msg.show({
			  title : '温馨提示',
			  msg : '公司名称不能为空!',
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
			  title : '温馨提示',
			  msg : '公司信息没有变化，不需要修改!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	
	//保存开始
	var AUJectUser=""
	if (AUJectUser==""){
		Ext.MessageBox.confirm('提示', '将对所作修改进行保存，是否要继续操作？', function(btn) {
			if (btn=="yes"){
				try {					
					var AddUpdateRet=objAudit.CompanyAddUpdate(CompInputNew,AUJectBZ,ipAdress);
					if (AddUpdateRet=="1"){
						//CompTabMessage="PMP_Company@@"+CompanyGridRowid+"@@"+AUJectBZ+"@@"+getIpAddress();
						//alert(CompTabFieldName);
						//var AddUpdateLogRet=objAudit.PMPOperatingRecord(CompTabMessage,OpCompInputOld,OpCompInputNew,OpCompTabFieldName);
						if (AddUpdateRet=="1"){
							Ext.MessageBox.alert('完成', '操作数据完成');
							obj.menuwindadd.close();
							ExtTool.LoadCurrPage('CompanyGridPanel');
						}
						else{
							Ext.Msg.show({
							  title : '温馨提示',
							  msg : '操作数据成功，日志操作失败，错误代码：'+AddUpdateLogRet,
							  icon : Ext.Msg.WARNING,
							  buttons : Ext.Msg.OK
							  });
							return;
						}; 
					}
					else{
						Ext.Msg.show({
						  title : '温馨提示',
						  msg : '数据操作失败，错误代码：'+AddUpdateRet,
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
	 //保存结束
	};
	obj.CompanyMenuDelete_OnClick=function(){
		obj.menuwindadd.close();
	};
}