
//����	DHCPECardAmountMove.js
//����	ת�����
//���	DHCPECardAmountMove  	
//����	2008.08.17
//������  xy


document.body.onload = BodyLoadHandler;
function BodyLoadHandler() {
	$('#SourceNo').bind('keypress',function(event){
		No_keydown("Source",event);
	});
	
		
	$('#ToNo').bind('keypress',function(event){
		No_keydown("To",event);
	});
	
	var obj=GetObj("SourceCardType");
	if (obj) obj.onchange=SourceCardType_change;
	var obj=GetObj("ToCardType");
	if (obj) obj.onchange=ToCardType_change;
	
	var obj=GetObj("BMove");
	if (obj) obj.onclick=BMove_click;
	
	websys_setfocus("SourceCardType")
}
function BMove_click()
{
	var SourceID=GetValue("SourceCardID");
	if (SourceID==""){
		alert("������Դ����");
		return false;
	}
	var ToID=GetValue("ToCardID");
	if (ToID==""){
		alert("������Ŀ������");
		return false;
	}
	var Amount=GetValue("MoveAmount");
	if (isNaN(Amount)){
		alert("��������ȷ��ת�ƽ��");
		return false;
	}
	var encmeth=GetValue("MoveClass");
	var ret=cspRunServerMethod(encmeth,SourceID,ToID,Amount);
	var Arr=ret.split("^");
	if (Arr[0]!=0){
		messageShow("","","",Arr[1]);
		return false;
	}else{
		alert("ת�Ƴɹ�")
		window.location.reload();
	}
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
	
	var obj = GetObj(Type + "CardType");
	var CardType = obj.options[obj.selectedIndex].value;
	if(CardType=="C"){
		var label = document.getElementById("c"+Type+"No");
	
		if(label) label.innerHTML=label.innerHTML.substring(0,1) + "���𿨺�";
	}else{
		var label = document.getElementById("c"+Type+"No");
		if(label) label.innerHTML=label.innerHTML.substring(0,1) + "�ǼǺ�";
	}

	SetValue(Type+"No","");
	SetValue(Type+"Info","");
	SetValue(Type+"Amount","");
	SetValue(Type+"Status","");
	SetValue(Type+"CardID","");
		
}

function No_keydown(Type,event)
{
	if (("9"==event.keyCode)||("13"==event.keyCode)) {
	
		No=getValueById(Type+"No");
		if (No=="") return false;
		var encmeth=getValueById("GetCardInfo");
		var DoType=getValueById(Type+"CardType");
		var ret=cspRunServerMethod(encmeth,No,DoType);
		var Arr=ret.split("^");
		if (Arr[0]!=0){
			alert("������Ϣϵͳ�в�����");
			return false
		}
		
		var obj = GetObj(Type+"CardType");
		var CardType = obj.options[obj.selectedIndex].value;
		if(CardType=="C"){
			SetValue(Type+"No",Arr[6]);	
		}else{
			SetValue(Type+"No",Arr[1]);	
		}
		SetValue(Type+"Info",Arr[2]);
		SetValue(Type+"Amount",Arr[5]);
		SetValue(Type+"Status",Arr[4]);
		SetValue(Type+"CardID",Arr[3]);
	}
}
function GetObj(Name)
{
	var obj=document.getElementById(Name);
	return obj;	
}
function GetValue(ElementName)
{
	var obj=GetObj(ElementName)
	if (obj){
		return obj.value;
	}else{
		return "";
	}
}
function SetValue(ElementName,value)
{
	var obj=GetObj(ElementName)
	if (obj){
		obj.value=value;
	}
}