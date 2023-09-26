//By    ljw20081230
var SelectedRow = 0;
var preRowInd=0;
function BodyLoadHandler(){
	var obj=document.getElementById('BPrint')
	if(obj) obj.onclick=BPrint_click;
	var obj=document.getElementById('selectAll');
	if (obj) obj.onclick=SelectAll_Click;
	var obj=document.getElementById('btnBabySreen');
	if (obj) obj.onclick=btnBabySreen_Click;
	var btnSelect=document.getElementById("select");
	if (btnSelect) {btnSelect.onclick=selectFn;}
}
function selectFn()
{    
    var stdate=document.getElementById("stdate").value;
    var enddate=document.getElementById("enddate").value;
    var FindStatus=document.getElementById("FindStatus").value;
    var FindStatusId=document.getElementById("FindStatusId").value;
    if (FindStatus=="") FindStatusId="";
    //alert(stdate+" "+enddate+" "+FindStatusId)
    var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPADelBaby"+"&stdate="+stdate+"&enddate="+enddate+"&FindStatusId="+FindStatusId+"&FindStatus="+FindStatus;
    window.location.href=lnk;
}

function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCPADelBaby');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var objselrow=document.getElementById("selrow");
	if (selectrow!=preRowInd){
		if (objselrow) objselrow.value=selectrow;
		preRowInd=selectrow;
	}
	else {
		if (objselrow) objselrow.value="";
		preRowInd=0;	
	}
}
function BPrint_click(){
	var xlsExcel,xlsSheet,xlsBook;
    var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
    var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
    var path,fileName,fso;
    var objtbl=document.getElementById('tDHCPADelBaby');
    var GetPrintData=document.getElementById("GetPrintData").value;
    path=GetFilePath();
    fileName=path+"procbabyinfo.xls";
	xlsExcel = new ActiveXObject("Excel.Application");

	xlsBook = xlsExcel.Workbooks.Add(fileName) //;Open(fileName)
	xlsSheet = xlsBook.ActiveSheet //  Worksheets(1)

      var hospitalDesc=document.getElementById("hospital").value
	xlsSheet.cells(1,1)=hospitalDesc+" "+ t['val:procbabyinfo']
	fontcell(xlsSheet,1,1,1,16);
	var Num=2
	for (var i=1;i<objtbl.rows.length;i++)
	{
		var sel=document.getElementById("SelItemz"+i);
		if (sel.checked==true)
		{
			var BabyID=document.getElementById("BabyIDz"+i).innerText;
            var prtdata=cspRunServerMethod(GetPrintData,BabyID);
            var str=prtdata.split("^");
                     Num=Num+1
			xlsSheet.cells(Num,1)=str[0];
            xlsSheet.cells(Num,2)=str[1];
			xlsSheet.cells(Num,3)=str[2];
			xlsSheet.cells(Num,4)=str[3];
			xlsSheet.cells(Num,5)=str[4];
			xlsSheet.cells(Num,6)=str[5];
			xlsSheet.cells(Num,7)=str[6];
			xlsSheet.cells(Num,8)=str[7];
			xlsSheet.cells(Num,9)=str[8];
			xlsSheet.cells(Num,10)=str[9];
			xlsSheet.cells(Num,11)=str[10];
			xlsSheet.cells(Num,12)=str[11];
			xlsSheet.cells(Num,13)=str[12];
			xlsSheet.cells(Num,14)=str[13];
			xlsSheet.cells(Num,15)=str[14];
			xlsSheet.cells(Num,16)=str[15];
		}
	}
	xlsExcel.Visible = true
    xlsSheet.PrintPreview
    //xlsSheet.PrintOut(); 
    //xlsSheet = null;
    xlsBook.Close(savechanges=false)
    xlsBook = null;
    xlsExcel.Quit();
    xlsExcel = null;	
 }	
 ///对应打印模版procbabyinfo1.xls
 ///包含听力筛查结果
