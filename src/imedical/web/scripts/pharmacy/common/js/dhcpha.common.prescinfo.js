/**
 * dhcpha.common.prescinfo.js
 * 模块:药房公共
 * 药房公共处方预览以及打印获取数据入口
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
	    var zf='[正方]'
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
	    var AdmDate=patarr[13] //就诊日期
	    var PatH=patarr[5];
	    var PyName=patarr[6];
	    var FyName=patarr[7];
	    var PatientCompany=patarr[12];  //工作单位
	    var PatientMedicareNo=patarr[14]; //医保编号
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
	    PrescMainInfo["PrescTitle"]=PrescTitle; //与xml mypara保持一致            
	    PrescMainInfo["zf"]=zf;
	    PrescMainInfo["PresType"]="处方笺";
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
		PrescMainInfo["HosName"]=Hospital+'处方笺';
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
		       var tmpdoseinfo=" 每次"+DoseQty
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
	     PrescMainInfo["Sum"]=TotalSum+'元';
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
	    var zf='[正方]'
	    var retval=retval=tkMakeServerCall("web.DHCOUTPHA.Common.Print","GetCYOrdInfoByPresc",PrescNo);
	    var tmparr=retval.split("!!");
	    var PatInfo=tmparr[0];
	    var OrdInfo=tmparr[1];
	    var PatArr=PatInfo.split("^");
	    var PatNo=PatArr[0];
	    var PatName=PatArr[1];
	    var PatAge=PatArr[2];
	    var PatSex=PatArr[3];
	    var Diag=PatArr[4]; 					//诊断
		var phwdesc=PatArr[5]; 					//窗口	    
	    var CookType=PatArr[20];			
	    var CFtype=PatArr[22];					//处方类型(普通,毒麻、精、急、儿)
	   	var AdmLoc=PatArr[23];					//病人科室
	    var Doctor=PatArr[24];    				//医生
	    var Queinst=PatArr[25];	
	    var Quefac=PatArr[26]					//
	    var PrescQty=PatArr[27];
	    var PrescNote=PatArr[30];				//处方备注
		var OrdDate=PatArr[31];     			//开方日期
		var DateStr=OrdDate.split("-");
		var Year=DateStr[0];					//年
		var Month=DateStr[1];					//月
		var Day=DateStr[2];						//日
		var HospDesc=PatArr[32];				//医院名称
		var Title=HospDesc+"门诊草药处方笺";	//处方标题
		var SumAmt=PatArr[34];    				//处方费用
	    var PatType=PatArr[35];					//病人类型
	    var PrescDrugInfo=PatArr[37];
	    var PrescConfig=PatArr[38];
	    var AuditName=PatArr[39];
		if(AuditName==""){
			AuditName=session['LOGON.USERNAME'];
		}
	    var PatNation=PatArr[40];				//民族
	    var PrescFreq=PatArr[41];
	    var MBDiagnos=PatArr[42];				//慢病诊断
	    var PrescSerialNo=PatArr[43];			//流水号
		var PrescCount=PatArr[36];				//味数
		if(PrescCount==0){
			PrescCount="";
		}else{
			PrescCount="("+PrescCount+"味)";
		}
	   
		//          
		var totalmoney=0;
		var ordarr=OrdInfo.split("@")
	    var OrdRows=ordarr.length;
	    var colNum=4; //列数
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
	    	//每次换行进入,开始拼第一行数据
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
			//无换行的结尾进入
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
		var yfpc="共"+Quefac+"付"+PrescCount+" "+PrescConfig+" 用法:"+Queinst+" "+PrescFreq+" "+PrescQty+"/次 "+PrescDrugInfo+" "+PrescNote;
		var totalmoney=parseFloat(SumAmt).toFixed(2);
		var singlemoney=(totalmoney/parseFloat(Quefac)).toFixed(2)
		totalmoney="一付金额:"+singlemoney+"  合计金额:"+totalmoney+"   "
	    //第一行
	    PrescMainInfo["Title"]=Title;
	    //第二行
	    PrescMainInfo["PatNo"]=PatNo; 
	    PrescMainInfo["OrdDate"]=OrdDate;
	    PrescMainInfo["Year"]=Year;
	    PrescMainInfo["Month"]=Month;
	    PrescMainInfo["Day"]=Day;
	    PrescMainInfo["CFtype"]=CFtype;
	    PrescMainInfo["PrescNo"]=PrescNo;
	    PrescMainInfo["PrescSerialNo"]=PrescSerialNo;
	    //第三行
	    PrescMainInfo["PatName"]=PatName;
	    PrescMainInfo["PatAge"]=PatAge;		    	
		PrescMainInfo["PatSex"]=PatSex;
		PrescMainInfo["PatNation"]=PatNation;
		//第四行
		PrescMainInfo["PatLoc"]=AdmLoc;
		PrescMainInfo["jytype"]=CookType;
	    PrescMainInfo["BillType"]=PatType;
		//第五行
	    PrescMainInfo["PatICD"]=Diag;
	    //第六行
	    PrescMainInfo["MBDiagnos"]=MBDiagnos;
		//正文签名
	    PrescMainInfo["Doctor"]=Doctor;
		PrescMainInfo["YFSM"]=yfpc;	
		PrescMainInfo["MyList"]=PrescList;
		//底部第一行
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
	    var zf='[正方]'
	    var retval=""
		var retval=tkMakeServerCall("web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery","GetPrescDetail",PrescNo);
	    var tmparr=retval.split("!!")
	    var PatInfo=tmparr[0]
	    var OrdInfo=tmparr[1]
		//病人信息
		var PatArr=PatInfo.split("^");
		var AdmLoc=PatArr[16];    	//科别
		var PatNo=PatArr[0];      	//登记号
		var PatName=PatArr[1];    	//病人姓名
		var PatAge=PatArr[2];     	//年龄
		var PatSex=PatArr[3];     	//性别
		var PrescNo=PatArr[29];   	//处方号 
		var PatNation=PatArr[30];	//名族
		var PatAddress=PatArr[20];  //地址
		var DiagnoDesc=PatArr[4]; 	//诊断
		var Doctor=PatArr[17];    	//医生
		var OrdDate=PatArr[18];     //开方日期
		var DateStr=OrdDate.split("-");
		var Year=DateStr[0];		//年
		var Month=DateStr[1];		//月
		var Day=DateStr[2];			//日
		var PyName=PatArr[9];     //配药人
		if(PyName==""){
			PyName=session['LOGON.USERNAME'];
		}
		var FyName=PatArr[10];    //发药人
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
		var PyDate=PatArr[11];    	//配药日期
		var FyDate=PatArr[11];    	//发药日期
		var Queinst=PatArr[21];
		var Quefac=PatArr[22];
		var Queqty=PatArr[23];
		var PrescNote=PatArr[26];	//处方备注
		var CookType=PatArr[27];    //煎药类型 
		var SumAmt=PatArr[28];    	//处方费用
		var CFtype=PatArr[30];		//民族
		var PatNation=PatArr[31]; 
		var PatType=PatArr[32];		//费别
		var PameNo=PatArr[33];		//住院号
		var PrescConfig=PatArr[36];
		var PrescFreq=PatArr[37];
		var PrescQty=PatArr[38];
		var PrescDrugInfo=PatArr[39];
		var DurationDesc=PatArr[40];	//疗程
		var PrescCount=PatArr[41];		//味数
		if(PrescCount==0){
			PrescCount="";
		}else{
			PrescCount=PrescCount+"味";
		}
		  
		var ordarr=OrdInfo.split("@")
	    var OrdRows=ordarr.length;
	    var colNum=4; //列数
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
	    	//每次换行进入,开始拼第一行数据
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
			//无换行的结尾进入
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
		var yfpc=DurationDesc+PrescCount+" "+PrescConfig+" 用法:"+Queinst+" "+PrescFreq+" "+PrescQty+"/次 "+PrescDrugInfo+" "+PrescNote;
		SumAmt=parseFloat(SumAmt).toFixed(2);
		var DrugMoney=SumAmt+"元";
		//第一行
	    PrescMainInfo["PrescNo"]=PrescNo;
	    //第二行
	    PrescMainInfo["Title"]=App_LogonHospDesc+"住院草药处方笺";
	    //第三行
	    PrescMainInfo["PatientNo"]=PameNo;
	    PrescMainInfo["PatNo"]=PatNo;
	    PrescMainInfo["OrdDate"]=OrdDate;
	    PrescMainInfo["Year"]=Year;
	    PrescMainInfo["Month"]=Month;
	    PrescMainInfo["Day"]=Day;
	    PrescMainInfo["CFtype"]=CFtype;
	    //第四行
	    PrescMainInfo["PatName"]=PatName;
	    PrescMainInfo["PatAge"]=PatAge;		    	
		PrescMainInfo["PatSex"]=PatSex;
		PrescMainInfo["PatNation"]=PatNation;
		//第五行
		PrescMainInfo["AdmLoc"]=AdmLoc;
		PrescMainInfo["CookType"]=CookType;
	    PrescMainInfo["PatType"]=PatType;
	    //第六行
	    PrescMainInfo["PatAddr"]=PatAddress;
		//第七行
	    PrescMainInfo["AdmDiagnos"]=DiagnoDesc;
	    //正文签名
	    PrescMainInfo["AdmDoctor"]=Doctor;
		PrescMainInfo["YFSM"]=yfpc;	
		PrescMainInfo["MyList"]=PrescList;
		//底部第一行
		PrescMainInfo["DrugMoney"]=DrugMoney;
		PrescMainInfo["AuditName"]=AuditName;	
		PrescMainInfo["CheckName"]=CheckName;
		//底部第二行
		PrescMainInfo["PyName"]=PyName;	
		PrescMainInfo["FyName"]=FyName;
	    return PrescMainInfo
	}
})
