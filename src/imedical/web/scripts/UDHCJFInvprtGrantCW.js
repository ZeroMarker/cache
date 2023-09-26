
function BodyLoadHandler() {
//	websys_setTitleBar("OutPatient  Registeration");

	var obj=document.getElementById('Add');
	if (obj) obj.onclick = Add_Click;
	var numobj=document.getElementById('number');
	if (numobj) numobj.onkeyup = celendno;
	var typeobj=document.getElementById('type');
	if (typeobj) typeobj.readOnly=true;
	var lquserobj=document.getElementById('lquser');
	if (lquserobj) lquserobj.readOnly=true;
    var numobj=document.getElementById('num');
	if (numobj) numobj.onkeyup = celendno;
    document.getElementById('Startno').readOnly=true;
    getinvgrantmax()

//	websys_setfocus('RegNo');

}

function getinvgrantmax(){
	var typeobj=document.getElementById('type');
	
	if (typeobj) p1=typeobj.value
	if (p1=="") return;
	//alert(p1)
	//p1="I"
	var getstartno=document.getElementById('getstartno');
	if (getstartno) {var encmeth=getstartno.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'setstartno_val','',p1)=='1'){
		};
	}

function setstartno_val(value){
	var val=value.split("^")
	if (val[3]=="") {
		var maxno=document.getElementById('maxno');
		if (maxno) {maxno.value="";
				maxno.readOnly=true;
				}
		var startno=document.getElementById('startno');
		if (startno) startno.value="";
		alert(t['01']);
		return;
		}
	var startno=document.getElementById('startno');
	startno.value=val[2];
	var maxno=document.getElementById('maxno');
	if (maxno) {maxno.value=val[1];
				maxno.readOnly=true;
				}
	if (val[2]=="") {websys_setfocus('startno');}
	else
	{websys_setfocus('endno');}
	
	}	
function Add_Click(){
	 var stnoobj=document.getElementById('startno');
	 if (stnoobj) var startno=stnoobj.value;
	 var endnoobj=document.getElementById('endno');
	 if (endnoobj) var endno=endnoobj.value;
	 var maxno=document.getElementById('maxno');
	if (maxno) var buyend=maxno.value;
	var lquserobj=document.getElementById('lquser');
	 if (lquserobj) var lquser=lquserobj.value;
	 var lquseridobj=document.getElementById('lquserid');
	 if (lquseridobj) var lquserid=lquseridobj.value;
	 var typeobj=document.getElementById('type');
	 if (typeobj) var type=typeobj.value;
	  
//	  var userid=buyuser;
	  var useflag=""
	  if (buyend=="") {
		alert(t['01']);
		return;
		}
	  if (type==""){
		  alert(t['03']);
		 websys_setfocus('type');
		 return false;
		  }
	  if (startno==""||endno=="") {
		alert(t['04']);
		 websys_setfocus('endno');
	   return false;
	  }
	  if (!checkno(startno)) {
		  alert(t['05']); 
		  websys_setfocus('startno');
		  return false;
		  }
	  if (!checkno(endno)) {
		  alert(t['06']);
	      websys_setfocus('endno');
		  return false;
	       }
	 if (parseInt(endno,10)<parseInt(startno,10))
	 {alert(t['07']);
	       websys_setfocus('endno');
		  return false;
		 } 
	 if (endno.length!=startno.length)
	 {alert(t['08']);
	       websys_setfocus('endno');
		  return false;
		 } 
	 if (parseInt(endno,10)>parseInt(buyend,10))
	       {
		       var tmpstrmsg=t['09']+buyend+t['10']
		       alert(tmpstrmsg);
	      websys_setfocus('endno');
		   return false;
		   }
	  if (lquser==""){
		  alert(t['11']);
		 websys_setfocus('lquser');
		 return false;
		  }
	  var tmpstrmsg=t['12']+startno+t['13']+endno+t['14']	  
	  var truthBeTold = window.confirm(tmpstrmsg);
     if (truthBeTold) {
	   // var userobj=document.getElementById('userid');
	   // if (userobj) var userid=userobj.value
        var str="^"+startno+"^"+endno+"^"+lquserid+"^"+buyend+"^"+type
      //  var str="^^"+type+"^"+buyuser+"^^"+startno+"^"+endno+"^^"+userid+"^^"+useflag
        var err="";
 		p1=str
 		var getadd=document.getElementById('getadd');
		if (getadd) {var encmeth=getadd.value} else {var encmeth=''};
		//alert(encmeth)
		if (cspRunServerMethod(encmeth,'addok','',p1)=='1'){
		//	alert("ok");
		};
       }
	}
	function addok(value)
	{//alert(value)
		if (value==0) {
		var findobj=document.getElementById('Find');
		if (findobj) findobj.click();
	//	window.location.reload();
		}}
	function checkno(inputtext) {
        var checktext="1234567890"
        for (var i = 0; i < inputtext.length; i++) {
            var chr = inputtext.charAt(i);
            var indexnum=checktext.indexOf(chr);
            if (indexnum<0)  return false;
        }
        return true;
    }
    function celendno() {
	    var numobj=document.getElementById('number');
	    if (numobj) var num=numobj.value
	   var snoobj=document.getElementById('startno');
	    if (snoobj) var sno=snoobj.value
	   
	   var ssno=""
	   var ssno1,slen,sslen
	   if (num==""||(parseInt(num,10)==0)) return;
       if (checkno(num)&&(sno!="")&&checkno(sno)) 
       {
	       ssno1=parseInt(sno,10)+parseInt(num,10)-1;
	       ssno=ssno1.toString()
	       slen=sno.length
	       sslen=ssno.length
	       for (i=slen;i>sslen;i--){
	        ssno="0"+ssno
	        }
	        var endnoobj=document.getElementById('endno');
	 if (endnoobj) endnoobj.value=ssno;
	       }
     }
function Find_Click(){}
function getuserid(value)	{
	var user=value.split("^");
	var obj=document.getElementById('lquserid');
	obj.value=user[1];
}
document.body.onload = BodyLoadHandler;