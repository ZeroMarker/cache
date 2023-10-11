/// 名称: 医用知识库 -列表型属性内容维护
/// 描述: 包含增删改查功能
/// 编写者: 基础数据平台组-谷雪萍
/// 编写日期: 2018-03-30

var init = function(){

	var HISUI_SQLTableName="MKB_TermProDetail"+property,HISUI_ClassTableName="User.MKBTermProDetail"+property;
	
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=DeleteData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=SaveData&pEntityName=web.Entity.MKB.MKBTermProDetail";
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetMyList";

	//重置按钮
	$("#btnRefresh").click(function (e) { 
		ClearFunLib();
	 }) 
 
	//添加按钮
	$("#save_btn").click(function (e) { 
		SaveFunLib();
	}) 
	
	//删除按钮
	$("#del_btn").click(function (e) { 
		DelData();
	})  
	
	//重置方法
	ClearFunLib=function()
	{
		//代码和描述赋值
		var textInfo=tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetTextInfo",property);
		var info=textInfo.split("[A]");  //全局变量 私有属性值表User.MKBTermProDetail的ID_"[A]"_属性内容		
		var id=info[0] 
		var text=info[1]
		$("#MKBTPDRowId").val(id)
	    setTimeout(function(){
		    var htmlEditor= document.getElementById('MKBTPDDesc').contentWindow.ue;
			//var htmlEditor=window.frames["MKBTPDDesc"].ue
       		htmlEditor.setContent(text);
	
		},1000)

	}
	ClearFunLib();

	///新增、更新
	SaveFunLib=function()
	{	
		var htmlEditor=document.getElementById('MKBTPDDesc').contentWindow.ue;
		var htmlText = htmlEditor.getContent();
		if (htmlText=="")
		{
			$.messager.alert('错误提示','中心词不能为空!',"error");
			return;
		}
		//var str=$("#MKBTPDRowId").val()+"&%"+property+"&%"+htmlText
		//var data=tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","SaveTest",str);
		$.ajax({
		url:SAVE_ACTION_URL,  
		data:{
			"MKBTPDRowId":$("#MKBTPDRowId").val(),  ///rowid
			"MKBTPDProDR":property,  
			"MKBTPDDesc":htmlText
		},  
		type:"POST",   
		success: function(data){
				var data=eval('('+data+')'); 
				if (data.success == 'true') 
				{
					$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
					$("#MKBTPDRowId").val(data.id)						
				} 
				else 
				{ 
					var errorMsg ="保存失败！"
					if (data.errorinfo) 
					{
						errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
					}
					$.messager.alert('操作提示',errorMsg,"error");
				}		
					}  
		})


	}

	///删除
	DelData=function()
	{        
		var id=$("#MKBTPDRowId").val()
		if (id=="") return 
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
			if (r){	
				$.ajax({
					url:DELETE_ACTION_URL,  
					data:{
						"id":id     ///rowid
					},  
					type:"POST",   
					success: function(data){
						  var data=eval('('+data+')'); 
						  if (data.success == 'true') {
								$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
								ClearFunLib();
						  } 
						  else { 
								var errorMsg ="删除失败！"
								if (data.info) {
									errorMsg =errorMsg+ '<br/>错误信息:' + data.info
								}
								$.messager.alert('操作提示',errorMsg,"error");
				
						}			
					}  
				})
			}
		});
	}
	
};
$(init);
