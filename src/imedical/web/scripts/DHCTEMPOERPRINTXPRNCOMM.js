var hospitalDesc=""
var idTmr=""

var PageNum=""

function CleanupL() 
{   
    window.clearInterval(idTmr);   
    CollectGarbage();   
}

function titlegridtmpItfaceL(xlsSheet,PagNum,Adm)
{    var titleRows = 0;titleCols = 0 ;//&chr(10)
		 var CenterHeader = "&14"+""+"\r"+"";
	   var info=tkMakeServerCall("web.DHCCLCom","PatInfo","^"+Adm,"");
	   var infoarr=info.split("^");
	   var curhospitalDesc=tkMakeServerCall("web.DHCCLCom","GetHospital");  //HYD20110621
	   var motherRegNo=tkMakeServerCall("web.DHCTEMPOERPRINT","getmother",Adm);
	   var mother=""
     if (motherRegNo!="")
        {
	        mother="mother:"+motherRegNo;
	    }
	    //var  LeftHeader="\r\r\r&9    "+t['val:patname']+":"+infoarr[4]+"              "+t['val:Dep']+infoarr[1]+"                "+t['val:bed']+infoarr[6]+"              "+t['val:patRec']+infoarr[12];LeftFooter = "";CenterFooter = t['val:cFooter'];RightFooter = "";
	    var  LeftHeader="\r\r\r&9    "+"姓名:"+":"+infoarr[4]+"              "+"科别:"+infoarr[1]+"                "+"床号:"+infoarr[6]+"              "+"住院号:"+infoarr[12];LeftFooter = "";CenterFooter = "&10第 &P 页";RightFooter = "";
        LeftFooter = "";CenterFooter = t['val:cFooter'];RightFooter = "";
	    //var CenterHeader = "&15"+hospitalDesc+"\r"+"&18"+t['val:tempOrdSheet'];
	    var CenterHeader = "&15"+curhospitalDesc+"\r"+"&18"+"临 时 医 嘱 单";
	    //var RightHeader = " ";RightFooter ="\r&10"+t['val:nurseSign']+"        "+t['SignTime']+"\r&10"+"    "+t['val:docSign']+"        "+t['SignTime']; ;LeftFooter = "";                                
	    var RightHeader = " ";RightFooter ="\r&10"+"护士签名"+"        "+"."+"\r&10"+"    "+"医生签名"+"        "+"."; ;LeftFooter = "";
	    //var CenterFooter ="\r\r\r\r&10"+t['val:sort']+PagNum+t['val:page'] ;
	    var CenterFooter ="\r\r\r\r&10"+"第"+PagNum+"页" ;
        ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter) 
        //PrintPagNo(xlsSheet,PagNum,11,24)
}

function xfillgridtmpItfaceL(xlsSheet,itm,frw)
{
		  var a43,a54,a65,flag;
		   xlsSheet.cells(frw,1)=itm[0];
		   xlsSheet.cells(frw,2)=itm[1];
		   xlsSheet.cells(frw,3)=itm[2];
		   xlsSheet.cells(frw,4)=itm[3];
		   xlsSheet.cells(frw,5)=itm[5];
		   xlsSheet.cells(frw,6)=itm[6];
		   //xlsSheet.cells(frw,7)=itm[6];
		   //alert (itm[8]);
		   var str1=itm[8];
		   var inx=str1.indexOf("DC",0);
		   //alert(inx)
           if(inx!=-1)
		        {
                     a43 = "Y";
		        }
                else
                {
                     a43 = "N";
                }
                if (itm[4]=="") 
                {
                  a54 = "N";
                }
               else
                {
                  a54 = "Y";
                }
                if (itm[6]=="")
                  {
                  a65 = "N";
                  }
                else
                {
                  a65 = "Y";
                }
                flag = a43 + "^" + a54 + "^" + a65;
                //saveordno("lsord", itm[7], flag);

} 
   
