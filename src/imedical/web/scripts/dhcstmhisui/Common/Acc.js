//说明：javascript的乘法结果会有误差，在两个浮点数相乘的时候会比较明显。这个函数返回较为精确的乘法结果。
//调用：accMul(arg1,arg2)
//返回值：arg1乘以arg2的精确结果
function accMul(arg1,arg2) {
	if(AccIsEmpty(arg1) || AccIsEmpty(arg2)){
		return '';
	}
	var m=0,s1=arg1.toString(),s2=arg2.toString();
	try{m+=s1.split(".")[1].length}catch(e){}
	try{m+=s2.split(".")[1].length}catch(e){}
	return Number(s1.replace(".",""))*Number(s2.replace(".",""))/Math.pow(10,m);
}
//给Number类型增加一个mul方法，调用起来更加方便。
Number.prototype.mul = function (arg){
	return accMul(arg, this);
}

//除法:2014-07-31 利用accMul重写accDiv
//说明：javascript的除法结果会有误差，在两个浮点数相除的时候会比较明显。这个函数返回较为精确的除法结果。
//调用：accDiv(arg1,arg2)
//返回值：arg1除以arg2的精确结果
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

//给Number类型增加一个div方法，调用起来更加方便。
Number.prototype.div = function (arg){
	return accDiv(this, arg);
}

//加法函数，用来得到精确的加法结果
//说明：javascript的加法结果会有误差，在两个浮点数相加的时候会比较明显。这个函数返回较为精确的加法结果。
//调用：accAdd(arg1,arg2)
//返回值：arg1加上arg2的精确结果
function accAdd(arg1,arg2){
	var r1,r2,m;
	try{r1=arg1.toString().split(".")[1].length}catch(e){r1=0}
	try{r2=arg2.toString().split(".")[1].length}catch(e){r2=0}
	m = Math.pow(10,r1+r2);
	return (accMul(arg1,m)+accMul(arg2,m))/m;
}

//给Number类型增加一个add方法，调用起来更加方便。
Number.prototype.add = function (arg){
	return accAdd(arg,this);
}

//利用accMul,accDiv重写减法(直接accAdd(arg1,-arg2)会有浮点计算多位小数的问题)
//调用：accSub(arg1,arg2)
//返回值：arg1减去arg2的精确结果
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