//Create by dongzt
// 20150118
//��������
function InitviewScreenEvent(obj) {
	
	var objApply = ExtTool.StaticServerObject("DHCPM.Application.PMApply");
	var objApply2 = ExtTool.StaticServerObject("DHCPM.Audit.PMAudit");
	
	//obj.intCurrRowIndex = -1;
	obj.LoadEvent = function(args){
		
		
		obj.btnQuery.on("click", obj.btnQuery_OnClick, obj);
		obj.btnApply.on("click", obj.btnApply_OnClick, obj);
				
		//�����¼�  

		
		
		//obj.StatDataGridPanel.on("rowclick", obj.StatDataGridPanel_rowclick, obj);
	};
	obj.btnApply_OnClick = function(){
		// Ext.MessageBox.alert('Status', 'Changes saved successfully.');
		 
		 var objWinEdit = new InitwinScreen();
		 objWinEdit.winScreen.show();
		/*  objWinEdit.winScreen.show();
		 ExtDeignerHelper.HandleResize(objwinScreen); */
		//Ext.example.msg("AA","BB",obj.btnApply_OnClick);
		/*   Ext.MessageBox.show({
           title: 'Please wait',
           msg: 'Loading items...',
           progressText: 'Initializing...',
           width:300,
           progress:true,
           closable:false,
           animEl: 'mb6'
       }); */

	}
	
	
	obj.btnQuery_OnClick = function(){
		obj.DtlDataGridPanelStore.removeAll();
		obj.DtlDataGridPanelStore.load({params : {start:0,limit:20}});
		
		/* obj.DtlDataGridPanelStore.removeAll();
		obj.DtlDataGridPanelStore.load({}); */
	}
	obj.DtlDataGridPanel.on('cellclick', function (grid, rowIndex, columnIndex, e) {  
//alert(1);
  var btn = e.getTarget('.controlBtn');  
  if (btn) 
  {  
    var t = e.getTarget();  
    var record = obj.DtlDataGridPanel.getStore().getAt(rowIndex);  
	//alert(1);
	var DemandID=record.get("DemandID");
	//alert(DemandID);
	var DemandDesc=record.get("DemandDesc");
	var DemandType=record.get("DemandType");
	var EmergDegree=record.get("EmergDegree");
	//alert(EmergDegree);
	var Serious=record.get("Serious");
	var UserPhone=record.get("UserPhone");
	var DemandStatus=record.get("DemandStatus");
	var PMModule=record.get("PMModule");
	var DemSituation=record.get("DemSituation");
	var DemandResult=record.get("DemandResult");  
	var Engineer=record.get("Engineer"); 
	
	var MenuName=record.get("MenuName"); 
	var UserName=record.get("UserName");  //
	var LocName=record.get("LocName");
	var DemStatusCode=record.get("DemStatusCode");
	
	
	
	var control = t.className; 
	//alert(control);
	if ('PMapply'==control)
	{
		
		if (DemandID !='')
		{
			try
			{
						//Ext.MessageBox.confirm('ȷ�Ͽ�', '����Ҫֱ���ύ��',fn1);
				
				
						 var errStr = objApply.SubmitApplication(DemandID);
						if (errStr=="0")
						{
							//alert(errStr);
							//Ext.MessageBox.alert('Status', '��');
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
						
									audiObj = new toAuditSubScreen();
									audiObj.DemandID.setValue(DemandID);
									audiObj.StatusCode.setValue(DemStatusCode);
									audiObj.winScreen.show();				
								}
								else
								{
									Ext.MessageBox.alert('Status', '�ύ�ɹ���');
						
									
								}
				
							}
							
							
							//######################################
							
						
							ExtTool.LoadCurrPage('DtlDataGridPanel'); 
						}
						else
						{
							Ext.MessageBox.alert('Status','����ʧ��!errCode='+errStr);
							
						} 
			
				
				}catch(err)
			{
				ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
			}
			
		}	
		
	}
	
	if ('PMdelete'==control)
	{
		//alert(DemandID);
		if (DemandID !='')
		{
			try
			{
			Ext.MessageBox.confirm('ȷ�Ͽ�', '��ȷ��Ҫɾ������������',fn);
				
				function fn(id)
				{
					//alert('�����İ�ťid�ǣ�'+id); 
					if (id=='yes')
					{
						
						 var errStr = objApply.DeleteApply(DemandID);
						if (errStr=="0")
						{
							//alert(errStr);
							Ext.MessageBox.alert('Status', 'ɾ���ɹ���');
						
							ExtTool.LoadCurrPage('DtlDataGridPanel'); 
						}
						else
						{
							Ext.MessageBox.alert('Status','ɾ��ʧ��!errCode='+errStr);
							
						} 
					}
					
					 
						
				}
				}catch(err)
			{
				ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
			}
			
			
		}
		
		
	}
	
	if ('PMDescription'==control)
	{
		
			
			objWinDetail = new InitDescScreen();
			
			//alert(PDemandID);
			objWinDetail.DemandID.setValue(DemandID);
			//alert(obj.DemandID.getValue());
			objWinDetail.winfDemName.setValue(DemandDesc);
			objWinDetail.winfDemName.disabled=true;
			//alert(obj.winfDemName.getValue());
			
			objWinDetail.winfDemType.setValue(DemandType);
			objWinDetail.winfDemType.disabled=true;
			objWinDetail.winfEmergency.setValue(EmergDegree);
			objWinDetail.winfEmergency.disabled=true;
			objWinDetail.winfPhone.setValue(UserPhone);
			
			objWinDetail.winfPhone.disabled=true;
			objWinDetail.winfDemDesc.setValue(DemSituation); //
			objWinDetail.winfDemDesc.disabled=true;
			objWinDetail.winfCreater.setValue(UserName); 
			objWinDetail.winfCreater.disabled=true;
			objWinDetail.winfLocation.setValue(LocName); //
			objWinDetail.winfLocation.disabled=true;
			objWinDetail.winfModule.setValue(PMModule); 
			objWinDetail.winfModule.disabled=true;
			 
			 //�����б�
			objWinDetail.winfGPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCPM.Query.PMQueryAll';
			param.QueryName = 'QryDemList';
			param.Arg1 = DemandID;    //obj.MenuID.getValue();
			param.ArgCnt = 1; 
			});
			
			//��ͨ��¼�б�
			objWinDetail.winfComlistStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCPM.Handle.PMHandle';
			param.QueryName = 'QryComContent';
			param.Arg1 = DemandID;    //obj.MenuID.getValue();
			param.ArgCnt = 1; 
			});
			 //���������б�
			objWinDetail.winfDownLoadProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCPM.Query.PMQueryAll';
			param.QueryName = 'QryDownLoadList';
			param.Arg1 = "";
			param.Arg2 = DemandID;    //obj.MenuID.getValue();
			param.ArgCnt = 2; 
			});
			objWinDetail.winfGPanelStore.load({});
			
			objWinDetail.winfComlistStore.load({}); 
				
			objWinDetail.winfDownLoadStore.load({}); 
		 
		
		
		
		objWinDetail.winScreen.show();
		
	}
	// 
	//��ִ�¼�
	if ('PMback'==control)
	{
		
		
		 //alert(1)
		 if(('����'==DemandStatus))
		{
			
		
				
						var receiptObj = new receiptScreen();
						receiptObj.DemandID.setValue(DemandID);
						//alert(1);
						receiptObj.winScreen.show();
						
	
	
			
		} 

		
		
	}
	
	if('PMfinish'==control)
	{
		//alert(1)
		
		
		 if('����'==DemandStatus)
		{
			
			
			
			var receiptobj = ExtTool.StaticServerObject("DHCPM.Application.PMApply");
	var  finishRet=receiptobj.FinishInsert(DemandID);
			try
			{
				if('0'==finishRet)
				{
					Ext.MessageBox.alert('Status', '��ϲ������������˳����ɣ�');
				}
				else
				{
					Ext.MessageBox.alert('Status', '����ʧ�ܣ�'+finishRet);
				}
				
			}
			catch(err){
				ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
			}
			
			ExtTool.LoadCurrPage('DtlDataGridPanel');  
			
		}
		
		
		
	}
	
	
	
	
	if ('PMEdit'==control)
	{
		//�����Ȳ����ˣ���̨������Ҫ��д
		//ֻ��ɾ�����ύ
		//��ִ�����
		objWinEdit = new InitwinScreen();
		objWinEdit.winfDemName.setValue(DemandDesc);   //����
		objWinEdit.winfDemName.disabled=true;
		objWinEdit.winfDemType.setValue(DemandType);  //����
		objWinEdit.winfDemType.disabled=true;
		
		objWinEdit.winfEmergency.setValue(EmergDegree);  //����
		objWinEdit.winfEmergency.disabled=true;
		
		objWinEdit.cboDemUser.setValue(Engineer);  //gon
		objWinEdit.cboDemUser.disabled=true;
		
		objWinEdit.winfPhone.setValue(Serious);  //yanzhong
		objWinEdit.winfPhone.disabled=true;
		
		objWinEdit.cboDemMenu.setValue(MenuName);  //yanzhong
		objWinEdit.cboDemMenu.disabled=true;
		
		objWinEdit.winfDemDesc.setValue(DemSituation);  //yanzhong
		objWinEdit.winfDemDesc.disabled=true;
		
		
		objWinEdit.winfDemResult.setValue(DemandResult);  //yanzhong
		objWinEdit.winfDemResult.disabled=true;
		
		Ext.getCmp("chkActivePanel").hidden=true;
		
		
		//Ext.getCmp("textfield").disabled=true;
		
		
		
		
		
		
		
		
		objWinEdit.winScreen.show();
	}
	
	
  

  }
},  
this);  


}

