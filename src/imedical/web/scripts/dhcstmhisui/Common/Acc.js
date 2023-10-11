//˵����javascript�ĳ˷������������������������˵�ʱ���Ƚ����ԡ�����������ؽ�Ϊ��ȷ�ĳ˷������
//���ã�accMul(arg1,arg2)
//����ֵ��arg1����arg2�ľ�ȷ���
function accMul(arg1,arg2) {
	if(AccIsEmpty(arg1) || AccIsEmpty(arg2)){
		return '';
	}
	var m=0,s1=arg1.toString(),s2=arg2.toString();
	try{m+=s1.split(".")[1].length}catch(e){}
	try{m+=s2.split(".")[1].length}catch(e){}
	return Number(s1.replace(".",""))*Number(s2.replace(".",""))/Math.pow(10,m);
}
//��Number��������һ��mul�����������������ӷ��㡣
Number.prototype.mul = function (arg){
	return accMul(arg, this);
}

//����:2014-07-31 ����accMul��дaccDiv
//˵����javascript�ĳ�����������������������������ʱ���Ƚ����ԡ�����������ؽ�Ϊ��ȷ�ĳ��������
//���ã�accDiv(arg1,arg2)
//����ֵ��arg1����arg2�ľ�ȷ���
function accDiv(arg1,arg2){
	if(AccIsEmpty(arg1) || AccIsEmpty(arg2)){
		return '';
	}
	var t1=0,t2=0,r1,r2;
	try{t1=arg1.toString().split(".")[1].length}catch(e){}
	try{t2=arg2.toString().split(".")[1].length}catch(e){}

	with(Math){
		var m = pow(10,t1+t2);
		r1 = accMul(arg1, m);
		r2 = accMul(arg2, m);
		return r1/r2;
	}
}

//��Number��������һ��div�����������������ӷ��㡣
Number.prototype.div = function (arg){
	return accDiv(this, arg);
}

//�ӷ������������õ���ȷ�ļӷ����
//˵����javascript�ļӷ������������������������ӵ�ʱ���Ƚ����ԡ�����������ؽ�Ϊ��ȷ�ļӷ������
//���ã�accAdd(arg1,arg2)
//����ֵ��arg1����arg2�ľ�ȷ���
function accAdd(arg1,arg2){
	var r1,r2,m;
	try{r1=arg1.toString().split(".")[1].length}catch(e){r1=0}
	try{r2=arg2.toString().split(".")[1].length}catch(e){r2=0}
	m = Math.pow(10,r1+r2);
	return (accMul(arg1,m)+accMul(arg2,m))/m;
}

//��Number��������һ��add�����������������ӷ��㡣
Number.prototype.add = function (arg){
	return accAdd(arg,this);
}

//����accMul,accDiv��д����(ֱ��accAdd(arg1,-arg2)���и�������λС��������)
//���ã�accSub(arg1,arg2)
//����ֵ��arg1��ȥarg2�ľ�ȷ���
function accSub(arg1,arg2){
	var r1,r2,m;
	try{r1=arg1.toString().split(".")[1].length}catch(e){r1=0}
	try{r2=arg2.toString().split(".")[1].length}catch(e){r2=0}
	m = Math.pow(10,r1+r2);
	var n = accMul(arg1,m)-accMul(arg2,m);
	return accDiv(n,m);
}

Number.prototype.sub = function(arg){
	return accSub(this, arg);
}

function AccIsEmpty(v){
	return v === null || v === undefined || v === '';
}