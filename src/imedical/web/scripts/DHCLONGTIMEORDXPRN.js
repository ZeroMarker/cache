var BPRNSTR;
BPRNSTR="";
var idTmr=""
var ComDep=parent.frames["RPtop"].document.getElementById("OrdDep")
var DepSelIndex=ComDep.selectedIndex;
var tem=ComDep.options[DepSelIndex].text.split("|");
var Dep=tem[1];
var DepNo=ComDep.options[DepSelIndex].value;
var hospitalDesc=document.getElementById("hospital").value;

function ExeQuery(ExeLongQuery,Adm,DepNo,user)
{
	var prj;
	//alert(ExeLongQuery+"^"+Adm+"^"+Dep+"^"+user)
	prj=cspRunServerMethod(ExeLongQuery,Adm,DepNo,user);
	return prj;
}
function GetStPage(OrdTyp, Adm, Dep,DepNo)
{
    var GetStartPage=document.getElementById("GetStartPage").value;
	var ret=cspRunServerMethod(GetStartPage,OrdTyp, Adm, Dep,DepNo);
	if (ret=="") ret=1;
	return ret;
}
function SearchOeOrdRowid(RowId)
{ //查询是否有对应的医嘱 打印当前页
 	var objtbl=document.getElementById('tDHCLONGTIMEORD');
	var i=0
	var rwstr="";
    for (i=1;i<objtbl.rows.length;i++)
    {
	    var rw=document.getElementById("ORWz"+i).innerText;
	    if (rw==RowId) return true;
    }  
   return false;
}





