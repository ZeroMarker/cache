/// author:     sufan
/// date:       2020-02-21
/// descript:   ͳ��ģ�����

$(function(){
	
	InitCombobox()			//��ʼ��������
})

///��ʼ������������
function InitCombobox()
{
	//���Ȳ���
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
///����ҳ
function Gologin(){
	location.href='dhcadv.homepage.csp';
}