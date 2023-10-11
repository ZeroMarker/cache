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
	var dataArr=[{id:'5',text:'科室字典'},{id:'6',text:'人员字典'},{id:'7',text:'存放地点'},{id:'0',text:'资产新增'},{id:'1',text:'资产变动'},{id:'2',text:'资产处置申报'},{id:'3',text:'资产处置销账'},{id:'4',text:'资产折旧'}];
	var SourceType = $HUI.combobox("#SourceType",{
		valueField:'id',
		textField:'text',
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		data:dataArr
	});
	setElement("SourceType","5");	//设置默认值
	
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
     				title: '请等待',
     				msg: '正在传输',
    				text:'传输中',             //进度条上显示的内容，不写这个属性就是10%-20%这样的进度显示
     				interval:300    //进度条变更的时候，默认为300ms
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
