var myData=new Array();
var myColumns=new Array();
var queryTypeCode=document.getElementById("queryTypeCode").value;
var hospitalName=document.getElementById("hospitalName").value;
var HospitalRowId=document.getElementById("HospitalRowId").value;
var ifPrintSheet=GetElement("ifPrintSheet","Y");
var ifPrintBar=GetElement("ifPrintBar","Y");
var ifPrintTransfusionCard=GetElement("ifPrintTransfusionCard","Y");
var ifPrintLabNote=GetElement("ifPrintLabNote","Y");
var ifPrintSeatNo=GetElement("ifPrintSeatNo","Y");
var ifRecPrint=GetElement("ifRecPrint","pY");
var ifPrintLocal=GetElement("ifPrintLocal","N");
var offLineRecLoc="^"+GetElement("offLineRecLoc","")+"^"
//alert(offLineRecLoc)

var debug=false;

if (queryTypeCode!="")
    {
    var GetTitle=document.getElementById("GetTitle").value;
    var titleStr=cspRunServerMethod(GetTitle,queryTypeCode,HospitalRowId);
    if (titleStr.length==0) {alert(t['val:setVar']);}
    var titleList=titleStr.split("^")
    var	myColumns=titleList[1].split("!")
	var varList=titleList[2].split("!")
	var getPrintTitle=document.getElementById("getPrintTitle").value;
    var printTitleStr=cspRunServerMethod(getPrintTitle,HospitalRowId+"@"+queryTypeCode);
    if (printTitleStr.length==0) {alert(t['val:setVar']);}
    var printTitleList=printTitleStr.split("^")
    var printDescList=printTitleList[0].split("|")
    var	printLenList=printTitleList[1].split("|")
	var printVarList=printTitleList[2].split("|")

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
	var reclocDescInd=GetArrayIndex(varList,"reclocDesc");
	var updateDateTimeInd=GetArrayIndex(varList,"updateDateTime");
}
function GetTitleNameByCode(titleDesc)
{
	var titleDescInd=GetArrayIndex(varList,titleDesc);
	return myColumns[titleDescInd]
}
function QueryPrintData()
{	return 0
}
function GetCheckData()
{
    var i,j,tmpStr,retStr,dischOrd,check,objOrdStatDesc;
	var objtbl=document.getElementById('tDHCNurOPExec');
	retStr=t['alert:selOrder']
    var tmpList=new Array();
    for (i=1;i<objtbl.rows.length;i++)
    {
	    var reclocDesc="";
	    var obj=document.getElementById('reclocDescz'+i);
	    if (obj) reclocDesc=obj.innerText;
	    if ((queryTypeCode.indexOf("JYDO")>-1)&&(offLineRecLoc.indexOf("^"+reclocDesc+"^")==-1)) continue;
	    check=document.getElementById('seleitemz'+i);
	    objDisposeStatCode=document.getElementById('disposeStatCodez'+i);
	    if (! objDisposeStatCode) { alert(t['alert:disOrdStat']);return}
	    var disposeStatCode=objDisposeStatCode.innerText;
		//if (check.checked==true) {
	    if ((check.checked==true)&&(disposeStatCode!="Discontinue")&&(disposeStatCode!="ExecDiscon")) {
            var PrintFlag=document.getElementById('tmpPrtFlagz'+i).innerText;
            var oeoriId=document.getElementById('oeoriIdz'+i).innerText;
            //---------------
            var GetPrintdata=document.getElementById("GetPrintdata").value;  //new add
            var Printdata=cspRunServerMethod(GetPrintdata,oeoriId);
            if (Printdata!="")
            {
	            PrintdataList=Printdata.split("^")
	              for (g=0;g<PrintdataList.length;g++)
	        {
		        arrylist=PrintdataList[g].split("|");
		        if (arrylist[0]=="execCtcpDesc") UserList_execCtcpDesc=arrylist[1];
		        if (arrylist[0]=="execDateTime") UserList_execDateTime=arrylist[1];
		        }
	            }
	         else
	         {
		        UserList_execCtcpDesc=undefined;
	            UserList_execDateTime=undefined;
		         
		         }
		     
	      
		        
            //-------------------
		    if (debug) alert(oeoriId);
			tmpList=[]
	    	for (j=0;j<varList.length;j++)
	    	{   var obj=document.getElementById(varList[j]+'z'+i);
	    	  	tmpStr="";
	    	   	if (obj) {if (varList[j]!="placerNo") tmpStr=obj.innerText; else  tmpStr=obj.value}
	            if (varList[j]=="updateDateTime"){
	             	var tmpDateTime=tmpStr.split(" ");
		 			if (tmpDateTime.length>1){tmpStr=tmpDateTime[0];}
		 		}
		 		
	            tmpList[j]=tmpStr;
	            //-------------
	            if ((varList[j]=="execCtcpDesc")&&(UserList_execCtcpDesc!=undefined)) tmpList[j]=UserList_execCtcpDesc;
	            if ((varList[j]=="execDateTime")&&(UserList_execDateTime!=undefined)) tmpList[j]=UserList_execDateTime;
	            
	            //--------------------------
		    }
		    tmpStr=document.getElementById('oeoriIdz'+i).innerText;
		    tmpList[tmpList.length]=tmpStr;
		    tmpStr=document.getElementById('placerCodez'+i).innerText;
		    tmpList[tmpList.length]=tmpStr;
		    tmpStr=document.getElementById('disposeStatCodez'+i).innerText;
		    tmpList[tmpList.length]=tmpStr;
		    tmpStr=document.getElementById('tmpPrtFlagz'+i).innerText;
		    tmpList[tmpList.length]=tmpStr;
		    if (arcimDescInd>-1){
			    //if (((queryTypeCode=="ZCQ")&&(tmpStr.indexOf("M")>-1))||((queryTypeCode!="ZCQ")&&(tmpStr.indexOf("Y")>-1))){
				//	tmpList[arcimDescInd]=tmpList[arcimDescInd]+"[重打]"
			    //}
		    }
		    myData[myData.length]=tmpList;
		    retStr=0;
	    }
    }
    return retStr;
}

