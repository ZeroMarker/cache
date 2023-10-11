var obj = new Object();   
function InitviewScreen(){
	obj.LocID=LocID;
	obj.selItems=SelItems;
	obj.WarnItems=WarnItems;
	obj.qryDate=QryDate;
	obj.ReportID=ReportID;
	obj.RepStatus="";
	if(obj.selItems==""){
		obj.selItems="主动报告";
	}
	obj.MayTrans  = Common_CheckboxToDic("MayTrans","CCWMayTrans",9);
	obj.MaySource = Common_CheckboxToDic("MaySource","CCWMayInf",9);
	
	//医院
    $HUI.combobox("#cboHospital",{
		url:$URL+'?ClassName=DHCHAI.BTS.HospitalSrv&QueryName=QryHospitalToSelect&ResultSetType=Array',
		valueField:'ID',
		textField:'BTDesc',
		editable:false,
		onSelect:function(rec){
			Common_ComboToLoc('cboLocation',rec.ID,"","I","W");
			if (LocID) {
				$('#cboLocation').combobox('setValue',LocID);
			}
		},
		onLoadSuccess:function(data){
			// 院区默认选择
			$('#cboHospital').combobox('select',data[0].ID);
		}
	});
		
	// 感染诊断
	$HUI.combobox("#cboInfDiag",{
		url:$URL+"?ClassName=DHCHAI.BTS.InfPosSrv&QueryName=QryInfPosToSelect&ResultSetType=array&aPosFlg=2",
		editable: true,       
		defaultFilter:4, 
		valueField: 'ID',
		textField: 'Desc'
	});
	//病原体
	$HUI.combobox("#cboMayPathogen",{
		url:$URL+"?ClassName=DHCHAI.DPS.LabBactSrv&QueryName=QryLabBacteria&ResultSetType=array",
		editable: true,       
		defaultFilter:4, 
		valueField: 'ID',
		textField: 'BacDesc'		
	});
	//病原体
	$HUI.combobox("#cboPathogen",{
		url:$URL+"?ClassName=DHCHAI.DPS.LabBactSrv&QueryName=QryLabBacteria&ResultSetType=array",
		editable: true,       
		defaultFilter:4, 
		valueField: 'ID',
		textField: 'BacDesc'
	});

    $("#UpdateLoc").val($.LOGON.LOCDESC);
    $('#UpdateDate').datebox('setValue',obj.qryDate);
	$('#UpdateUser').val($.LOGON.USERDESC);

	InitWinEvent(obj);       
	obj.LoadEvent();       
	return obj;  
	
	      
}
