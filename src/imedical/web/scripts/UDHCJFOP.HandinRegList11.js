//
//UDHCJFOP.HandinRegList11


var Guser,GuserCode,GuserName;
var PrintTxtInfo="",PrintListInfo="";


function BodyLoadHandler()
{
   Guser=session['LOGON.USERID'];
   GuserCode=session['LOGON.USERCODE'];
   GuserName=session['LOGON.USERNAME'];
   InitDoc();
   
   var myPrtXMLName="UDHCRegHandinRptList"
   DHCP_GetXMLConfig("InvPrintEncrypt",myPrtXMLName);
   document.onkeydown = DHCWeb_EStopSpaceKey;
}


function InitDoc()
{
	
   	var obj=document.getElementById("Print");
   	
	var Objtbl=document.getElementById('tUDHCJFOP_HandinRegList11');
	var Rows=Objtbl.rows.length;
	
	if (Rows>1)
	{
		obj.disabled=false;
		obj.onclick=Print_Click;
		}
	else
	{
		DHCWeb_DisBtn(obj);
		}
		
	
}


function GetPrintInfo()
{
	
	var rowtxt="";
	PrintTxtInfo="",PrintListInfo="";
	var c2=String.fromCharCode(2);
	var Objtbl=document.getElementById('tUDHCJFOP_HandinRegList11');
	var Rows=Objtbl.rows.length;
	if (Rows<2) {return false;}
	
	var obj=document.getElementById("ToDay");
	var Today=obj.value;
	PrintTxtInfo="UserName"+c2+GuserName;
	PrintTxtInfo=PrintTxtInfo+"^"+"Today"+c2+Today;
    
    for (i=0;i<Rows;i++)
    {
	    rowtxt="";
	    for (j=1;j<Objtbl.rows(i).cells.length;j++)
	    {
		    //Objtbl.rows(i).cells(j).innerText
		    if (rowtxt=="")
		    {
			    rowtxt=Objtbl.rows(i).cells(j).innerText
			    }
		    else
		    {
			    rowtxt=rowtxt + "^" + Objtbl.rows(i).cells(j).innerText
			    }
		    }
		if (PrintListInfo=="")
		{
			PrintListInfo=rowtxt
			}
		else
		{
			PrintListInfo=PrintListInfo+c2+rowtxt
			}
		
	    }
	
	return true;
	}

function Print_Click()
{
	var path=tkMakeServerCall("web.UDHCJFCOMMON","getpath","","")
	var Template=path+"UDHCJFOP.HandinRegList11.xls";
	try{
		var xlApp= new ActiveXObject("Excel.Application"); 
		var xlBook= xlApp.Workbooks.Add(Template); 
		var xlSheet = xlBook.ActiveSheet;	
		var xlsheet = xlBook.WorkSheets("Sheet1");
	}
	catch(e) {
  		alert( "要打印该表您必须安装Excel电子表格软件,同时浏览器须使用'ActiveX 控件',您的浏览器须允许执行控件 请点击帮助了解浏览器设置方法");
  		return "";
	}
	var eSrc=window.event.srcElement;
	var tbObj=document.getElementById('tUDHCJFOP_HandinRegList11');
	var rows=tbObj.rows.length;
	var rowObj = tbObj.getElementsByTagName("tr");
	if (tbObj)
   {
		var str = "" ,rowNumber,columnNumber;
		for(var rowNumber = 0;  rowNumber < rowObj.length;rowNumber++ )
		{
      for(var columnNumber = 1; columnNumber < rowObj[rowNumber].cells.length;columnNumber ++ )
			{
				str=rowObj[0].cells[columnNumber].innerText;
				if (str==" ") break;
				str = rowObj[rowNumber].cells[columnNumber].innerText;
				xlsheet.cells(rowNumber+2, columnNumber).value = str;
			}
		}
	}
	xlsheet.printout;
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null;

	
	return true;
	
	var PrintInfo=GetPrintInfo();
	if (PrintInfo)
	{
		XMLPrint(PrintTxtInfo,PrintListInfo);
		PrintTxtInfo="",PrintListInfo="";
	}
	
	}
function XMLPrint(TxtInfo,ListInfo)
{
	
	//alert(TxtInfo)
	//alert(ListInfo)
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);	
	
}

function UnloadHandler(){
	///
	
}

document.body.onload = BodyLoadHandler;

document.body.onunload =UnloadHandler;