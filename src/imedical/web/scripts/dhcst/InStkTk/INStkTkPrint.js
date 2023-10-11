//盘点打印
//zhangxiao
//20130715
//INStkTkPrint.js
function PrintINStk(Inst)
{    //alert(Inst)
	if(Inst==null||Inst==''){
		return;
		}
	var mainData=GetMainData(Inst);	
	if(mainData==null || mainData==""){
		return;
	}	
	
	var mainArr=mainData.split("^");
	var InstNo=mainArr[0]
	var LocDesc=mainArr[6]
	var InstDate=mainArr[1]
	var InstTime=mainArr[2]
	var qPar="" //"desc^ASC"  //包含特殊字符
	var Others=""
	var HospDesc=App_LogonHospDesc;
	//fileName="{DHCST_INStkTk_Common.raq(Inst="+Inst+";qPar="+qPar+";Others="+Others+";InstNo="+InstNo+";LocDesc="+LocDesc+";InstDate="+InstDate+";InstTime="+InstTime+";HospDesc="+HospDesc+")}";
	fileName="{DHCST_INStkTk_Common.raq(Inst="+Inst+";qPar="+qPar+";Others="+Others+";InstNo="+InstNo+";InstDate="+InstDate+";InstTime="+InstTime+")}";

	DHCCPM_RQDirectPrint(fileName);
	}
//盘点打印(按货位)
//wyx
//20131122
//INStkTkPrint.js
function PrintINStkStkBin(Inst){
    //alert(Inst)
	if(Inst==null||Inst==''){
		return;
		}
	var mainData=GetMainData(Inst);	
	if(mainData==null || mainData==""){
		return;
	}	
	
	var mainArr=mainData.split("^");
	var InstNo=mainArr[0]
	var LocDesc=mainArr[6]
	var InstDate=mainArr[1]
	var InstTime=mainArr[2]
	var qPar=""  //"desc^ASC"   //包含特殊字符
	var Others=""
	var HospDesc=App_LogonHospDesc;
	fileName="{DHCST_INStkTk_StkBin_Common.raq(Inst="+Inst+";qPar="+qPar+";Others="+Others+";InstNo="+InstNo+";InstDate="+InstDate+";InstTime="+InstTime+";)}";
	//fileName="{DHCST_INStkTk_StkBin_Common.raq(Inst="+Inst+";qPar="+qPar+";Others="+Others+";InstNo="+InstNo+";LocDesc="+LocDesc+";InstDate="+InstDate+";InstTime="+InstTime+";HospDesc="+HospDesc+";)}";
	DHCCPM_RQDirectPrint(fileName);
	}

function PrintINStkTotal(Inst)
{	
	if(Inst==null||Inst==''){
		return;
		}
	var mainData=GetMainData(Inst);	
	if(mainData==null || mainData==""){
		return;
	}	
	
	var mainArr=mainData.split("^");
	var InstNo=mainArr[0]
	var LocDesc=mainArr[6]
	var InstDate=mainArr[1]
	var InstTime=mainArr[2]
	var qPar="" //"desc^ASC"  //包含特殊字符
	var Others=""
	var HospDesc=App_LogonHospDesc;
	//fileName="{DHCST_INStkTk_Common.raq(Inst="+Inst+";qPar="+qPar+";Others="+Others+";InstNo="+InstNo+";LocDesc="+LocDesc+";InstDate="+InstDate+";InstTime="+InstTime+";HospDesc="+HospDesc+")}";
	fileName="{DHCST_INStkTk_Common_total.rpx(Inst="+Inst+";InstNo="+InstNo+";InstDate="+InstDate+";InstTime="+InstTime+")}";

	DHCCPM_RQDirectPrint(fileName);
}
	
	
function GetMainData(Inst)
 {
	var mainData="";
	if(Inst==null || Inst==''){
		return;
	}
	var url='dhcst.instktkaction.csp?actiontype=Select&Rowid='+Inst;
 
	var responseText=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(responseText);
	if(jsonData.success=='true'){
		mainData=jsonData.info;
	}
	
	return mainData;
	}		