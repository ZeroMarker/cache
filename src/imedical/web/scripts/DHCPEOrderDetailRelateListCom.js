/// DHCPEOrderDetailRelateListCom.js
/// ����ʱ��		2006.03.24
/// ������		xuwm
/// ��Ҫ����		��ʾҽ����Ŀ���б�
/// ��Ӧ��		DHC_PE_OrderDetailRelate
/// ����޸�ʱ��
/// ����޸���	
var CurrentSel=0;

var targeURL="";
var URLParamName="";

var FStationRowId=""
function BodyLoadHandler() {

	iniForm();
	
}

function iniForm(){

	var objParam;
	
	
	objParam=document.getElementById('ParRef');
	if (""!=objParam.value) { FStationRowId=objParam.value; }
	
	objParam=document.getElementById('ListTargeURL');
	//if (""!=objParam.value) { targeURL=objParam.value; }
	if (objParam) { targeURL="DHCPEOrderDetailRelateCom"; }
	
	objParam=document.getElementById('ParamName');
	//if (""!=objParam.value) { URLParamName=objParam.value; }
	if (objParam) { URLParamName="ParRef"; }
	
	ShowCurRecord(1);
	}


function SearchOrderDetailCom_click(){

    var obj=document.getElementById("ARCIM_DR");
    if (obj){ var iARCIM_DR=obj.value; }
	
	obj=document.getElementById("ARCIM_DR");
	obj.value="";	    
    
    var lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+targeURL
    	+"&"+URLParamName+"="+FStationRowId
		+"&"+"ParARCIMDR"+"="+iARCIM_DR
		;
    parent.frames[targeURL].location.href=lnk; 
}

//��ȡ ѡ���¼������ ѡ����ʾ���� Ϊ��ʹ��ҳ��������ʱ�Զ���ȡ��һ����¼ 
//�Ա㱾ҳ�����ҳ������ȷ�Ĵ������
function ShowCurRecord(CurRecord) {
	var selectrow=CurRecord;
	var SelRowObj
	var obj	
	
	SelRowObj=document.getElementById('ODR_ARCIM_DR'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("ARCIM_DR");
		obj.value=SelRowObj.value;
	}
	else {
		obj=document.getElementById("ARCIM_DR");
		obj.value="";	
	}

    SearchOrderDetailCom_click();
}

function SelectRowHandler()	{

	var eSrc=window.event.srcElement;
	var tForm="";
	
	var obj=document.getElementById("TFORM");
	if (obj){ tForm=obj.value; }
	
	var objtbl=document.getElementById('t'+tForm);	
	//var objtbl=document.getElementById('tDHCPEOrderDetailRelateListCom');
	
	if (objtbl) {
		var rows=objtbl.rows.length;
	}
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	//if (selectrow==CurrentSel)
	//{	    
	//    CurrentSel=0
	//    return;
	//	}

	CurrentSel=selectrow;
    ShowCurRecord(CurrentSel);


}
document.body.onload = BodyLoadHandler;
