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
 var InsuType="";
 var AdmDr="";
 var InsuCurCardNo=""; //��ǰҽ������
 var MedTypeDicRelationFlag=""; // 20220829 ҽ���������ֵ��־
 var InsuRegRepFlag="Y"; // 20230525 ҽ���ظ��ǼǱ�־
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
	 
    //#9 ҽ�����ÿ���
    InitPROConfg();
    
    //#0 סԺ�Ǽǽ����ת�����洦��
    RegLinkIni();        
	
	//st add 20220919 HanZH
	//#11 ��ʼ������
	InitDiseNameCmbGd();
	
	//#12 ��ʼ����������
	InitOprnOprtNameCmbGd();
	//ed
});


//ҽ�����ÿ���,ҽ����������������
function InitPROConfg()
{
	$.m({
		ClassName: "web.INSUDicDataCom",
		MethodName: "GetSys",
		type: "GET",
		itmjs: "",
		itmjsex: "",
		InString: "HISPROPerty"+InsuType,
		HospDr: HospDr
	}, function (rtn) {
        if (typeof rtn != "string")
         {
	       return ;
	     }
	     var DicAry = rtn.split("!")
	     for(var i =1,len=DicAry.length;i<len;i++)
	     {
		     var DataAry = DicAry[i].split("^");
		     var DicCode = DataAry[2];
		     var DicVal = DataAry[3];
		     switch (DicCode)
		     { 
		              /*ҽ����������������*/
	             case "AdmDateIsEdit" :
	                    var RdFlag='enable'
	                    //if (DicVal == 0){
	    	              // RdFlag='disable'
	                     //}
	                     //$("#AdmDate").datebox(RdFlag);
	                     //$("#AdmTime").timespinner(RdFlag);   //-ע�͵� DingSH 20220919
	                      enableById('AdmDate')  // �޸� DingSH 20220919 
	                      enableById('AdmTime')
	                      if (DicVal == 0){
	    	                disableById('AdmDate')
	                        disableById('AdmTime')
	                     }
	                    
	    	          break;
	    	     
	             default :
	    	          break;
	           }
		 }
		
	});

}
//��ʼ��ҽ������
function InitInsuTypeCmb()
{
    var options = {
		   hospDr:HospDr,
		   defaultFlag:"Y"
		}
	INSULoadDicData("InsuType","DLLType",options); // dhcinsu/common/dhcinsu.common.js
	$HUI.combobox("#InsuType",{
	    	onSelect:function(rec)
	    	{
		    	InsuType=rec.cCode;
		    	InitYLLBCmb();           //ҽ�����
		    	InitInsuDiagCmbGd();     //���
		    	//QryInsuDiag();         //���
		    	InitZLFSCmb();           //���Ʒ�ʽ
		    	InitBCFSCmb();           //������ʽ
		    	InitMdtrtCertTypeCmb();  //��ҽƾ������
		    	InitPROConfg();          //ҽ�����ÿ���
		    	//add 20220919 HanZH
				InitDiseNameCmbGd();	 //����
				InitOprnOprtNameCmbGd(); //��������
				InitadmdvsCmbGd();		 //ҽ������  +20230330 HanZH
		    }
		});
}

