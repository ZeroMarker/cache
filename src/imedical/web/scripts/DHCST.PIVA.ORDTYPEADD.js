//DHCST.PIVA.ORDTYPEADD
//
var UpdRowid;
function BodyLoadHandler()
{
	var obj=document.getElementById("bOK");
	if (obj) obj.onclick=UpdPhcCat;
	
	var obj=document.getElementById("bInsert");
	if (obj) obj.onclick=InsPhcCat;
	
	var obj=document.getElementById("tPhcCat");
	if (obj) obj.onblur=PhcLostFocus;
	
	var obj=document.getElementById("tPhcSubCat");
	if (obj) obj.onblur=PhcLostFocus;
		var obj=document.getElementById("bCancel");
	if (obj) obj.onclick=Cancel;
	
	SetPIVAOrdType();
}

/// 取药学分类rowid
function PhcCatLookUpSelect(str)
{
	var cat=str.split("^");
	var obj=document.getElementById("tPhcCatDr");
	if (obj)
	{
		if (cat.length>0)   obj.value=cat[1] ;
		else	obj.value="" ;  
	}
	var obj=document.getElementById("tPhcSubCatDr");
	if (obj) obj.value="";
	var obj=document.getElementById("tPhcSubCat");
	if (obj) obj.value="";
}

/// 取药学子分类rowid
function PhcSubCatLookUpSelect(str)
{
	var cat=str.split("^");
	var obj=document.getElementById("tPhcSubCatDr");
	if (obj)
	{
		if (cat.length>0)   obj.value=cat[1] ;
		else	obj.value="" ;  
	}
}
function Cancel()
{
	window.close();
}
function UpdPhcCat()
{
	var obj;
	var phccat;
	var phsubcat;
	
	obj=document.getElementById("tPhcCatDr");
	if (obj) phccat =obj.value;
	obj=document.getElementById("tPhcSubCatDr");
	if (obj) phsubcat =obj.value;
	if ((trim(phsubcat)=="")&&(trim(phccat)==""))	//合法性判断
	{
		alert("不能为空,请输入<药学分类> 或 <药学子类>后重试...");
		
		obj=document.getElementById("tPhcSubCat");
		if (obj){
			if (obj.disabled=false) obj.focus();
		}

	}
	
	//更新数据
	//

	if (UpdRowid==undefined){alert("请关闭窗口后重新选择...");return;}
    
	ret=cspRunUpdPhcCat(phccat,phsubcat,UpdRowid);
	if (ret!=0) 
	{
		alert("更新失败!"+ret);
  	  	return;
	}
	alert("更新成功!");
	opener.location.reload();
	window.close();

}


function cspRunUpdPhcCat(phccat,phsubcat,UpdRowid)
{
	
	var obj=document.getElementById("mUpdPhcCat");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,phccat,phsubcat,UpdRowid);
	return result;
}


function InsPhcCat()
{
	var obj;
	var phccat;
	var phsubcat;
	
	obj=document.getElementById("tPhcCatDr");
	if (obj) phccat =obj.value;
	obj=document.getElementById("tPhcSubCatDr");
	if (obj) phsubcat =obj.value;
	if ((trim(phsubcat)=="")&&(trim(phccat)==""))	//合法性判断
	{
		alert("不能为空,请输入<药学分类> 或 <药学子类>后重试...");
		
		obj=document.getElementById("tPhcSubCat");
		if (obj){
			if (obj.disabled=false) obj.focus();
		}
		return;
	}


	//更新数据
	//

	ret=cspRunInsPhcCat(phccat,phsubcat);
	if (ret!=0) 
	{
		if (ret=="-1"){alert("药学分类已存在！");return;}
		else{alert("保存失败!"+ret);
  	  	return;}
	}
	alert("保存成功!");
	opener.location.reload();
	window.close();

}

function cspRunInsPhcCat(phccat,phsubcat)
{
	var obj=document.getElementById("mInsPhcCat");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,phccat,phsubcat);
	return result;
}

function PhcLostFocus()
{
	var objsubcat=document.getElementById("tPhcSubCat");
	if (objsubcat)
	{ 
	  if (objsubcat.value=="")
	  {
		  	var objsubcatdr=document.getElementById("tPhcSubCatDr");
	        if (objsubcatdr) objsubcatdr.value="";
		  
	  }
	}
	//
	var objsubcat=document.getElementById("tPhcCat");
	if (objsubcat)
	{ 
	  if (objsubcat.value=="")
	  {
		  	var objsubcatdr=document.getElementById("tPhcCatDr");
	        if (objsubcatdr) objsubcatdr.value="";
		  
	  }
	}
	
	
}


function SetPIVAOrdType()
{ 
   var maindocu=window.opener.document
   var mainrow;
	if (maindocu) {
	  	
	   	var obj=document.getElementById("mainrow")
	    if (obj) var mainrow=obj.value;
	    if (mainrow>0)
	    {   
		    var obj=maindocu.getElementById("Tphcrowid"+"z"+mainrow)
		    if (obj) var phcrowid=obj.value;
		    var obj=maindocu.getElementById("Tcat"+"z"+mainrow)
		    if (obj) var cat=obj.innerText;
		    var obj=maindocu.getElementById("Tsubcat"+"z"+mainrow)
		    if (obj) var subcat=obj.innerText;
		    var obj=maindocu.getElementById("Trowid"+"z"+mainrow)
	        if (obj) UpdRowid=obj.value;
		    
		    
		    if (phcrowid.indexOf("||")==-1)
		    {
			    var obj=document.getElementById("tPhcCatDr");
			    if (obj) obj.value=phcrowid;
			    var obj=document.getElementById("tPhcCat");
			    if (obj) obj.value=cat;
			       
		    }
		    else
		    {
			    var tmparr=phcrowid.split("||");
			    var phccat=tmparr[0];
    
			    var obj=document.getElementById("tPhcCatDr");
			    if (obj) obj.value=phccat;
			    
			    var obj=document.getElementById("tPhcCat");
			    if (obj) obj.value=cat;
			    
			    var obj=document.getElementById("tPhcSubCatDr");
			    if (obj) obj.value=phcrowid;
			    
			    var obj=document.getElementById("tPhcSubCat");
			    if (obj) obj.value=subcat;
		    }
		    
		    
		    
        }
        
        
	}

}



document.body.onload=BodyLoadHandler