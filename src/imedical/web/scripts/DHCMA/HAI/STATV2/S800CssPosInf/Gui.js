function InitS800cssposinfWin(){
	var obj = new Object();
	obj.HospIDs =  GetGroupLinkHospForCSS();
	$.parser.parse();
	$HUI.radio("[name='chkStatunit']",{      
        onChecked:function(e,value){
	        var Statunit = $(e.target).val();   
			var HospIDs =  obj.HospIDs;
			var Alias   = "";
			var LocCate = "I";
			var LocType = Statunit;
	        setTimeout(function(){
				ShowStatDimens("cboShowType",LocType);
				Common_ComboToMSLoc("cboLoc",HospIDs,"","I",LocType);    // 统计单位-科室   
			 }, 200);
        }
    });
	$HUI.radio("#chkStatunit-Ward").setValue(true);
	var unitConfig = $m({
		ClassName: "DHCHAI.BT.Config",
		MethodName: "GetValByCode",
		aCode: "StatV2ScreenuUnit",
		aHospDr: $.LOGON.HOSPID
	},false);
	if (unitConfig) {
		if (unitConfig == 'E') {
			$HUI.radio("#chkStatunit-Loc").setValue(true);
        }
    }
	
	ShowStatDimens("cboShowType",Common_CheckboxValue('chkStatunit'));    	//展示维度	
	$HUI.combobox("#cboShowType",{
		onSelect:function(row,index){
			if ((row.Code.indexOf(Common_CheckboxValue('chkStatunit'))<0)) {
				$('#cboLoc').combobox('clear');
				$('#cboLoc').combobox('disable');
			}else {
				$('#cboLoc').combobox('enable');
			}
		}
	});
	
	//调查编号
	$HUI.combobox("#cboSurNum", {
		editable:true,
		defaultFilter:4,
		valueField: 'ID',
		textField: 'SESurvNumber',
		onShowPanel:function(){
			var url=$URL+"?ClassName=DHCHAI.IRS.INFCSSSrv&QueryName=QueryByCode&aHospIDs="+$.LOGON.HOSPID+"&aFlag=1&ResultSetType=array";
			$("#cboSurNum").combobox('reload',url);	
		},
		onSelect:function(row,index){
			if (row.HospIDs!=""){
				var Alias   = "";
				var LocCate = "I";
				var LocType = Common_CheckboxValue('chkStatunit');
				//科室病区
				Common_ComboToMSLoc("cboLoc",row.HospIDs,"","I",LocType);
				obj.HospIDs=row.HospIDs
			}else {
				$('#cboLoc').combobox('clear');
				$('#cboLoc').combobox('disable');
			}
		}
	});
	InitS800cssposinfWinEvent(obj);
	obj.LoadEvent(arguments);
	
	return obj;
}
