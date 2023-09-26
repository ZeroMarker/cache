
function TypeRenderer(val){
	switch(val){
		case 'A':	return '����';break;
		case 'AO':	return '����';break;
		case 'B':	return '����';break;
		case 'BO':	return '�ڲ�ͣ��';break;
		case 'R':	return 'ά��';break;
		case 'RO':	return 'ά�����';break;
		case 'M':	return '����';break;
		case 'MO':	return '�������';break;
		case 'D':	return '����';break;
		case 'RR':	return 'ά������';break;
		case 'W':	return '��';break;
		default:	return val;
	}
}

function StatusRenderer(val){
	switch(val){
		case 'A':	return '����';break;
		case 'S':	return 'ͣ��';break;
		case 'D':	return '����';break;
		case 'M':	return 'ά�ޱ���';break;
		default:	return val;
	}
}