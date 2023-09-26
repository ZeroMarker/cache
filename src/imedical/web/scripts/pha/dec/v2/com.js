/*
 * @模块:     煎药流程-煎药室公共
 * @编写日期: 2019-08-11
 * @编写人:   hulihua
 */

/**
 * 读卡
 * @method readCardClick
 * @param _fn：回调函数
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
				//卡有效
				if($('#txtBarCode')) {
					$('#txtBarCode').val(myAry[5]);
				}
				_fn();
				break;
			case '-200':
				$.messager.alert('提示', '卡无效', 'info', function () {
					return;
				});
				break;
			case '-201':
				//现金
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