var myData=new Array();
//var PrintDateTime;
var myColumns=new Array();
var queryTypeCode=document.getElementById("vartyp").value;
var printedFlag=false;
var debug=false;
var longNewOrdAdd=false;
var objlongNewOrdAdd=parent.frames["NurseTop"].document.getElementById("longNewOrdAdd"); 
if (objlongNewOrdAdd) longNewOrdAdd=objlongNewOrdAdd.checked;
var hospitalName=document.getElementById("hospitalName").value;
if (queryTypeCode!="")
    {
    var GetTitle=document.getElementById("GetTitle").value;
    var titleStr=cspRunServerMethod(GetTitle,queryTypeCode);
    if (titleStr.length==0) {alert(t['val:setVar']);}
    var titleList=titleStr.split("^")
    var	myColumns=titleList[1].split("!")
	var varList=titleList[2].split("!")
	var ordStatDescInd=GetArrayIndex(varList,"ordStatDesc");
	var execXDateTimeInd=GetArrayIndex(varList,"execXDateTime");
	var execXUserDescInd=GetArrayIndex(varList,"execXUserDesc");
	var oeoriIdInd=parseInt(titleList[0])
	var disposeStatInd=oeoriIdInd+2;
	    
	var disposeStatDescInd=GetArrayIndex(varList,"disposeStatDesc");
	var arcimDescInd=GetArrayIndex(varList,"arcimDesc");
	var doseQtyUnitInd=GetArrayIndex(varList,"doseQtyUnit");
    var phOrdQtyUnitInd=GetArrayIndex(varList,"phOrdQtyUnit");
    var execStatInd=GetArrayIndex(varList,"execStat");
    var execDateTimeInd=GetArrayIndex(varList,"execDateTime");
    var execCtcpDescInd=GetArrayIndex(varList,"execCtcpDesc");
    var prtFlagInd=GetArrayIndex(varList,"prtFlag");
    var oecprDescInd=GetArrayIndex(varList,"oecprDesc");
   	var labNoInd=GetArrayIndex(varList,"labNo");
	var freqInd=GetArrayIndex(varList,"phcfrCode");
	var reclocDescInd=GetArrayIndex(varList,"reclocDesc")
	var placerNoInd=GetArrayIndex(varList,"placerNo");
	var specDescInd=GetArrayIndex(varList,"specDesc");
}
function GetTitleNameByCode(titleDesc)
{
	var titleDescInd=GetArrayIndex(varList,titleDesc);
	return myColumns[titleDescInd]
}
function QueryPrintData()
{
    //if (ordStatDescInd<0) {return t['alert:disOrdStat'];}
    var gap="",rows=0,printFlag;
    var regNo=document.getElementById("RegNo").value;
    var sDate=document.getElementById("StartDate").value;
    var eDate=document.getElementById("EndDate").value;
    var queryTypeCode=document.getElementById("vartyp").value;
    var wardId=document.getElementById("wardid").value;
    var locId=document.getElementById("Loc").value;
    var dept=parent.frames['NurseTop'].document.getElementById("Dept").value;
    var doctyp=parent.frames['NurseTop'].document.getElementById("Doctyp").checked;
    if (dept==""){locId="";}
    var userId=session['LOGON.USERID'];
    
    var findPatient=document.getElementById("FindPatient").value;
    var getAllPatient=document.getElementById("GetAllPatient").value;
    var getOrderItem=document.getElementById("GetOrderItem").value;
    var getData=document.getElementById("GetData").value;
    var tmpList=new Array();   
    var patList=new Array();
    var retStr=t['alert:noPrintData'];
    //var kmtemp=document.getElementById("kmtemp").value;  //ypz061228
    //var rj=cspRunServerMethod(kmtemp);  //ypz 061228
    var GetTmpData=document.getElementById("GetTmpData").value;
    var GetTmpDataNum=document.getElementById("GetTmpDataNum").value;
    //qse add 061214
    var TmpNum=cspRunServerMethod(GetTmpDataNum,userId);
    var tem=new Array();
    var temstr;
    for (j=1;j<=TmpNum;j++)
    {
		var itemData=cspRunServerMethod(GetTmpData,userId,j);
		//rows=rows+1
		tmpList=(itemData).split("!");
		temstr=tmpList[tmpList.length-4]+"!"+tmpList[tmpList.length-1]
		tem=temstr.split("!");
		if(tem[1]!="Y")       //WKZ add 070921
		{
			rows=rows+1
			myData[rows-1]=tem
		}
	}
	if (TmpNum!=0)
	{retStr=0;}
    return retStr;
}
function GetCheckData()
{
    var i,j,tmpStr,retStr,dischOrd,check,objOrdStatDesc;
	var objtbl=document.getElementById('tDHCNURSEXCUTE');
	retStr=t['alert:selOrder']
    var tmpList=new Array();
    var curOrdId,mainOrdId=0,mainCheck=false,mainOriSub=0;
    myData=[];
    for (i=1;i<objtbl.rows.length;i++)
    {
	    check=document.getElementById('seleitemz'+i);
	    objDisposeStatCode=document.getElementById('disposeStatCodez'+i);
	    if (! objDisposeStatCode) { alert(t['alert:disOrdStat']);return}
	    var disposeStatCode=objDisposeStatCode.innerText;
	    //ypz 070709 begin
        var oeoriId=document.getElementById('oeoriIdz'+i).innerText;
	    var tmpOrdList=oeoriId.split("||");
        var oriSub=tmpOrdList[1];
        if (mainOriSub==0) {mainOriSub=oriSub;mainCheck=check.checked;}
        curOrdId=tmpOrdList[0];
        if (mainOrdId!=curOrdId) mainOrdId=curOrdId;
	    var arcimDesc=document.getElementById("arcimDescz"+i).innerText;
	    var arcimList=arcimDesc.split(mainOriSub)
	    if ((arcimList[0]=="____")&&(queryTypeCode.indexOf("PSD")<0)){
		    if (mainCheck!=check.checked) return arcimDesc+":主医嘱和关联医嘱选择标志不一致! "+oeoriId
	    }
	    else{mainOriSub=oriSub;mainCheck=check.checked;}
		//ypz 070709 end  
	    if ((check.checked==true)&&(disposeStatCode!="Discontinue")&&(disposeStatCode!="ExecDiscon")) {
			tmpList=[]
		    tmpStr=document.getElementById('oeoriIdz'+i).innerText;
		    tmpList[tmpList.length]=tmpStr;
		    tmpStr=document.getElementById('tmpPrtFlagz'+i).innerText;
		    tmpList[tmpList.length]=tmpStr;
		    myData[myData.length]=tmpList;
		    retStr=0;
	    }
	    /*     if ((check.checked==true)&&(disposeStatCode!="Discontinue")&&(disposeStatCode!="ExecDiscon")) {
            var PrintFlag=document.getElementById('tmpPrtFlagz'+i).innerText;
		    if (debug) alert(oeoriId);
			tmpList=[]
	    	for (j=0;j<varList.length;j++)
	    	{   var obj=document.getElementById(varList[j]+'z'+i);
	    	  	tmpStr="";
	    	   	if (obj) {if (varList[j]!="placerNo") tmpStr=obj.innerText; else  tmpStr=obj.value}
	            tmpList[j]=tmpStr;
		    }
		    tmpStr=document.getElementById('oeoriIdz'+i).innerText;
		    tmpList[tmpList.length]=tmpStr;
		    tmpStr=document.getElementById('placerCodez'+i).innerText;
		    tmpList[tmpList.length]=tmpStr;
		    tmpStr=document.getElementById('disposeStatCodez'+i).innerText;
		    tmpList[tmpList.length]=tmpStr;
		    tmpStr=document.getElementById('tmpPrtFlagz'+i).innerText;
		    tmpList[tmpList.length]=tmpStr;
		    
		    myData[myData.length]=tmpList;
		    retStr=0;
	    }*/
    }
    return retStr;
}
function GetFilePath()
{   var GetPath=document.getElementById("GetPath").value;
    var path=cspRunServerMethod(GetPath);
    return path
}
function GetPrintDateTime(adjSecond,delimiter,isAll) 
{ 	var queryTypeCode=document.getElementById("vartyp").value;
    var startDate=parent.frames["NurseTop"].document.getElementById("StartDate").value;
	var tmpList=startDate.split("/");
	if (tmpList.length>2){
    	var curDate=new Date(tmpList[2],tmpList[1]-1,tmpList[0]);
    	tmpList=queryTypeCode.split("CQ");
    	if (tmpList.length>1) 
    	{    
	        var curDateVal=curDate.getTime();
	        curDateVal=curDateVal+adjSecond*1000; //*60*60*24*1000
	        curDate.setTime(curDateVal);
        }
        if (isAll) PrintDateTime=curDate.getYear()+delimiter+(curDate.getMonth()+1)+delimiter+curDate.getDate();
        else PrintDateTime=(curDate.getMonth()+1)+delimiter+curDate.getDate();
    }
    else PrintDateTime=DateDemo();
	return PrintDateTime
}
function CopyToExcel(dataList,xlsSheet,frow,trow,fcol,tcol,xlsTop,xlsLeft)
{
	var i,j;
	var PRow=21; //rows per page
	var wrow=0
	var p=0;
	wrow=xlsTop
	/*var pg=""
	pg=wrow%21
	if ((pg==1)||(pg==2))
	{   titleLable(xlsSheet,"",PrintDateTime,typeDesc,wrow,dataList);
	    p=p+1;
        wrow=wrow+1;
	}*/
	//var FreqTime=document.getElementById("FreqTime").value;
	var getExecDateTime=document.getElementById("getExecDateTime").value;
	var execDateTimeInd=GetArrayIndex(varList,"execDateTime")
    var getPatInfo=document.getElementById("PatInfo").value;
	//alert(freqInd+"/"+execDateTimeInd)
	//if (execDateTimeInd<0) {alert("col display error");retrun}
    for (i=frow;i<=trow;i++)
    {   
	    var ss=dataList[i][3];
	    var dd=ss.split("_");
        var pres=(wrow)%PRow;
        var timeStr="";
        var PrintDateTime=GetPrintDateTime(0,"-",false);//PrintDateTime=DateDemo(); ypz 060928
        //alert("i7="+dataList[i][7])
        if ((execDateTimeInd>-1)&&(dataList[i][oeoriIdInd]!="")) {
  	    	var ret=cspRunServerMethod(getExecDateTime,dataList[i][oeoriIdInd],".","-",longNewOrdAdd);
  	    	if (ret!=""){
	  	    	var tmpDTList=ret.split("-");
  		    	//alert(tmpDTList)
  	    		for (j=0;j<tmpDTList.length;j++)
  	    		{
	  	    		var tmpList=tmpDTList[j].split(" ");
	  	    		if (tmpList.length>0){
	  	    			if (timeStr!="") timeStr=timeStr+"-"
	  	    			timeStr=timeStr+tmpList[1]
	  	    		}
	  	    	}
  	    	}
  	    }
  	    var sexValue=cspRunServerMethod(getPatInfo,dataList[i][oeoriIdInd]).split("^")[3]
	    for (j=fcol;j<=tcol;j++)  //'ubound(strList)
        { 
            if ((dd[0]=="")&&(j<6))
	        {
                xlsSheet.cells(wrow,xlsLeft+j-fcol)=dataList[i][j];
	        }
	        if (dd[0]!="")
	        {
                xlsSheet.cells(wrow,xlsLeft+j-fcol)=dataList[i][j];
                xlsSheet.cells(wrow,4)=sexValue;
		    }
        }
       /* if (dd[0]!="")
        {
            if (execDateTimeInd>2) xlsSheet.cells(wrow,execDateTimeInd-2)=timeStr;
        }*/
        /*if ((pres==0)&&(i!=trow))  //if last line,do not write title//unuse
        {
	        //alert(trow+"|"+"|"+i+"|"+dataList)
	        wrow=wrow+1;
	        //alert("copyto excel:")
	        titleLable(xlsSheet,"",PrintDateTime,typeDesc,wrow,dataList);
	        p=p+1;
	    }*/
        wrow=wrow+1;
    }
	return (wrow-1)+"^"+p 
}
function JCDPRN(chkSelPrint)  //exam apply sheet
{
		var resStr=GetCheckData();
	if (resStr!="0"){alert(resStr); return;}  //can't print!
    
    var xlsExcel,xlsSheet,xlsBook;
    var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
    var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
    var strList,tmpList,tmpStr,i,j,xlsTop,xlsLeft,typeInd,typeDesc;
    var path,fileName,fso;
    var printList=[],patPrint,framePrint,actRow;

    if (myData.length<1) {alert("请查询后打印!");return false}
    //alert(myData)
    var GetVarType;
    var varType=document.getElementById("vartyp").value;
    GetVarType=document.getElementById("GetVarType");
    
    var str=cspRunServerMethod(GetVarType.value,varType);
    fileName="";
    tmpList=str.split("^");
    if (tmpList.length>2) {fileName=tmpList[1];typeDesc=tmpList[0];patPrint=tmpList[2];framePrint=tmpList[3]}
    if (fileName=="") { alert("未指定EXCEL文件名!");return false}
    PrintDateTime=GetPrintDateTime(0,"-",false); //DateDemo();
    path = GetFilePath();  //ypz open
    fileName=path+ fileName;
    xlsExcel = new ActiveXObject("Excel.Application");
    xlsBook = xlsExcel.Workbooks.Add(fileName) //;Open(fileName)
    xlsSheet = xlsBook.ActiveSheet //  Worksheets(1)
    xlsTop=1;xlsLeft=1;
    //strList=titleStr.split("!")
    cols=oeoriIdInd; actRow=2;//actRow=0;
    oeoriIdStr="";preOrderId=0//alert("len="+oeoriIdStr.length)
   //xlsExcel.Visible = true
    var singtotal=14,sheetFirstRow
    var trno=0;  //换页调整行
    for (i=0;i<myData.length;i++)
    {  // alert(myData[i][cols-2])
        sheetFirstRow=i*(singtotal+1)
        //if ((myData[i][cols+3]!="Y")&&(myData[i][cols-2]!="停止")) //&&(myData[i][disposeStatDescInd]!="L")
        if (myData[i][cols-2]!="停止") //&&(myData[i][disposeStatDescInd]!="L")
        {   if (oeoriIdStr.length==0){oeoriIdStr=myData[i][oeoriIdInd]}
            else{oeoriIdStr=oeoriIdStr+"^"+myData[i][oeoriIdInd]}
            var pos;

            var PatInfo=document.getElementById("PatInfo").value;
            var str=cspRunServerMethod(PatInfo,myData[i][oeoriIdInd]);
            //alert(str)
            var arr=str.split("^");//regno_"^"_ctloc_"^"_room_"^"_sex_"^"_pagName
            var regno=arr[0];
            var ctloc=arr[1]; var room=arr[2];
            var sex=arr[3];
            var GetOrdSet=document.getElementById("GetOrdSet");
            //alert(i+":"+myData+"/"+myData[i][oeoriIdInd])
            var OrdSet=cspRunServerMethod(GetOrdSet.value,myData[i][oeoriIdInd]);
            var PreOrdSet;
         if ((PreOrdSet!="")&&(OrdSet==PreOrdSet)){}
         else
         {
            pos=sheetFirstRow+2;var row=pos;
            xlcenter(xlsSheet,row,1,6)
            FontStyle(xlsSheet,row,1,6,14)
            mergcell(xlsSheet,row,1,6);
            xlsSheet.cells(row,1)="粤北人民医院检查预约单";
           
            var warddes=document.getElementById("warddes").value;
            
            LeftHeader ="病区:"+warddes+"  打印时间:"+PrintDateTime+"  打印人:"+session['LOGON.USERNAME']+"                      功能科室:"+myData[i][reclocDescInd];; //'Chr(13) &""
           // alert(LeftHeader);
            pos=sheetFirstRow+3;var row=pos;
            xlsSheet.cells(row,1)=LeftHeader;
            
            pos=sheetFirstRow+4;var row=pos;
            AddGrid(xlsSheet,0,0,10,5,row,1);
            xlsSheet.cells(row,1)="科室:";xlsSheet.cells(row,2)=ctloc;
            xlsSheet.cells(row,3)="检查名称:";xlsSheet.cells(row,4)=myData[i][3];
            xlsSheet.cells(row,5)="床号:";xlsSheet.cells(row,6)=arr[6];
            pos=sheetFirstRow+5 ;row=pos;
            xlsSheet.cells(row,1)="姓名:";xlsSheet.cells(row,2)=arr[4];
            xlsSheet.cells(row,3)="性别:";xlsSheet.cells(row,4)=sex;
            xlsSheet.cells(row,5)="年龄:";xlsSheet.cells(row,6)=arr[7];
            pos=sheetFirstRow+6 ;row=pos;
            xlsSheet.cells(row,1)="病案号:";xlsSheet.cells(row,2)=arr[5];
            xlsSheet.cells(row,3)="住院号:";xlsSheet.cells(row,4)=regno;
            xlsSheet.cells(row,5)="单价:";xlsSheet.cells(row,6)=myData[i][priceInd];
            pos=sheetFirstRow+7 ;row=pos;
            //alert(myData[i])
            xlsSheet.cells(row,1)="临床诊断:";
            mergcell(xlsSheet,row,2,6);
            pos=sheetFirstRow+8 ;row=pos;
            xlsSheet.cells(row,1)="临床所见:";
            nmergcell(xlsSheet,row,row+5,1,1);
            nmergcell(xlsSheet,row,row+5,2,6);
            xlsSheet.cells(row,2)=myData[i][10];
            pos=sheetFirstRow+13 ;row=pos;
            if (OrdSet=="")
            {	xlsSheet.cells(row,1)="检查名称:";xlsSheet.cells(row,2)=myData[i][3];}
            else
            {   xlsSheet.cells(row,1)="检查名称:";xlsSheet.cells(row,2)=OrdSet;
            }
            PreOrdSet=OrdSet;

            pos=sheetFirstRow+14 ;row=pos;
            xlsSheet.cells(row,1)="医师:";xlsSheet.cells(row,2)=myData[i][9];
            xlsSheet.cells(row,3)="日期:";xlsSheet.cells(row,4)=myData[i][2];
            xlsSheet.cells(row,5)="备注:";
          } 
        }
    if (oeoriIdStr.length>0){
    //for (j=0;j<cols;j++) {xlsSheet.cells(actRow+xlsTop,j+xlsLeft)=myColumns[j]}
   // CopyToExcel(printList,xlsSheet,0,printList.length-1,0,cols-1,actRow+2,xlsLeft)
     SetPrintFlag(oeoriIdStr)
    }
    titleRows = 1;titleCols = 0 ;//&chr(10)
  
    //if (framePrint=="Y") AddFrame(xlsSheet,0,0,printList.length,cols-1,actRow+ 1, 1) //'添加边框
    //xlsExcel.Visible = true
    //xlsSheet.PrintPreview 
    xlsSheet.PrintOut
    xlsSheet = null;
    xlsBook.Close(savechanges=false)
    xlsBook = null;
    xlsExcel.Quit();
    xlsExcel = null;
  // }
  //  catch(e)
 //   {
 //       alert(e.toString());
//        xlsExcel.Quit();
//    }

}
}

