var Adm=document.getElementById("Adm").value;
var selrow;
var BPRNSTR;
BPRNSTR="";
var ComDep=parent.frames["RPtop"].document.getElementById("OrdDep")
var DepSelIndex=ComDep.selectedIndex;
var tem=ComDep.options[DepSelIndex].text.split("|");
var Dep=tem[1];
var DepNo=ComDep.options[DepSelIndex].value;
var NurOrd=document.getElementById("NurOrd").value;
var DocOrd=document.getElementById("DocOrd").value;
function BodyLoadHandler()
{
	var PrintCurr=document.getElementById('BtPrintCurr');
	PrintCurr.style.display="none";
	var Print=document.getElementById('Print');
	Print.style.display="none";
	var PageBtn=document.getElementById('SchPage');
	if (PageBtn) PageBtn.onclick=PageBtn_Click;
    var objtbl=document.getElementById('tDHCTEMPOERPRINT');
    if (objtbl) objtbl.onclick=Table_onclick;
	var btnsure=document.getElementById('btnsure');
	if (btnsure) btnsure.onclick=surecheck;
	var i=0;
    for (i=1;i<objtbl.rows.length;i++)
	{
	   var chek=document.getElementById("selz"+i);
	   //var ordstat=document.getElementById("DisposNurz"+i).innerText;
	   var ordstatObj=document.getElementById("DisposNurz"+i)
	   if(ordstatObj) var ordstat=ordstatObj.innerText;
	   else  var ordstat=""
	   var stat=ordstat.split("_");
	   var eSrc=objtbl.rows[i];
	   var RowObj=getRow(eSrc);
	   if (stat[1]=="1")
	   {
	   chek.checked=true;
       RowObj.className="LackOfFee";//green //arrange
	   }
	   var item=document.getElementById("OrdNoz"+i);
	   item.innerText=i;
       var item2=document.getElementById("ARCIMDescz"+i).innerText;
	   //alert (RowObj.rowIndex);
	   var flag,flag1;
	   flag=item2.indexOf("取消执行");
	   flag1=item2.indexOf("撤销医嘱");
	   var skinY,skinN;
	   skinY=item2.indexOf("(阳性)");
	   skinN=item2.indexOf("(阴性)");
	   if (skinY!=-1){
		  RowObj.className="SkinTest"
		   }
	   if (skinN!=-1){
		  RowObj.className="Green"
		   }
	   if ((flag!=-1)||(flag1!=-1)){
	    RowObj.className="Discontinue";
	   }
	   
	   var r, re;                     //
       re = new RegExp(t["01"]);  //
       r = item2.match(re);       //
       if (r==t["01"])
       {
	       RowObj.className="LackOfFee";
	   }
      //alert(r);
	}

    var obj=document.getElementById("Print");
    if (obj) {obj.onclick=PrintClick;}
    var obj=document.getElementById("RePrint");
    if (obj) {obj.onclick=RePrintClick;}
    var obj=document.getElementById("BtPrintCurr");
    if (obj) {obj.onclick=PrintCurrClick;}
    obj=document.getElementById("UpdateDate");
    if (obj) {obj.onclick=UpdateDateClick;}
    dsptxt();
    /*
    if (Adm!=""){
    var Res,PageStr,StPage,StRow;
    var FetchPageRow=document.getElementById("schtystrow").value;
    var CurStat=document.getElementById("CurStatus");
    Res=cspRunServerMethod(FetchPageRow,"lsord",Adm,Dep,DepNo)
    if (Res!=""){
    PageStr=Res.split("|");
    StPage=PageStr[0];
    StRow=PageStr[1];
    StRow=StRow-1;
    CurStat.value=t['val:xprn']+StPage+t['val:page']+StRow+t['val:Row'];
    }
    }
    */
    var CurStat=document.getElementById("CurStatus");
     var Res,StPage,StRow;
    Res = tkMakeServerCall("Nur.DHCORDPRINT", "getPLprintinfo",  Adm, DepNo, "LSORD" );
    var PagStr="";
  
    if (Res!="")
    {
       PagStr=Res.split("^");
    }
 
    if (PagStr!="")
    {
       StPage=eval(PagStr[1])+1;
       StRow=PagStr[2];
       CurStat.value=t['val:xprn']+StPage+t['val:page']+StRow+t['val:Row'];
    }
   // PrintCurStat();
}
function PrintCurStat()
{

}

 function Table_onclick()
 {
  var selrow=DHCWeb_GetRowIdx(window);
  if((!selrow)||(selrow<1)) return;
  var objtbl=document.getElementById('tDHCTEMPOERPRINT');
  var RowObj;
  var eSrc=objtbl.rows[selrow];
  RowObj=getRow(eSrc);
  var itemsel=document.getElementById("selz"+selrow);
	    if (itemsel.checked==true)
	    {
		// var eSrc=objtbl.rows[selrow];
	    // RowObj=getRow(eSrc);
         RowObj.className="LackOfFee";//green //arrange
		}
		else
		{
		  var num=selrow%2;
		  if (num==0)
		  {
		  RowObj.className="RowEven";//green //arrange
		  }
		  else
		  {
		  RowObj.className="RowOdd";//green //arrange
		  }

		}


 }
 function surecheck()
 {
	var objtbl=document.getElementById('tDHCTEMPOERPRINT');
	var i=0
	var rwstr="";
	var saveaudit=document.getElementById('tempsaveaudit').value
	var adm=document.getElementById('Adm').value
    for (i=1;i<objtbl.rows.length;i++)
    {
	    var itemsel=document.getElementById("selz"+i);
	    var ExNur=document.getElementById("ExNurz"+i);
	    var ExDC=document.getElementById("ExDCz"+i);
	    var ExTime=document.getElementById("ExTimez"+i)
	    var rw=document.getElementById("ORWz"+i).innerText;
	    var exd="N",exnur="N",ext="N";
	    var exstr="";
	    if (ExDC.checked==true){
		     exd="Y";
		    }
	    if (ExNur.checked==true){
		    exnur="Y";
		    }
	    if (ExTime.checked==true){
		    ext="Y";
		    }
		    exstr="!"+exd+"!"+exnur+"!"+ext
	    if (itemsel.checked==true)
	    {
		   rwstr=rwstr+rw+"!1"+exstr+"^";
		}
		else
		{
			rwstr=rwstr+rw+"!0"+exstr+"^"
		}
	}
    var ret=cspRunServerMethod(saveaudit,adm,rwstr);
 //alert(ret);
 }

