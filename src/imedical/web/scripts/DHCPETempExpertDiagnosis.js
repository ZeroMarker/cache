
/// ��Ӧ��	


var CurRow=0
var CurrentSel=0
function BodyLoadHandler() {

	var obj;
	obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click; }
	


}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}
//��֤�Ƿ�Ϊ������
function IsFloat(Value) {
	
	var reg;
	
	if(""==trim(Value)) { 
		//����Ϊ��
		return true; 
	}else { Value=Value.toString(); }
	
	reg=/^((-?|\+?)\d+)(\.\d+)?$/;
	if ("."==Value.charAt(0)) {
		Value="0"+Value;
	}
	
	var r=Value.match(reg);
	if (null==r) { return false; }
	else { return true; }
}

   



function Delete_click()

{ 
    var RowId=""
	var obj=document.getElementById("rowid");
	if (obj){RowId=obj.value; } 
	if(RowId==""){
		alert("����ѡ��Ҫɾ���ļ�¼") 
	return false��
	}
	var Instring=trim(RowId)
	var Ins=document.getElementById('DeleteBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring)
	
	if (flag==0)
	{   alert("ɾ���ɹ�");
		window.location.reload();
	}
	
	else
	{    
		alert("ɾ��ʧ��");
	}
	}
	
	
function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	
	var objtbl=document.getElementById('tDHCPETempExpertDiagnosis');	
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var Row=rowObj.rowIndex;
	if (Row==CurRow)
	{
		CurRow=0      
	
	}
	else
	{
		CurRow=Row;
	}
	
    var obj=document.getElementById("TED_RowIdz"+CurRow)
	var objrowid=document.getElementById("rowid")
	if (objrowid) objrowid.value=obj.innerText;

    var obj=document.getElementById("TED_DisplayNamez"+CurRow)
	var objTEDDisplayName=document.getElementById("TEDDisplayNamea")
	if (objTEDDisplayName) objTEDDisplayName.value=obj.innerText;
		
	var obj=document.getElementById("TED_Resultz"+CurRow)
    var objTEDResult=document.getElementById("TEDResult")
	if (objTEDResult) objTEDResult.value=obj.innerText;
	
	//DiagnoseConclusion  ���� 
	//Detail             ����
	lnk="dhcpeexpertdiagnosis.lnk.csp?DiagnoseConclusion="+objTEDResult.value+"Detail="+objTEDDisplayName.value;
	
	parent.frames.right.frames("topleft").ExpertDiagnosis(objTEDResult.value,objTEDDisplayName.value);
	//alert("aa");
    

}
 	

document.body.onload = BodyLoadHandler;
