//DHCInsuLocSZ.js
//Create by yangjianzhang
//����ʦְ������������Ա����ά��
var iSeldRow=0
var Rowidobj="",XXLXobj="",YLZBHobj="",YLZZTobj="",SBCARDobj="",TXMobj="",SFZHobj=""
var Nameobj="",XBobj="",CSNYobj="",FYIDobj="",FFXZIDobj="",RZIDobj=""
var JBIDobj="",BZNYobj="",YYDHobj="",DWDMobj="",DWXZDMobj="",DWMCobj=""
var DWDZobj="",DWDHobj="",DWYBobj="",JTZZobj="",ZZDHobj="",ZZYBobj=""
var StaDateobj="",EndDateobj="",YearStrDateobj="",MZQFDobj="",MZLJobj=""
var ZYQFXobj="",NDLJobj="",ZYCSobj="",TZLXobj="",ZCYYDMobj="",ZCKSMCobj=""
var ZCBQMCobj="",ZCCWBHobj="",ZRYYDHobj="",ZRKSMCobj="",ZRBQMCobj=""
var AdmReasonobj=""
//<th scope="row"><input name="OpenFile" type="file" id="OpenFile" value="��ť" size="30"></th>
function BodyLoadHandler() {
	//var obj=document.getElementById("Query");
	//if (obj){ obj.onclick=Query_click;}
	var obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click;}
	var obj=document.getElementById("Add");
	if (obj){ obj.onclick=Add_click;}
	var obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click;}
	iniForm();
}
	
