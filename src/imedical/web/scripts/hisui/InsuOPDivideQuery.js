var GROUPID=session['LOGON.GROUPID']
var iSeldRow=0
var TDivDr="",TDHCJFFlag="",TPaadm="",TBillNO="",TAdmReason="",THisType="",TDivFlag=""
var repidsub="";
var HospDr=session['LOGON.HOSPID'];
function BodyLoadHandler() { 
	init_Layout() // tangzf 2019-5-19
	///websys_setfocus2("RegNO")   ///Ϊɶ�ò��ˣ�������
	var obj=document.getElementById("RegNO")
	if(obj){
		obj.focus();		
		obj.onkeydown=Reg_onkeydown;			
	}
	var obj=document.getElementById("PrtNO")
	if(obj){
		obj.onkeydown=Text_onkeydown;		
	}
	var obj=document.getElementById("PrtInv")
	if(obj){
		obj.onkeydown=Text_onkeydown;
	}
	var obj=document.getElementById("InsuNO")
	if(obj){obj.onkeydown=Text_onkeydown}
	
	var obj=document.getElementById("TradeNO");
	if(obj){
		obj.onkeydown=Text_onkeydown;
	}
	var obj=document.getElementById("DivideStrike")
	if (obj){
		obj.onclick=DivideStrike_onclick
			
	}
	

    // DingSH 2015-12-17
    var obj=document.getElementById("DiviStrikeForInsu")
	if (obj){
		obj.onclick=DiviStrikeForInsu_onclick
			
	}
	// DingSH 2015-12-17
    var obj=document.getElementById("DiviStrikeForHis")
	if (obj){
		obj.onclick=DiviStrikeForHis_onclick
			
	}
	var obj=document.getElementById("ReadCard")
	if (obj){
		obj.onclick=ReadCard_onclick
	}
	var obj=document.getElementById("AdmInfo")
	if(obj){
		//obj.size=1
		//obj.multiple=false
	}
	init_INSUType(); 
	init_AdmInfo();

	
	var obj=document.getElementById("RegCancel")
	if(obj){obj.onclick=RegCancel_click}
	
	document.getElementById("HisType").value="O"  //��Ĭ��ֵ������
	
	var expobj=document.getElementById("ExpStr")
	if(expobj){
		var expsaveobj=document.getElementById("ExpStrSave")
		if(expsaveobj){expobj.value=expsaveobj.value;}
		//StrikeFlag^��ȫ��Dr^InsuNo^CardType^YLLB^DicCode^DicDesc^�ܽ�Money^MoneyType
		if(""==expobj.value){expobj.value="^"+GROUPID+"^^^^^^!0^"}
	}
	
	var obj=document.getElementById("BillDr") 
	if(obj){obj.style.display="none";}
	var obj=document.getElementById("cBillDr")
	if(obj){obj.style.display="none";}
	GetAdmInfoNew();
}
function ReadCard_onclick(){
	var InsuType=getValueById('InsuDllType') //document.getElementById("InsuDllType").value
	if (InsuType == ""){
		DHCWeb_HISUIalert('��ѡ��ҽ������');
		return;	
	}
	var CardStr=InsuReadCard("0",session['LOGON.USERID'],"","",InsuType).toString() //3003313901
	if(CardStr.split("|").length<2){
		return;
	}
	CardStr=CardStr.split("|")[1]
	var InsuNO=CardStr.split("^")[0]    //���ݷ��صĶ�����Ϣ��ȡ��ҽ����id0000;����insu_divide��Id0000�Ĵ洢����
	var InsuCardNO=CardStr.split("^")[1]
	document.getElementById("InsuNO").value=InsuNO
	document.getElementById("InsuCardNO").value=InsuCardNO
	//var obj=document.getElementById("InsuNO")
	//if(obj){DHCWeb_HISUIalert(obj.value)}
	var obj=document.getElementById("DivQuery");
	if (obj) {
		DivQuery_click();
		//GetAdmInfo();
		GetAdmInfoNew();
	}	
	
}
function Reg_onkeydown(){
	var obj=document.getElementById("RegNO")
	if (obj){
		if (window.event.keyCode==13){
			/*
			var PapmiNoLength=10-obj.value.length;     //�ǼǺŲ��� ,������Ŀ�޸Ĺ涨���ȣ�����Ϊ8  	
			if (obj){
				for (var i=0;i<PapmiNoLength;i++){
					obj.value="0"+obj.value;			
				}			
			}
			*/
			var tmpregno=tkMakeServerCall("web.UDHCJFBaseCommon","regnocon",obj.value)	//Zhan 20160725,�ǼǺŲ�ȫ
			if(tmpregno.length>7){obj.value=tmpregno}
			var obj=document.getElementById("DivQuery");
			if (obj) {DivQuery_click();
			//GetAdmInfo() 
			GetAdmInfoNew();
			}
		}
	}
}
function Text_onkeydown(){
		if (window.event.keyCode==13){
			var obj=document.getElementById("DivQuery");
		    if (obj) {
			    DivQuery_click();
		    	//GetAdmInfo();
		    	GetAdmInfoNew();
		     }
	
		}
}

