/**1
 * dhcpha.outpha.prescinfo.js
 * ģ��:����ҩ��
 * ����ҩ������Ԥ���Լ���ӡ��ȡ�������
 * creator:yunhaibao
 * createdate:2017-03-08
 */
 /** @_options
   *	PhdRowId,PrescNo,PrtRowId,PhlRowId,GetType(Print/PreView)
   */
var PrescXMLTemplate=tkMakeServerCall("web.DHCOutPhCommon","GetPrescFmtProp","",session['LOGON.CTLOCID'],"")
var XMLTemplateXY=PrescXMLTemplate.split("^")[0];
var XMLTemplateCY=PrescXMLTemplate.split("^")[1];
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
		if (XMLTemplateXY.indexOf("Ver")>0){
			PrescMainInfo["HosName"]=Hospital;
		}else{
			PrescMainInfo["HosName"]=Hospital+'������';
		}
	   	for (var i=0;i<DiagnoseArrayLen;i++) {
			var m=m+1;
			PrescMainInfo['Diagnose' + m] = DiagnoseArray[i];
		}
	    var sum=0;
	    var medinfo=tmparr[1]
	    var medarr=medinfo.split("@")
	    /*if(medarr==""){
		    return;
	    }*/
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
		       if(OrderName==""){
			       var PackQty="";
			       var DoseQty="";
			       var Inst="";
			       var Freq="";
			       var Lc="";
			       var totalprice="";
			       var Ordremark="";
			   }
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
			   if(totalprice!=""){
		   	      var sum=parseFloat(sum)+parseFloat(totalprice);  
			   }
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
	    var retval=""
	    if (PhdRowId!=""){
		    retval=tkMakeServerCall("web.DHCOutPhPrint","PrintPrescByPhd",PhdRowId)
	    }else{
		   	retval=tkMakeServerCall("web.DHCOutPhPrint","GetOrdInfoByPresc",PrescNo,PrtRowId,PhlRowId)
		}
	    var tmparr=retval.split("!!")
	    var patinfo=tmparr[0]
	    var ordinfo=tmparr[1]
	    var patarr=patinfo.split("^")
	    var PatNo=patarr[0];
	    var PatientName=patarr[1];
	    var PatientAge=patarr[2];
	    var PatientSex=patarr[3];
	    var Diag=patarr[4];
	    var PyName=patarr[6];
	    var FyName=patarr[7];
	    var FyDate=patarr[8];
	    var PrescNo=patarr[15];
	    
	    var Patloc=patarr[16];
	    var Patcall=patarr[18];
	    var Pataddress=patarr[19];
	    var Quecook=patarr[20];
	    var CFtype=patarr[22];						//��������(��ͨ,���顢����������)
	    var Doctor=patarr[24];
	    var Queinst=patarr[25]
	    var Quefac=patarr[26]
	    var Queqty=patarr[27]
	   
	    var Orddate=patarr[31];
	    var Hospital=patarr[32]         
	    var DateStr=Orddate.split("-");
		var Year=DateStr[0];		//��
		var Month=DateStr[1];		//��
		var Day=DateStr[2];			//��
		var SumAmt=patarr[34];    		//��������
	    
	    var PatType=patarr[35];				//��������
	    var PrescCount=patarr[36];		//ζ��
		if(PrescCount==0){
			PrescCount="";
		}else{
			PrescCount="("+PrescCount+"ζ)";
		}
	    var PrescDrugInfo=patarr[37];
	    var PrescConfig=patarr[38];
	    var AuditName=patarr[39];
	    var PatNation=patarr[40];			//����
	    var PrescFreq=patarr[41];
	    var MBDiagnos=patarr[42];		//�������
	    
		

	    
	    
		  
		var totalmoney=0;
		var ordarr=ordinfo.split("@")
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
	       	var SStr=ordstr.split("^")
	        var OrderName=SStr[11]
	        var Quenote=SStr[10]
	        if (Quenote==""){
		       Quenote=" "
		    }
	        var Queuom=SStr[2]
	        var Oneqty=(SStr[1]*1) /parseFloat(Quefac)
	        var Price= SStr[7]
	        var money=SStr[8]
	       	totalmoney=totalmoney+parseFloat(money);//���
	    	colList=OrderName+" "+Oneqty+Queuom+" "+Price+"^"+Quenote;
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
		var yfpc="��"+Quefac+"��"+PrescCount+" "+"�÷�:"+Queinst+" "+PrescFreq+"  һ������:"+Queqty
		var singlemoney=(totalmoney/parseFloat(Quefac)).toFixed(2)
		totalmoney=totalmoney.toFixed(2);
		totalmoney="һ�����:"+singlemoney+"  �ϼƽ��:"+totalmoney+"   "
		var yfpc=yfpc
		var lastrow="��ҩ��:"+PyName+"     ��ҩ��:"+FyName+"     ��ҩʱ��:"+FyDate
	    PrescMainInfo["PrescNo"]=PrescNo;
		PrescMainInfo["PatNo"]=PatNo;  
		PrescMainInfo["Year"]=Year;
	    PrescMainInfo["Month"]=Month;
	    PrescMainInfo["Day"]=Day;
	    PrescMainInfo["CFtype"]=CFtype;
	    
		PrescMainInfo["PatLoc"]=Patloc;
		PrescMainInfo["PyName"]=FyName;
		PrescMainInfo["PatName"]=PatientName;		    	
		PrescMainInfo["PatSex"]=PatientSex;
		PrescMainInfo["Doctor"]=Doctor;
		PrescMainInfo["PatAge"]=PatientAge;
		PrescMainInfo["jytype"]=Quecook;
		PrescMainInfo["PatType"]=PatType;
		
		PrescMainInfo["AdmDate"]=Orddate;
		PrescMainInfo["PatICD"]=Diag;
		PrescMainInfo["PatCall"]=Patcall;
		PrescMainInfo["PatAdd"]=Pataddress;
		PrescMainInfo["TotalMoney"]=totalmoney;
		PrescMainInfo["AuditName"]=AuditName;	
		PrescMainInfo["YFSM"]=yfpc;
		PrescMainInfo["HosName"]=Hospital+'������';
		PrescMainInfo["PrintSign"]=lastrow;	
		PrescMainInfo["MyList"]=PrescList;
	    return PrescMainInfo
	}
})
