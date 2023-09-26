/*
 * �����ֶ������ȡbarcode,expdate,batchno����Ϣ
 */
function GetBarCodeSplitInfo(code){
	var barcode = '', BatchNo = '', ExpDate = '', ProduceDate = '';
	if(code.length <= 22){
		//�ֶ����
		barcode = code;
		//����Ч��Ϊ��
	}else{
		//���ֶ���� || �ֶκ��ƴ�����
		var Start2 = code.substring(0,2), Start4 = code.substring(0,4);
		if(Start2 == '01'){
			//ɨ�������� && 01��ͷ
			barcode = code.substring(0,16);
		}else if(Start2 == '00'){
			//ɨ�������� && 00��ͷ
			barcode = code.substring(0,20);
		}else if(Start4 == '(01)'){
			//ɨ�������� && (01)��ͷ
			barcode = code.substring(0,18);
		}else if(Start4 == '(00)'){
			//ɨ�������� && (00)��ͷ
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
		$UI.msg('alert', '�޷���ȡ��Ʒ��!');
		return {Code : ''};
	}
	
	var InciId, ExpStartPosition, ExpLength, BatStartPosition, BatLength, ProStartPosition, ProLength;
	
	var tmpCode = code.replace(/\(/g,'').replace(/\)/g,'');				//��ʱcode,��������
	var tmpBarcode = '';
	if(!isEmpty(barcode)){
		tmpBarcode = barcode.replace(/\(/g,'').replace(/\)/g,'');		//��ʱinci_barcode,��������
	}
	if(!isEmpty(barcode)){
		var SplitInfoObj = $.cm({
			ClassName: 'web.DHCSTMHUI.DHCBarCodeSplitInfo',
			MethodName: 'GetSplitInfo',
			BarCode: barcode
		}, false);
		//BarcodeSplitInfo: rowid^inci_barcode^expStartPosition^expLength^batStartPosition^BatLength
		//����ͻ�ά����expStartPosition,batStartPosition,��������,��1��ʼ��,���Դ�����Ҫ-1
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
	//<1>�ȼ���Ч����ʼλ��
	if(!isEmpty(ExpStartPosition)){
		ExpStartPosition = Number(ExpStartPosition) - 1;	// �ͻ�ά������,��1��ʼ��,����-1
	}else{
		ExpStartPosition = tmpBarcode.length + 2;			// +2 ��ʾ��ʶ��
	}
	//<2>����Ч�ڽ�ȡ����
	if(!isEmpty(ExpLength)){
		ExpLength = Number(ExpLength);
	}else{
		//ȱʡΪ6(ymd��ʽ����)
		ExpLength = 6;
	}
	//<3>����������ʼλ��
	if(!isEmpty(BatStartPosition)){
		BatStartPosition = Number(BatStartPosition) - 1;		// �ͻ�ά������,��1��ʼ��,����-1
	}else{
		if(ExpLength > 0){
			//ȱʡЧ���ַ�����+2
			BatStartPosition = ExpStartPosition + ExpLength + 2;	// +2 ��ʾ��ʶ��
		}else{
			BatStartPosition = ExpStartPosition + 8;
		}
	}
	//<4>�������ų���
	if(!isEmpty(BatLength)){
		BatLength = Number(BatLength);
	}else{
		if(!isEmpty(BatStartPosition)){
			//���λ��,����ܻ�ȡBatStartPosition,Ĭ�ϵ����һλ
			BatLength = tmpCode.length - BatStartPosition;
		}else if(ExpLength === 0){
			//δ��д���ų���,��Ч�ڳ��ȱ��0ʱ,���ų���Ҳȡ0
			BatLength = 0;
		}
	}
	//<5>����������ʼλ��(�����ֱ���ά��,����Ĭ��)
	if(!isEmpty(ProStartPosition)){
		ProStartPosition = Number(ProStartPosition) - 1;	// �ͻ�ά������,��1��ʼ��,����-1
	}
	//<6>�������ڳ���
	if(!isEmpty(ProLength)){
		ProLength = Number(ProLength);
	}else{
		//ȱʡΪ6(ymd��ʽ����)
		ProLength = 6;
	}
	
	//���Ч��,����
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
		//��������
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