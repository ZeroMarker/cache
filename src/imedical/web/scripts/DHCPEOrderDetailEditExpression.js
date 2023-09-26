///DHCPEOrderDetailEditExpression.js
/// ����ʱ��		2006.04.07
/// ������		xuwm
/// ��Ҫ����		�༭������Ŀ�Ĺ�ʽ
/// ��Ӧ����		DHCPEOrderDetailCom
/// ����޸�ʱ��
/// ����޸���	
/// ��ҳδʹ��?��������ʹ��
var CurrentSel=0;
var targeURL="";		//Ŀ��ҳ��
var URLParamName="";	//��������
var URLOtherParem="";
function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click; }
	obj=document.getElementById("Expression");
	
	if (obj) { obj.value="10000*����/(���*���)"; }
	iniForm();
	
	}

function iniForm() {
	
	ShowCurRecord(1);

}
/*
function Update_click() {
	var strOriExpression="";
	var strExpression="";
	var tShowExpression="";
	var strResult="";
	var iLoop=0;
	var odCode="";
	var CurParam,CurOperator;
	var obj;
	var strLine="";
	var lLabels = new Array(); 
	var aList = "";
	var iRowId="",iDesc="",iCode="",iLable="";
	obj=document.getElementById("Expression");
	if (obj) { strOriExpression=obj.value; }
	
	strOriExpression=strOriExpression.split(":");
	
	aList=strOriExpression[1];
	aList=aList.split(",");
	strExpression=strOriExpression[0];

	for (iLoop=0;iLoop<aList.length;iLoop++) {
		strLine=aList[iLoop];
		strLine=strLine.split("=");
		iLable=strLine[0];
		iCode=strLine[1];
		iRowId='$C(1)'+GetOrderdetailCode(iCode)+'$C(1)';
		strExpression=strExpression.replace(iLable,iRowId);
		
	}

	obj=document.getElementById("tShowExpression");
	if (obj) { obj.value=strExpression+":"+aList; }

}
*/
function Update_click() {
	var strExpression="";
	var iLoop=0;
	var CurParam,CurOperator;
	var strLine="";
	var iRowId="",iDesc="",iCode="",iLable="";
	var ReadStatus="V"; //��ȡ����?V?��ǰ��ȡ����?O?��ǰ��ȡ��������?P��ǰ��ȡ������
	var obj;
	
	obj=document.getElementById("Expression");
	if (obj) { strExpression=obj.value+';'; }

	for (iLoop=0;iLoop<strExpression.length;iLoop++) {
		
		switch (strExpression.charAt(iLoop)){
			case "+":{
				CurOperator="+";
				ReadStatus="O";	
				break;				
			}
			case "-":{
				CurOperator="-";
				ReadStatus="O";	
				break;				
			}
			case "*":{
				CurOperator="*"
				ReadStatus="O";	
				break;			
			}
			case "/":{
				CurOperator="/";
				ReadStatus="O";			
				break;
			}
			case "(":{
				CurOperator="(";
				ReadStatus="PB";			
				break;
			}
			case ")":{
				CurOperator=")";
				ReadStatus="PE";			
				break;
			}
			
			case ";":{
				ReadStatus="F";		 
			}
			default: {
				ReadStatus="V";		 
				iDesc=iDesc+strExpression.charAt(iLoop);
				
			}

		}
		if ("O"==ReadStatus) {				
				iDesc=GetOrderdetailCode(iDesc);
				strLine=strLine+iDesc+CurOperator;
				iDesc="";	
				CurOperator="";	
		}
		if ("PB"==ReadStatus) {
				strLine=strLine+CurOperator;
				iDesc="";
				CurOperator="";
		}
		if ("PE"==ReadStatus) {
				iDesc=GetOrderdetailCode(iDesc);
				strLine=strLine+iDesc+CurOperator;
				iDesc="";
				CurOperator="";
		}			
		if ("F"==ReadStatus) {				
				iDesc=GetOrderdetailCode(iDesc);
				strLine=strExpression+';'+strLine+iDesc;
				iDesc="";					
		}
		//alert(strExpression.charAt(iLoop));
		//alert(strLine);
	}

	obj=document.getElementById("tShowExpression");
	if (obj) { obj.value=strExpression+strLine; }

}



function GetOrderdetailCode(aValue) {
	
 	if (""==aValue) { return "";}
	var tForm="";
	
	var obj=document.getElementById("TFORM");
	if (obj){ tForm=obj.value; }
	
	var objtbl=document.getElementById(tForm);
	
	var SelRowObj;
	var obj;
	var iCode="";	
	if (objtbl) { var rows=objtbl.rows.length; }
	iRowId="";
	iDesc="";
	for (var iLoop=1;iLoop<rows;iLoop++) {
		
		SelRowObj=document.getElementById('OD_Code'+'z'+iLoop);

		if (SelRowObj) { iDesc=SelRowObj.innerText; }
		else { continue; }
		
		if (iDesc==aValue) {
			aValue="["+iDesc+"]";			
			return aValue;		
		}
	}	
	return aValue;		

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

	var objtbl=document.getElementById('tDHCPEOrderDetailEditExpression');
	
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

