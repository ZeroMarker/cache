/// 							
/// DHCPEStationListCom.js
/// ����ʱ��		2006.03.16
/// ������		xuwm
/// ��Ҫ����		��ʾվ����б�
/// ��Ӧ��		DHC_PE_Station
/// ����޸�ʱ��	
/// ����޸���	
/// 			

var CurrentSel=0;
var targeURL="";		//Ŀ��ҳ��
var URLParamName="";	//��������
var URLOtherParem="";
function BodyLoadHandler() {
	
	iniForm();
	
}

function iniForm() {
	
	var obj; 
	var ltargeURL="";
	var lURLParamName="";
	//��ȡĿ��URL  
	obj=document.getElementById('TargetURLBox');
	ltargeURL=obj.value;

	if (""!=ltargeURL) {		
		targeURL=ltargeURL;
	}

	//��ȡ���ݲ�����	
	obj=document.getElementById('ParamNameBox');
	lURLParamName=obj.value;
	
	if (""!=lURLParamName) {		
		URLParamName=lURLParamName;

	}	
	//ShowCurRecord(1);

}


function SearchOrderDetailCom_click() {
 
	var iRowId="",iDesc="";
	var objParam;
	var lnk="";
	iRowId=document.getElementById("RowId").value;	
	iDesc=document.getElementById("Desc").value;

	objParam=document.getElementById('TargetURLBox');
	if (""!=objParam.value) { targeURL=objParam.value;  }

	objParam=document.getElementById('ParamNameBox');
	URLParamName=objParam.value;
	
	objParam=document.getElementById('OtherParamBox');
	URLOtherParem=objParam.value;	
	
	lnk="websys.default.csp?WEBSYS.TCOMPONENT="+targeURL
			+"&"+URLParamName+"="+iRowId;

	if (""!=iDesc) { lnk=lnk+"&"+URLParamName+"Name"+"="+iDesc; }
	if (""!=URLOtherParem) { lnk=lnk+URLOtherParem; }
	
	parent.frames[targeURL].location.href=lnk;
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

	//��ȡ ѡ���¼������ ѡ����ʾ���� Ϊ��ʹ��ҳ��������ʱ�Զ���ȡ��һ����¼ 
	SearchOrderDetailCom_click();
}
			
function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	var tForm="";
	
	var obj=document.getElementById("TFORM");
	if (obj){ tForm=obj.value; }
	
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
