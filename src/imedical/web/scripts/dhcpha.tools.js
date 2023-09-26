//document.styleSheets[0].addImport("DHCST.CSS",0);
document.write("<LINK REL='stylesheet' TYPE='text/css' HREF='../scripts/DHCST.CSS'></LINK>")
function getRegNo(regno)
{
	var len=regno.length;
	//var  reglen=10
	var reglen=tkMakeServerCall("web.DHCOutPhAdd","GetPminoLen")
	var zerolen=reglen-len
	var zero=""
	for (var i=1;i<=zerolen;i++)
	{zero=zero+"0" ;
		}
	return zero+regno ;
	}	
function today()
{
	var xx=new Date();
	return formatDate(xx)
}
function formatDate(dateobj)
{
	var sep="/";
	var day=dateobj.getDate();
	if (day<10){
		day="0"+day;
	}
	var mon=dateobj.getMonth()+1;
	if (mon<10) {
		mon="0"+mon ;
	}
	var year=dateobj.getFullYear();
	var dhcphadatefmt="";
	if (typeof(websys_DateFormat)!="undefined"){
		var dhcphadatefmt=websys_DateFormat.toUpperCase();
		if (dhcphadatefmt=="Y-M-D"){
			sep="-";
			return year+sep+mon+sep+day;
		}else if (dhcphadatefmt=="D/M/Y"){
			sep="/";
			return day+sep+mon+sep+year
		}
	}
	return day+sep+mon+sep+year
}

function formatDate2(datestr)
{
	var sep="-";
	//alert(datestr.replace(/-/g,"/"));
	var dateobj=new Date(datestr.replace(/-/g,"/"));	
	var day=dateobj.getDate();
	var mon=dateobj.getMonth()+1;
	if (mon<10) mon="0"+mon ;
	var year=dateobj.getFullYear();
	var varyear=year.toString();
	
	//year=varyear.substring(2,4);
	return year+sep+mon+sep+day;

}
function formatDate3(datestr)
{
	// 把 year-mon-day转成 day/mon/year
	sep="/"
	str=datestr.split("-")
	day=str[2]
	mon=str[1]
	year=str[0]
	return day+sep+mon+sep+year;

}
function getRelaDate(offset)
{
	//in terms of today ,calculate the date
	var obj=new Date();
	var ms=obj.getTime();
	var offsetms=60*60*24*offset*1000;
	var newms=ms+offsetms;
	var newdate=new Date(newms);
	return formatDate(newdate);
}

function getDesc(desc)
{
	//Description : if the "desc" has the "-",then get rid of it
	var ss=desc.split("-")
	if (ss.length>1 )
	{	result=ss[1] ;	}
	else
	{result=desc}
	return result
}

function getPrintDateTime()
{
	var sep="/"
	var d=new Date();
	var pt="";
	var c=":";
	var monVal=d.getMonth()+1;
	if (monVal<10){
		monVal="0"+monVal;
	}
	var dayVal=d.getDate();
	if (dayVal<10){
		dayVal="0"+dayVal;
	}
	var dhcphadatefmt="";
	if (typeof(websys_DateFormat)!="undefined"){
		var dhcphadatefmt=websys_DateFormat.toUpperCase();
		if (dhcphadatefmt=="Y-M-D"){
			sep="-";
			pt=d.getFullYear()+sep+monVal+sep+dayVal;
			
		}else if (dhcphadatefmt=="D/M/Y"){
			sep="/";
			pt=dayVal+sep+monVal+sep+d.getFullYear();
		}else if (dhcphadatefmt=="J/N/Y"){
			sep="/";
			pt=dayVal+sep+monVal+sep+d.getFullYear();
		}
	}
	if(pt==""){
		pt=d.getFullYear()+sep+monVal+sep+dayVal;
	}	
	pt+=" "
	var hourVal=d.getHours();
	if (hourVal<10){
		hourVal="0"+hourVal;
	}
	var minVal=d.getMinutes();
	if (minVal<10){
		minVal="0"+minVal;
	}
	var secVal=d.getSeconds();
	if (secVal<10){
		secVal="0"+secVal;
	}
	pt+=hourVal+c;
	pt+=minVal+c;
	pt+=secVal;
	return pt
}

function getPrintTime()
{
	var d=new Date();
	var pt="";
	var c=":";
	
	pt=d.getHours()+c;
	pt+=d.getMinutes()+c;
	pt+=d.getSeconds();
	return pt
}
function GetAge(dob)
{	//计算年龄
	//dob's format must be : yyyy-mm-dd
	if (dob=="") return ""
	var birthdate=dob.split("-")	;
	if (birthdate.length!=3) return ""
	
	var birthyear=birthdate[0] ;
	var birthmon=birthdate[1] ;
	
	var d=new Date();
	var currentyear=d.getFullYear();
	var currentmon=d.getMonth()+1;
	var age=currentyear-birthyear;
	if (age==0) return 1 ;
	if ((currentmon-birthmon)>=6) age+=1 ;
	if (age<0) age=0;
	return age
}
function getPrintDate()
{
	var d=new Date();
	var pt="";
	
	pt+=d.getFullYear()+"-";    ///  getYear 修改为 getFullYear bianshuai 2015-12-07
	pt+=(d.getMonth()+1)+"-";
	pt+=d.getDate();
	return pt
}
function SetWinCenter(win)
{	win.moveTo((screen.width-win.document.body.offsetWidth)/2,(screen.height-win.document.body.offsetHeight)/2)	 
}