//��ִ����
function receiptScreenEvent(obj) {
	
	
	obj.LoadEvent = function(){
		obj.btnConfirm.on("click", obj.btnConfirm_click, obj);
	obj.btnCancel.on("click", obj.btnCancel_click, obj);
	
	
	
};
 obj.btnConfirm_click=function()
{
	//alert("������Ա");
	var DemandID=obj.DemandID.getValue();
	var note=obj.winfDemResult.getValue();
	//alert(DemandID+"^"+note);
	
	//alert(DemandID+"^"+DemHanderID+"^"+note);
	
	var receiptobj = ExtTool.StaticServerObject("DHCPM.Application.PMApply");
	var  receiptRet=receiptobj.ReceiptInsert(note,DemandID);
	
	if ('0'==receiptRet)
	{
		Ext.MessageBox.alert('Status','��ִ�ɹ���');
	}
	else
	{
		Ext.MessageBox.alert('Status','��ִʧ��'+receiptRet);
	}
	
	obj.winScreen.close();
	ExtTool.LoadCurrPage('DtlDataGridPanel');
	
	
}

obj.btnCancel_click=function()
{
	obj.winScreen.close();
	ExtTool.LoadCurrPage('DtlDataGridPanel'); 
	
	
} 
	
	
	
	
	
	
}

