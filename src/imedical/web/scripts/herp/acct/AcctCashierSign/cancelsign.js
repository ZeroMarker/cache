function cancelsign() {
	var rowObj = itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var vouchIdArr = [],
	uncancelsigncount = 0;
	if (len > 0) {
		for (var i = 0; i < len; i++) {
			var vouchId = rowObj[i].get("rowid");
			var signUserId = rowObj[i].get("CheckerID");
			var signState = rowObj[i].get("IsCheck");
			var vouchState = rowObj[i].get("VouchState1");
			if (signUserId !== userdr || signState == "δǩ��" || vouchState > 21) {
				uncancelsigncount++;
				continue;
			} else if (vouchIdArr.indexOf(vouchId) == -1) {
				// ���˵��ظ���ƾ֤id
				vouchIdArr.push(vouchId);
			}
		}

		if (vouchIdArr.length == 0) {
			Ext.Msg.show({
				title: 'ע��',
				msg: '��ѡ����Ϊδǩ�֡��Ѽ��ˡ��ѽ���</br>��Ǳ���ǩ�ֵ�ƾ֤������ȡ��ǩ�֣� ',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.WARNING
			});
			return;

		} else {
			/* // ���򣬴�С����	//û��Ҫ����
			vouchIdArr.sort(function (a, b) {
				return a - b;
			}); */
			// console.log("vouchIdArr:" + vouchIdArr)
			if (uncancelsigncount > 0) {
				Ext.MessageBox.confirm('��ʾ', '������ȡ��ǩ�ֵ�ƾ֤�ѹ��ˣ�����Ĳ����� ', function (btn) {
					if (btn == 'yes') {
						cancelsigndetail(vouchIdArr);
					} else {
						return ;
					}

				});
			}
			else cancelsigndetail(vouchIdArr);
		}

	} else {
		Ext.Msg.show({
			title: '����',
			msg: '��ѡ����Ҫȡ��ǩ�ֵ�ƾ֤! ',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.ERROR
		});
	}
	return;
}

