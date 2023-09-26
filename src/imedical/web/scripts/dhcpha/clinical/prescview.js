
/// Creator:    bianshuai
/// CreateDate: 2014-06-17
/// Descript:   ���˾�����Ϣ����  ����/סԺ

function createPrescViewWin(phd,type){

	//������������
	if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	
	$('body').append('<div id="win"></div>');
	$('#win').append('<div id="tab"></div>');
    
    //window
    $('#win').window({
		title:'����Ԥ��',
		collapsible:true,
		border:true,
		closable:false,
		width:900,
		height:1000,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		onClose:function(){
			$('#win').remove();  //���ڹر�ʱ�Ƴ�win��DIV��ǩ
			window.close();//�رո�����
			}
	});
	var htmlstr="";
	if(type == "O"){
		OutPrescView(phd);  //���ﴦ������
	}else{
		InPrescView(phd);   //סԺ��������
	}
	
	//$('#win').html(htmlstr);
	$('#win').window('open');
}

/// �������� [����]
function OutPrescView(phd)
{
	//��ȡ������Ϣ
	var mytrn=tkMakeServerCall("web.DHCOutPhPrint","PrintPrescByPhd",phd);
	if(mytrn==""){
		$.messager.alert('����:','��ȡ������Ϣ����','error');
		return;}
		
	var SStr=mytrn.split("!!");
	var PatInfo=SStr[0]; //������Ϣ
	var DrgInfo=SStr[1]; //ҽ����Ϣ
	
	//������Ϣ
	var PatArr=PatInfo.split("^");
	var PrescNo=PatArr[15]; //������
	var CardNo=PatArr[14];  //����
	var PatNo=PatArr[0];    //�ǼǺ�
	var PatName=PatArr[1];  //��������
	var PatAge=PatArr[2];   //����
	var PatSex=PatArr[3];   //�Ա�
	var Patweight=PatArr[5];  //����
	var AdmLoc=PatArr[16];    //�Ʊ�
	var BillType=PatArr[19];  //�ѱ�
	var InsurNo="��";            //ҽ�����
	var Allergy="��";              //����ʷ
	var LocDesc=PatArr[11]+PatArr[17];     //ȡҩ�ص�[ҩ��+����]
	var AdmDate=PatArr[13];   	   //��������PatArr
	var DiagnoDesc=PatArr[4];      //���
	var ExceedReason=PatArr[35];   //����ԭ��
	var Doctor=PatArr[26];    //ҽ��
	var PyName=PatArr[6];     //��ҩ��
	var FyName=PatArr[7];     //��ҩ��
	
	var PrescTitle=PatArr[24];//��������
	if ((PrescTitle=="�顢��һ")&(FyName=="����3178"))	
	{ var FyName="���9436"}
	var PrescSingPrice=PatArr[27]+"Ԫ";    //��������

	//׼������������html
	var htmlstr="";
	//��DIV
	switch(PrescTitle){
		case "����":
			htmlstr=htmlstr+'<div style="margin:30px;width:800px;height:700px;border:1px solid #000000;background:#99FFCC;" class="mydiv">';
			break;
		case "����":
			htmlstr=htmlstr+'<div style="margin:30px;width:800px;height:700px;border:1px solid #000000;background:#FFFFCC;" class="mydiv">';
			break;
		case "�顢��һ":
			htmlstr=htmlstr+'<div style="margin:30px;width:800px;height:700px;border:1px solid #000000;background:#FFCCFF;" class="mydiv">';
			break;
		case "����":
			htmlstr=htmlstr+'<div style="margin:30px;width:800px;height:700px;border:1px solid #000000;background:#FFFFFF;color=red;" class="mydiv">';
			break;
		default:
			htmlstr=htmlstr+'<div style="margin:30px;width:800px;height:700px;border:1px solid #000000;background:#FFFFFF;" class="mydiv">';  
	}
	//����
	htmlstr=htmlstr+'<div style="margin:20px 0px 15px 0px;width:800px;height:50;" align="center">';
	htmlstr=htmlstr+'<span style="font-size:22pt;font-family:���Ŀ���;font-weight:bold;margin:0px 0px 5px 0px;">�� �� ʡ �� ҽ Ժ</span>';
	htmlstr=htmlstr+'<span style="font-size:22pt;font-family:���Ŀ���;right:180px;position:absolute;" >['+PrescTitle+']</span>';
	htmlstr=htmlstr+'</br>';
	htmlstr=htmlstr+'<span style="font-size:22pt;font-family:���Ŀ���;font-weight:bold;">������</span>';
	htmlstr=htmlstr+'</div>';
	//������Ϣ
	htmlstr=htmlstr+'<div style="width:800;height:100px;margin:0px 0px 5px 0px">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 80px;" class="font16">�������:</span><span class="btn-ui-width1 font12">'+PrescNo+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 60px;" class="font16">�Ʊ�:</span><span class="btn-ui-width1 font12">'+AdmLoc+'</span>';
	htmlstr=htmlstr+'</br>';
	
	htmlstr=htmlstr+'<div style="width:800;margin:0px 0px 5px 0px">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 80px;" class="font16">������:</span><span class="btn-ui-width1 font12">'+''+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 60px;" class="font16">�ǼǺ�:</span><span class="btn-ui-width1 font12">'+PatNo+'</span>';
	htmlstr=htmlstr+'</br>';
	
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 80px;" class="font16">��   ��:</span><span class="btn-ui-width2 font12">'+PatName+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 50px;" class="font16">�Ա�:</span><span class="btn-ui-width2 font12">'+PatSex+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 60px;" class="font16">����:</span><span class="btn-ui-width2 font12">'+PatAge+'</span>';
	htmlstr=htmlstr+'</br>';

	//htmlstr=htmlstr+'<span style="margin:0px 0px 5px 80px;" class="font16">���֤:</span><span class="btn-ui-width3 font12">'+''+'</span>';
	//htmlstr=htmlstr+'</br>';
	if((PrescTitle == "�顢��һ")||(PrescTitle == "����")){
		
		htmlstr=htmlstr+'<span style="margin:0px 0px 5px 80px;" class="font16">������:</span><span class="btn-ui-width1 font12">'+''+'</span>';
		htmlstr=htmlstr+'<span style="margin:0px 0px 5px 60px;" class="font16">���֤:</span><span class="btn-ui-width1 font12">'+''+'</span>';
		htmlstr=htmlstr+'</br>';
	}
	htmlstr=htmlstr+'</div>';
	//���
	htmlstr=htmlstr+'<div style="width:640;height:20px;margin:0px 80px 0px 80px;">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 0px;" class="font16">�ٴ����:'+DiagnoDesc+'</span>'	
	htmlstr=htmlstr+'</div>';
	htmlstr=htmlstr+'<hr style="background-color:blue;height:1px;border:none;">'; //����
	//ҽ����Ϣ
	htmlstr=htmlstr+'<div style="width:800;height:400px;margin:0px 0px 0px 0px;">';
	htmlstr=htmlstr+'<span style="font-size:22pt;font-family:���Ŀ���;margin:0px 0px 0px 50px;">Rp:</span>';
	htmlstr=htmlstr+'</p>';
	
	//ҩƷ��Ϣ
	var DrgInfoArr=DrgInfo.split("@");
	var Len=DrgInfoArr.length;
	var index="";
	for(var i=0;i<Len;i++)
	{
		var MedArr=DrgInfoArr[i].split("^");
		var MedName=MedArr[0]+MedArr[15]; //Ʒ��		
		var QtyUom=MedArr[1]+MedArr[2];     //����+��λ
		var Durtion=MedArr[6]; //�Ƴ�		
		var Intrus=MedArr[4];  //�÷�
		var Dosage=MedArr[3];  //����
		var freq=MedArr[5];    //Ƶ��
		var moeori=MedArr[13];  //��ҽ��ID
		var SpaciallySign=MedArr[16];  //������ű�ע

		htmlstr=htmlstr+'<span style="margin:0px 0px 0px 90px;" class="font16">'+(parseInt(i)+1)+"��"+MedName+" x "+QtyUom+'</span>';
		htmlstr=htmlstr+'</br>';

		htmlstr=htmlstr+'<span style="margin:0px 0px 0px 180px;" class="font16">Sig:'+Intrus+"	 "+Dosage+" 	"+freq+'</span>';
		//htmlstr=htmlstr+'<span style="right:300px;position:absolute;" class="font16">����:'+''+'</span>';
		htmlstr=htmlstr+'</p>';
	}
	
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 150px;font-weight:bold;" class="font16">-------------------------(���¿հ�)-------------------------</span>';
	htmlstr=htmlstr+'</div>';
	//����β��
	htmlstr=htmlstr+'<div style="width:800;height:50px;margin:0px 0px 20px 0px;">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;" class="font16">���:'+PrescSingPrice+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 340px;font-weight:bold;" class="font16">ҽ��:'+Doctor+'</span>';
	htmlstr=htmlstr+'<hr style="background-color:blue;height:1px;border:none;">'; //����
	
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;" class="font16">���:'+PyName+'</span>';
	htmlstr=htmlstr+'<span style="position:absolute;right:430px;" class="font16">�˶�:'+FyName+'</span>';
	htmlstr=htmlstr+'<span style="position:absolute;right:180px;" class="font16">����:'+AdmDate+'</span>';
	htmlstr=htmlstr+'</br>';
	
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;" class="font16">����:'+FyName+'</span>';
	htmlstr=htmlstr+'<span style="position:absolute;right:430px;" class="font16">��ҩ:'+PyName+'</span>';
	htmlstr=htmlstr+'</div>';

	htmlstr=htmlstr+'</div>';
	//return htmlstr;
	$('#win').html(htmlstr);
	return;
}


