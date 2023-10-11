$(document).ready(function () {
    initDocument();
});
function initDocument()
{
	initUserInfo();
	initMessage();
	setRequiredElements("SourceType") 
	initEvent();
	initSourceType();
}

function initEvent()
{
	jQuery("#BExecute").on("click", BExecute_Clicked);
}

function initSourceType()
{
	var dataArr=[{id:'5',text:'�����ֵ�'},{id:'6',text:'��Ա�ֵ�'},{id:'7',text:'��ŵص�'},{id:'0',text:'�ʲ�����'},{id:'1',text:'�ʲ��䶯'},{id:'2',text:'�ʲ������걨'},{id:'3',text:'�ʲ���������'},{id:'4',text:'�ʲ��۾�'}];
	var SourceType = $HUI.combobox("#SourceType",{
		valueField:'id',
		textField:'text',
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		data:dataArr
	});
	setElement("SourceType","5");	//����Ĭ��ֵ
	
}

function BExecute_Clicked()
{
	if (checkMustItemNull("")) return
	//var	result=tkMakeServerCall("web.DHCEQ.Interface.DHCEQForWJW","ExecuteSend",getElementValue("pMonthStr"),getElementValue("SourceType"))
	//setElement("Result",result);
	document.getElementById("BExecute").style.display = 'none'
	$.ajax({
                url : 'dhceq.process.appendfileaction.csp?&actiontype=ExecuteSend&pMonthStr='+getElementValue("pMonthStr")+"&SourceType="+getElementValue("SourceType"),
                type : 'POST',
                cache : false,
                async:true,
                beforeSend:function(){
					$.messager.progress({
     				title: '��ȴ�',
     				msg: '���ڴ���',
    				text:'������',             //����������ʾ�����ݣ���д������Ծ���10%-20%�����Ľ�����ʾ
     				interval:300    //�����������ʱ��Ĭ��Ϊ300ms
					});
				},
                success:function(data){
	                $.messager.progress('close');
	                var datajson=eval('(' + data + ')')
	                setElement("Result",datajson.result);
                    document.getElementById("BExecute").style.display = ''
	                
                	}
            })
}
