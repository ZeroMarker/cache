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
	if (obj.LocActive.getValue())
	{
		
		LocActive="Y";
		
	}
	else 
	{
		LocActive="N";
	}
	tmp += LocActive + "^";     //��������
	var next=function(){
//Ext.MessageBox.alert('Status', tmp);
	//return false;
	
	var DemDesc=obj.winfDemDesc.getValue();
	
	/*if (DemDesc.length<10)
	{
		Ext.MessageBox.alert('����', '�����������볬��10���֣�');
		return false;
	}*/
	
	var AuthModeRet=objAudit.CheckAuthMode();
	//var StatusCodeRet=objAudit1.StatusCode();
	if((obj.winfDemName.getValue()=="")||(obj.winfDemType.getValue()=="")||(obj.winfDemDesc.getValue()==""))
		{
			ExtTool.alert("��ʾ","�������ƣ��������ͺ���������������Ϊ��!")
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
				var myrtn=Ext.MessageBox.confirm('ȷ�Ͽ�', '����Ҫֱ���ύ��',fn);
				function fn(id)
				{
					//alert('�����İ�ťid�ǣ�'+id); 
					if (id=='yes')
					{
						var errStr = objApply.SubmitApplication(ret.split("^")[1],getIpAddress());
						if (errStr=="0")
						{  
						   var PermissionTypeRet=objAudit1.PermissionType();  //�ж������е��Ƿ���������������б��е�ʱ���Զ����
						   if(PermissionTypeRet=='Y'){
						    var PermissionUserRet=objAudit1.PermissionUser(''); //�жϸ��û��Ƿ�������Ȩ��
							if(PermissionUserRet.split("^")[0]=='Y'){
							  var AutoRet=objAudit1.PermissionAuto(ret.split("^")[1],PermissionUserRet.split("^")[1]);
							  if (AutoRet=="1"){
							  Ext.MessageBox.alert('Status','�ύ�ɹ����Զ���˳ɹ���');
							  ExtTool.LoadCurrPage('DtlDataGridPanel'); 
							  }
							  else{
							  Ext.MessageBox.alert('Status','�ύ�ɹ����Զ����ʧ�ܣ�');
							  ExtTool.LoadCurrPage('DtlDataGridPanel'); 
							  }
							}
							else{
							  if(FormulatePermissRet=="Y"){
							   Ext.MessageBox.confirm('ȷ�Ͽ�', '�ύ�ɹ�,���������Ƿ���Ҫָ������ˣ�',toAuthfun);
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
										Ext.MessageBox.alert('Status', '�ύ�ɹ���');
									}
								}
							} 
							};
						   }
						   else{
						    //Ext.MessageBox.alert('Status','�ύ�ɹ���');
							//ExtTool.LoadCurrPage('DtlDataGridPanel'); 
							
							if(FormulatePermissRet=="Y"){
							Ext.MessageBox.confirm('ȷ�Ͽ�', '�ύ�ɹ�,���������Ƿ���Ҫָ������ˣ�',toAuthfun);
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
										Ext.MessageBox.alert('Status', '�ύ�ɹ���');
									}
								}
							}
						   };
						}
						else
						{
							Ext.MessageBox.alert('Status','�ύʧ��!errCode='+errStr);
							//obj.winScreen.close();
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

	var Menu=tkMakeServerCall(IM_Menu,"Menu",obj.cboDemMenu.getRawValue());
	if(Menu=="bucunzai"){
		tmp=tmp+'^'+"@@"+'Save';
		next();
				}
    else {
		try{
		   var myrtn=Ext.MessageBox.confirm('ȷ�Ͽ�', '�ò˵��Ѿ�����������Ҫ����������',Menufunc);
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
	if (obj.LocActive.getValue())
	{
		
		LocActive="Y";
		
	}
	else 
	{
		LocActive="N";
	}
	tmp += LocActive + "^";     //��������
	
	//Ext.MessageBox.alert('Status', tmp);
	
	var DemDesc=obj.winfDemDesc.getValue();
	
	/* if (DemDesc.length<10)
	{
		Ext.MessageBox.alert('����', '�����������볬��10���֣�');
		return false;
	} */
	
	if((obj.winfDemName.getValue()=="")||(obj.winfDemType.getValue()=="")||(obj.winfDemDesc.getValue()==""))
		{
			ExtTool.alert("��ʾ","��������,�������ͺ���������������Ϊ��!")
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
					var PermissionTypeRet=objAudit1.PermissionType();  //�ж������е��Ƿ���������������б��е�ʱ���Զ����
					if(PermissionTypeRet=='Y'){
				    var PermissionUserRet=objAudit1.PermissionUser(''); //�жϸ��û��Ƿ�������Ȩ��
				    if(PermissionUserRet.split("^")[0]=='Y'){
					var AutoRet=objAudit1.PermissionAuto(ret.split("^")[1],PermissionUserRet.split("^")[1]);
					if (AutoRet=="1"){
					Ext.MessageBox.alert('Status','�ύ�ɹ����Զ���˳ɹ���');
				    ExtTool.LoadCurrPage('DtlDataGridPanel'); 
					}
					else{
					Ext.MessageBox.alert('Status','�ύ�ɹ����Զ����ʧ�ܣ�');
					ExtTool.LoadCurrPage('DtlDataGridPanel'); 
					}
					}
				    else{
					   if(FormulatePermissRet=="Y"){ 
					   Ext.MessageBox.confirm('ȷ�Ͽ�', '�ύ�ɹ�,���������Ƿ���Ҫָ������ˣ�',toAuthfun);
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
								Ext.MessageBox.alert('Status', '�ύ�ɹ���');
							}
						}
					    } 
				    };
				   }
				else{
				//Ext.MessageBox.alert('Status','�ύ�ɹ���');
				//ExtTool.LoadCurrPage('DtlDataGridPanel'); 
				if(FormulatePermissRet=="Y"){
				Ext.MessageBox.confirm('ȷ�Ͽ�', '�ύ�ɹ�,���������Ƿ���Ҫָ������ˣ�',toAuthfun);
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
					Ext.MessageBox.alert('Status', '�ύ�ɹ���');
					}
				}
				}
				};	
			}
			else
			{
					ExtTool.alert("��ʾ","����ʧ��!errCode="+ret);
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
		var myrtn=Ext.MessageBox.confirm('ȷ�Ͽ�', '�ò˵��Ѿ�����������Ҫ����������',function (id){
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
					      var dowmret='�����ϴ�ʧ��'+retDounload.split("//")[1];
					      Ext.MessageBox.alert('Status',dowmret);
						 };
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

