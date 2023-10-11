PCInfoPanel=(function(){
	function Init(){
		var _$label = $("label[for=PCInfo1]");
		if (_$label.length > 0){
		   domName = _$label[0].innerHTML;
		    _$label[0].innerHTML=$g(domName);
		}
		var _$label = $("label[for=PCInfo2]");
		if (_$label.length > 0){
		   domName = _$label[0].innerHTML;
		    _$label[0].innerHTML=$g(domName);
		}
		}
	function OtherInfo(){
		return "";
		}
	function PrintInfo(){
		return "";
		}
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
		}
	   
})();