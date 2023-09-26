

var selectRow=-1;
var ID=0,preRowInd=0;
var itmId="",arcosId="";
function BodyLoadHandler()
{
	//---
	
	var obj=document.getElementById('Add');
	if (obj) obj.onclick = Add_Click;
	var obj=document.getElementById('Delete');
	if (obj) obj.onclick = Delete_Click;
	var obj=document.getElementById('Update');
	if (obj) obj.onclick = Update_Click;
	var obj=document.getElementById("needArcimDescList");
	if (obj) obj.ondblclick = ArcimDescList_Dublclick;
}

function Add_Click()
{
	//var typeobj=document.getElementById('UomRowId');
	// if (typeobj) var ANCOUomDrId=typeobj.value;
	
    var OecBodySiteDesc=document.getElementById("OecBodySiteDesc");
    if (OecBodySiteDesc){
	  // alert(OecBodySiteDesc)
	    if (OecBodySiteDesc.value==""){alert(t['1']);return;} 
	    var GetOecObj=document.getElementById('GetOecBSD');
	    if (GetOecObj) {var encmeth=GetOecObj.value} else {var encmeth=''};
	    //alert(GetOecObj.value)
	    var OecBodySiteDescID=cspRunServerMethod(encmeth,'','',OecBodySiteDesc.value);
	   
	    var p1= OecBodySiteDescID;	     
    }
    var ANCOArcim=GetListData("needArcimDescList");
    if (ANCOArcim==""){alert(t['3']);return} 
    var p2=ANCOArcim;
     var objISDisplay=document.getElementById("ISDisplay");
    var ISDisplay=objISDisplay.value; 
    var p3=""
    if(ISDisplay=="是") p3="Y";    
	else p3="N";
	 var InsertObj=document.getElementById('AddCommonOrd');
	 if (InsertObj) {var encmeth=InsertObj.value} else {var encmeth=''};
	// alert(p1+p2+p3)
	 var Ret=cspRunServerMethod(encmeth,'addok','',p1,p2,p3);
    
}
function Delete_Click()
{
	//alert(preRowInd); 
	//if (preRowInd<1) return;
     var RowID=ID; 
     //alert(p1);              
     var Deleteobj=document.getElementById('DeleteCommonOrd');
     if (Deleteobj) {var encmeth=Deleteobj.value} else {var encmeth=''};
	 //alert(Deleteobj);
	 var Retstr=cspRunServerMethod(encmeth,'delok','',RowID);
	//cspRunServerMethod(encmeth,'','',"3");
	//cspRunServerMethod(encmeth,'3');	
}
function delok(value)
{   
     if (value==0) {
		var findobj=document.getElementById('Query');
		if (findobj) findobj.click();
	//	window.location.reload();
	    //alert("OK");
		}
	 else alert(value);

}
function Update_Click()
{	
	//if (preRowInd<1) return;
	var ANCOAnApply="",ANCOIcuApply="";
	 var typeobj=document.getElementById('OecBodySiteDesc');
	 if (typeobj) var OecBodySiteDesc=typeobj.value;
	 
	 var objISDisplay=document.getElementById("ISDisplay");
    var ISDisplay=objISDisplay.value; 
    var ISDisplayID=""
    if(ISDisplay=="是") ISDisplayID="Y";    
	else ISDisplayID="N";
	 var typeobj=document.getElementById('needArcimDesc');
	 if (typeobj) var needArcimDescID=typeobj.value;
	 
	 
	var GetOecObj=document.getElementById('GetOecBSD');
	if (GetOecObj) {var encmeth=GetOecObj.value} else {var encmeth=''};
	//alert(OecBodySiteDesc)
	var OecBodySiteDescID=cspRunServerMethod(encmeth,'','',OecBodySiteDesc);
	// bodsId=GetElementValue('tSPABodySitez'+ID,"I");
	// alert(OecBodySiteDescID)
	 
	 var ANCOArcim=GetListData("needArcimDescList");	 
	 
	 //var p1=ANCOCode+"^"+ANCODesc+"^"+ANCOType+"^"+ANCOArcim+"^"+ancViewCatIdStr+"^"+ANCOUomDrId+"^"+ANCOIconDrId+"^"+ANCOColor+"^"+ANCOAnApply+"^"+ANCOIcuApply+"^"+ANCOOptions+"^"+itmId+"^"+ancoMultiValueDesc+"^"+ancoSortNo+"^"+arcosId + "^" + ancoDataType;
     //alert(p1);
    
	 var UpdateObj=document.getElementById('UpdateCommonOrd');
	 if (UpdateObj) {var encmeth=UpdateObj.value} else {var encmeth=''};
	 //alert(ID)
	// alert(ANCOArcim)
	 var Ret=cspRunServerMethod(encmeth,'addok','',ID,OecBodySiteDescID,ANCOArcim,ISDisplayID);
}
function addok(value)
{    if (value==0) {
		var findobj=document.getElementById('Query');
		if (findobj) findobj.click();
	//	window.location.reload();
	    //alert("OK");
		}
	 else alert(value);
}
function ArcimDescList_Dublclick()
{
	list_Dublclick("needArcimDescList");
}
function list_Dublclick(elementName)
{
  	var listObj=document.getElementById(elementName);
  	var objSelected=listObj.selectedIndex;
  	if(objSelected == -1) return;
  	listObj.remove(objSelected);
}
function GetListData(elementName)
{
	var retString
	retString=""
	var objList=document.getElementById(elementName);
	if(objList){
		for (var i=0;i<objList.options.length;i++)
	   	{
		   if (objList.options[i].value!="")
		   {
			   if(retString==""){
				   retString=objList.options[i].value
			   }
			   else{
				   retString=retString+"~"+objList.options[i].value
			   }
		   }
		}
	}
	return retString
}
function SetOperInfo(str)
{	
	var strValue=str.split("^");
	var nameObj=document.getElementById("Name");
	nameObj.value=strValue[1];	
	var obj=document.getElementById("needArcimDesc");
	if(obj)
	{
		addListRow("needArcimDescList",strValue);
		obj.value=""
		websys_setfocus("needArcimDesc");
	}
}

