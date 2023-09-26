
var SelectedRow = 0;



document.body.onload = BodyLoadHandler;

function BodyLoadHandler(){	
	//var r = /^\+?[1-9][0-9]*$/;　　//正整数 
	//alert(r.test("5..6")); 
	var Obj=document.getElementById('fDHCCardSearch_List');
	if(Obj)Obj.ondblclick=CardSearchDBClickHander;
  
    //增加读医保卡的按钮
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
	//如果是从挂号界面打开的则将卡号带到挂号界面
    //var obj=document.getElementById('CardNo');
	//if (obj)cardno=obj.value;
	/*
	var Formobj=document.getElementById('fDHCCardSearch_List');
	
	 var win = Formobj.parentNode.parentNode;
	 //建卡界面弹出
	 if(win&&window.name=="FindPatBase")
	 {
		 var objCardNo=window.opener.opener.document.getElementById("CardNo")
		    if (objCardNo) objCardNo.value=cardno;
		    self.close();
		    window.opener.opener.websys_setfocus('CardNo');
		    window.opener.opener.focus();
	 }
	 //挂号界面弹出
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
	//获取其他证件信息
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
			alert("患者拥有不止一种卡,请选择需要修改的对应卡类型")
			}
		//设置其他证件信息
		parent.frames["UDHCCardPatInfoRegExp"].CardTypeSave(OtherCardNo);
		//关联建卡使用登记号作为卡号，验证卡号的有效性
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
