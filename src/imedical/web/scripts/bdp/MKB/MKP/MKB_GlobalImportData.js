var init = function() {
    //知识点1下拉框
    $('#MKBTermBase').combobox({
        url: $URL + "?ClassName=web.DHCBL.MKB.MKBKLMappingBase&QueryName=GetTermBaseSet&ResultSetType=array",
        valueField: 'ID',
        textField: 'Desc',
        mode: 'remote',
        /*onSelect:function(record){
	        var baseid=record.ID;
	        alert(baseid)
	        /*$('.source1').combobox('clear');
	        $('.source1').combobox('reload',$URL+"?ClassName=web.DHCBL.MKB.MKBKLMappingBase&QueryName=GetPublicCat&ResultSetType=array&base="+record.ID);
			var basedesc=record.Desc;
			$('.sourceknow1').text("（"+basedesc+"）");
	        }	*/
    });
    //执行导入按钮
    $("#importData").click(function(e) {
        var baseid = $("#MKBTermBase").combobox('getValue')
        //alert(baseid)
        var result = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal", "ImportDataByBase", baseid);
        $.messager.popover({
            msg: '导入成功！',
            type: 'success',
            timeout: 1000
        });
    })
}
$(init);