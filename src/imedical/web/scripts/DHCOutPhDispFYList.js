function BodyLoadHandler()
{
}


function SelectRowHandler(){
	
	
	 var eSrc=window.event.srcElement;
	 if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	 var eSrcAry=eSrc.id.split("z");
	 var rowObj=getRow(eSrc);
	 var selectrow=rowObj.rowIndex;
	 if (!selectrow) return;

     var patid="";
     var obj=document.getElementById("tbpatid"+"z"+selectrow)
     if (obj) patid=obj.innerText;
     var objFYType=document.getElementById("FYType").value
     if(objFYType=="1"){
        var docu=parent.frames['DHCOutPatienDisp'].document
     }else{
	    var docu=parent.frames['DHCOutPatienDispFY'].document
     }
	 
	 if (docu){
		 var CPmiNoobj=docu.getElementById("CPmiNo")
		 if (CPmiNoobj) CPmiNoobj.value=patid;
		 var BFindobj=docu.getElementById("BRetrieve")
	 	 if (BFindobj) BFindobj.onclick();
	 }
	 
}

document.body.onload=BodyLoadHandler;