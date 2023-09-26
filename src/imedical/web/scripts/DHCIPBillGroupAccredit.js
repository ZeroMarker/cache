//DHCIPBillGroupAccredit.js
var global_selectedIndex = -1 ;
function BodyLoadHandler() {
	var obj ; 
	obj = websys_$("AGAPrior") ;
	if(obj){
		obj.size = 1;
		obj.multiple = false;
		obj.options[0] = new Option(t['02'],"G") ;
		obj.options[1] = new Option(t['01'],"P") ;
	}
	;
	obj = websys_$("ActiveFlag") ;
	if(obj){
		obj.size = 1 ;
		obj.multiple = false ;
		obj.options[0] = new Option(t['03'],"Activate")
		obj.options[1] = new Option(t['04'],"Stop") ;
	}
	
	obj = websys_$("AccPAPMINo") ;
	if(obj){
		obj.onkeydown = AccPAPMINo_onkeydown ; 
		//obj.onpropertychange = AccPAPMINo_onpropertychange;
	}
	
	obj = websys_$("RegNo") ;
	if(obj){
		obj.onkeydown = RegNo_onkeydown ; 
		//obj.onpropertychange = RegNo_onpropertychange ;
	}	
	obj = websys_$("Add") ;
	if(obj){
		obj.onclick = Add_onclick ;
	}
	
	obj = websys_$("Update") ;
	if(obj){
	
		obj.onclick = Update_onclick ;
		//obj.style.visibility = "hidden" ;
	}	
}

function AccPAPMINo_onkeydown(){
	var key = window.event.keyCode ;
	var obj ;
	obj = websys_$("AccPAPMINo") ;
	if((key==13)&&(obj)){
		//AccRowid^AccPAPMINo^AccAccountNo^AccCardNo^AccName^AccStatus		
		var rtnString = executeServerRequest("AccEncrypt",obj.value) ;
		var rtnStringArr = rtnString.split("^") ;
		if(rtnStringArr.length>4){
			websys_$("AccRowid").value = rtnStringArr[0] ;				
			websys_$("AccPAPMINo").value = rtnStringArr[1] ;
			websys_$("AccAccountNo").value = rtnStringArr[2] ;			
			websys_$("AccCardNo").value = rtnStringArr[3] ;
			websys_$("AccName").value = rtnStringArr[4] ;			
		}
		Find_click();
	}	
}

function RegNo_onkeydown(){
	var key = window.event.keyCode ;
	var obj ;
	obj = websys_$("RegNo") ;
	if((key==13)&&(obj)){
		var rtnString = executeServerRequest("PaPatMasEncrypt",obj.value) ;
		var rtnStringArr = rtnString.split("^") ;
		if(rtnStringArr.length>1){
			websys_$("PatRowid").value = rtnStringArr[0] ;
			websys_$("RegNo").value = rtnStringArr[1] ;
			websys_$("Name").value = rtnStringArr[2] ;
		}
	}	
}

function Add_onclick(){
	var isNullFlag = CheckIsNull() ;
	if(!isNullFlag){
		return ; 
	}
	var priorIndex = websys_$("AGAPrior").selectedIndex ;
	var activeIndex = websys_$("ActiveFlag").selectedIndex ;
	var str = websys_$V("AccRowid")+"^"+websys_$V("PatRowid")+"^"+websys_$("AGAPrior").options[priorIndex].value +"^"+websys_$V("AGABeginDate")+"^"+websys_$V("AGABeginTime")+"^"+websys_$V("AGAEndDate")+"^"+websys_$V("AGAEndTime")+"^"+session['LOGON.USERID']+"^"+websys_$("ActiveFlag").options[activeIndex].value
	
	var rtnString = executeServerRequest("AddEncrypt",str) ;
	///if(rtnString==1){
    if(rtnString=="0"){
		Find_click() ;
		alert(t['AddSucc']) ;
	}else if(rtnString=="10"){
		alert(t['AccRowidIsNull']) ;
	}else if(rtnString=="11"){
		alert(t['PatRowidIsNull']) ;
	}else{
		alert(t['AddFail']) ;
	}
	
}

