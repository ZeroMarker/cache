/**
 * ҽ��סԺ�Ǽ�JS
 * FileName:insuipreg.hui.js
 * DingSH 2019-04-22
 * �汾��V1.0
 * hisui�汾:0.1.0
 */
 var AdmReasonDr="",AdmReasonNationalCode=""
 var HospDr=session['LOGON.HOSPID'];
 var GUser=session['LOGON.USERID'];
 var InsuType=""
 var AdmDr="" 
 $(function()
 {
	$(document).keydown(function (e) {
	             banBackSpace(e);
	         }); 	 
	//#1 ��ʼ��ҽ������	
	InitInsuTypeCmb();
	
	//#2 ��ʼ��ҽ�����
	InitYLLBCmb();
	
	//#3 ��ʼ��ҽ�����
	InitInsuDiagCmbGd();
	 //InitInsuDiag();

    //#4 ��ʼ�������¼
    InitAdmLst();
    
    //#5 ��ʼ��������ϼ�¼
	InitDiagLst();
	
	//#6 ��ʼ��Btn�¼�
	InitBtnClick(); 
	
	//#7 ��ʼ��ҽ�������¼
	 InitInAdmDg();
	
	//#8 ����Ԫ��
	$('#InAdmDlg').hide();
	 
	//#9 סԺ�Ǽǽ����ת�����洦��
    RegLinkIni();
});

//��ʼ��ҽ������
function InitInsuTypeCmb()
{
    var options = {
		   hospDr:HospDr,
		   defaultFlag:"N"
		}
	INSULoadDicData("InsuType","DLLType",options); // dhcinsu/common/dhcinsu.common.js
	$HUI.combobox("#InsuType",{
	    	onSelect:function(rec)
	    	{
		    	InsuType=rec.cCode;
		    	InitYLLBCmb();         //ҽ�����
		    	InitInsuDiagCmbGd(); //���
		    	//QryInsuDiag();         //���
		    	InitBCFSCmb();       //���Ʒ�ʽ
		    	InitZLFSCmb();       //������ʽ
		    }
		});
}

//��ʼ��Ԫ���¼�
function InitBtnClick(){
	//�ǼǺŻس��¼�
	$("#PapmiNo").keydown(function(e) 
	  { 
	     PapmiNo_onkeydown(e);
	   });  
	//סԺ�Żس��¼�
	$("#MedicareNo").keydown(function(e) 
	  { 
	     MedicareNo_onkeydown(e);
	   });  
	 $("#CardNo").change(function(){ 
         var CardNo=getValueById('CardNo');
	     setValueById('NewCardNo',CardNo)
     });
	
    $("#CardNo").bind('click onmouseenter',
      function(e){
	     var CardNo=getValueById('CardNo');
	     setValueById('OldCardNo',CardNo)
	    }); 
	}	
	
	
//�ǼǺŻس�����	
function PapmiNo_onkeydown(e){	
	if (e.keyCode==13)
	{
		AdmDr=""
		AdmReasonDr=""
		AdmReasonNationalCode=""
		Clear(0);
		GetPatInfo(); 
    }		
}

//סԺ�Żس�����	
function MedicareNo_onkeydown(e){	
	if (e.keyCode==13)
	{
		
		 var PatNo=""
         PatNo=tkMakeServerCall("web.DHCINSUIPReg","GetPatNoByMrNo",getValueById('MedicareNo'),"I",HospDr);
	     if (PatNo!="") {
		         AdmDr=""
		         AdmReasonDr=""
		         AdmReasonNationalCode=""
		         Clear(0);
		         setValueById('PapmiNo',PatNo)
		         GetPatInfo(); 
		      
		   }
		
     }		
}


//ҽ���ǼǺ���		        
function InsuIPReg_onclick(){	
	var TempString="",InsuAdmType="",CardInfo="",InsuNo=""
	var StDate="",EndDate=""
	var obj=$('#btnReg').linkbutton("options")
	if (obj.disabled==true){return ;}
	
	//ҽ������
	var InsuType=$('#InsuType').combobox('getValue');
    if (InsuType==""){
	    $.messager.alert("��ʾ","��ѡ��ҽ������!", 'info');
		return ;
    }
    
    //ҽ�����
    InsuAdmType=$('#InsuAdmType').combobox('getValue');
    if (InsuAdmType==""){
	    $.messager.alert("��ʾ","��ѡ��ҽ�����!", 'info');
		return ;
    }
    
    //ҽ����/ҽ��֤��
	InsuNo=getValueById('InsuNo');
	
	//ҽ����Ժ��ϱ���
    var InsuInDiagCode=getValueById('InsuInDiagCode');  
                
	//ҽ����Ժ�������
    var InsuInDiagDesc=$('#InsuInDiagDesc').combogrid('getValue') 
    
	//��������
	var AdmDate=getValueById('AdmDate'); 
	
	 //����ʱ��
	var AdmTime=getValueById('AdmTime');
	
	//���Ʒ�ʽ
	var ZLFSStr=$('#ZLFS').combobox('getValue');	
	
	//������ʽ
	var BCFSStr=$('#BCFS').combobox('getValue')	

	TempString=InsuAdmType+"^"+InsuInDiagCode+"^"+InsuInDiagDesc+"^"+InsuNo+"^"+AdmDate+"^"+AdmTime+"^"+ZLFSStr+"^"+BCFSStr+"^"+InsuType
	
	//ҽ���Ǽ�
	var flag=InsuIPReg(0,GUser,AdmDr,AdmReasonNationalCode, AdmReasonDr,TempString)//DHCInsuPort.js
	if (flag!="0") 
	 {
		$.messager.alert("��ʾ","ҽ���Ǽ�ʧ��!rtn="+flag, 'error');
		return ;
	}
	$.messager.alert("��ʾ","ҽ���Ǽǳɹ�!", 'info');
	UpdatePatAdmReason(AdmDr,"",GUser)
    GetPatInfo();
	
}

