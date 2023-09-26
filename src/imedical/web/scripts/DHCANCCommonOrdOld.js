document.write("<OBJECT id=dlgHelper CLASSID='clsid:3050f819-98b5-11cf-bb82-00aa00bdce0b' width='0px' height='0px'>");
document.write("</object>");

var selectRow=-1;
var ID=0,preRowInd=0;
function BodyLoadHandler() {
	var obj=document.getElementById('Add');
	if (obj) obj.onclick = Add_Click;
	var obj=document.getElementById('Delete');
	if (obj) obj.onclick = Delete_Click;
	var obj=document.getElementById('Update');
	if (obj) obj.onclick = Update_Click;	
	var obj=document.getElementById('ItemCatName');
	if (obj) obj.onblur = ItemCatBlue;
	//ypz begin
	obj=document.getElementById('selectColor'); 
	if (obj) obj.onclick =Color_click; 
	obj=document.getElementById('ColorDesc'); 
    if (obj) 
    {
	    obj.onkeypress=HexFilter;
	    obj.onblur=FormatColor;
    }
    //ypz end	
}
function Update_Click()
{
	if (preRowInd<1) return;
	 var typeobj=document.getElementById('ANCOCode');
	 if (typeobj) var ANCOCode=typeobj.value;
	 var typeobj=document.getElementById('ANCODesc');
	 if (typeobj) var ANCODesc=typeobj.value;
	 var typeobj=document.getElementById('CatID');
	 if (typeobj) var ANCOCat=typeobj.value;
	 //alert(typeobj.value);
	 /*switch(typeobj.value)
	 {
		 case "D":
		 	 if (typeobj) var ANCOCat="D";
		 	 break;
		 case "P":
		 	 if (typeobj) var ANCOCat="P";
		 	 break;
		 case "E":
		 	 if (typeobj) var ANCOCat="E";
		 	 break;
		 case  "M":
		 	 if (typeobj) var ANCOCat="M";
		 	 break;		 	 		 	 
		 default:
		 	 if (typeobj) var ANCOCat="M";
		 	 break;
	 }*/
	 switch(typeobj.value)
	 {
		 case "D":
		 	 if (typeobj) var ANCOCat="D";
		 	 break;
		 case "V":
		 	 if (typeobj) var ANCOCat="V";
		 	 break;
		 case "E":
		 	 if (typeobj) var ANCOCat="E";
		 	 break;
		 case "T":
		 	 if (typeobj) var ANCOCat="T";
		 	 break;
		 case  "L":
		 	 if (typeobj) var ANCOCat="L";
		 	 break;		 	 		 	 
		 default:
		 	 if (typeobj) var ANCOCat="D";
		 	 break;
	 }
	 var typeobj=document.getElementById('Name');
	 if (typeobj) var ANCOArcim=typeobj.value;
	 var typeobj=document.getElementById('ANCEViewCatId');
	 if (typeobj) var ANCEViewCatId=typeobj.value;
	 //wxl
	 var typeobj=document.getElementById('UomRowId');
	 if (typeobj) var ANCOUomDrId=typeobj.value;
	 var typeobj=document.getElementById('IconRowId');
	 if (typeobj) var ANCOIconDrId=typeobj.value;
	 var typeobj=document.getElementById('ColorDesc');
	 if (typeobj) var ANCOColor=typeobj.value;
	 var p1=ANCOCode+"^"+ANCODesc+"^"+ANCOCat+"^"+ANCOArcim+"^"+ANCEViewCatId+"^"+ANCOUomDrId+"^"+ANCOIconDrId+"^"+ANCOColor;
     p1=p1+"^"+ID;
     //alert(p1);
	 var UpdateObj=document.getElementById('UpdateCommonOrd');
	 if (UpdateObj) {var encmeth=UpdateObj.value} else {var encmeth=''};
	 var Ret=cspRunServerMethod(encmeth,'addok','',p1);
}
function Add_Click()
{
	 var typeobj=document.getElementById('ANCOCode');
	 if (typeobj) var ANCOCode=typeobj.value;
	 var typeobj=document.getElementById('ANCODesc');
	 if (typeobj) var ANCODesc=typeobj.value;
	 var typeobj=document.getElementById('CatID');
	 if (typeobj) var ANCOCat=typeobj.value;
	 /*switch(typeobj.value)
	 {
		 case "D":
		 	 if (typeobj) var ANCOCat="D";
		 	 break;
		 case "P":
		 	 if (typeobj) var ANCOCat="P";
		 	 break;
		 case "E":
		 	 if (typeobj) var ANCOCat="E";
		 	 break;
		 case  "M":
		 	 if (typeobj) var ANCOCat="M";
		 	 break;		 	 		 	 
		 default:
		 	 if (typeobj) var ANCOCat="D";
		 	 break;
	 }*/
	 switch(typeobj.value)
	 {
		 case "D":
		 	 if (typeobj) var ANCOCat="D";
		 	 break;
		 case "V":
		 	 if (typeobj) var ANCOCat="V";
		 	 break;
		 case "E":
		 	 if (typeobj) var ANCOCat="E";
		 	 break;
		 case "T":
		 	 if (typeobj) var ANCOCat="T";
		 	 break;
		 case  "L":
		 	 if (typeobj) var ANCOCat="L";
		 	 break;		 	 		 	 
		 default:
		 	 if (typeobj) var ANCOCat="D";
		 	 break;
	 }
	 var typeobj=document.getElementById('Name');
	 if (typeobj) var ANCOArcim=typeobj.value;
	 var typeobj=document.getElementById('ANCEViewCatId');
	 if (typeobj) var ANCEViewCatId=typeobj.value;
	 //wxl
	 var typeobj=document.getElementById('UomRowId');
	 if (typeobj) var ANCOUomDrId=typeobj.value;
	 var typeobj=document.getElementById('IconRowId');
	 if (typeobj) var ANCOIconDrId=typeobj.value;
	 var typeobj=document.getElementById('ColorDesc');
	 if (typeobj) var ANCOColor=typeobj.value;
	 var p1=ANCOCode+"^"+ANCODesc+"^"+ANCOCat+"^"+ANCOArcim+"^"+ANCEViewCatId+"^"+ANCOUomDrId+"^"+ANCOIconDrId+"^"+ANCOColor;
	 //alert(p1);
	 var InsertObj=document.getElementById('AddCommonOrd');
	 if (InsertObj) {var encmeth=InsertObj.value} else {var encmeth=''};
	 var Ret=cspRunServerMethod(encmeth,'addok','',p1);

	}
