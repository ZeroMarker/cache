function PrintRp(queryTypeCode,typ,RpDes)
{
    var PrintComm,i;
    PrintComm= new ActiveXObject("PrintBar.PrintCls");//TestAx.CLSMAIN
	//PrintComm.PrintName="zhixingdan";//printer name
	//var ordPrintInfo=document.getElementById("OrdPrintInfo").value;
    var oeoriIdStr="";
    var PatInfo=document.getElementById("PatInfo").value;
    var GetHead=document.getElementById("GetHead").value;
    var Head;
    Head=cspRunServerMethod(GetHead,HospitalRowId+"@"+queryTypeCode);
    var Data;
    var Pat;
    Data=Head.split("!");
    var Copise=document.getElementById("Copies");
    var hospitalName=document.getElementById("hospitalName").value;
      if (Copise){
	   PrintComm.Copies=Copise.value;
	   }else{
		   PrintComm.Copies=1;
	   }
		PrintComm.LeftW=0;  //Data[1];
    PrintComm.PageSize(1,2);
    PrintComm.PrinterName="zhixingdan";
    PrintComm.PrintBegin();
    PrintComm.HospitalName=hospitalName;
    PrintComm.PrintRpTyp=RpDes;
    PrintComm.PrintOut();
    var PrePatName,PreSeq;
    PrePatName="",PreSeq="";
    var PrintNum;
    PrintNum=0;
    var oeordnum=1
    var phcinDescSort=""
    var phcinDescSortNew=""
    var PrintNum1
    PrintNum1=0
    var phcfrnum=1
    var TypeCodeStr="CQSYD^SYD^CQZSD^cqkfyd^ZSD"

		for (i=0;i<myData.length;i++)
    { 
	  // if ((myData[i][1]!="Y")||(chkSelPrint==true))
	   //{
		PrintNum=PrintNum+1; 
		PrintNum1=PrintNum1+1 
	    var oeoriId=myData[i][0];

	    var str=cspRunServerMethod(PatInfo,oeoriId);
	    
	   var arcdes=GetArcim(oeoriId,HospitalRowId+"@"+queryTypeCode);
	    //s retStr=regNo_"^"_ctlocDesc_"^"_$g(room)_"^"_$g(sex)_"^"_$g(patName)_"^"_$g(safetyNetCardNo)_"^"_$g(bedCode)_"^"_$g(age)_"岁^"_$g(wardDesc)_"^"_homeAddres_"^"_homeTel_"  "_workTel_"  "_handtel
        var RetStr=arcdes.split("@")
        var orderitem=RetStr[0].split("^");

	    Pat=str.split("^");
	    if ((PrePatName!=Pat[4])||(PrePatName==""))
	    {
         if ((PrePatName!=Pat[4])&&(PrePatName!==""))
	      {
		    //PrintComm.PrintFoot();
		    ///PrintComm.PrintNewPage();
		    //PrintComm.PrintOut();
		  }
           PrintComm.BedNo = Pat[6];
           PrintComm.PatName = Pat[4];
           PrintComm.OrdDate = orderitem[5];
           PrintComm.PatDoc = Pat[11];
           PrintComm.RegNo = Pat[0];
           PrintComm.Age=Pat[7];
           PrintComm.PrnDate =orderitem[6];
           PrintComm.PrnUser =session['LOGON.USERNAME'];
           PrintComm.Dep = Pat[1];
           PrintComm.Room = Pat[2];
           PrintComm.PrintTitle = Data[0];
           PrintComm.PrintHead();
           PrePatName=Pat[4];
           PrintNum1=1
	    }
	    PrintComm.Freq = orderitem[2];
        PrintComm.Prior =orderitem[8];
        PrintComm.NumSX ="";
        PrintComm.Dose = orderitem[1];
        PrintComm.MedMth = orderitem[3];
        PrintComm.ExTime = "";
        //if(oeordnum>1)                               //wkz 080403  S
        //{
	       // PrintComm.OrdString ="___"+orderitem[0];
        //}
       // else
        //{
	        PrintComm.OrdString = orderitem[0];
        //}                                            //wkz 080403   E
        PrintComm.TitVal=RetStr[1];
        PrintComm.SinglNote =orderitem[12];
        //wkz 080104 S
        if(oeordnum<2) phcinDescSortNew=RetStr[0].split("|")[3] //RetStr[1].split("^")[2].split("|")[2]
		if ((phcinDescSortNew!=phcinDescSort)&(queryTypeCode=="JHD")&(PrintNum1>1)){
			PrintComm.PY=PrintComm.PY+300   
		    PrintComm.PrintLine(PrintComm.PX,PrintComm.PY,1,PrintComm.LineLong);
		    //PrintComm.PrintMethExTime();
		}
		//wkz 080104 E
        PrintComm.PrintItem();
		//wkz 080103 S
		if (oeordnum<2) phcfrnum=RetStr[0].split("|")[4];
		//{ var phcfrcode=RetStr[1].split("^")[2].split("|")[2]; } 
		//phcfrnum=Getphcfrnum(phcfrcode)
        if((oeordnum<2)&(queryTypeCode=="JHD")) phcinDescSort=RetStr[0].split("|")[3] //RetStr[1].split("^")[2].split("|")[2]
        var nextseq;
        var ord;
        var ordstr,temordstr;
        if ((i+1)<myData.length){
	        ord=myData[i+1][0]
            ordstr=GetArcim(ord,HospitalRowId+"@"+queryTypeCode);
            temordstr=(ordstr.split("@"))[0].split("^");
            nextseq=temordstr[7];
	       if ((nextseq!=orderitem[7]))
	       {

		     var oeordnum=1
		     if (TypeCodeStr.indexOf(queryTypeCode)!=-1){    //WKZ 080107  S
			     PrintComm.Notes ="";
			     PrintComm.PrintMethExTime();
				 phcfrnum=phcfrnum-1  //oeordnum
			     if(phcfrnum<0){phcfrnum=0}
			     for (var phci=1;phci<phcfrnum+1;phci++)
			     {
				     PrintComm.PY=PrintComm.PY+300;
				     PrintComm.Notes ="";
				     PrintComm.PrintMethExTime();
			     }
		     }
		     else {
			     PrintComm.Notes ="";
			     PrintComm.PrintMethExTime();			     
		     }                                              //WKZ 080107  E
        	 /*if(queryTypeCode!="JHD"){
        	 PrintComm.PY=PrintComm.PY+300*phcfrnum        //wkz 080103
        	 }
        	 PrintComm.Notes ="";
		     PrintComm.PrintMethExTime();
             //PrintComm.Notes ="";    */
             PreSeq = orderitem[7]

           }
            else{
			    PrintComm.Notes ="";                       //wkz 080403
			    //PrintComm.PrintMethExTime();               //wkz 080403	
	            oeordnum=oeordnum+1                      //wkz 080103
           }
        }
        if ((i+1)==myData.length){
	        if (TypeCodeStr.indexOf(queryTypeCode)!=-1){  //WKZ 080107  S
			     PrintComm.Notes ="";
			     PrintComm.PrintMethExTime();
				 phcfrnum=phcfrnum-1  //oeordnum
			     if(phcfrnum<0){phcfrnum=0}
			     for (var phci=1;phci<phcfrnum+1;phci++)
			     {
				     PrintComm.PY=PrintComm.PY+300;
				     PrintComm.Notes ="";
				     PrintComm.PrintMethExTime();
			     }
		     }
		     else {
			     PrintComm.Notes ="";
			     PrintComm.PrintMethExTime();			     
		     }                                             //WKZ 080107  E
	         /*if(queryTypeCode!="JHD"){
	         PrintComm.PY=PrintComm.PY+300*phcfrnum       //wkz 080103   
	         }
	         PrintComm.Notes ="";
	         PrintComm.PrintMethExTime();
             //PrintComm.Notes ="";  */
             PrintComm.PrintFoot();
	        }
	   }
   //}
 
   if (PrintNum>0){ 
   PrintComm.PrintEnd();
   }
   printCollectData=printCollectData.join("^")
   if (printCollectData.length>0){
	   
     SetPrintFlag(printCollectData);
    }
	self.location.reload();
}
function Getphcfrnum(phcfrCode)                            //wkz 080103
{
	var Getphcfrnum=document.getElementById("Getphcfrnum").value;
	var str=cspRunServerMethod(Getphcfrnum,phcfrCode);
	return str;
}
function GetArcim(ord,queryTypeCode)
{
	    var Ord,chl,tstr;
	    var getarcim=document.getElementById("getarcim").value;
	    tstr=ord.split("||");
	    Ord=tstr[0];
	    chl=tstr[1];
	    oeoreSub=tstr[2]
	    var str=cspRunServerMethod(getarcim,Ord,chl,oeoreSub,queryTypeCode);
	    return str;

}
function PrintSelSYCARD1()
 {
	 var retStr=0
   	 var typ=document.getElementById("vartyp").value;
   	 if ((vartyp.indexOf("SYD")<0)) return;
     //if ((typ!="PYD")&&(typ!="CQPYD")&&(typ!="CQZSD")&&(typ!="LSPYD")) 
     var sytyp="";
     if ((typ=="PYD")||(typ=="LSPYD"))
     {
	    sytyp="temp";
	 }
     if ((typ=="CQPYD")||(typ=="CQZSD"))
     {
	    sytyp="long";
	 }
	 var typindex;
	 var cardname;
	 typindex=typ.indexOf("PYD");
	 if (typindex!=-1)
	 {
		 cardname="dzc";
	 }
	 typindex=typ.indexOf("ZS");
	 if (typindex!=-1)
	 {
		 cardname="zsc";
	 }
	var chkSelPrint=document.getElementById('chkSelPrint').checked;
	myData=[];
	if (chkSelPrint==true) resStr=GetCheckData();
	else resStr=QueryPrintData();
	if (resStr!="0"){alert(resStr); return;}	   
	var Bar= new ActiveXObject("PrintBar.PrnBar");//TestAx.CLSMAIN
	//Bar.PrintName="shuyeka"
	var objtbl=document.getElementById('tDHCNURSEXCUTE');
	if(!objtbl) var objtbl=document.getElementById('tDHCNurIPExec');
	var i,j;
    // oeoriIdStr="";preOrderId=0//alert("len="+oeoriIdStr.length)
    // xlsExcel.Visible = true;
    //var warddes=document.getElementById("warddes").value; 
    var SyCard=document.getElementById("SyCard").value;
    //Bar.SetPageSize();
    j=0

    /*for (i=1;i<objtbl.rows.length;i++)
    {
	    var check=document.getElementById('seleitemz'+i);
	    var oeori=document.getElementById('oeoriIdz'+i).innerText;
	    var PrintFlag=document.getElementById('prtFlagz'+i).innerText;
	    if ((check.checked==true)&&(PrintFlag!="Y"))//&&(dispstat!="L")
	    {*/
    for (i=0;i<myData.length;i++)
    {
	   var oldi=i
       if ((myData[i][1]!="Y")||(chkSelPrint==true))
	   {
		   var oeori=myData[i][0];
		   var ret=cspRunServerMethod(SyCard,oeori);
		   var syd=ret.split("@");
		   for(j=0;j<syd.length;j++)
		   {
			 if (syd[j]!="")
			 {
				retStr=1
				var tem=syd[j].split("^");
                Bar.Ord=tem[0];
                Bar.PatLoc=tem[5];
                Bar.PatName=tem[1];
                Bar.BedCode=tem[2];
                //Bar.PhFactor=tem[0].split("!")[0].split("|")[4];
                //Bar.StDateTime=tem[6];
                //Bar.SYName =cardname;
                //Bar.SYTYP = sytyp;
                Bar.SYCWIDTH =4.8;
                Bar.SYDHEIGHT =3.2;
                //Bar.PrintSYCARD();
                var InfusionCardnum=eval(tem[0].split("!")[0].split("|")[4]);
                for(var InfCardi=1;InfCardi<InfusionCardnum+1;InfCardi++)
                {
                	Bar.SyNo=InfCardi+"/"+InfusionCardnum
                	Bar.PrintInfusionCardHX();
                }
                //num=num+1;
              }
	       }
	   }
   }
   if(retStr==0) {alert("没有打印数据?");return}
   //Bar.NewPage();
   //Bar.EndDoc();
   Bar=null;
 }