function JYDPRN(chkSelPrint) //lab apply sheet
{
		var resStr=GetCheckData();
	if (resStr!="0"){alert(resStr); return;}  //can't print!
	//alert(myData)
	var xlsExcel,xlsSheet,xlsBook;
    var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
    var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
    var strList,tmpList,tmpStr,i,j,xlsTop,xlsLeft,typeInd,typeDesc;
    var path,fileName,fso;
    var printList=[],patPrint,framePrint,actRow;
    var PreOrdSet="";

    ////if (myData.length<1) {alert("请查询后打印!");return false}
    var GetVarType;
    var varType=document.getElementById("vartyp").value;
    GetVarType=document.getElementById("GetVarType");
        
    var str=cspRunServerMethod(GetVarType.value,varType);
    fileName="";
    //alert(str);
    tmpList=str.split("^");
    if (tmpList.length>2) {fileName=tmpList[1];typeDesc=tmpList[0];patPrint=tmpList[2];framePrint=tmpList[3]}
    if (fileName=="") { alert("未指定EXCEL文件名!");return false}
    PrintDateTime=DateDemo();

    path = GetFilePath();  //ypz open
    fileName=path+ fileName;
    xlsExcel = new ActiveXObject("Excel.Application");
	xlsBook = xlsExcel.Workbooks.Add(fileName) //;Open(fileName)
	xlsSheet = xlsBook.ActiveSheet //  Worksheets(1)
    xlsTop=1;xlsLeft=1;
    cols=oeoriIdInd; actRow=0;
    oeoriIdStr="";preOrderId=0;//alert("len="+oeoriIdStr.length)
    //xlsExcel.Visible = true
        
    var singtotal=9;var sheetFirstRow;
    var trno=0,printRow=0;  //换页调整行
    for (i=0;i<myData.length;i++)
    {  /// alert((myData[i][cols-2]))
        sheetFirstRow=printRow*(singtotal+1)
        if (oeoriIdStr.length==0){oeoriIdStr=myData[i][oeoriIdInd]}
        else{oeoriIdStr=oeoriIdStr+"^"+myData[i][oeoriIdInd]}
        var PatInfo=document.getElementById("PatInfo").value;
        var str=cspRunServerMethod(PatInfo,myData[i][oeoriIdInd]);
        var arr=str.split("^");//regno_"^"_ctloc_"^"_room_"^"_sex_"^"_pagName
        var res;
        var GetOrdSet=document.getElementById("GetOrdSet");
        var OrdSet=cspRunServerMethod(GetOrdSet.value,myData[i][oeoriIdInd]);
     	if ((PreOrdSet!="")&&(OrdSet==PreOrdSet)) {   }
     	else
     	{  
     		//alert(myData[i])
     		SetJYDData(xlsSheet,sheetFirstRow,OrdSet,myData[i],arr);
        	//xlsExcel.Visible = true;
        	PreOrdSet=OrdSet;
     	}
     	printRow=printRow+1;
    }
    if (oeoriIdStr.length>0){
    //for (j=0;j<cols;j++) {xlsSheet.cells(actRow+xlsTop,j+xlsLeft)=myColumns[j]}
    //    CopyToExcel(printList,xlsSheet,0,printList.length-1,0,cols-1,actRow+2,xlsLeft)
     	SetPrintFlag(oeoriIdStr)
    }
    titleRows = 1;titleCols = 0 ;//&chr(10)
  
    //if (framePrint=="Y") AddFrame(xlsSheet,0,0,printList.length,cols-1,actRow+ 1, 1) //'添加边框
    //xlsExcel.Visible = true;
    //xlsSheet.PrintPreview 

    xlsSheet.PrintOut();
    xlsSheet = null;
    xlsBook.Close(savechanges=false)
    xlsBook = null;
    xlsExcel.Quit();
    xlsExcel = null;
    //}
    //    catch(e)
    //{
    //    alert(e.toString());
    //    xlsExcel.Quit();
    //}
}
function SetJYDData(xlsSheet,sheetFirstRow,OrdSet,dataList,arr)
{
		var PrintDateTime=GetPrintDateTime(0,"-",false);  //GetPrintDateTime();
	var pos=sheetFirstRow+2;var row=pos;
    xlcenter(xlsSheet,row,1,6)
    mergcell(xlsSheet,row,1,6)
    FontStyle(xlsSheet,row,1,6,14)
    xlsSheet.cells(row,1)="粤北人民医院检验预约单";
                
    var warddes=document.getElementById("warddes").value;
    var LeftHeader ="病区:"+warddes+"  打印时间:"+PrintDateTime+"  打印人:"+session['LOGON.USERNAME']+"                      功能科室:"+dataList[9];; //'Chr(13) &""
    pos=sheetFirstRow+3;var row=pos;
    mergcell(xlsSheet,row,1,6)
    xlsSheet.cells(row,1)=LeftHeader;
    //alert(myData[i]);
    pos=sheetFirstRow+4;var row=pos;
    AddGrid(xlsSheet,0,0,5,5,row,1);
    xlsSheet.cells(row,1)="科室:";xlsSheet.cells(row,2)=arr[1];
    xlsSheet.cells(row,3)="病室:";xlsSheet.cells(row,4)=arr[2];
    xlsSheet.cells(row,5)="床号:";xlsSheet.cells(row,6)=dataList[0];
    pos=sheetFirstRow+5 ;row=pos;
    xlsSheet.cells(row,1)="姓名:";xlsSheet.cells(row,2)=dataList[1];
    xlsSheet.cells(row,3)="性别:";xlsSheet.cells(row,4)=arr[3];
    xlsSheet.cells(row,5)="年龄:";xlsSheet.cells(row,6)=dataList[4];
    pos=sheetFirstRow+6 ;row=pos;
    xlsSheet.cells(row,1)="病案号:";xlsSheet.cells(row,2)=arr[5];
    xlsSheet.cells(row,3)="住院号:";xlsSheet.cells(row,4)=arr[0];
    pos=sheetFirstRow+7 ;row=pos;
    xlsSheet.cells(row,1)="临床诊断:";
    mergcell(xlsSheet,row,2,6);
    pos=sheetFirstRow+8 ;row=pos;
    if (OrdSet=="")
    {	xlsSheet.cells(row,1)="检验名称:";xlsSheet.cells(row,2)=dataList[3];}
    else
    {   xlsSheet.cells(row,1)="检验名称:";xlsSheet.cells(row,2)=OrdSet;
	}
    xlsSheet.cells(row,3)="单价:";xlsSheet.cells(row,4)=dataList[10];
    xlsSheet.cells(row,5)="标本号:";xlsSheet.cells(row,6)=dataList[6];
    pos=sheetFirstRow+9 ;row=pos;
    xlsSheet.cells(row,1)="医师:";xlsSheet.cells(row,2)=dataList[5];
    xlsSheet.cells(row,3)="日期:";xlsSheet.cells(row,4)=dataList[2];
    xlsSheet.cells(row,5)="备注:";	
}
function GetDate(dateStr)
{
	var tmpList=dateStr.split("/")
	if (tmpList.length<3) return 0;
	return ((tmpList[2]*1000)+(tmpList[1]*50)+tmpList[0]*1)
}
function GetArcim1(ord)
{
	    var Ord,chl,tstr;
	    var getarcim=document.getElementById("getarcim").value;
	    tstr=ord.split("||");
	    Ord=tstr[0];
	    chl=tstr[1];
	    var str=cspRunServerMethod(getarcim,Ord,chl,queryTypeCode);
	    return str;

}
function PrintClick()
{
	var chkSelPrint=document.getElementById('chkSelPrint').checked;
	myData=[];
	if (chkSelPrint==true) resStr=GetCheckData();
	else resStr=QueryPrintData();

	if (resStr!="0"){alert(resStr); return;}  //can't print!
 if (queryTypeCode=="JCD")
	{   //JCDPRN(chkSelPrint);
	    //return ;
	} 
	if (queryTypeCode.indexOf("JYD")>-1)
	{   
	    //JYDPRN(chkSelPrint);  //ypz 061209
	    var truthBePrint = window.confirm("是否打印标签?");
	    if(truthBePrint){PrintBar();}
	    //ypz 080714//var truthBePrintSJD = window.confirm("是否打印送检单?");
	    //ypz 080714//if(truthBePrintSJD){PrintClickExcel();}
    	return ;  //ypz 061109
	}
	if (queryTypeCode.indexOf("BLD")>-1)
	{   
	    var truthBePrint = window.confirm("是否打印标签?");
	    if(truthBePrint){PrintPathologyBar();}
    	return ;  //ypz 061109
	}
    var GetVarType=document.getElementById("GetVarType");
   	var str=cspRunServerMethod(GetVarType.value,queryTypeCode);
    tmpList=str.split("^");
   //	if (tmpList.length>2) {fileName=tmpList[1];typeDesc=tmpList[0];patPrint=tmpList[2];framePrint=tmpList[3]}
   	//if (fileName=="") { alert(t['alert:noExcelFile']);return false}
    var oeoriIdStr=""  ;//,preFrameMark=0,maxFrameCols=cols-3;//alert("len="+oeoriIdStr.length)

    var warddes="";
    var tmpPrintList=new Array();
	if (myData.length<1) {alert(t['alert:queryFirst']);return false}
	if (chkSelPrint==true){
	PrintRp(queryTypeCode,"select",tmpList[0]);
	}else{
	PrintRp(queryTypeCode,"all",tmpList[0]);
		}

}

