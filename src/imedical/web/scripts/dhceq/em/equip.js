var curYear=""; //��¼������������ʱ���޽ڵ�
$(function(){
	initDocument();
});
//modified by sjh SJH0027 2020-06-12 �޸�̨�ʽ����С��ˡ���Ϊ���ʡ�
function initDocument(){
	//�ۺϲ�ѯʱӰ�ر༭��ť
	//Modify by zx 2020-08-20 �༭��ť�ſ�,���ƿɱ༭���� BUG ZX0102
	//if (getElementValue("ReadOnly")==1) {$('#EquipInfo').layout('panel', 'center').panel({ title: '��Ϣ����' });}
	//����ͷ����ť
	if(getElementValue("ToolBarFlag")!=1){$("#EquipShow").layout('remove','north');}
	//����������Ϣ�鿴
	//add by zx 2019-06-11 ͼƬ�������Ȳ���Ӱ�ش���,ͨ��ReadOnly����
	/*if(getElementValue("DetailListFlag")!=1)
	{
		$("#EquipCard").layout('remove','center');
		$("#LifeInfoFind").hide();
	}
	else {initCardInfo();}*/
	initCardInfo();  //add by zx 2019-06-24  ���������� 939539
	//������������
	if(getElementValue("LifeInfoFlag")!=1){$('#EquipInfo').layout('remove','east');}
	else {
		lifeInfoKeywords();
		initLifeInfo("");
	}
	initUserInfo();
	fillData();
	initImage();
	if (tkMakeServerCall("web.DHCEQCommon","GetSysInfo",990079)!=1) $("#ConfigCard").remove();	// Mozy003002	2020-03-18	���θ����豸ģ��
};

///Creator: zx
///CreatDate: 2018-08-23
///Description: ��������ɸѡ��ؼ��ּ���
function lifeInfoKeywords()
{
	$("#LifeInfoItemDetail").keywords({
	    items:[
	        {
	            text:"",
	            type:"chapter", //��
	            items:[
	                {
	                    text:'������Ϣ',
	                    type:"section", //��  modifed by wy 2019-3-29
	                    items:[
	                        {text:'����',id:"91",selected:true},{text:'�ƻ�',id:"92",selected:true},{text:'�б�',id:'93',selected:true},{text:'��ͬ',id:'94',selected:true},{text:'����',id:'11',selected:true} 	                    ]
	                },
	                {
	                    text:"�ⷿ�䶯",
	                    type:'section', //��
	                    items:[
	                        {text:'���',id:"21",selected:true},{text:'ת��',id:"22",selected:true}
	                    ]
	                },
	                {
	                    text:"ά����Ϣ",
	                    type:'section', //��
	                    items:[
	                        {text:'ά��',id:"31",selected:true},{text:'������Ѳ��',id:'33',selected:true},{text:'����',id:'32',selected:true}  //add by zx 2019-03-28 ����������:852959
	                    ]
	                },
	                {
	                    text:"������Ϣ",
	                    type:'section', //��
	                    items:[
	                        {text:'����',id:"34",selected:true},{text:'�˻�������',id:'23',selected:true}
	                    ]
	                },
	                {
	                    text:"������Ϣ",
	                    type:'section', //��
	                    items:[
	                        {text:'�۾�',id:"35",selected:true},{text:'����',id:"51",selected:true},{text:'���ü�ͣ��',id:'41',selected:true},{text:'���ݵ���',id:"61",selected:true},{text:'��������',id:"82",selected:true},{text:'���',id:"55",selected:true}	//czf 2021-07-28 2014955
	                    ]
	                }
	            ]
	        }
	    ],
	});
}

///Creator: zx
///CreatDate: 2018-08-23
//��ť���¼�
$("#LifeInfoSeach").click(function(){
	//add by zx 2019-03-28 ����������:852959
	curYear=""	
	initLifeInfo();
	$('#LifeInfoFind').webuiPopover('hide');  //����Ӱ��
	});
///Creator: zx
///CreatDate: 2018-08-23
///Description: �������ڼ�����ʽ����
$('#LifeInfoFind').webuiPopover({width:330});  // modified by kdf 	����ţ�865567 

///Creator: zx
///CreatDate: 2018-08-23
///Description: ��ȡ̨����Ϣ������
function fillData()
{
	var RowID=getElementValue("RowID");
	if (RowID=="") return;
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","GetOneEquip",RowID);
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow('alert','error','��ʾ',jsonData.Data,'','','');return;}
	//jsonData.Data=GetJSONDataBySys(jsonData.Data);  //Add by JYP 2019-08-26
	setElementByJson(jsonData.Data); // hisuiͨ�÷���ֻ�ܸ�inputԪ�ظ�ֵ,�˷�������д
	showFieldsTip(jsonData.Data); // ��ϸ�ֶ���ʾ����ToolTip
	showFundsTip(jsonData.Data);  // �ʽ���Դ��Ϣtooltip
	//add by csj 20190215 �豸״̬�����ڿ�Ĳ������˻�
	if(getElementValue("EQStatus")!=0){
		disableElement("returnBtn",true)
	}
	$("#Banner").attr("src",'dhceq.plat.banner.csp?&EquipDR='+RowID); //add by zx 2019-02-15 ��ֹbanner������ݼ���
	//add by csj 2020-03-30 �����ڼ����豸���ü�����ť
	var Data=tkMakeServerCall("web.DHCEQ.EM.BUSEquipAttribute","CheckEquipHaveAttributeGroup","01",3, RowID);
	if(Data!="Y"){
		disableElement("BMeterage",true)
	}
    //modified by ZY 2913588,2913589,2913590
    
    var ExclusiveType=tkMakeServerCall("web.DHCEQ.EM.BUSOpenCheckRequest","GetExclusiveType",1,RowID)
    if (ExclusiveType=="DHCEQLand") //������Ϣ
    {
        var desc=$("#EQEquipTypeDR_ETDesc").html()
        $("#EQEquipTypeDR_ETDesc").html('<a href="#" style="margin:0;font-weight:800;" onclick="javascript:equipLand()">'+desc+'</a>')
    }
    else if (ExclusiveType=="DHCEQBuilding")    //������Ϣ
    {
        var desc=$("#EQEquipTypeDR_ETDesc").html()
        $("#EQEquipTypeDR_ETDesc").html('<a href="#" style="margin:0;font-weight:800;" onclick="javascript:equipBuilding()">'+desc+'</a>')
    }
    else if (ExclusiveType=="DHCEQIntangibleAssets")    //�����ʲ���Ϣ
    {
        var desc=$("#EQEquipTypeDR_ETDesc").html()
        $("#EQEquipTypeDR_ETDesc").html('<a href="#" style="margin:0;font-weight:800;" onclick="javascript:equipIntangibleAssets()">'+desc+'</a>')
    }
    else if (ExclusiveType=="DHCEQVehicle") //������Ϣ
    {
        var desc=$("#EQStatCatDR_SCDesc").html()
        $("#EQStatCatDR_SCDesc").html('<a href="#" style="margin:0;font-weight:800;" onclick="javascript:equipVehicle()">'+desc+'</a>')
    }
    
    $HUI.switchbox('#IdleFlagSwitch',{
       onText:'����',
       offText:'������',
       onClass:'primary',
       offClass:'gray',
       checked:false,
       onSwitchChange:function(e,obj){
           var RowID=getElementValue("RowID");
           var ExclusiveType=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","UpdateIdleFlag",RowID,obj.value)
       }
    })
	//modified by ZY 20221111 2993799
    var EQIdleFlag=getElementValue("EQIdleFlag")
    if (EQIdleFlag==0) EQIdleFlag=false
    else EQIdleFlag=true
    $('#IdleFlagSwitch').switchbox('setValue', EQIdleFlag);
}

