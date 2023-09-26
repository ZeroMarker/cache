/**
 * ģ��:��Һɨ��ִ��
 * js:	DHCST.PIVA.EXECUTE 
 */
function BodyLoadHandler(){
	InitForm();
	var obj = document.getElementById("tBarcode");
	if (obj) {
		obj.onkeydown=CheckByBarcode;
	} 
	var obj = document.getElementById("tFind");
	if (obj) {
		obj.onclick=FindRecord; 
	}
}

// �����G�����жϡA������һ�������ġA��ɨ���ȥ ������ ����
function IfTheSameWard(){
	var ret=""	
	var ifSame="same"
	var ifNotSame="notSame"
	var ret=GetRecord();		
	if (ret!=""){
		return ifSame;
		var arr=ret.split("^");
		var ward=arr[0];
	    var tmpwardUserSel = document.getElementById("SelectWard");
		var arr=tmpwardUserSel.value.split('-');
		if(tmpwardUserSel){	
			if(tmpwardUserSel.value!=""){		
			    if(ward!=arr[1]){
				    alert("ע��:����Һ������"+arr[1]+"!");
				    return ifNotSame;
				}else{
					return ifSame;
				}
			}else{
				alert("��ѡ��ǰ����");
				return ifNotSame;
			}
		}
	}else{
		return ifSame;
	}
}

/// ��ʼ��
function InitForm(){
	var sum=0
    var objsum=document.getElementById("tSum");
	if (objsum)	{
		sum=objsum.value;
	} 
	var remain=GetRecordNum(); //������ ʣ������
    var objtRemain=document.getElementById("tRemain");
	var ret=""
	var objret=document.getElementById("hiddenret");
	if (objret) { /// ִ�з���ֵ =0 �ɹ� ,<0ʧ��	
		var ret=objret.value;
	} 
	var ret=GetRecord();
	if ((ret=="")&&(sum==0)){
		objsum.value=0;
		var objstate=document.getElementById("tState");
		if (objstate){
			objstate.value="" ;
		}
	}  //�޴˱�ǩ
	if (ret!=""){
		var arr=ret.split("^");
		var ward=arr[0];
		var bed=arr[1];
		var name=arr[2];
		var batno=arr[3];
		var pr=arr[4];
		var prtdt=arr[5];
		var pydt=arr[6];
	    var objward = document.getElementById("tWard");
		if (objward) {objward.value=ward}
		var objbed = document.getElementById("tBed");
		if (objbed) {objbed.value=bed}
		var objname = document.getElementById("tName");
		if (objname) {objname.value=name}
		var objbat = document.getElementById("tBatNo");
		if (objbat) {objbat.value=batno}
		var objpr = document.getElementById("tPr");
		if (objpr) {objpr.value=pr}
		var objprt= document.getElementById("tPrtDate");
		if (objprt) {objprt.value=prtdt}
		var objp = document.getElementById("tPdate");
		if (objp) {objp.value=pydt}	
		if (objsum){
			if  (objsum.value==0){
				objsum.value=1;
			}else{   
				objsum.value=parseInt(trim(objsum.value))+1; 
			}
		}			
	}
    WriteState();  //״̬д����ʾ
	//��ʼ��״̬
	var obj = document.getElementById("tExeState");
	if (obj){
		setStates();
		obj.onchange=ExeStateSelect;
	}	
	SetFocus(); 	
}

///������ ����
///���Ӽ��㲡���Ѿ���ǩ�A���ǻ�δɨ�����Һ����
function GetRecordNum()
{
	var SelectWard="" ;
	var obj = document.getElementById("SelectWard");
    if (obj) SelectWard=obj.value;
	var obj=document.getElementById("mGetRecordNum");
	if (obj) {
		var encmeth=obj.value;
	}else{
		var encmeth='';
	}
	var result=cspRunServerMethod(encmeth,SelectWard);
	return result;
}

/// д��״̬��
function WriteState(){
     var exestate=""
	 var objstr=document.getElementById("hiddenstr");
	 if (objstr) exestate=objstr.value; //ִ�з��ص�Msg
	 var objstate=document.getElementById("tState");
	 if(objstate) objstate.value=exestate;
}

