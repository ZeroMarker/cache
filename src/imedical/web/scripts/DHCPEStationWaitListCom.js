/// DHCPEStationWaitListCom.js
/// ����ʱ��		2006.03.16
/// ������		xuwm
/// ��Ҫ����		��ʾ��վ��Ⱥ��������б�
/// ��Ӧ���		DHCPEStationWaitListCom
/// ����޸�ʱ��
/// ����޸���	

var CurrentSel=0;
var targeURL="DHCPEStationWaitCom";		//Ŀ��ҳ��
var URLParamName="ParRef";	//��������
function BodyLoadHandler() {
	
	iniForm();
	
	}

function iniForm() {

	ShowCurRecord(1);

}
function SearchOrderDetailCom_click() {
 
	var iRowId="",iDesc="";
	
	var lnk="";
	
	var objParam;
	
	//objParam=document.getElementById('TargetURLBox');
	//if (objParam) { targeURL=objParam.value;  }
	//else { targeURL="DHCPEStationWaitCom"; }
	//
	targeURL="DHCPEStationWaitCom";
	
	//objParam=document.getElementById('ParamNameBox');
	//if (objParam) { URLParamName=objParam.value; }
	//else { URLParamName="ParRef"; }	
	
	URLParamName="ParRef";
	
	iRowId=document.getElementById("RowId").value;	
	
	lnk="websys.default.csp?WEBSYS.TCOMPONENT="+targeURL
			+"&"+URLParamName+"="+iRowId;
	//alert(lnk);
	if (""!=iDesc) { lnk=lnk+"&"+URLParamName+"Name"+"="+iDesc; }
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width=700,height=520,left=0,top=0';
	//window.open(lnk,"_blank",nwin) 

}


//�Ա㱾ҳ�����ҳ������ȷ�Ĵ������
function ShowCurRecord(selectrow) {

	var SelRowObj;
	var obj;

	SelRowObj=document.getElementById('ST_RowId'+'z'+selectrow);
	obj=document.getElementById("RowId");
	obj.value=SelRowObj.value;


	SelRowObj=document.getElementById('ST_Desc'+'z'+selectrow);
	obj=document.getElementById("Desc");
	obj.value=SelRowObj.innerText;
	
	SelRowObj=document.getElementById('ST_Count'+'z'+selectrow);
	obj=document.getElementById("Count");
	obj.value=SelRowObj.innerText;	

	//��ȡ ѡ���¼������ ѡ����ʾ���� Ϊ��ʹ��ҳ��������ʱ�Զ���ȡ��һ����¼ 
	SearchOrderDetailCom_click();
}
			
function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	var tForm="";
	
	var obj=document.getElementById("TFORM");
	if (obj){ tForm="t"+obj.value; }
	
	var objtbl=document.getElementById('t'+tForm);
	//var objtbl=document.getElementById('tDHCPEStationListCom');
	
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	    
//	if (selectrow==CurrentSel) {	    
//		CurrentSel=0
//		return;
//	}

	CurrentSel=selectrow;

	ShowCurRecord(CurrentSel);

}

document.body.onload = BodyLoadHandler;

