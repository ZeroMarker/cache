var startdate
var enddate
var guser=session['LOGON.USERID'];
var tsData,num,job

function BodyLoadHandler() 
 {  	
   	var startDateobj=document.getElementById("StartDate");
   	startdate=startDateobj.value;
   	var enddateobj=document.getElementById("EndDate");
   	enddate=enddateobj.value;
   	guser=session['LOGON.USERID'];
   	var guserobj=document.getElementById("guser");
   	guserobj.value=guser;
   	var printobj=document.getElementById("print");
   	if (printobj){
	   	 printobj.onclick=Print_click;
	}
}

function Grid(objSheet,xlsTop,xlsLeft,hrow,lrow)
{   
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop+hrow,lrow)).Borders(1).LineStyle=1 ;
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop+hrow,lrow)).Borders(2).LineStyle=1;
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop+hrow,lrow)).Borders(3).LineStyle=1 ;
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop+hrow,lrow)).Borders(4).LineStyle=1 ;
}

function Print_click()
{
    if (startdate=="" || enddate==""){return;}
    var job=document.getElementById("job").value;
	var num=tkMakeServerCall("web.UDHCJFOPVOIDINVRep","GetNum",guser,job);
	var XLSPath=GetPath()
 	var Template=XLSPath+"JF_UDHCJFOPMonthRep.xls";
 	//var Template="D:\\JF_UDHCJFOPMonthRep.xls"
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet;
    xlApp.visible=true;

	var CurrRow=5;
	var columns=0
	for (i=1;i<=num;i++)
	    {   
            var retdata=tkMakeServerCall("web.UDHCJFOPVOIDINVRep","GetData",guser,job,i);          
            columns=retdata.split("^");
           
            for (j=0;j<=eval(columns.length);j++)
            {   
	            xlsheet.cells(CurrRow,j+1)=columns[j];
            }
            CurrRow=CurrRow+1;
	    }
	Grid(xlsheet,4,1,CurrRow-5,columns.length);

	var stdate=document.getElementById("StartDate").value;
   	var enddate=document.getElementById("EndDate").value;
	//var startdate=startdate.split("/");
    //var enddate=enddate.split("/");
    //stdate=startdate[2]+"-"+startdate[1]+"-"+startdate[0],enddate=enddate[2]+"-"+enddate[1]+"-"+enddate[0];
   // var Handflagobj=document.getElementById("HandFlag").checked;
    //var FindFeeobj=document.getElementById("FindFee").checked;
    //var FindRegobj=document.getElementById("FindReg").checked;
    var str=""
   // if(Handflagobj="")  str=str+"(未结算:"
   // else str=str+"(已结算:"
   // if((FindFeeobj==true)&&(FindRegobj==true))  str=str+"收费+挂号)"
   // if((FindFeeobj==true)&&(FindRegobj==false))  str=str+"收费)"
   // if((FindFeeobj==false)&&(FindRegobj==true))  str=str+"挂号)"
    //var printdate=document.getElementById("printDate").value;
    xlsheet.cells(3,1).value="查询日期:"+stdate+" 至 "+enddate+str;
   // xlsheet.cells(3,10).value="制表日期:"+printdate;   
	
	xlsheet.cells(CurrRow,3).value="制表:"+session['LOGON.USERNAME'];
	xlsheet.cells(CurrRow,5).value="复核:"
	
	if(this.id=="print"){
		//xlApp.Visible=true;
		xlsheet.PrintPreview();
		//xlsheet.printout;	
		xlBook.Close (savechanges=false);
	}else{
		xlBook.Close (savechanges=true);
	}
	xlApp.Quit();
	xlApp=null;
	xlsheet=null;
}

function GetPath() {
	var path=tkMakeServerCall("web.UDHCJFCOMMON","getpath","","");
	return path
	//alert(path)
}
  

document.body.onload = BodyLoadHandler;




