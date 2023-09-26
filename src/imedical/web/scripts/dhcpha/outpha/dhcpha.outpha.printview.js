//dhcpha.outphap.printview.js
//门诊处方预览
var App_LogonHospDesc=tkMakeServerCall("web.DHCSTKUTIL","GetHospName",session['LOGON.HOSPID']);
function OutPrescView()
{
	var cyflag=tkMakeServerCall("web.DHCOutPhDispFY","CheckCyFlag",phdispid);
	if(cyflag=="1"){var htmlstr=OutPrescViewCY(phdispid);}
	else{var htmlstr=OutPrescViewXY(phdispid);}
	document.write(htmlstr)
	//return htmlstr
}
/// 处方阅览 [门诊草药]
function OutPrescViewCY(phd)
{
	//获取处方信息
	var mytrn=tkMakeServerCall("web.DHCOutPhDispFY","GetPrescInfoByPhd",phd);
	if(mytrn==""){
		alert('警告:提取处方信息出错！');
		return;}
	
	var SStr=mytrn.split("!!");
	var PatInfo=SStr[0]; //病人信息
	var DrgInfo=SStr[1]; //医嘱信息

	//病人信息
	var PatArr=PatInfo.split("^");
	var PrescNo=PatArr[29];   //处方号
	var AdmLoc=PatArr[16];    //科别
	var PatNo=PatArr[0];      //登记号
	var PatName=PatArr[1];    //病人姓名
	var PatAge=PatArr[2];     //年龄
	var PatSex=PatArr[3];     //性别
	var Patweight=PatArr[5];  //体重
	var DiagnoDesc=PatArr[4]; //诊断
	var OrdDate=PatArr[18];   //开方日期
	var tel=PatArr[19];       //电话
	var address=PatArr[20];   //地址
	var Doctor=PatArr[17];    //医生
	var PyName=PatArr[9];     //配药人
	var FyName=PatArr[10];    //发药人
	var PyDate=PatArr[11];    //配药日期
	var sumamt=PatArr[28];   //处方费用
	var queinst=PatArr[21];
	var quefac=PatArr[22];
	var queqty=PatArr[23];
	var quedate=PatArr[24];
	var quexdate=PatArr[25];
	var quenote=PatArr[26];
	var quecook=PatArr[27];
	var nbsp3='&nbsp;&nbsp;&nbsp;';

	//准备处方阅览的html
	var htmlstr="";
	//主DIV
	htmlstr=htmlstr+'<div style="margin:8px;width:750px;height:700px;border:1px solid #000000;background:#FFFFFF;">';  
	//标题
	htmlstr=htmlstr+'<div style="margin:10px 0px 10px 0px;width:750px;height:30px;" align="center">';
	htmlstr=htmlstr+'<span style="font-size:22pt;font-family:华文楷体;font-weight:bold;margin:0px 0px 5px 0px;">'+App_LogonHospDesc+'处方笺</span>';
	htmlstr=htmlstr+'</div>';
	//基本信息
	htmlstr=htmlstr+'<div style="width:750px;height:100px;margin:0px 0px 5px 0px">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 50px;" class="font16">处方号:</span><span class="btn-ui-width5 font16">&nbsp;'+PrescNo+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 180px;" class="font16">'+"科"+nbsp3+"别:"+'</span><span class="btn-ui-width6 font16">&nbsp;'+AdmLoc+'</span>';
	htmlstr=htmlstr+'</br>'; //换行
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 50px;" class="font16">'+"姓"+nbsp3+"名:"+'</span><span class="btn-ui-width2 font16">&nbsp;'+PatName+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 50px;" class="font16">'+"性"+nbsp3+"别:"+'</span><span style="width:40px;border-bottom:1px solid #000000;" class="font16">&nbsp;'+PatSex+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 50px;" class="font16">'+"年"+nbsp3+"龄:"+'</span><span style="width:100px;border-bottom:1px solid #000000;" class="font16">&nbsp;'+PatAge+'</span>';
	htmlstr=htmlstr+'</br>';
	
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 50px;" class="font16">'+"登记号:"+'</span><span class="btn-ui-width2 font16">&nbsp;'+PatNo+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 50px;" class="font16">'+"日"+nbsp3+"期:"+'</span><span class="btn-ui-width2 font16">&nbsp;'+OrdDate+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 40px;" class="font16">'+"电话:"+'</span><span style="width:130px;border-bottom:1px solid #000000;" class="font16">&nbsp;'+tel+'</span>';
	htmlstr=htmlstr+'</br>'; //换行
	
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 50px;" class="font16">'+"地"+nbsp3+"址:"+'</span><span style="width:580px;border-bottom:1px solid #000000;" class="font12">&nbsp;'+address+'</span>';
	htmlstr=htmlstr+'</br>'; //换行
	
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">'+"诊"+nbsp3+"断:"+'</span><span style="width:580px;border-bottom:1px solid #000000;" class="font12">&nbsp;'+DiagnoDesc+'</span>';
	htmlstr=htmlstr+'</br>'; //换行
	htmlstr=htmlstr+'</div>';
	
	//画线
	htmlstr=htmlstr+'<hr style="margin:0px 0px 0px 25px;background-color:black;height:3px;border:none;">'; 
	
	//医嘱信息
	htmlstr=htmlstr+'<div style="width:750px;height:400px;margin:0px 0px 0px 0px;">';
	htmlstr=htmlstr+'<span style="font-size:22pt;font-family:华文楷体;margin:0px 0px 0px 50px;">Rp:</span>';
	htmlstr=htmlstr+'</p>';
	
	//药品信息
	var DrgInfoArr=DrgInfo.split("@");
	var Len=DrgInfoArr.length;
	var index="";
	var col=2;
	var rowcol=col;
	var row=Math.ceil(Len/col);
	var lastrowcol=col;
	if(Len%col!=0){lastrowcol=Len%col;}
	for(var i=1;i<=row;i++)
	{
		if(i==row){rowcol=lastrowcol;}
		for(var n=1;n<=rowcol;n++)
		{
			var j=(i-1)*col+n-1;
			var MedArr=DrgInfoArr[j].split("^");
			var specinstr=MedArr[11];  //草药备注
			if(n==1){var px=110;}
			else{var px=130;}
			htmlstr=htmlstr+'<span style="margin:0px 0px 0px '+px+"px;width:200px;"+'" class="font12">'+specinstr+'</span>';
		}
		//htmlstr=htmlstr+'</p>';
		htmlstr=htmlstr+'</br>';
		if(i==row){rowcol=lastrowcol;}
		for(var n=1;n<=rowcol;n++)
		{
			var j=(i-1)*col+n-1;
			var MedArr=DrgInfoArr[j].split("^");
			var InciDesc=MedArr[0];  //名称
			var qty=MedArr[1]
			qty=qty/quefac;
			/*
			if(qty.indexOf(".")>-1)
			{
				qty=Number(qty).toFixed(2);
			}
			*/
			var QtyUom=qty+MedArr[2];     //数量+单位
			var freqCY=MedArr[12];
			if(n==1){var px=80;}
			else{var px=30;}
			htmlstr=htmlstr+'<span style="margin:0px 0px 0px '+px+"px;width:300px;"+'" class="font16">'+InciDesc+"&nbsp;"+"&nbsp;"+QtyUom+'</span>';
		}
		htmlstr=htmlstr+'</p>';
		htmlstr=htmlstr+'</br>';
	}
	
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;font-weight:bold;" class="font16">-------------------------(以下空白)-------------------------</span>';
	htmlstr=htmlstr+'</div>';
	PrescSingPrice=Number(sumamt/quefac).toFixed(2)
	var queinst=PatArr[21];
	var quefac=PatArr[22];
	var queqty=PatArr[23];
	var quedate=PatArr[24];
	var quexdate=PatArr[25];
	var quenote=PatArr[26];
	var quecook=PatArr[27];
	//处方尾部
	htmlstr=htmlstr+'<div style="width:750px;height:50px;margin:0px 0px 20px 0px;">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;font-weight:bold;" class="font16">用法:'+freqCY+"&nbsp;"+queinst+"&nbsp;"+queqty+"&nbsp;"+"&nbsp;"+"&nbsp;"+"共: "+quefac+" 剂"+"&nbsp;"+"&nbsp;"+"&nbsp;"+quecook+'</span>';
	htmlstr=htmlstr+'</br>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;font-weight:bold;" class="font16">金额:'+PrescSingPrice+"元"+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 340px;font-weight:bold;" class="font16">医生:'+Doctor+'</span>';
	htmlstr=htmlstr+'<hr style="background-color:black;height:3px;border:none;">'; //画线
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">审核:'+PyName+'</span>';
	htmlstr=htmlstr+'<span style="position:absolute;right:430px;" class="font16">核对:'+FyName+'</span>';
	htmlstr=htmlstr+'<span style="position:absolute;right:100px;" class="font16">日期:'+PyDate+'</span>';
	htmlstr=htmlstr+'</br>';

	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">调配:'+PyName+'</span>';
	htmlstr=htmlstr+'<span style="position:absolute;right:430px;" class="font16">发药:'+FyName+'</span>';
	htmlstr=htmlstr+'</div>';
	
	htmlstr=htmlstr+'</div>';
	return htmlstr;
}



