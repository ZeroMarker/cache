//
//
var currentRow;
function BodyLoadHandler()
{
	try{
		//不想用组建编辑器
		//zhouxin 2015-12-23
		Ext.Ajax.request({
			url : 'dhcst.stkcatgroupaction.csp?actiontype=selectAll',
			method : 'POST',
			success : function(result, request) {
				var tables=document.getElementsByTagName("table");
				var tr = document.createElement("tr");
				trhtml = "<td><P align=right>类组</p></td><td><select name='stkgrp'   style='WIDTH: 125px; HEIGHT: 28px'>"; 
				trhtml=trhtml+"<option value='0'></option>";
				var jsonData = Ext.util.JSON.decode(result.responseText);
				Ext.each(jsonData.rows, function(v2){
					trhtml=trhtml+"<option value="+v2.RowId+">"+v2.Desc+"</option>";
        		})
        		trhtml=trhtml+"</select></td><td></td>"
        		tr.innerHTML =trhtml
        		tables[1].appendChild(tr);
			}
		});		
    
	}catch(e){alert(e.message)} 
	
	var obj ;
	obj=document.getElementById("Clear") ;
	if (obj) obj.onclick=ClearClick; 
	obj=document.getElementById("Find") ;
	if (obj) obj.onclick=FindClick; 
	obj=document.getElementById("Close") ;
	if (obj) obj.onclick=CloseClick; 
	var obj=document.getElementById("Print") ;
	if (obj) obj.onclick=PrintClickZYD; 
	
	//obj=document.getElementById("DispCat") ;
	//if (obj) obj.onclick=SelectCat(obj); 
	obj=document.getElementById("t"+"dhcpha_dispstat") ;
	if (obj) obj.ondblclick=StatDblClick; 
	
	obj=document.getElementById("ShowInfo") ;
	if (obj) obj.onclick=ShowSelInfoClick;
    
    obj=document.getElementById("SelectAll"); 
	if (obj){obj.onclick=SelectAll;}
	
	obj=document.getElementById("SelectNone"); 
	if (obj){obj.onclick=SelectNone;}
    
	obj=document.getElementById("DispCat") ;
	if (obj) obj.onchange=setDispCatVal; 
	
	var obj=document.getElementById("DispLoc"); 
	if (obj) 
	{obj.onkeydown=popDispLoc;
	obj.onblur=DispLocCheck;
	} 
	
	var obj=document.getElementById("InciAlias"); 
	if (obj) 
	{obj.onkeydown=popInciAlias;
	 obj.onblur=InciAliasCheck;
	} 


	 var obj=document.getElementById("ByWard");  
	 if (obj) obj.onclick=HandleStatFlag;
	 var obj=document.getElementById("ByAdmLoc");
	 if (obj) obj.onclick=HandleStatFlag;						

	 PopulateDispCat();
	
	 obj=document.getElementById("BodyLoaded");
	 if (obj.value!=1)
	 {
		//GetDefLoc() ;
		setDefaultDate();
	 }
	 setBodyLoaded();
	}
function InciAliasCheck()
{
	// 2006-05-26
	var obj=document.getElementById("InciAlias");
	var obj2=document.getElementById("incirowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	
	}// 2006-05-26
function popInciAlias()
{ // 2006-05-26
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  InciAlias_lookuphandler();
		}
}//2006-05-26
	
function DispLocCheck()
{
	// 2006-05-26
	var obj=document.getElementById("DispLoc");
	var obj2=document.getElementById("displocrowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	
	}// 2006-05-26
function popDispLoc()
{ // 2006-05-26
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  DispLoc_lookuphandler();
		}
}//2006-05-26

function setBodyLoaded()
{
	var obj=document.getElementById("BodyLoaded") ;
	if (obj) obj.value=1;
}

function setDefaultDate()
{
	var t=today();
	var obj=document.getElementById("StartDate") ;
	if (obj) obj.value=t;
	var obj=document.getElementById("EndDate") ;
	if (obj) obj.value=t;
	}
function setDispCatVal()
{
	var obj1=document.getElementById("dispcatval");
	var obj2=document.getElementById("DispCat");
	obj1.value=obj2.value;
	}

