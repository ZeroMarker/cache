///chz 2016��6��13�� 15:04:56
var lunarInfo=new Array(0x04bd8,0x04ae0,0x0a570,0x054d5,0x0d260,0x0d950,0x16554,0x056a0,0x09ad0,0x055d2,0x04ae0,0x0a5b6,0x0a4d0,0x0d250,0x1d255,0x0b540,0x0d6a0,0x0ada2,0x095b0,0x14977,0x04970,0x0a4b0,0x0b4b5,0x06a50,0x06d40,0x1ab54,0x02b60,0x09570,0x052f2,0x04970,0x06566,0x0d4a0,0x0ea50,0x06e95,0x05ad0,0x02b60,0x186e3,0x092e0,0x1c8d7,0x0c950,0x0d4a0,0x1d8a6,0x0b550,0x056a0,0x1a5b4,0x025d0,0x092d0,0x0d2b2,0x0a950,0x0b557,0x06ca0,0x0b550,0x15355,0x04da0,0x0a5d0,0x14573,0x052d0,0x0a9a8,0x0e950,0x06aa0,0x0aea6,0x0ab50,0x04b60,0x0aae4,0x0a570,0x05260,0x0f263,0x0d950,0x05b57,0x056a0,0x096d0,0x04dd5,0x04ad0,0x0a4d0,0x0d4d4,0x0d250,0x0d558,0x0b540,0x0b5a0,0x195a6,0x095b0,0x049b0,0x0a974,0x0a4b0,0x0b27a,0x06a50,0x06d40,0x0af46,0x0ab60,0x09570,0x04af5,0x04970,0x064b0,0x074a3,0x0ea50,0x06b58,0x055c0,0x0ab60,0x096d5,0x092e0,0x0c960,0x0d954,0x0d4a0,0x0da50,0x07552,0x056a0,0x0abb7,0x025d0,0x092d0,0x0cab5,0x0a950,0x0b4a0,0x0baa4,0x0ad50,0x055d9,0x04ba0,0x0a5b0,0x15176,0x052b0,0x0a930,0x07954,0x06aa0,0x0ad50,0x05b52,0x04b60,0x0a6e6,0x0a4e0,0x0d260,0x0ea65,0x0d530,0x05aa0,0x076a3,0x096d0,0x04bd7,0x04ad0,0x0a4d0,0x1d0b6,0x0d250,0x0d520,0x0dd45,0x0b5a0,0x056d0,0x055b2,0x049b0,0x0a577,0x0a4b0,0x0aa50,0x1b255,0x06d20,0x0ada0);
var str="��һ�����������߰˾�ʮ";
var now=new Date(),SY=now.getFullYear(),SM=now.getMonth(),SD=now.getDate();
var SW=now.getDay();
var lDObj=new Lunar(now);
var LM=lDObj.month;
var LD=lDObj.day;
function cyclical(num){
	var Gan="���ұ����켺�����ɹ�";
	var Zhi="�ӳ���î������δ�����纥";
	return(Gan.charAt(num%10)+Zhi.charAt(num%12));
}
function lYearDays(y){
   var i,sum=348;
   for(i=0x8000;i>0x8;i>>=1)sum+=(lunarInfo[y-1900]&i)?1:0;
   return sum+leapDays(y);
}
function leapDays(y){if(leapMonth(y))return (lunarInfo[y-1900]&0x10000)?30:29;else return(0);}
function leapMonth(y){return lunarInfo[y-1900]&0xf;}
function monthDays(y,m){return (lunarInfo[y-1900]&(0x10000>>m))?30:29;}
function Lunar(objDate){
	var i,leap=0,temp=0;
	var baseDate=new Date(1900,0,31);
	var offset=(objDate-baseDate)/86400000;
	this.dayCyl=offset+40;
	this.monCyl=14;
	for(i=1900;i<2050&&offset>0;i++){
		temp=lYearDays(i);
		offset-=temp;
		this.monCyl+=12;
	}
	if(offset<0){
		offset+=temp;
		i--;
		this.monCyl-=12;
	}
	this.year=i;
	this.yearCyl=i-1864;
	leap=leapMonth(i);
	this.isLeap=false
	for(i=1;i<13&&offset>0;i++){
		if(leap>0&&i==(leap+1)&&this.isLeap==false){
			--i;
			this.isLeap=true;
			temp=leapDays(this.year);
		}else{
			temp=monthDays(this.year,i);
		}
		if(this.isLeap==true&&i==(leap+1))this.isLeap=false;
		offset-=temp;
		if(this.isLeap==false)this.monCyl++;
	}
	if(offset==0&&leap>0&&i==leap+1)if(this.isLeap){
		this.isLeap=false;
	}else{
		--i;
		this.isLeap=true;
		--this.monCyl;
	}
	if(offset<0){offset+=temp;--i;--this.monCyl;}
	this.month=i;
	this.day=offset+1;
}
function YYMMDD(){ 
	var cl = '<font color="#333333">'; 
	if (SW == 0) cl = '<font color="#c00000">'; 
	if (SW == 6) cl = '<font color="#00c000">';
	//return(cl+SY+'��'+(SM+1)+'��'+SD+'��</font>'); 
	return((SM+1)+'��'+SD+'��'); 
}
function weekday(){ 
	var cl='<font color="#333333">'; 
	if (SW==0||SW==6)cl='<font color="#ff0000">';
	return cl+"����"+str.charAt(SW)+'</font>';
}
function cDay(m,d){
	var nStr="��ʮإئ��",s;
	if(m>10)s='ʮ'+str.charAt(m-10);else s=str.charAt(m);
	s+='��';
	switch(d){
		case 10:s+='��ʮ';break;
		case 20:s+='��ʮ';break;
		case 30:s+='��ʮ';break;
		default:s+=nStr.charAt(Math.floor(d/10));s+=str.charAt(d%10);
	}
	if(lDObj.isLeap)s="��"+s;
	return(s);
}
function lunarTime(){
	return('<font color="#006600">'+cyclical(SY-4)+'�� '+cDay(LM,LD)+'</font>');
}
function specialDate(){
	var sTermInfo=new Array(0,21208,42467,63836,85337,107014,128867,150921,173149,195551,218072,240693,263343,285989,308563,331033,353350,375494,397447,419210,440795,462224,483532,504758);
	var solarTerm=new Array("С��","��","����","��ˮ","����","����","����","����","����","С��","â��","����","С��","����","����","����","��¶","���","��¶","˪��","����","Сѩ","��ѩ","����");
	var lFtv="0101����0115Ԫ����0505�����0707��Ϧ���˽�0715��Ԫ��0815�����0909������1208���˽�1224С��0100��Ϧ";
	var sFtv="0101Ԫ��0214���˽�0308��Ů��0312ֲ����0315������Ȩ����0401���˽�0501�Ͷ���0504�����0512��ʿ��0601��ͯ��0701��������ۻع����0801������0808���׽�0909ë��ϯ��������0910��ʦ��0928���ӵ���1001�����1006���˽�1024���Ϲ���1112����ɽ����1220���Żع����1225ʥ����1226ë��ϯ����";
	var tmp1,tmp2,festival='';
	tmp1=new Date((31556925974.7*(SY-1900)+sTermInfo[SM*2+1]*60000)+Date.UTC(1900,0,6,2,5));
	tmp2=tmp1.getUTCDate();
	if(tmp2==SD)festival+=' <font color="#ff6600">���ս�����'+solarTerm[SM*2+1]+'</font>';
	tmp1=new Date((31556925974.7*(SY-1900)+sTermInfo[SM*2]*60000)+Date.UTC(1900,0,6,2,5));
	tmp2=tmp1.getUTCDate();
	if(tmp2==SD)festival+=' <font color="#ff6600">���ս�����'+solarTerm[SM*2]+'</font>';
	var reg=new RegExp((LM<10&&"0"||"")+LM+(LD<10&&"0"||"")+LD+'([^\\d]+)','');
	if(lFtv.match(reg)!=null)festival+=' <font color="#ff0000">'+RegExp.$1+'</font>';
	reg=new RegExp((SM<9&&"0"||"")+(SM+1)+(SD<10&&"0"||"")+SD+'([^\\d]+)','');
	if(sFtv.match(reg)!=null)festival+=' <font color="#ff0000">'+RegExp.$1+'</font>';
	return(festival);
}
function getBannerUrl(){
	var calendar = YYMMDD();
	var lunar = cDay(LM,LD);
	//alert(calendar + lunar);
	var bannerClassName = "";
	//Ԫ��
	if(calendar=="1��1��" || calendar=="1��2��" || calendar=="1��3��" )
	{
		bannerClassName = "YD";
		//alert("Ԫ������!");
	}
	//����
	else if(lunar=="һ�³�һ" || lunar=="һ�³���" || lunar=="һ�³���" || lunar=="һ�³���" || lunar=="һ�³���" || lunar=="һ�³���" || lunar=="һ�³���")
	{
		bannerClassName = "CJ";
		//alert("���ڿ���!");
	}
	//����
	else if(lunar=="���³���" || lunar=="���³���" || lunar=="���³���" )
	{
		bannerClassName = "DW";
	}
	//�Ͷ���
	else if(calendar=="5��1��" || calendar=="5��2��" || calendar=="5��3��")
	{
		bannerClassName = "LD";
	}
	//����
	else if(lunar=="����ʮ��" || lunar=="����ʮ��" || lunar=="����ʮ��" || lunar=="����ʮ��")
	{
		bannerClassName = "ZQ";
		//alert("�������!");
	}
	//����
	else if(calendar=="10��1��" || calendar=="10��2��" || calendar=="10��3��" || calendar=="10��4��" || calendar=="10��5��"  || calendar=="10��6��" || calendar=="10��7��")
	{
		bannerClassName = "GQ";
		//alert("�������!");
	} 
	return bannerClassName;
}