document.write("<OBJECT id=dlgHelper CLASSID='clsid:3050f819-98b5-11cf-bb82-00aa00bdce0b' width='0px' height='0px'>");
document.write("</object>");

var ancvcId=""
var SelectedRow=-1;
var ID=""
function BodyLoadHandler() {
	var obj=document.getElementById('Add');
	if (obj) obj.onclick = Add_Click;
	var obj=document.getElementById('Delete');
	if (obj) obj.onclick = Delete_Click;
	var obj=document.getElementById('Update');
	if (obj) obj.onclick = Update_Click;		
	//ypz begin
	obj=document.getElementById('selectColor'); 
	if (obj) obj.onclick =Color_click; 
	obj=document.getElementById('ANPIColor'); 
    if (obj) 
    {
	    obj.onkeypress=HexFilter;
	    obj.onblur=FormatColor;
    }
    //ypz end

}
function Update_Click()
{
	 var typeobj=document.getElementById('ANPIParref');
	 if (typeobj) var ANPIParref=typeobj.value;
	 var typeobj=document.getElementById('ANPIOpMonDr');
	 if (typeobj) var ANPIOpMonDr=typeobj.value;
	 var typeobj=document.getElementById('ANPIEventDr');
	 if (typeobj) var ANPIEventDr=typeobj.value;
	 var typeobj=document.getElementById('ANPIArcimDr');
	 if (typeobj) var ANPIArcimDr=typeobj.value;
	 var typeobj=document.getElementById('ANPIAnOrdDr');
	 if (typeobj) var ANPIAnOrdDr=typeobj.value;
	 var typeobj=document.getElementById('FlagID');
	// var LeftFirst=typeobj.left(1,1)
	 switch(typeobj.value)
	 {
		 case "D":
		 	 if (typeobj) var ANPIFlag="D";
		 	 break;
		 case "H":
		 	 if (typeobj) var ANPIFlag="H";
		 	 break;
		 case "U":
		 	 if (typeobj) var ANPIFlag="U";
		 	 break;		 	 
		 default:
		 	 if (typeobj) var ANPIFlag="U";
		 	 break;
	 }
	 var typeobj=document.getElementById('SourceID');
	 if (typeobj.value=="I")
	 {
	 if (typeobj) var ANPISource="I";
	 }
	 else
	 {
		 if (typeobj) var ANPISource="M"
	 }
	 var typeobj=document.getElementById('ANPIIconDr');
	 if (typeobj) var ANPIIconDr=typeobj.value;
	 
	 var typeobj=document.getElementById('ANPISeqNo');
	 if (typeobj) var ANPISeqNo=typeobj.value;

	 if (ANPISeqNo.length==0)  
	 {
		 alert("SeqNo null!");
	     return false;
	 }
	 var typeobj=document.getElementById('ANPIColor');
	 if (typeobj) var ANPIColor=typeobj.value;
	 if (ANPIColor.length==0)  
	 {
		 alert("Color null!");
	     return false;
	 }	 
	 var typeobj=document.getElementById('ANPIScaleDr');
	 if (typeobj) var ANPIScaleDr=typeobj.value;
	 var typeobj=document.getElementById('ANPIViewCat');
	 if (typeobj) var ANPIViewCat=ancvcId;//typeobj.value;
	 var typeobj=document.getElementById('ANPIUomDr');
	 if (typeobj) var ANPIUomDr=typeobj.value;
	 var p1=ANPIOpMonDr+"^"+ANPIEventDr+"^"+ANPIArcimDr+"^"+ANPIAnOrdDr+"^"+ANPIFlag+"^"+ANPISource+"^"+ANPIIconDr+"^"+ANPISeqNo+"^"+ANPIColor+"^"+ANPIScaleDr+"^"+ANPIViewCat+"^"+ANPIUomDr;
 	 //alert(ANPIOpMonDr);

     p1=p1+"^"+ID
 	 //alert(p1); 
	 var InsertObj=document.getElementById('UpdateDHCANParaItem');
	 if (InsertObj) {var encmeth=InsertObj.value} else {var encmeth=''};
	 var Ret=cspRunServerMethod(encmeth,'addok','',p1); 
	// alert(Ret);	 
}
function Add_Click()
{
	 var typeobj=document.getElementById('ANPIParref');
	 if (typeobj) var ANPIParref=typeobj.value;
	 var typeobj=document.getElementById('ANPIOpMonDr');
	 if (typeobj) var ANPIOpMonDr=typeobj.value;
	 var typeobj=document.getElementById('ANPIEventDr');
	 if (typeobj) var ANPIEventDr=typeobj.value;
	 var typeobj=document.getElementById('ANPIArcimDr');
	 if (typeobj) var ANPIArcimDr=typeobj.value;
	 var typeobj=document.getElementById('ANPIAnOrdDr');
	 if (typeobj) var ANPIAnOrdDr=typeobj.value;
	 var typeobj=document.getElementById('FlagID');
	// var LeftFirst=typeobj.left(1,1)
	//alert(typeobj.value);
	 switch(typeobj.value)
	 {
		 case "D":
		 	 if (typeobj) var ANPIFlag="D";
		 	 break;
		 case "H":
		 	 if (typeobj) var ANPIFlag="H";
		 	 break;
		 case  "U":
		 	 if (typeobj) var ANPIFlag="U";
		 	 break;		 	 
		 default:
		 	 if (typeobj) var ANPIFlag="U";
		 	 break;
	 }
	 var typeobj=document.getElementById('SourceID');
	 if (typeobj.value=="D")
	 {
	 if (typeobj) var ANPISource="D";
		 
	 }
	 else
	 {
		 if (typeobj) var ANPISource="M"
	 }
	 var typeobj=document.getElementById('ANPIIconDr');
	 if (typeobj) var ANPIIconDr=typeobj.value;
	 
	 var typeobj=document.getElementById('ANPISeqNo');
	 if (typeobj) var ANPISeqNo=typeobj.value;
	 if (ANPISeqNo.length==0)  
	 {
		 alert("SeqNo null!");
	     return false;
	 }	 
	 var typeobj=document.getElementById('ANPIColor');
	 if (typeobj) var ANPIColor=typeobj.value;
	 if (ANPIColor.length==0)  
	 {
		 alert("Color null!");
	     return false;
	 }	 
	 var typeobj=document.getElementById('ANPIScaleDr');
	 if (typeobj) var ANPIScaleDr=typeobj.value;
	 var typeobj=document.getElementById('ANPIViewCat');
	 if (typeobj) var ANPIViewCat=ancvcId;//typeobj.value;
	 var typeobj=document.getElementById('ANPIUomDr');
	 if (typeobj) var ANPIUomDr=typeobj.value;
	 
	 var p1=ANPIParref+"^"+ANPIOpMonDr+"^"+ANPIEventDr+"^"+ANPIArcimDr+"^"+ANPIAnOrdDr+"^"+ANPIFlag+"^"+ANPISource+"^"+ANPIIconDr+"^"+ANPISeqNo+"^"+ANPIColor+"^"+ANPIScaleDr+"^"+ANPIViewCat+"^"+ANPIUomDr;
 	 //alert(p1);
	 var InsertObj=document.getElementById('AddDHCANParaItem');
	 if (InsertObj) {var encmeth=InsertObj.value} else {var encmeth=''};
	 var Ret=cspRunServerMethod(encmeth,'addok','',p1);
	 //alert(Ret);
	}
