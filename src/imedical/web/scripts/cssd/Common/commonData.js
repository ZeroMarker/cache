// 包属性
var PackTypeDetailData = [
	{ 'RowId': 1, 'Description': $g('标牌追溯包') },
	{ 'RowId': 2, 'Description': $g('普通循环包') },
	{ 'RowId': 7, 'Description': $g('非循环包') }
	// { 'RowId': 10, 'Description': $g('专科器械包') },
	// { 'RowId': 3, 'Description': $g('清洗架') },
	// {"RowId":4, "Description":$g("清洗车")},
	// {"RowId":5, "Description":$g("灭菌筐")},
	// { 'RowId': 6, 'Description': $g('灭菌架') }
];
// 消毒包包装材料包属性调用
var PackTypeMData = [
	{ 'RowId': 1, 'Description': $g('标牌追溯包') },
	{ 'RowId': 2, 'Description': $g('普通循环包') },
	{ 'RowId': 7, 'Description': $g('非循环包') }
	//, { 'RowId': 10, 'Description': $g('专科器械包') }
];
// 标牌编码生成包属性调用
var PackTypeCodeData = [
	{ 'RowId': 1, 'Description': $g('标牌追溯包') },
	{ 'RowId': 3, 'Description': $g('清洗架') },
	{ 'RowId': 6, 'Description': $g('灭菌架') }
];

var NotUseData = [
	{ 'RowId': '', 'Description': $g('全部') },
	{ 'RowId': 'Y', 'Description': $g('可用') },
	{ 'RowId': 'N', 'Description': $g('不可用') }
];

var NotUseFlagData = [
	{ 'RowId': 'Y', 'Description': $g('是') },
	{ 'RowId': 'N', 'Description': $g('否') }
];
function UseFlagRenderer(value) {
	var Desc = value;
	if (value === 'Y') {
		Desc = $g('是');
	} else if (value === 'N') {
		Desc = $g('否');
	}
	return Desc;
}

var LeakData = [
	{ 'RowId': '1', 'Description': $g('每天') },
	{ 'RowId': '2', 'Description': $g('每周') },
	{ 'RowId': '3', 'Description': $g('每月') }
];

var PeriodData = [
	{ 'RowId': '0', 'Description': $g('每批') },
	{ 'RowId': '1', 'Description': $g('每天') },
	{ 'RowId': '2', 'Description': $g('每周') },
	{ 'RowId': '3', 'Description': $g('每月') }
];

var MachineTypeDataSearch = [
	{ 'RowId': '', 'Description': $g('全部') },
	{ 'RowId': 'sterilizer', 'Description': $g('灭菌器') },
	{ 'RowId': 'washer', 'Description': $g('清洗机') }
];

var MachineTypeData = [
	{ 'RowId': 'sterilizer', 'Description': $g('灭菌器') },
	{ 'RowId': 'washer', 'Description': $g('清洗机') }
];

var SexData = [
	{ 'RowId': '1', 'Description': $g('男') },
	{ 'RowId': '2', 'Description': $g('女') }
];
function SexRenderer(value) {
	var Desc = value;
	if (value === '1') {
		Desc = $g('男');
	} else if (value === '2') {
		Desc = $g('女');
	}
	return Desc;
}
var MachineVenData = [
	{ 'RowId': 'WL', 'Description': $g('外来厂商') },
	{ 'RowId': 'SW', 'Description': $g('机器厂商') }
];

var ReqTypeData = [
	{ 'RowId': '0', 'Description': $g('回收申请单') },
	{ 'RowId': '1', 'Description': $g('借包单') },
	{ 'RowId': '2', 'Description': $g('非循环包申请单') },
	{ 'RowId': '4', 'Description': $g('归还单') }
	// { 'RowId': '5', 'Description': $g('手术申请单') }
];

var ReqTypeAllData = [
	{ 'RowId': '', 'Description': $g('全部') },
	{ 'RowId': '0', 'Description': $g('回收申请单') },
	{ 'RowId': '1', 'Description': $g('借包单') },
	{ 'RowId': '2', 'Description': $g('非循环包申请单') },
	{ 'RowId': '4', 'Description': $g('归还单') }
	// { 'RowId': '5', 'Description': $g('手术申请单') }
];

