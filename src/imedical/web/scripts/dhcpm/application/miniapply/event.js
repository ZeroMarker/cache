function InitwinScreenEvent(obj) {
	var parent=objControlArry['viewScreen'];
	var objApply = ExtTool.StaticServerObject("DHCPM.Application.PMApply");
	
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
	tmp=tmp+"@@"+'Save';
	
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
	
	try
		{
			var ret = objApply.InsertNewApply(tmp);
			if (ret.split("^")[0]==0)
			{
				obj.DemandID.setValue(ret.split("^")[1]);
				
				var loadFile=Ext.getCmp("txtFile").getValue();
				if (loadFile!="") 
				{
					upLoad(loadFile);
				}
				var myrtn=Ext.MessageBox.confirm('确认框', '您需要直接提交吗？',fn);
				
				function fn(id)
				{
					//alert('单击的按钮id是：'+id); 
					if (id=='yes')
					{
						
						 var errStr = objApply.SubmitApplication(ret.split("^")[1]);
						if (errStr=="0")
						{
							//提交完成后，指定审核人
							//######################################
							Ext.MessageBox.confirm('确认框', '提交成功,本次需求是否需要指定审核人？',toAuthfun);
							function toAuthfun(id)
							{
					
								/* if (id=='yes')
								{
									var str=DemandID+"^"+"005";
									var errStr = objApply2.adjustStatusSave(str);
								} */
								
								if (id=='yes')
								{
									//alert(1)
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
							
							
							//######################################
						
      		 
						}
						else
						{
							Ext.MessageBox.alert('Status','保存失败!errCode='+errStr);
							obj.winScreen.close();
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
	tmp=tmp+"@@"+'Submit';
	
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
	
	try
		{
			var ret = objApply.InsertNewApply(tmp);
			if (ret.split("^")[0]==0)
			{
				obj.DemandID.setValue(ret.split("^")[1]);
				
				var loadFile=Ext.getCmp("txtFile").getValue();
				if (loadFile!="") 
				{
					upLoad(loadFile);
				}
				
				//提交完成后，指定审核人
							//######################################
							Ext.MessageBox.confirm('确认框', '提交成功,本次需求是否需要指定审核人？',toAuthfun);
							function toAuthfun(id)
							{
					
								/* if (id=='yes')
								{
									var str=DemandID+"^"+"005";
									var errStr = objApply2.adjustStatusSave(str);
								} */
								
								if (id=='yes')
								{
									//alert(1)
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
							
							
							//######################################
				
				
			}
			else
			{
					ExtTool.alert("提示","保存失败!errCode="+ret);
				//obj.winScreen.close();
			}
				ExtTool.LoadCurrPage('DtlDataGridPanel');  
				obj.winScreen.close();
			
			
		}catch(err)
		{
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}
	
	
	
	
	
}
obj.btnDelete_click=function()
{
	
	obj.winScreen.close();
}

function upLoad(loadFile)
{
	fileStr=loadFile.split("||");
					//alert(fileStr);
					if(fileStr!="")
					{	
						for(i=0;i<=fileStr.length-1;i++)
						{  
							VerStrName=fileStr[i].split("\\");
							name=VerStrName[VerStrName.length-1];
			  
							vers="D:\\dthealth\\app\\dthis\\fujian\\"
							//vers="\\\\172.16.0.27\\DHCCPMP\\"
			 
							//alert(fileStr[i]);
			
							dirc=handleSpace(VerStrName);
							//alert(dirc);
							LocalDirc=dirc+"\\"+name;
							dosString="copy "+LocalDirc+" "+vers+name;
			
							CreatBat(dosString);	   
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
