$(document).ready(function () {
    var tabTitle="�����ά��";
	var url='DHCCLCMappingService.csp';
	addTabFisrt(tabTitle,url);	
	/*$('#clickservice').click(function(){
		var tabTitle="�����ά��";
		var url='DHCCLCMappingService.csp';
		addTab(tabTitle,url);
	});*/
	$('#clickentity').click(function(){
		var tabTitle="ӳ��ʵ�����ά��";
		var url='DHCCLCMappingEntity.csp';
		addTab(tabTitle,url);
	});
	/*$('#clickcode').click(function(){
		var tabTitle="ӳ������ά��";
		var url='DHCCLCMappingCode.csp';
		addTab(tabTitle,url);
	});
	$('#clickrecord').click(function(){
		var tabTitle="ӳ��ҵ���ά��";
		var url='DHCCLMappingRecord.csp';
		addTab(tabTitle,url);
	});*/
	$('#clicklog').click(function(){
		var tabTitle="��־��ά��";
		var url='DHCCLMappingLog.csp';
		addTab(tabTitle,url);
	});
	$('#clickinputloc').click(function(){
		var tabTitle="���ұ���";
		var url='DHCCLInputLocData.csp';
		addTab(tabTitle,url);
	});
	$('#clickinputcarprvtp').click(function(){
		var tabTitle="ҽ����Ա���͵���";
		var url='DHCCLInputCarPrvTpData.csp';
		addTab(tabTitle,url);
	});
	$('#clickinputcareprov').click(function(){
		var tabTitle="ҽ����Ա����";
		var url='DHCCLInputCareProvData.csp';
		addTab(tabTitle,url);
	});
	$('#clickinputctuom').click(function(){
		var tabTitle="������λ����";
		var url='DHCCLInputCTUomData.csp';
		addTab(tabTitle,url);
	});
	$('#clickinputconfac').click(function(){
		var tabTitle="��λת������";
		var url='DHCCLInputConFacData.csp';
		addTab(tabTitle,url);
	});
	$('#clickinputfreq').click(function(){
		var tabTitle="Ƶ�α���";
		var url='DHCCLInputFreqData.csp';
		addTab(tabTitle,url);
	});
	$('#clickinputinstruct').click(function(){
		var tabTitle="�÷�����";
		var url='DHCCLInputInstructData.csp';
		addTab(tabTitle,url);
	});
	$('#clickinputitemcat').click(function(){
		var tabTitle="ҽ�����ർ��";
		var url='DHCCLInputItemCatData.csp';
		addTab(tabTitle,url);
	});
	$('#clickinputarcim').click(function(){
		var tabTitle="ҽ��ҩƷ����";
		var url='DHCCLInputArcimData.csp';
		addTab(tabTitle,url);
	});
	$('#clickinputlabtestcode').click(function(){
		var tabTitle="������Ŀ����";
		var url='DHCCLInputTestCodeData.csp';
		addTab(tabTitle,url);
	});
	$('#clickinputlabspecimen').click(function(){
		var tabTitle="����걾���͵���";
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
