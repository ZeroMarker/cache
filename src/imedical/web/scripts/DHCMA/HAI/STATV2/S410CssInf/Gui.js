function InitS410cssinfWin(){
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
	$HUI.radio("#chkStatunit-Ward").setValue(true);   //统计单位-病区
	
	var unitConfig = $m({
		ClassName: "DHCHAI.BT.Config",
		MethodName: "GetValByCode",
		aCode: "StatV2ScreenuUnit",
		aHospDr: $.LOGON.HOSPID
	},false);
	if (unitConfig) {
		if (unitConfig == 'E') {
            $HUI.radio("#chkStatunit-Loc").setValue(true); //后台取参数配置，若为科室改为统计单位-科室
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
	
	//筛选条件
	obj.cboConditions = Common_ComboDicCode("cboQryCon","StatScreenCondition");
	$('#cboQryCon').combobox('setValue',1);
	$('#cboQryCon').combobox('setText',"显示全部病区(科室)");
	
	//调查编号
	$HUI.combobox("#cboSurNum", {
		defaultFilter:4,
		valueField: 'ID',
		textField: 'SESurvNumber',
		onShowPanel:function(){
			var url=$URL+"?ClassName=DHCHAI.IRS.INFCSSSrv&QueryName=QueryByCode&aHospIDs="+$.LOGON.HOSPID+"&aFlag=1&ResultSetType=array";
			$("#cboSurNum").combobox('reload',url);	
		},
		onSelect:function(row,index){
			if (row!=""){	
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
		},onChange:function(){
				setTimeout(function(){
					var LocType = Common_CheckboxValue('chkStatunit');
					
					var HospIDs =  obj.HospIDs;
					Common_ComboToMSLoc("cboLoc",HospIDs,"","I",LocType);
				},1);
			}
	});
	InitS410cssinfWinEvent(obj);
	obj.LoadEvent(arguments);
	
	return obj;
}