/// ��ȡ��ǩ��¼
function GetRecord(){
	var bar="" ;
	var obj = document.getElementById("tBarcode");
    if (obj) bar=obj.value;
	var obj=document.getElementById("mGetRecord");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,bar);
	return result;
}

/// ��Һִ��״̬����
function setStates(){
	var obj=document.getElementById("tExeState");
	if (obj) PInitExeState(obj);
	var objindex=document.getElementById("ExeStateIndex");
	if (objindex) obj.selectedIndex=objindex.value;
}

/// ��ʼ����Һִ��״̬
function PInitExeState(listobj){
	var obj=document.getElementById("mGetExeState");
	if (obj) {
		var encmeth=obj.value;
	}else{
		var encmeth='';
	}
	var result=cspRunServerMethod(encmeth,session['LOGON.CTLOCID']);
	if (result!=""){
		var tmparr=result.split("!!")
		var cnt=tmparr.length
		for (i=0;i<=cnt-1;i++){ 
			var typestr=tmparr[i].split("^")
			var type=typestr[0];
			var typeindex=typestr[1];
			/// ��ʼ����Һִ��״̬
			if (listobj){
				listobj.size=1; 
			 	listobj.multiple=false;
			 	listobj.options[i+1]=new Option(type,typeindex);			 	
		    }
		}
	}else{
	    listobj.size=1; 
	 	listobj.multiple=false;
	}
}

/// ExeState
function ExeStateSelect(){
	var obj=document.getElementById("ExeStateIndex");
	if(obj){
		var objpass=document.getElementById("tExeState");
		obj.value=objpass.selectedIndex;
		SetFocus();
	}	
}

/// ɨ������
function CheckByBarcode(){	
	if (window.event.keyCode==13){
		window.event.keyCode=117;
		var ifthesame=""
		var ifthesame=IfTheSameWard()
		if(ifthesame=="notSame"){return}
		//������ע�� ���ڲ���
		//if (CheckBeforeFind()==false){alert("����ѡ��< Ԥִ��״̬������ ...>");return;}	
		re=Execute(); // ִ��
		if(re<0){
			alert("����ִ�СA��ο�������Һ״̬��ʾ")
			return
		}
		FindRecord(); // ��ʾ��¼
	}	
}

/// ִ��ǰ���
function CheckBeforeFind(){
	var objexe=document.getElementById("tExeState");
	if (objexe) pnumber=objexe.value;
	if (pnumber==""){
		return false;
	}else{
		return true;
	}
}

/// ���Ҽ�¼
function FindRecord(){
	var objbar=document.getElementById("tBarcode");
	if (objbar) barcode=objbar.value;
	var objstate=document.getElementById("tState");
	if (objstate) objstate.value="" ;
	var objstr=document.getElementById("hiddenstr"); //Msg
	if (objstr) objstr.value="" ;
	var objfind = document.getElementById("tFind");
	if (objfind) tFind_click();
}

/// ִ��--
function Execute(){
	var objbar=document.getElementById("tBarcode");
	if (objbar) barcode=objbar.value;
	var userid=session['LOGON.USERID'] ;
	var ctlocid=session['LOGON.CTLOCID'] ;
	var pnumber=""
	var objexe=document.getElementById("tExeState");
	if (objexe) pnumber=objexe.value;

	var obj=document.getElementById("mExecute");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,barcode,pnumber,userid,ctlocid);
	var arr=result.split("^") ;
	var state=arr[1] ;
	var ret=arr[0] ;
	
	if (barcode==""){state=""} //���,��ʼ��
	
	var objstate=document.getElementById("tState");
	if (objstate) objstate.value=state ;
	
	var objstr=document.getElementById("hiddenstr"); //Msg
	if (objstr)objstr.value=state ;
	
	var objret=document.getElementById("hiddenret"); //����ֵ  =0 �ɹ� ,<0ʧ��
	if (objret)objret.value=ret ;
    return ret  //������
	
	
}

/// ��ȡ����
function SetFocus(){
	obj=document.getElementById("tBarcode");
	if (obj){
		obj.value="";
		websys_setfocus(obj.id);
	};
}

document.body.onload=BodyLoadHandler;