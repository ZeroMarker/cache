/// DHCPEOrderDetailListCom.js
/// ����ʱ��		2006.03.23
/// ������		xuwm
/// ��Ҫ����		��ʾҽ����Ŀ�б���б� 
/// ��Ҫ����		�Ա�༭��Ŀ������
/// ���÷�Χ		ͨ��
/// ��Ӧ��		DHC_PE_OrderDetail
/// ����޸�ʱ��
/// ����޸���	
var CurrentSel=0;
var targeURL="";
var URLParamName="";
var FParRef=""
function BodyLoadHandler() {
	iniForm();
}

// *********************************************************************	  
function iniForm(){
	var obj; 
	var ltargeURL="";
	var lURLParamName="";
	
	

	//��ȡ��վ�� RowId
	obj=document.getElementById('ParRefBox');
	FParRef=obj.value;

	//��ȡĿ��URL  
	obj=document.getElementById('ListTargeURL');
	//ltargeURL=obj.value;
	//if (""!=ltargeURL) { targeURL=ltargeURL; }
	if(obj){targeURL="DHCPEODStandardCom"; }

	//��ȡ���ݲ�����	
	obj=document.getElementById('ParamName');
	//lURLParamName=obj.value;	
	//if (""!=lURLParamName) { URLParamName=lURLParamName; }
	if(obj){URLParamName="ParRef";}
	
	//��ʾ��һ����¼
	//ShowCurRecord(1);
}
//������ҳ�� �༭��������
function SearchOrderDetailCom_click(){
	
	var iRowId='';
	var iType='';
	var iDesc='';
	
	var obj;
	
	obj=document.getElementById("RowId");
	if (obj) { iRowId=obj.value ; }
	
    obj=document.getElementById("Type");
    if (obj) { iType=obj.value ; }
    
    obj=document.getElementById("Desc");
	if (obj) { iDesc=obj.value ; }
	
    var lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+targeURL
		+"&"+URLParamName+"="+iRowId
		+"&"+URLParamName+"Name="+iDesc
		+"&"+"OrderDetailType"+"="+iType
		; 
		//alert(lnk)
	if (""!=lnk){
		parent.frames[targeURL].location.href=lnk;  
	}	
}
//��ȡ ѡ���¼������ ѡ����ʾ���� Ϊ��ʹ��ҳ��������ʱ�Զ���ȡ��һ����¼ 
//�Ա㱾ҳ�����ҳ������ȷ�Ĵ������
function ShowCurRecord(selectrow)	{
	
	var SelRowObj;
	var obj;

	//��Ŀ���
	SelRowObj=document.getElementById('OD_RowId'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("RowId");
		obj.value=SelRowObj.value;
	}

	//��Ŀ����
	SelRowObj=document.getElementById('OD_Type'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("Type");	
		obj.value=SelRowObj.value;   
	}

	//��Ŀ����
	SelRowObj=document.getElementById('OD_Desc'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("Desc");
		obj.value=SelRowObj.innerText;
	}

	//������ҳ�� �༭��������
	SearchOrderDetailCom_click();
}
			
function SelectRowHandler()	{

	var eSrc=window.event.srcElement;
	var tForm="";
	
	var obj=document.getElementById("TFORM");
	if (obj){ tForm=obj.value; }
	
	var objtbl=document.getElementById('t'+tForm);		
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	    
//	if (selectrow==CurrentSel)
//	{	    
//		CurrentSel=0
//		return;
//	}

	CurrentSel=selectrow;
	
    ShowCurRecord(CurrentSel);


}
document.body.onload = BodyLoadHandler;