function PrintBar() //print lab barcode
{
    var Bar,i,j;  
    Bar= new ActiveXObject("PrintBar.PrnBar");//TestAx.CLSMAIN
    Bar.PrintName="tiaoma";//printer name
    var chkSelPrint=document.getElementById('chkSelPrint').checked;
    if (chkSelPrint==true) resStr=GetCheckDataExcel();
    else resStr=QueryPrintDataExcel();
    if ((queryTypeCode.indexOf("JYD")<0)) return;
    var prtFlagInd=varList.length+2  //GetArrayIndex(varList,"prtFlag");
    var oeoriIdInd=varList.length  //GetArrayIndex(varList,"oeoriId");
    var labNoInd=GetArrayIndex(varList,"labNo");
    SortListByCol(myData,labNoInd,true)
    var oeoriIdStr="",printedLabNoStr="^";
    var getArcimShortDesc=document.getElementById("GetArcimShortDesc").value;
    for (i=0;i<myData.length;i++)
    {
	       var oldi=i
        if ((myData[i][prtFlagInd]!="Y")||(chkSelPrint==true))
    	   {
            var oeoriId=myData[i][oeoriIdInd];
            var arcdes=GetArcim1(oeoriId);
            var RetStr=arcdes.split("@")
            var orderitem=RetStr[0].split("|");
            var labNo=orderitem[10];  //ypz 061026
            //var tmpList=printedLabNoStr.split("^"+labNo+"^")  //ypz 061026
            if (labNo!="")
            {           
                var	placerCode=myData[i][oeoriIdInd+1];
                var labelDesc="";
                var colorDesc=document.getElementById("color"+placerCode);
                if (colorDesc)
                {
	                labelDesc=colorDesc.value;
                }
                //if ((placerCode!="")&&(placerCode!=" ")) labelDesc=t['val:color'+placerCode];
                if (oeoriIdStr.length==0){oeoriIdStr=oeoriId}
                else{oeoriIdStr=oeoriIdStr+"^"+oeoriId}
                var PatInfo=document.getElementById("PatInfo").value;
                var str=cspRunServerMethod(PatInfo,oeoriId);
                var arr=str.split("^");//regNo_"^"_ctloc_"^"_room_"^"_sex_"^"_pagName
                var regNo=arr[0];
                var ctloc=arr[1]; var room=arr[2];
                var PreOrdSet;
                var GetOrdSet=document.getElementById("GetOrdSet");
                var OrdSet=cspRunServerMethod(GetOrdSet.value,oeoriId);
                if ((PreOrdSet!="")&&(OrdSet==PreOrdSet))
                {
                }
                else
                {
                    //var GetSpecName=document.getElementById("SpecName").value;
                    //var SpecName=cspRunServerMethod(GetSpecName,oeoriId);
                    //var getLabelDesc=document.getElementById("GetLabelDesc").value;
                    //var labelDesc=cspRunServerMethod(getLabelDesc,oeoriId);
                    var RecLoc=orderitem[11];
                    var OrdName=""  ///reclocDesc
                    var Sex=arr[3];
                    //var PatName=document.getElementById('patNamez'+i).innerText;
                    var PatName=regNo+" "+arr[4]
                    //var PatName=arr[4]
                    //var Age=document.getElementById('agez'+i).innerText;
                    var Age=arr[7]
                    var patLoc=arr[1]
                    var bedCode=arr[6]
                
                    var tmpList=arr[1].split("-")
                    if (tmpList.length>1) patLoc=tmpList[1]
                    if (OrdSet==""){
                        OrdName=cspRunServerMethod(getArcimShortDesc,"",oeoriId);//ypz 080717 //orderitem[0];
                    }
                    else
                    {
                        OrdName=OrdSet;
                    }
                    for (j=i+1;j<myData.length;j++)
                    {
                        var oeoriId=myData[j][oeoriIdInd];
                        var arcdes=GetArcim1(oeoriId);
                        var RetStr=arcdes.split("@")
                        var orderitem=RetStr[0].split("|");
                        var addLabNo=orderitem[10];
                        //var addLabNo=labNo;
                        ////var addCheck=myData[j][seleitemInd];
                        ////var addPrintFlag=myData[j][tmpPrtFlagInd];
                        //var addDisposeStatCode=document.getElementById('disposeStatCodez'+j).innerText;
	    			
                        //if ((addCheck.checked==true)&&(addPrintFlag!="Y")&&(addDisposeStatCode!="UnPaid")&&(addSpecNo==SpecNo))
                        if (addLabNo==labNo)
                        {
                            addOrdName=cspRunServerMethod(getArcimShortDesc,"",oeoriId);//ypz 080717 //orderitem[0];
                            OrdName=OrdName+","+addOrdName
                            oeoriIdStr=oeoriIdStr+"^"+oeoriId
                            oldi=j
                        }
                    }
                    i=oldi
                    // printedLabNoStr=printedLabNoStr+labNo+"^"
                    //ypz 061026 end
                    //alert(OrdSet+"/"+labNo+"/"+RecLoc+"/"+labelDesc+"/"+patLoc+"/"+OrdName+"/"+PatName+"/"+Sex+"/"+Age+"/"+bedCode); //return;
                    //test//

                    var specDesc="";
                    if (specDescInd>-1) specDesc=myData[i][specDescInd];

                    PreOrdSet=OrdSet;
                    Bar.LabNo=labNo;
                    Bar.RecLoc=RecLoc;
                    //Bar.SpecName=labelDesc;
                    Bar.LabelDesc=labelDesc+"  "+specDesc;
                    Bar.PatLoc=patLoc;
                    //Bar.PatWard=arr[8];
                    Bar.OrdName=OrdName;
                    Bar.PatName=PatName;
                    Bar.Sex=Sex;
                    Bar.Age=Age;
                    Bar.BedCode=bedCode;
                    //Bar.FontName="C39HrP72DlTt"
                    Bar.PrintOut(1);
                }
            }
        }
    }
    if ((oeoriIdStr.length>0)&(chkSelPrint==false)){
      SetPrintFlag(oeoriIdStr)
    }	
}
function PrintPathologyBar() //print Pathology barcode
{
    if ((queryTypeCode.indexOf("BLD")<0)) return;
    var Bar,i,j;
    Bar= new ActiveXObject("PrintBar.PrnBar");//TestAx.CLSMAIN
    Bar.PrintName="tiaoma";//printer name
    var chkSelPrint=document.getElementById('chkSelPrint').checked;
    if (chkSelPrint==true) resStr=GetCheckDataExcel();
    else resStr=QueryPrintDataExcel();
    var prtFlagInd=varList.length+2  //GetArrayIndex(varList,"prtFlag");
    var oeoriIdInd=varList.length  //GetArrayIndex(varList,"oeoriId");
    var labNoInd=GetArrayIndex(varList,"labNo");
    SortListByCol(myData,labNoInd,true)
    var oeoriIdStr="";

    var getArcimShortDesc=document.getElementById("GetArcimShortDesc").value;
    for (i=0;i<myData.length;i++)
    {
        if ((myData[i][prtFlagInd]!="Y")||(chkSelPrint==true))
    	   {
            var oeoriId=myData[i][oeoriIdInd];
            var labNo=myData[i][labNoInd];
            var arcdes=GetArcim1(oeoriId);
            var RetStr=arcdes.split("@")
            var orderitem=RetStr[0].split("|");
            var specDesc="";
            if (specDescInd>-1) specDesc=myData[i][specDescInd];
            if (specDesc.length>1)
            {           
                if (oeoriIdStr.length==0){oeoriIdStr=oeoriId}
                else{oeoriIdStr=oeoriIdStr+"^"+oeoriId}
                var PatInfo=document.getElementById("PatInfo").value;
                var str=cspRunServerMethod(PatInfo,oeoriId);
                var arr=str.split("^");//regNo_"^"_ctloc_"^"_room_"^"_sex_"^"_pagName
                var regNo=arr[0];
                var ctloc=arr[1]; var room=arr[2];
                var RecLoc=orderitem[11];
                var OrdName=""  ///reclocDesc
                var Sex=arr[3];
                var PatName=regNo+" "+arr[4]
                var Age=arr[7]
                var patLoc=arr[1]
                var bedCode=arr[6]
            
                var tmpList=arr[1].split("-");
                if (tmpList.length>1) patLoc=tmpList[1];
                OrdName=cspRunServerMethod(getArcimShortDesc,"",oeoriId);//ypz 080717 //orderitem[0];
                                
                tmpList=specDesc.split("/");
                for (j=0;j<tmpList.length;j++)
                {
	                   //alert(tmpList[j]+","+labNo);continue;
                    Bar.LabNo=labNo;
                    Bar.RecLoc=RecLoc;
                    Bar.LabelDesc=tmpList[j];
                    Bar.PatLoc=patLoc;
                    Bar.OrdName=OrdName;
                    Bar.PatName=PatName;
                    Bar.Sex=Sex;
                    Bar.Age=Age;
                    Bar.BedCode=bedCode;
                    //Bar.FontName="C39HrP72DlTt"
                    Bar.PrintOut(1);
                }
            }
        }
    }
    if ((oeoriIdStr.length>0)&(chkSelPrint==false)){
      SetPrintFlag(oeoriIdStr)
    }	
}
function SetWeekSheet(xlsSheet,startDate,curRow,printList)
{
	var tmpList=startDate.split("/");
	if (tmpList.length>2) {
	   	var curDate=new Date(tmpList[2],tmpList[1]-1,tmpList[0]);
	}
	else var curDate = new Date();
	var curDay=curDate.getDay();
	var curDateVal=curDate.getTime();
	curDateVal=curDateVal-(curDay-1)*60*60*24*1000
    for (j=0;j<7;j++){
		curDate.setTime(curDateVal);
	    xlsSheet.cells(curRow,cols-2+j)=(curDate.getMonth()+1)+"-"+curDate.getDate();
	    if (j==0) xlsSheet.cells(curRow-1,1)="    "+xlsSheet.cells(curRow-1,1)+(curDate.getMonth()+1)+"-"+curDate.getDate()+" 至 ";
	    if (j==6) xlsSheet.cells(curRow-1,1)=xlsSheet.cells(curRow-1,1)+(curDate.getMonth()+1)+"-"+curDate.getDate();
	    curDateVal=curDateVal+60*60*24*1000
    }
	xlsSheet.cells(curRow,1)=t['val:startDate']
	var sttDateTimeInd=GetArrayIndex(varList,"sttDateTime");
	for (j=0;j<printList.length;j++){
	    var tmpDateList=printList[j][sttDateTimeInd].split(" ")
	    if (tmpDateList.length>0) {
		    tmpDateList=tmpDateList[0].split("-");
		    if (tmpDateList.length>2) printList[j][sttDateTimeInd]=tmpDateList[1]+"-"+tmpDateList[2]
	    }
	}
}

