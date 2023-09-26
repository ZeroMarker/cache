
/// DHCPEGroupCollect.Detail.js


var CurRow=0
var CurrentSel=0
function BodyLoadHandler() {

	obj=document.getElementById("Export");
	if (obj){ obj.onclick=Export_click; }

}

function Export_click()
{
	var iGADMDR=""
	var tkclass="web.DHCPE.Report.GroupCollect"
	//var obj=parent.opener.parent.document.getElementById('GList');
	//if (obj){var iGADMDR=obj.value; }
	var iGADMDR=parent.opener.parent.frames('GList').GList.value;
	var ExportName=tkMakeServerCall(tkclass,"GetGName",iGADMDR);
	var obj;
	obj=document.getElementById("prnpath");
	if (obj&& ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEGroupCollectDetail.xls';
	}else{
		alert("无效模板路径");
		return;
	}
	
	xlApp= new ActiveXObject("Excel.Application"); //固定
	xlApp.UserControl = true;
    xlApp.visible = true; //显示
	xlBook= xlApp.Workbooks.Add(Templatefilepath); //固定
	xlsheet= xlBook.WorkSheets("Sheet1"); //Excel下标的名称
	
    var iIllStr="";
    obj=document.getElementById("IllStr");
	if (obj){ iIllStr=obj.value; }
	var IllArr=iIllStr.split("^");
    var IllLength=IllArr.length;
    var i=0
    for (Illi=0;Illi<IllLength;Illi++)
    {
	    var OneIll=IllArr[Illi];
	    if (OneIll=="") continue;
	    var OneArr=OneIll.split("$");
	    for (OneIlli=1;OneIlli<OneArr.length;OneIlli++)
    	{
	    var OneIllDesc=OneArr[OneIlli];
	    var OneAdmStr=tkMakeServerCall(tkclass,"GetIllAdmStr",OneIllDesc);
	    if (OneAdmStr=="") continue;
	    var AdmArr=OneAdmStr.split("^");
	    var AdmLength=AdmArr.length;
	    for (Admi=0;Admi<AdmLength;Admi++)
	    {
		    var OneAdm=AdmArr[Admi];
		    var OneDetail=tkMakeServerCall(tkclass,"GetOneAdmDetail",OneIllDesc,OneAdm);
		    if (OneDetail=="") continue;
		    var ADMInfo=OneDetail.split("^");
	
			for (j=0;j<ADMInfo.length;j++)
			{
				xlsheet.cells(3+i,j+1).value=ADMInfo[j];
				
			} 
			i=i+1;
	    }
    	}
	   
    }
	/*
	xlsheet.SaveAs("D:\\"+ExportName+".xls");	
	xlApp.Visible= true;
	xlApp.UserControl= true;
	*/
	xlBook.Close(savechanges = true);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null;

}


function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	
	var objtbl=document.getElementById('tDHCPEGroupCollect_Detail');	
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var Row=rowObj.rowIndex;
	if (Row==CurRow)
	{
		CurRow=0;
	
	}
	else
	{
		CurRow=Row;
	}
	var obj=document.getElementById("TIllz"+CurRow)
	if (obj){
		var Ill=obj.value;
		if (parent.frames["right"]){
			lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEGroupCollect.ADMList"
			+"&IllString"+"="+Ill;
			parent.frames["right"].location.href=lnk;
			}
		}


}	




document.body.onload = BodyLoadHandler;
