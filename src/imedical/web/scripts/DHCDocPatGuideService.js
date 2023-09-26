/// Creator:      ������
/// CreatDate:    2013-02-26
/// Description:  ���ﵥά������js
/// Global Description:^DHCDocConfig("PatGuideDocumentsPrt","ItemCat",ItemCat):������¼��Ҫ��ӡ��ҽ������
///                    ^DHCDocConfig("PatGuideDocumentsPrt","OrdCat",OrdCat):������¼����Ҫ��ʾ���ֵ�ҽ������
///                    ^DHCDocConfig("PatGuideDocumentsPrt","Spec",SpecDesc):������¼�걾��Ӧ�Ľ���λ��,ҽ��λ�����ȼ����걾λ��>�������ҽ���λ��>ҽ������ϸ>������ϸ
///                    ^DHCDocConfig("PatGuideDocumentsPrt","DepLocation",DepRowid):������¼���Ƕ�Ӧ�Ľ���λ��,��ȿ�����ϸ�����ߴ�����
///                    ^DHCDocConfig("PatGuideDocumentsPrt","PatGuideTips",HospRowid):��Ժ���洢��ܰ��ʾ,�Ա㽫������ҽ��ʹ��
///                    ^DHCDocConfig("PatGuideDocumentsPrt","AdmDepItemCat",ItemCatRowID):������¼����λ���߿������ҵ�ҽ������
///                    ^DHCDocConfig("PatGuideDocumentsPrt","AdmDepLocation",DepRowid):������¼�������ҿ�����ҽ���Ľ���λ��
function BodyLoadHandler() {
	var	obj=document.getElementById('OrderCategory');
	if (obj) obj.multiple=false;
	if (obj) obj.onchange = OrdCat_change;
	var	obj=document.getElementById('OrdSpec');
	if (obj) obj.multiple=false;
	if (obj) obj.onchange = OrdSpec_change;
	/*var	obj=document.getElementById('RecDepList');
	if (obj) obj.multiple=false;
	if (obj) obj.onchange = RecDepList_change;*/
	///���տ��ҳ�ʼ�����¼�
	var DepStr=DHCC_GetElementData('DepStr');
	ComboRecDep=dhtmlXComboFromStr("ComboRecDep",DepStr);
	ComboRecDep.enableFilteringMode(true);
	ComboRecDep.selectHandle=ComboRecDepselectHandle;
	///�������ҳ�ʼ�����¼�	
	ComboAdmDep=dhtmlXComboFromStr("ComboAdmDep",DepStr);
	ComboAdmDep.enableFilteringMode(true);
	ComboAdmDep.selectHandle=ComboAdmDepselectHandle;
	/*var	obj=document.getElementById('AdmDep');
	if (obj) obj.multiple=false;
	if (obj) obj.onchange = AdmDep_change;*/
	var	obj=document.getElementById('Hospital');
	if (obj) obj.multiple=false;
	if (obj) obj.onchange = Hospital_change;
	var	obj=document.getElementById('AdmDepOrdCat');
	if (obj) obj.multiple=false;
	if (obj) obj.onchange = AdmDepOrdCat_change;
	BuildOrdCatList();
	BuildHideOrdCatList();
	BuildSpecList();
	//BuildRecDepList();
	BuildHospitalList();
	BuildAdmDepOrdCat();
	//BuildAdmDepList();
	var obj=document.getElementById("Save");
	if (obj) {
		obj.onclick=SaveClickHandler
	}	
}

