var cPanel=(function(){
	var OperFlag = 1;       /// 手术显示状态
	function Init(){
		InitPageComponent();
		LoadTestItemList();
		/// 取材医生				
		if (ServerObj.DefualtDoc=="1"){$('#DocDr').combobox("setValue",session['LOGON.USERID']);}
			
		/// 取材科室
		$('#LocID').combobox("setValue",session['LOGON.CTLOCID']);
		LoadPatClinicalRec();
		InitPageCheckBox();
		LoadOtherInfo();
		}
	/// 初始化界面控件内容
	function InitPageComponent(){
		
		/// 手术医生	
		$('#OperUser').combobox({
			url:LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=QueryDoc&LocID="+'',
			//mode:'remote',
			blurValidValue:true,		
			onShowPanel:function(){		
				var unitUrl = LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=QueryDoc&LocID="+'';
				$("#OperUser").combobox('reload',unitUrl);
			}
		});
		
		/// 肿瘤发现日期
		$('#FoundDate').datebox({
			onSelect:function(date){
				var PisDate = "";
				if (PisID != ""){
					PisDate = GetPisNoSysTime();
				}
				PisDate = new Date(PisDate.replace(/\-/g, "\/"));  
				if (date > PisDate){
					$.messager.alert("提示:","肿瘤发现不能晚于申请日期！");
					$('#FoundDate').datebox('setValue',"");
					return;
				}
			}
		})
		
		/// 肿瘤发现日期控制
		$('#FoundDate').datebox().datebox('calendar').calendar({
			validator: function(date){
				var now = new Date();
				return date<=now;
			}
		});
		
		/// 上次月经日期控制
		$('#LastMensDate').datebox().datebox('calendar').calendar({
			validator: function(date){
				var now = new Date();
				return date<=now;
			}
		});
		
		/// 末次月经日期控制
		$('#MensDate').datebox().datebox('calendar').calendar({
			validator: function(date){
				var now = new Date();
				return date<=now;
			}
		});
		
		/// 上次月经日期控制
		$('#LastMensDate').datebox({
			onSelect: function(date){
				var MensDate = $HUI.datebox("#MensDate").getValue(); /// 末次月经
				if (MensDate != ""){
					var LastMensDate = $HUI.datebox("#LastMensDate").getValue(); /// 上次月经
					if (isCompare(LastMensDate, MensDate) == 1){
						$.messager.alert("提示:","【上次月经日期】不能大于等于【末次月经日期】！");
						$('#LastMensDate').datebox('setValue',"");
						return;
					}
				}else{
					$HUI.checkbox("#PauFlag").setValue(false);  /// 绝经
				}
				return true;
			}
		});
		
		/// 末次月经日期控制
		$('#MensDate').datebox({
			onSelect: function(date){
				var LastMensDate = $HUI.datebox("#LastMensDate").getValue(); /// 上次月经
				if (LastMensDate != ""){
					//var LastMensDate = new Date(LastMensDate.replace(/\-/g, "\/"));
					var MensDate = $HUI.datebox("#MensDate").getValue(); /// 末次月经
					if (isCompare(LastMensDate, MensDate) != 0){
						$.messager.alert("提示:","【末次月经日期】不能小于等于【上次月经日期】！");
						$('#MensDate').datebox('setValue',"");
						return;
					}
				}else{
					$HUI.checkbox("#PauFlag").setValue(false);  /// 绝经
				}
				return true;
			}
		});
			
		/// 胎数
		$("#PreTimes").keyup(function(){
		    var PreTimes = $("#PreTimes").val();  /// 胎数
		    var LyTimes = $("#LyTimes").val();    /// 产数
		    if ((LyTimes != "")&(PreTimes < LyTimes)){
			    $.messager.alert("提示:","胎数必须大于等于产数！");
				$("#PreTimes").val("");
			}
		});
		
		/// 产数
		$("#LyTimes").keyup(function(){
		    var PreTimes = $("#PreTimes").val();  /// 胎数
		    var LyTimes = $("#LyTimes").val();    /// 产数
		    if ((LyTimes != "")&(PreTimes < LyTimes)){
			    $.messager.alert("提示:","胎数必须大于等于产数！");
				$("#LyTimes").val("");
			}
		});
		
		/// 标本离体时间控制
		$('#SepDate').datetimebox({
			onHidePanel:function (){
				var SepDate = $HUI.datetimebox("#SepDate").getValue(); /// 离体时间
				var FixDate = $HUI.datetimebox("#FixDate").getValue(); /// 固定时间
				if(SepDate!=""){
					var SepDate=parseDateTime(SepDate);
					$HUI.datetimebox("#SepDate").setValue(SepDate.Format("yyyy-MM-dd hh:mm"))
				}
				if (FixDate != ""){
					var FixDate=parseDateTime(FixDate)
					//var FixDate = new Date(FixDate.replace(/\-/g, "\/"));
					//var SepDate = new Date(SepDate.replace(/\-/g, "\/"));
					if (SepDate >= FixDate){
						$.messager.alert("提示:","标本固定时间不能早于标本离体时间！");
						$('#SepDate').datetimebox('setValue',"");
						return;
					}
				}
				return true;    
			}
		});
		
		/// 标本固定时间控制
		$('#FixDate').datetimebox({
			onHidePanel:function (){
				var SepDate = $HUI.datetimebox("#SepDate").getValue(); /// 离体时间
				var FixDate = $HUI.datetimebox("#FixDate").getValue(); /// 固定时间
				if(FixDate!=""){
					var FixDate=parseDateTime(FixDate);
					$HUI.datetimebox("#FixDate").setValue(FixDate.Format("yyyy-MM-dd hh:mm"))
				}
				if (SepDate != ""){
					var SepDate=parseDateTime(SepDate)
					//var SepDate = new Date(SepDate.replace(/\-/g, "\/"));
					//var FixDate = new Date(FixDate.replace(/\-/g, "\/"));
					if (FixDate < SepDate){
						$.messager.alert("提示:","标本固定时间不能早于标本离体时间！");
						$HUI.datetimebox("#FixDate").setValue("");
						return;
					}
				}
				return true;
			}
		});
		
		/// 标本离体时间控制
		$('#SepDate').datetimebox().datetimebox('calendar').calendar({
			validator: function(date){
				var now = new Date();
				return date<=now;
			}
		});
		
		/// 标本固定时间控制
		$('#FixDate').datetimebox().datetimebox('calendar').calendar({
			validator: function(date){
				var now = new Date();
				return date<=now;
			}
		});
		
		/// 妇科信息
		$("#WomenCk").bind("click", WomenCk_OnClick);
		
		/// 肿瘤信息
		$("#TumorCk").bind("click", TumorCk_OnClick);
		
		/// 取材科室 
		$('#LocID').combobox({	//取材科室和取材医生可以选择 2018/2/2 qunianpeng 
			mode:'remote',  
			url:LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=SelAllLoc&&hospId="+LgHospID,
			blurValidValue:true,
			onShowPanel:function(){
				// var unitUrl = LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=SelAllLoc&&hospId="+LgHospID;
				// $("#LocID").combobox('reload',unitUrl);
			},
			onSelect:function(){	//设置级联 选择科室后，加载可以登录该科室的医生 qunianpeng 2018/2/7
				$("#DocDr").combobox("setValue","");
				$("#DocDr").combobox('reload');
			}
		});
		/// 取材医生 
		$('#DocDr').combobox({
			//mode:'remote',
			blurValidValue:true,
			url:LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=QueryDoc&LocID=",	
			onShowPanel:function(){
				var bLocID=$('#LocID').combobox('getValue');			
				var unitUrl = LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=QueryDoc&LocID="+bLocID;
				$("#DocDr").combobox('reload',unitUrl);
			}
		});	
		if (OperFlag == 1){
			$("#OperCon").hide();   /// 隐藏手术信息
		}
		$HUI.checkbox("#PauFlag", {
		onCheckChange:function(event,value){
			if (value == true){
				$('#MensDate').datebox('setValue',"");
				$('#LastMensDate').datebox('setValue',"");
			}
			}
		})
		var OperNameJson=tkMakeServerCall("web.DHCAppPisMasterQuery","GetOperName",EpisodeID)
	 $("#OperName").combogrid({
		panelWidth:500,
        mode:'remote',
        idField:'OPSID',
        textField:'OperDesc',
        data: JSON.parse(OperNameJson),
        columns:[[  
            {field:'AppDateTime',title:'手术申请时间',width:100},  
            {field:'OperDesc',title:'手术名称',width:80},  
            {field:'AppCareProvDesc',title:'手术申请人',width:80},  
            {field:'BodySiteDesc',title:'手术部位',width:80},  
            {field:'OperDateTime',title:'手术时间',width:80},  
            {field:'OPSID',title:'手术申请ID',width:50}  
        ]],
        pagination:true,
        onSelect:function(index,rowData){
	        $("#OperPart").val(rowData.BodySiteDesc)
			$HUI.datetimebox("#OperTime").setValue(rowData.OperDateTime);
			$("#OperID").val(OperID)
            //console.log("index="+index+",rowData=",rowData);
        },
    });

	}
	/// 加载临床病历  sufan 2018-02-01
	function LoadPatClinicalRec(){
		runClassMethod("web.DHCAppPisMasterQuery","GetPatClinicalRec",{"EpisodeID":EpisodeID},function(jsonString){

			if (jsonString != null){
				var jsonObjArr = jsonString;
			
				$("#MedRecord").val( jsonObjArr.arExaReqSym +""+ jsonObjArr.arExaReqHis +""+ jsonObjArr.arExaReqSig);  /// 主诉+现病史+体征
				
			}
		},'json',false)
	}

	/// 妇科信息
	function WomenCk_OnClick(){
		
		if (!$("#WomenCk").is(":checked")){
			$HUI.datebox("#LastMensDate").setValue("");  /// 上次月经
			$HUI.datebox("#MensDate").setValue("");      /// 末次月经
			$("#PreTimes").val(""); 	   		         /// 胎
			$("#LyTimes").val(""); 	   		             /// 产
			$HUI.checkbox("#PauFlag").setValue(false);   /// 绝经
		}
	}

	/// 肿瘤信息
	function TumorCk_OnClick(){

		if (!$("#TumorCk").is(":checked")){
			$HUI.datebox("#FoundDate").setValue("");   /// 发现日期
			$("#TumPart").val(""); 	   		           /// 原发部位
			$("#TumSize").val(""); 	   		           /// 肿瘤大小
			$("#TransPos").val(""); 	   		           /// 转移部位
			$("#Remark").val(""); 	   		               /// 备注
			$HUI.checkbox("#TransFlag").setValue(false);   /// 转移
			$HUI.checkbox("#RadCureFlag").setValue(false); /// 放疗
			$HUI.checkbox("#CheCureFlag").setValue(false); /// 化疗
		}
	}
	function LoadTestItemList(){
		
		/// 初始化检查方法区域
		$("#TesItem").html('<tr style="height:0px;" ><td style="width:20px;"></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
		runClassMethod("web.DHCAppPisMasterQuery","JsonPatInfDisList",{"HospID":LgHospID},function(jsonString){

			if (jsonString != ""){
				var jsonObjArr = jsonString;
				for (var i=0; i<jsonObjArr.length; i++){
					InsTesItemRegion(jsonObjArr[i]);
				}
			}
		},'json',false)
	}

	/// 病人传染病史内容
	function InsTesItemRegion(itemobj){	
		/// 标题行
		var htmlstr = '';
			htmlstr = '<tr style="height:30px"><td colspan="9" class=" tb_td_required" style="border:0px solid #ccc;font-weight:bold;">'+ itemobj.text +'</td></tr>';

		/// 项目
		var itemArr = itemobj.items;
		var itemhtmlArr = []; itemhtmlstr = "";
		for (var j=1; j<=itemArr.length; j++){
			
			var InputHtml = "";
			if (itemArr[j-1].text == "其他"){
			   InputHtml = '<input type="text" class="name-input-80" id="Test'+ itemArr[j-1].value +'"></input>';
			}
			itemhtmlArr.push('<td style="width:30px;"><input id="'+ itemArr[j-1].value +'" name="'+ itemArr[j-1].name +'" type="checkbox" value="'+ itemArr[j-1].value +'"></input></td><td>'+ itemArr[j-1].text + InputHtml +'</td>');
			if (j % 4 == 0){
				itemhtmlstr = itemhtmlstr + '<tr><td></td>' + itemhtmlArr.join("") + '</tr>';
				itemhtmlArr = [];
			}
		}
		if ((j-1) % 4 != 0){
			itemhtmlstr = itemhtmlstr + '<tr><td></td>' + itemhtmlArr.join("") + '<td style="width:30px"></td><td></td></tr>';
			itemhtmlArr = [];
		}
		$("#TesItem").append(htmlstr+itemhtmlstr)
	}
	/// 页面CheckBox控制
	function InitPageCheckBox(){
		
		$("input[name=TestItem]").click(function(){
			if ($(this).parent().next().text() == "其他"){
				if($("[value='"+this.id+"'][name=TestItem]").is(':checked')){
					/// 选中
					$("#Test"+ this.id).show();
				}else{
					/// 取消
					$("#Test"+ this.id).hide();
				}
			}
		
			/// 选择无时，进行设置
			if (($(this).parent().next().text() == "无")||($(this).parent().next().text() == "未查")||($(this).parent().next().text() == "结果未回")){
				if($("[value='"+this.id+"'][name=TestItem]").is(':checked')){
					$("input[name=TestItem][value!='"+this.id+"']").removeAttr("checked");
					/// 取消
					$("[id^='Test']").hide();
				}
			}else{
				$("input[name=TestItem]").each(function(){
					if (($(this).parent().next().text() == "无")||($(this).parent().next().text() == "未查")||($(this).parent().next().text() == "结果未回")){
						$("input[name=TestItem][value='"+this.id+"']").removeAttr("checked");
					}
				});
			}
		});
		
		//肿瘤信息选择后在显示详细信息 qunianpeng 2018/1/19	
		$("#TumorCk").nextAll().css("display","none");	
		$("#TumorCk").click(function(){
			if($("#TumorCk").is(':checked')){
				$("#TumorCk").nextAll().css("display","block");
			}else{
				$("#TumorCk").nextAll().css("display","none");
			}
		});
		$("#WomenCk").nextAll().css("display","none");	
		$("#WomenCk").click(function(){
			if($("#WomenCk").is(':checked')){
				$("#WomenCk").nextAll().css("display","block");
			}else{
				$("#WomenCk").nextAll().css("display","none");
			}
		});

	}
	function LoadOtherInfo(){
		var OtherInfo=""
		if (itemReqJsonStr!=""){
			for (var i = 0; i < itemReqJsonStr.length; i++) {
				var OneReqJson=itemReqJsonStr[i]
				var ID=OneReqJson.ID
				var Val=OneReqJson.Val
				if (ID=="OtherInfo") OtherInfo=Val
			}
		}
		if (OtherInfo!=""){
			OtherObj=$.parseJSON(OtherInfo); 
			mPisTesItm=$.parseJSON(OtherObj["mPisTesItmArr"])
			for (var i = 0; i < mPisTesItm.length; i++) {
				var Psiarry=mPisTesItm[i]
				var PsiID=Psiarry.split("^")[0]
				var PisTesItmArr = $("input[name=TestItem]");
	    		for (var j=0; j < PisTesItmArr.length; j++){
		    		if (PisTesItmArr[j].id==PsiID){
							$('#'+PsiID).attr("checked",true);
							if ($('#'+PsiID).parent().next().text() == "其他"){
								$("#Test"+ PsiID).show();
								$("#Test"+ PsiID).val(Psiarry.split("^")[1]);
								
								}
			    		}
		    		}
				}
			mPisTesItm=$.parseJSON(OtherObj["FixItemArr"])
			for (var i = 0; i < mPisTesItm.length; i++) {
				var Psiarry=mPisTesItm[i]
				var PsiID=Psiarry.split("^")[0]
				var PisTesItmArr = $("input[name=FixItem]");
	    		for (var j=0; j < PisTesItmArr.length; j++){
		    		if (PisTesItmArr[j].id==PsiID){
							$('#'+PsiID).attr("checked",true);
			    		}
		    		}
				}
			}
	}

	function OtherInfo(){
		mPisTesItmArr = []
		var PisTesItmArr = $("input[name=TestItem]");
	    for (var j=0; j < PisTesItmArr.length; j++){
		    if($('#'+PisTesItmArr[j].id).is(':checked')){
			    /// 其他项目判断
			    var TestItem = "";
			    if ($('#'+PisTesItmArr[j].id).parent().next().text() == "其他"){
					TestItem = $("#Test"+ PisTesItmArr[j].id).val();
					if (TestItem == "") {mPisTesFlag=1; break;}
				}
				
				mPisTesItmArr.push(PisTesItmArr[j].value +"^"+ TestItem);
		    }
		}
		var mPisTesItm = JSON.stringify(mPisTesItmArr);
		mPisTesItmArr = []
		var PisTesItmArr = $("input[name=FixItem]");
	    for (var j=0; j < PisTesItmArr.length; j++){
		    if($('#'+PisTesItmArr[j].id).is(':checked')){
			    /// 其他项目判断
			    var TestItem = "";
			    if ($('#'+PisTesItmArr[j].id).parent().next().text() == "其他"){
					TestItem = $("#Test"+ PisTesItmArr[j].id).val();
					if (TestItem == "") {mPisTesFlag=1; break;}
				}
				
				mPisTesItmArr.push(PisTesItmArr[j].value +"^"+ TestItem);
		    }
		}
		var FixItem = JSON.stringify(mPisTesItmArr);
		var RecLocDesc= $HUI.combobox("#recLoc").getText();
		var rtnObj = {}
		rtnObj["mPisTesItmArr"] = mPisTesItm;
		rtnObj["FixItemArr"] = FixItem;
		return rtnObj
	}
	function PrintInfo(){
		var mPisTesItm=""
		var PisTesItmArr = $("input[name=TestItem]");
	    for (var j=0; j < PisTesItmArr.length; j++){
		    if($('#'+PisTesItmArr[j].id).is(':checked')){
			    /// 其他项目判断
			    var TestItem = "";
			    if ($('#'+PisTesItmArr[j].id).parent().next().text() == "其他"){
					TestItem = $("#Test"+ PisTesItmArr[j].id).val();
					
				}else{
					TestItem=$('#'+PisTesItmArr[j].id).parent().next().text() 
					if ((TestItem!="无")&&(TestItem!="未查")&&(TestItem!="结果未回")){
						TestItem=TestItem+"(+)"
						}
					}
				if (mPisTesItm==""){
					var OnePic
					mPisTesItm=TestItem 
					}else{
					mPisTesItm=mPisTesItm+","+TestItem 
					}
				
		    }
		}
		FixItem=""
		var PisTesItmArr = $("input[name=FixItem]");
	    for (var j=0; j < PisTesItmArr.length; j++){
		    if($('#'+PisTesItmArr[j].id).is(':checked')){
			    /// 其他项目判断
			    var TestItem = "";
			    if ($('#'+PisTesItmArr[j].id).parent().next().text() == "其他"){
					TestItem = $("#Test"+ PisTesItmArr[j].id).val();
					if (TestItem == "") {mPisTesFlag=1; break;}
				}
				
				if (FixItem==""){
					FixItem=$('#'+PisTesItmArr[j].id).parent().next().text() 
					}else{
					FixItem=FixItem+","+$('#'+PisTesItmArr[j].id).parent().next().text() 
					}
		    }
		}
		var rtnObj = {}	
		var MedRecord=$("#MedRecord").val()
		var Stringlength=MedRecord.length
		var Number=1,StartLeng=0,MaxLength=100
		for (var j=0; j < MedRecord.length; j++){
			if ((j-StartLeng)>=MaxLength){
				rtnObj["MedRecord"+Number] = str.substr(StartLeng,j);
				StartLeng=j
				Number++
				}else if(j==MedRecord.length){
				rtnObj["MedRecord"+Number] = str.substr(StartLeng,j);	
				}
			}
		var rtnObj = {}	
		var MedRecord=$("#OperRes").val()
		var Stringlength=MedRecord.length
		var Number=1,StartLeng=0,MaxLength=100
		for (var j=0; j < MedRecord.length; j++){
			if ((j-StartLeng)>=MaxLength){
				rtnObj["OperRes"+Number] = str.substr(StartLeng,j);
				StartLeng=j
				Number++
			}else if(j==MedRecord.length){
				rtnObj["OperRes"+Number] = str.substr(StartLeng,j);	
				}
			}
		rtnObj["PisPatInfDis"] = mPisTesItm;
		rtnObj["FixItem"] = FixItem;
		
		return rtnObj
		}
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
		}
	   
})();