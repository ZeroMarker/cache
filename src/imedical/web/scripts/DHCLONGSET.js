var CONST_HOSPID=""; 

function getHospID(){	
    var HospitalRowId="";
	var objHospitalRowId=document.getElementById("HospitalRowId");
    if (objHospitalRowId) HospitalRowId=objHospitalRowId.value;
	return HospitalRowId;
}
function GetHospital(str)
{
	var obj=document.getElementById('HospitalRowId');
	var tem=str.split("^");
	obj.value=tem[1];
	var obj=document.getElementById('HospitalName');
	obj.value=tem[0];
	CONST_HOSPID=getHospID();
	location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCLONGSET&HospitalRowId="+tem[1]+"&HospitalName="+tem[0];
	//listSet();
}

function BodyLoadHandler()
{
	CONST_HOSPID=getHospID();
	var obj=document.getElementById('add');
	if (obj) obj.onclick =addPri_Click;
	var obj=document.getElementById('pridel');
	if (obj) obj.onclick =Pridel_Click;
	var obj=document.getElementById('addtemprior');
	if (obj) obj.onclick =addtemprior_Click;
	var obj=document.getElementById('deltempprior');
	if (obj) obj.onclick =deltempprior_Click;
    var obj=document.getElementById('addordcat');
	if (obj) obj.onclick =addordcat_Click;
	var obj=document.getElementById('ordcatdel');
	if (obj) obj.onclick =ordcatdel_Click;
    obj=document.getElementById('SaveSet');
	if (obj) obj.onclick =Save_Click;
	
	var obj=document.getElementById("dateType");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		if(obj.options.length>0){
			obj.options.selectedIndex=0;
		}
	}
	var obj=document.getElementById("timeType");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		if(obj.options.length>0){
			obj.options.selectedIndex=0;
		}
	}
	if(CONST_HOSPID!=""){
		listSet();
	}
}
function listSet()
{
  var GetSetValue=document.getElementById("GetSetValue").value;
  var ret=cspRunServerMethod(GetSetValue,CONST_HOSPID);
  var ifloc=document.getElementById("ifloc");
  var ifordcat=document.getElementById("ifordcat");
  var ifstop=document.getElementById("ifstop");
  var ifnur=document.getElementById("IfNur");
  var SordCat=document.getElementById("SordCat");
  var ifShowOrderGroupFlag=document.getElementById("ifShowOrderGroupFlag");// �Ƿ���ʾ��������
  var dateType=document.getElementById("dateType");//���ڸ�ʽ
  var timeType=document.getElementById("timeType");//ʱ���ʽ
  
  var ifLongNextPage=document.getElementById("ifLongNextPage");//����ҽ����ת���ǻ�ҳ
  var ifLongRedLine=document.getElementById("ifLongRedLine");//����ҽ����ת���ǻ���
  var ifTempNextPage=document.getElementById("ifTempNextPage");//��ʱҽ����ת���ǻ�ҳ
  var ifTempRedLine=document.getElementById("ifTempRedLine");//��ʱҽ����ת���ǻ���
  
  var ifLongOperNextPage=document.getElementById("ifLongOperNextPage");//����ҽ���������ǻ�ҳ
  var ifLongOperRedLine=document.getElementById("ifLongOperRedLine");//����ҽ���������ǻ���
  var ifTempOperNextPage=document.getElementById("ifTempOperNextPage");//��ʱҽ���������ǻ�ҳ
  var ifTempOperRedLine=document.getElementById("ifTempOperRedLine");//��ʱҽ���������ǻ���
  var OperOrderArcim=document.getElementById("OperOrderArcim");//��ʱҽ��������ҽ����
  var OperOrderArcimDr=document.getElementById("OperOrderArcimDr");//��ʱҽ��������ҽ����
  
  var ifLongDeliverNextPage=document.getElementById("ifLongDeliverNextPage");//����ҽ���������ǻ�ҳ
  var ifLongDeliverRedLine=document.getElementById("ifLongDeliverRedLine");//����ҽ���������ǻ���
  var ifTempDeliverNextPage=document.getElementById("ifTempDeliverNextPage");//��ʱҽ���������ǻ�ҳ
  var ifTempDeliverRedLine=document.getElementById("ifTempDeliverRedLine");//��ʱҽ���������ǻ���
  var DeliverOrderArcim=document.getElementById("DeliverOrderArcim");//��ʱҽ��������ҽ����
  var DeliverOrderArcimDr=document.getElementById("DeliverOrderArcimDr");//��ʱҽ��������ҽ����

  var ifLongReformNextPage=document.getElementById("ifLongReformNextPage");//����ҽ���������ǻ�ҳ
  var ifLongReformRedLine=document.getElementById("ifLongReformRedLine");//����ҽ���������ǻ���
  var ifTranslate=document.getElementById("ifTranslate");//ҽ�����Ƿ���
  
  var arr=ret.split("!");
  //alert(ret)
  var notloc=arr[0];
  var notcat=arr[1];
  var stop=arr[3];  
  var nur=arr[4];
  var scat=arr[2];
  var locstr=notloc.split("^");
  var catstr=notcat.split("^");
  var scatstr=scat.split("^");
  var showOrderGroupFlag = arr[5];  
  var dateTypeVal = arr[6]; 
  var timeTypeVal = arr[7];
  
  var ifLongNextPageVal=arr[8];//����ҽ����ת���ǻ�ҳ
  var ifLongRedLineVal=arr[9];//����ҽ����ת���ǻ���
  var ifTempNextPageVal=arr[10];//��ʱҽ����ת���ǻ�ҳ
  var ifTempRedLineVal=arr[11];//��ʱҽ����ת���ǻ���

  var ifLongOperNextPageVal=arr[12];//����ҽ���������ǻ�ҳ
  var ifLongOperRedLineVal=arr[13];//����ҽ���������ǻ���
  var ifTempOperNextPageVal=arr[14];//��ʱҽ���������ǻ�ҳ
  var ifTempOperRedLineVal=arr[15];//��ʱҽ���������ǻ���
  var OperOrderArcimDrVal = arr[16];//����ҽ����
  var OperOrderArcimVal = arr[17];//����ҽ����
  
  var ifLongDeliverNextPageVal=arr[18];//����ҽ���������ǻ�ҳ
  var ifLongDeliverRedLineVal=arr[19];//����ҽ���������ǻ���
  var ifTempDeliverNextPageVal=arr[20];//��ʱҽ���������ǻ�ҳ
  var ifTempDeliverRedLineVal=arr[21];//��ʱҽ���������ǻ���
  var DeliverOrderArcimDrVal = arr[22];//����ҽ����
  var DeliverOrderArcimVal = arr[23];//����ҽ����
  
  var ifLongReformNextPageVal=arr[24];//����ҽ���������ǻ�ҳ
  var ifLongReformRedLineVal=arr[25];//����ҽ���������ǻ���
  var ifTranslateVal=arr[26];//ҽ�����Ƿ���
  
  for (i=0;i<locstr.length;i++)
  {
	 ifselected(locstr[i],ifloc);
  }
  for (i=0;i<catstr.length;i++)
  {
	 ifselected(catstr[i],ifordcat);
  }
  for (i=0;i<scatstr.length;i++)
  {
	 ifselected(scatstr[i],SordCat);
  }
  if (stop=="true")
  {
   ifstop.checked=true;
  }
  if (nur=="true"){
	 ifnur.checked=true ;
  }
  if (showOrderGroupFlag=="true"){
	 ifShowOrderGroupFlag.checked=true ;
  }
  dateType.value = dateTypeVal;
  timeType.value = timeTypeVal;
  
  if (ifLongNextPageVal=="true"){
	 ifShowOrderGroupFlag.checked=true ;
  }
  ifLongNextPage.checked= ifLongNextPageVal=="true";//����ҽ����ת���ǻ�ҳ
  ifLongRedLine.checked=ifLongRedLineVal=="true";//����ҽ����ת���ǻ���
  ifTempNextPage.checked=ifTempNextPageVal=="true";//��ʱҽ����ת���ǻ�ҳ
  ifTempRedLine.checked= ifTempRedLineVal=="true";//��ʱҽ����ת���ǻ���
  
  ifLongOperNextPage.checked= ifLongOperNextPageVal=="true";//����ҽ���������ǻ�ҳ
  ifLongOperRedLine.checked=ifLongOperRedLineVal=="true";//����ҽ���������ǻ���
  ifTempOperNextPage.checked=ifTempOperNextPageVal=="true";//��ʱҽ���������ǻ�ҳ
  ifTempOperRedLine.checked= ifTempOperRedLineVal=="true";//��ʱҽ���������ǻ���
  OperOrderArcimDr.value = OperOrderArcimDrVal;
  OperOrderArcim.value=OperOrderArcimVal;//��ʱҽ��������ҽ����
  
  ifLongDeliverNextPage.checked= ifLongDeliverNextPageVal=="true";//����ҽ���������ǻ�ҳ
  ifLongDeliverRedLine.checked=ifLongDeliverRedLineVal=="true";//����ҽ���������ǻ���
  ifTempDeliverNextPage.checked=ifTempDeliverNextPageVal=="true";//��ʱҽ���������ǻ�ҳ
  ifTempDeliverRedLine.checked= ifTempDeliverRedLineVal=="true";//��ʱҽ���������ǻ���
  DeliverOrderArcimDr.value = DeliverOrderArcimDrVal;
  DeliverOrderArcim.value=DeliverOrderArcimVal;//��ʱҽ��������ҽ����
  
  ifLongReformNextPage.checked= ifLongReformNextPageVal=="true";//����ҽ���������ǻ�ҳ
  ifLongReformRedLine.checked=ifLongReformRedLineVal=="true";//����ҽ���������ǻ���
  ifTranslate.checked=ifTranslateVal=="true"; //ҽ�����Ƿ���
  
}
function addPri_Click()
{  //add longtime order include priority
	var surlist=document.getElementById("Priority");
	var dlist=document.getElementById("longPriority");
	movein(surlist,dlist);
}
function Pridel_Click()
{
	var surlist=document.getElementById("longPriority");
	var dlist=document.getElementById("Priority");
	moveout1(surlist,dlist);
}
function addtemprior_Click()
{  //add temp order include priority
	var surlist=document.getElementById("Priority");
	var dlist=document.getElementById("TemPrior");
	movein(surlist,dlist);
}
function deltempprior_Click()
{
	var dlist=document.getElementById("Priority");
	var surlist=document.getElementById("TemPrior");
	moveout1(surlist,dlist);
}
function addordcat_Click()
{  ////add drug cat
	var surlist=document.getElementById("OrdCat");
	var dlist=document.getElementById("LongOrdCat");
	movein(surlist,dlist);
}
function ordcatdel_Click()
{
	var surlist=document.getElementById("LongOrdCat");
	var dlist=document.getElementById("OrdCat");
	moveout1(surlist,dlist);
}
function addlistoption(selobj,resStr,del)
{
    var resList=new Array();
    var tmpList=new Array();
    selobj.options.length=0;
    resList=resStr.split(del);
   // alert (selobj.length);
    for (i=0;i<resList.length;i++)
    {
	    tmpList=resList[i].split("|")
	    selobj.add(new Option(tmpList[1],tmpList[0]));
	}
}
function ifselected(val,list)
{
	for (var i=0;i<list.options.length;i++){
		if (list.options[i].value==val)
		{
			list.options[i].selected=true;
		}
		//alert(i);
	}
	return false;
}
function moveout_Click()
{
  ////var surlist=document.getElementById("item");
  ////var dlist=document.getElementById("itemall");
  ////moveout1(surlist,dlist);
 // savevar(surlist);
}
function movein_Click()
{
  ////var surlist=document.getElementById("itemall");
  ////var dlist=document.getElementById("item");
  ////movein(surlist,dlist);
 // savevar(dlist);
}
function Save_Click()
{
  var longordcat=document.getElementById("LongOrdCat");
  var tempprior=document.getElementById("TemPrior");
  var longPriority=document.getElementById("longPriority");
  var SaveLongSet=document.getElementById("SaveLongSet").value;
  var ifloc=document.getElementById("ifloc");
  var ifordcat=document.getElementById("ifordcat");
  var SordCat=document.getElementById("SordCat");// ҽ������
  var ifShowOrderGroupFlag=document.getElementById("ifShowOrderGroupFlag");// �Ƿ���ʾ��������
  
  var longstr=selitem(longordcat);
  var temstr=selitem(tempprior);
  var medcat=selitem(longPriority);
  var NotLoc=selecteditem(ifloc);
  var NotOrdCat=selecteditem(ifordcat);
  var NotSordCat=selecteditem(SordCat);
  var ifStop=document.getElementById("ifstop");
  var ifnur=document.getElementById("IfNur");
  var dateType = document.getElementById("dateType");//���ڸ�ʽ
  var timeType = document.getElementById("timeType");//ʱ���ʽ
  
  var ifLongNextPage=document.getElementById("ifLongNextPage");//����ҽ����ת���ǻ�ҳ
  var ifLongRedLine=document.getElementById("ifLongRedLine");//����ҽ����ת���ǻ���
  var ifTempNextPage=document.getElementById("ifTempNextPage");//��ʱҽ����ת���ǻ�ҳ
  var ifTempRedLine=document.getElementById("ifTempRedLine");//��ʱҽ����ת���ǻ���
  
  var ifLongOperNextPage=document.getElementById("ifLongOperNextPage");//����ҽ���������ǻ�ҳ
  var ifLongOperRedLine=document.getElementById("ifLongOperRedLine");//����ҽ���������ǻ���
  var ifTempOperNextPage=document.getElementById("ifTempOperNextPage");//��ʱҽ���������ǻ�ҳ
  var ifTempOperRedLine=document.getElementById("ifTempOperRedLine");//��ʱҽ���������ǻ���
  var OperOrderArcim=document.getElementById("OperOrderArcim");//��ʱҽ��������ҽ����
  var OperOrderArcimDr=document.getElementById("OperOrderArcimDr");//��ʱҽ��������ҽ����
  
  var ifLongDeliverNextPage=document.getElementById("ifLongDeliverNextPage");//����ҽ���������ǻ�ҳ
  var ifLongDeliverRedLine=document.getElementById("ifLongDeliverRedLine");//����ҽ���������ǻ���
  var ifTempDeliverNextPage=document.getElementById("ifTempDeliverNextPage");//��ʱҽ���������ǻ�ҳ
  var ifTempDeliverRedLine=document.getElementById("ifTempDeliverRedLine");//��ʱҽ���������ǻ���
  var DeliverOrderArcim=document.getElementById("DeliverOrderArcim");//��ʱҽ��������ҽ����
  var DeliverOrderArcimDr=document.getElementById("DeliverOrderArcimDr");//��ʱҽ��������ҽ����
  
  var ifLongReformNextPage=document.getElementById("ifLongReformNextPage");//����ҽ���������ǻ�ҳ
  var ifLongReformRedLine=document.getElementById("ifLongReformRedLine");//����ҽ���������ǻ���
  var ifTranslate=document.getElementById("ifTranslate");//ҽ�����Ƿ���
  
  var resStr=cspRunServerMethod(SaveLongSet,longstr+"!"+temstr+"!"+medcat+"!"+NotLoc+"!"+NotOrdCat+"!"+NotSordCat+"!"+ifStop.checked+"!"+ifnur.checked+"!"+ifShowOrderGroupFlag.checked+"!"+dateType.value+"!"+timeType.value+"!"+ifLongNextPage.checked+"!"+ifLongRedLine.checked+"!"+ifTempNextPage.checked+"!"+ifTempRedLine.checked+"!"+ifLongOperNextPage.checked+"!"+ifLongOperRedLine.checked+"!"+ifTempOperNextPage.checked+"!"+ifTempOperRedLine.checked+"!"+OperOrderArcimDr.value+"!"+OperOrderArcim.value+"!"+ifLongDeliverNextPage.checked+"!"+ifLongDeliverRedLine.checked+"!"+ifTempDeliverNextPage.checked+"!"+ifTempDeliverRedLine.checked+"!"+DeliverOrderArcimDr.value+"!"+DeliverOrderArcim.value+"!"+ifLongReformNextPage.checked+"!"+ifLongReformRedLine.checked+"!"+CONST_HOSPID+"!"+ifTranslate.checked);
  if (resStr=="0")
  {
	  alert("����ɹ�")
	  }

  return;
}
function LookUpOperOrderArcimItem(value){
var temp
 temp=value.split("^")
 arcimId=temp[1]
 document.getElementById('OperOrderArcimDr').value=arcimId
}
function LookUpDeliverOrderArcimItem(value){
var temp
 temp=value.split("^")
 arcimId=temp[1]
 document.getElementById('DeliverOrderArcimDr').value=arcimId
}
function DHCWeb_GetRowIdx(wobj)
{
	try{
		var eSrc=wobj.event.srcElement;
		//alert(wobj.name);
		if (eSrc.tagName=="IMG") eSrc=wobj.event.srcElement.parentElement;
		var rowObj=getRow(eSrc);
		var selectrow=rowObj.rowIndex;
		return 	selectrow
	}catch (e)
	{
		alert(e.toString());
		return -1;
	}
}
document.body.onload = BodyLoadHandler;
function movein(surlist,dlist)
{
    if (surlist.selectedIndex==-1){
	   return;
	   }
	var i;
	var objSelected ;// new Option(surlist[nIndex].text, surlist[nIndex].value);
	for (i=0;i<surlist.options.length;i++)
	{
		if (surlist.options[i].selected)
		{
		  if (ifexist(surlist[i].value,dlist)==false)
		 {
		    var objSelected = new Option(surlist[i].text, surlist[i].value);
	        dlist.options[dlist.options.length]=objSelected;
	       // surlist.options[i]=null;
	        i=i-1;
		 }
       	}
	}
	return;
	}
