///������,ת�Ƴ������,ת��������,���������,��汨�����,�˻����

///�����ϸ���ָ�ֵ������������
///Return: false ���һ��ά��; true �����������
function CheckHighValueLabels(type,main){
	var url = "dhcstm.itmtrackaction.csp?actiontype=CheckLabelsByPointer&Type="+type+"&Main="+main;
	var result=ExecuteDBSynAccess(url);
	var info=Ext.util.JSON.decode(result).info;		//��ֵ���������жϽ��
	if(info!=""){
		Msg.info("error","��ֵ���� "+info+" û��¼�������¼����������������������!")
		return false;
	}
	return true;
}
