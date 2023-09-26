
var objstartdate;
var objenddate;
var objdisploc;
var idTmr=""

function BodyLoadHandler()
{
	
	var obj=document.getElementById("Find")
	if (obj) obj.onclick=FindDispData;
	var obj=document.getElementById("Exit")
	if (obj) obj.onclick=Exit;
	var obj=document.getElementById("Print")
	if (obj) obj.onclick=PrnHX; //������Ժ --- ��ĳ��ʱ��ͳ��
	//if (obj) obj.onclick=PrnBJFC; //�������� --- �����ҩͳ��
	var obj=document.getElementById("Clear")
	if (obj) obj.onclick=ClearClick;
	
	var objPoison=document.getElementById("Poison");
	if (objPoison) 
	{	
		objPoison.onkeydown=popPoison;
	 	objPoison.onblur=PoisonCheck;
	} 
	
	var objInciCat=document.getElementById("IncStkCat");
	if (objInciCat) 
	{	
		objInciCat.onkeydown=popInciCat;
	 	objInciCat.onblur=InciCatCheck;
	} 
	
	objstartdate=document.getElementById("StartDate")
	objenddate=document.getElementById("EndDate")
	objdisploc=document.getElementById("DispLocRowid")
	
	var obj=document.getElementById("Alias"); 
	if (obj) 
	{obj.onkeydown=popAlias;
	 obj.onblur=AliasCheck;
	}
    var obj=document.getElementById("AdmLoc"); 
	if (obj) 
	{obj.onkeydown=popAdmLoc;
	 obj.onblur=AdmLocCheck;
	}
	var objInciCatStr=document.getElementById("IncStkCatStr");
	if (objInciCatStr)
	{ 
	 	setIncCatList();
	}
}
function IncCatListRowidChanged()
{	
	var objlist=document.getElementById("IncStkCatStr");
	var obj=document.getElementById("IncStkCatRowid");
	
	if (obj)obj.value=''
	else return;
	
	if(objlist)
	{
		for (i=0;i<objlist.length;i++)
		{
			if (objlist.options[i].selected==true)
			{
				if (obj.value=="")
				{	obj.value=objlist[i].value;}
				else
				{	obj.value=obj.value+"^"+objlist[i].value;}				
			}
		}
	}
}
function setIncCatList()
{   
	
	var objGetIncStkCat=document.getElementById("mGetIncStkCat");
	if (objGetIncStkCat) {var encmeth=objGetIncStkCat.value;}
	else {var encmeth=''};

	var result=cspRunServerMethod(encmeth)  ;
	
	var catstr=result.split("!")
	var cnt=catstr.length
	
	var objStkCat=document.getElementById("IncStkCatStr") 
	if (objStkCat)
	{
		objStkCat.options.length=0;
		
		for (i=0;i<cnt;i++) 
		{
			var tmpcat=catstr[i].split("^");
			var rowid=tmpcat[0];
			var desc=tmpcat[1];
		
			objStkCat.options[i]=new Option (desc,rowid) ;
		}
	}
}
function AdmLocCheck()
{
	
	var obj=document.getElementById("AdmLoc");
	var obj2=document.getElementById("admlocrowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	
	}
function popAdmLoc()
{ 
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  AdmLoc_lookuphandler();
		}
}
function AdmLocLookUpSelect(str)
{ var loc=str.split("^");
  var obj=document.getElementById("admlocrowid");
  if (obj)
  {if (loc.length>0)   obj.value=loc[1] ;
    else
       obj.value="" ;  
  	 }

}
function AliasCheck()
{
	var obj=document.getElementById("Alias");
	var obj2=document.getElementById("incirowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	
	}
function popAlias()
{ 
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  Alias_lookuphandler();
		}
}

function AliasLookupSelect(str)
{	var inci=str.split("^");
	var obj=document.getElementById("incirowid");
	if (obj)
	{if (inci.length>0)   obj.value=inci[2] ;
		else  obj.value="" ;  
	 }

	}
