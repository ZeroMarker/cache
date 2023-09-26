var BPRNSTR;
BPRNSTR="";
var idTmr=""
var hospitalDesc=""



function XPrintLongClick(PrTyp,curadm)
{      
	   var Adm=curadm
	   var useridStr=tkMakeServerCall("web.DHCLONGTIMEORD","ExeLongQuery",Adm,"ALL",session['LOGON.USERID'])
	   var Processj;
	   if(PrTyp==2){
		   //print curr content
		   }else{
	    Processj=tkMakeServerCall("web.DHCLONGTIMEORD","ExeLongQuery",Adm,"ALL",session['LOGON.USERID'])
	   }
	
	    var xlsExcel,xlsSheet,xlsBook;
	    var i,j;
      var path=tkMakeServerCall("web.DHCLCNUREXCUTE","GetPath")

        var fileName="cqyz1.xls" ;//+ fileName;
        fileName=path+ fileName;
        //alert(fileName);
	    xlsExcel = new ActiveXObject("Excel.Application");
	    xlsBook = xlsExcel.Workbooks.Add(fileName) //;Open(fileName)
	    xlsSheet = xlsBook.ActiveSheet ;//  Worksheets(1)
	   // xlsExcel.Visible = true
	    var strj=Processj;  
	    var num=new Number(tkMakeServerCall("web.DHCLONGTIMEORD","GetItemNum",Adm,strj));
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
	    var PageNum=1
	    //alert(PageNum)
	    var ClearStr="A1:I29";
      bdprn=false;
	    Print=false;
	    if ((BPRNSTR!="")||(PrTyp==2))
	    {
		  bdprn=true; 
		}

		if ((PrTyp==1)||(PrTyp==2))
		{ //全部打印
			//alert(PrTyp);
			StPage=1;
			StRow=2;
		}
		var ret

		for (i=1;i<num+1;i++)
	     {
		   var res=tkMakeServerCall("web.DHCLONGTIMEORD","GetItem",i,Adm,strj);
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
		            gridsetItface(xlsSheet,1,1,cols,1,11);
            	  gridlist(xlsSheet,1,PRow,1,cols);
			          titlegridItface(xlsSheet,PageNum,Adm);
		          }
		         if ((PrTyp==1)||(PrTyp==2))
		         {
		          	gridsetItface(xlsSheet,1,1,cols,1,11);
            	  gridlist(xlsSheet,1,PRow,1,cols);
			      		titlegridItface(xlsSheet,PageNum,Adm);
			    }
			  }
			  else
			  {
			    gridsetItface(xlsSheet,1,1,cols,1,11);
			    gridlist(xlsSheet,1,PRow,1,cols);
			    titlegridItface(xlsSheet,PageNum,Adm);
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
		     xfillgridItface(xlsSheet,data,frw);
		   }
		   else
		   {
			   frw+=1;
			   	////////////////停过的医嘱打印签名070406qse
		       if (((StPage==PageNum)&&(frw<StRow)))
		       {
			    Print=true;
			    FillDataItface(frw ,data, xlsSheet);
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
		            gridsetItface(xlsSheet,1,1,cols,1,11);
            	  gridlist(xlsSheet,1,PRow,1,cols);
			          titlegridItface(xlsSheet,PageNum,Adm);
		          }
		         if ((PrTyp==1)||(PrTyp==2))
		         {
		           gridsetItface(xlsSheet,1,1,cols,1,11);
            	 gridlist(xlsSheet,1,PRow,1,cols);
			         titlegridItface(xlsSheet,PageNum,Adm);
			    }
			  }
			  else
			  {
			    gridsetItface(xlsSheet,1,1,cols,1,11);
			    gridlist(xlsSheet,1,PRow,1,cols);
			    titlegridItface(xlsSheet,PageNum,Adm);
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
		          	gridsetItface(xlsSheet,1,1,cols,1,11);
            	  gridlist(xlsSheet,1,PRow,1,cols);
			      		titlegridItface(xlsSheet,PageNum,Adm);
		          }
		         if ((PrTyp==1)||(PrTyp==2))
		         {
		          	gridsetItface(xlsSheet,1,1,cols,1,11);
            	  gridlist(xlsSheet,1,PRow,1,cols);
			      	  titlegridItface(xlsSheet,PageNum,Adm);
			    }

			}
		    else
		    {
			   		gridsetItface(xlsSheet,1,1,cols,1,11);
            gridlist(xlsSheet,1,PRow,1,cols);
			   		titlegridItface(xlsSheet,PageNum);
			   
			}
			if (Print==true){
			// xlsExcel.Visible = true;
            // xlsBook.PrintPreview;
             xlsSheet.PrintOut;
			}
	    }
	   // alert(PageNum)
	   if (bdprn==false){
        //SavePageRow("longord",PageNum,frw,Dep,DepNo);
        //var CurStat=document.getElementById("CurStatus");
        frw=frw-2;
        //CurStat.value=t['val:xprn']+PageNum+t['val:page']+frw+t['val:Row'];

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

function titlegridItface(xlsSheet,PagNum,Adm)
{
      var titleRows = 0;titleCols = 0 ;//&chr(10)
		  var CenterHeader = "&14"+""+"\r"+"";
		  var MedCareNo=tkMakeServerCall("web.DHCCLCom","GetMedCareNo",Adm);
		  var info=tkMakeServerCall("web.DHCCLCom","PatInfo","^"+Adm,"");
		  var infoarr=info.split("^");
		  var curhospitalDesc=tkMakeServerCall("web.DHCCLCom","GetHospital");
	    var motherRegNo=tkMakeServerCall("web.DHCTEMPOERPRINT","getmother",Adm);
	    var mother=""
        if (motherRegNo!="")
        {
	        mother="mother:"+motherRegNo;
	    }
       //regno_"^"_ctloc_"^"_room_"^"_sex_"^"_patName_"^"_Bah_"^"_bedCode_"^"_age
	    //var  LeftHeader="\r\r\r&9"+"    "+t['val:patname']+":"+infoarr[4]+"               "+t['val:Dep']+infoarr[1]+"                "+t['val:bed']+infoarr[6]+"              "+t['val:patRec']+infoarr[12];LeftFooter = "";CenterFooter = t['val:cFooter'];RightFooter = "";
      var  LeftHeader="\r\r\r&9"+"    "+"姓名:"+":"+infoarr[4]+"               "+"科别:"+infoarr[1]+"                "+"床号:"+infoarr[6]+"              "+"病案号:"+infoarr[12];LeftFooter = "";CenterFooter = "&10第 &P 页";RightFooter = "";
      //LeftFooter = "";CenterFooter = t['val:cFooter'];RightFooter = "";
      LeftFooter = "";CenterFooter = "&10第 &P 页";RightFooter = ""; 
      //var CenterHeader = "&15"+hospitalDesc+"\r"+"&18"+t['val:longTimeSheet'];
      var CenterHeader = "&15"+curhospitalDesc+"\r"+"&18"+"长 期 医 嘱 单";
	    //var RightHeader = " ";RightFooter ="&10"+t['val:nurseSign']+"        "+t['SignTime']+"\r"+"    "+t['val:docSign']+"        "+t['SignTime']; ;LeftFooter = "";
	    var RightHeader = " ";RightFooter ="&10"+"护士签名"+"        "+"."+"\r"+"    "+"医生签名"+"        "+"."; ;LeftFooter = "";
	    //var CenterFooter ="\r\r\r\r&10"+t['val:sort']+PagNum+t['val:page'];
      var CenterFooter ="\r\r\r\r&10"+"第"+PagNum+"页"; 
      ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter) 
      //PrintPagNo(xlsSheet,PagNum,11,24)
}


function xfillgridItface(xlsSheet,itm,frw)
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
       //saveordno("longord", itm[10], flag)

}

function FillDataItface(Row , itm, objectxsl)
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
              
              //saveordno("longord", itm[10], flag);
  
       }
  
