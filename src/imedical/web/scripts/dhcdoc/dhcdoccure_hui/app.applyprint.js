var app_applyPrint=(function(){
	//Excel打印方法
	function Excel_PrintCureApply(DCARowId,PrintData)
	{	
		//var DCARowId=ServerObj.DCARowId;
		if (DCARowId==""){
			$.messager.alert("提示","请选择需要打印的申请单据")
			return false
		}
		var getpath=tkMakeServerCall("web.UDHCJFCOMMON","getpath")
		var Template=getpath+"DHCDocCureApplyPrt.xls";
		var xlApp,xlsheet,xlBook
	 
		//左右边距
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.PageSetup.LeftMargin=0;  //lgl+
	    xlsheet.PageSetup.RightMargin=0;
	 
		
		var xlsrow=2; //用来指定模板的开始行数位置
		var xlsCurcol=1;  //用来指定开始的列数位置
		
		
		var RtnStr=PrintData; //tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetCureApply",DCARowId)
		var RtnStrArry=RtnStr.split(String.fromCharCode(1));
		var PatientArr=RtnStrArry[0].split("^"); //患者基本信息
		var CureApplyArr=RtnStrArry[1].split("^"); //预约单信息
		var CureApplyOtherArr=RtnStrArry[2].split("^"); //预约单其他医嘱信息
		
		var PatID=PatientArr[0]
		var PatNo=PatientArr[1];
		var PatName=PatientArr[2];
		var PatSex=PatientArr[3];
		var PatAge=PatientArr[4];
		var PatType=PatientArr[6];
		var PatTel=PatientArr[24];
		var PatAddress=PatientArr[10];
		
		var ArcimDesc=CureApplyArr[0]
		var AppOrderQty=CureApplyArr[2]
		var AppOrderUom=CureApplyArr[3]
		AppOrderQty=AppOrderQty+AppOrderUom;
		var RelocID=CureApplyArr[5]
		var AppReloc=CureApplyArr[4]
		var ApplyStatus=CureApplyArr[6]
		var ApplyUser=CureApplyArr[7]
		var ApplyDate=CureApplyArr[8]
		var ApplyRemarks=CureApplyArr[13]
		var ApplyPlan=CureApplyArr[14]
		var AdmID=CureApplyArr[15]
		var Price=CureApplyArr[16]
		var UnitPrice=CureApplyArr[18]	
		var AppLoc=CureApplyArr[25]
		var DocCurNO=CureApplyArr[30];	
		var InsertDate=CureApplyArr[27];
		var Hospital=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetHospitalDesc",session['LOGON.HOSPID'])
		var Title=Hospital+"治疗申请单";
		
		var OrderDoseQty=CureApplyOtherArr[0];
		var OrderDoseUnitID=CureApplyOtherArr[1];
		var OrderDoseUnit=CureApplyOtherArr[2];
		var PriorityDR=CureApplyOtherArr[3];
		var PriorityDesc=CureApplyOtherArr[4];
		var PHFreqDr=CureApplyOtherArr[5];
		var PHFreqDesc1=CureApplyOtherArr[6];
		var instrDr=CureApplyOtherArr[7];
		var instrDesc1=CureApplyOtherArr[8];
		var DuratDR=CureApplyOtherArr[9];
		var DuratDesc=CureApplyOtherArr[10];
		var StDate=CureApplyOtherArr[11];
		var FirstDayTimes=CureApplyOtherArr[12];
		
		xlsheet.cells(1,2)=Title;
		xlsheet.cells(xlsrow,xlsCurcol+8)=DocCurNO
		xlsrow=xlsrow+1
		xlsheet.cells(xlsrow,xlsCurcol+2)=PatName
		xlsheet.cells(xlsrow,xlsCurcol+4)=PatSex
		xlsheet.cells(xlsrow,xlsCurcol+6)=PatTel
		xlsheet.cells(xlsrow,xlsCurcol+8)=PatNo
		xlsrow=xlsrow+1
		xlsheet.cells(xlsrow,xlsCurcol+2)=PatAddress
		xlsrow=xlsrow+1
		xlsheet.cells(xlsrow,xlsCurcol+6)=AppLoc
		xlsheet.cells(xlsrow,xlsCurcol+2)=ApplyUser
		xlsrow=xlsrow+1
		xlsheet.cells(xlsrow,xlsCurcol+2)=PriorityDesc
		xlsheet.cells(xlsrow,xlsCurcol+4)=OrderDoseQty+""+OrderDoseUnit
		xlsheet.cells(xlsrow,xlsCurcol+6)=PHFreqDesc1
		xlsheet.cells(xlsrow,xlsCurcol+8)=DuratDesc
		xlsrow=xlsrow+1
		xlsheet.cells(xlsrow,xlsCurcol+2)=AppOrderQty
		xlsrow=xlsrow+1
		xlsheet.cells(xlsrow,xlsCurcol+2)=AppReloc
		xlsheet.cells(xlsrow,xlsCurcol+6)=ApplyDate
		xlsrow=xlsrow+1
		xlsheet.cells(xlsrow,xlsCurcol+2)=ArcimDesc
		xlsrow=xlsrow+1
		xlsheet.cells(xlsrow,xlsCurcol+2)=ApplyPlan
		xlsrow=xlsrow+1
		xlsheet.cells(xlsrow,xlsCurcol+2)=ApplyRemarks
		xlsrow=xlsrow+1
		xlsheet.cells(xlsrow,xlsCurcol+2)=ApplyUser
		xlsheet.cells(xlsrow,xlsCurcol+6)=InsertDate

		
	    xlBook.PrintOut()
	    xlBook.Close (savechanges=false);
	    xlApp.Quit();
		xlApp=null;
		xlsheet=null;
	}

	//在excel表格中画线的方法。
	function gridlist(objSheet,row1,row2,c1,c2)
	{
		objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
		objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
		objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
		objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
	}
	///xml打印方法
	function XML_PrintCureApply(DCARowId,PrintData)
	{
	    //var DCARowId=ServerObj.DCARowId;
		if (DCARowId==""){
			$.messager.alert("提示","请选择需要打印的申请单据")
			return false
		}
		DHCP_GetXMLConfig("InvPrintEncrypt","DHCDocCureApplyNew");
		var ApplyOtherInfo=$.cm({
			ClassName:"DHCDoc.DHCDocCure.Apply",
			MethodName:"GetApplyPrintInfo",
			dataType:"text",
			'DCARowId':DCARowId,
			'HosID':session['LOGON.HOSPID']
		},false)
		var JsonObj=eval ("(" + ApplyOtherInfo + ")");
		debugger
		var Hospital=JsonObj.Hospital;
		var BodySetJson=JsonObj.BodySetJson;
		
		var Title=Hospital;
		var RtnStr=PrintData;
		var RtnStrArry=RtnStr.split(String.fromCharCode(1));
		var PatientArr=RtnStrArry[0].split("^"); //患者基本信息
		var CureApplyArr=RtnStrArry[1].split("^"); //预约单信息
		var CureApplyOtherArr=RtnStrArry[2].split("^"); //预约单其他医嘱信息
		
		var PatID=PatientArr[0]
		var PatNo=PatientArr[1];
		var PatName=PatientArr[2];
		var PatSex=PatientArr[3];
		var PatAge=PatientArr[4];
		var PatType=PatientArr[6];
		var PatTel=PatientArr[24];
		var PatAddress=PatientArr[10];
		
		var ArcimDesc=CureApplyArr[0]
		var AppOrderQty=CureApplyArr[2]
		var AppOrderUom=CureApplyArr[3]
		AppOrderQty=AppOrderQty+AppOrderUom;
		var RelocID=CureApplyArr[5]
		var AppReloc=CureApplyArr[4]
		var ApplyStatus=CureApplyArr[6]
		var ApplyUser=CureApplyArr[7]
		var ApplyDate=CureApplyArr[8]
		var ApplyRemarks=CureApplyArr[13]
		var ApplyPlan=CureApplyArr[14]
		var AdmID=CureApplyArr[15]
		var Price=CureApplyArr[16]
		var UnitPrice=CureApplyArr[18]	
		var AppLoc=CureApplyArr[25]
		var DocCurNO=CureApplyArr[30];	
		var InsertDate=CureApplyArr[27];
		
		var OrderDoseQty=CureApplyOtherArr[0];
		var OrderDoseUnitID=CureApplyOtherArr[1];
		var OrderDoseUnit=CureApplyOtherArr[2];
		var PriorityDR=CureApplyOtherArr[3];
		var PriorityDesc=CureApplyOtherArr[4];
		var PHFreqDr=CureApplyOtherArr[5];
		var PHFreqDesc1=CureApplyOtherArr[6];
		var instrDr=CureApplyOtherArr[7];
		var instrDesc1=CureApplyOtherArr[8];
		var DuratDR=CureApplyOtherArr[9];
		var DuratDesc=CureApplyOtherArr[10];
		var StDate=CureApplyOtherArr[11];
		var FirstDayTimes=CureApplyOtherArr[12];
		var LnkLine="         ______________________________________________________________"
		ApplyPlan="治疗方案:  "+ApplyPlan
		ApplyPlan=formatString(ApplyPlan)
		ApplyPlan=ApplyPlan+String.fromCharCode(10)+LnkLine;
		ApplyRemarks="    备注:  "+ApplyRemarks
		ApplyRemarks=formatString(ApplyRemarks)
		ApplyRemarks=ApplyRemarks+String.fromCharCode(10)+LnkLine;
		ApplyPlan=ApplyPlan+String.fromCharCode(10)+ApplyRemarks;
		
		var PDlime=String.fromCharCode(2);
	    var MyPara="HospName"+PDlime+Title;
	    	MyPara=MyPara+"^"+"PatName"+PDlime+PatName;
	    	MyPara=MyPara+"^"+"PatSex"+PDlime+PatSex;
	    	MyPara=MyPara+"^"+"PatPhone"+PDlime+PatTel;
	    	MyPara=MyPara+"^"+"PatRegNo"+PDlime+PatNo;
	    	MyPara=MyPara+"^"+"PatAdress"+PDlime+PatAddress;
	    	MyPara=MyPara+"^"+"ApplyUser"+PDlime+ApplyUser;
	    	MyPara=MyPara+"^"+"ApplyDept"+PDlime+AppReloc;
	    	MyPara=MyPara+"^"+"OrderPrior"+PDlime+PriorityDesc;
	    	MyPara=MyPara+"^"+"DoseQty"+PDlime+OrderDoseQty+OrderDoseUnit;
	    	MyPara=MyPara+"^"+"Freq"+PDlime+PHFreqDesc1;
	    	MyPara=MyPara+"^"+"Duration"+PDlime+DuratDesc;
	    	MyPara=MyPara+"^"+"Qty"+PDlime+AppOrderQty;
	    	MyPara=MyPara+"^"+"CureRecloc"+PDlime+AppReloc;
	    	MyPara=MyPara+"^"+"SttDate"+PDlime+StDate;
	    	MyPara=MyPara+"^"+"CureItem"+PDlime+ArcimDesc;
	    	MyPara=MyPara+"^"+"ApplyPlan"+PDlime+ApplyPlan;
	    	MyPara=MyPara+"^"+"Notes"+PDlime+ApplyRemarks;
	    	MyPara=MyPara+"^"+"DocCureNO"+PDlime+DocCurNO;
	    DHC_PrintByLodop(getLodop(),MyPara,"","","");
	    //var myobj=document.getElementById("ClsBillPrint");
		//DHCP_PrintFunNew(myobj,MyPara,"");
		
		//打印部位图信息
		if(BodySetJson!=""){
			var BodySetJsonObj=eval ("(" + BodySetJson + ")");
			var BodyImageData=BodySetJsonObj.BodyImage;
			var BodySetStr=BodySetJsonObj.BodySetStr;
			if(BodyImageData!=""){
				DHCP_GetXMLConfig("InvPrintEncrypt","DHCDocCureApplyBody");
				var TitleList="部位序号^部位描述^部位备注";
				var MyList=TitleList;
				var MyListLen=0;
				if(BodySetStr!=""){
					var BodySetArr=BodySetStr.split("###");
					var chklen=20;
					for(var i=0;i<BodySetArr.length;i++){
						var aBodySetArr=BodySetArr[i].split("$$$");
						var BodyImageDesc=aBodySetArr[0]; //图片正面 Or 反面
						var ID=aBodySetArr[1]; //部位序号
						var BodyImageId=aBodySetArr[2];
						var BodyPointDesc=aBodySetArr[3]; //部位描述
						var BodyPointDemo=aBodySetArr[4]; //部位备注
						var DemoLen=BodyPointDemo.length;
						var oneList="";
						var loop=Math.ceil(DemoLen/chklen);
						for(var j=0;j<loop;j++){
							var str=BodyPointDemo.slice(j*chklen,j*chklen+chklen)
							if(j==0){
								oneList=ID+"^"+BodyPointDesc+"^"+str;
							}else{
								oneList=oneList+String.fromCharCode(2)+""+"^"+""+"^"+str;
							}
							MyListLen++;
						}
			
						if(MyList==""){
							MyList=oneList;
						}else{
							MyList=MyList+String.fromCharCode(2)+oneList;
						}
					}	
				}
				var MyPara="BodyImage"+PDlime+BodyImageData;
			    var loop=Math.ceil(MyListLen/25);
			    var MyListArr=MyList.split(String.fromCharCode(2));
				for(var k=0;k<loop;k++){
					var PartMyListArr=MyListArr.slice(k*25,(k+1)*25);
					var PartMyList=PartMyListArr.join(String.fromCharCode(2));
					if(k>0){
						PartMyList=TitleList+String.fromCharCode(2)+PartMyList;
					}
					DHC_PrintByLodop(getLodop(),MyPara,PartMyList,"","");
				}
			}
		}
	}

	function formatString(Str){
		var fStr="";
		var Arr=Str.split("\n");
		var chklen=37;
		var gHeight=0;
		for(var i=0;i<Arr.length;i++){
			var mStr="";
			var aStr=Arr[i];
			var len=aStr.length;
			var loop=Math.ceil(len/chklen);
			for(var j=0;j<loop;j++){
				gHeight=gHeight+1;
				var s=aStr.slice(j*chklen,j*chklen+chklen)
				//if(i>0){s="         "+s;}
				//s=s+String.fromCharCode(10);
				if(mStr=="")mStr=s;
				else{mStr=mStr+"\n"+s}
			}
			if(gHeight>17){
				fStr=fStr+"\n"+"......"
				break;	
			}
			if(fStr=="")fStr=mStr;
			else{fStr=fStr+"\n"+mStr}
		}
		return fStr
	}
	
	return {
		"Excel_PrintCureApply":Excel_PrintCureApply,
		"XML_PrintCureApply":XML_PrintCureApply	
	}
	
})()