function SelectRowHandler()	
{      
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCANCSiteProphyAntibiotics');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);	
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;	

	//alert(selectrow)	
	var OecBSDObj=document.getElementById('OecBodySiteDesc');
	var ISActiveObj=document.getElementById('ISDisplay');
	var ArcimObj=document.getElementById('needArcimDesc');	   
	var SelRowObj=document.getElementById('tSPAArcimIDz' + selectrow);			
	var tSPAArcimzID=SelRowObj.value; //innerText	
	var SelRowObj=document.getElementById('tRowIDz' + selectrow);		
	var tSPARowID=SelRowObj.innerText;
	ID=tSPARowID;
	var SelRowObj=document.getElementById('tSPABodySitez' + selectrow);		
	var tOecBSD=SelRowObj.innerText;
	var SelRowObj=document.getElementById('tSPAActivez' + selectrow);		
	var tIsActive=SelRowObj.innerText;        
    
   if(selectrow==preRowInd)
   {	 
	 OecBSDObj.value="";
	 ISActiveObj.value="";
	 ArcimObj.value=""; 	
	 preRowInd=0;
	 ID=0;
	 ClearListData("needArcimDescList");	
   }
   else
   {     
  	 ClearListData("needArcimDescList"); 
  	 //选中记录值对应对应于各个控件 	   	  	 
  	 if (tSPAArcimzID!=""){     
     SetComInfo(tSPAArcimzID);  //获取医嘱名称   
  	 }  
     OecBSDObj.value=tOecBSD;   
     if(tIsActive=="Y") tIsActive="是"
     else if(tIsActive=="N") tIsActive="否"
     ISActiveObj.value=tIsActive
    
     preRowInd=selectrow;  
   }
}
function ClearListData(elementName)
{
	var listvalue=GetListData(elementName);
	var listObj=document.getElementById(elementName);
	
	for(var i=0;i<listvalue.split("~").length;i++)
	{
	  	listObj.remove(0);
	}
}
function SetComInfo(Str)
{
	var p1=Str;   
	var SubStr=""
	for(var i=0;i<p1.split("~").length;i++)
	 {	
		 var str= p1.split("~")
		 var Sub=str[i].split("|")
		 //alert(Sub)
		 var SubID=Sub[0]
		 var verID=Sub[2]		 		
		 var UpObj=document.getElementById('GetComOrdInfo');
	     if (UpObj){var encmeth=UpObj.value} else {var encmeth=''};
	     //alert(SubID+verID)
	     var Ret=cspRunServerMethod(encmeth,SubID,verID);
	    // alert(Ret)			    
	     var SubStr=Ret+"^"+str[i]	     
		 addListRow("needArcimDescList",SubStr.split("^"));
	 }	
}
function SetOecBSD(OecBSDDesc)
{
	var UpObj=document.getElementById('GetOecBSD');
	if (UpObj){var encmeth=UpObj.value} else {var encmeth=''};
	//alert(UpObj.value)
	var Ret=cspRunServerMethod(encmeth,'','',OecBSDDesc);
	//alert(Ret)
	var OecBSDObj=document.getElementById('OecBodySiteDesc');
	if (OecBSDObj){OecBSDObj.value=Ret};
}
function addListRow(elementName,dataValue)
{
	//alert(dataValue[0]+"__"+dataValue[1])
	var itemValue=dataValue;
	if(itemValue[0] == "" || itemValue[1] == "") return;
    var objSelected = new Option(itemValue[0], itemValue[1]);
	var listObj=document.getElementById(elementName);
	listObj.options[listObj.options.length]=objSelected;
}
function SetUom(str)
{	
	var obj=str.split("^");	
	var Obj=document.getElementById("OecBodySiteDesc");
	Obj.value=obj[0];
	var Obj=document.getElementById("OecBodySiteDescID");
	Obj.value=obj[1];	
	}	
	
function GetActiveStr(str)
{
	var obj=str.split("^");	
	var ISDisplayflag=obj[0];
	var Obj=document.getElementById("ISDisplay");
	Obj.value=obj[1];
	//alert(ISDisplayflag+"/"+Obj.value)
}
document.body.onload = BodyLoadHandler; 