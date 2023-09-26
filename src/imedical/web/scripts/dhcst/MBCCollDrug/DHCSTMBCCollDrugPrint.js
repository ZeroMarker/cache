// /名称: 煎药室打印
// /描述: 煎药室打印
// /编写者：wyx
// /编写日期: 2014.10.21
/*
 * creator:wyx,2014.10.21
 * description:打印煎药证
 * params: prescno:处方号
 * return:
 * */
function PrintJYZ(prescno){
	
	if(prescno==null || prescno==''){
		return;
	}
	var flagstr=GetPrescType(prescno);	
	if(flagstr==null || flagstr==""){
		return;
	}
	var retstr=flagstr.split("^")
	if (retstr[0]==0)
	{PrintOutJYZ(retstr[1]);}
	else 
	{PrintInJYZ(prescno);}

}

/*
 * creator:wyx,2014.10.21
 * description:判断处方类型(住院还是门诊)
 * params: ingr:入库主表id
 * return:
 * */
function GetPrescType(prescno){
	
	if(prescno==null || prescno==''){
		return;
	}
	
	var url='dhcst.mbccolldrugaction.csp?action=GetPrescType&Prescno='+prescno;
	var responseText=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(responseText);	
	var retflag=jsonData.info;
	return retflag;
}
function PrintOutJYZ(phdrowid)
{
        var totalmoney=0;
	    var MyList="" ;
        var retval=GetPrescOutInfo(phdrowid)
        if (retval==""){return}
	    var tmparr=retval.split("!!")
	    var patinfo=tmparr[0]
	    var ordinfo=tmparr[1]
	    var patarr=patinfo.split("^")
	    var Quefac=patarr[26]
	    var Queinst=patarr[25]
	    var Queqty=patarr[27]
	    var Quenotes=patarr[30]
	    var PyName=patarr[6];
        var FyName=patarr[7];
        var FyDate=patarr[8];
        var PrescNo=patarr[15];
        var PatNo=patarr[0];
        var Patloc=patarr[16];
        var PatientName=patarr[1];
        var PatientAge=patarr[2];
        var PatientSex=patarr[3];
        var Doctor=patarr[24];
        var Patcall=patarr[18];
        var Pataddress=patarr[19];
        var Orddate=patarr[31];
        var Quecook=patarr[20];
        var Diag=patarr[4];
	    var ordarr=ordinfo.split("@")
	    var OrdRows=ordarr.length
	    var jzcnt=patarr[32]   //煎煮次数
	    var jztime=patarr[33]  //煎煮时间
	    var jzstr=jzcnt
	    if (jztime!="") {jzstr=jzstr+","+jztime}
	    var qzfre=patarr[34]  //取汁量
	    var qzfre="共取汁"+qzfre+"毫升"
        for (i=0;i<OrdRows;i++)
        {
	       
	        var ordstr=ordarr[i];
	        var SStr=ordstr.split("^")
	        var money=SStr[8]
	         totalmoney=totalmoney+parseFloat(money);//金额
	    
       }
	   //var yfpc="共"+Quefac+"剂"+" "+"用法:"+Queinst+"  一次用量:"+Queqty     	
      	
      	var MyPara="";
      	var MyList=""
      
      //DHCP_GetXMLConfig("InvPrintEncrypt","DHCPharmacyOutJYZ")    //InvPrintEncrypt是读取xml的方法调用
	    MyPara=MyPara+"PatName"+String.fromCharCode(2)+PatientName;
	    MyPara=MyPara+"^Sex"+String.fromCharCode(2)+PatientSex;
	    MyPara=MyPara+"^Age"+String.fromCharCode(2)+PatientAge; 
	    MyPara=MyPara+"^Amout"+String.fromCharCode(2)+totalmoney.toFixed(2);
	    MyPara=MyPara+"^PatNo"+String.fromCharCode(2)+PatNo;

	    MyPara=MyPara+"^FsQty"+String.fromCharCode(2)+Quefac;
	    if(Queinst.indexOf("外")>=0)
	    {MyPara=MyPara+"^WY"+String.fromCharCode(2)+"√";}
	    else
	    {MyPara=MyPara+"^KF"+String.fromCharCode(2)+"√";}	    
	    MyPara=MyPara+"^Remark"+String.fromCharCode(2)+jzstr;	   
	    MyPara=MyPara+"^PrescNo"+String.fromCharCode(2)+"*"+PrescNo+"*";
	    MyPara=MyPara+"^PrescNo2"+String.fromCharCode(2)+PrescNo; 	
       DHCP_GetXMLConfig("DHCPharmacyOutJYZ");
	   DHCP_PrintFun(MyPara,MyList);
	
}
//门诊处方信息
function GetPrescOutInfo(phdrowid){
		
	var url='dhcst.mbccolldrugaction.csp?action=GetPrescOutInfo&Phdrowid='+phdrowid;
	var responseText=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(responseText);	
	var retstr=jsonData.info;

	return retstr;
}
function PrintInJYZ(prescno)
{
 	
      var retval=GetPrescInInfo(prescno)
      if (retval=="")
      {
	      return;
	      }	
      var tmparr=retval.split("^")
      var paname=tmparr[0]	
      var fsqty=tmparr[1]
      var ward=tmparr[2]
      var bed=tmparr[3]
      var medno=tmparr[4]
      var YyDate=tmparr[5]
      var dreat=tmparr[6]
      var instruc=tmparr[7]
 	var notes=tmparr[8]
 	var jzcnt=tmparr[9]   //煎煮次数
	var jztime=tmparr[10]  //煎煮时间
	var jzstr=jzcnt
	if (jztime!="") {jzstr=jzstr+","+jztime}
	var qzfre=tmparr[11]  //取汁量
	var qzfre="共取汁"+qzfre+"毫升"
 	var MyPara="";
      	var MyList=""
      
 	 //DHCP_GetXMLConfig("InvPrintEncrypt","DHCPharmacyJYZ")    //InvPrintEncrypt是读取xml的方法调用
 	  	
	    MyPara=MyPara+"PatName"+String.fromCharCode(2)+paname;
	    MyPara=MyPara+"^FsQty"+String.fromCharCode(2)+fsqty;
	    MyPara=MyPara+"^PatWard"+String.fromCharCode(2)+ward;
	    MyPara=MyPara+"^BedNo"+String.fromCharCode(2)+bed;
	    MyPara=MyPara+"^MedNo"+String.fromCharCode(2)+medno;
	    MyPara=MyPara+"^YyTime"+String.fromCharCode(2)+YyDate;
	    if (dreat=="Y")
	    { MyPara=MyPara+"^DYES"+String.fromCharCode(2)+"√";}
	    else
	    {MyPara=MyPara+"^DNO"+String.fromCharCode(2)+"√";}
	    
	    if(instruc.indexOf("外")>=0)
	    { MyPara=MyPara+"^WY"+String.fromCharCode(2)+"√";}
	    else
	    { MyPara=MyPara+"^KF"+String.fromCharCode(2)+"√";}	    
	    //MyPara=MyPara+"^Remark"+String.fromCharCode(2)+notes;
	    MyPara=MyPara+"^Remark"+String.fromCharCode(2)+jzstr; 
	    //MyPara=MyPara+"^Yf"+String.fromCharCode(2)+jyway.substring(0,20);
	    //MyPara=MyPara+"^Yf1"+String.fromCharCode(2)+jyway.substring(21,jyway.length);	   
	    MyPara=MyPara+"^PrescNo"+String.fromCharCode(2)+"*"+prescno+"*";
	    MyPara=MyPara+"^PrescNo2"+String.fromCharCode(2)+prescno; 
	    MyPara=MyPara+"^Remark2"+String.fromCharCode(2)+qzfre;
	     
	    //var myobj=document.getElementById("ClsBillPrint");
		//DHCP_PrintFun(myobj,MyPara,"");	
	       DHCP_GetXMLConfig("DHCPharmacyJYZ");
	     DHCP_PrintFun(MyPara,MyList);	
	
}
function GetPrescInInfo(prescno){
		
	var url='dhcst.mbccolldrugaction.csp?action=GetPrescInInfo&Prescno='+prescno;
	var responseText=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(responseText);	
	var retstr=jsonData.info;
	return retstr;
}