function GetArrayIndex(varArray,val)
{
	for (i=0;i<varArray.length;i++)
	{
		if (varArray[i]==val) {return i;}
	}
	return -1;
}
function SetPrintFlag(oeoriIdStr)
{  
    //var queryTypeCode=document.getElementById("vartyp").value;
    var wardId=document.getElementById("wardid").value;
    var userId=session['LOGON.USERID'];
    var SetPrintFlag=document.getElementById("SetPrintFlag").value;
    if (oeoriIdStr!="")
    {
        if (!printedFlag)
        {
	        resStr=cspRunServerMethod(SetPrintFlag,wardId,userId,queryTypeCode,oeoriIdStr);
            PrintDateTime=resStr;
            printedFlag=true;
        }
    }
}
function DateDemo(){
    var d, s="";
    d = new Date();
    s += d.getDate() + "/";
    s += (d.getMonth() + 1) + "/";
    s += d.getYear();
    return(s);
}
function CopyToExcelSyd(dataList,xlsSheet,frow,trow,fcol,tcol,xlsTop,xlsLeft)
{
    var i,j
    for (i=frow;i<=trow;i++)
    {   
    	xlsSheet.cells(xlsTop+i,1)=dataList[i][3]
    	xlsSheet.cells(xlsTop+i,2)=dataList[i][4]
    	xlsSheet.cells(xlsTop+i,3)=dataList[i][5]
    	xlsSheet.cells(xlsTop+i,4)=dataList[i][6]
    	xlsSheet.cells(xlsTop+i,5)=dataList[i][7]
    	xlsSheet.cells(xlsTop+i,6)=dataList[i][10]
    	// xlsSheet.cells(xlsTop+i,8)=dataList[i][12]+dataList[i][11]
    }
    return true  
}
function writeTitlezl(xlsSheet,actRow)
 { //cure sheet title
	xlsSheet.cells(actRow,1)=GetTitleNameByCode("arcimDesc");
    xlsSheet.cells(actRow,2)=GetTitleNameByCode("doseQtyUnit");  //former:use qty;
    xlsSheet.cells(actRow,4)=GetTitleNameByCode("phcinDesc");
    xlsSheet.cells(actRow,3)=GetTitleNameByCode("phcfrCode");
    xlsSheet.cells(actRow,5)=GetTitleNameByCode("execCtcpDesc")+"/"+GetTitleNameByCode("execDateTime");
 }