function StatDblClick()
{  
  var row=DHCWeb_GetRowIdx(window) ;
  currentRow=row;
  if (row<1) return ;
  var obj=document.getElementById("ProcessID"+"z"+row) ;
  if (obj) var Pid=obj.value ;
   var obj=document.getElementById("AdmLocRowid"+"z"+row) ;
  if (obj) var AdmLocRowid=obj.value ;
  RetrieveAdmLocDisp(Pid,AdmLocRowid)
  
	}
///获取多个科室	
function ShowSelInfoClick()
{
	 
	var objPID=document.getElementById("ProcessID"+"z"+1) ;
    if (objPID) var pid=objPID.value ; 
    var objtbl=document.getElementById("t"+"dhcpha_dispstat") ;
    var tblrows=objtbl.rows.length-1 
    if (tblrows==0){return;}
    var strloc=""
	for (var i=1;i<=tblrows;i++)
	{	
	    var objselect=document.getElementById("Tselect"+"z"+i) ;
	    if (objselect.checked==false) {continue;}
	
	    var objlocrowid=document.getElementById("AdmLocRowid"+"z"+i) ;
	    var locrowid=objlocrowid.value
	    if (locrowid!=0)
	    {
		    if (strloc=="")
		    {
			    strloc=locrowid
		    }
		    else
		    {
			    strloc=strloc+"^"+locrowid
		    }
	    }
	    
	}
    RetrieveAdmLocDisp(pid,strloc)
    
}
function RetrieveAdmLocDisp(pno,admlocid)
{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispstatitm&ProcessID="+pno+"&AdmLocRowid="+admlocid;
	var obj=parent.frames['dhcpha.dispstatitm'].window.document.location.href=lnk;

	}

function SelectCat()
{
  var obj=document.getElementById("DispCat") ;
  if (obj) return obj.value ;
	
	}
function PopulateDispCat()
{	
	setCatList() ;
//	var obj=document.getElementById("DispCat") ;
	
 	//if (obj)
 //	{ 	
 //		obj.options.length=0;
 	//	var obj2=document.getElementById("DispCatString")
	//	if (obj2) 
	//	{ var cats=obj2.value ; }
	//	else {return ;}
	//	var data=cats.split("^") ;
		//
	//	obj.options[obj.options.length]=new Option("","");
	//	for (var i=0;i<data.length;i++)
	//	{	var s=data[i];
	//		ldata=s.split('-');
		//	obj.options[obj.options.length]=new Option (ldata[0],ldata[1]) ; 
	//	}
	//} 	
}
function ClearClick()
{
  //
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispstat"
	location.href=lnk;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispstatitm"
	parent.frames["dhcpha.dispstatitm"].location.href=lnk;
	
	
	}
function FindClick()
{
	if (CheckStatCon()==false) return ;
	
	var obj1=document.getElementById("dispcatval");
	var obj2=document.getElementById("DispCat");
	
	//
	//var obj=document.getElementById("StartDate");
	//if (obj) var sd=obj.value;
	//var obj=document.getElementById("EndDate");
	//if (obj) var ed=obj.value;
	//var obj=document.getElementById("displocrowid");
	//if (obj) var displocrowid=obj.value;
	//var obj=document.getElementById("dispcatval");
	//if (obj) var dispcatval=obj.value;
	//
	//dispcatval=SelectCat();

	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispstat&StartDate="+sd+"&EndDate="+ed+"&displocrowid="+displocrowid+"&dispcatval="+dispcatval
	//location.href=lnk;
	var obj=document.getElementById("dispcatval")
	Find_click();
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispstatitm"
	parent.frames["dhcpha.dispstatitm"].location.href=lnk;
	}
function CheckStatCon()
{
	var obj=document.getElementById("displocrowid")
	if (obj)
	{if (obj.value=="") 
		{ alert(t['NO_DISPLOC']) ;
			return false;}
		}
	var obj1=document.getElementById("StartDate")
	if (obj1)
	{if (obj1.value=="") 
		{ alert(t['NO_STARTDATE']) ;
			return false;}
		}		
	var obj2=document.getElementById("EndDate")
	if (obj2)
	{if (obj2.value=="") 
		{ alert(t['NO_ENDDATE']) ;
			return false;}
		}		
	if (DateStringCompare(obj1.value,obj2.value)==1)
	{	alert(t['INVALID_DATESCOPE']) ;
		return false ;
		}		
		
	}
	
