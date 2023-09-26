// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
//var separatorDate="/";
//var formatDate="DMY";
var frm = document.forms["fPAPregDelivery_Edit"];
function PAPregDeliveryEdit_BodyLoadHandler() {
	obj=document.getElementById('update1');
	if (obj) obj.onclick=UpdateAll;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateAll;
}

var AnaMethodID="",AnaDrugID=""
var stage2HtID="",stage3HtID="",FundusID=""
function Init() {
	//Log 45749 - If the episode type is not valid, disable all fields and return
	if(!checkAdmType()) return false;
	var objID=document.getElementById("ID");
	
	var obj;
     
	obj=document.getElementById('delete1');
	if (obj) {
		obj.onclick=DeleteClickHandler;
	}
	if (tsc['delete1']){
		 websys_sckeys[tsc['delete1']]=DeleteClickHandler;
	}else{
		tsc['delete1']="R"
		websys_sckeys["R"]=DeleteClickHandler;
	}

	obj=document.getElementById('DeleteIndIndctr');
	if (obj) obj.onclick=IndIndctrDeleteClickHandler;

	obj=document.getElementById('DeleteLabDelCompl');
	if (obj) obj.onclick=LabDelComplDeleteClickHandler;

	obj=document.getElementById('DeleteTearLoc');
	if (obj) obj.onclick=TearLocDeleteClickHandler;



	obj=document.getElementById('DeletePuerp');
	if (obj) obj.onclick=PuerpDeleteClickHandler;

	obj=document.getElementById('DeleteAugMth');
	if (obj) obj.onclick=AugMthDeleteClickHandler;

	obj=document.getElementById('DeleteIndMth');
	if (obj) obj.onclick=IndMthDeleteClickHandler;

	obj=document.getElementById('DeletePreCompl');
	if (obj) obj.onclick=PreComplDeleteClickHandler;

	obj=document.getElementById('update1');
	if (obj) obj.onclick=UpdateAll;
	if (tsc['update1']){
		 websys_sckeys[tsc['update1']]=UpdateAll;
	}else{
		tsc['update1']="U"
		websys_sckeys["U"]=UpdateAll;
	}

	obj=document.getElementById('DELLabourOnsetDate');
	if (obj) obj.onblur=OnsetDateHandler;

	obj=document.getElementById('DELLabourOnsetTime');
	if (obj) obj.onblur=OnsetTimeHandler;

	obj=document.getElementById('DELFullDilatationDate');
	if (obj) obj.onblur=DilationDateHandler;

	obj=document.getElementById('DELFullDilatationTime');
	if (obj) obj.onblur=DilationTimeHandler;

	obj=document.getElementById('DELCsDecisionDate');
	if (obj) obj.onblur=CsDecisionDateHandler;

	obj=document.getElementById('DELCsDecisionTime');
	if (obj) obj.onblur=CsDecisionTimeHandler;

	obj=document.getElementById('DELDateOfInduction');
	if (obj) obj.onblur=InductionDateHandler;

	obj=document.getElementById('DELTimeOfInduction');
	if (obj) obj.onblur=InductionTimeHandler;
	obj=document.getElementById('DELBloodLoss');
	if (obj) obj.onblur=BloodLossHandler;

	obj=document.getElementById('DELCervixDilation');
	if (obj) obj.onblur=CervixDilationHandler;

	obj=document.getElementById('DELContractionsInterval');
	if (obj) obj.onblur=ContractionHandler;

	obj=document.getElementById('DELLabourMethodDR');
	if (obj) obj.onblur=LabourMethodBlurHandler;
	CalcStage2();
	CalcStage3();
	CalcTotalLabour();
	//The following method disables the New link on PAPregDelBaby.List
	DoDisableNewLinkBaby();

	DoInitValidations();

	//ypz begin
	var objMoveAttachBaby=document.getElementById("MoveAttachBaby");	
	if (objMoveAttachBaby){
		var userId=session['LOGON.USERID'];
		var EpisodeID=document.getElementById('EpisodeID').value;
		//alert(EpisodeID+"/");
		var retStr=cspRunServerMethod(objMoveAttachBaby.value,EpisodeID,userId,"","");
		if (retStr!=0) {
			alert(retStr);
			//window.close();
			//return;
		}		
	}
	//ypz end
	

        // xuqy begin 090108
    combo("DelDrug");
    
       
	var PatientID=document.getElementById('PatientID').value;
  	var GetGravida=document.getElementById("GetGravida").value;
  	var delID=document.getElementById('ID').value;
    var str=cspRunServerMethod(GetGravida,PatientID,delID);
    var arrGravida=str.split("^");
    var Gravida=document.getElementById('Gravida');
    if (Gravida) {
	    if(objID.value!="")
	    Gravida.value=arrGravida[0];
  		Gravida.style.background="LightBlue";
    }
	var Para=document.getElementById('Para');
	if (Para){
		if(objID.value!="")
		Para.value=arrGravida[1];
		Para.style.background="LightBlue";
	}
	var DELPlurality=document.getElementById('DELPlurality');
	DELPlurality.style.background="LightBlue";
    var objStage2FundalHt=document.getElementById('DELStage2FundalHeight');
    if ((objStage2FundalHt)&&(arrGravida[2])){
	    var Stage2FundalHt=arrGravida[2].split(" ");
	    if (Stage2FundalHt[0]) objStage2FundalHt.value=Stage2FundalHt[0];
	    if (Stage2FundalHt[1]) stage2HtID=Stage2FundalHt[1];
	 }
    var objStage3FundalHt=document.getElementById('DELStage3FundalHeight');
    if ((objStage3FundalHt)&&(arrGravida[3])){
	    var Stage3FundalHt=arrGravida[3].split(" ");
	    if (Stage3FundalHt[0]) objStage3FundalHt.value=Stage3FundalHt[0];
	    if (Stage3FundalHt[1]) stage3HtID=Stage3FundalHt[1];
	 }
    
    var DELCollBloodLoss=document.getElementById('DELCollBloodLoss');
	if ((DELCollBloodLoss)&&(arrGravida[4])) DELCollBloodLoss.value=arrGravida[4];
	var DELEstiBloodLoss=document.getElementById('DELEstiBloodLoss');
	if ((DELEstiBloodLoss)&&(arrGravida[5])) DELEstiBloodLoss.value=arrGravida[5];
	var objDELBloodLoss=document.getElementById('DELBloodLoss');
	if ((objDELBloodLoss)&&(arrGravida[6])) objDELBloodLoss.value=arrGravida[6];
	var objDel1HourPulse=document.getElementById('Del1HourPulse');
   
	if ((objDel1HourPulse)&&(arrGravida[7])) objDel1HourPulse.value=arrGravida[7];
    var Del1HourBPDiastolic=document.getElementById('Del1HourBPDiastolic');
    if ((Del1HourBPDiastolic)&&(arrGravida[8])) Del1HourBPDiastolic.value=arrGravida[8];
    var Del1HourBPSystolic=document.getElementById('Del1HourBPSystolic');
    if ((Del1HourBPSystolic)&&(arrGravida[9])) Del1HourBPSystolic.value=arrGravida[9];
    var Del1HourFundus=document.getElementById('Del1HourFundus');
    if ((Del1HourFundus)&&(arrGravida[10])){
	    var Fundus=arrGravida[10].split(" ");
	    if (Fundus[0]) Del1HourFundus.value=Fundus[0];
	    if (Fundus[1]) FundusID=Fundus[1];
	 }
    
    var Del1HourBloodLoss=document.getElementById('Del1HourBloodLoss');
    if ((Del1HourBloodLoss)&&(arrGravida[11])) Del1HourBloodLoss.value=arrGravida[11];
	//add 2012
	var DelCervix=document.getElementById("DelCervix");
    if	((DelCervix)&&(arrGravida[12])) DelCervix.value=arrGravida[12];
	
    var DELNote=document.getElementById('DELNote'); 
    if ((DELNote)&&(arrGravida[13])) DELNote.value=arrGravida[13]; 
    var DELDiagnose=document.getElementById('DELDiagnose'); 
    
    if ((DELDiagnose)&&(arrGravida[14])) DELDiagnose.value=arrGravida[14]; 
    var PuerperiumAttention=document.getElementById('PuerperiumAttention'); 
    if ((PuerperiumAttention)&&(arrGravida[15])) PuerperiumAttention.value=arrGravida[15]; 
    if ((PuerperiumAttention)&&(PuerperiumAttention.value=="")) PuerperiumAttention.value="出血,感染"
    var obj=document.getElementById("DelDrugAdd");
	if (obj) {  obj.onclick=DelDrugAdd_Click;  }
	var obj=document.getElementById("DelDrugItem");
    if (obj) {obj.ondblclick=DelDrugItem_Dublclick}
    var GetDelDrugList=document.getElementById("GetDelDrugList").value;
    var strDrugList=cspRunServerMethod(GetDelDrugList,delID);
    if (strDrugList!=""){
	    //listDrug(strDrugList)
	    listdataInfo(strDrugList,"DelDrugItem")
    }
     var GetIndictList=document.getElementById("GetIndictList").value;
    var strIndictList=cspRunServerMethod(GetIndictList,delID);
    if (strIndictList!=""){
	    var arrydelt=strIndictList.split("&");
	    var IndictDesc=document.getElementById("IndictDesc")
	    if (arrydelt[0]) IndictDesc.value=arrydelt[0]
	    if ((arrydelt[1])&&(arrydelt[1]!="")){
		    listdataInfo(arrydelt[1],"Indicators")
		}    

    }
    var SutureAncommonOrd=document.getElementById('SutureAncommonOrd');
    if ((SutureAncommonOrd)&&(arrGravida[16])){
	    var anOrd=arrGravida[16].split(" ");
	    if (anOrd[0]) SutureAncommonOrd.value=anOrd[0];
	    if (anOrd[1]) AnaDrugID=anOrd[1];
	 }   
    var AnaestMethod=document.getElementById('AnaestMethod'); 
    if ((AnaestMethod)&&(arrGravida[17])){
	    var anMethod=arrGravida[17].split(" ");
	    if (anMethod[0]) AnaestMethod.value=anMethod[0];
	    if (anMethod[1]) AnaMethodID=anMethod[1];
	 }
	 
	var obj=document.getElementById("Indicators");
    if (obj) {obj.ondblclick=Indicators_Dublclick}
	var obj=document.getElementById("DelOPType");
    if ((obj)&&(arrGravida[19])) {
	    
	    arrGravida[19]=arrGravida[19].replace(/\|\|/g,"^");
	    	    listdataInfo(arrGravida[19],"DelOPType")
	    obj.ondblclick=DelOPType_Dublclick
    } 
	 
	 
	var DELSuture=document.getElementById('DELSuture');
	if ((DELSuture)&&(arrGravida[18])){
		DELSuture.value=arrGravida[18]
	   }
	 if((DELSuture)&&(DELSuture.value=="")) DELSuture.value="内缝2/0可吸收缝合线,外缝"     
     //xuqy end 090108

}

 function listdataInfo(strList,elementName)
{       
	var arryList=strList.split("^");
	var objItem=document.getElementById(elementName);
	
	//for (var i=1;i<arryDrugList.length;i++)
	for (var i=1;i<arryList.length;i++)
   	{
	   if (arryList[i]!="")
	   {
		var Item=arryList[i].split("$");
		var sel=new Option(Item[1],Item[0]);
		objItem.options[objItem.options.length]=sel;
		
	   }
	}
	
}
    