function PrintSYD()
{
    var startDate=parent.frames["NurseTop"].document.getElementById("StartDate").value; 
    var endDate=parent.frames["NurseTop"].document.getElementById("EndDate").value;
    if (GetDate(startDate)!=GetDate(endDate)) {alert(t['alert:sameStartEndDate']);return;};

    if ((queryTypeCode!="SYD")&&(queryTypeCode!="CQSY")) return;
    if (queryTypeCode=="SYD"){sytyp=t['val:temp']; }
    if (queryTypeCode=="CQSY"){sytyp=t['val:long']; }
	var execDateTime=GetPrintDateTime(0,"-",false);//PrintDateTime=DateDemo(); ypz 060928
    ////var SyCard=document.getElementById("SyCard").value;

    var num=0;
    var chkSelPrint=document.getElementById('chkSelPrint').checked;
    myData=[];
	if (chkSelPrint==true) resStr=GetCheckData();
	else resStr=QueryPrintData();
	if (resStr!="0"){alert(resStr); return;}  //can't print!
	

	  /*  var arcimDesc=myData[i][arcimDescInd];
		var tmpList=arcimDesc.split("____");
		if ((tmpList.length<2)){
	       	if (oeoriIdStr.length==0){oeoriIdStr=oeoriId;}
           	else{oeoriIdStr=oeoriIdStr+"^"+oeoriId}
           	var pos;
           	var str=cspRunServerMethod(ordPrintInfo,oeoriId,longNewOrdAdd);
 			// alert(str);return;
           	if (str!="")
           	{	//alert(str);continue;
	       		//if (queryTypeCode=="SYD"){
    	       		Card.OrderString=str;
              		Card.SetPrint();
           	   		Card.PrintSycd();
	       		//}
           	}
		}
	}

/*
    Bar= new ActiveXObject("PrintBar.PrnBar");//TestAx.CLSMAIN
    Bar.SetPageSize();
    for (i=0;i<myData.length;i++)
    {   
    	var arcimDesc=myData[i][arcimDescInd];
       	var tmpArcimList=arcimDesc.split("____");
       	if (tmpArcimList.length<2)
        {
        	var ord=myData[i][oeoriIdInd];
        	alert(ord)
        	var ret=cspRunServerMethod(SyCard,ord);
        	alert(ret)
        	if (ret!="")
        	{alert(sytyp)
        	   	var tem=ret.split("^");
        	   	Bar.Ord=tem[0];
        	   	Bar.PatLoc=tem[5];
        	   	Bar.PatName=tem[1];
        	   	Bar.BedCode=tem[2];
        	   	Bar.SYName =t['val:bottleCard'];
        	   	Bar.SYTYP = sytyp;
        	   	Bar.StDateTime=execDateTime
        	   	Bar.SYCWIDTH =5900 //11900;// 5900;  //2977;
        	   	Bar.SYDHEIGHT = 4050;  //4196
        	   	Bar.PrintSYCARD();
        	   	num=num+1;
        	}
        }
    }
	Bar.NewPage();
    Bar.EndDoc();
    Bar=null;*/
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
function titleLable(xlsSheet,warddes,dateTimeStr,type,Row,printList,queryTypeCode,labCount)
{
	var pgnum=21;
    var pg="";
    pg=(Row+1)%21;
    if (pg==0)
    {  //pug title to next page
	    Row=Row+2;
    }
    pg=Row%21
    if(pg==0)
    {
	    Row=Row+1;
	}
	//alert("intitle"+PrintDateTime)
    FontStyle(xlsSheet,Row,1,5,10);//12
    var setStr;
    //xlsSheet.cells(Row,1)=GetTitleNameByCode("bedCode")+":"+printList[0][1]+"    "+printList[0][0]+"    "+printList[0][2]+"    "+PrintDateTime;
    xlsSheet.cells(Row,1)=warddes+"    "+printList[0][1]+"    "+printList[0][0]+"    "+printList[0][2]+"    "+dateTimeStr;

    if (queryTypeCode.indexOf("JYD")>-1) {//ypz 061116
	    //xlsSheet.cells(1,1)= xlsSheet.cells(1,1)+"("+warddes+")"
	    xlsSheet.cells(Row,1)=warddes+"    "+t['val:specCount']+labCount+"    "+t['val:specSender']+"          "+t['val:specReceiver'];  
    }
    return Row+1

}
function setFrameTitle(xlsSheet,warddes,dateTimeStr,type,Row,printList,queryTypeCode,labCount)
{
	/*var pgnum=21;
    var pg="";
    pg=(Row+1)%21;
    if (pg==0){  Row=Row+2;   }//pug title to next page
    pg=Row%21
    if(pg==0){Row=Row+1;}*/
	//alert("intitle"+PrintDateTime)
    FontStyle(xlsSheet,Row,1,5,10);//12
    var setStr;
    //xlsSheet.cells(Row,1)=GetTitleNameByCode("bedCode")+":"+printList[0][1]+"    "+printList[0][0]+"    "+printList[0][2]+"    "+PrintDateTime;
    var chkSelPrint=document.getElementById('chkSelPrint').checked;
    if (chkSelPrint) xlsSheet.cells(Row,1)=printList[0][1]+"    "+printList[0][0]+"    "+printList[0][2]+",   "+warddes+"        "+dateTimeStr;
    else xlsSheet.cells(Row,1)=printList[0][1]+"    "+printList[0][0]+"    "+printList[0][2]+"    "+warddes+"        "+dateTimeStr;
    if (queryTypeCode.indexOf("JYD")>-1) {//ypz 061116
	    //xlsSheet.cells(1,1)= xlsSheet.cells(1,1)+"("+warddes+")"
	    xlsSheet.cells(Row,1)=warddes+"    "+t['val:specCount']+labCount+"    "+t['val:specSender']+"         "+t['val:specReceiver']+"         "+t['val:specReceiveTime'];  
    }
    return Row+1

}
function SortListByCol(list,col,ascendBool)
{   //sort list by number col,ascendBool:ascend or descend order
	var tmpList=[],i,j;
	for (i=0;i<list.length-1;i++)
	{
	    for (j=i+1;j<list.length;j++)
	    {
		    if ((list[i][col]>list[j][col])==ascendBool)
		    {
		    	var tmpList=list[i];list[i]=list[j];list[j]=tmpList;
		    }		     
	    }
	}
}
function GetFrameMark(queryTypeCode,dataList,oeoriIdInd)
{
	if (queryTypeCode.indexOf("JYD")<0){
		var tmpList=dataList[oeoriIdInd].split("||");
		if (tmpList.length>0) return tmpList[0];
	}
	else {
		var sortCol=GetArrayIndex(varList,"reclocDesc");
		if (sortCol>-1) return dataList[sortCol];
	}
	return -1
}
function GetLabCount(queryTypeCode,labNoStr,curLabNo) //ypz 061128
{
	if (queryTypeCode.indexOf("JYD")<0) return -1;
	var tmpLabNoList;
	tmpLabNoList=labNoStr.split("^"+curLabNo+"^")
	//alert(curLabNo+"/"+labNoStr)
	if ((curLabNo.length>0)&&(tmpLabNoList.length<2)) labNoStr=labNoStr+curLabNo+"^";
	//alert(curLabNo+"/after/"+labNoStr)

	return labNoStr;
}
function SetFrameData(queryTypeCode,printList,actRow,xlsSheet,xlsLeft,xlsTop,typeDesc,labNoStr,maxFrameCols,framePrint) //ypz 061128
{   
    var PatInfo=document.getElementById("PatInfo").value;
    //alert("set:"+printList[0][oeoriIdInd])
    var str=cspRunServerMethod(PatInfo,printList[0][oeoriIdInd]);//0 have data!!
    var arr=str.split("^");//regNo_"^"_ctloc_"^"_room_"^"_sex_
    var warddes=arr[8];
    var tmpLabNoList=labNoStr.split("^");
	var labCount=tmpLabNoList.length-2;
	var j,k,dateTimeStr;
	/*for (j=0;j<myColumns.length;j++)
	{
        if (j==GetArrayIndex(varList,"execCtcpDesc"))  //clear exec Careprovider col
        {
	        for (k=0;k<printList.length;k++){printList[k][j]="";}
        }
    }*/
	if (longNewOrdAdd){
    	dateTimeStr=GetPrintDateTime(0,".",false)+" 0:00-"+GetPrintDateTime(0,".",false)+" 15:59";
    	//teTimeStr=GetPrintDateTime(0,".",false)+" 00:00 - 23:59";
	}
	else{
    	dateTimeStr=GetPrintDateTime(0,".",false)+" 16:00-"+GetPrintDateTime(86400,".",false)+" 15:59";
    	//dateTimeStr=GetPrintDateTime(86400,".",false)+" 00:00 - 23:59";
	}
	if (queryTypeCode=="ZCQ") dateTimeStr="";
    actRow= setFrameTitle(xlsSheet,warddes,dateTimeStr,typeDesc,actRow+xlsTop,printList,queryTypeCode,labCount);
    //if ((queryTypeCode!="CQZLD")&&(queryTypeCode!="LSZLD")){
       for (j=4;j<cols-1;j++) {xlsSheet.cells(actRow,j-3)=myColumns[j];}
       if (queryTypeCode.indexOf("JYD")>-1){xlsSheet.cells(actRow,4)="性别";}
	    if (execXUserDescInd>2)  xlsSheet.cells(actRow,execXUserDescInd-2)="核对人";
    //}
    //else{writeTitlezl(xlsSheet,actRow);}
	
	//ypz 061219 begin
	if (queryTypeCode=="ZCQ"){
		//alert(printList)
		var startDate=parent.frames["NurseTop"].document.getElementById("StartDate").value;
		SetWeekSheet(xlsSheet,startDate,actRow,printList,varList);
		//alert("later"+printList)
	}
    //ypz 061219 end
	actRow=eval(actRow)+1;
	var str=CopyToExcel(printList,xlsSheet,0,printList.length-1,4,cols-2,actRow,xlsLeft)
	var tem=str.split("^");
	actRow=eval(tem[0]);
	var p=tem[1];
	if (framePrint=="Y") {
		gridlist(xlsSheet,actRow,actRow-printList.length-p,1,maxFrameCols);
	    if (queryTypeCode.indexOf("PSD")<0) gridlistlink(xlsSheet,actRow,actRow-printList.length-p,1,maxFrameCols);
	}
   	//alert(i+"///////"+myData[i])
	actRow=eval(actRow)+1; //a blank line after frame
	return actRow;
}

function SavePrint()
{
 	var startDate=parent.frames["NurseTop"].document.getElementById("StartDate").value; 
    var chkSelPrint=document.getElementById('chkSelPrint').checked;
    //if (chkSelPrint!=true) return 


    var i,j,tmpStr,retStr,dischOrd,check,objOrdStatDesc;
	var objtbl=document.getElementById('tDHCNURSEXCUTE');
	var retStr=t['alert:selOrder']
    var tmpList=new Array();
    var curOrdId,mainOrdId=0,mainCheck=false,mainOriSub=0;
    var saveData=new Array();
    saveData=[];
    for (i=1;i<objtbl.rows.length;i++)
    {
	    var PrintFlag=document.getElementById('tmpPrtFlagz'+i).innerText;
	    if (debug) alert(oeoriId);
		tmpList=[]
	   	for (j=0;j<varList.length;j++)
	   	{   var obj=document.getElementById(varList[j]+'z'+i);
	   	  	tmpStr="";
	   	   	if (obj) {if (varList[j]!="placerNo") tmpStr=obj.innerText; else  tmpStr=obj.value}
	           tmpList[j]=tmpStr;
	    }
	    tmpStr=document.getElementById('oeoriIdz'+i).innerText;
	    tmpList[tmpList.length]=tmpStr;
	    tmpStr=document.getElementById('placerCodez'+i).innerText;
	    tmpList[tmpList.length]=tmpStr;
	    tmpStr=document.getElementById('disposeStatCodez'+i).innerText;
	    tmpList[tmpList.length]=tmpStr;
	    tmpStr=document.getElementById('tmpPrtFlagz'+i).innerText;
	    tmpList[tmpList.length]=tmpStr;
	    tmpStr=document.getElementById('seleitemz'+i).checked;
	    tmpList[tmpList.length]=tmpStr;
		    
	    saveData[saveData.length]=tmpList;
	    retStr=0;
    }
    if (retStr!=0) return;


    var xlsExcel,xlsSheet,xlsBook;
    var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
    var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
    var strList,tmpList,tmpStr,i,j,k,xlsTop,xlsLeft,typeInd,typeDesc;
    var path,fileName,fso,frameMark,labCount=0;//rows per page
   	path = GetFilePath();
    fileName="";
    var GetVarType=document.getElementById("GetVarType");
   	var str=cspRunServerMethod(GetVarType.value,queryTypeCode);
    tmpList=str.split("^");
   	if (tmpList.length>2) {fileName=tmpList[1];typeDesc=tmpList[0];patPrint=tmpList[2];framePrint=tmpList[3]}
   	if (fileName.length<2) { alert(t['alert:noExcelFile']);return false}
    fileName=path+fileName
   	var PrintDateTime=GetPrintDateTime(0,"-",false);  //ypz 060928
  	cols=oeoriIdInd;

    xlsExcel = new ActiveXObject("Excel.Application");
    xlsBook = xlsExcel.Workbooks.Add(fileName) //;Open(fileName)
    xlsSheet = xlsBook.ActiveSheet; //Worksheets(1)
    xlsTop=1;xlsLeft=1;
    var oeoriIdStr="",preFrameMark=0,maxFrameCols=cols;//alert("len="+oeoriIdStr.length)

    var warddes="";
    var tmpPrintList=new Array();
    //xlsExcel.Visible = true;

	if (saveData.length<1) {return false}
    
    
    for (j=0;j<myColumns.length;j++){
        xlsSheet.cells(2,j+1)=myColumns[j]
    }
    xlsSheet.cells(2,cols+1)="oeoriId"
    xlsSheet.cells(2,cols+2)="placerCode"
    xlsSheet.cells(2,cols+3)="disposeStatCode"
	xlsSheet.cells(2,cols+4)="tmpPrtFlag"
    xlsSheet.cells(2,cols+5)="select"
    
    
    for (i=0;i<saveData.length;i++)
    {
	    for (j=0;j<cols+5;j++)
	    xlsSheet.cells(i+3,j+1)=saveData[i][j]
    }
    titleRows=0, titleCols=0;
    xlsSheet.cells(1,1)=typeDesc+"  checked="+chkSelPrint+" "+startDate+" user:"+session['LOGON.USERCODE'] //ypz 070319
    xlcenter(xlsSheet,1,1,maxFrameCols)
    mergcell(xlsSheet,1,1,maxFrameCols)
    FontStyle(xlsSheet,1,1,6,14)
    LeftHeader =""; //'Chr(13) &""
    RightHeader = "" ;LeftFooter ="";CenterFooter = "";RightFooter = "";
    ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter) 
    ////xlsSheet.printout
	//xlsExcel.Visible = true;
	//xlsSheet.PrintPreview ;
	
	var savefileName="C:\\Documents and Settings\\"+queryTypeCode

	var d = new Date();
    savefileName+=d.getYear()+"-"+(d.getMonth()+ 1)+"-"+d.getDate();
	savefileName+=" "+d.getHours()+","+d.getMinutes()+","+d.getSeconds();
	savefileName+=".xls"
    xlsSheet.SaveAs(savefileName);
    xlsSheet = null;
    xlsBook.Close(savechanges=false);
    xlsBook = null;
    xlsExcel.Quit();
    xlsExcel = null;
    
}
function CheckOrdErr()
{
	var i,preOeordId=0,oeordId,mainOriSub=0;
	for (i=0;i<myData.length;i++)
    {
 		var tmpList=myData[i][oeoriIdInd].split("||");
		if (tmpList.length>0) oeordId=tmpList[0];
		else {return "医嘱RowId错!"}
		
       	var arcimDesc=myData[i][arcimDescInd];
       	var tmpArcimList=arcimDesc.split("____");
        if (tmpArcimList.length<2) {
	        preOeordId=oeordId;
	        mainOriSub=tmpList[1];
        }
        else {
        	if (preOeordId!=oeordId) return "医嘱"+arcimDesc+"("+myData[i][oeoriIdInd]+")关联错!"
        	tmpArcimList=arcimDesc.split(mainOriSub);
	        if (tmpArcimList[0]!="____") 
        	{
        		if (tmpArcimList[0]=="*____"){return "医嘱"+arcimDesc+"("+myData[i][oeoriIdInd]+")未打包!"}
        		else {return "医嘱"+arcimDesc+"("+myData[i][oeoriIdInd]+")关联错!"}
        	}
        }
    }
    return 0
}

