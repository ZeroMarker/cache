///������,ת�Ƴ������,ת��������,���������,��汨�����,�˻����

///�����ϸ���ָ�ֵ������������
///Return: false ���һ��ά��; true �����������
function CheckHighValueLabels(type,main){
	var info=tkMakeServerCall("web.DHCSTMHUI.DHCItmTrack","CheckLabelsByPointer",type,main)
	if(info!=""){
		Msg.info("error","��ֵ���� "+info+" û��¼�������¼����������������������!")
		return false;
	}
	return true;
}
