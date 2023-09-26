//DHCCarPrvTpPHPoison.js
var SelectedRow=0;
var ComboCTCarPrvTp;
var ComboPHCPoison;
var ComboEpisodeType;
document.body.onload = BodyLoadHandler;


function BodyLoadHandler() {
    //就诊类型初始化
    var EpisodeTypeStr="O"+String.fromCharCode(1)+"门诊"+"^E"+String.fromCharCode(1)+"急诊"+"^I"+String.fromCharCode(1)+"住院";
	ComboEpisodeType=dhtmlXComboFromStr("EpisodeType",EpisodeTypeStr);
	ComboEpisodeType.enableFilteringMode(true);
	ComboEpisodeType.selectHandle=ComboEpisodeTypeselectHandle;
	//医护人员级别初始化
  	var CTCarPrvTpStr="";
	var encmeth=DHCC_GetElementData('GetCTCarPrvTpMethod');
	if (encmeth!=''){CTCarPrvTpStr=cspRunServerMethod(encmeth);}
	ComboCTCarPrvTp=dhtmlXComboFromStr("CTCarPrvTp",CTCarPrvTpStr);
	ComboCTCarPrvTp.enableFilteringMode(true);
	ComboCTCarPrvTp.selectHandle=ComboCTCarPrvTpselectHandle;	
	//药品管制分类初始化
  var PHCPoisonStr="";
	var encmeth=DHCC_GetElementData('GetPHCPoisonMethod');
	if (encmeth!=''){PHCPoisonStr=cspRunServerMethod(encmeth);}
	ComboPHCPoison=dhtmlXComboFromStr("PHCPoison",PHCPoisonStr);
	ComboPHCPoison.enableFilteringMode(true);
	ComboPHCPoison.selectHandle=ComboPHCPoisonselectHandle;		
	//允许级别初始化
	var obj=document.getElementById("ControlType");
	if(obj) 
	{ obj.size=1;
	  obj.multiple=false;
	  var NewIndex=obj.length;
	  obj.options[0] = new Option(" "," ");
		obj.options[1] = new Option("提示","A");
		obj.options[2] = new Option("禁止","F");
		obj.options[3] = new Option("申请单","P");
		obj.options[4] = new Option("系统申请","S");
		obj.onchange=ControlTypeList_Selected;
		}
	var obj=document.getElementById("CTCarPrvTp");
	if (obj) {obj.onkeypress=keydownhandler; }
	
	var obj=document.getElementById("PHCPoison");
	if (obj){obj.onkeypress=keydownhandler;}
	
	var obj=document.getElementById("Badd");
	if (obj){obj.onclick=AddClickHandler;}	
	
	var obj=document.getElementById("Bdel");
	if (obj){obj.onclick=DeleteClickHandler;}	
	
	var obj=document.getElementById("Bupt");
	if (obj){obj.onclick=UpdateClickHandler;}	


}

