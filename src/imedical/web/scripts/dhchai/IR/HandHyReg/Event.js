//页面Event
function InitHandHyRegWinEvent(obj){
	CheckSpecificKey();
	obj.HandRegID="";
	
	$("#btnDelete").addClass('disabled');
	
	$("#cboObsLoc").change(function(){
		setTimeout( function () {
			refreshHandHyReg();
		}, 200);
	});
	$("#cboHospital").change(function(){
		setTimeout( function () {
			refreshHandHyReg();
		}, 200);
	});
	$("#cboObsPage").change(function(){
		refreshHandHyReg();
	});
	$("#ObsDate").change(function(){
		refreshHandHyReg();
	});
	
	$("#btnEdit").on('click', function(){
		
		var HospitalDr = $.form.GetValue("cboHospital");
		var ObsLocDr   = $.form.GetValue("cboObsLoc");
		var ObsPage    = $.form.GetValue("cboObsPage");
		var ObsDate    = $.form.GetValue("ObsDate");
		var ObsUser    = $.form.GetValue("txtObsUser");
		var ObsNumber1    = $.form.GetValue("ObsNumber1");
		var ObsNumber2    = $.form.GetValue("ObsNumber2");
		var ObsNumber3    = $.form.GetValue("ObsNumber3");
		var ObsNumber4    = $.form.GetValue("ObsNumber4");
		var ErrorStr = "";
		if (ObsLocDr == '') {
			ErrorStr += '调查病区不允许为空!<br/>';
		}
		if (ObsPage == '') {
			ErrorStr += '调查页不允许为空!<br/>';
		}
		if (ObsDate == '') {
			ErrorStr += '调查月份不允许为空!<br/>';
		}
		if (ObsUser == '') {
			ErrorStr += '调查人不允许为空!<br/>';
		}
		if (ObsNumber1 == '') {
			ErrorStr += '医生调查人数不允许为空!<br/>';
		}
		if (ObsNumber2 == '') {
			ErrorStr += '护士调查人数不允许为空!<br/>';
		}
		if (ObsNumber3 == '') {
			ErrorStr += '护理员调查人数不允许为空!<br/>';
		}
		if (ObsNumber4 == '') {
			ErrorStr += '卫生员调查人数不允许为空!<br/>';
		}
		if (ErrorStr != '') {
			layer.alert(ErrorStr,{icon: 0});
			return ;
		}
		var arrResult = new Array();
		var rows = obj.gridHandHyReg.rows().data().toArray();
		for (var row = 0; row < rows.length; row++){
			var rd = rows[row];
			
			var val = getItemValues(rd['Cmp1']);
			var texts = getItemTexts(rd['Cmp1']);
			if (!((val.indexOf("I1")<0)&&(val.indexOf("I2")<0))){
				if ((val.indexOf("I1")<0)||(val.indexOf("I2")<0)){
					layer.alert("第"+(row+1)+"行第2、3列,请选择指征和手卫生行为,否则系统作为无效记录!",{icon: 0});
					return ;
				}
			}
			if (((","+texts+",").indexOf(",病人后,")>=0)&&((","+texts+",").indexOf(",环境后,")>=0)) {
				layer.alert("第"+(row+1)+"行第2列,病人后、环境后不可同时选择!",{icon: 0});
				return ;
			}
			if (((","+texts+",").indexOf(",无,")>=0)&&((","+texts+",").indexOf(",正确,")>=0)) {
				layer.alert("第"+(row+1)+"行第3列,无、正确不可同时选择!",{icon: 0});
				return ;
			}
			if ((val.indexOf("I1")>=0)&&(val.indexOf("I2")>=0)){
				arrResult.push(val);
			}
			
			var val = getItemValues(rd['Cmp2']);
			var texts = getItemTexts(rd['Cmp2']);
			if (!((val.indexOf("I1")<0)&&(val.indexOf("I2")<0))){
				if ((val.indexOf("I1")<0)||(val.indexOf("I2")<0)){
					layer.alert("第"+(row+1)+"行第5、6列,请选择指征和手卫生行为,否则系统作为无效记录!",{icon: 0});
					return ;
				}
			}
			if (((","+texts+",").indexOf(",病人后,")>=0)&&((","+texts+",").indexOf(",环境后,")>=0)) {
				layer.alert("第"+(row+1)+"行第5列,病人后、环境后不可同时选择!",{icon: 0});
				return ;
			}
			if (((","+texts+",").indexOf(",无,")>=0)&&((","+texts+",").indexOf(",正确,")>=0)) {
				layer.alert("第"+(row+1)+"行第6列,无、正确不可同时选择!",{icon: 0});
				return ;
			}
			if ((val.indexOf("I1")>=0)&&(val.indexOf("I2")>=0)){
				arrResult.push(val);
			}
			
			var val = getItemValues(rd['Cmp3']);
			var texts = getItemTexts(rd['Cmp3']);
			if (!((val.indexOf("I1")<0)&&(val.indexOf("I2")<0))){
				if ((val.indexOf("I1")<0)||(val.indexOf("I2")<0)){
					layer.alert("第"+(row+1)+"行第8、9列,请选择指征和手卫生行为,否则系统作为无效记录!",{icon: 0});
					return ;
				}
			}
			if (((","+texts+",").indexOf(",病人后,")>=0)&&((","+texts+",").indexOf(",环境后,")>=0)) {
				layer.alert("第"+(row+1)+"行第8列,病人后、环境后不可同时选择!",{icon: 0});
				return ;
			}
			if (((","+texts+",").indexOf(",无,")>=0)&&((","+texts+",").indexOf(",正确,")>=0)) {
				layer.alert("第"+(row+1)+"行第9列无、正确不可同时选择!",{icon: 0});
				return ;
			}
			if ((val.indexOf("I1")>=0)&&(val.indexOf("I2")>=0)){
				arrResult.push(val);
			}
			
			var val = getItemValues(rd['Cmp4']);
			var texts = getItemTexts(rd['Cmp4']);
			if (!((val.indexOf("I1")<0)&&(val.indexOf("I2")<0))){
				if ((val.indexOf("I1")<0)||(val.indexOf("I2")<0)){
					layer.alert("第"+(row+1)+"行第11、12列,请选择指征和手卫生行为,否则系统作为无效记录!",{icon: 0});
					return ;
				}
			}
			if (((","+texts+",").indexOf(",病人后,")>=0)&&((","+texts+",").indexOf(",环境后,")>=0)) {
				layer.alert("第"+(row+1)+"行第11列,病人后、环境后不可同时选择!",{icon: 0});
				return ;
			}
			if (((","+texts+",").indexOf(",无,")>=0)&&((","+texts+",").indexOf(",正确,")>=0)) {
				layer.alert("第"+(row+1)+"行第12列,无、正确不可同时选择!",{icon: 0});
				return ;
			}
			if ((val.indexOf("I1")>=0)&&(val.indexOf("I2")>=0)){
				arrResult.push(val);
			}
			
			var val = getItemValues(rd['Cmp5']);
			var texts = getItemTexts(rd['Cmp5']);
			if (!((val.indexOf("I1")<0)&&(val.indexOf("I2")<0))){
				if ((val.indexOf("I1")<0)||(val.indexOf("I2")<0)){
					layer.alert("第"+(row+1)+"行第14、15列,请选择指征和手卫生行为,否则系统作为无效记录!",{icon: 0});
					return ;
				}
			}
			if (((","+texts+",").indexOf(",病人后,")>=0)&&((","+texts+",").indexOf(",环境后,")>=0)) {
				layer.alert("第"+(row+1)+"行第14列,病人后、环境后不可同时选择!",{icon: 0});
				return ;
			}
			if (((","+texts+",").indexOf(",无,")>=0)&&((","+texts+",").indexOf(",正确,")>=0)) {
				layer.alert("第"+(row+1)+"行第15列,无、正确不可同时选择!",{icon: 0});
				return ;
			}
			if ((val.indexOf("I1")>=0)&&(val.indexOf("I2")>=0)){
				arrResult.push(val);
			}
			
			var val = getItemValues(rd['Cmp6']);
			var texts = getItemTexts(rd['Cmp6']);
			if (!((val.indexOf("I1")<0)&&(val.indexOf("I2")<0))){
				if ((val.indexOf("I1")<0)||(val.indexOf("I2")<0)){
					layer.alert("第"+(row+1)+"行第17、18列,请选择指征和手卫生行为,否则系统作为无效记录!",{icon: 0});
					return ;
				}
			}
			if (((","+texts+",").indexOf(",病人后,")>=0)&&((","+texts+",").indexOf(",环境后,")>=0)) {
				layer.alert("第"+(row+1)+"行第17列,病人后、环境后不可同时选择!",{icon: 0});
				return ;
			}
			if (((","+texts+",").indexOf(",无,")>=0)&&((","+texts+",").indexOf(",正确,")>=0)) {
				layer.alert("第"+(row+1)+"行第18列,无、正确不可同时选择!",{icon: 0});
				return ;
			}
			if ((val.indexOf("I1")>=0)&&(val.indexOf("I2")>=0)){
				arrResult.push(val);
			}
		}
		var HandHyRegTim = arrResult.join('#');
		if (HandHyRegTim==""){
			layer.alert('手卫生调查信息为空!',{icon: 0});
			return;
		}
		// 手卫生调查人数
		var HandHyRegCnt = "A,"+ObsNumber1+"#B,"+ObsNumber2+"#C,"+ObsNumber3+"#D,"+ObsNumber4;
		var InputStr = obj.HandRegID;
		InputStr += "^" + ObsLocDr;        // 调查科室病区
		InputStr += "^" + ObsPage;         // 调查第几页
		InputStr += "^" + ObsDate;         // 调查月份
		InputStr += "^" + ObsUser;         // 调查人
		InputStr += "^" + "1";             // 是否有效
		InputStr += "^" + "";              // 登记日期
		InputStr += "^" + "";              // 登记时间
		InputStr += "^" + $.LOGON.USERID;  // 登记人
		
		var flg = $.Tool.RunServerMethod("DHCHAI.IRS.HandHyRegSrv","SaveHandHyReg",InputStr,HandHyRegTim,HandHyRegCnt);
		if (parseInt(flg)<0){
				if (parseInt(flg)=="-101"){
					layer.msg('手卫生报告信息保存失败!',{icon: 2});
				}else if (parseInt(flg)=="-102"){
					layer.msg('手卫生调查时机信息保存失败!',{icon: 2});
				}else if (parseInt(flg)=="-103"){
					layer.msg('手卫生调查人数信息保存失败!',{icon: 2});
				}else{
					layer.msg('保存失败!',{icon: 2});
				}
			} else {
				obj.HandRegID=parseInt(flg);
				$("#btnDelete").removeClass('disabled');
				obj.gridHandHyReg.ajax.reload();
				setTimeout( function () {
					layer.msg('保存成功!',{icon: 1});
				}, 400);
				
			}
		$("#btnEdit").blur();
	});
	
	$("#btnDelete").on('click', function(){
		var flag = $("#btnDelete").hasClass("disabled");
		if(flag) return ;
		
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){ 
			var flg = $.Tool.RunServerMethod("DHCHAI.IR.HandHyReg","DeleteById",obj.HandRegID);
			if (parseInt(flg)<0){
				layer.msg('删除失败!',{icon: 2});
			} else {
				$("#btnDelete").addClass('disabled');
				obj.HandRegID="";
				obj.gridHandHyReg.ajax.reload();
				layer.msg('删除成功!',{icon: 1});
			}
		});
		$("#btnEdit").blur();
	});
	
	function refreshHandHyReg(){
		$("#gridHandHyReg_processing").css("margin-top","30px");
		$(".tab-content tbody").html("");
		obj.gridHandHyReg.ajax.reload(function(){
			var ObsLocDr   = $.form.GetValue("cboObsLoc");
			var ObsPage    = $.form.GetValue("cboObsPage");
			var ObsDate    = $.form.GetValue("ObsDate");
			var flg=$.Tool.RunServerMethod("DHCHAI.IR.HandHyReg","GetIDByLocDate",ObsLocDr,ObsDate,ObsPage);
			if (parseInt(flg)>0){
				obj.HandRegID=parseInt(flg);
				$("#btnDelete").removeClass('disabled');
				var Number1=$.Tool.RunServerMethod("DHCHAI.IR.HandHyRegCnt","GetCntByType",obj.HandRegID,"A");
				$.form.SetValue("ObsNumber1",Number1);
				var Number2=$.Tool.RunServerMethod("DHCHAI.IR.HandHyRegCnt","GetCntByType",obj.HandRegID,"B");
				$.form.SetValue("ObsNumber2",Number2);
				var Number3=$.Tool.RunServerMethod("DHCHAI.IR.HandHyRegCnt","GetCntByType",obj.HandRegID,"C");
				$.form.SetValue("ObsNumber3",Number3);
				var Number4=$.Tool.RunServerMethod("DHCHAI.IR.HandHyRegCnt","GetCntByType",obj.HandRegID,"D");
				$.form.SetValue("ObsNumber4",Number4);
			} else {
				obj.HandRegID="";
				$.form.SetValue("ObsNumber1","");
				$.form.SetValue("ObsNumber2","");
				$.form.SetValue("ObsNumber3","");
				$.form.SetValue("ObsNumber4","");
				$("#btnDelete").addClass('disabled');
			}
		},false);
	}
	
	function getItemValues(cmp)
	{
		var str="";
		if (cmp==""){
			return str;
		}
		var cmpArr=$('ul#' + cmp + ' li :checkbox');
		for (var num = 0; num < cmpArr.length; num++){
			if (cmpArr[num].checked){
				str = str + ',' + cmpArr[num].id;
			}
		}
		var cmpArr=$('ul#' + cmp + ' li :radio');
		for (var num = 0; num < cmpArr.length; num++){
			if (cmpArr[num].checked){
				str = str + ',' + cmpArr[num].id;
			}
		}
		if (str!=""){
			var str = str.substring(1);
		}
		return str;
	}
	
	function getItemTexts(cmp)
	{
		var str="";
		if (cmp==""){
			return str;
		}
		$('ul#' + cmp).find("li").each(function() {
			if ($(this).find("input")[0].checked) {
				str = str + ',' + $.trim($(this).text());
			}
		});
		
		if (str!=""){
			var str = str.substring(1);
		}
		return str;
	}
}