function dsptxt()
{ //text1.style.display ="none"
  //text1.style.display ="block"
    var obj=document.getElementById("UpdateDate");
    var StDate=document.getElementById("StDate");
    var StTime=document.getElementById("StTime");
    var ExDate=document.getElementById("ExDate1");
    var ExTime=document.getElementById("ExTime1");
    var cStDate=document.getElementById("cStDate");
    var cStTime=document.getElementById("cStTime");
    var cExDate=document.getElementById("cExDate1");
    var cExTime=document.getElementById("cExTime1");
 	var date=document.getElementById("ld50540iStDate"); //"ld50353iStDate"); //??//ypz 060806
 	var dateex=document.getElementById("ld50540iExDate1"); //"ld50353iExDate1");//??//ypz

    if (obj) obj.style.display ="none"; //ypz ah 060824 
    if (StDate) StDate.style.display ="none";
    if (StTime) StTime.style.display ="none";
    if (ExDate) ExDate.style.display ="none";
    if (ExTime) ExTime.style.display ="none";
    if (cStDate) cStDate.style.display="none";
    if (cStTime) cStTime.style.display="none";
    if (cExDate) cExDate.style.display="none";
    if (cExTime) cExTime.style.display="none";
    if (date) date.style.display="none";
    if (dateex) dateex.style.display="none";
}
function dsptxtblock()
{ //text1.style.display ="none"
  //text1.style.display ="block"
    var obj=document.getElementById("UpdateDate");
    var StDate=document.getElementById("StDate");
    var StTime=document.getElementById("StTime");
    var ExDate=document.getElementById("ExDate1");
    var ExTime=document.getElementById("ExTime1");
    var cStDate=document.getElementById("cStDate");
    var cStTime=document.getElementById("cStTime");
    var cExDate=document.getElementById("cExDate1");
    var cExTime=document.getElementById("cExTime1");
 	var date=document.getElementById("ld50353iStDate");
 	var dateex=document.getElementById("ld50353iExDate1");//
    obj.style.display ="inline";
    StDate.style.display ="inline";
    StTime.style.display ="inline";
    ExDate.style.display ="inline";
    ExTime.style.display ="inline";
    cStDate.style.display="inline";
    cStTime.style.display="inline";
    cExDate.style.display="inline";
    cExTime.style.display="inline";
    date.style.display="inline";
    dateex.style.display="inline";
}

