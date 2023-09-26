
/// ���һ�������������б�
function addAnaestOperation() {
    var operID = $HUI.combobox("#Operation").getValue(),
        operDesc = $HUI.combobox("#Operation").getText();
    var OperClassID = $HUI.combobox("#OperClass").getValue(),
      OperClassDesc = $HUI.combobox("#OperClass").getText();
      var BladeTypeID = $HUI.combobox("#BladeType").getValue(),
      BladeTypeDesc = $HUI.combobox("#BladeType").getText();
      var operNote = $("#OperNote").val();
      $("#OpSubDr").val("")	//20190118+dyl+7
    if (operDesc && operDesc != "") {
        $HUI.datagrid("#operationBox").appendRow({
            Operation:operID,
		  OperationDesc:operDesc,
		 OperClass:OperClassID,
		  	OperClassDesc:OperClassDesc,
		 	BladeType:BladeTypeID,
		  	BladeTypeDesc:BladeTypeDesc,
		  	OperNote:operNote,
		  	OpSub:''
        });
        $HUI.combobox("#Operation").clear();
        $HUI.combobox("#OperClass").clear();
        $HUI.combobox("#BladeType").clear();
        $("#OperNote").val("");
    }
}
//�޸�������Ϣ
function editAnaestOperation(){
    var selectRow=$("#operationBox").datagrid("getSelected");
    var selindex=$("#operationBox").datagrid("getRowIndex");
    if(selectRow)
    {
      var operID = $HUI.combobox("#Operation").getValue(),
      operDesc = $HUI.combobox("#Operation").getText();
      
      var OperClassID = $HUI.combobox("#OperClass").getValue(),
      OperClassDesc = $HUI.combobox("#OperClass").getText();
      
      var BladeTypeID = $HUI.combobox("#BladeType").getValue(),
      BladeTypeDesc = $HUI.combobox("#BladeType").getText();
      
       var operNote = $("#OperNote").val();
       var ssubOpSub=selectRow.OpSub;
        $("#OpSubDr").val(ssubOpSub)	////20190118+dyl+4
        
    	if(operDesc && operDesc != "") {
        $("#operationBox").datagrid("updateRow",{
	        index:selectOperIndex,
	        row:{
            Operation:operID,
		  	OperationDesc:operDesc,
		  	OperClass:OperClassID,
		  	OperClassDesc:OperClassDesc,
		 	BladeType:BladeTypeID,
		  	BladeTypeDesc:BladeTypeDesc,
		  	OperNote:operNote,
		  	OpSub:$("#OpSubDr").val()
        	}
        });
        $HUI.combobox("#Operation").clear();
        $HUI.combobox("#OperClass").clear();
        $HUI.combobox("#BladeType").clear();
        $("#OperNote").val("");
    	}
    }
    else{
        $.messager.alert("��ʾ", "����ѡ��Ҫ�޸ĵ�������", 'info');
        return;
    	}
}
function removeAnaestOperation(){
    var selectRow=$HUI.datagrid("#operationBox").getSelected();
    var rowIndex=$HUI.datagrid("#operationBox").getRowIndex(selectRow);
    if(selectRow)
    {
        $HUI.datagrid("#operationBox").deleteRow(rowIndex);
        $HUI.combobox("#Operation").clear();
        $HUI.combobox("#OperClass").clear();
        $HUI.combobox("#BladeType").clear();
        $("#OperNote").val("");
        $("#OpSubDr").val("")	//20190118+dyl+9
    }else{
        $.messager.alert("��ʾ", "����ѡ��Ҫɾ����������", 'info');
        return;
    }
}
function disablePatientsList(){
	$("#patientNo").searchbox("disable");
	$("#patientLoc").combobox("disable");
	$("#patientWard").combobox("disable");
	$("#btnSearch").linkbutton("disable");
	//$('#patientsList').datagrid('unselectAll');
}
   //������������
