//������������ǰ�¼�
function YearBefLoad(param) {
	param.flag = '';
	param.str = param.q;
}

//����Ԥ����ƣ��Աࣩ-�������������ǰ�¼���������
function selfDeptBefLoad(param) {
	param.hospid = hospid;
	param.userid = userid;
	param.str = param.q;
}

//����Ԥ�����-�������������ǰ�¼���������
function DeptSchemsBefLoad(param) {
	param.hospid = hospid;
	param.userid = userid;
	param.year = $('#yearcb').combobox('getValue');
	param.str = param.q;
}