function GetAdmInfo(){
	return;
	var AdmInfo=tkMakeServerCall("web.DHCINSUDivQue","GetAdmInfoEx")
	if(AdmInfo!=""){
		var obj=document.getElementById("AdmInfo")
		if(obj){
			obj.size=1
			obj.multiple=false
			for(var i=1;i<(AdmInfo.split("!").length-1);i++){
				obj.options[i-1]=new Option(AdmInfo.split("!")[i],AdmInfo.split("!")[i].split("^")[0]+"^"+AdmInfo.split("!")[i].split("^")[3])
				}		
			}		
	}
		
}
function GetAdmInfoNew(){
	var AdmInfoinfo=tkMakeServerCall("web.DHCINSUDivQue","GetAdmInfoEx",repidsub)
	if(AdmInfoinfo!=""){
		var obj=document.getElementById("AdmInfo")
		if(obj){
			//obj.size=1
			//obj.multiple=false
		 	$('#AdmInfo').combobox('loadData',[]);
			for(var i=0;i<AdmInfoinfo.split("!").length;i++){
				DHCWeb_AddToCombobox('AdmInfo',AdmInfoinfo.split("!")[i],AdmInfoinfo.split("!")[i].split("^")[0]+"^"+AdmInfoinfo.split("!")[i].split("^")[3]) // tangzf 2019-5-19
				//obj.options[i]=new Option(AdmInfo.split("!")[i],AdmInfo.split("!")[i].split("^")[0]+"^"+AdmInfo.split("!")[i].split("^")[3])
				}		
			}		
	}
}
function SelectRowHandler(index,rowData)	{
	//var eSrc=window.event.srcElement;
	//var objtbl=document.getElementById('tInsuOPDivideQuery');
	//	var rows=objtbl.rows.length;
	
	//var lastrowindex=rows - 1;
	
	//var rowObj=getRow(eSrc);

	var selectrow=index+1 //rowObj.rowIndex; tangzf 2019-5-19 hisui �� 0 ��ʼ
	if (!selectrow) return;
	if (iSeldRow==selectrow){TDivDr="",iSeldRow=0;return}
	iSeldRow=selectrow;
	var SelRowObj=rowData
	//SelRowObj=document.getElementById('TDivDrz'+selectrow);
	if (SelRowObj){TDivDr=rowData.TDivDr} //SelRowObj.innerText}
	else{TDivDr=""}
	
	//SelRowObj=document.getElementById('TPaadmz'+selectrow);
	if (SelRowObj){TPaadm=rowData.TPaadm}
	else{TPaadm=""}
	
	//SelRowObj=document.getElementById('TPrtNOz'+selectrow);
	if (SelRowObj){TPrtNO=rowData.TPrtNO}
	else{TPrtNO=""}
	
	//SelRowObj=document.getElementById('TBillNOz'+selectrow);
	if (SelRowObj){TBillNO=rowData.TBillNO}
	else{TBillNO=""}
	
	//SelRowObj=document.getElementById('TDHCJFFlagz'+selectrow);
	if (SelRowObj){TDHCJFFlag=rowData.TDHCJFFlag}
	else{TDHCJFFlag=""}
	
	//SelRowObj=document.getElementById('THisTypez'+selectrow);
	if (SelRowObj){THisType=rowData.THisType}
	else{THisType=""}
	
	//SelRowObj=document.getElementById('TAdmReasonz'+selectrow);
	if (SelRowObj){TAdmReason=rowData.TAdmReason}
	else{TAdmReason=""}
	
	//SelRowObj=document.getElementById('TDivFlagz'+selectrow);
	if (SelRowObj){TDivFlag=rowData.TDivFlag}
	else{TDivFlag=""}
}
function DivideStrike_onclick(){
	 var insutype="";
     insutype=getValueById("InsuDllType");
	 if(""==insutype){DHCWeb_HISUIalert("��ѡ��ҽ������");return;}
	 TAdmReason=tkMakeServerCall("web.INSUDicDataCom","GetDicBybillAndInd","AdmReasonDrToDLLType",insutype,3,HospDr);
	//DHCWeb_HISUIalert(TAdmReason)
	if (TDivDr==""){
		DHCWeb_HISUIalert("δѡ���κμ�¼")
		return		
	}

	if (TDHCJFFlag=="N"||TDHCJFFlag=="P"){
		DHCWeb_HISUIalert("�˼�¼��His�����������㣬����His�˷����˷�")
		return	
	}
	if("����"!=TDivFlag){DHCWeb_HISUIalert("�˼�¼����������״̬");return;}
	var ExpStr="";
    var obj=document.getElementById("ExpStr") //��չ��
    if(obj){ExpStr=obj.value;}
	//Port
	if (THisType=="סԺ"){
		if (TBillNO==""){
			DHCWeb_HISUIalert("��סԺ�����¼��δ��¼�ʵ���,�޷��˷�")
			return 
		}
		var Flag=InsuIPDivideCancle("0",session['LOGON.USERID'],TBillNO,"",TAdmReason,ExpStr)
		if (Flag!=0){
			DHCWeb_HISUIalert("ҽ���˷�ʧ��")}
		else{DHCWeb_HISUIalert("ҽ���˷ѳɹ�")}
	}
	else{
		//DHCWeb_HISUIalert(ExpStr)			//Handle,UserId,DivRowid,AdmSource,AdmReasonId,ExpString,CPPFlag
		var Flag=InsuOPDivideStrike("0",session['LOGON.USERID'],TDivDr,"",TAdmReason,ExpStr,"")	//�������б仯����
		if (Flag!=0){
			DHCWeb_HISUIalert("ҽ���˷�ʧ��")}
		else{DHCWeb_HISUIalert("ҽ���˷ѳɹ�")}
	}
}
function RegCancel_click(){
	var obj=getValueById("AdmInfo") //document.getElementById("AdmInfo")
	if(obj==""){
		DHCWeb_HISUIalert("��ѡ��Ǽ���Ϣ��");
		return;
	}
	var AdmInfoDr=obj.split("^")[0]
	var AdmReasonId=obj.split("^")[1]
	if(AdmInfoDr.indexOf("owid")>0){DHCWeb_HISUIalert("��ѡ��Ǽ���Ϣ��");return;}
	var Flag=InsuOPRegStrike("0",session['LOGON.USERID'],AdmInfoDr,"",AdmReasonId,"")	
	if(Flag==-1){DHCWeb_HISUIalert("ҽ���˺�ʧ��");return}
	DHCWeb_HISUIalert("ҽ���˺ųɹ�")
	
	}

