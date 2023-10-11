
//����  DHCPECardAmountMove.hisui.js
//����	�����ת��
//����	2019.04.20
//������  xy

$(function(){
	 
	InitCombobox();
	
	//ת��
	$("#BMove").click(function() {	
		BMove_click();		
        });
    
    //����
    $("#BClear").click(function() {	
		BClear_click();		
        });
        
     $("#SourceNo").keydown(function(e) {
			if(e.keyCode==13){
		    	No_keydown("Source")
			}
			
        }); 
        
     $("#ToNo").keydown(function(e) {
			if(e.keyCode==13){
				No_keydown("To");
				//$("#ToNo").dispatchEvent(new Event('blur', {}));
			}
			
        }); 

    /*$("#ToNo").blur(function(){
               ToNo_Change() 
             });*/

     $("#ToNo2").keydown(function(e) {
			if(e.keyCode==13){
				//ToNo2_keydown();
				$("#ToNo2").dispatchEvent(new Event('blur', {}));
			}
			
        });
      
	 $("#MoveAmount").keydown(function(e) {
			if(e.keyCode==13){
				MoveAmount_keydown();
			}
			
        }); 
    $("#ToCardType").combobox({
			onSelect:function(){
			ToCardType_change();	
		}
	    });
		
	$("#SourceCardType").combobox({
			onSelect:function(){
			SourceCardType_change();	
		}
	    });
	    
	$("#ImpSourceNo").keydown(function(e) {
		if(e.keyCode == 13){
	    	No_keydown("ImpSource");
		}
	});
	
	$("#ImpSourceCardType").combobox({
		onSelect:function(){
			ImpSourceCardType_change();	
		}
	});
	
	//����
    $("#BMClear").click(function() {	
		BMClear_click();		
        });
		
    $('#SourceCardType').combobox('setValue',"C");
    $('#ToCardType').combobox('setValue',"C");

})

//����
function BClear_click(){
	$("#SourceNo,#ToNo,#ToNo2,#SourceInfo,#ToInfo,#SourceStatus,#ToStatus,#SourceAmount,#ToAmount,#MoveAmount,#ToAmountNew,#SourceCardID,#ToCardID,#TotalNum,#TotalAmt").val("");
	$('#SourceCardType').combobox('setValue',"C");
    $('#ToCardType').combobox('setValue',"C");
	SourceCardType_change();
    ToCardType_change();


}


function SourceCardType_change()
{
	CardType_change("Source");
}

function ToCardType_change()
{
	CardType_change("To");
}

function CardType_change(Type)
{
	var CardType=getValueById(Type+"CardType");
	if(CardType=="C"){
		if(Type=="Source"){$("#SourceNoL").text("���𿨺�");}
		if(Type=="To"){$("#ToNoL").text("���𿨺�");}
		
		$("#ToNo2").css('display','block');//��ʾ
		$("#toto").css('display','block');//��ʾ
	
	}else{
		if(Type=="Source"){$("#SourceNoL").text("�ǼǺ�");}
		if(Type=="To"){$("#ToNoL").text("�ǼǺ�");}
		
		$("#TotalAmt").val("")
		
		$("#TotalNum").val("")
		
		$("#ToNo2").css('display','none');//����
		$("#toto").css('display','none');//����
		
			
	}

	setValueById(Type+"No","");
	setValueById(Type+"Info","");
	setValueById(Type+"Amount","");
	setValueById(Type+"Status","");
	setValueById(Type+"CardID","");
	setValueById("ToAmountNew","");
		
}
function ToNo2_keydown()
{
	var CardType=$("#ToCardType").combobox('getValue');	
	if(CardType=="C"){
		CalTotalAmt();
	}
}
function MoveAmount_keydown()
{
	var CardType=$("#SourceCardType").combobox('getValue');	
	if(CardType=="C"){
		CalTotalAmt();
	}
	
}
function ToNo_Change(){

	$("#ToInfo").val("");
	$("#ToStatus").val("");
	$("#ToAmount").val("");
	$("#ToCardID").val("");
	No_keydown("To")
	
	
}