/// �������� [סԺ]
function InPrescView(phac)
{
	///��ȡ��ӡ��Ϣ
	var retval=getOpDispMainInfo(phac);
	if(retval==""){
		alert("ȡ����Ϣ����");
		return;
	}

	var mainArr=retval.split("^");
	
	//��ϸ����
	var retval=tkMakeServerCall("web.DHCSTPCHCOLLPRN","getOperPhaPresc",phac);
	if(retval==""){
		alert("ȡ��ϸ��Ϣ����");
		return;
	}
	
	var num=retval.split("^")[0]; //��¼��[��������]
	var pid=retval.split("^")[1]; //���̱�ʾ
	if(num==0){return;}
	
	for(var i=1;i<=num;i++){
		var retval=tkMakeServerCall("web.DHCSTPCHCOLLPRN","ListOPDispPresc",pid,i);
		if(retval==""){return;}
		addPrescToPanel(mainArr,retval);
	}
}

/// ������ͼ�б�
function addPrescToPanel(mainArr,retval)
{
	var phaDispNo=mainArr[0];    //����
	var phaLoc=mainArr[1];       //ҩ��
	var ward=mainArr[2];         //����
	var PyName=mainArr[3];       //������
	var FyName=mainArr[3];       //������
	if (phaLoc=="SSYF-����ҩ��")
	{var FyName="���9436"}
	var phaCollDate=mainArr[4];  //��ҩ����
	var phaCollTime=mainArr[5];  //��ҩʱ��
	var printDate=mainArr[6];    //��ӡ����
	var printTime=mainArr[7];    //��ӡʱ��
	var disTypeDesc=mainArr[8];  //��ҩ����
	
	var medArr=retval.split("||");
	for (var j=0;j<medArr.length;j++)
	{
		var sstr=medArr[j].split("^");
		var PatBed=sstr[0];       //����
		var PatNo=sstr[1];        //�ǼǺ�
		var PatName=sstr[2];      //����
		var PatSex=sstr[3];       //�Ա�
		var PatLoc=sstr[4];       //����
		var PrescNo=sstr[5];      //����
		var Doctor=sstr[6];       //ҽʦ
		var PatAge=sstr[28];      //����
		var PatICD=sstr[27];      //���
		var PrescTitle=sstr[29];  //��������
		var PrescMoney=sstr[17]+"Ԫ";  //���
		var Medicare=sstr[38];    //������
		var BatNoList=sstr[39];    //����
		var MedDesc=sstr[9];        //Ʒ��
		var QtyUom=sstr[14]+sstr[15];  //����
		var Dosage=sstr[12];        //����
		var Freq=sstr[13];          //Ƶ��
		var Intrus=sstr[18];        //�÷�
		var Duration=sstr[19];      //�Ƴ�
		var Notes=sstr[20];         //��ע
		var Spec=sstr[24];          //���
		var generic=sstr[26];       //ͨ����
		var identityCard=sstr[34];  //���֤
		var AgentUser=sstr[35];     //������
		var identityCardOfAgent=sstr[36];//���������֤
		var PrescDate=sstr[37];          //ҽ������
		var Number=sstr[41];             //����ÿ�ձ��
		var trDoseUom=sstr[40];
		var useMethod="";
		
		if(j==0){
			//׼������������html
			var htmlstr="";
			//��DIV
			switch(PrescTitle){
				case "��":
					htmlstr=htmlstr+'<div style="margin:30px;width:800px;height:700px;border:1px solid #000000;background:#FFCCFF;" class="mydiv">';
					break;
				case "����":
					htmlstr=htmlstr+'<div style="margin:30px;width:800px;height:700px;border:1px solid #000000;background:#FFCCFF;" class="mydiv">';
					break;
				case "�顢��һ":
					htmlstr=htmlstr+'<div style="margin:30px;width:800px;height:700px;border:1px solid #000000;background:#FFCCFF;" class="mydiv">';
					useMethod="������";
					break;
				default:
					htmlstr=htmlstr+'<div style="margin:30px;width:800px;height:700px;border:1px solid #000000;">';  
			}	
			//����
			htmlstr=htmlstr+'<div style="margin:20px 0px 15px 0px;width:800px;height:50;" align="center">';
			htmlstr=htmlstr+'<span style="font-size:22pt;font-family:���Ŀ���;font-weight:bold;margin:0px 0px 5px 0px;">�� �� ʡ �� ҽ Ժ</span>';
			htmlstr=htmlstr+'<span style="font-size:22pt;font-family:���Ŀ���;right:180px;position:absolute;" >['+PrescTitle+']</span>';
			htmlstr=htmlstr+'</br>';
			htmlstr=htmlstr+'<span style="font-size:22pt;font-family:���Ŀ���;font-weight:bold;">������</span>';
			htmlstr=htmlstr+'</div>';
			//������Ϣ
			htmlstr=htmlstr+'<div style="width:800;height:100px;margin:0px 0px 5px 0px">';
			htmlstr=htmlstr+'<span style="margin:0px 0px 5px 80px;" class="font16">�������:</span><span class="btn-ui-width1 font12">'+PrescNo+'</span>';
			htmlstr=htmlstr+'<span style="margin:0px 0px 5px 60px;" class="font16">�Ʊ�/����:</span><span class="btn-ui-width1 font12">'+PatLoc+"   "+PatBed+'</span>';
			htmlstr=htmlstr+'</br>';
	
			htmlstr=htmlstr+'<div style="width:800;height:100px;margin:0px 0px 5px 0px">';
			htmlstr=htmlstr+'<span style="margin:0px 0px 5px 80px;" class="font16">������:</span><span class="btn-ui-width1 font12">'+Medicare+'</span>';
			htmlstr=htmlstr+'<span style="margin:0px 0px 5px 60px;" class="font16">�ǼǺ�:</span><span class="btn-ui-width1 font12">'+PatNo+'</span>';
			htmlstr=htmlstr+'</br>';
	
			htmlstr=htmlstr+'<span style="margin:0px 0px 5px 80px;" class="font16">��   ��:</span><span class="btn-ui-width2 font12">'+PatName+'</span>';
			htmlstr=htmlstr+'<span style="margin:0px 0px 5px 50px;" class="font16">�Ա�:</span><span class="btn-ui-width2 font12">'+PatSex+'</span>';
			htmlstr=htmlstr+'<span style="margin:0px 0px 5px 60px;" class="font16">����:</span><span class="btn-ui-width2 font12">'+PatAge+'</span>';
			htmlstr=htmlstr+'</br>';

			htmlstr=htmlstr+'<span style="margin:0px 0px 5px 80px;" class="font16">���֤:</span><span class="btn-ui-width3 font12">'+identityCard+'</span>';
			htmlstr=htmlstr+'</br>';

			htmlstr=htmlstr+'<span style="margin:0px 0px 5px 80px;" class="font16">������:</span><span class="btn-ui-width1 font12">'+AgentUser+'</span>';
			htmlstr=htmlstr+'<span style="margin:0px 0px 5px 60px;" class="font16">���֤:</span><span class="btn-ui-width1 font12">'+identityCardOfAgent+'</span>';
			htmlstr=htmlstr+'</br>';
			htmlstr=htmlstr+'</div>';
			//���
			htmlstr=htmlstr+'<div style="width:640;height:20px;margin:0px 80px 0px 80px;">';
			htmlstr=htmlstr+'<span style="margin:0px 0px 0px 0px;" class="font16">�ٴ����:'+PatICD+'</span>'	
			htmlstr=htmlstr+'</div>';
			htmlstr=htmlstr+'<hr style="background-color:blue;height:1px;border:none;">'; //����
			//ҽ����Ϣ
			htmlstr=htmlstr+'<div style="width:800;height:400px;margin:0px 0px 0px 0px;">';
			htmlstr=htmlstr+'<span style="font-size:22pt;font-family:���Ŀ���;margin:0px 0px 0px 50px;">Rp:</span>';
			htmlstr=htmlstr+'</p>';
		}

		htmlstr=htmlstr+'<span style="margin:0px 0px 0px 90px;" class="font16">'+(parseInt(j)+1)+"��"+MedDesc+" x "+QtyUom+'</span>';
		htmlstr=htmlstr+'</br>';

		htmlstr=htmlstr+'<span style="margin:0px 0px 0px 180px;" class="font16">Sig:'+Intrus+"	 "+trDoseUom+" 	"+Freq+"&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"+useMethod+'</span>';  ////Dosage
		htmlstr=htmlstr+'<span style="right:240px;position:absolute;" class="font16">����:'+BatNoList+'</span>';
		htmlstr=htmlstr+'</p>';
	
		if(j==0){
			htmlstr=htmlstr+'<span style="margin:0px 0px 0px 150px;font-weight:bold;" class="font16">-------------------------(���¿հ�)-------------------------</span>';
			htmlstr=htmlstr+'</div>';
			//����β��
			htmlstr=htmlstr+'<div style="width:800;height:50px;margin:0px 0px 20px 0px;">';
			htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;" class="font16">���:'+PrescMoney+'</span>';
			htmlstr=htmlstr+'<span style="margin:0px 0px 0px 340px;font-weight:bold;" class="font16">ҽ��:'+Doctor+'</span>';
			htmlstr=htmlstr+'<hr style="background-color:blue;height:1px;border:none;">'; //����
	
			htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;" class="font16">���:'+PyName+'</span>';
			htmlstr=htmlstr+'<span style="position:absolute;right:430px;" class="font16">�˶�:'+FyName+'</span>';
			htmlstr=htmlstr+'<span style="position:absolute;right:180px;" class="font16">����:'+PrescDate+'</span>';
			htmlstr=htmlstr+'</br>';
	
			htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;" class="font16">����:'+FyName+'</span>';
			htmlstr=htmlstr+'<span style="position:absolute;right:430px;" class="font16">��ҩ:'+PyName+'</span>';
			htmlstr=htmlstr+'<span style="position:absolute;right:180px;" class="font16">No:'+Number+'</span>';
			htmlstr=htmlstr+'</div>';

			htmlstr=htmlstr+'</div>';
		}
	}
	//return htmlstr;
	$('#win').append(htmlstr);
	return;
}

