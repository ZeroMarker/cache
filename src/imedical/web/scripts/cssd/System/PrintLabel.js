// 数字标签打印
var init = function() {
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			var Params = $UI.loopBlock('PrintTB');
			var Label = Params.Label;
			var Desc = Params.Desc;
			if (isEmpty(Label)) {
				$UI.msg('alert', '请输入标签!');
				return;
			}
			if (isEmpty(Desc)) {
				$UI.msg('alert', '请输入名称!');
				return;
			}
			printCodeDict(Label, Desc);
		}
	});
};
$(init);