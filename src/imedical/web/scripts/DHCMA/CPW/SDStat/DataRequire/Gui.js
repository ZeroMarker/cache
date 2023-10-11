//页面Gui
function InitMED0101Win(){
	var obj = new Object();
    $.parser.parse(); 
	var HospID=session['DHCMA.HOSPID']
	//初始查询条件
	$HUI.combobox('#cboHospital',
	    {
			url:$URL+'?ClassName=DHCMA.Util.EPS.HospitalSrv&QueryName=QryHospInfo&ResultSetType=Array&aHospID='+HospID,
			valueField:'OID',
			textField:'Desc',
	    	onSelect:function(rd){
		    	HospID=rd.OID;
		    	var url =$URL+'?ClassName=DHCMA.Util.EPS.LocationSrv&QueryName=QryLocInfo&ResultSetType=Array&aHospID='+HospID+'&aAdmType=I';
        		$('#cboLocation').combobox('setValue','');
        		$('#cboLocation').combobox('reload', url);
		   },
		   onLoadSuccess:function(){
			   	Common_SetValue('cboHospital',HospID);
			   	$('#search').click();
			   }		    
	    } )	
	$HUI.combobox('#cboLocation',
	    {
			url:$URL+'?ClassName=DHCMA.Util.EPS.LocationSrv&QueryName=QryLocInfo&ResultSetType=Array&aHospID='+HospID+'&aAdmType=I',
			valueField:'OID',
			textField:'Desc'		    
	    })
	    
    /*obj.cboHospital = Common_ComboToSSHosp("cboHospital",SSHospCode,"SD");
	//医院科室联动
	$HUI.combobox('#cboHospital',{
	    onSelect:function(rows){
		    var HospID=rows["CTHospID"];
		    Common_ComboToLoc("cboLocation","E","","I",HospID);
		   
	    }
    });*/
    $HUI.combobox('#cboQC',
	    {
			url:$URL+'?ClassName=DHCMA.CPW.SDS.QCEntitySrv&QueryName=QryQCEntity&ResultSetType=Array',
			valueField:'BTAbbrev',
			textField:'BTDesc'	  
	    })
	var date=Common_GetDate(new Date());
	$('#DateFrom').datebox('setValue',date);
	$('#DateTo').datebox('setValue',date);
	
	
	InitMED0101WinEvent(obj);	
	return obj;
}