function getanmethod(str)
{
		var ass=str.split("^");
		AnaMethodID=ass[1]; 
}
function getanDrug(str)
{
		var ass=str.split("^");
		AnaDrugID=ass[1]; 
}

function get2FundalHeight(str)
{
		var ass=str.split("^");
		stage2HtID=ass[1]; 
}

function get3FundalHeight(str)
{
		var ass=str.split("^");
		stage3HtID=ass[1]; 
}
function get1HourFundus(str)
{
		var ass=str.split("^");
		FundusID=ass[1]; 
}

function listDrug(strDrugList)
{       
	
	var arryDrugList=strDrugList.split("^");
	var objDrugItem=document.getElementById("DelDrugItem");
	//for (var i=1;i<arryDrugList.length;i++)
	for (var i=0;i<arryDrugList.length;i++)
   	{
	   if (arryDrugList[i]!="")
	   {
		var Item=arryDrugList[i].split("$");
		
		var sel=new Option(Item[2],Item[1]);
		objDrugItem.options[objDrugItem.options.length]=sel;
	   }
	}
	
}
function getDelOP(value)
{
	var i
	var user=value.split("^");
	var selop=document.getElementById('selDelOP');
	selop.value="";
    var objSelected = new Option(user[0], user[1]);
	var obj=document.getElementById('DelOPType');
	//obj.options[obj.options.length]=objSelected;
    // 20090817
    if (obj.options.length==0)
    {
	 obj.options[obj.options.length]=objSelected;   
    }
    else{
        for (i=0;i<obj.options.length;i++)
	     {   
            if (ifexist(user[1],obj)==false)
            {
             obj.options[obj.options.length]=objSelected;
            } 
	      }
	}      
}



function getIndictors(value)
{
	var i
	var user=value.split("^");
	var selIndict=document.getElementById('selIndict');
	selIndict.value="";
    var objSelected = new Option(user[0], user[1]);
	var obj=document.getElementById('Indicators');
    if (obj.options.length==0)
    {
	 obj.options[obj.options.length]=objSelected;   
    }
    else{
        for (i=0;i<obj.options.length;i++)
	     {   
            if (ifexist(user[1],obj)==false)
            {
             obj.options[obj.options.length]=objSelected;
            } 
	      }
	}      
}

function combo(cmstr)
   {
	var obj=document.getElementById(cmstr);
	if (obj){
		obj.size=1; 
		obj.multiple=false;
		if (obj.options.length>0){
			obj.options[0].selected=true;
		}
    }
   }
function DelDrugAdd_Click()
   {  
    var surlist=document.getElementById("DelDrug");
    var dlist=document.getElementById("DelDrugItem");
    movein(surlist,dlist)  
   }

function movein(surlist,dlist)
{  
    
   if (surlist.selectedIndex==-1){
	   return;
	   }

	var i;
	var objSelected ;// new Option(surlist[nIndex].text, surlist[nIndex].value);
	
	for (i=0;i<surlist.options.length;i++)
	{
		if (surlist.options[i].selected)
		{

		  if (ifexist(surlist[i].value,dlist)==false)
		   {
      	    var objSelected = new Option(surlist[i].text, surlist[i].value);
	        dlist.options[dlist.options.length]=objSelected;
	       // surlist.options[i]=null;
	        i=i-1;
		    }
       	 }
	   }
		
	return;
	}
	   
//检查目的listitem 是否有该值?
function ifexist(val,list)
{
	for (var i=0;i<list.options.length;i++){
		if (list.options[i].value==val)
		{
			return true;
		}
	}
	return false;
}

function DelDrugItem_Dublclick()
{
  var objDelDrugItem=document.getElementById("DelDrugItem");
  var a=objDelDrugItem.selectedIndex;
  if (a>=0){
  	objDelDrugItem.remove(a);
  }
}

function Indicators_Dublclick()
{
  var objItem=document.getElementById("Indicators");
  var a=objItem.selectedIndex;
  objItem.remove(a) ;
}

function DelOPType_Dublclick()
{
  var objItem=document.getElementById("DelOPType");
  var a=objItem.selectedIndex;
  objItem.remove(a) ;
}
	   
function labelMandatory(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl.className = "clsRequired";
	}
}

function labelNormal(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl.className = "";
	}
}

