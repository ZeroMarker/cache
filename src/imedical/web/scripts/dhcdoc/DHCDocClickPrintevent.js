var DRPrtComfirm=0;
function PrtClickInfoEvent(obj,EpisodeID,PatientID,MRADMID,ctlocid){
	
	//加载类方法
	//obj.stopOrderItem = ExtTool.StaticServerObject("web.DHCOEOrdItem");

	obj.LoadEvent = function(args) {
		obj.gridResultStore.load();
		obj.printButton.on("click",obj.printButton_onclick,obj);
		obj.btnCancleOrder.on("click",obj.btnCancleOrder_onclick,obj);
		TotalExpCal(EpisodeID);
		ThisDepartmentCal(ctlocid);
		getCardBalance(EpisodeID);
		
		obj.gridResult.on("rowclick",function(grid,row,e){
			
			var record=grid.getStore().getAt(row);
			var OrderItemRowid = record.get("OrderItemRowid");
			var OEORIOEORIDR = record.get("OEORIOEORIDR");
			var rowArr=[];//存放选中记录
			var rowdeArr=[];
			if(obj.gridCheckboxSelectionModel.isSelected(row)){
				//alert("rowArr row 1+"+row)
				rowArr.push(row); 
			}
			if (OEORIOEORIDR==""){
				for(var i=0;i<obj.gridResultStore.getCount();i++){
    				var record1 = obj.gridResultStore.getAt(i);
    				var OrderItemRowid1 = record1.get("OrderItemRowid"); 
    				var OEORIOEORIDR1 = record1.get("OEORIOEORIDR");
    				//alert(OEORIOEORIDR1+"##"+OrderItemRowid1)
    				if (OEORIOEORIDR1!="") {
	    				if (OEORIOEORIDR1==OrderItemRowid){
		    				if(obj.gridCheckboxSelectionModel.isSelected(i)){
			    				//alert("rowdeArr i 1+"+i)
	    						//rowdeArr.push(i); 
	    						obj.gridCheckboxSelectionModel.deselectRow(i);
		    				}else{
			    				//alert("rowArr i 1+"+i)
			    				rowArr.push(i); 
			    				} 		
	    				}
    				}	
   				}
   				
			}else{
				if(obj.gridCheckboxSelectionModel.isSelected(row)){
					rowArr.push(row); 
				}
				for(var i=0;i<obj.gridResultStore.getCount();i++){ 
					
    				var record1 = obj.gridResultStore.getAt(i); 
    				var OrderItemRowid1 = record1.get("OrderItemRowid");
    				var OEORIOEORIDR1 = record1.get("OEORIOEORIDR");
    				//alert(OEORIOEORIDR1)
    				if((OrderItemRowid1==OEORIOEORIDR)&&(OEORIOEORIDR1=="")){//根据后台数据判断那些记录默认选中   	
		    			if(obj.gridCheckboxSelectionModel.isSelected(i)){
	    					//rowdeArr.push(i); 
	    					obj.gridCheckboxSelectionModel.deselectRow(i);//反选选中记录 
		    			}else{
			    			rowArr.push(i); 
			    		} 		
    				}else if((OrderItemRowid1!=OrderItemRowid)&&(OEORIOEORIDR==OEORIOEORIDR1)){
	    				if(obj.gridCheckboxSelectionModel.isSelected(i)){
	    					//rowdeArr.push(i); 
	    					obj.gridCheckboxSelectionModel.deselectRow (i);//反选选中记录 	
		    			}else{
			    			rowArr.push(i); 
			    		} 
			    	}
   				}
   					
			}	
		obj.gridCheckboxSelectionModel.selectRows(rowArr,true);//执行选中记录,true保持选中状态
			
		});
	};
	
	
	obj.btnCancleOrder_onclick =function(){
		var strSelectedOrder="";
		var selections = obj.gridCheckboxSelectionModel.getSelections();
		var len = selections.length;
		if(len == 0){
			alert("未选中任何医嘱!请确认后重试！");
		}else{
			if(confirm("是否立即取消选中的医嘱？",true)){
				for(var i = 0;i<len;i++){
					var record = selections[i];
					var OrderItemRowid = record.get("OrderItemRowid");
					var OrderDocRowid = record.get("OrderDocRowid");
					var OrdBilled = record.get("OrdBilled");
					var OrdStatus = record.get("OrdStatus");
					if(OrdStatus=="已发药"){
						Ext.Msg.alert("提示","药品已发药，不能取消医嘱！请核实后重试！");
						return;
					}else if(OrdStatus=="已执行"){
						Ext.Msg.alert("提示","医技已执行，不能取消医嘱！请核实后重试！");
						return;
					}else if(OrdBilled=="已收费"){
						//Ext.Msg.alert("提示","医嘱已收费，不能取消医嘱！请核实后重试！");
						//return;
					}		
					if(strSelectedOrder=="") {strSelectedOrder=OrderItemRowid;}
					else {strSelectedOrder=strSelectedOrder+"^"+OrderItemRowid; }
				}
				//alert(strSelectedOrder)
				var ret = tkMakeServerCall("web.UDHCStopOrderLook","StopOrder","","",strSelectedOrder,OrderDocRowid,"","");
				if(ret == 0 ){
					Ext.Msg.alert("提示","取消医嘱成功！");
					obj.gridResultStore.reload();
					TotalExpCal(EpisodeID);
					ThisDepartmentCal(ctlocid);
				}else{
					Ext.Msg.alert("提示","取消医嘱失败！");
					return;
				}			
			}
		}			
	};

	
	 //费用合计---调用自己的接口不统计折扣。记账等金额只看总费用。实际费用以收费的时候为准
	function TotalExpCal(EpisodeID){
		var TotalExp = 0;
		var  TotalExp = tkMakeServerCall("web.DHCDocQryOEOrder","GetOrdItemSum",EpisodeID,"");
		var TotalExp = parseFloat(TotalExp);
		if(isNaN(TotalExp)){
			TotalExp = 0;
		}
		Ext.getCmp('TotalExpenses').setValue(TotalExp);
		/*
		var checkOutInfoExpStr=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.HOSPID']; 
		var checkOutInfo=tkMakeServerCall("web.udhcOPBillIF","GetLocCheckOutInfo",EpisodeID,"","",checkOutInfoExpStr);
		
		var tmpList=checkOutInfo.split("!");
		if (tmpList.length<4) {
			TotalExp=0
		}else{
			var TotalExp=tmpList[0];	
		}
		Ext.getCmp('TotalExpenses').setValue(TotalExp);
		*/
	}
	//本科室费用合计
	function ThisDepartmentCal(ctlocid){
		var  ThisDepExp = tkMakeServerCall("web.DHCDocQryOEOrder","GetOrdItemSum",EpisodeID,ctlocid);
		var ThisDepExp = parseFloat(ThisDepExp);
		if(isNaN(ThisDepExp)){
			ThisDepExp = 0;
		}
		Ext.getCmp('ThisDepartment').setValue(ThisDepExp.toFixed(2));
   		
	}
	
	
	//卡余额
	 function getCardBalance(EpisodeID){
		var  CardBalance = tkMakeServerCall("web.DHCDocOrderCommon","GetCurrentDeposit",EpisodeID);
		//var CardBalance = tkMakeServerCall("web.DHCOPChargeAddByOther","GetAccLeftByPaadm",EpisodeID);
		//alert(CardBalance)
		var CardBalance = parseFloat(CardBalance);
		if(isNaN(CardBalance)){
				CardBalance = 0;
				}
		Ext.getCmp('CardBalance').setValue(CardBalance.toFixed(2));
   		
	}
	
	function GetPatientBaseInfo(PatientID,EpisodeID,TitleSuf){
		//var GetPatient=document.getElementById('GetPatient');
		//if (GetPatient) {var encmeth=GetPatient.value} else {var encmeth=''};
		var GetPatientInfo=tkMakeServerCall("web.DHCDocOrderEntry","GetPatientByRowid",PatientID);
		if (GetPatientInfo!='') {
			//var GetPatientInfo=cspRunServerMethod(encmeth,PatientID);
			var PatientInfoArr=GetPatientInfo.split("^");
			var PatientNo=PatientInfoArr[1],PatientName=PatientInfoArr[2];
	 		var PatientSex=PatientInfoArr[3],PatientAge=PatientInfoArr[4];
	 		var PatBirthday=PatientInfoArr[5],PatCompany=PatientInfoArr[14];
	 		var MRNo=PatientInfoArr[18],PatientTel=PatientInfoArr[24];
	 		var Pattype=PatientInfoArr[6],InsuNo=PatientInfoArr[28];
	 		var PersonIDNo=PatientInfoArr[30];
	 		var CardNo=PatientInfoArr[29];
		}
		var PatientAge=tkMakeServerCall("web.DHCBillInterface","GetPapmiAge",PatientID,EpisodeID);
		var PAAdmInfo=tkMakeServerCall("web.UDHCPrescript","GetPatInform",EpisodeID);
	 	var PAAdmInfoArr=PAAdmInfo.split("^");
		var AdmDep=PAAdmInfoArr[2],AdmDate=PAAdmInfoArr[3],HosName=PAAdmInfoArr[4]+TitleSuf;
		var Depcodedr=PAAdmInfoArr[5]
		var PrescTitle="",Childweight="";
		var CTLocPrintTypeID=tkMakeServerCall("web.DHCDocPrescript","GetCTLocPrintTypeID",Depcodedr)
        if(CTLocPrintTypeID==1){
	        var rtn=tkMakeServerCall("web.UDHCPrescript","SetGetChildWeight",EpisodeID,"");
			if (rtn!='') {				
		        var str=rtn.split("^");
		        if((str[0]=="1")&&(str[1]=="")){
			         alert("儿科必须填写体重!");
			         return false;
			    }
			    Childweight="体重:"+str[1]+"Kg";
			}
			PrescTitle="[儿科]";
	    }
	    if(CTLocPrintTypeID==2){
		    PrescTitle="[急]";
	    }
		/*if (AdmDep.indexOf("儿科")!=-1) {
			var rtn=tkMakeServerCall("web.UDHCPrescript","SetGetChildWeight",EpisodeID,"");
			if (rtn!='') {				
		        var str=rtn.split("^");
		        if((str[0]=="1")&&(str[1]=="")){
			         alert("儿科必须填写体重!");
			         return "";
			    }
			    Childweight="体重:"+str[1];
			}
			PrescTitle="[儿科]";
		}else if (AdmDep.indexOf("急")!=-1) {PrescTitle="[急]";}*/
		var PrintDateTime=tkMakeServerCall("web.UDHCPrescript","GetSystemDateTime");
		var gmsy="",PrintFormat="",BillType="",UserAddName="";
		var SupplyCardNo="",Duration=""
		var MyPara='PrescTitle'+String.fromCharCode(2)+PrescTitle;
		//MyPara=MyPara+'^PatientMedicareNo'+String.fromCharCode(2)+InsuNo;
		MyPara=MyPara+'^PatientMedicareNo'+String.fromCharCode(2)+CardNo;
		MyPara=MyPara+'^MRNo'+String.fromCharCode(2)+MRNo;
		MyPara=MyPara+'^PANo'+String.fromCharCode(2)+PatientNo;
		MyPara=MyPara+'^PANoBarCode'+String.fromCharCode(2)+("*"+PatientNo+"*");
		MyPara=MyPara+'^AdmDep'+String.fromCharCode(2)+AdmDep;
		MyPara=MyPara+'^Name'+String.fromCharCode(2)+PatientName;
		MyPara=MyPara+'^Sex'+String.fromCharCode(2)+PatientSex;
		MyPara=MyPara+'^Age'+String.fromCharCode(2)+PatientAge;
		MyPara=MyPara+'^gmsy'+String.fromCharCode(2)+gmsy;
		MyPara=MyPara+'^Company'+String.fromCharCode(2)+PatCompany;
		MyPara=MyPara+'^AdmDate'+String.fromCharCode(2)+AdmDate;
		MyPara=MyPara+'^UserAddName'+String.fromCharCode(2)+UserAddName;
		//MyPara=MyPara+'^BillType'+String.fromCharCode(2)+BillType;
		MyPara=MyPara+'^PrintFormat'+String.fromCharCode(2)+PrintFormat;
		MyPara=MyPara+'^Childweight'+String.fromCharCode(2)+Childweight;
		//MyPara=MyPara+'^SupplyCard'+String.fromCharCode(2)+SupplyCardNo;
		MyPara=MyPara+'^Duration'+String.fromCharCode(2)+Duration;
		MyPara=MyPara+'^PatientTel'+String.fromCharCode(2)+PatientTel;
		MyPara=MyPara+'^IDCardNo'+String.fromCharCode(2)+PersonIDNo;
		MyPara=MyPara+'^PrintDateTime'+String.fromCharCode(2)+PrintDateTime;
		MyPara=MyPara+'^HosName'+String.fromCharCode(2)+HosName;
		return MyPara;
	}

	function GetPatMradmInfo(MRADMID){
		//var GetMRDiagnosDesc=document.getElementById('GetMRDiagnos');
		//if (GetMRDiagnosDesc) {var encmeth=GetMRDiagnosDesc.value} else {var encmeth=''};
		//if (encmeth!='') {
			var j=0;
			var MyPara="";
			var delim=';';//+String.fromCharCode(13)+String.fromCharCode(10)
			//var PatMradmInfo=cspRunServerMethod(encmeth,MRADMID,delim);
			var PatMradmInfo=tkMakeServerCall("web.DHCMRDiagnos","GetMRDiagnosDesc",MRADMID,delim);
			var len=PatMradmInfo.length;
			var MradmInfoArr=PatMradmInfo.split(delim);
			for (var i=0;i<MradmInfoArr.length;i++) {
				j=j+1;
				var MradmInfo=MradmInfoArr[i];
				if (MyPara=="") {
					if(MradmInfo.length>8){
						var MradmInfo1=MradmInfo.substring(0,9);
						var MradmInfo2=MradmInfo.substring(9,20);
						MyPara='^Diagnose'+j+String.fromCharCode(2)+MradmInfo1;
						j=j+1;
						MyPara=MyPara+'^Diagnose'+j+String.fromCharCode(2)+MradmInfo2;
					}else{
						MyPara='^Diagnose'+j+String.fromCharCode(2)+MradmInfo;
					}
				}else{
					if(MradmInfo.length>8){
						var MradmInfo1=MradmInfo.substring(0,9);
						var MradmInfo2=MradmInfo.substring(9,20);
						MyPara=MyPara+'^Diagnose'+j+String.fromCharCode(2)+MradmInfo1;
						j=j+1;
						MyPara=MyPara+'^Diagnose'+j+String.fromCharCode(2)+MradmInfo2;
					}else{
						MyPara=MyPara+'^Diagnose'+j+String.fromCharCode(2)+MradmInfo;
					}
				}
			}
		//}
	
		return MyPara;
	}
	function PatientPrescPrint(PatientID,EpisodeID,MRADMID,OrdList,flag1,flag2){
	//alert(EpisodeID+","+OrdList)
		//var PrescNoStr=tkMakeServerCall("web.UDHCPrescript","GetPrescNoStr",EpisodeID);
		var PrescNoStr=tkMakeServerCall("web.UDHCPrescript","GetPrescNoStrByOrdList",EpisodeID,OrdList);
		if(PrescNoStr=="")return;
		
		//获取病人的基本信息
		var PatientInfo=GetPatientBaseInfo(PatientID,EpisodeID,"处方笺");
		//获取病人本次就诊的诊断信息
		var PatMradmInfo=GetPatMradmInfo(MRADMID);
		PatMradmInfo=PatMradmInfo.replace(/(^\s*)|(\s*$)/g,'')
		//var PatMradmInfo=PatMradmInfo.split(" ")[0];
		var PrintCount=2;
		var myobj=document.getElementById('ClsBillPrint');
		var PrescNoArr=PrescNoStr.split("^");
		if((PrescNoArr[0].split('   ')[0].indexOf("!")>0)&&(DRPrtComfirm==0)){
			var PrescDMnum=2*PrescNoArr[0].split('   ')[0].split("!")[1];
			DRPrtComfirm=1
			if(!confirm("毒麻处方需要红纸打印，请放入"+PrescDMnum+"张红色处方纸。"))return;
		}
		for (var j=0;j<PrescNoArr.length;j++){
			var PrescDesc=PrescNoArr[j];
			var PrescNo=PrescDesc.split('   ')[0];//alert(PrescNo)
			if(PrescNo.indexOf("!")>0)PrescNo=PrescNo.split("!")[0];
			//var PrescSerialNo=PrescNo.substring(1,12);
			var ReclocDesc=PrescDesc.split('   ')[2];
			if (ReclocDesc.indexOf("-")!=-1)ReclocDesc=ReclocDesc.split("-")[1];
			var PrescType="";
			var BillType=PrescDesc.split('   ')[3];
			/*if((BillType=="自费")||(BillType=="北京生育保险")||(BillType=="北京新农合")||(BillType=="外埠新农合")||(BillType=="外埠医保")||(BillType=="其他")){
				PrescType="[普通]";
			}else if(BillType=="北京工伤保险"){
				PrescType="[工伤]";
			}else if(BillType=="公费医疗"){
				PrescType="[公疗]";
			}else {PrescType="[医保]";}*/
		
			var PatPrescInfo=tkMakeServerCall("web.UDHCPrescript","GetOrdItemByPrescNo",EpisodeID,PrescNo);
			
			if (PatPrescInfo=="") continue;
			var MyPara="",MyList="";
			var PrescInfoArr=PatPrescInfo.split(String.fromCharCode(1));
			var BilledTxt=PrescInfoArr[2];
			var PrescInfoArr1=PrescInfoArr[0].split("^");
			var Sum=PrescInfoArr1[0],PoisonClass=PrescInfoArr1[1];
			var OrdDate=PrescInfoArr1[2],OrdTime=PrescInfoArr1[3];
			if((PoisonClass!='J1')&&(PoisonClass!='J2')&&(PoisonClass!='DX')&&(PoisonClass!='MZ'))PoisonClass="";
			if ((PoisonClass=='DX')||(PoisonClass=='MZ')||(PoisonClass=='J1'))PoisonClass='[麻 精一]';
			if (PoisonClass=='J2')PoisonClass='[精二]';
			var MyPara='^Sum'+String.fromCharCode(2)+Sum+'元';
			MyPara=MyPara+'^OrdDate'+String.fromCharCode(2)+OrdDate;
			MyPara=MyPara+'^OrdTime'+String.fromCharCode(2)+OrdTime;
			MyPara=MyPara+'^PoisonClass'+String.fromCharCode(2)+PoisonClass;
			MyPara=MyPara+'^BilledTxt'+String.fromCharCode(2)+BilledTxt;
			MyPara=MyPara+'^PrescNo'+String.fromCharCode(2)+PrescNo;
			MyPara=MyPara+'^RecLoc'+String.fromCharCode(2)+ReclocDesc;
			//MyPara=MyPara+'^PrescType'+String.fromCharCode(2)+PrescType;
			MyPara=MyPara+'^BillType'+String.fromCharCode(2)+"["+BillType+"]";
			MyPara=MyPara+'^PrescSerialNo'+String.fromCharCode(2)+"*"+PrescNo+"*";
			/*if ((PoisonClass=='[麻 精一]')){
				DHCP_GetXMLConfig('XMLObject','YKYZLYYPrescriptPrintDM');
				var AgentInfo=tkMakeServerCall("web.TRYYDocCommon","GetAgentInfo",PatientID,EpisodeID);
				if(AgentInfo!=""){
					var AgentArr=AgentInfo.split("^");
					MyPara=MyPara+'^Agent'+String.fromCharCode(2)+AgentArr[0];
					MyPara=MyPara+'^AgentIDNo'+String.fromCharCode(2)+AgentArr[1];
				}
			}else{
				DHCP_GetXMLConfig('XMLObject','YKYZLYYPrescriptPrint');
			}*/
			//改为与处方预览统一模板
			//对于毒麻处方，取代办人信息从新的方法获取。
			var PrescSupplyInfo=tkMakeServerCall("web.DHCDocCheckPoison","GetAgencyInfoByPrescNo",PrescNo,PatientID)
			if ((PrescSupplyInfo!="")&&(PoisonClass=='[麻 精一]')){
				var PrescSupplyInfoArr=PrescSupplyInfo.split("^");
				var PAPMIAgencyName=PrescSupplyInfoArr[1];
				var PAPMIAgencyCredNo=PrescSupplyInfoArr[0];
				var PAPMIAgencyTel=PrescSupplyInfoArr[2];
				var PerSupply="代办人姓名:"+PAPMIAgencyName;
				var MyPara=MyPara+"^"+"SupplyName"+String.fromCharCode(2)+PerSupply;
				var PerSupplyCrad="代办人身份证号:"+PAPMIAgencyCredNo;
				var MyPara=MyPara+"^"+"SupplyCard"+String.fromCharCode(2)+PerSupplyCrad;
			}
			
			var PrescInfoArr2=PrescInfoArr[1].split(String.fromCharCode(2));
			/*for (var i=0;i<PrescInfoArr2.length;i++){
				if(PrescInfoArr2[i].length>60){
					var PrescInfoArr3=PrescInfoArr2[i].split("X");
					if (MyList=="") {
						MyList=PrescInfoArr3[0];
						//MyList= MyList+String.fromCharCode(2)+PrescInfoArr3[1];
					}else{
						MyList=MyList+String.fromCharCode(2)+PrescInfoArr3[0];
						//MyList=MyList+String.fromCharCode(2)+PrescInfoArr3[1];
					}
				}else{
					if (MyList=="") {
						MyList=PrescInfoArr2[i];
					}else{
						MyList=MyList+String.fromCharCode(2)+PrescInfoArr2[i];
					}
				}
			}*/
			var ReportData=tkMakeServerCall("web.DHCDocPrescript","GetPrescInfoByOrd",PrescNo)
			var tmparr = ReportData.split("!!")
			var medinfo = tmparr[1]
	        var medarr = medinfo.split("@")
	        var mlength = medarr.length
	         for (h = 0; h < mlength; h++) {
		         var medrow = medarr[h]
	            var rowarr = medrow.split("^")
	            var OrderName = rowarr[0]
	            var PackQty = rowarr[1] + rowarr[2]
	            var DoseQty = rowarr[3]
	            var Inst = rowarr[4]
	            var Freq = rowarr[5]
	            var Lc = rowarr[6]
	            var totalprice = rowarr[8]
	            var Ordremark = rowarr[10]
	            var Testflag = rowarr[9]
	            var Seqno = rowarr[11]

	            if (Testflag != "") {
	                Seqno = Seqno + String.fromCharCode(9650)
	            }
	            if (Ordremark.length > 10) {
	                Ordremark = Ordremark.substr(0, 10) + "...";
	            }

	            var OrderName = Seqno + " " + OrderName
				///项目要求在备注存在用法：的时候使用备注覆盖单次计量
	            var firstdesc = OrderName + ' X ' + PackQty
         
	            var inststring = "   			用法:每次" + DoseQty + "     " + Freq + "     " + Inst + "     " + Ordremark

	            var firstdesc = firstdesc + String.fromCharCode(2) + inststring

	            if (MyList == '') {
	                MyList=firstdesc;
	            } else {
	                //MyList.push(firstdesc);
	                MyList=MyList+String.fromCharCode(2)+firstdesc;
	            }
		     }
			//alert(MyList)
			//return;
			MyPara=PatientInfo+PatMradmInfo+MyPara;
			/*for (var i=1;i<=PrintCount;i++){
				if (i==1) var zf="[正方]";
				if (i==2) var zf="[底方]";
				var MyPara1=MyPara+'^zf'+String.fromCharCode(2)+zf;
				//alert(MyPara1)
				PrintFun(myobj,MyPara1,MyList);
			}*/
			if (flag1=="Y") {
				var zf="[正方]";
				var MyPara1=MyPara+'^ZDF'+String.fromCharCode(2)+zf;
				PrintFun(myobj,MyPara1,MyList);
			}
			if (flag2=="Y") {
				var zf="[底方]";
				var MyPara1=MyPara+'^ZDF'+String.fromCharCode(2)+zf;
				PrintFun(myobj,MyPara1,MyList);
			}
		}
	}
	function PrintFun(PObj,inpara,inlist){
		////DHCPrtComm.js
		try{
			var mystr='';
			for (var i= 0; i<PrtAryData.length;i++){
				mystr=mystr + PrtAryData[i];
			}
			inpara=DHCP_TextEncoder(inpara)
			inlist=DHCP_TextEncoder(inlist)
			var docobj=new ActiveXObject('MSXML2.DOMDocument.4.0');
			docobj.async = false;    //close
			var rtn=docobj.loadXML(mystr);
			if ((rtn)){
				////ToPrintDoc(ByVal inputdata As String, ByVal ListData As String, InDoc As MSXML2.DOMDocument40)			
				var rtn=PObj.ToPrintDocNew(inpara,inlist,docobj);
				////var rtn=PObj.ToPrintDoc(myinstr,myList,docobj);
				return websys_cancel();
			}
		}catch(e){
			var dt=new Date();
			var PrintDate=dt.getFullYear()+"-"+(dt.getMonth()+1)+"-"+dt.getDate();
			var PrintTime=dt.getHours()+":"+dt.getMinutes()+":"+dt.getSeconds();
			var ErrInfo=PrintDate+" "+PrintTime+" "+"错误编号："+e.number+"/  "+"错误名称："+e.name;
			var ErrInfo=ErrInfo+"/  "+"错误消息："+e.message+"/  "+"PrintError！！！";
			writeFile(ErrInfo);
			//alert(e.meaasge);
		}
	}
	obj.printButton_onclick = function(){
		//try{
		//卡消费调用计费接口,此处待做配置，当ConsumeFlag=1是进行卡消费操作，暂时写死
		var ConsumeFlag=0;
		if(ConsumeFlag==1){
			var consumeobj=Ext.getCmp("consume");
			if(consumeobj.checked){
				//alert(consumeobj.checked);
				var flag=CardBillClick();
				//alert(flag)
				/*if(flag!=0){
					alert("消费失败！")
				}*/
			}
		}
		var strSelectedOrder="",strSelectedArcim="";
		var selections = obj.gridCheckboxSelectionModel.getSelections();
		var len = selections.length;
		if(len == 0){
			Ext.Msg.alert("提示","请选相应医嘱,进行打印操作!")
			return;
			//Ext.Msg.alert("提示","未选中任何医嘱!");
			//alert("未选中任何医嘱!请确认后重试！");
		}else{
			for(var i = 0;i<len;i++){
				var record = selections[i];
				var OrderItemRowid=record.get("OrderItemRowid");
				if(strSelectedOrder=="") {strSelectedOrder=OrderItemRowid;}
				else {strSelectedOrder=strSelectedOrder+"^"+OrderItemRowid; }
				var ARCIMRowId=record.get("ARCIMRowId");
				if(strSelectedArcim=="") {strSelectedArcim=ARCIMRowId;}
				else {strSelectedArcim=strSelectedArcim+"^"+ARCIMRowId; }
			}
		}
	
		
		/*var recipeobj=Ext.getCmp("recipe");		
		if(recipeobj.checked){
			//打印处方
			/*var selections = obj.gridCheckboxSelectionModel.getSelections();
			var len = selections.length;
			for(var i = 0;i<len;i++){
				var record = selections[i];
				var OrderPrescNo=record.get("OrderPrescNo");
				var printFlag=record.get("printFlag");
				if(OrderPrescNo!=""&&(printFlag="Y")){
					alert("重打处方注意回收处方！")
				}
				
			}
			DHCP_GetXMLConfig('XMLObject','YKYZLYYPrescriptPrint');
			PatientPrescPrint(PatientID,EpisodeID,MRADMID,strSelectedOrder);
		}*/
		var frontFlagobj=Ext.getCmp("frontFlag");		
		if(frontFlagobj.checked){
			//打印处方正方
			//DHCP_GetXMLConfig("XMLObject","YKYZLYYPrescriptPrint");
			DHCP_GetXMLConfig("XMLObject","DHCOutPrescXYPrt");
			var FrontFlag="Y"
			var BackFlag="N"
			PatientPrescPrint(PatientID,EpisodeID,MRADMID,strSelectedOrder,FrontFlag,BackFlag);
		}
		var backFlagobj=Ext.getCmp("backFlag");		
		if(backFlagobj.checked){
			//打印处方底方
			var FrontFlag="N"
			var BackFlag="Y"
			//DHCP_GetXMLConfig("XMLObject","YKYZLYYPrescriptPrint");
			DHCP_GetXMLConfig("XMLObject","DHCOutPrescXYPrt");
			PatientPrescPrint(PatientID,EpisodeID,MRADMID,strSelectedOrder,FrontFlag,BackFlag);
		}
	
		var guideobj=Ext.getCmp("guide");
		if(guideobj.checked){
			//打印导诊单VB
			/*var GetPatientInfo=tkMakeServerCall("web.DHCDocOrderEntry","GetPatientByRowid",PatientID);
			var PatientInfoArr=GetPatientInfo.split("^");
			var PatientNo=PatientInfoArr[1],PatientName=PatientInfoArr[2];
	 		var PatientSex=PatientInfoArr[3],PatientAge=PatientInfoArr[4];
	 		var Pattype=PatientInfoArr[6],CardNo=PatientInfoArr[30];
			var PatAdmInfo=PatientNo+"^"+CardNo+"^"+PatientName+"^"+PatientAge+"^"+PatientSex+"^"+Pattype;
			var GetAdmInfo=tkMakeServerCall("web.UDHCPrescript","GetPatInform",EpisodeID);
			var AdmInfoArr=GetAdmInfo.split("^");
			var AdmDep=AdmInfoArr[2],AdmDate=AdmInfoArr[3];
			var PatAdmInfo=PatAdmInfo+"^"+AdmDep+"^"+AdmDate;
			var MradmInfo=tkMakeServerCall("web.DHCMRDiagnos","GetMRDiagnosDesc",MRADMID,";");
			var PatAdmInfo=PatAdmInfo+"^"+MradmInfo;
			//alert(PatAdmInfo)
			var ret=tkMakeServerCall("web.UDHCPrescript","GetOrdItemInfo",strSelectedOrder);
			//alert("ret+"+ret)
			if (ret!=""){
				ret=PatAdmInfo+String.fromCharCode(1)+ret;
				var printobj=parent.frames[1].document.getElementById("PrintOrderDirect");
				if(printobj)printobj.PrintOrdDirect(ret,"","");
			}*/
			////////////XML
			var MyPara="",MyList="",MyListStr="";
			///var PrintLine="_______________________________________________________________________________________";
			var PrintLine="---------------------------------------------------------------------------------------";
			DHCP_GetXMLConfig('XMLObject','DHCDOCOrderDirectPrint');
			//DHCP_GetXMLConfig('XMLObject','DHCDocGuidePatDocuments');
			//获取病人的基本信息
			var PatientInfo=GetPatientBaseInfo(PatientID,EpisodeID,"门急诊项目指引单");
			//获取病人本次就诊的诊断信息
			var MradmInfo=tkMakeServerCall("web.DHCMRDiagnos","GetMRDiagnosDesc",MRADMID,";");
			var MradmInfoArry=MradmInfo.split(" ");
			MyPara=PatientInfo+'^Diagnose'+String.fromCharCode(2)+MradmInfo;
		
			var retOrdItemInfo=tkMakeServerCall("web.UDHCPrescript","GetOrdItemInfo",EpisodeID,strSelectedOrder);
			//alert("ret+"+retOrdItemInfo)
			var OrdItemArr=retOrdItemInfo.split(String.fromCharCode(1));
			for (var i=0;i<OrdItemArr.length;i++){
				var OrdItemArr1=OrdItemArr[i].split(String.fromCharCode(2));
				if (MyListStr==""){
					MyListStr=OrdItemArr1[0];     //+PrintLine;
					//MyListStr=MyListStr+String.fromCharCode(2)+PrintLine;
				}else{
					MyListStr=MyListStr+String.fromCharCode(2)+OrdItemArr1[0];   //+PrintLine;
					//MyListStr=MyListStr+String.fromCharCode(2)+PrintLine;
				}
				var OrdItemArr2=OrdItemArr1[1].split(String.fromCharCode(3));
				for (var j=0;j<OrdItemArr2.length;j++){
					MyListStr=MyListStr+String.fromCharCode(2)+OrdItemArr2[j];					
				}
				if(OrdItemArr.length-1>i)MyListStr=MyListStr+String.fromCharCode(2)+PrintLine;
			}
			//alert(MyListStr)
			var PrintPage=0;  //打印页码
			var myobj=document.getElementById('ClsBillPrint');
			var MyListArr=MyListStr.split(String.fromCharCode(2));
			var PageTotal=Math.ceil(MyListArr.length/15);
			for (var j=1;j<=MyListArr.length;j++){
				if(MyList==""){MyList=MyListArr[j-1];}
				else{MyList=MyList+String.fromCharCode(2)+MyListArr[j-1];}
				if ((j>1)&&(j%15==0)) {
					PrintPage=PrintPage+1;
					var PrintPageText="第 "+PrintPage+" 页  共 "+PageTotal+" 页"
					var MyPara1=MyPara+'^PrintPage'+String.fromCharCode(2)+PrintPageText;
					PrintFun(myobj,MyPara1,MyList);
					MyList="";
				}
			}	
			if((MyListArr.length%15)>0){
				var PrintPageText="第 "+PageTotal+" 页  共 "+PageTotal+" 页"
				var MyPara1=MyPara+'^PrintPage'+String.fromCharCode(2)+PrintPageText;
				PrintFun(myobj,MyPara1,MyList);
			}
		}
	
		var orderobj=Ext.getCmp("order");
		if(orderobj.checked){
			//打印医嘱单
			DHCP_GetXMLConfig('XMLObject','DHCDocOrderListPrint');
			//获取病人的基本信息
			var PatientInfo=GetPatientBaseInfo(PatientID,EpisodeID,"门急诊医嘱单");
			//获取病人本次就诊的诊断信息
			var MradmInfo=tkMakeServerCall("web.DHCMRDiagnos","GetMRDiagnosDesc",MRADMID,";");
			var MradmInfoArry=MradmInfo.split(" ");
			var MyPara=PatientInfo+'^Diagnose'+String.fromCharCode(2)+MradmInfo;
			var dt=new Date();
			var PrintDate=dt.getFullYear()+"-"+(dt.getMonth()+1)+"-"+dt.getDate();
			var PrintTime=dt.getHours()+":"+dt.getMinutes()+":"+dt.getSeconds();
			var MyOtherPara="                                医生签名:";
			var MyOtherPara=MyOtherPara+String.fromCharCode(2)+"                                打印时间："+PrintDate+"  "+PrintTime
			//alert(MyPara)
			var ROrderList="",OrderList="",MyList="",MyListStr="";			
			var rows=Ext.getCmp('gridResult').getSelectionModel().getSelections(); //获取所有选中行，
			if(rows.length==0)return;
			for(var i=0;i <rows.length;i++){//alert(rows[i].get("OrderType"))
				var OrderType=rows[i].get("OrderType");
				var ARCIMRowId=rows[i].get("ARCIMRowId");
				if (OrderType=="R"){	
					var GenericName=tkMakeServerCall("web.UDHCJFCOMMON","GetDrugCommonNameByArcimId",ARCIMRowId);
					myOrderName=rows[i].get("OrderName");
					myOrderNameArr2=tkMakeServerCall("web.DHCDocOrderCommon","Getspec",ARCIMRowId);
				
					if (rows[i].get("OEORIOEORIDR")!="") GenericName="   "+GenericName;
					if (ROrderList==""){
						ROrderList=GenericName;   //rows[i].get("OrderName");
						ROrderList=ROrderList+String.fromCharCode(32)+rows[i].get("OrderDoseQty");
						ROrderList=ROrderList+rows[i].get("OrderDoseUOM");
						ROrderList=ROrderList+String.fromCharCode(32)+rows[i].get("PHFreqDesc");
						if(rows[i].get("PHFreqDesc")!="即刻"){
							ROrderList=ROrderList+String.fromCharCode(32)+rows[i].get("OrderDur");
						}
						ROrderList=ROrderList+String.fromCharCode(32)+rows[i].get("OrderInstr");
						ROrderList=ROrderList+String.fromCharCode(32)+"发药数:";
						ROrderList=ROrderList+myOrderNameArr2+"*"+rows[i].get("OrderPackQty")+rows[i].get("OrderPackUOM");	
						ROrderList=ROrderList+String.fromCharCode(32)+rows[i].get("OrdDepProcNotes");
					
					}else{
						ROrderList=ROrderList +String.fromCharCode(2)+ GenericName;   //rows[i].get("OrderName");
						ROrderList=ROrderList+String.fromCharCode(32)+rows[i].get("OrderDoseQty");
						ROrderList=ROrderList+rows[i].get("OrderDoseUOM");
						ROrderList=ROrderList+String.fromCharCode(32)+rows[i].get("PHFreqDesc");
						if(rows[i].get("PHFreqDesc")!="即刻"){
							ROrderList=ROrderList+String.fromCharCode(32)+rows[i].get("OrderDur");
						}
						ROrderList=ROrderList+String.fromCharCode(32)+rows[i].get("OrderInstr");
						//ROrderList=ROrderList +String.fromCharCode(2)+ GenericName + String.fromCharCode(32)+rows[i].get("PHFreqDesc")+String.fromCharCode(32)+rows[i].get("OrderDur")+String.fromCharCode(32)+rows[i].get("OrderInstr");
						ROrderList=ROrderList+String.fromCharCode(32)+ "发药数:"+ myOrderNameArr2+"*"+rows[i].get("OrderPackQty")+rows[i].get("OrderPackUOM")
						ROrderList=ROrderList+String.fromCharCode(32)+rows[i].get("OrdDepProcNotes");
					}					
				}else{
					var categoryflag=tkMakeServerCall("web.DHCDocQryOEOrder","GetOrderCategory",ARCIMRowId);
					//alert(categoryflag)
					if(categoryflag=="1"){}
					else{
						if (OrderList==""){
							OrderList=rows[i].get("OrderName");
						}else{
							OrderList=OrderList +String.fromCharCode(2)+ rows[i].get("OrderName");
						}
					}
				}
				
			}
			if((OrderList=="")&&(ROrderList==""))return;
			if(OrderList==""){
				if(ROrderList!=""){MyListStr=ROrderList+String.fromCharCode(2)+" "+String.fromCharCode(2)+MyOtherPara;}
			}else{
				if(ROrderList==""){MyListStr=OrderList+String.fromCharCode(2)+" "+String.fromCharCode(2)+MyOtherPara;}
				else{MyListStr=ROrderList+String.fromCharCode(2)+OrderList+String.fromCharCode(2)+" "+String.fromCharCode(2)+MyOtherPara;}
			}		
			//alert(MyListStr)
			var myobj=document.getElementById('ClsBillPrint');
			var MyListArr=MyListStr.split(String.fromCharCode(2));
			for (var j=1;j<=MyListArr.length;j++){
				if(MyList==""){MyList=MyListArr[j-1];}
				else{MyList=MyList+String.fromCharCode(2)+MyListArr[j-1];}
				if ((j>1)&&(j%18==0)) {
					PrintFun(myobj,MyPara,MyList);
					MyList="";
				}
			}	
			if((MyListArr.length%18)>0)PrintFun(myobj,MyPara,MyList);
		}
	
		/*var applyobj=Ext.getCmp("apply");
		if(applyobj.checked){
			//var ItemServiceFlag=cspRunServerMethod(GetItemServiceFlagMethod,strSelectedArcim);
			//alert(strSelectedArcim)
			//if (ItemServiceFlag=="1"){
				//var lnk="dhcrisappbill.csp?a=a&EpisodeID="+EpisodeID+"&mradm="+MRADMID+"&PatientID="+PatientID;
				//var SessionFieldName="RisAppBillURL"+EpisodeID;
				//websys_createWindow(lnk,"dhcrisappbill","status=1,scrollbars=1,top=50,left=10,width=1000,height=630");
				SelectedOrderArr=strSelectedOrder.split("^");
				strSelectedArcimArr=strSelectedArcim.split("^");
				//alert(strSelectedArcimArr+"___"+SelectedOrderArr)
				for(var i=0;i<strSelectedArcimArr.length;i++){
					//alert(strSelectedArcimArr[i])
					var ItemServiceFlag=cspRunServerMethod(GetItemServiceFlagMethod,strSelectedArcimArr[i]);
					//alert(ItemServiceFlag)
					if(ItemServiceFlag==1){
						PrintAppBill(SelectedOrderArr[i]);
					}
			
			    }
	
		}*/
		var rtn=tkMakeServerCall("web.UDHCPrescript","SetOrdItemPrintFlag",strSelectedOrder);
		if(rtn==0){
			obj.winPrtClickInfo.close();
		}
		/*}catch(e){
			var dt=new Date();
			var PrintDate=dt.getFullYear()+"-"+(dt.getMonth()+1)+"-"+dt.getDate();
			var PrintTime=dt.getHours()+":"+dt.getMinutes()+":"+dt.getSeconds();
			var ErrInfo=PrintDate+" "+PrintTime+" "+"错误编号："+e.number+"/  "+"错误名称："+e.name;
			var ErrInfo=ErrInfo+"/  "+"错误消息："+e.message+"/  "+"ClickError！！！";
			writeFile(ErrInfo);
			//alert(e.message);
			//return ;	
		//}*/
		
	}
	
	
	function PrintAppBill(SelectedOrdItemRowid){
		if (SelectedOrdItemRowid!=""){
		    var Temp = GetPrintTemp(SelectedOrdItemRowid);
		    //alert(Temp)
			//var GetPrintAppContentFunction=document.getElementById("GetPrintAppContent").value;
			var PrintContent=tkMakeServerCall("web.DHCRisCommFunctionEx","GetPrintAppBillContent",SelectedOrdItemRowid);
	  		//alert(PrintContent)
	  		//return;
	  		InvPrintNew(PrintContent,"");
		}else{
			alert("请选择医嘱");
		}
	
	}

	function GetPrintTemp(OEorditemID) {
	  	var value=tkMakeServerCall("web.DHCRisApplicationBill","GetAppShape",OEorditemID);
	  	var Item=value.split("^");
	   	if (Item[1]!=""){
		   gPrintTemp=Item[1];
		   //alert("gPrintTemp+"+gPrintTemp)
		   gHtmlTemp=Item[3]; 
		   //var myobj=parent.frames[1].document.getElementById("InvPrintEncrypt");  
	  	   DHCP_GetXMLConfig("InvPrintEncrypt",gPrintTemp);
	  	}
 
	 }
	function InvPrintNew(TxtInfo,ListInfo)
	 {
		var myobj=document.getElementById('ClsBillPrint');
	 	DHCP_PrintFun(myobj,TxtInfo,ListInfo);	//call xml print from zhaochangzhong
	 } 

	function getSelectedOrder(){
		var selections = obj.gridCheckboxSelectionModel.getSelections();
		var len = selections.length;
		if(len == 0){
			return;
			}else{
				for(var i = 0;i<len;i++){
					var record = selections[i];
					var OrderName=record.get("OrderName");
					var OrderDoseQty=record.get("OrderDoseQty");
					var OrderDoseUOM=record.get("OrderDoseUOM");
					var OrderFreq=record.get("OrderFreq");
					var OrderInstr=record.get("OrderInstr");
					var OrderDur=record.get("OrderDur");
					var OrderDoseQty=record.get("OrderDoseQty");
					var strSelectedOrder=OrderName+" "+OrderDoseQty+" "+OrderDoseUOM+" "+OrderFreq+" "+OrderInstr
								+" "+OrderDur+" "+OrderDoseQty
				}
			return strSelectedOrder;
		}
	} 
	function writeFile(filecontent){ 
		var fso, f, s ; 
		var filename="C://一键打印错误消息日志.txt"
		fso = new ActiveXObject("Scripting.FileSystemObject"); 
		f = fso.OpenTextFile(filename,8,true); 
		f.WriteLine(filecontent); 
		f.Close();
	} 
	
	
}