function DisableQuery()
{
	var obj=document.getElementById("printbut");
	if (obj)
	{	obj.disabled=true;
		obj.onclick=function(){return false;}
	}
}
function EnableQuery()
{
	var obj=document.getElementById("printbut");
	if (obj) {obj.disabled=false;
	obj.onclick=PrintClick;
	}
}



//===============from now on ypz 071120 add 
//
var relatedQueryStr="SYD^CQSY^ZSD^CQZS^ZCQ"
var onlyNewOrd=false
var objOnlyNewOrd=parent.frames['NurseTop'].document.getElementById("onlyNewOrd");
if (objOnlyNewOrd) onlyNewOrd=objOnlyNewOrd.checked;
var onlyNewOrdStr="";
//if ((onlyNewOrd)&&(queryTypeCode!="ZCQ")) onlyNewOrdStr=" - "+t['val:onlyNewOrd']; //" - 仅新开医嘱" //

function QueryPrintDataExcel()
{
    //if (ordStatDescInd<0) {return t['alert:disOrdStat'];}
    var gap="",rows=0,printFlag;
    var regNo=document.getElementById("RegNo").value;
    var sDate=document.getElementById("StartDate").value;
    var eDate=document.getElementById("EndDate").value;
    var queryTypeCode=document.getElementById("vartyp").value;
    var wardId=document.getElementById("wardid").value;
    var locId=document.getElementById("Loc").value;
    var dept=parent.frames['NurseTop'].document.getElementById("Dept").value;
    var doctyp=parent.frames['NurseTop'].document.getElementById("Doctyp").checked;
    if (dept==""){locId="";}
    var userId=session['LOGON.USERID'];
    
    var findPatient=document.getElementById("FindPatient").value;
    var getAllPatient=document.getElementById("GetAllPatient").value;
    var getOrderItem=document.getElementById("GetOrderItem").value;
    var getData=document.getElementById("GetData").value;
    var tmpList=new Array();   
    var patList=new Array();
    //var kmtemp=document.getElementById("kmtemp").value;  //ypz061228
    //var rj=cspRunServerMethod(kmtemp);  //ypz 061228
    var retStr=t['alert:noPrintData'];
		//alert("wardid=" + wardId+" userId=" + userId+" regNo="+regNo)
	resStr=cspRunServerMethod(findPatient,wardId,regNo,userId,"I",sDate,eDate);
	if (resStr=="") {return t['alert:databaseError'];}
	if (resStr<1) {return t['alert:noPatData'];}
	var patStr=cspRunServerMethod(getAllPatient,"","",userId);
	patList=patStr.split("^");
	myData=[]; //ypz 070327
	for (var i=0;i<patList.length;i++)
	{
	    tmpList=patList[i].split("!")
	    //alert(tmpList[0]+","+sDate+","+eDate+","+userId+","+wardId+" "+queryTypeCode)
	    var ordItems=cspRunServerMethod(getOrderItem,"","",tmpList[0],sDate,eDate,userId,wardId,queryTypeCode,gap,locId,doctyp,longNewOrdAdd,onlyNewOrd);
	    var tmpItemList=ordItems.split("^");
	    if (tmpItemList.length<2) continue;
	    for (j=1;j<=tmpItemList[0];j++)
	    {
		    var itemData=cspRunServerMethod(getData,"","",j,userId,tmpItemList[1]);
			tmpList=(itemData).split("!");
			if ((tmpList[disposeStatInd]!="Discontinue")&&(tmpList[disposeStatInd]!="ExecDiscon")){
				printFlag=tmpList[oeoriIdInd+3]
				if (((queryTypeCode!="ZCQ")&&(printFlag.indexOf("Y")<0))||((queryTypeCode=="ZCQ")&&(printFlag.indexOf("M")<0))) {
			    	retStr=0;
		       		rows=rows+1;
			   		myData[rows-1]=tmpList;
				}
			}
		}
	}
	return retStr;
}
function GetCheckDataExcel()
{
    var i,j,tmpStr,retStr,dischOrd,check,objOrdStatDesc;
	var objtbl=document.getElementById('tDHCNURSEXCUTE');
	retStr=t['alert:selOrder']
    var tmpList=new Array();
    
    var curOrdId,mainOrdId=0,mainCheck=false,mainOriSub=0;
    myData=[];
    for (i=1;i<objtbl.rows.length;i++)
    {
	    check=document.getElementById('seleitemz'+i);
	    objDisposeStatCode=document.getElementById('disposeStatCodez'+i);
	    if (! objDisposeStatCode) { alert(t['alert:disOrdStat']);return}
	    var disposeStatCode=objDisposeStatCode.innerText;
		//if (check.checked==true) {
	    
	    //ypz 070709 begin
        var oeoriId=document.getElementById('oeoriIdz'+i).innerText;
	    var tmpOrdList=oeoriId.split("||");
        var oriSub=tmpOrdList[1];
        if (mainOriSub==0) {mainOriSub=oriSub;mainCheck=check.checked;}
        curOrdId=tmpOrdList[0];
        if (mainOrdId!=curOrdId) mainOrdId=curOrdId;
	    var arcimDesc=document.getElementById("arcimDescz"+i).innerText;
	    var arcimList=arcimDesc.split(mainOriSub)
	    if ((arcimList[0]=="____")&&(queryTypeCode.indexOf("PSD")<0)){
		    if (mainCheck!=check.checked) return arcimDesc+":主医嘱和关联医嘱选择标志不一致! "+oeoriId
	    }
	    else{mainOriSub=oriSub;mainCheck=check.checked;}
		//ypz 070709 end    
		
        if ((check.checked==true)&&(disposeStatCode!="Discontinue")&&(disposeStatCode!="ExecDiscon")) {
            var PrintFlag=document.getElementById('tmpPrtFlagz'+i).innerText;
		    if (debug) alert(oeoriId);
			tmpList=[]
	    	for (j=0;j<varList.length;j++)
	    	{   var obj=document.getElementById(varList[j]+'z'+i);
	    	  	tmpStr="";
	    	   	if (obj) {if (varList[j]!="placerNo") tmpStr=obj.innerText; else  tmpStr=obj.value}
	            tmpList[j]=tmpStr;
		    }
		    tmpStr=document.getElementById('oeoriIdz'+i).innerText;
		    tmpList[tmpList.length]=tmpStr;
		    tmpStr=document.getElementById('placerCodez'+i).innerText;
		    tmpList[tmpList.length]=tmpStr;
		    tmpStr=document.getElementById('disposeStatCodez'+i).innerText;
		    tmpList[tmpList.length]=tmpStr;
		    tmpStr=document.getElementById('tmpPrtFlagz'+i).innerText;
		    tmpList[tmpList.length]=tmpStr;
		    
		    myData[myData.length]=tmpList;
		    retStr=0;
	    }
    }
    return retStr;
}