function DisableField(fldName) {
	var lbl = ('c'+fldName);
	var fld = document.getElementById(fldName);
	if (fld) {
		fld.value = "";
		fld.disabled = true;
		fld.className = "clsDisabled";
		if (lbl) lbl = lbl.className = "";
	}
}

function DisableList(fldName){
	var lbl = ('c'+fldName);
	var fld = document.getElementById(fldName);
	if (fld) {
		RemoveAllFromList(fld);
		fld.disabled = true;
		fld.className = "clsDisabled";
		if (lbl) lbl = lbl.className = "";
	}
}

function EnableField(fldName) {
	var lbl = ('c'+fldName);
	var fld = document.getElementById(fldName);
	if (fld) {
		fld.disabled = false;
		fld.className = "";
		if (lbl) lbl = lbl.className = "";
	}
}

function LinkDisabled() {
	return false;
}

//Log 45749 - On page load, check the admission status, if it's not valid give err message and disable all fields.
function checkAdmType(){
	var proceed = checkValidAdmType();
	if(!proceed){
		makeReadOnly();
	}
	return proceed;
}

//Log 45749 - this will be overriden by the custom scripts so sites can decide what episode types are invalid
function checkValidAdmType(){
	//var atObj=document.getElementById('admType');
	//if(atObj && atObj.value=="I") {
	//	return false;	
	//}

	return true;
}

//Log 45749 - this function will make all the fields on the delivery screen disabled
function makeReadOnly(){
	var el=document.forms["fPAPregDelivery_Edit"].elements;  
	if(!el) {return;}
	for (var i=0;i<el.length;i++) {
		if (!(el[i].type=="hidden")) {
			el[i].disabled=true;
		}
	}
	
	var arrLookUps=document.getElementsByTagName("IMG");
	for (var i=0; i<arrLookUps.length; i++) {
		if ((arrLookUps[i].id)&&(arrLookUps[i].id.charAt(0)=="l")) {
			arrLookUps[i].disabled=true;
		}
	}

	var arrLinks=document.getElementsByTagName("A");
	for (var i=0; i<arrLinks.length; i++) {
		if ((arrLinks[i].id)) {
			arrLinks[i].disabled=true;
			arrLinks[i].className="clsDisabled";
			arrLinks[i].onclick=LinkDisabled;
			arrLinks[i].style.cursor='default';
		}
	}	
}

//Log 43579 - On page load, set field dependencies based on Labour Method.
function DoInitValidations(){

	DoLabourMethodValidation();


}

//Log 43579 
function DoLabourMethodValidation(){
	var lmObj = document.getElementById('HLabourMethodType');
	if(lmObj){
		//set all required variables
		var ldateObj= document.getElementById('DELLabourOnsetDate');
		var ltimeObj= document.getElementById('DELLabourOnsetTime');
		var idateObj= document.getElementById('DELDateOfInduction');
		var itimeObj= document.getElementById('DELTimeOfInduction');
		var alkObj= document.getElementById('AUGMTHDesc');
		var amethObj= document.getElementById('AUGMTHEntered');
		var ilkObj= document.getElementById('INDMTHDesc');
		var imethObj= document.getElementById('INDMTHEntered');
		var iilkObj= document.getElementById('INDINDCTRDesc');
		var iindObj= document.getElementById('INDINDCTREntered');
		var oindObj= document.getElementById('DELOthIndIndctr');
		var oaimethObj= document.getElementById('DELOthIndAugMthd');
		
		if(lmObj.value=="" || lmObj.value=="N"){//Blank or No labour

			//Make Labour Onset date and time not mandatory
			if(ldateObj) labelNormal(ldateObj.id);
			if(ltimeObj) labelNormal(ltimeObj.id);
			
			//Make all other Induction/Augmentation fields disabled
			if(idateObj) {
				DisableField(idateObj.id);
				labelNormal(idateObj.id);
			}
			if(itimeObj) {
				DisableField(itimeObj.id);
				labelNormal(itimeObj.id);
			}
			if(amethObj) DisableList(amethObj.id);
			if(imethObj) DisableList(imethObj.id);
			if(iindObj) DisableList(iindObj.id);
			if(oindObj) DisableField(oindObj.id);			
			if(oaimethObj) DisableField(oaimethObj.id);			
			if(alkObj) DisableField(alkObj.id);
			if(ilkObj) DisableField(ilkObj.id);
			if(iilkObj) DisableField(iilkObj.id);
		
		}
		else{
			//do common validations that apply to Labour Method being 'S', 'A' or 'I'
			//Set Labour Onset Date/Time to Mandatory
			if(ldateObj) labelMandatory(ldateObj.id);
			if(ltimeObj) labelMandatory(ltimeObj.id);
			
 
			if(lmObj.value=="S"){ //Spontaneous labour
				//Make all Induction/Augmentation fields disabled
				if(idateObj) {
					EnableField(idateObj.id);
					labelNormal(idateObj.id);
				}
				if(itimeObj) {
					EnableField(itimeObj.id);
					labelNormal(itimeObj.id);
				}
				if(amethObj) EnableField(amethObj.id);
				if(imethObj) DisableList(imethObj.id);
				if(iindObj) DisableList(iindObj.id);
				if(oindObj) DisableField(oindObj.id);			
				if(alkObj) EnableField(alkObj.id);
				if(ilkObj) DisableField(ilkObj.id);
				if(iilkObj) DisableField(iilkObj.id);
				if(oaimethObj) EnableField(oaimethObj.id);			
			}
			else if(lmObj.value=="A"){ //Augmented labour
				//Make all Induction fields disabled, enable all augmentation fields
				if(idateObj) {
					EnableField(idateObj.id);
					labelMandatory(idateObj.id);
				}
				if(itimeObj) {
					EnableField(itimeObj.id);
					labelMandatory(itimeObj.id);
				}
				if(amethObj) EnableField(amethObj.id);
				if(imethObj) DisableList(imethObj.id);
				if(iindObj) DisableList(iindObj.id);
				if(oindObj) DisableField(oindObj.id);			
				if(alkObj) EnableField(alkObj.id);
				if(ilkObj) DisableField(ilkObj.id);
				if(iilkObj) DisableField(iilkObj.id);
				if(oaimethObj) EnableField(oaimethObj.id);			
			}
			else if(lmObj.value=="I"){ //Induced labour
				//Make all Augmentation fields disabled, enable all induction fields
				if(idateObj) {
					EnableField(idateObj.id);
					labelMandatory(idateObj.id);
				}
				if(itimeObj) {
					EnableField(itimeObj.id);
					labelMandatory(itimeObj.id);
				}
				if(amethObj) DisableList(amethObj.id);
				if(imethObj) EnableField(imethObj.id);
				if(iindObj) EnableField(iindObj.id);
				if(oindObj) EnableField(oindObj.id);			
				if(alkObj) DisableField(alkObj.id);
				if(ilkObj) EnableField(ilkObj.id);
				if(iilkObj) EnableField(iilkObj.id);
				if(oaimethObj) EnableField(oaimethObj.id);			
			}
		}		
	}
}

//Log 32539 - Blur Handler for 'DELLabourMethodDR'.  If the value in 'DELLabourMethodDR' is blank, 
//set HLabourMethodType to blank.
function LabourMethodBlurHandler(){
	var obj1 = document.getElementById('HLabourMethodType');
	var obj2 = document.getElementById('DELLabourMethodDR');
	if (obj1 && obj2){ 
		if (obj2.value == ""){
			obj1.value="";
			DoLabourMethodValidation();
		}
	}
}

//Log 32539
function SetLabourMethodType(str){
	//alert("str " + str);
	var arr = str.split("^");
	//alert("in js code " + arr[2] + " desc " + arr[0] + " type " + arr[3]);
	var obj = document.getElementById('HLabourMethodType');
	if(obj){
		obj.value = arr[3];
		DoLabourMethodValidation();
	}

}

