///סԺ��ҩ��ӡ����JS ����
///Creator:dinghongying
///CreateDate:2018-08-28
///dhcpha.inpha.dispprint.js
var reprintflag="";  //�Ƿ񲹴�״ֵ̬
var phacArr="";
var isPreView="0"; //Ĭ��ֱ�Ӵ�ӡ
var pidF="";
var HospitalDesc="";
var dispPrintType="";  //1��ϸ,2����,3����+��ϸ
function PrintRep(phacStr,reprintflag,PidIn,DispCat,printType){
	if (printType==undefined){
		printType="";
	}
	dispPrintType=printType;
	HospitalDesc=tkMakeServerCall("web.DHCSTKUTIL","GetHospName",session['LOGON.HOSPID'])
    pidF=PidIn
	if(phacStr!=""){  
		phacArr=phacStr.split("A");
	}
	for(var printi=0;printi<phacArr.length;printi++){
		var phac=phacArr[printi].split("B");
		var phaType=GetDispType(phac[0]);
		ClassOfPrint(phac[0],phaType,reprintflag);	
	}
	if (pidF!=""){
		ClassOfPrint2(reprintflag,DispCat);
	}	
}

///��ӡ����
function ClassOfPrint(phac,phatype,reprintflag){	
	//�жϽ����ӡ��ϸ�ʹ�ӡ�����Ƿ���ѡ��,�����ս���ѡ���ӡ
	
	var flag=0;  //״ֵ̬
	var conReserve=0;
	var prtResRet=0;
	var conOther="";
	var objDetailPrn=document.getElementById("DetailPrn");  //��ϸ
	if(objDetailPrn){
		if (objDetailPrn.checked==true){
			/*if (phatype=="ZCY"){
			    dhcphaMsgBox.alert("��ҩ����Ҫ��ѡ��ӡ���ܻ��ӡ��ϸ!");
			    return;
		    }*/
			flag=1;
			var conDetail=1;
		} 
	}else{
		if ((dispPrintType==1)||(dispPrintType==3)){
			if (phatype=="ZCY"){
			    dhcphaMsgBox.alert("��ҩ����Ҫ��ѡ��ӡ���ܻ��ӡ��ϸ!");
			    return;
		    }
			flag=1;
			var conDetail=1;	
		}
	}
	var objTotalPrn=document.getElementById("TotalPrn");   //����
	if(objTotalPrn){
		if (objTotalPrn.checked==true){
			/*if (phatype=="ZCY"){
			    dhcphaMsgBox.alert("��ҩ����Ҫ��ѡ��ӡ���ܻ��ӡ��ϸ!");
			    return;
		    }*/
			flag=1;
			var conTotal=1;
		}	
	}else{
		if ((dispPrintType==2)||(dispPrintType==3)){
			if (phatype=="ZCY"){
			    dhcphaMsgBox.alert("��ҩ����Ҫ��ѡ��ӡ���ܻ��ӡ��ϸ!");
			    return;
		    }
			flag=1;
			var conTotal=1;	
		}
	}
	//flagΪ0,����Ĭ�����ô�ӡ
	if((flag==0)||(reprintflag=="")){
		//Ĭ������		
	    var configStr=GetPrtTypeConfig(phatype).split("^");
	    if (flag==0){
		    var conTotal=configStr[2];    //����
		    var conDetail=configStr[1];   //��ϸ
		    var conOther=configStr[3];    //����
		    //var conReserve=configStr[11];  //��ҩ�����ҩ
		    var conReserve=0;  //��ҩ�����ҩ ��Ϊ�Ѿ����˵�����ӡ�����ҩ�����ô�����������
		    if ((conDetail==0)&&(conTotal==0)&&(conOther=="")){
				alert("ҩƷ���"+phatype+"���ò�ƥ��,���ʵ!");
				return;
			}
	        var prtResRet=configStr[4];   //�����ҩ
	       	var prtNoStock=configStr[6];    //��治���ӡ
	    }
	    isPreView=configStr[5];    //Ԥ����ӡ
	}   
	
    ///�ǻ��ܺ��嵥������£���������ָ����ʽ��ӡ   
    if(((conDetail=="0")&(conTotal=="0"))||(conOther!="")){
	    //yunhaibao,20160623,סԺ��ҩ��ӡ����ʱ����ά�������ݵ��ö�Ӧ�ķ���
	    var conOtherArr= conOther.split(";");
	    for (var otheri=0;otheri<conOtherArr.length;otheri++){
			var printother=conOtherArr[otheri];
			eval(printother)(phac,isPreView);
		}
	    /*
		switch (phatype) 
		{
			case "KFY":
				PrintLabel(phac);  //�ڷ���ǩ
				break;

			case "JDMK":
				//PrintPJDMY(phac,phatype);
				break;

			case "JSMK":
				//PrintPJDMY(phac,phatype);
				break;

			case "ZCY":
				PrintZCY(phac);
				break;      
		}
		*/
	}
	if (conOther==""){
		///��ӡ��ϸ�嵥
		if(conDetail==1){
			PrintDispDetail(phac,reprintflag,isPreView);
			if (phatype=="KFY") {
				PrintKFYLabel(phac);
			}
		} 
		///��ӡ���ܵ�
		if(conTotal==1){	
			if (conReserve==1){		
				PrintDispTotalRes(phac,reprintflag,isPreView); 
			}else{
				PrintDispTotal(phac,reprintflag,isPreView);
			}
		}
		if (prtResRet==1){
			PrintResRetDetail(phac,reprintflag,isPreView)	//�����ҩ��ϸ��ӡ
		}
	} 
	var logret=tkMakeServerCall("web.DHCSTPCHCOLLDSPPRN","GetLogInfo",phac);
	if(logret!=""){
		var logArr=logret.split("^");
		var moudule=logArr[0]
		var condition=logArr[1]
		var content=logArr[2]
		var EncryptCode=logArr[3]
		websys_EventLog(moudule,condition,content,EncryptCode)
	}
	//if (prtNoStock==1){
	//      PrintNoStockDetail(phac,reprintflag)	//��治����ϸ��ӡ
	//}
} 

