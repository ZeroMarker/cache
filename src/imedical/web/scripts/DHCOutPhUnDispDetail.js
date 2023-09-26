
var idTmr=""

function BodyLoadHandler()
{
	var prtobj=document.getElementById("print")
	if (prtobj) prtobj.onclick=print_Click;
	
}

function print_Click()
{
	   
	   var objtbl=document.getElementById("t"+"DHCOutPhUnDispDetail")
       if(objtbl){
	       
			   var cnt=objtbl.rows.length-1;
			   if (!(cnt>0)){alert("没有打印内容"); return ;}
			   var gPrnpath=GetPrintPath();
			   if (gPrnpath=="") 
			       {
			        	alert("获取打印路径失败") ;
			            return ;
			       }
                var Template=gPrnpath+"DHCOut_UnDispDetail_LF.xls";
				//var Template="C:\\DHCOut_UnDispDetail_LF.xls";
		        var xlApp = new ActiveXObject("Excel.Application");
		        var xlBook = xlApp.Workbooks.Add(Template);
		        var xlsheet = xlBook.ActiveSheet ; 

		        if (xlsheet==null) 
			    {       
			    	alert("没有找到打印模板");
			        return ;                
			    }
			   var objPid= document.getElementById("Tpid"+"z"+1)
			   pid=objPid.value
			   var prtnum=GetDetailNum(pid)   
			   var startNo=4;
			   
			   var objsd= document.getElementById("sdate")
			   if (objsd) var sdate=objsd.value;
			   
			   var objed= document.getElementById("edate")
			   if (objed) var edate=objed.value;
			   xlsheet.Cells(3, 2).Value =sdate ;
			   xlsheet.Cells(3, 5).Value =edate ;
			   for (i=1;i<=prtnum;i++)
			   {
				   var retstring=GetDetailString(pid,i)
				   var arr=retstring.split("^")
				   
				   var no=arr[0]
				   var name=arr[1]
				   var patno=arr[2]
				   var pydate=arr[3]
				   var price=arr[4]
				   var pyname=arr[5]
				   var reason=arr[7]
				   var incidesc=arr[9]
				   var uom=arr[10]
				   var qty=arr[11]
				   var money=arr[12]
				   var optype=arr[13]
				   if (i==1)var loc=arr[14]
				   
								   
                    xlsheet.Cells(startNo+i, 1).Value =no ;
                    xlsheet.Cells(startNo+i, 2).Value =name;
                    xlsheet.Cells(startNo+i, 3).Value =patno;    
                    xlsheet.Cells(startNo+i, 4).Value =pydate;
                    xlsheet.Cells(startNo+i, 5).Value =incidesc;  
                    xlsheet.Cells(startNo+i, 6).Value =uom;    
                    xlsheet.Cells(startNo+i, 7).Value =qty;
                    xlsheet.Cells(startNo+i, 8).Value =price;
			        xlsheet.Cells(startNo+i, 9).Value =money;
			        xlsheet.Cells(startNo+i, 10).Value =reason;
			        xlsheet.Cells(startNo+i, 11).Value =optype;
				   
				    if (i<prtnum) setBottomLine(xlsheet,startNo+i,1,11);
				   
			   }
			   
			   xlsheet.Cells(3, 9).Value =loc ;
			   xlsheet.printout();
			   
			   xlApp=null;
		       xlsheet=null;
		       xlBook.Close(savechanges=false);
		       window.setInterval("Cleanup();",1); 

         }
         
         
         
	  
}

function GetDetailNum(pid)
{
	   var obj=document.getElementById("mGetDetailNum")
	   if (obj) {exe=obj.value;} else {exe='';}
	   var cnt=cspRunServerMethod(exe,pid)
	   return cnt
}

function GetDetailString(pid,i)
{
	   var obj=document.getElementById("mListDetail")
	   if (obj) {exe=obj.value;} else {exe='';}
	   var retstring=cspRunServerMethod(exe,pid,i)
	   return retstring
}

function GetPrintPath()
{
	
	var obj=document.getElementById("mGetPrnPath") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	gPrnpath=cspRunServerMethod(encmeth,'','') ;
	
	return gPrnpath
}


function Cleanup() 
{   
    window.clearInterval(idTmr);   
    CollectGarbage();   
}

document.body.onbeforeunload=function(){
	
   var objtbl=document.getElementById("t"+"DHCOutPhUnDispDetail")
   if(objtbl){
	   var cnt=objtbl.rows.length-1;
	   if (cnt>0){
	   var objPid= document.getElementById("Tpid"+"z"+1)
	   pid=objPid.value
       var exe
	   var obj=document.getElementById("mKillBeforeLoad")
	   if (obj) {exe=obj.value;} else {exe='';}
	   var sss=cspRunServerMethod(exe,pid)
	            }
       }
 } 
 
 


document.body.onload=BodyLoadHandler;