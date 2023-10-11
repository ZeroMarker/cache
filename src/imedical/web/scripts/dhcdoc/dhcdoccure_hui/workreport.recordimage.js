var PageLogicObj={
	m_Timer:"",
	ImageHtml:"",
	ImageData:"",
	ImageNumOnLine:8	//每行最多显示多少图片
};
$(function(){
	var HospIdTdWidth=$("#HospIdTd").width()
	var opt={width:HospIdTdWidth}
	var hospComp = GenUserHospComp(opt);
	hospComp.jdata.options.onSelect = function(e,t){
		var HospID=t.HOSPRowId;
		$("#patNo,#PatientID").val("");
		$(".ImageShowList").children().remove();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}	
	InitEvent();
	PageHandler();
});

function Init() {
	//初始化每行最多显示多少图片
	var WinWidth=document.body.clientWidth;
	PageLogicObj.ImageNumOnLine=parseInt((WinWidth-130)/150);
	InitArcimDesc();
}

function InitEvent() {
	$("#Find").click(FindClick);
	InitPatNoEvent(FindClick);
}

function PageHandler() {
}

function FindClick() {
	var StartDate=$("#StartDate").datebox("getValue");
	var EndDate=$("#EndDate").datebox("getValue");
	var PatientID=$("#PatientID").val();
	var gtext=$HUI.lookup("#ComboArcim").getText();
	if(gtext=="")PageSizeItemObj.m_SelectArcimID="";
	var ArcimID=PageSizeItemObj.m_SelectArcimID;
	var checkedRadioObj = $("input[name='SortType']:checked");
	var SortType=checkedRadioObj.val();
	if (PatientID=="") {
		$.messager.alert("提示","请输入登记号查询","warning");
		return false;
	}
	var txtMsg=$g("下载中...");
	$.messager.progress({
	    title:"提示",
	    msg:"请稍等,正在查询下载图片....",
	    text:txtMsg
    });
    clearTimeout(PageLogicObj.m_Timer);
	PageLogicObj.m_Timer=setTimeout(function(){
		$(".ImageShowList").html("");
		var UserHospID=Util_GetSelUserHospID();	
		//var recCount=cspRunServerMethod(ServerObj.GetCureRecondImage,StartDate,EndDate,PatientID,ArcimID,SortType,UserHospID);
		//var recCount=tkMakeServerCall("DHCDoc.DHCDocCure.WordReport","GetCureRecondImage",StartDate,EndDate,PatientID,ArcimID,SortType,UserHospID);
		var retStr=$.m({
			ClassName:"DHCDoc.DHCDocCure.WordReport",
			MethodName:"GetCureRecondImage",
			StartDate:StartDate,
			EndDate:EndDate,
			PatientID:PatientID,
			ArcimID:ArcimID,
			Sortable:SortType,
			HospID:UserHospID
		},false);
		var retObj=JSON.parse(retStr);
		if(retObj.length==0){
			$.messager.progress('close');	
		}else{
			for(var i = 0;i<retObj.length;i++){
				var dataObj=retObj[i];	
				var ImageNum=dataObj.ImageNum;
				if(ImageNum == 0){
					continue;	
				}
				var ShowHead=dataObj.InitShowHead.split("^");
				InitShowHead(ShowHead[0],ShowHead[1],ShowHead[2],ShowHead[3]); //展示左侧的治疗申请信息格子
				var ShowFoot=dataObj.InitShowFoot.split("^");
				var BodyList=dataObj.BodyList;
				for(var j=0;j<BodyList.length;j++){
					var bodyObj=BodyList[j];	
					var ShowBody=bodyObj.InitShowBody.split("^");
					InitShowBody(ShowBody[0],ShowBody[1],ShowBody[2],ShowBody[3]);
					var PicList=bodyObj.PicList;
					for(var k=0;k<PicList.length;k++){
						var PicData	= PicList[k].InitPicData
						InitPicData(PicData);
					}
					
					var PicData=bodyObj.InsertPicData.split("^");
					InsertPicData(PicData[0],PicData[1]);
				}
				InitShowFoot(ShowFoot[0],ShowFoot[1]);
			}
		}
	},50);
}
//展示左侧的治疗申请信息格子
function InitShowHead(ApplyDate, ArcimName, DCARowId,ApplyNo) {
	var ImageShow="ImageShow";
	var ShowTitle="ShowTitle";
	if(typeof HISUIStyleCode!="undefined" && HISUIStyleCode=="lite"){
		ImageShow=ImageShow+'-lite';
		ShowTitle=ShowTitle+'-lite';
	}
	
	PageLogicObj.ImageHtml = '<div class='+ImageShow+'>';
	PageLogicObj.ImageHtml = PageLogicObj.ImageHtml + '<div id="'+DCARowId+'" class='+ShowTitle+'>';
	PageLogicObj.ImageHtml = PageLogicObj.ImageHtml + '<div class="ShowTitle-Date">'+ApplyDate+'</div>';
	PageLogicObj.ImageHtml = PageLogicObj.ImageHtml + '<div class="ShowTitle-Order">'+ArcimName+'</div>';
	PageLogicObj.ImageHtml = PageLogicObj.ImageHtml + '<div class="ShowTitle-No">'+ApplyNo+'</div>';
	PageLogicObj.ImageHtml = PageLogicObj.ImageHtml + '</div>';
	PageLogicObj.ImageHtml = PageLogicObj.ImageHtml + '<div class="ShowInfo">';
	PageLogicObj.ImageHtml = PageLogicObj.ImageHtml + '<ul>';
}

