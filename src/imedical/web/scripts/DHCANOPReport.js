
function BodyLoadHandler()
{
	//添加
	var objadd=document.getElementById("add");
	if (objadd) {objadd.onclick=add_click;}
	//更新
	var objupdate=document.getElementById("update");
	if (objupdate) 
	{			
		objupdate.onclick=update_click;
	}
	//删除
	var objdel=document.getElementById("del");
	if (objdel) {
		objdel.onclick=del_click;
		}
}
function add_click(e) 
{
	  var mthadd=document.getElementById("mthadd").value;
	  var code=document.getElementById("repcode").value;
	  var name=document.getElementById("repname").value;
	  //var filename=document.getElementById("repfilename").value;
	  var repOperStat=document.getElementById("repoperStat").value
	  var repStatCode=document.getElementById("repStatCode").value
	  var repstatistic=document.getElementById("repstatisticstat").value
	  var repststatcode=document.getElementById("repststatcode").value
	  if ((code=="")||(name==""))
	  {
	  	alert (t['alert:null']);
	  	return false;
	  }
	  var res=cspRunServerMethod(mthadd,code,repststatcode,name+"^"+repOperStat+"^"+repStatCode+"^"+repstatistic)
	  if (res==0){
		    alert(t['alert:success']);
	  }
	   else if(res==-1){
		  alert("此代码已存在");
	  }
	  else
	  {
			alert(t['alert:error']);
	  }
	  var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPReport";
	  window.location.href=lnk; 

}


function update_click(e) 
{
	  var mthupdate=document.getElementById("mthupdate").value;
	  var selrow=document.getElementById("selrow").value;
	  if(selrow==""){alert("请选中一行记录！");return;}
	  var oldcode=document.getElementById("codez"+selrow).innerText;
	  var ststatCode=document.getElementById("ststatCodez"+selrow).innerText;
	  
	  var code=document.getElementById("repcode").value;
	  var name=document.getElementById("repname").value;
	  //var filename=document.getElementById("repfilename").value;
	  var repOperStat=document.getElementById("repoperStat").value
	  var repStatCode=document.getElementById("repStatCode").value
	  var repstatistic=document.getElementById("repstatisticstat").value
	  var repststatcode=document.getElementById("repststatcode").value
	  if ((code=="")||(name==""))
	  {
	  	alert (t['alert:null']);
	  	return false;
	  }
	  //alert(oldcode+"^"+code+"^"+repststatcode+"^"+ststatCode+"^"+name+"^"+repOperStat+"^"+repStatCode+"^"+repstatistic)
	  var res=cspRunServerMethod(mthupdate,oldcode,code,repststatcode,ststatCode,name+"^"+repOperStat+"^"+repStatCode+"^"+repstatistic)
	  if (res==0){
		    alert(t['alert:success']);
	  }
	  else if(res==-1){
		  alert("此代码已存在");
	  }
	  else
	  {
			alert(t['alert:error']);
	  }
	  var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPReport";
	  window.location.href=lnk; 
}

function del_click(e) 
{

	    var mthdel=document.getElementById("mthdel").value;
    
	    var selrow=document.getElementById("selrow").value;
	    if(selrow==""){alert("请选中一行记录！");return;} //add mfc 20140523添加选中一行判断
	    var ststatCode=document.getElementById("ststatCodez"+selrow).innerText;
	    var code=document.getElementById("codez"+selrow).innerText;
	    if (selrow=="") return;
	    var res=cspRunServerMethod(mthdel,ststatCode,code);
	    if (res==0)
	    {
		    alert(t['alert:success']);
		}
		else
		{
			alert(t['alert:error']);
		}
	  var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPReport";
	  window.location.href=lnk; 
}
 function SelectRowHandler(e)
 {
    var selrow=document.getElementById("selrow");
    selrow.value=DHCWeb_GetRowIdx(window);
    //alert(selrow.value)
    var code=document.getElementById("codez"+selrow.value).innerText;
    //alert(code)
    var name=document.getElementById("namez"+selrow.value).innerText;
    var operstat=document.getElementById("operstatz"+selrow.value).innerText;
    var statCode=document.getElementById("statCodez"+selrow.value).value;
    var statisticstat=document.getElementById("statisticstatz"+selrow.value).innerText;
    var ststatCode=document.getElementById("ststatCodez"+selrow.value).innerText;

    var repcode=document.getElementById("repcode");
    var repname=document.getElementById("repname");
    var repoperStat=document.getElementById("repoperStat");
    var repStatCode=document.getElementById("repStatCode");
    var repstatisticstat=document.getElementById("repstatisticstat");
    var repststatcode=document.getElementById("repststatcode");

    repcode.value=code;
    repname.value=name;
    repoperStat.value=operstat;
    repStatCode.value=statCode;
    repstatisticstat.value=statisticstat;
    repststatcode.value=ststatCode;
    var win=parent.frames[1];
	if (win) {
		var frm = win.document.getElementById("ststatCode");
		if (frm) frm.value =ststatCode;
	} 
    var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPReportList&queryTypeCode="+code+"&ststatCode="+ststatCode;
    parent.frames[1].location.href=lnk;
   
    
    
 }
 
function DHCWeb_GetRowIdx(wobj)
{
	try{
		var eSrc=wobj.event.srcElement;
		//alert(wobj.name);
		if (eSrc.tagName=="IMG") eSrc=wobj.event.srcElement.parentElement;
		var rowObj=getRow(eSrc);
		var selectrow=rowObj.rowIndex;
		return 	selectrow
	}catch (e)
	{
		alert(e.toString());
		return -1;
	}
}

function SaveOperStat(str)
{
	var operStat=str.split("^");
	var obj=document.getElementById("repoperStat")
	if (obj) obj.value=operStat[1];
	var obj=document.getElementById("repStatCode")
	if (obj) obj.value=operStat[0];	
}

function Savestatistic(str)
{
	var statistic=str.split("^");
	var obj=document.getElementById("repststatcode")
	if (obj) obj.value=statistic[0];
	var obj=document.getElementById("repstatisticstat")
	if (obj) obj.value=statistic[1];	
}

document.body.onload = BodyLoadHandler;