///��ӡ����2(��治�㵥������)
function ClassOfPrint2(reprintflag,DispCat){        
	var retflag=0
	var WardList=GetWardDisp(); //��ȡ��֯�ķ�ҩ����
	if (WardList!=""){var retflag=1;}  
	var WardArr=WardList.split("^")
	if (retflag!=1){
	    return;
	}
	
	for(j=0;j<WardArr.length;j++) {
		var wardid=WardArr[j];
		var PatNoList=GetWardDispPatNo(wardid); //��ȡ��֯�ķ�ҩ�����Ĳ���id��
		var PatNoArr=PatNoList.split("^");
		for(i=0;i<PatNoArr.length;i++){
			var patNo=PatNoArr[i];
			var DispTypeList=GetWardDispPatNoType(wardid,patNo); //��ȡ��֯�ķ�ҩ�����Ĳ���id���ķ�ҩ���
			var DispTypeArr=DispTypeList.split("^")
			for(k=0;k<DispTypeArr.length;k++){
				var phatype=DispTypeArr[k]
				var configStr=GetPrtTypeConfig(phatype).split("^");
				var conTotal=configStr[2];    //����
				var conDetail=configStr[1];   //��ϸ
				var conOther=configStr[3];    //����
				var conReserve=configStr[8];  //�Ƿ���
				//if ((conDetail==0)&&(conTotal==0)&&(conOther=="")){
				// alert("ҩƷ���"+phatype+"���ò�ƥ��,���ʵ!");}
				var prtResRet=configStr[4];   //�����ҩ
				isPreView=configStr[5];    //Ԥ����ӡ
				var prtNoStock=configStr[6];    //��治���ӡ
				if (prtNoStock==1){
					if (confirm("ȷ����ӡ��治����ϸ����")==false) {
						KillNoStockTmp();
						return ;
					}
					PrintNoStockDetail(phatype,reprintflag,wardid,patNo,isPreView)	//��治����ϸ��ӡ
				}
			}
		}
		if (j=(WardArr.length-1)){
			KillNoStockTmp();
		}
	}
} 

///��ӡ��ϸ����
function PrintDispDetail(phac,reprintflag,isPreView){	
	if(phac==null || phac==''){
		return;
	}
	var mainData=GetPhacMainData(phac);	
	var luserid=session['LOGON.USERID']
	$.ajax({
		url:DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL+"?ClassName=web.DHCSTPCHCOLLDSPPRN&QueryName=QueryPhaCollDspDetailSum&Params="+phac+"|@|"+luserid,
		type:"post",
		async:false,
		dataType: "json",
		success: function(data){
			var LODOP=getLodop();
		    CreatDispDetailPrint(LODOP,data,mainData);
		}
	})
}