/*
 * creator:wyx 2014-10-23
 * description:打印煎药登记表（润乾）
 * params: 
 * return:
 * */
function PrintJYReg(locid,gUserId,Ddate,Dtime,Edate,Etime,Prescno,State,gUserName){
	
       
       
	//if (printtype==1) {
	//直接打印
	//alert(locid+","+gUserId+","+Ddate+","+Dtime+","+Edate+","+Etime+","+Prescno+","+State)
	fileName="{DHCST_MBCJYTOTAL_Common.raq(StartDate="+Ddate+";EndDate="+Edate+";StartTime="+Dtime+";EndTime="+Etime+";AUser="+gUserId+";Prescno="+Prescno+";locid="+locid+";State="+State+";gUserName="+gUserName+")}";
	DHCCPM_RQDirectPrint(fileName);
	//}
	//else {
	//预览打印	
	//fileName="DHCST_StockRec_Common.raq&Parref="+ingr+"&Vendor="+vendor+"&IngrNo="+ingrNo+"&IngrDate="+ingrDate+"&IngrLoc="+ingrLoc+"&CreateUser="+CreateUser+"&PurUser="+PurUser
	//DHCCPM_RQPrint(fileName)	
	//}
}
/*
 * creator:wyx 2014-11-03
 * description:打印煎药住院表（润乾）
 * params: 
 * return:
 * */
function PrintJYInpha(locid,gUserId,Ddate,Dtime,Edate,Etime,Prescno,State){
	
       
       
	//if (printtype==1) {
	//直接打印
	//alert(locid+","+gUserId+","+Ddate+","+Dtime+","+Edate+","+Etime+","+Prescno+","+State)
	fileName="{DHCST_MBCJYINPHATOTAL_Common.raq(StartDate="+Ddate+";StartTime="+Dtime+";EndDate="+Edate+";EndTime="+Etime+";AUser="+gUserId+";PatLoc="+locid+";Prescno="+Prescno+";State="+State+";Type="+"I"+")}";

	DHCCPM_RQDirectPrint(fileName);
	//}
	//else {
	//预览打印	
	//fileName="DHCST_StockRec_Common.raq&Parref="+ingr+"&Vendor="+vendor+"&IngrNo="+ingrNo+"&IngrDate="+ingrDate+"&IngrLoc="+ingrLoc+"&CreateUser="+CreateUser+"&PurUser="+PurUser
	//DHCCPM_RQPrint(fileName)	
	//}
}

