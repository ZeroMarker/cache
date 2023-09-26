Adm=document.getElementById("Adm").value;
var selrow;//=document.getElementById("selrow");

function BodyLoadHandler()
{
	var PrintCurr=document.getElementById('BtPrintCurr');
	PrintCurr.style.display="none";
	var PageBtn=document.getElementById('SchPage');
	if (PageBtn) PageBtn.onclick=PageBtn_Click;
    var objtbl=document.getElementById('tDHCLONGTIMEORD');
	if (objtbl) objtbl.onclick=Table_onclick;
	var btnsure=document.getElementById('btnsure');
	if (btnsure) btnsure.onclick=surecheck;
	var i=0;
    for (i=1;i<objtbl.rows.length;i++)
	{
	   var eSrc=objtbl.rows[i];
	   var RowObj=getRow(eSrc);
	   var item=document.getElementById("OrdNoz"+i);
       var item2=document.getElementById("OrdStatz"+i).innerText;
	   if(item2.indexOf("停止")!=-1)
	   {
		   RowObj.className="Discontinue";
	   }
	   var skinY,skinN;
	   skinY=item2.indexOf("(+)");
	   skinN=item2.indexOf("(-)");
	   if (skinY!=-1){
		  RowObj.className="SkinTest"
	   }
	   if (skinN!=-1){
		  RowObj.className="Green"
	   }
	   var chek=document.getElementById("selz"+i);
	   var ordstat=document.getElementById("OrdStatz"+i).innerText;
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
    //var Res,PageStr,StPage,StRow;
    //var FetchPageRow=document.getElementById("schtystrow").value;
    var CurStat=document.getElementById("CurStatus");
    /*
    if (Adm!=""){
    Res=cspRunServerMethod(FetchPageRow,"longord",Adm,Dep,DepNo)
    //alert(DepNo)
    if (Res!=""){
    PageStr=Res.split("|");
    StPage=PageStr[0];
    StRow=PageStr[1];
    StRow=StRow-2;
    CurStat.value=t['val:xprn']+StPage+t['val:page']+StRow+t['val:Row'];
    }
    */
    var Res,StPage,StRow;
    Res = tkMakeServerCall("Nur.DHCORDPRINT", "getPLprintinfo",  Adm, DepNo, "LONG" );
    var PagStr="";
   // alert(Res);
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
    
 }
 function Table_onclick()
 {
  var selrow=DHCWeb_GetRowIdx(window);
  if((!selrow)||(selrow<1)) return;
  var objtbl=document.getElementById('tDHCLONGTIMEORD');
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
	var objtbl=document.getElementById('tDHCLONGTIMEORD');
	var i=0
	var rwstr="";
	var saveaudit=document.getElementById('saveaudit').value
	var adm=document.getElementById('Adm').value
    for (i=1;i<objtbl.rows.length;i++)
    {
	    var itemsel=document.getElementById("selz"+i);
	    var ExNur=document.getElementById("ExNurz"+i);
	    var StopDateTime=document.getElementById("StopDateTimez"+i);
	    var StopDoc=document.getElementById("StopDocz"+i);
	    var StopNur=document.getElementById("StopNurz"+i);
	    var rw=document.getElementById("ORWz"+i).innerText;
	    var exn="N",stdt="N",stdoc="N",stnur="N";
	    var exstr="";
	    if (ExNur.checked==true){
		    exn="Y";
		    }
	    if (StopDateTime.checked==true){
		    stdt="Y";
		    }
	    if (StopDoc.checked==true){
		    stdoc="Y";
		    }
	    if (StopNur.checked==true){
		    stnur="Y";
		    }
		 exstr="!"+exn+"!"+stdt+"!"+stdoc+"!"+stnur;
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
	alert(ret);
 }
function UpdateDateClick()
{
	var update=document.getElementById("UpdateStDate").value;
	var updatestop=document.getElementById("UpateStopDate").value;
	var StDate=document.getElementById("StDate1").value;
	var StTime=document.getElementById("StTime").value;
	var stop=document.getElementById("StopDate").checked;
	var res;

	if ((selrow!="")&&(StDate!="")&&(StTime!=""))
	{
		var rw=document.getElementById("ORWz"+selrow).innerText;
		var ford= rw.replace(String.fromCharCode(1), "||");

		if (stop==true)
		{

		res=cspRunServerMethod(updatestop,ford,StDate,StTime);	
		}
		else{
		 res=cspRunServerMethod(update,ford,StDate,StTime);
		}
	    if (res==0)
	    {alert(t['alert:success'])}
	    else{alert(t['alert:error']);}
	}
}
function dsptxt()
{ //text1.style.display ="none"
  //text1.style.display ="block"
    var obj=document.getElementById("UpdateDate");
  	var StDate=document.getElementById("StDate1");
	var StTime=document.getElementById("StTime");
    var cStDate=document.getElementById("cStDate1");
	var cStTime=document.getElementById("cStTime");
	var date=document.getElementById("ld50537iStDate1") //"ld50354iStDate1");//??//ypz 060806
	var StopDate=document.getElementById("StopDate");
	var cStopDate=document.getElementById("cStopDate");

    if (obj) obj.style.display ="none";  //ypz ah 060824
    if (StDate) StDate.style.display ="none";
    if (StTime) StTime.style.display ="none";
    if (cStDate) cStDate.style.display="none";
    if (cStTime) cStTime.style.display="none";
    if (date) date.style.display="none";
    if (StopDate) StopDate.style.display="none";
    if (cStopDate) cStopDate.style.display="none";

}
function dsptxtblock()
{ //text1.style.display ="none"
  //text1.style.display ="block"
    var obj=document.getElementById("UpdateDate");
  	var StDate=document.getElementById("StDate1");
	var StTime=document.getElementById("StTime");
    var cStDate=document.getElementById("cStDate1");
	var cStTime=document.getElementById("cStTime");
	var date=document.getElementById("ld50353iStDate");
	var StopDate=document.getElementById("StopDate")
    var cStopDate=document.getElementById("cStopDate");

    obj.style.display ="inline";
    StDate.style.display ="inline";
    StTime.style.display ="inline";
    cStDate.style.display="inline";
    cStTime.style.display="inline";
    date.style.display="inline";
    StopDate.style.display="inline";
    cStopDate.style.display="inline";

}
function PrintCurrClick()
{  //print curr content
	XPrintClick(2);
	return;

}
function printNurRec(PrintComm,parr,flag)
{
	       //alert(parr);
            var ret=tkMakeServerCall("Nur.DHCMGNurseSet","getSet");
            var arr=ret.split("^");
            var CacheDB=arr[0];
            var webIP=arr[1];
            
		  var ret=tkMakeServerCall("web.DHCMGNurComm","PatInfo",Adm);
		  PrintComm.WebUrl=webIP+"/dthealth/web/DWR.DoctorRound.cls";
          var StLocPage=0;
          StLocPage=tkMakeServerCall("web.DHCTEMPOERPRINT", "GetStartPage","long", Adm, Dep, DepNo);
          if (StLocPage!="") PrintComm.StLocPage=StLocPage;  ///科室起始页设置
         
          var stpage, stline;
          var etpage, etline;
          //alert(session['LOGON.CTLOCID']);
          //alert(Adm);
          var aa = tkMakeServerCall("Nur.DHCORDPRINT", "getprintinfo",  Adm, DepNo, "long" );
          PrintComm.SetSignature("^CPTEx^XDate^XTime^StopNur^StopDoc"); //Arcim
          PrintComm.XuFlag="Y";
         if (flag=="Y")  ///签名
          {
	        PrintComm.signatureFlag="Y";
	      }else{
		       PrintComm.signatureFlag="N";
	          // PrintComm.SetSignature("");
		  }
		      
          var pinfo=aa.split('^');
          PrintComm.EPrintedOrdCount=0;
          PrintComm.StPrintedCound=0;
          PrintComm.PrintedOrdCount=0;
          PrintComm.stPage =0;
          PrintComm.stRow = 0;
          PrintComm.stPrintPos = 0;
          PrintComm.BstPage = 0;
          PrintComm.BstPrintPos =0;
          PrintComm.BstRow =0;     
			PrintComm.PageRows=32;  
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
                   // alert(arrpp);
                   // stpage=arrpp[0];
                    stpage =arrpp[0]; stline =arrpp[1];
                    etpage =arrpp[2]; etline =arrpp[3];
                    if (StLocPage!="")
                    {
	                   if (stpage!="")
	                   {
		                 if ((eval(stpage)-eval(StLocPage))>=0 )   stpage=eval(stpage)-eval(StLocPage)+1;
		               }
	                   if (etpage!="")
	                   {
		                  if ((eval(etpage)-eval(StLocPage))>=0 )    etpage=eval(etpage)-eval(StLocPage)+1;
	                   }
                    }

                   // alert(stpage+"^"+stline+"^"+etpage+"^"+etline+"^"+pinfo[5]);
                    var bprint = tkMakeServerCall("Nur.DHCORDPRINTSUB", "getpagprintinfo",stpage, stline, etpage, etline, pinfo[5]);
                    var bpinfo = bprint.split('|');
                    //alert(bpinfo);
                    var cc = bpinfo[0].split('^');
                    var stlin = cc[0];
                    var stcount = cc[2];
                    var srow = cc[1];
                    cc = bpinfo[1].split('^');
                    var etlin = cc[0];
                    var etcount = cc[2];
                    var erow = cc[1];


                   // if ((stpage == "1") && (stlin == "0")) stpage = "0";
                    pinfo[0] = stlin;
                    pinfo[1] = stpage-1;
                    //debugger;
                    pinfo[2] = srow;
                    pinfo[3] = stcount;
                    pinfo[4] = etcount;
                }else{
	               // debugger;
	              // alert(pinfo);
	                 var bprint = tkMakeServerCall("Nur.DHCORDPRINTSUB", "getpglin",eval(pinfo[1])+1, "0",  pinfo[5]);
                     var aaa=bprint.split('^');
                  // alert(aaa);
                     PrintComm.StPrintedCound=aaa[2];
	                
	                }
            }
            PrintComm.HeadH = (22 * 4);
		    PrintComm.TitleStr=ret;
		    PrintComm.SetPreView("1");
		    PrintComm.PrnLoc=session['LOGON.CTLOCID'];

            //PrintComm.SetConnectStr(CacheDB );
            if (pinfo[0] != "")
            {
                PrintComm.stPage = pinfo[1];
                PrintComm.stRow = pinfo[2];
                PrintComm.stPrintPos = pinfo[0];
                PrintComm.BstPage = pinfo[1];
                PrintComm.BstPrintPos =pinfo[0];
                PrintComm.BstRow =pinfo[2];
                PrintComm.PrintedOrdCount =pinfo[3];
                PrintComm.PagHead=pinfo[6];
                if (pinfo[4] != "") PrintComm.EPrintedOrdCount =pinfo[4];
            }
            // PrintComm.SetConnectStr(CacheDB);
            PrintComm.previewPrint = "0"; //是否弹出设置界面
            PrintComm.ItmName = "DHCNurPrnLongOrd";
            PrintComm.ID = "";
            PrintComm.MultID = "";
            PrintComm.MthArr = "";
            // Adm As %String, StartDate As %String, EndDate As %String, ChangeDate As %String = "", stop As %String = "0", ssuser = "", CurDep = "", NurOrd, DocOrd, SelDocDep As %String = "N", DocDepId = "", SelRecDep As %String = "N", RecDepId = ""
            //alert(DepNo);
            var parr=Adm+"^^^^1^"+session['LOGON.USERID']+"^"+DepNo+"^^^^^^";
            
            //alert(parr);
            PrintComm.SetParrm(parr);
            PrintComm.PrintOut();

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
                {  //保存签名记录
	               var parsub=tkMakeServerCall("Nur.DHCORDPRINTSUB", "savesign",SignStr,pinfo[5]) 
	            }
                if (pinfo[4]!="")  return;
            }
            //alert(Adm);
            if (PrintComm.PrnFlag <= 1) return;
            else {
                //page, prnpos, adm, Typ, user,OrdCount,Loc
                
                //string par = Comm.GetCacheData("Nur.DHCORDPRINT", "Save", new object[] { p, pos, "285665", "Long", "1", ordcount, "88!36", "210" });
                var par = tkMakeServerCall("Nur.DHCORDPRINT", "Save", p, pos, Adm, "long", session['LOGON.USERID'], ordcount, PagHead +"!"+RowH , strow ,DepNo,PageRows );
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
      
          PrintComm.HeadH = (22 * 4);
		  PrintComm.TitleStr=ret;
		  
		  //PrintComm.DesignFlag = "1";
		  PrintComm.SetPreView("1");
		  PrintComm.PrnLoc=session['LOGON.CTLOCID'];
          PrintComm.SetConnectStr(CacheDB );
          
          PrintComm.previewPrint = "0"; //是否弹出设置界面
          PrintComm.ItmName = "DHCNurPrnLongOrd";
          PrintComm.ID = "";
          PrintComm.MultID = "";
          PrintComm.MthArr = "";
            
          var parr=Adm+"^^^^1^"+session['LOGON.USERID']+"^"+DepNo+"^^^^^^";
          //alert(parr);
          PrintComm.SetParrm(parr);
          PrintComm.PrintOut();     
}
function RePrintClick()
{	
	 var win=parent.frames;
     var print=win["RPtop"].document.getElementById("PrintCommOrd");
     //ReprintNurRec(print,"","N");
     printNurRec(print,"1||||","N");
     return;
}

