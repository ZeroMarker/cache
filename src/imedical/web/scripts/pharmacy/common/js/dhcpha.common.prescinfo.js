/**
 * dhcpha.common.prescinfo.js
 * ģ��:ҩ������
 * ҩ����������Ԥ���Լ���ӡ��ȡ�������
 * creator:yunhaibao
 * createdate:2017-03-08
 */
 /** @_options
   *	PhdRowId,PrescNo,PrtRowId,PhlRowId,GetType(Print/PreView)
   */
var PrescXMLTemplate=tkMakeServerCall("web.DHCOutPhCommon","GetPrescFmtProp","",session['LOGON.CTLOCID'],"")
var XMLTemplateXY=PrescXMLTemplate.split("^")[0];
var XMLTemplateCY=PrescXMLTemplate.split("^")[1];
var XMLTemplateInCY=PrescXMLTemplate.split("^")[2];
var DHCPHAPRESCINFO=({
	GetPrescXYInfo:function(_options){
		var PrescMainInfo={};
		var PhdRowId=_options.PhdRowId;
		var PrescNo=_options.PrescNo;
		var PrtRowId=_options.PrtRowId;
		var PhlRowId=_options.PhlRowId;
		var GetType=_options.GetType;
		var IfPresc=_options.IfPresc;
		if (GetType=="PreView"){
			var PrescList=new Array();
		}
		else{
			var PrescList=""
		}
	    var zf='[����]'
	    var retval=""
	    if (PhdRowId!=""){
		    retval=tkMakeServerCall("web.DHCOutPhPrint","PrintPrescByPhd",PhdRowId,IfPresc)
	    }else{
		   	retval=tkMakeServerCall("web.DHCOutPhPrint","GetOrdInfoByPresc",PrescNo,PrtRowId,PhlRowId)
		}
	    var tmparr=retval.split("!!")
	    var patinfo=tmparr[0]
	    var patarr=tmparr[0].split("^")
	    var PatNo=patarr[0];
	    var PatientName=patarr[1];
	    var PatientSex=patarr[3];
	    var PatientAge=patarr[2];
	    var ReclocDesc=patarr[11];
	    var AdmDate=patarr[13] //��������
	    var PatH=patarr[5];
	    var PyName=patarr[6];
	    var FyName=patarr[7];
	    var PatientCompany=patarr[12];  //������λ
	    var PatientMedicareNo=patarr[14]; //ҽ�����
	    var PrescNo=patarr[15] 
	    var AdmDepDesc=patarr[16]
		var Doctor=patarr[24]
	    var Hospital=patarr[32]
	    var diag=patarr[4];
	    var DiagnoseArray=diag.split(",")
	    var DiagnoseArrayLen=DiagnoseArray.length
	    var m=0;
	    var PrescTitle=""
	    var BillType=""
	    var PoisonClass="";
	    var MRNo=patarr[33] 
	    var TotalSum=0 
	    PrescMainInfo["PrescTitle"]=PrescTitle; //��xml mypara����һ��            
	    PrescMainInfo["zf"]=zf;
	    PrescMainInfo["PresType"]="������";
	    PrescMainInfo["PatientMedicareNo"]=PatientMedicareNo;
	    PrescMainInfo["PrescNo"]=PrescNo;
	    PrescMainInfo["MRNo"]=MRNo;
		PrescMainInfo["PANo"]=PatNo;
		PrescMainInfo["RecLoc"]=ReclocDesc;
		PrescMainInfo["Name"]=PatientName;
		PrescMainInfo["Sex"]=PatientSex;
		PrescMainInfo["Age"]=PatientAge;
		PrescMainInfo["Company"]=PatientCompany;
		PrescMainInfo["AdmDate"]=AdmDate;
		PrescMainInfo["PatH"]=PatH;
		PrescMainInfo["PyName"]=PyName;
		PrescMainInfo["FyName"]=FyName;
		PrescMainInfo["HosName"]=Hospital+'������';
	   	for (var i=0;i<DiagnoseArrayLen;i++) {
			var m=m+1;
			PrescMainInfo['Diagnose' + m] = DiagnoseArray[i];
		}
	    var sum=0;
	    var medinfo=tmparr[1]
	    var medarr=medinfo.split("@")
	    var mlength=medarr.length
	    for (h=0;h<mlength;h++)
	     {
		       var medrow=medarr[h]
		       var rowarr=medrow.split("^")
		       var OrderName=rowarr[0]
		       var PackQty=rowarr[1]+rowarr[2]
		       var DoseQty=rowarr[3]
		       var Inst=rowarr[4]
		       var Freq=rowarr[5]
		       var Lc=rowarr[6]
		       var totalprice=rowarr[8]
		       var Ordremark=rowarr[10] 
		       var tmpdoseinfo=" ÿ��"+DoseQty
		       if (DoseQty==""){
			   		tmpdoseinfo="";
			   }
		       var firstdesc=OrderName+' X '+" / "+PackQty +tmpdoseinfo+" "+Inst+" "+Freq+" "+Lc+" "+Ordremark;		     
		       if (typeof(PrescList)=="string"){
			       if (PrescList=='') {
				       PrescList = firstdesc;
		           }else{
			           PrescList = PrescList + String.fromCharCode(2)+firstdesc;
				   }   
			   }else{
				   PrescList.push(firstdesc);
			   }
		   	   var sum=parseFloat(sum)+parseFloat(totalprice);  
	     } 
	     var TotalSum=sum.toFixed(2)
	     PrescMainInfo["Sum"]=TotalSum+'Ԫ';
	     PrescMainInfo["AdmDep"]=AdmDepDesc;
	     PrescMainInfo["UserAddName"]=Doctor;
	     PrescMainInfo["MyList"]=PrescList;
	     return PrescMainInfo
	},
	GetPrescCYInfo:function(_options){
		var PrescMainInfo={};
		var PhdRowId=_options.PhdRowId;
		var PrescNo=_options.PrescNo;
		var PrtRowId=_options.PrtRowId;
		var PhlRowId=_options.PhlRowId;
		var GetType=_options.GetType;
		if (GetType=="PreView"){
			var PrescList=new Array();
		}
		else{
			var PrescList=""
		}
		var PrescListData="";
	    var zf='[����]'
	    var retval=retval=tkMakeServerCall("web.DHCOUTPHA.Common.Print","GetCYOrdInfoByPresc",PrescNo);
	    var tmparr=retval.split("!!");
	    var PatInfo=tmparr[0];
	    var OrdInfo=tmparr[1];
	    var PatArr=PatInfo.split("^");
	    var PatNo=PatArr[0];
	    var PatName=PatArr[1];
	    var PatAge=PatArr[2];
	    var PatSex=PatArr[3];
	    var Diag=PatArr[4]; 					//���
		var phwdesc=PatArr[5]; 					//����	    
	    var CookType=PatArr[20];			
	    var CFtype=PatArr[22];					//��������(��ͨ,���顢����������)
	   	var AdmLoc=PatArr[23];					//���˿���
	    var Doctor=PatArr[24];    				//ҽ��
	    var Queinst=PatArr[25];	
	    var Quefac=PatArr[26]					//
	    var PrescQty=PatArr[27];
	    var PrescNote=PatArr[30];				//������ע
		var OrdDate=PatArr[31];     			//��������
		var DateStr=OrdDate.split("-");
		var Year=DateStr[0];					//��
		var Month=DateStr[1];					//��
		var Day=DateStr[2];						//��
		var HospDesc=PatArr[32];				//ҽԺ����
		var Title=HospDesc+"�����ҩ������";	//��������
		var SumAmt=PatArr[34];    				//��������
	    var PatType=PatArr[35];					//��������
	    var PrescDrugInfo=PatArr[37];
	    var PrescConfig=PatArr[38];
	    var AuditName=PatArr[39];
		if(AuditName==""){
			AuditName=session['LOGON.USERNAME'];
		}
	    var PatNation=PatArr[40];				//����
	    var PrescFreq=PatArr[41];
	    var MBDiagnos=PatArr[42];				//�������
	    var PrescSerialNo=PatArr[43];			//��ˮ��
		var PrescCount=PatArr[36];				//ζ��
		if(PrescCount==0){
			PrescCount="";
		}else{
			PrescCount="("+PrescCount+"ζ)";
		}
	   
		//          
		var totalmoney=0;
		var ordarr=OrdInfo.split("@")
	    var OrdRows=ordarr.length;
	    var colNum=4; //����
	    if(XMLTemplateCY.indexOf("Ver")>=0){
			colNum=3;  
		}
	    var splitOneRow=(colNum*2);
	    var colList="";
	    var colListOneRow="";    
	    for (i=0;i<OrdRows;i++){ 	
	       	var ordstr=ordarr[i];
	       	var SStr=ordstr.split("^");
	        var OrderName=SStr[0];
	        var Queuom=SStr[2];
	        var Oneqty=SStr[1];
	        var Price= SStr[7];
	        var Quenote=SStr[10];
	        if (Quenote==""){
		       Quenote=" ";
		    }
		    var PhSpecInstr=SStr[13];
		    var ColorFlag=SStr[14];
		    if(PhSpecInstr==""){
			    if(ColorFlag!=""){
				    colList=OrderName+" "+Oneqty+Queuom+"@"+ColorFlag+"^"+Quenote;
				}else{
	    			colList=OrderName+" "+Oneqty+Queuom+"^"+Quenote;
				}	
		    }else{
			    if(ColorFlag!=""){
			    	colList=OrderName+" "+Oneqty+Queuom+"@"+ColorFlag+"^"+Quenote+" "+PhSpecInstr;
			    }else{
				    colList=OrderName+" "+Oneqty+Queuom+"^"+Quenote+" "+PhSpecInstr;
				}	
			}
	    	//ÿ�λ��н���,��ʼƴ��һ������
	    	if ((i!=0)&&(i%colNum==0)) { 
		    	var splitLen=colListOneRow.split("^").length;
				if (splitLen<splitOneRow){
					var needLen=splitOneRow-splitLen;
					for (var needi=0;needi<needLen;needi++){
						colListOneRow=colListOneRow+"^";
					}
				}
				if (typeof(PrescList)=="string"){
				   if (PrescList=='') {
				       PrescList = colListOneRow;
				   }else{
				       PrescList = PrescList + String.fromCharCode(2)+colListOneRow;
				   }   
				}else{
				   PrescList.push(colListOneRow);
				}
		    	colListOneRow="";
		    }
		    if (colListOneRow==""){
				colListOneRow=colList;
			}else{
				colListOneRow=colListOneRow+"^"+colList;
			}
			//�޻��еĽ�β����
			if (i==(OrdRows-1)) {
				var splitLen=colListOneRow.split("^").length;
				if (splitLen<splitOneRow){
					var needLen=splitOneRow-splitLen;
					for (var needi=0;needi<needLen;needi++){
						colListOneRow=colListOneRow+"^";
					}
				}
				if (typeof(PrescList)=="string"){
				   if (PrescList=='') {
				       PrescList = colListOneRow;
				   }else{
				       PrescList = PrescList + String.fromCharCode(2)+colListOneRow;
				   }   
				}else{
				   PrescList.push(colListOneRow);
				}
		    	colListOneRow="";
			}
	    }
		var yfpc="��"+Quefac+"��"+PrescCount+" "+PrescConfig+" �÷�:"+Queinst+" "+PrescFreq+" "+PrescQty+"/�� "+PrescDrugInfo+" "+PrescNote;
		var totalmoney=parseFloat(SumAmt).toFixed(2);
		var singlemoney=(totalmoney/parseFloat(Quefac)).toFixed(2)
		totalmoney="һ�����:"+singlemoney+"  �ϼƽ��:"+totalmoney+"   "
	    //��һ��
	    PrescMainInfo["Title"]=Title;
	    //�ڶ���
	    PrescMainInfo["PatNo"]=PatNo; 
	    PrescMainInfo["OrdDate"]=OrdDate;
	    PrescMainInfo["Year"]=Year;
	    PrescMainInfo["Month"]=Month;
	    PrescMainInfo["Day"]=Day;
	    PrescMainInfo["CFtype"]=CFtype;
	    PrescMainInfo["PrescNo"]=PrescNo;
	    PrescMainInfo["PrescSerialNo"]=PrescSerialNo;
	    //������
	    PrescMainInfo["PatName"]=PatName;
	    PrescMainInfo["PatAge"]=PatAge;		    	
		PrescMainInfo["PatSex"]=PatSex;
		PrescMainInfo["PatNation"]=PatNation;
		//������
		PrescMainInfo["PatLoc"]=AdmLoc;
		PrescMainInfo["jytype"]=CookType;
	    PrescMainInfo["BillType"]=PatType;
		//������
	    PrescMainInfo["PatICD"]=Diag;
	    //������
	    PrescMainInfo["MBDiagnos"]=MBDiagnos;
		//����ǩ��
	    PrescMainInfo["Doctor"]=Doctor;
		PrescMainInfo["YFSM"]=yfpc;	
		PrescMainInfo["MyList"]=PrescList;
		//�ײ���һ��
		PrescMainInfo["TotalMoney"]=totalmoney;
		PrescMainInfo["AuditName"]=AuditName;	
	    return PrescMainInfo
	},
	GetPrescInCYInfo:function(_options){
		var PrescMainInfo={};
		var PhdRowId=_options.PhdRowId;
		var PrescNo=_options.PrescNo;
		var PrtRowId=_options.PrtRowId;
		var PhlRowId=_options.PhlRowId;
		var GetType=_options.GetType;
		if (GetType=="PreView"){
			var PrescList=new Array();
		}
		else{
			var PrescList=""
		}
		var PrescListData="";
	    var zf='[����]'
	    var retval=""
		var retval=tkMakeServerCall("web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery","GetPrescDetail",PrescNo);
	    var tmparr=retval.split("!!")
	    var PatInfo=tmparr[0]
	    var OrdInfo=tmparr[1]
		//������Ϣ
		var PatArr=PatInfo.split("^");
		var AdmLoc=PatArr[16];    	//�Ʊ�
		var PatNo=PatArr[0];      	//�ǼǺ�
		var PatName=PatArr[1];    	//��������
		var PatAge=PatArr[2];     	//����
		var PatSex=PatArr[3];     	//�Ա�
		var PrescNo=PatArr[29];   	//������ 
		var PatNation=PatArr[30];	//����
		var PatAddress=PatArr[20];  //��ַ
		var DiagnoDesc=PatArr[4]; 	//���
		var Doctor=PatArr[17];    	//ҽ��
		var OrdDate=PatArr[18];     //��������
		var DateStr=OrdDate.split("-");
		var Year=DateStr[0];		//��
		var Month=DateStr[1];		//��
		var Day=DateStr[2];			//��
		var PyName=PatArr[9];     //��ҩ��
		if(PyName==""){
			PyName=session['LOGON.USERNAME'];
		}
		var FyName=PatArr[10];    //��ҩ��
		if(FyName==""){
			FyName=session['LOGON.USERNAME'];
		}
		var AuditName=PatArr[34];
		if(AuditName==""){
			AuditName=session['LOGON.USERNAME'];
		}
		var CheckName=PatArr[35];
		if(CheckName==""){
			CheckName=session['LOGON.USERNAME'];
		}
		var PyDate=PatArr[11];    	//��ҩ����
		var FyDate=PatArr[11];    	//��ҩ����
		var Queinst=PatArr[21];
		var Quefac=PatArr[22];
		var Queqty=PatArr[23];
		var PrescNote=PatArr[26];	//������ע
		var CookType=PatArr[27];    //��ҩ���� 
		var SumAmt=PatArr[28];    	//��������
		var CFtype=PatArr[30];		//����
		var PatNation=PatArr[31]; 
		var PatType=PatArr[32];		//�ѱ�
		var PameNo=PatArr[33];		//סԺ��
		var PrescConfig=PatArr[36];
		var PrescFreq=PatArr[37];
		var PrescQty=PatArr[38];
		var PrescDrugInfo=PatArr[39];
		var DurationDesc=PatArr[40];	//�Ƴ�
		var PrescCount=PatArr[41];		//ζ��
		if(PrescCount==0){
			PrescCount="";
		}else{
			PrescCount=PrescCount+"ζ";
		}
		  
		var ordarr=OrdInfo.split("@")
	    var OrdRows=ordarr.length;
	    var colNum=4; //����
	    if(XMLTemplateInCY.indexOf("Ver")>=0){
			colNum=3;  
		}
		
	    var splitOneRow=(colNum*2);
	    var colList="";
	    var colListOneRow="";
	    for (i=0;i<OrdRows;i++){ 	
	       	var ordstr=ordarr[i];
	       	var SStr=ordstr.split("^");
	        var OrderName=SStr[0];
	        var Queuom=SStr[2];
	        var Oneqty=SStr[1];
	        var Quenote=SStr[4];
	        if (Quenote==""){
		       Quenote=" ";
		    }
		    var PhSpecInstr=SStr[5];
		    var ColorFlag=SStr[6];
		    
		    if(PhSpecInstr==""){
			    if(ColorFlag!=""){
				    colList=OrderName+" "+Oneqty+Queuom+"@"+ColorFlag+"^"+Quenote;
				}else{
	    			colList=OrderName+" "+Oneqty+Queuom+"^"+Quenote;
				}	
		    }else{
			    if(ColorFlag!=""){
			    	colList=OrderName+" "+Oneqty+Queuom+"@"+ColorFlag+"^"+Quenote+" "+PhSpecInstr;
			    }else{
				    colList=OrderName+" "+Oneqty+Queuom+"^"+Quenote+" "+PhSpecInstr;
				}	
			}
	    	//ÿ�λ��н���,��ʼƴ��һ������
	    	if ((i!=0)&&(i%colNum==0)) { 
		    	var splitLen=colListOneRow.split("^").length;
				if (splitLen<splitOneRow){
					var needLen=splitOneRow-splitLen;
					for (var needi=0;needi<needLen;needi++){
						colListOneRow=colListOneRow+"^";
					}
				}
				if (typeof(PrescList)=="string"){
				   if (PrescList=='') {
				       PrescList = colListOneRow;
				   }else{
				       PrescList = PrescList + String.fromCharCode(2)+colListOneRow;
				   }   
				}else{
				   PrescList.push(colListOneRow);
				}
		    	colListOneRow="";
		    }
		    if (colListOneRow==""){
				colListOneRow=colList;
			}else{
				colListOneRow=colListOneRow+"^"+colList;
			}
			//�޻��еĽ�β����
			if (i==(OrdRows-1)) {
				var splitLen=colListOneRow.split("^").length;
				if (splitLen<splitOneRow){
					var needLen=splitOneRow-splitLen;
					for (var needi=0;needi<needLen;needi++){
						colListOneRow=colListOneRow+"^";
					}
				}
				if (typeof(PrescList)=="string"){
				   if (PrescList=='') {
				       PrescList = colListOneRow;
				   }else{
				       PrescList = PrescList + String.fromCharCode(2)+colListOneRow;
				   }   
				}else{
				   PrescList.push(colListOneRow);
				}
		    	colListOneRow="";
			}
	    }
		var yfpc=DurationDesc+PrescCount+" "+PrescConfig+" �÷�:"+Queinst+" "+PrescFreq+" "+PrescQty+"/�� "+PrescDrugInfo+" "+PrescNote;
		SumAmt=parseFloat(SumAmt).toFixed(2);
		var DrugMoney=SumAmt+"Ԫ";
		//��һ��
	    PrescMainInfo["PrescNo"]=PrescNo;
	    //�ڶ���
	    PrescMainInfo["Title"]=App_LogonHospDesc+"סԺ��ҩ������";
	    //������
	    PrescMainInfo["PatientNo"]=PameNo;
	    PrescMainInfo["PatNo"]=PatNo;
	    PrescMainInfo["OrdDate"]=OrdDate;
	    PrescMainInfo["Year"]=Year;
	    PrescMainInfo["Month"]=Month;
	    PrescMainInfo["Day"]=Day;
	    PrescMainInfo["CFtype"]=CFtype;
	    //������
	    PrescMainInfo["PatName"]=PatName;
	    PrescMainInfo["PatAge"]=PatAge;		    	
		PrescMainInfo["PatSex"]=PatSex;
		PrescMainInfo["PatNation"]=PatNation;
		//������
		PrescMainInfo["AdmLoc"]=AdmLoc;
		PrescMainInfo["CookType"]=CookType;
	    PrescMainInfo["PatType"]=PatType;
	    //������
	    PrescMainInfo["PatAddr"]=PatAddress;
		//������
	    PrescMainInfo["AdmDiagnos"]=DiagnoDesc;
	    //����ǩ��
	    PrescMainInfo["AdmDoctor"]=Doctor;
		PrescMainInfo["YFSM"]=yfpc;	
		PrescMainInfo["MyList"]=PrescList;
		//�ײ���һ��
		PrescMainInfo["DrugMoney"]=DrugMoney;
		PrescMainInfo["AuditName"]=AuditName;	
		PrescMainInfo["CheckName"]=CheckName;
		//�ײ��ڶ���
		PrescMainInfo["PyName"]=PyName;	
		PrescMainInfo["FyName"]=FyName;
	    return PrescMainInfo
	}
})
