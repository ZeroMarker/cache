/// ��ʿ�޸ķּ�����
showNurWin = function(EmPCLvID){
	
	/*
	if ($("#newNurWin").is(":visible")){
		return;
	}  //���崦�ڴ�״̬,�˳�
	*/

	/// �ּ����ԭ��
	var url = LINK_CSP+"?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonEmDocUpdReson&HospID="+LgHospID+"&Type=Nur";
	var option = {
		panelHeight:"auto",
		blurValidValue:true,
		onSelect:function(record){
	        //setEmRecLevel();
	        }
		}
	new ListCombobox("EmNurRea",url,'',option).init(); 
	
	/// ��ʿ�޸ķּ�����
	var option = {
		iconCls:'icon-w-paper', //hxy 2022-07-29
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:true,
		closed:"true"
	};
	
	new WindowUX('��ʿ�޸ķּ�', 'newNurWin', '400', '150', option).Init();
}