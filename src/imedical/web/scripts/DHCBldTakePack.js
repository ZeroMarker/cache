///DHCBldTakePack.js

//ȡѪ��������Ϣ
var AppNo=document.getElementById('AppNo');
var Location=document.getElementById('Location');
var LocId=document.getElementById('LocId');
var Debtor=document.getElementById('Debtor');
var PatName=document.getElementById('Name');
var ABO=document.getElementById('ABO');
var RH=document.getElementById('RH');
var TakePackNo=document.getElementById('TakePackNo');
var Remark=document.getElementById('Remark');
//var TakePackList=document.getElementById('TakePackList');

Location.readOnly=true;
PatName.readOnly=true;
ABO.readOnly=true;
RH.readOnly=true;

var gUser=session['LOGON.USERID']
var gUsername=session['LOGON.USERNAME']
var gUsercode=session['LOGON.USERCODE']

function BodyLoadHandler() {
	InitControl();
   var obj=document.getElementById('Print');
   if (obj) obj.onclick=Print;
   var obj=document.getElementById('btnTakeList');
   if (obj) obj.onclick=ShowTakeList;
   //var obj=document.getElementById('Save');
   //if (obj) obj.onclick=FindHistroy;

   //if (TakePackList) TakePackList.onclick=SelectTakePack
  
}

function gettoday(){
    var d=new Date();
    var s=d.getDate()+"/";
    s+=(d.getMonth()+1)+"/";
    s+=d.getYear();
    return(s);
}

function getnowtime(){
   var d1 = new Date();
   var s1 = d1.getHours()+":";
   s1+=d1.getMinutes()+":";
   s1+=d1.getSeconds()+":";
   return(s1);
}


function InitControl(){
	//ȡѪ�б�
	/*
	var obj=document.getElementById("TakePackList");
	var GetTakeList=document.getElementById('GetTakeList');
	if (GetTakeList) {var encmeth=GetTakeList.value} else {var encmeth=''};
	var myExpStr="";
	var PackStr=cspRunServerMethod(encmeth,'','',AppNo.value);
	if (PackStr=='') {return 0;}
	alert(PackStr);
	//TakePackNo
	//
	var PackInfo=PackStr.split("^");
	for(i=0;i<=PackInfo.length-1;i++){
		TakePack=PackInfo[i];
		obj.multiple=false;
		obj.options[i]=new Option(PackInfo[i],i);
	}
	*/
	//tadmId.value=PatInfo[0];
	/*
	
    if (obj){
	   obj.size=1;
	   obj.multiple=false;	
	   obj.options[0]=new Option(t['CGSX'],"CGSX");
	   obj.options[1]=new Option(t['CGZL'],"CGZL");
	   obj.options[2]=new Option(t['JJSX'],"JJSX");
	   obj.options[3]=new Option(t['DLSX'],"DLSX");	   
	   obj.options[4]=new Option(t['TSPX'],"TSPX");	   
	}
	*/
	//������Ϣ
	var GetPatInfo=document.getElementById('GetPatInfo');
	if (GetPatInfo) {var encmeth=GetPatInfo.value} else {var encmeth=''};
	var PatInfoStr=cspRunServerMethod(encmeth,"",AppNo.value,TakePackNo.value);
    //alert("pat:"+PatInfoStr);
	if (PatInfoStr=='') {return 0;}
	var PatInfo=PatInfoStr.split("^");
	//alert(PatInfoStr);
	Debtor.value=PatInfo[0];
	PatName.value=PatInfo[1];
	ABO.value=PatInfo[2];
	RH.value=PatInfo[3];
	Location.value=PatInfo[4];
	LocId.value=PatInfo[5];
	Remark.value=PatInfo[6];
    ///
	var objtbl=document.getElementById('tDHCBldTakePack');
    if (objtbl.rows.length>0) {
	    var rows=objtbl.rows.length-1
		var i;
		for(i=1;i<=rows;i++){
			if (TakePackNo.value.length>0)
			{
				document.getElementById("Amountz"+i).readOnly=true;
				document.getElementById("Selectz"+i).readOnly=true;
				document.getElementById("Selectz"+i).checked=true;
				Remark.readOnly=true;
			}
			else
			{
				document.getElementById("Amountz"+i).readOnly=false;
				document.getElementById("Selectz"+i).readOnly=false;
				document.getElementById("Selectz"+i).checked=false
				Remark.readOnly=false;
			}
		}
    }
}


function BodyUnLoadHandler(){
}
function Print(){	
	if (CheckPackList()) 
	{
    	SaveTakePack();	
	}
}

function ShowTakeList()
{
    var AppNo =document.getElementById("AppNo");
    //alert(AppNo);
    if ((AppNo)&&(AppNo.value!="")) {
	   	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCBldTakePackList&AppNo="+AppNo.value;
	   	//alert(lnk);
   		var NewWin=open(lnk,"DHCBldTakePackList","scrollbars=no,resizable=no,top=10,left=10,width=1200,height=700");	
    }
}

