var Currow;

function BodyLoadHandler()
{
	
  GetALLOrditm(); //获取所有的orditm
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
	  {alert("取病区该医嘱项信息有误err: "+result+",点确定后再试")
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
	        
	        if (result==101){alert("库存不足")}
	        if (result==102){alert("更新失败")}
	        if (result==103){alert("获取医嘱失败")}
	        if (result>0){ orditmrowid=""; return;}
	        
	        
	        h=h+1
		    
		}
		else{orditmrowid=""}
	   } while(orditmrowid!="");
	
        if (h==0){alert("取病区该医嘱项信息有误err: "+h+",点确定后再试");
            KillTMP();
	        reGet();
        }
        else{
	   	alert("更新成功")
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