//ȡ��ҽ���Ǽ�
function InsuIPRegCancel_onclick(){

    var obj=$('#btnRegCancle').linkbutton("options")
	if (obj.disabled==true){return ;}
	if(""==AdmDr)
	{	
	 $.messager.alert("��ʾ","��ѡ���˼�������Ϣ!", 'info');
	 return;
	}
	//�Ǽ�ȡ��
	var ExpStr="^^^"
	var flag=InsuIPRegStrike(0,GUser,AdmDr, AdmReasonNationalCode, AdmReasonDr,ExpStr) //DHCInsuPort.js
	if (+flag<0) {
		 $.messager.alert("��ʾ","ȡ���Ǽ�ʧ��!"+flag, 'error');
		 return;
		}
	 $.messager.alert("��ʾ","ȡ���Ǽǳɹ�!", 'info');
	 //InitAdmCmbGd();
	 GetPatInfo();
}

//ҽ���ǼǺ���
function InsuReadCard_onclick() {
	
	//ҽ������
	var InsuType=$('#InsuType').combobox('getValue');
    if (InsuType==""){
	    $.messager.alert("��ʾ","��ѡ��ҽ������!", 'info');
		return ;
    }
	//ҽ����/ҽ��֤��
	InsuNo=getValueById('InsuNo');
	//ҽ��������
	var CardType="" ;
	//��չ��
	var ExpString=InsuType+"^^^"
	var flag=InsuReadCard(0,GUser,InsuNo,CardType,ExpString);//DHCInsuPort.js
	var NewCardNo="",CardNo="";
	if (eval(flag.split("|")[0])==0)
	{
		$.messager.alert("��ʾ","��ҽ�����ɹ�!", 'info');
		//ҽ�������ز�����ʽ���ο�ҽ���������ع̶������б�V2.0.xls
		 var InsuCardStr=flag.split("|")[1];
		 NewCardNo=InsuCardStr.split("^")[1];
		 setValueById('NewCardNo',NewCardNo);
	}
	CardNo=getValueById('CardNo');
	setValueById('OldCardNo',CardNo);
	if ((NewCardNo!="")&&(CardNo!="")&&(CardNo!=NewCardNo))
	{
	$.messager.confirm('ȷ��',"��ҽ�����Ŀ��ţ�"+NewCardNo+",�͵Ǽ�ʱҽ�����ţ�"+CardNo+"��һ�£��Ƿ�����޸ģ�",function(r){    
    if (r){    
       UpdINSUCardNo_onclick();   
    }    
    });  
   }
	
	
}
	
	
 //����ҽ��������
 function UpdINSUCardNo_onclick(){

	var NewCardNo=getValueById('NewCardNo');
 	if ((NewCardNo=="")||((NewCardNo==" "))){		   
  	  	$.messager.alert("��ʾ","�޸ĵ�ҽ������Ϊ�գ�����д!", 'info');
   	 	return;   
	 }
	 var OldCardNo=getValueById('OldCardNo');
	 if (NewCardNo==OldCardNo){		   
  	  	$.messager.alert("��ʾ","�޸ĵ�ҽ������û�仯����������д!", 'info');
   	 	return;   
	 }
  
	var flag=tkMakeServerCall("web.INSUAdmInfoCtlCom","UpdateINSUCardNo",AdmDr,OldCardNo+"_"+NewCardNo);
	if(flag=="0")
	{
	  setValueById('CardNo',NewCardNo);
	  setValueById('OldCardNo',OldCardNo);
	  OldCardNo=NewCardNo; //���³ɹ����µĿ��ű�ɾͿ�����
	  $.messager.alert("��ʾ","����ҽ��������Ϣ�ɹ�!", 'info');
	}
	else
	{
		
	  $.messager.alert("��ʾ","����ҽ��������Ϣʧ��!", 'error');
		
	}
	 
	}	
	
	
