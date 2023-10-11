/// 国家医保编码取值配置界面
/// 基础数据平台-李可凡
/// 2021-11-05

var init = function(){
	
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.INSUConfig&pClassMethod=SaveData";
	
	var HospID=""
	//多院区下拉框
	var hospComp=GenHospComp('CF_BDP_BD.INSUConfig');
	hospComp.options().onSelect=function(){
		HospID=$HUI.combogrid('#_HospList').getValue();
		GetConfig();
	}
	
	//加载方法
	GetConfig=function()
	{
		$('#TarItemConfig').combobox('setValue','');
		$('#OperationConfig').combobox('setValue','');
		$('#ICDDxConfig').combobox('setValue','');
		var TarItemConfig=tkMakeServerCall("web.DHCBL.BDP.INSUConfig","GetConfigByHospId",hospComp.getValue(),"DHC_TarItem");	
		var OperationConfig=tkMakeServerCall("web.DHCBL.BDP.INSUConfig","GetConfigByHospId",hospComp.getValue(),"ORC_Operation");	
		var ICDDxConfig=tkMakeServerCall("web.DHCBL.BDP.INSUConfig","GetConfigByHospId",hospComp.getValue(),"MRC_ICDDx");
		if (TarItemConfig!=""){
			$('#TarItemConfig').combobox('setValue',TarItemConfig);
		}
		if (OperationConfig!=""){
			$('#OperationConfig').combobox('setValue',OperationConfig);
		}
		if (ICDDxConfig!=""){
			$('#ICDDxConfig').combobox('setValue',ICDDxConfig);
		}
	}
	
	GetConfig();
	
	//点击保存按钮
	$("#BtnUpdate").click(function (e) { 
			UpdateData();
	});	
	
	//保存方法
	UpdateData=function()
	{
		/*
		if (hospComp.getValue()=="")
		{	$.messager.alert('错误提示','请先选择一个医院!',"info");
			return;
		}
		*/
		var datastr = "";
		datastr=hospComp.getValue();
		datastr=datastr+"^"+"DHC_TarItem"+"#"+$('#TarItemConfig').combobox('getValue');
		datastr=datastr+"^"+"ORC_Operation"+"#"+$('#OperationConfig').combobox('getValue');
		datastr=datastr+"^"+"MRC_ICDDx"+"#"+$('#ICDDxConfig').combobox('getValue');
		//alert(datastr);
		$.messager.confirm('提示', '确定要保存数据吗?', function(r){
			if (r){
				$.ajax({
					url:SAVE_ACTION_URL,  
					data:{
						"datastr":datastr
					},  
					type:"POST",   
					success: function(data){
							  var data=eval('('+data+')'); 
							  if (data.success == 'true') {
									$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
									
							  } 
							  else {
									var errorMsg ="保存失败！"
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