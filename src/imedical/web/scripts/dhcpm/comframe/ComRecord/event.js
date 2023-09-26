//沟通记录事件
function InComRecSubScreenEvent(obj) {
	var PMHandle=ExtTool.StaticServerObject("DHCPM.Handle.PMHandle");
	obj.LoadEvent = function(){
		obj.btnSubmit.on("click", obj.btnSubmit_OnClick, obj);
	obj.btnCancel.on("click", obj.btnCancel_click, obj);
	
	
	
	
	
};

//沟通记录提交
	obj.btnSubmit_OnClick= function(){
	
		
	var DemID=obj.DemandID.getValue();
	if (DemID=="")
	{
		Ext.MessageBox.alert('Status', '请选中记录！');
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
	//ExtTool.alert("提示",tmp2)
	//return;
	
	//alert(obj.cmbComWay.getValue())
	
	if (obj.cmbComWay.getValue() !='')
		{
			retResult = PMHandle.checkStatus(obj.cmbComWay.getValue());
			
		}
		if(retResult=='1')
		{
			Ext.MessageBox.alert('Status', '请重新选择沟通方式！');
			return false;
			
		}
	if((obj.txtComNote.getValue().length<10))
		{
			ExtTool.alert("提示","沟通内容必须大于10个字！")
			return false;	
		}
		 
	
		try
		{
			var ret = PMHandle.InsertPMCom(tmp2);
			if (ret==0)
			{
				
				
				Ext.MessageBox.alert('Status', '提交成功！');
				
				
				
				
				
			}
			else
			{
					ExtTool.alert("提示","保存失败!errCode="+ret);
				
			}
			
			obj.winScreen.close();
				//ExtTool.LoadCurrPage('DtlDataGridPanel'); 
				//location="javascript:location.reload()";	////窗口关闭后刷新当前页面 	
				//parent.location="javascript:location.reload()";//窗口关闭后刷新父页面 				
				
			
			
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