//��ȡ��ҩ����Ϣ 2014-11-21 bianshuai
function getOpDispMainInfo(phac)
{
	var retval=tkMakeServerCall("web.DHCSTPCHCOLLPRN","GetOperPhaColl",phac);
	return retval;
}

/// �رղ��Ƴ�����
function CloseWin()
{
	$('#win').window('close'); //�ر�
	$('#win').remove();
	window.close();//�رո�����
}

/// ��ȡ����
function getParam(paramName)
{
    paramValue = "";
    isFound = false;
    if (this.location.search.indexOf("?") == 0 && this.location.search.indexOf("=")>1)
    {
        arrSource = unescape(this.location.search).substring(1,this.location.search.length).split("&");
        i = 0;
        while (i < arrSource.length && !isFound)
        {
            if (arrSource[i].indexOf("=") > 0)
            {
                 if (arrSource[i].split("=")[0].toLowerCase()==paramName.toLowerCase())
                 {
                    paramValue = arrSource[i].split("=")[1];
                    isFound = true;
                 }
            }
            i++;
        }   
    }
   return paramValue;
}

///��ݼ�
$(document).keydown(function(e){
	return;
	//S ����83��ȷ��(�س���13)
	if(e.which == 13) {
		CloseWin();
		window.returnValue = "1";
	}
	//C����67���ر�(ctrl:17)
	if(e.which == 17) {
		CloseWin();
	}
});