function ReqTypeRenderer(value) {
	var Desc = value;
	if (value === '0') {
		Desc = $g('回收申请单');
	} else if (value === '1') {
		Desc = $g('借包单');
	} else if (value === '2') {
		Desc = $g('非循环包申请单');
	} else if (value === '4') {
		Desc = $g('归还单');
	} /* else if (value === '5') {
		Desc = $g('手术申请单');
	}*/
	return Desc;
}

var ReqLevelData = [
	{ 'RowId': '0', 'Description': $g('一般') },
	{ 'RowId': '1', 'Description': $g('紧急') }
];

var ReqLevelAllData = [
	{ 'RowId': '', 'Description': $g('全部') },
	{ 'RowId': '0', 'Description': $g('一般') },
	{ 'RowId': '1', 'Description': $g('紧急') }
];
function ReqLevelRenderer(value) {
	var Desc = value;
	if (value === '0') {
		Desc = $g('一般');
	} else if (value === '1') {
		Desc = $g('紧急');
	}
	return Desc;
}
var ReqStatusAllData = [
	{ 'RowId': '', 'Description': $g('全部') },
	{ 'RowId': '0', 'Description': $g('未提交') },
	{ 'RowId': '1', 'Description': $g('提交') },
	{ 'RowId': '2', 'Description': $g('回收') },
	{ 'RowId': '3', 'Description': $g('发放') },
	{ 'RowId': '5', 'Description': $g('确认') },
	{ 'RowId': '6', 'Description': $g('接收') },
	{ 'RowId': '7', 'Description': $g('归还') },
	{ 'RowId': '8', 'Description': $g('拒绝') }
];

function ReqStatusRenderer(value) {
	var Desc = value;
	if (value === '0') {
		Desc = $g('未提交');
	} else if (value === '1') {
		Desc = $g('提交');
	} else if (value === '2') {
		Desc = $g('回收');
	} else if (value === '3') {
		Desc = $g('发放');
	} else if (value === '5') {
		Desc = $g('确认');
	} else if (value === '6') {
		Desc = $g('接收');
	} else if (value === '7') {
		Desc = $g('归还');
	} else if (value === '8') {
		Desc = $g('拒绝');
	}
	return Desc;
}

var PackageStatusData = [
	{ 'RowId': 'P', 'Description': $g('已配包') },
	{ 'RowId': 'SP', 'Description': $g('灭菌中') },
	{ 'RowId': 'S', 'Description': $g('已灭菌') },
	{ 'RowId': 'D', 'Description': $g('已发放') },
	{ 'RowId': 'R', 'Description': $g('已接收') },
	{ 'RowId': 'U', 'Description': $g('已使用') },
	{ 'RowId': 'C', 'Description': $g('已回收') },
	{ 'RowId': 'TC', 'Description': $g('已过期处理') }
];

function PkgStatusRenderer(value) {
	var Desc = value;
	if (value === 'B') {
		Desc = $g('登记');
	} else if (value === 'W') {
		Desc = $g('已清洗');
	} else if (value === 'P') {
		Desc = $g('已配包');
	} else if (value === 'S') {
		Desc = $g('已灭菌');
	} else if (value === 'D') {
		Desc = $g('已发放');
	} else if (value === 'R') {
		Desc = $g('已接收');
	} else if (value === 'U') {
		Desc = $g('已使用');
	} else if (value === 'C') {
		Desc = $g('已回收');
	} else if (value === 'SW') {
		Desc = $g('二次清洗');
	} else if (value === 'SS') {
		Desc = $g('高水平消毒');
	} else if (value === 'TC') {
		Desc = $g('已过期处理');
	} else if (value === 'RC') {
		Desc = $g('已召回处理');
	} else if (value === 'SP') {
		Desc = $g('灭菌中');
	} else if (value === 'T') {
		Desc = $g('移交');
	} else if (value === 'G') {
		Desc = $g('已领用');
	}
	return Desc;
}

var OperatorTypeData = [
	{ 'RowId': '1', 'Description': $g('急诊手术') },
	{ 'RowId': '0', 'Description': $g('择期手术') }
];
function OperatorTypRenderer(value) {
	var Desc = value;
	if (value === '1') {
		Desc = $g('急诊手术');
	} else if (value === '0') {
		Desc = $g('择期手术');
	}
	return Desc;
}

var DateTypeData = [
	{ 'RowId': '1', 'Description': $g('当天') },
	{ 'RowId': '2', 'Description': $g('本周') },
	{ 'RowId': '3', 'Description': $g('本月') },
	{ 'RowId': '4', 'Description': $g('本季度') },
	{ 'RowId': '5', 'Description': $g('今年') }
];

