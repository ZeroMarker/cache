$(document).ready(function(){
	$(".SelectedLiCls").removeClass("SelectedLiCls");
	if (ServerObj.isNurseLogin!="1"){
		$.ajax({ 
		  type:'get', 
		  url:'../web.DHCDocInPatientListNew.cls?action=GetPatCount&LocID=' + session['LOGON.CTLOCID']+"&UserId="+session['LOGON.USERID'], 
		  success:function(data,textStatus){ 
		  	var obj = eval('(' + data + ')');
		  	for ( var ind in obj[0]) {
			  	$("#"+ind)[0].innerHTML=obj[0][ind];
			}
		    //$("#CurLocInPatCount")[0].innerHTML=obj[0].CurLocPatCount
		    //$("#CurLocCriticallyPatCount")[0].innerHTML=obj[0].CriticallyPatConut	
		  }
		});
	    $("#InPatList").addClass("SelectedLiCls");
		initPatientList("InPatList");
	}else{
		initPatientList("CurWarPatList");
		$("#CurWarPatList").addClass("SelectedLiCls");
	}
	$("#Tool_Search").click(OpenSearchPatCondition);
	$("#Tool_Refresh").click(RefreshPatientList);
	$("ul>li>a").click(ReLoadPatientList);
})
function RefreshPatientList(){
	window.frames[0].GetData();
}
function OpenSearchPatCondition(){
	$("#PatListSearchCons").toggle()
}
function ReLoadPatientList(e){
	var id=e.target.id;
	if (id==""){
		id=e.target.parentNode.id;
		if (id==""){
			id=e.target.parentNode.parentNode.id;
		}
	}else{
		if (id.indexOf("Count")>=0){
			id=e.currentTarget.id;
		}
	}
    $(".SelectedLiCls").removeClass("SelectedLiCls");
	$("#"+id+"").addClass("SelectedLiCls");
	initPatientList(id);
}
function initPatientList(id){
	$('#PatientListGrid').empty();
	var src="inpatientlist.inpat.csp",PatListType="";
	if (id=="InPatList"){
		PatListType="InPat";
	}else if (id=="OuPatList"){
		PatListType="OutPat";
	}else if (id=="TransOutPatList"){
		PatListType="TransDept";
	}else if (id=="OperationPatLis"){
		PatListType="OperationPat"
	}else if (id=="CriticallPatList"){
		PatListType="CriticallyPat"
	}else if(id=="CurWarPatList"){ //本病区患者
		PatListType="CurWarPat"
	}else if(id=="InHospTransPatList"){ //在院转科
		PatListType="InHospTransPat"
	}else if(id=="DisChargePatList"){ //出院患者
		PatListType="DisChargePat"
	}else if(id=="PreAdmissionPatList"){ //预入院患者
		PatListType="PreAdmissionPatList"
	}
	else{
		return false;
	}
	src=src+"?PatListType="+PatListType;
	var patientList= '<iframe id="framePatientList" src="'+src+'" width="100%" height="100%"'+
                     'marginheight="0" marginwidth="0" scrolling="no" align="middle" ></iframe>'	
     window.setTimeout(function(){
	     $('#PatientListGrid').empty().append(patientList);
	 }, 1000);              
    
}