//Check that length is a positive number
function BloodLossHandler(){
	var obj = document.getElementById('DELBloodLoss');
	if (obj && obj.value != "")
		CheckPositiveNumber(obj, "DELBloodLoss");

}

//Check that length is a positive number
function CervixDilationHandler(){
	var obj = document.getElementById('DELCervixDilation');
	if (obj && obj.value != "")
		CheckPositiveNumber(obj, "DELCervixDilation");

}

//Check that length is a positive number
function ContractionHandler(){
	var obj = document.getElementById('DELContractionsInterval');
	if (obj && obj.value != "")
		CheckPositiveNumber(obj, "DELContractionsInterval");

}

//Function to check if the passed value is a positive number.  If not give error message and clear field.
function CheckPositiveNumber(obj, fieldName){
	//This doesn't work properly on update.  Update still continues even if invalid.
	//var valid = IsPositiveNumber(obj);
	//if (!valid){
	//	obj.className='clsInvalid';
	//	websys_setfocus(fieldName);
	//	return websys_cancel();
	//}
	//else{
	//	obj.className='';
	//}
	//return true;	

	var valid = IsPositiveNumber(obj);
	if (!valid){
		alert(t[fieldName] + " " + t['Positive_Number']);
		obj.value="";
		websys_setfocus(fieldName);
		return false;
	}
	return true;
}


//Not implemented yet.  Can be overwritten in custome script.
function DoDisableNewLinkBaby(){

}

//This function compares the passed date and time to current date and time.  If passed date/time is in the future,
//an error message is given.
function DoDateTimeFutureValidationOLD(dateFld, timeFld){
	var dt = document.getElementById(dateFld);
	if(dt && dt.value != ""){
		var dateCmpr = DateStringCompareToday(dt.value);
		if(dateCmpr == 1){
			alert(t[dateFld] + " " + t["FutureDate"]);
    			dt.value = "";
	    		websys_setfocus(dateFld);
			return false;

			//dt.className='clsInvalid';
			//websys_setfocus(dateFld);
			//return  websys_cancel();
		}
		//if date is today's date, then check time to make sure that it's not in the future
		else if (dateCmpr == 0){
			var tm = document.getElementById(timeFld);
			if(tm && tm.value!="" && dt.value!=""){//need to check dt as well as it may have been set to "" above
				var arrDate = DateStringToArray(dt.value);
				var arrTime = TimeStringToArray(tm.value);
				var entDateTime = new Date(arrDate["yr"],arrDate["mn"]-1,arrDate["dy"],arrTime["hr"],arrTime["mn"],0);
				var nowDateTime = new Date();
				if (entDateTime.getTime() > nowDateTime.getTime()){
					alert(t[timeFld] + " " + t["FutureDate"]);
	    				tm.value = "";
    					websys_setfocus(timeFld);
					return false;
				}
			}
		
		}
	}
	return true;	
}
//md now based on standar datetime compare
function DoDateTimeFutureValidation(dateFld, timeFld){
	var dt = document.getElementById(dateFld);
	if(dt && dt.value != ""){
		var dateCmpr = DateStringCompareToday(dt.value);
		if(dateCmpr == 1){
			alert(t[dateFld] + " " + t["FutureDate"]);
    			dt.value = "";
	    		websys_setfocus(dateFld);
			return false;

			//dt.className='clsInvalid';
			//websys_setfocus(dateFld);
			//return  websys_cancel();
		}
		//if date is today's date, then check time to make sure that it's not in the future
		else if (dateCmpr == 0){
			var tm = document.getElementById(timeFld);
			if(tm && tm.value!="" && dt.value!=""){//need to check dt as well as it may have been set to "" above
				var dtcompare=DateTimeStringCompareToday(dt.value,tm.value) 
				if (dtcompare=="1"){
					alert(t[timeFld] + " " + t["FutureDate"]);
	    				tm.value = "";
    					websys_setfocus(timeFld);
					return false;
				}
			}
		
		}
	}
	return true;	
}
//This function compares the passed dates and times.  If date/time 1 is not after
//date/time 2, an error message is given.
function DoDateTimeComparisonAfter(dateFld1, timeFld1, dateFld2, timeFld2){
	var dt1 = document.getElementById(dateFld1);
	var dt2 = document.getElementById(dateFld2);
	var tm2 = document.getElementById(timeFld2);
	if(dt1 && dt1.value != "" && dt2 && dt2.value != ""){
		var dateCmpr = DateStringCompare(dt1.value,dt2.value);
		if(dateCmpr == -1){
			alert(t[dateFld1] + " " + t['Must_Be_After'] + " " + t[dateFld2]);
    			dt1.value = "";
	    		websys_setfocus(dateFld1);
			return false;
		}
		//if date 1 is after date 2, then check time 1 to make sure that it is after time 2
		else if (dateCmpr == 0){
			var tm1 = document.getElementById(timeFld1);
			if(tm1 && tm1.value!="" && dt1.value!="" && tm2 && tm2.value!=""){//need to check dt as well as it may have been set to "" above
				if (DateTimeStringCompare(dt1.value,tm1.value,dt2.value,tm2.value) != 1){
					alert(t[timeFld1] + " " + t['Must_Be_After'] + " " + t[timeFld2]);
	    				tm1.value = "";
    					websys_setfocus(timeFld1);
					return false;
				}
			}
		
		}
	}
	return true;	
}

//This function compares the passed dates and times.  If date/time 1 is not before
//date/time 2, an error message is given.
function DoDateTimeComparisonBefore(dateFld1, timeFld1, dateFld2, timeFld2){
	var dt1 = document.getElementById(dateFld1);
	var dt2 = document.getElementById(dateFld2);
	var tm2 = document.getElementById(timeFld2);
	if(dt1 && dt1.value != "" && dt2 && dt2.value != ""){
		var dateCmpr = DateStringCompare(dt1.value,dt2.value);
		if(dateCmpr == 1){
			alert(t[dateFld1] + " " + t['Must_Be_Before'] + " " + t[dateFld2]);
    			dt1.value = "";
	    		websys_setfocus(dateFld1);
			return false;
		}
		//if date 1 is after date 2, then check time 1 to make sure that it is after time 2
		else if (dateCmpr == 0){
			var tm1 = document.getElementById(timeFld1);
			if(tm1 && tm1.value!="" && dt1.value!="" && tm2 && tm2.value!=""){//need to check dt as well as it may have been set to "" above
				if (DateTimeStringCompare(dt1.value,tm1.value,dt2.value,tm2.value) != -1){
					alert(t[timeFld1] + " " + t['Must_Be_Before'] + " " + t[timeFld2]);
	    				tm1.value = "";
    					websys_setfocus(timeFld1);
					return false;
				}
			}
		
		}
	}
	return true;	
}

//check Date, if in the future give error message and return
//if Date is today's date, then check time, if in the future give error and return.
//Induction Date/Time must be before Onset Date/Time.
//Augmentation Date/Time must be after Onset Date/Time.
function InductionDateHandler(){
	DELDateOfInduction_changehandler(e)
	if (DoDateTimeFutureValidation("DELDateOfInduction","DELTimeOfInduction")){
		lbMth = document.getElementById('HLabourMethodType');
		if(lbMth && lbMth.value=="I"){
			if (DoDateTimeComparisonBefore("DELDateOfInduction","DELTimeOfInduction","DELLabourOnsetDate","DELLabourOnsetTime")){}
		}
		if (lbMth && (lbMth.value=="S" || lbMth.value=="A")){
			if (DoDateTimeComparisonAfter("DELDateOfInduction","DELTimeOfInduction","DELLabourOnsetDate","DELLabourOnsetTime")){}
		}
	}	
}