function PrintClick()
{	
	 var win=parent.frames;
     /*var print=win["RPtop"].document.getElementById("PrintCommOrd");
     printNurRec(print,"","N");
     */
     var DHCCNursePrintComm=win["RPtop"].document.getElementById("DHCCNursePrintComm");
     var ret=tkMakeServerCall("Nur.DHCMGNurseSet","getSet");
     var arr=ret.split("^");
     var CacheDB=arr[0];
     var webIp=arr[1];
     var wardId=session['LOGON.WARDID'];
     var userId=session['LOGON.USERID'];
     var locid=session['LOGON.CTLOCID'];
     var docloc=tkMakeServerCall("web.DHCLONGTIMEORD","GETLOCID",locid);
     var Adm=document.getElementById("Adm").value;
     DHCCNursePrintComm.showDoctorOrderSheetWindow(Adm,wardId,docloc,userId,webIp); 
     return; 
     /*var wardId=session['LOGON.WARDID'];
     var Adm=document.getElementById("Adm").value;
     var lnk="dhcnurdoctorordersheet.csp?EpisodeID="+Adm+"&wardId="+wardId;
     var NewWin=open(lnk,"dhcnurdoctorordersheet","scrollbars=no,resizable=no,top=6,left=6,width=1200,height=700");
     
     */return; 
	   XPrintClick(1);
	   return;
	    var xlsExcel,xlsSheet,xlsBook;
	    var i,j;
	    var Adm=document.getElementById("Adm").value;

        //alert(PrintDateTime);
        var  path = GetFilePath();
       // path="d:\\"
        var fileName="cqyz1.xls" ;//+ fileName;
        fileName=path+ fileName;
	    xlsExcel = new ActiveXObject("Excel.Application");
	    xlsBook = xlsExcel.Workbooks.Add(fileName) //;Open(fileName)
	    xlsSheet = xlsBook.ActiveSheet ;//  Worksheets(1)
	    var strj=document.getElementById("ProcessNoz"+1).innerText;
	    var GetItemNum=document.getElementById("GetItemNum").value;
	    var hospitalDesc=document.getElementById("hospital").value;
		alert(hospitalDesc);
	    var num=new Number(cspRunServerMethod(GetItemNum,Adm,strj));
	    var PRow=28;//lines per page
	    var pnum=0; //pages
	    var frw=3;
		for (i=1;i<num+1;i++)
	     {
		   var GetItem=document.getElementById("GetItem").value; 
		   var res=cspRunServerMethod(GetItem,i,Adm,strj);
		   alert(res)
		   var data=res.split("^");
		   var lnum=1+PRow*pnum;
		   if (lnum==1) gridset(xlsSheet,1,1,9,1,11);
		   xlsSheet.cells(frw,1)=data[0];
		   xlsSheet.cells(frw,2)=data[1];
		   xlsSheet.cells(frw,3)=data[2];//data[4];ypz 060810
		   xlsSheet.cells(frw,4)=data[3];//data[2];ypz ah 060824
		   xlsSheet.cells(frw,5)=data[4];//data[3];ypz 060810
		   xlsSheet.cells(frw,6)=data[5];
		   xlsSheet.cells(frw,7)=data[6];
		   xlsSheet.cells(frw,8)=data[7];
		   xlsSheet.cells(frw,9)=data[8];		   
		   var pres=frw%PRow;
		   if (pres==0)
		   {
			   pnum=pnum+1;
		       frw=frw+1;
		       gridset(xlsSheet,frw,1,10,frw,11);
			   //fontcell(xlsSheet,i+1,1,6,11);
			   //xlcenter(xlsSheet,i+1,1,6);
		       frw=frw+2
		   }
		   else
		   {
			   frw=frw+1
		   }
		    
		 }
       var titleRows = 0;titleCols = 0 ;//&chr(10)
		var CenterHeader = "&12"+hospitalDesc+"\r"+"&14"+t['val:longTimeSheet'];
	    var PatInfo=document.getElementById("patinfo").value;
		var regNo=parent.frames["RPtop"].document.getElementById("RegNo").value;  //ypz 070308
	    var info=cspRunServerMethod(PatInfo,Adm); //ypz 070308
	    //var info=cspRunServerMethod(PatInfo,regNo); //ypz 070308
	    var infoarr=info.split("^");
	    //regno_"^"_ctloc_"^"_room_"^"_sex_"^"_patName_"^"_Bah_"^"_bedCode_"^"_age
	   // var RightHeader ="\r\r\r&9"+infoarr[4]+", "+infoarr[3]+", "+infoarr[7]+t['val:yearsOld']+", "+infoarr[8]+t['val:ward']+", "+infoarr[6]+t['val:bed'];
	    var RightHeader="";
	    var  LeftHeader="\r\r\r&9"+t['val:patname']+":"+infoarr[4]+"    "+t['val:Dep']+infoarr[1]+"     "+t['val:room']+infoarr[2]+"      "+t['val:regNo']+infoarr[0];LeftFooter = "";CenterFooter = t['val:cFooter'];RightFooter = "";
        ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter) 
        var sherow=PRow-(i-pnum*PRow);
        
		gridlist(xlsSheet,1,i+sherow,1,10);
		xlsExcel.Visible = true;
        xlsSheet.PrintPreview() ;

        xlsSheet = null;
        xlsBook.Close(savechanges=false);
        xlsBook = null;
        xlsExcel.Quit();
        xlsExcel = null;
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
function gridset(xlsSheet,r,c1,c2,frw,fontnum)
{
     nfontcell(xlsSheet,r,r+1,c1,c2,fontnum);
	 nxlcenter(xlsSheet,r,r+1,c1,c2);
     nmergcell(xlsSheet,r,r,1,4);
     //nmergcell(xlsSheet,r,r+1,4,4);
     nmergcell(xlsSheet,r,r+1,5,5);
     //nmergcell(xlsSheet,r,r+1,3,3);
    // nmergcell(xlsSheet,r,r,6,9);
     nmergcell(xlsSheet,r,r,6,7);   //协和
     //nmergcell(xlsSheet,r,r+1,8,8);
     //nmergcell(xlsSheet,r,r+1,9,9);
	 xlsSheet.cells(frw,1)="";
	 xlsSheet.cells(frw+1,1)="";
	 xlsSheet.cells(frw+1,2)="";
	 xlsSheet.cells(frw+1,3)=""; //longtimeord; ypz ah 060824
	 xlsSheet.cells(frw+1,4)=""; //doc sign;
	 xlsSheet.cells(frw,5)=""; //nurse sign; ypz ah 060824
	 xlsSheet.cells(frw,6)="";
	 xlsSheet.cells(frw+1,6)="";
	 xlsSheet.cells(frw+1,7)="";
	 //xlsSheet.cells(frw+1,8)="";  //协和
	 //xlsSheet.cells(frw+1,9)="";
} 
//原第一行
function gridset1(xlsSheet,r,c1,c2,frw,fontnum)
{
     nfontcell(xlsSheet,r,r+1,c1,c2,fontnum);
	 nxlcenter(xlsSheet,r,r+1,c1,c2);
     nmergcell(xlsSheet,r,r,1,4);
     //nmergcell(xlsSheet,r,r+1,4,4);
     nmergcell(xlsSheet,r,r+1,5,5);
     //nmergcell(xlsSheet,r,r+1,3,3);
     nmergcell(xlsSheet,r,r,6,9);
     //nmergcell(xlsSheet,r,r+1,8,8);
     //nmergcell(xlsSheet,r,r+1,9,9);
	 xlsSheet.cells(frw,1)=t['val:startEnd'];
	 xlsSheet.cells(frw+1,1)=t['val:date'];
	 xlsSheet.cells(frw+1,2)=t['val:time'];
	 xlsSheet.cells(frw+1,3)=t['val:docSign']; //longtimeord; ypz ah 060824
	 xlsSheet.cells(frw+1,4)=t['val:nurseSign']; //doc sign;
	 xlsSheet.cells(frw,5)=t['val:longTimeOrd']; //nurse sign; ypz ah 060824
	 xlsSheet.cells(frw,6)=t['val:disch'];
	 xlsSheet.cells(frw+1,6)=t['val:date'];
	 xlsSheet.cells(frw+1,7)=t['val:time'];
	 xlsSheet.cells(frw+1,8)=t['val:docSign'];
	 xlsSheet.cells(frw+1,9)=t['val:nurseSign'];
} 
function GetFilePath()
  {   var GetPath=document.getElementById("GetPath").value;
      var path=cspRunServerMethod(GetPath);
      return path;
  }