function addok(value)
	{if (value==0) {
		var findobj=document.getElementById('Query');
		if (findobj) findobj.click();
	//	window.location.reload();
		}}
function Delete_Click()
{
     var p1=ID;
     var DeleteAnaestAgent=document.getElementById('DeleteDHCANParaItem');
	 if (DeleteAnaestAgent) {var encmeth=DeleteAnaestAgent.value} else {var encmeth=''};
	 //alert(p1);
	 var Ret=cspRunServerMethod(encmeth,'addok','',p1);	
}
function SetOperInfo(str)
{
	var obj=str.split("^");
	var Obj=document.getElementById("Name");
	Obj.value=obj[0];
	var Obj=document.getElementById("ID");
	Obj.value=obj[1];	
	}
function SetOperDevInfo(str)
{
	var obj=str.split("^");
	var Obj=document.getElementById("ANPIOpMonDr");
	Obj.value=obj[1];
	var Obj=document.getElementById("OpMonDrName");
	Obj.value=obj[0];	
	}
	
function SetEventInfo(str)
{
	var obj=str.split("^");
	var Obj=document.getElementById("ANPIEventDr");
	Obj.value=obj[1];
	var Obj=document.getElementById("ANPIEventDrName");
	Obj.value=obj[0];	
	}

function setComOrd(str)
{
	var obj=str.split("^");
	var Obj=document.getElementById("ANPIAnOrdDr");
	Obj.value=obj[1];
	var Obj=document.getElementById("ANPIAnOrdDrName");
	Obj.value=obj[0];	
	}