//check Date, if in the future give error message and return
//if Date is today's date, then check time, if in the future give error and return
//Induction Date/Time must be before Onset Date/Time
//Augmentation Date/Time must be after Onset Date/Time.
function InductionTimeHandler(){
	DELTimeOfInduction_changehandler(e)
	if(DoDateTimeFutureValidation("DELDateOfInduction","DELTimeOfInduction")){
		lbMth = document.getElementById('HLabourMethodType');
		if(lbMth && lbMth.value=="I"){
			if (DoDateTimeComparisonBefore("DELDateOfInduction","DELTimeOfInduction","DELLabourOnsetDate","DELLabourOnsetTime")){}
		}
		if(lbMth && (lbMth.value=="S" || lbMth.value=="A")){
			if (DoDateTimeComparisonAfter("DELDateOfInduction","DELTimeOfInduction","DELLabourOnsetDate","DELLabourOnsetTime")){}
		}
	}
}




//check Date, if in the future give error message and return
//if Date is today's date, then check time, if in the future give error and return
function CsDecisionDateHandler(){
	DELCsDecisionDate_changehandler(e)
	if (DoDateTimeFutureValidation("DELCsDecisionDate","DELCsDecisionTime")){
	}	
}

//check Date, if in the future give error message and return
//if Date is today's date, then check time, if in the future give error and return
function CsDecisionTimeHandler(){
	DELCsDecisionTime_changehandler(e)
	if(DoDateTimeFutureValidation("DELCsDecisionDate","DELCsDecisionTime")){
	}
}

//check Date, if in the future give error message and return
//if Date is today's date, then check time, if in the future give error and return.
//Onset Date/Time must be after Induction Date/Time but before Augmentation Date/Time.
//Onset Date/Time must be before Dilation Date/Time.
function OnsetDateHandler(){
	DELLabourOnsetDate_changehandler(e)
	if (DoDateTimeFutureValidation("DELLabourOnsetDate","DELLabourOnsetTime")){
		lbMth = document.getElementById('HLabourMethodType');
		if(lbMth && lbMth.value=="I"){
			if (DoDateTimeComparisonAfter("DELLabourOnsetDate","DELLabourOnsetTime","DELDateOfInduction","DELTimeOfInduction")){
				if(DoDateTimeComparisonBefore("DELLabourOnsetDate","DELLabourOnsetTime","DELFullDilatationDate","DELFullDilatationTime")){}
			}
		}
		else{
			if (DoDateTimeComparisonBefore("DELLabourOnsetDate","DELLabourOnsetTime","DELDateOfInduction","DELTimeOfInduction")){
				if(DoDateTimeComparisonBefore("DELLabourOnsetDate","DELLabourOnsetTime","DELFullDilatationDate","DELFullDilatationTime")){}
			}
		}
	}
	OnsetHandler();
}

//check Date, if in the future give error message and return
//if Date is today's date, then check time, if in the future give error and return
//Onset Date/Time must be after Induction Date/Time and before Dilation Date/Time.
function OnsetTimeHandler(){
	DELLabourOnsetTime_changehandler(e)
	if(DoDateTimeFutureValidation("DELLabourOnsetDate","DELLabourOnsetTime")){
		lbMth = document.getElementById('HLabourMethodType');
		if(lbMth && lbMth.value=="I"){
			if (DoDateTimeComparisonAfter("DELLabourOnsetDate","DELLabourOnsetTime","DELDateOfInduction","DELTimeOfInduction")){
				if(DoDateTimeComparisonBefore("DELLabourOnsetDate","DELLabourOnsetTime","DELFullDilatationDate","DELFullDilatationTime")){}
			}
		}
		else{
			if (DoDateTimeComparisonBefore("DELLabourOnsetDate","DELLabourOnsetTime","DELDateOfInduction","DELTimeOfInduction")){
				if(DoDateTimeComparisonBefore("DELLabourOnsetDate","DELLabourOnsetTime","DELFullDilatationDate","DELFullDilatationTime")){}
			}
		}
	}
	OnsetHandler();
}


function OnsetHandler(){
	CalcStage1();
	CalcTotalLabour();
}

//check Date, if in the future give error message and return
//if Date is today's date, then check time, if in the future give error and return
//Dilation Date/Time must be after Induction Date/Time and after Onset Date/Time.
function DilationDateHandler(){
	DELFullDilatationDate_changehandler(e)
	if (DoDateTimeFutureValidation("DELFullDilatationDate","DELFullDilatationTime")){
		if(DoDateTimeComparisonAfter("DELFullDilatationDate","DELFullDilatationTime","DELDateOfInduction","DELTimeOfInduction")){
			if(DoDateTimeComparisonAfter("DELFullDilatationDate","DELFullDilatationTime","DELLabourOnsetDate","DELLabourOnsetTime")){

			}
		}
	}	
	DilationHandler();
}

//check Date, if in the future give error message and return
//if Date is today's date, then check time, if in the future give error and return
//Dilation Date/Time must be after Induction Date/Time and after Onset Date/Time.
function DilationTimeHandler(){
	DELFullDilatationTime_changehandler(e)
	if(DoDateTimeFutureValidation("DELFullDilatationDate","DELFullDilatationTime")){
		if(DoDateTimeComparisonAfter("DELFullDilatationDate","DELFullDilatationTime","DELDateOfInduction","DELTimeOfInduction")){
			if(DoDateTimeComparisonAfter("DELFullDilatationDate","DELFullDilatationTime","DELLabourOnsetDate","DELLabourOnsetTime")){

			}
		}
	}
	DilationHandler();
}

function DilationHandler(){
	CalcStage1();
	CalcStage2();
	CalcTotalLabour();
}

//Calculate Stage1 as Full Dilation Date Time - Laour Onset Date Time.  Display as HH:MM.
function CalcStage1(){
	var onsetDateObj = document.getElementById('DELLabourOnsetDate');
	var onsetTimeObj = document.getElementById('DELLabourOnsetTime');
	var dilationDateObj = document.getElementById('DELFullDilatationDate');
	var dilationTimeObj = document.getElementById('DELFullDilatationTime');
	var stage1Obj = document.getElementById('DELStage1');	
	var stage1HObj = document.getElementById('DELStage1H');	

	if(onsetDateObj == null || onsetTimeObj == null || dilationDateObj == null || dilationTimeObj == null || stage1Obj == null || stage1HObj == null)
		return;
	
	if(onsetDateObj.value == "" || onsetTimeObj.value == "" || dilationDateObj.value == "" || dilationTimeObj.value == ""){
		stage1Obj.value = "";
		stage1HObj.value = "";
		return;
	}
	
	stage1Obj.value = DateTimeDiffInHMStr(onsetDateObj.value, onsetTimeObj.value, dilationDateObj.value, dilationTimeObj.value);	
	stage1HObj.value = stage1Obj.value;
}

//Calculate Stage2 as Birth Date Time of Last Baby - Full Dilation Date Time.  Display as HH:MM.
function CalcStage2(){
	var dilationDateObj = document.getElementById('DELFullDilatationDate');
	var dilationTimeObj = document.getElementById('DELFullDilatationTime');
	var maxBabyDateObj = document.getElementById('MaxBabyDob');
	var maxBabyTimeObj = document.getElementById('MaxBabyTob');
	var stage2Obj = document.getElementById('DELStage2');	
	var stage2HObj = document.getElementById('DELStage2H');	

	if(maxBabyDateObj == null || maxBabyTimeObj == null || dilationDateObj == null || dilationTimeObj == null || stage2Obj == null || stage2HObj == null)
		return;
	
	if(maxBabyDateObj.value == "" || maxBabyTimeObj.value == "" || dilationDateObj.value == "" || dilationTimeObj.value == ""){
		stage2Obj.value = "";
		stage2HObj.value = "";
		return;
	}
	
	stage2Obj.value = DateTimeDiffInHMStr(dilationDateObj.value, dilationTimeObj.value,maxBabyDateObj.value, maxBabyTimeObj.value);	
	stage2HObj.value = stage2Obj.value;

}