function popPoison()
{ 
	//2007-08-04,zdm
	if (window.event.keyCode==13) 
	{ 
		window.event.keyCode=117;
	  	Poison_lookuphandler();
	}
}
function PoisonCheck()
{
	// 2007-08-4,zdm
	var obj=document.getElementById("Poison");
	var obj2=document.getElementById("PoisonRowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	
}

function popInciCat()
{ 
	//2007-08-04,zdm
	if (window.event.keyCode==13) 
	{ 
		window.event.keyCode=117;
	  	IncStkCat_lookuphandler();
	}
}

function InciCatCheck()
{
	// 2007-08-4,zdm
	var obj=document.getElementById("IncStkCat");
	var obj2=document.getElementById("IncStkCatRowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	
}

function ClearClick()
{
	
	KillTmpPrintDM2();
	ReloadWinow();
}

function ReloadWinow()
{	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispstatDM" ;
	location.href=lnk;
}

function FindDispData()
{
	
	if (checkQueryCondition()==false)
	{return };
	var posdesc=document.getElementById("Poison").value
	
	if ((posdesc=="")||(posdesc==null))
	{
		alert("��ѡ����Ʒ��࣡");
		return;
	}
	IncCatListRowidChanged();
	Find_click();
}


function Exit()
{
	
	KillTmpPrintDM2();
	history.back();

}


function KillTmpPrintDM2()
{
	var obj=document.getElementById('Tpidz'+1)
	if (obj){
    var pid=obj.value
    var obj=document.getElementById("KillTmpPrintDM2") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var str=cspRunServerMethod(encmeth,pid)}
	
}


function checkQueryCondition()
{ 
  if (objstartdate=="") 
  { alert(t['NOSTARTDATE']) ;
    return false;
  }
  if (objenddate=="") 
  { alert(t['NOENDDATE']) ;
    return false;
  }
  if (objdisploc=="") 
  { alert(t['NODISPLOC']) ;
    return false;
  }
 if (DateStringCompare(objstartdate.value,objenddate.value )==1) 
	 {alert(t['INVALID_DATESCOPE']);
	 return  false ;}
 return true	
}
function DispLocLookUpSelect(str)
{ 
	var loc=str.split("^");
	var obj=document.getElementById("DispLocRowid");
	if (obj)
	{if (loc.length>0)   obj.value=loc[1] ;
		else	obj.value="" ;  
	}
}

function IncStkCatLookUpSelect(str)
{ 
	var cat=str.split("^");
	var obj=document.getElementById("IncStkCatRowid");
	if (obj)
	{if (cat.length>0)   obj.value=cat[1] ;
		else	obj.value="" ;  
	}
}

function Prn()
{
    var cnt=0 ;
    var obj=document.getElementById("T"+"dhcpha_dispstatDM")
    if (obj)
    {
	    cnt=getRowcount(obj); }
    if (cnt>0)
    {
		var prnpath=getPrnPath();
		if (prnpath=="") {
			alert(t['CANNOT_FIND_PRNPATH']) ;
			return ;
			}
		var Template=prnpath+"STP_DailyPrint_DM.xls";
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);
		var xlsheet = xlBook.ActiveSheet ;	
		var startrow=4 ; 
		if (xlsheet==null)
			{ alert(t['CANNOT_CREATE_PRNOBJECT']) ;
			return ;		  }
		var hospname=hospitalName();

		xlsheet.Cells(1,1)=hospname+t['PRN_TITILE']

		for (var row=1;row<=cnt;row++)
		{
			var date=getVal(row,"TDate")
			var regno=getVal(row,"TRegNo")
			var name=getVal(row,"TPaName")
			var sex=getVal(row,"TSex")
			var age=getVal(row,"TAge")
			var personid=getVal(row,"TIDNO")
			var diagnose=getVal(row,"TDiagNose")
			var prescno=getVal(row,"TPrescNo")
			var desc=getVal(row,"TDrugDesc")
			//var uom=getVal(row,"")
			var qty=getVal(row,"TQty")
			var batno=getVal(row,"TDrugBatchNo")
			var instruction=getVal(row,"TInstruction")
			var freq=getVal(row,"TFreq")
			var doseqty=getVal(row,"TDoseQty")
			var admloc=getVal(row,"TAdmLoc")
			var doctor=getVal(row,"TDoctor")
			var disp=getVal(row,"TDispUser")
			var remark=getVal(row,"TRem")
			var amt=getVal(row,"TAmt")
			
			xlsheet.Cells(startrow-1+row,1)=date
			xlsheet.Cells(startrow-1+row,2)=regno
			xlsheet.Cells(startrow-1+row,3)=name
			xlsheet.Cells(startrow-1+row,4)=sex
			xlsheet.Cells(startrow-1+row,5)=age
			xlsheet.Cells(startrow-1+row,6)=personid
			xlsheet.Cells(startrow-1+row,7)=diagnose
			xlsheet.Cells(startrow-1+row,8)=prescno
			xlsheet.Cells(startrow-1+row,9)=desc
			xlsheet.Cells(startrow-1+row,10)=qty
			xlsheet.Cells(startrow-1+row,11)=batno
			xlsheet.Cells(startrow-1+row,12)=instruction
			xlsheet.Cells(startrow-1+row,13)=freq
			xlsheet.Cells(startrow-1+row,14)=doseqty
			xlsheet.Cells(startrow-1+row,15)=admloc
			xlsheet.Cells(startrow-1+row,16)=doctor
			xlsheet.Cells(startrow-1+row,17)=disp
			xlsheet.Cells(startrow-1+row,18)=amt
			xlsheet.Cells(startrow-1+row,19)=remark
			
			setBottomPieceLine(xlsheet,startrow-1+row,1,19)
		}
		xlsheet.printout();	
			
		xlApp=null;
		xlsheet=null;
		xlBook.Close(savechanges=false);  
    }
}

function PrnHX()
{
    var cnt=0 ;
    var obj=document.getElementById("t"+"dhcpha_dispstatDM")
    if (obj)
    {
	    cnt=getRowcount(obj);

	     }

    if (cnt>0)
    {   
        var obj=document.getElementById("PoisonRowid")
	    if (obj.value==3)
	    {
		    PrnHX2();
		    return;
	    }
	    
		var prnpath=getPrnPath();
		if (prnpath=="") {
			alert(t['CANNOT_FIND_PRNPATH']) ;
			return ;
			}
		var Template=prnpath+"STP_DailyPrint_DM_HX.xls";
		//alert(Template)
	    //var Template="C:\\STP_DailyPrint_DM_HX.xls";
		xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);
		var xlsheet = xlBook.ActiveSheet ;	
		var startrow=4 ; // add lq
		if (xlsheet==null)
			{ alert(t['CANNOT_CREATE_PRNOBJECT']) ;
			return ;		  }
		
		//var hospname=hospitalName();
		//xlsheet.Cells(1,1)=hospname+t['PRN_TITILE']
		
		var DispLoc=document.getElementById("DispLoc") //��ҩ����
		var DispLoc1=DispLoc.value
		var DispLoc2=DispLoc1.split("-")
		var DispLoc=DispLoc2[1]
		xlsheet.Cells(2,1)=t['DISPLOC']+DispLoc
		var sdate=document.getElementById("StartDate")
		var edate=document.getElementById("EndDate")
		xlsheet.Cells(2,7)=t['SEDATE']+sdate.value+"--"+edate.value   //����
		var gusername=session['LOGON.USERNAME']
		xlsheet.Cells(2,13)=t['PRINTUSER']+gusername
		//xlsheet.Cells(2,18)=gusername
		var poison="";
		var objpoison=document.getElementById("Poison");
		if(objpoison)
		{
			var poison=objpoison.value
		}
		xlsheet.Cells(1,1)=t['PRN_TITLE2']+poison+t['PRN_TITLE3']
		
		 var cols=15
	     //var Rows=obj.rows.length;     
	     for (var row=1;row<=cnt;row++)
            {  
            	for (j=1;j<=cols;j++)
       	        { 
	  		       xlsheet.Cells(startrow-1+row,j).Borders(9).LineStyle = 1;   
	       	       xlsheet.Cells(startrow-1+row,j).Borders(7).LineStyle = 1;    
	      	       xlsheet.Cells(startrow-1+row,j).Borders(10).LineStyle = 1;   
	       	       xlsheet.Cells(startrow-1+row,j).Borders(8).LineStyle = 1;
	       	       xlApp.ActiveSheet.Cells(startrow-1+row,j).HorizontalAlignment = 3;    
       	        }
            }
		
		
		  
		for (var row=1;row<=cnt;row++)
		{
			var date=getVal(row,"TDate")
			var regno=getVal(row,"TRegNo")
			var name=getVal(row,"TPaName")
			var sex=getVal(row,"TSex")
			var age=getVal(row,"TAge")
			var personid=getVal(row,"TIDNO")
			var diagnose=getVal(row,"TDiagNose")
			var prescno=getVal(row,"TPrescNo")
			var descstr=getVal(row,"TDrugDesc")
			var tmpdesc=descstr.split("(")
			var desc=tmpdesc[0]
			var qty=getVal(row,"TQty")
			var batno=getVal(row,"TDrugBatchNo")
			var instruction=getVal(row,"TInstruction")
			var freq=getVal(row,"TFreq")
			var doseqty=getVal(row,"TDoseQty")
			var admloc=getVal(row,"TAdmLoc")
			var doctor=getVal(row,"TDoctor")
			var disp=getVal(row,"TDispUser")
			var remark=getVal(row,"TRem")
			var amt=getVal(row,"TAmt")
			var uom=getVal(row,"Tuom")
			var barcode=getVal(row,"TBarCode")
		
			xlsheet.Cells(startrow-1+row,1)=date
			xlsheet.Cells(startrow-1+row,2)=row
			xlsheet.Cells(startrow-1+row,3)=admloc
			xlsheet.Cells(startrow-1+row,4)=regno //prescno
			xlsheet.Cells(startrow-1+row,5)=name  //regno
			xlsheet.Cells(startrow-1+row,6)=sex   //name
			xlsheet.Cells(startrow-1+row,7)=age		//sex
			xlsheet.Cells(startrow-1+row,8)=personid //age
			xlsheet.Cells(startrow-1+row,9)=desc     // personid
			xlsheet.Cells(startrow-1+row,10)=barcode //desc
			xlsheet.Cells(startrow-1+row,11)=qty //barcode //batno
			xlsheet.Cells(startrow-1+row,12)=qty //+uom  //qty+uom      //barcode
			xlsheet.Cells(startrow-1+row,13)=doctor   //doctor  //uom
			xlsheet.Cells(startrow-1+row,14)=disp  //qty
			xlsheet.Cells(startrow-1+row,15)=disp  //diagnose
			//xlsheet.Cells(startrow-1+row,16)=doctor
			//xlsheet.Cells(startrow-1+row,17)=disp //�������뷢ҩ��һ��
			//xlsheet.Cells(startrow-1+row,18)=disp //��ҩ��
			
			
			//xlsheet.Cells(startrow-1+row,7)=diagnose
			//xlsheet.Cells(startrow-1+row,8)=prescno
			//xlsheet.Cells(startrow-1+row,10)=qty
			//xlsheet.Cells(startrow-1+row,11)=batno
			//xlsheet.Cells(startrow-1+row,12)=instruction
			//xlsheet.Cells(startrow-1+row,13)=freq
			//xlsheet.Cells(startrow-1+row,14)=doseqty
			//xlsheet.Cells(startrow-1+row,15)=admloc
			//xlsheet.Cells(startrow-1+row,16)=doctor
			//xlsheet.Cells(startrow-1+row,17)=disp
			//xlsheet.Cells(startrow-1+row,18)=amt
			//xlsheet.Cells(startrow-1+row,19)=remark
			
			//setBottomPieceLine(xlsheet,startrow-1+row,1,19)
		}
		//xlsheet.PrintPreview();
		xlsheet.printout();	
			
		xlApp=null;
		xlsheet=null;
		xlBook.Close(savechanges=false); 
		
	
    }
    else
    {
	   alert(t['NONE']) 
	   return;
    }
}
function PrnBJFC()
{
    var cnt=0 ;
    var n=0;
    var cols=15 ;
    var startrow=2 ;
    var obj=document.getElementById("T"+"dhcpha_dispstatDM")
    if (obj)
    {
	    cnt=getRowcount(obj); }
    if (cnt>0)
    {   
		var prnpath=getPrnPath();
		if (prnpath=="") {
			alert(t['CANNOT_FIND_PRNPATH']) ;
			return ;
			}
		var Template=prnpath+"STP_BJFCDailyPrint_DM.xls";
		xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);
		var xlsheet = xlBook.ActiveSheet ;	
		 
		if (xlsheet==null)
			{ alert(t['CANNOT_CREATE_PRNOBJECT']) ;
			return ;		  }
		
		var hospname=hospitalName();
		xlsheet.Cells(1,1)=hospname+"����ҩƷ�ǼǱ�"

		  
		for (var row=1;row<=cnt;row++)
		{

			var descstr=getVal(row,"TDrugDesc")
			var tmpdesc=descstr.split("(")
			var desc=tmpdesc[0]
			var barcode=getVal(row,"TBarCode")
			var uom=getVal(row,"Tuom")
			var date=getVal(row,"TDate")
			var name=getVal(row,"TPaName")
			var sex=getVal(row,"TSex")
			var age=getVal(row,"TAge")
			var remark=getVal(row,"TRem")
			var prno=getVal(row,"TPRNO")
			var personid=getVal(row,"TIDNO")
			var qty=getVal(row,"TQty")
			var batno=getVal(row,"TDrugBatchNo")
			var loc=getVal(row,"TAdmLoc")
			var doctor=getVal(row,"TDoctor")
			var disp=getVal(row,"TDispUser")
			

		
			xlsheet.Cells(startrow+n,1)="Ʒ��"+" "+desc
			xlsheet.Cells(startrow+n,4)="���"+" "+barcode
			xlsheet.Cells(startrow+n,8)="��λ"+" "+uom
			//xlsheet.Cells(startrow+n,10)="���ڽ��"
			xlsheet.Cells(startrow+n,13)="���"
			xlsheet.Cells(startrow+1+n,1)="���"
			xlsheet.Cells(startrow+2+n,1)=row
			xlsheet.Cells(startrow+1+n,2)="����"
			xlsheet.Cells(startrow+2+n,2)=date
			xlsheet.Cells(startrow+1+n,3)="��������"
			xlsheet.Cells(startrow+2+n,3)=name
			xlsheet.Cells(startrow+1+n,4)="�Ա�"
			xlsheet.Cells(startrow+2+n,4)=sex
			xlsheet.Cells(startrow+1+n,5)="����" 
			xlsheet.Cells(startrow+2+n,5)=sex 
			xlsheet.Cells(startrow+1+n,6)="ȷ�ﲡ��" 
			xlsheet.Cells(startrow+2+n,6)=remark 
			xlsheet.Cells(startrow+1+n,7)="������" 
			xlsheet.Cells(startrow+2+n,7)=prno
			xlsheet.Cells(startrow+1+n,8)="���֤��" 
			xlsheet.Cells(startrow+2+n,8)=personid
			xlsheet.Cells(startrow+1+n,9)="����" 
			xlsheet.Cells(startrow+2+n,9)=qty
			xlsheet.Cells(startrow+1+n,10)="ҩƷ����" 
			xlsheet.Cells(startrow+2+n,10)=batno
			xlsheet.Cells(startrow+1+n,11)="�Ʊ�" 
			xlsheet.Cells(startrow+2+n,11)=getDesc(loc,"-")
			xlsheet.Cells(startrow+1+n,12)="����ҽ��" 
			xlsheet.Cells(startrow+2+n,12)=doctor
			xlsheet.Cells(startrow+1+n,13)="��ҩ��" 
			xlsheet.Cells(startrow+2+n,13)=disp
			xlsheet.Cells(startrow+1+n,14)="������" 
			xlsheet.Cells(startrow+2+n,14)=disp
			//xlsheet.Cells(startrow+1+n,15)="���" 
			//xlsheet.Cells(startrow+2+n,15)=""

	
			 for (var h=startrow+1+n;h<=startrow+2+n;h++)
            {  
             	for (j=1;j<=cols;j++)
       	         { 
	                 xlsheet.Cells(h,j).Borders(9).LineStyle = 1;   
	        	     xlsheet.Cells(h,j).Borders(7).LineStyle = 1;    
	       	         xlsheet.Cells(h,j).Borders(10).LineStyle = 1;   
	        	     xlsheet.Cells(h,j).Borders(8).LineStyle = 1;
	        	     xlApp.ActiveSheet.Cells(h,j).HorizontalAlignment = 3;    
       	         }
             }
			
			n=n+5

			

		}
		
		//xlsheet.Cells(startrow+1+n,1)="����֧��"
		//xlsheet.Cells(startrow+1+n,8)="���ڽ��"
		//xlsheet.Cells(startrow+1+n,8)="���ڽ��"
		//xlsheet.Cells(startrow+1+n,13)=getPrintDateTime();
		//xlsheet.PrintPreview();
		xlsheet.printout();	
			
		xlApp=null;
		xlsheet=null;
		xlBook.Close(savechanges=false); 
		window.setInterval("Cleanup();",1); 
	
    }
    else
    {
	   alert(t['NONE']) 
	   return;
    }
}

