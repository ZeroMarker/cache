$(function (){
	if(!EpisodeID&&!PatientID){
		alert("就诊ID不能为空和病人ID不能同时为空！");
		return;
	}

	//获取病人信息
	runClassMethod("web.DHCEMECheck","GetAdmInfoByAdmAdnPatID",{
		EpisodeID:EpisodeID,
		PatientID:PatientID,
		EmPCLvID:EmPCLvID
		},function (data){
			if(data == null){
				return;
			}else{
				console.log(data);
				var DocCheckLevCss={};
				$("#PatCardNo").val(data.PatCardNo)  	//卡号
				$("#PatNo").val(data.PatNo);			//登记号
				$("#PatName").val(data.PatName)  		//姓名
				$("#PatAge").val(data.PatAge);			//年龄
				$("#PatBoD").val(data.birthday)  		//出生日期
				$("#PatSex").val(data.PatSex);			//性别
				$("#PatNation").val(data.PatNation)  	//民族
				$("#PatCountry").val(data.PatCountry);	//国籍
				$("#PatIdNo").val(data.Ident+":"+data.IdentNo)  		//身份证号
				$("#PatTelH").val(data.PatTelH);		//家庭电话
				$("#PatAddress").val(data.Address)      //家庭住址
				$("#EmDocCheckLev").val(setCell(data.DocCheckLev));  //医生分级 //hxy 2020-02-21			
				$("#EmDocCheckLevReason").val(data.DocCheckReason);  //医生分级原因
				DocCheckLevCss = StyleCheckLevColor(data.DocCheckLev);
				$("#EmDocCheckLev").css(DocCheckLevCss);
				
				if(EmPCLvID==="") EmPCLvID = data.EmPCLvID;
				if(!EmPCLvID) return;
				GetEmPatCheckLev(EmPCLvID);   //加载分级信息
			}
		})
})

function GetEmPatCheckLev(EmPCLvID){

			//获取分诊信息
	runClassMethod("web.DHCEMECheck","GetEmPatCheckLev",{"EmPCLvID":EmPCLvID},function(jsonString){
		if (jsonString != null){
			var EmPatCheckLevObj = jsonString;
			///	 总人数
			$("#EmBatchNum").val(EmPatCheckLevObj.EmBatchNum);
			
			///  推荐分级
			$("#EmRecLevel").val(EmPatCheckLevObj.EmRecLevel);
			
			///  护士更改分级原因
			$("#EmUpdLevRe").val(EmPatCheckLevObj.EmUpdLevRe);

			///  分诊科室
			$("#EmLocDesc").val(EmPatCheckLevObj.EmLocID);  //2016-09-06 congyue

			///  意识状态
			$("#EmAware").val(EmPatCheckLevObj.EmAware);

			///  护士分级
			//$('input[name="NurseLevel"][value="'+ EmPatCheckLevObj.NurseLevel +'"]').attr("checked",'checked'); 
			$("#NurseLevel").val(EmPatCheckLevObj.NurseLevel);
			
			///  去向
			$("#Area").val(EmPatCheckLevObj.Area) 
			
			//重返标识
			$("#EmAgainFlag").val(FormatterData(EmPatCheckLevObj.EmAgainFlag))
			
			//成批就诊
			$("#EmBatchFlag").val(FormatterData(EmPatCheckLevObj.EmBatchFlag))
			
			//病人来源
			$("#EmPatSource").val(EmPatCheckLevObj.EmPatSource);
			
			///  来诊方式
			$("#EmPatAdmWay").val(EmPatCheckLevObj.EmPatAdmWay);
			
			///  中毒
			$("#EmPoisonFlag").val(FormatterData(EmPatCheckLevObj.EmPoisonFlag));

			///  是否吸氧
			$("#EmOxygenFlag").val(FormatterData(EmPatCheckLevObj.EmOxygenFlag));
			
			///  筛查
			$("#EmScreenFlag").val(EmPatCheckLevObj.EmScreenFlag=="Y"?$g("是"):$g("否"));
			
			///  复合伤
			$("#EmCombFlag").val(FormatterData(EmPatCheckLevObj.EmCombFlag));

			///  ECG
			$("#EmECGFlag").val(FormatterData(EmPatCheckLevObj.EmECGFlag));
			
			///  用药情况
			$("#EmHisDrugDesc").val(EmPatCheckLevObj.EmHisDrug);

			///  辅助物
			$("#EmMaterialDesc").val(EmPatCheckLevObj.EmMaterial);

			///  疼痛分级
			$("#EmPainLev").val(EmPatCheckLevObj.EmPainLev);

			///  已开假条
			//$('[name="EmPatAskFlag"][value="'+ EmPatCheckLevObj.EmPatAskFlag +'"]').attr("checked",true);
			
			//生命体征
			$("#EmPatChkSign").val(EmPatCheckLevObj.EmPatChkSign)
			
			///	 成批就诊			
			//$("#EmBatchFlag").val(EmPatCheckLevObj.EmBatchFlag);
															
			///	 用药情况
			$("#EmHisDrugDesc").val(EmPatCheckLevObj.EmHisDrugDesc);
			
			///	 辅助物
			$("#EmMaterialDesc").val(EmPatCheckLevObj.EmMaterialDesc);
				
						
			///	 其他
			$("#EmOtherDesc").val(EmPatCheckLevObj.EmOtherDesc);

			///  症状
			$("#EmSymDesc").val(EmPatCheckLevObj.EmSymDesc)
			
			///	 既往史
			$("#EmPatChkHis").val(EmPatCheckLevObj.EmPatChkHis)
			
			///  预检号别
			$("#EmPatChkCare").val(EmPatCheckLevObj.EmPatChkCare)
			
			//来诊时间	
			$("#EmRegDate").val(EmPatCheckLevObj.PCLDate+" "+EmPatCheckLevObj.PCLTime)  		
			///  特殊人群 2016-09-05 congyue
			//$('[name="EmPatChkType"][value="'+ EmPatCheckLevObj.EmPatChkType +'"]').attr("checked",true);
			CheckLevColor(EmPatCheckLevObj);  //分级颜色
		}
	})
}