function FilterDesc(desc,ch )
{//get rid of one or more char from one word

 var result
 result=desc.replace(ch,"")
 return result
}

function ltrim(str) 
{ 
return str.replace(/^\s*/g,""); 
} 
function rtrim(str) 
{ 
return str.replace(/\s*$/g,""); 
} 
function trim(str) 
{ 
return ltrim(rtrim(str)); 
}

function IsNumeric(sText)
{
   var ValidChars = "0123456789.";
   var IsNumber=true;
   var Char;
 
   for (i = 0; i < sText.length && IsNumber == true; i++) 
      { 
      Char = sText.charAt(i); 
      if (ValidChars.indexOf(Char) == -1) 
         {
         IsNumber = false;
         }
      }
   return IsNumber;
   
}
function ExcelSet(objSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter)
{
    var titleRowsStr, titleColsStr
    if ((titleRows > 0)&&( titleRows < 6)) {titleRowsStr="$1:$"+titleRows}
    else { titleRowsStr = ""}
    titleColsStr = "";
    if (titleCols==1) titleColsStr = "$A:$A"    //'maxcols is 5
    if (titleCols==2) titleColsStr = "$A:$B"
    if (titleCols==3) titleColsStr = "$A:$C"
    if (titleCols==4) titleColsStr = "$A:$D"
    if (titleCols==5) titleColsStr = "$A:$E"
   
    objSheet.PageSetup.PrintTitleRows = titleRowsStr
    objSheet.PageSetup.PrintTitleColumns = titleColsStr
        
    objSheet.PageSetup.PrintArea = ""
    objSheet.PageSetup.LeftHeader = LeftHeader
    objSheet.PageSetup.CenterHeader = CenterHeader
    objSheet.PageSetup.RightHeader = RightHeader
    objSheet.PageSetup.LeftFooter = LeftFooter
    objSheet.PageSetup.CenterFooter = CenterFooter
    objSheet.PageSetup.RightFooter = RightFooter
}

function setBottomLine(objSheet,row,startcol,colnum)
{
    objSheet.Range(objSheet.Cells(row, startcol), objSheet.Cells(row, startcol + colnum - 1)).Borders(9).LineStyle=1 ;
}
function cellEdgeRightLine(objSheet,row,c1,c2)
{
	for (var i=c1;i<=c2;i++)
	{
		objSheet.Range(objSheet.Cells(row, i), objSheet.Cells(row,i)).Borders(10).LineStyle=1;
		objSheet.Range(objSheet.Cells(row, i), objSheet.Cells(row,i)).Borders(7).LineStyle=1;
	}
}
function GetHeader(src) 
{ 
     try{	
	 var ForReading=1; 
	 var fso=new ActiveXObject("Scripting.FileSystemObject");
	 var f=fso.OpenTextFile(src,ForReading);
	 return(f.ReadAll()); 
     }
         catch(e)
             {
	             alert(e.message);
             }

}

function GetStrWithoutSpecChar(Desc,StartChar,EndChar) 
{
 //根据输入串和分隔符?前?后?取出去掉分隔符和分隔符之间的内容后的串?
 //
	var Lpos 
	var Rpos 
	if (Desc=="") {  return ''}
	
	//自右向左找 "StartChar"  "EndChar"
	var ss=Desc.split(StartChar)
	if (ss.length>=0) var desc1=ss[0]
	var ss=Desc.split(EndChar)
	if (ss.length>=0) var desc2=ss[0]
	
	if ((desc2.length>desc1.length)&&(desc1.length>0) )
	{ return trim(desc1)}
	else {return Desc}
	
	/*
	Lpos =Desc.match(re) //InStr(Desc, StartChar)
	Rpos =Desc.match(re) // InStr(Desc, EndChar)
	if ((Lpos>0)&&(Rpos>0)&&(Rpos>=Lpos)) {
		  var re=Desc.substring(0,Lpos-1)
	   return re }
	else { return Desc}
	*/
}


function getPrnPath()
{
	var obj=document.getElementById("mGetPrnPath") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	prnpath=cspRunServerMethod(encmeth,'','') ;
	if(prnpath.substring(prnpath.length,prnpath.length-1)!="\\"){prnpath=prnpath+"\\"}
	return prnpath
}

function mergcell(objSheet,row,c1,c2)
{
        objSheet.Range(objSheet.Cells(row, c1), objSheet.Cells(row,c2)).MergeCells =1;
}

function SetNothing(app,book,sheet)
{
        app=null;
        book.Close(savechanges=false);
        sheet=null;
} 
