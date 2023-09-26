 function BodyLoadHandler() {
	
	var obj;
	obj=document.getElementById("BPrint");
	if (obj){ obj.onclick=BPrint_click; }
	
	obj=document.getElementById("BFind");
	if (obj){ obj.onclick=BFind_click; }
	
	obj=document.getElementById("BClear");
    if (obj) {obj.onclick=BClear_Click;}

	
}
function BClear_Click(){
	var obj;
	obj=document.getElementById("BeginDate");
	if (obj){ obj.value=""; }
	obj=document.getElementById("EndDate");
	if (obj){ obj.value=""; }
	obj=document.getElementById("ArcItemDesc");
	if (obj){ obj.value=""; }
	obj=document.getElementById("ArcItemID");
	if (obj){ obj.value=""; }
	
}

function BFind_click(){

    var obj;
	var iBeginDate="",iEndDate="",iArcItemID="",iArcItemDesc=""
	obj=document.getElementById("BeginDate");
	if (obj){ iBeginDate=obj.value; }
	obj=document.getElementById("EndDate");
	if (obj){ iEndDate=obj.value; }
	obj=document.getElementById("ArcItemDesc");
	if (obj){ iArcItemDesc=obj.value; }
	obj=document.getElementById("ArcItemID");
	if (obj){ iArcItemID=obj.value; }
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPESingleItemQuery"
			+"&BeginDate="+iBeginDate
			+"&EndDate="+iEndDate
			+"&ArcItemID="+iArcItemID
			;
			location.href=lnk;
}

function BPrint_click(){
	var obj;
	obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPERegNum.xls'; // 模板文件
	}else{
		alert("无效模板路径");
		return;
	}
	xlApp = new ActiveXObject("Excel.Application");  //固定
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
	xlsheet = xlBook.WorkSheets("Sheet1")     //Excel下标的名称
    	var BeginDateStr="",EndDateStr="",BeginDate="",EndDate="";
    	obj=document.getElementById("BeginDate");
    	if (obj) BeginDateStr=obj.value;
    	obj=document.getElementById("EndDate");
    	if (obj) EndDateStr=obj.value;
		/*
    	if (BeginDateStr!="") BeginDate=BeginDateStr.split("/")[2]+"-"+BeginDateStr.split("/")[1]+"-"+BeginDateStr.split("/")[0];
    	obj=document.getElementById("EndDate");
    	if (obj) EndDateStr=obj.value;
    	if (EndDateStr!="") EndDate=EndDateStr.split("/")[2]+"-"+EndDateStr.split("/")[1]+"-"+EndDateStr.split("/")[0];
    	xlsheet.cells(2, 2).value = BeginDate+"-----"+EndDate;
		*/
		xlsheet.cells(2, 2).value = BeginDateStr+"-----"+EndDateStr
		xlsheet.cells(1, 1).value="体检医嘱数量统计"
	var eSrc=window.event.srcElement;
	
	
	
	var tbObj=document.getElementById('tDHCPESingleItemQuery');	
	var rowObj = tbObj.getElementsByTagName("tr");
   	if(tbObj)
   	{
	  //rowNumber行序号
	var str = "" ,rowNumber,columnNumber //列序号
	for(var rowNumber = 0;  rowNumber < rowObj.length;rowNumber ++ )
	{ //rowObj[rowNumber].cells.length
      	
        for(var columnNumber = 1; columnNumber < rowObj[rowNumber].cells.length;columnNumber ++ )
         {
            str=rowObj[0].cells[columnNumber].innerText;
            if (str==" ") break;
            str = rowObj[rowNumber].cells[columnNumber].innerText;
            xlsheet.cells(rowNumber+3, columnNumber).value = str;
         }
      	}
   	}
	xlsheet.printout;
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null

	idTmr   =   window.setInterval("Cleanup();",1); 
	
}
function   Cleanup()   { 
	window.clearInterval(idTmr);   
	CollectGarbage();
  
}
function SearchArcItmmast(value){
	var aiList=value.split("^");
	if (""==value){return false}
	else{
		var obj;
		
		//医嘱名称
		obj=document.getElementById("ArcItemDesc");
		obj.value=aiList[1];

		//医嘱编号
		obj=document.getElementById("ArcItemID");
		obj.value=aiList[2];
		
	}
}

document.body.onload = BodyLoadHandler;