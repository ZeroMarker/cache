///PMP.ImprovementListQuery.js
//
var SelectedRow = 0;
var CurrentSel = 0;
var tables = document.getElementsByTagName("table");
var perRowid;

function BodyLoadHandler()
{
	var obj;
	
	obj=document.getElementById("new") ;
	if (obj) obj.onclick=newAdd;
	
}

	
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	objtbl=document.getElementById('tPMP_ImprovementListQuery');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	 if (selectrow==CurrentSel){	
       CurrentSel=0;
       //alert("1")
       return;
	 }
	
    var tipmlmenu=document.getElementById('TIPMLMenuz'+selectrow);
    var IPMLMenuValue = tipmlmenu.innerText
    if(IPMLMenuValue!=""){
      var ListRowidd=tkMakeServerCall("web.PMP.PMPImprovementList","ListRowid",IPMLMenuValue);
      //alert(ListRowidd+"ListRowidd")
      if(ListRowidd!=""){
	      lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMPImprovementHand3&str="+ListRowidd;
          parent.frames[1].location.href=lnk;
      }
    }
	CurrentSel=selectrow
	SelectedRow = selectrow;
    
}

function LookUp_ProDesc(value){
    var info=value.split("^");
    document.getElementById("ProDRHidden").value=info[0];
    document.getElementById('ProDR').value = info[1];
    getMaxLevel();
}
document.body.onload=BodyLoadHandler;