///��ȡ���˻�����Ϣ����
function GetPatInfo(){	
    var tmpPapmiNo=$('#PapmiNo').val()
	if (tmpPapmiNo=="")
		{
		$.messager.alert("��ʾ","�ǼǺŲ���Ϊ��!", 'info');
		return ;
		}
	 var PapmiNoLength=10-tmpPapmiNo.length;     //�ǼǺŲ���   	

		for (var i=0;i<PapmiNoLength;i++){
			tmpPapmiNo="0"+tmpPapmiNo;			
		}
	
   PapmiNo=tmpPapmiNo;	
   setValueById('PapmiNo',PapmiNo)              //�ǼǺŲ�ȫ���д
   var rtn=""
    rtn=tkMakeServerCall("web.DHCINSUIPReg","GetPatInfoByPatNo","","",PapmiNo,HospDr);
    if (typeof rtn != "string")
    {
	    return ;
	}
   if (rtn.split("!")[0]!="1") {
	 	 $.messager.alert('��ʾ','ȡ������Ϣʧ��,��������ȷ�ĵǼǺ�!','error' ,function(){
		 	  return ;
		 	 });
 	}else
 	{
	 	aData=rtn.split("^");
	 	setValueById('Name',aData[2]);             //����
	 	setValueById('Sex',aData[4]);              //�Ա�
	 	setValueById('Age',aData[3]);              //����
	 	setValueById('PatID',aData[8]);            //���֤��
	 	setValueById('CTProvinceName',aData[16]);  //ʡ
	 	setValueById('CTCityName',aData[18]);      //��
	 	setValueById('CTAreaName',aData[20]);      //��
	 	setValueById('BDDT',aData[9]);             //��������
	 	setValueById('MedicareNo',aData[14]);       //סԺ��
	    //CTProvinceCode=aData[15];
        //CTCityCode=aData[17];
        //CTAreaCode=aData[19];
         //InitAdmCmbGd();
         //InitAdmDiagCmbGd();
         QryAdmLst();
         QryDiagLst();
	 	return ;
	 }
	return ;
}	

//��ʼ�������¼����
function InitAdmLst()
{
	$('#AdmLst').combogrid({    
	    panelWidth:780, 
	    method:'GET',
	    idField:'AdmDr',  
	    textField:'AdmNo' ,  
	    columns:[[    
	        {field:'AdmDr',title:'AdmDr',width:60},    
	        {field:'AdmNo',title:'�����',width:120}, 
	        {field:'DepDesc',title:'�������',width:160},   
	        {field:'AdmDate',title:'��������',width:100},   
	        {field:'AdmTime',title:'����ʱ��',width:100},   
	        {field:'VisitStatus',title:'����״̬',width:120},  
	        //{field:'AdmReasonDr',title:'����ѱ�',width:120},      
	        {field:'AdmReasonDesc',title:'����ѱ�',width:120},      
	    ]] ,
		onClickRow:function(rowIndex, rowData)
		{
			  var AdmLstVal=rowData.AdmNo+"-"+rowData.DepDesc+"-"+rowData.AdmDate+" "+rowData.AdmTime+"-"+rowData.VisitStatus+"-"+rowData.AdmReasonDesc
		      $('#AdmLst').combogrid("setValue",AdmLstVal)
			  setValueById('DepDesc',rowData.DepDesc)
			  setValueById('AdmDate',rowData.AdmDate)
			  setValueById('AdmTime',rowData.AdmTime)
			  setValueById('InDiagCode',rowData.InDiagCode)
			  setValueById('InDiagDesc',rowData.InDiagDesc)
			  setValueById('AdmReasonDesc',rowData.AdmReasonDesc)
			  AdmDr=rowData.AdmDr
			  AdmReasonDr=rowData.AdmReasonDr
			  AdmReasonNationalCode=rowData.ReaNationalCode
			  //InitAdmDiagCmbGd()
			  QryDiagLst();
			  GetInsuAdmInfo()
			  QryInAdmInfo()
		},
		
		onLoadSuccess:function(data)
		{
	
			if (data.total==0)
			{
				$.messager.alert("��ʾ", "û�в�ѯ�����˾����¼,����ȷ�ϻ����Ƿ�ʿ�ִ�!", 'info');
				return ;
				
			}
			var indexed=-1
			var Flag=0
			for(var i in data.rows)
			{
				if(data.rows[i].VisitStatus=="��Ժ")
				{
					indexed=i;
					Flag=1
				}
				if (Flag==0)
				{
					indexed=i;
					
				}
				if(AdmDr==data.rows[i].AdmDr)
				{
					indexed=i;
				}
		    }
		    
		    if (indexed>=0)
		    {
			    var rowData=data.rows[indexed]
					$('#AdmLst').combogrid("setValue",rowData.AdmNo+"-"+rowData.DepDesc+"-"+rowData.AdmDate+" "+rowData.AdmTime+"-"+rowData.VisitStatus+"-"+rowData.AdmReasonDesc)
				    setValueById('DepDesc',rowData.DepDesc)
			        setValueById('AdmDate',rowData.AdmDate)
			        setValueById('AdmTime',rowData.AdmTime)
			        setValueById('InDiagCode',rowData.InDiagCode)
			        setValueById('InDiagDesc',rowData.InDiagDesc)
			        setValueById('AdmReasonDesc',rowData.AdmReasonDesc)
				    AdmDr=rowData.AdmDr
				    AdmReasonDr=rowData.AdmReasonDr
			        AdmReasonNationalCode=rowData.ReaNationalCode
			        //InitAdmDiagCmbGd();
			        QryDiagLst();
			        GetInsuAdmInfo();
			        QryInAdmInfo()
			}
		    
		    
		    
		}
       
});  
	
}

