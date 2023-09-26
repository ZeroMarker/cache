var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);

/*
var tmpChinese;
function GetChinese(MethodName,Ind)
{
	var strMethod = document.getElementById(MethodName).value;
	var ret = cspRunServerMethod(strMethod,Ind);
	var tmp=ret.split("^");
	return tmp;
}
tmpChinese=GetChinese("MethodGetChinese","DHC.WMR.Paadm.List");
//alert(tmpChinese[0]+tmpChinese[1]);



function DisplayMR()
{
	var MrType="",Papmi="",MainId="";
	var obj=document.getElementById("MrType");
	if (obj){MrType=obj.value;}
	var obj=document.getElementById("Papmi");
	if (obj){Papmi=obj.value;}
	var objMain=document.getElementById("ExistMain");
	var objMainId=document.getElementById("ExistMainId");
	if (objMain){
		objMain.value="";
		objMainId.value="";
		if ((MrType!=="")&&(Papmi!=="")){
			var obj=document.getElementById('MethodGetMain');
		    if (obj) {var encmeth=obj.value} else {var encmeth=''}
		    var ret=cspRunServerMethod(encmeth,MrType,Papmi);
		    if (ret){
			    var tmpList=ret.split("^");
			    if (tmpList[5]=="Y") {
					tmpList[5]=tmpChinese[0];
				}else{
					tmpList[5]=tmpChinese[1];
				}
			    if (tmpList[6]=="Y") {
					tmpList[6]=tmpChinese[2];
				}else{
					tmpList[6]=tmpChinese[3];
				}
			    if (tmpList[7]=="Y") {
					tmpList[7]=tmpChinese[4];
				}else{
					tmpList[7]=tmpChinese[5];
				}
				objMain.value=tmpChinese[6]+tmpList[2]+"   "+tmpList[5]+"   "+tmpList[6]+"   "+tmpList[7]+"   "+tmpChinese[7]+tmpList[8];
				objMainId.value=tmpList[0];
			}
		}
	}
}

function cmdNewMR_onclick()
{
	var MrType = document.getElementById("MrType").value;
	var AdmTypeFlag = document.getElementById("AdmTypeFlag").value;
	var WorkItem = document.getElementById("WorkItem").value;
	var RequestType = document.getElementById("RequestType").value;
	var AutoTransfer= document.getElementById("AutoTransfer").value;
	var AutoRequest= document.getElementById("AutoRequest").value;
	var PatientID=document.getElementById("Papmi").value;
	var EpisodeID=document.getElementById("CurrPaadm").value;
	
	if ((!MrType)||(!AdmTypeFlag)||(!PatientID)||(!EpisodeID)) {
		
		alert(t["selPaadm"]);
	}else{
		var strUrl="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.AdmitPatient.Main";
		var strUrl = strUrl + "&PatientID=" + PatientID 
		           + "&EpisodeID=" + EpisodeID
		           + "&MrType=" + MrType
		           + "&AdmTypeFlag=" + AdmTypeFlag
		           + "&WorkItem=" + WorkItem
		           + "&RequestType=" + RequestType
		           + "&AutoTransfer=" + AutoTransfer
		           + "&AutoRequest=" + AutoRequest;
		window.open(strUrl,null,"height=600,width=850,status=yes,toolbar=no,menubar=no,location=no");
	}
	window.location.reload();
}

function SelectRowHandler()	{
	var Paadm="",CurrPaadm="";
	var objtbl=document.getElementById('tDHC_WMR_Paadm_List');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var eSrc=window.event.srcElement;
	var objRow=getRow(eSrc);
	var selectrow=objRow.rowIndex;
	if (selectrow <= 0) return;
	
	obj=document.getElementById('Paadmz'+selectrow);
	if (obj){Paadm=obj.value;}
	obj=document.getElementById('CurrPaadm');
	if (obj){
		CurrPaadm=obj.value;
		if (CurrPaadm!==Paadm){
			obj.value=Paadm;
		}else{
			obj.value="";
		}
	}

}
*/

function intForm()
{
	//DisplayMR();
	//var obj=document.getElementById("cmdNewMR");
	//if (obj){obj.onclick=cmdNewMR_onclick;}
}

intForm();