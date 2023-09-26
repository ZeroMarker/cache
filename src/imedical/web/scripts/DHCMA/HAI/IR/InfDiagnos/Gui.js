//页面Gui
function InitInfDiagnosWin(){
	var obj = new Object();
	
	//感染诊断
    obj.cboInfPos = $HUI.combobox("#cboInfPos", {
		editable: true,       
		defaultFilter:4,     
		valueField: 'ID',
		textField: 'Desc',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.BTS.InfPosSrv&QueryName=QryInfPosToSelect&ResultSetType=array&aPosFlg=2";
		   	$("#cboInfPos").combobox('reload',url);
		},
		onChange:function(newValue,oldValue){	
			$('#cboInfSub').combobox('clear');
		}
	});
	
	//诊断分类	
	obj.cboInfSub = $HUI.combobox("#cboInfSub", {
		editable: false,       
		defaultFilter:4,     
		valueField: 'ID',
		textField: 'Desc',			
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.BTS.InfSubSrv&QueryName=QryInfSubByPosID&ResultSetType=array&aPosID="+$('#cboInfPos').combobox('getValue');
			$("#cboInfSub").combobox('reload',url);
		}
	});

	//感染转归字典
	obj.cboInfEffect = Common_ComboDicID("cboInfEffect","InfDiseasePrognosis");
	//与死亡关系字典
	obj.cboDeathRelation = Common_ComboDicID("cboDeathRelation","RepDeathRelative");
	
	InitInfDiagnosWinEvent(obj);	
	obj.LoadEvent(arguments);
	
	return obj;
}