//��ʼ��Ԫ���¼�
function InitBtnClick(){
	//�ǼǺŻس��¼�
	$("#PapmiNo").keydown(function(e) 
	  { 
	    if (e.keyCode==13)
	    {
	      PapmiNo_onkeydown();
	    }
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
	
   /* $("#CardNo").bind('click onmouseenter',
      function(e){
	     var CardNo=getValueById('CardNo');
	     setValueById('OldCardNo',CardNo)
	    }); */
	}	
	
	
//�ǼǺŻس�����	
function PapmiNo_onkeydown(){	
	//if (e.keyCode==13)
	//{
		AdmDr=""
		AdmReasonDr=""
		AdmReasonNationalCode=""
		Clear(0);
		GetPatInfo(); 
    //}		
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

	//У���Ƿ�ҽ���Ǽ�
	var _validReg = function(){
	       return new Promise(function(resolve,reject){
		       var obj=$('#btnReg').linkbutton("options")
	           if (obj.disabled==true){return reject();}
		       	//ҽ������
	           var InsuType=$('#InsuType').combobox('getValue');
               if (InsuType ==""){
	             $.messager.alert("��ʾ","��ѡ��ҽ������!", 'info');
		         return reject();
                }
              //ҽ�����
               InsuAdmType=$('#InsuAdmType').combobox('getValue');
              if (InsuAdmType==""){
	           $.messager.alert("��ʾ","��ѡ��ҽ�����!", 'info');
		        return reject();
               }
		       resolve();
		       });
	 }
	 
	//�������� �������������������Ϣ����
   	var _MantRegFlag=function(){
	       return new Promise(function(resolve,reject){
		      //+ WangXQ 20220829 ��������ߵ���
             if(MedTypeDicRelationFlag=="1"){
	             var url = "nur.hisui.medfertilityinfo.csp?EpisodeID="+AdmDr;
	 	         websys_showModal({
		         url: url,
		         title: "������Ϣ��д",
		         iconCls: "icon-w-edit",
		         width: "855",
		         height: "400",
		         onClose: function () {
			          MedTypeDicRelationFlag="";
	  			}
		        })
               }
                resolve();
               });
		 
	}
	
 //ҽ���ǼǺ���	
 var _InsuReg=function(){
   return new Promise(function(resolve,reject){
	   	     var TempString="",InsuType="",InsuAdmType="",CardInfo="",InsuNo=""
	         var StDate="",EndDate=""
	         //��ȡҽ������
	         var InsuType=$('#InsuType').combobox('getValue');
	         
	         //��ȡ�������
	         InsuAdmType=$('#InsuAdmType').combobox('getValue');
	         
			//ҽ����/ҽ��֤��
			InsuNo=getValueById('InsuNo');
			
			//ҽ����Ժ��ϱ���
		    var InsuInDiagCode=getValueById('InsuInDiagCode');  
		                
			//ҽ����Ժ�������
		    var InsuInDiagDesc=$('#InsuInDiagDesc').combogrid('getText');
		    
			//��������
			var AdmDate=getValueById('AdmDate'); 
			
			 //����ʱ��
			var AdmTime=getValueById('AdmTime');
			
			//���Ʒ�ʽ
			var ZLFSStr=$('#ZLFS').combobox('getValue');	
			
			//������ʽ
			var BCFSStr=$('#BCFS').combobox('getValue')	

			//����ƾ֤����
			var mdtrtCertType=getValueById('mdtrt_cert_type');	
			
			//����ƾ֤���
			var mdtrtCertNo=getValueById('mdtrt_cert_no')	
			
			//�α���ҽ������
			//var insuplcAdmdvs=getValueById('insuplc_admdvs')
			//upt HanZH 20230410
			var insuplcAdmdvs=$('#insuplc_admdvs').combogrid('getValue')
		
			//add 20220919 HanZH
			//���ֱ���
			var diseCodg=getValueById('diseCodg');
			//��������
			var diseName=getValueById('diseName');
			//������������
			var oprnOprtCode=getValueById('oprnOprtCode');
			//������������
			var oprnOprtName=getValueById('oprnOprtName');
			//upt 20230328 HanZH ����ѡ����Ϊ��ʱ���ж��Ƿ�����ѡ���ֽ���ҽ���Ǽǵ�ҽ����������
			if (diseCodg=="") {
				//�������� ����ѡ���ֽ���ҽ���Ǽǵ�ҽ�����	20220920 HanZH
				var RegFlag=""
				var RegFlagStr=tkMakeServerCall("web.INSUDicDataCom","GetDicByCodeAndInd","HISPROPerty"+InsuType,"AlwNoDiseSelRegOfMedType",4,HospDr);
				if (RegFlagStr!=""){
					if(RegFlagStr.indexOf("|"+InsuAdmType+"|")!=-1){
						RegFlag="Y";
					}
				}
				if(RegFlag!="Y"){
					$.messager.alert("��ʾ","��ѡ��ҽ�����="+InsuAdmType+"�Ĳ�����Ϣ!", 'info');
					return ;
				}
			}
			var JSSSLB="",psnCardType="",psnCardno="";
			//TempString=InsuAdmType+"^"+InsuInDiagCode+"^"+InsuInDiagDesc+"^"+InsuNo+"^"+AdmDate+"^"+AdmTime+"^"+ZLFSStr+"^"+BCFSStr+"^"+InsuType+"^"+""+"^"+mdtrtCertType+"^^"+JSSSLB+"^"+mdtrtCertNo+"^"+psnCardType+"^"+psnCardno+"^"+insuplcAdmdvs
			TempString=InsuAdmType+"^"+InsuInDiagCode+"^"+InsuInDiagDesc+"^"+InsuNo+"^"+AdmDate+"^"+AdmTime+"^"+ZLFSStr+"^"+BCFSStr+"^"+InsuType+"^"+""+"^"+mdtrtCertType+"^^"+JSSSLB+"^"+mdtrtCertNo+"^"+psnCardType+"^"+psnCardno+"^"+insuplcAdmdvs+"^"+diseCodg+"^"+diseName+"^"+oprnOprtCode+"^"+oprnOprtName
			
			//ҽ���Ǽ�
			var flag=InsuIPReg(0,GUser,AdmDr,AdmReasonNationalCode, AdmReasonDr,TempString)//DHCInsuPort.js
			InsuRegRepFlag="N";
			if (flag == 0) 
			{
				$.messager.alert("��ʾ","ҽ���Ǽǳɹ�!", 'info');
			}
			else	
			 {
				$.messager.alert("��ʾ","ҽ���Ǽ�ʧ��!rtn="+flag, 'error');
				return reject() ;
			}
			 UpdatePatAdmReason(AdmDr,"",GUser);
			//GetPatInfo();
			 PapmiNo_onkeydown();
	         resolve();
	  });
	}
   var promise = Promise.resolve();
	promise
		.then(_validReg)
		.then(_MantRegFlag)
		.then(_InsuReg, function () {
			//reject()
		});
   
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
	//����ƾ֤����	����ƾ֤ҽ���Ǽ�����ȡ��ҽ���Ǽ��ò���Աѡ��ȷ��	20220916 HanZH
	var mdtrtCertType=getValueById('mdtrt_cert_type');
	if (mdtrtCertType=="01"){
		var oldOk = $.messager.defaults.ok;
		var oldCancel = $.messager.defaults.cancel;
		$.messager.defaults.ok = "ȷ��";
		$.messager.defaults.cancel = "ȡ��";
		$.messager.confirm("ȡ��ҽ���Ǽ�", "����ƾ֤ҽ���Ǽ����ݣ��Ƿ�ȷ��ȡ��ҽ���Ǽ�", function (r) {
			if (r) {
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
			}else{
				$.messager.popover({ msg: "����ȡ��" });
				return;
			}
		});
		$.messager.defaults.ok = oldOk;
		$.messager.defaults.cancel = oldCancel; 
	}else
	{
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
	 //var OldCardNo=getValueById('OldCardNo');
	 if (NewCardNo==InsuCurCardNo){		   
  	  	$.messager.alert("��ʾ","�޸ĵ�ҽ������û�仯����������д!", 'info');
   	 	return;   
	 }
	var flag=tkMakeServerCall("web.INSUAdmInfoCtlCom","UpdateINSUCardNo",AdmDr,InsuCurCardNo+"_"+NewCardNo);
	if(flag=="0")
	{
	  setValueById('CardNo',NewCardNo);
	  setValueById('OldCardNo',InsuCurCardNo);
	  //OldCardNo=NewCardNo; //���³ɹ����µĿ��ű�ɾͿ�����
	  GetPatInfo();
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
	 	 setTimeout(function(){$.messager.alert('��ʾ','ȡ������Ϣʧ��,��������ȷ�ĵǼǺ�!','error')},200);
		 return ;
 	}
 	else
 	{
	 	aData=rtn.split("^");
	 	setValueById('Name',aData[2]);             //����
	 	setValueById('Sex',aData[4]);              //�Ա�
	 	setValueById('Age',aData[3]);              //����
	 	setValueById('PatID',aData[8]);            //���֤��
	 	setValueById('CTProvinceName',aData[16]);  //ʡ
	 	setValueById('CTCityName',aData[18]);      //��
	 	setValueById('CTAreaName',aData[20]);      //��
	 	//setValueById('BDDT',aData[9]);             //��������
	 	setValueById('MedicareNo',aData[14]);       //סԺ��
	    //CTProvinceCode=aData[15];
        //CTCityCode=aData[17];
        //CTAreaCode=aData[19];
         //InitAdmCmbGd();
         //InitAdmDiagCmbGd();
         QryAdmLst();
         QryDiagLst();
		setValueById('BDDT',GetInsuDateFormat(aData[9],3))	//��������	upt HanZH 20220805
	 }
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
			  //setValueById('AdmDate',rowData.AdmDate)
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

			  AdmDate=GetInsuDateFormat(rowData.AdmDate,3)
			  setValueById('AdmDate',AdmDate)	//��Ժ����	upt HanZH 20220805
		},
		
		onLoadSuccess:function(data)
		{
	        if (data.total<0) 
	        {
		        disableById("btnReg");        //+ 20220831
		        disableById("btnRegCancle");  
		        disableById("btnAppyReg");  //+ upt 20230314 Jins1010
		        return ;
	        }
			if (data.total==0)
			{
				disableById("btnReg");        //+ 20220831 
		        disableById("btnRegCancle");  
		        disableById("btnAppyReg");  //+ upt 20230314 Jins1010
				$.messager.alert("��ʾ", "û�в�ѯ�����˾����¼,����ȷ�ϻ����Ƿ�ʿ�ִ�!", 'info');
				return ;
			}
			else 
			{
			  var indexed=-1
			  var Flag=0
			  for(var i in data.rows)
			  {
				if( data.rows.hasOwnProperty(i)){
					if(AdmDr==data.rows[i].AdmDr)
					{
						indexed=i;
						 Flag=1;
						 break;
					}
					if((data.rows[i].VisitStatus=="��Ժ")&&(AdmDr==""))
					  {
						indexed=i;
						 Flag=1;
						 break;
					  }
				}
				// if (Flag==0)
				//   {
				// 	indexed=i;
				//  	break;
				//   }
				// if(AdmDr==data.rows[i].AdmDr)
				// {
				// 	indexed=i;
				//  	break;
				// }
				indexed=0;
		      }
		    
		      if (indexed>=0)
		       {
			    var rowData=data.rows[indexed]
					$('#AdmLst').combogrid("setValue",rowData.AdmNo+"-"+rowData.DepDesc+"-"+rowData.AdmDate+" "+rowData.AdmTime+"-"+rowData.VisitStatus+"-"+rowData.AdmReasonDesc)
				    setValueById('DepDesc',rowData.DepDesc)
			        //setValueById('AdmDate',rowData.AdmDate)
			  		
			        setValueById('AdmTime',rowData.AdmTime)
			        setValueById('InDiagCode',rowData.InDiagCode)
			        setValueById('InDiagDesc',rowData.InDiagDesc)
			        setValueById('AdmReasonDesc',rowData.AdmReasonDesc)
				    AdmDr=rowData.AdmDr
				    AdmReasonDr=rowData.AdmReasonDr
			        AdmReasonNationalCode=rowData.ReaNationalCode
			        //InitAdmDiagCmbGd();
			       
			        GetInsuAdmInfo();
			        QryInAdmInfo();
			        QryDiagLst();
			        
					AdmDate=GetInsuDateFormat(rowData.AdmDate,3)
					setValueById('AdmDate',AdmDate)	//��Ժ����	upt HanZH 20220805
			 }
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
	        {field:'DiagnosPrefix',title:'���ǰ׺',width:80},  
	        {field:'DiagnosDesc',title:'�������',width:160}, 
	        {field:'DiagnosMRDesc',title:'���ע��',width:80},  
	         {field:'MainDiagFlag',title:'�����',width:60,align:'center',
	            formatter: function(value,row,index)
	                {
			              return  value=="Y" ? "��":"��" 
			        }
			   },    
	        {field:'DiagnosType',title:'�������',width:80,align:'center'},   
	        {field:'DiagStat',title:'���״̬',width:80,align:'center'},   
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
{   if (!!AdmDr)
    {
	 var tURL=$URL+"?ClassName="+'web.DHCINSUPortUse'+"&MethodName="+"GetPatAllDiagsByADM"+"&PAADM="+AdmDr+"&DiagType="+""+"&ExpStr="+("^"+InsuType+"^HUIToJson")
     $('#DiagLst').combogrid({url:tURL});
    }
   
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
			enableById("btnAppyReg"); //+20230314 JinS1010
			if (rtn=="-100"){
				ClearInsuAdmInfo();	//+20221125 HanZH
				//��ʼ��ҽ������ +20230317 HanZH		
				InitInsuTypeCmb();
				InitYLLBCmb();
			}
		} else {
			var myAry = rtn.split("!")[1].split("^");
			if (((myAry[11] == "A") || (myAry[11] == "O")) && (InsuRegRepFlag=="Y")){
				var oldOk = $.messager.defaults.ok;
				var oldNo = $.messager.defaults.no;
				$.messager.defaults.ok = " �� ";
				$.messager.defaults.no = " �� ";
				var btcnfm = $.messager.confirm("��ܰ����", "�Ѵ�����Ч�Ǽ���Ϣ���Ƿ��ٴεǼ�?", function (r) {
					if (r) {
				        InitInsuTypeCmb();
				        InitYLLBCmb();
				        enableById("btnReg");
						enableById("btnRegCancle");
						enableById("btnAppyReg"); //+20230314 JinS1010
						return;
					} else {
						_loadInsuAdmInfo(myAry);
					}
					/*Ҫд�ڻص�������,�����ھɰ��¿��ܲ��ܻص�����*/
					$.messager.defaults.ok = oldOk;
					$.messager.defaults.no = oldNo;
				}).children("div.messager-button");
				btcnfm.children("a:eq(1)").focus();
				btcnfm.children("a:eq(0)").addClass('green'); 
			}else{
				InsuRegRepFlag="Y";
				_loadInsuAdmInfo(myAry);
			}
			
		}
	});
    //����ҽ���Ǽ���Ϣ + 20230411 DingSH
	function _loadInsuAdmInfo (myAry) {

		var actDesc = "";
		if (myAry[11] == "A") {
			actDesc = "��Ժ";
			disableById("btnReg");
			enableById("btnRegCancle");
			disableById("btnAppyReg"); //+20230314 JinS1010
		}
		if (myAry[11] == "O") {
			actDesc = "��Ժ";
			disableById("btnReg");
			disableById("btnRegCancle");
			disableById("btnAppyReg"); //+20230314 JinS1010
		}
		if (myAry[11] == "S") {
			actDesc = "ȡ���Ǽ�";
			enableById("btnReg");
			disableById("btnRegCancle");
			enableById("btnAppyReg"); //+20230314 JinS1010
		}
		setValueById("InsuActiveFlag", actDesc);        //ҽ���Ǽ�״̬
		setValueById("InsuNo", myAry[2]);               //ҽ����
		setValueById("CardNo", myAry[3]);               //ҽ������
		//setValueById("NewCardNo", myAry[3]);          //��ҽ������
		InsuCurCardNo= myAry[3];                         
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
		//setValueById("xzlx",myAry[37])                   //��������
		//setValueById("dylb",myAry[36])                   //�������
		setValueById("xzlx",myAry[36])                   //��������	upt HanZH 20220929
		setValueById("dylb",myAry[37])                   //�������	upt HanZH 20220929
		//setValueById("AdmDate",myAry[12])                //��Ժ����
		setValueById("AdmTime",myAry[13])                //��Ժʱ��
		setValueById("InsuAdmSeriNo",myAry[10])          //ҽ�������
		setValueById("InsuCenter",myAry[8])              //ҽ��ͳ����
		//setValueById("ZLFS", myAry[38]);               //���Ʒ�ʽ
		//setValueById("BCFS", myAry[39]);               //������ʽ
		InitMdtrtCertTypeCmb(myAry[42]);                 //����ƾ������
		setValueById("mdtrt_cert_no",myAry[43])          //����ƾ�ݱ��
		InitPROConfg();                                  //ҽ�����ÿ���
		AdmDate=GetInsuDateFormat(myAry[12],3)           //���ڸ�ʽ��
		setValueById('AdmDate',AdmDate)	                 //��Ժ����	upt HanZH 20220805
		
		var disOper=myAry[38].split("|")
		setValueById('diseCodg',disOper[0]); //upt HanZH 20220929
		setValueById('diseName',disOper[1]); //upt HanZH 20220929
		if(disOper.length=4){
			setValueById('oprnOprtName',disOper[2]); //upt HanZH 20220929
			setValueById('oprnOprtCode',disOper[3]); //upt HanZH 20220929
		}
		//ҽ��ͳ����	add HanZH 20230410
		$('#insuplc_admdvs').combogrid("setValue",myAry[8]);
		$('#insuplc_admdvs').combogrid("setText",myAry[54]);


	}
	
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
				return false;
				}
			if (getValueById("InsuType") && ($.trim(param.q).length >= 1)) {
				$("#InsuInDiagDesc").combogrid("grid").datagrid("options").url = $URL;
				param.ClassName = "web.DHCINSUIPReg";
				param.QueryName = "GetInsuDiagnosis";
				param.InsuInDiagDesc = param.q;
				param.InsuType = getValueById("InsuType");
				param.HospDr=HospDr;
			}else{
				$('#InsuInDiagDesc').combogrid('grid').datagrid("loadData",{total:0,rows:[]});
				return false;
				 
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
			height:528,
			width:948,
		    iconCls:'icon-w-paper',
			modal:true
			
		})
	
		
	}
	
	