//��ѯ�����¼����
function QryAdmLst()
{
	var tURL=$URL+"?ClassName="+'web.DHCINSUIPReg'+"&MethodName="+"GetPaAdmListByPatNoIPReg"+"&PapmiNo="+getValueById('PapmiNo')+"&itmjs="+"HUIToJson"+"&itmjsex="+""+"&HospDr="+HospDr
    $('#AdmLst').combogrid({url:tURL});
}


///��ʼ��������ϼ�¼����
function InitDiagLst()
{
	
	$('#DiagLst').combogrid({    
	    panelWidth:780, 
	    method:'GET',
	    idField:'DiagnosICDCode',  
	    textField:'DiagnosDesc' ,  
	    columns:[[    
	        {field:'DiagnosICDCode',title:'��ϱ���',width:100},    
	        {field:'DiagnosDesc',title:'�������',width:160}, 
	        {field:'DiagnosMRDesc',title:'���ע��',width:80},   
	        {field:'DiagnosType',title:'�������',width:80},   
	        {field:'DiagStat',title:'���״̬',width:80},   
	        {field:'InsuDiagCode',title:'ҽ����ϱ���',width:110},  
	        {field:'InsuDiagDesc',title:'ҽ���������',width:150}      
	    ]] ,
		onClickRow:function(rowIndex, rowData)
		{
			  var DiagLstVal=rowData.DiagnosICDCode+"-"+rowData.DiagnosDesc+"-"+rowData.DiagnosMRDesc+"-"+rowData.DiagStat+"-"+rowData.InsuDiagCode+"-"+rowData.InsuDiagDesc
		      $('#DiagLst').combogrid("setValue",DiagLstVal)
			  setValueById('InDiagCode',rowData.DiagnosICDCode)
			  setValueById('InDiagDesc',rowData.DiagnosDesc)
		},
       
  });  

}
///��ѯ������ϼ�¼����
function QryDiagLst()
{
	var tURL=$URL+"?ClassName="+'web.DHCINSUPortUse'+"&MethodName="+"GetPatAllDiagsByADM"+"&PAADM="+AdmDr+"&DiagType="+""+"&ExpStr="+("^"+InsuType+"^HUIToJson")
    $('#DiagLst').combogrid({url:tURL});
   
}


//��ȡҽ��������Ϣ����
function GetInsuAdmInfo()
{

	$.m({
		ClassName: "web.DHCINSUIPReg",
		MethodName: "GetInfoByAdm",
		type: "GET",
		itmjs: "",
		itmjsex: "",
		Paadm: AdmDr
	}, function (rtn) {
          if (typeof rtn != "string")
         {
	       return ;
	     }
		if (rtn.split("!")[0] != "1") {
			enableById("btnReg");
			enableById("btnRegCancle");
		} else {
			var myAry = rtn.split("!")[1].split("^");
			var actDesc = "";
			if (myAry[11] == "A") {
				actDesc = "��Ժ";
			   disableById("btnReg");
				enableById("btnRegCancle");
			}
			if (myAry[11] == "O") {
				actDesc = "��Ժ";
				disableById("btnReg");
				disableById("btnRegCancle");
			}
			if (myAry[11] == "S") {
				actDesc = "ȡ���Ǽ�";
				enableById("btnReg");
				disableById("btnRegCancle");
			}
			setValueById("InsuActiveFlag", actDesc);           //ҽ���Ǽ�״̬
			setValueById("InsuNo", myAry[2]);               //ҽ����
			setValueById("CardNo", myAry[3]);               //ҽ������
			setValueById("NewCardNo", myAry[3]);            //��ҽ������
			setValueById("OldCardNo", myAry[39]);           //��ҽ������
			InsuType=myAry[18];			
			setValueById("InsuType",myAry[18])
			InitYLLBCmb(myAry[14]);                          //ҽ�����
		    InitBCFSCmb();                                  //���Ʒ�ʽ
		    InitZLFSCmb();                                   //������ʽ
			setValueById("InsuPatType", myAry[4]);          //��Ա���
			$("#InsuInDiagDesc").combogrid("grid").datagrid("loadData", {
				total: 1,
				rows: [{"Code": myAry[26], "Desc": myAry[27]}]
			});
			$("#InsuInDiagDesc").combogrid("setValue", myAry[26]);   //ҽ�����
			
			setValueById("insuTreatType", myAry[36]);        //�������
			setValueById("insuAdmSeriNo", myAry[10]);        //ҽ�������
			setValueById("xzlx",myAry[37])                   //��������
	        setValueById("dylb",myAry[36])                   //�������
	        setValueById("AdmDate",myAry[12])                //��Ժ����
	        setValueById("AdmTime",myAry[13])                //��Ժʱ��
            setValueById("InsuAdmSeriNo",myAry[10])          //ҽ�������
            setValueById("InsuCenter",myAry[8])              //ҽ��ͳ����
			//setValueById("ZLFS", myAry[38]);               //���Ʒ�ʽ
			//setValueById("BCFS", myAry[39]);               //������ʽ
		}
	});
	
}