function SaveClickHandler(){
	///������Ҫ��ӡ��ҽ������
	var Itemobj=document.getElementById('OrditemCat');
    for (var j=0;j<Itemobj.length;++j){
		if (Itemobj.options[j].selected==true)
		{ 
			var ItemCat=Itemobj.options[j].value; 
			var ret=tkMakeServerCall("web.DHCDocPatGuideDocumentsPrt","SaveConfig1","ItemCat",ItemCat,1);
	    }else{
		    var ItemCat=Itemobj.options[j].value; 
			var ret=tkMakeServerCall("web.DHCDocPatGuideDocumentsPrt","SaveConfig1","ItemCat",ItemCat,0);
	    }
	        
    }
    ///�������λ���߿������ҵ�ҽ������
	var Itemobj=document.getElementById('AdmDepItemCat');
    for (var j=0;j<Itemobj.length;++j){
		if (Itemobj.options[j].selected==true)
		{ 
			var ItemCat=Itemobj.options[j].value; 
			var ret=tkMakeServerCall("web.DHCDocPatGuideDocumentsPrt","SaveConfig1","AdmDepItemCat",ItemCat,1);
	    }else{
		    var ItemCat=Itemobj.options[j].value; 
			var ret=tkMakeServerCall("web.DHCDocPatGuideDocumentsPrt","SaveConfig1","AdmDepItemCat",ItemCat,0);
	    }
	        
    }
    ///���治��Ҫ��ʾ���ֵ�ҽ������
    var OrdCatobj=document.getElementById("HideOrdCat");
    for (var j=0;j<OrdCatobj.length;++j){
		if (OrdCatobj.options[j].selected==true)
		{ 
			var OrdCat=OrdCatobj.options[j].value; 
			var ret=tkMakeServerCall("web.DHCDocPatGuideDocumentsPrt","SaveConfig1","OrdCat",OrdCat,1);
	    }else{
		    var OrdCat=OrdCatobj.options[j].value; 
			var ret=tkMakeServerCall("web.DHCDocPatGuideDocumentsPrt","SaveConfig1","OrdCat",OrdCat,0);
	    }
	        
    }
    ///����걾����λ��
    var Specobj=document.getElementById("OrdSpec");
    for (var j=0;j<Specobj.length;++j){
		if (Specobj.options[j].selected==true)
		{ 
			//var SpecCode=Specobj.options[j].value;	
			var SpecDesc=Specobj.options[j].innerText;		
			var obj=document.getElementById("SpecLocation");
			if (obj){
				var SpecLocation=obj.value;
			} 
			var ret=tkMakeServerCall("web.DHCDocPatGuideDocumentsPrt","SaveConfig1","Spec",SpecDesc,SpecLocation);
	    }
	        
    }
    ///������ҽ���λ��
    var LocID=ComboRecDep.getSelectedValue();
    var obj=document.getElementById("RecDepLocation");
	if (obj){
		var RecDepLocation=obj.value;
	} 
	var ret=tkMakeServerCall("web.DHCDocPatGuideDocumentsPrt","SaveConfig1","DepLocation",LocID,RecDepLocation);
	
    /*var Depobj=document.getElementById("RecDepList");
    for (var j=0;j<Depobj.length;++j){
		if (Depobj.options[j].selected==true)
		{ 
			var DepRowid=Depobj.options[j].value;			
			var obj=document.getElementById("RecDepLocation");
			if (obj){
				var RecDepLocation=obj.value;
			} 
			var ret=tkMakeServerCall("web.DHCDocPatGuideDocumentsPrt","SaveConfig1","DepLocation",DepRowid,RecDepLocation);
	    }
	        
    }*/
    ///���濪�����ҽ���λ��
    var LocID=ComboAdmDep.getSelectedValue();
    var obj=document.getElementById("AdmDepLocation");
	if (obj){
		var AdmDepLocation=obj.value;
	} 
	var ret=tkMakeServerCall("web.DHCDocPatGuideDocumentsPrt","SaveConfig1","AdmDepLocation",LocID,AdmDepLocation);
	
    /*var Depobj=document.getElementById("AdmDep");
    for (var j=0;j<Depobj.length;++j){
		if (Depobj.options[j].selected==true)
		{ 
			var DepRowid=Depobj.options[j].value;			
			var obj=document.getElementById("AdmDepLocation");
			if (obj){
				var RecDepLocation=obj.value;
			} 
			var ret=tkMakeServerCall("web.DHCDocPatGuideDocumentsPrt","SaveConfig1","AdmDepLocation",DepRowid,RecDepLocation);
	    }
	        
    }*/
    ///������ܰ��ʾ
    var Hospobj=document.getElementById("Hospital");
    for (var j=0;j<Hospobj.length;++j){
		if (Hospobj.options[j].selected==true)
		{ 
			var HospRowid=Hospobj.options[j].value;			
			var obj=document.getElementById("Tips");
			if (obj){
				var Tips=obj.value;
			} 
			var ret=tkMakeServerCall("web.DHCDocPatGuideDocumentsPrt","SaveConfig1","PatGuideTips",HospRowid,Tips);
	    }
	        
    }
    
    alert ("�������");
}

function OrdCat_change(){
	ClearList("OrditemCat");
	var obj=document.getElementById("OrderCategory");
	var selectobj=obj.options[obj.selectedIndex];
	if (selectobj) {
		var OrdCatID=selectobj.value;
	}
	if (OrdCatID==""){
		alert("����ѡ��һ������");
		return flase;
	}
	///����ѡ���ҽ�����ཨ��ҽ������
	var ret=tkMakeServerCall("web.DHCDocPatGuideDocumentsPrt","GetItemCat",OrdCatID);
	BuildList(ret,"OrditemCat");
}

function AdmDepOrdCat_change(){
	ClearList("AdmDepItemCat");
	var obj=document.getElementById("AdmDepOrdCat");
	var selectobj=obj.options[obj.selectedIndex];
	if (selectobj) {
		var OrdCatID=selectobj.value;
	}
	if (OrdCatID==""){
		alert("����ѡ��һ������");
		return flase;
	}	
	///����ѡ���ҽ�����ཨ��ҽ������
	var ret=tkMakeServerCall("web.DHCDocPatGuideDocumentsPrt","GetAdmDepItemCat",OrdCatID);	
	BuildList(ret,"AdmDepItemCat");
}

function OrdSpec_change(){
	var Specobj=document.getElementById("SpecLocation");
	if (Specobj){
		Specobj.value="";
	}
	var obj=document.getElementById("OrdSpec");
	var selectobj=obj.options[obj.selectedIndex];
	if (selectobj) {
		//var SpecCode=selectobj.value;
		var SpecDesc=selectobj.innerText;
	}		
	var ret=tkMakeServerCall("web.DHCDocPatGuideDocumentsPrt","GetConfig","Spec",SpecDesc);
	Specobj.value=ret
}

