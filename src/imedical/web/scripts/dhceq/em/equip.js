var curYear=""; //记录生命周期生成时年限节点
$(function(){
	initDocument();
});
//modified by sjh SJH0027 2020-06-12 修改台帐界面中“账”字为“帐”
function initDocument(){
	//综合查询时影藏编辑按钮
	//Modify by zx 2020-08-20 编辑按钮放开,控制可编辑内容 BUG ZX0102
	//if (getElementValue("ReadOnly")==1) {$('#EquipInfo').layout('panel', 'center').panel({ title: '信息总览' });}
	//隐藏头部按钮
	if(getElementValue("ToolBarFlag")!=1){$("#EquipShow").layout('remove','north');}
	//隐藏其他信息查看
	//add by zx 2019-06-11 图片、附件等不做影藏处理,通过ReadOnly控制
	/*if(getElementValue("DetailListFlag")!=1)
	{
		$("#EquipCard").layout('remove','center');
		$("#LifeInfoFind").hide();
	}
	else {initCardInfo();}*/
	initCardInfo();  //add by zx 2019-06-24  测试组需求 939539
	//隐藏生命周期
	if(getElementValue("LifeInfoFlag")!=1){$('#EquipInfo').layout('remove','east');}
	else {
		lifeInfoKeywords();
		initLifeInfo("");
	}
	initUserInfo();
	fillData();
	initImage();
	if (tkMakeServerCall("web.DHCEQCommon","GetSysInfo",990079)!=1) $("#ConfigCard").remove();	// Mozy003002	2020-03-18	屏蔽附属设备模块
};

///Creator: zx
///CreatDate: 2018-08-23
///Description: 生命周期筛选项关键字加载
function lifeInfoKeywords()
{
	$("#LifeInfoItemDetail").keywords({
	    items:[
	        {
	            text:"",
	            type:"chapter", //章
	            items:[
	                {
	                    text:'购置信息',
	                    type:"section", //节  modifed by wy 2019-3-29
	                    items:[
	                        {text:'申请',id:"91",selected:true},{text:'计划',id:"92",selected:true},{text:'招标',id:'93',selected:true},{text:'合同',id:'94',selected:true},{text:'验收',id:'11',selected:true} 	                    ]
	                },
	                {
	                    text:"库房变动",
	                    type:'section', //节
	                    items:[
	                        {text:'入库',id:"21",selected:true},{text:'转移',id:"22",selected:true}
	                    ]
	                },
	                {
	                    text:"维护信息",
	                    type:'section', //节
	                    items:[
	                        {text:'维修',id:"31",selected:true},{text:'计量和巡检',id:'33',selected:true},{text:'保养',id:'32',selected:true}  //add by zx 2019-03-28 测试组需求:852959
	                    ]
	                },
	                {
	                    text:"处置信息",
	                    type:'section', //节
	                    items:[
	                        {text:'报废',id:"34",selected:true},{text:'退货及减少',id:'23',selected:true}
	                    ]
	                },
	                {
	                    text:"其他信息",
	                    type:'section', //节
	                    items:[
	                        {text:'折旧',id:"35",selected:true},{text:'调帐',id:"51",selected:true},{text:'启用及停用',id:'41',selected:true},{text:'数据调整',id:"61",selected:true},{text:'鉴定报告',id:"82",selected:true},{text:'拆分',id:"55",selected:true}	//czf 2021-07-28 2014955
	                    ]
	                }
	            ]
	        }
	    ],
	});
}

///Creator: zx
///CreatDate: 2018-08-23
//按钮绑定事件
$("#LifeInfoSeach").click(function(){
	//add by zx 2019-03-28 测试组需求:852959
	curYear=""	
	initLifeInfo();
	$('#LifeInfoFind').webuiPopover('hide');  //弹框影藏
	});
///Creator: zx
///CreatDate: 2018-08-23
///Description: 生命周期加载样式控制
$('#LifeInfoFind').webuiPopover({width:330});  // modified by kdf 	需求号：865567 

