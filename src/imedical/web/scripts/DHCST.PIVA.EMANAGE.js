var CurrentRow;
function BodyLoadHandler()
{
	obj=document.getElementById("tAdd") ;
    if (obj) obj.onclick=AddClick;
    
    obj=document.getElementById("tQuery") ;
    if (obj) obj.onclick=tQuery_click;

    obj=document.getElementById("tStart") ;
    if (obj) obj.onclick=StartClick;
    
    obj=document.getElementById("tStop") ;
    if (obj) obj.onclick=StopClick;
    
    
}


function AddClick()
{   
    if (Checkinfo()==false) {return;}
	var obj=document.getElementById("Code"); 
	if (obj) 
	{	
	    var eqcode=(trim(obj.value))
		if (eqcode!="")
		{
			
			var objd=document.getElementById("Desc"); 
			var eqdesc=objd.value
			var objip=document.getElementById("IP"); 
			var eqip=objip.value
			var objcom=document.getElementById("Com"); 
			var eqcom=objcom.value
			var obj=document.getElementById("mInsert") ;
			if (obj) {var encmeth=obj.value;} else {var encmeth='';}
			var ret=cspRunServerMethod(encmeth,eqcode,eqdesc,eqip,eqcom) ;
			if (ret<0)
			{
				alert("保存失败,请重试")
			}
			else
			{
				ClearItem();
				tQuery_click();
			}

		}   
	} 
}

function Checkinfo()
{
	var code=""
	var objc=document.getElementById("Code"); 
	if (objc) {
		var code= trim(objc.value)
	}
	if (code=="")
	{
		alert("请先填写< 代码 >后重试...")
		return false;
	}
	//
	var desc="";
	var objd=document.getElementById("Desc"); 
	if (objd) {
		var desc= trim(objd.value)
	}
	if (desc=="")
	{
		alert("请先填写< 名称 >后重试...")
		return false;
	}
	//
	var ip="";
	var objip=document.getElementById("IP"); 
	if (objip) {
		var ip= trim(objip.value)
	}
    if (ip=="")
	{
		alert("请先填写< IP >后重试...")
		return false;
	}
	//
	var com=""
	var objco=document.getElementById("COM"); 
	if (objco) {
		var com= trim(objco.value)
	}
	if (com=="")
	{
		alert("请先填写< 端口 >后重试...")
		return false;
	}
	return true;
	
}

function ClearItem()
{
	var objc=document.getElementById("Code"); 
	if (objc) {
		objc.value="";
	}
	//
	var objd=document.getElementById("Desc"); 
	if (objd) {
	    objd.value="";
	}
	//
	var objip=document.getElementById("IP"); 
	if (objip) {
        objip.value="";
	}
	//
	var objco=document.getElementById("COM"); 
	if (objco) {
		objco.value="";
	}
	
	
}

function StartClick()
{
	    var cnt=1 ;
	    var objtbl=document.getElementById("t"+"DHCST_PIVA_EMANAGE")
	    if (objtbl)  {
		    var cnt=objtbl.rows.length  ; 
	    }
	    if (cnt==1){alert("请先选中设备后重试...")
	    return;}
	    for (var i=1;i<cnt; i++) {
		var cell=document.getElementById("tbSelectz"+i)
		if (cell.checked==true)
		{
            var objst=document.getElementById("tbStatez"+i)
		    if (objst.innerText=="OK") {continue;}
	        var objc=document.getElementById("tbCode"+"z"+i) 
	        var code=objc.innerText;
	        var objd=document.getElementById("tbDesc"+"z"+i) 
	        var desc=objd.innerText;
	        var objip=document.getElementById("tbIP"+"z"+i) 
	        var ip=objip.innerText;
	        var objcom=document.getElementById("tbCom"+"z"+i) 
	        var com=objcom.innerText;
			var objstart=document.getElementById("mStart") ;
			if (objstart) {var encmeth=objstart.value;} else {var encmeth='';}
			var ret=cspRunServerMethod(encmeth,code,com,ip) ;
			if (ret<0)
			{
				alert("启动失败,请重试");
				return;
			}
			else
			{
				var objcom=document.getElementById("tbRowid"+"z"+i)
				var rowid=objcom.value;
				var objstate=document.getElementById("mSetstate") ;
				if (objstate) {var encmeth=objstate.value;} else {var encmeth='';}
			    var err=cspRunServerMethod(encmeth,rowid,"OK") ;
				if (err==0) {objst.innerText="OK"};
				//alert("启动成功")
			}
		}
		
	    }
	
}

function StopClick()
{
	    var cnt=1 ;
	    var objtbl=document.getElementById("t"+"DHCST_PIVA_EMANAGE")
	    if (objtbl)  {
		    var cnt=objtbl.rows.length  ; 
	    }
	    if (cnt==1){alert("请先选中设备后重试...")
	    return;}
	    for (var i=1;i<cnt; i++) {
		var cell=document.getElementById("tbSelectz"+i)
		if (cell.checked==true)
		{
            var objst=document.getElementById("tbStatez"+i)
		    //if (objst.innerText=="") {continue;}
	        var objc=document.getElementById("tbCode"+"z"+i) 
	        var code=objc.innerText;
	        var objd=document.getElementById("tbDesc"+"z"+i) 
	        var desc=objd.innerText;
	        var objip=document.getElementById("tbIP"+"z"+i) 
	        var ip=objip.innerText;
	        var objcom=document.getElementById("tbCom"+"z"+i) 
	        var com=objcom.innerText;
			var objstart=document.getElementById("mStart") ;
			if (objstart) {var encmeth=objstart.value;} else {var encmeth='';}
			var ret=cspRunServerMethod(encmeth,code,com,ip) ;
			if (ret<0)
			{
				alert("停止失败,请重试")
			}
			else
			{
				var objcom=document.getElementById("tbRowid"+"z"+i)
				var rowid=objcom.value;
				var objstate=document.getElementById("mSetstate") ;
				if (objstate) {var encmeth=objstate.value;} else {var encmeth='';}
			    var err=cspRunServerMethod(encmeth,rowid,"") ;
				if (err==0) {objst.innerText=""};
				//alert("停止成功")
			}
		}
		
	    }
	
}

function SelectRowHandler()
 {
	 
	 var row=selectedRow(window);
	 CurrentRow=row;
 }









document.body.onload=BodyLoadHandler;