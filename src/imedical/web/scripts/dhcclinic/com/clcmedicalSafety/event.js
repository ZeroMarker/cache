
function InitViewScreenEvent(obj)
{
	
	var _DHCCLCMedicalSafety=ExtTool.StaticServerObject('web.DHCCLCMedicalSafety');
	
	obj.LoadEvent = function(args)
	{
		obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCLCMedicalSafety';
			param.QueryName = 'MedicalSafety';
			param.Arg1 = obj.Code.getRawValue();
			param.ArgCnt = 1;
		});
		obj.retGridPanelStore.load({
			params : {
				start:0
				,limit:200
			}
		});  
		
	}
	obj.retGridPanel_rowclick=function() //点击后获取数据
	{
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj)
	    {
		    var tDesc=selectObj.get('tDesc');
		    var tCode=selectObj.get('tCode');
		    var ttype=selectObj.get('ttype');
		    var tctlocDesc=selectObj.get('tctlocDesc');
		    obj.ctloc.setValue(selectObj.get('tctlocId'));
		    var trowId=selectObj.get('trowId');
			Ext.getDom("Code").value=tCode;
			Ext.getDom("Desc").value=tDesc;
			Ext.getDom("type").value=ttype;
			Ext.getDom("ctloc").value=tctlocDesc;
			Ext.getDom("rowId").value=trowId;
			//obj.rowId.setValue(trowId)
			//alert(obj.rowId.getValue);
			//alert(Ext.getDom("rowId").value);
		    //selectObj.set('checked',!selectObj.get('checked'));	
	    }
	}
	obj.btnSch_click = function()
	{
		obj.retGridPanelStore.load({
			params : {
				start:0
				,limit:200
			}
		});  
	}
	obj.btnAdd_click = function()
	{
		var Code=Ext.getDom("Code").value;
		if (Code=="") 
		{
			alert("请输入代码！");
			return;
		}
		var Desc=Ext.getDom("Desc").value;
		if (Desc=="") 
		{
			alert("请输入名称");
			return;
		}			
		var ctlocdesc=obj.ctloc.getRawValue()
		var ctloc=obj.ctloc.getValue()
		if (ctloc=="") 
		{
			alert("请选择科室");
			return;
		}
		var vaildFlag=_DHCCLCMedicalSafety.CheckIsValid(ctlocdesc,ctloc);
		if(vaildFlag=="1")
		{
			alert("科室只能从下拉框选择")
			return;
		}
		var type=obj.type.getValue()
		var str=Code+"^"+Desc+"^"+ctloc+"^"+type;
		var ret=_DHCCLCMedicalSafety.AddMedicalSafety(str);
		alert(ret);
		Ext.getDom("Code").value="";
		Ext.getDom("Desc").value="";
		Ext.getDom("ctloc").value="";
		Ext.getDom("type").value="";
		obj.retGridPanelStore.load({
			params : {
				start:0
				,limit:200
			}
		});  
		
	}
	obj.btnUpdate_click = function()
	{
		var rowId=Ext.getDom("rowId").value;
		if (rowId=="") 
		{
			alert("请先选择需要更新的记录！");
			return;
		}		
		var Code=Ext.getDom("Code").value;
		if (Code=="") 
		{
			alert("请输入代码！");
			return;
		}
		var Desc=Ext.getDom("Desc").value;
		if (Desc=="") 
		{
			alert("请输入名称");
			return;
		}			
		var ctlocdesc=obj.ctloc.getRawValue()
		var ctloc=obj.ctloc.getValue()
		if (ctloc=="") 
		{
			alert("请选择科室");
			return;
		}
		var vaildFlag=_DHCCLCMedicalSafety.CheckIsValid(ctlocdesc,ctloc);
		if(vaildFlag=="1")
		{
			alert("科室只能从下拉框选择")
			return;
		}
		var type=obj.type.getValue();
		var str=Code+"^"+Desc+"^"+ctloc+"^"+type;
		//alert(str);
		var ret=_DHCCLCMedicalSafety.UpdateMedicalSafety(rowId,str);
		alert(ret);
		Ext.getDom("Code").value="";
		Ext.getDom("Desc").value="";
		Ext.getDom("ctloc").value="";
		Ext.getDom("type").value="";
		obj.retGridPanelStore.load({
			params : {
				start:0
				,limit:200
			}
		}); 
		
	}
	obj.btnDelete_click = function()
	{
		var rowId=Ext.getDom("rowId").value;
		var ret=_DHCCLCMedicalSafety.DeleteMedicalSafety(rowId);
		Ext.getDom("Code").value="";
		Ext.getDom("Desc").value="";
		Ext.getDom("ctloc").value="";
		Ext.getDom("type").value="";
		
		obj.retGridPanelStore.load({
			params : {
				start:0
				,limit:200
			}
		}); 
		
	}
}
