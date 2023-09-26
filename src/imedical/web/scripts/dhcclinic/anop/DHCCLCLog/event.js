//dyl+20171031+日志码表
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
		    obj.CLCValue.setValue(rc.get("tClclogValueList"));	//变量值
		    obj.CLCValueDesc.setValue(rc.get("tClclogValueListDesc"));	//变量描述
		    obj.DefaultValue.setValue(rc.get("tClclogDefault"));	//缺省值
		    obj.AddIntro.setRawValue(rc.get("tClclogIfAddInfoDesc"));	//附加说明
		    obj.AddIntro.setValue(rc.get("tClclogIfAddInfo"));	//附加说明
		    obj.CLCType.setValue(rc.get("tClclogType"));	//类型
		    obj.CLCSeqNo.setValue(rc.get("tClclogSortNo"));	//排序号
		    
			//obj.retGridPanelStore.load({});      
	    }
    }
    
obj.addbutton_click=function()
    {
	    var CLCCode=obj.CLCCode.getValue();
	    var CLCDesc=obj.CLCDesc.getValue();
	    if(CLCCode==""){alert("代码不能为空");return;}
	    if(CLCDesc==""){alert("描述不能为空");return;}
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
			Ext.Msg.alert("提示","增加成功!",function(){
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
	    if(CLCCode==""){alert("代码不能为空");return;}
	    if(CLCDesc==""){alert("描述不能为空");return;}
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
			Ext.Msg.alert("提示","修改成功!",function(){
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
			Ext.Msg.alert("提示","请选择一条要删除的记录!");
			return;
		}
		
		Ext.Msg.confirm("选择","确认要删除？",function(btn){
	  		if(btn=="no")return;
	  		var ret=_DHCCLLog.DeleteCLCLog(Rowid);
	  		if(ret!="0")
	  	  		Ext.Msg.alert("提示","删除失败！");
	  		else
	  	 	 Ext.Msg.alert("提示","删除成功！",function(){
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