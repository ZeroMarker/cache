var SelectedRow=0;
var LoopCount=0;
var BlankRow=1;
document.body.onload = BodyLoadHandler;
function BodyLoadHandler(){
	///ҽԺ������
	var cobj=document.getElementById("Hospital");
	if (cobj) {
		cobj.multiple=false;
		cobj.size=1
		var NewIndex=cobj.length;
		cobj.options[NewIndex] = new Option("","");
		var GetPrescList=document.getElementById("GetHospital")
		if (GetPrescList) {var encmeth=GetPrescList.value} else {var encmeth=''};
		if (encmeth!="") {
			if (cspRunServerMethod(encmeth,'SetHospital')!='0') {
			}
		}
	}
	///����������
	var cobj=document.getElementById("Tariff");
	if (cobj) {
		cobj.multiple=false;
		cobj.size=1
		var NewIndex=cobj.length;
		cobj.options[NewIndex] = new Option("","");
		var GetPrescList=document.getElementById("GetTariff")
		if (GetPrescList) {var encmeth=GetPrescList.value} else {var encmeth=''};
		if (encmeth!="") {
			if (cspRunServerMethod(encmeth,'SetTariff')!='0') {
			}
		}
	}
	var obj=document.getElementById("Add");
	if (obj) {obj.onclick=AddClickHandler;}

	var obj=document.getElementById("Delete");
	if (obj) {obj.onclick=DeleteClickHandler;}

	var obj=document.getElementById("Update");
	if (obj) {obj.onclick=UpdateClickHandler;}
}

//
//����ҽԺ
function SetHospital(text,value){
	var obj=document.getElementById("Hospital");
	if (obj){
		var NewIndex=obj.length;
		obj.options[NewIndex] = new Option(text,value);
	}}
//��������
function SetTariff(text,value){
	var obj=document.getElementById("Tariff");
	if (obj){
		var NewIndex=obj.length;
		obj.options[NewIndex] = new Option(text,value);
	}}
function SelectRowHandler(){
	    var eSrc=window.event.srcElement;
		var objtbl=document.getElementById('tUDHCFavOrderSets_Edit_Price');
		var rows=objtbl.rows.length;
		var lastrowindex=rows - 1;	
		var rowObj=getRow(eSrc);	
		var selectrow=rowObj.rowIndex;
		m_RowIndex=selectrow;
		if(selectrow!=SelectedRow){
		var TDateFrom=document.getElementById('TDateFromz'+selectrow).innerText;
		document.getElementById("DateFrom").value=TDateFrom;
		var DateTo=document.getElementById('TDateToz'+selectrow).innerText;
		document.getElementById("DateTo").value=DateTo;
		var Price=document.getElementById('TPricez'+selectrow).innerText;
		document.getElementById("Price").value=Price;
		var TTariff=document.getElementById('TTariffrowidz'+selectrow).value;
		document.getElementById("Tariff").value=TTariff;
		var THospital=document.getElementById('Hospitalidz'+selectrow).value;
		document.getElementById("Hospital").value=THospital
		var Pricerowid=document.getElementById('Pricerowidz'+selectrow).value;
		document.getElementById("ARCOSRowidPrice").value=Pricerowid;
		SelectedRow=selectrow
		}
		else{
			document.getElementById("DateFrom").value="";
			document.getElementById("DateTo").value="";
			document.getElementById("Price").value="";
			document.getElementById("Tariff").value="";
			document.getElementById("Hospital").value="";
			document.getElementById("ARCOSRowidPrice").value="";
			SelectedRow=0
			}

}
function DeleteClickHandler()
{	var obj=document.getElementById("ARCOSRowidPrice");
	if (obj) ARCOSRowidPrice=obj.value;
	if (ARCOSRowidPrice==""){
		alert("��ѡ��һ�к���ɾ��");
		return;
		}
	var rtn=confirm("ȷ��ɾ������")
	if (rtn==true)
	{
		var ret=tkMakeServerCall("web.DHCUserFavItemPrice","Delete",ARCOSRowidPrice);
		if (ret==0){
		alert("ɾ���ɹ�");
		location.reload()
		}
		else{alert(ret)}
		}
	else{return;}
		}
function UpdateClickHandler()
{	
	var obj=document.getElementById("ARCOSRowidPrice");
	if (obj) ARCOSRowidPrice=obj.value;
	if (ARCOSRowidPrice==""){
		alert("��ѡ��һ�к����޸�");
		return;
		}
	var obj=document.getElementById("DateFrom");
	if (obj) DateFrom=obj.value;
	if (DateFrom==""){
		alert("��ʼ���ڲ���Ϊ��");
		return;
		}
	var obj=document.getElementById("DateTo");
	if (obj) DateTo=obj.value;	
	var obj=document.getElementById("Tariff");
	if (obj) Tariff=obj.value;
	if (Tariff==""){
		alert("��ѡ��������Ŀ");
		return;
		}
	var obj=document.getElementById("Price");
	if (obj) Price=obj.value.replace(/\s/g, "");
	if (Price==""){
		alert("�۸���Ϊ��");
		return;
		}
	var price=Number(Price)
	var price1=isNaN(price)
	if (price1==true){
		alert ("�۸�����������");
		return;
	}
	var obj=document.getElementById("Hospital");
	if (obj) Hospital=obj.value;
	//alert(ARCOSRowidPrice+"^"+DateFrom+"^"+DateTo+"^"+Tariff+"^"+Price+"^"+Hospital)
	var ret=tkMakeServerCall("web.DHCUserFavItemPrice","Update",ARCOSRowidPrice,DateFrom,DateTo,Tariff,Price,Hospital);
	if (ret==0){
		alert("���³ɹ�");
		location.reload()
		}
	else{alert(ret)}
	}
function AddClickHandler()
{
	var obj=document.getElementById("ARCOSRowid");
	if (obj) ARCOSRowid=obj.value;
	var obj=document.getElementById("DateFrom");
	if (obj) DateFrom=obj.value;
	if (obj) DateFrom=obj.value;
	if (DateFrom==""){
		alert("��ʼ���ڲ���Ϊ��");
		return;
		}
		var obj=document.getElementById("DateTo");
	if (obj) DateTo=obj.value;	
	var obj=document.getElementById("Tariff");
	if (obj) Tariff=obj.value;
	if (Tariff==""){
		alert("��ѡ��������Ŀ");
		return;
		}
	var obj=document.getElementById("Price");
	if (obj) Price=obj.value.replace(/\s/g, "");
	if (Price==""){
		alert("�۸���Ϊ��");
		return;
	}
	var price=Number(Price)
	var price1=isNaN(price)
	if (price1==true){
		alert ("�۸�����������");
		return;
	}
	var obj=document.getElementById("Hospital");
	if (obj) Hospital=obj.value;
	//alert(ARCOSRowid+"^"+DateFrom+"^"+DateTo+"^"+Tariff+"^"+Price+"^"+Hospital)
	var ret=tkMakeServerCall("web.DHCUserFavItemPrice","insert",ARCOSRowid,DateFrom,DateTo,Tariff,Price,Hospital);
	if (ret==0){
		alert("����ɹ�");
		location.reload()
		}
	else{alert(ret)}
	document.getElementById("Tariff").value="";
	}
document.body.onload = BodyLoadHandler;