///Creator: zx
///CreatDate: 2018-08-23
///Description: Ԫ�ظ�ֵ
///Input: vJsonInfo ��̨��ȡ��json����
///Other: ƽ̨ͳһ�����˴�������
function setElementByJson(vJsonInfo)
{
	for (var key in vJsonInfo)
	{
		var str=getShortString(vJsonInfo[key]);
		//add by zx 2019-06-17
		if (key=="EQAdvanceDisFlag") str=(vJsonInfo["EQHold1"]=="")?getShortString(vJsonInfo["EQAdvanceDisFlagDesc"]):getShortString(vJsonInfo["EQAdvanceDisFlagDesc"]+"("+vJsonInfo["EQHold1"]+")");  //add by zx 2019-07-05 ȥ������
		$("#"+key).text(str);
		if((key=="EQComputerFlag")||(key=="EQCommonageFlag")||(key=="EQRaditionFlag"))
		{
			if (vJsonInfo[key]=="1") $("#"+key).text("��");
			else $("#"+key).text("��");
		}
		if((key=="EQGuaranteePeriodNum")&&(vJsonInfo["EQGuaranteePeriodNum"]!="")) $("#"+key).text(vJsonInfo[key]+"��");
		if(vJsonInfo["EQAddDepreMonths"]!="")
		{
			var AddDepreMonths=parseInt(vJsonInfo["EQAddDepreMonths"]);
			if(AddDepreMonths>0) $("#EQLimitYearsNum").text(vJsonInfo["EQLimitYearsNum"]+" (��"+AddDepreMonths+"��)");
			else $("#EQLimitYearsNum").text(vJsonInfo["EQLimitYearsNum"]+" (��"+AddDepreMonths+"��)");
		}
        //modified by ZY 2913588,2913589,2913590
        /*
		if (vJsonInfo["EQEquipTypeDR"]==getElementValue("BuildingType"))
		{
			$("#EQEquipTypeDR_ETDesc").html('<a href="#" style="margin:0;font-weight:800;" onclick="javascript:equipBuilding()">'+vJsonInfo["EQEquipTypeDR_ETDesc"]+'</a>')
		}
		else if (vJsonInfo["EQStatCatDR"]==getElementValue("VehicleType")) //Modified By QW20220406 BUG:QW0157 ���ݳ�������
		{
			$("#EQStatCatDR_SCDesc").html('<a href="#" style="margin:0;font-weight:800;" onclick="javascript:equipVehicle()">'+vJsonInfo["EQStatCatDR_SCDesc"]+'</a>')
		}
		else
		{
			$("#EQEquipTypeDR_ETDesc").text(vJsonInfo["EQEquipTypeDR_ETDesc"])
		}
		if(key=="EQEquiCatDR_ECDesc") //Add By QW202208016 begin �����:2760300 �����ʲ�������ʾ,��Ϊ���ؿ���ת
		{
			var ECCode=vJsonInfo["EQEquiCatDR_ECCode"]
			if((ECCode.substring(0,3)=="101")||(ECCode=="7040101"))    ///����
			{
				$("#EQEquiCatDR_ECDesc").html('<a href="#" style="margin:0;font-weight:800;" onclick="javascript:equipLand()">'+vJsonInfo["EQEquiCatDR_ECDesc"]+'</a>')
			}
        }*/
		//alertShow(vJsonInfo["EQHold1"])
		//if(vJsonInfo["EQHold1"]!="") $("#EQAdvanceDisFlagDesc").text(vJsonInfo["EQAdvanceDisFlagDesc"]+" ��"+vJsonInfo["EQHold1"]+"��");
	}
	setElement("EQStatus",vJsonInfo.EQStatus)
	setElement("EQStatusDisplay",vJsonInfo.EQStatusDisplay)
	setElement("EQParentDR",vJsonInfo.EQParentDR);		//Mozy	914928	2019-7-11
	setElement("EQName",vJsonInfo.EQName); //Add By QW20220406 BUG:QW0157 ���ݳ�������
    //modified by ZY 20221111 2993799
    setElement("EQIdleFlag",vJsonInfo.EQIdleFlag);
}

///Creator: zx
///CreatDate: 2018-08-23
///Description: �����ַ����Ƚ�ȡ������Ϣ��ƴ��"..."
///Input: string ��Ҫ��ȡ���ַ���
function getShortString(string)
{
	string=string.toString(); //����int��ҪתΪstring
	var result = ""; //���ؽ��
	var j = 0;  //�ֽ�����Ϊ���Ʋ���
	for(var i = 0;i < string.length; i++){
		if(string.charCodeAt(i) > 255) //����Ǻ��֣����ַ������ȼ�2
		{
			j+=2;
		}
		else  //���ֻ���ĸ���ȼ�1
		{
			j++;
		}
		if (j>12) return result+"..."; //����������ʾ�ֽ���Ϊ12,�����������ֱֵ���˳������ؽ��
		result=result+string[i];
	}
	return result;
}

