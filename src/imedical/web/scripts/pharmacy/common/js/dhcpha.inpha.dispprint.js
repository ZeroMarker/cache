///住院发药打印公共JS 慈林
///Creator:dinghongying
///CreateDate:2018-08-28
///dhcpha.inpha.dispprint.js
var reprintflag="";  //是否补打状态值
var phacArr="";
var isPreView="0"; //默认直接打印
var pidF="";
var HospitalDesc="";
var dispPrintType="";  //1明细,2汇总,3汇总+明细
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

///打印归类
function ClassOfPrint(phac,phatype,reprintflag){	
	//判断界面打印明细和打印汇总是否有选中,有则按照界面选择打印
	
	var flag=0;  //状态值
	var conReserve=0;
	var prtResRet=0;
	var conOther="";
	var objDetailPrn=document.getElementById("DetailPrn");  //明细
	if(objDetailPrn){
		if (objDetailPrn.checked==true){
			/*if (phatype=="ZCY"){
			    dhcphaMsgBox.alert("草药不需要勾选打印汇总或打印明细!");
			    return;
		    }*/
			flag=1;
			var conDetail=1;
		} 
	}else{
		if ((dispPrintType==1)||(dispPrintType==3)){
			if (phatype=="ZCY"){
			    dhcphaMsgBox.alert("草药不需要勾选打印汇总或打印明细!");
			    return;
		    }
			flag=1;
			var conDetail=1;	
		}
	}
	var objTotalPrn=document.getElementById("TotalPrn");   //汇总
	if(objTotalPrn){
		if (objTotalPrn.checked==true){
			/*if (phatype=="ZCY"){
			    dhcphaMsgBox.alert("草药不需要勾选打印汇总或打印明细!");
			    return;
		    }*/
			flag=1;
			var conTotal=1;
		}	
	}else{
		if ((dispPrintType==2)||(dispPrintType==3)){
			if (phatype=="ZCY"){
			    dhcphaMsgBox.alert("草药不需要勾选打印汇总或打印明细!");
			    return;
		    }
			flag=1;
			var conTotal=1;	
		}
	}
	//flag为0,按照默认设置打印
	if((flag==0)||(reprintflag=="")){
		//默认设置		
	    var configStr=GetPrtTypeConfig(phatype).split("^");
	    if (flag==0){
		    var conTotal=configStr[2];    //汇总
		    var conDetail=configStr[1];   //明细
		    var conOther=configStr[3];    //其它
		    //var conReserve=configStr[11];  //发药冲减退药
		    var conReserve=0;  //发药冲减退药 因为已经有了单独打印冲减退药的配置此配置已无用
		    if ((conDetail==0)&&(conTotal==0)&&(conOther=="")){
				alert("药品类别"+phatype+"设置不匹配,请核实!");
				return;
			}
	        var prtResRet=configStr[4];   //冲减退药
	       	var prtNoStock=configStr[6];    //库存不足打印
	    }
	    isPreView=configStr[5];    //预览打印
	}   
	
    ///非汇总和清单的情况下，按照特殊指定格式打印   
    if(((conDetail=="0")&(conTotal=="0"))||(conOther!="")){
	    //yunhaibao,20160623,住院发药打印其他时根据维护的内容调用对应的方法
	    var conOtherArr= conOther.split(";");
	    for (var otheri=0;otheri<conOtherArr.length;otheri++){
			var printother=conOtherArr[otheri];
			eval(printother)(phac,isPreView);
		}
	    /*
		switch (phatype) 
		{
			case "KFY":
				PrintLabel(phac);  //口服标签
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
		///打印明细清单
		if(conDetail==1){
			PrintDispDetail(phac,reprintflag,isPreView);
			if (phatype=="KFY") {
				PrintKFYLabel(phac);
			}
		} 
		///打印汇总单
		if(conTotal==1){	
			if (conReserve==1){		
				PrintDispTotalRes(phac,reprintflag,isPreView); 
			}else{
				PrintDispTotal(phac,reprintflag,isPreView);
			}
		}
		if (prtResRet==1){
			PrintResRetDetail(phac,reprintflag,isPreView)	//冲减退药明细打印
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
	//      PrintNoStockDetail(phac,reprintflag)	//库存不足明细打印
	//}
} 

///打印归类2(库存不足单独设置)
function ClassOfPrint2(reprintflag,DispCat){        
	var retflag=0
	var WardList=GetWardDisp(); //获取组织的发药病区
	if (WardList!=""){var retflag=1;}  
	var WardArr=WardList.split("^")
	if (retflag!=1){
	    return;
	}
	
	for(j=0;j<WardArr.length;j++) {
		var wardid=WardArr[j];
		var PatNoList=GetWardDispPatNo(wardid); //获取组织的发药病区的病人id串
		var PatNoArr=PatNoList.split("^");
		for(i=0;i<PatNoArr.length;i++){
			var patNo=PatNoArr[i];
			var DispTypeList=GetWardDispPatNoType(wardid,patNo); //获取组织的发药病区的病人id串的发药类别
			var DispTypeArr=DispTypeList.split("^")
			for(k=0;k<DispTypeArr.length;k++){
				var phatype=DispTypeArr[k]
				var configStr=GetPrtTypeConfig(phatype).split("^");
				var conTotal=configStr[2];    //汇总
				var conDetail=configStr[1];   //明细
				var conOther=configStr[3];    //其它
				var conReserve=configStr[8];  //是否冲抵
				//if ((conDetail==0)&&(conTotal==0)&&(conOther=="")){
				// alert("药品类别"+phatype+"设置不匹配,请核实!");}
				var prtResRet=configStr[4];   //冲减退药
				isPreView=configStr[5];    //预览打印
				var prtNoStock=configStr[6];    //库存不足打印
				if (prtNoStock==1){
					if (confirm("确定打印库存不足明细单吗？")==false) {
						KillNoStockTmp();
						return ;
					}
					PrintNoStockDetail(phatype,reprintflag,wardid,patNo,isPreView)	//库存不足明细打印
				}
			}
		}
		if (j=(WardArr.length-1)){
			KillNoStockTmp();
		}
	}
} 

///打印明细单据
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

///打印汇总单据
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

///打印中药处方
function PrintZCY(phac,isPreView){
	var retval=tkMakeServerCall("web.DHCSTPCHCOLLDSPPRN","GetPhaCollDetailRunQian",phac);
	var str=retval.split("^");
	var num=str[0]; //处方数
	var pid=str[1]; //进程ID
	for(var m=1;m<=num;m++){
		var mainstr=tkMakeServerCall("web.DHCSTPCHCOLLDSPPRN","getListDispDetailCY",pid,m);
		var LODOP=getLodop();
		CreatDispCYPrint(LODOP,"",mainstr);
 	}	
	///k临时global
	var mytrn=tkMakeServerCall("web.DHCSTPCHCOLLDSPPRN","killTmpGlobalCY",pid);
}

///打印汇总(冲减)
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
//冲减明细打印
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
//打印库存不足的药品
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
///获取发药类别
function GetDispType(phac){
	var disptype=tkMakeServerCall("web.DHCSTPCHCOLLS","GetDispType","","",phac);
	return disptype;
}

///获取发药类别配置信息
function GetPrtTypeConfig(type){
  var config=tkMakeServerCall("web.DHCSTKUTIL","GetPrnTypeConfig",type);
  return config;
}

///获取发药主信息
function GetPhacMainData(phac){
	var maindata=tkMakeServerCall("web.DHCSTPCHCOLLDSPPRN","GetPhacMainData",phac);
	return maindata;
}

///检查有无库存不足的药品
function CheckNoStock(disptype){
	var ret=tkMakeServerCall("web.DHCSTPCHCOLLDSPPRN","CheckNoStock",pidF,disptype);
	return ret;
}

//重新获取组织的库存不足的病区
function GetWardDisp(){
	var ret=tkMakeServerCall("web.DHCSTPCHCOLLDSPPRN","GetWardDisp",pidF);
	return ret;
}

//重新获取组织的库存不足的病区的病人id串
function GetWardDispPatNo(wardid)
{
	var ret=tkMakeServerCall("web.DHCSTPCHCOLLDSPPRN","GetWardDispPatNo",pidF,wardid);
	return ret;
}

///重新获取组织的库存不足的病区的病人id串的发药类别
function GetWardDispPatNoType(wardid,patnoid){
	var ret=tkMakeServerCall("web.DHCSTPCHCOLLDSPPRN","GetWardDispPatNoType",pidF,wardid,patnoid);
	return ret;
}
///住院打印口服标签
function PrintKFYLabel(phac){
	var MyList="";
	var MyPara="";
	//准备打印数据
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
	    var patinfo=tmparr[0];   //病人信息串
	    var patarr=patinfo.split("^");
	    var pano=patarr[1];   //登记号
	    var bed=patarr[2];   //床号
	    var paname=patarr[3]; //病人姓名
	    var orddate=patarr[4]; //发药日期
		var freqflag=patarr[5]; //用药时间段（早，中，晚）
		var warddesc=patarr[6]; //用法
		var instruction=patarr[7]; //用法
	    //MyPara=MyPara+'admloc'+String.fromCharCode(2)+patloc;
	    MyPara=MyPara+'pano'+String.fromCharCode(2)+pano;
	    MyPara=MyPara+'^paname'+String.fromCharCode(2)+paname;
	    MyPara=MyPara+'^freqflag'+String.fromCharCode(2)+freqflag;
	    MyPara=MyPara+'^bed'+String.fromCharCode(2)+bed;  
	    MyPara=MyPara+'^orddate'+String.fromCharCode(2)+orddate; 
	    MyPara=MyPara+'^instruction'+String.fromCharCode(2)+instruction;
	    MyPara=MyPara+'^warddesc'+String.fromCharCode(2)+warddesc;
	    var xmlTopStr=MyPara;
	    var medinfo=tmparr[1];  //药品信息串
	    var medarr=medinfo.split("@");
	    var MyList='';
	    for (var h=0;h<medarr.length;h++){
			var medrow=medarr[h];
			var rowarr=medrow.split("^");
			var incidesc=rowarr[0];    //名称
			var dispqty=rowarr[1]; //数量
			//var Freq=rowarr[4];        //频次
			//var DoseQty=rowarr[1]+rowarr[2];  //剂量
			//MyPara=xmlTopStr+'^incidesc'+String.fromCharCode(2)+incidesc;
			//MyPara=MyPara+'^Freq'+String.fromCharCode(2)+Freq;
			//MyPara=MyPara+'^DoseQty'+String.fromCharCode(2)+DoseQty;
			//MyPara=MyPara+'^instruction'+String.fromCharCode(2)+instruction;
			//MyPara=MyPara+'^DispQty'+String.fromCharCode(2)+dispqty //+"/次"+" "+Freq+" "+instruction;
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
    ///打印完成 k掉临时global
    tkMakeServerCall("web.DHCSTPCHCOLLPRN","KillTempGlobal",pid);
    //return true;
}

function KillNoStockTmp(){
	if(pidF!=""){
		tkMakeServerCall("web.DHCSTPCHCOLLS","KillNoStockTMP",pidF)
	}
}  