//��ֵҽ�����ﵯ��Ԫ��		
function FillInAdmDl(Data)
{
	
	for (var key in Data) {
     if (Data.hasOwnProperty.call(Data, key)) {
         setValueById('F'+key.substr(1),Data[key]);
         
     }
    }

	
}		
	
//���ҽ�����ﵯ��Ԫ��	
function ClearInAdmDl()
{
	
	$('#InAdmDl').form('clear');
}	




		
//��ʼ��ҽ�����
function InitYLLBCmb()
{   
    MedTypeDicRelationFlag=""  //20220829  ҽ���������ֵ��ʶ
	var options = {
		   hospDr:HospDr,
		   defaultFlag:"Y",
		   DicOPIPFlag:"IP"
		}
	//INSULoadDicData("InsuAdmType",("AKA130"+InsuType),options); // dhcinsu/common/dhcinsu.common.js
	INSULoadDicData("InsuAdmType",("med_type"+InsuType),options); // dhcinsu/common/dhcinsu.common.js	20220106
	if(arguments.length ==1)
	{
		var InsuAdmType=arguments[0] || "";
		$HUI.combobox("#InsuAdmType",{
			onLoadSuccess:function(data){
				if (InsuAdmType!="")
				{
					setValueById('InsuAdmType',InsuAdmType);
				}
			},
			onSelect:function(data){
				MedTypeDicRelationFlag=data.DicRelationFlag
			}
		});
	}
	
	
}