///Creator: zx
///CreatDate: 2018-08-24
///Description: ��������������Ϣ��ȡ
function initLifeInfo()
{
	//add by zx 2019-03-28 ����������:852959
	var keyObj=$HUI.keywords("#LifeInfoItemDetail").getSelected();
	var sourceTypeDRs="";
	for (i=0;i<keyObj.length;i++)
	{
		//�ؼ����б��ȡid��
		if (sourceTypeDRs!="") sourceTypeDRs=sourceTypeDRs+",";
		sourceTypeDRs=sourceTypeDRs+keyObj[i].id;
	}
	$.cm({
		ClassName:"web.DHCEQ.EM.BUSLifeInfo",
		QueryName:"LifeInfo",
		EquipDR:$("#RowID").val(),
		LocDR:"",
		EquipTypeDR:"",
		LifeTypeDR:"",
		StartDate:"",
		EndDate:"",
		SourceTypeDR:sourceTypeDRs,
		QXType:""
	},function(jsonData){
		createLifeInfo(jsonData);
	});
}

///Creator: zx
///CreatDate: 2018-08-24
///Description: �����������ݽ�������
///Input: �����������ݼ�
function createLifeInfo(jsonData)
{
	$("#LifeInfoView").empty(); //ÿ�μ���֮ǰ�Ƴ���ʽ
	//��ʱ�䵹��,�����ֵ����
	for (var i=jsonData.rows.length-1;i>=0;i--)
	{
		var changeDate=jsonData.rows[i].TChangeDate; //�䶯����
		var changeTime=jsonData.rows[i].TChangeTime; //�䶯ʱ��  //Modife by zc 2020-09-18 ZC0083 ���ʱ��
		var appendType=jsonData.rows[i].TAppendType;	//�䶯����
		var sourceTypeDR=jsonData.rows[i].TSourceTypeDR;
		var sourceID=jsonData.rows[i].TSourceID;
		var usedFee=jsonData.rows[i].TUsedFee;
		var year=jsonData.rows[i].TYear;
		var keyInfo=jsonData.rows[i].TKeyInfo;
		
		var section="";
		var flag="";
		if(i==0) flag=1;
		if (curYear!=year)
		{
			curYear=year;
			section="eq-lifeinfo-lock.png^"+year;
		}
		var url='href="#" onclick="javascript:lifeInfoDetail('+sourceTypeDR+','+sourceID+')"';
		opt={
			id:'LifeInfoView',
			section:section,
			item:'^^'+changeDate+" "+changeTime+'%^'+url+'^'+appendType+':'+usedFee+'%^^'+keyInfo,   //Modife by zc 2020-09-18 ZC0083 ���ʱ��
			lastFlag:flag
		}
		
		createTimeLine(opt);
	}
}

///Creator: zx
///CreatDate: 2018-08-24
///Description: �������ڳ����ӵ��
///Input: sourceTypeDR ҵ�����  sourceID ҵ��id
function lifeInfoDetail(sourceType,sourceID)
{
	if (sourceType=="35")
	{
		messageShow('alert','info','��ʾ','�۾���ҵ�����ݣ�','','','')
		return;
	}
	var url="dhceqlifeinfo.csp?&SourceType="+sourceType+"&SourceID="+sourceID;
	//modify by lmm 2019-02-16 begin
	//modify by lmm 2020-06-02
	if (sourceType=="31")
	{
		showWindow(url,"ҵ������","","","icon-w-paper","modal","","","large");  
	}
	else if(sourceType=="11")
	{
		showWindow(url,"ҵ������","","","icon-w-paper","modal","","","large");  
	}
	else if((sourceType=="32")||(sourceType=="33"))
	{
		//Modefied by zc0109 2021-12-02  �޸ĵ����С begin
		showWindow(url,"ҵ������","","","icon-w-paper","modal","","","large");  
	}
	else
	{
		showWindow(url,"ҵ������","","","icon-w-paper","modal","","","large"); 
	}
	//modify by lmm 2019-02-16 end
	
}

///Creator: zx
///CreatDate: 2018-08-23
///Description: ҳ�������Ϣ�󻬶���ť
$('#moveLeft').click(function(){
	moveView(1);
});

///Creator: zx
///CreatDate: 2018-08-23
///Description: ҳ�������Ϣ�һ�����ť
$('#moveRight').click(function(){
	moveView(2);
});

///Creator: zx
///CreatDate: 2018-08-23
///Description: ��������,�����ڲ�div��ʾӰ��,�������׺��ֹ���
///Input: type �������� 1�� 2��
function moveView(type)
{
	var arry=new Array();
	var arryView= new Array();
	var viewLen=0; //��������ģ������
	var stopFlag=0; //�Ƿ�ֹͣ�˷��򻬶�
	$(".eq-card").each(function(index){
		viewLen=viewLen+1;
	 	if($(this).hasClass("eq-card-active")){arry.push(index)}; //��ǰ�ɼ�����ģ���������arry��
	});
	if (type==1)
	{
		if (arry[0]-1<0) return;
		for(j=0,len=arry.length;j<len;j++) {
			arryView.push(arry[j]-1);  //����ʱ����ģ��λ�ü�һ
			if (arry[j]-1==0) stopFlag=1; //������������ģ����������ʱ��Ҫ����ֹͣ��־
		}
	}
	else
	{
		var len=arry.length;
		if (arry[len-1]+1>=viewLen) return;
		for(j=0;j<len;j++) {
			arryView.push(arry[j]+1); //����ʱ����ģ��λ�ü�һ
			if (arry[j]+2>=viewLen) stopFlag=1; //������������ģ����������ʱ��Ҫ����ֹͣ��־
		}
	}
	if(stopFlag==1)
	{
		//ֹͣ��־ʱ��ذ�ť��ʽ�ı�
		if(type==1)
		{
			$("#moveLeft").removeClass("eq-card-move");
		 	$("#moveLeft").addClass("eq-card-stop");
		}
		else
		{
			$("#moveRight").removeClass("eq-card-move");
		 	$("#moveRight").addClass("eq-card-stop");
		}
	}
	else
	{
		// ������ֹͣʱ��ʽ��ť�ָ�
		$("#moveLeft").addClass("eq-card-move");
		$("#moveLeft").removeClass("eq-card-stop");
		$("#moveRight").addClass("eq-card-move");
		$("#moveRight").removeClass("eq-card-stop");
	}
	//�ڿ���ʾ������ʱ��ʾ����ģ��,���������ش���
	$(".eq-card").each(function(index){
		if (arryView.indexOf(index)==-1)
		{$(this).removeClass("eq-card-active");}
		else{$(this).addClass("eq-card-active");}
	});
}