function GetFilePath()
{
	if (ifPrintLocal=="Y") var path="c:\\moban\\"
	else {
		var GetPath=document.getElementById("GetPath").value;
    	var path=cspRunServerMethod(GetPath);
	}
    return path
}
function GetPrintDateTime(adjSecond,delimiter,isAll) 
{ 	var queryTypeCode=document.getElementById("queryTypeCode").value;
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
	if (arcimDescInd<0) return;

    for (i=frow;i<=trow;i++)
    {   
	    var newArcimDescInd=GetArrayIndex(printVarList,"arcimDesc");
	    var arcimDesc=dataList[i][newArcimDescInd];//var arcimDesc=dataList[i][arcimDescInd];
	    var arcimDescList=arcimDesc.split("____");
	    OrderName=arcimDesc;

        var pres=(wrow)%PRow;
        var timeStr="";
        var PrintDateTime=GetPrintDateTime(0,"-",false);//PrintDateTime=DateDemo(); ypz 060928
	    for (j=fcol;j<=tcol;j++)  //'ubound(strList)
        { 
            if ((arcimDescList[0]=="")&&(j<6))
	        {
                xlsSheet.cells(wrow,xlsLeft+j-fcol)=dataList[i][j];
	        }
	        if (arcimDescList[0]!="")
	        {
                xlsSheet.cells(wrow,xlsLeft+j-fcol)=dataList[i][j];
		    }
        }
        if (arcimDescList[0]!="")
        {
            //if (execDateTimeInd>2) xlsSheet.cells(wrow,execDateTimeInd-2)=timeStr;
        }
        //if (dataList[i][arcimDescInd]=="") xlsSheet.Rows(wrow+":"+wrow).RowHeight = 1
        //if (dataList[i][arcimDescInd]=="") xlsSheet.Rows(wrow+":"+wrow).RowHeight = 14   //2007-04-01 cjb change the print blank height of row
        wrow=wrow+1;
    }
	return (wrow-1)+"^"+p 
}
function GetDate(dateStr)
{
	var tmpList=dateStr.split("/")
	if (tmpList.length<3) return 0;
	return ((tmpList[2]*1000)+(tmpList[1]*50)+tmpList[0]*1)
}
function PrintExecSheet()
{
 	var startDate=parent.frames["NurseTop"].document.getElementById("StartDate").value; 
	var endDate=parent.frames["NurseTop"].document.getElementById("EndDate").value;
    //if (GetDate(startDate)!=GetDate(endDate)) {alert(t['alert:sameStartEndDate']);return;};
    var chkSelPrint=true; //document.getElementById('chkSelPrint').checked;
    var printList=[],patPrint,framePrint,actRow=1,resStr,labNoStr="^";
    var printNullLine=0;
	myData=[];
	if (chkSelPrint==true) resStr=GetCheckData();
	else resStr=QueryPrintData();
	if ((resStr!="0")&&(queryTypeCode.indexOf("JYDO")==-1)){alert(resStr); return;}  //can't print!
    if (resStr!="0") return;
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
   	if (fileName.length<2) {/*alert(t['alert:noExcelFile']);*/return false}
    fileName=path+fileName
   	var PrintDateTime=GetPrintDateTime(0,"-",false);  //ypz 060928
  	cols=oeoriIdInd;

	//alert(myData);//return;
	chkSelPrint=false;
    xlsExcel = new ActiveXObject("Excel.Application");
    xlsBook = xlsExcel.Workbooks.Add(fileName) //;Open(fileName)
    xlsSheet = xlsBook.ActiveSheet; //Worksheets(1)
    xlsTop=1;xlsLeft=1;
    titleRows=0, titleCols=0;
    xlsSheet.cells(1,1)=hospitalName+"  "+typeDesc  //ypz 070319
    var oeoriIdStr="",preFrameMark=0,maxFrameCols=cols-3;
    xlcenter(xlsSheet,1,1,maxFrameCols)
    mergcell(xlsSheet,1,1,printDescList.length)
    FontStyle(xlsSheet,1,1,6,14)
    LeftHeader =""; //'Chr(13) &""
    RightHeader = "" ;LeftFooter ="";CenterFooter = "";RightFooter = "";
    ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter) 

    
    ////alert("len="+oeoriIdStr.length)
    //if (queryTypeCode=="ZCQ")	maxFrameCols=maxFrameCols+7;

    var titleDesc="";
    var tmpPrintList=new Array();
    //xlsExcel.Visible = true;
	if (queryTypeCode.indexOf("JYDO")>-1) //ypz 061116
	{  	var sortCol=GetArrayIndex(varList,"reclocDesc");
		//var sortCol=GetArrayIndex(varList,"labNO");
	   	SortListByCol(myData,sortCol,true)
	}
	if (debug) alert(myData)
	if (myData.length<1) {alert(t['alert:queryFirst']);return false}
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
	            //if (debug) alert(myData[i][oeoriIdInd]+"/b/"+frameMark+"/"+preFrameMark)
				frameMark=GetFrameMark(queryTypeCode,myData[i],oeoriIdInd); //frame
                if (preFrameMark==0){preFrameMark=frameMark}
               		
               	if (tmpArcimList.length<2){ //start of a group
					//frist insert null into pregroup
               	    if (oeoriIdStr!=myData[i][oeoriIdInd]){  //for pre null line
  	        			if (phcfrFactor<=ordGruopCount) phcfrFactor=ordGruopCount+1;
  	        			
  	        			if (printNullLine==1){
	  	        			for (k=0;k<phcfrFactor-ordGruopCount;k++){
	               	    		var nullList=[];
   			    	       		for (j=0;j<varList.length;j++){nullList[j]=""}
	               	    		printList[printList.length]=nullList;
	  	        			}
        				}
               		}
               		//end of pre null line insert,begin cur line
              		phcfrFactor=0;
	        		//if need end frame
	                if (preFrameMark==frameMark){ //confirm frame:oeordId or recloc
		            	//if (queryTypeCode=="JYDO") labNoStr=GetLabCount(queryTypeCode,labNoStr,myData[i][labNoInd]);
	    	        } //end of one frame confirm frame:oeordId or recloc
	        	    else{ //start a new frame,another pat or recloc
		        	   // if (i<myData.length-1){
		            	mergcell(xlsSheet,actRow+1,1,printDescList.length);
		            	//alert("1: "+printList);
			          	actRow=SetFrameData(queryTypeCode,printList,actRow,xlsSheet,xlsLeft,xlsTop,typeDesc,labNoStr,maxFrameCols,framePrint); //ypz 061128
			          	//xlsExcel.Visible = true;
	                    //xlsSheet.PrintPreview ;
	                    if (queryTypeCode.indexOf("JYDO")>-1){
	                    	xlsSheet.printout;
							ClearXls(xlsSheet,2,1,actRow,printDescList.length)
			          		actRow=1
	                    }
		            	printList=[];
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
  	        		if (printNullLine==1){
  	        			for (k=0;k<phcfrFactor-ordGruopCount;k++){
	               	   		var nullList=[];
   			    	   		for (j=0;j<varList.length;j++){nullList[j]=""}
	               	   		printList[printList.length]=nullList;
  	        			}
        			}
			        mergcell(xlsSheet,actRow+1,1,printDescList.length);
			        //alert("2: "+printList)
		            actRow=SetFrameData(queryTypeCode,printList,actRow,xlsSheet,xlsLeft,xlsTop,typeDesc,labNoStr,maxFrameCols,framePrint);
		        }
            }//end of frame print(pat,recloc)
        }//unuse current
    } //end of myData[i]
    if (debug) alert("last:  colmns:"+myColumns)
    if (oeoriIdStr.length>0){
         SetPrintFlag(oeoriIdStr);
    }
    xlsSheet.printout
	//xlsExcel.Visible = true;
	//xlsSheet.PrintPreview ;
    xlsSheet = null;
    xlsBook.Close(savechanges=false);
    xlsBook = null;
    xlsExcel.Quit();
    xlsExcel = null;
    
    //catch(e)
    //{
	//    alert(e.toString());
	//    xlsExcel.Quit();
	//}
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
    //var queryTypeCode=document.getElementById("queryTypeCode").value;
    var wardId=document.getElementById("wardid").value;
    var userId=session['LOGON.USERID'];
    var SetPrintFlag=document.getElementById("SetPrintFlag").value;
    //alert(wardId+" "+userId+" "+queryTypeCode);
    if (oeoriIdStr!="")
    {
        if (ifRecPrint=="Y"){
	        /// alert(oeoriIdStr);
	        resStr=cspRunServerMethod(SetPrintFlag,userId,queryTypeCode,oeoriIdStr);
            PrintDateTime=resStr;
        }
    }
}
function SetTPQPrintFlag(oeoriIdStr)
{  
    //var queryTypeCode=document.getElementById("queryTypeCode").value;
    var wardId=document.getElementById("wardid").value;
    var userId=session['LOGON.USERID'];
    var SetPrintFlag=document.getElementById("SetPrintFlag").value;
    //alert(wardId+" "+userId+" "+queryTypeCode);
    if (oeoriIdStr!="")
    {
        if (ifRecPrint=="Y"){
	        /// alert(oeoriIdStr);
	        resStr=cspRunServerMethod(SetPrintFlag,userId,queryTypeCode,oeoriIdStr,"M");
            PrintDateTime=resStr;
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
function setFrameTitle(xlsSheet,titleDesc,dateTimeStr,type,Row,printList,queryTypeCode,labCount)
{
    FontStyle(xlsSheet,Row,1,5,10);//12
    xlsSheet.cells(Row,1)=titleDesc+"    "+dateTimeStr;
    return Row+1
}
function SortListByCol(list,col,ascendBool)
{   //sort list by col,ascendBool:ascend order
	var tmpList=[],i,j;
	for (i=list.length-1;i>0;i--)
	{
	    for (j=0;j<i;j++)
	    {
		    if ((list[j][col]>list[j+1][col])==ascendBool)
		    {
		    	var tmpList=list[j+1];list[j+1]=list[j];list[j]=tmpList;
		    }		     
	    }
	}
}
function AddNullListByCol(list,col)
{   //对col列不同的行之间,加入空行
	var tmpList=[],i,j;
	if (list.length<1) return tmpList;
	for (i=0;i<list.length-1;i++)
	{
		tmpList[tmpList.length]=list[i];
	    if ((list[i][col]!=list[i+1][col]))
		{
			var nullList=[]
			for (j=0;j<list[i].length;j++) nullList[nullList.length]=""
			tmpList[tmpList.length]=nullList;
		}
	}
	tmpList[tmpList.length]=list[list.length-1];
	list=[];
	list=tmpList;
	return tmpList;
}
function GetFrameMark(queryTypeCode,dataList,oeoriIdInd)
{
	if (queryTypeCode!="JYDO"){
		var tmpList=dataList[oeoriIdInd].split("||");
		if (tmpList.length>0) return tmpList[0];
	}
	else {
		var sortCol=GetArrayIndex(varList,"labNo"); //"reclocDesc"
		if (sortCol>-1) return dataList[sortCol];
	}
	return -1
}
function SetFrameData(queryTypeCode,printList,actRow,xlsSheet,xlsLeft,xlsTop,typeDesc,labNoStr,maxFrameCols,framePrint) //ypz 061128
{
    if (queryTypeCode.indexOf("JYDO")==-1) {
    	ReplaceOreIdByOriId(printList,oeoriIdInd)
    	MergeListByCol(printList,oeoriIdInd)
    }
    var PatInfo=document.getElementById("PatInfo").value;
    var str=cspRunServerMethod(PatInfo,printList[0][oeoriIdInd]);//0 have data!!
    var arr=str.split("^");//regNo_"^"_ctloc_"^"_room_"^"_sex_
    var titleDesc=arr[0]+"    "+arr[4]+"    "+arr[3]+","+arr[7]+String.fromCharCode(10)+"    "+arr[1];
    var tmpLabNoList=labNoStr.split("^");
	var labCount=tmpLabNoList.length-2;
	var i,j,k,dateTimeStr;
	var cols=printDescList.length;  //ypz 070601
	/*for (j=0;j<myColumns.length;j++)
	{
        if (j==GetArrayIndex(varList,"execCtcpDesc"))  //clear exec Careprovider col
        {
	        for (k=0;k<printList.length;k++){printList[k][j]="";}
        }
    }*/
   	dateTimeStr="";//GetPrintDateTime(86400,".",false);//+" 00:00 - 23:59";
    actRow=setFrameTitle(xlsSheet,titleDesc,dateTimeStr,typeDesc,actRow+xlsTop,printList,queryTypeCode,labCount);
	gridlistRow(xlsSheet,actRow,actRow-1,1,cols);

    
    //if ((queryTypeCode!="CQZLD")&&(queryTypeCode!="LSZLD")){
	////       for (j=3;j<cols;j++) {xlsSheet.cells(actRow,j-2)=myColumns[j];}
    //}
    //else{writeTitlezl(xlsSheet,actRow);}
	for (j=0;j<cols;j++) {xlsSheet.cells(actRow,j+1)=printDescList[j];}
	
	//ypz 061219 begin
	//if (queryTypeCode=="ZCQ"){
	//	var startDate=parent.frames["NurseTop"].document.getElementById("StartDate").value;
	//	SetWeekSheet(xlsSheet,startDate,actRow,printList,varList);
	//}
    //ypz 061219 end
	actRow=eval(actRow)+1;
	var tmpPrintList=[],varInd,tmpVal,newPrintList=[];
	for (i=0;i<printList.length;i++){
		tmpPrintList=[];
		for (j=0;j<printVarList.length;j++){
			varInd=GetArrayIndex(varList,printVarList[j]);
			tmpVal="";
			if (varInd>-1){tmpVal=printList[i][varInd]}
			tmpPrintList[tmpPrintList.length]=tmpVal;
		}
		newPrintList[newPrintList.length]=tmpPrintList;
	}
	//alert(printList+"//////"+newPrintList)
	//var str=CopyToExcel(printList,xlsSheet,0,printList.length-1,3,cols-1,actRow,xlsLeft)
	var str=CopyToExcel(newPrintList,xlsSheet,0,newPrintList.length-1,0,cols-1,actRow,xlsLeft)

	var tem=str.split("^");
	actRow=eval(tem[0]);
	var p=tem[1];
	if (framePrint=="Y"){
		//gridlist(xlsSheet,actRow,actRow-printList.length-p,1,maxFrameCols);
		gridlistRow(xlsSheet,actRow,actRow-newPrintList.length-p,1,cols);
	}
    //alert(i+"///////"+myData[i])
	actRow=eval(actRow)+1; //a blank line after frame
	return actRow;
}
function MergeListByCol(list,col)
{   //merge list by col
	var tmpList=[],i,j,k=0,tmpI,tmpJ;	
	for (i=0;i<list.length;i++)
	{
		tmpI=list[i][col];
		if (col==oeoriIdInd){
			tmpList=tmpI.split("||");
			if (tmpList.length>1) tmpI=tmpList[0]+"||"+tmpList[1];
		}
	    for (j=i+1;j<list.length;j++)
	    {
			tmpJ=list[j][col];
			if (col==oeoriIdInd){
				tmpList=tmpJ.split("||");
				if (tmpList.length>1) tmpJ=tmpList[0]+"||"+tmpList[1];
			}
		    if (tmpI==tmpJ)
		    {
		    	list[j][col]="Merge Row";
		    	//tmpList=list[j+1];list[j+1]=list[j];list[j]=tmpList;
		    }		     
	    }
	}
	j=1;
	for (i=1;i<list.length;i++)	{
	    if (list[i][col]!="Merge Row"){
		    list[j++]=list[i];
	    }
	}
	for (i=list.length-1;i>=j;i--){
		list.pop()
	}
}
function PrintClick()
{

	var queryTypeCode=document.getElementById('queryTypeCode').value; 
    if ((queryTypeCode=="Default")) return;
    var Card,i;  
    var queryTypeCode=document.getElementById('queryTypeCode').value; 
    if ((queryTypeCode.indexOf("JYDO")>-1)||(queryTypeCode.indexOf("BLD")>-1)){
	    if (ifPrintBar=="Y") PrintBar();
	    return;
    }
	if (ifPrintSheet=="Y") {
		printNurseSheet();
		return;
	}
	if (queryTypeCode.indexOf("BLDO")>-1)
	{
	    if (ifPrintBar=="Y"){PrintPathologyBar();}
    	return ;  //ypz 061109
	}
    if (((queryTypeCode=="SYDO")&&(ifPrintTransfusionCard=="Y"))||((queryTypeCode.indexOf("JYDO")>-1)&&(ifPrintLabNote=="Y")))
    {
        Card= new ActiveXObject("PrintBar.PrnBar");//TestAx.CLSMAIN
    }
    var objtbl=document.getElementById('tDHCNurOPExec');
    var ordPrintInfo=document.getElementById("OrdPrintInfo").value;
    var oeoriIdStr="";
	for (i=1;i<objtbl.rows.length;i++)
    {
        var check=document.getElementById('seleitemz'+i);
	    var oeoriId=document.getElementById('oeoriIdz'+i).innerText;
	    var PrintFlag=document.getElementById('tmpPrtFlagz'+i).innerText;
        if ((check.checked==true)&&(PrintFlag!="Y"))
	    {           
	        var arcimDesc=document.getElementById("arcimDescz"+i).innerText;
		 	var tmpList=arcimDesc.split("____");
		 	if ((tmpList.length<2)||(queryTypeCode=="PSDO")){
	           	if (oeoriIdStr.length==0){oeoriIdStr=oeoriId;}
               	else{oeoriIdStr=oeoriIdStr+"^"+oeoriId}
               	var str=cspRunServerMethod(ordPrintInfo,oeoriId);
 				// alert(str);return;
               	if (str!=""){
	           		if ((queryTypeCode=="SYDO")&&(ifPrintTransfusionCard=="Y")){
		           		Card.PrintName="tiaoma";//printer name
    	           		Card.OrderString=str;
        	       		Card.SetPrint();
        	       		Card.SYCWIDTH =8;
						Card.SYDHEIGHT =5;
            	   		Card.PrintSycd();
	           		}
            	   	else 
            	   	{
		           		/*if (queryTypeCode.indexOf("JYDO")<0)
		           		{	Card.xtprint="xiaotiao";//printer name
    	           			Card.OrderString=str;
        	       			Card.SetPrint();
            	   			Card.PrintCureSheet();
		           		}*/
            	   	}
               	}
		 	}
	    }
	}
	if (oeoriIdStr=="") return;
	if ((queryTypeCode.indexOf("JYDO")>-1)&&(ifPrintLabNote=="Y"))
   	{	
   		var str=cspRunServerMethod(ordPrintInfo,oeoriIdStr);
		Card.xtprint="xiaotiao";//printer name
    	Card.OrderString=str;
        Card.SetPrint();
   		Card.PrintLabNote();
	}
	if ((queryTypeCode.indexOf("SYDO")>-1)&&(ifPrintSeatNo=="Y")) PrintSeatClick()
	self.location.reload();
}
function PrintSeatClick()//print seat
{
   	var Card,i; 
   	//alert("ok") 
   	Card=new ActiveXObject("PrintBar.PrnBar");//TestAx.CLSMAIN
   	var objtbl=document.getElementById('tDHCNurOPExec');
   	var oeoriIdStr="";
	for (i=1;i<objtbl.rows.length;i++)
    {
        var check=document.getElementById('seleitemz'+i);
	    var oeoriId=document.getElementById('oeoriIdz'+i).innerText;
	    var PrintFlag=document.getElementById('tmpPrtFlagz'+i).innerText;
        if ((check.checked==true)&&(PrintFlag!="Y"))
	    {           
            var ordPrintInfo=document.getElementById("OrdPrintInfo").value;
            //alert(oeoriId)
            var str=cspRunServerMethod(ordPrintInfo,oeoriId);
            //alert(str);return;
            if (str!="")
            {
	        	Card.xtprint="xiaotiao";//printer name
              	Card.OrderString=str;
               	Card.PrintSeat();
               	return;
            }
	    }
	}
}
function PrintBar()//print barcode
{
    var Bar,i,j;
    var queryTypeCode=document.getElementById('queryTypeCode').value; 
    if ((queryTypeCode.indexOf("JYDO")<0)) return;
    Bar= new ActiveXObject("PrintBar.PrnBar");//TestAx.CLSMAIN
    Bar.PrintName="tiaoma";//printer name
    //Bar.SetBarPrint();return;
    var objtbl=document.getElementById('tDHCNurOPExec');
    var oeoriIdStr="",printedLabNoStr="^";
    var getArcimShortDesc=document.getElementById("GetArcimShortDesc").value;
    for (i=1;i<objtbl.rows.length;i++)
    {
        var check=document.getElementById('seleitemz'+i);
        var oeoriId=document.getElementById('oeoriIdz'+i).innerText;
        var PrintFlag=document.getElementById('tmpPrtFlagz'+i).innerText;
        var disposeStatCode=document.getElementById('disposeStatCodez'+i).innerText;
        var labNo=document.getElementById('labNoz'+i).innerText;  //ypz 061026
        if ((check.checked==true)&&(disposeStatCode=="UnPaid")) alert(t['alert:unPaidOrd'])
        var reclocDesc=document.getElementById('reclocDescz'+i).innerText;
        //if (offLineRecLoc.indexOf("^"+reclocDesc+"^")>-1) continue;  //ypz 070706
        var tmpList=printedLabNoStr.split("^"+labNo+"^")  //ypz 061026
        if ((check.checked==true)&&(PrintFlag!="Y")&&(disposeStatCode!="UnPaid")&&(tmpList.length<2))
        {           
            var	objPlacerCode=document.getElementById('placerCodez'+i);
            var placerCode="";
            if (objPlacerCode) {placerCode=objPlacerCode.innerText;}
            var labelDesc="";
            var colorDesc=document.getElementById("color"+placerCode);
            if (colorDesc)
            {
	           				labelDesc=colorDesc.value;
            }
            //if ((placerCode!="")&&(placerCode!=" ")) labelDesc=t['val:color'+placerCode];
            if (oeoriIdStr.length==0){oeoriIdStr=oeoriId}
            else{oeoriIdStr=oeoriIdStr+"^"+oeoriId}
            //alert (myData[i]);
            var PatInfo=document.getElementById("PatInfo").value;
            var str=cspRunServerMethod(PatInfo,oeoriId);
            var arr=str.split("^");//regNo_"^"_ctloc_"^"_room_"^"_sex_"^"_pagName
            var regNo=arr[0];
            var ctloc=arr[1]; var room=arr[2];
            var PreOrdSet;
            var GetOrdSet=document.getElementById("GetOrdSet");
            var OrdSet=cspRunServerMethod(GetOrdSet.value,oeoriId);
            if ((PreOrdSet!="")&&(OrdSet==PreOrdSet)){
            }
            else
            {
                var GetSpecName=document.getElementById("SpecName").value;
                var SpecName=cspRunServerMethod(GetSpecName,oeoriId);//if need
                //var getLabelDesc=document.getElementById("GetLabelDesc").value;
                //var labelDesc=cspRunServerMethod(getLabelDesc,oeoriId);
                var OrdName=""  ///reclocDesc
                var Sex=arr[3];
                var PatName=regNo+" "+arr[4]
                var Age=arr[7]
                var bedCode=arr[6]
                var patLoc=arr[1]
                var tmpList=arr[1].split("-")
                if (tmpList.length>1) patLoc=tmpList[1]
                //alert(tmpList+"/"+tmpList.length+"/"+patLoc);return;
                if (OrdSet==""){
	                    OrdName=cspRunServerMethod(getArcimShortDesc,"",oeoriId);//ypz 080717 //document.getElementById('arcimDescz'+i).innerText;
	               }
                else{OrdName=OrdSet;}
                //ypz 061026 begin
                for (j=i+1;j<objtbl.rows.length;j++)
                {
                    var addLabNo=document.getElementById('labNoz'+j).innerText;
                    var addCheck=document.getElementById('seleitemz'+j);//
                    var addPrintFlag=document.getElementById('tmpPrtFlagz'+j).innerText;//
                    var addDisposeStatCode=document.getElementById('disposeStatCodez'+j).innerText;
	    			
                    if ((addCheck.checked==true)&&(addPrintFlag!="Y")&&(addDisposeStatCode!="UnPaid")&&(addLabNo==labNo))
                    {
	                    var addOeoriId=document.getElementById('oeoriIdz'+j).innerText;
                        addOrdName=cspRunServerMethod(getArcimShortDesc,"",addOeoriId);//ypz 080717 //document.getElementById('arcimDescz'+j).innerText;
                        if (addOrdName!="") OrdName=OrdName+","+addOrdName;
                    }
                }

                printedLabNoStr=printedLabNoStr+labNo+"^"
                PreOrdSet=OrdSet;
                Bar.LabNo=labNo;
                Bar.RecLoc=reclocDesc;
                //Bar.SpecName=SpecName;
                Bar.LabelDesc=labelDesc;
                Bar.PatLoc=patLoc;
                Bar.OrdName=OrdName;
                Bar.PatName=PatName;
                Bar.Sex=Sex;
                Bar.Age=Age;
                Bar.BedCode=bedCode;
                Bar.PrintOut(1);
            }
        }
    }
    // Bar.PrintOut(SpecNo, SpecName, OrdName, Sex, PatName, Age);
    if (oeoriIdStr.length>0){
       SetPrintFlag(oeoriIdStr)  //060915
    }
}
function PrintPathologyBar() //print Pathology barcode
{
    var Bar,i,j;
    var queryTypeCode=document.getElementById('queryTypeCode').value; 
    if ((queryTypeCode.indexOf("BLDO")<0)) return;
    Bar= new ActiveXObject("PrintBar.PrnBar");//TestAx.CLSMAIN
    Bar.PrintName="tiaoma";//printer name
    //Bar.SetBarPrint();return;
    var objtbl=document.getElementById('tDHCNurOPExec');
    var oeoriIdStr="";
    var getArcimShortDesc=document.getElementById("GetArcimShortDesc").value;
    for (i=1;i<objtbl.rows.length;i++)
    {
        var check=document.getElementById('seleitemz'+i);
        var oeoriId=document.getElementById('oeoriIdz'+i).innerText;
        var PrintFlag=document.getElementById('tmpPrtFlagz'+i).innerText;
        var disposeStatCode=document.getElementById('disposeStatCodez'+i).innerText;
        var labNo=document.getElementById('labNoz'+i).innerText;
        var specDesc="";
        var objSpecDesc=document.getElementById('specDescz'+i);
        if (objSpecDesc) specDesc=objSpecDesc.innerText;
        if ((check.checked==true)&&(disposeStatCode=="UnPaid")) alert(t['alert:unPaidOrd'])
        //if (offLineRecLoc.indexOf("^"+reclocDesc+"^")>-1) continue;  //ypz 070706
        if ((check.checked==true)&&(PrintFlag!="Y")&&(disposeStatCode!="UnPaid")&&(specDesc.length>1))
        {           
            if (oeoriIdStr.length==0){oeoriIdStr=oeoriId}
            else{oeoriIdStr=oeoriIdStr+"^"+oeoriId}
            var PatInfo=document.getElementById("PatInfo").value;
            var str=cspRunServerMethod(PatInfo,oeoriId);
            var arr=str.split("^");//regNo_"^"_ctloc_"^"_room_"^"_sex_"^"_pagName
            var regNo=arr[0];
            var ctloc=arr[1]; var room=arr[2];
            var reclocDesc=document.getElementById('reclocDescz'+i).innerText;
            var OrdName=""  ///reclocDesc
            var Sex=arr[3];
            var PatName=regNo+" "+arr[4]
            var Age=arr[7]
            var bedCode=arr[6]
            var patLoc=arr[1]
            var tmpList=arr[1].split("-")
            if (tmpList.length>1) patLoc=tmpList[1]
	           OrdName=cspRunServerMethod(getArcimShortDesc,"",oeoriId);//ypz 080717 //document.getElementById('arcimDescz'+i).innerText;
                
            tmpList=specDesc.split("/");
            for (j=0;j<tmpList.length;j++)
            {
	               //alert(tmpList[j]);continue;
                Bar.LabNo=labNo;
                Bar.RecLoc=reclocDesc;
                Bar.LabelDesc=tmpList[j];;
                Bar.PatLoc=patLoc;
                Bar.OrdName=OrdName;
                Bar.PatName=PatName;
                Bar.Sex=Sex;
                Bar.Age=Age;
                Bar.BedCode=bedCode;
                Bar.PrintOut(1);
            }
        }
    }
    if ((oeoriIdStr.length>0)&(chkSelPrint==false)){
      //SetPrintFlag(oeoriIdStr)
    }	
}

function PrintSingleOrder(queryTypeCode,oeoriId)
{
	var ordPrintInfo=document.getElementById("OrdPrintInfo").value;///get data
	resStr=cspRunServerMethod(ordPrintInfo,oeoriId);
	if (resStr!="")
	{
		var Card;  
		Card= new ActiveXObject("PrintBar.PrnBar");//TestAx.CLSMAIN
		Card.OrderString=resStr;
		Card.SetPrint();
		if (queryTypeCode=="SYDO"){
			Card.PrintName="tiaoma";//printer name
			Card.PrintSycd();
		}
		else
		{
	   		if ((queryTypeCode.indexOf("JYDO")==-1)&&(queryTypeCode!="ZSDO")){
				Card.xtprint="xiaotiao"
				Card.PrintCureSheet();
			}
		}
	}
	else{alert(t["alert:carderr"]);return false;}  
	return true;
}

function GetElement(Id,defaultVal)
{
	var retVal=defaultVal;
	var obj=document.getElementById(Id);
	if (obj) retVal=obj.value;
	return retVal;
}
function ReplaceOreIdByOriId(list,col)
{   
	var tmpList=[],i;
	for (i=0;i<list.length;i++)	{
		if (list[i].length>col) {
			tmpList=list[i][col].split("||")
			if (tmpList.length>1) list[i][col]=tmpList[0]+"||"+tmpList[1];
	    }
	}
}
function PrintTPQ()
{
    var Card,i;  
    var queryTypeCode=document.getElementById('queryTypeCode').value; 
    Card= new ActiveXObject("PrintBar.PrnBar");//TestAx.CLSMAIN
    var objtbl=document.getElementById('tDHCNurOPExec');
    var ordPrintInfo=document.getElementById("OrdPrintInfo").value;
    var SyCard=document.getElementById("SyCard").value;
    var PatInfo=document.getElementById("PatInfo").value;
    var oeoriIdStr="";
    var SeatNo=""
    var objSeatNo=parent.frames["NurseTop"].document.getElementById("SeatNo");
	if (objSeatNo)SeatNo=objSeatNo.value;
	
	for (i=1;i<objtbl.rows.length;i++)
    {
        var check=document.getElementById('seleitemz'+i);
	    var oeoriId=document.getElementById('oeoriIdz'+i).innerText;
	    var PrintFlag=document.getElementById('tmpPrtFlagz'+i).innerText;
        if (check.checked==true)
	    {           
	        var arcimDesc=document.getElementById("arcimDescz"+i).innerText;
		 	var tmpList=arcimDesc.split("____");
		 	if (true){
           	if (oeoriIdStr.length==0){oeoriIdStr=oeoriId;}
           	else{oeoriIdStr=oeoriIdStr+"^"+oeoriId}
            if(tmpList.length>1){
	            continue;
	            }
           	//	var str=cspRunServerMethod(ordPrintInfo,oeoriId);
           	var str=cspRunServerMethod(PatInfo,oeoriId);
	 	  	var Pat=str.split("^");
			var ret=cspRunServerMethod(SyCard,oeoriId);
		    var syd=ret.split("@");
			// alert(str);return;
		   for(j=0;j<syd.length;j++)
		   {
			   //alert(oeoriId)
			 if (syd[j]!="")
			 {
				retStr=1
				var tem=syd[j].split("^");
                Card.Ord=tem[0];
                //Bar.PatLoc=tem[5];
                Card.PatName=tem[1];
                Card.PrintName="shuyeka"
                Card.SetPrint();
                Card.BedCode=SeatNo;
                //Bar.PhFactor=tem[0].split("!")[0].split("|")[4];
                //Bar.StDateTime=tem[6];
                //Bar.SYName =cardname;
                Card.ExeDate=tem[4].split(" ")[0];
                //Bar.OeoriId=oeori;
                Card.OeoriId="";
                Card.Sex=Pat[3];
                Card.Age=Pat[7];
                Card.PatWard=Pat[8];
                var oecprDesc=tem[0].split("!")[0].split("|")[5];
                //Bar.SYTYP=sytyp;
                Card.SYCWIDTH=8;
                Card.SYDHEIGHT=5;
                var InfusionCardnum=eval(tem[0].split("!")[0].split("|")[4]);
                var OeoriQty=tem[7];  //首日次数
                var FillerNo=tem[8];  //判断是否是首日新医嘱
                var Pdaflag=1
                if (Pdaflag==0)
                {
	                for(var InfCardi=1;InfCardi<InfusionCardnum+1;InfCardi++)
	                {
		                Card.SyNo=InfCardi+"/"+InfusionCardnum
		                Card.PrintInfusionCardQZ();
		                //CardNum++;
		            }
                }
                else
                {
	                Card.OeoriId=oeoriId;
	                if ((FillerNo=="")&&(oeoriId.split("||")[2]>OeoriQty)) //add by liulei 091204
	                {
		                Card.SyNo=oeoriId.split("||")[2]-OeoriQty+"/"+InfusionCardnum;  
		            }
		            else
		            {
			            Card.SyNo=oeoriId.split("||")[2]+"/"+InfusionCardnum; 
			        } 
                	Card.PrintInfusionCardQZ();
                	//CardNum++;
                }
              }
	       }
		 	}
	    }
	}
	if (oeoriIdStr=="") return;
	if (oeoriIdStr.length>0){
         SetTPQPrintFlag(oeoriIdStr);
    }
	self.location.reload();
}