function ControlTypeList_Selected()
{var ControlType=document.getElementById("ControlType");
	var selIndex=ControlType.selectedIndex;
	if (selIndex==-1) 
		return;
  else
	ControlType.options[selIndex].selected=true;
	
}
//选择一行记录
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCCarPrvTpPHPoison');
	var rows=objtbl.rows.length;
	var lastrowindex=rows-1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	
	if (selectrow!=SelectedRow){
	  var Row=GetRow(objtbl,selectrow);	 
		var TPPRowId=GetColumnData("TPPRowId",Row);
		var TPPParRef=GetColumnData("TPPParRef",Row);
		var CTCPTDesc=GetColumnData("CTCPTDesc",Row);
		var TPPPoisonDR=GetColumnData("TPPPoisonDR",Row);
		var PHCPODesc=GetColumnData("PHCPODesc",Row);
		var TPPControlType=GetColumnData("TPPControlType",Row);
		if(TPPRowId!="") var TPPParRowid=TPPRowId.split("||",1);  
		 var TPPParRowid=TPPParRowid+"^"+CTCPTDesc;
		 var obj=document.getElementById("Prowid");
		 if(obj) obj.value=TPPRowId;
		 //alert(obj.value)
		ComboCTCarPrvTp.setComboValue(TPPParRowid);
		var TPPPoisonDR=TPPPoisonDR+"^"+PHCPODesc;
		ComboPHCPoison.setComboValue(TPPPoisonDR);
		var obj=document.getElementById("ControlType");
		//alert(TPPControlType)
		if (obj&&obj.length>0){
			switch (TPPControlType) {
				case "A":
					obj.options[1].selected=true;
					break;
				case "F":
					obj.options[2].selected=true;
					break;
				case "P":
					obj.options[3].selected=true;
					break;
				case "S":
					obj.options[4].selected=true;
					break;
				default:
					obj.options[0].selected=true;	
			}	  	 
		}
	// 就诊类型
	var TEpisodeType=GetColumnData("TEpisodeType",Row);
	var obj=document.getElementById("EpisodeType");
	ComboEpisodeType.setComboValue(TEpisodeType);
		/// 审核权限
		var TChkVerify=GetColumnData("TChkVerify",Row);
		var obj=document.getElementById("ChkVerify");
		obj.checked=TChkVerify;

		SelectedRow = selectrow;
	}else{
		SelectedRow=0;
		ClearValue();
	}
	
}

function ClearValue(){
	  var obj=document.getElementById("Prowid");
	  obj.value="";
		ComboCTCarPrvTp.setComboText('');
		ComboPHCPoison.setComboText('');
		ComboEpisodeType.setComboText('');
		var ControlType=document.getElementById("ControlType");
		ControlType.selectedIndex=-1;
		DHCC_SetElementData("ChkVerify",false);
	
}
function keydownhandler(e){
	DHCC_Nextfoucs();
}
function ComboCTCarPrvTpselectHandle(e){
	DHCC_Nextfoucs();
}
function ComboEpisodeTypeselectHandle(){
	DHCC_Nextfoucs();
}
function ComboPHCPoisonselectHandle(e){
	DHCC_Nextfoucs();
}