///Creator: zx
///CreatDate: 2018-08-23
///Description filldata��ϸ�ֶ���ʾ����ToolTip
///Input: data ��̨����̨������
function showFieldsTip(data)
{
	$(".eq-table-info").each(function(index){
		var id=$(this).attr("id");
		if (!id) return;  //ռλԪ�ز�����
		if ((id=="EQComputerFlag")||(id=="EQCommonageFlag")||(id=="EQRaditionFlag")) var stringDate=$("#"+id).text();
		//add by zx 2019-06-17
		else if (id=="EQAdvanceDisFlag") var stringDate=(data["EQHold1"]=="")?data["EQAdvanceDisFlagDesc"]:data["EQAdvanceDisFlagDesc"]+"("+data["EQHold1"]+")";  //add by zx 2019-07-05 ƴ��bug�޸�
		else if (id=="EQLimitYearsNum") 
		{
			if (data["EQAddDepreMonths"]>0) var stringDate=data[id]+" (��"+data["EQAddDepreMonths"]+"��)";
			else if (data["EQAddDepreMonths"]<0) var stringDate=data[id]+" (��"+data["EQAddDepreMonths"]+"��)";
			else var stringDate=data[id];
		}
		else var stringDate=data[id];
		if (stringDate=="") return; //ֵΪ��Ԫ�ز�����
		$HUI.tooltip('#'+id,{
			position: 'bottom',
			content: function(){
					return stringDate; //��ʾֵ�ӷ��������л�ȡ
				},
			onShow: function(){
				$(this).tooltip('tip').css({
					backgroundColor: '#88a8c9',
					borderColor: '#4f75aa',
					boxShadow: '1px 1px 3px #4f75aa'
				});
			 },
			onPosition: function(){
				$(this).tooltip('tip').css('bottom', $(this).offset().bottom);
				$(this).tooltip('arrow').css('bottom', 20);
			}
		});
	});
}

///Creator: zx
///CreatDate: 2018-08-23
///Description �ʽ���Դ��ϸ��ϢToolTip
///Input: data ��̨����̨������
function showFundsTip(data)
{
	var RowID=$("#RowID").val();
	//�첽����
	var jsonData = $.cm({
		ClassName:"web.DHCEQ.EM.BUSFunds", //Modified BY QW20200320 BUG:QW0054
		QueryName:"GetFunds",
		FromType:"1",
		FromID:RowID,
		FundsAmount:data["EQOriginalFee"]
	},false);
	$HUI.tooltip('#EQFunds',{
		position: 'bottom',
		content: function(){
			var content='<div style="padding:5px;font-size:16px;color:#ffffff"><ul>';
			for (var i=0;i<jsonData.rows.length;i++)
			{
				var TFundsTypeDR=jsonData.rows[i].TFundsTypeDR;
				var TFundsType=jsonData.rows[i].TFundsType;
				var TFee=jsonData.rows[i].TFee;
				var TFinaceItem=jsonData.rows[i].TFinaceItem; //Add BY QW20200320 BUG:QW0054
				var TCurDepreTotalFee=jsonData.rows[i].TCurDepreTotalFee; //Add BY QW20200320 BUG:QW0054
				if (TFundsTypeDR==data["EQSelfFundsFlag"]) continue;
				content=content+'<li>'+TFundsType+'��'+TFee+' '+'�ۼ��۾�:'+TCurDepreTotalFee+' '+'������Ŀ:'+TFinaceItem+'</li>'; //Modified BY QW20200320 BUG:QW0054
			}
			content=content+'</ul></div>';
			return content;
		},
		onShow: function(){
			$(this).tooltip('tip').css({
				backgroundColor: '#88a8c9',
				borderColor: '#4f75aa',
				boxShadow: '1px 1px 3px #4f75aa'
			});
		 },
		onPosition: function(){
			$(this).tooltip('tip').css('bottom', $(this).offset().bottom);
			$(this).tooltip('arrow').css('bottom', 20);
		}
	});
}

///Creator: zx
///CreatDate: 2018-08-24
///Description ̨����Ϣ�༭����
function equipEdit()
{
	//Modify by zx 2020-08-20 BUG ZX0102
	var RowID=$("#RowID").val();
	var ReadOnly=getElementValue("ReadOnly");
	var url="dhceq.em.equipedit.csp?RowID="+RowID+"&ReadOnly="+ReadOnly;
	showWindow(url,"�ʲ���Ϣ�༭","","15row","icon-w-paper","modal","","","large");  //modify by lmm 2020-06-01 UI
}