function SetICONInfo(str)
{
	var obj=str.split("^");
	var Obj=document.getElementById("ANPIIconDr");
	Obj.value=obj[1];
	var Obj=document.getElementById("ANPIIconDrName");
	Obj.value=obj[0];	
	}
function SetItemInfo(str)
{
	var obj=str.split("^");
	var Obj=document.getElementById("ANPIArcimDr");
	Obj.value=obj[1];
	var Obj=document.getElementById("ANPIArcimDrName");
	Obj.value=obj[0];	
	}
	
function SetFlagInfo(str)
{
	//alert(str);
	var obj=str.split("^");
	var Obj=document.getElementById("FlagID");
	Obj.value=obj[0];
	var Obj=document.getElementById("ANPIFlag");
	Obj.value=obj[1];	
	}
	
		
function SetSourceInfo(str)
{
	//alert(str);
	var obj=str.split("^");
	var Obj=document.getElementById("SourceID");
	Obj.value=obj[0];
	var Obj=document.getElementById("ANPISource");
	Obj.value=obj[1];	
	}	
function SetUomInfo(str)
{
	//alert(str);
	var obj=str.split("^");
	var Obj=document.getElementById("ANPIUomDr");
	Obj.value=obj[1];
	var Obj=document.getElementById("ANPIUomName");
	Obj.value=obj[0];	
	}
function SetScaleInfo(str)
{
	//alert(str);
	var obj=str.split("^");
	var Obj=document.getElementById("ANPIScaleDr");
	Obj.value=obj[1];
	var Obj=document.getElementById("ANPIScaleName");
	Obj.value=obj[0];	
	}	