function PrintSelSYCARD2()
 {
	 var objPrintbut=document.getElementById("sycbtn");
	 if (objPrintbut) objPrintbut.style.display="none";
	 var retStr=0
   	 var typ=document.getElementById("vartyp").value;
     if ((vartyp.indexOf("SYD")<0)) return;
     var sytyp="";
     if ((typ=="SYD")||(typ=="LSZSD"))
     {
	    sytyp="temp";
	 }
     if ((typ=="CQSYD")||(typ=="CQZSD"))
     {
	    sytyp="long";
	 }
	 var typindex;
	 var cardname;
	 typindex=typ.indexOf("SY");
	 if (typindex!=-1)
	 {
		 cardname="dzc";
	 }
	 typindex=typ.indexOf("ZS");
	 if (typindex!=-1)
	 {
		 cardname="zsc";
	 }
	var chkSelPrint=document.getElementById('chkSelPrint').checked;
	myData=[];
	if (chkSelPrint==true) resStr=GetCheckData();
	else resStr=QueryPrintData();
	if (resStr!="0"){alert(resStr); return;}	   
	var Bar= new ActiveXObject("PrintBar.PrnBar");//TestAx.CLSMAIN
	var objtbl=document.getElementById('tDHCNURSEXCUTE');
	var i,j;
    // oeoriIdStr="";preOrderId=0//alert("len="+oeoriIdStr.length)
    // xlsExcel.Visible = true;
    //var warddes=document.getElementById("warddes").value; 
    var SyCard=document.getElementById("SyCard").value;
    //Bar.SetPageSize();
    j=0

    /*for (i=1;i<objtbl.rows.length;i++)
    {
	    var check=document.getElementById('seleitemz'+i);
	    var oeori=document.getElementById('oeoriIdz'+i).innerText;
	    var PrintFlag=document.getElementById('prtFlagz'+i).innerText;
	    if ((check.checked==true)&&(PrintFlag!="Y"))//&&(dispstat!="L")
	    {*/
    for (i=0;i<myData.length;i++)
    {
	   var oldi=i
       if ((myData[i][1]!="Y")||(chkSelPrint==true))
	   {
		   var oeori=myData[i][0];
		   var ret=cspRunServerMethod(SyCard,oeori);
		   var syd=ret.split("@");
		   for(j=0;j<syd.length;j++)
		   {
			 if (syd[j]!="")
			 {
				retStr=1
				var tem=syd[j].split("^");
                Bar.Ord=tem[0];
                Bar.PatLoc=tem[5];
                Bar.PatName=tem[1];
                Bar.BedCode=tem[2];
                Bar.PhFactor=tem[0].split("!")[0].split("|")[4];
                //Bar.StDateTime=tem[6];
                //Bar.SYName =cardname;
                //Bar.SYTYP = sytyp;
                Bar.SYCWIDTH =6500;
                Bar.SYDHEIGHT =5000;
                Bar.GridWidth=4500
                Bar.PrintSYCARD();
                //num=num+1;
              }
	       }
	   }
   }
   if(retStr==0)
   {
	   alert("没有打印数据?");
	   if (objPrintbut) objPrintbut.style.display="block";
	   return
	}
   if (objPrintbut) objPrintbut.style.display="block";
   Bar.NewPage();
   Bar.EndDoc();
   Bar=null;
 }
 function PrintSelSYCARD()
 {
	 var retStr=0
   	 var typ=document.getElementById("vartyp").value;
   	 var oeoriIdStr="";
     if (typ.indexOf("SY")<0) return;
     var sytyp="";
     if ((typ=="SYD")||(typ=="LSZSD"))
     {
	    sytyp=t['val:temp'];
	 }
     if ((typ=="CQSYD")||(typ=="CQZSD"))
     {
	    sytyp=t['val:long'];
	 }
	 var typindex;
	 var cardname;
	 typindex=typ.indexOf("SY");
	 if (typindex!=-1)
	 {
		 cardname="dzc";
	 }
	 typindex=typ.indexOf("ZS");
	 if (typindex!=-1)
	 {
		 cardname="zsc";
	 }
	//var chkSelPrint=document.getElementById('chkSelPrint').checked;
	myData=[];
	//if (chkSelPrint==true) resStr=GetCheckData(1);
	//else resStr=QueryPrintData("M",1);
	resStr=QueryPrintData("M",true);
	if (resStr!="0"){alert(resStr); return;}	   
	var Bar= new ActiveXObject("PrintBar.PrnBar");
	Bar.PrintName="shuyeka"
	Bar.SetPrint();
	var objtbl=document.getElementById('tDHCNURSEXCUTE');
	var i,j;
    var SyCard=document.getElementById("SyCard").value;
    var PatInfo=document.getElementById("PatInfo").value;  
    
    j=0
	var CardNum=0;   
	
    for (i=0;i<myData.length;i++)
    {
	   var oldi=i
      // if (myData[i][1].indexOf("M")<0)
	   //{
		   if (oeoriIdStr.length==0){oeoriIdStr=myData[i][0]}
       	   else{oeoriIdStr=oeoriIdStr+"^"+myData[i][0]}
		   var oeori=myData[i][0];
		   var str=cspRunServerMethod(PatInfo,oeori);
		   var Pat=str.split("^");
		   var syd=cspRunServerMethod(SyCard,oeori);
		   retStr=1
		   var tem=syd.split("^");
		   var ret=syd.split("@");
		   Bar.Ord=tem[0];
		   Bar.PatName=tem[1];
		   Bar.BedCode=tem[2];
		   Bar.ExeDate=tem[4].split(" ")[0];
		   Bar.OeoriId="";
		   Bar.Sex=Pat[3];
		   Bar.Age=Pat[7];
		   Bar.PatWard=Pat[8];       
		   Bar.SYCWIDTH=8;
		   Bar.SYDHEIGHT=5;
		   if(myData[i][1].indexOf("M")>-1) Bar.PrnFlag=t['val:repeatprint'];
		   else Bar.PrnFlag=" ";
		   var InfusionCardnum=eval(tem[0].split("!")[0].split("|")[4]);
		   var phfTimes=eval(tem[0].split("!")[0].split("|")[5]);
		   Bar.OeoriId=oeori;
		   Bar.SyNo=phfTimes+"/"+InfusionCardnum; 
		   if(ret[1]==0)Bar.PrintInfusionCardQZ();
          CardNum++;
	  // }
   }
   if(retStr==0) {alert("没有打印数据?");return}
   if (printCollectData.length>0){
	   
     SetPrintFlag(printCollectData.join("^"),"M");
    }
    self.location.reload();
   Bar=null;
 }