///Creator: zx
///CreatDate: 2018-09-20
///Description ̨�ʵײ���Ϣ��ʾ
function initCardInfo()
{
	$cm({
		ClassName:"web.DHCEQ.EM.BUSEquip",
		MethodName:"EquipRelatedInfo",
		Type:"",
		EquipDR:getElementValue("RowID"),
		CheckListDR:""
	},function(jsonData){
		if (jsonData.SQLCODE<0) {messageShow('alert','error','��ʾ',jsonData.Data,'','','');return;}
    	//jsonData.Data=GetJSONDataBySys(jsonData.Data);  //Add by JYP 2019-08-26
		$("#AffixNum").text("("+jsonData.Data["AffixNum"]+")");
		$("#PicNum").text("("+jsonData.Data["PicNum"]+")");
		//Modify by zx 2021-05-20 ��ʾ����ļ�����
		$("#DocNum").text("("+jsonData.Data["DocNum"]+")");
		$("#AppendFileNum").text("("+jsonData.Data["AppendFileNum"]+")");
		$("#ContractNum").text("("+jsonData.Data["ContractNum"]+")");
		$("#ConfigNum").text("("+jsonData.Data["ConfigNum"]+")");
		$("#EquipConfigNum").text("("+jsonData.Data["EquipConfigNum"]+")");
		$("#TreeNum").text("("+jsonData.Data["TreeNum"]+")");
		if(jsonData.Data["AffixInfo"]!="")
		{
			$("#AffixContent").empty();
			var data=jsonData.Data["AffixInfo"];
			var dataDetail=data.split("^");
			for(i=0;i<dataDetail.length;i++)
			{
				var dataItem=dataDetail[i].split("&");
				var nameText=dataItem[0];
				var numText=dataItem[1];
				var unit=dataItem[2];
				if (i>3)
				{
					$("#AffixMore").css('display','block');
					continue;
				}
				makeCardItemInfo("AffixContent",nameText,numText,unit)
			}
		}
		if(jsonData.Data["PicInfo"]!="")
		{
			$("#PicContent").empty();
			var data=jsonData.Data["PicInfo"];
			var dataDetail=data.split("^");
			for(i=0;i<dataDetail.length;i++)
			{
				var dataItem=dataDetail[i].split("&");
				var nameText=dataItem[0];
				var numText=dataItem[1];
				var unit=dataItem[2];
				if (i>3)
				{
					$("#PicMore").css('display','block');
					continue;
				}
				makeCardItemInfo("PicContent",nameText,numText,unit)
			}
		}
		//Modify by zc0076 2020-6-17 �ָ����ε�����ļ� begin
		//Modify by zx 2020-02-19 BUG ZX0076
		if(jsonData.Data["DocInfo"]!="")
		{
			$("#DocContent").empty();
			var data=jsonData.Data["DocInfo"];
			var dataDetail=data.split("^");
			for(i=0;i<dataDetail.length;i++)
			{
				var dataItem=dataDetail[i].split("&");
				var nameText=dataItem[0];
				var numText=dataItem[1];
				var unit=dataItem[2];
				if (i>3)
				{
					$("#DocMore").css('display','block');
					continue;
				}
				makeCardItemInfo("DocContent",nameText,numText,unit)
			}
		}
		//Modify by zc0076 2020-6-17 �ָ����ε�����ļ� begin
		if(jsonData.Data["AppendFileInfo"]!="")
		{
			$("#AppendFileContent").empty();
			var data=jsonData.Data["AppendFileInfo"];
			var dataDetail=data.split("^");
			for(i=0;i<dataDetail.length;i++)
			{
				var dataItem=dataDetail[i].split("&");
				var nameText=dataItem[0];
				var numText=dataItem[1];
				if (i>3)
				{
					$("#AppendFileMore").css('display','block');
					continue;
				}
				makeCardItemInfo("AppendFileContent",nameText,numText,"")
			}
		}
		if(jsonData.Data["ContractInfo"]!="")
		{
			$("#ContractContent").empty();
			var data=jsonData.Data["ContractInfo"];
			var dataDetail=data.split("^");
			for(i=0;i<dataDetail.length;i++)
			{
				var dataItem=dataDetail[i].split("&");
				var nameText=dataItem[0];
				var numText=dataItem[1];
				var linkID=dataItem[2];
				if (i>3)
				{
					$("#ContractMore").css('display','block');
					continue;
				}
				makeContractDetailInfo("ContractContent",nameText,numText,linkID);
			}
		}
		if(jsonData.Data["ConfigInfo"]!="")
		{
			$("#ConfigContent").empty();
			var data=jsonData.Data["ConfigInfo"];
			var dataDetail=data.split("^");
			for(i=0;i<dataDetail.length;i++)
			{
				var dataItem=dataDetail[i].split("&");
				var nameText=dataItem[0];
				var numText=dataItem[1];
				if (i>3)
				{
					$("#ConfigMore").css('display','block');
					continue;
				}
				makeCardItemInfo("ConfigContent",nameText,numText,"")
			}
		}
		if(jsonData.Data["EquipConfigInfo"]!="")
		{
			$("#EquipConfigContent").empty();
			var data=jsonData.Data["EquipConfigInfo"];
			var dataDetail=data.split("^");
			for(i=0;i<dataDetail.length;i++)
			{
				var dataItem=dataDetail[i].split("&");
				var nameText=dataItem[0];
				var numText=dataItem[1];
				if (i>3)
				{
					$("#EquipConfigMore").css('display','block');
					continue;
				}
				makeCardItemInfo("EquipConfigContent",nameText,numText,"")
			}
		}
		if(jsonData.Data["TreeInfo"]!="")
		{
			$("#TreeContent").empty();
			var data=jsonData.Data["TreeInfo"];
			var dataDetail=data.split("^");
			for(i=0;i<dataDetail.length;i++)
			{
				var dataItem=dataDetail[i].split("&");
				var nameText=dataItem[0];
				var numText=dataItem[1];
				if (i>3)
				{
					$("#TreeMore").css('display','block');
					continue;
				}
				makeCardItemInfo("TreeContent",nameText,numText,"")
			}
		}
	});
}

function makeCardItemInfo(id,nameText,numText,unit)
{
	var html='<div class="eq-card-item"><span class="eq-card-item-text">'+nameText+'</span><span class="eq-card-item-num">'+numText+unit+'</span></div>';
	$("#"+id).append(html);
}

function makeContractDetailInfo(id,nameText,numText,linkID)
{
	var html='<div class="eq-card-item"><span class="eq-card-item-text"><a href="#" onclick="javascript:contractDetail('+linkID+')">'+nameText+'</a></span><span class="eq-card-item-num">'+numText+'</span></div>';
	$("#"+id).append(html);
}
// Mozy003005	1249755		2020-4-1	�������޺�ͬ����
function contractDetail(linkID)
{
	var val="&RowID="+linkID+"&ReadOnly=1&QXType=1&ContractType=1";
	var url="dhceq.con.contractformaint.csp?"+val;
	showWindow(url,"���޺�ͬ��Ϣ","","","icon-w-paper","modal","","","large");
}

///Creator: zx
///CreatDate: 2018-08-24
///Description ���ʵ�����
function changeAccount()
{
    var RowID=getElementValue("RowID");
    var ReadOnly=getElementValue("ReadOnly");
    ///modified by ZY 2857906 20220818
    //var url="dhceqchangeaccount.csp?RowID="+RowID+"&ReadOnly="+ReadOnly;
    var url="dhceq.em.changeaccount.csp?RowID="+RowID+"&ReadOnly="+ReadOnly;
    showWindow(url,"������Ϣ","","","icon-w-paper","modal","30","15","verylarge",refreshWindow);  //MZY0157	3220814		2023-03-29
}

