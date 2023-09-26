var myData=new Array();
var myColumns=new Array();
var printedFlag=false;
var debug=false;
var specDescInd,placerNoInd,reclocDescInd,GetTitle,titleStr,titleList,myColumns,varList,getPrintTitle,printTitleList,printDescList,printLenList,printVarList
var ordStatDescInd,execXDateTimeInd,execXUserDescInd,oeoriIdInd,disposeStatInd,disposeStatDescInd
var arcimDescInd,arcimDescInd,doseQtyUnitInd,phOrdQtyUnitInd,execStatInd,execDateTimeInd
var execCtcpDescInd,prtFlagInd,prtFlagInd,oecprDescInd,labNoInd,freqInd
var printCollectData=new Array();  //需置打印标记的医嘱
function getIfCheck()
{
    for(var i=1;i<checkData.length;i++)
    {
        if(checkData[i]===true)
        {
            return true;
        }
    }
    return false;
}

function IntVar()
{
if (queryTypeCode!="")
	{
	    GetTitle=document.getElementById("GetTitle").value;
	    titleStr=cspRunServerMethod(GetTitle,queryTypeCode,HospitalRowId);
	    if (titleStr.length==0) {alert(t['val:setVar']);}
	    titleList=titleStr.split("^")
	    myColumns=titleList[1].split("!")
		varList=titleList[2].split("!")
		getPrintTitle=document.getElementById("getPrintTitle").value; // + wxl 090309
    	//alert("queryTypeCode="+queryTypeCode+" HospitalRowId="+HospitalRowId)
    	printTitleStr=cspRunServerMethod(getPrintTitle,HospitalRowId+"@"+queryTypeCode);
    	if (printTitleStr.length==0) {alert(t['val:setVar']);}
    	printTitleList=printTitleStr.split("^")
    	printDescList=printTitleList[0].split("|")
    	printLenList=printTitleList[1].split("|")
		printVarList=printTitleList[2].split("|") // + wxl 090309
		ordStatDescInd=GetArrayIndex(varList,"ordStatDesc");
		execXDateTimeInd=GetArrayIndex(varList,"execXDateTime");
		execXUserDescInd=GetArrayIndex(varList,"execXUserDesc");
		oeoriIdInd=parseInt(titleList[0])
		disposeStatInd=oeoriIdInd+2;
		disposeStatDescInd=GetArrayIndex(varList,"disposeStatDesc");
		arcimDescInd=GetArrayIndex(varList,"arcimDesc");
		doseQtyUnitInd=GetArrayIndex(varList,"doseQtyUnit");
	    phOrdQtyUnitInd=GetArrayIndex(varList,"phOrdQtyUnit");
	    execStatInd=GetArrayIndex(varList,"execStat");
	    execDateTimeInd=GetArrayIndex(varList,"execDateTime");
	    execCtcpDescInd=GetArrayIndex(varList,"execCtcpDesc");
	    prtFlagInd=GetArrayIndex(varList,"prtFlag");
	    oecprDescInd=GetArrayIndex(varList,"oecprDesc");
	   	labNoInd=GetArrayIndex(varList,"labNo");
		freqInd=GetArrayIndex(varList,"phcfrCode");
		reclocDescInd=GetArrayIndex(varList,"reclocDesc")
		placerNoInd=GetArrayIndex(varList,"placerNo");
		specDescInd=GetArrayIndex(varList,"specDesc");
		
}
}
function GetTitleNameByCode(titleDesc)
{
	var titleDescInd=GetArrayIndex(varList,titleDesc);
	return myColumns[titleDescInd]
}
//flag 为true表示过滤医嘱同一天的其他执行记录
function QueryPrintData0422(printFlag,flag)
{
	if(!printFlag){
		printFlag="Y"
	}
    var gap="",rows=0,printFlag;
    var regNo=document.getElementById("RegNo").value;
    var sDate=document.getElementById("StartDate").value;
    var eDate=document.getElementById("EndDate").value;
    var queryTypeCode=document.getElementById("vartyp").value;
    var wardId=document.getElementById("wardid").value;
    var locId=document.getElementById("Loc").value;
    var doctyp=document.getElementById("Doctyp").checked;
    var userId=session['LOGON.USERID'];
    
    var findPatient=document.getElementById("FindPatient").value;
    var getAllPatient=document.getElementById("GetAllPatient").value;
    var getOrderItem=document.getElementById("GetOrderItem").value;
    var getData=document.getElementById("GetData").value;
    var tmpList=new Array();   
    var patList=new Array();
    var retStr=t['alert:noPrintData'];
    var GetTmpData=document.getElementById("GetTmpData").value;
    var GetTmpDataNum=document.getElementById("GetTmpDataNum").value;
    //var TmpNum=cspRunServerMethod(GetTmpDataNum,userId);
    var TmpNum=serverOrderData.length-1;
    var tem=new Array();
    var temstr;
    printCollectData=[];
    var getId=new Array();
    for (j=1;j<=TmpNum;j++)
    {
		//var itemData=cspRunServerMethod(GetTmpData,userId,j);
		var itemData=serverOrderData[j];
		//rows=rows+1
		tmpList=(itemData).split("!");
		temstr=tmpList[tmpList.length-6]+"!"+tmpList[tmpList.length-3]
		tem=temstr.split("!");
		if(tem[1].indexOf(printFlag)<0)      
		{
			var tempIdArray=tmpList[tmpList.length-6].split("||");
			printCollectData[printCollectData.length]=tmpList[tmpList.length-6]
		    //多条执行记录过滤同一天的
			if(getId[tempIdArray[0]+"||"+tempIdArray[1]+"||"+tmpList[tmpList.length-1]]!=undefined)
			{
				 if(flag){
				 	continue;
				 }
			}
			getId[tempIdArray[0]+"||"+tempIdArray[1]+"||"+tmpList[tmpList.length-1]]=1
			rows=rows+1
			myData[rows-1]=tem
		}
	}
	if (TmpNum!=0)
	{retStr=0;}

    return retStr;
}
function QueryPrintData(printFlag,flag)
{
  if(!printFlag){
    printFlag="Y"
  }
    var gap="",rows=0,printFlag;
    var regNo=document.getElementById("RegNo").value;
    var sDate=document.getElementById("StartDate").value;
    var eDate=document.getElementById("EndDate").value;
    var queryTypeCode=document.getElementById("vartyp").value;
    var wardId=document.getElementById("wardid").value;
    var locId=document.getElementById("Loc").value;
    var doctyp=document.getElementById("Doctyp").checked;
    var userId=session['LOGON.USERID'];
    
    var findPatient=document.getElementById("FindPatient").value;
    var getAllPatient=document.getElementById("GetAllPatient").value;
    var getOrderItem=document.getElementById("GetOrderItem").value;
    var getData=document.getElementById("GetData").value;
    var tmpList=new Array();   
    var patList=new Array();
    var retStr=t['alert:noPrintData'];
    //var GetTmpData=document.getElementById("GetTmpData").value;
    //var GetTmpDataNum=document.getElementById("GetTmpDataNum").value;
    //var TmpNum=cspRunServerMethod(GetTmpDataNum,userId);
    var TmpNum=serverOrderData.length-1;
    var tem=new Array();
    var temstr;
    printCollectData=[];
    var getId=new Array();
    var checked=getIfCheck();
    var oeordId="";
    for (j=1;j<=TmpNum;j++)
    {
    //var itemData=cspRunServerMethod(GetTmpData,userId,j);
    var itemData=serverOrderData[j];
    //rows=rows+1
    tmpList=(itemData).split("!");
    temstr=tmpList[tmpList.length-6]+"!"+tmpList[tmpList.length-3]+"!"+tmpList[tmpList.length-1]+"!"+tmpList[arcimDescInd]
    tem=temstr.split("!");
    var disposeStatCode=tmpList[tmpList.length-4]
    if((((checked===false)&&(tem[1].indexOf(printFlag)<0))||((checked===true)&&(checkData[j]===true)))&&(disposeStatCode!="Discontinue")&&(disposeStatCode!="ExecDiscon")) 
    {
      var tempIdArray=tmpList[tmpList.length-6].split("||");
      printCollectData[printCollectData.length]=tmpList[tmpList.length-6]
        //多条执行记录过滤同一天的
      if(getId[tempIdArray[0]+"||"+tempIdArray[1]+"||"+tmpList[tmpList.length-1]]!=undefined)
      {
         if(flag){
          continue;
         }
      }
      getId[tempIdArray[0]+"||"+tempIdArray[1]+"||"+tmpList[tmpList.length-1]]=1
      rows=rows+1
      myData[rows-1]=tem
    }
  }
    if (myData.length!=0)
  {retStr=0;}

    return retStr;
}

