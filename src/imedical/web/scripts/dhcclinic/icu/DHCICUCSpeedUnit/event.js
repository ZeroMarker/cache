function InitViewScreenEvent(obj)
{
var _DHCICUCSpeedUnit=ExtTool.StaticServerObject('web.DHCICUCSpeedUnit');
obj.LoadEvent = function(args)
	{
	};
obj.retGridPanel_rowclick=function()
    {
	    var rc = obj.retGridPanel.getSelectionModel().getSelected();
	    
	    if (rc)
	    {
		    obj.ANCSUCode.setValue(rc.get("ANCSUCode"));
		    obj.ANCSUDesc.setValue(rc.get("ANCSUDesc"));
		    obj.ANCSUType.setValue(rc.get("ANCSUType"));
		    obj.ANCSUUomDr.setValue(rc.get("ANCSUUomDr"));
		    obj.ANCSUFactor.setValue(rc.get("ANCSUFactor"));
		    obj.ANCSUByPatWeight.setValue(rc.get("ANCSUByPatWeight"));
		    obj.ANCSUBaseSpeedUnitDr.setValue(rc.get("ANCSUBaseSpeedUnitDrdesc"));
		    obj.ANCSUBaseUomFactor.setValue(rc.get("ANCSUBaseUomFactor"));
		    
			//obj.retGridPanelStore.load({});      
	    }
    }
    
obj.addbutton_click=function()
    {
	    var ANCSUCode=obj.ANCSUCode.getValue();
	    var ANCSUDesc=obj.ANCSUDesc.getValue();
	    if(ANCSUCode=="")
	    {
		    alert("���벻��Ϊ��");
		    return;
	    }
	    if(ANCSUDesc=="")
	    {
		    alert("��������Ϊ��");
		    return;
	    }
	    var ANCSUType=obj.ANCSUType.getValue();
	    var ANCSUUomDr=obj.ANCSUUomDr.getValue();
	    var ANCSUFactor=obj.ANCSUFactor.getValue();
	    var ANCSUByPatWeight=obj.ANCSUByPatWeight.getValue();
	    var ANCSUBaseSpeedUnitDr=obj.ANCSUBaseSpeedUnitDr.getRawValue();
	    var ANCSUBaseUomFactor=obj.ANCSUBaseUomFactor.getValue();
		var typeStr=ANCSUCode+"^"+ANCSUDesc+"^"+ANCSUType+"^"+ANCSUUomDr+"^"+ANCSUFactor+"^"+ANCSUByPatWeight+"^"+ANCSUBaseSpeedUnitDr+"^"+ANCSUBaseUomFactor;
		var ret=_DHCICUCSpeedUnit.SpeedAdd(typeStr);
		if(ret==0)
		{
			Ext.Msg.alert("��ʾ","���ӳɹ�!",function(){
			obj.ANCSUCode.setValue("");
			obj.ANCSUDesc.setValue("");
			obj.ANCSUType.setValue("");
			obj.ANCSUUomDr.setValue("");
			obj.ANCSUFactor.setValue("");
			obj.ANCSUByPatWeight.setValue("");
			obj.ANCSUBaseSpeedUnitDr.setValue("");
			obj.ANCSUBaseUomFactor.setValue("");
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
		var ANCSUCode=obj.ANCSUCode.getValue();
	    var ANCSUDesc=obj.ANCSUDesc.getValue();
	    if(ANCSUCode=="")
	    {
		    alert("���벻��Ϊ��");
		    return;
	    }
	    if(ANCSUDesc=="")
	    {
		    alert("��������Ϊ��");
		    return;
	    }
	    var ANCSUType=obj.ANCSUType.getValue();
	    var ANCSUUomDr=obj.ANCSUUomDr.getValue();
	    var ANCSUFactor=obj.ANCSUFactor.getValue();
	    var ANCSUByPatWeight=obj.ANCSUByPatWeight.getValue();
	    var ANCSUBaseSpeedUnitDr=obj.ANCSUBaseSpeedUnitDr.getRawValue();
	    var ANCSUBaseUomFactor=obj.ANCSUBaseUomFactor.getValue();	//20160914+dyl
		var rc = obj.retGridPanel.getSelectionModel().getSelected();
		var Rowid=rc.get("Rowid");
		var typeStr=ANCSUCode+"^"+ANCSUDesc+"^"+ANCSUType+"^"+ANCSUUomDr+"^"+ANCSUFactor+"^"+ANCSUByPatWeight+"^"+ANCSUBaseSpeedUnitDr+"^"+ANCSUBaseUomFactor;
		var ret=_DHCICUCSpeedUnit.SpeedUpdate(Rowid,typeStr);
		if(ret==0)
		{
			Ext.Msg.alert("��ʾ","�޸ĳɹ�!",function(){
				obj.ANCSUCode.setValue("");
			    obj.ANCSUDesc.setValue("");
			    obj.ANCSUType.setValue("");
			    obj.ANCSUUomDr.setValue("");
			    obj.ANCSUFactor.setValue("");
			    obj.ANCSUByPatWeight.setValue("");
			    obj.ANCSUBaseSpeedUnitDr.setValue("");
			    obj.ANCSUBaseUomFactor.setValue("");
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
		var Rowid=rc.get("Rowid");
		if(Rowid=="")
		{
			Ext.Msg.alert("��ʾ","��ѡ��һ��Ҫɾ���ļ�¼!");
			return;
		}
		
		Ext.Msg.confirm("ѡ��","ȷ��Ҫɾ����",function(btn){
	  		if(btn=="no")return;
	  		var ret=_DHCICUCSpeedUnit.SpeedDel(Rowid);
	  		if(ret!="0")
	  	  		Ext.Msg.alert("��ʾ","ɾ��ʧ�ܣ�");
	  		else
	  	 	 Ext.Msg.alert("��ʾ","ɾ���ɹ���",function(){
				obj.ANCSUCode.setValue("");
			    obj.ANCSUDesc.setValue("");
			    obj.ANCSUType.setValue("");
			    obj.ANCSUUomDr.setValue("");
			    obj.ANCSUFactor.setValue("");
			    obj.ANCSUByPatWeight.setValue("");
			    obj.ANCSUBaseSpeedUnitDr.setValue("");
			    obj.ANCSUBaseUomFactor.setValue("");
				obj.retGridPanelStore.removeAll();
	  	  		obj.retGridPanelStore.load({});
		  	});
	    });	 
	}
}