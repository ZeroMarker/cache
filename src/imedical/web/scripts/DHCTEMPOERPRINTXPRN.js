var hospitalDesc="北京协和医院"; //document.getElementById("hospital").value;
var idTmr=""

function RegExpTest(){
  var ver = Number(ScriptEngineMajorVersion() + "." + ScriptEngineMinorVersion())
  if (ver >= 5.5){                 // 测试 JScript 的版本?
    var src = "The rain in Spain falls mainly in the plain.";
    var re = /\w+/g;               // 创建正则表达式模式?
    var arr;
    while ((arr = re.exec(src)) != null)
      alert(arr.index + "-" + arr.lastIndex + "\t" + arr);
  }
  else{
   // alert("请使用 JScript 的更新版本");
  }
}
function SearchDemo(){
   var r, re;                   // 声明变量?
   var s = "The rain in Spain falls mainly in the plain.";
   re = "Thedd";            // 创建正则表达式模式?
   r = s.search(re);            // 查找字符串?
   alert(r)
   return(r);                   // 返回 Boolean 结果?
}
function GetStPage(OrdTyp, Adm, Dep,DepNo)
{
    var GetStartPage=document.getElementById("GetStartPage").value;
	var ret=cspRunServerMethod(GetStartPage,OrdTyp, Adm, Dep,DepNo);
	if (ret=="") ret=1;
	return ret;
}

