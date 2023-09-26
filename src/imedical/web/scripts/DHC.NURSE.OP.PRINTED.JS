//lvxin 2013-10-28
DHCCNursePrintComm=document.getElementById("DHCCNursePrintComm")
function PrintTPQ()
{
	var queryTypeCode=document.getElementById('queryTypeCode').value; 
	var objSeatNo=parent.frames["NurseTop"].document.getElementById("SeatNo");
	if (objSeatNo)SeatNo=objSeatNo.value;
    var objtbl=document.getElementById('tDHCNurOPExec');
    var oeoriIdStr="",seqNoStr="";
	for (i=1;i<objtbl.rows.length;i++)
    {
        var check=document.getElementById('seleitemz'+i);
	    var oeoriId=document.getElementById('oeoriIdz'+i).innerText;
	    var seqNo=document.getElementById('tmpSeqNoz'+i).innerText;   
	    var PrintFlag=document.getElementById('tmpPrtFlagz'+i).innerText;
        if (check.checked==true)
	    {           
           	if (oeoriIdStr.length==0){oeoriIdStr=oeoriId;}
           	else{oeoriIdStr=oeoriIdStr+"^"+oeoriId}
           	if (seqNoStr.length==0){seqNoStr=seqNo;}
           	else{seqNoStr=seqNoStr+"^"+seqNo}
	    }
    }
    if(oeoriIdStr=="")
    {
	    alert("请选择医嘱！");
	    return;
	}

	DHCCNursePrintComm.showNurseExcuteSheetPreview(oeoriIdStr,seqNoStr,"T",queryTypeCode,session['WebIP'],"true",1,"NurseOrderOP.xml")	
	if(DHCCNursePrintComm.saveFlag==1)
	{
	SetPrintFlag(oeoriIdStr,"T");
	SavePrintRecord("T",queryTypeCode,oeoriIdStr,session['LOGON.USERID']);
	}
	    //DHCCNursePrintComm.showNurseExcuteSheetPreview(oeoriIdStr,seqNoStr,"T",queryTypeCode,session['WebIP'],"true",1,"NurseOrderOPInfusionLabel.xml") 	
    	
}
function printSYCard()
{
	var queryTypeCode=document.getElementById('queryTypeCode').value; 
	var objSeatNo=parent.frames["NurseTop"].document.getElementById("SeatNo");
    var objtbl=document.getElementById('tDHCNurOPExec');
    var oeoriIdStr="",seqNoStr="";
    var printedId=new Array();
	for (i=1;i<objtbl.rows.length;i++)
    {
        var check=document.getElementById('seleitemz'+i);
	    var oeoriId=document.getElementById('oeoriIdz'+i).innerText;
	    var seqNo=document.getElementById('tmpSeqNoz'+i).innerText;   
	    var PrintFlag=document.getElementById('tmpPrtFlagz'+i).innerText;
	    var orderStrList=oeoriId.split("||");
        if (check.checked==true)
	    {           

	    	if(printedId[orderStrList[0]+"||"+orderStrList[1]])
	    	{
		    	continue;
	    	}
           	if (oeoriIdStr.length==0){oeoriIdStr=oeoriId;}
           	else{oeoriIdStr=oeoriIdStr+"^"+oeoriId}
           	if (seqNoStr.length==0){seqNoStr=seqNo;}
           	else{seqNoStr=seqNoStr+"^"+seqNo}
           	printedId[orderStrList[0]+"||"+orderStrList[1]]=1;
        
	    }
    }
    if(oeoriIdStr=="")
    {
	    alert("请选择医嘱！");
	    return;
	}
    DHCCNursePrintComm.showNurseExcuteSheetPreview(oeoriIdStr,seqNoStr,"S",queryTypeCode,session['WebIP'],"true",1,"NurseOrderOP.xml")
	if(DHCCNursePrintComm.saveFlag==1)
	{
	SetPrintFlag(oeoriIdStr,"S");
	SavePrintRecord("S",queryTypeCode,oeoriIdStr,session['LOGON.USERID']);
	}
    
}
function printNurseSheet()
{
	var queryTypeCode=document.getElementById('queryTypeCode').value; 
	var objSeatNo=parent.frames["NurseTop"].document.getElementById("SeatNo");
    var objtbl=document.getElementById('tDHCNurOPExec');
    var oeoriIdStr="",seqNoStr="";
    var printedId=new Array();
	for (i=1;i<objtbl.rows.length;i++)
    {
        var check=document.getElementById('seleitemz'+i);
	    var oeoriId=document.getElementById('oeoriIdz'+i).innerText;
	    var seqNo=document.getElementById('tmpSeqNoz'+i).innerText;   
	    var PrintFlag=document.getElementById('tmpPrtFlagz'+i).innerText;
	    var orderStrList=oeoriId.split("||");
        if (check.checked==true)
	    {           
	    	if(printedId[orderStrList[0]+"||"+orderStrList[1]])
	    	{
		    	continue;
	    	}
           	if (oeoriIdStr.length==0){oeoriIdStr=oeoriId;}
           	else{oeoriIdStr=oeoriIdStr+"^"+oeoriId}
           	if (seqNoStr.length==0){seqNoStr=seqNo;}
           	else{seqNoStr=seqNoStr+"^"+seqNo}
           	printedId[orderStrList[0]+"||"+orderStrList[1]]=1;
	    }
    }
    if(oeoriIdStr=="")
    {
	    alert("请选择医嘱！");
	    return;
	}
		
	DHCCNursePrintComm.showNurseExcuteSheetPreview(oeoriIdStr,seqNoStr,"PAT",queryTypeCode,session['WebIP'],"true",1,"NurseOrder.xml")	
    if(DHCCNursePrintComm.saveFlag==1)
	{
	 SetPrintFlag(oeoriIdStr,"Y");
	 SavePrintRecord("PAT",queryTypeCode,oeoriIdStr,session['LOGON.USERID'])
	}
	    //DHCCNursePrintComm.showNurseExcuteSheetPreview(oeoriIdStr,seqNoStr,"T",queryTypeCode,session['WebIP'],"true",1,"NurseOrderOP.xml")	
    
}
function PrintBar()  //lVXIN 2013-10-29
{	
	var queryTypeCode=document.getElementById('queryTypeCode').value;
	var objtbl=document.getElementById('tDHCNurOPExec');
	var labNoStr="" ,oeorIdStr="";
	for (i=1;i<objtbl.rows.length;i++)
    {
	    var check=document.getElementById('seleitemz'+i);
	    var labNo=document.getElementById('labNoz'+i).innerText; 
	    if(labNo==""){
	    	alert("标本号为空请联系网络中心")
	    	return
	    }
	    var oeoriId=document.getElementById('oeoriIdz'+i).innerText;
	    if (check.checked==true)
	    {      
	    	if(labNoStr=="")
	   	    {
		    	labNoStr=labNo;
	        }
	   	    else
	        {
		       labNoStr=labNoStr+"^"+labNo;
	        }
	        if(oeorIdStr=="")
	       {
		       oeorIdStr=oeoriId;
	       }else
	            {
		          oeorIdStr=oeorIdStr+"^"+oeoriId;
	            }
	    }   
    }
  var sortStr=sortByLabNo(oeorIdStr,labNoStr)
  var sortStrArray=sortStr.split("@");
  oeorIdStr=sortStrArray[0];
  labNoStr=sortStrArray[1];
  DHCCNursePrintComm.showNurseExcuteSheetPreview(oeorIdStr,labNoStr,"P",queryTypeCode,session['WebIP'],"true",1,"NurseOrderOP.xml")	
  if(DHCCNursePrintComm.saveFlag==1)
   {
    
	 SetPrintFlag(oeorIdStr,"P");
	 SavePrintRecord("P",queryTypeCode,oeorIdStr,session['LOGON.USERID'])
	}
}
function sortByLabNo(oeorIdStr,labNoStr)
{
	var oeordIdArray=oeorIdStr.split("^")
	var labNoArray=labNoStr.split("^")
	var tmpLabNo=""
	var tmpOeordId="";
	var index="";
    var tmpLabNoArray=[];
	var tmpOrderIdArray=[];
    var tmpCollectArray=[];
	for(var i=0;i<oeordIdArray.length;i++)
	{
        if(!tmpCollectArray[i])
	 	{
			tmpOrderIdArray[tmpOrderIdArray.length]=oeordIdArray[i]
			tmpLabNoArray[tmpLabNoArray.length]=labNoArray[i]
		}
		else
		{
			continue;
		}
		for(var j=i+1;j<oeordIdArray.length;j++)
		{
			if((labNoArray[i]==labNoArray[j])&&(!tmpCollectArray[j]))
			{
				tmpOrderIdArray[tmpOrderIdArray.length]=oeordIdArray[j]
				tmpLabNoArray[tmpLabNoArray.length]=labNoArray[j]
				tmpCollectArray[j]=1
			}
		}
	}
	return tmpOrderIdArray.join("^")+"@"+tmpLabNoArray.join("^")
}
function DOCOnKeyDown()
{
	if ((event.keyCode==119)){
		parent.window.frames["NurseTop"].ReadCard_Click();
	}
}
function SetPrintFlag(oeoriIdStr,printFlag)
{  

   
    if (oeoriIdStr!="")
    {
        if(!printFlag)
        	{
	        	printFlag="Y"
        	}
         var Wardid=tkMakeServerCall("web.PACWard","GetWardFromLoc",session['LOGON.CTLOCID'])  //
	     resStr=tkMakeServerCall("web.DHCNurCom","SetPrintFlagNew",Wardid,session['LOGON.USERID'],queryTypeCode,oeoriIdStr,printFlag);

    }
}
function SavePrintRecord(printType,queryTypeCode,OrderStr,UserId)
	{
	    var ModelName;
		if (printType == "P")
		{
		ModelName="DHCNurOPExecP";  ///模块代码，DHC_EventModel表中Code
		}
		else if(printType == "PAT")
		{
		ModelName="DHCNurOPExecPAT";
		}
		else if(printType == "S")
		{
		ModelName="DHCNurOPExecS"; 
		}
		else if(printType == "T")
		{
		ModelName="DHCNurOPExecT"; 
		}
		var SecretCode=""
		var ret=tkMakeServerCall("web.DHCCLCom","SaveRecord",ModelName,OrderStr,printType,queryTypeCode,SecretCode,UserId)
		//alert(ret)
	}
document.onkeydown=DOCOnKeyDown;

