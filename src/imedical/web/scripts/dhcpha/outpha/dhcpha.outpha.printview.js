//dhcpha.outphap.printview.js
//���ﴦ��Ԥ��
var App_LogonHospDesc=tkMakeServerCall("web.DHCSTKUTIL","GetHospName",session['LOGON.HOSPID']);
function OutPrescView()
{
	var cyflag=tkMakeServerCall("web.DHCOutPhDispFY","CheckCyFlag",phdispid);
	if(cyflag=="1"){var htmlstr=OutPrescViewCY(phdispid);}
	else{var htmlstr=OutPrescViewXY(phdispid);}
	document.write(htmlstr)
	//return htmlstr
}
/// �������� [�����ҩ]
function OutPrescViewCY(phd)
{
	//��ȡ������Ϣ
	var mytrn=tkMakeServerCall("web.DHCOutPhDispFY","GetPrescInfoByPhd",phd);
	if(mytrn==""){
		alert('����:��ȡ������Ϣ����');
		return;}
	
	var SStr=mytrn.split("!!");
	var PatInfo=SStr[0]; //������Ϣ
	var DrgInfo=SStr[1]; //ҽ����Ϣ

	//������Ϣ
	var PatArr=PatInfo.split("^");
	var PrescNo=PatArr[29];   //������
	var AdmLoc=PatArr[16];    //�Ʊ�
	var PatNo=PatArr[0];      //�ǼǺ�
	var PatName=PatArr[1];    //��������
	var PatAge=PatArr[2];     //����
	var PatSex=PatArr[3];     //�Ա�
	var Patweight=PatArr[5];  //����
	var DiagnoDesc=PatArr[4]; //���
	var OrdDate=PatArr[18];   //��������
	var tel=PatArr[19];       //�绰
	var address=PatArr[20];   //��ַ
	var Doctor=PatArr[17];    //ҽ��
	var PyName=PatArr[9];     //��ҩ��
	var FyName=PatArr[10];    //��ҩ��
	var PyDate=PatArr[11];    //��ҩ����
	var sumamt=PatArr[28];   //��������
	var queinst=PatArr[21];
	var quefac=PatArr[22];
	var queqty=PatArr[23];
	var quedate=PatArr[24];
	var quexdate=PatArr[25];
	var quenote=PatArr[26];
	var quecook=PatArr[27];
	var nbsp3='&nbsp;&nbsp;&nbsp;';

	//׼������������html
	var htmlstr="";
	//��DIV
	htmlstr=htmlstr+'<div style="margin:8px;width:750px;height:700px;border:1px solid #000000;background:#FFFFFF;">';  
	//����
	htmlstr=htmlstr+'<div style="margin:10px 0px 10px 0px;width:750px;height:30px;" align="center">';
	htmlstr=htmlstr+'<span style="font-size:22pt;font-family:���Ŀ���;font-weight:bold;margin:0px 0px 5px 0px;">'+App_LogonHospDesc+'������</span>';
	htmlstr=htmlstr+'</div>';
	//������Ϣ
	htmlstr=htmlstr+'<div style="width:750px;height:100px;margin:0px 0px 5px 0px">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 50px;" class="font16">������:</span><span class="btn-ui-width5 font16">&nbsp;'+PrescNo+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 180px;" class="font16">'+"��"+nbsp3+"��:"+'</span><span class="btn-ui-width6 font16">&nbsp;'+AdmLoc+'</span>';
	htmlstr=htmlstr+'</br>'; //����
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 50px;" class="font16">'+"��"+nbsp3+"��:"+'</span><span class="btn-ui-width2 font16">&nbsp;'+PatName+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 50px;" class="font16">'+"��"+nbsp3+"��:"+'</span><span style="width:40px;border-bottom:1px solid #000000;" class="font16">&nbsp;'+PatSex+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 50px;" class="font16">'+"��"+nbsp3+"��:"+'</span><span style="width:100px;border-bottom:1px solid #000000;" class="font16">&nbsp;'+PatAge+'</span>';
	htmlstr=htmlstr+'</br>';
	
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 50px;" class="font16">'+"�ǼǺ�:"+'</span><span class="btn-ui-width2 font16">&nbsp;'+PatNo+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 50px;" class="font16">'+"��"+nbsp3+"��:"+'</span><span class="btn-ui-width2 font16">&nbsp;'+OrdDate+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 40px;" class="font16">'+"�绰:"+'</span><span style="width:130px;border-bottom:1px solid #000000;" class="font16">&nbsp;'+tel+'</span>';
	htmlstr=htmlstr+'</br>'; //����
	
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 50px;" class="font16">'+"��"+nbsp3+"ַ:"+'</span><span style="width:580px;border-bottom:1px solid #000000;" class="font12">&nbsp;'+address+'</span>';
	htmlstr=htmlstr+'</br>'; //����
	
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">'+"��"+nbsp3+"��:"+'</span><span style="width:580px;border-bottom:1px solid #000000;" class="font12">&nbsp;'+DiagnoDesc+'</span>';
	htmlstr=htmlstr+'</br>'; //����
	htmlstr=htmlstr+'</div>';
	
	//����
	htmlstr=htmlstr+'<hr style="margin:0px 0px 0px 25px;background-color:black;height:3px;border:none;">'; 
	
	//ҽ����Ϣ
	htmlstr=htmlstr+'<div style="width:750px;height:400px;margin:0px 0px 0px 0px;">';
	htmlstr=htmlstr+'<span style="font-size:22pt;font-family:���Ŀ���;margin:0px 0px 0px 50px;">Rp:</span>';
	htmlstr=htmlstr+'</p>';
	
	//ҩƷ��Ϣ
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
			var specinstr=MedArr[11];  //��ҩ��ע
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
			var InciDesc=MedArr[0];  //����
			var qty=MedArr[1]
			qty=qty/quefac;
			/*
			if(qty.indexOf(".")>-1)
			{
				qty=Number(qty).toFixed(2);
			}
			*/
			var QtyUom=qty+MedArr[2];     //����+��λ
			var freqCY=MedArr[12];
			if(n==1){var px=80;}
			else{var px=30;}
			htmlstr=htmlstr+'<span style="margin:0px 0px 0px '+px+"px;width:300px;"+'" class="font16">'+InciDesc+"&nbsp;"+"&nbsp;"+QtyUom+'</span>';
		}
		htmlstr=htmlstr+'</p>';
		htmlstr=htmlstr+'</br>';
	}
	
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;font-weight:bold;" class="font16">-------------------------(���¿հ�)-------------------------</span>';
	htmlstr=htmlstr+'</div>';
	PrescSingPrice=Number(sumamt/quefac).toFixed(2)
	var queinst=PatArr[21];
	var quefac=PatArr[22];
	var queqty=PatArr[23];
	var quedate=PatArr[24];
	var quexdate=PatArr[25];
	var quenote=PatArr[26];
	var quecook=PatArr[27];
	//����β��
	htmlstr=htmlstr+'<div style="width:750px;height:50px;margin:0px 0px 20px 0px;">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;font-weight:bold;" class="font16">�÷�:'+freqCY+"&nbsp;"+queinst+"&nbsp;"+queqty+"&nbsp;"+"&nbsp;"+"&nbsp;"+"��: "+quefac+" ��"+"&nbsp;"+"&nbsp;"+"&nbsp;"+quecook+'</span>';
	htmlstr=htmlstr+'</br>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;font-weight:bold;" class="font16">���:'+PrescSingPrice+"Ԫ"+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 340px;font-weight:bold;" class="font16">ҽ��:'+Doctor+'</span>';
	htmlstr=htmlstr+'<hr style="background-color:black;height:3px;border:none;">'; //����
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">���:'+PyName+'</span>';
	htmlstr=htmlstr+'<span style="position:absolute;right:430px;" class="font16">�˶�:'+FyName+'</span>';
	htmlstr=htmlstr+'<span style="position:absolute;right:100px;" class="font16">����:'+PyDate+'</span>';
	htmlstr=htmlstr+'</br>';

	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">����:'+PyName+'</span>';
	htmlstr=htmlstr+'<span style="position:absolute;right:430px;" class="font16">��ҩ:'+FyName+'</span>';
	htmlstr=htmlstr+'</div>';
	
	htmlstr=htmlstr+'</div>';
	return htmlstr;
}



