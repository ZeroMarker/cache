///DHCOPBILLINVSeatch.js
var AdmType=""
function BodyLoadHandler(){
	var obj=document.getElementById("Print")
	if(obj) obj.onclick=Print_OnClick;
	var obj=document.getElementById("Find");
	if(obj) obj.onclick=Find_click;
	var obj=document.getElementById("Type");
	if(obj){
	   obj.size=1;//只显示一行
	   obj.multiple=false//不能选取多个值
	   obj.onchange=balance_OnChange;
	   
	   
	}
	var varItem=new Option("","O")
	obj.options.add(varItem)
	var varItem=new Option("门诊","O")
	obj.options.add(varItem)
	var varItem= new Option("住院","I")
	obj.options.add(varItem)
}
function balance_OnChange()
{
	var obj=document.getElementById("Type");
	var index=obj.options.selectedIndex
	obj.options[index].selected = true;
	AdmType=obj.options[index].value;
	//alert(AdmType)
}
function Find_click()
{    var StInv=document.getElementById("StInv").value
     var EnInv=document.getElementById("EnInv").value
     var InsObj=document.getElementById("sel"); 
     var Exp=document.getElementById("Exp").value 
	 if (InsObj) {var encmeth=InsObj.value} else {var encmeth=''}
    var ReturnValue=cspRunServerMethod(encmeth,StInv,EnInv,AdmType,Exp);
	var tem=ReturnValue.split("^");
	document.getElementById('NormSum').value=tem[0]
	document.getElementById('Normnum').value=tem[5]
	document.getElementById('Renum').value=tem[1]
	document.getElementById('ReSum').value=tem[2]
	document.getElementById('Voidnum').value=tem[3]
	document.getElementById('VoidSum').value=tem[4]
	document.getElementById('TotalAcount').value=tem[6]
	
	
	
}
function getpath() {
	var getpath=document.getElementById('getpath');
	if (getpath) {var encmeth=getpath.value} else {var encmeth=''};	
	path=cspRunServerMethod(encmeth,'','')
}
function Print_OnClick()
{
  getpath();
  Template=path+"DHCINVPrtSceach.xls"
    xlApp = new ActiveXObject("Excel.Application");
    xlBook = xlApp.Workbooks.Add(Template);
    xlsheet = xlBook.ActiveSheet
     var obj2 = new Date();
	 var day = obj2.getDate();
	 var month = (obj2.getMonth()+1);
	 var year = obj2.getFullYear();
	 var Tday=year+"-"+month+"-"+day;
	 
	 var StInv=document.getElementById('StInv').value;
	 var EnInv=document.getElementById('EnInv').value;
	 var Exp=document.getElementById('Exp').value;
	 xlsheet.cells(2,6).value=session['LOGON.USERNAME'];
	 xlsheet.cells(2,4).value=Tday
	 
     xlsheet.cells(2,2).value=Exp+StInv+"-"+Exp+EnInv
     var Renum=document.getElementById('Renum').value;
	 var ReSum=document.getElementById('ReSum').value;
	  xlsheet.cells(3,2).value=Renum
     xlsheet.cells(3,5).value=ReSum
     var Voidnum=document.getElementById('Voidnum').value;
	 var VoidSum=document.getElementById('VoidSum').value;
	 xlsheet.cells(4,2).value=Voidnum
     xlsheet.cells(4,5).value=VoidSum
     var Voidnum=document.getElementById('Normnum').value;
	 var VoidSum=document.getElementById('NormSum').value;
	 xlsheet.cells(5,2).value=Voidnum
     xlsheet.cells(5,5).value=VoidSum
      var TotalAcount=document.getElementById('TotalAcount').value;
	 xlsheet.cells(6,3).value=TotalAcount
     xlApp.Visible=true
	 xlsheet.PrintPreview();
     xlBook.Close (savechanges=false);
	 xlApp.Quit();
	 xlApp=null;
  	 xlsheet=null

}
document.body.onload = BodyLoadHandler;