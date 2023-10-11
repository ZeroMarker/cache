var PageLogicObj={
	m_PatientListJson:[]
}
$(function(){
	setTableStyle();
	setDefaultValue("P","ACP");
	InitBedNo();
	if (ServerObj.NCPARRowID!=""){
		setNCPAccompanyInfo();
	}
	InitEvent();
})
function setTableStyle(){
	var td_MaxWidth=0
	var _tds=$("#NCPAccompanyRecEditWin table tr td.r-label:first-child");
	for (var i=0;i<_tds.length;i++){
		var td_width=$(_tds[i]).width();
		if (td_width>td_MaxWidth) td_MaxWidth=td_width;
	}
	_tds.css("width",td_MaxWidth);
}
function InitEvent(){
	$("#BSave").click(function(){SaveNCPAccompanyRec("");});
	$("#BSavePrint").click(SavePrintNCPAccompanyRec);
	$("#ReadCard").click(BtnReadCardHandler);
	$("#ReadPatInfo").click(ReadPatInfoHandler);
	$("#NCPARegNo").keydown(AccompanyNoOnKeyDown);
	$("#NCPARIdNo").blur(AccompanyCredNoBlur);
}
function InitBedNo(){
	var JsonData=$.cm({
        ClassName:"Nur.NIS.Service.Base.Ward",
        MethodName:"GetWardPatients",
        wardID:ServerObj.wardId,
        adm:ServerObj.EpisodeID, 
        groupSort:false,
        babyFlag:"",
        groupID:session['LOGON.GROUPID'],
        userID:session['LOGON.USERID']
    },false)
    var defPatInfo={};
    for (var i=0;i<JsonData.length;i++){
        if (("^床位^等候区^病人^患者^").indexOf("^"+JsonData[i].label+"^")>=0){
            PageLogicObj.m_PatientListJson=PageLogicObj.m_PatientListJson.concat(JsonData[i].children);
        }
        if (ServerObj.EpisodeID!=""){
            var index=$.hisui.indexOfArray(JsonData[i].children,"ID",ServerObj.EpisodeID);
            if (index>=0){
	            defPatInfo=JsonData[i].children[index];
	        }
        }
    }
    if (ServerObj.EpisodeID!=""){
        var index=$.hisui.indexOfArray(PageLogicObj.m_PatientListJson,"ID",ServerObj.EpisodeID);
        if (index<0) {
	        PageLogicObj.m_PatientListJson.push(defPatInfo);
	    }
    }
	$("#bedCode").combobox({
		valueField:'episodeID',
		textField:'label',
		mode: "local",
		data:PageLogicObj.m_PatientListJson,
		//disabled:ServerObj.defEpisodeID?true:false,
		onChange:function(newValue, oldValue){
			if (!newValue) {
				$("#patAge,#patName,#regNo").val("").removeAttr("disabled");
			}
		},
		onSelect:function(record){
			if (record) {
				$("#patAge").val(record.age).attr("disabled","disabled");
				$("#patName").val(record.name).attr("disabled","disabled");
				$("#regNo").val(record.regNo).attr("disabled","disabled");
				//2021-08-10
				var Result=tkMakeServerCall("Nur.NIS.Service.Accom.NCPAccompany", "GetNCPAccompanyControl",record.episodeID,session['LOGON.HOSPID']);
				if(Result=="Y"){
					$.messager.popover({msg:'患者未开陪护医嘱!',type:'error'});
					$("#BSave").hide()
					$("#BSavePrint").hide()
				}
				else{
					$("#BSave").show()
					$("#BSavePrint").show()					
				}
			}
		},
		onLoadSuccess:function(){
			if (ServerObj.EpisodeID!="") {
				$("#bedCode").combobox('select',ServerObj.EpisodeID);
			}
			if (ServerObj.bedEnable=="N"){
				$("#bedCode").combobox("disable");
			}
		}
	})
}
function setDefaultValue(opType,colType)
{				
	$.cm({
		ClassName:"Nur.NIS.Service.Accom.NCPAccompany",
		MethodName:"GetNCPAccompanyDefaultData",
		hospId:session['LOGON.HOSPID'],
		opType:opType,
		colTypeStr:colType
	},function(JsonData){
		for (var i=0;i<JsonData.length;i++){
			if(JsonData[i]["initValue"]!="")
			{	
				if(JsonData[i]["type"]=="单选框")
				{
					$("#"+JsonData[i]["field"]+"_"+JsonData[i]["initValue"]).radio("check");
				}
				else if(JsonData[i]["type"]=="日期")
				{
					$("#"+JsonData[i]["field"]).datebox("setValue",JsonData[i]["initValue"]); 
				}else if(JsonData[i]["type"]=="时间")
				{
					$("#"+JsonData[i]["field"]).val(JsonData[i]["initValue"]);
				}
			}
				
		}
		
	})
}
function SaveNCPAccompanyRec(callBackFun){
	var episodeID=$("#bedCode").combobox("getValue");
	if (!episodeID) {
		$.messager.popover({msg:'请选择患者床号！',type:'error'});
		$("#bedCode").next('span').find('input').focus();
		return false;
	}else if($.hisui.indexOfArray($("#bedCode").combobox("getData"),"episodeID",episodeID)<0){
		$.messager.popover({msg:'请在下拉框中选择患者床号！',type:'error'});
		$("#bedCode").next('span').find('input').focus();
		return false;
	}
	var NCPARIdNo=$("#NCPARIdNo").val();
	if (!NCPARIdNo) {
		$.messager.popover({msg:'请填写陪护人身份证号！',type:'error'});
		$("#NCPARIdNo").focus();
		return false;
	}else if(!DHCWeb_IsIdCardNo(NCPARIdNo)){
		//$("#NCPARIdNo").focus();
		return false;
	}
	var AccompanyActive=$("#NCPARAccompanyStatus_Yes").radio("getValue")?"Y":"N";
	var SaveDataArr={},SaveNameArr={}
	$('input, select, textarea').each(function(index){
	     var input = $(this);
	     var id=input.attr('id');
	     var value=undefined;
	     var type=input.attr('type');
	     var hidden=input.attr('hidden');
	     var name=input.attr("name");
	     if ((id!=undefined)&&(type!=undefined)){
              if (type=='textbox' && hidden!='hidden'){
                  //value=input.textbox('getValue');
                  value=$.trim(input.val());
              }else if (type=='combobox'){
                  value=input.combobox('getValue');
              }else if (type=='checkbox'){
                  if (input.is(':checked')) value=input.attr('xtext');
              }else if (type=='radio'){
                  //value=input.radio("getValue");
                  value="";
                  var id=name;
                  var _$sel=$("input[name='"+name+"']:checked");
                  if (_$sel.length>0){
	                  var selId=_$sel[0].id;
	                  value=selId.split("_")[1];
	              }
              }else if (type=='datetext'){
                  value=input.datebox("getValue")
              }else if (type!='button'){
                  value=input.val();                       
              }
              SaveDataArr[id]=value;
	     }
	});
	SaveDataArr["NCPAInfo1"]=$.trim($("#NCPAInfo1").val());
	SaveDataArr["episodeID"]=episodeID;
	SaveDataArr["NCPARIdNo"]=NCPARIdNo;
	SaveDataArr["NCPARPaPmiDR"]="";
	SaveDataArr["AccompanyActive"]=AccompanyActive;
	var RepeatCredNoRecFlag= tkMakeServerCall("Nur.NIS.Service.Accom.NCPAccompany", "GetRepeatCredNoRec",episodeID,ServerObj.NCPARRowID,NCPARIdNo);
	if (RepeatCredNoRecFlag =="Y"){
		$.messager.popover({msg:'身份证号:'+NCPARIdNo+"已是该患者陪护人员！",type:'error'});
		return false;
	}
	var deleteFlag= tkMakeServerCall("Nur.NIS.Service.Accom.NCPAccompany", "getIfActiveRec",episodeID,session['LOGON.HOSPID']);
	var Msg="";
	if ((!PageLogicObj.m_selAccompanyRecId)&&(deleteFlag=="Y")) {
		var Msg="确定新增启用状态的陪护记录吗?若患者已存在有效的陪护记录，新增后则自动停用！";
	}
	if (Msg!=""){
		$.messager.confirm('提示', Msg, function(r){
			if (r) {
				save();
			}
		});
	}else{
		save();
	}
	function save(){
		var NCPARRowID=$.m({
			ClassName:"Nur.NIS.Service.Accom.NCPAccompany",
			MethodName:"SaveNCPAccompanyRec",
			RecordID:ServerObj.NCPARRowID,//PageLogicObj.m_selAccompanyRecId,
			SaveDataArr:JSON.stringify(SaveDataArr),
			UserID:session['LOGON.USERID']
		},false)
		if (NCPARRowID>0) {
			if (callBackFun) callBackFun(NCPARRowID);
			if (websys_showModal("options").CallBackFunc){
				websys_showModal("options").CallBackFunc();
			}
		}else{
			$.messager.popover({msg:'保存失败！'+rtn,type:'error'});
			return false;
		}
	}
}
//保存并打印
function SavePrintNCPAccompanyRec(){
	SaveNCPAccompanyRec(function(NCPARRowID){
		PrintAccompanyRec(NCPARRowID,"N")
	});
}
function PrintAccompanyRec(RecordIDS,BlankAccompany){
	try {
		DHCP_GetXMLConfig("InvPrintEncrypt","NCPTie");
		var JsonData=$.cm({
			ClassName:"Nur.NIS.Service.Accom.NCPAccompany",
			MethodName:"GetNCPAccompanyPrintData",
			RecordIDS:RecordIDS,
			BlankAccompany:BlankAccompany
		},false)
		for (var i=0;i<JsonData.length;i++){
			var MyPara = "" + String.fromCharCode(2);
			for (Element in JsonData[i]){
				MyPara=MyPara +"^"+ Element + String.fromCharCode(2) + JsonData[i][Element];
			}
			DHC_PrintByLodop(getLodop(),MyPara,"","","");
		}
	} catch(e) {alert(e.message)};
}
function BtnReadCardHandler() {
	CardNoCallBack("0^1^2^2^^0000000546");
	DHCACC_GetAccInfo7(CardNoCallBack);
}
function CardNoCallBack(myrtn){
	var myary=myrtn.split("^");
	var rtn=myary[0];
	switch (rtn){
		case "0": //卡有效有帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			$("#NCPARegNo").val(PatientNo);
			setAccomInfo("",PatientNo); 
			break;
		case "-200": //卡无效
			$.messager.alert("提示","卡无效","info",function(){
				$('#UPCardNo').focus();
			});
			break;
		case "-201": //卡有效无帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			$("#NCPARegNo").val(PatientNo);
			setAccomInfo("",PatientNo); 
			event.keyCode=13;
		default:
	}
}
function ReadPatInfoHandler(){
	try {
		var myHCTypeDR = "1";
		var myInfo = DHCWCOM_PersonInfoRead(myHCTypeDR);
		//测试串
		//var myInfo = "0^<IDRoot><Age>55</Age><Name>***</Name><Sex>1</Sex><NationDesc>汉</NationDesc><Birth>19620817</Birth><Address>湖南省岳阳市岳阳楼区七里山社区居委会*区**栋***号</Address><CredNo>430105196208171015</CredNo><PhotoInfo></PhotoInfo></IDRoot>"
		var myAry = myInfo.split("^");
		if ((myAry.length > 1) && (myAry[0] == 0)) {
			var IDCardXML = myAry[1];
			var IDObj = new X2JS().xml_str2json(IDCardXML).IDRoot;
			$("#NCPARIdNo").val(IDObj["CredNo"]);
			$("#NCPAInfo1").val(IDObj["Name"]);
			var sex = "";
			switch (IDObj["Sex"]) {
				case "1":
					sex = "男";
					break;
				case "2":
					sex = "女";
					break;
				default:
			}
			$("#NCPAInfo2"+"-"+sex).radio("check");
			$("#NCPAInfo3").val(IDObj["Address"]);
		}
	} catch (e) {
		$.messager.popover({msg: "读身份证失败：" + e.message, type: "error"});
	}
}
function AccompanyNoOnKeyDown(e){
	var key=websys_getKey(e);
	if (key==13){
		var AccompanyCredNo = $("#NCPARIdNo").val().toUpperCase();
		var AccompanyRegNo = $("#NCPARegNo").val();
		setAccomInfo(AccompanyCredNo,AccompanyRegNo); 
		return false;
	}
}
function setAccomInfo(mypId,regNo){
	if(mypId.indexOf(" ")>-1)
	{
		mypId=mypId.split(" ")[0];
	}
	
	var myary;
	if(mypId!="")
	{
		myary=DHCWeb_GetInfoFromId(mypId);
	}
	if (((mypId!="")&&(myary[0]=="1"))||(regNo!="")){
		var rtn=$.m({
			ClassName:"Nur.NIS.Service.Accom.NCPAccompany",
			MethodName:"GetPatInfoByNo",
			RegNo:regNo,
			CredNo:mypId,
			logonHospID:session['LOGON.HOSPID']
		},false)
		if(rtn!="")
		{
			var arrInfo=JSON.parse(rtn)
			arr=[]
			$.each(arrInfo, function(key,value) {
		    	arr[value["colCode"]]=value["colValue"];
		    	arr[value["colCode"]+"_"+value["colValue"]]=value["colValue"];
		    });
		    
			$("input[class^='hisui-radio']").each(function(index,obj){
			  	
			  	if(arr[obj["id"]])
			  	{
					$("#"+obj["id"]).radio("check");
			  	}
			})
			$("input[class^='hisui-datebox']").each(function(index,obj){
			  	
			  	if(arr[obj["id"]])
			  	{
					$("#"+obj["id"]).datebox("setValue",arr[obj["id"]]);
			  	}
			})
			$("input[class^='hisui-timespinner']").each(function(index,obj){
			  	
			  	if(arr[obj["id"]])
			  	{
					$("#"+obj["id"]).val(arr[obj["id"]]);
			  	}
			})
			$("input[class^='textbox']").each(function(index,obj){
			  	
			  	if(arr[obj["id"]])
			  	{
					$("#"+obj["id"]).val(arr[obj["id"]]);
			  	}
			})
		}
	}else{
		$("#AccompanyCredNo").focus();
		return false;
	}
}
function AccompanyCredNoBlur(){
	var CredNo=$("#NCPARIdNo").val().toUpperCase();
	if (CredNo){
		setAccomInfo(CredNo);
		return false;
	}
}
function setNCPAccompanyInfo(){
	var row=websys_showModal("options").GetSelNCPAccompanyRec();
	arr=[]
	$.each(row, function(key,value) {
    	arr[key]=value;
    	arr[key+"_"+value]=value;
    });
	$("input[class^='hisui-radio']").each(function(index,obj){
	  	if(arr[obj["id"]]){
			$("#"+obj["id"]).radio("check");
	  	}
	})
	$("input[class^='hisui-datebox']").each(function(index,obj){
	  	if(arr[obj["id"]]){
			$("#"+obj["id"]).datebox("setValue",arr[obj["id"]]);
	  	}
	})
	$("input[class^='hisui-timespinner']").each(function(index,obj){
	  	if(arr[obj["id"]]){
			$("#"+obj["id"]).val(arr[obj["id"]]);
	  	}
	})
	$("input[class^='textbox']").each(function(index,obj){
	  	if(arr[obj["id"]]){
			$("#"+obj["id"]).val(arr[obj["id"]]);
	  	}
	})
	row.NCPARAccompanyStatus =="Y"?$("#NCPARAccompanyStatus_Yes").radio("check"):$("#NCPARAccompanyStatus_No").radio("check")
}