function addok(value)
	{if (value==0) {
		var findobj=document.getElementById('Query');
		if (findobj) findobj.click();
	//	window.location.reload();
	    //alert("OK");
		}
	 else alert("error");}
function Delete_Click()
{
	if (preRowInd<1) return;
     var p1=ID;
     var DeleteAnaestAgent=document.getElementById('DeleteCommonOrd');
	 if (DeleteAnaestAgent) {var encmeth=DeleteAnaestAgent.value} else {var encmeth=''};
	 //alert(p1);
	 var Ret=cspRunServerMethod(encmeth,'addok','',p1);	
}


function SetCatInfo(str)
{
   // alert("dd");
	var obj=str.split("^");
	var Obj=document.getElementById("CatID");
	Obj.value=obj[0];
	var Obj=document.getElementById("ANCOCat");
	Obj.value=obj[1];	
	}
	
function SetTypeInfo(str)
{
   
	var obj=str.split("^");
	var Obj=document.getElementById("ItemCatName");
	Obj.value=obj[0];
	var Obj=document.getElementById("needItemCatId");
	Obj.value=obj[1];
	//var S=obj[1];
	//alert(Obj.value);
	}
function SetOperInfo(str)
{
	var obj=str.split("^");
	var Obj=document.getElementById("Name");
	Obj.value=obj[1];
	var Obj=document.getElementById("needArcimDesc");
	Obj.value=obj[0];	
	}
function SetANCEViewCat(str)
{
	var obj=str.split("^");
	var Obj=document.getElementById("ANCEViewCat");
	Obj.value=obj[0];
	var Obj=document.getElementById("ANCEViewCatId");
	Obj.value=obj[1];	
	}

//wxl
function SetUom(str)
{
	var obj=str.split("^");
	var Obj=document.getElementById("UomDesc");
	Obj.value=obj[0];
	var Obj=document.getElementById("UomRowId");
	Obj.value=obj[1];	
	}		
	
//wxl
function SetIcon(str)
{
	var obj=str.split("^");
	var Obj=document.getElementById("IconDesc");
	Obj.value=obj[0];
	var Obj=document.getElementById("IconRowId");
	Obj.value=obj[1];	
	}		
			