function ExeQuery(ExeLongQuery,Adm,Dep,user)
{   
	var prj;
	prj=cspRunServerMethod(ExeLongQuery,Adm,Dep,user);
	return prj;
}
function SearchOeOrdRowid(RowId)
{ //查询是否有对应的医嘱 打印当前页
 	var objtbl=document.getElementById('tDHCTEMPOERPRINT');
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
	   var Adm=document.getElementById("Adm").value;
	   var ExeLongQuery=document.getElementById("ExeTempQuery").value;
	   var Processj;
	   if (PrTyp==2){}else{  
	   Processj=ExeQuery(ExeLongQuery,Adm,DepNo,session['LOGON.USERID']);
	   //var Processj=document.getElementById("ProcessNoz"+1).innerText
	   //alert(Processj)
	   }
	   var truthBeTold = window.confirm(t['alert:ifhaveprintwork']);
       if (!truthBeTold) {
	       return;
       }
	   //SearchDemo();
	   //
	   //var str1="jjjkdd";
	   //var i=str1.search("dd");
	  // alert("中");
	    //return;
	    var xlsExcel,xlsSheet,xlsBook;
	    var i,j;
        //alert(PrintDateTime);
        var  path = GetFilePath();
       // path="d:\\"
        var fileName="lsyz1.xls" ;//+ fileName;
        fileName=path+ fileName;
       // alert(fileName);
	    xlsExcel = new ActiveXObject("Excel.Application");
	    //alert("also ok")
	    var Adm=document.getElementById("Adm").value;
	    
	    xlsBook = xlsExcel.Workbooks.Add(fileName) //;Open(fileName)
	    xlsSheet = xlsBook.ActiveSheet ;//  Worksheets(1)
	   	var strj=Processj; 
	   	if (PrTyp==2){
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
        //var PRow=28;//每页行数
        var PRow=27;//每页行数
	    var pnum=0; //页数
	    var frw=1; 
	    //var cols=7;
	    var cols=6;
	    var PageNum=new Number(GetStPage("lsord",Adm,Dep,DepNo));
	    //var ClearStr="A1:G28";
	    var ClearStr="A1:G27";

      bdprn=false;
	    Print=false;
	    Res=cspRunServerMethod(FetchPageRow,"lsord",Adm,Dep,DepNo);
	    //TmpRes=cspRunServerMethod(TmpFetchPageRow,"lsord",Adm);
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
		if ((PrTyp==1)||(PrTyp==2)){
		   StPage=1;
	       StRow=1;
        
			}
		var ret
		//ret=cspRunServerMethod(KTmpSet,"lsord",Adm,Dep,DepNo) ; 
		var rows;
		for (i=1;i<num+1;i++)
	     {
		   var GetItem=document.getElementById("GetItem").value; 
		   var res=cspRunServerMethod(GetItem,i,Adm,strj);
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
		     xfillgrid(xlsSheet,data,frw);
		     Print=true;
		   }
		   else
		   {
		      frw+=1;
		   			   	////////////////停过的医嘱打印签名070406qse
		       if (((StPage==PageNum)&&(frw<StRow)))
		       {
			    Print=true;
			    lsFillData(frw ,data, xlsSheet);
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
					          //gridset(xlsSheet,1,1,cols,1,9);
            	           	  //gridlist(xlsSheet,1,PRow,1,cols);
			               	  titlegrid(xlsSheet,PageNum);       
				          }
 			        } 
			     	else        			    
		           	{
			          	if ((PrTyp==1)||(PrTyp==2))
			         	{ 
			         		//gridset(xlsSheet,1,1,cols,1,9);
            	      		//gridlist(xlsSheet,1,PRow,1,cols);
			                titlegrid(xlsSheet,PageNum);
			            }      
		            }
                 }  // +
  
			   // titlegridkong(xlsSheet);
			  }
			  else
			  {
			    //gridset(xlsSheet,1,1,cols,1,9);
			    //gridlist(xlsSheet,1,PRow,1,cols);
			    titlegrid(xlsSheet,PageNum);
			  }
			   PageNum+=1;
			   frw=1;
			   //xlsExcel.Visible = true;
              // xlsBook.PrintPreview;
              //alert(4)
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
		        //gridset(xlsSheet,1,1,cols,1,9);
          //gridlist(xlsSheet,1,PRow,1,cols);
			       titlegrid(xlsSheet,PageNum);
              }
		    }
		    else
		    {
			    //gridset(xlsSheet,1,1,cols,1,9);
            	//gridlist(xlsSheet,1,PRow,1,cols);
			    titlegrid(xlsSheet,PageNum);

			}
			 if (Print==true)
			 {
			 //xlsExcel.Visible = true;
             //xlsBook.PrintPreview;
             //alert(6)
             xlsSheet.PrintOut;
			 }
	    }
	    if (bdprn==false){
		
        SavePageRow("lsord",PageNum,frw,Dep,DepNo);
        var CurStat=document.getElementById("CurStatus");
        frw=frw-1;
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
	    
        return;
	    var xlsExcel,xlsSheet,xlsBook;
	    var i,j;
	    
        //alert(PrintDateTime);
        var  path = GetFilePath();
       // path="d:\\"
        var fileName="lsyz1.xls" ;//+ fileName;
        fileName=path+ fileName;
       // alert(fileName);
	    xlsExcel = new ActiveXObject("Excel.Application");
	    //alert("also ok")
	    var Adm=document.getElementById("Adm").value;
	    xlsBook = xlsExcel.Workbooks.Add(fileName) //;Open(fileName)
	    xlsSheet = xlsBook.ActiveSheet ;//  Worksheets(1)
	   	var strj=Processj;  //document.getElementById("ProcessNoz"+2).innerText;
        var GetItemNum=document.getElementById("GetItemNum").value;
	    var num=new Number(cspRunServerMethod(GetItemNum,Adm,strj));
	    var FetchPageRow=document.getElementById("schtystrow").value;
	    //察看打印的页码和行数
	    var Res;
	    Res=cspRunServerMethod(FetchPageRow,"lsord",Adm,Dep,DepNo);
	    var PageStr;
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
	    var PRow=28;//每页行数
	    var pnum=0; //页数
	    var frw=1; 
	    var cols=7;
	    var PageNum=new Number(GetStPage("lsord",Adm,Dep,DepNo));
	    var ClearStr="A1:G28";
		for (i=1;i<num+1;i++)
	     {
		   var GetItem=document.getElementById("GetItem").value; 
		   var res=cspRunServerMethod(GetItem,i,Adm,strj);
		   var data=res.split("^");
		   if (((StPage==PageNum)&&(frw>=StRow))||(PageNum>StPage))
		   {
			 frw+=1;  
		   }
		   else
		   {
		       frw+=1;
		   	   if (PageNum==pg)
			   {
                  //alert(data)
                  lsFillData(frw,data,xlsSheet); //''友谊不用
			   }

		   }
		   Pres=(frw)%PRow;
		   //alert(frw+"^"+Pres)
		   if (Pres==0)
		   {
			// alert(PageNum);
			  if (StPage>=PageNum)
			  {
			   titlegridkong(xlsSheet);
			  }
			  else
			  {
			   // gridset(xlsSheet,1,1,cols,1,11);
			    //gridlist(xlsSheet,1,PRow,1,cols);
			  //  alert(PageNum)
			    titlegrid(xlsSheet,PageNum);
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
	        //alert(PageNum)
	        if ((StPage==PageNum)&&(frw>1)&&(StPage!=0))
	        {
		      titlegridkong(xlsSheet);
		    }
		    else
		    {
			   // gridset(xlsSheet,1,1,cols,1,11);
            	//gridlist(xlsSheet,1,PRow,1,cols);
            	//alert(PageNum)
			    titlegrid(xlsSheet,PageNum);
			   
			}
			// xlsExcel.Visible = true;
            // xlsBook.PrintPreview;
             xlsSheet.PrintOut;
	    }
      //  SavePageRow("lsord",PageNum,frw);

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
{       var titleRows = 0;titleCols = 0 ;//&chr(10)
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
	    
	    var curname
	    curname=infoarr[4]
	    var curlen
	    curlen=strlen(curname)
	    var allInfo
		    var allInfo="      "
	    allInfo=allInfo+curname
	    var ii
	    for (ii=curlen;ii<14;ii++)
    	{
	    	allInfo=allInfo+" ";   // 补姓名
    	}  
	    
        allInfo=allInfo+"  "+infoarr[1]  //科  2
	    
	    curname=infoarr[1];
	    curlen=strlen(curname);
	    for (ii=curlen;ii<18;ii++)
    	{
	     allInfo=allInfo+" ";     //补科室
    	}
    	if(curlen>19)
    	{
	    	allInfo=allInfo+infoarr[8];
    	}
        else
        {	  
    		allInfo=allInfo+"   "+infoarr[8];;   //2
        }
    	 curname=infoarr[8];
	    curlen=strlen(curname);
	    for (ii=curlen;ii<24;ii++)
    	{
	    allInfo=allInfo+" ";     //补病房
	                    
    	}
    	if(curlen>25)
    	{
	    	allInfo=allInfo+PagNum;
    	}
        else
        {	  
    		allInfo=allInfo+"     "+PagNum; //5
        }  
    	
    	allInfo=allInfo+"                 "+infoarr[12]; //18
    
        //regno_"^"_ctloc_"^"_room_"^"_sex_"^"_patName_"^"_Bah_"^"_bedCode_"^"_age
	    //var  LeftHeader="\r\r\r&9"+t['val:patname']+":"+infoarr[4]+"    "+t['val:Dep']+infoarr[1]+"     "+t['val:bed']+infoarr[6]+"      "+t['val:regNo']+infoarr[0]+"  "+t['val:patRec']+infoarr[12];LeftFooter = "";CenterFooter = t['val:cFooter'];RightFooter = "";
	    //var  LeftHeader="\r\r\r&9    "+infoarr[4]+"              "+infoarr[1]+"          "+ infoarr[8]+"                "+PagNum+"              "+infoarr[12];LeftFooter = "";CenterFooter = t['val:cFooter'];RightFooter = "";
	    
	    var  LeftHeader="\r\r\r&9    "+allInfo;LeftFooter = "";CenterFooter = t['val:cFooter'];RightFooter = "";
	    
	    
	    //+t['val:patname']+":" t['val:Dep']+ +t['val:bed'] +t['val:patRec']  infoarr[6]
        LeftFooter = "";CenterFooter = t['val:cFooter'];RightFooter = "";
	    var CenterHeader = "&15"+""+"\r"+"&18"+""; //hospitalDesc  t['val:tempOrdSheet']
	    
	    var RightHeader = " ";RightFooter ="" ;LeftFooter = ""; //"\r&10"+t['val:nurseSign']+"        "+t['SignTime']+"\r&10"+"    "+t['val:docSign']+"        "+t['SignTime'];                                 
	    var CenterFooter ="" //"\r\r\r\r&10"+t['val:sort']+PagNum+t['val:page'] ;
        ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter) 
        //PrintPagNo(xlsSheet,PagNum,11,24)
}

function strlen(str)  
{  
    var i;  
    var len;  
      
    len = 0;  
    for (i=0;i<str.length;i++)  
    {  
        if (str.charCodeAt(i)>255) len+=2; else len++;  
    }  
    return len;  
}


function titlegrid2(xlsSheet,PagNum)
{       var titleRows = 0;titleCols = 0 ;//&chr(10)
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
	    //var  LeftHeader="\r\r\r&9"+t['val:patname']+":"+infoarr[4]+"    "+t['val:Dep']+infoarr[1]+"     "+t['val:bed']+infoarr[6]+"      "+t['val:regNo']+infoarr[0]+"  "+t['val:patRec']+infoarr[12];LeftFooter = "";CenterFooter = t['val:cFooter'];RightFooter = "";
	    var  LeftHeader="\r\r\r&9    "+t['val:patname']+":"+infoarr[4]+"              "+t['val:Dep']+infoarr[1]+"                "+t['val:bed']+infoarr[6]+"              "+t['val:patRec']+infoarr[12];LeftFooter = "";CenterFooter = t['val:cFooter'];RightFooter = "";
        LeftFooter = "";CenterFooter = t['val:cFooter'];RightFooter = "";
	    var CenterHeader = "&15"+hospitalDesc+"\r"+"&18"+t['val:tempOrdSheet'];
	    
	    var RightHeader = " ";RightFooter ="\r&10"+t['val:nurseSign']+"        "+t['SignTime']+"\r&10"+"    "+t['val:docSign']+"        "+t['SignTime']; ;LeftFooter = "";                                
	    var CenterFooter ="\r\r\r\r&10"+t['val:sort']+PagNum+t['val:page'] ;
        ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter) 
        //PrintPagNo(xlsSheet,PagNum,11,24)
}

function titlegrid1(xlsSheet,pagno)
{
        var titleRows = 0;titleCols = 0 ;//&chr(10)
		var CenterHeader = "&14"+t['val:hospitalname']+"\r"+t['val:tempOrdSheet'];
	    var PatInfo=document.getElementById("Patinfo").value;
	    var Adm=document.getElementById("Adm").value;
	    var info=cspRunServerMethod(PatInfo,Adm);
	    var infoarr=info.split("^");
	    //regno_"^"_ctloc_"^"_room_"^"_sex_"^"_patName_"^"_Bah_"^"_bedCode_"^"_age
	    var  LeftHeader="\r\r\r&9"+t['val:patname']+":"+infoarr[4]+"    "+t['val:Dep']+infoarr[1]+"     "+t['val:room']+infoarr[2]+"      "+t['val:regNo']+infoarr[0];LeftFooter = "";CenterFooter = t['val:cFooter'];RightFooter = "";
	    var RightHeader = " ";LeftFooter = "";CenterFooter = "";RightFooter = "";
        ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter) 
        PrintPagNo(xlsSheet,pagno,11,24)
}
function PrintPagNo(xlsSheet,pagno,rh,rw)
{
	 //&10负责医生签字                     "+"第 &P 页"+   负责护士签字"
	 SetRowH(xlsSheet ,rw+":"+rw, rh);
	 fontcell(xlsSheet,rw,1,6,10);
     xlstyle(xlsSheet,rw,1,6,1);
	 xlsSheet.cells(rw,2)=t['val:docSign']+"                     "+t['val:sort']+pagno+t['val:page']+"               "+t['val:nurseSign']; 
}