//��ѯҽ��������Ϣ
function QryInAdmInfo()
{
 $('#inadmdg').datagrid('options').url = $URL	
 $('#inadmdg').datagrid('reload',{
	ClassName:'web.DHCINSUIPReg',
	QueryName:'GetInsuAdmInfo',
	AdmDr:AdmDr
	});
}

//����ҽ�����(֧�ּ���)
function InitInsuDiagCmbGd(){
$("#InsuInDiagDesc").combogrid({
		panelWidth: 420,
		validType: ['checkInsuInfo'],
		delay: 300,
		mode: 'remote',
		method: 'GET',
		fitColumns: true,
		pagination: true,
		idField: 'Code',
		textField: 'Desc',
		data: [],
		columns: [
			[{field: 'Rowid', title: 'Rowid', hidden: true},
			 {field: 'Code', title: 'ҽ����ϱ���', width: 120},
			 {field: 'Desc', title: 'ҽ���������', width: 230}]
		],
		onBeforeLoad: function(param) {
			if (typeof param.q == "undefined"){
				return ;
				}
			if (getValueById("InsuType") && ($.trim(param.q).length > 1)) {
				$("#InsuInDiagDesc").combogrid("grid").datagrid("options").url = $URL;
				param.ClassName = "web.DHCINSUIPReg";
				param.QueryName = "GetInsuDiagnosis";
				param.InsuInDiagDesc = param.q;
				param.InsuType = getValueById("InsuType");
				param.HospDr=HospDr;
			}
		},
		onSelect: function(rowIndex, rowData) {
			setValueById("InsuInDiagCode", rowData.Code);
		},
		onChange: function(newValue, oldValue) {
			if (!newValue) {
				setValueById("InsuInDiagCode", "");
			}
		}
	});
}

//����ҽ�����(֧�ּ���)
function InitInsuDiag(){
$("#InsuInDiagDesc").combogrid({
		panelWidth: 420,
		validType: ['checkInsuInfo'],
		delay: 300,
		mode: 'remote',
		method: 'GET',
		fitColumns: true,
		pagination: true,
		idField: 'Code',
		textField: 'Desc',
		data: [],
		columns: [
			[{field: 'Rowid', title: 'Rowid', hidden: true},
			 {field: 'Code', title: 'ҽ����ϱ���', width: 120},
			 {field: 'Desc', title: 'ҽ���������', width: 230}]
		],
		onBeforeLoad: function(param) {
			if (typeof param.q == "undefined"){
				return ;
				}
			if (getValueById("InsuType") && ($.trim(param.q).length > 1)) {
				$("#InsuInDiagDesc").combogrid("grid").datagrid("options").url = $URL;
				param.ClassName = "web.DHCINSUIPReg";
				param.QueryName = "GetInsuDiagnosis";
				param.InsuInDiagDesc = param.q;
				param.InsuType = getValueById("InsuType");
				param.HospDr=HospDr;
			}
		},
		onSelect: function(rowIndex, rowData) {
			setValueById("InsuInDiagCode", rowData.Code);
		},
		onChange: function(newValue, oldValue) {
			if (!newValue) {
				setValueById("InsuInDiagCode", "");
			}
		}
	});

}
function  QryInsuDiag()
{
	$('#InsuInDiagDesc').combogrid('clear');
	var tURL=$URL+"?ClassName="+'web.DHCINSUIPReg'+"&QueryName="+"GetInsuDiagnosis"+"&InsuInDiagDesc="+getValueById("InsuInDiagDesc")+"&InsuType="+ getValueById("InsuType")+"&HospDr="+HospDr
    $('#InsuInDiagDesc').combogrid({url:tURL});
}




//���������������
function  InAdmFrmClick(rowIndex){
	    
	initInAdmDlFrm(rowIndex);
	
}
	
	
//ҽ��������Ϣ����
function initInAdmDlFrm(rowIndex){
	
	var rowData=$('#inadmdg').datagrid("getRows")[rowIndex];    

	 $('#InAdmDlg').show(); 
	 ClearInAdmDl();
	 FillInAdmDl(rowData);
	 $HUI.dialog("#InAdmDlg",{
			title:"ҽ��������Ϣ",
			height:560,
			width:985,
		    iconCls:'icon-w-paper',
			modal:true
			
		})
	
		
	}
	
	
