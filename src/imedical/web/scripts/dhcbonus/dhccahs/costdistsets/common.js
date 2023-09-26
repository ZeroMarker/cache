function formatNum(val){
	//alert(val);
	var flag=false;
	if(val<0){
		flag=true;
	}
	val = xf(val,2);

	var digit = val.indexOf("."); // 取得小数点的位置
	var int = val.substr(0,digit); // 取得小数中的整数部分
	var minusFlag = 0;
	if (val.indexOf("-") != -1) { //负数时
		minusFlag = 1;
		int = int.substr(1,int.length-1); // 取得负数中的负号后部分
	}
	var i;
	var mag = new Array();
	var word;
	if (val.indexOf(".") == -1) { // 整数时
		i = val.length; // 整数的个数
		while(i > 0) {
			word = val.substring(i,i-3); // 每隔3位截取一组数字
			i-= 3;
			mag.unshift(word); // 分别将截取的数字压入数组
		}
		val = mag;
	}
	else{ // 小数时
		i = int.length; // 除小数外，整数部分的个数
	while(i > 0) {
		word = int.substring(i,i-3); // 每隔3位截取一组数字
		i-= 3;
		mag.unshift(word);
	}
		val = mag + val.substring(digit);
	}
	if (minusFlag == 1) { //负数时
		val = '-' + val;
	}
	var result="";
	if(flag){
		result="<div align=\"right\"><font color=\"red\">"+val+"</font></div>";
	}else{
		result="<div align=\"right\">"+val+"</div>";
	}
	return result;
}
function xf(Str,nAfterDotParam)
{
	var Str = Str.toString();
	var dot = Str.indexOf(".");
	var Strlength = Str.length;

	if(nAfterDotParam<=0)
	{
		return Str;
	}
	if(dot==-1)
	{
		Str+=".";
		for(i=0;i<nAfterDotParam;i++)
		{
			Str +="0";
		}
	}
	else
	{
		var strArray = Str.split(".");
		if(strArray[1].length <nAfterDotParam)
		{
			for(i=0;i<nAfterDotParam-strArray[1].length;i++)
			{
				Str += "0";
			}
		}
		else
		{
			var x =1;
			for(i=0;i<nAfterDotParam;i++)
			{
				x=x*10;
			}
			Str = (Math.round(parseFloat(Str*x))/x).toString();

		}
	}
	return Str;
}

function color(val)
{
	 return "<font color=#0066CC>"+val+"</font>";
	
}