function Update_onclick(){
	
	var isNullFlag = CheckIsNull() ;
	
	if(!isNullFlag){
		return ; 
	}
	var priorIndex = websys_$("AGAPrior").selectedIndex ;
	var activeIndex = websys_$("ActiveFlag").selectedIndex ;
	if(global_selectedIndex!=-1){
		var str = websys_$V("AccRowid")+"^"+websys_$("TAGARowidz"+global_selectedIndex).innerText+"^"+websys_$V("PatRowid")+"^"+websys_$("AGAPrior").options[priorIndex].value +"^"+websys_$V("AGABeginDate")+"^"+websys_$V("AGABeginTime")+"^"+websys_$V("AGAEndDate")+"^"+websys_$V("AGAEndTime")+"^"+session['LOGON.USERID']+"^"+websys_$("ActiveFlag").options[activeIndex].value ;
		
		var rtnString = executeServerRequest("UpdateEncrypt",str) ;
		if(rtnString==1){
			Find_click() ;
			alert(t['AddSucc']) ;
		}else if(rtnString=="10"){
			alert(t['AccRowidIsNull']) ;
		}else if(rtnString=="11"){
			alert(t['PatRowidIsNull']) ;
		}else{
			alert(t['AddFail']) ;
		}
	}
	
}

function AccPAPMINo_onpropertychange(){	
		websys_$("AccRowid").value = "" ;
		websys_$("AccAccountNo").value = "" ;
		websys_$("AccCardNo").value = "" ;
		websys_$("AccName").value = "" ;
}

function RegNo_onpropertychange(){
	websys_$("PatRowid").value = "" ;
	websys_$("Name").value = "" ;
}

function SelectRowHandler(){
	var srcObj = window.event.srcElement ;
	var tableObj = websys_$("tDHCIPBillGroupAccredit") ;
	var rows = tableObj.rows.length ;
	if(rows>0){
		selectedRowId = getRow(srcObj).rowIndex ;
		
		if((selectedRowId<rows)&&(selectedRowId>0)&&(selectedRowId!=global_selectedIndex)){
			global_selectedIndex = selectedRowId  ;	 //选中行
			//websys_$("Add").style.visibility = "hidden" ;	
			//websys_$("Update").style.visibility = "visible" ;
		}else{
			global_selectedIndex = -1 ;
			//websys_$("Add").style.visibility = "visible" ;
			//websys_$("Update").style.visibility = "hidden" ;
		}
	}else{
		global_selectedIndex = -1 ;
	}
	
	if(global_selectedIndex!=-1){
		websys_$("PatRowid").value = websys_$("TPAPERDRz"+global_selectedIndex).innerText ;
		
		websys_$("RegNo").value = websys_$("TPatRegNoz"+global_selectedIndex).innerText ;
		websys_$("Name").value = websys_$("TNamez"+global_selectedIndex).innerText ;
		websys_$("AGABeginDate").value = websys_$("TBeginDatez"+global_selectedIndex).innerText ;
		websys_$("AGABeginTime").value = websys_$("TBeginTimez"+global_selectedIndex).innerText ;
		websys_$("AGAEndDate").value = websys_$("TEndDatez"+global_selectedIndex).innerText ;
		websys_$("AGAEndTime").value = websys_$("TEndTimez"+global_selectedIndex).innerText ;
		
		if(websys_$("TPriorz"+global_selectedIndex).value=="P"){
			websys_$("AGAPrior").options[0].selected = true ;
		}if(websys_$("TPriorz"+global_selectedIndex).value=="G"){
			websys_$("AGAPrior").options[1].selected = true ;
		}if(websys_$("TAGAActiveFlagz"+global_selectedIndex).innerText=="无效"){
			websys_$("ActiveFlag").options[1].selected = true ;
		}if(websys_$("TAGAActiveFlagz"+global_selectedIndex).innerText=="有效"){
			websys_$("ActiveFlag").options[0].selected = true ;
		}
	}else{
		websys_$("PatRowid").value = "" ;
		websys_$("RegNo").value = "" ;
		websys_$("Name").value = "" ;
		websys_$("AGABeginDate").value = "" ;
		websys_$("AGABeginTime").value = "" ;
		websys_$("AGAEndDate").value = "" ;
		websys_$("AGAEndTime").value = "" ;
		websys_$("AGAPrior").options[0].selected = true ;;
	}
}

function CheckIsNull(){
	if(websys_$V("AccPAPMINo")==""){
		alert(t['AccPAPMINoIsNull']) ;
		return false ;
	}
	if(websys_$V("AccRowid")==""){
		alert(t['AccRowidIsNull']) ;
		return false ;
	}
	if(websys_$V("RegNo")==""){
		alert(t['RegNoIsNull'])
		return false ;
	}
	if(websys_$V("PatRowid")==""){
		alert(t['PatRowidIsNull']) ;
		return false ;
	}
	if(websys_$V("AGABeginDate")==""){
		alert(t['AGABeginDateIsNull']) ;
		return false ;
	}
	//if(websys_$V("AGAEndDate")==""){
	//	alert(t['AGAEndDateIsNull']) ;
	//	return false ;
	//}
	return true ; 
}

document.body.onload = BodyLoadHandler;