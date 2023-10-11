function BodyLoadHandler() {
	var obj=document.getElementById('PapmiNo');
	if (obj) obj.onkeydown=PapmiNoObj_keydown;
	var myobj=document.getElementById('TBBExtCode');
	if (myobj){
		myobj.size=1;
		myobj.multiple=false;
	}
	var obj=document.getElementById("Updateinsu");
	if (obj) obj.onclick=Update_click;
	var obj=document.getElementById("UpdateBBExtCode");
	if (obj) obj.onclick=UpdateBBExtCode_click;
	var obj=document.getElementById("AllSelect");
	if (obj) obj.onclick=AllSelect_click;
	loadBBExtCode();
	AllSelect_click();
}
function Admlook(str) {
	//alert(str);
	var obj=document.getElementById('Adm');
	var tem=str.split("^");
	obj.value=tem[0];
	var obj1=document.getElementById('AdmId');
	obj1.value=tem[1];
	var obj=document.getElementById('Find');
	obj.click()
}
function loadBBExtCode(){
	DHCWebD_ClearAllListA("TBBExtCode");
	var encmeth=DHCWebD_GetObjValue("ReadPatTypeAdm");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","TBBExtCode");
	}
	
}
function AllSelect_click(){
	var obj=document.getElementById('AllSelect');
	if(obj.checked==true) var flag=true
	else var flag=false
	var objtbl=document.getElementById('tDHCDocOrderMedLeft');
	if (objtbl)
	{
		var rows = objtbl.rows;
		for(var i=1;i<rows.length;i++)
		{
			var CheckFlag=document.getElementById("CheckFlagz"+i)
			CheckFlag.checked=flag
	    }
	}
		
}
function Update_click()	
{
	var objtbl=document.getElementById('tDHCDocOrderMedLeft');
	if (objtbl)
	{
		var rows = objtbl.rows;
		for(var i=1;i<rows.length;i++)
		{
			var INSUTMP="N"
			var OEItemID=document.getElementById("OEItemIDz"+i).value
			var MedLeft=document.getElementById("MedLeftz"+i)
			if(MedLeft.checked==true)  INSUTMP="Y"
			var Update=document.getElementById('SetINSUTMP');
			
		if (Update) {var encmeth=Update.value} else {var encmeth=''};
		//alert(OEItemID+INSUTMP)
		var Ret=cspRunServerMethod(encmeth,OEItemID,INSUTMP)	
		
				}	
				if (Ret==1) alert(t["UpdateSuccess"])
				else alert(t["UpdateFail"])
                                window.close();
		}	
}

function PapmiNoObj_keydown(e){
	if (evtName=='PapmiNo') 
	{
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var key=websys_getKey(e);
	if (key==13) {
		var PapmiNo=FormatPapmiNo();
		DHCC_SetElementData("PapmiNo",PapmiNo);
		if(PapmiNo!=""){
			var GetDetail=document.getElementById('FindPatByID');
			if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
			var PatName=cspRunServerMethod(encmeth,PapmiNo)
			if(PatName=="")alert("此病人ID不存在")
			else {
				var obj=document.getElementById('PatName')
				if(obj){
				  	obj.value=PatName;
				  	var obj=document.getElementById('Adm');
					obj.value="";
					var obj1=document.getElementById('AdmId');
					obj1.value="";
					var obj=document.getElementById('Find');
					obj.click()
				}
			}
			
		}
	}
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow)
     {return;}
	if (selectrow !=0) {
		var OEItemID=document.getElementById("OEItemIDz"+selectrow).value
		var ArcimDesc=document.getElementById("ArcimDescz"+selectrow).innerText
		var SubmitLink='Submitz'+selectrow;				
		if (eSrc.id==SubmitLink)	{
			var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCDocOrderBBExt&OrderID="+OEItemID+"&ArcimDesc="+ArcimDesc
			if(typeof websys_writeMWToken=='function') lnk=websys_writeMWToken(lnk);
	        win=open(lnk,"DHCDocOrderMedLeft","status=1,scrollbars=1,top=150,left=400,width=700,height=400");
			return false;
			}
			
		}
		
}
function UpdateBBExtCode_click()
{
	var objtbl=document.getElementById('tDHCDocOrderMedLeft');
	if (!objtbl) objtbl=document.getElementById('tDHCDocOrderMedLeft_List0');
	if (objtbl.rows.length<2){
		alert("请先查找病人的就诊记录")
		return;
	}
	var unum=0;
	for(var i=1;i<objtbl.rows.length;i++)
	{
		var ischeck=document.getElementById("CheckFlagz"+i)
		if(ischeck.checked==true)unum=unum+1;
	}
	if (unum==0){alert("请先查找病人的就诊记录");return;}
	
	var BBExtCode=DHCC_GetElementData("TBBExtCode")
	var BBExtCode=BBExtCode.split("^")[0]
	var result=0
	if (objtbl){
		var rows = objtbl.rows;
		for(var i=1;i<rows.length;i++)
		{
			var ischeck=document.getElementById("CheckFlagz"+i)
			if(ischeck.checked==true){
				var OEItemID=document.getElementById("OEItemIDz"+i).value
				var encmeth=DHCWebD_GetObjValue("UpdateBBExtCodeEncrypt");
	          if (encmeth!=""){
		      var rtn=cspRunServerMethod(encmeth,OEItemID,BBExtCode);
		      if(rtn!=0){
			      alert("更新失败")
			      result=1
			      }
	        }
		}
		}
		if(result==0)alert("更新成功")	
	}
	var obj=document.getElementById('Find');
      if(obj)obj.click()
}
function FormatPapmiNo(){
	var PapmiNo=DHCC_GetElementData("PapmiNo");
	if (PapmiNo!='') {
		var PapmiNoLength=DHCC_GetElementData("PatientNoLen");
		if ((PapmiNo.length<PapmiNoLength)&&(PapmiNoLength!=0)) {
			for (var i=(PapmiNoLength-PapmiNo.length-1); i>=0; i--) {
				PapmiNo="0"+PapmiNo;
			}
		}
	}

	return PapmiNo
}

document.body.onload = BodyLoadHandler;