var Currow;

function BodyLoadHandler()
{
	
  GetALLOrditm(); //��ȡ���е�orditm
  var obj=document.getElementById("Modify")
  if (obj) {obj.onclick=UpdateOrditm}

		
}

function GetALLOrditm()
{
	
	  var obj=document.getElementById("Toeoriz"+1)
	  if (obj) {var str=obj.innerText}
      var xxx
      var xxx=document.getElementById("GetAllOrditm");
	  if (xxx) {var encmeth=xxx.value} else {var encmeth=''};
	  var result=cspRunServerMethod(encmeth,str)  ;
	  if (result==-1)
	  {alert("ȡ������ҽ������Ϣ����err: "+result+",��ȷ��������")
	   reGet();
	   return;}	  
}


function UpdateOrditm()
{
	
	if (!Currow) return;
	if (Currow<1) return
	str=""
	var obj=document.getElementById("Toeoriz"+Currow)
	if (obj) {var str=obj.innerText}
	if (str==""){return;}
	var tmpstr=str.split("@")
	//var orditmrowid=tmpstr[0]
	var pid=tmpstr[2]
	
	var obj=document.getElementById("Tarciz"+Currow)
	if (obj) {var arcim=obj.innerText}
	
	var orditmrowid=""
	var h=0
	do {
	    var zzz
        var zzz=document.getElementById("ListOrditm");
	    if (zzz) {var encmeth=zzz.value} else {var encmeth=''};
		var retoeori=cspRunServerMethod(encmeth,pid,orditmrowid)  ;

		if (retoeori!="")
		{
			var orditmrowid=retoeori;
			//alert(orditmrowid)
			
		    var xxxobj
            var xxxobj=document.getElementById("UpdateOrditm");
	        if (xxxobj) {var encmeth=xxxobj.value} else {var encmeth=''};
	        var result=cspRunServerMethod(encmeth,orditmrowid,arcim)  ;
	        //alert(result)
	        
	        if (result==101){alert("��治��")}
	        if (result==102){alert("����ʧ��")}
	        if (result==103){alert("��ȡҽ��ʧ��")}
	        if (result>0){ orditmrowid=""; return;}
	        
	        
	        h=h+1
		    
		}
		else{orditmrowid=""}
	   } while(orditmrowid!="");
	
        if (h==0){alert("ȡ������ҽ������Ϣ����err: "+h+",��ȷ��������");
            KillTMP();
	        reGet();
        }
        else{
	   	alert("���³ɹ�")
	    KillTMP();
	    reGet();  }
	    
	    
	    
}
	


function reGet()
{
	var maindocu=window.opener.document
    var objfind=maindocu.getElementById("Collect")
    if (objfind){objfind.click()  }
    window.close();
}

function SelectRowHandler()
 {
	Currow=selectedRow(window);

 }

function KillTMP()
{
	   str=""
	   var obj=document.getElementById("Toeoriz"+1)
	   if (obj) {var str=obj.innerText}
	   if (str==""){return;}
	   var tmpstr=str.split("@")
	   //var orditmrowid=tmpstr[0]
	   var pid=tmpstr[2]
       var exe
	   var obj=document.getElementById("KillAfterModifyARCIM")
	   if (obj) {exe=obj.value;} else {exe='';}
	   var sss=cspRunServerMethod(exe,pid)
}













document.body.onload=BodyLoadHandler;