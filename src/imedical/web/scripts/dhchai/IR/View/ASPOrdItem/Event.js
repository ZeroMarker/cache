//页面Event
function InitASPOrdItemWinEvent(obj){
	$.form.iCheckRender();
	
	if (PowerType==1) {
		$('#PharExperNav li a[href="#ExperMethods"]').tab('show');
	}
	
	//点击选中
	obj.gridViewDetail.on('select', function(e, dt, type, indexes) {
		if ($("#OEOrd_"+indexes[0]).prop("checked")){
			$("#OEOrd_"+indexes[0]).prop("checked", false);
		}else{
			$("#OEOrd_"+indexes[0]).prop("checked", true);
		}
	});
	obj.gridViewDetail.on('deselect', function(e, dt, type, indexes) {
		$("#OEOrd_"+indexes[0]).prop("checked", false);
	});
	
	$('#cboRuleAnti').on('change', function(){
		if (this.value){
			obj.gridViewDetail.search(this.options[this.options.selectedIndex].text).draw();
		}else{
			obj.gridViewDetail.search("").draw();
		}
	});
	//按钮
	$("#PharMethodBtn a,#ExperMethodBtn a").on("click", function(){
		//取消点击
		if ($(this).hasClass("layui-layer-btn0")) {
			$(this).removeClass("layui-layer-btn0"); //样式
			$(".tab-page").css("display","none"); //页面
			obj.CheckResult = -1; //数据
		} else {
			//点击
			if ($(this).parent().attr("id") == "PharMethodBtn") {
				$("#PharMethodBtn a").each(function(){
					if ($(this).hasClass("layui-layer-btn0")) {
						$(this).removeClass("layui-layer-btn0");
						$(this).addClass("layui-layer-btn1");
					}
				});
			}
			if ($(this).parent().attr("id") == "ExperMethodBtn") {
				$("#ExperMethodBtn a").each(function(){
					if ($(this).hasClass("layui-layer-btn0")) {
						$(this).removeClass("layui-layer-btn0");
						$(this).addClass("layui-layer-btn1");
					}
				});
			}
			$(this).addClass("layui-layer-btn0");
			//页面
			var id = $(this).attr("id");
			$(".tab-page").each(function(){
				if ($(this).attr("data-bindBtn") == id){
					$(this).css("display","block");
				}else{
					$(this).css("display","none");
				}
			});
			//数据
			if (id.indexOf("outReason") > -1) obj.CheckResult = 0;
			if (id.indexOf("inReason") > -1) obj.CheckResult = 1;
			if (id.indexOf("follow") > -1) obj.CheckResult = 2;
		}
		
	});
	//提交
	$(".btnOpinion").on("click", function(){
		//获取选中的医嘱
		var rd = obj.gridViewDetail.rows({selected: true}).data().toArray();
		if (rd.length < 1) {
			layer.msg('对医嘱评估，请选中至少一条医嘱！',{time: 2000,icon: 2});
			return false;
		}
		if (obj.CheckResult == -1) return;
		
		var isPhar=0; //专家评估时，是否药师评估
		var AntiIDs="",OEOrdIds="";
		for (var i=0; i<rd.length; i++){
			AntiIDs += "|" + rd[i].AntiMastID;
			OEOrdIds += "|" + rd[i].ID;
			if (rd[i].PharOpinion == '未处置') isPhar=1;
		}
		AntiIDs = AntiIDs.substr(1);
		OEOrdIds = OEOrdIds.substr(1);
		
		//获取处置方案
		var methods = getMethods();
		if (!methods) return;
		var methodArr = methods.split("#");
		var CheckType = methodArr[0]; //identity
		var codeList = methodArr[1];
		var textDesc = methodArr[2];
		
		if ((CheckType == 2 )&&(isPhar == 1)) {
			layer.msg('评估的医嘱必须已经经过药师初步处置！',{time: 2000,icon: 2});
			return false;
		}
		
		var InputStr = PaadmID;
		//InputStr += "^" + PaadmID;
		InputStr += "^" + CheckType;
		InputStr += "^" + obj.CheckResult;
		InputStr += "^" + "";
		InputStr += "^" + "";
		InputStr += "^" + $.LOGON.USERID;
		
		InputStr += "^" + AntiIDs;
		InputStr += "^" + OEOrdIds;
		
		InputStr += "^" + codeList;
		InputStr += "^" + textDesc;
		
		var retval = $.Tool.RunServerMethod('DHCHAI.IRS.ASPOrdItemSrv','UpdateAsp',InputStr, "^");
		if (parseInt(retval)>0){
			layer.msg('保存成功!',{icon: 1});
		} else {
			layer.msg('保存失败!',{icon: 2});
		}
	});
	
	//获取处置方案
	function getMethods(){
		var identity = "";
		$("#PharExperNav li").each(function() {
			if ($(this).hasClass("active")) {
				identity = $(this).find("a").attr("href");
				return false; //break
			}
		});
		if (identity == "") return;
		identity = (identity=="#PharMethods") ? 1 : 2; //身份信息
		
		var idenDesc = (identity == 1) ? "Phar" : "Exper";
		if (obj.CheckResult == "0") {
			var CheckResult = "outReason";
		} else if (obj.CheckResult == "1") {
			var CheckResult = "inReason";
		} else {
			var CheckResult = "follow";
		}
		var codeList="",textDesc="";
		for (var i=0; i<obj.MethodCodes[CheckResult].CodeList.length; i++) {
			var DicCode = obj.MethodCodes[CheckResult].CodeList[i];
			var textcontent = $.trim($.form.GetValue(idenDesc + "-" + CheckResult + "-text-" + DicCode));
			if ((textcontent == "")||(textcontent == 0))  continue;
			codeList += "|" + DicCode;
			textDesc += "|" + textcontent;
		}
		codeList = codeList.substr(1);
		textDesc = textDesc.substr(1);
		if (( CheckResult !="inReason" )&&(textDesc == "")) {
			layer.msg('请填写评估意见！',{time: 2000,icon: 2});
			return false;
		}
		return identity +"#"+ codeList +"#"+ textDesc;
	}
	
	$('#gridViewDetail').on('click','a.Program', function (e) {
	    e.preventDefault();
		var tr = $(this).closest('tr');
		var row = obj.gridViewDetail.row(tr);
		var rowData = row.data();
		
		var idenDesc = ($(this).attr("data-type") == 0) ? "PharProID" : "ExperProID";
		
		obj.gridViewDetail.rows().data().each(function(val ,item) {
			if ((rowData[idenDesc] == val[idenDesc]) && (rowData.ID != val.ID)) {
				obj.gridViewDetail.rows(':eq('+item+')').select();
			} else {
				obj.gridViewDetail.rows(':eq('+item+')').deselect();
			}
		});
		if ($(this).attr("data-type") == 0) {
			$('#PharExperNav li a[href="#PharMethods"]').tab('show');
		} else {
			$('#PharExperNav li a[href="#ExperMethods"]').tab('show');
		}
		getAllOpinion(rowData[idenDesc]);
    });
	
	function getAllOpinion(ProgramID){
		removeAllMethod();
		var retval = $.Tool.RunServerMethod('DHCHAI.IRS.ASPOrdItemSrv','getAllOpinion',ProgramID);
		var retArr=retval.split("#");
		var ProgramInfo = retArr[0];
		var OrdItemInfo = retArr[1];
		var OpinionInfo = retArr[2];
		
		var CheckType	= ProgramInfo.split("^")[1];
		var CheckResult	= ProgramInfo.split("^")[2];
		var CheckDate	= ProgramInfo.split("^")[3];
		var CheckTime	= ProgramInfo.split("^")[4];
		var CheckUserDesc	= ProgramInfo.split("^")[5];
		
		var idenDesc = (CheckType == 1) ? "Phar" : "Exper";
		if (CheckResult == "0") {
			var CheckResult = "outReason";
		} else if (CheckResult == "1") {
			var CheckResult = "inReason";
		} else {
			var CheckResult = "follow";
		}
		//模拟点击按钮
		if (!$("#" + idenDesc + CheckResult + "Btn").hasClass("layui-layer-btn0")) {
			$("#" + idenDesc + CheckResult + "Btn").click();
		}
		
		var OrdItemArr = OrdItemInfo.split("|");
		
		var OpinionArr = OpinionInfo.split("|");
		for (var i=0; i<OpinionArr.length; i++){
			var DicID 		= OpinionArr[i].split("^")[0];
			var DicCode		= OpinionArr[i].split("^")[1];
			var OpinionTxt	= OpinionArr[i].split("^")[2];
			//对评估方案赋值
			$.form.SetValue(idenDesc + "-" + CheckResult + "-text-" + DicCode, OpinionTxt);
		}
		return true;
	}
	
	function removeAllMethod() {
		var idenDesc = ["Phar", "Exper"];
		var CheckResult = ["inReason", "outReason", "follow"];
		for (var i=0; i<idenDesc.length; i++) {
			for (var j=0; j<CheckResult.length; j++) {
				console.log(idenDesc[i]+"-"+CheckResult[j]);
				console.log(obj.MethodCodes[CheckResult[j]].CodeList);
				for (var k=0; k<obj.MethodCodes[CheckResult[j]].CodeList.length; k++) {
					var DicCode = obj.MethodCodes[CheckResult[j]].CodeList[k];
					if (typeof DicCode == 'undefined') continue;
					var id = idenDesc[i] + "-" + CheckResult[j] + "-text-" + DicCode;
					$.form.SetValue(id, "");
				}
			}
			
		}
	}
	
}