/// �������� [������ҩ](����)
function OutPrescViewXY(phd)
{
	//��ȡ������Ϣ
	var mytrn=tkMakeServerCall("web.DHCOutPhDispFY","GetPrescInfoByPhd",phd);
	if(mytrn==""){
		alert('����:��ȡ������Ϣ����');
		return;}
	
	var SStr=mytrn.split("!!");
	var PatInfo=SStr[0]; //������Ϣ
	var DrgInfo=SStr[1]; //ҽ����Ϣ

	//������Ϣ
	var PatArr=PatInfo.split("^");
	var PrescNo=PatArr[29];   //������
	var AdmLoc=PatArr[16];    //�Ʊ�
	var PatNo=PatArr[0];      //�ǼǺ�
	var PatName=PatArr[1];    //��������
	var PatAge=PatArr[2];     //����
	var PatSex=PatArr[3];     //�Ա�
	var Patweight=PatArr[5];  //����
	var DiagnoDesc=PatArr[4]; //���
	var OrdDate=PatArr[18];   //��������
	var tel=PatArr[19];       //�绰
	var address=PatArr[20];   //��ַ
	var Doctor=PatArr[17];    //ҽ��
	var PyName=PatArr[9];     //��ҩ��
	var FyName=PatArr[10];    //��ҩ��
	var PyDate=PatArr[11];    //��ҩ����
	var PrescSingPrice=PatArr[28]+"Ԫ";  //��������
	var presctype=PatArr[30]; //�ѱ�
	var cardno=PatArr[6];     //����
	var nbsp3='&nbsp;&nbsp;&nbsp;&nbsp;';

	//׼������������html
	var htmlstr="";
	//��DIV
	htmlstr=htmlstr+'<div style="margin:8px;width:750px;height:700px;border:1px solid #000000;background:#FFFFFF;">';  
	//����
	htmlstr=htmlstr+'<div style="margin:10px 0px 10px 0px;width:750px;height:30px;" align="center">';
	htmlstr=htmlstr+'<span style="font-size:22pt;font-family:���Ŀ���;font-weight:bold;margin:0px 0px 5px 0px;">'+App_LogonHospDesc+'������</span>';
	htmlstr=htmlstr+'</div>';
	//������Ϣ
	htmlstr=htmlstr+'<div style="width:750px;height:140px;margin:0px 0px 0px 0px">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 25px;" class="font16">'+"�ѱ�:"+'&nbsp;'+presctype+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">�ǼǺ�:&nbsp;'+PatNo+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">������:&nbsp;'+PrescNo+'</span>';
	//����
	//htmlstr=htmlstr+'<hr style="margin:0px 25px 0px 25px;background-color:black;height:3px;border:none;">';
	htmlstr=htmlstr+'</br>'; //����
	//htmlstr=htmlstr+'</div>';
	//htmlstr=htmlstr+'<div style="width:750px;height:15px;margin:0px 0px 8px 0px">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 25px;" class="font16">'+"����:"+'</span><span class="btn-ui-width2 font16" style="width:140px;">&nbsp;'+PatName+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 0px;" class="font16">'+"�Ա�:"+'</span><span style="width:60px;border-bottom:1px solid #000000;" class="font16">&nbsp;'+PatSex+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 0px;" class="font16">'+"����:"+'</span><span style="width:100px;border-bottom:1px solid #000000;" class="font16">&nbsp;'+PatAge+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 0px;" class="font16">'+"�Ʊ�:"+'</span><span class="btn-ui-width6 font16">&nbsp;'+AdmLoc+'</span>';
	htmlstr=htmlstr+'</br>'; //����
	//htmlstr=htmlstr+'</div>';
	//htmlstr=htmlstr+'<div style="width:750px;height:15px;margin:0px 0px 8px 0px">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 25px;" class="font16">'+"�绰:"+'</span><span style="width:150px;border-bottom:1px solid #000000;" class="font16">&nbsp;'+tel+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 0px;" class="font16">'+"����:"+'</span><span style="width:80px;border-bottom:1px solid #000000;" class="font16">&nbsp;'+Patweight+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 0px;" class="font16">'+"����:"+'</span><span style="width:150px;border-bottom:1px solid #000000;" class="font16">&nbsp;'+cardno+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 0px;" class="font16">'+"����:"+'</span><span class="btn-ui-width2 font16">&nbsp;'+OrdDate+'</span>';
	htmlstr=htmlstr+'</br>'; //����
	//htmlstr=htmlstr+'</div>';
	//htmlstr=htmlstr+'<div style="width:750px;height:15px;margin:0px 0px 8px 0px">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 25px;" class="font16">'+"��ַ:"+'</span><span style="width:650px;border-bottom:1px solid #000000;" class="font12">&nbsp;'+address+'</span>';
	htmlstr=htmlstr+'</br>'; //����
	//htmlstr=htmlstr+'</div>';
	//htmlstr=htmlstr+'<div style="width:750px;height:15px;margin:0px 0px 8px 0px">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 25px;" class="font16">'+"���:"+'</span><span style="width:650px;border-bottom:1px solid #000000;" class="font12">&nbsp;'+DiagnoDesc+'</span>';
	htmlstr=htmlstr+'</br>'; //����
	htmlstr=htmlstr+'</div>';
	//����
	htmlstr=htmlstr+'<hr style="margin:0px 25px 0px 25px;background-color:black;height:3px;border:none;">'; 
	
	//ҽ����Ϣ
	htmlstr=htmlstr+'<div style="width:750px;height:400px;margin:0px 0px 0px 0px;">';
	htmlstr=htmlstr+'<span style="font-size:22pt;font-family:���Ŀ���;margin:0px 0px 0px 25px;">Rp:</span>';
	htmlstr=htmlstr+'</p>';
	
	//ҩƷ��Ϣ
	var DrgInfoArr=DrgInfo.split("@");
	var Len=DrgInfoArr.length;
	var index="";
	var lastmoeori="";
	var ordNo=0
	for(var i=0;i<Len;i++)
	{
		var MedArr=DrgInfoArr[i].split("^");
		var InciDesc=MedArr[0]; //Ʒ��		
		var QtyUom=MedArr[1]+MedArr[2];     //����+��λ
		var Durtion=MedArr[6]; //�Ƴ�		
		var Intrus=MedArr[4];  //�÷�
		var Dosage=MedArr[3];  //����
		var freq=MedArr[5];    //Ƶ��
		//var moeori=MedArr[13];  //��ҽ��ID
		var spec=MedArr[13];   //���
		var SeqFlag=MedArr[14];   //�Ƿ����ҽ��
		var moeori=MedArr[15];    //��ҽ��ID
		var phdur=MedArr[16];    //�Ƴ�
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
				htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">'+ordNo+"��"+InciDesc+"("+spec+")"+'</span>';
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
				htmlstr=htmlstr+'<span style="margin:0px 0px 0px 120px;" class="font16">�÷�:'+nbsp3+freq+" x "+phdur+nbsp3+nbsp3+Intrus+'</span>';
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
			htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">'+ordNo+"��"+InciDesc+nbsp3+nbsp3+spec+" x "+QtyUom+'</span>';
			htmlstr=htmlstr+'</br>';
			
			htmlstr=htmlstr+'<span style="margin:0px 0px 0px 120px;" class="font16">�÷�:'+nbsp3+Dosage+nbsp3+freq+nbsp3+Intrus+'</span>';
			htmlstr=htmlstr+'</p>';
			htmlstr=htmlstr+'</br>';
		}
		lastmoeori=moeori;
	}
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 100px;font-weight:bold;" class="font16">-------------------------(���¿հ�)-------------------------</span>';
	htmlstr=htmlstr+'</div>';
	
	//����β��
	htmlstr=htmlstr+'<div style="width:750px;height:50px;margin:0px 0px 20px 0px;">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;font-weight:bold;" class="font16">���:'+PrescSingPrice+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 340px;font-weight:bold;" class="font16">ҽ��:'+Doctor+'</span>';
	htmlstr=htmlstr+'<hr style="background-color:black;height:3px;border:none;">'; //����
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">���:'+PyName+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;" class="font16">�˶�:'+FyName+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;" class="font16">����:'+PyDate+'</span>';
	htmlstr=htmlstr+'</br>';

	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 50px;" class="font16">����:'+PyName+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;" class="font16">��ҩ:'+FyName+'</span>';
	htmlstr=htmlstr+'</div>';
	
	htmlstr=htmlstr+'</div>';
	return htmlstr;
}
document.body.onload = OutPrescView;