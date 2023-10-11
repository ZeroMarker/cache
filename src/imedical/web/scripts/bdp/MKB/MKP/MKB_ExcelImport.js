///编写日期：2018-11-22
var init = function(){
	var SAVE_URL="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBStructuredDataProcessing&pClassMethod=DataProcessing";
	var ErrorMsgInfo="请先确认本机有安装office软件。打开IE,在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用，确定后，重启浏览器。 "
	GetBrower=function()
	{	
		///ie10,9,8,7,6                                                   //IE11
        if(((window.ActiveXObject)&&((navigator.userAgent.toLowerCase()).match(/msie ([\d.]+)/)[1]))||(("ActiveXObject" in window)))
        {
        	return "IE"
        }
        else if(((navigator.userAgent.toLowerCase()).match(/firefox\/([\d.]+)/)))
        {
        	return "FIREFOX"
        }
        else if((navigator.userAgent.toLowerCase()).match(/opera.([\d.]+)/))
        {
        	return "OPERA"
        }
        else if((navigator.userAgent.toLowerCase()).match(/version\/([\d.]+).*safari/))
		{
			return "SAFARI"
		}
		else
		{
			return "OTHER"
		}
	}
	var BrowerVersion=GetBrower()

	doChange=function(file){
	    var upload_file = $.trim($("#filePath").val());    //获取上传文件
	    $('#ExcelImportPath').val(upload_file);     //赋值给自定义input框
	}
	$("#ImportBtn").click(function(){
		var efilepath=$('#ExcelImportPath').val()
		if (BrowerVersion!="IE")
		{
			alert("请在IE下执行！"); 
			return;
		}
		if( efilepath.indexOf("fakepath")>0 ) {alert ("请在IE下执行导入！"); return;}
		if( efilepath.indexOf(".csv")<=0 ) {alert ("请选择excel表格文件！"); return;}
		ExcelImport(efilepath);
	})
	function ExcelImport(efilepath){
		$.messager.progress({
				 title:"提示",
				 msg:"正在导入数据，请勿刷新或关闭页面，请稍候...",
				 text:"导入中..."
			 });
		alert(1)	 
		//var Flag =tkMakeServerCall("web.DHCBL.MKB.MKBDataProcessing","DataProcessing",efilepath)
		
		$.ajax({
			url:SAVE_URL,
			data:{path:efilepath},
			dataType:'json',
			timeout:0,
			async:true,
			success:function(data){
				var data=eval('('+data+')');
				if (data.success=="true"){  //保存失败
					$.messager.alert("提示","保存成功","info")
					$.messager.progress('close');
				}else{
					$.messager.alert("提示","保存失败","error")
					$.messager.progress('close');
				}	
			}
		}) 
	}
};
$(init);