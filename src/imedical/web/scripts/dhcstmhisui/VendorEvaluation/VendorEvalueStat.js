var init = function () {
	var VendorParams = JSON.stringify(addSessionParams({
				APCType: "M",
				RcFlag: "Y"
			}));
	var VendorBox = $HUI.combobox('#Vendor', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
			valueField: 'RowId',
			textField: 'Description'
		});
	var EvalIndexParams=JSON.stringify(addSessionParams());
	var EvalIndexBox = $HUI.combobox('#EvalIndex', {
			url: $URL + '?ClassName=web.DHCSTMHUI.DHCVendorEvaluationIndex&QueryName=EvalIndex&ResultSetType=array&Params='+EvalIndexParams,
			valueField: 'RowId',
			textField: 'Desc'
		});

	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#Conditions');
			if (isEmpty(ParamsObj.StartDate)) {
				$UI.msg('alert','��ʼ���ڲ���Ϊ��!');
				return;
			}
			if (isEmpty(ParamsObj.EndDate)) {
				$UI.msg('alert','��ֹ���ڲ���Ϊ��!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			Params=encodeUrlStr(Params);
			var CheckedRadioObj = $("input[name='ReportType']:checked");
			var CheckedValue = CheckedRadioObj.val();
			var CheckedTitle = CheckedRadioObj.attr("label");
			var URL = CheckedURL(CheckedValue, Params);
			AddTab(CheckedTitle, URL);
		}
	});

	$UI.linkbutton('#ClearBT', {
		onClick: function () {
			$UI.clearBlock('#Conditions');
			var Tabs = $('#tabs').tabs('tabs');
			var Tiles = new Array();
			var Len = Tabs.length;
			if (Len > 0) {
				for (var j = 0; j < Len; j++) {
					var Title = Tabs[j].panel('options').title;
					if (Title != '����') {
						Tiles.push(Title);
					}
				}
				for (var i = 0; i < Tiles.length; i++) {
					$('#tabs').tabs('close', Tiles[i]);
				}
			}
			SetDefaValues();
		}
	});

	SetDefaValues();
};
$(init);

function SetDefaValues() {
	$('#StartDate').datebox('setValue', DateFormatter(new Date()));
	$('#EndDate').datebox('setValue', DateFormatter(new Date()));
}
function CheckedURL(CheckedValue, Params) {
	var p_URL="";
	if ('FlagVendorIndexScore' == CheckedValue) {
		p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_VendorIndexScore.raq&Params=' + Params;
	} else {
		p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_VendorIndexScore.raq&Params=' + Params;
	}
	return p_URL;
}
function AddTab(title, url) {
	if ($('#tabs').tabs('exists', title)) {
		$('#tabs').tabs('select', title); //ѡ�в�ˢ��
		var currTab = $('#tabs').tabs('getSelected');
		if (url != undefined && currTab.panel('options').title != '����') {
			$('#tabs').tabs('update', {
				tab: currTab,
				options: {
					content: CreateFrame(url)
				}
			})
		}
	} else {
		var content = CreateFrame(url);
		$('#tabs').tabs('add', {
			title: title,
			content: content,
			closable: true
		});
	}
}
function CreateFrame(url) {
	var s = '<iframe scrolling="auto" frameborder="0"  src="' + url + '" style="width:100%;height:99.4%;"></iframe>';
	return s;
}