function ItemsClear(){
	Rowidobj.value=""
	YLZBHobj.value=""
	XBobj.value=""
	CSNYobj.value=""
	DWDMobj.value=""
	DWMCobj.value=""
}
function iniForm(){
	AdmReasonobj=document.getElementById("AdmReason");
	/*if(AdmReasonobj){		
		AdmReasonobj.size=1; 
		AdmReasonobj.multiple=false;	
		AddListBox(AdmReasonobj,"LocType");
	}*/
	Rowidobj=document.getElementById("Rowid");
	XXLXobj=document.getElementById("XXLX");
	//AdmReasonobj=document.getElementById("AdmReason");
	YLZBHobj=document.getElementById("YLZBH");	//������
	if (YLZBHobj){YLZBHobj.value=""}
	YLZZTobj=document.getElementById("YLZZT");	//ҽ��֤״̬
	if (YLZZTobj){YLZZTobj.value=""}
	SBCARDobj=document.getElementById("SBCARD");	//�籣����
	if (SBCARDobj){SBCARDobj.value=""}
	TXMobj=document.getElementById("TXM");		//������
	if (TXMobj){TXMobj.value=""}
	SFZHobj=document.getElementById("SFZH");	//���֤����
	if (SFZHobj){SFZHobj.value=""}
	Nameobj=document.getElementById("Name");	//��������
	if (Nameobj){Nameobj.value=""}
	XBobj=document.getElementById("XB");	///�Ա�
	if (XBobj){
		XBobj.size=1; 
		XBobj.multiple=false;	
		XBobj.options[0]=new Option(t['Sex1'],"1");
	  	XBobj.options[1]=new Option(t['Sex2'],"2");
	  	XBobj.options[2]=new Option(t['Sex9'],"9");
	}
	CSNYobj=document.getElementById("CSNY");	//��������
	if (CSNYobj){CSNYobj.onkeydown=getage}
	FYIDobj=document.getElementById("FYID");	//�������ʴ���
	if (FYIDobj){
		FYIDobj.size=1; 
		FYIDobj.multiple=false;
		AddListBox(FYIDobj,"FYID");
	}
	
	FFXZIDobj=document.getElementById("FFXZID");	//�������ʴ���
	if (FFXZIDobj){
		FFXZIDobj.size=1; 
		FFXZIDobj.multiple=false;
		AddListBox(FFXZIDobj,"FFXZID");
	}
	RZIDobj=document.getElementById("RZID");	//ְ�����
	if (RZIDobj){
		RZIDobj.size=1; 
		RZIDobj.multiple=false;
		AddListBox(RZIDobj,"RZID");
	}
	JBIDobj=document.getElementById("JBID");	//ְ������
	if (JBIDobj){
		JBIDobj.size=1; 
		JBIDobj.multiple=false;
		AddListBox(JBIDobj,"JBID");
	}
	BZNYobj=document.getElementById("BZNY");	//��֤����
	if (BZNYobj){BZNYobj.value=""}
	YYDHobj=document.getElementById("YYDH");	//ѡ��ҽԺ����
	if (YYDHobj){YYDHobj.value=""}
	DWDMobj=document.getElementById("DWDM");	//��λ����
	if (DWDMobj){DWDMobj.value=""}
	DWXZDMobj=document.getElementById("DWXZDM");	//��λ����
	if (DWXZDMobj){
		DWXZDMobj.size=1; 
		DWXZDMobj.multiple=false;
		AddListBox(DWXZDMobj,"JBID");
	}
	DWMCobj=document.getElementById("DWMC");	///��λ����
	if (DWMCobj){DWMCobj.value=""}
	DWDZobj=document.getElementById("DWDZ");	//��λ��ַ
	if (DWDZobj){DWDZobj.value=""}
	DWDHobj=document.getElementById("DWDH");	//��λ�绰
	if (DWDHobj){DWDHobj.value=""}
	DWYBobj=document.getElementById("DWYB");	//��λ�ʱ�
	if (DWYBobj){DWYBobj.value=""}
	JTZZobj=document.getElementById("JTZZ");	//��ͥ��ַ
	if (JTZZobj){JTZZobj.value=""}
	ZZDHobj=document.getElementById("ZZDH");	//��ͥ�绰
	if (ZZDHobj){ZZDHobj.value=""}
	ZZYBobj=document.getElementById("ZZYB");	//��ͥ�ʱ�
	if (ZZYBobj){ZZYBobj.value=""}
	StaDateobj=document.getElementById("StaDate");	//��Ч����(תԺת�����ʼ����)
	if (StaDateobj){StaDateobj.value=""}
	EndDateobj=document.getElementById("EndDate");	//��������(תԺת�����ֹ����)
	if (EndDateobj){EndDateobj.value=""}
	YearStrDateobj=document.getElementById("YearStrDate");	//��ȿ�ʼʱ��
	if (YearStrDateobj){YearStrDateobj.value=""}
	MZQFDobj=document.getElementById("MZQFD");	//�����𸶶�
	if (MZQFDobj){MZQFDobj.value=""}
	MZLJobj=document.getElementById("MZLJ");	//�����۸����ۼ�
	if (MZLJobj){MZLJobj.value=""}
	ZYQFXobj=document.getElementById("ZYQFX");	//סԺ����
	if (ZYQFXobj){ZYQFXobj.value=""}
	NDLJobj=document.getElementById("NDLJ");	//����ۼ�
	if (NDLJobj){NDLJobj.value=""}
	ZYCSobj=document.getElementById("ZYCS");	//סԺ����
	if (ZYCSobj){ZYCSobj.value=""}
	TZLXobj=document.getElementById("TZLX");	//ת��֪ͨ����
	if (TZLXobj){
		TZLXobj.size=1; 
		TZLXobj.multiple=false;	
		TZLXobj.options[0]=new Option(t['TZLX0'],"0");
	  	TZLXobj.options[1]=new Option(t['TZLX1'],"1");
	}
	ZCYYDMobj=document.getElementById("ZCYYDM");	//ת��ҽԺ����
	//if (ZCYYDMobj){ZCYYDMobj.value=""}
	ZCKSMCobj=document.getElementById("ZCKSMC");	//ת�������������
	if (ZCKSMCobj){ZCKSMCobj.value=""}
	ZCBQMCobj=document.getElementById("ZCBQMC");	//ת����������
	if (ZCBQMCobj){ZCBQMCobj.value=""}
	ZCCWBHobj=document.getElementById("ZCCWBH");	//ת����λ����
	if (ZCCWBHobj){ZCCWBHobj.value=""}
	ZRYYDHobj=document.getElementById("ZRYYDH");	//ת��ҽԺ����
	if (ZRYYDHobj){ZRYYDHobj.value=""}
	ZRKSMCobj=document.getElementById("ZRKSMC");	//����ת��ָ����������
	if (ZRKSMCobj){ZRKSMCobj.value=""}
	ZRBQMCobj=document.getElementById("ZRBQMC");	//����ת��ָ����������
	if (ZRBQMCobj){ZRBQMCobj.value=""}
}



