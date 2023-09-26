var parWin;
var currRow;
function BodyLoadHandler()
{
   parWin=window.dialogArguments;
   var obj=document.getElementById("OK");
   if (obj) obj.onclick=SetIncItm;
   var obj=document.getElementById("t"+"dhcpha_IncItmByAlias");
   if (obj) obj.ondblclick=SetIncItm;


 }
function SetIncItm()
{
	var str=GetInci();
	if (str=="") return;
	if (parWin)
	{

	  var docu=parWin.document;
	  var obj=docu.getElementById("Alias");
	  if (obj)
	  {
		parWin.AliasLookupSelect(str);
		window.close();
	  }
	
	} 	
	
	}
function GetInci()
{
  if (currRow>0)
  {
	  var obj1=document.getElementById("tINCI"+"z"+currRow);
	    var obj2=document.getElementById("tCode"+"z"+currRow);
	    var obj3=document.getElementById("tDesc"+"z"+currRow);
	      
  	if (obj)  return obj3.innerText+"^"+obj2.innerText+"^"+obj1.value;
  
  }
 
}
function SelectRowHandler()
{
	
  currRow=selectedRow(window);
  
}
document.body.onload=BodyLoadHandler;
