function PrintRp(queryTypeCode,typ,RpDes)
{
	var PrintComm,i;
    PrintComm= new ActiveXObject("PrintBar.PrintCls");//TestAx.CLSMAIN
	//PrintComm.PrintName="tiaoma";//printer name
	//var ordPrintInfo=document.getElementById("OrdPrintInfo").value;
    var oeoriIdStr="";
    if (typ=="select"){
    chkSelPrint=true;
    }
    else{
    chkSelPrint=false;
    }
    var PatInfo=document.getElementById("PatInfo").value;
    var GetHead=document.getElementById("GetHead").value;
    var Head;
    Head=cspRunServerMethod(GetHead,queryTypeCode);
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
    var TypeCodeStr="CQSYD^SYD^CQZSD^cqkfyd^ZSD"
	for (i=0;i<myData.length;i++)
    { 
	   if ((myData[i][1]!="Y")||(chkSelPrint==true))
	   {
		PrintNum=PrintNum+1; 
		PrintNum1=PrintNum1+1 
	   if (oeoriIdStr.length==0){oeoriIdStr=myData[i][0]}
       else{oeoriIdStr=oeoriIdStr+"^"+myData[i][0]}
	    var oeoriId=myData[i][0];
	    var str=cspRunServerMethod(PatInfo,oeoriId);
	    
	    var arcdes=GetArcim(oeoriId,queryTypeCode);
	    //s retStr=regNo_"^"_ctlocDesc_"^"_$g(room)_"^"_$g(sex)_"^"_$g(patName)_"^"_$g(safetyNetCardNo)_"^"_$g(bedCode)_"^"_$g(age)_"岁^"_$g(wardDesc)_"^"_homeAddres_"^"_homeTel_"  "_workTel_"  "_handtel
        var RetStr=arcdes.split("@")
        var orderitem=RetStr[0].split("|");
	    Pat=str.split("^");
	    if ((PrePatName!=Pat[4])||(PrePatName==""))
	    {
         if ((PrePatName!=Pat[4])&&(PrePatName!==""))
	      {
		    PrintComm.PrintFoot();
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
        if(oeordnum>1)                               //wkz 080403  S
        {
	        PrintComm.OrdString = "___"+orderitem[0];
        }
        else
        {
	        PrintComm.OrdString = orderitem[0];
        }                                            //wkz 080403   E
        PrintComm.TitVal=RetStr[1];
        PrintComm.SinglNote =orderitem[12];
        //wkz 080104 S
        if(oeordnum<2) phcinDescSortNew=orderitem[3];  ///RetStr[1].split("^")[2].split("|")[2]
		if ((phcinDescSortNew!=phcinDescSort)&(queryTypeCode=="JHD")&(PrintNum1>1)){
			PrintComm.PY=PrintComm.PY+300   
		    PrintComm.PrintLine(PrintComm.PX,PrintComm.PY,1,PrintComm.LineLong);
		    //PrintComm.PrintMethExTime();
		}
		//wkz 080104 E
        PrintComm.PrintItem();
		//wkz 080103 S
		//if ((oeordnum<2)&(RetStr[1].split("^").length>3)) { var phcfrcode=RetStr[1].split("^")[3].split("|")[2]; } 
		//else { var phcfrcode="" }
		var phcfrnum=1
		phcfrnum=orderitem[4];   //Getphcfrnum(phcfrcode)
        phcfrnum=phcfrnum-oeordnum
        if(phcfrnum<0){phcfrnum=0}
        if((oeordnum<2)&(queryTypeCode=="JHD")) phcinDescSort=orderitem[3];    ///RetStr[1].split("^")[2].split("|")[2]
        //wkz 080103 E
        var nextseq;
        var ord;
        var ordstr,temordstr;
        if ((i+1)<myData.length){
	        ord=myData[i+1][0]
            ordstr=GetArcim(ord,queryTypeCode);
            temordstr=ordstr.split("|");
            nextseq=temordstr[7];
	       if ((nextseq!=orderitem[7]))
	       {
		     var oeordnum=1
		     if (TypeCodeStr.indexOf(queryTypeCode)!=-1){    //WKZ 080107  S
			     PrintComm.Notes ="";
			     PrintComm.PrintMethExTime();
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
			    PrintComm.PrintMethExTime();               //wkz 080403	
	            oeordnum=oeordnum+1                        //wkz 080103
           }
        }
        if ((i+1)==myData.length){
	        if (TypeCodeStr.indexOf(queryTypeCode)!=-1){  //WKZ 080107  S
			     PrintComm.Notes ="";
			     PrintComm.PrintMethExTime();
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
   }
   if (PrintNum>0){ 
   PrintComm.PrintEnd();
   }
   if ((oeoriIdStr.length>0)&(typ!="select")){
     SetPrintFlag(oeoriIdStr);
    }
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
	    var str=cspRunServerMethod(getarcim,Ord,chl,queryTypeCode);
	    return str;

}
function PrintSelSYCARD()
 {
	 var retStr=0
   	 var typ=document.getElementById("vartyp").value;
     if ((typ!="SYD")&&(typ!="CQSYD")&&(typ!="CQZSD")&&(typ!="LSZSD")) return;
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
	Bar.PrintName="shuyeka"
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
                //Bar.PhFactor=tem[0].split("!")[0].split("|")[4];
                //Bar.StDateTime=tem[6];
                //Bar.SYName =cardname;
                //Bar.SYTYP = sytyp;
                Bar.SYCWIDTH =7;
                Bar.SYDHEIGHT =8;
                //Bar.PrintSYCARD();
                var InfusionCardnum=eval(tem[0].split("!")[0].split("|")[4]);
                for(var InfCardi=1;InfCardi<InfusionCardnum+1;InfCardi++)
                {
                	Bar.SyNo=InfCardi+"/"+InfusionCardnum
                	Bar.PrintInfusionCard();
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
function PrintSelSYCARD1()
{
    var startDate=parent.frames["NurseTop"].document.getElementById("StartDate").value; 
    var endDate=parent.frames["NurseTop"].document.getElementById("EndDate").value;
    if (GetDate(startDate)!=GetDate(endDate)) {alert(t['alert:sameStartEndDate']);return;};

    if ((queryTypeCode!="SYD")&&(queryTypeCode!="CQSYD")&&(queryTypeCode!="Default")&&(queryTypeCode!="LSD")) return;
    if (queryTypeCode=="SYD"){sytyp=t['val:temp']; }
    if (queryTypeCode=="CQSYD"){sytyp=t['val:long']; }
	//var execDateTime=GetPrintDateTime(0,"-",false);//PrintDateTime=DateDemo(); ypz 060928
    ////var SyCard=document.getElementById("SyCard").value;

    var num=0,printPara="^Y";
    var chkSelPrint=document.getElementById('chkSelPrint').checked;
    myData=[];
	if (chkSelPrint==true) resStr=GetCheckData();
	else resStr=QueryPrintData();
	if (resStr!="0"){alert(resStr); return;}  //can't print!
    var Card,i;
    Card= new ActiveXObject("PrintBar.PrnBar");//TestAx.CLSMAIN
	Card.PrintName="tiaoma";//printer name
	var ordPrintInfo=document.getElementById("OrdPrintInfo").value;
    var oeoriIdStr="";
	for (i=0;i<myData.length;i++)
    {
	   // alert(myData[i])
	    var oeoriId=myData[i][0];
	    //var arcimDesc=myData[i][arcimDescInd];
		//var tmpList=arcimDesc.split("____");
		//if ((tmpList.length<2)){
	       	if (oeoriIdStr.length==0){oeoriIdStr=oeoriId;}
           	else{oeoriIdStr=oeoriIdStr+"^"+oeoriId}
           	var pos;
           	var str=cspRunServerMethod(ordPrintInfo,oeoriId,printPara);//longNewOrdAdd
           	if (str!="")
           	{	//alert(str);  ///continue;
	       		//if (queryTypeCode=="SYD"){
    	       		Card.OrderString=str;
              		Card.SetPrint();
           	   		Card.PrintSycd();
	       		//}
           	}
		//}
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