function BPrint_click1(){
	var xlsExcel,xlsSheet,xlsBook;
    var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
    var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
    var path,fileName,fso;
    var objtbl=document.getElementById('tDHCPADelBaby');
    var GetPrintData=document.getElementById("GetPrintData").value;
    path=GetFilePath();
    fileName=path+"procbabyinfo.xls";
	xlsExcel = new ActiveXObject("Excel.Application");

	xlsBook = xlsExcel.Workbooks.Add(fileName) //;Open(fileName)
	xlsSheet = xlsBook.ActiveSheet //  Worksheets(1)

    var hospitalDesc=document.getElementById("hospital").value
	//xlsSheet.cells(1,1)=hospitalDesc+" "+ t['val:procbabyinfo']
	//fontcell(xlsSheet,1,1,1,16);
	//Row 1,2,3,4 is Fixed in Excel Template
	var Num=33;		
	for (var i=1;i<objtbl.rows.length;i++)
	{
		var sel=document.getElementById("SelItemz"+i);
		if (sel.checked==true)
		{
			var BabyID=document.getElementById("BabyIDz"+i).innerText;
            var prtdata=cspRunServerMethod(GetPrintData,BabyID);
            var str=prtdata.split("^");
            Num=Num+1;
			xlsSheet.cells(Num,1)=i;
            xlsSheet.cells(Num,2)=str[1];
			xlsSheet.cells(Num,3)=str[21];
			xlsSheet.cells(Num,4)=str[0];
			xlsSheet.cells(Num,5)=str[6];
			xlsSheet.cells(Num,6)=str[3];
			xlsSheet.cells(Num,7)=str[10];
			xlsSheet.cells(Num,8)=str[16];
			xlsSheet.cells(Num,9)=str[5];
			xlsSheet.cells(Num,10)=str[17];
			xlsSheet.cells(Num,11)=str[18];
			xlsSheet.cells(Num,12)=str[19];
			xlsSheet.cells(Num,13)=str[20];
			xlsSheet.cells(Num,14)=str[15];
		}
	}
	xlsExcel.Visible = true
    xlsSheet.PrintPreview
    //xlsSheet.PrintOut(); 
    //xlsSheet = null;
    xlsBook.Close(savechanges=false)
    xlsBook = null;
    xlsExcel.Quit();
    xlsExcel = null;	}

function GetFilePath()
  {   var GetPath=document.getElementById("GetPath").value;
      var path=cspRunServerMethod(GetPath);
      return path;
  }


function getFindStatus(str)
{
	var loc=str.split("^");
	var obj=document.getElementById("FindStatus")
	if (obj) obj.value=loc[0];
	var obj=document.getElementById("FindStatusId")
	if (obj) obj.value=loc[1];
}

function SelectAll_Click()
{
  var obj=document.getElementById("selectAll");
  var Objtbl=document.getElementById('tDHCPADelBaby');
  var Rows=Objtbl.rows.length;
  for (var i=1;i<Rows;i++){
	var selobj=document.getElementById('SelItemz'+i);  
	selobj.checked=obj.checked;  
	}
}
function btnBabySreen_Click()
{
	var objtbl=document.getElementById('tDHCPADelBaby');
	var EpisodeID="";
	var BabyID=""
	var num=0
	for (var i=1;i<objtbl.rows.length;i++)
	{
		var sel=document.getElementById("SelItemz"+i);
		if (sel.checked==true)
		{
			num=num+1
			EpisodeID=document.getElementById("EpisodeIDz"+i).value;
    		BabyID=document.getElementById("BabyIDz"+i).innerText;
		}
	}
	if(num!=1){
		alert("请勾选一名病人!")
		return;
	}

    var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPAPregDelBabyScreen&EpisodeID="+EpisodeID+"&BabyID="+BabyID;
   	window.open(lnk,'_blank',"top=200,left=400,width=400,height=250");	
}
document.body.onload=BodyLoadHandler;