
var SelectedRow = 0;



document.body.onload = BodyLoadHandler;

function BodyLoadHandler(){	
	//var r = /^\+?[1-9][0-9]*$/;����//������ 
	//alert(r.test("5..6")); 
	var Obj=document.getElementById('fDHCCardSearch_List');
	if(Obj)Obj.ondblclick=CardSearchDBClickHander;
  
    //���Ӷ�ҽ�����İ�ť
	var myobj = document.getElementById("ReadInsuICCardInfo");
	if (myobj){
		myobj.onclick = DHCCReadInsuCardInfo;
	}
}


function CardSearchDBClickHander()
{
	if (SelectedRow==0) return;
	
	var myPatientID="";
	var myobj=document.getElementById('TPatientIDz'+SelectedRow);
	if (myobj!=null) myPatientID=myobj.value;
	//var cardno=document.getElementById('CardNOz'+SelectedRow).innerText;
	var Regno=document.getElementById('TRegNoz'+SelectedRow).innerText;
	//����ǴӹҺŽ���򿪵��򽫿��Ŵ����ҺŽ���
    //var obj=document.getElementById('CardNo');
	//if (obj)cardno=obj.value;
	/*
	var Formobj=document.getElementById('fDHCCardSearch_List');
	
	 var win = Formobj.parentNode.parentNode;
	 //�������浯��
	 if(win&&window.name=="FindPatBase")
	 {
		 var objCardNo=window.opener.opener.document.getElementById("CardNo")
		    if (objCardNo) objCardNo.value=cardno;
		    self.close();
		    window.opener.opener.websys_setfocus('CardNo');
		    window.opener.opener.focus();
	 }
	 //�ҺŽ��浯��
	if (window.name=="FindPatReg"){
			var Parobj=window.opener
	    var objCardNo=Parobj.document.getElementById("CardNo")
	    if (objCardNo) objCardNo.value=cardno;
      self.close();
	    Parobj.websys_setfocus('CardNo'); 
	}
	if (window.name=="UDHCJFIPReg"){
			
			var Parobj=window.opener
		    var objRegno=Parobj.document.getElementById("Regno")
		    if (objRegno) objRegno.value=Regno;
		    self.close();
		    Parobj.getpatinfo1()
		    Parobj.websys_setfocus('name'); 
				}
	if (window.name=="UDHCCardPatInfoRegExp"){
			
			  var Parobj=window.opener;
		    self.close();
		    Parobj.ValidateRegInfoByCQU(myPatientID);
		    
	}*/
	//self.close();
	//parent.frames["UDHCCardPatInfoRegExp"].ValidateRegInfoByCQU(myPatientID);
	//��ȡ����֤����Ϣ
	var OtherCardNo=""
	var ObjOtherCardNo=document.getElementById('OtherCardNoz'+SelectedRow);
	if (ObjOtherCardNo){
		OtherCardNo=ObjOtherCardNo.value;
	}
	if (parent.frames["UDHCCardPatInfoRegExp"]){
		//Regno
		parent.frames["UDHCCardPatInfoRegExp"].DHCWebD_SetObjValueA("PAPMINo", Regno);
		parent.frames["UDHCCardPatInfoRegExp"].GetPatDetailByPAPMINo()
		var CardNO=document.getElementById('CardNOz'+SelectedRow).innerText;
		if (CardNO.indexOf(",")<0){
		var CardType=tkMakeServerCall('web.DHCPATCardUnite','ReadCardTypeByDesc',CardNO)
		parent.frames["UDHCCardPatInfoRegExp"].myCombAry["CardTypeDefine"].setComboValue(CardType);
		parent.frames["UDHCCardPatInfoRegExp"].CardTypeDefine_OnChange()
		}else{
			alert("����ӵ�в�ֹһ�ֿ�,��ѡ����Ҫ�޸ĵĶ�Ӧ������")
			}
		//��������֤����Ϣ
		parent.frames["UDHCCardPatInfoRegExp"].CardTypeSave(OtherCardNo);
		//��������ʹ�õǼǺ���Ϊ���ţ���֤���ŵ���Ч��
		parent.frames["UDHCCardPatInfoRegExp"].CheckForUsePANoToCardNO();
		
		
	}
	
}


function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCCardSearch_List');
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;	
	var rowObj=getRow(eSrc);	
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;

	SelectedRow = selectrow;
}
