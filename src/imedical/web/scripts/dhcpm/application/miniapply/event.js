function InitwinScreenEvent(obj) {
	var parent=objControlArry['viewScreen'];
	var objApply = ExtTool.StaticServerObject("DHCPM.Application.PMApply");
	
obj.LoadEvent = function(){
	
	
	
};
obj.btnSave_click=function()
{
	//tmp=connectStr("Save");
	
	//����^^�绰^����^һ��ͨ��Ա^���^��������^�����̶�^���س̶�^�󲹱�־^����^ָ�ɹ���ʦ^^Ҫ��ﵽЧ��^������^����^�˵�^�������^�˵��ظ�
	var tmp = obj.winfDemName.getValue()+"^^";  
	tmp += obj.winfPhone.getValue() + "^";
	tmp += obj.winfDemType.getValue() + "^";
	tmp += obj.cboDemUser.getValue() + "^"; 
	//tmp += obj.winfDemResult.getValue() + "^"; 
	tmp += "^"; //��ǰ��ͨ
	tmp += obj.winfDemDesc.getValue() + "^"; 
	tmp += obj.winfEmergency.getValue() + "^"; 
	tmp += obj.winfSerious.getValue() + "^";
	//������ʱ����
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
		Ext.MessageBox.alert('����', '�����������볬��10���֣�');
		return false;
	}
	
	if((obj.winfDemName.getValue()=="")||(obj.winfPhone.getValue()=="")||(obj.winfDemType.getValue()=="")||(obj.winfDemDesc.getValue()==""))
		{
			ExtTool.alert("��ʾ","�������ƣ��绰���������ͺ���������������Ϊ��!")
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
				var myrtn=Ext.MessageBox.confirm('ȷ�Ͽ�', '����Ҫֱ���ύ��',fn);
				
				function fn(id)
				{
					//alert('�����İ�ťid�ǣ�'+id); 
					if (id=='yes')
					{
						
						 var errStr = objApply.SubmitApplication(ret.split("^")[1]);
						if (errStr=="0")
						{
							//�ύ��ɺ�ָ�������
							//######################################
							Ext.MessageBox.confirm('ȷ�Ͽ�', '�ύ�ɹ�,���������Ƿ���Ҫָ������ˣ�',toAuthfun);
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
									Ext.MessageBox.alert('Status', '�ύ�ɹ���');
						
									
								}
				
							}
							
							
							//######################################
						
      		 
						}
						else
						{
							Ext.MessageBox.alert('Status','����ʧ��!errCode='+errStr);
							obj.winScreen.close();
						} 
					}
					else
					{
						Ext.MessageBox.alert('Status', '����ɹ���');
					}
					ExtTool.LoadCurrPage('DtlDataGridPanel');  
						obj.winScreen.close();
				}
				
	
			}

			else{
				ExtTool.alert("��ʾ","����ʧ��!errCode="+ret);
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
	
	
	//����^^�绰^����^һ��ͨ��Ա^���^��������^�����̶�^���س̶�^�󲹱�־^����^ָ�ɹ���ʦ^^Ҫ��ﵽЧ��^������^����^�˵�^�������^�˵��ظ�
	var tmp = obj.winfDemName.getValue()+"^^";  
	tmp += obj.winfPhone.getValue() + "^";
	tmp += obj.winfDemType.getValue() + "^";
	tmp += obj.cboDemUser.getValue() + "^"; 
	tmp += obj.winfDemResult.getValue() + "^"; 
	tmp += obj.winfDemDesc.getValue() + "^"; 
	tmp += obj.winfEmergency.getValue() + "^"; 
	tmp += obj.winfSerious.getValue() + "^";
	//������ʱ����
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
		Ext.MessageBox.alert('����', '�����������볬��10���֣�');
		return false;
	}
	
	if((obj.winfDemName.getValue()=="")||(obj.winfPhone.getValue()=="")||(obj.winfDemType.getValue()=="")||(obj.winfDemDesc.getValue()==""))
		{
			ExtTool.alert("��ʾ","�������ƣ��绰���������ͺ���������������Ϊ��!")
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
				
				//�ύ��ɺ�ָ�������
							//######################################
							Ext.MessageBox.confirm('ȷ�Ͽ�', '�ύ�ɹ�,���������Ƿ���Ҫָ������ˣ�',toAuthfun);
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
									Ext.MessageBox.alert('Status', '�ύ�ɹ���');
						
									
								}
				
							}
							
							
							//######################################
				
				
			}
			else
			{
					ExtTool.alert("��ʾ","����ʧ��!errCode="+ret);
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
	
	
	
	//����^^�绰^����^һ��ͨ��Ա^���^��������^�����̶�^���س̶�^�󲹱�־^����^ָ�ɹ���ʦ^^Ҫ��ﵽЧ��^������^����^�˵�^�������^�˵��ظ�
	var tmp = obj.winfDemName.getValue()+"^^";  
	tmp += obj.winfPhone.getValue() + "^";
	tmp += obj.winfDemType.getValue() + "^";
	tmp += obj.cboDemUser.getValue() + "^"; 
	tmp += obj.winfDemResult.getValue() + "^"; 
	tmp += obj.winfDemDesc.getValue() + "^"; 
	tmp += obj.winfEmergency.getValue() + "^"; 
	tmp += obj.winfSerious.getValue() + "^";
	//������ʱ����
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
		Ext.MessageBox.alert('����', '�����������볬��10���֣�');
		return false;
	}
	
	if((obj.winfDemName.getValue()=="")||(obj.winfPhone.getValue()=="")||(obj.winfDemType.getValue()=="")||(obj.winfDemDesc.getValue()==""))
		{
			ExtTool.alert("��ʾ","�������ƣ��绰���������ͺ���������������Ϊ��!")
			return;	
		}
		
		
    return tmp;
	
}
}