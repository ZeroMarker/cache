//20190102+mfc
function OnHidePanel(item)
{
	var valueField = $(item).combobox("options").valueField;
	var val = $(item).combobox("getValue");  //当前combobox的值
	var txt = $(item).combobox("getText");
	var allData = $(item).combobox("getData");   //获取combobox所有数据
	var result = true;      //为true说明输入的值在下拉框数据中不存在
	if (val=="") result=false;
	for (var i = 0; i < allData.length; i++) {
		if (val == allData[i][valueField]) {
	    	result = false;
	    	break;
	    }
	}
	if (result) {
	    if (txt!="")
	    {
	    	$.messager.alert("提示","请从下拉框选择","error"); 
	    	$(item).combobox('setValue',"");
	    	$(item).combobox("setText","");
	    	$(item).combobox("reload");
	    	return;
	    }
	}
}