function UpdateDateClick()
{
	//alert(document.getElementById("UpExDate").value);
 var update=document.getElementById("UpStDate").value;
 var UpExDate=document.getElementById("UpExDate").value;
 var StDate=document.getElementById("StDate").value;
 var StTime=document.getElementById("StTime").value;
 var ExDate=document.getElementById("ExDate1").value;
 var ExTime=document.getElementById("ExTime1").value;
 //alert(selrow)
	if ((selrow!="")&&(StDate!="")&&(StTime!=""))
	{
		var rw=document.getElementById("ORWz"+selrow).innerText;
		var ford= rw.replace(String.fromCharCode(1), "||");
		//alert(ford)
		var res=cspRunServerMethod(update,ford,StDate,StTime);
	    if (res==0)
	    {alert("OK")}
	    else{alert("err")}
	}
	if ((selrow!="")&&(ExDate!="")&&(ExTime!=""))
	{
		var rw=document.getElementById("ORWz"+selrow).innerText;
		var ford= rw.replace(String.fromCharCode(1), "||");
		var res=cspRunServerMethod(UpExDate,ford,ExDate,ExTime);
	    if (res==0)
	    {alert("OK")}
	    else{alert("err")}
	}
	
}
 function SelectRowHandler()
 {
   // var i;
    //var resList=new Array();
    //var objtbl=document.getElementById('tDHCTEMPOERPRINT');
     selrow=DHCWeb_GetRowIdx(window);
   // var rw=document.getElementById("rwz"+selrow.value).innerText;
    //RowId=document.getElementById("ORWz"+selrow).innerText;
 
 }
function DHCWeb_GetRowIdx(wobj)
{
	try{
		var eSrc=wobj.event.srcElement;
		//alert(wobj.name);
		if (eSrc.tagName=="IMG") eSrc=wobj.event.srcElement.parentElement;
		var rowObj=getRow(eSrc);
		var selectrow=rowObj.rowIndex;
		return 	selectrow
	}catch (e)
	{
		alert(e.toString());
		return -1;
	}
}

