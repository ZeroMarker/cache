var currRow; 
var refreason ;
var refreasonDesc ;
function BodyLoadHandler()
{
	var obj=document.getElementById("OK")
	if (obj) obj.onclick=RetVal;
	
	var obj=document.getElementById("Cancel")
	if (obj) obj.onclick=Cancel;
}
	
function Cancel()
{ 
    window.returnValue=""
    window.close();
}

	
function SelectRowHandler()
{
	
   if (currRow>0)
    var obj=document.getElementById("TSelect"+"z"+currRow)
    if (obj) {obj.checked=false}
	currRow=selectedRow(window)
	if (currRow>0){
	    var obj=document.getElementById("TRowid"+"z"+currRow)
	    if (obj) 
	     {refreason=obj.value; }
	     //refuse reason description
	    var obj3=document.getElementById("TReasonDesc"+"z"+currRow)
	    if (obj3) 
	     {refreasonDesc=obj3.innerText; }
	    var obj2=document.getElementById("TSelect"+"z"+currRow)
	    if (obj2) 
	     {obj2.checked=true; }
	  }
	   
}


function RetVal()
{
	var rowid="" ,refreasonDesc=""
	if (!currRow){
		alert("请选择原因!")
		return;
	}
	var objselect=document.getElementById("TSelect"+"z"+currRow)
	if (objselect.checked)
	{
		var obj=document.getElementById("TRowid"+"z"+currRow)
		if (obj) var rowid=obj.value;
		
		var obj3=document.getElementById("TReasonDesc"+"z"+currRow)
	    if (obj3) {refreasonDesc=obj3.innerText; }
	}
	if (rowid==""){
		alert("请选择原因!")
		return;
	}
	 
	window.returnValue=rowid+"^"+refreasonDesc

	window.close();
}
	
	
/*
function SetRefuse()
{  
   var maindocu=window.opener.document
  
   var mainrow;
	if (maindocu) {
	  	var objtbl=maindocu.getElementById("t"+"dhcpha_phadisp")
	  
		//mainrow=selectedRow(window.opener)
	    var obj=document.getElementById("MainRow")
	    if (obj) var mainrow=obj.value;
	    
	    //--单个医嘱 如控制制关联医嘱则注释
	    /*
	    if (mainrow>0)
	    {
		    var obj=maindocu.getElementById("TRefuseReason"+"z"+mainrow)
            if (obj) obj.value=refreason  ;
            //alert(obj.value); 
            //set refuse reason description
		    var obj=maindocu.getElementById("TRefuseReasonDesc"+"z"+mainrow)
            if (obj) obj.innerText=refreasonDesc   ;
            var r=parseInt(mainrow)
             for  (var h=1;h<=objtbl.cells.length; h++)
            {  
              if (objtbl.rows(r).cells(h))
              {objtbl.rows(r).cells(h).style.backgroundColor="#ffc0c0";} 
               }
              
        }
        */
        
        // ---控制关联医嘱
      /*
	    var rowstr=mainrow.split("^");
	    var rowcnt=rowstr[0]
	   
	    if (rowcnt>0)
	    {
		    for (var i=1;i<=rowcnt;i++)
		    {
			     
			    var obj=maindocu.getElementById("TRefuseReason"+"z"+rowstr[i])
	            if (obj) obj.value=refreason  ;
			    var obj=maindocu.getElementById("TRefuseReasonDesc"+"z"+rowstr[i])
	            if (obj) obj.innerText=refreasonDesc   ;
	            
	            var r=parseInt(rowstr[i])
	            
	            for  (var h=1;h<=objtbl.cells.length; h++)
		            {    
		              if (objtbl.rows(r).cells(h))
		              {objtbl.rows(r).cells(h).style.backgroundColor="#ffc0c0";} 
		            }
            
            
            
            } 
                    
        }
        // ---
        
 //   }
 //   */
 //  window.close();
//}

	

/*
function SelectRowHandler()
{
//	var obj=document.getElementById("t"+"dhcpha_setdrugrefusereason")
//	if (obj) 
//	
    if (currRow>0)
    var obj=document.getElementById("TSelect"+"z"+currRow)
    if (obj) {obj.checked=false}
	currRow=selectedRow(window)
	if (currRow>0){
	    var obj=document.getElementById("TRowid"+"z"+currRow)
	    if (obj) 
	     {refreason=obj.value; }
	     //refuse reason description
	    var obj3=document.getElementById("TReasonDesc"+"z"+currRow)
	    if (obj3) 
	     {refreasonDesc=obj3.innerText; }
	    var obj2=document.getElementById("TSelect"+"z"+currRow)
	    if (obj2) 
	     {obj2.checked=true; }
	  }   
}
function Cancel()
{ 
	refreason ="" ;
	refreasonDesc ="" ;
    window.close();
}

function Ok()
{
	window.close();
}
document.body.onbeforeunload=function(){

	 SetRefuse()
	 
}

*/
document.body.onload=BodyLoadHandler;