///��ӡ���ܵ���
function PrintDispTotal(phac,reprintflag,isPreView){
	if(phac==null || phac==''){
		return;
	}
	var mainData=GetPhacMainData(phac);	
	$.ajax({
		url:DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL+"?ClassName=web.DHCSTPCHCOLLDSPPRN&QueryName=QueryPhaCollDspTotal&Params="+phac,
		type:"post",
		async:false,
		dataType: "json",
		success: function(data){
			var LODOP=getLodop();
		    CreatDispTotalPrint(LODOP,data,mainData);
		    LODOP.PREVIEW();
		}
	})
}

///��ӡ��ҩ����
function PrintZCY(phac,isPreView){
	var retval=tkMakeServerCall("web.DHCSTPCHCOLLDSPPRN","GetPhaCollDetailRunQian",phac);
	var str=retval.split("^");
	var num=str[0]; //������
	var pid=str[1]; //����ID
	for(var m=1;m<=num;m++){
		var mainstr=tkMakeServerCall("web.DHCSTPCHCOLLDSPPRN","getListDispDetailCY",pid,m);
		var LODOP=getLodop();
		CreatDispCYPrint(LODOP,"",mainstr);
 	}	
	///k��ʱglobal
	var mytrn=tkMakeServerCall("web.DHCSTPCHCOLLDSPPRN","killTmpGlobalCY",pid);
}

///��ӡ����(���)
function PrintDispTotalRes(phac,reprintflag,isPreView){
	if(phac==null || phac==''){
		return;
	}
	var mainData=GetPhacMainData(phac);	
	$.ajax({
		url:DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL+"?ClassName=web.DHCSTPCHCOLLDSPPRN&QueryName=QueryPhaCollDspTotal&Params="+phac,
		type:"post",
		async:false,
		dataType: "json",
		success: function(data){
			var LODOP=getLodop();
		    CreatDispTotalResPrint(LODOP,data,mainData);
		}
    })

}
//�����ϸ��ӡ
function PrintResRetDetail(phac,reprintflag,isPreView){
	if(phac==null || phac==''){
		return;
	}
	var mainData=GetPhacMainData(phac);	
	$.ajax({
		url:DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL+"?ClassName=web.DHCSTPCHCOLLDSPPRN&QueryName=QueryPhaCollResRetDetail&Params="+phac,
		type:"post",
		async:false,
		dataType: "json",
		success: function(data){
			var LODOP=getLodop();
		    CreatDispTotalPrint(LODOP,data,mainData);
		}
    })
}
//��ӡ��治���ҩƷ
function PrintNoStockDetail(phatype,reprintflag,wardid,patNo,isPreView){
	if(pidF==null || pidF==''){
		return;
	}
	var Flag=reprintflag
	$.ajax({
		url:DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL+"?ClassName=web.DHCSTPCHCOLLDSPPRN&QueryName=QueryPhaCollNoStockDetail&Params="+pidF+"|@|"+wardid+"|@|"+patNo+"|@|"+phatype,
		type:"post",
		async:false,
		dataType: "json",
		success: function(data){
			var LODOP=getLodop();
		    CreatNoStockDetailPrint(LODOP,data,"");
		}
    })
}
///��ȡ��ҩ���
function GetDispType(phac){
	var disptype=tkMakeServerCall("web.DHCSTPCHCOLLS","GetDispType","","",phac);
	return disptype;
}

///��ȡ��ҩ���������Ϣ
function GetPrtTypeConfig(type){
  var config=tkMakeServerCall("web.DHCSTKUTIL","GetPrnTypeConfig",type);
  return config;
}

///��ȡ��ҩ����Ϣ
function GetPhacMainData(phac){
	var maindata=tkMakeServerCall("web.DHCSTPCHCOLLDSPPRN","GetPhacMainData",phac);
	return maindata;
}

///������޿�治���ҩƷ
function CheckNoStock(disptype){
	var ret=tkMakeServerCall("web.DHCSTPCHCOLLDSPPRN","CheckNoStock",pidF,disptype);
	return ret;
}

//���»�ȡ��֯�Ŀ�治��Ĳ���
function GetWardDisp(){
	var ret=tkMakeServerCall("web.DHCSTPCHCOLLDSPPRN","GetWardDisp",pidF);
	return ret;
}