//Calculate Stage3 as Delivery Date Time of last placenta - Birth Date Time of Last Baby.  Display as HH:MM.
function CalcStage3(){
	var maxPlacDateObj = document.getElementById('MaxPlacDate');
	var maxPlacTimeObj = document.getElementById('MaxPlacTime');
	var maxBabyDateObj = document.getElementById('MaxBabyDob');
	var maxBabyTimeObj = document.getElementById('MaxBabyTob');
	var stage3Obj = document.getElementById('DELStage3');	
	var stage3HObj = document.getElementById('DELStage3H');	

	if(maxBabyDateObj == null || maxBabyTimeObj == null || maxPlacDateObj == null || maxPlacTimeObj == null || stage3Obj == null || stage3HObj == null)
		return;
	
	if(maxPlacDateObj.value == "" || maxPlacTimeObj.value == "" || maxBabyDateObj.value == "" || maxBabyTimeObj.value == ""){
		stage3Obj.value = "";
		stage3HObj.value = "";
		return;
	}
	
	stage3Obj.value = DateTimeDiffInHMStr(maxBabyDateObj.value, maxBabyTimeObj.value,maxPlacDateObj.value, maxPlacTimeObj.value);	
	stage3HObj.value = stage3Obj.value;
}

//Calculate Stage3 as Delivery Date Time of last placenta - Laour Onset Date Time.  Display as HH:MM.
function CalcTotalLabour(){
	var onsetDateObj = document.getElementById('DELLabourOnsetDate');
	var onsetTimeObj = document.getElementById('DELLabourOnsetTime');
	var maxPlacDateObj = document.getElementById('MaxPlacDate');
	var maxPlacTimeObj = document.getElementById('MaxPlacTime');
	var totalObj = document.getElementById('DELTotalDuration');	
	var totalHObj = document.getElementById('DELTotalDurationH');	

	if(onsetDateObj == null || onsetTimeObj == null || maxPlacDateObj == null || maxPlacTimeObj == null || totalObj == null || totalHObj == null)
		return;
	
	if(onsetDateObj.value == "" || onsetTimeObj.value == "" || maxPlacDateObj.value == "" || maxPlacTimeObj.value == ""){
		totalObj.value = "";
		totalHObj.value = "";
		return;
	}
	
	totalObj.value = DateTimeDiffInHMStr(onsetDateObj.value, onsetTimeObj.value, maxPlacDateObj.value, maxPlacTimeObj.value);	
	totalHObj.value = totalObj.value;
}


//This function is called by the OnAfterSave UDF of PAPregDelivery.  This will prompt a message to the user and sets TOVERRIDE.
//Also sets a hidden field depending on if the user chooses Yes or No.
function PromptPreAdmsDelete(txt) { 
	frm.TOVERRIDE.value='1'; 
	preads = txt.replace("^","\n");	
        if (confirm(t['PROMPT_PREADM_DEL'] + "\n" + preads)) { 
                //set hidden flag 
		var obj = document.getElementById('DeletePreAdmsFlag');
		if (obj){
			obj.value = "1";
		}
        } 
	else{
		var obj = document.getElementById('DeletePreAdmsFlag');
		if (obj){
			obj.value = "";
		}
	}
} 

function UpdateAll() {
	
        //var PluralityCount=document.getElementById("PluralityCount").value;
	//if (PluralityCount==""){
	//  alert("请录入胎数!")
	//  return false;
	//}
	var Gravida=document.getElementById('Gravida');
    if ((Gravida)&&(Gravida.value=="")){
	    alert("请录入孕次!") 
        return false;
    }
	var Para=document.getElementById('Para');
	if ((Para)&&(Para.value=="")){
	    alert("请录入产次!") 
        return false;
    }
	if(checkMandatoryFields()) {
		UpdateIndIndctrs();
		UpdateLabDelCompl();
		UpdateTearLoc();
		UpdatePuerp();
		UpdateAugMth();
		UpdateIndMth();
		UpdatePreCompl();

		//set Updated flag to true b/c attempting to update once now
		var obj=document.getElementById('Updated');
		if (obj){
			if(obj.value == "0") obj.value = "1";
		}
		//xuqy 090108 begin
		//var obj=document.getElementById("DelDrugItem");
		//var DelDrugItem=getitem(obj);

		var DelDrugItem=getListData("DelDrugItem");
		//手术
		var DelOPType=getListData("DelOPType");   //20090817
		var DelOpTypeValue=getListData("DelOPType").replace(/\^/g,"||");
		
		var PatientID=document.getElementById('PatientID').value;
        var objGravida=document.getElementById('Gravida')
        if (objGravida) var Gravida=objGravida.value;
        else var Gravida="";
		var objPara=document.getElementById('Para');
		if (objPara) var Para=objPara.value;
		else var Para="";
		var setGravida=document.getElementById("setGravida").value;
        var delID=document.getElementById('ID').value;
		if(delID==''){
			update1_click();
			var EpisodeID=document.getElementById('EpisodeID').value;
			delID=tkMakeServerCall("web.DHCPADelivery","getDelID",EpisodeID)
		}
        var objDELCollBloodLoss=document.getElementById('DELCollBloodLoss');
        if (objDELCollBloodLoss) var DELCollBloodLoss=objDELCollBloodLoss.value;
        else  var DELCollBloodLoss="";
        var objDELEstiBloodLoss=document.getElementById('DELEstiBloodLoss');
        if (objDELEstiBloodLoss) var DELEstiBloodLoss=objDELEstiBloodLoss.value;
        else  var DELEstiBloodLoss="";
        var objDel1HourPulse=document.getElementById('Del1HourPulse');
        if (objDel1HourPulse) var Del1HourPulse=objDel1HourPulse.value;
        else  var Del1HourPulse="";
        var objDel1HourBPDiastolic=document.getElementById('Del1HourBPDiastolic');
        if (objDel1HourBPDiastolic) var Del1HourBPDiastolic=objDel1HourBPDiastolic.value;
        else var Del1HourBPDiastolic="";
        var objDel1HourBPSystolic=document.getElementById('Del1HourBPSystolic');
        if (objDel1HourBPSystolic) var Del1HourBPSystolic=objDel1HourBPSystolic.value;
        else var Del1HourBPSystolic="";  
        var objDel1HourBloodLoss=document.getElementById('Del1HourBloodLoss');
        if (objDel1HourBloodLoss) var Del1HourBloodLoss=objDel1HourBloodLoss.value;
        else var Del1HourBloodLoss=""; 
        var objDelCervix=document.getElementById('DelCervix');
        if (objDelCervix) var DelCervix=objDelCervix.value;
        else var DelCervix=""; 
        var objDELNote=document.getElementById('DELNote');
        if (objDELNote) var DELNote=objDELNote.value;
        else var DELNote="";
        var objDELDiagnose=document.getElementById('DELDiagnose');
        if (objDELDiagnose) var DELDiagnose=objDELDiagnose.value;
        else var DELDiagnose="";
        var objPuerperiumAttention=document.getElementById('PuerperiumAttention');
        if (objPuerperiumAttention) var PuerperiumAttention=objPuerperiumAttention.value;
        else var PuerperiumAttention="";
        var objDELSuture=document.getElementById('DELSuture');
        if (objDELSuture) var DELSuture=objDELSuture.value;
        else var DELSuture="";
        var Indicators=getListData("Indicators");
        var objIndictDesc=document.getElementById('IndictDesc')
        if (objIndictDesc) var IndictDesc=objIndictDesc.value;
        else var IndictDesc="";
        Del1HourFundus=document.getElementById('Del1HourFundus').value;
		if(FundusID=="")
		FundusID=Del1HourFundus;
        var DelStr=stage2HtID+"^"+stage3HtID+"^"+DELCollBloodLoss+"^"+DELEstiBloodLoss+"^"+Del1HourPulse+"^"+Del1HourBPDiastolic+"^"+Del1HourBPSystolic+"^"
		DelStr+=FundusID+"^"+Del1HourBloodLoss+"^"+DelCervix+"^"+DELNote+"^"+DELDiagnose+"^"+PuerperiumAttention
            DelStr=DelStr+"^"+AnaDrugID+"^"+AnaMethodID+"^"+DELSuture+"^"+IndictDesc+"^"+DelOpTypeValue
        //alert(PatientID+"@"+Gravida+"@"+Para+"@"+delID+"@"+DelStr+"@"+DelDrugItem+"@"+Indicators)
        var str=cspRunServerMethod(setGravida,PatientID,Gravida,Para,delID,DelStr,DelDrugItem,Indicators); 
        //xuqy 090108 end
		return update1_click();

	}
	return false;
}

