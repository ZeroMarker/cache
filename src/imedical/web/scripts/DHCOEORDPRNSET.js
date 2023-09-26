 var OrdTyp=document.getElementById("OrdTyp").value;
 var Dep=document.getElementById("Dep").value;
 var DepNo=document.getElementById("DepNo").value;
 
 function BodyLoadHandler()
{
   	var obj=document.getElementById('OK');
	if (obj) {obj.onclick=OK_click;}
	var obj=document.getElementById('Cancel');
	if (obj) {obj.onclick=Cancel_click;}
	
	//alert(2);
var LongStPge,ShortStPge,LStRow,SStRow,LEdRow,SEdRow;
 ShortStPge=document.getElementById('ShortStPge');
 SStRow=document.getElementById('SStRow');
 SEdRow=document.getElementById('SEdRow');
 var Adm=document.getElementById("Adm").value;
 //var FetchPageRow=document.getElementById("schtystrow").value;
	    //察看打印的页码和行数
 var Res;
 //Res=cspRunServerMethod(FetchPageRow,OrdTyp,Adm,Dep,DepNo);
 Res = tkMakeServerCall("Nur.DHCORDPRINT", "getPLprintinfo",  Adm, session['LOGON.CTLOCID'], OrdTyp );
 var PagStr="";
 if (Res!="")
 {
	 //PagStr=Res.split("|");
	 PagStr=Res.split("^");
 }
 /*
 if (PagStr!="")
 {
	ShortStPge.value=PagStr[0];
	SStRow.value=PagStr[1];
	if (PagStr[2]){
		 SEdRow.value=PagStr[2];
		}
 }
*/
if (PagStr!="")
 {//pos_"^"_pag_"^"_strow_"^"_ordcount_"^^"_rw
	ShortStPge.value=eval(PagStr[1])+1;
	SStRow.value=PagStr[2];
	//if (PagStr[2]){
	//	 SEdRow.value=PagStr[2];
	//	}
 }


}
/*
function OK_click() //增加
{
 
 var EndPage,StPage,StRow,EdRow;
 var SetStr;
 StPage=document.getElementById('ShortStPge');
 EndPage=document.getElementById('LsEndPage');
 StRow=document.getElementById('SStRow');
 EdRow=document.getElementById('SEdRow');
 SetStr=""; //初始化
 
 if ((StPage.value!="")&&(StRow.value!=""))
 {
     if (OrdTyp=="lsord"){
      SetStr=StPage.value+"|"+StRow.value;
     }
     else{
      SetStr=StPage.value+"|"+(eval(StRow.value)+1);

	     }
 }
 else
 {
	 if (OrdTyp=="lsord"){
      SetStr=StPage.value+"|"+eval(1);
     }
     else{
      SetStr=StPage.value+"|"+(eval(2));

	     }

 }
 if ((EndPage.value!="")&&(EdRow.value!="")){
	 if (OrdTyp=="lsord")
     {
	 SetStr=SetStr+"|"+EndPage.value+"|"+(eval(EdRow.value)+1);
     }
     else{
	 SetStr=SetStr+"|"+EndPage.value+"|"+(eval(EdRow.value)+2);
	     }
	}
else{
	  if (OrdTyp=="lsord")
     {
	 SetStr=SetStr+"|"+EndPage.value+"|"+(eval(28));
     }
     else{
	 SetStr=SetStr+"|"+EndPage.value+"|"+(eval(29));
	     }
	
	}
 window.returnValue=SetStr;
//	 alert(window.returnValue);
 window.close();
}
*/
function OK_click() //增加
{
 //alert(OrdTyp);
 var EndPage,StPage,StRow,EdRow;
 var SetStr;
 StPage=document.getElementById('ShortStPge');
 EndPage=document.getElementById('LsEndPage');
 StRow=document.getElementById('SStRow');
 EdRow=document.getElementById('SEdRow');
 SetStr=""; //初始化
 
 if ((StPage.value!="")&&(StRow.value!=""))
 {
     if (OrdTyp=="lsord"){
      SetStr=StPage.value+"|"+(eval(StRow.value)-1);
     }
     else{
      SetStr=StPage.value+"|"+(eval(StRow.value)-1);

	     }
 }
 else
 {
	 if (OrdTyp=="lsord"){
      SetStr=StPage.value+"|";
     }
     else{
      SetStr=StPage.value+"|";

	     }

 }
 if ((EndPage.value!="")&&(EdRow.value!="")){
	 if (OrdTyp=="lsord")
     {
	 SetStr=SetStr+"|"+EndPage.value+"|"+(eval(EdRow.value));
     }
     else{
	 SetStr=SetStr+"|"+EndPage.value+"|"+(eval(EdRow.value));
	     }
	}
else{
	  if (OrdTyp=="lsord")
     {
	 SetStr=SetStr+"|"+EndPage.value+"|";
     }
     else{
	 SetStr=SetStr+"|"+EndPage.value+"|";
	     }
	
	}
 window.returnValue=SetStr;
//	 alert(window.returnValue);
 window.close();
}
function Cancel_click()//修改
{//	    resStr=#server(web.udhcclnurseexec.TypeUpdate(typeData[typeIndex][0],form1.txtCode.value,form1.txtDesc.value+"^"+form1.txtFilename.value+"^"+form1.txtPatOrder.value+"^"+form1.txtPrintFrame.value))#;
    
    var SetStr;
    SetStr="";
    window.returnValue=SetStr;
    window.close();
}
function SavePageRow(typ,Page,Row)
{
		var startrow=document.getElementById("startrow").value;
	    var Adm=document.getElementById("Adm").value;
	    var info=cspRunServerMethod(startrow,typ,Adm,Page,Row,Dep);
	
}
document.body.onload = BodyLoadHandler;