//check listitem to determine if it have the value
function ifexist(val,list)
{
	for (var i=0;i<list.options.length;i++){
		if (list.options[i].value==val)
		{
			return true;
		}
		//alert(i);
	}
	return false;
}
function moveout(surlist,dlist)
{
   if (surlist.selectedIndex==-1){
	   return;
	   }
	var nIndex=surlist.selectedIndex;
	//alert (surlist.options[nIndex].text);
	var Index =dlist.options.length;
	if (ifexist(surlist[nIndex].value,dlist)==false)
	{
	var objSelected = new Option(surlist[nIndex].text, surlist[nIndex].value);
	dlist.options[Index]=objSelected;
	}
	surlist.options[nIndex]=null;
	//form1.dismeth.options[2].selected=true;
	return;
}
function moveout1(surlist,dlist)
{
    if (surlist.selectedIndex==-1){
	   return;
	   }
	var i;
	var objSelected ;// new Option(surlist[nIndex].text, surlist[nIndex].value);
	for (i=0;i<surlist.options.length;i++)
	{
		if (surlist.options[i].selected)
		{
		  //if (ifexist(surlist[i].value,dlist)==false)
		  //{
		   // var objSelected = new Option(surlist[i].text, surlist[i].value);
	        //dlist.options[dlist.options.length]=objSelected;
	        surlist.options[i]=null;
	        i=i-1;
		 //}
       	}
	}
	return;
	}