//ָ��������¼�
function toAuditSubScreenEvent(obj) {
	obj.LoadEvent = function(){
		obj.btnConfirm.on("click", obj.btnConfirm_click, obj);
	obj.btnCancel.on("click", obj.btnCancel_click, obj);
	
	
	
};
 obj.btnConfirm_click=function()
{
	//alert("�����������");
	var DemandID=obj.DemandID.getValue();
	var AuditUserID=obj.cboAuditUser.getValue();
	//alert(AuditUserID);
	var note=obj.winAudiResult.getValue();
	var statusCode=obj.StatusCode.getValue();
	
	//alert(DemandID+"^"+statusCode+"^"+note);
	
	
	var objAudit = ExtTool.StaticServerObject("DHCPM.Audit.PMAudit");
	var str=DemandID+"^"+AuditUserID+"^"+note+"^"+"005";
	//alert(str);
	var  distriRet=objAudit.appointAuditor1(str);
	//var  distriRet=objAudit.adjustStatusSave(str);
	
	if ('0'==distriRet)
	{
		Ext.MessageBox.alert('Status','ָ������˳ɹ���');
	}
	else
	{
		Ext.MessageBox.alert('Status','����ʧ��'+distriRet);
	}
	
	obj.winScreen.close();
	ExtTool.LoadCurrPage('DtlDataGridPanel');
	
	
}

obj.btnCancel_click=function()
{
	obj.winScreen.close();
	ExtTool.LoadCurrPage('DtlDataGridPanel'); 
	
	
} 
	
	
	
}