function formatNum(val){
	//alert(val);
	var flag=false;
	if(val<0){
		flag=true;
	}
	val = xf(val,2);

	var digit = val.indexOf("."); // ȡ��С�����λ��
	var int = val.substr(0,digit); // ȡ��С���е���������
	var minusFlag = 0;
	if (val.indexOf("-") != -1) { //����ʱ
		minusFlag = 1;
		int = int.substr(1,int.length-1); // ȡ�ø����еĸ��ź󲿷�
	}
	var i;
	var mag = new Array();
	var word;
	if (val.indexOf(".") == -1) { // ����ʱ
		i = val.length; // �����ĸ���
		while(i > 0) {
			word = val.substring(i,i-3); // ÿ��3λ��ȡһ������
			i-= 3;
			mag.unshift(word); // �ֱ𽫽�ȡ������ѹ������
		}
		val = mag;
	}
	else{ // С��ʱ
		i = int.length; // ��С���⣬�������ֵĸ���
	while(i > 0) {
		word = int.substring(i,i-3); // ÿ��3λ��ȡһ������
		i-= 3;
		mag.unshift(word);
	}
		val = mag + val.substring(digit);
	}
	if (minusFlag == 1) { //����ʱ
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