function selitem(selbox)
{
      var tmpList=new Array();
        for ( var i=0;i<selbox.options.length;i++)
		{
			//if (selbox.options[i].selected)
			//{   //alert(tmpList.length+" //"+tmpList)
			    tmpList[tmpList.length]=selbox.options[i].value+"|"+selbox.options[i].text
			//}
		}
		if (tmpList[0]=="") tmpList=tmpList.slice(1)
		var Str=tmpList.join("^");
  return Str
}
function selecteditem(selbox)
{
      var tmpList=new Array();
        for ( var i=0;i<selbox.options.length;i++)
		{
			if (selbox.options[i].selected)
			{   //alert(tmpList.length+" //"+tmpList)
			    tmpList[tmpList.length]=selbox.options[i].value+"|"+selbox.options[i].text
			}
		}
		if (tmpList[0]=="") tmpList=tmpList.slice(1)
		var Str=tmpList.join("^");
  return Str
}
function Swap(a,b) {
	//Swap position and style of two options
	//We used to just remove then add - but this didn't work in NS6
	var opta=lstItems[a];
	var optb=lstItems[b];
	lstItems[a]= new Option(optb.text,optb.value);
	lstItems[a].style.color=optb.style.color;
	lstItems[a].style.backgroundColor=optb.style.backgroundColor;
	lstItems[b]= new Option(opta.text,opta.value);
	lstItems[b].style.color=opta.style.color;
	lstItems[b].style.backgroundColor=opta.style.backgroundColor;
	lstItems.selectedIndex=b;
}
function UpClickHandler() {
	var i=lstItems.selectedIndex;
	var len=lstItems.length;

	if ((len>1)&&(i>0)) {
		Swap(i,i-1)
	}
    savevar(lstItems);
	return false;
}
function DownClickHandler() {
	var i=lstItems.selectedIndex;
	var len=lstItems.length;
	if ((len>1)&&(i<(len-1))) {
		Swap(i,i+1)
	 }
    savevar(lstItems)
	 return false;
}