$(document).ready(function () {
    var tabTitle="服务表维护";
	var url='DHCCLCMappingService.csp';
	addTabFisrt(tabTitle,url);	
	/*$('#clickservice').click(function(){
		var tabTitle="服务表维护";
		var url='DHCCLCMappingService.csp';
		addTab(tabTitle,url);
	});*/
	$('#clickentity').click(function(){
		var tabTitle="映射实体码表维护";
		var url='DHCCLCMappingEntity.csp';
		addTab(tabTitle,url);
	});
	/*$('#clickcode').click(function(){
		var tabTitle="映射代码表维护";
		var url='DHCCLCMappingCode.csp';
		addTab(tabTitle,url);
	});
	$('#clickrecord').click(function(){
		var tabTitle="映射业务表维护";
		var url='DHCCLMappingRecord.csp';
		addTab(tabTitle,url);
	});*/
	$('#clicklog').click(function(){
		var tabTitle="日志表维护";
		var url='DHCCLMappingLog.csp';
		addTab(tabTitle,url);
	});
	$('#clickinputloc').click(function(){
		var tabTitle="科室表导入";
		var url='DHCCLInputLocData.csp';
		addTab(tabTitle,url);
	});
	$('#clickinputcarprvtp').click(function(){
		var tabTitle="医护人员类型导入";
		var url='DHCCLInputCarPrvTpData.csp';
		addTab(tabTitle,url);
	});
	$('#clickinputcareprov').click(function(){
		var tabTitle="医护人员导入";
		var url='DHCCLInputCareProvData.csp';
		addTab(tabTitle,url);
	});
	$('#clickinputctuom').click(function(){
		var tabTitle="基本单位导入";
		var url='DHCCLInputCTUomData.csp';
		addTab(tabTitle,url);
	});
	$('#clickinputconfac').click(function(){
		var tabTitle="单位转换表导入";
		var url='DHCCLInputConFacData.csp';
		addTab(tabTitle,url);
	});
	$('#clickinputfreq').click(function(){
		var tabTitle="频次表导入";
		var url='DHCCLInputFreqData.csp';
		addTab(tabTitle,url);
	});
	$('#clickinputinstruct').click(function(){
		var tabTitle="用法表导入";
		var url='DHCCLInputInstructData.csp';
		addTab(tabTitle,url);
	});
	$('#clickinputitemcat').click(function(){
		var tabTitle="医嘱子类导入";
		var url='DHCCLInputItemCatData.csp';
		addTab(tabTitle,url);
	});
	$('#clickinputarcim').click(function(){
		var tabTitle="医嘱药品导入";
		var url='DHCCLInputArcimData.csp';
		addTab(tabTitle,url);
	});
	$('#clickinputlabtestcode').click(function(){
		var tabTitle="检验项目导入";
		var url='DHCCLInputTestCodeData.csp';
		addTab(tabTitle,url);
	});
	$('#clickinputlabspecimen').click(function(){
		var tabTitle="检验标本类型导入";
		var url='DHCCLInputSpecimenData.csp';
		addTab(tabTitle,url);
	});
	function addTabFisrt(subtitle,url){
		if (!$('#tabs').tabs('exists',subtitle)){
			$('#tabs').tabs('add',{
				title:subtitle,
				content:createFrame(url),
				closable:false
			})
		}
		else {
			$('#tabs').tabs('select',subtitle);
		}
	}	
	function addTab(subtitle,url){
		if (!$('#tabs').tabs('exists',subtitle)){
			$('#tabs').tabs('add',{
				title:subtitle,
				content:createFrame(url),
				closable:true
			})
		}
		else {
			$('#tabs').tabs('select',subtitle);
		}
	}
	
	function createFrame(url){
		var s='<iframe name="mainFrame" scrolling="auto" frameborder="0" src="'+url+'" style="width:100%;height:100%;"></iframe>';
		return s;
	}
})