function XPrintClick(PrTyp)
{      
	  // var checkDate=parent.frames["RPtop"].document.getElementById("SelDate");
      // var checkall=parent.frames["RPtop"].document.getElementById("AllOrd");
	   var Adm=document.getElementById("Adm").value;
	   //alert(Adm)
	   var ExeLongQuery=document.getElementById("ExeLongQuery").value;
	   var Processj;
	   if(PrTyp==2){
		   //print curr content
		   }else{
	   Processj=ExeQuery(ExeLongQuery,Adm,DepNo,session['LOGON.USERID']);
	   }
	   //var test = String.fromCharCode(1);
	   var truthBeTold = window.confirm(t['alert:ifhaveprintwork']);
       if (!truthBeTold) {
	       return;
       }
      //  return;
	    var xlsExcel,xlsSheet,xlsBook;
	    var i,j;
        //alert(PrintDateTime);
        var  path = GetFilePath();
       // path="d:\\"
        var fileName="cqyz1.xls" ;//+ fileName;
        fileName=path+ fileName;
        //alert(fileName);
	    xlsExcel = new ActiveXObject("Excel.Application");
	    xlsBook = xlsExcel.Workbooks.Add(fileName) //;Open(fileName)
	    xlsSheet = xlsBook.ActiveSheet ;//  Worksheets(1)
	    var strj=Processj;  
	    if (PrTyp==2){ 
	    //Print curr content
		   strj=document.getElementById("ProcessNoz"+1).innerText;
	    }
        var GetItemNum=document.getElementById("GetItemNum").value;
	    var num=new Number(cspRunServerMethod(GetItemNum,Adm,strj));
	    var FetchPageRow=document.getElementById("schtystrow").value;
	    var TmpFetchPageRow=document.getElementById("TmpSch").value;
	    var KTmpSet=document.getElementById("KTmpSet").value;
	    //察看打印的页码和行数
	    var Res,TmpRes;
	    var Print;
	    var StPage=0,EdPage=0;
	    var StRow=0,EdRow=0;
	    var PageStr;
        var bdprn;
        var PRow=29;//每页行数
	    var pnum=0; //页数
	    var frw=2; 
	    var cols=9;
	    var PageNum=new Number(GetStPage("longord",Adm,Dep,DepNo));
	    //alert(PageNum)
	    var ClearStr="A1:I29";
        bdprn=false;
	    Print=false;
	    Res=cspRunServerMethod(FetchPageRow,"longord",Adm,Dep,DepNo);
	   // TmpRes=cspRunServerMethod(TmpFetchPageRow,"longord",Adm,Dep);
	    if ((BPRNSTR!="")||(PrTyp==2))
	    {
		  bdprn=true; 
		}
 	    if (bdprn)
 	    {  //补打设置
	       PageStr=BPRNSTR.split("|");
	       
           StPage=PageStr[0];
	       StRow=PageStr[1];
		   EdPage=PageStr[2];
		   EdRow=PageStr[3];
		  // alert(BPRNSTR)
	      if (PageStr[2]) 
	      {
		    var numb;
		    //alert(PageNum);
		    numb=(EdPage-PageNum)*(PRow-2)+(EdRow-2) ;  
		   // alert(numb);
		    if (numb<num){num=numb;}
		  }
		}
		if (bdprn==false){
	      if (Res=="") 
	      {
            Res= "0|0";
	      }
          PageStr=Res.split("|");
          StPage=PageStr[0];
	      StRow=PageStr[1];
		}
		if ((PrTyp==1)||(PrTyp==2))
		{ //全部打印
			//alert(PrTyp);
			StPage=1;
			StRow=2;
		}

		var ret

		//ret=cspRunServerMethod(KTmpSet,"longord",Adm,Dep); //清除补打设置
		for (i=1;i<num+1;i++)
	     {
		   var GetItem=document.getElementById("GetItem").value; 
		   var res=cspRunServerMethod(GetItem,i,Adm,strj);
		   //alert(res)
		   var data=res.split("^");
           var flag=true;
           if (PrTyp==2){
	           //打印当前页
            // flag=SearchOeOrdRowid(data[10]);
            flag=true;
           }
           if (flag==false) continue;
           if (data[4].indexOf(t['val:afterOp'],0)!=-1)
		   {  
		      data[5]="",data[6]="",data[7]="",data[8]="",data[9]="";
			  if (StPage>=PageNum)
			  {
			    	//套打加07/03/15
		         if (StRow==2){
		          gridset(xlsSheet,1,1,cols,1,11);
            	  gridlist(xlsSheet,1,PRow,1,cols);
			      titlegrid(xlsSheet,PageNum);
		          }
		         if ((PrTyp==1)||(PrTyp==2))
		         {
		          gridset(xlsSheet,1,1,cols,1,11);
            	  gridlist(xlsSheet,1,PRow,1,cols);
			      titlegrid(xlsSheet,PageNum);
			    }
			  }
			  else
			  {
			    gridset(xlsSheet,1,1,cols,1,11);
			    gridlist(xlsSheet,1,PRow,1,cols);
			    titlegrid(xlsSheet,PageNum);
			  }
			   PageNum+=1;
			   frw=2;
			   if (Print==true){
			   // xlsExcel.Visible = true;
               // xlsBook.PrintPreview;
                xlsSheet.PrintOut;
                ClearContents (xlsSheet,ClearStr);
               if ((PageNum>EdPage)&&(EdPage!=0)) break;
			   }
		   } 
		   if (((StPage==PageNum)&&(frw>=StRow))||(PageNum>StPage))
		   {
			 frw+=1;  
			 //alert(frw)
			 Print=true;
		     xfillgrid(xlsSheet,data,frw);
		   }
		   else
		   {
			   frw+=1;
			   	////////////////停过的医嘱打印签名070406qse
		       if (((StPage==PageNum)&&(frw<StRow)))
		       {
			    Print=true;
			    FillData(frw ,data, xlsSheet);
		       }

		   } 
		   Pres=(frw)%PRow;
		   //alert(frw+"^"+Pres)
		   if (Pres==0)
		   {
			  if (StPage>=PageNum)
			  {
			    	//套打加07/03/15
		         if (StRow==2){
		          gridset(xlsSheet,1,1,cols,1,11);
            	  gridlist(xlsSheet,1,PRow,1,cols);
			      titlegrid(xlsSheet,PageNum);
		          }
		         if ((PrTyp==1)||(PrTyp==2))
		         {
		          gridset(xlsSheet,1,1,cols,1,11);
            	  gridlist(xlsSheet,1,PRow,1,cols);
			      titlegrid(xlsSheet,PageNum);
			    }
			  }
			  else
			  {
			    gridset(xlsSheet,1,1,cols,1,11);
			    gridlist(xlsSheet,1,PRow,1,cols);
			    titlegrid(xlsSheet,PageNum);
			  }
			   PageNum+=1;
			   frw=2;
			   if (Print==true){
			   // xlsExcel.Visible = true;
               // xlsBook.PrintPreview;
                xlsSheet.PrintOut;
                ClearContents (xlsSheet,ClearStr);
			   }
		   } 
		 }
        if (frw>2)
        {
	        if ((StPage==PageNum)&&(frw>2)&&(StPage!=0))
	        {
		         if (StRow==2){
		          gridset(xlsSheet,1,1,cols,1,11);
            	  gridlist(xlsSheet,1,PRow,1,cols);
			      titlegrid(xlsSheet,PageNum);
		          }
		         if ((PrTyp==1)||(PrTyp==2))
		         {
		          gridset(xlsSheet,1,1,cols,1,11);
            	  gridlist(xlsSheet,1,PRow,1,cols);
			      titlegrid(xlsSheet,PageNum);
			    }

			}
		    else
		    {
			   gridset(xlsSheet,1,1,cols,1,11);
               gridlist(xlsSheet,1,PRow,1,cols);
			   titlegrid(xlsSheet,PageNum);
			   
			}
			if (Print==true){
			// xlsExcel.Visible = true;
            // xlsBook.PrintPreview;
             xlsSheet.PrintOut;
			}
	    }
	   // alert(PageNum)
	   if (bdprn==false){
        SavePageRow("longord",PageNum,frw,Dep,DepNo);
        var CurStat=document.getElementById("CurStatus");
        frw=frw-2;
        CurStat.value=t['val:xprn']+PageNum+t['val:page']+frw+t['val:Row'];

	   }
        xlsSheet = null;
        xlsBook.Close(savechanges=false);
        xlsBook = null;
        xlsExcel.Quit();
        xlsExcel = null;
        window.setInterval("Cleanup();",1);
}
function Cleanup() 
{   
    window.clearInterval(idTmr);   
    CollectGarbage();   
}
function SignPrintClick()
{
	   var Adm=document.getElementById("Adm").value;
	   ///var ExeLongQuery=document.getElementById("ExeTempQuery").value;
	   //var Processj;
	  // Processj=ExeQuery(ExeLongQuery,Adm,DepNo,session['LOGON.USERID']);
	   var truthBeTold = window.confirm(t['alert:ifhaveprintwork']);
       if (!truthBeTold) {
	       return;
       }
	    var pg = window.prompt(t['alert:inputpagenum'],1);
	    if (pg=="") return; 
	   // alert(pg);
	    if (pg)
	    {
		    var win=parent.frames;
            var print=win["RPtop"].document.getElementById("PrintCommOrd");
            printNurRec(print,pg+"||"+pg+"||","Y");
		}
		return
		
	    var xlsExcel,xlsSheet,xlsBook;
	    var i,j;
        //alert(PrintDateTime);
        var  path = GetFilePath();
       // path="d:\\"
        var fileName="cqyz1.xls" ;//+ fileName;
        fileName=path+ fileName;
       // alert(fileName);
	    xlsExcel = new ActiveXObject("Excel.Application");
	    //alert("also ok")
	    xlsBook = xlsExcel.Workbooks.Add(fileName) //;Open(fileName)
	    xlsSheet = xlsBook.ActiveSheet ;//  Worksheets(1)
	    var strj=Processj;  //document.getElementById("ProcessNoz"+2).innerText;
        var GetItemNum=document.getElementById("GetItemNum").value;
	    var num=new Number(cspRunServerMethod(GetItemNum,Adm,strj));
	    var FetchPageRow=document.getElementById("schtystrow").value;
	    //察看打印的页码和行数
	    var Res;
	    Res=cspRunServerMethod(FetchPageRow,"longord",Adm,Dep,DepNo);
	    var PageStr;
	    var Print;
	    Print=false;
	    if (Res=="") 
	    {
          Res= "0|0";
	    }
        else
        {
        }
        PageStr=Res.split("|");
        var StPage=PageStr[0];
	    var StRow=PageStr[1];
	    var PRow=29;//每页行数
	    var pnum=0; //页数
	    var frw=2; 
	    var cols=9;
	    var PageNum=new Number(GetStPage("longord",Adm,Dep,DepNo));
	    var ClearStr="A1:I29";
		for (i=1;i<num+1;i++)
	     {
		   var GetItem=document.getElementById("GetItem").value; 
		   var res=cspRunServerMethod(GetItem,i,Adm,strj);
		   var data=res.split("^");
		   if (data[4].indexOf(t['val:afterOp'],0)!=-1)
		   {
			  if (StPage>=PageNum)
			  {
			    
			  }
			  else
			  {

			    titlegrid(xlsSheet,PageNum);
			  }
			   PageNum+=1;
			   frw=2;
			  if (Print==true){
			   //xlsExcel.Visible = true;
               //xlsBook.PrintPreview;
               xlsSheet.PrintOut;
               ClearContents (xlsSheet,ClearStr);
               Print=false;
			  }
		   } 
		   if (((StPage==PageNum)&&(frw>=StRow))||(PageNum>StPage))
		   {
			 frw+=1;  
			// alert(frw)
		   }
		   else
		   {
			 frw+=1;
		     if (PageNum==pg)
		     {
			    Print=true;
			    FillData(frw ,data, xlsSheet);
			 }
			     
		   }
		   Pres=(frw)%PRow;
		   if (Pres==0)
		   {
			// alert(PageNum);
			  if (StPage>=PageNum)
			  {
			    
			  }
			  else
			  {
			    titlegrid(xlsSheet,PageNum);
			  }
			   PageNum+=1;
			   frw=2;
			  if (Print==true){
			   //xlsExcel.Visible = true;
               //xlsBook.PrintPreview;
               xlsSheet.PrintOut;
               ClearContents (xlsSheet,ClearStr);
               Print=false;
			  }
		   } 
		 }
        if (frw>2)
        {
	        //alert(PageNum)
	        if ((StPage==PageNum)&&(frw>2)&&(StPage!=0))
	        {
		        
		    }
		    else
		    {
			    titlegrid(xlsSheet,PageNum);
			   
			}
			if (Print==true){
             xlsSheet.PrintOut;
			}
	    }
        xlsSheet = null;
        xlsBook.Close(savechanges=false);
        xlsBook = null;
        xlsExcel.Quit();
        xlsExcel = null;
}
function SinglePagePrintClick() //打印
{
	   //var test = String.fromCharCode(1);
	   var truthBeTold = window.confirm(t['alert:ifhaveprintwork']);
       if (!truthBeTold) {
	       return;
       }

	    var pg = window.prompt(t['alert:inputpagenum'],1);
	    if (pg=="") return; 
	    var xlsExcel,xlsSheet,xlsBook;
	    var i,j;
        //alert(PrintDateTime);
        var  path = GetFilePath();
       // path="d:\\"
        var fileName="cqyz1.xls" ;//+ fileName;
        fileName=path+ fileName;
       // alert(fileName);
	    xlsExcel = new ActiveXObject("Excel.Application");
	    //alert("also ok")
	    var Adm=document.getElementById("Adm").value;
	    xlsBook = xlsExcel.Workbooks.Add(fileName) //;Open(fileName)
	    xlsSheet = xlsBook.ActiveSheet ;//  Worksheets(1)
	    var strj=document.getElementById("ProcessNoz"+2).innerText;
        var GetItemNum=document.getElementById("GetItemNum").value;
	    var num=new Number(cspRunServerMethod(GetItemNum,Adm,strj));
	    var FetchPageRow=document.getElementById("schtystrow").value;
	    //察看打印的页码和行数
	    var Res=cspRunServerMethod(FetchPageRow,"longord",Adm);
	    var PageStr;
	    var Print;
	    Print=false;
	    if (Res=="") 
	    {
          Res= "0|0";
	    }
        else
        {
        }
        PageStr=Res.split("|");
        var StPage=PageStr[0];
	    var StRow=PageStr[1];
	    var PRow=23;//每页行数
	    var pnum=0; //页数
	    var frw=2; 
	    var cols=9;
	    var PageNum=1;
	    var ClearStr="A1:I23";
		for (i=1;i<num+1;i++)
	     {
		   var GetItem=document.getElementById("GetItem").value; 
		   var res=cspRunServerMethod(GetItem,i,Adm,strj);
		   var data=res.split("^");
		   if (((StPage==PageNum)&&(frw>=StRow))||(PageNum>StPage))
		   {
			 frw+=1;  
			// alert(frw)
		   }
		   else
		   {
			 frw+=1;
		     if (PageNum==pg)
		     {
			    Print=true;
			    FillData(frw ,data, xlsSheet);
			 }
			     
		   }
		   Pres=(frw)%PRow;
		   //alert(frw+"^"+Pres)
		   if (Pres==0)
		   {
			// alert(PageNum);
			  if (StPage>=PageNum)
			  {
			    
			  }
			  else
			  {
			    gridset(xlsSheet,1,1,cols,1,11);
			    gridlist(xlsSheet,1,PRow,1,cols);
			    titlegrid(xlsSheet,PageNum);
			  }
			   PageNum+=1;
			   frw=2;
			  if (Print==true){
			   xlsExcel.Visible = true;
               xlsBook.PrintPreview;
               xlsSheet.PrintOut;
               ClearContents (xlsSheet,ClearStr);
			  }
		   } 
		 }
        if (frw>2)
        {
	        //alert(PageNum)
	        if ((StPage==PageNum)&&(frw>2)&&(StPage!=0))
	        {
		        
		    }
		    else
		    {
			    gridset(xlsSheet,1,1,cols,1,11);
            	gridlist(xlsSheet,1,PRow,1,cols);
			    titlegrid(xlsSheet,PageNum);
			   
			}
			if (Print==true){
			 xlsExcel.Visible = true;
             xlsBook.PrintPreview;
             xlsSheet.PrintOut;
			}
	    }
      //  SavePageRow("longord",PageNum,frw);

        xlsSheet = null;
        xlsBook.Close(savechanges=false);
        xlsBook = null;
        xlsExcel.Quit();
        xlsExcel = null;
        window.setInterval("Cleanup();",1); 
}
function Cleanup() 
{   
    window.clearInterval(idTmr);   
    CollectGarbage();   
}
function titlegrid(xlsSheet,PagNum)
{
        var titleRows = 0;titleCols = 0 ;//&chr(10)
		var CenterHeader = "&14"+""+"\r"+"";
	    var PatInfo=document.getElementById("Patinfo").value;
	    var Adm=document.getElementById("Adm").value;
	    //var info=cspRunServerMethod(PatInfo,"^"+Adm);
	    var Dep=document.getElementById("Dep").value;
	    var info=cspRunServerMethod(PatInfo,"^"+Adm,Dep);
	    var infoarr=info.split("^");
	    var getmother=document.getElementById("getmother").value;
	    var motherRegNo=cspRunServerMethod(getmother,Adm);
	    var mother=""
        if (motherRegNo!="")
        {
	        mother="mother:"+motherRegNo;
	    }
       //regno_"^"_ctloc_"^"_room_"^"_sex_"^"_patName_"^"_Bah_"^"_bedCode_"^"_age
	    //var  LeftHeader="\r\r\r&9"+"                "+infoarr[4]+"                     "+infoarr[1]+"        "+infoarr[2]+"              "+PagNum+"               "+infoarr[12]+mother;
	    //var  LeftHeader="\r\r\r&9"+"      "+t['val:patname']+":"+infoarr[4]+"    "+t['val:Dep']+infoarr[1]+"     "+t['val:bed']+infoarr[6]+"      "+t['val:regNo']+infoarr[0]+"  "+t['val:patRec']+infoarr[12];LeftFooter = "";CenterFooter = t['val:cFooter'];RightFooter = "";
	    var  LeftHeader="\r\r\r&9"+"    "+t['val:patname']+":"+infoarr[4]+"               "+t['val:Dep']+infoarr[1]+"                "+t['val:bed']+infoarr[6]+"              "+t['val:patRec']+infoarr[12];LeftFooter = "";CenterFooter = t['val:cFooter'];RightFooter = "";
        LeftFooter = "";CenterFooter = t['val:cFooter'];RightFooter = "";
        var CenterHeader = "&15"+hospitalDesc+"\r"+"&18"+t['val:longTimeSheet'];
	    var RightHeader = " ";RightFooter ="&10"+t['val:nurseSign']+"        "+t['SignTime']+"\r"+"    "+t['val:docSign']+"        "+t['SignTime']; ;LeftFooter = "";
	    var CenterFooter ="\r\r\r\r&10"+t['val:sort']+PagNum+t['val:page'];
        ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter) 
        //PrintPagNo(xlsSheet,PagNum,11,24)
}
function titlegrid1(xlsSheet,PagNum)
{
        var titleRows = 0;titleCols = 0 ;//&chr(10)
		var CenterHeader = "&14"+t['val:hospitalname']+"\r"+t['val:orddan'];
	    var PatInfo=document.getElementById("patinfo").value;
	    var Adm=document.getElementById("Adm").value;
	    var getmother=document.getElementById("getmother").value;
	    var info=cspRunServerMethod(PatInfo,Adm);
	    var infoarr=info.split("^");
	    //regno_"^"_ctloc_"^"_room_"^"_sex_"^"_patName_"^"_Bah_"^"_bedCode_"^"_age
	    var  LeftHeader="\r\r\r&9"+t['val:patname']+":"+infoarr[4]+"    "+t['val:Dep']+infoarr[1]+"     "+t['val:room']+infoarr[2]+"      "+t['val:regNo']+infoarr[0];LeftFooter = "";CenterFooter = t['val:cFooter'];RightFooter = "";
	    
	    var RightHeader = " ";LeftFooter = "";CenterFooter =""; ;RightFooter = "";
        ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter) 
        PrintPagNo(xlsSheet,PagNum,11,24)
}
function PrintPagNo(xlsSheet,pagno,rh,rw)
{
	 //&10负责医生签字                     "+"第 &P 页"+   负责护士签字"
	 SetRowH(xlsSheet ,rw+":"+rw, rh);
	 fontcell(xlsSheet,rw,1,6,10);
	 xlstyle(xlsSheet,rw,1,6,1)
	 xlsSheet.cells(rw,2)=t['val:docSign']+"                     "+t['val:sort']+pagno+t['val:page']+"               "+t['val:nurseSign']; 
}
function xfillgrid(xlsSheet,itm,frw)
{		   xlsSheet.cells(frw,1)=itm[0];
		   xlsSheet.cells(frw,2)=itm[1];
		   xlsSheet.cells(frw,3)=itm[2];
		   xlsSheet.cells(frw,4)=itm[3];
		   xlsSheet.cells(frw,5)=itm[4];
		   xlsSheet.cells(frw,6)=itm[5];
		   xlsSheet.cells(frw,7)=itm[6];
		   xlsSheet.cells(frw,8)=itm[7];
		   xlsSheet.cells(frw,9)=itm[8];
		  // alert(itm[10]);
		          if (itm[3] =="") 
		          {
                    a43 = "N";
		          }
                  else
                  {
                    a43 = "Y";
                  }
                   if (itm[5] == "") 
                    {
                    a67 = "N";
                    }
                    else
                    {
                    a67 = "Y";
                    }
                    if (itm[7] =="") 
                    {
                    a88 = "N";
                    }
                    else
                    {
                    a88 = "Y";
                    }
                    if (itm[8] == "") 
                    {
                    a912 = "N";
                    }
                    else
                    {
                    a912 = "Y";
                    }
       flag = a43 + "^" + a67 + "^" + a88 + "^" + a912
       saveordno("longord", itm[10], flag)

}
function SavePageRow(typ,Page,Row,Dep,DepNo)
{
		var startrow=document.getElementById("startrow").value;
	    var Adm=document.getElementById("Adm").value;
	    
	    var info=cspRunServerMethod(startrow,typ,Adm,Page.toString(),Row,Dep,DepNo);
	
}
 function FillData(Row , itm, objectxsl)
       {    
             var flag ;
             var a43, a67, a88, a912 ;
             flag = fetchordflag("longord", itm[10])
             if (flag=="Y^Y^Y^Y")
              return;
              var arr=flag.split("^")
              a43 = arr[0]  ;//Mid(flag, 1, 1)
              a67 = arr[1] ;//Mid(flag, 3, 1)
              a88 = arr[2] ;//Mid(flag, 5, 1)
              a912 =arr[3] ;// Mid(flag, 7, 1)
               if (a43=="Y") 
               {}
               else
                {
	                objectxsl.Cells(Row, 4).value = itm[3];
                    if (itm[3]!="")
                    {
                     a43 = "Y"
                    }
                }
               if (a67=="Y")
               {
               }
               else
               { 
                 objectxsl.Cells(Row, 6).value = itm[5]
                 objectxsl.Cells(Row, 7).value = itm[6]
                    if (itm[6]!="") 
                    {
                    a67 = "Y";
                    }
               }
               if (a88 =="Y")
               {
               }
               else
               { objectxsl.Cells(Row, 8).value = itm[7]
                  if (itm[7]!="")
                  {
                  a88 = "Y";
                  }
               }
               if (a912 =="Y")
               {}
               else
               {
                 objectxsl.Cells(Row, 9).value = itm[8];
                 if (itm[8]!="")
                 {
                   a912 = "Y";
                 }
               }
            
              flag = a43 + "^" + a67 + "^" + a88 + "^" + a912
              
              saveordno("longord", itm[10], flag);
  
       }
  
  function saveordno(typ,ord ,flag )
  {
       // alert(ord)
        var ford= ord.replace(String.fromCharCode(1), "||");
        var saveordno=document.getElementById("saveordno").value;
	    var info=cspRunServerMethod(saveordno,typ,ford,flag);
    //     vmdb.Execute "$$saveordno^DHCBLPRINTROW(P0,P1,P2)"
  }
  function fetchordflag(typ,ord)
   {
     var ford= ord.replace(String.fromCharCode(1), "||")
     var fetchordno=document.getElementById("fetchordno").value;
	 var info=cspRunServerMethod(fetchordno,typ,ford);
	 return info;
 }
