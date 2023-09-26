
function BodyLoadHandler()
{
	var obj=document.getElementById("t"+"dhcpha_phadistypeordcat")
	if (obj) obj.ondblclick=selectOrdCat;
	
	var obj=document.getElementById("bsave");
	if (obj) obj.onclick=SaveFun;
	
}

function SaveFun()
{
	var obj=document.getElementById("distype");
	if (obj) distype=obj.value ;
	if (distype=="") {
		alert("请选择正确的所属类别!")
		return ; 
	}
	var obj=document.getElementById("currentRow")
	if (obj) row=obj.value ;
	if (row>0)
	{
		var obj=document.getElementById("tOrdCatRowid"+"z"+row);
		if (obj) ordcatrowid=obj.value;
		var wholeflag=0;
		var obj2=document.getElementById("tWholeDisp"+"z"+row);
		if (obj2){
			if (obj2.checked){
			      var wholeflag=1;
			}
			
		} 
		
		var obj=document.getElementById("mSaveConfig")
		if (obj) {var encmeth=obj.value; }	else {var encmeth='';}
   		var result=cspRunServerMethod(encmeth,distype,ordcatrowid,wholeflag) ;
		if (result=="-1") {
				alert("请选择正确的所属类别!")
				return ; 
		}
		alert("保存成功!")
	}
	
}

function selectOrdCat()
{
	//according to the display type cat rowid , make selections of the definition
	var distype ;
	var row;
	//
	var obj=document.getElementById("distype");
	if (obj) distype=obj.value ;
	if (distype=="") return ; 

	var obj=document.getElementById("currentRow")
	if (obj) row=obj.value ;
	if (row>0)
	{
		var obj2=document.getElementById("tOrdCatRowid"+"z"+row);
		if (obj2) ordcatrowid=obj2.value;
		
		//if selected
		var selected ;
		var obj=document.getElementById("tSelect"+"z"+row)
		if (obj) selected=obj.checked;

		if (selected==true)   //alreaday selected then delete
		{
			delRel(distype,ordcatrowid);
		}
		else
		{	//make selections

			if (DispCatExists(ordcatrowid))
				{	alert(t['ALREADYEXISTS']);
				 return ;
				}
			else
				{  
					 InsPhaDisRel(distype,ordcatrowid); }
		}
	}
	self.location.reload();
}
function InsPhaDisRel(distype,ordcatrowid)
{	

	var obj=document.getElementById("mInsRel")
	if (obj) {var encmeth=obj.value; }	else {var encmeth='';}
		
	var result=cspRunServerMethod(encmeth,distype,ordcatrowid) ;
	if (result!="") return true	;
	return false;
}
function delRel(distype,ordcatrowid)
{
	var obj=document.getElementById("mDelRel")
	if (obj) {var encmeth=obj.value; }	else {var encmeth='';}
		
	var result=cspRunServerMethod(encmeth,distype,ordcatrowid) ;
	if (result!="") return true	;
	return false;
	
	}
function DispCatExists(ordcatrowid)
{
	var obj=document.getElementById("mIsRelaExists")
	if (obj) {	var encmeth=obj.value;}	else {var encmeth='';}

	var result=cspRunServerMethod(encmeth,ordcatrowid) ;
	//alert(result);
	if (result!="") return true;
	return false;
}

function SelectRowHandler()
 {
	var row=selectedRow(window);
	var obj=document.getElementById("currentRow") ;
	if (obj) obj.value=row;

}

function refreshWin()
{
	window.location.reload()  	
}

document.body.onload=BodyLoadHandler;
