//页面Gui
function InitWin(){
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
	    
	$HUI.combobox('#Type',
	    {
		    data:[
		    	{'Type':'1','Desc':"出院日期"},
		    	{'Type':'2','Desc':"提交日期"}
		    ],
			valueField:'Type',
			textField:'Desc'
	    }) 
	Common_SetValue('Type','1');
	
	$HUI.combobox('#cboDoc',
	    {
		    defaultFilter:4,
		    blurValidValue:true,
			url:$URL+'?ClassName=DHCMA.Util.EPS.CareProvSrv&QueryName=QryCareProvInfo&ResultSetType=Array',
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
			valueField:'BTID',
			textField:'BTDesc'	  
	    })
	var date=Common_GetDate(new Date());
	$('#DateFrom').datebox('setValue',date);
	$('#DateTo').datebox('setValue',date);
	
	
	InitWinEvent(obj);	
	return obj;
}