function PrintSet(lnk,nwin)
{
 // var ward=parent.frames["NurseTop"].document.getElementById("PacWard").value;
  //var wardid=parent.frames["NurseTop"].document.getElementById("wardid").value;
  //if (wardid=="")
  //{
  // alert(t["02"]);
  // return;
 // }
   //lnk+="&ward="+wardid+"&warddes="+ward;
   var Adm=document.getElementById("Adm").value;
   //nwin="top=50,left=200,height=210,width=350,z-look=Yes";
   Adm=escape(Adm)
   Dep=Dep
   DepNo=DepNo
   //lnk+="&Adm="+Adm+"&OrdTyp=longord"+"&Dep="+Dep+"&DepNo="+DepNo;
   lnk+="&Adm="+Adm+"&OrdTyp=long"+"&Dep="+Dep+"&DepNo="+DepNo;
 //var str=window.open(lnk,'_blank',nwin);	
  var str=window.showModalDialog(lnk,"dialogWidth=500px;dialogHeight=500px");
  if (str)
  {
   BPRNSTR=str;
   //XPrintClick(0);
   var win=parent.frames;
   var print=win["RPtop"].document.getElementById("PrintCommOrd");
   //alert(BPRNSTR);
   printNurRec(print,BPRNSTR,"N");
  }

}
function gengxinriqi()
{
 dsptxtblock();	
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
function SetStpage(lnk)
{
	  var Adm=document.getElementById("Adm").value;
 //  nwin="top=50,left=200,height=210,width=350";
   //lnk+="&Adm="+Adm;
  // window.open(lnk,'_blank',nwin);	
   Adm=escape(Adm)
   //Dep=Dep
  // alert(Dep);
   DepNo=escape(DepNo)
   lnk+="&Adm="+Adm+"&OrdTyp=long"+"&Dep="+Dep+"&DepNo="+DepNo;  //showModalDialog,"dialogWidth=500px;dialogHeight=200px"
  // alert(lnk);
  var str=window.showModalDialog(lnk,"dialogWidth=500px;dialogHeight=200px");	
  // var str=window.show(lnk,"dialogWidth=500px;dialogHeight=200px");
  

}
function PageBtn_Click()
{
 var page=document.getElementById("PagNo").value;
 var adm=document.getElementById("Adm").value;
 var pageNum;
 var Dep=document.getElementById("Dep").value;
 var NurOrd=document.getElementById("NurOrd").value;
 var DocOrd=document.getElementById("DocOrd").value;
 var stop=document.getElementById("stop").value;
 var ssuser=session['LOGON.USERID'];
 if (page!="")
 {
	pageNum=eval(page)-1
 }
 else{
	 return;
	 }
window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCLONGTIMEORD&Adm="+adm+"&StartDate=&EndDate=&ChangeDate=&stop="+stop+"&ssuser="+ssuser+"&Dep="+Dep+"&NurOrd="+NurOrd+"&DocOrd="+DocOrd+"&PagNo="+page+"&CONTEXT=&TWKFL=&TWKFLI=&TPAGCNT="+pageNum+"&TSRT=0";

}

document.body.onload = BodyLoadHandler;