//ѡ��ȡѪ��
function SelectTakePack(){
	var selOption=TakePackList.selectedIndex;
	var txtTake=TakePackList.options[selOption].text;
	//
	//alert("select:"+txtTake);
}
//���ȡѪ��Ϣ
function CheckPackList(){
	var objtbl=document.getElementById('tDHCBldTakePack');
	RetValue=false;
	var Amount,AppValue;
	var flag=false;
    if (objtbl.rows.length>0) {
	    var rows=objtbl.rows.length-1
		var i;
		for(i=1;i<=rows;i++){
			if (document.getElementById("Selectz"+i).checked){
				Amount=document.getElementById("Amountz"+i).value;
				//alert(IsNumber(Amount));
				if (!IsNumber(Amount)){
					alert(document.getElementById("OrderDescz"+i)+"ȡѪ����������!���ʵ��");
					RetVaue=false;
					return RetValue;
				}
				else
				{
					if (Amount<0.00001){
						alert(t['F03']);
						return false; 
					}
					RetValue=true;
					AppValue=document.getElementById("AppValuez"+i).innerText;
					if ((Amount-AppValue)>0){
						flag=true;	
					}
				}
			}
		}				
	}
	if (flag){
		//
		var ret= window.confirm("ȡѪ����������Ѫ��!�Ƿ��������?");
		if (ret) {
			return true;
		}
		else
		{
			return false;
		}
	}
	if (!RetValue){
		alert("��ѡ��Ҫȡ��ѪҺƷ��!")
	}
	return RetValue;
}
//�ж��Ƿ�Ϊ����
function IsNumber(theNum)
{
  	return theNum.search(/^[0-9]+.?[0-9]*$/)>=0;
}


//����ȡѪ��
function SaveTakePack(){
	var pList,pOrdList;
	var SelRowObj;
	var flag;
	var Amount;
	pList=AppNo.value + "^" + LocId.value + "^" + Remark.value + "^" +ABO.value + "^" +RH.value;  //Location.value
	pList = pList + "^";    //Group
	//alert(pList);
	//ȡѪ��Ϣ
	pOrdList=""
	flag=0
	var objtbl=document.getElementById('tDHCBldTakePack');
	//alert(objtbl.rows.length);
    if (objtbl.rows.length>0) {
	    var rows=objtbl.rows.length-1
		var i;
		for(i=1;i<=rows;i++){
			if (document.getElementById("Selectz"+i).checked){
				//alert(i);
				//SelRowObj=document.getElementById("OrderDescz");
				//alert(SelRowObj);
				flag=1
				pOrdList=pOrdList+ document.getElementById("OrdRowIDz"+i).innerText;
				//alert(pOrdList);
				pOrdList=pOrdList+ "^" +document.getElementById("OrderDescz"+i).innerText;
				pOrdList=pOrdList+ "^" +document.getElementById("Amountz"+i).value;
				pOrdList=pOrdList+ "^" +document.getElementById("Unitz"+i).innerText;
				pOrdList=pOrdList+ "^" +document.getElementById("Sequencez"+i).innerText;
			}				
			pOrdList=pOrdList+"|";
		}
    }
    
    if (pOrdList=='') {
	    alert(t['F02']);  //ѡ��Ѫ�ɷ�
	    return;
	}
    
    //alert(pOrdList);
    //��������
    var ins=document.getElementById('SaveTakePack');
	if (ins) {var encmeth=ins.value} else {var encmeth=''};
	var rtn=cspRunServerMethod(encmeth,"","",TakePackNo.value,gUser,pList,pOrdList);
	if (rtn=="0"){
		//alert("����ɹ�!");
		alert(t['S01']);  //����ɹ�
		
	}
	else
	{
		//alert("����ʧ��!�������:"+ret);
		alert(t['F01']+"�������:"+ret);  //����ʧ��
		return ;
	}
	//��ӡ��Ѫ��
    var xlApp,obook,osheet,xlsheet,xlBook
	var RowStart=7;
	
	var getpath=document.getElementById('getpath');
	if (getpath) {var encmeth=getpath.value} else {var encmeth=''};
	path=cspRunServerMethod(encmeth,'','');
	var Template=path+"DHCBldTakePack.xls";
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet;
	//
	xlsheet.cells(4,2).value=Location.value;
	xlsheet.cells(4,5).value=PatName.value;
	xlsheet.cells(4,8).value=Debtor.value;
	xlsheet.cells(5,2).value=ABO.value; //abo
    xlsheet.cells(5,5).value=RH.value; //rh
    //
    if (objtbl.rows.length>0) {
	    var rows=objtbl.rows.length-1
		for(i=1;i<=rows;i++){
			if (document.getElementById("Selectz"+i).checked){
				//Amount=document.getElementById("Amountz"+i).value;
				xlsheet.cells(RowStart,1).value=document.getElementById("OrderDescz"+i).innerText;
				xlsheet.cells(RowStart,6).value=document.getElementById("Amountz"+i).value;
				xlsheet.cells(RowStart,8).value=document.getElementById("Unitz"+i).innerText
				RowStart=RowStart+1
			}				
		}
    }
    xlsheet.cells(14,2).value=Remark.value;
    xlApp.Visible=false;
    //xlsheet.PrintPreview();
    xlsheet.PrintOut();
    xlBook.Close(savechanges=false);
    xlApp.Quit();
    xlApp=null;
    xlsheet=null
    return rtn
}

document.body.onload = BodyLoadHandler;
document.body.onunload = BodyUnLoadHandler;