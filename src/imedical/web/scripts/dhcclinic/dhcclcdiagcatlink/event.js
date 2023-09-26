function InitViewScreenEvent(obj)
{
	//alert(0)
	var preSelectRowId="";
	var curSelectRowId="";
	var _DHCCLCDiagCat=ExtTool.StaticServerObject('web.DHCCLCDiagCat');
	obj.LoadEvent = function(args)
	{
	}
	
	obj.retGridPanel_rowclick=function(){
		var selectObj = obj.GridPanel.getSelectionModel().getSelected();
		if(selectObj){
			curSelectRowId=selectObj.get("rowId");
			//alert(curSelectRowId)
			if(curSelectRowId!=preSelectRowId){
				obj.comDiagnosis.setValue(selectObj.get("DiagId")); //诊断
				obj.comDiagnosis.setRawValue(selectObj.get("Diagnosis"))
				obj.comDiagnosisCat.setValue(selectObj.get("DiagCatId"));//诊断分类
				obj.comDiagnosisCat.setRawValue(selectObj.get("DiagCatDes"))
				preSelectRowId=curSelectRowId;
			}else{
				obj.comDiagnosis.setValue("");
				obj.comDiagnosisCat.setValue("");
				preSelectRowId="";
				curSelectRowId=""
			}
		};
	}
	
	obj.btnSave_click=function(){
		var DiagnosisId=obj.comDiagnosis.getValue();
		//alert(DiagnosisId);
		if(DiagnosisId==""){
			ExtTool.alert("提示","诊断不能为空");
			return;
		}
		
		var DiagnosisCatId=obj.comDiagnosisCat.getValue();
		if(DiagnosisCatId==""){
			ExtTool.alert("提示","诊断分类不能为空");
			return;
		}
		//alert(DiagnosisCatId);
		if(curSelectRowId!=""){
			var ret=_DHCCLCDiagCat.UpdateDiagCatLink(curSelectRowId,DiagnosisId,DiagnosisCatId);
			//alert(ret);
			if(ret=="0"){
				alert("更新成功！");
				obj.comDiagnosis.setValue("");
				obj.comDiagnosisCat.setValue("");
				
				obj.GridPanelStore.removeAll();
				obj.GridPanelStore.reload({});
				obj.comDiagnosisStore.reload({});
				curSelectRowId=""
				return;
			}else{
				alert(ret);
				return;
			}
		}else{
			var ret=_DHCCLCDiagCat.InsertDiagCatLink(DiagnosisId,DiagnosisCatId);
			//alert(ret);
			if(ret=="0"){
				alert("新增成功！");
				obj.comDiagnosis.setValue("");
				obj.comDiagnosisCat.setValue("");
				obj.GridPanelStore.removeAll();
				obj.GridPanelStore.reload({});
				obj.comDiagnosisStore.reload({});
				curSelectRowId=""
				return;
			}else{
				ExtTool.alert("提示",ret);
				return;
			}
		}	
	};
	
	obj.btnSch_click=function(){
		obj.GridPanelStore.removeAll({});
			obj.GridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCLCDiagCat';
			param.QueryName = 'LookUpDiagCatLink';
			param.Arg1=obj.comDiagnosisCat.getValue();
			//param.Arg2=obj.DiagnosisCat.getValue();
			param.ArgCnt =1;
		});
		obj.GridPanelStore.load({});
	}
	
	obj.btnDelete_click=function(){
		if(curSelectRowId!=""){
			var ret=_DHCCLCDiagCat.DeleteDiagCatLink(curSelectRowId);
			if(ret=="0"){
				alert("删除成功！");
				obj.DiagnosisCatCode.setValue("");
				obj.DiagnosisCat.setValue("");
				curSelectRowId=""
				obj.GridPanelStore.removeAll();
				obj.GridPanelStore.reload({});
				obj.comDiagnosisStore.reload({});
				return;
			}else{
				alert(ret);
				return;
			}
		}else{
			alert("请选择一条要删除的记录");
			return;
		}
	}
}
