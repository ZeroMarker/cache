
/// Creator:    bianshuai
/// CreateDate: 2014-06-17
/// Descript:   病人就诊信息窗口  门诊/住院

function createPrescViewWin(phd,type){

	//创建弹出窗体
	if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出
	
	$('body').append('<div id="win"></div>');
	$('#win').append('<div id="tab"></div>');
    
    //window
    $('#win').window({
		title:'处方预览',
		collapsible:true,
		border:true,
		closable:false,
		width:900,
		height:1000,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		onClose:function(){
			$('#win').remove();  //窗口关闭时移除win的DIV标签
			window.close();//关闭父窗口
			}
	});
	var htmlstr="";
	if(type == "O"){
		OutPrescView(phd);  //门诊处方阅览
	}else{
		InPrescView(phd);   //住院处方阅览
	}
	
	//$('#win').html(htmlstr);
	$('#win').window('open');
}

/// 处方阅览 [门诊]
function OutPrescView(phd)
{
	//获取处方信息
	var mytrn=tkMakeServerCall("web.DHCOutPhPrint","PrintPrescByPhd",phd);
	if(mytrn==""){
		$.messager.alert('警告:','提取处方信息出错！','error');
		return;}
		
	var SStr=mytrn.split("!!");
	var PatInfo=SStr[0]; //病人信息
	var DrgInfo=SStr[1]; //医嘱信息
	
	//病人信息
	var PatArr=PatInfo.split("^");
	var PrescNo=PatArr[15]; //处方号
	var CardNo=PatArr[14];  //卡号
	var PatNo=PatArr[0];    //登记号
	var PatName=PatArr[1];  //病人姓名
	var PatAge=PatArr[2];   //年龄
	var PatSex=PatArr[3];   //性别
	var Patweight=PatArr[5];  //体重
	var AdmLoc=PatArr[16];    //科别
	var BillType=PatArr[19];  //费别
	var InsurNo="无";            //医保编号
	var Allergy="无";              //过敏史
	var LocDesc=PatArr[11]+PatArr[17];     //取药地点[药房+窗口]
	var AdmDate=PatArr[13];   	   //开方日期PatArr
	var DiagnoDesc=PatArr[4];      //诊断
	var ExceedReason=PatArr[35];   //超量原因
	var Doctor=PatArr[26];    //医生
	var PyName=PatArr[6];     //配药人
	var FyName=PatArr[7];     //发药人
	
	var PrescTitle=PatArr[24];//处方类型
	if ((PrescTitle=="麻、精一")&(FyName=="张琼3178"))	
	{ var FyName="许岑9436"}
	var PrescSingPrice=PatArr[27]+"元";    //处方费用

	//准备处方阅览的html
	var htmlstr="";
	//主DIV
	switch(PrescTitle){
		case "儿科":
			htmlstr=htmlstr+'<div style="margin:30px;width:800px;height:700px;border:1px solid #000000;background:#99FFCC;" class="mydiv">';
			break;
		case "急诊":
			htmlstr=htmlstr+'<div style="margin:30px;width:800px;height:700px;border:1px solid #000000;background:#FFFFCC;" class="mydiv">';
			break;
		case "麻、精一":
			htmlstr=htmlstr+'<div style="margin:30px;width:800px;height:700px;border:1px solid #000000;background:#FFCCFF;" class="mydiv">';
			break;
		case "精二":
			htmlstr=htmlstr+'<div style="margin:30px;width:800px;height:700px;border:1px solid #000000;background:#FFFFFF;color=red;" class="mydiv">';
			break;
		default:
			htmlstr=htmlstr+'<div style="margin:30px;width:800px;height:700px;border:1px solid #000000;background:#FFFFFF;" class="mydiv">';  
	}
	//标题
	htmlstr=htmlstr+'<div style="margin:20px 0px 15px 0px;width:800px;height:50;" align="center">';
	htmlstr=htmlstr+'<span style="font-size:22pt;font-family:华文楷体;font-weight:bold;margin:0px 0px 5px 0px;">安 徽 省 立 医 院</span>';
	htmlstr=htmlstr+'<span style="font-size:22pt;font-family:华文楷体;right:180px;position:absolute;" >['+PrescTitle+']</span>';
	htmlstr=htmlstr+'</br>';
	htmlstr=htmlstr+'<span style="font-size:22pt;font-family:华文楷体;font-weight:bold;">处方笺</span>';
	htmlstr=htmlstr+'</div>';
	//基本信息
	htmlstr=htmlstr+'<div style="width:800;height:100px;margin:0px 0px 5px 0px">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 80px;" class="font16">处方编号:</span><span class="btn-ui-width1 font12">'+PrescNo+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 60px;" class="font16">科别:</span><span class="btn-ui-width1 font12">'+AdmLoc+'</span>';
	htmlstr=htmlstr+'</br>';
	
	htmlstr=htmlstr+'<div style="width:800;margin:0px 0px 5px 0px">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 80px;" class="font16">病历号:</span><span class="btn-ui-width1 font12">'+''+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 60px;" class="font16">登记号:</span><span class="btn-ui-width1 font12">'+PatNo+'</span>';
	htmlstr=htmlstr+'</br>';
	
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 80px;" class="font16">姓   名:</span><span class="btn-ui-width2 font12">'+PatName+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 50px;" class="font16">性别:</span><span class="btn-ui-width2 font12">'+PatSex+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 5px 60px;" class="font16">年龄:</span><span class="btn-ui-width2 font12">'+PatAge+'</span>';
	htmlstr=htmlstr+'</br>';

	//htmlstr=htmlstr+'<span style="margin:0px 0px 5px 80px;" class="font16">身份证:</span><span class="btn-ui-width3 font12">'+''+'</span>';
	//htmlstr=htmlstr+'</br>';
	if((PrescTitle == "麻、精一")||(PrescTitle == "精二")){
		
		htmlstr=htmlstr+'<span style="margin:0px 0px 5px 80px;" class="font16">代办人:</span><span class="btn-ui-width1 font12">'+''+'</span>';
		htmlstr=htmlstr+'<span style="margin:0px 0px 5px 60px;" class="font16">身份证:</span><span class="btn-ui-width1 font12">'+''+'</span>';
		htmlstr=htmlstr+'</br>';
	}
	htmlstr=htmlstr+'</div>';
	//诊断
	htmlstr=htmlstr+'<div style="width:640;height:20px;margin:0px 80px 0px 80px;">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 0px;" class="font16">临床诊断:'+DiagnoDesc+'</span>'	
	htmlstr=htmlstr+'</div>';
	htmlstr=htmlstr+'<hr style="background-color:blue;height:1px;border:none;">'; //画线
	//医嘱信息
	htmlstr=htmlstr+'<div style="width:800;height:400px;margin:0px 0px 0px 0px;">';
	htmlstr=htmlstr+'<span style="font-size:22pt;font-family:华文楷体;margin:0px 0px 0px 50px;">Rp:</span>';
	htmlstr=htmlstr+'</p>';
	
	//药品信息
	var DrgInfoArr=DrgInfo.split("@");
	var Len=DrgInfoArr.length;
	var index="";
	for(var i=0;i<Len;i++)
	{
		var MedArr=DrgInfoArr[i].split("^");
		var MedName=MedArr[0]+MedArr[15]; //品名		
		var QtyUom=MedArr[1]+MedArr[2];     //数量+单位
		var Durtion=MedArr[6]; //疗程		
		var Intrus=MedArr[4];  //用法
		var Dosage=MedArr[3];  //剂量
		var freq=MedArr[5];    //频次
		var moeori=MedArr[13];  //主医嘱ID
		var SpaciallySign=MedArr[16];  //特殊符号标注

		htmlstr=htmlstr+'<span style="margin:0px 0px 0px 90px;" class="font16">'+(parseInt(i)+1)+"、"+MedName+" x "+QtyUom+'</span>';
		htmlstr=htmlstr+'</br>';

		htmlstr=htmlstr+'<span style="margin:0px 0px 0px 180px;" class="font16">Sig:'+Intrus+"	 "+Dosage+" 	"+freq+'</span>';
		//htmlstr=htmlstr+'<span style="right:300px;position:absolute;" class="font16">批号:'+''+'</span>';
		htmlstr=htmlstr+'</p>';
	}
	
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 150px;font-weight:bold;" class="font16">-------------------------(以下空白)-------------------------</span>';
	htmlstr=htmlstr+'</div>';
	//处方尾部
	htmlstr=htmlstr+'<div style="width:800;height:50px;margin:0px 0px 20px 0px;">';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;" class="font16">金额:'+PrescSingPrice+'</span>';
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 340px;font-weight:bold;" class="font16">医生:'+Doctor+'</span>';
	htmlstr=htmlstr+'<hr style="background-color:blue;height:1px;border:none;">'; //画线
	
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;" class="font16">审核:'+PyName+'</span>';
	htmlstr=htmlstr+'<span style="position:absolute;right:430px;" class="font16">核对:'+FyName+'</span>';
	htmlstr=htmlstr+'<span style="position:absolute;right:180px;" class="font16">日期:'+AdmDate+'</span>';
	htmlstr=htmlstr+'</br>';
	
	htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;" class="font16">调配:'+FyName+'</span>';
	htmlstr=htmlstr+'<span style="position:absolute;right:430px;" class="font16">发药:'+PyName+'</span>';
	htmlstr=htmlstr+'</div>';

	htmlstr=htmlstr+'</div>';
	//return htmlstr;
	$('#win').html(htmlstr);
	return;
}


