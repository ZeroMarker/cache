Adm=document.getElementById("Adm").value;

function BodyLoadHandler()
{

	var objtbl=document.getElementById('tDHCLONGTIMEORDCZ');
	
	var i=0
    for (i=1;i<objtbl.rows.length;i++)
	{
	   var eSrc=objtbl.rows[i];
	   var RowObj=getRow(eSrc);
	   var item=document.getElementById("OrdNoz"+i);
	   item.innerText=i;
	}

    var obj=document.getElementById("Print");
    if (obj) {obj.onclick=PrintClick;}
 }
function PrintClick()
{
	    var xlsExcel,xlsSheet,xlsBook;
	    var i,j;
	    var Adm=document.getElementById("Adm").value;

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
	    var GetItemNum=document.getElementById("GetItemNum").value;
	    var num=new Number(cspRunServerMethod(GetItemNum,Adm));
	    var PRow=28;//ÿҳ����
	    var pnum=0; //ҳ��
	    var frw=3;
		for (i=1;i<num+1;i++)
	     {
		   var GetItem=document.getElementById("GetItem").value; 
		   var res=cspRunServerMethod(GetItem,i,Adm);
		   var data=res.split("^");
		   var lnum=1+PRow*pnum;
		   if (lnum==1) gridset(xlsSheet,1,1,9,1,11);
		   xlsSheet.cells(frw,1)=data[0];
		   xlsSheet.cells(frw,2)=data[1];
		   xlsSheet.cells(frw,3)=data[2];
		   xlsSheet.cells(frw,4)=data[3];
		   xlsSheet.cells(frw,5)=data[4];
		   xlsSheet.cells(frw,6)=data[5];
		   xlsSheet.cells(frw,7)=data[6];
		   xlsSheet.cells(frw,8)=data[7];
		   xlsSheet.cells(frw,9)=data[8];
		   
		   var pres=frw%PRow;
		   if (pres==0)
		   {
			   pnum=pnum+1;
		       frw=frw+1;
		       gridset(xlsSheet,frw,1,9,frw,11);
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
		var CenterHeader = "&14��������ҽԺ\r"+"�� �� ҽ �� ��";
	    var PatInfo=document.getElementById("patinfo").value;
	    var info=cspRunServerMethod(PatInfo,Adm);
	    var infoarr=info.split("^");
	    //regno_"^"_ctloc_"^"_room_"^"_sex_"^"_patName_"^"_Bah_"^"_bedCode_"^"_age
	    var LeftHeader="\r\r\r&9����:"+infoarr[4]+" �Ա�:"+infoarr[3]+" ����: "+infoarr[7]+" ����:"+infoarr[2]+" ����: "+infoarr[6]+" ������: "+infoarr[5]+" �ǼǺ�: "+infoarr[0];
	          var RightHeader = " ";LeftFooter = "";CenterFooter = "&10����ҽ��ǩ��                     "+"�� &P ҳ"+"             ����ʿǩ��";RightFooter = "";
        ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter) 
        var sherow=PRow-(i-pnum*PRow);
        
		gridlist(xlsSheet,1,i+sherow,1,9);
		xlsExcel.Visible = true;
        xlsSheet.PrintPreview() ;

        xlsSheet = null;
        xlsBook.Close(savechanges=false);
        xlsBook = null;
        xlsExcel.Quit();
        xlsExcel = null;
}
function gridset(xlsSheet,r,c1,c2,frw,fontnum)
{
     nfontcell(xlsSheet,r,r+1,c1,c2,fontnum);
	 nxlcenter(xlsSheet,r,r+1,c1,c2);
     nmergcell(xlsSheet,r,r,1,2);
     nmergcell(xlsSheet,r,r+1,3,3);
     nmergcell(xlsSheet,r,r+1,4,4);
     nmergcell(xlsSheet,r,r+1,5,5);
     nmergcell(xlsSheet,r,r,6,7);
     nmergcell(xlsSheet,r,r+1,8,8);
     nmergcell(xlsSheet,r,r+1,9,9);
    
	 xlsSheet.cells(frw,1)="�� ʼ";
	 xlsSheet.cells(frw+1,1)="����";
	 xlsSheet.cells(frw+1,2)="ʱ��";
	 xlsSheet.cells(frw,3)="ҽ��ǩ��";
	 xlsSheet.cells(frw,4)="��ʿǩ��";
	 xlsSheet.cells(frw,5)="�� �� ҽ ��";
	 xlsSheet.cells(frw,6)="ͣ  ֹ";
	 xlsSheet.cells(frw+1,6)="�� ��";
	 xlsSheet.cells(frw+1,7)="ʱ ��";
	 xlsSheet.cells(frw,8)="ҽ��ǩ��";
	 xlsSheet.cells(frw,9)="��ʿǩ��";
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
   nwin="top=50,left=200,height=210,width=350";
   lnk+="&Adm="+Adm;
   window.open(lnk,'_blank',nwin);	

}

document.body.onload = BodyLoadHandler;