function PrintClickExcel()
{
 	var startDate=parent.frames["NurseTop"].document.getElementById("StartDate").value; 
	var endDate=parent.frames["NurseTop"].document.getElementById("EndDate").value;
    //if ((queryTypeCode!="ZCQ")&&(GetDate(startDate)!=GetDate(endDate))) {alert(t['alert:sameStartEndDate']);return;};
    var chkSelPrint=document.getElementById('chkSelPrint').checked;
    var printList=[],patPrint,framePrint,actRow=1,resStr,labNoStr="^";
	//myData=[];  //ypz rem 070327
	DisableQuery() //ypz 070730
	if (chkSelPrint==true) resStr=GetCheckDataExcel();
	else resStr=QueryPrintDataExcel();
	if (resStr!="0"){alert(resStr); EnableQuery();return;}  //can't print!
	if (queryTypeCode.indexOf("PSD")<0) resStr=CheckOrdErr();
	
	if (resStr!="0"){alert(resStr); EnableQuery();return;}  //can't print!
	if (queryTypeCode=="CQSY") {SavePrint();}  //ypz temp 070716
   	if (queryTypeCode=="JCD")
	{   JCDPRN(chkSelPrint);
	    EnableQuery();return ;
	} 
	if (queryTypeCode.indexOf("JYD")>-1)
	{   
	    ////JYDPRN(chkSelPrint);  //ypz 061209
	    ////PrintBar();
    	////EnableQuery();return ;  //ypz 061109
    	resStr=CheckPlacerNo();
    	if (resStr!=0) {alert(resStr);return;}
    	//return;
	}
    var xlsExcel,xlsSheet,xlsBook;
    var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
    var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
    var strList,tmpList,tmpStr,i,j,k,xlsTop,xlsLeft,typeInd,typeDesc;
    var path,fileName,fso,frameMark,labCount=0;//rows per page
	// if (queryTypeCode=="SYD") // {  //  PrintSYDClick();  //  return ;  // } 
   	path = GetFilePath();
    fileName="";
    var GetVarType=document.getElementById("GetVarType");
   	var str=cspRunServerMethod(GetVarType.value,queryTypeCode);
    tmpList=str.split("^");
   	if (tmpList.length>2) {fileName=tmpList[1];typeDesc=tmpList[0];patPrint=tmpList[2];framePrint=tmpList[3]}
   	if (fileName.length<2) { alert(t['alert:noExcelFile']);EnableQuery();return false}
    fileName=path+fileName
   	var PrintDateTime=GetPrintDateTime(0,"-",false);  //ypz 060928
  	cols=oeoriIdInd;
	//alert(myData);//return;
	chkSelPrint=false;
    xlsExcel = new ActiveXObject("Excel.Application");
    xlsBook = xlsExcel.Workbooks.Add(fileName) //;Open(fileName)
    xlsSheet = xlsBook.ActiveSheet; //Worksheets(1)
    xlsTop=1;xlsLeft=1;
    var oeoriIdStr="",preFrameMark=0,maxFrameCols=cols-3;//alert("len="+oeoriIdStr.length)
    if (queryTypeCode=="ZCQ")	maxFrameCols=maxFrameCols+7;

    var warddes="";
    var tmpPrintList=new Array();
    //xlsExcel.Visible = true;

	if (queryTypeCode.indexOf("JYD")>-1) //ypz 061116
	{  	
		var sortCol=GetArrayIndex(varList,"reclocDesc");
	   	SortListByCol(myData,sortCol,true)
	   	maxFrameCols=10
	}
	if (myData.length<1) {alert(t['alert:queryFirst']);EnableQuery();return false}
    //strList=titleStr.split("!")
    //cols=oeoriIdInd; actRow=1; //actRow=0;
    //xlsExcel.Visible = true;
    var phcfrFactor=0,ordGruopCount=0;
    for (i=0;i<myData.length;i++)
    {   //if (debug) alert(myData[i][cols+3])
       	//ypz 061226//if ((myData[i][ordStatDescInd]!=t['val:dischOrd']))  ///ypz 061224 :(myData[i][cols+3]!="Y")&&
        {   
            if (oeoriIdStr.length==0){oeoriIdStr=myData[i][oeoriIdInd]}
            else{oeoriIdStr=oeoriIdStr+"^"+myData[i][oeoriIdInd]}
            if (prtFlagInd>-1) myData[i][prtFlagInd]="Y"+myData[i][prtFlagInd];
       		var arcimDesc=myData[i][arcimDescInd];
       		var tmpArcimList=arcimDesc.split("____");
            if (patPrint!="Y"){printList[printList.length]=myData[i];}//not pat print
            else { //pat print
	            //if (debug) alert(myData[i][oeoriIdInd])
	            frameMark=GetFrameMark(queryTypeCode,myData[i],oeoriIdInd); //frame
                if (preFrameMark==0){preFrameMark=frameMark}
               		
               	if (tmpArcimList.length<2){ //start of a group
					//frist insert null into pregroup
               	    if (oeoriIdStr!=myData[i][oeoriIdInd]){  //for pre null line
  	        			if (phcfrFactor<=ordGruopCount) phcfrFactor=ordGruopCount+1;
  	        			if (queryTypeCode.indexOf("JYD")>-1) phcfrFactor=ordGruopCount-1;
  	        			if (("^"+relatedQueryStr+"^").indexOf(queryTypeCode)>-1){
	  	        			for (k=0;k<phcfrFactor-ordGruopCount;k++){
	               	    		var nullList=[];
   			    	       		for (j=0;j<varList.length;j++){nullList[j]=""}
	               	    		printList[printList.length]=nullList;
	  	        			}
        				}
               		}
               		//end of pre null line insert,begin cur line
              		phcfrFactor=0;
	    			if ((freqInd>-1)&&(queryTypeCode=="ZCQ")){
	    				var getPhcfrFactor=document.getElementById("getPhcfrFactor").value;
  	        			phcfrFactor=cspRunServerMethod(getPhcfrFactor,myData[i][freqInd]);
	        		}
	        		//if need end frame
	                if (preFrameMark==frameMark){ //confirm frame:oeordId or recloc
		            	if (queryTypeCode.indexOf("JYD")>-1) labNoStr=GetLabCount(queryTypeCode,labNoStr,myData[i][labNoInd]);
	    	        } //end of one frame confirm frame:oeordId or recloc
	        	    else{ //start a new frame,another pat or recloc
		        	   // if (i<myData.length-1){
		            	mergcell(xlsSheet,actRow+1,1,maxFrameCols);
			          	actRow=SetFrameData(queryTypeCode,printList,actRow,xlsSheet,xlsLeft,xlsTop,typeDesc,labNoStr,maxFrameCols,framePrint); //ypz 061128
		                if (queryTypeCode.indexOf("JYD")>-1){
		                	labNoStr="^";
	            			labNoStr=GetLabCount(queryTypeCode,labNoStr,myData[i][labNoInd]);
		                }
		            	printList=[];
		            	////////////printList[printList.length]=myData[i];
		            	preFrameMark=frameMark;
		            //}
	            	}//end of another patient or recloc
	        		ordGruopCount=1;
                }
                else {
	                ordGruopCount=ordGruopCount+1;
            	}
                printList[printList.length]=myData[i];

	            if (i==myData.length-1){  //last item add frame
  	        		if (("^"+relatedQueryStr+"^").indexOf(queryTypeCode)>-1){
  	        			for (k=0;k<phcfrFactor-ordGruopCount;k++){
	               	   		var nullList=[];
   			    	   		for (j=0;j<varList.length;j++){nullList[j]=""}
	               	   		printList[printList.length]=nullList;
  	        			}
        			}
			        mergcell(xlsSheet,actRow+1,1,maxFrameCols);
		            actRow=SetFrameData(queryTypeCode,printList,actRow,xlsSheet,xlsLeft,xlsTop,typeDesc,labNoStr,maxFrameCols,framePrint);
		        }
            }//end of frame print(pat,recloc)
        }//unuse current
    } //end of myData[i]
    /*if (oeoriIdStr.length>0){
        if (! longNewOrdAdd) SetPrintFlag(oeoriIdStr);
    }*/
    if ((oeoriIdStr.length>0)&(chkSelPrint==false)){
      SetPrintFlag(oeoriIdStr)
    }
    titleRows=0, titleCols=0;
    xlsSheet.cells(1,1)=hospitalName+"  "+typeDesc+onlyNewOrdStr  //ypz 070319
    xlcenter(xlsSheet,1,1,maxFrameCols)
    mergcell(xlsSheet,1,1,maxFrameCols)
    FontStyle(xlsSheet,1,1,6,14)
    LeftHeader =""; //'Chr(13) &""
    RightHeader = "" ;LeftFooter ="";CenterFooter = "";RightFooter = "";
    ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter) 
    xlsSheet.printout
	xlsExcel.Visible = true;
	///xlsSheet.PrintPreview ;
    xlsSheet = null;
    xlsBook.Close(savechanges=false);
    xlsBook = null;
    xlsExcel.Quit();
    xlsExcel = null;
    EnableQuery()
    //catch(e)
    //{
	//    alert(e.toString());
	//    xlsExcel.Quit();
	//}
}

function CheckPlacerNo()
{
	if (placerNoInd<0) return 0;
	var retStr=0
	for (var i=0;i<myData.length;i++) 
	{
	   if ((myData[i][placerNoInd].length<2)||(myData[i][placerNoInd]==" ")) {
		   retStr=t['alert:noPlacerNo']+" oeoriId="+myData[i][oeoriIdInd];
		   break;
		}
	}
	return retStr
}