///Creator: zx
///CreatDate: 2018-09-13
///Description �豸���õ�����
function equipStart()
{
	var RowID=getElementValue("RowID");
	var ReadOnly=getElementValue("ReadOnly");
	var Status=getElementValue("EQStatus");
	if (Status<"2")
	{
		ReadOnly=1;
	}
	var StatusDisplay=getElementValue("EQStatusDisplay");
	var url='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQEquipStart&EquipID='+RowID+"&ReadOnly="+ReadOnly+"&FromStatusDR="+Status+"&FromStatus="+StatusDisplay+"&StartFlag=Y";
	showWindow(url,"�ʲ�����","","","icon-w-paper","modal","","","large",reloadPage);  //modify by lmm 2020-06-01 UI
}
///Creator: zx
///CreatDate: 2018-09-13
///Description �豸ͣ�õ�����
function equipStop()
{
	var RowID=getElementValue("RowID");
	var ReadOnly=getElementValue("ReadOnly");
	var Status=getElementValue("EQStatus");
	if (Status=="2")
	{
		ReadOnly=1;
	}
	var StatusDisplay=getElementValue("EQStatusDisplay");
	var url='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQEquipStop&EquipID='+RowID+"&ReadOnly="+ReadOnly+"&FromStatusDR="+Status+"&FromStatus="+StatusDisplay+"&StopFlag=Y";
	showWindow(url,"�ʲ�ͣ��","","","icon-w-paper","modal","","","large",reloadPage);  //modify by lmm 2020-06-01 UI
}

function reloadPage()
{
	var str="dhceq.em.equip.csp?&RowID="+getElementValue("RowID")+"&ReadOnly="+getElementValue("ReadOnly")+"&ToolBarFlag="+getElementValue("ToolBarFlag")+"&LifeInfoFlag="+getElementValue("LifeInfoFlag")+"&DetailListFlag="+getElementValue("DetailListFlag");
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		str += "&MWToken="+websys_getMWToken()
	}
	window.location.href=str
}


///Creator: jyp
///CreatDate: 2019-02-16
///Description �豸���Ե�����
function equipAttribute()
{
	var RowID=getElementValue("RowID");
	var ReadOnly=getElementValue("ReadOnly");
	var Status=getElementValue("EQStatus");
	var url='dhceq.em.equipattributelist.csp?SourceID='+RowID+"&SourceType=3"+"&ReadOnly="+ReadOnly;
	showWindow(url,"�豸����","","","icon-w-paper","modal","220","65","middle");  //MZY0157	3220824		2023-03-29
}
///Creator: zx
///CreatDate: 2018-09-13
///Description �豸���޵�����
function maintRequest()
{
	//modified by csj 20190125 
	var RowID=getElementValue("RowID");
	var url="dhceq.em.mmaintrequestsimple.csp?ExObjDR="+RowID+"&QXType=&WaitAD=off&Status=0&RequestLocDR="+curLocID+"&StartDate=&EndDate=&InvalidFlag=N&vData=^Action=^SubFlag=&LocFlag="+curLocID;
	showWindow(url,"ά������","694px","727px","icon-w-paper","modal","373","51","middle");  //MZY0157	3220827		2023-03-29
}

///Creator: zx
///CreatDate: 2018-09-13
///Description �豸������¼������
function meterage()
{
	var RowID=getElementValue("RowID");
	var url="dhceq.em.meterage.csp?BussType=2&EquipDR="+RowID+"&RowID="+"&MaintTypeDR=5";
	showWindow(url,"������¼","","437px","icon-w-paper","modal","","","large");		// MZY0151	2023-02-01
}

///Creator: zx
///CreatDate: 2018-09-13
///Description �豸Ѳ���¼������
function inspect()
{
	var RowID=getElementValue("RowID");
	var url="dhceq.em.inspect.csp?BussType=2&EquipDR="+RowID+"&RowID="+"&MaintTypeDR=4";	//modified by csj 20191202 ���Ѳ��ά�����Ͳ���
	showWindow(url,"����¼","","","icon-w-paper","modal","","","large");		// MZY0154	3249067		2023-03-03
}

function returnRequest()
{
	//modified by csj 20190125 
	var RowID=getElementValue("RowID");
	//modified by ZY0229 20200511
	url="dhceq.em.return.csp?EquipDR="+RowID+"&ROutTypeDR=1&WaitAD=off&QXType=2"; 
	showWindow(url,"�ʲ��˻�","","","icon-w-paper","modal","","","large");   //modify by lmm 2019-02-16
}

///Creator: zx
///CreatDate: 2018-09-13
///Description �豸���ϵ�����
function disuseRequest()
{
	var RowID=getElementValue("RowID");
	var ReadOnly=getElementValue("ReadOnly");
	var url='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQBatchDisuseRequest&DType=1&Type=0&EquipDR='+RowID+"&RequestLocDR="+curLocID+"&ReadOnly="+ReadOnly; //sessionֵ��Ҫ�滻
	showWindow(url,"�ʲ�����","","","icon-w-paper","modal","","","large");   //modify by lmm 2020-06-02 UI
	
}

///Creator: zx
///CreatDate: 2018-08-29
///Description �����༭������
function affixEdit()
{
	var RowID=getElementValue("RowID");
	var ReadOnly=getElementValue("ReadOnly");
	var EQParentDR=getElementValue("EQParentDR");
	var url='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAffix&EquipDR='+RowID+"&ConfigFlag="+EQParentDR+"&ReadOnly="+ReadOnly;	//Mozy	914928	2019-7-11	���Ӳ���ConfigFlag
	showWindow(url,"�豸����","","","icon-w-paper","modal","","","large");    //modify by lmm 2020-06-04 UI
}

///Creator: zx
///CreatDate: 2018-08-29
///Description ͼƬ���ϱ༭������
function picEdit()
{
	var RowID=getElementValue("RowID");
	// add by zx 2019-06-11
	var ReadOnly=getElementValue("ReadOnly");
	//modified by czf 20190305
	var url='dhceq.plat.picturemenu.csp?&CurrentSourceType=52&CurrentSourceID='+RowID+'&EquipDR='+RowID+"&ReadOnly="+ReadOnly;
	showWindow(url,"ͼƬ����","","","icon-w-paper","modal","","","middle");     //modify by lmm 2020-06-04 UI
}

///Creator: zx
///CreatDate: 2018-08-29
///Description ����ļ��༭������
function docEdit()
{
	var RowID=getElementValue("RowID");
	var ReadOnly=getElementValue("ReadOnly");
	var EQParentDR=getElementValue("EQParentDR");
	var url='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQDoc&EquipDR='+RowID+"&ConfigFlag="+EQParentDR+"&ReadOnly="+ReadOnly;	//Mozy	914928	2019-7-11	���Ӳ���ConfigFlag
	showWindow(url,"����ļ�","","","icon-w-paper","modal","","","large");    //modify by lmm 2020-06-04 UI
}

