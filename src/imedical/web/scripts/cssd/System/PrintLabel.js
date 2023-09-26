var init = function () {	
	$UI.linkbutton('#PrintBT',{ 
		onClick:function(){			
			PrintBarcode();
		}
	});
	function PrintBarcode(){
		var Params=$UI.loopBlock('PrintTB');
		var label=Params.Number
		var Name=Params.Description
		if (isEmpty(label)) {
                $UI.msg('alert', '请输入条码!');
				return;
            }
		if (isEmpty(Name)) {
                $UI.msg('alert', '请输入名称!');
				return;
            }
	printCodeDict(label,Name);
	}
}
$(init);