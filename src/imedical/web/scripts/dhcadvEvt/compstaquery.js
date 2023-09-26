/// author:     sufan
/// date:       2020-02-21
/// descript:   统计模板独立

$(function(){
	
	InitCombobox()			//初始化下拉框
})

///初始化下拉框数据
function InitCombobox()
{
	//抢救病区
	$('#statemp').combobox({
		url:$URL+"?ClassName=web.DHCADVCOMMONPART&MethodName=QueryStaTemp",
		valueField: 'value',
		textField: 'text',
		blurValidValue:true,
		onSelect:function(option){
			switchMainSrc(option.code)
		}
	})
	
}
function switchMainSrc(code)
{
	if(code==""){return;}
	var LinkUrl = "dhcadv.model.report.csp?&code=" +code+'&quoteflag=1';
	$("#TabMain").attr("src", LinkUrl);	
}
///回首页
function Gologin(){
	location.href='dhcadv.homepage.csp';
}