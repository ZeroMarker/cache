
function TypeRenderer(val){
	switch(val){
		case 'A':	return '启用';break;
		case 'AO':	return '回收';break;
		case 'B':	return '发放';break;
		case 'BO':	return '内部停用';break;
		case 'R':	return '维修';break;
		case 'RO':	return '维修完成';break;
		case 'M':	return '保养';break;
		case 'MO':	return '保养完成';break;
		case 'D':	return '报废';break;
		case 'RR':	return '维修申请';break;
		case 'W':	return '损坏';break;
		default:	return val;
	}
}

function StatusRenderer(val){
	switch(val){
		case 'A':	return '启用';break;
		case 'S':	return '停用';break;
		case 'D':	return '报废';break;
		case 'M':	return '维修保养';break;
		default:	return val;
	}
}