function MatchDemo()
{
   var r, re;                    
   var s = "The rain in Spain falls mainly in the plain";
   re = new RegExp("Spain");  
   r = s.match(re);               
   return(r);                     
}
function PrintCurrClick()
{
	XPrintClick(2);
	return;

}
function printNurRec(PrintComm,parr,flag)
{
	///Nur.DHCORDPRINT SetPrintFlag
	 
          var ret=tkMakeServerCall("Nur.DHCMGNurseSet","getSet");
          var arr=ret.split("^");
          var CacheDB=arr[0];
          var webIP=arr[1];
            
		  var f=tkMakeServerCall("Nur.DHCORDPRINT","SetPrintFlag",session['LOGON.USERID'],session['LOGON.CTLOCID']+"^lsord",Adm,"Y");  //打印
		  var ret=tkMakeServerCall("web.DHCMGNurComm","PatInfo",Adm);
		  var StLocPage=0;
		
          StLocPage=tkMakeServerCall("web.DHCTEMPOERPRINT", "GetStartPage","lsord", Adm, Dep, DepNo);
          if (StLocPage!="") PrintComm.StLocPage=StLocPage;  ///科室起始页设置

          var stpage, stline;
          var etpage, etline;
          var aa = tkMakeServerCall("Nur.DHCORDPRINT", "getprintinfo",  Adm, DepNo, "lsord" );
          PrintComm.WebUrl=webIP+"/dthealth/web/DWR.DoctorRound.cls";
          PrintComm.SetSignature("^TimeEx^CPTEx^Status"); //Arcim
          PrintComm.XuFlag="Y";
          PrintComm.StPrintedCound=0;
          PrintComm.EPrintedOrdCount=0;
          PrintComm.PrintedOrdCount=0;
          PrintComm.stPage =0;
          PrintComm.stRow = 0;
          PrintComm.stPrintPos = 0;
          PrintComm.BstPage = 0;
          PrintComm.BstPrintPos =0;
          PrintComm.BstRow =0;   
          PrintComm.PageRows=32;   
          if (flag=="Y")  ///签名
          {
	        PrintComm.signatureFlag="Y";
	      }else{
		       PrintComm.signatureFlag="N";

		      }
          var pinfo=aa.split('^');
          if( aa!="")  PrintComm.PrnPar=pinfo[5];
          else{
	           PrintComm.PrnPar="";
	           PrintComm.stRow=0;
          }

            if (pinfo[0] != "")
            {
                if (parr != "")
                {
                   
                    PrintComm.XuFlag="N";
                    arrpp=parr.split('|');
                    stpage =arrpp[0]; stline =arrpp[1];
                    etpage =arrpp[2]; etline =arrpp[3];
                   if (stpage!="")
                   {
	                 if ((eval(stpage)-eval(StLocPage))>=0 )   stpage=eval(stpage)-eval(StLocPage)+1;
	               }
                   if (etpage!="")
                   {
	                  if ((eval(etpage)-eval(StLocPage))>=0 )    etpage=eval(etpage)-eval(StLocPage)+1;
                   }
                    //alert(stpage+"^"+stline+"^"+etpage+"^"+etline);
                    var bprint = tkMakeServerCall("Nur.DHCORDPRINTSUB", "getpagprintinfo",stpage, stline, etpage, etline, pinfo[5]);
                    var bpinfo = bprint.split('|');
                    var cc = bpinfo[0].split('^');
                    var stlin = cc[0];
                    var stcount = cc[2];
                    var srow = cc[1];
                    cc = bpinfo[1].split('^');
                    var etlin = cc[0];
                    var etcount = cc[2];
                    var erow = cc[1];

                    pinfo[0] = stlin;
                    pinfo[1] = stpage-1;
                    pinfo[2] = srow;
                    pinfo[3] = stcount;
                    pinfo[4] = etcount;
                    //debugger;
                }else{
	               // debugger;
	                 var bprint = tkMakeServerCall("Nur.DHCORDPRINTSUB", "getpglin",eval(pinfo[1])+1, "0",  pinfo[5]);
                     var aaa=bprint.split('^');
                     PrintComm.StPrintedCound=aaa[2];
	                
	                }
            }
            PrintComm.HeadH = (60);
		    PrintComm.TitleStr=ret;
		    PrintComm.SetPreView("1");
		    PrintComm.PrnLoc=session['LOGON.CTLOCID'];

           // PrintComm.SetConnectStr(CacheDB );
            if (pinfo[0] != "")
            {
                PrintComm.stPage = pinfo[1];
                PrintComm.stRow = pinfo[2];
                PrintComm.stPrintPos = pinfo[0];
                PrintComm.BstPage = pinfo[1];
                PrintComm.BstPrintPos =pinfo[0];
                PrintComm.BstRow =pinfo[2];
                PrintComm.PrintedOrdCount =pinfo[3];
                if (pinfo[4] != "") PrintComm.EPrintedOrdCount =pinfo[4];
                PrintComm.PagHead=pinfo[6];

            }
            // PrintComm.SetConnectStr(CacheDB);
            PrintComm.previewPrint = "0"; //是否弹出设置界面
            PrintComm.ItmName = "DHCNurPrnTmpOrd";
            PrintComm.ID = "";
            PrintComm.MultID = "";
            PrintComm.MthArr = "";
            // Adm As %String, StartDate As %String, EndDate As %String, ChangeDate As %String = "", stop As %String = "0", ssuser = "", CurDep = "", NurOrd, DocOrd, SelDocDep As %String = "N", DocDepId = "", SelRecDep As %String = "N", RecDepId = ""
            var parr=Adm+"^^^^1^"+session['LOGON.USERID']+"^"+DepNo+"^^^^^^";
            PrintComm.SetParrm(parr);
            PrintComm.PrintOut();
            ///结束
            var f=tkMakeServerCall("Nur.DHCORDPRINT","SetPrintFlag",session['LOGON.USERID'],"",Adm,"N");  //打印

            var p = PrintComm.Pages;
            var pos = PrintComm.stPrintPos;
            var strow = PrintComm.stRow;
            var ordcount = PrintComm.PrintedOrdCount;
            var PagOrdStr = PrintComm.PagOrdStr;
            var OrdsRow = PrintComm.OrdsRow;
            var RowH = PrintComm.SRowH;
            var PagHead = PrintComm.PagHead;
            var SignStr=PrintComm.SignOrds;
            var PageRows=PrintComm.PageRows;
			
            if (pinfo[0] != "")
            {
                if ((PrintComm.PrnFlag> 1)&&(PrintComm.signatureFlag=="Y") )
                {
	              
	               var parsub=tkMakeServerCall("Nur.DHCORDPRINTSUB", "savesign",SignStr,pinfo[5]) 
	            }
                if (pinfo[4]!="")  return;
            }
         
            if (PrintComm.PrnFlag <= 1) return;
            else {
                //page, prnpos, adm, Typ, user,OrdCount,Loc

                //string par = Comm.GetCacheData("Nur.DHCORDPRINT", "Save", new object[] { p, pos, "285665", "Long", "1", ordcount, "88!36", "210" });
               
                var par = tkMakeServerCall("Nur.DHCORDPRINT", "Save", p, pos, Adm, "lsord", session['LOGON.USERID'], ordcount, PagHead +"!"+RowH , strow ,DepNo,PageRows );
                
                if (par != "")
                {
	                PrintComm.SavePagInfo(par);
                    //var parsub=tkMakeServerCall("Nur.DHCORDPRINTSUB", "Save",  PagOrdStr, OrdsRow ,par,SignStr);
                }
            
            }

			//alert(a);			
			//*/
}
function ReprintNurRec(PrintComm,parr,flag)
{
            var ret=tkMakeServerCall("Nur.DHCMGNurseSet","getSet");
            var arr=ret.split("^");
            var CacheDB=arr[0];
            var webIP=arr[1];
            
		    var ret=tkMakeServerCall("web.DHCMGNurComm","PatInfo",Adm);
		  
          
		    PrintComm.signatureFlag="N";
	        PrintComm.SetSignature("");
	        
            PrintComm.HeadH = (60);
		    PrintComm.TitleStr=ret;
		    PrintComm.SetPreView("1");
		    PrintComm.PrnLoc=session['LOGON.CTLOCID'];

            PrintComm.SetConnectStr(CacheDB );
           
            PrintComm.previewPrint = "0"; //是否弹出设置界面
            PrintComm.ItmName = "DHCNurPrnTmpOrd";
            PrintComm.ID = "";
            PrintComm.MultID = "";
            PrintComm.MthArr = "";
            
            var parr=Adm+"^^^^1^"+session['LOGON.USERID']+"^"+DepNo+"^^^^^^";
            PrintComm.SetParrm(parr);
            PrintComm.PrintOut();

            
}
function RePrintClick()
{   
	var win=parent.frames;
    var print=win["RPtop"].document.getElementById("PrintCommOrd");
    printNurRec(print,"1|||","N");
    return;
}
function PrintClick()
{   
	var win=parent.frames;
var print=win["RPtop"].document.getElementById("PrintCommOrd");
//alert(print);
printNurRec(print,"","N");
return;

	XPrintClick(1);
	return;
	  	var objtbl=document.getElementById('tDHCTEMPOERPRINT');
	    if  (objtbl.rows.length==1) return;
	    var xlsExcel,xlsSheet,xlsBook;
	    var i,j;
        //alert(PrintDateTime);
        var  path = GetFilePath();
      // var aa=MatchDemo();
      //alert( aa);
       //path="d:\\"
        var fileName="lsyz1.xls" ;//+ fileName;
        fileName=path+ fileName;
	    xlsExcel = new ActiveXObject("Excel.Application");
	    //alert("also ok")
	    xlsBook = xlsExcel.Workbooks.Add(fileName) //;Open(fileName)
	    xlsSheet = xlsBook.ActiveSheet ;//  Worksheets(1)
	   	var strj=document.getElementById("ProcessNoz"+1).innerText;
        var GetItemNum=document.getElementById("GetItemNum").value;
	    var num=new Number(cspRunServerMethod(GetItemNum,Adm,strj));
	    var PRow=28;//lines per pages
	    var pnum=0; //pages
	    var frw=2;
		for (i=1;i<num+1;i++)
	     {
		   var GetItem=document.getElementById("GetItem").value; 
		   
		   var res=cspRunServerMethod(GetItem,i,Adm,strj);
		   var data=res.split("^");
           var lnum=1+PRow*pnum;
		   if (lnum==1) gridset(xlsSheet,1,1,9,1,11);
		   xlsSheet.cells(frw,1)=data[0];
		   xlsSheet.cells(frw,2)=data[1];
		   xlsSheet.cells(frw,3)=data[2];
		   xlsSheet.cells(frw,4)=data[3];
		   xlsSheet.cells(frw,5)=data[5];
		   xlsSheet.cells(frw,6)=data[6];
		   xlsSheet.cells(frw,7)="";
		   
		   var pres=frw%PRow;
		   if (pres==0)
		   {
			   pnum=pnum+1;
		       frw=frw+1;
		       gridset(xlsSheet,frw,1,7,frw,11);
			   //fontcell(xlsSheet,i+1,1,6,11);
			   //xlcenter(xlsSheet,i+1,1,6);
		       frw=frw+2
		   }
		   else
		   {
			   frw=frw+1
		   }
		    
		 }
	    var hospitalDesc=document.getElementById("hospital").value;
        var titleRows = 0;titleCols = 0 ;//&chr(10)
		var CenterHeader = "&12"+hospitalDesc+"\r"+"&14"+t['val:tempOrdSheet'];
	    var PatInfo=document.getElementById("patinfo").value;
		var regNo=parent.frames["RPtop"].document.getElementById("RegNo").value;  //ypz 070308
	    var info=cspRunServerMethod(PatInfo,Adm); //ypz 070308
	    //var info=cspRunServerMethod(PatInfo,regNo); //ypz 070308
	    var infoarr=info.split("^");
	    //regno_"^"_ctloc_"^"_room_"^"_sex_"^"_patName_"^"_Bah_"^"_bedCode_"^"_age
	    var RightHeader="";
	    var  LeftHeader="\r\r\r&9"+t['val:patname']+":"+infoarr[4]+"    "+t['val:Dep']+infoarr[1]+"     "+t['val:room']+infoarr[2]+"      "+t['val:regNo']+infoarr[0];LeftFooter = "";CenterFooter = t['val:cFooter'];RightFooter = "";
        ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter) 
        var sherow=PRow-(i-pnum*PRow);
		gridlist(xlsSheet,1,i+sherow,1,7);
		xlsExcel.Visible = true;
        xlsSheet.PrintPreview ;

       /* xlsSheet = null;
        xlsBook.Close(savechanges=false);
        xlsBook = null;
        xlsExcel.Quit();
        xlsExcel = null;*/
}
function gridset(xlsSheet,r,c1,c2,frw,fontnum)
{
     fontcell(xlsSheet,r,c1,c2,fontnum);
	 xlcenter(xlsSheet,r,c1,c2);
	 xlsSheet.cells(frw,1)=""; //t['val:date']
	 xlsSheet.cells(frw,2)="";//t['val:time']
	 xlsSheet.cells(frw,3)="";//t['val:ordDesc']
	 xlsSheet.cells(frw,4)="";//t['val:docSign']
	 xlsSheet.cells(frw,5)="";//t['val:execDateTime']
	 xlsSheet.cells(frw,6)="";//t['val:nurseSign']
	// xlsSheet.cells(frw,7)="";//t['val:note']   //协和


}
function gridset1(xlsSheet,r,c1,c2,frw,fontnum)
{
     fontcell(xlsSheet,r,c1,c2,fontnum);
	 xlcenter(xlsSheet,r,c1,c2);
	 xlsSheet.cells(frw,1)=t['val:date'];
	 xlsSheet.cells(frw,2)=t['val:time'];
	 xlsSheet.cells(frw,3)=t['val:ordDesc'];
	 xlsSheet.cells(frw,4)=t['val:docSign'];
	 xlsSheet.cells(frw,5)=t['val:execDateTime'];
	 xlsSheet.cells(frw,6)=t['val:nurseSign'];
	 xlsSheet.cells(frw,7)=t['val:note'];


}
 function GetFilePath()
  {   var GetPath=document.getElementById("GetPath").value;
      var path=cspRunServerMethod(GetPath);
      return path;
  }
