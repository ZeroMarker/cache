//DHC.OPReg.Reports.js

var Status="";
var path="";

function BodyLoadHandler() {
	var obj=document.getElementById("RegUser");
	if (obj){obj.onkeydown=RegUser_keyDown;}  
 var BPrintobj=document.getElementById("BExport");
  if (BPrintobj) BPrintobj.onclick=Export_click;
  ctlocobj=document.getElementById("ctloc");
	
	var staobj=document.getElementById("status");
	if (staobj){Status=staobj.value;
	//alert(Status)
	   if (Status==""){
			var tmp=document.getElementById("RegUser");
			//alert(2)
			tmp.value=session['LOGON.USERNAME'];
			//tmp.Disabled=true;
			tmp.readOnly=true;	
			var Myobj=document.getElementById('Myid');	
			var imgname="ld"+Myobj.value+"i"+"RegUser"
			var tmp1=document.getElementById(imgname);
			tmp1.style.display="none";
			var tmp=document.getElementById("SuseID");
			tmp.value=session['LOGON.USERID'];
		}
		getpath();
	}
	
	var RegObj=document.getElementById('RegUser');
	var obj=document.getElementById('SuseID');
	if(RegObj.value=="")obj.value="";
}

function RegUser_keyDown()
{ 
	if (event.keyCode==13)
     {
	 RegUser_lookuphandler();  
	 }
	/*if (window.event.keyCode==13) 
	{  
		//window.event.keyCode=117;   //为F6-
	  	RegUser_lookuphandler();    //获得本元素lookup属性中的句柄
	}*/
}
function RegUser_lookuphandler() {
	
		var url='websys.lookup.csp';
		url += "?ID=d50133iRegUser";
		url += "&CONTEXT=Kweb.DHCUserGroup:Finduse1";
		url += "&TLUJSF=uselook";
		var obj=document.getElementById('RegUser');
		if (obj) url += "&P1=" + websys_escape(obj.value);
		

		websys_lu(url,1,"");
		return websys_cancel();
	
}
function UnloadHandler(){
	/*     //在后台已经执行完
	var obj=document.getElementById("KillTmp");
	if (obj){
		var encmeth=obj.value;
		if (encmeth!=""){
			cspRunServerMethod(encmeth);
		}
	}
	*/
}