function PrintRpByWard(queryTypeCode,typ,RpDes)
{
	var PrintComm,i;
    PrintComm= new ActiveXObject("PrintBar.PrintCls");
    var oeoriIdStr="";
    var PatInfo=document.getElementById("PatInfo").value;
    var GetHead=document.getElementById("GetHead").value;
    var Head;
    Head=cspRunServerMethod(GetHead,HospitalRowId+"@"+queryTypeCode);
    var Data;
    var Pat;
    Data=Head.split("!");
    var Copise=document.getElementById("Copies");
    var hospitalName=document.getElementById("hospitalName").value;
      if (Copise){
	   PrintComm.Copies=Copise.value;
	   }else{
		   PrintComm.Copies=1;
	   }
	PrintComm.LeftW=Data[1];
    PrintComm.PageSize(1,2);
    PrintComm.PrinterName="zhixingdan";
    PrintComm.PrintBegin();
    PrintComm.HospitalName=hospitalName;
    PrintComm.PrintRpTyp=RpDes;
    PrintComm.PrintOut();
    var PrePatName,PreSeq;
    PrePatName="",PreSeq="";
    var PrintNum;
    PrintNum=0;
    var oeordnum=1
    var phcinDescSort=""
    var phcinDescSortNew=""
    var PrintNum1
    PrintNum1=0
	for (i=0;i<myData.length;i++)
    { 
	   //if ((myData[i][1]!="Y")||(chkSelPrint==true))
	   //{

		PrintNum=PrintNum+1; 
		PrintNum1=PrintNum1+1 
	    var oeoriId=myData[i][0];
	    var str=cspRunServerMethod(PatInfo,oeoriId);
	    
	    var arcdes=GetArcim(oeoriId,HospitalRowId+"@"+queryTypeCode);
	    //s retStr=regNo_"^"_ctlocDesc_"^"_$g(room)_"^"_$g(sex)_"^"_$g(patName)_"^"_$g(safetyNetCardNo)_"^"_$g(bedCode)_"^"_$g(age)_"岁^"_$g(wardDesc)_"^"_homeAddres_"^"_homeTel_"  "_workTel_"  "_handtel
        var RetStr=arcdes.split("@")
        var orderitem=RetStr[0].split("^");
	    Pat=str.split("^");
	    if ((PrePatName!=Pat[4])||(PrePatName==""))
	    {
			PrintComm.BedNo = Pat[6];
			PrintComm.PatName = Pat[4];
			PrintComm.OrdDate = orderitem[5];
			PrintComm.PatDoc = Pat[11];
			PrintComm.RegNo = Pat[0];
			PrintComm.Age=Pat[7];
			PrintComm.PrnDate =orderitem[6];
			PrintComm.PrnUser =session['LOGON.USERNAME'];
			PrintComm.Dep = Pat[1];
			PrintComm.Room = Pat[2];
			PrintComm.PrintTitle = Data[0];
			if ((PrePatName!=Pat[4])&&(PrePatName!==""))
			{
				PrintComm.PrintLine(0,PrintComm.PY-50,1,PrintComm.LineLong);
				var PX=50
				var PY=PrintComm.PY
				PrintComm.PrintStringLeftHead(PX,PrintComm.PY, Pat[6], 10, "True")
				if(PY==PrintComm.PY)
				{
					var PX=eval(Data[0].split("^")[0].split("|")[1])+50
					PrintComm.PrintStringLeftHead(PX,PrintComm.PY, Pat[4], 10, "True")
				}
			}
			if(PrePatName=="") PrintComm.PrintHeadWard();
			PrePatName=Pat[4];
			PrintNum1=1
	    }
	    PrintComm.Freq = orderitem[2];
        PrintComm.Prior =orderitem[8];
        PrintComm.NumSX ="";
        PrintComm.Dose = orderitem[1];
        PrintComm.MedMth = orderitem[3];
        PrintComm.ExTime = "";
        //if(oeordnum>1)
        //{
	       // PrintComm.OrdString ="___"+orderitem[0];
        //}
        //else
        //{
	        PrintComm.OrdString = orderitem[0];
        //} 
        PrintComm.TitVal=RetStr[1];
        PrintComm.SinglNote =orderitem[12];
        PrintComm.PrintItemWard();
        var ord;
        var ordstr,temordstr;
        if ((i+1)<myData.length){
	        ord=myData[i+1][0]
            ordstr=GetArcim(ord,HospitalRowId+"@"+queryTypeCode);
            temordstr=(ordstr.split("@"))[0].split("^");
            nextseq=temordstr[7];
	       if ((nextseq!=orderitem[7]))
	       {
		     var oeordnum=1
			 PrintComm.PrintLineWard();
		   }
		   else {
			     //PrintComm.PrintLineWard();			     
		     }
           }
            else{
			    PrintComm.PrintLineWard();
	            oeordnum=oeordnum+1
           }
        //}
        if ((i+1)==myData.length){
			 //PrintComm.PrintLineWard();	
			 PrintComm.PrintLine(0,PrintComm.PY-50,1,PrintComm.LineLong);		     
	        }
	 }
   if (PrintNum>0){ 
   PrintComm.PrintEnd();
   }
   printCollectData=printCollectData.join("^")
   if (printCollectData.length>0){
     SetPrintFlag(printCollectData);
    }
    self.location.reload();
}
function PrintBedCard()
{
	var objPrintbut=document.getElementById("bedBtn");
    if (objPrintbut) objPrintbut.style.display="none";
	//var chkSelPrint=document.getElementById('chkSelPrint').checked;
	myData=[];
	//if (chkSelPrint==true) resStr=GetCheckData();
	//else resStr=QueryPrintData();
	resStr=QueryPrintData();
	if (resStr!="0"){alert(resStr); return;}
	var GetVarType=document.getElementById("GetVarType");
	var str=cspRunServerMethod(GetVarType.value,queryTypeCode,HospitalRowId);
	var tmpList=str.split("^");
	var typeDesc=tmpList[0];fileName=tmpList[1];patPrint=tmpList[2];framePrint=tmpList[3]
	var fileName="PrintBedCard.xls"
	//var chkSelPrint=document.getElementById('chkSelPrint').checked;
	//if (chkSelPrint==true)
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
	if (myData.length<1)
	{
		alert(t['alert:queryFirst']);
		EnableQuery();
		if (objPrintbut) objPrintbut.style.display="block";
		return false
	}
	EnableQuery();
    var PrintNum=4;
    var cardNo=1
    var ordDate=""
    for (i=0;i<myData.length;i++)
    {
	    //if ((myData[i][1]!="Y")||(chkSelPrint==true))
	    //{
		   var oeoriId=myData[i][0];
		   var PatInfo=document.getElementById("PatInfo").value;
		   var str=cspRunServerMethod(PatInfo,oeoriId);
		   var Pat=str.split("^");
		   if ((PrePatName!=Pat[4])||(PrePatName==""))
		   {
			   if ((PrePatName!=Pat[4])&&(PrePatName!==""))
			   {
						AddTitle(xlsSheet,typeDesc,PrePatName,PrePatBed,PrePatRegNo,PrePatPacWard,PrePatCtLoc,ordDate,cardNo);
				    if(cardNo==1)
				    {
					    cardNo=2
					    PrintNum=22
				    }
				    else
				    {
					    cardNo=1
					    PrintNum=4
				    }
				    if((cardNo==2)||(cardNo==0))
				    {
					    xlsSheet = null;
					    xlsSheet = xlsBook.ActiveSheet;
				    }
					var PrePatName=Pat[4]
					var PrePatBed=Pat[6]
					var PrePatRegNo=Pat[0]
					var PrePatPacWard=Pat[8]
					var PrePatCtLoc=Pat[1]
					PrintNum=PrintNum+1
					ordDate=AddExecData(xlsSheet,oeoriId,PrintNum);
			   }
			   else
			   {
					var PrePatName=Pat[4]
					var PrePatBed=Pat[6]
					var PrePatRegNo=Pat[0]
					var PrePatPacWard=Pat[8]
					var PrePatCtLoc=Pat[1]
					PrintNum=PrintNum+1
					if(PrintNum==17)
					{
						AddTitle(xlsSheet,typeDesc,PrePatName,PrePatBed,PrePatRegNo,PrePatPacWard,PrePatCtLoc,ordDate,cardNo);
						PrintNum=23
						if(cardNo==2)
						{
							cardNo=1
						}
						else
							{
								cardNo=2
							}
						//ordDate=AddExecData(xlsSheet,oeoriId,PrintNum);
					}
					if(PrintNum==35)
					{
						AddTitle(xlsSheet,typeDesc,PrePatName,PrePatBed,PrePatRegNo,PrePatPacWard,PrePatCtLoc,ordDate,cardNo);
						PrintNum=5
						if(cardNo==2)
						{
							cardNo=1
						}
						else
							{
								cardNo=2
							}
						//ordDate=AddExecData(xlsSheet,oeoriId,PrintNum);
					}
					ordDate=AddExecData(xlsSheet,oeoriId,PrintNum);
			   }
		   }
		   else
		   {
				PrintNum=PrintNum+1
					if(PrintNum==17)
					{
						AddTitle(xlsSheet,typeDesc,PrePatName,PrePatBed,PrePatRegNo,PrePatPacWard,PrePatCtLoc,ordDate,cardNo);
						PrintNum=23
						if(cardNo==2)
						{
							cardNo=1
						}
						else
							{
								cardNo=2
							}
						//ordDate=AddExecData(xlsSheet,oeoriId,PrintNum);
					}
					if(PrintNum==35)
					{
						AddTitle(xlsSheet,typeDesc,PrePatName,PrePatBed,PrePatRegNo,PrePatPacWard,PrePatCtLoc,ordDate,cardNo);
						if(cardNo==2)
						{
							cardNo=1
						}
						else
							{
								cardNo=2
							}
						PrintNum=5
						//ordDate=AddExecData(xlsSheet,oeoriId,PrintNum);
					}
					ordDate=AddExecData(xlsSheet,oeoriId,PrintNum);
		   }
		 }
	//}
	if(cardNo==1) cardNo=0
	AddTitle(xlsSheet,typeDesc,PrePatName,PrePatBed,PrePatRegNo,PrePatPacWard,PrePatCtLoc,ordDate,cardNo);
	xlsSheet = null;
	xlsBook.Close(savechanges=false);
	xlsBook = null;
	xlsExcel.Visible =false
	xlsExcel.Quit();
	if (objPrintbut) objPrintbut.style.display="block";
}
function AddTitle(xlsSheet,typeDesc,PrePatName,PrePatBed,PrePatRegNo,PrePatPacWard,PrePatCtLoc,ordDate,cardNo)
{
	if((cardNo==2)||(cardNo==0))
	{
		if(cardNo==0)
		{
			xlsSheet.cells(1,1)=typeDesc
			xlsSheet.cells(2,1)="科室:"+PrePatCtLoc+"  病区:"+PrePatPacWard+"  日期:"+ordDate
			xlsSheet.cells(3,1)="住院号:"+PrePatRegNo+"  姓名:"+PrePatName+"  床号:"+PrePatBed
			xlsSheet.cells(4,1)="药品名称"
			xlsSheet.cells(4,2)="频次"
			xlsSheet.cells(4,3)="执行时间"
			xlsSheet.cells(4,4)="签字"
			xlsSheet.cells(17,1)="病人签字:__________     "
		}
		else
			{
			xlsSheet.cells(19,1)=typeDesc
			xlsSheet.cells(20,1)="科室:"+PrePatCtLoc+"  病区:"+PrePatPacWard+"  日期:"+ordDate
			xlsSheet.cells(21,1)="住院号:"+PrePatRegNo+"  姓名:"+PrePatName+"  床号:"+PrePatBed
			xlsSheet.cells(22,1)="药品名称"
			xlsSheet.cells(22,2)="频次"
			xlsSheet.cells(22,3)="执行时间"
			xlsSheet.cells(22,4)="签字"
			xlsSheet.cells(35,1)="病人签字:__________    "
			}

	  xlsSheet.Range(xlsSheet.Cells(19, 1), xlsSheet.Cells(35,4)).Borders(1).LineStyle=-4142;
		xlsSheet.Range(xlsSheet.Cells(19, 1), xlsSheet.Cells(35,4)).Borders(2).LineStyle=-4142;
		xlsSheet.Range(xlsSheet.Cells(18, 1), xlsSheet.Cells(35,4)).Borders(3).LineStyle=-4142;
		xlsSheet.Range(xlsSheet.Cells(18, 1), xlsSheet.Cells(35,4)).Borders(4).LineStyle=-4142;
		if(cardNo==2)
		{
		  xlsSheet.Range(xlsSheet.Cells(19, 1), xlsSheet.Cells(35,4)).Borders(1).LineStyle=1;
			xlsSheet.Range(xlsSheet.Cells(19, 1), xlsSheet.Cells(35,4)).Borders(2).LineStyle=1;
			xlsSheet.Range(xlsSheet.Cells(18, 1), xlsSheet.Cells(35,4)).Borders(3).LineStyle=1;
			xlsSheet.Range(xlsSheet.Cells(18, 1), xlsSheet.Cells(35,4)).Borders(4).LineStyle=1;
		}
		//ClearGrid(xlsSheet)
	}
	else
	{
			xlsSheet.cells(1,1)=typeDesc
			xlsSheet.cells(2,1)="科室:"+PrePatCtLoc+"  病区:"+PrePatPacWard+"  日期:"+ordDate
			xlsSheet.cells(3,1)="住院号:"+PrePatRegNo+"  姓名:"+PrePatName+"  床号:"+PrePatBed
			xlsSheet.cells(4,1)="药品名称"
			xlsSheet.cells(4,2)="频次"
			xlsSheet.cells(4,3)="执行时间"
			xlsSheet.cells(4,4)="签字"
			xlsSheet.cells(17,1)="病人签字:__________     "
		
		/*xlsSheet.cells(19,1)=typeDesc
		xlsSheet.cells(20,1)="科室:"+PrePatCtLoc+"  病区:"+PrePatPacWard+"  日期:"+ordDate
		xlsSheet.cells(21,1)="住院号:"+PrePatRegNo+"  姓名:"+PrePatName+"  床号:"+PrePatBed
		xlsSheet.cells(22,1)="药品名称"
		xlsSheet.cells(22,2)="频次"
		xlsSheet.cells(22,3)="执行时间"
		xlsSheet.cells(22,4)="签字"
		xlsSheet.cells(35,1)="病人签字:__________    "*/
	  //xlsSheet.Range(xlsSheet.Cells(19, 1), xlsSheet.Cells(35,4)).Borders(1).LineStyle=1;
		//xlsSheet.Range(xlsSheet.Cells(19, 1), xlsSheet.Cells(35,4)).Borders(2).LineStyle=1;
		//xlsSheet.Range(xlsSheet.Cells(18, 1), xlsSheet.Cells(35,4)).Borders(3).LineStyle=1;
		//xlsSheet.Range(xlsSheet.Cells(18, 1), xlsSheet.Cells(35,4)).Borders(4).LineStyle=1;
	  xlsSheet.Range(xlsSheet.Cells(19, 1), xlsSheet.Cells(35,4)).Borders(1).LineStyle=-4142;
		xlsSheet.Range(xlsSheet.Cells(19, 1), xlsSheet.Cells(35,4)).Borders(2).LineStyle=-4142;
		xlsSheet.Range(xlsSheet.Cells(18, 1), xlsSheet.Cells(35,4)).Borders(3).LineStyle=-4142;
		xlsSheet.Range(xlsSheet.Cells(18, 1), xlsSheet.Cells(35,4)).Borders(4).LineStyle=-4142;
		//AddGrid(xlsSheet)
	}
	if((cardNo==2)||(cardNo==0))
	{
		xlsSheet.PrintOut(1,1,1,false,"ZHIXINGDAN",false,false)
		xlsSheet.Range("A1:D35").Value=""
	}
}
function AddExecData(xlsSheet,oeoriId,PrintNum)
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
		var phcfrCode=ordInfo[3]
	} 
	else
	{
		var ordDate=""
		var ordTime=""
		var arcimDesc=""
	}
	xlsSheet.cells(PrintNum,1)=arcimDesc
	xlsSheet.cells(PrintNum,2)=phcfrCode
	return ordDate
}
function AddGrid(xlsSheet)
{
    xlsSheet.Range(xlsSheet.Cells(19, 1), xlsSheet.Cells(35,4)).Borders(1).LineStyle=1;
	xlsSheet.Range(xlsSheet.Cells(19, 1), xlsSheet.Cells(35,4)).Borders(2).LineStyle=1;
	xlsSheet.Range(xlsSheet.Cells(19, 1), xlsSheet.Cells(35,4)).Borders(3).LineStyle=1;
	xlsSheet.Range(xlsSheet.Cells(19, 1), xlsSheet.Cells(35,4)).Borders(4).LineStyle=1;
}
function ClearGrid(xlsSheet)
{
    xlsSheet.Range(xlsSheet.Cells(19, 1), xlsSheet.Cells(35,4)).Borders(1).LineStyle=-4142;
	xlsSheet.Range(xlsSheet.Cells(19, 1), xlsSheet.Cells(35,4)).Borders(2).LineStyle=-4142;
	xlsSheet.Range(xlsSheet.Cells(19, 1), xlsSheet.Cells(35,4)).Borders(3).LineStyle=-4142;
	xlsSheet.Range(xlsSheet.Cells(19, 1), xlsSheet.Cells(35,4)).Borders(4).LineStyle=-4142;
}

