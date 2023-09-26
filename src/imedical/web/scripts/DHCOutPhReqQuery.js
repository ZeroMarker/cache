// DHCOutPhReqQuery
//
var currRow="";

function BodyLoadHandler()
{
  var obj=document.getElementById("Print")
  if (obj) obj.onclick=PrintReq;
  var obj=document.getElementById("Clear")
  if (obj) obj.onclick=Clear;
  
  var obj=document.getElementById("PaNo")
  if (obj) 
  {obj.onblur=GetPaInfo;
   obj.onkeydown=setPa;
  }

	var obj=document.getElementById("Loc"); 
	if (obj) 
	{obj.onkeydown=popLoc;
	 obj.onblur=LocCheck;
	} 
	ReloadItems();
	    
  //自动查找
 // var obj=document.getElementById("Find")
  //if (obj) obj.click();
}
function popLoc()     
{ 
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
		window.event.isLookup=true
	  	Loc_lookuphandler(window.event);
	}
}
function LocCheck()
{// 
	var obj=document.getElementById("Loc");
	var obj2=document.getElementById("displocRowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
}//
function DispLocLookUpSelect(str)
{
	var ss=str.split("^") ;
	if ( ss.length>0) 
	{ 
	var obj=document.getElementById("displocRowid") ;
	if (obj) obj.value=ss[1] ; // rowid of the disp loc
	}
}
function setPa()
{
	if (window.event.keyCode==13) 
	{  //window.event.keyCode=117;
	   GetPaInfo();
	}	
}
function GetPaInfo()
{
	var exe="";
	var obj=document.getElementById("mGetPaInfo");
	if (obj){ exe=obj.value;} else {exe="";return;} 
	
	var pmiobj=document.getElementById("PaNo");
	var pano=trim(pmiobj.value);
  	
	if (pano=="") {
		SetPaInfo("");
		return;
		}
	else
	{
		var plen=pmiobj.value.length;
		var i;
		var lszero="";
		if (plen==0){      return ;}
		if (plen>10){ return;}
		 for (i=1;i<=10-plen;i++)
		  {
		 	 lszero=lszero+"0"  
			 }
		 var pano=lszero+pano;
		 //alert(pano);
		 pmiobj.value=pano;
	}
	
   var ret=cspRunServerMethod(exe,"SetPaInfo","",pano);
   	
	
}
function SetPaInfo(str)
{

  if (str=="")
  {
 	  var obj=document.getElementById("PaInfo");
	  if (obj) obj.value=""; //+ " " +age ;
	  }
  else
  {
	  ss=str.split("^")
	  var paname=ss[0];
	  var sex=ss[1];
	  //var age=ss[2];
	  
	  var obj=document.getElementById("PaInfo");
	  if (obj) obj.value=paname+" " + sex ; //+ " " +age ;
  }
  
	
}
function Retrieve()
{
    ReloadItems();
	obj=document.getElementById("Find");
	if (obj) 
	{
	obj.click();
	}
}

function PrintReq()
{
	//打印申请单
	try{
	if (currRow=="") return;
	var HospDesc=tkMakeServerCall("web.DHCSTKUTIL","GetHospName",session['LOGON.HOSPID'])
	var obj=document.getElementById("paname"+"z"+currRow)
	if (obj)
	{var patname=obj.innerText;}
	else { return;}
	var obj=document.getElementById("pano"+"z"+currRow)
	if (obj)
	{var pmino=obj.innerText;}
	else { return;}
	var invNo="";
	var obj=document.getElementById("invNo"+"z"+currRow)
	if (obj)	{invNo=obj.innerText;}
	var username="";
	var obj=document.getElementById("userName"+"z"+currRow)
	if (obj)	{username=obj.innerText;}
	
	//var sysdate=getPrintDate();
	var retreas="";
	var obj=document.getElementById("reason"+"z"+currRow)
	if (obj)	{retreas=obj.innerText;}
	var obj=document.getElementById("reqDate"+"z"+currRow) //申请日期
	var reqdate=obj.innerText;
	var phaloc="";
	var obj=document.getElementById("dispLoc"+"z"+currRow);
	if (obj)	{phaloc=obj.innerText;}

	var admloc="";
	var obj=document.getElementById("ordDeptLoc"+"z"+currRow);
	if (obj)	{admloc=obj.innerText;}
	
	var reqcode=document.getElementById("reqCode"+"z"+currRow).innerText
	
	
	var getmethod=document.getElementById('printpath');
	if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
	var path=cspRunServerMethod(encmeth)
      	
	var xlApp,obook,osheet,xlsheet,xlBook
	var Template=path+"yftysqd.xls";
	//Template="e:\\yftysqd.xls"
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet ;
	
	//var prtinv=document.getElementById('TPrtInvz'+1).innerText;
	
	xlsheet.cells(1,1).value=HospDesc+"退药申请单"+"(补打)"

	xlsheet.cells(2,2).value=patname
    xlsheet.cells(2,5).value=pmino
    xlsheet.cells(3,2).value=invNo
    xlsheet.cells(3,5).value=retreas 
    
    xlsheet.cells(4,2).value=phaloc
	xlsheet.cells(4,5).value=reqcode
	xlsheet.cells(5,2).value=username
	xlsheet.cells(5,5).value=reqdate
	            
	                 
	xlsheet.cells(7,1).value="药品名称"
	xlsheet.cells(7,2).value="申请数量"
	xlsheet.cells(7,3).value="单位"
	xlsheet.cells(7,4).value="单价"
	xlsheet.cells(7,5).value="金额"
	
	var docu=parent.frames['DHCOutPhReqQueryItm'].document;
	
	if (docu)
	{
		var rownum ,i,j=0;
		objtbl=docu.getElementById("t"+'DHCOutPhReqQueryItm');
		var rows=objtbl.rows.length-1;
		var money=0,rr=0;
		for (i=1;i<=rows;i++)
		{
			j=j+1;
			//var reqcode=document.getElementById('TReqCodez'+i).innerText
			
			var reqqty=docu.getElementById('reqQty'+"z"+i).innerText;
			
			var arcimDesc=docu.getElementById('arcimDesc'+"z"+i).innerText;
			//var sp=docu.getElementById('sp'+"z"+i).value;

			var reqUom=docu.getElementById("uom"+"z"+i).innerText;
				
			//xlsheet.cells(7+j,1).value=arcimDesc;
			//xlsheet.cells(7+j,3).value=reqqty+" " + reqUom;
			
			// xlsheet.cells(6+j,4).value=document.getElementById('TBatCodez'+i).innerText
			//xlsheet.cells(6+i,5).value=sysdate
			//PHLDesc=document.getElementById('TPhLocDescz'+i).innerText
			//pc[reqcode]=1
			
			var evMoney=docu.getElementById('reqAmt'+"z"+i).innerText
			money=eval(money)+eval(evMoney);
			money=parseFloat(money).toFixed(2);
			var phprice=docu.getElementById('sp'+"z"+i).innerText
			
			
		    xlsheet.cells(7+i,1).value=arcimDesc
	        xlsheet.cells(7+i,2).value=reqqty
	        xlsheet.cells(7+i,3).value=reqUom
	        xlsheet.cells(7+i,4).value=phprice
	        xlsheet.cells(7+i,5).value=money
		        
		        
		        
		}		
		 xlsheet.cells(9+rows,1).value="药房主任意见:"+"                  签字:        日期:"		
	}
	else	{return;}
	
	xlsheet.printout;
	xlBook.Close(savechanges=false);
	xlApp=null;
	xlsheet=null;
	}
	catch(e)
	{
		alert(e.message)
	}
}
function Clear()
{
	//清空界面
	obj=document.getElementById("StartDate");
	if (obj) obj.value="";
	obj=document.getElementById("EndDate");
	if (obj) obj.value="";
	obj=document.getElementById("displocRowid");
	if (obj)  obj.value="";
	obj=document.getElementById("Loc");
	if (obj)  obj.value="";
	obj=document.getElementById("thePrt");
	if (obj)  obj.value="";
	obj=document.getElementById("PrescNo");
	if (obj)  obj.value="";
	obj=document.getElementById("PaNo");
	if (obj)  obj.value="";
	obj=document.getElementById("PaInfo");
	if (obj)  obj.value="";
	
	ReloadItems();
	obj=document.getElementById("Find");
	if (obj) obj.click();
	
	//DHCOutPhWeb_setfocus("PaNo");
	
	currRow="";
}

function SelectRowHandler(value)
{
	var objtbl=document.getElementById("t"+"DHCOutPhReqQuery");
	if (objtbl)
	{currRow=DHCOutPhWeb_GetRowIdx(this);}
	//
	if (currRow>0) 
	{
		var req="";
		var obj=document.getElementById("req"+"z"+currRow);
		if (obj)
		{
			req=obj.value;
			//alert(req);
			//检索明细
			var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhReqQueryItm"+"&req="+req;
			parent.frames["DHCOutPhReqQueryItm"].document.location.href=lnk;
		}
		
	}
	
}
function ReloadItems()
{		
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhReqQueryItm";
	parent.frames["DHCOutPhReqQueryItm"].document.location.href=lnk;
}
document.body.onload=BodyLoadHandler;