//ֻ����ҽ������ DingSH 2015-12-17

function DiviStrikeForInsu_onclick(){
    var djlsh0="",ExpStr="";
	if (TDHCJFFlag=="N"||TDHCJFFlag=="P"){
		DHCWeb_HISUIalert("�˼�¼��His�����������㣬����His�˷����˷�")
		return	
	}
	var obj=document.getElementById("TradeNO")
    if(obj.value==""){DHCWeb_HISUIalert("��¼�������ˮ��");return} else{djlsh0=obj.value;}
    var insutype="";
    insutype=getValueById("InsuDllType"); //document.getElementById("InsuDllType").value;
    //ע�� ÿ����Ŀȡ��ʱ��θ���ͬ������ExpStr����ƴ��
    var obj=document.getElementById("ExpStr") //��չ��
    if(obj){ExpStr=obj.value;}
    if(""==insutype){DHCWeb_HISUIalert("��ѡ��ҽ������");return;}
   TAdmReason=tkMakeServerCall("web.INSUDicDataCom","GetDicBybillAndInd","AdmReasonDrToDLLType",insutype,3,HospDr);
   var CPPFlag=""
   var Flag=InsuOPDivideCancleForInsu("0",session['LOGON.USERID'],djlsh0,"",TAdmReason,ExpStr,CPPFlag) //-�������޴κ�����DHCINSUPort.js
	if (Flag!=0){
			    DHCWeb_HISUIalert("ҽ�������˷�ʧ��")}
		else{DHCWeb_HISUIalert("ҽ�������˷ѳɹ�")}
   
	
}