///Modify: Mozy		770799
///CreatDate: 2018-12-18
///Description ���޺�ͬ�༭����
function contractEdit()
{
	var RowID=getElementValue("RowID");
	var ReadOnly=getElementValue("ReadOnly");
	var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQContractMaintEquipList&ContractType=1&QXType=1&EquipDR="+RowID+"&ReadOnly="+ReadOnly; //add by zx 2019-06-11
	showWindow(url,"���޺�ͬ","","","icon-w-paper","modal","","","large");  //modify by lmm 2019-02-16
}

///Modify: Mozy
///ModifyDate: 2019-5-30
///Description �豸���ñ༭������
function configEdit()
{
	var RowID=getElementValue("RowID");
	var str='dhceq.process.config.csp?&OpenFlag=N&SourceType=2&SourceID='+RowID+"&ReadOnly="+getElementValue("ReadOnly");	//Mozy0249		1195363	2020-2-27
	showWindow(str,"�豸����","","","icon-w-paper","modal","","","large");
}

///Creator: Mozy
///CreatDate: 2018-11-25
///Description �����豸������
function equipconfigEdit()
{
	var RowID=getElementValue("RowID");
	//add by zx 2019-06-11
	var ReadOnly=getElementValue("ReadOnly");
	var url='dhceq.em.equipconfiginfo.csp?&EquipDR='+RowID+"&ReadOnly="+ReadOnly; 	//Mozy	1012394	2019-8-28
	showWindow(url,"�����豸","","","icon-w-paper","modal","","","large");	//modify by lmm 2020-06-04 UI
}

///Description �豸���༭������
function treeEdit()
{
	var RowID=getElementValue("RowID");
	//add by zx 2019-06-11
	var ReadOnly=getElementValue("ReadOnly");
	var url='dhceqassociated.csp?ParEquipDR='+RowID+"&ReadOnly="+ReadOnly; 
	showWindow(url,"�豸��","","","icon-w-paper","modal","","","large");	// MZY0094	2117902		2021-09-13
}

//Modify by zx 2020-02-19 BUG ZX0076
///Description �ļ�����
function appendFileEdit()
{
	var RowID=getElementValue("RowID");
	var ReadOnly=getElementValue("ReadOnly");
	//Modefined by zc0060 20200327   �ļ��ϴ�����  begin
	//var url='dhceq.process.appendfile.csp?&CurrentSourceType=52&CurrentSourceID='+RowID+'&Status=&ReadOnly='+ReadOnly	//add by csj 2020-03-23 ����ţ�1227406
	var url='dhceq.plat.appendfile.csp?&CurrentSourceType=52&CurrentSourceID='+RowID+'&Status=&ReadOnly='+ReadOnly
	//Modefined by zc0060 20200327   �ļ��ϴ�����  end
	showWindow(url,"��������","","","icon-w-paper","modal","","","large");   //modify by lmm 2020-06-04 UI
}

///Creator: zx
///CreatDate: 2018-08-29
///Description ͼƬ����
function initImage()
{
	var RowID=getElementValue("RowID");
	$.m({
			ClassName:"web.DHCEQ.Plat.LIBPicture",
			MethodName:"GetPictureByEquip",
			RowID:RowID
		},function(data){
		if(data!="")
		{
			var imageUrl="web.DHCEQ.Lib.DHCEQStreamServer.cls?PICLISTROWID="+data;
			$("#Image").attr("src",imageUrl);
			$("#Image").css("display","block");
			$("#DefaultImage").css("display","none");
		}
	});
}
///modify by wl 2019-12-16 WL0029
/// Excel��ӡPrintFlag==0,��Ǭ��ӡPrintFlag==1
function printCard()
{
	var RowID=getElementValue("RowID");	
	//Modefined by zc0060 20200326  ��Ƭ��ӡ��������
	//var PreviewRptFlag = GetElementValue("PreviewRptFlag"); //��ǬԤ����־ ��Ԥ�� :0  Ԥ�� :1
    var PrintFlag=getElementValue("PrintFlag");
    if ((RowID=="")||(RowID<1))	return;
    
    var HasAffix=getElementValue("HasAffixFlag");
    if(PrintFlag==0)
	{
	    PrintEQCard(RowID); //add by zx 2018-12-18 ��ӡ����
	}
	if(PrintFlag==1)
	{
		PrintEQCard(RowID,2);	//czf 2022-01-24 ��Ǭ������ӡ��Ƭ������ΪLodop��ӡ
		if (HasAffix==1)
        {
       		messageShow("confirm","info","��ʾ","�Ƿ��ӡ���棿","",printCardVerso,"");
        }
		/*
        var d=new Date()
        var day=d.getDate()
        var month=d.getMonth() + 1
        var year=d.getFullYear()
        var CurrentDate = year + "-" + month + "-" + day
        var PreviewRptFlag=getElementValue("PreviewRptFlag"); //add by wl 2019-11-11 WL0010 begin   ������ǬԤ����־
        var fileName=""	;
        if(PreviewRptFlag==0)
        { 
	        fileName="{DHCEQCardPrint.raq(RowId="+RowID+")}";
	        DHCCPM_RQDirectPrint(fileName);
	        if (HasAffix==1)		//czf 20210322
	        {
		        fileName="{DHCEQCardVersoPrint.raq(RowID="+RowID+")}"; 
			DHCCPM_RQDirectPrint(fileName);	
	        }
        }
        if(PreviewRptFlag==1)
        { 
	        fileName="DHCEQCardPrint.raq&RowId="+RowID ;
	        DHCCPM_RQPrint(fileName);
	        if (HasAffix==1)
	        {
	       		messageShow("confirm","info","��ʾ","�Ƿ��ӡ����,�����,�������ʧ","",printCardVerso,"");
	        }
        }	
        */											//add by wl 2019-11-11 WL0010 end	 	
    }
}

