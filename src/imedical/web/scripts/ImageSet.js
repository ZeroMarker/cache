var CONST_HOSPID=""; 
/*whc 2020-07-08 �����������^����*/
if(websys_isIE==true){
    document.onkeypress = null;
}else{
	document.removeEventListener("keydown", websys_sckey)
}
document.onkeydown = null;
/*end*/
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
	location.href = "websys.default.csp?WEBSYS.TCOMPONENT=ImageSet&HospitalRowId="+tem[1]+"&HospitalName="+tem[0];
	//listSet();
}  
// var ClubName=document.getElementById("ClubName").value
var SelectedRow = 0;
//����ѡ�����µ�ȫ�ֱ���
var updateId=0
//����ѡ��ɾ����ȫ�ֱ���
var deleteCode=""
function BodyLoadHandler()
{
	var objSave=document.getElementById("Save")
    if (objSave) { objSave.onclick=SaveClick}
    
    var objDelete=document.getElementById("Delete")
    if(objDelete){objDelete.onclick=DeleteClick}
    
    var objSearch=document.getElementById("Search")
    if(objSearch){objSearch.onclick=SearchClick}
}
//���ѡ��һ��
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tImageSet');//���������: t+�����
	
	var rows=objtbl.rows.length; 
	var RowObj=getRow(eSrc); 	// ѡ��ʱ�е���ɫ//RowObj.className="Needless";
	var selectrow=RowObj.rowIndex;
	var objIcoDesc=document.getElementById('IcoDesc');
	var objIcoCode=document.getElementById('IcoCode');
	var objArcimCodeS=document.getElementById('ArcimCodeS');
	var objArcimColorCode=document.getElementById('ColorCode');
	
	var IcoDescTab=document.getElementById("IcoDescTabz"+selectrow);
	var IcoCodeTab=document.getElementById("IcoCodeTabz"+selectrow);
	var ColorCodeTab="";//document.getElementById("ColorCodez"+selectrow);
   	var ArcimCodeStrTab=document.getElementById("ArcimCodeStrTabz"+selectrow);



    if((SelectedRow==selectrow)&&(objIcoDesc.value!='')){
	    console.log(objIcoDesc.value);
		objIcoDesc.value = '';
		objIcoCode.value = '';
		objArcimCodeS.value = '';
		objArcimColorCode.value = '';
	}else{
		objIcoDesc.value=IcoDescTab.innerText;
		objIcoCode.value=IcoCodeTab.innerText;
		objArcimCodeS.value=ArcimCodeStrTab.innerText;
		//objArcimColorCode.value=ColorCodeTab.innerText;
		console.log(objIcoDesc.value);
	}
	SelectedRow = selectrow;
   	deleteCode=IcoCodeTab.innerText;
   	return;
}
//���ñ��еı��溯���������ݺ���
function SaveClick()
{
	 var IcoDesc=document.getElementById("IcoDesc").value
	 var IcoCode=document.getElementById("IcoCode").value	 
	 var ArcimCodeS=document.getElementById("ArcimCodeS").value	  
	 var ColorCode="";//document.getElementById("ColorCode").value	
    if(!IcoDesc||!IcoCode||!ArcimCodeS){alert("��д����Ϣ���ڿ�ֵ,����!");return}
    //if(ColorCode.length!=0&&(ColorCode.length<7||ColorCode.indexOf('#')<0)){alert("��ɫ�����ʽ������,����!");return}
	 var SaveImageSet=document.getElementById("SaveImageSet").value;
	//alert(IcoDesc+"^"+IcoCode+"^"+ArcimCodeS)
	//�����ݱ��浽����
	CONST_HOSPID=getHospID();
	var str=cspRunServerMethod(SaveImageSet,IcoDesc,IcoCode,ArcimCodeS,ColorCode,CONST_HOSPID)
	alert("����ɹ�")
	//���¼��غ���������ˢ�º�������ֻˢ�µ�ǰҳ��
     location.reload()	
}

function DeleteClick() {
	var IcoDesc = document.getElementById("IcoDesc").value
		var ret = confirm("ȷ��ɾ��?");
	if (ret) {
		if (!IcoDesc) {
			alert("��ѡ��ɾ������");
			return
		}
		if (deleteCode == "") {
			alert("����ͨ������У�����ɾ������ʱ��������ɾ��");
			return
		}
		var DeleteImageSet = document.getElementById("DeleteImageSet").value;
		//alert(deleteCode);
		var str = cspRunServerMethod(DeleteImageSet, deleteCode)
			alert("ɾ���ɹ�")
			//���¼��غ���������ˢ�º�������ֻˢ�µ�ǰҳ��
			location.reload()
	}
	else{
		return;
	}
}
//�Ծ��ֲ�������Ϊ������ѯ���������⡪��ˢ��ʱ�򻹱�����һ�εĲ���
function SearchClick()
{
	 var ClubName=document.getElementById("ClubName").value
	 var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCClubHealth"+"&clubName1="+ClubName;
     location.href=lnk;
   // document.getElementById("ClubName").value=ClubName
   // alert(ClubName)
     //location.reload()	
}
document.body.onload = BodyLoadHandler;

	 
