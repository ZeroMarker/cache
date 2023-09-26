
//Ext.BLANK_IMAGE_URL="../scripts_lib/ext3.2.1/resources/images/default/s.gif"
function GetRequest() {

   var url = location.search; //获取url中"?"符后的字串

   var theRequest = new Object();

   if (url.indexOf("?") != -1) {

      var str = url.substr(1);

      strs = str.split("&");

      for(var i = 0; i < strs.length; i ++) {

         theRequest[strs[i].split("=")[0]]=unescape(strs[i].split("=")[1]);

      }

   }

   return theRequest;

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



//获取打印配置
function GetPrintPath()
{
	var prnpath=tkMakeServerCall("web.DHCSTCOMWEB", "GetPrintPath") ;
	if(prnpath.substring(prnpath.length,prnpath.length-1)!="\\"){prnpath=prnpath+"\\"}
	return prnpath	
}

//清空XLS对象
function SetNothing(app,book,sheet)
{
        app=null;
        book.Close(savechanges=false);
        sheet=null;
        
}  

//格式化日期
function FormatDate(datestr,sep)
{
	var dateobj=new Date(datestr.replace(/-/g,"/"));	
	var day=dateobj.getDate();
	var mon=dateobj.getMonth()+1;
	if (mon<10) mon="0"+mon ;
	var year=dateobj.getFullYear();
	var varyear=year.toString();
	return year+sep+mon+sep+day;

}


 //合并单元格
 function mergcell(objSheet,row,c1,c2)
 {
        objSheet.Range(objSheet.Cells(row, c1), objSheet.Cells(row,c2)).MergeCells =1;
 } 
 
 //划下边框线
 function setBottomLine(objSheet,row,startcol,colnum)
 {
    objSheet.Range(objSheet.Cells(row, startcol), objSheet.Cells(row, startcol + colnum - 1)).Borders(9).LineStyle=1 ;
 }
 
 
 function GetPIVAStDate()
 {
 	var ret=tkMakeServerCall("web.DHCSTPIVAOUTCOMMON","GetPIVAStDate");
 	return ret;
 } 

 function GetPIVAEndDate()
 {
 	var ret=tkMakeServerCall("web.DHCSTPIVAOUTCOMMON","GetPIVAEndDate");
 	return ret;
 } 
function getPrintDateTime()
{
	
	var d=new Date();
	var pt="";
	var c=":";
	
	pt+=d.getFullYear()+"-";	//getYear 改为 getFullYear 20151104zhouyg
	pt+=(d.getMonth()+1)+"-";
	pt+=d.getDate();
	pt+=" "
	pt+=d.getHours()+c;
	pt+=d.getMinutes()+c;
	pt+=d.getSeconds();
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
function cellEdgeRightLine(objSheet,row,c1,c2)
{
	for (var i=c1;i<=c2;i++)
	{
		objSheet.Range(objSheet.Cells(row, i), objSheet.Cells(row,i)).Borders(10).LineStyle=1;
		objSheet.Range(objSheet.Cells(row, i), objSheet.Cells(row,i)).Borders(7).LineStyle=1;
	}
}