function saveOperApplication(btnid)
{
     var checkResult=CheckData();
     if(checkResult==false) return;
     var appLocId=$("#AppLocation").combobox('getValue');
     var appDocId=$("#AppDoctor").combobox('getValue');
     var operLocationId=$("#OperLocation").combobox('getValue');
     var operType="";
     var operDate=$("#OperDate").datebox('getValue');
     var operTime=$("#OperTime").timespinner('getValue');
     var operDuration="";
     var isAnaest=$("#IsAnaest").combobox('getValue');
     var anaMethod=getPrevAnaMethods;
     var reentryOperation="";
     var prevDiagnosisId="";
     var operPreDiagMem="";
     var preDiagStr=prevDiagnosisId+"/"+operPreDiagMem;
     var mainOperStr=getMainOperStr();
     if(mainOperStr=="")
     {
	     $.messager.alert("����","�����������Ϣ","warning");
             return;
     }
     var subOperStr=getSubOperStr();
     var bodySiteId=$("#BodySite").combobox('getValues');
     bodySiteId=String(bodySiteId).replace(/,/g, "|");
     var operPosId="";
     var operMem=$("#AreaOperMem").val();
     var isoOperation=$("#IsoOperation").checkbox('getValue')?"Y":"N";
     var isECC=$("#ECC").checkbox('getValue')?"Y":"N";
     var isTransAutoblood=$("#TransAutoblood").checkbox('getValue')?"Y":"N";
     var isPrepareBlood=$("#PrepareBlood").checkbox('getValue')?"Y":"N";
     var planSeq="";
     var bloodTypeId=$("#BloodType").combobox('getValue');
     var RHBloodTypeDesc=$("#RHBloodType").combobox('getText');
     var HbsAgDesc=$("#HbsAg").combobox('getText');
  	var HcvAbDesc=$("#HcvAb").combobox('getText');
     var HivAbDesc=$("#HivAb").combobox('getText');
     var SyphilisDesc=$("#Syphilis").combobox('getText');
     var labTestNote="";
     var opDocNote="";
      var cirNurIdStr="";
	var CirNurArray = $("#comCirculNurse").combobox("getValues");
    if(CirNurArray&&CirNurArray.length>0)
    {
        cirNurIdStr= CirNurArray.join(",");
    }
     var ordNo=$("#comOrdNo").combobox('getValue');
    if (typeof ordNo=="undefined") ordNo="";
     var oproom=$("#comOperRoom").combobox('getValue');
    if (typeof oproom=="undefined") oproom="";

     var str1=appLocId+"^"+appDocId+"^"+operDate+"^"+operTime+"^"+session['LOGON.USERID']+"^"+EpisodeID+"^"+oproom+"^"+operMem+"^"+bloodTypeId+"^^^^^^"+operDuration+"^"+opDocNote+"^"+planSeq+"^^^^";
     var appOperInfo=mainOperStr+"^"+preDiagStr+"^"+""+"^"+""+"^"+operLocationId+"^"+bodySiteId+"^"+operPosId+"^"+subOperStr;
     var assDocIdStr="";
     var strCheck=HbsAgDesc+"^"+HcvAbDesc+"^"+HivAbDesc+"^"+SyphilisDesc+"^"+operType+"^"+labTestNote+"^"+RHBloodTypeDesc+"^"+isoOperation+"^"+isPrepareBlood+"^"+isTransAutoblood+"^"+isECC
                  +"^"+isAnaest+"^^^^^"+reentryOperation;
     var selfReport=$("#txtPatSelfReport").val();
     var operResource="";
     var operQueueNo="";
     var comHosTime=$("#comeHosTime").timespinner('getValue');
     var patNotice=$("#txtPatKnow").val();
     var operStockId=$("#comOpConsumable").combobox('getValue');
     var operStockNote=$("#txtstockItemNote").val();
     var beforQueueNo="";
     var telNum=$("#txtPatTele").val();
     //����^ԤԼ��Դ^��Դ^��Ժʱ��^������֪^�Ĳ�^����^֮ǰԤԼ�ĺ�Դ
	  var strClinic=selfReport+"^"+operResource+"^"+operQueueNo+"^"+operDate+" "+comHosTime+"^"+patNotice+"^"+operStockId+"^"+operStockNote+"^"+beforQueueNo+"^"+telNum
		var logUserId=session['LOGON.USERID'];
		var note=$("#txtNote").val(); //ע������
		var opReq=$("#txtOpReq").val();    //��ע
	    var opDateTime="";
	    var surgeonId=$("#comSurgeon").combobox('getValue');
	    if((btnid=="btnOpSave")&&(surgeonId==""))
	    {
		    $.messager.alert("����","��ѡ������ҽʦ","warning");
             return;
	    }
		if (appType=="RegOp"){
	    var opDateTime= $("#dateOpStt").datebox("getValue")+"|"+$("#timeOpStt").timespinner("getValue")+"|"+$("#dateOpEnd").datebox("getValue")+"|"+$("#timeOpEnd").timespinner("getValue");
       }
    
	  var strOp=logUserId+"^"+opReq+"^"+note+"^"+"N"+"^"+ordNo+"^"+""+"|"+""+"^"+opDateTime+"^"+surgeonId;
	switch(appType)
      {
	      case "ward":
	        if((opaId==null)||(opaId=="")) 
     		{
		      	var result=$.m({
	             ClassName:"web.DHCANOPArrangeClinics",
	             MethodName:"insertAnRecord",
	            itmjs:"InsertAddOnOperation",
	             itmjsex:"",
	             str1:str1,
	             op:appOperInfo,
	             ass:assDocIdStr,
	             strcheck:strCheck,
	             anmetId:anaMethod,
	             ifBLApp:"",
	             strClinic:strClinic,
	             appType:appType
	         	},false)
	              
	         	if(result.split("^")[0]<0)
	         	{
		         	window.returnValue=0;	//20181207
	             $.messager.alert("����","�����������"+result.split("^")[1],"warning");
	             return;
	         	}
	         	else{
		         /*
	             $.messager.confirm("ȷ��","����ɹ�,�Ƿ��ӡ����ԤԼ��",function(r){
		             PrintMZSSYYD("MZSSYYD","N",opaId);
		            
	                 
	             })
	             */ 
	             window.returnValue=1;	//20181207
	             var closeWindow = confirm("����ɹ�,�Ƿ��ӡ����ԤԼ��")
			       if(closeWindow)
			       {	
					    PrintMZSSYYD("MZSSYYD","N",result);
					    
			       }
			       window.close();
	         	}
     		}
     	else{
		     	 var result=$.m({
	             ClassName:"web.DHCANOPArrangeClinics",
	             MethodName:"updatewardRecord",
	            itmjs:"InsertAddOnOperation",
	             itmjsex:"",
	             opaId:opaId,
	             str1:str1,
	             op:appOperInfo,
	             ass:assDocIdStr,
	             strcheck:strCheck,
	             anmetId:anaMethod,
	             ifBLApp:"",
	             strClinic:strClinic,
	             appType:appType
	         	},false)
	              
	         	if(result!=0)
	         	{
	             $.messager.alert("����","�޸������������"+result,"warning");
		         	window.returnValue=0;	//20181207
	             return;
	         	}else{
		         	/*
	             $.messager.confirm("ȷ��","����ɹ�",function(r){
		             window.returnValue=1;	//20181207
	                    window.close();
	             })*/
	             window.returnValue=1;	//20181207
	             var closeWindow = confirm("����ɹ�,�Ƿ��ӡ����ԤԼ��")
			       if(closeWindow)
			       {	
					    PrintMZSSYYD("MZSSYYD","N",opaId);
					    
			       }
			       window.close();
	         	} 
    	 }

	      break;
	      case "op":
	      		
		      var result=$.m({
	             ClassName:"web.DHCANOPArrange",
	             MethodName:"UpdateOpRecord",
	             opaId:opaId,
	             str1:str1,
	             scr:"",
	             cir:cirNurIdStr,
	             strOp:strOp,
	             appType:appType,
	             AppLocType:"O",
	             anMethodIdStr:anaMethod
	             
	         	},false)
				if (result!=0){
					window.returnValue=0;	//20181207
				alert(ret);return}
				else 
				{
					$.messager.confirm("ȷ��","��������Ϣ���³ɹ�",function(r){
						window.returnValue=1;	//20181207
			            window.close();
			             })
				}
	      
	      break;
	      case "RegOp":
		      if(btnid=="btnSave")
		      {
				     var result=$.m({
		             ClassName:"web.DHCANOPArrangeClinics",
		             MethodName:"updatewardRecord",
		             opaId:opaId,
		             str1:str1,
		             op:appOperInfo,
		             ass:assDocIdStr,
		             strcheck:strCheck,
		             anmetId:anaMethod,
		             ifBLApp:"",
		             strClinic:strClinic,
		             appType:appType
		         	},false)
		              
		         	if(result.split("^")[0]<0)
		         	{
			         	window.returnValue=0;	//20181207
		             $.messager.alert("����","�����������"+result,"warning");
		             return;
		         	}else{
		              $.messager.confirm("ȷ��","����ɹ����Ƿ�����޸�������Ϣ",function(r){
			             if(!r)
		                {
			                window.returnValue=1;	//20181207
		                    window.close();
		                }
		             })
		         	} 
		      }
			else if(btnid=="btnOpSave")
			{
				var result=$.m({
	             ClassName:"web.DHCANOPArrange",
	             MethodName:"UpdateOpRecord",
	             opaId:opaId,
	             str1:str1,
	             scr:"",
	             cir:cirNurIdStr,
	             strOp:strOp,
	             appType:appType,
	             AppLocType:"O",
	             anMethodIdStr:anaMethod
	         	},false)
				if (result!=0){
				alert(result);return}
				else 
				{
				 $.messager.confirm("ȷ��","����ɹ����Ƿ�����޸�������Ϣ",function(r){
			             if(!r)
		                {
			                window.returnValue=1;	//20181207
		                    window.close();
		                }
				 })
				}

			}
			break;
	      }     
	      
}
//
function GetFilePath()
	{
		var path=$.m({
        ClassName:"web.DHCClinicCom",
        MethodName:"GetPath"
    },false);
    return path;
	}
	
