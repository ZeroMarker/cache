
function BodyLoadHandler() {

	var papno=document.getElementById("papno").value
   

    if (papno!=""){
    var getadm=document.getElementById('getadm');
	if (getadm) {var encmeth=getadm.value} else {var encmeth=''};

	      var str=cspRunServerMethod(encmeth,papno)
	      str=str.split("^")
	      var admobj=document.getElementById("Adm");
	      admobj.value=str[0]
	      var nameobj=document.getElementById("name");
	      nameobj.value=str[1]
	      var papnoobj=document.getElementById("papno");
	          papnoobj.value=str[2]
    }
	
	var obj=document.getElementById("papno");
	if (obj) obj.onkeydown=findadm;
	
	websys_setfocus('papno');
}
  
 function findadm(){
	var key=websys_getKey(e);
	if (key==13) {
		var papno=document.getElementById("papno").value
		if (papno!=""){
			 var getadm=document.getElementById('getadm');
	         if (getadm) {var encmeth=getadm.value} else {var encmeth=''};

	          var str=cspRunServerMethod(encmeth,papno)
	          str=str.split("^")
	          var admobj=document.getElementById("Adm");
	          admobj.value=str[0]
	          var nameobj=document.getElementById("name");
	          nameobj.value=str[1]
			  var papnoobj=document.getElementById("papno");
	          papnoobj.value=str[2]
			 }
		//	Find_click();
	}
		 
 }
			   
document.body.onload = BodyLoadHandler;	

