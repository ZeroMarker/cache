var SelectedRow=-1;
var ID=""
var p1=""
var AnaID="",preRowInd=0;;
function BodyLoadHandler() {
	var obj=document.getElementById('Add');
	if (obj) obj.onclick = Add_Click;
	var obj=document.getElementById('Delete');
	if (obj) obj.onclick = Delete_Click;
	var obj=document.getElementById('Update');
	if (obj) obj.onclick = Update_Click;		
}
function Update_Click()
{
	if (preRowInd<1) return;
	 var typeobj=document.getElementById('ANICode');
	 if (typeobj) var ANICode=typeobj.value;
	 var typeobj=document.getElementById('ANIDesc');
	 if (typeobj) var ANIDesc=typeobj.value;
	 var typeobj=document.getElementById('ANICount');
	 if (typeobj) var ANICount=typeobj.value;
	 var typeobj=document.getElementById('ANIWidth');
	 if (typeobj) var ANIWidth=typeobj.value;
	 var typeobj=document.getElementById('ANIHeight');
	 if (typeobj) var ANIHeight=typeobj.value;
	 var typeobj=document.getElementById('ANIPositionX');
	 if (typeobj) var ANIPositionX=typeobj.value;
	 var typeobj=document.getElementById('ANIPositionY');
	 if (typeobj) var ANIPositionY=typeobj.value;
	 var typeobj=document.getElementById('ANILineWidth');
	 if (typeobj) var ANILineWidth=typeobj.value;
	 var typeobj=document.getElementById('ANIShape');
	 if (typeobj) var ANIShape=typeobj.value;
	 var typeobj=document.getElementById('ANIData');
	 if (typeobj) var ANIData=typeobj.value;
	 var p1=ANICode+"^"+ANIDesc+"^"+ANICount+"^"+ANIWidth+"^"+ANIHeight+"^"+ANIPositionX+"^"+ANIPositionY+"^"+ANILineWidth+"^"+ANIShape+"^"+ANIData
     p1=p1+"^"+ID
 	 //alert(p1);	 
	 var InsertObj=document.getElementById('UpdateDHCANCIcon');
	 if (InsertObj) {var encmeth=InsertObj.value} else {var encmeth=''};
	 var Ret=cspRunServerMethod(encmeth,'addok','',p1); 
	// alert(Ret);	 
}
function Add_Click()
{
	 var typeobj=document.getElementById('ANICode');
	 if (typeobj) var ANICode=typeobj.value;
	 if ((typeobj)&&(typeobj.value=="")){alert("图列代码不能为空！");return;} 
	 var typeobj=document.getElementById('ANIDesc');
	 if (typeobj) var ANIDesc=typeobj.value;
	 if ((typeobj)&&(typeobj.value=="")){alert("图列名称不能为空！");return;} 
	 var typeobj=document.getElementById('ANICount');
	 if (typeobj) var ANICount=typeobj.value;
	 var typeobj=document.getElementById('ANIWidth');
	 if (typeobj) var ANIWidth=typeobj.value;
	 var typeobj=document.getElementById('ANIHeight');
	 if (typeobj) var ANIHeight=typeobj.value;
	 var typeobj=document.getElementById('ANIPositionX');
	 if (typeobj) var ANIPositionX=typeobj.value;
	 var typeobj=document.getElementById('ANIPositionY');
	 if (typeobj) var ANIPositionY=typeobj.value;
	 var typeobj=document.getElementById('ANILineWidth');
	 if (typeobj) var ANILineWidth=typeobj.value;
	 var typeobj=document.getElementById('ANIShape');
	 if (typeobj) var ANIShape=typeobj.value;
	 var typeobj=document.getElementById('ANIData');
	 if (typeobj) var ANIData=typeobj.value;
	 var p1=ANICode+"^"+ANIDesc+"^"+ANICount+"^"+ANIWidth+"^"+ANIHeight+"^"+ANIPositionX+"^"+ANIPositionY+"^"+ANILineWidth+"^"+ANIShape+"^"+ANIData
 	 //alert(p1);
	 var InsertObj=document.getElementById('AddDHCANCIcon');
	 if (InsertObj) {var encmeth=InsertObj.value} else {var encmeth=''};
	 var Ret=cspRunServerMethod(encmeth,'addok','',p1);
	}
function addok(value)
	{if (value==0) {
		var findobj=document.getElementById('Query');
		if (findobj) findobj.click();
	//	window.location.reload();
		}}
function Delete_Click()
{
	if (preRowInd<1) return;
     var p1=ID;
     var DeleteAnaestAgent=document.getElementById('DeleteDHCANCIcon');
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
	
function SelectRowHandler()	
{  
	var eSrc=window.event.srcElement;
	Objtbl=document.getElementById('tDHCANCIcon');
	Rows=Objtbl.rows.length;
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	//alert(selectrow)
	//alert(SelectedRow)
	//if (selectrow!=SelectedRow) {
	var SelRowObj=document.getElementById('tIDz'+selectrow);
	ID=SelRowObj.innerText;
	var typeobj=document.getElementById('ANICode');
	 var typeobj1=document.getElementById('ANIDesc');
	 var typeobj2=document.getElementById('ANICount');
	 var typeobj3=document.getElementById('ANIWidth');
	 var typeobj4=document.getElementById('ANIHeight');
	 var typeobj5=document.getElementById('ANIPositionX');
	 var typeobj6=document.getElementById('ANIPositionY');
	 var typeobj7=document.getElementById('ANILineWidth');
	 var typeobj8=document.getElementById('ANIShape')
	 var typeobj9=document.getElementById('ANIData');
	if (preRowInd==selectrow){
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
	preRowInd=0;
	ID=0;
	}
	
	else {
		GetIconInfo(ID);
		preRowInd=selectrow;
	}
	}
function GetIconInfo(RowID)
{
	 p1=RowID;	 
	 var UpdateObj=document.getElementById('GetIconInfo');
	 if (UpdateObj) {var encmeth=UpdateObj.value} else {var encmeth=''};
	 var Ret=cspRunServerMethod(encmeth,p1); 
	 //alert(Ret);
	 var RetStr=Ret.split("^")
	 var typeobj=document.getElementById('ANICode');
     typeobj.value=RetStr[0];
	 var typeobj1=document.getElementById('ANIDesc');
     typeobj1.value=RetStr[1];
	 var typeobj2=document.getElementById('ANICount');
     typeobj2.value=RetStr[2];
	 var typeobj3=document.getElementById('ANIWidth');
     typeobj3.value=RetStr[3];
	 var typeobj4=document.getElementById('ANIHeight');
     typeobj4.value=RetStr[4];
	 var typeobj5=document.getElementById('ANIPositionX');
     typeobj5.value=RetStr[5];
	 var typeobj6=document.getElementById('ANIPositionY');
     typeobj6.value=RetStr[6];
	 var typeobj7=document.getElementById('ANILineWidth');
     typeobj7.value=RetStr[7];
	 var typeobj8=document.getElementById('ANIShape');
     typeobj8.value=RetStr[8];
	 var typeobj9=document.getElementById('ANIData');
     typeobj9.value=RetStr[9];
    //SelectedRow=p1;
}
	
document.body.onload = BodyLoadHandler;