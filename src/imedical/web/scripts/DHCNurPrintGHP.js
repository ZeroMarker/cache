function BodyLoadHandler()
{
	var obj=document.getElementById("Print");
    if(obj) obj.onclick=Print_Click;
    
}
function Print_Click(){
  var objjobNumber=document.getElementById("jobNumber");
  if (objjobNumber.value=="")
  {
	  alert("«Î ‰»Îπ§∫≈!");
	  return;
  }
  var userid=objjobNumber.value;
  Card= new ActiveXObject("PrintBar.PrnBar");//TestAx.CLSMAIN
  Card.PrintName="tiaoma";
  Card.jobNumberStr=userid;
  //Card.SetPrint();
  Card.PrintJobNumber();

}
document.body.onload = BodyLoadHandler;