//��ʼ����Ժԭ�� +20200916 DingSH
function InitInsuIPRsCmb()
{
	var options = {
		   hospDr:HospDr,
		   defaultFlag:"Y",
		   DicOPIPFlag:"IP"
		  
		}
	//INSULoadDicData("InsuIPRs",("AKA130"+InsuType),options); // dhcinsu/common/dhcinsu.common.js
	INSULoadDicData("InsuIPRs",("med_type"+InsuType),options); // dhcinsu/common/dhcinsu.common.js	upt 20220106
	
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

//��ʼ��������ʽ
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
		fitColumns: false,
		rownumbers:true,
		singleSelect: true,
		frozenColumns:[[
		  { 
		    field:'TOpt',
		    width:40,
		    title:'����',
		    formatter: function (value, row, index) {
						//return "<img class='myTooltip' style='width:60' title='��ϸ��Ϣ' onclick=\"InAdmFrmClick('" + index+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/pat_info.png' style='border:0px;cursor:pointer'>";
						//return "<span class='myTooltip' style='color:#339EFF' onclick='InAdmFrmClick(" + row.TrnsLogDr + "," + row.Infno + ")'>����</span>";
						return "<a class='myTooltip' style='color:#339EFF' onclick=\"InAdmFrmClick('" + index+"')\" style='border:0px;cursor:pointer'>����</a>";
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
			{field:'TAdmDate',title:'��Ժ����',width:100,align:'center'},
			{field:'TAdmTime',title:'��Ժʱ��',width:80,align:'center'},
			{field:'TInsuUser',title:'������',width:100},
			{field:'TFunDate',title:'��������',width:120,align:'center'},
			{field:'TFunTime',title:'����ʱ��',width:120,align:'center'},
			{field:'TOutUser',title:'��Ժ������',width:140},
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
		if(rtn.split("^")[0]!=0){$.messager.alert("��ʾ","ҽ���Ǽǳɹ�,���Ǹ��·ѱ�ʧ��,rtn="+rtn, 'info')}
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
	AdmDr="";
	setValueById('AdmDate',"");
	setValueById('AdmTime',"");
	setValueById('DepDesc',"");
	setValueById('InDiagCode',"");
	setValueById('InDiagDesc',"");
	setValueById('AdmReasonDesc',"");
	//$('#AdmLst').combogrid('setValue',"")
	//$('#DiagLst').combogrid('setValue', "")
    //$('#AdmLst').combogrid('clear');
    //$('#DiagLst').combogrid('clear');
    
    $HUI.combogrid("#AdmLst").clear();
    $HUI.combogrid("#DiagLst").clear();
    $('#AdmLst').combogrid('grid').datagrid("loadData",{total:-1,rows:[]});
    $('#DiagLst').combogrid('grid').datagrid("loadData",{total:-1,rows:[]});
   
	}
function ClearInsuAdmInfo() {
	$('#InsuType').combobox('setValue',"");
    $('#InsuAdmType').combobox('setValue',"");
	$('#InsuInDiagDesc').combogrid('clear');
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
	setValueById('mdtrt_cert_type',"");	//20220106
	setValueById('mdtrt_cert_no',""); //20220106
	
	setValueById('diseName',""); //20220929
	setValueById('diseCodg',""); //20220929
	setValueById('oprnOprtName',""); //20220929
	setValueById('oprnOprtCode',""); //20220929

	setValueById('insuplc_admdvs',""); //20230331
	
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
//��ʼ������ƾ֤����
function InitMdtrtCertTypeCmb()
{
	var options = {
		   hospDr:HospDr,
		   defaultFlag:"Y",
		}
	INSULoadDicData("mdtrt_cert_type",("mdtrt_cert_type"+InsuType),options); // dhcinsu/common/dhcinsu.common.js
	if(arguments.length ==1)
	{
	var selVal=arguments[0];
	$HUI.combobox("#mdtrt_cert_type",{
	      onLoadSuccess:function(data){
				       setValueById('mdtrt_cert_type',selVal);
				     }
				});
	}
}	
//���ز���(֧�ּ���)
function InitDiseNameCmbGd(){
$("#diseName").combogrid({
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
			 {field: 'Code', title: '���ֱ���', width: 120},
			 {field: 'Desc', title: '��������', width: 230}]
		],
		onBeforeLoad: function(param) {
			if (typeof param.q == "undefined"){
				return false;
				}
			if (getValueById("InsuType") && ($.trim(param.q).length >= 1)) {
				$("#diseName").combogrid("grid").datagrid("options").url = $URL;
				param.ClassName = "web.DHCINSUIPReg";
				param.QueryName = "GetInsuDise";
				param.InsuInDiagDesc = param.q;
				param.InsuType = getValueById("InsuType");
				param.MedType = getValueById("InsuAdmType");
				param.HospDr=HospDr
			}else{
				$('#diseName').combogrid('grid').datagrid("loadData",{total:0,rows:[]});
				return false;
				 
				}
		},
		onSelect: function(rowIndex, rowData) {
			setValueById("diseCodg", rowData.Code);
		},
		onChange: function(newValue, oldValue) {
			if (!newValue) {
				setValueById("diseCodg", "");
			}
		}
	});
}

function InitOprnOprtNameCmbGd(){
$("#oprnOprtName").combogrid({
		panelWidth: 420,
		validType: ['checkInsuInfo'],
		delay: 300,
		mode: 'remote',
		method: 'GET',
		fitColumns: true,
		pagination: true,
		idField: 'OprnOprtCode',
		textField: 'OprnOprtName',
		data: [],
		columns: [
			[{field: 'Rowid', title: 'Rowid', hidden: true},
			 {field: 'OprnOprtCode', title: '������������', width: 120},
			 {field: 'OprnOprtName', title: '������������', width: 230}]
		],
		onBeforeLoad: function(param) {
			if (typeof param.q == "undefined"){
				return false;
				}
			if (getValueById("InsuType") && ($.trim(param.q).length >= 1)) {
				$("#oprnOprtName").combogrid("grid").datagrid("options").url = $URL;
				param.ClassName = "web.DHCINSUIPReg";
				param.QueryName = "QueryOPRNOPRTLISTNEW";
				param.QryType="";
				param.StDate="";
				param.EndDate="";
				param.Code="";
				param.Desc = param.q;
				param.HospId=HospDr;
				param.HiType = getValueById("InsuType");
				param.StDate="";
				param.EndDate="";
				param.Code="";
				param.HisBatch="";
				param.Ver=""
			}else{
				$('#oprnOprtName').combogrid('grid').datagrid("loadData",{total:0,rows:[]});
				return false;
				 
				}
		},
		onSelect: function(rowIndex, rowData) {
			setValueById("oprnOprtCode", rowData.OprnOprtCode);
		},
		onChange: function(newValue, oldValue) {
			if (!newValue) {
				setValueById("oprnOprtCode", "");
			}
		}
	});
}
//2023/03/01 JinS1010 ҽ��סԺ�������뵯��
function btnAppyReg_onclick()  
{
	 
	var obj=$('#btnAppyReg').linkbutton("options")
	if (obj.disabled==true){return ;}
	if(""==AdmDr)
	{	
	 $.messager.alert("��ʾ","��ѡ���˼�������Ϣ!", 'info');
	 return;
	}
	
	var url = "dhcinsu.regappy.csp?&AdmDr="+AdmDr
    websys_showModal({
		url: url,   
		title: "ҽ��סԺ��������",
		iconCls: "icon-w-add",		
		top:"108px", 
		left:"152px",
		onClose: function () {
			
		}
	});
	
}
//ҽ����չ��Ϣ����
function btnInsuAdmExt_onclick()
{
	
	if(AdmDr==""){
	
		$.messager.alert("��ʾ","��ѡ�������Ϣ��", 'info')

		return ;
		}
	var url = "dhcinsu.admext.csp?&AdmDr="+AdmDr	
    websys_showModal({
		url: url,
		title: "ҽ����չ��Ϣ",
		iconCls: "icon-add",	
		width: "500",
		height: "550",	
		onClose: function () {
			
		}
	});
}

//��ʼ��ҽ������ +20230330
function InitadmdvsCmbGd(){
	$("#insuplc_admdvs").combogrid({
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
				{field: 'Code', title: '��������', width: 120},
				{field: 'Desc', title: '��������', width: 230}]
		],
		onBeforeLoad: function(param) {
			if (typeof param.q == "undefined"){
				return false;
				}
			if (getValueById("InsuType") && ($.trim(param.q).length >= 1)) {
				$("#insuplc_admdvs").combogrid("grid").datagrid("options").url = $URL;
				param.ClassName = "web.DHCINSUIPReg";
				param.QueryName = "GetAdmdvs";
				param.Admdvs = param.q;
				param.InsuType = getValueById("InsuType");
				param.HospDr=HospDr
			}else{
				$('#insuplc_admdvs').combogrid('grid').datagrid("loadData",{total:0,rows:[]});
					return false;
			}
		},
		onClickRow:function(rowIndex, rowData)
		{
			  admdvs=rowData.Code;
		},
	});
}
