function InitViewportEvent(obj)
{
	var preSelectRowId="";
	var curSelectRowId="";
	var _DHCANCDiagCat=ExtTool.StaticServerObject('web.DHCANCDiagCat');
	obj.LoadEvent = function(args)
	{
	}
	
	//��ѡ��ʱ
	obj.retGridPanel_rowclick=function(){
		var selectObj = obj.GridPanel.getSelectionModel().getSelected();
		if(selectObj){
			curSelectRowId=selectObj.get("rowId");
			//alert(curSelectRowId)
			if(curSelectRowId!=preSelectRowId){
				obj.DiagnosisCatCode.setValue(selectObj.get("Code"));
				obj.DiagnosisCat.setValue(selectObj.get("DiagCatDes"));
				preSelectRowId=curSelectRowId;
			}else{
				obj.DiagnosisCatCode.setValue("");
				obj.DiagnosisCat.setValue("");
				preSelectRowId="";
				curSelectRowId=""
			}
		};
	};
	obj.btnSch_click = function()
	{
		obj.GridPanelStore.removeAll();
		obj.GridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCANCDiagCat';
			param.QueryName = 'LookUpDiagCat';
			param.Arg1=obj.DiagnosisCatCode.getValue();
			param.Arg2=obj.DiagnosisCat.getValue();
			param.ArgCnt =2;
		});
		obj.GridPanelStore.load({});
	};
	obj.btnSave_click=function()
	{
		//alert(0)
		//var selectObj = obj.GridPanel.getSelectionModel().getSelected();
		if(obj.DiagnosisCatCode.getValue()=="")
		{
			alert("������벻��Ϊ��");
			return;
		}
		if(obj.DiagnosisCat.getValue()==""){
			alert("��Ϸ������Ʋ���Ϊ��");
			return;
		}
		var DiagnosisCatCode=obj.DiagnosisCatCode.getValue();
		var DiagnosisCat=obj.DiagnosisCat.getValue();
		if(curSelectRowId!=""){
			var ret=_DHCANCDiagCat.UpdateDiagCat(curSelectRowId,DiagnosisCatCode,DiagnosisCat);
			//alert(ret);
			if(ret=="0"){
				alert("���³ɹ���");
				obj.GridPanelStore.removeAll();
				obj.GridPanelStore.load({});
				obj.DiagnosisCatCode.setValue("");
				obj.DiagnosisCat.setValue("");
				curSelectRowId="";
				return;
			}else{
				alert(ret);
				return;
			}
		}else{
			var ret=_DHCANCDiagCat.InsertDiagCat(DiagnosisCatCode,DiagnosisCat);
			//alert(ret);
			if(ret=="0"){
				alert("�����ɹ���");
				obj.GridPanelStore.removeAll();
				obj.GridPanelStore.reload({});
				obj.DiagnosisCatCode.setValue("");
				obj.DiagnosisCat.setValue("");
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
			var ret=_DHCANCDiagCat.DeleteDiagCat(curSelectRowId);
			if(ret=="0"){
				alert("ɾ���ɹ���");
				obj.GridPanelStore.removeAll();
				obj.GridPanelStore.load({});
				obj.DiagnosisCatCode.setValue("");
				obj.DiagnosisCat.setValue("");
				curSelectRowId="";
				return;
			}else{
				alert(ret);
				return;
			}
		}
	};
}