/// 处方阅览 [门诊西药](福永)
function OutPrescViewXY(phd)
{
	//获取处方信息
	var mytrn=tkMakeServerCall("web.DHCOutPhDispFY","GetPrescInfoByPhd",phd);
	if(mytrn==""){
		alert('警告:提取处方信息出错！');
		return;}
	
	var SStr=mytrn.split("!!");
	var PatInfo=SStr[0]; //病人信息
	var DrgInfo=SStr[1]; //医嘱信息

	//病人信息
	var PatArr=PatInfo.split("^");
	var PrescNo=PatArr[29];   //处方号
	var AdmLoc=PatArr[16];    //科别
	var PatNo=PatArr[0];      //登记号
	var PatName=PatArr[1];    //病人姓名
	var PatAge=PatArr[2];     //年龄
	var PatSex=PatArr[3];     //性别
	var Patweight=PatArr[5];  //体重
	var DiagnoDesc=PatArr[4]; //诊断
	var OrdDate=PatArr[18];   //开方日期
	var tel=PatArr[19];       //电话
	var address=PatArr[20];   //地址
	var Doctor=PatArr[17];    //医生
	var PyName=PatArr[9];     //配药人
	var FyName=PatArr[10];    //发药人
	var PyDate=PatArr[11];    //配药日期
	var PrescSingPrice=PatArr[28]+"元";  //处方费用
	var presctype=PatArr[30]; //费别
	var cardno=PatArr[6];     //卡号
	var nbsp3='&nbsp;&nbsp;&nbsp;&nbsp;';

	//准备处方阅览的html
	var htmlstr="";
	//主DIV
	htmlstr=htmlstr+'<div style="margin:8px;width:750px;height:700px;border:1px solid #000000;background:#FFFFFF;">';  
	//标题
	htmlstr=htmlstr+'<div style="margin:10px 0px 10px 0px;width:750px;height:30px;" align="center">';
	htmlstr=htmlstr+'<span style="font-size:22pt;font-family:华文楷体;font-weight:bold;margin:0px 0px 5px 0px;">'+App_LogonHospDesc+'处方笺</span>';
	htmlstr=htmlstr+'</div>';
	//基本信息
	htmlstr=htmlstr+'<div style="width:750px;height:140px;margin:0px 0px 0px 0px">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 25px;" class="font16">'+"费别:"+'&nbsp;'+presctype+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">登记号:&nbsp;'+PatNo+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">处方号:&nbsp;'+PrescNo+'</span>';
	//画线
	//htmlstr=htmlstr+'<hr style="margin:0px 25px 0px 25px;background-color:black;height:3px;border:none;">';
	htmlstr=htmlstr+'</br>'; //换行
	//htmlstr=htmlstr+'</div>';
	//htmlstr=htmlstr+'<div style="width:750px;height:15px;margin:0px 0px 8px 0px">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 25px;" class="font16">'+"姓名:"+'</span><span class="btn-ui-width2 font16" style="width:140px;">&nbsp;'+PatName+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 0px;" class="font16">'+"性别:"+'</span><span style="width:60px;border-bottom:1px solid #000000;" class="font16">&nbsp;'+PatSex+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 0px;" class="font16">'+"年龄:"+'</span><span style="width:100px;border-bottom:1px solid #000000;" class="font16">&nbsp;'+PatAge+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 0px;" class="font16">'+"科别:"+'</span><span class="btn-ui-width6 font16">&nbsp;'+AdmLoc+'</span>';
	htmlstr=htmlstr+'</br>'; //换行
	//htmlstr=htmlstr+'</div>';
	//htmlstr=htmlstr+'<div style="width:750px;height:15px;margin:0px 0px 8px 0px">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 25px;" class="font16">'+"电话:"+'</span><span style="width:150px;border-bottom:1px solid #000000;" class="font16">&nbsp;'+tel+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 0px;" class="font16">'+"体重:"+'</span><span style="width:80px;border-bottom:1px solid #000000;" class="font16">&nbsp;'+Patweight+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 0px;" class="font16">'+"卡号:"+'</span><span style="width:150px;border-bottom:1px solid #000000;" class="font16">&nbsp;'+cardno+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 0px;" class="font16">'+"日期:"+'</span><span class="btn-ui-width2 font16">&nbsp;'+OrdDate+'</span>';
	htmlstr=htmlstr+'</br>'; //换行
	//htmlstr=htmlstr+'</div>';
	//htmlstr=htmlstr+'<div style="width:750px;height:15px;margin:0px 0px 8px 0px">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 25px;" class="font16">'+"地址:"+'</span><span style="width:650px;border-bottom:1px solid #000000;" class="font12">&nbsp;'+address+'</span>';
	htmlstr=htmlstr+'</br>'; //换行
	//htmlstr=htmlstr+'</div>';
	//htmlstr=htmlstr+'<div style="width:750px;height:15px;margin:0px 0px 8px 0px">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 25px;" class="font16">'+"诊断:"+'</span><span style="width:650px;border-bottom:1px solid #000000;" class="font12">&nbsp;'+DiagnoDesc+'</span>';
	htmlstr=htmlstr+'</br>'; //换行
	htmlstr=htmlstr+'</div>';
	//画线
	htmlstr=htmlstr+'<hr style="margin:0px 25px 0px 25px;background-color:black;height:3px;border:none;">'; 
	
	//医嘱信息
	htmlstr=htmlstr+'<div style="width:750px;height:400px;margin:0px 0px 0px 0px;">';
	htmlstr=htmlstr+'<span style="font-size:22pt;font-family:华文楷体;margin:0px 0px 0px 25px;">Rp:</span>';
	htmlstr=htmlstr+'</p>';
	
	//药品信息
	var DrgInfoArr=DrgInfo.split("@");
	var Len=DrgInfoArr.length;
	var index="";
	var lastmoeori="";
	var ordNo=0
	for(var i=0;i<Len;i++)
	{
		var MedArr=DrgInfoArr[i].split("^");
		var InciDesc=MedArr[0]; //品名		
		var QtyUom=MedArr[1]+MedArr[2];     //数量+单位
		var Durtion=MedArr[6]; //疗程		
		var Intrus=MedArr[4];  //用法
		var Dosage=MedArr[3];  //剂量
		var freq=MedArr[5];    //频次
		//var moeori=MedArr[13];  //主医嘱ID
		var spec=MedArr[13];   //规格
		var SeqFlag=MedArr[14];   //是否关联医嘱
		var moeori=MedArr[15];    //主医嘱ID
		var phdur=MedArr[16];    //疗程
		var nextseflag=0;
		var nextmoeori="";
		var m=Len-1;
		if(i!=m)
		{
			var nextdata=DrgInfoArr[i+1].split("^");
			var nextseflag=nextdata[14];
			var nextmoeori=nextdata[15];
		}
		//alert("SeqFlag="+SeqFlag+";lastmoeori="+lastmoeori+";moeori="+moeori)
		if(SeqFlag=="1")  
		{
			if(lastmoeori!=moeori)
			{
				ordNo=(parseInt(ordNo)+1)
				htmlstr=htmlstr+'</p>';
				htmlstr=htmlstr+'</br>';
				htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">'+ordNo+"、"+InciDesc+"("+spec+")"+'</span>';
				//htmlstr=htmlstr+'<span style="margin:0px 0px 0px 400px;" class="font16">'+'</span>';
				htmlstr=htmlstr+'<span style="position:absolute;right:100px;" class="font16">'+Dosage+nbsp3+"("+QtyUom+")"+'</span>';
			}
			else
			{
				htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">'+nbsp3+InciDesc+"("+spec+")"+'</span>';
				htmlstr=htmlstr+'<span style="position:absolute;right:100px;" class="font16">'+Dosage+nbsp3+"("+QtyUom+")"+'</span>';
			}
			htmlstr=htmlstr+'</br>';
			if((nextseflag!="1")||(nextmoeori!=moeori))
			{
				htmlstr=htmlstr+'<span style="margin:0px 0px 0px 120px;" class="font16">用法:'+nbsp3+freq+" x "+phdur+nbsp3+nbsp3+Intrus+'</span>';
				htmlstr=htmlstr+'</p>';
				htmlstr=htmlstr+'</br>'
			}
		}
		else
		{
			ordNo=(parseInt(ordNo)+1)
			if((lastmoeori!="")&&(lastmoeori!=moeori))
			{
				htmlstr=htmlstr+'</p>';
				htmlstr=htmlstr+'</br>'
			}
			htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">'+ordNo+"、"+InciDesc+nbsp3+nbsp3+spec+" x "+QtyUom+'</span>';
			htmlstr=htmlstr+'</br>';
			
			htmlstr=htmlstr+'<span style="margin:0px 0px 0px 120px;" class="font16">用法:'+nbsp3+Dosage+nbsp3+freq+nbsp3+Intrus+'</span>';
			htmlstr=htmlstr+'</p>';
			htmlstr=htmlstr+'</br>';
		}
		lastmoeori=moeori;
	}
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 100px;font-weight:bold;" class="font16">-------------------------(以下空白)-------------------------</span>';
	htmlstr=htmlstr+'</div>';
	
	//处方尾部
	htmlstr=htmlstr+'<div style="width:750px;height:50px;margin:0px 0px 20px 0px;">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;font-weight:bold;" class="font16">金额:'+PrescSingPrice+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 340px;font-weight:bold;" class="font16">医生:'+Doctor+'</span>';
	htmlstr=htmlstr+'<hr style="background-color:black;height:3px;border:none;">'; //画线
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">审核:'+PyName+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;" class="font16">核对:'+FyName+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;" class="font16">日期:'+PyDate+'</span>';
	htmlstr=htmlstr+'</br>';

	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">调配:'+PyName+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;" class="font16">发药:'+FyName+'</span>';
	htmlstr=htmlstr+'</div>';
	
	htmlstr=htmlstr+'</div>';
	return htmlstr;
}
document.body.onload = OutPrescView;