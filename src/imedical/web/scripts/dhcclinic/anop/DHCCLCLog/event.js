//dyl+20171031+��־���
function InitViewScreenEvent(obj)
{
var _DHCCLLog=ExtTool.StaticServerObject('web.DHCCLLog');
obj.LoadEvent = function(args)
	{
		var Rowid="";
		 
	};
obj.retGridPanel_rowclick=function()
    {
	    var rc = obj.retGridPanel.getSelectionModel().getSelected();
	    
	    if (rc)
	    {
		    obj.CLCDesc.setValue(rc.get("tClclogDesc"));
		    obj.CLCCode.setValue(rc.get("tClclogCode"));
		    obj.CLCValue.setValue(rc.get("tClclogValueList"));	//����ֵ
		    obj.CLCValueDesc.setValue(rc.get("tClclogValueListDesc"));	//��������
		    obj.DefaultValue.setValue(rc.get("tClclogDefault"));	//ȱʡֵ
		    obj.AddIntro.setRawValue(rc.get("tClclogIfAddInfoDesc"));	//����˵��
		    obj.AddIntro.setValue(rc.get("tClclogIfAddInfo"));	//����˵��
		    obj.CLCType.setValue(rc.get("tClclogType"));	//����
		    obj.CLCSeqNo.setValue(rc.get("tClclogSortNo"));	//�����
		    
			//obj.retGridPanelStore.load({});      
	    }
    }
    
obj.addbutton_click=function()
    {
	    var CLCCode=obj.CLCCode.getValue();
	    var CLCDesc=obj.CLCDesc.getValue();
	    if(CLCCode==""){alert("���벻��Ϊ��");return;}
	    if(CLCDesc==""){alert("��������Ϊ��");return;}
	    var CLCType=obj.CLCType.getValue();
	    var CLCValue=obj.CLCValue.getValue();
	    var CLCValueDesc=obj.CLCValueDesc.getValue();
	    var DefaultValue=obj.DefaultValue.getValue();
	    var CLCSeqNo=obj.CLCSeqNo.getRawValue();
	    var AddIntro=obj.AddIntro.getValue();
		var typeStr=CLCCode+"^"+CLCDesc+"^"+CLCType+"^"+CLCValue+"^"+CLCValueDesc+"^"+AddIntro+"^"+DefaultValue+"^"+CLCSeqNo;
		var ret=_DHCCLLog.InsertCLCLog(CLCCode,CLCDesc,CLCType,CLCValue,CLCValueDesc,AddIntro,DefaultValue,CLCSeqNo);
		if(ret==0)
		{
			Ext.Msg.alert("��ʾ","���ӳɹ�!",function(){
			obj.CLCCode.setValue("");
			obj.CLCDesc.setValue("");
			obj.CLCType.setValue("");
			obj.CLCValue.setValue("");
			obj.CLCValueDesc.setValue("");
			obj.DefaultValue.setValue("");
			obj.AddIntro.setValue("");
			obj.CLCSeqNo.setValue("");
			obj.retGridPanelStore.removeAll();
	  	  	obj.retGridPanelStore.load({});
	  	  	});
		}
		else
		{
			alert(ret)
		}
		
	}

obj.updatebutton_click=function()
	{
	 var CLCCode=obj.CLCCode.getValue();
	    var CLCDesc=obj.CLCDesc.getValue();
	    if(CLCCode==""){alert("���벻��Ϊ��");return;}
	    if(CLCDesc==""){alert("��������Ϊ��");return;}
	    var CLCType=obj.CLCType.getValue();
	    var CLCValue=obj.CLCValue.getValue();
	    var CLCValueDesc=obj.CLCValueDesc.getValue();
	    var DefaultValue=obj.DefaultValue.getValue();
	    var CLCSeqNo=obj.CLCSeqNo.getRawValue();
	    var AddIntro=obj.AddIntro.getValue();
		var typeStr=CLCCode+"^"+CLCDesc+"^"+CLCType+"^"+CLCValue+"^"+CLCValueDesc+"^"+AddIntro+"^"+DefaultValue+"^"+CLCSeqNo;
		var rc = obj.retGridPanel.getSelectionModel().getSelected();
		var Rowid=rc.get("tClclogId");
		var ret=_DHCCLLog.UpdateCLCLog(Rowid,CLCCode,CLCDesc,CLCType,CLCValue,CLCValueDesc,AddIntro,DefaultValue,CLCSeqNo);
		if(ret==0)
		{
			Ext.Msg.alert("��ʾ","�޸ĳɹ�!",function(){
				obj.CLCCode.setValue("");
			obj.CLCDesc.setValue("");
			obj.CLCType.setValue("");
			obj.CLCValue.setValue("");
			obj.CLCValueDesc.setValue("");
			obj.DefaultValue.setValue("");
			obj.AddIntro.setValue("");
			obj.CLCSeqNo.setValue("");
			obj.retGridPanelStore.removeAll();
	  	  	obj.retGridPanelStore.load({});  
	  	  		
	  	  	});
		}
		else
		{
			alert(ret)
		}
	}

obj.deletebutton_click=function()
	{
		var rc = obj.retGridPanel.getSelectionModel().getSelected();
		var Rowid=rc.get("tClclogId");
		if(Rowid=="")
		{
			Ext.Msg.alert("��ʾ","��ѡ��һ��Ҫɾ���ļ�¼!");
			return;
		}
		
		Ext.Msg.confirm("ѡ��","ȷ��Ҫɾ����",function(btn){
	  		if(btn=="no")return;
	  		var ret=_DHCCLLog.DeleteCLCLog(Rowid);
	  		if(ret!="0")
	  	  		Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  		else
	  	 	 Ext.Msg.alert("��ʾ","ɾ���ɹ���",function(){
				obj.CLCCode.setValue("");
			obj.CLCDesc.setValue("");
			obj.CLCType.setValue("");
			obj.CLCValue.setValue("");
			obj.CLCValueDesc.setValue("");
			obj.DefaultValue.setValue("");
			obj.AddIntro.setValue("");
			obj.CLCSeqNo.setValue("");
			obj.retGridPanelStore.removeAll();
	  	  	obj.retGridPanelStore.load({});  
		  	});
	    });	 
	}
}