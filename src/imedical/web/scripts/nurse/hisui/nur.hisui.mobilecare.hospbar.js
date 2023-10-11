/// Creator:      EH
/// CreatDate:    2021-08-12
/// Description:  院区下拉框

function _hospbar() {
	var _box = this;
	_box.onSelect = function() {
	};
	_box.onHospChange = _box.onSelect;
	_box._onSelect = function() {
		$.expression(_box.onSelect);
		if (_box.onSelect != _box.onHospChange) {
			$.expression(_box.onHospChange);
		}
		if ($HUI._locpanel && $HUI._locpanel.onHospChange != _box.onHospChange) {
			$.expression($HUI._locpanel.onHospChange);
		}
	}
	/// 初始化
	_box.initEvent = function() {
		if (GV._HOSPBOX == '_HospList') {
			var hospID = $.m({
				ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
				MethodName: 'GetDefHospIdByTableName',
				tableName: GV._MAINTABLE,
				HospID: session['LOGON.HOSPID'],
				date: ''
			}, false);
			GV._HOSPID = hospID;
			$.loadJavaScript('../scripts/hisui/websys.comm.js', function() {
				var width = $('#hospBox').width();
				var td = $('#hospBox').parent().parent().children();
				td.css('display', 'none');
				td.last().after('<td><span class="r-label" style="color:red">医院</span></td><td><input id="_HospList" class="combo-text validatebox-text" autocomplete="off" style="width:240px;height:28px;line-height:28px" data-options="enterNullValueClear:false,panelMaxHeight:\'398px\'"></td>');
				GenHospComp(GV._MAINTABLE, '', { width: width });
				$('#_HospList').combogrid('options').onSelect = _box._onSelect;
				$('#_HospList').combogrid('options').onLoadSuccess = function() {
					if (typeof(SelectHospID) != 'undefined' && SelectHospID) {
						$('#_HospList').combogrid('setValue', SelectHospID);
					}
					_box._onSelect();
				};
			});
		} else {
			GV._HOSPID = session['LOGON.HOSPID'];
			var obj = {
				url: $URL + '?q=1&ClassName=' + GV._CLASSNAME + '&QueryName=FindHosp' + '&ResultSetType=array',
				valueField: 'ID',
				textField: 'name',
				defaultFilter: 4,
				onLoadSuccess: function() {
					$(this).combobox('setValue', (typeof(SelectHospID) != 'undefined' && SelectHospID) ? SelectHospID : GV._HOSPID);
					_box._onSelect();
				}
			}
			obj.onSelect = _box._onSelect;
			$('#hospBox').combobox(obj);
		}
	};
	/// 等待参数传递
	setTimeout(function() {
		_box.initEvent();
	}, 0);
}
$HUI.hospbar = function() {
	if (!$HUI._hospbar) {
		$HUI._hospbar = new _hospbar();
	}
	return $HUI._hospbar;
};
$(function() {
	$HUI.hospbar();
});
