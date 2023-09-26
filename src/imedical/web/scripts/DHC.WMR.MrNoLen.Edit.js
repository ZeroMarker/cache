
iniForm();
function iniForm()
{
	var obj=document.getElementById("cmdUpdate");
	if (obj){ obj.onclick=Update_click;}
	var obj=document.getElementById("cboType");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		obj.disabled=true;
	}
	var obj=document.getElementById("cboDefLoc");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		
		obj.length=0;
		var objItm1=document.createElement("OPTION");
		obj.options.add(objItm1);
		objItm1.innerText ='全院统一取号';
		objItm1.value = 0;
		var objItm2=document.createElement("OPTION");
		obj.options.add(objItm2);
		objItm2.innerText ='按科室取号';
		objItm2.value = 1;
	}
	var obj=document.getElementById("cboField");
	if (obj){
		obj.size=1;
		obj.multiple=false;
	}
	//add by liuxuefeng 2009-06-29 init cboMrNoCancelFlag
	var obj=document.getElementById("cboMrNoCancelFlag");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		
		obj.length=0;
		var objItm1=document.createElement("OPTION");
		obj.options.add(objItm1);
		objItm1.innerText ="Y";
		objItm1.value = "Y";
		var objItm2=document.createElement("OPTION");
		obj.options.add(objItm2);
		objItm2.innerText ="N";
		objItm2.value = "N";
	}
  //DefaultType	默认号码类型
	InitDHCWMRDICListBox("DefaultType","Y"); 
  //AdmType	就诊类型
	InitDHCWMRDICListBox("AdmType","Y"); 
  //ReceiptType	接诊方式
	InitDHCWMRDICListBox("ReceiptType","Y"); 
  //AssignType	号码发放方式
	InitDHCWMRDICListBox("AssignType","Y"); 
  //UnReceiptType	取消接诊方式
	InitDHCWMRDICListBox("UnReceiptType","Y"); 
  //RecycleType	号码回收方式
	InitDHCWMRDICListBox("RecycleType","Y"); 
}


function Update_click()
{
	var cType="",cLen="",cHead="",cDefLoc="",cMinNo="",cField="",cMrNoCancelFlag="";
	var cDefaultType="",cHospitalID="",cAdmType="",cReceiptType="",cAssignType="",cUnReceiptType="",cRecycleType="",cText1="",cText2="",cText3="",cText4="";
	cType = getElementValue("cboType");
	cLen = getElementValue("txtLen");
	cHead = getElementValue("txtHead");
	cDefLoc = getElementValue("cboDefLoc");
	cMinNo = getElementValue("txtMinNO");
	cField = getElementValue("cboField");
	cMrNoCancelFlag = getElementValue("cboMrNoCancelFlag");

	cDefaultType=getElementValue("DefaultType");
	cHospitalID=getElementValue("HospitalID");
	cAdmType=getElementValue("AdmType");
	cReceiptType=getElementValue("ReceiptType");
	cAssignType=getElementValue("AssignType");
	cUnReceiptType=getElementValue("UnReceiptType");
	cRecycleType=getElementValue("RecycleType");
	cText1=getElementValue("Text1");
	cText2=getElementValue("Text2");
	cText3=getElementValue("Text3");
	cText4=getElementValue("Text4");
	
		////////////////////////////////////////////////////////
	if ((cType=="")||(cDefLoc=="")||(cField=="")) return;
	
	var InStr=cType+"^"+cLen+"^"+cHead+"^"+cDefLoc+"^"+cMinNo+"^"+cField+"^"+cMrNoCancelFlag;
	InStr=InStr+"^"+cDefaultType+"^"+cHospitalID+"^"+cAdmType+"^"+cReceiptType+"^"+cAssignType+"^"+cUnReceiptType+"^"+cRecycleType+"^"+cText1+"^"+cText2+"^"+cText3+"^"+cText4;
	//alert(InStr);
	var obj=document.getElementById('ClassUpdate');
    if (obj) {var encmeth=obj.value} else {var encmeth=''}
    var Flag=cspRunServerMethod(encmeth,InStr);
    if (Flag>0){alert(t['UpdateTrue']);}
    else{alert(t['UpdateFalse']);}
    //alert(Flag);
    lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.MrNoLen.Edit";
    location.href=lnk;
}

