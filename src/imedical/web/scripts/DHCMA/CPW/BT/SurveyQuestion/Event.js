//页面Event
function InitDicEditWinEvent(obj){
    obj.LoadEvent = function(args){
	    //添加
		$('#btnAddS').on('click', function(){
			obj.Slayer();
		});
	    //保存
		$('#SaveS').on('click', function(){
	     	obj.btnSaveS_click();
     	});
     	//修改
		$('#btnEditS').on('click', function(){
			var rd=obj.gridSurvey.getSelected()
			obj.Slayer(rd);	
		});
     	//删除
		$('#btnDeleteS').on('click', function(){
			obj.btnDeleteS_click();
		}); 
		//题目
		//添加
		$('#btnAddQ').on('click', function(){
			obj.Qlayer();
		});
	    //保存
		$('#SaveQ').on('click', function(){
	     	obj.btnSaveQ_click();
     	});
     	//修改
		$('#btnEditQ').on('click', function(){
			var rd=obj.gridQuestion.getSelected()
			obj.Qlayer(rd);	
		});
     	//删除
		$('#btnDeleteQ').on('click', function(){
			obj.btnDeleteQ_click();
		});
		//选项
		//添加
		$('#btnAddO').on('click', function(){
			obj.Olayer();
		});
	    //保存
		$('#SaveO').on('click', function(){
	     	obj.btnSaveO_click();
     	});
     	//修改
		$('#btnEditO').on('click', function(){
			var rd=obj.gridOption.getSelected()
			obj.Olayer(rd);	
		});
     	//删除
		$('#btnDeleteO').on('click', function(){
			obj.btnDeleteO_click();
		});
		
    }
    //双击编辑标题事件
	obj.gridSurvey_onDbselect = function(rd){
		obj.Slayer(rd);
	}
	//双击编辑题目事件
	obj.gridQuestion_onDbselect = function(rd){
		obj.Qlayer(rd);
	}
	//双击编辑题目选项事件
	obj.gridOption_onDbselect = function(rd){
		obj.Olayer(rd);
	}
    //单击标题事件
	obj.gridSurvey_onSelect = function (){
		var rowData = obj.gridSurvey.getSelected();
		if (rowData["BTID"] == obj.SurveyID) {
			obj.SurveyID="";
			obj.gridSurvey.clearSelections();
			obj.gridOption.loadData([]);
			obj.gridQuestion.loadData([]);
			$("#btnAddS").linkbutton("enable"); 
			$("#btnEditS").linkbutton("disable");
			$("#btnDeleteS").linkbutton("disable");
			$("#btnAddQ").linkbutton("disable");
		}
		else {
			obj.SurveyID = rowData["BTID"];
			obj.QuestionID=""
			obj.OptionID=""
			obj.gridQuestion.load({
				ClassName:"DHCMA.CPW.BTS.SurveyQuestionSrv",
				QueryName:"QryQuestion",
				aParRef:obj.SurveyID
			});
			$("#btnAddS").linkbutton("disable");
			$("#btnEditS").linkbutton("enable");
			$("#btnDeleteS").linkbutton("enable");
			$("#btnAddQ").linkbutton("enable");
			$("#btnEditQ").linkbutton("disable");
			$("#btnDeleteQ").linkbutton("disable");
			$("#btnAddO").linkbutton("disable");
			$("#btnEditO").linkbutton("disable");
			$("#btnDeleteO").linkbutton("disable");
		}
	}
	
	//单击题目事件
	obj.gridQuestion_onSelect = function (){
		var rowData = obj.gridQuestion.getSelected();
		if (rowData["BTID"] == obj.QuestionID) {
			obj.QuestionID="";
			obj.gridQuestion.clearSelections();
			obj.gridOption.loadData([]);
			$("#btnAddQ").linkbutton("enable"); 
			$("#btnEditQ").linkbutton("disable");
			$("#btnDeleteQ").linkbutton("disable");
			$("#btnAddO").linkbutton("disable");
		}
		else {
			obj.QuestionID = rowData["BTID"];
			obj.gridOption.load({
				ClassName:"DHCMA.CPW.BTS.SurveyOptionSrv",
				QueryName:"QryOption",
				aParRef:obj.QuestionID
			});
			$("#btnAddQ").linkbutton("disable");
			$("#btnEditQ").linkbutton("enable");
			$("#btnDeleteQ").linkbutton("enable");
			$("#btnAddO").linkbutton("enable");
		}
	}
	//单击题目选项事件
	obj.gridOption_onSelect = function (){
		var rowData = obj.gridOption.getSelected();
		if (rowData["BTID"] == obj.OptionID) {
			obj.OptionID="";
			obj.gridOption.clearSelections();
			$("#btnAddO").linkbutton("enable"); 
			$("#btnEditO").linkbutton("disable");
			$("#btnDeleteO").linkbutton("disable");
		}
		else {
			obj.OptionID = rowData["BTID"];
			$("#btnAddO").linkbutton("disable");
			$("#btnEditO").linkbutton("enable");
			$("#btnDeleteO").linkbutton("enable");
		}
	}
	//保存标题
	obj.btnSaveS_click = function(){
		var errinfo = "";
		var Code = $('#Code').val();
		var Title = $('#Title').val();
		var Resume = $('#Resume').val();
		 if (!Code){
		    var errinfo = errinfo +  "请填写问卷代码!<br>";
		}
		if (!Title) {
			var errinfo = errinfo +  "请填写问卷标题!<br>";
		}
		var IsCheck = $m({
			ClassName:"DHCMA.CPW.BT.Survey",
			MethodName:"CheckSQCode",
			aCode:Code,
			aID:obj.SurveyID
		},false);
	  	if(IsCheck>=1) {
	  		errinfo = errinfo + "代码与列表中现有项目重复，请检查修改!<br>";
	  	}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var inputStr = obj.SurveyID;
		inputStr = inputStr + "^" + Code;
		inputStr = inputStr + "^" + Title;
		inputStr = inputStr + "^" + Resume		
		var TRet=$m({
			ClassName :"DHCMA.CPW.BT.Survey",
			MethodName:"Update",
			aInputStr :inputStr,
			aSeparete:"^",
			aHospID:$("#cboSSHosp").combobox('getValue')
		},false)
		if (parseInt(TRet)>0) {
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			$HUI.dialog('#winSurvey').close()
			obj.gridSurvey.reload();
			//刷新值域列表，清空字典信息
		}else{
			$.messager.alert("错误提示", "更新数据错误!Error=" + TRet, 'info');
		}
	}
	//保存题目
	obj.btnSaveQ_click = function(){
		var errinfo = "";
		var ItemNo = $('#ItemNo').val();
		var ItemDesc = $('#ItemDesc').val();
		var ItemType = $('#ItemType').combobox('getValue')
		var ItemScore = $('#ItemScore').val();
		var ItemResume = $('#ItemResume').val();
		 if (!ItemNo){
		    var errinfo = errinfo +  "请填写题目序号!<br>";
		}
		if (!ItemDesc) {
			var errinfo = errinfo +  "请填写题目描述!<br>";
		}
		if (!ItemType) {
			var errinfo = errinfo +  "请填写题目类型!<br>";
		}
		var IsCheck = $m({
			ClassName:"DHCMA.CPW.BT.SurveyQuestion",
			MethodName:"CheckSQItemNo",
			aItem:ItemNo,
			Parref:obj.SurveyID
		},false);
	  	if((!obj.QuestionID)&&(ItemNo)&&(IsCheck>=1)) {
	  		errinfo = errinfo + "序号与列表中现有序号重复，请检查修改!<br>";
	  	}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var inputStr = obj.SurveyID;
		inputStr = inputStr + "^" + obj.QuestionID;
		inputStr = inputStr + "^" + ItemNo;
		inputStr = inputStr + "^" + ItemDesc;
		inputStr = inputStr + "^" + ItemType;
		inputStr = inputStr + "^" + ItemScore;
		inputStr = inputStr + "^" + ItemResume;		
		var TRet=$m({
			ClassName :"DHCMA.CPW.BT.SurveyQuestion",
			MethodName:"Update",
			aInputStr :inputStr,
			aSeparete:"^"
		},false)
		if (parseInt(TRet)>0) {
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			$HUI.dialog('#winQuestion').close()
			obj.gridQuestion.reload();
			//刷新值域列表，清空字典信息
		}else{
			$.messager.alert("错误提示", "更新数据错误!Error=" + TRet, 'info');
		}
	}
	//保存题目选项
	obj.btnSaveO_click = function(){
		var errinfo = "";
		var OptionNo = $('#OptionNo').val();
		var OptionDesc = $('#OptionDesc').val();
		var OptionScore = $('#OptionScore').val();
		 if (!OptionNo){
		    var errinfo = errinfo +  "请填写选项序号!<br>";
		}
		if (!OptionDesc) {
			var errinfo = errinfo +  "请填写选项描述!<br>";
		}
		if (!OptionScore) {
			var errinfo = errinfo +  "请填写分值!<br>";
		}
		var IsCheck = $m({
			ClassName:"DHCMA.CPW.BT.SurveyOption",
			MethodName:"CheckSQOptionNo",
			aOptionNo:OptionNo,
			Parrer:obj.QuestionID
		},false);
	  	if((!obj.OptionID)&&(OptionNo)&&(IsCheck>=1)) {
	  		errinfo = errinfo + "序号与列表中现有序号重复，请检查修改!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var inputStr = obj.QuestionID;
		inputStr = inputStr + "^" + obj.OptionID;
		inputStr = inputStr + "^" + OptionNo;
		inputStr = inputStr + "^" + OptionDesc;
		inputStr = inputStr + "^" + OptionScore		
		var TRet=$m({
			ClassName :"DHCMA.CPW.BT.SurveyOption",
			MethodName:"Update",
			aInputStr :inputStr,
			aSeparete:"^"
		},false)
		if (parseInt(TRet)>0) {
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			$HUI.dialog('#winOption').close()
			obj.gridOption.reload();
			//刷新值域列表，清空字典信息
		}else{
			$.messager.alert("错误提示", "更新数据错误!Error=" + TRet, 'info');
		}
	}
	//删除标题
	obj.btnDeleteS_click = function(){
		if (obj.SurveyID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCMA.CPW.BT.Survey",
					MethodName:"DeleteById",
					aId:obj.SurveyID,
					aHospID:$("#cboSSHosp").combobox('getValue')
				},false);
				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');					
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.SurveyID = ""
					obj.gridSurvey.reload() ;//刷新当前页
				}
			} 
		});
	}
	//删除题目
	obj.btnDeleteQ_click = function(){
		if (obj.QuestionID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCMA.CPW.BT.SurveyQuestion",
					MethodName:"DeleteById",
					aId:obj.QuestionID
				},false);
				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');					
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.QuestionID = ""
					obj.gridQuestion.reload() ;//刷新当前页
				}
			} 
		});
	}
	//删除题目选项
	obj.btnDeleteO_click = function(){
		if (obj.OptionID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCMA.CPW.BT.SurveyOption",
					MethodName:"DeleteById",
					aId:obj.OptionID
				},false);
				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');					
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.OptionID = ""
					obj.gridOption.reload() ;//刷新当前页
				}
			} 
		});
	}
	//配置窗体-初始化
	obj.Slayer= function(rd){
		if(rd){
			obj.SurveyID = rd["BTID"];
			var Code = rd["BTCode"];
			var Title = rd["BTTitle"];
			var Resume = rd["BTResume"];
			$('#Code').val(Code);
			$('#Title').val(Title);
			$('#Resume').val(Resume);
		}else{
			obj.SurveyID = "";
			$('#Code').val('');
			$('#Title').val('');
			$('#Resume').val('');
		}
		var left=$("#btnEditS").offset().left+5;
		$HUI.dialog('#winSurvey').open().window("move",{left:left});
	}
	obj.Qlayer= function(rd){
		if(rd){
			obj.QuestionID 	 = rd["BTID"];
			var ItemNo 		 = rd["BTItemNo"];
			var ItemDesc 	 = rd["BTItemDesc"];
			var ItemTypeID   = rd["BTItemTypeID"];
			var ItemTypeDesc = rd["BTItemTypeDesc"];
			var ItemScore 	 = rd["BTItemScore"];
			var ItemResume 	 = rd["BTItemResume"];
			$('#ItemNo').val(ItemNo);
			$('#ItemDesc').val(ItemDesc);
		
			$('#ItemType').combobox('setValue',ItemTypeID)
			$('#ItemType').combobox('setText',ItemTypeDesc)
			$('#ItemScore').val(ItemScore);
			$('#ItemResume').val(ItemResume);
		}else{
			obj.QuestionID = "";
			$('#ItemNo').val('');
			$('#ItemDesc').val('');
			$('#ItemType').combobox('setValue',"")
			$('#ItemScore').val('');
			$('#ItemResume').val('');
		}
		var top=$("#btnEditQ").offset().top+5;
		$HUI.dialog('#winQuestion').open().window("move",{top:top});
	}	
	obj.Olayer= function(rd){
		if(rd){
			obj.OptionID 	 = rd["BTID"];
			var OptionNo 	 = rd["BTOptionNo"];
			var OptionDesc 	 = rd["BTOptionDesc"];
			var OptionScore  = rd["BTOptionScore"];
			$('#OptionNo').val(OptionNo);
			$('#OptionDesc').val(OptionDesc);
			$('#OptionScore').val(OptionScore);
		}else{
			obj.OptionID = "";
			$('#OptionNo').val('');
			$('#OptionDesc').val('');
			$('#OptionScore').val('');
		}
		
		$HUI.dialog('#winOption').open();
	}
	// Code和就诊号应该是传
	/*obj.ShowSurvey = function () {
		var strUrl= "./dhcma.cpw.bt.survey.csp?1=1&Code=" + "SurQuestion" + "&EpisodeID=" + "142" ;
	    websys_showModal({
			url:strUrl,
			title:'问卷',
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:true,
			width:1150,
			height:'90%'  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
		});
	}*/
}