function lsFillDataItfaceL(Row , itm , objectxsl ) //临时医属
   {   var flag;
       var a43, a54, a65 ;
       var skg;
       flag = fetchordflag("lsord", itm[7])
       if (flag =="Y^Y^Y") 
       return;
      // alert(flag);
       var arr=flag.split("^");         
              a43 =arr[0];
              a54 =arr[1];
              a65 =arr[2];
               if (a43=="Y") 
               {
	           }
               else
               {    
                   var str=itm[2];
                    if (str.search("DC")!=-1)
                     {
	                    // alert(itm[2])
	                    var j;
	                   
	                    skg="";
	                    //alert(skg)
	                    for (j=1;j<34;j++)
	                    {
		                    skg=skg+" ";
		                }
		                
                       objectxsl.Cells(Row, 3).value = skg+"----DC";
                      // alert(skg)
                       //arratem(addnum) = Row
                       //addnum = addnum + 1
                       a43 = "Y"
                     }
               }
               if (a54=="Y")
               {
	           }
               else
               {   
                    objectxsl.Cells(Row, 5).value = itm[5];
                    if (itm[4]!="") 
                    {
                    a54 = "Y";
                    }
               }
               if(a65=="Y")
               {
	           }
               else
               {
                  objectxsl.Cells(Row, 6).value = itm[6];
                 // objectxsl.Cells(Row, 7).value = itm[6];
                  if (itm[6]!="") 
                  {
                  a65 = "Y";
                  }
               }
              
              flag = a43 + "^" + a54 + "^" + a65;
              //saveordno("lsord", itm[7], flag);
   }
      
 
 