function No_keydown(Type)
{
	var HospID=session['LOGON.HOSPID'];
	var LocID=session['LOGON.CTLOCID'];

	$("#"+Type+"Info").val("");
	$("#"+Type+"Status").val("");
	$("#"+Type+"Amount").val("");
	$("#"+Type+"CardID").val("");

	    var No=getValueById(Type+"No");
		if (No=="") 
		{   
		   $.messager.popover({msg: "��������𿨺�", type: "info"});
			//alert("���������");
			return false;
		}
		var DoType=getValueById(Type+"CardType");
		
		var ret=tkMakeServerCall("web.DHCPE.AdvancePayment","GetInfoByNo",No,DoType,HospID,LocID);
		var Arr=ret.split("^");
		if (Arr[0]!=0){
			 $.messager.popover({msg: "������Ϣϵͳ�в�����", type: "info"});
			//alert("������Ϣϵͳ�в�����");
			return false
		}
		
		var CardType=getValueById(Type+"CardType");
		
		if(CardType=="C"){
			 setValueById(Type+"No",Arr[6]);	
		}else{
			 setValueById(Type+"No",Arr[1]);	
		}
		 setValueById(Type+"Info",Arr[2]);
		 setValueById(Type+"Amount",Arr[5]);
		 setValueById(Type+"Status",Arr[4]);
		 setValueById(Type+"CardID",Arr[3]);
		 if((Type=="To")&&(CardType=="C")){
			 CalTotalAmt();
		 }
	
}