function Export_click() 
{
	var staobj=document.getElementById("status");
	if(staobj.value=="ZZ"){
		Template=path+"DHCOPRegReportsZZ.xls";
	}else{
		Template=path+"DHCOPRegReports.xls";
	}
	//改成调用摸板进行打印还需GetPath(),至于汇总，可另设置一隐藏元素，取另一个GLOBAL
	var tblobj=document.getElementById("tDHC_OPReg_Reports");
 var StartDate=document.getElementById("StDate").value;
 //var aa=getDate()
 //alert(aa)
 var EndDate=document.getElementById("EdDate").value;
 var ctloc=document.getElementById("ctloc").value;
 var userid=document.getElementById("userid").value;
 
 var rows,pagerow;
 var getmethod=document.getElementById('getrows');
  if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
  //alert(encmeth+"^"+ctloc+"^"+userid);
 var PrintRTN=cspRunServerMethod(encmeth,ctloc,userid)
 var PrintArr=PrintRTN.split("^");
 var PrintRows=PrintArr[0];
 var userName=PrintArr[1];
  if (PrintRows==0){return ;}
try{
var oXL = new ActiveXObject("Excel.Application"); 
var oWB = oXL.Workbooks.Add(Template); 
var oSheet = oWB.ActiveSheet; 
var mainrows=PrintRows;


}
catch(e) {
  alert( "要打印该表您必须安装Excel电子表格软件,同时浏览器须使用'ActiveX 控件',您的浏览器须允许执行控件 请点击帮助了解浏览器设置方法");
  return "";
}
 
/*
var mainlie = tblobj.rows(0).cells.length;
var i,j;
oSheet.Cells(1,4).value="挂号员日报表";
// oSheet.Columns("A").ColumnWidth =9;
// oSheet.Columns("B").ColumnWidth =9;
 oSheet.Columns("C").ColumnWidth =10;
 //oSheet.Columns("D").ColumnWidth =7;
 oSheet.Cells(2,1).value="开始日期:";

 oSheet.Range(oSheet.Cells(2,2),oSheet.Cells(2,3)).mergecells=true;
 oSheet.Range(oSheet.Cells(2,2),oSheet.Cells(2,3)).HorizontalAlignment =-4108;//居中
  oSheet.Range(oSheet.Cells(2,2),oSheet.Cells(2,3)).value=StartDate
  
  oSheet.Cells(2,4).value ="结束日期:";
  oSheet.Range(oSheet.Cells(2,5),oSheet.Cells(2,6)).mergecells=true;
  oSheet.Range(oSheet.Cells(2,5),oSheet.Cells(2,6)).HorizontalAlignment =-4108;//居中
  oSheet.Range(oSheet.Cells(2,5),oSheet.Cells(2,6)).value =EndDate;
   
   oSheet.Cells(2,7).value ="操作员:";
   oSheet.Cells(2,8).value =userName;
   
  for (j=1;j<mainlie;j++){  
     oSheet.Cells(3,j).value = tblobj.rows(0).cells(j).innerText;
     }
     */
  //alert(StartDate+EndDate)
  var hospObj=document.getElementById('HospName');
  if ((hospObj)&&(hospObj.value!="")){
	  if(staobj.value=="ZZ"){
		  oSheet.Cells(1,2).value =hospObj.value+"挂号员日报表汇总";
	  }else{
		  oSheet.Cells(1,1).value =hospObj.value+"挂号员日报表";
	  }
	  
  }
  oSheet.Cells(2,4).value =StartDate;
 
  oSheet.Cells(2,7).value =EndDate;
 
  oSheet.Cells(2,11).value =userName;
   for (i=3;i<=mainrows+2;i++)
     {  
	   var getmethod=document.getElementById('getrowinf');
       if (getmethod) {var encmeth=getmethod.value} else {var encmeth='';}
       var PrintSet=cspRunServerMethod(encmeth,ctloc,userid,i-2)
       var sstr=PrintSet.split("^")
       oSheet.Cells(i+1,1).HorizontalAlignment=3;//左对齐
       oSheet.Range(oSheet.Cells(i+1,3),oSheet.Cells(i+1,9)).HorizontalAlignment =-4108;//居中
       oSheet.Cells(i+1,1).value =sstr[0];
       oSheet.Cells(i+1,2).value =sstr[1];
       oSheet.Cells(i+1,3).value =sstr[2];
       oSheet.Cells(i+1,4).value =sstr[9];
       oSheet.Cells(i+1,5).value =sstr[3];
       oSheet.Cells(i+1,6).value =sstr[4];
       oSheet.Cells(i+1,7).value =sstr[5];
       oSheet.Cells(i+1,8).value =sstr[6];
       oSheet.Cells(i+1,9).value =sstr[7];
       oSheet.Cells(i+1,10).value =sstr[8];
      // var mainrows=(mainrows-4)+1
       //oSheet.Range(oSheet.Cells(2,1)).Columns.AutoFit;
       //DrawLine(i+1,oSheet);
       /*oSheet.Cells(i+1,10).value =sstr[9];
       oSheet.Cells(i+1,11).value =sstr[10];
       oSheet.Cells(i+1,12).value =sstr[11];
       oSheet.Cells(i+1,13).value =sstr[12];
       oSheet.Cells(i+1,14).value =sstr[13];
       oSheet.Cells(i+1,15).value =sstr[14];
       oSheet.Cells(i+1,16).value =sstr[15];
       oSheet.Cells(i+1,17).value =sstr[16];
       oSheet.Cells(i+1,18).value =sstr[17]; */ 
 
	 }
 mainrows=parseInt(mainrows)+4;
 gridlist(oSheet,4,mainrows,1,11);
oSheet.printout;
oWB.Close (savechanges=false);
oXL.Quit();
oXL=null;
oSheet=null;

  
//oXL.Visible = true; 
//oXL.UserControl = true; 
}
function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1-1, c1), objSheet.Cells(row2-1,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1-1, c1), objSheet.Cells(row2-1,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1-1, c1), objSheet.Cells(row2-1,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1-1, c1), objSheet.Cells(row2-1,c2)).Borders(4).LineStyle=1; 
}
function getpath()
{
	  var getpath=document.getElementById('GetPath');
    if (getpath) {var encmeth=getpath.value} else {var encmeth=''};
	  path=cspRunServerMethod(encmeth,'','')
}

function DrawLine(Row,xlsheet)
{
	//var Range=xlsheet.Cells(Row,1);
	var Range=xlsheet.Range(xlsheet.Cells(Row,1),xlsheet.Cells(Row,9));
	Range.Borders(9).LineStyle = 3;     // 线的格式
	Range.Borders(9).Weight = 2;
	Range.Borders(9).ColorIndex = -4105;          // 9表示下边线
}

function uselook(str) {
	//alert(Status+","+1)
	if (Status==""){
		var tmp=document.getElementById("SuseID");
		tmp.value=session['LOGON.USERID'];
	}
	
	else{
			
	var obj=document.getElementById('SuseID');
	var tem=str.split("^");
	obj.value=tem[1];
	}
}


document.body.onload = BodyLoadHandler;

document.body.onunload =UnloadHandler;