//��ֵҽ�����ﵯ��Ԫ��		
function FillInAdmDl(Data)
{
	
	setValueById('FXString6',Data.TXString6);     //����
	setValueById('FXString5',Data.TXString5);     //���֤��
	setValueById('FXString7',Data.TXString7);     //�Ա�
	setValueById('FInsuId',Data.TInsuId);       //ҽ�����˱��
	setValueById('FCardNo',Data.TCardNo);       //ҽ������
	setValueById('FCardStatus',Data.TCardStatus);   //ҽ����״̬
	setValueById('FAdmType',Data.TAdmType);      //��������
	setValueById('FPatType',Data.TPatType);      //��Ա����
	setValueById('FAdmSeriNo',Data.TAdmSeriNo);    //ҽ�������
	setValueById('FActiveFlag',Data.TActiveFlag);    //�Ǽ�״̬
	setValueById('AdmDate',Data.TAdmDate);      //��Ժ����
	setValueById('FAdmTime',Data.TAdmTime);      //��Ժʱ��
	setValueById('FInsuUser',Data.TInsuUser);     //��Ժ����Ա
	setValueById('FFunDate',Data.TFunDate);      //�ǼǷ�������
	setValueById('FFunTime',Data.TFunTime);      //�ǼǷ���ʱ��
	setValueById('FXString7',Data.TXString7);     //��������
	setValueById('FOutUser',Data.TOutUser);      //��Ժ����Ա
	setValueById('FOutDate',Data.TOutDate);      //��Ժ����
	setValueById('FOutTime',Data.TOutTime);      //��Ժʱ��
	setValueById('FDeptDesc',Data.TDeptDesc);     //�������
	setValueById('FCompany',Data.TCompany);      //��λ����
	setValueById('FStates',Data.TStates);       //����
	setValueById('FCenter',Data.TCenter);       //ͳ����
	setValueById('FXString1',Data.TXString1);     //ҽ����Ժ��ϱ���
	setValueById('FXString2',Data.TXString2);     //ҽ����Ժ�������
	setValueById('FIpTimes',Data.TIpTimes);      //סԺ����
	setValueById('FAdmCancelNo',Data.TAdmCancelNo);  //������ˮ��
	setValueById('FXString3',Data.TXString3);     //ҽ����Ժ��ϱ���
	setValueById('FXString4',Data.TXString4);     //ҽ����Ժ�������
	setValueById('FXString9',Data.TXString9);     //Ԥ��9
	setValueById('FXString10',Data.TXString10);    //Ԥ��10
	setValueById('FXFloat1',Data.TXFloat1);      //Ԥ��1
	setValueById('FXFloat2',Data.TXFloat2);      //Ԥ��2
	setValueById('FXFloat3',Data.TXFloat3);      //Ԥ��3
	setValueById('XFloat4',Data.TXFloat4);       //Ԥ��4
	setValueById('FXString11',Data.TXString11);    //Ԥ��11
	setValueById('FXString12',Data.TXString12);    //Ԥ��12
	setValueById('FXString13',Data.TXString13);    //Ԥ��13
	setValueById('FXString14',Data.TXString14);    //Ԥ��14
	setValueById('FXString15',Data.TXString15);    //Ԥ��15
	setValueById('FXString16',Data.TXString16);    //Ԥ��16
	setValueById('FXString17',Data.TXString17);    //Ԥ��17
	setValueById('FXString18',Data.TXString18);    //Ԥ��18
	setValueById('FXString19',Data.TXString19);    //Ԥ��19
	setValueById('FXString20',Data.TXString20);    //Ԥ��20

	
}		
	
//���ҽ�����ﵯ��Ԫ��	
function ClearInAdmDl()
{
	
	getValueById('FXString7',"");     //����
	getValueById('FXString5',"");     //���֤��
	getValueById('FXString6',"");     //�Ա�
	getValueById('FInsuId',"");       //ҽ�����˱��
	getValueById('FCardNo',"");       //ҽ������
	getValueById('FCardStatus',"");   //ҽ����״̬
	getValueById('FAdmType',"");      //��������
	getValueById('FPatType',"");      //��Ա����
	getValueById('FAdmSeriNo',"");    //ҽ�������
	getValueById('FActiveFlag',"");    //�Ǽ�״̬
	getValueById('FAdmDate',"");      //��Ժ����
	getValueById('FAdmTime',"");      //��Ժʱ��
	getValueById('FInsuUser',"");     //��Ժ����Ա
	getValueById('FFunDate',"");      //�ǼǷ�������
	getValueById('FFunTime',"");      //�ǼǷ���ʱ��
	getValueById('FXString7',"");     //��������
	getValueById('FOutUser',"");      //��Ժ����Ա
	getValueById('FOutDate',"");      //��Ժ����
	getValueById('FOutTime',"");      //��Ժʱ��
	getValueById('FDeptDesc',"");     //�������
	getValueById('FCompany',"");      //��λ����
	getValueById('FStates',"");       //����
	getValueById('FCenter',"");       //ͳ����
	getValueById('FXString1',"");     //ҽ����Ժ��ϱ���
	getValueById('FXString2',"");     //ҽ����Ժ�������
	getValueById('FIpTimes',"");      //סԺ����
	getValueById('FAdmCancelNo',"");  //������ˮ��
	getValueById('FXString3',"");     //ҽ����Ժ��ϱ���
	getValueById('FXString4',"");     //ҽ����Ժ�������
	getValueById('FXString9',"");     //Ԥ��9
	getValueById('FXString10',"");    //Ԥ��10
	getValueById('FXFloat1',"");      //Ԥ��1
	getValueById('FXFloat2',"");      //Ԥ��2
	getValueById('FXFloat3',"");      //Ԥ��3
	getValueById('XFloat4',"");       //Ԥ��4
	getValueById('FXString11',"");    //Ԥ��11
	getValueById('FXString12',"");    //Ԥ��12
	getValueById('FXString13',"");    //Ԥ��13
	getValueById('FXString14',"");    //Ԥ��14
	getValueById('FXString15',"");    //Ԥ��15
	getValueById('FXString16',"");    //Ԥ��16
	getValueById('FXString17',"");    //Ԥ��17
	getValueById('FXString18',"");    //Ԥ��18
	getValueById('FXString19',"");    //Ԥ��19
	getValueById('FXString20',"");    //Ԥ��20
}	