//ֻ����HIS���� DingSH 2015-12-17
function DiviStrikeForHis_onclick(){
	
	 var insutype="";
     insutype=getValueById("InsuDllType");
	 if(""==insutype){DHCWeb_HISUIalert("��ѡ��ҽ������");return;}
	 TAdmReason=tkMakeServerCall("web.INSUDicDataCom","GetDicBybillAndInd","AdmReasonDrToDLLType",insutype,3,HospDr);
	 
	if (TDivDr==""){
		DHCWeb_HISUIalert("δѡ���κμ�¼")
		return		
	}

   var InvNo ="" ;
	if (TDHCJFFlag=="N"||TDHCJFFlag=="P"){
		DHCWeb_HISUIalert("�˼�¼��His�����������㣬����His�˷����˷�")
		return	
	}
	
	//var obj=document.getElementById("PrtInv")
	//if(obj.value==""){DHCWeb_HISUIalert("��¼�뷢Ʊ��Inv");return} else{InvNo=obj.value;}
	
    //ע�� ÿ����Ŀȡ��ʱ��θ���ͬ������ExpStr����ƴ��

    var obj=document.getElementById("ExpStr") //��չ��
    if(obj){ExpStr=obj.value;}
   var CPPFlag=""
   var Flag=InsuOPDivideCancleForHis("0",session['LOGON.USERID'],TDivDr,"",TAdmReason,ExpStr,CPPFlag) //-�������޴κ�����DHCINSUPort.js
	if (Flag!=0){
			    DHCWeb_HISUIalert("ҽ�������˷�ʧ��")}
		else{DHCWeb_HISUIalert("ҽ�������˷ѳɹ�")}
   

}
function init_Layout(){
	$('.datagrid-sort-icon').text('');
	$('td.i-tableborder>table').css("border-spacing","0px 8px");
	setValueById('StartDate',getDefStDate(0));
	setValueById('EndDate',getDefStDate(0));
}
function init_INSUType(){
		$HUI.combobox("#InsuDllType", {
			valueField:'id',
			textField:'text',
			editable:false,
			onLoadSuccess:function(data){
				if(data.length > 0){
					$("#InsuDllType").combobox('select',data[0].id);	
				}
			}
		})
		
		var GetStr;
		var QueStr=tkMakeServerCall("web.INSUDicDataCom","QueryDicData","DLLType","",HospDr);
		if(QueStr.split("^")[0]==0){
			DHCWeb_HISUIalert("ҽ���ֵ�DLLType�ӿ�����δά��");
			return;
		}
		for(var i=0;i<QueStr.split("^")[0];i++){
			GetStr=tkMakeServerCall("web.INSUDicDataCom","GetDicData",QueStr.split("^")[1],i+1)
			DHCWeb_AddToCombobox('InsuDllType',GetStr.split("^")[3],GetStr.split("^")[2])
			//obj.options[i]=new Option(GetStr.split("^")[3],GetStr.split("^")[2]);	
			
		}
		var n=$("#InsuDllType").combobox('getData').length;
		for (var i =0;i<n;i++){
			var Typeobj=document.getElementById("InsuDllTypeSave");
			var comboboxVal=$("#InsuDllType").combobox('getData')[i];
			if(comboboxVal.id==Typeobj.value){
			$("#InsuDllType").combobox('select',comboboxVal.id);
			}
		}
		$HUI.datagrid("#tInsuOPDivideQuery",{
			onLoadSuccess:function(data){
				if(data.rows.length>0){
					repidsub=DHCWeb_GetDatagridInfo('#tInsuOPDivideQuery',1,'snodeind') // tangzf 2019-5-19 ȡ��ǰ���̺�
					GetAdmInfoNew();
				}
				}
			})
}
function init_AdmInfo(){

	$HUI.combobox("#AdmInfo", {
			valueField:'id',
			textField:'text',
		})
}
document.body.onload = BodyLoadHandler;