function getListData(elementName)
{
	var retString
	retString=""
	var listObj=document.getElementById(elementName);
	if(listObj){
	for (var i=0;i<listObj.options.length;i++)
   	{
	   if (listObj.options[i].value!="")
	   {
		   if(retString==""){
			   retString=listObj.options[i].value
		   }else{
			   retString=retString+"^"+listObj.options[i].value
		   }
	   }
	}
	}
	return retString
}


function getitem(selbox)
{
      var tmpList=new Array();
        for ( var i=0;i<selbox.options.length;i++)
		{   
			tmpList[tmpList.length]=selbox.options[i].value
		}
		//if (tmpList[0]=="") tmpList=tmpList.slice(1)
		var Str=tmpList.join("^");
  return Str
}

function checkMandatoryFields(){
	//Check Labour Method dependant fields.
	var lmObj = document.getElementById('HLabourMethodType');
	if(lmObj){
		var ldateObj= document.getElementById('DELLabourOnsetDate');
		var ltimeObj= document.getElementById('DELLabourOnsetTime');
		var idateObj= document.getElementById('DELDateOfInduction');
		var itimeObj= document.getElementById('DELTimeOfInduction');
		var amethObj= document.getElementById('AUGMTHEntered');
		var imethObj= document.getElementById('INDMTHEntered');
		var iindObj= document.getElementById('INDINDCTREntered');

		//If Labour Onset is Augmented or Induced, then Labour Onset Date/Time
		//and Induction/Augmentation Date/Time are mandatory.
		if(lmObj.value=="A" || lmObj.value=="S" || lmObj.value=="I"){
			if(ldateObj && ldateObj.value==""){
				alert(t[ldateObj.id] + " " + t['XMISSING']);
				websys_setfocus(ldateObj.id);
				return false;
			}
			if(ltimeObj && ltimeObj.value==""){
				alert(t[ltimeObj.id] + " " + t['XMISSING']);
				websys_setfocus(ltimeObj.id);
				return false;
			}
		}

		//If Labour Onset is Augmented, Augmentation Methods is mandatory
		if(lmObj.value=="A"){
			if(idateObj && idateObj.value==""){
				alert(t[idateObj.id] + " " + t['XMISSING']);
				websys_setfocus(idateObj.id);
				return false;
			}
			if(itimeObj && itimeObj.value==""){
				alert(t[itimeObj.id] + " " + t['XMISSING']);
				websys_setfocus(itimeObj.id);
				return false;
			}
			if(amethObj && amethObj.options.length==0){
				alert(t[amethObj.id] + " " + t['XMISSING']);
				websys_setfocus('AUGMTHDesc');
				return false;
			}
		}

		//If Labour Onset is Induced, Induction Methods, Induction Indicators are mandatory.
		if(lmObj.value=="I"){
			if(idateObj && idateObj.value==""){
				alert(t[idateObj.id] + " " + t['XMISSING']);
				websys_setfocus(idateObj.id);
				return false;
			}
			if(itimeObj && itimeObj.value==""){
				alert(t[itimeObj.id] + " " + t['XMISSING']);
				websys_setfocus(itimeObj.id);
				return false;
			}
			if(imethObj && imethObj.options.length==0){
				alert(t[imethObj.id] + " " + t['XMISSING']);
				websys_setfocus('INDMTHDesc');
				return false;
			}
			if(iindObj && iindObj.options.length==0){
				alert(t[iindObj.id] + " " + t['XMISSING']);
				websys_setfocus('INDINDCTRDesc');
				return false;
			}
		}
	}
	return true;
}


//////////////////////////////////////////// Start Listboxes ///////////////////////////////////////////

//PAPrDelIndIndctrs List
function UpdateIndIndctrs() {
	var arrItems = new Array();
	var lst = document.getElementById("INDINDCTREntered");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			//TN:need to pass description for reloading when update error occurs
			arrItems[j] = lst.options[j].value + String.fromCharCode(2) + lst.options[j].text;
		}
		var el = document.getElementById("INDINDCTRDescString");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
	}
}

//PAPrDelLabDelCompl List
function UpdateLabDelCompl() {
	var arrItems = new Array();
	var lst = document.getElementById("LABDELCOMPLEntered");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			//TN:need to pass description for reloading when update error occurs
			arrItems[j] = lst.options[j].value + String.fromCharCode(2) + lst.options[j].text;
		}
		var el = document.getElementById("LABDELCOMPLDescString");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
	}
}

//PAPrDelLacerations List
function UpdateTearLoc() {
	var arrItems = new Array();
	var lst = document.getElementById("TEARLOCEntered");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			//TN:need to pass description for reloading when update error occurs
			arrItems[j] = lst.options[j].value + String.fromCharCode(2) + lst.options[j].text;
		}
		var el = document.getElementById("TEARLOCDescString");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
	}
}

//PAPrDelPuerpCompl List
function UpdatePuerp() {
	var arrItems = new Array();
	var lst = document.getElementById("PuerpEntered");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			//TN:need to pass description for reloading when update error occurs
			arrItems[j] = lst.options[j].value + String.fromCharCode(2) + lst.options[j].text;
		}
		var el = document.getElementById("PuerpDescString");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
	}
}

//PAPrDelAugMethods List
function UpdateAugMth() {
	var arrItems = new Array();
	var lst = document.getElementById("AUGMTHEntered");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			//TN:need to pass description for reloading when update error occurs
			arrItems[j] = lst.options[j].value + String.fromCharCode(2) + lst.options[j].text;
		}
		var el = document.getElementById("AUGMTHDescString");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
	}
}


//PAPrDelIndMethods List
function UpdateIndMth() {
	var arrItems = new Array();
	var lst = document.getElementById("INDMTHEntered");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			//TN:need to pass description for reloading when update error occurs
			arrItems[j] = lst.options[j].value + String.fromCharCode(2) + lst.options[j].text;
		}
		var el = document.getElementById("INDMTHDescString");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
	}
}

//PAPregAntenatalCompl List
function UpdatePreCompl() {
	var arrItems = new Array();
	var lst = document.getElementById("PRECOMPLEntered");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			//TN:need to pass description for reloading when update error occurs
			arrItems[j] = lst.options[j].value + String.fromCharCode(2) + lst.options[j].text;
		}
		var el = document.getElementById("PRECOMPLDescString");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
	}
}


function DeleteClickHandler() {
	var EpisodeID=document.getElementById('EpisodeID').value;
	var ifHasBabyOrder=tkMakeServerCall("web.PAPregDelivery","ifHasOrder",EpisodeID);
	if(ifHasBabyOrder=="1") {
		alert("婴儿已经有医嘱,无法删除!");
		return false;
	}
	//Log 49176 Chandana 9/2/05 - If babies exists, give a warning before deleting.
	var maxBabyObj = document.getElementById("MaxBabyNo");
	var msg=t['Delete_Dtl'];
	if(maxBabyObj && maxBabyObj.value > 0) msg = t['Delete_Babies'];
	if(!confirm(msg)) return false;

	//Delete items from PAPrDelIndIndctrsList listbox when a "Delete" button is clicked.
	var obj=document.getElementById("INDINDCTREntered")
	if (obj) RemoveFromList(obj);
	var obj=document.getElementById("LABDELCOMPLEntered")
	if (obj) RemoveFromList(obj);
	var obj=document.getElementById("PuerpEntered")
	if (obj) RemoveFromList(obj);
	var obj=document.getElementById("TEARLOCEntered")
	if (obj) RemoveFromList(obj);
	var obj=document.getElementById("AUGMTHEntered")
	if (obj) RemoveFromList(obj);
	var obj=document.getElementById("INDMTHEntered")
	if (obj) RemoveFromList(obj);
	var obj=document.getElementById("PRECOMPLEntered")
	if (obj) RemoveFromList(obj);
	var obj=document.getElementById("ID")
	if (obj) var DELID=obj.value;
	else var DELID="";
	var objDeletePregDelivery=document.getElementById("DeletePregDelivery");
	if (objDeletePregDelivery){
		var str=cspRunServerMethod(objDeletePregDelivery.value,DELID);
		if (str!=0){alert(str);return false;}
	}
	return true;
}

