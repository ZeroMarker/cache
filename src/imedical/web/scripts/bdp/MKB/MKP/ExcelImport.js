///编写日期：2018-11-22
var init = function(){
	doChange=function(file){
	    var upload_file = $.trim($("#fileParth").val());    //获取上传文件
	    $('#ExcelImportPath').val(upload_file);     //赋值给自定义input框
	}
	$("#ImportBtn").click(function(){
		var path=$('#ExcelImportPath').val()
		ExcelImport(path);
	})
	function ExcelImport(path){
		$.messager.progress({
				 title:"提示",
				 msg:"正在导入数据，请勿刷新或关闭页面，请稍候...",
				 text:"导入中..."
			 });
		alert(1)	
		var Flag =tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","DataProcessing",path) 
		if (Flag=="0"){  //保存失败
			alert("保存失败")
			$.messager.progress('close');
		}
		if (Flag=="1"){
			alert("保存成功")
			$.messager.progress('close');
		}			
	}

};
$(init);