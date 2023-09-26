var gCurrRow;

function BodyLoadHandler()
{	var obj=document.getElementById("AddRow");
	if (obj) obj.onclick=addDispType;
//	var obj=document.getElementById("t"+"dhcpha_phadisptype");
//	if (obj) obj.ondblclick=SetSelectDefault;
	}

function addDispType()
{
	var parref ;
	var obj=document.getElementById("Parref")
	if (obj) parref=obj.value;
	if (parref=="") return ;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phalocdisptypeAdd&Parref="+parref
	window.open(lnk,"_target","width=600,height=100,resizable=yes")	
}
function selectRowHandler()
{
	gCurrRow=selectedRow(window)
	
	}

document.body.onload=BodyLoadHandler;