function SelectRowHandler()	
{  
	var eSrc=window.event.srcElement;
	Objtbl=document.getElementById('tDHCANCCommonOrd');
	Rows=Objtbl.rows.length;
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	selectRow=rowObj.rowIndex;
	if (!selectRow) return;
	var SelRowObj=document.getElementById('tRowIDz'+selectRow);
	ID=SelRowObj.innerText;
    var typeobj=document.getElementById('ANCOCode');
	var typeobj1=document.getElementById('ANCODesc');
	var typeobj2=document.getElementById('ANCOCat');
	var typeobj3=document.getElementById('needArcimDesc');
	var typeobj4=document.getElementById('Name');
	var typeobj5=document.getElementById('CatID');
	var typeobj6=document.getElementById('needItemCatId');
	var typeobj7=document.getElementById('ItemCatName');
	var typeobj8=document.getElementById('ANCEViewCatId');
	var typeobj9=document.getElementById('ANCEViewCat');
	//wxl
	var typeobj10=document.getElementById('UomRowId');
	var typeobj11=document.getElementById('UomDesc');
	var typeobj12=document.getElementById('IconRowId');
	var typeobj13=document.getElementById('IconDesc');
	var typeobj14=document.getElementById('ColorDesc');
    if (selectRow==preRowInd){
	 typeobj.value="";
	 typeobj1.value="";
	 typeobj2.value="";
	 typeobj3.value="";
	 typeobj4.value="";
	 typeobj5.value="";
	 typeobj6.value="";
	 typeobj7.value="";
	 typeobj8.value="";
	 typeobj9.value="";
	 //wxl
	 typeobj10.value="";
	 typeobj11.value="";
	 typeobj12.value="";
	 typeobj13.value="";
	 typeobj14.value="";  
	 preRowInd=0;
	 ID=0;
    }
   else { 
       SetComInfo(ID);
       preRowInd=selectRow;
   }
}
	
function SetComInfo(Str)
{
	 p1=Str;
     //alert(p1);	 
	 var UpObj=document.getElementById('GetComOrdInfo');
	 if (UpObj) {var encmeth=UpObj.value} else {var encmeth=''};
	 var Ret=cspRunServerMethod(encmeth,p1); 
	 var RetStr=Ret.split("^");
	 //alert(Ret);
	 var typeobj=document.getElementById('ANCOCode');
	 if (typeobj)  typeobj.value=RetStr[0];
	 var typeobj1=document.getElementById('ANCODesc');
     if (typeobj1)  typeobj1.value=RetStr[1];
	 var typeobj2=document.getElementById('ANCOCat');
	 typeobj2.value=RetStr[2];
	 var typeobj3=document.getElementById('needArcimDesc');
	 typeobj3.value=RetStr[4];
	 var typeobj4=document.getElementById('Name');
	 typeobj4.value=RetStr[3];
	 var typeobj5=document.getElementById('CatID');
	 typeobj5.value=RetStr[5];
	 var typeobj6=document.getElementById('needItemCatId');
	 typeobj6.value=RetStr[6];
	 var typeobj7=document.getElementById('ItemCatName');
	 typeobj7.value=RetStr[7];	 	 
	 var typeobj8=document.getElementById('ANCEViewCatId');
	 typeobj8.value=RetStr[8];
	 var typeobj9=document.getElementById('ANCEViewCat');
	 typeobj9.value=RetStr[9];
	 //wxl
	 var typeobj10=document.getElementById('UomRowId');
	 typeobj10.value=RetStr[10];
	 var typeobj11=document.getElementById('UomDesc');
	 typeobj11.value=RetStr[11];
	 var typeobj12=document.getElementById('IconRowId');
	 typeobj12.value=RetStr[12];
	 var typeobj13=document.getElementById('IconDesc');
	 typeobj13.value=RetStr[13];
	 var typeobj14=document.getElementById('ColorDesc');
	 typeobj14.value=RetStr[14];
	 //alert(selectRow)
}
function ItemCatBlue()
{
	var obj=document.getElementById('ItemCatName');
	if ((obj)&&(obj.value=="")) document.getElementById('needItemCatId').value="";
}

	//ypz begin
function FormatColor()//add 0 before color value
{
	var obj=document.getElementById('ColorDesc'); 
	if (obj) {
		obj.value=((obj.value.length<6)?"000000".substring(0,6-obj.value.length):"") + obj.value;
	}
}
function HexFilter()//only hex input
{
	var obj=document.getElementById('ColorDesc'); 
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
	var obj=document.getElementById('ColorDesc'); 
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

document.body.onload = BodyLoadHandler;