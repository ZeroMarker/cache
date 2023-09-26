    function opappprn()  //operation application print(detail selected),status:apply 
    {
	 // try{
	    var xlsExcel,xlsSheet,xlsBook;
        var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
        var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
        var path,fileName,fso;
        var objtbl=document.getElementById('tUDHCANPATMAIN');
        var GetQtPrintData=document.getElementById("GetQtPrintData").value;
        var curNum=0;
       // fileName=path + "OPAPP.xls";
        path=GetFilePath();
        fileName=path+"opapprp.xls";
        //alert(fileName)
        //fileName="C:\\opapprp.xls";
	    xlsExcel = new ActiveXObject("Excel.Application");
	    xlsBook = xlsExcel.Workbooks.Add(fileName) //;Open(fileName)
	    xlsSheet = xlsBook.ActiveSheet //  Worksheets(1)
	    var hospitalDesc=document.getElementById("hospital").value
   	    for (i=1;i<objtbl.rows.length;i++)  
	     {   
            var stat=document.getElementById("statusz"+i).innerText;
            var SelItem = document.getElementById("SelItemz" + i);
            if ((stat == t["val:apply"]) && (SelItem.checked == true))
            { 
                var pos,startRow;
                startRow=15*curNum;  //pos=1;
                //alert (startRow+"/");
                pos=startRow+1;var row=pos;
                //mergcell(xlsSheet,row,1,11);
                //xlcenter(xlsSheet,pos,1,11);
                
                CenterHeader =hospitalDesc+" "+ t['val:operApplySheet']
                xlsSheet.cells(row,1)=CenterHeader;
                fontcell(xlsSheet,row,1,1,16);
                var rw=document.getElementById("opaIdz"+i).innerText;
                var prtdata=cspRunServerMethod(GetQtPrintData,rw);
                var str=prtdata.split("^");
                //alert(str);
                //	 s str=printdt_"^"_bedcode_"^"_opmem_"^"_mzz_"^"_ash_"^"_xsh_"^"_xch
                pos=startRow+3;var row=pos;
                xlsSheet.cells(row,1)=t['val:annouceDate']+str[0];
               // if (str[0]) xlsSheet.cells(row,2)=
                xlsSheet.cells(row,9)=t['val:operDate']+document.getElementById("opdatez"+i).innerText;
                
               // xlsSheet.cells(row,10)=
                pos=startRow+4 ;row=pos;
                xlsSheet.cells(row,1)=t['val:regNo'];
                xlsSheet.cells(row,2)=document.getElementById("regnoz"+i).innerText;
              //  alert(document.getElementById("regnoz"+i).innerText);
                xlsSheet.cells(row,3)=t['val:loc'];
                var loc=document.getElementById("locz"+i).innerText;
                var locarr=loc.split("-");
                xlsSheet.cells(row,4)=locarr[1];
                xlsSheet.cells(row,5)=t['val:name'];
                xlsSheet.cells(row,6)=document.getElementById("patnamez"+i).innerText;
                xlsSheet.cells(row,7)=t['val:sex'];
                xlsSheet.cells(row,8)=document.getElementById("sexz"+i).innerText;
                xlsSheet.cells(row,9)=t['val:age'];
                var age=document.getElementById("agez"+i).innerText;
                var agearr=age.split("Y");
                xlsSheet.cells(row,10)=agearr[0];
                xlsSheet.cells(row,11)=t['val:bed'];//+document.getElementById("bednoz"+i).innerText;
                if (str[1])  xlsSheet.cells(row,12)=str[1]; //patloc	ward	bedcode 	type
                pos=startRow+5;var row=pos;
                xlsSheet.cells(row,1)=t['val:specInject'];xlsSheet.cells(row,2)=document.getElementById("yyz"+i).innerText;
                xlsSheet.cells(row,7)=t['val:type'];xlsSheet.cells(row,8)=document.getElementById("jzstatz"+i).innerText;
               
                pos=startRow+6;var row=pos;//;+(singtotal*no);
                xlsSheet.cells(row,1)=t['val:dialog'];xlsSheet.cells(row,2)=document.getElementById("diagz"+i).innerText;
               
                pos=startRow+7;var row=pos;
                xlsSheet.cells(row,1)=t['val:operName'];xlsSheet.cells(row,2)=document.getElementById("opnamez"+i).innerText;
              
                pos=startRow+8;var row=pos;
                xlsSheet.cells(row, 1) = t['val:operDoc'];
                var operDocs = document.getElementById("opdocz" + i).innerText.split(/[, ]/g);
                //xlsSheet.cells(row, 2) = document.getElementById("opdocz" + i).innerText;
                xlsSheet.cells(row, 2) = operDocs[0]
                var ass=str[4].split(" ");
               if (ass[0]) xlsSheet.cells(row,4)=ass[0]; //assist
               if (ass[1]) xlsSheet.cells(row,6)=ass[1]; //assist
               if (ass[2]) xlsSheet.cells(row,8)=ass[2]; //assist
                pos=startRow+9;var row=pos;
                xlsSheet.cells(row,1)=t['val:operNeeds'];
                if (str[2]) xlsSheet.cells(row,2)=str[2];
                var mz=str[3].split(" ");
                pos=startRow+10;var row=pos;
                xlsSheet.cells(row,1)=t['val:aneasthist'];
                xlsSheet.cells(row,2)=mz[0]
                xlsSheet.cells(row,3)=mz[1];
                xlsSheet.cells(row,5)=t['val:changeDuty'];
                xlsSheet.cells(row,6)=mz[2];
                xlsSheet.cells(row,6)=mz[3];
                xlsSheet.cells(row, 8) = t['val:aneasthMethod'];
                xlsSheet.cells(row,10)=document.getElementById("anmethodz"+i).innerText;
                 //alert(document.getElementById("anmethodz"+i).innerText);
                pos=startRow+11;var row=pos;
                xlsSheet.cells(row,1)=t['val:operRoom'];//xlsSheet.cells(row,2)=document.getElementById("oproomz"+i).innerText;
                xlsSheet.cells(row,3)=t['val:roomOrder'];//xlsSheet.cells(row,4)=document.getElementById("opordnoz"+i).innerText;
                //xlsSheet.cells(row,5)="OperPackage";xlsSheet.cells(row,6)=document.getElementById("oppackz"+i).innerText;
              
                pos=startRow+12 ;row=pos;
                xlsSheet.cells(row,1)=t['val:scrubNurse'];
                var sr=document.getElementById("scrubnursez"+i).innerText;
                var srarr=sr.split(" ");
                xlsSheet.cells(row,2)=srarr[0];
                xlsSheet.cells(row,3)=srarr[1];
                xlsSheet.cells(row,4)=t['val:circulNurse'];
                var cir=document.getElementById("circulnursez"+i).innerText;
                var cirarr=cir.split(" ");
                xlsSheet.cells(row,5)=cirarr[0];
                xlsSheet.cells(row,6)=cirarr[1];
               // alert(cirarr);
                //apploc		appdoc		adddate				
                var qxnur=str[5].split(" ")
                var xhnur=str[6].split(" ")
                pos=startRow+13 ;row=pos;
                xlsSheet.cells(row,1)=t['val:changeScrubNurse'];
                xlsSheet.cells(row,4)=t['val:changeCirculNurse'];
                if (qxnur[2]) xlsSheet.cells(row,2)=qxnur[2];
                if (qxnur[3]) xlsSheet.cells(row,3)=qxnur[3];
                if (xhnur[2]) xlsSheet.cells(row,5)=xhnur[2];
                if (xhnur[3]) xlsSheet.cells(row,6)=xhnur[3];
                xlsSheet.cells(14,9)=t['val:masterSign'];
                //AddGrid(xlsSheet,0,0,9,11,pos,1)
                //xlsExcel.Visible = true;
                //xlsSheet.PrintPreview ;
                //xlsSheet.PrintOut();
                //ClearContents(xlsSheet,"A4:L13");
                curNum=curNum+1
            }
        }
        //if (framePrint=="Y") AddFrame(xlsSheet,0,0,printList.length,cols-1,actRow+ 1, 1) //add frame
        //xlsExcel.Visible = true
       // xlsSheet.PrintPreview 
        xlsSheet.PrintOut(); 

        xlsSheet = null;
        xlsBook.Close(savechanges=false)
        xlsBook = null;
        xlsExcel.Quit();
        xlsExcel = null;
	   //}
      //  catch(e)
      //  {
	   //     alert(e.toString());
	      //  xlsExcel.Quit();

	 //   }

	}   
