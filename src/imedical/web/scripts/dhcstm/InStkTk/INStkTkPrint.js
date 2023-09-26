//盘点打印
//zhangxiao
//20130715
//INStkTkPrint.js
function PrintINStk(Inst,type)
{
	if(Inst==null||Inst==''){
		return;
	}
	var mainData=GetMainData(Inst);	
	if(mainData==null || mainData==""){
		return;
	}
	
	var mainArr=mainData.split("^");
	var InstNo=mainArr[0];
	var LocDesc=mainArr[6];
	var InstDate=mainArr[1];
	var InstTime=mainArr[2];
	var qPar="desc^ASC";
	var NoFreezeZero = InStkTkParamObj.NoFreezeZeroWhilePrint;		//打印时过滤冻结数为0的项目
	var Others = '^^^' + NoFreezeZero;
	
	var RaqName = 'DHCSTM_INStkTk_Common.raq';
	if (type==1){
		RaqName = 'DHCSTM_INStkTk_Common.raq';
	}else if (type==2){
		RaqName = 'DHCSTM_INStkTk_Commoninci.raq';
	}
	var fileName="{"+RaqName+"(Inst="+Inst+";qPar="+qPar+";Others="+Others+";InstNo="+InstNo+";LocDesc="+LocDesc+";InstDate="+InstDate+";InstTime="+InstTime+";HospDesc="+App_LogonHospDesc+")}";
	if(InStkTkParamObj.IndirPrint!="N"){
		fileName=TranslateRQStr(fileName);
		DHCSTM_DHCCPM_RQPrint(fileName);
	}else{
		DHCCPM_RQDirectPrint(fileName);
	}
}
function PrintINStkQuery(Inst,Others)
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
	var qPar="desc^ASC"
	
	fileName="{DHCSTM_INStkTk_Common.raq(Inst="+Inst+";qPar="+qPar+";Others="+Others+";InstNo="+InstNo+";LocDesc="+LocDesc+";InstDate="+InstDate+";InstTime="+InstTime+";HospDesc="+App_LogonHospDesc+")}";
	if(InStkTkParamObj.IndirPrint!="N")
	{
		fileName=TranslateRQStr(fileName);
		DHCCPM_RQPrint(fileName);
	}
	else{
		DHCCPM_RQDirectPrint(fileName);
	}
}
function GetMainData(Inst)
{
	var mainData="";
	if(Inst==null || Inst==''){
		return;
	}
	var url='dhcstm.instktkaction.csp?actiontype=Select&Rowid='+Inst;
 
	var responseText=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(responseText);
	if(jsonData.success=='true'){
		mainData=jsonData.info;
	}
	
	return mainData;
}