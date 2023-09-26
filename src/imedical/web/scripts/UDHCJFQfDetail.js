var Adm
var regno
var regnoobj,BillNo
var patid
function BodyLoadHandler() {
	regnoobj=document.getElementById('regno')
	regnoobj.onkeydown=getpat
	var obj=document.getElementById('Adm')
	if(obj){Adm=obj.value}
	if (Adm!="") {
	  getpatinfro()
	}
    var obj=document.getElementById('BillNo')
	if(obj){BillNo=obj.value}
	if (BillNo!=""){
	    getfeeinfro()	
		}
    var obj=document.getElementById('add')
    if (obj){
	    obj.onclick=Add_click}
	var obj=document.getElementById('print')
    if (obj){
	    obj.onclick=Print_click}
	    
}
function getpat(){
   var key=websys_getKey(e);
   if (key==13) {
      
   }
}
function Add_click(){
	var remain1=document.getElementById('remain1').value
	var remain2=document.getElementById('remain2').value
	if ((remain1!="")||(remain2!="")){
		var add=document.getElementById('addin')
		if (add) {var encmeth=add.value} else {var encmeth=''};
		   
	      var str0=cspRunServerMethod(encmeth,remain1,remain2,Adm)
	      var str=0
	      if (str0.indexOf("^")!=-1){
		      var data=str0.split("^")
		      str=data[0]}
	      if (str=="1"){
		      window.opener.document.getElementById("reflag").value="1"
		      window.opener.document.getElementById("qfjob").value=data[1]
		      window.opener.document.getElementById("Add").onclick
		       window.close()
		      }
		   else {
			   alert(t['01']);
			   return;
			     } 
		     }
	 else {
		 alert(t['01']);
			   return;
		 }
	
	}

function setinfro(patid)
{   
    getpatinfro(patid)
    getfeeinfro(patid)
}
function getpatinfro(){
	if (Adm=="") return;
	var patinfo=document.getElementById('patinfo');
	if (patinfo) {var encmeth=patinfo.value} else {var encmeth=''};	   
	var str=cspRunServerMethod(encmeth,Adm)
	if (str=="") return;
	str=str.split("^")
	var obj=document.getElementById('name')
	obj.value=str[5]
	var obj=document.getElementById('sex')
	obj.value=str[19]
	var obj=document.getElementById('age')
	obj.value=str[16]
	var obj=document.getElementById('birthday')
	obj.value=str[17]
	var obj=document.getElementById('paperid')
	obj.value=str[20]
	var obj=document.getElementById('ForeignId')
	obj.value=str[30]
	var obj=document.getElementById('company')
	obj.value=str[11]
	var obj=document.getElementById('worktel')
	obj.value=str[27]
	var obj=document.getElementById('address')
	obj.value=str[29]
	var obj=document.getElementById('zipcode')
	obj.value=str[25]
	var obj=document.getElementById('hometel')
	obj.value=str[26]
	var obj=document.getElementById('medicare')
	obj.value=str[18]
	var obj=document.getElementById('regno')
	obj.value=str[6]
	var obj=document.getElementById('pattype')
	obj.value=str[7]
	var obj=document.getElementById('ybcardno')
	obj.value=str[1]
	var obj=document.getElementById('admdept')
	obj.value=str[2]
	var obj=document.getElementById('admward')
	obj.value=str[22]
	var obj=document.getElementById('admdoc')
	obj.value=str[23]
	var obj=document.getElementById('admtimes')
	obj.value=str[21]
	var obj=document.getElementById('admdate')
	obj.value=str[0]
	var obj=document.getElementById('dischdate')
	obj.value=str[1]
	
				
	}
function getfeeinfro(){
	if (BillNo=="") return ;
	var feeinfo=document.getElementById('feeinfo');
	if (feeinfo) {var encmeth=feeinfo.value} else {var encmeth=''};		   
	var str=cspRunServerMethod(encmeth,BillNo)
	if (str=="") return;
	str=str.split("##")
	var str1=str[0].split("&")
	var deposit=str[2]
	var totalsum=str[1]
	var qf=str[3]
	var num=str[4]
	var obj=document.getElementById('patfee')
	obj.value=str[1]
	var obj=document.getElementById('deposit')
	obj.value=str[2]
	var obj=document.getElementById('balance')
	obj.value=str[3]
	
	for (i=1;i<=num;i++){
		var str2=str1[i].split("^")
	    var obj1=document.getElementById('cfee'+i)
	    obj1.innerHTML=str2[0]
	     var obj=document.getElementById('fee'+i)
	    obj.value=str2[1]
		
		}

	}
document.body.onload = BodyLoadHandler;	