/*function RecDepList_change(){
	var Depobj=document.getElementById("RecDepLocation");
	if (Depobj){
		Depobj.value="";
	}
	var obj=document.getElementById("RecDepList");
	var selectobj=obj.options[obj.selectedIndex];
	if (selectobj) {
		var DepRowid=selectobj.value;
	}		
	var ret=tkMakeServerCall("web.DHCDocPatGuideDocumentsPrt","GetConfig","DepLocation",DepRowid);
	Depobj.value=ret
}*/

/*function AdmDep_change(){
	var Depobj=document.getElementById("AdmDepLocation");
	if (Depobj){
		Depobj.value="";
	}
	var obj=document.getElementById("AdmDep");
	var selectobj=obj.options[obj.selectedIndex];
	if (selectobj) {
		var DepRowid=selectobj.value;
	}		
	var ret=tkMakeServerCall("web.DHCDocPatGuideDocumentsPrt","GetConfig","AdmDepLocation",DepRowid);
	Depobj.value=ret
}*/

function Hospital_change(){
	var Tipsobj=document.getElementById("Tips");
	if (Tipsobj){
		Tipsobj.value="";
	}
	var obj=document.getElementById("Hospital");
	var selectobj=obj.options[obj.selectedIndex];
	if (selectobj) {
		var HospRowid=selectobj.value;
	}		
	var ret=tkMakeServerCall("web.DHCDocPatGuideDocumentsPrt","GetConfig","PatGuideTips",HospRowid);
	Tipsobj.value=ret
}

function ComboRecDepselectHandle(){
	try {
		var Depobj=document.getElementById("RecDepLocation");
	    if (Depobj){
		    Depobj.value="";
	    }
		var LocID=ComboRecDep.getSelectedValue();		
		var ret=tkMakeServerCall("web.DHCDocPatGuideDocumentsPrt","GetConfig","DepLocation",LocID);
	    Depobj.value=ret
 
	}catch(e){
		alert(e.message);
	}
}

function ComboAdmDepselectHandle(){
	try {
		var Depobj=document.getElementById("AdmDepLocation");
	    if (Depobj){
		    Depobj.value="";
	    }
		var LocID=ComboAdmDep.getSelectedValue();		
		var ret=tkMakeServerCall("web.DHCDocPatGuideDocumentsPrt","GetConfig","AdmDepLocation",LocID);
	    Depobj.value=ret
 
	}catch(e){
		alert(e.message);
	}
}
///��ʼ��ҽ�������б�
function BuildOrdCatList(){
	var ret=tkMakeServerCall("web.DHCDocPatGuideDocumentsPrt","GetOrdCat");
	BuildList(ret,"OrderCategory");
}
///��ʼ������Ҫ��ʾ���ֵ�ҽ������
function BuildHideOrdCatList(){
	var ret=tkMakeServerCall("web.DHCDocPatGuideDocumentsPrt","GetHideOrdCat");
	BuildList(ret,"HideOrdCat");
}
///��ʼ���߿������ҵ�ҽ�������б�
function BuildAdmDepOrdCat(){
	var ret=tkMakeServerCall("web.DHCDocPatGuideDocumentsPrt","GetOrdCat");
	BuildList(ret,"AdmDepOrdCat");
}
///���������ַ�������ListBox
function BuildList(value,ElementName){
	ClearList(ElementName);
	if (value=="") return false;
	var char1="\1";
	var char2="\2";
	var arr=value.split(char2);
	var i=arr.length;
	for (j=0;j<i;j++){
		var oneValue=arr[j];
		var oneArr=oneValue.split(char1);
		AddList(ElementName,oneArr[0],oneArr[1],oneArr[2]);
	}
}

function AddList(ElementName,value,text,Selected){

	var obj=document.getElementById(ElementName);
	var length=obj.length;
	//alert(value+"^"+text);
	obj.options[length] = new Option(value,text);
	if (Selected==1) obj.options[length].selected=true;
}

function ClearList(ElementName){
	var obj=document.getElementById(ElementName);	
	var length=obj.length
	for(i=length-1;i>=0;i--){
		obj.remove(i);
	} //�����
}

///��ʼ���걾�б�
function BuildSpecList(){
	var ret=tkMakeServerCall("web.DHCDocPatGuideDocumentsPrt","GetSpec");
	BuildList(ret,"OrdSpec");
}
///��ʼ�����տ����б�
/*function BuildRecDepList(){
	var ret=tkMakeServerCall("web.DHCDocPatGuideDocumentsPrt","GetRecDep");
	BuildList(ret,"RecDepList");
}*/
/*function BuildAdmDepList(){
	var ret=tkMakeServerCall("web.DHCDocPatGuideDocumentsPrt","GetRecDep");
	BuildList(ret,"AdmDep");
}*/
///��ʼ��ҽԺ�б�
function BuildHospitalList(){
	var ret=tkMakeServerCall("web.DHCDocPatGuideDocumentsPrt","GetHospital");
	BuildList(ret,"Hospital");
}
document.body.onload = BodyLoadHandler;