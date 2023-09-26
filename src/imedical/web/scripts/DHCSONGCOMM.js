alert("d");

	
function  BodyLoadHandler(){
	
	(document.getElementById("RegonNo")).onkeydown=evaluateName;
	(document.getElementById("find")).onclick=evaluatePatmasinf
  }
function evaluateName(){
   if(window.event.keyCode==13){
  var RegonNo=document.getElementById("RegonNo").value;
  
  var hidevalue=document.getElementById("HGetPatName").value;


  var PatName =cspRunServerMethod(hidevalue,RegonNo)
 
   
   
   document.getElementById("PatName").value=PatName
  
   }
}

function evaluatePatmasinf(){
	
	var patmasinf =(document.getElementById("patmasinf")).value;//获取到patmasinf的rowid
	
	     alert(patmasinf)
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCSUNGETBILLCOMMNET&patmasinf='+patmasinf
         window.open(str,'_blank','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1000,height=700,left=0,top=0')
	}

document.onload = BodyLoadHandler();	