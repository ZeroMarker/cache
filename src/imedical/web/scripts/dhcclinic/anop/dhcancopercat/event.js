function InitViewportEvent(obj)
{
	var preSelectRowId="";
	var curSelectRowId="";
	var _DHCANCOperCat=ExtTool.StaticServerObject('web.DHCANCOperationCat');
	obj.LoadEvent = function(args)
	{
	}
	
	//行选择时
	obj.retGridPanel_rowclick=function(){
		var selectObj = obj.GridPanel.getSelectionModel().getSelected();
		if(selectObj){
			curSelectRowId=selectObj.get("rowId");
			//alert(curSelectRowId)
			if(curSelectRowId!=preSelectRowId){
				obj.OperCatCode.setValue(selectObj.get("Code"));
				obj.OperCat.setValue(selectObj.get("Desc"));
				obj.comAppLoc.setValue(selectObj.get("LocId"));
				obj.comAppLoc.setRawValue(selectObj.get("LocDesc"));
				obj.comDiagnosisCat.setValue(selectObj.get("sysCatId"));
				obj.comDiagnosisCat.setRawValue(selectObj.get("sysCatDesc"));
				obj.opType.setValue(selectObj.get("catTypeCode"));
				obj.opType.setRawValue(selectObj.get("catTypeDesc"));
				preSelectRowId=curSelectRowId;
			}else{
				obj.OperCatCode.setValue("");
				obj.OperCat.setValue("");
				obj.comAppLoc.setValue("");
				obj.comAppLoc.setRawValue("");
				obj.comDiagnosisCat.setValue("");
				obj.comDiagnosisCat.setRawValue("");
				obj.opType.setValue("");
				obj.opType.setRawValue("");
				preSelectRowId="";
				curSelectRowId=""
			}
		};
	};
	obj.btnSch_click = function()
	{
		obj.GridPanelStore.removeAll();
		obj.GridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCANCOperationCat';
			param.QueryName = 'LookUpOperationCat';
			param.Arg1=obj.OperCatCode.getValue();
			param.Arg2=obj.OperCat.getValue();
			param.Arg3=obj.comAppLoc.getValue();
			param.Arg4=obj.comDiagnosisCat.getValue();
			param.Arg5=obj.opType.getValue();
			param.ArgCnt =5;
		});
		obj.GridPanelStore.load({});
	};
	obj.btnSave_click=function()
	{
		//alert(0)
		//var selectObj = obj.GridPanel.getSelectionModel().getSelected();
		//if(obj.comAppLoc.getValue()==""){
			//alert("使用科室不能为空！");
			//return;
		//}
		if(obj.OperCatCode.getValue()=="")
		{
			alert("分类代码不能为空");
			return;
		}
		if(obj.OperCat.getValue()==""){
			alert("分类名称不能为空");
			return;
		}
		if(obj.opType.getValue()==""){
			alert("分类类别不能为空");
			return;
		}
		var OperCatCode=obj.OperCatCode.getValue();
		var OperCat=obj.OperCat.getValue();
		var LocId=obj.comAppLoc.getValue();
		var sysCat=obj.comDiagnosisCat.getValue(); //系统分类
		var catType=obj.opType.getValue(); //分类类别
		if(curSelectRowId!=""){
			var ret=_DHCANCOperCat.UpdateOperationCat(curSelectRowId,OperCatCode,OperCat,LocId,sysCat,catType);
			//alert(ret);
			if(ret>=0){
				alert("更新成功！");
				obj.GridPanelStore.removeAll();
				obj.GridPanelStore.load({});
				obj.OperCatCode.setValue("");
				obj.OperCat.setValue("");
				obj.comAppLoc.setValue("");
				obj.comDiagnosisCat.setValue("");
				obj.opType.setValue("");
				curSelectRowId="";
				return;
			}else{
				alert(ret);
				return;
			}
		}else{
			var ret=_DHCANCOperCat.InsertOperationCat(LocId,OperCatCode,OperCat,sysCat,catType);
			//alert(ret);
			if(ret=="0"){
				alert("新增成功！");
				obj.GridPanelStore.removeAll();
				obj.GridPanelStore.reload({});
				obj.OperCatCode.setValue("");
				obj.OperCat.setValue("");
				obj.comAppLoc.setValue("");
				obj.comDiagnosisCat.setValue("");
				obj.opType.setValue("");
				//alert(ret)
				curSelectRowId="";
				return;
			}else{
				alert(ret);
				return;
			}
		}
		
	}

	obj.btnDelete_click = function()
	{
		if(curSelectRowId!=""){
			var ret=_DHCANCOperCat.DeleteOperationCat(curSelectRowId);
			if(ret=="0"){
				alert("删除成功！");
				obj.GridPanelStore.removeAll();
				obj.GridPanelStore.load({});
				obj.OperCatCode.setValue("");
				obj.OperCat.setValue("");
				obj.comAppLoc.setValue("");
				obj.comDiagnosisCat.setValue("");
				obj.opType.setValue("");
				curSelectRowId="";
				return;
			}else{
				alert(ret);
				return;
			}
		}else{
			alert("请选择一条要删除的记录！");
			return;
		}
	};
}
