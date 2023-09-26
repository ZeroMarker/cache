var IM_Menu='web.PMP.PMPImprovementList';
function InitwinScreenEvent(obj) {
	var parent=objControlArry['viewScreen'];
	var objApply = ExtTool.StaticServerObject("DHCPM.Application.PMApply");
	var objAudit = ExtTool.StaticServerObject("DHCPM.Audit.PMAudit");
	var objAudit1 = ExtTool.StaticServerObject("web.PMP.Document");
	var FormulatePermissRet=objAudit1.FormulatePermiss();
obj.LoadEvent = function(){
	
	
	
};
obj.btnSave_click=function()
{
	//tmp=connectStr("Save");
	
	//名称^^电话^类型^一沟通人员^结果^需求描述^紧急程度^严重程度^后补标志^附件^指派工程师^^要求达到效果^创建人^科室^菜单^需审核人^菜单重复
	var tmp = obj.winfDemName.getValue()+"^^";  
	tmp += obj.winfPhone.getValue() + "^";
	tmp += obj.winfDemType.getValue() + "^";
	tmp += obj.cboDemUser.getValue() + "^"; 
	//tmp += obj.winfDemResult.getValue() + "^"; 
	tmp += "^"; //事前沟通
	tmp += obj.winfDemDesc.getValue() + "^"; 
	tmp += obj.winfEmergency.getValue() + "^"; 
	tmp += obj.winfSerious.getValue() + "^";
	//激活暂时不做
	//alert(obj.chkActive.getValue())
	if (obj.chkActive.getValue())
	{
		
		checkValue="Y";
		
	}
	else 
	{
		checkValue="N";
	}
	
	tmp += checkValue + "^";
	tmp +=  Ext.getCmp("txtFile").getValue() + "^^^";
	tmp += obj.winfDemResult.getValue() + "^";
	var userId=session['LOGON.USERID'];
	var locid=session['LOGON.CTLOCID'];
	tmp += userId + "^";
	tmp += locid + "^";
	//tmp += obj.cboDemMenu.getValue() + "^^";
	tmp += obj.cboDemMenu.getRawValue() + "^^";
	//tmp=tmp+"@@"+"Save";
	if (obj.LocActive.getValue())
	{
		
		LocActive="Y";
		
	}
	else 
	{
		LocActive="N";
	}
	tmp += LocActive + "^";     //科内需求
	var next=function(){
//Ext.MessageBox.alert('Status', tmp);
	//return false;
	
	var DemDesc=obj.winfDemDesc.getValue();
	
	/*if (DemDesc.length<10)
	{
		Ext.MessageBox.alert('警告', '需求描述必须超过10个字！');
		return false;
	}*/
	
	var AuthModeRet=objAudit.CheckAuthMode();
	//var StatusCodeRet=objAudit1.StatusCode();
	if((obj.winfDemName.getValue()=="")||(obj.winfDemType.getValue()=="")||(obj.winfDemDesc.getValue()==""))
		{
			ExtTool.alert("提示","需求名称，需求类型和需求描述都不能为空!")
			return;	
		}
	
	try
		{
		    tmp=tmp+"@@"+obj.winfPUser.getValue()+"@@"+getIpAddress();
			var ret = objApply.InsertNewApply(tmp);
			if (ret.split("^")[0]==0)
			{
				obj.DemandID.setValue(ret.split("^")[1]);
				
				var loadFile=Ext.getCmp("txtFile").getValue();
				if (loadFile!="") 
				{
				upLoad(loadFile,ret.split("^")[1]);
				}
				var myrtn=Ext.MessageBox.confirm('确认框', '您需要直接提交吗？',fn);
				function fn(id)
				{
					//alert('单击的按钮id是：'+id); 
					if (id=='yes')
					{
						var errStr = objApply.SubmitApplication(ret.split("^")[1],getIpAddress());
						if (errStr=="0")
						{  
						   var PermissionTypeRet=objAudit1.PermissionType();  //判断配置中的是否开启申请人在审核列表中的时候自动审核
						   if(PermissionTypeRet=='Y'){
						    var PermissionUserRet=objAudit1.PermissionUser(''); //判断该用户是否存在审核权限
							if(PermissionUserRet.split("^")[0]=='Y'){
							  var AutoRet=objAudit1.PermissionAuto(ret.split("^")[1],PermissionUserRet.split("^")[1]);
							  if (AutoRet=="1"){
							  Ext.MessageBox.alert('Status','提交成功，自动审核成功！');
							  ExtTool.LoadCurrPage('DtlDataGridPanel'); 
							  }
							  else{
							  Ext.MessageBox.alert('Status','提交成功，自动审核失败！');
							  ExtTool.LoadCurrPage('DtlDataGridPanel'); 
							  }
							}
							else{
							  if(FormulatePermissRet=="Y"){
							   Ext.MessageBox.confirm('确认框', '提交成功,本次需求是否需要指定审核人？',toAuthfun);
								function toAuthfun(id)
								{
									if (id=='yes')
									{
										
										audiObj = new toAuditSubScreen();
										audiObj.DemandID.setValue(ret.split("^")[1]);
										//audiObj.StatusCode.setValue(DemStatusCode);
										audiObj.winScreen.show();				
									}
									else
									{
										Ext.MessageBox.alert('Status', '提交成功！');
									}
								}
							} 
							};
						   }
						   else{
						    //Ext.MessageBox.alert('Status','提交成功！');
							//ExtTool.LoadCurrPage('DtlDataGridPanel'); 
							
							if(FormulatePermissRet=="Y"){
							Ext.MessageBox.confirm('确认框', '提交成功,本次需求是否需要指定审核人？',toAuthfun);
								function toAuthfun(id)
								{
									if (id=='yes')
									{
										
										audiObj = new toAuditSubScreen();
										audiObj.DemandID.setValue(ret.split("^")[1]);
										//audiObj.StatusCode.setValue(DemStatusCode);
										audiObj.winScreen.show();				
									}
									else
									{
										Ext.MessageBox.alert('Status', '提交成功！');
									}
								}
							}
						   };
						}
						else
						{
							Ext.MessageBox.alert('Status','提交失败!errCode='+errStr);
							//obj.winScreen.close();
						} 
					}
					else
					{
						Ext.MessageBox.alert('Status', '保存成功！');
					}
					ExtTool.LoadCurrPage('DtlDataGridPanel');  
					obj.winScreen.close();
				}
			}
			else{
				ExtTool.alert("提示","保存失败!errCode="+ret);
				//obj.winScreen.close();
			}
		}catch(err)
		{
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}
}

	var Menu=tkMakeServerCall(IM_Menu,"Menu",obj.cboDemMenu.getRawValue());
	if(Menu=="bucunzai"){
		tmp=tmp+'^'+"@@"+'Save';
		next();
				}
    else {
		try{
		   var myrtn=Ext.MessageBox.confirm('确认框', '该菜单已经存在需求，您要继续申请吗？',Menufunc);
		   function Menufunc(btn){
		      if(btn=='yes'){
		      tmp=tmp+'^'+Menu+"@@"+'Save';
			  next();
					}
		      else {
		     tmp=tmp+'^'+"@@"+'Save';
			 next();
			   }
		    };
		}catch(err)
		{
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}
	   
		//return;
	     
	 };
}
obj.btnApply_click=function()
{
	//tmp=connectStr("Submit");
	//alert(tmp);
	
	
	//名称^^电话^类型^一沟通人员^结果^需求描述^紧急程度^严重程度^后补标志^附件^指派工程师^^要求达到效果^创建人^科室^菜单^需审核人^菜单重复
	var tmp = obj.winfDemName.getValue()+"^^";  
	tmp += obj.winfPhone.getValue() + "^";
	tmp += obj.winfDemType.getValue() + "^";
	tmp += obj.cboDemUser.getValue() + "^"; 
	tmp += obj.winfDemResult.getValue() + "^"; 
	tmp += obj.winfDemDesc.getValue() + "^"; 
	tmp += obj.winfEmergency.getValue() + "^"; 
	tmp += obj.winfSerious.getValue() + "^";
	//激活暂时不做
	//alert(obj.chkActive.getValue())
	if (obj.chkActive.getValue())
	{
		
		checkValue="Y";
		
	}
	else 
	{
		checkValue="N";
	}
	
	tmp += checkValue + "^";
	tmp +=  Ext.getCmp("txtFile").getValue() + "^^^";
	tmp += obj.winfDemResult.getValue() + "^";
	var userId=session['LOGON.USERID'];
	var locid=session['LOGON.CTLOCID'];
	tmp += userId + "^";
	tmp += locid + "^";
	//tmp += obj.cboDemMenu.getValue() + "^^";
	tmp += obj.cboDemMenu.getRawValue() + "^^";
	//tmp=tmp+"@@"+"Save";
	if (obj.LocActive.getValue())
	{
		
		LocActive="Y";
		
	}
	else 
	{
		LocActive="N";
	}
	tmp += LocActive + "^";     //科内需求
	
	//Ext.MessageBox.alert('Status', tmp);
	
	var DemDesc=obj.winfDemDesc.getValue();
	
	/* if (DemDesc.length<10)
	{
		Ext.MessageBox.alert('警告', '需求描述必须超过10个字！');
		return false;
	} */
	
	if((obj.winfDemName.getValue()=="")||(obj.winfDemType.getValue()=="")||(obj.winfDemDesc.getValue()==""))
		{
			ExtTool.alert("提示","需求名称,需求类型和需求描述都不能为空!")
			return;	
		}
	var netxx=function(){
	var AuthModeRet=objAudit.CheckAuthMode();
	try
		{
		    tmp=tmp+"@@"+obj.winfPUser.getValue()+"@@"+getIpAddress();
			var ret = objApply.InsertNewApply(tmp);
			if (ret.split("^")[0]==0)
			{
				obj.DemandID.setValue(ret.split("^")[1]);
				
				var loadFile=Ext.getCmp("txtFile").getValue();
				if (loadFile!="") 
				{
					upLoad(loadFile,ret.split("^")[1]);
				}
				 var errStr = objApply.SubmitApplication(ret.split("^")[1],getIpAddress());
				if (errStr=="0")
			        {  
					var PermissionTypeRet=objAudit1.PermissionType();  //判断配置中的是否开启申请人在审核列表中的时候自动审核
					if(PermissionTypeRet=='Y'){
				    var PermissionUserRet=objAudit1.PermissionUser(''); //判断该用户是否存在审核权限
				    if(PermissionUserRet.split("^")[0]=='Y'){
					var AutoRet=objAudit1.PermissionAuto(ret.split("^")[1],PermissionUserRet.split("^")[1]);
					if (AutoRet=="1"){
					Ext.MessageBox.alert('Status','提交成功，自动审核成功！');
				    ExtTool.LoadCurrPage('DtlDataGridPanel'); 
					}
					else{
					Ext.MessageBox.alert('Status','提交成功，自动审核失败！');
					ExtTool.LoadCurrPage('DtlDataGridPanel'); 
					}
					}
				    else{
					   if(FormulatePermissRet=="Y"){ 
					   Ext.MessageBox.confirm('确认框', '提交成功,本次需求是否需要指定审核人？',toAuthfun);
						function toAuthfun(id)
						{
						if (id=='yes')
							{
							  audiObj = new toAuditSubScreen();
							  audiObj.DemandID.setValue(ret.split("^")[1]);
							   //audiObj.StatusCode.setValue(DemStatusCode);
							   audiObj.winScreen.show();				
							}
						else
							{
								Ext.MessageBox.alert('Status', '提交成功！');
							}
						}
					    } 
				    };
				   }
				else{
				//Ext.MessageBox.alert('Status','提交成功！');
				//ExtTool.LoadCurrPage('DtlDataGridPanel'); 
				if(FormulatePermissRet=="Y"){
				Ext.MessageBox.confirm('确认框', '提交成功,本次需求是否需要指定审核人？',toAuthfun);
				function toAuthfun(id)
					{
					if (id=='yes')
					{
					audiObj = new toAuditSubScreen();
					audiObj.DemandID.setValue(ret.split("^")[1]);
					//audiObj.StatusCode.setValue(DemStatusCode);
					audiObj.winScreen.show();				
					}
				   else
					{
					Ext.MessageBox.alert('Status', '提交成功！');
					}
				}
				}
				};	
			}
			else
			{
					ExtTool.alert("提示","保存失败!errCode="+ret);
				//obj.winScreen.close();
			}
				ExtTool.LoadCurrPage('DtlDataGridPanel');  
				obj.winScreen.close();
			
		}
		}catch(err)
		{
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}
	
	}
	var Menu=tkMakeServerCall(IM_Menu,"Menu",obj.cboDemMenu.getRawValue());
	if(Menu!="bucunzai"){
		var myrtn=Ext.MessageBox.confirm('确认框', '该菜单已经存在需求，您要继续申请吗？',function (id){
			if(id=="yes"){
			  tmp=tmp+'^'+myrtn+"@@"+'Submit';
			   netxx();
						}
			else {
			   tmp=tmp+'^'+"@@"+'Submit';
			   netxx();
				}
					
		    });
	}
	else {
		 tmp=tmp+'^'+"@@"+'Submit';
		 netxx();
	}
	
	
	
	
	
}
obj.btnDelete_click=function()
{
	
	obj.winScreen.close();
}

function upLoad(loadFile,Rowid)
{
    var objApply = ExtTool.StaticServerObject("DHCPM.Application.PMApply");
	fileStr=loadFile.split("||");
					//alert(fileStr);
					if(fileStr!="")
					{	
						for(i=0;i<=fileStr.length-1;i++)
						{  
						var ip=getIpAddress();
				        var retDounload=FileDownload(fileStr[i],"","UpLoad");
						var downRet=retDounload.split("//")[0]
					    if(downRet=="true"){
					       var FileNameAddRet=objApply.Adjunct(fileStr[i],retDounload.split("//")[1],Rowid,'Improvement',ip);
					      }
						 if(downRet!="true"){
					      var dowmret='附件上传失败'+retDounload.split("//")[1];
					      Ext.MessageBox.alert('Status',dowmret);
						 };
						}
					}
				
}

function connectStr(flag)
{
	
	
	
	//名称^^电话^类型^一沟通人员^结果^需求描述^紧急程度^严重程度^后补标志^附件^指派工程师^^要求达到效果^创建人^科室^菜单^需审核人^菜单重复
	var tmp = obj.winfDemName.getValue()+"^^";  
	tmp += obj.winfPhone.getValue() + "^";
	tmp += obj.winfDemType.getValue() + "^";
	tmp += obj.cboDemUser.getValue() + "^"; 
	tmp += obj.winfDemResult.getValue() + "^"; 
	tmp += obj.winfDemDesc.getValue() + "^"; 
	tmp += obj.winfEmergency.getValue() + "^"; 
	tmp += obj.winfSerious.getValue() + "^";
	//激活暂时不做
	//alert(obj.chkActive.getValue())
	if (obj.chkActive.getValue())
	{
		
		checkValue="Y";
		
	}
	else 
	{
		checkValue="N";
	}
	
	tmp += checkValue + "^";
	tmp +=  Ext.getCmp("txtFile").getValue() + "^^^";
	tmp += obj.winfDemResult.getValue() + "^";
	var userId=session['LOGON.USERID'];
	var locid=session['LOGON.CTLOCID'];
	tmp += userId + "^";
	tmp += locid + "^";
	//tmp += obj.cboDemMenu.getValue() + "^^";
	tmp += obj.cboDemMenu.getRawValue() + "^^";
	//tmp=tmp+"@@"+"Save";
	tmp=tmp+"@@"+flag;
	
	Ext.MessageBox.alert('Status', tmp);
	
	var DemDesc=obj.winfDemDesc.getValue();
	
	if (DemDesc.length<10)
	{
		Ext.MessageBox.alert('警告', '需求描述必须超过10个字！');
		return false;
	}
	
	if((obj.winfDemName.getValue()=="")||(obj.winfPhone.getValue()=="")||(obj.winfDemType.getValue()=="")||(obj.winfDemDesc.getValue()==""))
		{
			ExtTool.alert("提示","需求名称，电话，需求类型和需求描述都不能为空!")
			return;	
		}
		
		
    return tmp;
	
}
}

