

function BodyLoadHandler()
{

}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
    //var obj=document.getElementById("TbtnSurez"+selectrow);
    var surelink="TbtnSurez"+selectrow
    var obj=document.getElementById("TAdmz"+selectrow);
    var adm=obj.value;
    var obj=document.getElementById("Tindz"+selectrow);
    var ind=obj.innerText;
    var obj=document.getElementById("TMemSurez"+selectrow);
    var mem=obj.value; 
    var other=""
    //var obj=document.getElementById("btnSurez"+selectrow);
    var cancellink="TbtnCancelz"+selectrow
    //alert(eSrc.id)
	if (selectrow !=0) {
				if (eSrc.id==surelink)	{    //审核
				    //alert(adm+","+ind+","+mem)
					var obj=document.getElementById("TSureStatusz"+selectrow);
				    if (obj.innerText=="已审"){
					    alert("已经审核过不需要再审核")
					    return false;
				    }
					var obj=document.getElementById('savesure');
					if (obj) {var encmeth=obj.value} else {var encmeth=''};
					var Stat=cspRunServerMethod(encmeth,adm,ind,1,mem,other);     //,LocId,UserId
					if (Stat!=0)	{
						alert(Stat);
						return false;
					}
					else{
						var obj=document.getElementById("TSureStatusz"+selectrow);
						obj.innerText="已审"
						return false;
					}

				}
				if (eSrc.id==cancellink)	{    //撤销审核
				    //alert(adm+","+ind+","+mem)
					var obj=document.getElementById("TSureStatusz"+selectrow);
				    if (obj.innerText!="已审"){
					    alert("不是已审的不需要撤销")
					    return false;
				    }
					var obj=document.getElementById('savesure');
					if (obj) {var encmeth=obj.value} else {var encmeth=''};
					var Stat=cspRunServerMethod(encmeth,adm,ind,0,mem,other);     //,LocId,UserId
					if (Stat!=0)	{
						alert(Stat);
						return false;
					}
					else{
						var obj=document.getElementById("TSureStatusz"+selectrow);
						obj.innerText="撤销"
						return false;
					}

				}
	}
}
document.body.onload = BodyLoadHandler;