function CheckData(){
    if ((!EpisodeID)||(EpisodeID=="")){
		$.messager.alert("��ʾ","��ѡ����!","error");
		return false;
    }
    if($HUI.timespinner("#OperTime").getValue()=="") 
    {
        $.messager.alert("��ʾ","����д������ʼʱ��!","error");
		return false;
    }
    if($HUI.timespinner("#comeHosTime").getValue()=="") 
    {
        $.messager.alert("��ʾ","����д��Ժʱ��!","error");
		return false;
    }
    if($HUI.combobox("#BloodType").getValue()=="")
    {
        $.messager.alert("��ʾ","��ѡ����Ѫ��!","error");
		return false;
    }
    if($HUI.combobox("#RHBloodType").getValue()=="")
    {
        $.messager.alert("��ʾ","��ѡ����Ѫ��!","error");
		return false;
    }
    if($HUI.combobox("#HbsAg").getValue()=="")
    {
        $.messager.alert("��ʾ","HbsAg��Ŀ����!","error");
		return false;
    }
    if($HUI.combobox("#HcvAb").getValue()=="")
    {
        $.messager.alert("��ʾ","HcvAb��Ŀ����!","error");
		return false;
    }
    if($HUI.combobox("#HivAb").getValue()=="")
    {
        $.messager.alert("��ʾ","HivAb��Ŀ����!","error");
		return false;
    }
    if($HUI.combobox("#Syphilis").getValue()=="")
    {
        $.messager.alert("��ʾ","÷����Ŀ����!","error");
		return false;
    }
}


