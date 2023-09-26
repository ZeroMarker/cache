var SelectedRow = 0,preRowInd=0;
var ancvcCodeold=0;
function BodyLoadHandler(){
	var obj=document.getElementById('ADD')
	if(obj) obj.onclick=ADD_click;
	var obj=document.getElementById('UPDATE')
	if(obj) obj.onclick=UPDATE_click;
	var obj=document.getElementById('DELETE')
	if(obj) obj.onclick=DELETE_click;
	var obj=document.getElementById('DelAppFlag')
	if(obj) obj.onclick=DelAppFlag_click;
}
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCANCViewCat');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById('Rowid');
	var obj1=document.getElementById('ancvcCode');
    var obj2=document.getElementById('ancvcDesc');
	var obj3=document.getElementById('ancvcVs');
	var obj4=document.getElementById('ancvcOrder');
	var obj5=document.getElementById('ancvcEvent');
	//var obj6=document.getElementById('vpsiteDesc');
	var obj7=document.getElementById('ancvcVPSite');
	//var obj8=document.getElementById('vpsiteDr');
	//var obj9=document.getElementById('lconDr');
	var obj10=document.getElementById('ancvcTherapy');
	var obj11=document.getElementById('ancvcLab');
	var obj12=document.getElementById('ANCVSCDesc');
	var obj13=document.getElementById('ANCVSCId');
	var obj14=document.getElementById('ancvcDisplayByCat');
	var obj15=document.getElementById('ancvcOptions');
	var objSummaryType=document.getElementById('ancvcSummaryType');
	var SelRowObj=document.getElementById('tRowidz'+selectrow);
	var SelRowObj1=document.getElementById('tAncvcCodez'+selectrow);
	var SelRowObj2=document.getElementById('tAncvcDescz'+selectrow);
	var SelRowObj3=document.getElementById('tAncvcVsz'+selectrow);
	var SelRowObj4=document.getElementById('tAncvcOrderz'+selectrow);
	var SelRowObj5=document.getElementById('tAncvcEventz'+selectrow);
	//var SelRowObj6=document.getElementById('tVpsiteDescz'+selectrow);
	var SelRowObj7=document.getElementById('tAncvcVPSitez'+selectrow);
	//var SelRowObj8=document.getElementById('tVpsiteIdz'+selectrow);
	//var SelRowObj9=document.getElementById('tLconIdz'+selectrow);
	var SelRowObj10=document.getElementById('tAncvcTherapyz'+selectrow);
	var SelRowObj11=document.getElementById('tAncvcLabz'+selectrow);	
    var SelRowObj12=document.getElementById('tANCVSCDescz'+selectrow);
    var SelRowObj13=document.getElementById('tANCVSCIdz'+selectrow);
    var SelRowObj14=document.getElementById('tAncvcDisplayByCatz'+selectrow);
     var SelRowObj15=document.getElementById('tOptionsz'+selectrow);
    var SelRowObjSummaryType=document.getElementById('tAncvcSummaryTypez'+selectrow);
    if (preRowInd==selectrow){
	   obj.value=""; 
       obj1.value="";
       obj2.value="";
       obj3.value="";
       obj4.value="";
       obj5.value="";
       //obj6.value="";
       obj7.value="";
       //obj8.value="";
    //   obj9.value=""; 
       obj10.value="";
       obj11.value="";
       obj12.value="";
       obj13.value="";
       obj14.value="";
       obj15.value="";
       if (objSummaryType) objSummaryType.value=""
   		preRowInd=0;
    }
   else{
	   	obj.value=SelRowObj.innerText;
		obj1.value=SelRowObj1.innerText;
		obj2.value=SelRowObj2.innerText;
		obj3.value=SelRowObj3.innerText;
		obj4.value=SelRowObj4.innerText;
		obj5.value=SelRowObj5.innerText;
		//obj6.value=SelRowObj6.innerText;
		obj7.value=SelRowObj7.innerText;
		//obj8.value=SelRowObj8.innerText;
		//obj9.value=SelRowObj9.innerText;
		obj10.value=SelRowObj10.innerText;
		obj11.value=SelRowObj11.innerText;
		obj12.value=SelRowObj12.innerText;
		obj13.value=SelRowObj13.innerText;
		obj14.value=SelRowObj14.innerText;
		obj15.value=SelRowObj15.innerText;

		if (objSummaryType) objSummaryType.value=SelRowObjSummaryType.innerText;
		preRowInd=selectrow;
   }
	obj3.value=obj3.value.replace(" ","");
	obj4.value=obj4.value.replace(" ","");
	obj5.value=obj5.value.replace(" ","");
	//obj6.value=obj6.value.replace(" ","");
	obj7.value=obj7.value.replace(" ","");
	//obj8.value=obj8.value.replace(" ","");
	//obj9.value=obj9.value.replace(" ","");
	obj10.value=obj10.value.replace(" ","");
	obj11.value=obj11.value.replace(" ","");
	obj12.value=obj12.value.replace(" ","");
	obj14.value=obj14.value.replace(" ","");
	obj15.value=obj15.value.replace(" ","");
    ancvcCodeold=SelRowObj1.innerText;
	objSummaryType.value=objSummaryType.value.replace(" ","");
    //alert(ancvcCodeold,"/"+SelRowObj1.innerText);
	SelectedRow=selectrow;
	return;
	}
