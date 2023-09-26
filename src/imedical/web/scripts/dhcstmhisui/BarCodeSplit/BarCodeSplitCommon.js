/*
 * 按不分段条码获取barcode,expdate,batchno等信息
 */
function GetBarCodeSplitInfo(code){
	var barcode = '', BatchNo = '', ExpDate = '', ProduceDate = '';
	if(code.length <= 22){
		//分段情况
		barcode = code;
		//批号效期为空
	}else{
		//不分段情况 || 分段后的拼接情况
		var Start2 = code.substring(0,2), Start4 = code.substring(0,4);
		if(Start2 == '01'){
			//扫码无括号 && 01开头
			barcode = code.substring(0,16);
		}else if(Start2 == '00'){
			//扫码无括号 && 00开头
			barcode = code.substring(0,20);
		}else if(Start4 == '(01)'){
			//扫码有括号 && (01)开头
			barcode = code.substring(0,18);
		}else if(Start4 == '(00)'){
			//扫码有括号 && (00)开头
			barcode = code.substring(0,22);
		}else{
			var SplitInfo = $.cm({
				ClassName: 'web.DHCSTMHUI.DHCBarCodeSplitInfo',
				MethodName: 'LocateSplitInfo',
				BarCode: code
			}, false);
			if(!isEmpty(SplitInfo['BarCode'])){
				barcode = SplitInfo['BarCode'];
			}
		}
	}
	if(isEmpty(barcode)){
		$UI.msg('alert', '无法获取物品码!');
		return {Code : ''};
	}
	
	var InciId, ExpStartPosition, ExpLength, BatStartPosition, BatLength, ProStartPosition, ProLength;
	
	var tmpCode = code.replace(/\(/g,'').replace(/\)/g,'');				//临时code,不计括号
	var tmpBarcode = '';
	if(!isEmpty(barcode)){
		tmpBarcode = barcode.replace(/\(/g,'').replace(/\)/g,'');		//临时inci_barcode,不计括号
	}
	if(!isEmpty(barcode)){
		var SplitInfoObj = $.cm({
			ClassName: 'web.DHCSTMHUI.DHCBarCodeSplitInfo',
			MethodName: 'GetSplitInfo',
			BarCode: barcode
		}, false);
		//BarcodeSplitInfo: rowid^inci_barcode^expStartPosition^expLength^batStartPosition^BatLength
		//这里客户维护的expStartPosition,batStartPosition,不计括号,从1开始数,所以代码里要-1
		if(typeof(SplitInfoObj) == 'object'){
			InciId = SplitInfoObj['InciId'];
			ExpStartPosition = SplitInfoObj['ExpStartPosition'];
			ExpLength = SplitInfoObj['ExpLength'];
			BatStartPosition = SplitInfoObj['BatStartPosition'];
			BatLength = SplitInfoObj['BatLength'];
			ProStartPosition = SplitInfoObj['ProStartPosition'];
			ProLength = SplitInfoObj['ProLength'];
		}
	}
	//<1>先计算效期起始位置
	if(!isEmpty(ExpStartPosition)){
		ExpStartPosition = Number(ExpStartPosition) - 1;	// 客户维护数据,从1开始数,所以-1
	}else{
		ExpStartPosition = tmpBarcode.length + 2;			// +2 表示标识符
	}
	//<2>计算效期截取长度
	if(!isEmpty(ExpLength)){
		ExpLength = Number(ExpLength);
	}else{
		//缺省为6(ymd格式长度)
		ExpLength = 6;
	}
	//<3>计算批号起始位置
	if(!isEmpty(BatStartPosition)){
		BatStartPosition = Number(BatStartPosition) - 1;		// 客户维护数据,从1开始数,所以-1
	}else{
		if(ExpLength > 0){
			//缺省效期字符后面+2
			BatStartPosition = ExpStartPosition + ExpLength + 2;	// +2 表示标识符
		}else{
			BatStartPosition = ExpStartPosition + 8;
		}
	}
	//<4>计算批号长度
	if(!isEmpty(BatLength)){
		BatLength = Number(BatLength);
	}else{
		if(!isEmpty(BatStartPosition)){
			//这个位置,如果能获取BatStartPosition,默认到最后一位
			BatLength = tmpCode.length - BatStartPosition;
		}else if(ExpLength === 0){
			//未填写批号长度,且效期长度标记0时,批号长度也取0
			BatLength = 0;
		}
	}
	//<5>生产日期起始位置(如需拆分必须维护,否则不默认)
	if(!isEmpty(ProStartPosition)){
		ProStartPosition = Number(ProStartPosition) - 1;	// 客户维护数据,从1开始数,所以-1
	}
	//<6>生产日期长度
	if(!isEmpty(ProLength)){
		ProLength = Number(ProLength);
	}else{
		//缺省为6(ymd格式长度)
		ProLength = 6;
	}
	
	//拆分效期,批号
	try{
		ExpDateStr = tmpCode.substring(ExpStartPosition, ExpStartPosition + ExpLength);
		BatchNo = tmpCode.substring(BatStartPosition, BatStartPosition + BatLength);
		var Century = String(new Date().getFullYear()).substring(0,2);
		if(!isEmpty(ExpDateStr) && (ExpDateStr.length == ExpLength)){
			var NewExpDate = Century + '' + ExpDateStr;
			var Year = NewExpDate.substring(0,4), Month = NewExpDate.substring(4,6) - 1, Day = NewExpDate.substring(6,8);
			ExpDate = new Date(Year, Month, Day);
		}else{
			ExpDate = '';
		}
		//生产日期
		if(!isEmpty(ProStartPosition)){
			ProduceDateStr = tmpCode.substring(ProStartPosition, ProStartPosition + ProLength);
			if(!isEmpty(ProduceDateStr) && (ProduceDateStr.length == ProLength)){
				var NewProduceDate = Century + '' + ProduceDateStr;
				var Year = NewProduceDate.substring(0,4), Month = NewProduceDate.substring(4,6) - 1, Day = NewProduceDate.substring(6,8);
				ProduceDate = new Date(Year, Month, Day);
			}else{
				ProduceDate = '';
			}
		}
	}catch(e){}
	
	var Obj = {InciId : InciId, Code : barcode, BatchNo : BatchNo, ExpDate : ExpDate, ProduceDate : ProduceDate};
	return Obj;
}