function PrintExecSheet() // + wxl 090309
{
    var chkSelPrint=document.getElementById('chkSelPrint').checked;
    var printList=[],patPrint,framePrint,actRow,resStr,labNoStr="^";
	myData=[];
	//DisableQuery() //ypz 070730
	if (chkSelPrint==true) resStr=GetCheckDataExcel();
	else resStr=QueryPrintDataExcel();
	if (resStr!="0"){alert(resStr); EnableQuery();return;}  //can't print!	
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
   	if (fileName.length<2) { alert(t['alert:noExcelFile']);EnableQuery();return false}
    fileName=path+fileName
  	cols=printDescList.length;
    xlsExcel = new ActiveXObject("Excel.Application");
    xlsBook = xlsExcel.Workbooks.Add(fileName) //;Open(fileName)
    xlsSheet = xlsBook.ActiveSheet; //Worksheets(1)
    xlsTop=1;xlsLeft=1;
    var oeoriIdStr="",preFrameMark=0,maxFrameCols=cols-3;//alert("len="+oeoriIdStr.length)
    titleRows=0, titleCols=0;
    var hospitalName=document.getElementById("hospitalName").value;
    xlsSheet.cells(1,1)=hospitalName+"  "+typeDesc  //ypz 070319
    xlcenter(xlsSheet,1,1,cols);
    mergcell(xlsSheet,1,1,cols);
    FontStyle(xlsSheet,1,1,6,14);
    LeftHeader =""; 
    RightHeader = "" ;LeftFooter ="";CenterFooter = "";RightFooter = "";
    ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter) 
	var PacWard=parent.frames["NurseTop"].document.getElementById("PacWard").value; 
	var wardDesc=PacWard.split("-")
	if (wardDesc[1]!="") wardDesc=wardDesc[1]; 
	var objgetSysDate=document.getElementById("getSysDate");
    if (objgetSysDate) 
    {
	    var getSysDate=objgetSysDate.value;
	    tempDate=getSysDate.split("/");
	    getSysData=tempDate[2]+"-"+tempDate[1]+"-"+tempDate[0];
    }
    //var objgetSysTime=document.getElementById("getSysTime");
    //if ((objgetSysDate)&&(objgetSysTime)) var PrintDateTime=getSysData+" "+objgetSysTime.value;
	//LeftHeader="病区:"+wardDesc+"     打印时间:"+PrintDateTime+"     打印人:"+session['LOGON.USERNAME'];
	LeftHeader=t['val:wardDesc']+wardDesc+"     "+t['val:PrintDateTime']+getSysData+"     "+t['val:PrintUser']+session['LOGON.USERNAME'];	
	xlsSheet.cells(2,1)=LeftHeader;
	mergcell(xlsSheet,2,1,cols);
	FontStyle(xlsSheet,2,1,cols,12);
    
	for (j=0;j<cols;j++) {xlsSheet.cells(3,j+1)=printDescList[j];}
	FontStyle(xlsSheet,3,1,cols,12);
	actRow=4;

    var tmpPrintList=new Array();
	var newPrintList=new Array();
	if (queryTypeCode.indexOf("JYD")>-1) //ypz 061116
	{  	
		var sortCol=GetArrayIndex(varList,"reclocDesc");
	   	SortListByCol(myData,sortCol,true);
	}
	if (queryTypeCode.indexOf("czczzld")>-1) //ypz 061116
	{  	
		//var sortCol=GetArrayIndex(varList,"arcimDesc");
	   	//SortListByCol(myData,sortCol,true);
	   	var arcimDescInd=GetArrayIndex(varList,"arcimDesc");
	   	var freqInd=GetArrayIndex(varList,"phcfrCode");
	   	SortListByTwoCol(myData,arcimDescInd,freqInd,true,true);
	}
	if (myData.length<1) {alert(t['alert:queryFirst']);EnableQuery();return false}
    var tmpPrintList=[],varInd,tmpVal,newPrintList=[];
    for (i=0;i<myData.length;i++)
    {
       	if ((myData[i][0]!="Y")||(chkSelPrint==true))
        {   
            if (oeoriIdStr.length==0){oeoriIdStr=myData[i][oeoriIdInd]}
            else{oeoriIdStr=oeoriIdStr+"^"+myData[i][oeoriIdInd]}
            //printList[printList.length]=myData[i];
            tmpPrintList=[];
			for (j=0;j<printVarList.length;j++){
			varInd=GetArrayIndex(varList,printVarList[j]);
			tmpVal="";
			if (varInd>-1){tmpVal=myData[i][varInd]}
			tmpPrintList[tmpPrintList.length]=tmpVal;
			}
			newPrintList[newPrintList.length]=tmpPrintList;
        }
    }
    var str=CopyToExcel(newPrintList,xlsSheet,0,newPrintList.length-1,0,cols-1,actRow,xlsLeft)
	var tem=str.split("^");
	actRow=eval(tem[0]);
	var p=tem[1];
	if (framePrint=="Y"){
		gridlist(xlsSheet,actRow,actRow-newPrintList.length-p,1,cols);
	}
	gridlisttwocol(xlsSheet,actRow-newPrintList.length-p+1,actRow);
    if ((oeoriIdStr.length>0)&(chkSelPrint==false))
    {
      SetPrintFlag(oeoriIdStr)
    }
    xlsSheet.printout
	//xlsExcel.Visible = true;
	//xlsSheet.PrintPreview ;
    xlsSheet = null;
    xlsBook.Close(savechanges=false);
    xlsBook = null;
    xlsExcel.Quit();
    xlsExcel = null;
}