function SelectRowHandler()	
{  
	var eSrc=window.event.srcElement;
	Objtbl=document.getElementById('tDHCANParaItem');
	Rows=Objtbl.rows.length;
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (selectrow!=SelectedRow) {
	var SelRowObj=document.getElementById('tIDz'+selectrow);
	ID=SelRowObj.innerText;
	SetParaItemInfo(ID);
	}
}
function SetParaItemInfo(Str)
{
	 p1=Str;	 
	 var UpdateObj=document.getElementById('GetParaInfo');
	 if (UpdateObj) {var encmeth=UpdateObj.value} else {var encmeth=''};
	 var Ret=cspRunServerMethod(encmeth,p1); 
	 var RetStr=Ret.split("^")
	 var typeobj=document.getElementById('ANPIAnOrdDr');
     typeobj.value=RetStr[0];
	 var typeobj=document.getElementById('ANPIArcimDr');
     typeobj.value=RetStr[1];
	 var typeobj=document.getElementById('ANPISource');
     typeobj.value=RetStr[2];
	 var typeobj=document.getElementById('ANPIFlag');
     typeobj.value=RetStr[3];
	 var typeobj=document.getElementById('ANPIEventDr');
     typeobj.value=RetStr[4];
	 var typeobj=document.getElementById('ANPIIconDr');
     typeobj.value=RetStr[5];
	 var typeobj=document.getElementById('ANPIOpMonDr');
     typeobj.value=RetStr[6];
	 var typeobj=document.getElementById('ANPIAnOrdDrName');
     typeobj.value=RetStr[7];
	 var typeobj=document.getElementById('ANPIArcimDrName');
     typeobj.value=RetStr[8];
	 var typeobj=document.getElementById('ANPIEventDrName');
     typeobj.value=RetStr[9];
	 var typeobj=document.getElementById('ANPIIconDrName');
     typeobj.value=RetStr[10];
     var typeobj=document.getElementById('OpMonDrName');
     typeobj.value=RetStr[11];
     
	 var typeobj=document.getElementById('ANPISeqNo');
     typeobj.value=RetStr[12];
	 var typeobj=document.getElementById('ANPIColor');
     typeobj.value=RetStr[13];
	 var typeobj=document.getElementById('ANPIScaleDr');
     typeobj.value=RetStr[14];
	 var typeobj=document.getElementById('ANPIScaleName');
     typeobj.value=RetStr[15];
     ancvcId=RetStr[16];
	 var typeobj=document.getElementById('ANPIViewCat');
     typeobj.value=RetStr[17];
	 var typeobj=document.getElementById('ANPIUomDr');
     typeobj.value=RetStr[18];
     var typeobj=document.getElementById('ANPIUomName');
     typeobj.value=RetStr[19];   
	 var typeobj=document.getElementById('FlagID');
     typeobj.value=RetStr[20];
     var typeobj=document.getElementById('SourceID');
     typeobj.value=RetStr[21];         
  
	}
	//ypz begin
function FormatColor()//add 0 before color value
{
	var obj=document.getElementById('ANPIColor'); 
	if (obj) {
		obj.value=((obj.value.length<6)?"000000".substring(0,6-obj.value.length):"") + obj.value;
	}
}
function HexFilter()//only hex input
{
	var obj=document.getElementById('ANPIColor'); 
	if (obj) {if (obj.value.length>5) {window.event.keyCode = 0;return;}};
	if ( !(((window.event.keyCode >= 48) && (window.event.keyCode <= 57)) 
		|| ((window.event.keyCode >= 65) && (window.event.keyCode <= 70))
		|| ((window.event.keyCode >= 97) && (window.event.keyCode <= 102))
		|| (window.event.keyCode == 13)))
	{
		window.event.keyCode = 0 ;
	}
} 
function Color_click()//call color panel
{
	var curColor="000000"
	var obj=document.getElementById('ANPIColor'); 
    if (obj) curColor=obj.value;
	/*//window.open('dhccolorpanel.csp', 'Sample', 'toolbar=no,location=yes,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=no,width=1,height=1,left=0,top=0');	
	////window.open('dhccolorpanel.csp', 'Sample', 'toolbar=no,location=yes,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=no,width=48,height=80,left=10000,top=10000');	//ok
	//showModelessDialog("dhccolorpanel.csp","window", "status:false;dialogWidth:0px;dialogHeight:0px;edge:Raised; enter:no; help: No; resizable: No; status: No;dialogTop:100px;dialogLeft:100px");
	var diaRet=showModalDialog("dhccolorpanel.csp",tmpColor, "status:false;dialogWidth:0px;dialogHeight:0px;edge:Raised; enter:no; help: No; resizable: No; status: No");
	if (obj) obj.value =diaRet; */
	
    var tempColor=window.dialogArguments;
    var Hcolor = dlgHelper.ChooseColorDlg(curColor).toString(16);
    tempColor=((Hcolor.length<6)?"000000".substring(0,6-Hcolor.length):"") + Hcolor;
    if (obj) obj.value=tempColor;
    //alert("tempColor="+tempColor);
    window.close();
}
//ypz end
function GetAncViewCat(str)
{
		var doc=str.split("^");
		var obj=document.getElementById("ANPIViewCat")
		ancvcId=doc[0];
		obj.value=doc[2];
}

document.body.onload = BodyLoadHandler;