function XPrintTempClick(PrTyp,curadm)
{     
	   //var Adm=document.getElementById("Adm").value;                //HYD20110621
	   var Adm=curadm
	   //var ExeLongQuery=document.getElementById("ExeTempQuery").value;  //HYD20110621
	   var Processj;
	   if (PrTyp==2){}else{  
	   //Processj=ExeQuery(ExeLongQuery,Adm,DepNo,session['LOGON.USERID']);     //HYD20110621
     Processj=tkMakeServerCall("web.DHCLONGTIMEORD","ExeTempQuery",Adm,"ALL",session['LOGON.USERID'])
	   }
	   
	   //var truthBeTold = window.confirm(t['alert:ifhaveprintwork']);
     //  if (!truthBeTold) {
	   //    return;
     //  }
       
       
      var xlsExcel,xlsSheet,xlsBook;
	    var i,j;
      //var  path = GetFilePath();
      var path=tkMakeServerCall("web.DHCLCNUREXCUTE","GetPath")
      var fileName="lsyz1.xls" ;//+ fileName;
      fileName=path+ fileName;
	    xlsExcel = new ActiveXObject("Excel.Application");
	    //var Adm=document.getElementById("Adm").value;        //HYD20110621
	    
	    xlsBook = xlsExcel.Workbooks.Add(fileName) //;Open(fileName)
	    xlsSheet = xlsBook.ActiveSheet ;//  Worksheets(1)
	   	var strj=Processj; 
	   	if (PrTyp==2){
		   	//strj=document.getElementById("ProcessNoz"+1).innerText;    //HYD20110621
	  
	   	}
      //var GetItemNum=document.getElementById("GetItemNum").value;   //HYD20110621
	    //var num=new Number(cspRunServerMethod(GetItemNum,Adm,strj));  //HYD20110621
	    var num=new Number(tkMakeServerCall("web.DHCTEMPOERPRINT","GetItemNum",Adm,strj));
	    //var FetchPageRow=document.getElementById("schtystrow").value;   //HYD20110621
	    // var TmpFetchPageRow=document.getElementById("TmpSch").value;    //HYD20110621
      // var KTmpSet=document.getElementById("KTmpSet").value;           //HYD20110621
	
	    //察看打印的页码和行数
	    var Res,TmpRes;
	    var Print;
	    var StPage=0,EdPage=0;
	    var StRow=0,EdRow=0;
	    var PageStr;
        var bdprn;
        var PRow=28;//每页行数
	    var pnum=0; //页数
	    var frw=1; 
	    var cols=7;
	    //var PageNum=new Number(GetStPage("lsord",Adm,Dep,DepNo));       //HYD20110621
	    
	    var PageNum=1;
	    
	    var ClearStr="A1:G28";

      bdprn=false;
	    Print=false;
	    //HYD20110621
	    /*
	    Res=cspRunServerMethod(FetchPageRow,"lsord",Adm,Dep,DepNo);
	    if ((BPRNSTR!="")||(PrTyp==2)){
		   bdprn= true;   
		    }
 	    if (bdprn)
 	    {  //补打设置
	       PageStr=BPRNSTR.split("|");
           StPage=PageStr[0];
	       StRow=PageStr[1];
		   EdPage=PageStr[2];
		   EdRow=PageStr[3];
		  if (BPRNSTR) 
	      {
		    var numb;
		   // alert(PageNum)
		    numb=(EdPage-PageNum)*(PRow-1)+(PageStr[3]-1) ;
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
		*/
		//HYD20110621
		if ((PrTyp==1)||(PrTyp==2)){
		   StPage=1;
	     StRow=1;
			}
		var ret
		//ret=cspRunServerMethod(KTmpSet,"lsord",Adm,Dep,DepNo) ; 
		var rows;
		for (i=1;i<num+1;i++)
	     {
		   //var GetItem=document.getElementById("GetItem").value;     //HYD20110621
		   //var res=cspRunServerMethod(GetItem,i,Adm,strj);           //HYD20110621
		   var res=tkMakeServerCall("web.DHCTEMPOERPRINT","GetItem",i,Adm,strj);
		   var data=res.split("^");
	       var flag=true;
           if (PrTyp==2){
	           //打印当前页
            //flag=SearchOeOrdRowid(data[7]);
            flag=true;
           
           }
          
          
           if (flag==false) continue;
		   if (((StPage==PageNum)&&(frw>=StRow))||(PageNum>StPage))
		   {
			 frw+=1; 
		     //xfillgrid(xlsSheet,data,frw);
		     xfillgridtmpItfaceL(xlsSheet,data,frw);               //HYD20110621
		     Print=true;
		   }
		   else
		   {
		      frw+=1;
		   			   	////////////////停过的医嘱打印签名070406qse
		       if (((StPage==PageNum)&&(frw<StRow)))
		       {
			    Print=true;
			    //lsFillData(frw ,data, xlsSheet);             //HYD20110621
			    lsFillDataItfaceL(frw ,data, xlsSheet);
		       }

		   }
		   Pres=(frw)%PRow;
		   //
		   //(frw+"^"+Pres)
		   if (Pres==0)
		   {
			// alert(PageNum);
			  if (StPage>=PageNum)
			  {
			     /*if (StRow==1)
		        {			    
		        gridset(xlsSheet,1,1,cols,1,9);
            	gridlist(xlsSheet,1,PRow,1,cols);
			    titlegrid(xlsSheet,PageNum);
                }*/
                if (StRow==1) // + "续打"或"补打"改进 090310
		     	{
			     	if (PrTyp==0)
			        {
				      	if (PageNum>=StPage)  
				          {
					          gridsettmpItfaceL(xlsSheet,1,1,cols,1,9);            //HYD20110621
            	           	  gridlist(xlsSheet,1,PRow,1,cols);
			               	  titlegridtmpItfaceL(xlsSheet,PageNum,Adm);           //HYD20110621   
				          }
 			        } 
			     	else        			    
		           	{
			          	if ((PrTyp==1)||(PrTyp==2))
			         	{ 
			         		gridsettmpItfaceL(xlsSheet,1,1,cols,1,9);             //HYD20110621
            	      		gridlist(xlsSheet,1,PRow,1,cols);
			                titlegridtmpItfaceL(xlsSheet,PageNum,Adm);            //HYD20110621
			            }      
		            }
                 }  // +
  
			   // titlegridkong(xlsSheet);
			  }
			  else
			  {
			    gridsettmpItfaceL(xlsSheet,1,1,cols,1,9);                  //HYD20110621
			    gridlist(xlsSheet,1,PRow,1,cols);
			    titlegridtmpItfaceL(xlsSheet,PageNum,Adm);                    //HYD20110621
			  }
			   PageNum+=1;
			   frw=1;
			  // xlsExcel.Visible = true;
              // xlsBook.PrintPreview;
               xlsSheet.PrintOut;
               ClearContents (xlsSheet,ClearStr);

		   } 
		 }
        if (frw>1)
        {
	        if ((StPage==PageNum)&&(frw>1)&&(StPage!=0))
	        {
		      //titlegridkong(xlsSheet);
		      if (StRow==1)
		      {	
		        gridsettmpItfaceL(xlsSheet,1,1,cols,1,9);              //HYD20110621
          gridlist(xlsSheet,1,PRow,1,cols);
			       titlegridtmpItfaceL(xlsSheet,PageNum,Adm);                //HYD20110621
              }
		    }
		    else
		    {
			    gridsettmpItfaceL(xlsSheet,1,1,cols,1,9);              //HYD20110621
            	gridlist(xlsSheet,1,PRow,1,cols);
			    titlegridtmpItfaceL(xlsSheet,PageNum,Adm);                 //HYD20110621

			}
			 if (Print==true)
			 {
			// xlsExcel.Visible = true;
             //xlsBook.PrintPreview;
             xlsSheet.PrintOut;
			 }
	    }
	    if (bdprn==false){
		
        //SavePageRow("lsord",PageNum,frw,Dep,DepNo);                 //HYD20110621
        //var CurStat=document.getElementById("CurStatus");           //HYD20110621
        frw=frw-1;
        //CurStat.value=t['val:xprn']+PageNum+t['val:page']+frw+t['val:Row'];    //HYD20110621

	    }

        xlsSheet = null;
        xlsBook.Close(savechanges=false);
        xlsBook = null;
        xlsExcel.Quit();
        xlsExcel = null;
        window.setInterval("CleanupL();",1); 
}
 