//���»�ȡ��֯�Ŀ�治��Ĳ����Ĳ���id��
function GetWardDispPatNo(wardid)
{
	var ret=tkMakeServerCall("web.DHCSTPCHCOLLDSPPRN","GetWardDispPatNo",pidF,wardid);
	return ret;
}

///���»�ȡ��֯�Ŀ�治��Ĳ����Ĳ���id���ķ�ҩ���
function GetWardDispPatNoType(wardid,patnoid){
	var ret=tkMakeServerCall("web.DHCSTPCHCOLLDSPPRN","GetWardDispPatNoType",pidF,wardid,patnoid);
	return ret;
}
///סԺ��ӡ�ڷ���ǩ
function PrintKFYLabel(phac){
	var MyList="";
	var MyPara="";
	//׼����ӡ����
	var retval=tkMakeServerCall("web.DHCSTPCHCOLLPRN","GetPhaCollDetail",phac);
    var prnarr=retval.split("^");
	var pid=prnarr[1];  
	var retval=tkMakeServerCall("web.DHCSTPCHCOLLPRN","GetDispFreqCnt",pid);
	var num=retval
	var MyPara="";
	for (var k=1;k<=num;k++){	 
		var MyList="";
		var MyPara="";
		var retval=tkMakeServerCall("web.DHCSTPCHCOLLPRN","ListDispFreq",pid,k);   
	    var tmparr=retval.split("||");
	    var patinfo=tmparr[0];   //������Ϣ��
	    var patarr=patinfo.split("^");
	    var pano=patarr[1];   //�ǼǺ�
	    var bed=patarr[2];   //����
	    var paname=patarr[3]; //��������
	    var orddate=patarr[4]; //��ҩ����
		var freqflag=patarr[5]; //��ҩʱ��Σ��磬�У���
		var warddesc=patarr[6]; //�÷�
		var instruction=patarr[7]; //�÷�
	    //MyPara=MyPara+'admloc'+String.fromCharCode(2)+patloc;
	    MyPara=MyPara+'pano'+String.fromCharCode(2)+pano;
	    MyPara=MyPara+'^paname'+String.fromCharCode(2)+paname;
	    MyPara=MyPara+'^freqflag'+String.fromCharCode(2)+freqflag;
	    MyPara=MyPara+'^bed'+String.fromCharCode(2)+bed;  
	    MyPara=MyPara+'^orddate'+String.fromCharCode(2)+orddate; 
	    MyPara=MyPara+'^instruction'+String.fromCharCode(2)+instruction;
	    MyPara=MyPara+'^warddesc'+String.fromCharCode(2)+warddesc;
	    var xmlTopStr=MyPara;
	    var medinfo=tmparr[1];  //ҩƷ��Ϣ��
	    var medarr=medinfo.split("@");
	    var MyList='';
	    for (var h=0;h<medarr.length;h++){
			var medrow=medarr[h];
			var rowarr=medrow.split("^");
			var incidesc=rowarr[0];    //����
			var dispqty=rowarr[1]; //����
			//var Freq=rowarr[4];        //Ƶ��
			//var DoseQty=rowarr[1]+rowarr[2];  //����
			//MyPara=xmlTopStr+'^incidesc'+String.fromCharCode(2)+incidesc;
			//MyPara=MyPara+'^Freq'+String.fromCharCode(2)+Freq;
			//MyPara=MyPara+'^DoseQty'+String.fromCharCode(2)+DoseQty;
			//MyPara=MyPara+'^instruction'+String.fromCharCode(2)+instruction;
			//MyPara=MyPara+'^DispQty'+String.fromCharCode(2)+dispqty //+"/��"+" "+Freq+" "+instruction;
		    var firstdesc=incidesc+" "+dispqty   
			if (MyList=='') {
				MyList = firstdesc;
			}else{
    			MyList = MyList + String.fromCharCode(2)+firstdesc;
			}
		} 
		DHCP_GetXMLConfig("InvPrintEncrypt","DHCSTPJLABLE"); 
		var myobj=document.getElementById("ClsBillPrint"); 
		DHCP_PrintFun(myobj,MyPara,MyList);

	}
    ///��ӡ��� k����ʱglobal
    tkMakeServerCall("web.DHCSTPCHCOLLPRN","KillTempGlobal",pid);
    //return true;
}

function KillNoStockTmp(){
	if(pidF!=""){
		tkMakeServerCall("web.DHCSTPCHCOLLS","KillNoStockTMP",pidF)
	}
}  