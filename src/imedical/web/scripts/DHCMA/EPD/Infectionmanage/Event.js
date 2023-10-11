//页面Event
function InitviewScreenEvent(obj) {
	obj.LoadEvent = function(args){ 
		//查询
		$('#btnQuery').on('click', function(){	
			obj.InfectionLoad();
		});
		//保存
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
     	});
     	// 操作说明
		$("#admitTip").on('click',function(){
			$HUI.dialog("#winAdmitTipInfo").open();	
		})
    }
	//清空
	obj.ClearFormItem1 = function() {
		$('#txtICD').val('');
		$('#txtName').val('');
		$('#cboKind').combobox('setValue','');
		$('#cboLevel').combobox('setValue','');
		$('#cboAppendix').combobox('setValue','');
		$('#txtTimeLimit').val('');
		$('#txtResume').val('');
		$('#chkWork').checkbox('setValue',false);
		$('#chkMulti').checkbox('setValue',false);
		$('#chkReport').checkbox('setValue',false);
		$('#chkChronic').checkbox('setValue',false);
		
	}
	
	obj.gridAliasLoad = function(RowId){	
		$cm ({
			ClassName:"DHCMed.EPDService.InfectionSrv",
			QueryName:"QryAliasByRowID",		
			Parref: RowId
		},function(rs){
			obj.RecRowID=RowId;
			$('#gridAlias').datagrid('loadData', rs);				
		});
    }

	//单击一行将数据填入表单中
	obj.gridInfType_onSelect = function (rowData){
		if (rowData["RowID"] == obj.RecRowID) {
			obj.gridInfection.clearSelections();
			obj.ClearFormItem1();
			obj.RecRowID="";
		}else {
			obj.RecRowID = rowData["RowID"];
			$cm({                  
				ClassName:"DHCMed.EPD.Infection",
				MethodName:"GetObjById",
				id:rowData["RowID"]
			},function(rd) {						
				$('#txtICD').val(rd["MIFICD"]);
				$('#txtName').val(rd["MIFDisease"]);
				$('#cboKind').combobox('setValue',rd["MIFKind"]);
				$('#cboLevel').combobox('setValue',rd["MIFRank"]);
				$('#cboAppendix').combobox('setValue',rd["MIFAppendix"]);
				$('#chkMulti').checkbox('setValue',(rd["MIFMulti"]=='Y'? true: false));
				$('#txtTimeLimit').val(rd["MIFTimeLimit"]);
				$('#txtResume').val(rd["MIFResume"]);
				$('#chkWork').checkbox('setValue',(rd["MIFIsActive"]=='Y'? true: false));
				$('#chkReport').checkbox('setValue',(rd["MIFIsForceReport"]=='Y'? true: false));
				$('#chkChronic').checkbox('setValue',(rd["MIFIsChronic"]=='N'? false: true));
				
			});
		}
	}
	//保存  
	obj.btnSave_click = function(){
	   	var errinfo = "";
		var ICD = $('#txtICD').val();
		var txtName = $('#txtName').val();
		var cboKind = $('#cboKind').combobox('getValue');
		var cboLevel = $('#cboLevel').combobox('getValue');
		var cboAppendix = $('#cboAppendix').combobox('getValue');
		var chkMulti = $('#chkMulti').checkbox('getValue');         //多次患病

		if(chkMulti){
			chkMulti='Y';
		}else{
			chkMulti='N';
		}
		var chkDependent ='Y';                                         //客观诊断
		var txtTimeLimit = $('#txtTimeLimit').val();
		var txtResume = $('#txtResume').val();
		var txtMinAge = "";
		var txtMaxAge = "";
		var chkWork = $('#chkWork').checkbox('getValue');
		if(chkWork){
			chkWork='Y';
		}else{
			chkWork='N';
		}
		var chkReport = $('#chkReport').checkbox('getValue');
		if(chkReport){
			chkReport='Y';
		}else{
			chkReport='N';
		}
		var chkChronic = $('#chkChronic').checkbox('getValue');
		if(chkChronic){
			chkChronic='Y';
		}else{
			chkChronic='N';
		}
		
		if (!ICD) {
			errinfo = errinfo + "ICD为空!<br>";
		}
		if (!txtName) {
			errinfo = errinfo + "传染病名称为空!<br>";
		}
		if (!cboKind) {
			errinfo = errinfo + "传染病类别为空!<br>";
		}
		if (!cboLevel) {
			errinfo = errinfo + "传染病级别为空!<br>";
		}
	
		if (chkMulti=="Y"&!txtTimeLimit) {
			errinfo = errinfo + "可多次患病的疾病重复报告时限不能为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + ICD;
		inputStr = inputStr + CHR_1 + txtName;
		inputStr = inputStr + CHR_1 + cboKind;
		inputStr = inputStr + CHR_1 + cboLevel;
		inputStr = inputStr + CHR_1 + cboAppendix;
		inputStr = inputStr + CHR_1 + chkMulti;
		inputStr = inputStr + CHR_1 + chkDependent;
		inputStr = inputStr + CHR_1 + txtTimeLimit;
		inputStr = inputStr + CHR_1 + txtResume;
		inputStr = inputStr + CHR_1 + txtMinAge;
		inputStr = inputStr + CHR_1 + txtMaxAge;
		inputStr = inputStr + CHR_1 + chkWork;
		inputStr = inputStr + CHR_1 + chkReport;
		inputStr = inputStr + CHR_1 + chkChronic;
	
		var flg = $m({
			ClassName:"DHCMed.EPD.Infection",
			MethodName:"Update",
			Instring:inputStr,
			Delimiter:CHR_1
		},false);
		if (parseInt(flg) == -2) {
			$.messager.alert("错误提示", "已存在相同ICD编码及传染病名称的数据,更新失败", 'info');
			return;
		}
		if (parseInt(flg) <= 0) {
			$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			return;
		}else {
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.ClearFormItem1();
			obj.RecRowID="";
			obj.gridInfection.reload();//刷新当前页
		}
	}
	//查询
	obj.InfectionLoad = function(){
		var Multi =  $("#chkMulti").checkbox('getValue')? 'Y':''; 
		var Work =  $("#chkWork").checkbox('getValue')? 'Y':'';   
		var Report =  $("#chkReport").checkbox('getValue')? 'Y':'';  
		var Chronic =  $("#chkChronic").checkbox('getValue')? 'Y':'';              
		obj.gridInfection.load({
			ClassName:"DHCMed.EPDService.InfectionSrv",
			QueryName:"QryIFList",	
			aICD:$('#txtICD').val(),                                   //ICD
			aName:$('#txtName').val(),                                 //传染病名称
			aKind:$('#cboKind').combobox('getValue'),                  //传染病类别
			aRank:$('#cboLevel').combobox('getValue'),                 //传染病级别
			aAppendixID:$('#cboAppendix').combobox('getValue'),         //附卡类型
			aTimeLimit:$('#txtTimeLimit').val(),
			aMulti:Multi,					                           //多次患病
			aWork:Work,					                               //是否有效
			aReport:Report,					                           //是否强制上报
			aChronic:Chronic					                           //是否强制上报
	    });	
    }
	
}