function CloseClick()
{	
	parent.close();
	}
function DispLocLookUpSelect(str)
{
	var ss=str.split("^") ;
	  if ( ss.length>0) 
	  { 
		   var obj=document.getElementById("displocrowid") ;
		   if (obj) obj.value=ss[1] ; // rowid of the disp loc
	   }
}
function GetDefLoc()
{	
	var objBodyLoaded=document.getElementById("BodyLoaded") ;
	if (objBodyLoaded) BodyLoaded=objBodyLoaded.value;
	
	//alert(BodyLoaded);
	if (BodyLoaded!=1)
	{
		var userid=session['LOGON.USERID'] ;
		var obj=document.getElementById("mGetDefaultLoc") ;
		if (obj) {var encmeth=obj.value;} else {var encmeth='';}
		var ss=cspRunServerMethod(encmeth,'setDefLoc','',userid) ;
		objBodyLoaded.value=1;
	}
}
function setDefLoc(value)
{
	var defloc=value.split("^");
	if (defloc.length>0)
	var locdr=defloc[0] ;
	var locdesc=defloc[1] ;
	if (locdr=="") return ;
	var obj=document.getElementById("DispLoc") ;
	if (obj) obj.value=locdesc
	var obj=document.getElementById("displocrowid") ;
	if (obj) obj.value=locdr
	
}
function clearTmpCollGlobal()
{	var objtbl=document.getElementById("t"+"dhcpha_dispstat") ;
	
	if (objtbl) var cnt=getRowcount(objtbl)
	else return ;
	if (cnt<1) return ;

	var obj=document.getElementById("ProcessIDz"+1)
	if (obj) processid=obj.value;
	else return ;
	
	var obj=document.getElementById("mKillCollTmpGlobal") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var ss=cspRunServerMethod(encmeth,'','',processid) ;
}
function BodyBeforeUnLoadHandler()
{clearTmpCollGlobal();}
function AliasLookupSelect(str)
{	var inci=str.split("^");
	var obj=document.getElementById("incirowid");
	if (obj)
	{if (inci.length>0)   obj.value=inci[2] ;
		else  obj.value="" ;  
	 }

	}

