
function PrintINStk(Inst,type)
{
	if(Inst==null||Inst==''){
		return;
	}
	var qPar="code^ASC";
	var NoFreezeZero = InStkTkParamObj.NoFreezeZeroWhilePrint;		//打印时过滤冻结数为0的项目
	var Others =JSON.stringify({NoFreezeZero:NoFreezeZero});
	var RaqName = 'DHCSTM_HUI_INStkTk_Common.raq';
	if (type==1){
		RaqName = 'DHCSTM_HUI_INStkTk_Common.raq';
	}else if (type==2){
		RaqName = 'DHCSTM_HUI_INStkTk_Commoninci.raq';
	}
	var fileName="{"+RaqName+"(Inst="+Inst+";qPar="+qPar+";Others="+Others+")}";
	if(InStkTkParamObj.IndirPrint!="N"){
		fileName=TranslateRQStr(fileName);
		DHCSTM_DHCCPM_RQPrint(fileName);
	}else{
		DHCCPM_RQDirectPrint(fileName);
	}
}