//添加图片列表li节点
function InitShowBody(DCRPRowId, PicName, UserName, ImageDate) {
	var liInfo="li-Info";
	if(typeof HISUIStyleCode!="undefined" && HISUIStyleCode=="lite"){
		liInfo=liInfo+'-lite';
	}
	PageLogicObj.ImageHtml = PageLogicObj.ImageHtml + '<li>';
	PageLogicObj.ImageHtml = PageLogicObj.ImageHtml + '<div class='+liInfo+'>';
	PageLogicObj.ImageHtml = PageLogicObj.ImageHtml + '<div class="Image">';
	//PageLogicObj.ImageHtml = PageLogicObj.ImageHtml + '<img title="点击查看原图" id="'+DCRPRowId+'" src="'+ImgBase64+'" alt="'+PicName+'" width="150px" height="150px" onclick="showImage(this)">';
	PageLogicObj.ImageHtml = PageLogicObj.ImageHtml + "$<img>$";
	PageLogicObj.ImageHtml = PageLogicObj.ImageHtml + '</div>';
	PageLogicObj.ImageHtml = PageLogicObj.ImageHtml + '<div class="Image-Info">';
	PageLogicObj.ImageHtml = PageLogicObj.ImageHtml + '<div class="Image-Info-User">'+UserName+'</div>';
	PageLogicObj.ImageHtml = PageLogicObj.ImageHtml + '<div class="Image-Info-Time">'+ImageDate+'</div>';
	PageLogicObj.ImageHtml = PageLogicObj.ImageHtml + '</div>';
	PageLogicObj.ImageHtml = PageLogicObj.ImageHtml + '</div>';
	PageLogicObj.ImageHtml = PageLogicObj.ImageHtml + '</li>';							
}

//将后台拆分的base64数据重新拼接为一个完成的base64字符串
function InitPicData(ImageData) {
	PageLogicObj.ImageData=PageLogicObj.ImageData+""+ImageData;					
}

//往图片列表li节点填充图片base64数据
function InsertPicData(DCRPRowId,PicName) {
	var ImageHtmlData = '<img title="点击查看原图" id="'+DCRPRowId+'" src="'+PageLogicObj.ImageData+'" alt="'+PicName+'" width="150px" height="150px" onclick="showImage(this)">';
	PageLogicObj.ImageHtml=PageLogicObj.ImageHtml.replace("$<img>$",ImageHtmlData)
	PageLogicObj.ImageData="";			
}
//补充div ul 结束标签、将图片列表添加到主div展示
function InitShowFoot(DCARowId, ImageNum) {
	PageLogicObj.ImageHtml = PageLogicObj.ImageHtml + '</ul>';
	PageLogicObj.ImageHtml = PageLogicObj.ImageHtml + '</div>';
	PageLogicObj.ImageHtml = PageLogicObj.ImageHtml + '</div>';					
	
	$(".ImageShowList").append(PageLogicObj.ImageHtml);
	var HeightMul=Math.ceil(parseInt(ImageNum)/PageLogicObj.ImageNumOnLine);
	window.setTimeout(function(){
		HeightMul=HeightMul*220+5;
		$("#"+DCARowId).height(HeightMul+"px");
		$("#"+DCARowId).parent().height(HeightMul+"px");
		$.messager.progress('close');
	},500)
}

function showImage(ImageObj) {
    var widths = (window.screen.availWidth) * 9 / 10;
    var heights = (window.screen.availHeight) * 8 / 10;
    var iLeft = (window.screen.availWidth - widths) / 2;
    var iTop = 10; //(window.screen.availHeight - heights) / 2;
 

	const img = new Image();
	img.src = ImageObj.src;
	const newWin = window.open("", "_blank","height="+heights+",width="+widths+",top="+iTop+",left="+iLeft+",toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=1");
	newWin.document.write(img.outerHTML);
	newWin.document.title = "图片详情"
	newWin.document.close();
}