function setCatList()
{   //according to definition,display the dispensing category and description
	var obj=document.getElementById("mGetDrugType") ;
	if (obj) {var encmeth=obj.value}
	else {var encmeth=''};
	
	var result=cspRunServerMethod(encmeth)  ;
	var drugGrps=result.split("!")
	var cnt=drugGrps.length
	var objDispCat=document.getElementById("DispCat") 
	objDispCat.options[0]=new Option ("","") ;
	for (i=0;i<cnt;i++) {
		
		var drugGrpCode=drugGrps[i].split("^");
		var code=drugGrpCode[0];
		var desc=drugGrpCode[1];
		
	objDispCat.options[objDispCat.options.length]=new Option (desc,code) ; 
	}
}
function PrintClick()
{
	//print the stat result data ....	
	var DOCU;
	var row ;
	var admlocrowid;
    
    var objtbl=document.getElementById("t"+"dhcpha_dispstat");
    var cnt=getRowcount(objtbl);
    if (cnt<=0) 
    {alert(t['NO_DATA'])
		return ;
	    }
    
    //row=DHCWeb_GetRowIdx(window) ;
	
	if (currentRow>0) 
	{  //begin to print in statitm 
		var recloc; 
		var admloc ;
		var rowcount ;
		DOCU=parent.frames['dhcpha.dispstatitm'].document;
		if (DOCU) {
			var objtbl=DOCU.getElementById("t"+"dhcpha_dispstatitm") ;
			if (objtbl) rowcount=getRowcount(objtbl) ; }
		if (rowcount>0)
		{	
			var prnpath=getPrnPath();
			var Template=prnpath+"DHCSTP_PhaDispStat.xls";
			var xlApp = new ActiveXObject("Excel.Application");
			var xlBook = xlApp.Workbooks.Add(Template);
			var xlsheet = xlBook.ActiveSheet ;
		    var startRow=6 ;
		
			var obj=document.getElementById("DispLoc") ;
			if (obj) recloc=obj.value;
			var obj=document.getElementById("StartDate") ;
			if (obj) sd=obj.value;
			var obj=document.getElementById("EndDate") ;
			if (obj) ed=obj.value;
			var obj=document.getElementById("AdmLocDesc"+"z"+currentRow) ;
			if (obj) 
			{var admloc=obj.innerText;
			//alert(admloc) 
			 }
			//set data into excel
			xlsheet.Cells(3,1).Value =t['PRN_PHALOC']+recloc;
			xlsheet.Cells(4,1).Value =t['PRN_ADMLOC']+admloc;
			xlsheet.Cells(3,4).Value =t['PRN_DATESCOPE']+sd+"--"+ed;
			xlsheet.Cells(4,4).Value =t['PRN_DATETIME']+getPrintDateTime();
			
			var i;
			var j
			j=startRow ;
			for (i=1;i<=rowcount;i++)
			{
				var obj=DOCU.getElementById("DispItmDesc"+"z"+i) ;
				if (obj) var itmdesc=obj.innerText;
				var obj=DOCU.getElementById("DispQty"+"z"+i) ;
				if (obj) var dispqty=obj.innerText;
				var obj=DOCU.getElementById("RetQty"+"z"+i) ;
				if (obj) var retqty=obj.innerText;
				var obj=DOCU.getElementById("Total"+"z"+i) ;
				if (obj) var totalqty=obj.innerText;
				var obj=DOCU.getElementById("Uom"+"z"+i) ;
				if (obj) var uom=obj.innerText;
				var obj=DOCU.getElementById("Amount"+"z"+i) ;
				if (obj) var amt=obj.innerText;
				//
				xlsheet.Cells(i+startRow,1).Value=itmdesc;
				xlsheet.Cells(i+startRow,2).Value=uom;
				xlsheet.Cells(i+startRow,3).Value=dispqty;
				xlsheet.Cells(i+startRow,4).Value=retqty;
				xlsheet.Cells(i+startRow,5).Value=totalqty;
				xlsheet.Cells(i+startRow,6).Value=amt;
				//
			
			}
		}
	}
	else
	{ alert(t['NO_DATA']) ; 
		return ;	}
		
	xlsheet.printout();
    SetNothing(xlApp,xlBook,xlsheet);		
		
}
function PrintClickHX()
{
	//print the stat result data ....	
	var DOCU;
	var row ;
	var admlocrowid;
    
    var objtbl=document.getElementById("t"+"dhcpha_dispstat");
    var cnt=getRowcount(objtbl);
    if (cnt<=0) 
    {alert(t['NO_DATA'])
		return ;
	    }
    
    //row=DHCWeb_GetRowIdx(window) ;
	
	if (currentRow>0) 
	{  //begin to print in statitm 
		var recloc; 
		var admloc ;
		var rowcount ;
		DOCU=parent.frames['dhcpha.dispstatitm'].document;
		if (DOCU) {
			var objtbl=DOCU.getElementById("t"+"dhcpha_dispstatitm") ;
			if (objtbl) rowcount=getRowcount(objtbl) ; }
		if (rowcount>0)
		{	
			var prnpath=getPrnPath();
			var Template=prnpath+"DHCSTP_PhaDispStat_HX.xls";
			var xlApp = new ActiveXObject("Excel.Application");
			var xlBook = xlApp.Workbooks.Add(Template);
			var xlsheet = xlBook.ActiveSheet ;
		    var startRow=5 ;
		
			var obj=document.getElementById("DispLoc") ;
			if (obj) recloc=obj.value;
			var recloc1=recloc.split("-")
		    var recloc=recloc1[1]
			var obj=document.getElementById("StartDate") ;
			if (obj) sd=obj.value;
			var obj=document.getElementById("EndDate") ;
			if (obj) ed=obj.value;
			var obj=document.getElementById("StartTime") ;
			if (obj) st=obj.value
			var obj=document.getElementById("EndTime") ;
			if (obj) et=obj.value
			var obj=document.getElementById("AdmLocDesc"+"z"+currentRow) ;
			if (obj) 
			{
			 var admloc=obj.innerText;
             if (admloc==t['TOTAL'])
			 {var admloc=""}
			 else
			 {var admloc1=admloc.split("-")
			  var admloc=admloc1[1]}
			
			 }
			 
			//set data into excel
			xlsheet.Cells(3,1).Value =t['PRN_PHALO']+recloc;
			xlsheet.Cells(4,1).Value =t['PRN_ADMLOC']+admloc;
			xlsheet.Cells(3,8).Value =t['PRN_DATESTAR']+sd+" "+st;
			xlsheet.Cells(4,8).Value =t['PRN_DATEEN']+ed+" "+et;
			//xlsheet.Cells(4,4).Value =t['PRN_DATETIME']+getPrintDateTime();
			
			var cols=11
	        var Rows=objtbl.rows.length;   
	        //<---------------------- add by lq -------------
	        for (i=1;i<=Rows-2;i++)
            {  
            	for (j=1;j<=cols;j++)
       	        { 
       	  
	  		       xlsheet.Cells(i+startRow,j).Borders(9).LineStyle = 1;    
	       	       xlsheet.Cells(i+startRow,j).Borders(7).LineStyle = 1;    
	      	       xlsheet.Cells(i+startRow,j).Borders(10).LineStyle = 1;   
	       	       xlsheet.Cells(i+startRow,j).Borders(8).LineStyle = 1;    
	 	       	   xlApp.ActiveSheet.Cells(i+startRow,j).HorizontalAlignment = 3;
       	        }
            }
			//------------------------------------->
			var i;
			var j
			j=startRow ;
			for (i=1;i<=rowcount;i++)
			{
				var obj=DOCU.getElementById("DispItmDesc"+"z"+i) ;
				if (obj) var itmdesc=obj.innerText;
				var obj=DOCU.getElementById("DispQty"+"z"+i) ;
				if (obj) var dispqty=obj.innerText;
				var obj=DOCU.getElementById("RetQty"+"z"+i) ;
				if (obj) var retqty=obj.innerText;
				var obj=DOCU.getElementById("Total"+"z"+i) ;
				if (obj) var totalqty=obj.innerText;
				var obj=DOCU.getElementById("Uom"+"z"+i) ;
				if (obj) var uom=obj.innerText;
				var obj=DOCU.getElementById("Amount"+"z"+i) ;
				if (obj) var amt=obj.innerText;
				//<---------------------- add by lq -------------
				var obj=DOCU.getElementById("TPhcfDesc"+"z"+i) ;
				if (obj) var rPhcfDesc=obj.innerText;
				var obj=DOCU.getElementById("TManf"+"z"+i) ;
				if (obj) var rmanf=obj.innerText;
				var obj=DOCU.getElementById("TBarcode"+"z"+i) ;
				if (obj) var BarCode=obj.innerText;
				var obj=DOCU.getElementById("TPhciprice"+"z"+i) ;
				if (obj) var phciprice=obj.innerText;
				
				var tmpitm=itmdesc.split("(")
				itmdesc=tmpitm[0];
				xlsheet.Cells(i+startRow,2).Value=itmdesc;
				xlsheet.Cells(i+startRow,3).Value=BarCode;
				xlsheet.Cells(i+startRow,4).Value=rPhcfDesc;
				xlsheet.Cells(i+startRow,5).Value=rmanf;
				xlsheet.Cells(i+startRow,6).Value=uom;
				xlsheet.Cells(i+startRow,7).Value=dispqty;
				xlsheet.Cells(i+startRow,8).Value=retqty;
				xlsheet.Cells(i+startRow,9).Value=totalqty;
				xlsheet.Cells(i+startRow,10).Value=phciprice;
				xlsheet.Cells(i+startRow,11).Value=amt;
			
				//
			
			}
			for (i=1;i<=rowcount-1;i++)
			{
			  xlsheet.Cells(i+startRow,1).Value=i  //编号
			}
			//---------------------- ------------->
		
		}
	}
	else
	{ alert(t['NO_DATA']) ; 
		return ;	}
		
    	
	xlsheet.printout();
    SetNothing(xlApp,xlBook,xlsheet);		
}