function PrintSet(lnk,nwin)
{
   //lnk+="&ward="+wardid+"&warddes="+ward;
   var Adm=document.getElementById("Adm").value;
 //  nwin="top=50,left=200,height=210,width=350";
   //lnk+="&Adm="+Adm;
  // window.open(lnk,'_blank',nwin);	
   Adm=escape(Adm)	//cjb 2007-12-12
   Dep=escape(Dep)
   DepNo=escape(DepNo)
   lnk+="&Adm="+Adm+"&OrdTyp=lsord"+"&Dep="+Dep+"&DepNo="+DepNo;
   var str=window.showModalDialog(lnk,"dialogWidth=500px;dialogHeight=500px");
   if (str)
   {	
     BPRNSTR=str;
     //XPrintClick(0);
     // alert(BPRNSTR);
     var win=parent.frames;
     var print=win["RPtop"].document.getElementById("PrintCommOrd");
     printNurRec(print,BPRNSTR,"N");
   }

}
function gengxinriqi()
{
  dsptxtblock();	
}
function SetStpage(lnk)
{
	  var Adm=document.getElementById("Adm").value;
 //  nwin="top=50,left=200,height=210,width=350";
   //lnk+="&Adm="+Adm;
  // window.open(lnk,'_blank',nwin);	
   Adm=escape(Adm)
   Dep=escape(Dep)
   DepNo=escape(DepNo)
   lnk+="&Adm="+Adm+"&OrdTyp=lsord"+"&Dep="+Dep+"&DepNo="+DepNo;  //,
   var str=window.showModalDialog(lnk,"dialogWidth=500px;dialogHeight=200px");	


}
function PageBtn_Click()
{
 var page=document.getElementById("PagNo").value;
 var adm=document.getElementById("Adm").value;
 var pageNum;
 var Dep=document.getElementById("Dep").value;
 var NurOrd=document.getElementById("NurOrd").value;
 var DocOrd=document.getElementById("DocOrd").value;
 //alert(NurOrd)
 var stop=document.getElementById("stop").value;
 var ssuser=session['LOGON.USERID'];
 if (page!="")
 {
	pageNum=eval(page)-1
 }else{
	 return;
	 }
window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCTEMPOERPRINT&Adm="+adm+"&StartDate=&EndDate=&ChangeDate=&stop="+stop+"&ssuser="+ssuser+"&Dep="+Dep+"&NurOrd="+NurOrd+"&DocOrd="+DocOrd+"&PagNo="+page+"&CONTEXT=&TWKFL=&TWKFLI=&TPAGCNT="+pageNum+"&TSRT=0";

}
document.body.onload = BodyLoadHandler;