function optzPRN()  //operation announce print(detail selected):status:arranged
    {
	 // try{
	    var xlsExcel,xlsSheet,xlsBook;
        var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
        var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
        var path,fileName,fso;
        var objtbl=document.getElementById('tUDHCANPATMAIN');
        var GetQtPrintData=document.getElementById("GetQtPrintData").value;
        //alert(GetQtPrintData)
       // fileName=path + "OPAPP.xls";
        path=GetFilePath();
        fileName=path+"opapprp.xls";
        //fileName="C:\\opapprp.xls";
	    xlsExcel = new ActiveXObject("Excel.Application");
	    xlsBook = xlsExcel.Workbooks.Add(fileName) //;Open(fileName)
	    xlsSheet = xlsBook.ActiveSheet //  Worksheets(1)
   	    for (i=1;i<objtbl.rows.length;i++)  
	     {   
            var stat=document.getElementById("statusz"+i).innerText;
            var SelItem=document.getElementById("SelItemz"+i);
            if ((stat==t["val:arrange"])&&(SelItem.checked==true)) //arranged and select pat
            { 
                var pos;
               // alert (myData[i]);
                var hospitalDesc=document.getElementById("hospital").value
                CenterHeader =hospitalDesc+" "+ t['val:operArrangeSheet'];
                pos=1;var row=pos;
                xlsSheet.cells(row,1)=CenterHeader;
                fontcell(xlsSheet,row,1,1,16);
                var rw=document.getElementById("opaIdz"+i).innerText;
                var prtdata=cspRunServerMethod(GetQtPrintData,rw);
                var str=prtdata.split("^");
                //	 s str=printdt_"^"_bedcode_"^"_opmem_"^"_mzz_"^"_ash_"^"_xsh_"^"_xch
                pos=3;var row=pos;
                xlsSheet.cells(row,1)=t['val:annouceDate']+str[0];
               // if (str[0]) xlsSheet.cells(row,2)=
                xlsSheet.cells(row,9)=t['val:operDate']+document.getElementById("opdatez"+i).innerText;
               // xlsSheet.cells(row,10)=
                pos=4 ;row=pos;
                xlsSheet.cells(row,1)=t['val:regNo'];
                xlsSheet.cells(row,2)=document.getElementById("regnoz"+i).innerText;
              //  alert(document.getElementById("regnoz"+i).innerText);
                xlsSheet.cells(row,3)=t['val:loc'];
                var loc=document.getElementById("locz"+i).innerText;
                var locarr=loc.split("/");//("-");
                xlsSheet.cells(row,4)=locarr[0];//[1];
                xlsSheet.cells(row,5)=t['val:name'];
                xlsSheet.cells(row,6)=document.getElementById("patnamez"+i).innerText;
                xlsSheet.cells(row,7)=t['val:sex'];
                xlsSheet.cells(row,8)=document.getElementById("sexz"+i).innerText;
                xlsSheet.cells(row,9)=t['val:sex'];
                var age=document.getElementById("agez"+i).innerText;
                var agearr=age.split("Y");
                xlsSheet.cells(row,10)=agearr[0];
                xlsSheet.cells(row,11)=t['val:bed'];//+document.getElementById("bednoz"+i).innerText;
                if (str[1])  xlsSheet.cells(row,12)=str[1]; //admloc	ward	bed		type
                pos=5;var row=pos;
                xlsSheet.cells(row,1)=t['val:specInject'];xlsSheet.cells(row,2)=document.getElementById("yyz"+i).innerText;
                xlsSheet.cells(row,7)=t['val:type'];xlsSheet.cells(row,8)=document.getElementById("jzstatz"+i).innerText;
               
                pos=6;var row=pos;//;+(singtotal*no);
                xlsSheet.cells(row,1)=t['val:dialog'];xlsSheet.cells(row,2)=document.getElementById("diagz"+i).innerText;
               
                pos=7;var row=pos;
                xlsSheet.cells(row,1)=t['val:operName'];xlsSheet.cells(row,2)=document.getElementById("opnamez"+i).innerText;
              
                pos=8;var row=pos;
                //xlsSheet.cells(row,1)=t['val:operDoc'];xlsSheet.cells(row,2)=document.getElementById("opdocz"+i).innerText;
                var operDoc=document.getElementById("opdocz"+i).innerText;
                xlsSheet.cells(row,1)=t['val:operDoc'];xlsSheet.cells(row,2)=operDoc.split(",")[0];
                var ass=str[4].split(" ");
               if (ass[0]) xlsSheet.cells(row,4)=ass[0]; //assistant
               if (ass[1]) xlsSheet.cells(row,6)=ass[1]; //assistant
               if (ass[2]) xlsSheet.cells(row,8)=ass[2]; //assistant
                pos=9;var row=pos;
                xlsSheet.cells(row,1)=t['val:operNeeds'];
                if (str[2]) xlsSheet.cells(row,2)=str[2];
                var mz=str[3].split(" ");
                pos=10;var row=pos;
                xlsSheet.cells(row,1)=t['val:aneasthist'];
                xlsSheet.cells(row,2)=mz[0]
                xlsSheet.cells(row,3)=mz[1];
                xlsSheet.cells(row,5)=t['val:changeDuty'];
                xlsSheet.cells(row,6)=mz[2];
                xlsSheet.cells(row,6)=mz[3];
                var anmethodStr=document.getElementById("anmethodz"+i).innerText;
                if (anmethodStr.split("-").length>1) var anmethod=anmethodStr.split("-")[1];
                else var anmethod=anmethodStr;
                xlsSheet.cells(row,8)=t['val:aneasthMethod'];xlsSheet.cells(row,10)=anmethod;
                 //alert(document.getElementById("anmethodz"+i).innerText);
                pos=11;var row=pos;
                xlsSheet.cells(row,1)=t['val:operRoom'];xlsSheet.cells(row,2)=document.getElementById("oproomz"+i).value;//.innerText;
                xlsSheet.cells(row,3)=t['val:roomOrder'];xlsSheet.cells(row,4)=document.getElementById("opordnoz"+i).value;//.innerText;
                //xlsSheet.cells(row,5)="operPackage";xlsSheet.cells(row,6)=document.getElementById("oppackz"+i).innerText;
              
                pos=12 ;row=pos;
                xlsSheet.cells(row,1)=t['val:scrubNurse'];
                var sr=document.getElementById("scrubnursez"+i).innerText;
                var srarr=sr.split(" ");
                xlsSheet.cells(row,2)=srarr[0];
                xlsSheet.cells(row,3)=srarr[1];
                xlsSheet.cells(row,4)=t['val:circulNurse'];
                var cir=document.getElementById("circulnursez"+i).innerText;
                var cirarr=cir.split(" ");
                xlsSheet.cells(row,5)=cirarr[0];
                xlsSheet.cells(row,6)=cirarr[1];
               // alert(cirarr);
                //app loc		app doc		app date			
                var qxnur=str[5].split(" ");
                var xhnur=str[6].split(" ");
                pos=13 ;row=pos;
                xlsSheet.cells(row,1)=t['val:changeScrubNurse'];
                xlsSheet.cells(row,4)=t['val:changeCirculNurse'];
                if (qxnur[2]) xlsSheet.cells(row,2)=qxnur[2];
                if (qxnur[3]) xlsSheet.cells(row,3)=qxnur[3];
                if (xhnur[2]) xlsSheet.cells(row,5)=xhnur[2];
                if (xhnur[3]) xlsSheet.cells(row,6)=xhnur[3];
                 xlsSheet.cells(14,9)=t['val:masterSign'];
                xlsExcel.Visible = true;
                xlsSheet.PrintPreview ;
               // xlsSheet.PrintOut();
                ClearContents(xlsSheet,"A4:L13");
            }
            if((stat!=t["val:arrange"])&&(SelItem.checked==true))alert("只能打印手术 安排 表！")
        }
        //if (framePrint=="Y") AddFrame(xlsSheet,0,0,printList.length,cols-1,actRow+ 1, 1) //'add frame
        //xlsExcel.Visible = true
       // xlsSheet.PrintPreview 
       // xlsSheet.PrintOut(); 

        xlsSheet = null;
        xlsBook.Close(savechanges=false)
        xlsBook = null;
        xlsExcel.Quit();
        xlsExcel = null;
	   //}
      //  catch(e)
      //  {
	   //     alert(e.toString());
	      //  xlsExcel.Quit();

	 //   }

	} 
	
 
	            
       
      
    
	      
           
	            
	            
	            
	            
	            
	            
	            
	            
	            
	            
	            
	            
	            
	            
	          
    