function InitDiagsQry()
{
	$("#InsuInDiagDesc").searchbox({
		prompt: '������ؼ���',
        searcher: function (value, name) {
                initDiagFrm(value);
            } 
	});
}

function InitDiagDg(KeyWords){
	
     //alert("KeyWords="+KeyWords+"InsuType="+InsuType)
	 //��ʼ��datagrid
	$HUI.datagrid("#indiagdg",{
		rownumbers:true,
	    width:445,
	    height:260,
		//striped:true,
		//fitColumns:true,
		singleSelect: true,
		//autoRowHeight:false,
		data: [],
		columns:[[
		
			{field:'Rowid',title:'Rowid',width:60},
			{field:'Code',title:'ҽ����ϱ���',width:120},
			{field:'Desc',title:'ҽ���������',width:230}
			//{field:'TStDate',title:'��Ч����',width:140},
			//{field:'TEndDate',title:'��ֹ����',width:140}	
		]],
		url:$URL+"?ClassName=web.DHCINSUIPReg&QueryName=GetInsuDiagnosis&InsuInDiagDesc="+encodeURI(KeyWords)+"&InsuType="+InsuType+"&HospDr="+HospDr,
		pageSize: 5,
		pageList:[5,10],
		pagination:true,
        onClickRow : function(rowIndex, rowData) {
	    
            
        },
        onDblClickRow:function(rowIndex, rowData){
	       
	        $('#InsuInDiagDesc').searchbox('setValue', rowData.Desc);
	        setValueById('InsuInDiagCode',rowData.Code)
	        $('#DiagDlBd').window('close');  
	        },
        onUnselect: function(rowIndex, rowData) {
        }
	});
	 
}
		
//��ʼ��ҽ�����
function InitYLLBCmb()
{
	var options = {
		   hospDr:HospDr,
		   defaultFlag:"Y",
		   DicOPIPFlag:"IP"
		}
	INSULoadDicData("InsuAdmType",("AKA130"+InsuType),options); // dhcinsu/common/dhcinsu.common.js
	if(arguments.length ==1)
	{
	var InsuAdmType=arguments[0];
	$HUI.combobox("#InsuAdmType",{
	      onLoadSuccess:function(data){
				       setValueById('InsuAdmType',InsuAdmType);
				     }
				});
	}
}



//��ʼ�����Ʒ�ʽ
function InitZLFSCmb()
{
	var options = {
		   hospDr:HospDr,
		   defaultFlag:"N",
		}
	INSULoadDicData("ZLFS",("ZLFS"+InsuType),options); // dhcinsu/common/dhcinsu.common.js
}

//��ʼ�����ŷ�ʽ
function InitBCFSCmb()
{
	var options = {
		   hospDr:HospDr,
		   defaultFlag:"N",
		}
	INSULoadDicData("BCFS",("BCFS"+InsuType),options); // dhcinsu/common/dhcinsu.common.js
}