function CheckLevColor(data){
	var StyleCss={};
	StyleCss = StyleCheckLevColor(data.EmRecLevel);
	$("#EmRecLevel").css(StyleCss)
	StyleCss = StyleCheckLevColor(data.NurseLevel);
	$("#NurseLevel").css(StyleCss)
	StyleCss = StyleCheckLevAreaColor(data.Area);
	$("#Area").css(StyleCss);
	
}

function StyleCheckLevColor(param){
	var css={};
	/*if(param=="1级"){ //hxy 2020-02-21 st
		css = {"color":"red","font-weight":"bold"};
	}
	if(param=="2级"){
		css = {"color":"red","font-weight":"bold"};
	}
	if(param=="3级"){
		css = {"color":"#f9bf3b","font-weight":"bold"};	
	}
	if(param=="4级"){
		css = {"color":"green","font-weight":"bold"};	
	}*/
	if((param==$g("Ⅰ级"))||(param==$g("1级"))){
		css = {"color":"red","font-weight":"bold"};
	}
	if((param==$g("Ⅱ级"))||(param==$g("2级"))){
		css = {"color":"orange","font-weight":"bold"};
	}
	if((param==$g("Ⅲ级"))||(param==$g("3级"))){
		css = {"color":"#f9bf3b","font-weight":"bold"};	
	}
	if((param==$g("Ⅳa级"))||(param==$g("Ⅳb级"))||(param==$g("4级"))||(param==$g("5级"))){
		css = {"color":"green","font-weight":"bold"};	
	}//ed
	return css;
}

function StyleCheckLevAreaColor(param){
	var css={};
	if(param==$g("红区")){
		css = {"color":"red","font-weight":"bold"};
	}
	if(param==$g("橙区")){ //hxy 2020-02-21 st
		css = {"color":"orange","font-weight":"bold"};
	}//ed
	if(param==$g("黄区")){
		css = {"color":"#f9bf3b","font-weight":"bold"};
	}
	if(param==$g("绿区")){
		css = {"color":"green","font-weight":"bold"};	
	}

	return css;
}


//格式化数据Y->是，N->否
function FormatterData(data){
	if(data.trim()=="Y"){
		return $g("是");	
	}else if(data.trim()=="N"){
		return $g("否");	
	}else{
		return ""	
	}	
}

//hxy 2020-02-21
function setCell(value){
	if(value==$g("1级")){value=$g("Ⅰ级");}
	if(value==$g("2级")){value=$g("Ⅱ级");}
	if(value==$g("3级")){value=$g("Ⅲ级");}
	if(value==$g("4级")){value=$g("Ⅳa级");}
	if(value==$g("5级")){value=$g("Ⅳb级");}
	return value;
}