/// 处方阅览 [住院]
function InPrescView(phac)
{
	///获取打印信息
	var retval=getOpDispMainInfo(phac);
	if(retval==""){
		alert("取主信息错误");
		return;
	}

	var mainArr=retval.split("^");
	
	//明细数据
	var retval=tkMakeServerCall("web.DHCSTPCHCOLLPRN","getOperPhaPresc",phac);
	if(retval==""){
		alert("取明细信息错误");
		return;
	}
	
	var num=retval.split("^")[0]; //记录数[处方总数]
	var pid=retval.split("^")[1]; //进程标示
	if(num==0){return;}
	
	for(var i=1;i<=num;i++){
		var retval=tkMakeServerCall("web.DHCSTPCHCOLLPRN","ListOPDispPresc",pid,i);
		if(retval==""){return;}
		addPrescToPanel(mainArr,retval);
	}
}

/// 处方视图列表
function addPrescToPanel(mainArr,retval)
{
	var phaDispNo=mainArr[0];    //单号
	var phaLoc=mainArr[1];       //药房
	var ward=mainArr[2];         //病区
	var PyName=mainArr[3];       //操作人
	var FyName=mainArr[3];       //操作人
	if (phaLoc=="SSYF-手术药房")
	{var FyName="许岑9436"}
	var phaCollDate=mainArr[4];  //发药日期
	var phaCollTime=mainArr[5];  //发药时间
	var printDate=mainArr[6];    //打印日期
	var printTime=mainArr[7];    //打印时间
	var disTypeDesc=mainArr[8];  //发药类型
	
	var medArr=retval.split("||");
	for (var j=0;j<medArr.length;j++)
	{
		var sstr=medArr[j].split("^");
		var PatBed=sstr[0];       //床号
		var PatNo=sstr[1];        //登记号
		var PatName=sstr[2];      //姓名
		var PatSex=sstr[3];       //性别
		var PatLoc=sstr[4];       //科室
		var PrescNo=sstr[5];      //处方
		var Doctor=sstr[6];       //医师
		var PatAge=sstr[28];      //年龄
		var PatICD=sstr[27];      //诊断
		var PrescTitle=sstr[29];  //处方类型
		var PrescMoney=sstr[17]+"元";  //金额
		var Medicare=sstr[38];    //病历号
		var BatNoList=sstr[39];    //批号
		var MedDesc=sstr[9];        //品名
		var QtyUom=sstr[14]+sstr[15];  //数量
		var Dosage=sstr[12];        //剂量
		var Freq=sstr[13];          //频率
		var Intrus=sstr[18];        //用法
		var Duration=sstr[19];      //疗程
		var Notes=sstr[20];         //备注
		var Spec=sstr[24];          //规格
		var generic=sstr[26];       //通用名
		var identityCard=sstr[34];  //身份证
		var AgentUser=sstr[35];     //代办人
		var identityCardOfAgent=sstr[36];//代办人身份证
		var PrescDate=sstr[37];          //医嘱日期
		var Number=sstr[41];             //处方每日编号
		var trDoseUom=sstr[40];
		var useMethod="";
		
		if(j==0){
			//准备处方阅览的html
			var htmlstr="";
			//主DIV
			switch(PrescTitle){
				case "儿":
					htmlstr=htmlstr+'<div style="margin:30px;width:800px;height:700px;border:1px solid #000000;background:#FFCCFF;" class="mydiv">';
					break;
				case "急诊":
					htmlstr=htmlstr+'<div style="margin:30px;width:800px;height:700px;border:1px solid #000000;background:#FFCCFF;" class="mydiv">';
					break;
				case "麻、精一":
					htmlstr=htmlstr+'<div style="margin:30px;width:800px;height:700px;border:1px solid #000000;background:#FFCCFF;" class="mydiv">';
					useMethod="术中用";
					break;
				default:
					htmlstr=htmlstr+'<div style="margin:30px;width:800px;height:700px;border:1px solid #000000;">';  
			}	
			//标题
			htmlstr=htmlstr+'<div style="margin:20px 0px 15px 0px;width:800px;height:50;" align="center">';
			htmlstr=htmlstr+'<span style="font-size:22pt;font-family:华文楷体;font-weight:bold;margin:0px 0px 5px 0px;">安 徽 省 立 医 院</span>';
			htmlstr=htmlstr+'<span style="font-size:22pt;font-family:华文楷体;right:180px;position:absolute;" >['+PrescTitle+']</span>';
			htmlstr=htmlstr+'</br>';
			htmlstr=htmlstr+'<span style="font-size:22pt;font-family:华文楷体;font-weight:bold;">处方笺</span>';
			htmlstr=htmlstr+'</div>';
			//基本信息
			htmlstr=htmlstr+'<div style="width:800;height:100px;margin:0px 0px 5px 0px">';
			htmlstr=htmlstr+'<span style="margin:0px 0px 5px 80px;" class="font16">处方编号:</span><span class="btn-ui-width1 font12">'+PrescNo+'</span>';
			htmlstr=htmlstr+'<span style="margin:0px 0px 5px 60px;" class="font16">科别/床号:</span><span class="btn-ui-width1 font12">'+PatLoc+"   "+PatBed+'</span>';
			htmlstr=htmlstr+'</br>';
	
			htmlstr=htmlstr+'<div style="width:800;height:100px;margin:0px 0px 5px 0px">';
			htmlstr=htmlstr+'<span style="margin:0px 0px 5px 80px;" class="font16">病历号:</span><span class="btn-ui-width1 font12">'+Medicare+'</span>';
			htmlstr=htmlstr+'<span style="margin:0px 0px 5px 60px;" class="font16">登记号:</span><span class="btn-ui-width1 font12">'+PatNo+'</span>';
			htmlstr=htmlstr+'</br>';
	
			htmlstr=htmlstr+'<span style="margin:0px 0px 5px 80px;" class="font16">姓   名:</span><span class="btn-ui-width2 font12">'+PatName+'</span>';
			htmlstr=htmlstr+'<span style="margin:0px 0px 5px 50px;" class="font16">性别:</span><span class="btn-ui-width2 font12">'+PatSex+'</span>';
			htmlstr=htmlstr+'<span style="margin:0px 0px 5px 60px;" class="font16">年龄:</span><span class="btn-ui-width2 font12">'+PatAge+'</span>';
			htmlstr=htmlstr+'</br>';

			htmlstr=htmlstr+'<span style="margin:0px 0px 5px 80px;" class="font16">身份证:</span><span class="btn-ui-width3 font12">'+identityCard+'</span>';
			htmlstr=htmlstr+'</br>';

			htmlstr=htmlstr+'<span style="margin:0px 0px 5px 80px;" class="font16">代办人:</span><span class="btn-ui-width1 font12">'+AgentUser+'</span>';
			htmlstr=htmlstr+'<span style="margin:0px 0px 5px 60px;" class="font16">身份证:</span><span class="btn-ui-width1 font12">'+identityCardOfAgent+'</span>';
			htmlstr=htmlstr+'</br>';
			htmlstr=htmlstr+'</div>';
			//诊断
			htmlstr=htmlstr+'<div style="width:640;height:20px;margin:0px 80px 0px 80px;">';
			htmlstr=htmlstr+'<span style="margin:0px 0px 0px 0px;" class="font16">临床诊断:'+PatICD+'</span>'	
			htmlstr=htmlstr+'</div>';
			htmlstr=htmlstr+'<hr style="background-color:blue;height:1px;border:none;">'; //画线
			//医嘱信息
			htmlstr=htmlstr+'<div style="width:800;height:400px;margin:0px 0px 0px 0px;">';
			htmlstr=htmlstr+'<span style="font-size:22pt;font-family:华文楷体;margin:0px 0px 0px 50px;">Rp:</span>';
			htmlstr=htmlstr+'</p>';
		}

		htmlstr=htmlstr+'<span style="margin:0px 0px 0px 90px;" class="font16">'+(parseInt(j)+1)+"、"+MedDesc+" x "+QtyUom+'</span>';
		htmlstr=htmlstr+'</br>';

		htmlstr=htmlstr+'<span style="margin:0px 0px 0px 180px;" class="font16">Sig:'+Intrus+"	 "+trDoseUom+" 	"+Freq+"&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"+useMethod+'</span>';  ////Dosage
		htmlstr=htmlstr+'<span style="right:240px;position:absolute;" class="font16">批号:'+BatNoList+'</span>';
		htmlstr=htmlstr+'</p>';
	
		if(j==0){
			htmlstr=htmlstr+'<span style="margin:0px 0px 0px 150px;font-weight:bold;" class="font16">-------------------------(以下空白)-------------------------</span>';
			htmlstr=htmlstr+'</div>';
			//处方尾部
			htmlstr=htmlstr+'<div style="width:800;height:50px;margin:0px 0px 20px 0px;">';
			htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;" class="font16">金额:'+PrescMoney+'</span>';
			htmlstr=htmlstr+'<span style="margin:0px 0px 0px 340px;font-weight:bold;" class="font16">医生:'+Doctor+'</span>';
			htmlstr=htmlstr+'<hr style="background-color:blue;height:1px;border:none;">'; //画线
	
			htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;" class="font16">审核:'+PyName+'</span>';
			htmlstr=htmlstr+'<span style="position:absolute;right:430px;" class="font16">核对:'+FyName+'</span>';
			htmlstr=htmlstr+'<span style="position:absolute;right:180px;" class="font16">日期:'+PrescDate+'</span>';
			htmlstr=htmlstr+'</br>';
	
			htmlstr=htmlstr+'<span style="margin:0px 0px 0px 80px;" class="font16">调配:'+FyName+'</span>';
			htmlstr=htmlstr+'<span style="position:absolute;right:430px;" class="font16">发药:'+PyName+'</span>';
			htmlstr=htmlstr+'<span style="position:absolute;right:180px;" class="font16">No:'+Number+'</span>';
			htmlstr=htmlstr+'</div>';

			htmlstr=htmlstr+'</div>';
		}
	}
	//return htmlstr;
	$('#win').append(htmlstr);
	return;
}

//获取发药主信息 2014-11-21 bianshuai
function getOpDispMainInfo(phac)
{
	var retval=tkMakeServerCall("web.DHCSTPCHCOLLPRN","GetOperPhaColl",phac);
	return retval;
}

/// 关闭并移除窗体
function CloseWin()
{
	$('#win').window('close'); //关闭
	$('#win').remove();
	window.close();//关闭父窗口
}

/// 获取参数
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

///快捷键
$(document).keydown(function(e){
	return;
	//S 键（83）确认(回车：13)
	if(e.which == 13) {
		CloseWin();
		window.returnValue = "1";
	}
	//C键（67）关闭(ctrl:17)
	if(e.which == 17) {
		CloseWin();
	}
});