///Creator: zx
///CreatDate: 2018-08-23
///Description: 获取台帐信息并加载
function fillData()
{
	var RowID=getElementValue("RowID");
	if (RowID=="") return;
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","GetOneEquip",RowID);
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow('alert','error','提示',jsonData.Data,'','','');return;}
	//jsonData.Data=GetJSONDataBySys(jsonData.Data);  //Add by JYP 2019-08-26
	setElementByJson(jsonData.Data); // hisui通用方法只能给input元素赋值,此方法被重写
	showFieldsTip(jsonData.Data); // 详细字段提示工具ToolTip
	showFundsTip(jsonData.Data);  // 资金来源信息tooltip
	//add by csj 20190215 设备状态不是在库的不允许退货
	if(getElementValue("EQStatus")!=0){
		disableElement("returnBtn",true)
	}
	$("#Banner").attr("src",'dhceq.plat.banner.csp?&EquipDR='+RowID); //add by zx 2019-02-15 防止banner多次数据加载
	//add by csj 2020-03-30 不属于计量设备禁用计量按钮
	var Data=tkMakeServerCall("web.DHCEQ.EM.BUSEquipAttribute","CheckEquipHaveAttributeGroup","01",3, RowID);
	if(Data!="Y"){
		disableElement("BMeterage",true)
	}
    //modified by ZY 2913588,2913589,2913590
    
    var ExclusiveType=tkMakeServerCall("web.DHCEQ.EM.BUSOpenCheckRequest","GetExclusiveType",1,RowID)
    if (ExclusiveType=="DHCEQLand") //土地信息
    {
        var desc=$("#EQEquipTypeDR_ETDesc").html()
        $("#EQEquipTypeDR_ETDesc").html('<a href="#" style="margin:0;font-weight:800;" onclick="javascript:equipLand()">'+desc+'</a>')
    }
    else if (ExclusiveType=="DHCEQBuilding")    //房屋信息
    {
        var desc=$("#EQEquipTypeDR_ETDesc").html()
        $("#EQEquipTypeDR_ETDesc").html('<a href="#" style="margin:0;font-weight:800;" onclick="javascript:equipBuilding()">'+desc+'</a>')
    }
    else if (ExclusiveType=="DHCEQIntangibleAssets")    //无形资产信息
    {
        var desc=$("#EQEquipTypeDR_ETDesc").html()
        $("#EQEquipTypeDR_ETDesc").html('<a href="#" style="margin:0;font-weight:800;" onclick="javascript:equipIntangibleAssets()">'+desc+'</a>')
    }
    else if (ExclusiveType=="DHCEQVehicle") //车辆信息
    {
        var desc=$("#EQStatCatDR_SCDesc").html()
        $("#EQStatCatDR_SCDesc").html('<a href="#" style="margin:0;font-weight:800;" onclick="javascript:equipVehicle()">'+desc+'</a>')
    }
    
    $HUI.switchbox('#IdleFlagSwitch',{
       onText:'闲置',
       offText:'非闲置',
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
///Description: 元素赋值
///Input: vJsonInfo 后台获取的json数据
///Other: 平台统一方法此处不适用
function setElementByJson(vJsonInfo)
{
	for (var key in vJsonInfo)
	{
		var str=getShortString(vJsonInfo[key]);
		//add by zx 2019-06-17
		if (key=="EQAdvanceDisFlag") str=(vJsonInfo["EQHold1"]=="")?getShortString(vJsonInfo["EQAdvanceDisFlagDesc"]):getShortString(vJsonInfo["EQAdvanceDisFlagDesc"]+"("+vJsonInfo["EQHold1"]+")");  //add by zx 2019-07-05 去掉括号
		$("#"+key).text(str);
		if((key=="EQComputerFlag")||(key=="EQCommonageFlag")||(key=="EQRaditionFlag"))
		{
			if (vJsonInfo[key]=="1") $("#"+key).text("是");
			else $("#"+key).text("否");
		}
		if((key=="EQGuaranteePeriodNum")&&(vJsonInfo["EQGuaranteePeriodNum"]!="")) $("#"+key).text(vJsonInfo[key]+"月");
		if(vJsonInfo["EQAddDepreMonths"]!="")
		{
			var AddDepreMonths=parseInt(vJsonInfo["EQAddDepreMonths"]);
			if(AddDepreMonths>0) $("#EQLimitYearsNum").text(vJsonInfo["EQLimitYearsNum"]+" (增"+AddDepreMonths+"月)");
			else $("#EQLimitYearsNum").text(vJsonInfo["EQLimitYearsNum"]+" (减"+AddDepreMonths+"月)");
		}
        //modified by ZY 2913588,2913589,2913590
        /*
		if (vJsonInfo["EQEquipTypeDR"]==getElementValue("BuildingType"))
		{
			$("#EQEquipTypeDR_ETDesc").html('<a href="#" style="margin:0;font-weight:800;" onclick="javascript:equipBuilding()">'+vJsonInfo["EQEquipTypeDR_ETDesc"]+'</a>')
		}
		else if (vJsonInfo["EQStatCatDR"]==getElementValue("VehicleType")) //Modified By QW20220406 BUG:QW0157 房屋车辆改造
		{
			$("#EQStatCatDR_SCDesc").html('<a href="#" style="margin:0;font-weight:800;" onclick="javascript:equipVehicle()">'+vJsonInfo["EQStatCatDR_SCDesc"]+'</a>')
		}
		else
		{
			$("#EQEquipTypeDR_ETDesc").text(vJsonInfo["EQEquipTypeDR_ETDesc"])
		}
		if(key=="EQEquiCatDR_ECDesc") //Add By QW202208016 begin 需求号:2760300 增加资产分类显示,若为土地可跳转
		{
			var ECCode=vJsonInfo["EQEquiCatDR_ECCode"]
			if((ECCode.substring(0,3)=="101")||(ECCode=="7040101"))    ///土地
			{
				$("#EQEquiCatDR_ECDesc").html('<a href="#" style="margin:0;font-weight:800;" onclick="javascript:equipLand()">'+vJsonInfo["EQEquiCatDR_ECDesc"]+'</a>')
			}
        }*/
		//alertShow(vJsonInfo["EQHold1"])
		//if(vJsonInfo["EQHold1"]!="") $("#EQAdvanceDisFlagDesc").text(vJsonInfo["EQAdvanceDisFlagDesc"]+" （"+vJsonInfo["EQHold1"]+"）");
	}
	setElement("EQStatus",vJsonInfo.EQStatus)
	setElement("EQStatusDisplay",vJsonInfo.EQStatusDisplay)
	setElement("EQParentDR",vJsonInfo.EQParentDR);		//Mozy	914928	2019-7-11
	setElement("EQName",vJsonInfo.EQName); //Add By QW20220406 BUG:QW0157 房屋车辆改造
    //modified by ZY 20221111 2993799
    setElement("EQIdleFlag",vJsonInfo.EQIdleFlag);
}

///Creator: zx
///CreatDate: 2018-08-23
///Description: 根据字符长度截取过长信息并拼接"..."
///Input: string 需要截取的字符串
function getShortString(string)
{
	string=string.toString(); //部分int需要转为string
	var result = ""; //返回结果
	var j = 0;  //字节数作为控制参数
	for(var i = 0;i < string.length; i++){
		if(string.charCodeAt(i) > 255) //如果是汉字，则字符串长度加2
		{
			j+=2;
		}
		else  //数字或字母长度加1
		{
			j++;
		}
		if (j>12) return result+"..."; //设置最大可显示字节数为12,遍历超过这个值直接退出并返回结果
		result=result+string[i];
	}
	return result;
}

///Creator: zx
///CreatDate: 2018-08-24
///Description: 生命周期数据信息获取
function initLifeInfo()
{
	//add by zx 2019-03-28 测试组需求:852959
	var keyObj=$HUI.keywords("#LifeInfoItemDetail").getSelected();
	var sourceTypeDRs="";
	for (i=0;i<keyObj.length;i++)
	{
		//关键字列表获取id串
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
///Description: 生命周期数据解析加载
///Input: 生命周期数据集
function createLifeInfo(jsonData)
{
	$("#LifeInfoView").empty(); //每次加载之前移除样式
	//按时间倒序,从最大值遍历
	for (var i=jsonData.rows.length-1;i>=0;i--)
	{
		var changeDate=jsonData.rows[i].TChangeDate; //变动日期
		var changeTime=jsonData.rows[i].TChangeTime; //变动时间  //Modife by zc 2020-09-18 ZC0083 添加时间
		var appendType=jsonData.rows[i].TAppendType;	//变动类型
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
			item:'^^'+changeDate+" "+changeTime+'%^'+url+'^'+appendType+':'+usedFee+'%^^'+keyInfo,   //Modife by zc 2020-09-18 ZC0083 添加时间
			lastFlag:flag
		}
		
		createTimeLine(opt);
	}
}

///Creator: zx
///CreatDate: 2018-08-24
///Description: 生命周期超链接点击
///Input: sourceTypeDR 业务代码  sourceID 业务id
function lifeInfoDetail(sourceType,sourceID)
{
	if (sourceType=="35")
	{
		messageShow('alert','info','提示','折旧无业务数据！','','','')
		return;
	}
	var url="dhceqlifeinfo.csp?&SourceType="+sourceType+"&SourceID="+sourceID;
	//modify by lmm 2019-02-16 begin
	//modify by lmm 2020-06-02
	if (sourceType=="31")
	{
		showWindow(url,"业务详情","","","icon-w-paper","modal","","","large");  
	}
	else if(sourceType=="11")
	{
		showWindow(url,"业务详情","","","icon-w-paper","modal","","","large");  
	}
	else if((sourceType=="32")||(sourceType=="33"))
	{
		//Modefied by zc0109 2021-12-02  修改弹框大小 begin
		showWindow(url,"业务详情","","","icon-w-paper","modal","","","large");  
	}
	else
	{
		showWindow(url,"业务详情","","","icon-w-paper","modal","","","large"); 
	}
	//modify by lmm 2019-02-16 end
	
}

///Creator: zx
///CreatDate: 2018-08-23
///Description: 页面相关信息左滑动按钮
$('#moveLeft').click(function(){
	moveView(1);
});

///Creator: zx
///CreatDate: 2018-08-23
///Description: 页面相关信息右滑动按钮
$('#moveRight').click(function(){
	moveView(2);
});

///Creator: zx
///CreatDate: 2018-08-23
///Description: 滑动控制,控制内部div显示影藏,滑动到底后禁止点击
///Input: type 滑动方向 1左 2右
function moveView(type)
{
	var arry=new Array();
	var arryView= new Array();
	var viewLen=0; //滑动内容模块数量
	var stopFlag=0; //是否停止此方向滑动
	$(".eq-card").each(function(index){
		viewLen=viewLen+1;
	 	if($(this).hasClass("eq-card-active")){arry.push(index)}; //当前可见内容模块放置数组arry中
	});
	if (type==1)
	{
		if (arry[0]-1<0) return;
		for(j=0,len=arry.length;j<len;j++) {
			arryView.push(arry[j]-1);  //左移时内容模块位置减一
			if (arry[j]-1==0) stopFlag=1; //存在最左内容模块在数组中时需要设置停止标志
		}
	}
	else
	{
		var len=arry.length;
		if (arry[len-1]+1>=viewLen) return;
		for(j=0;j<len;j++) {
			arryView.push(arry[j]+1); //右移时内容模块位置加一
			if (arry[j]+2>=viewLen) stopFlag=1; //存在最右内容模块在数组中时需要设置停止标志
		}
	}
	if(stopFlag==1)
	{
		//停止标志时相关按钮样式改变
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
		// 不存在停止时样式按钮恢复
		$("#moveLeft").addClass("eq-card-move");
		$("#moveLeft").removeClass("eq-card-stop");
		$("#moveRight").addClass("eq-card-move");
		$("#moveRight").removeClass("eq-card-stop");
	}
	//在可显示数组中时显示内容模块,其余做隐藏处理
	$(".eq-card").each(function(index){
		if (arryView.indexOf(index)==-1)
		{$(this).removeClass("eq-card-active");}
		else{$(this).addClass("eq-card-active");}
	});
}

///Creator: zx
///CreatDate: 2018-08-23
///Description filldata详细字段提示工具ToolTip
///Input: data 后台请求台帐数据
function showFieldsTip(data)
{
	$(".eq-table-info").each(function(index){
		var id=$(this).attr("id");
		if (!id) return;  //占位元素不处理
		if ((id=="EQComputerFlag")||(id=="EQCommonageFlag")||(id=="EQRaditionFlag")) var stringDate=$("#"+id).text();
		//add by zx 2019-06-17
		else if (id=="EQAdvanceDisFlag") var stringDate=(data["EQHold1"]=="")?data["EQAdvanceDisFlagDesc"]:data["EQAdvanceDisFlagDesc"]+"("+data["EQHold1"]+")";  //add by zx 2019-07-05 拼接bug修复
		else if (id=="EQLimitYearsNum") 
		{
			if (data["EQAddDepreMonths"]>0) var stringDate=data[id]+" (增"+data["EQAddDepreMonths"]+"月)";
			else if (data["EQAddDepreMonths"]<0) var stringDate=data[id]+" (减"+data["EQAddDepreMonths"]+"月)";
			else var stringDate=data[id];
		}
		else var stringDate=data[id];
		if (stringDate=="") return; //值为空元素不处理
		$HUI.tooltip('#'+id,{
			position: 'bottom',
			content: function(){
					return stringDate; //显示值从返回数据中获取
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
///Description 资金来源详细信息ToolTip
///Input: data 后台请求台帐数据
function showFundsTip(data)
{
	var RowID=$("#RowID").val();
	//异步处理
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
				content=content+'<li>'+TFundsType+'：'+TFee+' '+'累计折旧:'+TCurDepreTotalFee+' '+'核算项目:'+TFinaceItem+'</li>'; //Modified BY QW20200320 BUG:QW0054
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
///Description 台帐信息编辑弹框
function equipEdit()
{
	//Modify by zx 2020-08-20 BUG ZX0102
	var RowID=$("#RowID").val();
	var ReadOnly=getElementValue("ReadOnly");
	var url="dhceq.em.equipedit.csp?RowID="+RowID+"&ReadOnly="+ReadOnly;
	showWindow(url,"资产信息编辑","","15row","icon-w-paper","modal","","","large");  //modify by lmm 2020-06-01 UI
}

///Creator: zx
///CreatDate: 2018-09-20
///Description 台帐底部信息显示
function initCardInfo()
{
	$cm({
		ClassName:"web.DHCEQ.EM.BUSEquip",
		MethodName:"EquipRelatedInfo",
		Type:"",
		EquipDR:getElementValue("RowID"),
		CheckListDR:""
	},function(jsonData){
		if (jsonData.SQLCODE<0) {messageShow('alert','error','提示',jsonData.Data,'','','');return;}
    	//jsonData.Data=GetJSONDataBySys(jsonData.Data);  //Add by JYP 2019-08-26
		$("#AffixNum").text("("+jsonData.Data["AffixNum"]+")");
		$("#PicNum").text("("+jsonData.Data["PicNum"]+")");
		//Modify by zx 2021-05-20 显示随机文件数量
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
		//Modify by zc0076 2020-6-17 恢复屏蔽的随机文件 begin
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
		//Modify by zc0076 2020-6-17 恢复屏蔽的随机文件 begin
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
// Mozy003005	1249755		2020-4-1	修正保修合同链接
function contractDetail(linkID)
{
	var val="&RowID="+linkID+"&ReadOnly=1&QXType=1&ContractType=1";
	var url="dhceq.con.contractformaint.csp?"+val;
	showWindow(url,"保修合同信息","","","icon-w-paper","modal","","","large");
}

///Creator: zx
///CreatDate: 2018-08-24
///Description 调帐弹出框
function changeAccount()
{
    var RowID=getElementValue("RowID");
    var ReadOnly=getElementValue("ReadOnly");
    ///modified by ZY 2857906 20220818
    //var url="dhceqchangeaccount.csp?RowID="+RowID+"&ReadOnly="+ReadOnly;
    var url="dhceq.em.changeaccount.csp?RowID="+RowID+"&ReadOnly="+ReadOnly;
    showWindow(url,"调帐信息","","","icon-w-paper","modal","30","15","verylarge",refreshWindow);  //MZY0157	3220814		2023-03-29
}

///Creator: zx
///CreatDate: 2018-09-13
///Description 设备启用弹出框
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
	showWindow(url,"资产启用","","","icon-w-paper","modal","","","large",reloadPage);  //modify by lmm 2020-06-01 UI
}
///Creator: zx
///CreatDate: 2018-09-13
///Description 设备停用弹出框
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
	showWindow(url,"资产停用","","","icon-w-paper","modal","","","large",reloadPage);  //modify by lmm 2020-06-01 UI
}

function reloadPage()
{
	var str="dhceq.em.equip.csp?&RowID="+getElementValue("RowID")+"&ReadOnly="+getElementValue("ReadOnly")+"&ToolBarFlag="+getElementValue("ToolBarFlag")+"&LifeInfoFlag="+getElementValue("LifeInfoFlag")+"&DetailListFlag="+getElementValue("DetailListFlag");
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		str += "&MWToken="+websys_getMWToken()
	}
	window.location.href=str
}


///Creator: jyp
///CreatDate: 2019-02-16
///Description 设备属性弹出框
function equipAttribute()
{
	var RowID=getElementValue("RowID");
	var ReadOnly=getElementValue("ReadOnly");
	var Status=getElementValue("EQStatus");
	var url='dhceq.em.equipattributelist.csp?SourceID='+RowID+"&SourceType=3"+"&ReadOnly="+ReadOnly;
	showWindow(url,"设备属性","","","icon-w-paper","modal","220","65","middle");  //MZY0157	3220824		2023-03-29
}
///Creator: zx
///CreatDate: 2018-09-13
///Description 设备报修弹出框
function maintRequest()
{
	//modified by csj 20190125 
	var RowID=getElementValue("RowID");
	var url="dhceq.em.mmaintrequestsimple.csp?ExObjDR="+RowID+"&QXType=&WaitAD=off&Status=0&RequestLocDR="+curLocID+"&StartDate=&EndDate=&InvalidFlag=N&vData=^Action=^SubFlag=&LocFlag="+curLocID;
	showWindow(url,"维修申请","694px","727px","icon-w-paper","modal","373","51","middle");  //MZY0157	3220827		2023-03-29
}

///Creator: zx
///CreatDate: 2018-09-13
///Description 设备计量记录弹出框
function meterage()
{
	var RowID=getElementValue("RowID");
	var url="dhceq.em.meterage.csp?BussType=2&EquipDR="+RowID+"&RowID="+"&MaintTypeDR=5";
	showWindow(url,"计量记录","","437px","icon-w-paper","modal","","","large");		// MZY0151	2023-02-01
}

///Creator: zx
///CreatDate: 2018-09-13
///Description 设备巡检记录弹出框
function inspect()
{
	var RowID=getElementValue("RowID");
	var url="dhceq.em.inspect.csp?BussType=2&EquipDR="+RowID+"&RowID="+"&MaintTypeDR=4";	//modified by csj 20191202 添加巡检维护类型参数
	showWindow(url,"检查记录","","","icon-w-paper","modal","","","large");		// MZY0154	3249067		2023-03-03
}

function returnRequest()
{
	//modified by csj 20190125 
	var RowID=getElementValue("RowID");
	//modified by ZY0229 20200511
	url="dhceq.em.return.csp?EquipDR="+RowID+"&ROutTypeDR=1&WaitAD=off&QXType=2"; 
	showWindow(url,"资产退货","","","icon-w-paper","modal","","","large");   //modify by lmm 2019-02-16
}

///Creator: zx
///CreatDate: 2018-09-13
///Description 设备报废弹出框
function disuseRequest()
{
	var RowID=getElementValue("RowID");
	var ReadOnly=getElementValue("ReadOnly");
	var url='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQBatchDisuseRequest&DType=1&Type=0&EquipDR='+RowID+"&RequestLocDR="+curLocID+"&ReadOnly="+ReadOnly; //session值需要替换
	showWindow(url,"资产报废","","","icon-w-paper","modal","","","large");   //modify by lmm 2020-06-02 UI
	
}

///Creator: zx
///CreatDate: 2018-08-29
///Description 附件编辑弹出框
function affixEdit()
{
	var RowID=getElementValue("RowID");
	var ReadOnly=getElementValue("ReadOnly");
	var EQParentDR=getElementValue("EQParentDR");
	var url='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAffix&EquipDR='+RowID+"&ConfigFlag="+EQParentDR+"&ReadOnly="+ReadOnly;	//Mozy	914928	2019-7-11	增加参数ConfigFlag
	showWindow(url,"设备附件","","","icon-w-paper","modal","","","large");    //modify by lmm 2020-06-04 UI
}

///Creator: zx
///CreatDate: 2018-08-29
///Description 图片资料编辑弹出框
function picEdit()
{
	var RowID=getElementValue("RowID");
	// add by zx 2019-06-11
	var ReadOnly=getElementValue("ReadOnly");
	//modified by czf 20190305
	var url='dhceq.plat.picturemenu.csp?&CurrentSourceType=52&CurrentSourceID='+RowID+'&EquipDR='+RowID+"&ReadOnly="+ReadOnly;
	showWindow(url,"图片资料","","","icon-w-paper","modal","","","middle");     //modify by lmm 2020-06-04 UI
}

///Creator: zx
///CreatDate: 2018-08-29
///Description 相关文件编辑弹出框
function docEdit()
{
	var RowID=getElementValue("RowID");
	var ReadOnly=getElementValue("ReadOnly");
	var EQParentDR=getElementValue("EQParentDR");
	var url='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQDoc&EquipDR='+RowID+"&ConfigFlag="+EQParentDR+"&ReadOnly="+ReadOnly;	//Mozy	914928	2019-7-11	增加参数ConfigFlag
	showWindow(url,"相关文件","","","icon-w-paper","modal","","","large");    //modify by lmm 2020-06-04 UI
}

///Modify: Mozy		770799
///CreatDate: 2018-12-18
///Description 保修合同编辑弹框
function contractEdit()
{
	var RowID=getElementValue("RowID");
	var ReadOnly=getElementValue("ReadOnly");
	var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQContractMaintEquipList&ContractType=1&QXType=1&EquipDR="+RowID+"&ReadOnly="+ReadOnly; //add by zx 2019-06-11
	showWindow(url,"保修合同","","","icon-w-paper","modal","","","large");  //modify by lmm 2019-02-16
}

///Modify: Mozy
///ModifyDate: 2019-5-30
///Description 设备配置编辑弹出框
function configEdit()
{
	var RowID=getElementValue("RowID");
	var str='dhceq.process.config.csp?&OpenFlag=N&SourceType=2&SourceID='+RowID+"&ReadOnly="+getElementValue("ReadOnly");	//Mozy0249		1195363	2020-2-27
	showWindow(str,"设备配置","","","icon-w-paper","modal","","","large");
}

///Creator: Mozy
///CreatDate: 2018-11-25
///Description 附属设备弹出框
function equipconfigEdit()
{
	var RowID=getElementValue("RowID");
	//add by zx 2019-06-11
	var ReadOnly=getElementValue("ReadOnly");
	var url='dhceq.em.equipconfiginfo.csp?&EquipDR='+RowID+"&ReadOnly="+ReadOnly; 	//Mozy	1012394	2019-8-28
	showWindow(url,"附属设备","","","icon-w-paper","modal","","","large");	//modify by lmm 2020-06-04 UI
}

///Description 设备树编辑弹出框
function treeEdit()
{
	var RowID=getElementValue("RowID");
	//add by zx 2019-06-11
	var ReadOnly=getElementValue("ReadOnly");
	var url='dhceqassociated.csp?ParEquipDR='+RowID+"&ReadOnly="+ReadOnly; 
	showWindow(url,"设备树","","","icon-w-paper","modal","","","large");	// MZY0094	2117902		2021-09-13
}

//Modify by zx 2020-02-19 BUG ZX0076
///Description 文件资料
function appendFileEdit()
{
	var RowID=getElementValue("RowID");
	var ReadOnly=getElementValue("ReadOnly");
	//Modefined by zc0060 20200327   文件上传改造  begin
	//var url='dhceq.process.appendfile.csp?&CurrentSourceType=52&CurrentSourceID='+RowID+'&Status=&ReadOnly='+ReadOnly	//add by csj 2020-03-23 需求号：1227406
	var url='dhceq.plat.appendfile.csp?&CurrentSourceType=52&CurrentSourceID='+RowID+'&Status=&ReadOnly='+ReadOnly
	//Modefined by zc0060 20200327   文件上传改造  end
	showWindow(url,"电子资料","","","icon-w-paper","modal","","","large");   //modify by lmm 2020-06-04 UI
}

///Creator: zx
///CreatDate: 2018-08-29
///Description 图片加载
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
/// Excel打印PrintFlag==0,润乾打印PrintFlag==1
function printCard()
{
	var RowID=getElementValue("RowID");	
	//Modefined by zc0060 20200326  卡片打印不起作用
	//var PreviewRptFlag = GetElementValue("PreviewRptFlag"); //润乾预览标志 不预览 :0  预览 :1
    var PrintFlag=getElementValue("PrintFlag");
    if ((RowID=="")||(RowID<1))	return;
    
    var HasAffix=getElementValue("HasAffixFlag");
    if(PrintFlag==0)
	{
	    PrintEQCard(RowID); //add by zx 2018-12-18 打印调用
	}
	if(PrintFlag==1)
	{
		PrintEQCard(RowID,2);	//czf 2022-01-24 润乾连续打印卡片报错，改为Lodop打印
		if (HasAffix==1)
        {
       		messageShow("confirm","info","提示","是否打印反面？","",printCardVerso,"");
        }
		/*
        var d=new Date()
        var day=d.getDate()
        var month=d.getMonth() + 1
        var year=d.getFullYear()
        var CurrentDate = year + "-" + month + "-" + day
        var PreviewRptFlag=getElementValue("PreviewRptFlag"); //add by wl 2019-11-11 WL0010 begin   增加润乾预览标志
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
	       		messageShow("confirm","info","提示","是否打印反面,点击是,正面会消失","",printCardVerso,"");
	        }
        }	
        */											//add by wl 2019-11-11 WL0010 end	 	
    }
}

/// 增加系统参数控制润乾打印
/// modified by sjh 2019-12-10 BUG00020
///modify by wl 2019-12-23 WL0033 删除修改不必要的值获取
function printCardVerso()
{
	var RowID=getElementValue("RowID");
	var PrintFlag = getElementValue("PrintFlag");	 //打印方式标志位 excel：0  润乾:1   
	if ((RowID=="")||(RowID<1))	return;
	var PreviewRptFlag = getElementValue("PreviewRptFlag"); //润乾预览标志 不预览 :0  预览 :1
	var HOSPDESC = getElementValue("GetHospitalDesc");
	var filename = ""
	//Excel打印方式
	if(PrintFlag==0)  
	{
		PrintEQCardVerso(RowID);  //add by zx 2018-12-18 打印调用
	}
	//润乾打印
	if(PrintFlag==1)
	{
		printCardVersoLodop(RowID);	//czf 改为lodop打印
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
//台帐顶部增加产品库链接
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
		showWindow(url,"产品授权书信息","","","icon-w-paper","modal","45","15","large");	// MZY0157	3220840		2023-03-29
		//showWindow(url,"产品授权书维护","","","icon-w-paper","modal","","","large");
	}
	else
	{
		messageShow("","","","产品库信息生成错误:"+list[0]+":"+list[1])
		return
	}
}
// add by zx 2019-07-05 
// 房屋信息弹框
function equipBuilding()
{
    var RowID=getElementValue("RowID");
    var ReadOnly=getElementValue("ReadOnly");
    //Modified By QW20220406 BUG:QW0157 房屋车辆改造 begin
    //modified by ZY 2913588,2913589,2913590
    //var EQName=getElementValue("EQName");
    //var url='dhceq.em.building.csp?&EquipDR='+RowID+"&ReadOnly="+ReadOnly+"&EQName="+EQName; 
    var url='dhceq.em.building.csp?&BDSourceType=1&BDSourceID='+RowID+"&ReadOnly="+ReadOnly; 
    //Modified By QW20220406 BUG:QW0157 房屋车辆改造 end
    showWindow(url,"房屋信息","3col","9row","icon-w-paper");        //modify by lmm 2020-06-01 UI   //czf 1730763 2021-01-22
}

// Add By QW202208016 begin 需求号:2760300 增加资产分类显示,若为土地可跳转 土地信息弹框
function equipLand()
{
    var RowID=getElementValue("RowID");
    var ReadOnly=getElementValue("ReadOnly");
    //modified by ZY 2913588,2913589,2913590
    //var EQName=getElementValue("EQName");
    //var url='dhceq.em.land.csp?&EquipDR='+RowID+"&ReadOnly="+ReadOnly+"&EQName="+EQName; 
    var url='dhceq.em.land.csp?&LSourceType=1&LSourceID='+RowID+"&ReadOnly="+ReadOnly; 
    showWindow(url,"土地信息","3col","9row","icon-w-paper"); 
}
///Creator: czf 2020-05-07 1300634
///Description 工程师报修弹出框
function engineerMaintRequest()
{
	var RowID=getElementValue("RowID");
	//modified by ZY20230215  bug :  修改维修界面的csp链接
	var url="dhceq.em.maintrequest.csp?ExObjDR="+RowID+"&QXType=&WaitAD=off&Status=&RequestLocDR="+curLocID+"&StartDate=&EndDate=&InvalidFlag=N&vData=^Action=^SubFlag=&LocFlag="+curLocID+"&MaintType=1";
	//showWindow(url,"工程师维修申请","","17row","icon-w-paper","modal","","","large");   //modify by lmm 2020-06-01
	showWindow(url,"工程师维修申请","","","icon-w-paper","modal","","","large");   //modify by lmm 2020-06-01 UI
}

// add by lmm 2020-07-23
// 车辆信息弹框
function equipVehicle()
{
    var RowID=getElementValue("RowID");
    var ReadOnly=getElementValue("ReadOnly");
    //Modified By QW20220406 BUG:QW0157 房屋车辆改造 begin
    //modified by ZY 2913588,2913589,2913590
    //var EQName=getElementValue("EQName");
    //var url='dhceq.em.vehicle.csp?&EquipDR='+RowID+"&ReadOnly="+ReadOnly+"&EQName="+EQName; 
    var url='dhceq.em.vehicle.csp?&VSourceType=1&VSourceID='+RowID+"&ReadOnly="+ReadOnly; 
    //Modified By QW20220406 BUG:QW0157 房屋车辆改造 end
    showWindow(url,"车辆信息","4col","7row","icon-w-paper");        //modify by lmm 2020-06-01 UI
}

///add by ZY 20220913 2907381、2907386、2907390
// 无形资产信息弹框
function equipIntangibleAssets()
{
    var RowID=getElementValue("RowID");
    var ReadOnly=getElementValue("ReadOnly");
    var url='dhceq.em.intangibleassets.csp?&IASourceType=1&IASourceID='+RowID+"&ReadOnly="+ReadOnly; 
    showWindow(url,"无形资产信息","4col","7row","icon-w-paper");
}