function CheckBeforeUpdate(){
	var TPPParRowid=ComboCTCarPrvTp.getSelectedValue();
	
	if (TPPParRowid=="") {
		alert(t['CTCarPrvTpIsNull']);
		ComboCTCarPrvTp.setfocus();
		return false;
	}
	var PHCPOrowid=ComboPHCPoison.getSelectedValue();
	if (PHCPOrowid=="") {
		alert(t['PHCPositonIsNull']);
		ComboPHCPoison.setfocus();
		return false;
	}
	var EpisodeTypeCode=ComboEpisodeType.getSelectedValue();
	if (EpisodeTypeCode=="") {
		alert(t['EpisodeTypeIsNull']);
		ComboEpisodeType.setfocus();
		return false;
	}
	
	return true;	
}
function AddClickHandler(e){
	var check=CheckBeforeUpdate();
	if (!check) return;
  
	var TPPParRef=ComboCTCarPrvTp.getSelectedValue();
	var TPPPoisonDR=ComboPHCPoison.getSelectedValue();
	var Prowid=DHCC_GetElementData('Prowid');
	var TPPEpisodeType=ComboEpisodeType.getSelectedValue();
		
	var checkUni=CheckUnique(TPPParRef,"",TPPPoisonDR,TPPEpisodeType);
	if(!checkUni) return;
	var obj=document.getElementById("ControlType");
	if(obj&&obj.value!="")
	{var CType=obj.value;}
	else CType="";
	var EpisodeType="";
	if (ComboEpisodeType) EpisodeType=ComboEpisodeType.getSelectedValue();
	var ChkVerify=DHCC_GetElementData('ChkVerify');
	
	var obj=document.getElementById('InsertMethod');
	var encmeth=""
	if (obj) 
		{ encmeth=obj.value;}
	
	
		if (encmeth!="")
		{   
				var ret=cspRunServerMethod(encmeth,TPPParRef,TPPPoisonDR,CType,EpisodeType,ChkVerify);
				
				if (ret==0)
				{
					
					location.reload();
					ClearValue();
					return;
				}
				else
				{
					alert(t['FailAdd']);
					return;
				}
		 }
		return websys_cancel();
}
function DeleteClickHandler(){
	   var obj=document.getElementById("Prowid");
	  if(obj) var TPPRowId=obj.value;
	  
	  if(TPPRowId=="")
	  {alert(t['Select']);
	  	return;
	  }
	  else
	  { 
			var obj=document.getElementById('DeleteMethod');
			var encmeth=""
			if (obj) 
				{ encmeth=obj.value;}
	
	  	
			if (encmeth!="")
			{ 
				var ret=cspRunServerMethod(encmeth,TPPRowId);
				
				if (ret==0)
				{
					alert(t['SuccessDelete']);
					location.reload();
					ClearValue();
					return;
				}
				else
				{
					alert(t['FailDelete']);
					return;
				}
		 	}
		}
		
}
function UpdateClickHandler(){
	  
	  //var check=CheckBeforeUpdate();
	  //if (!check) return;
	  var obj=document.getElementById('Prowid');
	  
	  if(obj) var TPPRowId=obj.value; 
	  if(TPPRowId=="")
	  {alert(t['Select']);
	  	return;
	  }
	  var TPPParRowId=TPPRowId.split("||",1)
	 
	  var TPPParRef=ComboCTCarPrvTp.getSelectedValue();
	  
	  if(TPPParRowId!=TPPParRef)
	     {alert(t['NotUpdate']);
	     	return;
	     }
	var TPPPoisonDR=ComboPHCPoison.getSelectedValue();
	var Prowid=DHCC_GetElementData('Prowid');
	var TPPEpisodeType=ComboEpisodeType.getSelectedValue();
	var ChkVerify=DHCC_GetElementData('ChkVerify');

	  var checkUni=CheckUnique(TPPParRef,Prowid,TPPPoisonDR,TPPEpisodeType);
	  if(!checkUni) return;
	 var obj=document.getElementById("ControlType");
	if(obj&&obj.value!="")
	 var CType=obj.value;
	 else CType=" ";
	 var EpisodeType="";
	if (ComboEpisodeType) EpisodeType=ComboEpisodeType.getSelectedValue();
	
		var obj=document.getElementById("UpdateMethod");
		
		var encmeth=""
		if (obj) 
		{ encmeth=obj.value;}
		if (encmeth!='')
		{   
				var ret=cspRunServerMethod(encmeth,TPPRowId,TPPPoisonDR,CType,EpisodeType,ChkVerify);
				if (ret==0)
				{
					alert(t['SuccessUpdate']);
					location.reload();
					ClearValue();
					return;
				}else
				{
					alert(t['FailUpdate']);
					return;
				}
		 }
		return websys_cancel();
}
function GetRow(objtbl,Rowindex){
	var RowObj=objtbl.rows[Rowindex];
	var rowitems=RowObj.all;
	if (!rowitems) rowitems=RowObj.getElementsByTagName("LABEL");
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			var Row=arrId[arrId.length-1];
		}
	}
	return Row;
}
function GetColumnData(ColName,Row){
	var CellObj=document.getElementById(ColName+"z"+Row);
	//alert(CellObj.id+"^"+CellObj.tagName+"^"+CellObj.value);
	if (CellObj){ 
		if (CellObj.tagName=='LABEL'){
			return CellObj.innerText;
		}else{
			if (CellObj.type=="checkbox"){return CellObj.checked;}else{return CellObj.value;}
		}
	}
	return "";
}

function CheckUnique(TPPParRef,Prowid,TPPPoisonDR,TPPEpisodeType){
  var obj=document.getElementById("CheckUnique");
		
		var encmeth=""
		if (obj) 
		{ encmeth=obj.value;}
		
		if (encmeth!='')
		{   
				var ret=cspRunServerMethod(encmeth,TPPParRef,Prowid,TPPPoisonDR,TPPEpisodeType);
				
				if (ret=="Y")
				{
					alert(t['ResNotUnique']);
					return false;
				}else if (ret==""){
					alert(t['其他错误']);
					return false;
				}
				
		 }
		 return true;
}