function ClearAllList(obj) {
	if (obj.options.length>0) {
	for (var i=obj.options.length-1; i>=0; i--) obj.options[i] = null;
	}
}

function AddItemToList(obj,arytxt,aryval) {
	if (arytxt.length>0) {
		//if (arytxt[0]!="") {
			var lstlen=obj.length;
			for (var i=0;i<arytxt.length;i++) {
				
				obj.options[lstlen] = new Option(arytxt[i],aryval[i]); lstlen++;}
		//}
	}
}

function ListBoxSelected(ListBoxId)	{
	var row=false;
	for (var i=0;i<ListBoxId.length;i++) {
		if (ListBoxId.options[i].selected) {
			row=true;
			break;
		}
	}
	return row;
}
function AddListBox(obj,ItemName){
	
	ClearAllList(obj)
	var Ins=document.getElementById('QueryDicList');
  	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
 	var OutStr=cspRunServerMethod(encmeth,ItemName);
 	if(OutStr==""){
		return;
	}
	var arytxt=new Array();
	var aryval=new Array();
	arytxt[0]=""
	aryval[0]=""
	var valueAry=OutStr.split("!");
	if (valueAry.length>0) {
		var j=0
		for (var i=0;i<valueAry.length;i++) {			
			var arytmp=valueAry[j].split("^");
			arytxt[j+1]=arytmp[3];
			aryval[j+1]=arytmp[2];
			j++
		}	
	}
	if (obj) {
		AddItemToList(obj,arytxt,aryval)
	}
	
}
function Save(Instring){
	var Ins=document.getElementById('Save');
  	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
 	var OutStr=cspRunServerMethod(encmeth,Instring);
 	if(parseInt(OutStr)>0){
		alert("����ɹ�")
	}
	else{alert("����ʧ��")}
	
}
function Delete(){
	//var Ins=document.getElementById('Save');
  	//if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
 	//var OutStr=cspRunServerMethod(encmeth,'','',Instring);
 	//if(parseInt(OutStr)<=0){
	//	alert(t['Err02']);
	//	return;
	//}
}
function Delete_click(){
	if (confirm(t['03']+Nameobj.value+t['04'])){
		if (Rowidobj.value=""){
			alert(t['Err01']);
			return ;
		}
	}	
	
}
function Update_click(){
	if (confirm(t['02']+Nameobj.value+t['04'])){
	/*	if (Rowidobj.value==""){
			alert(t['Err01']);
			//return ;
		}*/
		var Instring=Cstr(Rowidobj)+"^"+Cstr(XXLXobj)+"^"+Cstr(YLZBHobj)+"^"+Cstr(YLZZTobj)+"^"+Cstr(SBCARDobj)+"^"+Cstr(TXMobj)+"^"+Cstr(SFZHobj)
		Instring=Instring+"^"+Cstr(Nameobj)+"^"+Cstr(XBobj)+"^"+Cstr(CSNYobj)+"^"+Cstr(FYIDobj)+"^"+Cstr(FFXZIDobj)+"^"+Cstr(RZIDobj)
		Instring=Instring+"^"+Cstr(JBIDobj)+"^"+Cstr(BZNYobj)+"^"+Cstr(YYDHobj)+"^"+Cstr(DWDMobj)+"^"+Cstr(DWXZDMobj)+"^"+Cstr(DWMCobj)
		Instring=Instring+"^"+Cstr(DWDZobj)+"^"+Cstr(DWDHobj)+"^"+Cstr(DWYBobj)+"^"+Cstr(JTZZobj)+"^"+Cstr(ZZDHobj)+"^"+Cstr(ZZYBobj)+"^"+Cstr("")+"^"+Cstr("")
		Instring=Instring+"^"+Cstr(StaDateobj)+"^"+""+"^"+Cstr(EndDateobj)+"^"+""+"^"+Cstr(YearStrDateobj)+"^"+Cstr(AdmReasonobj)+"^"+""+"^"+Cstr(MZQFDobj)+"^"+Cstr(MZLJobj)
		Instring=Instring+"^"+Cstr(ZYQFXobj)+"^"+Cstr(NDLJobj)+"^"+Cstr(ZYCSobj)+"^"+Cstr(TZLXobj)+"^"+Cstr(ZCYYDMobj)+"^"+Cstr(ZCKSMCobj)
		Instring=Instring+"^"+Cstr(ZCBQMCobj)+"^"+Cstr(ZCCWBHobj)+"^"+Cstr(ZRYYDHobj)+"^"+Cstr(ZRKSMCobj)+"^"+Cstr(ZRBQMCobj)
		//alert(Instring)
		Save(Instring);
	}

}
function Add_click(){
	alert(AdmReasonobj.innerText)
	alert(AdmReasonobj.value)
	Rowidobj.value=""
	ItemsClear()
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCInsuLocSZ');
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
     
    //alert(selectrow+"/"+rows)
    
	if (!selectrow) return;
	if (iSeldRow==selectrow){
		return;
	}
	iSeldRow=selectrow;
	var SelRowObj
	var obj
	SelRowObj=document.getElementById('TRowidz'+selectrow);
	if (SelRowObj){Rowidobj.value=SelRowObj.value}
	else{Rowidobj.value=""}
	SelRowObj=document.getElementById('TYLZBHz'+selectrow);
	if (SelRowObj){YLZBHobj.value=SelRowObj.innerText;}
	else{YLZBHobj.value=""}
	SelRowObj=document.getElementById('TSFZHz'+selectrow);
	if (SelRowObj){SFZHobj.value=SelRowObj.innerText}
	else{SFZHobj.value=""}
	SelRowObj=document.getElementById('TNamez'+selectrow);
	if (SelRowObj){Nameobj.value=SelRowObj.innerText}
	else{Nameobj.value=""}	
	SelRowObj=document.getElementById('TXBz'+selectrow);
	if (SelRowObj){XBobj.value=SelRowObj.innerText}
	else{XBobj.value=""}
	SelRowObj=document.getElementById('TCSNYz'+selectrow);
	if (SelRowObj){CSNYobj.value=SelRowObj.innerText}
	else{CSNYobj.value=""}
	/*SelRowObj=document.getElementById('TAdmReasonz'+selectrow);
	if (SelRowObj){AdmReasonobj.value=SelRowObj.value;}
	else{AdmReasonobj.value=""}*/
	SelRowObj=document.getElementById('TDWDMz'+selectrow);
	if (SelRowObj){DWDMobj.value=SelRowObj.innerText}
	else{DWDMobj.value=""}
	SelRowObj=document.getElementById('TDWMCz'+selectrow);
	if (SelRowObj){DWMCobj.value=SelRowObj.innerText}
	else{DWMCobj.value=""}
	SelRowObj=document.getElementById('TMZQFDz'+selectrow);
	if (SelRowObj){MZQFDobj.value=SelRowObj.innerText}
	else{MZQFDobj.value=""}
	SelRowObj=document.getElementById('TMZLJz'+selectrow);
	if (SelRowObj){MZLJobj.value=SelRowObj.innerText}
	else{MZLJobj.value=""}
	SelRowObj=document.getElementById('TZYQFXz'+selectrow);
	if (SelRowObj){ZYQFXobj.value=SelRowObj.innerText}
	else{ZYQFXobj.value=""}
	SelRowObj=document.getElementById('TNDLJz'+selectrow);
	if (SelRowObj){NDLJobj.value=SelRowObj.innerText}
	else{NDLJobj.value=""}
	SelRowObj=document.getElementById('TZYCSz'+selectrow);
	if (SelRowObj){ZYCSobj.value=SelRowObj.innerText}
	else{ZYCSobj.value=""}
}	 
function Cstr(obj){
	OutStr=""
	if (obj==null){return OutStr }
	if (obj.value!=undefined){OutStr=obj.value}
	return OutStr
}
function InPut(FileName){
	    var xlApp,obook,osheet,xlsheet,xlBook,temp,str,vbdata,i,j 
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(FileName);
	    xlsheet = xlBook.ActiveSheet  
	    //var objtbl=parent.frames[0].document.getElementById('tINSUPRTFOOTSUM');
	    var i,j,k
	    ExcelRows=ExcelSheet.UsedRange.Cells.Rows.Count;   
		ExcelCols=ExcelSheet.UsedRange.Cells.Columns.Count;
		if (ExcelCols<24) {alert("��ѡ����ȷ�������ļ�!");return;}
        for (i=1;i<ExcelRows;i++)
        {
	        var TmpList=new Array();
	        TmpList[0]=""
			for (j=1;j<ExcelCols;j++){
				TmpList[j]=ExcelSheet.Cells(i,j).text
			}
			var VerStr=tkMakeServerCall("web.DHCINSULOCInfo","GetLocInfoBySSID",TmpList[6],AdmReasonobj.value)
			var VerArr=VerStr.split("^")
			if (parseInt(VerArr[0])<=0){
				TmpList[0]=""
			}
			else{  ///�Ƿ���Ҫ�������ж�
				if(TmpList[1]="1"){TmpList[0]=""}
				}
			var InString=""
			for(k=0;k<TmpList.length;k++){
				if (InString=="") {InString=TmpList[k]}
				else {InString=InString+"^"+TmpList[k]}
				}
			Save(InString)
	    }
	    xlApp.Visible=false
	    xlBook.Close (savechanges=false);
	    xlApp.Quit();
	    xlApp=null;
	    xlsheet=null   
}
 function getage()
 {	
 	if (window.event.keyCode==13) 
	{
		var p1=obj.value
		if (p1==""){
			alert(t['09']);
		return;
		}    
		getage1()
	}
 }
 function getage1(){
	 var p1=CSNYobj.value
     if (p1==""){
	     alert(t['09']);
	     return;
	 }else{
	 Birth_OnBlur(obj);
	 }
 }
 function Birth_OnBlur(obj){
	var mybirth=DHCWebD_GetObjValue("CSNY");
	if ((mybirth=="")||((mybirth.length!=8)&&((mybirth.length!=10)))){
		var obj=document.getElementById("CSNY");
		obj.className='clsInvalid';
		//websys_setfocus("birthdate");
		//return websys_cancel();
	}else{
		var obj=document.getElementById("CSNY");
		obj.className='clsvalid';
	}
	if ((mybirth.length==8)){
		var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(4,6)+"-"+mybirth.substring(6,8)
		DHCWebD_SetObjValueA("CSNY",mybirth);
	}
}
function DHCWebD_SetObjValueA(TName,transval){
	var Tobj=document.getElementById(TName);
	if(!Tobj){
		return;
	}
	switch (Tobj.type)
	{
		case "select-one":
			var myrows=Tobj.options.length;
			Tobj.options[myrows] = new Option(transval,"");	//,aryval[i]	
			break;
		case "checkbox":
			Tobj.checked=transval;	//txtobj.checked;
			break;
		case "text":
			Tobj.innerText=transval;		//txtobj.value;
			break;
		case "hidden":
			Tobj.value=transval;
			break;
		default:
			Tobj.innerText=transval;		//txtobj.value;
			break;
	}
}
function DHCWebD_GetObjValue(objname)
{
	var obj=document.getElementById(objname);
	var transval="";
	if (obj){
		switch (obj.type)
		{
			case "select-one":
				myidx=obj.selectedIndex;
				transval=obj.options[myidx].text;
				break;
			case "checkbox":
				transval=obj.checked;
				break;
			case "dhtmlXCombo":
				transval=obj.getSelectedValue();
				
				break;
			default:
				transval=obj.value;
				break;
		}
	}
	return transval;
}
function SetData(value){
	var TempData=value.split("^");
	var obj=document.getElementById("AdmReason")
	if (obj){
		obj.value=TempData[2];	
	}		
	obj=document.getElementById("AdmReasonDesc")
	if (obj){obj.value=TempData[3];
	    Disease=TempData[3];
	 }	
}
document.body.onload = BodyLoadHandler;