function PoisonLookUpSelect(str)
{ 

    //ȡ���Ʒ���rowid
	var cat=str.split("^");
	var obj=document.getElementById("PoisonRowid");
	if (obj)
	{if (cat.length>0)   obj.value=cat[1] ;
		else	obj.value="" ;  
	}

}

function getVal(row,colname)
{
	var obj=document.getElementById(colname+"z"+row)  ;
	var val,text;
	if (obj)
	{
		val=obj.value;
		text=obj.innerText;
	}	
	if (text!="") return text;
	return val;
}
function getPrnPath()
{
	var obj=document.getElementById("mGetPrnPath") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var prnpath=cspRunServerMethod(encmeth,'','') ;
	return prnpath
	}
function hospitalName()
{	var obj=document.getElementById("mPrtHospName") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var hospname=cspRunServerMethod(encmeth,'','') ;
	//alert("hospname:"+hospname);
	return hospname
	}




 function PrnHX2()
{
	   //���龫��ҩƷ�����ӡ
	   //lq 2007-10-12
       var prnpath=getPrnPath();
		if (prnpath=="") {
			alert(t['CANNOT_FIND_PRNPATH']) ;
			return ;
			}
		var Template=prnpath+"STP_DailyPrint_DM_HX2.xls";
		//alert(Template)
	    //var Template="C:\\STP_DailyPrint_DM_HX2.xls";
		xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);
		var xlsheet = xlBook.ActiveSheet ;	
		var startrow=4 ; // add lq
		
		if (xlsheet==null)
			{ alert(t['CANNOT_CREATE_PRNOBJECT']) ;
			return ;		  }
		
        var DispLoc=document.getElementById("DispLoc") //��ҩ����
		var DispLoc1=DispLoc.value
		var DispLoc2=DispLoc1.split("-")
		var DispLoc=DispLoc2[1]
		//xlsheet.Cells(2,1)=t['DISPLOC']+DispLoc
		var sdate=document.getElementById("StartDate")
		var edate=document.getElementById("EndDate")
		//xlsheet.Cells(2,7)=t['SEDATE']+sdate.value+"--"+edate.value   //����
		var gusername=session['LOGON.USERNAME']
		//xlsheet.Cells(2,10)=t['PRINTUSER']+gusername
        xlsheet.Cells(2,1)=t['DISPLOC']+DispLoc+"    "+t['SEDATE']+sdate.value+"--"+edate.value

        var obj=document.getElementById('Tpidz'+1)
        var pid=obj.value
        var obj=document.getElementById("getnum") ;
	    if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	    var str=cspRunServerMethod(encmeth,pid) ;//������ҩ_"^"_�ڼ���ҩ_"^"_ÿ��ҩ������_"^"_ҩƷ��
	    str=str.split("||")
	    num=str[0] //������ҩ
	    
	    var obj=document.getElementById("getnum1") ;
	    if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	    var str1=cspRunServerMethod(encmeth,pid) ;//��˳�򷵻���ʱ��ӡglobal�±�,��ҩ����?||?���
	    numstr=str1.split("||")
    var row=0
	for(var n=1;n<=num;n++)  //ÿ��ҩ
	{
		   var titlerow=startrow+row-1
		   xlsheet.Cells(titlerow,1)=name
		   xlsheet.Cells(startrow+row,1)=t['ID'] 
		   xlsheet.Cells(startrow+row,2)=t['Disdate']  
		   xlsheet.Cells(startrow+row,3)=t['Paname'] 
		   xlsheet.Cells(startrow+row,4)=t['Disnum']  
		   xlsheet.Cells(startrow+row,5)="" 
		   xlsheet.Cells(startrow+row,6)=t['ID']  
		   xlsheet.Cells(startrow+row,7)=t['Disdate']  
		   xlsheet.Cells(startrow+row,8)=t['Paname']  
		   xlsheet.Cells(startrow+row,9)=t['Disnum']  
		   xlsheet.Cells(startrow+row,10)="" 
		   xlsheet.Cells(startrow+row,11)=t['ID'] 
		   xlsheet.Cells(startrow+row,12)=t['Disdate']  
		   xlsheet.Cells(startrow+row,13)=t['Paname']  
		   xlsheet.Cells(startrow+row,14)=t['Disnum'] 
		   for (j=1;j<=14;j++){
		   xlsheet.Cells(startrow+row,j).Borders(9).LineStyle = 1;   
	       xlsheet.Cells(startrow+row,j).Borders(7).LineStyle = 1;    
	       xlsheet.Cells(startrow+row,j).Borders(10).LineStyle = 1;   
	       xlsheet.Cells(startrow+row,j).Borders(8).LineStyle = 1;
	       xlApp.ActiveSheet.Cells(startrow+row,j).HorizontalAlignment = 2;   } 

    
      lstr=str[n]   //�ڼ���ҩ_"^"_ÿ��ҩ������_"^"_ҩƷ��
      str2=lstr.split("^")
      name=str2[2]  //ҩ��
      num1=str2[1]  //ÿ��ҩ������
      strr=numstr[n-1]
      
      var startcol=0  //��ʼ��
      
	  for (var m=1;m<=num1;m++)//ĳ��ҩ��ÿ����¼
	   {
	
	     liststr=strr.split("^")
	     liststr=liststr[m]

	     var obj=document.getElementById("liststr") ;
	     if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	     var lstr2=cspRunServerMethod(encmeth,pid,name,liststr) ;
	     
	     lstr2=lstr2.split("^")
	     disdate=lstr2[0] //����
	     paname=lstr2[2] //��������
	     dianum=lstr2[9] //��ҩ����
	     barcode=lstr2[22] //���
	     uom=lstr2[21] //��λ
	     fac=lstr2[23] //����
         
	     xlsheet.Cells(startrow+row+1,startcol+1)=m //���
	     xlsheet.Cells(startrow+row+1,startcol+2)=disdate //����
	     xlsheet.Cells(startrow+row+1,startcol+3)=paname //��������
	     xlsheet.Cells(startrow+row+1,startcol+4)=dianum //��ҩ����
	     
         startcol=startcol+5 //ÿ����¼ÿ�к���5��
         
         if (m%3==0) //ÿȡ������¼����,�г�ʼΪ0
	          {
		       row=row+1
		       startcol=0 
		       }  
        
         
	         for  (h=1;h<=14;h++) 
	            {   
		       xlsheet.Cells(startrow+row+1,h).Borders(9).LineStyle = 1;   
	           xlsheet.Cells(startrow+row+1,h).Borders(7).LineStyle = 1;    
	           xlsheet.Cells(startrow+row+1,h).Borders(10).LineStyle = 1;   
	           xlsheet.Cells(startrow+row+1,h).Borders(8).LineStyle = 1;
	           xlApp.ActiveSheet.Cells(startrow+row+1,h).HorizontalAlignment = 2;    
       	       
	            }
    	    
	    }
	      
	     xlsheet.Cells(titlerow,1)=t['Medname']+":"+name+"  "+t['Barcode']+":"+barcode+"  "+t['Uom']+":"+uom+"   "+t['Fac']+":"+fac  //ÿ��ҩ����
	     var row=row+3 //ÿ��ҩ��ʼ�� 3:���б���+��һ��
         
	}
	
     
        xlsheet.Cells(startrow+row+2,7)=t['Gro']+"^"
		xlsheet.printout();	
			
		xlApp=null;
		xlsheet=null;
		xlBook.Close(savechanges=false);
		window.setInterval("Cleanup();",1); 


}
function Cleanup() //�����ӡ������������ lq 2007-10-12
{   
    window.clearInterval(idTmr);   
    CollectGarbage();   
}


document.body.onbeforeunload=function(){

   KillTmpPrintDM2();  //lq ��ҳ��ˢ��?����?�ر�ʱ������ξ�������ӡ^TmpPrintDM2
  } 
  
  

  
document.body.onload=BodyLoadHandler;