function PrintClickZYD()
{
	  //print the stat result data ....	
		var DOCU;
		var row ;
		var admlocrowid;
  
	  //begin to print in statitm 
		var recloc; 
		var admloc ;
		var rowcount ;
		var tmpward="";
		DOCU=parent.frames['dhcpha.dispstatitm'].document;
		if (DOCU) 
		{
			var objtbl=DOCU.getElementById("t"+"dhcpha_dispstatitm") ;
			if (objtbl) rowcount=getRowcount(objtbl) ;
		}
		if (rowcount<=0) 
        {
            alert(t['NO_DATA'])
	        return ;
        }
	
		var prnpath=getPrnPath();
		var Template=prnpath+"DHCSTP_PhaDispStat_ZYD.xls";
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);
		var xlsheet = xlBook.ActiveSheet ;
	    var startRow=2 ;
	
		var obj=document.getElementById("DispLoc") ;
		if (obj) recloc=obj.value;
		var recloc1=recloc.split("-")
	    var recloc=recloc1[1]
		var obj=document.getElementById("StartDate") ;
		if (obj) sd=obj.value;
		var obj=document.getElementById("EndDate") ;
		if (obj) ed=obj.value;
		var obj=document.getElementById("StartTime") ;
		if (obj) st=obj.value
		var obj=document.getElementById("EndTime") ;
		if (obj) et=obj.value
		var obj=document.getElementById("AdmLocDesc"+"z"+currentRow) ;
		if (obj) 
		{
		 var admloc=obj.innerText;
         if (admloc==t['TOTAL'])
		 {var admloc=""}
		 else
		 {var admloc1=admloc.split("-")
		  var admloc=admloc1[1]}
		
		 }
		var cols=11
		var i;
		var j
		var h=1;
		j=startRow ;
		for (i=1;i<=rowcount-1;i++)
		{
			var obj=DOCU.getElementById("DispItmDesc"+"z"+i) ;
			if (obj) var itmdesc=obj.innerText;
			var obj=DOCU.getElementById("DispQty"+"z"+i) ;
			if (obj) var dispqty=obj.innerText;
			var obj=DOCU.getElementById("RetQty"+"z"+i) ;
			if (obj) var retqty=obj.innerText;
			var obj=DOCU.getElementById("Total"+"z"+i) ;
			if (obj) var totalqty=obj.innerText;
			var obj=DOCU.getElementById("Uom"+"z"+i) ;
			if (obj) var uom=obj.innerText;
			var obj=DOCU.getElementById("Amount"+"z"+i) ;
			if (obj) var amt=obj.innerText;
			var obj=DOCU.getElementById("TPhcfDesc"+"z"+i) ;
			if (obj) var rPhcfDesc=obj.innerText;
			var obj=DOCU.getElementById("TManf"+"z"+i) ;
			if (obj) var rmanf=obj.innerText;
			var obj=DOCU.getElementById("TBarCode"+"z"+i) ;
			if (obj) var BarCode=obj.innerText;
			var obj=DOCU.getElementById("TPhciPrice"+"z"+i) ;
			if (obj) var phciprice=obj.innerText;
			var obj=DOCU.getElementById("Tward"+"z"+i) ;
			if (obj) var ward=obj.innerText;
			var obj=DOCU.getElementById("TTotalUom"+"z"+i) ;
			if (obj) var TotalQtyUom=obj.innerText;

			if ((tmpward!=ward)&&(trim(ward)!=""))
			{
				startRow=startRow+4
			    xlsheet.Cells(i+startRow-2,1).Value="病区:"+ward+"   "+"开始日期:"+sd+" "+st+"   "+"结束日期:"+ed+" "+et
				xlsheet.Cells(i+startRow-1,1).Value="序号"
				xlsheet.Cells(i+startRow-1,2).Value="药品名称"
				xlsheet.Cells(i+startRow-1,3).Value="规格"
				xlsheet.Cells(i+startRow-1,4).Value="剂型"
				xlsheet.Cells(i+startRow-1,5).Value="厂家"
				xlsheet.Cells(i+startRow-1,6).Value="单位"
				xlsheet.Cells(i+startRow-1,7).Value="发药数量"
				xlsheet.Cells(i+startRow-1,8).Value="退药数量"
				xlsheet.Cells(i+startRow-1,9).Value="合计数量"
				xlsheet.Cells(i+startRow-1,10).Value="药品单价"
				xlsheet.Cells(i+startRow-1,11).Value="药品金额"
				for (j=1;j<=cols;j++)
	   	        { 
	  		       xlsheet.Cells(i+startRow-1,j).Borders(9).LineStyle = 1;    
	       	       xlsheet.Cells(i+startRow-1,j).Borders(7).LineStyle = 1;    
	      	       xlsheet.Cells(i+startRow-1,j).Borders(10).LineStyle = 1;   
	       	       xlsheet.Cells(i+startRow-1,j).Borders(8).LineStyle = 1;    
	 	       	   xlApp.ActiveSheet.Cells(i+startRow-1,j).HorizontalAlignment = 3;
	   	        }
				h=1
			}
			
			for (j=1;j<=cols;j++)
   	        { 
   	  
  		       xlsheet.Cells(i+startRow,j).Borders(9).LineStyle = 1;    
       	       xlsheet.Cells(i+startRow,j).Borders(7).LineStyle = 1;    
      	       xlsheet.Cells(i+startRow,j).Borders(10).LineStyle = 1;   
       	       xlsheet.Cells(i+startRow,j).Borders(8).LineStyle = 1;    
 	       	   xlApp.ActiveSheet.Cells(i+startRow,j).HorizontalAlignment = 3;
   	        }
			//
		    var tmpitm=itmdesc.split("(")
			itmdesc=tmpitm[0];
			xlsheet.Cells(i+startRow,1).Value=h  //编号
			xlsheet.Cells(i+startRow,2).Value=itmdesc;
			xlsheet.Cells(i+startRow,3).Value=BarCode;
			xlsheet.Cells(i+startRow,4).Value=rPhcfDesc;
			xlsheet.Cells(i+startRow,5).Value=rmanf;
			xlsheet.Cells(i+startRow,6).Value=uom;
			xlsheet.Cells(i+startRow,7).Value=dispqty;
			xlsheet.Cells(i+startRow,8).Value=retqty;
			xlsheet.Cells(i+startRow,9).Value=TotalQtyUom;
			xlsheet.Cells(i+startRow,10).Value=phciprice;
			xlsheet.Cells(i+startRow,11).Value=amt;
			
			var tmpward=ward
			h=h+1

	    }

			xlsheet.printout();
		    SetNothing(xlApp,xlBook,xlsheet);		
}

