/// DHCPEGTeamList.js

var CurrentSel=0;

var targeURL="";
var URLParamName="";

function BodyLoadHandler() {

	iniForm();
	
	}

function iniForm(){
	
	var obj; 

	//��ȡĿ��URL  
	obj=document.getElementById('TargetURLBox');
	targeURL=obj.value;
	
	//��ȡ���ݲ�����	
	obj=document.getElementById('ParamNameBox');
	URLParamName=obj.value;
	
	//


	//��ʾ��һ����¼
	ShowCurRecord(1);
	
}

//������ҳ�� �༭��������
function SearchOrderDetailCom_click(){

	var iRowId=document.getElementById("RowId").value;
	var iType="GT"
    var lnk="";
    var obj;
    var URLOtherParam="";
    
	obj=document.getElementById('OtherParamBox');
	URLOtherParam=obj.value;
	
    lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+targeURL
		+"&"+URLParamName+"="+iRowId
		+"&"+"sType"+"="+iType		
		; 

	
	if (""!=URLOtherParam) { lnk=lnk+URLOtherParam; }

	if (""!=lnk){
		parent.frames[targeURL].location.href=lnk;  
		
	} 
	 
}
//��ȡ ѡ���¼������ ѡ����ʾ���� Ϊ��ʹ��ҳ��������ʱ�Զ���ȡ��
//һ����¼ 
//�Ա㱾ҳ�����ҳ������ȷ�Ĵ������
function ShowCurRecord(selectrow)	{
	
	var SelRowObj;
	var obj;
	
	//��Ŀ���
	SelRowObj=document.getElementById('GT_RowId'+'z'+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("RowId");
		obj.value=SelRowObj.value;
	}
	else {
		//û���б���
		obj=document.getElementById("RowId");
		obj.value="";
	}

	//������ҳ�� �༭��������
	SearchOrderDetailCom_click();
}
			
function SelectRowHandler()	{

	var eSrc=window.event.srcElement;

	var objtbl=document.getElementById('tDHCPEGTeamList');
	
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