function SelectRowHandler()	{
	var cMrType="",cDefLoc="",cField="",cHead="",cLen="",cMinNo="",cMrNoCancelFlag="";
	var cDefaultType="",cHospitalID="",cAdmType="",cReceiptType="",cAssignType="",cUnReceiptType="",cRecycleType="",cText1="",cText2="",cText3="",cText4="";
	var objtbl=document.getElementById('tDHC_WMR_MrNoLen_Edit');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var eSrc=window.event.srcElement;
	var objRow=getRow(eSrc);
	var selectrow=objRow.rowIndex;
	
	if (selectrow <= 0) return;
	cMrType = getElementValue('MrTpId'+"z"+selectrow);
	cDefLoc = getElementValue('DefLocId'+"z"+selectrow);
	cField = getElementValue('FieldId'+"z"+selectrow);
	cHead = getElementValue('Head'+"z"+selectrow);
	cLen = getElementValue('Len'+"z"+selectrow);
	cMinNo = getElementValue('MinNo'+"z"+selectrow);
	cMrNoCancelFlag = getElementValue('MrNoCancelFlag'+"z"+selectrow);
	
	cDefaultType = getElementValue('iDefaultType'+"z"+selectrow);
	cHospitalID = getElementValue('iHospitalID'+"z"+selectrow);
	cAdmType = getElementValue('iAdmType'+"z"+selectrow);
	cReceiptType = getElementValue('iReceiptType'+"z"+selectrow);
	cAssignType = getElementValue('iAssignType'+"z"+selectrow);
	cUnReceiptType = getElementValue('iUnReceiptType'+"z"+selectrow);
	cRecycleType = getElementValue('iRecycleType'+"z"+selectrow);
	cText1 = getElementValue('iText1'+"z"+selectrow);
	cText2 = getElementValue('iText2'+"z"+selectrow);
	cText3 = getElementValue('iText3'+"z"+selectrow);
	cText4 = getElementValue('iText4'+"z"+selectrow);
	
	if ((cMrType=="")||(cDefLoc=="")||(cField=="")) return;
	///赋值操作
	setElementValue("cboType",Trim(cMrType));
	setElementValue("cboDefLoc",Trim(cDefLoc));
	setElementValue("cboField",Trim(cField));
	setElementValue("cboMrNoCancelFlag",Trim(cMrNoCancelFlag));
	setElementValue("txtLen",Trim(cLen));
	setElementValue("txtHead",Trim(cHead));
	setElementValue("txtMinNO",Trim(cMinNo));
	setElementValue("DefaultType",Trim(cDefaultType));
	setElementValue("HospitalID",Trim(cHospitalID));
	setElementValue("AdmType",Trim(cAdmType));
	setElementValue("ReceiptType",Trim(cReceiptType));
	setElementValue("AssignType",Trim(cAssignType));
	setElementValue("UnReceiptType",Trim(cUnReceiptType));
	setElementValue("RecycleType",Trim(cRecycleType));
	setElementValue("Text1",Trim(cText1));
	setElementValue("Text2",Trim(cText2));
	setElementValue("Text3",Trim(cText3));
	setElementValue("Text4",Trim(cText4));

	
}
//以下为被调用的公共方法
//
function AddListItem(controlID, itemCaption, itemValue, pos)
{
		var obj = document.getElementById(controlID);
		obj.size=1;
		obj.multiple=false;
		var objItm = document.createElement("OPTION");
		if(pos >=0 )
		{
			obj.options.add(objItm, pos);		
		}else
		{
			obj.options.add(objItm);
		}
		objItm.innerText = itemCaption;
		objItm.value = itemValue;
		return objItm;
}


//初始化DHC_WMR_Dictionary字典选择框方法
function InitDHCWMRDICListBox(DicName,ActiveFlag)  {
	var DefaultTypeArray=GetDHCWMRDictionaryArryByTypeFlag("GetDHCWMRDictionaryArryByTypeFlag", DicName, ActiveFlag);
  var objItem=new Object();
  var obj=document.getElementById(DicName);
  var objEmptyItm=document.createElement("OPTION");
	obj.options.add(objEmptyItm);
	objEmptyItm.innerText ="";
	objEmptyItm.value = "";
  for(i=0;i<DefaultTypeArray.length;i++){
  	objItem=DefaultTypeArray[i];
  	AddListItem(DicName, objItem.Description, objItem.RowID, i+1);
  	}
  }	
