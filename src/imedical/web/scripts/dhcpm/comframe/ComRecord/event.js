//��ͨ��¼�¼�
function InComRecSubScreenEvent(obj) {
	var PMHandle=ExtTool.StaticServerObject("DHCPM.Handle.PMHandle");
	obj.LoadEvent = function(){
		obj.btnSubmit.on("click", obj.btnSubmit_OnClick, obj);
	obj.btnCancel.on("click", obj.btnCancel_click, obj);
	
	
	
	
	
};

//��ͨ��¼�ύ
	obj.btnSubmit_OnClick= function(){
	
		
	var DemID=obj.DemandID.getValue();
	if (DemID=="")
	{
		Ext.MessageBox.alert('Status', '��ѡ�м�¼��');
		return false;
	}
	var retResult="";
	var tmp2 = DemID + "^";
	tmp2 += obj.ComDate.getRawValue() + "^";
	tmp2 += obj.ComTime.getRawValue() + "^";
	tmp2 += obj.txtComDuration.getValue() + "^";
	tmp2 += obj.cmbComWay.getValue() + "^";
	
	tmp2 += obj.txtHosStr.getValue() + "^";
	tmp2 += obj.txtPrjStr.getValue() + "^";
	tmp2 += obj.txtOtherStr.getValue() + "^";   
	tmp2 += obj.txtComNote.getValue() +"^";
	tmp2 += obj.txtLocation.getValue();
	
	
	//Ext.MessageBox.alert('Status', tmp2);
	//ExtTool.alert("��ʾ",tmp2)
	//return;
	
	//alert(obj.cmbComWay.getValue())
	
	if (obj.cmbComWay.getValue() !='')
		{
			retResult = PMHandle.checkStatus(obj.cmbComWay.getValue());
			
		}
		if(retResult=='1')
		{
			Ext.MessageBox.alert('Status', '������ѡ��ͨ��ʽ��');
			return false;
			
		}
	if((obj.txtComNote.getValue().length<10))
		{
			ExtTool.alert("��ʾ","��ͨ���ݱ������10���֣�")
			return false;	
		}
		 
	
		try
		{
			var ret = PMHandle.InsertPMCom(tmp2);
			if (ret==0)
			{
				
				
				Ext.MessageBox.alert('Status', '�ύ�ɹ���');
				
				
				
				
				
			}
			else
			{
					ExtTool.alert("��ʾ","����ʧ��!errCode="+ret);
				
			}
			
			obj.winScreen.close();
				//ExtTool.LoadCurrPage('DtlDataGridPanel'); 
				//location="javascript:location.reload()";	////���ڹرպ�ˢ�µ�ǰҳ�� 	
				//parent.location="javascript:location.reload()";//���ڹرպ�ˢ�¸�ҳ�� 				
				
			
			
		}catch(err)
		{
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}  
		
	}

obj.btnCancel_click=function()
{
	obj.winScreen.close();
} 
	
	
	
}