/// ����ϵͳ����������Ǭ��ӡ
/// modified by sjh 2019-12-10 BUG00020
///modify by wl 2019-12-23 WL0033 ɾ���޸Ĳ���Ҫ��ֵ��ȡ
function printCardVerso()
{
	var RowID=getElementValue("RowID");
	var PrintFlag = getElementValue("PrintFlag");	 //��ӡ��ʽ��־λ excel��0  ��Ǭ:1   
	if ((RowID=="")||(RowID<1))	return;
	var PreviewRptFlag = getElementValue("PreviewRptFlag"); //��ǬԤ����־ ��Ԥ�� :0  Ԥ�� :1
	var HOSPDESC = getElementValue("GetHospitalDesc");
	var filename = ""
	//Excel��ӡ��ʽ
	if(PrintFlag==0)  
	{
		PrintEQCardVerso(RowID);  //add by zx 2018-12-18 ��ӡ����
	}
	//��Ǭ��ӡ
	if(PrintFlag==1)
	{
		printCardVersoLodop(RowID);	//czf ��Ϊlodop��ӡ
		/*
		if(PreviewRptFlag==0)
		{ 
		    fileName="{DHCEQCardVersoPrint.raq(RowID="+RowID
		    +";HOSPDESC="+HOSPDESC
		    +";USERNAME="+curUserName
		    +")}";	
	        DHCCPM_RQDirectPrint(fileName);		
		}
		
		if(PreviewRptFlag==1)
		{ 
			fileName="DHCEQCardVersoPrint.raq&RowID="+RowID
		    +"&HOSPDESC="+HOSPDESC
		    +"&USERNAME="+curUserName	   
			DHCCPM_RQPrint(fileName);	
		}
		*/
	}		
}
//add by mwz 2020-03-27  MWZ0030
//̨�ʶ������Ӳ�Ʒ������
function productPicture()
{
	//modified by zy 20220926   2826780
	var RowID=getElementValue("RowID");
	var result=tkMakeServerCall("web.DHCEQ.Plat.CTProduct","SaveProductDataBySource","1",RowID);
	var list=result.split("^");
	if (list[0]==0)
	{
		var PMProductDR=list[1]
		if (PMProductDR=="") return;
		var url='dhceq.plat.proxyauthorization.csp?&PMProductDR='+PMProductDR+'&PMSourceType=1&PMSourceID='+RowID;
		//modified by ZY20230208 bug:3163825
		showWindow(url,"��Ʒ��Ȩ����Ϣ","","","icon-w-paper","modal","45","15","large");	// MZY0157	3220840		2023-03-29
		//showWindow(url,"��Ʒ��Ȩ��ά��","","","icon-w-paper","modal","","","large");
	}
	else
	{
		messageShow("","","","��Ʒ����Ϣ���ɴ���:"+list[0]+":"+list[1])
		return
	}
}
// add by zx 2019-07-05 
// ������Ϣ����
function equipBuilding()
{
    var RowID=getElementValue("RowID");
    var ReadOnly=getElementValue("ReadOnly");
    //Modified By QW20220406 BUG:QW0157 ���ݳ������� begin
    //modified by ZY 2913588,2913589,2913590
    //var EQName=getElementValue("EQName");
    //var url='dhceq.em.building.csp?&EquipDR='+RowID+"&ReadOnly="+ReadOnly+"&EQName="+EQName; 
    var url='dhceq.em.building.csp?&BDSourceType=1&BDSourceID='+RowID+"&ReadOnly="+ReadOnly; 
    //Modified By QW20220406 BUG:QW0157 ���ݳ������� end
    showWindow(url,"������Ϣ","3col","9row","icon-w-paper");        //modify by lmm 2020-06-01 UI   //czf 1730763 2021-01-22
}

// Add By QW202208016 begin �����:2760300 �����ʲ�������ʾ,��Ϊ���ؿ���ת ������Ϣ����
function equipLand()
{
    var RowID=getElementValue("RowID");
    var ReadOnly=getElementValue("ReadOnly");
    //modified by ZY 2913588,2913589,2913590
    //var EQName=getElementValue("EQName");
    //var url='dhceq.em.land.csp?&EquipDR='+RowID+"&ReadOnly="+ReadOnly+"&EQName="+EQName; 
    var url='dhceq.em.land.csp?&LSourceType=1&LSourceID='+RowID+"&ReadOnly="+ReadOnly; 
    showWindow(url,"������Ϣ","3col","9row","icon-w-paper"); 
}
///Creator: czf 2020-05-07 1300634
///Description ����ʦ���޵�����
function engineerMaintRequest()
{
	var RowID=getElementValue("RowID");
	//modified by ZY20230215  bug :  �޸�ά�޽����csp����
	var url="dhceq.em.maintrequest.csp?ExObjDR="+RowID+"&QXType=&WaitAD=off&Status=&RequestLocDR="+curLocID+"&StartDate=&EndDate=&InvalidFlag=N&vData=^Action=^SubFlag=&LocFlag="+curLocID+"&MaintType=1";
	//showWindow(url,"����ʦά������","","17row","icon-w-paper","modal","","","large");   //modify by lmm 2020-06-01
	showWindow(url,"����ʦά������","","","icon-w-paper","modal","","","large");   //modify by lmm 2020-06-01 UI
}

// add by lmm 2020-07-23
// ������Ϣ����
function equipVehicle()
{
    var RowID=getElementValue("RowID");
    var ReadOnly=getElementValue("ReadOnly");
    //Modified By QW20220406 BUG:QW0157 ���ݳ������� begin
    //modified by ZY 2913588,2913589,2913590
    //var EQName=getElementValue("EQName");
    //var url='dhceq.em.vehicle.csp?&EquipDR='+RowID+"&ReadOnly="+ReadOnly+"&EQName="+EQName; 
    var url='dhceq.em.vehicle.csp?&VSourceType=1&VSourceID='+RowID+"&ReadOnly="+ReadOnly; 
    //Modified By QW20220406 BUG:QW0157 ���ݳ������� end
    showWindow(url,"������Ϣ","4col","7row","icon-w-paper");        //modify by lmm 2020-06-01 UI
}

///add by ZY 20220913 2907381��2907386��2907390
// �����ʲ���Ϣ����
function equipIntangibleAssets()
{
    var RowID=getElementValue("RowID");
    var ReadOnly=getElementValue("ReadOnly");
    var url='dhceq.em.intangibleassets.csp?&IASourceType=1&IASourceID='+RowID+"&ReadOnly="+ReadOnly; 
    showWindow(url,"�����ʲ���Ϣ","4col","7row","icon-w-paper");
}
