//UDHCJFArcimPrice1
var typeobj
var PrintARCIMPricetobj
function BodyLoadHandler() {
	typeobj=document.getElementById('OrdType');
	typeobj.onkeydown=gettype;
	PrintARCIMPricetobj=document.getElementById('PrintARCIMPrice');
	PrintARCIMPricetobj.onclick=PrintARCIMPrice
	var tbl=document.getElementById("tUDHCJFArcimPrice1");
	if(tbl) tbl.ondblclick=TblDblClick;
}
function TblDblClick()	{
	
	var eSrc=window.event.srcElement;
	Objtbl=document.getElementById('tUDHCJFArcimPrice1');
	Rows=Objtbl.rows.length;
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var SelRowObj=document.getElementById('TArcimz'+selectrow);
	var curarcim=SelRowObj.value;
	var UserGroupID=session['LOGON.GROUPID'];
	var ret=tkMakeServerCall('web.DHCDocOrderEntry','AddControl',curarcim,UserGroupID);
    if (ret==1)
	{
		alert("护士没有此项权限，请重新选择")
		return false;
	}
	var lnk='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFItmPrice1&arcim='+curarcim;
	if (parent.frames['UDHCJFItmPrice1']) parent.frames['UDHCJFItmPrice1'].location.href=lnk;
	if (window.name=="UDHCJFArcimPrice1"){
		var Parobj=window.opener
		Parobj.PACSArcimFun(curarcim);
	}
}
//function SelectRowHandler()	{
	
//	var eSrc=window.event.srcElement;
//	Objtbl=document.getElementById('tUDHCJFArcimPrice');
//	Rows=Objtbl.rows.length;
//	var lastrowindex=Rows - 1;
//	var rowObj=getRow(eSrc);
///	var selectrow=rowObj.rowIndex;
//	if (!selectrow) return;
	
	
//	var SelRowObj=document.getElementById('TArcimz'+selectrow);
//	var curarcim=SelRowObj.innerText
    //alert(curarcim);
//	var lnk='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFItmPrice&arcim='+curarcim;
	
	//parent.frames['UDHCJFItmPrice'].location.href=lnk			
//}
function gettype()
{if (window.event.keyCode==13) 
	{
	  window.event.keyCode=117;
	  OrdType_lookuphandler();
	
	}
}
function getpath() {
		   
			var getpath=document.getElementById('getpath');
			if (getpath) {var encmeth=getpath.value} else {var encmeth=''};
		
			return path=cspRunServerMethod(encmeth,'','');
			
	}
function PrintARCIMPrice()
 	{  
 	    
	 	var xlApp,obook,osheet,xlsheet,xlBook,temp,str,vbdata,i,j
        var Template
        var k=0,l
        
       var path = getpath()
        Template=path+"UDHCJFArcimPrice.xls" ;
        xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet  
	    xlApp.visible=true;
	    var getnum=document.getElementById('getnum');
	    if (getnum) {var encmeth=getnum.value} else {var encmeth=''};
	    var row=1
	    var SelRowObj=document.getElementById('Tjobz'+row);
	    var CheckExternalCode=document.getElementById('CheckExternalCode');
	    //alert(CheckExternalCode);
	    var jj=SelRowObj.innerText;
	    //var jj=SelRowObj.value;
	    var p1=jj
	      xlsheet.cells(1,1)="医嘱名称"
	      xlsheet.cells(1,2)="医嘱别名"
	      xlsheet.cells(1,3)="医嘱价格"
	      xlsheet.cells(1,4)="收费代码"
	      xlsheet.cells(1,5)="收费名称"
	      xlsheet.cells(1,6)="数量"
	      xlsheet.cells(1,7)="价格"
	     if(CheckExternalCode.checked == true)
	     {
		  xlsheet.cells(1,8)="LIS代码"
	      xlsheet.cells(1,9)="组套名" 
	     }
	    var gnum=cspRunServerMethod(encmeth,'','',p1);
	     
               for (i=1;i<=gnum;i++)
	           {    
		           p3=i	          
		           
		           
		             var getdata=document.getElementById('getdata');
		             if (getdata) {var encmeth=getdata.value} else {var encmeth=''};
		             var str=cspRunServerMethod(encmeth,'','',p1,p3);
		             myData1=str.split("^")    
	                 xlsheet.cells(i+1,1)=myData1[1]
	                 xlsheet.cells(i+1,2)=myData1[9]
	                 xlsheet.cells(i+1,3)=myData1[3]
	                 xlsheet.cells(i+1,4)=myData1[11]
	                 xlsheet.cells(i+1,5)=myData1[5]
	                 xlsheet.cells(i+1,6)=myData1[6]
	                 xlsheet.cells(i+1,7)=myData1[7]
	                if(CheckExternalCode.checked == true)
	                  {
		               xlsheet.cells(i+1,8)=myData1[12]
	                    xlsheet.cells(i+1,9)=myData1[13]
	                  }
                }	       
	    //xlsheet.printout
	    //xlBook.Close (savechanges=false);
	    //xlApp.Quit();
	    //xlApp=null;
	    //xlsheet=null 
	   // 
	   // var killdata=document.getElementById('killdata');
	   //if (killdata) {var encmeth=killdata.value} else {var encmeth=''};
	   // var gnum=cspRunServerMethod(encmeth,'','');    
 	}
	
	
	
document.body.onload=BodyLoadHandler;