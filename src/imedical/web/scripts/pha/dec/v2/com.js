/*
 * @ģ��:     ��ҩ����-��ҩ�ҹ���
 * @��д����: 2019-08-11
 * @��д��:   hulihua
 */

/**
 * ����
 * @method readCardClick
 * @param _fn���ص�����
 */
function readCardClick(_fn) {
	try {
		var cardType = $('#cmbCardType').combobox('getValue');
		var cardTypeDR = cardType.split('^')[0];
		var myRtn = '';
		if (cardTypeDR == '') {
			myRtn = DHCACC_GetAccInfo();
		} else {
			myRtn = DHCACC_GetAccInfo(cardTypeDR, cardType);
		}
		var myAry = myRtn.toString().split('^');
		var rtn = myAry[0];
		switch (rtn) {
			case '0':
				//����Ч
				if($('#txtBarCode')) {
					$('#txtBarCode').val(myAry[5]);
				}
				_fn();
				break;
			case '-200':
				$.messager.alert('��ʾ', '����Ч', 'info', function () {
					return;
				});
				break;
			case '-201':
				//�ֽ�
				if($('#txtBarCode')) {
					$('#txtBarCode').val(myAry[5]);
				}
				_fn();
				break;
			default:
		}
	} catch (e) {
		
	}
}