//��ʼ������Grid
function InitInAdmDg()
{
    //��ʼ��datagrid
	$HUI.datagrid("#inadmdg",{
	    //url:$URL,
		border:false,	
		toolbar:[],
		data: [],
		rownumbers:true,
		singleSelect: true,
		frozenColumns:[[
		  { 
		    field:'TOpt',
		    width:40,
		    title:'����',
		    formatter: function (value, row, index) {
							return "<img class='myTooltip' style='width:60' title='��ϸ��Ϣ' onclick=\"InAdmFrmClick('" + index+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/pat_info.png' style='border:0px;cursor:pointer'>";
					}
		  }
		
		]],
		columns:[[
		
			{field:'TRowid',title:'TRowid',width:10,hidden:true},
			{field:'TInsuId',title:'ҽ�����˱��',width:120},
			{field:'TCardNo',title:'ҽ������',width:100},
			{field:'TPatType',title:'��Ա����',width:80},
		    {field:'TAdmType',title:'��������',width:80},
			{field:'TDeptDesc',title:'�������',width:120},
			{field:'TActiveFlag',title:'�Ǽ�״̬',width:80},
			{field:'TAdmDate',title:'��Ժ����',width:100},
			{field:'TAdmTime',title:'��Ժʱ��',width:80},
			{field:'TInsuUser',title:'��Ժ�Ǽ���',width:100},
			{field:'TFunDate',title:'��Ժ�Ǽ�����',width:120},
			{field:'TFunTime',title:'��Ժ�Ǽ�ʱ��',width:120},
			{field:'TOutUser',title:'��Ժ�Ǽ���',width:140},
			{field:'TStates',title:'�α�����',width:100},
			{field:'TCenter',title:'������',width:80},
			{field:'TAccount',title:'ҽ���˻�',width:80},
			{field:'TAdmSeriNo',title:'ҽ�������',width:100},
			{field:'TInsuType',title:'ҽ������',width:80},
			{field:'TCardStatus',title:'ҽ����״̬ ',width:100},
			{field:'TCompany',title:'��˾����',width:100},
			{field:'TAdmDr',title:'TAdmDr',width:60},
		]],
		pageSize: 10,
		pagination:true,
        onClickRow : function(rowIndex, rowData) {  
        },
        onDblClickRow:function(rowIndex, rowData){
	       
	        },
        onUnselect: function(rowIndex, rowData) {
        
        }
	});
	
}

 //����Padm.Rowid ���·ѱ�
 //ReadId Ϊ��ʱ  ���� ҽ���Ǽ���Ϣ ���� ��Ա��� ���·ѱ�
 //ReadId ��Ϊ��ʱ ���ݴ����ReadId���и��·ѱ�
//DingSH 20160713	
function UpdatePatAdmReason(AdmDr,ReadId,ExpStr)
{
	$.m
	({
		ClassName:"web.DHCINSUIPReg",
		MethodName:"UpdatePatAdmReason",
		PAADMDr:AdmDr,
		ReaId:ReadId,
		ExpStr:ExpStr
		},
	function(rtn)
	{
		if(rtn!=0){$.messager.alert("��ʾ","ҽ���Ǽǳɹ�,���Ǹ��·ѱ�ʧ��,rtn="+rtn, 'info')}
	});
	
 }	
 
 
 function Clear(AFlag){
	ClearPatInfo(AFlag);
	ClearPaadmInfo(AFlag);
	ClearInsuAdmInfo();
}


function ClearPatInfo(AFlag) {
	setValueById('Name',"");
    setValueById('Sex',"");
	setValueById('Age',"");
	setValueById('BDDT',"");
	if(AFlag){
		setValueById('PapmiNo',"");
		setValueById('MedicareNo',"");
		$(".validatebox-text").validatebox("validate");
	}
	setValueById('PatID',"");
	setValueById('CTProvinceName',"");
	setValueById('CTCityName',"");
	setValueById('CTAreaName',"");
	}
function ClearPaadmInfo(AFlag) {
	setValueById('AdmDate',"");
	setValueById('AdmTime',"");
	setValueById('DepDesc',"");
	setValueById('InDiagCode',"");
	setValueById('InDiagDesc',"");
	setValueById('AdmReasonDesc',"");
	//$('#AdmLst').combogrid('setValue',"")
	//$('#DiagLst').combogrid('setValue', "")
    $('#AdmLst').combogrid('clear');
    $('#DiagLst').combogrid('clear');
    setValueById('AdmLst','');
    setValueById('DiagLst','');
    $('#AdmLst').combogrid('grid').datagrid("loadData",{total:-1,rows:[]});
    $('#DiagLst').combogrid('grid').datagrid("loadData",{total:-1,rows:[]});
   
	}
function ClearInsuAdmInfo() {
	$('#InsuType').combobox('setValue',"");
    $('#InsuAdmType').combobox('setValue',"");
	$('#InsuInDiagDesc').combogrid('setValue',"");
	$('#InsuInDiagDesc').combogrid('grid').datagrid("loadData",{total:0,rows:[]});
	setValueById('InsuInDiagCode',"");
	setValueById('InsuPatType',"");
	setValueById('dylb',"");
	setValueById('xzlx',"");
	setValueById('InsuNo',"");
	setValueById('CardNo',"");
	setValueById('OldCardNo',"");
	setValueById('InsuCardStatus',"");
	setValueById('InsuActiveFlag',"");
	setValueById('InsuAdmSeriNo',"");
	setValueById('InsuCenter',"");
	$('#ZLFS').combobox('setValue',"");
    $('#BCFS').combobox('setValue',"");
	$("#inadmdg").datagrid("loadData",{total:0,rows:[]}); //20191028
	}
	
	
///����סԺ�Ǽǽ��浽ҽ��������ת���������	
function RegLinkIni() {
	if(ArgPapmiNo==undefined) return;
	AdmReasonDr=""
	AdmReasonNationalCode=""
	Clear(0);
	if(ArgAdmDr!=""){
		AdmDr=ArgAdmDr
	}
	if(ArgPapmiNo!=""){
		setValueById('PapmiNo',ArgPapmiNo)
		GetPatInfo(); 
	}
	
}	
	