var LendStateData = [
	{ 'RowId': '', 'Description': $g('全部') },
	{ 'RowId': '0', 'Description': $g('未归还') },
	{ 'RowId': '1', 'Description': $g('已归还') }
];

var SterilizerData = [
	{ 'RowId': 'MJ-SHINVA4000', 'Description': 'MJ-SHINVA4000' },	// SHINVA新华医疗-4000
	{ 'RowId': 'MJ-SHINVA5000', 'Description': 'MJ-SHINVA5000' },	// SHINVA新华医疗-5000
	{ 'RowId': 'MJ-SHINVAPS', 'Description': 'MJ-SHINVAPS' },	// SHINVA新华医疗-等离子
	{ 'RowId': 'MJ-SHINVAEO', 'Description': 'MJ-SHINVAEO' }	// SHINVA新华医疗-环氧乙烷
];

var WasherData = [
	{ 'RowId': 'QX-SHINVAWS', 'Description': 'QX-SHINVAWS' },	// SHINVA新华医疗-负压
	{ 'RowId': 'QX-SHINVASB', 'Description': 'QX-SHINVASB' },	// SHINVA新华医疗-6000（单舱）
	{ 'RowId': 'QX-SHINVAMB', 'Description': 'QX-SHINVAMB' },	// SHINVA新华医疗-多舱
	{ 'RowId': 'QX-SHINVAOC', 'Description': 'QX-SHINVAOC' }	// SHINVA新华医疗-外车
];
var InfectData = [
	{ 'RowId': '乙肝', 'Description': $g('乙肝') },
	{ 'RowId': '艾滋', 'Description': $g('艾滋') }
];

var StockFlagData = [
	{ 'RowId': '', 'Description': $g('全部') },
	{ 'RowId': 'O', 'Description': $g('已出库') },
	{ 'RowId': 'I', 'Description': $g('已入库') }
];
// 日常监测
var PackCheckData = [
	{ 'RowId': '1', 'Description': $g('合格') },
	{ 'RowId': '2', 'Description': $g('不合格') }
];

var PropertyData = [
	{ 'RowId': '1', 'Description': $g('正常') },
	{ 'RowId': '2', 'Description': $g('异常') }
];

var CheckMaterialData = [
	{ 'RowId': '1', 'Description': $g('破损') },
	{ 'RowId': '2', 'Description': $g('包装错误') }
];

var PreciseProtectData = [
	{ 'RowId': '1', 'Description': $g('未保护') },
	{ 'RowId': '2', 'Description': $g('保护不规范') }
];

var CardoProtectData = [
	{ 'RowId': '1', 'Description': $g('轴节未打开') },
	{ 'RowId': '2', 'Description': $g('未保护') },
	{ 'RowId': '3', 'Description': $g('保护不规范') }
];

var CheCardData = [
	{ 'RowId': '1', 'Description': $g('无包内卡') },
	{ 'RowId': '2', 'Description': $g('放置位置错误') }
];

var WidthData = [
	{ 'RowId': '1', 'Description': '<6mm' }
];

var DistanceData = [
	{ 'RowId': '1', 'Description': '≤2.5cm' }
];

var TapeTooShortData = [
	{ 'RowId': '1', 'Description': $g('过短') },
	{ 'RowId': '2', 'Description': $g('过长') }
];

var IncompleteCloseData = [
	{ 'RowId': '1', 'Description': $g('闭合不完整') },
	{ 'RowId': '2', 'Description': $g('包装不美观') }
];

var SixMarksData = [
	{ 'RowId': '1', 'Description': $g('无标识') },
	{ 'RowId': '2', 'Description': $g('不完整') }
];

var VolumeData = [
	{ 'RowId': '1', 'Description': $g('过大') }
];

var WeightInstrusData = [
	{ 'RowId': '1', 'Description': $g('超重') }
];
var CurLocationData = [
	{ 'RowId': 'CallBack', 'Description': $g('回收区') },
	{ 'RowId': 'Clean', 'Description': $g('清洗机') },
	{ 'RowId': 'Pack', 'Description': $g('打包区') },
	{ 'RowId': 'Ster', 'Description': $g('灭菌器') },
	{ 'RowId': 'Disp', 'Description': $g('无菌区') }
];