function ADD_click(){
	var ancvcCode,ancvcDesc,Rerencmeth,ancvcOrder,ancvcVs,ancvcEvent,vpsiteDr,ancvcVPSite,ancvcTherapy,ancvcLab,ANCVSCId,ancvcDisplayByCat,ancvcOptions;
	var IcuApply,ancvcAnApply="",ancvcIcuApply="";
	var obj=document.getElementById('ancvcCode')
	if(obj) ancvcCode=obj.value;
	if(ancvcCode==""){
		alert(t['alert:ancvccodeFill']) 
		return;
		}
	var obj=document.getElementById('ancvcDesc')
	if(obj)  ancvcDesc=obj.value;
	if(ancvcDesc==""){
		alert(t['alert:ancvcdescFill']) 
		return;
		}

	/*var obj=document.getElementById('RepANCViewCat')
	if(obj) Rerencmeth=obj.value;
    var repflag=cspRunServerMethod(Rerencmeth,ancvcCode)
    if(repflag=="Y"){
		alert(t['alert:ANCViewCatrepeat'])
		 return;
		}
    */
    var obj2=document.getElementById('ancvcOrder');
    if(obj2) ancvcOrder=obj2.value;
	var obj3=document.getElementById('ancvcVs');
    if(obj3) ancvcVs=obj3.value; 
    var obj4=document.getElementById('ancvcEvent');
    if(obj4) ancvcEvent=obj4.value;
    //var obj5=document.getElementById('vpsiteDr');
    //if(obj5) vpsiteDr=obj5.value;
    var obj6=document.getElementById('ancvcVPSite');
    if(obj6) ancvcVPSite=obj6.value;
    
    var obj7=document.getElementById('ancvcTherapy');
    if(obj7) ancvcTherapy=obj7.value;
    var obj8=document.getElementById('ancvcLab');
    if(obj8) ancvcLab=obj8.value; 
    var obj9=document.getElementById('IcuApply');
	if (obj9)
	{	 IcuApply=obj9.value;	
		 if(obj9.value=="Y") ancvcIcuApply="Y";
	 	 else ancvcAnApply="Y";
	}
	var ANCVSCId="" 
	var obj10=document.getElementById('ANCVSCId');
    if(obj10) ANCVSCId=obj10.value;  
    if(ANCVSCId=="")
    {
	    alert("请选择显示大类");
	    return;
    }
    var ancvcOptions=""	
  var obj17=document.getElementById('ancvcOptions');
	 if (obj17) var ancvcOptions=obj17.value;//wanghailin modify 20120312
	var obj11=document.getElementById('ancvcDisplayByCat');
    if(obj11) ancvcDisplayByCat=obj11.value;  
    //alert(ancvccode+"^"+ancvcdesc+"^"+ancvcorder+"^"+ancvcvs+"^"+ancvcevent+"^"+vpsiteDr+"^"+ancvcVPSite)
    var ancvcSummaryType=""
    var objSummaryType=document.getElementById('ancvcSummaryType');
    if(objSummaryType) ancvcSummaryType=objSummaryType.value; 	       
	var obj=document.getElementById('InsertANCViewCat')
	if(obj) {
		var encmeth=obj.value;
	    var resStr=cspRunServerMethod(encmeth,ancvcCode, ancvcDesc, ancvcVs, ancvcOrder, ancvcEvent, ancvcVPSite,ancvcTherapy,ancvcLab,ancvcAnApply,ancvcIcuApply,ANCVSCId,ancvcDisplayByCat,ancvcSummaryType,ancvcOptions)
	    if (resStr!='0'){
			alert(t['alert:baulk']);
			return;
			}	
		else  {alert(t['alert:success']);
		location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCANCViewCat&IcuApply="+IcuApply;
		}
	}
}
function UPDATE_click(){
	if (preRowInd<1) return;
	var IcuApply,ancvcAnApply="",ancvcIcuApply="";
	var ancvcCode,ancvcDesc,Rerencmeth,ancvcOrder,ancvcVs,ancvcEvent,vpsiteDr,ancvcVPSite,Rowid,ancvcTherapy,ancvcLab,ANCVSCId,ancvcDisplayByCat,ancvcOptions;
	var obj=document.getElementById('ancvcCode')
	if(obj) ancvcCode=obj.value;
	if(ancvcCode==""){
		alert(t['alert:ancvccodeFill']) 
		return;
		}
	
	var obj=document.getElementById('ancvcDesc')
	if(obj)  ancvcDesc=obj.value;
	if(ancvcDesc==""){
		alert(t['alert:ancvcdescFill']) 
		return;
		}
	//alert(ancvcCodeold+"/"+ancvcCode);
	/*if(ancvcCodeold!=ancvcCode){
	var obj=document.getElementById('RepANCViewCat')
	if(obj) Rerencmeth=obj.value;
    var repflag=cspRunServerMethod(Rerencmeth,ancvcCode)
    if(repflag=="Y"){
		alert(t['alert:ANCViewCatrepeat'])
		 return;
		}
	 }
    */
    var obj1=document.getElementById('Rowid');
    if(obj1) Rowid=obj1.value;
    var obj2=document.getElementById('ancvcOrder');
    if(obj2) ancvcOrder=obj2.value;
	var obj3=document.getElementById('ancvcVs');
    if(obj3) ancvcVs=obj3.value; 
    var obj4=document.getElementById('ancvcEvent');
    if(obj4) ancvcEvent=obj4.value;
    //var obj5=document.getElementById('vpsiteDr');
    //if(obj5) vpsiteDr=obj5.value;
    //var obj6=document.getElementById('lconDr');
    //if(obj6) lconDr=obj6.value;
    //var obj7=document.getElementById('vpsiteDesc');
    //if(obj7) vpsiteDesc=obj7.value;
    var obj8=document.getElementById('ancvcVPSite');
    if(obj8) ancvcVPSite=obj8.value;
    //if (vpsiteDesc=="") vpsiteDr=""
    //if (ancvcVPSite=="") lconDr=""
    var obj9=document.getElementById('ancvcTherapy');
    if(obj9) ancvcTherapy=obj9.value;
    var obj10=document.getElementById('ancvcLab');
    if(obj10) ancvcLab=obj10.value; 
    var obj11=document.getElementById('IcuApply');
	if (obj11)
	 {
		 IcuApply=obj11.value;
		 if(obj11.value=="Y") ancvcIcuApply="Y";
	 	 else ancvcAnApply="Y";
	 }
    var obj12=document.getElementById('ANCVSCId');
    if(obj12) ANCVSCId=obj12.value;  	
    var obj13=document.getElementById('ancvcDisplayByCat');
    if(obj13) ancvcDisplayByCat=obj13.value; 
    var ancvcOptions=""	
    var obj17=document.getElementById('ancvcOptions');
	  if (obj17) var ancvcOptions=obj17.value;//wanghailin modify 20120312       
    var ancvcSummaryType=""
    var objSummaryType=document.getElementById('ancvcSummaryType');
    if(objSummaryType) ancvcSummaryType=objSummaryType.value; 	       
	var obj=document.getElementById('UpdateANCViewCat')
	if(obj) {
		var encmeth=obj.value;
	    var resStr=cspRunServerMethod(encmeth,Rowid , ancvcCode , ancvcDesc, ancvcVs, ancvcOrder , ancvcEvent, ancvcVPSite,ancvcTherapy,ancvcLab,ancvcAnApply,ancvcIcuApply,ANCVSCId,ancvcDisplayByCat,ancvcSummaryType,ancvcOptions);
	    if (resStr!='0'){
			alert(t['alert:baulk']+" "+"Code="+resStr);
			return;
			}	
		else  {alert(t['alert:success']);
		location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCANCViewCat&IcuApply="+IcuApply;
		}
	}
}
function DELETE_click(){
	if (preRowInd<1) return;
	var Rowid,IcuApply;
	var obj=document.getElementById('IcuApply');
	if(obj) IcuApply=obj.value;
	var obj=document.getElementById('Rowid')
	if(obj) Rowid=obj.value;
	if(Rowid==""){
		alert(t['alert:Please Select One']) 
		return;
		}
	var obj=document.getElementById('DeleteANCViewCat')
	if(obj) var encmeth=obj.value;
	var resStr=cspRunServerMethod(encmeth,Rowid)
	if (resStr!='0')
		{alert(t['alert:baulk']);
		return;}	
	else {alert(t['alert:success'])
	  location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCANCViewCat&IcuApply="+IcuApply;
	}
}
function DelAppFlag_click(){
	if (preRowInd<1) return;
	var Rowid,IcuApply,ancvcAnApply="",ancvcIcuApply="";
	var objIcuApply=document.getElementById('IcuApply');
	if (objIcuApply)
	{
		if(objIcuApply.value=="Y") ancvcIcuApply="N";
	 	else ancvcAnApply="N";
	}
	var obj=document.getElementById('Rowid')
	if(obj) Rowid=obj.value;
	if(Rowid==""){
		alert(t['alert:Please Select One']) 
		return;
		}
	var p1=Rowid+"^"+ancvcAnApply+"^"+ancvcIcuApply;
	var obj=document.getElementById('DelVCAppFlag')
	if(obj) var encmeth=obj.value;
	var resStr=cspRunServerMethod(encmeth,p1)
	if (resStr!='0')
		{alert(t['alert:baulk']);
		return;}	
	else {alert(t['alert:success'])
	  location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCANCViewCat&IcuApply="+objIcuApply.value;}
}

function LookUpvpsite(value){
var temp
 temp=value.split("^")
 vpsiteDr=temp[1]
 document.getElementById('vpsiteDr').value=vpsiteDr
}
function LookUplcon(value){
//var temp
// temp=value.split("^")
 //lconDr=temp[1]
//document.getElementById('lconDr').value=lconDr
}
function SetVSC(str)
{
	var obj=str.split("^");
	var Obj=document.getElementById("ANCVSCDesc");
	Obj.value=obj[0];
	var Obj=document.getElementById("ANCVSCId");
	Obj.value=obj[1];	
}			
document.body.onload = BodyLoadHandler;