//�رմ���
function closeWindow(){
	window.returnValue=0;	//20181207
    window.close();
}
	///�������ģ����Ϣ
function saveTempleteDoc_click()
	{
		//alert(obj.comAppDoc.getValue())
		if($("#AppLocation").combobox("getValue")==""){
			alert("����ҽ����Ϣ�쳣���޷����棬��������Ա��");
			return;
		}
		//alert(obj.txtPatKnow.getValue())
		if($("#txtPatKnow").val()=="")
		{
			alert("��������֪������Ϊ�գ�");
			return;
		}
		var locId=$("#AppLocation").combobox("getValue");
		var docId=$("#AppDoctor").combobox("getValue");
		var saveInfo=$("#txtPatKnow").val();
		var ret=$.m({
			//LocId As %String, CtcptId As %String, SetingInfo
	             ClassName:"web.DHCANOPArrange",
	             MethodName:"SaveSetingInfo",
	             LocId:locId,
	             CtcptId:docId,
	             SetingInfo:saveInfo
	         	},false)
		//var ret=_DHCANOPArrange.SaveSetingInfo("",docId,saveInfo);
		if(ret==1)alert("����ɹ���");
		else alert("����ʧ�ܣ�");
	}
	//��ӡ����ԤԼ����Ϣ
function PrintMZSSYYD(prnType,exportFlag,printOpaId)
	{
		if (prnType=="") return;
		//var printInfo=_DHCANOPArrangeClinics.GetMZSSMZYYD(printOpaId); //��ȡ��ӡ��Ϣ
		var printInfo=$.m({
        ClassName:"web.DHCANOPArrangeClinics",
        MethodName:"GetMZSSMZYYD",
        opaId:printOpaId
    },false);
		if(printInfo=="") return ;
		var name,fileName,path,operStat,printTitle,operNum;
		var xlsExcel,xlsBook,xlsSheet;
		var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
		var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
		path=GetFilePath();
		
		fileName=path+prnType+".xls";
		try{
		xlsExcel = new ActiveXObject("Excel.Application");
		xlsBook = xlsExcel.Workbooks.Open(fileName);
		}
		catch(e){
			alert(e.name+"^"+e.message+"^"+e.description+"^"+e.number)
			}
		xlsSheet = xlsBook.ActiveSheet;
		
		
		//var loc=window.status.split(':')[3].split(' ')[1];
		//alert(loc)
		//var hospital=window.status.split(':')[3].split(' ')[2]
		//var hospitalDesc="�׶�ҽ�ƴ�ѧ����"+hospital;
		///***************��ӡ��ͷ**************
		//var hospital=_DHCClinicCom.GetHospital();
		var hospital=$.m({
        ClassName:"web.DHCClinicCom",
        MethodName:"GetHospital"
		},false);
		xlsSheet.cells(1,1)=hospital;
			var position=""
		position=printInfo.split('^')[14];
		//alert(position)
		xlsSheet.cells(1,8)=position;	//������λ
		var appointnum=""	//ԤԼ��
		appointnum=printInfo.split('^')[19]+"";
		xlsSheet.cells(2,8)=appointnum;	
		var appdept=""	//ԤԼ����
		appdept=printInfo.split('^')[13];
		xlsSheet.cells(2,1)="    "+appdept+"����ԤԼ��";
		var patname=""	//��������
		patname=printInfo.split('^')[0];
		xlsSheet.cells(3,2)=patname; 
		var patgender=""	//�Ա�
		patgender=printInfo.split('^')[1];
		xlsSheet.cells(3,4)=patgender;	
		//DZY^Ů^25��^^370***********641X^
		//13649500432^^^^^
		//ͷ��Ѫ�������Գ���^^ҽ��01^������^�ڷ�������^
		//��ǰ��^27/09/2017^27/09/2017 09:00^27/09/2017 ^����ģ��hkdhfkhfkdhfiehie^
		//^kkdkfdsfkd
		var patage=""	//����
		patage=printInfo.split('^')[2];
		xlsSheet.cells(3,6)=patage;	
		var patmed=""  //������
		patmed=printInfo.split('^')[3];
		xlsSheet.cells(3,8)=patmed;	
		var patidnum=""	//���֤��
		patidnum=printInfo.split('^')[4];
		xlsSheet.cells(4,2)=patidnum;
		var patworkplace=""	//������λ
		patworkplace=printInfo.split('^')[6];
		xlsSheet.cells(4,5)=patworkplace;
		var patphone=""		//�绰
		patphone=printInfo.split('^')[5];		
		xlsSheet.cells(5,2)="'"+patphone; 
		var pataddress=""
		pataddress=printInfo.split('^')[7];
		xlsSheet.cells(5,5)=pataddress; //��ͥסַ
		var patmedinfo=""
		patmedinfo=printInfo.split('^')[20];
		xlsSheet.cells(6,2)=patmedinfo;	//����ժҪ
		var patdiag=""
		patdiag=printInfo.split('^')[8];	//���
		xlsSheet.cells(7,2)=patdiag;
		var opname="" //��������
		opname=printInfo.split('^')[9];
		xlsSheet.cells(8,2)=opname;
		var opsurgeon=""
		opsurgeon=printInfo.split('^')[10];
		xlsSheet.cells(9,2)=opsurgeon; //����ҽ��
			 
		var oploc=""	//��������
		oploc=printInfo.split('^')[12];
		xlsSheet.cells(9,4)=oploc;
		var appointtime="" //ԤԼ����
		appointtime=printInfo.split('^')[16];
		xlsSheet.cells(9,7)=appointtime;
		var appdoc=""	//����ҽ��
		appdoc=printInfo.split('^')[11]
		xlsSheet.cells(10,2)=appdoc;	
		var apploc=""	//�������
		apploc=printInfo.split('^')[13];
		xlsSheet.cells(10,4)=apploc;
		var apptime=""	//����ʱ��
		apptime=printInfo.split('^')[15];
		xlsSheet.cells(10,7)=apptime;
		
		var patnotice=""	//������֪
		patnotice=printInfo.split('^')[18];
		xlsSheet.cells(12,1)=patnotice;
		var cometime=""	//��Ժʱ��
		cometime=printInfo.split('^')[17];
		xlsSheet.cells(12,7)=cometime;
		

		
		if (exportFlag=="Y")
		{
			var savefileName="D:\\";
			//var savefileName=_UDHCANOPSET.GetExportParth()
			var d = new Date();
			savefileName+=d.getYear()+"-"+(d.getMonth()+ 1)+"-"+d.getDate();
			savefileName+=" "+d.getHours()+","+d.getMinutes()+","+d.getSeconds();
			savefileName+=".xls"
			xlsSheet.SaveAs(savefileName);	
		}
		else
		{
			xlsExcel.Visible = true;
			xlsSheet.PrintPreview();
		}
		//xlsSheet.PrintOut();
		xlsSheet = null;
		xlsBook.Close(savechanges=false)
		xlsBook = null;
		xlsExcel.Quit();
		xlsExcel = null;
	}