function titlegridkong(xlsSheet)
{
        var titleRows = 0;titleCols = 0 ;//&chr(10)
		var CenterHeader = "";
	    //var PatInfo=document.getElementById("patinfo").value;
	    //var Adm=document.getElementById("Adm").value;
	    //var info=cspRunServerMethod(PatInfo,Adm);
	    //var infoarr=info.split("^");
	    //regno_"^"_ctloc_"^"_room_"^"_sex_"^"_patName_"^"_Bah_"^"_bedCode_"^"_age
	    var LeftHeader="";
	    var RightHeader = " ";LeftFooter = "";CenterFooter = "";RightFooter = "";
        ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter) 
  
}
function xfillgrid(xlsSheet,itm,frw)
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
                saveordno("lsord", itm[7], flag);

}
function SavePageRow(typ,Page,Row,Dep,DepNo)
{
		var startrow=document.getElementById("startrow").value;
	    var Adm=document.getElementById("Adm").value;
	    var info;
        var pagenum;
        pagenum=Page.toString();	
        info=cspRunServerMethod(startrow,typ,Adm,pagenum,Row,Dep,DepNo);	
}
function lsFillData(Row , itm , objectxsl ) //临时医属
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
              saveordno("lsord", itm[7], flag);
   }
function saveordno(typ,ord ,flag )
  {
        var ford=ord.replace(String.fromCharCode(1), "||");
        var saveordno=document.getElementById("saveordno").value;
	    var info=cspRunServerMethod(saveordno,typ,ford,flag);
    //     vmdb.Execute "$$saveordno^DHCBLPRINTROW(P0,P1,P2)"
  }
  function fetchordflag(typ,ord)
   {
     var ford=ord.replace(String.fromCharCode(1), "||")
     var fetchordno=document.getElementById("fetchordno").value;
	 var info=cspRunServerMethod(fetchordno,typ,ford);
	 return info;
 }
 