function getPrnPath()
{
	var obj=document.getElementById("mGetPrnPath") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	prnpath=cspRunServerMethod(encmeth,'','') ;
	return prnpath
}
function SetNothing(app,book,sheet)
{
	app=null;
	book.Close(savechanges=false);
	sheet=null;
}
/*
function HandleStatFlag(e)
{  var obj=websys_getSrcElement(e)
   //alert(obj.id)
	}
	*/

function HandleStatFlag(e)
  {  
   //according to user selection, make the display between checkbox
   //
   var obj=websys_getSrcElement(e)
	  var obj2=document.getElementById("statflag")
   
   if  (obj.id=="ByWard" )
   {
	   var objx=document.getElementById("ByAdmLoc")
	   if (objx){objx.checked=!obj.value}
	   if (obj.checked) obj2.value="1" ;
	   else obj2.value="0"
	   }
   if  (obj.id=="ByAdmLoc" )
   {
	   var objx=document.getElementById("ByWard")
	   if (objx){objx.checked=!obj.value}
	   if (obj.checked) obj2.value="0" ;
	   else obj2.value="1"
	   }
   }

function SelectAll()
{
 
  var rowcnt;
  var objtbl=document.getElementById("t"+"dhcpha_dispstat")  
  if (objtbl){rowcnt=getRowcount(objtbl) }	
  if (rowcnt>0)
  {
	  for (i=1;i<=rowcnt-1;i++)
	  {
		  var obj=document.getElementById("Tselect"+"z"+i)
		  if (obj) obj.checked=true ;  
	  }
   }		
}
function SelectNone()
{
  var rowcnt;
  var objtbl=document.getElementById("t"+"dhcpha_dispstat")  
  if (objtbl){rowcnt=getRowcount(objtbl) }	
  if (rowcnt>0)
  {
	  for (i=1;i<=rowcnt-1;i++)
	  {
		  var obj=document.getElementById("Tselect"+"z"+i)
		  if (obj) obj.checked=false ;  
	  }
   }	 
}

	
document.body.onload=BodyLoadHandler;
document.body.onbeforeunload=BodyBeforeUnLoadHandler;