//�����ܽ���������
function CalTotalAmt()
{
		var ToID=$("#ToCardID").val();
	
	var ToNo=$("#ToNo").val();
	var ToNo2=$("#ToNo2").val();
	if((ToNo2=="")&&(ToNo=="")){
		$.messager.popover({msg: "�����𿨺Ų���Ϊ��", type: "info"})
		return false;
	}
	if(ToID==""){
		if(ToNo!="")
		{
			if (!IsNumber(ToNo)){
				$.messager.alert("��ʾ","�����𿨺Ų��ܰ�����ĸ","info");
				return false;
			}
		}
		if(ToNo2!="")
		{
			if (!IsNumber(ToNo2)){
				$.messager.alert("��ʾ","�����𿨺Ų��ܰ�����ĸ","info");
				return false;
			}
		}
		
	}
		
	var Amt=$("#MoveAmount").val();
	
	if ((ToID=="")&&(Amt=="")){ 
		$.messager.popover({msg: "ת�ƽ���Ϊ��", type: "info"});
	 	return false;
	}
	
	
	
	if(ToID==""){
		if((ToNo2!="")&&(ToNo!="")){
			var TotalNum=((+ToNo2)-(+ToNo)+1)
		}else{
			var TotalNum=1;
		}
		var TotalAmt=(TotalNum*(+Amt))
		$("#TotalAmt").val(TotalAmt);
		$("#TotalNum").val(TotalNum);
	}
	
	
}
function BMove_click()
{
	CalTotalAmt();
	var HospID=session['LOGON.HOSPID'];
	var LocID=session['LOGON.CTLOCID'];


	var SourceID=$("#SourceCardID").val();
	if (SourceID==""){
		$.messager.alert("��ʾ","������Դ����","info");
		return false;
	}
	var ToID=$("#ToCardID").val();
	if (ToID==""){
		//$.messager.alert("��ʾ","������Ŀ������","info");
		//return false;
		var Type=$("#ToCardType").combobox('getValue');
		var MoveNo=$("#ToNo").val();
		if (MoveNo==""){
			$.messager.alert("��ʾ","������Ŀ������","info");
			return false;
		}
		ToNo2=$("#ToNo2").val();
		if(MoveNo!="")
		{
			if (!IsNumber(MoveNo)){
				$.messager.alert("��ʾ","�����𿨺Ų��ܰ�����ĸ","info");
				return false;
			}
		}
		if(ToNo2!="")
		{
			if (!IsNumber(ToNo2)){
				$.messager.alert("��ʾ","�����𿨺Ų��ܰ�����ĸ","info");
				return false;
			}
		}


		
		if (ToNo2!=""){
			MoveNo=MoveNo+"-"+ToNo2
		}
	}
	
	var ToStatus=$("#ToStatus").val();
	var ToCardType=$("#ToCardType").combobox('getValue');
	if(ToCardType=="C"){var ToCardType="����";}
	if(ToCardType=="R"){var ToCardType="Ԥ�ɽ�";}
	var SourceCardType=$("#SourceCardType").combobox('getValue');
	if(SourceCardType=="C"){var SourceCardType="����";}
	if(SourceCardType=="R"){var SourceCardType="Ԥ�ɽ�";}
	
	if((ToCardType==SourceCardType)&&(SourceCardType=="����")){
		if(SourceID==ToID){
			$.messager.alert("��ʾ","Դ���𿨺ź͵����𿨺Ų�����ͬ������������","info");
			return false;
		
		}
	}
	if((ToCardType==SourceCardType)&&(SourceCardType=="Ԥ�ɽ�")){
		if(SourceID==ToID){
			$.messager.alert("��ʾ","�ǼǺŲ�����ͬ������������","info");
			return false;
		
		}
	}
	if((SourceID!="")&&($("#SourceStatus").val()!="����")){
		$.messager.alert("��ʾ","Դ"+SourceCardType+"��������״̬,������ת��","info");
		return false;
	}
	if((ToID!="")&&(ToStatus!="����")){
		$.messager.alert("��ʾ","��"+ToCardType+"��������״̬,������ת��","info");
		return false;
	}
	var Amount=$("#MoveAmount").val();
	if ((isNaN(Amount))||(Amount=="")||(Amount==0)||(Amount<0)){
		$.messager.alert("��ʾ","��������ȷ��ת�ƽ��","info");
		return false;
	}
	if((Amount.indexOf(".")!="-1")&&(Amount.toString().split(".")[1].length>2))
		{
			$.messager.alert("��ʾ","ת�ƽ��С������ܳ�����λ","info");
			return false;
		}

	if (ToID!=""){
		var ret=tkMakeServerCall("web.DHCPE.AdvancePayment","MoveAmount",SourceID,ToID,Amount);
	}else{
		//alert(Type+"^"+MoveNo+"^"+Amount+"^"+SourceID)
		var ret=tkMakeServerCall("web.DHCPE.AdvancePayment","InsertAPInfo",Type,MoveNo,Amount,SourceID);
	}
	var Arr=ret.split("^");
	if (Arr[0]!=0){
		$.messager.alert("��ʾ",Arr[1],"info");
		return false;
	}else{
			
		if($("#SourceNo").val()!=""){
			var SourceInfoStr=tkMakeServerCall("web.DHCPE.AdvancePayment","GetInfoByNo",$("#SourceNo").val(),getValueById("SourceCardType"),HospID,LocID);
			var SourceInfo=SourceInfoStr.split("^");
			$("#SourceAmount").val(SourceInfo[5]);
			
		}
		if($("#ToNo").val()!=""){
			var ToInfoStr=tkMakeServerCall("web.DHCPE.AdvancePayment","GetInfoByNo",$("#ToNo").val(),getValueById("ToCardType"),HospID,LocID);
			var ToInfo=ToInfoStr.split("^");
			$("#ToAmountNew").val(ToInfo[5]);
			
		}
		$.messager.alert("��ʾ","ת�Ƴɹ�","success");
	    
	}
}
//�����������
function BMClear_click(){
	$("#ImpSourceNo,#ImpSourceInfo,#ImpSourceStatus,#ImpSourceAmount,#ImpTotalAmt").val("");
    //No_keydown("ImpSource");

}
function IsNumber(value) {
  var reg = /^[0-9]+.?[0-9]*$/;
  if (reg.test(value)) {
    return true;
  }
  return false;
}


function InitCombobox()
{
	// Դ������
	var SourceCTypeObj = $HUI.combobox("#SourceCardType",{
		valueField:'id',
		textField:'text',
		panelHeight:'70',
		data:[
            {id:'R',text:$g('Ԥ�ɽ�')},
            {id:'C',text:$g('����')},
           
        ]
	});

	//��������		
	var ToCTypeObj = $HUI.combobox("#ToCardType",{
		valueField:'id',
		textField:'text',
		panelHeight:'70',
		data:[
            {id:'R',text:$g('Ԥ�ɽ�')},
            {id:'C',text:$g('����')},     
        ]
	});
	
	var ImpSourceCTypeObj = $HUI.combobox("#ImpSourceCardType",{
		valueField:'id',
		textField:'text',
		panelHeight:'70',
		data:[
            //{id:'R',text:$g('Ԥ�ɽ�')},
            {id:'C',text:$g('����'), selected:true}
           
        ]
	});
	
}