function IndIndctrDeleteClickHandler() {
	//Delete items from INDINDCTREntered listbox when a "Delete" button is clicked.

	var obj=document.getElementById("INDINDCTREntered")
	if (obj)
		RemoveFromList(obj);
	return false;
}

function LabDelComplDeleteClickHandler() {
	//Delete items from LABDELCOMPLEntered listbox when a "Delete" button is clicked.

	var obj=document.getElementById("LABDELCOMPLEntered")
	if (obj)
		RemoveFromList(obj);
	return false;
}

function TearLocDeleteClickHandler() {
	//Delete items from TEARLOCEntered listbox when a "Delete" button is clicked.

	var obj=document.getElementById("TEARLOCEntered")
	if (obj)
		RemoveFromList(obj);
	return false;
}

function PuerpDeleteClickHandler() {
	//Delete items from PuerpEntered listbox when a "Delete" button is clicked.

	var obj=document.getElementById("PuerpEntered")
	if (obj)
		RemoveFromList(obj);
	return false;
}

function AugMthDeleteClickHandler() {
	//Delete items from AUGMTHEntered listbox when a "Delete" button is clicked.

	var obj=document.getElementById("AUGMTHEntered")
	if (obj)
		RemoveFromList(obj);
	return false;
}

function IndMthDeleteClickHandler() {
	//Delete items from INDMTHEntered listbox when a "Delete" button is clicked.

	var obj=document.getElementById("INDMTHEntered")
	if (obj)
		RemoveFromList(obj);
	return false;
}

function PreComplDeleteClickHandler() {
	//Delete items from PRECOMPLEntered listbox when a "Delete" button is clicked.

	var obj=document.getElementById("PRECOMPLEntered")
	if (obj)
		RemoveFromList(obj);
	return false;
}

function IndIndctrsLookupSelect(txt) {
	//Add an item to PAPrDelIndIndctrsList when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	var obj=document.getElementById("INDINDCTREntered")

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("Induction Indicator has already been selected");
				var obj=document.getElementById("INDINDCTRDesc")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert("Induction Indicator has already been selected");
				var obj=document.getElementById("INDINDCTRDesc")
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("INDINDCTRDesc")
	if (obj) obj.value="";
}

function LabDelComplLookupSelect(txt) {
	//Add an item to PAPrDelLabDelComplList when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	var obj=document.getElementById("LABDELCOMPLEntered")

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("Labour & Delivery complication has already been selected");
				var obj=document.getElementById("LABDELCOMPLDesc")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert("Labour & Delivery complication has already been selected");
				var obj=document.getElementById("LABDELCOMPLDesc")
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("LABDELCOMPLDesc")
	if (obj) obj.value="";
}

function TearLocLookupSelect(txt) {
	//Add an item to PAPrDelLacerations when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	var obj=document.getElementById("TEARLOCEntered")

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("Laceration has already been selected");
				var obj=document.getElementById("TEARLOCDesc")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert("Laceration has already been selected");
				var obj=document.getElementById("TEARLOCDesc")
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("TEARLOCDesc")
	if (obj) obj.value="";
}

function PuerpLookupSelect(txt) {
	//Add an item to PAPrDelPuerpCompl when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	var obj=document.getElementById("PuerpEntered")

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("Puerperium Complication has already been selected");
				var obj=document.getElementById("PUERPDesc")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert("Puerperium Complication has already been selected");
				var obj=document.getElementById("PUERPDesc")
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("PUERPDesc")
	if (obj) obj.value="";
}

function AugMthLookupSelect(txt) {
	//Add an item to PAPrDelAugMethods when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	var obj=document.getElementById("AUGMTHEntered")

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("Augmentation method has already been selected");
				var obj=document.getElementById("AUGMTHDesc")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert("Augmentation method has already been selected");
				var obj=document.getElementById("AUGMTHDesc")
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("AUGMTHDesc")
	if (obj) obj.value="";
}

function IndMthLookupSelect(txt) {
	//Add an item to PAPrDelIndMethods when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	var obj=document.getElementById("INDMTHEntered")

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("Induction method has already been selected");
				var obj=document.getElementById("INDMTHDesc")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert("Induction method has already been selected");
				var obj=document.getElementById("INDMTHDesc")
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("INDMTHDesc")
	if (obj) obj.value="";
}

function PreComplLookupSelect(txt) {
	//Add an item to PAPregAntenatalCompl when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	var obj=document.getElementById("PRECOMPLEntered")

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("Antenatal Complication has already been selected");
				var obj=document.getElementById("PRECOMPLDesc")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert("Antenatal Complication has already been selected");
				var obj=document.getElementById("PRECOMPLDesc")
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("PRECOMPLDesc")
	if (obj) obj.value="";
}

function AddItemToList(list,code,desc) {
	//Add an item to a listbox
	//alert("in list " + list.name + " code " + code + " desc " + desc);
	code=String.fromCharCode(2)+code
	list.options[list.options.length] = new Option(desc,code);
}

function AddItemToList_Reload(list,code,desc) {
	//Add an item to a listbox
	list.options[list.options.length] = new Option(desc,code);
}

function RemoveFromList(obj) {
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
		obj.options[i]=null;
	}

}

function RemoveAllFromList(obj){
	for (var i=(obj.length-1); i>=0; i--) {
		obj.options[i]=null;
	}

}

//TN: reload listboxes with values in hidded fields.
//this is due to page being refreshed upon error message (such as invalid pin)
function ReloadListBoxes() {
	ListboxReload("INDINDCTRDescString", "INDINDCTREntered");
	ListboxReload("LABDELCOMPLDescString", "LABDELCOMPLEntered");
	ListboxReload("TEARLOCDescString", "TEARLOCEntered");
	ListboxReload("PuerpDescString", "PuerpEntered");
	ListboxReload("AUGMTHDescString", "AUGMTHEntered");
	ListboxReload("INDMTHDescString", "INDMTHEntered");
	ListboxReload("PRECOMPLDescString", "PRECOMPLEntered");
}

function ListboxReload(strName, lstName) {
	var el = document.getElementById(strName);
	var lst = document.getElementById(lstName);
	var updated = document.getElementById("Updated");
	//don't execute this when page loads for the first time b/c first time values come from db, 
	//execute for subsequent reloads (such as on error condition).
	if ((lst) && (el) && (updated.value == "1")) {
		RemoveAllFromList(lst);
		if(el.value != ""){
			var arrITEM=el.value.split(String.fromCharCode(1));
			for (var i=0; i<arrITEM.length; i++) {
				var arrITEMVAL=arrITEM[i].split(String.fromCharCode(2));
				AddItemToList_Reload(lst,arrITEMVAL[0]+String.fromCharCode(2)+arrITEMVAL[1],arrITEMVAL[2]);
			}
		}
	}
}



//TN: call this outside onload call so it can be called straight away, and not wait till everything has loaded.

ReloadListBoxes();
//////////////////////////////////////////// End Listboxes ///////////////////////////////////////////

document.body.onload=Init;