//flag 为1表示不过滤医嘱同一天的其他执行记录
function GetCheckData(flag)
{
	var i,j,tmpStr,retStr,dischOrd,check,objOrdStatDesc;
	var objtbl=document.getElementById('tDHCNurIPExec');
	retStr=t['alert:selOrder']
    var tmpList=new Array();
    var curOrdId,mainOreId=0,mainCheck=false;
    myData=[];
    printCollectData=[];
    var getId=new Array();
    for (i=1;i<objtbl.rows.length;i++)
    {
	    check=document.getElementById('seleitemz'+i);
	    objDisposeStatCode=document.getElementById('disposeStatCodez'+i);
	    if (! objDisposeStatCode) { alert(t['alert:disOrdStat']);return}
	    var disposeStatCode=objDisposeStatCode.innerText;
	    //ypz 070709 begin
        var oeoriId=document.getElementById('oeoriIdz'+i).innerText;
        var curOrdId=oeoriId;
        if (mainOreId==0) {mainOreId=curOrdId;mainCheck=check.checked;}
	    var arcimDesc=document.getElementById("arcimDescz"+i).innerText;
	    var curSeqNo=document.getElementById("tmpSeqNoz"+i).innerText;
        if ((curOrdId!=curSeqNo)&&(queryTypeCode.indexOf("PSD")<0)){
	    	if (mainCheck!=check.checked) return arcimDesc+":主医嘱和关联医嘱选择标志不一致! "+oeoriId
     	}
    	else{mainOreId=curOrdId;mainCheck=check.checked;} 
	    if ((check.checked==true)&&(disposeStatCode!="Discontinue")&&(disposeStatCode!="ExecDiscon")) {
			tmpList=[]
		    tmpStr=document.getElementById('oeoriIdz'+i).innerText;
		    tmpList[tmpList.length]=tmpStr;
		    tmpStr=document.getElementById('tmpPrtFlagz'+i).innerText;
		    tmpList[tmpList.length]=tmpStr;
		    var sttDate=document.getElementById('sttDatez'+i).innerText;
		    var tempIdArray=tmpList[0].split("||");
		    printCollectData[printCollectData.length]=tmpList[0]
	       //多条执行记录过滤同一天的
			if(getId[tempIdArray[0]+"||"+tempIdArray[1]+"||"+sttDate]!=undefined)
			{
			 	if(flag){
				 		continue;
				 }
			}
			getId[tempIdArray[0]+"||"+tempIdArray[1]+"||"+sttDate]=1
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
	var getExecDateTime=document.getElementById("getExecDateTime").value;
	var execDateTimeInd=GetArrayIndex(varList,"execDateTime")
    var getPatInfo=document.getElementById("PatInfo").value;
    for (i=frow;i<=trow;i++)
    {   
	    //var ss=dataList[i][3];
	    var newArcimDescInd=GetArrayIndex(printVarList,"arcimDesc");
	    
	    var ss=dataList[i][newArcimDescInd];
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
                //xlsSheet.cells(wrow,4)=sexValue;
		    }
        }
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
    
    var str=cspRunServerMethod(GetVarType.value,varType,HospitalRowId);
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
    {  
        sheetFirstRow=i*(singtotal+1)
        
        if (myData[i][cols-2]!="停止")
        {   if (oeoriIdStr.length==0){oeoriIdStr=myData[i][oeoriIdInd]}
            else{oeoriIdStr=oeoriIdStr+"^"+myData[i][oeoriIdInd]}
            var pos;

            var PatInfo=document.getElementById("PatInfo").value;
            var str=cspRunServerMethod(PatInfo,myData[i][oeoriIdInd]);
            //alert(str)
            var arr=str.split("^");
            var regno=arr[0];
            var ctloc=arr[1]; var room=arr[2];
            var sex=arr[3];
            var GetOrdSet=document.getElementById("GetOrdSet");
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
        
    var str=cspRunServerMethod(GetVarType.value,varType,HospitalRowId);
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
	    oreSub=tstr[2];
	    var str=cspRunServerMethod(getarcim,Ord,chl,oreSub,queryTypeCode);
	    return str;

}

function PrintClick()
{

 if ((queryTypeCode.indexOf("JYD")>-1)||(queryTypeCode.indexOf("BLD")>-1))
  {   
  
        PrintBar();
        return ;
  }
  myData=[];
  //var objPrintbut=document.getElementById("printbut");
  //if (objPrintbut) objPrintbut.style.display="none";  
  resStr=QueryPrintData("Y",true);
  if (resStr!="0")
  {
    alert(resStr);
    if (objPrintbut) objPrintbut.style.display="block";
    return;
  } 
  ///For HuaXi
    var GetVarType=document.getElementById("GetVarType");
    var str=cspRunServerMethod(GetVarType.value,queryTypeCode,HospitalRowId);
    var tmpList=str.split("^");
    if (tmpList.length>2) {fileName=tmpList[1];typeDesc=tmpList[0];patPrint=tmpList[2];framePrint=tmpList[3]}
    
  if (queryTypeCode.indexOf("JCD")>-1)
  {   
  } 
  if (queryTypeCode.indexOf("JYD")>-1)
  {   
  
        var truthBePrint = window.confirm("是否打印标签?");
        if(truthBePrint){PrintBar();}
        //var truthBePrintSJD = window.confirm("是否打印送检单?");
        //if(truthBePrintSJD){PrintClickExcel();}
        if (objPrintbut) objPrintbut.style.display="block";
        self.location.reload();
        return ;
        
  }
/*if (queryTypeCode.indexOf("SXD")>-1)
  {   
      document.getElementById("printbut").style.display="none";
      PrintBarHX();
      if (objPrintbut) objPrintbut.style.display="block";
      self.location.reload();     
      return ;
  }*/
    var GetVarType=document.getElementById("GetVarType");
    var str=cspRunServerMethod(GetVarType.value,queryTypeCode,HospitalRowId);
    tmpList=str.split("^");
    var oeoriIdStr=""  ;
  
    var warddes="";
    var tmpPrintList=new Array();
    if (myData.length<1)
    {
        alert(t['alert:queryFirst']);
        return false
    }
    //if (fileName.length>2) {PrintExecSheet();return;} // + wxl 090309
    if(tmpList[2]=="N")
    {
          PrintRpByWard(queryTypeCode,"select",tmpList[0])
  
    }else{
          PrintRp(queryTypeCode,"select",tmpList[0]);
    }
}
function PrintClick0422()
{
	//var chkSelPrint=document.getElementById('chkSelPrint').checked;
	myData=[];
	var objPrintbut=document.getElementById("printbut");
    if (objPrintbut) objPrintbut.style.display="none";
	//if (chkSelPrint==true) resStr=GetCheckData(true);
	//else resStr=QueryPrintData("Y",true);
resStr=QueryPrintData("Y",true);
	if (resStr!="0")
	{
		alert(resStr);
		if (objPrintbut) objPrintbut.style.display="block";
		return;
	} 
	///For HuaXi
    var GetVarType=document.getElementById("GetVarType");
   	var str=cspRunServerMethod(GetVarType.value,queryTypeCode,HospitalRowId);
    var tmpList=str.split("^");
   	if (tmpList.length>2) {fileName=tmpList[1];typeDesc=tmpList[0];patPrint=tmpList[2];framePrint=tmpList[3]}
   	
 	if (queryTypeCode.indexOf("JCD")>-1)
	{   
	} 
	if (queryTypeCode.indexOf("JYD")>-1)
	{   
	
	    var truthBePrint = window.confirm("是否打印标签?");
	    if(truthBePrint){PrintBar();}
	    var truthBePrintSJD = window.confirm("是否打印送检单?");
	    if(truthBePrintSJD){PrintClickExcel();}
	    if (objPrintbut) objPrintbut.style.display="block";
    	self.location.reload();
    	return ;
	}
	if (queryTypeCode.indexOf("SXD")>-1)
	{   
	    document.getElementById("printbut").style.display="none";
	    PrintBarHX();
	    if (objPrintbut) objPrintbut.style.display="block";
	    self.location.reload();	    
    	return ;
	}
    var GetVarType=document.getElementById("GetVarType");
   	var str=cspRunServerMethod(GetVarType.value,queryTypeCode,HospitalRowId);
    tmpList=str.split("^");
    var oeoriIdStr=""  ;
	
    var warddes="";
    var tmpPrintList=new Array();
	if (myData.length<1)
	{
		alert(t['alert:queryFirst']);
		return false
	}
	if (fileName.length>2) {PrintExecSheet();return;} // + wxl 090309
	if(tmpList[2]=="N")
	{
		if (queryTypeCode.indexOf("JYD")>-1)
		{   
	    	var truthBePrintSJD = window.confirm("是否打印送检单?");
	    	if(truthBePrintSJD)
	    	{
				if(chkSelPrint==true)
				{
					PrintRpByWard(queryTypeCode,"select",tmpList[0])
				}
				else
				{
					PrintRpByWard(queryTypeCode,"all",tmpList[0])
				}
	    	}
    		return ;
		}
		if(chkSelPrint==true)
		{
			PrintRpByWard(queryTypeCode,"select",tmpList[0])
		}
		else
		{
				PrintRpByWard(queryTypeCode,"all",tmpList[0])
		}
		return;
	}
	if (chkSelPrint==true){
		PrintRp(queryTypeCode,"select",tmpList[0]);
	}else{
		PrintRp(queryTypeCode,"all",tmpList[0]);
		}
	
	
}

function PrintBar() //print lab barcode
{
	//debugger;
    var Bar,i,j;  
    Bar= new ActiveXObject("PrintBar.PrnBar");//TestAx.CLSMAIN
    Bar.PrintName="tiaoma";//printer name
     QueryPrintData("P",true);     
     var gg=new Array();  
    //var chkSelPrint=document.getElementById('chkSelPrint').checked;
    //if (chkSelPrint==true) resStr=GetCheckDataExcel();
   // else resStr=QueryPrintDataExcel();
    //if ((queryTypeCode.indexOf("JYD")<0)) return;
    //var prtFlagInd=varList.length+2  //GetArrayIndex(varList,"prtFlag");
    //var oeoriIdInd=varList.length  //GetArrayIndex(varList,"oeoriId");
    //var labNoInd=GetArrayIndex(varList,"labNo");
    //SortListByCol(myData,labNoInd,true)
    var oeoriIdStr="",printedLabNoStr="^";
    var getArcimShortDesc=document.getElementById("GetArcimShortDesc").value;
    //alert(myData.length);
    for (i=0;i<myData.length;i++)
    {
	    if(gg[i]==true) continue;
	       //var oldi=i;
        //if (myData[i][1]!="Y")
    	   //{
            //var oeoriId=myData[i][oeoriIdInd];
            var oeoriId=myData[i][0];
            var arcdes=GetArcim1(oeoriId);
            var RetStr=arcdes.split("@")
            var orderitem=RetStr[0].split("^");
            var labNo=orderitem[10];  //ypz 061026
            var specDesc=orderitem[13];
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
                        var oeoriId=myData[j][0];
                        var arcdes=GetArcim1(oeoriId);
                        var RetStr=arcdes.split("@")
                        var orderitem=RetStr[0].split("^");
                        var addLabNo=orderitem[10];
                        //var addLabNo=labNo;
                        ////var addCheck=myData[j][seleitemInd];
                        ////var addPrintFlag=myData[j][tmpPrtFlagInd];
                        //var addDisposeStatCode=document.getElementById('disposeStatCodez'+j).innerText;
	    			
                        //if ((addCheck.checked==true)&&(addPrintFlag!="Y")&&(addDisposeStatCode!="UnPaid")&&(addSpecNo==SpecNo))
                        if (addLabNo==labNo)
                        {
	                        gg[j]=true;
                            addOrdName=cspRunServerMethod(getArcimShortDesc,"",oeoriId);//ypz 080717 //orderitem[0];
                            OrdName=OrdName+","+addOrdName
                            oeoriIdStr=oeoriIdStr+"^"+oeoriId
                            oldi=j
                        }
                    }
                    //i=oldi
                    //if (specDescInd>-1) specDesc=myData[i][specDescInd];
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
   // }
   // if ((oeoriIdStr.length>0)&(chkSelPrint==false)){
      //SetPrintFlag(oeoriIdStr)
      SetPrintFlag(oeoriIdStr,"P");
      self.location.reload();
   // }	
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
function SetPrintFlag(oeoriIdStr,printFlag)
{  
    //var queryTypeCode=document.getElementById("vartyp").value;
    var wardId=document.getElementById("wardid").value;
    var userId=session['LOGON.USERID'];
    var SetPrintFlag=document.getElementById("SetPrintFlag").value;
    if (oeoriIdStr!="")
    {
        if (!printedFlag)
        {		
        	
        	if(!printFlag)
        	{
	        	printFlag="Y"
        	}
        
	        resStr=cspRunServerMethod(SetPrintFlag,wardId,userId,queryTypeCode,oeoriIdStr,printFlag);
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
       //if (queryTypeCode.indexOf("JYD")>-1){xlsSheet.cells(actRow,4)="性别";}
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
	actRow=eval(actRow)+1
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
	var objtbl=document.getElementById('tDHCNurIPExec');
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
   	var str=cspRunServerMethod(GetVarType.value,queryTypeCode,HospitalRowId);
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
var objOnlyNewOrd=document.getElementById("onlyNewOrd");
if (objOnlyNewOrd) onlyNewOrd=objOnlyNewOrd.value;
var onlyNewOrdStr="";
//if ((onlyNewOrd)&&(queryTypeCode!="ZCQ")) onlyNewOrdStr=" - "+t['val:onlyNewOrd']; //" - 仅新开医嘱" //

function QueryPrintDataExcel()
{
    //if (ordStatDescInd<0) {return t['alert:disOrdStat'];}
    var gap="",rows=0,printFlag;
    var queryTypeCode=document.getElementById("vartyp").value;
    var userId=session['LOGON.USERID'];
    var GetTmpData=document.getElementById("GetTmpData").value;
    var GetTmpDataNum=document.getElementById("GetTmpDataNum").value;
	myData=[]; //ypz 070327
	var retStr=t['alert:noPrintData'];
	var TmpNum=cspRunServerMethod(GetTmpDataNum,userId);
	for (var i=1;i<=TmpNum;i++)
	{
		    var itemData=cspRunServerMethod(GetTmpData,userId,i);
			tmpList=(itemData).split("!");
							alert(itemData)
			if ((tmpList[disposeStatInd]!="Discontinue")&&(tmpList[disposeStatInd]!="ExecDiscon")){
				printFlag=tmpList[oeoriIdInd+3]

				if (printFlag.indexOf("Y")<0) {
			    	retStr=0;
		       		rows=rows+1;
			   		myData[rows-1]=tmpList;
				}

			}
	}
	return retStr;
}
function GetCheckDataExcel()
{
    var i,j,tmpStr,retStr,dischOrd,check,objOrdStatDesc;
	var objtbl=document.getElementById('tDHCNurIPExec');
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
		    tmpStr=document.getElementById('tmpSeqNoz'+i).innerText;
		    tmpList[tmpList.length]=tmpStr;
		    
		    myData[myData.length]=tmpList;
		    retStr=0;
	    }
    }
    return retStr;
}

function PrintClickExcel()
{
 	//var startDate=parent.frames["NurseTop"].document.getElementById("StartDate").value; 
	//var endDate=parent.frames["NurseTop"].document.getElementById("EndDate").value;
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
    	//if (resStr!=0) {alert(resStr);return;}
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
   	var str=cspRunServerMethod(GetVarType.value,queryTypeCode,HospitalRowId);
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
	   	maxFrameCols=16
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
    var hospitalName=document.getElementById("hospitalName").value;
    xlsSheet.cells(1,1)=hospitalName+"  "+typeDesc+onlyNewOrdStr  //ypz 070319
    xlcenter(xlsSheet,1,1,maxFrameCols)
    mergcell(xlsSheet,1,1,maxFrameCols)
    FontStyle(xlsSheet,1,1,6,14)
    LeftHeader =""; 
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
function PrintBarHX()
{
    var Bar,i,j
    //Bar= new ActiveXObject("RePrint.clsRePrint");
    var chkSelPrint=document.getElementById('chkSelPrint').checked;
    if ((queryTypeCode.indexOf("JYD")<0)&(queryTypeCode.indexOf("SXD")<0)) return;
    var oeoriIdStr="",PrePatName=""
    var endIfFlag=0
    for (i=0;i<myData.length;i++)
    {
     if ((myData[i][1]!="Y")||(chkSelPrint==true))
	   {
		   var oeoriId=myData[i][0];
		   var PatInfo=document.getElementById("PatInfo").value;
		   var str=cspRunServerMethod(PatInfo,oeoriId);
		   var Pat=str.split("^");
		   if ((PrePatName!=Pat[4])&&(PrePatName!==""))
		   {
					GetLabInfoInsert(PrePatName,oeoriIdStr,Bar)
			    oeoriIdStr=oeoriId,PrePatName=Pat[4]
		   }
		   else
		   {
			   var PrePatName=Pat[4]
			   if (oeoriIdStr.length==0){oeoriIdStr=oeoriId}
			   else{oeoriIdStr=oeoriIdStr+"^"+oeoriId}
		   }
	   }
    }
    if((PrePatName!="")&&(oeoriIdStr!=""))
    {GetLabInfoInsert(PrePatName,oeoriIdStr,Bar);}
    else alert("补打请选择检验项目!")
	//Bar=null
}
function GetLabInfoInsert(PrePatName,oeoriIdStr,Bar)
{
	var Bar= new ActiveXObject("RePrint.clsRePrint");
	var chkSelPrint=document.getElementById('chkSelPrint').checked;
	var GetLabInterFaceData=document.getElementById('GetLabInterFaceData').value;
	var myRetLisInfo=cspRunServerMethod(GetLabInterFaceData,"DHCNurBarCodePrint",oeoriIdStr);
	//myRetLisInfo=myRetLisInfo.split("<BarCode>")[1].split("</BarCode>")[0]
	if(myRetLisInfo!="") var myRetLisAmount=cspRunServerMethod(GetLabInterFaceData,"DHCNurGetAmountOfTube",oeoriIdStr);
	else var myRetLisAmoun=""
	if((myRetLisInfo=="")||(myRetLisAmount==""))
	{
		alert(PrePatName+" LIS数据返回失败!")
	}
	else
	{
		if(chkSelPrint==true)
		{
			var lisInfo=myRetLisInfo.split("<BarCode>")
			for(var i=1;i<lisInfo.length;i++)
			{
				var lisStr=lisInfo[i].split("</BarCode>")[0]
				lisStr=lisStr.replace("拟:","")
				Bar.funcBarCode("",lisStr,1)
				if (queryTypeCode.indexOf("SXD")>-1) Bar.funcBarCode("",lisStr,1)
			}
		}
		else
		{
			var LabInsertOrdItem=document.getElementById('LabInsertOrdItem').value;
			var userId=session['LOGON.USERID'];
			var userDeptId=session['LOGON.CTLOCID'];
			var qty=myRetLisAmount.split("<Amount>")[1].split("</Amount>")[0]
			if(qty<1)
			{
				var truthBePrint = window.confirm("试管数量不合法,是否打印标签?");
				if(truthBePrint)
				{
					var lisInfo=myRetLisInfo.split("<BarCode>")
					for(var i=1;i<lisInfo.length;i++)
					{
						var lisStr=lisInfo[i].split("</BarCode>")[0]
						lisStr=lisStr.replace("拟:","")
						Bar.funcBarCode("",lisStr,1)
						if (queryTypeCode.indexOf("SXD")>-1) Bar.funcBarCode("",lisStr,1)
					}
					SetPrintFlag(oeoriIdStr)
				}
				esle
				{
					Bar=null
					return;
				}
			}else{
					var ordType="Cont"
					var myRetLab=cspRunServerMethod(LabInsertOrdItem,userId,userDeptId,oeoriIdStr,qty,ordType);
					if(myRetLab=="0")
					{
						var lisInfo=myRetLisInfo.split("<BarCode>")
						for(var i=1;i<lisInfo.length;i++)
						{
							var lisStr=lisInfo[i].split("</BarCode>")[0]
							lisStr=lisStr.replace("拟:","")
							Bar.funcBarCode("",lisStr,1)
							if (queryTypeCode.indexOf("SXD")>-1) Bar.funcBarCode("",lisStr,1)
						}
						SetPrintFlag(oeoriIdStr)
					}
					else
					{
						alert(PrePatName+" "+myRetLab+" 采血管医嘱插入失败!")
					}
			}
		}
	}
	Bar=null
}
function PrintExcelCQ(tmpList)
{
		var typeDesc=tmpList[0];fileName=tmpList[1];patPrint=tmpList[2];framePrint=tmpList[3]
    var chkSelPrint=document.getElementById('chkSelPrint').checked;
		if (chkSelPrint==true)
    var xlsExcel,xlsSheet,xlsBook;
    var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
    var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
    var strList,tmpList,tmpStr,i,j,k,xlsTop,xlsLeft,typeInd,typeDesc;
    var path,fileName,fso,frameMark,labCount=0;
   	path = GetFilePath();
    fileName=path+fileName
		var PrePatName="",PrePatBed="",PrePatRegNo="",PrePatPacWard="",oeoriIdStr="",oeoriIdPrintStr="";
    xlsExcel = new ActiveXObject("Excel.Application");
    xlsBook = xlsExcel.Workbooks.Add(fileName)
    xlsSheet = xlsBook.ActiveSheet;
		if (myData.length<1) {alert(t['alert:queryFirst']);EnableQuery();return false}
		EnableQuery();
    var PrintNum=0;
    for (i=0;i<myData.length;i++)
    {
	    if ((myData[i][1]!="Y")||(chkSelPrint==true))
	    {
		   var oeoriId=myData[i][0];
		   var PatInfo=document.getElementById("PatInfo").value;
		   var str=cspRunServerMethod(PatInfo,oeoriId);
		   var Pat=str.split("^");
		   if ((PrePatName!=Pat[4])||(PrePatName==""))
		   {
			   if ((PrePatName!=Pat[4])&&(PrePatName!==""))
			   {
						CQTitle(xlsSheet,typeDesc,PrePatName,PrePatBed,PrePatRegNo,PrePatPacWard);
				    var PrintNum=0
				    var PrintNum=0;
				    xlsSheet = null;
				    //xlsBook.Delete;
				    if(oeoriIdPrintStr.length==0) oeoriIdPrintStr=oeoriIdStr
				    else oeoriIdPrintStr=oeoriIdPrintStr+"^"+oeoriIdStr
				    //xlsBook= xlsExcel.Workbooks.Add(fileName)
				    xlsSheet = xlsBook.ActiveSheet;
						var PrePatName=Pat[4]
						var PrePatBed=Pat[6]
						var PrePatRegNo=Pat[0]
						var PrePatPacWard=Pat[8]
						oeoriIdStr=oeoriId
						var PrintNum=PrintNum+1
						var newFlage=CQAddExecData(xlsSheet,oeoriId,PrintNum,Pat,typeDesc);
						if(newFlage=="1") var PrintNum=1
			   }
			   else
			   {
						var PrePatName=Pat[4]
						var PrePatBed=Pat[6]
						var PrePatRegNo=Pat[0]
						var PrePatPacWard=Pat[8]
						if (oeoriIdStr.length==0){oeoriIdStr=oeoriId}
						else{oeoriIdStr=oeoriIdStr+"^"+oeoriId}
						var PrintNum=PrintNum+1
						var newFlage=CQAddExecData(xlsSheet,oeoriId,PrintNum,Pat,typeDesc);
						if(newFlage=="1") var PrintNum=1
			   }
		   }
		   else
		   {
					if (oeoriIdStr.length==0){oeoriIdStr=oeoriId}
					else{oeoriIdStr=oeoriIdStr+"^"+oeoriId}
					var PrintNum=PrintNum+1
					var newFlage=CQAddExecData(xlsSheet,oeoriId,PrintNum,Pat,typeDesc);
					if(newFlage=="1") var PrintNum=1
		   }		   
		 }
		 }
	CQTitle(xlsSheet,typeDesc,PrePatName,PrePatBed,PrePatRegNo,PrePatPacWard);
	if(oeoriIdPrintStr.length==0) oeoriIdPrintStr=oeoriIdStr
	else oeoriIdPrintStr=oeoriIdPrintStr+"^"+oeoriIdStr	
	if((chkSelPrint!=true)&(oeoriIdPrintStr.length!=0)) SetPrintFlag(oeoriIdPrintStr);
	xlsSheet = null;
	var PrintNum=0
	xlsBook.Close(savechanges=false);
	xlsBook = null;
	xlsExcel.Visible = false;
	xlsExcel.Quit();
} 
function CQTitle(xlsSheet,typeDesc,PrePatName,PrePatBed,PrePatRegNo,PrePatPacWard)
{
	var titleRows=0, titleCols=0;
	typeDesc=typeDesc.split("(")[0]
	var hospitalName=document.getElementById("hospitalName").value;
	var now = new Date();
	var PrintDate = now.getYear()+"年";
	xlsSheet.cells(2,1)=PrintDate
	var CenterHeader="&18"+hospitalName+"\r&14"+typeDesc
	var LeftHeader ="",RightHeader = "" ,LeftFooter ="",CenterFooter = "",RightFooter = "";
	LeftFooter = "病区:"+PrePatPacWard+" 床号:"+PrePatBed+" 姓名:"+PrePatName+" 住院号:"+PrePatRegNo;
	ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter) 
	//xlsSheet.printout
	xlsSheet.PrintOut(1,1,1,false,"ZHIXINGDAN",false,false)
	//xlsSheet.PrintOut("ZHIXINGDAN")
	xlsSheet.Range("A4:C30").Value=""
	for(var i=1;i<15;i++)
	{
		xlsSheet.Range(xlsSheet.Cells(i*2+2, 1), xlsSheet.Cells(i*2+2,6)).Borders(3).LineStyle=1;
		xlsSheet.Range(xlsSheet.Cells(i*2+1, 1), xlsSheet.Cells(i*2+1,6)).Borders(4).LineStyle=1;	
	}
}
function CQAddExecData(xlsSheet,oeoriId,PrintNum,Pat,typeDesc)
{
	var obGetOrdInfo=document.getElementById("GetOrdInfo")
	var retNewFlag=0
	if(obGetOrdInfo)
	{
		var getOrdInfo=obGetOrdInfo.value;
		var str=cspRunServerMethod(getOrdInfo,oeoriId);
		var ordInfo=str.split("^");
		var ordDate=ordInfo[0]
		var ordTime=ordInfo[1]
		var arcimDesc=ordInfo[2]
	} 
	else
	{
		var ordDate=""
		var ordTime=""
		var arcimDesc=""
	}
	if(PrintNum>14)
	{
		var PrePatName=Pat[4]
		var PrePatBed=Pat[6]
		var PrePatRegNo=Pat[0]
		var PrePatPacWard=Pat[8]
		CQTitle(xlsSheet,typeDesc,PrePatName,PrePatBed,PrePatRegNo,PrePatPacWard);
		PrintNum=1
		var retNewFlag=1
	}
	xlsSheet.cells(PrintNum*2+2,1)=ordDate
	xlsSheet.cells(PrintNum*2+2,2)=ordTime
	xlsSheet.cells(PrintNum*2+2,3)=arcimDesc
	xlsSheet.Range(xlsSheet.Cells(PrintNum*2+2, 1), xlsSheet.Cells(PrintNum*2+2,6)).Borders(3).LineStyle=1;
	xlsSheet.Range(xlsSheet.Cells(PrintNum*2+1, 1), xlsSheet.Cells(PrintNum*2+1,6)).Borders(4).LineStyle=1;
	if((arcimDesc.indexOf("__")>-1)&&(retNewFlag!=1))
	{
		xlsSheet.cells(PrintNum*2+2,1)=""
		xlsSheet.cells(PrintNum*2+2,2)=""
		xlsSheet.Range(xlsSheet.Cells(PrintNum*2+2, 1), xlsSheet.Cells(PrintNum*2+2,6)).Borders(3).LineStyle=-4142;
		xlsSheet.Range(xlsSheet.Cells(PrintNum*2+1, 1), xlsSheet.Cells(PrintNum*2+1,6)).Borders(4).LineStyle=-4142;
	}
	return retNewFlag
}
function PrintExcelLS(tmpList)
{
		var typeDesc=tmpList[0];fileName=tmpList[1];patPrint=tmpList[2];framePrint=tmpList[3]
    var chkSelPrint=document.getElementById('chkSelPrint').checked;
		if (chkSelPrint==true)
    var xlsExcel,xlsSheet,xlsBook;
    var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
    var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
    var strList,tmpList,tmpStr,i,j,k,xlsTop,xlsLeft,typeInd,typeDesc;
    var path,fileName,fso,frameMark,labCount=0;
   	path = GetFilePath();
    fileName=path+fileName
		var PrePatName="",PrePatBed="",PrePatRegNo="",PrePatPacWard="",oeoriIdStr="",oeoriIdPrintStr="";
    xlsExcel = new ActiveXObject("Excel.Application");
    xlsBook = xlsExcel.Workbooks.Add(fileName)
    xlsSheet = xlsBook.ActiveSheet;
		if (myData.length<1) {alert(t['alert:queryFirst']);EnableQuery();return false}
		EnableQuery();
    var PrintNum=0;
    for (i=0;i<myData.length;i++)
    {
	    if ((myData[i][1]!="Y")||(chkSelPrint==true))
	    {
		   var oeoriId=myData[i][0];
		   var PatInfo=document.getElementById("PatInfo").value;
		   var str=cspRunServerMethod(PatInfo,oeoriId);
		   var Pat=str.split("^");
		   if ((PrePatName!=Pat[4])||(PrePatName==""))
		   {
			   if ((PrePatName!=Pat[4])&&(PrePatName!==""))
			   {
					LSTitle(xlsSheet,Pat,typeDesc,PrePatName,PrePatBed,PrePatRegNo,PrePatPacWard);
				    var PrintNum=0
				    var PrintNum=0;
				    xlsSheet = null;
				    //xlsBook.Delete;
				    if(oeoriIdPrintStr.length==0) oeoriIdPrintStr=oeoriIdStr
				    else oeoriIdPrintStr=oeoriIdPrintStr+"^"+oeoriIdStr
				    //xlsBook= xlsExcel.Workbooks.Add(fileName)
				    xlsSheet = xlsBook.ActiveSheet;
						var PrePatName=Pat[4]
						var PrePatBed=Pat[6]
						var PrePatRegNo=Pat[0]
						var PrePatPacWard=Pat[8]
						oeoriIdStr=oeoriId
						var PrintNum=PrintNum+1
					var newFlage=LSAddExecData(xlsSheet,oeoriId,PrintNum,Pat,typeDesc);
					if(newFlage=="1") var PrintNum=1
			   }
			   else
			   {
					var PrePatName=Pat[4]
					var PrePatBed=Pat[6]
					var PrePatRegNo=Pat[0]
					var PrePatPacWard=Pat[8]
					if (oeoriIdStr.length==0){oeoriIdStr=oeoriId}
					else{oeoriIdStr=oeoriIdStr+"^"+oeoriId}
					var PrintNum=PrintNum+1
					var newFlage=LSAddExecData(xlsSheet,oeoriId,PrintNum,Pat,typeDesc);
					if(newFlage=="1") var PrintNum=1
			   }
		   }
		   else
		   {
					if (oeoriIdStr.length==0){oeoriIdStr=oeoriId}
					else{oeoriIdStr=oeoriIdStr+"^"+oeoriId}
					var PrintNum=PrintNum+1
					var newFlage=LSAddExecData(xlsSheet,oeoriId,PrintNum,Pat,typeDesc);
					if(newFlage=="1") var PrintNum=1
		   }
		   
		 }
		 }
	if(oeoriIdPrintStr.length==0) oeoriIdPrintStr=oeoriIdStr
	else oeoriIdPrintStr=oeoriIdPrintStr+"^"+oeoriIdStr
	if((chkSelPrint!=true)&(oeoriIdPrintStr.length!=0)) SetPrintFlag(oeoriIdPrintStr);
	LSTitle(xlsSheet,typeDesc,PrePatName,PrePatBed,PrePatRegNo,PrePatPacWard);
	xlsSheet = null;
	var PrintNum=0
	xlsBook.Close(savechanges=false);
	xlsBook = null;
	xlsExcel.Visible =false
	xlsExcel.Quit();
}
function LSTitle(xlsSheet,typeDesc,PrePatName,PrePatBed,PrePatRegNo,PrePatPacWard)
{

	var titleRows=0, titleCols=0;
	typeDesc=typeDesc.split("(")[0]
	var hospitalName=document.getElementById("hospitalName").value;
	var now = new Date();
	var PrintDate = now.getYear()+"年";
	xlsSheet.cells(1,1)=PrintDate
	var CenterHeader="&18"+hospitalName+"\r&14"+typeDesc
	var LeftHeader ="",RightHeader = "" ,LeftFooter ="",CenterFooter = "",RightFooter = "";
	LeftFooter = "病区:"+PrePatPacWard+" 床号:"+PrePatBed+" 姓名:"+PrePatName+" 住院号:"+PrePatRegNo;
	ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter) 
	//xlsSheet.printout
	xlsSheet.PrintOut(1,1,1,false,"ZHIXINGDAN",false,false)
	xlsSheet.Range("A3:C31").Value=""
}
function LSAddExecData(xlsSheet,oeoriId,PrintNum,Pat,typeDesc)
{
	var obGetOrdInfo=document.getElementById("GetOrdInfo")
	if(obGetOrdInfo)
	{
		var getOrdInfo=obGetOrdInfo.value;
		var str=cspRunServerMethod(getOrdInfo,oeoriId);
		var ordInfo=str.split("^");
		var ordDate=ordInfo[0]
		var ordTime=ordInfo[1]
		var arcimDesc=ordInfo[2]
	} 
	else
	{
		var ordDate=""
		var ordTime=""
		var arcimDesc=""
	}
	if(PrintNum>29)
	{
		var PrePatName=Pat[4]
		var PrePatBed=Pat[6]
		var PrePatRegNo=Pat[0]
		var PrePatPacWard=Pat[8]
		LSTitle(xlsSheet,typeDesc,PrePatName,PrePatBed,PrePatRegNo,PrePatPacWard);
		PrintNum=1
		var retNewFlag=1
	}
	xlsSheet.cells(PrintNum+2,1)=ordDate
	xlsSheet.cells(PrintNum+2,2)=ordTime
	xlsSheet.cells(PrintNum+2,3)=arcimDesc
	return retNewFlag
}
function SortListByTwoCol(list,col1,col2,ascendBool1,ascendBool2)  // + wxl 090312
{   //sort list by number col,ascendBool:ascend or descend order
	var tmpList=[],i,j;
	for (i=0;i<list.length-1;i++)
	{
	    for (j=i+1;j<list.length;j++)
	    {
		    if ((list[i][col1]>list[j][col1])==ascendBool1)
		    {
		    	var tmpList=list[i];list[i]=list[j];list[j]=tmpList;
		    }
		    if (list[i][col1]==list[j][col1])
		    {
		    	if ((list[i][col2]>list[j][col2])==ascendBool2)
		    	{
		    	var tmpList=list[i];list[i]=list[j];list[j]=tmpList;
		    	}

		    }		     
	    }
	}
}
function PrintbarClick()
{
	if ((queryTypeCode.indexOf("JYD")<0)) return;
	PrintBar()
	return ;  
}
